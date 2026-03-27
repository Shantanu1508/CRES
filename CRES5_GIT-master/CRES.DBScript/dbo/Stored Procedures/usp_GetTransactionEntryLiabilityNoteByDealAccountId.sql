CREATE Procedure [dbo].[usp_GetTransactionEntryLiabilityNoteByDealAccountId]  --'18f6eeec-3822-4667-ba66-8481c915f78b','c10f3372-0fc2-4861-a9f5-148f1f80804f'
(
 @DealAccountId uniqueidentifier,
 @AnalysisId uniqueidentifier
)
as 
BEGIN
	SET NOCOUNT ON;

	select
	tr.LiabilityNoteID
	,tr.[Date]  
	,tr.Amount  
	,tr.[TransactionType]  
	,tr.EndingBalance
	,n.CRENoteID
	,AssetDate
	,AssetAmount
	,AssetTransactionType
	,tr.CreatedBy  
	,tr.CreatedDate  
	,tr.UpdatedBy  
	,tr.UpdatedDate
	,tr.AllInCouponRate
	,NULL as SublineBalance
	,NULL as EquityBalance
	,NULL as UnallocatedSubline
	,NULL as UnallocatedEquity

	from cre.TransactionEntryLiability tr
	inner jOin core.account acc on acc.AccountID = tr.LiabilityNoteAccountId
	left Join cre.note n on n.account_accountid = tr.AssetAccountID
	where acc.isdeleted <> 1
	and tr.AnalysisID = @AnalysisID
	and tr.LiabilityNoteAccountId  in (Select AccountID from cre.LiabilityNote where DealAccountID  = @DealAccountId)
	Order BY  tr.date,tr.LiabilityNoteID,tr.TransactionType
	
	
	--Order by tr.LiabilityNoteID,tr.[Date],tr.[TransactionType],n.CRENoteID
	

END
