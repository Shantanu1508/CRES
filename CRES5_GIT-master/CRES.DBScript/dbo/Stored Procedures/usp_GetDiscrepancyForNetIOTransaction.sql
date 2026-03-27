-- Procedure
CREATE PROCEDURE [dbo].[usp_GetDiscrepancyForNetIOTransaction]   
AS  
BEGIN  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  

	Select * from(	
		Select d.DealName as [Deal Name], n.crenoteid as [Note ID],ana.Name as Scenario,Cast(ROUND(Sum(tr.Amount),2) as decimal(28,2)) as Amount
		from cre.TransactionEntry tr
		inner join core.account acc on acc.accountid = tr.AccountID
		inner join cre.note n on n.Account_AccountID = acc.AccountID
		
		inner join Cre.Deal d on d.dealID=n.DealID
		left join core.Analysis ana on ana.AnalysisID = tr.AnalysisID
		LEFT JOIN CORE.AnalysisParameter AP ON AP.AnalysisID = ana.AnalysisID

		Where tr.[Type] in ('InitialFunding','FundingOrRepayment','Balloon','ScheduledPrincipalPaid','PIKPrincipalFunding','PIKPrincipalPaid','PrincipalWriteoff','EquityDistribution','NetPropertyIncomeOrLoss')
		and acc.isdeleted<>1
		and n.enablem61calculations = 3
		and n.crenoteid not in ('9809','9810')
		and acc.AccountTypeID = 1
		and d.[Status] = 323
		AND d.DealName NOT LIKE '%copy%'
		AND AP.IncludeInDiscrepancy=3
		and d.WatchlistStatus <> 'REO'
		group by DealName, n.crenoteid,ana.Name

	)a where ABS(a.Amount)> 0.1   --and Scenario='Default' 
	Order by Scenario,[Deal Name], [Note ID]
  
  

 SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
END     


