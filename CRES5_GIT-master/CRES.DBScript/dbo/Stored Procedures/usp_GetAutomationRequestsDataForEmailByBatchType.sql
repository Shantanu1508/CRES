CREATE PROCEDURE [dbo].[usp_GetAutomationRequestsDataForEmailByBatchType]        
   @BatchType nvarchar(256)    
AS        
BEGIN              
            
 SET NOCOUNT ON;              
        
       
 select d.DealID,ar.StatusID,ar.BatchID, d.CREDealID,d.DealName,ae.Message from core.AutomationExtension ae      
inner join CRE.Deal  d on d.DealID = ae.DealID      
inner join Core.AutomationRequests ar on ar.AutomationRequestsID = ae.AutomationRequestsID    
where ae.BatchID in ( select distinct(BatchID) from core.AutomationRequests ar where ar.isEmailSent=4 and BatchType =@BatchType)     
    
END 