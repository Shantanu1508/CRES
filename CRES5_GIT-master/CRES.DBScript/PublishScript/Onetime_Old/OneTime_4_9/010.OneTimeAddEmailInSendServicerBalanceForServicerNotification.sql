IF((SELECT DB_NAME()) = 'CRES4_Acore')
BEGIN

	IF NOT EXISTS(SELECT 1 from APP.EmailNotification WHERE ModuleId =893)
	BEGIN
		INSERT INTO app.emailnotification (EmailID,ModuleId,Status,Type)VALUES('support@m61systems.com',893,1,783)
		INSERT INTO app.emailnotification (EmailID,ModuleId,Status,Type)VALUES('sgnotices@berkadia.com',893,1,782)
	END

	IF NOT EXISTS(SELECT 1 from APP.EmailNotification WHERE ModuleId =895)
	BEGIN
		INSERT INTO app.emailnotification (EmailID,ModuleId,Status,Type)VALUES('support@m61systems.com',895,1,783)
		INSERT INTO app.emailnotification (EmailID,ModuleId,Status,Type)VALUES('wffundingnotice@acorecapital.com',895,1,782)
	END

END
ELSE
BEGIN
IF NOT EXISTS(SELECT 1 from APP.EmailNotification WHERE ModuleId =893)
	BEGIN
	    INSERT INTO app.emailnotification (EmailID,ModuleId,Status,Type)VALUES('msingh@hvantage.com',893,1,783)
		INSERT INTO app.emailnotification (EmailID,ModuleId,Status,Type)VALUES('support@m61systems.com',893,1,782)
		 INSERT INTO app.emailnotification (EmailID,ModuleId,Status,Type)VALUES('rsahu@hvantage.com',893,1,783)
		 INSERT INTO app.emailnotification (EmailID,ModuleId,Status,Type)VALUES('sgnotices@berkadia.com',893,1,782)
	END

	IF NOT EXISTS(SELECT 1 from APP.EmailNotification WHERE ModuleId =895)
	BEGIN
	    INSERT INTO app.emailnotification (EmailID,ModuleId,Status,Type)VALUES('msingh@hvantage.com',895,1,783)
		INSERT INTO app.emailnotification (EmailID,ModuleId,Status,Type)VALUES('support@m61systems.com',895,1,782)
		INSERT INTO app.emailnotification (EmailID,ModuleId,Status,Type)VALUES('rsahu@hvantage.com',895,1,783)
		INSERT INTO app.emailnotification (EmailID,ModuleId,Status,Type)VALUES('wffundingnotice@acorecapital.com',895,1,782)
	END
END
 