
CREATE PROCEDURE dbo.[usp_GetAllTransactionTypeForFilter] 

AS
BEGIN
SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	select distinct TransactionType from cre.TranscationReconciliation 
				where deleted=0 
				order by TransactionType

END

