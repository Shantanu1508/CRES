CREATE view [dbo].FullAccUnpaidInterest_Interim2
As

Select  

I.CRENoteID
, Date
, Amount

,AccrualStartdate 
,AccrualEndate
,Nextaccrualdate
,HolidayAdjustedPaymentDate 
,Monthend
,AccrualDays
, LIBOR
, Spread
, Dayofthemonth
,Interest = ISNUll(
				case 
				When Monthend > ActualPayoffDate then 0
				when date >= DateAdd (d, day(N.Dayofthemonth)-2,DATEADD(mm, DATEDIFF(mm,0,AccrualStartdate), 0)) 
				Then Amount * (LIBOR + Spread)/ 360 * (datediff (d, I.Date, Dateadd(d,-1,Nextaccrualdate ) ) +1 )  end,0)


from FullAccUnpaidInterest_Interim1 I
Inner Join cre.Note N on N.CRENoteID =  I.Crenoteid
Inner join core.Account  A on A.AccountID =  N.Account_AccountID
where isdeleted = 0
--and N.CRENoteID = '6150X'
----Order by Monthend


---Figures out/ Calcaultes the Interest of the Transactions after the drop Date.
---		That is say the transaction (Positive Funding only since it is the Paydown convention Full Accrual) happens to be on 29 calculates interest between 29 and the follow
--		interest accrual end date.
---		Uses the correct aaccrual Days depending on if the activity is Funding or Repayment.

--Ties the the interest calculated for the the activitis after the drop date to Month end
--		for example the Funding happens to be on 6/29/2019 then computes the interest from 6/29/2019 to 7/7/2019 
--		and lines up against the 7/31/2019 month end period.
