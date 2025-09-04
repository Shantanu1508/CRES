CREATE PROCEDURE [dbo].[usp_DeleteAutomationlogByBatchID] 
@BatchID int
AS
BEGIN      
    
 SET NOCOUNT ON; 
		 Delete
		from Core.AutomationRequests 
		Where BatchID=@BatchID
		

 END