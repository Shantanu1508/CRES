 
 --[dbo].[usp_GetLiabilityFundingScheduleDetailByLiabilityTypeID]  'A3C83A5C-3A70-4359-83DE-5399D5CF78A0'

CREATE PROCEDURE [dbo].[usp_GetLiabilityFundingScheduleDetailByLiabilityTypeID] 
 @LiabilityTypeID nvarchar(256)   
AS  
BEGIN  


	Declare @CalcAsOfDate date;	
	SET @CalcAsOfDate = ISNULL((Select MAX(TransactionDate) from CRE.LiabilityFundingScheduleAggregate where Applied = 1 and AccountID in (
			Select distinct ln.LiabilitytypeID
			from cre.LiabilityNote ln  
			Inner Join core.Account acc on acc.AccountID = ln.AccountID  
			Where acc.IsDeleted <> 1  
			and ln.AssetAccountID  in (
				Select ln.AssetAccountID
				from cre.LiabilityNote ln  
				Inner Join core.Account acc on acc.AccountID = ln.AccountID  
				Where acc.IsDeleted <> 1  
				and ln.LiabilityTypeID  = @LiabilityTypeID	
			)
		)
	),'1/1/1900')

IF OBJECT_ID('TempDB..#temp_LiabilityFunding') IS NOT NULL
	DROP TABLE #temp_LiabilityFunding;
 
CREATE TABLE #temp_LiabilityFunding(
 LiabilityFundingScheduleID Int,
 LiabilityAccountID UNIQUEIDENTIFIER,
 TransactionDate Date,
 TransactionAmount decimal(28,15),
 TransactionType NVARCHAR (256),
 AssetAccountID UNIQUEIDENTIFIER,
 AssetTransactionDate Date,
 AssetTransactionAmount decimal(28,15),
 TransactionAdvanceRate decimal(28,15),
 CumulativeAdvanceRate decimal(28,15),
 AssetTransactionComment nvarchar(256),
 EndingBalance decimal(28,15),
 Comments nvarchar(256),
 LiabilityNoteAccountID UNIQUEIDENTIFIER,
 Applied bit,
 [Status] int,
 CalcType int
)

INSERT into #temp_LiabilityFunding
select tr.LiabilityFundingScheduleID
	,tr.AccountID as LiabilityAccountID
	,tr.TransactionDate as TransactionDate
	,tr.TransactionAmount as TransactionAmount
	,tr.TransactionTypes as TransactionType
	,tr.AssetAccountID
	,tr.AssetTransactionDate as AssetTransactionDate
	,tr.AssetTransactionAmount as AssetTransactionAmount
	,tr.TransactionAdvanceRate as TransactionAdvanceRate
	,tr.CumulativeAdvanceRate as CumulativeAdvanceRate
	,tr.AssetTransactionComment as AssetTransactionComment
	,tr.EndingBalance
	,tr.Comments
	,tr.LiabilityNoteAccountID
	,tr.Applied
	,tr.[Status]
	,tr.CalcType
From CRE.LiabilityFundingSchedule tr
Where tr.AccountID = @LiabilityTypeID

IF OBJECT_ID('TempDB..#temp_TransactionEntry') IS NOT NULL
	DROP TABLE #temp_TransactionEntry;

CREATE TABLE #temp_TransactionEntry(
LiabilityAccountID UNIQUEIDENTIFIER,
LiabilityNoteID NVARCHAR (256),
TransactionDate Date,
TransactionAmount decimal(28,15),
TransactionType NVARCHAR (256),
AssetAccountID UNIQUEIDENTIFIER,
AssetTransactionType NVARCHAR (256),
AssetTransactionDate Date,
AssetTransactionAmount decimal(28,15),
EndingBalance decimal(28,15),
LiabilityNoteAccountID UNIQUEIDENTIFIER
)

INSERT into #temp_TransactionEntry
select tr.LiabilityAccountID
	,tr.LiabilityNoteID
	,tr.date as TransactionDate
	,tr.Amount as TransactionAmount
	,TransactionType
	,tr.AssetAccountID
	,AssetTransactionType
	,tr.AssetDate as AssetTransactionDate
	,tr.AssetAmount as AssetTransactionAmount
	,tr.EndingBalance
	,tr.LiabilityNoteAccountID as LiabilityNoteAccountID
From CRE.transactionentryLiability tr
where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and LiabilityAccountID = @LiabilityTypeID

Select LiabilityFundingScheduleID
,LiabilityAccountID
,LiabilityNoteID
,TransactionDate
,TransactionAmount
,TransactionType
,CRENoteID
,OriginalTotalCommitment
,AssetAccountID
,AssetName
,AssetTransactionType
,AssetTransactionDate
,AssetTransactionAmount
,TransactionAdvanceRate
,CumulativeAdvanceRate
,AssetTransactionComment
,EndingBalance
,DealAccountID
,LiabilityNoteAccountID
,Applied
,Comments
,TableName
,DealName
,CREDealID
,[Status]
,StatusText
From(
	select t.LiabilityFundingScheduleID
	,t.LiabilityAccountID
	,ln.LiabilityNoteID
	,t.TransactionDate
	,t.TransactionAmount
	,t.TransactionType
	,n.CRENoteID
	,n.OriginalTotalCommitment
	,t.AssetAccountID
	,acc.name as AssetName
	,null as AssetTransactionType
	,t.AssetTransactionDate
	,t.AssetTransactionAmount
	,t.TransactionAdvanceRate
	,t.CumulativeAdvanceRate
	,t.AssetTransactionComment
	,t.EndingBalance
	,ln.AccountID as LiabilityNoteAccountID
	,CAST(t.Applied as bit)  Applied
	,t.Comments
	,'LiabilityFundingSchedule' as TableName
	,d.AccountID as DealAccountID
	,d.DealName
	,d.CREDealID
	,t.[Status]
	,l.Name as StatusText
	From #temp_LiabilityFunding t
	left join core.account acc on acc.accountid = t.AssetAccountID
	LEFT Join Core.Lookup l on l.LookupID = t.Status
	left join cre.note n on n.account_accountid= acc.accountid
	inner join cre.liabilitynote ln on ln.accountid = t.LiabilityNoteAccountID
	Inner join cre.deal d on d.dealid = n.DealID
	and (t.TransactionDate <= @CalcAsOfDate or t.[Status] = 943)

	UNION ALL 

	select 0 as LiabilityFundingScheduleID
	,te.LiabilityAccountID
	,te.LiabilityNoteID
	,te.TransactionDate
	,te.TransactionAmount
	,TransactionType
	,n.CRENoteID
	,n.OriginalTotalCommitment
	,te.AssetAccountID
	,acc.name as AssetName
	,AssetTransactionType
	,te.AssetTransactionDate
	,te.AssetTransactionAmount
	,null as TransactionAdvanceRate
	,null as CumulativeAdvanceRate
	,null as AssetTransactionComment
	,te.EndingBalance
	,te.LiabilityNoteAccountID
	,CAST(0 as bit) as Applied
	,null as Comments
	,'TransactionentryLiability' as TableName
	,d.AccountID as DealAccountID
	,d.DealName
	,d.CREDealID
	,942 as [Status]
	,'Projected' as StatusText
	From #temp_TransactionEntry te
	left join core.account acc on acc.accountid = te.AssetAccountID
	left join cre.note n on n.account_accountid= acc.accountid
	Inner join cre.deal d on d.dealid = n.DealID
	Where te.TransactionDate > @CalcAsOfDate
	and te.TransactionDate not in (Select TransactionDate from #temp_LiabilityFunding li where li.LiabilityAccountID = @LiabilityTypeID and li.[Status] = 943 and isnull(li.CalcType,0)<>911)

)a
order by a.TransactionDate
	

END