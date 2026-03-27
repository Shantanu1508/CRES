CREATE View [dbo].interimFuLLAccrualGAAPRecon
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
, AcrrualDays= Case When Day(Date) = 8 then 0
  else (DateDiff(DAY,  Date, Eomonth(Date, 0)) +1) End            
 
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
			 and T.AccountTypeID= 1
			 )Y

Outer Apply (Select T.Amount Spread from TransactionEntry T 
			 Where Type = 'SpreadPercentage' 
			 and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
			 and T.NoteID = P.Noteid and T.Date = X.Date1
			 and T.AccountTypeID= 1
			 )Z
Where Day(FirstPaymentDate) = 8 
and Day(Date)>= 8  
--and Noteid = 'Phtm BB A'


--Query Figures out the Holiday adjusted payment date
--Computes the accrual days for the paydown happening between the 8th (After 8th) and month ends.

-----Assumptions
--------1. When the amort or the paydown happens on the 8th then we make the accrual days equal to zero because 
				--When we compare the Exclude pre Pay Paydown to Full Accraul the Paydown happing on 8th should not matter
				--When we compare the Exclude pre pay amort to the Exclude pre pay for amort if should not matter. Basically the amortiaztion should not matter for GAAP reconcillation.
				--The differences will only happen whenever there will be the paydown happening after 8th of and to end of month including the end of the month.
