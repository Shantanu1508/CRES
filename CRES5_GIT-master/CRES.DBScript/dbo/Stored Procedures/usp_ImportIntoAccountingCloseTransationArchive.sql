-- Procedure


CREATE Procedure [dbo].[usp_ImportIntoAccountingCloseTransationArchive]
@DealIDs nvarchar(max),
@CloseDate Date,
@UserID nvarchar(256)

AS

BEGIN

	SET NOCOUNT ON;


IF OBJECT_ID('tempdb..#tblDealList') IS NOT NULL         
	DROP TABLE #tblDealList

CREATE TABLE #tblDealList(
	CREDealId nvarchar(256)
)
INSERT INTO #tblDealList(CREDealId)
Select [Value] from [dbo].[fn_Split_Str](@DealIDs,'|')
--======================================================

IF OBJECT_ID('tempdb..#tblPeriodDeal') IS NOT NULL         
	DROP TABLE #tblPeriodDeal

CREATE TABLE #tblPeriodDeal(
	PeriodID UNIQUEIDENTIFIER,
	AnalysisID UNIQUEIDENTIFIER,
	DealID UNIQUEIDENTIFIER,
	LastAccountingCloseDate Date,
	NewClosedate Date
)
INSERT INTO #tblPeriodDeal(PeriodID,AnalysisID,DealID,LastAccountingCloseDate,NewClosedate)

Select p.PeriodID
,p.AnalysisID
,d.DealID
,lstCloseDate.LastAccountingCloseDate
,@CloseDate as NewClosedate

from CORE.[Period] p 	
Inner Join cre.deal d on d.dealid =  p.dealid
Inner Join(
	Select d.DealID,ISNULL(MAX(p.Closedate),'1/1/1900') as LastAccountingCloseDate
	from cre.deal d 
	Left Join CORE.[Period] p 	on d.dealid =  p.dealid and p.isdeleted <> 1 and p.CloseDate <> CAST(@CloseDate as date) 
	where d.isdeleted <> 1 
	and d.credealid in (Select CREDealId From #tblDealList)
	Group by d.DealID
)lstCloseDate on lstCloseDate.DealID = p.DealID

where d.isdeleted <> 1 and p.isdeleted <> 1
and p.CloseDate = @CloseDate
and d.credealid in (Select CREDealId From #tblDealList)
--======================================================

	Insert Into [CORE].[AccountingCloseTransationArchive](
	[TransactionEntryID]
	,[PeriodID]
    ,n.[NoteID]
    ,[Date] 
    ,[Amount]
    ,[Type]
    ,[AnalysisID]
    ,[FeeName]
    ,[StrCreatedBy]
    ,[GeneratedBy] 
    ,[TransactionDateByRule]
    ,[TransactionDateServicingLog]
    ,[RemitDate] 
    ,[FeeTypeName] 
    ,[Comment]
    ,[PaymentDateNotAdjustedforWorkingDay]
    ,[PurposeType] 
    ,[Cash_NonCash]
    ,[IOTermEndDate]
    ,LIBORPercentage
    ,SpreadPercentage
    ,PIKInterestPercentage
    ,PIKLiborPercentage
	--,NonCommitmentAdj
    ,AllInCouponRate
	,[IsDeleted]
	,[CreatedBy]
    ,[CreatedDate]
    ,[UpdatedBy]
    ,[UpdatedDate] 
	,AdjustmentType
	)
	Select
	[TransactionEntryID]
	,pd.PeriodID
    ,n.[NoteID]
    ,tr.[Date] 
    ,tr.[Amount]
    ,tr.[Type]
    ,tr.[AnalysisID]
    ,tr.[FeeName]
    ,tr.[StrCreatedBy]
    ,tr.[GeneratedBy] 
    ,tr.[TransactionDateByRule]
    ,tr.[TransactionDateServicingLog]
    ,tr.[RemitDate] 
    ,tr.[FeeTypeName] 
    ,tr.[Comment]
    ,tr.[PaymentDateNotAdjustedforWorkingDay]
    ,tr.[PurposeType] 
    ,tr.[Cash_NonCash]
    ,tr.[IOTermEndDate]
    ,tr.LIBORPercentage
    ,tr.SpreadPercentage
    ,tr.PIKInterestPercentage
    ,tr.PIKLiborPercentage
	--,tr.NonCommitmentAdj
    ,tr.AllInCouponRate
	,0 as [IsDeleted]	
	,@UserID
	,GETDATE()
	,@UserID
	,GETDATE()
	,tr.AdjustmentType
	FROM cre.TransactionEntry tr	
	Inner join core.account acc on acc.accountid = tr.AccountID
    Inner join cre.note n on n.account_accountid = acc.accountid

	--inner join cre.Note n on n.NoteID = tr.NoteID
	--Inner join core.account acc on acc.accountid =n.account_accountid
	Inner Join #tblPeriodDeal pd on pd.DealID =  n.DealID and tr.AnalysisID = pd.AnalysisID
	WHERE  acc.Isdeleted <> 1	and acc.AccountTypeID = 1
	and ( CAST(tr.Date as date) > CAST(pd.LastAccountingCloseDate as date) and CAST(tr.Date as date) <= CAST(pd.NewClosedate as date))	




END
