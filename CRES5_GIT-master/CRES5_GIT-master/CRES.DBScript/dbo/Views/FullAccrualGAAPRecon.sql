CREATE View [dbo].FullAccrualGAAPRecon
as
Select DealName
, Status
,Noteid
 ,Monthend
 ,NonHolidayPymtDate
 , LIBOR
, Spread
,AllinOnecoupon
,HolidateAdjustedPaymentdate
, SUM(Amount)Amount
,SUM(ISNUll(expectedGaapDiff,0))expectedGaapDiff

from interim2FullAccrualGAAPRecon
--Where expectedGaapDiff <> 0 and expectedGaapDiff is not NULL
--where Noteid = '2742' 
--and Monthend = '4/30/2019'
Group by 
DealName
, Status
,Noteid
 ,Monthend
 ,NonHolidayPymtDate
 , LIBOR
, Spread
,AllinOnecoupon
,HolidateAdjustedPaymentdate
--order by HolidateAdjustedPaymentdate


-- Groups by the Month ends 
