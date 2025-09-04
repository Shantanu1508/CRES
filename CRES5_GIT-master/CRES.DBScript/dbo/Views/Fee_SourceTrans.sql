-- View
CREATE View [dbo].[Fee_SourceTrans]
as
Select CreNoteid,  ExitFee, Balloon,  Repayment 
from Cre.Note N
Inner Join Core.account acc on acc.accountid = N.Account_accountid
Cross apply (Select SUM( Amount) AS ExitFee 
				from Cre.Transactionentry T
			 Where T.AccountID = N.Account_AccountID
			 and Type = 'ExitFeeExcludedFromLevelYield'
			 and T.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
			 )x
		

 Cross apply (Select SUM( Amount) AS Balloon from Cre.Transactionentry T
			 Where T.AccountID = N.Account_AccountID



			 and Type = 'Balloon'
			 and T.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

			 )y

Cross apply (Select SUM( Amount) AS Repayment from Cre.Transactionentry T
			 Where T.AccountID = N.Account_AccountID


			 and Type = 'FundingOrrepayment' and Amount > 0
			 and T.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

			 )z
			 --Where Crenoteid = '4048'

		

