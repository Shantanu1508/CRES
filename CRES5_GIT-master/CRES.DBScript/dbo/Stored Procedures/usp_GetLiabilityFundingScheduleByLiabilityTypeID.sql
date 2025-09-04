---[dbo].[usp_GetLiabilityFundingScheduleByLiabilityTypeID]  'CCEE6EE3-D5B2-4D4B-9C83-0EAEDC34026F'  
CREATE PROCEDURE [dbo].[usp_GetLiabilityFundingScheduleByLiabilityTypeID]  
 @LiabilityTypeID nvarchar(256)   
AS  
BEGIN  

IF OBJECT_ID('TempDB..#TempLiabilityFunding') IS NOT NULL

DROP TABLE #TempLiabilityFunding;
 
CREATE TABLE #TempLiabilityFunding(

LiabilityFundingScheduleID int,
LiabilityNoteAccountID  uniqueidentifier,
TransactionDate datetime,
TransactionAmount decimal(28, 15),	 
GeneratedBy Int,
Applied bit,
Comments nvarchar(max),
AssetAccountID uniqueidentifier,
AssetTransactionDate datetime,
AssetTransactionAmount decimal(28, 15),
TransactionAdvanceRate decimal(28, 15),
CumulativeAdvanceRate decimal(28, 15) ,	
AssetTransactionComment nvarchar(max),
RowNo int,
TransactionTypes nvarchar(256) ,
GeneratedByUserID nvarchar(256),
GeneratedByText nvarchar(256),
[AssetName]  nvarchar(256)
) 

INSERT INTO #TempLiabilityFunding
select
ls.LiabilityFundingScheduleID
,ls.LiabilityNoteAccountID
,ls.TransactionDate
,ls.TransactionAmount
,ls.GeneratedBy
,ls.Applied
,ls.Comments
,ls.AssetAccountID
,ls.AssetTransactionDate
,ls.AssetTransactionAmount
,ls.TransactionAdvanceRate
,ls.CumulativeAdvanceRate
,ls.AssetTransactionComment
,ls.RowNo
,ls.TransactionTypes
,ls.GeneratedByUserID
,null as GeneratedByText
,null as [AssetName]
From CRE.LiabilityFundingSchedule ls 
--Left Join CORE.Lookup lGeneratedBy on lGeneratedBy.lookupid = ls.GeneratedBy
--Left Join(
--	Select ls1.LiabilityFundingScheduleID, u.[Login],ls1.GeneratedByUserID
--	from cre.LiabilityFundingSchedule ls1
--	left join app.[user] u on u.userid = ls1.GeneratedByUserID
--	Where ls1.GeneratedBy = 822
--	and ls1.AccountID = @LiabilityTypeID
--)tblGeneratedBy_Name on tblGeneratedBy_Name.LiabilityFundingScheduleID = ls.LiabilityFundingScheduleID

where ls.AccountID = @LiabilityTypeID



Update #TempLiabilityFunding SET #TempLiabilityFunding.GeneratedByText = z.GeneratedByText,#TempLiabilityFunding.[AssetName] = z.AssetName 
From(
	Select ls.LiabilityFundingScheduleID
	,(CASE WHEN ls.GeneratedBy = 822 THEN  tblGeneratedBy_Name.[Login] ELSE lGeneratedBy.name END) as GeneratedByText
	,acca.AssetName
	From #TempLiabilityFunding ls 
	Left Join CORE.Lookup lGeneratedBy on lGeneratedBy.lookupid = ls.GeneratedBy
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
	)acca on acca.AssetAccountID = ls.AssetAccountID
	Left Join(
		Select ls1.LiabilityFundingScheduleID, u.[Login],ls1.GeneratedByUserID
		from #TempLiabilityFunding ls1
		left join app.[user] u on u.userid = ls1.GeneratedByUserID
		Where ls1.GeneratedBy = 822	
	)tblGeneratedBy_Name on tblGeneratedBy_Name.LiabilityFundingScheduleID = ls.LiabilityFundingScheduleID
)z
Where #TempLiabilityFunding.LiabilityFundingScheduleID = z.LiabilityFundingScheduleID


Select 
t.LiabilityFundingScheduleID
,t.LiabilityNoteAccountID
,ln.LiabilityNoteID
,acc.Name as LiabilityNoteName
,t.TransactionDate
,t.TransactionAmount
,null as WorkFlowStatus
,t.GeneratedBy
,t.Applied
,t.Comments
,t.AssetAccountID
--,acca.AssetName as [AssetName]
,t.[AssetName]
,t.AssetTransactionDate
,t.AssetTransactionAmount
,t.TransactionAdvanceRate
,t.CumulativeAdvanceRate
,t.AssetTransactionComment
,t.RowNo
,t.GeneratedByText
--,(CASE WHEN t.GeneratedBy = 822 THEN  tblGeneratedBy_Name.[Login] ELSE lGeneratedBy.name END) as GeneratedByText
,t.GeneratedByUserID
,t.TransactionTypes
From #TempLiabilityFunding t
Inner Join cre.LiabilityNote ln on t.LiabilityNoteAccountID = ln.Accountid
Inner Join core.account acc on acc.accountID = ln.AccountID
Left Join CORE.Lookup lGeneratedBy on lGeneratedBy.lookupid = t.GeneratedBy

--Left Join (
--	Select AssetAccountID,AssetName
--	From(
--		SELECT d.DealName as AssetName,acc.AccountID as AssetAccountID
--		FROM CRE.Deal AS d
--		INNER JOIN Core.Account AS acc ON acc.AccountID = d.AccountID
--		WHERE acc.IsDeleted <> 1 		

--		UNION ALL

--		SELECT n.CRENoteID as AssetName,acc.AccountID as AssetAccountID
--		FROM CRE.Note AS n
--		INNER JOIN Core.Account AS acc ON acc.AccountID = n.Account_AccountID
--		WHERE acc.IsDeleted <> 1		
--	)z
--)acca on acca.AssetAccountID = t.AssetAccountID

--Left Join(
--	Select ls.LiabilityFundingScheduleID, u.[Login],ls.GeneratedByUserID
--	from [CRE].[LiabilityFundingSchedule] ls
--	Inner Join cre.LiabilityNote ln on ls.LiabilityNoteAccountID = ln.Accountid
--	left join app.[user] u on u.userid = ls.GeneratedByUserID
--	Where ls.GeneratedBy = 822
--	---and ln.DealAccountID = @DealAccountID
--)tblGeneratedBy_Name on tblGeneratedBy_Name.LiabilityFundingScheduleID = t.LiabilityFundingScheduleID

Where ln.LiabilityTypeID  = @LiabilityTypeID

ORDER BY t.TransactionDate,ISNULL(NULLIF(CAST(t.applied as int),0),99),t.TransactionTypes,t.AssetName

END