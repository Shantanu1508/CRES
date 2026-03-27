
CREATE PROCEDURE [dbo].[usp_Liability_Onetime_LiabilityFundingSchedule_UploadTransactionTabOnly]   
AS  
BEGIN  
 SET NOCOUNT ON;  


Declare @L_EquityName nvarchar(256);

SET @L_EquityName = (Select top 1 EquityName from [Lib_11Trans])


--SET @L_EquityName = 'ACORE Credit Partners II'
--SET @L_EquityName = 'ACORE Opportunistic Credit I'
--SET @L_EquityName = 'ACORE Opportunistic Credit II'
--SET @L_EquityName = 'ACORE Credit Partners I'


Declare @equityAccountID UNIQUEIDENTIFIER;
SET @equityAccountID = (Select e.accountid from cre.equity e inner join core.account acc on acc.accountid = e.accountid where acc.name = @L_EquityName)


Delete From CRE.LiabilityFundingSchedule where LiabilityNoteAccountID in (
	Select Distinct LiabilityNoteAccountID from cre.TransactionEntryLiability tr where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	and ParentAccountid =@equityAccountID
)


INSERT into CRE.LiabilityFundingSchedule (
LiabilityNoteAccountID
,TransactionDate
,TransactionAmount
,Applied
,Comments
,AssetAccountID
,RowNo
,CreatedBy
,CreatedDate
,UpdatedBy
,UpdatedDate
,[Description]
,TransactionTypes
,AccountID
,EndingBalance)

Select 
LiabilityNoteAccountID
,tr.date TransactionDate
,tr.amount TransactionAmount
,1 as Applied
,null as Comments
,AssetAccountID
,1 as  RowNo
,'B0E6697B-3534-4C09-BE0A-04473401AB93'
,GETDATE()
,'B0E6697B-3534-4C09-BE0A-04473401AB93'
,GETDATE()
,null as [Description]
,tr.[TransactionType] as TransactionTypes
,tr.LiabilityAccountID AccountID
,ROUND(SUM(ISNULL(tr.Amount,0)) OVER(PARTITION BY tr.ParentAccountid,tr.LiabilityAccountID,tr.LiabilityNoteAccountID ORDER BY tr.ParentAccountid,tr.LiabilityAccountID,tr.LiabilityNoteAccountID,tr.date ),2) AS AccumaltedEndingBalance_new

From cre.TransactionEntryLiability tr where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
and tr.TransactionType in (Select TransactionName from cre.TransactionTypes where TransactionCategory = 'Liability' )
and ParentAccountid =@equityAccountID
----order by tr.LiabilityAccountID


-----===================LiabilityFundingScheduleAggregate===========================================

----truncate table CRE.LiabilityFundingScheduleAggregate

Delete From CRE.LiabilityFundingScheduleAggregate where ParentAccountID = @equityAccountID


declare @TableTypeLiabilityFundingScheduleAggregate [dbo].[TableTypeLiabilityFundingScheduleAggregate]   

Insert into @TableTypeLiabilityFundingScheduleAggregate(LiabilityFundingScheduleAggregateID,[AccountID],TransactionDate,TransactionAmount,TransactionTypes,Applied,Comments,EndingBalance,ParentAccountID)  
Select LiabilityFundingScheduleAggregateID
,[AccountID]
,TransactionDate
,TransactionAmount
,TransactionTypes
,Applied
,Comments
,ROUND(SUM(ISNULL(a.TransactionAmount,0)) OVER(PARTITION BY ParentAccountID,[AccountID] ORDER BY ParentAccountID,[AccountID],TransactionDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),2) AS AccumaltedEndingBalance
,ParentAccountID
from
(
	Select 0 as LiabilityFundingScheduleAggregateID
	,tr.AccountID as [AccountID]
	,tr.date as TransactionDate
	,tr.amount as TransactionAmount 
	,tr.[type] as TransactionTypes 
	,1 as Applied
	,null as Comments
	,@equityAccountID as ParentAccountID
	From CRE.TransactionEntry tr
	where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	and ParentAccountid =@equityAccountID
	and tr.Type in (Select TransactionName from cre.TransactionTypes where TransactionCategory = 'Liability' )
	--and tr.AccountID not in (Select AccountID from cre.Cash)
)a

EXEC [dbo].[usp_InsertUpdateLiabilityFundingScheduleAggregate]  @TableTypeLiabilityFundingScheduleAggregate,'B0E6697B-3534-4C09-BE0A-04473401AB93'



END