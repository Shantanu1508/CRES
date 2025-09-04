CREATE view  ReapyPaydownNonWireconfirm
As
Select
Notekey
,Dealname
,n.crenoteid,MAX( Date )Date 
from NoteFundingSchedule n
Inner join note n1 on n1.noteid = crenoteid
Where Purpose = 'Paydown'   and wireconfirm = 0
group by Dealname, n.crenoteid, Notekey