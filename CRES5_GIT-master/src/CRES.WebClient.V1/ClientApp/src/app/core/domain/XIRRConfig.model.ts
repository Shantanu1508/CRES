
export class XIRRConfigMasterDataContract {
  public ListXirrConfig: Array<XIRRConfig>;
  public ListXirrConfigFilter: Array<XIRRConfigFilterDataContract>;
  public deletedXIRRConfig: Array<number>;
}
export class XIRRConfig {
  public RowNumber: number;
  public XIRRConfigID: number;
  public XIRRConfigGUID: string;
  public ReturnName: string;
  public Type: string;
  public PortfolioID: string;
  public AnalysisID: string;
  public ObjectType: string;
  public ObjectID: number;
  public Comments: string;
  public CreatedBy: string;
  public CreatedDate: Date;
  public UpdatedBy: string;
  public UpdatedDate: Date;
  public ListTagMasterXIRRData: Array<TagMasterXIRR>;
  public Group1: number;
  public Group2: number;
  public ArchiveDate: Date;
  public FileNameInput: string;
  public FileNameOutput: string;
  public IsActive: boolean;
  public Name: string;
  public Status: string;
  public UpdateXIRRLinkedDealText: string;
  public ArchivalRequirementText: string;

  public ArchivalRequirement: number;
  public ReferencingDealLevelReturn: number;
  public UpdateXIRRLinkedDeal: number;
  
  public ListXirrConfigFilter: Array<XIRRConfigFilterDataContract>;
  public ListXirrConfig: Array<XIRRConfig>;
  public active: boolean;
  public CutoffRelativeDateID: number;
  public CutoffDateOverride: Date;
  public ShowReturnonDealScreen: number;
}
export class TagMasterXIRR {
  TagMasterXIRRID: number;
  Name: string;
  CreatedBy: string;
  CreatedDate: Date;
  UpdatedBy: string;
  UpdatedDate: Date;
}

export class XIRRConfigParam {
  XIRRConfigIDs: string;
  ArchiveDate: Date;
  Comments: string;
}

export class XIRRConfigFilterDataContract {
  public RowNumber: number;
  public XIRRConfigID: number;
  public XIRRFilterSetupID: number;
  public FilterName: string;
  public FilterDropDownValue: string;
 }

export type TTreeItem = {
  header: string;
  items?: TTreeItem[];
  newItem?: boolean;
};
