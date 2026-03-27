CREATE View [dbo].InterimFullAccrualInterestRecon
As

Select * from
(
Select 
DealName 
,Status
,P.Noteid
, Purpose
, P.Date Repaymentdate
,Day
, P.Amount RepaymentAmount
, NonHolidayPymtDate
,  HolidateAdjustedPaymentdate
, LIBOR
, Spread
, (ISNULL(LIBOR,0) + ISNULL(Spread,0)) AllinOnecoupon
,AccrualDaysIntCalc

, P.Amount * (ISNULL(LIBOR,0) + ISNULL(Spread,0)) *AccrualDaysIntCalc/360 as ExpectedInterestDiff



from
(

Select 
DealName
, Status
,Noteid
, Purpose
, Date
, Day(Date) Day
, Eomonth(Date, 0)Monthend
, Amount--= Case When Day(Date) = 8 then 0 else Amount end
, NonHolidayPymtDate
, Date1 HolidateAdjustedPaymentdate
, LIBOR 
,Spread 
  , AccrualDaysIntCalc = Case When Purpose = 'Amortization'then 0
						 when DaY(Date) = 8 then 0
						else (DateDiff(DAY,  Date,NonHolidayPymtDate )) End


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
								and T.AccountTypeID = 1
								)Y

					
					Outer Apply (Select T.Amount Spread from TransactionEntry T 
								 Where Type = 'SpreadPercentage' 
								and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
								and T.NoteID = P.Noteid and T.Date = X.Date1
								and T.AccountTypeID = 1
								)Z
				Where Day(FirstPaymentDate) = 8 

) P


)M
Where  AccrualDaysIntCalc <> 0 and RepaymentAmount <> 0
--and Noteid = 'Phtm BB A'


---- This query is to figure out the Holiday adjusted payment date and calculate the Interest of each paydowns
---Assumptions
------1. The calc method is always 360
------2. Only Loans having Payment date as 8th are considered
------3. When payment Date is 8th then accraul days is zero.
------4. Amortization is excluded as in Intgartion the Amort is set to Exclude prepay.

