using System;
using System.Collections.Generic;
using System.Data;

namespace CRES.DataContract
{
    public class DealDataContract
    {
        public System.Guid DealID { get; set; }
        public string DealName { get; set; }
        public string NoteId { get; set; }
        public string NoteHref { get; set; }
        public int? DealType { get; set; }
        public int BatchID { get; set; }
        public int? LoanProgram { get; set; }
        public int? LoanPurpose { get; set; }
        public string DealTypeText { get; set; }
        public string LoanProgramText { get; set; }
        public string LoanPurposeText { get; set; }
        public int? Statusid { get; set; }
        public string StatusText { get; set; }
        public DateTime? AppReceived { get; set; }
        public DateTime? EstClosingDate { get; set; }
        public int? BorrowerRequest { get; set; }
        public string BorrowerRequestText { get; set; }
        public decimal? RecommendedLoan { get; set; }
        public decimal? TotalFutureFunding { get; set; }
        public int? Source { get; set; }
        public string SourceText { get; set; }
        public string BrokerageFirm { get; set; }
        public string BrokerageContact { get; set; }
        public string Sponsor { get; set; }
        public string Principal { get; set; }
        public decimal? NetWorth { get; set; }
        public decimal? Liquidity { get; set; }
        public string ClientDealID { get; set; }
        public string CREDealID { get; set; }
        public string LinkedDealID { get; set; }
        public decimal? TotalCommitment { get; set; }
        public decimal? AdjustedTotalCommitment { get; set; }
        public decimal? AggregatedTotal { get; set; }
        public string AssetManagerComment { get; set; }
        public string AssetManager { get; set; }
        public string AnalysisID { get; set; }
        public Guid? AssetManagerID { get; set; }
        public Guid? AMTeamLeadUserID { get; set; }
        public Guid? AMSecondUserID { get; set; }
        public string DealCity { get; set; }
        public string DealState { get; set; }
        public string DealPropertyType { get; set; }
        public DateTime? FullyExtMaturityDate { get; set; }
        public int? AllowSizerUpload { get; set; }
        public string AllowSizerUploadText { get; set; }
        public string GeoLocation { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? UnderwritingStatusid { get; set; }
        public string UnderwritingStatusidText { get; set; }
        public DateTime? LastUpdatedFF { get; set; }
        public string LastUpdatedFF_String { get; set; }
        public string LastUpdatedByFF { get; set; }
        public string DealComment { get; set; }
        public int? ServicerDropDate { get; set; }
        public int? ServicereDayAjustement { get; set; }
        public List<PayruleNoteDetailFundingDataContract> PayruleNoteDetailFundingList { get; set; }
        public List<AutoSpreadRuleDataContract> AutoSpreadRuleList { get; set; }
        public List<PayruleNoteAMSequenceDataContract> PayruleNoteAMSequenceList { get; set; }
        public List<PayruleDealFundingDataContract> PayruleDealFundingList { get; set; }
        public List<SizerScenarioDataContract> ScenarioList = new List<SizerScenarioDataContract>();
        public List<PayruleTargetNoteFundingScheduleDataContract> PayruleTargetNoteFundingScheduleList { get; set; }
        public List<PayruleSetupDataContract> PayruleSetupList { get; set; }
        public List<NoteDataContract> notelist { get; set; }
        public List<HolidayListDataContract> ListHoliday { get; set; }
        public int StatusCode { get; set; }
        public string NewNoteId { get; set; }
        public string DealRule { get; set; }
        public string BoxDocumentLink { get; set; }
        public bool ShowUseRuleN { get; set; }
        public string DealGroupID { get; set; }
        public Boolean? EnableAutoSpread { get; set; }
        public Boolean? EnableM61Calculator { get; set; }
        public AutoSpreadRuleDataContract AutoSpreadRule { get; set; }
        public List<PayruleDealFundingDataContract> PayruleDeletedDealFundingList { get; set; }
        public List<PayruleDealFundingDataContract> DeletedDealFundingList { get; set; }
        public List<NoteEndingBalanceDataContract> ListNoteEndingBalance { get; set; }
        public List<PayruleTargetNoteFundingScheduleDataContract> Listnotefunding { get; set; }
        public string envname { get; set; }
        public string CopyDealID { get; set; }
        public string CopyDealName { get; set; }
        public string PayruleGenerationExceptionMessage { get; set; }
        public string PayruleGenerationStackTrace { get; set; }
        public string BaseCurrencyName { get; set; }
        public Decimal Endingbalance { get; set; }
        public DateTime MaxWireConfirmRecord { get; set; }
        public DateTime maxWiredDatecalculated { get; set; }

        public bool EnableAutospreadUseRuleN { get; set; }
        public bool? ApplyNoteLevelPaydowns { get; set; }
        public List<PayruleTargetNoteFundingScheduleDataContract> PayruleDeletedTargetNoteFundingScheduleList { get; set; }
        public List<CalculatedNoteRepaymentDataContract> ListCalculatedNoteRepayment { get; set; }
        public List<AutoRepaymentNoteBalancesDataContract> ListNoteRepaymentBalances { get; set; }

        //public int? AmortizationMethod { get; set; }
        //public string AmortizationMethodText { get; set; }
        //public int? ReduceAmortizationForCurtailments { get; set; }
        //public string ReduceAmortizationForCurtailmentsText { get; set; }
        //public int? BusinessDayAdjustmentForAmort { get; set; }
        //public string BusinessDayAdjustmentForAmortText { get; set; }
        //public int? NoteDistributionMethod { get; set; }
        //public string NoteDistributionMethodText { get; set; }

        //public decimal? PeriodicStraightLineAmortOverride { get; set; }
        //public decimal? FixedPeriodicPayment { get; set; }

        //public List<DealAmortizationDataContract> DealAmortizationList { get; set; }

        //public int? Flag_BasicDealSave { get; set; }
        //public int? Flag_DealFundingSave { get; set; }
        //public int? Flag_DealAmortSave { get; set; }
        //public int? Flag_NoteSaveFromDealDetail { get; set; }

        //public List<NoteListDealAmortDataContarct> NoteListForDealAmort { get; set; }

        //   public List<PayruleNoteAMSequenceDataContract> AmortSequenceList { get; set; }

        //public string DealAmortGenerationExceptionMessage { get; set; }
        public AmortDataContract amort { get; set; }
        public bool Flag_DealFundingSave { get; set; }
        public bool Flag_NoteSaveFromDealDetail { get; set; }
        public bool Flag_DealAmortSave { get; set; }
        public string actiontype { get; set; }
        public string output { get; set; }
        public string ScenarioText { get; set; }
        public DateTime? FirstPaymentDate { get; set; }
        public DateTime? max_ExtensionMat { get; set; }
        public DateTime? LastWireConfirmDate_db { get; set; }
        public decimal? EquityAmount { get; set; }
        //
        public decimal? RemainingAmount { get; set; }


        public List<AdjustedTotalCommitmentDataContract> Listadjustedtotlacommitment { get; set; }
        public List<AdjustedTotalCommitmentDataContract> DeleteAdjustedTotalCommitment { get; set; }
        public DateTime? AmortStartDate { get; set; }
        public List<string> Listnewnoteids { get; set; }
        public string IsPayruleClicked { get; set; }
        public string OriginalCREDealID { get; set; }
        public string OriginalDealName { get; set; }
        public DateTime? KnownFullPayoffDate { get; set; }
        public DateTime? ExpectedFullRepaymentDate { get; set; }
        public DateTime? AutoPrepayEffectiveDate { get; set; }
        public DateTime? EarliestPossibleRepaymentDate { get; set; }
        public DateTime? LatestPossibleRepaymentDate { get; set; }
        public int? Blockoutperiod { get; set; }
        public int? PossibleRepaymentdayofthemonth { get; set; }
        public int? Repaymentallocationfrequency { get; set; }
        public DateTime? RepaymentStartDate { get; set; }
        public Boolean? EnableAutospreadRepayments { get; set; }
        public Boolean? EnableAutospreadRepayments_db { get; set; }
        public Boolean? AutoUpdateFromUnderwriting { get; set; }
        public List<ProjectedPayoffDataContract> ListProjectedPayoff { get; set; }
        public List<AutoRepaymentBalancesDataContract> ListAutoRepaymentBalances { get; set; }
        public string RepaymentAutoSpreadMethodText { get; set; }
        public int? RepaymentAutoSpreadMethodID { get; set; }
        public int? MinAccrualFrequency { get; set; }
        public DateTime? maxMaturityDate { get; set; }
        public List<CummulativeProbabilityDataContract> ListCummulativeProbability = new List<CummulativeProbabilityDataContract>();
        public List<CalculatedAutoRepaymentDataContract> ListCalculatedAutoRepayment { get; set; }
        public Boolean? AllowFundingDevDataFlag { get; set; }
        public Boolean? AllowFFSaveJsonIntoBlob { get; set; }
        public DataTable ListFeeInvoice { get; set; }
        public Boolean? DealLevelMaturity { get; set; }
        public DataTable MaturityList { get; set; }

        public DataTable ReserveAccountList { get; set; }
        public bool? IsREODeal { get; set; }
        public bool? BalanceAware { get; set; }

        public DataTable ReserveScheduleList { get; set; }
        public DateTime? RepayExpectedMaturityDate { get; set; }
        //RepaymentAutoSpreadMethodIDText
        public string RepaymentAutoSpreadMethodIDText { get; set; }

        public PrepayDataContract PrepaySchedule { get; set; }

        public int? PropertyTypeID { get; set; }
        public int? LoanStatusID { get; set; }

        public DateTime? PrePayDate { get; set; }
        public decimal? ICMFullyFundedEquity { get; set; }
        public decimal? EquityatClosing { get; set; }
    }
    public class PrepayDataContract
    {
        public int PrepayScheduleId { get; set; }

        public string DealID { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public DateTime? CalcThru { get; set; }

        public DateTime? PrepayDate { get; set; }
        public int? PrepaymentMethod { get; set; }

        public string PrepaymentMethodText { get; set; }
        public int? BaseAmountType { get; set; }

        public string BaseAmountTypeText { get; set; }
        public int? SpreadCalcMethod { get; set; }

        public string SpreadCalcMethodText { get; set; }
        public bool? GreaterOfSMOrBaseAmtTimeSpread { get; set; }
        public bool? HasNoteLevelSMSchedule { get; set; }
        public bool? Includefeesincredits { get; set; }
        public decimal MinimumMultipleDue { get; set; }
        public DateTime? OpenPaymentDate { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

        public string TableName { get; set; }
        public string AnalysisID { get; set; }
        public List<PrepayAdjustmentDataContract> PrepayAdjustmentList { get; set; }
        public List<SpreadMaintenanceScheduleDataContract> SpreadMaintenanceScheduleList { get; set; }
        public List<MinMultScheduleDataContract> MinMultScheduleList { get; set; }
        public List<FeeCreditsDataContract> FeeCreditsList { get; set; }

        public List<PrepayAdjustmentDataContract> PrepayAdjustment { get; set; }
        public List<SpreadMaintenanceScheduleDataContract> SpreadMaintenanceSchedule { get; set; }
        public List<SpreadMaintenanceScheduleDataContract> SpreadMaintenanceScheduleDeallevel { get; set; }
        public List<MinMultScheduleDataContract> MinMultSchedule { get; set; }
        public List<FeeCreditsDataContract> FeeCredits { get; set; }
    }
}
public class PrepayAdjustmentDataContract
{
    public int PrepayAdjustmentId { get; set; }
    public DateTime? Date { get; set; }
    public decimal? PrepayAdjAmt { get; set; }
    public string Comment { get; set; }
}
public class SpreadMaintenanceScheduleDataContract
{
    public int SpreadMaintenanceScheduleId { get; set; }
    public DateTime? SpreadDate { get; set; }
    public string NoteId { get; set; }
    public string CRENoteID { get; set; }
    public decimal? Spread { get; set; }
    public bool? CalcAfterPayoff { get; set; }
}
public class MinMultScheduleDataContract
{
    public int MinMultScheduleID { get; set; }
    public DateTime? MiniSpreadDate { get; set; }
    public decimal? MinMultAmount { get; set; }
}
public class FeeCreditsDataContract
{
    public int FeeCreditsID { get; set; }
    public bool? UseActualFees { get; set; }
    public decimal? FeeCreditOverride { get; set; }
    public int? FeeTypeNameText { get; set; }


}
public class PrepayProjectionDataContract
{
    public int DealPrepayProjectionID { get; set; }
    public string DealID { get; set; }
    public DateTime? PrepayDate { get; set; }
    public decimal? PrepayPremium_RemainingSpread { get; set; }
    public decimal? UPB { get; set; }
    public DateTime? OpenPrepaymentDate { get; set; }
    public decimal? TotalPayoff { get; set; }
    public DateTime? prepaylastUpdatedFF { get; set; }
    public string prepaylastUpdatedByFF { get; set; }
}

public class PrepayAllocationsDataContract
{
    public int DealPrepayAllocationsID { get; set; }
    public string DealID { get; set; }
    public string NoteID { get; set; }
    public string CRENoteID { get; set; }
    public DateTime? PrepayDate { get; set; }
    public decimal? MinmultDue { get; set; }
}

public class PropertyTypeDataContract
{
    public int? PropertyTypeID { get; set; }
    public string PropertyTypeMajorDesc { get; set; }
}

public class LoanStatusDataContract
{
    public int? LoanStatusID { get; set; }
    public string LoanStatusDesc { get; set; }
}

public class PrepayCalcStatusDataContract
{
    public string Status { get; set; }

    public string ErrorMessage { get; set; }
    public string Message { get; set; }
    public string Message_StackTrace { get; set; }
    public string RequestID { get; set; }
}

public class EquitySummaryDataContract
{
    public string Dealid { get; set; }
    public string Type { get; set; }
    public decimal ExpectedEquity { get; set; }
    public decimal EquityContributedToDate { get; set; }
    public decimal RemainingEquity { get; set; }
    public decimal Per_ContributedToDate { get; set; }
}