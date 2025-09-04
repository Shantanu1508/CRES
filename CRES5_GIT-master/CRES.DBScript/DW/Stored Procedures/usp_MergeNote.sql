CREATE PROCEDURE [DW].[usp_MergeNote]  
@BatchLogId int  
AS  
BEGIN  
  
SET NOCOUNT ON  
  
  
UPDATE [DW].BatchDetail  
SET  
BITableName = 'NoteBI',  
BIStartTime = GETDATE()  
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_NoteBI'  
  
  
MERGE [DW].NoteBI NB  
USING [DW].L_NoteBI LNB  
ON NB.noteid = LNB.noteid  
WHEN MATCHED THEN  
 UPDATE   
 SET   
NB.[AccountID] = LNB.[AccountID],  
NB.[DealID] = LNB.[DealID],  
NB.[CRENoteID] = LNB.[CRENoteID],  
NB.[ClientNoteID] = LNB.[ClientNoteID],  
NB.[Comments] = LNB.[Comments],  
NB.[InitialInterestAccrualEndDate] = LNB.[InitialInterestAccrualEndDate],  
NB.[AccrualFrequency] = LNB.[AccrualFrequency],  
NB.[DeterminationDateLeadDays] = LNB.[DeterminationDateLeadDays],  
NB.[DeterminationDateReferenceDayoftheMonth] = LNB.[DeterminationDateReferenceDayoftheMonth],  
NB.[DeterminationDateInterestAccrualPeriod] = LNB.[DeterminationDateInterestAccrualPeriod],  
NB.[DeterminationDateHolidayList] = LNB.[DeterminationDateHolidayList],  
NB.[FirstPaymentDate] = LNB.[FirstPaymentDate],  
NB.[InitialMonthEndPMTDateBiWeekly] = LNB.[InitialMonthEndPMTDateBiWeekly],  
NB.[PaymentDateBusinessDayLag] = LNB.[PaymentDateBusinessDayLag],  
NB.[IOTerm] = LNB.[IOTerm],  
NB.[AmortTerm] = LNB.[AmortTerm],  
NB.[PIKSeparateCompounding] = LNB.[PIKSeparateCompounding],  
NB.[MonthlyDSOverridewhenAmortizing] = LNB.[MonthlyDSOverridewhenAmortizing],  
NB.[AccrualPeriodPaymentDayWhenNotEOMonth] = LNB.[AccrualPeriodPaymentDayWhenNotEOMonth],  
NB.[FirstPeriodInterestPaymentOverride] = LNB.[FirstPeriodInterestPaymentOverride],  
NB.[FirstPeriodPrincipalPaymentOverride] = LNB.[FirstPeriodPrincipalPaymentOverride],  
NB.[FinalInterestAccrualEndDateOverride] = LNB.[FinalInterestAccrualEndDateOverride],  
NB.[AmortType] = LNB.[AmortType],  
NB.[RateType] = LNB.[RateType],  
NB.[ReAmortizeMonthly] = LNB.[ReAmortizeMonthly],  
NB.[ReAmortizeatPMTReset] = LNB.[ReAmortizeatPMTReset],  
NB.[StubPaidInArrears] = LNB.[StubPaidInArrears],  
NB.[RelativePaymentMonth] = LNB.[RelativePaymentMonth],  
NB.[SettleWithAccrualFlag] = LNB.[SettleWithAccrualFlag],  
NB.[InterestDueAtMaturity] = LNB.[InterestDueAtMaturity],  
NB.[RateIndexResetFreq] = LNB.[RateIndexResetFreq],  
NB.[FirstRateIndexResetDate] = LNB.[FirstRateIndexResetDate],  
NB.[LoanPurchase] = LNB.[LoanPurchase],  
NB.[AmortIntCalcDayCount] = LNB.[AmortIntCalcDayCount],  
NB.[StubPaidinAdvanceYN] = LNB.[StubPaidinAdvanceYN],  
NB.[FullPeriodInterestDueatMaturity] = LNB.[FullPeriodInterestDueatMaturity],  
NB.[ProspectiveAccountingMode] = LNB.[ProspectiveAccountingMode],  
NB.[IsCapitalized] = LNB.[IsCapitalized],  
NB.[SelectedMaturityDateScenario] = LNB.[SelectedMaturityDateScenario],  
NB.[SelectedMaturityDate] = LNB.[SelectedMaturityDate],  
NB.[InitialMaturityDate] = LNB.[InitialMaturityDate],  
NB.[ExpectedMaturityDate] = LNB.[ExpectedMaturityDate],  
NB.[OpenPrepaymentDate] = LNB.[OpenPrepaymentDate],  
NB.[CashflowEngineID] = LNB.[CashflowEngineID],  
NB.[LoanType] = LNB.[LoanType],  
NB.[Classification] = LNB.[Classification],  
NB.[SubClassification] = LNB.[SubClassification],  
NB.[GAAPDesignation] = LNB.[GAAPDesignation],  
NB.[PortfolioID] = LNB.[PortfolioID],  
NB.[GeographicLocation] = LNB.[GeographicLocation],  
NB.[PropertyType] = LNB.[PropertyType],  
NB.[RatingAgency] = LNB.[RatingAgency],  
NB.[RiskRating] = LNB.[RiskRating],  
NB.[PurchasePrice] = LNB.[PurchasePrice],  
NB.[FutureFeesUsedforLevelYeild] = LNB.[FutureFeesUsedforLevelYeild],  
NB.[TotalToBeAmortized] = LNB.[TotalToBeAmortized],  
NB.[StubPeriodInterest] = LNB.[StubPeriodInterest],  
NB.[WDPAssetMultiple] = LNB.[WDPAssetMultiple],  
NB.[WDPEquityMultiple] = LNB.[WDPEquityMultiple],  
NB.[PurchaseBalance] = LNB.[PurchaseBalance],  
NB.[DaysofAccrued] = LNB.[DaysofAccrued],  
NB.[InterestRate] = LNB.[InterestRate],  
NB.[PurchasedInterestCalc] = LNB.[PurchasedInterestCalc],  
NB.[ModelFinancingDrawsForFutureFundings] = LNB.[ModelFinancingDrawsForFutureFundings],  
NB.[NumberOfBusinessDaysLagForFinancingDraw] = LNB.[NumberOfBusinessDaysLagForFinancingDraw],  
NB.[FinancingFacilityID] = LNB.[FinancingFacilityID],  
NB.[FinancingInitialMaturityDate] = LNB.[FinancingInitialMaturityDate],  
NB.[FinancingExtendedMaturityDate] = LNB.[FinancingExtendedMaturityDate],  
NB.[FinancingPayFrequency] = LNB.[FinancingPayFrequency],  
NB.[FinancingInterestPaymentDay] = LNB.[FinancingInterestPaymentDay],  
NB.[ClosingDate] = LNB.[ClosingDate],  
NB.[InitialFundingAmount] = LNB.[InitialFundingAmount],  
NB.[Discount] = LNB.[Discount],  
NB.[OriginationFee] = LNB.[OriginationFee],  
NB.[CapitalizedClosingCosts] = LNB.[CapitalizedClosingCosts],  
NB.[PurchaseDate] = LNB.[PurchaseDate],  
NB.[PurchaseAccruedFromDate] = LNB.[PurchaseAccruedFromDate],  
NB.[PurchasedInterestOverride] = LNB.[PurchasedInterestOverride],  
NB.[DiscountRate] = LNB.[DiscountRate],  
NB.[ValuationDate] = LNB.[ValuationDate],  
NB.[FairValue] = LNB.[FairValue],  
NB.[DiscountRatePlus] = LNB.[DiscountRatePlus],  
NB.[FairValuePlus] = LNB.[FairValuePlus],  
NB.[DiscountRateMinus] = LNB.[DiscountRateMinus],  
NB.[FairValueMinus] = LNB.[FairValueMinus],  
NB.[InitialIndexValueOverride] = LNB.[InitialIndexValueOverride],  
NB.[IncludeServicingPaymentOverrideinLevelYield] = LNB.[IncludeServicingPaymentOverrideinLevelYield],  
NB.[OngoingAnnualizedServicingFee] = LNB.[OngoingAnnualizedServicingFee],  
NB.[IndexRoundingRule] = LNB.[IndexRoundingRule],  
NB.[RoundingMethod] = LNB.[RoundingMethod],  
NB.[StubInterestPaidonFutureAdvances] = LNB.[StubInterestPaidonFutureAdvances],  
NB.[TaxAmortCheck] = LNB.[TaxAmortCheck],  
NB.[PIKWoCompCheck] = LNB.[PIKWoCompCheck],  
NB.[GAAPAmortCheck] = LNB.[GAAPAmortCheck],  
NB.[StubIntOverride] = LNB.[StubIntOverride],  
NB.[PurchasedIntOverride] = LNB.[PurchasedIntOverride],  
NB.[ExitFeeFreePrepayAmt] = LNB.[ExitFeeFreePrepayAmt],  
NB.[ExitFeeBaseAmountOverride] = LNB.[ExitFeeBaseAmountOverride],  
NB.[ExitFeeAmortCheck] = LNB.[ExitFeeAmortCheck],  
NB.[FixedAmortScheduleCheck] = LNB.[FixedAmortScheduleCheck],  
NB.[GeneratedBy] = LNB.[GeneratedBy],  
NB.[UseRuletoDetermineNoteFunding] = LNB.[UseRuletoDetermineNoteFunding],  
NB.[NoteFundingRule] = LNB.[NoteFundingRule],  
NB.[FundingPriority] = LNB.[FundingPriority],  
NB.[NoteBalanceCap] = LNB.[NoteBalanceCap],  
NB.[RepaymentPriority] = LNB.[RepaymentPriority],  
NB.[NoofdaysrelPaymentDaterollnextpaymentcycle] = LNB.[NoofdaysrelPaymentDaterollnextpaymentcycle],  
NB.[UseIndexOverrides] = LNB.[UseIndexOverrides],  
NB.[IndexNameID] = LNB.[IndexNameID],  
NB.[ServicerID] = LNB.[ServicerID],  
NB.[TotalCommitment] = LNB.[TotalCommitment],  
NB.[DeterminationDateHolidayListBI] = LNB.[DeterminationDateHolidayListBI],  
NB.[RateTypeBI] = LNB.[RateTypeBI],  
NB.[ReAmortizeMonthlyBI] = LNB.[ReAmortizeMonthlyBI],  
NB.[ReAmortizeatPMTResetBI] = LNB.[ReAmortizeatPMTResetBI],  
NB.[StubPaidInArrearsBI] = LNB.[StubPaidInArrearsBI],  
NB.[RelativePaymentMonthBI] = LNB.[RelativePaymentMonthBI],  
NB.[SettleWithAccrualFlagBI] = LNB.[SettleWithAccrualFlagBI],  
NB.[InterestDueAtMaturityBI] = LNB.[InterestDueAtMaturityBI],  
NB.[LoanPurchaseBI] = LNB.[LoanPurchaseBI],  
NB.[StubPaidinAdvanceYNBI] = LNB.[StubPaidinAdvanceYNBI],  
NB.[ProspectiveAccountingModeBI] = LNB.[ProspectiveAccountingModeBI],  
NB.[IsCapitalizedBI] = LNB.[IsCapitalizedBI],  
NB.[ClassificationBI] = LNB.[ClassificationBI],  
NB.[SubClassificationBI] = LNB.[SubClassificationBI],  
NB.[GAAPDesignationBI] = LNB.[GAAPDesignationBI],  
NB.[GeographicLocationBI] = LNB.[GeographicLocationBI],  
NB.[PropertyTypeBI] = LNB.[PropertyTypeBI],  
NB.[RatingAgencyBI] = LNB.[RatingAgencyBI],  
NB.[RiskRatingBI] = LNB.[RiskRatingBI],  
NB.[ModelFinancingDrawsForFutureFundingsBI] = LNB.[ModelFinancingDrawsForFutureFundingsBI],  
NB.[NumberOfBusinessDaysLagForFinancingDrawBI] = LNB.[NumberOfBusinessDaysLagForFinancingDrawBI],  
NB.[FinancingFacilityBI] = LNB.[FinancingFacilityBI],  
NB.[FinancingPayFrequencyBI] = LNB.[FinancingPayFrequencyBI],  
NB.[IncludeServicingPaymentOverrideinLevelYieldBI] = LNB.[IncludeServicingPaymentOverrideinLevelYieldBI],  
NB.[RoundingMethodBI] = LNB.[RoundingMethodBI],  
NB.[StubInterestPaidonFutureAdvancesBI] = LNB.[StubInterestPaidonFutureAdvancesBI],  
NB.[ExitFeeAmortCheckBI] = LNB.[ExitFeeAmortCheckBI],  
NB.[FixedAmortScheduleCheckBI] = LNB.[FixedAmortScheduleCheckBI],  
NB.[IndexNameBI] = LNB.[IndexNameBI],  
NB.[StatusID] = LNB.[StatusID],  
NB.[StatusBI] = LNB.[StatusBI],  
NB.[Name] = LNB.[Name],  
NB.[BaseCurrencyID] = LNB.[BaseCurrencyID],  
NB.[BaseCurrencyBI] = LNB.[BaseCurrencyBI],  
NB.[PayFrequency] = LNB.[PayFrequency],  
NB.[ImportBIDate] = GETDATE(),  
NB.[ClientName] = LNB.[ClientName],  
NB.[Portfolio] = LNB.[Portfolio],  
NB.[Tag1] = LNB.[Tag1],  
NB.[Tag2] = LNB.[Tag2],  
NB.[Tag3] = LNB.[Tag3],  
NB.[Tag4] = LNB.[Tag4],  
NB.[CreatedBy] = LNB.[CreatedBy],  
NB.[CreatedDate] = LNB.[CreatedDate],  
NB.[UpdatedBy] = LNB.[UpdatedBy],  
NB.[UpdatedDate] = LNB.[UpdatedDate],  
NB.[lienposition] = LNB.[lienposition],  
NB.[lienpositionBI] = LNB.[lienpositionBI],  
NB.priority = LNB.priority,  
--NB.ExtendedMaturityScenario1 = LNB. ExtendedMaturityScenario1 ,  
--NB.ExtendedMaturityScenario2 = LNB. ExtendedMaturityScenario2 ,  
--NB.ExtendedMaturityScenario3 = LNB. ExtendedMaturityScenario3 ,  
NB.ActualPayoffDate = LNB. ActualPayoffDate ,  
NB.FullyExtendedMaturityDate = LNB. FullyExtendedMaturityDate ,  
NB.TotalCommitmentExtensionFeeisBasedOn = LNB. TotalCommitmentExtensionFeeisBasedOn ,  
NB.LienPriority = LNB. LienPriority ,  
NB.UnusedFeeThresholdBalance = LNB. UnusedFeeThresholdBalance ,  
NB.UnusedFeePaymentFrequency = LNB. UnusedFeePaymentFrequency ,  
NB.Servicer = LNB. Servicer ,  
NB.FullInterestAtPPayoff = LNB. FullInterestAtPPayoff ,  
NB.ServicerBI = LNB. ServicerBI ,  
  
NB.ClientID  = LNB.ClientID ,  
NB.FinancingSourceID  = LNB.FinancingSourceID ,  
NB.DebtTypeID  = LNB.DebtTypeID ,  
NB.BillingNotesID  = LNB.BillingNotesID ,  
NB.CapStack  = LNB.CapStack ,  
NB.ClientBI  = LNB.ClientBI ,  
NB.FinancingSourceBI  = LNB.FinancingSourceBI ,  
NB.DebtTypeBI  = LNB.DebtTypeBI ,  
NB.BillingNotesBI  = LNB.BillingNotesBI ,  
NB.CapStackBI  = LNB.CapStackBI ,  
NB.FundID  = LNB.FundID ,  
NB.FundBI  = LNB.FundBI ,  
NB.PoolID  = LNB.PoolID ,  
NB.PoolBI  = LNB.PoolBI ,  
  
NB.ServicerNameID= LNB.ServicerNameID,  
NB.ServicerNameBI= LNB.ServicerNameBI,  
NB.BusinessdaylafrelativetoPMTDate= LNB.BusinessdaylafrelativetoPMTDate,  
NB.DayoftheMonth= LNB.DayoftheMonth,  
NB.InterestCalculationRuleForPaydowns= LNB.InterestCalculationRuleForPaydowns,  
NB.InterestCalculationRuleForPaydownsBI= LNB.InterestCalculationRuleForPaydownsBI,  
NB.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate= LNB.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate,  
NB.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDateBI= LNB.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDateBI,  
  
NB.FundedAndOwnedByThirdParty= LNB.FundedAndOwnedByThirdParty,  
NB.InterestCalculationRuleForPaydownsAmort= LNB.InterestCalculationRuleForPaydownsAmort,  
NB.InterestCalculationRuleForPaydownsAmortBI= LNB.InterestCalculationRuleForPaydownsAmortBI,  
NB.Pik_NonPIK  = LNB.Pik_NonPIK,  
NB.HasFundingRepayment = LNB.HasFundingRepayment,  
NB.FullAccrualHasRepayment = LNB.FullAccrualHasRepayment,  
NB.HasAmortTerm_Or_FixedAmort = LNB.HasAmortTerm_Or_FixedAmort,  
NB.HasAmortTerm = LNB.HasAmortTerm,  
NB.HasOnlyRepayment = LNB.HasOnlyRepayment,  
NB.HasFixedAmort = LNB.HasFixedAmort,  
  
NB.HasScheduledPrincipal = LNB.HasScheduledPrincipal,  
NB.HasPIkPrincipalpaid = LNB.HasPIkPrincipalpaid,  
NB.HasPIkInterestpaid = LNB.HasPIkInterestpaid,  
NB.InitialFundingEquCommit = LNB.InitialFundingEquCommit,  
NB.HasDSMonthlyOverride = LNB.HasDSMonthlyOverride,  
NB.FixedPIK = LNB.FixedPIK,  
NB.FloatingPIK = LNB.FloatingPIK,  
NB.FinancingSourceGroup = LNB.FinancingSourceGroup,  
NB.ImpactCommitmentCalc = LNB.ImpactCommitmentCalc,  
NB.ImpactCommitmentCalcBI = LNB.ImpactCommitmentCalcBI,  
NB.FirstIndexDeterminationDateOverride = LNB.FirstIndexDeterminationDateOverride ,

NB.NoteType= LNB.NoteType ,
NB.EnableM61Calculations= LNB.EnableM61Calculations ,
NB.NoteTypeBI= LNB.NoteTypeBI ,
NB.EnableM61CalculationsBI= LNB.EnableM61CalculationsBI ,
NB.RepaymentDayoftheMonth= LNB.RepaymentDayoftheMonth 
  
WHEN NOT MATCHED THEN  
   
 INSERT   
 ([NoteID]  
           ,[AccountID]  
           ,[DealID]  
           ,[CRENoteID]  
           ,[ClientNoteID]  
           ,[Comments]  
           ,[InitialInterestAccrualEndDate]  
           ,[AccrualFrequency]  
           ,[DeterminationDateLeadDays]  
           ,[DeterminationDateReferenceDayoftheMonth]  
           ,[DeterminationDateInterestAccrualPeriod]  
           ,[DeterminationDateHolidayList]  
           ,[FirstPaymentDate]  
           ,[InitialMonthEndPMTDateBiWeekly]  
           ,[PaymentDateBusinessDayLag]  
           ,[IOTerm]  
           ,[AmortTerm]  
           ,[PIKSeparateCompounding]  
           ,[MonthlyDSOverridewhenAmortizing]  
           ,[AccrualPeriodPaymentDayWhenNotEOMonth]  
           ,[FirstPeriodInterestPaymentOverride]  
           ,[FirstPeriodPrincipalPaymentOverride]  
           ,[FinalInterestAccrualEndDateOverride]  
           ,[AmortType]  
           ,[RateType]  
           ,[ReAmortizeMonthly]  
           ,[ReAmortizeatPMTReset]  
           ,[StubPaidInArrears]  
           ,[RelativePaymentMonth]  
           ,[SettleWithAccrualFlag]  
           ,[InterestDueAtMaturity]  
           ,[RateIndexResetFreq]  
           ,[FirstRateIndexResetDate]  
           ,[LoanPurchase]  
           ,[AmortIntCalcDayCount]  
           ,[StubPaidinAdvanceYN]  
           ,[FullPeriodInterestDueatMaturity]  
           ,[ProspectiveAccountingMode]  
           ,[IsCapitalized]  
           ,[SelectedMaturityDateScenario]  
           ,[SelectedMaturityDate]  
           ,[InitialMaturityDate]  
           ,[ExpectedMaturityDate]  
           ,[OpenPrepaymentDate]  
           ,[CashflowEngineID]  
           ,[LoanType]  
           ,[Classification]  
           ,[SubClassification]  
           ,[GAAPDesignation]  
           ,[PortfolioID]  
           ,[GeographicLocation]  
           ,[PropertyType]  
           ,[RatingAgency]  
           ,[RiskRating]  
           ,[PurchasePrice]  
           ,[FutureFeesUsedforLevelYeild]  
           ,[TotalToBeAmortized]  
           ,[StubPeriodInterest]  
           ,[WDPAssetMultiple]  
           ,[WDPEquityMultiple]  
           ,[PurchaseBalance]  
           ,[DaysofAccrued]  
           ,[InterestRate]  
           ,[PurchasedInterestCalc]  
           ,[ModelFinancingDrawsForFutureFundings]  
           ,[NumberOfBusinessDaysLagForFinancingDraw]  
           ,[FinancingFacilityID]  
           ,[FinancingInitialMaturityDate]  
           ,[FinancingExtendedMaturityDate]  
           ,[FinancingPayFrequency]  
           ,[FinancingInterestPaymentDay]  
           ,[ClosingDate]  
           ,[InitialFundingAmount]  
           ,[Discount]  
           ,[OriginationFee]  
           ,[CapitalizedClosingCosts]  
           ,[PurchaseDate]  
           ,[PurchaseAccruedFromDate]  
           ,[PurchasedInterestOverride]  
           ,[DiscountRate]  
           ,[ValuationDate]  
           ,[FairValue]  
           ,[DiscountRatePlus]  
           ,[FairValuePlus]  
           ,[DiscountRateMinus]  
           ,[FairValueMinus]  
           ,[InitialIndexValueOverride]  
           ,[IncludeServicingPaymentOverrideinLevelYield]  
           ,[OngoingAnnualizedServicingFee]  
           ,[IndexRoundingRule]  
           ,[RoundingMethod]  
           ,[StubInterestPaidonFutureAdvances]  
           ,[TaxAmortCheck]  
           ,[PIKWoCompCheck]  
           ,[GAAPAmortCheck]  
           ,[StubIntOverride]  
           ,[PurchasedIntOverride]  
           ,[ExitFeeFreePrepayAmt]  
           ,[ExitFeeBaseAmountOverride]  
           ,[ExitFeeAmortCheck]  
           ,[FixedAmortScheduleCheck]  
           ,[GeneratedBy]  
           ,[UseRuletoDetermineNoteFunding]  
           ,[NoteFundingRule]  
           ,[FundingPriority]  
           ,[NoteBalanceCap]  
           ,[RepaymentPriority]  
           ,[NoofdaysrelPaymentDaterollnextpaymentcycle]  
           ,[UseIndexOverrides]  
           ,[IndexNameID]  
           ,[ServicerID]  
           ,[TotalCommitment]  
           ,[DeterminationDateHolidayListBI]  
           ,[RateTypeBI]  
           ,[ReAmortizeMonthlyBI]  
           ,[ReAmortizeatPMTResetBI]  
           ,[StubPaidInArrearsBI]  
           ,[RelativePaymentMonthBI]  
           ,[SettleWithAccrualFlagBI]  
           ,[InterestDueAtMaturityBI]  
           ,[LoanPurchaseBI]  
           ,[StubPaidinAdvanceYNBI]  
           ,[ProspectiveAccountingModeBI]  
           ,[IsCapitalizedBI]  
           ,[ClassificationBI]  
           ,[SubClassificationBI]  
           ,[GAAPDesignationBI]  
           ,[GeographicLocationBI]  
           ,[PropertyTypeBI]  
           ,[RatingAgencyBI]  
           ,[RiskRatingBI]  
           ,[ModelFinancingDrawsForFutureFundingsBI]  
           ,[NumberOfBusinessDaysLagForFinancingDrawBI]  
           ,[FinancingFacilityBI]  
           ,[FinancingPayFrequencyBI]  
           ,[IncludeServicingPaymentOverrideinLevelYieldBI]  
           ,[RoundingMethodBI]  
           ,[StubInterestPaidonFutureAdvancesBI]  
           ,[ExitFeeAmortCheckBI]  
           ,[FixedAmortScheduleCheckBI]  
           ,[IndexNameBI]  
           ,[StatusID]  
           ,[StatusBI]  
           ,[Name]  
           ,[BaseCurrencyID]  
           ,[BaseCurrencyBI]  
           ,[PayFrequency]  
     ,[ImportBIDate]  
     ,[ClientName]  
   ,[Portfolio]  
   ,[Tag1]  
   ,[Tag2]  
   ,[Tag3]  
   ,[Tag4]  
   ,[CreatedBy]  
           ,[CreatedDate]  
           ,[UpdatedBy]  
           ,[UpdatedDate]  
     ,lienposition  
     ,[lienpositionBI]  
     ,priority  
  --   ,ExtendedMaturityScenario1   
--,ExtendedMaturityScenario2   
--,ExtendedMaturityScenario3   
,ActualPayoffDate   
,FullyExtendedMaturityDate   
,TotalCommitmentExtensionFeeisBasedOn  
,LienPriority  
,UnusedFeeThresholdBalance  
,UnusedFeePaymentFrequency  
,Servicer  
,FullInterestAtPPayoff  
,ServicerBI  
  
,ClientID  
,FinancingSourceID  
,DebtTypeID  
,BillingNotesID  
,CapStack  
,ClientBI  
,FinancingSourceBI  
,DebtTypeBI  
,BillingNotesBI  
,CapStackBI  
,FundID  
,FundBI  
,PoolID  
,PoolBI  
  
,ServicerNameID  
,ServicerNameBI  
,BusinessdaylafrelativetoPMTDate  
,DayoftheMonth  
,InterestCalculationRuleForPaydowns  
,InterestCalculationRuleForPaydownsBI  
,PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate  
,PIKInterestAddedToBalanceBasedOnBusinessAdjustedDateBI  
,FundedAndOwnedByThirdParty  
,InterestCalculationRuleForPaydownsAmort  
,InterestCalculationRuleForPaydownsAmortBI  
,Pik_NonPIK   
,HasFundingRepayment   
,FullAccrualHasRepayment   
,HasAmortTerm_Or_FixedAmort  
,HasAmortTerm  
,HasOnlyRepayment  
,HasFixedAmort  
  
,HasScheduledPrincipal  
,HasPIkPrincipalpaid  
,HasPIkInterestpaid  
,InitialFundingEquCommit  
,HasDSMonthlyOverride  
,FixedPIK  
,FloatingPIK  
,FinancingSourceGroup  
,ImpactCommitmentCalc  
,ImpactCommitmentCalcBI  
,FirstIndexDeterminationDateOverride  

,NoteType
,EnableM61Calculations
,NoteTypeBI
,EnableM61CalculationsBI
,RepaymentDayoftheMonth
)  
  
VALUES (LNB.[NoteID],  
LNB.[AccountID],  
LNB.[DealID],  
LNB.[CRENoteID],  
LNB.[ClientNoteID],  
LNB.[Comments],  
LNB.[InitialInterestAccrualEndDate],  
LNB.[AccrualFrequency],  
LNB.[DeterminationDateLeadDays],  
LNB.[DeterminationDateReferenceDayoftheMonth],  
LNB.[DeterminationDateInterestAccrualPeriod],  
LNB.[DeterminationDateHolidayList],  
LNB.[FirstPaymentDate],  
LNB.[InitialMonthEndPMTDateBiWeekly],  
LNB.[PaymentDateBusinessDayLag],  
LNB.[IOTerm],  
LNB.[AmortTerm],  
LNB.[PIKSeparateCompounding],  
LNB.[MonthlyDSOverridewhenAmortizing],  
LNB.[AccrualPeriodPaymentDayWhenNotEOMonth],  
LNB.[FirstPeriodInterestPaymentOverride],  
LNB.[FirstPeriodPrincipalPaymentOverride],  
LNB.[FinalInterestAccrualEndDateOverride],  
LNB.[AmortType],  
LNB.[RateType],  
LNB.[ReAmortizeMonthly],  
LNB.[ReAmortizeatPMTReset],  
LNB.[StubPaidInArrears],  
LNB.[RelativePaymentMonth],  
LNB.[SettleWithAccrualFlag],  
LNB.[InterestDueAtMaturity],  
LNB.[RateIndexResetFreq],  
LNB.[FirstRateIndexResetDate],  
LNB.[LoanPurchase],  
LNB.[AmortIntCalcDayCount],  
LNB.[StubPaidinAdvanceYN],  
LNB.[FullPeriodInterestDueatMaturity],  
LNB.[ProspectiveAccountingMode],  
LNB.[IsCapitalized],  
LNB.[SelectedMaturityDateScenario],  
LNB.[SelectedMaturityDate],  
LNB.[InitialMaturityDate],  
LNB.[ExpectedMaturityDate],  
LNB.[OpenPrepaymentDate],  
LNB.[CashflowEngineID],  
LNB.[LoanType],  
LNB.[Classification],  
LNB.[SubClassification],  
LNB.[GAAPDesignation],  
LNB.[PortfolioID],  
LNB.[GeographicLocation],  
LNB.[PropertyType],  
LNB.[RatingAgency],  
LNB.[RiskRating],  
LNB.[PurchasePrice],  
LNB.[FutureFeesUsedforLevelYeild],  
LNB.[TotalToBeAmortized],  
LNB.[StubPeriodInterest],  
LNB.[WDPAssetMultiple],  
LNB.[WDPEquityMultiple],  
LNB.[PurchaseBalance],  
LNB.[DaysofAccrued],  
LNB.[InterestRate],  
LNB.[PurchasedInterestCalc],  
LNB.[ModelFinancingDrawsForFutureFundings],  
LNB.[NumberOfBusinessDaysLagForFinancingDraw],  
LNB.[FinancingFacilityID],  
LNB.[FinancingInitialMaturityDate],  
LNB.[FinancingExtendedMaturityDate],  
LNB.[FinancingPayFrequency],  
LNB.[FinancingInterestPaymentDay],  
LNB.[ClosingDate],  
LNB.[InitialFundingAmount],  
LNB.[Discount],  
LNB.[OriginationFee],  
LNB.[CapitalizedClosingCosts],  
LNB.[PurchaseDate],  
LNB.[PurchaseAccruedFromDate],  
LNB.[PurchasedInterestOverride],  
LNB.[DiscountRate],  
LNB.[ValuationDate],  
LNB.[FairValue],  
LNB.[DiscountRatePlus],  
LNB.[FairValuePlus],  
LNB.[DiscountRateMinus],  
LNB.[FairValueMinus],  
LNB.[InitialIndexValueOverride],  
LNB.[IncludeServicingPaymentOverrideinLevelYield],  
LNB.[OngoingAnnualizedServicingFee],  
LNB.[IndexRoundingRule],  
LNB.[RoundingMethod],  
LNB.[StubInterestPaidonFutureAdvances],  
LNB.[TaxAmortCheck],  
LNB.[PIKWoCompCheck],  
LNB.[GAAPAmortCheck],  
LNB.[StubIntOverride],  
LNB.[PurchasedIntOverride],  
LNB.[ExitFeeFreePrepayAmt],  
LNB.[ExitFeeBaseAmountOverride],  
LNB.[ExitFeeAmortCheck],  
LNB.[FixedAmortScheduleCheck],  
LNB.[GeneratedBy],  
LNB.[UseRuletoDetermineNoteFunding],  
LNB.[NoteFundingRule],  
LNB.[FundingPriority],  
LNB.[NoteBalanceCap],  
LNB.[RepaymentPriority],  
LNB.[NoofdaysrelPaymentDaterollnextpaymentcycle],  
LNB.[UseIndexOverrides],  
LNB.[IndexNameID],  
LNB.[ServicerID],  
LNB.[TotalCommitment],  
LNB.[DeterminationDateHolidayListBI],  
LNB.[RateTypeBI],  
LNB.[ReAmortizeMonthlyBI],  
LNB.[ReAmortizeatPMTResetBI],  
LNB.[StubPaidInArrearsBI],  
LNB.[RelativePaymentMonthBI],  
LNB.[SettleWithAccrualFlagBI],  
LNB.[InterestDueAtMaturityBI],  
LNB.[LoanPurchaseBI],  
LNB.[StubPaidinAdvanceYNBI],  
LNB.[ProspectiveAccountingModeBI],  
LNB.[IsCapitalizedBI],  
LNB.[ClassificationBI],  
LNB.[SubClassificationBI],  
LNB.[GAAPDesignationBI],  
LNB.[GeographicLocationBI],  
LNB.[PropertyTypeBI],  
LNB.[RatingAgencyBI],  
LNB.[RiskRatingBI],  
LNB.[ModelFinancingDrawsForFutureFundingsBI],  
LNB.[NumberOfBusinessDaysLagForFinancingDrawBI],  
LNB.[FinancingFacilityBI],  
LNB.[FinancingPayFrequencyBI],  
LNB.[IncludeServicingPaymentOverrideinLevelYieldBI],  
LNB.[RoundingMethodBI],  
LNB.[StubInterestPaidonFutureAdvancesBI],  
LNB.[ExitFeeAmortCheckBI],  
LNB.[FixedAmortScheduleCheckBI],  
LNB.[IndexNameBI],  
LNB.[StatusID],  
LNB.[StatusBI],  
LNB.[Name],  
LNB.[BaseCurrencyID],  
LNB.[BaseCurrencyBI],  
LNB.[PayFrequency],  
GETDATE(),  
LNB.[ClientName],  
LNB.[Portfolio],  
LNB.[Tag1],  
LNB.[Tag2],  
LNB.[Tag3],  
LNB.[Tag4],  
LNB.[CreatedBy],  
LNB.[CreatedDate],  
LNB.[UpdatedBy],  
LNB.[UpdatedDate],  
LNB.lienposition,  
LNB.[lienpositionBI],  
LNB.priority,  
--LNB.ExtendedMaturityScenario1,  
--LNB.ExtendedMaturityScenario2,  
--LNB.ExtendedMaturityScenario3,  
LNB.ActualPayoffDate,  
LNB.FullyExtendedMaturityDate,  
LNB.TotalCommitmentExtensionFeeisBasedOn,  
LNB.LienPriority,  
LNB.UnusedFeeThresholdBalance,  
LNB.UnusedFeePaymentFrequency,  
LNB.Servicer,  
LNB.FullInterestAtPPayoff,  
LNB.ServicerBI,  
  
LNB.ClientID,  
LNB.FinancingSourceID,  
LNB.DebtTypeID,  
LNB.BillingNotesID,  
LNB.CapStack,  
LNB.ClientBI,  
LNB.FinancingSourceBI,  
LNB.DebtTypeBI,  
LNB.BillingNotesBI,  
LNB.CapStackBI,  
LNB.FundID,  
LNB.FundBI,  
LNB.PoolID,  
LNB.PoolBI,  
  
LNB.ServicerNameID,  
LNB.ServicerNameBI,  
LNB.BusinessdaylafrelativetoPMTDate,  
LNB.DayoftheMonth,  
LNB.InterestCalculationRuleForPaydowns,  
LNB.InterestCalculationRuleForPaydownsBI,  
LNB.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate,  
LNB.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDateBI,  
  
LNB.FundedAndOwnedByThirdParty,  
LNB.InterestCalculationRuleForPaydownsAmort,  
LNB.InterestCalculationRuleForPaydownsAmortBI,  
LNB.Pik_NonPIK ,  
LNB.HasFundingRepayment ,  
LNB.FullAccrualHasRepayment ,  
LNB.HasAmortTerm_Or_FixedAmort,  
LNB.HasAmortTerm,  
LNB.HasOnlyRepayment,  
LNB.HasFixedAmort,  
  
LNB.HasScheduledPrincipal,  
LNB.HasPIkPrincipalpaid,  
LNB.HasPIkInterestpaid,  
LNB.InitialFundingEquCommit,  
LNB.HasDSMonthlyOverride,  
LNB.FixedPIK,  
LNB.FloatingPIK,  
LNB.FinancingSourceGroup,  
LNB.ImpactCommitmentCalc,  
LNB.ImpactCommitmentCalcBI,  
LNB.FirstIndexDeterminationDateOverride  ,

LNB.NoteType,
LNB.EnableM61Calculations,
LNB.NoteTypeBI,
LNB.EnableM61CalculationsBI,
LNB.RepaymentDayoftheMonth
);  
  
  
  
DECLARE @RowCount int  
SET @RowCount = @@ROWCOUNT  
  
UPDATE [DW].BatchDetail  
SET  
BIEndTime = GETDATE(),  
BIRecordCount = @RowCount  
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_NoteBI'  
  
Print(char(9) +'usp_MergeNote - ROWCOUNT = '+cast(@RowCount  as varchar(100)));  
  
  
END
GO

