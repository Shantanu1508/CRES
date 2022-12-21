

import { Component, OnInit, AfterViewInit, ViewChild } from "@angular/core";
import { Router, ActivatedRoute } from '@angular/router';
import * as wjNg2Grid from 'wijmo/wijmo.angular2.grid';
import * as wjcGrid from 'wijmo/wijmo.grid';
import { NgModule } from '@angular/core';
import { Paginated } from '../core/common/paginated';
import { UtilityService } from '../core/services/utilityService';
import { ModuleWithProviders } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { Headers, RequestOptions, BaseRequestOptions } from '@angular/http';
import * as wjcChart from 'wijmo/wijmo.chart';
import * as wjcInput from 'wijmo/wijmo.input';
import { LoggingService } from './../core/services/loggingService';
import { WjChartModule } from 'wijmo/wijmo.angular2.chart';
import { WjInputModule } from 'wijmo/wijmo.angular2.input';
import { WjGridModule } from 'wijmo/wijmo.angular2.grid';
import { WjGridFilterModule } from 'wijmo/wijmo.angular2.grid.filter';
import * as wjcChartInteraction from 'wijmo/wijmo.chart.interaction';
import { WjChartInteractionModule } from 'wijmo/wijmo.angular2.chart.interaction';
import { ReportService } from './../core/services/reportservice'
import { DevDashBoardService } from '../core/services/devDashBoardService';
import { TaskManagerService } from '../core/services/TaskManagerService';
import { Search } from "../core/domain/search";
import { MembershipService } from '../core/services/membershipservice';
import { Note, DownloadCashFlow } from "../core/domain/Note";
import { NoteService } from '../core/services/NoteService';
import { WjChartAnalyticsModule } from 'wijmo/wijmo.angular2.chart.analytics';
import { CalculationManagerService } from '../core/services/CalculationManagerService';
import { Scenario } from "../core/domain/Scenario";
import { scenarioService } from '../core/services/scenarioService';
import { devDashBoard } from "./../core/domain/devdashboard";
import * as wjNg2Input from 'wijmo/wijmo.angular2.input';

import * as wjcCore from 'wijmo/wijmo';
import { empty } from "../../../node_modules/rxjs/observable/empty";
@Component({
    selector: "devdashboard",
    templateUrl: "app/components/DevDashBoard.html",
    providers: [DevDashBoardService, MembershipService, NoteService, ReportService, CalculationManagerService, scenarioService, LoggingService, TaskManagerService]
})
export class DevDashBoardComponent extends Paginated {
    private _pagePath: any;
    itemsSource: any[];
    itemsError: any[];
    itemsSourceCalcInfo: any[];
    userlist: any[];
    itemsSourcetime: any[];
    private FirstCall: number = 0;
    private refreshcount: number = 0;
    private _isFetching: boolean = false;

    source: any;
    chartTypes: any[];
    selectedSeries = [];
    chartType = 'Column';

    private _devDashBoard: devDashBoard;

    dwlastupdatedtime: any;
    private _isNoteListFetching: boolean = false;
    private _ShowmessagedivMsgWar: boolean = false;
    private _WaringMessage: string = '';
    pal = 0;
    Logtype: any;
    Failed = 0;
    Remainingnotes = 0;
    movingAverageName: string;
    movingAveragePeriod: number;
    movingAverageType: string;
    GenericDialogBody: string;
    private _groupWidth = '70%';
    CREnoteID: any;
    Completed = 0;
    CalcSubmit = 0;
    Running = 0;
    Processing = 0;
    firstcall = 1;
    Dependents = 0;
    public _dtUTCHours: number;
    public _userOffset: number;
    public _centralOffset: number;
    MaxCalculatedtime: any;
    columnSet: any;
    result: any;
    CalculationRequesttime: any;
    TotalCalculationtimeinmin = 0;
    Fastest = 0;
    FastestNoteID: any;
    myList: any;
    dwdwStatus: any;
    Slowest = 0;
    SlowestNoteID: any;
    lstcalculationlist: any;
    Pending = 0;
    CalcProgress = 0;
    Avgtime: any;
    multipleCREnoteID: any;
    private _note: Note;
    MinCalculatedtime: any;
    palettes = 'standard,cocoa,coral,dark,highcontrast,light,midnight,modern,organic,slate,zen,cyborg,superhero,flatly,darkly,cerulan'.split(',');
    ScenarioId: string;
    labels = 0;
    lblBorder = false;
    TotalConversionsMonth = 0;
    TotalConversionsWeek = 0;
    TotalConversionsToday = 0;
    TotalSentMessages = 0;
    TotalReceivedMessages = 0;
    DailyAverage = 0;
    firsttime = 0;
    text_username: any;
    public usernameID: any;
    public usernameText: any;
    private _result: any;
    private _cachedeal = {};
    private _searchObj: any;
    public _pageSizeSearch: number = 10;
    public _pageIndexSearch: number = 1;
    public _totalCountSearch: number = 0;
    public lstimportdataStatus: any;
    public _isShowLoader: boolean = false;

    @ViewChild('chartpie') chartpie: wjcChart.FlexPie;
    @ViewChild('UserSummary') UserSummary: wjcChart.FlexChart;

    @ViewChild('ErrorMatrix') ErrorMatrix: wjcChart.FlexChart;
    @ViewChild('chart') chart: wjcChart.FlexChart;
    @ViewChild('flexcalculation') flex: wjcGrid.FlexGrid;
    @ViewChild('rsChart') rsChart: wjcChart.FlexChart;
    @ViewChild('rangeSelector') rangeSelector: wjcChartInteraction.RangeSelector;

    private _lstScenario: any;
    private _scenariodc: Scenario;
    private wfstatus: boolean;
    public Status4: string;
    public BatchEndTime4: string;
    constructor(
        public devDashBoardService: DevDashBoardService,
        public taskManagerService: TaskManagerService,
        public notesvc: NoteService,
        public membershipService: MembershipService,
        public reportService: ReportService,
        public calculationsvc: CalculationManagerService,
        public utilityService: UtilityService,
        public scenarioService: scenarioService,
        public loggingService: LoggingService,
        private _router: Router) {
        super(50, 1, 0);
        this._scenariodc = new Scenario('');
        this._lstScenario = this._scenariodc.LstScenarioUserMap;
        this.getAllDistinctScenario();
        this.ScenarioId = window.localStorage.getItem("scenarioid");
        this.utilityService.setPageTitle("Dev-DashBoard");
        var _date = new Date();
        this._devDashBoard = new devDashBoard('');
        this._dtUTCHours = _date.getTimezoneOffset() / 60;

        this._userOffset = _date.getTimezoneOffset() * 60 * 1000; // user's offset time
        if (this._dtUTCHours < 6) {
            this._centralOffset = 6 * 60 * 60 * 1000; // 6 for central time - use whatever you need
        }
        else {
            this._centralOffset = this._dtUTCHours * 60 * 60 * 1000; // 6 for central time - use whatever you need
        }
        this.GetStagingDataIntoIntegrationStatus();
        this.getallStatus();
    }

    stRendered() {
        var stChart = this.chart;

        if (!stChart) {
            return;
        }
        stChart.axisX.labels = false;
        stChart.axisX.axisLine = false;

        stChart.legend.position = 0;
    }

    getData() {
        var countries = 'US,Germany,UK,Japan,Italy,Greece'.split(','),
            data = [];
        for (var i = 0; i < countries.length; i++) {
            data.push({
                country: countries[i],
                sales: Math.random() * 10000,
            });
        }
        return data;
    }

    selectionChanged(s, e) {
        if (s.selection) {
            this._isFetching = true;
            var value = s.selection.collectionView.currentItem.ProcessType
            this.Logtype = value;
            this.showDialogCustom("myModalLog");
            this.getLogByType(value);
        }

    }

    stErrorRendered() {
        var stChart = this.ErrorMatrix;
        var value = "20px";
        if (!stChart) {
            return;
        }
        stChart.palette = ['rgba(255, 54, 54)'];
        stChart.axisX.labels = true;
        stChart.axisY.labels = true;
        stChart.legend.position = 0;
    }

    rsRendered() {
        var rsChart = this.rsChart;

        if (!rsChart) {
            return;
        }
        rsChart.axisY.labels = false;
        rsChart.axisY.majorGrid = false;
    }
    rangeChanged() {
        if (this.chart && this.rangeSelector) {
            this.chart.axisX.min = this.rangeSelector.min;
            this.chart.axisX.max = this.rangeSelector.max;
            this.chart.invalidate();
        }
    }

    getEnumNames(enumClass) {
        var names = [];
        for (var key in enumClass) {
            var val = parseInt(key);
            if (isNaN(val)) names.push(key);
        }
        return names;
    }
    showDialogCustom(controlid): void {
        var modalRole = document.getElementById(controlid);
        modalRole.style.display = "block";
        $.getScript("/js/jsDrag.js");
    }

    ShowModalConfirmTag(controlid) {
        var ScenarioName = this._lstScenario.find(x => x.AnalysisID == this.ScenarioId).ScenarioName
        this.GenericDialogBody = "Are you sure want to calculate all notes for "+ScenarioName+" scenario.";
        var modalDelete = document.getElementById(controlid);
        modalDelete.style.display = "block";
        $.getScript("/js/jsDrag.js");
    }

    GCloseCreatePopUp(controlid): void {
        var modal = document.getElementById(controlid);
        modal.style.display = "none";
    }
    getPieChartData() {
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
    }
    getCalculationStatus(): void {
        try {
            this.devDashBoardService.getCalculationStatus(this.ScenarioId).subscribe(res => {
                if (res.Succeeded) {

                    this.CalculationRequesttime = new Date().toLocaleString();
                    this.FastestNoteID = 0;
                    this.Completed = 0;
                    this.Processing = 0;
                    this.Dependents = 0;
                    this.Running = 0;
                    this.Remainingnotes = 0;
                    this.TotalCalculationtimeinmin = 0;
                    this.Pending = 0;
                    var data = [];
                    this.Avgtime = 0;
                    this.Failed = 0;                  
                    this.CalcSubmit = 0;
                    this.CalcProgress = 0;
                    this.Slowest = 0;
                    this.SlowestNoteID = "";
                    this.Fastest = 0;
                    this.FastestNoteID = "";

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
                            this.Fastest = fastslow[i].value;
                            this.FastestNoteID = fastslow[i].CRENoteID;
                        }
                        if (fastslow[i].Name == "Min Time") {
                            this.Slowest = fastslow[i].value;
                            this.SlowestNoteID = fastslow[i].CRENoteID;
                        }
                    }
                    for (var i = 0; i < result.length; i++) {
                        if (result[i].Name == "Failed")
                        {
                            this.Failed = result[i].value;
                        }
                        if (result[i].Name == "Completed") {
                            this.Completed = result[i].value;
                        }
                        if (result[i].Name == "CalcSubmit") {
                            this.CalcSubmit = result[i].value;
                        }
                        if (result[i].Name == "Running") {
                            this.Running = result[i].value;
                        }
                        if (result[i].Name == "Processing") {
                            this.Processing = result[i].value;

                        }
                        if (result[i].Name == "Dependents") {
                            this.Dependents = result[i].value;
                        }
                        if (result[i].Name == "Total Calculation time in min") {
                            this.TotalCalculationtimeinmin = result[i].value;
                        }

                    }
                    this.Remainingnotes = this.Processing + this.Dependents + this.CalcSubmit;
                    this.Pending = this.Processing + this.Dependents + this.Running + this.CalcSubmit;

                    if (this.Completed != null && this.Completed != 0 && this.TotalCalculationtimeinmin != null && this.TotalCalculationtimeinmin != 0) {
                        this.Avgtime = (this.Completed / this.TotalCalculationtimeinmin);
                        this.Avgtime = parseFloat(this.Avgtime.toString()).toFixed(2);
                    }
                    if (this.Completed != null && this.Completed != 0 && this.Pending != 0 && this.Pending != null) {
                        this.CalcProgress = Math.round((this.Completed / (this.Pending + this.Completed)) * 100);
                    }
                    else if (this.Pending == 0 && this.Completed != 0) {
                        this.CalcProgress = 100;
                    }

                    if (this.CalcProgress > 100) {
                        this.CalcProgress = 100;
                    }

                    this.itemsSource = data;
                    if (this.Pending === undefined || this.Pending === null) {
                        this.Pending = 0
                    }
                    if (this.FirstCall == 0) {
                        this.FirstCall = 1;
                        this.GetCalcStatus();
                    }
                }
                else {
                }
            });
        } catch (err) {
        }
    }
    GetCalcStatus(): void {
        if (this.Pending === undefined || this.Pending === null) {
            this.Pending = 0
        }
        if (this.Pending != 0) {
            this.FirstCall = 1;
            this.calculationsvc.calcstatus().subscribe(res => {
                if (res.Succeeded) {
                    this.refreshcount = res.TotalCount;
                    if (this.refreshcount > 0) {
                        this.getCalculationStatus();
                        setTimeout(() => {
                            this.GetCalcStatus();
                        }, 20000);

                    }
                    else if (this.refreshcount == 0)//For call once again after complete all process.
                    {
                        this.getCalculationStatus();
                        // this.getFailedNotes();
                    }
                }
            });
        } else {
            // upate status to final time
            this.getCalculationStatus();
            // this.getFailedNotes();
        }
    }
    GetCalculationJson(): void {
        try {

            this._isFetching = true;
            this._devDashBoard.NoteID = this.CREnoteID;
            this._devDashBoard.ScenarioID = this.ScenarioId;
            this.devDashBoardService.getCalcJson(this._devDashBoard).subscribe(res => {
                if (res.Succeeded) {
                    var data = res.NoteData;
                    var jsonname = "Note_" + this.CREnoteID + "_Calc.json"
                    this.downloadJson(data, jsonname);
                    this._isFetching = false;
                }
                else {
                    this._isFetching = false;
                }
            });
        } catch (err) {
            this._isFetching = false;
        }
    }
    ShowCalcDashBoardData() {
        setTimeout(function () {
            if (this.ErrorMatrix) {
                this.ErrorMatrix.invalidate();
            }
        }.bind(this), 1000);
    }

    CalculateMultipleNote(): void {
        try {
            this._devDashBoard.NoteID = this.multipleCREnoteID;
            this._devDashBoard.ScenarioID = this.ScenarioId;
            this.devDashBoardService.CalculateMultipleNotes(this._devDashBoard).subscribe(res => {
                if (res.Succeeded) {
                    this.multipleCREnoteID = "";
                    this._ShowmessagedivMsgWar = true;
                    this.GetCalcStatus();
                    this._WaringMessage = "Notes queued for calculation";
                    this.GCloseCreatePopUp("myModalCalculate");
                    setTimeout(function () {
                        this._ShowmessagedivMsgWar = false;
                    }.bind(this), 5000);
                }
                else {
                }
            });
        } catch (err) {
        }
    }


    CalcAllNotes(): void {
        try {
            this._isShowLoader = true;
            this.devDashBoardService.CalcAllNotes(this.ScenarioId).subscribe(res => {
                if (res.Succeeded) {
                    this.multipleCREnoteID = "";
                    this._ShowmessagedivMsgWar = true;
                    this.GetCalcStatus();
                    this._WaringMessage = "Notes queued for calculation";
                    this.GCloseCreatePopUp("myModalConfirmTag");
                    this._isShowLoader = false;
                    setTimeout(function () {
                        this._ShowmessagedivMsgWar = false;
                    }.bind(this), 5000);
                }
                else {
                }
            });
        } catch (err) {
        }
    }
    downloadJson(myJson, filename) {
        var sJson = JSON.stringify(myJson);
        var element = document.createElement('a');
        element.setAttribute('href', "data:text/json;charset=UTF-8," + encodeURIComponent(sJson));
        element.setAttribute('download', filename);
        element.style.display = 'none';
        document.body.appendChild(element);
        element.click();
        document.body.removeChild(element);
    }

    getTwoDigitString(number) {
        if (number.toString().length === 1)
            return "0" + number;
        return number;
    }

    convertDateToBindableWithTime(date) {
        var dateObj = new Date(date);
        return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear() + " " + dateObj.getHours() + ":" + dateObj.getMinutes() + ":" + dateObj.getSeconds();
    }


    warehouseStatus(btnname = "Refresh Data Warehouse") {
        this.reportService.GetwarehouseStatus(btnname).subscribe(res => {
            if (res.Succeeded) {

                if (res.Status2 == "Process Running") {
                    this.Status4 = res.Status2;
                    this.BatchEndTime4 = '';
                }
                else if (res.Status2 == "Process InComplete") {
                    this.Status4 = res.Status2 + '\r \n Last Updated ';
                    this.BatchEndTime4 = res.BatchEndTime;
                   // this.BatchEndTime4 = this.convertDateToBindableWithTime(res.BatchEndTime);

                }
                else {
                    this.Status4 = res.Status2 + '\r \n Last Updated ';
                    this.BatchEndTime4 = res.BatchEndTime;
                  // this.BatchEndTime4 = this.convertDateToBindableWithTime(res.BatchEndTime);


                }

            }
        });
    }
    RefreshReport(): void {
        var d = new Date();
        var datestring = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate() + " " +
            d.getHours() + ":" + d.getMinutes();
        this.devDashBoardService.RefreshDataWarehouse(datestring).subscribe(res => {
            if (res.Succeeded) {

                this._ShowmessagedivMsgWar = true;
                this._WaringMessage = res.Message;
                setTimeout(function () {
                    this._ShowmessagedivMsgWar = false;
                }.bind(this), 5000);
            }
            else {

            }
        });
    }

    importStagingData(): void {
        this.devDashBoardService.importStagingData().subscribe(res => {
            if (res.Succeeded) {
                this.CustomAlert(res.Message);
            }
            else {

            }
        });
    }

    GetStagingDataIntoIntegrationStatus(): void {
        try {
            this._isFetching = true;
            this.devDashBoardService.GetStagingDataIntoIntegrationStatus().subscribe(res => {
                if (res.Succeeded) {
                    this.lstimportdataStatus = res.ImportDataStatus;
                    this._isFetching = false;
                }
                else {
                    this._isFetching = false;
                }
            });
        } catch (err) {
            this._isFetching = false;
        }
    }

    getLogByType(logtype): void {
        try {

            this.lstcalculationlist = null;
            this.devDashBoardService.getFailedNotes(logtype).subscribe(res => {
                if (res.Succeeded) {
                    this.lstcalculationlist = res.CalculationStatus;
                    for (var i = 0; i < this.lstcalculationlist.length; i++) {
                        if (this.lstcalculationlist[i].RequestTime != null) {
                            var d = new Date(this.lstcalculationlist[i].RequestTime.toString());
                            var _month = d.getMonth() + 1;
                            var month = (_month < 10) ? '0' + _month : _month;
                            var amOrPm = (d.getHours() < 12) ? "AM" : "PM";
                            var hour = (d.getHours() < 12) ? d.getHours() : d.getHours() - 12;
                            var hr = (hour < 10) ? '0' + hour : hour;
                            var date = (d.getDate() < 10) ? '0' + d.getDate() : d.getDate();
                            var minutes = (d.getMinutes() < 10) ? '0' + d.getMinutes() : d.getMinutes();
                            this.lstcalculationlist[i].RequestTime = month + '-' + date + '-' + d.getFullYear() + ' ' + hr + ':' + minutes + ' ' + amOrPm;
                        }

                        if (this.lstcalculationlist[i].FundingOrEndTime != null) {
                            this.lstcalculationlist[i].FundingOrEndTime = new Date(this.lstcalculationlist[i].FundingOrEndTime.toString());
                        }
                    }


                    setTimeout(() => {
                        if (this.flex) {
                            var flexGrid = this.flex;
                            if (this.Logtype != "Deal" && this.Logtype != "Note") {
                                var columns = flexGrid.columns;
                                columns[1].visible = false;
                                columns[0].visible = false;
                                flexGrid.invalidate();
                            }
                            if (this.Logtype == "Deal" || this.Logtype == "Note") {
                                var columns = flexGrid.columns;
                                columns[1].visible = true;
                                columns[0].visible = true;
                                flexGrid.invalidate();

                            }
                        }
                    }, 500);



                    this._isFetching = false;
                }
                else {
                    this._isFetching = false;
                    this.lstcalculationlist = null;
                }
            });
        } catch (err) {
        }
    }

    flexcalculationInitialized(flexGrid) {
        if (this.Logtype == "Calculator") {
            var columns = flexGrid.columns;
            columns[1].visible = false;
        }

    }

    downloadNoteCashflowsExportData(): void {
        this._isNoteListFetching = true;
        this._note = new Note('');
        var downloadCashFlow = new DownloadCashFlow();
        downloadCashFlow.NoteId = "00000000-0000-0000-0000-000000000000";
        downloadCashFlow.DealID = "00000000-0000-0000-0000-000000000000";
        downloadCashFlow.AnalysisID = window.localStorage.getItem("scenarioid");
        downloadCashFlow.MutipleNoteId = "";
        try {
            this.notesvc.getNoteCashflowsExportData(downloadCashFlow).subscribe(res => {
                if (res.Succeeded) {
                    this.downloadFile(res.lstNoteCashflowsExportData);
                    this._isNoteListFetching = false;
                }
                else {
                    this._isNoteListFetching = false;
                }
            });
        } catch (err) {
            alert("Error in cashflow download");
            this._isNoteListFetching = false;
        }
    }

    downloadFile(objArray) {
        var data = this.ConvertToCSV(objArray);
        var displayDate = new Date().toLocaleDateString("en-US");
        var fileName = "NoteCashflow-" + displayDate + ".csv";

        let blob = new Blob(['\ufeff' + data], { type: 'text/csv;charset=utf-8;' });
        let dwldLink = document.createElement("a");
        let url = URL.createObjectURL(blob);
        let isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
        if (isSafariBrowser) {  //if Safari open in new window to save file with random filename.
            dwldLink.setAttribute("target", "_blank");
        }
        dwldLink.setAttribute("href", url);
        dwldLink.setAttribute("download", fileName);
        dwldLink.style.visibility = "hidden";
        document.body.appendChild(dwldLink);
        dwldLink.click();
        document.body.removeChild(dwldLink);
    }

    ConvertToCSV(objArray) {
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
                if (line != '') line += ','

                line += array[i][index];
            }
            str += line + '\r\n';
        }
        return str;
    }

    getallStatus(): void {
        try {
            //  arguments.callee.toString();
            this.loggingService.writeToLog("DevDashBoard", "info", "testing");
            this.GetErrorCount();
            this.GetCalcStatus();
            //this.getFailedNotes();
            //this.GetDWStatus();
        } catch (err) {
            this.loggingService.writeToLog("DevDashBoard", "error", err.stack);
        }

    }

    getAllDistinctScenario(): void {
        var _userData = JSON.parse(localStorage.getItem('user'));
        this._scenariodc.UserID = _userData.UserID;
        this.scenarioService.getAllScenarioDistinct(this._scenariodc).subscribe(res => {
            if (res.Succeeded) {
                if (res.lstScenarioUserMap.length > 0) {
                    this._lstScenario = res.lstScenarioUserMap;
                    this.ScenarioId = res.lstScenarioUserMap.filter(x => x.ScenarioName == "Default")[0].AnalysisID;
                    //this.ScenarioName = res.lstScenarioUserMap.filter(x => x.ScenarioName == "Default")[0].ScenarioName;
                    this._scenariodc.AnalysisID = this.ScenarioId;
                    //this._calculationManager.AnalysisID = this.ScenarioId;
                }
            }
        });
    }
    changeScenario(value): void {
        this.ScenarioId = value;
        this.GetCalcStatus();
    }

    getPalette(): string[] {
        return wjcChart.Palettes['highcontrast'];
    }
    GetErrorCount(): void {
        this.devDashBoardService.GetErrorCount().subscribe(res => {
            var data = res.UserRequestCount;
            this.userlist = res.ResultList;
            this.itemsError = data;
        });
    }

    //writeToLog(module: string, logtype: string, logtext: string)
    //{
    //    var text = module + "||" + logtype + "||" + logtext;
    //}

    //AI dashBoard Section  started

    GetAIDashBoard(): void {
        try {
            var result = [];
            var lookup = {};
            this.devDashBoardService.GetAIDashBoardData().subscribe(res => {
                if (res.Succeeded) {
                    var data = res.lstAIDashboard;

                    var boxitems = data.filter(x => x.IsChart == "Box");
                    var items = data.filter(x => x.IsChart == "Chart");
                    for (var boxdata, j = 0; boxdata = boxitems[j++];) {
                        if (boxdata.Name == "Total Sent") {
                            this.TotalSentMessages = boxdata.value;
                        }
                        else if (boxdata.Name == "Total Received") {
                            this.TotalReceivedMessages = boxdata.value;
                        }
                        else if (boxdata.Name == "Today") {
                            this.TotalConversionsToday = boxdata.value;
                        }
                        else if (boxdata.Name == "Current Month") {
                            this.TotalConversionsMonth = boxdata.value;
                        }
                        else if (boxdata.Name == "Current Week") {
                            this.TotalConversionsWeek = boxdata.value;
                        } else if (boxdata.Name == "Avg Question") {
                            this.DailyAverage = boxdata.value;
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
                            var filterdata = items.filter(z => z.ChartName == result[re])
                            if (filterdata) {
                                var charttype = filterdata[0].ChartType;
                                if (charttype == "Pie") {
                                    this.addPieChart(filterdata, filterdata[0].ChartName);
                                } else {
                                    this.addChart(filterdata[0].ChartType, filterdata, filterdata[0].ChartName);
                                }
                            }

                        }
                    }


                }
                else {
                    this.loggingService.writeToLog("DevDashBoard", "error", res.Message);
                }
            });
        } catch (err) {
            this.loggingService.writeToLog("DevDashBoard", "error", err.stack);
        }
    }
    addPieChart(itemlist, Chartheader) {
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
    }

    GenricAddPieChart(itemlist, Chartheader, Classname) {
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
    }

    clearolddata() {
        var container = document.querySelector('.Userdynamicchart');
        container.innerHTML = "";

        container = document.querySelector('.Userdynamicpie');
        container.innerHTML = "";

    }

    GenricAddChart(charttype, itemlist, Chartheader, classname) {
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
    }

    addChart(charttype, itemlist, Chartheader) {
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
    }

    ShowDashBoardData() {
        if (this.firsttime == 0) {
            this.GetAIDashBoard();
            this.firsttime = 1;
        }

    }
    //AI DashBoard Section  ended
    // user ai start
    ShowUserAIDashBoard() {
        //if (this.firsttime == 0) {
        //    this.GetAIDashBoard();
        //    this.firsttime = 1;
        //}
    }


    checkDroppedDownChangedUserName(sender: wjNg2Input.WjAutoComplete, args) {
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
    }

    getAutosuggestusername = this.getAutosuggestusernameFunc.bind(this);
    getAutosuggestusernameFunc(query, max, callback) {
        this._result = null;

        var self = this,
            result = self._cachedeal[query];
        if (result) {
            callback(result);
            return;
        }
        // not in cache, get from server
        var params = { query: query, max: max };
        this._searchObj = new Search(query);

        this.taskManagerService.getAutosuggestSearchUsername(this._searchObj, this._pageIndexSearch, this._pageSizeSearch).subscribe(res => {
            if (res.Succeeded) {
                var data: any = res.lstSearch;
                this._totalCountSearch = res.TotalCount;
                this._result = data;
                var _valueType;
                let items = [];
                for (var i = 0; i < this._result.length; i++) {
                    var c = this._result[i];
                    c.DisplayName = c.Valuekey;
                }
                callback(this._result);
            }
            else {
                this.utilityService.navigateToSignIn();
            }
        });
        error => console.error('Error: ' + error)
    }

    showUserAIData() {
        this.GetAIUserData();
    }


    GetAIUserData(): void {
        try {
            this.clearolddata();
            var result = [];
            var lookup = {};
            this.devDashBoardService.GetaiUserLog(this.usernameID).subscribe(res => {
                if (res.Succeeded) {
                    var data = res.lstAIDashboard;

                    var items = data.filter(x => x.IsChart == "Chart");
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
                            var filterdata = items.filter(z => z.ChartName == result[re])
                            if (filterdata) {
                                var charttype = filterdata[0].ChartType;
                                if (charttype == "Pie") {
                                    this.GenricAddPieChart(filterdata, filterdata[0].ChartName, '.Userdynamicpie');
                                } else {
                                    this.GenricAddChart(filterdata[0].ChartType, filterdata, filterdata[0].ChartName, '.Userdynamicchart');
                                }
                            }

                        }
                    }


                }
                else {
                    this.loggingService.writeToLog("DevDashBoard", "error", res.Message);
                }
            });
        } catch (err) {
            this.loggingService.writeToLog("DevDashBoard", "error", err.stack);
        }
    }
    //user ai end
    CustomAlert(dialog): void {
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
    }

    ok(): void {
        document.getElementById('dialogbox').style.display = "none";
        document.getElementById('dialogoverlay').style.display = "none";
    }


}
const routes: Routes = [
    { path: '', component: DevDashBoardComponent }]

@NgModule({
    imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjChartModule, WjGridModule, WjInputModule, WjGridFilterModule, WjChartInteractionModule],
    declarations: [DevDashBoardComponent]
})

export class DevDashBoardModule { }