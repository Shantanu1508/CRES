
import { Location } from '@angular/common';
import { Component, Directive, Inject, Injectable, ViewChild, HostListener } from '@angular/core';
import { Http, Headers } from '@angular/http';
import { DomSanitizer } from '@angular/platform-browser';
import { ActivatedRoute, Router } from '@angular/router';
import * as wjNg2Input from 'wijmo/wijmo.angular2.input';
import { Message, MsgSpeech } from './core/domain/BotMessage';
import { Scenario } from "./core/domain/Scenario";
import { Search } from "./core/domain/search";
import { UserNotification } from './core/domain/UserNotification';
import { AutoLogoutService } from './core/services/autologoutservice';
import { ChatService } from './core/services/chatService';
import { DataService } from './core/services/dataService';
import { MembershipService } from './core/services/membershipservice';
import { PushNotificationService } from './core/services/pushnotificationservice';
//import { CalculationManagerComponent } from './components/calculationmanager.component';
import { scenarioService } from './core/services/scenarioService';
import { SearchService } from './core/services/searchService';
import { UtilityService } from './core/services/utilityService';
import { AzureADAuthService } from './ngauth/authenticators/azureadauthservice';
import { PushNotificationComponent } from './Notification/notification.component';
import { SignalRService } from './Notification/signalRService';
import { LoggingService } from './core/services/loggingservice';
import { User } from './core/domain/user';
declare var $: any;

@Component({
    //selector: 'my-app',
    host: { '(window:scroll)': 'track($style-5)' },
    templateUrl: "./app/app.component.html?v=" + $.getVersion(),
    providers: [SearchService, UtilityService, PushNotificationComponent, scenarioService, AutoLogoutService, LoggingService]
})
@Injectable()
@Directive({ selector: '[PushNotificationComponent]' })

export class AppComponent {
    private _searchObj: Search;
    private _searchData: Search;
    private _result: any;
    private _temppagePath: any;
    private _pagePath: any;
    private _isSearchDataFetching: boolean = false;
    private _dvEmptySearchMsg: boolean = false;

    public _pageSizeSearch: number = 10;
    public _pageIndexSearch: number = 1;
    public _totalCountSearch: number = 0;
    public _totalCount: number = 0;
    private _isShowDealMenu: boolean = true;
    private _isShowNoteMenu: boolean = true;
    private _callmenupermisisoncode: boolean = false;
    private _isShowPropertyMenu: boolean = true;
    private _isShowFinancingMenu: boolean = true;
    private _isShowCMMenu: boolean = true;
    private _isShowIndexesMenu: boolean = true;
    private _isShowreportMenu: boolean = true;
    private _isShowUnderwritingMenu: boolean = true;
    private _isShowAddNewTopMenu: boolean = true;
    private _isShowAddNewTopMenuUserProfile: boolean = true;
    private _isShowAddNewTopMenuAlert: boolean = true;
    public _environmentCSS: string;
    public _TotalNotificationCount: string;
    public _Notifications: string;
    public _isNotificationsshow: boolean = false;
    public _Notificationscount: number;
    public _NotificationscountText: any;
    public canSendMessage: boolean;
    public allMessages: any;
    public notificationmessage: string;
    public currentnotificationcount: number = 0;
    public unotification = new Array<UserNotification>();
    public _pageIndex: number = 1;
    public _isGetMenuPermission: boolean = false;
    private _isShowRuleEngineMenu: boolean = true;
    private _isShowWorkFlowMenu: boolean = true;
    private _scenariodc: Scenario;
    //private _scenarioUserMap: ScenarioUserMap;
    private _lstScenario: any;
    private _isShowDynamicPortfolio: boolean = true;

    private _isShowPeriodicCloseMenu: boolean = true;
    private _selectedColor: string;
    private _isShowScenario: boolean = true;
    private _isShowFeeConfiguration: boolean = true;
    private _isShowTransactionReconciliation: boolean = true;

    private userNameList: any;
    public _isShowImpersonate: boolean = false;
    public _isShowReturntoimpersonator: boolean = false;
    public _returnToImpersonator: boolean = null;

    private _isShowTagMasterMenu: boolean = true;
    private _isShowChatBox: boolean = false;
    private usertoken: any;
    private usertokenUI: any;
    private loginsession: any;
    private HBOTApiKey: any;
    private HBOTApiPath: any;
    public _issessionstart: boolean = false;
    public _isuserinactive: boolean = false;
    private _user: User;
    @ViewChild('acAsync') acAsync: wjNg2Input.WjAutoComplete;
    @ViewChild('notification') Push: PushNotificationComponent;
    title: string = 'CRES';
    description: string = 'New deal';
    @ViewChild('style-5') notifidiv: HTMLDivElement;
    public formValue: string = "";
    public QuesAnsasked: any;

    _isrefreshsession: boolean = false;
    public chatmsg: any;
    public timeoutID: any;
    public _issearch: boolean = false;
    public _index: number = 0;
    public botstatus: string = '';
    public intentName: string;
    public _isnewpageRender: boolean = false;
    public isPageRender: boolean = false;
    public _issearchbox: boolean = false;
    public _isShowchatpopup: boolean = false;
    public appbotarr: any;
    public isChatEnabled: boolean = false;
    public userspeech = '';
    public isAnsReceived: boolean = false;
    public IPAddress: any;
    private _ShowmessagedivMsgWar: any;
    private _ShowmessagedivWar: boolean = false;
    private _Showmessagediv: boolean = false;
    private _ShowSuccessmessagediv: boolean = false;
    private _ShowSuccessmessage: any;

    constructor(@Inject(AzureADAuthService) private _authService: AzureADAuthService,
        public membershipService: MembershipService,
        private _router: Router,
        private activatedRoute: ActivatedRoute,
        public searchService: SearchService,
        public utilityService: UtilityService,
        public location: Location,
        public dataService: DataService,
        public _signalRService: SignalRService,
        public pushNotificationService: PushNotificationService,
        public scenarioService: scenarioService,
        public sanitizer: DomSanitizer,
        public autoLogout: AutoLogoutService,
        public httpClient: Http,
        public loggingService: LoggingService,
        public chatservice: ChatService
    ) {
        this._scenariodc = new Scenario('');
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


    HideMenu(): boolean {
        var ret_val = false;
        var rolename = window.localStorage.getItem("rolename");
        if (rolename != null) {
            if (rolename.toString() == "Super Admin") {
                ret_val = true;
            }
        }
        return ret_val;
    }

    MenuforViewer(): boolean {
        var ret_val = false;
        var rolename = window.localStorage.getItem("rolename");
        if (rolename != null) {
            if (rolename.toString() == "Viewer") {
                ret_val = true;
            }
        }
        return ret_val;
    }

    AddUpdateIPAddressByUserID(): void {
        try {
            this.membershipService.AddUpdateIPAddressByUserID(this._user).subscribe(res => {
                if (res.Succeeded) {
                    localStorage.setItem('user', JSON.stringify(this._user));
                    this._ShowSuccessmessage = "Your current IP address has been added/updated successfully.";
                    this._ShowSuccessmessagediv = true;
                    setTimeout(function () {
                        this._ShowSuccessmessagediv = false;
                    }.bind(this), 5000);
                }
                else {
                    //  alert('failed!')
                }
            });
        } catch (err) {
        }
    }


    SaveIPAddress() {
        this.IPAddress = JSON.parse(localStorage.getItem('userIP'));
        this._user = JSON.parse(localStorage.getItem('user'));
        this._user.IpAddress = this.IPAddress;
        if (this._user.IpAddress != undefined && this._user.IpAddress != "") {
            this.membershipService.CheckDuplicateIPAddress(this._user).subscribe(res => {
                if (res.Succeeded) {
                    if (res.Message != "Duplicate") {
                        this.AddUpdateIPAddressByUserID();
                    }
                    else {
                        this._ShowmessagedivWar = true;
                        this._ShowmessagedivMsgWar = "This IP already exits, please use different IP."
                        setTimeout(() => {
                            this._ShowmessagedivWar = false;
                            this._ShowmessagedivMsgWar = "";
                        }, 3000);
                    }
                }
                else {
                    this._router.navigate(['login']);
                }
            });

        }
    }

    GetAllUserNotification(): void {
        this._isNotificationsshow = true;
        var d = new Date();
        this.notificationmessage = "";
        var datestring = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate() + " " +
            d.getHours() + ":" + d.getMinutes();
        this.unotification = new Array<UserNotification>();
        //    alert('_pageIndex' + this._pageIndex);   
        //  if ($("#notificationscount").text() != "") {
        //this.searchService.getAllUserNotification(datestring.toString()).subscribe(res => {
        //    if (res.Succeeded) {
        this.pushNotificationService.getallnotification(datestring.toString(), this._pageIndex, 10).subscribe(res => {
            if (res.Succeeded == true) {
                this.unotification = res.lstUserNotification;
                this.currentnotificationcount = this.unotification.length;
                if (this.currentnotificationcount > 0) {
                    for (var i = 0; i < this.unotification.length; i++) {
                        if (window.location.href.indexOf("dealdetail/a") > -1) {
                            this.unotification[i].Msg = this.unotification[i].Msg.toString().replace('dealdetail/a/', 'dealdetail/');
                        }
                        else if (this.unotification[i].Msg.indexOf("dealdetail/") > -1) {
                            this.unotification[i].Msg = this.unotification[i].Msg.toString().replace('dealdetail/', 'dealdetail/a/');
                        }
                        if (window.location.href.indexOf("notedetail/a") > -1) {
                            this.unotification[i].Msg = this.unotification[i].Msg.toString().replace('notedetail/a/', 'notedetail/');

                        }
                        else if (this.unotification[i].Msg.indexOf("notedetail/") > -1) {
                            this.unotification[i].Msg = this.unotification[i].Msg.toString().replace('notedetail/', 'notedetail/a/');

                        }
                    }

                }

                else {
                    this.unotification = new Array<UserNotification>();
                    this._isNotificationsshow = false;
                    this.notificationmessage = "No new notifications found";
                }

                if (this._Notificationscount == 0) {
                    this._Notificationscount = null;
                    this._NotificationscountText = "";
                    this._isNotificationsshow = false;
                }
                this.ClearNotificationcount();
                this._isNotificationsshow = false;
            }
            else {
                this._isNotificationsshow = false;
            }
        });
        error => console.error('Error: ' + error)
    }

    ClearNotificationcount(): void {
        if (this._Notificationscount != 0) {
            $("#notificationscount").text("");
            this.pushNotificationService.ClearUserNotificationCount().subscribe(res => {
                if (res.Succeeded) {
                    this._Notificationscount = 0;
                    this._NotificationscountText = "";
                    this._isNotificationsshow = false;
                }
            });
        }
    }

    ClearAllNotification(): void {

        this.pushNotificationService.ClearAllUserNotification().subscribe(res => {
            if (res.Succeeded) {
                $("#notificationscount").text("");
                this._Notificationscount = 0;
                this._NotificationscountText = "";
                this.unotification = new Array<UserNotification>();
                this.notificationmessage = "No new notifications.";
                //  this._Notificationscount--;
                //alert(JSON.stringify(this._Notifications));
            }

        });
    }

    CloseNotification(id: string, e: any): void {
        e.stopPropagation();
        this.pushNotificationService.ClearUserNotification(id).subscribe(res => {
            if (res.Succeeded == true) {
                $("#" + id).hide();
            }
        });

    }

    GetUserNotificationCount(): void {
        //   e.preventDefault();       
        this.pushNotificationService.GetUserNotificationCount().subscribe(res => {
            if (res.Succeeded) {
                this._Notificationscount = res.exceptioncount;
                this._totalCount = res.TotalCount;
                this._NotificationscountText = res.exceptioncount;
                if (this._Notificationscount == 0) {
                    $("#notificationscount").text("");
                }
                else {

                    if (this._Notificationscount > 99) {
                        $("#notificationscount").text("99+");
                    }
                    else {
                        $("#notificationscount").text(this._NotificationscountText);
                    }

                }
            }
        });
    }

    getUserName(): string {
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
    }

    getemailId(): string {
        var useremail = this._authService.getemail();
        localStorage.setItem('useremail', useremail);

        this._isSearchDataFetching = false;
        return useremail;
    }

    isUserLoggedIn(): boolean {
        this.getemailId();
        return this.membershipService.isUserAuthenticated();
    }


    logout(state = "/"): void {
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
                .subscribe(res => {
                    let link = ['/login'];
                    this._router.navigate(link);
                    this._callmenupermisisoncode = false;


                },
                    error => console.error('Errro' + error),
                    () => { });
        }

        //update for reload left menu after new login
        this._isGetMenuPermission = false;
    }


    // select first item if user presses enter and nothing is selected
    public initialized(sender: wjNg2Input.WjAutoComplete, e) {
        var ac = sender;
        var totalCount = this._totalCountSearch;
        var _isAIEnable = this.dataService._isAIEnable;
        ac.hostElement.addEventListener('keydown', function (e) {
            if (e.keyCode == 13 && ac.text && ac.selectedIndex < 0) {
                if (_isAIEnable == "false") {
                    (<HTMLInputElement>document.getElementById('hdnSearchCount')).value = "1";
                    var inputValue = (<HTMLInputElement>document.getElementById('hdnSearchCount')).value;
                    ac.selectedIndex = 0;
                }
            }
        });
    }

    // handle dropdown clicks: this method gets invoked when the dropdown's itemClicked event fires
    checkTextboxChanged(sender: wjNg2Input.WjAutoComplete, e) {
        var ac = sender;
        var x = e.which || e.keyCode;
        var _isboxclicked = false;
        var inputValue = (<HTMLInputElement>document.getElementById('hdnSearchCount')).value;
        if (inputValue == '1') {
            this._isSearchDataFetching = true;
            (<HTMLInputElement>document.getElementById('hdnSearchCount')).value = "0";
            if (this.dataService._isAIEnable == "false") {
                ac.selectedIndex = 0;
            }
            setTimeout(function () {
                this.checkDroppedDownChanged(sender, e);
            }.bind(this), 2000);
        }
    }

    // to assign display name to innerhtml
    formatautocompleteListbox(sender: wjNg2Input.WjAutoComplete, e) {
        var data = e.data;
        e.item.innerHTML = data.DisplayName;
    }
    public _existsdealnamefound = false;
    // handle dropdown clicks: this method gets invoked when the dropdown's itemClicked event fires
    public checkDroppedDownChanged(sender: wjNg2Input.WjAutoComplete, e) {
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
            this.searchService.UpdateRankInSearchItem(this._searchObj).subscribe(res => {
                if (res.Succeeded) {

                }
                else {

                }
            });
            error => console.error('Error: ' + error)
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
    }

    defaultSearch(ac, obj) {
        // if (this._issearch == false && this.botstatus != "0") {
        this._issearchbox = true;
        this._isnewpageRender = true;

        if (obj.ValueType == 283) {
            this._temppagePath = ['dealdetail'];
            if (window.location.href.indexOf("dealdetail/a") > -1) {
                this._pagePath = ['dealdetail', ac.selectedValue]
            }
            else {
                this._pagePath = ['dealdetail/a', ac.selectedValue]
            }
        }
        else if (obj.ValueType == 182) {
            this._temppagePath = ['notedetail'];

            if (window.location.href.indexOf("notedetail/a") > -1) {
                this._pagePath = ['notedetail', ac.selectedValue]
            }
            else {
                this._pagePath = ['notedetail/a', ac.selectedValue]
            }
        }
    }

    private _cache = {};
    getAutosuggestData = this.getAutosuggestDataFunc.bind(this);
    getAutosuggestDataFunc(query, max, callback) {
        this._isSearchDataFetching = true;
        this._issearch = false;
        var _foundMatch: string = '';
        this.formValue = '';
        var _newformValue: any;
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
            var self = this,
                result = self._cache[query];
            if (result) {
                this._dvEmptySearchMsg = false;
                this._isSearchDataFetching = false;
                callback(result);
                return;
            }

            // not in cache, get from server
            var params = { query: query, max: max };
            this._searchObj = new Search(query);
            // try getting the result from the cache
            var self = this,
                result = self._cache[query];
            if (result) {
                this._dvEmptySearchMsg = false;
                this._isSearchDataFetching = false;
                callback(result);
                return;
            }

            // not in cache, get from server
            var params = { query: query, max: max };
            this._searchObj = new Search(query);

            this.searchService.getAutosuggestSearchData(this._searchObj, this._pageIndexSearch, this._pageSizeSearch).subscribe(res => {
                if (res.Succeeded) {
                    var data: any = res.lstSearch;
                    //this._totalCountSearch = 1; //res.TotalCount;

                    this._result = data;
                    this._totalCountSearch = this._result.length;
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
                    let items = [];
                    for (var i = 0; i < this._result.length; i++) {
                        var c = this._result[i];
                        var _valueType;

                        if (c.ValueType == 283) { //Deal
                            _valueType = '<img src="../images/letter-d-blue-icon.png" /> ';
                        }
                        else if (c.ValueType == 182) { //Note
                            _valueType = '<img src="../images/letter-n-blue-icon.png" /> ';
                        }
                        c.DisplayName = _valueType + c.Valuekey;
                    }
                    callback(this._result);

                }

                else {
                    this.utilityService.navigateToSignIn();
                }
            });
            error => console.error('Error: ' + error)
        }
    }

    GetMenuPermission(): void {
        try {

            this.membershipService.getuserpermision().subscribe(res => {
                if (res.Succeeded) {
                    if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                        var _object = res.UserPermissionList;
                        for (var i = 0; i < _object.length; i++) {
                            if (_object[i].ChildModule == 'Deal') {
                                this._isShowDealMenu = true;
                            }
                            if (_object[i].ChildModule == 'Reports') {
                                this._isShowreportMenu = true;
                            }
                            if (_object[i].ChildModule == 'Notes') {
                                this._isShowNoteMenu = true;
                            }
                            if (_object[i].ChildModule == 'Financing') {
                                this._isShowFinancingMenu = true;
                            }
                            if (_object[i].ChildModule == 'CalculationManager') {
                                this._isShowCMMenu = true;
                            }
                            if (_object[i].ChildModule == 'Indexes') {
                                this._isShowIndexesMenu = true;
                            }
                            if (_object[i].ChildModule == 'Properties') {
                                this._isShowPropertyMenu = true;
                            }
                            if (_object[i].ChildModule == 'Integration') {
                                this._isShowUnderwritingMenu = true;
                            }

                            if (_object[i].ChildModule == 'AddNew') {
                                this._isShowAddNewTopMenu = true;
                            }
                            if (_object[i].ChildModule == 'UserProfile') {
                                this._isShowAddNewTopMenuUserProfile = true;
                            }
                            if (_object[i].ChildModule == 'Alert') {
                                this._isShowAddNewTopMenuAlert = true;
                            }
                            if (_object[i].ChildModule == 'RuleEngine') {
                                this._isShowRuleEngineMenu = true;
                            }
                            if (_object[i].ChildModule.toLowerCase() == 'workflow') {
                                this._isShowWorkFlowMenu = true;
                            }
                            if (_object[i].ChildModule == 'Dynamic_Portfolio') {
                                this._isShowDynamicPortfolio = true;
                            }
                            if (_object[i].ChildModule == 'ScenarioManagementPage') {
                                this._isShowScenario = true;
                            }
                            if (_object[i].ChildModule == 'Fee_Configuration') {
                                this._isShowFeeConfiguration = true;
                            }
                            if (_object[i].ChildModule == 'Transaction_Reconciliation') {
                                this._isShowTransactionReconciliation = true;
                            }
                            if (_object[i].ChildModule == 'Periodic_Close') {
                                this._isShowPeriodicCloseMenu = true;
                            }
                            if (_object[i].ChildModule == 'Tag_Master') {
                                this._isShowTagMasterMenu = true;
                            }
                            //if (_object[i].ChildModule == 'btnChatBox') {
                            //    this._isShowChatBox = true;
                            //    this.createHBOTApi();
                            //}
                        }
                    }

                    this.GetUserToken();
                    this.getAllDistinctScenario();
                }
            });
        } catch (err) {
            alert(err)
        }
    }



    GetUsersToImpersonate(): void {
        try {
            var user = JSON.parse(localStorage.getItem('user'));
            if (localStorage.getItem('impersonatorUserInfo') != null && localStorage.getItem('impersonatorUserInfo') != undefined) {
                user = JSON.parse(localStorage.getItem('impersonatorUserInfo'));
                this._isShowImpersonate = false;
                this._isShowReturntoimpersonator = true;
            }
            else {
                this.membershipService.GetUsersToImpersonate(user.UserID).subscribe(res => {
                    if (res.Succeeded) {
                        if (res.UsersToImpersonateList.length > 0) {
                            this.userNameList = res.UsersToImpersonateList;
                            this._isShowImpersonate = true;

                        } else {
                            this._isShowImpersonate = false;
                        }

                    } else {
                        this._isShowImpersonate = false;
                    }
                });
            }

        } catch (err) {
            alert(err);
        }
    }

    private subscribeToEvents(): void {

        // if connection exists it can call of method.  
        this._signalRService.connectionEstablished.subscribe(() => {
            this.canSendMessage = true;
        });

        // finally our service method to call when response received from server event and transfer response to some variable to be shwon on the browser.  
        this._signalRService.messageReceived.subscribe((message: any) => {
            this.title = 'New Message';
            var _pushNotification = message.split('|*|');
            this.description = _pushNotification[1];
            this.Push.notificationroutepath = _pushNotification[2];
            this.Push.show();

            // console.log('12' + message);
        });

    }

    openLink(module): void {
        if (module == 'dealdetail') {
            if (window.location.href.indexOf("dealdetail/a") > -1) {
                this._pagePath = ['dealdetail', '00000000-0000-0000-0000-000000000000']
            }
            else {
                this._pagePath = ['dealdetail/a', '00000000-0000-0000-0000-000000000000']
            }

        }
        else if (module == 'financingdetail') {
            if (window.location.href.indexOf("financingdetail/a") > -1) {
                this._pagePath = ['financingdetail', '00000000-0000-0000-0000-000000000000']
            }
            else {
                this._pagePath = ['financingdetail/a', '00000000-0000-0000-0000-000000000000']
            }
        }

        else if (module == 'notificationsubscription') {
            this._pagePath = ['notificationsubscription']

        }

        else if (module == 'taskdetail') {
            this._pagePath = ['taskdetail/a', '00000000-0000-0000-0000-000000000000']

        }

        this._router.navigate(this._pagePath)
    }

    getAllDistinctScenario(): void {
        var _userData = JSON.parse(localStorage.getItem('user'));
        this._scenariodc.UserID = _userData.UserID;
        this.scenarioService.getAllScenarioDistinct(this._scenariodc).subscribe(res => {
            if (res.Succeeded) {
                this._lstScenario = res.lstScenarioUserMap;

                localStorage.setItem('lstScenario', this._lstScenario);
                var DefaultScenarioID = res.lstScenarioUserMap.filter(x => x.ScenarioName == "Default")[0].AnalysisID;
                localStorage.setItem('DefaultScenarioID', DefaultScenarioID);
                this.getScenarioByUser();
            }
        });
    }

    showDialog(): void {
        var modalRole = document.getElementById('myModelimpersonate');
        modalRole.style.display = "block";
        $.getScript("/js/jsDrag.js");
    }

    returnToImpersonator() {
        this._isShowImpersonate = true;
        this._isShowReturntoimpersonator = false;

        if (this._returnToImpersonator == null) {
            this._returnToImpersonator = true;
        }
        else
            this._returnToImpersonator = !this._returnToImpersonator;
    }

    SaveScenarioUserMap(_analysisID, ScenarioName): void {
        //_analysisID = _analysisID.value;
        var scenarioobj = this._lstScenario.filter(x => x.AnalysisID == _analysisID);
        this._selectedColor = scenarioobj[0].ScenarioColor;

        var _userData = JSON.parse(localStorage.getItem('user'));
        this._scenariodc.UserID = _userData.UserID;
        this._scenariodc.AnalysisID = _analysisID;
        this._lstScenario.ScenarioName = ScenarioName;
        this.scenarioService.InsertUpdateScenarioUserMap(this._scenariodc).subscribe(res => {
            if (res.Succeeded) {
                var msg = res.Message;

                localStorage.setItem('scenarioid', _analysisID);
                localStorage.setItem('ScenarioName', scenarioobj[0].ScenarioName);

                localStorage.setItem('CalculationModeID', scenarioobj[0].CalculationModeID);
                localStorage.setItem('CalculationModeText', scenarioobj[0].CalculationModeText);
                var returnUrl = this._router.url;

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

                this._router.navigate([returnUrl]);
            }
        });
    }

    getScenarioByUser(): void {
        var _userData = JSON.parse(localStorage.getItem('user'));
        this._scenariodc.UserID = _userData.UserID;
        this.scenarioService.getScenarioUserMapByUserID(this._scenariodc).subscribe(res => {
            if (res.Succeeded) {
                var data = res.ScenarioUserMap;
                this._lstScenario.AnalysisID = data.AnalysisID;
                this._lstScenario.ScenarioName = data.ScenarioName;
                this._lstScenario.CalculationModeID = data.CalculationModeID;
                this._lstScenario.CalculationModeText = data.CalculationModeText;
                this._selectedColor = data.ScenarioColor;

                localStorage.setItem('scenarioid', this._lstScenario.AnalysisID);
                localStorage.setItem('ScenarioName', this._lstScenario.ScenarioName);
                localStorage.setItem('CalculationModeID', this._lstScenario.CalculationModeID);
                localStorage.setItem('CalculationModeText', this._lstScenario.CalculationModeText);
            }
        });
    }

    onclickeventnotifi(e: any): void {
        e.stopPropagation();
    }


    openForm() {
        document.getElementById("myForm").style.display = "block";
    }

    closeForm() {
        document.getElementById("myForm").style.display = "none";
    }
    ImpersonateUserCount() {
        this.membershipService.ImpersonateUserCount().subscribe(res => {
            if (res.Succeeded) {
                var count = res.TotalCount;
                if (count > 0) {
                    this._isShowImpersonate = true;
                    this.GetUsersToImpersonate();
                }

            }
            else {
                this._isShowImpersonate = false;
            }
        });
    }

    GetUserToken() {
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
            this.usertoken = user.Token;  //'acdb406c6e222afaa14e268ceebbe527'; //user.Token; 
            this.usertokenUI = user.TokenUId;
            this.loginsession = user.LoginSession;
        }
        // var urlSafe = this.HBOTApiKey + "?Token=" + this.usertoken + "&TokenUI=" + this.usertokenUI + "&LoginSession=" + this.loginsession;
        // this.HBOTApiPath = this.sanitizer.bypassSecurityTrustResourceUrl(urlSafe);

        this.GetSystemConfigKeys();
    }

    GetSystemConfigKeys() {
        this.membershipService.getsystemconfigkeys().subscribe(res => {
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
    }

    sendMessage(sender: wjNg2Input.WjAutoComplete, e) {
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
                    (<HTMLInputElement>document.getElementById('autosearch')).value = "0";
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
                setTimeout(() => {
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
    }


    // Sends and receives messages via DialogFlow
    converse(msg) {
        var usertokenUI = this.usertokenUI;
        var usertoken = this.usertoken;
        var _dialogflowbaseurl = localStorage.getItem('dialogflowbaseurl');
        var _API_Key = localStorage.getItem('API_Key');
        this.formValue = "";
        const userMessage = new Message(
            new MsgSpeech(msg, 'text', "null", "null"),
            'user',
            this.create_UUID(),
            false
        );
        this.QuesAnsasked = msg;
        this.update(userMessage);
        this.intentName = '';
        this.formValue = "";
        var headers = new Headers();
        headers.append("auth_key", _API_Key); //this.dataService.API_Key
        var JSONdata = {
            "user_utterance": msg,
            "client_api_auth_token": usertokenUI + '|' + usertoken,
            "session_id": this.loginsession
        };
        //call dialogflowapi to get response
        try {

            return this.httpClient.post(_dialogflowbaseurl, JSONdata, { headers: headers })
                .map((res) => (
                    res.json()))
                .subscribe(val => {
                    if (val) {
                        var data = val;
                        let speech: any = {};
                        if (Object.keys(data).length > 0) {
                            speech = data;
                        } else {
                            speech = { speech: speech, type: 'text' };
                        }
                        const botMessage = new Message(
                            new MsgSpeech(speech.output, speech.type, speech.status, speech.intent_name),
                            'bot',
                            this.create_UUID(),
                            false
                        );
                        this.botstatus = speech.status;
                        this.intentName = speech.intent_name;
                        this.update(botMessage);
                    }
                    else {
                        this.loggingService.writeToLog("AI_Assistant ", "info", " Question :" + this.QuesAnsasked + " : No response from dialog Flow API");
                    }
                });
        }
        catch (err) {
            this.loggingService.writeToLog("AI_Assistant ", "info", " Question :" + this.QuesAnsasked + " : No response from dialog Flow API");
        }
    }

    update(msg: Message) {
        let content: any = msg.content;
        var openurl: any = "";
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
        } else {
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
                    var founddiff: boolean = false;

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
                const chatlogres = this.chatservice.insertChatLogfromDashboard(dtchatqueans).subscribe(res => {
                    if (res) {

                    }
                });
            }
        }
        setTimeout(() => {
            this.isAnsReceived = false;
        }, 5500);
    }

    errorHandler(error: any): void {
        console.log(error);
    }

    DownloadFile(msg: Message, downloadurl: string) {
        var TokenUId = this.usertokenUI;
        this.httpClient.get(downloadurl, { headers: TokenUId })
            .map((res) => (
                res.json()))
            .subscribe(
                (res) => {
                    if (res.Listdt.length > 0) {
                        var items = res.Listdt;
                        var fileName = res.SingleResult;
                        const replacer = (key, value) => (value === null ? "" : value);
                        const header = Object.keys(items[0]);
                        let csv = items.map((row) =>
                            header
                                .map((fieldName) => JSON.stringify(row[fieldName], replacer))
                                .join(",")
                        );
                        csv.unshift(header.join(","));
                        csv = csv.join("\r\n");

                        const blob = new Blob(["\ufeff" + csv], {
                            type: "text/csv;charset=utf-8;",
                        });
                        const url = window.URL.createObjectURL(blob);
                        // const fileName = this.getUrlVars(downloadurl, "DealID");

                        if (navigator.msSaveOrOpenBlob) {
                            // navigator.msSaveBlob(blob, fileName + "-cashflow.csv");
                            navigator.msSaveBlob(blob, fileName + ".csv");
                        } else {
                            const a = document.createElement("a");
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
                },
                (error) => {
                    msg.enableLoading = false;
                    console.log(error);
                }
            );
    }

    ConvertToCSV(objArray) {
        var array = typeof objArray != "object" ? JSON.parse(objArray) : objArray;
        var str = "";

        for (var i = 0; i < array.length; i++) {
            var line = "";
            for (var index in array[i]) {
                if (line != "") line += ",";

                line += array[i][index];
            }

            str += line + "\r\n";
        }

        return str;
    }

    IsJsonString(str: string) {
        try {
            JSON.parse(str);
        } catch (error) {
            return false;
        }
        return true;
    }

    create_UUID() {
        var dt = new Date().getTime();
        var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
            var r = (dt + Math.random() * 16) % 16 | 0;
            dt = Math.floor(dt / 16);
            return (c == 'x' ? r : (r & 0x3 | 0x8)).toString(16);
        });
        return uuid;
    }

    closeChatbox() {
        this._isShowchatpopup = false;
    }

    //close innerpage div when clicked outside
    //latestcode
    closeinnerChatbox(e) {
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
    }
}