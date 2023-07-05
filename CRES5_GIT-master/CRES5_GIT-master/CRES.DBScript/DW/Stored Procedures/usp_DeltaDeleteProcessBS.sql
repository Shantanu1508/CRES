


CREATE PROCEDURE  [DW].[usp_DeltaDeleteProcessBS] 
	@BatchLogId int
AS
BEGIN
	
	SET NOCOUNT ON;

	Print('usp_DeltaDeleteProcessBS - BatchLogId = '+cast(@BatchLogId  as varchar(100)));
	

	DECLARE @currentBatchStart datetime,@batchCount int

	SET @currentBatchStart = (SELECT BatchStartTime FROM [DW].BatchLog WHERE BatchLogID = @BatchLogId)
	

	
	Delete from  DW.NoteperiodiccalcBI where noteid in 
	(
		Select Distinct noteid from DW.NoteperiodiccalcBI 
		where noteid not in (Select noteid from dw.noteBI)
	)

	Delete from  DW.TransactionEntryBI where noteid in 
	(
		Select Distinct noteid from DW.TransactionEntryBI 
		where noteid not in (Select noteid from dw.noteBI)
	)

	Delete From DW.NotePeriodicCalcBI where AnalysisID is null
	Delete From DW.TransactionEntryBI where AnalysisID is null

	Delete From dw.NotePeriodicCalcByEntityBI where AnalysisID is null
	Delete From dw.TransactionByEntityBI where AnalysisID is null


	UPDATE BatchLog
	SET Status = 'DELETING'
	WHERE BatchLogId = @BatchLogId

	
	

	IF @@ERROR <> 0
	BEGIN
		UPDATE BatchLog
		SET BatchEndTime = GETDATE(),Status = 'FAILURE',ErrorMessage = @@ERROR
		WHERE BatchLogId = @BatchLogId
	END
	
END



