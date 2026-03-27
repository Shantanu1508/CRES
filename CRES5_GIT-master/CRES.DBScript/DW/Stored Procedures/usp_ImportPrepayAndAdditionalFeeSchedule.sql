-- Procedure

CREATE PROCEDURE [DW].[usp_ImportPrepayAndAdditionalFeeSchedule]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


	INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
	VALUES (@BatchLogId,'L_PrepayAndAdditionalFeeScheduleBI',GETDATE())

	Truncate table [DW].[L_PrepayAndAdditionalFeeScheduleBI]


	DECLARE @id int,@RowCount int
	SET @id = (SELECT @@IDENTITY)


SET @RowCount = @@ROWCOUNT
	Print(char(9) +'usp_ImportPrepayAndAdditionalFeeSchedule - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

	UPDATE [DW].BatchDetail
	SET
	LandingEndTime = GETDATE(),
	LandingRecordCount = @RowCount
	WHERE BatchDetailId = @id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END


