Create View [dbo].IncludeprepayGAAPRecon
as

Select DealName
,Status
,Noteid
, SUM(Amount) Amount
,NonHolidayPymtDate
,  HolidateAdjustedPaymentdate

, LIBOR
, Spread
,  AllinOnecoupon 
, SUM(ExepcetedInterestDifference)ExepcetedInterestDifference
from interim2IncludeprepayGAAPRecon
--Where Noteid = '1779'
Group by 
DealName
,Status
,Noteid
,NonHolidayPymtDate
,  HolidateAdjustedPaymentdate
, LIBOR
, Spread
,  AllinOnecoupon 

