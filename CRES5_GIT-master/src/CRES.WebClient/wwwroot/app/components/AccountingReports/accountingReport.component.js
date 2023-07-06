"use strict";
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (Object.prototype.hasOwnProperty.call(b, p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        if (typeof b !== "function" && b !== null)
            throw new TypeError("Class extends value " + String(b) + " is not a constructor or null");
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
exports.AccountReportListModule = exports.AccountingReportComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var reportService_1 = require("../../core/services/reportService");
var notificationService_1 = require("../../core/services/notificationService");
var utilityService_1 = require("../../core/services/utilityService");
var paginated_1 = require("../../core/common/paginated");
var wjcGrid = require("wijmo/wijmo.grid");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wjcGridFilter = require("wijmo/wijmo.grid.filter");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var wijmo_angular2_input_1 = require("wijmo/wijmo.angular2.input");
var ng2_file_input_1 = require("ng2-file-input");
var reportFile_1 = require("../../core/domain/reportFile");
var AccountingReportComponent = /** @class */ (function (_super) {
    __extends(AccountingReportComponent, _super);
    function AccountingReportComponent(reportSrv, utilityService, notificationService, _router) {
        var _this = _super.call(this, 30, 1, 0) || this;
        _this.reportSrv = reportSrv;
        _this.utilityService = utilityService;
        _this.notificationService = notificationService;
        _this._router = _router;
        _this._reportListFetching = false;
        _this._ShowmessagedivMsgWar = false;
        _this._dvEmptyReportSearchMsg = false;
        _this._Showmessagediv = false;
        _this._ShowmessagedivMsg = '';
        _this._WaringMessage = '';
        _this._isshowGeneratebutton = false;
        _this._isShowActivityLog = false;
        _this._reportFileGUID = "";
        _this._dvInValidJson = false;
        _this._dvInValidJsonMsg = '';
        _this._attributeValue = "";
        _this._ShowmessagedivError = false;
        _this._ShowmessagedivErrorMsg = '';
        _this._isshowGeneratebutton = false;
        _this.getAllRepots();
        _this.utilityService.setPageTitle("M61–Report");
        return _this;
    }
    AccountingReportComponent.prototype.initialized = function (s, e) {
        this.gridFilter.filterChanged.addHandler(function () {
            console.log('filter changed 11111');
        });
    };
    // Component views are initialized
    AccountingReportComponent.prototype.ngAfterViewInit = function () {
        // commit row changes when scrolling the grid
        var _this = this;
        this.flex.scrollPositionChanged.addHandler(function () {
            var myDiv = $('#flex').find('div[wj-part="root"]');
            if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
                if (_this.flex.rows.length < _this._totalCount) {
                    _this._pageIndex = _this.pagePlus(1);
                    _this.getAllRepots();
                }
            }
        });
    };
    AccountingReportComponent.prototype.getAllRepots = function () {
        var _this = this;
        this._reportListFetching = true;
        this.reportSrv.GetAllAccountingReport(this._pageIndex, this._pageSize)
            .subscribe(function (res) {
            if (res.Succeeded) {
                //if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                var data = res.ReportFileList;
                _this._totalCount = res.TotalCount;
                if (_this._pageIndex == 1) {
                    _this.lstreports = data;
                    //remove first cell selection
                    _this.flex.selectionMode = wjcGrid.SelectionMode.None;
                    if (res.TotalCount == 0) {
                        _this._dvEmptyReportSearchMsg = true;
                        _this._reportListFetching = false;
                    }
                    else {
                        setTimeout(function () {
                            _this._reportListFetching = false;
                        }, 2000);
                    }
                    setTimeout(function () {
                        _this.ApplyPermissions(res.UserPermissionList);
                    }, 2000);
                }
                else {
                    _this.lstreports = _this.lstreports.concat(data);
                }
                _this._reportListFetching = false;
                setTimeout(function () {
                    this.flex.invalidate();
                    //this.flex.autoSizeColumns(0, this.flex.columns.length, false, 20);
                    //this.flex.columns[0].width = 350; // for Note Id
                }.bind(_this), 1);
                //} else {
                //    this.utilityService.navigateUnauthorize();
                //}
                //
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
    AccountingReportComponent.prototype.generateReport = function (ReportFileGUID) {
        var _this = this;
        var _objreportfile = this.lstreports.filter(function (x) { return x.ReportFileGUID == ReportFileGUID; })[0];
        var _reportFile = new reportFile_1.reportFile();
        _reportFile.ReportFileGUID = ReportFileGUID;
        _reportFile.IsDownloadRequire = false;
        _reportFile.DefaultAttributes = this._attributeValue;
        this._reportListFetching = true;
        this.reportSrv.GenerateAccountingReport(_reportFile)
            .subscribe(function (res) {
            _this._reportListFetching = false;
            if (_reportFile.IsDownloadRequire == false) {
                if (res.Succeeded) {
                    //this._reportListFetching = false;
                    _this._Showmessagediv = true;
                    _this._ShowmessagedivMsg = "File generated successfully";
                    setTimeout(function () {
                        this._Showmessagediv = false;
                        this._ShowmessagedivMsg = "";
                        //   console.log(this._ShowmessagedivWar);
                    }.bind(_this), 5000);
                }
                else {
                    _this._ShowmessagedivError = true;
                    _this._ShowmessagedivErrorMsg = "Erro in file generation,Please try after some time.";
                    setTimeout(function () {
                        this._ShowmessagedivError = false;
                        this._ShowmessagedivErrorMsg = "";
                        //   console.log(this._ShowmessagedivWar);
                    }.bind(_this), 5000);
                }
            }
            else {
                var b = new Blob([res]);
                //var url = window.URL.createObjectURL(b);
                //window.open(url);
                var dwldLink = document.createElement("a");
                var url = URL.createObjectURL(b);
                var isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
                if (isSafariBrowser) { //if Safari open in new window to save file with random filename.
                    dwldLink.setAttribute("target", "_blank");
                }
                dwldLink.setAttribute("href", url);
                dwldLink.setAttribute("download", _objreportfile.ReportFileName + '.' + _objreportfile.ReportFileFormat);
                dwldLink.style.visibility = "hidden";
                document.body.appendChild(dwldLink);
                dwldLink.click();
                document.body.removeChild(dwldLink);
                //this._reportListFetching = false;
                _this._Showmessagediv = true;
                _this._ShowmessagedivMsg = "File generated successfully";
                setTimeout(function () {
                    this._Showmessagediv = false;
                    this._ShowmessagedivMsg = "";
                }.bind(_this), 5000);
            }
        }, function (error) {
            // alert('Something went wrong');
            _this._reportListFetching = false;
            ;
        });
    };
    AccountingReportComponent.prototype.ApplyPermissions = function (_object) {
        var buttonarray = _object.filter(function (item) { return item.ModuleType === 'Control' && item.RightsName === 'Edit'; });
        if (buttonarray.length > 0 && typeof buttonarray != 'undefined') {
            this._isshowGeneratebutton = true;
        }
        this._isShowActivityLog = true;
    };
    AccountingReportComponent.prototype.clickeddeal = function () {
        this._reportListFetching = true;
    };
    AccountingReportComponent.prototype.ShowAttributesDialog = function (attributeValue, reportname) {
        $("#txtDefaultAttribute").val(attributeValue);
        $("#spnHeader").text(reportname + ' parameters');
        var modal = document.getElementById('ModalReportFileAttribute');
        modal.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    AccountingReportComponent.prototype.ClosePopUpReportFileAttribute = function () {
        var modal = document.getElementById('ModalReportFileAttribute');
        $('#txtDefaultAttribute').val('');
        modal.style.display = "none";
    };
    AccountingReportComponent.prototype.GenearteAndDownloadReport = function (ReportFileGUID) {
        var _objreportfile = this.lstreports.filter(function (x) { return x.ReportFileGUID == ReportFileGUID; })[0];
        if (_objreportfile.DefaultAttributes !== undefined && _objreportfile.DefaultAttributes != null) {
            this._reportFileGUID = ReportFileGUID;
            this.ShowAttributesDialog(_objreportfile.DefaultAttributes, _objreportfile.ReportFileName);
        }
        else {
            this._reportFileGUID = "";
            this._attributeValue = "";
            this.generateReport(_objreportfile.ReportFileGUID);
        }
    };
    AccountingReportComponent.prototype.GenearteAndDownloadReportWithParam = function (ReportFileGUID) {
        if (!this.isValidJson($("#txtDefaultAttribute").val())) {
            this._dvInValidJson = true;
            this._dvInValidJsonMsg = "Invalid json format";
            setTimeout(function () {
                this._dvInValidJson = false;
                this._dvInValidJsonMsg = "";
                //   console.log(this._ShowmessagedivWar);
            }.bind(this), 3000);
            return false;
        }
        else {
            this._attributeValue = $("#txtDefaultAttribute").val();
            this.ClosePopUpReportFileAttribute();
            this.generateReport(this._reportFileGUID);
        }
    };
    AccountingReportComponent.prototype.isValidJson = function (jsonstring) {
        try {
            JSON.parse(jsonstring);
        }
        catch (e) {
            return false;
        }
        return true;
    };
    var _a, _b, _c;
    __decorate([
        (0, core_1.ViewChild)('flex'),
        __metadata("design:type", typeof (_a = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _a : Object)
    ], AccountingReportComponent.prototype, "flex", void 0);
    __decorate([
        (0, core_1.ViewChild)('filter'),
        __metadata("design:type", typeof (_b = typeof wjcGridFilter !== "undefined" && wjcGridFilter.FlexGridFilter) === "function" ? _b : Object)
    ], AccountingReportComponent.prototype, "gridFilter", void 0);
    AccountingReportComponent = __decorate([
        (0, core_1.Component)({
            selector: "accountingreport",
            templateUrl: "app/components/AccountingReports/accountingReport.html?v=" + $.getVersion(),
            providers: [reportService_1.ReportService, notificationService_1.NotificationService]
        }),
        __metadata("design:paramtypes", [reportService_1.ReportService,
            utilityService_1.UtilityService,
            notificationService_1.NotificationService, typeof (_c = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _c : Object])
    ], AccountingReportComponent);
    return AccountingReportComponent;
}(paginated_1.Paginated));
exports.AccountingReportComponent = AccountingReportComponent;
var routes = [
    { path: '', component: AccountingReportComponent }
];
var AccountReportListModule = /** @class */ (function () {
    function AccountReportListModule() {
    }
    AccountReportListModule = __decorate([
        (0, core_2.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_input_1.WjInputModule, wijmo_angular2_grid_filter_1.WjGridFilterModule, ng2_file_input_1.Ng2FileInputModule.forRoot()],
            declarations: [AccountingReportComponent]
        })
    ], AccountReportListModule);
    return AccountReportListModule;
}());
exports.AccountReportListModule = AccountReportListModule;
//# sourceMappingURL=accountingReport.component.js.map