-- View
	
CREATE View [dbo].[MinInterestTransaction]
As
	
select N1.CRENoteID,  MIN(T1.Date) Date From [CRE].[TransactionEntry] T1
Inner Join Cre.Note N1 on N1.Account_Accountid = T1.AccountID	
Inner join core.account acc on acc.accountid = n1.account_accountid	


Where [Type] = 'InterestPaid'
and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
Group by CrenoteId	


