import { Component, OnInit, AfterViewInit, ViewChild, Output, HostListener, EventEmitter } from "@angular/core";
import { Router, ActivatedRoute, Params } from '@angular/router';
import { Periodic } from "../core/domain/Periodic";
import { PeriodicDataService } from '../core/services/PeriodicDataService';
import { User } from '../core/domain/user';
import { Paginated } from '../core/common/paginated';
import * as wjcCore from 'wijmo/wijmo';
import * as wjcGrid from 'wijmo/wijmo.grid';
import * as wjcGridXlsx from 'wijmo/wijmo.grid.xlsx';
import * as wjNg2Input from 'wijmo/wijmo.angular2.input';
import { ModuleWithProviders, Input, Inject, enableProdMode, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { WjGridModule } from 'wijmo/wijmo.angular2.grid';
import { WjInputModule } from 'wijmo/wijmo.angular2.input';
import { WjGridFilterModule } from 'wijmo/wijmo.angular2.grid.filter';
import { userdefaultsetting } from '../core/domain/userdefaultsetting';
import { AppSettings } from '../core/common/appsettings';
import { Module } from "../core/domain/Module";
import { Document } from "../core/domain/document";
import { Ng2FileInputModule, Ng2FileInputService, Ng2FileInputAction } from 'ng2-file-input';
declare var $: any;
import { functionService } from '../core/services/functionService';
import { UtilityService } from '../core/services/utilityService';

@Component({
    selector: "PeriodicClose",
    templateUrl: "app/components/PeriodicClose.html?v=" + $.getVersion(),
    providers: [PeriodicDataService, Periodic, functionService] //NoteService, dealService, UtilityService, MembershipService, FileUploadService, functionService]
})

export class PeriodicCloseComponent extends Paginated {

    private _periodic: Periodic;
    //private _periodicservice: PeriodicDataService;
    private _Showmessagediv: boolean = false;
    private _ShowmessagedivMsg: string = '';

    private _Showmessagenotediv: boolean = false;
    public _ConfirmMsgText: string;

    Message: any;
    public _userdefaultsetting: userdefaultsetting;

    public ScenarioId: string;
    public ScenarioName: string;

    private _showexceptionEmptymessage: boolean = false;
    // private _showexceptionEmptydiv: boolean = false;
    _isPeriodiccloseSaving: boolean = false;
    private _disabled: boolean = true;
    savedialogmsg: string
    private _result: any;
    _startDate: Date;
    _endDate: Date;
    @ViewChild('flexperiodicclose') flexperiodicclose: wjcGrid.FlexGrid;
    public lstPeriodicClose: any;
    private _dvEmptySearchMsg: boolean = false;
    private _isGridShow: boolean;
    lstselectedPeriod: any;


    columns: {
        binding?: string, header?: string, width?: any, format?: string
    }[];


    constructor(private activatedRoute: ActivatedRoute,
        private ng2FileInputService: Ng2FileInputService,
        private _router: Router,
        public functionServiceSrv: functionService,
        public _periodicservice: PeriodicDataService, public _utilityService: UtilityService) {
        super(10, 1, 0);

        this.ScenarioId = window.localStorage.getItem("scenarioid");
        this.ScenarioName = window.localStorage.getItem("ScenarioName");
        this._utilityService.setPageTitle("Periodic-Close");
        this._periodic = new Periodic();
        this.getAllPeriodicClose();
    }

    // Component views are initialized
    ngAfterViewInit() {
        //stop input (number type) control 'Scroll Wheel' feature
        setTimeout(function () {
            $('input[type=number]').each(function () {
                var el = (<HTMLInputElement>document.getElementById(($(this).attr("id"))));
                if (el) {
                    el.addEventListener('wheel', function (e) {
                        e.preventDefault(); // prevent event
                        e.stopImmediatePropagation(); // stop propogation
                    }, true);
                }
            })

            $(".ibox1").each(function () {
                var el = (<HTMLInputElement>document.getElementById(($(this).attr("id"))));
                if (el) {
                    el.addEventListener('wheel', function (e) {
                        e.preventDefault(); // prevent event
                        e.stopImmediatePropagation(); // stop propogation
                    }, true);
                }
            })
        }.bind(this), 3000);
    }

    SavePeriodicClose(): void {

        this.ScenarioId = window.localStorage.getItem("scenarioid");
        this.ScenarioName = window.localStorage.getItem("ScenarioName");
        this._periodic.AnalysisID = this.ScenarioId;

        if (this.isValidate()) {

            //Confirm msg box
            var customdialogbox = document.getElementById('customdialogbox');
            this._ConfirmMsgText = 'Are you sure you want to close the period for the date entered?';
            customdialogbox.style.display = "block";
            $.getScript("/js/jsDrag.js");

        } else {
            this._isPeriodiccloseSaving = false;
            this.CustomDialogteSave();
        }


    }


    SavePeriodicCloseFunc(): void {

        this.ClosePopUpConfirmBox();

        this._periodic.StartDate = this._utilityService.convertDatetoGMT(this._startDate);
        this._periodic.EndDate = this._utilityService.convertDatetoGMT(this._endDate);

        this._isPeriodiccloseSaving = true;
        this._disabled = false;


        this._periodicservice.savePeriodicClose(this._periodic).subscribe(res => {
            if (res.Succeeded) {
                this._startDate = null;
                this._endDate = null;

                this.getAllPeriodicClose();

                this._Showmessagediv = true;
                this._ShowmessagedivMsg = "Periodic Close added successfully";

                setTimeout(function () {
                    this._Showmessagediv = false;
                    this._isPeriodiccloseSaving = false;
                    this._disabled = true;
                }.bind(this), 2000);
            }
        });
    }


    isValidate(): boolean {
        var ret_value = true;
        this.savedialogmsg = "";
        

        if (!this._startDate || !this._endDate) {
            this.savedialogmsg = "Please select date range.";
            return false;
        }
        if (this._startDate > this._endDate) {
            this.savedialogmsg = "End date can not be smaller than start date.";
            return false;
        }
        if (this._startDate.getTime() == this._endDate.getTime()) {
            this.savedialogmsg = "Start date and end date can not be equal.";
            return false;
        }

        var firstDayOfmonth = new Date(this._startDate.getFullYear(), this._startDate.getMonth(), 1);
        if (this._startDate.getTime() != new Date(firstDayOfmonth).getTime()) {
            this.savedialogmsg = "Start date should be the first day of month.";
            return false;
        }

        var lastDayOfmonth = new Date(this._endDate.getFullYear(), this._endDate.getMonth() + 1, 0);
        if (this._endDate.getTime() != new Date(lastDayOfmonth).getTime()) {
            this.savedialogmsg = "End date should be last day of month.";
            return false;
        }

        var lastDayOfmonthFromStartDate = new Date(this._startDate.getFullYear(), this._startDate.getMonth() + 1, 0);
        if (this._endDate.getTime() != new Date(lastDayOfmonthFromStartDate).getTime()) {
            this.savedialogmsg = "Start and end date should belong to the same month. Like, Jan 1, 2019 to Jan 31, 2019.";
            return false;
        }

        if (this.lstPeriodicClose) {
            var maxEndDate;
            var minStartDate;

            maxEndDate = this.lstPeriodicClose[0].MaxEndDate;
            minStartDate = this.lstPeriodicClose[this.lstPeriodicClose.length - 1].StartDate;

            if (this._startDate.getTime() < new Date(minStartDate).getTime()) {
                this.savedialogmsg = "Start date should not be less than the start date of first close.";
                return false;
            }

            if (this._startDate.getTime() == new Date(maxEndDate).getTime()) {
                this.savedialogmsg = "Start date can not be equal to last close date.";
                return false;
            }


            if (this._startDate >= new Date(maxEndDate)) {
                if (this._startDate.getTime() == new Date(new Date(maxEndDate).setDate(new Date(maxEndDate).getDate() + 1)).getTime()) {
                    return true;
                } else {
                    this.savedialogmsg = "Start date should be the next date of the last close date.";
                    return false;
                }
            }




            var isStartDatePeriodexist = false;
            for (var i = 0; i < this.lstPeriodicClose.length; i++) {
                if (this._startDate.getTime() == new Date(this.lstPeriodicClose[i].StartDate).getTime()) {
                    isStartDatePeriodexist = true;
                    break;
                }
            }
            if (isStartDatePeriodexist) {
                this.savedialogmsg = "Period for this date already exist. Please enter different date.";
                return false;
            }

        }


        //if (this._startDate < new Date(maxEndDate)) {
        //    var isStartDateExist = false;
        //    for (var i = 0; i < this.lstPeriodicClose.length; i++) {
        //        if (this._startDate.getTime() == new Date(this.lstPeriodicClose[i].StartDate).getTime()) {
        //            isStartDateExist = true;
        //            break;
        //        }
        //    }
        //    if (isStartDateExist == false) {
        //        this.savedialogmsg = "Please add a new start date or enter any existing start date.";
        //        return false;
        //    }


        //    var isEndDateExist = false;
        //    for (var i = 0; i < this.lstPeriodicClose.length; i++) {
        //        if (this._endDate.getTime() == new Date(this.lstPeriodicClose[i].EndDate).getTime()) {
        //            isEndDateExist = true;
        //            break;
        //        }
        //    }
        //    if (isEndDateExist == false) {
        //        this.savedialogmsg = "Please add a new end date or enter any existing end date.";
        //        return false;
        //    }
        //}

        return ret_value;
    }


  


    getAllPeriodicClose(): void {

        this._isGridShow = false;
        this._isPeriodiccloseSaving = true;
        this.ScenarioId = window.localStorage.getItem("scenarioid");
        this.ScenarioName = window.localStorage.getItem("ScenarioName");
        this._periodic.AnalysisID = this.ScenarioId;

        this._periodicservice.getPeriodicCloseByUserID(this._periodic).subscribe(res => {
            if (res.Succeeded) {
                if (res.TotalCount == 0) {

                    this.lstPeriodicClose = null;
                    this._dvEmptySearchMsg = false;
                    this._isPeriodiccloseSaving = false;
                    setTimeout(() => {
                        this._dvEmptySearchMsg = false;
                    }, 2000);
                } else {
                    this._isGridShow = true;
                    this.lstPeriodicClose = res.lstPeriodicClose;

                    this.lstselectedPeriod = res.lstPeriodicClose;
                    this.lstselectedPeriod = this.lstPeriodicClose.filter(x => x.PeriodAutoID == 0);
                    this.ConvertToBindableDate(this.lstPeriodicClose);

                    setTimeout(() => {
                        this._isPeriodiccloseSaving = false;
                    }, 2000);
                }

            }
        });
        error => {
            this._isPeriodiccloseSaving = false;
            console.error('Error: ' + error);
        }
    }

    private ConvertToBindableDate(Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this.lstPeriodicClose[i].StartDate != null)
                this.lstPeriodicClose[i].StartDate = this.convertDateToBindable(this.lstPeriodicClose[i].StartDate);

            if (this.lstPeriodicClose[i].EndDate != null)
                this.lstPeriodicClose[i].EndDate = this.convertDateToBindable(this.lstPeriodicClose[i].EndDate);

            if (this.lstPeriodicClose[i].CreatedDate != null)
                this.lstPeriodicClose[i].CreatedDate = this.convertDateToBindableWithTime(this.lstPeriodicClose[i].CreatedDate);

        }
    }

    convertDateToBindable(date) {
        var dateObj = new Date(date);
        return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear();
    }

    convertDateToBindableWithTime(date) {
        var dateObj = new Date(date);
        return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear() + " " + dateObj.getHours() + ":" + dateObj.getMinutes() + ":" + dateObj.getSeconds();
    }


    getTwoDigitString(number) {
        if (number.toString().length === 1)
            return "0" + number;
        return number;
    }


    CustomDialogteSave(): void {
        var winW = window.innerWidth;
        var winH = window.innerHeight;
        var dialogbox = document.getElementById('Genericdialogbox');
        document.getElementById('savedialogmessage').innerHTML = this.savedialogmsg;

        dialogbox.style.display = "block";
        $.getScript("/js/jsDrag.js");

    }
    ClosePopUpDialog() {
        var modal = document.getElementById('Genericdialogbox');
        modal.style.display = "none";
    }
    Savedialogbox(): void {

        this.ClosePopUpDialog();
    }

    ClosePopUpConfirmBox() {
        var modal = document.getElementById('customdialogbox');
        modal.style.display = "none";
    }


    ClosePopUpopenperiod() {
        var modal = document.getElementById('customdialogboxopenperiod');
        modal.style.display = "none";
    }



    OpenPeriodicCloseConfirm() {
        if (this.lstselectedPeriod.length > 0) {
            var customdialogbox = document.getElementById('customdialogboxopenperiod');
            this._ConfirmMsgText = 'Are you sure you want to open the period for the selected date(s)?';
            customdialogbox.style.display = "block";
            $.getScript("/js/jsDrag.js");
        }
        else {
            this.savedialogmsg = "Please open at least one period.";
            this.CustomDialogteSave();
        }
    }
    //Confirm msg box


    OpenPeriodicClose() {
        this.ClosePopUpopenperiod();
        if (this.lstselectedPeriod.length > 0) {

            this._isPeriodiccloseSaving = true;
            var PeriodIDs = '';
            for (var i = 0; i < this.lstselectedPeriod.length; i++) {
                PeriodIDs = PeriodIDs + ',' + this.lstselectedPeriod[i].PeriodID
            }

            this._periodic.PeriodIDs = PeriodIDs.slice(1, PeriodIDs.length);
            this._periodic.AnalysisID = this.ScenarioId;
            this._periodicservice.openPeriodicClose(this._periodic).subscribe(res => {
                if (res.Succeeded) {
                    this._startDate = null;
                    this._endDate = null;

                    this.getAllPeriodicClose();

                    this._Showmessagediv = true;
                    this._ShowmessagedivMsg = "Period opened successfully.";

                    setTimeout(function () {
                        this._Showmessagediv = false;
                        this._isPeriodiccloseSaving = false;
                        this._disabled = true;
                    }.bind(this), 2000);
                }
                else
                {
                    this._isPeriodiccloseSaving = false;
                }
            });
            error => {
                console.error('Error: ' + error);
            }
        }
        else {
            this.savedialogmsg = "Please open atleast one period";
            this.CustomDialogteSave();
        }



    }

    ChangeOpenPeriodicClose(id: string, chkvalue: boolean, rowindex: number) {

        var currselected = this.lstPeriodicClose.filter(x => x.PeriodAutoID == id);
        var isValid = true;;
        if (chkvalue == true) {
            this.lstPeriodicClose[rowindex].IsOpenPeriod = true;
            var period = this.lstPeriodicClose.filter(x => (new Date(x.EndDate) > new Date(currselected[0].EndDate) && x.PeriodAutoID != id));


            this.lstselectedPeriod.forEach((e) => {
                period = period.filter(x => x.PeriodAutoID != e.PeriodAutoID);
            });


            //var selected = this.lstselectedPeriod.filter(x => x.PeriodAutoID == id);
            if (period.length > 0) {
                this.savedialogmsg = "You can not open the period on a prior date without opening all period(s) of later date.";
                this.CustomDialogteSave();
                this.lstPeriodicClose[rowindex].IsOpenPeriod = false;
            }
            else {
                this.lstselectedPeriod = this.lstselectedPeriod.concat(this.lstPeriodicClose.filter(x => x.PeriodAutoID == id));
            }

        }
        else {

            var period = this.lstPeriodicClose.filter(x => (new Date(x.EndDate) < new Date(currselected[0].EndDate) && x.PeriodAutoID != id && x.IsOpenPeriod == true));
            if (period.length > 0) {
                this.savedialogmsg = "You can not open the period on a later date without opening all period(s) of prior date.";
                this.CustomDialogteSave();
                this.lstPeriodicClose[rowindex].IsOpenPeriod = true;
            }
            else {
                this.lstPeriodicClose[rowindex].IsOpenPeriod = false;
                this.lstselectedPeriod = this.lstselectedPeriod.filter(x => x.PeriodAutoID != id);
            }
        }
        console.log(this.lstselectedPeriod);
        setTimeout(function () {
            this.flexperiodicclose.invalidate();
        }.bind(this), 1000);

    }

}

const routes: Routes = [

    { path: '', component: PeriodicCloseComponent }]

@NgModule({
    // imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjInputModule, WjGridFilterModule],
    imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjGridModule, WjInputModule, WjGridFilterModule, Ng2FileInputModule.forRoot()],
    declarations: [PeriodicCloseComponent]
})

export class PeriodicCloseModule { }