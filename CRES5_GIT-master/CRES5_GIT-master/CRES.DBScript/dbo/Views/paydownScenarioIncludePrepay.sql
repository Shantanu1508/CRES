Create View [dbo].[paydownScenarioIncludePrepay]
as
Select 
T.Noteid
,T.Date
,ISNULL(PS.paymentDate, T.Date) PaymentdateBi
,Round(T.Amount,2) InterestPaid

,SUM(ISNULL(PS.Amount,0)) RepaymentAmount
, isnull(Ps.PaymentDate,'')PaymentDate
, NextAccrualDate

,T.Analysisid
, ISNULL(Libor,0) LIBOR, ISNULL(Spread,0)Spread
, (ISNULL(Libor,0) + ISNULL(Spread,0)) allinOneCoupon
, oneDayRepaymentInterest =SUM(ISNULL(PS.Amount,0)) * (ISNULL(Libor,0) + ISNULL(Spread,0))/ 360



from TransactionEntry T
Left Join Note N on N.Noteid = T.noteid

Left Join paydownScenario PS on T.NoteID = PS.CRENoteID and T.Date = PS.PaymentDate
Outer Apply (Select Amount Libor from TransactionEntry T1
			Where T.NoteID =  T1.NoteID and T.date = T1.date
			and Type = 'LIBORPercentage' 
			and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F')X

Outer Apply (Select Amount Spread from TransactionEntry T1
			Where T.NoteID =  T1.NoteID and T.date = T1.date
			and Type = 'SpreadPercentage' 
			and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F')y

where T.Type = 'interestPaid'
and T.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
and PS.Repaymentdate <>  Dateadd (Month, -1,NextAccrualDate)
and PS.Amount < 0
and Maturity_DateBI > GETDATE()
Group By
T.Noteid
,T.Date
,ISNULL(PS.paymentDate, T.Date) 
,Round(T.Amount,2) 
, LIBOR
,ISNULL(Spread,0)

, isnull(Ps.PaymentDate,'')
, NextAccrualDate

,Analysisid
,Amortintcalcdaycount


