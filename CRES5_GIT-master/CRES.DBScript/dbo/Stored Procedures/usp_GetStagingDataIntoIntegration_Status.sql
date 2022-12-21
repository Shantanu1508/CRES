
CREATE PROCEDURE [dbo].[usp_GetStagingDataIntoIntegration_Status]
AS
BEGIN
    SET NOCOUNT ON;

    Select TableName,Status,StartDate,EndDate from DW.ImportStagDataIntoInt_Status


END