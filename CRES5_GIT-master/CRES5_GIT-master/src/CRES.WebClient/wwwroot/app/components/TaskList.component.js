"use strict";
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
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
exports.TaskListModule = exports.TaskListComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var TaskManagement_1 = require("../core/domain/TaskManagement");
var taskManagerService_1 = require("../core/services/taskManagerService");
var notificationService_1 = require("../core/services/notificationService");
var core_2 = require("@angular/core");
var utilityService_1 = require("../core/services/utilityService");
var paginated_1 = require("../core/common/paginated");
var wjcGrid = require("wijmo/wijmo.grid");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wijmo_angular2_core_1 = require("wijmo/wijmo.angular2.core");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var TaskListComponent = /** @class */ (function (_super) {
    __extends(TaskListComponent, _super);
    function TaskListComponent(TaskSrv, utilityService, notificationService, _router) {
        var _this = _super.call(this, 30, 1, 0) || this;
        _this.TaskSrv = TaskSrv;
        _this.utilityService = utilityService;
        _this.notificationService = notificationService;
        _this._router = _router;
        _this.chkeddisplay = false;
        _this._Showmessagediv = false;
        _this._ShowmessagedivMsg = '';
        _this._TaskListFetching = false;
        _this._taskManagement = new TaskManagement_1.TaskManagement('');
        //get all records except closed send 1
        _this.GetTaskList(1);
        _this.utilityService.setPageTitle("M61-Task List");
        return _this;
    }
    // Component views are initialized
    TaskListComponent.prototype.ngAfterViewInit = function () {
        // commit row changes when scrolling the grid
        var _this = this;
        this.flex.scrollPositionChanged.addHandler(function () {
            var myDiv = $('#flex').find('div[wj-part="root"]');
            if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
                if (_this.flex.rows.length < _this._totalCount) {
                    _this._pageIndex = _this.pagePlus(1);
                    if (_this.chkeddisplay == true) {
                        //show closed
                        _this.GetTaskList(0);
                    }
                    else {
                        //hide close
                        _this.GetTaskList(1);
                    }
                }
            }
        });
    };
    TaskListComponent.prototype.GetTaskList = function (all) {
        var _this = this;
        if (localStorage.getItem('divSucessTask') == 'true') {
            this._Showmessagediv = true;
            this._ShowmessagedivMsg = localStorage.getItem('divSucessMsgTask');
            this._ShowmessagedivMsg = (this._ShowmessagedivMsg.replace('\"', '')).replace('\"', '');
            localStorage.setItem('divSucessTask', JSON.stringify(false));
            localStorage.setItem('divSucessMsgTask', JSON.stringify(''));
            setTimeout(function () {
                this._Showmessagediv = false;
            }.bind(this), 5000);
        }
        this._TaskListFetching = true;
        this._taskManagement.Status = all;
        this.TaskSrv.getAllTask(this._taskManagement, this._pageIndex, this._pageSize)
            .subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.lstTask;
                _this._totalCount = res.TotalCount;
                if (_this._pageIndex == 1) {
                    _this.lstTask = data;
                    //remove first cell selection
                    _this.flex.selectionMode = wjcGrid.SelectionMode.None;
                }
                else {
                    data.forEach(function (obj, i) {
                        //format date
                        //this.flex.rows.push(new wjcGrid.Row(obj));
                    });
                    _this.lstTask = _this.lstTask.concat(data);
                }
                for (var i = 0; i < _this.lstTask.length; i++) {
                    if (_this.lstTask[i].StartDate != '0001-01-01T00:00:00') {
                        if (_this.lstTask[i].StartDate == null) {
                            _this.lstTask[i].StartDate = null;
                        }
                        else {
                            _this.lstTask[i].StartDate = new Date(_this.lstTask[i].StartDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                        }
                    }
                    else {
                        _this.lstTask[i].StartDate = null;
                    }
                    if (_this.lstTask[i].DeadlineDate != '0001-01-01T00:00:00') {
                        if (_this.lstTask[i].DeadlineDate == null) {
                            _this.lstTask[i].DeadlineDate = null;
                        }
                        else {
                            _this.lstTask[i].DeadlineDate = new Date(_this.lstTask[i].DeadlineDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                        }
                    }
                    else {
                        _this.lstTask[i].DeadlineDate = null;
                    }
                    if (_this.lstTask[i].EstimatedCompletionDate != '0001-01-01T00:00:00') {
                        if (_this.lstTask[i].EstimatedCompletionDate == null) {
                            _this.lstTask[i].EstimatedCompletionDate = null;
                        }
                        else {
                            _this.lstTask[i].EstimatedCompletionDate = new Date(_this.lstTask[i].EstimatedCompletionDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                        }
                    }
                    else {
                        _this.lstTask[i].EstimatedCompletionDate = null;
                    }
                    if (_this.lstTask[i].ActualCompletionDate != '0001-01-01T00:00:00') {
                        if (_this.lstTask[i].ActualCompletionDate == null) {
                            _this.lstTask[i].ActualCompletionDate = null;
                        }
                        else {
                            _this.lstTask[i].ActualCompletionDate = new Date(_this.lstTask[i].ActualCompletionDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                        }
                    }
                    else {
                        _this.lstTask[i].ActualCompletionDate = null;
                    }
                }
                setTimeout(function () {
                    this.flex.invalidate();
                    this.flex.autoSizeColumns(0, this.flex.columns.length, false, 20);
                    this.flex.columns[4].width = 300;
                    this.flex.columns[5].width = 300; // for Note Id
                }.bind(_this), 1);
                setTimeout(function () {
                    _this._TaskListFetching = false;
                }, 2000);
            }
            else {
                _this.utilityService.navigateToSignIn();
            }
        }, function (error) {
            if (error.status == 401) {
                _this.notificationService.printErrorMessage('Authentication required');
                _this.utilityService.navigateToSignIn();
            }
        });
    };
    TaskListComponent.prototype.AddNewTask = function () {
        this._router.navigate(['taskdetail/a', '00000000-0000-0000-0000-000000000000']);
    };
    TaskListComponent.prototype.Getclosedrecords = function () {
        if (this.chkeddisplay == true) {
            //hide close
            this.chkeddisplay = false;
            this.GetTaskList(1);
        }
        else {
            //show closed
            this.chkeddisplay = true;
            this.GetTaskList(0);
        }
    };
    __decorate([
        core_1.ViewChild('flex'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], TaskListComponent.prototype, "flex", void 0);
    TaskListComponent = __decorate([
        core_1.Component({
            selector: "deal",
            templateUrl: "app/components/tasklist.html",
            providers: [taskManagerService_1.TaskManagerService, notificationService_1.NotificationService]
        }),
        __metadata("design:paramtypes", [taskManagerService_1.TaskManagerService,
            utilityService_1.UtilityService,
            notificationService_1.NotificationService,
            router_1.Router])
    ], TaskListComponent);
    return TaskListComponent;
}(paginated_1.Paginated));
exports.TaskListComponent = TaskListComponent;
var routes = [
    { path: '', component: TaskListComponent }
];
var TaskListModule = /** @class */ (function () {
    function TaskListModule() {
    }
    TaskListModule = __decorate([
        core_2.NgModule({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_core_1.WjCoreModule, wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule],
            declarations: [TaskListComponent]
        })
    ], TaskListModule);
    return TaskListModule;
}());
exports.TaskListModule = TaskListModule;
//# sourceMappingURL=TaskList.component.js.map