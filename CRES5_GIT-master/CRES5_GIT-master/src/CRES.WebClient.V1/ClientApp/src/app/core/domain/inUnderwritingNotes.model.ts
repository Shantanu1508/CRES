export class IN_UnderwritingNotes {

  public IN_UnderwritingNoteID: string;
  public IN_UnderwritingAccountID: string;
  public IN_UnderwritingDealID: string;

  public ClientNoteID: number;
  public ClientDealID: string;
  public ClosingDate: Date;
  public FirstPaymentDate: Date;
  public SelectedMaturityDate: Date;
  public InitialFundingAmount: any;
  public OriginationFee: any;
  public OriginationFeePct: any;
  public IOTerm: number;
  public AmortTerm: number;
  public DeterminationDateLeadDays: number;
  public DeterminationDateReferenceDayoftheMonth: number;
  public RoundingMethod: number;
  public RoundingMethodText: string;

  public IndexRoundingRule: number;
  public StatusID: number;
  public StatusIDText: string;


  public CreatedBy: string;
  public CreatedDate: Date;
  public UpdatedBy: string;
  public UpdatedDate: Date;

  public Name: string;
  public PayFrequency: number;
  public PayFrequencyText: string;



  constructor(IN_UnderwritingNoteID: string, IN_UnderwritingAccountID: string, IN_UnderwritingDealID: string) {

    this.IN_UnderwritingNoteID = IN_UnderwritingNoteID;
    this.IN_UnderwritingAccountID = IN_UnderwritingAccountID;
    this.IN_UnderwritingDealID = IN_UnderwritingDealID;
  }
}
