
Create View [dbo].[TransactionentrySchedulePrincipal]
As
Select  
DealName
, T.Noteid
,SUM(ISNull(T.Amount,0)) TransactEntry_ScheduledPrin

from TransactionEntry T
Where Scenario = 'Default' 
and DealName not Like '%Test%' 
and Type = 'ScheduledPrincipalPaid'
and T.date <=GETDATE()  and DealName not like '%Copy%'
Group by DealName, Noteid