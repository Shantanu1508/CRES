IF((SELECT DB_NAME()) = 'CRES4_Acore')
BEGIN

	IF NOT EXISTS(SELECT 1 from APP.EmailNotification WHERE ModuleId =898)
	BEGIN
		INSERT INTO app.emailnotification (EmailID,ModuleId,Status,Type)VALUES('support@m61systems.com',898,1,782)	 
	END 

END
ELSE
BEGIN
IF NOT EXISTS(SELECT 1 from APP.EmailNotification WHERE ModuleId =898)
	BEGIN
	    INSERT INTO app.emailnotification (EmailID,ModuleId,Status,Type)VALUES('msingh@hvantage.com',898,1,783)
        INSERT INTO app.emailnotification (EmailID,ModuleId,Status,Type)VALUES('psingh@hvantage.com',898,1,782)
	END	 
END
 