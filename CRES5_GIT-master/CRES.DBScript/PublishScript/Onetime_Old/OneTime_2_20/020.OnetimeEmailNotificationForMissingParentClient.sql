IF Not Exists (SELECT 1 FROM app.EmailNotification WHERE ModuleId=792)
BEGIN
	INSERT INTO app.EmailNotification(EmailId,ModuleId,[Status],[type]) VALUES('skhan@hvantage.com',792,1,null)
END