CREATE PROCEDURE [dbo].[usp_GetValuationLogsDownload]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT Severity, Module, Message, Message_StackTrace, ObjectID, CreatedDate
	FROM App.Logger
	WHERE  Module like '%Valuation%'
	AND CreatedDate>=DATEADD(hour,-48,GETDATE());

END