import { Component, ViewChild, Injectable } from "@angular/core";
import { Router,  ActivatedRoute } from '@angular/router';
import { FinancingWarehouse } from "../core/domain/financingWarehouse.model"
import { financingWarehouseService } from '../core/services/financingWarehouse.service';
import { NotificationService } from '../core/services/notification.service'
import { UtilityService } from '../core/services/utility.service';
import { Paginated } from '../core/common/paginated.service';
import * as wjcGrid from '@grapecity/wijmo.grid';
import {  NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';

@Component({
  selector: "FinancingWarehouse",
  templateUrl: "./financingWarehouse.html",
  providers: [financingWarehouseService, NotificationService]
})

//@CanActivate((next: ComponentInstruction, previous: ComponentInstruction) => {
//    return isLoggedIn(next, previous);
//})

@Injectable()
export class FinancingWareComponent extends Paginated {
  public _financingWarehouse !: FinancingWarehouse;
  //private routes = Routes;

  public _dvEmptyFiancingSearchMsg: boolean = false;
  public _Showmessagediv: boolean = false;
  public _ShowmessagedivMsg: string = '';
  public _isFinancingListFetching: boolean = false;
  public _dvEmptyFinancingSearchMsg: boolean = false;
  financingaddpath: any;

  lstfinancingWarehouse: any;
  @ViewChild('flex') flex !: wjcGrid.FlexGrid;
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
      var successfinancingmsg: any = localStorage.getItem('divSucessMsgFinancing');
      this._ShowmessagedivMsg = successfinancingmsg;
      this._ShowmessagedivMsg = (this._ShowmessagedivMsg.replace('\"', '')).replace('\"', '');
      localStorage.setItem('divSucessFinancing', JSON.stringify(false));
      localStorage.setItem('divSucessMsgFinancing', JSON.stringify(''));
      //to hide _Showmessagediv after 5 sec
      setTimeout(() => {
        this._Showmessagediv = false;
        console.log(this._Showmessagediv);
      }, 5000);
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
    (error:string) => console.error('Error: ' + error)
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

export class financingWarehouseModule { }
