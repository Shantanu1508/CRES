CREATE PROCEDURE [dbo].[usp_GetDealByBatchIDAutomation] 
@BatchID int
AS
BEGIN      
    
 SET NOCOUNT ON; 
		 select ar.BatchID
		,d.DealID
		,d.DealName
		,d.CREDealID
		,l.Name as [Status] 
		from Core.AutomationRequests ar
		inner join cre.Deal d on ar.DealID=d.DealID
		left join core.Lookup l on l.LookupID = d.[Status]
		Where BatchID=@BatchID
		 Order by d.DealName

 END