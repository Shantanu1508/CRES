-- View  
ALTER view [dbo].[NotePeriodicCalc]                
as                 
select                 
N.NoteID as NoteKey,                
N.CRENoteID as NoteID,                
PeriodEndDate,                
[Month],                
ActualCashFlows,                
GAAPCashFlows,                
EndingGAAPBookValue,                
null as TotalGAAPIncomeforthePeriod,                
null as InterestAccrualforthePeriod,                
null as PIKInterestAccrualforthePeriod,                
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
CurrentPeriodInterestAccrualPeriodEnddate as CurrentPeriodInterestAccrualPeriodEnddate,               
             
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
,CurrentPeriodPIKInterestAccrualPeriodEnddate as CurrentPeriodPIKInterestAccrualPeriodEnddate          
      
,MaturitydateBI1 = Case when N.ActualPayoffdate is null then N.FullyExtendedMaturityDate else N.ActualPayoffDate end          
,EomMaturitydateBI = EOMonth( Case when N.ActualPayoffdate is null then N.FullyExtendedMaturityDate else N.ActualPayoffDate end,0)         
,N.PIK_nonPIK          
,N.FinancingSource        
    
,N.PIKInterestPaidForThePeriod    
,N.PIKInterestAppliedForThePeriod      
    
,N.PIKPrincipalPaidForThePeriod    
,N.EndingBalanceBI_RP    
,ISNULL(N.RemainingUnfundedCommitment  ,0) as RemainingUnfundedCommitment  
,CurrentPeriodPIKInterestAccrual

From [DW].[NotePeriodicCalcBI] N            
Where [Month] is not null        
and analysisid in ('C10F3372-0FC2-4861-A9F5-148F1F80804F')          
      
      
      
--===============================================        
GO

ALTER VIEW [dbo].[NotePeriodicCalc_AccountingRecon]  
AS  
SELECT N.NoteID AS NoteKey  
 ,N.CRENoteID AS NoteID  
 ,PeriodEndDate  
 ,[Month]  
 ,ActualCashFlows  
 ,GAAPCashFlows  
 ,EndingGAAPBookValue  
 ,null as TotalGAAPIncomeforthePeriod  
 ,null as InterestAccrualforthePeriod  
 ,null as PIKInterestAccrualforthePeriod  
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
 ,NULL AS ExitFeeIncludedInLevelYield  
 ,NULL AS ExitFeeExcludedFromLevelYield  
 ,NULL AS AdditionalFeesIncludedInLevelYield  
 ,NULL AS AdditionalFeesExcludedFromLevelYield  
 ,NULL AS OriginationFeeStripping  
 ,NULL AS ExitFeeStrippingIncldinLevelYield  
 ,NULL AS ExitFeeStrippingExcldfromLevelYield  
 ,NULL AS AddlFeesStrippingIncldinLevelYield  
 ,NULL AS AddlFeesStrippingExcldfromLevelYield  
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
 ,n.CreatedBy  
 ,n.CreatedDate  
 ,n.UpdatedBy  
 ,n.UpdatedDate  
 ,AllInCouponRate  
 ,[CleanCost]  
 ,[GrossDeferredFees]  
 ,[DeferredFeesReceivable]  
 ,[CleanCostPrice]  
 ,[AmortizedCostPrice]  
 ,[AdditionalFeeAccrual]  
 ,[CapitalizedCostAccrual]  
 ,DailySpreadInterestbeforeStrippingRule  
 ,DailyLiborInterestbeforeStrippingRule  
 ,ReversalofPriorInterestAccrual  
 ,InterestReceivedinCurrentPeriod  
 ,CurrentPeriodInterestAccrual  
 ,TotalGAAPInterestFortheCurrentPeriod  
 ,AccruedInterestBI AS AccruedInterest  
 ,InvestmentBasis  
 ,CurrentPeriodInterestAccrualPeriodEnddate as CurrentPeriodInterestAccrualPeriodEnddate  
 ,NoteID_EODPeriodEndDateBI AS NoteID_PeriodEndDate  
 ,LIBORPercentage  
 ,SpreadPercentage  
 ,AnalysisName AS Scenario  
 ,FeeStrippedforthePeriod  
 ,PIKInterestPercentage  
 ,AmortizedCost  
 ,CREDealID  
 ,DealName  
 ,BSCurrentBalance  
 ,AccumaltedDiscountPremiumBI AS AccumaltedDiscountPremium  
 ,AccumalatedCapitalizedCostBI AS AccumalatedCapitalizedCost  
 ,InterestSuspenseAccountActivityforthePeriod  
 ,InterestSuspenseAccountBalance  
 ,AllInBasisValuation  
 --, NoteID_Date  =   crenoteid+'_'+  (CONVERT (VARCHAR(10),(PeriodEndDate), 110))        
 ,NoteID_Date = n.crenoteid + '_' + (CONVERT(VARCHAR(10), eomonth(PeriodEndDate, 0), 110))  
 ,PeriodendDateBI = CASE   
  WHEN PeriodEndDate = Convert(DATE, (GetDate() - 1))  
   THEN 'Last Close'  
  ELSE Convert(VARCHAR, PeriodendDate)  
  END  
 ,AnalysisID  
 ,AllInPIKRate  
 ,CurrentPeriodPIKInterestAccrualPeriodEnddate as CurrentPeriodPIKInterestAccrualPeriodEnddate  
 ,MaturitydateBI1 = CASE   
  WHEN N.ActualPayoffdate IS NULL  
   THEN N.FullyExtendedMaturityDate  
  ELSE N.ActualPayoffDate  
  END  
 ,EomMaturitydateBI = EOMonth(CASE   
   WHEN N.ActualPayoffdate IS NULL  
    THEN N.FullyExtendedMaturityDate  
   ELSE N.ActualPayoffDate  
   END, 0)  
 ,N.PIK_nonPIK  
 ,N.FinancingSource  
 ,N.PIKInterestPaidForThePeriod  
 ,N.PIKInterestAppliedForThePeriod  
 ,MaturityDateBI = ISNULL(ActualPayoffDate, FullyExtendedMaturityDate)  
 ,n.PIKPrincipalPaidForThePeriod -- Added by Anurag  
 ,(AccumalatedCapitalizedCostBI + AccumaltedDiscountPremiumBI + [CleanCost]  
+[CurrentPeriodInterestAccrual]  
+[CurrentPeriodPIKInterestAccrual]   
+[AccumulatedAmort]    
+ PIKPrincipalPaidForThePeriod  
-[InterestSuspenseAccountBalance]) [GAAP Calculated Value]  

,CurrentPeriodPIKInterestAccrual
FROM [DW].[NotePeriodicCalcBI] N  
--inner join dw.notebi ni on ni.noteid = n.noteid  
WHERE [Month] IS NOT NULL  
 AND analysisid IN ('C10F3372-0FC2-4861-A9F5-148F1F80804F')  
 AND n.Month IS NOT NULL  
 --and CRENoteID = '12394'  
 --===============================================    
--and PeriodEndDate = '2020-12-31'  

go


     
ALTER view [dbo].[NotePeriodicCalc_GAAPTEst]        
as         
select         
N.NoteID as NoteKey,        
N.CRENoteID as NoteID,        
PeriodEndDate,        
[Month],        
ActualCashFlows,        
GAAPCashFlows,        
EndingGAAPBookValue,        
null as TotalGAAPIncomeforthePeriod,        
null as InterestAccrualforthePeriod,        
null as PIKInterestAccrualforthePeriod,        
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
CurrentPeriodInterestAccrualPeriodEnddate as CurrentPeriodInterestAccrualPeriodEnddate,        
n.CRENoteID + '_'+ Convert(Varchar(10),EOMonth(PeriodEndDate,0),110) NoteID_PeriodEndDate,    
n.CRENoteID + '_'+ Convert(Varchar(10),EOMonth(PeriodEndDate,0),110)+'_' + AnalysisName NoteID_PeriodEndDate_Analysis,    
LIBORPercentage,        
SpreadPercentage,        
AnalysisName as Scenario,        
FeeStrippedforthePeriod,        
PIKInterestPercentage,        
AmortizedCost,        
CREDealID,        
DealName,        
BSCurrentBalance        
    
    
--,SUM(ISNULL(N.DiscountPremiumAccrual,0)) OVER(PARTITION BY AnalysisID,N.NoteID ORDER BY AnalysisID,N.NoteID,PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumaltedDiscountPremiumBI    
--,SUM(ISNULL(N.CapitalizedCostAccrual,0)) OVER(PARTITION BY AnalysisID,N.NoteID ORDER BY AnalysisID,N.NoteID,PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumalatedCapitalizedCostBI    
    
,AccumaltedDiscountPremiumBI AS AccumaltedDiscountPremium    
,AccumalatedCapitalizedCostBI AS AccumalatedCapitalizedCost    
    
,InterestSuspenseAccountActivityforthePeriod,        
InterestSuspenseAccountBalance,        
AllInBasisValuation        
--, n.crenoteid+'_'+CONVERT (VARCHAR(10),PeriodEndDate, 110) NoteID_Date      
,AnalysisID     
,Maturity_DateBI    
, NT.Discount    
, NT.CapitalizedClosingCosts    
, NoteID_EODPeriodEndDateBI    
--, Case WHEN FeeNoteid is Not NULL THEN 'Negative Additional Fee' Else 'Without Negative Addtional Fee' End as wIth_Without_NegativeFee    
, N.Pik_NonPIK    
, Client    
From [DW].[NotePeriodicCalcBI] N       
    
 Left Join Note NT on NT.Notekey = N.NoteID    
 --Outer apply (Select Distinct NoteID FeeNoteid from FeeSchedule F    
 --   Where N.NoteID = F.NoteKey    
 --   and (FeeType = 'Origination Fee'  and FeeAmountOverride < 0 and IncludedLevelYield <> 0)    
 --   Or  (FeeType = 'Origination Fee' and Value < 0 and BaseAmountOverride <> 0)    
 --   )X    
    
   Where EOMONTH (N.FullyExtendedMaturityDate) > EOMONTH (PeriodEndDate,0)    
   and EOMONTH(N.PeriodEndDate,0) = PeriodEndDate    
    and AnalysisName = 'Default'    
 and dealNAme not in ('[Deal abc]')    
    
 and CRENoteID not in    
    
 (Select Distinct F.NoteID FeeNoteid from FeeSchedule F    
    inner join note n on F.NoteId = N.NoteID    
    WHere   (FeeType = 'Origination Fee'  and isnull(FeeAmountOverride,0) < 0     
      and isnull(IncludedLevelYield,0) <> 0)    
    Or  (FeeType = 'Origination Fee' and ISNULL(Value,0) < 0 and  isnull(IncludedLevelYield,0) <> 0 )    
        
        
        
    )    
    
and CRENoteID not in     
   (     
 Select Distinct F.NoteID FeeNoteid from FeeSchedule F    
    inner join note n on F.NoteId = N.NoteID    
    WHere   (FeeType = 'Origination Fee'  and isnull(FeeAmountOverride,0) > 0     
      and isnull(IncludedLevelYield,0) <> 0    
      and (FeeName Like 'Additional%' or FeeName = 'Origination Fee #2 ') )    
    Or  (FeeType = 'Origination Fee' and ISNULL(Value,0) > 0 and  isnull(IncludedLevelYield,0) <> 0     
      and (FeeName Like 'Additional%' or FeeName = 'Origination Fee #2 ')    
          
     )    
)    
  
  


  go



    
      
ALTER view [dbo].[NotePeriodicCalc_GAAPTEst_NegativeAddtionalfee]        
as         
select         
N.NoteID as NoteKey,        
N.CRENoteID as NoteID,        
PeriodEndDate,        
[Month],        
ActualCashFlows,        
GAAPCashFlows,        
EndingGAAPBookValue,        
null as TotalGAAPIncomeforthePeriod,        
null as InterestAccrualforthePeriod,        
null as PIKInterestAccrualforthePeriod,        
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
CurrentPeriodInterestAccrualPeriodEnddate as CurrentPeriodInterestAccrualPeriodEnddate,        
n.CRENoteID + '_'+ Convert(Varchar(10),EOMonth(PeriodEndDate,0),110) NoteID_PeriodEndDate,    
n.CRENoteID + '_'+ Convert(Varchar(10),EOMonth(PeriodEndDate,0),110)+'_' + AnalysisName NoteID_PeriodEndDate_Analysis,    
LIBORPercentage,        
SpreadPercentage,        
AnalysisName as Scenario,        
FeeStrippedforthePeriod,        
PIKInterestPercentage,        
AmortizedCost,        
CREDealID,        
DealName,        
BSCurrentBalance        
    
    
--,SUM(ISNULL(N.DiscountPremiumAccrual,0)) OVER(PARTITION BY AnalysisID,N.NoteID ORDER BY AnalysisID,N.NoteID,PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumaltedDiscountPremiumBI    
--,SUM(ISNULL(N.CapitalizedCostAccrual,0)) OVER(PARTITION BY AnalysisID,N.NoteID ORDER BY AnalysisID,N.NoteID,PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumalatedCapitalizedCostBI    
    
,AccumaltedDiscountPremiumBI AS AccumaltedDiscountPremium    
,AccumalatedCapitalizedCostBI AS AccumalatedCapitalizedCost    
    
,InterestSuspenseAccountActivityforthePeriod,        
InterestSuspenseAccountBalance,        
AllInBasisValuation    
--, n.crenoteid+'_'+CONVERT (VARCHAR(10),PeriodEndDate, 110) NoteID_Date      
,AnalysisID     
,Maturity_DateBI    
, NT.Discount    
, NT.CapitalizedClosingCosts    
, NoteID_EODPeriodEndDateBI    
--, Case WHEN FeeNoteid is Not NULL THEN 'Negative Additional Fee' Else 'Without Negative Addtional Fee' End as wIth_Without_NegativeFee    
, N.Pik_NonPIK    
, Client    
From [DW].[NotePeriodicCalcBI] N       
    
 Left Join Note NT on NT.Notekey = N.NoteID    
 --Outer apply (Select Distinct NoteID FeeNoteid from FeeSchedule F    
 --   Where N.NoteID = F.NoteKey    
 --   and (FeeType = 'Origination Fee'  and FeeAmountOverride < 0 and IncludedLevelYield <> 0)    
 --   Or  (FeeType = 'Origination Fee' and Value < 0 and BaseAmountOverride <> 0)    
 --   )X    
    
   Where EOMONTH (N.FullyExtendedMaturityDate) > EOMONTH (PeriodEndDate,0)    
   and EOMONTH(N.PeriodEndDate,0) = PeriodEndDate    
    and AnalysisName = 'Default'    
 and dealNAme not in ('[Deal abc]')    
    
 and CRENoteID in     
    
 (Select Distinct F.NoteID FeeNoteid from FeeSchedule F    
    inner join note n on F.NoteId = N.NoteID    
    WHere   (FeeType = 'Origination Fee'  and isnull(FeeAmountOverride,0) < 0     
      and isnull(IncludedLevelYield,0) <> 0)    
    Or  (FeeType = 'Origination Fee' and ISNULL(Value,0) < 0 and isnull(IncludedLevelYield,0) <> 0 )    
    and Maturity_DateBI > GETDATE()    
    
    
 )    
  
  go

     
ALTER view [dbo].[NotePeriodicCalc_GAAPTEst_PostiveAddtionalFees]        
as         
select         
N.NoteID as NoteKey,        
N.CRENoteID as NoteID,        
PeriodEndDate,        
[Month],        
ActualCashFlows,        
GAAPCashFlows,        
EndingGAAPBookValue,        
null as TotalGAAPIncomeforthePeriod,        
null as InterestAccrualforthePeriod,        
null as PIKInterestAccrualforthePeriod,        
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
CurrentPeriodInterestAccrualPeriodEnddate as CurrentPeriodInterestAccrualPeriodEnddate,        
n.CRENoteID + '_'+ Convert(Varchar(10),EOMonth(PeriodEndDate,0),110) NoteID_PeriodEndDate,    
n.CRENoteID + '_'+ Convert(Varchar(10),EOMonth(PeriodEndDate,0),110)+'_' + AnalysisName NoteID_PeriodEndDate_Analysis,    
LIBORPercentage,        
SpreadPercentage,        
AnalysisName as Scenario,        
FeeStrippedforthePeriod,        
PIKInterestPercentage,        
AmortizedCost,        
CREDealID,        
DealName,        
BSCurrentBalance        
    
    
--,SUM(ISNULL(N.DiscountPremiumAccrual,0)) OVER(PARTITION BY AnalysisID,N.NoteID ORDER BY AnalysisID,N.NoteID,PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumaltedDiscountPremiumBI    
--,SUM(ISNULL(N.CapitalizedCostAccrual,0)) OVER(PARTITION BY AnalysisID,N.NoteID ORDER BY AnalysisID,N.NoteID,PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumalatedCapitalizedCostBI    
    
,AccumaltedDiscountPremiumBI AS AccumaltedDiscountPremium    
,AccumalatedCapitalizedCostBI AS AccumalatedCapitalizedCost    
    
,InterestSuspenseAccountActivityforthePeriod,        
InterestSuspenseAccountBalance,        
AllInBasisValuation        
--, n.crenoteid+'_'+CONVERT (VARCHAR(10),PeriodEndDate, 110) NoteID_Date      
,AnalysisID     
,Maturity_DateBI    
, NT.Discount    
, NT.CapitalizedClosingCosts    
, NoteID_EODPeriodEndDateBI    
--, Case WHEN FeeNoteid is Not NULL THEN 'Negative Additional Fee' Else 'Without Negative Addtional Fee' End as wIth_Without_NegativeFee    
, N.Pik_NonPIK    
, Client    
From [DW].[NotePeriodicCalcBI] N       
    
 Left Join Note NT on NT.Notekey = N.NoteID    
 --Outer apply (Select Distinct NoteID FeeNoteid from FeeSchedule F    
 --   Where N.NoteID = F.NoteKey    
 --   and (FeeType = 'Origination Fee'  and FeeAmountOverride < 0 and IncludedLevelYield <> 0)    
 --   Or  (FeeType = 'Origination Fee' and Value < 0 and BaseAmountOverride <> 0)    
 --   )X    
    
   Where EOMONTH (N.FullyExtendedMaturityDate) > EOMONTH (PeriodEndDate,0)    
   and EOMONTH(N.PeriodEndDate,0) = PeriodEndDate    
    and AnalysisName = 'Default'    
 and dealNAme not in ('[Deal abc]')    
    
 --and CRENoteID not in    
    
 --(Select Distinct F.NoteID FeeNoteid from FeeSchedule F    
 --   inner join note n on F.NoteId = N.NoteID    
 --   WHere   (FeeType = 'Origination Fee'  and isnull(FeeAmountOverride,0) < 0     
 --     and isnull(IncludedLevelYield,0) <> 0)    
 --   Or  (FeeType = 'Origination Fee' and ISNULL(Value,0) < 0 and  isnull(IncludedLevelYield,0) <> 0 )    
        
        
        
 --   )    
    
and CRENoteID  in     
   (     
 Select Distinct F.NoteID FeeNoteid from FeeSchedule F    
    inner join note n on F.NoteId = N.NoteID    
    WHere   (FeeType = 'Origination Fee'  and isnull(FeeAmountOverride,0) > 0     
      and isnull(IncludedLevelYield,0) <> 0    
      and (FeeName Like 'Additional%' or FeeName = 'Origination Fee #2 ') )    
    Or  (FeeType = 'Origination Fee' and ISNULL(Value,0) > 0 and  isnull(IncludedLevelYield,0) <> 0     
      and (FeeName Like 'Additional%' or FeeName = 'Origination Fee #2 ')    
          
     )    
)    
  
  

  go



    
ALTER view [dbo].[NotePeriodicCalc_PipeLineRecon]                
as                 
select                 
N.NoteID as NoteKey,                
N.CRENoteID as NoteID,                
PeriodEndDate,                
[Month],                
ActualCashFlows,                
GAAPCashFlows,                
EndingGAAPBookValue,                
null as TotalGAAPIncomeforthePeriod,                
null as InterestAccrualforthePeriod,                
null as PIKInterestAccrualforthePeriod,                
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
CurrentPeriodInterestAccrualPeriodEnddate as CurrentPeriodInterestAccrualPeriodEnddate,               
             
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
,CurrentPeriodPIKInterestAccrualPeriodEnddate as CurrentPeriodPIKInterestAccrualPeriodEnddate          
      
,MaturitydateBI1 = Case when N.ActualPayoffdate is null then N.FullyExtendedMaturityDate else N.ActualPayoffDate end          
,EomMaturitydateBI = EOMonth( Case when N.ActualPayoffdate is null then N.FullyExtendedMaturityDate else N.ActualPayoffDate end,0)         
,N.PIK_nonPIK          
,N.FinancingSource        
    
,N.PIKInterestPaidForThePeriod    
,N.PIKInterestAppliedForThePeriod      
,N.CurrentPeriodPIKInterestAccrual

From [DW].[NotePeriodicCalcBI] N            
Where    analysisid in ('C10F3372-0FC2-4861-A9F5-148F1F80804F')          
      
      
      
--=============================================== 
