if not exists(Select 1 from [App].[AppConfig] where [Key]='PowerBIPassword')
begin

INSERT INTO [App].[AppConfig]
           ([Key]
           ,[Value]
           ,[Comments]
           )
     VALUES
           ('PowerBIPassword'
           ,'Q4ZWA$B39dce@HZXC'
           ,'Password for PowerBI account login'
           )
end



IF NOT EXISTS(Select [Value] from app.appconfig where [key] = 'ImportStagingDataIntoIntegration')
BEGIN
	INSERT INTO app.appconfig ([key],[value],Comments)VALUES('ImportStagingDataIntoIntegration',0,'Import Staging Data Into Integration')
END