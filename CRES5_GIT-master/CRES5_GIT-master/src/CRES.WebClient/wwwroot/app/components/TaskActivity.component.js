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
exports.TaskActivityModule = exports.TaskActivityComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var TaskManagement_1 = require("../core/domain/TaskManagement");
var TaskManagerService_1 = require("../core/services/TaskManagerService");
var membershipservice_1 = require("../core/services/membershipservice");
var utilityService_1 = require("../core/services/utilityService");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var search_1 = require("../core/domain/search");
var wijmo_angular2_input_1 = require("wijmo/wijmo.angular2.input");
var signalRService_1 = require("./../Notification/signalRService");
var appsettings_1 = require("../core/common/appsettings");
var TaskActivityComponent = /** @class */ (function () {
    function TaskActivityComponent(taskManagerService, route, _router, _signalRService, membershipService, utilityService) {
        var _this = this;
        this.taskManagerService = taskManagerService;
        this.route = route;
        this._router = _router;
        this._signalRService = _signalRService;
        this.membershipService = membershipService;
        this.utilityService = utilityService;
        this._Showmessagediv = false;
        this._TaskFetching = false;
        this._ShowmessagedivMsg = '';
        this._cachedeal = {};
        this._pageSizeSearch = 10;
        this._pageIndexSearch = 1;
        this._totalCountSearch = 0;
        this.getAutosuggestusername = this.getAutosuggestusernameFunc.bind(this);
        this._taskComment = new TaskManagement_1.TaskComment();
        this.route.params.forEach(function (params) {
            if (params['id'] !== undefined) {
                _this.taskid = params['id'];
                _this._taskManagement = new TaskManagement_1.TaskManagement('');
                _this.GetAllLookups();
                _this.GetTaskByTaskID();
                _this.user = JSON.parse(localStorage.getItem('user'));
                var _date = new Date();
                _this.utilityService.setPageTitle("M61–Task Details");
                setTimeout(function () {
                    _this.getemailnotify();
                }, 10);
                _this._dtUTCHours = _date.getTimezoneOffset() / 60; //_date.getUTCHours();
                //alert('date getTimezoneOffset' + _date.getTimezoneOffset() );
                _this._userOffset = _date.getTimezoneOffset() * 60 * 1000; // user's offset time
                if (_this._dtUTCHours < 6) {
                    _this._centralOffset = 6 * 60 * 60 * 1000; // 6 for central time - use whatever you need
                }
                else {
                    _this._centralOffset = _this._dtUTCHours * 60 * 60 * 1000; // 6 for central time - use whatever you need
                }
            }
        });
    }
    TaskActivityComponent.prototype.SetTitleMessage = function () {
        if (this.taskid == "00000000-0000-0000-0000-000000000000") {
            this.titlemsg = "Create new task";
        }
        else {
            this.titlemsg = "Edit task";
        }
    };
    TaskActivityComponent.prototype.GetAllLookups = function () {
        var _this = this;
        try {
            this.taskManagerService.getAllLookup().subscribe(function (res) {
                if (res.Succeeded) {
                    var data = res.lstLookups;
                    _this.lstlookupPriority = data.filter(function (x) { return x.ParentID == "57"; });
                    _this.lstlookupTaskType = data.filter(function (x) { return x.ParentID == "58"; });
                    _this.lstlookupStatus = data.filter(function (x) { return x.ParentID == "59"; });
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
        }
    };
    TaskActivityComponent.prototype.DiscardChanges = function () {
        this._router.navigate(['task']);
    };
    TaskActivityComponent.prototype.GetTaskByTaskID = function () {
        var _this = this;
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
            this.taskManagerService.getTaskByTaskID(this.taskid).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.GetComments();
                    var data = res.TaskData;
                    _this._taskManagement = data;
                    _this.task_username = _this._taskManagement.AssignedToText;
                    setTimeout(function () {
                        this._TaskFetching = false;
                        this.adjusttextareaheight();
                    }.bind(_this), 50);
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
        }
    };
    TaskActivityComponent.prototype.adjusttextareaheight = function () {
        var cont = $("#txtdescription");
        cont[0].style.height = "1px";
        cont[0].style.height = (cont[0].scrollHeight + 20) + "px";
    };
    TaskActivityComponent.prototype.adjustheight = function () {
        var cont = $("#txtdescription");
        cont[0].style.height = "1px";
        cont[0].style.height = (cont[0].scrollHeight + 20) + "px";
    };
    TaskActivityComponent.prototype.adjustCommentheight = function () {
        var cont = $("#Comments");
        cont[0].style.height = "1px";
        cont[0].style.height = (cont[0].scrollHeight + 20) + "px";
    };
    TaskActivityComponent.prototype.validateandsave = function () {
        var errormsg = "";
        if (this._taskManagement.Summary == undefined || this._taskManagement.Summary == "") {
            errormsg = "<p>" + "Please enter summary." + "</p>";
        }
        var CreatedDate = this.convertDatetoGMT(this._taskManagement.CreatedDate);
        var displayDate = this.formatdate(CreatedDate);
        if (this._taskManagement.StartDate != null) {
            var inputDate = this.convertDatetoGMT(this._taskManagement.StartDate);
            if (inputDate.setHours(0, 0, 0, 0) < CreatedDate.setHours(0, 0, 0, 0)) {
                errormsg = errormsg + "<p>" + "Please enter start date greater than or equal to created date (" + displayDate + ").</p>";
            }
        }
        if (this._taskManagement.DeadlineDate != null) {
            var inputDate = new Date(this._taskManagement.DeadlineDate);
            if (inputDate.setHours(0, 0, 0, 0) < CreatedDate.setHours(0, 0, 0, 0)) {
                errormsg = errormsg + "<p>" + "Please enter deadline date greater than or equal to created date (" + displayDate + ").</p>";
            }
        }
        if (errormsg == "") {
            this.InsertUpdateTask();
        }
        else {
            this.CustomAlert(errormsg);
        }
    };
    TaskActivityComponent.prototype.InsertUpdateTask = function () {
        var _this = this;
        try {
            var _module = '';
            if (this._taskManagement.DeadlineDate != null) {
                this._taskManagement.DeadlineDate = this.convertDatetoGMT(this._taskManagement.DeadlineDate);
            }
            if (this._taskManagement.StartDate != null) {
                this._taskManagement.StartDate = this.convertDatetoGMT(this._taskManagement.StartDate);
            }
            if (this._taskManagement.ActualCompletionDate != null) {
                this._taskManagement.ActualCompletionDate = this.convertDatetoGMT(this._taskManagement.ActualCompletionDate);
            }
            if (this._taskManagement.EstimatedCompletionDate != null) {
                this._taskManagement.EstimatedCompletionDate = this.convertDatetoGMT(this._taskManagement.EstimatedCompletionDate);
            }
            var Notificationmessage;
            this._taskManagement.TaskID = this.taskid;
            if (this.usernameID != "" && this.usernameID != null) {
                this._taskManagement.AssignedTo = this.usernameID;
                this._taskManagement.AssignedToText = this.usernameText;
            }
            if (this._taskManagement.Priority != null || this._taskManagement.Priority != 0) {
                this._taskManagement.PriorityText = this.lstlookupPriority.find(function (x) { return x.LookupID == _this._taskManagement.Priority; }).Name;
            }
            if (this._taskManagement.Status != null || this._taskManagement.Status != 0) {
                this._taskManagement.StatusText = this.lstlookupStatus.find(function (x) { return x.LookupID == _this._taskManagement.Status; }).Name;
            }
            if (this._taskManagement.TaskType != null || this._taskManagement.TaskType != 0) {
                this._taskManagement.TaskTypeText = this.lstlookupTaskType.find(function (x) { return x.LookupID == _this._taskManagement.TaskType; }).Name;
            }
            var _lststrSubscibeduser = '';
            this._taskComment.UpdatedBy = this.user.FirstName + " " + this.user.LastName;
            this.taskManagerService.InsertUpdateTask(this._taskManagement).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.newtaskid = res.newtaskID;
                    localStorage.setItem('divSucessTask', JSON.stringify(true));
                    localStorage.setItem('divSucessMsgTask', JSON.stringify("The task has been saved."));
                    var username = JSON.parse(localStorage.getItem('user'));
                    Notificationmessage = "Tast " + _this._taskManagement.Summary + " edited by " + username.FirstName + " " + username.LastName;
                    // }
                    _module = "Edit Task";
                    for (var i = 0; i < _this.lstsubscriber.length; i++) {
                        _lststrSubscibeduser += _this.lstsubscriber[i].UserID + ',';
                    }
                    //Notificationmessage  variable 
                    //1 Module Name=Add task/Edit Task
                    //2 Message =Actual message which display for Notification
                    //3 Envirement =local/DEV/QA
                    //4 UserID= List of subscribed user whom to send notification
                    Notificationmessage = _module + '|*|' + Notificationmessage + '|*|' + appsettings_1.AppSettings._notificationenvironment + '|*|' + _lststrSubscibeduser;
                    _this._signalRService.SendTaskToOthers(_this.newtaskid, Notificationmessage);
                    _this._router.navigate(['task']);
                }
                else {
                    localStorage.setItem('divWarTask', JSON.stringify(true));
                    localStorage.setItem('divWarMsgTask', JSON.stringify('Error occurred while creating task'));
                    _this._router.navigate(['task']);
                }
            });
        }
        catch (err) {
        }
    };
    TaskActivityComponent.prototype.showEmailNotify = function () {
        var modalcopy = document.getElementById('myModelNotifyEmail');
        modalcopy.style.display = "block";
        $.getScript("/js/jsDrag.js");
        this.getemailnotify();
        $.getScript("/js/jsDrag.js");
    };
    TaskActivityComponent.prototype.getemailnotify = function () {
        var _this = this;
        this.listuser = "";
        try {
            this.taskManagerService.getNotifyEmail(this.taskid).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.lstsubscribuser = res.lstSubscribeduser;
                    var data = res.lstSubscribeduser.filter(function (x) { return x.SubscriptionStatus == true; });
                    _this.lstsubscriber = data;
                    if (_this.lstsubscriber !== undefined) {
                        _this.totalpeople = _this.lstsubscriber.length;
                    }
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
        }
    };
    TaskActivityComponent.prototype.SubscribeUser = function () {
        var _this = this;
        this.listuser = "";
        for (var i = 0; i < this.lstsubscribuser.length; i++) {
            this.lstsubscribuser[i].TaskID = this.taskid;
        }
        this.taskManagerService.InsertUpdateSubscribeUser(this.lstsubscribuser).subscribe(function (res) {
            if (res.Succeeded) {
                var data = _this.lstsubscribuser.filter(function (x) { return x.SubscriptionStatus == true; });
                _this.lstsubscriber = data;
                if (_this.lstsubscriber !== undefined) {
                    _this.totalpeople = _this.lstsubscriber.length;
                }
                _this.ClosePopUp();
            }
        });
    };
    TaskActivityComponent.prototype.ClosePopUp = function () {
        var modal = document.getElementById('myModelNotifyEmail');
        modal.style.display = "none";
    };
    TaskActivityComponent.prototype.convertDatetoGMT = function (date) {
        if (date != null) {
            date = new Date(date);
            var _userOffset = date.getTimezoneOffset() * 60 * 1000; // user's offset time
            var _centralOffset = this._dtUTCHours * 60 * 60 * 1000; // 6 for central time - use whatever you need
            date = new Date(date.getTime() - this._userOffset + this._centralOffset); // redefine variable
            return date;
        }
        else
            return date;
    };
    TaskActivityComponent.prototype.formatdate = function (date) {
        var year = date.getFullYear();
        var month = (1 + date.getMonth()).toString();
        month = month.length > 1 ? month : '0' + month;
        var day = date.getDate().toString();
        day = day.length > 1 ? day : '0' + day;
        return month + '/' + day + '/' + year;
    };
    TaskActivityComponent.prototype.InsertUpdateComment = function () {
        var _this = this;
        try {
            if (this._taskComment.Comments == null || this._taskComment.Comments == "") {
                this.CustomAlert("Please enter comment.");
            }
            else {
                this._taskComment.TaskID = this.taskid;
                this._taskComment.TaskCommentsID = "00000000-0000-0000-0000-000000000000";
                this._taskComment.TaskSummary = this._taskManagement.Summary;
                this._taskComment.CreatedBy = this.user.FirstName + " " + this.user.LastName;
                this.taskManagerService.InsertUpdateTaskComment(this._taskComment).subscribe(function (res) {
                    if (res.Succeeded) {
                        _this.newtaskid = res.newtaskID;
                        _this.GetComments();
                        _this._taskComment.Comments = "";
                        // this._router.navigate(['task']);
                    }
                    else {
                        _this._router.navigate(['login']);
                    }
                });
            }
        }
        catch (err) {
        }
    };
    TaskActivityComponent.prototype.GetComments = function () {
        var _this = this;
        try {
            this._taskComment.TaskID = this.taskid;
            var d = new Date();
            var datestring = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate() + " " +
                d.getHours() + ":" + d.getMinutes();
            this._taskComment.Currentdate = datestring;
            this.taskManagerService.GetTCommentsByTaskID(this._taskComment).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.lsttaskcomment = res.lstTaskComment;
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
        }
    };
    TaskActivityComponent.prototype.CopyTask = function () {
        var _this = this;
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
            this.taskManagerService.InsertUpdateTask(this._taskManagement).subscribe(function (res) {
                if (res.Succeeded) {
                    _this._taskManagement = res.TaskData;
                    localStorage.setItem('divSucessTaskCopy', JSON.stringify(true));
                    localStorage.setItem('divSucessMsgTaskCopy', JSON.stringify("Task copied successfully and opens for edit."));
                    _this.newtaskid = res.newtaskID;
                    _this._pagePath = 'taskactivity/' + _this.newtaskid;
                    _this._router.navigate([_this._pagePath]);
                }
                else {
                    _this._router.navigate(['login']);
                    _this.CustomAlert("Error occurred.");
                }
            });
        }
        catch (err) {
            this._TaskFetching = false;
        }
    };
    TaskActivityComponent.prototype.EditTask = function () {
        this._pagePath = 'taskdetail/a/' + this.taskid;
        this._router.navigate([this._pagePath]);
    };
    TaskActivityComponent.prototype.checkDroppedDownChangedUserName = function (sender, args) {
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
    };
    TaskActivityComponent.prototype.CustomAlert = function (dialog) {
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
    TaskActivityComponent.prototype.ok = function () {
        document.getElementById('dialogbox').style.display = "none";
        document.getElementById('dialogoverlay').style.display = "none";
    };
    TaskActivityComponent.prototype.getAutosuggestusernameFunc = function (query, max, callback) {
        var _this = this;
        this._result = null;
        var self = this, result = self._cachedeal[query];
        if (result) {
            callback(result);
            return;
        }
        // not in cache, get from server
        var params = { query: query, max: max };
        this._searchObj = new search_1.Search(query);
        this.taskManagerService.getAutosuggestSearchUsername(this._searchObj, this._pageIndexSearch, this._pageSizeSearch).subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.lstSearch;
                _this._totalCountSearch = res.TotalCount;
                _this._result = data;
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
                var items = [];
                for (var i = 0; i < _this._result.length; i++) {
                    var c = _this._result[i];
                    c.DisplayName = c.Valuekey;
                }
                //  this._isSearchDataFetching = false;
                // and return the result
                callback(_this._result);
            }
            else {
                _this.utilityService.navigateToSignIn();
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    var _a, _b;
    TaskActivityComponent = __decorate([
        (0, core_1.Component)({
            selector: "taskactivity",
            templateUrl: "app/components/TaskActivity.html?v=" + $.getVersion(),
            providers: [TaskManagerService_1.TaskManagerService, membershipservice_1.MembershipService]
        }),
        __metadata("design:paramtypes", [TaskManagerService_1.TaskManagerService, typeof (_a = typeof router_1.ActivatedRoute !== "undefined" && router_1.ActivatedRoute) === "function" ? _a : Object, typeof (_b = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _b : Object, signalRService_1.SignalRService,
            membershipservice_1.MembershipService,
            utilityService_1.UtilityService])
    ], TaskActivityComponent);
    return TaskActivityComponent;
}());
exports.TaskActivityComponent = TaskActivityComponent;
var routes = [
    { path: '', component: TaskActivityComponent }
];
var TaskActivityModule = /** @class */ (function () {
    function TaskActivityModule() {
    }
    TaskActivityModule = __decorate([
        (0, core_1.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, wijmo_angular2_input_1.WjInputModule, router_2.RouterModule.forChild(routes)],
            declarations: [TaskActivityComponent]
        })
    ], TaskActivityModule);
    return TaskActivityModule;
}());
exports.TaskActivityModule = TaskActivityModule;
//# sourceMappingURL=TaskActivity.component.js.map