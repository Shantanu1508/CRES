

import { Component, ViewChild } from "@angular/core";
import { Router } from '@angular/router';
import * as wjcGrid from '@grapecity/wijmo.grid';
import { NgModule } from '@angular/core';
import { Paginated } from '../core/common/paginated.service';
import { UtilityService } from '../core/services/utility.service';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import * as wjcChart from '@grapecity/wijmo.chart';
import { LoggingService } from './../core/services/logging.service';
import { WjChartModule } from '@grapecity/wijmo.angular2.chart';
import { WjInputModule } from '@grapecity/wijmo.angular2.input';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import * as wjcChartInteraction from '@grapecity/wijmo.chart.interaction';
import { WjChartInteractionModule } from '@grapecity/wijmo.angular2.chart.interaction';
import { ReportService } from './../core/services/report.service'
import { DevDashBoardService } from '../core/services/devDashBoard.service';
import { TaskManagerService } from '../core/services/taskManager.service';
import { Search } from "../core/domain/search.model";
import { MembershipService } from '../core/services/membership.service';
import { Note, DownloadCashFlow } from "../core/domain/note.model";
import { NoteService } from '../core/services/note.service';
import { CalculationManagerService } from '../core/services/calculationManager.service';
import { Scenario } from "../core/domain/scenario.model";
import { scenarioService } from '../core/services/scenario.service';
import { devDashBoard } from "./../core/domain/devDashBoard.model";
import * as wjNg2Input from '@grapecity/wijmo.angular2.input';
import { EnvConfig } from "../core/domain/EnvConfig.model";

declare var $: any;

@Component({
  selector: "devdashboard",
  templateUrl: "./devDashBoard.html",
  providers: [DevDashBoardService, MembershipService, NoteService, ReportService, CalculationManagerService, scenarioService, LoggingService, TaskManagerService]
})
export class DevDashBoardComponent extends Paginated {
  public _pagePath: any;
  itemsSource !: any[];
  itemsError !: any[];
  userlist !: any[];
  itemsSourcetime !: any[];
  public FirstCall: number = 0;
  public refreshcount: number = 0;
  public _isFetching: boolean = false;

  source: any;
  chartTypes !: any[];
  selectedSeries = [];
  chartType = 'Column';

  public _devDashBoard: devDashBoard;

  dwlastupdatedtime: any;
  public _isNoteListFetching: boolean = false;
  public _ShowmessagedivMsgWar: boolean = false;
  public _WaringMessage: string = '';
  pal = 0;
  Logtype: any;
  Failed = 0;
  Remainingnotes = 0;
  movingAverageName !: string;
  movingAveragePeriod !: number;
  movingAverageType !: string;
  public _groupWidth = '70%';
  CREnoteID: any;
  objectID: any;
  Completed = 0;
  Running = 0;
  Processing = 0;
  firstcall = 1;
  Dependents = 0;
  DataSavedinDB = 0;
  SavedPendinginDB = 0;
  CalcSubmit = 0;
  public _dtUTCHours: number;
  public _userOffset: number;
  public _centralOffset: number;
  MaxCalculatedtime: any;
  columnSet: any;
  result: any;
  CalculationRequesttime: any;
  TotalCalculationtimeinmin = 0;

  myList: any;
  dwdwStatus: any;

  lstcalculationlist: any;
  Pending = 0;
  CalcProgress = 0;
  Avgtime: any;
  multipleCREnoteID: any;
  public _note !: Note;
  MinCalculatedtime: any;
  palettes = 'standard,cocoa,coral,dark,highcontrast,light,midnight,modern,organic,slate,zen,cyborg,superhero,flatly,darkly,cerulan'.split(',');
  ScenarioId: string;
  ScenarioName: string;
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
  public _result: any;
  public _cachedeal = {};
  public _searchObj: any;
  public _pageSizeSearch: number = 10;
  public _pageIndexSearch: number = 1;
  public _totalCountSearch: number = 0;
  public _isLogsListFetching: boolean = false;
  multipleCREDealID: any;

  @ViewChild('chartpie') chartpie !: wjcChart.FlexPie;
  @ViewChild('UserSummary') UserSummary !: wjcChart.FlexChart;

  @ViewChild('ErrorMatrix') ErrorMatrix !: wjcChart.FlexChart;
  @ViewChild('DiscrepancySummary') DiscrepancySummary !: wjcChart.FlexChart;
  @ViewChild('chart') chart !: wjcChart.FlexChart;
  @ViewChild('flexcalculation') flex !: wjcGrid.FlexGrid;
  @ViewChild('rsChart') rsChart !: wjcChart.FlexChart;
  @ViewChild('rangeSelector') rangeSelector !: wjcChartInteraction.RangeSelector;

  public _lstScenario: any;
  public _scenariodc: Scenario;
  public wfstatus !: boolean;
  CalculationSummarylist: any;
  DiscrepancySummarylist: any[] = [];
  isLoading: boolean = false;

  XirrCompleted = 0;
  XirrRunning = 0;
  XirrProcessing = 0;
  XirrFailed = 0;
  public lstimportdataStatus: any;

  ValCompleted = 0;
  ValRunning = 0;
  ValProcessing = 0;
  ValFailed = 0;
  ValTotalCalculationtimeinmin = 0;
  ValAvgtime: any;
  ValErrorlist: any[] = [];
  VmStatusList: any[] = [];
  public _EnvConfig: EnvConfig;
  public _lstEnvConfig: any;
  envName: string;
  public _showConfirmationDialog: boolean;
  ValuationCalculationSummarylist: any;
  ValuationMarkedDateSummarylist: any;
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
    var scenarioid: any = window.localStorage.getItem("scenarioid");
    this.ScenarioId = scenarioid;
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
    this.getallStatus();
    this.GetStagingDataIntoIntegrationStatus();

    this._EnvConfig = new EnvConfig();
    this._showConfirmationDialog = false;
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

  ShowCalcDashBoardData() {
    setTimeout(() => {
      if (this.ErrorMatrix) {
        this.ErrorMatrix.invalidate();
      }
    }, 1000);
  }
  selectionChanged(s: any, e: any) {
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

  stSummaryRendered() {
    var stChart = this.DiscrepancySummary;
    var value = "20px";
    if (!stChart) {
      return;
    }
    stChart.palette = ['rgba(139, 0, 139)'];
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

  getEnumNames(enumClass: any) {
    var names = [];
    for (var key in enumClass) {
      var val = parseInt(key);
      if (isNaN(val)) names.push(key);
    }
    return names;
  }
  showDialogCustom(controlid: any): void {
    var modalRole: any = document.getElementById(controlid);
    modalRole.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }

  GCloseCreatePopUp(controlid: any): void {
    var modal: any = document.getElementById(controlid);
    modal.style.display = "none";
    this._showConfirmationDialog = false;
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
          this.DataSavedinDB = 0;

          var result = res.CalculationStatus;
          var resuser = res.UserRequestCount;
          for (var i = 0; i < resuser.length; i++) {
            data.push({
              name: resuser[i].Name,
              value: resuser[i].value
            });
          }

          for (var i = 0; i < result.length; i++) {
            if (result[i].Name == "Failed") {
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
            if (result[i].Name == "SaveDBPending") {
              this.DataSavedinDB = result[i].value;
            }

          }
          if (this.DataSavedinDB != 0) {
            this.SavedPendinginDB = this.DataSavedinDB;
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
          var jsonname = "Note_" + this.CREnoteID + "_Calc_" + this.ScenarioName +".json"
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

  GetLogsExcel(): void {
    this._isLogsListFetching = true;
    this.devDashBoardService.downloadLogsExcel(this.objectID).subscribe(res => {
      setTimeout(function () {
        this._isLogsListFetching = false;
      }.bind(this), 5000);

      var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '_');
      var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '_');

      var fileName = this.objectID + "_ErrorLogs_" + displayDate + "_" + displayTime + ".xlsx";

      let b: any = new Blob([res]);
      let dwldLink = document.createElement("a");
      let url = URL.createObjectURL(b);
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

      this._isLogsListFetching = false;

      error => {
        console.error('Error downloading Excel file:', error);
        setTimeout(function () {
          this._isLogsListFetching = false;
        }.bind(this), 5000);
      }
    });
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
          setTimeout(() => {
            this._ShowmessagedivMsgWar = false;
          }, 5000);
        }
        else {
        }
      });
    } catch (err) {
    }
  }
  CalcAllNotes(): void {
    try {

      this.devDashBoardService.CalcAllNotes(this.ScenarioId).subscribe(res => {
        if (res.Succeeded) {
          this.multipleCREnoteID = "";
          this._ShowmessagedivMsgWar = true;
          this.GetCalcStatus();
          this._WaringMessage = "Notes queued for calculation";
          this.GCloseCreatePopUp("myModalCalculate");
          setTimeout(() => {
            this._ShowmessagedivMsgWar = false;
          }, 5000);
        }
        else {
        }
      });
    } catch (err) {
    }
  }


  downloadJson(myJson: any, filename: any) {
    var sJson = JSON.stringify(myJson);
    var element = document.createElement('a');
    element.setAttribute('href', "data:text/json;charset=UTF-8," + encodeURIComponent(sJson));
    element.setAttribute('download', filename);
    element.style.display = 'none';
    document.body.appendChild(element);
    element.click();
    document.body.removeChild(element);
  }

  RefreshReport(): void {
    var d = new Date();
    var datestring = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate() + " " +
      d.getHours() + ":" + d.getMinutes();
    this.devDashBoardService.RefreshDataWarehouse(datestring).subscribe(res => {
      if (res.Succeeded) {
        this._ShowmessagedivMsgWar = true;
        this._WaringMessage = res.Message;
        setTimeout(() => {
          this._ShowmessagedivMsgWar = false;
        }, 5000);
      }
      else {

      }
    });
  }

  importStagingData(): void {
    this.devDashBoardService.importStagingData().subscribe(res => {
      if (res.Succeeded) {
        this._ShowmessagedivMsgWar = true;
        this._WaringMessage = res.Message;
        setTimeout(() => {
          this._ShowmessagedivMsgWar = false;
        }, 5000);
      }
      else {

      }
    });
  }

  getLogByType(logtype: any): void {
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
              if (this.Logtype == "ExportFutureFunding" || this.Logtype == "Calculator") {
                var columns = flexGrid.columns;
                columns[1].visible = false;
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

  flexcalculationInitialized(flexGrid: any) {
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
    var scenarioid: any = window.localStorage.getItem("scenarioid");
    downloadCashFlow.AnalysisID = scenarioid;
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

  downloadFile(objArray: any) {
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

  ConvertToCSV(objArray: any) {
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
      //this.GetDiscrepancySummary();
      //this.getFailedNotes();
      //this.GetDWStatus();
      this.GetValuationCalculationSummary();
    } catch (err) {
      this.loggingService.writeToLog("DevDashBoard", "error", err.stack);
    }

  }

  getAllDistinctScenario(): void {
    var user: any = localStorage.getItem('user');
    var _userData = JSON.parse(user);
    this._scenariodc.UserID = _userData.UserID;
    this.scenarioService.getAllScenarioDistinct(this._scenariodc).subscribe(res => {
      if (res.Succeeded) {
        if (res.lstScenarioUserMap.length > 0) {
          this._lstScenario = res.lstScenarioUserMap;
          this.ScenarioId = res.lstScenarioUserMap.filter((x: any) => x.ScenarioName == "Default")[0].AnalysisID;
          this.ScenarioName = res.lstScenarioUserMap.filter(x => x.AnalysisID == this.ScenarioId)[0].ScenarioName;
          this._scenariodc.AnalysisID = this.ScenarioId;
          //this._calculationManager.AnalysisID = this.ScenarioId;
        }
      }
    });
  }
  changeScenario(value: any): void {
    this.ScenarioId = value.target.value;
    this.ScenarioName = this._lstScenario.filter(x => x.AnalysisID == this.ScenarioId)[0].ScenarioName;
    this.GetCalcStatus();
  }

  ok(): void {
    var dialogoverlay: any = document.getElementById('dialogoverlay');
    var dialogbox: any = document.getElementById('dialogbox');
    dialogbox.style.display = "none";
    dialogoverlay.style.display = "none";
  }

  getPalette(): string[] {
    return wjcChart.Palettes['highcontrast'];
  }
  GetErrorCount(): void {
    this.devDashBoardService.GetErrorCount().subscribe(res => {
      var data = res.UserRequestCount;
      this.userlist = res.ResultList;
      this.itemsError = data;
      this.CalculationSummarylist = res.CalcSummary;
    });
  }


  downloadExcelOutput(Name: any, DataTable: any) {
    if (DataTable.length > 0) {
      var datatab = this.ConvertToCSV(DataTable);
      var data = datatab;
      var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '-');
      var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '-');
      var fileName = Name + ".csv";

      let blob = new Blob(['\ufeff' + data], { type: 'text/csv;charset=utf-8;' });

      let dwldLink = document.createElement("a");
      let url = URL.createObjectURL(blob);
      let isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
      if (isSafariBrowser) {
        dwldLink.setAttribute("target", "_blank");
      }
      dwldLink.setAttribute("href", url);
      dwldLink.setAttribute("download", fileName);
      dwldLink.style.visibility = "hidden";
      document.body.appendChild(dwldLink);
      dwldLink.click();
      document.body.removeChild(dwldLink);
    } else {
      alert("No data to download.");
    }
  }



  onChartSelectionChanged(s: any, event: any): void {
    if (s.selection) {
      var selectedItem = s.selection.collectionView.currentItem;
      if (selectedItem) {
        var tableName = selectedItem.Item1;
        var tableData = selectedItem.Item2;
        this.downloadExcelOutput(tableName, tableData);
      }
    }
  }

  GetDiscrepancySummary(): void {
    this.isLoading = true;

    this.devDashBoardService.GetFirstDiscrepancySummary().subscribe(firstHalfRes => {
      this.DiscrepancySummarylist = firstHalfRes.DataTablesList;
      //console.log(this.DiscrepancySummarylist);
      this.devDashBoardService.GetSecondDiscrepancySummary().subscribe(secondHalfRes => {
        this.DiscrepancySummarylist = this.DiscrepancySummarylist.concat(secondHalfRes.DataTablesList2);
        this.isLoading = false;
      });
    });
  }



  //writeToLog(module: string, logtype: string, logtext: string)
  //{
  //    var text = module + "||" + logtype + "||" + logtext;
  //}

  //AI dashBoard Section  started

  
  addPieChart(itemlist: any, Chartheader: any) {
    var container: any = document.querySelector('.dynamicpie');

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

  GenricAddPieChart(itemlist: any, Chartheader: any, Classname: any) {
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
    var container: any = document.querySelector('.Userdynamicchart');
    container.innerHTML = "";

    container = document.querySelector('.Userdynamicpie');
    container.innerHTML = "";

  }

  GenricAddChart(charttype: any, itemlist: any, Chartheader: any, classname: any) {
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

  addChart(charttype: any, itemlist: any, Chartheader: any) {
    var container: any = document.querySelector('.dynamicchart');
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
  GetXIRRSummaryfordevdash(): void {
    try {
      this.devDashBoardService.GetXIRRSummaryfordevdash().subscribe(res => {
        if (res.Succeeded) {

          this.XirrCompleted = 0;
          this.XirrProcessing = 0;
          this.XirrRunning = 0;
          this.XirrFailed = 0;

          var result = res.XIRRStatusSummary;

          for (var i = 0; i < result.length; i++) {
            if (result[i].Name == "Failed") {
              this.XirrFailed = result[i].value;
            }
            if (result[i].Name == "Completed") {
              this.XirrCompleted = result[i].value;
            }
            if (result[i].Name == "Running") {
              this.XirrRunning = result[i].value;
            }
            if (result[i].Name == "Processing") {
              this.XirrProcessing = result[i].value;
            }


            //
          }

        }
        else {
        }
      });
    } catch (err) {
    }
  }
  GetCalculationStatusForValuation(): void {
    try {
      this.devDashBoardService.GetCalculationStatusForValuationDashBoard().subscribe(res => {
        if (res.Succeeded) {

          this.ValCompleted = 0;
          this.ValProcessing = 0;
          this.ValRunning = 0;
          this.ValFailed = 0;

          var result = res.CalculationStatus;

          for (var i = 0; i < result.length; i++) {
            if (result[i].Name == "Failed") {
              this.ValFailed = result[i].value;
            }
            if (result[i].Name == "Completed") {
              this.ValCompleted = result[i].value;
            }
            if (result[i].Name == "Running") {
              this.ValRunning = result[i].value;
            }
            if (result[i].Name == "Processing") {
              this.ValProcessing = result[i].value;
            }
            if (result[i].Name == "Total Calculation time in min") {
              this.ValTotalCalculationtimeinmin = result[i].value;
            }
          }

          var totalcount = this.ValCompleted + this.ValFailed;
          if (this.ValTotalCalculationtimeinmin != null && this.ValTotalCalculationtimeinmin != 0) {
            this.ValAvgtime = (totalcount / this.ValTotalCalculationtimeinmin);
            this.ValAvgtime = parseFloat(this.ValAvgtime.toString()).toFixed(2);
          }
          this.ValErrorlist = result.filter(x => x.IsChart == "calcerror");
          this.GetGetAzureVMStatus();
        }
        else {
        }
      });
    } catch (err) {
    }
  }

  GetGetAzureVMStatus(): void {
    try {
      this.devDashBoardService.GetGetAzureVMStatusAPI().subscribe(res => {
        if (res.Succeeded) {
          this.VmStatusList = res.dt;
        }
        else {
        }
      });
    } catch (err) {
    }
  }

  GetEnvConfig(): void {
    this.devDashBoardService.GetEnvConfig().subscribe(res => {
      if (res.Succeeded) {
        this._EnvConfig = res.lstEnvConfig;
        this._lstEnvConfig = res.lstEnvConfig;
      }
    });
  }

  changeEnvName(e: any): void {
    this.envName = e.target.value;
  }

  RepairDeal(): void {
    if (this.envName != null && this.envName != "") {
      if (this._EnvConfig.DealID != null && this._EnvConfig.DealID != "") {
        var selectedEnvConfig = this._lstEnvConfig.find(x => x.EnvName == this.envName);
        this.devDashBoardService.CheckEnvConnection(selectedEnvConfig).subscribe(res => {
          if (res.Succeeded) {
            //Call deal import method from other source
            var modalRole: any = document.getElementById('myModalConfirmRepairDeal');
            modalRole.style.display = "block";
            $.getScript("/js/jsDrag.js");
            this._showConfirmationDialog = true;
          }
        });
      }
      else {
        this._ShowmessagedivMsgWar = true;
        this._WaringMessage = "Please enter Deal ID then press repair deal.";
        setTimeout(function () {
          this._ShowmessagedivMsgWar = false;
          this._WaringMessage = "";
        }.bind(this), 5000);
      }
    }
    else {
      this._ShowmessagedivMsgWar = true;
      this._WaringMessage = "Please select environment then press repair deal.";
      setTimeout(function () {
        this._ShowmessagedivMsgWar = false;
        this._WaringMessage = "";
      }.bind(this), 5000);
    }
  }

  ImportDeal(): void {
    this._isNoteListFetching = true;
    this.GCloseCreatePopUp('myModalConfirmRepairDeal');
    var selectedEnvConfig = this._lstEnvConfig.find(x => x.EnvName == this.envName);
    //Call deal import method from other source
    selectedEnvConfig.DealID = this._lstEnvConfig.DealID;
    selectedEnvConfig.NoteID = this._lstEnvConfig.NoteID;
    this.devDashBoardService.ImportDealFromOtherSource(selectedEnvConfig).subscribe(res => {
      if (res.Succeeded) {
        this._ShowmessagedivMsgWar = true;
        this._WaringMessage = "Deal imported successfully from the other source.";
        setTimeout(function () {
          this._ShowmessagedivMsgWar = false;
          this._WaringMessage = "";
          this._isNoteListFetching = false;
        }.bind(this), 5000);
      }
    });
    this._showConfirmationDialog = false;
  }

  GetValuationLogsExcel(): void {
    this._isLogsListFetching = true;
    this.devDashBoardService.downloadValuationLogsExcel(this.objectID).subscribe(res => {
      setTimeout(function () {
        this._isLogsListFetching = false;
      }.bind(this), 5000);

      var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '_');
      var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '_');

      var fileName = "ValuationLogs_" + displayDate + "_" + displayTime + ".xlsx";

      let b: any = new Blob([res]);
      let dwldLink = document.createElement("a");
      let url = URL.createObjectURL(b);
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

      this._isLogsListFetching = false;

      error => {
        console.error('Error downloading Excel file:', error);
        setTimeout(function () {
          this._isLogsListFetching = false;
        }.bind(this), 5000);
      }
    });
  }

  GetValuationCalculationSummary(): void {
    this.devDashBoardService.GetValuationCalculationSummary().subscribe(res => {
      var result = res.CalcSummary;

      this.ValuationCalculationSummarylist = result.filter(x => x.GridType == "ServerName");
      this.ValuationMarkedDateSummarylist = result.filter(x => x.GridType == "MarkedDate");
    });
  }

  CalculateMultipleDeal(): void {
    try {
      this._devDashBoard.DealID = this.multipleCREDealID;
      this._devDashBoard.ScenarioID = this.ScenarioId;
      this.devDashBoardService.CalculateMultipleDeals(this._devDashBoard).subscribe(res => {
        if (res.Succeeded) {
          this.multipleCREDealID = "";
          this._ShowmessagedivMsgWar = true;
          this.GetCalcStatus();
          this._WaringMessage = "Deals queued for calculation";
          this.GCloseCreatePopUp("myModalCalculateDeal");
          setTimeout(() => {
            this._ShowmessagedivMsgWar = false;
          }, 5000);
        }
        else {
        }
      });
    } catch (err) {
    }
  }
}
const routes: Routes = [
  { path: '', component: DevDashBoardComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjChartModule, WjGridModule, WjInputModule, WjGridFilterModule, WjChartInteractionModule],
  declarations: [DevDashBoardComponent]
})

export class devDashBoardModule { }
