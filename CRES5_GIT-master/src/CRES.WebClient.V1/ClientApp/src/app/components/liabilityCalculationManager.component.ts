import { Component, OnInit, AfterViewInit, ViewChild, OnDestroy, HostListener } from '@angular/core';
import { Router } from '@angular/router';
import * as wjcGrid from '@grapecity/wijmo.grid';
import { CalculationManagerService } from '../core/services/calculationManager.service'
import { NoteService } from '../core/services/note.service';
import { LiabilityCalcStatus } from "../core/domain/LiabilityCalcStatus.model";
import { exceptions } from "../core/domain/exceptions.model";
import { UtilityService } from '../core/services/utility.service';
import { Paginated } from '../core/common/paginated.service';
import * as wjNg2Input from '@grapecity/wijmo.angular2.input';
import * as wjNg2GridFilter from '@grapecity/wijmo.angular2.grid.filter';
import { Subscription } from "rxjs";
import { NoteCashflowsExportDataList } from "../core/domain/noteCashflowsExportDataList.model";
import { Note, DownloadCashFlow } from "../core/domain/note.model";
import { ModuleWithProviders, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import { PermissionService } from '../core/services/permission.service';
import { SignalRService } from './../Notification/signalR.service';
import { TestCase } from "../core/domain/testCase.model";
import { scenarioService } from '../core/services/scenario.service';
import { Scenario } from "../core/domain/scenario.model";
import { User } from '../core/domain/user.model';
import { BatchCalculationMaster } from '../core/domain/batchCalculationMaster.model';
import { FileUploadService } from '../core/services/fileUpload.service';
import { DomSanitizer } from '@angular/platform-browser';
import { WjInputModule } from '@grapecity/wijmo.angular2.input';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { AppSettings } from '../core/common/appsettings';
import { DataService } from '../core/services/data.service';
import { equityService } from '../core/services/equity.service';
declare var XLSX: any;

@Component({
  templateUrl: "./liabilityCalculationManager.html",
  providers: [CalculationManagerService, NoteService, PermissionService, scenarioService, FileUploadService, equityService, DataService]
})

export class LiabilityCalculationManagerComponent extends Paginated {
  private rowsToUpdate: any = [];
  lstcalculationlist: Array<LiabilityCalcStatus> = new Array<LiabilityCalcStatus>();
  // private routes = Routes;
  private lstLiabilitySummary: any;
  private Message: any = '';
  private lstexceptions: any;
  public _Showmessagediv: boolean = false;
  public _ShowSuccessmessagediv: boolean = false;
  private _ShowSuccessmessage: any;

  public _ShowSuccessmessagedivclose: boolean = false;
  private _ShowSuccessmessageclose: any;

  public _isCalcListFetching: boolean = false;
  _chkSelectAll: boolean = false;
  private subscriptionLoad: Subscription;
  private subscription: Subscription;
  public _isShowDownloadCashflows: boolean = false;
  private _lastExecutedTime: any;
  public _ShowSuccessmessageTestcasediv: boolean = false;
  private _ShowSuccessmessageTestcase: any;
  public _norecordtestcase: boolean = false;
  public currentoffset: any;
  @ViewChild('flexcalculation') flex: wjcGrid.FlexGrid;
  @ViewChild('flexLiabilitySummary') flexLiabilitySummary: wjcGrid.FlexGrid;
  @ViewChild('filter') gridFilter: wjNg2GridFilter.WjFlexGridFilter;

  //@ViewChild('flexNoteCashflowsExportDataList') flexNoteCashflowsExportDataList: wijmo.grid.FlexGrid;


  processing: number = 0;
  Running: number = 0;
  Completed: number = 0;
  Failed: number = 0;
  Dependents: number = 0;
  Remainingnotes: number = 0;
  CalcSubmit: number = 0;
  private arrnew: any = [];
  totalcount: number = 0;
  private refreshcount: number = 0;
  private finalCall: number = 0;
  public _isExceptionListFetching: boolean = false;
  public _fetchingDownloadstatus: boolean = false;

  public _ExceptionListCount: number = 1;
  private _testcasecount: number = 0;
  private _noteCashflowsExportDataList: NoteCashflowsExportDataList;
  private _note: Note;
  private _testCase: TestCase;
  private _testCaseData: any;
  private _istestdataexist: boolean = false;
  public istestcasefetching: boolean = false;
  public dtNoteCashflowsExportData: any;
  private totalTestCasecount: number = 0;
  lstPortfolio: any;
  PortfolioMasterGuid: string = "00000000-0000-0000-0000-000000000000";
  _lstcalculationlistCount: number = 1;
  _calculationManager: LiabilityCalcStatus = new LiabilityCalcStatus("");

  ScenarioId: string;
  public _lstScenario: any;
  private _scenariodc: Scenario;
  public _user: User;
  ScenarioName: string;
  _lstcalculationlistCountOnDropDownFilter: number = 0;
  _lstcalculationlistCountOnGridFilter: number = 0;
  lstbatchlog: any
  lstCalculationSummary: any;
  _CalculationSummary: LiabilityCalcStatus = new LiabilityCalcStatus("");
  _batchcalc: BatchCalculationMaster = new BatchCalculationMaster("");
  public _lstlstbatchlogCount: number = 1;
  private NoteCountOnFirstLoad: number = 0;
  isAllowDebugInCalc: boolean = false;
  private _batchType: string = 'Single';
  iscancelCal: boolean = false;
  ctx: any;
  workbookXML: any;
  worksheetsXML: any;
  rowsXML: any;
  location: Location;
  public listtransactioncategory: any = [];
  public transacatename: any;
  @ViewChild('multiseltransactioncategory') multiseltransactioncategory: wjNg2Input.WjMultiSelect
  public flexchecked: boolean = false;
  lstCheckDuplicateTransactionCashflow: any;
  lastUrl: any;
  constructor(private _router: Router,
    public notesvc: NoteService,
    public calculationsvc: CalculationManagerService,
    public permissionService: PermissionService,
    public utilityService: UtilityService,
    public _signalRService: SignalRService,
    public scenarioService: scenarioService,
    public fileUploadService: FileUploadService,
    public equitySrv: equityService,
    public dataService: DataService,

    private sani: DomSanitizer,

  ) {
    super(50, 1, 0);

    this._user = JSON.parse(localStorage.getItem('user'));
    this._scenariodc = new Scenario('');
    this._lstScenario = this._scenariodc.LstScenarioUserMap;
    this.getAllDistinctScenario();
    this.subscribetoevent();
    this._chkSelectAll = false;
    this.GettimezoneCurrentOffset();
    this.finalCall = 1;
    this.utilityService.setPageTitle("M61–Calculation");
  }

  @HostListener('window:beforeunload', ['$event'])
  public beforeunloadHandler($event) {
    if (this._fetchingDownloadstatus == true) {
      $event.returnValue = "Download is in progress, Are you sure want to refresh the page ?";
    }

  }

  @HostListener('window:popstate', ['$event'])
  public onPopState($event) {
    if (this._fetchingDownloadstatus == true) {
      const confirmLeave = window.confirm('Download is in progress, Are you sure want to leave this page ?');

      //if (!confirmLeave) {
      //  history.pushState(null, '', window.location.href); // Prevent the back navigation
      //}
    }
  }

  @HostListener('window:pushstate', ['$event'])
  public onPushState($event) {
    if (this._fetchingDownloadstatus == true) {
      const confirmLeave = window.confirm('Download is in progress, Are you sure want to leave this page ?');

      //if (!confirmLeave) {
      //  history.pushState(null, '', window.location.href); // Prevent the back navigation
      //}
    }
  }

  ngOnInit() {
    this._calculationManager.AnalysisID = this.ScenarioId;
  }

  // Component views are initialized
  ngAfterViewInit() {
    // commit row changes when scrolling the grid
    this.flexLiabilitySummary.scrollPositionChanged.addHandler(() => {
      var myDiv = $('#flexLiabilitySummary').find('div[wj-part="root"]');
      //  alert(myDiv.prop('offsetHeight') + myDiv.scrollTop() + '  ' + myDiv.prop('scrollHeight'));
      if (myDiv.prop('offsetHeight') + myDiv.scrollTop() <= myDiv.prop('scrollHeight')) {
        if (this.flexLiabilitySummary.rows.length < this._ExceptionListCount) {
          this._pageIndex = this.pagePlus(1);
        }
      }
    });
  }



  public converteddatetime: any;
  private ConvertToBindableDate(Data, modulename, locale: string) {
    var options = { year: "numeric", month: "numeric", day: "numeric" };

    for (var i = 0; i < Data.length; i++) {

      if (this.lstcalculationlist[i].RequestTime != null) {
        this.lstcalculationlist[i].RequestTime = new Date(this.lstcalculationlist[i].RequestTime.toString());
      }
      if (this.lstcalculationlist[i].StartTime != null) {
        this.lstcalculationlist[i].StartTime = new Date(this.lstcalculationlist[i].StartTime.toString());
        if (this.lstcalculationlist[i].StartTime.getFullYear() < 2010) {
          this.lstcalculationlist[i].StartTime = null;
        }

      }
      if (this.lstcalculationlist[i].EndTime != null) {
        this.lstcalculationlist[i].EndTime = new Date(this.lstcalculationlist[i].EndTime.toString());
        if (this.lstcalculationlist[i].EndTime.getFullYear() < 2010) {
          this.lstcalculationlist[i].EndTime = null;
        }

      }


    }
  }

  private ConvertToBindableDateSummary(Data) {

    for (var i = 0; i < Data.length; i++) {

      if (this.lstLiabilitySummary[i].PledgeDate != null)
        this.lstLiabilitySummary[i].PledgeDate = new Date(this.lstLiabilitySummary[i].PledgeDate.toString());

      if (this.lstLiabilitySummary[i].EffectiveDate != null)
        this.lstLiabilitySummary[i].EffectiveDate = new Date(this.lstLiabilitySummary[i].EffectiveDate.toString());

      if (this.lstLiabilitySummary[i].MaturityDate != null)
        this.lstLiabilitySummary[i].MaturityDate = new Date(this.lstLiabilitySummary[i].MaturityDate.toString());


    }
  }

  ConvertToTimeZone(Data) {
    var d: any = Data;
    var amOrPm = (d.getHours() < 12) ? "AM" : "PM";
    var hour = (d.getHours() < 12) ? d.getHours() : d.getHours() - 12;
    var hr = (hour < 10) ? '0' + hour : hour;
    var minutes = (d.getMinutes() < 10) ? '0' + d.getMinutes() : d.getMinutes();
    var month = (d.getMonth() + 1 < 10) ? '0' + d.getMonth() + 1 : d.getMonth() + 1;
    var date = (d.getDate() < 10) ? '0' + d.getDate() : d.getDate();
    return this.converteddatetime = month + '-' + date + '-' + d.getFullYear() + ' ' + hr + ':' + minutes + ' ' + amOrPm;
  }
  convertDateToBindable(date) {
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
  }
  getTwoDigitString(number) {
    if (number.toString().length === 1)
      return "0" + number;
    return number;
  }

  SelectAll(): void {
    this._chkSelectAll = !this._chkSelectAll;
    //  var colindex = this.flex.getColumn('Active').index;
    for (var i = 0; i < this.flex.rows.length; i++) {
      this.flex.rows[i].dataItem.Active = this._chkSelectAll;
    }
    this.flex.invalidate();
  }

  RefreshStatusandGrid() {
    this._isCalcListFetching = true;

    this.RefreshCalcStatus();
    this.getCalculationStatus();
    if (this.flex) {
      setTimeout(() => {
        this.flex.invalidate();
      }, 1000);
    }
  }

  public sleep(delay) {
    var start = new Date().getTime();
    while (new Date().getTime() < start + delay);
  }

  getAllDistinctScenario(): void {
    var _userData = JSON.parse(localStorage.getItem('user'));
    this._scenariodc.UserID = _userData.UserID;
    this.scenarioService.getAllScenarioDistinct(this._scenariodc).subscribe(res => {
      if (res.Succeeded) {
        if (res.lstScenarioUserMap.length > 0) {
          this._lstScenario = res.lstScenarioUserMap;
          this.ScenarioId = res.lstScenarioUserMap.filter(x => x.ScenarioName == "Default")[0].AnalysisID;
          this.ScenarioName = res.lstScenarioUserMap.filter(x => x.ScenarioName == "Default")[0].ScenarioName;
          this._scenariodc.AnalysisID = this.ScenarioId;
          this._calculationManager.AnalysisID = this.ScenarioId;
          this.isAllowDebugInCalc = this._lstScenario[0].AllowDebugInCalc;
          this.RefreshCalcStatus();
          this.getCalculationStatus();
        }
      }
    });
  }

  public RefreshCalcStatus(): void {
    this._isCalcListFetching = true;
    this.equitySrv.getLiabilityCalculationStatus(this.ScenarioId).subscribe(res => {
      if (res.Succeeded) {
        //this._chkSelectAll = false;
        var data = res.LiabilityCalculationStatus;
        this.totalcount = res.LiabilityCalculationStatus.length;
        if (this.totalcount > 0) {
          this.lstcalculationlist = data;

          this.ConvertTimeaccordingtoUser(this.lstcalculationlist);
          this.ConvertToBindableDate(this.lstcalculationlist, "", "en-US");
          if (this.flex) {
            this.flex.columnHeaders.rows[0].height = 25;
            setTimeout(() => {
              this.flex.invalidate(true);
              this._isCalcListFetching = false;
            }, 200);

          }

        }
      }
    });
  }

  getCalculationStatus(): void {
    try {
      this.equitySrv.getLiabilityCalculationStatusForDashBoard(this.ScenarioId).subscribe(res => {
        if (res.Succeeded) {

          this.Completed = 0;
          this.processing = 0;
          this.Running = 0;
          this.Failed = 0;
          this.Dependents = 0;
          this.CalcSubmit = 0;

          var result = res.LiabilityCalculationStatus;

          for (var i = 0; i < result.length; i++) {
            if (result[i].Name == "Failed") {
              this.Failed = result[i].Count;
            }
            if (result[i].Name == "Completed") {
              this.Completed = result[i].Count;
            }
            if (result[i].Name == "Running") {
              this.Running = result[i].Count;
            }
            if (result[i].Name == "Processing") {
              this.processing = result[i].Count;
            }
            if (result[i].Name == "Dependents") {
              this.Dependents = result[i].Count;
            }
            if (result[i].Name == "CalcSubmit") {
              this.CalcSubmit = result[i].Count;
            }
          }
          this.Remainingnotes = this.processing + this.Dependents + this.CalcSubmit;
        }
        else {
        }
      });
    } catch (err) {
    }
  }

  public GetAllLiabilitySummary(): void {
    this.equitySrv.getLiabilitySummaryDashBoard().subscribe(res => {
      if (res.Succeeded) {
        this.lstLiabilitySummary = res.dt;
        this.ConvertToBindableDateSummary(this.lstLiabilitySummary);
      }
      else {
      }
    }, error => {
      this._Showmessagediv = true;
      this.Message = "Error Occurred While Loading Liability Relationship";
    });
    setTimeout(() => {
      this.flexLiabilitySummary.invalidate(true);
    }, 200);
    this._isExceptionListFetching = false;
  }


  invlaidatecalculationManagergrid() {
    if (this._scenariodc == null) {
      this.getAllDistinctScenario();
    }
    this.RefreshCalcStatus();
    this.getCalculationStatus();
    if (this.flex) {
      setTimeout(() => {
        this.flex.invalidate();
      }, 1000);
    }
  }

  CalcAtServer(): void {
    this._isCalcListFetching = true;
    let EquityAccountList: string[] = [];
    try {
      if (this.lstcalculationlist.filter(x => x.Active == true).length == 0) {
        this.CustomAlert('Please select fund for calculation.');
        this._isCalcListFetching = false;
      } else {
        for (var i = 0; i < this.lstcalculationlist.length; i++) {
          try {
            if (typeof this.lstcalculationlist[i].Active !== null) {
              if (this.lstcalculationlist[i].Active == true) {
                EquityAccountList.push(this.lstcalculationlist[i].AccountID);
              }
            }
          }
          catch (err) { console.log(err); }
        }
        this._isCalcListFetching = true;
        this.equitySrv.QueueEquityListForCalculation(EquityAccountList).subscribe(res => {
          if (res.Succeeded) {
            setTimeout(function () {
              this.RefreshStatusandGrid();
            }.bind(this), 5000);

          }
        });
      }
    } catch (err) {
      //alert(err);
    }
    /* this._isCalcListFetching = false;*/
  }

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
    document.getElementById('dialogboxhead').innerHTML = "CRES - web";
    document.getElementById('dialogboxbody').innerHTML = dialog;
  }

  ok(): void {
    document.getElementById('dialogbox').style.display = "none";
    document.getElementById('dialogoverlay').style.display = "none";
  }

  // convert Json to CSV data in Angular2

  subscribetoevent(): void {
    this._signalRService.updateCalcNotification.subscribe((message: any) => {
      var res = message.split('|*|');
      if (res[0] == "CALCMGR" && res[1] == AppSettings._notificationenvironment) {
        //let timer = TimerObservable.create(6000, 6000);
        //this.subscription = timer.subscribe(t => { this.GetCalcStatus(); });

        this.finalCall = 1;
        this.RefreshCalcStatus();
      }
    })
  }

  GetUserPermission(): void {
    try {
      this.permissionService.GetUserPermissionByPagename("CalculationManager").subscribe(res => {
        if (res.Succeeded) {
          if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
            var _object = res.UserPermissionList;
            var controlarrayedit = _object.filter(function (item) { return item.ModuleType === 'Control' && item.RightsName === 'Edit'; });

            for (var i = 0; i < controlarrayedit.length; i++) {
              if (controlarrayedit[i].ChildModule == 'btnCalculationManagerDownloadCashflows') {
                this._isShowDownloadCashflows = true;
              }
            }
          }
        }
      });
    } catch (err) {
      alert(err)
    }
  }

  changeScenario(value): void {
    this._lstcalculationlistCount = 1;
    this.ScenarioId = value;
    this._scenariodc.AnalysisID = this.ScenarioId;
    this._calculationManager.AnalysisID = this.ScenarioId;
    this.ScenarioName = this._lstScenario.filter(x => x.AnalysisID == value)[0].ScenarioName;
    this.RefreshCalcStatus();
  }

  ddlScenarioChange(obj): void {
    this.ScenarioId = obj;
    //this._calculationManager.AnalysisID = this.ScenarioId;
  }

  HideMenu(): boolean {
    var ret_val = false;
    var rolename = window.localStorage.getItem("rolename");
    if (rolename != null) {
      if (rolename.toString() == "Super Admin") {
        ret_val = true;
      }
    }
    return ret_val
  }

  GettimezoneCurrentOffset() {
    this.calculationsvc.GettimezoneCurrentOffset().subscribe(res => {
      if (res.Succeeded) {
        this.currentoffset = res.currentoffset;
      }
    });
  }

  ConvertTimeaccordingtoUser(data) {
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
          //  dt = d.getDate() - 1;
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
  }

  GetExportExcelLiabilityRelationship(): void {
    this._isCalcListFetching = true;
    var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '');
    var displayTime = new Date().getTime();
    var environmentName = this.dataService._environmentNamae != '' ? "(" + this.dataService._environmentNamae.replace("-", "").trim() + ") " : "";

    var fileName = environmentName + " " + "Liability_Relationship_" + displayDate + "_" + displayTime + ".xlsx";


    this.equitySrv.GetExportExcelLiabilitySummaryDashBoard().subscribe(res => {
      if (res.size > 8047 && res.type != "") {
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
        this._isCalcListFetching = false;
      } else {

        this.ShowErrorMessageFiledDownload();
      }

    });

  }
  ShowErrorMessageFiledDownload() {
    this._isCalcListFetching = false;
    this._Showmessagediv = true;
    this.Message = "An error occurred while downloading Liability Summary. Please contact m61 support.";
    setTimeout(function () {
      this._Showmessagediv = false;
    }.bind(this), 5000);
  }

}


const routes: Routes = [
  { path: '', component: LiabilityCalculationManagerComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjGridModule, WjGridFilterModule, WjInputModule, WjCoreModule],
  declarations: [LiabilityCalculationManagerComponent]
})

export class LiabilityCalculationManagerModule { }
