import { Component, OnInit, AfterViewInit, ViewChild, Injectable, Input, Output } from "@angular/core";
import { Router, RouterLink, CanActivate, ActivatedRoute, Params } from '@angular/router';
import { ModuleWithProviders, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { UtilityService } from '../core/services/utilityService';
import { TranscationreconciliationService } from './../core/services/TranscationreconciliationService';
import { RouterModule, Routes } from '@angular/router';
import { Headers, RequestOptions, BaseRequestOptions } from '@angular/http';
import * as wjNg2Input from 'wijmo/wijmo.angular2.input';
import { WjCoreModule } from 'wijmo/wijmo.angular2.core';
import { WjGridModule } from 'wijmo/wijmo.angular2.grid';
import { WjInputModule } from 'wijmo/wijmo.angular2.input';
import { WjGridFilterModule } from 'wijmo/wijmo.angular2.grid.filter';
import * as wjNg2Core from 'wijmo/wijmo.angular2.core';
import * as wjcGrid from 'wijmo/wijmo.grid';
import * as wjcGridXlsx from 'wijmo/wijmo.grid.xlsx';
import * as wjcCore from 'wijmo/wijmo';
declare var $: any;


@Component({
    templateUrl: "app/components/TransactionAuditDetail.html?v=" + $.getVersion(),
    providers: [TranscationreconciliationService]
})



export class TransactionAuditDetailComponent {
    public lsttranscationaudit: any;
    public lsttransauditcnt: any;
    public batchid: any;
    private _istranscationFetching: boolean = false;

    constructor(private activatedRoute: ActivatedRoute,
        public utilityService: UtilityService,
        public transserv: TranscationreconciliationService,
        private _router: Router) {
        this.utilityService.setPageTitle("M61-Transaction Audit Details");

        this.activatedRoute.params.forEach((params: Params) => {
            if (params['batchid'] !== undefined) {
                this.batchid= params['batchid'];
            }
        });
        this.GettranscationauditByBatchid(this.batchid);
    }

    GettranscationauditByBatchid(batchid): void {
        this._istranscationFetching = true;
        this.transserv.getTranscationAuditDetail(batchid).subscribe(res => {
            if (res.Succeeded) {
                this.lsttranscationaudit = res.dtTestCase;                
                //format date
                for (var i = 0; i < this.lsttranscationaudit.length; i++) {
                    if (this.lsttranscationaudit[i].DueDate != null) {
                        this.lsttranscationaudit[i].DueDate = new Date(this.lsttranscationaudit[i].DueDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                    }
                    if (this.lsttranscationaudit[i].RemitDate != null) {
                        this.lsttranscationaudit[i].RemitDate = new Date(this.lsttranscationaudit[i].RemitDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                    }
                    if (this.lsttranscationaudit[i].TransactionDate != null) {
                        this.lsttranscationaudit[i].TransactionDate = new Date(this.lsttranscationaudit[i].TransactionDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                    }
                }
                this._istranscationFetching = false;
            }
        })
    }
    

    BackAuditSummary():void {
         this._router.navigate(['Transactionaudit']);
    }

}



const routes: Routes = [

    { path: '', component: TransactionAuditDetailComponent }]

@NgModule({
    imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjInputModule, WjGridFilterModule],
    declarations: [TransactionAuditDetailComponent]
})

export class TransactionAuditDetailComponentModule {

}
