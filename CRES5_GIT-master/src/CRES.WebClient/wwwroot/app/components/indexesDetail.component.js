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
exports.IndexesDetailModule = exports.IndexesDetailComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var indexes_1 = require("../core/domain/indexes");
var indexType_1 = require("../core/domain/indexType");
var indexesService_1 = require("../core/services/indexesService");
var notificationService_1 = require("../core/services/notificationService");
var utilityService_1 = require("../core/services/utilityService");
var paginated_1 = require("../core/common/paginated");
var wjcCore = require("wijmo/wijmo");
var wjcGrid = require("wijmo/wijmo.grid");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wijmo_angular2_core_1 = require("wijmo/wijmo.angular2.core");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var functionService_1 = require("../core/services/functionService");
var IndexesDetailComponent = /** @class */ (function (_super) {
    __extends(IndexesDetailComponent, _super);
    function IndexesDetailComponent(activatedRoute, _router, indexesService, utilityService, notificationService, functionServiceSrv) {
        var _this = _super.call(this, 30, 0, 0) || this;
        _this.activatedRoute = activatedRoute;
        _this._router = _router;
        _this.indexesService = indexesService;
        _this.utilityService = utilityService;
        _this.notificationService = notificationService;
        _this.functionServiceSrv = functionServiceSrv;
        _this.indexupdatedRowNo = [];
        _this.indexrowsToUpdate = [];
        _this._ShowmessagedivWar = false;
        _this.TotalCount = 0;
        _this.Message = '';
        _this._Showmessagediv = false;
        _this._isIndexesDetailFetching = true;
        _this._isScrolled = true;
        _this._indexessearch = new indexes_1.IndexesSearch();
        _this._isIndexLoad = true;
        _this._IndexFromSelected = true;
        _this._isShowImportIndexes = false;
        _this.activatedRoute.params.forEach(function (params) {
            if (params['id'] !== undefined) {
                _this.indexId = '0';
                var indexesGUID = params['id'];
                _this._indexesdc = new indexes_1.Indexes(indexesGUID);
                _this.IndexesMasterGuid = indexesGUID;
                // this.GetIndexesMasterDetailByID(this._indexesdc);
                if (_this.IndexesMasterGuid != '00000000-0000-0000-0000-000000000000') {
                    _this.GetIndexesMasterDetailByID(_this._indexesdc);
                }
                else {
                    _this.GetIndexsListByIndexesMasterGuid(_this.IndexesMasterGuid);
                }
                _this.GetAllIndexes();
            }
        });
        _this.utilityService.setPageTitle("M61 – Index Details");
        return _this;
    }
    IndexesDetailComponent.prototype.ngAfterViewInit = function () {
        // commit row changes when scrolling the grid
        var _this = this;
        this.flexIndexesDetail.scrollPositionChanged.addHandler(function () {
            var myDiv = $('#flexIndexesDetail').find('div[wj-part="root"]');
            if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
                if (_this.flexIndexesDetail.rows.length < _this.TotalCount) {
                    _this._isIndexesDetailFetching = true;
                    _this._indexessearch.IndexesMasterGuid = _this.IndexesMasterGuid;
                    _this._indexessearch.Fromdate = _this._lastDate;
                    _this._indexessearch.Todate = null;
                    _this.GetIndexBetweenDates(_this._indexessearch, "after");
                }
            }
            else if (myDiv.scrollTop() == 0) {
                if (_this.flexIndexesDetail.rows.length < _this.TotalCount) {
                    _this._indexessearch.IndexesMasterGuid = _this.IndexesMasterGuid;
                    _this._isIndexesDetailFetching = true;
                    _this._indexessearch.Fromdate = null;
                    _this._indexessearch.Todate = _this._FirstDate;
                    _this.GetIndexBetweenDates(_this._indexessearch, "before");
                }
            }
        });
    };
    IndexesDetailComponent.prototype.GetIndexBetweenDates = function (indexessearch, append) {
        var _this = this;
        this.indexesService.GetIndexListByDate(indexessearch).subscribe(function (res) {
            if (res.Succeeded) {
                var tempdata = _this.indexesDetaildata;
                _this.indexesindexdata = res.dtIndexType;
                _this._listlength = _this.indexesindexdata.length;
                if (_this.indexesindexdata.length > 0) {
                    for (var i = 0; i < _this.indexesindexdata.length; i++) {
                        if (_this.indexesindexdata[i].Date != null) {
                            if (_this.indexesindexdata[i].Date == "1900-01-01T00:00:00") {
                                _this.indexesindexdata[i].Date = "";
                            }
                            else {
                                _this.indexesindexdata[i].Date = new Date(_this.indexesindexdata[i].Date.toString());
                            }
                        }
                    }
                    if (append == "before") {
                        // if (this._FirstDate > this.scenarioindexdata[0].Date) { this._FirstDate = this.scenarioindexdata[0].Date; }
                        _this._FirstDate = _this.indexesindexdata[0].Date;
                        _this.indexesDetaildata = _this.indexesindexdata.concat(tempdata);
                        _this.cvIndexesDetaildata = new wjcCore.CollectionView(_this.indexesDetaildata);
                        _this.cvIndexesDetaildata.trackChanges = true;
                        _this._isIndexesDetailFetching = false;
                        var myDiv = $('#flexIndexesDetail').find('div[wj-part="root"]');
                        myDiv.scrollTop(100);
                    }
                    else {
                        if (_this._lastDate < _this.indexesindexdata[_this._listlength - 1].Date) {
                            _this._lastDate = _this.indexesindexdata[_this._listlength - 1].Date;
                        }
                        if (_this._lastDate != null) {
                            _this._lastDate = _this.createDateAsUTC(_this._lastDate);
                        }
                        _this.indexesDetaildata = _this.indexesDetaildata.concat(_this.indexesindexdata);
                        _this.cvIndexesDetaildata = new wjcCore.CollectionView(_this.indexesDetaildata);
                        _this.cvIndexesDetaildata.trackChanges = true;
                        var myDiv = $('#flexIndexesDetail').find('div[wj-part="root"]');
                    }
                    var delrow = _this.flexIndexesDetail.rows[30];
                    _this.flexIndexesDetail.rows.remove(delrow);
                    // this.scenarioDetaildata = this.scenarioindexdata;
                    //this.scenarioindexdata.forEach((obj, i) => {
                    //    this.flexScenarioDetail.rows.push(new wjcGrid.Row(obj));
                    //});
                    _this._isIndexesDetailFetching = false;
                }
                else {
                    //this.scenarioDetaildata = [];
                    //this.cvScenarioDetaildata = new wjcCore.CollectionView(this.scenarioDetaildata);
                    //this.cvScenarioDetaildata.trackChanges = true;
                    _this._isIndexesDetailFetching = false;
                }
            }
        });
    };
    IndexesDetailComponent.prototype.downloadIndexsExportData = function () {
        var _this = this;
        //var _note: Note;
        this._isIndexesDetailFetching = true;
        this._indexessearch.IndexesMasterGuid = this.IndexesMasterGuid;
        this.indexesService.GetIndexesExportDataByIndexesMasterId(this._indexessearch).subscribe(function (res) {
            if (res.Succeeded) {
                setTimeout(function () {
                    this._isIndexesDetailFetching = false;
                }.bind(_this), 100);
                _this.downloadFile(res.dtIndexType);
            }
            else {
                // this._dvEmptynoteperiodiccalcMsg = true;
            }
            (function (error) { return console.error('Error: ' + error); });
        });
    };
    IndexesDetailComponent.prototype.GetIndexesMasterDetailByID = function (_objIndexes) {
        var _this = this;
        try {
            this._isIndexesDetailFetching = true;
            var _indexesGUID = _objIndexes.IndexesMasterGuid;
            this.indexesService.GetIndexesDetailByIndexesMasterGuid(_objIndexes).subscribe(function (res) {
                if (res.Succeeded) {
                    if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                        _this._indexesdc = res.indexesMaster;
                        _this.GetIndexsListByIndexesMasterGuid(_indexesGUID);
                    }
                    else {
                        localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                        localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));
                        _this.utilityService.navigateUnauthorize();
                    }
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
        }
    };
    IndexesDetailComponent.prototype.DiscardChanges = function () {
        this._router.navigate(['indexes']);
    };
    IndexesDetailComponent.prototype.GetIndexsListByIndexesMasterGuid = function (_indexesGUID) {
        var _this = this;
        this.indexesService.GetIndexListByIndexesMasterID(_indexesGUID, this._pageIndex, this._pageSize).subscribe(function (res) {
            if (res.Succeeded) {
                _this.TotalCount = res.TotalCount;
                if (_this.TotalCount == 0) {
                    _this._isIndexLoad = false;
                }
                _this._isScrolled = false;
                _this.indexesindexdata = res.dtIndexType;
                _this._isScrolled = true;
                var locale = "en-US";
                var options = { year: "numeric", month: "numeric", day: "numeric" };
                // for (var i = 0; i < this.TotalCount; i++) {
                for (var i = 0; i < _this.indexesindexdata.length; i++) {
                    if (_this.indexesindexdata[i].Date != null) {
                        if (_this.indexesindexdata[i].Date == "1900-01-01T00:00:00") {
                            _this.indexesindexdata[i].Date = "";
                        }
                        else {
                            _this.indexesindexdata[i].Date = new Date(_this.indexesindexdata[i].Date.toString());
                        }
                    }
                    if (i == _this.indexesindexdata.length - 1) {
                        setTimeout(function () {
                            this._isIndexesDetailFetching = false;
                        }.bind(_this), 2000);
                    }
                }
                _this.indexesDetaildata = _this.indexesindexdata;
                if (_this.indexesindexdata.length > 0) {
                    _this._FirstDate = _this.indexesindexdata[0].Date;
                    _this._lastDate = _this.indexesindexdata[(_this.indexesindexdata.length) - 1].Date;
                    if (_this._lastDate != null) {
                        _this._lastDate = _this.createDateAsUTC(_this._lastDate);
                    }
                    _this.cvIndexesDetaildata = new wjcCore.CollectionView(_this.indexesDetaildata);
                    _this.cvIndexesDetaildata.trackChanges = true;
                }
                else {
                    _this.indexesDetaildata = [];
                    _this.cvIndexesDetaildata = new wjcCore.CollectionView(_this.indexesDetaildata);
                    _this.cvIndexesDetaildata.trackChanges = true;
                }
                var myDiv = $('#flexIndexesDetail').find('div[wj-part="root"]');
                myDiv.scrollTop(200);
                if (_this.indexesindexdata.length == 0) {
                    _this._isIndexesDetailFetching = false;
                }
                _this._isIndexesDetailFetching = false;
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    IndexesDetailComponent.prototype.Addcolumn = function (header, binding) {
        try {
            this.columns.push({ "header": header, "binding": binding, "format": 'p5' });
        }
        catch (err) { }
    };
    IndexesDetailComponent.prototype.ValidateIndexesAndSave = function (Actionstatus) {
        var _this = this;
        try {
            this._isIndexesDetailFetching = true;
            this._indexesdc.IndexesMasterGuid = this.IndexesMasterGuid;
            //this._indexesdc.ActionStatus = Actionstatus;
            if (this._indexesdc.IndexesName != "" && this._indexesdc.IndexesName != null) {
                this.indexesService.CheckDuplicateIndexesName(this._indexesdc).subscribe(function (res) {
                    if (res.Succeeded) {
                        if (res.Message != "Duplicate") {
                            _this.InsertUpdateIndexesMasterdetail();
                        }
                        else {
                            _this._ShowmessagedivWar = true;
                            _this._ShowmessagedivMsgWar = "Index with same name already exits, please use different index name.";
                            _this._isIndexesDetailFetching = false;
                            setTimeout(function () {
                                _this._ShowmessagedivWar = false;
                                _this._ShowmessagedivMsgWar = "";
                            }, 3000);
                        }
                    }
                    else {
                        _this._router.navigate(['login']);
                    }
                });
            }
            else {
                this._ShowmessagedivWar = true;
                this._ShowmessagedivMsgWar = "Please fill Index name.";
                this._isIndexesDetailFetching = false;
                setTimeout(function () {
                    _this._ShowmessagedivWar = false;
                    _this._ShowmessagedivMsgWar = "";
                }, 3000);
            }
        }
        catch (err) {
        }
    };
    IndexesDetailComponent.prototype.InsertUpdateIndexesMasterdetail = function () {
        var _this = this;
        try {
            this.indexesService.InsertUpdateIndexesMasterdetail(this._indexesdc).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.IndexesMasterGuid = res.newIndexesMasterGuid;
                    localStorage.setItem('divSucessIndexes', JSON.stringify(true));
                    localStorage.setItem('successmsgindexes', JSON.stringify(res.Message));
                    _this.UpdateIndex(_this.IndexesMasterGuid);
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
        }
    };
    IndexesDetailComponent.prototype.adjustdescrtiptionheight = function () {
        var cont = $("#Description");
        cont[0].style.height = "1px";
        cont[0].style.height = (cont[0].scrollHeight + 20) + "px";
    };
    // index grid saving code
    IndexesDetailComponent.prototype.IndexesDetailselectionChanged = function () {
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
    };
    IndexesDetailComponent.prototype.beginningEdit = function (modulename) {
        switch (modulename) {
            case "IndexesDetail":
                var sel = this.flexIndexesDetail.selection;
                if (this.indexesDetaildata[sel.topRow].Date != null)
                    this.prevDateBeforeEdit = this.indexesDetaildata[sel.topRow].Date;
                break;
        }
    };
    IndexesDetailComponent.prototype.rowEditEnded = function (modulename) {
        switch (modulename) {
            case "IndexesDetail":
                var sel = this.flexIndexesDetail.selection;
                var flag = this.CheckDuplicateDate(sel.topRow);
                //alert('end  - ' + this.prevDateBeforeEdit);
                if (flag == true) {
                    var indformatDate;
                    var locale = "en-US";
                    var options = { year: "numeric", month: "numeric", day: "numeric" };
                    indformatDate = this.indexesDetaildata[sel.topRow].Date;
                    if (indformatDate.toString().indexOf("GMT") == -1)
                        alert("Date - " + indformatDate + " already in list");
                    else
                        alert("Date " + indformatDate.toLocaleDateString(locale, options) + " already in list");
                    this.indexesDetaildata[sel.topRow].Date = this.prevDateBeforeEdit;
                    this.indexesDetaildata[sel.topRow].AnalysisID = this.IndexesMasterGuid;
                }
        }
        this.prevDateBeforeEdit = null;
    };
    IndexesDetailComponent.prototype.CopiedDataValidate = function (modulename) {
        try {
            switch (modulename) {
                case "IndexesDetail":
                    var sel = this.flexIndexesDetail.selection;
                    var rssformatDate;
                    var datearr = '';
                    for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
                        var flag = this.CheckDuplicateDate(tprow); //this.CheckDuplicateDate(this.scenarioDetaildata, tprow);
                        if (flag == true) {
                            var locale = "en-US";
                            var options = { year: "numeric", month: "numeric", day: "numeric" };
                            rssformatDate = this.indexesDetaildata[tprow].Date;
                            // datearr = rssformatDate.toLocaleDateString(locale, options); 
                            datearr = datearr + " , " + rssformatDate.toLocaleDateString(locale, options);
                            this.indexesDetaildata[tprow].Date = '';
                        }
                    }
                    if (datearr != '' && datearr != null) {
                        if (datearr.indexOf("GMT") == -1)
                            this.CustomAlert("Date " + datearr.slice(3) + " already in list");
                        else
                            this.CustomAlert("Date " + datearr.slice(3) + " already in list");
                    }
            }
        }
        catch (err) {
            console.log(err);
        }
    };
    IndexesDetailComponent.prototype.CheckDuplicateDate = function (rwNum) {
        try {
            var i;
            for (i = 0; i < this.indexesDetaildata.length; i++)
                if (rwNum != i && this.indexesDetaildata[rwNum].Date.toString() == this.indexesDetaildata[i].Date.toString())
                    break;
            if (i == this.indexesDetaildata.length)
                return false;
            else
                return true;
        }
        catch (err) {
            console.log(err);
        }
    };
    IndexesDetailComponent.prototype.convertDatetoGMTGrid = function (Data) {
        if (Data) {
            for (var i = 0; i < Data.length; i++) {
                if (this._indextype[i].Date) {
                    this._indextype[i].Date = this.createDateAsUTC(this._indextype[i].Date);
                }
            }
        }
    };
    IndexesDetailComponent.prototype.createDateAsUTC = function (date) {
        if (date) {
            date = new Date(date);
            return new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds()));
        }
        else
            return date;
    };
    IndexesDetailComponent.prototype.UpdateIndex = function (newIndexesMasterGuid) {
        var _this = this;
        debugger;
        if (this.indexesDetaildata == undefined) {
            this._router.navigate(['indexes']);
        }
        this._indextype = new indexType_1.IndexType();
        //if (this.indexupdatedRowNo != null) {
        //    for (var i = 0; i < this.indexupdatedRowNo.length; i++) {
        //        this.scenarioDetaildata[this.indexupdatedRowNo[i]].AnalysisID = newscenarioid;
        //        this.indexrowsToUpdate.push(this.scenarioDetaildata[this.indexupdatedRowNo[i]]);
        //    }
        //    this._indextype = this.indexrowsToUpdate;
        //}
        for (var j = 0; j < this.indexesDetaildata.length; j++) {
            if (Object.keys(this.indexesDetaildata[j]).length > 0) {
                this.indexesDetaildata[j].IndexesMasterGuid = newIndexesMasterGuid;
                for (var i = 0; i < this.cvIndexesDetaildata.itemsAdded.length; i++) {
                    this._indextype = new indexType_1.IndexType();
                    this._indextype = this.cvIndexesDetaildata.itemsAdded[i];
                    if (this.indexesDetaildata[j].Date == this._indextype.Date) {
                        if (!(this._indextype.Date.toString() == "" || this._indextype.Date == null)) {
                            this.indexrowsToUpdate.push(this.indexesDetaildata[j]);
                        }
                    }
                }
                for (var i = 0; i < this.cvIndexesDetaildata.itemsEdited.length; i++) {
                    this._indextype = new indexType_1.IndexType();
                    this._indextype = this.cvIndexesDetaildata.itemsEdited[i];
                    if (this.indexesDetaildata[j].Date == this._indextype.Date) {
                        if (!(this._indextype.Date.toString() == "" || this._indextype.Date == null)) {
                            this.indexrowsToUpdate.push(this.indexesDetaildata[j]);
                        }
                    }
                }
            }
        }
        this._indextype = this.indexrowsToUpdate;
        this.convertDatetoGMTGrid(this._indextype);
        this.indexrowsToUpdate = null;
        this.indexrowsToUpdate = [];
        this.indexupdatedRowNo = null;
        this.indexupdatedRowNo = [];
        this.indexesService.AddUpdateIndexTypeList(this._indextype).subscribe(function (res) {
            if (res.Succeeded) {
                _this._router.navigate(['indexes']);
            }
            else {
                _this._isIndexesDetailFetching = false;
                _this._ShowmessagedivWar = true;
                _this._ShowmessagedivMsgWar = "Error occured while saving.";
                setTimeout(function () {
                    _this._ShowmessagedivWar = false;
                    _this._ShowmessagedivMsgWar = "";
                }, 3000);
            }
        });
    };
    IndexesDetailComponent.prototype.downloadFile = function (objArray) {
        var data = this.ConvertToCSV(objArray);
        var displayDate = new Date().toLocaleDateString("en-US");
        var fileName = this._indexesdc.IndexesName + "-" + displayDate + ".csv";
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
    IndexesDetailComponent.prototype.ConvertToCSV = function (objArray) {
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
    IndexesDetailComponent.prototype.ChangeFolder = function (newvalue) {
        this.indexId = newvalue;
    };
    IndexesDetailComponent.prototype.showDialogImportIndex = function () {
        var _this = this;
        if (this._indexesdc.IndexesName != "" && this._indexesdc.IndexesName != null) {
            var modal = document.getElementById('myModalImportIndex');
            modal.style.display = "block";
            $.getScript("/js/jsDrag.js");
        }
        else {
            this._ShowmessagedivWar = true;
            this._ShowmessagedivMsgWar = "Please fill Index name.";
            this._isIndexesDetailFetching = false;
            setTimeout(function () {
                _this._ShowmessagedivWar = false;
                _this._ShowmessagedivMsgWar = "";
            }, 3000);
        }
    };
    IndexesDetailComponent.prototype.ClosePopUpImportIndex = function () {
        var modal = document.getElementById('myModalImportIndex');
        modal.style.display = "none";
        this.indexId = '0';
    };
    IndexesDetailComponent.prototype.GetAllIndexes = function () {
        var _this = this;
        this.indexesService.GetAllIndexesMaster(1, 100)
            .subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.lstIndexesMaster;
                _this.lstIndexesData = data.filter(function (x) { return x.IndexesMasterGuid != _this.IndexesMasterGuid; });
                if (_this.lstIndexesData.length > 0) {
                    _this._isShowImportIndexes = true;
                }
            }
        });
    };
    IndexesDetailComponent.prototype.ImportIndex = function (importtype) {
        var _this = this;
        if (this.indexId != '0') {
            this._IndexFromSelected = true;
            if (importtype.id == "ImportReplace") {
                this._indexesdc.ImportType = 1;
            }
            else if (importtype.id == "ImportOverwrite") {
                this._indexesdc.ImportType = 2;
            }
            this._indexesdc.IndewxFromGuid = this.indexId;
            this._indexesdc.IndewxToGuid = this.IndexesMasterGuid;
            try {
                //check for duplicate index
                this._isIndexesDetailFetching = true;
                this.indexesService.CheckDuplicateIndexesName(this._indexesdc).subscribe(function (res) {
                    if (res.Succeeded) {
                        if (res.Message != "Duplicate") {
                            _this.indexesService.ImportIndexes(_this._indexesdc).subscribe(function (res) {
                                if (res.Succeeded) {
                                    localStorage.setItem('divSucessIndexes', JSON.stringify(true));
                                    localStorage.setItem('successmsgindexes', JSON.stringify('Indexes imported successfully'));
                                    _this._router.navigate(['indexes']);
                                }
                                else {
                                    _this._router.navigate(['login']);
                                }
                            });
                        }
                        else {
                            _this.ClosePopUpImportIndex();
                            _this._ShowmessagedivWar = true;
                            _this._ShowmessagedivMsgWar = "Index with same name already exits, please use different index name.";
                            _this._isIndexesDetailFetching = false;
                            setTimeout(function () {
                                _this._ShowmessagedivWar = false;
                                _this._ShowmessagedivMsgWar = "";
                            }, 3000);
                        }
                    }
                });
            }
            catch (err) {
                this.ClosePopUpImportIndex();
                this._isIndexesDetailFetching = false;
            }
        }
        else {
            this._IndexFromSelected = false;
            setTimeout(function () {
                _this._IndexFromSelected = true;
            }, 5000);
        }
    };
    IndexesDetailComponent.prototype.RefreshLibors = function () {
        var _this = this;
        this._isIndexesDetailFetching = true;
        this.indexesService.importindexbyapi(this._indextype, 1, 100).subscribe(function (res) {
            if (res.Succeeded == true) {
                _this._isIndexesDetailFetching = false;
                _this._ShowmessagedivWar = true;
                _this._ShowmessagedivMsgWar = "Libor refresh successfully!";
                setTimeout(function () {
                    _this._ShowmessagedivWar = false;
                    _this._ShowmessagedivMsgWar = "";
                }, 3000);
            }
        });
    };
    IndexesDetailComponent.prototype.CustomAlert = function (dialog) {
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
    IndexesDetailComponent.prototype.ok = function () {
        document.getElementById('dialogbox').style.display = "none";
        document.getElementById('dialogoverlay').style.display = "none";
    };
    __decorate([
        core_1.ViewChild('flexIndexesDetail'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], IndexesDetailComponent.prototype, "flexIndexesDetail", void 0);
    IndexesDetailComponent = __decorate([
        core_1.Component({
            selector: "indexesdetail",
            templateUrl: "app/components/indexesdetail.html?v=" + $.getVersion(),
            providers: [indexesService_1.indexesService, notificationService_1.NotificationService, utilityService_1.UtilityService, functionService_1.functionService],
        }),
        __metadata("design:paramtypes", [router_1.ActivatedRoute,
            router_1.Router,
            indexesService_1.indexesService,
            utilityService_1.UtilityService,
            notificationService_1.NotificationService,
            functionService_1.functionService])
    ], IndexesDetailComponent);
    return IndexesDetailComponent;
}(paginated_1.Paginated));
exports.IndexesDetailComponent = IndexesDetailComponent;
var routes = [
    { path: '', component: IndexesDetailComponent }
];
var IndexesDetailModule = /** @class */ (function () {
    function IndexesDetailModule() {
    }
    IndexesDetailModule = __decorate([
        core_2.NgModule({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_core_1.WjCoreModule, wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule],
            declarations: [IndexesDetailComponent]
        })
    ], IndexesDetailModule);
    return IndexesDetailModule;
}());
exports.IndexesDetailModule = IndexesDetailModule;
//# sourceMappingURL=indexesDetail.component.js.map