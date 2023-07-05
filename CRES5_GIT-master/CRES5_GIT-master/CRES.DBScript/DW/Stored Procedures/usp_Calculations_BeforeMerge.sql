
CREATE PROCEDURE [DW].[usp_Calculations_BeforeMerge]
	@BatchLogID int
AS
BEGIN
	SET NOCOUNT ON;

	Print('usp_Calculations_BeforeMerge - BatchLogId = '+cast(@BatchLogId  as varchar(100)));
	

	UPDATE [DW].BatchLog
	SET Status = 'PRE-CALCULATIONS'
	WHERE BatchLogId = @BatchLogID

	DECLARE @BatchCount int
	SET @BatchCount = (SELECT count(*) from BatchLog WHERE BatchEndTime > CONVERT(DATE,GETDATE()) and BatchName = 'Delta Refresh Process' and Status = 'SUCCESS')

	
END
