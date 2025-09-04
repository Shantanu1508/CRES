export class portfolio {


  public PortfolioID: string;
  public PortfolioMasterGuid !: string;
  public PortfolioName !: string;
  public Description !: string;
  public ClientIDs !: string;
  public PoolIDs !: string;
  public MaturityDateID !: number;
  public FundIDs !: string;
  public AllowWholeDeal !: boolean;
  public AllowWholeDealText !: string;
  public FinancingSourceIDs !: string;
  
  public XIRRConfigID !: number;
  constructor(PortfolioID: string) {
    this.PortfolioID = PortfolioID;
  }
}
