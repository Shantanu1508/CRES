    
CREATE View [dbo].[NotePeriodicCalcByEntity_All]    
as    
  
select     
NPC.NoteID as NoteKey,    
CRENoteID as NoteID,    
PeriodEndDate,    
EntityName as Entity,    
[Month],    
ActualCashFlows   ActualCashFlows ,    
GAAPCashFlows   GAAPCashFlows ,    
EndingGAAPBookValue   EndingGAAPBookValue ,    
TotalGAAPIncomeforthePeriod   TotalGAAPIncomeforthePeriod ,    
InterestAccrualforthePeriod   InterestAccrualforthePeriod ,    
PIKInterestAccrualforthePeriod   PIKInterestAccrualforthePeriod ,    
TotalAmortAccrualForPeriod   TotalAmortAccrualForPeriod ,    
AccumulatedAmort   AccumulatedAmort ,    
BeginningBalance   BeginningBalance ,    
TotalFutureAdvancesForThePeriod   TotalFutureAdvancesForThePeriod ,    
TotalDiscretionaryCurtailmentsforthePeriod   TotalDiscretionaryCurtailmentsforthePeriod ,    
InterestPaidOnPaymentDate   InterestPaidOnPaymentDate ,    
TotalCouponStrippedforthePeriod   TotalCouponStrippedforthePeriod ,    
CouponStrippedonPaymentDate   CouponStrippedonPaymentDate ,    
ScheduledPrincipal   ScheduledPrincipal ,    
PrincipalPaid   PrincipalPaid ,    
BalloonPayment   BalloonPayment ,    
EndingBalance   EndingBalance ,    
ExitFeeIncludedInLevelYield   ExitFeeIncludedInLevelYield ,    
ExitFeeExcludedFromLevelYield   ExitFeeExcludedFromLevelYield ,    
AdditionalFeesIncludedInLevelYield   AdditionalFeesIncludedInLevelYield ,    
AdditionalFeesExcludedFromLevelYield   AdditionalFeesExcludedFromLevelYield ,    
OriginationFeeStripping   OriginationFeeStripping ,    
ExitFeeStrippingIncldinLevelYield   ExitFeeStrippingIncldinLevelYield ,    
ExitFeeStrippingExcldfromLevelYield   ExitFeeStrippingExcldfromLevelYield ,    
AddlFeesStrippingIncldinLevelYield   AddlFeesStrippingIncldinLevelYield ,    
AddlFeesStrippingExcldfromLevelYield   AddlFeesStrippingExcldfromLevelYield ,    
EndOfPeriodWAL   EndOfPeriodWAL ,    
PIKInterestFromPIKSourceNote   PIKInterestFromPIKSourceNote ,    
PIKInterestTransferredToRelatedNote   PIKInterestTransferredToRelatedNote ,    
PIKInterestForThePeriod   PIKInterestForThePeriod ,    
BeginningPIKBalanceNotInsideLoanBalance   BeginningPIKBalanceNotInsideLoanBalance ,    
PIKInterestForPeriodNotInsideLoanBalance   PIKInterestForPeriodNotInsideLoanBalance ,    
PIKBalanceBalloonPayment   PIKBalanceBalloonPayment ,    
EndingPIKBalanceNotInsideLoanBalance   EndingPIKBalanceNotInsideLoanBalance ,    
CostBasis   CostBasis ,    
PreCapBasis   PreCapBasis ,    
BasisCap   BasisCap ,    
AmortAccrualLevelYield   AmortAccrualLevelYield ,    
ScheduledPrincipalShortfall   ScheduledPrincipalShortfall ,    
PrincipalShortfall   PrincipalShortfall ,    
PrincipalLoss   PrincipalLoss ,    
InterestForPeriodShortfall   InterestForPeriodShortfall ,    
InterestPaidOnPMTDateShortfall   InterestPaidOnPMTDateShortfall ,    
CumulativeInterestPaidOnPMTDateShortfall   CumulativeInterestPaidOnPMTDateShortfall ,    
InterestShortfallLoss   InterestShortfallLoss ,    
InterestShortfallRecovery   InterestShortfallRecovery ,    
BeginningFinancingBalance   BeginningFinancingBalance ,    
TotalFinancingDrawsCurtailmentsForPeriod   TotalFinancingDrawsCurtailmentsForPeriod ,    
FinancingBalloon   FinancingBalloon ,    
EndingFinancingBalance   EndingFinancingBalance ,    
FinancingInterestPaid   FinancingInterestPaid ,    
FinancingFeesPaid   FinancingFeesPaid ,    
PeriodLeveredYield   PeriodLeveredYield ,    
OrigFeeAccrual    OrigFeeAccrual  ,    
DiscountPremiumAccrual     DiscountPremiumAccrual   ,    
ExitFeeAccrual     ExitFeeAccrual   ,    
AllInCouponRate AS  AllInCouponRate     
, AnalysisID    
,AnalysisName ScenarioName  

,FinancingSource
,ClientName  

,PIKInterestAppliedForThePeriod
,PIKPrincipalPaidForThePeriod

,InterestReceivedinCurrentPeriod
    
From DW.NotePeriodicCalcByEntityBI_ALL NPC   
where AnalysisID in ('C10F3372-0FC2-4861-A9F5-148F1F80804F','45CF083B-4755-4A8C-982A-7DC6D7B8E5F2')
---AnalysisName in ('Default','Fully Extended (FWCV)')
  
    