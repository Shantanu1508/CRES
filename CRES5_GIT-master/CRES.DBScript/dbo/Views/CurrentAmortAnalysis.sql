CREATE View  [dbo].[CurrentAmortAnalysis]
As


Select  T.DealName
,DealNameStatus =  T.Dealname + '_' + Status
, T.Noteid
, Initialinterestaccrualenddate
, min(Date)Date
, isnull(IOterm,0)IOterm
,AmortTerm
,Status
, AmortMethodused = Case when ISNULL(MonthlyDSoverridewhenamortizing,0) <> 0 Then 'Has Monthly Override' 
		When ISNULL(HasFixedAmort,'') = 'Yes' Then 'Has Fixed Amort'
		When ISNULL(MonthlyDSoverridewhenamortizing,0) = 0  and ISnull(HasFixedAmort,'') = 'No' then 'Amort Rate'
		end
, MaturitydateBi = Case when ActualPayoffdate is null then Fullyextendedmaturitydate else actualpayoffdate end
, Dateadd (m,ioterm, Initialinterestaccrualenddate)AmortStart

 from TransactionEntry T
Inner Join Note N on N.Noteid = T.Noteid
Inner join deal d on d.dealkey = n.dealkey

where Type = 'ScheduledPrincipalpaid' 

And Scenario = 'Default'
and T.AccountTypeID = 1
group by T.Noteid,t.Dealname, IOterm, MonthlyDSoverridewhenamortizing, Initialinterestaccrualenddate
,HasFixedAmort,AmortTerm,ActualPayoffdate,Fullyextendedmaturitydate,Status

