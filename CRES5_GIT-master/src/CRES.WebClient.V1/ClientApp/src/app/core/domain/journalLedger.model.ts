export class JournalLedgerMaster {
  public JournalEntryMasterID: number;
  public TransactionEntryID: number;
  public JournalEntryMasterGUID: string;
  public DebtEquityAccountID: string;
  public JournalEntryDate: Date;
  public Comments: string;
  public Listjldc!: Array<JournalLedger>;

  constructor(JournalEntryMasterID: number) {
    this.JournalEntryMasterID = JournalEntryMasterID;
  }
}

export class JournalLedger {
  public JournalEntryMasterID: number;
  public TransactionEntryID: number;
  public JournalEntryMasterGUID: string;
  public DebtEquityAccountID: string;
  public JournalEntryDate: Date;
  public TransactionDate: Date;
  public TransactionType: number;
  public TransactionTypeText: string;
  public TransactionAmount: number;
  public Comments: string;
  public CommentsDetail: string;
  public CreatedBy: string;
  public CreatedDate: Date;
  public UpdatedBy: string;
  public UpdatedDate: Date;
}
