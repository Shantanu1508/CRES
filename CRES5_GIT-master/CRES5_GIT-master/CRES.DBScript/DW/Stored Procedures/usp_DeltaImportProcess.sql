-- Procedure


CREATE PROCEDURE [DW].[usp_DeltaImportProcess]
	@BatchLogId int
AS
BEGIN
	
	SET NOCOUNT ON;
    
	Print(char(9) +'usp_DeltaImportProcess - BatchLogId = '+cast(@BatchLogId  as varchar(100)));
	
	
	DECLARE @LastBatchStartDeal datetime;
	DECLARE @LastBatchStartNote datetime;
	DECLARE @LastBatchStartTran datetime;
	DECLARE @LastBatchStartDailyCalc datetime;

	DECLARE @LastBatchStartTransactionEntry datetime;
	DECLARE @LastBatchStartNotePeriodicCalc datetime;

	DECLARE @LastBatchStartExceptions datetime;

	DECLARE @LastBatchNoteFunding datetime;
	DECLARE @LastBatchStartBSNoteFunding datetime;

	DECLARE @LastBatchStartDealFundingSchdule datetime;
	DECLARE @LastBatchStartNoteFundingSchedule datetime;

	DECLARE @LastBatchStartBackshopCurrentBalance datetime;

	DECLARE @LastBatchStartFundingSequences datetime;
	DECLARE @LastBatchStartWorkFlow datetime;

	DECLARE @LastBatchStartInterestCalculator datetime;
	
	DECLARE @LastBatchStartWFTaskDetail datetime;
	DECLARE @LastBatchStartWFCheckListDetail datetime;
	
	DECLARE @LastBatchStartDailyInterestAccruals datetime;
	DECLARE @LastBatchStartNoteTransactionDetail datetime;
	
	DECLARE @LastBatchStartProperty datetime;
	DECLARE @LastBatchStartRateSpreadSchedule datetime;

	DECLARE @LastBatchStartInvoiceDetail datetime;

	DECLARE @LastBatchStarttotalcomm datetime;

	DECLARE @CurrentBatchStart datetime,@LastBatchId int,@LastBatchStatus varchar(50),@LastFailedBatchId int
	

	------from backshop nightly
	--DECLARE @LastBatchStartUwDeal datetime;
	--DECLARE @LastBatchStartUwNote datetime;
	--DECLARE @LastBatchStartUwNoteFunding datetime;
	--DECLARE @LastBatchStartUwCashflow datetime;
	----------------------------------

	SET @LastBatchId = (SELECT TOP 1 BatchLogId FROM [DW].BatchLog WHERE BatchName = 'Delta Refresh Process' and Status = 'SUCCESS' ORDER BY BatchStartTime DESC)
	SET @LastFailedBatchId = (SELECT TOP 1 BatchLogId FROM [DW].BatchLog 
							WHERE BAtchLogID > @LastBatchId AND BatchLogId < @BatchLogId and BatchName = 'Delta Refresh Process' and Status <> 'SUCCESS' 
							ORDER BY BatchStartTime ASC)


	IF @LastFailedBatchId is null
	BEGIN
		SET @LastBatchStartDeal = (SELECT MAX(UpdatedDate) FROM [DW].[DealBI])
		SET @LastBatchStartNote = (SELECT MAX(UpdatedDate) FROM [DW].[NoteBI])
		
		--SET @LastBatchStartTran = (SELECT MAX(UpdatedDate) FROM [DW].TransactionBI)
		--SET @LastBatchStartDailyCalc = (SELECT MAX(UpdatedDate) FROM [DW].DailyCalcBI)
		
		SET @LastBatchStartTransactionEntry = @LastBatchStartNote --(SELECT MAX(UpdatedDate) FROM [DW].TransactionEntryBI)
		SET @LastBatchStartNotePeriodicCalc = @LastBatchStartNote --(SELECT MAX(UpdatedDate) FROM [DW].NotePeriodicCalcBI)
		SET @LastBatchStartExceptions = (SELECT MAX(UpdatedDate) FROM [DW].ExceptionsBI)

		--SET @LastBatchNoteFunding = (SELECT MAX(AuditUpdateDate) FROM [DW].NoteFundingBI)
		--SET @LastBatchStartBSNoteFunding = (SELECT MAX(AuditUpdateDate) FROM [DW].BSNoteFundingBI)

		SET @LastBatchStartDealFundingSchdule = (SELECT MAX(UpdatedDate) FROM [DW].DealFundingSchduleBI)
		SET @LastBatchStartNoteFundingSchedule = (SELECT MAX(UpdatedDate) FROM [DW].NoteFundingScheduleBI)

		--SET @LastBatchStartBackshopCurrentBalance = (SELECT MAX(ImportDate) FROM [DW].BackshopCurrentBalanceBI)

		SET @LastBatchStartFundingSequences = (SELECT MAX(UpdatedDate) FROM [DW].FundingSequencesBI)
		SET @LastBatchStartWorkFlow  = (SELECT MAX(UpdatedDate) FROM [DW].WorkFlowBI)

		SET @LastBatchStartInterestCalculator = (SELECT MAX(UpdatedDate) FROM [DW].InterestCalculatorBI)
		SET @LastBatchStartWFTaskDetail = (SELECT MAX(UpdatedDate) FROM [DW].[WFTaskDetailBI])
		SET @LastBatchStartWFCheckListDetail = (SELECT MAX(UpdatedDate) FROM [DW].[WFCheckListDetailBI])

		SET @LastBatchStartDailyInterestAccruals = @LastBatchStartNote  --(SELECT MAX(UpdatedDate) FROM [DW].[DailyInterestAccrualsBI])
		SET @LastBatchStartNoteTransactionDetail = (SELECT MAX(UpdatedDate) FROM [DW].[NoteTransactionDetailBI])

		SET @LastBatchStartProperty = (SELECT MAX(UpdatedDate) FROM [DW].[PropertyBI])
		SET @LastBatchStartRateSpreadSchedule = (SELECT MAX(UpdatedDate) FROM [DW].[RateSpreadScheduleBI])
		
		SET @LastBatchStartInvoiceDetail = (SELECT MAX(UpdatedDate) FROM [DW].[InvoiceDetailBI])
		
		set @LastBatchStarttotalcomm = (SELECT MAX(UpdatedDate) FROM [DW].[TotalCommitmentDataBI])

		------from backshop nightly
		--SET @LastBatchStartUwDeal = (SELECT MAX(AuditUpdateDate) FROM [DW].[UwDealBI])
		--SET @LastBatchStartUwNote = (SELECT MAX(AuditUpdateDate) FROM [DW].[UwNoteBI])
		--SET @LastBatchStartUwNoteFunding = (SELECT MAX(AuditUpdateDate) FROM [DW].[UwNoteFundingBI])
		--SET @LastBatchStartUwCashflow = (SELECT MAX(PeriodEndDate) FROM [DW].[UwCashflowBI])
		----------------------------------


	END
	ELSE 
	BEGIN
		SET @LastBatchStartDeal = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_DealBI')
		SET @LastBatchStartNote = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_NoteBI')
		
		--SET @LastBatchStartTran = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_TransactionBI')
		--SET @LastBatchStartDailyCalc = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_DailyCalcBI')
		

		SET @LastBatchStartTransactionEntry = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_TransactionEntryBI')
		SET @LastBatchStartNotePeriodicCalc = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_NotePeriodicCalcBI')
		SET @LastBatchStartExceptions = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_ExceptionsBI')

		--SET @LastBatchNoteFunding = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_NoteFundingBI')
		--SET @LastBatchStartBSNoteFunding = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_BSNoteFundingBI')

		SET @LastBatchStartDealFundingSchdule = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_DealFundingSchduleBI')
		SET @LastBatchStartNoteFundingSchedule = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_NoteFundingScheduleBI')
		
		--SET @LastBatchStartBackshopCurrentBalance = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_BackshopCurrentBalanceBI')
		
		SET @LastBatchStartFundingSequences = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_FundingSequencesBI')
		SET @LastBatchStartWorkFlow = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_WorkFlowBI')

		SET @LastBatchStartInterestCalculator = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_InterestCalculatorBI')
		SET @LastBatchStartWFTaskDetail = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_WFTaskDetailBI')
		SET @LastBatchStartWFCheckListDetail  = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_WFCheckListDetailBI')

		SET @LastBatchStartDailyInterestAccruals  = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_DailyInterestAccrualsBI')
		SET @LastBatchStartNoteTransactionDetail = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_NoteTransactionDetailBI')

		SET @LastBatchStartProperty = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_PropertyBI')
		SET @LastBatchStartRateSpreadSchedule = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_RateSpreadScheduleBI')
		
		SET @LastBatchStartInvoiceDetail = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_InvoiceDetailBI')

		SET @LastBatchStarttotalcomm = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_TotalCommitmentDataBI')

		
		
		------from backshop nightly
		--SET @LastBatchStartUwDeal = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_UwDealBI')
		--SET @LastBatchStartUwNote = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_UwNoteBI')
		--SET @LastBatchStartUwNoteFunding = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_UwNoteFundingBI')
		--SET @LastBatchStartUwCashflow = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_UwCashflowBI')
		----------------------------------
	END

	SET @CurrentBatchStart = (SELECT BatchStartTime FROM [DW].BatchLog WHERE BatchLogId = @BatchLogId)
	
	
	EXEC [DW].usp_ImportDeal @BatchLogId,@LastBatchStartDeal,@CurrentBatchStart
	EXEC [DW].usp_ImportNote @BatchLogId,@LastBatchStartNote,@CurrentBatchStart
	
	--EXEC [DW].usp_ImportTransaction @BatchLogId,@LastBatchStartTran,@CurrentBatchStart
	--EXEC [DW].usp_ImportDailyCalc @BatchLogId,@LastBatchStartDailyCalc,@CurrentBatchStart

	EXEC [DW].usp_ImportTransactionEntry @BatchLogId,@LastBatchStartTran,@CurrentBatchStart
	EXEC [DW].usp_ImportNotePeriodicCalc @BatchLogId,@LastBatchStartDailyCalc,@CurrentBatchStart

	EXEC [DW].usp_ImportExceptionsBI @BatchLogId,@LastBatchStartDailyCalc,@CurrentBatchStart

	--EXEC [DW].usp_ImportNoteFunding @BatchLogId,@LastBatchNoteFunding,@CurrentBatchStart
	--EXEC [DW].usp_ImportBSNoteFunding @BatchLogId,@LastBatchStartBSNoteFunding,@CurrentBatchStart

	EXEC [DW].usp_ImportDealFundingSchdule @BatchLogId,@LastBatchStartDealFundingSchdule,@CurrentBatchStart
	EXEC [DW].usp_ImportNoteFundingSchedule @BatchLogId,@LastBatchStartNoteFundingSchedule,@CurrentBatchStart
	
	--EXEC [DW].usp_ImportBackshopCurrentBalance @BatchLogId,@LastBatchStartBackshopCurrentBalance,@CurrentBatchStart

	EXEC [DW].usp_ImportFundingSequences @BatchLogId,@LastBatchStartFundingSequences,@CurrentBatchStart

	EXEC [DW].usp_ImportWorkFlowData @BatchLogId,@LastBatchStartFundingSequences,@CurrentBatchStart

	EXEC [DW].usp_ImportInterestCalculator @BatchLogId,@LastBatchStartInterestCalculator,@CurrentBatchStart

	EXEC [DW].[usp_ImportWFTaskDetail] @BatchLogId,@LastBatchStartWFTaskDetail,@CurrentBatchStart

	EXEC  [DW].[usp_ImportWFCheckListDetail] @BatchLogId,@LastBatchStartWFCheckListDetail,@CurrentBatchStart

	EXEC  [DW].[usp_ImportDailyInterestAccruals] @BatchLogId,@LastBatchStartDailyInterestAccruals,@CurrentBatchStart

	EXEC  [DW].[usp_ImportNoteTransactionDetail] @BatchLogId,@LastBatchStartNoteTransactionDetail,@CurrentBatchStart

	EXEC  [DW].[usp_ImportProperty] @BatchLogId,@LastBatchStartProperty,@CurrentBatchStart

	EXEC  [DW].[usp_ImportRateSpreadSchedule] @BatchLogId,@LastBatchStartRateSpreadSchedule,@CurrentBatchStart

	EXEC [DW].[usp_ImportInvoiceDetail] @BatchLogId,@LastBatchStartInvoiceDetail,@CurrentBatchStart
	
	EXEC [DW].[usp_ImportTotalCommitmentData] @BatchLogId,@LastBatchStarttotalcomm,@CurrentBatchStart
	

	------from backshop nightly
	--EXEC [DW].usp_ImportUwDeal @BatchLogId,@LastBatchStartUwDeal,@CurrentBatchStart
	--EXEC [DW].usp_ImportUwNote @BatchLogId,@LastBatchStartUwNote,@CurrentBatchStart
	--EXEC [DW].usp_ImportUwNoteFunding @BatchLogId,@LastBatchStartUwNoteFunding,@CurrentBatchStart
	--EXEC [DW].usp_ImportUwCashflow @BatchLogId,@LastBatchStartUwCashflow,@CurrentBatchStart
	----------------------------------


	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartDeal WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_DealBI'
	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartNote WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_NoteBI'
	
	--UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartTran WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_TransactionBI'
	--UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartDailyCalc WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_DailyCalcBI'

	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartTransactionEntry WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_TransactionEntryBI'
	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartNotePeriodicCalc WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_NotePeriodicCalcBI'
	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartExceptions WHERE BatchLogId = @BatchLogId and LandingTableName ='L_ExceptionsBI'

	--UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchNoteFunding WHERE BatchLogId = @BatchLogId and LandingTableName ='L_NoteFundingBI'
	--UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartBSNoteFunding WHERE BatchLogId = @BatchLogId and LandingTableName ='L_BSNoteFundingBI'

	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartDealFundingSchdule WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_DealFundingSchduleBI'
	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartNoteFundingSchedule WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_NoteFundingScheduleBI'
	
	--UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartBackshopCurrentBalance WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_BackshopCurrentBalanceBI'
	
	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartFundingSequences WHERE BatchLogId = @BatchLogId and LandingTableName ='L_FundingSequencesBI'
	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartWorkFlow WHERE BatchLogId = @BatchLogId and LandingTableName ='L_WorkFlowBI'
	
	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartInterestCalculator WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_InterestCalculatorBI'

	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartWFTaskDetail WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_WFTaskDetailBI'
	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartWFCheckListDetail WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_WFCheckListDetailBI'

	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartDailyInterestAccruals WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_DailyInterestAccrualsBI'

	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartNoteTransactionDetail WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_NoteTransactionDetailBI'
	
	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartProperty WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_PropertyBI'
	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartRateSpreadSchedule WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_RateSpreadScheduleBI'
	
	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartInvoiceDetail WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_InvoiceDetailBI'

	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStarttotalcomm WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_TotalCommitmentDataBI'
	
	------from backshop nightly
	--UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartUwDeal WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_UwDealBI'
	--UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartUwNote WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_UwNoteBI'
	--UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartUwNoteFunding WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_UwNoteFundingBI'
	--UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartUwCashflow WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_UwCashflowBI'
	----------------------------------

END


