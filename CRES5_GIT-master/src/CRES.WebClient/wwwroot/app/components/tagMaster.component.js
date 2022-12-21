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
exports.TagMasterModule = exports.TagMasterComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var wjcGrid = require("wijmo/wijmo.grid");
var core_2 = require("@angular/core");
var utilityService_1 = require("../core/services/utilityService");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wijmo_angular2_chart_1 = require("wijmo/wijmo.angular2.chart");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var tagMasterService_1 = require("../core/services/tagMasterService");
var membershipservice_1 = require("../core/services/membershipservice");
var TagMaster_1 = require("../core/domain/TagMaster");
var scenarioService_1 = require("../core/services/scenarioService");
var Scenario_1 = require("../core/domain/Scenario");
var fileuploadservice_1 = require("../core/services/fileuploadservice");
var TagMasterComponent = /** @class */ (function () {
    function TagMasterComponent(tagMasterService, membershipService, utilityService, scenarioService, fileUploadService, _router) {
        this.tagMasterService = tagMasterService;
        this.membershipService = membershipService;
        this.utilityService = utilityService;
        this.scenarioService = scenarioService;
        this.fileUploadService = fileUploadService;
        this._router = _router;
        this._ShowSuccessmessageRolediv = false;
        this._alertinfodiv = false;
        this._Showgrid = false;
        this._isShowLoader = false;
        this._ShowSucessdiv = false;
        this._isshowAddTag = false;
        this._isshowDeleteTag = false;
        this._isRoleSaving = false;
        this._IsShowMsg = false;
        this._Showgrid = false;
        this.tagMaster = new TagMaster_1.TagMaster("");
        this.user = JSON.parse(localStorage.getItem('user'));
        this.ConfirmDialogBoxFor = "";
        this.utilityService.setPageTitle("Tag-Master");
        this.GettagList();
        this._scenariodc = new Scenario_1.Scenario('');
        this._lstScenario = this._scenariodc.LstScenarioUserMap;
        this.getAllDistinctScenario();
    }
    TagMasterComponent.prototype.getAllDistinctScenario = function () {
        var _this = this;
        var _userData = JSON.parse(localStorage.getItem('user'));
        this._scenariodc.UserID = _userData.UserID;
        this.scenarioService.getAllScenarioDistinct(this._scenariodc).subscribe(function (res) {
            if (res.Succeeded) {
                if (res.lstScenarioUserMap.length > 0) {
                    _this._lstScenario = res.lstScenarioUserMap;
                    _this.ScenarioId = res.lstScenarioUserMap.filter(function (x) { return x.ScenarioName == "Default"; })[0].AnalysisID;
                }
            }
        });
    };
    TagMasterComponent.prototype.GettagList = function () {
        var _this = this;
        this.ScenarioId = window.localStorage.getItem("scenarioid");
        this.tagMaster.AnalysisID = this.ScenarioId;
        try {
            this.tagMasterService.GetTagMaster(this.tagMaster).subscribe(function (res) {
                if (res.Succeeded) {
                    if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0 && res.UserPermissionList.filter(function (x) { return x.ModuleType == "Page"; }).length > 0) {
                        _this.listTagMaster = res.TagMasterList;
                        if (_this.listTagMaster.length > 0) {
                            _this._Showgrid = true;
                            _this.ConvertToBindableDate(_this.listTagMaster);
                        }
                        _this.ApplyPermissions(res.UserPermissionList);
                    }
                    else {
                        localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                        localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));
                        _this.utilityService.navigateUnauthorize();
                    }
                }
                else {
                }
            });
        }
        catch (err) {
        }
    };
    TagMasterComponent.prototype.ApplyPermissions = function (_object) {
        for (var i = 0; i < _object.length; i++) {
            if (_object[i].ChildModule == 'btnAddTag') {
                this._isshowAddTag = true;
            }
            if (_object[i].ChildModule == 'btnDeleteTag') {
                this._isshowDeleteTag = true;
            }
        }
    };
    TagMasterComponent.prototype.ConvertToBindableDate = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this.listTagMaster[i].CreatedDate != null)
                this.listTagMaster[i].CreatedDate = this.convertDateToBindable(this.listTagMaster[i].CreatedDate);
        }
    };
    TagMasterComponent.prototype.convertDateToBindable = function (date) {
        var dateObj = new Date(date);
        return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear() + " " + dateObj.getHours() + ":" + dateObj.getMinutes() + ":" + dateObj.getSeconds();
    };
    TagMasterComponent.prototype.getTwoDigitString = function (number) {
        if (number.toString().length === 1)
            return "0" + number;
        return number;
    };
    TagMasterComponent.prototype.CallConfirmBox = function () {
        if (this.ConfirmDialogBoxFor == 'AddTag') {
            this.SaveTag();
        }
        if (this.ConfirmDialogBoxFor == 'DeleteTag') {
            this.DeleteTag();
        }
    };
    TagMasterComponent.prototype.DeleteTag = function () {
        var _this = this;
        this._isShowLoader = true;
        this.tagMasterService.DeleteTagByTagID(this.tagMaster).subscribe(function (res) {
            if (res.Succeeded) {
                _this._isShowLoader = false;
                _this.ClosePopUpConfirmBox();
                _this._ShowSucessdivMsg = "Tag '" + _this.tagMaster.TagName + "' has been deleted successfully.";
                _this._ShowSucessdiv = true;
                setTimeout(function () {
                    this._ShowSucessdiv = false;
                }.bind(_this), 4000);
                _this.GettagList();
            }
            else {
                _this._isShowLoader = false;
                _this.ClosePopUpConfirmBox();
                _this.GettagList();
            }
            (function (error) {
                _this._isShowLoader = false;
                _this.ClosePopUpConfirmBox();
                _this.GettagList();
            });
        });
    };
    TagMasterComponent.prototype.DeleteLink_Click = function (obj) {
        this.ConfirmDialogBoxFor = 'DeleteTag';
        this.tagMaster.TagMasterID = obj.TagMasterID;
        this.tagMaster.AnalysisID = obj.AnalysisID;
        this.tagMaster.TagName = obj.TagName;
        var customdialogbox = document.getElementById('customdialogbox');
        this._ConfirmMsgText = 'Are you sure you want to delete ' + this.tagMaster.TagName + ' for ' + obj.AnalysisName + ' scenario?';
        customdialogbox.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    TagMasterComponent.prototype.CreateTag = function () {
        var _this = this;
        this.ConfirmDialogBoxFor = 'AddTag';
        if (this.tagMaster.NewTagName.toString() == "") {
            this._alertinfodiv = true;
            this._alertinfomessage = "Please enter tag.";
            setTimeout(function () {
                this._alertinfodiv = false;
            }.bind(this), 4000);
        }
        else {
            var Ftaglist;
            if (this.listTagMaster) {
                Ftaglist = this.listTagMaster.filter(function (x) { return x.TagName.toLowerCase() == _this.tagMaster.NewTagName.toLowerCase(); });
            }
            if (Ftaglist.length == 0) {
                this.CallConfirmBox();
            }
            else {
                this._IsShowMsg = true;
                this._MsgText = "Tag: " + this.tagMaster.NewTagName + " already exists.";
                setTimeout(function () {
                    this._IsShowMsg = false;
                }.bind(this), 4000);
            }
        }
    };
    TagMasterComponent.prototype.SaveTag = function () {
        var _this = this;
        this.ClosePopUpConfirmBox();
        //==============================
        this.tagMaster.TagMasterID = '00000000-0000-0000-0000-000000000000';
        this.tagMaster.AnalysisID = this.ScenarioId;
        this.tagMaster.TagName = this.tagMaster.NewTagName;
        this.tagMaster.TagDesc = this.tagMaster.NewTagDesc;
        //this._isRoleSaving = true;
        this.tagMasterService.InsertTagMaster(this.tagMaster).subscribe(function (res) {
            if (res.Succeeded) {
                _this.tagMaster.NewTagName = "";
                _this.tagMaster.NewTagDesc = "";
                //this._isRoleSaving = false;
                //this._ShowSuccessRolemessage = "Tag: " + this.tagMaster.TagName + " saved successfully."
                //this._ShowSuccessmessageRolediv = true;
                //setTimeout(function () {
                //    this._ShowSuccessmessageRolediv = false;
                //}.bind(this), 4000);
                _this._ShowSucessdivMsg = "Tag '" + _this.tagMaster.TagName + "' saved successfully.";
                _this._ShowSucessdiv = true;
                setTimeout(function () {
                    this._ShowSucessdiv = false;
                }.bind(_this), 4000);
                _this.CloseCreateTagPopUp();
                _this.GettagList();
            }
            else {
            }
        });
        //==============================
    };
    TagMasterComponent.prototype.showCreateTagDialog = function () {
        this.tagMaster.NewTagName = "";
        this.tagMaster.NewTagDesc = "";
        this.ConfirmDialogBoxFor = 'AddTag';
        var modalRole = document.getElementById('myModalCreateTag');
        modalRole.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    TagMasterComponent.prototype.CloseCreateTagPopUp = function () {
        var modal = document.getElementById('myModalCreateTag');
        modal.style.display = "none";
    };
    //download from azure
    //DownloadScenario(obj): void {
    //    this._isShowLoader = true;
    //    //this.ScenarioId = window.localStorage.getItem("scenarioid");
    //    this.ScenarioName = obj.AnalysisName
    //    this._isScenarioDownloading = true;
    //    this.tagMaster.TagMasterID = obj.TagMasterID;
    //    this.tagMaster.AnalysisID = obj.AnalysisID; //this.ScenarioId;
    //    this.tagMaster.TagName = obj.TagName;
    //    this.tagMaster.TagFileName = obj.TagFileName;
    //    this.tagMaster.NewTagFileName = obj.NewTagFileName;
    //    if (obj.TagFileName == null || obj.TagFileName == undefined || obj.TagFileName == '') {
    //        this.tagMasterService.uploadNoteCashflowsExportDataFromTransactionCloseToAzure(this.tagMaster).subscribe(res => {
    //            if (res.Succeeded) {
    //                //setTimeout(function () {
    //                //    this._isScenarioDownloading = false;
    //                //}.bind(this), 100);
    //                //this.downloadFile(res.dttagWiseCashflow);
    //                //this._isShowLoader = false;
    //                obj.TagFileName = obj.NewTagFileName
    //                this.DownloadTagFile(obj.NewTagFileName, obj.NewTagFileName, 'AzureBlob', '');
    //            }
    //            else {
    //                // this._dvEmptynoteperiodiccalcMsg = true;
    //            }
    //            error => {
    //                this._isShowLoader = false;
    //            }
    //        });
    //    }
    //    else
    //    {
    //        this.DownloadTagFile(obj.TagFileName, obj.TagFileName, 'AzureBlob', '');
    //    } 
    //}
    //normal download from db
    TagMasterComponent.prototype.DownloadScenario = function (obj) {
        var _this = this;
        this._isShowLoader = true;
        //this.ScenarioId = window.localStorage.getItem("scenarioid");
        this.ScenarioName = obj.AnalysisName;
        this._isScenarioDownloading = true;
        this.tagMaster.TagMasterID = obj.TagMasterID;
        this.tagMaster.AnalysisID = obj.AnalysisID; //this.ScenarioId;
        this.tagMaster.TagName = obj.TagName;
        this.tagMasterService.getNoteCashflowsExportDataFromTransactionClose(this.tagMaster).subscribe(function (res) {
            if (res.Succeeded) {
                setTimeout(function () {
                    this._isScenarioDownloading = false;
                }.bind(_this), 100);
                _this.downloadFile(res.dttagWiseCashflow);
                _this._isShowLoader = false;
            }
            else {
                // this._dvEmptynoteperiodiccalcMsg = true;
            }
            (function (error) {
                _this._isShowLoader = false;
            });
        });
    };
    TagMasterComponent.prototype.downloadFile = function (objArray) {
        this.user = JSON.parse(localStorage.getItem('user'));
        var data = this.ConvertToCSV(objArray);
        var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '-');
        var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '-');
        //var fileName = "Cashflow_" + this.tagMaster.TagName + "_" + this.ScenarioName + "_" + displayDate + "_" + displayTime + "_" + this.user.Login + ".csv";
        var fileName = this.tagMaster.TagName + "_" + this.ScenarioName + "_Cashflow_" + displayDate + "_" + displayTime + ".csv";
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
    TagMasterComponent.prototype.ConvertToCSV = function (objArray) {
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
    TagMasterComponent.prototype.ClosePopUpConfirmBox = function () {
        this.ConfirmDialogBoxFor = "";
        var modal = document.getElementById('customdialogbox');
        modal.style.display = "none";
    };
    TagMasterComponent.prototype.changeScenario = function (value) {
        this.ScenarioId = value;
    };
    TagMasterComponent.prototype.DownloadTagFile = function (filename, originalfilename, storagetype, documentStorageID) {
        var _this = this;
        this._isShowLoader = true;
        documentStorageID = documentStorageID === undefined ? '' : documentStorageID;
        var ID = '';
        if (storagetype == 'Box')
            ID = documentStorageID;
        else if (storagetype == 'AzureBlob')
            ID = filename;
        this.fileUploadService.downloadObjectDocumentByStorageType(ID, storagetype)
            .subscribe(function (fileData) {
            var b = new Blob([fileData]);
            //var url = window.URL.createObjectURL(b);
            //window.open(url);
            var dwldLink = document.createElement("a");
            var url = URL.createObjectURL(b);
            var isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
            if (isSafariBrowser) { //if Safari open in new window to save file with random filename.
                dwldLink.setAttribute("target", "_blank");
            }
            dwldLink.setAttribute("href", url);
            dwldLink.setAttribute("download", originalfilename);
            dwldLink.style.visibility = "hidden";
            document.body.appendChild(dwldLink);
            dwldLink.click();
            document.body.removeChild(dwldLink);
            _this._isShowLoader = false;
        }, function (error) {
            //  alert('Something went wrong');
            _this._isShowLoader = false;
        });
    };
    var _a, _b;
    __decorate([
        (0, core_1.ViewChild)('flexTagMaster'),
        __metadata("design:type", typeof (_a = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _a : Object)
    ], TagMasterComponent.prototype, "flex", void 0);
    TagMasterComponent = __decorate([
        (0, core_1.Component)({
            selector: "tagmaster",
            templateUrl: "app/components/TagMaster.html?v=" + $.getVersion(),
            providers: [tagMasterService_1.TagMasterService, membershipservice_1.MembershipService, scenarioService_1.scenarioService, fileuploadservice_1.FileUploadService]
        }),
        __metadata("design:paramtypes", [tagMasterService_1.TagMasterService,
            membershipservice_1.MembershipService,
            utilityService_1.UtilityService,
            scenarioService_1.scenarioService,
            fileuploadservice_1.FileUploadService, typeof (_b = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _b : Object])
    ], TagMasterComponent);
    return TagMasterComponent;
}());
exports.TagMasterComponent = TagMasterComponent;
var routes = [
    { path: '', component: TagMasterComponent }
];
var TagMasterModule = /** @class */ (function () {
    function TagMasterModule() {
    }
    TagMasterModule = __decorate([
        (0, core_2.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_chart_1.WjChartModule, wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule],
            declarations: [TagMasterComponent]
        })
    ], TagMasterModule);
    return TagMasterModule;
}());
exports.TagMasterModule = TagMasterModule;
//# sourceMappingURL=tagMaster.component.js.map