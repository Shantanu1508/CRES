

CREATE PROCEDURE [dbo].[usp_ImportIntoUserNotificationArchive]

AS
  BEGIN
  SET NOCOUNT ON; 


INSERT INTO [App].[UserNotificationArchive]  
		([UserNotificationID]
		,[NotificationSubscriptionID]  
		,[ViewedTime]  
		,[CleanTime]  
		,[ObjectId]  
		,[ObjectTypeId]  
		,[GeneratedBy]  
		,[CreatedBy]  
		,[CreatedDate]  
		,[UpdatedBy]  
		,[UpdatedDate])   
       
Select
[UserNotificationID]
,[NotificationSubscriptionID]  
,[ViewedTime]  
,[CleanTime]  
,[ObjectId]  
,[ObjectTypeId]  
,[GeneratedBy]  
,[CreatedBy]  
,[CreatedDate]  
,[UpdatedBy]  
,[UpdatedDate]  
from [App].[UserNotification] where CAST(CreatedDate as Date) < CAST(DateAdd(d,-7,GETDATE()) as Date)


DELETE from [App].[UserNotification] where CAST(CreatedDate as Date) < CAST(DateAdd(d,-7,GETDATE()) as Date)


DELETE from [App].[UserNotificationArchive] where CAST(CreatedDate as Date) < CAST(DateAdd(d,-30,GETDATE()) as Date)


END
