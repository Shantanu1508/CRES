CREATE PROCEDURE [VAL].[usp_GetValuationRequestsCount]
 
AS  
BEGIN  
  
	SET NOCOUNT ON;
   

   ------Update to Failed if running more than 20 minute----  
update val.valuationrequests set StatusID = 265,EndTime = getdate() ,ErrorMessage='Forcefully failed - calculation got stucked' where ValuationRequestsID in (  
 Select ValuationRequestsID  
 from val.valuationrequests Where StatusID = 267  
 and DateDiff(minute,StartTime,getdate()) > 15
)  
---------------------------------------------------------  
  
------Update to Processing again if Processing more than 10 min----  
update val.valuationrequests set StatusID = 292,RequestTime = getdate() ,VMMasterID = null where ValuationRequestsID in (  
 Select ValuationRequestsID  
 from val.valuationrequests Where VMMasterID is not NULL and StartTime is null and StatusID = 292  
 and DateDiff(MINUTE,RequestTime,getdate()) > 10
)  
---------------------------------------------------------  

	select count(l.StatusID) as [Count],l.Name,cr.StatusID 
	from VAL.ValuationRequests   cr
	inner join  Core.Lookup l on l.LookupID = cr.StatusID	 
	group by cr.statusid,l.Name,l.StatusID
 
END
GO

