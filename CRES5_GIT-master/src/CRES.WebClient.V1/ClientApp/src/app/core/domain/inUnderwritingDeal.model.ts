export class IN_UnderwritingDeal {


  public IN_UnderwritingDealID: string;
  public ClientDealID: string;
  public DealName: string;

  public ClientNoteID: string;
  public StatusID: number;
  public AssetManager: string;
  public DealCity: string;
  public DealState: string;
  public DealPropertyType: string;
  public TotalCommitment: number;
  public FullyExtMaturityDate: Date;

  public CreatedBy: string;
  public CreatedDate: Date;
  public UpdatedBy: string;
  public UpdatedDate: Date;


  constructor(IN_UnderwritingDealID: string) {

    this.IN_UnderwritingDealID = IN_UnderwritingDealID;

  }
}
