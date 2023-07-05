export class DealFunding {
    public DealFundingID: string;
    public DealID: string;
    public Date: string;
    public Amount: number;
    public Applied: boolean;
    public CreatedBy: string;
    public CreatedDate: Date;
    public UpdatedBy: string;
    public UpdatedDate: Date;
    public isdirty: boolean;
    public PurposeText: string;
    public PurposeID: number;
    public DrawFundingId: string;
    constructor(DealID: string) {

        this.DealID = DealID;

    }

}











