    
CREATE View [dbo].[NotePeriodicCalcByEntity_All_ExpectedMaturityDate]    
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
where AnalysisID in ('D8F8AF6D-B9C7-4015-A610-41D34941EEB5','261CA4F1-A0AF-45C1-8CF6-053DAFAAA835')




--AnalysisName in ('Expected Maturity Date (with Prepay, FWCV)','Expected Maturity Date (with Prepay, Index Flat)')
  
    