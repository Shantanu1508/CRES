CREATE PROCEDURE dbo.[usp_GetEmailIdsForEmailNotificationNew] -- 341    
 @ModuleId INT    
AS    
BEGIN    
 SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
  SELECT   
  [EmailId],  
  ISNULL([Type],0) as  [Type]    
    FROM App.EmailNotification WHERE ModuleId = @ModuleId and status=1    
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END
GO

