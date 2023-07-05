  
CREATE view [dbo].[NotePeriodicCalc_PipeLineRecon]              
as               
select               
N.NoteID as NoteKey,              
N.CRENoteID as NoteID,              
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
              
null as ExitFeeIncludedInLevelYield,              
null as ExitFeeExcludedFromLevelYield,              
null as AdditionalFeesIncludedInLevelYield,              
null as AdditionalFeesExcludedFromLevelYield,              
null as OriginationFeeStripping,              
null as ExitFeeStrippingIncldinLevelYield,              
null as ExitFeeStrippingExcldfromLevelYield,              
null as AddlFeesStrippingIncldinLevelYield,              
null as AddlFeesStrippingExcldfromLevelYield,              
              
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
n.CreatedBy,              
n.CreatedDate,              
n.UpdatedBy,              
n.UpdatedDate,              
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
AccruedInterestBI as AccruedInterest,              
InvestmentBasis,              
CurrentPeriodInterestAccrualPeriodEnddate,             
           
NoteID_EODPeriodEndDateBI as NoteID_PeriodEndDate,            
            
LIBORPercentage,              
SpreadPercentage,              
AnalysisName as Scenario,              
FeeStrippedforthePeriod,              
PIKInterestPercentage,              
AmortizedCost,              
CREDealID,              
DealName,              
BSCurrentBalance              
          
,AccumaltedDiscountPremiumBI AS AccumaltedDiscountPremium          
,AccumalatedCapitalizedCostBI AS AccumalatedCapitalizedCost          
          
,InterestSuspenseAccountActivityforthePeriod,              
InterestSuspenseAccountBalance,              AllInBasisValuation           
--, NoteID_Date  =   crenoteid+'_'+  (CONVERT (VARCHAR(10),(PeriodEndDate), 110))        
, NoteID_Date  =   crenoteid+'_'+  (CONVERT (VARCHAR(10),eomonth(PeriodEndDate,0), 110))        
        
 ,PeriodendDateBI = Case WHEN  PeriodEndDate = Convert(Date,(GetDate()-1)) THEN 'Last Close'             
     Else Convert (varchar,PeriodendDate) End            
        
        
,AnalysisID          
,AllInPIKRate        
,CurrentPeriodPIKInterestAccrualPeriodEnddate        
    
,MaturitydateBI1 = Case when N.ActualPayoffdate is null then N.FullyExtendedMaturityDate else N.ActualPayoffDate end        
,EomMaturitydateBI = EOMonth( Case when N.ActualPayoffdate is null then N.FullyExtendedMaturityDate else N.ActualPayoffDate end,0)       
,N.PIK_nonPIK        
,N.FinancingSource      
  
,N.PIKInterestPaidForThePeriod  
,N.PIKInterestAppliedForThePeriod    
    
From [DW].[NotePeriodicCalcBI] N          
Where    analysisid in ('C10F3372-0FC2-4861-A9F5-148F1F80804F')        
    
    
    
--===============================================    