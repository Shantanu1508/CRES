CREATE Procedure [dbo].[usp_CreateAutoTag]  
@AnalysisID UNIQUEIDENTIFIER,  
@TagName nvarchar(256),  
@TagDesc nvarchar(256),  
@UserID NVarchar(255) = null,  
@PortfolioMasterID int = null,  
@BatchCalculationMasterID int = null  
AS  
  
BEGIN  
  
 SET NOCOUNT ON;  
  
Declare @TagMasterID UNIQUEIDENTIFIER;  
  
Declare @ScenarioName nvarchar(256) = (Select [Name] from core.Analysis where AnalysisID = @AnalysisID)  
Declare @L_TagName nvarchar(256) = 'Tag_'+ @TagName +'_'+replace(@ScenarioName,' ','')+'_'+Convert(nvarchar(256),getdate(),101)  
Declare @L_TagDesc nvarchar(256) = @TagDesc --'System generated tag from period close.'  
Declare @PortfoliName nvarchar(255)  
  
IF (@PortfolioMasterID IS NOT NULL)  
BEGIN  
select @PortfoliName = PortfoliName FROM core.PortfolioMaster WHERE PortfolioMasterID = @PortfolioMasterID  
SET @L_TagName = 'Tag_'+ @TagName +'_'+replace(@ScenarioName,' ','')+'_'+replace(@PortfoliName,' ','')+'_'+Convert(nvarchar(256),getdate(),101)  
END  
  
  
DECLARE @newTagMaster  UNIQUEIDENTIFIER;  
DECLARE @tTagMaster TABLE (tTagMasterId UNIQUEIDENTIFIER)  
  
INSERT INTO [CRE].[TagMaster]([TagName],[TagDesc],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],AnalysisID)   
OUTPUT inserted.TagMasterID INTO @tTagMaster(tTagMasterId)  
Values(@L_TagName,@L_TagDesc,@UserID,GETDATE(),@UserID,GETDATE(),@AnalysisID)  
   
SET @TagMasterID = (Select tTagMasterId from @tTagMaster)  
  
  
  
INSERT INTO [CRE].[TransactionEntryClose]  
           ([NoteID]  
           ,[Date]  
           ,[Amount]  
           ,[Type]  
           ,[CreatedBy]  
           ,[CreatedDate]  
           ,[UpdatedBy]  
           ,[UpdatedDate]  
           ,[AnalysisID]  
           ,[FeeName]   
           ,[TagMasterID]  
     ,StrCreatedBy  
     ,TransactionDateByRule  
     ,TransactionDateServicingLog)  
 Select   
 n.[NoteID]  
 ,[Date]  
 ,[Amount]  
 ,[Type]  
 ,@UserID  
 ,GETDATE()  
 ,@UserID  
 ,GETDATE()  
 ,[AnalysisID]  
 ,[FeeName]   
 ,@TagMasterID as [TagMasterID]   
 ,StrCreatedBy  
 ,TransactionDateByRule  
 ,TransactionDateServicingLog  
 FROM cre.TransactionEntry tr   
 Inner join core.account acc on acc.accountid = tr.AccountID   and acc.accounttypeid = 1
 Inner join cre.note n on n.account_accountid = acc.accountid  
 Where AnalysisID = @AnalysisID  
 and acc.accounttypeid = 1 and acc.IsDeleted <> 1
 and ((@BatchCalculationMasterID is not null and n.NoteID in (Select NoteID FROM [Core].BatchCalculationDetail where BatchCalculationMasterID =@BatchCalculationMasterID))  
 or  @BatchCalculationMasterID is null)  
   
  
END
