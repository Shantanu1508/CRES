CREATE	View [dbo].scheduledPrinconHolidayInterim
As

select 
N.Noteid
, FullyExtendedMaturitydate
, T.date
, Day(FirstPaymentDate) -  Day(T.Date) AccrualDays
, DateDiff(D, T.Date, FullyExtendedMaturitydate)Transdate_Minus_FullyExt
, T.Amount ScheduledPrincipal
, LIBOR
, spread
, Amount * (LIBOR + spread)/360 * (Day(FirstPaymentDate) -  Day(T.Date)) Interestvar
 from Note N
inner join TransactionEntry T on N.Noteid = T.Noteid
Outer apply (Select Amount LIBOR from TransactionEntry T1
				Where Type = 'LIBORPercentage' 
				and T.NoteID = T1.NoteID
				and T.Date =  T1.date
				and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				and T1.AccountTypeID = 1
				)
				X

Outer apply (Select Amount SPREAD from TransactionEntry T1
				Where  T.NoteID = T1.NoteID
				and T.Date =  T1.date and
				Type = 'SpreadPercentage' and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				and T1.AccountTypeID = 1
				)y


Where Type = 'ScheduledPrincipalPaid'
and Maturity_DateBI > Getdate()  and Day(FirstPaymentDate) = 8
and Day(T.Date) <> 8 
and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

