

CREATE PROCEDURE [DW].[usp_MergeTransactionEntry]
@BatchLogId int
AS
BEGIN

SET NOCOUNT ON


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


UPDATE [DW].BatchDetail
	SET
	BITableName = 'TransactionEntryBI',
	BIStartTime = GETDATE()
	WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_TransactionEntryBI'


IF EXISTS(Select top 1 NoteID from [DW].[L_TransactionEntryBI])
BEGIN

	Delete ncBI from [DW].[TransactionEntryBI] ncBI
	inner join 
	(
		Select Distinct NoteID,AnalysisID from [DW].[L_TransactionEntryBI]

	)L on L.Noteid = ncBI.Noteid and ncBI.AnalysisID = L.AnalysisID


	--Delete from [DW].[TransactionEntryBI] where NoteID in (Select Distinct NoteID from [DW].[L_TransactionEntryBI])

	INSERT INTO [DW].[TransactionEntryBI]
		(TransactionEntryID,
		NoteID,
		CRENoteID,
		Date ,
		Amount, 
		Type,
		CreatedBy ,
		CreatedDate, 
		UpdatedBy ,
		UpdatedDate ,
		TransactionEntryAutoID,
		AnalysisID,
		AnalysisName,
		FeeName,
		DealName ,
		CreDealID,
		TransactionDateByRule,
		TransactionDateServicingLog,
		RemitDate,
		PaymentDateNotAdjustedforWorkingDay,
		[PurposeType],
		[Cash_NonCash]
		)
	Select
		tb.TransactionEntryID,
		tb.NoteID,
		n.CRENoteID,
		tb.Date ,
		tb.Amount, 
		tb.Type,
		tb.CreatedBy ,
		tb.CreatedDate, 
		tb.UpdatedBy ,
		tb.UpdatedDate ,
		TransactionEntryAutoID,
		AnalysisID,
		AnalysisName,
		FeeName,
		d.DealName ,
		d.CreDealID,
		tb.TransactionDateByRule,
		tb.TransactionDateServicingLog,
		tb.RemitDate,
		tb.PaymentDateNotAdjustedforWorkingDay,
		tb.[PurposeType],
		tb.[Cash_NonCash]
		From [DW].[L_TransactionEntryBI] tb
		Inner Join [DW].[NoteBI] n on n.NoteID = tb.NoteID
		inner join DW.DealBI d on d.dealid = n.dealid



END


	DECLARE @RowCount int
	SET @RowCount = @@ROWCOUNT



	UPDATE [DW].BatchDetail
	SET
	BIEndTime = GETDATE(),
	BIRecordCount = @RowCount
	WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_TransactionEntryBI'

	Print(char(9) +'usp_MergeTransactionEntry - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

		-----------------------------------------------
	--Truncate table [DW].[L_TransactionEntryBI]
	-----------------------------------------------

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END

