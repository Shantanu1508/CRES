---[dbo].[usp_GetDealLevelDataLiabilityFundingScheduleDetail] 'A3C83A5C-3A70-4359-83DE-5399D5CF78A0'

CREATE PROCEDURE [dbo].[usp_GetDealLevelDataLiabilityFundingScheduleDetail] 
	@LiabilityTypeID nvarchar(256)   
AS  
BEGIN
	Declare @CalcAsOfDate date;
	SET @CalcAsOfDate = ISNULL((Select MAX(TransactionDate) from CRE.LiabilityFundingScheduleDeal where Applied =1 and AccountID = @LiabilityTypeID),'1/1/1900')

	Select 
	LiabilityFundingScheduleDealID
	,AccountID
	,DealAccountID
	,TransactionDate
	,SUM(a.TransactionAmount) AS TotalTransactionAmount
	,TransactionType
	,EndingBalance
	,Applied
	,Comments
	,DealName
	,CREDealID
	,[Status]
	,StatusText
	From(
		select 
		LiabilityFundingScheduleDealID
		,tr.AccountID
		,D.AccountID as DealAccountID
		,tr.TransactionDate as TransactionDate
		,tr.TransactionAmount as TransactionAmount
		,tr.TransactionTypes as TransactionType
		,Sum(tr.TransactionAmount) Over(Partition By tr.AccountID ORDER by tr.AccountID ,tr.TransactionDate) as EndingBalance
		,CAST(Applied as bit)  Applied
		,tr.Comments
		,d.DealName
		,d.CREDealID
		,tr.[Status]
		,l.Name as StatusText
		From CRE.LiabilityFundingScheduleDeal tr
		LEFT Join cre.deal d on d.AccountID = tr.DealAccountID
		LEFT Join Core.Lookup l on l.LookupID = tr.Status
		Where tr.AccountID = @LiabilityTypeID 
		and (tr.TransactionDate <= @CalcAsOfDate or tr.[status] = 943)

		UNION ALL 

		select 
		0 as LiabilityFundingScheduleDealID
		,tr.LiabilityAccountID
		,D.AccountID as DealAccountID
		,tr.date as TransactionDate
		,tr.Amount as TransactionAmount
		,TransactionType
		,Sum(tr.Amount) Over(Partition By tr.LiabilityAccountID ORDER by tr.LiabilityAccountID ,tr.Date) as EndingBalance
		,CAST(0 as bit) as Applied
		,null as Comments
		,d.DealName
		,d.CREDealID
		,942 as [Status]
		,'Projected' as StatusText
		From CRE.transactionentryLiability tr
		left join core.account acc on acc.accountid = tr.AssetAccountID
		left join cre.note n on n.account_accountid= acc.accountid
		LEFT join cre.deal d on d.dealid = n.DealID
		Where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
		and LiabilityAccountID = @LiabilityTypeID
		and tr.date > @CalcAsOfDate
		and tr.Date not in (Select TransactionDate from cre.LiabilityFundingScheduleDeal where AccountID = @LiabilityTypeID and [Status] = 943 )


	)a
	GROUP BY 
	LiabilityFundingScheduleDealID
	,AccountID
	,DealAccountID
	,TransactionDate
    ,TransactionType
	,EndingBalance
	,Applied
	,Comments
	,DealName
	,CREDealID
	,[Status]
	,StatusText
order by a.TransactionDate

END