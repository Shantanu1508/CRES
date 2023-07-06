CREATE View [dbo].DropdateInterim3
As

select T.CRENoteID
,date
, MAX(Amount) Ineterst
, SUM(InterestAfterDropdate)InterestAfterDropdate
, MAx(FirstPaymentDate) FirstPaymentDate
--, FundingRepayAmount
--, Round(ISNULL((Amount - InterestAfterDropdate), Amount),2) 

from Dw.TransactionEntryBI T 
Outer Apply (Select * from DropdateInterim2 I
				where T.CreNoteid =  I.creNoteid 
				and T.Date = I.HolidayAdjustedPaymentDate
			)X


Where T.Type = 'InterestPaid' 
--and T.NoteId = 'Phtm BB A' 
and AnalysisId = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  
--and CreNoteid = '8175'
group by T.CRENoteID, Date
--and InterestAfterDropdate is not null


