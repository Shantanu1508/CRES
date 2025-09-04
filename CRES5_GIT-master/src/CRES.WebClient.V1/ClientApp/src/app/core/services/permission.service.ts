import { Injectable } from "@angular/core";
import { DataService } from './data.service';
import { UtilityService } from './utility.service';
import { Servicer } from '../domain/note.model';
import { SchedulerParam } from '../domain/schedulerParam.model';
import { SchedulerConfig } from '../domain/schedulerConfig.model';
import { changepowerbipasswrd } from "../domain/changePassword.model";

@Injectable()
export class PermissionService {
  private _GetUserPermissionAPI: string = 'api/permission/getuserpermissionbypagename';
  private _GetRoleAPI: string = 'api/permission/getrole';
  private _GetModuleTabMasterAPI: string = 'api/permission/getmoduletabmaster';
  private _GetPermissionByRoleIdAPI: string = 'api/permission/getpermissionbyroleid';
  private _InsertUpdateUserPermissionByRoleIDAPI: string = 'api/permission/InsertUpdateUserPermissionByRoleID';
  private _notegetallLookupAPI: string = 'api/note/getallLookup';
  private _AddUpdateRoleAPI: string = 'api/permission/AddUpdateRole';
  private _ResetuserpasswordAPI: string = 'api/permission/ResetPasswordandsendactivationlink';
  //private _ResetuserpasswordAPI: string = 'api/permission/ResetPassword';
  private _ForgotuserpasswordAPI: string = 'api/permission/forgotpasswordandsendactivationlink';
  private _getAllowBasicLoginAPI: string = 'api/account/getappconfigbykey';
  private _getallappconfigAPI: string = 'api/account/getallappconfig';
  private _updateAllowBasicLoginAPI: string = 'api/account/UpdateAppConfigByKey';
  private _getAllServicerAPI: string = 'api/account/getallservicer';
  private _updateservicerbyservicerIdAPI: string = 'api/account/UpdateServicerByServicerID';
  private _getalltransactiontypes: string = 'api/account/getAlltransactionTypes';
  private _savetransactiotypes: string = 'api/account/saveTransactionTypes';
  private _deletetransactiontypesAPI: string = 'api/account/deleteTransactiontypes';
  private _getallschedulerconfigAPI: string = 'api/permission/getallschedulerconfig';
  private _addupdateschedulerconfigAPI: string = 'api/permission/addupdateschedulerconfig';
  private _runschedulerconfigAPI: string = 'api/permission/runscheduler';
  private _getallholidaycalendar: string = 'api/permission/getholidaycalendar';
  private _addHolidaydatesAPI: string = 'api/permission/addholidaydates';
  private _addHolidaycalendarNameAPI: string = 'api/permission/addholidaycalendarname';
  private _syncQuickbookAPI: string = 'api/wfcontroller/syncQuickbook';
  private _getPowerBIPasswordAPI: string = 'api/permission/getPowerBIPassword';
  private _UpdatePowerBIPasswordAPI: string = 'api/permission/UpdatePowerBIPassword';
  private _getContentByRuleTypeDetailIDAPI: string = 'api/permission/getContentByRuleTypeDetailID';
  private _getAllRulesAPI: string = 'api/permission/getallrules';
  private _updatejsontemplateAPI: string = 'api/permission/updatejsontemplate';

  
  constructor(public accountService: DataService, public utilityService: UtilityService) { }

  GetUserPermissionByPagename(pagename) {
    this.accountService.set(this._GetUserPermissionAPI);
    return this.accountService.post(JSON.stringify(pagename));//
  }

  GetRole() {
    this.accountService.set(this._GetRoleAPI);
    return this.accountService.getAll();//
  }

  GetModuleTabMaster() {
    this.accountService.set(this._GetModuleTabMasterAPI);
    return this.accountService.getAll();//
  }

  GetPermissionByRoleId(roleid) {
    this.accountService.set(this._GetPermissionByRoleIdAPI);
    return this.accountService.post(JSON.stringify(roleid));
  }

  InsertUpdateUserPermissionByRoleID(moduleTabMasterList) {
    this.accountService.set(this._InsertUpdateUserPermissionByRoleIDAPI);
    return this.accountService.post(JSON.stringify(moduleTabMasterList));
  }

  getAllLookupById() {
    this.accountService.set(this._notegetallLookupAPI);
    return this.accountService.getAll();
  }

  AddUpdateRole(RoleDC) {
    this.accountService.set(this._AddUpdateRoleAPI);
    return this.accountService.post(JSON.stringify(RoleDC));
  }

  ResetUserPassword(user) {
    this.accountService.set(this._ResetuserpasswordAPI);
    return this.accountService.post(JSON.stringify(user));
  }

  /*
  ResetPasswordByAuthenticationkey{
      this.accountService.set(this._ResetuserpasswordAPI);
      return this.accountService.post(JSON.stringify(user));
  }

  ForgotPasswordByAuthenticationkey(user) {
      this.accountService.set(this._ForgotuserpasswordAPI);
      return this.accountService.post(JSON.stringify(user));
  }
  */
  GetUserPermissionBySuperAdmin(): boolean {
    var isPermission = false;
    var rolename = window.localStorage.getItem("rolename");
    if (rolename != null) {
      if (rolename.toString() == "Super Admin" || rolename.toString() == "Viewer") {
        isPermission = true;
      }
      else {
        isPermission = false;
      }
      if (isPermission == false) {
        localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
        localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));
        this.utilityService.navigateUnauthorize();
      }
      else
        isPermission = true;
    }
    return isPermission;
  }

  GetAllowBasiclogin(key) {
    this.accountService.set(this._getAllowBasicLoginAPI);
    return this.accountService.post(JSON.stringify(key));
  }

  GetAllAppSetting() {
    this.accountService.set(this._getallappconfigAPI);
    return this.accountService.getAll();
  }

  UpdateAllowBasicLogin(_appConfig) {
    this.accountService.set(this._updateAllowBasicLoginAPI);
    return this.accountService.post(JSON.stringify(_appConfig));
  }

  GetAllServicer() {
    this.accountService.set(this._getAllServicerAPI);
    return this.accountService.getAll();
  }
  SaveServicerByServicerID(servicer: Servicer) {
    this.accountService.set(this._updateservicerbyservicerIdAPI);
    return this.accountService.post(JSON.stringify(servicer));
  }

  GetTransactionTypes() {
    this.accountService.set(this._getalltransactiontypes);
    return this.accountService.getAll();
  }
  SaveTransactionTypes(transactiontypes: any) {
    this.accountService.set(this._savetransactiotypes);
    return this.accountService.post(JSON.stringify(transactiontypes));
  }
  deleteTransactionType(id: number) {
    this.accountService.set(this._deletetransactiontypesAPI);
    return this.accountService.post(JSON.stringify(id));
  }
  getallschedulerconfig(schedulerParam: SchedulerParam) {
    this.accountService.set(this._getallschedulerconfigAPI);
    return this.accountService.post(JSON.stringify(schedulerParam));
  }

  addupdateschedulerconfig(scheduleconfig: any) {
    this.accountService.set(this._addupdateschedulerconfigAPI);
    return this.accountService.post(JSON.stringify(scheduleconfig));
  }

  RunScheduler(scheduleconfig: SchedulerConfig) {
    this.accountService.set(this._runschedulerconfigAPI);
    return this.accountService.post(JSON.stringify(scheduleconfig));
  }

  GetHolidayCalendar() {
    this.accountService.set(this._getallholidaycalendar);
    return this.accountService.getAll();
  }

  addHolidayCalendarName(CalendarName: any) {
    this.accountService.set(this._addHolidaycalendarNameAPI);
    return this.accountService.post(JSON.stringify(CalendarName));
  }

  addHolidayDates(dtHolidaysDate: any) {
    this.accountService.set(this._addHolidaydatesAPI);
    return this.accountService.post(JSON.stringify(dtHolidaysDate));
  }

  syncQuickbook() {
    this.accountService.set(this._syncQuickbookAPI);
    return this.accountService.getAll();
  }

  getpowerBIpassword() {
    this.accountService.set(this._getPowerBIPasswordAPI);
    return this.accountService.getAll();
  }

  UpdatePowerBIPassword(_changepowerbipasswrd: changepowerbipasswrd) {
    this.accountService.set(this._UpdatePowerBIPasswordAPI);
    return this.accountService.post(JSON.stringify(_changepowerbipasswrd));
  }

  GetContentByRuleTypeDetailID(RuleTypeDetailID) {
    this.accountService.set(this._getContentByRuleTypeDetailIDAPI);
    return this.accountService.post(JSON.stringify(RuleTypeDetailID));
  }

  GetAllRules() {
    this.accountService.set(this._getAllRulesAPI);
    return this.accountService.getAll();
  }

  UpdateJsonTemplate(data) {
    this.accountService.set(this._updatejsontemplateAPI);
    return this.accountService.post(JSON.stringify(data));
  }
 
 
}
