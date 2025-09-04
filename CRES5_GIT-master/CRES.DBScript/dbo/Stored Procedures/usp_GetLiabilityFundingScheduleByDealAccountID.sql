-- Procedure
CREATE PROCEDURE [dbo].[usp_GetLiabilityFundingScheduleByDealAccountID] --'c5c2cd90-2321-4b2a-8ba4-9e3c273ed3ac'
	@DealAccountID UNIQUEIDENTIFIER 
AS
BEGIN


Declare @CalcAsOfDate date;	
	SET @CalcAsOfDate = ISNULL((Select MAX(TransactionDate) from CRE.LiabilityFundingScheduleAggregate where AccountID in (
			Select distinct ln.LiabilitytypeID
			from cre.LiabilityNote ln  
			Inner Join core.Account acc on acc.AccountID = ln.AccountID  
			Where acc.IsDeleted <> 1  
			and ln.DealAccountID  =  @DealAccountID
			--in (
			--	Select ln.AssetAccountID
			--	from cre.LiabilityNote ln  
			--	Inner Join core.Account acc on acc.AccountID = ln.AccountID  
			--	left join cre.note n on n.account_accountid= acc.accountid
			--	Inner Join cre.deal d on d.dealid = n.DealID
			--	Where acc.IsDeleted <> 1  
			--	and d.AccountID = @DealAccountID
			--)
		)
	),'1/1/1900')


Select 
LiabilityFundingScheduleID
,LiabilityNoteAccountID
,LiabilityNoteID
,LiabilityNoteName
,TransactionDate
,TransactionAmount
,WorkFlowStatus
,GeneratedBy
,Applied
,Comments
,AssetAccountID
,AssetName
,AssetTransactionDate
,AssetTransactionAmount
,TransactionAdvanceRate
,CumulativeAdvanceRate
,AssetTransactionComment
,RowNo
,GeneratedByText
,GeneratedByUserID
,TransactionTypes
,crenoteid
From(
	select tr.LiabilityFundingScheduleID
	,tr.LiabilityNoteAccountID
	,ln.LiabilityNoteID
	,acc.Name as LiabilityNoteName
	,tr.TransactionDate
	,tr.TransactionAmount
	,null as WorkFlowStatus
	,null as GeneratedBy
	,CAST(tr.Applied as bit) as Applied
	--,lStatus.name as StatusText
	,tr.Comments
	,tr.AssetAccountID
	,acc.Name as [AssetName]
	,tr.AssetTransactionDate
	,tr.AssetTransactionAmount
	,tr.TransactionAdvanceRate
	,tr.CumulativeAdvanceRate
	,tr.AssetTransactionComment
	,tr.RowNo
	,null as GeneratedByText
	,null as GeneratedByUserID
	,tr.TransactionTypes
	,n.crenoteid
	From CRE.LiabilityFundingSchedule tr
	left join core.account acc on acc.accountid = tr.AssetAccountID
	left join cre.note n on n.account_accountid= acc.accountid
	Inner Join cre.deal d on d.dealid = n.DealID
	inner join cre.liabilitynote ln on ln.accountid = tr.LiabilityNoteAccountID
	Where d.AccountID = @DealAccountID
	and tr.TransactionDate <= @CalcAsOfDate

	UNION ALL 

	select 0 as LiabilityFundingScheduleID
	,tr.LiabilityNoteAccountID
	,tr.LiabilityNoteID
	,acc.Name as LiabilityNoteName
	,tr.date as TransactionDate
	,tr.amount as TransactionAmount
	,null as WorkFlowStatus
	,null as GeneratedBy
	,CAST(0 as bit) as Applied
	--,lStatus.name as StatusText
	,null as Comments
	,tr.AssetAccountID
	,acc.Name as [AssetName]
	,tr.AssetDate as  AssetTransactionDate
	,tr.AssetAmount as  AssetTransactionAmount
	,null as  TransactionAdvanceRate
	,null as  CumulativeAdvanceRate
	,null as AssetTransactionComment
	,null as RowNo
	,null as GeneratedByText
	,null as GeneratedByUserID
	,tr.TransactionType as TransactionTypes
	,n.crenoteid
	From CRE.transactionentryLiability tr
	left join core.account acc on acc.accountid = tr.AssetAccountID
	left join cre.note n on n.account_accountid= acc.accountid
	Inner Join cre.deal d on d.dealid = n.DealID
	Where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	and d.AccountID = @DealAccountID
	and tr.date > @CalcAsOfDate

)a
order by a.TransactionDate

--Select 
--ls.LiabilityFundingScheduleID
--,ls.LiabilityNoteAccountID
--,ln.LiabilityNoteID
--,acc.Name as LiabilityNoteName

--,ls.TransactionDate
--,ls.TransactionAmount
--,null as WorkFlowStatus

--,ls.GeneratedBy
--,CAST(ls.Applied as bit) as Applied
----,lStatus.name as StatusText

--,ls.Comments
--,ls.AssetAccountID
--,acca.AssetName as [AssetName]
--,ls.AssetTransactionDate
--,ls.AssetTransactionAmount
--,ls.TransactionAdvanceRate
--,ls.CumulativeAdvanceRate
--,ls.AssetTransactionComment
--,ls.RowNo
--,(CASE WHEN ls.GeneratedBy = 822 THEN  tblGeneratedBy_Name.[Login] ELSE lGeneratedBy.name END) as GeneratedByText
--,tblGeneratedBy_Name.GeneratedByUserID
--,ls.TransactionTypes

--From CRE.LiabilityFundingSchedule ls
--Inner Join cre.LiabilityNote ln on ls.LiabilityNoteAccountID = ln.Accountid
--Inner Join core.account acc on acc.accountID = ln.AccountID
--Left Join CORE.Lookup lGeneratedBy on lGeneratedBy.lookupid = ls.GeneratedBy

--Left Join (
--	Select AssetAccountID,AssetName
--	From(
--		SELECT d.DealName as AssetName,acc.AccountID as AssetAccountID
--		FROM CRE.Deal AS d
--		INNER JOIN Core.Account AS acc ON acc.AccountID = d.AccountID
--		WHERE acc.IsDeleted <> 1 and acc.AccountID = @DealAccountID

--		UNION ALL

--		SELECT n.CRENoteID as AssetName,acc.AccountID as AssetAccountID
--		FROM CRE.Note AS n
--		INNER JOIN Core.Account AS acc ON acc.AccountID = n.Account_AccountID
--		WHERE acc.IsDeleted <> 1
--		and n.DealID = (Select dealid from cre.deal where AccountID= @DealAccountID)
--	)z
--)acca on acca.AssetAccountID = ls.AssetAccountID

--Left Join(
--	Select ls.LiabilityFundingScheduleID, u.[Login],ls.GeneratedByUserID
--	from [CRE].[LiabilityFundingSchedule] ls
--	Inner Join cre.LiabilityNote ln on ls.LiabilityNoteAccountID = ln.Accountid
--	left join app.[user] u on u.userid = ls.GeneratedByUserID
--	Where ln.DealAccountID = @DealAccountID
--	and ls.GeneratedBy = 822
--)tblGeneratedBy_Name on tblGeneratedBy_Name.LiabilityFundingScheduleID = ls.LiabilityFundingScheduleID


--Where ln.DealAccountID = @DealAccountID

--ORDER BY ls.TransactionDate,ISNULL(NULLIF(CAST(ls.applied as int),0),99),ls.TransactionTypes,acca.AssetName


END