import { Component, OnInit, AfterViewInit, ViewChild, Injectable } from "@angular/core";
import { Router, RouterLink, CanActivate, ActivatedRoute,Params } from '@angular/router';
import { ImportUnderwritingService } from '../../core/services/ImportUnderwritingService';
import {isLoggedIn} from '../../core/services/is-logged-in';
import {backshopImport} from '../../core/domain/backshopImport';
import {IN_UnderwritingNotes} from '../../core/domain/IN_UnderwritingNotes';
import { UtilityService } from '../../core/services/utilityService';
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
   
    templateUrl: "app/components/ImportExport/IN_UnderwritingNoteDetail.html",
    providers: [ImportUnderwritingService]
   
})

//@CanActivate((next: ComponentInstruction, previous: ComponentInstruction) => {
//    return isLoggedIn(next, previous);
//})


export class IN_UnderwritingNoteDetailComponent {


   // private routes = Routes;
    public _in_UnderwritingNotes: IN_UnderwritingNotes;
    public lstINUnderwritingRateSpreadSchedule: any;
    public lstINUnderwritingStrippingSchedule: any;
    public lstINUnderwritingPIKSchedule: any;
    public lstIN_UnderwritingFundingSchedule: any;
    
   
    public lstIN_UnderwritingNotes: any;
    public IN_UnderwritingNotesDC: any;
     IN_UnderwritingNoteID:any
     constructor(private _activatedRoute: ActivatedRoute, public importUnderwritingService: ImportUnderwritingService, private _router: Router, public utilityService: UtilityService) {
        
        this._in_UnderwritingNotes = new IN_UnderwritingNotes('', '', '');
        this._activatedRoute.params.forEach((params: Params) => {
            if (params['in_UnNoteid'] !== undefined) {
                this.IN_UnderwritingNoteID= params['in_UnNoteid'];
            }
        });   

       // var IN_UnderwritingNoteID = _routeParams.get('in_UnNoteid');

        this._in_UnderwritingNotes.IN_UnderwritingNoteID = this.IN_UnderwritingNoteID;

        this.lstIN_UnderwritingNotes = JSON.parse(localStorage.getItem('lstIN_UnderwritingNotes'));


        this.GetINUnderwritingRateSpreadScheduleByNoteID();


        
        for (var i = 0; i < this.lstIN_UnderwritingNotes.length; i++) {
            if (this.lstIN_UnderwritingNotes[i].IN_UnderwritingNoteID == this.IN_UnderwritingNoteID) {
                this.IN_UnderwritingNotesDC = this.lstIN_UnderwritingNotes[i];
                break;
            }
        }

         this.utilityService.setPageTitle("M61-Integration Note");
    }



    GetINUnderwritingRateSpreadScheduleByNoteID(): void {

        this.importUnderwritingService.GetINUnderwritingRateSpreadScheduleByNoteID(this._in_UnderwritingNotes).subscribe(res => {
            if (res.Succeeded) {
                var data: any = res.lstIN_UnderwritingRateSpreadScheduleDataContractList;
                this.lstINUnderwritingRateSpreadSchedule = data;

                this.ConvertToBindableDate(this.lstINUnderwritingRateSpreadSchedule, "RateSpreadSchedule");
            }
            else {
            }
        });


        this.GetINUnderwritingStrippingScheduleByNoteID();
    }



    GetINUnderwritingStrippingScheduleByNoteID(): void {

        this.importUnderwritingService.GetINUnderwritingStrippingScheduleByNoteID(this._in_UnderwritingNotes).subscribe(res => {
            if (res.Succeeded) {
                var data: any = res.lstIN_UnderwritingStrippingScheduleDataContractList;
                this.lstINUnderwritingStrippingSchedule = data;
                
                this.ConvertToBindableDate(this.lstINUnderwritingStrippingSchedule, "StrippingSchedule");

            }
            else {
            }
        });

        this.GetINUnderwritingPIKScheduleByNoteID();
    }

    GetINUnderwritingPIKScheduleByNoteID(): void {

        this.importUnderwritingService.GetINUnderwritingPIKScheduleByNoteID(this._in_UnderwritingNotes).subscribe(res => {
            if (res.Succeeded) {
                var data: any = res.lstIN_UnderwritingPIKScheduleDataContractList;
                this.lstINUnderwritingPIKSchedule = data;

                this.ConvertToBindableDate(this.lstINUnderwritingPIKSchedule, "PIKSchedule");

            }
            else {
            }
        });


        //this.GetINUnderwritingFundingScheduleByNoteID();
    }

    GetINUnderwritingFundingScheduleByNoteID(): void {

        this.importUnderwritingService.GetINUnderwritingFundingScheduleByNoteID(this._in_UnderwritingNotes).subscribe(res => {
            if (res.Succeeded) {
                var data: any = res.lstIN_UnderwritingFundingScheduleDataContractList;
                this.lstIN_UnderwritingFundingSchedule = data;

                this.ConvertToBindableDate(this.lstIN_UnderwritingFundingSchedule, "FundingSchedule");
            }
            else {
            }
        });
    }

    
  

    private ConvertToBindableDate(Data, grid) {

        if (grid == "RateSpreadSchedule") {
            for (var i = 0; i < Data.length; i++) {
                this.lstINUnderwritingRateSpreadSchedule[i].CreatedDate = new Date(Data[i].CreatedDate);
                this.lstINUnderwritingRateSpreadSchedule[i].UpdatedDate = new Date(Data[i].UpdatedDate);
                this.lstINUnderwritingRateSpreadSchedule[i].Date = new Date(Data[i].Date);
            }
        }

        if (grid == "StrippingSchedule") {
            for (var i = 0; i < Data.length; i++) {
                this.lstINUnderwritingStrippingSchedule[i].CreatedDate = new Date(Data[i].CreatedDate);
                this.lstINUnderwritingStrippingSchedule[i].UpdatedDate = new Date(Data[i].UpdatedDate);
                this.lstINUnderwritingStrippingSchedule[i].StartDate = new Date(Data[i].StartDate);
            }
        }

        if (grid == "PIKSchedule") {
            for (var i = 0; i < Data.length; i++) {
                this.lstINUnderwritingPIKSchedule[i].CreatedDate = new Date(Data[i].CreatedDate);
                this.lstINUnderwritingPIKSchedule[i].UpdatedDate = new Date(Data[i].UpdatedDate);
                this.lstINUnderwritingPIKSchedule[i].StartDate = new Date(Data[i].StartDate);
                this.lstINUnderwritingPIKSchedule[i].EndDate = new Date(Data[i].EndDate);
            }
        }

        if (grid == "FundingSchedule") {
            for (var i = 0; i < Data.length; i++) {
                this.lstIN_UnderwritingFundingSchedule[i].CreatedDate = new Date(Data[i].CreatedDate);
                this.lstIN_UnderwritingFundingSchedule[i].UpdatedDate = new Date(Data[i].UpdatedDate);
                this.lstIN_UnderwritingFundingSchedule[i].Date = new Date(Data[i].Date);
            }
        }
    }



   
}


const routes: Routes = [

    { path: '', component: IN_UnderwritingNoteDetailComponent }]

@NgModule({
    imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjGridModule, WjGridFilterModule],
    declarations: [IN_UnderwritingNoteDetailComponent]
})

export class IN_UnderwritingNoteModule { }