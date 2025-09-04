using CRES.DataContract;
using CRES.TestAutoMation.Utility;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;

namespace CRES.TestAutoMation
{
    public static class BaseConfiguration
    {
        public static readonly string Env = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");

        private static readonly string CurrentDirectory = Directory.GetParent(Directory.GetCurrentDirectory()).Parent.Parent.FullName;
        private static readonly string CurrentDirectory1 = Directory.GetParent(Directory.GetCurrentDirectory()).Parent.Parent.Parent.FullName;

        /// <summary>
        /// Getting appsettings.json file.
        /// </summary>
        public static readonly IConfigurationRoot Builder = new ConfigurationBuilder()
            .AddJsonFile(Path.Combine(Directory.GetParent(Directory.GetCurrentDirectory()).Parent.Parent.FullName, "appsettings.json"))
            .Build();


        public static bool UseCurrentDirectory
        {
            get
            {
                string setting = null;


                setting = Builder["appSettings:UseCurrentDirectory"];

                if (string.IsNullOrEmpty(setting))
                {
                    return false;
                }

                if (setting.ToLower(CultureInfo.CurrentCulture).Equals("true"))
                {
                    return true;
                }

                return false;
            }
        }
        public static bool UseCurrentDirectory1
        {
            get
            {
                string setting = null;


                setting = Builder["appSettings:UseCurrentDirectory"];

                if (string.IsNullOrEmpty(setting))
                {
                    return false;
                }

                if (setting.ToLower(CultureInfo.CurrentCulture).Equals("true"))
                {
                    return true;
                }

                return false;
            }
        }
        public static string GetEnvironment()
        {

            string setting = "";
            setting = Builder["appSettings:ExuecutionEnvironment"];
            return setting;

        }

        public static string GetNewQAUrl()
        {

            string setting = "";
            setting = Builder["appSettings:NewQAUrl"];
            return setting;

        }

        public static string GetQAUrl()
        {

            string setting = "";
            setting = Builder["appSettings:QAUrl"];
            return setting;

        }
        public static string GetNgUrl()
        {

            string setting = "";
            setting = Builder["appSettings:NgUrl"];
            return setting;

        }

        public static string GetNewQaUsername()
        {

            string setting = "";
            setting = Builder["appSettings:NewQaUsername"];
            return setting;

        }

        public static string GetNewQaPassword()
        {

            string setting = "";
            setting = Builder["appSettings:NewQaPassword"];
            return setting;

        }

        public static string GetQaUsername()
        {

            string setting = "";
            setting = Builder["appSettings:QaUsername"];
            return setting;

        }

        public static string GetQaPassword()
        {

            string setting = "";
            setting = Builder["appSettings:QaPassword"];
            return setting;

        }

        public static string GetIntUrl()
        {
            string setting = "";
            setting = Builder["appSettings:IntUrl"];
            return setting;
        }

        public static string GetIntUsername()
        {
            string setting = "";
            setting = Builder["appSettings:IntUsername"];
            return setting;

        }

        public static string GetIntPassword()
        {
            string setting = "";
            setting = Builder["appSettings:IntPassword"];
            return setting;

        }

        public static string GetDevUrl()
        {
            string setting = "";
            setting = Builder["appSettings:DevUrl"];
            return setting;
        }

        public static string GetDevUsername()
        {
            string setting = "";
            setting = Builder["appSettings:DevUsername"];
            return setting;

        }

        public static string GetDevPassword()
        {
            string setting = "";
            setting = Builder["appSettings:DevPassword"];
            return setting;

        }

        public static string GetStagingUrl()
        {
            string setting = "";
            setting = Builder["appSettings:StagingUrl"];
            return setting;
        }
        public static string GetDemoUrl()
        {  //code
            string setting = "";
            setting = Builder["appSettings:DemoUrl"];
            return setting;
        }
        public static string GetStagingUsername()
        {
            string setting = "";
            setting = Builder["appSettings:StagingUsername"];
            return setting;

        }

        public static string GetStagingPassword()
        {
            string setting = "";
            setting = Builder["appSettings:StagingPassword"];
            return setting;

        }
        public static string GetURL()
        {
            string setting = "";
            setting = Builder["appSettings:url"];
            return setting;

        }
        public static string GetAcoreUsername()
        {
            string setting = "";
            setting = Builder["appSettings:AcoreUsername"];
            return setting;

        }
        public static string GetAcorePassword()
        {
            string setting = "";
            setting = Builder["appSettings:AcorePassword"];
            return setting;

        }
        public static string GetLoginUrl()
        {
            string setting = "";
            setting = Builder["appSettings:LoginUrl"];
            return setting;

        }
        public static string GetDemoPassword()
        {
            string setting = "";
            setting = Builder["appSettings:DemoPassword"];
            return setting;

        }
        public static string GetDemoUsername()
        {
            string setting = "";
            setting = Builder["appSettings:DemoUsername"];
            return setting;

        }

        public static string GetAcoreUrl()
        {
            string setting = "";
            setting = Builder["appSettings:AcoreUrl"];
            return setting;
        }


        public static string GetDashboardUrl()
        {
            string setting = "";
            setting = Builder["appSettings:DashboardUrl"];
            return setting;

        }
        public static string GetLoginUrlNew()
        {
            string setting = "";
            setting = Builder["appSettings:LoginUrlNew"];
            return setting;

        }

        public static string DealFunding()
        {
            string setting = "";
            setting = Builder["appSettings:DealFundingUrl"];
            return setting;

        }

        public static string NoteFunding()
        {

            string setting = "";
            setting = Builder["appSettings:NoteFundingUrl"];
            return setting;

        }

        public static string getusername()
        {

            string setting = "";
            setting = Builder["appSettings:username"];

            return setting;

        }
        public static string TestAllDealForAmort()
        {
            string setting = "";
            setting = Builder["DealPageSettings:TestAllDealForAmort"];
            return setting;
        }
        public static string TestAllDealForGenerateFunding()
        {
            string setting = "";
            setting = Builder["DealPageSettings:TestAllDealForGenerateFunding"];
            return setting;
        }

        public static string TestAllNoteForSaving()
        {
            string setting = "";
            setting = Builder["NotePageSettings:TestAllNoteForSaving"];
            return setting;
        }


        public static string HeadlessDriver()
        {
            string headless = "";
            headless = Builder["appSettings:HeadlessDriver"];
            return headless;
        }

        public static int BrowserCount()
        {
            int browserCount = 1;
            browserCount = Convert.ToInt16(Builder["browserSettings:BrowserCount"]);
            return browserCount;
        }

        public static string Browser()
        {
            string browser = "";
            browser = Builder["appSettings:Browser"];
            return browser;
        }


        public static string getpassword()
        {
            string setting = "";
            setting = Builder["appSettings:password"];
            return setting;
        }
        public static string LoginUrl()
        {
            string setting = "";
            setting = Builder["appSettings:LoginUrl"];
            return setting;
        }

        public static bool AllowSave()
        {
            string setting = "";
            setting = Builder["DealPageSettings:SaveDeal"];
            if (setting.ToLower() == "yes")
            {
                return true;
            }
            else
            {
                return false;
            }

        }
        
        public static string SendValidationReportEmail()
        {
            string setting = "";
            setting = Builder["appSettings:SendValidationReportEmail"];
            
                return setting;          

        }

        public static bool SendProgressEmail()
        {
            string setting = "";
            setting = Builder["appSettings:SendProgressEmail"];
            if (setting.ToLower() == "yes")
            {
                return true;
            }
            else
            {
                return false;
            }

        }

        public static int SendProgressEmailDealCounter()
        {
            string setting = "";
            setting = Builder["appSettings:SendProgressEmailDealCounter"];
            return int.Parse(setting);
        }

        public static string ExcelDealIDTab()
        {
            string tab = "";
            tab = Builder["appSettings:ExcelDealIDTab"];
            return tab;
        }
        public static string ExcelNoteIDTab()
        {
            string tab = "";
            tab = Builder["appSettings:ExcelNoteIDTab"];
            return tab;
        }     

        public static string DeafultLoggingFile()
        {
            string setting = "";
            setting = Builder["appSettings:DeafultLoggingFile"];
            return setting;
        }

        public static string QAUrl()
        {
            string setting = "";
            setting = Builder["appSettings:QAUrl"];
            return setting;
        }

        public static string IntUrl()
        {
            string setting = "";
            setting = Builder["appSettings:IntUrl"];
            return setting;
        }

        public static string MyAccountUrl()
        {
            string setting = "";
            setting = Builder["appSettings:MyAccountUrl"];
            return setting;
        }
        public static string UserManagementUrl()
        {
            string setting = "";
            setting = Builder["appSettings:UserManagementUrl"];
            return setting;
        }

        public static string ScenarioUrl()
        {
            string setting = "";
            setting = Builder["appSettings:ScenarioUrl"];
            return setting;
        }
        public static string IndexPageUrl()
        {
            string setting = "";
            setting = Builder["appSettings:IndexPageUrl"];
            return setting;
        }

        public static string FeeConfigUrl()
        {
            string setting = "";
            setting = Builder["appSettings:FeeConfigUrl"];
            return setting;
        }


        public static string DynamicPortfolioUrl()
        {
            string setting = "";
            setting = Builder["appSettings:DynamicPortfolioUrl"];
            return setting;
        }

        public static string TranscatioReconUrl()
        {
            string setting = "";
            setting = Builder["appSettings:TranscatioReconUrl"];
            return setting;
        }

        public static string IntTranscatioReconUrl()
        {
            string setting = "";
            setting = Builder["appSettings:IntTranscatioReconUrl"];
            return setting;
        }

        public static string TransactionauditURL()
        {
            string setting = "";
            setting = Builder["appSettings:TransactionauditURL"];
            return setting;
        }

        public static string IntTransactionauditURL()
        {
            string setting = "";
            setting = Builder["appSettings:IntTransactionauditURL"];
            return setting;
        }

        public static string accountingcloseUrl()
        {
            string setting = "";
            setting = Builder["appSettings:accountingcloseUrl"];
            return setting;
        }

        public static string CalculationManagerUrl()
        {
            string setting = "";
            setting = Builder["appSettings:CalculationManagerUrl"];
            return setting;
        }

        public static string IntCalculationManagerUrl()
        {
            string setting = "";
            setting = Builder["appSettings:IntCalculationManagerUrl"];
            return setting;
        }
        public static string GenerateAutomationUrl()
        {
            string setting = "";
            setting = Builder["appSettings:GenerateAutomationUrl"];
            return setting;
        }


        public static string ReportUrl()
        {
            string setting = "";
            setting = Builder["appSettings:ReportUrl"];
            return setting;
        }

        public static string ReportHistoryUrl()
        {
            string setting = "";
            setting = Builder["appSettings:ReportHistoryUrl"];
            return setting;
        }

        public static string TagsUrl()
        {
            string setting = "";
            setting = Builder["appSettings:TagsUrl"];
            return setting;
        }
        public static string WorkFlowUrl()
        {
            string setting = "";
            setting = Builder["appSettings:WorkFlowUrl"];
            return setting;
        }
        public static string DevDashboard()
        {
            string setting = "";
            setting = Builder["appSettings:TaskUrl"];
            return setting;
        }

        public static string HelpPageUrl()
        {
            string setting = "";
            setting = Builder["appSettings:HelpPageUrl"];
            return setting;
        }

        public static string DataManagementUrl()
        {
            string setting = "";
            setting = Builder["appSettings:DataManagementUrl"];
            return setting;
        }

        public static string NotificationSubsUrl()
        {
            string setting = "";
            setting = Builder["appSettings:NotificationSubsUrl"];
            return setting;
        }

        public static string AcoreUrl()
        {
            string setting = "";
            setting = Builder["appSettings:AcoreUrl"];
            return setting;
        }

        public static string TakeScreenshot()
        {
            string setting = "";
            setting = Builder["appSettings:TakeScreenshot"];
            return setting;
        }
        public static string EmailTO()
        {
            string setting = "";
            setting = Builder["appSettings:EmailTO"];
            return setting;
        }

        public static string Host
        {

            get
            {
                string setting = "";
                setting = Builder["Application:Host"];
                return setting;

            }

        }
        public static string UserName
        {
            get
            {
                string setting = "";
                setting = Builder["Application:UserName"];
                return setting;

            }

        }
        public static string Password
        {
            get
            {
                string setting = "";
                setting = Builder["Application:Password"];
                return setting;

            }

        }

        public static string Port
        {
            get
            {
                string setting = "";
                setting = Builder["Application:Port"];
                return setting;

            }

        }

        public class NoteCalculation
        {
            public string Note_Id { get; set; }
            public string Calculation { get; set; }
            public string Status { get; set; }
            public string Exception { get; set; }
        }
        public class NoteInputForCalculation
        {
            public string Note_Id { get; set; }
            public string Note_Href { get; set; }            
        }
        public class NoteIds
        {
            public string Note_Id { get; set; }
        }

        public static string InputNoteIdsFile
        {
            get
            {
                string setting = null;

                setting = BaseConfiguration.Builder["appSettings:NotesIdForCalculation"];

                if (BaseConfiguration.UseCurrentDirectory)
                {
                    return Path.Combine(CurrentDirectory1 + FilesHelper.Separator + setting);
                }

                return setting;
            }
        }


        public static SqlConnection ApplicationCon { get; set; }
        public static SqlConnection AppConnectionString { get; set; }



    }
}
public class NotesDataContract
{
    public System.Guid DealID { get; set; }
    public string DealName { get; set; }
    public string NoteId { get; set; }
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
