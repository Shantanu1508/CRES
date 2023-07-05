CREATE View [dbo].interimIncludeprepayGAAPRecon
as
Select 
DealName
, Status
,Noteid
, Purpose
, Date
, Day(Date) Day
, Eomonth(Date, 0)Monthend
, Amount 
, NonHolidayPymtDate
, Date1 HolidateAdjustedPaymentdate
, LIBOR
, Spread
, (ISNULL(LIBOR,0) + ISNULL(Spread,0)) AllinOnecoupon
--Use "AccrualDays" for Unpaid for Full Accrual Interest.
--, AcrrualDays= Case When Day(Date) = 8 then 0
--  else (DateDiff(DAY,  Date, Eomonth(Date, 0)) +1) End            
  
--  --Use "AccrualDays" for Unpaid for Include Prepay Interest.
----, AcrualDays= Case When Day(Date) = 8 then 0
----  else 1 End     

------ Use "AccrualDaysIntCalc" for Full accrualinterest variance.
--  --, AccrualDaysIntCalc = Case When Day(Date) = 8 then 0
--  --else (DateDiff(DAY,  Date,NonHolidayPymtDate )) End

--Use "AccrualDaysIntCalc" for Include Prepay accrualinterest variance.
--, AccrualDaysIntCalc = Case When Day(Date) = 8 then 0
--  else 1 End
, AccrualDaysIntCalc = 1

 
From Paydown_PaymentDate P
outer apply (Select isholidayBi, isholiday, isweekend, 
					date1 = Case when isholidayBI = 0 and IsWeekend = 0 then c.date 
					when isholidayBI = 0 and IsWeekend = 1 and DATENAME (DW, Date)= 'Saturday' Then DateAdd(Day, -1, c.Date)
					when isholidayBI = 0 and IsWeekend = 1 and DATENAME (DW, Date)= 'Sunday' Then DateAdd(Day, -2, c.Date)
					When isholidayBI = 1 and IsWeekend = 0 and DateName(Dw,DateAdd(Day, -1, c.Date)) = 'Sunday' Then DateAdd(Day, -3, c.Date)
						end 
				from CalendarBI C
				where P.NonHolidayPymtDate =  C.Date  
			 )X

Outer Apply (Select Amount LIBOR from TransactionEntry T 
			 Where Type = 'LIBORPercentage' 
			 and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
			 and   T.NoteID = P.Noteid and T.Date = X.Date1
			 )Y

Outer Apply (Select T.Amount Spread from TransactionEntry T 
			 Where Type = 'SpreadPercentage' 
			 and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
			 and T.NoteID = P.Noteid and T.Date = X.Date1
			 )Z
Where Day(FirstPaymentDate) = 8  and Purpose <> 'Amortization'
and Day(Date)>= 8  
--and Noteid = '1779'
