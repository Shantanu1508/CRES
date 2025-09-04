CREATE VIEW [dbo].[NotePeriodicCalc_AccountingRecon]          
AS          
SELECT N.NoteID AS NoteKey          
 ,N.CRENoteID AS NoteID          
 ,PeriodEndDate          
 ,[Month]          
 ,ActualCashFlows          
 --,GAAPCashFlows          
 ,EndingGAAPBookValue          
 --,null as TotalGAAPIncomeforthePeriod          
 --,null as InterestAccrualforthePeriod          
 --,null as PIKInterestAccrualforthePeriod          
 ,TotalAmortAccrualForPeriod          
 ,AccumulatedAmort          
 ,BeginningBalance          
 ,TotalFutureAdvancesForThePeriod          
 ,TotalDiscretionaryCurtailmentsforthePeriod          
 --,InterestPaidOnPaymentDate          
 --,TotalCouponStrippedforthePeriod          
 --,CouponStrippedonPaymentDate          
 --,ScheduledPrincipal          
 ,PrincipalPaid          
 ,BalloonPayment          
 ,EndingBalance          
 --,NULL AS ExitFeeIncludedInLevelYield          
 --,NULL AS ExitFeeExcludedFromLevelYield          
 --,NULL AS AdditionalFeesIncludedInLevelYield          
 --,NULL AS AdditionalFeesExcludedFromLevelYield          
 --,NULL AS OriginationFeeStripping          
 --,NULL AS ExitFeeStrippingIncldinLevelYield          
 --,NULL AS ExitFeeStrippingExcldfromLevelYield          
 --,NULL AS AddlFeesStrippingIncldinLevelYield          
 --,NULL AS AddlFeesStrippingExcldfromLevelYield          
 --,EndOfPeriodWAL          
 --,PIKInterestFromPIKSourceNote          
 --,PIKInterestTransferredToRelatedNote          
 --,PIKInterestForThePeriod          
 --,BeginningPIKBalanceNotInsideLoanBalance          
 ,PIKInterestForPeriodNotInsideLoanBalance  as       SeparatelyCompoundedPIKInterest      
 --,PIKBalanceBalloonPayment          
 --,EndingPIKBalanceNotInsideLoanBalance          
 ,NetPIKAmountForThePeriod      
 --,CostBasis          
 --,PreCapBasis          
 --,BasisCap          
 --,AmortAccrualLevelYield          
 --,ScheduledPrincipalShortfall          
 --,PrincipalShortfall          
 --,PrincipalLoss          
 --,InterestForPeriodShortfall          
 --,InterestPaidOnPMTDateShortfall          
 --,CumulativeInterestPaidOnPMTDateShortfall          
 --,InterestShortfallLoss          
 --,InterestShortfallRecovery          
 --,BeginningFinancingBalance          
 --,TotalFinancingDrawsCurtailmentsForPeriod          
 --,FinancingBalloon          
 --,EndingFinancingBalance          
 --,FinancingInterestPaid          
 --,FinancingFeesPaid          
 --,PeriodLeveredYield          
 --,OrigFeeAccrual          
 ,DiscountPremiumAccrual          
 --,ExitFeeAccrual          
 --,n.CreatedBy          
 --,n.CreatedDate          
 --,n.UpdatedBy          
 --,n.UpdatedDate          
 --,AllInCouponRate          
 ,[CleanCost]          
 ,[GrossDeferredFees]          
 --,[DeferredFeesReceivable]          
 --,[CleanCostPrice]          
 --,[AmortizedCostPrice]          
 --,[AdditionalFeeAccrual]          
 ,[CapitalizedCostAccrual]          
 --,DailySpreadInterestbeforeStrippingRule          
 --,DailyLiborInterestbeforeStrippingRule          
 ,ReversalofPriorInterestAccrual          
 ,InterestReceivedinCurrentPeriod          
 ,CurrentPeriodInterestAccrual          
 ,TotalGAAPInterestFortheCurrentPeriod          
 --,AccruedInterestBI AS AccruedInterest          
 --,InvestmentBasis          
 --,CurrentPeriodInterestAccrualPeriodEnddate as CurrentPeriodInterestAccrualPeriodEnddate          
 --,NoteID_EODPeriodEndDateBI AS NoteID_PeriodEndDate          
 --,LIBORPercentage          
 --,SpreadPercentage          
 --,AnalysisName AS Scenario          
 --,FeeStrippedforthePeriod          
 --,PIKInterestPercentage          
 ,AmortizedCost          
 ,N.CREDealID          
 ,N.DealName          
 --,BSCurrentBalance     
   
 --,AccumaltedDiscountPremiumBI AS AccumaltedDiscountPremium          
 --,AccumalatedCapitalizedCostBI AS AccumalatedCapitalizedCost    
   
  ,[DiscountPremiumAccumulatedAmort] AS AccumaltedDiscountPremium          
 ,[CapitalizedCostAccumulatedAmort] AS AccumalatedCapitalizedCost  
  
 --,InterestSuspenseAccountActivityforthePeriod          
 ,InterestSuspenseAccountBalance          
 ,AllInBasisValuation          
 --, NoteID_Date  =   crenoteid+'_'+  (CONVERT (VARCHAR(10),(PeriodEndDate), 110))                
 ,NoteID_Date = n.crenoteid + '_' + (CONVERT(VARCHAR(10), eomonth(PeriodEndDate, 0), 110))          
 --,PeriodendDateBI = CASE           
 -- WHEN PeriodEndDate = Convert(DATE, (GetDate() - 1))          
 --  THEN 'Last Close'          
 -- ELSE Convert(VARCHAR, PeriodendDate)          
 -- END          
 ,N.AnalysisID          
 --,AllInPIKRate          
 --,CurrentPeriodPIKInterestAccrualPeriodEnddate as CurrentPeriodPIKInterestAccrualPeriodEnddate          
 ,MaturitydateBI1 = CASE           
  WHEN N.ActualPayoffdate IS NULL          
   THEN N.FullyExtendedMaturityDate          
  ELSE N.ActualPayoffDate          
  END          
 --,EomMaturitydateBI = EOMonth(CASE           
 --  WHEN N.ActualPayoffdate IS NULL          
 --   THEN N.FullyExtendedMaturityDate          
 --  ELSE N.ActualPayoffDate          
 --  END, 0)          
-- ,N.PIK_nonPIK          
,N.FinancingSource          
-- ,N.PIKInterestPaidForThePeriod          
 ,N.PIKInterestAppliedForThePeriod          
,MaturityDateBI = ISNULL(ni.ActualPayoffDate, ni.FullyExtendedMaturityDate)          
,n.PIKPrincipalPaidForThePeriod       
-- ,(AccumalatedCapitalizedCostBI + AccumaltedDiscountPremiumBI + [CleanCost]          
--+[CurrentPeriodInterestAccrual]          
--+[CurrentPeriodPIKInterestAccrual]           
--+[AccumulatedAmort]            
--+ PIKPrincipalPaidForThePeriod          
---[InterestSuspenseAccountBalance]) [GAAP Calculated Value]            
,CurrentPeriodPIKInterestAccrual        
-- ,CapitalizedCostAccumulatedAmort        
 --,DiscountPremiumAccumulatedAmort        
,[PrincipalWriteoff]      
,d.[DealStatusBI]      
,ni.CapitalizedClosingCosts      
,Discount      
,ISNULL(ni.ActualPayoffDate,ni.FullyExtendedMaturityDate) as MaturityBi,      
CASE      
WHEN ISNULL(ni.ActualPayoffDate,ni.FullyExtendedMaturityDate)<=[periodenddate] then 0 else ni.CapitalizedClosingCosts end AS CapitalizedClosingCostsBi,      
CASE      
WHEN ISNULL(ni.ActualPayoffDate,ni.FullyExtendedMaturityDate)<=[periodenddate] then 0 else ni.Discount end AS DiscountBi    


,cr. CalcEnginetype 
,l.name as EnableM61Calculations
,CashInterest
,CapitalizedInterest
,(select [Value]+'#/dealdetail/'+N.CREDealID from app.appconfig where [key]='M61BaseUrl')  as DealUrl
FROM [DW].[NotePeriodicCalcBI] N          
INNER JOIN cre.note ni on ni.noteid = n.noteid          
INNER JOIN DW.DealBI d ON d.dealid=ni.DealID   
Left join core.lookup l on l.lookupid = ni.EnableM61Calculations
left join(  
    select analysisid,accountid ,l.name as CalcEnginetype  
    from core.CalculationRequests c  
    left join core.lookup l on l.lookupid = c.calcenginetype  
    where analysisid in ( 'c10f3372-0fc2-4861-a9f5-148f1f80804f')    
)cr on cr.analysisid = N.analysisid and cr.accountid = N.accountid  

WHERE [Month] IS NOT NULL          
 AND N.analysisid IN ('C10F3372-0FC2-4861-A9F5-148F1F80804F')          
 AND n.Month IS NOT NULL          
 --and N.CRENoteID = '12394'          
 --===============================================            
--and PeriodEndDate = '2023-12-31' 


GO


