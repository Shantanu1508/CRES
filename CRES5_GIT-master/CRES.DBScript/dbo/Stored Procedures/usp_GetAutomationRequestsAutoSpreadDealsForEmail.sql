CREATE PROCEDURE [dbo].[usp_GetAutomationRequestsAutoSpreadDealsForEmail]  ---'All_AutoSpread_Deals'  
   @BatchType nvarchar(256)  
AS        
BEGIN              
            
 SET NOCOUNT ON;         


	IF(@BatchType = 'All_AutoSpread_Deals') 
	BEGIN
		select d.DealID,d.CREDealID,d.DealName,ar.StatusID,ar.BatchID,ae.Message  
		from core.AutomationExtension ae  
		inner join CRE.Deal  d on d.DealID = ae.DealID  
		inner join Core.AutomationRequests ar on ar.AutomationRequestsID = ae.AutomationRequestsID  
		where ae.BatchID in ( select distinct(BatchID) from core.AutomationRequests ar where ar.isEmailSent=4 and BatchType in ('All_AutoSpread_Deals','CommitmentDiscrepancy','Phantom_Deal') )   
	END
	ELSE
	BEGIN
		select d.DealID,d.CREDealID,d.DealName,ar.StatusID,ar.BatchID,ae.Message  
		from core.AutomationExtension ae  
		inner join CRE.Deal  d on d.DealID = ae.DealID  
		inner join Core.AutomationRequests ar on ar.AutomationRequestsID = ae.AutomationRequestsID  
		where ae.BatchID in ( select distinct(BatchID) from core.AutomationRequests ar where ar.isEmailSent=4 and BatchType =@BatchType) 
	END


        
END 


 
