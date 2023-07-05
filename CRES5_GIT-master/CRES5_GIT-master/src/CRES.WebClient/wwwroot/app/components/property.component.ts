import { Component, OnInit, AfterViewInit, ViewChild, Injectable } from "@angular/core";
import { Router, RouterLink, CanActivate, ActivatedRoute } from '@angular/router';
import {Property} from "../core/domain/Property"
import * as wjNg2Grid from 'wijmo/wijmo.angular2.grid';
import { OperationResult } from '../core/domain/operationResult';
import { propertyService } from '../core/services/propertyService';
import { NotificationService } from '../core/services/notificationService'
import {isLoggedIn} from '../core/services/is-logged-in';
import { UtilityService } from '../core/services/utilityService';

//import { Routes, APP_ROUTES } from '../routes.Config';
import { Paginated } from '../core/common/paginated';
import * as wjNg2GridFilter from 'wijmo/wijmo.angular2.grid.filter';
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
  //  selector: "property",
    templateUrl: "app/components/Property.html",
    providers: [propertyService, NotificationService]
  
})
//@CanActivate((next: ComponentInstruction, previous: ComponentInstruction) => {
//    return isLoggedIn(next, previous);
//})

export class Propertycomponent extends Paginated {
   // private routes = Routes;
    lstproperties: any;
    private _formatting = true;
    private updatedRowNo: any = [];
    private rowsToUpdate: any = [];
    private _prop: Property
    private _isPropertyListFetching: boolean = false;
    private _dvEmptyPropertySearchMsg: boolean = false;

    @ViewChild('flex') flex: wjcGrid.FlexGrid;
    alwaysEdit = false;
    private updatedValue: Property;
    constructor(private _router: Router, public propertysvc: propertyService,
        public notificationService: NotificationService,
        public utilityService: UtilityService
    ) {       
        super(50, 1, 0);
        this._prop = new Property('');
        this.getAllproperty(this._prop);
        this.utilityService.setPageTitle("M61-Properties");
    }

    // Component views are initialized
    ngAfterViewInit() {
        //== this._updateFormatting();

        // commit row changes when scrolling the grid
        this.flex.scrollPositionChanged.addHandler(() => {
            var myDiv = $('#flex').find('div[wj-part="root"]');
            if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
                //alert('this.flex.rows.length ' + this.flex.rows.length + 'this._totalCount ' + this._totalCount);
                if (this.flex.rows.length < this._totalCount) {
                    this._pageIndex = this.pagePlus(1);
                    this.getAllproperty(this._prop);
                }
            }
        });
    }

    getAllproperty(_prop: Property): void {
        this._isPropertyListFetching = true;
        _prop.Deal_DealID = '';
        this.propertysvc.getallproperty(_prop, this._pageIndex, this._pageSize).subscribe(res => {
            if (res.Succeeded) {
                if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                    var data: any = res.lstProperty;

                    this._totalCount = res.TotalCount;

                    if (this._pageIndex == 1) {
                        this.lstproperties = data;

                        //remove first cell selection
                        this.flex.selectionMode = wjcGrid.SelectionMode.None;

                        if (res.TotalCount == 0) {
                            this._dvEmptyPropertySearchMsg = true;
                            //setTimeout(() => {
                            //    this._dvEmptyPropertySearchMsg = false;
                            //}, 2000);
                        }
                    }
                    else {
                        //data.forEach((obj, i) => { // FETCH ALL DATA AND PUSH IN FLEX GRID!!!
                        //    this.flex.rows.push(new wjcGrid.Row(obj));
                        //});
                        this.lstproperties.concat(data);
                    }
                    this.ConvertToBindableDate(this.lstproperties);
                    this._isPropertyListFetching = false;
                }
                else {
                    localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                    localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));

                    this.utilityService.navigateUnauthorize();
                }
            }
            else {
                this._router.navigate(['/login']);
            }
        });
        error => console.error('Error: ' + error)
    }

    selectionChangedHandler() {
        var flex = this.flex;
        var rowIdx = this.flex.collectionView.currentPosition;
        try {
            var count = this.updatedRowNo.indexOf(rowIdx);
            if (count == -1)
                this.updatedRowNo.push(rowIdx);
        }
        catch (err) {
            console.log(err);
        }
    }

    UpdateProperty(): void {
        try {
            this.rowsToUpdate = [];
            for (var i = 0; i < this.updatedRowNo.length; i++) {
                this.rowsToUpdate.push(this.lstproperties[this.updatedRowNo[i]]);
            }
        }
        catch (err) {
            console.log(err);
        }

        this._prop = this.rowsToUpdate

        this.propertysvc.AddupdateProperty(this._prop).subscribe(res => {
            if (res.Succeeded) {
                //  alert("Succeed");
            }
            else {
                //     this._router.navigate([this.routes.login.name]);
                //  alert("Fail");
            }
        });
        error => console.error('Error: ' + error)
    }

    

    private ConvertToBindableDate(Data) {
        for (var i = 0; i < Data.length; i++) {
            this.lstproperties[i].CreatedDate = new Date(Data[i].CreatedDate);
        }
    }
}



const routes: Routes = [

    { path: '', component: Propertycomponent }]

@NgModule({
    imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjGridFilterModule],
    declarations: [Propertycomponent]

})

export class PropertyModule { }