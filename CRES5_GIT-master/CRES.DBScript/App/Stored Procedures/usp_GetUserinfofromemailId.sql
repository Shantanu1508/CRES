

Create PROCEDURE [App].[usp_GetUserinfofromemailId] --'msingh@newconinfosystems.com'
(
	@emailid nvarchar(256)
	
)
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
Login,
 [Password]     
FROM [App].[User]
WHERE Email = @emailid


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END


