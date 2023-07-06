import { Component, OnInit, AfterViewInit, ViewChild, OnDestroy } from '@angular/core';
import { Router } from '@angular/router';
import * as wjcGrid from '@grapecity/wijmo.grid';
import { CalculationManagerService } from '../core/services/calculationManager.service'
import { NoteService } from '../core/services/note.service';
import { CalculationManagerList } from "../core/domain/calculationManagerList.model";
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
import { Notificationsettings } from '../../../../appsettings.json';
import { TestCase } from "../core/domain/testCase.model";
import { portfolioService } from '../core/services/portfolio.service'
import { scenarioService } from '../core/services/scenario.service';
import { Scenario } from "../core/domain/scenario.model";
import { User } from '../core/domain/user.model';
import { BatchCalculationMaster } from '../core/domain/batchCalculationMaster.model';
import { FileUploadService } from '../core/services/fileUpload.service';
import { DomSanitizer } from '@angular/platform-browser';
import { WjInputModule } from '@grapecity/wijmo.angular2.input';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
declare var XLSX: any;

@Component({
  templateUrl: "./calculationManager.html",
  providers: [CalculationManagerService, NoteService, PermissionService, portfolioService, scenarioService, FileUploadService]
})

export class CalculationManagerComponent extends Paginated {
  //export class CalculationManagerComponent  {
  public notelist: Array<CalculationManagerList> = new Array<CalculationManagerList>();
  public rowsToUpdate: any = [];
  lstcalculationlist: Array<CalculationManagerList> = new Array<CalculationManagerList>();
  // private routes = Routes;
  public lstnotesexceptions: any;
  public Message: any = '';
  public lstexceptions: any;
  public _Showmessagediv: boolean = false;
  public _ShowSuccessmessagediv: boolean = false;
  public _ShowSuccessmessage: any;
  public _isCalcListFetching: boolean = false;
  _chkSelectAll: boolean = false;
  public subscriptionLoad !: Subscription;
  public subscription !: Subscription;
  public _isShowDownloadCashflows: boolean = false;
  public _lastExecutedTime: any;
  public _ShowSuccessmessageTestcasediv: boolean = false;
  public _ShowSuccessmessageTestcase: any;
  public _norecordtestcase: boolean = false;
  public currentoffset: any;
  @ViewChild('flexcalculation') flex !: wjcGrid.FlexGrid;
  @ViewChild('flexnoteexceptions') flexnoteexceptions !: wjcGrid.FlexGrid;
  @ViewChild('flextestcase') flextestcase !: wjcGrid.FlexGrid;
  @ViewChild('filter') gridFilter !: wjNg2GridFilter.WjFlexGridFilter;
  @ViewChild('flexbatch') flexbatch !: wjcGrid.FlexGrid;

  //@ViewChild('flexNoteCashflowsExportDataList') flexNoteCashflowsExportDataList: wijmo.grid.FlexGrid;
  public arrnew: any = [];
  totalcount: number = 0;
  public refreshcount: number = 0;
  public finalCall: number = 0;
  public _isExceptionListFetching: boolean = false;
  public _ExceptionListCount: number = 1;
  public _testcasecount: number = 0;
  public _noteCashflowsExportDataList: NoteCashflowsExportDataList;
  public _note !: Note;
  public _testCase !: TestCase;
  public _testCaseData: any;
  public _istestdataexist: boolean = false;
  public istestcasefetching: boolean = false;
  public dtNoteCashflowsExportData: any;
  public totalTestCasecount: number = 0;
  lstPortfolio: any
  PortfolioMasterGuid: string = "00000000-0000-0000-0000-000000000000"
  _lstcalculationlistCount: number = 1;
  _calculationManager: CalculationManagerList = new CalculationManagerList("");

  ScenarioId !: string
  CalculationModeID !: number;

  lstCalculationMode: any;
  public _lstScenario: any;
  public _scenariodc: Scenario;
  public _user: User;
  ScenarioName !: string;
  _lstcalculationlistCountOnDropDownFilter: number = 0;
  _lstcalculationlistCountOnGridFilter: number = 0;
  lstbatchlog: any;
  _batchcalc: BatchCalculationMaster = new BatchCalculationMaster("");
  public _lstlstbatchlogCount: number = 1;
  public NoteCountOnFirstLoad: number = 0;
  isAllowDebugInCalc: boolean = false;
  public _batchType: string = 'Single';

  ctx: any;
  workbookXML: any;
  worksheetsXML: any;
  rowsXML: any;
  location !: Location;
  public listtransactioncategory: any = [];
  public transacatename: any;
  _chkSelectdownloadAll: boolean = false;
  @ViewChild('multiseltransactioncategory') multiseltransactioncategory !: wjNg2Input.WjMultiSelect
  public flexchecked: boolean = false;
  public showWarningMsgdashboard !: boolean;

  constructor(private _router: Router,
    public notesvc: NoteService,
    public calculationsvc: CalculationManagerService,
    public permissionService: PermissionService,
    public utilityService: UtilityService,
    public _signalRService: SignalRService,
    public _portfolioService: portfolioService,
    public scenarioService: scenarioService,
    public fileUploadService: FileUploadService,
    private sani: DomSanitizer,

  ) {
    super(50, 1, 0);
    var user: any = localStorage.getItem('user');
    this._user = JSON.parse(user);
    this._scenariodc = new Scenario('');
    this._lstScenario = this._scenariodc.LstScenarioUserMap;
    this.getAllDistinctScenario();
    this.subscribetoevent();
    this._chkSelectdownloadAll = false;
    this._chkSelectAll = false;
    // this.notelist = new CalculationManagerList("");
    this._noteCashflowsExportDataList = new NoteCashflowsExportDataList();
    this.GettimezoneCurrentOffset();
    this.RefreshCalculationStatus();
    this.finalCall = 1;
    this.utilityService.setPageTitle("M61–Calculation");
    this.GetUserPermission();
    this.GetTransactionCategory();

  }

  ngOnInit() {
    var calcmodeid:any = window.localStorage.getItem("CalculationModeID");
    this.CalculationModeID = parseInt(calcmodeid);

    this._scenariodc.CalculationModeID = this.CalculationModeID;
    this._calculationManager.PortfolioMasterGuid = "00000000-0000-0000-0000-000000000000";
    this._calculationManager.AnalysisID = this.ScenarioId;
    this.GetAllLookups();
    this.GetAllPortfolio();
    this.GetCalcStatus();
  }

  GetAllPortfolio(): void {
    this._portfolioService.getallportfolio().subscribe(res => {
      if (res.Succeeded) {
        var data = res.lstportfolio;
        this.lstPortfolio = data;
      }
    });
  }

  ChangeDynamicPortfolio(newvalue:any): void {
    this._lstcalculationlistCount = 1;
    this._calculationManager.PortfolioMasterGuid = newvalue.target.value;
    this.RefreshCalculationStatus()
  }

  // Component views are initialized
  ngAfterViewInit() {
    // commit row changes when scrolling the grid
    this.flexnoteexceptions.scrollPositionChanged.addHandler(() => {
      var myDiv = $('#flexnoteexceptions').find('div[wj-part="root"]');
      //  alert(myDiv.prop('offsetHeight') + myDiv.scrollTop() + '  ' + myDiv.prop('scrollHeight'));
      if (myDiv.prop('offsetHeight') + myDiv.scrollTop() <= myDiv.prop('scrollHeight')) {
        if (this.flexnoteexceptions.rows.length < this._ExceptionListCount) {
          this._pageIndex = this.pagePlus(1);
          this.GetAllExceptions();
        }
      }
    });

    this.flextestcase.scrollPositionChanged.addHandler(() => {
      var mytestDiv = $('#flextestcase').find('div[wj-part="root"]');
      if (mytestDiv.prop('offsetHeight') + mytestDiv.scrollTop() <= mytestDiv.prop('scrollHeight')) {
        if (this.flextestcase.rows.length < this._testcasecount) {
          this._pageIndex = this.pagePlus(1);
          this._istestdataexist = false;
          this.GetTestcases(false);
        }
      }
    });

    if (this.lstcalculationlist) {
      this.gridFilter.filterApplied.addHandler(() => {
        for (var i = 0; i < this.lstcalculationlist.length; i++) {
          this.lstcalculationlist[i].Active = false;
          this.lstcalculationlist[i].downloadnote = false;
        }
        this.RefreshCalcStatus();
      });
    }


  }

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


  public RefreshCalculationStatus(): void {
    this._isCalcListFetching = true;
    this.calculationsvc.refreshCalculation(this._calculationManager).subscribe(res => {
      if (res.Succeeded) {
        if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
          var data = res.lstCalculationManger;
          this.totalcount = res.lstCalculationManger.length;
          this._lstcalculationlistCount = this.totalcount;
          this._lstcalculationlistCountOnDropDownFilter = res.lstCalculationManger.length;
          this._lstcalculationlistCountOnGridFilter = res.lstCalculationManger.length;
          if (this.totalcount > 0) {
            this.lstcalculationlist = data;
            for (var i = 0; i < this.totalcount; i++) {
              this.flex.invalidate();
            }
            var calctextcolindex = this.flex.getColumn("EnableM61CalculationsText").index;
            var calccheckboxcol = this.flex.getColumn("Active").index;
            if (this.flex) {
              this.flex.itemFormatter = function (panel, r, c, cell) {
                if (panel.cellType != wjcGrid.CellType.Cell) {
                  return;
                }
                var item = panel.getCellData(r, calctextcolindex,false);
                if (item == 'N') {
                  if (calccheckboxcol == panel.columns[c].index) {
                    cell.style.backgroundColor = '#cfcfcf';
                  } else {
                    cell.style.backgroundColor = "none";
                  }
                  //   panel.grid.rows[r].isReadOnly = true;


                } else {
                  cell.style.backgroundColor = "none";
                }
              }
            }

            this.ConvertToBindableDate(this.lstcalculationlist, "", "en-US");

            setTimeout(() => {
              //this.flex.autoSizeColumns(0, this.flex.columns.length - 1, false, 30);
              this._isCalcListFetching = false;
            }, 1);
          }
          else {
            this.lstcalculationlist = [];
            this._isCalcListFetching = false;
          }
        } else {
          localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
          localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));

          this.utilityService.navigateUnauthorize();
        }
        if (this.NoteCountOnFirstLoad == 0) {
          this.NoteCountOnFirstLoad = this.totalcount
        }

      }
    });
  }

  cellEditbeginCalc(s:any, e:any) {
    if (s.rows[e.row]._data.EnableM61CalculationsText == "N") {
      if (e.col.toString() == "0") {
        s.rows[e.row]._data.downloadnote = false;
        e.cancel = true;
      } else {
        e.cancel = false;
      }
    }
    this.flex.invalidate();
  }

  public CancelBatchCalculationRequest(): void {
    this._isCalcListFetching = true;
    this.calculationsvc.deleteBatchCalculationRequestByAnalysisID(this.ScenarioId).subscribe(res => {
      if (res.Succeeded) {
        this._ShowSuccessmessage = "Last batch calculation request reset successfully.";
        this._ShowSuccessmessagediv = true;
        setTimeout(() => {
          this._ShowSuccessmessagediv = false;
          this._isCalcListFetching = false;
        }, 5000);

      } else {
        localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
        localStorage.setItem('WarmsgdashBoad', JSON.stringify('Error occurred while processing request'));
        setTimeout(() => {
          this.showWarningMsgdashboard = false;
          this._isCalcListFetching = false;
        }, 5000);
      }
    });
  }

  public getAllExceptions(): void { }

  CalcAtServerDialog(): void {
    this.rowsToUpdate = [];
    // for (var i = 0; i < this.totalcount; i++) {
    for (var i = 0; i < this.lstcalculationlist.length; i++) {
      try {
        if (this.lstcalculationlist[i].EnableM61CalculationsText == 'Y') {
          if (typeof this.lstcalculationlist[i].Active !== null) {
            // console.log(i);
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
      catch (err) { console.log(err); }
    }
    if (this.flex) {
      this.flex.invalidate();
    }
    var templenght = 0;
    templenght = Object.keys(this.rowsToUpdate).length;
    this.notelist = this.rowsToUpdate;
    if (templenght > 0) {
      //if (this.lstcalculationlist.filter(x => x.Active == true).length == this.NoteCountOnFirstLoad && this.NoteCountOnFirstLoad > 0) {
      if (this.lstcalculationlist.filter(x => x.Active == true).length == this._lstcalculationlistCountOnGridFilter && this._lstcalculationlistCountOnGridFilter > 0) {
        var modaltag:any = document.getElementById('myModalConfirmTag');
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

  }

  CalcAtServerWithConfirm(event:any): void {
    this.CloseModalConfirmTag();
    if (event.target.id == 'tagYes') {
      this._batchType = 'AllWithTag';
    }
    else if (event.target.id == 'tagNo') {
      this._batchType = 'All';
    }
    this.CalcAtServer();
  }

  CloseModalConfirmTag(): void {
    var modal:any = document.getElementById('myModalConfirmTag');
    modal.style.display = "none";
  }

  CalcAtServer(): void {
    this._isCalcListFetching = true;
    try {
      this.notelist[0].BatchType = this._batchType;
      this.notelist[0].PortfolioMasterGuid = this._calculationManager.PortfolioMasterGuid;

      this.finalCall = 1;
      this.calculationsvc.sendnoteforcalculation(this.notelist).subscribe(res => {
        if (res.Succeeded) {
          this.GetCalcStatus();
          this._signalRService.SendCalcNotification("CALCMGR" + '|*|' + Notificationsettings._notificationenvironment);
          this._ShowSuccessmessage = res.Message;
          this._ShowSuccessmessagediv = true;
          setTimeout(()=>{
            this._ShowSuccessmessagediv = false;
            this._isCalcListFetching = false;
          }, 5000);
        }
        else {
          this._Showmessagediv = true;
          this.Message = res.Message;
          setTimeout(() => {
            this._Showmessagediv = false;
            this._isCalcListFetching = false;
          }, 5000);
        }
      });
    } catch (err) {
      //alert(err);
    }

  }

  CustomAlert(dialog:any): void {
    var winW = window.innerWidth;
    var winH = window.innerHeight;
    var dialogoverlay:any = document.getElementById('dialogoverlay');
    var dialogbox: any = document.getElementById('dialogbox');
    var dialogboxhead: any = document.getElementById('dialogboxhead');
    var dialogboxbody: any = document.getElementById('dialogboxbody');
    dialogoverlay.style.display = "block";
    dialogoverlay.style.height = winH + "px";
    dialogbox.style.left = (winW / 2) - (550 * .5) + "px";
    dialogbox.style.top = "100px";
    dialogbox.style.display = "block";
    dialogboxhead.innerHTML = "CRES - web";
    dialogboxbody.innerHTML = dialog;
  }

  ok(): void {
    var dialogoverlay: any = document.getElementById('dialogoverlay');
    var dialogbox: any = document.getElementById('dialogbox');
    dialogbox.style.display = "none";
    dialogoverlay.style.display = "none";
  }

  public converteddatetime: any;
  private ConvertToBindableDate(Data:any, modulename:any, locale: string) {
    var options = { year: "numeric", month: "numeric", day: "numeric" };

    for (var i = 0; i < Data.length; i++) {
      if (this.lstcalculationlist[i].RequestTime != null) {
        this.lstcalculationlist[i].RequestTime = new Date(this.lstcalculationlist[i].RequestTime.toString());
      }

      if (this.lstcalculationlist[i].StartTime != null) {
        //var d = new Date(this.lstcalculationlist[i].StartTime.toString());
        //this.ConvertToTimeZone(d);
        //this.lstcalculationlist[i].StartTime = this.converteddatetime;
        var startTime:any = this.lstcalculationlist[i].StartTime;
        this.lstcalculationlist[i].StartTime = new Date(startTime.toString());
      }

      if (this.lstcalculationlist[i].EndTime != null) {
        //var d = new Date(this.lstcalculationlist[i].EndTime.toString());
        //this.ConvertToTimeZone(d);
        //this.lstcalculationlist[i].EndTime = this.converteddatetime;
        var endTime: any = this.lstcalculationlist[i].EndTime;
        this.lstcalculationlist[i].EndTime = new Date(endTime.toString());
      }

      //if (this.lstcalculationlist[i].StartTime != null) {
      //    this.lstcalculationlist[i].StartTime = new Date(this.lstcalculationlist[i].StartTime.toString());
      //}

      //if (this.lstcalculationlist[i].EndTime != null) {
      //    this.lstcalculationlist[i].EndTime = new Date(this.lstcalculationlist[i].EndTime.toString());
      //}
    }
  }


  ConvertToTimeZone(Data:any) {
    var d: any = Data;
    var amOrPm = (d.getHours() < 12) ? "AM" : "PM";
    var hour = (d.getHours() < 12) ? d.getHours() : d.getHours() - 12;
    var hr = (hour < 10) ? '0' + hour : hour;
    var minutes = (d.getMinutes() < 10) ? '0' + d.getMinutes() : d.getMinutes();
    var month = (d.getMonth() + 1 < 10) ? '0' + d.getMonth() + 1 : d.getMonth() + 1;
    var date = (d.getDate() < 10) ? '0' + d.getDate() : d.getDate();
    return this.converteddatetime = month + '-' + date + '-' + d.getFullYear() + ' ' + hr + ':' + minutes + ' ' + amOrPm;
  }


  SelectAll(s:any): void {
    this._chkSelectAll = !this._chkSelectAll;
    //  var colindex = this.flex.getColumn('Active').index;
    for (var i = 0; i < s.rows.length; i++) {
      if (s.rows[i]._data.EnableM61CalculationsText == 'Y') {
        s.rows[i]._data.Active = this._chkSelectAll;
      }
    }
    this.flex.invalidate();
  }


  SelectAllDownload(s:any): void {
    this._chkSelectdownloadAll = !this._chkSelectdownloadAll;
    // var colindex = this.flex.getColumn('downloadnote').index;
    for (var i = 0; i < s.rows.length; i++) {
      s.rows[i]._data.downloadnote = this._chkSelectdownloadAll;
    }
    this.flex.invalidate();
  }

  GetCalcStatus(): void {
    // var num: number = 1;
    if (this.finalCall == 1) {
      this.calculationsvc.calcstatus().subscribe(res => {
        if (res.Succeeded) {
          this.refreshcount = res.TotalCount;
          if (this.refreshcount > 0) {
            this.RefreshCalcStatus();

            setTimeout(() => {
              this.GetCalcStatus();
            }, 30000);
            // alert('setTimeout');
          }
          else if (this.refreshcount == 0 && this.finalCall == 1)//For call once again after complete all process.
          {
            //alert("this.subscription.unsubscribe()");
            this.finalCall = 0;
            this.RefreshCalcStatus();
            //this.subscription.unsubscribe();
            //this.subscriptionLoad.unsubscribe();

            //alert("this.subscription.unsubscribe() - DONE");
          }
        }
      });
    }
  }

  public sleep(delay:any) {
    var start = new Date().getTime();
    while (new Date().getTime() < start + delay);
  }

  public RefreshCalcStatus(): void {
    this.calculationsvc.refreshCalculation(this._calculationManager).subscribe(res => {
      if (res.Succeeded) {
        this._isCalcListFetching = false;
        var data = res.lstCalculationManger;
        this.totalcount = res.lstCalculationManger.length;
        if (this.totalcount > 0) {
          //  this.lstcalculationlist = data;
          //  if (data.length != this.flex.rows.length) {
          for (var i = 0; i < data.length; i++) {
            for (var j = 0; j < this.flex.rows.length; j++) {
              try {
                if (this.flex.rows[j].dataItem.NoteId == data[i].NoteId) {
                  this.flex.rows[j].dataItem.NoteId = data[i].NoteId;
                  this.flex.rows[j].dataItem.CRENoteID = data[i].CRENoteID;
                  this.flex.rows[j].dataItem.NoteName = data[i].NoteName;
                  this.flex.rows[j].dataItem.StatusID = data[i].StatusID;
                  this.flex.rows[j].dataItem.StatusText = data[i].StatusText;
                  this.flex.rows[j].dataItem.UserName = data[i].ApplicationID;
                  this.flex.rows[j].dataItem.StartTime = data[i].StartTime;
                  this.lstcalculationlist[i].EndTime = data[i].EndTime;
                  this.flex.rows[j].dataItem.ErrorMessage = data[i].ErrorMessage;
                  this.flex.rows[j].dataItem.FileName = data[i].FileName;
                  this.flex.rows[j].dataItem.EnableM61Calculations = data[i].EnableM61Calculations;
                  this.flex.rows[j].dataItem.EnableM61CalculationsText = data[i].EnableM61CalculationsText;


                }
              }
              catch (err) {
                console.log(err);
              }
            }
          }

          //else {

          //    this.lstcalculationlist = data;
          //}
          this.ConvertTimeaccordingtoUser(this.lstcalculationlist);
          //   this.ConvertToBindableDate(this.lstcalculationlist, "", "en-US");
          if (this.flex) {
            this.flex.columnHeaders.rows[0].height = 25;
            this.flex.invalidate();
          }

        }
      }
    });
  }



  public GetAllExceptions(): void {
    this._isExceptionListFetching = true;
    // this._ExceptionListCount = 0;

    this.calculationsvc.GetallExceptions("note", this._pageIndex, this._pageSize).subscribe(res => {
      if (res.Succeeded) {
        var data = res.Allexceptionslist;
        this._ExceptionListCount = res.TotalCount;

        if (this._pageIndex == 1) {
          this.flexnoteexceptions.autoSizeColumns();
          //remove first cell selection
          //this.flexnoteexceptions.selectionMode = wjcGrid.SelectionMode.None;

          if (res.CountException == 0) {
            this._ExceptionListCount = 0;
            // this._dvEmptyNoteSearchMsg = true;
            //setTimeout(() => {
            //    this._dvEmptyNoteSearchMsg = false;
            //}, 2000);
          }
          else {
            this.lstnotesexceptions = data;
            setTimeout(() => {
              this.flexnoteexceptions.invalidate(true);

              this.flexnoteexceptions.autoSizeColumns();
            }, 200);
          }
        }
        else {
          //data.forEach((obj, i) => { // FETCH ALL DATA AND PUSH IN FLEX GRID!!!
          //    this.flexnoteexceptions.rows.push(new wjcGrid.Row(obj));
          //});
          this.lstnotesexceptions.concat(data);
        }
      }
      this._isExceptionListFetching = false;
    });
  }

  GetTestcases(isrun: boolean) {
    this._testCase = new TestCase();
    if (!this._istestdataexist || isrun == true) {
      this.istestcasefetching = true;
      this._testCase.isRun = isrun;
      this._testCase.ModuleName = "Note";
      this.calculationsvc.getTestCases(this._testCase, this._pageIndex, this._pageSize).subscribe(res => {
        if (res.Succeeded) {
          var data = res.dtTestCase;
          this.totalTestCasecount = res.TotalCount;
          if (data) {
            if (this.flextestcase.columns.length < 2) {
              Object.keys(data[0]).forEach((x, y) => {
                if (x.toString() != "NoteID" && x.toString() != "CRENoteID")
                  this.flextestcase.columns.push(new wjcGrid.Column({ header: x, binding: x, align: 'center' }));
              })
            }

            this._istestdataexist = true;
            this._testcasecount = res.TotalCount;
            this._lastExecutedTime = res.Trace;
            if (this._pageIndex == 1) {
              if (isrun) {
                this._ShowSuccessmessageTestcasediv = true;
                this._ShowSuccessmessageTestcase = 'Test Cases excuted successfully.';
              }

              if (this._testcasecount != 0) {
                this._testCaseData = data;
                setTimeout(() => {
                  if (this.flextestcase) {
                    this._ShowSuccessmessageTestcasediv = false;
                    this.flextestcase.invalidate(true);
                    this.flextestcase.autoSizeColumns();
                  }
                }, 2000);
              }
            }
            else {
              this._testCaseData = this._testCaseData.concat(data);
            }
          }

          this.istestcasefetching = false;
        }
        else {
          this.istestcasefetching = false;

          if (this.totalTestCasecount == 0) {
            this._norecordtestcase = true;
          }
        }
      });
    }
  }

  invlaidatecalculationManagergrid() {
    if (this.flex) {
      setTimeout(() => {
        this.flex.invalidate();
      }, 1000);
    }
  }

  public ChangeCalcStatus(noteobj:any): void {
    for (var i = 0; i < noteobj.length; i++) {
      if (this.lstcalculationlist[i].Active == true) {
        this.lstcalculationlist[i].StatusText = "Processing";
        this.lstcalculationlist[i].StartTime = null;
        this.lstcalculationlist[i].EndTime = null;
        this.lstcalculationlist[i].ErrorMessage = null;
      }
    }
  }


  downloadNoteCashflowsExportData(): void {
    //var _note: Note;
    this._isCalcListFetching = true;
    var transactioncategoryname = '';
    this._note = new Note('');
    var downloadCashFlow = new DownloadCashFlow();
    if (this.multiseltransactioncategory != undefined) {
      this.transacatename = this.multiseltransactioncategory.checkedItems.map(({ TransactionCategory }) => TransactionCategory);
      transactioncategoryname = this.multiseltransactioncategory.checkedItems.map(({ TransactionCategory }) => TransactionCategory).join('|')
      transactioncategoryname = transactioncategoryname.length ? transactioncategoryname : 'Default';
    }

    downloadCashFlow.NoteId = "00000000-0000-0000-0000-000000000000";
    downloadCashFlow.DealID = "00000000-0000-0000-0000-000000000000";
    downloadCashFlow.AnalysisID = this.ScenarioId;
    downloadCashFlow.PortfolioMasterGuid = this._calculationManager.PortfolioMasterGuid;
    downloadCashFlow.CountOnDropDownFilter = this._lstcalculationlistCountOnDropDownFilter;
    downloadCashFlow.TransactionCategoryName = transactioncategoryname;
    downloadCashFlow.Pagename = 'Calc';
    //downloadCashFlow.PortfolioId = this.PortfolioMasterGuid;
    var flexcalc = this.flex.itemsSource;
    var downloadnotescnt = flexcalc.filter((x:any) => x.downloadnote == true).length;
    if (downloadnotescnt > 0) {
      var noteilds = '';
      //we select only Grid visible rows
      for (var i = 0; i < this.flex.rows.length; i++) {
        if (this.flex.rows[i].dataItem.downloadnote == true) {
          noteilds += this.flex.rows[i].dataItem["CRENoteID"] + ",";
        }
      }
      this._lstcalculationlistCountOnGridFilter = this.flex.rows.length;
      downloadCashFlow.CountOnGridFilter = this._lstcalculationlistCountOnGridFilter;

      downloadCashFlow.MutipleNoteId = noteilds;
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
      } else {
        if (filterednames.indexOf("_Default") >= 0) {
          filterednames = filterednames.replace("_Default", "");
        }
      }
      var fileName = "CalcMgr" + "_" + this.ScenarioName + filterednames + "_Cashflow_" + displayDate + "_" + displayTime + ".xlsx";

      this.notesvc.getNoteCashflowsExportData(downloadCashFlow).subscribe(res => {
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
      });


    }
    else {
      this.CustomAlert('Please select note(s) for download.');
      this._isCalcListFetching = false;
    }
  }

  fetchXML(stores:any) {
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
  }

  downloadFileCalcOutput(CalcDebugFileName: any, dtNotePeriodicOutputsDataContract: any, dtDatesTab: any, dtRateTab: any, dtBalanceTab: any, dtFeesTab: any, dtFeeOutputDataContract: any, dtCouponTab: any, dtPIKInterestTab: any, dtGAAPBasisTab: any, dtFinancingTab: any) {
    var user: any = localStorage.getItem('user');
    this._user = JSON.parse(user);

    var data_dtNotePeriodicOutputsDataContract = 'Output_Periodic' + '\r\n\n' + this.ConvertToCSV(dtNotePeriodicOutputsDataContract) + '\r\n\n';
    var data_dtDatesTab = 'Dates' + '\r\n\n' + this.ConvertToCSV(dtDatesTab) + '\r\n\n';
    var data_dtRateTab = 'Rates' + '\r\n\n' + this.ConvertToCSV(dtRateTab) + '\r\n\n';
    var data_dtBalanceTab = 'Balance' + '\r\n\n' + this.ConvertToCSV(dtBalanceTab) + '\r\n\n';
    var data_dtFeesTab = 'Fees' + '\r\n\n' + this.ConvertToCSV(dtFeesTab) + '\r\n\n';
    var data_dtFeeOutputDataContract = 'FeeOutput' + '\r\n\n' + this.ConvertToCSV(dtFeeOutputDataContract) + '\r\n\n';
    var data_dtCouponTab = 'Coupon' + '\r\n\n' + this.ConvertToCSV(dtCouponTab) + '\r\n\n';
    var data_dtPIKInterestTab = 'PIK_Interest' + '\r\n\n' + this.ConvertToCSV(dtPIKInterestTab) + '\r\n\n';
    var data_dtGAAPBasisTab = 'GAAP_Basis' + '\r\n\n' + this.ConvertToCSV(dtGAAPBasisTab) + '\r\n\n';
    var data_dtFinancingTab = 'Financing' + '\r\n\n' + this.ConvertToCSV(dtFinancingTab);

    var data = data_dtNotePeriodicOutputsDataContract + data_dtDatesTab + data_dtRateTab + data_dtBalanceTab + data_dtFeesTab + data_dtFeeOutputDataContract + data_dtCouponTab + data_dtPIKInterestTab + data_dtGAAPBasisTab + data_dtFinancingTab;

    var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '-');
    var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '-');
    //var fileName = "Cashflow_" + window.localStorage.getItem("ScenarioName") + "_" + displayDate + "_" + displayTime + "_" + this._user.Login + ".csv";
    var fileName = CalcDebugFileName + ".csv"; //"CalcMgr_" + this.ScenarioName + "_Cashflow_" + displayDate + "_" + displayTime + ".csv";

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

  downloadFile(objArray: any) {
    var user: any = localStorage.getItem('user');
    this._user = JSON.parse(user);
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
    } else {
      if (filterednames.indexOf("_Default") >= 0) {
        filterednames = filterednames.replace("_Default", "");
      }
    }
    var fileName = "CalcMgr" + "_" + this.ScenarioName + filterednames + "_Cashflow_" + displayDate + "_" + displayTime + ".csv";
    //========================


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

  // convert Json to CSV data in Angular2
  ConvertToCSV(objArray:any) {
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

  subscribetoevent(): void {
    this._signalRService.updateCalcNotification.subscribe((message: any) => {
      var res = message.split('|*|');
      if (res[0] == "CALCMGR" && res[1] == Notificationsettings._notificationenvironment) {
        //let timer = TimerObservable.create(6000, 6000);
        //this.subscription = timer.subscribe(t => { this.GetCalcStatus(); });

        this.finalCall = 1;
        this.GetCalcStatus();
      }
    })
  }

  GetUserPermission(): void {
    try {
      this.permissionService.GetUserPermissionByPagename("CalculationManager").subscribe(res => {
        if (res.Succeeded) {
          if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
            var _object = res.UserPermissionList;
            var controlarrayedit = _object.filter((item:any)=> { return item.ModuleType === 'Control' && item.RightsName === 'Edit'; });

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

  GetAllLookups(): void {
    this.notesvc.getAllLookupById().subscribe(res => {
      var data = res.lstLookups;

      this.lstCalculationMode = data.filter((x:any) => x.ParentID == "79");
    });
  }

  getAllDistinctScenario(): void {
    var user:any = localStorage.getItem('user');
    var _userData = JSON.parse(user);
    this._scenariodc.UserID = _userData.UserID;
    this.scenarioService.getAllScenarioDistinct(this._scenariodc).subscribe(res => {
      if (res.Succeeded) {
        if (res.lstScenarioUserMap.length > 0) {
          this._lstScenario = res.lstScenarioUserMap;
          this.ScenarioId = res.lstScenarioUserMap.filter((x:any) => x.ScenarioName == "Default")[0].AnalysisID;
          this.ScenarioName = res.lstScenarioUserMap.filter((x:any) => x.ScenarioName == "Default")[0].ScenarioName;
          this._scenariodc.AnalysisID = this.ScenarioId;
          this._calculationManager.AnalysisID = this.ScenarioId;
          this.isAllowDebugInCalc = this._lstScenario[0].AllowDebugInCalc;
          this.flex.invalidate();
        }
      }
    });
  }

  changeScenario(value:any): void {
    this._lstcalculationlistCount = 1;
    this.ScenarioId = value.target.value;
    this._scenariodc.AnalysisID = this.ScenarioId;
    this._calculationManager.AnalysisID = this.ScenarioId;
    this.ScenarioName = this._lstScenario.filter((x:any) => x.AnalysisID == value)[0].ScenarioName;
    this.RefreshCalculationStatus();
  }

  ddlScenarioChange(obj:any): void {
    this.ScenarioId = obj;
    //this._calculationManager.AnalysisID = this.ScenarioId;
  }

  ddlCalculationMode(obj:any): void {
    this.CalculationModeID = obj;
  }

  public GetBatchLog(): void {
    this._isExceptionListFetching = true;
    // this._ExceptionListCount = 0;

    this.calculationsvc.getbatchlog(this._batchcalc).subscribe(res => {
      if (res.Succeeded) {
        setTimeout(() => {
          this.flexbatch.invalidate(true);
        }, 200);
        if (res.lstBatchCalculationMaster.length > 0) {
          this.lstbatchlog = res.lstBatchCalculationMaster;
          this.ConvertToBindableBatchLog(this.lstbatchlog, "", "en-US");
          this._lstlstbatchlogCount = res.lstBatchCalculationMaster.length;
        }
        else
          this._lstlstbatchlogCount = 0;
      }
      this._isExceptionListFetching = false;
    });
  }

  private ConvertToBindableBatchLog(Data:any, modulename:any, locale: string) {
    var options = { year: "numeric", month: "numeric", day: "numeric" };
    for (var i = 0; i < Data.length; i++) {
      if (this.lstbatchlog[i].StartTime != null) { this.lstbatchlog[i].StartTime = new Date(this.lstbatchlog[i].StartTime.toString()); }
      if (this.lstbatchlog[i].EndTime != null) {
        this.lstbatchlog[i].EndTime = new Date(this.lstbatchlog[i].EndTime.toString());
      }
    }
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

  calcObjForDownload: CalculationManagerList = new CalculationManagerList("");
  DownloadCalcOutputExcel(FileName:any): void {
    this._isCalcListFetching = true;
    this.calcObjForDownload.FileName = FileName

    this.calculationsvc.downloadfilecalcoutput(this.calcObjForDownload).subscribe(res => {
      if (res.Succeeded) {
        this._ShowSuccessmessagediv = true;
        this._ShowSuccessmessage = "Downloading the output excel.";
        setTimeout(() => {
          this._ShowSuccessmessagediv = false;
          this._isCalcListFetching = false;
        }, 5000);

        this.exportToExcel(res.CalcDebugFileName, [res.dtNotePeriodicOutputsDataContract, res.dtDatesTab, res.dtRateTab, res.dtFeesTab, res.dtFeeOutputDataContract, res.dtBalanceTab, res.dtCouponTab, res.dtPIKInterestTab, res.dtGAAPBasisTab, res.dtFutureFundingScheduleTab, res.dtMaturityList], ['Output_Periodic', 'Dates', 'Rates', 'Fees', 'FeeOutput', 'BalanceTab', 'Coupon', 'PIK_Interest', 'GAAP_Basis', 'Future_Funding_Schedule', 'Maturity_Dates']);
        //this.downloadFileCalcOutput(res.CalcDebugFileName, res.dtNotePeriodicOutputsDataContract, res.dtDatesTab, res.dtRateTab, res.dtBalanceTab, res.dtFeesTab, res.dtFeeOutputDataContract, res.dtCouponTab, res.dtPIKInterestTab, res.dtGAAPBasisTab, res.dtFinancingTab);

        this._isCalcListFetching = false;
      }
      else {
        this._Showmessagediv = true;
        this.Message = "Some error occurred while downloading.";
        setTimeout(() => {
          this._Showmessagediv = false;
          this._isCalcListFetching = false;
        }, 5000);
      }
      (error:string) => console.error('Error: ' + error)
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
  }

  exportToExcel(filename:any, arr:any, sheets:any) {
    const fileName = filename + '.xlsx';
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
  }

  GettimezoneCurrentOffset() {
    this.calculationsvc.GettimezoneCurrentOffset().subscribe(res => {
      if (res.Succeeded) {
        this.currentoffset = res.currentoffset;
      }
    });
  }

  ConvertTimeaccordingtoUser(data:any) {
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
          dt = d.getDate() - 1;
        }
        else {
          hour = hour;
          dt = d.getDate();
        }
        if (seconds > 60) {
          seconds = seconds - 60;
          minutes = minutes + seconds;
        }
        if (minutes > 60) {
          minutes = minutes - 60;
          hour = hour + 1;
        }
        var dat = (dt < 10) ? '0' + dt : dt;
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
          dt = d.getDate() - 1
        }
        else {
          hour = hour;
          dt = d.getDate();
        }
        if (seconds > 60) {
          seconds = seconds - 60;
          minutes = minutes + seconds;
        }
        if (minutes > 60) {
          minutes = minutes - 60;
          hour = hour + 1;
        }
        var dat = (dt < 10) ? '0' + dt : dt;
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
  GetTransactionCategory() {
    this.calculationsvc.GetTransactionCategory().subscribe(res => {
      if (res.Succeeded) {
        var data = res.dt;
        this.listtransactioncategory = data;
        //this.listtransactioncategory.forEach((objparent, i) => { // FETCH ALL DATA AND PUSH IN FLEX GRID!!!
        //    data.TransactionCategory.split(/\s*,\s*/).forEach((obj, j) => {
        //        if (objparent.TransactionCategory == obj) {
        //            this.listtransactioncategory[i].selected = true;
        //        }
        //    });

      }
    });
  }

}

const routes: Routes = [
  { path: '', component: CalculationManagerComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjGridModule, WjGridFilterModule, WjInputModule, WjCoreModule],
  declarations: [CalculationManagerComponent]
})

export class calculationManagerModule { }
