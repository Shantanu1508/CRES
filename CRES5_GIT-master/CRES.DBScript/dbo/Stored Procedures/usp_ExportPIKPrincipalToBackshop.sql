CREATE PROCEDURE [dbo].[usp_ExportPIKPrincipalToBackshop] --'5290','admin_qa'  
(  
 @NoteId nvarchar(256),  
 @userName nvarchar(256)  
)  
AS  
BEGIN  
  
DECLARE @query nvarchar(256) = N'Select COUNT(noteid) from [acore].[vw_AcctNote] where Noteid = '''+@NoteId+''''  
DECLARE @NoteCount TABLE (Cnt int,ShardName nvarchar(max))  
INSERT INTO @NoteCount (Cnt,ShardName)  
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceDataFF', @stmt = @query  
  
  
IF ((Select cnt from @NoteCount) > 0) --Check if note exists in backshop database  
BEGIN  
 BEGIN TRY  
    
  exec sp_NoteFundingsDeleteByNoteIdPIK @NoteId  
   
  
  Declare @CRENoteID [nvarchar](256)  
  Declare @FundingDate Date   
  Declare @FundingAmount decimal(28,12)  
  Declare @Comments [nvarchar](MAX)  
  Declare @FundingPurpose [nvarchar](256)  
  Declare @AuditUserName [nvarchar](256)  
  Declare @ExportTimeStamp DATETIME   
  Declare @Status [nvarchar](256)  
  Declare @Applied bit  
  Declare @WireConfirm bit  
  Declare @DrawFundingId [nvarchar](256)  
  Declare @WF_CurrentStatus [nvarchar](256)  
    
  Declare @PIKReasonCode [nvarchar](256)  
  --Declare @PIKComments [nvarchar](max)  
  
    
  IF CURSOR_STATUS('global','CursorPIK')>=-1  
  BEGIN  
   DEALLOCATE CursorPIK  
  END  
  
  DECLARE CursorPIK CURSOR   
  for  
  (  
   Select [CRENoteID]  
   ,[FundingDate]  
   ,[FundingAmount]  
   ,[Comments]  
   ,[FundingPurpose]  
   ,[AuditUserName]  
   ,[ExportTimeStamp]  
   ,[Status]   
   ,[Applied]  
   ,[WireConfirm]   
   ,DrawFundingId   
   ,WF_CurrentStatus   
   ,PIKReasonCode  
   --,PIKComments  
   from [IO].[out_PIKPrincipalFunding] where [CRENoteID] = @NoteId --and [AuditUserName] = @userName  
  )  
  OPEN CursorPIK  
  FETCH NEXT FROM CursorPIK  
  INTO @CRENoteID,@FundingDate,@FundingAmount,@Comments,@FundingPurpose,@AuditUserName,@ExportTimeStamp,@Status,@Applied,@WireConfirm,@DrawFundingId,@WF_CurrentStatus,@PIKReasonCode  
  WHILE @@FETCH_STATUS = 0  
  BEGIN  
     
   exec spNoteFundingsSave -1,@CRENoteID,@Applied,@FundingDate,@FundingAmount,@Comments,@FundingPurpose,@DrawFundingId,NUll,NUll,@WireConfirm,@AuditUserName,@WF_CurrentStatus,@PIKReasonCode,null --generatedby  
     
  FETCH NEXT FROM CursorPIK  
  INTO @CRENoteID,@FundingDate,@FundingAmount,@Comments,@FundingPurpose,@AuditUserName,@ExportTimeStamp,@Status,@Applied,@WireConfirm,@DrawFundingId,@WF_CurrentStatus,@PIKReasonCode  
  END  
  CLOSE CursorPIK     
  DEALLOCATE CursorPIK  
   
  
  UPDATE [IO].[out_PIKPrincipalFunding] set [Status] = 'Exported' where [CRENoteID] = @NoteId ----and [AuditUserName] = @userName  
  
 END TRY  
 BEGIN CATCH  
  UPDATE [IO].[out_PIKPrincipalFunding] set [Status] = 'ExportFailed' where [CRENoteID] = @NoteId ----and [AuditUserName] = @userName  
 END CATCH  
  
  
END  
ELSE  
BEGIN  
 UPDATE [IO].[out_PIKPrincipalFunding] set [Status] = 'Not Exists in [acore].[vw_AcctNote]' where [CRENoteID] = @NoteId ----and [AuditUserName] = @userName  
END  
  
END
GO

