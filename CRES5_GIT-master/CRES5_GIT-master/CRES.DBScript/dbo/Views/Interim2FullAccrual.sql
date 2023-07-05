CREATE View [dbo].Interim2FullAccrual
As

Select 
DealName 
,NoteID
,Status
, NonHolidayPymtDate
,  HolidateAdjustedPaymentdate
,SUM(RepaymentAmount)RepaymentAmount


,SUM(ExpectedInterestDiff)ExpectedInterestDiff

from
InterimFullAccrualInterestRecon
--where Noteid = '1779'
Group By 
DealName 
,Status
,Noteid
, NonHolidayPymtDate
,  HolidateAdjustedPaymentdate
, LIBOR
, Spread
,AllinOnecoupon


--- The Transactions are group by the Payment date.
