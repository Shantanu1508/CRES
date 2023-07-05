import { Component, Inject, NgModule, Injectable } from "@angular/core";
import { Router, ActivatedRoute } from '@angular/router';
//import { dealService } from '../core/services/dealService';
import { DashboardService } from '../core/services/dashboardService';
import { User } from '../core/domain/user';
import { MembershipService } from '../core/services/membershipservice';
import { OperationResult } from '../core/domain/operationResult';
import { UtilityService } from '../core/services/utilityService';
import { ModuleWithProviders } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { Location, LocationStrategy, HashLocationStrategy } from '@angular/common';
import { Headers, RequestOptions, BaseRequestOptions, Http } from '@angular/http';
import { ChatService } from '../core/services/chatService';
import { Message, MsgSpeech } from "../core/domain/BotMessage";
import { DataService } from "../core/services/dataService";
declare var $: any;

@Component({
    selector: 'dashboard',
    templateUrl: "app/components/dashboard.html?v=" + $.getVersion(),
    providers: [DashboardService, MembershipService],
})

@Injectable()


export class DashboardComponent {
    //  private routes = Routes;
    private _router: Router;
    message: string;
    lstMyDeal: any;
    lstProperty: any;
    lstLastUpdatedDeal: any;
    lstUpFunding: any;
    lstNewDeal: any;
    isPageRender: boolean = true;
    isMyDeal: boolean = false;
    isProperty: boolean = false;
    isLastUpdatedDeal: boolean = false;
    isUpFunding: boolean = false;
    isNewDeal: boolean = false;
    _ShowdivMsgWar: boolean = false;
    _WarmsgdashBoad: any;
    private _dvDashboardSearchMsg: boolean = false;
    public chatLogList: any = [];
    public _userchat: any;
    public userarr: any = '';
    public botarr: any = [];
    public _isrefreshsession: boolean = false;
    public _pageSize: number = 50;
    public _pageIndex: number = 1;
    public _istodaylist: boolean = false;
    public _isyesterdaylist: boolean = false;
    public _ispastlist: boolean = false;
    public _ischathistory: boolean = false;
    public _createmultipleinnerdiv: boolean = false;


    constructor(public dashboardService: DashboardService, private route: ActivatedRoute, public membershipService: MembershipService, public utilityService: UtilityService,
        public chatservice: ChatService, public httpClient: Http, public dataService: DataService
    ) {

        // this.routes = Routes;
        //   this._router = router;

        this._userchat = setInterval(() => {
            var data: any = [];
            var _isdivbind = localStorage.getItem('IsChatmsgBind');
            if (_isdivbind == 'true') {
                data = this.chatservice.getMessage();
                if (this._istodaylist == false) {
                    this._istodaylist = true;
                    this._ischathistory = false;
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

                    this._ischathistory = false;
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
                this.chatservice.setMessage(msg);
            }
        }, 500);
        localStorage.setItem('divSucessDeal', null);
        localStorage.setItem('divWarningMsg', null);
        localStorage.setItem("ParentId", null);
        localStorage.setItem("IntentName", null);
        this.getDashboardData();
        this.utilityService.setPageTitle("M61–Dashboard");
    }
    ngOnInit() {
        this.getChatHistory();
    }
    getDashboardData(): void {

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

        this.dashboardService.getAllDashboardData().subscribe(res => {
            if (res.Succeeded) {
                if (res.lstdashBoard.length == 0) {
                    this._dvDashboardSearchMsg = true;
                }
                var data: any = res.lstdashBoard;
                //this.lstMyDeal = data;
                this.lstMyDeal = data.filter(x => x.Module == "Deal");
                this.lstProperty = data.filter(y => y.Module == "Property");
                this.lstLastUpdatedDeal = data.filter(x => x.Module == "LastUpdatedDeal");
                this.lstUpFunding = data.filter(u => u.Module == "UpcomingFunding");
                this.lstNewDeal = data.filter(x => x.Module == "NewDeal");

                this.isMyDeal = this.lstMyDeal.length > 0 ? true : false;
                this.isProperty = this.lstProperty.length > 0 ? true : false;
                this.isLastUpdatedDeal = this.lstLastUpdatedDeal.length > 0 ? true : false;
                this.isUpFunding = this.lstUpFunding.length > 0 ? true : false;
                this.isNewDeal = this.lstNewDeal.length > 0 ? true : false;

                this.isPageRender = false;
            }
            else {
                //  alert('error');
                this._router.navigate(['/login']);
            }
        });
        error => console.error('Error: ' + error)
    }

    clickedlink() {
        this.isPageRender = true;
    }

    //ngOnInit() {
    //   // alert(123);
    //    this.message = "Welcome to CRES";
    //   //== this.getDashboardData();
    //}

    public _ischatstatus: boolean = false;
    public _isnotchatstatus: boolean = false;
    getChatHistory() {
        this.membershipService.getChatLogHistory(this._pageIndex, this._pageSize).subscribe(res => {
            if (res) {
                var data = res.Listdt;
                if (data.length > 0) {
                    this._ischathistory = false;
                    this._isrefreshsession = false;
                    this.chatLogList = data;
                    var todaylist = data.filter(x => x.DateText == "Today");
                    var yesterdaylist = data.filter(x => x.DateText == "Yesterday");
                    var pastlist = data.filter(x => x.DateText == "Past");

                    if (pastlist.length > 0) {
                        this._ispastlist = true;
                        this.CreateMultipleDiv(pastlist, "Past");
                    }
                    if (yesterdaylist.length > 0) {
                        this._isyesterdaylist = true;
                        this.CreateMultipleDiv(yesterdaylist, "Yesterday");
                    }
                    if (todaylist.length > 0) {
                        this._istodaylist = true;
                        this.CreateMultipleDiv(todaylist, "Today");
                    }
                }
                else {
                    this._ischathistory = true;
                    this._isrefreshsession = false;
                }
            }
        });
    }

    CreateMultipleDiv(data, text) {
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
    }
}

const routes: Routes = [

    { path: '', component: DashboardComponent }]

@NgModule({
    imports: [FormsModule, CommonModule, RouterModule.forChild(routes)],
    declarations: [DashboardComponent],
    exports: [DashboardComponent]
})

export class DashboardModule { }