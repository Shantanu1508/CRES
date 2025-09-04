CREATE View Avgscheduledprincipal
As
Select Noteid, Count(*)No, Avg_scheduleprincipal = SUM(Amount)/Count(*) 
from TransactionEntry T
Where scenario = 'Default' and Type = 'scheduledprincipalpaid'
and T.AccountTypeID = 1
group by NOteid