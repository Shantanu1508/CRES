
if not exists(select 1 from CRE.WFTemplate where TemplateFileName='ReservePreliminaryNotification.html')
	insert into CRE.WFTemplate(WFTemplateGUID,TemplateFileName) values(newid(),'ReservePreliminaryNotification.html')
go
if not exists(select 1 from CRE.WFTemplate where TemplateFileName='ReserveFinalNotification.html')
	insert into CRE.WFTemplate(WFTemplateGUID,TemplateFileName) values(newid(),'ReserveFinalNotification.html')
go

if not exists(select 1 from CRE.WFNotificationConfig where Name='ReservePreliminaryNotificationConfig')
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
           ,'ReservePreliminaryNotificationConfig'
           ,0
           ,1
           ,0
           ,0
           ,1
           ,0
           )
   end
  go
  if not exists(select 1 from CRE.WFNotificationConfig where Name='ReserveFinalNotificationConfig')
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
           ,'ReserveFinalNotificationConfig'
           ,0
           ,1
           ,0
           ,0
           ,1
           ,0
           )
   end
  go

if not exists(select 1 from CRE.[WFNotificationMaster] where Name='Reserve Preliminary Notification')
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
           ,'Reserve Preliminary Notification'
           ,4
           ,4
           ,1
           )


end

go

if not exists(select 1 from CRE.[WFNotificationMaster] where Name='Reserve Final Notification')
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
           ,'Reserve Final Notification'
           ,5
           ,5
           ,1
           )


end
