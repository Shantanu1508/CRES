IF NOT EXISTS(select * from app.appconfig where [key] = 'AllowLiabilityAutomation')
BEGIN
	Insert into app.appconfig([key],[value],comments)VALUES('AllowLiabilityAutomation','1','Allow Liability Automation')
END

