import { Component, Inject, NgModule } from "@angular/core";
import { Router, ActivatedRoute, Params, Route } from '@angular/router';
import { TaskManagement, TaskComment } from "../core/domain/TaskManagement";
import { TaskManagerService } from '../core/services/TaskManagerService';
import { User } from '../core/domain/user';
import { MembershipService } from '../core/services/membershipservice';
import { OperationResult } from '../core/domain/operationResult';
import { UtilityService } from '../core/services/utilityService';
import { ModuleWithProviders } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { Location, LocationStrategy, HashLocationStrategy } from '@angular/common';
import { Headers, RequestOptions, BaseRequestOptions } from '@angular/http';
import { Search } from "../core/domain/search";
import * as wjcCore from 'wijmo/wijmo';
import * as wjNg2Input from 'wijmo/wijmo.angular2.input';
import { WjInputModule } from 'wijmo/wijmo.angular2.input';
import { SignalRService } from './../Notification/signalRService';
import { AppSettings } from '../core/common/appsettings';
declare var $: any;
@Component({
    selector: "taskactivity",
    templateUrl: "app/components/TaskActivity.html?v=" + $.getVersion(),
    providers: [TaskManagerService, MembershipService]
})

export class TaskActivityComponent {
    //  private routes = Routes;

    taskid: any;
    listuser: any;
    newtaskid: any;
    task_username: any;
    user: any;
    lstsubscriber; any;
    totalpeople: any;
    public titlemsg: any;
    public PriorityColor: any;
    private _taskManagement: TaskManagement;
    private _taskComment: TaskComment;
    private _Showmessagediv: boolean = false;

    private _TaskFetching: boolean = false;
    private _ShowmessagedivMsg: string = '';
    lstlookupPriority: any;
    lstlookupTaskType: any;
    public usernameID: any;
    public usernameText: any;
    _ShowmessagedivMsgWar: any;

    lstlookupStatus: any;
    lsttaskcomment: any;
    public lstsubscribuser: any;
    public _dtUTCHours: number;
    public _userOffset: number;
    public _centralOffset: number;
    private _cachedeal = {};
    private _result: any;
    private _searchObj: any;
    public _pageSizeSearch: number = 10;
    public _pageIndexSearch: number = 1;
    public _totalCountSearch: number = 0;
    public _pagePath: any;

    constructor(public taskManagerService: TaskManagerService,
        private route: ActivatedRoute,
        private _router: Router,
        public _signalRService: SignalRService,
        public membershipService: MembershipService,
        public utilityService: UtilityService) {
        this._taskComment = new TaskComment();
        this.route.params.forEach((params: Params) => {
            if (params['id'] !== undefined) {
                this.taskid = params['id'];
                this._taskManagement = new TaskManagement('');

                this.GetAllLookups();
                this.GetTaskByTaskID();
                this.user = JSON.parse(localStorage.getItem('user'));
                var _date = new Date();

                this.utilityService.setPageTitle("M61–Task Details");
                setTimeout(() => {
                    this.getemailnotify();
                     
                }, 10);

                this._dtUTCHours = _date.getTimezoneOffset() / 60; //_date.getUTCHours();
                //alert('date getTimezoneOffset' + _date.getTimezoneOffset() );
                this._userOffset = _date.getTimezoneOffset() * 60 * 1000; // user's offset time

                if (this._dtUTCHours < 6) {
                    this._centralOffset = 6 * 60 * 60 * 1000; // 6 for central time - use whatever you need
                }
                else {
                    this._centralOffset = this._dtUTCHours * 60 * 60 * 1000; // 6 for central time - use whatever you need
                }
            }
        });
    }
    SetTitleMessage(): void {
        if (this.taskid == "00000000-0000-0000-0000-000000000000") {
            this.titlemsg = "Create new task";
        }
        else {
            this.titlemsg = "Edit task"
        }
    }
    GetAllLookups(): void {
        try {
            this.taskManagerService.getAllLookup().subscribe(res => {
                if (res.Succeeded) {
                    var data = res.lstLookups;
                    this.lstlookupPriority = data.filter(x => x.ParentID == "57");
                    this.lstlookupTaskType = data.filter(x => x.ParentID == "58");
                    this.lstlookupStatus = data.filter(x => x.ParentID == "59");
                }
                else {
                    this._router.navigate(['login']);
                }
            });
        } catch (err) {
        }
    }

    DiscardChanges() {
        this._router.navigate(['task']);
    }
    GetTaskByTaskID(): void {
        try {
            this._TaskFetching = true;
            if (localStorage.getItem('divSucessTaskCopy') == 'true') {
                this._Showmessagediv = true;
                this._ShowmessagedivMsg = localStorage.getItem('divSucessMsgTaskCopy');
                this._ShowmessagedivMsg = (this._ShowmessagedivMsg.replace('\"', '')).replace('\"', '');
                localStorage.setItem('divSucessTaskCopy', JSON.stringify(false));
                localStorage.setItem('divSucessMsgTaskCopy', JSON.stringify(''));
                setTimeout(function () {
                    this._Showmessagediv = false;
                    this._TaskFetching = false;
                   
                 
                }.bind(this), 5000);
            }

            this.taskManagerService.getTaskByTaskID(this.taskid).subscribe(res => {
                if (res.Succeeded) {
                    this.GetComments();
                    var data = res.TaskData;
                    this._taskManagement = data;
                    this.task_username = this._taskManagement.AssignedToText;
                    setTimeout(function () {
                        this._TaskFetching = false;
                        this.adjusttextareaheight();
                    }.bind(this), 50);
                }
                else {
                    this._router.navigate(['login']);
                }
            });
        } catch (err) {
        }
    }

    adjusttextareaheight():void {
        var cont = $("#txtdescription");
        cont[0].style.height = "1px";
        cont[0].style.height = (cont[0].scrollHeight + 20) + "px";
    }

    adjustheight(): void {
        var cont = $("#txtdescription");
        cont[0].style.height = "1px";
        cont[0].style.height = (cont[0].scrollHeight + 20) + "px";
    }
    adjustCommentheight(): void {
        var cont = $("#Comments");
        cont[0].style.height = "1px";
        cont[0].style.height = (cont[0].scrollHeight + 20) + "px";
    }
     
    validateandsave(): void
    {
        var errormsg = "";
        if (this._taskManagement.Summary == undefined || this._taskManagement.Summary == "")
        {
            errormsg = "<p>" + "Please enter summary." + "</p>";
        }       

        var CreatedDate = this.convertDatetoGMT(this._taskManagement.CreatedDate);
        var displayDate = this.formatdate(CreatedDate);
        if (this._taskManagement.StartDate != null)
        {
            var inputDate = this.convertDatetoGMT(this._taskManagement.StartDate);            
            if (inputDate.setHours(0, 0, 0, 0) < CreatedDate.setHours(0, 0, 0, 0))
            {
                errormsg = errormsg + "<p>" + "Please enter start date greater than or equal to created date (" + displayDate   + ").</p>";
            }
        }

        if (this._taskManagement.DeadlineDate != null) {
            var inputDate = new Date(this._taskManagement.DeadlineDate);           
            if (inputDate.setHours(0, 0, 0, 0) < CreatedDate.setHours(0, 0, 0, 0)) {
                errormsg = errormsg + "<p>" + "Please enter deadline date greater than or equal to created date (" + displayDate+ ").</p>";
            }
        }
       

        if (errormsg == "") {
            this.InsertUpdateTask();             
        }
        else {
            this.CustomAlert(errormsg);
        }

    }
    InsertUpdateTask(): void {
        try {
            var _module = '';
            if (this._taskManagement.DeadlineDate != null) { this._taskManagement.DeadlineDate = this.convertDatetoGMT(this._taskManagement.DeadlineDate); }
            if (this._taskManagement.StartDate != null) { this._taskManagement.StartDate = this.convertDatetoGMT(this._taskManagement.StartDate); }
            if (this._taskManagement.ActualCompletionDate != null) { this._taskManagement.ActualCompletionDate = this.convertDatetoGMT(this._taskManagement.ActualCompletionDate); }
            if (this._taskManagement.EstimatedCompletionDate != null) { this._taskManagement.EstimatedCompletionDate = this.convertDatetoGMT(this._taskManagement.EstimatedCompletionDate); }

            var Notificationmessage;
            this._taskManagement.TaskID = this.taskid;
            if (this.usernameID != "" && this.usernameID != null) {
                this._taskManagement.AssignedTo = this.usernameID;
                this._taskManagement.AssignedToText = this.usernameText
            }

            if (this._taskManagement.Priority != null || this._taskManagement.Priority != 0) {
                this._taskManagement.PriorityText = this.lstlookupPriority.find(x => x.LookupID == this._taskManagement.Priority).Name
            }
            if (this._taskManagement.Status != null || this._taskManagement.Status != 0) {
                this._taskManagement.StatusText = this.lstlookupStatus.find(x => x.LookupID == this._taskManagement.Status).Name
            }
            if (this._taskManagement.TaskType != null || this._taskManagement.TaskType != 0) {
                this._taskManagement.TaskTypeText = this.lstlookupTaskType.find(x => x.LookupID == this._taskManagement.TaskType).Name
            }

            var _lststrSubscibeduser = '';
            this._taskComment.UpdatedBy = this.user.FirstName + " " + this.user.LastName
            this.taskManagerService.InsertUpdateTask(this._taskManagement).subscribe(res => {
                if (res.Succeeded) {
                    this.newtaskid = res.newtaskID
                    localStorage.setItem('divSucessTask', JSON.stringify(true));
                    localStorage.setItem('divSucessMsgTask', JSON.stringify("The task has been saved."));
                    var username = JSON.parse(localStorage.getItem('user'));
                    Notificationmessage = "Tast " + this._taskManagement.Summary + " edited by " + username.FirstName + " " + username.LastName;
                    // }

                    _module = "Edit Task"

                    for (var i = 0; i < this.lstsubscriber.length; i++) {
                        _lststrSubscibeduser += this.lstsubscriber[i].UserID + ',';
                    }
                        //Notificationmessage  variable 
                        //1 Module Name=Add task/Edit Task
                        //2 Message =Actual message which display for Notification
                        //3 Envirement =local/DEV/QA
                        //4 UserID= List of subscribed user whom to send notification
                   
                    Notificationmessage = _module + '|*|' + Notificationmessage + '|*|' + AppSettings._notificationenvironment + '|*|' + _lststrSubscibeduser;

                    this._signalRService.SendTaskToOthers(this.newtaskid, Notificationmessage);
                    this._router.navigate(['task']);
                }
                else {
                    localStorage.setItem('divWarTask', JSON.stringify(true));
                    localStorage.setItem('divWarMsgTask', JSON.stringify('Error occurred while creating task'));
                    this._router.navigate(['task']);
                }
            });
        } catch (err) {
        }
    }
    showEmailNotify() {
        var modalcopy = document.getElementById('myModelNotifyEmail');
        modalcopy.style.display = "block";
        $.getScript("/js/jsDrag.js");
        this.getemailnotify();
        $.getScript("/js/jsDrag.js");
    }

    getemailnotify() {
        this.listuser = "";
        try {
            this.taskManagerService.getNotifyEmail(this.taskid).subscribe(res => {
                if (res.Succeeded) {
                    this.lstsubscribuser = res.lstSubscribeduser;
                    var data = res.lstSubscribeduser.filter(x => x.SubscriptionStatus == true);
                    this.lstsubscriber = data;
                    if (this.lstsubscriber !== undefined) {
                        this.totalpeople = this.lstsubscriber.length;
                    }
                }
                else {
                    this._router.navigate(['login']);
                }
            });
        } catch (err) {
        }
    }
    SubscribeUser() {
        this.listuser = "";
        for (var i = 0; i < this.lstsubscribuser.length; i++) {
            this.lstsubscribuser[i].TaskID = this.taskid;
        }
        this.taskManagerService.InsertUpdateSubscribeUser(this.lstsubscribuser).subscribe(res => {
            if (res.Succeeded) {
                var data = this.lstsubscribuser.filter(x => x.SubscriptionStatus == true);
                this.lstsubscriber = data;
                if (this.lstsubscriber !== undefined) {
                    this.totalpeople = this.lstsubscriber.length;
                }
                this.ClosePopUp();
            }
        });
    }

    ClosePopUp() {
        var modal = document.getElementById('myModelNotifyEmail');
        modal.style.display = "none";
    }

    convertDatetoGMT(date: Date) {
        if (date != null) {
            date = new Date(date);
            var _userOffset = date.getTimezoneOffset() * 60 * 1000; // user's offset time
            var _centralOffset = this._dtUTCHours * 60 * 60 * 1000; // 6 for central time - use whatever you need
            date = new Date(date.getTime() - this._userOffset + this._centralOffset); // redefine variable
            return date;
        }
        else
            return date;
    }

    formatdate(date)
    {
        var year = date.getFullYear();

        var month = (1 + date.getMonth()).toString();
        month = month.length > 1 ? month : '0' + month;
        var day = date.getDate().toString();
        day = day.length > 1 ? day : '0' + day;

        return month + '/' + day + '/' + year;
    }
    InsertUpdateComment(): void {
        try {
            if (this._taskComment.Comments == null || this._taskComment.Comments == "") {
                this.CustomAlert("Please enter comment.");
            }
            else {
                this._taskComment.TaskID = this.taskid;
                this._taskComment.TaskCommentsID = "00000000-0000-0000-0000-000000000000";
                this._taskComment.TaskSummary = this._taskManagement.Summary;
                this._taskComment.CreatedBy = this.user.FirstName + " " + this.user.LastName
                this.taskManagerService.InsertUpdateTaskComment(this._taskComment).subscribe(res => {
                    if (res.Succeeded) {
                        this.newtaskid = res.newtaskID
                        this.GetComments();
                        this._taskComment.Comments = "";
                        // this._router.navigate(['task']);
                    }
                    else {
                        this._router.navigate(['login']);
                    }
                });
            }
        } catch (err) {
        }
    }

    GetComments(): void {
        try {
            this._taskComment.TaskID = this.taskid;

            var d = new Date();
            var datestring = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate() + " " +
                d.getHours() + ":" + d.getMinutes();
            this._taskComment.Currentdate = datestring;
            this.taskManagerService.GetTCommentsByTaskID(this._taskComment).subscribe(res => {
                if (res.Succeeded) {
                    this.lsttaskcomment = res.lstTaskComment;
                }
                else {
                    this._router.navigate(['login']);
                }
            });
        } catch (err) {
        }
    }

    CopyTask(): void {
        try {
            this._TaskFetching = true;
            if (this._taskManagement.DeadlineDate != null) {
                var dt2 = new Date(this._taskManagement.DeadlineDate);
                var dt1 = new Date(this._taskManagement.CreatedDate);
                var diffindays = Math.floor((Date.UTC(dt2.getFullYear(), dt2.getMonth(), dt2.getDate()) - Date.UTC(dt1.getFullYear(), dt1.getMonth(), dt1.getDate())) / (1000 * 60 * 60 * 24));
                var result = new Date();
                this._taskManagement.DeadlineDate = new Date(result.setDate(result.getDate() + diffindays));
            }

            this._taskManagement.TaskID = "00000000-0000-0000-0000-000000000000";
            this._taskManagement.TaskAutoID = null;
            this._taskManagement.StartDate = null;
            this._taskManagement.EstimatedCompletionDate = null;
            this._taskManagement.ActualCompletionDate = null;
            this._taskManagement.Tag1 = null;
            this._taskManagement.Tag2 = null;
            this._taskManagement.Tag3 = null;
            this.taskManagerService.InsertUpdateTask(this._taskManagement).subscribe(res => {
                if (res.Succeeded) {
                    this._taskManagement = res.TaskData

                    localStorage.setItem('divSucessTaskCopy', JSON.stringify(true));
                    localStorage.setItem('divSucessMsgTaskCopy', JSON.stringify("Task copied successfully and opens for edit."));

                    this.newtaskid = res.newtaskID
                    this._pagePath = 'taskactivity/' + this.newtaskid;
                    this._router.navigate([this._pagePath]);
                }
                else {
                    this._router.navigate(['login']);
                    this.CustomAlert("Error occurred.");
                }
            });
        } catch (err) {
            this._TaskFetching = false;
        }
    }

    EditTask(): void {
        this._pagePath = 'taskdetail/a/' + this.taskid;
        this._router.navigate([this._pagePath]);
    }

    checkDroppedDownChangedUserName(sender: wjNg2Input.WjAutoComplete, args) {
        var ac = sender;
        if (ac.selectedIndex == -1) {
            if (ac.text != this.task_username) {
                this.task_username = null;                    
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


    getAutosuggestusername = this.getAutosuggestusernameFunc.bind(this);
    getAutosuggestusernameFunc(query, max, callback) {
        this._result = null;

        var self = this,
            result = self._cachedeal[query];
        if (result) {
            callback(result);
            return;
        }

        // not in cache, get from server
        var params = { query: query, max: max };
        this._searchObj = new Search(query);

        this.taskManagerService.getAutosuggestSearchUsername(this._searchObj, this._pageIndexSearch, this._pageSizeSearch).subscribe(res => {
            if (res.Succeeded) {
                var data: any = res.lstSearch;
                this._totalCountSearch = res.TotalCount;

                this._result = data;
                //show message for 1 sec. when no record found
                //if (this._result.length == 0)
                //{
                //    this._dvEmptySearchMsg = true;
                //    setTimeout(() => {
                //        this._dvEmptySearchMsg = false;
                //    }, 1000);
                //}
                var _valueType;
                // add 'DisplayName' property to result
                let items = [];
                for (var i = 0; i < this._result.length; i++) {
                    var c = this._result[i];
                    c.DisplayName = c.Valuekey;
                }
                //  this._isSearchDataFetching = false;
                // and return the result
                callback(this._result);
            }
            else {
                this.utilityService.navigateToSignIn();
            }
        });
        error => console.error('Error: ' + error)
    }
}

const routes: Routes = [
    { path: '', component: TaskActivityComponent }]

@NgModule({
    imports: [FormsModule, CommonModule, WjInputModule, RouterModule.forChild(routes)],
    declarations: [TaskActivityComponent]
})

export class TaskActivityModule { }