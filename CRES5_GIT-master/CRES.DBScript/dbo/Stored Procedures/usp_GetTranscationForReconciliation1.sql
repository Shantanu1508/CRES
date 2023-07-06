CREATE PROCEDURE [dbo].[usp_GetTranscationForReconciliation1] 
AS
BEGIN

	select	
		tr.Transcationid,
		tr.[DateDue],
		tr.RemittanceDate,
		d.CREDealID,
		d.DealID,
			n.CRENoteID,
			n.NoteID,
			ac.Name as NoteName,
			tr.TransactionType,	
			tr.ServicingAmount,
			tr.CalculatedAmount,
			--tr.Delta,
			Case
			When ISNULL(tr.OverrideValue,0)=0  Then tr.Delta
			When ISNULL(tr.OverrideValue,0)<>0  Then tr.CalculatedAmount-tr.OverrideValue
			END as Delta,
			ISNULL(tr.Adjustment,0) as Adjustment,
			ISNULL(tr.ActualDelta,tr.Delta) as ActualDelta
			,tr.M61Value,
			tr.ServicerValue,
			tr.Ignore,
			tr.OverrideValue,
			tr.Exception,
			tr.comments,			
			0 as isRecon,			
			tr.TransactionDate,
			sm.ServicerName as 'SourceType'
	 from cre.TranscationReconciliation tr	
	left join cre.note n on n.NoteID=tr.NoteID
	left join cre.Deal d on d.DealID=n.DealID	
	inner join [CRE].[ServicerMaster] sm on sm.ServicerMasterID=tr.ServcerMasterID	
	 INNER JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
	where tr.PostedDate  is null and Deleted=0
	order by tr.M61Value desc,
			tr.ServicerValue desc,
			tr.Ignore desc,
			isnull(tr.OverrideValue,0) desc,d.CREDealID,n.CRENoteID,tr.TransactionType,tr.[DateDue]


END


--select * from  cre.TranscationReconciliation where  Deleted=0

--select * from [CRE].[ServicerMaster]

--select * from IO.L_Remittance
