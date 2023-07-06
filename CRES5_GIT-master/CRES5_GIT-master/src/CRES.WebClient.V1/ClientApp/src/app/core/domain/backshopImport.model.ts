export class backshopImport {


  public DealID: string;
  public DealName: string;
  public UserName: string;
  public BatchLogID: string;

  constructor(DealName: string, UserName: string) {

    this.DealName = DealName;
    this.UserName = UserName;
  }
}
