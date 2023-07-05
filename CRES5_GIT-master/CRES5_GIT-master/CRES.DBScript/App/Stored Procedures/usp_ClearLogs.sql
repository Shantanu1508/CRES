

CREATE PROCEDURE [APP].[usp_ClearLogs]
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM [APP].[CategoryLog]
    DELETE FROM [APP].[Log]
    DELETE FROM [APP].[Category]
END
