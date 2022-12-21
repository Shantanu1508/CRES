  Create View 
  [dbo].Unfunded
  as
  Select Distinct N.CreNoteid  --'Unfunded' 
					 from DW.NoteBI N
					 inner JOin DW.transactionEntryBI tr on N.Noteid = tr.Noteid
						where tr.type not in ( 'FundingOrRepayment')  -- Unfunded Loans
						and Tr.[Date] <= EOMONTH(DateAdd(month,2,EOMONTH(n.ClosingDate)))  
						and InitialFundingAmount < 1
						and Tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
						 ---Unfunded Loans
