CREATE View [dbo].[PaymentDate_Balance]
As
Select Date, Crenoteid,Balance, crenoteid+'_'+CONVERT (VARCHAR(10),Date, 110) NoteID_Date  from [Paymentdate] P
outer apply (Select SUM(Amount)*-1 balance from TransactionEntry T
			 where P.Crenoteid = T.Noteid and T.Date <= P.Date
			 and Type in  ('ScheduledPrincipalPaid', 'FundingorRepayment', 'InitialFunding', 'PIKPrincipalFunding') 
			 and T.AccountTypeID = 1
			 )x