
CREATE view [dbo].[vw_Disc_ForNotesFailedInCalculation] 
AS

	select 
	ana.Name as Scenario
	,d.DealName as [Deal Name]
	,d.CREDealID as [Deal ID]
	,n.CRENoteID as [Note ID]
	,acc.name as [Note Name]
	,l.name as [Status]
	from core.calculationrequests cr
	inner join core.account acc on acc.accountid = cr.accountid
	Inner join cre.note n on n.account_accountid = acc.accountid
	Inner join cre.deal d on d.dealid = n.dealid
	Left Join core.lookup l on l.lookupid = cr.statusid
	left join core.Analysis ana on ana.AnalysisID = cr.AnalysisID
	LEFT JOIN CORE.AnalysisParameter AP ON AP.AnalysisID = ana.AnalysisID
	where l.name = 'Failed'
	and  d.DealName NOT LIKE '%copy%'
	AND AP.IncludeInDiscrepancy=3
	
GO