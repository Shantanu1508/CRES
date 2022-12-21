CREATE View [dbo].verifyAmortOverride
as

Select  T.DealName
,DealNameStatus =  T.Dealname + '_' + Status
, T.Noteid
, MaturitydateBi = Case when ActualPayoffdate is null then Fullyextendedmaturitydate else actualpayoffdate end
,Status
, n.Totalcommitment NotelevelTotalCommitment
--, SUM(n.MonthlyDSoverridewhenamortizing) NotelevelamortOverride
, LienPosition =Case when LienPosition = 353 then 'First'
		When LienPosition = 356 then 'Mezzanine'
		When LienPosition = 357 then 'Pref Equity' end
, Min(Date)Date
, Amount GeneratedAmort
from TransactionEntry T
Inner Join Note N on N.Noteid = T.Noteid
Inner join deal d on d.dealkey = n.dealkey

where Type = 'ScheduledPrincipalpaid' 

And Scenario = 'Default'
and isnull(n.MonthlyDSoverridewhenamortizing,0) <>0

group by T.Noteid,t.Dealname , n.Totalcommitment,  Amount
,ActualPayoffdate,Fullyextendedmaturitydate,Status,LienPosition

