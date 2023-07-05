export class UserDelegateConfiguration {

  public UserDelegateConfigID: string;
  public TagMasterID !: string;
  public UserID !: string;
  public DelegatedUserID ?: string|null;
  public Startdate ?: Date |null;
  public Enddate ?: Date | null;
  public IsActive !: string;
  public EntryType !: string;
  public RequestType !: string;
  public username !: string;
  constructor(UserDelegateConfigID: string) {
    this.UserDelegateConfigID = UserDelegateConfigID;
  }
}
