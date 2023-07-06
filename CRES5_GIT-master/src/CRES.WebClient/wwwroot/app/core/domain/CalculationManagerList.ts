export class CalculationManagerList {


    public CalculationRequestID: string;
    public NoteId: string;
    public NoteName: string;
    public RequestTime: Date;
    public StatusID: Number;
    public StatusText: string;
    public UserName: string;
    public ApplicationID: Number;
    public ApplicationText: string;
    public StartTime: Date;
    public EndTime: Date;
    public PriorityID: Number;
    public PriorityText: string;
    public ErrorMessage: string;
    public ErrorDetails: string;
     public Active: boolean;
    public DealId: string;
    public DealName: string;
    public CRENoteID: string;

    public AnalysisID: string;
    public PortfolioMasterGuid: string;

    public CalculationModeID: number
    public CalculationModeText: number
    public BatchType: string;

    public UserID: string;
    public FileName: string;
    public EnableM61Calculations: number;
    public EnableM61CalculationsText: string;
    public downloadnote: boolean;
    public PayOffDate: Date;
    public IsPaidOffDeal: boolean;
    constructor(NoteName: string) {
        this.NoteName = NoteName;
    }
}


 


