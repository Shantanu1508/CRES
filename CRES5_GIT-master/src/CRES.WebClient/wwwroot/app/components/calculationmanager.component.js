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
exports.CalculationManagerModule = exports.CalculationManagerComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var wjcGrid = require("wijmo/wijmo.grid");
var CalculationManagerService_1 = require("../core/services/CalculationManagerService");
var NoteService_1 = require("../core/services/NoteService");
var CalculationManagerList_1 = require("../core/domain/CalculationManagerList");
var utilityService_1 = require("../core/services/utilityService");
var paginated_1 = require("../core/common/paginated");
var wjNg2Input = require("wijmo/wijmo.angular2.input");
var wjNg2GridFilter = require("wijmo/wijmo.angular2.grid.filter");
var noteCashflowsExportDataList_1 = require("../core/domain/noteCashflowsExportDataList");
var Note_1 = require("../core/domain/Note");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var PermissionService_1 = require("../core/services/PermissionService");
var signalRService_1 = require("./../Notification/signalRService");
var appsettings_1 = require("../core/common/appsettings");
var TestCase_1 = require("../core/domain/TestCase");
var portfolioService_1 = require("../core/services/portfolioService");
var scenarioService_1 = require("../core/services/scenarioService");
var Scenario_1 = require("../core/domain/Scenario");
var BatchCalculationMaster_1 = require("../core/domain/BatchCalculationMaster");
var fileuploadservice_1 = require("../core/services/fileuploadservice");
var platform_browser_1 = require("@angular/platform-browser");
var wijmo_angular2_input_1 = require("wijmo/wijmo.angular2.input");
var wijmo_angular2_core_1 = require("wijmo/wijmo.angular2.core");
var CalculationManagerComponent = /** @class */ (function (_super) {
    __extends(CalculationManagerComponent, _super);
    function CalculationManagerComponent(_router, notesvc, calculationsvc, permissionService, utilityService, _signalRService, _portfolioService, scenarioService, fileUploadService, sani) {
        var _this = _super.call(this, 50, 1, 0) || this;
        _this._router = _router;
        _this.notesvc = notesvc;
        _this.calculationsvc = calculationsvc;
        _this.permissionService = permissionService;
        _this.utilityService = utilityService;
        _this._signalRService = _signalRService;
        _this._portfolioService = _portfolioService;
        _this.scenarioService = scenarioService;
        _this.fileUploadService = fileUploadService;
        _this.sani = sani;
        //export class CalculationManagerComponent  {
        _this.notelist = new Array();
        _this.rowsToUpdate = [];
        _this.lstcalculationlist = new Array();
        _this.Message = '';
        _this._Showmessagediv = false;
        _this._ShowSuccessmessagediv = false;
        _this._isCalcListFetching = false;
        _this._chkSelectAll = false;
        _this._isShowDownloadCashflows = false;
        _this._ShowSuccessmessageTestcasediv = false;
        _this._norecordtestcase = false;
        //@ViewChild('flexNoteCashflowsExportDataList') flexNoteCashflowsExportDataList: wijmo.grid.FlexGrid;
        _this.arrnew = [];
        _this.totalcount = 0;
        _this.refreshcount = 0;
        _this.finalCall = 0;
        _this._isExceptionListFetching = false;
        _this._ExceptionListCount = 1;
        _this._testcasecount = 0;
        _this._istestdataexist = false;
        _this.istestcasefetching = false;
        _this.totalTestCasecount = 0;
        _this.PortfolioMasterGuid = "00000000-0000-0000-0000-000000000000";
        _this._lstcalculationlistCount = 1;
        _this._calculationManager = new CalculationManagerList_1.CalculationManagerList("");
        _this._lstcalculationlistCountOnDropDownFilter = 0;
        _this._lstcalculationlistCountOnGridFilter = 0;
        _this._batchcalc = new BatchCalculationMaster_1.BatchCalculationMaster("");
        _this._lstlstbatchlogCount = 1;
        _this.NoteCountOnFirstLoad = 0;
        _this.isAllowDebugInCalc = false;
        _this._batchType = 'Single';
        _this.iscancelCal = false;
        _this.listtransactioncategory = [];
        _this._chkSelectdownloadAll = false;
        _this.flexchecked = false;
        _this.calcObjForDownload = new CalculationManagerList_1.CalculationManagerList("");
        _this._user = JSON.parse(localStorage.getItem('user'));
        _this._scenariodc = new Scenario_1.Scenario('');
        _this._lstScenario = _this._scenariodc.LstScenarioUserMap;
        _this.getAllDistinctScenario();
        _this.subscribetoevent();
        _this._chkSelectdownloadAll = false;
        _this._chkSelectAll = false;
        // this.notelist = new CalculationManagerList("");
        _this._noteCashflowsExportDataList = new noteCashflowsExportDataList_1.NoteCashflowsExportDataList();
        _this.GettimezoneCurrentOffset();
        _this.RefreshCalculationStatus();
        _this.finalCall = 1;
        _this.utilityService.setPageTitle("M61–Calculation");
        _this.GetUserPermission();
        _this.GetTransactionCategory();
        return _this;
    }
    CalculationManagerComponent.prototype.ngOnInit = function () {
        this.CalculationModeID = parseInt(window.localStorage.getItem("CalculationModeID"));
        this._scenariodc.CalculationModeID = this.CalculationModeID;
        this._calculationManager.PortfolioMasterGuid = "00000000-0000-0000-0000-000000000000";
        this._calculationManager.AnalysisID = this.ScenarioId;
        this.GetAllLookups();
        this.GetAllPortfolio();
        this.GetCalcStatus();
    };
    CalculationManagerComponent.prototype.GetAllPortfolio = function () {
        var _this = this;
        this._portfolioService.getallportfolio().subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.lstportfolio;
                _this.lstPortfolio = data;
            }
        });
    };
    CalculationManagerComponent.prototype.ChangeDynamicPortfolio = function (newvalue) {
        this._lstcalculationlistCount = 1;
        this._calculationManager.PortfolioMasterGuid = newvalue;
        this.RefreshCalculationStatus();
    };
    // Component views are initialized
    CalculationManagerComponent.prototype.ngAfterViewInit = function () {
        var _this = this;
        // commit row changes when scrolling the grid
        this.flexnoteexceptions.scrollPositionChanged.addHandler(function () {
            var myDiv = $('#flexnoteexceptions').find('div[wj-part="root"]');
            //  alert(myDiv.prop('offsetHeight') + myDiv.scrollTop() + '  ' + myDiv.prop('scrollHeight'));
            if (myDiv.prop('offsetHeight') + myDiv.scrollTop() <= myDiv.prop('scrollHeight')) {
                if (_this.flexnoteexceptions.rows.length < _this._ExceptionListCount) {
                    _this._pageIndex = _this.pagePlus(1);
                    _this.GetAllExceptions();
                }
            }
        });
        this.flextestcase.scrollPositionChanged.addHandler(function () {
            var mytestDiv = $('#flextestcase').find('div[wj-part="root"]');
            if (mytestDiv.prop('offsetHeight') + mytestDiv.scrollTop() <= mytestDiv.prop('scrollHeight')) {
                if (_this.flextestcase.rows.length < _this._testcasecount) {
                    _this._pageIndex = _this.pagePlus(1);
                    _this._istestdataexist = false;
                    _this.GetTestcases(false);
                }
            }
        });
        if (this.lstcalculationlist) {
            this.gridFilter.filterApplied.addHandler(function () {
                for (var i = 0; i < _this.lstcalculationlist.length; i++) {
                    _this.lstcalculationlist[i].Active = false;
                    _this.lstcalculationlist[i].downloadnote = false;
                }
                // this.RefreshCalcStatus();
            });
        }
    };
    //initFilter(filter) {
    //    filter.filterChanging.addHandler((s, e) => {
    //        var editor = s.activeEditor;
    //        if (editor) {
    //            var clear = editor.hostElement.querySelector('[wj-part="btn-clear"]');
    //            clear.addEventListener('click', e => {
    //                alert('clear clicked');
    //            }, true);
    //        }
    //    });
    //}
    CalculationManagerComponent.prototype.RefreshCalculationStatus = function () {
        var _this = this;
        this._isCalcListFetching = true;
        this.calculationsvc.refreshCalculation(this._calculationManager).subscribe(function (res) {
            if (res.Succeeded) {
                if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                    var data = res.lstCalculationManger;
                    _this.totalcount = res.lstCalculationManger.length;
                    _this._lstcalculationlistCount = _this.totalcount;
                    _this._lstcalculationlistCountOnDropDownFilter = res.lstCalculationManger.length;
                    _this._lstcalculationlistCountOnGridFilter = res.lstCalculationManger.length;
                    if (_this.totalcount > 0) {
                        _this.lstcalculationlist = data;
                        //for (var i = 0; i < this.totalcount; i++) {
                        //    this.flex.invalidate();
                        //}
                        var calctextcolindex = _this.flex.getColumn("EnableM61CalculationsText").index;
                        var calccheckboxcol = _this.flex.getColumn("Active").index;
                        if (_this.flex) {
                            _this.flex.itemFormatter = function (panel, r, c, cell) {
                                if (panel.cellType != wjcGrid.CellType.Cell) {
                                    return;
                                }
                                var item = panel.getCellData(r, calctextcolindex);
                                if (item == 'N') {
                                    if (calccheckboxcol == panel.columns[c].index) {
                                        cell.style.backgroundColor = '#cfcfcf';
                                    }
                                    else {
                                        cell.style.backgroundColor = null;
                                    }
                                    //   panel.grid.rows[r].isReadOnly = true;
                                }
                                else {
                                    cell.style.backgroundColor = null;
                                }
                            };
                        }
                        _this.ConvertToBindableDate(_this.lstcalculationlist, "", "en-US");
                        setTimeout(function () {
                            //this.flex.autoSizeColumns(0, this.flex.columns.length - 1, false, 30);
                            this._isCalcListFetching = false;
                        }.bind(_this), 1);
                    }
                    else {
                        _this.lstcalculationlist = null;
                        _this._isCalcListFetching = false;
                    }
                }
                else {
                    localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                    localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));
                    _this.utilityService.navigateUnauthorize();
                }
                if (_this.NoteCountOnFirstLoad == 0) {
                    _this.NoteCountOnFirstLoad = _this.totalcount;
                }
            }
        });
    };
    CalculationManagerComponent.prototype.cellEditbeginCalc = function (s, e) {
        if (this.flex.rows[e.row]._data.EnableM61CalculationsText == "N") {
            if (e.col.toString() == "0") {
                this.flex.rows[e.row]._data.downloadnote = false;
                e.cancel = true;
            }
            else {
                e.cancel = false;
            }
        }
        this.flex.invalidate();
    };
    CalculationManagerComponent.prototype.CancelBatchCalculationRequest = function () {
        var _this = this;
        this._isCalcListFetching = true;
        this.iscancelCal = true;
        this.finalCall = 0;
        for (var i = 0; i < this.lstcalculationlist.length; i++) {
            try {
                if (this.lstcalculationlist[i].EnableM61CalculationsText == 'Y') {
                    if (typeof this.lstcalculationlist[i].Active !== null) {
                        // if (this.lstcalculationlist[i].Active == true) {
                        this.lstcalculationlist[i].StatusText = null;
                        this.lstcalculationlist[i].StartTime = null;
                        this.lstcalculationlist[i].EndTime = null;
                        this.lstcalculationlist[i].ErrorMessage = null;
                        this.lstcalculationlist[i].AnalysisID = this.ScenarioId;
                        this.lstcalculationlist[i].CalculationModeID = this.CalculationModeID;
                        this.lstcalculationlist[i].Active = false;
                        //}
                    }
                }
            }
            catch (err) {
                console.log(err);
            }
        }
        if (this.flex) {
            this.flex.invalidate();
        }
        this.calculationsvc.deleteBatchCalculationRequestByAnalysisID(this.ScenarioId).subscribe(function (res) {
            if (res.Succeeded) {
                _this._ShowSuccessmessage = "Last batch calculation request reset successfully for " + _this.ScenarioName + " scenario .";
                _this._ShowSuccessmessagediv = true;
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                    this._isCalcListFetching = false;
                }.bind(_this), 5000);
            }
            else {
                localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                localStorage.setItem('WarmsgdashBoad', JSON.stringify('Error occurred while processing request'));
                setTimeout(function () {
                    this.showWarningMsgdashboard = false;
                    this._isCalcListFetching = false;
                }.bind(_this), 5000);
            }
        });
    };
    CalculationManagerComponent.prototype.getAllExceptions = function () { };
    CalculationManagerComponent.prototype.CalcFunded = function () {
        this.iscancelCal = false;
        var modaltag = document.getElementById('myModalConfirmTagCalFunded');
        modaltag.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    CalculationManagerComponent.prototype.CalcAtServerDialog = function () {
        this.iscancelCal = false;
        this.rowsToUpdate = [];
        for (var i = 0; i < this.lstcalculationlist.length; i++) {
            try {
                if (this.lstcalculationlist[i].EnableM61CalculationsText == 'Y') {
                    if (typeof this.lstcalculationlist[i].Active !== null) {
                        if (this.lstcalculationlist[i].Active == true) {
                            this.lstcalculationlist[i].StatusText = "Processing";
                            this.lstcalculationlist[i].StartTime = null;
                            this.lstcalculationlist[i].EndTime = null;
                            this.lstcalculationlist[i].ErrorMessage = null;
                            this.lstcalculationlist[i].AnalysisID = this.ScenarioId;
                            this.lstcalculationlist[i].CalculationModeID = this.CalculationModeID;
                            this.rowsToUpdate.push(this.lstcalculationlist[i]);
                        }
                    }
                }
            }
            catch (err) {
                console.log(err);
            }
        }
        if (this.flex) {
            this.flex.invalidate();
        }
        var templenght = 0;
        templenght = Object.keys(this.rowsToUpdate).length;
        this.notelist = this.rowsToUpdate;
        if (templenght > 0) {
            //if (this.lstcalculationlist.filter(x => x.Active == true).length == this.NoteCountOnFirstLoad && this.NoteCountOnFirstLoad > 0) {
            if (this.lstcalculationlist.filter(function (x) { return x.Active == true; }).length + this.lstcalculationlist.filter(function (x) { return x.EnableM61CalculationsText != 'Y'; }).length == this._lstcalculationlistCountOnGridFilter && this._lstcalculationlistCountOnGridFilter > 0) {
                var modaltag = document.getElementById('myModalConfirmTag');
                modaltag.style.display = "block";
                $.getScript("/js/jsDrag.js");
            }
            else {
                this._batchType = 'Single';
                this.CalcAtServer();
            }
        }
        else {
            this.CustomAlert('Please select note(s) for calculation.');
            this._isCalcListFetching = false;
        }
    };
    CalculationManagerComponent.prototype.CloseFundedModel = function () {
        var modal = document.getElementById('myModalConfirmTagCalFunded');
        modal.style.display = "none";
    };
    CalculationManagerComponent.prototype.CalcFundedNote = function () {
        this.rowsToUpdate = [];
        for (var i = 0; i < this.lstcalculationlist.length; i++) {
            try {
                if (this.lstcalculationlist[i].EnableM61CalculationsText == 'Y') {
                    if (!this.lstcalculationlist[i].IsPaidOffDeal) {
                        this.lstcalculationlist[i].StatusText = "Processing";
                        this.lstcalculationlist[i].StartTime = null;
                        this.lstcalculationlist[i].EndTime = null;
                        this.lstcalculationlist[i].ErrorMessage = null;
                        this.lstcalculationlist[i].AnalysisID = this.ScenarioId;
                        this.lstcalculationlist[i].CalculationModeID = this.CalculationModeID;
                        this.rowsToUpdate.push(this.lstcalculationlist[i]);
                    }
                }
            }
            catch (err) {
                console.log(err);
            }
        }
        if (this.flex) {
            this.flex.invalidate();
        }
        this.notelist = this.rowsToUpdate;
        this.CalcAtServer();
        this.CloseFundedModel();
    };
    CalculationManagerComponent.prototype.CalcSelectedNote = function () {
        if (this.lstcalculationlist.filter(function (x) { return x.Active == true; }).length == 0) {
            this.CustomAlert('Please select note(s) for calculation.');
            this._isCalcListFetching = false;
        }
        else {
            this.rowsToUpdate = [];
            for (var i = 0; i < this.lstcalculationlist.length; i++) {
                try {
                    if (this.lstcalculationlist[i].EnableM61CalculationsText == 'Y') {
                        if (typeof this.lstcalculationlist[i].Active !== null) {
                            if (this.lstcalculationlist[i].Active == true) {
                                this.lstcalculationlist[i].StatusText = "Processing";
                                this.lstcalculationlist[i].StartTime = null;
                                this.lstcalculationlist[i].EndTime = null;
                                this.lstcalculationlist[i].ErrorMessage = null;
                                this.lstcalculationlist[i].AnalysisID = this.ScenarioId;
                                this.lstcalculationlist[i].CalculationModeID = this.CalculationModeID;
                                this.rowsToUpdate.push(this.lstcalculationlist[i]);
                            }
                        }
                    }
                }
                catch (err) {
                    console.log(err);
                }
            }
            if (this.flex) {
                this.flex.invalidate();
            }
            this.notelist = this.rowsToUpdate;
            this.CalcAtServer();
        }
    };
    CalculationManagerComponent.prototype.CalcAtServerWithConfirm = function (event) {
        this.CloseModalConfirmTag();
        if (event.target.id == 'tagYes') {
            this._batchType = 'AllWithTag';
        }
        else if (event.target.id == 'tagNo') {
            this._batchType = 'All';
        }
        this.CalcAtServer();
    };
    CalculationManagerComponent.prototype.CloseModalConfirmTag = function () {
        var modal = document.getElementById('myModalConfirmTag');
        modal.style.display = "none";
    };
    CalculationManagerComponent.prototype.CalcAtServer = function () {
        var _this = this;
        this._isCalcListFetching = true;
        try {
            this.notelist[0].BatchType = this._batchType;
            this.notelist[0].PortfolioMasterGuid = this._calculationManager.PortfolioMasterGuid;
            this.finalCall = 1;
            this.calculationsvc.sendnoteforcalculation(this.notelist).subscribe(function (res) {
                if (res.Succeeded) {
                    setTimeout(function () {
                        this.GetCalcStatus();
                    }.bind(_this), 30000);
                    _this._signalRService.SendCalcNotification("CALCMGR" + '|*|' + appsettings_1.AppSettings._notificationenvironment);
                    _this._ShowSuccessmessage = res.Message;
                    _this._ShowSuccessmessagediv = true;
                    setTimeout(function () {
                        this._ShowSuccessmessagediv = false;
                        this._isCalcListFetching = false;
                    }.bind(_this), 5000);
                }
                else {
                    _this._Showmessagediv = true;
                    _this.Message = res.Message;
                    setTimeout(function () {
                        this._Showmessagediv = false;
                        this._isCalcListFetching = false;
                    }.bind(_this), 5000);
                }
            });
        }
        catch (err) {
            //alert(err);
        }
    };
    CalculationManagerComponent.prototype.CustomAlert = function (dialog) {
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
    };
    CalculationManagerComponent.prototype.ok = function () {
        document.getElementById('dialogbox').style.display = "none";
        document.getElementById('dialogoverlay').style.display = "none";
    };
    CalculationManagerComponent.prototype.ConvertToBindableDate = function (Data, modulename, locale) {
        var options = { year: "numeric", month: "numeric", day: "numeric" };
        for (var i = 0; i < Data.length; i++) {
            if (this.lstcalculationlist[i].RequestTime != null) {
                this.lstcalculationlist[i].RequestTime = new Date(this.lstcalculationlist[i].RequestTime.toString());
            }
            if (this.lstcalculationlist[i].StartTime != null) {
                //var d = new Date(this.lstcalculationlist[i].StartTime.toString());
                //this.ConvertToTimeZone(d);
                //this.lstcalculationlist[i].StartTime = this.converteddatetime;
                this.lstcalculationlist[i].StartTime = new Date(this.lstcalculationlist[i].StartTime.toString());
            }
            if (this.lstcalculationlist[i].EndTime != null) {
                //var d = new Date(this.lstcalculationlist[i].EndTime.toString());
                //this.ConvertToTimeZone(d);
                //this.lstcalculationlist[i].EndTime = this.converteddatetime;
                this.lstcalculationlist[i].EndTime = new Date(this.lstcalculationlist[i].EndTime.toString());
            }
            if (this.lstcalculationlist[i].PayOffDate != null) {
                this.lstcalculationlist[i].PayOffDate = new Date(this.convertDateToBindable(this.lstcalculationlist[i].PayOffDate));
            }
            //if (this.lstcalculationlist[i].StartTime != null) {
            //    this.lstcalculationlist[i].StartTime = new Date(this.lstcalculationlist[i].StartTime.toString());
            //}
            //if (this.lstcalculationlist[i].EndTime != null) {
            //    this.lstcalculationlist[i].EndTime = new Date(this.lstcalculationlist[i].EndTime.toString());
            //}
        }
    };
    CalculationManagerComponent.prototype.ConvertToTimeZone = function (Data) {
        var d = Data;
        var amOrPm = (d.getHours() < 12) ? "AM" : "PM";
        var hour = (d.getHours() < 12) ? d.getHours() : d.getHours() - 12;
        var hr = (hour < 10) ? '0' + hour : hour;
        var minutes = (d.getMinutes() < 10) ? '0' + d.getMinutes() : d.getMinutes();
        var month = (d.getMonth() + 1 < 10) ? '0' + d.getMonth() + 1 : d.getMonth() + 1;
        var date = (d.getDate() < 10) ? '0' + d.getDate() : d.getDate();
        return this.converteddatetime = month + '-' + date + '-' + d.getFullYear() + ' ' + hr + ':' + minutes + ' ' + amOrPm;
    };
    CalculationManagerComponent.prototype.convertDateToBindable = function (date) {
        var dateObj = null;
        if (date) {
            if (typeof (date) == "string") {
                date = date.replace("Z", "");
                dateObj = new Date(date);
            }
            else {
                dateObj = date;
            }
            if (dateObj != null) {
                return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear();
            }
        }
    };
    CalculationManagerComponent.prototype.getTwoDigitString = function (number) {
        if (number.toString().length === 1)
            return "0" + number;
        return number;
    };
    CalculationManagerComponent.prototype.SelectAll = function () {
        this._chkSelectAll = !this._chkSelectAll;
        //  var colindex = this.flex.getColumn('Active').index;
        for (var i = 0; i < this.flex.rows.length; i++) {
            if (this.flex.rows[i]._data.EnableM61CalculationsText == 'Y') {
                this.flex.rows[i]._data.Active = this._chkSelectAll;
            }
        }
        this.flex.invalidate();
    };
    CalculationManagerComponent.prototype.SelectAllDownload = function () {
        this._chkSelectdownloadAll = !this._chkSelectdownloadAll;
        // var colindex = this.flex.getColumn('downloadnote').index;
        for (var i = 0; i < this.flex.rows.length; i++) {
            this.flex.rows[i]._data.downloadnote = this._chkSelectdownloadAll;
        }
        this.flex.invalidate();
    };
    CalculationManagerComponent.prototype.GetCalcStatus = function () {
        var _this = this;
        // var num: number = 1;
        if (this.iscancelCal == false) {
            if (this.finalCall == 1) {
                this.calculationsvc.calcstatus().subscribe(function (res) {
                    if (res.Succeeded) {
                        _this.refreshcount = res.TotalCount;
                        if (_this.refreshcount > 0) {
                            // this.RefreshCalcStatus();
                            setTimeout(function () {
                                _this.RefreshCalcStatus();
                            }, 20000);
                            setTimeout(function () {
                                _this.GetCalcStatus();
                            }, 30000);
                            // alert('setTimeout');
                        }
                        else if (_this.refreshcount == 0 && _this.finalCall == 1) //For call once again after complete all process.
                         {
                            _this.finalCall = 0;
                            //alert("this.subscription.unsubscribe()");
                            if (_this.iscancelCal == false) {
                                _this.RefreshCalcStatus();
                            }
                            //this.subscription.unsubscribe();
                            //this.subscriptionLoad.unsubscribe();
                            //alert("this.subscription.unsubscribe() - DONE");
                        }
                    }
                });
            }
        }
    };
    CalculationManagerComponent.prototype.sleep = function (delay) {
        var start = new Date().getTime();
        while (new Date().getTime() < start + delay)
            ;
    };
    CalculationManagerComponent.prototype.RefreshCalcStatus = function () {
        var _this = this;
        this.calculationsvc.refreshCalculation(this._calculationManager).subscribe(function (res) {
            if (res.Succeeded) {
                _this._isCalcListFetching = false;
                var data = res.lstCalculationManger;
                _this.totalcount = res.lstCalculationManger.length;
                if (_this.totalcount > 0) {
                    //  this.lstcalculationlist = data;
                    if (data.length != _this.flex.rows.length) {
                        for (var i = 0; i < data.length; i++) {
                            for (var j = 0; j < _this.flex.rows.length; j++) {
                                try {
                                    if (_this.flex.rows[j]._data.NoteId == data[i].NoteId) {
                                        _this.flex.rows[j]._data.NoteId = data[i].NoteId;
                                        _this.flex.rows[j]._data.CRENoteID = data[i].CRENoteID;
                                        _this.flex.rows[j]._data.NoteName = data[i].NoteName;
                                        _this.flex.rows[j]._data.StatusID = data[i].StatusID;
                                        _this.flex.rows[j]._data.StatusText = data[i].StatusText;
                                        _this.flex.rows[j]._data.UserName = data[i].ApplicationID;
                                        _this.flex.rows[j]._data.StartTime = data[i].StartTime;
                                        _this.lstcalculationlist[i].EndTime = data[i].EndTime;
                                        _this.flex.rows[j]._data.ErrorMessage = data[i].ErrorMessage;
                                        _this.flex.rows[j]._data.FileName = data[i].FileName;
                                        _this.flex.rows[j]._data.EnableM61Calculations = data[i].EnableM61Calculations;
                                        _this.flex.rows[j]._data.EnableM61CalculationsText = data[i].EnableM61CalculationsText;
                                    }
                                }
                                catch (err) {
                                    console.log(err);
                                }
                            }
                        }
                    }
                    else {
                        _this.lstcalculationlist = data;
                    }
                    _this.ConvertTimeaccordingtoUser(_this.lstcalculationlist);
                    _this.ConvertToBindableDate(_this.lstcalculationlist, "", "en-US");
                    if (_this.flex) {
                        _this.flex.columnHeaders.rows[0].height = 25;
                        setTimeout(function () {
                            _this.flex.invalidate(true);
                        }, 200);
                    }
                }
            }
        });
    };
    CalculationManagerComponent.prototype.GetAllExceptions = function () {
        var _this = this;
        this._isExceptionListFetching = true;
        // this._ExceptionListCount = 0;
        this.calculationsvc.GetallExceptions("note", this._pageIndex, this._pageSize).subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.Allexceptionslist;
                _this._ExceptionListCount = res.TotalCount;
                if (_this._pageIndex == 1) {
                    _this.flexnoteexceptions.autoSizeColumns();
                    //remove first cell selection
                    //this.flexnoteexceptions.selectionMode = wjcGrid.SelectionMode.None;
                    if (res.CountException == 0) {
                        _this._ExceptionListCount = 0;
                    }
                    else {
                        _this.lstnotesexceptions = data;
                        setTimeout(function () {
                            _this.flexnoteexceptions.invalidate(true);
                        }, 200);
                    }
                }
                else {
                    //data.forEach((obj, i) => { // FETCH ALL DATA AND PUSH IN FLEX GRID!!!
                    //    this.flexnoteexceptions.rows.push(new wjcGrid.Row(obj));
                    //});
                    _this.lstnotesexceptions = _this.lstnotesexceptions.concat(data);
                }
            }
            // this.lstnotesexceptions = data;
            setTimeout(function () {
                _this.flexnoteexceptions.invalidate(true);
                _this.flexnoteexceptions.autoSizeColumns();
            }, 200);
            _this._isExceptionListFetching = false;
        });
    };
    CalculationManagerComponent.prototype.GetTestcases = function (isrun) {
        var _this = this;
        this._testCase = new TestCase_1.TestCase();
        if (!this._istestdataexist || isrun == true) {
            this.istestcasefetching = true;
            this._testCase.isRun = isrun;
            this._testCase.ModuleName = "Note";
            this.calculationsvc.getTestCases(this._testCase, this._pageIndex, this._pageSize).subscribe(function (res) {
                if (res.Succeeded) {
                    var data = res.dtTestCase;
                    _this.totalTestCasecount = res.TotalCount;
                    if (data) {
                        if (_this.flextestcase.columns.length < 2) {
                            Object.keys(data[0]).forEach(function (x, y) {
                                if (x.toString() != "NoteID" && x.toString() != "CRENoteID")
                                    _this.flextestcase.columns.push(new wjcGrid.Column({ header: x, binding: x, align: 'center' }));
                            });
                        }
                        _this._istestdataexist = true;
                        _this._testcasecount = res.TotalCount;
                        _this._lastExecutedTime = res.Trace;
                        if (_this._pageIndex == 1) {
                            if (isrun) {
                                _this._ShowSuccessmessageTestcasediv = true;
                                _this._ShowSuccessmessageTestcase = 'Test Cases excuted successfully.';
                            }
                            if (_this._testcasecount != 0) {
                                _this._testCaseData = data;
                                setTimeout(function () {
                                    if (_this.flextestcase) {
                                        _this._ShowSuccessmessageTestcasediv = false;
                                        _this.flextestcase.invalidate(true);
                                        _this.flextestcase.autoSizeColumns();
                                    }
                                }, 2000);
                            }
                        }
                        else {
                            _this._testCaseData = _this._testCaseData.concat(data);
                        }
                    }
                    _this.istestcasefetching = false;
                }
                else {
                    _this.istestcasefetching = false;
                    if (_this.totalTestCasecount == 0) {
                        _this._norecordtestcase = true;
                    }
                }
            });
        }
    };
    CalculationManagerComponent.prototype.invlaidatecalculationManagergrid = function () {
        var _this = this;
        if (this.flex) {
            setTimeout(function () {
                _this.flex.invalidate();
            }, 1000);
        }
    };
    CalculationManagerComponent.prototype.ChangeCalcStatus = function (noteobj) {
        for (var i = 0; i < noteobj.length; i++) {
            if (this.lstcalculationlist[i].Active == true) {
                this.lstcalculationlist[i].StatusText = "Processing";
                this.lstcalculationlist[i].StartTime = null;
                this.lstcalculationlist[i].EndTime = null;
                this.lstcalculationlist[i].ErrorMessage = null;
            }
        }
    };
    CalculationManagerComponent.prototype.downloadNoteCashflowsExportData = function () {
        var _this = this;
        //var _note: Note;
        this._isCalcListFetching = true;
        var transactioncategoryname = '';
        this._note = new Note_1.Note('');
        var downloadCashFlow = new Note_1.DownloadCashFlow();
        if (this.multiseltransactioncategory != undefined) {
            this.transacatename = this.multiseltransactioncategory.checkedItems.map(function (_a) {
                var TransactionCategory = _a.TransactionCategory;
                return TransactionCategory;
            });
            transactioncategoryname = this.multiseltransactioncategory.checkedItems.map(function (_a) {
                var TransactionCategory = _a.TransactionCategory;
                return TransactionCategory;
            }).join('|');
            transactioncategoryname = transactioncategoryname.length ? transactioncategoryname : 'Default';
        }
        downloadCashFlow.NoteId = "00000000-0000-0000-0000-000000000000";
        downloadCashFlow.DealID = "00000000-0000-0000-0000-000000000000";
        downloadCashFlow.AnalysisID = this.ScenarioId;
        downloadCashFlow.PortfolioMasterGuid = this._calculationManager.PortfolioMasterGuid;
        downloadCashFlow.CountOnDropDownFilter = this._lstcalculationlistCountOnDropDownFilter;
        downloadCashFlow.TransactionCategoryName = transactioncategoryname;
        //downloadCashFlow.PortfolioId = this.PortfolioMasterGuid;
        var flexcalc = this.flex.itemsSource;
        var downloadnotescnt = flexcalc.filter(function (x) { return x.downloadnote == true; }).length;
        if (downloadnotescnt > 0) {
            var noteilds = '';
            //we select only Grid visible rows
            for (var i = 0; i < this.flex.rows.length; i++) {
                if (this.flex.rows[i]._data.downloadnote == true) {
                    noteilds += this.flex.rows[i]._data["CRENoteID"] + ",";
                }
            }
            this._lstcalculationlistCountOnGridFilter = this.flex.rows.length;
            downloadCashFlow.CountOnGridFilter = this._lstcalculationlistCountOnGridFilter;
            //if (downloadnotescnt == this.flex.rows.length)
            if (downloadnotescnt == this.totalcount) {
                if (downloadCashFlow.PortfolioMasterGuid == "00000000-0000-0000-0000-000000000000") {
                    downloadCashFlow.MutipleNoteId = '';
                }
                else {
                    downloadCashFlow.MutipleNoteId = noteilds;
                }
            }
            else {
                downloadCashFlow.MutipleNoteId = noteilds;
            }
            downloadCashFlow.Pagename = "Calc";
            var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '-');
            var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '-');
            var filterednames = "";
            if (this.transacatename.length > 0) {
                for (var j = 0; j < this.transacatename.length; j++) {
                    var filtername = this.transacatename[j];
                    filterednames = filterednames + "_" + filtername;
                }
            }
            else {
                filterednames = "_Default";
            }
            if (filterednames == "_Default") {
                filterednames = "";
            }
            else {
                if (filterednames.indexOf("_Default") >= 0) {
                    filterednames = filterednames.replace("_Default", "");
                }
            }
            var fileName = "CalcMgr" + "_" + this.ScenarioName + filterednames + "_Cashflow_" + displayDate + "_" + displayTime + ".xlsx";
            this.notesvc.getNoteCashflowsExportData(downloadCashFlow).subscribe(function (res) {
                var b = new Blob([res]);
                var dwldLink = document.createElement("a");
                var url = URL.createObjectURL(b);
                var isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
                if (isSafariBrowser) { //if Safari open in new window to save file with random filename.
                    dwldLink.setAttribute("target", "_blank");
                }
                dwldLink.setAttribute("href", url);
                dwldLink.setAttribute("download", fileName);
                dwldLink.style.visibility = "hidden";
                document.body.appendChild(dwldLink);
                dwldLink.click();
                document.body.removeChild(dwldLink);
                _this._isCalcListFetching = false;
            });
        }
        else {
            this.CustomAlert('Please select note(s) for download.');
            this._isCalcListFetching = false;
        }
    };
    CalculationManagerComponent.prototype.fetchXML = function (stores) {
        var wrkbookXML = '';
        for (var i = 0; i < stores.length; i++) {
            var worksheetName = 'Data';
            i == 0 ? worksheetName = 'Canada' : worksheetName = 'India';
            wrkbookXML += '<Worksheet ss:Name="' + worksheetName + '"><Table>';
            var rowXML = '<Column ss:AutoFitWidth="1" ss:Width="450" /><Column ss:AutoFitWidth="1" ss:Width="450" />';
            for (var j = 0; j < stores[i].length; j++) {
                rowXML += '<Row>';
                rowXML += '<Cell><Data ss:Type="String">123</Data></Cell>';
                //rowXML += '<Cell><Data ss:Type="String">' + stores[i][j].state + '</Data></Cell>';
                //rowXML += '<Cell><Data ss:Type="String">' + stores[i][j].occupation + '</Data></Cell>';
                rowXML += '</Row>';
            }
            wrkbookXML += rowXML;
            wrkbookXML += '</Table></Worksheet>';
        }
        return wrkbookXML;
    };
    //downloadFileCalcOutput(CalcDebugFileName, dtNotePeriodicOutputsDataContract, dtDatesTab, dtRateTab, dtBalanceTab, dtFeesTab, dtFeeOutputDataContract, dtCouponTab, dtPIKInterestTab, dtGAAPBasisTab, dtFinancingTab) {
    //    this._user = JSON.parse(localStorage.getItem('user'));
    //    var data_dtNotePeriodicOutputsDataContract = 'Output_Periodic' + '\r\n\n' + this.ConvertToCSV(dtNotePeriodicOutputsDataContract) + '\r\n\n';
    //    var data_dtDatesTab = 'Dates' + '\r\n\n' + this.ConvertToCSV(dtDatesTab) + '\r\n\n';
    //    var data_dtRateTab = 'Rates' + '\r\n\n' + this.ConvertToCSV(dtRateTab) + '\r\n\n';
    //    var data_dtBalanceTab = 'Balance' + '\r\n\n' + this.ConvertToCSV(dtBalanceTab) + '\r\n\n';
    //    var data_dtFeesTab = 'Fees' + '\r\n\n' + this.ConvertToCSV(dtFeesTab) + '\r\n\n';
    //    var data_dtFeeOutputDataContract = 'FeeOutput' + '\r\n\n' + this.ConvertToCSV(dtFeeOutputDataContract) + '\r\n\n';
    //    var data_dtCouponTab = 'Coupon' + '\r\n\n' + this.ConvertToCSV(dtCouponTab) + '\r\n\n';
    //    var data_dtPIKInterestTab = 'PIK_Interest' + '\r\n\n' + this.ConvertToCSV(dtPIKInterestTab) + '\r\n\n';
    //    var data_dtGAAPBasisTab = 'GAAP_Basis' + '\r\n\n' + this.ConvertToCSV(dtGAAPBasisTab) + '\r\n\n';
    //    var data_dtFinancingTab = 'Financing' + '\r\n\n' + this.ConvertToCSV(dtFinancingTab);
    //    var data = data_dtNotePeriodicOutputsDataContract + data_dtDatesTab + data_dtRateTab + data_dtBalanceTab + data_dtFeesTab + data_dtFeeOutputDataContract + data_dtCouponTab + data_dtPIKInterestTab + data_dtGAAPBasisTab + data_dtFinancingTab;
    //    var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '-');
    //    var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '-');
    //    //var fileName = "Cashflow_" + window.localStorage.getItem("ScenarioName") + "_" + displayDate + "_" + displayTime + "_" + this._user.Login + ".csv";
    //    var fileName = CalcDebugFileName + ".csv"; //"CalcMgr_" + this.ScenarioName + "_Cashflow_" + displayDate + "_" + displayTime + ".csv";
    //    let blob = new Blob(['\ufeff' + data], { type: 'text/csv;charset=utf-8;' });
    //    let dwldLink = document.createElement("a");
    //    let url = URL.createObjectURL(blob);
    //    let isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
    //    if (isSafariBrowser) {  //if Safari open in new window to save file with random filename.
    //        dwldLink.setAttribute("target", "_blank");
    //    }
    //    dwldLink.setAttribute("href", url);
    //    dwldLink.setAttribute("download", fileName);
    //    dwldLink.style.visibility = "hidden";
    //    document.body.appendChild(dwldLink);
    //    dwldLink.click();
    //    document.body.removeChild(dwldLink);
    //}
    CalculationManagerComponent.prototype.downloadFile = function (objArray) {
        this._user = JSON.parse(localStorage.getItem('user'));
        var data = this.ConvertToCSV(objArray);
        var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '-');
        var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '-');
        //var fileName = "Cashflow_" + window.localStorage.getItem("ScenarioName") + "_" + displayDate + "_" + displayTime + "_" + this._user.Login + ".csv";
        var filterednames = "";
        if (this.transacatename.length > 0) {
            for (var j = 0; j < this.transacatename.length; j++) {
                var filtername = this.transacatename[j];
                filterednames = filterednames + "_" + filtername;
            }
        }
        else {
            filterednames = "_Default";
        }
        //var fileName = "CalcMgr" + filterednames + "_Cashflow_" + displayDate + "_" + displayTime + ".csv";
        //vishal ===========      
        if (filterednames == "_Default") {
            filterednames = "";
        }
        else {
            if (filterednames.indexOf("_Default") >= 0) {
                filterednames = filterednames.replace("_Default", "");
            }
        }
        var fileName = "CalcMgr" + "_" + this.ScenarioName + filterednames + "_Cashflow_" + displayDate + "_" + displayTime + ".csv";
        //========================
        var blob = new Blob(['\ufeff' + data], { type: 'text/csv;charset=utf-8;' });
        var dwldLink = document.createElement("a");
        var url = URL.createObjectURL(blob);
        var isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
        if (isSafariBrowser) { //if Safari open in new window to save file with random filename.
            dwldLink.setAttribute("target", "_blank");
        }
        dwldLink.setAttribute("href", url);
        dwldLink.setAttribute("download", fileName);
        dwldLink.style.visibility = "hidden";
        document.body.appendChild(dwldLink);
        dwldLink.click();
        document.body.removeChild(dwldLink);
    };
    // convert Json to CSV data in Angular2
    CalculationManagerComponent.prototype.ConvertToCSV = function (objArray) {
        var array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
        var str = '';
        var row = "";
        for (var index in objArray[0]) {
            //Now convert each value to string and comma-separated
            row += index + ',';
        }
        row = row.slice(0, -1);
        //append Label row with line break
        str += row + '\r\n';
        for (var i = 0; i < array.length; i++) {
            var line = '';
            for (var index in array[i]) {
                if (line != '')
                    line += ',';
                line += array[i][index];
            }
            str += line + '\r\n';
        }
        return str;
    };
    CalculationManagerComponent.prototype.subscribetoevent = function () {
        var _this = this;
        this._signalRService.updateCalcNotification.subscribe(function (message) {
            var res = message.split('|*|');
            if (res[0] == "CALCMGR" && res[1] == appsettings_1.AppSettings._notificationenvironment) {
                //let timer = TimerObservable.create(6000, 6000);
                //this.subscription = timer.subscribe(t => { this.GetCalcStatus(); });
                _this.finalCall = 1;
                _this.GetCalcStatus();
            }
        });
    };
    CalculationManagerComponent.prototype.GetUserPermission = function () {
        var _this = this;
        try {
            this.permissionService.GetUserPermissionByPagename("CalculationManager").subscribe(function (res) {
                if (res.Succeeded) {
                    if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                        var _object = res.UserPermissionList;
                        var controlarrayedit = _object.filter(function (item) { return item.ModuleType === 'Control' && item.RightsName === 'Edit'; });
                        for (var i = 0; i < controlarrayedit.length; i++) {
                            if (controlarrayedit[i].ChildModule == 'btnCalculationManagerDownloadCashflows') {
                                _this._isShowDownloadCashflows = true;
                            }
                        }
                    }
                }
            });
        }
        catch (err) {
            alert(err);
        }
    };
    CalculationManagerComponent.prototype.GetAllLookups = function () {
        var _this = this;
        this.notesvc.getAllLookupById().subscribe(function (res) {
            var data = res.lstLookups;
            _this.lstCalculationMode = data.filter(function (x) { return x.ParentID == "79"; });
        });
    };
    CalculationManagerComponent.prototype.getAllDistinctScenario = function () {
        var _this = this;
        var _userData = JSON.parse(localStorage.getItem('user'));
        this._scenariodc.UserID = _userData.UserID;
        this.scenarioService.getAllScenarioDistinct(this._scenariodc).subscribe(function (res) {
            if (res.Succeeded) {
                if (res.lstScenarioUserMap.length > 0) {
                    _this._lstScenario = res.lstScenarioUserMap;
                    _this.ScenarioId = res.lstScenarioUserMap.filter(function (x) { return x.ScenarioName == "Default"; })[0].AnalysisID;
                    _this.ScenarioName = res.lstScenarioUserMap.filter(function (x) { return x.ScenarioName == "Default"; })[0].ScenarioName;
                    _this._scenariodc.AnalysisID = _this.ScenarioId;
                    _this._calculationManager.AnalysisID = _this.ScenarioId;
                    _this.isAllowDebugInCalc = _this._lstScenario[0].AllowDebugInCalc;
                    _this.flex.invalidate();
                }
            }
        });
    };
    CalculationManagerComponent.prototype.changeScenario = function (value) {
        this._lstcalculationlistCount = 1;
        this.ScenarioId = value;
        this._scenariodc.AnalysisID = this.ScenarioId;
        this._calculationManager.AnalysisID = this.ScenarioId;
        this.ScenarioName = this._lstScenario.filter(function (x) { return x.AnalysisID == value; })[0].ScenarioName;
        this.RefreshCalculationStatus();
    };
    CalculationManagerComponent.prototype.ddlScenarioChange = function (obj) {
        this.ScenarioId = obj;
        //this._calculationManager.AnalysisID = this.ScenarioId;
    };
    CalculationManagerComponent.prototype.ddlCalculationMode = function (obj) {
        this.CalculationModeID = obj;
    };
    CalculationManagerComponent.prototype.GetBatchLog = function () {
        var _this = this;
        this._isExceptionListFetching = true;
        // this._ExceptionListCount = 0;
        this.calculationsvc.getbatchlog(this._batchcalc).subscribe(function (res) {
            if (res.Succeeded) {
                setTimeout(function () {
                    _this.flexbatch.invalidate(true);
                }, 200);
                if (res.lstBatchCalculationMaster.length > 0) {
                    _this.lstbatchlog = res.lstBatchCalculationMaster;
                    _this.ConvertToBindableBatchLog(_this.lstbatchlog, "", "en-US");
                    _this._lstlstbatchlogCount = res.lstBatchCalculationMaster.length;
                }
                else
                    _this._lstlstbatchlogCount = 0;
            }
            _this._isExceptionListFetching = false;
        });
    };
    CalculationManagerComponent.prototype.ConvertToBindableBatchLog = function (Data, modulename, locale) {
        var options = { year: "numeric", month: "numeric", day: "numeric" };
        for (var i = 0; i < Data.length; i++) {
            if (this.lstbatchlog[i].StartTime != null) {
                this.lstbatchlog[i].StartTime = new Date(this.lstbatchlog[i].StartTime.toString());
            }
            if (this.lstbatchlog[i].EndTime != null) {
                this.lstbatchlog[i].EndTime = new Date(this.lstbatchlog[i].EndTime.toString());
            }
        }
    };
    CalculationManagerComponent.prototype.HideMenu = function () {
        var ret_val = false;
        var rolename = window.localStorage.getItem("rolename");
        if (rolename != null) {
            if (rolename.toString() == "Super Admin") {
                ret_val = true;
            }
        }
        return ret_val;
    };
    CalculationManagerComponent.prototype.DownloadCalcOutputExcel = function (FileName) {
        var _this = this;
        this._isCalcListFetching = true;
        this.calcObjForDownload.FileName = FileName;
        this.calculationsvc.downloadfilecalcoutput(this.calcObjForDownload).subscribe(function (res) {
            if (res.Succeeded) {
                _this._ShowSuccessmessagediv = true;
                _this._ShowSuccessmessage = "Downloading the output excel.";
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                    this._isCalcListFetching = false;
                }.bind(_this), 5000);
                if (res.Enablem61Calculation == "true") {
                    _this.exportToExcel(res.CalcDebugFileName, [res.dtNotePeriodicOutputsDataContract], ['V1_Output']);
                }
                else {
                    _this.exportToExcel(res.CalcDebugFileName, [res.dtNotePeriodicOutputsDataContract, res.dtDatesTab, res.dtRateTab, res.dtFeesTab, res.dtFeeOutputDataContract, res.dtBalanceTab, res.dtCouponTab, res.dtPIKInterestTab, res.dtGAAPBasisTab, res.dtFutureFundingScheduleTab, res.dtMaturityList], ['Output_Periodic', 'Dates', 'Rates', 'Fees', 'FeeOutput', 'BalanceTab', 'Coupon', 'PIK_Interest', 'GAAP_Basis', 'Future_Funding_Schedule', 'Maturity_Dates']);
                }
                _this._isCalcListFetching = false;
            }
            else {
                _this._Showmessagediv = true;
                _this.Message = "Some error occurred while downloading.";
                setTimeout(function () {
                    this._Showmessagediv = false;
                    this._isCalcListFetching = false;
                }.bind(_this), 5000);
            }
            (function (error) { return console.error('Error: ' + error); });
        });
        ////this._isListFetching = true;
        //this.fileUploadService.downloadfilecalcoutput(this.calcObjForDownload).subscribe(fileData => {
        //    let b: any = new Blob([fileData]);
        //    //var url = window.URL.createObjectURL(b);
        //    //window.open(url);
        //    var displayDate = new Date().toLocaleDateString("en-US");
        //    var fileName = "M61_Wells_Export_";//+ this._deal.CREDealID + "_" + displayDate + ".xlsx";
        //    let dwldLink = document.createElement("a");
        //    let url = URL.createObjectURL(b);
        //    let isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
        //    if (isSafariBrowser) {  //if Safari open in new window to save file with random filename.
        //        dwldLink.setAttribute("target", "_blank");
        //    }
        //    dwldLink.setAttribute("href", url);
        //    dwldLink.setAttribute("download", fileName);
        //    dwldLink.style.visibility = "hidden";
        //    document.body.appendChild(dwldLink);
        //    dwldLink.click();
        //    document.body.removeChild(dwldLink);
        //    //this._isListFetching = false;
        //},
        //    error => {
        //        alert('Something went wrong');
        //        //this._isListFetching = false;;
        //    }
        //);
    };
    CalculationManagerComponent.prototype.exportToExcel = function (filename, arr, sheets) {
        var fileName = filename + '.xlsx';
        var ws = XLSX.WorkSheet;
        var wb = XLSX.WorkBook;
        wb = XLSX.utils.book_new();
        // if res.dtPIKInterestTab is null
        if (arr[6] == '' || arr[6] == 'undefined') {
            arr = [arr[0], arr[1], arr[2], arr[3], arr[4], arr[5], arr[7]];
            sheets = [sheets[0], sheets[1], sheets[2], sheets[3], sheets[4], sheets[5], sheets[7]];
        }
        wb.Props = {
            Title: "CRES",
            Subject: fileName,
            Author: "M61",
            CreatedDate: Date.now()
        };
        for (var i = 0; i < arr.length; i++) {
            ws = XLSX.utils.json_to_sheet(arr[i]);
            XLSX.utils.book_append_sheet(wb, ws, sheets[i]);
        }
        XLSX.writeFile(wb, fileName);
    };
    CalculationManagerComponent.prototype.GettimezoneCurrentOffset = function () {
        var _this = this;
        this.calculationsvc.GettimezoneCurrentOffset().subscribe(function (res) {
            if (res.Succeeded) {
                _this.currentoffset = res.currentoffset;
            }
        });
    };
    CalculationManagerComponent.prototype.ConvertTimeaccordingtoUser = function (data) {
        var usertimezone = this._user.TimeZone;
        var dt;
        var a = this.currentoffset.split(":");
        for (var k = 0; k < data.length; k++) {
            var calcstarttime = data[k].StartTime;
            var calcendtime = data[k].EndTime;
            if (calcstarttime != null) {
                var d = new Date(calcstarttime);
                var hour = d.getHours() + parseInt(a[0]);
                var minutes = d.getMinutes() + parseInt(a[1]);
                var seconds = d.getSeconds();
                if (hour < 0) {
                    hour = 12 + (hour);
                    //   dt = d.getDate() - 1;
                }
                else {
                    hour = hour;
                    // dt = d.getDate();
                }
                if (seconds > 60) {
                    seconds = seconds - 60;
                    minutes = minutes + seconds;
                }
                if (minutes > 60) {
                    minutes = minutes - 60;
                    hour = hour + 1;
                }
                dt = d.getDate();
                //var dat = (dt < 10) ? '0' + dt : dt;
                var dat = dt;
                var month = d.getMonth() + 1;
                var mth = (month < 10) ? '0' + month : month;
                var year = d.getFullYear();
                var d1 = (hour < 10) ? '0' + hour : hour;
                var d2 = (minutes < 10) ? '0' + minutes : minutes;
                var d3 = (seconds < 10) ? '0' + seconds : seconds;
                var newtime = mth + "-" + dat + "-" + year + " " + d1 + ":" + d2 + ":" + d3;
                data[k].StartTime = newtime;
            }
            if (calcendtime != null) {
                var d = new Date(calcendtime);
                var hour = d.getHours() + parseInt(a[0]);
                var minutes = d.getMinutes() + parseInt(a[1]);
                var seconds = d.getSeconds();
                if (hour < 0) {
                    hour = 12 + (hour);
                    //dt = d.getDate() - 1
                }
                else {
                    hour = hour;
                    // dt = d.getDate();
                }
                dt = d.getDate();
                if (seconds > 60) {
                    seconds = seconds - 60;
                    minutes = minutes + seconds;
                }
                if (minutes > 60) {
                    minutes = minutes - 60;
                    hour = hour + 1;
                }
                //var dat = (dt < 10) ? '0' + dt : dt;
                var dat = dt;
                var month = d.getMonth() + 1;
                var mth = (month < 10) ? '0' + month : month;
                var year = d.getFullYear();
                var d1 = (hour < 10) ? '0' + hour : hour;
                var d2 = (minutes < 10) ? '0' + minutes : minutes;
                var d3 = (seconds < 10) ? '0' + seconds : seconds;
                var newtime = mth + "-" + dat + "-" + year + " " + d1 + ":" + d2 + ":" + d3;
                data[k].EndTime = newtime;
            }
        }
    };
    CalculationManagerComponent.prototype.GetTransactionCategory = function () {
        var _this = this;
        this.calculationsvc.GetTransactionCategory().subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.dt;
                _this.listtransactioncategory = data;
                //this.listtransactioncategory.forEach((objparent, i) => { // FETCH ALL DATA AND PUSH IN FLEX GRID!!!
                //    data.TransactionCategory.split(/\s*,\s*/).forEach((obj, j) => {
                //        if (objparent.TransactionCategory == obj) {
                //            this.listtransactioncategory[i].selected = true;
                //        }
                //    });
            }
        });
    };
    __decorate([
        (0, core_1.ViewChild)('flexcalculation'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], CalculationManagerComponent.prototype, "flex", void 0);
    __decorate([
        (0, core_1.ViewChild)('flexnoteexceptions'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], CalculationManagerComponent.prototype, "flexnoteexceptions", void 0);
    __decorate([
        (0, core_1.ViewChild)('flextestcase'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], CalculationManagerComponent.prototype, "flextestcase", void 0);
    __decorate([
        (0, core_1.ViewChild)('filter'),
        __metadata("design:type", wjNg2GridFilter.WjFlexGridFilter)
    ], CalculationManagerComponent.prototype, "gridFilter", void 0);
    __decorate([
        (0, core_1.ViewChild)('flexbatch'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], CalculationManagerComponent.prototype, "flexbatch", void 0);
    __decorate([
        (0, core_1.ViewChild)('multiseltransactioncategory'),
        __metadata("design:type", wjNg2Input.WjMultiSelect)
    ], CalculationManagerComponent.prototype, "multiseltransactioncategory", void 0);
    CalculationManagerComponent = __decorate([
        (0, core_1.Component)({
            templateUrl: "app/components/CalculationManager.html",
            providers: [CalculationManagerService_1.CalculationManagerService, NoteService_1.NoteService, PermissionService_1.PermissionService, portfolioService_1.portfolioService, scenarioService_1.scenarioService, fileuploadservice_1.FileUploadService]
        }),
        __metadata("design:paramtypes", [router_1.Router,
            NoteService_1.NoteService,
            CalculationManagerService_1.CalculationManagerService,
            PermissionService_1.PermissionService,
            utilityService_1.UtilityService,
            signalRService_1.SignalRService,
            portfolioService_1.portfolioService,
            scenarioService_1.scenarioService,
            fileuploadservice_1.FileUploadService,
            platform_browser_1.DomSanitizer])
    ], CalculationManagerComponent);
    return CalculationManagerComponent;
}(paginated_1.Paginated));
exports.CalculationManagerComponent = CalculationManagerComponent;
var routes = [
    { path: '', component: CalculationManagerComponent }
];
var CalculationManagerModule = /** @class */ (function () {
    function CalculationManagerModule() {
    }
    CalculationManagerModule = __decorate([
        (0, core_2.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule, wijmo_angular2_input_1.WjInputModule, wijmo_angular2_core_1.WjCoreModule],
            declarations: [CalculationManagerComponent]
        })
    ], CalculationManagerModule);
    return CalculationManagerModule;
}());
exports.CalculationManagerModule = CalculationManagerModule;
//# sourceMappingURL=calculationmanager.component.js.map