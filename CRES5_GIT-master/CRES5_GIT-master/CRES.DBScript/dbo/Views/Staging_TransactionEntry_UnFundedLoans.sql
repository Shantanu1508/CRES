CREATE View [dbo].[Staging_TransactionEntry_UnFundedLoans]
as 
select 
NoteID as NoteKey,
CRENoteID as NoteID,
Date,
Amount,
--Type,
CreatedBy,
CreatedDate,
UpdatedBy,
UpdatedDate, 
Case WHEN Type = 'OriginationFee' THEN 'OriginationFeeIncludedInLevelYield' ELSE Type  End as Type

From [DW].[Staging_TransactionEntry] T
where  	 Type = 'EndingGAAPBookValue'
and CreNoteid not in ( Select Distinct N.CreNoteid
					 from DW.NoteBI N
					 inner JOin DW.transactionEntryBI tr on N.Noteid = tr.Noteid
						where tr.type not in ( 'FundingOrRepayment')  -- Unfunded Loans
						and Tr.[Date] <= EOMONTH(DateAdd(month,2,EOMONTH(n.ClosingDate))
						)  and InitialFundingAmount < 1 and tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
						) ---Unfunded Loans

