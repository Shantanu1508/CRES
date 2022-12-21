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

  public ScenarioColor !: string;
  public UserID !: string;
  public UseActuals !: number;
  public UseActualsText !: string;
  public UseBusinessDayAdjustment !: number;
  public UseBusinessDayAdjustmentText !: string;


  LstScenarioUserMap: Array<ScenarioUserMap>;

  public CalculationModeID !: number

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

