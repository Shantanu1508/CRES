-- View
CREATE view [dbo].[EndingBalanceAfterFinalprojectepaydown]
as

Select Dealname
,n.noteid
, di.Date
, Di.EndingBalance
from DailyBalDefault di
inner join note n on n.notekey = di.NoteID
inner Join EndingBalanceAfterFinalprojectepaydownInterim EI 
on Di.Date = EI.Date and n.noteid = Ei.crenoteid 
--and di.AnalysisID= 'c10f3372-0fc2-4861-a9f5-148f1f80804f'
--where Dealname = 'Northstar ALTO Portfolio'