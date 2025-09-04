CREATE view  [dbo].[Diffmaturitydates]
as

Select dealname, count (Distinct Dealname)Number, Status

,DealNameStatus =  Dealname + '_' + Status
from
(

Select 
T.DealName
,DealNameStatus =  T.Dealname + '_' + Status
, MaturitydateBi = Case when ActualPayoffdate is null then Fullyextendedmaturitydate 
else Actualpayoffdate end
, MAX(date) Date
, Status
 from TransactionEntry T
Inner Join Note N on N.Noteid = T.Noteid
Inner join deal d on d.dealkey = n.dealkey
where [Type] = 'ScheduledPrincipalPaid' 
and Scenario = 'Default'
and T.AccountTypeID = 1

group by 
t.Dealname
,ActualPayoffdate
,Fullyextendedmaturitydate
,Status
)x
where DealName <> 'Spectrum Commerce Center'
group by dealname, Status
Having count (*)>1
