
import { Component, OnInit, AfterViewInit, ViewChild } from "@angular/core";
import { Router, ActivatedRoute } from '@angular/router';
import { deals } from "../core/domain/deals";
import { OperationResult } from '../core/domain/operationResult';
import { dealService } from '../core/services/dealService';
import { NotificationService } from '../core/services/notificationService'
import { User } from '../core/domain/user';
import { NgModule } from '@angular/core';
import { UtilityService } from '../core/services/utilityService';
import { Paginated } from '../core/common/paginated';
import * as wjcCore from 'wijmo/wijmo';
import * as wjcGrid from 'wijmo/wijmo.grid';
import { ModuleWithProviders } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import * as wjcGridFilter from 'wijmo/wijmo.grid.filter';
import { Headers, RequestOptions, BaseRequestOptions } from '@angular/http';
import { WjCoreModule } from 'wijmo/wijmo.angular2.core';
import { WjGridModule } from 'wijmo/wijmo.angular2.grid';
import { WjGridFilterModule } from 'wijmo/wijmo.angular2.grid.filter';
import { WjInputModule } from 'wijmo/wijmo.angular2.input';
declare var $: any;  

@Component({
    selector: "deal",
    templateUrl: "app/components/deal.html?v=" + $.getVersion(),
    providers: [dealService, NotificationService]   
})


export class DealListComponent extends Paginated {
   
    dealMessage: string;
    userid: number;
    lstdeals: any;
    private _deals: Array<deals>;
    private userobj: User;
    dealaddpath: any;
    private _dealListFetching: boolean = false;
    private _ShowmessagedivMsgWar: boolean = false;
    private _dvEmptyDealSearchMsg: boolean = false;
    private _Showmessagediv: boolean = false;
    private _ShowmessagedivMsg: string = '';
    private _WaringMessage: string = '';
    private _isshowDealbutton: boolean = false;
    private _isShowActivityLog: boolean = false;

    @ViewChild('flex') flex: wjcGrid.FlexGrid;
    @ViewChild('filter') gridFilter: wjcGridFilter.FlexGridFilter;
    constructor(public dealSrv: dealService,
        public utilityService: UtilityService,
        public notificationService: NotificationService,
        private _router: Router) {
        super(30, 1, 0);
        this._isshowDealbutton = false;
        this.getDeals();
        this.utilityService.setPageTitle("M61–Deals");
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
                    this.getDeals();
                  
                }
            }
        });
    }

    getDeals(): void {        
        if (localStorage.getItem('divSucessDeal') == 'true') {
            this._Showmessagediv = false; //Vishal
            this._ShowmessagedivMsg = localStorage.getItem('divSucessMsgDeal');
            this._ShowmessagedivMsg = (this._ShowmessagedivMsg.replace('\"', '')).replace('\"', '');
            localStorage.setItem('divSucessDeal', JSON.stringify(false));
            localStorage.setItem('divSucessMsgDeal', JSON.stringify(''));

            
            setTimeout(function () {
                this._Showmessagediv = false;
                console.log(this._Showmessagediv);
            }.bind(this), 5000);
        }

        if (localStorage.getItem('divWarningMsgDeal') == 'true') {
            this._ShowmessagedivMsgWar = true;
            this._WaringMessage = localStorage.getItem('divWarningMsg');
            this._WaringMessage = (this._WaringMessage.replace('\"', '')).replace('\"', '');
            localStorage.setItem('divWarningMsgDeal', JSON.stringify(false));
            localStorage.setItem('divWarningMsg', JSON.stringify(''));
            setTimeout(function () {
                this._ShowmessagedivMsgWar = false;
            }.bind(this), 5000);
        }

        this._dealListFetching = true;
        this.dealSrv.getAllDeals(this._pageIndex, this._pageSize)
            .subscribe(res => {
                if (res.Succeeded) {

                    if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {

                        var data: any = res.lstDeals;
                        this._totalCount = res.TotalCount;

                        
                        if (this._pageIndex == 1) {
                            this.lstdeals = data;

                            //remove first cell selection
                            this.flex.selectionMode = wjcGrid.SelectionMode.None;

                            if (res.TotalCount == 0) {
                                this._dvEmptyDealSearchMsg = true;
                                this._dealListFetching = false;
                            } else {
                                setTimeout(() => {
                                    this._dealListFetching = false;                                   
                                }, 2000);
                            }


                            setTimeout(() => {
                                this.ApplyPermissions(res.UserPermissionList);
                            }, 2000);


                            //format date
                            for (var i = 0; i < this.lstdeals.length; i++) {
                                if (this.lstdeals[i].FullyExtMaturityDate != '0001-01-01T00:00:00') {
                                    if (this.lstdeals[i].FullyExtMaturityDate == null) {
                                        this.lstdeals[i].FullyExtMaturityDate = null;
                                    } else {
                                        this.lstdeals[i].FullyExtMaturityDate = new Date(this.lstdeals[i].FullyExtMaturityDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                                    }
                                }
                                else {
                                    this.lstdeals[i].FullyExtMaturityDate = null;
                                }

                                if (this.lstdeals[i].EstClosingDate != '0001-01-01T00:00:00') {
                                    if (this.lstdeals[i].EstClosingDate != null) {
                                        this.lstdeals[i].EstClosingDate = new Date(this.lstdeals[i].EstClosingDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                                    }
                                }
                                else {
                                    this.lstdeals[i].EstClosingDate = null;
                                }
                            }
                            
                        }
                        else {
                           
                            data.forEach((obj, i) => { // FETCH ALL DATA AND PUSH IN FLEX GRID!!!
                                //format date

                                if (obj.FullyExtMaturityDate != '0001-01-01T00:00:00') {
                                    if (obj.FullyExtMaturityDate == null) {
                                        obj.FullyExtMaturityDate = null;
                                    } else {
                                        obj.FullyExtMaturityDate = new Date(obj.FullyExtMaturityDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                                    }
                                }
                                else {
                                    obj.FullyExtMaturityDate = null;
                                }
                                if (obj.EstClosingDate != '0001-01-01T00:00:00') {
                                    if (obj.EstClosingDate != null) {
                                        obj.EstClosingDate = new Date(obj.EstClosingDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                                    }
                                }
                                else {
                                    obj.EstClosingDate = null;
                                }                               
                                
                                //this.flex.rows.push(new wjcGrid.Row(obj));
                            });
                            this.lstdeals = this.lstdeals.concat(data);
                            
                        }
                        
                        this._dealListFetching = false;

                        setTimeout(function () {
                            this.flex.invalidate();
                            //this.flex.autoSizeColumns(0, this.flex.columns.length, false, 20);
                            //this.flex.columns[0].width = 350; // for Note Id
                        }.bind(this), 1);

                    } else {
                        this.utilityService.navigateUnauthorize();
                    }
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

    ApplyPermissions(_object): void {

        var buttonarray = _object.filter(function (item) { return item.ModuleType === 'Control' && item.RightsName === 'Edit'; });

        if (buttonarray.length > 0 && typeof buttonarray != 'undefined') {
            this._isshowDealbutton = true;
        }
        this._isShowActivityLog = true;
    }
    AddNewDeal(): void {        
        this._router.navigate(['/dealdetail', "00000000-0000-0000-0000-000000000000"]);
    }

    clickeddeal() {
        this._dealListFetching = true;
    }
}


const routes: Routes = [

    { path: '', component: DealListComponent }]

@NgModule({
    imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule,  WjGridFilterModule],
    declarations: [DealListComponent]
})

export class DealListModule { }

