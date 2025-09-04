CREATE view [dbo].[MasterTransactiontype]
As
Select Distinct Type from dw.transactionEntryBI where AccountTypeID = 1
Union 
Select Distinct TYPE from [dbo].[Staging_TransactionEntry]


