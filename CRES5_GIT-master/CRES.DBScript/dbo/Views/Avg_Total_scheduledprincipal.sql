CREATE View Avg_Total_scheduledprincipal
As
Select Noteid, Count(*)No, Avg_scheduleprincipal = SUM(Amount)/Count(*), TotalScheduleAmort= SUM(amount) 
from TransactionEntry T
Where scenario = 'Default' and Type = 'scheduledprincipalpaid'
and T.AccountTypeID =1
group by NOteid