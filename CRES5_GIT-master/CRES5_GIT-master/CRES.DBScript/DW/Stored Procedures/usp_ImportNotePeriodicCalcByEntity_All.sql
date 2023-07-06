
CREATE PROCEDURE [DW].[usp_ImportNotePeriodicCalcByEntity_All]
AS
BEGIN
	SET NOCOUNT ON;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

--Declare @analysisID UNIQUEIDENTIFIER  = (Select analysisID from core.analysis where [Name] = 'Default')


Truncate table [DW].[NotePeriodicCalcByEntityBI_All] 


INSERT INTO [DW].[NotePeriodicCalcByEntityBI_All]
(NotePeriodicCalcID,
NotePeriodicCalcAutoID ,
NoteID,
CRENoteID,
EntityName,
PctAllocation,
PeriodEndDate,
[Month],
ActualCashFlows,
GAAPCashFlows,
EndingGAAPBookValue,
TotalGAAPIncomeforthePeriod,
InterestAccrualforthePeriod,
PIKInterestAccrualforthePeriod,
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
AccruedInterestBI ,
LIBORPercentage,
SpreadPercentage,
CreatedBy,
CreatedDate,
UpdatedBy,
UpdatedDate,
AnalysisID,
AnalysisName,
FeeStrippedforthePeriod,
PIKInterestPercentage,
FinancingSource,
ClientName
)

Select 

cf.NotePeriodicCalcID,
cf.NotePeriodicCalcAutoID ,
n.NoteID,n.crenoteid CRENoteID,

np.TrancheName as EntityName,
np.PercentofNote,

cf.PeriodEndDate,
cf.[Month],
(cf.ActualCashFlows  * PercentofNote)  as ActualCashFlows,
(cf.GAAPCashFlows  * PercentofNote)  as GAAPCashFlows,
(cf.EndingGAAPBookValue  * PercentofNote)  as EndingGAAPBookValue,
(cf.TotalGAAPIncomeforthePeriod  * PercentofNote)  as TotalGAAPIncomeforthePeriod,
(cf.InterestAccrualforthePeriod  * PercentofNote)  as InterestAccrualforthePeriod,
(cf.PIKInterestAccrualforthePeriod  * PercentofNote)  as PIKInterestAccrualforthePeriod,
(cf.TotalAmortAccrualForPeriod  * PercentofNote)  as TotalAmortAccrualForPeriod,
(cf.AccumulatedAmort  * PercentofNote)  as AccumulatedAmort,
(cf.BeginningBalance  * PercentofNote)  as BeginningBalance,
(cf.TotalFutureAdvancesForThePeriod  * PercentofNote)  as TotalFutureAdvancesForThePeriod,
(cf.TotalDiscretionaryCurtailmentsforthePeriod  * PercentofNote)  as TotalDiscretionaryCurtailmentsforthePeriod,
(cf.InterestPaidOnPaymentDate  * PercentofNote)  as InterestPaidOnPaymentDate,
(cf.TotalCouponStrippedforthePeriod  * PercentofNote)  as TotalCouponStrippedforthePeriod,
(cf.CouponStrippedonPaymentDate  * PercentofNote)  as CouponStrippedonPaymentDate,
(cf.ScheduledPrincipal  * PercentofNote)  as ScheduledPrincipal,
(cf.PrincipalPaid  * PercentofNote)  as PrincipalPaid,
(cf.BalloonPayment  * PercentofNote)  as BalloonPayment,
(cf.EndingBalance  * PercentofNote)  as EndingBalance,
--(cf.ExitFeeIncludedInLevelYield  * PercentofNote)  as ExitFeeIncludedInLevelYield,
--(cf.ExitFeeExcludedFromLevelYield  * PercentofNote)  as ExitFeeExcludedFromLevelYield,
--(cf.AdditionalFeesIncludedInLevelYield  * PercentofNote)  as AdditionalFeesIncludedInLevelYield,
--(cf.AdditionalFeesExcludedFromLevelYield  * PercentofNote)  as AdditionalFeesExcludedFromLevelYield,
--(cf.OriginationFeeStripping  * PercentofNote)  as OriginationFeeStripping,
--(cf.ExitFeeStrippingIncldinLevelYield  * PercentofNote)  as ExitFeeStrippingIncldinLevelYield,
--(cf.ExitFeeStrippingExcldfromLevelYield  * PercentofNote)  as ExitFeeStrippingExcldfromLevelYield,
--(cf.AddlFeesStrippingIncldinLevelYield  * PercentofNote)  as AddlFeesStrippingIncldinLevelYield,
--(cf.AddlFeesStrippingExcldfromLevelYield  * PercentofNote)  as AddlFeesStrippingExcldfromLevelYield,
(cf.EndOfPeriodWAL  * PercentofNote)  as EndOfPeriodWAL,
(cf.PIKInterestFromPIKSourceNote  * PercentofNote)  as PIKInterestFromPIKSourceNote,
(cf.PIKInterestTransferredToRelatedNote  * PercentofNote)  as PIKInterestTransferredToRelatedNote,
(cf.PIKInterestForThePeriod  * PercentofNote)  as PIKInterestForThePeriod,
(cf.BeginningPIKBalanceNotInsideLoanBalance  * PercentofNote)  as BeginningPIKBalanceNotInsideLoanBalance,
(cf.PIKInterestForPeriodNotInsideLoanBalance  * PercentofNote)  as PIKInterestForPeriodNotInsideLoanBalance,
(cf.PIKBalanceBalloonPayment  * PercentofNote)  as PIKBalanceBalloonPayment,
(cf.EndingPIKBalanceNotInsideLoanBalance  * PercentofNote)  as EndingPIKBalanceNotInsideLoanBalance,
(cf.CostBasis  * PercentofNote)  as CostBasis,
(cf.PreCapBasis  * PercentofNote)  as PreCapBasis,
(cf.BasisCap  * PercentofNote)  as BasisCap,
(cf.AmortAccrualLevelYield  * PercentofNote)  as AmortAccrualLevelYield,
(cf.ScheduledPrincipalShortfall  * PercentofNote)  as ScheduledPrincipalShortfall,
(cf.PrincipalShortfall  * PercentofNote)  as PrincipalShortfall,
(cf.PrincipalLoss  * PercentofNote)  as PrincipalLoss,
(cf.InterestForPeriodShortfall  * PercentofNote)  as InterestForPeriodShortfall,
(cf.InterestPaidOnPMTDateShortfall  * PercentofNote)  as InterestPaidOnPMTDateShortfall,
(cf.CumulativeInterestPaidOnPMTDateShortfall  * PercentofNote)  as CumulativeInterestPaidOnPMTDateShortfall,
(cf.InterestShortfallLoss  * PercentofNote)  as InterestShortfallLoss,
(cf.InterestShortfallRecovery  * PercentofNote)  as InterestShortfallRecovery,
(cf.BeginningFinancingBalance  * PercentofNote)  as BeginningFinancingBalance,
(cf.TotalFinancingDrawsCurtailmentsForPeriod  * PercentofNote)  as TotalFinancingDrawsCurtailmentsForPeriod,
(cf.FinancingBalloon  * PercentofNote)  as FinancingBalloon,
(cf.EndingFinancingBalance  * PercentofNote)  as EndingFinancingBalance,
(cf.FinancingInterestPaid  * PercentofNote)  as FinancingInterestPaid,
(cf.FinancingFeesPaid  * PercentofNote)  as FinancingFeesPaid,
(cf.PeriodLeveredYield  * PercentofNote)  as PeriodLeveredYield,
(cf.OrigFeeAccrual   * PercentofNote)  as OrigFeeAccrual ,
(cf.DiscountPremiumAccrual    * PercentofNote)  as DiscountPremiumAccrual  ,
(cf.ExitFeeAccrual    * PercentofNote)  as ExitFeeAccrual  ,
(cf.AllInCouponRate  * PercentofNote)  as AllInCouponRate,
(cf.CleanCost  * PercentofNote)  as CleanCost,
(cf.GrossDeferredFees  * PercentofNote)  as GrossDeferredFees,
(cf.DeferredFeesReceivable  * PercentofNote)  as DeferredFeesReceivable,
(cf.CleanCostPrice  * PercentofNote)  as CleanCostPrice,
(cf.AmortizedCostPrice  * PercentofNote)  as AmortizedCostPrice,
(cf.AdditionalFeeAccrual  * PercentofNote)  as AdditionalFeeAccrual,
(cf.CapitalizedCostAccrual  * PercentofNote)  as CapitalizedCostAccrual,
(cf.DailySpreadInterestbeforeStrippingRule  * PercentofNote)  as DailySpreadInterestbeforeStrippingRule,
(cf.DailyLiborInterestbeforeStrippingRule  * PercentofNote)  as DailyLiborInterestbeforeStrippingRule,
(cf.ReversalofPriorInterestAccrual  * PercentofNote)  as ReversalofPriorInterestAccrual,
(cf.InterestReceivedinCurrentPeriod  * PercentofNote)  as InterestReceivedinCurrentPeriod,
(cf.CurrentPeriodInterestAccrual  * PercentofNote)  as CurrentPeriodInterestAccrual,
(cf.TotalGAAPInterestFortheCurrentPeriod  * PercentofNote)  as TotalGAAPInterestFortheCurrentPeriod,
(cf.InvestmentBasis  * PercentofNote)  as InvestmentBasis,
(cf.CurrentPeriodInterestAccrualPeriodEnddate  * PercentofNote)  as CurrentPeriodInterestAccrualPeriodEnddate,
(cf.AccruedInterestBI  * PercentofNote)  as AccruedInterestBI,
(cf.LIBORPercentage  * PercentofNote)  as LIBORPercentage,
(cf.SpreadPercentage  * PercentofNote)  as SpreadPercentage,
cf.CreatedBy,
cf.CreatedDate,
cf.UpdatedBy,
cf.UpdatedDate,
cf.AnalysisID,
cf.AnalysisName,
(cf.FeeStrippedforthePeriod  * PercentofNote)  as FeeStrippedforthePeriod, 
(cf.PIKInterestPercentage  * PercentofNote)  as PIKInterestPercentage,


LFinancingSourceID.FinancingSourceName as FinancingSource,
c.ClientName

from cre.note n 
inner join core.account acc on acc.accountid = n.account_accountid
inner join cre.deal d on d.dealid = n.dealid  
left join CRE.NoteTranchePercentage np on np.crenoteid = n.crenoteid
left join [CRE].[FinancingSourceMaster] LFinancingSourceID on LFinancingSourceID.FinancingSourceMasterID = n.FinancingSourceID
left join cre.Client c on c.ClientID = n.ClientID
inner join DW.NotePeriodicCalcBI cf on cf.noteid = n.noteid and cf.analysisID in (Select analysisID from core.analysis where [Name] in ('Default','Fully Extended (FWCV)','Expected Maturity Date (with Prepay, FWCV)','Expected Maturity Date (with Prepay, Index Flat)') )
and cf.PeriodEndDate >= CAST(DateADD(year,-1,getdate())  as Date) ---and cf.PeriodEndDate <= CAST(getdate() as Date))

where acc.isdeleted <> 1 and d.isdeleted <> 1
and cf.analysisID in (Select analysisID from core.analysis where [Name] in ('Default','Fully Extended (FWCV)','Expected Maturity Date (with Prepay, FWCV)','Expected Maturity Date (with Prepay, Index Flat)') )
and cf.PeriodEndDate >= CAST(DateADD(year,-1,getdate())  as Date) 
and cf.[Month] is not null 


SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END


