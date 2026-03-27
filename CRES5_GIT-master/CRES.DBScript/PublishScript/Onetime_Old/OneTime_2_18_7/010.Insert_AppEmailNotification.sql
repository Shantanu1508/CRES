
--IF NOT EXISTS(Select * from App.EmailNotification Where EmailId = 'igai@acorecapital.com' and ModuleId = 781)
--BEGIN
--	insert into App.EmailNotification (EmailId,ModuleId,Status) values ('igai@acorecapital.com',781,1)
--END



IF NOT EXISTS(Select * from App.EmailNotification Where EmailId = 'support@m61systems.com' and ModuleId = 781)
BEGIN
	insert into App.EmailNotification (EmailId,ModuleId,Status) values ('support@m61systems.com',781,1)
END