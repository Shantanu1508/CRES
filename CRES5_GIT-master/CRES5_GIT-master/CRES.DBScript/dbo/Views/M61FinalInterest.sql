CREATE View [dbo].M61FinalInterest
As



select T1.Noteid, T1.Date, T1.Amount from TransactionEntry T1
Inner Join (

Select T.Noteid, MAX(Date)Date, D.Status from TransactionEntry T
Inner join NOte N on N.Noteid = T.Noteid
Inner join Deal D on N.DealKey = D.DealKey

where ActualPayoffdate between '5/8/2019' and '8/8/2019'
and T.Noteid not Like '%x%' and T.Noteid not Like '%Y%'  and  T.Noteid Not Like '%Z%'
and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
and Type = 'InterestPaid' and D.Status not like 'Phantom'
Group By T.Noteid, D.Status
)x
On X.NoteID = T1.NoteID and X.Date = T1.Date  
Inner join NOte N on N.Noteid = T1.Noteid
Inner join Deal D on N.DealKey = D.DealKey
where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' 
and T1.Type = 'InterestPaid' and D.Status not like 'Phantom'

