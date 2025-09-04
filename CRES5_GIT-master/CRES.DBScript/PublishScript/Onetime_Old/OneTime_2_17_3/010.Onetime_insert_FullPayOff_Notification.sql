
if not exists(select 1 from CRE.WFTemplate where TemplateFileName='FinalNotificationWithoutApproval.html')
	insert into CRE.WFTemplate(WFTemplateGUID,TemplateFileName) values(newid(),'FinalNotificationWithoutApproval.html')
go

if not exists(select 1 from CRE.WFNotificationConfig where Name='FinalNotificationWithoutApprovalConfig')
   begin
   INSERT INTO [CRE].[WFNotificationConfig]
           ([WFNotificationConfigGuID]
           ,[Name]
           ,[CanChangeReplyTo]
           ,[CanChangeRecipientList]
           ,[CanChangeHeader]
           ,[CanChangeBody]
           ,[CanChangeFooter]
           ,[CanChangeSchedule]
           )
     VALUES
           (newid()
           ,'FinalNotificationWithoutApprovalConfig'
           ,0
           ,1
           ,0
           ,0
           ,1
           ,0
           )
   end
  go

if not exists(select 1 from CRE.[WFNotificationMaster] where Name='Final Notification Without Approval')
begin

INSERT INTO [CRE].[WFNotificationMaster]
           ([WFNotificationMasterGuID]
           ,[Name]
           ,[WFNotificationConfigID]
           ,[TemplateID]
           ,[IsEnable]
           )
     VALUES
           (newid()
           ,'Final Notification Without Approval'
           ,6
           ,6
           ,1
           )


end

if not exists(select 1 from CRE.WFNotificationMasterEmail where lookupid=704)
begin
	insert into CRE.WFNotificationMasterEmail(lookupID,EmailID,ParentClient)
	select 704,EmailID,ParentClient from [CRE].WFNotificationMasterEmail where lookupid=605
end

if not exists(select 1 from app.emailnotification where moduleid=704)
begin
	insert into app.emailnotification(EmailID,ModuleId,Status)
	--values ('allacoreemployees@acorecapital.com',704,1)
	values ('allacoreemployees@mailinator.com',704,1)

end