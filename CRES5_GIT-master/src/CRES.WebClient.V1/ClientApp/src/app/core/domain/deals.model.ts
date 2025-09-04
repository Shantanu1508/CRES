import { Note, TagMasterXIRR } from "./note.model";

export class deals {
  public DealID: string;
  public DealAccountID: string;
  public DealName!: string;
  public DealType!: number;
  public DealTypeText!: string;
  public LoanProgram!: number;
  public LoanProgramText!: string;
  public LoanPurpose!: number;
  public LoanPurposeText!: string;

  public Statusid!: number;
  public StatusText!: string;
  public ScenarioIdPrepay!: string;
  public SendEmailAfterCalc!: string;
  
  public LiabilitySource!: number;
  public LiabilitySourceText!: string;  

  public AppReceived!: Date;
  public EstClosingDate!: Date;
  public BorrowerRequest!: number;
  public BorrowerRequestText!: string;
  public RecommendedLoan!: number;
  public TotalFutureFunding!: number;
  public Source!: number;
  public SourceText!: string;
  public BrokerageFirm!: number;
  public BrokerageContact!: string;
  public Principal!: string;
  public Sponsor!: string;
  public NetWorth!: number;
  public Liquidity!: number;
  public ClientDealID!: string;
  public CREDealID!: string;
  public TotalCommitment!: string;
  public AdjustedTotalCommitment!: string;
  public AggregatedTotal!: number;
  public AssetManagerComment!: string;
  public LinkedDealID!: string;
  public AllowSizerUpload!: number;
  public AssetManager!: string;
  public AssetManagerID!: string;
  public AMTeamLeadUserID!: string;
  public AMSecondUserID!: string;
  public DealCity!: string;
  public DealState!: string;
  public DealPropertyType!: string;
  public FullyExtMaturityDate!: Date;
  public LastUpdatedFF!: Date;
  public UnderwritingStatusid !: number;
  public UnderwritingStatusidText!: string;
  public DealComment!: string;
  public LastUpdatedByFF!: string;
  public LastUpdatedFF_String!: string;
  public CopyDealID!: string;
  public CopyDealName!: string;
  public AnalysisID!: string;
  public EnableAutoSpread!: boolean;

  public ServicerDropDate!: number;
  public ServicereDayAjustement!: number;
  public FirstPaymentDate!: Date;

  public currentUserName!: string;
  public currentUserID!: string;

  public isLiabilityTabCLicked!: boolean;
  public ListHoliday!: any;
  public CalcEngineType: number;
  PayruleDealFundingList!: Array<DealFunding>;
  DeletedDealFundingList!: Array<DealFunding>;
  PayruleTargetNoteFundingScheduleList!: Array<Notefunding>;
  PayruleNoteAMSequenceList!: Array<NoteSequence>;
  AmortSequenceList!: Array<NoteSequence>;
  PayruleNoteDetailFundingList!: Array<NoteDetailFunding>;
  PayruleSetupList!: Array<PayruleSetMaster>;
  notelist!: Array<Note>;
  BoxDocumentLink!: string;
  public DealGroupID!: string;
  public DealRule!: string;
  public maxMaturityDate!: Date;
  ShowUseRuleN!: boolean;
  AutoSpreadRuleList!: Array<AutoSpreadRule>;
  ServicingWatchlistLegal!: Array<ServicingWatchlistDataContract>;
  ServicingWatchlistAccounting!: Array<ServicingWatchlistDataContract>;
  ServicingPotentialImpairment!: Array<ServicingWatchlistDataContract>;
  ListDealLiability!: Array<DealLiabilityDataContract>;
  ListDealLiabilityDupliateCheck!: Array<DealLiabilityDataContract>;
  ListLiabilityFundingSchedule!: Array<LiabilityFundingSchedule>;
  public envname!: string;
  amort: Amort;
  PrepaymentPremium: PrepaymentPremium;
  Flag_DealFundingSave: boolean = false;
  Flag_NoteSaveFromDealDetail: boolean = false;
  Flag_DealAmortSave: boolean = false;
  public BaseCurrencyName!: string;
  //   public EquityAmount!: number;
  public RemainingAmount!: number;
  public Listadjustedtotlacommitment!: Array<DealAdjustedTotalCommitmentTab>;
  public DeleteAdjustedTotalCommitment!: Array<DealAdjustedTotalCommitmentTab>;
  public IsPayruleClicked!: string;
  public RequiredEquity!: number;
  public AdditionalEquity!: number;
  public EnableAutospreadRepayments!: boolean;
  public AutoUpdateFromUnderwriting!: boolean;
  public EnableAutospreadRepayments_db: boolean;
  public ExpectedFullRepaymentDate!: Date;
  public RepaymentAutoSpreadMethodID!: number;
  public RepaymentAutoSpreadMethodText!: string;
  public RepaymentStartDate!: Date;
  public EarliestPossibleRepaymentDate!: Date;
  public Blockoutperiod !: number | null;
  public PossibleRepaymentdayofthemonth!: number;
  public Repaymentallocationfrequency!: number;
  public AutoPrepayEffectiveDate!: Date;
  public LatestPossibleRepaymentDate!: Date;
  public ListProjectedPayoff!: Array<ProjectedPayoffDate>;
  public ListAutoRepaymentBalances!: Array<AutoRepaymentBalances>;
  public ListNoteRepaymentBalances!: Array<AutoRepaymentNoteBalances>;
  public ListLiabilityNoteAssetMapping!: Array<LiabilityNoteAssetMapping>;
  public KnownFullPayoffDate!: Date;
  public AllowFundingDevDataFlag!: boolean;
  public AllowFFSaveJsonIntoBlob!: boolean;
  public ListFeeInvoice: any = [];
  public EnableAutospreadUseRuleN!: boolean;
  public LastWireConfirmDate_db: Date;
  public ApplyNoteLevelPaydowns!: boolean;
  public DealLevelMaturity!: boolean;
  public MaturityList: any = [];
  public ReserveAccountList: any = [];
  public ReserveScheduleList: any = [];
  public IsREODeal!: boolean;
  public BalanceAware: boolean;
  public RepayExpectedMaturityDate!: Date;
  public PropertyTypeID: number;
  public LoanStatusID: number;
  public max_ExtensionMat: Date;
  public PrePayDate: Date;
  public ICMFullyFundedEquity: number;
  public EquityatClosing: number;
  public EnableM61Calculator: boolean;
  public Listnoteid: any = [];
  public LastAccountingclosedate: Date;

  public InternalRefi!: number;
  public PortfolioLoan!: number;
  public AssigningLoanToTakeoutLender!: number;
  public NettingofReservesEscrows!: number;

  public InternalRefiText!: string;
  public PortfolioLoanText!: string;
  public AssigningLoanToTakeoutLenderText!: string;
  public NettingofReservesEscrowsText!: string;


  public WatchlistStatusID!: number;
  public WatchlistStatusText!: string;
  public IsServicingWatchlisttabClicked!: boolean;
  public ServicingPotentialImpairmentList: any = [];
  public DeleteServicingPotentialImpairment: any = [];
  public ListSelectedXIRRTags: Array<TagMasterXIRR>;
  XIRRCalculationRequests!: XIRRCalculationRequests;
  public XIRRValue!: number
  AutoDistributeWriteoffList!: Array<AutoDistributeWriteoff>;
  public XIRROverride: any = [];
  public EnableAutoDistributePrincipalWriteoff!: boolean;

  ListRevolverDealFunding!: Array<DealFunding>;
  ListRevolverNoteFunding!: Array<Notefunding>;
  DealRelationshipList!: Array<DealRelationship>;

  public dtPrepaymentGroup: any = [];
  public dtPrepaymentNote: any = [];
  public dtPrepaymentNoteAlloc: any = [];
  public dtPayoffStatementFees: any = [];

  PrepaymentGroupSize: number;
  PrepaymentAllocationMethod: number;
  public Bookmark: string;
  public MaturityAdjMonthsOverride: number;
  public ExcludeDealFromLiability!: boolean;
  public isPipeline: string;
  constructor(DealID: string) {
    this.DealID = DealID;
    this.amort = new Amort();
    this.PrepaymentPremium = new PrepaymentPremium();
  }
}

export class DealFunding {
  public DealFundingID!: string;
  public DealID: string;
  public Date!: Date;
  public Amount!: number;
  public Comment!: string;
  public CreatedBy!: string;
  public CreatedDate!: Date;
  public UpdatedBy!: string;
  public UpdatedDate!: Date;
  public PurposeID!: number;
  public PurposeText!: string;
  public Applied!: boolean;
  public Issaved!: boolean;
  public DrawFundingId!: string;
  public Comments!: string;
  public WF_CurrentStatus!: string;
  public OldComment!: string;
  public DrawFeeStatus!: number;
  public DrawFeeStatusName!: string;
  public DrawFeeFile!: string;
  public IsRowEdited!: boolean;
  public IsShowDrawStatus!: boolean;
  public NonCommitmentAdj: boolean;
  public AdjustmentType: number;
  public _isSoftHoliday!: boolean;
  constructor(DealID: string) {
    this.DealID = DealID;
  }
}
export class Notefunding {
  public NoteID!: string;
  public Value!: string;
  public Date!: Date;
  public NoteName!: string;
  public isDeleted!: number
  public PurposeID!: number;
  public Purpose!: string;
  public DealFundingRowno!: number;
  public DealFundingID!: string;
  public Applied!: boolean;
  public NonCommitmentAdj!: boolean;
  public AdjustmentType: number;
  public Comments!: string;
  public GeneratedByText: string;
  public GeneratedByUserID: string;
  public GeneratedBy: number;
}

export class NoteSequence {
  public NoteID!: string;
  public SequenceNo!: number;
  public SequenceType!: string;
  public SequenceTypeText!: string;
  public Value!: number;
  public Ratio: number = 0;
}

export class XIRRCalculationRequests {
  public XIRRConfigID!: number;
  public ObjectID!: string;

}
export class NoteDetailFunding {
  public NoteID!: string;
  public CRENoteID!: string;
  public NoteName!: string;
  public UseRuletoDetermineNoteFundingText!: string;
  public UseRuletoDetermineNoteFunding!: string;
  public NoteFundingRule!: string;
  public NoteFundingRuleText!: string;
  public NoteBalanceCap!: string;
  public FundingPriority!: string;
  public RepaymentPriority!: string;
}

export class PayruleSetMaster {
  StripTransferFrom!: string;
  StripTransferTo!: string;
  DealID!: string;
  Amount!: string;
  Value!: string;
  RuleID!: string;
  RuleIDText!: string;

}

export class AutoSpreadRule {
  UserID!: string;
  DealID!: string;
  AutoSpreadRuleID!: string;
  PurposeType!: number;
  DebtAmount!: number;
  // EquityAmount!: number;
  StartDate!: Date;
  EndDate!: Date;
  DistributionMethod!: number;
  FrequencyFactor!: number;
  Comment!: string;
  PurposeTypeText!: string;
  DistributionMethodText!: string;
  public RequiredEquity!: number;
  public AdditionalEquity!: number;
  public _isSoftHolidayStart!: boolean;
  public _isSoftHolidayEnd!: boolean;
}

export class ServicingWatchlistDataContract {
  public DealID!: string;
  public StartDate!: Date;
  public EndDate!: Date;
  public TypeID!: number;
  public TypeText!: string;
  public Comment!: string;
  public EffectiveDate!: Date;
  public Amount!: number;
  public IsDeleted!: boolean;

}

export class DealAmortization {
  public DealAmortizationScheduleID!: string;
  //  public DealAmortizationScheduleAutoID!: number;
  public DealID!: string;
  public DealAmortScheduleRowno!: number;
  public Date!: Date;
  public Amount!: number;
  public CreatedBy!: string;
  public CreatedDate!: Date;
  public UpdatedBy!: string;
  public UpdatedDate!: Date;
  public IsDelete!: boolean;


}

export class NoteAmortization {
  public DealAmortizationScheduleID!: string;
  public DealAmortizationScheduleAutoID!: number;
  public DealID!: string;
  public Date!: Date;
  public Value!: number;
  public NoteName!: string;
  public DealAmortScheduleRowno!: number;
  public CreatedBy!: string;
  public CreatedDate!: Date;
  public UpdatedBy!: string;
  public UpdatedDate!: Date;
  public NoteID!: string;
  public CRENoteID!: string;

}


//export class PayruleDealFunding {
//    public DealFundingID!: string;
//    public DealID!: string;
//    public Date!: Date;
//    public Value!: number;
//    public Comment!: string;
//    public PurposeID!: number;
//    public PurposeText!: string;
//    public CreatedBy!: string;
//    public CreatedDate!: Date;
//    public UpdatedBy!: string;
//    public UpdatedDate!: Date;
//}
export class Amort {
  //constructor() {
  //    this.AmortizationMethod = 0;
  //    this.AmortizationMethodText = "";
  //}
  public dt!: any;
  public AmortizationMethod!: number;
  public AmortizationMethodText!: string;
  public ReduceAmortizationForCurtailments!: number;
  public ReduceAmortizationForCurtailmentsText!: string;
  public BusinessDayAdjustmentForAmort!: number;
  public BusinessDayAdjustmentForAmortText!: string;
  public NoteDistributionMethod!: number;
  public NoteDistributionMethodText!: string;
  public PeriodicStraightLineAmortOverride!: number;
  public FixedPeriodicPayment!: number;
  public AmortSequenceList!: Array<NoteSequence>;
  public NoteListForDealAmort!: Array<NoteAmort>;
  public DealAmortScheduleList!: Array<DealAmortization>;
  public NoteAmortScheduleList!: Array<NoteAmortization>;
  public MutipleNoteIds!: string;
}



export class NoteAmort {
  public NoteID!: string;
  public CRENoteID!: string;
  public Name!: string;
  public MaturityDate!: Date;
  public LienPosition!: number;
  public LienPositionText!: string;
  public Priority!: number;
  public IOTerm!: number;
  public AmortRate!: number;
  public TotalCommitment!: number;
  public EstimatedCurrentBalance!: number;
  public AmortTerm!: number;
  public UseRuletoDetermineAmortizationText!: string;
  public UseRuletoDetermineAmortization!: string;
  public RoundingNoteText!: string;
  public RoundingNote!: number;
  public StraightLineAmortOverride!: number;
}

export class DealAdjustedTotalCommitmentTab {
  public DealID!: string;
  public NoteAdjustedCommitmentMasterID!: number;
  public CRENoteID!: string;
  public NoteID!: string;
  public Date!: Date;
  public Type!: number;
  public Rownumber!: number;
  public DealAdjustmentHistory!: number;
  public AdjustedCommitment!: number;
  public TotalCommitment!: number;
  public AggregatedCommitment!: number;
  public Comments!: string;
  public Amount!: number;
  public TypeText!: string;
  public NoteAdjustedTotalCommitment!: number;
  public NoteAggregatedTotalCommitment!: number;
  public NoteTotalCommitment!: number;
  public TotalRequiredEquity!: number;
  public TotalAdditionalEquity!: number;
  public TotalEquityatClosing: number;
  public ExcludeFromCommitmentCalculation: number;
}


export class AutoEquity {
  public EquityName!: string;
  public TotalCommitted!: number;
  public TotalContibutedDate!: number;
  public RemainingtoContribute!: number;
  public Percentcontributed!: number;
}

export class ProjectedPayoffDate {
  public DealID!: string;
  public ProjectedPayoffAsofDate!: Date;
  public CumulativeProbability!: number;
}

export class AutoRepaymentBalances {
  public DealID!: string;
  public Date!: Date;
  public Amount!: Date;
  public Type!: string;
}

export class AutoRepaymentNoteBalances {
  public NoteID!: string;
  public Date!: Date;
  public Amount: number;
  public Type!: string;
}

export class PrepaymentPremium {

  public PrepayScheduleId: number;
  public EventDealId: number;
  public DealID: string;
  public PrePayDate: Date;
  public EffectiveDate: Date;
  public CalcThru: Date;
  public PrepaymentMethod: number;
  public BaseAmount: number;
  public SpreadCalcMethod: number;
  public GreaterOfSMOrBaseAmtTimeSpread: boolean;
  public HasNoteLevelSMSchedule: boolean;
  public Includefeesincredits: boolean;
  public RemainingSpread: number;
  public MinimumMultipleDue: number;
  public OpenPaymentDate: Date;
  public PrepayDate: Date;
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
  public UPB: number
  public OpenPrepaymentDate: Date
  public TotalPayoff: number

}
export class DealLiabilityDataContract {
  public LiabilityNoteAutoID: string;
  public LiabilityNoteAccountID: string;
  public LiabilityNoteID: string;
  public LiabilityNoteName: string;
  public DealAccountID: string;
  public AssetID: string;
  public AssetNotes: string;
  public PledgeDate: Date;
  public MaturityDate: Date;
  public PaydownAdvanceRate: number;
  public FundingAdvanceRate: number;
  public CurrentAdvanceRate: number;
  public TargetAdvanceRate: number;
  public CurrentLiabilityNoteBalance: number;
  public UndrawnCapacity: number;
  public modulename: string;
  public IsDeleted!: boolean;
}

export class LiabilityNoteAssetMapping {
  public LiabilityNoteId: string;
  public DealAccountId: string;
  public LiabilityNoteAccountId: string;
  public AssetAccountId: string;
}

export class LiabilityFundingSchedule {
  public LiabilityNoteID: string;
  public LiabilityNoteAccountID: string;
  public LiabilityNoteName: string;
  public TransactionDate!: Date;
  public TransactionAmount!: number;
  public WorkflowStatus!: number;
  public WorkflowStatusText: string;
  public GeneratedBy!: number;
  public GeneratedByText: string;
  public Status!: number;
  public StatusText: string;
  public Comments: string;
  public AssetAccountID: string;
  public AssetName: string;
  public AssetTransactionDate!: Date;
  public AssetTransactionAmount!: number;
  public TransactionAdvanceRate!: number;
  public CumulativeAdvanceRate !: number;
  public AssetTransactionComment: string;
  public RowNo!: number;
  public CreatedBy: string;
  public CreatedDate: Date;
  public UpdatedBy: string;
  public UpdatedDate: Date;

}

export class AutoDistributeWriteoff {
  public UserID!: string;
  public DealID!: string;
  public NoteID!: string;
  public CRENoteID!: string;
  public NoteName!: string;
  public LienPosition!: string;
  public PriorityOverride!: number;
  public Priority!: number;
  public EstBls!: number;
}

export class ServicingPotentialWriteoffList {

  public WLDealPotentialImpairmentID!: string;
  public DealID!: string;
  public Date!: Date;
  public Value!: number;
  public AdjustmentType!: number;
  public AdjustmentTypeText!: string;
  public Comment!: string;
  public RowNo!: number;
  public Applied!: boolean;
  public NoteID!: string;
  public CRENoteID!: string;
  public Notename!: string;
  public UserID!: string;
  public IsDeleted!: number;
}


export class PrincipalWriteoff {
  AutoDistributeWriteoffList!: Array<AutoDistributeWriteoff>;
  ServicingPotentialDealWriteoffList!: Array<ServicingPotentialWriteoffList>;
  ServicingPotentialNoteWriteoffList!: Array<ServicingPotentialWriteoffList>;
}

export class DealRelationship {
  public DealID!: string;
  public RelationshipID!: number;
  public LinkedDealID!: string;
}

export class ReserveAccountSync {
  public DealID!: string;
}
