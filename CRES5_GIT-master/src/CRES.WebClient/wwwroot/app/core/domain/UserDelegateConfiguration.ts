export class UserDelegateConfiguration {

    public UserDelegateConfigID: string;
    public TagMasterID: string;
    public UserID: string;
    public DelegatedUserID: string;
    public Startdate: Date;
    public Enddate: Date;
    public IsActive: string;
    public EntryType: string;
    public RequestType: string;
    public username: string;
    constructor(UserDelegateConfigID: string) {
        this.UserDelegateConfigID = UserDelegateConfigID;
    }
}