CREATE View [dbo].interim2FullAccrualGAAPRecon
as
Select DealName
, Status
,Noteid
 ,Monthend
 ,NonHolidayPymtDate
 , HolidateAdjustedPaymentdate
 , LIBOR
, Spread
,AllinOnecoupon
, Amount
, (AMount * AllinOnecoupon* AcrrualDays)/360 As expectedGaapDiff
from interimFuLLAccrualGAAPRecon
where AcrrualDays<>0 
--and Noteid = '1779'
--Group by 
----DealName
----, Status
----,Noteid
---- ,Eomonth(Date, 0
---- ,NonHolidayPymtDate
---- , LIBOR
----, Spread
