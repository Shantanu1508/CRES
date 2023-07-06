import { Component, OnInit, AfterViewInit, ViewChild, Output, HostListener, EventEmitter } from "@angular/core";
import { Router, ActivatedRoute, Params } from '@angular/router';
import { deals } from "../../core/domain/deals";
import { OperationResult } from '../../core/domain/operationResult';
import { ReportService } from '../../core/services/reportService';
import { NotificationService } from '../../core/services/notificationService'
import { User } from '../../core/domain/user';
import { UtilityService } from '../../core/services/utilityService';
import { Paginated } from '../../core/common/paginated';
import * as wjcCore from 'wijmo/wijmo';
import * as wjcGrid from 'wijmo/wijmo.grid';
import * as wjNg2Input from 'wijmo/wijmo.angular2.input';
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
import { Ng2FileInputModule, Ng2FileInputService, Ng2FileInputAction } from 'ng2-file-input';
import * as wjcGridXlsx from 'wijmo/wijmo.grid.xlsx';
import { Module } from "../../core/domain/Module";
import { reportFile } from '../../core/domain/reportFile';
declare var $: any;




@Component({
    selector: "accountingreport",
    templateUrl: "app/components/AccountingReports/accountingReport.html?v=" + $.getVersion(),
    providers: [ReportService, NotificationService]
})


export class AccountingReportComponent extends Paginated {

    dealMessage: string;
    userid: number;
    lstreports: any;
    private _deals: Array<deals>;
    private userobj: User;
    dealaddpath: any;
    private _reportListFetching: boolean = false;
    private _ShowmessagedivMsgWar: boolean = false;
    private _dvEmptyReportSearchMsg: boolean = false;
    private _Showmessagediv: boolean = false;
    private _ShowmessagedivMsg: string = '';
    private _WaringMessage: string = '';
    private _isshowGeneratebutton: boolean = false;
    private _isShowActivityLog: boolean = false;
    private _reportFileGUID = "";
    private _dvInValidJson: boolean = false;
    private _dvInValidJsonMsg: string = '';
    private _attributeValue = "";
    private _ShowmessagedivError: boolean = false;
    private _ShowmessagedivErrorMsg: string = '';

    

    @ViewChild('flex') flex: wjcGrid.FlexGrid;
    @ViewChild('filter') gridFilter: wjcGridFilter.FlexGridFilter;
    constructor(public reportSrv: ReportService,
        public utilityService: UtilityService,
        public notificationService: NotificationService,
        private _router: Router) {
        super(30, 1, 0);
        this._isshowGeneratebutton = false;
        this.getAllRepots();
        this.utilityService.setPageTitle("M61–Report");
    }


    initialized(s: wjcGrid.FlexGrid, e: any) {
        this.gridFilter.filterChanged.addHandler(function () {
            console.log('filter changed 11111');
        });
    }
    // Component views are initialized
    ngAfterViewInit() {
        // commit row changes when scrolling the grid

        this.flex.scrollPositionChanged.addHandler(() => {
            var myDiv = $('#flex').find('div[wj-part="root"]');

            if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
                if (this.flex.rows.length < this._totalCount) {
                    this._pageIndex = this.pagePlus(1);
                    this.getAllRepots();

                }
            }
        });
    }

    getAllRepots(): void {

        this._reportListFetching = true;
        this.reportSrv.GetAllAccountingReport(this._pageIndex, this._pageSize)
            .subscribe(res => {
                if (res.Succeeded) {

                    //if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {

                        var data: any = res.ReportFileList;
                        this._totalCount = res.TotalCount;


                        if (this._pageIndex == 1) {
                            this.lstreports = data;

                            //remove first cell selection
                            this.flex.selectionMode = wjcGrid.SelectionMode.None;

                            if (res.TotalCount == 0) {
                                this._dvEmptyReportSearchMsg = true;
                                this._reportListFetching = false;
                            } else {
                                setTimeout(() => {
                                    this._reportListFetching = false;
                                }, 2000);
                            }

                            setTimeout(() => {
                                this.ApplyPermissions(res.UserPermissionList);
                            }, 2000);

                        }
                        else {
                            this.lstreports = this.lstreports.concat(data);
                        }

                        this._reportListFetching = false;

                        setTimeout(function () {
                            this.flex.invalidate();
                            //this.flex.autoSizeColumns(0, this.flex.columns.length, false, 20);
                            //this.flex.columns[0].width = 350; // for Note Id
                        }.bind(this), 1);

                    //} else {
                    //    this.utilityService.navigateUnauthorize();
                    //}
                    //
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

    generateReport(ReportFileGUID): void {
        var _objreportfile = this.lstreports.filter(x => x.ReportFileGUID == ReportFileGUID)[0];

      
        var _reportFile = new reportFile();
        _reportFile.ReportFileGUID = ReportFileGUID;
        _reportFile.IsDownloadRequire = false;
        _reportFile.DefaultAttributes = this._attributeValue;

        this._reportListFetching = true;
        this.reportSrv.GenerateAccountingReport(_reportFile)
            .subscribe(res => {
                this._reportListFetching = false;
                if (_reportFile.IsDownloadRequire == false) {
                    if (res.Succeeded) {
                        //this._reportListFetching = false;

                        this._Showmessagediv = true;
                        this._ShowmessagedivMsg = "File generated successfully";
                        setTimeout(function () {
                            this._Showmessagediv = false;
                            this._ShowmessagedivMsg = "";
                            //   console.log(this._ShowmessagedivWar);
                        }.bind(this), 5000);
                    }
                    else {
                        this._ShowmessagedivError = true;
                        this._ShowmessagedivErrorMsg = "Erro in file generation,Please try after some time.";
                        setTimeout(function () {
                            this._ShowmessagedivError = false;
                            this._ShowmessagedivErrorMsg = "";
                            //   console.log(this._ShowmessagedivWar);
                        }.bind(this), 5000);
                    }
                }
                else
                {
                    
                        let b: any = new Blob([res]);
                        //var url = window.URL.createObjectURL(b);
                        //window.open(url);

                        let dwldLink = document.createElement("a");
                        let url = URL.createObjectURL(b);
                        let isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
                        if (isSafariBrowser) {  //if Safari open in new window to save file with random filename.
                            dwldLink.setAttribute("target", "_blank");
                        }
                        dwldLink.setAttribute("href", url);
                        dwldLink.setAttribute("download", _objreportfile.ReportFileName + '.' + _objreportfile.ReportFileFormat);
                        dwldLink.style.visibility = "hidden";
                        document.body.appendChild(dwldLink);
                        dwldLink.click();
                        document.body.removeChild(dwldLink);
                        //this._reportListFetching = false;
                        this._Showmessagediv = true;
                        this._ShowmessagedivMsg = "File generated successfully";
                        setTimeout(function () {
                            this._Showmessagediv = false;
                            this._ShowmessagedivMsg = "";
                        }.bind(this), 5000);
                }
            },
            error => {
               // alert('Something went wrong');
                this._reportListFetching = false;;
                
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


    clickeddeal() {
        this._reportListFetching = true;
    }

    ShowAttributesDialog(attributeValue,reportname) {
        
        $("#txtDefaultAttribute").val(attributeValue);
        $("#spnHeader").text(reportname+' parameters');
        
        var modal = document.getElementById('ModalReportFileAttribute');
        modal.style.display = "block";
        $.getScript("/js/jsDrag.js");
    }

    ClosePopUpReportFileAttribute() {
        var modal = document.getElementById('ModalReportFileAttribute');
        $('#txtDefaultAttribute').val('');
        modal.style.display = "none";
    }

    GenearteAndDownloadReport(ReportFileGUID)
    {
        var _objreportfile = this.lstreports.filter(x => x.ReportFileGUID == ReportFileGUID)[0];
        if (_objreportfile.DefaultAttributes !== undefined && _objreportfile.DefaultAttributes != null) {
            this._reportFileGUID = ReportFileGUID;
            this.ShowAttributesDialog(_objreportfile.DefaultAttributes, _objreportfile.ReportFileName);
        }
        else
        {
            this._reportFileGUID = "";
            this._attributeValue = "";
            this.generateReport(_objreportfile.ReportFileGUID);
        }
    }
    GenearteAndDownloadReportWithParam(ReportFileGUID)
    {
        if (!this.isValidJson($("#txtDefaultAttribute").val()))
        {
            this._dvInValidJson = true;
            this._dvInValidJsonMsg = "Invalid json format";
            setTimeout(function () {
                this._dvInValidJson = false;
                this._dvInValidJsonMsg = "";
                //   console.log(this._ShowmessagedivWar);
            }.bind(this), 3000);
            return false;
        }
        else    
        {
            this._attributeValue = $("#txtDefaultAttribute").val();
            this.ClosePopUpReportFileAttribute();
            this.generateReport(this._reportFileGUID);
        }
    }

    isValidJson(jsonstring)
    {
        try {
            JSON.parse(jsonstring);
        } catch (e) {
            return false;
        }
        return true;
    }
}


const routes: Routes = [

    { path: '', component: AccountingReportComponent }]

@NgModule({
    imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjGridModule, WjInputModule, WjGridFilterModule, Ng2FileInputModule.forRoot()],
    declarations: [AccountingReportComponent]
})
    

export class AccountReportListModule { }

