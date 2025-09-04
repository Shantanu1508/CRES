export class LiabilityCalcStatus {
  public value!: Number;
  public Name!: string;
  public vDate!: Date;
  public LiabilityID!: string;
  public LiabilityName!: string;
  public StatusText!: string;
  public RequestTime!: Date;
  public ProcessType!: string;
  public ErrorMessage!: string;
  public ScenarioID!: string;
  public UserID!: string;
  public CalcStatus!: string;
  public LastUpdated!: Date;
  public RequestBy!: string;
  public IsEnable!: Number;
  public CalcEngineTypeText!: string;
  public StartTime!: Date;
  public EndTime!: Date;
  public AnalysisID!: string;
  public Active!: boolean;
  public AccountID!: string;
  constructor(AnalysisID: string) {
    this.AnalysisID = AnalysisID;
  }
}
