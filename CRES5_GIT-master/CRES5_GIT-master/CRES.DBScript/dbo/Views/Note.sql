
  
-- View  
    
  
CREATE VIEW [dbo].[Note] AS    
SELECT     
n.noteid as Notekey,    
n.[CRENoteID] as NoteID,    
n.[ClientNoteID],    
n.[Comments],    
n.[InitialInterestAccrualEndDate],    
n.[AccrualFrequency],    
n.[DeterminationDateLeadDays],    
n.[DeterminationDateReferenceDayoftheMonth],    
n.[DeterminationDateInterestAccrualPeriod],    
n.[DeterminationDateHolidayList],    
n.[FirstPaymentDate],    
n.[InitialMonthEndPMTDateBiWeekly],    
n.[PaymentDateBusinessDayLag],    
n.[IOTerm],    
n.[AmortTerm],    
n.[PIKSeparateCompounding],    
n.[MonthlyDSOverridewhenAmortizing],    
n.[AccrualPeriodPaymentDayWhenNotEOMonth],    
n.[FirstPeriodInterestPaymentOverride],    
n.[FirstPeriodPrincipalPaymentOverride],    
n.[FinalInterestAccrualEndDateOverride],    
n.[AmortType],    
n.[RateType],    
n.[ReAmortizeMonthly],    
n.[ReAmortizeatPMTReset],    
n.[StubPaidInArrears],    
n.[RelativePaymentMonth],    
n.[SettleWithAccrualFlag],    
n.[InterestDueAtMaturity],    
n.[RateIndexResetFreq],    
n.[FirstRateIndexResetDate],    
n.[LoanPurchase],    
n.[AmortIntCalcDayCount],    
n.[StubPaidinAdvanceYN],    
n.[FullPeriodInterestDueatMaturity],    
n.[ProspectiveAccountingMode],    
n.[IsCapitalized],    
n.[SelectedMaturityDateScenario],    
n.[SelectedMaturityDate],    
n.[InitialMaturityDate],    
n.[ExpectedMaturityDate],    
n.[OpenPrepaymentDate],    
n.[CashflowEngineID],    
n.[LoanType],    
n.[Classification],    
n.[SubClassification],    
n.[GAAPDesignation],    
n.[PortfolioID],    
n.[GeographicLocation],    
n.[PropertyType],    
n.[RatingAgency],    
n.[RiskRating],    
n.[PurchasePrice],    
n.[FutureFeesUsedforLevelYeild],    
n.[TotalToBeAmortized],    
n.[StubPeriodInterest],    
n.[WDPAssetMultiple],    
n.[WDPEquityMultiple],    
n.[PurchaseBalance],    
n.[DaysofAccrued],    
n.[InterestRate],    
n.[PurchasedInterestCalc],    
n.[ModelFinancingDrawsForFutureFundings],    
n.[NumberOfBusinessDaysLagForFinancingDraw],    
n.[FinancingFacilityID],    
n.[FinancingInitialMaturityDate],    
n.[FinancingExtendedMaturityDate],    
n.[FinancingPayFrequency],    
n.[FinancingInterestPaymentDay],    
n.[ClosingDate],    
n.[InitialFundingAmount],    
n.[Discount],    
n.[OriginationFee],    
n.[CapitalizedClosingCosts],    
n.[PurchaseDate],    
n.[PurchaseAccruedFromDate],    
n.[PurchasedInterestOverride],    
n.[DiscountRate],    
n.[ValuationDate],    
n.[FairValue],    
n.[DiscountRatePlus],    
n.[FairValuePlus],    
n.[DiscountRateMinus],    
n.[FairValueMinus],    
n.[InitialIndexValueOverride],    
n.[IncludeServicingPaymentOverrideinLevelYield],    
n.[OngoingAnnualizedServicingFee],    
n.[IndexRoundingRule],    
n.[RoundingMethod],    
n.[StubInterestPaidonFutureAdvances],    
n.[TaxAmortCheck],    
n.[PIKWoCompCheck],    
n.[GAAPAmortCheck],    
n.[StubIntOverride],    
n.[PurchasedIntOverride],    
n.[ExitFeeFreePrepayAmt],    
n.[ExitFeeBaseAmountOverride],    
n.[ExitFeeAmortCheck],    
n.[FixedAmortScheduleCheck],    
n.[GeneratedBy],    
n.[UseRuletoDetermineNoteFunding],    
n.[NoteFundingRule],    
n.[FundingPriority],    
n.[NoteBalanceCap],    
n.[RepaymentPriority],    
n.[NoofdaysrelPaymentDaterollnextpaymentcycle],    
n.[UseIndexOverrides],    
n.[IndexNameID],    
n.[ServicerID],    
n.[TotalCommitment],    
n.[DeterminationDateHolidayListBI],    
n.[RateTypeBI],    
n.[ReAmortizeMonthlyBI],    
n.[ReAmortizeatPMTResetBI],    
n.[StubPaidInArrearsBI],    
n.[RelativePaymentMonthBI],    
n.[SettleWithAccrualFlagBI],    
n.[InterestDueAtMaturityBI],    
n.[LoanPurchaseBI],    
n.[StubPaidinAdvanceYNBI],    
n.[ProspectiveAccountingModeBI],    
n.[IsCapitalizedBI],    
n.[ClassificationBI],    
n.[SubClassificationBI],    
n.[GAAPDesignationBI],    
n.[GeographicLocationBI],    
n.[PropertyTypeBI],    
n.[RatingAgencyBI],    
n.[RiskRatingBI],    
n.[ModelFinancingDrawsForFutureFundingsBI],    
n.[NumberOfBusinessDaysLagForFinancingDrawBI],    
n.[FinancingFacilityBI],    
n.[FinancingPayFrequencyBI],    
n.[IncludeServicingPaymentOverrideinLevelYieldBI],    
n.[RoundingMethodBI],    
n.[StubInterestPaidonFutureAdvancesBI],    
n.[ExitFeeAmortCheckBI],    
n.[FixedAmortScheduleCheckBI],    
n.[IndexNameBI],    
n.[StatusID],    
n.[StatusBI],    
n.[Name],    
n.[BaseCurrencyID],    
n.[BaseCurrencyBI],    
n.[PayFrequency],    
n.[ImportBIDate],    
n.[CreatedBy],    
n.[CreatedDate],    
n.[UpdatedBy],    
n.[UpdatedDate],    
n.Dealid as DealKey,    
n.ClientName ,    
n.Portfolio ,    
n.Tag1 ,    
n.Tag2 ,    
n.Tag3 ,    
n.Tag4,    
n.lienposition,    
n.lienpositionBI,    
n.priority,    
    
ExtendedMaturityScenario1,    
ExtendedMaturityScenario2,     
ExtendedMaturityScenario3,     
ActualPayoffDate,    
FullyExtendedMaturityDate,    
TotalCommitmentExtensionFeeisBasedOn,    
LienPriority,    
UnusedFeeThresholdBalance,    
UnusedFeePaymentFrequency,    
ServicerBI as Servicer,    
FullInterestAtPPayoff,    
Maturity_DateBI =  (Case WHEN  ActualPayoffDate is not null and ActualPayoffDate< getdate() THEn ActualPayoffDate    
      When ActualPayoffDate is not null and ActualPayoffDate>= Getdate() THEN ActualPayoffDate    
      WHEN ActualPayoffDate is NULL Then (Case when ExtendedMaturityScenario1 >= Getdate()  THEN  ExtendedMaturityScenario1    
                WHen ExtendedMaturityScenario2  >= Getdate()  THEN  ExtendedMaturityScenario2    
                WHen ExtendedMaturityScenario3  >= Getdate()  THEN  ExtendedMaturityScenario3    
                Else FullyExtendedMaturityDate End)    
      end),    
    
    
ClientBI as Client,    
FinancingSourceBI as FinancingSource,    
DebtTypeBI as DebtType,    
BillingNotesBI as BillingNotes,    
CapStackBI as CapStack,    
    
FundBI as FundName ,    

PoolBI as [Pool],    
  
Pik_NonPIK,  
HasFundingRepayment,  
FullAccrualHasRepayment,  
HasAmortTerm_Or_FixedAmort,  
  
HasAmortTerm,  
HasOnlyRepayment,  
HasFixedAmort,  
  
--HasAmortTerm = Case when crenoteid in  (Select Distinct CRENoteID from Cre.Note  
--              where ISNULL(AmortTerm,0) <> 0 ) Then 'Yes' else 'No' End,  
--HasOnlyRepayment = Case when CRENoteID in (Select Distinct CRENoteID from DW.NoteFundingScheduleBI  
--           Where PurposeBI <> 'AMortization' and Amount < 0) Then 'Yes' else 'No' end,  
--HasFixedAmort = Case when crenoteid in (Select  distinct  CRENoteID  
--              from [Core].[AmortSchedule] A  
--              Inner join Core.Event E on E.EventID =  A.EventId  
--              Inner join Core.Lookup  L on L.LookupID = E.EventTypeID  
--              inner join cre.note n on n.Account_AccountID = e.AccountID  
--              inner join cre.Deal D on D.DealID = N.DealID  
--              where LookupID = 19) Then 'Yes' else 'No' End,  
  
--Pik_NonPIK = Case when CreNoteid in (Select CreNoteid from(Select n.crenoteid,(Select count(piks.StartDate)     
--       from Core.[PIKSchedule] piks    
--       inner join core.Event e on e.EventID = piks.EventId    
--       inner join core.Account acc on acc.AccountID = e.AccountID    
--       where e.EventTypeID = 12     
--       and acc.AccountID = n.account_accountid) PIKScheduleCnt    
--       from cre.Note n    
--       )a  where PIKScheduleCnt > 0    
--       ) THEN 'Pik Loan'    
--          else 'Non PIK'    
--          End  ,  
--HasFundingRepayment = Case   
--      when CRENoteID in (Select Distinct CRENoteID from Dw.NoteFundingScheduleBI  
--           where PurposeBI <> 'Amortization' and Amount <> 0)   
--      Then 'Yes' else 'No' end,  
  
--FullAccrualHasRepayment = Case when InterestCalculationRuleForPaydownsBI = 'Full Period Accrual'   
--        and   
--        CRENoteID in (Select Distinct CRENoteID from Dw.NotefundingscheduleBi  
--           where PurposeBI <> 'Amortization' and Amount < 0)  
--        THEN 'Yes' else 'No' end  
--        ,  
  
--HasAmortTerm_Or_FixedAmort = Case when crenoteid in (Select  distinct  CRENoteID  
--              from [Core].[AmortSchedule] A  
--              Inner join Core.Event E on E.EventID =  A.EventId  
--              Inner join Core.Lookup  L on L.LookupID = E.EventTypeID  
--              inner join cre.note n on n.Account_AccountID = e.AccountID  
--              inner join cre.Deal D on D.DealID = N.DealID  
--              where LookupID = 19 or Crenoteid in (Select Distinct CRENoteID from Cre.Note  
--              where ISNULL(AmortTerm,0) <> 0 )) Then 'Yes' else 'No' End,  
  
n.ServicerNameBI  as ServicerName,  
n.BusinessdaylafrelativetoPMTDate,  
n.DayoftheMonth,  
n.InterestCalculationRuleForPaydownsBI as InterestCalculationRuleForPaydowns,  
n.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDateBI as PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate,  
n.FundedAndOwnedByThirdParty ,  
n.InterestCalculationRuleForPaydownsAmortBI as  AmortInterestCalculationRuleForPaydowns  ,  
   
n.M61Commitment	,
n.M61AdjustedCommitment,
n.OriginationFeePercentageRP,

HasScheduledPrincipal,
HasPIkPrincipalpaid,
HasPIkInterestpaid,
InitialFundingEquCommit,
HasDSMonthlyOverride,
FixedPIK,
FloatingPIK
  
FROM [DW].[NoteBI] n


