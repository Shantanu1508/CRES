import { Component, Inject, OnInit, ViewChild } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { User } from '../core/domain/user.model';
import { AzureADAuthService } from '../ngAuth/authenticators/azureADAuth.service';
import { MembershipService } from '../core/services/membership.service';
import { PermissionService } from '../core/services/permission.service';
import { OperationResult } from '../core/domain/operationResult.model';
import { ModuleWithProviders, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { changepasswrd } from '../core/domain/changePassword.model';
import { ModuleTabMaster } from '../core/domain/moduleTabMaster.model';
import { NotificationService } from '../core/services/notification.service';
import { UserDelegateConfiguration } from "../core/domain/userDelegateConfiguration.model";
import { UserService } from '../core/services/user.service';
import { userdefaultsetting } from '../core/domain/userDefaultSetting.model';
import { Search } from "../core/domain/search.model";
import * as wjNg2Input from '@grapecity/wijmo.angular2.input';
import * as wjcGrid from '@grapecity/wijmo.grid';
import { WjInputModule } from '@grapecity/wijmo.angular2.input';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { TimeZone } from "../core/domain/timeZone.model";
import * as wjcCore from '@grapecity/wijmo';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import { UtilityService } from '../core/services/utility.service';
//import * as $ from "jquery";
declare var $:any;

@Component({
  selector: 'changepassword',
  providers: [MembershipService, NotificationService, UserService, PermissionService],
  templateUrl: './changePassword.html'
})
export class changepassword {
  private _router: Router;
  public _changepasswrd: changepasswrd;
  public _user: User;
  private _timezone !: TimeZone;

  public ListActiveDelegatedUser: any;
  public userdelegateconfiguration: UserDelegateConfiguration;

  lstuser: any; Succeeded: any;
  private Message: any = '';
  public _Showmessagediv: boolean = false;
  public _ShowSuccessmessagediv: boolean = false;
  public _ShowSuccessmessage: any;
  public _userdefaultsetting: userdefaultsetting;
  public moduleTabMaster !: ModuleTabMaster;
  public usernameID: any;
  public usernameText: any;
  c_username: any;
  public _Showerrormessagediv: boolean = false;
  public _errormessage: any;
  lstTimeZone: any;
  private _cachedeal = {};
  private _result: any;
  private _searchObj: any;
  public _pageSizeSearch: number = 10;
  public _pageIndexSearch: number = 1;
  public _totalCountSearch: number = 0;
  task_username: any;
  public userdefsettingList !: Array<userdefaultsetting>;
  public moduleTabMasterlist: any;
  public _allowBasicLogin: boolean = true;
  _chkSelectAll: boolean = false;
  @ViewChild('flexDelegatedUser') flexuserdelegate !: wjcGrid.FlexGrid;
  public delegateuserdata !: wjcCore.CollectionView;
  public delegationMessage !: string;
  public delegationusercount: number = 0;
  public lstdelegateuser: boolean = false;
  public lstUsers: any;
  public DelegatedUserID: any;
  public _isListFetching: boolean = false;
  public _userinfo: any;
  public showcurrentoffset: boolean = false;
  constructor(public membershipService: MembershipService, public utilityService: UtilityService,
    public notificationService: NotificationService,
    router: Router,
    public userService: UserService, public permissionService: PermissionService) {
    this._changepasswrd = new changepasswrd('', '', '');
    this._chkSelectAll = false;

    this.userdelegateconfiguration = new UserDelegateConfiguration("");
    this.utilityService.setPageTitle("M61-My Account");
    this._router = router;
    var user:any = localStorage.getItem('user');
    this._user = JSON.parse(user);
    this._userdefaultsetting = new userdefaultsetting(this._user.UserID, '', '');
    this.getModuleTabMaster();
    this.SetDefaultTabName();
    this.GetAllActiveDelegatedUser();
    // this.GetUser();
    // this.onchangeCurrentOffset();
    this.GetAllUser();
    this.Onloadusercredential();
    if (localStorage.getItem('allowBasicLogin') == "true")
      this._allowBasicLogin = true;
    else
      this._allowBasicLogin = false;
  }


  //getAllLookup(): void {
  //    this.lstTimeZone = [
  //        { "LookupID": "Dateline Standard Time", "Name": "Dateline Standard Time (-12:00)" },
  //        { "LookupID": "UTC-11", "Name": "UTC-11 (-11:00)" },
  //        { "LookupID": "Aleutian Standard Time", "Name": "Aleutian Standard Time (-09:00)" },
  //        { "LookupID": "Hawaiian Standard Time", "Name": "Hawaiian Standard Time (-10:00)" },
  //        { "LookupID": "Marquesas Standard Time", "Name": "Marquesas Standard Time (-09:30)" },
  //        { "LookupID": "Alaskan Standard Time", "Name": "Alaskan Standard Time (-08:00)" },
  //        { "LookupID": "UTC-09", "Name": "UTC-09 (-09:00)" },
  //        { "LookupID": "Pacific Standard Time (Mexico)", "Name": "Pacific Standard Time (Mexico) (-07:00)" },
  //        { "LookupID": "UTC-08", "Name": "UTC-08 (-08:00)" },
  //        { "LookupID": "Pacific Standard Time", "Name": "Pacific Standard Time (-07:00)" },
  //        { "LookupID": "US Mountain Standard Time", "Name": "US Mountain Standard Time (-07:00)" },
  //        { "LookupID": "Mountain Standard Time (Mexico)", "Name": "Mountain Standard Time (Mexico) (-06:00)" },
  //        { "LookupID": "Mountain Standard Time", "Name": "Mountain Standard Time (-06:00)" },
  //        { "LookupID": "Central America Standard Time", "Name": "Central America Standard Time (-06:00)" },
  //        { "LookupID": "Central Standard Time", "Name": "Central Standard Time (-05:00)" },
  //        { "LookupID": "Easter Island Standard Time", "Name": "Easter Island Standard Time (-06:00)" },
  //        { "LookupID": "Central Standard Time (Mexico)", "Name": "Central Standard Time (Mexico) (-05:00)" },
  //        { "LookupID": "Canada Central Standard Time", "Name": "Canada Central Standard Time (-06:00)" },
  //        { "LookupID": "SA Pacific Standard Time", "Name": "SA Pacific Standard Time (-05:00)" },
  //        { "LookupID": "Eastern Standard Time (Mexico)", "Name": "Eastern Standard Time (Mexico) (-05:00)" },
  //        { "LookupID": "Eastern Standard Time", "Name": "Eastern Standard Time (-04:00)" },
  //        { "LookupID": "Haiti Standard Time", "Name": "Haiti Standard Time (-04:00)" },
  //        { "LookupID": "Cuba Standard Time", "Name": "Cuba Standard Time (-04:00)" },
  //        { "LookupID": "US Eastern Standard Time", "Name": "US Eastern Standard Time (-04:00)" },
  //        { "LookupID": "Turks And Caicos Standard Time", "Name": "Turks And Caicos Standard Time (-04:00)" },
  //        { "LookupID": "Paraguay Standard Time", "Name": "Paraguay Standard Time (-04:00)" },
  //        { "LookupID": "Atlantic Standard Time", "Name": "Atlantic Standard Time (-03:00)" },
  //        { "LookupID": "Venezuela Standard Time", "Name": "Venezuela Standard Time (-04:00)" },
  //        { "LookupID": "Central Brazilian Standard Time", "Name": "Central Brazilian Standard Time (-04:00)" },
  //        { "LookupID": "SA Western Standard Time", "Name": "SA Western Standard Time (-04:00)" },
  //        { "LookupID": "Pacific SA Standard Time", "Name": "Pacific SA Standard Time (-04:00)" },
  //        { "LookupID": "Newfoundland Standard Time", "Name": "Newfoundland Standard Time (-02:30)" },
  //        { "LookupID": "Tocantins Standard Time", "Name": "Tocantins Standard Time (-03:00)" },
  //        { "LookupID": "E. South America Standard Time", "Name": "E. South America Standard Time (-03:00)" },
  //        { "LookupID": "SA Eastern Standard Time", "Name": "SA Eastern Standard Time (-03:00)" },
  //        { "LookupID": "Argentina Standard Time", "Name": "Argentina Standard Time (-03:00)" },
  //        { "LookupID": "Greenland Standard Time", "Name": "Greenland Standard Time (-02:00)" },
  //        { "LookupID": "Montevideo Standard Time", "Name": "Montevideo Standard Time (-03:00)" },
  //        { "LookupID": "Magallanes Standard Time", "Name": "Magallanes Standard Time (-03:00)" },
  //        { "LookupID": "Saint Pierre Standard Time", "Name": "Saint Pierre Standard Time (-02:00)" },
  //        { "LookupID": "Bahia Standard Time", "Name": "Bahia Standard Time (-03:00)" },
  //        { "LookupID": "UTC-02", "Name": "UTC-02 (-02:00)" },
  //        { "LookupID": "Mid-Atlantic Standard Time", "Name": "Mid-Atlantic Standard Time (-01:00)" },
  //        { "LookupID": "Azores Standard Time", "Name": "Azores Standard Time (+00:00)" },
  //        { "LookupID": "Cape Verde Standard Time", "Name": "Cape Verde Standard Time (-01:00)" },
  //        { "LookupID": "UTC", "Name": "UTC (+00:00)" },
  //        { "LookupID": "GMT Standard Time", "Name": "GMT Standard Time (+01:00)" },
  //        { "LookupID": "Greenwich Standard Time", "Name": "Greenwich Standard Time (+00:00)" },
  //        { "LookupID": "Sao Tome Standard Time", "Name": "Sao Tome Standard Time (+00:00)" },
  //        { "LookupID": "W. Europe Standard Time", "Name": "W. Europe Standard Time (+02:00)" },
  //        { "LookupID": "Central Europe Standard Time", "Name": "Central Europe Standard Time (+02:00)" },
  //        { "LookupID": "Romance Standard Time", "Name": "Romance Standard Time (+02:00)" },
  //        { "LookupID": "Morocco Standard Time", "Name": "Morocco Standard Time (+01:00)" },
  //        { "LookupID": "Central European Standard Time", "Name": "Central European Standard Time (+02:00)" },
  //        { "LookupID": "W. Central Africa Standard Time", "Name": "W. Central Africa Standard Time (+01:00)" },
  //        { "LookupID": "Jordan Standard Time", "Name": "Jordan Standard Time (+03:00)" },
  //        { "LookupID": "GTB Standard Time", "Name": "GTB Standard Time (+03:00)" },
  //        { "LookupID": "Middle East Standard Time", "Name": "Middle East Standard Time (+03:00)" },
  //        { "LookupID": "Egypt Standard Time", "Name": "Egypt Standard Time (+02:00)" },
  //        { "LookupID": "E. Europe Standard Time", "Name": "E. Europe Standard Time (+03:00)" },
  //        { "LookupID": "Syria Standard Time", "Name": "Syria Standard Time (+03:00)" },
  //        { "LookupID": "West Bank Standard Time", "Name": "West Bank Standard Time (+03:00)" },
  //        { "LookupID": "South Africa Standard Time", "Name": "South Africa Standard Time (+02:00)" },
  //        { "LookupID": "FLE Standard Time", "Name": "FLE Standard Time (+03:00)" },
  //        { "LookupID": "Israel Standard Time", "Name": "Israel Standard Time (+03:00)" },
  //        { "LookupID": "Kaliningrad Standard Time", "Name": "Kaliningrad Standard Time (+02:00)" },
  //        { "LookupID": "Sudan Standard Time", "Name": "Sudan Standard Time (+02:00)" },
  //        { "LookupID": "Libya Standard Time", "Name": "Libya Standard Time (+02:00)" },
  //        { "LookupID": "Namibia Standard Time", "Name": "Namibia Standard Time (+02:00)" },
  //        { "LookupID": "Arabic Standard Time", "Name": "Arabic Standard Time (+03:00)" },
  //        { "LookupID": "Turkey Standard Time", "Name": "Turkey Standard Time (+03:00)" },
  //        { "LookupID": "Arab Standard Time", "Name": "Arab Standard Time (+03:00)" },
  //        { "LookupID": "Belarus Standard Time", "Name": "Belarus Standard Time (+03:00)" },
  //        { "LookupID": "Russian Standard Time", "Name": "Russian Standard Time (+03:00)" },
  //        { "LookupID": "E. Africa Standard Time", "Name": "E. Africa Standard Time (+03:00)" },
  //        { "LookupID": "Iran Standard Time", "Name": "Iran Standard Time (+04:30)" },
  //        { "LookupID": "Arabian Standard Time", "Name": "Arabian Standard Time (+04:00)" },
  //        { "LookupID": "Astrakhan Standard Time", "Name": "Astrakhan Standard Time (+04:00)" },
  //        { "LookupID": "Azerbaijan Standard Time", "Name": "Azerbaijan Standard Time (+04:00)" },
  //        { "LookupID": "Russia Time Zone 3", "Name": "Russia Time Zone 3 (+04:00)" },
  //        { "LookupID": "Mauritius Standard Time", "Name": "Mauritius Standard Time (+04:00)" },
  //        { "LookupID": "Saratov Standard Time", "Name": "Saratov Standard Time (+04:00)" },
  //        { "LookupID": "Georgian Standard Time", "Name": "Georgian Standard Time (+04:00)" },
  //        { "LookupID": "Volgograd Standard Time", "Name": "Volgograd Standard Time (+04:00)" },
  //        { "LookupID": "Caucasus Standard Time", "Name": "Caucasus Standard Time (+04:00)" },
  //        { "LookupID": "Afghanistan Standard Time", "Name": "Afghanistan Standard Time (+04:30)" },
  //        { "LookupID": "West Asia Standard Time", "Name": "West Asia Standard Time (+05:00)" },
  //        { "LookupID": "Ekaterinburg Standard Time", "Name": "Ekaterinburg Standard Time (+05:00)" },
  //        { "LookupID": "Pakistan Standard Time", "Name": "Pakistan Standard Time (+05:00)" },
  //        { "LookupID": "Qyzylorda Standard Time", "Name": "Qyzylorda Standard Time (+05:00)" },
  //        { "LookupID": "India Standard Time", "Name": "India Standard Time (+05:30)" },
  //        { "LookupID": "Sri Lanka Standard Time", "Name": "Sri Lanka Standard Time (+05:30)" },
  //        { "LookupID": "Nepal Standard Time", "Name": "Nepal Standard Time (+05:45)" },
  //        { "LookupID": "Central Asia Standard Time", "Name": "Central Asia Standard Time (+06:00)" },
  //        { "LookupID": "Bangladesh Standard Time", "Name": "Bangladesh Standard Time (+06:00)" },
  //        { "LookupID": "Omsk Standard Time", "Name": "Omsk Standard Time (+06:00)" },
  //        { "LookupID": "Myanmar Standard Time", "Name": "Myanmar Standard Time (+06:30)" },
  //        { "LookupID": "SE Asia Standard Time", "Name": "SE Asia Standard Time (+07:00)" },
  //        { "LookupID": "Altai Standard Time", "Name": "Altai Standard Time (+07:00)" },
  //        { "LookupID": "W. Mongolia Standard Time", "Name": "W. Mongolia Standard Time (+07:00)" },
  //        { "LookupID": "North Asia Standard Time", "Name": "North Asia Standard Time (+07:00)" },
  //        { "LookupID": "N. Central Asia Standard Time", "Name": "N. Central Asia Standard Time (+07:00)" },
  //        { "LookupID": "Tomsk Standard Time", "Name": "Tomsk Standard Time (+07:00)" },
  //        { "LookupID": "China Standard Time", "Name": "China Standard Time (+08:00)" },
  //        { "LookupID": "North Asia East Standard Time", "Name": "North Asia East Standard Time (+08:00)" },
  //        { "LookupID": "Singapore Standard Time", "Name": "Singapore Standard Time (+08:00)" },
  //        { "LookupID": "W. Australia Standard Time", "Name": "W. Australia Standard Time (+08:00)" },
  //        { "LookupID": "Taipei Standard Time", "Name": "Taipei Standard Time (+08:00)" },
  //        { "LookupID": "Ulaanbaatar Standard Time", "Name": "Ulaanbaatar Standard Time (+08:00)" },
  //        { "LookupID": "Aus Central W. Standard Time", "Name": "Aus Central W. Standard Time (+08:45)" },
  //        { "LookupID": "Transbaikal Standard Time", "Name": "Transbaikal Standard Time (+09:00)" },
  //        { "LookupID": "Tokyo Standard Time", "Name": "Tokyo Standard Time (+09:00)" },
  //        { "LookupID": "North Korea Standard Time", "Name": "North Korea Standard Time (+09:00)" },
  //        { "LookupID": "Korea Standard Time", "Name": "Korea Standard Time (+09:00)" },
  //        { "LookupID": "Yakutsk Standard Time", "Name": "Yakutsk Standard Time (+09:00)" },
  //        { "LookupID": "Cen. Australia Standard Time", "Name": "Cen. Australia Standard Time (+09:30)" },
  //        { "LookupID": "AUS Central Standard Time", "Name": "AUS Central Standard Time (+09:30)" },
  //        { "LookupID": "E. Australia Standard Time", "Name": "E. Australia Standard Time (+10:00)" },
  //        { "LookupID": "AUS Eastern Standard Time", "Name": "AUS Eastern Standard Time (+10:00)" },
  //        { "LookupID": "West Pacific Standard Time", "Name": "West Pacific Standard Time (+10:00)" },
  //        { "LookupID": "Tasmania Standard Time", "Name": "Tasmania Standard Time (+10:00)" },
  //        { "LookupID": "Vladivostok Standard Time", "Name": "Vladivostok Standard Time (+10:00)" },
  //        { "LookupID": "Lord Howe Standard Time", "Name": "Lord Howe Standard Time (+10:30)" },
  //        { "LookupID": "Bougainville Standard Time", "Name": "Bougainville Standard Time (+11:00)" },
  //        { "LookupID": "Russia Time Zone 10", "Name": "Russia Time Zone 10 (+11:00)" },
  //        { "LookupID": "Magadan Standard Time", "Name": "Magadan Standard Time (+11:00)" },
  //        { "LookupID": "Norfolk Standard Time", "Name": "Norfolk Standard Time (+11:00)" },
  //        { "LookupID": "Sakhalin Standard Time", "Name": "Sakhalin Standard Time (+11:00)" },
  //        { "LookupID": "Central Pacific Standard Time", "Name": "Central Pacific Standard Time (+11:00)" },
  //        { "LookupID": "Russia Time Zone 11", "Name": "Russia Time Zone 11 (+12:00)" },
  //        { "LookupID": "New Zealand Standard Time", "Name": "New Zealand Standard Time (+12:00)" },
  //        { "LookupID": "UTC+12", "Name": "UTC+12 (+12:00)" },
  //        { "LookupID": "Fiji Standard Time", "Name": "Fiji Standard Time (+12:00)" },
  //        { "LookupID": "Kamchatka Standard Time", "Name": "Kamchatka Standard Time (+13:00)" },
  //        { "LookupID": "Chatham Islands Standard Time", "Name": "Chatham Islands Standard Time (+12:45)" },
  //        { "LookupID": "UTC+13", "Name": "UTC+13 (+13:00)" },
  //        { "LookupID": "Tonga Standard Time", "Name": "Tonga Standard Time (+13:00)" },
  //        { "LookupID": "Samoa Standard Time", "Name": "Samoa Standard Time (+13:00)" },
  //        { "LookupID": "Line Islands Standard Time", "Name": "Line Islands Standard Time (+14:00)" }
  //    ];
  //}
  GetUser(): void {
    console.log("_user:", this._user);
  }

  //GetAllTimeZone(): void {
  //    this.membershipService.getallTimezone().subscribe(res => {
  //            if (res.Succeeded) {
  //                this.lstTimeZone = res.lstAppTimeZone;
  //            }
  //            else {
  //                console.log("GetAllTimeZone fails!");
  //            }
  //        });
  //}



  login(): void {
    this._errormessage = "";
    var passwrdstring = "";
    var runvalidation = false;
    if (this._changepasswrd.OldPassword == "" && this._changepasswrd.NewPassword == "" && this._changepasswrd.ConfirmPassword == "") {
      this._errormessage = "Please enter current password.";
    }
    if (this._changepasswrd.OldPassword == "") {
      passwrdstring = passwrdstring + "current password ,";
      if (this._changepasswrd.NewPassword == "") {
        if (this._changepasswrd.ConfirmPassword == "") {
        }
        else {
          runvalidation = true;
        }
      }
      else {
        runvalidation = true;
      }
    }
    else {
      runvalidation = true;
    }
    if (runvalidation == false) {
      passwrdstring = "";
    }

    if (runvalidation == true) {
      if (this._changepasswrd.NewPassword == "") {
        passwrdstring = passwrdstring + "new password ,";
      }
      if (this._changepasswrd.ConfirmPassword == "") {
        passwrdstring = passwrdstring + "confirm password ";
      }
    }
    if (passwrdstring) {
      this._errormessage = this._errormessage + "Please enter " + passwrdstring.slice(0, -1) + ".";
    }
    else if (this._changepasswrd.NewPassword != this._changepasswrd.ConfirmPassword) {
      this._errormessage = "New password and confirm password does not match."
    }

    if (!this._errormessage) {
      this.membershipService.ChangePassword(this._changepasswrd).subscribe(res => {
        if (res.Succeeded == true) {
          var data: any = res.UserData;
          this.lstuser = data;
          this.Succeeded = res.Succeeded;
          this._changepasswrd.ConfirmPassword = '';
          this._changepasswrd.NewPassword = '';
          this._changepasswrd.OldPassword = '';
          //this.Message = res.Message;
          this._ShowSuccessmessage = res.Message;
          var user: any = localStorage.getItem('user');
          var _userData = JSON.parse(user);
          this._user = res.UserData;
          this._user.Token = res.Token;
          //this.Message = "Password changed succesfully."
          this._ShowSuccessmessage = "Password changed succesfully."
          this._ShowSuccessmessagediv = true;
          setTimeout(() => {
            this._ShowSuccessmessagediv = false;
          }, 5000);
          localStorage.setItem('user', JSON.stringify(this._user));
        }
        else {
          this._errormessage = "Current password isn't correct."
          this._Showerrormessagediv = true;
          setTimeout(() => {
            this._Showerrormessagediv = false;
          }, 5000);
        }
      });
    }
    if (this._errormessage) {
      this._Showerrormessagediv = true;
      setTimeout(() => {
        this._Showerrormessagediv = false;
      }, 5000);
    }

  }

  DiscardChanges() {

    //this._router.navigate([this.routes.dashboard.name]);
    window.history.back();
  }

  Save(objNote : any): void {

    objNote.UserID = this._user.UserID;

    this.userService.UpdateUserCredentialByUserID(objNote).subscribe(res => {

      if (res.Succeeded) {

        this._user = res.UserData;
        localStorage.setItem('user', JSON.stringify(this._user));
        this._ShowSuccessmessage = "Saved successfully.";
        this._ShowSuccessmessagediv = true;

        setTimeout(() => {
          this._ShowSuccessmessagediv = false;
        }, 5000);
      }
      else {
        //  alert('failed!')
      }
    });
  }


  SaveSetting(): void {
    console.log(this.userdefsettingList);
    this.userdefsettingList.length = 0;

    if (this._userdefaultsetting.DefaultNoteTabName != null) {
      this.userdefsettingList.push(new userdefaultsetting(this._user.UserID, 'UserDefault_Note', this._userdefaultsetting.DefaultNoteTabName));
    }
    if (this._userdefaultsetting.DefaultDealTabName != null) {
      this.userdefsettingList.push(new userdefaultsetting(this._user.UserID, 'UserDefault_Deal', this._userdefaultsetting.DefaultDealTabName));
    }

    this.membershipService.InsertUpdateUserDefaultSetting(this.userdefsettingList).subscribe(res => {
      if (res.Succeeded) {
        this._ShowSuccessmessage = "Your preferences saved successfully.";
        this._ShowSuccessmessagediv = true;
        setTimeout(() => {
          this._ShowSuccessmessagediv = false;
        }, 5000);
      }
      else {

        this._errormessage = "Error occurred";
        this._Showerrormessagediv = true;
        setTimeout(() => {
          this._Showerrormessagediv = false;
        }, 5000);

      }
    });
  }
  getModuleTabMaster(): void {

    this.permissionService.GetModuleTabMaster().subscribe(res => {
      if (res.Succeeded) {
        var tabarray = res.ModuleTabMasterList.filter((item:any) => { return item.ModuleType === 'Tab'; });
        this.moduleTabMaster = tabarray;
        this.moduleTabMasterlist = tabarray;
      }
      else {
        this.moduleTabMaster;
      }
    });
  }
  SetDefaultTabName(): void {

    this._userdefaultsetting.DefaultNoteTabName = "";
    this._userdefaultsetting.DefaultDealTabName = "";

    this._userdefaultsetting.UserID = this._user.UserID;
    this.membershipService.GetUserDefaultSettingByUserID(this._userdefaultsetting).subscribe(res => {
      if (res.Succeeded) {

        this.userdefsettingList = res.UserDefaultSetting;
        this._userdefaultsetting.DefaultNoteTabName = 'Accounting';
        for (var i = 0; i < this.userdefsettingList.length; i++) {
          if (this.userdefsettingList[i].TypeText == 'UserDefault_Note') {
            this._userdefaultsetting.DefaultNoteTabName = this.userdefsettingList[i].Value;
          }
          if (this.userdefsettingList[i].TypeText == 'UserDefault_Deal') {
            this._userdefaultsetting.DefaultDealTabName = this.userdefsettingList[i].Value;
          }
        }
      }
      else {

      }

    });

  }

  showCreateDialog(): void {
    this.userdelegateconfiguration.DelegatedUserID = null;
    this.userdelegateconfiguration.Startdate = null;
    this.userdelegateconfiguration.Enddate = null;
    this.c_username = "";

    var modalRole: any = document.getElementById('myModalCreate');
    modalRole.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }

  CloseCreatePopUp(): void {
    var modal:any = document.getElementById('myModalCreate');
    modal.style.display = "none";
  }

  InsertDelegateConfiguration() {
    var dateerror = "";
    var datestring = "";
    var DateObj = new Date();
    var StartdateObj: any;
    var EnddateObj: any;
    if (this.userdelegateconfiguration.Startdate != null || this.userdelegateconfiguration.Startdate != undefined) {
      StartdateObj = new Date(this.userdelegateconfiguration.Startdate);
      var startdate = ('0' + (StartdateObj.getMonth() + 1)).slice(-2) + '/' + ('0' + StartdateObj.getDate()).slice(-2) + '/' + StartdateObj.getFullYear();
    }

    if (this.userdelegateconfiguration.Enddate != null || this.userdelegateconfiguration.Enddate != undefined) {
      EnddateObj = new Date(this.userdelegateconfiguration.Enddate);
      var enddate = ('0' + (EnddateObj.getMonth() + 1)).slice(-2) + '/' + ('0' + EnddateObj.getDate()).slice(-2) + '/' + EnddateObj.getFullYear();
    }

    var _currentdate = ('0' + (DateObj.getMonth() + 1)).slice(-2) + '/' + ('0' + DateObj.getDate()).slice(-2) + '/' + DateObj.getFullYear();
    if (StartdateObj != undefined && StartdateObj.toDateString() < DateObj.toDateString()) {
      dateerror = dateerror + "<p>" + "Start Date cannot be prior to today’s date " + _currentdate + "." + "</p>";
    }
    if (EnddateObj != undefined && EnddateObj < StartdateObj) {
      dateerror = dateerror + "<p>" + "End date can not be smaller than start date." + "</p>";
    }

    if (this.userdelegateconfiguration.DelegatedUserID == null) {
      datestring = datestring + "Username ,";
    }
    if (this.userdelegateconfiguration.Startdate == null) {
      datestring = datestring + "Start date ,";
    }
    if (this.userdelegateconfiguration.Enddate == null) {
      datestring = datestring + "End date ";
    }
    if (datestring != "") {
      dateerror = dateerror + "<p>" + datestring.slice(0, -1) + " are required field(s)." + "</p>";
    }

    if (!dateerror) {
      this._isListFetching = true;
      this.userdelegateconfiguration.DelegatedUserID = this.DelegatedUserID;
      var userdata:any = localStorage.getItem('user');
      var user = JSON.parse(userdata);
      this.userdelegateconfiguration.username = user.FirstName + ' ' + user.LastName;
      this.userService.insertUserDelegateConfig(this.userdelegateconfiguration).subscribe(res => {
        if (res.Succeeded) {
          this._isListFetching = false;
          this.userdelegateconfiguration.Startdate = null;
          this.userdelegateconfiguration.Enddate = null;
          this.GetAllActiveDelegatedUser();
          this.CloseCreatePopUp();

        } else {

        }
      });
    }
    else {
      this.CustomAlert(dateerror);
    }
  }

  public revokeindex !: number;
  public _revokedelegateuser: any;
  showRevokeDialog(revokeindex: number) {
    this.revokeindex = revokeindex;
    var modalDelete:any = document.getElementById('myModalRevoke');
    modalDelete.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }

  CloseDeletePopUp() {
    var modal:any = document.getElementById('myModalRevoke');
    modal.style.display = "none";
  }

  revokeRow() {
    this.CloseDeletePopUp();
    this.ChangeDelegateUser(this.revokeindex);
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

  ChangeDelegateUser(delegateuserdetails :any) {
    if (delegateuserdetails != null) {
      this._revokedelegateuser = this.delegateuserdata.items[delegateuserdetails].UserDelegateConfigID
    }
    this.userService.RevokeUserDelegateConfigByUserDelegateConfigID(this._revokedelegateuser).subscribe(res => {
      if (res.Succeeded) {
        this._ShowSuccessmessagediv = true;
        this._ShowSuccessmessage = "Delegate user revoked successfully.";
        setTimeout(() => {
          this._ShowSuccessmessagediv = false;
        }, 5000);
      }
      // this.delegationusercount = 0;
      this.GetAllActiveDelegatedUser();
    });

  }

  GetAllUser(): void {
    this.membershipService.GetAllUsers().subscribe(res => {
      if (res.Succeeded) {
        this.lstUsers = res.UserList;
      }
    });
  }

  GetAllActiveDelegatedUser() {
    this._isListFetching = true;
    this.delegationMessage = '';
    this.userService.getAllActiveDelegatedUser().subscribe(res => {
      if (res.Succeeded) {
        this._isListFetching = false;
        this.ListActiveDelegatedUser = res.AllActiveDelegatedUser;
        this.delegationusercount = 0;
        this.delegationusercount = this.delegationusercount + this.ListActiveDelegatedUser.length;
        if (this.ListActiveDelegatedUser.length == 0) {
          this.delegationMessage = "No delegate user found.";
          this.lstdelegateuser = false;
        }
        //AllActiveDelegatedUser
        else {
          this.lstdelegateuser = true;
          this.ConvertToBindableDate(this.ListActiveDelegatedUser);
          this.delegateuserdata = new wjcCore.CollectionView(this.ListActiveDelegatedUser);
          // track changes
          this.delegateuserdata.trackChanges = true;
          setTimeout(() => {
            this.flexuserdelegate.invalidate();
          }, 200);
        }
      } else {

      }

    });
  }
  private ConvertToBindableDate(Data:any) {
    for (var i = 0; i < Data.length; i++) {
      if (this.ListActiveDelegatedUser[i].Startdate != null)
        this.ListActiveDelegatedUser[i].Startdate = this.convertDateToBindable(this.ListActiveDelegatedUser[i].Startdate);
      if (this.ListActiveDelegatedUser[i].Enddate != null)
        this.ListActiveDelegatedUser[i].Enddate = this.convertDateToBindable(this.ListActiveDelegatedUser[i].Enddate);

    }
  }
  convertDateToBindable(date:any) {
    var dateObj = new Date(date);
    return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear();
  }
  getTwoDigitString(number:any) {
    if (number.toString().length === 1)
      return "0" + number;
    return number;
  }

  //getAutosuggestusername = this.getAutosuggestusernameFunc.bind(this);
  //getAutosuggestusernameFunc(query, max, callback) {
  //    this._result = null;

  //    var self = this,
  //        result = self._cachedeal[query];
  //    if (result) {
  //        callback(result);
  //        return;
  //    }
  //    var params = { query: query, max: max };
  //    this._searchObj = new Search(query);

  //    this.userService.getAutosuggestSearchUsername(this._searchObj, this._pageIndexSearch, this._pageSizeSearch).subscribe(res => {
  //        if (res.Succeeded) {
  //            var data: any = res.lstSearch;
  //            this._totalCountSearch = res.TotalCount;
  //            this._result = data;
  //            var _valueType;
  //            let items = [];
  //            for (var i = 0; i < this._result.length; i++) {
  //                var c = this._result[i];
  //                c.DisplayName = c.Valuekey;
  //            }

  //            callback(this._result);
  //        }
  //        else {

  //        }
  //    });
  //    error => console.error('Error: ' + error)
  //}

  checkDroppedDownChangedUserName(sender:any) {
    this.DelegatedUserID = sender;
  }

  UpdateUserByUserID(): void {

    if (this._user.ContactNo1 != undefined && this._user.ContactNo1 != "") {
      var phonenumber = this._user.ContactNo1.toString();
      var pattern = /^[0-9a-bA-B]+$/;
      var phoneNumberPattern = /^\(?(\d{3})\)[ ]?(\d{3})[-](\d{4})$/;
      var phonepattern = /^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$/;
      if (phonepattern.test(this._user.ContactNo1)) {
        this._user.ContactNo1 = phonenumber.replace(/\D+/g, '').replace(/^(\d{3})(\d{3})(\d{4}).*/, '($1) $2-$3');
      }
      if (!phoneNumberPattern.test(this._user.ContactNo1)) {
        if (this._user.ContactNo1.length != 10 || !pattern.test(this._user.ContactNo1)) {
          this._errormessage = "Please enter valid contact number. Ex: (111) 111-1111.";
          this._Showerrormessagediv = true;
          setTimeout(() => {
            this._Showerrormessagediv = false;
          }, 5000);
        }
      }
      if (phoneNumberPattern.test(this._user.ContactNo1)) {
        this._user.ContactNo1 = phonenumber.replace(/\D+/g, '').replace(/^(\d{3})(\d{3})(\d{4}).*/, '($1) $2-$3');
      }
      else {
        this._user.ContactNo1 = phonenumber.replace(/\D+/g, '').replace(/^(\d{3})(\d{3})(\d{4}).*/, '($1) $2-$3');
      }
    }

    if (this.usernameID != null) {
      this._user.TimeZone = this.usernameID;
    }

    if (!this._errormessage) {
      this.membershipService.UpdateUserByUserID(this._user).subscribe(res => {
        if (res.Succeeded) {
          //this._user.TimeZone = this.usernameID;
          localStorage.setItem('user', JSON.stringify(this._user));
          this._ShowSuccessmessage = "Saved successfully.";
          this._ShowSuccessmessagediv = true;
          setTimeout(() => {
            this._ShowSuccessmessagediv = false;
          }, 5000);
        }
        else {
          //  alert('failed!')
        }
      });
    }
  }



  onChange(sender: wjNg2Input.WjAutoComplete) {
    var ac = sender;
    // this.task_username = this._user.TimeZone;
    if (ac.selectedIndex == -1) {
      if (ac.text != this.task_username) {
        this.task_username = this._user.TimeZone;
        this.usernameID = null;
        this.usernameText = null;
      }
    }
    else {
      this.usernameID = ac.selectedValue;
      this.usernameText = ac.selectedItem.Valuekey;
      this.task_username = ac.selectedItem.Valuekey;
    }
  }



  getAutosuggesttimezone = this.getAutosuggesttimezoneFunc.bind(this);
  getAutosuggesttimezoneFunc(query: any, max: any, callback: any) {
    if(!(query.toString() == "null" || query =="" || query.toString() == "undefined")) {
      this._result = null;
      var self: any = this,
        result = self._cachedeal[query];
      if (result) {
        callback(result);
        return;
      }
      var params = { query: query, max: max };
      this._searchObj = new TimeZone(query);
      this.membershipService.getallTimezone(this._searchObj, this._pageIndexSearch, this._pageSizeSearch).subscribe(res => {
        if (res.Succeeded) {
          var data: any = res.lstAppTimeZone;
          this._result = data;
          for (var i = 0; i < this._result.length; i++) {
            var c = this._result[i];
            c.DisplayName = c.Valuekey;
          }

          callback(this._result);
        }
        else {
          console.log("Dropdown not Bind.");
        }

      });
      (error: string) => console.error('Error: ' + error)
    }
  }

  //onchangeCurrentOffset() {
  //    try {
  //        this.membershipService.getalltimezone().subscribe(res => {
  //            if (res.Succeeded == true) {
  //                var result = res.lstAppTimeZone;
  //                for (var i = 0; i < result.length; i++) {
  //                    if (this._user.TimeZone == result[i].Name) {
  //                        this.currentoffset = result[i].current_utc_offset;
  //                    }
  //                }
  //            }
  //        });
  //    }
  //    catch (Exception) {
  //        console.log(Exception);
  //    }
  //}

  Onloadusercredential() {
    this.membershipService.GetUserInfobyUserid().subscribe(res => {
      if (res.Succeeded == true) {
        this._userinfo = res._userinfo;
        this._user.TimeZone = this._userinfo.TimeZone;
      }
    });
  }

}


const routes: Routes = [

  { path: '', component: changepassword }]

@NgModule({
  imports: [FormsModule, CommonModule, WjInputModule, WjGridModule, RouterModule.forChild(routes), WjGridFilterModule],
  declarations: [changepassword]

})

export class changePasswordModule { }
