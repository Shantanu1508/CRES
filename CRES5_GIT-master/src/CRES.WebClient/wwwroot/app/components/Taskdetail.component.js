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
exports.TaskDetailModule = exports.TaskDetailComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var TaskManagement_1 = require("../core/domain/TaskManagement");
var TaskManagerService_1 = require("../core/services/TaskManagerService");
var membershipservice_1 = require("../core/services/membershipservice");
var utilityService_1 = require("../core/services/utilityService");
var fileuploadservice_1 = require("../core/services/fileuploadservice");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var search_1 = require("../core/domain/search");
var wijmo_angular2_input_1 = require("wijmo/wijmo.angular2.input");
var signalRService_1 = require("./../Notification/signalRService");
var appsettings_1 = require("../core/common/appsettings");
var ng2_file_input_1 = require("ng2-file-input");
var TaskDetailComponent = /** @class */ (function () {
    function TaskDetailComponent(taskManagerService, route, _signalRService, _router, membershipService, utilityService, ng2FileInputService, fileUploadService) {
        var _this = this;
        this.taskManagerService = taskManagerService;
        this.route = route;
        this._signalRService = _signalRService;
        this._router = _router;
        this.membershipService = membershipService;
        this.utilityService = utilityService;
        this.ng2FileInputService = ng2FileInputService;
        this.fileUploadService = fileUploadService;
        this.myFileInputIdentifier = "tHiS_Id_IS_sPeeCiAL";
        this.actionLog = "";
        this.errors = [];
        this.dragAreaClass = 'dragarea';
        this.projectId = 0;
        this.sectionId = 0;
        this.fileExt = "JPG, GIF, PNG, TXT";
        this.maxFiles = 5;
        this.maxSize = 5; // 5MB
        this.uploadStatus = new core_1.EventEmitter();
        this._cachedeal = {};
        this._pageSizeSearch = 10;
        this._pageIndexSearch = 1;
        this._totalCountSearch = 0;
        this.getAutosuggestusername = this.getAutosuggestusernameFunc.bind(this);
        var _date = new Date();
        this._dtUTCHours = _date.getTimezoneOffset() / 60; //_date.getUTCHours();
        //alert('date getTimezoneOffset' + _date.getTimezoneOffset() );
        this._userOffset = _date.getTimezoneOffset() * 60 * 1000; // user's offset time
        if (this._dtUTCHours < 6) {
            this._centralOffset = 6 * 60 * 60 * 1000; // 6 for central time - use whatever you need
        }
        else {
            this._centralOffset = this._dtUTCHours * 60 * 60 * 1000; // 6 for central time - use whatever you need
        }
        this.route.params.forEach(function (params) {
            if (params['id'] !== undefined) {
                _this.taskid = params['id'];
                _this._taskManagement = new TaskManagement_1.TaskManagement('');
                _this.GetAllLookups();
                _this.SetTitleMessage();
                if (_this.taskid != "00000000-0000-0000-0000-000000000000") {
                    _this.GetTaskByTaskID();
                }
            }
        });
    }
    TaskDetailComponent.prototype.SetTitleMessage = function () {
        if (this.taskid == "00000000-0000-0000-0000-000000000000") {
            this.titlemsg = "Create new task";
            this._taskManagement.Priority = 366;
            this._taskManagement.Status = 373;
            this.usernameID = "";
            this.usernameText = "";
        }
        else {
            this.titlemsg = "Edit task";
        }
    };
    TaskDetailComponent.prototype.GetAllLookups = function () {
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
    TaskDetailComponent.prototype.convertDatetoGMT = function (date) {
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
    TaskDetailComponent.prototype.validateandsave = function () {
        var errormsg = "";
        if (this._taskManagement.Summary == undefined || this._taskManagement.Summary == "") {
            errormsg = "<p>" + "Please enter summary." + "</p>";
        }
        if (this._taskManagement.TaskType == undefined || this._taskManagement.TaskType == null) {
            errormsg = errormsg + "<p>" + "Please select task type." + "</p>";
        }
        if (this._taskManagement.StartDate != null) {
            var inputDate = new Date(this._taskManagement.StartDate);
            var todaysDate = new Date();
            if (inputDate.setHours(0, 0, 0, 0) < todaysDate.setHours(0, 0, 0, 0)) {
                errormsg = errormsg + "<p>" + "Please enter start date greater than or equal to today." + "</p>";
            }
        }
        if (this._taskManagement.DeadlineDate != null) {
            var inputDate = new Date(this._taskManagement.DeadlineDate);
            var todaysDate = new Date();
            if (inputDate.setHours(0, 0, 0, 0) < todaysDate.setHours(0, 0, 0, 0)) {
                errormsg = errormsg + "<p>" + "Please enter deadline date greater than or equal to today." + "</p>";
            }
        }
        if (this._taskManagement.EstimatedCompletionDate != null) {
            var inputDate = new Date(this._taskManagement.EstimatedCompletionDate);
            var todaysDate = new Date();
            if (inputDate.setHours(0, 0, 0, 0) < todaysDate.setHours(0, 0, 0, 0)) {
                errormsg = errormsg + "<p>" + "Please enter estimated completion date greater than or equal to today." + "</p>";
            }
        }
        if (this._taskManagement.ActualCompletionDate != null) {
            var inputDate = new Date(this._taskManagement.ActualCompletionDate);
            var todaysDate = new Date();
            if (inputDate.setHours(0, 0, 0, 0) < todaysDate.setHours(0, 0, 0, 0)) {
                errormsg = errormsg + "<p>" + "Please enter actual completion date greater than or equal to today." + "</p>";
            }
        }
        if (errormsg == "") {
            this.InsertUpdateTask();
        }
        else {
            this.CustomAlert(errormsg);
        }
    };
    TaskDetailComponent.prototype.InsertUpdateTask = function () {
        var _this = this;
        var _module = '';
        var _env = 'local';
        try {
            this._taskManagement.TaskID = this.taskid;
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
            if (this.usernameID != null) {
                this._taskManagement.AssignedTo = this.usernameID;
                this._taskManagement.AssignedToText = this.usernameText;
            }
            if (Number(this._taskManagement.Priority) != null || Number(this._taskManagement.Priority) != 0) {
                this._taskManagement.PriorityText = this.lstlookupPriority.find(function (x) { return x.LookupID == _this._taskManagement.Priority; }).Name;
            }
            if (Number(this._taskManagement.Status) != null || Number(this._taskManagement.Status) != 0) {
                this._taskManagement.StatusText = this.lstlookupStatus.find(function (x) { return x.LookupID == _this._taskManagement.Status; }).Name;
            }
            if (Number(this._taskManagement.TaskType) != null || Number(this._taskManagement.TaskType) != 0) {
                this._taskManagement.TaskTypeText = this.lstlookupTaskType.find(function (x) { return x.LookupID == _this._taskManagement.TaskType; }).Name;
            }
            this.taskManagerService.InsertUpdateTask(this._taskManagement).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.taskid = res.newtaskID;
                    _this._pagePath = 'taskactivity/' + _this.taskid;
                    _this._router.navigate([_this._pagePath]);
                    var Notificationmessage;
                    var username = JSON.parse(localStorage.getItem('user'));
                    if (_this.taskid = "00000000-0000-0000-0000-000000000000") {
                        Notificationmessage = "New Task added by" + username.FirstName + " " + username.LastName;
                        _module = "Edit Task";
                        //Notificationmessage  variable 
                        //1 Module Name=Add task/Edit Task
                        //2 Message =Actual message which display for Notification.
                        //3 Envirement =local/DEV/QA
                        Notificationmessage = _module + '|*|' + Notificationmessage + '|*|' + appsettings_1.AppSettings._notificationenvironment;
                    }
                    _this._signalRService.SendTaskToOthers(_this.taskid, Notificationmessage);
                    //this.saveFiles();
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
        }
    };
    TaskDetailComponent.prototype.GetTaskByTaskID = function () {
        var _this = this;
        try {
            this.taskManagerService.getTaskByTaskID(this.taskid).subscribe(function (res) {
                if (res.Succeeded) {
                    var data = res.TaskData;
                    _this._taskManagement = data;
                    _this.task_username = _this._taskManagement.AssignedToText;
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
        }
    };
    TaskDetailComponent.prototype.checkDroppedDownChangedUserName = function (sender, args) {
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
    TaskDetailComponent.prototype.DiscardChanges = function () {
        window.history.back();
    };
    TaskDetailComponent.prototype.getAutosuggestusernameFunc = function (query, max, callback) {
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
    TaskDetailComponent.prototype.CustomAlert = function (dialog) {
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
    TaskDetailComponent.prototype.ok = function () {
        document.getElementById('dialogbox').style.display = "none";
        document.getElementById('dialogoverlay').style.display = "none";
    };
    TaskDetailComponent.prototype.onAction = function (event) {
        console.log(event);
        this.actionLog += "\n currentFiles: " + this.getFileNames(event.currentFiles);
        console.log(this.actionLog);
        //let fileList: FileList = event.currentFiles;
        this.fileList = event.currentFiles;
        //this.saveFiles(this.fileList);
    };
    TaskDetailComponent.prototype.onAdded = function (event) {
        this.actionLog += "\n FileInput: " + event.id;
        this.actionLog += "\n Action: File added";
    };
    TaskDetailComponent.prototype.onRemoved = function (event) {
        this.actionLog += "\n FileInput: " + event.id;
        this.actionLog += "\n Action: File removed";
    };
    TaskDetailComponent.prototype.onInvalidDenied = function (event) {
        this.actionLog += "\n FileInput: " + event.id;
        this.actionLog += "\n Action: File denied";
    };
    TaskDetailComponent.prototype.onCouldNotRemove = function (event) {
        this.actionLog += "\n FileInput: " + event.id;
        this.actionLog += "\n Action: Could not remove file";
    };
    TaskDetailComponent.prototype.resetFileInput = function () {
        this.ng2FileInputService.reset(this.myFileInputIdentifier);
    };
    TaskDetailComponent.prototype.logCurrentFiles = function () {
        var files = this.ng2FileInputService.getCurrentFiles(this.myFileInputIdentifier);
        this.actionLog += "\n The currently added files are: " + this.getFileNames(files);
    };
    TaskDetailComponent.prototype.getFileNames = function (files) {
        var names = files.map(function (file) { return file.name; });
        return names ? names.join(", ") : "No files currently added.";
    };
    TaskDetailComponent.prototype.isValidFiles = function (files) {
        // Check Number of files
        if (files.length > this.maxFiles) {
            this.errors.push("Error: At a time you can upload only " + this.maxFiles + " files");
            return;
        }
        this.isValidFileExtension(files);
        return this.errors.length === 0;
    };
    TaskDetailComponent.prototype.isValidFileExtension = function (files) {
        // Make array of file extensions
        var extensions = (this.fileExt.split(','))
            .map(function (x) { return x.toLocaleUpperCase().trim(); });
        for (var i = 0; i < files.length; i++) {
            // Get file extension
            var ext = files[i].name.toUpperCase().split('.').pop() || files[i].name;
            // Check the extension exists
            var exists = extensions.includes(ext);
            if (!exists) {
                this.errors.push("Error (Extension): " + files[i].name);
            }
            // Check file size
            this.isValidFileSize(files[i]);
        }
    };
    TaskDetailComponent.prototype.isValidFileSize = function (file) {
        var fileSizeinMB = file.size / (1024 * 1000);
        var size = Math.round(fileSizeinMB * 100) / 100; // convert upto 2 decimal place
        if (size > this.maxSize)
            this.errors.push("Error (File Size): " + file.name + ": exceed file size limit of " + this.maxSize + "MB ( " + size + "MB )");
    };
    TaskDetailComponent.prototype.saveFiles = function () {
        var _this = this;
        //this.saveFiles(this.fileList);
        //alert('save');
        var files = this.fileList;
        //alert('save123456');
        this.errors = []; // Clear error
        // Validate file size and allowed extensions
        if (files.length > 0 && (!this.isValidFiles(files))) {
            this.uploadStatus.emit(false);
            return;
        }
        if (files.length > 0) {
            var formData = new FormData();
            for (var j = 0; j < files.length; j++) {
                formData.append("file[]", files[j], files[j].name);
            }
            var parameters = {
                projectId: this.projectId,
                sectionId: this.sectionId
            };
            this.fileUploadService.upload(formData, parameters)
                .subscribe(function (success) {
                _this.uploadStatus.emit(true);
                console.log(success);
            }, function (error) {
                _this.uploadStatus.emit(true);
                _this.errors.push(error.ExceptionMessage);
            });
        }
    };
    var _a, _b, _c;
    __decorate([
        (0, core_1.Input)(),
        __metadata("design:type", Number)
    ], TaskDetailComponent.prototype, "projectId", void 0);
    __decorate([
        (0, core_1.Input)(),
        __metadata("design:type", Number)
    ], TaskDetailComponent.prototype, "sectionId", void 0);
    __decorate([
        (0, core_1.Input)(),
        __metadata("design:type", String)
    ], TaskDetailComponent.prototype, "fileExt", void 0);
    __decorate([
        (0, core_1.Input)(),
        __metadata("design:type", Number)
    ], TaskDetailComponent.prototype, "maxFiles", void 0);
    __decorate([
        (0, core_1.Input)(),
        __metadata("design:type", Number)
    ], TaskDetailComponent.prototype, "maxSize", void 0);
    __decorate([
        (0, core_1.Output)(),
        __metadata("design:type", Object)
    ], TaskDetailComponent.prototype, "uploadStatus", void 0);
    TaskDetailComponent = __decorate([
        (0, core_1.Component)({
            selector: "taskdetail",
            templateUrl: "app/components/Taskdetail.html?v=" + $.getVersion(),
            providers: [TaskManagerService_1.TaskManagerService, membershipservice_1.MembershipService, fileuploadservice_1.FileUploadService]
        }),
        __metadata("design:paramtypes", [TaskManagerService_1.TaskManagerService, typeof (_a = typeof router_1.ActivatedRoute !== "undefined" && router_1.ActivatedRoute) === "function" ? _a : Object, signalRService_1.SignalRService, typeof (_b = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _b : Object, membershipservice_1.MembershipService,
            utilityService_1.UtilityService, typeof (_c = typeof ng2_file_input_1.Ng2FileInputService !== "undefined" && ng2_file_input_1.Ng2FileInputService) === "function" ? _c : Object, fileuploadservice_1.FileUploadService])
    ], TaskDetailComponent);
    return TaskDetailComponent;
}());
exports.TaskDetailComponent = TaskDetailComponent;
var routes = [
    { path: '', component: TaskDetailComponent }
];
var TaskDetailModule = /** @class */ (function () {
    function TaskDetailModule() {
    }
    TaskDetailModule = __decorate([
        (0, core_1.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, wijmo_angular2_input_1.WjInputModule, router_2.RouterModule.forChild(routes), ng2_file_input_1.Ng2FileInputModule.forRoot()],
            declarations: [TaskDetailComponent]
        })
    ], TaskDetailModule);
    return TaskDetailModule;
}());
exports.TaskDetailModule = TaskDetailModule;
//# sourceMappingURL=Taskdetail.component.js.map