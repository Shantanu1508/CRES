CREATE View [dbo].ExcludePrepaYUnpaidInterest_Interim2
as
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
,Interest= case 
				When Monthend >  ActualPayoffDate then 0
				when date >= DateAdd (d, day(N.Dayofthemonth)-2,DATEADD(mm, DATEDIFF(mm,0,AccrualStartdate), 0)) 
				Then Amount * (LIBOR + Spread)/ 360 * (datediff (d, I.Date, Dateadd(d,-1,Nextaccrualdate ) ) +1 )  
				end
--,Interest= case WHEN date > DateAdd (d, 13-2 ,DATEADD(mm, DATEDIFF(mm,0,AccrualStartdate), 0)) 
--				THEN Amount * (LIBOR + Spread)/ 360 * (datediff (d, I.Date, Dateadd(d,-1,Nextaccrualdate ) ) +1 )  
--				end


from ExcludePrepaYUnpaidInterest_Interim1 I
Inner Join cre.Note N on N.CRENoteID =  I.Crenoteid
Inner join core.Account  A on A.AccountID =  N.Account_AccountID
where isdeleted = 0
--and N.CRENoteID = '8175'

--Order by Monthend


---Figures out/ Calcaultes the Interest of the Transactions after the drop date.
--Ties the the interest calculated for the the activitis after the drop date to Month end
-- for example the Funding happens to be on 6/29/2019 then comuptes the interest from 6/29/2019 to 7/7/2019 
--and lines up against the 7/31/2019 month end period.

