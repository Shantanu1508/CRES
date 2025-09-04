if not exists(select 1 from app.emailnotification where moduleid=720)
begin
	insert into app.emailnotification(EmailID,ModuleId,Status)
	--for prod
	--values ('jennis@acorecapital.com',720,1),
	--values ('dgrocholski@acorecapital.com',720,1)

	--for test
	values ('jennis@mailinator.com',720,1),
	('dgrocholski@mailinator.com',720,1)

end