

CREATE PROCEDURE [dbo].[usp_GetTransactionGroup] 
(
	@UserID UNIQUEIDENTIFIER
)
AS
BEGIN
 SET NOCOUNT ON;
   SELECT NULL as TransactionName, 'All Actual Transactions' as TransactionGroup 

 UNION ALL

 SELECT TransactionName, TransactionGroup  FROM [Cre].[TransactionTypes] WHERE nullif(TransactionGroup,'') IS NOT NULL


END
