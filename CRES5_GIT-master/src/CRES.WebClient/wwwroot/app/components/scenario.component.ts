import { Component, OnInit, Inject, Compiler, ViewChild } from '@angular/core';
import { Router, ActivatedRoute, Params, Route } from '@angular/router';
//import {Scenario} from "../core/domain/scenario"
import * as wjNg2Grid from 'wijmo/wijmo.angular2.grid';
import { OperationResult } from '../core/domain/operationResult';
import { scenarioService } from '../core/services/scenarioService';
import { NotificationService } from '../core/services/notificationService'

import {isLoggedIn} from '../core/services/is-logged-in';
import { UtilityService } from '../core/services/utilityService';
import { Paginated } from '../core/common/paginated';

import * as wjcCore from 'wijmo/wijmo';
import * as wjcGrid from 'wijmo/wijmo.grid';

import { ModuleWithProviders, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
//import { Location, LocationStrategy, HashLocationStrategy } from '@angular/common';
import { Headers, RequestOptions, BaseRequestOptions } from '@angular/http';
import { WjCoreModule } from 'wijmo/wijmo.angular2.core';
import { WjGridModule } from 'wijmo/wijmo.angular2.grid';
import { WjGridFilterModule } from 'wijmo/wijmo.angular2.grid.filter';
import { Scenario, Scenariosearch } from "../core/domain/scenario";
import { CalculationManagerList } from "../core/domain/CalculationManagerList";
import { NoteService } from '../core/services/noteservice';
import { User } from "../core/domain/User";
import { DownloadCashFlow } from "../core/domain/note";
declare var $: any;
declare var XLSX: any;

@Component({
    selector: "scenario",
    templateUrl: "app/components/Scenario.html?v=" + $.getVersion(),
    providers: [scenarioService, NotificationService, NoteService]
   })

export class ScenarioComponent {
    private _scenario: scenarioService;
    //private _scenarios: Scenario;
    //private _scenariosearch: Scenario;
    private scenariodata: any
    private TotalCount: number = 0;
    private scenarioupdatedRowNo: any = [];
    scenarioaddpath: any;
    private scenarioToUpdate: any = [];
    lstScenarioData: any;

    public user: User;

    private Message: any = '';
    private _ShowSuccessmessagediv: boolean = false;
    private _ShowSuccessmessage: any;
   // private routes = Routes;
    private _isScenarioListFetching: boolean = true;
    _DeleteMsgText: any;
    public _scenariosearch = new Scenariosearch();
    private _isScenarioDownloading: boolean = false;
    private _Showmessagediv: boolean = false;
    _deletedScenario: any;


    @ViewChild('flexscenario') flexScenario: wjcGrid.FlexGrid;
    _calculationManagerList: CalculationManagerList = new CalculationManagerList("");
    private _isShowLoader: boolean = false;
    constructor(private _router: Router,
        public scenarioService: scenarioService,
        public noteSrv: NoteService,
        public utilityService: UtilityService,
        public notificationService: NotificationService) {
        this._calculationManagerList.AnalysisID = window.localStorage.getItem("scenarioid");
        this.user = JSON.parse(localStorage.getItem('user'));
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
            setTimeout(function () {
                this._ShowSuccessmessagediv = false;
            }.bind(this), 5000);

            setTimeout(function () {
                if (this.flexScenario) {
                    this.flexScenario.autoSizeColumns(0, this.flexScenario.columns.length, false, 20);
                    this.flexScenario.columns[0].width = 350; // for Note Id
                }
            }.bind(this), 1);

        }

        this.scenarioService.GetScenario().subscribe(res =>
        {

            if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                var data = res.lstScenario;
                this.lstScenarioData = data;
                this.TotalCount = data.lenght;
                setTimeout(function () {
                    this.flexScenario.selectionMode = wjcGrid.SelectionMode.None;
                    this._isScenarioListFetching = false;
                }.bind(this), 200);
            } else
            {

                localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));
                this.utilityService.navigateUnauthorize();
            }

           
        });
    }

    ShowSuccessmessageDiv(msg) {
        this._ShowSuccessmessagediv = true;
        this._ShowSuccessmessage = msg;
        setTimeout(function () {
            this._ShowSuccessmessagediv = false;
        }.bind(this), 5000);
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

    DownloadScenario(obj): void{
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
         
       /*
        this.scenarioService.getGetScenarioDownload(this._scenariosearch).subscribe(res => {

            if (res.Succeeded) {
                setTimeout(function () {                    
                    this._isScenarioDownloading = false;
                }.bind(this), 100);

                var exceptiondt = res.dt;
                this.user = JSON.parse(localStorage.getItem('user'));

                var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '-');
                var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '-');
                var exceptiontablst = [];
                if (exceptiondt.length > 0) {
                    for (var j = 0; j < exceptiondt.length; j++) {
                        exceptiontablst.push({
                            'CREID': exceptiondt[j].CRENoteID,
                            'Name': exceptiondt[j].Name,
                            'Field name': exceptiondt[j].FieldName,
                            'Summary': exceptiondt[j].Summary,
                            'Exception type': exceptiondt[j].ActionLevelText,
                            'Exception date': new Date(exceptiondt[j].UpdatedDate)
                        });
                    }
                } else {
                    exceptiontablst.push({
                        'CREID': null,
                        'Name': null,
                        'Field name': null,
                        'Summary': null,
                        'Exception type': null,
                        'Exception date': null
                    });
                }
                var tabname = this._scenariosearch.ScenarioName + "_Cashflow";
                var fileName = "CashFlow_" + this._scenariosearch.ScenarioName + "_" + displayDate + "_" + displayTime + "_" + this.user.Login;
                this.exportToExcel(fileName, [res.dtIndexType, exceptiontablst], [tabname,'Exceptions']);
               // this.downloadFile(res.dtIndexType);
                this._isShowLoader = false;
            }
            else {
                // this._dvEmptynoteperiodiccalcMsg = true;
            }
            error => {
                this._isShowLoader = false;
            }
        });
       */
    }

    exportToExcel(filename, arr, sheets) {
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

    downloadFile(objArray) {
        this.user = JSON.parse(localStorage.getItem('user'));        

        var data = this.ConvertToCSV(objArray);
        var displayDate = new Date().toLocaleDateString("en-US");
        //var fileName = "Scenario_" + this._scenariosearch.ScenarioName+"_" + displayDate + ".csv";
        var displayTime = new Date().toLocaleTimeString("en-US")
        var fileName = "CashFlow_" + this._scenariosearch.ScenarioName + "_"+ displayDate + "_" + displayTime + "_" + this.user.Login + ".csv";

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


    DeleteSce(deleteditem: any) {
        var customdialogbox = document.getElementById('Deletedialogbox');
        customdialogbox.style.display = "block";
        this._deletedScenario = deleteditem;
        this._DeleteMsgText = ' Are you sure you want to delete the ' + deleteditem.ScenarioName + ' Scenario' ;
        $.getScript("/js/jsDrag.js");
    }

    DeleteScenario() {
        debugger;
        this.scenarioService.deleteScenario(this._deletedScenario.AnalysisID)
            .subscribe(res => {
                if (res.Succeeded) {
                    this.GetAllScenario();
                    this._isShowLoader = false;
                    this._ShowSuccessmessage = 'Scenario deleted successfully.'
                    this._ShowSuccessmessagediv = true;
                    this.ClosePopUp();
                    setTimeout(function () {
                        this._ShowSuccessmessagediv = false;
                    }.bind(this), 5000);

                    //
                }
                else {
                    this.ClosePopUp();
                    this._isShowLoader = false;
                    this.Message = "Something went wrong.Please try after some time.";
                    this._Showmessagediv = true;
                    setTimeout(function () {
                        this._Showmessagediv = false;
                    }.bind(this), 5000);
                   
                }
            },
                error => {
                    if (error.status == 401) {
                        this.notificationService.printErrorMessage('Authentication required');
                        this.utilityService.navigateToSignIn();
                    }
                }
            );
    }
    ClosePopUp() {
        var modal = document.getElementById('Deletedialogbox');
        modal.style.display = "none";
        
    }
}


const routes: Routes = [

    { path: '', component: ScenarioComponent }]

@NgModule({
    imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjGridFilterModule],
    declarations: [ScenarioComponent]

})

export class ScenarioModule { }