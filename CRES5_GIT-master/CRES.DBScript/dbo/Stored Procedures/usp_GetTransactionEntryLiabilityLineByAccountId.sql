
--[dbo].[usp_GetTransactionEntryLiabilityLineByAccountId] '05A96B38-8B22-47B2-AA06-6C84F63C9C67'	,'C10F3372-0FC2-4861-A9F5-148F1F80804F'

CREATE Procedure [dbo].[usp_GetTransactionEntryLiabilityLineByAccountId]
(
 @AccountId uniqueidentifier,
 @AnalysisId uniqueidentifier
)
as 
BEGIN
	SET NOCOUNT ON;

IF EXISTS(Select * from cre.equity where accountid = @AccountId)
BEGIN
	select
	 tr.[Date]  
	,tr.Amount  
	,tr.[Type]  
	,tr.AllInCouponRate
	,tr.EndingBalance
	,tr.SpreadValue
	,tr.OriginalIndex
	,tr.CreatedBy  
	,tr.CreatedDate  
	,tr.UpdatedBy  
	,tr.UpdatedDate
	,(CASE WHEN tr.[Type] = 'InterestPaid' THEN ISNULL(d.DealName,'Unallocated Interest') ELSE null END) as DealName
	from cre.TransactionEntry tr
	inner jOin core.account acc on acc.AccountID = tr.AccountID
	Left join cre.deal d on d.accountid = tr.DealAccountId
	--Left Join(
	--	Select Distinct parentaccountid,Date,STRING_AGG(DealName,',') as DealName
	--	From(
	--		Select Distinct tr.parentaccountid,tr.date, d.DealName
	--		from cre.TransactionEntryLiability tr
	--		inner jOin core.account accLiTy on accLiTy.AccountID = tr.LiabilityNoteAccountID
	--		Inner join cre.liabilitynote ln on ln.accountid = tr.LiabilityNoteAccountID
	--		inner jOin cre.LiabilityNoteAssetMapping lnam on lnam.LiabilityNoteAccountId = ln.accountid
	--		left Join cre.note n on n.account_accountid = lnam.AssetAccountId
	--		left join cre.deal d on d.dealid = n.dealid
	--		where accLiTy.IsDeleted <> 1
	--		and tr.AnalysisID = @AnalysisID
	--		and tr.parentaccountid = @AccountId
	--	)z
	--	group by parentaccountid,date
	--)tbldeal on tbldeal.parentaccountid = tr.AccountId and tbldeal.Date = tr.Date
	where acc.isdeleted <> 1
	and tr.AnalysisID = @AnalysisID
	and tr.AccountId = @AccountId
	Order by tr.[Date],tr.[Type]
END
ELSE
BEGIN
	select
	 tr.[Date]  
	,tr.Amount  
	,tr.[Type] 
	,tr.AllInCouponRate 
	,tr.EndingBalance
	,tr.SpreadValue
	,tr.OriginalIndex
	,tr.CreatedBy  
	,tr.CreatedDate  
	,tr.UpdatedBy  
	,tr.UpdatedDate
	,(CASE WHEN tr.[Type] = 'InterestPaid' THEN ISNULL(d.DealName,'Unallocated Interest') ELSE null END) as DealName
	from cre.TransactionEntry tr
	inner jOin core.account acc on acc.AccountID = tr.AccountID
	Left join cre.deal d on d.accountid = tr.DealAccountId
	--Left Join(
	--	Select Distinct LiabilityAccountID,Date,STRING_AGG(DealName,',') as DealName
	--	From(
	--		Select Distinct tr.LiabilityAccountID,tr.date, d.DealName
	--		from cre.TransactionEntryLiability tr
	--		inner jOin core.account accLiTy on accLiTy.AccountID = tr.LiabilityNoteAccountID
	--		Inner join cre.liabilitynote ln on ln.accountid = tr.LiabilityNoteAccountID
	--		inner jOin cre.LiabilityNoteAssetMapping lnam on lnam.LiabilityNoteAccountId = ln.accountid
	--		left Join cre.note n on n.account_accountid = lnam.AssetAccountId
	--		left join cre.deal d on d.dealid = n.dealid
	--		where accLiTy.IsDeleted <> 1
	--		and tr.AnalysisID = @AnalysisID
	--		and tr.LiabilityAccountID = @AccountId
	--	)z
	--	group by LiabilityAccountID,date
	--)tbldeal on tbldeal.LiabilityAccountID = tr.AccountId and tbldeal.Date = tr.Date
	where acc.isdeleted <> 1
	and tr.AnalysisID = @AnalysisID
	and tr.AccountId = @AccountId
	Order by tr.[Date],tr.[Type]
END

END