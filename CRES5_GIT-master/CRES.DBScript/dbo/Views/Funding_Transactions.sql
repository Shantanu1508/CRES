CREATE View [dbo].[Funding_Transactions]

as
Select Noteid, ISnull(Amount,0)*-1 Amount from dbo.[TransactionEntry]
Where Type = 'FundingorRepayment'
and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
and AccountTypeID =1

