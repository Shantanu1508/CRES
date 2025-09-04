
--[dbo].[usp_GetDealAutomationAuditLog]  1,20,0
Create PROCEDURE [dbo].[usp_GetDealAutomationAuditLog] 
  @PgeIndex INT,
  @PageSize INT,
  @TotalCount INT OUTPUT 
AS
BEGIN      
    
 SET NOCOUNT ON;  
 SELECT @TotalCount =  COUNT( Distinct BatchID) FROM Core.AutomationRequests; 

select Distinct ar.BatchID
,ar.BatchType
,Count(ar.DealID) as TotalDeals
,MAX(l.name) as AutomationType
,MAX((u.FirstName + ' ' + u.LastName)) as SubmittedBy
,MIN(ar.CreatedDate) as SubmittedDate
,(CASE WHEN tblRunning.BatchID is null THEN 'Completed' ELSE 'Queued' END) as [Status]
from Core.AutomationRequests ar
left join app.[user] u on u.userid = ar.CreatedBy
left join core.lookup l on l.lookupid = ar.AutomationType
lEFT JOIN(
	select Distinct BatchID,count(statusID) cnt  from Core.AutomationRequests 
	where ISNULL(statusID,292) <> 266
	group by BatchID
)tblRunning on tblRunning.batchid = ar.batchid

group by ar.BatchID,ar.BatchType,tblRunning.BatchID
having ar.BatchType<>'Phantom_Deal'
Order by ar.BatchID Desc
	OFFSET (@PgeIndex - 1)*@PageSize ROWS
	FETCH NEXT @PageSize ROWS ONLY




END