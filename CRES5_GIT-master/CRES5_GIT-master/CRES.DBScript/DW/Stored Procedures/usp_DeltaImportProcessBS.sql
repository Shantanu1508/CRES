

CREATE PROCEDURE [DW].[usp_DeltaImportProcessBS]
	@BatchLogId int
AS
BEGIN
	
	SET NOCOUNT ON;
    
	Print(char(9) +'usp_DeltaImportProcessBS - BatchLogId = '+cast(@BatchLogId  as varchar(100)));
	
	DECLARE @LastBatchStartUwDeal datetime;
	DECLARE @LastBatchStartUwNote datetime;
	DECLARE @LastBatchStartUwNoteFunding datetime;
	DECLARE @LastBatchStartUwNoteCommitmentAdjustment datetime;
	DECLARE @LastBatchStartUwCashflow datetime;
	DECLARE @LastBatchStartUwProperty datetime;

	DECLARE @CurrentBatchStart datetime,@LastBatchId int,@LastBatchStatus varchar(50),@LastFailedBatchId int
	
	SET @LastBatchId = (SELECT TOP 1 BatchLogId FROM [DW].BatchLog WHERE BatchName = 'Refresh From Backshop' and Status = 'SUCCESS' ORDER BY BatchStartTime DESC)
	SET @LastFailedBatchId = (SELECT TOP 1 BatchLogId FROM [DW].BatchLog 
							WHERE BAtchLogID > @LastBatchId AND BatchLogId < @BatchLogId and BatchName = 'Refresh From Backshop' and Status <> 'SUCCESS' 
							ORDER BY BatchStartTime ASC)


	IF @LastFailedBatchId is null
	BEGIN
		
		SET @LastBatchStartUwDeal = (SELECT MAX(AuditUpdateDate) FROM [DW].[UwDealBI])
		SET @LastBatchStartUwNote = (SELECT MAX(AuditUpdateDate) FROM [DW].[UwNoteBI])
		SET @LastBatchStartUwNoteFunding = (SELECT MAX(AuditUpdateDate) FROM [DW].[UwNoteFundingBI])
		SET @LastBatchStartUwNoteCommitmentAdjustment = (SELECT MAX(AuditUpdateDate) FROM [DW].[UwNoteCommitmentAdjustmentBI])
		SET @LastBatchStartUwCashflow = (SELECT MAX(PeriodEndDate) FROM [DW].[UwCashflowBI])
		SET @LastBatchStartUwProperty = (SELECT MAX(AuditUpdateDate) FROM [DW].[UwPropertyBI])

	END
	ELSE 
	BEGIN
		
		SET @LastBatchStartUwDeal = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_UwDealBI')
		SET @LastBatchStartUwNote = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_UwNoteBI')
		SET @LastBatchStartUwNoteFunding = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_UwNoteFundingBI')
		SET @LastBatchStartUwNoteCommitmentAdjustment = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_UwNoteCommitmentAdjustmentBI')
		SET @LastBatchStartUwCashflow = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_UwCashflowBI')
		SET @LastBatchStartUwProperty = (SELECT LastCreatedDate FROM [DW].BatchDetail WHERE BatchLogId = @LastFailedBAtchId and LandingTableName = 'L_UwPropertyBI')

	END

	SET @CurrentBatchStart = (SELECT BatchStartTime FROM [DW].BatchLog WHERE BatchLogId = @BatchLogId)
	
	
	EXEC [DW].usp_ImportUwDeal @BatchLogId,@LastBatchStartUwDeal,@CurrentBatchStart
	EXEC [DW].usp_ImportUwNote @BatchLogId,@LastBatchStartUwNote,@CurrentBatchStart
	EXEC [DW].usp_ImportUwNoteFunding @BatchLogId,@LastBatchStartUwNoteFunding,@CurrentBatchStart
	EXEC [DW].usp_ImportUwNoteCommitmentAdjustment @BatchLogId,@LastBatchStartUwNoteCommitmentAdjustment,@CurrentBatchStart
	EXEC [DW].usp_ImportUwCashflow @BatchLogId,@LastBatchStartUwCashflow,@CurrentBatchStart
	EXEC [DW].usp_ImportUwProperty @BatchLogId,@LastBatchStartUwProperty,@CurrentBatchStart
	

	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartUwDeal WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_UwDealBI'
	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartUwNote WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_UwNoteBI'
	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartUwNoteFunding WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_UwNoteFundingBI'
	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartUwNoteCommitmentAdjustment WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_UwNoteCommitmentAdjustmentBI'
	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartUwCashflow WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_UwCashflowBI'
	UPDATE [DW].BatchDetail SET LastCreatedDate = @LastBatchStartUwProperty WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_UwPropertyBI'
		
	
END


