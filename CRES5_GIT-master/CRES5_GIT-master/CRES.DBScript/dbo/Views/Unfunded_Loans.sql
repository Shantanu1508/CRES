CREATE View [dbo].[Unfunded_Loans]
As

Select * from DBO.TransactionEntry
where Noteid in (Select Distinct N.CreNoteid
				from DW.NoteBI N
				inner JOin DW.transactionEntryBI tr on N.Noteid = tr.Noteid
				where tr.type not in ( 'FundingOrRepayment')  and 
				Tr.[Date] <= EOMONTH(DateAdd(month,2,EOMONTH(n.ClosingDate)))  and InitialFundingAmount < 1 and tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				)
				and Type = 'EndingGAAPBookValue'


