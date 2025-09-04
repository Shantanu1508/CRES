IF((SELECT DB_NAME()) = 'CRES4_Acore')
BEGIN

	IF NOT EXISTS(SELECT 1 from APP.EmailNotification WHERE ModuleId =707)
	BEGIN
		INSERT INTO app.emailnotification(emailid,moduleid,status)values('skhan@hvantage.com',707,1),('rsahu@hvantage.com',707,1), ('schandak@hvantage.com ',707,1)
	END

END
ELSE
BEGIN
	IF NOT EXISTS(SELECT 1 from APP.EmailNotification WHERE ModuleId =707)
	BEGIN
		INSERT INTO app.emailnotification(emailid,moduleid,status)values('skhan@hvantage.com',707,1),('rsahu@hvantage.com',707,1)
	END
END