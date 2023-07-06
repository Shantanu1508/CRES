CREATE View [dbo].[TransactionEntry_UnfundedLoans]
as

Select T.Noteid, T.Date,T.Amount,T.Type, T.NoteKey from DBO.Transactionentry T
Left join dbo.Note N On T.Notekey = N.NoteKey
Where Type = 'EndingGAAPBookValue' 
--and Eomonth(ClosingDate,0) <>  T.Date

and T.Noteid not in ( Select Distinct N.CreNoteid
					 from DW.NoteBI N
					 inner JOin DW.transactionEntryBI tr on N.Noteid = tr.Noteid
						where tr.type not in ( 'FundingOrRepayment')  -- Unfunded Loans
						and Tr.[Date] <= EOMONTH(DateAdd(month,2,EOMONTH(n.ClosingDate))
						)  and InitialFundingAmount < 1 and tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
						) ---Unfunded Loans




