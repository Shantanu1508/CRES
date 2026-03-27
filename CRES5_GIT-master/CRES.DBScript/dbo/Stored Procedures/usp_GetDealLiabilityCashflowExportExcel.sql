CREATE Procedure [dbo].[usp_GetDealLiabilityCashflowExportExcel]  --5c5677d1-d5cb-467c-ba1d-21f4dc5e2cb0','c10f3372-0fc2-4861-a9f5-148f1f80804f'
(
 @DealAccountId uniqueidentifier,
 @AnalysisId uniqueidentifier
)
as 
BEGIN
	SET NOCOUNT ON;

	Declare @tblTransactionentry as table(
	AnalysisID UNIQUEIDENTIFIER,
	ParentAccountID UNIQUEIDENTIFIER,
	AccountId UNIQUEIDENTIFIER,	
	LiabilityAccountId_Of_CashAccID	 UNIQUEIDENTIFIER,
	[Date] date ,
	[Type]	nvarchar(256),
	Amount	decimal(28,15),
	EndingBalance	decimal(28,15),
	AccountTypeID int
	)

	INSERT INTO @tblTransactionentry(AnalysisID,ParentAccountId,AccountId,LiabilityAccountId_Of_CashAccID,Date,Type,Amount,EndingBalance,AccountTypeID)
	select tr.AnalysisID
	,tr.ParentAccountId
	,tr.AccountId
	,ISNULL(tblChAcc.AccountID,tr.AccountId) as [LiabilityAccountId_Of_CashAccID]
	,tr.Date
	,tr.[Type] 
	,tr.Amount
	,tr.EndingBalance
	,acc.AccountTypeID
	from cre.TransactionEntry tr
	inner join core.account acc on acc.AccountID = tr.AccountId
	Left Join(
		Select AccountID,PortfolioAccountID,[Text],[Type]
		From(
			Select acc.AccountID as AccountID,d.PortfolioAccountID,acc.name as [Text] ,'Debt' as [Type]  
			from cre.Debt d   
			Inner Join core.Account acc on acc.AccountID =  d.AccountID   
			where  IsDeleted<> 1   
  
			UNION ALL    
  
			Select acc.AccountID as AccountID,d.PortfolioAccountID,acc.name as [Text] ,'Equity' as [Type]  
			from cre.Equity d   
			Inner Join core.Account acc on acc.AccountID =  d.AccountID   
			where IsDeleted<> 1 
		)z
	)tblChAcc on tblChAcc.PortfolioAccountID = tr.AccountId
	where acc.isdeleted <> 1
	and tr.AnalysisID = @AnalysisId
	and tr.AccountID  in (
		Select liabilitytypeid from cre.liabilitynote where dealaccountid = @DealAccountId
		UNION
		Select portfolioaccountid from cre.equity where accountid in (Select liabilitytypeid from cre.liabilitynote where dealaccountid = @DealAccountId)
		UNION
		Select portfolioaccountid from cre.debt where accountid in (Select liabilitytypeid from cre.liabilitynote where dealaccountid = @DealAccountId)
	)


	select Distinct
	 ff.FundName as Fund
	,tblLibtype.FacilityName as Facility
	,d.DealName as Deal_Name
	,tr.LiabilityNoteID as Liability_ID
	,tr.[Date] as Transaction_Date
	,tr.Amount as Transaction_Amount
	,tr.[TransactionType] as Transaction_Type
	,tr.EndingBalance as Ending_Balance
	,tr.AllInCouponRate as Effective_Rate
	,tblEqBls.EndingBalance as Equity_Balance
	,tblSubBls.EndingBalance as Subline_Balance
	,tblEqUnallocBls.Amount as Unallocated_Equity
	,tblSubUnallocBls.Amount as Unallocated_Subline
	
	--,n.CRENoteID as Asset_ID
	--,AssetDate as Asset_Date
	--,AssetAmount as Asset_Amount
	--,AssetTransactionType as AssetTransactionType

	from cre.TransactionEntryLiability tr
	inner join core.account acc on acc.AccountID = tr.LiabilityNoteAccountId
	left join cre.liabilitynote li on li.AccountID = tr.LiabilityNoteAccountId
	INNER JOIN cre.liabilitynoteassetmapping la ON li.AccountID = la.LiabilityNoteAccountId
	left Join cre.note n on n.account_accountid = la.AssetAccountId	
	left Join cre.deal d on d.dealid = n.DealID

	left join (
		SELECT Distinct sub.FundName,sub.LiabilityTypeID as Fund,ln.LiabilityNoteID,ln.AccountID
		FROM cre.liabilitynote ln
		Inner join cre.deal d on d.AccountID = ln.DealAccountID
		INNER JOIN cre.liabilitynoteassetmapping la ON ln.AccountID = la.LiabilityNoteAccountId
		INNER JOIN (
		SELECT acceq.name as FUndName,LiabilityTypeID,am.AssetAccountId AS assetnotesid
		FROM cre.liabilitynote l
		INNER JOIN cre.liabilitynoteassetmapping am ON l.AccountID = am.LiabilityNoteAccountId
		Inner join cre.equity eq on eq.accountid = l.LiabilityTypeID
		Inner JOIN core.Account acceq on eq.accountid = acceq.AccountID
		) sub ON la.AssetAccountId = sub.assetnotesid
		LEFT JOIN core.Account a on ln.LiabilityTypeID = a.AccountID	
		where a.IsDeleted <> 1
	)ff on ff.AccountID = tr.LiabilityNoteAccountId

	Left Join(
	Select acc.AccountID as AccountID,acc.name as FacilityName
	from cre.Debt d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	INNER JOIN Core.AccountCategory AC on AC.AccountCategoryID = acc.AccountTypeID 
	where IsDeleted<> 1
	UNION ALL
	Select acc.AccountID as AccountID,acc.name as FacilityName 
	from cre.Equity d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	INNER JOIN Core.AccountCategory AC on AC.AccountCategoryID = acc.AccountTypeID 
	where IsDeleted<> 1

	UNION ALL
	Select acc.AccountID as AccountID,acc.name as FacilityName
	from cre.Cash d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	INNER JOIN Core.AccountCategory AC on AC.AccountCategoryID = acc.AccountTypeID 
	where IsDeleted<> 1
)tblLibtype on tblLibtype.AccountID = li.LiabilityTypeID


Left Join(
		select
		tr.AccountId
		,tr.Date
		,tr.[Type] 
		,tr.EndingBalance
		,acc.AccountTypeID
		from @tblTransactionentry tr
		inner jOin core.account acc on acc.AccountID = tr.AccountId
		where acc.isdeleted <> 1
		and tr.AnalysisID = @AnalysisId
		--and tr.ParentAccountID  = @AccountId
		and tr.AccountId not in (Select AccountId from cre.cash)
		--and tr.Date ='03/24/2022'
		and tr.Type like '%equity%'
	)tblEqBls on tblEqBls.AccountId = li.LiabilityTypeID and tblEqBls.Date = tr.[Date] ---and tblBls.AccountTypeID = z.AccountTypeID

	Left Join(
		select
		tr.AccountId
		,tr.Date
		,tr.[Type] 
		,tr.EndingBalance
		,acc.AccountTypeID
		from @tblTransactionentry tr
		inner jOin core.account acc on acc.AccountID = tr.AccountId
		where acc.isdeleted <> 1
		and tr.AnalysisID = @AnalysisId
		--and tr.ParentAccountID  = @AccountId
		and tr.AccountId not in (Select AccountId from cre.cash)
		---and tr.Date ='03/24/2022'
		and tr.Type like '%subline%'
	)tblSubBls on tblSubBls.AccountId = li.LiabilityTypeID and tblSubBls.Date = tr.[Date]

	Left Join(
		select
		tr.LiabilityAccountId_Of_CashAccID as AccountId
		,tr.Date
		,tr.[Type] 
		,tr.Amount 
		,acc.AccountTypeID
		from @tblTransactionentry tr
		inner jOin core.account acc on acc.AccountID = tr.AccountId
		where acc.isdeleted <> 1
		and tr.AnalysisID = @AnalysisId
		--and tr.ParentAccountID  = @AccountId
		and tr.AccountId in (Select AccountId from cre.cash)
		--and tr.Date ='03/24/2022'
		and tr.Type like '%equity%'
	)tblEqUnallocBls on tblEqUnallocBls.AccountId = li.LiabilityTypeID and tblEqUnallocBls.Date = tr.[Date]

	Left Join(
		select
		tr.LiabilityAccountId_Of_CashAccID as AccountId
		,tr.Date
		,tr.[Type] 
		,tr.Amount 
		,acc.AccountTypeID
		from @tblTransactionentry tr
		inner jOin core.account acc on acc.AccountID = tr.AccountId
		where acc.isdeleted <> 1
		and tr.AnalysisID = @AnalysisId
		--and tr.ParentAccountID  = @AccountId
		and tr.AccountId in (Select AccountId from cre.cash)
		--and tr.Date ='03/24/2022'
		and tr.Type like '%Subline%'
	)tblSubUnallocBls on tblSubUnallocBls.AccountId = li.LiabilityTypeID and tblSubUnallocBls.Date = tr.[Date]

	where acc.isdeleted <> 1
	and tr.AnalysisID = @AnalysisID
	and tr.LiabilityNoteAccountId  in (Select AccountID from cre.LiabilityNote where DealAccountID  = @DealAccountId)
	Order by tr.[Date],tr.LiabilityNoteID,tr.[TransactionType]

END
GO

