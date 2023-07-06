IF NOT EXISTS(SELECT 1 from APP.EmailNotification WHERE ModuleId =703)
BEGIN
	INSERT INTO APP.EmailNotification(EmailId,ModuleId,Status)VALUES('sbanerjee@hvantage.com',703,1)
END

IF NOT EXISTS(SELECT 1 from APP.EmailNotification WHERE ModuleId =704)
BEGIN
	INSERT INTO APP.EmailNotification(EmailId,ModuleId,Status)VALUES('allacoreemployees@mailinator.com',704,1)
END

IF NOT EXISTS(SELECT 1 from APP.EmailNotification WHERE ModuleId =705)
BEGIN
	INSERT INTO APP.EmailNotification(EmailId,ModuleId,Status)VALUES('skhan@hvantage.com',705,1)
END

IF NOT EXISTS(SELECT 1 from APP.EmailNotification WHERE ModuleId =706)
BEGIN
	INSERT INTO App.EmailNotification(EmailId,ModuleId,Status)VALUES('msingh@hvantage.com',706,1),('sbanerjee@hvantage.com',706,1)
END