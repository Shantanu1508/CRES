export class Debt {
  public DebtID: string;
  public DebtName: string;
  public OriginalDebtName: string;
  public DebtTypeText: string;
  public DebtAccountID: string;
  public DebtType: number;
  public Applied: number;
  public CurrencyText: string;
  public Currency: number;
  public CurrentCommitment: number;
  public FundingNoticeBusinessDays: number;
  public EarliestFinancingArrival: Date;
  public CurrentBalance!: number;
  public OriginationFees: number;
  public OriginationDate: Date;
  public RateTypeText: string;
  public RateType: number;
  public Spread: number;
  public Index: number;
  public IntCalcMethod: string;
  public IntCalcMethodText: string;
  public PayFrequency: number;
  public DrawLag: number;
  public PaydownDelay: number;
  public AccountID: string;
  public MatchTermsText: string;
  public MatchTerms: number;
  public IsRevolving: number;
  public IsRevolvingText: string;
  public MaxAdvanceRate: number;
  public TargetAdvanceRate: number;
  public DefaultIndexNameText: string;
  public DefaultIndexName: number;
  public FinanacingSpreadRate: number;
  public CreatedBy: string;
  public CreatedDate: Date;
  public UpdatedBy: string;
  public UpdatedDate: Date;
  public InitialInterestAccrualEnddate: Date;
  public AccrualFrequency: number;
  public AccrualFrequencyText: string;
  public Status: string;
  
  public PaymentDayMonth: number;
  public PaymentDateBusinessDayLag: number;
  public Determinationdateleaddays: number;
  public DeterminationDateRefDayMonth: number;
  public RateIndexResetFreq: number;
  public RoundingMethod: number;
  public RoundingMethodText: string;
  public IndexRoundingRule: number;
  public IndexRoundingRuleText: string;
  public ExpenseRateType: number;
  public ExpenseRateTypeText: string;
  public InitialFundingDelay: number;
  public EffectiveDate: Date;
  public Commitment: number;
  public InitialMaturityDate: Date;
  public EffectiveDateFeeSchedule: Date;
  public LatestEffectiveDaterateSchedule: Date;
  public modulename: string;
  public pagesIndex: number;
  public pagesSize: number;
  public ExitFee: number;
  public ExtensionFees: number;
  public FundDelay: number;
  public FundingDay: number;
  public AdditionalTransList!: Array<AdditionalTransaction>;
  public FeeScheduleList!: Array<FeeSchedule>;
  public ListLiabilityRate!: any;
  public ListLiabilityFundingSchedule!: Array<LiabilityFundingSchedule>;
  public ListSelectedXIRRTags: Array<TagMasterXIRR>;
  liabilityMasterFunding: any;
  liabilityDetailFunding: any;
  public CashAccount: string;
  public CashAccountID: string;
  public AdditionalAccountID: string;
  public DebtExtDataList!: any;
  public BankerID: number;
  public BankerText: string;
  public ListDealLevelLiabilityFundingSchedule!: any;
  public ListInterestExpense!: any;
  public AbbreviationName: string;
  public LinkedFundID: string;
  public ListPrepayAndAdditionalFeeScheduleLiabilityDetail!: any;
  constructor(DebtID: string) {
    this.DebtID = DebtID;
  }
}

export class TagMasterXIRR {
  TagMasterXIRRID: number;
  Name: string;
  CreatedBy: string;
  CreatedDate: Date;
  UpdatedBy: string;
  UpdatedDate: Date;
}
export class AdditionalTransaction {
  public TransactionDate: Date;
  public TransactionAmount: number;
  public TransactionType: number;
  public TransactionTypeText: string;
  public IncludeLevelYield: number;
  public Comments: string;
  public CreatedBy: string;
  public CreatedDate: Date;
  public UpdatedBy: string;
  public UpdatedDate: Date;
}

export class FeeSchedule {
  public EffectiveDate: Date;
  public FeeName: string;
  public StartDate!: Date;
  public EndDate!: Date;
  public ValueTypeID!: number;
  public FeeTypeText!: string;
  public Fee!: number;
  public FeeAmountOverride!: number;
  public BaseAmountOverride!: number;
  public ApplyTrueUpFeatureID!: number;
  public ApplyTrueUpFeatureText!: string;
  public IncludedLevelYield!: number;
  public PercentageOfFeeToBeStripped!: number;
  public IsDeleted!: boolean;
  public CreatedBy: string;
  public CreatedDate!: Date;
  public UpdatedBy: string;
  public UpdatedDate!: Date;
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
