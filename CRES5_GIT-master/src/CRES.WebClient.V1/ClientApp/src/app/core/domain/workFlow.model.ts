export class Workflow {
  public WFTaskDetailId: number;
  public TaskID: string;
  public WFStatusPurposeMappingID: number;
  public WFStatusMasterID: number;
  public StatusName: string;
  public SubmitType: number;
  public SubmitTypeText: string;

  public Comment: string;
  public PurposeTypeId: number;
  public OrderIndex: number;
  public TaskTypeID: number;
  public TaskTypeIDText: string;
  public CreatedBy: string;
  public CreatedDate: Date;

  public NextWFStatusPurposeMappingID: number;
  public NextWFStatusMasterID: number;
  public NextStatusName: string;
  public NextOrderIndex: number;
  public wfFlag: string;
  public wf_isAllow: number;

  public filterType: string;

  WFAdditionalList: WFAdditionalData;
  WFCheckList: Array<WFCheckListData>;
  WFStatusList: Array<WFStatusData>;
  WFClientList: Array<WFClientData>;
  WFNotificationMasterEmail: Array<WFClientData>;
  public DealName: string;
  public DrawComment: string;
  public ActivityLog: string;
  public FooterText: string;
  public SenderName: string;
  WFCheckListStatus: Array<WFCheckListStatus>;

  public StatusDisplayName: string;
  public StatusDisplayNameWithFormat: string;
  public NextStatusDisplayNameWithFormat: string;
  public NextStatusDisplayName: string;

  public AdditionalComments: string;
  public SpecialInstructions: string;
  public NoteswithAmount: string;
  public wf_isAllowReject: number;
  public TimeZone: string;
  public WorkFlowType: string;
  public DelegatedUserName: string;
  public IsDisableFundingTeamApproval: number;
  public IsOnlyPrimaryUser: number;
  public ReserveScheduleBreakDown: string;
  public ExitFee: number;
  public ExitFeePercentage: number;
  public PrepayPremium: number;
  public PropertyManagerEmail: string;
  public CREDealID: string;
  public AdditionalEmail: string;
  public IsDiscrepancyForCommitment: boolean;
  public OriginalWFStatusPurposeMappingID: number;
  public AmOversightMsg: string;
  constructor(WFTaskDetailId: number) {
    this.WFTaskDetailId = WFTaskDetailId;
  }
  /*
  public int? WFTaskDetailId { get; set; }
      public int ? WFStatusPurposeMappingID { get; set; }
      public string TaskID { get; set; }
      public int ? WFStatusTaskMappingID { get; set;  }
      public int ? WFStatusMasterID { get; set; }
      public string StatusName { get; set; }
      public int ? SubmitType { get; set; }
      public string SubmitTypeText { get; set; }

      public WFAdditionalDataContarct WFAdditionalList { get; set; }
      public List < WFCheckListDataContract > WFCheckList { get; set; }
      public List < WFStatus > WFStatusList { get; set; }
      public int ? TaskTypeID { get; set; }
      public string Comment { get; set; }
      public int ? PurposeTypeId { get; set; }
      public int ? OrderIndex { get; set; }
      public string TaskTypeIDText { get; set; }
      public string CreatedBy { get; set; }
      public DateTime ? CreatedDate { get; set; }
  */
}

export class WFAdditionalData {
  public Amount: string;
  public Applied: boolean;
  public Comment: string;
  public CREDealID: string;
  public Date: Date;
  public DealName: string;
  public DrawFundingID: string;
  public FindingAmount: string;
  public FundingDate: string;
  public PurposeID: number;
  public PurposeIDText: string;
  public PurposeText: string;
  public TaskID: string;
  public WFTaskDetailID: number;
  public BoxDocumentLink: string;
  public DeadLineDate: Date;
  public IsPreliminaryNotification: boolean;
  public IsRevisedPreliminaryNotification: boolean;
  public IsFinalNotification: boolean;
  public IsRevisedFinalNotification: boolean;
  public IsFinalNotificationPayOff: boolean;
  public IsRevisedFinalNotificationPayOff: boolean;
  public IsServicerNotification: boolean;
  public IsRevisedServicerNotification: boolean;
  public CreatedByName: string;
  public AMEmails: string;
  public AdditionalComments: string;
  public SpecialInstructions: string;
  public SeniorCreNoteID: string;
  public SeniorServicerName: string;
  public RequiredEquity: number;
  public AdditionalEquity: number;
  public BaseCurrencyName: string;
  public ServicerName: string;
  public IsREODeal: boolean;
  public PropertyManagerEmail: string;
  public AccountingEmail: string;
  public LastPrelimSentDate: Date;
  public IsCancelFinalSent: boolean;
  public AdditionalGroupEmail: string;
  public RevisedMessage: string;
  public NotesWithFinancingSourceNone: string;
  public AMEmailsWithoutWellsBerkadia: string;
  public WatchlistStatus: string;
  public TotalPendingInvoice: number;
  public TotalPendingInvoiceAmt: number;
  public IsPrelimDisabled: boolean;
  public CREDealIDWithREO: string;

  constructor(WFTaskDetailId: number) {
    this.WFTaskDetailID = WFTaskDetailId;

  }

}

export class WFCheckListData {
  public CheckListMasterId: number;
  public CheckListName: string;
  public CheckListStatus: number;
  public CheckListStatusText: string;
  public Comment: string;
  public IsMandatory: boolean;
  public TaskID: string;
  public WFCheckListDetailID: string;
  public WFTaskDetailID: number;


  constructor(WFTaskDetailId: number) {
    this.WFTaskDetailID = WFTaskDetailId;

  }
}

export class WFStatusData {
  public WFStatusMasterID: number;
  public StatusName: string;
  public StatusDisplayName: string;
  public OrderIndex: number;
  public WFTaskDetailID: number;
  public TaskID: string;

  constructor(WFTaskDetailId: number) {
    this.WFTaskDetailID = WFTaskDetailId;

  }
}

export class WFNotificationMaster {
  public WFNotificationMasterID: number;
  public WFNotificationMasterGuID: string;
  public Name: string;
  public WFNotificationConfigID: number;
  public TemplateID: number;
  public TaskID: string;

  constructor(WFNotificationMasterID: number) {
    this.WFNotificationMasterID = WFNotificationMasterID;

  }
}

export class WFNotificationDetailDataContract {
  public WFNotificationID: number;
  public WFNotificationGuID: string;
  public WFNotificationMasterID: number;
  public TaskID: string;
  public WFHeader: string;
  public WFBody: string;
  public WFFooter: string;
  public MessageHTML: string;
  public ScheduledDateTime: string;
  public ActionType: number;
  public AdditionalText: string;
  public EmailToIds: string;
  public EmailCCIds: string;
  public TemplateID: number;
  public TemplateFileName: string;
  public DealName: string;
  public Subject: string;
  public ReplyTo: string;
  public EnvironmentName: string;
  public UserName: string;
  public AdditionalComments: string;
  public SpecialInstructions: string;
  WFCheckList: Array<WFCheckListData>;
  public TaskTypeID: number;
  public DealDetail: string;
  public AdditionalEmail: string;
  public ExitFee: number;
  public ExitFeePercentage: number;
  public PrepayPremium: number;
  public OriginalWFStatusPurposeMappingID: number;

  constructor(WFNotificationID: number) {
    this.WFNotificationID = WFNotificationID;
  }
}

export class WFClientData {
  public ClientID: number;
  public ClientName: string;
  public EmailID: string;
  public ClientsName: string;
  public EmailIDs: string;
  public LookupID: number;

  constructor(WFClientID: number) {
    this.ClientID = WFClientID;

  }
}
export class WFCheckListStatus {
  public LookupID: number;
  public Name: string;
}





