export class Scenario {
  public AnalysisID : string;
  public ScenarioName !: string;
  public StatusID !: number;
  public Description !: string;
  public AnalysisParameterID !: string;
  public MaturityScenarioOverrideID !: number;
  public MaturityScenarioOverrideText !: string;
  public MaturityAdjustment !: string;
  public ActionStatus !: string;

  public FunctionName !: string;
  public IndexScenarioOverride !: number
  public IndexScenarioOverrideText !: string;
  public CalculationMode !: number
  public CalculationModeText !: string;
  public ExcludedForcastedPrePayment !: number
  public ExcludedForcastedPrePaymentText !: string;
  public AutoCalcFreq !: number;
  public AutoCalcFreqText !: string;
  public IncludeProjectedPrincipalWriteoff: number;
  public IncludeProjectedPrincipalWriteoffText: string;
  public ScenarioColor !: string;
  public UserID !: string;
  public UseActuals !: number;
  public UseActualsText !: string;
  public UseBusinessDayAdjustment !: number;
  public UseBusinessDayAdjustmentText !: string;
  public DisableBusinessDayAdjustment !: number;
  public CalcEngineType: number;
  public CalcEngineTypeText: string;
  public CalculationFrequency: number;
  public CalculationFrequencyText: string;
  public AllowCalcOverride: number;
  public AllowCalcAlongWithDefault: number;
  public AccountingClose: number;
  public CalculateLiability: number;
  public CalculateLiabilityText: string;
  public ScenarioStatus: number;
  public ScenarioStatusText: string;
  public UseFinancingMaturityDateOverride: number;
  public UseFinancingMaturityDateOverrideText: string;
  public UseMaturityAdjustmentMonths: number;
  public UseMaturityAdjustmentMonthsText: string;
  LstScenarioUserMap: Array<ScenarioUserMap>;

  public LastCalculatedDate: Date;
  public IncludeInDiscrepancyText !: string;
  public IncludeInDiscrepancy !: number;

  public CalculationModeID !: number;
  public jsonparam: string;

  public OperationMode: string;
  public EqDelayMonths !: number;
  public FinDelayMonths !: number;
  public MinEqBalForFinStart !: number;
  public SublineEqApplyMonths !: number;
  public SublineFinApplyMonths !: number;
  public DebtCallDaysOfTheMonth !: number;
  public CapitalCallDaysOfTheMonth !: number;
  constructor(AnalysisID: string) {
    this.AnalysisID = AnalysisID;
    this.LstScenarioUserMap = new Array<ScenarioUserMap>();
  }
}
export class Scenariosearch {
  public AnalysisID !: string;
  public Fromdate?: Date;
  public Todate?: Date;

  public Description !: string;
  public ScenarioName !: string;
  public ScenarioColor !: string;

}


export class ScenarioUserMap {
  public AnalysisID: string;

  public Description !: string;
  public ScenarioName !: string;
  public ScenarioColor !: string;

  public CalculationModeID !: number
  public CalculationModeText !: string

  constructor(AnalysisID: string) {
    this.AnalysisID = AnalysisID;
  }
}

export class RuleType {
  public RuleTypeMasterID: number;
  public RuleTypeDetailID: number;
  public AnalysisID: string
  public NoteID: string
  public DealID: string

}
