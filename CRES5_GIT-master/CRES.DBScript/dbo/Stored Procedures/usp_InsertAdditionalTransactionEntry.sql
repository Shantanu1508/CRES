
CREATE PROCEDURE [dbo].[usp_InsertAdditionalTransactionEntry]  
  
@DealAccountId uniQUEIDENtIFIER,
@CreatedBy  nvarchar(256)  
  
AS  
BEGIN  
    SET NOCOUNT ON;



Delete from [CRE].[AdditionalTransactionEntry] where [DealAccountId] = @DealAccountId

---liability note level
INSERT INTO [CRE].[AdditionalTransactionEntry]
([AccountId]
,[Date]
,[Amount]
,[Type]
,[AnalysisID]
,[Comment]
,[EndingBalance]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
,[DealAccountId]
,[AssetAccountID]
,LiabilityTypeID)
	
Select 
ls.LiabilityNoteAccountID as AccountId
,ls.TransactionDate as [Date]
,ls.TransactionAmount as [Amount]
,ls.TransactionTypes as [Type]
,'C10F3372-0FC2-4861-A9F5-148F1F80804F' as [AnalysisID]
,ls.[Comments]
,null as [EndingBalance]
,@CreatedBy [CreatedBy]
,getdate() [CreatedDate]
,@CreatedBy [UpdatedBy]
,getdate()[UpdatedDate]
,ln.[DealAccountId]
,ls.[AssetAccountID]
,ln.LiabilityTypeID
From CRE.LiabilityFundingSchedule ls
Inner Join cre.LiabilityNote ln on ls.LiabilityNoteAccountID = ln.Accountid
Inner Join core.account acc on acc.accountID = ln.AccountID

Where  ls.Applied = 1
and ln.DealAccountID = @DealAccountId
and ls.TransactionDate <= '01/26/2024'


---liability type level (debt/equity or subline)

INSERT INTO [CRE].[AdditionalTransactionEntry]
([AccountId]
,[Date]
,[Amount]
,[Type]
,[AnalysisID]
,[Comment]
,[EndingBalance]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
,[DealAccountId]
,[AssetAccountID]
,LiabilityTypeID)

Select 
ln.LiabilityTypeID as AccountId
,ls.TransactionDate as [Date]
,sum(ls.TransactionAmount) as [Amount]
,ls.TransactionTypes as [Type]
,'C10F3372-0FC2-4861-A9F5-148F1F80804F' as [AnalysisID]
,ls.[Comments]
,null as [EndingBalance]
,@CreatedBy [CreatedBy]
,getdate() [CreatedDate]
,@CreatedBy [UpdatedBy]
,getdate()[UpdatedDate]
,ln.[DealAccountId]
,null as [AssetAccountID]
,null as LiabilityTypeID
From CRE.LiabilityFundingSchedule ls
Inner Join cre.LiabilityNote ln on ls.LiabilityNoteAccountID = ln.Accountid
Inner Join core.account acc on acc.accountID = ln.AccountID

Where ln.DealAccountID = @DealAccountId
and ls.Applied = 1
and ls.TransactionDate <= '01/26/2024'
group by ln.LiabilityTypeID,ls.TransactionDate,ls.TransactionTypes,ls.[Comments],ln.[DealAccountId]




update [CRE].[AdditionalTransactionEntry] set [CRE].[AdditionalTransactionEntry].EndingBalance = a.endingbalance
from(
	select DealAccountID,[AnalysisID],[AccountId],[Date],sum([Amount]) as endingbalance
	from [CRE].[AdditionalTransactionEntry]
	where DealAccountID = @DealAccountId
	group by DealAccountID,[AnalysisID],[AccountId],[Date]
)a
where [CRE].[AdditionalTransactionEntry].[AnalysisID] = a.[AnalysisID]
and [CRE].[AdditionalTransactionEntry].[AccountId] = a.[AccountId]
and [CRE].[AdditionalTransactionEntry].[Date] = a.[Date]
and [CRE].[AdditionalTransactionEntry].DealAccountID = a.DealAccountID



End