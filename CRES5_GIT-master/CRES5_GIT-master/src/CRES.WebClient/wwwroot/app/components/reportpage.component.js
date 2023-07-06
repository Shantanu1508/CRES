"use strict";
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
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
exports.ReportModule = exports.ReportpageComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var notificationService_1 = require("../core/services/notificationService");
var reportservice_1 = require("./../core/services/reportservice");
var utilityService_1 = require("../core/services/utilityService");
var paginated_1 = require("../core/common/paginated");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wjcGrid = require("wijmo/wijmo.grid");
var wijmo_angular2_core_1 = require("wijmo/wijmo.angular2.core");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var reportFile_1 = require("../core/domain/reportFile");
var wijmo_angular2_input_1 = require("wijmo/wijmo.angular2.input");
var ReportpageComponent = /** @class */ (function (_super) {
    __extends(ReportpageComponent, _super);
    function ReportpageComponent(_router, reportService, utilityService, notificationService) {
        var _this = _super.call(this, 50, 1, 0) || this;
        _this._router = _router;
        _this.reportService = reportService;
        _this.utilityService = utilityService;
        _this.notificationService = notificationService;
        _this._isNoteListFetching = false;
        _this._dvEmptyReportMsg = false;
        _this._Showmessagediv = false;
        _this._ShowmessagedivMsg = '';
        _this._dvEmptyNoteSearchMsg = false;
        _this.powerbistatus_onmsg = "Turn off Power BI Service";
        _this.powerbistatus_offmsg = "Turn on Power BI Service";
        _this.turnonmsg = "Power BI Service currently turned off.You can turn on the service by clicking the link ‘Turn on Power BI Service’ on this page.It will take couple of minutes to start the service.";
        _this.turnoffmsg = "Power BI Service currently turned on. You can trun off the service by clicking the link ‘Turn off Power BI Service’ on this page.";
        _this.initialfetchingmsg = "We are fetching the current status of Power BI Service.";
        _this.submittedreqonmsg = "Request to turn on the Service Submitted Successfully.";
        _this.submittedreqoffmsg = "Request to turn off the Service Submitted Successfully.";
        _this._fetchingstatus = false;
        _this._aftersubmitrequest = false;
        _this._userrolecheck = false;
        _this._otheruserscheck = false;
        _this._checkstatusofuserrole = false;
        _this._ispowerbistatus = false;
        //acore reporting
        _this._reportFileGUID = "";
        _this._dvInValidJson = false;
        _this._dvInValidJsonMsg = '';
        _this._attributeValue = "";
        _this._ShowmessagedivError = false;
        _this._ShowmessagedivErrorMsg = '';
        _this.utilityService.setPageTitle("M61-Reports");
        _this._user = JSON.parse(localStorage.getItem('user'));
        _this.getReports();
        _this.GetCRESPowerBIEmbeddedStatus();
        return _this;
        //this.powerbistatus_off = "Turn on Power BI Service";  //Red
        // this.turnonmsg = "Power BI Service currently turned off.You can turn on the service by clicking the button ‘Turn on Power BI Service’ on this page.It will take couple of minutes to start the service.";
    }
    //=======================Start Getwarehouse(Refresh Warehouse)====================================//
    ReportpageComponent.prototype.warehouseStatus = function (btnname) {
        var _this = this;
        if (btnname === void 0) { btnname = "Refresh Data Warehouse"; }
        this.reportService.GetwarehouseStatus(btnname).subscribe(function (res) {
            if (res.Succeeded) {
                if (res.Status2 == "Process Running") {
                    /* alert("alert1");*/
                    _this.Status4 = res.Status2;
                    _this.BatchEndTime4 = '';
                }
                else if (res.Status2 == "Process InComplete") {
                    _this.Status4 = res.Status2 + '\r \n Last Updated ';
                    _this.BatchEndTime4 = res.BatchEndTime;
                    // this.BatchEndTime4 = this.convertDateToBindableWithTime(res.BatchEndTime);
                }
                else {
                    /* alert("alert2");*/
                    _this.Status4 = res.Status2 + '\r \n Last Updated ';
                    _this.BatchEndTime4 = res.BatchEndTime;
                    // this.BatchEndTime4 =this.convertDateToBindableWithTime(res.BatchEndTime);
                }
            }
        });
    };
    ReportpageComponent.prototype.showbackshopStatus = function (btnname) {
        var _this = this;
        if (btnname === void 0) { btnname = "Refresh Backshop Data"; }
        this.reportService.GetwarehouseStatus(btnname).subscribe(function (res) {
            if (res.Succeeded) {
                if (res.Status2 == "Process Running") {
                    _this.Status1 = res.Status2 + ' ';
                    _this.BatchEndTime1 = '';
                }
                else if (res.Status2 == "Process InComplete") {
                    _this.Status1 = res.Status2 + '\r \n Last Updated ';
                    _this.BatchEndTime1 = res.BatchEndTime;
                    _this.BatchEndTime1 = _this.convertDateToBindableWithTime(res.BatchEndTime);
                }
                else {
                    _this.Status1 = res.Status2 + '\r \n Last Updated ';
                    _this.BatchEndTime1 = res.BatchEndTime;
                    _this.BatchEndTime1 = _this.convertDateToBindableWithTime(res.BatchEndTime);
                }
            }
        });
    };
    ReportpageComponent.prototype.showentityStatus = function (btnname) {
        var _this = this;
        if (btnname === void 0) { btnname = "Refresh Entity Data"; }
        this.reportService.GetwarehouseStatus(btnname).subscribe(function (res) {
            if (res.Succeeded) {
                if (res.Status2 == "Process Running") {
                    _this.Status3 = res.Status2;
                    _this.BatchEndTime3 = '';
                }
                else if (res.Status2 == "Process InComplete") {
                    _this.Status3 = res.Status2 + '\r \n Last Updated ';
                    _this.BatchEndTime3 = res.BatchEndTime;
                    _this.BatchEndTime3 = _this.convertDateToBindableWithTime(res.BatchEndTime);
                }
                else {
                    _this.Status3 = res.Status2 + '\r \n Last Updated ';
                    _this.BatchEndTime3 = res.BatchEndTime;
                    _this.BatchEndTime3 = _this.convertDateToBindableWithTime(res.BatchEndTime);
                }
            }
        });
    };
    ReportpageComponent.prototype.ngOnInit = function () {
        jQuery.getScript('js/powerbi/angular.js');
        jQuery.getScript('js/powerbi/powerbi.js');
        jQuery.getScript('js/powerbi/angular-powerbi.js');
    };
    ReportpageComponent.prototype.getReports = function () {
        var _this = this;
        this._isNoteListFetching = true;
        this.reportService.GetAllReport(this._pageIndex, this._pageSize).subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.lstReport;
                _this._totalCount = res.TotalCount;
                if (_this._pageIndex == 1) {
                    _this.lstReport = data;
                    //remove first cell selection
                    _this.flex.selectionMode = wjcGrid.SelectionMode.None;
                    if (res.TotalCount == 0) {
                        _this._dvEmptyNoteSearchMsg = true;
                        //setTimeout(() => {
                        //    this._dvEmptyNoteSearchMsg = false;
                        //}, 2000);
                    }
                    //this.getAllAcoreRepots();
                }
                else {
                    //data.forEach((obj, i) => { // FETCH ALL DATA AND PUSH IN FLEX GRID!!!
                    //    this.flex.rows.push(new wjcGrid.Row(obj));
                    //});
                    _this.lstReport.concat(data);
                }
                _this._isNoteListFetching = false;
            }
            else {
                //alert('else');
                //debugger;
                _this._isNoteListFetching = false;
                _this.utilityService.navigateToSignIn();
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    ReportpageComponent.prototype.AssignId = function (_powerbiId) {
        localStorage.setItem('powerbiReportId', JSON.stringify(_powerbiId));
        // alert('done');
    };
    ReportpageComponent.prototype.RefreshReport = function () {
        var _this = this;
        this._isNoteListFetching = true;
        this.reportService.GetimportReport().subscribe(function (res) {
            if (res.Succeeded) {
                _this._Showmessagediv = true;
                _this._isNoteListFetching = false;
                _this._ShowmessagedivMsg = 'Data Warehouse updated Successfully.';
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                    this._Showmessagediv = false;
                    this._ShowmessagedivMsg = '';
                }.bind(_this), 5000);
            }
            else {
                _this._isNoteListFetching = false;
                _this._router.navigate(['login']);
            }
        });
    };
    ReportpageComponent.prototype.convertDateToBindable = function (date) {
        if (date) {
            var dateObj = new Date(date);
            return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear();
        }
    };
    ReportpageComponent.prototype.getTwoDigitString = function (number) {
        if (number.toString().length === 1)
            return "0" + number;
        return number;
    };
    ReportpageComponent.prototype.convertDateToBindableWithTime = function (date) {
        var dateObj = new Date(date);
        return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear() + " " + dateObj.getHours() + ":" + dateObj.getMinutes() + ":" + dateObj.getSeconds();
    };
    ReportpageComponent.prototype.DownloadNoteDataTape = function () {
        var _this = this;
        this._isNoteListFetching = true;
        this.reportService.DownloadNoteDataTape('0').subscribe(function (res) {
            if (res.Succeeded) {
                _this._isNoteListFetching = false;
                _this.downloadFile(res.lstDownloadNoteDataTape);
            }
            else {
                _this._isNoteListFetching = false;
            }
            (function (error) { return console.error('Error: ' + error); });
        });
    };
    ReportpageComponent.prototype.downloadFile = function (objArray) {
        var data = this.ConvertToCSV(objArray);
        var displayDate = new Date().toLocaleDateString("en-US");
        var fileName = "Download Data Tape-" + displayDate + ".csv";
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
    ReportpageComponent.prototype.ConvertToCSV = function (objArray) {
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
    ReportpageComponent.prototype.GetCRESPowerBIEmbeddedStatus = function () {
        var _this = this;
        var userrole = this._user.RoleName;
        this._otheruserscheck = true;
        this.reportService.CheckPowerBIStatusOnLoad().subscribe(function (res) {
            _this._fetchingstatus = true;
            var data = res.Status;
            if (res.Succeeded) {
                if (userrole == "Super Admin" && data == "Resuming" || userrole == "Super Admin" && data == "Succeeded") {
                    _this._userrolecheck = true;
                    _this._aftersubmitrequest = false;
                    _this._checkstatusofuserrole = false;
                    _this._ispowerbistatus = true;
                    _this.powerbistatus_onmsg; //Green
                    _this.turnoffmsg;
                    clearTimeout(timeInterval);
                }
                else if (userrole != "Super Admin" && data == "Resuming" || userrole != "Super Admin" && data == "Succeeded") {
                    _this._checkstatusofuserrole = true;
                }
                else if (data == "Paused" || data == "Pausing") {
                    _this._ispowerbistatus = false;
                    _this._checkstatusofuserrole = false;
                    _this._userrolecheck = false;
                    var timeInterval = setTimeout(function () {
                        this._aftersubmitrequest = false;
                        this.GetCRESPowerBIEmbeddedStatus();
                        this.powerbistatus_offmsg; //Red
                        this.turnonmsg;
                    }.bind(_this), 100050);
                }
                else if (data == "") {
                    _this.GetCRESPowerBIEmbeddedStatus();
                }
            }
        });
    };
    ReportpageComponent.prototype.updateCRESPowerBIEmbeddedStatus = function () {
        var _this = this;
        this._isNoteListFetching = true;
        this._aftersubmitrequest = true;
        var userrole = this._user.RoleName;
        this._otheruserscheck = true;
        this._fetchingstatus = true;
        this.reportService.updatePowerBIStatusOnLoad().subscribe(function (res) {
            var data = res.Status;
            if (res.Succeeded) {
                if (userrole == "Super Admin" && data == "Resuming" || userrole == "Super Admin" && data == "Succeeded") {
                    _this._checkstatusofuserrole = false;
                    _this._userrolecheck = true;
                    _this._aftersubmitrequest = false;
                    _this._ispowerbistatus = true;
                    _this.powerbistatus_onmsg; //Green
                    _this.turnoffmsg;
                }
                else if (userrole != "Super Admin" && data == "Resuming" || userrole != "Super Admin" && data == "Succeeded") {
                    _this._checkstatusofuserrole = true;
                }
                else if (data == "Paused" || data == "Pausing") {
                    _this._checkstatusofuserrole = false;
                    _this._aftersubmitrequest = false;
                    _this._userrolecheck = false;
                    _this._ispowerbistatus = false;
                    _this.powerbistatus_offmsg; //Red
                }
                else if (data == "") {
                    _this.GetCRESPowerBIEmbeddedStatus();
                }
                _this._isNoteListFetching = false;
            }
        });
    };
    //acore report related methods
    ReportpageComponent.prototype.ShowAttributesDialog = function (attributeValue, reportname) {
        var _this = this;
        this.ReportGuid = attributeValue;
        this.reportInputDate = '';
        var _isallowinput = this.lstReport.filter(function (x) { return x.ReportFileGUID == _this.ReportGuid; })[0];
        if (_isallowinput.IsAllowInput == true) {
            //this.ReportGuid = attributeValue;
            //$("#txtDefaultAttribute").val(reportname);
            $("#spnHeader").text(reportname + ' parameters');
            var modal = document.getElementById('ModalReportFileAttribute');
            modal.style.display = "block";
            $.getScript("/js/jsDrag.js");
        }
        else {
            //this.ReportGuid = attributeValue;
            this.GenearteAndDownloadReport();
        }
    };
    ReportpageComponent.prototype.ClosePopUpReportFileAttribute = function () {
        var modal = document.getElementById('ModalReportFileAttribute');
        $('#txtDefaultAttribute').val('');
        modal.style.display = "none";
    };
    ReportpageComponent.prototype.GenearteAndDownloadReport = function () {
        var errmsg = "";
        var ReportFileGUID = this.ReportGuid;
        var _objreportfile = this.lstReport.filter(function (x) { return x.ReportFileGUID == ReportFileGUID; })[0];
        if (_objreportfile.IsAllowInput == true) {
            if (this.reportInputDate == undefined || this.reportInputDate == null || this.reportInputDate.toString() == "") {
                errmsg = "Please enter date.";
            }
        }
        if (errmsg != "") {
            this.CustomAlert(errmsg);
        }
        else {
            var month = new Date(this.reportInputDate).getMonth() + 1;
            var attributedate = { "Date": month + '/' + new Date(this.reportInputDate).getDate() + '/' + new Date(this.reportInputDate).getFullYear() };
            if (_objreportfile.DefaultAttributes !== undefined && _objreportfile.DefaultAttributes != null && _objreportfile.DefaultAttributes != "") {
                this._reportFileGUID = ReportFileGUID;
                this.ShowAttributesDialog(_objreportfile.DefaultAttributes, _objreportfile.Name);
            }
            else {
                this._reportFileGUID = "";
                if (_objreportfile.IsAllowInput == true) {
                    this._attributeValue = JSON.stringify(attributedate);
                }
                else {
                    this._attributeValue = null;
                }
                this.ClosePopUpReportFileAttribute();
                this.generateReport(_objreportfile.ReportFileGUID);
            }
        }
    };
    ReportpageComponent.prototype.GenearteAndDownloadReportWithParam = function () {
        if (!this.isValidJson($("#txtDefaultAttribute").val())) {
            this._dvInValidJson = true;
            this._dvInValidJsonMsg = "Invalid json format";
            setTimeout(function () {
                this._dvInValidJson = false;
                this._dvInValidJsonMsg = "";
                //   console.log(this._ShowmessagedivWar);
            }.bind(this), 3000);
            return false;
        }
        else {
            this._attributeValue = $("#txtDefaultAttribute").val();
            this.ClosePopUpReportFileAttribute();
            this.generateReport(this._reportFileGUID);
        }
    };
    ReportpageComponent.prototype.isValidJson = function (jsonstring) {
        try {
            JSON.parse(jsonstring);
        }
        catch (e) {
            return false;
        }
        return true;
    };
    ReportpageComponent.prototype.generateReport = function (ReportFileGUID) {
        var _this = this;
        var _objreportfile = this.lstReport.filter(function (x) { return x.ReportFileGUID == ReportFileGUID; })[0];
        var _reportFile = new reportFile_1.reportFile();
        _reportFile.ReportFileGUID = ReportFileGUID;
        _reportFile.IsDownloadRequire = false;
        _reportFile.DefaultAttributes = this._attributeValue;
        this._isNoteListFetching = true;
        this.reportService.GenerateAccountingReport(_reportFile)
            .subscribe(function (res) {
            _this._isNoteListFetching = false;
            if (_reportFile.IsDownloadRequire == false) {
                if (res.Succeeded) {
                    //this._isNoteListFetching = false;
                    var replog = res.ReportFileLog;
                    _this.DownloadDocument(replog.FileName, replog.OriginalFileName, replog.StorageTypeID, replog.StorageLocation, res.DocumentStorageID);
                    _this._Showmessagediv = true;
                    _this._ShowmessagedivMsg = "File generated successfully";
                    setTimeout(function () {
                        this._Showmessagediv = false;
                        this._ShowmessagedivMsg = "";
                        //   console.log(this._ShowmessagedivWar);
                    }.bind(_this), 5000);
                }
                else {
                    _this._ShowmessagedivError = true;
                    _this._ShowmessagedivErrorMsg = "Error in file generation,Please try after some time.";
                    setTimeout(function () {
                        this._ShowmessagedivError = false;
                        this._ShowmessagedivErrorMsg = "";
                        //   console.log(this._ShowmessagedivWar);
                    }.bind(_this), 5000);
                }
            }
            else {
                var b = new Blob([res]);
                //var url = window.URL.createObjectURL(b);
                //window.open(url);
                var dwldLink = document.createElement("a");
                var url = URL.createObjectURL(b);
                var isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
                if (isSafariBrowser) { //if Safari open in new window to save file with random filename.
                    dwldLink.setAttribute("target", "_blank");
                }
                dwldLink.setAttribute("href", url);
                dwldLink.setAttribute("download", _objreportfile.Name + '.' + _objreportfile.ReportFileFormat);
                dwldLink.style.visibility = "hidden";
                document.body.appendChild(dwldLink);
                dwldLink.click();
                document.body.removeChild(dwldLink);
                //this._isNoteListFetching = false;
                _this._Showmessagediv = true;
                _this._ShowmessagedivMsg = "File generated successfully";
                setTimeout(function () {
                    this._Showmessagediv = false;
                    this._ShowmessagedivMsg = "";
                }.bind(_this), 5000);
            }
        }, function (error) {
            //alert('Something went wrong');
            _this._isNoteListFetching = false;
            ;
        });
    };
    ReportpageComponent.prototype.DownloadDocument = function (filename, originalfilename, storagetypeID, storageLocation, documentStorageID) {
        var _this = this;
        documentStorageID = documentStorageID === undefined ? '' : documentStorageID;
        //var _reportfilelog = new reportFileLog();
        //_reportfilelog.FileName = filename;
        //_reportfilelog.StorageLocation = storageLocation;
        //_reportfilelog.StorageTypeID = storagetypeID;
        //if (_reportfilelog.StorageTypeID == "459")
        //    _reportfilelog.FileName = documentStorageID;
        var ID = filename;
        if (storagetypeID == "459")
            ID = documentStorageID;
        this.reportService.downloadObjectDocumentByStorageTypeAndLocation(ID, storagetypeID, storageLocation)
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
            _this._isNoteListFetching = false;
        }, function (error) {
            alert('Something went wrong');
            _this._isNoteListFetching = false;
        });
    };
    //
    ReportpageComponent.prototype.RefreshBSUnderwiting = function () {
        var _this = this;
        this._isNoteListFetching = true;
        this.reportService.GetRefreshBSUnderwriting().subscribe(function (res) {
            if (res.Succeeded) {
                _this._Showmessagediv = true;
                _this._isNoteListFetching = false;
                _this._ShowmessagedivMsg = res.Message;
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                    this._Showmessagediv = false;
                    this._ShowmessagedivMsg = '';
                }.bind(_this), 5000);
            }
            else {
                _this._isNoteListFetching = false;
                _this._router.navigate(['login']);
            }
        });
    };
    ReportpageComponent.prototype.RefreshEntityDataToDW = function () {
        var _this = this;
        this._isNoteListFetching = true;
        this.reportService.getrefreshentitydatatodw().subscribe(function (res) {
            if (res.Succeeded) {
                _this._Showmessagediv = true;
                _this._isNoteListFetching = false;
                _this._ShowmessagedivMsg = res.Message;
                setTimeout(function () {
                    this._ShowSuccessmessagediv = false;
                    this._Showmessagediv = false;
                    this._ShowmessagedivMsg = '';
                }.bind(_this), 5000);
            }
            else {
                _this._isNoteListFetching = false;
                _this._router.navigate(['login']);
            }
        });
    };
    ReportpageComponent.prototype.CustomAlert = function (dialog) {
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
    };
    ReportpageComponent.prototype.ok = function () {
        document.getElementById('dialogbox').style.display = "none";
        document.getElementById('dialogoverlay').style.display = "none";
    };
    __decorate([
        core_1.ViewChild('flex'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], ReportpageComponent.prototype, "flex", void 0);
    ReportpageComponent = __decorate([
        core_1.Component({
            selector: "reportpage",
            templateUrl: "app/components/reportpage.html",
            providers: [reportservice_1.ReportService, notificationService_1.NotificationService]
        }),
        __metadata("design:paramtypes", [router_1.Router,
            reportservice_1.ReportService,
            utilityService_1.UtilityService,
            notificationService_1.NotificationService])
    ], ReportpageComponent);
    return ReportpageComponent;
}(paginated_1.Paginated));
exports.ReportpageComponent = ReportpageComponent;
var routes = [
    { path: '', component: ReportpageComponent }
];
var ReportModule = /** @class */ (function () {
    function ReportModule() {
    }
    ReportModule = __decorate([
        core_2.NgModule({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_core_1.WjCoreModule, wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule, wijmo_angular2_input_1.WjInputModule],
            declarations: [ReportpageComponent]
        })
    ], ReportModule);
    return ReportModule;
}());
exports.ReportModule = ReportModule;
//==============================================Report==================================================================//
//# sourceMappingURL=reportpage.component.js.map