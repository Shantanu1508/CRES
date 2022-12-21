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
exports.userpermissionModule = exports.userpermission = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var user_1 = require("../core/domain/user");
var membershipservice_1 = require("../core/services/membershipservice");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var notificationservice_1 = require("../core/services/notificationservice");
var permissionService_1 = require("../core/services/permissionService");
var Role_1 = require("../core/domain/Role");
var wjcGrid = require("wijmo/wijmo.grid");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_input_1 = require("wijmo/wijmo.angular2.input");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var wjcCore = require("wijmo/wijmo");
var dataService_1 = require("../core/services/dataService");
var SchedulerConfig_1 = require("../core/domain/SchedulerConfig");
var SchedulerParam_1 = require("../core/domain/SchedulerParam");
var userpermission = /** @class */ (function () {
    function userpermission(membershipService, notificationService, router, dataService, permissionService) {
        this.membershipService = membershipService;
        this.notificationService = notificationService;
        this.router = router;
        this.dataService = dataService;
        this.permissionService = permissionService;
        this._chkShowAllActiveInactiveUsers = false;
        this._isCalcListFetching = false;
        this._Showmessagediv = false;
        this._ShowSuccessmessagediv = false;
        this._ShowSuccessmessageRolediv = false;
        this._alertinfodiv = false;
        this._isChecked = false;
        this._isCalcChecked = false;
        this._iscalcboosterChecked = false;
        this.environmentName = "";
        this.showemailanddeletebtn = false;
        this._isAllowFFSaveJsonIntoBlob = false;
        this._isAllowBackshopFFImport = false;
        this._isEnableM61Calculator = false;
        this.lstFrequency = [];
        this.lstFrequency.push({ 'Frequency': 'Hourly' });
        this.lstFrequency.push({ 'Frequency': 'Daily' });
        this.lstFrequency.push({ 'Frequency': 'Weekly' });
        this.lstFrequency.push({ 'Frequency': 'Monthly' });
        permissionService.GetUserPermissionBySuperAdmin();
        this._chkSelectAll_IsEdit = false;
        this._chkSelectAll_IsView = false;
        this._chkSelectAll_IsDelete = false;
        this.user = JSON.parse(localStorage.getItem('user'));
        this._isRoleSaving = false;
        this._IsShowMsg = false;
        this._MsgText = "";
        this._MsgTextUser = "";
        this.role = new Role_1.Role("");
        this._appConfig = new user_1.AppConfig();
        this.CheckRole();
        this.GetAllUser();
        this._forceLogout = {
            resetRowIndex: "null",
            userName: "All",
            userID: "null"
        };
        this.GetAllTimeZone();
    }
    userpermission.prototype.CheckRole = function () {
        var rolename = window.localStorage.getItem("rolename");
        if (rolename != null) {
            if (rolename.toString() != "Super Admin") {
                this.router.navigate(['/login']);
            }
        }
    };
    userpermission.prototype.GetUserPermission = function () {
        var _this = this;
        this.permissionService.GetRole().subscribe(function (res) {
            if (res.Succeeded) {
                if (typeof res.RoleList !== 'undefined' && res.RoleList.length > 0) {
                    _this.rolelist = res.RoleList;
                    _this.RoleID = _this.rolelist[0].RoleID;
                    _this.GetPermissionByRoleId();
                    setTimeout(function () {
                        this.flex.invalidate();
                    }.bind(_this), 2000);
                }
                else {
                }
            }
        });
    };
    userpermission.prototype.GetRole = function () {
        var _this = this;
        this.permissionService.GetRole().subscribe(function (res) {
            if (res.Succeeded) {
                if (typeof res.RoleList !== 'undefined' && res.RoleList.length > 0) {
                    _this.rolelist = res.RoleList;
                }
                else {
                }
            }
        });
    };
    userpermission.prototype.GetPermissionByRoleId = function () {
        var _this = this;
        this._isCalcListFetching = true;
        this.permissionService.GetPermissionByRoleId(this.RoleID).subscribe(function (res) {
            if (res.Succeeded) {
                if (typeof res.ModuleTabMasterList !== 'undefined' && res.ModuleTabMasterList.length > 0) {
                    _this.moduleTabMasterList = res.ModuleTabMasterList;
                    _this._isCalcListFetching = false;
                }
                else {
                    _this._isCalcListFetching = false;
                }
            }
        });
    };
    userpermission.prototype.RoleChange = function (roleID) {
        this.RoleID = roleID;
        this.GetPermissionByRoleId();
    };
    userpermission.prototype.GetAllUser = function () {
        this._isCalcListFetching = true;
        this.GetRole();
        this.GetAllLookups();
        setTimeout(function () {
            var _this = this;
            this.UsersToUpdate = new Array();
            this.membershipService.GetAllUsers().subscribe(function (res) {
                if (res.Succeeded) {
                    _this.lstUsers = res.UserList;
                    _this._initData();
                    _this._bindGridDropdows();
                    setTimeout(function () {
                        this.Userflex.invalidate();
                        this._isCalcListFetching = false;
                    }.bind(_this), 2000);
                }
                else {
                    console.log("GetAllUsers fails!");
                }
            });
        }.bind(this), 3000);
    };
    userpermission.prototype._initData = function () {
        // create CollectionView
        // this.data = new wjcCore.CollectionView(ActiveUsersList);
        this.onChangeShowAllActiveInactiveUsers(this._chkShowAllActiveInactiveUsers);
        this.userdata = new wjcCore.CollectionView(this.lstApproverUser);
        this.schedulerdata = new wjcCore.CollectionView(this.lstSchedulerConfig);
        // track changes
        this.data.trackChanges = true;
        this.userdata.trackChanges = true;
    };
    userpermission.prototype.onChangeShowAllActiveInactiveUsers = function (newvalue) {
        // var checked = e.target.checked;
        if (newvalue == true) {
            this.data = new wjcCore.CollectionView(this.lstUsers);
            this._chkShowAllActiveInactiveUsers = true;
        }
        else {
            var lstActiveUsers = this.lstUsers.filter(function (x) { return x.Status == "Active"; });
            this.data = new wjcCore.CollectionView(lstActiveUsers);
            this._chkShowAllActiveInactiveUsers = false;
        }
        this.data.trackChanges = true;
    };
    userpermission.prototype.AddUpdateUser = function () {
        var _this = this;
        console.log(this.user);
        var isMandatory = false;
        var isDuplicate = false;
        debugger;
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
            var NewItemsAdded = this.data.itemsAdded.filter(function (x) { return ((x.FirstName !== undefined && x.FirstName != "") &&
                (x.LastName !== undefined && x.LastName != "") &&
                (x.Email !== undefined && x.Email != "") &&
                (x.Login !== undefined && x.Login != "")); });
            var NewItemsEdited = this.data.itemsEdited.filter(function (x) { return ((x.FirstName !== undefined && x.FirstName != "") &&
                (x.LastName !== undefined && x.LastName != "") &&
                (x.Email !== undefined && x.Email != "") &&
                (x.Login !== undefined && x.Login != "")); });
            if (NewItemsAdded.length > 0 || NewItemsEdited.length > 0) {
                var userinfo = JSON.parse(localStorage.getItem("user"));
                for (var i = 0; i < NewItemsAdded.length; i++) {
                    NewItemsAdded[i].UserID = '00000000-0000-0000-0000-000000000000';
                    NewItemsAdded[i].SuperAdminName = userinfo.FirstName + " " + userinfo.LastName;
                    NewItemsAdded[i].UpdatedBy = this.user.UserID;
                    if (!(Number(NewItemsAdded[i].RoleName.toString()).toString() == "NaN" || Number(NewItemsAdded[i].RoleName) == 0)) {
                        NewItemsAdded[i].RoleID = Number(NewItemsAdded[i].RoleName);
                    }
                    else {
                        var filteredarray = this.rolelist.filter(function (x) { return x.RoleID == NewItemsAdded[i].RoleName; });
                        if (filteredarray.length != 0) {
                            NewItemsAdded[i].RoleID = NewItemsAdded[i].RoleName;
                        }
                        else {
                            var filteredarrayNew = this.rolelist.filter(function (x) { return x.RoleName == NewItemsAdded[i].RoleName; });
                            if (filteredarrayNew.length != 0) {
                                NewItemsAdded[i].RoleID = filteredarrayNew[0].RoleID;
                            }
                        }
                    }
                    if (!(Number(NewItemsAdded[i].Status).toString() == "NaN" || Number(NewItemsAdded[i].Status) == 0)) {
                        NewItemsAdded[i].StatusID = Number(NewItemsAdded[i].Status);
                    }
                    else {
                        var filteredarray = this.lstStatus.filter(function (x) { return x.LookupID == NewItemsAdded[i].Status; });
                        if (filteredarray.length != 0) {
                            NewItemsAdded[i].StatusID = Number(NewItemsAdded[i].Status);
                        }
                        else {
                            var filteredarrayNew = this.lstStatus.filter(function (x) { return x.Name == NewItemsAdded[i].Status; });
                            if (filteredarrayNew.length != 0) {
                                NewItemsAdded[i].StatusID = Number(filteredarrayNew[i].StatusID);
                            }
                        }
                    }
                    if (!(NewItemsAdded[i].TimeZone == null || NewItemsAdded[i].TimeZone == undefined || NewItemsAdded[i].TimeZone == "")) {
                        var filteredarray = this.lsttimezone.filter(function (x) { return x.TimeZoneID == NewItemsAdded[i].TimeZone; });
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
                        var filteredarray = this.rolelist.filter(function (x) { return x.RoleID == NewItemsEdited[i].RoleName; });
                        if (filteredarray.length != 0) {
                            NewItemsEdited[i].RoleID = NewItemsEdited[i].RoleName;
                        }
                    }
                    if (!(Number(NewItemsEdited[i].Status.toString()).toString() == "NaN" || Number(NewItemsEdited[i].Status) == 0)) {
                        NewItemsEdited[i].StatusID = Number(NewItemsEdited[i].Status);
                    }
                    else {
                        var filteredarray = this.lstStatus.filter(function (x) { return x.LookupID == NewItemsEdited[i].Status; });
                        if (filteredarray.length != 0) {
                            NewItemsEdited[i].StatusID = Number(NewItemsEdited[i].Status);
                        }
                    }
                    if (!(NewItemsEdited[i].TimeZone == null || NewItemsEdited[i].TimeZone == undefined || NewItemsEdited[i].TimeZone == "")) {
                        var filteredarray = this.lsttimezone.filter(function (x) { return x.TimeZoneID == NewItemsEdited[i].TimeZone; });
                        if (filteredarray.length > 0) {
                            NewItemsEdited[i].TimeZone = filteredarray[0].Name;
                        }
                    }
                    this.UsersToUpdate.push(NewItemsEdited[i]);
                }
                this.membershipService.AddUpdateUser(this.UsersToUpdate).subscribe(function (res) {
                    if (res.Succeeded) {
                        for (var i = 0; i < _this.UsersToUpdate.length; i++) {
                            if (_this.UsersToUpdate[i].UserID == _this.user.UserID) {
                                _this.user.TimeZone = _this.UsersToUpdate[i].TimeZone;
                                localStorage.setItem('user', JSON.stringify(_this.user));
                            }
                        }
                        _this._isCalcListFetching = false;
                        _this._ShowSuccessmessage = 'User Added/Updated Successfully.';
                        _this._ShowSuccessmessagediv = true;
                        setTimeout(function () {
                            this._ShowSuccessmessagediv = false;
                        }.bind(_this), 2000);
                        _this.GetAllUser();
                    }
                    else {
                        _this._ShowSuccessmessage = 'User Add/Update failed.';
                        _this._ShowSuccessmessagediv = true;
                        setTimeout(function () {
                            this._ShowSuccessmessagediv = false;
                        }.bind(_this), 2000);
                        _this.GetAllUser();
                    }
                }, function (error) {
                });
            }
            else {
                this.GetAllUser();
                this._isCalcListFetching = false;
                this._ShowSuccessmessage = 'User Added/Updated Successfully.';
                this._ShowSuccessmessagediv = true;
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                }.bind(this), 2000);
            }
        }
    };
    userpermission.prototype.SavePermission = function () {
        var _this = this;
        for (var i = 0; i < this.moduleTabMasterList.length; i++) {
            this.moduleTabMasterList[i].RoleID = this.RoleID;
        }
        this._isCalcListFetching = true;
        this.permissionService.InsertUpdateUserPermissionByRoleID(this.moduleTabMasterList).subscribe(function (res) {
            if (res.Succeeded) {
                _this._isCalcListFetching = false;
                _this._ShowSuccessmessage = "Permission for role is saved successfully.";
                _this._ShowSuccessmessagediv = true;
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                }.bind(_this), 5000);
            }
        });
    };
    userpermission.prototype.SelectAll = function (input) {
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
    };
    userpermission.prototype.GetAllLookups = function () {
        var _this = this;
        this.permissionService.getAllLookupById().subscribe(function (res) {
            var data = res.lstLookups;
            _this.lstStatus = data.filter(function (x) { return x.ParentID == "1"; });
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
            _this.lstapprover = [
                { "ModuleId": "606", "ModuleName": "First draw approver" },
                { "ModuleId": "552", "ModuleName": "Tier 2 approver" },
                { "ModuleId": "617", "ModuleName": "Tier 1 approver" },
                { "ModuleId": "720", "ModuleName": " REO Reserve Group" }
            ];
            _this._bindGridDropdows();
        });
    };
    userpermission.prototype._bindGridDropdows = function () {
        var flexRole = this.Userflex;
        var wfflexapprover = this.WFUserflexdata;
        var flexscheduler = this.flexScheduler;
        if (flexRole) {
            var colRoleName = flexRole.columns.getColumn('RoleName');
            var colStatus = flexRole.columns.getColumn('Status');
            var colTimeZone = flexRole.columns.getColumn('TimeZone');
            if (colRoleName) {
                colRoleName.showDropDown = true;
                colRoleName.dataMap = this._buildDataMap(this.rolelist, 'RoleID', 'RoleName');
            }
            if (colStatus) {
                colStatus.showDropDown = true;
                colStatus.dataMap = this._buildDataMap(this.lstStatus, 'LookupID', 'Name');
            }
            if (colTimeZone) {
                colTimeZone.showDropDown = true;
                colTimeZone.dataMap = this._buildDataMap(this.lsttimezone, 'TimeZoneID', 'Name');
            }
        }
        if (wfflexapprover) {
            var colFirstName = wfflexapprover.columns.getColumn('ModuleId');
            if (colFirstName) {
                colFirstName.showDropDown = true;
                //this.lstapprover = this.lstApproverUser.filter(x => x.ModuleId);
                colFirstName.dataMap = this._buildDataMap(this.lstapprover, 'ModuleId', 'ModuleName');
            }
        }
        if (flexscheduler) {
            var colStatus = flexscheduler.columns.getColumn('Status');
            if (colStatus) {
                colStatus.showDropDown = true;
                colStatus.dataMap = this._buildDataMap(this.lstStatus, 'LookupID', 'Name');
            }
            var colFrequency = flexscheduler.columns.getColumn('Frequency');
            if (colFrequency) {
                colFrequency.showDropDown = true;
                colFrequency.dataMap = this._buildDataMap(this.lstFrequency, 'Frequency', 'Frequency');
            }
        }
    };
    userpermission.prototype._buildDataMap = function (items, key, value) {
        var map = [];
        if (items) {
            for (var i = 0; i < items.length; i++) {
                var obj = items[i];
                map.push({ key: obj[key], value: obj[value] });
            }
        }
        return new wjcGrid.DataMap(map, 'key', 'value');
    };
    userpermission.prototype.CloseCreateRolePopUp = function () {
        var modal = document.getElementById('myModalCreateRole');
        modal.style.display = "none";
    };
    userpermission.prototype.CreateRole = function () {
        var _this = this;
        if (this.role.NewRoleName.toString() == "") {
            this._alertinfodiv = true;
            this._alertinfomessage = "Please enter role.";
            setTimeout(function () {
                this._alertinfodiv = false;
            }.bind(this), 4000);
        }
        else {
            var rolename = this.rolelist.filter(function (x) { return x.RoleName.toLowerCase() == _this.role.NewRoleName.toLowerCase(); });
            if (rolename.length == 0) {
                this.role.RoleID = '00000000-0000-0000-0000-000000000000';
                this.role.RoleName = this.role.NewRoleName;
                this.role.StatusID = 1;
                this.role.UserId = this.user.UserID;
                this._isRoleSaving = true;
                this.permissionService.AddUpdateRole(this.role).subscribe(function (res) {
                    if (res.Succeeded) {
                        _this._isRoleSaving = false;
                        _this._ShowSuccessRolemessage = "Role: " + _this.role.NewRoleName + " saved successfully.";
                        _this._ShowSuccessmessageRolediv = true;
                        setTimeout(function () {
                            this._ShowSuccessmessageRolediv = false;
                        }.bind(_this), 4000);
                        _this.GetRole();
                    }
                    else {
                    }
                });
            }
            else {
                this._IsShowMsg = true;
                this._MsgText = "Role: " + this.role.NewRoleName + " already exists.";
                setTimeout(function () {
                    this._IsShowMsg = false;
                }.bind(this), 4000);
            }
        }
    };
    userpermission.prototype.showCreateRoleDialog = function () {
        this.role.NewRoleName = "";
        var modalRole = document.getElementById('myModalCreateRole');
        modalRole.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    userpermission.prototype.ResetPassword = function () {
        var _this = this;
        this._isCalcListFetching = true;
        var userval = this.data.items[this.resetRowIndex];
        var userinfo = JSON.parse(localStorage.getItem("user"));
        userval.SuperAdminName = userinfo.FirstName + " " + userinfo.LastName;
        this.permissionService.ResetUserPassword(userval).subscribe(function (res) {
            if (res.Succeeded) {
                _this.CloseResetPopUp();
                _this._isCalcListFetching = false;
            }
            else {
                _this._isCalcListFetching = false;
            }
        });
    };
    userpermission.prototype.CloseResetPopUp = function () {
        var modal = document.getElementById('myModalReset');
        modal.style.display = "none";
    };
    userpermission.prototype.showDeleteDialog = function (resetRowIndex) {
        this.resetRowIndex = resetRowIndex;
        this._loginID = this.data.items[this.resetRowIndex].Login;
        var modalDelete = document.getElementById('myModalReset');
        modalDelete.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    userpermission.prototype.GetAllowBasicLogin = function () {
        var _this = this;
        this.permissionService.GetAllAppSetting().subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.AllSettingKeys;
                if (data.find(function (x) { return x.Key == "AllowBasicLogin"; }).Value == "0") {
                    _this._isChecked = false;
                }
                else {
                    _this._isChecked = true;
                }
                if (data.find(function (x) { return x.Key == "AllowDebugInCalc"; }).Value == "0") {
                    _this._isCalcChecked = false;
                }
                else {
                    _this._isCalcChecked = true;
                }
                if (data.find(function (x) { return x.Key == "AllowCalcBooster"; }).Value == "0") {
                    _this._iscalcboosterChecked = false;
                }
                else {
                    _this._iscalcboosterChecked = true;
                }
                if (data.find(function (x) { return x.Key == "AllowFFSaveJsonIntoBlob"; }).Value == "0") {
                    _this._isAllowFFSaveJsonIntoBlob = false;
                }
                else {
                    _this._isAllowFFSaveJsonIntoBlob = true;
                }
                if (data.find(function (x) { return x.Key == "EnableM61Calculator"; }).Value == "0") {
                    _this._isEnableM61Calculator = false;
                }
                else {
                    _this._isEnableM61Calculator = true;
                }
                if (data.find(function (x) { return x.Key == "AllowBackshopFF"; }).Value == "0") {
                    _this._isAllowBackshopFFImport = false;
                }
                else {
                    _this._isAllowBackshopFFImport = true;
                }
            }
        });
    };
    userpermission.prototype.GetCalcManager = function () {
        var _this = this;
        this.permissionService.GetAllowBasiclogin("AllowDebugInCalc").subscribe(function (res) {
            if (res.Succeeded) {
                if (res.AllowBasicLogin.Value == "0")
                    _this._isCalcChecked = false;
                else
                    _this._isCalcChecked = true;
            }
        });
    };
    userpermission.prototype.changeSelect = function (value) {
        this._isChecked = value;
    };
    userpermission.prototype.UpdateAllowBasicLogin = function (valuechecked, Key) {
        var _this = this;
        this._isCalcListFetching = true;
        this._appConfig.Key = Key;
        this._appConfig.Value = valuechecked ? "1" : "0";
        this.permissionService.UpdateAllowBasicLogin(this._appConfig).subscribe(function (res) {
            if (res.Succeeded) {
                _this._ShowSuccessmessage = "Details Saved successfully.";
                _this._ShowSuccessmessagediv = true;
                setTimeout(function () {
                    this._isCalcListFetching = false;
                    this._ShowSuccessmessagediv = false;
                }.bind(_this), 2000);
            }
        });
    };
    userpermission.prototype.beginningEditEmailLogin = function (e) {
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
    };
    userpermission.prototype.rowEditEndedEmailLogin = function () {
        var sel = this.Userflex.selection;
        if ((this.lstUsers[sel.topRow].Email != null && this.lstUsers[sel.topRow].Email != undefined) ||
            (this.lstUsers[sel.topRow].Login != null && this.lstUsers[sel.topRow].Login != undefined)) {
            var flag = this.CheckDuplicateEmailLogin(this.lstUsers, sel.topRow);
            if (flag) {
                this.CustomAlert(this._MsgTextUser);
            }
        }
    };
    userpermission.prototype.CheckDuplicateEmailLogin = function (lstData, rwNum) {
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
                return false;
            else
                return true;
        }
        catch (err) {
            console.log(err);
        }
    };
    userpermission.prototype.CheckDuplicateEmailLoginOnSave = function () {
        var i;
        var isDuplicate = false;
        var userlsr = this.data.items;
        for (i = 0; i < userlsr.length; i++) {
            var emailarray = userlsr.filter(function (x) { return x.Email == userlsr[i].Email && x.Email != null && x.Email != ""; });
            if (emailarray.length > 1) {
                this._MsgTextUser = "Email <b>" + userlsr[i].Email + "</b> already exist in the list.";
                isDuplicate = true;
                break;
            }
            var loginarray = userlsr.filter(function (x) { return x.Login == userlsr[i].Login && x.Login != null && x.Login != ""; });
            if (loginarray.length > 1) {
                this._MsgTextUser = "Login name  <b>" + userlsr[i].Login + "</b> already exist in the list.";
                isDuplicate = true;
                break;
            }
        }
        return isDuplicate;
    };
    userpermission.prototype.CheckMandatoryFieldsOnSave = function () {
        var i;
        var isRequired = false;
        var udata = this.data.items;
        for (i = 0; i < udata.length; i++) {
            if (((udata[i].FirstName === undefined || udata[i].FirstName == "")
                || (udata[i].LastName === undefined || udata[i].LastName == "")
                || (udata[i].Email === undefined || udata[i].Email == "")
                || (udata[i].Login === undefined || udata[i].Login == "")) == true
                &&
                    ((udata[i].FirstName === undefined || udata[i].FirstName == "")
                        && (udata[i].LastName === undefined || udata[i].LastName == "")
                        && (udata[i].Email === undefined || udata[i].Email == "")
                        && (udata[i].Login === undefined || udata[i].Login == "")) == false) {
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
    };
    userpermission.prototype.CustomAlert = function (dialog) {
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
    userpermission.prototype.ok = function () {
        document.getElementById('dialogbox').style.display = "none";
        document.getElementById('dialogoverlay').style.display = "none";
    };
    userpermission.prototype.cellEditEndedEmailLogin = function (e) {
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
    };
    userpermission.prototype.pastedEmailLogin = function (e) {
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
    };
    userpermission.prototype.showForceLogoutDialog = function (resetRowIndex) {
        this._forceLogout = {
            resetRowIndex: resetRowIndex,
            userName: "All",
            userID: "null"
        };
        if (resetRowIndex != "null") {
            this._forceLogout =
                {
                    resetRowIndex: resetRowIndex,
                    userName: this.data.items[resetRowIndex].FirstName,
                    userID: this.data.items[resetRowIndex].UserID
                };
        }
        var modalForceLogout = document.getElementById('myModalForceLogout');
        modalForceLogout.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    userpermission.prototype.CloseForceLogoutPopUp = function () {
        var modal = document.getElementById('myModalForceLogout');
        modal.style.display = "none";
    };
    userpermission.prototype.ForceLogout = function () {
        var _this = this;
        this.membershipService.ForceLogout(this._forceLogout.userID).subscribe(function (res) {
            if (res.Succeeded) {
                _this.CloseForceLogoutPopUp();
                //this.membershipService.UserLogout();
                _this._ShowSuccessmessage = _this._forceLogout.userName + ' logged out successfully.';
                _this._ShowSuccessmessagediv = true;
                setTimeout(function () {
                    _this._ShowSuccessmessagediv = false;
                }, 2000);
                var user = void 0;
                user = res.UserData;
                user.Token = res.Token;
                user.TokenUId = res.UserData.UserID;
                //localStorage.setItem('user', JSON.stringify(user));
                //localStorage.setItem('rolename', user.RoleName);
            }
            else {
                console.log("GetAllUsers fails!");
                _this._ShowSuccessmessage = 'Forced logout failed.';
                _this._ShowSuccessmessagediv = true;
                setTimeout(function () {
                    _this._ShowSuccessmessagediv = false;
                }, 2000);
            }
        });
    };
    userpermission.prototype.GetWFApprover = function () {
        var _this = this;
        this._isCalcListFetching = true;
        this.membershipService.GetWFApprover().subscribe(function (res) {
            if (res.Succeeded) {
                _this.showemailanddeletebtn = true;
                _this.lstApproverUser = res.UserApproverList;
                // this.lstapprover = Array.from(new Set(this.lstApproverUser.map((item: any) => item.ModuleId)));
                _this._isCalcListFetching = false;
                _this._initData();
                setTimeout(function () {
                    this.WFUserflexdata.invalidate();
                }.bind(_this), 3000);
            }
        });
        this.showemailanddeletebtn = false;
    };
    userpermission.prototype.onChangeWFApprover = function (e, userdetail) {
    };
    userpermission.prototype.AddUpdateWFApprover = function () {
        var _this = this;
        this._MsgTextUser = "";
        var approvertype;
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
                        approvertype = this.lstapprover.find(function (x) { return x.ModuleId == Number(_this.lstApproverUser[k].ModuleName); }).ModuleName;
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
                this.membershipService.InsertUpdateWFApprover(this.lstApproverUser).subscribe(function (res) {
                    if (res.Succeeded == true) {
                        _this.GetWFApprover();
                        _this._isCalcListFetching = false;
                        _this._ShowSuccessmessage = "Approver Added/Updated successfully";
                        _this._ShowSuccessmessagediv = true;
                        setTimeout(function () {
                            this._ShowSuccessmessagediv = false;
                        }.bind(_this), 2000);
                    }
                });
            }
        }
    };
    userpermission.prototype.SendWFApproverEmail = function (userdetails) {
        var _this = this;
        var envname;
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
        };
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
                };
        }
        if (this._wfapproveremail.Email == '' || this._wfapproveremail.Email == null) {
            if (this._wfapproveremail.ModuleId == '' || this._wfapproveremail.ModuleId == null) {
                console.log("Email and Approver type is blank");
            }
        }
        else {
            this._isCalcListFetching = true;
            this.membershipService.SendWFApproverEmail(this._wfapproveremail).subscribe(function (res) {
                if (res.Succeeded == true) {
                    _this._isCalcListFetching = false;
                    _this._ShowSuccessmessage = 'Email Sent.';
                    _this._ShowSuccessmessagediv = true;
                    setTimeout(function () {
                        this._ShowSuccessmessagediv = false;
                    }.bind(_this), 2000);
                }
            });
        }
    };
    userpermission.prototype.GetAllTimeZone = function () {
        var _this = this;
        this.membershipService.getalltimezone().subscribe(function (res) {
            if (res.Succeeded) {
                _this.lsttimezone = res.lstAppTimeZone;
            }
            else {
                console.log("GetAllTimeZone fails!");
            }
        });
    };
    userpermission.prototype.CloseDeletePopUp = function () {
        var modal = document.getElementById('myModalDelete');
        modal.style.display = "none";
    };
    userpermission.prototype.CloseSchedulerPopUp = function () {
        var modal = document.getElementById('myModalScheduler');
        modal.style.display = "none";
    };
    userpermission.prototype.showDeleteDialogforwfapprover = function (deleteRowIndex) {
        this._deletewfapprover = {
            deleteRowIndex: deleteRowIndex,
            EmailNotificationID: ""
        };
        if (deleteRowIndex != null) {
            this._deletewfapprover = {
                deleteRowIndex: deleteRowIndex,
                EmailNotificationID: this.userdata.items[deleteRowIndex].EmailNotificationID
            };
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
    };
    userpermission.prototype.deleteRow = function () {
        this.CloseDeletePopUp();
        this.DeleteWFApprover(this.deleteRowIndex);
    };
    userpermission.prototype.DeleteWFApprover = function (userdeletedetails) {
        var _this = this;
        this._isCalcListFetching = true;
        this._deletewfapprover = {
            userdeletedetails: userdeletedetails,
            Email: "",
            EmailNotificationID: "",
        };
        if (userdeletedetails != null) {
            this._deletewfapprover =
                {
                    userdetails: userdeletedetails,
                    Email: this.userdata.items[userdeletedetails].Email,
                    EmailNotificationID: this.userdata.items[userdeletedetails].EmailNotificationID,
                };
        }
        this.membershipService.DeleteWFApprover(this._deletewfapprover).subscribe(function (res) {
            if (res.Succeeded == true) {
                _this.GetWFApprover();
                _this._isCalcListFetching = false;
                _this._ShowSuccessmessage = 'Workflow Approver Deleted!';
                _this._ShowSuccessmessagediv = true;
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                }.bind(_this), 2000);
            }
        });
    };
    userpermission.prototype.GetALLSchedulerConfig = function () {
        var _this = this;
        this._isCalcListFetching = true;
        this.schedulerParam = new SchedulerParam_1.SchedulerParam();
        this.schedulerParam.Status = 0;
        this.schedulerParam.GroupID = 0;
        this.permissionService.getallschedulerconfig(this.schedulerParam).subscribe(function (res) {
            if (res.Succeeded) {
                if (typeof res.ListSchedulerConfig !== 'undefined' && res.ListSchedulerConfig.length > 0) {
                    _this.lstSchedulerConfig = res.ListSchedulerConfig;
                    _this.ConvertToBindableDateScheduler();
                    _this._isCalcListFetching = false;
                    _this._initData();
                    _this._bindGridDropdows();
                    setTimeout(function () {
                        this.flexScheduler.invalidate();
                    }.bind(_this), 3000);
                }
                else {
                    _this._isCalcListFetching = false;
                }
            }
        });
    };
    userpermission.prototype.ConvertToBindableDateScheduler = function () {
        for (var i = 0; i < this.lstSchedulerConfig.length; i++) {
            if (this.lstSchedulerConfig[i].NextexecutionTime != null) {
                this.lstSchedulerConfig[i].NextexecutionTime = new Date(this.convertDateToBindable(this.lstSchedulerConfig[i].NextexecutionTime));
            }
        }
    };
    userpermission.prototype.convertDateToBindable = function (date) {
        var dateObj = null;
        if (date) {
            if (typeof (date) == "string") {
                date = date.replace("Z", "");
                dateObj = new Date(date);
            }
            else {
                dateObj = date;
            }
            if (dateObj != null) {
                return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear();
            }
        }
    };
    userpermission.prototype.getTwoDigitString = function (number) {
        if (number.toString().length === 1)
            return "0" + number;
        return number;
    };
    userpermission.prototype.AddUpdateSchedulerConfig = function () {
        var _this = this;
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
            this.permissionService.addupdateschedulerconfig(this.lstSchedulerConfig).subscribe(function (res) {
                if (res.Succeeded) {
                    _this._isCalcListFetching = false;
                    _this._ShowSuccessmessage = 'Scheduler config Added/Updated Successfully.';
                    _this._ShowSuccessmessagediv = true;
                    setTimeout(function () {
                        this._ShowSuccessmessagediv = false;
                    }.bind(_this), 2000);
                    _this.GetALLSchedulerConfig();
                }
                else {
                    _this._ShowSuccessmessage = 'Scheduler config Add/Update failed.';
                    _this._ShowSuccessmessagediv = true;
                    setTimeout(function () {
                        this._ShowSuccessmessagediv = false;
                    }.bind(_this), 2000);
                    _this.GetAllUser();
                }
            }, function (error) {
            });
        }
    };
    userpermission.prototype.CheckMandatoryFieldsForScheduler = function () {
        var i;
        var isRequired = false;
        for (i = 0; i < this.lstSchedulerConfig.length; i++) {
            if (((this.lstSchedulerConfig[i].SchedulerName === undefined || this.lstSchedulerConfig[i].SchedulerName == "")
                || (this.lstSchedulerConfig[i].ExecutionTime === undefined || this.lstSchedulerConfig[i].ExecutionTime == "")) == true) {
                isRequired = true;
                this._MsgTextUser = "Please fill out all fields to proceed";
                break;
            }
            else {
                var patternAMPM = /^(1[0-2]|0?[1-9]):[0-5][0-9] ?([AaPp][Mm])$/;
                // var pattern = /^\d*((\.|,)\d*)?$/;
                if (!patternAMPM.test(this.lstSchedulerConfig[i].ExecutionTime)) {
                    isRequired = true;
                    this._MsgTextUser = "Please enter valid Execution Time. Ex: 10:35 AM, 10:35 PM ";
                    break;
                }
            }
        }
        return isRequired;
    };
    userpermission.prototype.CheckDuplicateSchedulerName = function () {
        var _this = this;
        var i;
        var isDuplicate = false;
        for (i = 0; i < this.lstSchedulerConfig.length; i++) {
            var SchedulerNamearray = this.lstSchedulerConfig.filter(function (x) { return x.SchedulerName == _this.lstSchedulerConfig[i].SchedulerName && x.SchedulerName != null && x.SchedulerName != ""; });
            if (SchedulerNamearray.length > 1) {
                this._MsgTextUser = "Scheduler name  <b>" + this.lstSchedulerConfig[i].SchedulerName + "</b> already exist in the list.";
                isDuplicate = true;
                break;
            }
        }
        return isDuplicate;
    };
    userpermission.prototype.ShowRunSchedulerDialog = function (SchedulerRowIndex) {
        this.SelectedSchedulerName = this.lstSchedulerConfig[SchedulerRowIndex].SchedulerName;
        this.SelectedSchedulerID = this.lstSchedulerConfig[SchedulerRowIndex].SchedulerConfigID;
        var modalDelete = document.getElementById('myModalScheduler');
        modalDelete.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    userpermission.prototype.RunScheduler = function () {
        var _this = this;
        this.CloseSchedulerPopUp();
        this._isCalcListFetching = true;
        this._schedulerConfig = new SchedulerConfig_1.SchedulerConfig('');
        this._schedulerConfig.SchedulerConfigID = this.SelectedSchedulerID;
        this._schedulerConfig.GeneratedBy = "Manual";
        this.permissionService.RunScheduler(this._schedulerConfig).subscribe(function (res) {
            if (res.Succeeded) {
                _this._isCalcListFetching = false;
                _this._ShowSuccessmessage = 'Scheduler executed Successfully.';
                _this._ShowSuccessmessagediv = true;
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                }.bind(_this), 2000);
                _this.GetALLSchedulerConfig();
            }
            else {
                _this._ShowSuccessmessage = 'Scheduler execution failed.';
                _this._ShowSuccessmessagediv = true;
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                }.bind(_this), 2000);
                _this.GetAllUser();
            }
            _this._isCalcListFetching = false;
        }, function (error) {
        });
    };
    var _a, _b, _c, _d, _e;
    __decorate([
        (0, core_1.ViewChild)('flexpermission'),
        __metadata("design:type", typeof (_a = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _a : Object)
    ], userpermission.prototype, "flex", void 0);
    __decorate([
        (0, core_1.ViewChild)('flex'),
        __metadata("design:type", typeof (_b = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _b : Object)
    ], userpermission.prototype, "Userflex", void 0);
    __decorate([
        (0, core_1.ViewChild)('userflexdata'),
        __metadata("design:type", typeof (_c = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _c : Object)
    ], userpermission.prototype, "WFUserflexdata", void 0);
    __decorate([
        (0, core_1.ViewChild)('flexScheduler'),
        __metadata("design:type", typeof (_d = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _d : Object)
    ], userpermission.prototype, "flexScheduler", void 0);
    userpermission = __decorate([
        (0, core_1.Component)({
            selector: 'userpermission',
            providers: [membershipservice_1.MembershipService, notificationservice_1.NotificationService, permissionService_1.PermissionService],
            templateUrl: 'app/account/userpermission.html'
        }),
        __metadata("design:paramtypes", [membershipservice_1.MembershipService,
            notificationservice_1.NotificationService, typeof (_e = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _e : Object, dataService_1.DataService,
            permissionService_1.PermissionService])
    ], userpermission);
    return userpermission;
}());
exports.userpermission = userpermission;
var routes = [
    { path: '', component: userpermission }
];
var userpermissionModule = /** @class */ (function () {
    function userpermissionModule() {
    }
    userpermissionModule = __decorate([
        (0, core_2.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule, wijmo_angular2_input_1.WjInputModule],
            declarations: [userpermission]
        })
    ], userpermissionModule);
    return userpermissionModule;
}());
exports.userpermissionModule = userpermissionModule;
//# sourceMappingURL=userpermission.component.js.map