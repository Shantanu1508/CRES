-- Procedure


-- Procedure


-- Procedure

CREATE PROCEDURE [DW].[usp_ImportNotePeriodicCalc]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
VALUES (@BatchLogId,'L_NotePeriodicCalcBI',GETDATE())

DECLARE @id int,@RowCount int
SET @id = (SELECT @@IDENTITY)


Truncate table [DW].[L_NotePeriodicCalcBI]

INSERT INTO [DW].[L_NotePeriodicCalcBI]
(NotePeriodicCalcID,
NoteID,
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
CurrentPeriodInterestAccrualPeriodEnddate,
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
AllInPIKRate,
CurrentPeriodPIKInterestAccrualPeriodEnddate,
PIKInterestPaidForThePeriod,
PIKInterestAppliedForThePeriod  ,

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
EndingPreCapGAAPBasis ,
PIKPrincipalPaidForThePeriod,
EndingBalanceBI_RP,
[RemainingUnfundedCommitment],
CurrentPeriodPIKInterestAccrual,
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
Select
NotePeriodicCalcID,
n.NoteID,
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
nc.CreatedBy,
nc.CreatedDate,
nc.UpdatedBy,
nc.UpdatedDate,
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
CurrentPeriodInterestAccrualPeriodEnddate,
NotePeriodicCalcAutoID,
LIBORPercentage,
SpreadPercentage,

nc.AnalysisID,
an.[Name] as AnalysisName,
FeeStrippedforthePeriod,
PIKInterestPercentage,
AmortizedCost,
d.CREDealID,
d.DealName,

nc.InterestSuspenseAccountActivityforthePeriod,
nc.InterestSuspenseAccountBalance,
nc.AllInBasisValuation,

SUM(ISNULL(nc.DiscountPremiumAccrual,0)) OVER(PARTITION BY nc.AnalysisID,n.NoteID ORDER BY nc.AnalysisID,n.NoteID,nc.PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumaltedDiscountPremiumBI,
SUM(ISNULL(nc.CapitalizedCostAccrual,0)) OVER(PARTITION BY nc.AnalysisID,n.NoteID ORDER BY nc.AnalysisID,n.NoteID,nc.PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumalatedCapitalizedCostBI,
n.CRENoteID + '_'+ Convert(Varchar(10),EOMonth(PeriodEndDate,0),110)  as NoteID_EODPeriodEndDateBI,
nc.AllInPIKRate,
nc.CurrentPeriodPIKInterestAccrualPeriodEnddate,
nc.PIKInterestPaidForThePeriod,
nc.PIKInterestAppliedForThePeriod  ,

nc.EndingPreCapPVBasis,
nc.LevelYieldIncomeForThePeriod,
nc.PVAmortTotalIncomeMethod,
nc.EndingCleanCostLY,
nc.EndingAccumAmort,
nc.PVAmortForThePeriod,
nc.EndingSLBasis,
nc.SLAmortForThePeriod,
nc.SLAmortOfTotalFeesInclInLY,
nc.SLAmortOfDiscountPremium,
nc.SLAmortOfCapCost,
nc.EndingAccumSLAmort,
nc.EndingPreCapGAAPBasis,
nc.PIKPrincipalPaidForThePeriod,
(CASE WHEN (n.InitialFundingAMount = 0.01 and ISNULL(nc.EndingBalance,0) <> 0) THEN ISNULL(nc.EndingBalance,0) - ISNULL(n.InitialFundingAMount,0)
 ELSE ISNULL(nc.EndingBalance,0)
 END
 )  as EndingBalanceBI_RP,
nc.[RemainingUnfundedCommitment],
nc.CurrentPeriodPIKInterestAccrual,

nc.AccountID,
acc.AccountTypeID,
ac.name as AccountTypeBI,
[CapitalizedCostAccumulatedAmort],
[DiscountPremiumAccumulatedAmort],
[PrincipalWriteoff],
[NetPIKAmountForThePeriod],
ParentAccountID	    ,
CashInterest		,
CapitalizedInterest	

From cre.NotePeriodicCalc nc
inner join core.account acc on acc.accountid = nc.AccountID
inner join cre.Note n on n.Account_AccountID = acc.AccountID
left join Core.Analysis an on an.AnalysisID = nc.AnalysisID
inner join cre.deal d on d.DealID = n.dealid
Left Join core.AccountCategory ac on ac.AccountCategoryID = acc.AccounttypeID

where d.isdeleted <> 1
and NotePeriodicCalcAutoID > (Select ISNULL(MAX(NotePeriodicCalcAutoID),0) from [DW].[NotePeriodicCalcBI])		




SET @RowCount = @@ROWCOUNT
Print(char(9) +'usp_ImportNotePeriodicCalc - ROWCOUNT = '+cast(@RowCount  as varchar(100)));


UPDATE [DW].BatchDetail SET LandingEndTime = GETDATE(),LandingRecordCount = @RowCount WHERE BatchDetailId = @id


SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END
GO