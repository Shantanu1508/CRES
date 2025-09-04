
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
*/