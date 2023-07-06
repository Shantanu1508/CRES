import {Component, OnInit, AfterViewInit, ViewChild, Injectable} from "@angular/core";
import { Router, RouterLink, CanActivate, ActivatedRoute} from '@angular/router';
import {FinancingWarehouse} from "../core/domain/financingWarehouse"
import * as wjNg2Grid from 'wijmo/wijmo.angular2.grid';
import { OperationResult } from '../core/domain/operationResult';
import { financingWarehouseService } from '../core/services/financingWarehouseService';
import { NotificationService } from '../core/services/notificationService'
//import { Routes, APP_ROUTES } from '../routes.Config';
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

@Component({
    selector: "FinancingWarehouse",
    templateUrl: "app/components/financingWarehouse.html",
    providers: [financingWarehouseService, NotificationService] 
})

//@CanActivate((next: ComponentInstruction, previous: ComponentInstruction) => {
//    return isLoggedIn(next, previous);
//})

@Injectable()
export class FinancingWareComponent extends Paginated {
    private _financingWarehouse: FinancingWarehouse;
    //private routes = Routes;

    private _dvEmptyFiancingSearchMsg: boolean = false;
    private _Showmessagediv: boolean = false;
    private _ShowmessagedivMsg: string = '';
    private _isFinancingListFetching: boolean = false;
    private _dvEmptyFinancingSearchMsg: boolean = false;
    financingaddpath: any;

    lstfinancingWarehouse: any;
    @ViewChild('flex') flex: wjcGrid.FlexGrid;
    constructor(private _router: Router,
        public financingsvc: financingWarehouseService,
        public utilityService: UtilityService,
        public notificationService: NotificationService,       
        private _actrouting: ActivatedRoute) {
        super(50, 1, 0);
        //  this._note = new Note("75385E05-A73F-4BFE-AFEB-7214CB436F26");
        // this._note = new Note('');
        this.utilityService.setPageTitle("M61-Financing");
        this.getAllfinancingWarehouse();
    }

    ngAfterViewInit() {
        // commit row changes when scrolling the grid
        this.flex.scrollPositionChanged.addHandler(() => {
            var myDiv = $('#flex').find('div[wj-part="root"]');
            if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
                if (this.flex.rows.length < this._totalCount) {
                    this._pageIndex = this.pagePlus(1);
                    this.getAllfinancingWarehouse();
                }
            }
        });
    }

    getAllfinancingWarehouse(): void {
        if (localStorage.getItem('divSucessFinancing') == 'true') {
            this._Showmessagediv = true;
            this._ShowmessagedivMsg = localStorage.getItem('divSucessMsgFinancing');
            this._ShowmessagedivMsg = (this._ShowmessagedivMsg.replace('\"', '')).replace('\"', '');
            localStorage.setItem('divSucessFinancing', JSON.stringify(false));
            localStorage.setItem('divSucessMsgFinancing', JSON.stringify(''));
            //to hide _Showmessagediv after 5 sec
            setTimeout(function () {
                this._Showmessagediv = false;
                console.log(this._Showmessagediv);
            }.bind(this), 5000);
        }

        this._isFinancingListFetching = true;
        this.financingsvc.GetAllFinancingWarehouse(this._pageIndex, this._pageSize).subscribe(res => {
            if (res.Succeeded) {
                //------------------
                var data: any = res.lstFinancingWarehouseDataContract;
                this._totalCount = res.TotalCount;

                if (this._pageIndex == 1) {
                    this.lstfinancingWarehouse = data;
                    //remove first cell selection
                    this.flex.selectionMode = wjcGrid.SelectionMode.None;

                    if (res.TotalCount == 0) {
                        this._dvEmptyFinancingSearchMsg = true;
                    }
                }
                else {
                    //data.forEach((obj, i) => {
                    //    this.flex.rows.push(new wjcGrid.Row(obj));
                    //});
                    this.lstfinancingWarehouse.concat(data);
                }
                this._isFinancingListFetching = false;

                if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                }
                else {
                    localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                    localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));

                    this.utilityService.navigateUnauthorize();
                }

                //-------------------
            }
            else {
                this.utilityService.navigateToSignIn();
            }
        });
        error => console.error('Error: ' + error)
    }

    AddNewFinancing(): void {
        //this.financingaddpath = ['/financingdetail', { id: "00000000-0000-0000-0000-000000000000" }]
        ////      alert("AddNewDeal");
        //this._router.navigate(this.financingaddpath)

        this._router.navigate(['/financingdetail', "00000000-0000-0000-0000-000000000000"]);
    }
}


const routes: Routes = [

    { path: '', component: FinancingWareComponent }]

@NgModule({
    imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjGridFilterModule],
    declarations: [FinancingWareComponent]

})

export class FinancingWareModule { }
