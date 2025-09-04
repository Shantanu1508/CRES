CREATE view [dbo].[NegativebalanceAmort]
as
With LoanswithScheduleprincipal as
(
Select * from
(
Select 
DealName
,Crenoteid
, Date
, endingbalance
, ScheduledPrincipal
,HighorSmallNegativebalance = Case When EndingBalance>0 Then 'Positive Balance' 
									when Round(EndingBalance,2) < 0 and Endingbalance >= -25 Then'Small Negative Balance' 
									when Round(EndingBalance,0) < -25 then 'High Negative Balance' end					
, ISNULL(endingbalance,0)- ISNULL(ScheduledPrincipal,0) Delta
from [EndingBalanceAfterFinalprojectepaydownInterim] E
Cross apply (Select T.Noteid, SUM(Amount)ScheduledPrincipal from TransactionEntry T
			Where scenario = 'Default' and Type = 'ScheduledPrincipalPaid' 
			and T.Date > E.date and e.Crenoteid = T.noteid
			and T.AccountTypeID = 1
			Group by T.Noteid
			)x
)x

)
Select  * from LoanswithScheduleprincipal