
 ----[dbo].[usp_UpdateLiabilityAggregateEndingBalance] 'EEC2266F-1AAF-404E-9D2A-CDBFDA82D394', 'C10F3372-0FC2-4861-A9F5-148F1F80804F'


CREATE PROCEDURE [dbo].[usp_UpdateLiabilityAggregateEndingBalance]     -- 'EEC2266F-1AAF-404E-9D2A-CDBFDA82D394', 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	@EquityAccountID UNIQUEIDENTIFIER  ,
	@AnalysisID UNIQUEIDENTIFIER
AS      
BEGIN
	
	SET NOCOUNT ON;

	/*
IF OBJECT_ID('tempdb..#tblTransEndingBalance') IS NOT NULL         
	DROP TABLE #tblTransEndingBalance;

CREATE TABLE #tblTransEndingBalance( 
	LiabilityAccountID	UniqueIdentifier NULL,	
	[Date]	Date NULL,
	EndingBalance	 Decimal(28,15) NULL	
)


INSERT INTO #tblTransEndingBalance(LiabilityAccountID,Date,EndingBalance)

Select LiabilityAccountID,Date,EndingBalance
From(

Select Distinct tr.LiabilityAccountID,[Date],NULL as EndingBalance
from cre.TransactionEntryLiability tr
inner jOin core.account acc on acc.AccountID = tr.LiabilityNoteAccountId
left Join cre.note n on n.account_accountid = tr.AssetAccountID
Inner Join core.account acc1 on acc1.AccountID = n.Account_AccountID
Inner Join cre.deal d on d.dealid = n.DealID
 
inner jOin core.account acc2 on acc2.AccountID = tr.LiabilityAccountID
Inner join core.AccountCategory ac on ac.AccountCategoryID = acc2.AccountTypeID
where acc.isdeleted <> 1  and analysisid = @AnalysisID
and tr.ParentAccountId = @EquityAccountID
and tr.LiabilityAccountID in (Select accountid from cre.Equity)

UNION ALL

Select Distinct tr.LiabilityAccountID,[Date],NULL  as EndingBalance
from cre.TransactionEntryLiability tr
inner jOin core.account acc on acc.AccountID = tr.LiabilityNoteAccountId
left Join cre.note n on n.account_accountid = tr.AssetAccountID
Inner Join core.account acc1 on acc1.AccountID = n.Account_AccountID
Inner Join cre.deal d on d.dealid = n.DealID
 
inner jOin core.account acc2 on acc2.AccountID = tr.LiabilityAccountID
Inner join core.AccountCategory ac on ac.AccountCategoryID = acc2.AccountTypeID
where acc.isdeleted <> 1  and analysisid = @AnalysisID
and tr.ParentAccountId = @EquityAccountID
and tr.LiabilityAccountID in (
	Select dt.accountid ---,acc.name as DebtName,ac.name as AccountCategory 
	from cre.Debt dt
	Inner join core.account acc on acc.accountid = dt.accountid
	inner join core.accountcategory ac on ac.AccountCategoryID = acc.accounttypeid
	where acc.IsDeleted <> 1 
	and ac.name = 'Subline'
)


--UNION ALL

--Select Distinct tr.LiabilityAccountID,[Date],NULL  as EndingBalance ----UnallocatedEquity
--from cre.TransactionEntryLiability tr
--inner jOin core.account acc on acc.AccountID = tr.LiabilityNoteAccountId
--left Join cre.note n on n.account_accountid = tr.AssetAccountID
--Inner Join core.account acc1 on acc1.AccountID = n.Account_AccountID
--Inner Join cre.deal d on d.dealid = n.DealID
 
--inner jOin core.account acc2 on acc2.AccountID = tr.LiabilityAccountID
--Inner join core.AccountCategory ac on ac.AccountCategoryID = acc2.AccountTypeID
--where acc.isdeleted <> 1  and analysisid = @AnalysisID
--and tr.ParentAccountId = @EquityAccountID  ---'EEC2266F-1AAF-404E-9D2A-CDBFDA82D394'
--and tr.LiabilityAccountID in (
--	Select dt.accountid --,acc.name as DebtName,ac.name as AccountCategory 
--	from cre.Debt dt
--	Inner join core.account acc on acc.accountid = dt.accountid
--	inner join core.accountcategory ac on ac.AccountCategoryID = acc.accounttypeid
--	where acc.IsDeleted <> 1 
--	and ac.name = 'Cash' and acc.name like '%Equity%'
--)



--UNION ALL

--Select Distinct tr.LiabilityAccountID,[Date],SublineBalance   as EndingBalance ----UnallocatedSubline
--from cre.TransactionEntryLiability tr
--inner jOin core.account acc on acc.AccountID = tr.LiabilityNoteAccountId
--left Join cre.note n on n.account_accountid = tr.AssetAccountID
--Inner Join core.account acc1 on acc1.AccountID = n.Account_AccountID
--Inner Join cre.deal d on d.dealid = n.DealID
 
--inner jOin core.account acc2 on acc2.AccountID = tr.LiabilityAccountID
--Inner join core.AccountCategory ac on ac.AccountCategoryID = acc2.AccountTypeID
--where acc.isdeleted <> 1  and analysisid = @AnalysisID
--and tr.ParentAccountId = @EquityAccountID  ----'EEC2266F-1AAF-404E-9D2A-CDBFDA82D394'
--and tr.LiabilityAccountID in (
--	Select dt.accountid --,acc.name as DebtName,ac.name as AccountCategory 
--	from cre.Debt dt
--	Inner join core.account acc on acc.accountid = dt.accountid
--	inner join core.accountcategory ac on ac.AccountCategoryID = acc.accounttypeid
--	where acc.IsDeleted <> 1 
--	and ac.name = 'Cash' and acc.name like '%Subline%'
--)



)a



Update cre.LiabilityFundingScheduleAggregate set cre.LiabilityFundingScheduleAggregate.EndingBalance = a.EndingBalance
From(
	Select LiabilityAccountID,[Date],EndingBalance 
	From #tblTransEndingBalance
)a
Where cre.LiabilityFundingScheduleAggregate.AccountID = a.LiabilityAccountID and cre.LiabilityFundingScheduleAggregate.TransactionDate = a.[Date]


Update cre.TransactionEntry set cre.TransactionEntry.EndingBalance = a.EndingBalance
From(
	Select LiabilityAccountID,[Date],EndingBalance 
	From #tblTransEndingBalance
)a
Where cre.TransactionEntry.analysisid = @AnalysisID
and cre.TransactionEntry.AccountID = a.LiabilityAccountID and cre.TransactionEntry.[Date] = a.[Date]
*/

END