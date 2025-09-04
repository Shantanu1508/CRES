  
    
CREATE View [dbo].[BalanceRollFundPay] as   
  
  
  
---OLd  
--select NoteID AS NoteKey     
--,DealName    
--,[DATE]     
--,Amount     
--,[Type]    
--,AnalysisName AS Scenario    
--,(CASE     
--WHEN [Type] in ('FundingOrRepayment') and amount > 0 THEN 'Paydown'     
--WHEN [Type] in ('FundingOrRepayment') and amount < 0 THEN 'Funding'     
--ELSE (CASE WHEN Amount < 0 THEN 'Funding' ELSE 'Paydown' END)     
--END    
--) as Amount_type       
    
--FROM [DW].[TransactionEntryBI]    
--where [Type] in ('Balloon','PikprincipalPaid','InitialFunding','FundingOrRepayment','pikprincipalfunding','scheduledprincipalpaid')    
--and AccountTypeID = 1  
  
  
---New logic  
Select n.NoteID AS NoteKey     
,d.DealName    
,tr.[DATE]     
,tr.Amount     
,tr.[Type]    
,ana.name as Scenario    
,(CASE     
WHEN [Type] in ('FundingOrRepayment') and amount > 0 THEN 'Paydown'     
WHEN [Type] in ('FundingOrRepayment') and amount < 0 THEN 'Funding'     
ELSE (CASE WHEN Amount < 0 THEN 'Funding' ELSE 'Paydown' END)     
END    
) as Amount_type  
,tr.PurposeType  
from cre.TransactionEntry tr  
inner join core.account acc on acc.accountid = tr.AccountID  
inner join cre.note n on n.Account_AccountID = acc.AccountID  
inner join Cre.Deal d on d.dealID=n.DealID  
Inner join core.Analysis ana on ana.AnalysisID = tr.AnalysisID  
Where tr.[Type] in ('InitialFunding','FundingOrRepayment','Balloon','ScheduledPrincipalPaid','PIKPrincipalFunding','PIKPrincipalPaid','PrincipalWriteoff','EquityDistribution','NetPropertyIncomeOrLoss')  
and acc.isdeleted<>1  
and acc.AccountTypeID = 1  
and tr.AnalysisID in ('C10F3372-0FC2-4861-A9F5-148F1F80804F','D8F8AF6D-B9C7-4015-A610-41D34941EEB5')  
and d.[Status] = 323  
AND d.DealName NOT LIKE '%copy%'  
  
  
  
  
---Aggregated  
--Select NoteKey   
--,DealName   
--,[DATE]   
--,SUM(Amount) as Amount    
--,Scenario   
--,Amount_type  
--From(  
-- Select n.NoteID AS NoteKey     
-- ,d.DealName    
-- ,EOMONTH(tr.[DATE] ) as [Date]    
-- ,tr.Amount    
-- ,ana.name as Scenario    
-- ,(CASE     
-- WHEN [Type] in ('FundingOrRepayment') and amount > 0 THEN 'Paydown'     
-- WHEN [Type] in ('FundingOrRepayment') and amount < 0 THEN 'Funding'     
-- ELSE (CASE WHEN Amount < 0 THEN 'Funding' ELSE 'Paydown' END)     
-- END    
-- ) as Amount_type  
-- from cre.TransactionEntry tr  
-- inner join core.account acc on acc.accountid = tr.AccountID  
-- inner join cre.note n on n.Account_AccountID = acc.AccountID  
-- inner join Cre.Deal d on d.dealID=n.DealID  
-- Inner join core.Analysis ana on ana.AnalysisID = tr.AnalysisID  
-- Where tr.[Type] in ('InitialFunding','FundingOrRepayment','Balloon','ScheduledPrincipalPaid','PIKPrincipalFunding','PIKPrincipalPaid','PrincipalWriteoff','EquityDistribution','NetPropertyIncomeOrLoss')  
-- and acc.isdeleted<>1  
-- and acc.AccountTypeID = 1  
-- and tr.AnalysisID in ('C10F3372-0FC2-4861-A9F5-148F1F80804F','D8F8AF6D-B9C7-4015-A610-41D34941EEB5')  
-- and d.[Status] = 323  
-- AND d.DealName NOT LIKE '%copy%'  
-- --and n.crenoteid = '2230'  
  
--)z  
  
--Group By  
--NoteKey   
--,DealName   
--,[DATE]   
--,Scenario   
--,Amount_type  