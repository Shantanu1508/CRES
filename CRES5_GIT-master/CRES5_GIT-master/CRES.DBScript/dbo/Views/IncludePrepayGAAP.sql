CREATE view [dbo].[IncludePrepayGAAP]
as

Select 
T.Noteid
,T.Date 
, ISNULL(X.Amount,0)SUmRepayments
, EOMONTH (Date,-1) Periodend
, Int_UnpaidInterest
, Staging_UnpaidInterest
, LIBOR
, Spread
, ((ISNULL(X.amount,0))* (LIBOR+Spread)/360)*-1 AdjustmentInterest

, Int_UnpaidInterest - Staging_UnpaidInterest DeltaUnpaid

from TransactionEntry T
Outer apply (Select CRENoteID
					, SUM(ISNull(Amount,0))amount from NoteFundingSchedule N
				Where T.NoteID =  N.CRENoteID 
				and N.Date > Dateadd(m,-1,T.Date) and N.Date  <= EOMONTH (T.Date,-1)
				--and N.Date >= T.Date and N.Date<= EOMONTH (T.Date,0)
				and N.Amount < 0  and Day(N.Date) <> 8
				--and Purpose <> 'Amortization'
				Group By CRENoteID
				)X

Outer Apply (Select EndingGAAPBookValue Int_GAAP
				, CleanCost Int_CleanCost
				, CurrentPeriodInterestAccrualPeriodEnddate Int_UnpaidInterest
				, AccumulatedAmort Int_AccumalatedAmort 
				, PeriodEndDate
				from NotePeriodicCalc N
				Where T.NoteID = N.NoteID and EOMONTH (t.Date,-1) = EOMonth(PeriodEndDate,0)
				and PeriodEndDate = EOMONTH (PeriodEndDate,0)
				and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and T.AnalysisID = N.AnalysisID

				) Z

outer Apply (Select EndingGAAPBookValue
					, CleanCost
					, CurrentPeriodInterestAccrualPeriodEnddate Staging_UnpaidInterest
					, AccumulatedAmort 
				from Staging_Cashflow N
				Where T.NoteID = N.NoteID and EOMONTH (t.Date,-1) = EOMONTH (N.PeriodEndDate,0)
				and PeriodEndDate = EOMONTH (PeriodEndDate,0)and T.AnalysisID = N.AnalysisID
				and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				)Y

Outer Apply (Select Amount LIBOR from TransactionEntry T1
			Where Type = 'LIBORPercentage' and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
			and T.NoteID = T1.NoteID and T1.Date = T.Date
			)A



Outer Apply (Select Amount Spread from TransactionEntry T1
			Where Type = 'SpreadPercentage' and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
			and T.NoteID = T1.NoteID and T1.Date = T.Date
 

			)B

Where T.Type = 'InterestPaid' 
and T.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
--and T.NoteID = '1779' 
--Order By T.Date



