CREATE View [dbo].[DropdateInterim2]
as
select
I.CreNoteid
, DateAdd(month,-1, Nextaccrualdate) AccrualStartdate
, Dateadd(d,-1,Nextaccrualdate ) AccrualEndate
,datediff (d, I.Date, Dateadd(d,-1,Nextaccrualdate ) ) + 1 AccrualDays
, I.NextAccrualDate Paymentdate
, Date1 HolidayAdjustedPaymentDate
, I.NexttoNextAccrual
, I.Date FundingRepaydate
, I.Amount FundingRepayAmt
, LIBOR
,Spread
, FirstPaymentDate

--, InterestAfterDropdate

--= case when date > DateAdd (d, day(N.Dayofthemonth)-2,DATEADD(mm, DATEDIFF(mm,0,PreviousAccrual), 0)) 
--Then Amount * (LIBOR + Spread)/ 360 * (datediff (d, I.Date, Dateadd(d,-1,Nextaccrualdate ) ) +1 )  end

--, InterestAfterDropdate
--= case when InterestCalculationRuleForPaydowns = 594 and AMount< 0 then 0
--	when 
--	date >= DateAdd (d, day(N.Dayofthemonth)-2,DATEADD(mm, DATEDIFF(mm,0,PreviousAccrual), 0)) 
--	Then Amount * (LIBOR + Spread)/ 360 * (datediff (d, I.Date, Dateadd(d,-1,Nextaccrualdate ) ) +1 )  end


, InterestAfterDropdate
= case when InterestCalculationRuleForPaydowns = 594 and AMount< 0 then 0
		When InterestCalculationRuleForPaydowns = 592 and Amount < 0 and date >= DateAdd (d, day(N.Dayofthemonth)-2,DATEADD(mm, DATEDIFF(mm,0,DateAdd(month,-1, Nextaccrualdate)), 0))   
		Then Amount * (LIBOR + Spread)/ 360 * (datediff (d, I.Date, Dateadd(d,-1,Nextaccrualdate ) ) )
		when date >= DateAdd (d, day(N.Dayofthemonth)-2,DATEADD(mm, DATEDIFF(mm,0,DateAdd(month,-1, Nextaccrualdate)), 0)) 
		Then Amount * (LIBOR + Spread)/ 360 * (datediff (d, I.Date, Dateadd(d,-1,Nextaccrualdate ) ) +1 )  end


--= Case when (Month (I.Date) =  Month ( I.PreviousAccrual)) and (Day(I.Date)  > (DayoftheMonth)) Then  Amount * (LIBOR + Spread)/ 360 * (datediff (d, I.Date, Dateadd(d,-1,Nextaccrualdate ) ) +1 ) 
--		when (Month (I.Date) =  Month ( I.PreviousAccrual)) and (Day(I.Date)  = (DayoftheMonth)) THEN (Amount * ((LIBOR + Spread)/ 360 * (datediff (d, I.Date, Dateadd(d,-1,Nextaccrualdate ) ) +1 ) ))
--		When Month (I.Date) > Month ( I.PreviousAccrual) Then Amount * (LIBOR + Spread)/ 360 * (datediff (d, I.Date, Dateadd(d,-1,Nextaccrualdate ) ) +1 ) end 

, Interest


from Dw.[InterimDropDateBI] I
Inner Join cre.Note N on N.CRENoteID =  I.Crenoteid

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

	Outer Apply (Select  ISNULL(Amount,0) LIBOR from Dw.TransactionEntryBI T
					Where I.CRENoteID  = T.CRENoteID and X.Date1 = T.Date
					and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' 
					and Type = 'LIBORPercentage'
					and T.AccountTypeID = 1)y

Outer Apply (Select  ISNULL(Amount,0) Spread from Dw.TransactionEntryBI T
					Where I.CRENoteID  = T.CRENoteID and date1 = T.Date
					and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and Type = 'SpreadPercentage'
					and T.AccountTypeID = 1
					)z

Outer Apply (
				Select  ISNULL(Amount,0) Interest from Dw.TransactionEntryBI T 
					Where I.CRENoteID  = T.CRENoteID and date1 = T.Date
					and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and Type = 'InterestPaid'
					and T.AccountTypeID = 1



			)A

where 

(I.Date) <> DateAdd(month,-1, Nextaccrualdate) 
 and Purpose <> 'Amortization'
--and Day(I.Date) > DayoftheMonth 
----N.Dayofthemonth < Day(Date) and Date < = DateAdd(d,-1,NexttoNextAccrual)
--and
 --and I.CreNoteid = '4192'
 --order by date




 --Select InterestCalculationRuleForPaydowns from CRe.Note
 --Where CRENoteid = '9048'


 --select * from NoteFundingschedule
 --Where CRENoteID = '6632'


