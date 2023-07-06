import { Component, OnInit, Inject, Compiler, AfterViewInit, ViewChild } from '@angular/core';
import { Router, ActivatedRoute, Params, Route } from '@angular/router';
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
//import { Location, LocationStrategy, HashLocationStrategy } from '@angular/common';
import { Headers, RequestOptions, BaseRequestOptions } from '@angular/http';
import { WjCoreModule } from 'wijmo/wijmo.angular2.core';
import { WjGridModule } from 'wijmo/wijmo.angular2.grid';
import { WjGridFilterModule } from 'wijmo/wijmo.angular2.grid.filter';
declare var $: any; 
@Component({
    selector: "indexes",
    templateUrl: "app/components/indexes.html?v=" + $.getVersion(),
    providers: [indexesService, NotificationService]
})

export class IndexesComponent extends Paginated {
    private _indexes: indexesService;
     private indexesdata: any
    private TotalCount: number = 0;
    private indexesupdatedRowNo: any = [];
    sindexesaddpath: any;
    private indexesToUpdate: any = [];
    lstIndexesData: any;

    private Message: any = '';
    private _ShowSuccessmessagediv: boolean = false;
    private _ShowSuccessmessage: any;
    // private routes = Routes;
    private _isIndexesListFetching: boolean = true;
    private _isshowIndexesAddbutton: boolean = false;
    private _dvEmptyIndexesSearchMsg: boolean = false;

    @ViewChild('flexindexes') flexIndexes: wjcGrid.FlexGrid;

    constructor(private _router: Router,
        public indexesService: indexesService,
        public utilityService: UtilityService,
        public notificationService: NotificationService) {
        super(30, 1, 0);
        this.GetAllIndexes();

        this.utilityService.setPageTitle("M61–Indexes");
    }

    // Component views are initialized
    ngAfterViewInit() {
        // commit row changes when scrolling the grid

        this.flexIndexes.scrollPositionChanged.addHandler(() => {
            var myDiv = $('#flex').find('div[wj-part="root"]');

            if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
                if (this.flexIndexes.rows.length < this._totalCount) {
                    this._pageIndex = this.pagePlus(1);
                    this.GetAllIndexes();
                }
            }
        });
    }

    GetAllIndexes(): void {
        
        this._isIndexesListFetching = true;
        if (localStorage.getItem('divSucessIndexes') == 'true') {
            this._ShowSuccessmessagediv = true;
            this._ShowSuccessmessage = localStorage.getItem('successmsgindexes');
            this._ShowSuccessmessage = (this._ShowSuccessmessage.replace('\"', '')).replace('\"', '');
            localStorage.setItem('divSucessIndexes', JSON.stringify(false));
            localStorage.setItem('successmsgindexes', JSON.stringify(''));

            //to hide _Showmessagediv after 5 sec
            setTimeout(function () {
                this._ShowSuccessmessagediv = false;
            }.bind(this), 5000);

            setTimeout(function () {
                if (this.flexIndexes) {
                    this.flexIndexes.autoSizeColumns(0, this.flex.columns.length, false, 20);
                    this.flexIndexes.columns[0].width = 350; // for Note Id
                }
            }.bind(this), 1);

        }

       
        this.indexesService.GetAllIndexesMaster(this._pageIndex, this._pageSize)
            .subscribe(res => {
                if (res.Succeeded) {

                    if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {

                        var data: any = res.lstIndexesMaster;
                        this._totalCount = res.TotalCount;


                        if (this._pageIndex == 1) {
                            this.lstIndexesData = data;

                            //remove first cell selection
                            this.flexIndexes.selectionMode = wjcGrid.SelectionMode.None;
                            
                            if (res.TotalCount == 0) {
                                this._dvEmptyIndexesSearchMsg = true;
                                this._isIndexesListFetching = false;
                            } else {
                                setTimeout(() => {
                                    this._isIndexesListFetching = false;
                                }, 2000);
                            }


                            setTimeout(() => {
                                this.ApplyPermissions(res.UserPermissionList);
                            }, 2000);                           

                        }
                        else {

                            data.forEach((obj, i) => { // FETCH ALL DATA AND PUSH IN FLEX GRID!!!
                                    //this.flex.rows.push(new wjcGrid.Row(obj));
                            });
                            this.lstIndexesData = this.lstIndexesData.concat(data);

                        }

                        this._isIndexesListFetching = false;

                        setTimeout(function () {
                            this.flex.invalidate();
                            this.flex.autoSizeColumns(0, this.flex.columns.length, false, 20);
                            this.flex.columns[0].width = 150; // for Indexes name Id
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

    ShowSuccessmessageDiv(msg) {
        this._ShowSuccessmessagediv = true;
        this._ShowSuccessmessage = msg;
        setTimeout(function () {
            this._ShowSuccessmessagediv = false;
        }.bind(this), 5000);
    }

    ApplyPermissions(_object): void {

        for (var i = 0; i < _object.length; i++) {
            if (_object[i].ChildModule == 'btnAddIndex') {
                this._isshowIndexesAddbutton = true;
            }
        }

        //var buttonarray = _object.filter(function (item) { return item.ModuleType === 'Control' && item.RightsName === 'Edit'; });

        //if (buttonarray.length > 0 && typeof buttonarray != 'undefined') {
        //    this._isshowIndexesAddbutton = true;
        //}
    }

    AddNewIndexes(): void {
        this._router.navigate(['/indexesdetail', "00000000-0000-0000-0000-000000000000"]);
    }   
}


const routes: Routes = [

    { path: '', component: IndexesComponent }]

@NgModule({
    imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjGridFilterModule],
    declarations: [IndexesComponent]

})

export class IndexesModule { }