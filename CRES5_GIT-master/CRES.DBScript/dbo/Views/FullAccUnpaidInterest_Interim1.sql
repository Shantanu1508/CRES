CREATE View [dbo].[FullAccUnpaidInterest_Interim1]
as

Select CRENoteID, Date, Amount
 , DateAdd(month,-1, Nextaccrualdate)  AccrualStartdate 
, Dateadd(d,-1,Nextaccrualdate ) AccrualEndate
,Nextaccrualdate 
, Date1 HolidayAdjustedPaymentDate 
, EOMonth (Dateadd(d,-1,Nextaccrualdate ),0) Monthend
, AccrualDays = DateDiff (d,Date,Dateadd(d,-1,Nextaccrualdate ) ) +1
, LIBOR
, Spread
, (ISNULL(LIBOR,0) + ISNULL(Spread,0)) AllinOnecoupon
from  [InterimDropDate] I

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

where 
Amount > 0
--and CRENoteID = '7218'



	-- Gets the LIBOR Spread and All in One Coupon
	-- Figures out the accrual Days
	--		Since this is for Paydown conevntion "Full Acrrual" ignores the repayments (dded filter amount > 0)
	--- Does the holiday adjustment for the payment date
