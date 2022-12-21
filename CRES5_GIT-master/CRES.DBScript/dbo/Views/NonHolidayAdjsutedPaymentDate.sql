CREATE View [dbo].NonHolidayAdjsutedPaymentDate
as

Select 
T.Noteid
,T.Date 
, Case when Day(T.Date) -  8 <> 0  Then DateAdd( d,    8-Day(T.Date),  T.Date )
  else T.date
end as NonHolidayAdjustedPaymentDate
--, ISNULL(X.Amount,0)Repayments
--, X.Date
--, EOmonth (T.date,0) accrualenddate
--,DateDIFF(d, X.Date,EOmonth (T.date,0)  ) +1 as AccrualDays
--, EOMONTH (Date,0) Periodend
--, Int_UnpaidInterest
--, Staging_UnpaidInterest
--, LIBOR
--, Spread
--, ((ISNULL(X.amount,0))* (LIBOR+Spread)/360)*-1 AdjustmentInterest

--, Int_UnpaidInterest - Staging_UnpaidInterest DeltaUnpaid

from TransactionEntry T
--Outer apply (Select CRENoteID
--,date
--					, (ISNull(Amount,0))amount
--					, Purpose from NoteFundingSchedule N
--				Where T.NoteID =  N.CRENoteID 
--				and N.Date Between T.Date and EOMONTH (T.Date)
--				--and N.Date >= T.Date and N.Date<= EOMONTH (T.Date,0)
--				and N.Amount < 0 and Purpose <>  'Amortization'
			
--				)X


where T.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' 
--and T.Noteid = '1779'
and Type = 'InterestPaid' 
