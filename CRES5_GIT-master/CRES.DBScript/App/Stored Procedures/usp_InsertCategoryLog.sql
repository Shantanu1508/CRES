

CREATE PROCEDURE [APP].[usp_InsertCategoryLog]
    @CategoryID INT,
    @LogID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CatLogID INT
    SELECT @CatLogID FROM [APP].[CategoryLog] WHERE CategoryID=@CategoryID and LogID = @LogID
    IF @CatLogID IS NULL
    BEGIN
        INSERT INTO [APP].[CategoryLog] (CategoryID, LogID) VALUES(@CategoryID, @LogID)
        RETURN @@IDENTITY
    END
    ELSE RETURN @CatLogID
END
