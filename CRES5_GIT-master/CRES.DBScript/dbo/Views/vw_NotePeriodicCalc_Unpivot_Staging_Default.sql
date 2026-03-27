
CREATE VIEW [dbo].[vw_NotePeriodicCalc_Unpivot_Staging_Default]
AS
Select Scenario,dealname,credealid,crenoteid,[Type],PeriodEndDate,[Value]
From(
	Select a.Name as Scenario,d.dealname,d.credealid,n.crenoteid,
	nc.PeriodEndDate	
	,ISNULL(ActualCashFlows,0) as ActualCashFlows
	,ISNULL(GAAPCashFlows,0) as GAAPCashFlows
	,ISNULL(EndingGAAPBookValue,0) as EndingGAAPBookValue
	,ISNULL(TotalGAAPIncomeforthePeriod,0) as TotalGAAPIncomeforthePeriod
	,ISNULL(InterestAccrualforthePeriod,0) as InterestAccrualforthePeriod
	,ISNULL(PIKInterestAccrualforthePeriod,0) as PIKInterestAccrualforthePeriod
	,ISNULL(TotalAmortAccrualForPeriod,0) as TotalAmortAccrualForPeriod
	,ISNULL(AccumulatedAmort,0) as AccumulatedAmort
	,ISNULL(BeginningBalance,0) as BeginningBalance
	,ISNULL(TotalFutureAdvancesForThePeriod,0) as TotalFutureAdvancesForThePeriod
	,ISNULL(TotalDiscretionaryCurtailmentsforthePeriod,0) as TotalDiscretionaryCurtailmentsforthePeriod
	,ISNULL(InterestPaidOnPaymentDate,0) as InterestPaidOnPaymentDate
	,ISNULL(TotalCouponStrippedforthePeriod,0) as TotalCouponStrippedforthePeriod
	,ISNULL(CouponStrippedonPaymentDate,0) as CouponStrippedonPaymentDate
	,ISNULL(ScheduledPrincipal,0) as ScheduledPrincipal
	,ISNULL(PrincipalPaid,0) as PrincipalPaid
	,ISNULL(BalloonPayment,0) as BalloonPayment
	,ISNULL(EndingBalance,0) as EndingBalance
	,ISNULL(ExitFeeIncludedInLevelYield,0) as ExitFeeIncludedInLevelYield
	,ISNULL(ExitFeeExcludedFromLevelYield,0) as ExitFeeExcludedFromLevelYield
	,ISNULL(AdditionalFeesIncludedInLevelYield,0) as AdditionalFeesIncludedInLevelYield
	,ISNULL(AdditionalFeesExcludedFromLevelYield,0) as AdditionalFeesExcludedFromLevelYield
	,ISNULL(OriginationFeeStripping,0) as OriginationFeeStripping
	,ISNULL(ExitFeeStrippingIncldinLevelYield,0) as ExitFeeStrippingIncldinLevelYield
	,ISNULL(ExitFeeStrippingExcldfromLevelYield,0) as ExitFeeStrippingExcldfromLevelYield
	,ISNULL(AddlFeesStrippingIncldinLevelYield,0) as AddlFeesStrippingIncldinLevelYield
	,ISNULL(AddlFeesStrippingExcldfromLevelYield,0) as AddlFeesStrippingExcldfromLevelYield
	,ISNULL(EndOfPeriodWAL,0) as EndOfPeriodWAL
	,ISNULL(PIKInterestFromPIKSourceNote,0) as PIKInterestFromPIKSourceNote
	,ISNULL(PIKInterestTransferredToRelatedNote,0) as PIKInterestTransferredToRelatedNote
	,ISNULL(PIKInterestForThePeriod,0) as PIKInterestForThePeriod
	,ISNULL(BeginningPIKBalanceNotInsideLoanBalance,0) as BeginningPIKBalanceNotInsideLoanBalance
	,ISNULL(PIKInterestForPeriodNotInsideLoanBalance,0) as PIKInterestForPeriodNotInsideLoanBalance
	,ISNULL(PIKBalanceBalloonPayment,0) as PIKBalanceBalloonPayment
	,ISNULL(EndingPIKBalanceNotInsideLoanBalance,0) as EndingPIKBalanceNotInsideLoanBalance
	,ISNULL(CostBasis,0) as CostBasis
	,ISNULL(PreCapBasis,0) as PreCapBasis
	,ISNULL(BasisCap,0) as BasisCap
	,ISNULL(AmortAccrualLevelYield,0) as AmortAccrualLevelYield
	,ISNULL(ScheduledPrincipalShortfall,0) as ScheduledPrincipalShortfall
	,ISNULL(PrincipalShortfall,0) as PrincipalShortfall
	,ISNULL(PrincipalLoss,0) as PrincipalLoss
	,ISNULL(InterestForPeriodShortfall,0) as InterestForPeriodShortfall
	,ISNULL(InterestPaidOnPMTDateShortfall,0) as InterestPaidOnPMTDateShortfall
	,ISNULL(CumulativeInterestPaidOnPMTDateShortfall,0) as CumulativeInterestPaidOnPMTDateShortfall
	,ISNULL(InterestShortfallLoss,0) as InterestShortfallLoss
	,ISNULL(InterestShortfallRecovery,0) as InterestShortfallRecovery
	,ISNULL(BeginningFinancingBalance,0) as BeginningFinancingBalance
	,ISNULL(TotalFinancingDrawsCurtailmentsForPeriod,0) as TotalFinancingDrawsCurtailmentsForPeriod
	,ISNULL(FinancingBalloon,0) as FinancingBalloon
	,ISNULL(EndingFinancingBalance,0) as EndingFinancingBalance
	,ISNULL(FinancingInterestPaid,0) as FinancingInterestPaid
	,ISNULL(FinancingFeesPaid,0) as FinancingFeesPaid
	,ISNULL(PeriodLeveredYield,0) as PeriodLeveredYield
	,ISNULL(OrigFeeAccrual,0) as OrigFeeAccrual
	,ISNULL(DiscountPremiumAccrual,0) as DiscountPremiumAccrual
	,ISNULL(ExitFeeAccrual,0) as ExitFeeAccrual
	,ISNULL(AllInCouponRate,0) as AllInCouponRate
	,ISNULL(GrossDeferredFees,0) as GrossDeferredFees
	,ISNULL(DeferredFeesReceivable,0) as DeferredFeesReceivable
	,ISNULL(CleanCostPrice,0) as CleanCostPrice
	,ISNULL(AmortizedCostPrice,0) as AmortizedCostPrice
	,ISNULL(AdditionalFeeAccrual,0) as AdditionalFeeAccrual
	,ISNULL(CapitalizedCostAccrual,0) as CapitalizedCostAccrual
	,ISNULL(DailySpreadInterestbeforeStrippingRule,0) as DailySpreadInterestbeforeStrippingRule
	,ISNULL(DailyLiborInterestbeforeStrippingRule,0) as DailyLiborInterestbeforeStrippingRule
	,ISNULL(ReversalofPriorInterestAccrual,0) as ReversalofPriorInterestAccrual
	,ISNULL(InterestReceivedinCurrentPeriod,0) as InterestReceivedinCurrentPeriod
	,ISNULL(CurrentPeriodInterestAccrual,0) as CurrentPeriodInterestAccrual
	,ISNULL(TotalGAAPInterestFortheCurrentPeriod,0) as TotalGAAPInterestFortheCurrentPeriod
	,ISNULL(CleanCost,0) as CleanCost
	,ISNULL(InvestmentBasis,0) as InvestmentBasis
	,ISNULL(CurrentPeriodInterestAccrualPeriodEnddate,0) as CurrentPeriodInterestAccrualPeriodEnddate
	,ISNULL(LIBORPercentage,0) as LIBORPercentage
	,ISNULL(SpreadPercentage,0) as SpreadPercentage
	,ISNULL(FeeStrippedforthePeriod,0) as FeeStrippedforthePeriod
	,ISNULL(PIKInterestPercentage,0) as PIKInterestPercentage
	,ISNULL(AmortizedCost,0) as AmortizedCost
	,ISNULL(InterestSuspenseAccountActivityforthePeriod,0) as InterestSuspenseAccountActivityforthePeriod
	,ISNULL(InterestSuspenseAccountBalance,0) as InterestSuspenseAccountBalance
	,ISNULL(AllInBasisValuation,0) as AllInBasisValuation
	,ISNULL(AllInPIKRate,0) as AllInPIKRate
	,ISNULL(CurrentPeriodPIKInterestAccrualPeriodEnddate,0) as CurrentPeriodPIKInterestAccrualPeriodEnddate
	,ISNULL(PIKInterestPaidForThePeriod,0) as PIKInterestPaidForThePeriod
	,ISNULL(PIKInterestAppliedForThePeriod,0) as PIKInterestAppliedForThePeriod
	,ISNULL(EndingPreCapPVBasis,0) as EndingPreCapPVBasis
	,ISNULL(LevelYieldIncomeForThePeriod,0) as LevelYieldIncomeForThePeriod
	,ISNULL(PVAmortTotalIncomeMethod,0) as PVAmortTotalIncomeMethod
	,ISNULL(EndingCleanCostLY,0) as EndingCleanCostLY
	,ISNULL(EndingAccumAmort,0) as EndingAccumAmort
	,ISNULL(PVAmortForThePeriod,0) as PVAmortForThePeriod
	,ISNULL(EndingSLBasis,0) as EndingSLBasis
	,ISNULL(SLAmortForThePeriod,0) as SLAmortForThePeriod
	,ISNULL(SLAmortOfTotalFeesInclInLY,0) as SLAmortOfTotalFeesInclInLY
	,ISNULL(SLAmortOfDiscountPremium,0) as SLAmortOfDiscountPremium
	,ISNULL(SLAmortOfCapCost,0) as SLAmortOfCapCost
	,ISNULL(EndingAccumSLAmort,0) as EndingAccumSLAmort
	,ISNULL(EndingPreCapGAAPBasis,0) as EndingPreCapGAAPBasis
	,ISNULL(PIKPrincipalPaidForThePeriod,0) as PIKPrincipalPaidForThePeriod
	from [DW].[Staging_Cashflow] nc
	inner join cre.note n on n.noteid = nc.noteid
	inner join core.account acc on acc.accountid = n.account_accountid
	inner join cre.deal d on d.dealid = n.dealid
	left join core.analysis a on a.analysisid = nc.analysisid
	where nc.analysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and nc.[month] is not null
	---and n.crenoteid = '2230'
)a
UNPIVOT 
(
	[Value] FOR [Type] IN (
	ActualCashFlows
	,GAAPCashFlows
	,EndingGAAPBookValue
	,TotalGAAPIncomeforthePeriod
	,InterestAccrualforthePeriod
	,PIKInterestAccrualforthePeriod
	,TotalAmortAccrualForPeriod
	,AccumulatedAmort
	,BeginningBalance
	,TotalFutureAdvancesForThePeriod
	,TotalDiscretionaryCurtailmentsforthePeriod
	,InterestPaidOnPaymentDate
	,TotalCouponStrippedforthePeriod
	,CouponStrippedonPaymentDate
	,ScheduledPrincipal
	,PrincipalPaid
	,BalloonPayment
	,EndingBalance
	,ExitFeeIncludedInLevelYield
	,ExitFeeExcludedFromLevelYield
	,AdditionalFeesIncludedInLevelYield
	,AdditionalFeesExcludedFromLevelYield
	,OriginationFeeStripping
	,ExitFeeStrippingIncldinLevelYield
	,ExitFeeStrippingExcldfromLevelYield
	,AddlFeesStrippingIncldinLevelYield
	,AddlFeesStrippingExcldfromLevelYield
	,EndOfPeriodWAL
	,PIKInterestFromPIKSourceNote
	,PIKInterestTransferredToRelatedNote
	,PIKInterestForThePeriod
	,BeginningPIKBalanceNotInsideLoanBalance
	,PIKInterestForPeriodNotInsideLoanBalance
	,PIKBalanceBalloonPayment
	,EndingPIKBalanceNotInsideLoanBalance
	,CostBasis
	,PreCapBasis
	,BasisCap
	,AmortAccrualLevelYield
	,ScheduledPrincipalShortfall
	,PrincipalShortfall
	,PrincipalLoss
	,InterestForPeriodShortfall
	,InterestPaidOnPMTDateShortfall
	,CumulativeInterestPaidOnPMTDateShortfall
	,InterestShortfallLoss
	,InterestShortfallRecovery
	,BeginningFinancingBalance
	,TotalFinancingDrawsCurtailmentsForPeriod
	,FinancingBalloon
	,EndingFinancingBalance
	,FinancingInterestPaid
	,FinancingFeesPaid
	,PeriodLeveredYield
	,OrigFeeAccrual
	,DiscountPremiumAccrual
	,ExitFeeAccrual
	,AllInCouponRate
	,GrossDeferredFees
	,DeferredFeesReceivable
	,CleanCostPrice
	,AmortizedCostPrice
	,AdditionalFeeAccrual
	,CapitalizedCostAccrual
	,DailySpreadInterestbeforeStrippingRule
	,DailyLiborInterestbeforeStrippingRule
	,ReversalofPriorInterestAccrual
	,InterestReceivedinCurrentPeriod
	,CurrentPeriodInterestAccrual
	,TotalGAAPInterestFortheCurrentPeriod
	,CleanCost
	,InvestmentBasis
	,CurrentPeriodInterestAccrualPeriodEnddate
	,LIBORPercentage
	,SpreadPercentage
	,FeeStrippedforthePeriod
	,PIKInterestPercentage
	,AmortizedCost
	,InterestSuspenseAccountActivityforthePeriod
	,InterestSuspenseAccountBalance
	,AllInBasisValuation
	,AllInPIKRate
	,CurrentPeriodPIKInterestAccrualPeriodEnddate
	,PIKInterestPaidForThePeriod
	,PIKInterestAppliedForThePeriod
	,EndingPreCapPVBasis
	,LevelYieldIncomeForThePeriod
	,PVAmortTotalIncomeMethod
	,EndingCleanCostLY
	,EndingAccumAmort
	,PVAmortForThePeriod
	,EndingSLBasis
	,SLAmortForThePeriod
	,SLAmortOfTotalFeesInclInLY
	,SLAmortOfDiscountPremium
	,SLAmortOfCapCost
	,EndingAccumSLAmort
	,EndingPreCapGAAPBasis
	,PIKPrincipalPaidForThePeriod)
) as sq_up

--order by Scenario,dealname,crenoteid,[Type],PeriodEndDate