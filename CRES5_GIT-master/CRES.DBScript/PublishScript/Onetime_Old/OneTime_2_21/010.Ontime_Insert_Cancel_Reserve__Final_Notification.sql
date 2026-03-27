--for normal workflow
if not exists(select 1 from CRE.WFTemplate where TemplateFileName='CancelFinalNotification.html')
	insert into CRE.WFTemplate(WFTemplateGUID,TemplateFileName) values(newid(),'CancelFinalNotification.html')
go

if not exists(select 1 from CRE.WFNotificationConfig where Name='CancelFinalNotificationConfig')
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
           ,'CancelFinalNotificationConfig'
           ,0
           ,1
           ,0
           ,0
           ,1
           ,0
           )
   end
  go
  

if not exists(select 1 from CRE.[WFNotificationMaster] where Name='Cancel Final Notification')
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
           ,'Cancel Final Notification'
           ,8
           ,8
           ,1
           )


end


--for reserve workflow
if not exists(select 1 from CRE.WFTemplate where TemplateFileName='CancelReserveFinalNotification.html')
	insert into CRE.WFTemplate(WFTemplateGUID,TemplateFileName) values(newid(),'CancelReserveFinalNotification.html')
go

if not exists(select 1 from CRE.WFNotificationConfig where Name='CancelReserveFinalNotificationConfig')
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
           ,'CancelReserveFinalNotificationConfig'
           ,0
           ,1
           ,0
           ,0
           ,1
           ,0
           )
   end
  go
  

if not exists(select 1 from CRE.[WFNotificationMaster] where Name='Cancel Reserve Final Notification')
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
           ,'Cancel Reserve Final Notification'
           ,9
           ,9
           ,1
           )


end
