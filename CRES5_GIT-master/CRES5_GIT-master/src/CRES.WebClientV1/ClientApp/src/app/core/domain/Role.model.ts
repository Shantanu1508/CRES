export class Role {


  RoleID !: string
  RoleName: string
  StatusID !: number
  UserId !: string
  NewRoleName !: string
  constructor(RoleName: string) {
    this.RoleName = RoleName;
  }
}
