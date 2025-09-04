import { Component, OnInit, Inject, Compiler, ViewChild } from '@angular/core';
import { Router, ActivatedRoute, Params, Route } from '@angular/router';
import { Scenario, Scenariosearch } from "../core/domain/scenario.model";
import { IndexType } from "../core/domain/indexType.model";
import * as wjNg2Grid from '@grapecity/wijmo.angular2.grid';

import { scenarioService } from '../core/services/scenario.service';
import { NotificationService } from '../core/services/notification.service'

import { UtilityService } from '../core/services/utility.service';
import { Paginated } from '../core/common/paginated.service';

import * as wjcCore from '@grapecity/wijmo';
import * as wjcGrid from '@grapecity/wijmo.grid';

import { ModuleWithProviders, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';

import { DataService } from '../core/services/data.service';
import { MembershipService } from '../core/services/membership.service';

@Component({
  selector: "scenariodetail",
  templateUrl: "./scenarioDetail.html",
  providers: [scenarioService, NotificationService, UtilityService, MembershipService],
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
  public _isshowCalcAndSave: boolean = true;

  public TotalCount: number = 0;
  public scenarioDetaildata: any;
  public scenarioindexdata: Array<any>;
  public subCategories: any = [];
  public Message: any = '';
  public _Showmessagediv: boolean = false;
  public _isScenarioDetailFetching: boolean = true;
  public _isShowScenarioRuleType: boolean = false;
  public _isShowOtherScenario: boolean = false;
  public _disableScenarioStatus: boolean = false;
  public _disableEditingSName: boolean = false;
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
  lstIncludeProjectedPrincipalWriteoff: any;
  lstCalculateLiability: any;
  lstAllowCalcOverride: any;
  lstAllowCalcAlongWithDefault: any;
  lstAccountingClose: any;
  lstScenarioStatus: any;
  lstUseFinancingMaturityDateOverride: any;
  lstIncludeInDiscrepancy: any;
  public saveorupdate: any = "";

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
  @ViewChild('flexScenarioDetail') flexScenarioDetail: wjcGrid.FlexGrid; s
  lstCalculationFrequency: any;
  lstCalcEngineType: any;
  public CalculationFrequencyId: any;
  public CalcEngineTypeId: any;
  public _timezoneAbbreviation: any;

  constructor(private activatedRoute: ActivatedRoute,
    private _router: Router,
    public scenarioService: scenarioService,
    public utilityService: UtilityService,
    public notificationService: NotificationService,
    public dataService: DataService,
    public membershipservice: MembershipService) {
    super(30, 0, 0);
    this.activatedRoute.params.forEach((params: Params) => {
      if (params['id'] !== undefined) {
        var scenarioaId = params['id'];
        this._scenariodc = new Scenario(scenarioaId);
        this.analysisid = scenarioaId;
        this.GetScenarioByID(scenarioaId);
      }
    });
    this.utilityService.setPageTitle("M61 – Scenario Details");
    this.GetUserTimezoneByID();
  }
  GetScenarioByID(_scenarioaId): void {
    try {
      this.scenarioService.GetScenarioByScenarioID(_scenarioaId).subscribe(res => {
        if (res.Succeeded) {
          if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
            this._scenariodc = res.ScenarioParameters;
            var _isV1UIEnable = this.dataService._isV1UIEnable;

            if (this._scenariodc.ScenarioName != "Default") {
              this._isShowOtherScenario = true;
            }

            if (_isV1UIEnable == "true") {
              this._isShowScenarioRuleType = true;
            }
            else {
              this._isShowScenarioRuleType = false;
            }

            this.GetAllLookups();
            this.GetAllIndexes();

            this._isScenarioDetailFetching = false;

            if (this._scenariodc.ScenarioName == "Default" || this._scenariodc.ScenarioName == "Fully Extended (with Prepay, Index Flat)") {
              this._disableScenarioStatus = true;
              this._disableEditingSName = true;
            }
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
  OnChangeScenarioStatus(newvalue) {
    this.showhidesaveandcalcbutton();

  }
  showhidesaveandcalcbutton() {

    if (this._scenariodc.ScenarioStatus == 2) {
      this._isshowCalcAndSave = false;
    } else {
      this._isshowCalcAndSave = true;
    }
  }
  CustomDialogteSave(msg): void {
    var winW = window.innerWidth;
    var winH = window.innerHeight;
    var dialogbox = document.getElementById('Genericdialogbox');
    document.getElementById('savedialogmessage').innerHTML = msg;

    dialogbox.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }
  ClosePopUpDialog() {
    var modal = document.getElementById('Genericdialogbox');
    modal.style.display = "none";
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
          this.lstIncludeProjectedPrincipalWriteoff = data.filter(x => x.ParentID == "2");
          this.lstCalculateLiability = data.filter(x => x.ParentID == "2");
          this.lstAllowCalcOverride = data.filter(x => x.ParentID == "2");
          this.lstAllowCalcAlongWithDefault = data.filter(x => x.ParentID == "2");
          this.lstAccountingClose = data.filter(x => x.ParentID == "2");
          this.lstBusinessDayAdjustment = data.filter(x => x.ParentID == "2");
          this.lstCalculationFrequency = data.filter(x => x.ParentID == "133");
          this.lstCalcEngineType = data.filter(x => x.ParentID == "134");
          this.lstScenarioStatus = data.filter(x => x.ParentID == "1");
          this.lstUseFinancingMaturityDateOverride = data.filter(x => x.ParentID == "2");
          this.lstIncludeInDiscrepancy = data.filter(x => x.ParentID == "2");
          if (this.analysisid == "00000000-0000-0000-0000-000000000000") {
            this.CalculationFrequencyId = this.lstCalculationFrequency.filter(x => x.Name == "Daily")[0].LookupID;
            this._scenariodc.CalculationFrequency = this.CalculationFrequencyId;
            this.CalcEngineTypeId = this.lstCalcEngineType.filter(x => x.Name == "V1 (New)")[0].LookupID;
            this._scenariodc.CalcEngineType = this.CalcEngineTypeId;
          }
          if (this._scenariodc.CalcEngineType == 798) {
            this._isShowScenarioRuleType = true;
          }
          else {
            this._isShowScenarioRuleType = false;
          }
        }
        else {
          this._router.navigate(['login']);
        }
      });
    } catch (err) {
    }
  }

  OnChangeCalcEngineType(newvalue) {
    if (newvalue == 798) {
      this._isShowScenarioRuleType = true;
    }
    else {
      this._isShowScenarioRuleType = false;
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

  CheckAndSaveScenario(Actionstatus) {
    this.saveorupdate = Actionstatus;
    if (Actionstatus == "CalcAndSave") {
      var msg = "Are you sure to want to save and calculate " + this._scenariodc.ScenarioName + " scenario."
      this.CustomDialogteSave(msg);
    } else {
      this.ValidateScenarioAndSave(Actionstatus);
    }

  }
  InsertUpdateData() {
    this.ValidateScenarioAndSave('CalcAndSave');
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
        this._scenariodc.ActionStatus = Actionstatus;
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

      const lstJsonString = JSON.stringify(this.lstjsonparameters);
      this._scenariodc.jsonparam = lstJsonString;

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

  beginningEdit(modulename): void {
    switch (modulename) {
      case "ScenarioDetail":
        var sel = this.flexScenarioDetail.selection;
        if (this.scenarioDetaildata[sel.topRow].Date != null)
          this.prevDateBeforeEdit = this.scenarioDetaildata[sel.topRow].Date;
        break;
    }
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

  trackGridChanges(ParentModuleName: string, ChildModuleName: string, ModuleID: string, FieldName: string, rowIndex: number, FieldValue: any) {
    
    const change = {
      ParentModuleName: ParentModuleName,
      ChildModuleName: ChildModuleName,
      ModuleID: ModuleID,
      FieldName: FieldName,
      RowIndex: rowIndex,
      FieldValue: FieldValue
    };

    const existingChangeIndex = this.lstjsonparameters.findIndex(item =>
      item.FieldName === FieldName && item.RowIndex === rowIndex
    );

    if (existingChangeIndex !== -1) {
      this.lstjsonparameters[existingChangeIndex].FieldValue = FieldValue;
    } else {
      this.lstjsonparameters.push(change);
    }
  }


  onCellEditEnded(event: any, grid: any) {
    const column = grid.columns[event.col];
    const row = grid.rows[event.row];
    const binding = column.binding;
    const value = grid.getCellData(event.row, event.col, true);

    this.trackGridChanges('Scenario', 'Scenario Detail', this._scenariodc.AnalysisID, binding, row.index, value);
  }


  lstjsonparameters: { ParentModuleName: string, ChildModuleName: string, ModuleID: string, FieldName: string, RowIndex: number, FieldValue: any }[] = [];

  trackFieldChange(ParentModuleName: string, ChildModuleName: string, ModuleID: string, FieldName: string, FieldValue: any) {

    let RowIndex = 0;

    if (FieldName == "Maturity Scenario Override") {
      var selectedMaturity = this.lstMaturityScenarioOverride.filter(option => option.LookupID == FieldValue);
      if (selectedMaturity) {
        FieldValue = selectedMaturity[0].Name;
      }
    }

    if (FieldName == "Index Scenario Override") {
      var selectedIndex = this.lstIndexesMaster.filter(option => option.IndexesMasterID == FieldValue);
      if (selectedIndex) {
        FieldValue = selectedIndex[0].IndexesName;
      }
    }

    if (FieldName == "Calculation Mode") {
      var selectedCalculation = this.lstCalculationMode.filter(option => option.LookupID == FieldValue);
      if (selectedCalculation) {
        FieldValue = selectedCalculation[0].Name;
      }
    }

    if (FieldName == "Automate Calculation Frequency") {
      var selectedCalcFreq = this.lstAutoCalcFreq.filter(option => option.LookupID == FieldValue);
      if (selectedCalcFreq) {
        FieldValue = selectedCalcFreq[0].Name;
      }
    }

    if (FieldName == "Use Servicing Data") {
      var selectedActuals = this.lstUseActuals.filter(option => option.LookupID == FieldValue);
      if (selectedActuals) {
        FieldValue = selectedActuals[0].Name;
      }
    }

    if (FieldName == "Disable Business Day Adjustment") {
      var selected = this.lstBusinessDayAdjustment.filter(option => option.LookupID == FieldValue);
      if (selected) {
        FieldValue = selected[0].Name;
      }
    }

    if (FieldName == "Calculation Frequency") {
      var selectedfreq = this.lstCalculationFrequency.filter(option => option.LookupID == FieldValue);
      if (selectedfreq) {
        FieldValue = selectedfreq[0].Name;
      }
    }
    if (FieldName == "Calc Engine Type") {
      var selectCalcEngineType = this.lstCalcEngineType.filter(option => option.LookupID == FieldValue);
      if (selectCalcEngineType) {
        FieldValue = selectCalcEngineType[0].Name;
      }
    }
    if (FieldName == "Allow Calc Engine Type Override") {
      var selectcalc = this.lstAllowCalcOverride.filter(option => option.LookupID == FieldValue);
      if (selectcalc) {
        FieldValue = selectcalc[0].Name;
      }
    }
    if (FieldName == "Calc Along with Default") {
      var selecteddefault = this.lstAllowCalcAlongWithDefault.filter(option => option.LookupID == FieldValue);
      if (selecteddefault) {
        FieldValue = selecteddefault[0].Name;
      }
    }
    if (FieldName == "Include Projected Principal Writeoff") {
      var selectedWriteoff = this.lstIncludeProjectedPrincipalWriteoff.filter(option => option.LookupID == FieldValue);
      if (selectedWriteoff) {
        FieldValue = selectedWriteoff[0].Name;
      }
    }
    if (FieldName == "Calculate Liability") {
      var selectedliability = this.lstCalculateLiability.filter(option => option.LookupID == FieldValue);
      if (selectedliability) {
        FieldValue = selectedliability[0].Name;
      }
    }
    if (FieldName == "Scenario Status") {
      var selectedStatus = this.lstScenarioStatus.filter(option => option.LookupID == FieldValue);
      if (selectedStatus) {
        FieldValue = selectedStatus[0].Name;
      }
    }
    if (FieldName == "Use Financing Maturity Date Override") {
      var sel = this.lstUseFinancingMaturityDateOverride.filter(option => option.LookupID == FieldValue);
      if (sel) {
        FieldValue = sel[0].Name;
      }
    }

    if (FieldName == "Excluded Forcasted Pre Payment") {
      var Excluded = this.lstExcludedForcastedPrePayment.filter(option => option.LookupID == FieldValue);
      if (Excluded) {
        FieldValue = Excluded[0].Name;
      }
    }
    if (FieldName == "Include In Discrepancy") {
      var desc = this.lstIncludeInDiscrepancy.filter(option => option.LookupID == FieldValue);
      if (desc) {
        FieldValue = desc[0].Name;
      }
    }

    const existingIndex = this.lstjsonparameters.findIndex(item => item.FieldName === FieldName);
    if (existingIndex !== -1) {
      this.lstjsonparameters[existingIndex].FieldValue = FieldValue;
    } else {
      this.lstjsonparameters.push({ ParentModuleName, ChildModuleName, ModuleID, FieldName, RowIndex, FieldValue });
    }
  }

  GetUserTimezoneByID() {
    this.membershipservice.GetUserTimeZonebyUserID().subscribe(res => {
      if (res.Succeeded) {
        var data = res.dt;
        this._timezoneAbbreviation = data[0].Abbreviation;
      }
    });
  }
}

const routes: Routes = [

  { path: '', component: ScenarioDetailComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjGridFilterModule],
  declarations: [ScenarioDetailComponent]
})

export class scenarioDetailModule { }
