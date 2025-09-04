--IF not EXISTS(Select * from [App].[AppConfig] where [Key] = 'AllowDailyGAAPBasisComponents')
--BEGIN
--	INSERT [App].[AppConfig] ([Key], [Value], [Comments], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (N'AllowDailyGAAPBasisComponents', N'0', N'AllowDailyGAAPBasisComponents', NULL, NULL, NULL, NULL)
--END


IF not EXISTS(Select * from [App].[AppConfig] where [Key] = 'AllowSponsorDetailFromBackshop')
BEGIN
	IF((SELECT DB_NAME()) = 'CRES4_Acore')
	BEGIN
		INSERT [App].[AppConfig] ([Key], [Value], [Comments], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (N'AllowSponsorDetailFromBackshop', N'1', N'AllowDailyGAAPBasisComponents', NULL, NULL, NULL, NULL)
	END
	ELSE
	BEGIN
		INSERT [App].[AppConfig] ([Key], [Value], [Comments], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (N'AllowSponsorDetailFromBackshop', N'0', N'AllowDailyGAAPBasisComponents', NULL, NULL, NULL, NULL)
	END
	
END



IF not EXISTS(Select * from [App].[AppConfig] where [Key] = 'AllowDealAutomation')
BEGIN
	INSERT [App].[AppConfig] ([Key], [Value], [Comments], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (N'AllowDealAutomation', N'1', N'AllowDealAutomation', NULL, NULL, NULL, NULL)
END