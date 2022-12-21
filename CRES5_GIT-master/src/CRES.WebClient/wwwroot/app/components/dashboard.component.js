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
exports.DashboardModule = exports.DashboardComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
//import { dealService } from '../core/services/dealService';
var dashboardService_1 = require("../core/services/dashboardService");
var membershipservice_1 = require("../core/services/membershipservice");
var utilityService_1 = require("../core/services/utilityService");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var http_1 = require("@angular/http");
var chatService_1 = require("../core/services/chatService");
var dataService_1 = require("../core/services/dataService");
var DashboardComponent = /** @class */ (function () {
    function DashboardComponent(dashboardService, route, membershipService, utilityService, chatservice, httpClient, dataService) {
        // this.routes = Routes;
        //   this._router = router;
        var _this = this;
        this.dashboardService = dashboardService;
        this.route = route;
        this.membershipService = membershipService;
        this.utilityService = utilityService;
        this.chatservice = chatservice;
        this.httpClient = httpClient;
        this.dataService = dataService;
        this.isPageRender = true;
        this.isMyDeal = false;
        this.isProperty = false;
        this.isLastUpdatedDeal = false;
        this.isUpFunding = false;
        this.isNewDeal = false;
        this._ShowdivMsgWar = false;
        this._dvDashboardSearchMsg = false;
        this.chatLogList = [];
        this.userarr = '';
        this.botarr = [];
        this._isrefreshsession = false;
        this._pageSize = 50;
        this._pageIndex = 1;
        this._istodaylist = false;
        this._isyesterdaylist = false;
        this._ispastlist = false;
        this._ischathistory = false;
        this._createmultipleinnerdiv = false;
        //ngOnInit() {
        //   // alert(123);
        //    this.message = "Welcome to CRES";
        //   //== this.getDashboardData();
        //}
        this._ischatstatus = false;
        this._isnotchatstatus = false;
        this._userchat = setInterval(function () {
            var data = [];
            var _isdivbind = localStorage.getItem('IsChatmsgBind');
            if (_isdivbind == 'true') {
                data = _this.chatservice.getMessage();
                if (_this._istodaylist == false) {
                    _this._istodaylist = true;
                    _this._ischathistory = false;
                }
                if (data.length > 0) {
                    //to set for new question start
                    var parentid = localStorage.getItem("ParentId");
                    var intentname = localStorage.getItem('IntentName');
                    if (parentid == "Continue" && intentname != data[0].intentName) {
                        localStorage.setItem("ParentId", 'End');
                    }
                    parentid = localStorage.getItem("ParentId");
                    intentname = localStorage.getItem('IntentName');
                    // create parent div and inner div
                    var botstatus = data[0].status;
                    var botintentname = data[0].intentName;
                    var iDiv = document.createElement('div');
                    var dateDiv = document.createElement('span');
                    dateDiv.className = 'divtimeai';
                    _this._ischathistory = false;
                    if (parentid == "null" || parentid == "End") {
                        var innerDiv = document.createElement('p');
                        iDiv.innerHTML = '';
                        iDiv.id = 'activity';
                        iDiv.className = 'divQuestion';
                        iDiv.innerHTML = data[0].userSpeech;
                        var displaytime = new Date().toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });
                        dateDiv.innerHTML = displaytime;
                        iDiv.appendChild(dateDiv);
                        //create innerdiv
                        innerDiv.className = 'divAnswers';
                        innerDiv.id = 'innerdiv';
                        innerDiv.innerHTML = '';
                        innerDiv.innerHTML = data[0].Speech;
                        iDiv.appendChild(innerDiv);
                    }
                    if (parentid == "Continue" && intentname == data[0].intentName) {
                        if (document.getElementById("innerdiv")) {
                            var firstresponse = '';
                            firstresponse = '<p>' + document.getElementById("innerdiv").innerHTML.toString() + '</p>';
                            document.getElementById("innerdiv").innerHTML = '';
                            firstresponse = firstresponse + '<p>' + data[0].userSpeech + '</p>';
                            firstresponse = firstresponse + '<p>' + data[0].Speech + '</p>';
                            document.getElementById("innerdiv").innerHTML = '';
                            document.getElementById("innerdiv").innerHTML = firstresponse;
                        }
                    }
                    if (document.getElementsByClassName("todayactivity").length > 0) {
                        var item = document.getElementsByClassName("todayactivity")[0].appendChild(iDiv);
                        $("#activity").prepend(item);
                    }
                    localStorage.setItem('IsChatmsgBind', 'false');
                }
                //to set msg emtpy
                localStorage.setItem("ParentId", 'End');
                localStorage.setItem("IntentName", botintentname);
                if (botstatus != "0") {
                    localStorage.setItem("ParentId", 'End');
                }
                else {
                    if (botstatus == "0") {
                        localStorage.setItem("ParentId", 'Continue');
                    }
                }
                var msg = [];
                _this.chatservice.setMessage(msg);
            }
        }, 500);
        localStorage.setItem('divSucessDeal', null);
        localStorage.setItem('divWarningMsg', null);
        localStorage.setItem("ParentId", null);
        localStorage.setItem("IntentName", null);
        this.getDashboardData();
        this.utilityService.setPageTitle("M61–Dashboard");
    }
    DashboardComponent.prototype.ngOnInit = function () {
        this.getChatHistory();
    };
    DashboardComponent.prototype.getDashboardData = function () {
        var _this = this;
        if (localStorage.getItem('showWarningMsgdashboard') == 'true') {
            this._ShowdivMsgWar = true;
            this._WarmsgdashBoad = localStorage.getItem('WarmsgdashBoad');
            this._WarmsgdashBoad = (this._WarmsgdashBoad.replace('\"', '')).replace('\"', '');
            localStorage.setItem('showWarningMsgdashboard', JSON.stringify(false));
            localStorage.setItem('WarmsgdashBoad', JSON.stringify(''));
            setTimeout(function () {
                this._ShowdivMsgWar = false;
            }.bind(this), 5000);
        }
        this.dashboardService.getAllDashboardData().subscribe(function (res) {
            if (res.Succeeded) {
                if (res.lstdashBoard.length == 0) {
                    _this._dvDashboardSearchMsg = true;
                }
                var data = res.lstdashBoard;
                //this.lstMyDeal = data;
                _this.lstMyDeal = data.filter(function (x) { return x.Module == "Deal"; });
                _this.lstProperty = data.filter(function (y) { return y.Module == "Property"; });
                _this.lstLastUpdatedDeal = data.filter(function (x) { return x.Module == "LastUpdatedDeal"; });
                _this.lstUpFunding = data.filter(function (u) { return u.Module == "UpcomingFunding"; });
                _this.lstNewDeal = data.filter(function (x) { return x.Module == "NewDeal"; });
                _this.isMyDeal = _this.lstMyDeal.length > 0 ? true : false;
                _this.isProperty = _this.lstProperty.length > 0 ? true : false;
                _this.isLastUpdatedDeal = _this.lstLastUpdatedDeal.length > 0 ? true : false;
                _this.isUpFunding = _this.lstUpFunding.length > 0 ? true : false;
                _this.isNewDeal = _this.lstNewDeal.length > 0 ? true : false;
                _this.isPageRender = false;
            }
            else {
                //  alert('error');
                _this._router.navigate(['/login']);
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    DashboardComponent.prototype.clickedlink = function () {
        this.isPageRender = true;
    };
    DashboardComponent.prototype.getChatHistory = function () {
        var _this = this;
        this.membershipService.getChatLogHistory(this._pageIndex, this._pageSize).subscribe(function (res) {
            if (res) {
                var data = res.Listdt;
                if (data.length > 0) {
                    _this._ischathistory = false;
                    _this._isrefreshsession = false;
                    _this.chatLogList = data;
                    var todaylist = data.filter(function (x) { return x.DateText == "Today"; });
                    var yesterdaylist = data.filter(function (x) { return x.DateText == "Yesterday"; });
                    var pastlist = data.filter(function (x) { return x.DateText == "Past"; });
                    if (pastlist.length > 0) {
                        _this._ispastlist = true;
                        _this.CreateMultipleDiv(pastlist, "Past");
                    }
                    if (yesterdaylist.length > 0) {
                        _this._isyesterdaylist = true;
                        _this.CreateMultipleDiv(yesterdaylist, "Yesterday");
                    }
                    if (todaylist.length > 0) {
                        _this._istodaylist = true;
                        _this.CreateMultipleDiv(todaylist, "Today");
                    }
                }
                else {
                    _this._ischathistory = true;
                    _this._isrefreshsession = false;
                }
            }
        });
    };
    DashboardComponent.prototype.CreateMultipleDiv = function (data, text) {
        var iDiv = new Array();
        for (var i = 0; i < data.length; i++) {
            if (data[i].ParentId == data[i].chatlogid) {
                // if (data[i].status == null || data[i].status == "null") {
                iDiv[i] = document.createElement('div');
                var dateDiv = document.createElement('span');
                dateDiv.className = 'divtimeai';
                iDiv[i].id = 'activity';
                iDiv[i].className = 'divQuestion';
                iDiv[i].innerHTML = data[i].Speech;
                if (text == "Past") {
                    var pastitem = document.getElementsByClassName("pastactivity")[0].appendChild(iDiv[i]);
                    $("#pastactivity").prepend(pastitem);
                }
                if (text == "Yesterday") {
                    var yesterdayitem = document.getElementsByClassName("yesterdayactivity")[0].appendChild(iDiv[i]);
                    $("#yesterdayactivity").prepend(yesterdayitem);
                }
                if (text == "Today") {
                    var todayitem = document.getElementsByClassName("todayactivity")[0].appendChild(iDiv[i]);
                    $("#todayactivity").prepend(todayitem);
                }
                if (text == "Today") {
                    dateDiv.innerHTML = data[i].DisplayTime;
                }
                else {
                    var converteddate = new Date(data[i].DisplayDate).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                    dateDiv.innerHTML = converteddate;
                }
                iDiv[i].appendChild(dateDiv);
                //create innerdiv
                for (var k = data.length - 1; k >= 0; k--) {
                    if (data[k].ParentId == data[i].ParentId && data[i].ParentId != data[k].chatlogid) {
                        var innerDiv = document.createElement('div');
                        innerDiv.className = 'divAnswers';
                        iDiv[i].appendChild(innerDiv);
                        innerDiv.innerHTML = data[k].Speech;
                    }
                }
            }
        }
    };
    var _a, _b;
    DashboardComponent = __decorate([
        (0, core_1.Component)({
            selector: 'dashboard',
            templateUrl: "app/components/dashboard.html?v=" + $.getVersion(),
            providers: [dashboardService_1.DashboardService, membershipservice_1.MembershipService],
        }),
        (0, core_1.Injectable)(),
        __metadata("design:paramtypes", [dashboardService_1.DashboardService, typeof (_a = typeof router_1.ActivatedRoute !== "undefined" && router_1.ActivatedRoute) === "function" ? _a : Object, membershipservice_1.MembershipService, utilityService_1.UtilityService,
            chatService_1.ChatService, typeof (_b = typeof http_1.Http !== "undefined" && http_1.Http) === "function" ? _b : Object, dataService_1.DataService])
    ], DashboardComponent);
    return DashboardComponent;
}());
exports.DashboardComponent = DashboardComponent;
var routes = [
    { path: '', component: DashboardComponent }
];
var DashboardModule = /** @class */ (function () {
    function DashboardModule() {
    }
    DashboardModule = __decorate([
        (0, core_1.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes)],
            declarations: [DashboardComponent],
            exports: [DashboardComponent]
        })
    ], DashboardModule);
    return DashboardModule;
}());
exports.DashboardModule = DashboardModule;
//# sourceMappingURL=dashboard.component.js.map