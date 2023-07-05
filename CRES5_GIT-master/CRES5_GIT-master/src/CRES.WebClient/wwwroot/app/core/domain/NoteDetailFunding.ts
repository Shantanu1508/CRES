
export class notedetailfunding {
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
    public TotalCommitment: string;

    public Lienposition:string
    public Priority: string
    public InitialFundingAmount: string

    public AggregatedTotal: string;
    public AdjustedTotalCommitment: string;
    public CommitmentUsedInFFDistribution: string;


constructor(NoteID: string) {

        this.NoteID = NoteID;

    }
}