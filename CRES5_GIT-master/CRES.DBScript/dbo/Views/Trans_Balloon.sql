-- View
CREATE View [dbo].[Trans_Balloon]
AS

Select Crenoteid, max(Amount)Balloon, Type, analysisid, max(TotalCommitment)TotalCOmmitment 
from Cre.TransactionEntry T
Inner Join Cre.Note N on  N.Account_Accountid = T.AccountID




Where  T.Type = 'Balloon' 
			 and  T.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

Group by Crenoteid,  Type, analysisid

