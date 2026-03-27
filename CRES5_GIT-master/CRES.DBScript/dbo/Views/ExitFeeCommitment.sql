CREATE View ExitFeeCommitment
As

Select N.Noteid, M61AdjustedCommitment, (ISNULL(M61AdjustedCommitment,0)+ISNULL(Amount,0))ExtFeeCommitmentBI, (Amount)Scheduleprincipallessthantoday from Note N
Outer apply (Select T.Noteid, SUM(Amount)Amount from TransactionEntry T
				Where Scenario = 'Default' and Type = 'ScheduledPrincipalPaid'
				and Date<getdate()
				and N.Noteid = T.Noteid
				and T.AccountTypeID = 1
				group by T.Noteid)x