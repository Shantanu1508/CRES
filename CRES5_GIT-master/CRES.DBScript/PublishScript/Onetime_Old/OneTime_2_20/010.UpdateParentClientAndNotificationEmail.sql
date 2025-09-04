
--for QA
update cre.FinancingSourceMaster set ParentClient='ACP II' where FinancingSourceName='ACORE Credit Partners II'
update cre.WFNotificationMasterEmail set ParentClient='ACP II' where ParentClient='ACORE Credit Partners II'
update cre.WFNotificationMasterEmail set EmailID='fundingdrawacorefunds@mailinator.com' where ParentClient='ACP II'

update cre.WFNotificationMasterEmail set EmailID='fundingdrawacorefunds@mailinator.com' where EmailID in 
('fundingdrawaciv@mailinator.com','fundingdrawacss@mailinator.com')

IF Not Exists (SELECT 1 FROM app.EmailNotification WHERE ModuleId=791 and EmailId='acorepefs@statestreetmailinator.com')
BEGIN
	INSERT INTO app.EmailNotification(EmailId,ModuleId,[Status],[type]) VALUES('acorepefs@statestreetmailinator.com',791,1,null)
END

IF Not Exists (SELECT 1 FROM cre.WFNotificationMasterEmail WHERE LookupID=604 and ParentClient='ACP II')
BEGIN
	INSERT INTO cre.WFNotificationMasterEmail VALUES(null,604,'fundingdrawacorefunds@mailinator.com','ACP II')
END

IF Not Exists (SELECT 1 FROM cre.WFNotificationMasterEmail WHERE LookupID=605 and ParentClient='ACP II')
BEGIN
	INSERT INTO cre.WFNotificationMasterEmail VALUES(null,605,'fundingdrawacorefunds@mailinator.com','ACP II')
END

IF Not Exists (SELECT 1 FROM cre.WFNotificationMasterEmail WHERE LookupID=607 and ParentClient='ACP II')
BEGIN
	INSERT INTO cre.WFNotificationMasterEmail VALUES(null,607,'fundingdrawacorefunds@mailinator.com','ACP II')
END
IF Not Exists (SELECT 1 FROM cre.WFNotificationMasterEmail WHERE LookupID=704 and ParentClient='ACP II')
BEGIN
	INSERT INTO cre.WFNotificationMasterEmail VALUES(null,704,'fundingdrawacorefunds@mailinator.com','ACP II')
END



/*
--for prod
update cre.FinancingSourceMaster set ParentClient='ACP II' where FinancingSourceName='ACORE Credit Partners II'
update cre.WFNotificationMasterEmail set ParentClient='ACP II' where ParentClient='ACORE Credit Partners II'
update cre.WFNotificationMasterEmail set EmailID='fundingdrawacorefunds@acorecapital.com' where ParentClient='ACP II'

update cre.WFNotificationMasterEmail set EmailID='fundingdrawacorefunds@acorecapital.com' where EmailID in 
('fundingdrawaciv@acorecapital.com','fundingdrawacss@acorecapital.com')

IF Not Exists (SELECT 1 FROM app.EmailNotification WHERE ModuleId=791 and EmailId='acorepefs@statestreet.com')
BEGIN
	INSERT INTO app.EmailNotification(EmailId,ModuleId,[Status],[type]) VALUES('acorepefs@statestreet.com',791,1,null)
END

IF Not Exists (SELECT 1 FROM cre.WFNotificationMasterEmail WHERE LookupID=604 and ParentClient='ACP II')
BEGIN
	INSERT INTO cre.WFNotificationMasterEmail VALUES(null,604,'fundingdrawacorefunds@acorecapital.com','ACP II')
END

IF Not Exists (SELECT 1 FROM cre.WFNotificationMasterEmail WHERE LookupID=605 and ParentClient='ACP II')
BEGIN
	INSERT INTO cre.WFNotificationMasterEmail VALUES(null,605,'fundingdrawacorefunds@acorecapital.com','ACP II')
END

IF Not Exists (SELECT 1 FROM cre.WFNotificationMasterEmail WHERE LookupID=607 and ParentClient='ACP II')
BEGIN
	INSERT INTO cre.WFNotificationMasterEmail VALUES(null,607,'fundingdrawacorefunds@acorecapital.com','ACP II')
END
IF Not Exists (SELECT 1 FROM cre.WFNotificationMasterEmail WHERE LookupID=704 and ParentClient='ACP II')
BEGIN
	INSERT INTO cre.WFNotificationMasterEmail VALUES(null,704,'fundingdrawacorefunds@acorecapital.com','ACP II')
END
*/