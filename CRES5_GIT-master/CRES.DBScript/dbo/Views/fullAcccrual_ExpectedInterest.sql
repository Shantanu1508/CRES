CREATE View [dbo].[fullAcccrual_ExpectedInterest]

As
Select *
,Case when Repaymentdate = dateadd(M,-1,NextAccrualDate)	Then 0
		else Amount *( ISNULL(LIBOR,0) +ISNULL(Spread,0))/ 360 * dfd end as InterestVarinace
--, Case when Purpose = 'Amortization' then 0
--	when Repaymentdate = dateadd(M,-1,NextAccrualDate)	Then 0
--else Amount *( ISNULL(LIBOR,0) +ISNULL(Spread,0))/ 360 * dfd end as InterestVarinace
from
(Select 
CRENoteID
, P.date Repaymentdate
, NextAccrualDate
, dateadd(d,-1,NextAccrualDate) AccrualEndDate
, isweekend
, isholidaybi
, date1  as PaymentDate
, Amount
,datediff(d,p.Date, NextAccrualDate)dfd
--,-- datediff(d,p.Date, dateadd(d,-1,NextAccrualDate))dfd
--, DateDiff(D,Date, NextAccrualDate) NopfAcc
,(LIBOR)LIBOR
,(Spread) SPread
, Purpose

from [paydownScenrioPaymentDate] p
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
Where  Amount<0  

union

Select 
Noteid
,T.Date
,cast(T.Date as date)
, AccrualEnddate =CASE When Day(T.Date)<> 8 Then  DateAdd(d,(8 - Day(T.Date))-1, T.Date   ) 
	   When Day(T.Date)= 8  Then DateAdd(d,-1, T.Date) End
,0
, 0
, T.Date
, Amount
,DATEDIFF(d,t.Date, DateAdd(d,(8 - Day(T.Date)), T.Date   ) )
,LIBOR
,Spread
,'None'
from TransactionEntry T 
 Outer Apply (Select  ISNULL(Amount,0) LIBOR from TransactionEntry T1
						Where T.Noteid  = T1.NoteID and T1.Date= T.Date
						and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and Type = 'LIBORPercentage')A

						 Outer Apply (Select  ISNULL(Amount,0) Spread from TransactionEntry T1
						Where T.Noteid  = T1.NoteID and T1.Date= T.Date
						and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' 
						and Type = 'SpreadPercentage')b

Where Type = 'Balloon' and   AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
and T.AccountTypeID = 1


 ) A


			
--Where  Amount<0  
--and Repaymentdate  < Getdate()
--and Repaymentdate <> dateadd(M,-1,NextAccrualDate) 

--and Purpose <> 'Amortization'
--Where CRENoteID = '6234'

