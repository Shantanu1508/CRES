CREATE PROCEDURE [dbo].[usp_GetImportStagingDataStatus] 

AS
BEGIN
 SET NOCOUNT ON;
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 Declare @Status nvarchar(50);

IF EXISTS(Select [Status] from DW.ImportStagDataIntoInt_Status)
BEGIN
	IF((Select COUNT(Distinct [Status]) from DW.ImportStagDataIntoInt_Status where [Status] <> 'Completed') = 0)
	BEGIN
		SET @Status = 'Completed';
	END
	ELSE
	BEGIN
		SET @Status ='Not Completed';
	END
END
ELSE
BEGIN
	SET @Status ='No Data';
END
	
	SELECT @Status as [Status];

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
