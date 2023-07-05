Create View [dbo].FullAccrualInterestRecon
As

Select T.Noteid
, ISNULL(RepaymentAmount,0) Sum_Repaymt_Amort 
, T.Date Paymentdate

, T.Amount Staging_Interest
, Int_Interest IntegrationInterest
,  ISNULL(Int_Interest,0) - ISNULL(T.Amount,0) ActualDifference
, ISNULL(ExpectedInterestDiff,0)ExpectedInterestDiff
from Staging_TransactionEntry T
Outer apply (Select ExpectedInterestDiff, RepaymentAmount
					
					from Interim2FullAccrual I

				Where ISNULL(T.NoteID,'') =ISNULL(I.Noteid,'') and ISNULL(T.Date,'') =  IsNULL(HolidateAdjustedPaymentdate,'')
			
				)X
				

Outer apply (Select Amount Int_Interest from Transactionentry T1
				Where T1.NoteID = T.Noteid and T.Date =  T1.Date and
				T.Type = T1.Type and T.AnalysisID =  T1.AnalysisID
				
				)Y

				where Type = 'InterestPaid' and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				--and NoteID = '1779'
				--order by T.Date
