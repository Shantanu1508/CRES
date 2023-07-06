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
exports.TransactionAuditComponentModule = exports.TransactionAuditComponent = void 0;
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
var fileuploadservice_1 = require("../core/services/fileuploadservice");
var TransactionAuditComponent = /** @class */ (function () {
    function TransactionAuditComponent(utilityService, transserv, fileUploadService, _router) {
        this.utilityService = utilityService;
        this.transserv = transserv;
        this.fileUploadService = fileUploadService;
        this._router = _router;
        this._isShowLoader = false;
        this._ShowdivMsgWar = false;
        this._Warningmsg = '';
        this.utilityService.setPageTitle("M61-Transaction Audit");
        this.GetAlltranscationaudit();
    }
    TransactionAuditComponent.prototype.GetAlltranscationaudit = function () {
        var _this = this;
        this.transserv.getalltranscationaudit().subscribe(function (res) {
            if (res.Succeeded) {
                _this.lsttranscationaudit = res.lstTransactionAudit;
                if (_this.lsttranscationaudit) {
                    _this._isShowLoader = false;
                    for (var i = 0; i < _this.lsttranscationaudit.length; i++) {
                        if (_this.lsttranscationaudit[i].UploadedDate != null) {
                            _this.lsttranscationaudit[i].UploadedDate = new Date(_this.lsttranscationaudit[i].UploadedDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric" });
                        }
                    }
                }
            }
        });
    };
    TransactionAuditComponent.prototype.DownloadDocument = function (filename, originalfilename, storagetype, documentStorageID) {
        var _this = this;
        this._isShowLoader = true;
        documentStorageID = documentStorageID === undefined ? '' : documentStorageID;
        var ID = '';
        if (storagetype == 'Box')
            ID = documentStorageID;
        else if (storagetype == 'AzureBlob')
            ID = filename;
        this.fileUploadService.downloadObjectDocumentByStorageType(ID, storagetype)
            .subscribe(function (fileData) {
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
            dwldLink.setAttribute("download", originalfilename);
            dwldLink.style.visibility = "hidden";
            document.body.appendChild(dwldLink);
            dwldLink.click();
            document.body.removeChild(dwldLink);
            _this._isShowLoader = false;
        }, function (error) {
            //  alert('Something went wrong');
            _this._isShowLoader = false;
            ;
        });
    };
    TransactionAuditComponent.prototype.DeleteAuditRecords = function (BatchLogID) {
        var _this = this;
        this._isShowLoader = true;
        this.transserv.DeleteAuditbyBatchlogId(BatchLogID).subscribe(function (res) {
            if (res.Succeeded) {
                _this._Warningmsg = 'Deleted Successfully.';
                _this.GetAlltranscationaudit();
                _this._ShowdivMsgWar = true;
                setTimeout(function () {
                    this._ShowdivMsgWar = false;
                    this._isShowLoader = false;
                }.bind(_this), 2000);
            }
        });
    };
    TransactionAuditComponent = __decorate([
        core_1.Component({
            templateUrl: "app/components/TransactionAudit.html?v=" + $.getVersion(),
            providers: [TranscationreconciliationService_1.TranscationreconciliationService, fileuploadservice_1.FileUploadService]
        }),
        __metadata("design:paramtypes", [utilityService_1.UtilityService,
            TranscationreconciliationService_1.TranscationreconciliationService, fileuploadservice_1.FileUploadService,
            router_1.Router])
    ], TransactionAuditComponent);
    return TransactionAuditComponent;
}());
exports.TransactionAuditComponent = TransactionAuditComponent;
var routes = [
    { path: '', component: TransactionAuditComponent }
];
var TransactionAuditComponentModule = /** @class */ (function () {
    function TransactionAuditComponentModule() {
    }
    TransactionAuditComponentModule = __decorate([
        core_2.NgModule({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_core_1.WjCoreModule, wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_input_1.WjInputModule, wijmo_angular2_grid_filter_1.WjGridFilterModule],
            declarations: [TransactionAuditComponent]
        })
    ], TransactionAuditComponentModule);
    return TransactionAuditComponentModule;
}());
exports.TransactionAuditComponentModule = TransactionAuditComponentModule;
//# sourceMappingURL=TransactionAudit.component.js.map