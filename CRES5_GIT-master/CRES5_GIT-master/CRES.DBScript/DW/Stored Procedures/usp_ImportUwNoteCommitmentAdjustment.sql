
CREATE PROCEDURE [DW].[usp_ImportUwNoteCommitmentAdjustment]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
	VALUES (@BatchLogId,'L_UwNoteCommitmentAdjustmentBI',GETDATE())

	DECLARE @id int,@RowCount int
	SET @id = (SELECT @@IDENTITY)


	UPDATE [DW].BatchDetail
	SET
	LandingEndTime = GETDATE(),
	LandingRecordCount = @RowCount
	WHERE BatchDetailId = @id

END
