"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.changepasswordModule = exports.changepassword = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var membershipservice_1 = require("../core/services/membershipservice");
var permissionService_1 = require("../core/services/permissionService");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var changepassword_1 = require("../core/domain/changepassword");
var notificationservice_1 = require("../core/services/notificationservice");
var UserDelegateConfiguration_1 = require("../core/domain/UserDelegateConfiguration");
var userservice_1 = require("../core/services/userservice");
var userdefaultsetting_1 = require("../core/domain/userdefaultsetting");
var wjcGrid = require("wijmo/wijmo.grid");
var wijmo_angular2_input_1 = require("wijmo/wijmo.angular2.input");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var TimeZone_1 = require("../core/domain/TimeZone");
var wjcCore = require("wijmo/wijmo");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var utilityService_1 = require("../core/services/utilityService");
var changepassword = /** @class */ (function () {
    function changepassword(membershipService, utilityService, notificationService, router, userService, permissionService) {
        this.membershipService = membershipService;
        this.utilityService = utilityService;
        this.notificationService = notificationService;
        this.userService = userService;
        this.permissionService = permissionService;
        this._ShowmessagedivWar = false;
        this.Message = '';
        this._Showmessagediv = false;
        this._ShowSuccessmessagediv = false;
        this._Showerrormessagediv = false;
        this._cachedeal = {};
        this._pageSizeSearch = 10;
        this._pageIndexSearch = 1;
        this._totalCountSearch = 0;
        this._allowBasicLogin = true;
        this._chkSelectAll = false;
        this.delegationusercount = 0;
        this.lstdelegateuser = false;
        this._isListFetching = false;
        this.MyIpaddress = '';
        this.showcurrentoffset = false;
        this.getAutosuggesttimezone = this.getAutosuggesttimezoneFunc.bind(this);
        this._changepasswrd = new changepassword_1.changepasswrd('', '', '');
        this._chkSelectAll = false;
        this.userdelegateconfiguration = new UserDelegateConfiguration_1.UserDelegateConfiguration("");
        this.utilityService.setPageTitle("M61-My Account");
        this._router = router;
        this._user = JSON.parse(localStorage.getItem('user'));
        this._userdefaultsetting = new userdefaultsetting_1.userdefaultsetting(this._user.UserID, '', '');
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
    changepassword.prototype.GetUser = function () {
        console.log("_user:", this._user);
    };
    changepassword.prototype.login = function () {
        var _this = this;
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
            this._errormessage = "New password and confirm password does not match.";
        }
        if (!this._errormessage) {
            this.membershipService.ChangePassword(this._changepasswrd).subscribe(function (res) {
                if (res.Succeeded == true) {
                    var data = res.UserData;
                    _this.lstuser = data;
                    _this.Succeeded = res.Succeeded;
                    _this._changepasswrd.ConfirmPassword = '';
                    _this._changepasswrd.NewPassword = '';
                    _this._changepasswrd.OldPassword = '';
                    //this.Message = res.Message;
                    _this._ShowSuccessmessage = res.Message;
                    var _userData = JSON.parse(localStorage.getItem('user'));
                    _this._user = res.UserData;
                    _this._user.Token = res.Token;
                    //this.Message = "Password changed succesfully."
                    _this._ShowSuccessmessage = "Password changed succesfully.";
                    _this._ShowSuccessmessagediv = true;
                    setTimeout(function () {
                        this._ShowSuccessmessagediv = false;
                    }.bind(_this), 5000);
                    localStorage.setItem('user', JSON.stringify(_this._user));
                }
                else {
                    _this._errormessage = "Current password isn't correct.";
                    _this._Showerrormessagediv = true;
                    setTimeout(function () {
                        this._Showerrormessagediv = false;
                    }.bind(_this), 5000);
                }
            });
        }
        if (this._errormessage) {
            this._Showerrormessagediv = true;
            setTimeout(function () {
                this._Showerrormessagediv = false;
            }.bind(this), 5000);
        }
    };
    changepassword.prototype.DiscardChanges = function () {
        //this._router.navigate([this.routes.dashboard.name]);
        window.history.back();
    };
    changepassword.prototype.Save = function (objNote) {
        var _this = this;
        objNote.UserID = this._user.UserID;
        this.userService.UpdateUserCredentialByUserID(objNote).subscribe(function (res) {
            if (res.Succeeded) {
                _this._user = res.UserData;
                localStorage.setItem('user', JSON.stringify(_this._user));
                _this._ShowSuccessmessage = "Saved successfully.";
                _this._ShowSuccessmessagediv = true;
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                }.bind(_this), 5000);
            }
            else {
                //  alert('failed!')
            }
        });
    };
    changepassword.prototype.SaveSetting = function () {
        var _this = this;
        console.log(this.userdefsettingList);
        this.userdefsettingList.length = 0;
        if (this._userdefaultsetting.DefaultNoteTabName != null) {
            this.userdefsettingList.push(new userdefaultsetting_1.userdefaultsetting(this._user.UserID, 'UserDefault_Note', this._userdefaultsetting.DefaultNoteTabName));
        }
        if (this._userdefaultsetting.DefaultDealTabName != null) {
            this.userdefsettingList.push(new userdefaultsetting_1.userdefaultsetting(this._user.UserID, 'UserDefault_Deal', this._userdefaultsetting.DefaultDealTabName));
        }
        this.membershipService.InsertUpdateUserDefaultSetting(this.userdefsettingList).subscribe(function (res) {
            if (res.Succeeded) {
                _this._ShowSuccessmessage = "Your preferences saved successfully.";
                _this._ShowSuccessmessagediv = true;
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                }.bind(_this), 5000);
            }
            else {
                _this._errormessage = "Error occurred";
                _this._Showerrormessagediv = true;
                setTimeout(function () {
                    this._Showerrormessagediv = false;
                }.bind(_this), 5000);
            }
        });
    };
    changepassword.prototype.getModuleTabMaster = function () {
        var _this = this;
        this.permissionService.GetModuleTabMaster().subscribe(function (res) {
            if (res.Succeeded) {
                var tabarray = res.ModuleTabMasterList.filter(function (item) { return item.ModuleType === 'Tab'; });
                _this.moduleTabMaster = tabarray;
                _this.moduleTabMasterlist = tabarray;
            }
            else {
                _this.moduleTabMaster = null;
            }
        });
    };
    changepassword.prototype.SetDefaultTabName = function () {
        var _this = this;
        this._userdefaultsetting.DefaultNoteTabName = "";
        this._userdefaultsetting.DefaultDealTabName = "";
        this._userdefaultsetting.UserID = this._user.UserID;
        this.membershipService.GetUserDefaultSettingByUserID(this._userdefaultsetting).subscribe(function (res) {
            if (res.Succeeded) {
                _this.userdefsettingList = res.UserDefaultSetting;
                _this._userdefaultsetting.DefaultNoteTabName = 'Accounting';
                for (var i = 0; i < _this.userdefsettingList.length; i++) {
                    if (_this.userdefsettingList[i].TypeText == 'UserDefault_Note') {
                        _this._userdefaultsetting.DefaultNoteTabName = _this.userdefsettingList[i].Value;
                    }
                    if (_this.userdefsettingList[i].TypeText == 'UserDefault_Deal') {
                        _this._userdefaultsetting.DefaultDealTabName = _this.userdefsettingList[i].Value;
                    }
                }
            }
            else {
            }
        });
    };
    changepassword.prototype.showCreateDialog = function () {
        this.userdelegateconfiguration.DelegatedUserID = null;
        this.userdelegateconfiguration.Startdate = null;
        this.userdelegateconfiguration.Enddate = null;
        this.c_username = "";
        var modalRole = document.getElementById('myModalCreate');
        modalRole.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    changepassword.prototype.CloseCreatePopUp = function () {
        var modal = document.getElementById('myModalCreate');
        modal.style.display = "none";
    };
    changepassword.prototype.InsertDelegateConfiguration = function () {
        var _this = this;
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
            this.userService.insertUserDelegateConfig(this.userdelegateconfiguration).subscribe(function (res) {
                if (res.Succeeded) {
                    _this._isListFetching = false;
                    _this.userdelegateconfiguration.Startdate = null;
                    _this.userdelegateconfiguration.Enddate = null;
                    _this.GetAllActiveDelegatedUser();
                    _this.CloseCreatePopUp();
                }
                else {
                }
            });
        }
        else {
            this.CustomAlert(dateerror);
        }
    };
    changepassword.prototype.showRevokeDialog = function (revokeindex) {
        this.revokeindex = revokeindex;
        var modalDelete = document.getElementById('myModalRevoke');
        modalDelete.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    changepassword.prototype.CloseDeletePopUp = function () {
        var modal = document.getElementById('myModalRevoke');
        modal.style.display = "none";
    };
    changepassword.prototype.revokeRow = function () {
        this.CloseDeletePopUp();
        this.ChangeDelegateUser(this.revokeindex);
    };
    changepassword.prototype.CustomAlert = function (dialog) {
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
    };
    changepassword.prototype.ok = function () {
        document.getElementById('dialogbox').style.display = "none";
        document.getElementById('dialogoverlay').style.display = "none";
    };
    changepassword.prototype.ChangeDelegateUser = function (delegateuserdetails) {
        var _this = this;
        if (delegateuserdetails != null) {
            this._revokedelegateuser = this.delegateuserdata.items[delegateuserdetails].UserDelegateConfigID;
        }
        this.userService.RevokeUserDelegateConfigByUserDelegateConfigID(this._revokedelegateuser).subscribe(function (res) {
            if (res.Succeeded) {
                _this._ShowSuccessmessagediv = true;
                _this._ShowSuccessmessage = "Delegate user revoked successfully.";
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                }.bind(_this), 5000);
            }
            // this.delegationusercount = 0;
            _this.GetAllActiveDelegatedUser();
        });
    };
    changepassword.prototype.GetAllUser = function () {
        var _this = this;
        this.membershipService.GetAllUsers().subscribe(function (res) {
            if (res.Succeeded) {
                _this.lstUsers = res.UserList;
            }
        });
    };
    changepassword.prototype.GetAllActiveDelegatedUser = function () {
        var _this = this;
        this._isListFetching = true;
        this.delegationMessage = '';
        this.userService.getAllActiveDelegatedUser().subscribe(function (res) {
            if (res.Succeeded) {
                _this._isListFetching = false;
                _this.ListActiveDelegatedUser = res.AllActiveDelegatedUser;
                _this.delegationusercount = 0;
                _this.delegationusercount = _this.delegationusercount + _this.ListActiveDelegatedUser.length;
                if (_this.ListActiveDelegatedUser.length == 0) {
                    _this.delegationMessage = "No delegate user found.";
                    _this.lstdelegateuser = false;
                }
                //AllActiveDelegatedUser
                else {
                    _this.lstdelegateuser = true;
                    _this.ConvertToBindableDate(_this.ListActiveDelegatedUser);
                    _this.delegateuserdata = new wjcCore.CollectionView(_this.ListActiveDelegatedUser);
                    // track changes
                    _this.delegateuserdata.trackChanges = true;
                    setTimeout(function () {
                        this.flexuserdelegate.invalidate();
                    }.bind(_this), 200);
                }
            }
            else {
            }
        });
    };
    changepassword.prototype.ConvertToBindableDate = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this.ListActiveDelegatedUser[i].Startdate != null)
                this.ListActiveDelegatedUser[i].Startdate = this.convertDateToBindable(this.ListActiveDelegatedUser[i].Startdate);
            if (this.ListActiveDelegatedUser[i].Enddate != null)
                this.ListActiveDelegatedUser[i].Enddate = this.convertDateToBindable(this.ListActiveDelegatedUser[i].Enddate);
        }
    };
    changepassword.prototype.convertDateToBindable = function (date) {
        var dateObj = new Date(date);
        return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear();
    };
    changepassword.prototype.getTwoDigitString = function (number) {
        if (number.toString().length === 1)
            return "0" + number;
        return number;
    };
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
    changepassword.prototype.checkDroppedDownChangedUserName = function (sender, args) {
        var ac = args;
        this.DelegatedUserID = args;
    };
    changepassword.prototype.UpdateUserByUserID = function () {
        var _this = this;
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
            this.membershipService.UpdateUserByUserID(this._user).subscribe(function (res) {
                if (res.Succeeded) {
                    //this._user.TimeZone = this.usernameID;
                    localStorage.setItem('user', JSON.stringify(_this._user));
                    _this._ShowSuccessmessage = "Saved successfully.";
                    _this._ShowSuccessmessagediv = true;
                    setTimeout(function () {
                        this._ShowSuccessmessagediv = false;
                    }.bind(_this), 5000);
                }
                else {
                    //  alert('failed!')
                }
            });
        }
    };
    changepassword.prototype.onChange = function (sender, args) {
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
    };
    changepassword.prototype.getAutosuggesttimezoneFunc = function (query, max, callback) {
        var _this = this;
        this._result = null;
        var self = this, result = self._cachedeal[query];
        if (result) {
            callback(result);
            return;
        }
        var params = { query: query, max: max };
        this._searchObj = new TimeZone_1.TimeZone(query);
        this.membershipService.getallTimezone(this._searchObj, this._pageIndexSearch, this._pageSizeSearch).subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.lstAppTimeZone;
                _this._result = data;
                for (var i = 0; i < _this._result.length; i++) {
                    var c = _this._result[i];
                    c.DisplayName = c.Valuekey;
                }
                callback(_this._result);
            }
            else {
                console.log("Dropdown not Bind.");
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
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
    changepassword.prototype.Onloadusercredential = function () {
        var _this = this;
        this.membershipService.GetUserInfobyUserid().subscribe(function (res) {
            if (res.Succeeded == true) {
                _this._userinfo = res._userinfo;
                _this._user.TimeZone = _this._userinfo.TimeZone;
                _this._user.IpAddress = _this._userinfo.IpAddress;
            }
        });
    };
    var _a, _b;
    __decorate([
        (0, core_1.ViewChild)('flexDelegatedUser'),
        __metadata("design:type", typeof (_a = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _a : Object)
    ], changepassword.prototype, "flexuserdelegate", void 0);
    changepassword = __decorate([
        (0, core_1.Component)({
            selector: 'changepassword',
            providers: [membershipservice_1.MembershipService, notificationservice_1.NotificationService, userservice_1.UserService, permissionService_1.PermissionService],
            templateUrl: 'app/account/ChangePassword.html'
        }),
        __metadata("design:paramtypes", [membershipservice_1.MembershipService, utilityService_1.UtilityService,
            notificationservice_1.NotificationService, typeof (_b = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _b : Object, userservice_1.UserService, permissionService_1.PermissionService])
    ], changepassword);
    return changepassword;
}());
exports.changepassword = changepassword;
var routes = [
    { path: '', component: changepassword }
];
var changepasswordModule = /** @class */ (function () {
    function changepasswordModule() {
    }
    changepasswordModule = __decorate([
        (0, core_2.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, wijmo_angular2_input_1.WjInputModule, wijmo_angular2_grid_1.WjGridModule, router_2.RouterModule.forChild(routes), wijmo_angular2_grid_filter_1.WjGridFilterModule],
            declarations: [changepassword]
        })
    ], changepasswordModule);
    return changepasswordModule;
}());
exports.changepasswordModule = changepasswordModule;
//# sourceMappingURL=changePassword.component.js.map