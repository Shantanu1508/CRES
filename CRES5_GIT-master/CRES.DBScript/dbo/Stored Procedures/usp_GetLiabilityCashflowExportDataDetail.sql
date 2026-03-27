-- Procedure

---[dbo].[usp_GetLiabilityCashflowExportDataDetail] 'A3C83A5C-3A70-4359-83DE-5399D5CF78A0','c10f3372-0fc2-4861-a9f5-148f1f80804f','Equity'
---[dbo].[usp_GetLiabilityCashflowExportDataDetail] 'E16B9A2A-B9CC-439D-A6D2-516556DBA670','c10f3372-0fc2-4861-a9f5-148f1f80804f','Debt'


CREATE Procedure [dbo].[usp_GetLiabilityCashflowExportDataDetail] 
(
 @AccountId uniqueidentifier,
 @AnalysisId uniqueidentifier,
 @Type nvarchar(256)
)
as 
BEGIN
	SET NOCOUNT ON;


IF OBJECT_ID('tempdb..#tblLiabilityCashFlow') IS NOT NULL         
DROP TABLE #tblLiabilityCashFlow

CREATE TABLE #tblLiabilityCashFlow( 
	RowNumber Int IDENTITY(1,1),
	FundName	nvarchar(256),
	DealID	nvarchar(256),
	DealName	nvarchar(256),
	FacilityName	nvarchar(256),
	AssetID	nvarchar(256),
	AssetName	nvarchar(256),
	LiabilityNoteID	nvarchar(256),
	[Date]	Date,
	Amount	decimal(28,15),
	TransactionType	nvarchar(256),
	SublineBalance	decimal(28,15),
	EquityBalance	decimal(28,15),
	UnallocatedSubline	decimal(28,15),
	UnallocatedEquity	decimal(28,15),
	AssetTransactionDate	Date,
	AssetAmount	decimal(28,15),
	AssetTransactionType	nvarchar(256)   

	CONSTRAINT [PK_tblLiabilityCashFlow_RowNumber] PRIMARY KEY CLUSTERED (RowNumber ASC)
)  


IF(@Type ='Equity')
BEGIN

	 Declare @EquityName nvarchar(256) = (Select acc.Name from cre.equity eq inner join core.account acc on eq.AccountID = acc.AccountID where eq.AccountID = @AccountId)


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
	inner jOin core.account acc on acc.AccountID = tr.AccountId
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
			and d.accountid = @AccountId
		)z
	)tblChAcc on tblChAcc.PortfolioAccountID = tr.AccountId
	where acc.isdeleted <> 1
	and tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	and tr.ParentAccountID  = @AccountId
	and tr.Amount <> 0
	----===============================================

	--Select 
	-- --z.AccountId,
	--z.CREDealID	
	--,z.DealName	
	--,z.AssetID	
	--,z.AssetName	
	--,z.LiabilityNoteID	
	--,z.Date	
	--,z.Amount	
	--,z.TransactionType	
	--,z.AssetTransactionDate	
	--,z.AssetAmount	
	--,z.AssetTransactionType	
	--,z.AccountTypeID
	--,tblSubBls.EndingBalance as SublineBalance
	--,tblEqBls.EndingBalance as EquityBalance
	--,tblSubUnallocBls.Amount as UnallocatedSubline
	--,tblEqUnallocBls.Amount as UnallocatedEquity


	INSERT INTO #tblLiabilityCashFlow(
	FundName
	,DealID
	,DealName
	,FacilityName
	,AssetID
	,AssetName
	,LiabilityNoteID
	,Date
	,Amount
	,TransactionType
	,SublineBalance
	,EquityBalance
	,UnallocatedSubline
	,UnallocatedEquity
	,AssetTransactionDate
	,AssetAmount
	,AssetTransactionType)

	Select 
	@EquityName as FundName,
	z.CREDealID	'Deal ID',
	z.DealName	'Deal Name',
	z.FacilityName 'Facility Name',
	z.AssetID	'Asset ID',
	z.AssetName	'Asset Name',
	z.LiabilityNoteID	'Liability Note ID',
	z.Date	,
	z.Amount	,
	z.TransactionType	'Transaction Type',
	--EndingBalance	,
	tblSubBls.EndingBalance as 'Subline Balance',
	tblEqBls.EndingBalance	as 'Equity Balance',
	tblSubUnallocBls.Amount	as 'Unallocated Subline',
	tblEqUnallocBls.Amount	as 'Unallocated Equity',
	--LineBalance	,
	z.AssetTransactionDate	'Asset Transaction Date',
	z.AssetAmount	'Asset Amount',
	z.AssetTransactionType	'Asset Transaction Type'
	From(
	select tr.AccountId
	,'Portfolio' as CREDealID
	,@EquityName as DealName
	,dtname.FacilityName as FacilityName
	,null as AssetID
	,null as AssetName
	,null as LiabilityNoteID
	,tr.[Date]  
	,tr.Amount  
	,tr.[Type] as [TransactionType] 

	,null as AssetTransactionDate
	,null as AssetAmount
	,null as AssetTransactionType

	,acc.AccountTypeID
	from @tblTransactionentry tr
	inner jOin core.account acc on acc.AccountID = tr.AccountId
	Left join(
		Select dt.accountid ,acc.name as FacilityName
		from cre.debt dt 
		inner jOin core.account acc on acc.AccountID = dt.AccountID
	)dtname on dtname.AccountID = tr.AccountId

	where acc.isdeleted <> 1
	and tr.AnalysisID = @AnalysisId
	and tr.ParentAccountID  = @AccountId
	--and tr.AccountID  = @AccountId
	and tr.AccountId not in (Select AccountId from cre.cash)
	and tr.[type] not in (Select transactionname from cre.TransactionTypes where transactionname like '%fee%' or transactionname = 'InterestPaid' or transactionname like 'Repo%')
	--and tr.Date ='03/24/2022'
	--and tr.Type like '%equity%'

	UNION ALL


	select tr.LiabilityAccountID
	--,(CASE WHEN (tr.LiabilityNoteID like '%LN_PS%' OR tr.LiabilityNoteID like '%LN_PE%') THEN 'Portfolio' ELSE d.CREDealID END) as CREDealID
	,d.CREDealID
	,d.DealName
	,dtname.FacilityName as FacilityName
	,n.CRENoteID as AssetID
	,acc1.name as AssetName
	,tr.LiabilityNoteID
	,tr.[Date]  
	,tr.Amount  
	,tr.[TransactionType] 
	,AssetDate as AssetTransactionDate
	,AssetAmount
	,AssetTransactionType
	,accLiTy.AccountTypeID
	from cre.TransactionEntryLiability tr
	Inner join cre.LiabilityNote ln on ln.AccountID = tr.LiabilityNoteAccountID
	inner jOin core.account acc on acc.AccountID = tr.LiabilityNoteAccountId
	left Join cre.note n on n.account_accountid = tr.AssetAccountID
	left Join core.account acc1 on acc1.AccountID = n.Account_AccountID
	inner jOin core.account accLiTy on accLiTy.AccountID = tr.LiabilityAccountId
	left Join cre.deal d on d.AccountID = ln.DealAccountID
	Left join(
		Select ln.accountid as liabilitynoteAccountID,aLiTy.name as FacilityName
		from cre.liabilitynote ln
		Inner join cre.debt dt on dt.accountid = ln.LiabilityTypeId
		inner jOin core.account aLiTy on aLiTy.AccountID = ln.LiabilityTypeId
	)dtname on dtname.liabilitynoteAccountID = tr.LiabilityNoteAccountId

	where acc.isdeleted <> 1
	and tr.AnalysisID = @AnalysisId
	and tr.ParentAccountID  = @AccountId
	and tr.LiabilityAccountId not in (Select AccountId from cre.cash)
	--and tr.Date ='03/24/2022'
	--and tr.[TransactionType] like '%equity%'


	UNION ALL

	---Detail Cash account

	select tblChAcc.AccountID
	---tr.LiabilityAccountID
	,'Portfolio' as CREDealID
	,d.DealName
	,dtname.FacilityName as FacilityName
	,n.CRENoteID as AssetID
	,acc1.name as AssetName
	,tr.LiabilityNoteID
	,tr.[Date]  
	,tr.Amount  
	,tr.[TransactionType] 
	,AssetDate as AssetTransactionDate
	,AssetAmount
	,AssetTransactionType
	,accLiTy.AccountTypeID
	from cre.TransactionEntryLiability tr
	inner jOin core.account acc on acc.AccountID = tr.LiabilityNoteAccountId
	left Join cre.note n on n.account_accountid = tr.AssetAccountID
	Inner Join core.account acc1 on acc1.AccountID = n.Account_AccountID
	inner jOin core.account accLiTy on accLiTy.AccountID = tr.LiabilityAccountId
	Inner Join cre.deal d on d.dealid = n.DealID
	Left Join(
		Select AccountID,PortfolioAccountID,[Text],[Type]
		From(
			Select acc.AccountID as AccountID,d.PortfolioAccountID,acc.name as [Text] ,'Debt' as [Type]  
			from cre.Debt d   
			Inner Join core.Account acc on acc.AccountID =  d.AccountID   
			left Join core.Account accp on acc.AccountID =  d.PortfolioAccountID 
			where  acc.IsDeleted<> 1   
  
			UNION ALL    
  
			Select acc.AccountID as AccountID,d.PortfolioAccountID,acc.name as [Text] ,'Equity' as [Type]  
			from cre.Equity d   
			Inner Join core.Account acc on acc.AccountID =  d.AccountID   
			left Join core.Account accp on acc.AccountID =  d.PortfolioAccountID
			where acc.IsDeleted<> 1   
		)z
	)tblChAcc on tblChAcc.PortfolioAccountID = tr.LiabilityAccountId
	Left join(
		Select dt.accountid ,acc.name as FacilityName,dt.PortfolioAccountID
		from cre.debt dt 
		inner jOin core.account acc on acc.AccountID = dt.AccountID
	)dtname on dtname.PortfolioAccountID = tr.LiabilityAccountId
	
	where acc.isdeleted <> 1
	and tr.AnalysisID = @AnalysisId
	and tr.ParentAccountID  = @AccountId
	and tr.LiabilityAccountId in (Select AccountId from cre.cash)
	--and tr.Date ='03/24/2022'
	--and tr.[TransactionType] like '%equity%'


		--UNION ALL

		--select tr.LiabilityAccountID
		--,null as CREDealID
		--,null as DealName
		--,acc.Name as FacilityName
		--,null as  AssetID
		--,null as  AssetName
		--,tr.LiabilityNoteID
		--,tr.[Date]  
		--,tr.Amount  
		--,tr.[TransactionType] 
		--,AssetDate as AssetTransactionDate
		--,AssetAmount
		--,AssetTransactionType
		--,null as AccountTypeID
		--from cre.TransactionEntryLiability tr
		--Left join cre.debt dt on dt.accountid = tr.LiabilityAccountID	
		--Inner join core.account acc on acc.accountid = dt.AccountID
		--where tr.AnalysisID = @AnalysisId
		--and tr.ParentAccountID  = @AccountId
		--and tr.TransactionType = 'InterestPaid'
		--and tr.LiabilityNoteID like '%unallocatedbls_%'

	)z
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
		and tr.ParentAccountID  = @AccountId
		and tr.AccountId not in (Select AccountId from cre.cash)
		--and tr.Date ='03/24/2022'
		and tr.Type like '%equity%'
	)tblEqBls on tblEqBls.AccountId = z.AccountId and tblEqBls.Date = z.Date ---and tblBls.AccountTypeID = z.AccountTypeID
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
		and tr.ParentAccountID  = @AccountId
		and tr.AccountId not in (Select AccountId from cre.cash)
		---and tr.Date ='03/24/2022'
		and tr.Type like '%subline%'
	)tblSubBls on tblSubBls.AccountId = z.AccountId and tblSubBls.Date = z.Date

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
		and tr.ParentAccountID  = @AccountId
		and tr.AccountId in (Select AccountId from cre.cash)
		--and tr.Date ='03/24/2022'
		and tr.Type like '%equity%'
	)tblEqUnallocBls on tblEqUnallocBls.AccountId = z.AccountId and tblEqUnallocBls.Date = z.Date

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
		and tr.ParentAccountID  = @AccountId
		and tr.AccountId in (Select AccountId from cre.cash)
		--and tr.Date ='03/24/2022'
		and tr.Type like '%Subline%'
	)tblSubUnallocBls on tblSubUnallocBls.AccountId = z.AccountId and tblSubUnallocBls.Date = z.Date

	--order by  z.[Date], z.LiabilityNoteID,z.TransactionType
	order by  z.[Date], z.AssetID,z.TransactionType

END
ELSE IF(@Type ='Debt')
BEGIN

	INSERT INTO #tblLiabilityCashFlow(FundName
	,DealID
	,DealName
	,FacilityName
	,AssetID
	,AssetName
	,LiabilityNoteID
	,Date
	,Amount
	,TransactionType
	,SublineBalance
	,EquityBalance
	,UnallocatedSubline
	,UnallocatedEquity
	,AssetTransactionDate
	,AssetAmount
	,AssetTransactionType)

	select 
	acceq.name as FundName,
	d.CREDealID as 'Deal ID'
	,d.DealName as 'Deal Name'
	,dtname.FacilityName 'Facility Name'
	,n.CRENoteID as 'Asset ID'
	,acc1.name as 'Asset Name'
	,tr.LiabilityNoteID as 'Liability Note ID'
	,tr.[Date]  
	,tr.Amount  
	,tr.[TransactionType]  as 'Transaction Type'
	,tr.EndingBalance as 'Ending Balance'	
	,null	as 'Equity Balance'
	,null	as 'Unallocated Subline'
	,null	as 'Unallocated Equity'
	,AssetDate as 'Asset Transaction Date'
	,AssetAmount as 'Asset Amount'
	,AssetTransactionType as 'Asset Transaction Type'
	from cre.TransactionEntryLiability tr
	Inner join cre.LiabilityNote ln on ln.AccountID = tr.LiabilityNoteAccountID
	inner jOin core.account acc on acc.AccountID = tr.LiabilityNoteAccountId
	left Join cre.note n on n.account_accountid = tr.AssetAccountID
	left Join core.account acc1 on acc1.AccountID = n.Account_AccountID
	Inner Join cre.deal d on d.AccountID = ln.DealAccountID
	Left join(
		Select ln.accountid as liabilitynoteAccountID,aLiTy.name as FacilityName
		from cre.liabilitynote ln
		Inner join cre.debt dt on dt.accountid = ln.LiabilityTypeId
		inner jOin core.account aLiTy on aLiTy.AccountID = ln.LiabilityTypeId
	)dtname on dtname.liabilitynoteAccountID = tr.LiabilityNoteAccountId

	Left Join core.account acceq on acceq.AccountID = tr.ParentAccountId

	where acc.isdeleted <> 1
	and tr.AnalysisID = @AnalysisId
	and tr.LiabilityAccountID  = @AccountId
	Order BY  acceq.name,tr.date,tr.LiabilityNoteID,tr.TransactionType
END



Update #tblLiabilityCashFlow set #tblLiabilityCashFlow.EquityBalance = ISNULL(a.EquityBalance,0),
#tblLiabilityCashFlow.SublineBalance = ISNULL(a.SublineBalance,0),
#tblLiabilityCashFlow.UnallocatedSubline = ISNULL(a.UnallocatedSubline,0),
#tblLiabilityCashFlow.UnallocatedEquity = ISNULL(a.UnallocatedEquity,0)
From(
	Select RowNumber
	--,z.SublineBalance
	,SublineBalance = (case 
					when SublineBalance is null 
					then (select SublineBalance from #tblLiabilityCashFlow t3 where t3.RowNumber = (select max(RowNumber)  from #tblLiabilityCashFlow t2  where t2.RowNumber < z.RowNumber and SublineBalance is not null) ) 
					else SublineBalance 
					end)
	--,z.EquityBalance	
	,EquityBalance = (case 
					when EquityBalance is null 
					then (select EquityBalance from #tblLiabilityCashFlow t3 where t3.RowNumber = (select max(RowNumber)  from #tblLiabilityCashFlow t2  where t2.RowNumber < z.RowNumber and EquityBalance is not null) ) 
					else EquityBalance 
					end)


	--,z.UnallocatedSubline
	,UnallocatedSubline = (case 
					when UnallocatedSubline is null 
					then (select UnallocatedSubline from #tblLiabilityCashFlow t3 where t3.RowNumber = (select max(RowNumber)  from #tblLiabilityCashFlow t2  where t2.RowNumber < z.RowNumber and UnallocatedSubline is not null) ) 
					else UnallocatedSubline 
					end)
	--,z.UnallocatedEquity
	,UnallocatedEquity = (case 
					when UnallocatedEquity is null 
					then (select UnallocatedEquity from #tblLiabilityCashFlow t3 where t3.RowNumber = (select max(RowNumber)  from #tblLiabilityCashFlow t2  where t2.RowNumber < z.RowNumber and UnallocatedEquity is not null) ) 
					else UnallocatedEquity 
					end)

	from (
		Select RowNumber 	
		,SublineBalance
		,EquityBalance	
		,UnallocatedSubline
		,UnallocatedEquity	
		From #tblLiabilityCashFlow 
	)z

)a
Where #tblLiabilityCashFlow.RowNumber = a.RowNumber


Select 
FundName
,z.DealID
,z.DealName
,z.FacilityName
,z.LiabilityNoteID
,z.Date
,z.Amount
,z.TransactionType
,z.SublineBalance
,z.EquityBalance	
,z.UnallocatedSubline
,z.UnallocatedEquity
,z.AssetID
,z.AssetName
,z.AssetTransactionDate
,z.AssetAmount
,z.AssetTransactionType
from (
	Select 
	RowNumber 
	,FundName
	,DealID
	,DealName
	,FacilityName
	,AssetID
	,AssetName
	,LiabilityNoteID
	,Date
	,Amount
	,TransactionType
	,SublineBalance
	,EquityBalance	
	,UnallocatedSubline
	,UnallocatedEquity
	,AssetTransactionDate
	,AssetAmount
	,AssetTransactionType
	From #tblLiabilityCashFlow 
)z
order by  z.[Date], z.AssetID,z.TransactionType



END
GO

