-- Procedure  
  
  
  
CREATE PROCEDURE [DW].[usp_MergeNotePeriodicCalc]  
  
@BatchLogId int  
  
AS  
BEGIN  
  
SET NOCOUNT ON  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   
  
  
UPDATE [DW].BatchDetail  
SET  
BITableName = 'NotePeriodicCalcBI',  
BIStartTime = GETDATE()  
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_NotePeriodicCalcBI'  
  
  
IF EXISTS(Select top 1 NoteID from [dw].[L_NotePeriodicCalcBI])  
BEGIN  
  
  
Delete ncBI from [DW].[NotePeriodicCalcBI] ncBI  
inner join   
(  
 Select Distinct NoteID,AnalysisID from [DW].[L_NotePeriodicCalcBI]  
  
)L on L.Noteid = ncBI.Noteid and ncBI.AnalysisID = L.AnalysisID  
  
  
--Delete from [DW].[NotePeriodicCalcBI] where NoteID in (Select Distinct NoteID,AnalysisID from [DW].[L_NotePeriodicCalcBI])  
  
  
INSERT INTO [DW].[NotePeriodicCalcBI]  
(NotePeriodicCalcID,  
NoteID,  
CRENoteID,  
PeriodEndDate,  
[Month],  
ActualCashFlows,  
GAAPCashFlows,  
EndingGAAPBookValue,  
--TotalGAAPIncomeforthePeriod,  
--InterestAccrualforthePeriod,  
--PIKInterestAccrualforthePeriod,  
TotalAmortAccrualForPeriod,  
AccumulatedAmort,  
BeginningBalance,  
TotalFutureAdvancesForThePeriod,  
TotalDiscretionaryCurtailmentsforthePeriod,  
InterestPaidOnPaymentDate,  
TotalCouponStrippedforthePeriod,  
CouponStrippedonPaymentDate,  
ScheduledPrincipal,  
PrincipalPaid,  
BalloonPayment,  
EndingBalance,  
  
--ExitFeeIncludedInLevelYield,  
--ExitFeeExcludedFromLevelYield,  
--AdditionalFeesIncludedInLevelYield,  
--AdditionalFeesExcludedFromLevelYield,  
--OriginationFeeStripping,  
--ExitFeeStrippingIncldinLevelYield,  
--ExitFeeStrippingExcldfromLevelYield,  
--AddlFeesStrippingIncldinLevelYield,  
--AddlFeesStrippingExcldfromLevelYield,  
  
EndOfPeriodWAL,  
PIKInterestFromPIKSourceNote,  
PIKInterestTransferredToRelatedNote,  
PIKInterestForThePeriod,  
BeginningPIKBalanceNotInsideLoanBalance,  
PIKInterestForPeriodNotInsideLoanBalance,  
PIKBalanceBalloonPayment,  
EndingPIKBalanceNotInsideLoanBalance,  
CostBasis,  
PreCapBasis,  
BasisCap,  
AmortAccrualLevelYield,  
ScheduledPrincipalShortfall,  
PrincipalShortfall,  
PrincipalLoss,  
InterestForPeriodShortfall,  
InterestPaidOnPMTDateShortfall,  
CumulativeInterestPaidOnPMTDateShortfall,  
InterestShortfallLoss,  
InterestShortfallRecovery,  
BeginningFinancingBalance,  
TotalFinancingDrawsCurtailmentsForPeriod,  
FinancingBalloon,  
EndingFinancingBalance,  
FinancingInterestPaid,  
FinancingFeesPaid,  
PeriodLeveredYield,  
OrigFeeAccrual ,  
DiscountPremiumAccrual  ,  
ExitFeeAccrual  ,  
CreatedBy,  
CreatedDate,  
UpdatedBy,  
UpdatedDate,  
AllInCouponRate,  
[CleanCost],  
[GrossDeferredFees],  
[DeferredFeesReceivable],  
[CleanCostPrice],  
[AmortizedCostPrice],  
[AdditionalFeeAccrual],  
[CapitalizedCostAccrual],  
DailySpreadInterestbeforeStrippingRule,  
DailyLiborInterestbeforeStrippingRule,  
ReversalofPriorInterestAccrual,  
InterestReceivedinCurrentPeriod,  
CurrentPeriodInterestAccrual,  
TotalGAAPInterestFortheCurrentPeriod,  
InvestmentBasis,  
--CurrentPeriodInterestAccrual,  
NotePeriodicCalcAutoID,  
LIBORPercentage,  
SpreadPercentage,  
AnalysisID,  
AnalysisName,  
FeeStrippedforthePeriod,  
PIKInterestPercentage,  
AmortizedCost ,  
CREDealID,  
DealName,  
InterestSuspenseAccountActivityforthePeriod,  
InterestSuspenseAccountBalance,  
AllInBasisValuation,  
AccumaltedDiscountPremiumBI ,  
AccumalatedCapitalizedCostBI,  
NoteID_EODPeriodEndDateBI,  
AccruedInterestBI,  
BSCurrentBalance,  
AllInPIKRate,  
CurrentPeriodPIKInterestAccrual,  
  
ActualPayoffdate,  
FullyExtendedMaturityDate,  
PIK_nonPIK,  
FinancingSource,  
  
PIKInterestPaidForThePeriod,  
PIKInterestAppliedForThePeriod ,  
  
EndingPreCapPVBasis,  
LevelYieldIncomeForThePeriod,  
PVAmortTotalIncomeMethod,  
EndingCleanCostLY,  
EndingAccumAmort,  
PVAmortForThePeriod,  
EndingSLBasis,  
SLAmortForThePeriod,  
SLAmortOfTotalFeesInclInLY,  
SLAmortOfDiscountPremium,  
SLAmortOfCapCost,  
EndingAccumSLAmort,  
EndingPreCapGAAPBasis,  
PIKPrincipalPaidForThePeriod,  
EndingBalanceBI_RP,  
[RemainingUnfundedCommitment]  ,
CurrentPeriodInterestAccrualPeriodEnddate,
CurrentPeriodPIKInterestAccrualPeriodEnddate,
AccountID,
AccountTypeID,
AccountTypeBI,
[CapitalizedCostAccumulatedAmort],
[DiscountPremiumAccumulatedAmort],
[PrincipalWriteoff],
[NetPIKAmountForThePeriod],
ParentAccountID	    ,
CashInterest		,
CapitalizedInterest	
)  
Select Distinct  
NotePeriodicCalcID,  
tb.NoteID,  n.CRENoteID,  
tb.PeriodEndDate,  
[Month],  
ActualCashFlows,  
GAAPCashFlows,  
EndingGAAPBookValue,  
--TotalGAAPIncomeforthePeriod,  
--InterestAccrualforthePeriod,  
--PIKInterestAccrualforthePeriod,  
TotalAmortAccrualForPeriod,  
AccumulatedAmort,  
BeginningBalance,  
TotalFutureAdvancesForThePeriod,  
TotalDiscretionaryCurtailmentsforthePeriod,  
InterestPaidOnPaymentDate,  
TotalCouponStrippedforthePeriod,  
CouponStrippedonPaymentDate,  
ScheduledPrincipal,  
PrincipalPaid,  
BalloonPayment,  
EndingBalance,  
  
--ExitFeeIncludedInLevelYield,  
--ExitFeeExcludedFromLevelYield,  
--AdditionalFeesIncludedInLevelYield,  
--AdditionalFeesExcludedFromLevelYield,  
--OriginationFeeStripping,  
--ExitFeeStrippingIncldinLevelYield,  
--ExitFeeStrippingExcldfromLevelYield,  
--AddlFeesStrippingIncldinLevelYield,  
--AddlFeesStrippingExcldfromLevelYield,  
  
EndOfPeriodWAL,  
PIKInterestFromPIKSourceNote,  
PIKInterestTransferredToRelatedNote,  
PIKInterestForThePeriod,  
BeginningPIKBalanceNotInsideLoanBalance,  
PIKInterestForPeriodNotInsideLoanBalance,  
PIKBalanceBalloonPayment,  
EndingPIKBalanceNotInsideLoanBalance,  
CostBasis,  
PreCapBasis,  
BasisCap,  
AmortAccrualLevelYield,  
ScheduledPrincipalShortfall,  
PrincipalShortfall,  
PrincipalLoss,  
InterestForPeriodShortfall,  
InterestPaidOnPMTDateShortfall,  
CumulativeInterestPaidOnPMTDateShortfall,  
InterestShortfallLoss,  
InterestShortfallRecovery,  
BeginningFinancingBalance,  
TotalFinancingDrawsCurtailmentsForPeriod,  
FinancingBalloon,  
EndingFinancingBalance,  
FinancingInterestPaid,  
FinancingFeesPaid,  
PeriodLeveredYield,  
OrigFeeAccrual ,  
DiscountPremiumAccrual  ,  
ExitFeeAccrual  ,  
tb.CreatedBy,  
tb.CreatedDate,  
tb.UpdatedBy,  
tb.UpdatedDate,  
AllInCouponRate,  
[CleanCost],  
[GrossDeferredFees],  
[DeferredFeesReceivable],  
[CleanCostPrice],  
[AmortizedCostPrice],  
[AdditionalFeeAccrual],  
[CapitalizedCostAccrual],  
DailySpreadInterestbeforeStrippingRule,  
DailyLiborInterestbeforeStrippingRule,  
ReversalofPriorInterestAccrual,  
InterestReceivedinCurrentPeriod,  
CurrentPeriodInterestAccrual,  
TotalGAAPInterestFortheCurrentPeriod,  
InvestmentBasis,  
---CurrentPeriodInterestAccrual,  
NotePeriodicCalcAutoID,  
LIBORPercentage,  
SpreadPercentage,  
AnalysisID,  
AnalysisName,  
FeeStrippedforthePeriod,  
PIKInterestPercentage,  
AmortizedCost,  
CREDealID,  
DealName,  
InterestSuspenseAccountActivityforthePeriod,  
InterestSuspenseAccountBalance,  
AllInBasisValuation,  
AccumaltedDiscountPremiumBI ,  
AccumalatedCapitalizedCostBI,  
NoteID_EODPeriodEndDateBI,  
SUM(ISNULL(tb.InterestReceivedinCurrentPeriod,0)) OVER(PARTITION BY tb.AnalysisID,tb.NoteID ORDER BY tb.AnalysisID,tb.NoteID,tb.PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccruedInterest,  
BSCash.CurrentBalance,  
tb.AllInPIKRate,  
tb.CurrentPeriodPIKInterestAccrual,  
  
n.ActualPayoffdate,  
n.FullyExtendedMaturityDate,  
n.PIK_nonPIK,  
n.FinancingSourceBI,  
tb.PIKInterestPaidForThePeriod,  
tb.PIKInterestAppliedForThePeriod ,  
  
EndingPreCapPVBasis,  
LevelYieldIncomeForThePeriod,  
PVAmortTotalIncomeMethod,  
EndingCleanCostLY,  
EndingAccumAmort,  
PVAmortForThePeriod,  
EndingSLBasis,  
SLAmortForThePeriod,  
SLAmortOfTotalFeesInclInLY,  
SLAmortOfDiscountPremium,  
SLAmortOfCapCost,  
EndingAccumSLAmort,  
EndingPreCapGAAPBasis,  
tb.PIKPrincipalPaidForThePeriod,  
tb.EndingBalanceBI_RP,  
tb.[RemainingUnfundedCommitment]  ,
tb.CurrentPeriodInterestAccrualPeriodEnddate,
tb.CurrentPeriodPIKInterestAccrualPeriodEnddate,
tb.AccountID,
tb.AccountTypeID,
tb.AccountTypeBI,
[CapitalizedCostAccumulatedAmort],
[DiscountPremiumAccumulatedAmort],
[PrincipalWriteoff],
[NetPIKAmountForThePeriod],
ParentAccountID	    ,
CashInterest		,
CapitalizedInterest	
From [dw].[L_NotePeriodicCalcBI]  tb  
Inner Join [DW].[NoteBI] n on n.NoteID = tb.NoteID  
left join (  
 Select Distinct DealID,NoteId,CurrentBalance,PeriodEndDate from [DW].[UwCashflowBI]  
) BSCash on n.CRENoteId = BSCash.noteid and tb.PeriodEndDate = BSCash.PeriodEndDate  
  
END  
  
  
DECLARE @RowCount int  
SET @RowCount = @@ROWCOUNT  
  
UPDATE [DW].BatchDetail  
SET  
BIEndTime = GETDATE(),  
BIRecordCount = @RowCount  
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_NotePeriodicCalcBI'  
  
----------------------------------------------------  
--Truncate table [DW].[L_NotePeriodicCalcBI]  
----------------------------------------------------  
  
Print(char(9) +'usp_MergeNotePeriodicCalc - ROWCOUNT = '+cast(@RowCount  as varchar(100)));  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED   
  
  
END  