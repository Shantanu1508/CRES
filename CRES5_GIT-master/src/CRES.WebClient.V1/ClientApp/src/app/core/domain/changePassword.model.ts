export class changepasswrd {
  OldPassword: string
  ConfirmPassword: string
  NewPassword: string
  AuthenticationKey !: string
  Email !: string
  UserLogin !: string

  constructor(OldPassword: string, ConfirmPassword: string, NewPassword: string) {

    this.OldPassword = OldPassword;
    this.ConfirmPassword = ConfirmPassword;
    this.NewPassword = NewPassword;

  }


}
export class changepowerbipasswrd {
  key: string
  Value: string

}
