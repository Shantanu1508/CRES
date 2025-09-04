-- Procedure
CREATE PROCEDURE [dbo].[usp_GetLogsDownload]
    @ObjectID VARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT Severity, Module, Message, Message_StackTrace, ObjectID, CreatedDate
    FROM App.Logger
    WHERE  Severity = 'Error'
      AND ObjectID = @ObjectID;
END;
GO

