 
CREATE PROCEDURE [dbo].[usp_ClearAllUserNotificationCount]  
 -- Add the parameters for the stored procedure here  
 @UserID nvarchar(256)  
 
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
    -- Insert statements for procedure here   
update un
set un.ViewedTime=GETDATE()
from [App].[UserNotification] un left join App.NotificationSubscription ns on ns.NotificationSubscriptionID=un.NotificationSubscriptionId
 where ns.userid = @UserID
 	and un.[CleanTime] is null
	and un.[ViewedTime] is null

--update un
--set un.ViewedTime=GETDATE()
--from [App].[UserNotificationArchive] un left join App.NotificationSubscription ns on ns.NotificationSubscriptionID=un.NotificationSubscriptionId
-- where ns.userid = @UserID
-- 	and un.[CleanTime] is null
--	and un.[ViewedTime] is null
END
