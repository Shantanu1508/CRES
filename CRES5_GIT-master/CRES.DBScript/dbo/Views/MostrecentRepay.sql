CREATE View MostrecentRepay
As
Select DealName, N1.Crenoteid, (T.Amount) Amount_TransactionEntry,Date 
from Cre.TransactionEntry T
Inner join Cre.Note n1 on T.AccountID = N1.Account_AccountID
Inner join cre.Deal D on d.Dealid = N1.Dealid

Where   
 Type = 'FundingOrRepayment' and T.Amount>0 and T.Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' 
 and [IsDeleted] = 0