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
exports.TransactionAuditDetailComponentModule = exports.TransactionAuditDetailComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var utilityService_1 = require("../core/services/utilityService");
var TranscationreconciliationService_1 = require("./../core/services/TranscationreconciliationService");
var router_2 = require("@angular/router");
var wijmo_angular2_core_1 = require("wijmo/wijmo.angular2.core");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_input_1 = require("wijmo/wijmo.angular2.input");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var TransactionAuditDetailComponent = /** @class */ (function () {
    function TransactionAuditDetailComponent(activatedRoute, utilityService, transserv, _router) {
        var _this = this;
        this.activatedRoute = activatedRoute;
        this.utilityService = utilityService;
        this.transserv = transserv;
        this._router = _router;
        this._istranscationFetching = false;
        this.utilityService.setPageTitle("M61-Transaction Audit Details");
        this.activatedRoute.params.forEach(function (params) {
            if (params['batchid'] !== undefined) {
                _this.batchid = params['batchid'];
            }
        });
        this.GettranscationauditByBatchid(this.batchid);
    }
    TransactionAuditDetailComponent.prototype.GettranscationauditByBatchid = function (batchid) {
        var _this = this;
        this._istranscationFetching = true;
        this.transserv.getTranscationAuditDetail(batchid).subscribe(function (res) {
            if (res.Succeeded) {
                _this.lsttranscationaudit = res.dtTestCase;
                //format date
                for (var i = 0; i < _this.lsttranscationaudit.length; i++) {
                    if (_this.lsttranscationaudit[i].DueDate != null) {
                        _this.lsttranscationaudit[i].DueDate = new Date(_this.lsttranscationaudit[i].DueDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                    }
                    if (_this.lsttranscationaudit[i].RemitDate != null) {
                        _this.lsttranscationaudit[i].RemitDate = new Date(_this.lsttranscationaudit[i].RemitDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                    }
                    if (_this.lsttranscationaudit[i].TransactionDate != null) {
                        _this.lsttranscationaudit[i].TransactionDate = new Date(_this.lsttranscationaudit[i].TransactionDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                    }
                }
                _this._istranscationFetching = false;
            }
        });
    };
    TransactionAuditDetailComponent.prototype.BackAuditSummary = function () {
        this._router.navigate(['Transactionaudit']);
    };
    TransactionAuditDetailComponent = __decorate([
        core_1.Component({
            templateUrl: "app/components/TransactionAuditDetail.html?v=" + $.getVersion(),
            providers: [TranscationreconciliationService_1.TranscationreconciliationService]
        }),
        __metadata("design:paramtypes", [router_1.ActivatedRoute,
            utilityService_1.UtilityService,
            TranscationreconciliationService_1.TranscationreconciliationService,
            router_1.Router])
    ], TransactionAuditDetailComponent);
    return TransactionAuditDetailComponent;
}());
exports.TransactionAuditDetailComponent = TransactionAuditDetailComponent;
var routes = [
    { path: '', component: TransactionAuditDetailComponent }
];
var TransactionAuditDetailComponentModule = /** @class */ (function () {
    function TransactionAuditDetailComponentModule() {
    }
    TransactionAuditDetailComponentModule = __decorate([
        core_2.NgModule({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_core_1.WjCoreModule, wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_input_1.WjInputModule, wijmo_angular2_grid_filter_1.WjGridFilterModule],
            declarations: [TransactionAuditDetailComponent]
        })
    ], TransactionAuditDetailComponentModule);
    return TransactionAuditDetailComponentModule;
}());
exports.TransactionAuditDetailComponentModule = TransactionAuditDetailComponentModule;
//# sourceMappingURL=TransactionAuditDetail.component.js.map