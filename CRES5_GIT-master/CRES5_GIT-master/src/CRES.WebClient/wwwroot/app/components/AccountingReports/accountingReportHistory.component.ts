
import { Component, OnInit, AfterViewInit, ViewChild } from "@angular/core";
import { Router, ActivatedRoute } from '@angular/router';
import { deals } from "../../core/domain/deals";
import { OperationResult } from '../../core/domain/operationResult';
import { ReportService } from '../../core/services/reportService';
import { NotificationService } from '../../core/services/notificationService'
import { User } from '../../core/domain/user';
import { UtilityService } from '../../core/services/utilityService';
import { Paginated } from '../../core/common/paginated';
import * as wjNg2Input from 'wijmo/wijmo.angular2.input';
import * as wjcCore from 'wijmo/wijmo';
import * as wjcGrid from 'wijmo/wijmo.grid';
import { ModuleWithProviders, Input, Inject, enableProdMode, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import * as wjcGridFilter from 'wijmo/wijmo.grid.filter';
import { Headers, RequestOptions, BaseRequestOptions } from '@angular/http';
import { WjCoreModule } from 'wijmo/wijmo.angular2.core';
import { WjGridModule } from 'wijmo/wijmo.angular2.grid';
import { WjGridFilterModule } from 'wijmo/wijmo.angular2.grid.filter';
import { WjInputModule } from 'wijmo/wijmo.angular2.input';
import { reportFileLog } from "../../core/domain/reportFileLog";
import { FileUploadService } from '../../core/services/fileuploadservice';
import { Ng2FileInputModule, Ng2FileInputService, Ng2FileInputAction } from 'ng2-file-input';
declare var $: any;

@Component({
    selector: "reporthistory",
    templateUrl: "app/components/AccountingReports/accountingReportHistory.html?v=" + $.getVersion(),
    providers: [ReportService, FileUploadService, NotificationService]
})


export class AccountingReportHistoryComponent extends Paginated {

    dealMessage: string;
    userid: number;
    private _deals: Array<deals>;
    private userobj: User;
    dealaddpath: any;
    private _isListFetching: boolean = false;
    private _ShowmessagedivMsgWar: boolean = false;
    private _dvEmptyReportSearchMsg: boolean = false;
    private _Showmessagediv: boolean = false;
    private _ShowmessagedivMsg: string = '';
    private _WaringMessage: string = '';
    private _isshowGeneratebutton: boolean = false;
    private _isShowActivityLog: boolean = false;
    public _document: reportFileLog;

    public _pageSizeDocImport: number = 30;
    public _pageIndexDocImport: number = 1;
    public _totalCountDocImport: number = 0;
    public CurrentcountDocImport: number = 0;
    private isScrollHandlerAdded: boolean = false;
    private _dvEmptyDocumentMsg: boolean = false;
    lstReports: any;
    lstReportMaster: any;
    _startDate: Date;
    _endDate: Date;
    savedialogmsg: string

    @ViewChild('flex') flex: wjcGrid.FlexGrid;
    @ViewChild('filter') gridFilter: wjcGridFilter.FlexGridFilter;
    public _ConfirmMsgText: string;
    private ConfirmDialogBoxFor: string;
    private UploadedDocumentLogID: string;
    constructor(public reportSrv: ReportService,
        private ng2FileInputService: Ng2FileInputService,
        public fileUploadService: FileUploadService,
        public utilityService: UtilityService,
        public notificationService: NotificationService,
        private _router: Router) {
        super(30, 1, 0);
        this._isshowGeneratebutton = false;
        this._document = new reportFileLog();
        var d = new Date();
        var currdate = new Date((d.getMonth() + 1) + "/" + d.getDate() + "/" + d.getFullYear())
        this._endDate = new Date((d.getMonth() + 1) + "/" + d.getDate() + "/" + d.getFullYear())
        this._startDate = this.getDateMonthsBefore(currdate, 1)
        //this.getAllRepots();
        this.getDocumentList();
        this.utilityService.setPageTitle("M61–Report");
    }


    initialized(s: wjcGrid.FlexGrid, e: any) {
        this.gridFilter.filterChanged.addHandler(function () {
            console.log('filter changed 11111');
        });
    }

    ngOnInit() {
        this.getAllRepots();
    }
    // Component views are initialized
    //ngAfterViewInit() {
    //    // commit row changes when scrolling the grid

    //    this.flex.scrollPositionChanged.addHandler(() => {
    //        var myDiv = $('#flex').find('div[wj-part="root"]');

    //        if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
    //            if (this.flex.rows.length < this._totalCount) {
    //                this._pageIndex = this.pagePlus(1);
    //                this.getAllRepots();

    //            }
    //        }
    //    });
    //}

    getDocumentList(): void {
        this._isListFetching = true;
        this._document.ObjectTypeID = '643';
        var d = new Date();
        var datestring = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate() + " " +
            d.getHours() + ":" + d.getMinutes();


        this._document.CurrentTime = datestring;
        this._document.Status = 1;

        this.reportSrv.getDocumentsByObjectId(this._document, this._pageIndexDocImport, this._pageSizeDocImport).subscribe(res => {
            if (res.Succeeded) {
                var data: any = res.lstReportFileLog;
                this._totalCountDocImport = res.TotalCount;

                if (this._pageIndexDocImport == 1) {
                    this.lstReports = data;

                    if (this._totalCountDocImport == 0) {
                        this._dvEmptyDocumentMsg = true;
                    }
                    else {
                        this._dvEmptyDocumentMsg = false;
                    }
                }
                else {
                    this.lstReports = this.lstReports.concat(data);
                }
                this._isListFetching = false;

                //setTimeout(function () {
                //    this.flexDocument.invalidate();
                //    //remove first cell selection
                //    this.flexDocument.selectionMode = wjcGrid.SelectionMode.None;
                //    //this.flexDocument.autoSizeColumns(0, this.flexDocument.columns.length, false, 20);
                //    //this.flexDocument.columns[0].width = 350; // for Note Id
                //    this.addScrollHandler();
                //}.bind(this), 100);
            }
            else {
                this.utilityService.navigateToSignIn();
            }
        });
        error => console.error('Error: ' + error)
    }
    DownloadDocument(filename, originalfilename, storagetypeID, storageLocation, documentStorageID) {
        this._isListFetching = true;
        documentStorageID = documentStorageID === undefined ? '' : documentStorageID

        //var _reportfilelog = new reportFileLog();
        //_reportfilelog.FileName = filename;
        //_reportfilelog.StorageLocation = storageLocation;
        //_reportfilelog.StorageTypeID = storagetypeID;
        //if (_reportfilelog.StorageTypeID == "459")
        //    _reportfilelog.FileName = documentStorageID;

        var ID = filename;
        if (storagetypeID == "459")
            ID = documentStorageID

        this.reportSrv.downloadObjectDocumentByStorageTypeAndLocation(ID, storagetypeID, storageLocation)
            .subscribe(fileData => {
                let b: any = new Blob([fileData]);
                //var url = window.URL.createObjectURL(b);
                //window.open(url);

                let dwldLink = document.createElement("a");
                let url = URL.createObjectURL(b);
                let isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
                if (isSafariBrowser) {  //if Safari open in new window to save file with random filename.
                    dwldLink.setAttribute("target", "_blank");
                }
                dwldLink.setAttribute("href", url);
                dwldLink.setAttribute("download", originalfilename);
                dwldLink.style.visibility = "hidden";
                document.body.appendChild(dwldLink);
                dwldLink.click();
                document.body.removeChild(dwldLink);
                this._isListFetching = false;
            },
                error => {
                  //  alert('Something went wrong');
                    this._isListFetching = false;;
                }
            );
    }

    ApplyPermissions(_object): void {

        var buttonarray = _object.filter(function (item) { return item.ModuleType === 'Control' && item.RightsName === 'Edit'; });

        if (buttonarray.length > 0 && typeof buttonarray != 'undefined') {
            this._isshowGeneratebutton = true;
        }
        this._isShowActivityLog = true;
    }

    getAllRepots(): void {

        this.reportSrv.GetAllAccountingReport(1, 1000)
            .subscribe(res => {
                if (res.Succeeded) {

                    //if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {

                    var data: any = res.ReportFileList;
                    this._totalCount = res.TotalCount;
                    this.lstReportMaster = data;
                }
                else {
                    this.utilityService.navigateToSignIn();
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
    SearchDocument(): void {

        if (this._startDate !== undefined && this._endDate !== undefined) {
            this._document.StartDate = this.utilityService.convertDatetoGMT(this._startDate);
            this._document.EndDate = this.utilityService.convertDatetoGMT(this._endDate);
        }
        else {
            this._document.StartDate = null;
            this._document.EndDate = null;
        }

        this._document.ObjectGUID = $("#ddlReportName").val();

        if (this.isValidate()) {

            this.getDocumentList();

        } else {
            this.CustomDialogSearch();
        }

    }
    isValidate(): boolean {
        var ret_value = true;
        this.savedialogmsg = "";

        if (!this._startDate && !this._endDate) {
            return true;
        }
        if (!this._startDate || !this._endDate) {
            this.savedialogmsg = "Please select date range.";
            return false;
        }
        if (this._startDate > this._endDate) {
            this.savedialogmsg = "End date can not be smaller than start date.";
            return false;
        }
        return ret_value;
    }
    CustomDialogSearch(): void {
        var winW = window.innerWidth;
        var winH = window.innerHeight;
        var dialogbox = document.getElementById('Genericdialogbox');
        document.getElementById('searchdialogmessage').innerHTML = this.savedialogmsg;

        dialogbox.style.display = "block";
        $.getScript("/js/jsDrag.js");

    }
    ClosePopUpDialog() {
        var modal = document.getElementById('Genericdialogbox');
        modal.style.display = "none";
    }
    getDateMonthsBefore(date, nofMonths) {
        var thisMonth = date.getMonth();
        // set the month index of the date by subtracting nofMonths from the current month index
        date.setMonth(thisMonth - nofMonths);
        // When trying to add or subtract months from a Javascript Date() Object which is any end date of a month,  
        // JS automatically advances your Date object to next month's first date if the resulting date does not exist in its month. 
        // For example when you add 1 month to October 31, 2008 , it gives Dec 1, 2008 since November 31, 2008 does not exist.
        // if the result of subtraction is negative and add 6 to the index and check if JS has auto advanced the date, 
        // then set the date again to last day of previous month
        // Else check if the result of subtraction is non negative, subtract nofMonths to the index and check the same.
        if ((thisMonth - nofMonths < 0) && (date.getMonth() != (thisMonth + nofMonths))) {
            date.setDate(0);
        } else if ((thisMonth - nofMonths >= 0) && (date.getMonth() != thisMonth - nofMonths)) {
            date.setDate(0);
        }
        return date;
    }

    CallConfirm(obj): void {
        this.ConfirmDialogBoxFor = 'DeleteHistory'
        this.UploadedDocumentLogID = obj.UploadedDocumentLogID;
        var customdialogbox = document.getElementById('customdialogbox');
        this._ConfirmMsgText = 'Are you sure you want to delete ' + obj.FileName + '?';
        customdialogbox.style.display = "block";
        $.getScript("/js/jsDrag.js");

    }
    ClosePopUpConfirmBox() {
        this._ConfirmMsgText = "";
        var modal = document.getElementById('customdialogbox');
        modal.style.display = "none";
    }

    ConfirmBoxOK() {
        if (this.ConfirmDialogBoxFor == 'DeleteHistory') {
            this.DeleteReportHistory();
        }
    }

    DeleteReportHistory(): void {
        this.ClosePopUpConfirmBox();
        this._isListFetching = true;
        var lstDoc = this.lstReports.filter(x => x.UploadedDocumentLogID == this.UploadedDocumentLogID);
        lstDoc.forEach((obj, i) => { obj.Status = 395 });

        if (lstDoc.length > 0) {
            this.reportSrv.updateReportLogStatus(lstDoc).subscribe(res => {
                if (res.Succeeded) {
                    this.getDocumentList()
                    this._isListFetching = false;
                    this._Showmessagediv = true;
                    this._ShowmessagedivMsg = "File deleted successfully";
                    setTimeout(function () {
                        this._Showmessagediv = false;
                        this._ShowmessagedivMsg = "";
                        //   console.log(this._ShowmessagedivWar);
                    }.bind(this), 5000);
                }

                else {
                    this.utilityService.navigateToSignIn();
                }
            });
            error => {
                this._isListFetching = false;
                alert('Something went wrong');
            }
        }
    }
}


const routes: Routes = [

    { path: '', component: AccountingReportHistoryComponent }]

@NgModule({
    imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjGridModule, WjInputModule, WjGridFilterModule, Ng2FileInputModule.forRoot()],
    declarations: [AccountingReportHistoryComponent]
})

export class AccountingReportHistoryModule { }

