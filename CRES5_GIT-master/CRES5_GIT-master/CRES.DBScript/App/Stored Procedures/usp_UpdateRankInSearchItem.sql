


CREATE PROCEDURE [App].[usp_UpdateRankInSearchItem] --'3c932775-b39a-4cc4-888c-85d22423a1a3','D1212'
(
	@ObjectID UNIQUEIDENTIFIER,
	@SearchText nvarchar(256)
) 
AS
BEGIN


	Declare @Object_ObjectAutoID UNIQUEIDENTIFIER;

	SET @Object_ObjectAutoID = (Select ObjectAutoID from App.[Object] where ObjectID = @ObjectID)

	UPDATE [App].[SearchItem] SET [Rank] = [Rank] + 1  WHERE  Object_ObjectAutoID = @Object_ObjectAutoID and SearchText = @SearchText;

END






