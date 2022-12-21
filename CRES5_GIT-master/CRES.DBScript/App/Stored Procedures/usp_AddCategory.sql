
CREATE PROCEDURE [APP].[usp_AddCategory]
    -- Add the parameters for the function here
    @CategoryName nvarchar(64),
    @LogID int
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CatID INT
    SELECT @CatID = CategoryID FROM [APP].[Category] WHERE CategoryName = @CategoryName
    IF @CatID IS NULL
    BEGIN
        INSERT INTO [APP].[Category] (CategoryName) VALUES(@CategoryName)
        SELECT @CatID = @@IDENTITY
    END

    EXEC [APP].[usp_InsertCategoryLog] @CatID, @LogID 

    RETURN @CatID
END
