 CREATE PROCEDURE [dbo].[usp_GetAutomationRequestsAutoForDownloadExcel]      --'All_AutoSpread_Deals'
 @BatchID int 
AS      
BEGIN            
          
 SET NOCOUNT ON; 
 select d.DealID,d.CREDealID,d.DealName,ae.Message from core.AutomationExtension ae
inner join CRE.Deal  d on d.DealID = ae.DealID
where ae.BatchID =@BatchID;


END