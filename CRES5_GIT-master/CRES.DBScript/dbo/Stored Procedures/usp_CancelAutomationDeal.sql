CREATE PROCEDURE [dbo].[usp_CancelAutomationDeal]    
AS  
BEGIN  
  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 
 
 Declare @max_BatchId int;
 SET @max_BatchId = (select ISNULL(MAX(BatchID),0) from Core.AutomationRequests where  AutomationType = 799)


 Delete from Core.AutomationRequests where BatchID = @max_BatchId
 Delete from core.AutomationExtension where BatchID = @max_BatchId



 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
  
  




