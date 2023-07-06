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
exports.AccountingReportHistoryModule = exports.AccountingReportHistoryComponent = void 0;
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
var reportFileLog_1 = require("../../core/domain/reportFileLog");
var fileuploadservice_1 = require("../../core/services/fileuploadservice");
var ng2_file_input_1 = require("ng2-file-input");
var AccountingReportHistoryComponent = /** @class */ (function (_super) {
    __extends(AccountingReportHistoryComponent, _super);
    function AccountingReportHistoryComponent(reportSrv, ng2FileInputService, fileUploadService, utilityService, notificationService, _router) {
        var _this = _super.call(this, 30, 1, 0) || this;
        _this.reportSrv = reportSrv;
        _this.ng2FileInputService = ng2FileInputService;
        _this.fileUploadService = fileUploadService;
        _this.utilityService = utilityService;
        _this.notificationService = notificationService;
        _this._router = _router;
        _this._isListFetching = false;
        _this._ShowmessagedivMsgWar = false;
        _this._dvEmptyReportSearchMsg = false;
        _this._Showmessagediv = false;
        _this._ShowmessagedivMsg = '';
        _this._WaringMessage = '';
        _this._isshowGeneratebutton = false;
        _this._isShowActivityLog = false;
        _this._pageSizeDocImport = 30;
        _this._pageIndexDocImport = 1;
        _this._totalCountDocImport = 0;
        _this.CurrentcountDocImport = 0;
        _this.isScrollHandlerAdded = false;
        _this._dvEmptyDocumentMsg = false;
        _this._isshowGeneratebutton = false;
        _this._document = new reportFileLog_1.reportFileLog();
        var d = new Date();
        var currdate = new Date((d.getMonth() + 1) + "/" + d.getDate() + "/" + d.getFullYear());
        _this._endDate = new Date((d.getMonth() + 1) + "/" + d.getDate() + "/" + d.getFullYear());
        _this._startDate = _this.getDateMonthsBefore(currdate, 1);
        //this.getAllRepots();
        _this.getDocumentList();
        _this.utilityService.setPageTitle("M61–Report");
        return _this;
    }
    AccountingReportHistoryComponent.prototype.initialized = function (s, e) {
        this.gridFilter.filterChanged.addHandler(function () {
            console.log('filter changed 11111');
        });
    };
    AccountingReportHistoryComponent.prototype.ngOnInit = function () {
        this.getAllRepots();
    };
    // Component views are initialized
    //ngAfterViewInit() {
    //    // commit row changes when scrolling the grid
    //    this.flex.scrollPositionChanged.addHandler(() => {
    //        var myDiv = $('#flex').find('div[wj-part="root"]');
    //        if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
    //            if (this.flex.rows.length < this._totalCount) {
    //                this._pageIndex = this.pagePlus(1);
    //                this.getAllRepots();
    //            }
    //        }
    //    });
    //}
    AccountingReportHistoryComponent.prototype.getDocumentList = function () {
        var _this = this;
        this._isListFetching = true;
        this._document.ObjectTypeID = '643';
        var d = new Date();
        var datestring = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate() + " " +
            d.getHours() + ":" + d.getMinutes();
        this._document.CurrentTime = datestring;
        this._document.Status = 1;
        this.reportSrv.getDocumentsByObjectId(this._document, this._pageIndexDocImport, this._pageSizeDocImport).subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.lstReportFileLog;
                _this._totalCountDocImport = res.TotalCount;
                if (_this._pageIndexDocImport == 1) {
                    _this.lstReports = data;
                    if (_this._totalCountDocImport == 0) {
                        _this._dvEmptyDocumentMsg = true;
                    }
                    else {
                        _this._dvEmptyDocumentMsg = false;
                    }
                }
                else {
                    _this.lstReports = _this.lstReports.concat(data);
                }
                _this._isListFetching = false;
                //setTimeout(function () {
                //    this.flexDocument.invalidate();
                //    //remove first cell selection
                //    this.flexDocument.selectionMode = wjcGrid.SelectionMode.None;
                //    //this.flexDocument.autoSizeColumns(0, this.flexDocument.columns.length, false, 20);
                //    //this.flexDocument.columns[0].width = 350; // for Note Id
                //    this.addScrollHandler();
                //}.bind(this), 100);
            }
            else {
                _this.utilityService.navigateToSignIn();
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    AccountingReportHistoryComponent.prototype.DownloadDocument = function (filename, originalfilename, storagetypeID, storageLocation, documentStorageID) {
        var _this = this;
        this._isListFetching = true;
        documentStorageID = documentStorageID === undefined ? '' : documentStorageID;
        //var _reportfilelog = new reportFileLog();
        //_reportfilelog.FileName = filename;
        //_reportfilelog.StorageLocation = storageLocation;
        //_reportfilelog.StorageTypeID = storagetypeID;
        //if (_reportfilelog.StorageTypeID == "459")
        //    _reportfilelog.FileName = documentStorageID;
        var ID = filename;
        if (storagetypeID == "459")
            ID = documentStorageID;
        this.reportSrv.downloadObjectDocumentByStorageTypeAndLocation(ID, storagetypeID, storageLocation)
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
            _this._isListFetching = false;
        }, function (error) {
            //  alert('Something went wrong');
            _this._isListFetching = false;
            ;
        });
    };
    AccountingReportHistoryComponent.prototype.ApplyPermissions = function (_object) {
        var buttonarray = _object.filter(function (item) { return item.ModuleType === 'Control' && item.RightsName === 'Edit'; });
        if (buttonarray.length > 0 && typeof buttonarray != 'undefined') {
            this._isshowGeneratebutton = true;
        }
        this._isShowActivityLog = true;
    };
    AccountingReportHistoryComponent.prototype.getAllRepots = function () {
        var _this = this;
        this.reportSrv.GetAllAccountingReport(1, 1000)
            .subscribe(function (res) {
            if (res.Succeeded) {
                //if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                var data = res.ReportFileList;
                _this._totalCount = res.TotalCount;
                _this.lstReportMaster = data;
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
    AccountingReportHistoryComponent.prototype.SearchDocument = function () {
        if (this._startDate !== undefined && this._endDate !== undefined) {
            this._document.StartDate = this.utilityService.convertDatetoGMT(this._startDate);
            this._document.EndDate = this.utilityService.convertDatetoGMT(this._endDate);
        }
        else {
            this._document.StartDate = null;
            this._document.EndDate = null;
        }
        this._document.ObjectGUID = $("#ddlReportName").val();
        if (this.isValidate()) {
            this.getDocumentList();
        }
        else {
            this.CustomDialogSearch();
        }
    };
    AccountingReportHistoryComponent.prototype.isValidate = function () {
        var ret_value = true;
        this.savedialogmsg = "";
        if (!this._startDate && !this._endDate) {
            return true;
        }
        if (!this._startDate || !this._endDate) {
            this.savedialogmsg = "Please select date range.";
            return false;
        }
        if (this._startDate > this._endDate) {
            this.savedialogmsg = "End date can not be smaller than start date.";
            return false;
        }
        return ret_value;
    };
    AccountingReportHistoryComponent.prototype.CustomDialogSearch = function () {
        var winW = window.innerWidth;
        var winH = window.innerHeight;
        var dialogbox = document.getElementById('Genericdialogbox');
        document.getElementById('searchdialogmessage').innerHTML = this.savedialogmsg;
        dialogbox.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    AccountingReportHistoryComponent.prototype.ClosePopUpDialog = function () {
        var modal = document.getElementById('Genericdialogbox');
        modal.style.display = "none";
    };
    AccountingReportHistoryComponent.prototype.getDateMonthsBefore = function (date, nofMonths) {
        var thisMonth = date.getMonth();
        // set the month index of the date by subtracting nofMonths from the current month index
        date.setMonth(thisMonth - nofMonths);
        // When trying to add or subtract months from a Javascript Date() Object which is any end date of a month,  
        // JS automatically advances your Date object to next month's first date if the resulting date does not exist in its month. 
        // For example when you add 1 month to October 31, 2008 , it gives Dec 1, 2008 since November 31, 2008 does not exist.
        // if the result of subtraction is negative and add 6 to the index and check if JS has auto advanced the date, 
        // then set the date again to last day of previous month
        // Else check if the result of subtraction is non negative, subtract nofMonths to the index and check the same.
        if ((thisMonth - nofMonths < 0) && (date.getMonth() != (thisMonth + nofMonths))) {
            date.setDate(0);
        }
        else if ((thisMonth - nofMonths >= 0) && (date.getMonth() != thisMonth - nofMonths)) {
            date.setDate(0);
        }
        return date;
    };
    AccountingReportHistoryComponent.prototype.CallConfirm = function (obj) {
        this.ConfirmDialogBoxFor = 'DeleteHistory';
        this.UploadedDocumentLogID = obj.UploadedDocumentLogID;
        var customdialogbox = document.getElementById('customdialogbox');
        this._ConfirmMsgText = 'Are you sure you want to delete ' + obj.FileName + '?';
        customdialogbox.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    AccountingReportHistoryComponent.prototype.ClosePopUpConfirmBox = function () {
        this._ConfirmMsgText = "";
        var modal = document.getElementById('customdialogbox');
        modal.style.display = "none";
    };
    AccountingReportHistoryComponent.prototype.ConfirmBoxOK = function () {
        if (this.ConfirmDialogBoxFor == 'DeleteHistory') {
            this.DeleteReportHistory();
        }
    };
    AccountingReportHistoryComponent.prototype.DeleteReportHistory = function () {
        var _this = this;
        this.ClosePopUpConfirmBox();
        this._isListFetching = true;
        var lstDoc = this.lstReports.filter(function (x) { return x.UploadedDocumentLogID == _this.UploadedDocumentLogID; });
        lstDoc.forEach(function (obj, i) { obj.Status = 395; });
        if (lstDoc.length > 0) {
            this.reportSrv.updateReportLogStatus(lstDoc).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.getDocumentList();
                    _this._isListFetching = false;
                    _this._Showmessagediv = true;
                    _this._ShowmessagedivMsg = "File deleted successfully";
                    setTimeout(function () {
                        this._Showmessagediv = false;
                        this._ShowmessagedivMsg = "";
                        //   console.log(this._ShowmessagedivWar);
                    }.bind(_this), 5000);
                }
                else {
                    _this.utilityService.navigateToSignIn();
                }
            });
            (function (error) {
                _this._isListFetching = false;
                alert('Something went wrong');
            });
        }
    };
    var _a, _b, _c, _d;
    __decorate([
        (0, core_1.ViewChild)('flex'),
        __metadata("design:type", typeof (_a = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _a : Object)
    ], AccountingReportHistoryComponent.prototype, "flex", void 0);
    __decorate([
        (0, core_1.ViewChild)('filter'),
        __metadata("design:type", typeof (_b = typeof wjcGridFilter !== "undefined" && wjcGridFilter.FlexGridFilter) === "function" ? _b : Object)
    ], AccountingReportHistoryComponent.prototype, "gridFilter", void 0);
    AccountingReportHistoryComponent = __decorate([
        (0, core_1.Component)({
            selector: "reporthistory",
            templateUrl: "app/components/AccountingReports/accountingReportHistory.html?v=" + $.getVersion(),
            providers: [reportService_1.ReportService, fileuploadservice_1.FileUploadService, notificationService_1.NotificationService]
        }),
        __metadata("design:paramtypes", [reportService_1.ReportService, typeof (_c = typeof ng2_file_input_1.Ng2FileInputService !== "undefined" && ng2_file_input_1.Ng2FileInputService) === "function" ? _c : Object, fileuploadservice_1.FileUploadService,
            utilityService_1.UtilityService,
            notificationService_1.NotificationService, typeof (_d = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _d : Object])
    ], AccountingReportHistoryComponent);
    return AccountingReportHistoryComponent;
}(paginated_1.Paginated));
exports.AccountingReportHistoryComponent = AccountingReportHistoryComponent;
var routes = [
    { path: '', component: AccountingReportHistoryComponent }
];
var AccountingReportHistoryModule = /** @class */ (function () {
    function AccountingReportHistoryModule() {
    }
    AccountingReportHistoryModule = __decorate([
        (0, core_2.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_input_1.WjInputModule, wijmo_angular2_grid_filter_1.WjGridFilterModule, ng2_file_input_1.Ng2FileInputModule.forRoot()],
            declarations: [AccountingReportHistoryComponent]
        })
    ], AccountingReportHistoryModule);
    return AccountingReportHistoryModule;
}());
exports.AccountingReportHistoryModule = AccountingReportHistoryModule;
//# sourceMappingURL=accountingReportHistory.component.js.map