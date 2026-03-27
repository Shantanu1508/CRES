using System;
using System.Collections.Generic;
using System.Data;

namespace CRES.DataContract
{
    public class NoteDataContract
    {
        public string NoteId { get; set; }
        public string ID { get; set; }
        public string AccountID { get; set; }
        public string DealID { get; set; }
        public string DealName { get; set; }
        public string CREDealID { get; set; }
        public string CalculatorExceptionMessage { get; set; }
        public string CRENoteID { get; set; }
        public string ClientNoteID { get; set; }
        public string Comments { get; set; }
        public bool? EnableTrace { get; set; }
        public DateTime? InitialInterestAccrualEndDate { get; set; }
        public DateTime? PrepayDate { get; set; }
        public int? AccrualFrequency { get; set; }
        public int? DeterminationDateLeadDays { get; set; }
        public int? DeterminationDateReferenceDayoftheMonth { get; set; }
        public int? DeterminationDateInterestAccrualPeriod { get; set; }
        public int? DeterminationDateHolidayList { get; set; }
        public string DeterminationDateHolidayListText { get; set; }
        public DateTime? FirstPaymentDate { get; set; }
        public DateTime? InitialMonthEndPMTDateBiWeekly { get; set; }
        public int? PaymentDateBusinessDayLag { get; set; }
        public int? IOTerm { get; set; }
        public string DefaultscenarioID { get; set; }
        public int? AmortTerm { get; set; }
        public int? PIKSeparateCompounding { get; set; }
        public Decimal? MonthlyDSOverridewhenAmortizing { get; set; }
        public int? AccrualPeriodPaymentDayWhenNotEOMonth { get; set; }
        public Decimal? FirstPeriodInterestPaymentOverride { get; set; }
        public Decimal? FirstPeriodPrincipalPaymentOverride { get; set; }
        public DateTime? FinalInterestAccrualEndDateOverride { get; set; }
        //public int? LoanCurrency { get; set; }
        public int? AmortType { get; set; }
        public int? RateType { get; set; }
        public string RateTypeText { get; set; }
        public int? ReAmortizeMonthly { get; set; }
        public int? ReAmortizeatPMTReset { get; set; }
        public int? StubPaidInArrears { get; set; }
        public int? RelativePaymenttMonth { get; set; }
        public int? SettleWithAccrualFlag { get; set; }
        public int? InterestDueAtMaturity { get; set; }
        public Decimal? RateIndexResetFreq { get; set; }
        public DateTime? FirstRateIndexResetDate { get; set; }
        public int? LoanPurchase { get; set; }
        public int? AmortIntCalcDayCount { get; set; }
        public int? StubPaidinAdvanceYN { get; set; }
        public int? FullPeriodInterestDueatMaturity { get; set; }
        public int? ProspectiveAccountingMode { get; set; }
        public int? IsCapitalized { get; set; }
        public int? SelectedMaturityDateScenario { get; set; }
        public string SelectedMaturityDateScenarioText { get; set; }
        public DateTime? SelectedMaturityDate { get; set; }
        public DateTime? InitialMaturityDate { get; set; }
        public DateTime? ExpectedMaturityDate { get; set; }
        public DateTime? FullyExtendedMaturityDate { get; set; }
        public DateTime? OpenPrepaymentDate { get; set; }
        public int? CashflowEngineID { get; set; }
        public int? LoanType { get; set; }
        public int? Classification { get; set; }
        public int? SubClassification { get; set; }
        public int? GAAPDesignation { get; set; }
        public int? PortfolioID { get; set; }
        public int? GeographicLocation { get; set; }
        public int? PropertyType { get; set; }
        public int? RatingAgency { get; set; }
        public int? RiskRating { get; set; }
        public Decimal? PurchasePrice { get; set; }
        public Decimal? FutureFeesUsedforLevelYeild { get; set; }
        public Decimal? TotalToBeAmortized { get; set; }
        public Decimal? StubPeriodInterest { get; set; }
        public Decimal? WDPAssetMultiple { get; set; }
        public Decimal? WDPEquityMultiple { get; set; }
        public Decimal? PurchaseBalance { get; set; }
        public int? DaysofAccrued { get; set; }
        public Decimal? InterestRate { get; set; }
        public Decimal? PurchasedInterestCalc { get; set; }
        public int? ModelFinancingDrawsForFutureFundings { get; set; }
        public int? NumberOfBusinessDaysLagForFinancingDraw { get; set; }
        public Guid? FinancingFacilityID { get; set; }
        public string FinancingFacilityIDText { get; set; }
        public DateTime? FinancingInitialMaturityDate { get; set; }
        public DateTime? FinancingExtendedMaturityDate { get; set; }
        public int? FinancingPayFrequency { get; set; }
        public int? FinancingInterestPaymentDay { get; set; }
        public DateTime? ClosingDate { get; set; }
        public Decimal? InitialFundingAmount { get; set; }
        public Decimal? Discount { get; set; }
        public Decimal? OriginationFee { get; set; }
        public Decimal? CapitalizedClosingCosts { get; set; }
        public DateTime? PurchaseDate { get; set; }
        public Decimal? PurchaseAccruedFromDate { get; set; }
        public Decimal? PurchasedInterestOverride { get; set; }
        public Decimal? OngoingAnnualizedServicingFee { get; set; }
        public Decimal? DiscountRate { get; set; }
        public DateTime? ValuationDate { get; set; }
        public Decimal? FairValue { get; set; }
        public Decimal? DiscountRatePlus { get; set; }
        public Decimal? FairValuePlus { get; set; }
        public Decimal? DiscountRateMinus { get; set; }
        public Decimal? FairValueMinus { get; set; }
        public int? IncludeServicingPaymentOverrideinLevelYield { get; set; }
        public string IncludeServicingPaymentOverrideinLevelYieldText { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string PIKSeparateCompoundingText { get; set; }
        public string LoanPurchaseYNText { get; set; }
        public string StubPaidinAdvanceYNText { get; set; }
        public string ModelFinancingDrawsForFutureFundingsText { get; set; }
        public int? RelativePaymentMonth { get; set; }
        public decimal? InitialIndexValueOverride { get; set; }
        public int? StubInterestPaidonFutureAdvances { get; set; }
        public string TaxAmortCheck { get; set; }
        public string PIKWoCompCheck { get; set; }
        public string GAAPAmortCheck { get; set; }
        public int? RoundingMethod { get; set; }
        public string RoundingMethodText { get; set; }
        public int? IndexRoundingRule { get; set; }
        public string StubOnFFtext { get; set; }
        public int? StubOnFF { get; set; }
        public decimal? StubInterestPurchased { get; set; }
        public int? StatusID { get; set; }
        public string StatusName { get; set; }
        public string Name { get; set; }
        public int? BaseCurrencyID { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? PayFrequency { get; set; }
        public string LoanCurrency { get; set; }
        public Decimal? StubIntOverride { get; set; }
        public Decimal? PurchasedIntOverride { get; set; }
        public Decimal? ExitFeeFreePrepayAmt { get; set; }
        public Decimal? ExitFeeBaseAmountOverride { get; set; }
        public int? ExitFeeAmortCheck { get; set; }
        public string ExitFeeAmortCheckText { get; set; }
        public int? FixedAmortSchedule { get; set; }
        public string FixedAmortScheduleText { get; set; }
        public int? UseRuletoDetermineNoteFunding { get; set; }
        public string UseRuletoDetermineNoteFundingText { get; set; }
        public int? NoteFundingRule { get; set; }
        public string NoteFundingRuleText { get; set; }
        public Decimal? NoteBalanceCap { get; set; }
        public int? FundingPriority { get; set; }
        public int? RepaymentPriority { get; set; }
        public Decimal? WeightedSpread { get; set; }
        public bool? UseIndexOverrides { get; set; }
        public int? IndexNameID { get; set; }
        public string IndexNameText { get; set; }
        public Decimal? UnusedFeeThresholdBalance { get; set; }
        public int UnusedFeePaymentFrequency { get; set; }
        public string ClientName { get; set; }
        public string Portfolio { get; set; }
        public string Tag1 { get; set; }
        public string Tag2 { get; set; }
        public string Tag3 { get; set; }
        public string Tag4 { get; set; }
        public string CalcEngineTypeText { get; set; }
        public int? AccrualPeriodType { get; set; }
        public string AccrualPeriodTypetext { get; set; }
        public int? AccrualPeriodBusinessDayAdj { get; set; }
        public string AccrualPeriodBusinessDayAdjText { get; set; }
        public DateTime? ExtendedMaturityCurrent { get; set; }
        public DateTime? ActualPayoffDate { get; set; }
        public Decimal? TotalCommitmentExtensionFeeisBasedOn { get; set; }
        public int? Servicer { get; set; }
        public string ServicerText { get; set; }
        public string FullInterestAtPPayoffText { get; set; }
        public int? FullInterestAtPPayoff { get; set; }
        public string CRENewNoteID { get; set; }
        public Boolean? CollectCalculatorLogs { get; set; }
        public string MaturityScenarioOverrideText { get; set; }
        public int? CalculationModeID { get; set; }
        public string CalculationModeText { get; set; }
        public DateTime? AcctgCloseDate { get; set; }
        public DateTime? LiborDataAsofDate { get; set; }
        public int? BusinessdaylafrelativetoPMTDate { get; set; }
        public int? DayoftheMonth { get; set; }
        public int? PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate { get; set; }
        public String PIKInterestAddedToBalanceBasedOnBusinessAdjustedDateText { get; set; }
        public int? InterestCalculationRuleForPaydowns { get; set; }
        public String InterestCalculationRuleForPaydownsText { get; set; }
        public int? InterestCalculationRuleForPIKPaydowns { get; set; }
        public String InterestCalculationRuleForPIKPaydownsText { get; set; }
        public DataTable maturityList { get; set; }
        public DateTime? NoteTransferDate { get; set; }
        public DateTime? LastAccountingCloseDate { get; set; }
        public List<PIKSchedule> NotePIKScheduleList { get; set; }
        public List<RateSpreadSchedule> RateSpreadScheduleList { get; set; }
        public List<MaturityScenariosDataContract> MaturityScenariosList { get; set; }
        public List<MaturityScenariosDataContract> lstMaturity { get; set; }
        public List<MaturityScenariosDataContract> MaturityScenariosListFromDatabase { get; set; }
        public List<StrippingScheduleDataContract> NoteStrippingList { get; set; }
        public List<NoteCommitmentEquityDataContract> NoteCommitmentNoteData { get; set; }
        public List<DefaultScheduleDataContract> NoteDefaultScheduleList { get; set; }
        public List<PrepayAndAdditionalFeeScheduleDataContract> NotePrepayAndAdditionalFeeScheduleList { get; set; }
        public List<EffectiveDateList> EffectiveDateList { get; set; }
        public List<FutureFundingScheduleTab> ListFutureFundingScheduleTab { get; set; }
        public List<FutureFundingScheduleTab> ListFutureFundingScheduleTabFromDB { get; set; }
        public List<PIKfromPIKSourceNoteTab> ListPIKfromPIKSourceNoteTab { get; set; }
        public List<FeeCouponStripReceivableTab> ListFeeCouponStripReceivable { get; set; }
        public List<LiborScheduleTab> ListLiborScheduleTab { get; set; }
        public List<FixedAmortScheduleTab> ListFixedAmortScheduleTab { get; set; }
        public List<NoteServicingFeeScheduleDataContract> NoteServicingFeeScheduleList { get; set; }
        public List<FinancingScheduleDataContract> NoteFinancingScheduleList { get; set; }
        public List<NotePeriodicOutputsDataContract> ListNotePeriodicOutputs { get; set; }
        public List<DailyGAAPBasisComponentsDataContract> ListDailyGAAPBasisComponents { get; set; }
        public List<ServicingLogTab> ListServicingLogTab { get; set; }
        public List<OutputNPVdata> ListOutputNPVdata { get; set; }
        public List<OutputAllTabData> ListOutputAllTabData { get; set; }
        public List<Transaction> ListTransaction { get; set; }
        public List<Transaction> ListCalcValues { get; set; }
        public List<TransactionEntry> ListCashflowTransactionEntry { get; set; }
        public ScenarioParameterDataContract DefaultScenarioParameters { get; set; }
        public List<ServicingOneTimeFeesTableDataContract> ServicingOneTimeFeesTableList { get; set; }
        public List<FinancingFeeScheduleDataContract> ListFinancingFeeSchedule { get; set; }
        public List<PIKInterestTab> ListPIKInterestTab { get; set; }
        public List<HolidayListDataContract> ListHoliday { get; set; }
        public List<PIKDistributionsDataContract> ListPIKDistribution { get; set; }
        public List<HistoricalAccrualDataContract> ListHistoricalAccrual { get; set; }
        public List<FeeSchedulesConfigDataContract> ListFeeSchedules { get; set; }
        public List<InterestCalculatorDataContract> ListInterestCalculator { get; set; }

        public int? pageIndex { get; set; }
        public int? pageSize { get; set; }
        public string modulename { get; set; }
        public string SaveWithoutCalc { get; set; }
        public int? NoofdaysrelPaymentDaterollnextpaymentcycle { get; set; }
        public DateTime? lastCalcDateTime { get; set; }
        public string ServicerID { get; set; }
        public Decimal? TotalCommitment { get; set; }

        public string CopyCRENoteId;

        public string CopyName;
        public string CopyDealID;
        public string CopyDealName;
        public string CalcJSONRequest;
        public int NumberofDaysinPast { get; set; }
        public int NumberofDaysinFuture { get; set; }
        public List<NotePeriodicOutputsDataContract> ListNotePeriodicOutput_Daily { get; set; }
        public List<NotePeriodicOutputsDataContract> ListNotePeriodicOutput_PVAndGaap { get; set; }
        public List<NotePeriodicOutputsDataContract> ListNotePeriodicOutput_SpreadAndLibor { get; set; }
        public List<FeeSchedulesConfigDataContract> ListFeeSchedulesConfiguration { get; set; }
        public List<FeeFunctionsConfigDataContract> ListFeeFunctions { get; set; }
        public int StatusCode { get; set; }
        //public int cntCritialException { get; set; }
        public int? Priority { get; set; }
        public int? LienPosition { get; set; }
        //public string LienPositionText { get; set; }
        public string FFLastUpdatedDate_String { get; set; }
        public string UpdatedByFF { get; set; }
        public string NoteRule { get; set; }
        public string FunctionName { get; set; }
        public string RequestType { get; set; }
        public int? ClientID { get; set; }
        public int? FundID { get; set; }
        public int? FinancingSourceID { get; set; }
        public int? DebtTypeID { get; set; }
        public int? BillingNotesID { get; set; }
        public int? CapStack { get; set; }
        public int? PoolID { get; set; }
        public Guid? AnalysisID { get; set; }
        // public Boolean? IsSingleNoteClac { get; set; }
        public string CalculatorstackTrace { get; set; }
        public Decimal? StubInterestRateOverride { get; set; }
        public int? ServicerNameID { get; set; }
        public string ServicerNameText { get; set; }
        public List<ServicerDropDateSetup> ListDropDateSetup { get; set; }
        public bool? EnableDebug { get; set; }
        public CalculatorDebugData CalculatorDebugData { get; set; }
        public int? InterestCalculationRuleForPaydownsAmort { get; set; }
        public String InterestCalculationRuleForPaydownsAmortText { get; set; }
        public List<ScheduleEffectiveDateDataContract> ListEffectiveDateCount { get; set; }
        public decimal? AdjustedTotalCommitment { get; set; }
        public decimal? AggregatedTotal { get; set; }
        public int? RoundingNote { get; set; }
        public string RoundingNoteText { get; set; }
        public decimal? StraightLineAmortOverride { get; set; }
        public int? RepaymentDayoftheMonth { get; set; }
        public int? UseRuletoDetermineAmortization { get; set; }
        public int? FutureFundingBillingCutoffDay { get; set; }
        public int? CurtailmentBillingCutoffDay { get; set; }

        public List<SizerDocumentsDataContract> SizerDoc { get; set; }
        public List<PayruleNoteAMSequenceDataContract> FundingRepaymentSequence { get; set; }

        public List<DailyInterestAccrualsDataContract> ListDailyInterestAccruals { get; set; }
        public List<PeriodicInterestRateUsed> ListPeriodicInterestRateUsed { get; set; }
        public List<NoteDataContract> NotePayRuleFundingParameters { get; set; }
        public string BaseCurrencyText { get; set; }
        public string StubInterestPaidonFutureAdvancesText { get; set; }
        public string DebtTypeText { get; set; }
        public string BillingNotesText { get; set; }
        public string CapStackText { get; set; }
        public string IsCapitalizedText { get; set; }
        public string LoanTypeText { get; set; }
        public string ReAmortizeMonthlyText { get; set; }
        public string ReAmortizeatPMTResetText { get; set; }
        public string StubPaidInArrearsText { get; set; }
        public string SettleWithAccrualFlagText { get; set; }
        public decimal? OriginalTotalCommitment { get; set; }
        public decimal? MKT_PRICE { get; set; }
        public string STRATEGY { get; set; }
        public int? StrategyCode { get; set; }
        public string StrategyName { get; set; }
        public int? EnableM61Calculations { get; set; }
        public List<NoteMarketPriceDataContract> ListNoteMarketPrice { get; set; }
        public Decimal? InitialRequiredEquity { get; set; }
        public Decimal? InitialAdditionalEquity { get; set; }
        public string OriginalCRENoteID { get; set; }
        public string OriginalNoteName { get; set; }
        //public int BatchIDVSTO { get; set; }
        public Decimal? OriginationFeePercentageRP { get; set; }
        public List<NoteCommitmentDataContract> ListNoteCommitment { get; set; }
        public Boolean? AllowYieldConfigData { get; set; }
        public string AllowDailyGAAPBasisComponents { get; set; }
        public List<YieldCalcInputDataContract> ListYieldCalcInput { get; set; }
        public Boolean? CalcByNewMaturitySetup { get; set; }
        public DataTable NoteMaturityList { get; set; }
        public int? MaturityMethodID { get; set; }
        public string MaturityGroupName { get; set; }
        public string MultipleNoteids { get; set; }
        public int? ImpactCommitmentCalc { get; set; }
        public Boolean? BalanceAware { get; set; }

        public DateTime? FirstIndexDeterminationDateOverride { get; set; }

        public IndexDataContract ListIndices { get; set; }

        public int? AccountingClose { get; set; }
        public string AccountingCloseText { get; set; }

        public List<ServicingWatchListCalcDataContract> ListServicingWatchProjected { get; set; }

        public List<TagMasterXIRRDataContract> ListSelectedXIRRTags { get; set; }
        public Decimal? UPBAtForeclosure { get; set; }

        public int? FullIOTermFlag { get; set; }
        public string FullIOTermFlagText { get; set; }
        public Decimal? NetCapitalInvested { get; set; }
        public int? NoteType { get; set; }
        public DateTime? MaturityUsedInCalc;
        public int? MaturityAdjMonthsOverride;
        public int? InterestOnlyNote { get; set; }
        public int? ConstantPaymentMethod { get; set; }
        public int? PaymentDateAccrualPeriod { get; set; }
        public string PaymentDateAccrualPeriodText { get; set;}
    }
    public class DownloadCashFlowDataContract
    {
        public string NoteId { get; set; }
        public string DealID { get; set; }
        public string AnalysisID { get; set; }
        // public string PortfolioId { get; set; }
        public string MutipleNoteId { get; set; }
        public int CountOnDropDownFilter { get; set; }
        public int CountOnGridFilter { get; set; }
        public string PortfolioMasterGuid { get; set; }
        public string TransactionCategoryName { get; set; }
        public string Pagename { get; set; }


    }
    public class ScheduleEffectiveDateDataContract
    {
        public Guid NoteId { get; set; }
        public int EffectiveDateCount { get; set; }
        public string ScheduleName { get; set; }
    }

    public class UserPreferenceDataContract
    {
        public string userid { get; set; }
        public string ParentModuleName { get; set; }
        public string ModuleType { get; set; }
        public string ModuleName { get; set; }
        public string HTMLTagID { get; set; }
        public bool IsActive { get; set; }
        public string UpdatedBy { get; set; }
    }

    public class NoteSheet
    {
        public int SrNo { get; set; }
        public string Note_ID { get; set; }
        public string Note_Name { get; set; }
        public string Status { get; set; }
        public string Exception { get; set; }
    }
    

}