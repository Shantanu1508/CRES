
CREATE View [dbo].[M61_CurrentBalalnce]

AS

Select N.Noteid, ISNULL(EndingBalance,0) - ISNULL(Amount,0) CurrentBalalnce, AnalysisID from [dbo].[NotePeriodicCalc] N
outer apply (Select SUM(ISNUll(Amount,0))As Amount, AnalysisID AnalysisID_TransEntry  from [dbo].TransactionEntry T
			
			 Where N.Noteid =  T.noteid and Date between DATEADD(day, 1, EoMonth(getdate(),-1))  and getdate()

			 and Type in ('FundingorRepayment', 'ScheduledPrincipalPaid')
			 and N.AnalysisID = T.AnalysisID
			 Group by T.Noteid, AnalysisId


			 )X
			 where PeriodEndDate = EOMonth(Getdate(),-1) 





