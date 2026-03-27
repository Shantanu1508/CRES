import { Location } from '@angular/common';
import { Component, Directive, Inject, Injectable, ViewChild, HostListener, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { DomSanitizer } from '@angular/platform-browser';
import { ActivatedRoute, Router } from '@angular/router';
import * as wjNg2Input from '@grapecity/wijmo.angular2.input';
import { Message, MsgSpeech } from './core/domain/botMessage.model';
import { Scenario } from "./core/domain/scenario.model";
import { Search } from "./core/domain/search.model";
import { UserNotification } from './core/domain/userNotification.model';
import { AutoLogoutService } from './core/services/autoLogout.service';
import { ChatService } from './core/services/chat.service';
import { DataService } from './core/services/data.service';
import { MembershipService } from './core/services/membership.service';
import { PushNotificationService } from './core/services/pushNotification.service';
import { scenarioService } from './core/services/scenario.service';
import { SearchService } from './core/services/search.service';
import { UtilityService } from './core/services/utility.service';
import { AzureADAuthService } from './ngAuth/authenticators/azureADAuth.service';
import { AzureADAuthServiceInternal } from './ngAuth/authenticators/azureADAuthInternal.service';

import { PushNotificationComponent } from './Notification/notification.component';
import { SignalRService } from './Notification/signalR.service';
import { LoggingService } from './core/services/logging.service';
import appsettings from '../../../appsettings.json';
//import { _isAIEnable, _environmentCSS, _environmentNamae } from '../../../appsettings.json';
import { map } from 'rxjs/operators';
declare var $: any;
import { ChangeDetectorRef } from '@angular/core';
import { Observable } from 'rxjs';
import { User } from './core/domain/user.model';
import { Console } from 'console';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  providers: [SearchService, UtilityService, PushNotificationComponent, scenarioService, AutoLogoutService, LoggingService]
})

////@Component({
////  selector: 'app-root',
////  //host: { '(window:scroll)': 'track($style-5)' },
////  templateUrl: "./app.component.html",
////  providers: [SearchService, UtilityService, PushNotificationComponent, scenarioService, AutoLogoutService, LoggingService]
////})

//@Injectable()
//@Directive({ selector: '[PushNotificationComponent]' })

export class AppComponent implements OnInit {
  public _searchObj !: Search;
  public _searchData !: Search;
  public _result: any;
  public _temppagePath: any;
  public _pagePath: any;
  public _isSearchDataFetching: boolean = false;
  public _dvEmptySearchMsg: boolean = false;

  public _pageSizeSearch: number = 10;
  public _pageIndexSearch: number = 1;
  public _totalCountSearch: number = 0;
  public _totalCount: number = 0;
  public _isShowDealMenu: boolean = true;
  public _isShowNoteMenu: boolean = true;
  public _callmenupermisisoncode: boolean = false;
  public _isShowPropertyMenu: boolean = true;
  public _isShowFinancingMenu: boolean = true;
  public _isShowCMMenu: boolean = true;
  public _isShowIndexesMenu: boolean = true;
  public _isShowreportMenu: boolean = true;
  public _isShowUnderwritingMenu: boolean = true;
  public _isShowAddNewTopMenu: boolean = true;
  public _isShowAddNewTopMenuUserProfile: boolean = true;
  public _isShowAddNewTopMenuAlert: boolean = true;
  public _environmentCSS: string = appsettings._environmentCSS;
  public _environmentNamae: string = appsettings._environmentNamae;
  public _TotalNotificationCount!: string;
  public _Notifications!: string;
  public _isNotificationsshow: boolean = false;
  public _Notificationscount!: number;
  public _NotificationscountText: any;
  public canSendMessage!: boolean;
  public allMessages: any;
  public notificationmessage!: string;
  public currentnotificationcount: number = 0;
  public unotification = new Array<UserNotification>();
  public _pageIndex: number = 1;
  public _isGetMenuPermission: boolean = false;
  public _isShowRuleEngineMenu: boolean = true;
  public _isShowWorkFlowMenu: boolean = true;
  public _scenariodc: Scenario;
  private _user: User;
  //private _scenarioUserMap: ScenarioUserMap;
  public _lstScenario: any;
  public _isShowDynamicPortfolio: boolean = true;


  public _selectedColor!: string;
  public _isShowScenario: boolean = true;
  public _isShowFeeConfiguration: boolean = true;
  public _isShowTransactionReconciliation: boolean = true;
  public _isShowAccountingClose: boolean = true;
  public _isShowXIRR: boolean = true;
  public userNameList: any;
  public _isShowImpersonate: boolean = false;
  public _isShowReturntoimpersonator: boolean = false;
  public _returnToImpersonator!: boolean;

  public _isShowTagMasterMenu: boolean = true;
  public _isShowChatBox: boolean = false;
  public HBOTApiKey: any;
  public HBOTApiPath: any;
  public _issessionstart: boolean = false;
  public _isuserinactive: boolean = false;
  public IPAddress: any;
  private _ShowmessagedivMsgWar: any;
  public _ShowmessagedivWar: boolean = false;
  private _Showmessagediv: boolean = false;
  public _ShowSuccessmessagediv: boolean = false;
  private _ShowSuccessmessage: any;
  @ViewChild('acAsync') acAsync!: wjNg2Input.WjAutoComplete;
  @ViewChild('notification') Push!: PushNotificationComponent;
  title: string = 'CRES';
  description: string = 'New deal';
  @ViewChild('style-5') notifidiv!: HTMLDivElement;
  public formValue: string = "";
  public QuesAnsasked: any;

  _isrefreshsession: boolean = false;
  public chatmsg: any;
  public timeoutID: any;
  public _issearch: boolean = false;
  public _index: number = 0;
  public botstatus: string = '';
  public intentName!: string;
  public _isnewpageRender: boolean = false;
  public isPageRender: boolean = false;
  public _issearchbox: boolean = false;
  public _isShowchatpopup: boolean = false;
  public isChatEnabled: boolean = false;
  public userspeech = '';
  public _isAIEnable = appsettings._isAIEnable;
  public _isUserLoggedIn !: boolean;
  public messages: Observable<Message[]>;
  public isAnsReceived: boolean = false;
  public isAPICalled: boolean = false;
  public _isShowAutomationMenu: boolean = false;

  constructor(@Inject(AzureADAuthService) private _authService: AzureADAuthService, private _authServiceInternal:AzureADAuthServiceInternal,
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
    public httpClient: HttpClient,
    public loggingService: LoggingService,
    public chatservice: ChatService,
    private cdref: ChangeDetectorRef
  ) {
   // this.CheckifUserIsLogedIN();
    this.isUserLoggedIn();
    this._scenariodc = new Scenario('');
    this._lstScenario = this._scenariodc.LstScenarioUserMap;
    var impersonateuser: any = localStorage.getItem('impersonatorUserInfo');
    var _impersonateuserData = JSON.parse(impersonateuser);
    if (_impersonateuserData != null || _impersonateuserData != undefined) {
      this.GetUsersToImpersonate();
    }

    this.HideMenu();
    this.MenuforViewer();
    setTimeout(() => {
      this.subscribeToEvents();
    }, 8000);
    $("#notificationscount").text("");

    var returnUrl = this._router.url;
    if (returnUrl.indexOf('dashboard') > -1 || returnUrl == '/' || returnUrl == '') {
      this._isShowchatpopup = false;
    }
    localStorage.setItem('IsChatmsgBind', 'false');
    this.dataService.getIPAddress();

    var logoutFrom = localStorage.getItem("logoutFrom");

    if (logoutFrom == "Internal") {
      window.localStorage.removeItem("logoutFrom");
      window.localStorage.clear();
      this._router.navigate(['logininternal']);
    }
    else if (logoutFrom == "Main") {
      window.localStorage.removeItem("logoutFrom");
      window.localStorage.clear();
      this._router.navigate(['login']);
    }
  }

  ngOnInit() {
    this.messages = this.chatservice.conversation.asObservable();
  }
  ngAfterContentChecked() {
    this.cdref.detectChanges();
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
          this._Notificationscount = 0;
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
    (error: string) => console.error('Error: ' + error)
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
    var useremil: any = window.localStorage.getItem("useremail");

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
        this._isShowAccountingClose = false;
        this._isShowXIRR = false;

        this._isShowTagMasterMenu = false;
        this.GetMenuPermission();
        //  this.GetUsersToImpersonate();
        setTimeout(() => {
          this.GetUserNotificationCount();
        }, 6000);

      }
    }
    else {
      var user: any = localStorage.getItem('user');
      if (user != null) {
        var _userData = JSON.parse(user);
      }
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
        this._isShowAccountingClose = false;
        this._isShowTagMasterMenu = false;
        this._isShowXIRR = false;
        
        this.GetMenuPermission();
        //  this.GetUsersToImpersonate();

      }
      return _userData != undefined ? _userData.FirstName : '';
    }
    var user: any = localStorage.getItem('user');
    if (user != null) {
      var _userData = JSON.parse(user);
    }
    return _userData != undefined ? _userData.FirstName : '';
  }

  getemailId(): string {
    var useremail = this._authService.getemail();
    localStorage.setItem('useremail', useremail);

    this._isSearchDataFetching = false;
    return useremail;
  }

  isUserLoggedIn() {
    this.getemailId();
    return this.membershipService.isUserAuthenticated();
  }


  


  logout(state = "/"): void {
    var useremil: any = window.localStorage.getItem("useremail");

    if (useremil.toString() !== "undefined") {
      var link = window.location.href;
      link = link.substr(0, link.lastIndexOf("/"));
      // window.location.href = "https://login.microsoftonline.com/b8267886-f0c8-4160-ab6f-6e97968fdc90/oauth2/logout?post_logout_redirect_uri=" + "http://acore.azurewebsites.net/"
      //this._authService.LogOutall();
      this._authServiceInternal.LogOutall();

      localStorage.removeItem('user');
      localStorage.removeItem('useremail');
      window.localStorage.removeItem("id_token");
      window.localStorage.removeItem("access_token");
      window.localStorage.removeItem("allowbasiclogin");
      //window.localStorage.clear();

    }
    else {
      this.membershipService.logout()
        .subscribe(res => {

          var dbloginfrom = localStorage.getItem('dbloginfrom');
          localStorage.removeItem('dbloginfrom');
          if (dbloginfrom == 'main') {
            let link = ['login'];
            this._router.navigate(link);
          }
          else {
            let link = ['logininternal'];
            this._router.navigate(link);
          }

         
          this._callmenupermisisoncode = false;
        },
          error => console.error('Error' + error),
          () => { });
    }

    //update for reload left menu after new login
    this._isGetMenuPermission = false;
  }


  // select first item if user presses enter and nothing is selected
  public initialized(sender: wjNg2Input.WjAutoComplete) {
    var ac = sender;
    var totalCount = this._totalCountSearch;
    var _isAIEnable: any = this._isAIEnable;
    ac.hostElement.addEventListener('keydown', function (e: any) {
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
  checkTextboxChanged(sender: wjNg2Input.WjAutoComplete, e: any) {
    var ac = sender;
    var x = e.which || e.keyCode;
    var _isboxclicked = false;
    var inputValue = (<HTMLInputElement>document.getElementById('hdnSearchCount')).value;
    if (inputValue == '1') {
      this._isSearchDataFetching = true;
      (<HTMLInputElement>document.getElementById('hdnSearchCount')).value = "0";
      if (this._isAIEnable == "false") {
        ac.selectedIndex = 0;
      }
      setTimeout(() => {
        this.checkDroppedDownChanged(sender, e);
      }, 2000);
    }
  }

  // to assign display name to innerhtml
  formatautocompleteListbox(sender: wjNg2Input.WjAutoComplete, e: any) {
    var data = e.data;
    e.item.innerHTML = data.DisplayName;
  }
  public _existsdealnamefound = false;
  // handle dropdown clicks: this method gets invoked when the dropdown's itemClicked event fires
  public checkDroppedDownChanged(sender: wjNg2Input.WjAutoComplete, e: any) {
    var ac: any = sender;
    if (ac.selectedIndex > -1) {
      var obj = JSON.parse(JSON.stringify(ac.selectedItem));
      this._isSearchDataFetching = true;
      var text = ac.text;
      var guid = ac.selectedValue;
      var _foundMatch = false;
      var select: any;

      if (this._isAIEnable == "true") {
        //@ is present in string
        if (this._issearch == true) {
          var chkstr = ac.text.indexOf('@');
          // if deal name contains @
          if (chkstr > 0) {
            this._existsdealnamefound = true;
            select = ac.text;
          }
          else {
            select = this.formValue + ac.text;
          }


          //@ present at the start
          if (this.formValue == "") {
            select = ac.text;
            this.sendMessage(sender);
            _foundMatch = true;
          }
        }
        else {
          //selected value from dropdown
          if ((this.formValue.length >= 2) || (ac.text.length != this.formValue.length)) {
            select = ac.text;
            this.sendMessage(sender);
            _foundMatch = true;
          }
          else {
            //typed not selected
            if (this.formValue.length == ac.text.length) {
              select = ac.text;
              this.sendMessage(sender);
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
      (error: string) => console.error('Error: ' + error)
      setTimeout(() => {
        this._isSearchDataFetching = false;
      }, 2000);

      // to stop open deal via AI if opened with click
      //setTimeout(function () {
      //    this._issearchbox = false;
      //}.bind(this), 4000);
      //===================================

      if (this._isAIEnable == "false") {
        ac.text = "";
        this._router.navigate(this._pagePath);
      }

    }
  }

  defaultSearch(ac: any, obj: any) {
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
    } else if (obj.ValueType == 844) {
      //LiabilityNote
      if (window.location.href.indexOf("liabilityNote/n") > -1) {
        this._pagePath = ['liabilityNote/u', ac.selectedValue]
      }
      else {
        this._pagePath = ['liabilityNote/n', ac.selectedValue]
      }
    } else if (obj.ValueType == 842) {
      //LiabilityNote
      if (window.location.href.indexOf("debt/n") > -1) {
        this._pagePath = ['debt/u', ac.selectedValue]
      }
      else {
        this._pagePath = ['debt/n', ac.selectedValue]
      }
    } else if (obj.ValueType == 843) {
      //LiabilityNote
      if (window.location.href.indexOf("equity/n") > -1) {
        this._pagePath = ['equity/u', ac.selectedValue]
      }
      else {
        this._pagePath = ['equity/n', ac.selectedValue]
      }
    }
  }

  private _cache = {};
  getAutosuggestData = this.getAutosuggestDataFunc.bind(this);
  getAutosuggestDataFunc(query: any, max: any, callback: any) {
    if (query != null) {
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
      var result: any;
      //autosearch enable after 1 character 
      if (query.length >= 2) {
        // try getting the result from the cache
        var self: any = this,
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
        var self: any = this,
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
                _valueType = '<img src="../assets/images/Letter-D-blue-icon.png" /> ';
              }
              else if (c.ValueType == 182) { //Note
                _valueType = '<img src="../assets/images/Letter-N-blue-icon.png" /> ';
              } else if (c.ValueType == 844) {
                _valueType = '<img src="../assets/images/liquidity_note.png" /> ';
              }
              else if (c.ValueType == 842) {
                _valueType = '<img src="../assets/images/Letter-Debt-blue-icon.png" /> ';
              }
              else if (c.ValueType == 843) {
                _valueType = '<img src="../assets/images/Letter-Equity-blue-icon.png" /> ';
              }              
              c.DisplayName = _valueType + c.Valuekey;
            }
            callback(this._result);

          }

          else {
            this.utilityService.navigateToSignIn();
          }
        });
        (error: string) => console.error('Error: ' + error)
      }
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
              if (_object[i].ChildModule == 'Accounting_Close') {
                this._isShowAccountingClose = true;
              }
              if (_object[i].ChildModule == 'XIRR') {
                this._isShowXIRR = true;
              }

              if (_object[i].ChildModule == 'Tag_Master') {
                this._isShowTagMasterMenu = true;
              }
              if (_object[i].ChildModule == 'GenerateAutomation') {
                this._isShowAutomationMenu = true;
              }
            //  this._isShowXIRR = true;
              

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
      var _user: any = localStorage.getItem('user');
      var user = JSON.parse(_user);
      var impersonateuser = localStorage.getItem('impersonatorUserInfo');
      if (impersonateuser != null && impersonateuser != undefined) {
        user = JSON.parse(impersonateuser);
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
      if (_pushNotification.length > 1) {
        this.description = _pushNotification[1];
        if (_pushNotification.length > 2) {
          this.Push.notificationroutepath = _pushNotification[2];
          this.Push.show();
        }
      }
      // console.log('12' + message);
    });

  }

  openLink(module: any): void {
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
    else if (module == 'debt') {
      this._pagePath = ['debt'];
    }
    else if (module == 'equity') {
      this._pagePath = ['equity'];
    }
    else if (module == 'investors') {
      this._pagePath = ['investors'];
    }
    else if (module == 'journalLedger') {
      this._pagePath = ['journalLedger'];
    }

    this._router.navigate(this._pagePath)
  }

  getAllDistinctScenario(): void {
    var user: any = localStorage.getItem('user');
    if (user != null) {
      var _userData = JSON.parse(user);
      this._scenariodc.UserID = _userData.UserID;
    }
    this.scenarioService.getAllScenarioDistinct(this._scenariodc).subscribe(res => {
      if (res.Succeeded) {
        this._lstScenario = res.lstScenarioUserMap;

        localStorage.setItem('lstScenario', this._lstScenario);
        var DefaultScenarioID = res.lstScenarioUserMap.filter((x: any) => x.ScenarioName == "Default")[0].AnalysisID;
        localStorage.setItem('DefaultScenarioID', DefaultScenarioID);
        this.getScenarioByUser();
      }
    });
  }

  showDialog(): void {
    var modalRole: any = document.getElementById('myModelimpersonate');
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

  SaveScenarioUserMap(_analysisID: any, ScenarioName: any): void {
    //_analysisID = _analysisID.value;
    var scenarioobj = this._lstScenario.filter((x: any) => x.AnalysisID == _analysisID);
    this._selectedColor = scenarioobj[0].ScenarioColor;
    var user: any = localStorage.getItem('user');
    var _userData = JSON.parse(user);
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
    var user: any = localStorage.getItem('user');
    var _userData = JSON.parse(user);
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
    var myform: any = document.getElementById("myForm");
    myform.style.display = "block";
  }

  closeForm() {
    var myform: any = document.getElementById("myForm");
    myform.style.display = "none";
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
    var impersonateuser: any = localStorage.getItem('impersonatorUserInfo');
    var impersonateuserdata = JSON.parse(impersonateuser);
    var userdata = window.localStorage.getItem("user");
    if (impersonateuserdata != null || impersonateuserdata != undefined) {
      localStorage.setItem('AIToken', impersonateuserdata.Token);
      localStorage.setItem('AITokenUId', impersonateuserdata.TokenUId);
      localStorage.setItem('AISession', impersonateuserdata.LoginSession);
    }
    else if (userdata != null || userdata != undefined) {
      var user = JSON.parse(userdata);
      localStorage.setItem('AIToken', user.Token);
      localStorage.setItem('AITokenUId', user.TokenUId);
      localStorage.setItem('AISession', user.LoginSession);
    }
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


  sendMessage(sender: wjNg2Input.WjAutoComplete) {
    if (this._isAIEnable == "true") {
      this.isChatEnabled = true;
      var ac: any = sender;
      this.formValue = ac.text;
      ac.text = "";

      // calling for AI config key.
      var dialogflowbaseurl = localStorage.getItem('dialogflowbaseurl');
      if (dialogflowbaseurl == undefined || dialogflowbaseurl == null || dialogflowbaseurl == "") {
        this.GetSystemConfigKeys();
      }
      this.isAnsReceived = true;
      ac.hostElement.addEventListener('keydown', function (e: any) {
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
        var formval = this.formValue;
        this.formValue = formval.charAt(0).toUpperCase() + formval.slice(1).replace(/\\/g, '').replace('@', '');
        this.chatservice.converse(this.formValue, this._isShowchatpopup);
        if (this._isShowchatpopup == true) {
          this.isAPICalled = true;
          if (this._isShowchatpopup == true) {
            this.messages.subscribe((val) => {
              if (val.length > 0) {
                if (this.isAPICalled == true) {
                  this.updateMessage(val);
                }
              }
            });
          }
        }
        else {
          //for dashboard page
          this.chatservice.sendMessage(this.formValue);
        }
      }
      setTimeout(() => {
        this.isAnsReceived = false;
      }, 3800);

      this.formValue = "";
    }
  }

  updateMessage(msg) {
    $('#showChatDiv').show();
    var parentid = localStorage.getItem("appParentId");
    var intentname = localStorage.getItem("appIntentName");

    if (parentid == null || parentid == undefined) {
      localStorage.setItem("appParentId", "null");
    }
    if (intentname == null || intentname == undefined) {
      localStorage.setItem("appIntentName", "null");
    }

    if (msg[0].sentBy == "bot") {
      this.isAPICalled = false;
      var botstatus = msg[0].content.status;
      var botintentname = msg[0].content.intentName;
      var founddiff: boolean = false;

      if (parentid == "Continue" && intentname != msg[0].content.intentName) {
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
        _appiDiv.innerHTML = this.userspeech;
        var displaytime = new Date().toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });
        _appdateDiv.innerHTML = displaytime;
        _appiDiv.appendChild(_appdateDiv);

        //create innerdiv
        _appinnerDiv.className = 'divAnswers';
        _appinnerDiv.id = 'innerdiv';
        _appinnerDiv.innerHTML = '';
        _appinnerDiv.innerHTML = '<p>' + msg[0].content.Speech + '</p>';
        _appiDiv.appendChild(_appinnerDiv);
      }

      if (parentid == "Continue" && intentname == msg[0].content.intentName) {
        if (document.getElementById("innerdiv")) {
          var firstresponse = '';
          var firstinnerdiv: any = document.getElementById("innerdiv");
          var firstresponse = '<p>' + firstinnerdiv.innerHTML.toString() + '</p>';
          firstinnerdiv.innerHTML = '';
          firstresponse = firstresponse + '<p>' + this.userspeech + '</p>';
          firstresponse = firstresponse + '<p>' + msg[0].content.Speech + '</p>';
          firstinnerdiv.innerHTML = '';
          firstinnerdiv.innerHTML = firstresponse;
        }
      }

      if (document.getElementsByClassName("chatDivactivity").length > 0) {
        var item = document.getElementsByClassName("chatDivactivity")[0].appendChild(_appiDiv);
        $("#showChatDiv").prepend(item);
      }
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
    } else {
      this.userspeech = msg[0].content.Speech;
    }
  }


  errorHandler(error: any): void {
    console.log(error);
  }

  closeChatbox() {
    this._isShowchatpopup = false;
  }

  //close innerpage div when clicked outside
  //latestcode
  closeinnerChatbox(e: any) {
    var autosearch: any = document.getElementById('autosearch');
    var showchatdiv: any = document.getElementById('showChatDiv');
    if (autosearch.contains(e.target)) {
      $('#showChatDiv').show();
    }
    else if (showchatdiv.contains(e.target)) {
      $('#showChatDiv').show();
    }
    else {
      e.stopPropagation();
      $('#showChatDiv').hide();
    }
  }
}
