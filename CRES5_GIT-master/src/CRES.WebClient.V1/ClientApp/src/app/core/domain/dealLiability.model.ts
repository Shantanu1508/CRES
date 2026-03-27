export class dealLiability {
  public LiabilityNoteID: string; 
  public LiabilityNoteName: string; 
  public AssetID: string; 
  public PledgeDate!: Date; 
  public MaturityDate!: Date;
  public PaydownAdvanceRate!: number; 
  public FundingAdvanceRate!: number;  
  public CurrentAdvanceRate!: number;  
  public TargetAdvanceRate!: number; 
  public CurrentLiabilityNoteBalance!: number;
  public UndrawnCapacity!: number;
  public CreatedBy: string;
  public CreatedDate: Date;
  public UpdatedBy: string;
  public UpdatedDate: Date;
}

export class generalSetupDetails {
  public EffectiveDate!: Date;
  public AttributeName: string;
  public Value: string;
  public CreatedBy: string;
  public CreatedDate: Date;
  public UpdatedBy: string;
  public UpdatedDate: Date;
 }
