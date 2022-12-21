CREATE Procedure [App].[usp_GetAppConfigByKey]
	@userId [uniqueidentifier],
	@Key nvarchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	
	Select [Key],[Value] from [App].[AppConfig] where [Key] like '%' +@Key+'%'

END
