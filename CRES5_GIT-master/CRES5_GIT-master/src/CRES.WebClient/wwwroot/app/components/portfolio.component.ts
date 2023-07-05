import { Component, OnInit, Inject, Compiler, ViewChild } from '@angular/core';
import { Router, ActivatedRoute, Params, Route } from '@angular/router';
import { portfolio } from "../core/domain/portfolio";
import { IndexType } from "../core/domain/indexType";
import * as wjNg2Grid from 'wijmo/wijmo.angular2.grid';
import { OperationResult } from '../core/domain/operationResult';
import { scenarioService } from '../core/services/scenarioService';
import { NotificationService } from '../core/services/notificationService'
import { NoteService } from '../core/services/NoteService'
import { MembershipService } from '../core/services/membershipservice';

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
import { WjInputModule } from 'wijmo/wijmo.angular2.input';
import { portfolioService } from '../core/services/portfolioService'
declare var $: any;  

@Component({
    selector: "portfolio",
    templateUrl: "app/components/portfolio.html?v=" + $.getVersion(),
    providers: [NoteService, NotificationService, UtilityService, portfolioService],
})

export class PortfolioComponent {
    cvScenarioDetaildata: wjcCore.CollectionView;
    private TotalCount: number = 0;
    private _portfolio: portfolio;
    private _ShowmessagedivMsgWar: any;
    private _ShowmessagedivWar: boolean = false;
    private Message: any = '';
    private _Showmessagediv: boolean = false;
    
    private _ShowSuccessmessagediv: boolean = false;
    private _ShowSuccessmessage: any;
    // private routes = Routes;
    private _isPortfolioListFetching: boolean = true;
    lstPortfolio: any
    @ViewChild('flexportfolio') flexportfolio: wjcGrid.FlexGrid;
    private _isNoRecord: boolean = false;
   
    constructor(private activatedRoute: ActivatedRoute,
        private _router: Router,
        public noteService: NoteService,
        public utilityService: UtilityService,
        public notificationService: NotificationService,
        public membershipService: MembershipService,
        public _portfolioService: portfolioService
    ) {
        this.GetAllPortfolio();
        this.utilityService.setPageTitle("M61 – Dynamic Portfolio");
    }



    GetAllPortfolio(): void {
        if (localStorage.getItem('divSucessPortfolio') == 'true') {
            this._ShowSuccessmessagediv = true;
            this._ShowSuccessmessage = localStorage.getItem('successmsgPortfolio');
            this._ShowSuccessmessage = (this._ShowSuccessmessage.replace('\"', '')).replace('\"', '');
            localStorage.setItem('divSucessPortfolio', JSON.stringify(false));
            localStorage.setItem('successmsgPortfolio', JSON.stringify(''));

            //to hide _Showmessagediv after 5 sec
            setTimeout(function () {
                this._ShowSuccessmessagediv = false;
            }.bind(this), 5000);

            setTimeout(function () {
                if (this.flexportfolio) {
                    this.flexportfolio.autoSizeColumns(0, this.flex.columns.length, false, 20);
                    this.flexportfolio.columns[0].width = 350; // for Note Id
                }
            }.bind(this), 1);

        }

        this._portfolioService.getallportfolio().subscribe(res => {
            if (res.Succeeded) {
                if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                    var data = res.lstportfolio;
                    this.lstPortfolio = data;
                    this.TotalCount = data.lenght;
                    this._isNoRecord = this.lstPortfolio.length == 0 ? true : false;
                    setTimeout(function () {
                        if (this.TotalCount>0)
                            this.flexportfolio.selectionMode = wjcGrid.SelectionMode.None;
                        this._isPortfolioListFetching = false;
                    }.bind(this), 200);
                }
                else {

                    localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                    localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));
                    this.utilityService.navigateUnauthorize();
                }
            }
            else {
                this.utilityService.navigateToSignIn();
            }

        });
    }

    AddNewPortfolio(): void {
        this._router.navigate(['/portfoliodetail', "00000000-0000-0000-0000-000000000000"]);
    }


    
}

const routes: Routes = [

    { path: '', component: PortfolioComponent }]

@NgModule({
    imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjGridFilterModule, WjInputModule],
    declarations: [PortfolioComponent]
})

export class PortfolioModule { }