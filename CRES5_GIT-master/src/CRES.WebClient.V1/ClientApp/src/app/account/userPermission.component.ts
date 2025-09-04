import { Component, Inject, OnInit, ViewChild } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { User, AppConfig } from '../core/domain/user.model';
import { MembershipService } from '../core/services/membership.service';
import { OperationResult } from '../core/domain/operationResult.model';
import { ModuleWithProviders, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { NotificationService } from '../core/services/notification.service';
import { PermissionService } from '../core/services/permission.service';
import { UtilityService } from '../core/services/utility.service';
import { ModuleTabMaster } from '../core/domain/moduleTabMaster.model';
import { Role } from '../core/domain/role.model';
import * as wjcGrid from '@grapecity/wijmo.grid';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjInputModule } from '@grapecity/wijmo.angular2.input';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import * as wjcCore from '@grapecity/wijmo';
import { DataService } from '../core/services/data.service';
import { SchedulerConfig } from '../core/domain/schedulerConfig.model';
import { SchedulerParam } from '../core/domain/schedulerParam.model';

@Component({
  selector: 'userpermission',
  providers: [MembershipService, NotificationService, PermissionService],
  templateUrl: './userPermission.html'
})




export class userpermission {

  public rolelist: any;
  public RoleID: any;
  public moduleTabMaster !: ModuleTabMaster;
  public moduleTabMasterList !: Array<ModuleTabMaster>;
  public _isCalcListFetching: boolean = false;
  public modulename: any;
  public _Showmessagediv: boolean = false;
  public _ShowSuccessmessagediv: boolean = false;
  public _ShowSuccessmessage !: string;
  public _chkSelectAll_IsEdit: boolean;
  public _chkSelectAll_IsView: boolean;
  public _chkSelectAll_IsDelete: boolean;

  public user: User;
  public lstUsers !: Array<User>;
  public data !: wjcCore.CollectionView;
  public userdata !: wjcCore.CollectionView;
  private UsersToUpdate !: Array<User>;
  lstStatus: any;
  lstTimeZone: any;
  lsttimezone: any;
  lstFrequency: any;

  @ViewChild('flexpermission') flex !: wjcGrid.FlexGrid;
  @ViewChild('flex') Userflex !: wjcGrid.FlexGrid;
  @ViewChild('userflexdata') WFUserflexdata !: wjcGrid.FlexGrid;
  @ViewChild('flexScheduler') flexScheduler !: wjcGrid.FlexGrid;


  public role: Role;
  public _isRoleSaving: boolean;
  public NewRoleName !: string;
  public _IsShowMsg: boolean;
  public _MsgText: string;
  public _ShowSuccessmessageRolediv: boolean = false;
  public _ShowSuccessRolemessage !: string;
  public _alertinfodiv: boolean = false;

  public _alertinfomessage !: string;
  public resetRowIndex !: number;
  public _loginID !: string;
  public _isChecked: boolean = false;
  public _isCalcChecked: boolean = false;
  public _isLiabBlobDownldChecked: boolean = false;
  public _iscalcboosterChecked: boolean = false;
  public _appConfig: AppConfig;
  public _MsgTextUser: string;
  public _forceLogout: any;
  public _wfapproveremail: any;
  public lstapprover: any;
  public lstApproverUser !: Array<User>;
  public _deletewfapprover: any;
  public environmentName = "";
  public showemailanddeletebtn: boolean = false;
  public deleteRowIndex !: number;
  public lstSchedulerConfig !: Array<SchedulerConfig>;
  public schedulerParam !: SchedulerParam;
  public schedulerdata !: wjcCore.CollectionView;
  SelectedSchedulerName !: string;
  SelectedSchedulerID !: number;
  _schedulerConfig !: SchedulerConfig;
  public _isAllowFFSaveJsonIntoBlob: boolean = false;
  public _isAllowBackshopFFImport: boolean = false;
  public Message: any;
  public _isEnableM61Calculator: boolean = false;
  public _chkShowAllActiveInactiveUsers = false;
  constructor(public membershipService: MembershipService,
    public notificationService: NotificationService,
    private router: Router,
    public dataService: DataService,
    public utilityService: UtilityService,
    public permissionService: PermissionService) {
    this.lstFrequency = []
    this.lstFrequency.push({ 'Frequency': 'Hourly' });
    this.lstFrequency.push({ 'Frequency': 'Daily' });
    this.lstFrequency.push({ 'Frequency': 'Weekly' });
    this.lstFrequency.push({ 'Frequency': 'Monthly' });

    permissionService.GetUserPermissionBySuperAdmin();
    this._chkSelectAll_IsEdit = false;
    this._chkSelectAll_IsView = false;
    this._chkSelectAll_IsDelete = false;
    var user:any = localStorage.getItem('user');
    this.user = JSON.parse(user);

    this._isRoleSaving = false;
    this._IsShowMsg = false;
    this._MsgText = "";
    this._MsgTextUser = "";
    this.utilityService.setPageTitle("M61–User Permission");
    this.role = new Role("");
    this._appConfig = new AppConfig();
    this.CheckRole();
    this.GetAllUser();
    this._forceLogout = {
      resetRowIndex: "null",
      userName: "All",
      userID: "null"
    }

    this.GetAllTimeZone();

  }

  CheckRole(): void {

    var rolename = window.localStorage.getItem("rolename");
    if (rolename != null) {

      if (rolename.toString() != "Super Admin") {
        this.router.navigate(['/login']);
      }
    }

  }


  GetUserPermission(): void {

    this.permissionService.GetRole().subscribe(res => {
      if (res.Succeeded) {
        if (typeof res.RoleList !== 'undefined' && res.RoleList.length > 0) {
          this.rolelist = res.RoleList;

          this.RoleID = this.rolelist[0].RoleID;

          this.GetPermissionByRoleId();

          setTimeout(() => {
            this.flex.invalidate();
          }, 2000);

        }
        else {
        }
      }
    });
  }

  GetRole(): void {

    this.permissionService.GetRole().subscribe(res => {
      if (res.Succeeded) {
        if (typeof res.RoleList !== 'undefined' && res.RoleList.length > 0) {
          this.rolelist = res.RoleList;

        }
        else {
        }
      }
    });
  }


  GetPermissionByRoleId(): void {
    this._isCalcListFetching = true;
    this.permissionService.GetPermissionByRoleId(this.RoleID).subscribe(res => {
      if (res.Succeeded) {
        if (typeof res.ModuleTabMasterList !== 'undefined' && res.ModuleTabMasterList.length > 0) {

          this.moduleTabMasterList = res.ModuleTabMasterList;
          this._isCalcListFetching = false;
        }
        else {
          this._isCalcListFetching = false;
        }
      }
    });
  }


  RoleChange(roleID: any): void {
    this.RoleID = roleID.target.value;
    this.GetPermissionByRoleId();
  }

  GetAllUser(): void {
    this._isCalcListFetching = true;
    this.GetRole();
    this.GetAllLookups();

    setTimeout(() => {
      this.UsersToUpdate = new Array<User>();
      this.membershipService.GetAllUsers().subscribe(res => {
        if (res.Succeeded) {

          this.lstUsers = res.UserList;
          this._initData();
          this._bindGridDropdows();

          setTimeout(() => {
            this.Userflex.invalidate();
            this._isCalcListFetching = false;
          }, 2000);
        }
        else {
          console.log("GetAllUsers fails!");
        }

      });

    }, 3000);

  }

  private _initData() {
    // create CollectionView
    //this.data = new wjcCore.CollectionView(this.lstUsers);
    this.onChangeShowAllActiveInactiveUsers(this._chkShowAllActiveInactiveUsers);
    this.userdata = new wjcCore.CollectionView(this.lstApproverUser);
    this.schedulerdata = new wjcCore.CollectionView(this.lstSchedulerConfig);
    // track changes
    this.data.trackChanges = true;
    this.userdata.trackChanges = true;

  }

  onChangeShowAllActiveInactiveUsers(newvalue): void {
    // var checked = e.target.checked;

    if (newvalue == true) {
      this.data = new wjcCore.CollectionView(this.lstUsers);
      this._chkShowAllActiveInactiveUsers = true;
    }
    else {
      var lstActiveUsers = this.lstUsers.filter(x => x.Status == "Active");
      this.data = new wjcCore.CollectionView(lstActiveUsers);
      this._chkShowAllActiveInactiveUsers = false;
    }
    this.data.trackChanges = true;

  }

  AddUpdateUser(): void {
    var isMandatory = false;
    var isDuplicate = false;
    isMandatory = this.CheckMandatoryFieldsOnSave();
    if (isMandatory) {
      this.CustomAlert(this._MsgTextUser);
    }
    else {
      isDuplicate = this.CheckDuplicateEmailLoginOnSave();
      if (isDuplicate) {
        this.CustomAlert(this._MsgTextUser);
      }
    }
    if (!isMandatory && !isDuplicate) {
      this._isCalcListFetching = true;

      //if any of the filed(FirstName,LastName,Email,Login) is empty then dont add/update that user

      var NewItemsAdded = this.data.itemsAdded.filter(
        x => ((x.FirstName !== undefined && x.FirstName != "") &&
          (x.LastName !== undefined && x.LastName != "") &&
          (x.Email !== undefined && x.Email != "") &&
          (x.Login !== undefined && x.Login != "")
        )
      );

      var NewItemsEdited = this.data.itemsEdited.filter(
        x => ((x.FirstName !== undefined && x.FirstName != "") &&
          (x.LastName !== undefined && x.LastName != "") &&
          (x.Email !== undefined && x.Email != "") &&
          (x.Login !== undefined && x.Login != "")
        )
      );

      if (NewItemsAdded.length > 0 || NewItemsEdited.length > 0) {
        var user: any = localStorage.getItem("user");
        var userinfo = JSON.parse(user);
        for (var i = 0; i < NewItemsAdded.length; i++) {

          NewItemsAdded[i].UserID = '00000000-0000-0000-0000-000000000000';
          NewItemsAdded[i].SuperAdminName = userinfo.FirstName + " " + userinfo.LastName;
          NewItemsAdded[i].UpdatedBy = this.user.UserID;



          if (!(Number(NewItemsAdded[i].RoleName.toString()).toString() == "NaN" || Number(NewItemsAdded[i].RoleName) == 0)) {
            NewItemsAdded[i].RoleID = Number(NewItemsAdded[i].RoleName);
          }
          else {
            var filteredarray = this.rolelist.filter((x:any) => x.RoleID == NewItemsAdded[i].RoleName)
            if (filteredarray.length != 0) {
              NewItemsAdded[i].RoleID = NewItemsAdded[i].RoleName;
            }
            else {
              var filteredarrayNew = this.rolelist.filter((x:any) => x.RoleName == NewItemsAdded[i].RoleName)
              if (filteredarrayNew.length != 0) {
                NewItemsAdded[i].RoleID = filteredarrayNew[0].RoleID;
              }

            }
          }


          if (!(Number(NewItemsAdded[i].Status).toString() == "NaN" || Number(NewItemsAdded[i].Status) == 0)) {
            NewItemsAdded[i].StatusID = Number(NewItemsAdded[i].Status);
          }
          else {
            var filteredarray = this.lstStatus.filter((x:any) => x.LookupID == NewItemsAdded[i].Status)
            if (filteredarray.length != 0) {
              NewItemsAdded[i].StatusID = Number(NewItemsAdded[i].Status);
            }
            else {
              var filteredarrayNew = this.lstStatus.filter((x:any) => x.Name == NewItemsAdded[i].Status)
              if (filteredarrayNew.length != 0) {
                NewItemsAdded[i].StatusID = Number(filteredarrayNew[i].StatusID);
              }
            }
          }

          if (!(NewItemsAdded[i].TimeZone == null || NewItemsAdded[i].TimeZone == undefined || NewItemsAdded[i].TimeZone == "")) {
            var filteredarray = this.lsttimezone.filter((x:any) => x.TimeZoneID == NewItemsAdded[i].TimeZone)
            if (filteredarray.length > 0) {
              NewItemsAdded[i].TimeZone = filteredarray[0].Name;
            }
          }


          this.UsersToUpdate.push(NewItemsAdded[i]);
        }

        for (var i = 0; i < NewItemsEdited.length; i++) {
          NewItemsEdited[i].UpdatedBy = this.user.UserID;


          if (!(Number(NewItemsEdited[i].RoleName.toString()).toString() == "NaN" || Number(NewItemsEdited[i].RoleName) == 0)) {
            NewItemsEdited[i].RoleID = Number(NewItemsEdited[i].RoleName);
          }
          else {
            var filteredarray = this.rolelist.filter((x:any) => x.RoleID == NewItemsEdited[i].RoleName)
            if (filteredarray.length != 0) {
              NewItemsEdited[i].RoleID = NewItemsEdited[i].RoleName;
            }
          }

          if (!(Number(NewItemsEdited[i].Status.toString()).toString() == "NaN" || Number(NewItemsEdited[i].Status) == 0)) {
            NewItemsEdited[i].StatusID = Number(NewItemsEdited[i].Status);
          }
          else {
            var filteredarray = this.lstStatus.filter((x:any) => x.LookupID == NewItemsEdited[i].Status)
            if (filteredarray.length != 0) {
              NewItemsEdited[i].StatusID = Number(NewItemsEdited[i].Status);
            }
          }


          if (!(NewItemsEdited[i].TimeZone == null || NewItemsEdited[i].TimeZone == undefined || NewItemsEdited[i].TimeZone == "")) {
            var filteredarray = this.lsttimezone.filter((x:any) => x.TimeZoneID == NewItemsEdited[i].TimeZone)
            if (filteredarray.length > 0) {
              NewItemsEdited[i].TimeZone = filteredarray[0].Name;
            }
          }

          this.UsersToUpdate.push(NewItemsEdited[i]);
        }

        this.membershipService.AddUpdateUser(this.UsersToUpdate).subscribe(res => {
          if (res.Succeeded) {
            for (var i = 0; i < this.UsersToUpdate.length; i++) {
              if (this.UsersToUpdate[i].UserID == this.user.UserID) {
                this.user.TimeZone = this.UsersToUpdate[i].TimeZone;
                localStorage.setItem('user', JSON.stringify(this.user));

              }
            }
            this._isCalcListFetching = false;

            this._ShowSuccessmessage = 'User Added/Updated Successfully.';
            this._ShowSuccessmessagediv = true;
            setTimeout(()=> {
              this._ShowSuccessmessagediv = false;
              this._ShowSuccessmessage = '';
            }, 2000);

            this.GetAllUser();

          }
          else {
            this.Message = 'User Add/Update failed.';
            this._Showmessagediv = true;
            setTimeout(() => {
              this._Showmessagediv = false;
              this.Message = '';
            }, 2000);
            this.GetAllUser();
          }
        },
          error => {

          }
        );
      }
      else {
        this.GetAllUser();
        this._isCalcListFetching = false;
        this._ShowSuccessmessage = 'User Added/Updated Successfully.';
        this._ShowSuccessmessagediv = true;
        setTimeout(() => {
          this._ShowSuccessmessagediv = false;
        }, 2000);
      }

    }



  }

  SavePermission(): void {
    for (var i = 0; i < this.moduleTabMasterList.length; i++) {
      this.moduleTabMasterList[i].RoleID = this.RoleID;
    }

    this._isCalcListFetching = true;
    this.permissionService.InsertUpdateUserPermissionByRoleID(this.moduleTabMasterList).subscribe(res => {
      if (res.Succeeded) {
        this._isCalcListFetching = false;
        this._ShowSuccessmessage = "Permission for role is saved successfully.";
        this._ShowSuccessmessagediv = true;
        setTimeout(() => {
          this._ShowSuccessmessagediv = false;
        }, 5000);
      }
    });
  }

  SelectAll(input:any): void {
    if (input == 'IsEdit') {
      this._chkSelectAll_IsEdit = !this._chkSelectAll_IsEdit;
      for (var i = 0; i < this.moduleTabMasterList.length; i++) {
        this.moduleTabMasterList[i].IsEdit = this._chkSelectAll_IsEdit;
      }
    }
    if (input == 'IsView') {

      this._chkSelectAll_IsView = !this._chkSelectAll_IsView;
      for (var i = 0; i < this.moduleTabMasterList.length; i++) {
        this.moduleTabMasterList[i].IsView = this._chkSelectAll_IsView;
      }

    }
    if (input == 'IsDelete') {
      this._chkSelectAll_IsDelete = !this._chkSelectAll_IsDelete;
      for (var i = 0; i < this.moduleTabMasterList.length; i++) {
        this.moduleTabMasterList[i].IsDelete = this._chkSelectAll_IsDelete;
      }

    }
    this.flex.invalidate();

  }

  GetAllLookups(): void {
    this.permissionService.getAllLookupById().subscribe(res => {
      var data = res.lstLookups;

      this.lstStatus = data.filter((x:any) => x.ParentID == "1");

      //this.lstapprover = [
      //    { "LookupID": "552", "Name": "Approval (L2)" },
      //    { "LookupID": "606", "Name": "First draw approver" }
      //];



      //this.lstTimeZone = [
      //    { "LookupID": "Dateline Standard Time", "Name": "Dateline Standard Time (-12:00)" },
      //    { "LookupID": "UTC-11", "Name": "UTC-11 (-11:00)" },
      //    { "LookupID": "Aleutian Standard Time", "Name": "Aleutian Standard Time (-09:00)" },
      //    { "LookupID": "Hawaiian Standard Time", "Name": "Hawaiian Standard Time (-10:00)" },
      //    { "LookupID": "Marquesas Standard Time", "Name": "Marquesas Standard Time (-09:30)" },
      //    { "LookupID": "Alaskan Standard Time", "Name": "Alaskan Standard Time (-08:00)" },
      //    { "LookupID": "UTC-09", "Name": "UTC-09 (-09:00)" },
      //    { "LookupID": "Pacific Standard Time (Mexico)", "Name": "Pacific Standard Time (Mexico) (-07:00)" },
      //    { "LookupID": "UTC-08", "Name": "UTC-08 (-08:00)" },
      //    { "LookupID": "Pacific Standard Time", "Name": "Pacific Standard Time (-07:00)" },
      //    { "LookupID": "US Mountain Standard Time", "Name": "US Mountain Standard Time (-07:00)" },
      //    { "LookupID": "Mountain Standard Time (Mexico)", "Name": "Mountain Standard Time (Mexico) (-06:00)" },
      //    { "LookupID": "Mountain Standard Time", "Name": "Mountain Standard Time (-06:00)" },
      //    { "LookupID": "Central America Standard Time", "Name": "Central America Standard Time (-06:00)" },
      //    { "LookupID": "Central Standard Time", "Name": "Central Standard Time (-05:00)" },
      //    { "LookupID": "Easter Island Standard Time", "Name": "Easter Island Standard Time (-06:00)" },
      //    { "LookupID": "Central Standard Time (Mexico)", "Name": "Central Standard Time (Mexico) (-05:00)" },
      //    { "LookupID": "Canada Central Standard Time", "Name": "Canada Central Standard Time (-06:00)" },
      //    { "LookupID": "SA Pacific Standard Time", "Name": "SA Pacific Standard Time (-05:00)" },
      //    { "LookupID": "Eastern Standard Time (Mexico)", "Name": "Eastern Standard Time (Mexico) (-05:00)" },
      //    { "LookupID": "Eastern Standard Time", "Name": "Eastern Standard Time (-04:00)" },
      //    { "LookupID": "Haiti Standard Time", "Name": "Haiti Standard Time (-04:00)" },
      //    { "LookupID": "Cuba Standard Time", "Name": "Cuba Standard Time (-04:00)" },
      //    { "LookupID": "US Eastern Standard Time", "Name": "US Eastern Standard Time (-04:00)" },
      //    { "LookupID": "Turks And Caicos Standard Time", "Name": "Turks And Caicos Standard Time (-04:00)" },
      //    { "LookupID": "Paraguay Standard Time", "Name": "Paraguay Standard Time (-04:00)" },
      //    { "LookupID": "Atlantic Standard Time", "Name": "Atlantic Standard Time (-03:00)" },
      //    { "LookupID": "Venezuela Standard Time", "Name": "Venezuela Standard Time (-04:00)" },
      //    { "LookupID": "Central Brazilian Standard Time", "Name": "Central Brazilian Standard Time (-04:00)" },
      //    { "LookupID": "SA Western Standard Time", "Name": "SA Western Standard Time (-04:00)" },
      //    { "LookupID": "Pacific SA Standard Time", "Name": "Pacific SA Standard Time (-04:00)" },
      //    { "LookupID": "Newfoundland Standard Time", "Name": "Newfoundland Standard Time (-02:30)" },
      //    { "LookupID": "Tocantins Standard Time", "Name": "Tocantins Standard Time (-03:00)" },
      //    { "LookupID": "E. South America Standard Time", "Name": "E. South America Standard Time (-03:00)" },
      //    { "LookupID": "SA Eastern Standard Time", "Name": "SA Eastern Standard Time (-03:00)" },
      //    { "LookupID": "Argentina Standard Time", "Name": "Argentina Standard Time (-03:00)" },
      //    { "LookupID": "Greenland Standard Time", "Name": "Greenland Standard Time (-02:00)" },
      //    { "LookupID": "Montevideo Standard Time", "Name": "Montevideo Standard Time (-03:00)" },
      //    { "LookupID": "Magallanes Standard Time", "Name": "Magallanes Standard Time (-03:00)" },
      //    { "LookupID": "Saint Pierre Standard Time", "Name": "Saint Pierre Standard Time (-02:00)" },
      //    { "LookupID": "Bahia Standard Time", "Name": "Bahia Standard Time (-03:00)" },
      //    { "LookupID": "UTC-02", "Name": "UTC-02 (-02:00)" },
      //    { "LookupID": "Mid-Atlantic Standard Time", "Name": "Mid-Atlantic Standard Time (-01:00)" },
      //    { "LookupID": "Azores Standard Time", "Name": "Azores Standard Time (+00:00)" },
      //    { "LookupID": "Cape Verde Standard Time", "Name": "Cape Verde Standard Time (-01:00)" },
      //    { "LookupID": "UTC", "Name": "UTC (+00:00)" },
      //    { "LookupID": "GMT Standard Time", "Name": "GMT Standard Time (+01:00)" },
      //    { "LookupID": "Greenwich Standard Time", "Name": "Greenwich Standard Time (+00:00)" },
      //    { "LookupID": "Sao Tome Standard Time", "Name": "Sao Tome Standard Time (+00:00)" },
      //    { "LookupID": "W. Europe Standard Time", "Name": "W. Europe Standard Time (+02:00)" },
      //    { "LookupID": "Central Europe Standard Time", "Name": "Central Europe Standard Time (+02:00)" },
      //    { "LookupID": "Romance Standard Time", "Name": "Romance Standard Time (+02:00)" },
      //    { "LookupID": "Morocco Standard Time", "Name": "Morocco Standard Time (+01:00)" },
      //    { "LookupID": "Central European Standard Time", "Name": "Central European Standard Time (+02:00)" },
      //    { "LookupID": "W. Central Africa Standard Time", "Name": "W. Central Africa Standard Time (+01:00)" },
      //    { "LookupID": "Jordan Standard Time", "Name": "Jordan Standard Time (+03:00)" },
      //    { "LookupID": "GTB Standard Time", "Name": "GTB Standard Time (+03:00)" },
      //    { "LookupID": "Middle East Standard Time", "Name": "Middle East Standard Time (+03:00)" },
      //    { "LookupID": "Egypt Standard Time", "Name": "Egypt Standard Time (+02:00)" },
      //    { "LookupID": "E. Europe Standard Time", "Name": "E. Europe Standard Time (+03:00)" },
      //    { "LookupID": "Syria Standard Time", "Name": "Syria Standard Time (+03:00)" },
      //    { "LookupID": "West Bank Standard Time", "Name": "West Bank Standard Time (+03:00)" },
      //    { "LookupID": "South Africa Standard Time", "Name": "South Africa Standard Time (+02:00)" },
      //    { "LookupID": "FLE Standard Time", "Name": "FLE Standard Time (+03:00)" },
      //    { "LookupID": "Israel Standard Time", "Name": "Israel Standard Time (+03:00)" },
      //    { "LookupID": "Kaliningrad Standard Time", "Name": "Kaliningrad Standard Time (+02:00)" },
      //    { "LookupID": "Sudan Standard Time", "Name": "Sudan Standard Time (+02:00)" },
      //    { "LookupID": "Libya Standard Time", "Name": "Libya Standard Time (+02:00)" },
      //    { "LookupID": "Namibia Standard Time", "Name": "Namibia Standard Time (+02:00)" },
      //    { "LookupID": "Arabic Standard Time", "Name": "Arabic Standard Time (+03:00)" },
      //    { "LookupID": "Turkey Standard Time", "Name": "Turkey Standard Time (+03:00)" },
      //    { "LookupID": "Arab Standard Time", "Name": "Arab Standard Time (+03:00)" },
      //    { "LookupID": "Belarus Standard Time", "Name": "Belarus Standard Time (+03:00)" },
      //    { "LookupID": "Russian Standard Time", "Name": "Russian Standard Time (+03:00)" },
      //    { "LookupID": "E. Africa Standard Time", "Name": "E. Africa Standard Time (+03:00)" },
      //    { "LookupID": "Iran Standard Time", "Name": "Iran Standard Time (+04:30)" },
      //    { "LookupID": "Arabian Standard Time", "Name": "Arabian Standard Time (+04:00)" },
      //    { "LookupID": "Astrakhan Standard Time", "Name": "Astrakhan Standard Time (+04:00)" },
      //    { "LookupID": "Azerbaijan Standard Time", "Name": "Azerbaijan Standard Time (+04:00)" },
      //    { "LookupID": "Russia Time Zone 3", "Name": "Russia Time Zone 3 (+04:00)" },
      //    { "LookupID": "Mauritius Standard Time", "Name": "Mauritius Standard Time (+04:00)" },
      //    { "LookupID": "Saratov Standard Time", "Name": "Saratov Standard Time (+04:00)" },
      //    { "LookupID": "Georgian Standard Time", "Name": "Georgian Standard Time (+04:00)" },
      //    { "LookupID": "Volgograd Standard Time", "Name": "Volgograd Standard Time (+04:00)" },
      //    { "LookupID": "Caucasus Standard Time", "Name": "Caucasus Standard Time (+04:00)" },
      //    { "LookupID": "Afghanistan Standard Time", "Name": "Afghanistan Standard Time (+04:30)" },
      //    { "LookupID": "West Asia Standard Time", "Name": "West Asia Standard Time (+05:00)" },
      //    { "LookupID": "Ekaterinburg Standard Time", "Name": "Ekaterinburg Standard Time (+05:00)" },
      //    { "LookupID": "Pakistan Standard Time", "Name": "Pakistan Standard Time (+05:00)" },
      //    { "LookupID": "Qyzylorda Standard Time", "Name": "Qyzylorda Standard Time (+05:00)" },
      //    { "LookupID": "India Standard Time", "Name": "India Standard Time (+05:30)" },
      //    { "LookupID": "Sri Lanka Standard Time", "Name": "Sri Lanka Standard Time (+05:30)" },
      //    { "LookupID": "Nepal Standard Time", "Name": "Nepal Standard Time (+05:45)" },
      //    { "LookupID": "Central Asia Standard Time", "Name": "Central Asia Standard Time (+06:00)" },
      //    { "LookupID": "Bangladesh Standard Time", "Name": "Bangladesh Standard Time (+06:00)" },
      //    { "LookupID": "Omsk Standard Time", "Name": "Omsk Standard Time (+06:00)" },
      //    { "LookupID": "Myanmar Standard Time", "Name": "Myanmar Standard Time (+06:30)" },
      //    { "LookupID": "SE Asia Standard Time", "Name": "SE Asia Standard Time (+07:00)" },
      //    { "LookupID": "Altai Standard Time", "Name": "Altai Standard Time (+07:00)" },
      //    { "LookupID": "W. Mongolia Standard Time", "Name": "W. Mongolia Standard Time (+07:00)" },
      //    { "LookupID": "North Asia Standard Time", "Name": "North Asia Standard Time (+07:00)" },
      //    { "LookupID": "N. Central Asia Standard Time", "Name": "N. Central Asia Standard Time (+07:00)" },
      //    { "LookupID": "Tomsk Standard Time", "Name": "Tomsk Standard Time (+07:00)" },
      //    { "LookupID": "China Standard Time", "Name": "China Standard Time (+08:00)" },
      //    { "LookupID": "North Asia East Standard Time", "Name": "North Asia East Standard Time (+08:00)" },
      //    { "LookupID": "Singapore Standard Time", "Name": "Singapore Standard Time (+08:00)" },
      //    { "LookupID": "W. Australia Standard Time", "Name": "W. Australia Standard Time (+08:00)" },
      //    { "LookupID": "Taipei Standard Time", "Name": "Taipei Standard Time (+08:00)" },
      //    { "LookupID": "Ulaanbaatar Standard Time", "Name": "Ulaanbaatar Standard Time (+08:00)" },
      //    { "LookupID": "Aus Central W. Standard Time", "Name": "Aus Central W. Standard Time (+08:45)" },
      //    { "LookupID": "Transbaikal Standard Time", "Name": "Transbaikal Standard Time (+09:00)" },
      //    { "LookupID": "Tokyo Standard Time", "Name": "Tokyo Standard Time (+09:00)" },
      //    { "LookupID": "North Korea Standard Time", "Name": "North Korea Standard Time (+09:00)" },
      //    { "LookupID": "Korea Standard Time", "Name": "Korea Standard Time (+09:00)" },
      //    { "LookupID": "Yakutsk Standard Time", "Name": "Yakutsk Standard Time (+09:00)" },
      //    { "LookupID": "Cen. Australia Standard Time", "Name": "Cen. Australia Standard Time (+09:30)" },
      //    { "LookupID": "AUS Central Standard Time", "Name": "AUS Central Standard Time (+09:30)" },
      //    { "LookupID": "E. Australia Standard Time", "Name": "E. Australia Standard Time (+10:00)" },
      //    { "LookupID": "AUS Eastern Standard Time", "Name": "AUS Eastern Standard Time (+10:00)" },
      //    { "LookupID": "West Pacific Standard Time", "Name": "West Pacific Standard Time (+10:00)" },
      //    { "LookupID": "Tasmania Standard Time", "Name": "Tasmania Standard Time (+10:00)" },
      //    { "LookupID": "Vladivostok Standard Time", "Name": "Vladivostok Standard Time (+10:00)" },
      //    { "LookupID": "Lord Howe Standard Time", "Name": "Lord Howe Standard Time (+10:30)" },
      //    { "LookupID": "Bougainville Standard Time", "Name": "Bougainville Standard Time (+11:00)" },
      //    { "LookupID": "Russia Time Zone 10", "Name": "Russia Time Zone 10 (+11:00)" },
      //    { "LookupID": "Magadan Standard Time", "Name": "Magadan Standard Time (+11:00)" },
      //    { "LookupID": "Norfolk Standard Time", "Name": "Norfolk Standard Time (+11:00)" },
      //    { "LookupID": "Sakhalin Standard Time", "Name": "Sakhalin Standard Time (+11:00)" },
      //    { "LookupID": "Central Pacific Standard Time", "Name": "Central Pacific Standard Time (+11:00)" },
      //    { "LookupID": "Russia Time Zone 11", "Name": "Russia Time Zone 11 (+12:00)" },
      //    { "LookupID": "New Zealand Standard Time", "Name": "New Zealand Standard Time (+12:00)" },
      //    { "LookupID": "UTC+12", "Name": "UTC+12 (+12:00)" },
      //    { "LookupID": "Fiji Standard Time", "Name": "Fiji Standard Time (+12:00)" },
      //    { "LookupID": "Kamchatka Standard Time", "Name": "Kamchatka Standard Time (+13:00)" },
      //    { "LookupID": "Chatham Islands Standard Time", "Name": "Chatham Islands Standard Time (+12:45)" },
      //    { "LookupID": "UTC+13", "Name": "UTC+13 (+13:00)" },
      //    { "LookupID": "Tonga Standard Time", "Name": "Tonga Standard Time (+13:00)" },
      //    { "LookupID": "Samoa Standard Time", "Name": "Samoa Standard Time (+13:00)" },
      //    { "LookupID": "Line Islands Standard Time", "Name": "Line Islands Standard Time (+14:00)" }
      //];
      this.lstapprover = [
        { "ModuleId": "606", "ModuleName": "First draw approver" },
        { "ModuleId": "552", "ModuleName": "Tier 2 approver" },
        { "ModuleId": "617", "ModuleName": "Tier 1 approver" },
        { "ModuleId": "720", "ModuleName": "REO Reserve Group" },
        { "ModuleId": "858", "ModuleName": "AM Oversight" }

      ];
      this._bindGridDropdows();
    });
  }

  private _bindGridDropdows() {

    var flexRole = this.Userflex;
    var wfflexapprover = this.WFUserflexdata;
    var flexscheduler = this.flexScheduler;

    if (flexRole) {
      var colRoleName = flexRole.columns.getColumn('RoleName');
      var colStatus = flexRole.columns.getColumn('Status');
      var colTimeZone = flexRole.columns.getColumn('TimeZone');

      if (colRoleName) {
        //colRoleName.showDropDown = true;
        colRoleName.dataMap = this._buildDataMap(this.rolelist, 'RoleID', 'RoleName');
      }

      if (colStatus) {
        //colStatus.showDropDown = true;
        colStatus.dataMap = this._buildDataMap(this.lstStatus, 'LookupID', 'Name');
      }

      if (colTimeZone) {
        //colTimeZone.showDropDown = true;
        colTimeZone.dataMap = this._buildDataMap(this.lsttimezone, 'TimeZoneID', 'Name');
      }

    }

    if (wfflexapprover) {
      var colFirstName = wfflexapprover.columns.getColumn('ModuleId');
      if (colFirstName) {
        //colFirstName.showDropDown = true;
        //this.lstapprover = this.lstApproverUser.filter(x => x.ModuleId);
        colFirstName.dataMap = this._buildDataMap(this.lstapprover, 'ModuleId', 'ModuleName');
      }
    }
    if (flexscheduler) {
      var colStatus = flexscheduler.columns.getColumn('Status');
      if (colStatus) {
        //colStatus.showDropDown = true;
        colStatus.dataMap = this._buildDataMap(this.lstStatus, 'LookupID', 'Name');
      }

      var colFrequency = flexscheduler.columns.getColumn('Frequency');
      if (colFrequency) {
        //colFrequency.showDropDown = true;
        colFrequency.dataMap = this._buildDataMap(this.lstFrequency, 'Frequency', 'Frequency');
      }

    }

  }

  private _buildDataMap(items:any, key:any, value:any): wjcGrid.DataMap {
    var map = [];
    if (items) {
      for (var i = 0; i < items.length; i++) {
        var obj = items[i];
        map.push({ key: obj[key], value: obj[value] });
      }
    }
    return new wjcGrid.DataMap(map, 'key', 'value');
  }

  CloseCreateRolePopUp(): void {
    var modal:any = document.getElementById('myModalCreateRole');
    modal.style.display = "none";
  }


  CreateRole(): void {
    if (this.role.NewRoleName.toString() == "") {
      this._alertinfodiv = true;
      this._alertinfomessage = "Please enter role."

      setTimeout(() =>{
        this._alertinfodiv = false;
      }, 4000);


    }
    else {
      var rolename = this.rolelist.filter((x:any) => x.RoleName.toLowerCase() == this.role.NewRoleName.toLowerCase())

      if (rolename.length == 0) {
        this.role.RoleID = '00000000-0000-0000-0000-000000000000';
        this.role.RoleName = this.role.NewRoleName;
        this.role.StatusID = 1;
        this.role.UserId = this.user.UserID;

        this._isRoleSaving = true;
        this.permissionService.AddUpdateRole(this.role).subscribe(res => {
          if (res.Succeeded) {
            this._isRoleSaving = false;

            this._ShowSuccessRolemessage = "Role: " + this.role.NewRoleName + " saved successfully."
            this._ShowSuccessmessageRolediv = true;
            setTimeout(() => {
              this._ShowSuccessmessageRolediv = false;
            }, 4000);

            this.GetRole();

          } else {

          }
        });

      } else {
        this._IsShowMsg = true;
        this._MsgText = "Role: " + this.role.NewRoleName + " already exists."
        setTimeout(() => {
          this._IsShowMsg = false;
        }, 4000);
      }
    }

  }

  showCreateRoleDialog(): void {
    this.role.NewRoleName = "";
    var modalRole:any = document.getElementById('myModalCreateRole');
    modalRole.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }


  ResetPassword() {
    this._isCalcListFetching = true;
    var userval = this.data.items[this.resetRowIndex];
    var user: any = localStorage.getItem("user");
    var userinfo = JSON.parse(user);
    userval.SuperAdminName = userinfo.FirstName + " " + userinfo.LastName;
    this.permissionService.ResetUserPassword(userval).subscribe(res => {

      if (res.Succeeded) {
        this.CloseResetPopUp();
        this._isCalcListFetching = false;
      }
      else {
        this._isCalcListFetching = false;
      }
    });

  }

  CloseResetPopUp() {
    var modal:any = document.getElementById('myModalReset');
    modal.style.display = "none";
  }


  showDeleteDialog(resetRowIndex: number) {
    this.resetRowIndex = resetRowIndex;
    this._loginID = this.data.items[this.resetRowIndex].Login;
    var modalDelete:any = document.getElementById('myModalReset');
    modalDelete.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }

  GetAllowBasicLogin() {
    this.permissionService.GetAllAppSetting().subscribe(res => {
      if (res.Succeeded) {
        var data = res.AllSettingKeys;
        if (data.find((x:any) => x.Key == "AllowBasicLogin").Value == "0")
          this._isChecked = false;
        else
          this._isChecked = true;

        if (data.find((x:any) => x.Key == "AllowDebugInCalc").Value == "0")
          this._isCalcChecked = false;
        else
          this._isCalcChecked = true;

        if (data.find((x:any) => x.Key == "AllowCalcBooster").Value == "0")
          this._iscalcboosterChecked = false;
        else
          this._iscalcboosterChecked = true;
        if (data.find((x:any) => x.Key == "AllowFFSaveJsonIntoBlob").Value == "0")
          this._isAllowFFSaveJsonIntoBlob = false;
        else
          this._isAllowFFSaveJsonIntoBlob = true;
        if (data.find(x => x.Key == "EnableM61Calculator").Value == "0") 
          this._isEnableM61Calculator = false;      
        else 
          this._isEnableM61Calculator = true;
        if (data.find((x:any) => x.Key == "AllowBackshopFF").Value == "0")
          this._isAllowBackshopFFImport = false;
        else
          this._isAllowBackshopFFImport = true;
        if (data.find((x: any) => x.Key == "AllowLiabBlobDownld").Value == "0")
          this._isLiabBlobDownldChecked = false;
        else
          this._isLiabBlobDownldChecked = true;
      }
    });

  }

  GetCalcManager() {
    this.permissionService.GetAllowBasiclogin("AllowDebugInCalc").subscribe(res => {
      if (res.Succeeded) {
        if (res.AllowBasicLogin.Value == "0")
          this._isCalcChecked = false;
        else
          this._isCalcChecked = true;
      }
    })
  }

  changeSelect(value:any) {
    this._isChecked = value;
  }
  UpdateAllowBasicLogin(valuechecked:any, Key:any) {
    this._isCalcListFetching = true;
    this._appConfig.Key = Key;
    this._appConfig.Value = valuechecked ? "1" : "0";
    this.permissionService.UpdateAllowBasicLogin(this._appConfig).subscribe(res => {
      if (res.Succeeded) {
        this._ShowSuccessmessage = "Details Saved successfully.";
        this._ShowSuccessmessagediv = true;
        setTimeout(() => {
          this._isCalcListFetching = false;
          this._ShowSuccessmessagediv = false;
        }, 2000);
      }
    });
  }


  beginningEditEmailLogin(e: wjcGrid.CellRangeEventArgs) {

    var sel = this.Userflex.selection;

    if (this.lstUsers[sel.topRow].RoleName === undefined || this.lstUsers[sel.topRow].RoleName == "") {
      this.lstUsers[sel.topRow].RoleName = "Viewer";
      this.lstUsers[sel.topRow].RoleID = "";
    }
    if (this.lstUsers[sel.topRow].Status === undefined || this.lstUsers[sel.topRow].Status == "") {
      this.lstUsers[sel.topRow].Status = "Active";
      this.lstUsers[sel.topRow].StatusID = "";
    }

    ////for setting email and login as readonly for exitimg users
    //if (e.col.toString() == "2" || e.col.toString() == "3") {

    //    if (!(this.lstUsers[sel.topRow].UserID === undefined))
    //    {
    //        e.cancel = true;
    //    }

    //}

  }
  rowEditEndedEmailLogin(): void {

    var sel = this.Userflex.selection;

    if ((this.lstUsers[sel.topRow].Email != null && this.lstUsers[sel.topRow].Email != undefined) ||
      (this.lstUsers[sel.topRow].Login != null && this.lstUsers[sel.topRow].Login != undefined)) {
      var flag = this.CheckDuplicateEmailLogin(this.lstUsers, sel.topRow);

      if (flag) {
        this.CustomAlert(this._MsgTextUser);

      }
    }



  }



  CheckDuplicateEmailLogin(lstData: any, rwNum: any): boolean {
    var checkduplicate:any;
    try {
      var i;
      for (i = 0; i < lstData.length; i++) {

        if (!(lstData[rwNum].Email === undefined)) {
          if (rwNum != i && lstData[i].Email != null && lstData[i].Email != "" && lstData[rwNum].Email.toString() == lstData[i].Email.toString()) {
            this._MsgTextUser = "Email <b>" + this.lstUsers[i].Email + "</b> already exist in the list.";
            break;
          }
        }

        if (!(lstData[rwNum].Login === undefined)) {
          if (rwNum != i && lstData[i].Login != null && lstData[i].Login != "" && lstData[rwNum].Login.toString() == lstData[i].Login.toString()) {
            this._MsgTextUser = "Login name  <b>" + this.lstUsers[i].Login + "</b> already exist in the list.";
            break;
          }
        }
      }
      if (i == lstData.length)
        checkduplicate = false;
      else
        checkduplicate = true;
    }
    catch (err) {
      console.log(err);
    }
    return checkduplicate;
  }


  CheckDuplicateEmailLoginOnSave(): boolean {
    var i;
    var isDuplicate = false;
    var userlsr = this.data.items;
    for (i = 0; i < userlsr.length; i++) {

      var emailarray = userlsr.filter(x => x.Email == userlsr[i].Email && x.Email != null && x.Email != "")
      if (emailarray.length > 1) {
        this._MsgTextUser = "Email <b>" + userlsr[i].Email + "</b> already exist in the list.";
        isDuplicate = true;
        break;
      }
      var loginarray = userlsr.filter(x => x.Login == userlsr[i].Login && x.Login != null && x.Login != "")
      if (loginarray.length > 1) {
        this._MsgTextUser = "Login name  <b>" + userlsr[i].Login + "</b> already exist in the list.";
        isDuplicate = true;
        break;
      }
    }
    return isDuplicate;

  }

  CheckMandatoryFieldsOnSave(): boolean {
    var i;
    var isRequired = false;
    var udata = this.data.items;
    for (i = 0; i < udata.length; i++) {

      if (
        ((udata[i].FirstName === undefined || udata[i].FirstName == "")
          || (udata[i].LastName === undefined || udata[i].LastName == "")
          || (udata[i].Email === undefined || udata[i].Email == "")
          || (udata[i].Login === undefined || udata[i].Login == "")) == true
        &&
        ((udata[i].FirstName === undefined || udata[i].FirstName == "")
          && (udata[i].LastName === undefined || udata[i].LastName == "")
          && (udata[i].Email === undefined || udata[i].Email == "")
          && (udata[i].Login === undefined || udata[i].Login == "")) == false
      ) {
        isRequired = true;
        this._MsgTextUser = "Please fill out all fields to proceed";
        break;

      }
      else {
        if (udata[i].ContactNo1 != undefined && udata[i].ContactNo1 != "") {
          var pattern = /^[0-9a-bA-B]+$/;
          // var pattern = /^\d*((\.|,)\d*)?$/;
          var phoneNumberPattern = /^\(?(\d{3})\)[ ]?(\d{3})[-](\d{4})$/;
          var phonepattern = /^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$/;

          //var phonepattern = /^(\d{3}-\d{3}-\d{4})$/;

          if (phonepattern.test(udata[i].ContactNo1)) {
            udata[i].ContactNo1 = udata[i].ContactNo1.replace(/\D+/g, '').replace(/^(\d{3})(\d{3})(\d{4}).*/, '($1) $2-$3');
          }
          if (!phoneNumberPattern.test(udata[i].ContactNo1)) {
            if (udata[i].ContactNo1.length != 10 || !pattern.test(udata[i].ContactNo1)) {
              isRequired = true;
              this._MsgTextUser = "Please enter valid contact number. Ex: (111) 111-1111 for login " + this.lstUsers[i].Login;
              break;
            }
          }
          if (phoneNumberPattern.test(udata[i].ContactNo1)) {
            udata[i].ContactNo1 = udata[i].ContactNo1.replace(/\D+/g, '').replace(/^(\d{3})(\d{3})(\d{4}).*/, '($1) $2-$3');
          }
          else {
            udata[i].ContactNo1 = udata[i].ContactNo1.replace(/\D+/g, '').replace(/^(\d{3})(\d{3})(\d{4}).*/, '($1) $2-$3');
          }
          //var phoneNumberPattern = /^\(?(\d{3})\)[ ]?(\d{3})[-](\d{4})$/;
          //if (!phoneNumberPattern.test(this.lstUsers[i].ContactNo1)) {

          //    isRequired = true;
          //    this._MsgTextUser = "Please enter valid contact number. Ex: (111) 111-1111";
          //    break;
          //}
        }

      }


    }
    return isRequired;

  }



  CustomAlert(dialog:any): void {
    var winW = window.innerWidth;
    var winH = window.innerHeight;
    var dialogoverlay:any = document.getElementById('dialogoverlay');
    var dialogbox:any = document.getElementById('dialogbox');
    dialogoverlay.style.display = "block";
    dialogoverlay.style.height = winH + "px";
    dialogbox.style.left = (winW / 2) - (550 * .5) + "px";
    dialogbox.style.top = "100px";
    dialogbox.style.display = "block";
    var dialogboxhead: any = document.getElementById('dialogboxhead');
    var dialogboxbody: any = document.getElementById('dialogboxbody');
    dialogboxhead.innerHTML = "CRES - web";
    dialogboxbody.innerHTML = dialog;
    //document.getElementById('dialogboxfoot').innerHTML = '<span class="custombutton" onclientclick="this.ok()">OK</span>';
  }

  ok(): void {
    var dialogoverlay: any = document.getElementById('dialogoverlay');
    var dialogbox: any = document.getElementById('dialogbox');
    dialogbox.style.display = "none";
    dialogoverlay.style.display = "none";
  }

  cellEditEndedEmailLogin(e: wjcGrid.CellEditEndingEventArgs) {

    if (e.col.toString() == "2" || e.col.toString() == "3") {

      var sel = this.Userflex.selection;

      if ((this.data[sel.topRow].Email != null && this.data[sel.topRow].Email != undefined) ||
        (this.data[sel.topRow].Login != null && this.data[sel.topRow].Login != undefined)) {
        var flag = this.CheckDuplicateEmailLogin(this.data, sel.topRow);
        if (flag) {
          this.CustomAlert(this._MsgTextUser);

        }
      }
    }

  }

  pastedEmailLogin(e: wjcGrid.CellEditEndingEventArgs) {
    var sel = this.Userflex.selection;

    if (this.lstUsers[sel.topRow].Status === undefined || this.lstUsers[sel.topRow].Status == "") {
      this.lstUsers[sel.topRow].Status = "Active";
    }
    if (this.lstUsers[sel.topRow].RoleName === undefined || this.lstUsers[sel.topRow].RoleName == "") {
      this.lstUsers[sel.topRow].RoleName = "Viewer";
    }
    if (e.col.toString() == "2" || e.col.toString() == "3") {

      if ((this.lstUsers[sel.topRow].Email != null && this.lstUsers[sel.topRow].Email != undefined) ||
        (this.lstUsers[sel.topRow].Login != null && this.lstUsers[sel.topRow].Login != undefined)) {
        var flag = this.CheckDuplicateEmailLogin(this.lstUsers, sel.topRow);

        if (flag) {
          this.CustomAlert(this._MsgTextUser);

        }
      }
    }
  }



  showForceLogoutDialog(resetRowIndex:any) {
    this._forceLogout = {
      resetRowIndex: resetRowIndex,
      userName: "All",
      userID: "null"
    }

    if (resetRowIndex != "null") {
      this._forceLogout =
      {
        resetRowIndex: resetRowIndex,
        userName: this.data.items[resetRowIndex].FirstName,
        userID: this.data.items[resetRowIndex].UserID
      }
    }
    let modalForceLogout:any = document.getElementById('myModalForceLogout');
    modalForceLogout.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }

  CloseForceLogoutPopUp() {
    var modal:any = document.getElementById('myModalForceLogout');
    modal.style.display = "none";
  }

  ForceLogout() {
    this.membershipService.ForceLogout(this._forceLogout.userID).subscribe(res => {
      if (res.Succeeded) {
        this.CloseForceLogoutPopUp();
        //this.membershipService.UserLogout();

        this._ShowSuccessmessage = this._forceLogout.userName + ' logged out successfully.';
        this._ShowSuccessmessagediv = true;
        setTimeout(() => {
          this._ShowSuccessmessagediv = false;
        }, 2000);

        let user: User;
        user = res.UserData;
        user.Token = res.Token;
        user.TokenUId = res.UserData.UserID;
       // localStorage.setItem('user', JSON.stringify(user));
       // localStorage.setItem('rolename', user.RoleName);
      }
      else {
        console.log("GetAllUsers fails!");

        this._ShowSuccessmessage = 'Forced logout failed.';
        this._ShowSuccessmessagediv = true;
        setTimeout(() => {
          this._ShowSuccessmessagediv = false;
        }, 2000);
      }

    });
  }


  GetWFApprover() {
    this._isCalcListFetching = true;
    this.membershipService.GetWFApprover().subscribe(res => {
      if (res.Succeeded) {
        this.showemailanddeletebtn = true;
        this.lstApproverUser = res.UserApproverList;
        // this.lstapprover = Array.from(new Set(this.lstApproverUser.map((item: any) => item.ModuleId)));

        this._isCalcListFetching = false;
        this._initData();
        setTimeout(() => {
          this.WFUserflexdata.invalidate();
        }, 3000);
      }
    });
    this.showemailanddeletebtn = false;
  }

  AddUpdateWFApprover() {
    this._MsgTextUser = "";
    var approvertype: string;
    //duplicate  user email
    for (var i = 0; i < this.lstApproverUser.length; i++) {

      if (this.lstApproverUser[i].Email == null || this.lstApproverUser[i].Email == '') {
        this._MsgTextUser = "Email is a required field.";
        this.CustomAlert(this._MsgTextUser);
        break;
      }
      if (this.lstApproverUser[i].Email && (!(this.lstApproverUser[i].ModuleId) || this.lstApproverUser[i].ModuleId == 0)) {
        this._MsgTextUser = "Please select approver type.";
        this.CustomAlert(this._MsgTextUser);
        break;
      }
    }
    for (var l = 0; l < this.lstApproverUser.length - 1; l++) {
      for (var k = l + 1; k < this.lstApproverUser.length; k++) {
        if (this.lstApproverUser[k].ModuleName != "" || this.lstApproverUser[k].ModuleName != null || this.lstApproverUser[k].ModuleName != undefined) {
          var approvertype = "";
          if (!(Number(this.lstApproverUser[k].ModuleName).toString() == "NaN" || Number(this.lstApproverUser[k].ModuleName) == 0)) {
            approvertype = this.lstapprover.find((x:any) => x.ModuleId == Number(this.lstApproverUser[k].ModuleName)).ModuleName
            this.lstApproverUser[k].ModuleName = approvertype;
          }
          else {
            this.lstApproverUser[k].ModuleName = this.lstApproverUser[k].ModuleName;
          }
        }

        if (this.lstApproverUser[l].Email == this.lstApproverUser[k].Email && this.lstApproverUser[l].ModuleId == this.lstApproverUser[k].ModuleId) {
          this._MsgTextUser = "Email <b>" + this.lstApproverUser[l].Email + " </b> already exists as <b> " + this.lstApproverUser[l].ModuleName;
          this.CustomAlert(this._MsgTextUser);
          break;

        }
      }
    }

    //User exists or not
    if (!this._MsgTextUser) {
      var j, approvermsg;
      approvermsg = "";
      for (i = 0; i < this.lstApproverUser.length; i++) {
        for (j = 0; j < this.lstUsers.length; j++) {
          if (this.lstUsers[j].Email.toLowerCase() == this.lstApproverUser[i].Email.toLowerCase()) {
            break;
          }
        }
        if (j == this.lstUsers.length) {
          approvermsg = approvermsg + "<p>" + this.lstApproverUser[i].Email;
        }
      }

      if (approvermsg != "") {
        approvermsg = "Below user(s) does not exist in the system:" + approvermsg;
        this.CustomAlert(approvermsg);

      }

      else {
        this._isCalcListFetching = true;
        this.membershipService.InsertUpdateWFApprover(this.lstApproverUser).subscribe(res => {
          if (res.Succeeded == true) {
            this.GetWFApprover();
            this._isCalcListFetching = false;
            this._ShowSuccessmessage = "Approver Added/Updated successfully";
            this._ShowSuccessmessagediv = true;
            setTimeout(() => {
              this._ShowSuccessmessagediv = false;
            }, 2000);
          }
        });
      }
    }
  }


  SendWFApproverEmail(userdetails :any) {
    var envname: any;
    envname = this.dataService._environmentNamae;
    this.environmentName = envname.split(/[- ]+/).pop();
    var msgapprover = "";
    this._wfapproveremail = {
      userdetails: userdetails,
      Email: "",
      ModuleId: "",
      ModuleName: "",
      FirstName: "",
      LastName: "",
      envname: ""
    }
    if (userdetails != null) {
      this._wfapproveremail =
      {
        userdetails: userdetails,
        Email: this.userdata.items[userdetails].Email,
        ModuleId: this.userdata.items[userdetails].ModuleId,
        ModuleName: this.userdata.items[userdetails].ModuleName,
        FirstName: this.userdata.items[userdetails].FirstName,
        LastName: this.user.FirstName + ' ' + this.user.LastName,
        envname: this.environmentName
      }
    }
    if (this._wfapproveremail.Email == '' || this._wfapproveremail.Email == null) {
      if (this._wfapproveremail.ModuleId == '' || this._wfapproveremail.ModuleId == null) {
        console.log("Email and Approver type is blank");
      }
    }
    else {
      this._isCalcListFetching = true;
      this.membershipService.SendWFApproverEmail(this._wfapproveremail).subscribe(res => {
        if (res.Succeeded == true) {
          this._isCalcListFetching = false;
          this._ShowSuccessmessage = 'Email Sent.';
          this._ShowSuccessmessagediv = true;
          setTimeout(() => {
            this._ShowSuccessmessagediv = false;
          }, 2000);

        }
      });
    }
  }

  GetAllTimeZone(): void {
    this.membershipService.getalltimezone().subscribe(res => {
      if (res.Succeeded) {
        this.lsttimezone = res.lstAppTimeZone;
      }
      else {
        console.log("GetAllTimeZone fails!");
      }
    });
  }

  CloseDeletePopUp() {
    var modal:any = document.getElementById('myModalDelete');
    modal.style.display = "none";
  }

  CloseSchedulerPopUp() {
    var modal:any = document.getElementById('myModalScheduler');
    modal.style.display = "none";
  }

  showDeleteDialogforwfapprover(deleteRowIndex: number) {
    this._deletewfapprover = {
      deleteRowIndex: deleteRowIndex,
      EmailNotificationID: ""
    }
    if (deleteRowIndex != null) {
      this._deletewfapprover = {
        deleteRowIndex: deleteRowIndex,
        EmailNotificationID: this.userdata.items[deleteRowIndex].EmailNotificationID
      }
    }
    if (this._deletewfapprover.EmailNotificationID == null) {
      //console.log("Delete row not have any data");
      //this.userdata.removeAt(this.deleteRowIndex);
      this.deleteRowIndex = deleteRowIndex;
      var modalDelete = document.getElementById('myModalDelete');
      modalDelete.style.display = "block";
      $.getScript("/js/jsDrag.js");
    }
    else {
      this.deleteRowIndex = deleteRowIndex;
      var modalDelete = document.getElementById('myModalDelete');
      modalDelete.style.display = "block";
      $.getScript("/js/jsDrag.js");
    }
  }

  deleteRow() {
    this.CloseDeletePopUp();
    this.DeleteWFApprover(this.deleteRowIndex);
  }

  DeleteWFApprover(userdeletedetails :any) {
    this._isCalcListFetching = true;
    this._deletewfapprover = {
      userdeletedetails: userdeletedetails,
      Email: "",
      EmailNotificationID: "",
    }
    if (userdeletedetails != null) {
      this._deletewfapprover =
      {
        userdetails: userdeletedetails,
        Email: this.userdata.items[userdeletedetails].Email,
        EmailNotificationID: this.userdata.items[userdeletedetails].EmailNotificationID,
      }
    }
    this.membershipService.DeleteWFApprover(this._deletewfapprover).subscribe(res => {
      if (res.Succeeded == true) {
        this.GetWFApprover();
        this._isCalcListFetching = false;
        this._ShowSuccessmessage = 'Workflow Approver Deleted!';
        this._ShowSuccessmessagediv = true;
        setTimeout(() => {
          this._ShowSuccessmessagediv = false;
        }, 2000);
      }
    });
  }

  GetALLSchedulerConfig(): void {
    this._isCalcListFetching = true;
    this.schedulerParam = new SchedulerParam();
    this.schedulerParam.Status = 0;
    this.schedulerParam.GroupID = 0;
    this.permissionService.getallschedulerconfig(this.schedulerParam).subscribe(res => {
      if (res.Succeeded) {
        if (typeof res.ListSchedulerConfig !== 'undefined' && res.ListSchedulerConfig.length > 0) {

          this.lstSchedulerConfig = res.ListSchedulerConfig;
          this.ConvertToBindableDateScheduler();
          this._isCalcListFetching = false;
          this._initData();
          this._bindGridDropdows();
          setTimeout(() => {
            this.flexScheduler.invalidate();
          }, 3000);
        }
        else {
          this._isCalcListFetching = false;
        }

      }
    });
  }

  private ConvertToBindableDateScheduler() {
    for (var i = 0; i < this.lstSchedulerConfig.length; i++) {
      if (this.lstSchedulerConfig[i].NextexecutionTime != null) {
        this.lstSchedulerConfig[i].NextexecutionTime = new Date(this.convertDateToBindable(this.lstSchedulerConfig[i].NextexecutionTime));
      }
    }
  }

  convertDateToBindable(date:any) {
    var dateObj = null;
    var _date: any;
    if (date) {
      if (typeof (date) == "string") {
        date = date.replace("Z", "");
        dateObj = new Date(date);
      }
      else {
        dateObj = date;
      }
      if (dateObj != null) {
       _date = this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear();
      }
    }
    return _date;
  }
  getTwoDigitString(number:any) {
    if (number.toString().length === 1)
      return "0" + number;
    return number;
  }

  AddUpdateSchedulerConfig(): void {
    var isMandatory = false;
    var isDuplicate = false;
    isMandatory = this.CheckMandatoryFieldsForScheduler();
    if (isMandatory) {
      this.CustomAlert(this._MsgTextUser);
    }
    else {
      isDuplicate = this.CheckDuplicateSchedulerName();
      if (isDuplicate) {
        this.CustomAlert(this._MsgTextUser);
      }
    }
    if (!isMandatory && !isDuplicate) {
      this._isCalcListFetching = true;


      this.permissionService.addupdateschedulerconfig(this.lstSchedulerConfig).subscribe(res => {
        if (res.Succeeded) {
          this._isCalcListFetching = false;
          this._ShowSuccessmessage = 'Scheduler config Added/Updated Successfully.';
          this._ShowSuccessmessagediv = true;
          setTimeout(()=> {
            this._ShowSuccessmessagediv = false;
          }, 2000);

          this.GetALLSchedulerConfig();

        }
        else {

          this._ShowSuccessmessage = 'Scheduler config Add/Update failed.';
          this._ShowSuccessmessagediv = true;
          setTimeout(() => {
            this._ShowSuccessmessagediv = false;
          }, 2000);
          this.GetAllUser();
        }
      },
        error => {

        }
      );
    }
  }

  CheckMandatoryFieldsForScheduler(): boolean {
    var i;
    var isRequired = false;
    for (i = 0; i < this.lstSchedulerConfig.length; i++) {

      if (
        ((this.lstSchedulerConfig[i].SchedulerName === undefined || this.lstSchedulerConfig[i].SchedulerName == "")
          || (this.lstSchedulerConfig[i].ExecutionTime === undefined || this.lstSchedulerConfig[i].ExecutionTime == "")
        ) == true

      ) {
        isRequired = true;
        this._MsgTextUser = "Please fill out all fields to proceed";
        break;

      }
      else {
        var patternAMPM = /^(1[0-2]|0?[1-9]):[0-5][0-9] ?([AaPp][Mm])$/
        // var pattern = /^\d*((\.|,)\d*)?$/;
        if (!patternAMPM.test(this.lstSchedulerConfig[i].ExecutionTime)) {
          isRequired = true;
          this._MsgTextUser = "Please enter valid Execution Time. Ex: 10:35 AM, 10:35 PM ";
          break;
        }
      }


    }
    return isRequired;

  }
  CheckDuplicateSchedulerName(): boolean {
    var isDuplicate = false;
    for (var i = 0; i < this.lstSchedulerConfig.length; i++) {

      var SchedulerNamearray = this.lstSchedulerConfig.filter(x => x.SchedulerName == this.lstSchedulerConfig[i].SchedulerName && x.SchedulerName != null && x.SchedulerName != "")
      if (SchedulerNamearray.length > 1) {
        this._MsgTextUser = "Scheduler name  <b>" + this.lstSchedulerConfig[i].SchedulerName + "</b> already exist in the list.";
        isDuplicate = true;
        break;
      }
    }
    return isDuplicate;
  }

  ShowRunSchedulerDialog(SchedulerRowIndex: number) {
    this.SelectedSchedulerName = this.lstSchedulerConfig[SchedulerRowIndex].SchedulerName;
    this.SelectedSchedulerID = this.lstSchedulerConfig[SchedulerRowIndex].SchedulerConfigID;
    var modalDelete:any = document.getElementById('myModalScheduler');
    modalDelete.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }
  RunScheduler(): void {
    this.CloseSchedulerPopUp();
    this._isCalcListFetching = true;
    this._schedulerConfig = new SchedulerConfig('');
    this._schedulerConfig.SchedulerConfigID = this.SelectedSchedulerID;
    this._schedulerConfig.GeneratedBy = "Manual"
    this.permissionService.RunScheduler(this._schedulerConfig).subscribe(res => {
      if (res.Succeeded) {
        this._isCalcListFetching = false;
        this._ShowSuccessmessage = 'Scheduler executed Successfully.';
        this._ShowSuccessmessagediv = true;
        setTimeout(() => {
          this._ShowSuccessmessagediv = false;
        }, 2000);

        this.GetALLSchedulerConfig();

      }
      else {

        this._ShowSuccessmessage = 'Scheduler execution failed.';
        this._ShowSuccessmessagediv = true;
        setTimeout(() => {
          this._ShowSuccessmessagediv = false;
        }, 2000);
        this.GetAllUser();
      }
      this._isCalcListFetching = false;
    },
      error => {

      }
    );
  }

}




const routes: Routes = [

  { path: '', component: userpermission }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjGridModule, WjGridFilterModule, WjInputModule],
  declarations: [userpermission]

})

export class userPermissionModule { }
