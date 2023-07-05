CREATE Procedure [dbo].[usp_InsertTransactionEntryCloseArchive]
@AnalysisID UNIQUEIDENTIFIER,
@TagMasterID nvarchar(256)
AS

BEGIN

	SET NOCOUNT ON;
	--trnasferred all transactions to archive table 
   INSERT INTO [CRE].[TransactionEntryCloseArchive]
           ([NoteID]
           ,[Date]
           ,[Amount]
           ,[Type]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
		   ,[TransactionEntryCloseAutoID]
           ,[AnalysisID]
           ,[FeeName]
		   ,[PeriodID]
		   ,[PeriodCloseEnd] 
           ,[TagMasterID]
		   ,StrCreatedBy
		   ,TransactionDateByRule
		   ,TransactionDateServicingLog
		   ,RemitDate)
	Select 
	[NoteID]
           ,[Date]
           ,[Amount]
           ,[Type]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
		   ,[TransactionEntryCloseAutoID]
           ,[AnalysisID]
           ,[FeeName]
		   ,[PeriodID]
		   ,[PeriodCloseEnd] 
           ,[TagMasterID]
		   ,StrCreatedBy
		   ,TransactionDateByRule
		   ,TransactionDateServicingLog
		   ,RemitDate
	FROM cre.TransactionEntryClose 
	Where AnalysisID = @AnalysisID and TagMasterID=@TagMasterID

	--delete from the TransactionEntryClose after transfering all tranasactions in archive table
	delete from cre.TransactionEntryClose where AnalysisID = @AnalysisID and TagMasterID=@TagMasterID
	

END
