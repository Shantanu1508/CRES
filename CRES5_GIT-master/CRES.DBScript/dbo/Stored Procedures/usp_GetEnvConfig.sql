CREATE PROCEDURE [dbo].[usp_GetEnvConfig]
	@ExcludedEnvName nvarchar(256)
AS
BEGIN
	SET NOCOUNT ON;

	Select [EnvName],[ServerName],[LoginName],[Password],[DBName] 
	from [App].[EnvConfig] WHERE EnvName not like '%' + @ExcludedEnvName + '%';
END