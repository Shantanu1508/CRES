
CREATE PROCEDURE [dbo].[usp_GetUserNotification]  
 -- Add the parameters for the stored procedure here  
 @UserID nvarchar(256)  
 
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
    -- Insert statements for procedure here   


SELECT un.[UserNotificationID]
      ,un.[NotificationSubscriptionID]
      ,un.[ViewedTime]
      ,un.[CleanTime]
      ,un.[ObjectId]
      ,un.[ObjectTypeId]
	  ,CASE WHEN un.[ObjectTypeId] = 283 THEN (Select n.Msg1 +' '+dealname +' '+ n.msg2 +' '+ (Select FirstNAme+' '+LastName from App.[User] where UserId = ns.userid) from CRE.Deal where dealid = un.[ObjectId])
	  ELSE n.Msg1 +' '+ n.msg2 END as Msg
	  ,(Select FirstName+' '+LastName from App.[User] where UserId = un.[CreatedBy]) as Sender
      ,un.[CreatedBy]
      ,un.[CreatedDate]
      ,un.[UpdatedBy]
      ,un.[UpdatedDate]
  FROM [App].[UserNotification] un
  left join App.NotificationSubscription ns ON ns.NotificationSubscriptionId = un.NotificationSubscriptionId
  left Join app.Notification n ON n.NotificationId = ns.NotificationId
	Where ns.userid = @UserID
	and un.[CleanTime] is null

 
END
