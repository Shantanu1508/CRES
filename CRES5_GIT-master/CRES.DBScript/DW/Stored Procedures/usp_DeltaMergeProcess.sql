

CREATE PROCEDURE  [DW].[usp_DeltaMergeProcess]
	@BatchLogId int
AS
BEGIN
	SET NOCOUNT ON


	Print('usp_DeltaMergeProcess - BatchLogId = '+cast(@BatchLogId  as varchar(100)));

	UPDATE [DW].BatchLog
	SET Status = 'MERGING'
	WHERE BatchLogId = @BatchLogId
	
	
	EXEC [DW].usp_MergeDeal @BatchLogId
	EXEC [DW].usp_MergeNote @BatchLogId
	
	--EXEC [DW].usp_MergeTransaction @BatchLogId
	--EXEC [DW].usp_MergeDailyCalc @BatchLogId
	
	EXEC [DW].usp_MergeTransactionEntry @BatchLogId
	EXEC [DW].usp_MergeNotePeriodicCalc @BatchLogId

	EXEC [DW].usp_MergeExceptionsBI @BatchLogId
	

	--EXEC [DW].[usp_MergeNoteFunding] @BatchLogId
	--EXEC [DW].[usp_MergeBSNoteFunding] @BatchLogId

	EXEC [DW].[usp_MergeDealFundingSchdule] @BatchLogId
	EXEC [DW].[usp_MergeNoteFundingSchedule] @BatchLogId

	--EXEC [DW].[usp_MergeBackshopCurrentBalance] @BatchLogId
	EXEC [DW].[usp_MergeFundingSequences] @BatchLogId

	EXEC [DW].[usp_MergeWorkFlow] @BatchLogId

	EXEC [DW].[usp_MergeInterestCalculator] @BatchLogId

	EXEC [DW].[usp_MergeWFTaskDetail] @BatchLogId
	
	EXEC [DW].[usp_MergeWFCheckListDetail] @BatchLogId

	EXEC [DW].[usp_MergeDailyInterestAccruals] @BatchLogId

	EXEC [DW].[usp_MergeNoteTransactionDetail] @BatchLogId

	EXEC [DW].[usp_MergeProperty] @BatchLogId

	EXEC [DW].[usp_MergeRateSpreadSchedule] @BatchLogId
	
	EXEC [DW].[usp_MergeNoteTranchePercentage] @BatchLogId
	
	EXEC [DW].[usp_MergeInvoiceDetail] @BatchLogId

	EXEC [DW].[usp_MergeTotalCommitmentData] @BatchLogId

	------from backshop nightly
	--EXEC [DW].usp_MergeUwDeal @BatchLogId
	--EXEC [DW].usp_MergeUwNote @BatchLogId
	--EXEC [DW].usp_MergeUwNoteFunding @BatchLogId
	--EXEC [DW].usp_MergeUwCashflow @BatchLogId
	----------------------------------


	IF @@ERROR <> 0
	BEGIN
		UPDATE [DW].BatchLog
		SET BatchEndTime = GETDATE(),Status = 'FAILURE',ErrorMessage = ERROR_MESSAGE()
		WHERE BatchLogId = @BatchLogId
	END
END


