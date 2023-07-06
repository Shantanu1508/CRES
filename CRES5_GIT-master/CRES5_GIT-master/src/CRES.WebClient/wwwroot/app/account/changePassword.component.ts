import { Component, Inject, OnInit, ViewChild } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { User } from '../core/domain/user';
import { AzureADAuthService } from '../ngauth/authenticators/azureadauthservice';
import { MembershipService } from '../core/services/membershipservice';
import { PermissionService } from '../core/services/permissionService';
import { OperationResult } from '../core/domain/operationResult';
import { ModuleWithProviders, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { Location, LocationStrategy, HashLocationStrategy } from '@angular/common';
import { Headers, RequestOptions, BaseRequestOptions } from '@angular/http';
import { changepasswrd } from '../core/domain/changepassword';
import { ModuleTabMaster } from '../core/domain/moduletabmaster';
import { NotificationService } from '../core/services/notificationservice';
import { UserDelegateConfiguration } from "../core/domain/UserDelegateConfiguration";
import { UserService } from '../core/services/userservice';
import { userdefaultsetting } from '../core/domain/userdefaultsetting';
import { Search } from "../core/domain/search";
import * as wjNg2Input from 'wijmo/wijmo.angular2.input';
import * as wjcGrid from 'wijmo/wijmo.grid';
import { WjInputModule } from 'wijmo/wijmo.angular2.input';
import { WjGridModule } from 'wijmo/wijmo.angular2.grid';
import { TimeZone } from "../core/domain/TimeZone";
import * as wjcCore from 'wijmo/wijmo';
import { WjGridFilterModule } from 'wijmo/wijmo.angular2.grid.filter';
import { UtilityService } from '../core/services/utilityService';



@Component({
    selector: 'changepassword',
    providers: [MembershipService, NotificationService, UserService, PermissionService],
    templateUrl: 'app/account/ChangePassword.html'
})
export class changepassword {
    private _router: Router;
    private _changepasswrd: changepasswrd;
    private _user: User;
    private _timezone: TimeZone;

    private ListActiveDelegatedUser: any;
    public userdelegateconfiguration: UserDelegateConfiguration;
    private _ShowmessagedivMsgWar: any;
    private _ShowmessagedivWar: boolean = false;
    lstuser: any; Succeeded: any;
    private Message: any = '';
    private _Showmessagediv: boolean = false;
    private _ShowSuccessmessagediv: boolean = false;
    private _ShowSuccessmessage: any;
    public _userdefaultsetting: userdefaultsetting;
    public moduleTabMaster: ModuleTabMaster;
    public usernameID: any;
    public usernameText: any;
    c_username: any;
    private _Showerrormessagediv: boolean = false;
    private _errormessage: any;
    lstTimeZone: any;
    private _cachedeal = {};
    private _result: any;
    private _searchObj: any;
    public _pageSizeSearch: number = 10;
    public _pageIndexSearch: number = 1;
    public _totalCountSearch: number = 0;
    task_username: any;
    public userdefsettingList: Array<userdefaultsetting>;
    public moduleTabMasterlist: any;
    private _allowBasicLogin: boolean = true;
    _chkSelectAll: boolean = false;
    @ViewChild('flexDelegatedUser') flexuserdelegate: wjcGrid.FlexGrid;
    public delegateuserdata: wjcCore.CollectionView;
    public delegationMessage: string;
    public delegationusercount: number = 0;
    public lstdelegateuser: boolean = false;
    public lstUsers: any;
    public DelegatedUserID: any;
    public _isListFetching: boolean = false;
    public _userinfo: any;
    public MyIpaddress: string = '';
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
        this._user = JSON.parse(localStorage.getItem('user'));
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



    GetUser(): void {
        console.log("_user:", this._user);
    }



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
                    var _userData = JSON.parse(localStorage.getItem('user'));
                    this._user = res.UserData;
                    this._user.Token = res.Token;
                    //this.Message = "Password changed succesfully."
                    this._ShowSuccessmessage = "Password changed succesfully."
                    this._ShowSuccessmessagediv = true;
                    setTimeout(function () {
                        this._ShowSuccessmessagediv = false;
                    }.bind(this), 5000);
                    localStorage.setItem('user', JSON.stringify(this._user));
                }
                else {
                    this._errormessage = "Current password isn't correct."
                    this._Showerrormessagediv = true;
                    setTimeout(function () {
                        this._Showerrormessagediv = false;
                    }.bind(this), 5000);
                }
            });
        }
        if (this._errormessage) {
            this._Showerrormessagediv = true;
            setTimeout(function () {
                this._Showerrormessagediv = false;
            }.bind(this), 5000);
        }
    }

    DiscardChanges() {
        //this._router.navigate([this.routes.dashboard.name]);
        window.history.back();
    }

    Save(objNote): void {
        objNote.UserID = this._user.UserID;
        this.userService.UpdateUserCredentialByUserID(objNote).subscribe(res => {

            if (res.Succeeded) {

                this._user = res.UserData;
                localStorage.setItem('user', JSON.stringify(this._user));
                this._ShowSuccessmessage = "Saved successfully.";
                this._ShowSuccessmessagediv = true;

                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                }.bind(this), 5000);
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
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                }.bind(this), 5000);
            }
            else {

                this._errormessage = "Error occurred";
                this._Showerrormessagediv = true;
                setTimeout(function () {
                    this._Showerrormessagediv = false;
                }.bind(this), 5000);

            }
        });
    }
    getModuleTabMaster(): void {

        this.permissionService.GetModuleTabMaster().subscribe(res => {
            if (res.Succeeded) {
                var tabarray = res.ModuleTabMasterList.filter(function (item) { return item.ModuleType === 'Tab'; });
                this.moduleTabMaster = tabarray;
                this.moduleTabMasterlist = tabarray;

            }
            else {
                this.moduleTabMaster = null;
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

        var modalRole = document.getElementById('myModalCreate');
        modalRole.style.display = "block";
        $.getScript("/js/jsDrag.js");
    }

    CloseCreatePopUp(): void {
        var modal = document.getElementById('myModalCreate');
        modal.style.display = "none";
    }

    InsertDelegateConfiguration() {
        var dateerror = "";
        var datestring = "";
        var DateObj = new Date();
        if (this.userdelegateconfiguration.Startdate != null || this.userdelegateconfiguration.Startdate != undefined) {
            var StartdateObj = new Date(this.userdelegateconfiguration.Startdate);
            var startdate = ('0' + (StartdateObj.getMonth() + 1)).slice(-2) + '/' + ('0' + StartdateObj.getDate()).slice(-2) + '/' + StartdateObj.getFullYear();
        }

        if (this.userdelegateconfiguration.Enddate != null || this.userdelegateconfiguration.Enddate != undefined) {
            var EnddateObj = new Date(this.userdelegateconfiguration.Enddate);
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
            var user = JSON.parse(localStorage.getItem('user'));
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

    public revokeindex: number;
    public _revokedelegateuser: any;
    showRevokeDialog(revokeindex: number) {
        this.revokeindex = revokeindex;
        var modalDelete = document.getElementById('myModalRevoke');
        modalDelete.style.display = "block";
        $.getScript("/js/jsDrag.js");
    }

    CloseDeletePopUp() {
        var modal = document.getElementById('myModalRevoke');
        modal.style.display = "none";
    }

    revokeRow() {
        this.CloseDeletePopUp();
        this.ChangeDelegateUser(this.revokeindex);
    }

    CustomAlert(dialog): void {
        var winW = window.innerWidth;
        var winH = window.innerHeight;
        var dialogoverlay = document.getElementById('dialogoverlay');
        var dialogbox = document.getElementById('dialogbox');
        dialogoverlay.style.display = "block";
        dialogoverlay.style.height = winH + "px";
        dialogbox.style.left = (winW / 2) - (550 * .5) + "px";
        dialogbox.style.top = "100px";
        dialogbox.style.display = "block";
        document.getElementById('dialogboxhead').innerHTML = "CRES - web";
        document.getElementById('dialogboxbody').innerHTML = dialog;
        //document.getElementById('dialogboxfoot').innerHTML = '<span class="custombutton" onclientclick="this.ok()">OK</span>';
    }

    ok(): void {
        document.getElementById('dialogbox').style.display = "none";
        document.getElementById('dialogoverlay').style.display = "none";
    }

    ChangeDelegateUser(delegateuserdetails) {
        if (delegateuserdetails != null) {
            this._revokedelegateuser = this.delegateuserdata.items[delegateuserdetails].UserDelegateConfigID
        }
        this.userService.RevokeUserDelegateConfigByUserDelegateConfigID(this._revokedelegateuser).subscribe(res => {
            if (res.Succeeded) {
                this._ShowSuccessmessagediv = true;
                this._ShowSuccessmessage = "Delegate user revoked successfully.";
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                }.bind(this), 5000);
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
                    setTimeout(function () {
                        this.flexuserdelegate.invalidate();
                    }.bind(this), 200);
                }
            } else {

            }

        });
    }
    private ConvertToBindableDate(Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this.ListActiveDelegatedUser[i].Startdate != null)
                this.ListActiveDelegatedUser[i].Startdate = this.convertDateToBindable(this.ListActiveDelegatedUser[i].Startdate);
            if (this.ListActiveDelegatedUser[i].Enddate != null)
                this.ListActiveDelegatedUser[i].Enddate = this.convertDateToBindable(this.ListActiveDelegatedUser[i].Enddate);

        }
    }
    convertDateToBindable(date) {
        var dateObj = new Date(date);
        return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear();
    }
    getTwoDigitString(number) {
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

    checkDroppedDownChangedUserName(sender: wjNg2Input.WjAutoComplete, args) {
        var ac = args;
        this.DelegatedUserID = args;
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
                    setTimeout(function () {
                        this._Showerrormessagediv = false;
                    }.bind(this), 5000);
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
                    setTimeout(function () {
                        this._ShowSuccessmessagediv = false;
                    }.bind(this), 5000);
                }
                else {
                    //  alert('failed!')
                }
            });
        }
    }



    onChange(sender: wjNg2Input.WjAutoComplete, args) {
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
    getAutosuggesttimezoneFunc(query, max, callback) {
        this._result = null;
        var self = this,
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
        error => console.error('Error: ' + error)
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
                this._user.IpAddress = this._userinfo.IpAddress;
            }
        });
    }

    //AddUpdateIPAddressByUserID(): void {
    //    try {
    //        this.membershipService.AddUpdateIPAddressByUserID(this._user).subscribe(res => {
    //            if (res.Succeeded) {

    //                localStorage.setItem('user', JSON.stringify(this._user));
    //                this._ShowSuccessmessage = "Your current IP address has been added/updated successfully.";
    //                this._ShowSuccessmessagediv = true;
    //                setTimeout(function () {
    //                    this._ShowSuccessmessagediv = false;
    //                }.bind(this), 5000);
    //            }
    //            else {
    //                //  alert('failed!')
    //            }
    //        });
    //    } catch (err) {
    //    }
    //}


    //SaveIPAddress() {
    //    if (this._user.IpAddress != undefined && this._user.IpAddress != "") {
    //        this.membershipService.CheckDuplicateIPAddress(this._user).subscribe(res => {
    //            if (res.Succeeded) {
    //                if (res.Message != "Duplicate") {
    //                    this.AddUpdateIPAddressByUserID();
    //                }
    //                else {
    //                    this._ShowmessagedivWar = true;
    //                    this._ShowmessagedivMsgWar = "This IP already exits, please use different IP."
    //                    setTimeout(() => {
    //                        this._ShowmessagedivWar = false;
    //                        this._ShowmessagedivMsgWar = "";
    //                    }, 3000);
    //                }
    //            }
    //            else {
    //                this._router.navigate(['login']);
    //            }
    //        });
   
    //    }
    //}

}


const routes: Routes = [

    { path: '', component: changepassword }]

@NgModule({
    imports: [FormsModule, CommonModule, WjInputModule, WjGridModule, RouterModule.forChild(routes), WjGridFilterModule],
    declarations: [changepassword]

})

export class changepasswordModule { }