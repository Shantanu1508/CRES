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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppComponent = void 0;
var common_1 = require("@angular/common");
var core_1 = require("@angular/core");
var http_1 = require("@angular/http");
var platform_browser_1 = require("@angular/platform-browser");
var router_1 = require("@angular/router");
var wjNg2Input = require("wijmo/wijmo.angular2.input");
var BotMessage_1 = require("./core/domain/BotMessage");
var Scenario_1 = require("./core/domain/Scenario");
var search_1 = require("./core/domain/search");
var autologoutservice_1 = require("./core/services/autologoutservice");
var chatService_1 = require("./core/services/chatService");
var dataService_1 = require("./core/services/dataService");
var membershipservice_1 = require("./core/services/membershipservice");
var pushnotificationservice_1 = require("./core/services/pushnotificationservice");
//import { CalculationManagerComponent } from './components/calculationmanager.component';
var scenarioService_1 = require("./core/services/scenarioService");
var searchService_1 = require("./core/services/searchService");
var utilityService_1 = require("./core/services/utilityService");
var azureadauthservice_1 = require("./ngauth/authenticators/azureadauthservice");
var notification_component_1 = require("./Notification/notification.component");
var signalRService_1 = require("./Notification/signalRService");
var loggingservice_1 = require("./core/services/loggingservice");
var AppComponent = /** @class */ (function () {
    function AppComponent(_authService, membershipService, _router, activatedRoute, searchService, utilityService, location, dataService, _signalRService, pushNotificationService, scenarioService, sanitizer, autoLogout, httpClient, loggingService, chatservice) {
        this._authService = _authService;
        this.membershipService = membershipService;
        this._router = _router;
        this.activatedRoute = activatedRoute;
        this.searchService = searchService;
        this.utilityService = utilityService;
        this.location = location;
        this.dataService = dataService;
        this._signalRService = _signalRService;
        this.pushNotificationService = pushNotificationService;
        this.scenarioService = scenarioService;
        this.sanitizer = sanitizer;
        this.autoLogout = autoLogout;
        this.httpClient = httpClient;
        this.loggingService = loggingService;
        this.chatservice = chatservice;
        this._isSearchDataFetching = false;
        this._dvEmptySearchMsg = false;
        this._pageSizeSearch = 10;
        this._pageIndexSearch = 1;
        this._totalCountSearch = 0;
        this._totalCount = 0;
        this._isShowDealMenu = true;
        this._isShowNoteMenu = true;
        this._callmenupermisisoncode = false;
        this._isShowPropertyMenu = true;
        this._isShowFinancingMenu = true;
        this._isShowCMMenu = true;
        this._isShowIndexesMenu = true;
        this._isShowreportMenu = true;
        this._isShowUnderwritingMenu = true;
        this._isShowAddNewTopMenu = true;
        this._isShowAddNewTopMenuUserProfile = true;
        this._isShowAddNewTopMenuAlert = true;
        this._isNotificationsshow = false;
        this.currentnotificationcount = 0;
        this.unotification = new Array();
        this._pageIndex = 1;
        this._isGetMenuPermission = false;
        this._isShowRuleEngineMenu = true;
        this._isShowWorkFlowMenu = true;
        this._isShowDynamicPortfolio = true;
        this._isShowPeriodicCloseMenu = true;
        this._isShowScenario = true;
        this._isShowFeeConfiguration = true;
        this._isShowTransactionReconciliation = true;
        this._isShowImpersonate = false;
        this._isShowReturntoimpersonator = false;
        this._returnToImpersonator = null;
        this._isShowTagMasterMenu = true;
        this._isShowChatBox = false;
        this._issessionstart = false;
        this._isuserinactive = false;
        this.title = 'CRES';
        this.description = 'New deal';
        this.formValue = "";
        this._isrefreshsession = false;
        this._issearch = false;
        this._index = 0;
        this.botstatus = '';
        this._isnewpageRender = false;
        this.isPageRender = false;
        this._issearchbox = false;
        this._isShowchatpopup = false;
        this.isChatEnabled = false;
        this.userspeech = '';
        this.isAnsReceived = false;
        this._ShowmessagedivWar = false;
        this._Showmessagediv = false;
        this._ShowSuccessmessagediv = false;
        this._existsdealnamefound = false;
        this._cache = {};
        this.getAutosuggestData = this.getAutosuggestDataFunc.bind(this);
        this._scenariodc = new Scenario_1.Scenario('');
        this._lstScenario = this._scenariodc.LstScenarioUserMap;
        var _impersonateuserData = JSON.parse(localStorage.getItem('impersonatorUserInfo'));
        if (_impersonateuserData != null || _impersonateuserData != undefined) {
            this.GetUsersToImpersonate();
        }
        this.HideMenu();
        this.MenuforViewer();
        setTimeout(function () {
            this.subscribeToEvents();
        }.bind(this), 8000);
        $("#notificationscount").text("");
        var returnUrl = this._router.url;
        if (returnUrl.indexOf('dashboard') > -1 || returnUrl == '/' || returnUrl == '') {
            this._isShowchatpopup = false;
        }
        localStorage.setItem('IsChatmsgBind', 'false');
        this.dataService.getIPAddress();
    }
    AppComponent.prototype.HideMenu = function () {
        var ret_val = false;
        var rolename = window.localStorage.getItem("rolename");
        if (rolename != null) {
            if (rolename.toString() == "Super Admin") {
                ret_val = true;
            }
        }
        return ret_val;
    };
    AppComponent.prototype.MenuforViewer = function () {
        var ret_val = false;
        var rolename = window.localStorage.getItem("rolename");
        if (rolename != null) {
            if (rolename.toString() == "Viewer") {
                ret_val = true;
            }
        }
        return ret_val;
    };
    AppComponent.prototype.AddUpdateIPAddressByUserID = function () {
        var _this = this;
        try {
            this.membershipService.AddUpdateIPAddressByUserID(this._user).subscribe(function (res) {
                if (res.Succeeded) {
                    localStorage.setItem('user', JSON.stringify(_this._user));
                    _this._ShowSuccessmessage = "Your current IP address has been added/updated successfully.";
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
        catch (err) {
        }
    };
    AppComponent.prototype.SaveIPAddress = function () {
        var _this = this;
        this.IPAddress = JSON.parse(localStorage.getItem('userIP'));
        this._user = JSON.parse(localStorage.getItem('user'));
        this._user.IpAddress = this.IPAddress;
        if (this._user.IpAddress != undefined && this._user.IpAddress != "") {
            this.membershipService.CheckDuplicateIPAddress(this._user).subscribe(function (res) {
                if (res.Succeeded) {
                    if (res.Message != "Duplicate") {
                        _this.AddUpdateIPAddressByUserID();
                    }
                    else {
                        _this._ShowmessagedivWar = true;
                        _this._ShowmessagedivMsgWar = "This IP already exits, please use different IP.";
                        setTimeout(function () {
                            _this._ShowmessagedivWar = false;
                            _this._ShowmessagedivMsgWar = "";
                        }, 3000);
                    }
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
    };
    AppComponent.prototype.GetAllUserNotification = function () {
        var _this = this;
        this._isNotificationsshow = true;
        var d = new Date();
        this.notificationmessage = "";
        var datestring = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate() + " " +
            d.getHours() + ":" + d.getMinutes();
        this.unotification = new Array();
        //    alert('_pageIndex' + this._pageIndex);   
        //  if ($("#notificationscount").text() != "") {
        //this.searchService.getAllUserNotification(datestring.toString()).subscribe(res => {
        //    if (res.Succeeded) {
        this.pushNotificationService.getallnotification(datestring.toString(), this._pageIndex, 10).subscribe(function (res) {
            if (res.Succeeded == true) {
                _this.unotification = res.lstUserNotification;
                _this.currentnotificationcount = _this.unotification.length;
                if (_this.currentnotificationcount > 0) {
                    for (var i = 0; i < _this.unotification.length; i++) {
                        if (window.location.href.indexOf("dealdetail/a") > -1) {
                            _this.unotification[i].Msg = _this.unotification[i].Msg.toString().replace('dealdetail/a/', 'dealdetail/');
                        }
                        else if (_this.unotification[i].Msg.indexOf("dealdetail/") > -1) {
                            _this.unotification[i].Msg = _this.unotification[i].Msg.toString().replace('dealdetail/', 'dealdetail/a/');
                        }
                        if (window.location.href.indexOf("notedetail/a") > -1) {
                            _this.unotification[i].Msg = _this.unotification[i].Msg.toString().replace('notedetail/a/', 'notedetail/');
                        }
                        else if (_this.unotification[i].Msg.indexOf("notedetail/") > -1) {
                            _this.unotification[i].Msg = _this.unotification[i].Msg.toString().replace('notedetail/', 'notedetail/a/');
                        }
                    }
                }
                else {
                    _this.unotification = new Array();
                    _this._isNotificationsshow = false;
                    _this.notificationmessage = "No new notifications found";
                }
                if (_this._Notificationscount == 0) {
                    _this._Notificationscount = null;
                    _this._NotificationscountText = "";
                    _this._isNotificationsshow = false;
                }
                _this.ClearNotificationcount();
                _this._isNotificationsshow = false;
            }
            else {
                _this._isNotificationsshow = false;
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    AppComponent.prototype.ClearNotificationcount = function () {
        var _this = this;
        if (this._Notificationscount != 0) {
            $("#notificationscount").text("");
            this.pushNotificationService.ClearUserNotificationCount().subscribe(function (res) {
                if (res.Succeeded) {
                    _this._Notificationscount = 0;
                    _this._NotificationscountText = "";
                    _this._isNotificationsshow = false;
                }
            });
        }
    };
    AppComponent.prototype.ClearAllNotification = function () {
        var _this = this;
        this.pushNotificationService.ClearAllUserNotification().subscribe(function (res) {
            if (res.Succeeded) {
                $("#notificationscount").text("");
                _this._Notificationscount = 0;
                _this._NotificationscountText = "";
                _this.unotification = new Array();
                _this.notificationmessage = "No new notifications.";
                //  this._Notificationscount--;
                //alert(JSON.stringify(this._Notifications));
            }
        });
    };
    AppComponent.prototype.CloseNotification = function (id, e) {
        e.stopPropagation();
        this.pushNotificationService.ClearUserNotification(id).subscribe(function (res) {
            if (res.Succeeded == true) {
                $("#" + id).hide();
            }
        });
    };
    AppComponent.prototype.GetUserNotificationCount = function () {
        var _this = this;
        //   e.preventDefault();       
        this.pushNotificationService.GetUserNotificationCount().subscribe(function (res) {
            if (res.Succeeded) {
                _this._Notificationscount = res.exceptioncount;
                _this._totalCount = res.TotalCount;
                _this._NotificationscountText = res.exceptioncount;
                if (_this._Notificationscount == 0) {
                    $("#notificationscount").text("");
                }
                else {
                    if (_this._Notificationscount > 99) {
                        $("#notificationscount").text("99+");
                    }
                    else {
                        $("#notificationscount").text(_this._NotificationscountText);
                    }
                }
            }
        });
    };
    AppComponent.prototype.getUserName = function () {
        var useremil = window.localStorage.getItem("useremail");
        //  alert('useremil' + useremil);
        if (useremil.toString() == "undefined") {
            if (this._callmenupermisisoncode == false) {
                this._callmenupermisisoncode = true;
                this._isShowDealMenu = false;
                this._isShowNoteMenu = false;
                this._isShowPropertyMenu = false;
                this._isShowFinancingMenu = false;
                this._isShowCMMenu = false;
                this._isShowIndexesMenu = false;
                this._isShowreportMenu = false;
                this._isShowUnderwritingMenu = false;
                //top menu
                this._isShowAddNewTopMenu = false;
                this._isShowAddNewTopMenuUserProfile = false;
                this._isShowAddNewTopMenuAlert = false;
                this._isShowRuleEngineMenu = false;
                this._isShowWorkFlowMenu = false;
                this._isShowDynamicPortfolio = false;
                this._isShowScenario = false;
                this._isShowFeeConfiguration = false;
                this._isShowTransactionReconciliation = false;
                this._isShowPeriodicCloseMenu = false;
                this._isShowTagMasterMenu = false;
                this.GetMenuPermission();
                //  this.GetUsersToImpersonate();
                setTimeout(function () {
                    this.GetUserNotificationCount();
                }.bind(this), 6000);
            }
        }
        else {
            var _userData = JSON.parse(localStorage.getItem('user'));
            //if (_userData == "" || _userData == null) {
            //    this.GetMenuPermission();
            //}
            if (!this._isGetMenuPermission) {
                this._isGetMenuPermission = true;
                this._callmenupermisisoncode = true;
                this._isShowDealMenu = false;
                this._isShowNoteMenu = false;
                this._isShowPropertyMenu = false;
                this._isShowFinancingMenu = false;
                this._isShowCMMenu = false;
                this._isShowIndexesMenu = false;
                this._isShowreportMenu = false;
                this._isShowUnderwritingMenu = false;
                //top menu
                this._isShowAddNewTopMenu = false;
                this._isShowAddNewTopMenuUserProfile = false;
                this._isShowAddNewTopMenuAlert = false;
                this._isShowRuleEngineMenu = false;
                this._isShowWorkFlowMenu = false;
                this._isShowDynamicPortfolio = false;
                this._isShowScenario = false;
                this._isShowFeeConfiguration = false;
                this._isShowTransactionReconciliation = false;
                this._isShowPeriodicCloseMenu = false;
                this._isShowTagMasterMenu = false;
                this.GetMenuPermission();
                //  this.GetUsersToImpersonate();
            }
            return _userData.FirstName;
        }
        var _userData = JSON.parse(localStorage.getItem('user'));
        return _userData.FirstName;
    };
    AppComponent.prototype.getemailId = function () {
        var useremail = this._authService.getemail();
        localStorage.setItem('useremail', useremail);
        this._isSearchDataFetching = false;
        return useremail;
    };
    AppComponent.prototype.isUserLoggedIn = function () {
        this.getemailId();
        return this.membershipService.isUserAuthenticated();
    };
    AppComponent.prototype.logout = function (state) {
        var _this = this;
        if (state === void 0) { state = "/"; }
        var useremil = window.localStorage.getItem("useremail");
        if (useremil.toString() !== "undefined") {
            var link = window.location.href;
            link = link.substr(0, link.lastIndexOf("/"));
            // window.location.href = "https://login.microsoftonline.com/b8267886-f0c8-4160-ab6f-6e97968fdc90/oauth2/logout?post_logout_redirect_uri=" + "http://acore.azurewebsites.net/"
            this._authService.LogOutall();
            localStorage.removeItem('user');
            localStorage.removeItem('useremail');
            window.localStorage.removeItem("id_token");
            window.localStorage.removeItem("access_token");
            window.localStorage.removeItem("allowbasiclogin");
            window.localStorage.clear();
        }
        else {
            this.membershipService.logout()
                .subscribe(function (res) {
                var link = ['/login'];
                _this._router.navigate(link);
                _this._callmenupermisisoncode = false;
            }, function (error) { return console.error('Errro' + error); }, function () { });
        }
        //update for reload left menu after new login
        this._isGetMenuPermission = false;
    };
    // select first item if user presses enter and nothing is selected
    AppComponent.prototype.initialized = function (sender, e) {
        var ac = sender;
        var totalCount = this._totalCountSearch;
        var _isAIEnable = this.dataService._isAIEnable;
        ac.hostElement.addEventListener('keydown', function (e) {
            if (e.keyCode == 13 && ac.text && ac.selectedIndex < 0) {
                if (_isAIEnable == "false") {
                    document.getElementById('hdnSearchCount').value = "1";
                    var inputValue = document.getElementById('hdnSearchCount').value;
                    ac.selectedIndex = 0;
                }
            }
        });
    };
    // handle dropdown clicks: this method gets invoked when the dropdown's itemClicked event fires
    AppComponent.prototype.checkTextboxChanged = function (sender, e) {
        var ac = sender;
        var x = e.which || e.keyCode;
        var _isboxclicked = false;
        var inputValue = document.getElementById('hdnSearchCount').value;
        if (inputValue == '1') {
            this._isSearchDataFetching = true;
            document.getElementById('hdnSearchCount').value = "0";
            if (this.dataService._isAIEnable == "false") {
                ac.selectedIndex = 0;
            }
            setTimeout(function () {
                this.checkDroppedDownChanged(sender, e);
            }.bind(this), 2000);
        }
    };
    // to assign display name to innerhtml
    AppComponent.prototype.formatautocompleteListbox = function (sender, e) {
        var data = e.data;
        e.item.innerHTML = data.DisplayName;
    };
    // handle dropdown clicks: this method gets invoked when the dropdown's itemClicked event fires
    AppComponent.prototype.checkDroppedDownChanged = function (sender, e) {
        var ac = sender;
        if (ac.selectedIndex > -1) {
            var obj = JSON.parse(JSON.stringify(ac.selectedItem));
            this._isSearchDataFetching = true;
            var text = ac.text;
            var guid = ac.selectedValue;
            var _foundMatch = false;
            if (this.dataService._isAIEnable == "true") {
                //@ is present in string
                if (this._issearch == true) {
                    var chkstr = ac.text.indexOf('@');
                    // if deal name contains @
                    if (chkstr > 0) {
                        this._existsdealnamefound = true;
                        var select = ac.text;
                    }
                    else {
                        var select = this.formValue + ac.text;
                    }
                    //@ present at the start
                    if (this.formValue == "") {
                        var select = ac.text;
                        this.sendMessage(sender, e);
                        _foundMatch = true;
                    }
                }
                else {
                    //selected value from dropdown
                    if ((this.formValue.length >= 2) || (ac.text.length != this.formValue.length)) {
                        var select = ac.text;
                        this.sendMessage(sender, e);
                        _foundMatch = true;
                    }
                    else {
                        //typed not selected
                        if (this.formValue.length == ac.text.length) {
                            var select = ac.text;
                            this.sendMessage(sender, e);
                            ac.text = "";
                        }
                    }
                }
                if (_foundMatch == false) {
                    ac.text = "";
                    if (select != undefined) {
                        ac.text = select;
                    }
                }
                else {
                    setTimeout(function () {
                        ac.text = "";
                    }.bind(this), 2500);
                }
            }
            else {
                this.defaultSearch(ac, obj);
            }
            //Update Rank=======================
            this._searchObj.ValueID = guid;
            this._searchObj.Valuekey = text;
            this.searchService.UpdateRankInSearchItem(this._searchObj).subscribe(function (res) {
                if (res.Succeeded) {
                }
                else {
                }
            });
            (function (error) { return console.error('Error: ' + error); });
            setTimeout(function () {
                this._isSearchDataFetching = false;
            }.bind(this), 2000);
            // to stop open deal via AI if opened with click
            //setTimeout(function () {
            //    this._issearchbox = false;
            //}.bind(this), 4000);
            //===================================
            if (this.dataService._isAIEnable == "false") {
                ac.text = "";
                this._router.navigate(this._pagePath);
            }
        }
    };
    AppComponent.prototype.defaultSearch = function (ac, obj) {
        // if (this._issearch == false && this.botstatus != "0") {
        this._issearchbox = true;
        this._isnewpageRender = true;
        if (obj.ValueType == 283) {
            this._temppagePath = ['dealdetail'];
            if (window.location.href.indexOf("dealdetail/a") > -1) {
                this._pagePath = ['dealdetail', ac.selectedValue];
            }
            else {
                this._pagePath = ['dealdetail/a', ac.selectedValue];
            }
        }
        else if (obj.ValueType == 182) {
            this._temppagePath = ['notedetail'];
            if (window.location.href.indexOf("notedetail/a") > -1) {
                this._pagePath = ['notedetail', ac.selectedValue];
            }
            else {
                this._pagePath = ['notedetail/a', ac.selectedValue];
            }
        }
    };
    AppComponent.prototype.getAutosuggestDataFunc = function (query, max, callback) {
        var _this = this;
        this._isSearchDataFetching = true;
        this._issearch = false;
        var _foundMatch = '';
        this.formValue = '';
        var _newformValue;
        var newquerystring = query;
        _foundMatch = newquerystring;
        query = newquerystring.replace(/\\/g, '');
        this._index = newquerystring.indexOf('@');
        this.formValue = newquerystring;
        if (this._index >= 0) {
            this._issearch = true;
            _newformValue = _foundMatch.split("@");
            query = _newformValue[1];
            this.formValue = '';
            if (this._index > 0) {
                this.formValue = _newformValue[0];
            }
        }
        //autosearch enable after 1 character 
        if (query.length >= 2) {
            // try getting the result from the cache
            var self = this, result = self._cache[query];
            if (result) {
                this._dvEmptySearchMsg = false;
                this._isSearchDataFetching = false;
                callback(result);
                return;
            }
            // not in cache, get from server
            var params = { query: query, max: max };
            this._searchObj = new search_1.Search(query);
            // try getting the result from the cache
            var self = this, result = self._cache[query];
            if (result) {
                this._dvEmptySearchMsg = false;
                this._isSearchDataFetching = false;
                callback(result);
                return;
            }
            // not in cache, get from server
            var params = { query: query, max: max };
            this._searchObj = new search_1.Search(query);
            this.searchService.getAutosuggestSearchData(this._searchObj, this._pageIndexSearch, this._pageSizeSearch).subscribe(function (res) {
                if (res.Succeeded) {
                    var data = res.lstSearch;
                    //this._totalCountSearch = 1; //res.TotalCount;
                    _this._result = data;
                    _this._totalCountSearch = _this._result.length;
                    //alert('this._totalCountSearch' + this._totalCountSearch);
                    // (<HTMLInputElement>document.getElementById('hdnSearchCount')).value = "0";
                    //show message for 1 sec. when no record found
                    //if (this._result.length == 0) {
                    //   this._dvEmptySearchMsg = true;
                    //  setTimeout(() => {
                    //     this._dvEmptySearchMsg = false;
                    // }, 1000);
                    // }
                    // add 'DisplayName' property to result
                    var items = [];
                    for (var i = 0; i < _this._result.length; i++) {
                        var c = _this._result[i];
                        var _valueType;
                        if (c.ValueType == 283) { //Deal
                            _valueType = '<img src="../images/letter-d-blue-icon.png" /> ';
                        }
                        else if (c.ValueType == 182) { //Note
                            _valueType = '<img src="../images/letter-n-blue-icon.png" /> ';
                        }
                        c.DisplayName = _valueType + c.Valuekey;
                    }
                    callback(_this._result);
                }
                else {
                    _this.utilityService.navigateToSignIn();
                }
            });
            (function (error) { return console.error('Error: ' + error); });
        }
    };
    AppComponent.prototype.GetMenuPermission = function () {
        var _this = this;
        try {
            this.membershipService.getuserpermision().subscribe(function (res) {
                if (res.Succeeded) {
                    if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                        var _object = res.UserPermissionList;
                        for (var i = 0; i < _object.length; i++) {
                            if (_object[i].ChildModule == 'Deal') {
                                _this._isShowDealMenu = true;
                            }
                            if (_object[i].ChildModule == 'Reports') {
                                _this._isShowreportMenu = true;
                            }
                            if (_object[i].ChildModule == 'Notes') {
                                _this._isShowNoteMenu = true;
                            }
                            if (_object[i].ChildModule == 'Financing') {
                                _this._isShowFinancingMenu = true;
                            }
                            if (_object[i].ChildModule == 'CalculationManager') {
                                _this._isShowCMMenu = true;
                            }
                            if (_object[i].ChildModule == 'Indexes') {
                                _this._isShowIndexesMenu = true;
                            }
                            if (_object[i].ChildModule == 'Properties') {
                                _this._isShowPropertyMenu = true;
                            }
                            if (_object[i].ChildModule == 'Integration') {
                                _this._isShowUnderwritingMenu = true;
                            }
                            if (_object[i].ChildModule == 'AddNew') {
                                _this._isShowAddNewTopMenu = true;
                            }
                            if (_object[i].ChildModule == 'UserProfile') {
                                _this._isShowAddNewTopMenuUserProfile = true;
                            }
                            if (_object[i].ChildModule == 'Alert') {
                                _this._isShowAddNewTopMenuAlert = true;
                            }
                            if (_object[i].ChildModule == 'RuleEngine') {
                                _this._isShowRuleEngineMenu = true;
                            }
                            if (_object[i].ChildModule.toLowerCase() == 'workflow') {
                                _this._isShowWorkFlowMenu = true;
                            }
                            if (_object[i].ChildModule == 'Dynamic_Portfolio') {
                                _this._isShowDynamicPortfolio = true;
                            }
                            if (_object[i].ChildModule == 'ScenarioManagementPage') {
                                _this._isShowScenario = true;
                            }
                            if (_object[i].ChildModule == 'Fee_Configuration') {
                                _this._isShowFeeConfiguration = true;
                            }
                            if (_object[i].ChildModule == 'Transaction_Reconciliation') {
                                _this._isShowTransactionReconciliation = true;
                            }
                            if (_object[i].ChildModule == 'Periodic_Close') {
                                _this._isShowPeriodicCloseMenu = true;
                            }
                            if (_object[i].ChildModule == 'Tag_Master') {
                                _this._isShowTagMasterMenu = true;
                            }
                            //if (_object[i].ChildModule == 'btnChatBox') {
                            //    this._isShowChatBox = true;
                            //    this.createHBOTApi();
                            //}
                        }
                    }
                    _this.GetUserToken();
                    _this.getAllDistinctScenario();
                }
            });
        }
        catch (err) {
            alert(err);
        }
    };
    AppComponent.prototype.GetUsersToImpersonate = function () {
        var _this = this;
        try {
            var user = JSON.parse(localStorage.getItem('user'));
            if (localStorage.getItem('impersonatorUserInfo') != null && localStorage.getItem('impersonatorUserInfo') != undefined) {
                user = JSON.parse(localStorage.getItem('impersonatorUserInfo'));
                this._isShowImpersonate = false;
                this._isShowReturntoimpersonator = true;
            }
            else {
                this.membershipService.GetUsersToImpersonate(user.UserID).subscribe(function (res) {
                    if (res.Succeeded) {
                        if (res.UsersToImpersonateList.length > 0) {
                            _this.userNameList = res.UsersToImpersonateList;
                            _this._isShowImpersonate = true;
                        }
                        else {
                            _this._isShowImpersonate = false;
                        }
                    }
                    else {
                        _this._isShowImpersonate = false;
                    }
                });
            }
        }
        catch (err) {
            alert(err);
        }
    };
    AppComponent.prototype.subscribeToEvents = function () {
        var _this = this;
        // if connection exists it can call of method.  
        this._signalRService.connectionEstablished.subscribe(function () {
            _this.canSendMessage = true;
        });
        // finally our service method to call when response received from server event and transfer response to some variable to be shwon on the browser.  
        this._signalRService.messageReceived.subscribe(function (message) {
            _this.title = 'New Message';
            var _pushNotification = message.split('|*|');
            _this.description = _pushNotification[1];
            _this.Push.notificationroutepath = _pushNotification[2];
            _this.Push.show();
            // console.log('12' + message);
        });
    };
    AppComponent.prototype.openLink = function (module) {
        if (module == 'dealdetail') {
            if (window.location.href.indexOf("dealdetail/a") > -1) {
                this._pagePath = ['dealdetail', '00000000-0000-0000-0000-000000000000'];
            }
            else {
                this._pagePath = ['dealdetail/a', '00000000-0000-0000-0000-000000000000'];
            }
        }
        else if (module == 'financingdetail') {
            if (window.location.href.indexOf("financingdetail/a") > -1) {
                this._pagePath = ['financingdetail', '00000000-0000-0000-0000-000000000000'];
            }
            else {
                this._pagePath = ['financingdetail/a', '00000000-0000-0000-0000-000000000000'];
            }
        }
        else if (module == 'notificationsubscription') {
            this._pagePath = ['notificationsubscription'];
        }
        else if (module == 'taskdetail') {
            this._pagePath = ['taskdetail/a', '00000000-0000-0000-0000-000000000000'];
        }
        this._router.navigate(this._pagePath);
    };
    AppComponent.prototype.getAllDistinctScenario = function () {
        var _this = this;
        var _userData = JSON.parse(localStorage.getItem('user'));
        this._scenariodc.UserID = _userData.UserID;
        this.scenarioService.getAllScenarioDistinct(this._scenariodc).subscribe(function (res) {
            if (res.Succeeded) {
                _this._lstScenario = res.lstScenarioUserMap;
                localStorage.setItem('lstScenario', _this._lstScenario);
                var DefaultScenarioID = res.lstScenarioUserMap.filter(function (x) { return x.ScenarioName == "Default"; })[0].AnalysisID;
                localStorage.setItem('DefaultScenarioID', DefaultScenarioID);
                _this.getScenarioByUser();
            }
        });
    };
    AppComponent.prototype.showDialog = function () {
        var modalRole = document.getElementById('myModelimpersonate');
        modalRole.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    AppComponent.prototype.returnToImpersonator = function () {
        this._isShowImpersonate = true;
        this._isShowReturntoimpersonator = false;
        if (this._returnToImpersonator == null) {
            this._returnToImpersonator = true;
        }
        else
            this._returnToImpersonator = !this._returnToImpersonator;
    };
    AppComponent.prototype.SaveScenarioUserMap = function (_analysisID, ScenarioName) {
        var _this = this;
        //_analysisID = _analysisID.value;
        var scenarioobj = this._lstScenario.filter(function (x) { return x.AnalysisID == _analysisID; });
        this._selectedColor = scenarioobj[0].ScenarioColor;
        var _userData = JSON.parse(localStorage.getItem('user'));
        this._scenariodc.UserID = _userData.UserID;
        this._scenariodc.AnalysisID = _analysisID;
        this._lstScenario.ScenarioName = ScenarioName;
        this.scenarioService.InsertUpdateScenarioUserMap(this._scenariodc).subscribe(function (res) {
            if (res.Succeeded) {
                var msg = res.Message;
                localStorage.setItem('scenarioid', _analysisID);
                localStorage.setItem('ScenarioName', scenarioobj[0].ScenarioName);
                localStorage.setItem('CalculationModeID', scenarioobj[0].CalculationModeID);
                localStorage.setItem('CalculationModeText', scenarioobj[0].CalculationModeText);
                var returnUrl = _this._router.url;
                if (window.location.href.indexOf("notedetail/a") > -1) {
                    returnUrl = returnUrl.toString().replace('notedetail/a/', 'notedetail/');
                }
                else if (returnUrl.indexOf("notedetail/") > -1) {
                    returnUrl = returnUrl.toString().replace('notedetail/', 'notedetail/a/');
                }
                if (window.location.href.indexOf("a/CalculationManager") > -1) {
                    returnUrl = returnUrl.toString().replace('a/CalculationManager', 'CalculationManager');
                }
                else if (returnUrl.indexOf("CalculationManager") > -1) {
                    returnUrl = returnUrl.toString().replace('CalculationManager', 'a/CalculationManager');
                }
                if (window.location.href.indexOf("a/tags") > -1) {
                    returnUrl = returnUrl.toString().replace('a/tags', 'tags');
                }
                else if (returnUrl.indexOf("tags") > -1) {
                    returnUrl = returnUrl.toString().replace('tags', 'a/tags');
                }
                if (window.location.href.indexOf("a/periodicclose") > -1) {
                    returnUrl = returnUrl.toString().replace('a/periodicclose', 'periodicclose');
                }
                else if (returnUrl.indexOf("periodicclose") > -1) {
                    returnUrl = returnUrl.toString().replace('periodicclose', 'a/periodicclose');
                }
                _this._router.navigate([returnUrl]);
            }
        });
    };
    AppComponent.prototype.getScenarioByUser = function () {
        var _this = this;
        var _userData = JSON.parse(localStorage.getItem('user'));
        this._scenariodc.UserID = _userData.UserID;
        this.scenarioService.getScenarioUserMapByUserID(this._scenariodc).subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.ScenarioUserMap;
                _this._lstScenario.AnalysisID = data.AnalysisID;
                _this._lstScenario.ScenarioName = data.ScenarioName;
                _this._lstScenario.CalculationModeID = data.CalculationModeID;
                _this._lstScenario.CalculationModeText = data.CalculationModeText;
                _this._selectedColor = data.ScenarioColor;
                localStorage.setItem('scenarioid', _this._lstScenario.AnalysisID);
                localStorage.setItem('ScenarioName', _this._lstScenario.ScenarioName);
                localStorage.setItem('CalculationModeID', _this._lstScenario.CalculationModeID);
                localStorage.setItem('CalculationModeText', _this._lstScenario.CalculationModeText);
            }
        });
    };
    AppComponent.prototype.onclickeventnotifi = function (e) {
        e.stopPropagation();
    };
    AppComponent.prototype.openForm = function () {
        document.getElementById("myForm").style.display = "block";
    };
    AppComponent.prototype.closeForm = function () {
        document.getElementById("myForm").style.display = "none";
    };
    AppComponent.prototype.ImpersonateUserCount = function () {
        var _this = this;
        this.membershipService.ImpersonateUserCount().subscribe(function (res) {
            if (res.Succeeded) {
                var count = res.TotalCount;
                if (count > 0) {
                    _this._isShowImpersonate = true;
                    _this.GetUsersToImpersonate();
                }
            }
            else {
                _this._isShowImpersonate = false;
            }
        });
    };
    AppComponent.prototype.GetUserToken = function () {
        var impersonateuserdata = JSON.parse(localStorage.getItem('impersonatorUserInfo'));
        var userdata = window.localStorage.getItem("user");
        // to get hbot api from appsetting
        // this.HBOTApiKey = this.dataService.HbotApiKey;
        if (impersonateuserdata != null || impersonateuserdata != undefined) {
            this.usertoken = impersonateuserdata.Token;
            this.usertokenUI = impersonateuserdata.TokenUId;
            this.loginsession = impersonateuserdata.LoginSession;
        }
        else if (userdata != null || userdata != undefined) {
            var user = JSON.parse(userdata);
            this.usertoken = user.Token; //'acdb406c6e222afaa14e268ceebbe527'; //user.Token; 
            this.usertokenUI = user.TokenUId;
            this.loginsession = user.LoginSession;
        }
        // var urlSafe = this.HBOTApiKey + "?Token=" + this.usertoken + "&TokenUI=" + this.usertokenUI + "&LoginSession=" + this.loginsession;
        // this.HBOTApiPath = this.sanitizer.bypassSecurityTrustResourceUrl(urlSafe);
        this.GetSystemConfigKeys();
    };
    AppComponent.prototype.GetSystemConfigKeys = function () {
        this.membershipService.getsystemconfigkeys().subscribe(function (res) {
            if (res.Succeeded) {
                if (typeof res.SystemConfigKeysList != 'undefined' && res.SystemConfigKeysList.length > 0)
                    var _object = res.SystemConfigKeysList;
                for (var i = 0; i < _object.length; i++) {
                    if (_object[i].Key == 'dialogflowbaseurl') {
                        localStorage.setItem('dialogflowbaseurl', _object[i].Value);
                    }
                    if (_object[i].Key == 'API_Key') {
                        localStorage.setItem('API_Key', _object[i].Value);
                    }
                }
            }
        });
    };
    AppComponent.prototype.sendMessage = function (sender, e) {
        if (this.dataService._isAIEnable == "true") {
            this.isChatEnabled = true;
            var ac = sender;
            this.formValue = ac.text;
            ac.text = "";
            // calling for AI config key.
            var dialogflowbaseurl = localStorage.getItem('dialogflowbaseurl');
            if (dialogflowbaseurl == undefined || dialogflowbaseurl == null || dialogflowbaseurl == "") {
                this.GetSystemConfigKeys();
            }
            ac.hostElement.addEventListener('keydown', function (e) {
                if (e.keyCode == 13 && ac.text && ac.selectedIndex < 0) {
                    document.getElementById('autosearch').value = "0";
                }
                $('#showChatDiv').show();
            });
            var returnUrl = this._router.url;
            if (returnUrl.indexOf("/dashboard") > -1 || returnUrl == "/") {
                this._isShowchatpopup = false;
                $('#showChatDiv').hide();
            }
            else {
                this._isShowchatpopup = true;
                $('#showChatDiv').show();
                setTimeout(function () {
                    $('#showChatDiv').hide();
                }, 0.001);
            }
            if (this.formValue != "") {
                this.isAnsReceived = true;
                var formval = this.formValue;
                this.formValue = formval.charAt(0).toUpperCase() + formval.slice(1).replace(/\\/g, '').replace('@', '');
                this.converse(this.formValue);
            }
            this.formValue = "";
        }
    };
    // Sends and receives messages via DialogFlow
    AppComponent.prototype.converse = function (msg) {
        var _this = this;
        var usertokenUI = this.usertokenUI;
        var usertoken = this.usertoken;
        var _dialogflowbaseurl = localStorage.getItem('dialogflowbaseurl');
        var _API_Key = localStorage.getItem('API_Key');
        this.formValue = "";
        var userMessage = new BotMessage_1.Message(new BotMessage_1.MsgSpeech(msg, 'text', "null", "null"), 'user', this.create_UUID(), false);
        this.QuesAnsasked = msg;
        this.update(userMessage);
        this.intentName = '';
        this.formValue = "";
        var headers = new http_1.Headers();
        headers.append("auth_key", _API_Key); //this.dataService.API_Key
        var JSONdata = {
            "user_utterance": msg,
            "client_api_auth_token": usertokenUI + '|' + usertoken,
            "session_id": this.loginsession
        };
        //call dialogflowapi to get response
        try {
            return this.httpClient.post(_dialogflowbaseurl, JSONdata, { headers: headers })
                .map(function (res) { return (res.json()); })
                .subscribe(function (val) {
                if (val) {
                    var data = val;
                    var speech = {};
                    if (Object.keys(data).length > 0) {
                        speech = data;
                    }
                    else {
                        speech = { speech: speech, type: 'text' };
                    }
                    var botMessage = new BotMessage_1.Message(new BotMessage_1.MsgSpeech(speech.output, speech.type, speech.status, speech.intent_name), 'bot', _this.create_UUID(), false);
                    _this.botstatus = speech.status;
                    _this.intentName = speech.intent_name;
                    _this.update(botMessage);
                }
                else {
                    _this.loggingService.writeToLog("AI_Assistant ", "info", " Question :" + _this.QuesAnsasked + " : No response from dialog Flow API");
                }
            });
        }
        catch (err) {
            this.loggingService.writeToLog("AI_Assistant ", "info", " Question :" + this.QuesAnsasked + " : No response from dialog Flow API");
        }
    };
    AppComponent.prototype.update = function (msg) {
        var _this = this;
        var content = msg.content;
        var openurl = "";
        var firstmsg = "this is user token " + this.usertokenUI + '|' + this.usertoken + " do not change it.";
        if (msg.sentBy == 'bot') {
            if (msg.content.Type == 'url') {
                openurl = msg.content.Speech;
                msg.content.Speech = "";
                msg.content.Speech = "The requested page is being opened.";
            }
            if (msg.content.Type == 'download') {
                var downloadurl = msg.content.Speech;
                msg.content.Speech = "";
                msg.content.Speech = "Download request submitted.";
            }
            this.QuesAnsasked = msg.content.Speech;
            this.appbotarr = [];
            this.appbotarr.push({
                "userSpeech": this.userspeech,
                "Speech": msg.content.Speech,
                "sentBy": msg.sentBy,
                "status": (msg.content.status == "") ? null : msg.content.status,
                "intentName": msg.content.intentName
            });
            switch (content.Type) {
                case 'download':
                    this.DownloadFile(msg, downloadurl);
                    break;
                case 'table':
                    break;
                case 'url':
                    this._isnewpageRender = true;
                    this._isShowchatpopup = false;
                    var dealindex = openurl.indexOf("dealdetail/");
                    var noteindex = openurl.indexOf("notedetail/");
                    if (dealindex > 0) {
                        var _url = openurl.split("dealdetail/");
                        var dealid = _url[1];
                        if (window.location.href.indexOf("dealdetail/a") > -1) {
                            this._pagePath = ['dealdetail', dealid];
                        }
                        else {
                            this._pagePath = ['dealdetail/a', dealid];
                        }
                    }
                    if (noteindex > 0) {
                        var _url = openurl.split("notedetail/");
                        var noteid = _url[1];
                        if (window.location.href.indexOf("notedetail/a") > -1) {
                            this._pagePath = ['notedetail', noteid];
                        }
                        else {
                            this._pagePath = ['notedetail/a', noteid];
                        }
                    }
                    this._router.navigate(this._pagePath);
                    // }
                    //const url = this.dataService.Basepath;
                    // window.open(openurl.replace('http', url), "_self");
                    break;
                case 'text':
                    break;
            }
            if (this._isShowchatpopup == false) {
                this.chatservice.setMessage(this.appbotarr);
                localStorage.setItem('IsChatmsgBind', 'true');
                this.isAnsReceived = false;
            }
        }
        else {
            this.userspeech = msg.content.Speech;
        }
        if (this._isShowchatpopup == true) {
            $('#showChatDiv').show();
            //to set for new question start
            var parentid = localStorage.getItem("appParentId");
            var intentname = localStorage.getItem("appIntentName");
            if (parentid == null || parentid == undefined) {
                localStorage.setItem("appParentId", "null");
            }
            if (intentname == null || intentname == undefined) {
                localStorage.setItem("appIntentName", "null");
            }
            if (msg.sentBy == "bot") {
                if (this.appbotarr.length > 0) {
                    var botstatus = this.appbotarr[0].status;
                    var botintentname = this.appbotarr[0].intentName;
                    var founddiff = false;
                    if (parentid == "Continue" && intentname != this.appbotarr[0].intentName) {
                        localStorage.setItem("appParentId", 'End');
                        founddiff = true;
                    }
                    else {
                        founddiff = false;
                    }
                    if (founddiff == true) {
                        parentid = localStorage.getItem("appParentId");
                        intentname = localStorage.getItem('appIntentName');
                    }
                    //create div
                    var _appiDiv = document.createElement('div');
                    var _appdateDiv = document.createElement('span');
                    _appdateDiv.className = 'divtimeai';
                    if (parentid == "null" || parentid == "End") {
                        var _appinnerDiv = document.createElement('p');
                        _appiDiv.id = 'showChatDiv';
                        _appiDiv.className = 'innerpagequestion';
                        _appiDiv.innerHTML = '';
                        _appiDiv.innerHTML = this.appbotarr[0].userSpeech;
                        var displaytime = new Date().toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });
                        _appdateDiv.innerHTML = displaytime;
                        _appiDiv.appendChild(_appdateDiv);
                        //create innerdiv
                        _appinnerDiv.className = 'divAnswers';
                        _appinnerDiv.id = 'innerdiv';
                        _appinnerDiv.innerHTML = '';
                        _appinnerDiv.innerHTML = '<p>' + this.appbotarr[0].Speech + '</p>';
                        _appiDiv.appendChild(_appinnerDiv);
                    }
                    if (parentid == "Continue" && intentname == this.appbotarr[0].intentName) {
                        if (document.getElementById("innerdiv")) {
                            var firstresponse = '';
                            var firstresponse = '<p>' + document.getElementById("innerdiv").innerHTML.toString() + '</p>';
                            document.getElementById("innerdiv").innerHTML = '';
                            firstresponse = firstresponse + '<p>' + this.appbotarr[0].userSpeech + '</p>';
                            firstresponse = firstresponse + '<p>' + this.appbotarr[0].Speech + '</p>';
                            document.getElementById("innerdiv").innerHTML = '';
                            document.getElementById("innerdiv").innerHTML = firstresponse;
                        }
                    }
                    if (document.getElementsByClassName("chatDivactivity").length > 0) {
                        var item = document.getElementsByClassName("chatDivactivity")[0].appendChild(_appiDiv);
                        $("#showChatDiv").prepend(item);
                    }
                    this.isAnsReceived = false;
                    localStorage.setItem("appParentId", 'End');
                    localStorage.setItem("appIntentName", botintentname);
                    if (botstatus != "0") {
                        localStorage.setItem("appParentId", 'End');
                    }
                    else {
                        if (botstatus == "0") {
                            localStorage.setItem("appParentId", 'Continue');
                        }
                    }
                }
            }
        }
        //for chat logging 
        if (this.QuesAnsasked != undefined && msg.content.status != undefined) {
            var dtchatqueans = [];
            if (!(msg.sentBy.toString() == "null")) {
                dtchatqueans.push({
                    "Status": msg.content.status,
                    "Question": this.QuesAnsasked,
                    "IntentName": msg.content.intentName,
                    "SentBy": msg.sentBy,
                    "LoginSession": this.loginsession
                });
                msg.sentBy = null;
                this.QuesAnsasked = undefined;
                var chatlogres = this.chatservice.insertChatLogfromDashboard(dtchatqueans).subscribe(function (res) {
                    if (res) {
                    }
                });
            }
        }
        setTimeout(function () {
            _this.isAnsReceived = false;
        }, 5500);
    };
    AppComponent.prototype.errorHandler = function (error) {
        console.log(error);
    };
    AppComponent.prototype.DownloadFile = function (msg, downloadurl) {
        var TokenUId = this.usertokenUI;
        this.httpClient.get(downloadurl, { headers: TokenUId })
            .map(function (res) { return (res.json()); })
            .subscribe(function (res) {
            if (res.Listdt.length > 0) {
                var items = res.Listdt;
                var fileName = res.SingleResult;
                var replacer_1 = function (key, value) { return (value === null ? "" : value); };
                var header_1 = Object.keys(items[0]);
                var csv = items.map(function (row) {
                    return header_1
                        .map(function (fieldName) { return JSON.stringify(row[fieldName], replacer_1); })
                        .join(",");
                });
                csv.unshift(header_1.join(","));
                csv = csv.join("\r\n");
                var blob = new Blob(["\ufeff" + csv], {
                    type: "text/csv;charset=utf-8;",
                });
                var url = window.URL.createObjectURL(blob);
                // const fileName = this.getUrlVars(downloadurl, "DealID");
                if (navigator.msSaveOrOpenBlob) {
                    // navigator.msSaveBlob(blob, fileName + "-cashflow.csv");
                    navigator.msSaveBlob(blob, fileName + ".csv");
                }
                else {
                    var a = document.createElement("a");
                    a.href = url;
                    a.download = fileName + ".csv";
                    // a.download = fileName + "-cashflow.csv";
                    document.body.appendChild(a);
                    a.click();
                    document.body.removeChild(a);
                }
                window.URL.revokeObjectURL(url);
                msg.enableLoading = false;
            }
        }, function (error) {
            msg.enableLoading = false;
            console.log(error);
        });
    };
    AppComponent.prototype.ConvertToCSV = function (objArray) {
        var array = typeof objArray != "object" ? JSON.parse(objArray) : objArray;
        var str = "";
        for (var i = 0; i < array.length; i++) {
            var line = "";
            for (var index in array[i]) {
                if (line != "")
                    line += ",";
                line += array[i][index];
            }
            str += line + "\r\n";
        }
        return str;
    };
    AppComponent.prototype.IsJsonString = function (str) {
        try {
            JSON.parse(str);
        }
        catch (error) {
            return false;
        }
        return true;
    };
    AppComponent.prototype.create_UUID = function () {
        var dt = new Date().getTime();
        var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
            var r = (dt + Math.random() * 16) % 16 | 0;
            dt = Math.floor(dt / 16);
            return (c == 'x' ? r : (r & 0x3 | 0x8)).toString(16);
        });
        return uuid;
    };
    AppComponent.prototype.closeChatbox = function () {
        this._isShowchatpopup = false;
    };
    //close innerpage div when clicked outside
    //latestcode
    AppComponent.prototype.closeinnerChatbox = function (e) {
        if (document.getElementById('autosearch').contains(e.target)) {
            $('#showChatDiv').show();
        }
        else if (document.getElementById('showChatDiv').contains(e.target)) {
            $('#showChatDiv').show();
        }
        else {
            e.stopPropagation();
            $('#showChatDiv').hide();
        }
    };
    var _a, _b, _c, _d, _e, _f;
    __decorate([
        (0, core_1.ViewChild)('acAsync'),
        __metadata("design:type", typeof (_a = typeof wjNg2Input !== "undefined" && wjNg2Input.WjAutoComplete) === "function" ? _a : Object)
    ], AppComponent.prototype, "acAsync", void 0);
    __decorate([
        (0, core_1.ViewChild)('notification'),
        __metadata("design:type", notification_component_1.PushNotificationComponent)
    ], AppComponent.prototype, "Push", void 0);
    __decorate([
        (0, core_1.ViewChild)('style-5'),
        __metadata("design:type", HTMLDivElement)
    ], AppComponent.prototype, "notifidiv", void 0);
    AppComponent = __decorate([
        (0, core_1.Component)({
            //selector: 'my-app',
            host: { '(window:scroll)': 'track($style-5)' },
            templateUrl: "./app/app.component.html?v=" + $.getVersion(),
            providers: [searchService_1.SearchService, utilityService_1.UtilityService, notification_component_1.PushNotificationComponent, scenarioService_1.scenarioService, autologoutservice_1.AutoLogoutService, loggingservice_1.LoggingService]
        }),
        (0, core_1.Injectable)(),
        (0, core_1.Directive)({ selector: '[PushNotificationComponent]' }),
        __param(0, (0, core_1.Inject)(azureadauthservice_1.AzureADAuthService)),
        __metadata("design:paramtypes", [azureadauthservice_1.AzureADAuthService,
            membershipservice_1.MembershipService, typeof (_b = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _b : Object, typeof (_c = typeof router_1.ActivatedRoute !== "undefined" && router_1.ActivatedRoute) === "function" ? _c : Object, searchService_1.SearchService,
            utilityService_1.UtilityService, typeof (_d = typeof common_1.Location !== "undefined" && common_1.Location) === "function" ? _d : Object, dataService_1.DataService,
            signalRService_1.SignalRService,
            pushnotificationservice_1.PushNotificationService,
            scenarioService_1.scenarioService, typeof (_e = typeof platform_browser_1.DomSanitizer !== "undefined" && platform_browser_1.DomSanitizer) === "function" ? _e : Object, autologoutservice_1.AutoLogoutService, typeof (_f = typeof http_1.Http !== "undefined" && http_1.Http) === "function" ? _f : Object, loggingservice_1.LoggingService,
            chatService_1.ChatService])
    ], AppComponent);
    return AppComponent;
}());
exports.AppComponent = AppComponent;
//# sourceMappingURL=app.component.js.map