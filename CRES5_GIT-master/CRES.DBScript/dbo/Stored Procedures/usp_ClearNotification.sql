 
create PROCEDURE [dbo].[usp_ClearNotification]  
 -- Add the parameters for the stored procedure here  
 @NotificationID UNIQUEIDENTIFIER
,@UpdatedBy varchar(256)
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  

update [App].[UserNotification]
set CleanTime=GETDATE(),
UpdatedBy=@UpdatedBy,
UpdatedDate=GETDATE()
 where UserNotificationID=@NotificationID
 END
