CREATE View [dbo].Dropdate_IncludeprePayUnpaidInterest_Interim3
As
Select  I.CRENoteID, Date, Amount

,AccrualStartdate 
,AccrualEndate
,Nextaccrualdate
,HolidayAdjustedPaymentDate 
,Monthend
,AccrualDays
, LIBOR
, Spread
, Dayofthemonth
--,Interest= case when date > DateAdd (d, day(N.Dayofthemonth)-2,DATEADD(mm, DATEDIFF(mm,0,AccrualStartdate), 0)) 
--Then Amount * (LIBOR + Spread)/ 360 * (datediff (d, I.Date, Dateadd(d,-1,Nextaccrualdate ) ) +1 )  end
,Interest= case WHEN date >= DateAdd (d, day(N.Dayofthemonth)-2 ,DATEADD(mm, DATEDIFF(mm,0,AccrualStartdate), 0)) 
				THEN Amount * (LIBOR + Spread)/ 360 * AccrualDays 

				end

				
			from Dropdate_IncludeprePayUnpaidInterest_Interim2 I




				Inner Join cre.Note N on N.CRENoteID =  I.Crenoteid
--where I.CRENoteID = '9049'
--order by Monthend




---Figures out/ Calcaultes the Interest of the Transactions after the drop Date.
---		That is say the transaction happens to be on 29 calculates interest between 29 and the follow
--		interest accrual end date.
---		Uses the correct aaccrual Days depending on if the activity is Funding or Repayment.

--Ties the the interest calculated for the the activitis after the drop date to Month end
--		for example the Funding happens to be on 6/29/2019 then computes the interest from 6/29/2019 to 7/7/2019 
--		and lines up against the 7/31/2019 month end period.
