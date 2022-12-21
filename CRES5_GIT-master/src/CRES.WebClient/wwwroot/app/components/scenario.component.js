"use strict";
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
exports.ScenarioModule = exports.ScenarioComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var scenarioService_1 = require("../core/services/scenarioService");
var notificationService_1 = require("../core/services/notificationService");
var utilityService_1 = require("../core/services/utilityService");
var wjcGrid = require("wijmo/wijmo.grid");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wijmo_angular2_core_1 = require("wijmo/wijmo.angular2.core");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var scenario_1 = require("../core/domain/scenario");
var CalculationManagerList_1 = require("../core/domain/CalculationManagerList");
var noteservice_1 = require("../core/services/noteservice");
var note_1 = require("../core/domain/note");
var ScenarioComponent = /** @class */ (function () {
    function ScenarioComponent(_router, scenarioService, noteSrv, utilityService, notificationService) {
        this._router = _router;
        this.scenarioService = scenarioService;
        this.noteSrv = noteSrv;
        this.utilityService = utilityService;
        this.notificationService = notificationService;
        this.TotalCount = 0;
        this.scenarioupdatedRowNo = [];
        this.scenarioToUpdate = [];
        this.Message = '';
        this._ShowSuccessmessagediv = false;
        // private routes = Routes;
        this._isScenarioListFetching = true;
        this._scenariosearch = new scenario_1.Scenariosearch();
        this._isScenarioDownloading = false;
        this._Showmessagediv = false;
        this._calculationManagerList = new CalculationManagerList_1.CalculationManagerList("");
        this._isShowLoader = false;
        this._calculationManagerList.AnalysisID = window.localStorage.getItem("scenarioid");
        this.user = JSON.parse(localStorage.getItem('user'));
        this.GetAllScenario();
        this.utilityService.setPageTitle("M61–Scenarios");
    }
    ScenarioComponent.prototype.GetAllScenario = function () {
        var _this = this;
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
        this.scenarioService.GetScenario().subscribe(function (res) {
            if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                var data = res.lstScenario;
                _this.lstScenarioData = data;
                _this.TotalCount = data.lenght;
                setTimeout(function () {
                    this.flexScenario.selectionMode = wjcGrid.SelectionMode.None;
                    this._isScenarioListFetching = false;
                }.bind(_this), 200);
            }
            else {
                localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));
                _this.utilityService.navigateUnauthorize();
            }
        });
    };
    ScenarioComponent.prototype.ShowSuccessmessageDiv = function (msg) {
        this._ShowSuccessmessagediv = true;
        this._ShowSuccessmessage = msg;
        setTimeout(function () {
            this._ShowSuccessmessagediv = false;
        }.bind(this), 5000);
    };
    ScenarioComponent.prototype.AddNewScenario = function () {
        this._router.navigate(['/scenariodetail', "00000000-0000-0000-0000-000000000000"]);
    };
    ScenarioComponent.prototype.ResetDefaultToActiveScenario = function () {
        var _this = this;
        try {
            this._isScenarioListFetching = true;
            this.scenarioService.ResetDefaultToActiveScenario(this._calculationManagerList).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.GetAllScenario();
                    _this._ShowSuccessmessagediv = true;
                    _this._isScenarioListFetching = false;
                    var msg = "Default Scenario is marked as active and notes sent to server for calculation.";
                    _this.ShowSuccessmessageDiv(msg);
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
        }
    };
    ScenarioComponent.prototype.DownloadScenario = function (obj) {
        var _this = this;
        //var _note: Note;
        this._isScenarioDownloading = true;
        this._scenariosearch.AnalysisID = obj.AnalysisID;
        this._scenariosearch.ScenarioName = obj.ScenarioName;
        this._isShowLoader = true;
        var downloadCashFlow = new note_1.DownloadCashFlow();
        downloadCashFlow.Pagename = "Scenario";
        var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '-');
        var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '-');
        downloadCashFlow.MutipleNoteId = "";
        downloadCashFlow.AnalysisID = obj.AnalysisID;
        var fileName = "CashFlow_" + this._scenariosearch.ScenarioName + "_" + displayDate + "_" + displayTime + "_" + this.user.Login + ".xlsx";
        this.noteSrv.getNoteCashflowsExportData(downloadCashFlow).subscribe(function (res) {
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
            _this._isShowLoader = false;
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
    };
    ScenarioComponent.prototype.exportToExcel = function (filename, arr, sheets) {
        var fileName = filename + '.xlsx';
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
    };
    ScenarioComponent.prototype.downloadFile = function (objArray) {
        this.user = JSON.parse(localStorage.getItem('user'));
        var data = this.ConvertToCSV(objArray);
        var displayDate = new Date().toLocaleDateString("en-US");
        //var fileName = "Scenario_" + this._scenariosearch.ScenarioName+"_" + displayDate + ".csv";
        var displayTime = new Date().toLocaleTimeString("en-US");
        var fileName = "CashFlow_" + this._scenariosearch.ScenarioName + "_" + displayDate + "_" + displayTime + "_" + this.user.Login + ".csv";
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
    ScenarioComponent.prototype.ConvertToCSV = function (objArray) {
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
    ScenarioComponent.prototype.DeleteSce = function (deleteditem) {
        var customdialogbox = document.getElementById('Deletedialogbox');
        customdialogbox.style.display = "block";
        this._deletedScenario = deleteditem;
        this._DeleteMsgText = ' Are you sure you want to delete the ' + deleteditem.ScenarioName + ' Scenario';
        $.getScript("/js/jsDrag.js");
    };
    ScenarioComponent.prototype.DeleteScenario = function () {
        var _this = this;
        debugger;
        this.scenarioService.deleteScenario(this._deletedScenario.AnalysisID)
            .subscribe(function (res) {
            if (res.Succeeded) {
                _this.GetAllScenario();
                _this._isShowLoader = false;
                _this._ShowSuccessmessage = 'Scenario deleted successfully.';
                _this._ShowSuccessmessagediv = true;
                _this.ClosePopUp();
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                }.bind(_this), 5000);
                //
            }
            else {
                _this.ClosePopUp();
                _this._isShowLoader = false;
                _this.Message = "Something went wrong.Please try after some time.";
                _this._Showmessagediv = true;
                setTimeout(function () {
                    this._Showmessagediv = false;
                }.bind(_this), 5000);
            }
        }, function (error) {
            if (error.status == 401) {
                _this.notificationService.printErrorMessage('Authentication required');
                _this.utilityService.navigateToSignIn();
            }
        });
    };
    ScenarioComponent.prototype.ClosePopUp = function () {
        var modal = document.getElementById('Deletedialogbox');
        modal.style.display = "none";
    };
    var _a, _b;
    __decorate([
        (0, core_1.ViewChild)('flexscenario'),
        __metadata("design:type", typeof (_a = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _a : Object)
    ], ScenarioComponent.prototype, "flexScenario", void 0);
    ScenarioComponent = __decorate([
        (0, core_1.Component)({
            selector: "scenario",
            templateUrl: "app/components/Scenario.html?v=" + $.getVersion(),
            providers: [scenarioService_1.scenarioService, notificationService_1.NotificationService, noteservice_1.NoteService]
        }),
        __metadata("design:paramtypes", [typeof (_b = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _b : Object, scenarioService_1.scenarioService,
            noteservice_1.NoteService,
            utilityService_1.UtilityService,
            notificationService_1.NotificationService])
    ], ScenarioComponent);
    return ScenarioComponent;
}());
exports.ScenarioComponent = ScenarioComponent;
var routes = [
    { path: '', component: ScenarioComponent }
];
var ScenarioModule = /** @class */ (function () {
    function ScenarioModule() {
    }
    ScenarioModule = __decorate([
        (0, core_2.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_core_1.WjCoreModule, wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule],
            declarations: [ScenarioComponent]
        })
    ], ScenarioModule);
    return ScenarioModule;
}());
exports.ScenarioModule = ScenarioModule;
//# sourceMappingURL=scenario.component.js.map