IF not EXISTS(Select * from [App].[AppConfig] where [Key] = 'NumberOfCalculationRetries_valuation')
BEGIN
	INSERT [App].[AppConfig] ([Key], [Value], [Comments], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (N'NumberOfCalculationRetries_valuation', N'3', N'NumberOfCalculationRetries_valuation', NULL, NULL, NULL, NULL)
END




IF not EXISTS(Select * from [App].emailnotification where ModuleID = 632 and EmailID = 'abuzzi@acorecapital.com')
BEGIN

	INSERT INTO app.emailnotification(ModuleID,Status,EmailID,Type)
	VALUES(632,1,'abuzzi@acorecapital.com',782)

END