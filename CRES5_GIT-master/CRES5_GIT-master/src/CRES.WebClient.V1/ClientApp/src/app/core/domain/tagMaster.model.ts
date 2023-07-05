export class TagMaster {
  public TagMasterID: string;
  public TagName: string;
  public TagDesc: string;

  public NewTagName: string;
  public NewTagDesc: string;
  public FullName: string;
  public AnalysisID: string;
  public CreatedDate: Date;
  public AnalysisName: string;
  public TagFileName: string;
  public NewTagFileName: string;



  constructor(tagMasterID: string) {
    this.TagMasterID = tagMasterID;
  }
}
