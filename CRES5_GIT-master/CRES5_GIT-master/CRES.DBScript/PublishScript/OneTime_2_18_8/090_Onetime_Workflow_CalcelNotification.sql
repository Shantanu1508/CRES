IF not exists(SELECT 1 FROM cre.WFTemplate WHERE TemplateFileName='CancelPreliminaryNotification.html')
BEGIN
INSERT INTO cre.WFTemplate(TemplateFileName) 
VALUES('CancelPreliminaryNotification.html')
END

GO

IF not exists(SELECT 1 FROM cre.[WFNotificationConfig] WHERE [Name]='CancelPreliminaryNotificationConfig')
BEGIN
INSERT INTO [CRE].[WFNotificationConfig]
           ([Name]
           ,[CanChangeReplyTo]
           ,[CanChangeRecipientList]
           ,[CanChangeHeader]
           ,[CanChangeBody]
           ,[CanChangeFooter]
           ,[CanChangeSchedule]
          )
     VALUES
           ('CancelPreliminaryNotificationConfig'
           ,0
           ,1
           ,0
           ,0
           ,1
           ,0
           )
END

GO

IF not exists(SELECT 1 FROM cre.WFNotificationMaster WHERE [Name]='Cancel Preliminary Notification')
BEGIN
INSERT INTO cre.WFNotificationMaster([Name],WFNotificationConfigID,TemplateID,IsEnable)
VALUES('Cancel Preliminary Notification',7,7,1)
END
