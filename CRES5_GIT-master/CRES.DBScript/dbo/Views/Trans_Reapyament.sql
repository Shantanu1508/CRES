CREATE View [dbo].[Trans_Reapyament]
AS

Select Crenoteid, Sum(Amount)Repayment, Type, analysisid from Cre.TransactionEntry T
Inner Join Cre.Note N on N.Noteid = T.Noteid
Where  T.Type = 'FundingOrRepayment' 
			 and  T.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
			 and isnull(Amount,0) > 0


Group by Crenoteid,  Type, analysisid

