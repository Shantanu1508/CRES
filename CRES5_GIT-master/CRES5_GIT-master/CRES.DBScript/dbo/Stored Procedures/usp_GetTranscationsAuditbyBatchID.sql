--[dbo].usp_GetTranscationsAuditbyBatchID 87
Create PROCEDURE [dbo].usp_GetTranscationsAuditbyBatchID
@BatchID int	
AS
BEGIN
	SET NOCOUNT ON;

	Select n.CRENoteID,
	n.NoteID,
	(CASE WHEN ta.Status = 'Ignore Paydowns' THEN 'FundingOrRepayment' WHEN ta.Status = 'Ignore Pik Principal Paid' THEN 'PIKPrincipalPaid' ELSE ta.TransactionType END ) TransactionType,
	ta.DueDate,
	ta.RemitDate,
	ta.ServicingAmount,
	ta.Comment,
	ta.TotalRemit,
	ta.Status,
	sm.ServicerName as 'SourceType',
	ta.TransactionDate from cre.TransactionAuditLog ta
	left join [CRE].[ServicerMaster] sm on sm.ServicerMasterID=ta.ServicerMasterID 
	left join cre.note n on n.NoteID=ta.NoteID
	where BatchLogID=@BatchID


 
END
