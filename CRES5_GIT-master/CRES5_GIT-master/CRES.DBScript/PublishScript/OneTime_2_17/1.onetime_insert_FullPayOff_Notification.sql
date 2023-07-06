
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
           ,4
           ,4
           ,1
           )


end

if not exists(select 1 from CRE.WFNotificationMasterEmail where lookupid=704)
begin
	insert into CRE.WFNotificationMasterEmail(lookupID,EmailID,ParentClient)
	select 704,EmailID,ParentClient from [CRE].WFNotificationMasterEmail where lookupid=605
end