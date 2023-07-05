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
exports.WorkflowListModule = exports.WorkflowListComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var Workflow_1 = require("../core/domain/Workflow");
var notificationService_1 = require("../core/services/notificationService");
var utilityService_1 = require("../core/services/utilityService");
var paginated_1 = require("../core/common/paginated");
var wjcGridDetail = require("wijmo/wijmo.grid.detail");
var wjcCore = require("wijmo/wijmo");
var wjcGrid = require("wijmo/wijmo.grid");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wijmo_angular2_core_1 = require("wijmo/wijmo.angular2.core");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var wijmo_angular2_grid_detail_1 = require("wijmo/wijmo.angular2.grid.detail");
var wijmo_angular2_input_1 = require("wijmo/wijmo.angular2.input");
var WFService_1 = require("../core/services/WFService");
var dealfunding_1 = require("../core/domain/dealfunding");
var wjNg2Input = require("wijmo/wijmo.angular2.input");
var WorkflowListComponent = /** @class */ (function (_super) {
    __extends(WorkflowListComponent, _super);
    function WorkflowListComponent(WFSrv, utilityService, notificationService, _router) {
        var _this = _super.call(this, 30, 1, 0) || this;
        _this.WFSrv = WFSrv;
        _this.utilityService = utilityService;
        _this.notificationService = notificationService;
        _this._router = _router;
        _this._workflowListFetching = false;
        _this._ShowmessagedivMsgWar = false;
        _this._dvEmptyWFSearchMsg = false;
        _this._Showmessagediv = false;
        _this._ShowmessagedivMsg = '';
        _this._WaringMessage = '';
        _this._isshowDealbutton = false;
        _this._isShowActivityLog = false;
        _this._fundingCache = {};
        _this.lststatus = [];
        _this.detailMode = wjcGridDetail.DetailVisibilityMode[wjcGridDetail.DetailVisibilityMode.ExpandSingle];
        _this._fundings = new wjcCore.CollectionView();
        _this._isChecked = true;
        _this._isshowDealbutton = false;
        _this._workflowObj = new Workflow_1.Workflow(0);
        _this._workflowObj.filterType = 'respective';
        _this.getWorkflow(_this._workflowObj);
        _this.utilityService.setPageTitle("M61–Workflow");
        return _this;
    }
    // Component views are initialized
    WorkflowListComponent.prototype.ngAfterViewInit = function () {
        // commit row changes when scrolling the grid
        var _this = this;
        this.flex.scrollPositionChanged.addHandler(function () {
            var myDiv = $('#flex').find('div[wj-part="root"]');
            if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
                if (_this.flex.rows.length < _this._totalCount) {
                    _this._pageIndex = _this.pagePlus(1);
                    //this._workflowObj.filterType = filterType;
                    _this.getWorkflow(_this._workflowObj);
                }
            }
        });
    };
    WorkflowListComponent.prototype.FetchAllTask = function (valuechecked) {
        //this._isCalcListFetching = true;
        if (valuechecked) {
            this._workflowObj.filterType = 'all';
        }
        else {
            this._workflowObj.filterType = 'respective';
        }
        this.getWorkflow(this._workflowObj);
    };
    WorkflowListComponent.prototype.getWorkflow = function (_workflowObj) {
        var _this = this;
        if (localStorage.getItem('divSucessWorkflow') == 'true') {
            this._Showmessagediv = false;
            this._ShowmessagedivMsg = localStorage.getItem('divSucessMsgDeal');
            this._ShowmessagedivMsg = (this._ShowmessagedivMsg.replace('\"', '')).replace('\"', '');
            localStorage.setItem('divSucessDeal', JSON.stringify(false));
            localStorage.setItem('divSucessMsgDeal', JSON.stringify(''));
            setTimeout(function () {
                this._Showmessagediv = false;
                console.log(this._Showmessagediv);
            }.bind(this), 5000);
        }
        if (localStorage.getItem('divWarningMsgWorkflow') == 'true') {
            this._ShowmessagedivMsgWar = true;
            this._WaringMessage = localStorage.getItem('divWarningMsg');
            this._WaringMessage = (this._WaringMessage.replace('\"', '')).replace('\"', '');
            localStorage.setItem('divWarningMsgWorkflow', JSON.stringify(false));
            localStorage.setItem('divWarningMsg', JSON.stringify(''));
            setTimeout(function () {
                this._ShowmessagedivMsgWar = false;
            }.bind(this), 5000);
        }
        this._workflowListFetching = true;
        //this._workflowObj.filterType = filterType;
        this.WFSrv.getAllWorkflowByFilterType(_workflowObj, this._pageIndex, this._pageSize)
            .subscribe(function (res) {
            if (res.Succeeded) {
                if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                    var data = res.lstWorkflow;
                    _this._totalCount = res.TotalCount;
                    if (_this._pageIndex == 1) {
                        _this.lstworkflow = data;
                        _this.alllstworkflow = _this.lstworkflow;
                        //remove first cell selection
                        //   this.flex.selectionMode = wjcGrid.SelectionMode.None;
                        if (res.TotalCount == 0) {
                            _this._dvEmptyWFSearchMsg = true;
                            _this._workflowListFetching = false;
                        }
                        else {
                            _this._dvEmptyWFSearchMsg = false;
                            //setTimeout(() => {
                            //    this._dvEmptyWFSearchMsg = false;
                            //    this._workflowListFetching = false;
                            //}, 500);
                        }
                        setTimeout(function () {
                            _this.ApplyPermissions(res.UserPermissionList);
                        }, 2000);
                        //format date
                        for (var i = 0; i < _this.lstworkflow.length; i++) {
                            if (_this.lstworkflow[i].Amount < 0) {
                                _this.lstworkflow[i].Deadline = 'N/A';
                            }
                            if (_this.lstworkflow[i].Fundingdate != '0001-01-01T00:00:00') {
                                if (_this.lstworkflow[i].Fundingdate != null) {
                                    _this.lstworkflow[i].Fundingdate = new Date(_this.lstworkflow[i].Fundingdate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                                }
                            }
                            else {
                                _this.lstworkflow[i].Fundingdate = null;
                            }
                            if (_this.lstworkflow[i].Deadline != 'N/A') {
                                if (_this.lstworkflow[i].Deadline != '0001-01-01T00:00:00') {
                                    if (_this.lstworkflow[i].Deadline != null) {
                                        _this.lstworkflow[i].Deadline = new Date(_this.lstworkflow[i].Deadline.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                                    }
                                }
                                else {
                                    _this.lstworkflow[i].Deadline = null;
                                }
                            }
                        }
                    }
                    else {
                        data.forEach(function (obj, i) {
                            //format date
                            if (obj.Fundingdate != '0001-01-01T00:00:00') {
                                if (obj.Fundingdate == null) {
                                    obj.Fundingdate = null;
                                }
                                else {
                                    obj.Fundingdate = new Date(obj.Fundingdate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                                }
                            }
                            else {
                                obj.Fundingdate = null;
                            }
                            if (obj.Deadline != 'N/A') {
                                if (obj.Deadline != '0001-01-01T00:00:00') {
                                    if (obj.Deadline != null) {
                                        obj.Deadline = new Date(obj.Deadline.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                                    }
                                }
                                else {
                                    obj.Deadline = null;
                                }
                            }
                            //this.flex.rows.push(new wjcGrid.Row(obj));
                        });
                        _this.lstworkflow = _this.lstworkflow.concat(data);
                        _this.alllstworkflow = _this.lstworkflow;
                    }
                    _this._workflowListFetching = false;
                    setTimeout(function () {
                        if (!this._dvEmptyWFSearchMsg)
                            this.flex.invalidate();
                        this.getAllWorkflowdetail();
                        //this._initDetailProvider(this.flex);
                        //this.flex.autoSizeColumns(0, this.flex.columns.length, false, 20);
                        //this.flex.columns[0].width = 350; // for Note Id
                    }.bind(_this), 1);
                }
                else {
                    localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                    localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));
                    _this.utilityService.navigateUnauthorize();
                }
                //
            }
            else {
                _this.utilityService.navigateToSignIn();
            }
            if (_this.lstworkflow) {
                _this.onchangedcheckeditems();
                _this.multiselStatus.headerFormat = "3 Status Selected";
            }
            // this.lstworkflow = this.lstworkflow.filter(x => x.StatusName != "Projected" && x.StatusName != "Under Review")
        }, function (error) {
            if (error.status == 401) {
                _this.notificationService.printErrorMessage('Authentication required');
                _this.utilityService.navigateToSignIn();
            }
        });
        this.GetAllWorkflowStatus();
    };
    WorkflowListComponent.prototype.getAllWorkflowdetail = function () {
        var _this = this;
        //alert('fundingID ' + fundingID);
        this._dealFunding = new dealfunding_1.DealFunding('');
        this._dealFunding.DealFundingID = '00000000-0000-0000-0000-000000000000';
        this.WFSrv.getfundingdetailbydealfundingid(this._dealFunding).subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.lstFundingScheduleDetail;
                _this.lstworkflowDetail = data;
            }
            else {
                // no record
            }
        });
    };
    WorkflowListComponent.prototype.getWorkflowdetailByFundingID = function (fundingID) {
        return this.lstworkflowDetail.filter(function (x) { return x.DealFundingID.toLowerCase() == fundingID.toLowerCase(); });
    };
    WorkflowListComponent.prototype.ApplyPermissions = function (_object) {
        //var buttonarray = _object.filter(function (item) { return item.ModuleType === 'Control' && item.RightsName === 'Edit'; });
        //if (buttonarray.length > 0 && typeof buttonarray != 'undefined') {
        //    this._isshowDealbutton = true;
        //}
        //this._isShowActivityLog = true;
    };
    WorkflowListComponent.prototype.clickeddeal = function (url) {
        this._workflowListFetching = true;
    };
    WorkflowListComponent.prototype.GetAllWorkflowStatus = function () {
        var _this = this;
        if (this.lststatus) {
            if (this.lststatus.length == 0) {
                this.WFSrv.getWorkflowStatus().subscribe(function (res) {
                    if (res.Succeeded) {
                        var data = res.dt;
                        data.find(function (x) { return x.StatusName == "Under Review"; }).StatusName = "Under Review/Requested";
                        var lststatusName = data.map(function (x) { return x.StatusName; });
                        for (var j = 0; j < lststatusName.length; j++) {
                            if (lststatusName[j] != "Projected" && lststatusName[j] != "Completed") {
                                _this.lststatus.push({ "StatusName": lststatusName[j], selected: lststatusName[j] });
                            }
                            else {
                                _this.lststatus.push({ "StatusName": lststatusName[j], selected: undefined });
                            }
                        }
                        _this.multiselStatus.showDropDownButton = true;
                        _this.multiselStatus.headerFormat = "3 Status Selected";
                        // this.lststatus = res.dt;
                    }
                });
            }
        }
    };
    WorkflowListComponent.prototype.onchangedcheckeditems = function () {
        // if (s.checkedItems.length > 0) {
        var checked = this.multiselStatus.checkedItems;
        var lstchecked = checked.map(function (x) { return x.StatusName; });
        for (var i = 0; i < lstchecked.length; i++) {
            if (lstchecked[i] == 'Under Review/Requested') {
                var wfstatus = lstchecked[i].split("/");
                for (var k = 0; k < wfstatus.length; k++) {
                    lstchecked.push(wfstatus[k]);
                }
                //  lstchecked.splice(lstchecked[i], 1);
                var index = lstchecked.indexOf(lstchecked[i]);
                if (index !== -1) {
                    lstchecked.splice(index, 1);
                }
            }
        }
        if (this.multiselStatus.checkedItems.length > 2)
            this.multiselStatus.headerFormat = this.multiselStatus.checkedItems.length + " Status Selected";
        this.lstworkflow = this.alllstworkflow.filter(function (itm) {
            return lstchecked.indexOf(itm.StatusName) > -1;
        });
        var lstpayoff = this.alllstworkflow.filter(function (x) { return x.PurposeID == 316; });
        if (lstpayoff) {
            for (var i = 0; i < lstpayoff.length; i++) {
                this.lstworkflow.push(lstpayoff[i]);
            }
        }
        //   }
    };
    __decorate([
        core_1.ViewChild('multiselStatus'),
        __metadata("design:type", wjNg2Input.WjMultiSelect)
    ], WorkflowListComponent.prototype, "multiselStatus", void 0);
    __decorate([
        core_1.ViewChild('flex'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], WorkflowListComponent.prototype, "flex", void 0);
    WorkflowListComponent = __decorate([
        core_1.Component({
            selector: "workflow",
            templateUrl: "app/components/workflow.html?v=" + $.getVersion(),
            providers: [WFService_1.WFService, notificationService_1.NotificationService]
        }),
        __metadata("design:paramtypes", [WFService_1.WFService,
            utilityService_1.UtilityService,
            notificationService_1.NotificationService,
            router_1.Router])
    ], WorkflowListComponent);
    return WorkflowListComponent;
}(paginated_1.Paginated));
exports.WorkflowListComponent = WorkflowListComponent;
var routes = [
    { path: '', component: WorkflowListComponent }
];
var WorkflowListModule = /** @class */ (function () {
    function WorkflowListModule() {
    }
    WorkflowListModule = __decorate([
        core_1.NgModule({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_core_1.WjCoreModule, wijmo_angular2_input_1.WjInputModule, wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule, wijmo_angular2_grid_detail_1.WjGridDetailModule],
            declarations: [WorkflowListComponent]
        })
    ], WorkflowListModule);
    return WorkflowListModule;
}());
exports.WorkflowListModule = WorkflowListModule;
//# sourceMappingURL=Workflow.component.js.map