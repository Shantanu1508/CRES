import { Component, OnInit, Inject, Compiler, ViewChild } from '@angular/core';
import { Router, ActivatedRoute, Params, Route } from '@angular/router';
import { Scenario, Scenariosearch } from "../core/domain/scenario.model";
import { IndexType } from "../core/domain/indexType.model";
import * as wjNg2Grid from '@grapecity/wijmo.angular2.grid';
import { OperationResult } from '../core/domain/operationResult.model';
import { scenarioService } from '../core/services/scenario.service';
import { NotificationService } from '../core/services/notification.service'

import { isLoggedIn } from '../core/services/isLoggedIn.service';
import { UtilityService } from '../core/services/utility.service';
import { Paginated } from '../core/common/paginated.service';

import * as wjcCore from '@grapecity/wijmo';
import * as wjcGrid from '@grapecity/wijmo.grid';

import { ModuleWithProviders, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
//import { Headers, RequestOptions, BaseRequestOptions } from '@angular/http';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import { functionService } from '../core/services/function.service';
import { DataService } from '../core/services/data.service';

@Component({
  selector: "scenariodetail",
  templateUrl: "./scenarioDetail.html",
  providers: [scenarioService, NotificationService, UtilityService, functionService],
})

export class ScenarioDetailComponent extends Paginated {
  cvScenarioDetaildata: wjcCore.CollectionView;
  public _scenariodc: Scenario;
  public _indextype: IndexType;
  public analysisid: any;
  public _ShowmessagedivMsgWar: any;
  public indexupdatedRowNo: any = [];
  public indexrowsToUpdate: any = [];
  public _ShowmessagedivWar: boolean = false;
  public TotalCount: number = 0;
  public scenarioDetaildata: any;
  public scenarioindexdata: Array<any>;
  public subCategories: any = [];
  public Message: any = '';
  public _Showmessagediv: boolean = false;
  public _isScenarioDetailFetching: boolean = true;
  public _isShowScenarioRuleType: boolean = false;
  public _isScrolled: boolean = true;
  public _FirstDate: Date;
  public _lastDate: Date;

  public _listlength: any;
  lstMaturityScenarioOverride: any;
  lstRuleTypebyruleid: any;
  public _scenariosearch = new Scenariosearch();
  public _isIndexLoad: boolean = true;
  public _isShowLoader: boolean = false;
  lstIndexesMaster: any;
  lstCalculationMode: any;
  lstExcludedForcastedPrePayment: any;
  lstAutoCalcFreq: any;
  lstUseActuals: any;

  columns: {
    binding?: string, header?: string, width?: any, format?: string
  }[];
  public lstFolders: any;
  public foldername: string;
  public autoVerfoldername: string;
  public lstBusinessDayAdjustment: any = [];
  public lstTemplatename: any = [];
  

  public _lstruletype: any = [];
  public _lstruletypedetail: any = [];
  public _lstRuleTypeSetupNew: any = [];
  public _isReadOnlyRuleTypeName: boolean = true;
   public _lstsunruletype: any = [];

    public cityMap: any = [];
    public listruletype: any = [];
  

    public _isShowSaveScenario: boolean = true;
    @ViewChild('RuleTypeList') RuleTypeList: wjcGrid.FlexGrid;
    @ViewChild('flexScenarioDetail') flexScenarioDetail: wjcGrid.FlexGrid;s

  constructor(private activatedRoute: ActivatedRoute,
    private _router: Router,
    public scenarioService: scenarioService,
    public utilityService: UtilityService,  
    public notificationService: NotificationService,
    public dataService: DataService,
    public functionServiceSrv: functionService) {
    super(30, 0, 0);
    this.activatedRoute.params.forEach((params: Params) => {
      if (params['id'] !== undefined) {
        var scenarioaId = params['id'];
        this._scenariodc = new Scenario(scenarioaId);
        this.analysisid = scenarioaId;
        this.GetScenarioByID(scenarioaId);
      }
    });
    this.getFastFolderList();
    this.utilityService.setPageTitle("M61 – Scenario Details");
  }





  GetScenarioByID(_scenarioaId): void {
    try {
      this.scenarioService.GetScenarioByScenarioID(_scenarioaId).subscribe(res => {
        if (res.Succeeded) {
          if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
            this._scenariodc = res.ScenarioParameters;
            var _isV1UIEnable = this.dataService._isV1UIEnable;
            if (_isV1UIEnable == "true") {
              this._isShowScenarioRuleType = true;
            }
            else {
              this._isShowScenarioRuleType = false;
            }
            //this.GetIndexByScenarioID(_scenarioaId);
            this.GetAllLookups();
            this.GetAllIndexes();

            this._isScenarioDetailFetching = false;
          } else {
            localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
            localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));
            this.utilityService.navigateUnauthorize();
          }
        }
        else {
          this._router.navigate(['login']);
        }
      });
    } catch (err) {
    }
  }
  GetAllLookups(): void {
    try {
      this.getAllRuleType();
      this.GetAllRuleTypeDetail();
      setTimeout(function () {
        this.GetRuleTypeSetupByObjectId();
      }.bind(this), 1000);
      this.scenarioService.getAllLookup().subscribe(res => {
        if (res.Succeeded) {
          var data = res.lstLookups;
          this.lstMaturityScenarioOverride = data.filter(x => x.ParentID == "52");
          this.lstCalculationMode = data.filter(x => x.ParentID == "79");
          this.lstExcludedForcastedPrePayment = data.filter(x => x.ParentID == "2");
          this.lstAutoCalcFreq = data.filter(x => x.ParentID == "98");
          this.lstUseActuals = data.filter(x => x.ParentID == "2");
          this.lstBusinessDayAdjustment = data.filter(x => x.ParentID == "2");
        }
        else {
          this._router.navigate(['login']);
        }
      });
    } catch (err) {
    }
  }

    

    sortByName(a, b) {
        var textA = a.FileName.toUpperCase();
        var textB = b.FileName.toUpperCase();
        return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
    }

    cellRuleTypeEditHandler = function (s, e) {
        var col = s.columns[e.col];
        if (col.binding == 'FileName') {
            var RuleTypeName = s.rows[e.row].dataItem.RuleTypeName
            switch (RuleTypeName) {
                case RuleTypeName:
                    this.lstRuleTypebyruleid = this._lstruletypedetail.filter(x => x.RuleTypeName == RuleTypeName)
                    this.lstRuleTypebyruleid.sort(this.sortByName);
                    col.dataMap = this._buildDataMapWithoutLookupNew(this.lstRuleTypebyruleid);
                    break;
                default:
                    col.dataMap = this._buildDataMapWithoutLookupNew(this._lstruletypedetail);
                    break;
            }
        }
    }

  
  GetAllIndexes(): void {
    try {
      this.scenarioService.getIndexesFromIndexesMaster().subscribe(res => {
        if (res.Succeeded) {
          this.lstIndexesMaster = res.lstIndexesMaster;
        }
        else {
          this._router.navigate(['login']);
        }
      });
    } catch (err) {
    }
  }


  DiscardChanges(): void {
    this._router.navigate(['scenarios']);
  }


  ValidateScenarioAndSave(Actionstatus): void {
    try {
            this._isShowLoader = true;
            this._isShowSaveScenario = false;
      var RuleTypelength = 0;
      var ruletypeerror = '';

      var dtRuleType = [];
      if (this._isShowScenarioRuleType == true) {
        if (this.RuleTypeList.allowAddNew == false) {
          RuleTypelength = this.RuleTypeList.rows.length;
        } else {
          RuleTypelength = this.RuleTypeList.rows.length - 1;
        }
        for (var h = 0; h < RuleTypelength; h++) {
          if (Object.keys(this.RuleTypeList.rows[h]).length > 0) {
            dtRuleType.push({
              'RuleTypeDetail': this.RuleTypeList.rows[h].dataItem.FileName
            });

          }
        }
        for (var l = 0; l < dtRuleType.length; l++) {
          if (dtRuleType[l].RuleTypeDetail == null || dtRuleType[l].RuleTypeDetail == "" || dtRuleType[l].RuleTypeDetail == undefined) {
            ruletypeerror = "Please select the template(s).";
          }
        }
      }
      if (ruletypeerror != "") {
        this._isShowLoader = false;
        this._isShowSaveScenario = true;
        this.CustomAlert(ruletypeerror);
      }
      else {
        this._scenariodc.AnalysisID = this.analysisid;
        if (this._scenariodc.ScenarioName != "" && this._scenariodc.ScenarioName != null) {
          this.scenarioService.CheckDuplicateScenario(this._scenariodc).subscribe(res => {
            if (res.Succeeded) {
              if (res.Message != "Duplicate") {
                this.InsertUpdateScenario();
               // this.AddUpdateAnalusisRuleTypeSetup();
              }
              else {
                this._ShowmessagedivWar = true;
                this._ShowmessagedivMsgWar = "Scenario with same name already exits, please use different scenario name."
                this._isScenarioDetailFetching = false;
                this._isShowLoader = false;
                this._isShowSaveScenario = true;
                setTimeout(() => {
                  this._ShowmessagedivWar = false;
                  this._ShowmessagedivMsgWar = "";
                }, 3000);
              }
            }
            else {
              this._router.navigate(['login']);
            }
          });



        } else {

          this._ShowmessagedivWar = true;
          this._ShowmessagedivMsgWar = "Please fill Scenario name."
          this._isShowSaveScenario = true;
          this._isScenarioDetailFetching = false;
          this._isShowLoader = false;
          setTimeout(() => {
            this._ShowmessagedivWar = false;
            this._ShowmessagedivMsgWar = "";
          }, 3000);
        }
      }

    } catch (err) {
    }
  }

  InsertUpdateScenario(): void {
    try {
      this.scenarioService.InsertUpdateScenario(this._scenariodc).subscribe(res => {
        if (res.Succeeded) {
          this.analysisid = res.newscenarioid;
          this._scenariodc.AnalysisID = this.analysisid;
          if (this._isShowScenarioRuleType == true) {
            this.AddUpdateAnalusisRuleTypeSetup();
          }
          localStorage.setItem('divSucessScenario', JSON.stringify(true));
          localStorage.setItem('successmsgscenario', JSON.stringify(res.ScenarioMsg));

          this._router.navigate(['scenarios']);
          //this.UpdateIndex(this.analysisid);
          this._isShowLoader = false;
          this._isShowSaveScenario = true;
        }
        else {
          this._router.navigate(['login']);
        }
      });
    } catch (err) {
    }
  }

  adjustdescrtiptionheight(): void {
    var cont = $("#Description");
    cont[0].style.height = "1px";
    cont[0].style.height = (cont[0].scrollHeight + 20) + "px";
  }
  public prevDateBeforeEdit: Date;
  // index grid saving code

  ScenarioDetailselectionChanged(): void {
    //var flexIndex = this.flexScenarioDetail;
    //var rowIdx = this.flexScenarioDetail.collectionView.currentPosition;
    try {
      //var count = this.indexupdatedRowNo.indexOf(rowIdx);
      //if (count == -1)
      //    this.indexupdatedRowNo.push(rowIdx);
    }
    catch (err) {
      console.log(err);
    }
  }
  beginningEdit(modulename): void {
    switch (modulename) {
      case "ScenarioDetail":
        var sel = this.flexScenarioDetail.selection;
        if (this.scenarioDetaildata[sel.topRow].Date != null)
          this.prevDateBeforeEdit = this.scenarioDetaildata[sel.topRow].Date;
        break;
    }
  }

  getFastFolderList(): void {


    this.functionServiceSrv.getallFastFunction()
      .subscribe(res => {

        this.lstFolders = res;
        if (this.lstFolders != null && this.lstFolders.length > 0) {
          this.autoVerfoldername = this.lstFolders[0].FunctionName;
          this.lstFolders[0].FunctionName = "Auto-Version";
          this.foldername = "Auto-Version";
        }

      },
        error => {
          this.utilityService.navigateToSignIn();
        }

      );
  }
  ChangeFolder(newvalue): void {
    this.foldername = newvalue;
  }

  private _buildDataMapWithoutLookupNew(items): wjcGrid.DataMap {
    var map = [];

    for (var i = 0; i < items.length; i++) {
      var obj = items[i];
      map.push({ key: obj['FileName'], value: obj['FileName'] });
    }
    return new wjcGrid.DataMap(map, 'key', 'value');
  }

  getAllRuleType() {
    this.scenarioService.getallruletype().subscribe(res => {
      if (res.Succeeded) {
        this._lstruletype = res.lstScenariorule;
      }
    });
  }

  GetAllRuleTypeDetail() {
    this.scenarioService.getallruletypedetail().subscribe(res => {
      if (res.Succeeded) {
        this._lstruletypedetail = res.lstScenarioRuleDetail;
        var RuleType = this.RuleTypeList;
        if (RuleType) {
          var colRuleType = RuleType.columns.getColumn('FileName');
          if (colRuleType) {
           // colRuleType.showDropDown = true;
            colRuleType.dataMap = this._buildDataMapWithoutLookupNew(this._lstruletypedetail);
          }
        }

      }
    });
  }

  GetRuleTypeSetupByObjectId() {
    this.scenarioService.getruletypesetupbyobjectId(this._scenariodc.AnalysisID).subscribe(res => {
      if (res.Succeeded) {
        this._lstruletype = res.lstScenariorule;
      }
    });
  }

  

  AddUpdateAnalusisRuleTypeSetup() {
    var RuleTypelength = 0;

    if (this.RuleTypeList.allowAddNew == false) {
      RuleTypelength = this.RuleTypeList.rows.length;
    } else {
      RuleTypelength = this.RuleTypeList.rows.length - 1;
    }

    for (var h = 0; h < RuleTypelength; h++) {
      if (Object.keys(this.RuleTypeList.rows[h]).length > 0) {
        var RuleTypeDetailID = this._lstruletypedetail.find(x => x.FileName == this.RuleTypeList.rows[h].dataItem.FileName).RuleTypeDetailID
        this._lstRuleTypeSetupNew.push({
          'AnalysisID': this._scenariodc.AnalysisID,
          'RuleTypeMasterID': this._lstruletype[h].RuleTypeMasterID,
          'RuleTypeDetailID': RuleTypeDetailID,

        });

      }
    }
    this.scenarioService.addupdateanalysisruletypesetup(this._lstRuleTypeSetupNew).subscribe(res => {
      if (res.Succeeded) {
      }
    });
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
    document.getElementById('dialogboxhead').innerHTML = "CRES - Validation Error";
    document.getElementById('dialogboxbody').innerHTML = dialog;
  }

  ok(): void {
    document.getElementById('dialogbox').style.display = "none";
    document.getElementById('dialogoverlay').style.display = "none";
  }

  //ngAfterViewInit() {
  //    // commit row changes when scrolling the grid


  //    this.flexScenarioDetail.scrollPositionChanged.addHandler(() => {
  //        var myDiv = $('#flexScenarioDetail').find('div[wj-part="root"]');
  //        if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {

  //            if (this.flexScenarioDetail.rows.length < this.TotalCount) {
  //                this._isScenarioDetailFetching = true;
  //                this._scenariosearch.AnalysisID = this.analysisid;
  //                this._scenariosearch.Fromdate = this._lastDate;
  //                this._scenariosearch.Todate = null;
  //                this.GetIndexBetweenDates(this._scenariosearch, "after");
  //            }
  //        }
  //        else if (myDiv.scrollTop() == 0) {
  //            if (this.flexScenarioDetail.rows.length < this.TotalCount) {
  //                this._scenariosearch.AnalysisID = this.analysisid;
  //                this._isScenarioDetailFetching = true;
  //                this._scenariosearch.Fromdate = null;
  //                this._scenariosearch.Todate = this._FirstDate;
  //                this.GetIndexBetweenDates(this._scenariosearch, "before");
  //            }
  //        }
  //    });
  //}


  //GetIndexBetweenDates(scenariosearch: Scenariosearch, append: string) {
  //    this.scenarioService.GetIndexBetweenDates(scenariosearch).subscribe(res => {
  //        if (res.Succeeded) {
  //            var tempdata = this.scenarioDetaildata;
  //            this.scenarioindexdata = res.dtIndexType;
  //            this._listlength = this.scenarioindexdata.length;
  //            if (this.scenarioindexdata.length > 0) {
  //                for (var i = 0; i < this.scenarioindexdata.length; i++) {
  //                    if (this.scenarioindexdata[i].Date != null) {
  //                        if (this.scenarioindexdata[i].Date == "1900-01-01T00:00:00") {
  //                            this.scenarioindexdata[i].Date = "";
  //                        } else {
  //                            this.scenarioindexdata[i].Date = new Date(this.scenarioindexdata[i].Date.toString());
  //                        }
  //                    }
  //                }


  //                if (append == "before") {

  //                    // if (this._FirstDate > this.scenarioindexdata[0].Date) { this._FirstDate = this.scenarioindexdata[0].Date; }
  //                    this._FirstDate = this.scenarioindexdata[0].Date;
  //                    this.scenarioDetaildata = this.scenarioindexdata.concat(tempdata);

  //                    this.cvScenarioDetaildata = new wjcCore.CollectionView(this.scenarioDetaildata);
  //                    this.cvScenarioDetaildata.trackChanges = true;

  //                    this._isScenarioDetailFetching = false;
  //                    var myDiv = $('#flexScenarioDetail').find('div[wj-part="root"]');
  //                    myDiv.scrollTop(100);
  //                }
  //                else {

  //                    if (this._lastDate < this.scenarioindexdata[this._listlength - 1].Date) {
  //                        this._lastDate = this.scenarioindexdata[this._listlength - 1].Date;
  //                    }
  //                    if (this._lastDate != null) { this._lastDate = this.createDateAsUTC(this._lastDate); }
  //                    this.scenarioDetaildata = this.scenarioDetaildata.concat(this.scenarioindexdata);

  //                    this.cvScenarioDetaildata = new wjcCore.CollectionView(this.scenarioDetaildata);
  //                    this.cvScenarioDetaildata.trackChanges = true;

  //                    var myDiv = $('#flexScenarioDetail').find('div[wj-part="root"]');

  //                }
  //                var delrow = this.flexScenarioDetail.rows[30];
  //                this.flexScenarioDetail.rows.remove(delrow);


  //                // this.scenarioDetaildata = this.scenarioindexdata;
  //                //this.scenarioindexdata.forEach((obj, i) => {
  //                //    this.flexScenarioDetail.rows.push(new wjcGrid.Row(obj));

  //                //});
  //                this._isScenarioDetailFetching = false;
  //            }
  //            else {
  //                //this.scenarioDetaildata = [];
  //                //this.cvScenarioDetaildata = new wjcCore.CollectionView(this.scenarioDetaildata);
  //                //this.cvScenarioDetaildata.trackChanges = true;
  //                this._isScenarioDetailFetching = false;

  //            }
  //        }
  //    });
  //}


  //downloadIndexsExportData(): void {

  //    //var _note: Note;
  //    this._isScenarioDetailFetching = true;
  //    this._scenariosearch.AnalysisID = this.analysisid;
  //    this.scenarioService.GetIndexesExportData(this._scenariosearch).subscribe(res => {

  //        if (res.Succeeded) {
  //            setTimeout(function () {
  //                //== this.exportNoteCashflowsExcel();  
  //                this._isScenarioDetailFetching = false;

  //            }.bind(this), 100);

  //            this.downloadFile(res.dtIndexType);
  //        }
  //        else {
  //            // this._dvEmptynoteperiodiccalcMsg = true;
  //        }
  //        error => console.error('Error: ' + error)
  //    });
  //}


  //GetIndexByScenarioID(ScenarioID): void {

  //    this.scenarioService.GetIndexByScenarioID(ScenarioID, this._pageIndex, this._pageSize).subscribe(res => {
  //        if (res.Succeeded) {
  //            this.TotalCount = res.TotalCount
  //            if (this.TotalCount == 0) {
  //                this._isIndexLoad = false;
  //            }
  //            this._isScrolled = false;
  //            this.scenarioindexdata = res.dtIndexType
  //            this._isScrolled = true;

  //            var locale = "en-US"
  //            var options = { year: "numeric", month: "numeric", day: "numeric" };
  //            // for (var i = 0; i < this.TotalCount; i++) {
  //            for (var i = 0; i < this.scenarioindexdata.length; i++) {
  //                if (this.scenarioindexdata[i].Date != null) {
  //                    if (this.scenarioindexdata[i].Date == "1900-01-01T00:00:00") {
  //                        this.scenarioindexdata[i].Date = "";
  //                    } else {
  //                        this.scenarioindexdata[i].Date = new Date(this.scenarioindexdata[i].Date.toString());
  //                    }
  //                }


  //                if (i == this.scenarioindexdata.length - 1) {
  //                    setTimeout(function () {
  //                        this._isScenarioDetailFetching = false;
  //                    }.bind(this), 2000);
  //                }
  //            }
  //            this.scenarioDetaildata = this.scenarioindexdata;
  //            if (this.scenarioindexdata.length > 0) {

  //                this._FirstDate = this.scenarioindexdata[0].Date;
  //                this._lastDate = this.scenarioindexdata[(this.scenarioindexdata.length) - 1].Date;
  //                if (this._lastDate != null) { this._lastDate = this.createDateAsUTC(this._lastDate); }
  //                this.cvScenarioDetaildata = new wjcCore.CollectionView(this.scenarioDetaildata);
  //                this.cvScenarioDetaildata.trackChanges = true;
  //            }
  //            else {
  //                this.scenarioDetaildata = [];
  //                this.cvScenarioDetaildata = new wjcCore.CollectionView(this.scenarioDetaildata);
  //                this.cvScenarioDetaildata.trackChanges = true;
  //            }
  //            var myDiv = $('#flexScenarioDetail').find('div[wj-part="root"]');
  //            myDiv.scrollTop(200);

  //            if (this.scenarioindexdata.length == 0) {
  //                this._isScenarioDetailFetching = false;
  //            }

  //        }

  //    });
  //    error => console.error('Error: ' + error)
  //}

  //Addcolumn(header, binding) {
  //    try {
  //        this.columns.push({ "header": header, "binding": binding, "format": 'p5' })
  //    } catch (err) { }
  //}

  //rowEditEnded(modulename): void {
  //    switch (modulename) {
  //        case "ScenarioDetail":
  //            var sel = this.flexScenarioDetail.selection;
  //            var flag = this.CheckDuplicateDate(sel.topRow);
  //            //alert('end  - ' + this.prevDateBeforeEdit);
  //            if (flag == true) {
  //                var indformatDate: Date;

  //                var locale = "en-US"
  //                var options = { year: "numeric", month: "numeric", day: "numeric" };

  //                indformatDate = this.scenarioDetaildata[sel.topRow].Date;
  //                if (indformatDate.toString().indexOf("GMT") == -1)
  //                    alert("Date - " + indformatDate + " already in list");
  //                else
  //                    alert("Date " + indformatDate.toLocaleDateString(locale, options) + " already in list");
  //                this.scenarioDetaildata[sel.topRow].Date = this.prevDateBeforeEdit;

  //                this.scenarioDetaildata[sel.topRow].AnalysisID = this.analysisid;
  //            }
  //    }
  //    this.prevDateBeforeEdit = null;
  //}
  //CopiedDataValidate(modulename): void {
  //    try {
  //        switch (modulename) {
  //            case "ScenarioDetail":
  //                var sel = this.flexScenarioDetail.selection;
  //                var rssformatDate: Date;
  //                for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
  //                    var flag = this.CheckDuplicateDate(tprow); //this.CheckDuplicateDate(this.scenarioDetaildata, tprow);
  //                    if (flag == true) {
  //                        var locale = "en-US"
  //                        var options = { year: "numeric", month: "numeric", day: "numeric" };
  //                        rssformatDate = this.scenarioDetaildata[tprow].Date;
  //                        if (rssformatDate.toString().indexOf("GMT") == -1)
  //                            alert("Date - " + rssformatDate + " already in list");
  //                        else
  //                            alert("Date - " + rssformatDate.toLocaleDateString(locale, options) + " already in list");
  //                    }
  //                    break;
  //                }
  //        }
  //    }
  //    catch (err) {
  //        console.log(err);
  //    }
  //}

  //CheckDuplicateDate(rwNum): boolean {
  //    try {
  //        var i;
  //        for (i = 0; i < this.scenarioDetaildata.length; i++)
  //            if (rwNum != i && this.scenarioDetaildata[rwNum].Date.toString() == this.scenarioDetaildata[i].Date.toString())
  //                break;
  //        if (i == this.scenarioDetaildata.length)
  //            return false;
  //        else
  //            return true;
  //    }
  //    catch (err) {
  //        console.log(err);
  //    }
  //}

  //convertDatetoGMTGrid(Data) {
  //    if (Data) {
  //        for (var i = 0; i < Data.length; i++) {
  //            if (this._indextype[i].Date) {
  //                this._indextype[i].Date = this.createDateAsUTC(this._indextype[i].Date);
  //            }
  //        }
  //    }
  //}

  //createDateAsUTC(date: Date) {
  //    if (date) {
  //        date = new Date(date);
  //        return new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds()));
  //    } else
  //        return date;
  //}



  //UpdateIndex(newscenarioid): void {
  //    this._indextype = new IndexType();
  //    //if (this.indexupdatedRowNo != null) {
  //    //    for (var i = 0; i < this.indexupdatedRowNo.length; i++) {
  //    //        this.scenarioDetaildata[this.indexupdatedRowNo[i]].AnalysisID = newscenarioid;
  //    //        this.indexrowsToUpdate.push(this.scenarioDetaildata[this.indexupdatedRowNo[i]]);
  //    //    }
  //    //    this._indextype = this.indexrowsToUpdate;
  //    //}
  //    for (var j = 0; j < this.scenarioDetaildata.length; j++) {
  //        this.scenarioDetaildata[j].AnalysisID = newscenarioid;

  //        for (var i = 0; i < this.cvScenarioDetaildata.itemsAdded.length; i++) {
  //            this._indextype = new IndexType();
  //            this._indextype = this.cvScenarioDetaildata.itemsAdded[i];
  //            if (this.scenarioDetaildata[j].Date == this._indextype.Date) {
  //                this.indexrowsToUpdate.push(this.scenarioDetaildata[j])
  //            }
  //        }
  //        for (var i = 0; i < this.cvScenarioDetaildata.itemsEdited.length; i++) {
  //            this._indextype = new IndexType();
  //            this._indextype = this.cvScenarioDetaildata.itemsEdited[i];
  //            if (this.scenarioDetaildata[j].Date == this._indextype.Date) {
  //                this.indexrowsToUpdate.push(this.scenarioDetaildata[j])
  //            }
  //        }

  //    }

  //    //for (var i = 0; i < this.cvScenarioDetaildata.itemsAdded.length; i++) {
  //    //    //this.cvScenarioDetaildata.itemsAdded[i].AnalysisID = newscenarioid;
  //    //    this.indexrowsToUpdate.push(this.cvScenarioDetaildata.itemsAdded[i]);
  //    //}

  //    //for (var i = 0; i < this.cvScenarioDetaildata.itemsEdited.length; i++) {
  //    //    //this.cvScenarioDetaildata.itemsAdded[i].AnalysisID  = newscenarioid;
  //    //    this.indexrowsToUpdate.push(this.cvScenarioDetaildata.itemsEdited[i]);
  //    //}

  //    this._indextype = this.indexrowsToUpdate;
  //    this.convertDatetoGMTGrid(this._indextype);
  //    this.indexrowsToUpdate = null;
  //    this.indexrowsToUpdate = [];
  //    this.indexupdatedRowNo = null;
  //    this.indexupdatedRowNo = [];

  //    this.scenarioService.AddUpdateIndexType(this._indextype).subscribe(res => {
  //        if (res.Succeeded) {


  //            this._router.navigate(['scenarios']);
  //        }
  //        else {
  //            this._isScenarioDetailFetching = false;
  //            this._ShowmessagedivWar = true;
  //            this._ShowmessagedivMsgWar = "Error occured while saving."
  //            setTimeout(() => {
  //                this._ShowmessagedivWar = false;
  //                this._ShowmessagedivMsgWar = "";
  //            }, 3000);


  //        }
  //    });
  //}


  //downloadFile(objArray) {
  //    var data = this.ConvertToCSV(objArray);
  //    var displayDate = new Date().toLocaleDateString("en-US");
  //    var fileName = "Indexes-" + displayDate + ".csv";

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

  //// convert Json to CSV data in Angular2
  //ConvertToCSV(objArray) {
  //    var array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
  //    var str = '';
  //    var row = "";

  //    for (var index in objArray[0]) {
  //        //Now convert each value to string and comma-separated
  //        row += index + ',';
  //    }
  //    row = row.slice(0, -1);
  //    //append Label row with line break
  //    str += row + '\r\n';

  //    for (var i = 0; i < array.length; i++) {
  //        var line = '';
  //        for (var index in array[i]) {
  //            if (line != '') line += ','

  //            line += array[i][index];
  //        }
  //        str += line + '\r\n';
  //    }
  //    return str;
  //}


}

const routes: Routes = [

  { path: '', component: ScenarioDetailComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjGridFilterModule],
  declarations: [ScenarioDetailComponent]
})

export class scenarioDetailModule { }
