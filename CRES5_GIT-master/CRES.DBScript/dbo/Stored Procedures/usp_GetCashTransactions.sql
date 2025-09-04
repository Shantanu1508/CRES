CREATE PROCEDURE [dbo].[usp_GetCashTransactions]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
	[Date], 
	[Transaction Type], 
	[Transaction] 
	FROM [dbo].[CashTransactions]
END
GO

