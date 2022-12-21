import { Component, OnInit, Inject, Compiler, ViewChild } from '@angular/core';
import { Router, ActivatedRoute, Params, Route } from '@angular/router';
//import {Scenario} from "../core/domain/scenario"
import * as wjNg2Grid from '@grapecity/wijmo.angular2.grid';
import { OperationResult } from '../core/domain/operationResult.model';
import { scenarioService } from '../core/services/scenario.service';
import { NotificationService } from '../core/services/notification.service'

import { UtilityService } from '../core/services/utility.service';
import { Paginated } from '../core/common/paginated.service';

import * as wjcGrid from '@grapecity/wijmo.grid';

import { ModuleWithProviders, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import { Scenario, Scenariosearch } from "../core/domain/scenario.model";
import { CalculationManagerList } from "../core/domain/calculationManagerList.model";
import { NoteService } from '../core/services/note.service';
import { User } from "../core/domain/user.model";
import { DownloadCashFlow } from "../core/domain/note.model";
import * as $ from "jquery";
//var XLSX = require('../../assets/js/xlsx');

@Component({
  selector: "scenario",
  templateUrl: "./scenario.html",
  providers: [scenarioService, NotificationService, NoteService]
})

export class ScenarioComponent {
  private _scenario!: scenarioService;
  public scenariodata: any
  public TotalCount: number = 0;
  private scenarioupdatedRowNo: any = [];
  scenarioaddpath: any;
  public scenarioToUpdate: any = [];
  lstScenarioData: any;

  public user: User;

  public Message: any = '';
  public _ShowSuccessmessagediv: boolean = false;
  public _ShowSuccessmessage: any;
  // private routes = Routes;
  public _isScenarioListFetching: boolean = true;

  public _scenariosearch = new Scenariosearch();
  public _isScenarioDownloading: boolean = false;
  public _Showmessagediv: boolean = false;


  @ViewChild('flexscenario') flexScenario!: wjcGrid.FlexGrid;
  _calculationManagerList: CalculationManagerList = new CalculationManagerList("");
  public _isShowLoader: boolean = false;
  constructor(private _router: Router,
    public scenarioService: scenarioService,
    public noteSrv: NoteService,
    public utilityService: UtilityService,
    public notificationService: NotificationService) {
    var _scenarioid: any = window.localStorage.getItem("scenarioid"); 
    this._calculationManagerList.AnalysisID = _scenarioid;
    var _user: any = localStorage.getItem('user');
    this.user = JSON.parse(_user);
    this.GetAllScenario();
    this.utilityService.setPageTitle("M61–Scenarios");
  }

  GetAllScenario(): void {
    if (localStorage.getItem('divSucessScenario') == 'true') {
      this._ShowSuccessmessagediv = true;
      this._ShowSuccessmessage = localStorage.getItem('successmsgscenario');
      this._ShowSuccessmessage = (this._ShowSuccessmessage.replace('\"', '')).replace('\"', '');
      localStorage.setItem('divSucessScenario', JSON.stringify(false));
      localStorage.setItem('successmsgscenario', JSON.stringify(''));

      //to hide _Showmessagediv after 5 sec
      setTimeout( () => {
        this._ShowSuccessmessagediv = false;
      }, 5000);

      setTimeout( () => {
        if (this.flexScenario) {
          this.flexScenario.autoSizeColumns(0, this.flexScenario.columns.length, false, 20);
          this.flexScenario.columns[0].width = 350; // for Note Id
        }
      }, 1);

    }

    this.scenarioService.GetScenario().subscribe(res => {

      if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
        var data = res.lstScenario;
        this.lstScenarioData = data;
        this.TotalCount = data.lenght;
        setTimeout(() => {
          this.flexScenario.selectionMode = wjcGrid.SelectionMode.None;
          this._isScenarioListFetching = false;
        }, 200);
      } else {

        localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
        localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));
        this.utilityService.navigateUnauthorize();
      }
    });
  }

  ShowSuccessmessageDiv(msg: any) {
    this._ShowSuccessmessagediv = true;
    this._ShowSuccessmessage = msg;
    setTimeout(() => {
      this._ShowSuccessmessagediv = false;
    }, 5000);
  }

  AddNewScenario(): void {
    this._router.navigate(['/scenariodetail', "00000000-0000-0000-0000-000000000000"]);
  }

  ResetDefaultToActiveScenario(): void {
    try {
      this._isScenarioListFetching = true;
      this.scenarioService.ResetDefaultToActiveScenario(this._calculationManagerList).subscribe(res => {
        if (res.Succeeded) {
          this.GetAllScenario();
          this._ShowSuccessmessagediv = true;
          this._isScenarioListFetching = false;
          var msg = "Default Scenario is marked as active and notes sent to server for calculation.";
          this.ShowSuccessmessageDiv(msg);
        }
        else {
          this._router.navigate(['login']);
        }
      });
    } catch (err) {
    }
  }

  DownloadScenario(obj: any): void {
    //var _note: Note;
    this._isScenarioDownloading = true;
    this._scenariosearch.AnalysisID = obj.AnalysisID;
    this._scenariosearch.ScenarioName = obj.ScenarioName;
    this._isShowLoader = true;
    var downloadCashFlow = new DownloadCashFlow();
    downloadCashFlow.Pagename = "Scenario";
    var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '-');
    var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '-');
    downloadCashFlow.MutipleNoteId = "";
    downloadCashFlow.AnalysisID = obj.AnalysisID;
    var fileName = "CashFlow_" + this._scenariosearch.ScenarioName + "_" + displayDate + "_" + displayTime + "_" + this.user.Login + ".xlsx";

    this.noteSrv.getNoteCashflowsExportData(downloadCashFlow).subscribe(res => {
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
      this._isShowLoader = false;
    });
    
  }

  /*
  exportToExcel(filename: any, arr : any, sheets: any) {
    const fileName = filename + '.xlsx';
    var ws = XLSX.WorkSheet;
    var wb = XLSX.WorkBook;
    wb = XLSX.utils.book_new();
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
*/

  downloadFile(objArray: any) {

    var _user: any = localStorage.getItem('user');
    this.user = JSON.parse(_user);

    var data = this.ConvertToCSV(objArray);
    var displayDate = new Date().toLocaleDateString("en-US");
    //var fileName = "Scenario_" + this._scenariosearch.ScenarioName+"_" + displayDate + ".csv";
    var displayTime = new Date().toLocaleTimeString("en-US")
    var fileName = "CashFlow_" + this._scenariosearch.ScenarioName + "_" + displayDate + "_" + displayTime + "_" + this.user.Login + ".csv";

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
}


const routes: Routes = [

  { path: '', component: ScenarioComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjGridFilterModule],
  declarations: [ScenarioComponent]

})

export class scenarioModule { }
