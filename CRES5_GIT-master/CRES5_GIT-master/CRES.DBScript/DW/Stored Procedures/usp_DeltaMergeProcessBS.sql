

CREATE PROCEDURE  [DW].[usp_DeltaMergeProcessBS]
	@BatchLogId int
AS
BEGIN
	SET NOCOUNT ON


	Print('usp_DeltaMergeProcessBS - BatchLogId = '+cast(@BatchLogId  as varchar(100)));

	UPDATE [DW].BatchLog
	SET Status = 'MERGING'
	WHERE BatchLogId = @BatchLogId
	
	
	EXEC [DW].usp_MergeUwDeal @BatchLogId
	EXEC [DW].usp_MergeUwNote @BatchLogId
	EXEC [DW].usp_MergeUwNoteFunding @BatchLogId
	EXEC [DW].usp_MergeUwNoteCommitmentAdjustment @BatchLogId
	EXEC [DW].usp_MergeUwCashflow @BatchLogId
	EXEC [DW].usp_MergeUwProperty @BatchLogId

	IF @@ERROR <> 0
	BEGIN
		UPDATE [DW].BatchLog
		SET BatchEndTime = GETDATE(),Status = 'FAILURE',ErrorMessage = ERROR_MESSAGE()
		WHERE BatchLogId = @BatchLogId
	END
END


