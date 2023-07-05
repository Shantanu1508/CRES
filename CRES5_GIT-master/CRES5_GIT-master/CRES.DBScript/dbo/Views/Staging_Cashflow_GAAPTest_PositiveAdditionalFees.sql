CREATE view [dbo].[Staging_Cashflow_GAAPTest_PositiveAdditionalFees]
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
N.CreatedBy,  
N.CreatedDate,  
N.UpdatedBy,  
N.UpdatedDate,  
N.AllInCouponRate,  
  
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
,crenoteid+'_'+CONVERT (VARCHAR(10),EOMONTH (PeriodEndDate,0), 110) NoteID_Date  
,n.CRENoteID + '_'+ Convert(Varchar(10),EOMonth(PeriodEndDate,0),110)+'_' + A.Name NoteID_PeriodEndDate_Analysis
,AnalysisID

,AccumaltedDiscountPremiumBI AS AccumaltedDiscountPremium
,AccumalatedCapitalizedCostBI AS AccumalatedCapitalizedCost
	
,[CurrentPeriodInterestAccrualPeriodEnddate]
,Maturity_DateBI
, NT.Discount
, NT.CapitalizedClosingCosts
, NoteID_EODPeriodEndDateBI
 From [DW].[Staging_Cashflow]  N
  Left Join Note NT on NT.Notekey = N.NoteID
   Left Join Dw.AnalysisBI A on A.AnalysisKey = N.AnalysisID
   Where EOMONTH (FullyExtendedMaturityDate) > EOMONTH (PeriodEndDate,0)
   and EOMONTH (N.PeriodEndDate,0) = N.PeriodEndDate
   and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
   ----- Negative additional Fee
   --and CRENoteID not in
   --(Select Distinct F.NoteID FeeNoteid from FeeSchedule F
			--	inner join note n on F.NoteId = N.NoteID
			--	WHere 	 (FeeType = 'Origination Fee'  and isnull(FeeAmountOverride,0) < 0 
			--			and isnull(IncludedLevelYield,0) <> 0)
			--	Or  (FeeType = 'Origination Fee' and ISNULL(Value,0) < 0 and isnull(IncludedLevelYield,0) <> 0 )
			--	)

----Postive additional Fee
and CRENoteID  in

(
	Select Distinct F.NoteID FeeNoteid from FeeSchedule F
				inner join note n on F.NoteId = N.NoteID
				WHere 	 (FeeType = 'Origination Fee'  and isnull(FeeAmountOverride,0) > 0 
						and isnull(IncludedLevelYield,0) <> 0
						and (FeeName Like 'Additional%' or FeeName = 'Origination Fee #2 ') )
				Or  (FeeType = 'Origination Fee' and ISNULL(Value,0) > 0 and  isnull(IncludedLevelYield,0) <> 0 
						and (FeeName Like 'Additional%' or FeeName = 'Origination Fee #2 ')
						
					)



)
			
