-- View  
CREATE VIEW [dbo].[NotePeriodicCalc_AccountingRecon]  
AS  
SELECT N.NoteID AS NoteKey  
 ,N.CRENoteID AS NoteID  
 ,PeriodEndDate  
 ,[Month]  
 ,ActualCashFlows  
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
 ,CurrentPeriodInterestAccrualPeriodEnddate  
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
 ,CurrentPeriodPIKInterestAccrualPeriodEnddate  
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
+[CurrentPeriodInterestAccrualPeriodEnddate]  
+[CurrentPeriodPIKInterestAccrualPeriodEnddate]   
+[AccumulatedAmort]    
+ PIKPrincipalPaidForThePeriod  
-[InterestSuspenseAccountBalance]) [GAAP Calculated Value]  
FROM [DW].[NotePeriodicCalcBI] N  
--inner join dw.notebi ni on ni.noteid = n.noteid  
WHERE [Month] IS NOT NULL  
 AND analysisid IN ('C10F3372-0FC2-4861-A9F5-148F1F80804F')  
 AND n.Month IS NOT NULL  
 --and CRENoteID = '12394'  
 --===============================================    
--and PeriodEndDate = '2020-12-31'  