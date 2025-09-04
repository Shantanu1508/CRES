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
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var utilityService_1 = require("../core/services/utilityService");
var paginated_1 = require("../core/common/paginated");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var PermissionService_1 = require("../core/services/PermissionService");
var wijmo_angular2_input_1 = require("wijmo/wijmo.angular2.input");
var wijmo_angular2_core_1 = require("wijmo/wijmo.angular2.core");
var AutomationService_1 = require("../core/services/AutomationService");
var wjcGrid = require("wijmo/wijmo.grid");
var AutomationComponent = /** @class */ (function (_super) {
    __extends(AutomationComponent, _super);
    function AutomationComponent(_router, permissionService, utilityService, automationService) {
        var _this = _super.call(this, 50, 1, 0) || this;
        _this._router = _router;
        _this.permissionService = permissionService;
        _this.utilityService = utilityService;
        _this.automationService = automationService;
        _this._isAutomationFetching = false;
        _this._chkSelectAll = false;
        _this._ShowSuccessmessage = false;
        _this._ShowmessagedivMsgWar = '';
        _this.utilityService.setPageTitle("M61–Automation");
        _this.GetAllAutomation();
        return _this;
        //   this.GetAutomationLog();
    }
    AutomationComponent.prototype.ngAfterViewInit = function () {
        var _this = this;
        // commit row changes when scrolling the grid
        if (this.lstAutomation) {
            this.flexAutomationLog.scrollPositionChanged.addHandler(function () {
                var myDiv = $('#flexAutomationLog').find('div[wj-part="root"]');
                if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
                    if (_this.flex.rows.length < _this._totalCount) {
                        _this._pageIndex = _this.pagePlus(1);
                        _this.GetAutomationLog();
                    }
                }
            });
        }
    };
    AutomationComponent.prototype.GetAllAutomation = function () {
        var _this = this;
        this._isAutomationFetching = true;
        this.automationService.getDealListForAutomation().subscribe(function (res) {
            if (res.Succeeded) {
                //      if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                _this._isAutomationFetching = false;
                var data = res.dt;
                if (_this._pageIndex == 1) {
                    _this.lstAutomation = data;
                }
                else {
                    _this.lstAutomation = _this.lstAutomation.concat(data);
                }
                //}
                //else {
                //    localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                //    localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));
                //    this.utilityService.navigateUnauthorize();
                //}
            }
        });
    };
    AutomationComponent.prototype.SelectAll = function () {
        this._chkSelectAll = !this._chkSelectAll;
        for (var i = 0; i < this.flex.rows.length; i++) {
            this.flex.rows[i]._data.Active = this._chkSelectAll;
        }
        this.flex.invalidate();
    };
    AutomationComponent.prototype.Save = function () {
        var _this = this;
        var AutomationDeals = this.lstAutomation.filter(function (x) { return x.Active == true; });
        this.automationService.InsertintoautomationRequests(AutomationDeals).subscribe(function (res) {
            if (res.Succeeded) {
                _this._ShowSuccessmessage = true;
                _this._ShowmessagedivMsgWar = 'Data Saved Successfully.';
                _this.GetAllAutomation();
                setTimeout(function () {
                    this._ShowSuccessmessage = false;
                }.bind(_this), 3000);
            }
        });
    };
    AutomationComponent.prototype.CancelAutomation = function () {
        var _this = this;
        this.automationService.CancelAutomation().subscribe(function (res) {
            if (res.Succeeded) {
                _this._ShowSuccessmessage = true;
                _this._ShowmessagedivMsgWar = 'Automation cancelled Successfully.';
                setTimeout(function () {
                    this._ShowSuccessmessage = false;
                }.bind(_this), 3000);
            }
        });
    };
    AutomationComponent.prototype.GetAutomationLog = function () {
        var _this = this;
        this._isAutomationFetching = true;
        this.automationService.getAutomationLog(this._pageIndex, this._pageSize).subscribe(function (res) {
            _this.lstAutomationLog = res.dt;
            _this._isAutomationFetching = false;
            for (var i = 0; i < _this.lstAutomationLog.length; i++) {
                if (_this.lstAutomationLog[i].SubmittedDate != null) {
                    _this.lstAutomationLog[i].SubmittedDate = new Date(_this.lstAutomationLog[i].SubmittedDate.toString());
                }
            }
        });
    };
    AutomationComponent.prototype.ViewAutomationSubmittedDeals = function (BatchID) {
        var _this = this;
        this._isAutomationFetching = true;
        this.automationService.getDealByBatchIDAutomation(BatchID).subscribe(function (res) {
            if (res.Succeeded) {
                _this.lstAutoDeals = res.dt;
                _this._isAutomationFetching = false;
            }
        });
        var modalAutomation = document.getElementById('myModalAutomation');
        modalAutomation.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    AutomationComponent.prototype.CloseAutomationPopUp = function () {
        var modalCopy = document.getElementById('myModalAutomation');
        modalCopy.style.display = "none";
    };
    AutomationComponent.prototype.DeleteAutomationlog = function () {
        var _this = this;
        //  this.deletedBatchid = BatchID;
        this._isAutomationFetching = true;
        this.automationService.DeleteAutomationlog(this.deletedBatchid).subscribe(function (res) {
            if (res.Succeeded) {
                _this.GetAutomationLog();
                _this._ShowSuccessmessage = true;
                _this._ShowmessagedivMsgWar = 'Automation log deleted Successfully.';
                _this.CloseDeletePopUp();
                setTimeout(function () {
                    this._ShowSuccessmessage = false;
                }.bind(_this), 3000);
                _this._isAutomationFetching = false;
            }
        });
    };
    AutomationComponent.prototype.showDeleteDialog = function (BatchID) {
        this.deletedBatchid = BatchID;
        var modalDelete = document.getElementById('myModalDelete');
        modalDelete.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    AutomationComponent.prototype.CloseDeletePopUp = function () {
        var modal = document.getElementById('myModalDelete');
        modal.style.display = "none";
    };
    AutomationComponent.prototype.DownloadAutomationExcel = function (BatchID) {
        var _this = this;
        this._isAutomationFetching = true;
        //this.automationService.DownloadAutomationExcel(BatchID).subscribe(res => {
        //    if (res.Succeeded) {
        //        this._isAutomationFetching = false;
        //    }
        //})
        //=============================================================
        this.automationService.DownloadAutomationExcel(BatchID)
            .subscribe(function (fileData) {
            _this._isAutomationFetching = false;
            var b = new Blob([fileData]);
            //var url = window.URL.createObjectURL(b);
            //window.open(url);
            var dwldLink = document.createElement("a");
            var url = URL.createObjectURL(b);
            var isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
            if (isSafariBrowser) { //if Safari open in new window to save file with random filename.
                dwldLink.setAttribute("target", "_blank");
            }
            dwldLink.setAttribute("href", url);
            dwldLink.setAttribute("download", 'Automtionlog.xlsx');
            dwldLink.style.visibility = "hidden";
            document.body.appendChild(dwldLink);
            dwldLink.click();
            document.body.removeChild(dwldLink);
            _this._isAutomationFetching = false;
        }, function (error) {
            console.log(error);
            // alert('Something went wrong');
            _this._isAutomationFetching = false;
        });
    };
    __decorate([
        core_1.ViewChild('flex'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], AutomationComponent.prototype, "flex", void 0);
    __decorate([
        core_1.ViewChild('flexAutomationLog'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], AutomationComponent.prototype, "flexAutomationLog", void 0);
    AutomationComponent = __decorate([
        core_1.Component({
            templateUrl: "app/components/Automation.html",
            providers: [AutomationService_1.AutomationService, PermissionService_1.PermissionService]
        }),
        __metadata("design:paramtypes", [router_1.Router,
            PermissionService_1.PermissionService,
            utilityService_1.UtilityService,
            AutomationService_1.AutomationService])
    ], AutomationComponent);
    return AutomationComponent;
}(paginated_1.Paginated));
exports.AutomationComponent = AutomationComponent;
var routes = [
    { path: '', component: AutomationComponent }
];
var AutomationModule = /** @class */ (function () {
    function AutomationModule() {
    }
    AutomationModule = __decorate([
        core_1.NgModule({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule, wijmo_angular2_input_1.WjInputModule, wijmo_angular2_core_1.WjCoreModule],
            declarations: [AutomationComponent]
        })
    ], AutomationModule);
    return AutomationModule;
}());
exports.AutomationModule = AutomationModule;
//# sourceMappingURL=Automation.component.js.map