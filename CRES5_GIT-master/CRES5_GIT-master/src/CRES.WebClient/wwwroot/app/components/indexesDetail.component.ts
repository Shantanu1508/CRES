import { Component, OnInit, Inject, Compiler, ViewChild } from '@angular/core';
import { Router, ActivatedRoute, Params, Route } from '@angular/router';
import { Indexes, IndexesSearch } from "../core/domain/indexes";
import { IndexType } from "../core/domain/indexType";
import * as wjNg2Grid from 'wijmo/wijmo.angular2.grid';
import { OperationResult } from '../core/domain/operationResult';
import { indexesService } from '../core/services/indexesService';
import { NotificationService } from '../core/services/notificationService'

import { isLoggedIn } from '../core/services/is-logged-in';
import { UtilityService } from '../core/services/utilityService';
import { Paginated } from '../core/common/paginated';

import * as wjcCore from 'wijmo/wijmo';
import * as wjcGrid from 'wijmo/wijmo.grid';

import { ModuleWithProviders, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { Headers, RequestOptions, BaseRequestOptions } from '@angular/http';
import { WjCoreModule } from 'wijmo/wijmo.angular2.core';
import { WjGridModule } from 'wijmo/wijmo.angular2.grid';
import { WjGridFilterModule } from 'wijmo/wijmo.angular2.grid.filter';
import { functionService } from '../core/services/functionService';
declare var $: any;
@Component({
    selector: "indexesdetail",
    templateUrl: "app/components/indexesdetail.html?v=" + $.getVersion(),
    providers: [indexesService, NotificationService, UtilityService, functionService],
})

export class IndexesDetailComponent extends Paginated {
    cvIndexesDetaildata: wjcCore.CollectionView;
    private _indexesdc: Indexes;
    private _indextype: IndexType;
    private IndexesMasterGuid: any;
    private _ShowmessagedivMsgWar: any;
    private indexupdatedRowNo: any = [];
    private indexrowsToUpdate: any = [];
    private _ShowmessagedivWar: boolean = false;
    private TotalCount: number = 0;
    private indexesDetaildata: any;
    public indexesindexdata: Array<any>;
    private Message: any = '';
    private _Showmessagediv: boolean = false;
    private _isIndexesDetailFetching: boolean = true;
    private _isScrolled: boolean = true;
    private _FirstDate: Date;
    private _lastDate: Date;

    private _listlength: any;
    public _indexessearch = new IndexesSearch();
    private _isIndexLoad: boolean = true;
    private _IndexFromSelected: boolean = true;
    private _isShowImportIndexes: boolean = false;

    columns: {
        binding?: string, header?: string, width?: any, format?: string
    }[];
    private lstFolders: any;
    public indexId: string;
    public autoVerfoldername: string;
    lstIndexesData: any;

    @ViewChild('flexIndexesDetail') flexIndexesDetail: wjcGrid.FlexGrid;
    constructor(private activatedRoute: ActivatedRoute,
        private _router: Router,
        public indexesService: indexesService,
        public utilityService: UtilityService,
        public notificationService: NotificationService,
        public functionServiceSrv: functionService) {
        super(30, 0, 0);
        this.activatedRoute.params.forEach((params: Params) => {
            if (params['id'] !== undefined) {
                this.indexId = '0'
                var indexesGUID = params['id'];
                this._indexesdc = new Indexes(indexesGUID);
                this.IndexesMasterGuid = indexesGUID;
                // this.GetIndexesMasterDetailByID(this._indexesdc);

                if (this.IndexesMasterGuid != '00000000-0000-0000-0000-000000000000') {
                    this.GetIndexesMasterDetailByID(this._indexesdc);
                }
                else {
                    this.GetIndexsListByIndexesMasterGuid(this.IndexesMasterGuid);
                }
                this.GetAllIndexes();
            }
        });
        this.utilityService.setPageTitle("M61 – Index Details");
    }



    ngAfterViewInit() {
        // commit row changes when scrolling the grid


        this.flexIndexesDetail.scrollPositionChanged.addHandler(() => {
            var myDiv = $('#flexIndexesDetail').find('div[wj-part="root"]');
            if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {

                if (this.flexIndexesDetail.rows.length < this.TotalCount) {
                    this._isIndexesDetailFetching = true;
                    this._indexessearch.IndexesMasterGuid = this.IndexesMasterGuid;
                    this._indexessearch.Fromdate = this._lastDate;
                    this._indexessearch.Todate = null;
                    this.GetIndexBetweenDates(this._indexessearch, "after");
                }
            }
            else if (myDiv.scrollTop() == 0) {
                if (this.flexIndexesDetail.rows.length < this.TotalCount) {
                    this._indexessearch.IndexesMasterGuid = this.IndexesMasterGuid;
                    this._isIndexesDetailFetching = true;
                    this._indexessearch.Fromdate = null;
                    this._indexessearch.Todate = this._FirstDate;
                    this.GetIndexBetweenDates(this._indexessearch, "before");
                }
            }
        });
    }


    GetIndexBetweenDates(indexessearch: IndexesSearch, append: string) {
        this.indexesService.GetIndexListByDate(indexessearch).subscribe(res => {
            if (res.Succeeded) {
                var tempdata = this.indexesDetaildata;
                this.indexesindexdata = res.dtIndexType;
                this._listlength = this.indexesindexdata.length;
                if (this.indexesindexdata.length > 0) {
                    for (var i = 0; i < this.indexesindexdata.length; i++) {
                        if (this.indexesindexdata[i].Date != null) {
                            if (this.indexesindexdata[i].Date == "1900-01-01T00:00:00") {
                                this.indexesindexdata[i].Date = "";
                            } else {
                                this.indexesindexdata[i].Date = new Date(this.indexesindexdata[i].Date.toString());
                            }
                        }
                    }


                    if (append == "before") {

                        // if (this._FirstDate > this.scenarioindexdata[0].Date) { this._FirstDate = this.scenarioindexdata[0].Date; }
                        this._FirstDate = this.indexesindexdata[0].Date;
                        this.indexesDetaildata = this.indexesindexdata.concat(tempdata);

                        this.cvIndexesDetaildata = new wjcCore.CollectionView(this.indexesDetaildata);
                        this.cvIndexesDetaildata.trackChanges = true;

                        this._isIndexesDetailFetching = false;
                        var myDiv = $('#flexIndexesDetail').find('div[wj-part="root"]');
                        myDiv.scrollTop(100);
                    }
                    else {

                        if (this._lastDate < this.indexesindexdata[this._listlength - 1].Date) {
                            this._lastDate = this.indexesindexdata[this._listlength - 1].Date;
                        }
                        if (this._lastDate != null) { this._lastDate = this.createDateAsUTC(this._lastDate); }
                        this.indexesDetaildata = this.indexesDetaildata.concat(this.indexesindexdata);

                        this.cvIndexesDetaildata = new wjcCore.CollectionView(this.indexesDetaildata);
                        this.cvIndexesDetaildata.trackChanges = true;

                        var myDiv = $('#flexIndexesDetail').find('div[wj-part="root"]');

                    }
                    var delrow = this.flexIndexesDetail.rows[30];
                    this.flexIndexesDetail.rows.remove(delrow);


                    // this.scenarioDetaildata = this.scenarioindexdata;
                    //this.scenarioindexdata.forEach((obj, i) => {
                    //    this.flexScenarioDetail.rows.push(new wjcGrid.Row(obj));

                    //});
                    this._isIndexesDetailFetching = false;
                }
                else {
                    //this.scenarioDetaildata = [];
                    //this.cvScenarioDetaildata = new wjcCore.CollectionView(this.scenarioDetaildata);
                    //this.cvScenarioDetaildata.trackChanges = true;
                    this._isIndexesDetailFetching = false;

                }
            }
        });
    }


    downloadIndexsExportData(): void {

        //var _note: Note;
        this._isIndexesDetailFetching = true;
        this._indexessearch.IndexesMasterGuid = this.IndexesMasterGuid;
        this.indexesService.GetIndexesExportDataByIndexesMasterId(this._indexessearch).subscribe(res => {

            if (res.Succeeded) {
                setTimeout(function () {
                    this._isIndexesDetailFetching = false;

                }.bind(this), 100);

                this.downloadFile(res.dtIndexType);
            }
            else {
                // this._dvEmptynoteperiodiccalcMsg = true;
            }
            error => console.error('Error: ' + error)
        });
    }



    GetIndexesMasterDetailByID(_objIndexes: Indexes): void {
        try {
            this._isIndexesDetailFetching = true;
            var _indexesGUID = _objIndexes.IndexesMasterGuid;
            this.indexesService.GetIndexesDetailByIndexesMasterGuid(_objIndexes).subscribe(res => {
                if (res.Succeeded) {
                    if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                        this._indexesdc = res.indexesMaster;
                        this.GetIndexsListByIndexesMasterGuid(_indexesGUID);
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

    DiscardChanges(): void {
        this._router.navigate(['indexes']);
    }


    GetIndexsListByIndexesMasterGuid(_indexesGUID): void {

        this.indexesService.GetIndexListByIndexesMasterID(_indexesGUID, this._pageIndex, this._pageSize).subscribe(res => {
            if (res.Succeeded) {
                this.TotalCount = res.TotalCount
                if (this.TotalCount == 0) {
                    this._isIndexLoad = false;
                }
                this._isScrolled = false;
                this.indexesindexdata = res.dtIndexType
                this._isScrolled = true;

                var locale = "en-US"
                var options = { year: "numeric", month: "numeric", day: "numeric" };
                // for (var i = 0; i < this.TotalCount; i++) {
                for (var i = 0; i < this.indexesindexdata.length; i++) {
                    if (this.indexesindexdata[i].Date != null) {
                        if (this.indexesindexdata[i].Date == "1900-01-01T00:00:00") {
                            this.indexesindexdata[i].Date = "";
                        } else {
                            this.indexesindexdata[i].Date = new Date(this.indexesindexdata[i].Date.toString());
                        }
                    }


                    if (i == this.indexesindexdata.length - 1) {
                        setTimeout(function () {
                            this._isIndexesDetailFetching = false;
                        }.bind(this), 2000);
                    }
                }
                this.indexesDetaildata = this.indexesindexdata;
                if (this.indexesindexdata.length > 0) {

                    this._FirstDate = this.indexesindexdata[0].Date;
                    this._lastDate = this.indexesindexdata[(this.indexesindexdata.length) - 1].Date;
                    if (this._lastDate != null) { this._lastDate = this.createDateAsUTC(this._lastDate); }
                    this.cvIndexesDetaildata = new wjcCore.CollectionView(this.indexesDetaildata);
                    this.cvIndexesDetaildata.trackChanges = true;
                }
                else {
                    this.indexesDetaildata = [];
                    this.cvIndexesDetaildata = new wjcCore.CollectionView(this.indexesDetaildata);
                    this.cvIndexesDetaildata.trackChanges = true;
                }
                var myDiv = $('#flexIndexesDetail').find('div[wj-part="root"]');
                myDiv.scrollTop(200);

                if (this.indexesindexdata.length == 0) {
                    this._isIndexesDetailFetching = false;
                }

                this._isIndexesDetailFetching = false;
            }

        });
        error => console.error('Error: ' + error)
    }

    Addcolumn(header, binding) {
        try {
            this.columns.push({ "header": header, "binding": binding, "format": 'p5' })
        } catch (err) { }
    }

    ValidateIndexesAndSave(Actionstatus): void {
        try {

            this._isIndexesDetailFetching = true;

            this._indexesdc.IndexesMasterGuid = this.IndexesMasterGuid;
            //this._indexesdc.ActionStatus = Actionstatus;

            if (this._indexesdc.IndexesName != "" && this._indexesdc.IndexesName != null) {
                this.indexesService.CheckDuplicateIndexesName(this._indexesdc).subscribe(res => {
                    if (res.Succeeded) {
                        if (res.Message != "Duplicate") {
                            this.InsertUpdateIndexesMasterdetail();
                        }
                        else {
                            this._ShowmessagedivWar = true;
                            this._ShowmessagedivMsgWar = "Index with same name already exits, please use different index name."
                            this._isIndexesDetailFetching = false;
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
                this._ShowmessagedivMsgWar = "Please fill Index name."
                this._isIndexesDetailFetching = false;
                setTimeout(() => {
                    this._ShowmessagedivWar = false;
                    this._ShowmessagedivMsgWar = "";
                }, 3000);
            }

        } catch (err) {
        }
    }

    InsertUpdateIndexesMasterdetail(): void {
        try {
            this.indexesService.InsertUpdateIndexesMasterdetail(this._indexesdc).subscribe(res => {
                if (res.Succeeded) {
                    this.IndexesMasterGuid = res.newIndexesMasterGuid;

                    localStorage.setItem('divSucessIndexes', JSON.stringify(true));
                    localStorage.setItem('successmsgindexes', JSON.stringify(res.Message));
                    this.UpdateIndex(this.IndexesMasterGuid);
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
    private prevDateBeforeEdit: Date;
    // index grid saving code

    IndexesDetailselectionChanged(): void {
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
            case "IndexesDetail":
                var sel = this.flexIndexesDetail.selection;
                if (this.indexesDetaildata[sel.topRow].Date != null)
                    this.prevDateBeforeEdit = this.indexesDetaildata[sel.topRow].Date;
                break;
        }
    }

    rowEditEnded(modulename): void {
        switch (modulename) {
            case "IndexesDetail":
                var sel = this.flexIndexesDetail.selection;
                var flag = this.CheckDuplicateDate(sel.topRow);
                //alert('end  - ' + this.prevDateBeforeEdit);
                if (flag == true) {
                    var indformatDate: Date;

                    var locale = "en-US"
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
    }

    CopiedDataValidate(modulename): void {
        try {
            switch (modulename) {
                case "IndexesDetail":
                    var sel = this.flexIndexesDetail.selection;
                    var rssformatDate: Date;
                    var datearr: any = '';
                    for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
                        var flag = this.CheckDuplicateDate(tprow); //this.CheckDuplicateDate(this.scenarioDetaildata, tprow);
                        if (flag == true) {
                            var locale = "en-US"
                            var options = { year: "numeric", month: "numeric", day: "numeric" };
                            rssformatDate = this.indexesDetaildata[tprow].Date;
                            // datearr = rssformatDate.toLocaleDateString(locale, options); 
                            datearr = datearr + " , " + rssformatDate.toLocaleDateString(locale, options);
                            this.indexesDetaildata[tprow].Date = '';
                        }
                    }

                    if (datearr != '' && datearr != null)
                    {
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
    }

    CheckDuplicateDate(rwNum): boolean {
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
    }

    convertDatetoGMTGrid(Data) {
        if (Data) {
            for (var i = 0; i < Data.length; i++) {
                if (this._indextype[i].Date) {
                    this._indextype[i].Date = this.createDateAsUTC(this._indextype[i].Date);
                }
            }
        }
    }

    createDateAsUTC(date: Date) {
        if (date) {
            date = new Date(date);
            return new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds()));
        } else
            return date;
    }



    UpdateIndex(newIndexesMasterGuid): void {
        debugger;
        if (this.indexesDetaildata == undefined) {
            this._router.navigate(['indexes']);
        }

        this._indextype = new IndexType();
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
                    this._indextype = new IndexType();
                    this._indextype = this.cvIndexesDetaildata.itemsAdded[i];
                    if (this.indexesDetaildata[j].Date == this._indextype.Date) {
                        if (!(this._indextype.Date.toString() == "" || this._indextype.Date == null)) {
                            this.indexrowsToUpdate.push(this.indexesDetaildata[j])
                        }
                    }
                }
                for (var i = 0; i < this.cvIndexesDetaildata.itemsEdited.length; i++) {
                    this._indextype = new IndexType();
                    this._indextype = this.cvIndexesDetaildata.itemsEdited[i];
                    if (this.indexesDetaildata[j].Date == this._indextype.Date) {
                        if (!(this._indextype.Date.toString() == "" || this._indextype.Date == null)) {
                            this.indexrowsToUpdate.push(this.indexesDetaildata[j])
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

        this.indexesService.AddUpdateIndexTypeList(this._indextype).subscribe(res => {
            if (res.Succeeded) {


                this._router.navigate(['indexes']);
            }
            else {
                this._isIndexesDetailFetching = false;
                this._ShowmessagedivWar = true;
                this._ShowmessagedivMsgWar = "Error occured while saving."
                setTimeout(() => {
                    this._ShowmessagedivWar = false;
                    this._ShowmessagedivMsgWar = "";
                }, 3000);


            }
        });
    }


    downloadFile(objArray) {
        var data = this.ConvertToCSV(objArray);
        var displayDate = new Date().toLocaleDateString("en-US");
        var fileName = this._indexesdc.IndexesName + "-" + displayDate + ".csv";

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

    ChangeFolder(newvalue): void {
        this.indexId = newvalue;
    }
    showDialogImportIndex(): void {

        if (this._indexesdc.IndexesName != "" && this._indexesdc.IndexesName != null) {

            var modal = document.getElementById('myModalImportIndex');
            modal.style.display = "block";
            $.getScript("/js/jsDrag.js");

        } else {

            this._ShowmessagedivWar = true;
            this._ShowmessagedivMsgWar = "Please fill Index name."
            this._isIndexesDetailFetching = false;
            setTimeout(() => {
                this._ShowmessagedivWar = false;
                this._ShowmessagedivMsgWar = "";
            }, 3000);
        }




    }

    ClosePopUpImportIndex(): void {

        var modal = document.getElementById('myModalImportIndex');
        modal.style.display = "none";
        this.indexId = '0'

    }

    GetAllIndexes(): void {
        this.indexesService.GetAllIndexesMaster(1, 100)
            .subscribe(res => {
                if (res.Succeeded) {
                    var data: any = res.lstIndexesMaster;
                    this.lstIndexesData = data.filter(x => x.IndexesMasterGuid != this.IndexesMasterGuid);
                    if (this.lstIndexesData.length > 0) {
                        this._isShowImportIndexes = true;
                    }
                }
            }
            );
    }

    ImportIndex(importtype) {
        if (this.indexId != '0') {
            this._IndexFromSelected = true;
            if (importtype.id == "ImportReplace") {
                this._indexesdc.ImportType = 1
            }
            else if (importtype.id == "ImportOverwrite") {
                this._indexesdc.ImportType = 2
            }
            this._indexesdc.IndewxFromGuid = this.indexId
            this._indexesdc.IndewxToGuid = this.IndexesMasterGuid

            try {

                //check for duplicate index
                this._isIndexesDetailFetching = true;
                this.indexesService.CheckDuplicateIndexesName(this._indexesdc).subscribe(res => {
                    if (res.Succeeded) {
                        if (res.Message != "Duplicate") {
                            this.indexesService.ImportIndexes(this._indexesdc).subscribe(res => {
                                if (res.Succeeded) {
                                    localStorage.setItem('divSucessIndexes', JSON.stringify(true));
                                    localStorage.setItem('successmsgindexes', JSON.stringify('Indexes imported successfully'));
                                    this._router.navigate(['indexes']);
                                }
                                else {
                                    this._router.navigate(['login']);
                                }
                            });
                        }
                        else {
                            this.ClosePopUpImportIndex();
                            this._ShowmessagedivWar = true;
                            this._ShowmessagedivMsgWar = "Index with same name already exits, please use different index name."
                            this._isIndexesDetailFetching = false;
                            setTimeout(() => {
                                this._ShowmessagedivWar = false;
                                this._ShowmessagedivMsgWar = "";
                            }, 3000);
                        }
                    }
                });


            } catch (err) {
                this.ClosePopUpImportIndex();
                this._isIndexesDetailFetching = false;
            }
        }
        else {
            this._IndexFromSelected = false;
            setTimeout(() => {
                this._IndexFromSelected = true;
            }, 5000);
        }
    }

    RefreshLibors() {
        this._isIndexesDetailFetching = true;
        this.indexesService.importindexbyapi(this._indextype, 1, 100).subscribe(res => {
            if (res.Succeeded == true) {
                this._isIndexesDetailFetching = false;
                this._ShowmessagedivWar = true;
                this._ShowmessagedivMsgWar = "Libor refresh successfully!";
                setTimeout(() => {
                    this._ShowmessagedivWar = false;
                    this._ShowmessagedivMsgWar = "";
                }, 3000);
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
        //document.getElementById('dialogboxfoot').innerHTML = '<span class="custombutton" onclientclick="this.ok()">OK</span>';
    }

    ok(): void {
        document.getElementById('dialogbox').style.display = "none";
        document.getElementById('dialogoverlay').style.display = "none";
    }
}

const routes: Routes = [

    { path: '', component: IndexesDetailComponent }]

@NgModule({
    imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjGridFilterModule],
    declarations: [IndexesDetailComponent]
})

export class IndexesDetailModule { }