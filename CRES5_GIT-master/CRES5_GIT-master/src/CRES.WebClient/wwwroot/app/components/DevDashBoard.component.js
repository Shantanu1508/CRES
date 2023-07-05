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
exports.DevDashBoardModule = exports.DevDashBoardComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var wjcGrid = require("wijmo/wijmo.grid");
var core_2 = require("@angular/core");
var paginated_1 = require("../core/common/paginated");
var utilityService_1 = require("../core/services/utilityService");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wjcChart = require("wijmo/wijmo.chart");
var loggingService_1 = require("./../core/services/loggingService");
var wijmo_angular2_chart_1 = require("wijmo/wijmo.angular2.chart");
var wijmo_angular2_input_1 = require("wijmo/wijmo.angular2.input");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var wjcChartInteraction = require("wijmo/wijmo.chart.interaction");
var wijmo_angular2_chart_interaction_1 = require("wijmo/wijmo.angular2.chart.interaction");
var reportservice_1 = require("./../core/services/reportservice");
var devDashBoardService_1 = require("../core/services/devDashBoardService");
var TaskManagerService_1 = require("../core/services/TaskManagerService");
var search_1 = require("../core/domain/search");
var membershipservice_1 = require("../core/services/membershipservice");
var Note_1 = require("../core/domain/Note");
var NoteService_1 = require("../core/services/NoteService");
var CalculationManagerService_1 = require("../core/services/CalculationManagerService");
var Scenario_1 = require("../core/domain/Scenario");
var scenarioService_1 = require("../core/services/scenarioService");
var devdashboard_1 = require("./../core/domain/devdashboard");
var DevDashBoardComponent = /** @class */ (function (_super) {
    __extends(DevDashBoardComponent, _super);
    function DevDashBoardComponent(devDashBoardService, taskManagerService, notesvc, membershipService, reportService, calculationsvc, utilityService, scenarioService, loggingService, _router) {
        var _this = _super.call(this, 50, 1, 0) || this;
        _this.devDashBoardService = devDashBoardService;
        _this.taskManagerService = taskManagerService;
        _this.notesvc = notesvc;
        _this.membershipService = membershipService;
        _this.reportService = reportService;
        _this.calculationsvc = calculationsvc;
        _this.utilityService = utilityService;
        _this.scenarioService = scenarioService;
        _this.loggingService = loggingService;
        _this._router = _router;
        _this.FirstCall = 0;
        _this.refreshcount = 0;
        _this._isFetching = false;
        _this.selectedSeries = [];
        _this.chartType = 'Column';
        _this._isNoteListFetching = false;
        _this._ShowmessagedivMsgWar = false;
        _this._WaringMessage = '';
        _this.pal = 0;
        _this.Failed = 0;
        _this.Remainingnotes = 0;
        _this._groupWidth = '70%';
        _this.Completed = 0;
        _this.CalcSubmit = 0;
        _this.Running = 0;
        _this.Processing = 0;
        _this.firstcall = 1;
        _this.Dependents = 0;
        _this.TotalCalculationtimeinmin = 0;
        _this.Fastest = 0;
        _this.Slowest = 0;
        _this.Pending = 0;
        _this.CalcProgress = 0;
        _this.palettes = 'standard,cocoa,coral,dark,highcontrast,light,midnight,modern,organic,slate,zen,cyborg,superhero,flatly,darkly,cerulan'.split(',');
        _this.labels = 0;
        _this.lblBorder = false;
        _this.TotalConversionsMonth = 0;
        _this.TotalConversionsWeek = 0;
        _this.TotalConversionsToday = 0;
        _this.TotalSentMessages = 0;
        _this.TotalReceivedMessages = 0;
        _this.DailyAverage = 0;
        _this.firsttime = 0;
        _this._cachedeal = {};
        _this._pageSizeSearch = 10;
        _this._pageIndexSearch = 1;
        _this._totalCountSearch = 0;
        _this._isShowLoader = false;
        _this.getAutosuggestusername = _this.getAutosuggestusernameFunc.bind(_this);
        _this._scenariodc = new Scenario_1.Scenario('');
        _this._lstScenario = _this._scenariodc.LstScenarioUserMap;
        _this.getAllDistinctScenario();
        _this.ScenarioId = window.localStorage.getItem("scenarioid");
        _this.utilityService.setPageTitle("Dev-DashBoard");
        var _date = new Date();
        _this._devDashBoard = new devdashboard_1.devDashBoard('');
        _this._dtUTCHours = _date.getTimezoneOffset() / 60;
        _this._userOffset = _date.getTimezoneOffset() * 60 * 1000; // user's offset time
        if (_this._dtUTCHours < 6) {
            _this._centralOffset = 6 * 60 * 60 * 1000; // 6 for central time - use whatever you need
        }
        else {
            _this._centralOffset = _this._dtUTCHours * 60 * 60 * 1000; // 6 for central time - use whatever you need
        }
        _this.GetStagingDataIntoIntegrationStatus();
        _this.getallStatus();
        return _this;
    }
    DevDashBoardComponent.prototype.stRendered = function () {
        var stChart = this.chart;
        if (!stChart) {
            return;
        }
        stChart.axisX.labels = false;
        stChart.axisX.axisLine = false;
        stChart.legend.position = 0;
    };
    DevDashBoardComponent.prototype.getData = function () {
        var countries = 'US,Germany,UK,Japan,Italy,Greece'.split(','), data = [];
        for (var i = 0; i < countries.length; i++) {
            data.push({
                country: countries[i],
                sales: Math.random() * 10000,
            });
        }
        return data;
    };
    DevDashBoardComponent.prototype.selectionChanged = function (s, e) {
        if (s.selection) {
            this._isFetching = true;
            var value = s.selection.collectionView.currentItem.ProcessType;
            this.Logtype = value;
            this.showDialogCustom("myModalLog");
            this.getLogByType(value);
        }
    };
    DevDashBoardComponent.prototype.stErrorRendered = function () {
        var stChart = this.ErrorMatrix;
        var value = "20px";
        if (!stChart) {
            return;
        }
        stChart.palette = ['rgba(255, 54, 54)'];
        stChart.axisX.labels = true;
        stChart.axisY.labels = true;
        stChart.legend.position = 0;
    };
    DevDashBoardComponent.prototype.rsRendered = function () {
        var rsChart = this.rsChart;
        if (!rsChart) {
            return;
        }
        rsChart.axisY.labels = false;
        rsChart.axisY.majorGrid = false;
    };
    DevDashBoardComponent.prototype.rangeChanged = function () {
        if (this.chart && this.rangeSelector) {
            this.chart.axisX.min = this.rangeSelector.min;
            this.chart.axisX.max = this.rangeSelector.max;
            this.chart.invalidate();
        }
    };
    DevDashBoardComponent.prototype.getEnumNames = function (enumClass) {
        var names = [];
        for (var key in enumClass) {
            var val = parseInt(key);
            if (isNaN(val))
                names.push(key);
        }
        return names;
    };
    DevDashBoardComponent.prototype.showDialogCustom = function (controlid) {
        var modalRole = document.getElementById(controlid);
        modalRole.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    DevDashBoardComponent.prototype.ShowModalConfirmTag = function (controlid) {
        var _this = this;
        var ScenarioName = this._lstScenario.find(function (x) { return x.AnalysisID == _this.ScenarioId; }).ScenarioName;
        this.GenericDialogBody = "Are you sure want to calculate all notes for " + ScenarioName + " scenario.";
        var modalDelete = document.getElementById(controlid);
        modalDelete.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    DevDashBoardComponent.prototype.GCloseCreatePopUp = function (controlid) {
        var modal = document.getElementById(controlid);
        modal.style.display = "none";
    };
    DevDashBoardComponent.prototype.getPieChartData = function () {
        // populate itemsSource
        var names = ['Oranges', 'Apples', 'Pears', 'Bananas', 'Pineapples'];
        var data = [];
        for (var i = 0; i < names.length; i++) {
            data.push({
                name: names[i],
                value: Math.round(Math.random() * 100)
            });
        }
        this.itemsSource = data;
    };
    DevDashBoardComponent.prototype.getCalculationStatus = function () {
        var _this = this;
        try {
            this.devDashBoardService.getCalculationStatus(this.ScenarioId).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.CalculationRequesttime = new Date().toLocaleString();
                    _this.FastestNoteID = 0;
                    _this.Completed = 0;
                    _this.Processing = 0;
                    _this.Dependents = 0;
                    _this.Running = 0;
                    _this.Remainingnotes = 0;
                    _this.TotalCalculationtimeinmin = 0;
                    _this.Pending = 0;
                    var data = [];
                    _this.Avgtime = 0;
                    _this.Failed = 0;
                    _this.CalcSubmit = 0;
                    _this.CalcProgress = 0;
                    _this.Slowest = 0;
                    _this.SlowestNoteID = "";
                    _this.Fastest = 0;
                    _this.FastestNoteID = "";
                    var result = res.CalculationStatus;
                    var resuser = res.UserRequestCount;
                    var fastslow = res.FastestandSlowest;
                    for (var i = 0; i < resuser.length; i++) {
                        data.push({
                            name: resuser[i].Name,
                            value: resuser[i].value
                        });
                    }
                    //get fastest
                    for (var i = 0; i < fastslow.length; i++) {
                        if (fastslow[i].Name == "Max Time") {
                            _this.Fastest = fastslow[i].value;
                            _this.FastestNoteID = fastslow[i].CRENoteID;
                        }
                        if (fastslow[i].Name == "Min Time") {
                            _this.Slowest = fastslow[i].value;
                            _this.SlowestNoteID = fastslow[i].CRENoteID;
                        }
                    }
                    for (var i = 0; i < result.length; i++) {
                        if (result[i].Name == "Failed") {
                            _this.Failed = result[i].value;
                        }
                        if (result[i].Name == "Completed") {
                            _this.Completed = result[i].value;
                        }
                        if (result[i].Name == "CalcSubmit") {
                            _this.CalcSubmit = result[i].value;
                        }
                        if (result[i].Name == "Running") {
                            _this.Running = result[i].value;
                        }
                        if (result[i].Name == "Processing") {
                            _this.Processing = result[i].value;
                        }
                        if (result[i].Name == "Dependents") {
                            _this.Dependents = result[i].value;
                        }
                        if (result[i].Name == "Total Calculation time in min") {
                            _this.TotalCalculationtimeinmin = result[i].value;
                        }
                    }
                    _this.Remainingnotes = _this.Processing + _this.Dependents + _this.CalcSubmit;
                    _this.Pending = _this.Processing + _this.Dependents + _this.Running + _this.CalcSubmit;
                    if (_this.Completed != null && _this.Completed != 0 && _this.TotalCalculationtimeinmin != null && _this.TotalCalculationtimeinmin != 0) {
                        _this.Avgtime = (_this.Completed / _this.TotalCalculationtimeinmin);
                        _this.Avgtime = parseFloat(_this.Avgtime.toString()).toFixed(2);
                    }
                    if (_this.Completed != null && _this.Completed != 0 && _this.Pending != 0 && _this.Pending != null) {
                        _this.CalcProgress = Math.round((_this.Completed / (_this.Pending + _this.Completed)) * 100);
                    }
                    else if (_this.Pending == 0 && _this.Completed != 0) {
                        _this.CalcProgress = 100;
                    }
                    if (_this.CalcProgress > 100) {
                        _this.CalcProgress = 100;
                    }
                    _this.itemsSource = data;
                    if (_this.Pending === undefined || _this.Pending === null) {
                        _this.Pending = 0;
                    }
                    if (_this.FirstCall == 0) {
                        _this.FirstCall = 1;
                        _this.GetCalcStatus();
                    }
                }
                else {
                }
            });
        }
        catch (err) {
        }
    };
    DevDashBoardComponent.prototype.GetCalcStatus = function () {
        var _this = this;
        if (this.Pending === undefined || this.Pending === null) {
            this.Pending = 0;
        }
        if (this.Pending != 0) {
            this.FirstCall = 1;
            this.calculationsvc.calcstatus().subscribe(function (res) {
                if (res.Succeeded) {
                    _this.refreshcount = res.TotalCount;
                    if (_this.refreshcount > 0) {
                        _this.getCalculationStatus();
                        setTimeout(function () {
                            _this.GetCalcStatus();
                        }, 20000);
                    }
                    else if (_this.refreshcount == 0) //For call once again after complete all process.
                     {
                        _this.getCalculationStatus();
                        // this.getFailedNotes();
                    }
                }
            });
        }
        else {
            // upate status to final time
            this.getCalculationStatus();
            // this.getFailedNotes();
        }
    };
    DevDashBoardComponent.prototype.GetCalculationJson = function () {
        var _this = this;
        try {
            this._isFetching = true;
            this._devDashBoard.NoteID = this.CREnoteID;
            this._devDashBoard.ScenarioID = this.ScenarioId;
            this.devDashBoardService.getCalcJson(this._devDashBoard).subscribe(function (res) {
                if (res.Succeeded) {
                    var data = res.NoteData;
                    var jsonname = "Note_" + _this.CREnoteID + "_Calc.json";
                    _this.downloadJson(data, jsonname);
                    _this._isFetching = false;
                }
                else {
                    _this._isFetching = false;
                }
            });
        }
        catch (err) {
            this._isFetching = false;
        }
    };
    DevDashBoardComponent.prototype.ShowCalcDashBoardData = function () {
        setTimeout(function () {
            if (this.ErrorMatrix) {
                this.ErrorMatrix.invalidate();
            }
        }.bind(this), 1000);
    };
    DevDashBoardComponent.prototype.CalculateMultipleNote = function () {
        var _this = this;
        try {
            this._devDashBoard.NoteID = this.multipleCREnoteID;
            this._devDashBoard.ScenarioID = this.ScenarioId;
            this.devDashBoardService.CalculateMultipleNotes(this._devDashBoard).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.multipleCREnoteID = "";
                    _this._ShowmessagedivMsgWar = true;
                    _this.GetCalcStatus();
                    _this._WaringMessage = "Notes queued for calculation";
                    _this.GCloseCreatePopUp("myModalCalculate");
                    setTimeout(function () {
                        this._ShowmessagedivMsgWar = false;
                    }.bind(_this), 5000);
                }
                else {
                }
            });
        }
        catch (err) {
        }
    };
    DevDashBoardComponent.prototype.CalcAllNotes = function () {
        var _this = this;
        try {
            this._isShowLoader = true;
            this.devDashBoardService.CalcAllNotes(this.ScenarioId).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.multipleCREnoteID = "";
                    _this._ShowmessagedivMsgWar = true;
                    _this.GetCalcStatus();
                    _this._WaringMessage = "Notes queued for calculation";
                    _this.GCloseCreatePopUp("myModalConfirmTag");
                    _this._isShowLoader = false;
                    setTimeout(function () {
                        this._ShowmessagedivMsgWar = false;
                    }.bind(_this), 5000);
                }
                else {
                }
            });
        }
        catch (err) {
        }
    };
    DevDashBoardComponent.prototype.downloadJson = function (myJson, filename) {
        var sJson = JSON.stringify(myJson);
        var element = document.createElement('a');
        element.setAttribute('href', "data:text/json;charset=UTF-8," + encodeURIComponent(sJson));
        element.setAttribute('download', filename);
        element.style.display = 'none';
        document.body.appendChild(element);
        element.click();
        document.body.removeChild(element);
    };
    DevDashBoardComponent.prototype.getTwoDigitString = function (number) {
        if (number.toString().length === 1)
            return "0" + number;
        return number;
    };
    DevDashBoardComponent.prototype.convertDateToBindableWithTime = function (date) {
        var dateObj = new Date(date);
        return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear() + " " + dateObj.getHours() + ":" + dateObj.getMinutes() + ":" + dateObj.getSeconds();
    };
    DevDashBoardComponent.prototype.warehouseStatus = function (btnname) {
        var _this = this;
        if (btnname === void 0) { btnname = "Refresh Data Warehouse"; }
        this.reportService.GetwarehouseStatus(btnname).subscribe(function (res) {
            if (res.Succeeded) {
                if (res.Status2 == "Process Running") {
                    _this.Status4 = res.Status2;
                    _this.BatchEndTime4 = '';
                }
                else if (res.Status2 == "Process InComplete") {
                    _this.Status4 = res.Status2 + '\r \n Last Updated ';
                    _this.BatchEndTime4 = res.BatchEndTime;
                    // this.BatchEndTime4 = this.convertDateToBindableWithTime(res.BatchEndTime);
                }
                else {
                    _this.Status4 = res.Status2 + '\r \n Last Updated ';
                    _this.BatchEndTime4 = res.BatchEndTime;
                    // this.BatchEndTime4 = this.convertDateToBindableWithTime(res.BatchEndTime);
                }
            }
        });
    };
    DevDashBoardComponent.prototype.RefreshReport = function () {
        var _this = this;
        var d = new Date();
        var datestring = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate() + " " +
            d.getHours() + ":" + d.getMinutes();
        this.devDashBoardService.RefreshDataWarehouse(datestring).subscribe(function (res) {
            if (res.Succeeded) {
                _this._ShowmessagedivMsgWar = true;
                _this._WaringMessage = res.Message;
                setTimeout(function () {
                    this._ShowmessagedivMsgWar = false;
                }.bind(_this), 5000);
            }
            else {
            }
        });
    };
    DevDashBoardComponent.prototype.importStagingData = function () {
        var _this = this;
        this.devDashBoardService.importStagingData().subscribe(function (res) {
            if (res.Succeeded) {
                _this.CustomAlert(res.Message);
            }
            else {
            }
        });
    };
    DevDashBoardComponent.prototype.GetStagingDataIntoIntegrationStatus = function () {
        var _this = this;
        try {
            this._isFetching = true;
            this.devDashBoardService.GetStagingDataIntoIntegrationStatus().subscribe(function (res) {
                if (res.Succeeded) {
                    _this.lstimportdataStatus = res.ImportDataStatus;
                    _this._isFetching = false;
                }
                else {
                    _this._isFetching = false;
                }
            });
        }
        catch (err) {
            this._isFetching = false;
        }
    };
    DevDashBoardComponent.prototype.getLogByType = function (logtype) {
        var _this = this;
        try {
            this.lstcalculationlist = null;
            this.devDashBoardService.getFailedNotes(logtype).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.lstcalculationlist = res.CalculationStatus;
                    for (var i = 0; i < _this.lstcalculationlist.length; i++) {
                        if (_this.lstcalculationlist[i].RequestTime != null) {
                            var d = new Date(_this.lstcalculationlist[i].RequestTime.toString());
                            var _month = d.getMonth() + 1;
                            var month = (_month < 10) ? '0' + _month : _month;
                            var amOrPm = (d.getHours() < 12) ? "AM" : "PM";
                            var hour = (d.getHours() < 12) ? d.getHours() : d.getHours() - 12;
                            var hr = (hour < 10) ? '0' + hour : hour;
                            var date = (d.getDate() < 10) ? '0' + d.getDate() : d.getDate();
                            var minutes = (d.getMinutes() < 10) ? '0' + d.getMinutes() : d.getMinutes();
                            _this.lstcalculationlist[i].RequestTime = month + '-' + date + '-' + d.getFullYear() + ' ' + hr + ':' + minutes + ' ' + amOrPm;
                        }
                        if (_this.lstcalculationlist[i].FundingOrEndTime != null) {
                            _this.lstcalculationlist[i].FundingOrEndTime = new Date(_this.lstcalculationlist[i].FundingOrEndTime.toString());
                        }
                    }
                    setTimeout(function () {
                        if (_this.flex) {
                            var flexGrid = _this.flex;
                            if (_this.Logtype != "Deal" && _this.Logtype != "Note") {
                                var columns = flexGrid.columns;
                                columns[1].visible = false;
                                columns[0].visible = false;
                                flexGrid.invalidate();
                            }
                            if (_this.Logtype == "Deal" || _this.Logtype == "Note") {
                                var columns = flexGrid.columns;
                                columns[1].visible = true;
                                columns[0].visible = true;
                                flexGrid.invalidate();
                            }
                        }
                    }, 500);
                    _this._isFetching = false;
                }
                else {
                    _this._isFetching = false;
                    _this.lstcalculationlist = null;
                }
            });
        }
        catch (err) {
        }
    };
    DevDashBoardComponent.prototype.flexcalculationInitialized = function (flexGrid) {
        if (this.Logtype == "Calculator") {
            var columns = flexGrid.columns;
            columns[1].visible = false;
        }
    };
    DevDashBoardComponent.prototype.downloadNoteCashflowsExportData = function () {
        var _this = this;
        this._isNoteListFetching = true;
        this._note = new Note_1.Note('');
        var downloadCashFlow = new Note_1.DownloadCashFlow();
        downloadCashFlow.NoteId = "00000000-0000-0000-0000-000000000000";
        downloadCashFlow.DealID = "00000000-0000-0000-0000-000000000000";
        downloadCashFlow.AnalysisID = window.localStorage.getItem("scenarioid");
        downloadCashFlow.MutipleNoteId = "";
        try {
            this.notesvc.getNoteCashflowsExportData(downloadCashFlow).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.downloadFile(res.lstNoteCashflowsExportData);
                    _this._isNoteListFetching = false;
                }
                else {
                    _this._isNoteListFetching = false;
                }
            });
        }
        catch (err) {
            alert("Error in cashflow download");
            this._isNoteListFetching = false;
        }
    };
    DevDashBoardComponent.prototype.downloadFile = function (objArray) {
        var data = this.ConvertToCSV(objArray);
        var displayDate = new Date().toLocaleDateString("en-US");
        var fileName = "NoteCashflow-" + displayDate + ".csv";
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
    DevDashBoardComponent.prototype.ConvertToCSV = function (objArray) {
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
    DevDashBoardComponent.prototype.getallStatus = function () {
        try {
            //  arguments.callee.toString();
            this.loggingService.writeToLog("DevDashBoard", "info", "testing");
            this.GetErrorCount();
            this.GetCalcStatus();
            //this.getFailedNotes();
            //this.GetDWStatus();
        }
        catch (err) {
            this.loggingService.writeToLog("DevDashBoard", "error", err.stack);
        }
    };
    DevDashBoardComponent.prototype.getAllDistinctScenario = function () {
        var _this = this;
        var _userData = JSON.parse(localStorage.getItem('user'));
        this._scenariodc.UserID = _userData.UserID;
        this.scenarioService.getAllScenarioDistinct(this._scenariodc).subscribe(function (res) {
            if (res.Succeeded) {
                if (res.lstScenarioUserMap.length > 0) {
                    _this._lstScenario = res.lstScenarioUserMap;
                    _this.ScenarioId = res.lstScenarioUserMap.filter(function (x) { return x.ScenarioName == "Default"; })[0].AnalysisID;
                    //this.ScenarioName = res.lstScenarioUserMap.filter(x => x.ScenarioName == "Default")[0].ScenarioName;
                    _this._scenariodc.AnalysisID = _this.ScenarioId;
                    //this._calculationManager.AnalysisID = this.ScenarioId;
                }
            }
        });
    };
    DevDashBoardComponent.prototype.changeScenario = function (value) {
        this.ScenarioId = value;
        this.GetCalcStatus();
    };
    DevDashBoardComponent.prototype.getPalette = function () {
        return wjcChart.Palettes['highcontrast'];
    };
    DevDashBoardComponent.prototype.GetErrorCount = function () {
        var _this = this;
        this.devDashBoardService.GetErrorCount().subscribe(function (res) {
            var data = res.UserRequestCount;
            _this.userlist = res.ResultList;
            _this.itemsError = data;
        });
    };
    //writeToLog(module: string, logtype: string, logtext: string)
    //{
    //    var text = module + "||" + logtype + "||" + logtext;
    //}
    //AI dashBoard Section  started
    DevDashBoardComponent.prototype.GetAIDashBoard = function () {
        var _this = this;
        try {
            var result = [];
            var lookup = {};
            this.devDashBoardService.GetAIDashBoardData().subscribe(function (res) {
                if (res.Succeeded) {
                    var data = res.lstAIDashboard;
                    var boxitems = data.filter(function (x) { return x.IsChart == "Box"; });
                    var items = data.filter(function (x) { return x.IsChart == "Chart"; });
                    for (var boxdata, j = 0; boxdata = boxitems[j++];) {
                        if (boxdata.Name == "Total Sent") {
                            _this.TotalSentMessages = boxdata.value;
                        }
                        else if (boxdata.Name == "Total Received") {
                            _this.TotalReceivedMessages = boxdata.value;
                        }
                        else if (boxdata.Name == "Today") {
                            _this.TotalConversionsToday = boxdata.value;
                        }
                        else if (boxdata.Name == "Current Month") {
                            _this.TotalConversionsMonth = boxdata.value;
                        }
                        else if (boxdata.Name == "Current Week") {
                            _this.TotalConversionsWeek = boxdata.value;
                        }
                        else if (boxdata.Name == "Avg Question") {
                            _this.DailyAverage = boxdata.value;
                        }
                    }
                    for (var item, i = 0; item = items[i++];) {
                        var name = item.ChartName;
                        if (name) {
                            if (name != "") {
                                if (!(name in lookup)) {
                                    lookup[name] = 1;
                                    result.push(name);
                                }
                            }
                        }
                    }
                    if (result) {
                        for (var re = 0; re < result.length; re++) {
                            var filterdata = items.filter(function (z) { return z.ChartName == result[re]; });
                            if (filterdata) {
                                var charttype = filterdata[0].ChartType;
                                if (charttype == "Pie") {
                                    _this.addPieChart(filterdata, filterdata[0].ChartName);
                                }
                                else {
                                    _this.addChart(filterdata[0].ChartType, filterdata, filterdata[0].ChartName);
                                }
                            }
                        }
                    }
                }
                else {
                    _this.loggingService.writeToLog("DevDashBoard", "error", res.Message);
                }
            });
        }
        catch (err) {
            this.loggingService.writeToLog("DevDashBoard", "error", err.stack);
        }
    };
    DevDashBoardComponent.prototype.addPieChart = function (itemlist, Chartheader) {
        var container = document.querySelector('.dynamicpie');
        var header = document.createElement("span");
        header.className = "AIcarbox-fonts";
        header.innerHTML = Chartheader;
        container.appendChild(header);
        var host = document.createElement("div");
        container.appendChild(host);
        new wjcChart.FlexPie(host, {
            itemsSource: itemlist,
            bindingName: 'Name',
            binding: 'value',
        });
    };
    DevDashBoardComponent.prototype.GenricAddPieChart = function (itemlist, Chartheader, Classname) {
        var container = document.querySelector(Classname);
        var header = document.createElement("span");
        header.className = "AIcarbox-fonts";
        header.innerHTML = Chartheader;
        container.appendChild(header);
        var host = document.createElement("div");
        container.appendChild(host);
        new wjcChart.FlexPie(host, {
            itemsSource: itemlist,
            bindingName: 'Name',
            binding: 'value',
        });
    };
    DevDashBoardComponent.prototype.clearolddata = function () {
        var container = document.querySelector('.Userdynamicchart');
        container.innerHTML = "";
        container = document.querySelector('.Userdynamicpie');
        container.innerHTML = "";
    };
    DevDashBoardComponent.prototype.GenricAddChart = function (charttype, itemlist, Chartheader, classname) {
        var container = document.querySelector(classname);
        var header = document.createElement("span");
        header.className = "AIcarbox-fonts";
        header.innerHTML = Chartheader;
        container.appendChild(header);
        var ybinding = { binding: "value" };
        var seriesdata = [];
        seriesdata.push(ybinding);
        var selectedSeries = seriesdata;
        var host = document.createElement("div");
        container.appendChild(host);
        new wjcChart.FlexChart(host, {
            itemsSource: itemlist,
            series: selectedSeries,
            chartType: charttype,
            bindingX: 'Name',
        });
    };
    DevDashBoardComponent.prototype.addChart = function (charttype, itemlist, Chartheader) {
        var container = document.querySelector('.dynamicchart');
        var header = document.createElement("span");
        header.className = "AIcarbox-fonts";
        header.innerHTML = Chartheader;
        container.appendChild(header);
        var ybinding = { binding: "value" };
        var seriesdata = [];
        seriesdata.push(ybinding);
        var selectedSeries = seriesdata;
        var host = document.createElement("div");
        container.appendChild(host);
        new wjcChart.FlexChart(host, {
            itemsSource: itemlist,
            series: selectedSeries,
            chartType: charttype,
            bindingX: 'Name',
        });
    };
    DevDashBoardComponent.prototype.ShowDashBoardData = function () {
        if (this.firsttime == 0) {
            this.GetAIDashBoard();
            this.firsttime = 1;
        }
    };
    //AI DashBoard Section  ended
    // user ai start
    DevDashBoardComponent.prototype.ShowUserAIDashBoard = function () {
        //if (this.firsttime == 0) {
        //    this.GetAIDashBoard();
        //    this.firsttime = 1;
        //}
    };
    DevDashBoardComponent.prototype.checkDroppedDownChangedUserName = function (sender, args) {
        var ac = sender;
        if (ac.selectedIndex == -1) {
            if (ac.text != this.text_username) {
                this.text_username = null;
                this.usernameID = null;
                this.usernameText = null;
            }
        }
        else {
            this.usernameID = ac.selectedValue;
            this.usernameText = ac.selectedItem.Valuekey;
            this.text_username = ac.selectedItem.Valuekey;
        }
    };
    DevDashBoardComponent.prototype.getAutosuggestusernameFunc = function (query, max, callback) {
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
                var _valueType;
                var items = [];
                for (var i = 0; i < _this._result.length; i++) {
                    var c = _this._result[i];
                    c.DisplayName = c.Valuekey;
                }
                callback(_this._result);
            }
            else {
                _this.utilityService.navigateToSignIn();
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    DevDashBoardComponent.prototype.showUserAIData = function () {
        this.GetAIUserData();
    };
    DevDashBoardComponent.prototype.GetAIUserData = function () {
        var _this = this;
        try {
            this.clearolddata();
            var result = [];
            var lookup = {};
            this.devDashBoardService.GetaiUserLog(this.usernameID).subscribe(function (res) {
                if (res.Succeeded) {
                    var data = res.lstAIDashboard;
                    var items = data.filter(function (x) { return x.IsChart == "Chart"; });
                    for (var item, i = 0; item = items[i++];) {
                        var name = item.ChartName;
                        if (name) {
                            if (name != "") {
                                if (!(name in lookup)) {
                                    lookup[name] = 1;
                                    result.push(name);
                                }
                            }
                        }
                    }
                    if (result) {
                        for (var re = 0; re < result.length; re++) {
                            var filterdata = items.filter(function (z) { return z.ChartName == result[re]; });
                            if (filterdata) {
                                var charttype = filterdata[0].ChartType;
                                if (charttype == "Pie") {
                                    _this.GenricAddPieChart(filterdata, filterdata[0].ChartName, '.Userdynamicpie');
                                }
                                else {
                                    _this.GenricAddChart(filterdata[0].ChartType, filterdata, filterdata[0].ChartName, '.Userdynamicchart');
                                }
                            }
                        }
                    }
                }
                else {
                    _this.loggingService.writeToLog("DevDashBoard", "error", res.Message);
                }
            });
        }
        catch (err) {
            this.loggingService.writeToLog("DevDashBoard", "error", err.stack);
        }
    };
    //user ai end
    DevDashBoardComponent.prototype.CustomAlert = function (dialog) {
        var winW = window.innerWidth;
        var winH = window.innerHeight;
        var dialogoverlay = document.getElementById('dialogoverlay');
        var dialogbox = document.getElementById('dialogbox');
        dialogoverlay.style.display = "block";
        dialogoverlay.style.height = winH + "px";
        dialogbox.style.left = (winW / 2) - (550 * .5) + "px";
        dialogbox.style.top = "100px";
        dialogbox.style.display = "block";
        document.getElementById('dialogboxhead').innerHTML = "CRES - Validation Error";
        document.getElementById('dialogboxbody').innerHTML = dialog;
        //document.getElementById('dialogboxfoot').innerHTML = '<span class="custombutton" onclientclick="this.ok()">OK</span>';
    };
    DevDashBoardComponent.prototype.ok = function () {
        document.getElementById('dialogbox').style.display = "none";
        document.getElementById('dialogoverlay').style.display = "none";
    };
    var _a, _b, _c, _d, _e, _f, _g, _h;
    __decorate([
        (0, core_1.ViewChild)('chartpie'),
        __metadata("design:type", typeof (_a = typeof wjcChart !== "undefined" && wjcChart.FlexPie) === "function" ? _a : Object)
    ], DevDashBoardComponent.prototype, "chartpie", void 0);
    __decorate([
        (0, core_1.ViewChild)('UserSummary'),
        __metadata("design:type", typeof (_b = typeof wjcChart !== "undefined" && wjcChart.FlexChart) === "function" ? _b : Object)
    ], DevDashBoardComponent.prototype, "UserSummary", void 0);
    __decorate([
        (0, core_1.ViewChild)('ErrorMatrix'),
        __metadata("design:type", typeof (_c = typeof wjcChart !== "undefined" && wjcChart.FlexChart) === "function" ? _c : Object)
    ], DevDashBoardComponent.prototype, "ErrorMatrix", void 0);
    __decorate([
        (0, core_1.ViewChild)('chart'),
        __metadata("design:type", typeof (_d = typeof wjcChart !== "undefined" && wjcChart.FlexChart) === "function" ? _d : Object)
    ], DevDashBoardComponent.prototype, "chart", void 0);
    __decorate([
        (0, core_1.ViewChild)('flexcalculation'),
        __metadata("design:type", typeof (_e = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _e : Object)
    ], DevDashBoardComponent.prototype, "flex", void 0);
    __decorate([
        (0, core_1.ViewChild)('rsChart'),
        __metadata("design:type", typeof (_f = typeof wjcChart !== "undefined" && wjcChart.FlexChart) === "function" ? _f : Object)
    ], DevDashBoardComponent.prototype, "rsChart", void 0);
    __decorate([
        (0, core_1.ViewChild)('rangeSelector'),
        __metadata("design:type", typeof (_g = typeof wjcChartInteraction !== "undefined" && wjcChartInteraction.RangeSelector) === "function" ? _g : Object)
    ], DevDashBoardComponent.prototype, "rangeSelector", void 0);
    DevDashBoardComponent = __decorate([
        (0, core_1.Component)({
            selector: "devdashboard",
            templateUrl: "app/components/DevDashBoard.html",
            providers: [devDashBoardService_1.DevDashBoardService, membershipservice_1.MembershipService, NoteService_1.NoteService, reportservice_1.ReportService, CalculationManagerService_1.CalculationManagerService, scenarioService_1.scenarioService, loggingService_1.LoggingService, TaskManagerService_1.TaskManagerService]
        }),
        __metadata("design:paramtypes", [devDashBoardService_1.DevDashBoardService,
            TaskManagerService_1.TaskManagerService,
            NoteService_1.NoteService,
            membershipservice_1.MembershipService,
            reportservice_1.ReportService,
            CalculationManagerService_1.CalculationManagerService,
            utilityService_1.UtilityService,
            scenarioService_1.scenarioService,
            loggingService_1.LoggingService, typeof (_h = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _h : Object])
    ], DevDashBoardComponent);
    return DevDashBoardComponent;
}(paginated_1.Paginated));
exports.DevDashBoardComponent = DevDashBoardComponent;
var routes = [
    { path: '', component: DevDashBoardComponent }
];
var DevDashBoardModule = /** @class */ (function () {
    function DevDashBoardModule() {
    }
    DevDashBoardModule = __decorate([
        (0, core_2.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_chart_1.WjChartModule, wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_input_1.WjInputModule, wijmo_angular2_grid_filter_1.WjGridFilterModule, wijmo_angular2_chart_interaction_1.WjChartInteractionModule],
            declarations: [DevDashBoardComponent]
        })
    ], DevDashBoardModule);
    return DevDashBoardModule;
}());
exports.DevDashBoardModule = DevDashBoardModule;
//# sourceMappingURL=DevDashBoard.component.js.map