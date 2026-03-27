export class liabilityNote {
  public LiabilityNoteID: string;
  public OriginalLiabilityNoteID: string;  
  public LiabilityName: string;
  public AssetAccountID: string;
  public LiabilityTypeGUID: string;  
  public Applied: number;
  public CurrentAdvanceRate: number; 
  public CurrentBalance: number;
  public UndrawnCapacity: number;
  public LiabilityTypeID: string;
  public LiabilityTypeText: string;
  public DealAccountID: string;
  public LiabilityNoteAccountID: string;
  public LiabilityNoteGUID: string;
  public PledgeDate: Date;  
  public LatestEffectiveDaterateSchedule: Date;
  public EffectiveDateFeeSchedule: Date;
  public modulename: string;
  public pagesIndex: number;
  public pagesSize: number;
  public AnalysisID: string;
  public PaydownAdvanceRate: number;
  public FundingAdvanceRate: number;
  public TargetAdvanceRate: number;
  public MaturityDate: Date;
  public CreatedBy: string;
  public CreatedDate: Date;
  public UpdatedBy: string;
  public Status: string;
  
  public Type: string;
  public ListLiabilityRate!: any;
  public FeeScheduleList!: any;
  public UpdatedDate: Date;
  public ThirdPartyOwnership: number;
  public LiabilityAssetMap!: any;

  public DefaultIndexName :number;
  public FinanacingSpreadRate: number;
  public AccrualFrequency: number;

  public AccrualEndDateBusinessDayLag :number;
  public RoundingMethod :number;
  public PayFrequency :number;
  public IndexRoundingRule :number;
  public IntCalcMethod: number;
  public AccountTypeText: string;
  public EffectiveDate: Date;
  public UseNoteLevelOverride: boolean;
  public DebtEquityTypeID: number;
  public ListInterestExpense: any = [];

  public InterestExpenseScheduleID!: number;
  public SelectedEventID: string;
  public SelectedEffectiveDate: Date;
  public SelectedInitialInterestAccrualEnddate :Date;
  public SelectedPaymentDayMonth: number;
  public SelectedPaymentDateBusinessDayLag: number;
  public SelectedDeterminationdateleaddays :number;
  public SelectedDeterminationDateRefDayMonth :number;
  public SelectedInitialIndexValueOverride: number;
  public SelectedRecourse: number;
  public SelectedFirstRateIndexResetDate: Date;
  public SelectedAdditionalAccountID: string;

  public pmtdtaccper: number;
  public ResetIndexDaily: number;
  public LiabilitySource!: number;
  public LiabilitySourceText!: string;
  public ListPrepayAndAdditionalFeeScheduleLiabilityDetail!: any;
  constructor(LiabilityNoteID: string) {
    this.LiabilityNoteID = LiabilityNoteID;
  }
}

export class rateSpread {
  public EffectiveDate!: Date;
  public Date!: Date; 
  public ValueType!: number; 
  public ValueTypeText: string; 
  public Value!: number; 
  public CalcMethod!: number; 
  public CalcMethodText: string; 
  public RateOrSpreadStripped!: number; 
  public IndexName!: number; 
  public IndexNameText: string; 
  public DeterminationDateHolidayList!: number; 
  public DeterminationDateHolidayListText: string;
  public IsDeleted: boolean;
  public CreatedBy: string; 
  public CreatedDate!: Date; 
  public UpdatedBy: string; 
  public UpdatedDate!: Date; 
}
