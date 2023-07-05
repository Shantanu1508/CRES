export class Note {
    public NoteId: string;
    public AccountID: string;
    public DealID: string;
    public DealName: string;
    public CRENoteID: string;
    public Comments: string;

    public InitialInterestAccrualEndDate: Date;
    public AccrualFrequency: number;
    public DeterminationDateLeadDays: number;
    public DeterminationDateReferenceDayoftheMonth: number;
    public DeterminationDateInterestAccrualPeriod: number;
    public DeterminationDateHolidayList: Number;
    public FirstPaymentDate: Date;
    public InitialMonthEndPMTDateBiWeekly: Date;
    public PaymentDateBusinessDayLag: number;
    public IOTerm: number;
    public AmortTerm: number;
    public PIKSeparateCompounding: number;
    public MonthlyDSOverridewhenAmortizing: number;
    public AccrualPeriodPaymentDayWhenNotEOMonth: number;
    public FirstPeriodInterestPaymentOverride: any;
    public FirstPeriodPrincipalPaymentOverride: any;
    public FinalInterestAccrualEndDateOverride: Date;
    public AmortType: number;
    public RateType: number;
    public RateTypeText: string;
    public ReAmortizeMonthly: number;
    public ReAmortizeatPMTReset: number;
    public StubPaidInArrears: number;
    public RelativePaymentMonth: number;
    public SettleWithAccrualFlag: number;
    public InterestDueAtMaturity: number;
    public RateIndexResetFreq: number;
    public FirstRateIndexResetDate: Date;
    public LoanPurchase: number;
    public AmortIntCalcDayCount: number;
    public StubPaidinAdvanceYN: number;
    public FullPeriodInterestDueatMaturity: number;
    public ProspectiveAccountingMode: number;
    public IsCapitalized: number;
    public SelectedMaturityDateScenario: number;
    public SelectedMaturityDate: Date;
    //public InitialMaturityDate: Date;
    public ExpectedMaturityDate: Date;
    public OpenPrepaymentDate: Date;
    public CashflowEngineID: number;
    public LoanType: number;
    public Classification: number;
    public SubClassification: number;
    public GAAPDesignation: number;
    public PortfolioID: number;
    public GeographicLocation: number;
    public PropertyType: number;
    public RatingAgency: number;
    public RiskRating: number;
    public PurchasePrice: any;
    public FutureFeesUsedforLevelYeild: any;
    public TotalToBeAmortized: any;
    public StubPeriodInterest: any;
    public WDPAssetMultiple: any;
    public WDPEquityMultiple: Number;
    public PurchaseBalance: any;
    public DaysofAccrued: number;
    public InterestRate: Number;
    public PurchasedInterestCalc: any;
    public ModelFinancingDrawsForFutureFundings: any;
    public NumberOfBusinessDaysLagForFinancingDraw: number;
    public FinancingFacilityID: number;
    public FinancingInitialMaturityDate: Date;
    public FinancingExtendedMaturityDate: Date;
    public FinancingPayFrequency: number;
    public FinancingInterestPaymentDay: number;
    public ClosingDate: Date;
    public InitialFundingAmount: any;
    public Discount: any;
    public OriginationFee: any;
    public CapitalizedClosingCosts: any;
    public PurchaseDate: Date;
    public PurchaseAccruedFromDate: any;
    public PurchasedInterestOverride: any;
    public DiscountRate: Number;
    public ValuationDate: Date;
    public FairValue: any;
    public DiscountRatePlus: Number;
    public FairValuePlus: any;
    public DiscountRateMinus: Number;
    public FairValueMinus: any;
    public InitialIndexValueOverride: number;
    public IncludeServicingPaymentOverrideinLevelYield: number;
    public OngoingAnnualizedServicingFee: Number;
    public IndexRoundingRule: number;
    public RoundingMethod: number;
    public StubInterestPaidonFutureAdvances: number;
    public TaxAmortCheck: string;
    public PIKWoCompCheck: string;
    public GAAPAmortCheck: string;
    public DefaultscenarioID: string;
    public CreatedBy: string;
    public CreatedDate: Date;
    public UpdatedBy: string;
    public UpdatedDate: Date;
    public Name: string;
    public StatusID: number;
    public StatusName: string;
    public BaseCurrencyID: number;
    public StartDate: Date;
    public EndDate: Date;
    public PayFrequency: number;
    public pagesIndex: number;
    public pagesSize: number;
    public modulename: string;
    public IndexNameID: string;
    public IndexNameText: string;
    public Servicer: number;
    public ServicerText: string;
    public NotesavedFrom: string;
    public UseIndexOverrides: boolean;
    public NoofdaysrelPaymentDaterollnextpaymentcycle: number;
    public ClientNoteID: string;
    public lastCalcDateTime: Date;
    public CopyCRENoteId: string;
    public CopyName: string;
    public CopyDealID: string;
    public CopyDealName: string;
    public CRENewNoteID: string;
    public NewNoteName: string;
    public ServicerID: string;
    public TotalCommitment: number;
    public CalcJSONRequest: string;
    public ClientName: string;
    public Portfolio: string;
    public Tag1: string;
    public Tag2: string;
    public Tag3: string;
    public Tag4: string;
    //public ExtendedMaturityScenario1: Date;
    //public ExtendedMaturityScenario2: Date;
    //public ExtendedMaturityScenario3: Date;
    public ActualPayoffDate: Date;
    //public FullyExtendedMaturityDate: Date;
    public TotalCommitmentExtensionFeeisBasedOn: number;
    public CREDealID: string;
    public Isexclude: boolean;
    public UseRuletoDetermineNoteFunding: number;
    public UseRuletoDetermineNoteFundingText: string;
    lstNoteServicingLog: Array<ServicingLog>
    public FullInterestAtPPayoff: number;
    public FullInterestAtPPayoffText: string;
    public FFLastUpdatedDate_String: string;
    public UpdatedByFF: string;
    public NoteRule: string;
    public RequestType: string;
    public ClientID: number;
    public FundId: number;
    public FinancingSourceID: number;
    public DebtTypeID: number;
    public BillingNotesID: number;
    public CapStack: number;
    public PoolID: number;
    public AnalysisID: string;
    public AnalysisIDNew: string;
    public CalculationModeID: number
    public CalculationModeText: number
    public IsSingleNoteClac: boolean = false
    public StubInterestRateOverride: number
    public CalculationStatus: string;
    public ServicerNameID: number;
    public ServicerNameText: string;
    public BusinessdaylafrelativetoPMTDate: number;
    public DayoftheMonth: number;
    public PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate: number;
    public PIKInterestAddedToBalanceBasedOnBusinessAdjustedDateText: string;
    public InterestCalculationRuleForPaydowns: number;
    public InterestCalculationRuleForPaydownsText: string;
    public InterestCalculationRuleForPaydownsAmort: number;
    public InterestCalculationRuleForPaydownsAmortText: string;
    public ListEffectiveDateCount: any;
    public OriginationFeePercentageRP: number
    
    public RoundingNote: number;
    public RoundingNoteText: string;
    public StraightLineAmortOverride: number;
   
    public AdjustedTotalCommitment: number;
    public AggregatedTotal: number;

    public RepaymentDayoftheMonth: number;
    public NoteTransferDate: Date;
    public OriginalTotalCommitment: number;
    public EnableM61Calculations: number; 
    public MaturityMethodID: number; 
    public MultipleNoteids: string;
    public ListNoteMarketPrice: Array<NoteMarketPrice>;
    public ImpactCommitmentCalc: number;
    public BalanceAware: boolean;
    constructor(DealID: string) {
        this.DealID = DealID;
    }
}


export class ServicingLog {
    TransactionDate: Date;
    TransactionType: number;
    TransactionAmount: number;
    RelatedtoModeledPMTDate: Date;
    ModeledPayment: number;
    AmountOutstandingafterCurrentPayment: number;
}




export class DownloadCashFlow {
    NoteId: string;
    DealID: string;
    AnalysisID: string;
   /// PortfolioId: string;
    MutipleNoteId: string;
    PortfolioMasterGuid: string;
    CountOnDropDownFilter: number;
    CountOnGridFilter: number;
    TransactionCategoryName: string;
    Pagename: string;
}
export class Servicer {
    ServicerMasterID: number;
    ServicerDisplayName: string;
    ServicerDropDate: number;
    RepaymentDropDate: number;

    constructor(ServicerMasterID: number, ServicerDropDate: number, RepaymentDropDate: number) {
        this.ServicerMasterID = ServicerMasterID;
        this.ServicerDropDate = ServicerDropDate;
        this.RepaymentDropDate = RepaymentDropDate;
    }
}
    export class NoteMarketPrice {
    NoteID: string;
    Date: Date;
    Value: number;
}

export class JsonTemplate {
    public JsonTemplateID: string;
    public JsonTemplateName: string;
    public keyname: string;
    public Value: string;

}

export class TemplateName {
    public JsonTemplateMasterID: number;
    public TemplateName: string;
    public NewTemplateName: string;  
}