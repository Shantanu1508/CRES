CREATE View [dbo].ExcludePrepaYUnpaidInterest_Interim1
as
Select CRENoteID, Date, Amount
,  DateAdd(month,-1, Nextaccrualdate) AccrualStartdate  
, Dateadd(d,-1,Nextaccrualdate ) AccrualEndate
,Nextaccrualdate 
, Date1 HolidayAdjustedPaymentDate 
, EOMonth (Dateadd(d,-1,Nextaccrualdate ),0) Monthend
, AccrualDays = DateDiff (d,Date,Dateadd(d,-1,Nextaccrualdate ) ) +1
, LIBOR
, Spread
, (ISNULL(LIBOR,0) + ISNULL(Spread,0)) AllinOnecoupon
from  Dw.[InterimDropDateBI] I

outer apply (Select isholidayBi
					, isholiday
					, isweekend, 
					date1 = Case when isholidayBI = 0 and IsWeekend = 0 then c.date 
					when isholidayBI = 0 and IsWeekend = 1 and DATENAME (DW, Date)= 'Saturday' Then DateAdd(Day, -1, c.Date)
					when isholidayBI = 0 and IsWeekend = 1 and DATENAME (DW, Date)= 'Sunday' Then DateAdd(Day, -2, c.Date)
					When isholidayBI = 1 and IsWeekend = 0 and DateName(Dw,DateAdd(Day, -1, c.Date)) = 'Sunday' Then DateAdd(Day, -3, c.Date)
					end 
			from CalendarBI C
		 where I.NextAccrualDate =  C.Date  
			)X

Outer Apply (Select Amount LIBOR from TransactionEntry T 
			 Where Type = 'LIBORPercentage' 
			 and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
			 and   T.NoteID = I.CRENoteID and T.Date = X.Date1
			 and T.AccountTypeID = 1
			 )Y


Outer Apply (Select T.Amount Spread from TransactionEntry T 
			 Where Type = 'SpreadPercentage' 
			 and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
			 and T.NoteID = I.CRENoteID and T.Date = X.Date1
			 and T.AccountTypeID = 1
			 )Z


--Where CRENoteID = '4525'
--- Holiday Adjustement
---Gets the LIBOR and the Spread.
--- get all in one coupon.
-- gets the accrual Day -- since exclude pre pay scenario the accrual days is +1
-- Since its is paydown convention equals to exclude prepay the accrual days for  is same for Funding and Repayment.
