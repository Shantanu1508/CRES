 

CREATE VIEW [dbo].[Transaction] AS

SELECT NoteID as NoteKey, CRENoteID as NoteID,Cast([Date] as Date) as TransactionDate,[Funding],[Curtailment],[Origination Fees],[Exit Fees],[Prepayment Fees],[Additional Fees],[Interest],[Balloon Payment],[Initial Funding],[Scheduled Principal]
FROM (			
		Select 
		TransactionTypeBI as TransactionType,
		tr.[Date] as [Date]
		,cast(cast(tr.Amount as DECIMAL(28,5)) as float) as [Value]
		,tr.AccountID
		,n.CRENoteID
		,n.NoteID	
		from [dw].[TransactionBI] tr
		INNER JOIN [dw].[NoteBI] n ON n.AccountID = tr.AccountID
		and tr.StatusID= 1

) as sq_up
PIVOT (
MIN([Value])
FOR TransactionType IN ([Funding],[Curtailment],[Origination Fees],[Exit Fees],[Prepayment Fees],[Additional Fees],[Interest],[Balloon Payment],[Initial Funding],[Scheduled Principal])
) as p

