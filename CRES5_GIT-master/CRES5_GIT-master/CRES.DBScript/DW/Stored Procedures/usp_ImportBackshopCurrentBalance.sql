
CREATE PROCEDURE [DW].[usp_ImportBackshopCurrentBalance]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;

INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
VALUES (@BatchLogId,'L_BackshopCurrentBalanceBI',GETDATE())

DECLARE @id int,@RowCount int
SET @id = (SELECT @@IDENTITY)


truncate table [DW].[L_BackshopCurrentBalanceBI]




SET @RowCount = @@ROWCOUNT
Print(char(9) +char(9)+'usp_ImportBackshopCurrentBalance - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

UPDATE [DW].BatchDetail
SET
LandingEndTime = GETDATE(),
LandingRecordCount = @RowCount
WHERE BatchDetailId = @id





END



