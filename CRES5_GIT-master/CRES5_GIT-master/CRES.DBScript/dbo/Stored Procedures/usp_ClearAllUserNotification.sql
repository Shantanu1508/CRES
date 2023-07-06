 
CREATE PROCEDURE [dbo].[usp_ClearAllUserNotification]  
 -- Add the parameters for the stored procedure here  
 @UserID nvarchar(256)  
 
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
    -- Insert statements for procedure here   
update un
set un.CleanTime=GETDATE(),
un.UpdatedDate=GETDATE(),
un.UpdatedBy=@UserID
from [App].[UserNotification] un left join App.NotificationSubscription ns on ns.NotificationSubscriptionID=un.NotificationSubscriptionId
 where ns.userid = @UserID and un.CleanTime is null

--update un
--set un.CleanTime=GETDATE(),
--un.UpdatedDate=GETDATE(),
--un.UpdatedBy=@UserID
--from [App].[UserNotificationArchive] un left join App.NotificationSubscription ns on ns.NotificationSubscriptionID=un.NotificationSubscriptionId
-- where ns.userid = @UserID and un.CleanTime is null
END
