--for QA
if not exists(select 1 from app.EmailNotification where Emailid='reserverequests@mailinator.com' and ModuleId=857)
		insert into app.emailnotification (EmailId,ModuleId,Status) select 'reserverequests@mailinator.com',857,1

if not exists(select 1 from app.EmailNotification where Emailid='ReservesSupervisors@mailinator.com' and ModuleId=857)
        insert into app.emailnotification (EmailId,ModuleId,Status) select 'ReservesSupervisors@mailinator.com',857,1

/*
--for production
if not exists(select 1 from app.EmailNotification where Emailid='reserverequests@berkadia.com' and ModuleId=857)
	insert into app.emailnotification (EmailId,ModuleId,Status) select 'reserverequests@berkadia.com',857,1

if not exists(select 1 from app.EmailNotification where Emailid='ReservesSupervisors@berkadia.com' and ModuleId=857)
	insert into app.emailnotification (EmailId,ModuleId,Status) select 'ReservesSupervisors@berkadia.com',857,1
	*/