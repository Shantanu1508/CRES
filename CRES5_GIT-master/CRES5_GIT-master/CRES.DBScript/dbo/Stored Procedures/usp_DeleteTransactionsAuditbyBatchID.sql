--[dbo].usp_GetTranscationsAuditbyBatchID 87
Create PROCEDURE [dbo].usp_DeleteTransactionsAuditbyBatchID
@BatchID int	
AS
BEGIN
	SET NOCOUNT ON;

	update cre.TransactionAuditLog 
	set IsDeleted=1
	where BatchLogID=@BatchID



 
END
