using System;
using System.Collections.Generic;

namespace CRES.DataContract
{
    public class NoteCalculatorDataContract
    {
        public string NoteID { get; set; }
        public string AccountID { get; set; }
        public string DealID { get; set; }
        public string CRENoteID { get; set; }
        public int? ClientNoteID { get; set; }
        public string Comments { get; set; }

        public DateTime? InitialInterestAccrualEndDate { get; set; }
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
        public int? RateIndexResetFreq { get; set; }
        public DateTime? FirstRateIndexResetDate { get; set; }
        public int? LoanPurchase { get; set; }
        public int? AmortIntCalcDayCount { get; set; }
        public int? StubPaidinAdvanceYN { get; set; }
        public int? FullPeriodInterestDueatMaturity { get; set; }
        public int? ProspectiveAccountingMode { get; set; }
        public int? IsCapitalized { get; set; }
        public int? SelectedMaturityDateScenario { get; set; }
        public DateTime? SelectedMaturityDate { get; set; }
        public DateTime? InitialMaturityDate { get; set; }
        public DateTime? ExpectedMaturityDate { get; set; }
        public DateTime? OpenPrepaymentDate { get; set; }
        public string CashflowEngineID { get; set; }
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
        public Decimal? ModelFinancingDrawsForFutureFundings { get; set; }
        public int? NumberOfBusinessDaysLagForFinancingDraw { get; set; }
        public Guid? FinancingFacilityID { get; set; }
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

        public List<PIKSchedule> NotePIKScheduleList { get; set; }
        public List<RateSpreadSchedule> RateSpreadScheduleList { get; set; }
        public List<MaturityScenariosDataContract> MaturityScenariosList { get; set; }
        public List<StrippingScheduleDataContract> NoteStrippingList { get; set; }
        public List<DefaultScheduleDataContract> NoteDefaultScheduleList { get; set; }
        public List<PrepayAndAdditionalFeeScheduleDataContract> NotePrepayAndAdditionalFeeScheduleList { get; set; }
        public List<EffectiveDateList> EffectiveDateList { get; set; }
        public List<FutureFundingScheduleTab> ListFutureFundingScheduleTab { get; set; }
        public List<PIKfromPIKSourceNoteTab> ListPIKfromPIKSourceNoteTab { get; set; }
        public List<FeeCouponStripReceivableTab> ListFeeCouponStripReceivable { get; set; }
        public List<LiborScheduleTab> ListLiborScheduleTab { get; set; }
        public List<FixedAmortScheduleTab> ListFixedAmortScheduleTab { get; set; }
        public List<NoteServicingFeeScheduleDataContract> NoteServicingFeeScheduleList { get; set; }
        public List<FinancingScheduleDataContract> NoteFinancingScheduleList { get; set; }


        public List<NotePeriodicOutputsDataContract> ListNotePeriodicOutputs { get; set; }




        public List<ServicingLogTab> ListServicingLogTab { get; set; }








        public int? pageIndex { get; set; }
        public int? pageSize { get; set; }
        public string modulename { get; set; }

        public string SaveWithoutCalc { get; set; }

        public int? NoofdaysrelPaymentDaterollnextpaymentcycle { get; set; }

    }
}
