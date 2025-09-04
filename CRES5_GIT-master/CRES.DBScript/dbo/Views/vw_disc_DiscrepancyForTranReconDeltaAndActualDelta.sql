
CREATE view [dbo].[vw_disc_DiscrepancyForTranReconDeltaAndActualDelta] 
AS

Select 
CREDealID as DealID
,DealName
,CRENoteID as NoteID
,NoteName
,ServicerName as Servicer
,TransactionTypeText as TransactionType
,RelatedtoModeledPMTDate as DueDate
,RemittanceDate as RemitDate
,ServicingAmount
,CalculatedAmount
,OverrideValue
,Delta
,Adjustment
,WriteOffAmount
,ActualDelta
,M61Value
,ServicerValue
,Ignore
,Delta_New
,ActualDelta_New
--,'Update [Cre].[NoteTransactionDetail] set Delta = '''+CAST(Delta_New as nvarchar(256))+''',ActualDelta = '''+CAST(ActualDelta_New as nvarchar(256))+''' where NoteTransactionDetailID =  '''+CAST(NoteTransactionDetailID as nvarchar(256))+''' '


from(

Select * ,[ActualDelta_New] = (ISNULL(a.Delta_New,0) + ISNULL(a.[Adjustment],0) + ISNULL(a.WriteOffAmount,0))
from(
	Select n.NoteTransactionDetailID,n.TranscationReconciliationID
	,sm.ServicerName
	,d.DealName
	,d.CREDealID
	,acc.name as NoteName
	,n1.[CRENoteID]
	,n.[TransactionTypeText]
	,n.[RelatedtoModeledPMTDate] 
	,n.[RemittanceDate]
	,n.[ServicingAmount]
	,n.[CalculatedAmount]
	,n.[OverrideValue]
	,n.[Delta]
	,n.[Adjustment]
	,n.WriteOffAmount
	,n.[ActualDelta]
	,n.[M61Value]
	,n.[ServicerValue]
	,n.[Ignore]

	,(CASE WHEN n.[OverrideValue] IS NOT NULL and  ServicerValue <> 1 THEN (ISNULL(n.[OverrideValue],0) - ISNULL(n.[CalculatedAmount],0)) ELSE (ISNULL(n.[ServicingAmount],0) - ISNULL(n.[CalculatedAmount],0)) END) as Delta_New

	
	FROM [Cre].[NoteTransactionDetail] n
	Inner join cre.note n1 on n1.noteid = n.noteid
	Inner join cre.deal d on d.dealid = n1.dealid
	Inner join core.Account acc on acc.accountid = n1.account_accountid
	left join CRE.TransactionTypes tr on n.TransactionTypeText=tr.TransactionName
	left join Core.Lookup l ON n.OverrideReason=l.LookupID
	left join [Cre].[ServicerMaster] sm on n.[ServicerMasterID]=sm.ServicerMasterId

	WHERE acc.IsDeleted <> 1
	and ServicerName not in ('M61Addin','Modified')


)a

)z
where ( ABS((ROUND(z.[Delta],2) - ROUND(z.Delta_New,2))) > 0.1  OR ABS((ROUND(z.ActualDelta,2) - ROUND(z.ActualDelta_New,2))) > 0.1 )
and z.M61Value <> 1
--a.creNoteID = '26959'

