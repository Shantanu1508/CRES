
CREATE PROCEDURE [DW].[usp_ImportNoteFundingSchedule]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;

INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
VALUES (@BatchLogId,'L_NoteFundingScheduleBI',GETDATE())

DECLARE @id int,@RowCount int
SET @id = (SELECT @@IDENTITY)


truncate table [DW].[L_NoteFundingScheduleBI]




SET @RowCount = @@ROWCOUNT
Print(char(9) +char(9)+'usp_ImportNoteFundingSchedule - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

UPDATE [DW].BatchDetail
SET
LandingEndTime = GETDATE(),
LandingRecordCount = @RowCount
WHERE BatchDetailId = @id





END



