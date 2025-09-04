--[dbo].usp_GetTranscationsAuditbyBatchID 6626
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
	where BatchLogID=@BatchID and ta.CRENoteID is  null

	union all

	Select ta.CRENoteID,
	'00000000-0000-0000-0000-000000000000',
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
	where BatchLogID=@BatchID and ta.CRENoteID is not null


 
END
