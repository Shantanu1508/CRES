

CREATE PROCEDURE [dbo].[usp_GetTransactionCategory] 
(
	@UserID UNIQUEIDENTIFIER
)
AS
BEGIN
 SET NOCOUNT ON;
 SELECT a.TransactionCategory FROM(
		--SELECT DISTINCT (CASE WHEN TransactionCategory = 'Loan Cashflow' THEN 'Default' ELSE TransactionCategory END) as TransactionCategory FROM [Cre].[TransactionTypes] 
		SELECT DISTINCT TransactionCategory FROM [Cre].[TransactionTypes] 
		UNION ALL
		SELECT 'All Cashflows' as TransactionCategory
	)a

	ORDER BY CASE WHEN [TransactionCategory] = 'Default' THEN '1'
	 WHEN [TransactionCategory] <> 'All Cashflows' THEN '2'
	ELSE [TransactionCategory] END ASC
END

