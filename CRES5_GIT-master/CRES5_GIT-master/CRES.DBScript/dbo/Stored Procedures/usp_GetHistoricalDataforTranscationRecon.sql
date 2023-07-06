


CREATE Procedure [dbo].usp_GetHistoricalDataforTranscationRecon

AS

BEGIN
	SET NOCOUNT ON;

	select	
		tr.Transcationid,
		tr.[DateDue],
		tr.RemittanceDate,
		d.CREDealID,
		d.DealID,
			n.CRENoteID,
			n.NoteID,
			tr.TransactionType,	
			tr.ServicingAmount,
			tr.CalculatedAmount,
			tr.Delta,
			tr.M61Value,
			tr.ServicerValue,
			tr.Ignore,
			tr.OverrideValue,
			tr.comments,			
			1 as isRecon
	 from cre.TranscationReconciliation tr
	left join cre.note n on n.NoteID=tr.NoteID
	left join cre.Deal d on d.DealID=n.DealID		
	where tr.PostedDate  is not null
	order by d.CREDealID,n.CRENoteID,tr.TransactionType,tr.[DateDue]


	END