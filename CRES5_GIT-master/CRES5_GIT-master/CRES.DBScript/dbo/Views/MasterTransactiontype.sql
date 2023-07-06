CREATE view [dbo].[MasterTransactiontype]
As
Select Distinct Type from dw.transactionEntryBI
Union 
Select Distinct TYPE from [dbo].[Staging_TransactionEntry]


