import { Note } from "./note";

export class deals {
    public DealID: string;
    public DealName: string;
    public DealType: number;
    public DealTypeText: string;
    public LoanProgram: number;
    public LoanProgramText: string;
    public LoanPurpose: number;
    public LoanPurposeText: string;
    public Statusid: number;
    public StatusText: string;
    public AppReceived: Date;
    public EstClosingDate: Date;
    public BorrowerRequest: number;
    public BorrowerRequestText: string;
    public RecommendedLoan: number;
    public TotalFutureFunding: number;
    public Source: number;
    public SourceText: string;
    public BrokerageFirm: number;
    public BrokerageContact: string;
    public Principal: string;
    public Sponsor: string;
    public NetWorth: number;
    public Liquidity: number;
    public ClientDealID: string;
    public CREDealID: string;
    public TotalCommitment: string;
    public AdjustedTotalCommitment: string;
    public AggregatedTotal: number;
    public AssetManagerComment: string;
    public LinkedDealID: string;
    public AllowSizerUpload: number;
    public AssetManager: string;
    public AssetManagerID: string;
    public AMTeamLeadUserID: string;
    public AMSecondUserID: string;
    public DealCity: string;
    public DealState: string;
    public DealPropertyType: string;
    public FullyExtMaturityDate: Date;
    public LastUpdatedFF: Date;
    public UnderwritingStatusid: number;
    public UnderwritingStatusidText: string;
    public DealComment: string;
    public LastUpdatedByFF: string;
    public LastUpdatedFF_String: string;
    public CopyDealID: string;
    public CopyDealName: string;
    public AnalysisID: string;
    public AnalysisIDNew: string;
    public EnableAutoSpread: boolean;
    public ServicerDropDate: number;
    public ServicereDayAjustement: number;
    public FirstPaymentDate: Date;
    public max_ExtensionMat: Date;
    public LastWireConfirmDate_db: Date;   
    public EnableM61Calculator: boolean;
    public ListHoliday: any;
    PayruleDealFundingList: Array<DealFunding>;
    DeletedDealFundingList: Array<DealFunding>;
    PayruleTargetNoteFundingScheduleList: Array<Notefunding>;
    PayruleNoteAMSequenceList: Array<NoteSequence>;
    AmortSequenceList: Array<NoteSequence>;
    PayruleNoteDetailFundingList: Array<NoteDetailFunding>;
    PayruleSetupList: Array<PayruleSetMaster>;
    notelist: Array<Note>;
    BoxDocumentLink: string;
    public DealGroupID: string;
    public DealRule: string;
    public maxMaturityDate: Date;    
    ShowUseRuleN: boolean;
    AutoSpreadRuleList: Array<AutoSpreadRule>;
    public envname: string;
    amort: Amort;
    PrepaymentPremium: PrepaymentPremium;
    Flag_DealFundingSave: boolean = false;
    Flag_NoteSaveFromDealDetail: boolean = false;
    Flag_DealAmortSave: boolean = false;
    public BaseCurrencyName: string;
    //   public EquityAmount: number;
    public RemainingAmount: number;
    public Listadjustedtotlacommitment: Array<DealAdjustedTotalCommitmentTab>;
    public DeleteAdjustedTotalCommitment: Array<DealAdjustedTotalCommitmentTab>;
    public IsPayruleClicked: string;
    public RequiredEquity: number;
    public AdditionalEquity: number;
    public EnableAutospreadRepayments: boolean;
    public EnableAutospreadRepayments_db: boolean;
    public AutoUpdateFromUnderwriting: boolean;
    public ExpectedFullRepaymentDate: Date;
    public RepaymentAutoSpreadMethodID: number;
    public RepaymentAutoSpreadMethodText: string;
    public RepaymentStartDate: Date;
    public EarliestPossibleRepaymentDate: Date;
    public Blockoutperiod: number;
    public PossibleRepaymentdayofthemonth: number;
    public Repaymentallocationfrequency: number;
    public AutoPrepayEffectiveDate: Date;
    public LatestPossibleRepaymentDate: Date;
    public ListProjectedPayoff: Array<ProjectedPayoffDate>;
    public ListAutoRepaymentBalances: Array<AutoRepaymentBalances>;  
    public ListNoteRepaymentBalances: Array<AutoRepaymentNoteBalances>;    
    public KnownFullPayoffDate: Date;
    public AllowFundingDevDataFlag: boolean;
    public AllowFFSaveJsonIntoBlob: boolean;
    public ListFeeInvoice: any = [];
    public EnableAutospreadUseRuleN: boolean;
    public ApplyNoteLevelPaydowns: boolean;
    public DealLevelMaturity: boolean;
    public MaturityList: any = [];
    public ReserveAccountList: any = [];
    public ReserveScheduleList: any = [];
    public IsREODeal: boolean;
    public BalanceAware: boolean;
    public RepayExpectedMaturityDate: Date;
    public PropertyTypeID: number;
    public LoanStatusID: number;
    public PrePayDate: Date;
    public ICMFullyFundedEquity: number;
    public EquityatClosing: number;
    constructor(DealID: string) {
        this.DealID = DealID;
        this.amort = new Amort();
        this.PrepaymentPremium = new PrepaymentPremium();

    }
}

export class DealFunding {
    public DealFundingID: string;
    public DealID: string;
    public Date: Date;
    public Amount: number;
    public Comment: string;
    public CreatedBy: string;
    public CreatedDate: Date;
    public UpdatedBy: string;
    public UpdatedDate: Date;
    public PurposeID: number;
    public PurposeText: string;
    public Applied: boolean;
    public Issaved: boolean;
    public DrawFundingId: string;
    public Comments: string;
    public WF_CurrentStatus: string;
    public OldComment: string;
    public DrawFeeStatus: number;
    public DrawFeeStatusName: string;
    public DrawFeeFile: string;
    public IsRowEdited: boolean;
    public IsShowDrawStatus: boolean;
    constructor(DealID: string) {
        this.DealID = DealID;
    }
}
export class Notefunding {
    public NoteID: string;
    public Value: string;
    public Date: Date;
    public NoteName: string;
    public isDeleted: number
    public PurposeID: number;
    public Purpose: string;
    public DealFundingRowno: number;
    public DealFundingID: string;
    public Applied: boolean;
    public Comments: string;
    public GeneratedByText: string;
    public GeneratedBy: number;
    
}

export class NoteSequence {
    public NoteID: string;
    public SequenceNo: number;
    public SequenceType: string;
    public SequenceTypeText: string;
    public Value: number;
    public Ratio: number = 0;
}


export class NoteDetailFunding {
    public NoteID: string;
    public CRENoteID: string;
    public NoteName: string;
    public UseRuletoDetermineNoteFundingText: string;
    public UseRuletoDetermineNoteFunding: string;
    public NoteFundingRule: string;
    public NoteFundingRuleText: string;
    public NoteBalanceCap: string;
    public FundingPriority: string;
    public RepaymentPriority: string;
}

export class PayruleSetMaster {
    StripTransferFrom: string;
    StripTransferTo: string;
    DealID: string;
    Amount: string;
    Value: string;
    RuleID: string;
    RuleIDText: string;

}

export class AutoSpreadRule {
    UserID: string;
    DealID: string;
    AutoSpreadRuleID: string;
    PurposeType: number;
    DebtAmount: number;
    // EquityAmount: number;
    StartDate: Date;
    EndDate: Date;
    DistributionMethod: number;
    FrequencyFactor: number;
    Comment: string;
    PurposeTypeText: string;
    DistributionMethodText: string;
    public RequiredEquity: number;
    public AdditionalEquity: number;

}

export class DealAmortization {
    public DealAmortizationScheduleID: string;
    //  public DealAmortizationScheduleAutoID: number;
    public DealID: string;
    public DealAmortScheduleRowno: number;
    public Date: Date;
    public Amount: number;
    public CreatedBy: string;
    public CreatedDate: Date;
    public UpdatedBy: string;
    public UpdatedDate: Date;
    public IsDelete: boolean;


}

export class NoteAmortization {
    public DealAmortizationScheduleID: string;
    public DealAmortizationScheduleAutoID: number;
    public DealID: string;
    public Date: Date;
    public Value: number;
    public NoteName: string;
    public DealAmortScheduleRowno: number;
    public CreatedBy: string;
    public CreatedDate: Date;
    public UpdatedBy: string;
    public UpdatedDate: Date;
    public NoteID: string;
    public CRENoteID: string;

}


//export class PayruleDealFunding {
//    public DealFundingID: string;
//    public DealID: string;
//    public Date: Date;
//    public Value: number;
//    public Comment: string;
//    public PurposeID: number;
//    public PurposeText: string;
//    public CreatedBy: string;
//    public CreatedDate: Date;
//    public UpdatedBy: string;
//    public UpdatedDate: Date;
//}
export class Amort {
    //constructor() {
    //    this.AmortizationMethod = 0;
    //    this.AmortizationMethodText = "";
    //}
    public dt: any;
    public AmortizationMethod: number;
    public AmortizationMethodText: string;
    public ReduceAmortizationForCurtailments: number;
    public ReduceAmortizationForCurtailmentsText: string;
    public BusinessDayAdjustmentForAmort: number;
    public BusinessDayAdjustmentForAmortText: string;
    public NoteDistributionMethod: number;
    public NoteDistributionMethodText: string;
    public PeriodicStraightLineAmortOverride: number;
    public FixedPeriodicPayment: number;
    public AmortSequenceList: Array<NoteSequence>;
    public NoteListForDealAmort: Array<NoteAmort>;
    public DealAmortScheduleList: Array<DealAmortization>;
    public NoteAmortScheduleList: Array<NoteAmortization>;
    public MutipleNoteIds: string;
}



export class NoteAmort {
    public NoteID: string;
    public CRENoteID: string;
    public Name: string;
    public MaturityDate: Date;
    public LienPosition: number;
    public LienPositionText: string;
    public Priority: number;
    public IOTerm: number;
    public AmortRate: number;
    public TotalCommitment: number;
    public EstimatedCurrentBalance: number;
    public AmortTerm: number;
    public UseRuletoDetermineAmortizationText: string;
    public UseRuletoDetermineAmortization: string;
    public RoundingNoteText: string;
    public RoundingNote: number;
    public StraightLineAmortOverride: number;
}

export class DealAdjustedTotalCommitmentTab {
    public DealID: string;
    public NoteAdjustedCommitmentMasterID: number;
    public CRENoteID: string;
    public NoteID: string;
    public Date: Date;
    public Type: number;
    public Rownumber: number;
    public DealAdjustmentHistory: number;
    public AdjustedCommitment: number;
    public TotalCommitment: number;
    public AggregatedCommitment: number;
    public Comments: string;
    public Amount: number;
    public TypeText: string;
    public NoteAdjustedTotalCommitment: number;
    public NoteAggregatedTotalCommitment: number;
    public NoteTotalCommitment: number;
    public TotalRequiredEquity: number;
    public TotalAdditionalEquity: number;
    public ExcludeFromCommitmentCalculation: number;
    public TotalEquityatClosing: number;
    public CommitmentType: string;
}


export class AutoEquity {
    public EquityName: string;
    public TotalCommitted: number;
    public TotalContibutedDate: number;
    public RemainingtoContribute: number;
    public Percentcontributed: number;
}

export class ProjectedPayoffDate {
    public DealID: string;
    public ProjectedPayoffAsofDate: Date;
    public CumulativeProbability: number;
}

export class AutoRepaymentBalances {
    public DealID: string;
    public Date: Date;
    public Amount: Date;
    public Type: string;
}

export class AutoRepaymentNoteBalances {
    public NoteID: string;
    public Date: Date;
    public Amount: number;
    public Type: string;
}

export class PrepaymentPremium {

    public PrepayScheduleId: number;
    public EventDealId: number;
    public DealID: string;
    public EffectiveDate: Date;
    public CalcThru: Date;
    public PrepayDate: Date;
    public PrepaymentMethod: number;
    public BaseAmountType: number;
    public SpreadCalcMethod: number;
    public GreaterOfSMOrBaseAmtTimeSpread: boolean;
    public HasNoteLevelSMSchedule: boolean;
    public Includefeesincredits: boolean;
    public RemainingSpread: number;
    public OpenPaymentDate: Date;
    public AnalysisID: string; 
    public PrePaymentRuleType: number;
    public PrepayAdjustmentList: Array<PrepayAdjustment>;
    public SpreadMaintenanceScheduleList: Array<SpreadMaintenanceSchedule>;
    public MinMultScheduleList: Array<MinMultSchedule>;
    public FeeCreditsList: Array<FeeCredits>;
}

export class PrepayAdjustment {
    public PrepayAdjustmentId: number;
    public Date: Date;
    public PrepayAdjAmt: number;
    public Comment: string;
}

export class SpreadMaintenanceSchedule {
    public SpreadMaintenanceScheduleId: number;
    public SpreadDate: Date;
    public NoteId: string;
    public CRENoteID: string;
    public Spread: number;
    public CalcAfterPayoff: boolean;
}

export class MinMultSchedule {
    public MinMultScheduleID: number;
    public MiniSpreadDate: Date;
    public MinMultAmount: number;

}

export class FeeCredits {
    public FeeCreditsID: number;
    public UseActualFees: boolean;
    public FeeCreditOverride: number;
    public FeeTypeNameText: number;

}

export class PrepayProjection {
    public DealPrepayProjectionID: number;
    public DealID: string;
    public PrepayDate: Date;
    public PrepayPremium_RemainingSpread: number;
    public UPB:number
    public OpenPrepaymentDate: Date
    public TotalPayoff: number

}