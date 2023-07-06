CREATE View [dbo].interim2IncludeprepayGAAPRecon
AS

Select 
DealName
,Status
,Noteid
, Purpose
, Date
, Monthend
, Amount 
, NonHolidayPymtDate
,  HolidateAdjustedPaymentdate
, LIBOR
, Spread
,  AllinOnecoupon 
,AccrualDaysIntCalc
, Amount * AllinOnecoupon * AccrualDaysIntCalc/ 360 ExepcetedInterestDifference

from interimIncludeprepayGAAPRecon
Where AccrualDaysIntCalc <> 0 
--and Noteid = '1779'


 
