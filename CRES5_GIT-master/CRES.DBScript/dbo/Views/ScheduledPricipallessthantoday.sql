CREATE view ScheduledPricipallessthantoday
As
Select Dealid, SUM(Amount) Scheduleprincipallessthantoday 
from Transactionentry T
Inner join Note n on n.noteid = T.noteid
Where Scenario = 'Default' and Type = 'ScheduledPrincipalPaid'
and (Financingsource <>'3rd Party Owned' and Financingsource<>'Co-Fund')
and Date<Getdate() 
and T.AccountTypeID = 1
--and Dealid = '18-2385'

Group by Dealid