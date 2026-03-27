import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { User } from '../domain/user.model';
import { TimeZone } from '../domain/timeZone.model';
import { changepasswrd } from '../domain/changePassword.model';
import { userdefaultsetting } from '../../core/domain/userDefaultSetting.model';


@Injectable()
export class MembershipService {

  private _accountLoginAPI: string = 'api/account/authenticate';
  private _accountLogoutAPI: string = 'api/account/logout';
  private _accountChangePasswordAPI: string = 'api/account/ChangePassword';
  private _accountResetPasswordAPI: string = 'api/account/resetpassword';
  private _accountResetPasswordByAuthenticationkeyAPI: string = 'api/permission/resetpasswordandsendactivationlink';
  private _accountForgotPasswordByAuthenticationkeyAPI: string = 'api/permission/forgotpasswordandsendactivationlink';
  private _accountgetuserpwdAPI: string = 'api/account/loginfromazure';
  private _accountuserperissionAPI: string = "api/account/getuserperission";


  //private _accountGetUserCredentialByUserID: string = 'api/account/GetUserCredentialByUserID';

  private _getuserdefaultsettingbyuseridAPI: string = 'api/account/getuserdefaultsettingbyuserid';
  private _insertupdateuuserdefaultsettingAPI: string = "api/account/insertupdateuuserdefaultsetting";

  private _AddUpdateUserAzureADAPI: string = 'api/account/AddUpdateUserAzureAD';
  private _AddUpdateUserAPI: string = 'api/account/AddUpdateUser';
  private _GetAllUsersAPI: string = 'api/account/GetAllUsers';
  private _accountgetalllookupAPI: string = 'api/account/getallLookup';
  private _accountGetUsersByRoleNameAPI: string = 'api/account/getUsersByRoleName';
  private _getuserstoimpersonateAPI: string = 'api/account/getuserstoimpersonate';
  private _UpdateUserByUserIDAPI: string = 'api/account/UpdateUserByUserID';

  private _forceLogoutAPI: string = 'api/account/ForceLogout';
  private _accountalltimezoneAPI: string = "api/account/GetAllTimeZoneData";
  private _getwfapproverAPI: string = "api/account/getwfapprover";
  private _insertupdatewfapproverAPI: string = "api/account/InsertUpdateWFApprover";
  private _sendemailwdapproverAPI: string = 'api/account/SendEmailWFApprover';
  private _getalltimezoneAPI: string = 'api/account/GetAllTimeZone';
  private _deletewfapproverAPI: string = 'api/account/DeleteWFApproverByEmailNotificationId';
  private _countimpersonateuserAPI: string = 'api/account/impersonateusercount';
  public _usercredentialAPI: string = 'api/account/getusercredentialbyUserID';
  public _usertimezoneAPI: string = 'api/account/gettimezonebyuserid';
  private _getchatloghistoryAPI: string = "api/HBOT/getchatlogHistory";
  private _insertchatLogAPI: string = "api/HBOT/insertchatlog";
  private _getsystemconfigkeysAPI: string = "api/account/getsystemconfigkeys";
  private _addupdateIPaddressbyuserIDAPI: string = "api/account/UpdateIPAddressByUserID";
  private checkduplicateIPaddressAPI: string = "api/account/CheckDuplicateIPAddress";
  private _accountGetUsersInfoByRoleNameForDropDownAPI: string = "api/account/GetUsersInfoByRoleNameForDropDown";
  
  private _checkifuserislogedinAPI: string = "api/Account/checkifuserislogedin";
  
  constructor(public accountService: DataService) { }



  login(creds: User) {
    this.accountService.set(this._accountLoginAPI);
    //return this.accountService.get(1);
    return this.accountService.post(JSON.stringify(creds));//
  }

  logout() {
    localStorage.removeItem('user');
    this.accountService.set(this._accountLogoutAPI);
    return this.accountService.post(null, false);
  }


  getUserId(): string {
    var user: any = localStorage.getItem('user');
    var _userData = JSON.parse(user);
    return _userData.UserID;
  }

  loginFromAzure(email: string) {
    this.accountService.set(this._accountgetuserpwdAPI);
    return this.accountService.post(JSON.stringify(email));
  }


  ChangePassword(creds: changepasswrd) {
    this.accountService.set(this._accountChangePasswordAPI);
    return this.accountService.post(JSON.stringify(creds));
  }

  ResetPassword(creds: changepasswrd) {
    this.accountService.set(this._accountResetPasswordAPI);
    return this.accountService.post(JSON.stringify(creds));
  }

  ResetPasswordByAuthenticationkey(creds: changepasswrd) {
    this.accountService.set(this._accountResetPasswordByAuthenticationkeyAPI);
    return this.accountService.post(JSON.stringify(creds));
  }

  ForgotPasswordByAuthenticationkey(creds: changepasswrd) {
    this.accountService.set(this._accountForgotPasswordByAuthenticationkeyAPI);
    return this.accountService.post(JSON.stringify(creds));
  }

  //getUserCredentialByUserID(creds: User) {

  //    this.accountService.set(this._accountGetUserCredentialByUserID);
  //    return this.accountService.getByID(creds.UserID);
  //}

  getuserpermision() {
    this.accountService.set(this._accountuserperissionAPI);
    return this.accountService.getAll();
  }

  getsystemconfigkeys() {
    this.accountService.set(this._getsystemconfigkeysAPI);
    return this.accountService.getAll();
  }
  CheckifUserIsLogedIN() {
    this.accountService.set(this._checkifuserislogedinAPI);
    return this.accountService.getAll();
  } 


  getallTimezone(lstAppTimeZone: TimeZone, pagesIndex?: number, pagesSize?: number) {
    this.accountService.set(this._accountalltimezoneAPI, pagesIndex, pagesSize);
    return this.accountService.post(JSON.stringify(lstAppTimeZone));
  }

  getalltimezone() {
    this.accountService.set(this._getalltimezoneAPI);
    return this.accountService.getAll();
  }


  //check client side user auth status 
  isUserAuthenticated(): boolean {
    var _user: any = localStorage.getItem('user');
    if (_user)
      return true;
    else
      return false;
  }

  getLoggedInUser(): User {
    var _user !: User;

    if (this.isUserAuthenticated()) {
      var user:any = localStorage.getItem('user');
      var _userData = JSON.parse(user);
      _user = new User(_userData.Username, _userData.Password);
    }

    return _user;
  }


  GetUserDefaultSettingByUserID(_userdefaultsetting: userdefaultsetting) {
    this.accountService.set(this._getuserdefaultsettingbyuseridAPI);
    return this.accountService.post(JSON.stringify(_userdefaultsetting));//
  }

  InsertUpdateUserDefaultSetting(_userdefaultsetting:any) {
    this.accountService.set(this._insertupdateuuserdefaultsettingAPI);
    return this.accountService.post(JSON.stringify(_userdefaultsetting));//
  }


  GetAllUsers() {
    this.accountService.set(this._GetAllUsersAPI);
    return this.accountService.getAll();//
  }

  GetUsersToImpersonate(userID: string) {
    this.accountService.set(this._getuserstoimpersonateAPI);
    return this.accountService.getByID(userID);//
  }



  AddUpdateUser(Userlst:any) {
    this.accountService.set(this._AddUpdateUserAPI);
    return this.accountService.post(JSON.stringify(Userlst));//
  }

  getAllLookup(lookupIds: string) {
    this.accountService.set(this._accountgetalllookupAPI);
    return this.accountService.getByID(lookupIds);
  }
  getusersbyrolename(rolename: string) {
    this.accountService.set(this._accountGetUsersByRoleNameAPI);
    return this.accountService.getByID(rolename);
  }
  getUsersInfoByRoleNameForDropDown(rolename: string) {
    this.accountService.set(this._accountGetUsersInfoByRoleNameForDropDownAPI);
    return this.accountService.getByID(rolename);
  }
  //GetUsersInfoByRoleNameForDropDown

  ForceLogout(ID: string) {
    this.accountService.set(this._forceLogoutAPI);
    return this.accountService.getByID(ID);
  }

  UpdateUserByUserID(User:any) {
    this.accountService.set(this._UpdateUserByUserIDAPI);
    return this.accountService.post(JSON.stringify(User));//
  }


  UserLogout() {
    this.accountService.logout();
  }

  GetWFApprover() {
    this.accountService.set(this._getwfapproverAPI);
    return this.accountService.getAll();
  }

  InsertUpdateWFApprover(UserList:any) {
    this.accountService.set(this._insertupdatewfapproverAPI);
    return this.accountService.post(JSON.stringify(UserList));
  }

  SendWFApproverEmail(wfuserdetails:any) {
    this.accountService.set(this._sendemailwdapproverAPI);
    return this.accountService.post(JSON.stringify(wfuserdetails));
  }

  DeleteWFApprover(wfuser:any) {
    this.accountService.set(this._deletewfapproverAPI);
    return this.accountService.post(JSON.stringify(wfuser));
  }

  ImpersonateUserCount() {
    this.accountService.set(this._countimpersonateuserAPI);
    return this.accountService.getAll();
  }

  GetUserInfobyUserid() {
    this.accountService.set(this._usercredentialAPI);
    return this.accountService.getAll();
  }
  GetUserTimeZonebyUserID() {
    this.accountService.set(this._usertimezoneAPI);
    return this.accountService.getAll();
  }

  getChatLogHistory(_pageIndex:any, _pageSize:any) {
    this.accountService.set(this._getchatloghistoryAPI);
    return this.accountService.post(JSON.stringify(_pageIndex, _pageSize));
  }
  insertchatLog(dtchatqueans: any) {
    this.accountService.set(this._insertchatLogAPI);
    return this.accountService.post(JSON.stringify(dtchatqueans));
  }
  CheckDuplicateIPAddress(User: User) {
    this.accountService.set(this.checkduplicateIPaddressAPI);
    return this.accountService.post(JSON.stringify(User));
  }

  AddUpdateIPAddressByUserID(User: User) {
    this.accountService.set(this._addupdateIPaddressbyuserIDAPI);
    return this.accountService.post(JSON.stringify(User));
  }
}
