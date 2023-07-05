export class DrawFeeInvoiceDetail {
  public DrawFeeInvoiceDetailID: number
  public TaskID: string
  public Amount: number
  public FirstName: string
  public LastName: string
  public Designation: string
  public CompanyName: string
  public Address: string
  public City: string
  public State: string
  public Zip: string
  public Email1: string
  public Email2: string
  public PhoneNo: string
  public AlternatePhone: string
  public Comment: string
  public AutoSendInvoice: number
  public CreatedBy: string
  public CreatedDate: Date
  public UpdatedBy: string
  public UpdatedDate: Date
  public FundingDate: Date
  public CreDealID: string
  public DrawNo: string
  public DrawFeeStatus: number
  public DrawFeeStatusText: string
  public FileName: string
  public InvoiceNo: string
  public ObjectTypeID: number
  public ObjectID: string
  public InvoiceTypeID: number
  public ID: string
  public EndPointID: string
  public DealName: string
  public IsManualInvoice: boolean = false
  public StorageType: string
  public TemplateName: string
  public InvoiceCode: string
  public StateID: number;
  public InvoiceNoUI: string;
  public AMEmails: string;
  public SenderFirstName: string;
  public SenderLastName: string;
  public SenderEmail: string;
  public FundingAmount: number

  //constructor
  constructor(FirstName: string) {
    this.FirstName = FirstName;
  }
}
