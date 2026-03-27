-- View
CREATE View [dbo].[Balloon_TotalCommitment]
As

Select CreNoteid
, Sum(Amount) Balloon 
, Max(TotalCommitment) TotalCommitment 
, Isnull(Sum(Amount),0)- ISNULL(Max(TotalCommitment),0) TotalCommit_Minus_Balloon
from Cre.Note N
Inner Join CORE.Account acc on acc.accountid = n.account_accountid
Inner Join Cre.TransactionEntry T on N.Account_AccountID = T.AccountID


Where acc.accounttypeid = 1 and Type = 'Balloon' and analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

Group By N.Crenoteid

