--[dbo].[usp_GetDebtorEquityFundingExportExcel] 'A3C83A5C-3A70-4359-83DE-5399D5CF78A0'

CREATE Procedure [dbo].[usp_GetDebtorEquityFundingExportExcel] 
(
 @AccountId uniqueidentifier
)
as 
BEGIN
	SET NOCOUNT ON;
	
	
	Declare @CalcAsOfDate date;	
	SET @CalcAsOfDate = ISNULL((Select MAX(TransactionDate) from CRE.LiabilityFundingScheduleAggregate where AccountID in (
			Select distinct ln.LiabilitytypeID
			from cre.LiabilityNote ln  
			Inner Join core.Account acc on acc.AccountID = ln.AccountID  
			Where acc.IsDeleted <> 1  
			and ln.AssetAccountID  in (
				Select ln.AssetAccountID
				from cre.LiabilityNote ln  
				Inner Join core.Account acc on acc.AccountID = ln.AccountID  
				Where acc.IsDeleted <> 1  
				and ln.LiabilityTypeID  = @AccountId	
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
 Applied bit
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
From CRE.LiabilityFundingSchedule tr
Where tr.AccountID = @AccountId

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
where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and LiabilityAccountID = @AccountId

Select
 LiabiityType as Liabiity_Type
,LiabilityNoteID as Liability_Note_ID
,TransactionDate as Transaction_Date
,TransactionAmount as Transaction_Amount
,TransactionType as Transaction_Type
,Applied as Confirmed
,CREDealID as Deal_ID
,DealName as Deal_Name
,EndingBalance as Ending_Balance
,UnallocatedBalance as Unallocated_Balance
,AssetID as Asset_ID
,AssetName as Asset_Name
,AssetTransactionDate as Asset_Transaction_Date
,AssetTransactionAmount as Borrower_Transaction_Amount
,TransactionAdvanceRate as Transaction_Advance_Rate
,CumulativeAdvanceRate as Cumulative_Advance_Rate
,AssetTransactionComment as Asset_Transaction_Comments
,Comments as Comments
From(
	select 
	 ln.LiabilityNoteID
	,t.TransactionDate
	,t.TransactionAmount
	,t.TransactionType
	,acca.AssetName as AssetID
	,acc.[Name] as AssetName
	,null as AssetTransactionType
	,t.AssetTransactionDate
	,t.AssetTransactionAmount
	,t.TransactionAdvanceRate
	,t.CumulativeAdvanceRate
	,t.AssetTransactionComment
	,t.EndingBalance
	,CAST(t.Applied as bit)  Applied
	,t.Comments
	,d.DealName
	,d.CREDealID
	,Db.LibName as LiabiityType
	,tr.[Amount] as UnallocatedBalance
	From #temp_LiabilityFunding t
	left join core.account acc on acc.accountid = t.AssetAccountID
	left join cre.note n on n.account_accountid= acc.accountid
	inner join cre.liabilitynote ln on ln.accountid = t.LiabilityNoteAccountID
	Inner join cre.deal d on d.dealid = n.DealID
	Left Join (
		Select AssetAccountID,AssetName
		From(
			SELECT d.DealName as AssetName,acc.AccountID as AssetAccountID
			FROM CRE.Deal AS d
			INNER JOIN Core.Account AS acc ON acc.AccountID = d.AccountID
			WHERE acc.IsDeleted <> 1 

			UNION ALL

			SELECT n.CRENoteID as AssetName,acc.AccountID as AssetAccountID
			FROM CRE.Note AS n
			INNER JOIN Core.Account AS acc ON acc.AccountID = n.Account_AccountID
			WHERE acc.IsDeleted <> 1
		
		)z
	)acca on acca.AssetAccountID = t.AssetAccountID
	LEFT JOIN (
	
			Select acc.AccountID,d.PortfolioAccountID,acc.name as LibName
			from cre.Debt d   
			Inner Join core.Account acc on acc.AccountID =  d.AccountID   
			where  IsDeleted<> 1   
  
			UNION ALL    
  
			Select acc.AccountID,d.PortfolioAccountID,acc.name as LibName
			from cre.Equity d   
			Inner Join core.Account acc on acc.AccountID =  d.AccountID   
			where IsDeleted<> 1

			UNION ALL    
  
			Select acc.AccountID,null as PortfolioAccountID,acc.name as LibName
			from cre.CASH d   
			Inner Join core.Account acc on acc.AccountID =  d.AccountID   
			where IsDeleted<> 1
	) Db on Db.AccountID = t.LiabilityAccountID
	left join cre.TransactionEntry tr ON tr.AccountID = db.PortfolioAccountID AND tr.[Date] = t.TransactionDate

	and t.TransactionDate <= @CalcAsOfDate

	UNION ALL 

	select
	te.LiabilityNoteID
	,te.TransactionDate
	,te.TransactionAmount
	,TransactionType
	,acca.AssetName as AssetID
	,acc.[Name] as AssetName
	,AssetTransactionType
	,te.AssetTransactionDate
	,te.AssetTransactionAmount
	,null as TransactionAdvanceRate
	,null as CumulativeAdvanceRate
	,null as AssetTransactionComment
	,te.EndingBalance
	,CAST(0 as bit) as Applied
	,null as Comments
	,d.DealName
	,d.CREDealID
	,Db.LibName as LiabiityType
	,tr.[Amount] as UnallocatedBalance
	From #temp_TransactionEntry te
	left join core.account acc on acc.accountid = te.AssetAccountID
	left join cre.note n on n.account_accountid= acc.accountid
	Inner join cre.deal d on d.dealid = n.DealID
		Left Join (
		Select AssetAccountID,AssetName
		From(
			SELECT d.DealName as AssetName,acc.AccountID as AssetAccountID
			FROM CRE.Deal AS d
			INNER JOIN Core.Account AS acc ON acc.AccountID = d.AccountID
			WHERE acc.IsDeleted <> 1 

			UNION ALL

			SELECT n.CRENoteID as AssetName,acc.AccountID as AssetAccountID
			FROM CRE.Note AS n
			INNER JOIN Core.Account AS acc ON acc.AccountID = n.Account_AccountID
			WHERE acc.IsDeleted <> 1
		
		)z
	)acca on acca.AssetAccountID = te.AssetAccountID
	LEFT JOIN (
	
			Select acc.AccountID,d.PortfolioAccountID,acc.name as LibName
			from cre.Debt d   
			Inner Join core.Account acc on acc.AccountID =  d.AccountID   
			where  IsDeleted<> 1   
  
			UNION ALL    
  
			Select acc.AccountID,d.PortfolioAccountID,acc.name as LibName
			from cre.Equity d   
			Inner Join core.Account acc on acc.AccountID =  d.AccountID   
			where IsDeleted<> 1

			UNION ALL    
  
			Select acc.AccountID,null as PortfolioAccountID,acc.name as LibName
			from cre.CASH d   
			Inner Join core.Account acc on acc.AccountID =  d.AccountID   
			where IsDeleted<> 1
	) Db on Db.AccountID = te.LiabilityAccountID
	left join cre.TransactionEntry tr ON tr.AccountID = db.PortfolioAccountID AND tr.[Date] = te.TransactionDate

	Where te.TransactionDate > @CalcAsOfDate

)a
order by a.TransactionDate

END