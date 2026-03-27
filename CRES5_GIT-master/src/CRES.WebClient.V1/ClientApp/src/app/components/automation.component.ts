import { Component, NgModule, ViewChild ,AfterViewInit} from '@angular/core';
import { Router } from '@angular/router';

import { UtilityService } from '../core/services/utility.service';
import { Paginated } from '../core/common/paginated.service';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';

import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import { PermissionService } from '../core/services/permission.service';

import { WjInputModule } from '@grapecity/wijmo.angular2.input';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { AutomationService } from '../core/services/automation.service'
import * as wjcGrid from '@grapecity/wijmo.grid';

@Component({
    templateUrl: "./automation.html",
    providers: [AutomationService, PermissionService]
})

export class AutomationComponent extends Paginated {
    public lstAutomation: any;
    public lstAutomationLog: any;
    public lstAutoDeals: any;
    public _isAutomationFetching: boolean = false;
    public _chkSelectAll: boolean = false;
    public _ShowSuccessmessage: boolean = false;
    public _ShowmessagedivMsgWar = '';
    public deletedBatchid: number;
    @ViewChild('flex') flex: wjcGrid.FlexGrid;
  @ViewChild('flexAutomationLog') flexAutomationLog: wjcGrid.FlexGrid;

    constructor(private _router: Router,
        public permissionService: PermissionService,
        public utilityService: UtilityService,
        public automationService: AutomationService,
    ) {
        super(50, 1, 0);
        this.utilityService.setPageTitle("M61–Automation");
        this.GetAllAutomation();
     //   this.GetAutomationLog();
    }

    ngAfterViewInit() {
        // commit row changes when scrolling the grid
        if (this.lstAutomation) {
            this.flexAutomationLog.scrollPositionChanged.addHandler(() => {
                var myDiv = $('#flexAutomationLog').find('div[wj-part="root"]');

                if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
                    if (this.flex.rows.length < this._totalCount) {
                        this._pageIndex = this.pagePlus(1);
                        this.GetAutomationLog();

                    }
                }
            });
        }
    }

    GetAllAutomation(): void {
        this._isAutomationFetching = true;
        this.automationService.getDealListForAutomation().subscribe(res => {
            if (res.Succeeded) {
          //      if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                this._isAutomationFetching = false;
                var data = res.dt;
                if (this._pageIndex == 1) {
                    this.lstAutomation = data;
                }
                else {
                    this.lstAutomation = this.lstAutomation.concat(data);
                }
                //}
                //else {
                //    localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                //    localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));

                //    this.utilityService.navigateUnauthorize();
                //}
            }
        });
    }

    SelectAll(): void {
        this._chkSelectAll = !this._chkSelectAll;
      for (var i = 0; i < this.flex.rows.length; i++) {
        this.flex.rows[i].dataItem.Active = this._chkSelectAll;
        }
        this.flex.invalidate();
    }

    Save() {
        var AutomationDeals = this.lstAutomation.filter(x => x.Active == true);

        this.automationService.InsertintoautomationRequests(AutomationDeals).subscribe(res => {
            if (res.Succeeded) {
                this._ShowSuccessmessage = true;
                this._ShowmessagedivMsgWar = 'Data Saved Successfully.';
                this.GetAllAutomation();
                setTimeout(function () {
                    this._ShowSuccessmessage = false;
                }.bind(this), 3000);
            }
        });


    }

    CancelAutomation() {

        this.automationService.CancelAutomation().subscribe(res => {
            if (res.Succeeded) {
                this._ShowSuccessmessage = true;
                this._ShowmessagedivMsgWar = 'Automation cancelled Successfully.';
                setTimeout(function () {
                    this._ShowSuccessmessage = false;
                }.bind(this), 3000);
            }
        });
    }

    GetAutomationLog(): void {
        this._isAutomationFetching = true;
        this.automationService.getAutomationLog(this._pageIndex, this._pageSize).subscribe(res => {
            this.lstAutomationLog = res.dt;
            this._isAutomationFetching = false;
            for (var i = 0; i < this.lstAutomationLog.length; i++) {
                if (this.lstAutomationLog[i].SubmittedDate != null) {
                    this.lstAutomationLog[i].SubmittedDate = new Date(this.lstAutomationLog[i].SubmittedDate.toString());
                }
            }
        })
    }

    ViewAutomationSubmittedDeals(BatchID): void {
        this._isAutomationFetching = true;
        this.automationService.getDealByBatchIDAutomation(BatchID).subscribe(res => {
            if (res.Succeeded) {
                this.lstAutoDeals = res.dt;
                this._isAutomationFetching = false;
            }
        })

        var modalAutomation = document.getElementById('myModalAutomation');
        modalAutomation.style.display = "block";
        $.getScript("/js/jsDrag.js");
    }

    CloseAutomationPopUp() {
        var modalCopy = document.getElementById('myModalAutomation');
        modalCopy.style.display = "none";
    }


    DeleteAutomationlog(): void {
      //  this.deletedBatchid = BatchID;
        this._isAutomationFetching = true;
        this.automationService.DeleteAutomationlog(this.deletedBatchid).subscribe(res => {
            if (res.Succeeded) {
                this.GetAutomationLog();
                this._ShowSuccessmessage = true;
                this._ShowmessagedivMsgWar = 'Automation log deleted Successfully.';
                this.CloseDeletePopUp();
                setTimeout(function () {
                    this._ShowSuccessmessage = false;
                }.bind(this), 3000);
                this._isAutomationFetching = false;
            }
        })

    }

    showDeleteDialog(BatchID: number) {
        this.deletedBatchid = BatchID;
        var modalDelete = document.getElementById('myModalDelete');

        modalDelete.style.display = "block";
        $.getScript("/js/jsDrag.js");
    }

    CloseDeletePopUp() {
        var modal = document.getElementById('myModalDelete');
        modal.style.display = "none";
    }

    DownloadAutomationExcel(BatchID): void {
        this._isAutomationFetching = true;
        //this.automationService.DownloadAutomationExcel(BatchID).subscribe(res => {
        //    if (res.Succeeded) {
               
        //        this._isAutomationFetching = false;
        //    }
        //})
        //=============================================================


        this.automationService.DownloadAutomationExcel(BatchID)
            .subscribe(fileData => {
                this._isAutomationFetching = false;
               
                let b: any = new Blob([fileData]);
                //var url = window.URL.createObjectURL(b);
                //window.open(url);

                let dwldLink = document.createElement("a");
                let url = URL.createObjectURL(b);
                let isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
                if (isSafariBrowser) {  //if Safari open in new window to save file with random filename.
                    dwldLink.setAttribute("target", "_blank");
                }
                dwldLink.setAttribute("href", url);
                dwldLink.setAttribute("download",  'Automtionlog.xlsx');
                dwldLink.style.visibility = "hidden";
                document.body.appendChild(dwldLink);
                dwldLink.click();
                document.body.removeChild(dwldLink);
                this._isAutomationFetching = false;
            },
                error => {
                    console.log(error);
                    // alert('Something went wrong');
                    this._isAutomationFetching = false;
                }
            );
    }
}
const routes: Routes = [
    { path: '', component: AutomationComponent }]

@NgModule({
    imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjGridModule, WjGridFilterModule, WjInputModule, WjCoreModule],
    declarations: [AutomationComponent]
})

export class AutomationModule { }
