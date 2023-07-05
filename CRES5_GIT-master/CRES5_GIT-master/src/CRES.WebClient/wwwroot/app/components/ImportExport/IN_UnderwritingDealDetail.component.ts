import { Component, OnInit, AfterViewInit, ViewChild, Injectable } from "@angular/core";
import { Router, RouterLink, CanActivate, ActivatedRoute } from '@angular/router';

import { ImportUnderwritingService } from '../../core/services/ImportUnderwritingService';
import { isLoggedIn } from '../../core/services/is-logged-in';
import { UtilityService } from '../../core/services/utilityService';
import { backshopImport } from '../../core/domain/backshopImport';
import { IN_UnderwritingNotes } from '../../core/domain/IN_UnderwritingNotes';
import { IN_UnderwritingDeal } from '../../core/domain/IN_UnderwritingDeal';

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
    //  selector: "IN_UnderwritingDealDetail",
    templateUrl: "app/components/ImportExport/IN_UnderwritingDealDetail.html",
    providers: [ImportUnderwritingService],
})

export class IN_UnderwritingDealDetailComponent {
    //private routes = Routes;
    public _backshopImport: backshopImport;
    public lstIN_UnderwritingNotes: any;
    public IN_UnderwritingDealData: IN_UnderwritingDeal;

    public isProcessComplete: boolean = true;

    public allowImport: boolean = false;

    @ViewChild('flex') flex: wjcGrid.FlexGrid;

    constructor(public importUnderwritingService: ImportUnderwritingService, private _router: Router, public utilityService: UtilityService) {
        this._backshopImport = new backshopImport('', '');

        this._backshopImport = JSON.parse(localStorage.getItem('backshopImport'));

        this.IN_UnderwritingDealData = new IN_UnderwritingDeal("");

        this.isProcessComplete = true;

        this.GetINUnderwritingDealDataByDealId();
        this.utilityService.setPageTitle("M61-Integration Deal");
    }

    GetINUnderwritingDealDataByDealId(): void {
        var _userData = JSON.parse(localStorage.getItem('user'));
        this._backshopImport.UserName = _userData.UserID;

        this.importUnderwritingService.GetINUnderwritingDealDataByDealId(this._backshopImport).subscribe(res => {
            if (res.Succeeded) {
                this.IN_UnderwritingDealData = res.IN_UnderwritingDeal;

                //alert(JSON.stringify(this.IN_UnderwritingDealData));
                this.GetInUnderwritingNotesByDealID();
            } else {
            }
        });
    }

    GetInUnderwritingNotesByDealID(): void {
        var _userData = JSON.parse(localStorage.getItem('user'));
        this._backshopImport.UserName = _userData.UserID;

        this.importUnderwritingService.GetInUnderwritingNotesByDealID(this._backshopImport).subscribe(res => {
            if (res.Succeeded) {
                this.isProcessComplete = false;

                var data: any = res.lstIN_UnderwritingNotes;
                this.lstIN_UnderwritingNotes = data;
                this.ConvertToBindableDate(this.lstIN_UnderwritingNotes);

                localStorage.setItem('lstIN_UnderwritingNotes', JSON.stringify(this.lstIN_UnderwritingNotes));

                //remove first cell selection
                this.flex.selectionMode = wjcGrid.SelectionMode.None;

                setTimeout(function () {
                    this.flex.autoSizeColumns(0, this.flex.columns.length, false, 20);
                    this.flex.columns[0].width = 200; // for Note Id
                }.bind(this), 1);
            }
            else {
            }
        });
    }

    ImportLandingtableToMainDB(): void {
        this.isProcessComplete = true;
        
        var _userData = JSON.parse(localStorage.getItem('user'));
        this._backshopImport.UserName = _userData.UserID;

       

        var lstcheckDuplicateNote = this.lstIN_UnderwritingNotes.filter(x => x.NoteExistsInDiffDeal > 0);
        var msg = '';
        if (lstcheckDuplicateNote != null) {
            if (lstcheckDuplicateNote.length > 0) {
                for (var i = 0; i < lstcheckDuplicateNote.length; i++) {
                    msg = msg + 'Note id <b>' + lstcheckDuplicateNote[i].ClientNoteID + '</b> is already exists in deal  <b> <a target="_blank" href="/#/dealdetail/' + lstcheckDuplicateNote[i].NoteExistsInDiffDealName + '">' + lstcheckDuplicateNote[i].NoteExistsInDiffDealName + '</a></b></br>';
                }
                this.allowImport = false;
               
            }
            else {
                this.allowImport = true;
            }
        }
        else {
            this.allowImport = true;
        }


        if (this.allowImport) {
            this.importUnderwritingService.ImportLandingtableToMainDB(this._backshopImport).subscribe(res => {
                if (res.Succeeded) {
                    this.isProcessComplete = false;
                    this.CustomAlert("Data imported successfully.");

                }
                else {
                    //this.CustomAlert("Deal '" + this._backshopImport.DealName + "' not found.");
                    //this._router.navigate(['/ImportUnderwriting']);
                }
            });
        } else {
            this.isProcessComplete = false;
            this.CustomAlert(msg);
        }
        
    }

    DeleteINUnderwritingDealDataByDealID(): void {
        this.isProcessComplete = true;

        var _userData = JSON.parse(localStorage.getItem('user'));
        this._backshopImport.UserName = _userData.UserID;

        if (confirm("Do you want to discard this import?") == true) {
            this.importUnderwritingService.DeleteINUnderwritingDealDataByDealID(this._backshopImport).subscribe(res => {
                if (res.Succeeded) {
                    //alert("Data imported successfully.");
                    this.isProcessComplete = false;
                    this._router.navigate(['/ImportUnderwriting']);
                    // this._router.navigate([this.routes.importUnderwriting.name]);
                }
                else {
                    //alert("Deal '" + this._backshopImport.DealName + "' not found.");
                    //this._router.navigate([this.routes.iN_UnderwritingDealDetail.name]);
                }
            });
        }
        else {
            this.isProcessComplete = false;
        }
    }

    private _formatting = true;

    get formatting(): boolean {
        return this._formatting;
    }
    set formatting(value: boolean) {
        if (this._formatting != value) {
            this._formatting = value;
            this._updateFormatting();
        }
    }

    CustomAlert(dialog): void {
        var winW = window.innerWidth;
        var winH = window.innerHeight;
        var dialogoverlay = document.getElementById('dialogoverlay');
        var dialogbox = document.getElementById('dialogbox');
        dialogoverlay.style.display = "block";
        dialogoverlay.style.height = winH + "px";
        dialogbox.style.left = (winW / 2) - (550 * .5) + "px";
        dialogbox.style.top = "100px";
        dialogbox.style.display = "block";
        document.getElementById('dialogboxhead').innerHTML = "CRES - web";
        document.getElementById('dialogboxbody').innerHTML = dialog;
    }

    ok(): void {
        this._router.navigate(['/dashboard']);
        document.getElementById('dialogbox').style.display = "none";
        document.getElementById('dialogoverlay').style.display = "none";
    }

    private _updateFormatting() {
        var flex = this.flex;
        if (flex) {
            var fmt = this.formatting;
            this._setColumnFormat('ClosingDate', fmt ? 'MMM dd yy' : null);
            this._setColumnFormat('FirstPaymentDate', fmt ? 'MMM dd yy' : null);
            this._setColumnFormat('SelectedMaturityDate', fmt ? 'MMM dd yy' : null);

            this._setColumnFormat('ExpectedMaturityDate', fmt ? 'MMM dd yy' : null);
            this._setColumnFormat('ExtendedMaturityScenario1', fmt ? 'MMM dd yy' : null);
            this._setColumnFormat('ExtendedMaturityScenario2', fmt ? 'MMM dd yy' : null);
            this._setColumnFormat('ExtendedMaturityScenario3', fmt ? 'MMM dd yy' : null);
            this._setColumnFormat('InitialMaturityDate', fmt ? 'MMM dd yy' : null);
        }
    }

    private _setColumnFormat(name, format) {
        var col = this.flex.columns.getColumn(name);
        if (col) {
            col.format = format;
        }
    }

    private ConvertToBindableDate(Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this.lstIN_UnderwritingNotes[i].ClosingDate != null) this.lstIN_UnderwritingNotes[i].ClosingDate = new Date(Data[i].ClosingDate);
            if (this.lstIN_UnderwritingNotes[i].FirstPaymentDate != null) this.lstIN_UnderwritingNotes[i].FirstPaymentDate = new Date(Data[i].FirstPaymentDate);
            if (this.lstIN_UnderwritingNotes[i].SelectedMaturityDate != null) this.lstIN_UnderwritingNotes[i].SelectedMaturityDate = new Date(Data[i].SelectedMaturityDate);
            if (this.lstIN_UnderwritingNotes[i].ExpectedMaturityDate != null) this.lstIN_UnderwritingNotes[i].ExpectedMaturityDate = new Date(Data[i].ExpectedMaturityDate);
            if (this.lstIN_UnderwritingNotes[i].ExtendedMaturityScenario1 != null) this.lstIN_UnderwritingNotes[i].ExtendedMaturityScenario1 = new Date(Data[i].ExtendedMaturityScenario1);
            if (this.lstIN_UnderwritingNotes[i].ExtendedMaturityScenario2 != null) this.lstIN_UnderwritingNotes[i].ExtendedMaturityScenario2 = new Date(Data[i].ExtendedMaturityScenario2);
            if (this.lstIN_UnderwritingNotes[i].ExtendedMaturityScenario3 != null) this.lstIN_UnderwritingNotes[i].ExtendedMaturityScenario3 = new Date(Data[i].ExtendedMaturityScenario3);
            if (this.lstIN_UnderwritingNotes[i].InitialMaturityDate != null) this.lstIN_UnderwritingNotes[i].InitialMaturityDate = new Date(Data[i].InitialMaturityDate);
        }
    }
}

const routes: Routes = [

    { path: '', component: IN_UnderwritingDealDetailComponent }]

@NgModule({
    imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjGridModule, WjGridFilterModule],
    declarations: [IN_UnderwritingDealDetailComponent]
})

export class IN_UnderwritingDealModule { }