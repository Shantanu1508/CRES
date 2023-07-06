 

CREATE VIEW [dbo].[DailyCalc] AS

SELECT NoteID as NoteKey, CRENoteID as NoteID,Cast([Date] as Date) as TransactionDate,[Amort],[Ending Balance],[Book Value]
FROM (			
		Select 
		CalcValueBI as TransactionType,
		tr.[Date] as [Date]
		,cast(cast(tr.Amount as DECIMAL(28,5)) as float) as [Value]
		,tr.AccountID
		,n.CRENoteID	
		,n.NoteID
		from [dw].[DailyCalcBI] tr
		INNER JOIN [dw].[NoteBI] n ON n.AccountID = tr.AccountID
		

) as sq_up
PIVOT (
MIN([Value])
FOR TransactionType IN ([Amort],[Ending Balance],[Book Value])
) as p

