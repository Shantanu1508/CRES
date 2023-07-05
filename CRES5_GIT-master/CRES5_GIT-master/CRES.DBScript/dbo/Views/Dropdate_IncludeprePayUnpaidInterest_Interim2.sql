CREATE View [dbo].[Dropdate_IncludeprePayUnpaidInterest_Interim2]
as
Select CRENoteID, Date, Amount
, DateAdd(month,-1, Nextaccrualdate) AccrualStartdate  
, Dateadd(d,-1,Nextaccrualdate ) AccrualEndate
,Nextaccrualdate 
, Date1 HolidayAdjustedPaymentDate 
, EOMonth (Dateadd(d,-1,Nextaccrualdate ),0) Monthend
, AccrualDays = Case when Amount < 0 THEN DateDiff (d,Date,Dateadd(d,-1,Nextaccrualdate ) )
		When Amount > 0 then DateDiff (d,Date,Dateadd(d,-1,Nextaccrualdate ) ) +1
		End

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
			 )Y


Outer Apply (Select T.Amount Spread from TransactionEntry T 
			 Where Type = 'SpreadPercentage' 
			 and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
			 and T.NoteID = I.CRENoteID and T.Date = X.Date1
			 )Z



	-- Gets the LIBOR Spread and All in One Coupon
	-- Figures out the accrual Days
	--		Since this is for Paydown conevntion "Include prepay" for Funding the Accrual days
	--		are different than the repayments
	---		Depending on the activity is Funding or Repayment Figures out the accrual Days.
	--- Does the holiday adjustment for the payment date


	
