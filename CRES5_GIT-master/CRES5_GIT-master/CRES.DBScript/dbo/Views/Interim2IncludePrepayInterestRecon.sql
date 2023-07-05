CREATE View [dbo].Interim2IncludePrepayInterestRecon
As

Select DealName 
,Status
,Noteid
, SUM(RepaymentAmount)Sum_Repay_Amort
, NonHolidayPymtDate
,  HolidateAdjustedPaymentdate
, LIBOR
, Spread
, AllinOnecoupon
,SUM(ExpectedInterestDiff)ExpectedInterestDiff
, AccrualDaysIntCalc
from InterimIncludePrepayInterestRecon 


--Where Noteid = '5309'
Group By 
DealName 
,Status
,Noteid
, NonHolidayPymtDate
,  HolidateAdjustedPaymentdate
, LIBOR
, Spread
,AllinOnecoupon
,AccrualDaysIntCalc


--Transactions are grouped by the payment date.
