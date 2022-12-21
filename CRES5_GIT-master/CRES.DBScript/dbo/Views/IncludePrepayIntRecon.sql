Create View [dbo].IncludePrepayIntRecon
As

Select 
Noteid
, Datebi
,ISNULL(Sum_Repay_Amort,0)Sum_Repay_Amort
,StagingInterest
,IntegartionInterest
, ISNULL(StagingInterest,0)-ISNULL(IntegartionInterest,0) ActualDiff
, ISNULL(ExpectedInterestDiff ,0)ExpectedInterestDiff
from
(

Select 
Noteid
, Date
, AnalysisID
, Type
,  DateBI = Case when s.date = '10/8/2018' then '10/5/2018' else S.Date end 
,  Amount StagingInterest
from Staging_TransactionEntry S
) a
Outer apply (Select Sum_Repay_Amort, ExpectedInterestDiff from Interim2IncludePrepayInterestRecon I
				where a.Datebi = HolidateAdjustedPaymentdate and a.Noteid = I.Noteid
				)X

Outer apply (Select Amount IntegartionInterest  from Transactionentry T
				Where Type = 'InterestPaid' and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				and a.date = T.date and a.NoteID =  T.NoteID and T.Type =  a.type and T.AnalysisID = a.AnalysisID
			)Y



Where Type = 'InterestPaid' and a.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
--and a.NoteID = '1779'
--Order by date
