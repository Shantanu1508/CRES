-- Procedure
-- Procedure


CREATE PROCEDURE [dbo].[usp_ImportProductionDataIntoIntegration_InStagingTables]
AS
BEGIN
    SET NOCOUNT ON;
	
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @analysiID UNIQUEIDENTIFIER = (Select analysisID from  [dbo].[Ex_Prod_Analysis] where [name] = 'Default')

exec [dbo].[usp_Import_Prod_Note_InStagingTables]

truncate table [DW].[Staging_Cashflow]
truncate table [DW].[Staging_TransactionEntry]
truncate table [DW].[Staging_NoteFunding]
Truncate table [DW].[Staging_DealFundingSchdule]

INSERT INTO [DW].[Staging_NoteFunding]
([NoteID]
,[CRENoteID]
,[TransactionDate]
,[WireConfirm]
,[PurposeBI]
,[Amount]
,[DrawFundingID]
,[Comments]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy] 
,[UpdatedDate] )

Select	[NoteID]
,[CRENoteID]
,[TransactionDate]
,[WireConfirm]
,[PurposeBI]
,[Amount]
,[DrawFundingID]
,[Comments]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy] 
,[UpdatedDate]
From [dbo].[Ex_Prod_LatestNoteFunding]

PRINT('Staging_NoteFunding: '+CAST(@@ROWCOUNT as nvarchar(256)))
---------------------------------------


INSERT INTO [DW].[Staging_DealFundingSchdule]
([DealFundingID]
,[DealID]
,[CREDealID]
,[Date]
,[Amount] 
,[PurposeBI]
,[WireConfirm]
,[Comment]
,[DrawFundingId]	  
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate])
Select
d.[DealFundingID],
d.[DealID],
deal.[CREDealID],
d.[Date],
d.[Amount],
lPurpose.Name,
d.[Applied],
d.[Comment],
d.[DrawFundingId],
d.[CreatedBy],
d.[CreatedDate],
d.[UpdatedBy],
d.[UpdatedDate]
FROM EX_Prod_DealFunding d
inner join EX_Prod_Deal deal on d.DealID = deal.DealID
LEFT Join Core.Lookup lPurpose on d.PurposeID=lPurpose.LookupID and  ParentID = 50

PRINT('Staging_DealFundingSchdule: '+CAST(@@ROWCOUNT as nvarchar(256)))


INSERT INTO [DW].[Staging_TransactionEntry]
([TransactionEntryID]
,[NoteID]
,[CRENoteID]
,[Date]
,[Amount]
,[Type]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
,AnalysisID
,FeeName
,StrCreatedBy
,GeneratedBy
)

SELECT [TransactionEntryID]
,tr.[NoteID]
,n.[CRENoteID]
,tr.[Date]
,tr.[Amount]
,tr.[Type]
,tr.[CreatedBy]
,tr.[CreatedDate]
,tr.[UpdatedBy]
,tr.[UpdatedDate]
,tr.AnalysisID
,tr.FeeName
,tr.StrCreatedBy
,tr.GeneratedBy
FROM [dbo].[Ex_Prod_TransactionEntry] tr
Inner Join [dbo].[Ex_Prod_Note] n on n.noteid = tr.noteid  
Where tr.AnalysisID = @analysiID
PRINT('Staging_TransactionEntry: '+CAST(@@ROWCOUNT as nvarchar(256)))


INSERT INTO [DW].[Staging_Cashflow]
([NotePeriodicCalcID]
,[NoteID]
,[CRENoteID]
,[PeriodEndDate]
,[Month]
,[ActualCashFlows]
,[GAAPCashFlows]
,[EndingGAAPBookValue]
--,[TotalGAAPIncomeforthePeriod]
--,[InterestAccrualforthePeriod]
--,[PIKInterestAccrualforthePeriod]
,[TotalAmortAccrualForPeriod]
,[AccumulatedAmort]
,[BeginningBalance]
,[TotalFutureAdvancesForThePeriod]
,[TotalDiscretionaryCurtailmentsforthePeriod]
,[InterestPaidOnPaymentDate]
,[TotalCouponStrippedforthePeriod]
,[CouponStrippedonPaymentDate]
,[ScheduledPrincipal]
,[PrincipalPaid]
,[BalloonPayment]
,[EndingBalance]
,[ExitFeeIncludedInLevelYield]
,[ExitFeeExcludedFromLevelYield]
,[AdditionalFeesIncludedInLevelYield]
,[AdditionalFeesExcludedFromLevelYield]
,[OriginationFeeStripping]
,[ExitFeeStrippingIncldinLevelYield]
,[ExitFeeStrippingExcldfromLevelYield]
,[AddlFeesStrippingIncldinLevelYield]
,[AddlFeesStrippingExcldfromLevelYield]
,[EndOfPeriodWAL]
,[PIKInterestFromPIKSourceNote]
,[PIKInterestTransferredToRelatedNote]
,[PIKInterestForThePeriod]
,[BeginningPIKBalanceNotInsideLoanBalance]
,[PIKInterestForPeriodNotInsideLoanBalance]
,[PIKBalanceBalloonPayment]
,[EndingPIKBalanceNotInsideLoanBalance]
,[CostBasis]
,[PreCapBasis]
,[BasisCap]
,[AmortAccrualLevelYield]
,[ScheduledPrincipalShortfall]
,[PrincipalShortfall]
,[PrincipalLoss]
,[InterestForPeriodShortfall]
,[InterestPaidOnPMTDateShortfall]
,[CumulativeInterestPaidOnPMTDateShortfall]
,[InterestShortfallLoss]
,[InterestShortfallRecovery]
,[BeginningFinancingBalance]
,[TotalFinancingDrawsCurtailmentsForPeriod]
,[FinancingBalloon]
,[EndingFinancingBalance]
,[FinancingInterestPaid]
,[FinancingFeesPaid]
,[PeriodLeveredYield]
,[OrigFeeAccrual]
,[DiscountPremiumAccrual]
,[ExitFeeAccrual]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
,[AllInCouponRate]
,[CleanCost]
,[GrossDeferredFees]
,[DeferredFeesReceivable]
,[CleanCostPrice]
,[AmortizedCostPrice]
,[AdditionalFeeAccrual]
,[CapitalizedCostAccrual]
,[DailySpreadInterestbeforeStrippingRule]
,[DailyLiborInterestbeforeStrippingRule]
,[ReversalofPriorInterestAccrual]
,[InterestReceivedinCurrentPeriod]
,[CurrentPeriodInterestAccrual]
,[TotalGAAPInterestFortheCurrentPeriod]		   
,InvestmentBasis
--,CurrentPeriodInterestAccrualPeriodEnddate
,LIBORPercentage
,SpreadPercentage
,AnalysisID
,FeeStrippedforthePeriod
,PIKInterestPercentage
,AmortizedCost
,InterestSuspenseAccountActivityforthePeriod
,InterestSuspenseAccountBalance

,AccumaltedDiscountPremiumBI 
,AccumalatedCapitalizedCostBI
,NoteID_EODPeriodEndDateBI 
)
SELECT [NotePeriodicCalcID]
,cf.[NoteID]
,n.[CRENoteID]
,[PeriodEndDate]
,[Month]
,[ActualCashFlows]
,[GAAPCashFlows]
,[EndingGAAPBookValue]
--,[TotalGAAPIncomeforthePeriod]
--,[InterestAccrualforthePeriod]
--,[PIKInterestAccrualforthePeriod]
,[TotalAmortAccrualForPeriod]
,[AccumulatedAmort]
,[BeginningBalance]
,[TotalFutureAdvancesForThePeriod]
,[TotalDiscretionaryCurtailmentsforthePeriod]
,[InterestPaidOnPaymentDate]
,[TotalCouponStrippedforthePeriod]
,[CouponStrippedonPaymentDate]
,[ScheduledPrincipal]
,[PrincipalPaid]
,[BalloonPayment]
,[EndingBalance]
,[ExitFeeIncludedInLevelYield]
,[ExitFeeExcludedFromLevelYield]
,[AdditionalFeesIncludedInLevelYield]
,[AdditionalFeesExcludedFromLevelYield]
,[OriginationFeeStripping]
,[ExitFeeStrippingIncldinLevelYield]
,[ExitFeeStrippingExcldfromLevelYield]
,[AddlFeesStrippingIncldinLevelYield]
,[AddlFeesStrippingExcldfromLevelYield]
,[EndOfPeriodWAL]
,[PIKInterestFromPIKSourceNote]
,[PIKInterestTransferredToRelatedNote]
,[PIKInterestForThePeriod]
,[BeginningPIKBalanceNotInsideLoanBalance]
,[PIKInterestForPeriodNotInsideLoanBalance]
,[PIKBalanceBalloonPayment]
,[EndingPIKBalanceNotInsideLoanBalance]
,[CostBasis]
,[PreCapBasis]
,[BasisCap]
,[AmortAccrualLevelYield]
,[ScheduledPrincipalShortfall]
,[PrincipalShortfall]
,[PrincipalLoss]
,[InterestForPeriodShortfall]
,[InterestPaidOnPMTDateShortfall]
,[CumulativeInterestPaidOnPMTDateShortfall]
,[InterestShortfallLoss]
,[InterestShortfallRecovery]
,[BeginningFinancingBalance]
,[TotalFinancingDrawsCurtailmentsForPeriod]
,[FinancingBalloon]
,[EndingFinancingBalance]
,[FinancingInterestPaid]
,[FinancingFeesPaid]
,[PeriodLeveredYield]
,[OrigFeeAccrual]
,[DiscountPremiumAccrual]
,[ExitFeeAccrual]
,cf.[CreatedBy]
,cf.[CreatedDate]
,cf.[UpdatedBy]
,cf.[UpdatedDate]
,[AllInCouponRate]
,[CleanCost]
,[GrossDeferredFees]
,[DeferredFeesReceivable]
,[CleanCostPrice]
,[AmortizedCostPrice]
,[AdditionalFeeAccrual]
,[CapitalizedCostAccrual]
,[DailySpreadInterestbeforeStrippingRule]
,[DailyLiborInterestbeforeStrippingRule]
,[ReversalofPriorInterestAccrual]
,[InterestReceivedinCurrentPeriod]
,[CurrentPeriodInterestAccrual]
,[TotalGAAPInterestFortheCurrentPeriod]
,InvestmentBasis
--,CurrentPeriodInterestAccrualPeriodEnddate
,LIBORPercentage
,SpreadPercentage
,AnalysisID
,FeeStrippedforthePeriod
,PIKInterestPercentage
,AmortizedCost
,InterestSuspenseAccountActivityforthePeriod
,InterestSuspenseAccountBalance
,null as AccumaltedDiscountPremiumBI
,null as AccumalatedCapitalizedCostBI
--,SUM(ISNULL(cf.DiscountPremiumAccrual,0)) OVER(PARTITION BY cf.AnalysisID,cf.NoteID ORDER BY cf.AnalysisID,cf.NoteID,cf.PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumaltedDiscountPremiumBI
--,SUM(ISNULL(cf.CapitalizedCostAccrual,0)) OVER(PARTITION BY cf.AnalysisID,cf.NoteID ORDER BY cf.AnalysisID,cf.NoteID,cf.PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumalatedCapitalizedCostBI
,n.CRENoteID + '_'+ Convert(Varchar(10),EOMonth(cf.PeriodEndDate,0),110)  as NoteID_EODPeriodEndDateBI
FROM [dbo].[Ex_Prod_NotePeriodicCalc] cf
Inner Join [dbo].[Ex_Prod_Note] n on n.noteid = cf.noteid  
Where cf.AnalysisID = @analysiID

PRINT('Staging_Cashflow: '+CAST(@@ROWCOUNT as nvarchar(256)))

Update [DW].[Staging_Cashflow]  set [DW].[Staging_Cashflow].AccumaltedDiscountPremiumBI = a.AccumaltedDiscountPremiumBI,[DW].[Staging_Cashflow].AccumalatedCapitalizedCostBI = a.AccumalatedCapitalizedCostBI
From(
	SELECT [NotePeriodicCalcID]        
	,SUM(ISNULL(cf.DiscountPremiumAccrual,0)) OVER(PARTITION BY cf.AnalysisID,cf.NoteID ORDER BY cf.AnalysisID,cf.NoteID,cf.PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumaltedDiscountPremiumBI
	,SUM(ISNULL(cf.CapitalizedCostAccrual,0)) OVER(PARTITION BY cf.AnalysisID,cf.NoteID ORDER BY cf.AnalysisID,cf.NoteID,cf.PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumalatedCapitalizedCostBI
	FROM [DW].[Staging_Cashflow] cf
)a
where [DW].[Staging_Cashflow].[NotePeriodicCalcID] = a.[NotePeriodicCalcID]
---------------------------------------
 

PRINT('Insert - Start - DW.Staging_IntegartionCashFlowBI')

Truncate table DW.Staging_IntegartionCashFlowBI

INSERT INTO DW.Staging_IntegartionCashFlowBI (Scenario,AnalysisID,NoteKey,NoteID,PeriodEndDate,In_EndingGAAPBookValue,In_TotalAmortAccrualForPeriod,In_AccumulatedAmort,In_DiscountPremiumAccrual,In_AccumaltedDiscountPremium,In_CapitalizedCostAccrual,In_AccumalatedCapitalizedCost,In_CurrentPeriodInterestAccrualPeriodEnddate,St_EndingGAAPBookValue,St_TotalAmortAccrualForPeriod,St_AccumulatedAmort,St_DiscountPremiumAccrual,St_AccumaltedDiscountPremium,St_CapitalizedCostAccrual,St_AccumalatedCapitalizedCost,St_CurrentPeriodInterestAccrualPeriodEnddate)
Select 
In_np.Scenario
,In_np.AnalysisID
,In_np.NoteKey	
,In_np.NoteID	
,In_np.PeriodEndDate
,In_np.EndingGAAPBookValue as In_EndingGAAPBookValue
,In_np.TotalAmortAccrualForPeriod as In_TotalAmortAccrualForPeriod
,In_np.AccumulatedAmort as In_AccumulatedAmort
,In_np.DiscountPremiumAccrual as In_DiscountPremiumAccrual
,In_np.AccumaltedDiscountPremium as In_AccumaltedDiscountPremium
,In_np.CapitalizedCostAccrual as In_CapitalizedCostAccrual
,In_np.AccumalatedCapitalizedCost as In_AccumalatedCapitalizedCost
,In_np.CurrentPeriodInterestAccrualPeriodEnddate as In_CurrentPeriodInterestAccrualPeriodEnddate
,St_np.EndingGAAPBookValue as St_EndingGAAPBookValue
,St_np.TotalAmortAccrualForPeriod as St_TotalAmortAccrualForPeriod
,St_np.AccumulatedAmort as St_AccumulatedAmort
,St_np.DiscountPremiumAccrual as St_DiscountPremiumAccrual
,St_np.AccumaltedDiscountPremium as St_AccumaltedDiscountPremium
,St_np.CapitalizedCostAccrual as St_CapitalizedCostAccrual
,St_np.AccumalatedCapitalizedCost as St_AccumalatedCapitalizedCost
,St_np.CurrentPeriodInterestAccrualPeriodEnddate as St_CurrentPeriodInterestAccrualPeriodEnddate
from dbo.NotePeriodicCalc In_np
left join dbo.Staging_Cashflow St_np on In_np.NoteID = St_np.NoteID and In_np.AnalysisID = St_np.AnalysisID and In_np.PeriodEndDate = St_np.PeriodEndDate

PRINT('Insert - End - DW.Staging_IntegartionCashFlowBI')


SET TRANSACTION ISOLATION LEVEL READ COMMITTED



END


