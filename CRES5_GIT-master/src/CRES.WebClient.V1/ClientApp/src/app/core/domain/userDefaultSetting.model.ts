export class userdefaultsetting {
  UserDefaultSettingID !: string
  UserID: string
  Type !: number
  TypeText: string
  Value: string

  DefaultNoteTabName !: string
  DefaultDealTabName !: string

  CreatedBy !: string
  CreatedDate !: string
  UpdatedBy !: string
  UpdatedDate !: string


  constructor(UserID: string, TypeText: string, Value: string) {

    this.UserID = UserID;
    this.TypeText = TypeText;
    this.Value = Value;
  }

}
