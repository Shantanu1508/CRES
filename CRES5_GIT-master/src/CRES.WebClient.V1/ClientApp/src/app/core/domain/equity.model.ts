import { TagMasterXIRR } from "./note.model";
export class equity {

public EquityGUID: string;
  public EquityName: string;
  public OriginalEquityName: string;  
  public EquityTypeText: string;
  public EquityAccountID: string;
  public FacilityAccountID: string;
  public EquityType!: number;
  public Status!: number;
  public StatusText: string;
  public CurrencyText: string;
  public Currency!: number;
  public InvestorCapital!: number;
  public CapitalReserveRequirement!: number;
  public ReserveRequirement!: number;
  public CommittedCapital!: number;
  public CapitalReserve!: number;
  public UncommittedCapital!: number;
  public CapitalCallNoticeBusinessDays!: number;
  public EarliestEquityArrival!: Date;
  public InceptionDate!: Date;
  public LastDatetoInvest!: Date;
  public FundBalanceexcludingReserves!: number;
  public LinkedShortTermBorrowingFacilityID: string;
  public LinkedShortTermBorrowingFacilityText: string;
  public CreatedBy: string;
  public CreatedDate!: Date;
  public UpdatedBy: string;
  public UpdatedDate!: Date;
  public modulename: string;
  public pagesIndex: number;
  public pagesSize: number;
  public EffectiveDate: Date;
  public Commitment: number;
  public InitialMaturityDate: Date;
  public ErrorMessage: string;
  public FundDelay: number;
  public FundingDay: number;
  AdditionalTransList!: Array<AdditionalTransaction>;
  public ListSelectedXIRRTags: Array<TagMasterXIRR>;
  liabilityMasterFunding: any;
  ListLiabilityFundingSchedule: any;
  public CalcAsOfDate!: Date;
  public FileName: string;
  public CashAccount: string;
  public CashAccountID: string;
  public AbbreviationName: string;
  public EffectiveDateFeeSchedule: Date;
  public LatestEffectiveDaterateSchedule: Date;
  public ListLiabilityRate!: any;
  public FeeScheduleList!: any;
  public FacilityFeeScheduleList!: any;
  public FacilityRateSpreadScheduleList!: any;
  public DebtExtDataList!: any;
  public ListDealLevelLiabilityFundingSchedule!: any;
  public ListInterestExpense!: any;
  public StructureText: string;
  public StructureID!: number;
  public ListPrepayAndAdditionalFeeScheduleLiabilityDetail!: any;
}

export class AdditionalTransaction {
  public TransactionDate: Date;
  public TransactionAmount: number;
  public TransactionType: number;
  public TransactionTypeText: string;
  public Comments: string;
}

export class equityAssets {
  public EquityNoteID: string;
  public EquityNoteName: string;
  public AssetID: string;
  public InitialInvestmentDate!: Date;
  public MaturityDate!: Date;
  public CreatedBy: string;
  public CreatedDate!: Date;
  public UpdatedBy: string;
  public UpdatedDate!: Date;
}

export class equityCapContriDistb {
  public EquityNoteID: string;
  public EquityNoteName: string;
  public TransactionDate!: Date;
  public TransactionAmount!: number;
  public WorkflowStatus!: number;
  public WorkflowStatusText: string;
  public GeneratedBy!: number;
  public GeneratedByText: string;
  public Status!: number;
  public StatusText: string;
  public Comments: string;
  public AssetID: string;
  public AssetName: string;
  public AssetTransactionDate!: Date;
  public AssetTransactionAmount!: number;
  public TransactionAdvanceRate!: number;
  public CummlativeAdvanceRate!: number;
  public AssetTransactionComments: string;
  public CreatedBy: string;
  public CreatedDate!: Date;
  public UpdatedBy: string;
  public UpdatedDate!: Date;
}

export class equityCashflow {
  public BorrowerNoteID: string;
  public TransactionDate!: Date;
  public TransactionAmount!: number;
  public EndingBalance!: number;
  public TransactionTypeText: string;
  public TransactionType!: number;
  public SpreadRate!: number;
  public Index!: number;
  public FeeName: string;
  public RemitDate!: Date;
  public Comment: string;
  public EquityNoteID: string;
}


