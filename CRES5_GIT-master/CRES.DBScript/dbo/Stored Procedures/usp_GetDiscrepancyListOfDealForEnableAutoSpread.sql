-- Procedure
CREATE PROCEDURE [dbo].[usp_GetDiscrepancyListOfDealForEnableAutoSpread]     
AS    
BEGIN    
 SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
    
    

Select DealName,CREDealID,FullPayOffDate  
From(
	Select Distinct d.DealName,d.CREDealID,CONVERT(varchar, tblFullPayOff.FullPayOffDate , 101) FullPayOffDate  
	--,n.CRENoteID,acc.name as NoteName,CONVERT(varchar, p.Payoffdate, 101) as Payoffdate    
	from cre.Note n    
	inner join core.account acc on acc.accountid = n.account_accountid    
	inner join cre.Deal d on n.DealID = d.DealID    
	left join dbo.Payoffdate p on p.notekey = n.noteid    
	left join(  select Distinct dealid,MAX([date]) as FullPayOffDate   from cre.DealFunding where purposeid = 630  group by dealid  )tblFullPayOff on tblFullPayOff.dealid = d.dealid  
	where n.ActualPayoffdate is null     
	and acc.IsDeleted <> 1 and d.isdeleted <> 1    
	and d.Status in (323,325)    
	--and d.dealid not in (Select distinct dealid from [CRE].[DealFunding] where PurposeID = 630) --FullPayOff    
	and ISNULL(EnableAutoSpreadRepayments,0) <> 1   
)a
  
order by Cast(a.FullPayOffDate as date)  asc
    
    
    
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED        
END     


