Create Procedure [dbo].[usp_GetClient]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT [ClientID],[ClientName] FROM [CRE].[Client] Order by [ClientName]
END
