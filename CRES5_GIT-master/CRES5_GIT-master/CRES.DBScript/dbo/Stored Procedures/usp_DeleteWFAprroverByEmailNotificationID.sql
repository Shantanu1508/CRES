--[dbo].[usp_DeleteWFAprroverByEmailNotificationID] 'B0E6697B-3534-4C09-BE0A-04473401AB93','27','abc@123'  
CREATE PROCEDURE [dbo].[usp_DeleteWFAprroverByEmailNotificationID]   
(  
 @UserId Uniqueidentifier,  
 @EmailNotificationID int,  
 @Email nvarchar(256)  
)  
AS  
BEGIN  
     DELETE FROM [App].[EmailNotification] WHERE EmailNotificationID = @EmailNotificationID AND EmailId = @Email  
END  
