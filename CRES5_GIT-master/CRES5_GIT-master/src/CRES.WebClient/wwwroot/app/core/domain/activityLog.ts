export class ActivityLog {
    public ActivityLogID: string;
    public ModuleID: string;
    public ModuleTypeID: number;
    public ModuleName: string;
    public AssignedTo: string;
    public AssignedToText: string;
    public ActivityByFirstLetter: string;
    public Modified : string;
    public UColor : string;
    public ActivityMessage : string;
    public DisplayMessage: string;
    public ActivityColor : string;
    public ActivityUserFirstLetter : string;
    public ActivityType : string;
    public CreatedBy: string;
    public CreatedDate: Date;
    public UpdatedBy: string;
    public UpdatedDate: Date;
    public UserName: string;
    public Currentdate: string;
       

constructor(ActivityLogID: string) {
    this.ActivityLogID = ActivityLogID;
}
}