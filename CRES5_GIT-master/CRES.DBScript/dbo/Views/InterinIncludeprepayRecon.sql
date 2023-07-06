Create View [dbo].InterinIncludeprepayRecon
As
Select * from
(
Select 
DealName 
Status
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

, E.amount IntInterestAmount
, Q.Amount StagingInterestamount
, P.Amount * (ISNULL(LIBOR,0) + ISNULL(Spread,0)) *AccrualDaysIntCalc/360 as ExpectedInterestDiff
,( Q.Amount  - E.amount)ActualIntegrationVsStagingDelta



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
, Amount 
, NonHolidayPymtDate
, Date1 HolidateAdjustedPaymentdate
, LIBOR = Case when Date1 = '10/5/2018' then 0.02133 else LIBOR end 
,Spread = Case when Date1 = '10/5/2018' then 0.0400 else Spread end 

--Use "AccrualDays" for Unpaid for Full Accrual Interest.
--, AcrualDays= Case When Day(Date) = 8 then 0
--  else (DateDiff(DAY,  Date, Eomonth(Date, 0)) +1) End            
  
--  --Use "AccrualDays" for Unpaid for Include Prepay Interest.
--, AcrualDays= Case When Day(Date) = 8 then 0
--  else 1 End     

---- Use "AccrualDaysIntCalc" for Full accrualinterest variance.
  , AccrualDaysIntCalc = Case When Day(Date) = 8 then 0
  else (DateDiff(DAY,  Date,NonHolidayPymtDate )) End

----Use "AccrualDaysIntCalc" for Include Prepay accrualinterest variance.
--, AccrualDaysIntCalc = Case When Day(Date) = 8 then 0
--  else 1 End
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
Where Day(FirstPaymentDate) = 8 

) P

Outer apply (Select * from(
				Select NoteID
				, Date
				, DateBI= Case when Date = '10/8/2018' then '10/5/2018' else Date end
				, Amount 
				, AnalysisID
				from Staging_transactionentry
				Where Type = 'InterestPaid' and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				
				)A
				Where P.Noteid =  A.NoteID and P.HolidateAdjustedPaymentdate = A.Date
				)Q

Outer apply (Select * from(
				Select NoteID
				, Date
				, DateBI= Case when Date = '10/8/2018' then '10/5/2018' else Date end
				, Amount 
				, AnalysisID
				from TransactionEntry
				Where Type = 'InterestPaid' and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				
				)D
				Where P.Noteid =  D.NoteID and P.HolidateAdjustedPaymentdate = D.Date
				)E
)M
Where  AccrualDaysIntCalc <> 0

---- 
