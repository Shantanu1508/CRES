-- EXEC [dbo].[usp_UpdateLiabilityBalanceColumns] '8975769C-CA9B-453E-8AD6-90EFEEBBC976','C10F3372-0FC2-4861-A9F5-148F1F80804F'

CREATE PROCEDURE [dbo].[usp_UpdateLiabilityBalanceColumns]       
	@EquityAccountID UNIQUEIDENTIFIER  ,
	@AnalysisID UNIQUEIDENTIFIER
AS      
BEGIN
	
	SET NOCOUNT ON;
	/*
	IF OBJECT_ID('tempdb..#tblTrans') IS NOT NULL         
		DROP TABLE #tblTrans;

	CREATE TABLE #tblTrans( 
		TransactionEntryLiabilityID	UniqueIdentifier NULL,
		LiabilityFundingScheduleAggregateID	int NULL,
		DealID	nvarchar(256) NULL,
		DealName	nvarchar(256) NULL,
		TransactionType	nvarchar(256) NULL,
		TranTypeNew	nvarchar(256) NULL,
		date	Date NULL,
		Amount	 Decimal(28,15) NULL,
		SublineBalance	 Decimal(28,15) NULL,
		EquityBalance	 Decimal(28,15) NULL,
		UnallocatedSubline Decimal(28,15) NULL,	
		UnallocatedEquity Decimal(28,15) NULL
	)

	Insert into #tblTrans(TransactionEntryLiabilityID,LiabilityFundingScheduleAggregateID,DealID,DealName,TransactionType,TranTypeNew,date,Amount,SublineBalance,EquityBalance,UnallocatedSubline,UnallocatedEquity)
	Select 
		TransactionEntryLiabilityID	
		,LiabilityFundingScheduleAggregateID
		,DealID	
		,DealName	
		,TransactionType	
		,TranTypeNew	
		,date	
		,ROUND(Amount,2) as Amount
		,SublineBalance	
		,EquityBalance	
		,UnallocatedSubline	
		,UnallocatedEquity
	From(
 
			Select  tr.TransactionEntryLiabilityID
			,null as LiabilityFundingScheduleAggregateID
			,(CASE WHEN ac.Name like '%cash%' THEN 'Portfolio' else d.CREDealID END) as  DealID
			,d.DealName
			,tr.TransactionType
			,(CASE WHEN tr.TransactionType like '%equity%' THEN 'Equity' WHEN tr.TransactionType like '%subline%' THEN 'Subline' else tr.TransactionType END) as TranTypeNew
 
			,tr.date
			,Round(tr.Amount,2) as Amount
			,0.0 as SublineBalance
			,0.0 as EquityBalance
			,0.0 as UnallocatedSubline  
			,0.0 as UnallocatedEquity
 
			from cre.TransactionEntryLiability tr
			inner jOin core.account acc on acc.AccountID = tr.LiabilityNoteAccountId
			left Join cre.note n on n.account_accountid = tr.AssetAccountID
			Inner Join core.account acc1 on acc1.AccountID = n.Account_AccountID
			Inner Join cre.deal d on d.dealid = n.DealID
 
			inner jOin core.account acc2 on acc2.AccountID = tr.LiabilityAccountID
			Inner join core.AccountCategory ac on ac.AccountCategoryID = acc2.AccountTypeID
			where acc.isdeleted <> 1  and analysisid =@AnalysisID
			and tr.ParentAccountId = @EquityAccountID
 
			UNION ALL
 
 
			Select null as TransactionEntryLiabilityID
			,tr.LiabilityFundingScheduleAggregateID
			,'Portfolio' as  DealID
			,null DealName
			,tr.TransactionTypes
			,(CASE WHEN tr.TransactionTypes like '%equity%' THEN 'Equity' WHEN tr.TransactionTypes like '%subline%' THEN 'Subline' else tr.TransactionTypes END) as TranTypeNew
			,tr.TransactionDate as date
			,tr.TransactionAmount as  Amount
			,0.0 as SublineBalance
			,0.0 as EquityBalance
			,0.0 as UnallocatedSubline  
			,0.0 as UnallocatedEquity 
			From CRE.LiabilityFundingScheduleAggregate tr
			where tr.AccountID in (
				Select eq.AccountID 
				from cre.equity eq
				Inner join core.account acc on acc.accountid = eq.accountid where acc.isdeleted <> 1
 
				UNION ALL

				Select eq.AccountID 
				from cre.Debt eq
				Inner join core.account acc on acc.accountid = eq.accountid where acc.isdeleted <> 1
			)

			--Where tr.comments is null
 
	)a order by a.date;

	IF OBJECT_ID('tempdb..#tblTransGroup') IS NOT NULL         
		DROP TABLE #tblTransGroup;

	CREATE TABLE #tblTransGroup( 
		DealID nvarchar(256) NULL,
		TranTypeNew	nvarchar(256) NULL,
		date	Date NULL,
		SumAmount	 Decimal(28,15) NULL,
		RunningSum	 Decimal(28,15) NULL
	);


	INSERT INTO #tblTransGroup (DealID,TranTypeNew,date,SUMAmount,RunningSum)
	SELECT NULL,TranTypeNew,date,SumAMount,
	SUM(SumAmount) Over (Partition By TranTypeNew Order by TranTypeNew,date rows between unbounded preceding and current row) as RunningSum
	from (
		SELECT TranTypeNew,date,Sum(Amount) as SumAmount from #tblTrans
		Group By TranTypeNew,date
	) Res

	IF OBJECT_ID('tempdb..#tblTransGroupUnallocated') IS NOT NULL         
		DROP TABLE #tblTransGroupUnallocated;

	CREATE TABLE #tblTransGroupUnallocated( 
		DealID nvarchar(256) NULL,
		TranTypeNew	nvarchar(256) NULL,
		date	Date NULL,
		SumAmount	 Decimal(28,15) NULL,
		RunningSum	 Decimal(28,15) NULL
	)


	INSERT INTO #tblTransGroupUnallocated (DealID,TranTypeNew,date,SUMAmount,RunningSum)
	SELECT DealID,TranTypeNew,date,SumAMount,
	SUM(SumAmount) Over (Partition By TranTypeNew Order by TranTypeNew,date rows between unbounded preceding and current row) as RunningSum
	from
	(SELECT DealID,TranTypeNew,date,Sum(Amount) as SumAmount from #tblTrans Where DealID='Portfolio'
	Group By DealID,TranTypeNew,date) Res


	Update T Set 
		T.SublineBalance = TRes.SublineBalance,
		T.EquityBalance =  TRes.EquityBalance,
		T.UnallocatedSubline = TRes.UnallocatedSubline,
		T.UnallocatedEquity = TRes.UnallocatedEquity
	From #tblTrans T INNER JOIN (
		Select 
			TU.DealID,
			TG.TranTypeNew,
			TG.date,
			TG.SumAmount,
			TG.RunningSum,
			--CASE WHEN TG.TranTypeNew='Subline' Then TG.RunningSum ELSE 
			ISNULL((Select Top 1 TT.RunningSum From #tblTransGroup TT Where TT.Date<=TG.Date AND TT.TranTypeNew='Subline' Order by TT.date desc),0)  as SublineBalance,
			--CASE WHEN TG.TranTypeNew='Equity' Then TG.RunningSum ELSE 
			ISNULL((Select Top 1 TT.RunningSum From #tblTransGroup TT Where TT.Date<=TG.Date AND TT.TranTypeNew='Equity' Order by TT.date desc),0) as EquityBalance,
			--CASE WHEN TG.TranTypeNew='Subline' AND TU.DealID='Portfolio' Then TU.RunningSum ELSE 
			ISNULL((Select Top 1 TT.RunningSum From #tblTransGroupUnallocated TT Where TT.Date<=TG.Date AND TT.TranTypeNew='Subline' Order by TT.date desc),0) as UnallocatedSubline,
			--CASE WHEN TG.TranTypeNew='Equity' AND TU.DealID='Portfolio' Then TU.RunningSum ELSE 
			ISNULL((Select Top 1 TT.RunningSum From #tblTransGroupUnallocated TT Where TT.Date<=TG.Date AND TT.TranTypeNew='Equity' Order by TT.date desc),0) as UnallocatedEquity 
		from #tblTransGroup TG 
		LEFT JOIN #tblTransGroupUnallocated TU ON TG.TranTypeNew = TU.TranTypeNew AND TG.Date=TU.Date
	) TRes ON T.TranTypeNew = TRes.TranTypeNew AND T.Date = TRes.date 

	--EXEC [dbo].[usp_UpdateLiabilityAggregateEndingBalance] @EquityAccountID,@AnalysisID ----'EEC2266F-1AAF-404E-9D2A-CDBFDA82D394', 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	*/
END