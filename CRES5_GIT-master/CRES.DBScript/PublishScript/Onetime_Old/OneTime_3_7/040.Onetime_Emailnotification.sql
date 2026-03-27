


IF((SELECT DB_NAME()) = 'CRES4_Acore')
BEGIN
	INSERT INTO app.emailnotification (EmailID,ModuleId,Status,Type)
	VALUES('amfinancialcontrols@acorecapital.com',632,1,783)
END