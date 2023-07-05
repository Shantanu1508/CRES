import { Component, OnInit, AfterViewInit, ViewChild, Injectable } from "@angular/core";
import { Router, RouterLink, CanActivate, ActivatedRoute } from '@angular/router';
import { dealService } from '../../core/services/dealservice';
import { deals } from "../../core/domain/deals";
import { ImportUnderwritingService } from '../../core/services/ImportUnderwritingService';
import { PermissionService } from '../../core/services/PermissionService';
import { isLoggedIn } from '../../core/services/is-logged-in';
import { UtilityService } from '../../core/services/utilityService';
import { backshopImport } from '../../core/domain/backshopImport';
import { ModuleWithProviders, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { Headers, RequestOptions, BaseRequestOptions } from '@angular/http';
import * as wjcCore from 'wijmo/wijmo';
import * as wjcGrid from 'wijmo/wijmo.grid';
//import { WjCoreModule } from 'wijmo/wijmo.angular2.core';
import { WjGridModule } from 'wijmo/wijmo.angular2.grid';
import { WjGridFilterModule } from 'wijmo/wijmo.angular2.grid.filter';
@Component({
    // selector: "ImportUnderwriting",
    templateUrl: "app/components/ImportExport/ImportUnderwriting.html",
    providers: [ImportUnderwritingService, PermissionService, UtilityService, dealService],
})

export class ImportUnderwritingComponent {
    //private routes = Routes;
    public _backshopImport: backshopImport;
    public dealName;
    public username;
    public messagetext: any;
    public tt: any;
    private _dvDealImport: boolean = false;
    private _dvDealImportMsg: string = '';

    public isProcessComplete: boolean = true;

    constructor(//private _routeParams: RouteParams,
        public dealSrv: dealService,
        public importUnderwritingService: ImportUnderwritingService,
        public permissionService: PermissionService,
        public utilityService: UtilityService,
        private _router: Router) {
        this._backshopImport = new backshopImport('', '');
        this._deal = new deals('');
        this.isProcessComplete = false;
        this.GetUserPermission();
        this.utilityService.setPageTitle("M61-Integration");
    }
    private _deal: deals;

    ImportBackShopInUnderwritingtable(): void {
        this.isProcessComplete = true;
        this._dvDealImport = false;
        this._dvDealImportMsg = '';

        var _userData = JSON.parse(localStorage.getItem('user'));
        this._backshopImport.UserName = _userData.UserID;

      
        this._deal.CREDealID = this._backshopImport.DealName;
       this._deal.DealName = this._backshopImport.DealName;
      
        this.dealSrv.checkduplicatedeal(this._deal).subscribe(res => {
            if (res.Succeeded) {
                this.messagetext = "Deal Id " + this._deal.CREDealID + " already exist, do you want to override existing deal information?"
                this.showDialog();
            }
            else {
                this.Importdealfrombackshoptoin_underwriting();
            }
        });

        //this.importUnderwritingService.getINUnderwritingDealByDealIdorDealName(this._backshopImport).subscribe(res => {
        //    if (res.Succeeded) {
        //        this.messagetext = res.Message;
        //        this.showDialog();                 
        //    }
        //    else {
        //        this.Importdealfrombackshoptoin_underwriting();
        //    }
        //});
    }

    Importdealfrombackshoptoin_underwriting(): void {
        //Import deal from backshop to in_underwriting
        this.importUnderwritingService.ImportBackShopInUnderwritingtable(this._backshopImport).subscribe(res => {
            if (res.Succeeded) {
                this.isProcessComplete = false;
                this._backshopImport = res.BackShopImportDataContract;
                localStorage.setItem('backshopImport', JSON.stringify(this._backshopImport));

                this._router.navigate(['\IN_UnderwritingDealDetail']);
            }
            else {
                this.isProcessComplete = false;
                this._dvDealImport = true;
                this._dvDealImportMsg = res.Message;
            }
        });
    }

    GetUserPermission(): void {
        this.permissionService.GetUserPermissionByPagename("Integration").subscribe(res => {
            if (res.Succeeded) {
                if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                }
                else {
                    localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                    localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));

                    this.utilityService.navigateUnauthorize();
                }
            }
        });
    }

    showDialog() {
        var customdialogbox = document.getElementById('customdialogbox');
        customdialogbox.style.display = "block";
        $.getScript("/js/jsDrag.js");
    }

    startimportprocess() {
        this.Importdealfrombackshoptoin_underwriting();
    }

    ClosePopUp() {
        var modal = document.getElementById('customdialogbox');
        modal.style.display = "none";
        this.isProcessComplete = false;
    }
}

const routes: Routes = [

    { path: '', component: ImportUnderwritingComponent }]

@NgModule({
    imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjGridModule, WjGridFilterModule],
    declarations: [ImportUnderwritingComponent]
})

export class ImportUnderwritingModule { }