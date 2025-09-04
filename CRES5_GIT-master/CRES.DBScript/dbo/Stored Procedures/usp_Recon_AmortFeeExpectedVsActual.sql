CREATE PROCEDURE [dbo].[usp_Recon_AmortFeeExpectedVsActual]
AS  
BEGIN  
  
	SET NOCOUNT ON;


	IF OBJECT_ID('tempdb..[##Tbl1]') IS NOT NULL
	DROP TABLE ##Tbl1

	Select DealID, DealName, a.CRENoteID, AmortOfDeferredFee, a.IncFee_FeeRecv, ISNULL(AmortOfDeferredFee-a.IncFee_FeeRecv,0) as Delta
	into ##Tbl1
	from (
	Select d.dealName as DealName, CREDealID as DealID, n.CRENoteID, SUM(ISNULL(TotalAmortAccrualForPeriod,0)) as AmortOfDeferredFee, tr.IncFee_FeeRecv 
	FROM Cre.NotePeriodicCalc np
	 Inner join core.account acc on acc.accountid = np.AccountID
    Inner join cre.note n on n.account_accountid = acc.accountid and acc.AccounttypeID = 1
     
		--left join cre.note n on n.NoteID=np.NoteID
		left join cre.deal d on d.DealID=n.DealID
		left join (
				select CRENoteID, SUM(IncFee_FeeRecv) IncFee_FeeRecv from (
				Select CRENoteID, Type,
				--case when Type Like '%IncludedInLevelYield' then 1 when Type in ( 'OriginationFeeStripReceivable', 'Discount/Premium', 'CapitalizedClosingCost') then 1 when Type in ('ExitFeeStripReceivable', 'ExtensionFeeStripReceivable') then 0 else 1000000000 end
				ISNULL(SUM (te.Amount),0) as IncFee_FeeRecv 
				FROM CRE.TransactionEntry te
				 Inner join core.account acc on acc.accountid = te.AccountID
                 Inner join cre.note n on n.account_accountid = acc.accountid

				--left join cre.note n on te.NoteID=n.NoteID
				--inner join core.account acc on acc.accountid = n.account_accountid
				left join core.lookup lstatus on lstatus.lookupid = acc.StatusId
				where (Type Like '%IncludedInLevelYield' OR Type in ('OriginationFeeStripping', 'OriginationFeeStripReceivable'))
				--and CRENoteID='15185'
				and te.AnalysisID='c10f3372-0fc2-4861-a9f5-148f1f80804f'
				and acc.IsDeleted<>1
				 and acc.AccounttypeID = 1
				group by CRENoteID, Type) fee
	group by CRENoteID) tr on tr.CreNoteID= n.CRENoteID
	Where AnalysisID='c10f3372-0fc2-4861-a9f5-148f1f80804f' and np.Month is Not Null --and n.CRENoteID='11077'
	group by CREDealID, DealName, n.CRENoteID, tr.IncFee_FeeRecv) a
	order by DealName, CRENoteID

	select* from ##Tbl1 order by DealName, CRENoteID
	--select n.CRENoteID, ActualPayoffDate from cre.Note n where ActualPayoffDate is not null

END