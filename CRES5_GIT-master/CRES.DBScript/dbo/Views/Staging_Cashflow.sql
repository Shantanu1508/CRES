CREATE view [dbo].[Staging_Cashflow]  
as   
select     
N.NoteID as NoteKey,    
CRENoteID as NoteID,    
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
ExitFeeIncludedInLevelYield,    
ExitFeeExcludedFromLevelYield,    
AdditionalFeesIncludedInLevelYield,    
AdditionalFeesExcludedFromLevelYield,    
OriginationFeeStripping,    
ExitFeeStrippingIncldinLevelYield,    
ExitFeeStrippingExcldfromLevelYield,    
AddlFeesStrippingIncldinLevelYield,    
AddlFeesStrippingExcldfromLevelYield,    
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
TotalGAAPInterestFortheCurrentPeriod    
,NoteID_EODPeriodEndDateBI as NoteID_Date    
,AnalysisID  
  
,AccumaltedDiscountPremiumBI AS AccumaltedDiscountPremium  
,AccumalatedCapitalizedCostBI AS AccumalatedCapitalizedCost  
   
,[CurrentPeriodInterestAccrualPeriodEnddate]  
 
,RemainingUnfundedCommitment
,CalcEngineType
,levyld
,cum_dailypikint
,cum_baladdon_am
,cum_baladdon_nonam
,cum_dailyint
,cum_ddbaladdon
,cum_ddintdelta
,initbal
,cum_fee_levyld
,period_ddintdelta_shifted
,intdeltabal
,cum_exit_fee_excl_lv_yield
,accountingclosedate
,CurrentPeriodPIKInterestAccrual
,AccPeriodEnd
,AccPeriodStart
,pmtdtnotadj
,pmtdt
,periodpikint
,DropDateInterestDeltaBalance
,AverageDailyBalance
,DeferredFeeGAAPBasis
,CapitalizedCostLevelYield
,CapitalizedCostGAAPBasis
,CapitalizedCostAccumulatedAmort
,DiscountPremiumLevelYield
,DiscountPremiumGAAPBasis
,DiscountPremiumAccumulatedAmort
,InterestPastDue
,AccountId

 From [DW].[Staging_Cashflow]  N  
  
  