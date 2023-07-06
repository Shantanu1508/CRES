 
CREATE PROCEDURE [dbo].[usp_GetUserNotificationCount]  --'b55d8909-25ef-4778-8756-6997e33ad9f5'
 -- Add the parameters for the stored procedure here  
 @UserID nvarchar(256) 

AS  
BEGIN  
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
Declare @totalCnt int,
		@currentcnt int	

DECLARE @usercount TABLE(
    totalCount int NOT NULL,
    currentcount int NOT NULL
);


SET @totalCnt=
(SELECT count(n.StatusID)     
  FROM [App].[UserNotification] un
  left join App.NotificationSubscription ns ON ns.NotificationSubscriptionId = un.NotificationSubscriptionId
  left Join app.[Notification] n ON n.NotificationId = ns.NotificationId  	
	Where ns.userid = @UserID
	 	and un.[CleanTime] is null
--	and un.[ViewedTime] is null
)
--+
--(SELECT count(n.StatusID)     
--  FROM [App].[UserNotificationArchive] un
--  left join App.NotificationSubscription ns ON ns.NotificationSubscriptionId = un.NotificationSubscriptionId
--  left Join app.[Notification] n ON n.NotificationId = ns.NotificationId  	
--	Where ns.userid = @UserID
--	 	and un.[CleanTime] is null
----	and un.[ViewedTime] is null
--)

SET @currentcnt=
(SELECT count(n.StatusID)     
  FROM [App].[UserNotification] un
  left join App.NotificationSubscription ns ON ns.NotificationSubscriptionId = un.NotificationSubscriptionId
  left Join app.[Notification] n ON n.NotificationId = ns.NotificationId  	
	Where ns.userid = @UserID
	 and un.[CleanTime] is null
	 and un.[ViewedTime] is null
)
--+
--(SELECT count(n.StatusID)     
--  FROM [App].[UserNotificationArchive] un
--  left join App.NotificationSubscription ns ON ns.NotificationSubscriptionId = un.NotificationSubscriptionId
--  left Join app.[Notification] n ON n.NotificationId = ns.NotificationId  	
--	Where ns.userid = @UserID
--	 and un.[CleanTime] is null
--	 and un.[ViewedTime] is null
--)

	 INSERT INTO @usercount
		SELECT @totalcnt, @currentcnt 

		select * from @usercount
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
