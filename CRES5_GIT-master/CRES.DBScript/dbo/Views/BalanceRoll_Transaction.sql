  
CREATE View [dbo].[BalanceRoll_Transaction] as 
Select  ana.name as Scenario
,d.DealName  
,d.credealid as DealID
,n.CRENoteID  AS NoteID 
,acc.name as NoteName
,fs.FinancingSourceName
,tr.[DATE]   
,tr.Amount   
,tr.[Type]  
  
,(CASE   
WHEN [Type] in ('FundingOrRepayment') and amount > 0 THEN 'Paydown'   
WHEN [Type] in ('FundingOrRepayment') and amount < 0 THEN 'Funding'   
ELSE (CASE WHEN Amount < 0 THEN 'Funding' ELSE 'Paydown' END)   
END  
) as Amount_type
from cre.TransactionEntry tr
inner join core.account acc on acc.accountid = tr.AccountID
inner join cre.note n on n.Account_AccountID = acc.AccountID
inner join Cre.Deal d on d.dealID=n.DealID
Inner join core.Analysis ana on ana.AnalysisID = tr.AnalysisID
left join cre.FinancingSourceMaster fs on fs.FinancingSourceMasterID = n.FinancingSourceID
Where tr.[Type] in ('InitialFunding','FundingOrRepayment','Balloon','ScheduledPrincipalPaid','PIKPrincipalFunding','PIKPrincipalPaid','PrincipalWriteoff','EquityDistribution','NetPropertyIncomeOrLoss')
and acc.isdeleted<>1
and acc.AccountTypeID = 1
and tr.AnalysisID in ('C10F3372-0FC2-4861-A9F5-148F1F80804F','D8F8AF6D-B9C7-4015-A610-41D34941EEB5')
and d.[Status] = 323
AND d.DealName NOT LIKE '%copy%'
AND [Date] >= DateADD(Year,-1,Getdate())




