
-- Procedure
CREATE PROCEDURE [dbo].[usp_GetDiscrepancyAutoSpreadDealWithNoUnderwriting]     
AS    
BEGIN    
 SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
    

	Select DealName as [Deal Name],CREDealID as [Deal ID],FullPayOffDate as [Full PayOff Date]  
	From(
		select Distinct d.DealName,d.CREDealID,CONVERT(varchar, tblFullPayOff.FullPayOffDate , 101) FullPayOffDate
		from cre.deal  d
		left join(  select Distinct dealid,MAX([date]) as FullPayOffDate   from cre.DealFunding where purposeid = 630  group by dealid  )tblFullPayOff on tblFullPayOff.dealid = d.dealid 
		where isdeleted <> 1 
		and EnableAutoSpreadRepayments = 1 
		and ISNULL(AutoUpdateFromUnderwriting,0) = 0  
		AND d.DealName NOT LIKE '%copy%'
	)a
  
	order by Cast(a.FullPayOffDate as date)  asc
    
    
    
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED        
END