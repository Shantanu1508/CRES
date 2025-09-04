CREATE view [dbo].[FixedAmortwithdiffamounts]
as
Select  Dealname, Count(Distinct DealName)number, status
,DealNameStatus =  Dealname + '_' + Status
from
(
Select dealname, sum(amount)amount, status from 
(
Select  T.DealName
,sum (Round(Amount,2)) amount
,Date
,Status
 from TransactionEntry T
Inner Join Note N on N.Noteid = T.Noteid
Inner join deal d on d.dealkey = n.dealkey
where Type = 'ScheduledPrincipalpaid' 
and  ISNULL(HasFixedAmort,'') = 'Yes'
And Scenario = 'Default'  
and T.AccountTypeID = 1
group by t.Dealname, date, status
)x

Group by DealName,  Round(Amount,2), status

)y
where Dealname not in ( '600 Washington', 'AutospredTest', 'Outlet Mall Portfolio copy') 
Group By dealName, status
Having count (*)>1
