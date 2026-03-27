-- Procedure
CREATE PROCEDURE [dbo].[usp_GetXIRRStatusSummaryfordevdash]    
AS    
BEGIN  
    select count(l.StatusID) as [Count],l.Name,cr.Status from cre.XIRRCalculationRequests  cr
	inner join  Core.Lookup l on l.LookupID = cr.Status
	group by cr.status,l.Name,l.StatusID
END;