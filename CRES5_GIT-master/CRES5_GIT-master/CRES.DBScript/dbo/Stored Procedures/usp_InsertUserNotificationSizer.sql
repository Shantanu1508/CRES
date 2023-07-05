
CREATE PROCEDURE [dbo].[usp_InsertUserNotificationSizer]  -- '1128'
 -- Add the parameters for the stored procedure here  
 @CreDealID nvarchar(256)
  
  
AS  
BEGIN  
 
 SET NOCOUNT ON;  
 
 Declare @UserID UNIQUEIDENTIFIER = (select UserID  from App.[User] where Login ='sizer')
 
 Declare @DealID UNIQUEIDENTIFIER = (select top 1 DealID  from CRE.Deal where CREDealID =@CreDealID)    

   	Exec [dbo].[usp_InsertUserNotification]  @UserID,'adddeal',@DealID

END
