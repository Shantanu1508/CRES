export class Periodic {
  public StartDate: Date;
  public EndDate: Date;
  public AzureBlobLink: string;
  public UserID: string;
  public CreatedBy: string;
  public CreatedDate: Date;
  public MaxEndDate: Date;
  public PeriodAutoID: number;
  public AnalysisID: string;
  public PeriodID: string;
  public PeriodIDs: string;
}



export class AccountingClose {
  public Active: boolean = false;
  public DealID: string;
  public DealName: string;
  public LastAccountingCloseDate: Date;
  public LastClosedOn: Date;
  public LastClosedBy: string;
  public ClosingDate: Date;
  public Maturity: Date;
  public ActualPayoffdate: Date;
  public FirstUnrecDate: Date;
  public isDataExists: number;
  public Comments: string;  
}
