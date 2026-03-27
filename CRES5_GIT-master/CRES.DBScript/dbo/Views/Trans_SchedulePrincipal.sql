-- View
CREATE View [dbo].[Trans_SchedulePrincipal]
AS

Select Crenoteid, Sum(Amount)ScheduledPrincipal, Type, analysisid from Cre.TransactionEntry T
Inner Join Cre.Note N on N.Account_Accountid = T.AccountID
Where  T.Type = 'ScheduledPrincipalPaid' 
and  T.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

		


Group by Crenoteid,  Type, analysisid

