CREATE view [dbo].[EndingBalanceAfterFinalprojectepaydownInterim]
as
Select tblFundingPayDown.Notekey,Dealname,crenoteid,tblFundingPayDown.Date,di.Endingbalance
from(
Select
Notekey
,Dealname
,n.crenoteid
,MAX(n.Date)Date
from NoteFundingSchedule n
Inner join note n1 on n1.noteid = crenoteid
Where Purpose = 'Paydown' and wireconfirm = 0
group by Dealname, n.crenoteid, Notekey
)tblFundingPayDown
Inner join
(
Select di1.noteid,di1.date,di1.Endingbalance from [CRE].[DailyInterestAccruals] di1
Where di1.AnalysisID= 'c10f3372-0fc2-4861-a9f5-148f1f80804f'
and di1.noteid in (
Select
Distinct n1.notekey
from NoteFundingSchedule n
Inner join note n1 on n1.noteid = crenoteid
Where Purpose = 'Paydown' and wireconfirm = 0
)

) di on di.noteid = tblFundingPayDown.notekey and di.date = tblFundingPayDown.date