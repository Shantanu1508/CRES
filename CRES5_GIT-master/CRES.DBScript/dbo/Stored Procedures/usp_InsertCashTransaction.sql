-- Procedure

CREATE PROCEDURE [dbo].[usp_InsertCashTransactions]
(
	@tbltype_CashTransactions [TableTypeCashTransactions] READONLY
)
AS
BEGIN
	TRUNCATE TABLE [dbo].[CashTransactions];
	
	INSERT INTO [dbo].[CashTransactions]([date],[Transaction Type],[Transaction]) 
	SELECT [date],TransactionType,[Transaction] FROM @tbltype_CashTransactions;

END