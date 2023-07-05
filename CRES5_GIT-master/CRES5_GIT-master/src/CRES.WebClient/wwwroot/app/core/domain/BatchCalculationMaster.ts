export class BatchCalculationMaster {
    public AnalysisID: string;
    public Name: string;
    public BatchCalculationMasterID: number;
    public BatchCalculationMasterGUID: string;
    public StartTime: Date;
    public EndTime: Date;
    public Total: number;
    public TotalCompleted: number;
    public TotalFailed: number;
    public BatchType: string;
    public UserID: string;
    public Status: string;
    constructor(name: string) {
        this.Name = name;
    }
}