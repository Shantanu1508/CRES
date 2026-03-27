using CRES.DataContract.WorkFlow;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;

namespace CRES.DataContract
{
    public class GenericResult
    {
        public object query;
        public List<XIRRArchiveDataContract> lstArchivesXIRR;

        public string Status2 { get; set; }
        public DateTime? BatchEndTime { get; set; }

        public bool Succeeded { get; set; }
        public string Message { get; set; }
        public string DealCalcuStatus { get; set; }
        public string PrepayCalcuStatus { get; set; }
        public string Token { get; set; }
        public string newDeailID { get; set; }
        public string newNoteID { get; set; }
        public string newFinancingWarehouseid { get; set; }

        public string RuleContent { get; set; }
        public int? TotalCount { get; set; }
        public UserDataContract UserData { get; set; }
        public string Trace { get; set; }

        public string Validationstring { get; set; }

        public int exceptioncount { get; set; }
        public int Criticalerror { get; set; }
        public dynamic v1json { get; set; }
        public PrepayDataContract ListPrePaySchedule { get; set; }
        public List<IDValueDataContract> ListScheduledPrincipalPaid { get; set; }
        public List<PowerBIDataSet> lstPowerBIDataSet { get; set; }

        public string CalculatorExceptionMessage { get; set; }
        public List<DealDataContract> lstDeals { get; set; }
        public List<NoteDataContract> lstNotes { get; set; }
        public List<NoteUsedInDealDataContract> lstNotesDeal { get; set; }
        public NoteDataContract NoteData { get; set; }
        public NoteAdditinalFeildsDataContract NoteAdditinalData { get; set; }
        public List<PropertyDataContract> lstProperty { get; set; }
        public List<DashBoardDataContract> lstdashBoard { get; set; }
        public List<FinancingWarehouseDataContract> lstFinancingWarehouseDataContract { get; set; }

        public FinancingWarehouseDataContract FinancingWarehouseDataContract { get; set; }
        public DealDataContract DealDataContract { get; set; }
        public List<PayruleDealFundingDataContract> DealFunding { get; set; }
        public List<LookupDataContract> lstLookups { get; set; }
        public DataTable dtIndexType { get; set; }
        public DataTable dtTestCase { get; set; }
        //  public List<PropertyDataContract> lstproperty { get; set; }

        public BackShopImportDataContract BackShopImportDataContract { get; set; }

        public List<NotePeriodicOutputsDataContract> lstNotePeriodicOutputsDataContract { get; set; }
        public List<DailyInterestAccrualsDataContract> ListDailyInterestAccruals { get; set; }

        public IN_UnderwritingDealDataContract IN_UnderwritingDeal { get; set; }
        public List<IN_UnderwritingNoteDataContract> lstIN_UnderwritingNotes { get; set; }

        public List<IN_UnderwritingRateSpreadScheduleDataContract> lstIN_UnderwritingRateSpreadScheduleDataContractList { get; set; }
        public List<IN_UnderwritingStrippingScheduleDataContract> lstIN_UnderwritingStrippingScheduleDataContractList { get; set; }
        public List<IN_UnderwritingPIKScheduleDataContract> lstIN_UnderwritingPIKScheduleDataContractList { get; set; }
        public List<IN_UnderwritingFundingScheduleDataContract> lstIN_UnderwritingFundingScheduleDataContractList { get; set; }
        public List<SearchDataContract> lstSearch { get; set; }

        public PropertyDataContract propertyDataContract { get; set; }

        public List<UserNotificationDataContract> lstUserNotification { get; set; }
        public List<NotePeriodicOutputsDataContract> ListNotePeriodicOutput_Daily { get; set; }
        public List<NotePeriodicOutputsDataContract> ListNotePeriodicOutput_PVAndGaap { get; set; }
        public List<NotePeriodicOutputsDataContract> ListNotePeriodicOutput_SpreadAndLibor { get; set; }

        //public List<MaturityScenariosDataContract> lstMaturityScenariosDataContract { get; set; }
        //public List<RateSpreadSchedule> lstRateSpreadSchedule { get; set; }
        //public List<PrepayAndAdditionalFeeScheduleDataContract> lstPrepayAndAdditionalFeeScheduleDataContract { get; set; }
        //public List<StrippingScheduleDataContract> lstStrippingScheduleDataContract { get; set; }
        //public List<FinancingFeeScheduleDataContract> lstFinancingFeeScheduleDataContract { get; set; }
        //public List<FinancingScheduleDataContract> lstFinancingScheduleDataContract { get; set; }
        //public List<DefaultScheduleDataContract> lstDefaultScheduleDataContract { get; set; }
        //public List<NoteServicingFeeScheduleDataContract> lstNoteServicingFeeScheduleDataContract { get; set; }
        //public List<PIKSchedule> lstPIKSchedule { get; set; }

        public DataTable lstMaturityScenariosDataContract { get; set; }
        public DataTable lstRateSpreadSchedule { get; set; }
        public DataTable lstPrepayAndAdditionalFeeScheduleDataContract { get; set; }
        public DataTable lstStrippingScheduleDataContract { get; set; }
        public DataTable lstFinancingFeeScheduleDataContract { get; set; }
        public DataTable lstFinancingScheduleDataContract { get; set; }
        public DataTable lstDefaultScheduleDataContract { get; set; }
        public DataTable lstNoteServicingFeeScheduleDataContract { get; set; }
        public DataTable lstPIKSchedule { get; set; }

        public DataTable lstFundingSchedule { get; set; }
        public DataTable lstPIKScheduleDetail { get; set; }
        public DataTable lstLIBORSchedule { get; set; }
        public DataTable lstAmortSchedule { get; set; }
        public DataTable lstFeeCouponStripReceivable { get; set; }
        public DataTable lstFundingRepaymentSequenceHistory { get; set; }
        public DataTable lstNoteDealFunding { get; set; }
        public DataTable lstNoteDealFundingBlank { get; set; }
        public DataTable lstNoteAllocationPercentage { get; set; }
        public DataTable lstNoteAllocationAmount { get; set; }

        public DataTable PayruleSetupData { get; set; }
        public DataTable ImportDataStatus { get; set; }

        public List<OutputNPVdata> ListOutputNPVdata { get; set; }
        public List<Transaction> ListTransaction { get; set; }
        public List<TransactionEntry> ListCashflowTransactionEntry { get; set; }
        public List<Transaction> ListCalcVal { get; set; }

        public List<OutputAllTabData> ListOutputAllTabData { get; set; }

        public List<FutureFundingScheduleTab> lstFutureFundingScheduleTab { get; set; }

        public DateTime? EffectiveDate { get; set; }

        public NoteAllScheduleLatestRecordDataContract NoteAllScheduleLatestRecord { get; set; }

        public NoteAdditinalListDataContract NoteAdditinalList { get; set; }

        public List<PayruleNoteAMSequenceDataContract> lstSequences { get; set; }

        public List<PayruleTargetNoteFundingScheduleDataContract> lstnoteFundingschedule { get; set; }

        public List<NotePeriodicOutputsDataContract> lstnotePeriodicOutputs { get; set; }

        public List<OutputNPVdata> lstOutputNPVdata { get; set; }

        public List<string> lstnoteexistmsg { get; set; }

        public List<ReportDataContract> lstReport { get; set; }
        public List<LiborScheduleTab> lstLiborScheduledata { get; set; }

        public List<FLiborScheduleTab> lstFastLiborScheduledata { get; set; }
        public List<ExceptionDataContract> Allexceptionslist { get; set; }
        public ExceptionDataContract NoteExceptions { get; set; }

        public List<CalculationManagerDataContract> lstCalculationManger { get; set; }

        //public List<Transaction> ListTransaction { get; set; }
        //public List<Transaction> ListCalcVal { get; set; }

        public string SCalcValue { get; set; }
        public DataTable dtCalcReq { get; set; }

        // public List<Transaction> TransactionList { get; set; }
        public string STransactions { get; set; }

        public List<UserPermissionDataContract> UserPermissionList { get; set; }

        public List<SystemConfigKeys> SystemConfigKeysList { get; set; }

        //public List<NoteCashflowsExportDataContract> lstNoteCashflowsExportData { get; set; }
        public DataTable lstNoteCashflowsExportData { get; set; }

        public DataTable dt { get; set; }

        public DataTable lstDownloadNoteDataTape { get; set; }
        public List<ScenarioParameterDataContract> lstScenario { get; set; }

        public ScenarioParameterDataContract ScenarioParameters { get; set; }

        public string newscenarioid { get; set; }

        public string ScenarioMsg { get; set; }

        public int StatusCode { get; set; }
        public List<RoleDataContract> RoleList { get; set; }
        //===================Added Getwarehouse List====================================//
        public List<DWStatusDataContract> warehouseStatus { get; set; }

        public List<UserDefaultSettingDataContract> UserDefaultSetting { get; set; }

        public List<ModuleTabMasterDataContract> ModuleTabMasterList { get; set; }

        public List<UserDataContract> UserList { get; set; }

        public List<NotificationSubscriptionDataContract> lstSubscription { get; set; }

        public List<PIKDistributionsDataContract> ListPIKDistribution { get; set; }

        // task
        public List<TaskManagementDataContract> lstTask { get; set; }

        public TaskManagementDataContract TaskData { get; set; }

        public string newtaskID { get; set; }

        public List<TaskCommentDataContract> lstTaskComment { get; set; }

        public List<TaskSubscriptionDataContract> lstSubscribeduser { get; set; }

        public List<ActivityLogDataContract> lstActivityLog { get; set; }

        public List<DocumentDataContract> lstDocument { get; set; }

        public AppConfigDataContract AllowBasicLogin { get; set; }

        public List<ClientDataContract> lstClient { get; set; }
        public List<FundDataContract> lstFund { get; set; }

        public List<HolidayListDataContract> HolidayList { get; set; }

        public List<ServicerDataContract> lstServicer { get; set; }

        public WFDetailDataContract WFDetailDataContract { get; set; }

        public List<WFRejectListDataContract> lstRejectList { get; set; }

        public List<WorkflowListDataContract> lstWorkflow { get; set; }

        public List<IndexesMasterDataContract> lstIndexesMaster { get; set; }
        public IndexesMasterDataContract indexesMaster { get; set; }

        public ScenarioUserMapDataContract ScenarioUserMap { get; set; }

        public List<ScenarioUserMapDataContract> lstScenarioUserMap { get; set; }

        public string newIndexesMasterGuid { get; set; }

        public List<WFDetailDataContract> lstWFComments { get; set; }

        public List<FutureFundingScheduleDetailDataContract> lstFundingScheduleDetail { get; set; }

        public PortfolioDataContract portfolioDataContract { get; set; }
        public List<PortfolioDataContract> lstportfolio { get; set; }

        public List<PeriodicDataContract> lstPeriodicClose { get; set; }

        public List<FeeSchedulesConfigDataContract> lstFeeTypeLookUp { get; set; }

        public List<FeeFunctionsConfigDataContract> lstFeeFunctionsConfig { get; set; }
        public List<FeeSchedulesConfigDataContract> lstFeeSchedulesConfig { get; set; }
        public List<HistoricalAccrualDataContract> lstHistAccrual { get; set; }
        public List<TagMasterDataContract> TagMasterList { get; set; }
        public TagMasterDataContract TagMasterDC { get; set; }
        public List<DevDashBoardDataContract> CalculationStatus { get; set; }
        public List<DevDashBoardDataContract> UserRequestCount { get; set; }
        public List<DevDashBoardDataContract> ResultList { get; set; }
        public DataTable CalcSummary { get; set; }
        public List<DevDashBoardDataContract> FastestandSlowest { get; set; }
        public DevDashBoardDataContract dwstatus { get; set; }
        public DataTable dttagWiseCashflow { get; set; }
        public List<TransactionAuditDataContract> lstTransactionAudit { get; set; }
        public List<TransactionEntryDataContract> lstTransactionEntry { get; set; }
        public List<UserDelegationConfigDataContract> AllActiveDelegatedUser { get; set; }
        public List<UserDelegationConfigDataContract> UsersToImpersonateList { get; set; }
        public List<WFNotificationConfigDataContract> wfNotificationConfigDataContract { get; set; }
        public List<WFTemplateRecipientDataContract> wfTemplateRecipient { get; set; }
        public List<InterestCalculatorDataContract> ListInterestCalculator { get; set; }

        public List<LookupMasterDataContract> lstlookupMaster { get; set; }
        public List<BatchCalculationMasterDataContract> lstBatchCalculationMaster { get; set; }
        public List<DevDashBoardDataContract> lstAIDashboard { get; set; }

        //Calc output datatable
        public DataTable dtNotePeriodicOutputsDataContract { get; set; }

        public DataTable dtBalanceTab { get; set; }
        public DataTable dtCouponTab { get; set; }
        public DataTable dtPIKInterestTab { get; set; }
        public DataTable dtFinancingTab { get; set; }
        public DataTable dtRateTab { get; set; }
        public DataTable dtFeesTab { get; set; }
        public DataTable dtDatesTab { get; set; }
        public DataTable dtGAAPBasisTab { get; set; }
        public DataTable dtFeeOutputDataContract { get; set; }

        public DataTable dtFutureFundingScheduleTab { get; set; }
        public DataTable dtMaturityList { get; set; }
        public string CalcDebugFileName { get; set; }
        public string Enablem61Calculation { get; set; }

        public string Status { get; set; }
        public DataTable dtGroup { get; set; }
        public DataTable dtholidaymaster { get; set; }

        public EquityDataContract EquityData { get; set; }
        public string LiabilityTypeID { get; set; }

        //========================

        public List<AppConfigDataContract> AllSettingKeys { get; set; }
        public List<AppTimeZoneDataContract> lstAppTimeZone { get; set; }
        public List<AutoSpreadRuleDataContract> _autospreadrule { get; set; }
        public List<DevDashBoardDataContract> _lstwfStatus { get; set; }
        public List<FinancingSourceDataContract> lstfinancingsource { get; set; }
        public List<UserDataContract> UserApproverList { get; set; }

        public string PayruleGenerationExceptionMessage { get; set; }
        public string DealAmortGenerationExceptionMessage { get; set; }

        public List<NoteListDealAmortDataContarct> lstNoteDetailForDealAmort { get; set; }
        public string NoteJson { get; set; }
        public List<ServicerDataContract> ServicerList { get; set; }
        public List<DealAmortScheduleDataContract> lstDealAmortization { get; set; }

        public List<DataDictionaryDataContract> DataDictionaryList { get; set; }
        public List<WFStatusPurposeMappingDataContract> lstWFStatusPurposeMapping { get; set; }
        public UserDataContract _userinfo { get; set; }
        public PayloadDataContract Payload { get; set; }
        public List<ReportFileDataContract> ReportFileList { get; set; }
        public List<ReportFileLogDataContract> lstReportFileLog { get; set; }
        public List<NoteAmortFundingDataContract> lstnoteamortendbal { get; set; }
        public ReportFileLogDataContract ReportFileLog { get; set; }
        public string currentoffset { get; set; }
        public List<SchedulerConfigDataContract> ListSchedulerConfig { get; set; }
        public DataTable dtNoteCommitment { get; set; }
        public DrawFeeInvoiceDataContract DrawFeeInvoice { get; set; }
        public PayruleDealFundingDataContract _dealFunding { get; set; }
        //
        public QBDCompanyDataContract QBDCompany { get; set; }
        public List<ProjectedPayoffDataContract> _lstprojectedpayoffdates { get; set; }

        public List<ReserveAccountDataContract> ListReserveScheduleBreakDown { get; set; }
        public DataTable dtEffectiveDates { get; set; }

        public MemoryStream ms { get; set; }
        //dt
        public DataTable dtInvestors { get; set; }
        public DataTable dtNoteFinancingSources { get; set; }
        public DataTable dtNoteAdditionalInfo { get; set; }
        public DataTable dtDelphi { get; set; }
        public List<DWStatusDataContract> lstDWStatus { get; set; }

        public string JsonTemplateItem { get; set; }

        public List<RuleTypeDataContract> AllRulesList { get; set; }

        public List<PrepayAllocationsDataContract> lstPrepayAllocations { get; set; }

        public List<PrepayProjectionDataContract> lstPrepayProjection { get; set; }

        public DateTime? Prepaylastupdated { get; set; }

        public string PrepaylastupdatedBy { get; set; }

        public List<SpreadMaintenanceScheduleDataContract> lstDealSpreadMaintenanceDeallevel { get; set; }
        public List<SpreadMaintenanceScheduleDataContract> lstDealSpreadMaintenance { get; set; }
        public List<PrepayAdjustmentDataContract> lstDealPrepay { get; set; }

        public List<MinMultScheduleDataContract> lstDealMiniSpread { get; set; }
        public List<FeeCreditsDataContract> lstDealMiniFee { get; set; }

        public string appconfigpowerBI { get; set; }
        public int lstPrepay { get; set; }
        public string AnalysisId { get; set; }
        public List<ScenarioruletypeDataContract> lstScenariorule { get; set; }
        public List<ScenarioruletypeDataContract> lstScenarioRuleDetail { get; set; }

        public List<LoanStatusDataContract> lstLoanstatus { get; set; }

        public List<PropertyTypeDataContract> lstPropertytype { get; set; }

        public PrepayCalcStatusDataContract PrepayCalcFailedStatusData { get; set; }

        public List<string> loggedfiledata { get; set; }

        public string CalculationErrorMessage { get; set; }

        public List<EquitySummaryDataContract> equitySummaryDatas { get; set; }

        public List<WFDashboardDataContract> lstWFDashboard { get; set; }

        public int? WFStatusPurposeMappingID { get; set; }

        public List<ServicingWatchlistDataContract> ListServicingWatchlistLegal { get; set; }
        public List<ServicingWatchlistDataContract> ListServicingWatchlistAccounting { get; set; }
        public List<ServicingWatchlistDataContract> ListServicingPotentialImpairment { get; set; }

        public List<(string TableName, DataTable Table, int RowCount)> DataTablesList { get; set; }
        public List<(string TableName, DataTable Table, int RowCount)> DataTablesList2 { get; set; }
        public LiabilityNoteDataContract lstLiabilityNote { get; set; }
        public List<LiabilityNoteDataContract> ListDealLiability { get; set; }
        public List<LiabilityNoteDataContract> lstDebtNote { get; set; }
        public DataTable FirstHalfData { get; set; }
        public DataTable SecondHalfData { get; set; }
        public DataTable lstDealFundingImpairment { get; set; }
        public List<LiabilityNoteDataContract> lstNote { get; set; }
        public List<LiabilityFundingScheduleDataContract> ListLiabilityFundingSchedule { get; set; }
        public List<LookupDataContract> AssetList { get; set; }
        public DebtDataContract Debtdc { get; set; }
        public DataTable DealInfo { get; set; }
        public List<LookupDataContract> ListAccountCategory { get; set; }
        public List<AdditionalTransactionDataContract> ListAddTrans { get; set; }
        public List<FeeScheduleDataContract> ListFeeSchedule { get; set; }
        public List<JournalLedgerDataContract> ListjournalLedger { get; set; }
        public List<LiabilityRateSpreadDataContract> ListLiabilityRate { get; set; }
        public JournalLedgerDataContract journalLedger { get; set; }
        public List<ScheduleEffectiveDateLiabilityDataContract> ListEffectiveDateCount { get; set; }
        public DataTable lstGeneralSetupDetailsLiabilityNote { get; set; }
        public DataTable lstGeneralSetupDetails { get; set; }
        public List<LiabilityNoteAssetMapping> LNoteAssetMap { get; set; }
        public string JournalEntryMasterGUID { get; set; }
        public DataTable LiabilityCashFlow { get; set; }
        public EquityDataContract eqstatus { get; set; }
        public List<TransactionTypesDataContract> TTList { get; set; }
        public List<XIRRConfigDataContract> lstXirrConfig { get; set; }
        public DataTable CheckDuplicateData { get; set; }
        public int RowCount { get; set; }
        public List<XIRRFiltersLookupDataContract> XIRRFiltersLookup { get; set; }
        public List<XIRRConfigFilterDataContract> ListXirrFilters { get; set; }
        public List<XIRRConfigFilterDataContract> ListXirrConfigFilterDropDown { get; set; }       
        public NoteAdditinalListDataContract NoteList_RSSFEE { get; set; }
        public XIRRReturnGroupDataContract XIRRReturnGroupDC { get; set; }
        public List<LookupDataContract> lstReferencingDealLevelLookup { get; set; }
        public List<DevDashBoardDataContract> XIRRStatusSummary { get; set; }
        public List<AutoDistributeWriteoffDataContract> _autodistributewriteoff { get; set; }

        public PrincipalWriteoffDataContract PrincipalWriteoffData { get; set; }
        public List<EnvConfigDataContract> lstEnvConfig { get; set; }
        public decimal? CalcWeightedSpread { get; set; }
        public decimal? CalcWeightedEffectiveRate { get; set; }

        //used in autospreading
        public List<PayruleDealFundingDataContract> ListRevolverDealFunding { get; set; }
        public List<PayruleTargetNoteFundingScheduleDataContract> ListRevolverNoteFunding { get; set; }
        public List<DealRelationshipDataContract> _dealRelationship { get; set; }
        public List<CashAccountDataContract> _lstCashAccount { get; set; }
        public DataTable lstCurrentSpread { get; set; }
        public List<ReserveAccountMasterDataContract> lstReserveAccountMaster { get; set; }
        public DealDashDataContract DealDashData { get; set; }
        public DataTable UserPreferenceLogs { get; set; }
        public DataTable dtLastUpdatedforTabs { get; set; }
        public DataTable dtBookMarkedDeal { get; set; }
        public DataTable dtnotedashboarddata { get; set; }
        public DataTable dtAssociatedDebt { get; set; }
        public List<FeeScheduleDataContract> FacilityFeeSchedule { get; set; }
        public List<LiabilityRateSpreadDataContract> FacilityRateSpreadSchedule { get; set; }
        public DataTable lstFacilityFeeHistory { get; set; }
        public DataTable lstFacilityRateSpreadHistory { get; set; }
        public List<ScheduleEffectiveDateLiabilityDataContract> ListFacilityEffectiveDateCounts { get; set; }
        public List<DebtDataContract> ListDebtExtInterest { get; set; }
        public List<LookupDataContract> lstDebtEquityType { get; set; }
        public List<LookupDataContract> listAssociatedDeals { get; set; }
        public List<LookupDataContract> lstTransactionType { get; set; }
        public List<InterestExpenseScheduleDataContract> lstInterestExpenseSchedule { get; set; }
        public List<LiabilityCalcDataContract> LiabilityCalculationStatus { get; set; }
        public DataTable lstInterestExpenseScheduleHistory { get; set; }
        public List<LookupDataContract> ListofFundName { get; set; }
        public List<PrepayAndAdditionalFeeScheduleLiabilityDetailDataContract> ListPrepayAndAdditionalFeeScheduleLiabilityDetail { get; set; }

        public int allowImport;
    }



    public class GenericResultResponce
    {
        //
        public bool Succeeded { get; set; }
        public string Message { get; set; }
    }
}