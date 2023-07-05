export class User {
  //Username: string;
  //Password: string;
  //RememberMe: boolean;


  UserID !: string
  FirstName !: string
  LastName !: string
  Email !: string
  Login: string
  Password: string
  ExpirationDate !: Date
  StatusID !: string
  Status !: string
  OldPassword !: string
  NewPassword !: string
  ConfirmPassword !: string

  CreatedBy !: string
  CreatedDate !: Date
  UpdatedBy !: string
  UpdatedDate !: Date
  Token !: string
  TokenUId !: string

  RoleID !: string
  RoleName !: string
  SuperAdminName !: string
  ContactNo1 !: string
  DelegatedUser !: string
  TimeZone !: string
  EmailNotificationID !: number
  Name !: string
  ModuleId !: number
  ModuleName !: string
  LoginSession !: string
  IpAddress: string

  constructor(login: string, password: string) {

    this.Login = login;
    this.Password = password;

  }
}


export class AppConfig {

  Key !: string
  Value !: string


}
