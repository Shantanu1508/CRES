using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class DealDataContract
    {
        public string DealAccountID { get; set; }
        public System.Guid DealID { get; set; }
        public string DealName { get; set; }
        public string CRENoteID { get; set; }
        public string NoteId { get; set; }
        public string NoteName { get; set; }
        public string NoteHref { get; set; }
        public int? DealType { get; set; }
        public int BatchID { get; set; }
        public int? LoanProgram { get; set; }
        public int? AllowGaapComponentInCashflowDownload { get; set; }
        public string AllowGaapComponentInCashflowDownloadText { get; set; }
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
        public string ScenarioIdPrepay { get; set; }
        
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
        public string currentUserName { get; set; }
        public string currentUserID { get; set; }
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

        public List<MaturityScenariosDataContract> ListMaturityScenrio { get; set; }
        public string SendEmailAfterCalc { get; set; }
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
        public DataTable dtPayoffStatementFees { get; set; }

        public Boolean? DealLevelMaturity { get; set; }
        public DataTable MaturityList { get; set; }
        public List<string> Listnoteid { get; set; }

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
        public int? CalcEngineType { get; set; }
        public string CalcEngineTypeText { get; set; }

        public DateTime? PrePayDate { get; set; }
        public decimal? ICMFullyFundedEquity { get; set; }
        public decimal? EquityatClosing { get; set; }
        public decimal? SumTotalRepayments { get; set; }
        public decimal? TotalRepaymentSequences { get; set; }
        public decimal? RepayTobeAdjusted { get; set; }
        public DateTime? LastAccountingclosedate { get; set; }

        //ServicingWatchlist   
        public string WatchlistStatus { get; set; }
        public Boolean? IsServicingWatchlisttabClicked { get; set; }
        public List<ServicingWatchlistDataContract> ServicingWatchlistLegal { get; set; }
        public List<ServicingWatchlistDataContract> ServicingWatchlistAccounting { get; set; }
        public List<ServicingWatchlistDataContract> ServicingPotentialImpairment { get; set; }

        public DataTable ServicingPotentialImpairmentList { get; set; }
        public DataTable DeleteServicingPotentialImpairment { get; set; }


        //for 
        public List<PayruleDealFundingDataContract> PayruleDealFundingList_AdjustmentType { get; set; }
        public List<PayruleTargetNoteFundingScheduleDataContract> PayruleTargetNoteFundingScheduleList_AdjustmentType { get; set; }

        public List<PayruleDealFundingDataContract> DealFundingListAdjustmentTypeAutoSpread { get; set; }
        public List<PayruleTargetNoteFundingScheduleDataContract> NoteFundingScheduleListAdjustmentTypeAutoSpread { get; set; }


        //Principal Writeoff

        public List<PayruleDealFundingDataContract> PayruleDealFundingList_Pwriteoff { get; set; }
        public List<PayruleTargetNoteFundingScheduleDataContract> PayruleTargetNoteFundingScheduleList_Pwriteoff { get; set; }

        //Liability
        public bool isLiabilityTabCLicked { get; set; }

        public List<LiabilityNoteDataContract> ListDealLiability { get; set; }
        public List<LiabilityNoteDataContract> ListDealLiabilityDupliateCheck { get; set; }

        public List<LiabilityFundingScheduleDataContract> ListLiabilityFundingSchedule { get; set; }
        public List<LiabilityNoteAssetMapping> ListLiabilityNoteAssetMapping { get; set; }

        public List<TagMasterXIRRDataContract> ListSelectedXIRRTags { get; set; }
        public decimal? XIRRValue { get; set; }

        public List<AutoDistributeWriteoffDataContract> AutoDistributeWriteoffList { get; set; }
        public DataTable XIRROverride { get; set; }
        public bool? EnableAutoDistributePrincipalWriteoff { get; set; }
        public List<PayruleDealFundingDataContract> ListRevolverDealFunding { get; set; }
        public List<PayruleTargetNoteFundingScheduleDataContract> ListRevolverNoteFunding { get; set; }
        public List<DealRelationshipDataContract> DealRelationshipList { get; set; }

        public int? PrepaymentGroupSize { get; set; }
        public int? PrepaymentAllocationMethod { get; set; }
        public DataTable dtPrepaymentGroup { get; set; }
        public DataTable dtPrepaymentNote { get; set; }
        public DataTable dtPrepaymentNoteAlloc { get; set; }
        public string Bookmark { get; set; }
        public int? MaturityAdjMonthsOverride { get; set; }
        public bool? ExcludeDealFromLiability { get; set; }
        public int? LiabilitySource { get; set; }
        public string LiabilitySourceText { get; set; }

        public string InternalRefiText { get; set; }
        public string PortfolioLoanText { get; set; }
        public string AssigningLoanToTakeoutLenderText { get; set; }
        public string NettingofReservesEscrowsText { get; set; }
        public int? InternalRefi { get; set; }
        public int? PortfolioLoan { get; set; }
        public int? AssigningLoanToTakeoutLender { get; set; }
        public int? NettingofReservesEscrows { get; set; }

        public string isPipeline { get; set; }
        public string DealStackTrace { get; set; }
        public string DealErrorMessage { get; set; }
        
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
        public decimal? MinimumMultipleDue { get; set; }
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

    public class DealDashDataContract
    {
        public System.Guid DealID { get; set; }
        public string CREDealID { get; set; }
        public string DealName { get; set; }
        public string AssetManager { get; set; }
        public decimal? TotalCommitment { get; set; }
        public decimal? AdjustedTotalCommitment { get; set; }
        public decimal? XIRRValue { get; set; }
        public string FileName { get; set; }
        public decimal? FullyFundedEquity { get; set; }
        public decimal? EquityContributedToDate { get; set; }
        public decimal? BorrowerEquity { get; set; }
        public DateTime? NextFundingDate { get; set; }
        public DateTime? NextPaydownDate { get; set; }
        public string UseRules { get; set; }
        public string Banker { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public decimal? FundedPercentage { get; set; }

    }


    public class PrepayAdjustmentDataContract
    {
        public int PrepayAdjustmentId { get; set; }
        public DateTime? Date { get; set; }
        public decimal? PrepayAdjAmt { get; set; }
        public string Comment { get; set; }
        public int? IsDeleted { get; set; }
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
        public int ? IsDeleted { get; set; }
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
        public int? PrepaymentMethodID { get; set; }
        public string PrepaymentMethodText { get; set; }
        public DateTime? UpdatedDate { get; set; }
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

    public class LiabilityNoteAssetMapping
    {
        public string LiabilityNoteId { get; set; }
        public string DealAccountId { get; set; }
        public string LiabilityNoteAccountId { get; set; }
        public string AssetAccountId { get; set; }
    }

    public class DealRelationshipDataContract
    {
        public Guid? DealID { get; set; }
        public string LinkedDealID { get; set; }
        public string RelationshipText { get; set; }
        public int? RelationshipID { get; set; }
    }

    public class ReserveAccountSyncDataContract
    {
        public string DealID { get; set; }

    }

}