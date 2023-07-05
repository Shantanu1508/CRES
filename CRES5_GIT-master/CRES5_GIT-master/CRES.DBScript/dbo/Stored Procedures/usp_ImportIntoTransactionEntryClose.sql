CREATE Procedure [dbo].[usp_ImportIntoTransactionEntryClose]
@StartDate Date = null,
@EndDate Date = null,
@PeriodID UNIQUEIDENTIFIER = null,
@UserID NVarchar(255) = null,
@TagMasterID UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
@AnalysisID UNIQUEIDENTIFIER

AS

BEGIN

	SET NOCOUNT ON;



IF(@PeriodID is not null) --Create system generated tag from periodic close
BEGIN


	--Delete from cre.TagMaster where TagMasterID in (Select Distinct TagMasterID FROM [CRE].[TransactionEntryClose] WHERE PeriodID is not null and PeriodID not in (Select Distinct PeriodID from core.[Period] where IsDeleted <> 1 ))
	--DELETE FROM [CRE].[TransactionEntryClose] WHERE PeriodID is not null and PeriodID not in (Select Distinct PeriodID from core.[Period] where IsDeleted <> 1 )
	
	select @AnalysisID = AnalysisID from core.Analysis where Name='Default'

	Declare @ScenarioName nvarchar(256) = (Select [Name] from core.Analysis where AnalysisID = @AnalysisID)
	Declare @TagName nvarchar(256) = 'Tag_'+@ScenarioName+'_'+Convert(nvarchar(256),@EndDate,101)
	Declare @TagDesc nvarchar(256) = 'System generated tag from period close.'
	DECLARE @newTagMaster  UNIQUEIDENTIFIER;
	DECLARE @tTagMaster TABLE (tTagMasterId UNIQUEIDENTIFIER)

	INSERT INTO [CRE].[TagMaster]([TagName],[TagDesc],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],AnalysisID,PeriodID)	
	OUTPUT inserted.TagMasterID INTO @tTagMaster(tTagMasterId)
	Values(@TagName,@TagDesc,@UserID,GETDATE(),@UserID,GETDATE(),@AnalysisID,@PeriodID)
	
	SET @TagMasterID = (Select tTagMasterId from @tTagMaster)
	 
END



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
           ,[PeriodID]
           ,[PeriodCloseEnd]
           ,[TagMasterID]
		   ,StrCreatedBy
		   ,TransactionDateByRule
		   ,TransactionDateServicingLog
		   ,RemitDate
		   ,FeeTypeName
		   ,Comment
		   ,PurposeType
		   ,[Cash_NonCash]
		   )
	Select 
	[NoteID]
	,[Date]
	,[Amount]
	,[Type]
	,@UserID
	,GETDATE()
	,@UserID
	,GETDATE()
	,[AnalysisID]
	,[FeeName]
	,@PeriodID as [PeriodID]
	,@EndDate as [PeriodCloseEnd]
	,@TagMasterID as [TagMasterID]	
	,StrCreatedBy
	,TransactionDateByRule
	,TransactionDateServicingLog
	,RemitDate
	,FeeTypeName
	,Comment
	,PurposeType
	,[Cash_NonCash]
	FROM cre.TransactionEntry 
	Where AnalysisID = @AnalysisID
	

END
