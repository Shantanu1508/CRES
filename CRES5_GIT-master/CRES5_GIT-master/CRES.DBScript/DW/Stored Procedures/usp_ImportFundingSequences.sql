
CREATE PROCEDURE [DW].[usp_ImportFundingSequences]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;

INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
VALUES (@BatchLogId,'L_FundingSequencesBI',GETDATE())

DECLARE @id int,@RowCount int
SET @id = (SELECT @@IDENTITY)


truncate table [DW].[L_FundingSequencesBI]




SET @RowCount = @@ROWCOUNT
Print(char(9) +char(9)+'usp_ImportFundingSequences - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

UPDATE [DW].BatchDetail
SET
LandingEndTime = GETDATE(),
LandingRecordCount = @RowCount
WHERE BatchDetailId = @id





END



