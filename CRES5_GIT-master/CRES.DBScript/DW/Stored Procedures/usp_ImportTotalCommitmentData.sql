
CREATE PROCEDURE [DW].[usp_ImportTotalCommitmentData]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;

INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
VALUES (@BatchLogId,'L_TotalCommitmentDataBI',GETDATE())

DECLARE @id int,@RowCount int
SET @id = (SELECT @@IDENTITY)


truncate table [DW].[L_TotalCommitmentDataBI]



SET @RowCount = @@ROWCOUNT
Print(char(9) +char(9)+'usp_ImportTotalCommitmentData - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

UPDATE [DW].BatchDetail
SET
LandingEndTime = GETDATE(),
LandingRecordCount = @RowCount
WHERE BatchDetailId = @id





END



