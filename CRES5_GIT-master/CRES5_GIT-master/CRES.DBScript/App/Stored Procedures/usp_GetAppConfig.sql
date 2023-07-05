Create Procedure [App].[usp_GetAppConfig]
	@userId [uniqueidentifier]
	
AS
BEGIN
	SET NOCOUNT ON;
	
	Select [Key],[Value] from [App].[AppConfig] 

END
