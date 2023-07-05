CREATE View [dbo].[FullAccrualGAAP]
as

select CRENoteID as Noteid
, P.date Repaymentdate
, NextAccrualDate
, EOMONTH(P.Date,0)PeriodEnddate
--, dateadd(d,-1,NextAccrualDate) AccrualEndDate 
,Amount Repaymentamount
, datediff(d,p.Date, EOMONTH (NextAccrualDate,0))AccrualEndDate
, Purpose
, PreviousAccrual
, LIBOR
,Spread
, date1
,AccrualDays =Case When Day(FirstPaymentDate) =  Day (P.date) Then 0 else
(datediff(d,p.Date, EOMONTH (Nextaccrualdate,0)) +1) end 
, Case When Day(FirstPaymentDate) =  Day (P.date) Then 0
else Amount *( ISNULL(LIBOR,0) +ISNULL(Spread,0))/ 360 * (datediff(d,p.Date, EOMONTH (p.Date,0)) +1) end As GAAPVariance
from [InterinFullAccrualGAAP] p
left join Note N1 on P.CRENoteID =  N1.NoteID
outer apply (Select isholidayBi
					, isholiday
					, isweekend, 
					date1 = Case when isholidayBI = 0 and IsWeekend = 0 then c.date 
					when isholidayBI = 0 and IsWeekend = 1 and DATENAME (DW, Date)= 'Saturday' Then DateAdd(Day, -1, c.Date)
					when isholidayBI = 0 and IsWeekend = 1 and DATENAME (DW, Date)= 'Sunday' Then DateAdd(Day, -2, c.Date)
					When isholidayBI = 1 and IsWeekend = 0 and DateName(Dw,DateAdd(Day, -1, c.Date)) = 'Sunday' Then DateAdd(Day, -3, c.Date)
					end 
			from CalendarBI C
			 where P.NextAccrualDate =  C.Date  
			 )X

	Outer Apply (Select  ISNULL(Amount,0) LIBOR from TransactionEntry T
					Where P.CRENoteID  = T.NoteID and X.Date1 = T.Date
					and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' 
					and Type = 'LIBORPercentage')y

					Outer Apply (Select  ISNULL(Amount,0) Spread from TransactionEntry T
					Where P.CRENoteID  = T.NoteID and date1 = T.Date
					and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and Type = 'SpreadPercentage'
					)z



where  Amount <0 
--and Purpose <> 'Amortization'
--and Date > PreviousAccrual and Date <= EOMONTH (PreviousAccrual,0)
and Day(Date)>= 8 and Day(FirstPaymentDate) = 8
--and CRENoteID = '2230'
