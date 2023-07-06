import { Component, ViewChild} from "@angular/core";
import { Router, ActivatedRoute, Params } from '@angular/router';
import { FinancingWarehouse } from "../core/domain/financingWarehouse.model"
import { financingWarehouseService } from '../core/services/financingWarehouse.service';
import { NotificationService } from '../core/services/notification.service'
import { UtilityService } from '../core/services/utility.service';
import * as wjcGrid from '@grapecity/wijmo.grid';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjInputModule } from '@grapecity/wijmo.angular2.input';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
declare var $: any;
@Component({
  //  selector: "FinancingWarehouseDetail",
  templateUrl: "./financingWarehouseDetail.html",
  providers: [financingWarehouseService, NotificationService]

})

export class FinancingWareDetailComponent {
  public _financingWarehouse: FinancingWarehouse;
  message: any;
  accountid: any;
  FinancingWarehouseid: any;
  public flexfinancingwhouseupdatedRowNo: any = [];
  public flexfinancingwhouseToUpdate: any = [];
  @ViewChild('flexfwh') flexfwh !: wjcGrid.FlexGrid;
  _financingWhouse: any = new FinancingWarehouse;
  public _Showmessagediv: boolean = false;
  public _ShowmessagedivMsg: string = '';

  constructor(private _router: Router,
    private activatedRoute: ActivatedRoute,
    public financingsvc: financingWarehouseService,
    public utilityService: UtilityService,
    public notificationService: NotificationService) {

    this._financingWarehouse = new FinancingWarehouse();
    this.getFinancingWhousebyId();
    this.utilityService.setPageTitle("M61-Financing Detail");
  }

  saveFinancing(): void {
    this.financingsvc.SaveFinancing(this._financingWarehouse).subscribe(res => {
      if (res.Succeeded) {
        localStorage.setItem('divSucessFinancing', JSON.stringify(true));
        localStorage.setItem('divSucessMsgFinancing', JSON.stringify(res.Message));
        this.FinancingWarehouseid = res.newFinancingWarehouseid;
        this.SaveFinancingDetaillist();
        // this._router.navigate([this.routes.financingWareHouse.name]);
      }
      else {
        this._router.navigate(['financingWareHouse']);

      }
    });
  }




  SaveFinancingDetaillist(): void {
    if (this.flexfinancingwhouseupdatedRowNo.length > 0) {
      for (var i = 0; i < this.flexfinancingwhouseupdatedRowNo.length; i++) {
        //  this._financingWarehouse.lstFinancingWarehouseDetail[i].FinancingWarehouseID = this.FinancingWarehouseid;
        this.flexfinancingwhouseToUpdate.push(this._financingWarehouse.lstFinancingWarehouseDetail[this.flexfinancingwhouseupdatedRowNo[i]]);
        this.flexfinancingwhouseToUpdate[i].FinancingWarehouseID = this.FinancingWarehouseid;
      }

      this._financingWhouse.lstFinancingWarehouseDetail = this.flexfinancingwhouseToUpdate;

      this.financingsvc.SaveFinancingDetails(this._financingWhouse).subscribe(res => {
        if (res.Succeeded) {
          localStorage.setItem('divSucessFinancing', JSON.stringify(true));
          localStorage.setItem('divSucessMsgFinancing', JSON.stringify(res.Message));
          this._router.navigate(['financingWareHouse']);
        }
        else {
          // alert('Fail');
          this.utilityService.navigateToSignIn();
        }
      });
    }
    else {
      this._router.navigate(['financingWareHouse']);
    }
  }


  getFinancingWhousebyId(): void {
    var options: any = { year: "numeric", month: "numeric", day: "numeric" };

    this.activatedRoute.params.subscribe((params: Params) => {
      this._financingWhouse.FinancingWarehouseID = params['id'];
    });

    this.financingsvc.getFinancingWhousebyId(this._financingWhouse).subscribe(res => {
      if (res.Succeeded) {
        this._financingWarehouse = res.FinancingWarehouseDataContract;
        this.accountid = this._financingWarehouse.AccountID;
        for (var i = 0; i < this._financingWarehouse.lstFinancingWarehouseDetail.length; i++) {
          if (this._financingWarehouse.lstFinancingWarehouseDetail[i].StartDate != null) {
            this._financingWarehouse.lstFinancingWarehouseDetail[i].StartDate = new Date(this._financingWarehouse.lstFinancingWarehouseDetail[i].StartDate.toString().replace('T00', 'T17')).toLocaleDateString("en-US", options);
          }
          if (this._financingWarehouse.lstFinancingWarehouseDetail[i].EndDate != null) {
            this._financingWarehouse.lstFinancingWarehouseDetail[i].EndDate = new Date(this._financingWarehouse.lstFinancingWarehouseDetail[i].EndDate.toString().replace('T00', 'T17')).toLocaleDateString("en-US", options);
          }
        }
      }
      else {
        this._financingWarehouse = new FinancingWarehouse();
      }
    })
  }

  financingselectionChanged() {
    var flexfwh = this.flexfwh;
    var rowIdx = this.flexfwh.collectionView.currentPosition;
    try {
      var count = this.flexfinancingwhouseupdatedRowNo.indexOf(rowIdx);
      if (count == -1)
        this.flexfinancingwhouseupdatedRowNo.push(rowIdx);
    }
    catch (err) {
      console.log(err);
    }
  }

  DiscardChanges() {
    this._router.navigate(['financingWareHouse']);
  }

  PayFrequencyChange(newvalue: any): void {
    var value = newvalue.target.value;
    this._financingWarehouse.PayFrequency = value;
  }

  BaseCurrencyChange(newvalue: any): void {
    var value = newvalue.target.value;
    this._financingWarehouse.BaseCurrencyID = value;
  }

  IsRevolvingChange(newvalue: any): void {
    var value = newvalue.target.value;
    this._financingWarehouse.IsRevolving = value;
  }


  CustomValidator() {
    if (this._financingWarehouse.Name != "" && this._financingWarehouse.Name != null) {
      this.saveFinancing();
    } else {
      var msg = "";
      this.CustomAlert(msg)
    }

  }
  CustomAlert(dialog:any): void {
    var winW = window.innerWidth;
    var winH = window.innerHeight;
    var dialogoverlay:any = document.getElementById('dialogoverlay');
    var dialogbox: any = document.getElementById('dialogbox');
    var dialogboxhead: any = document.getElementById('dialogboxhead');
    var dialogboxbody: any = document.getElementById('dialogboxbody');
    dialogoverlay.style.display = "block";
    dialogoverlay.style.height = winH + "px";
    dialogbox.style.left = (winW / 2) - (550 * .5) + "px";
    dialogbox.style.top = "100px";
    dialogbox.style.display = "block";
    dialogboxhead.innerHTML = "CRES - web";
    dialogboxbody.innerHTML = dialog;
    //document.getElementById('dialogboxfoot').innerHTML = '<span class="custombutton" onclientclick="this.ok()">OK</span>';
  }
  ok(): void {
    var dialogoverlay: any = document.getElementById('dialogoverlay');
    var dialogbox: any = document.getElementById('dialogbox');
    dialogbox.style.display = "none";
    dialogoverlay.style.display = "none";
  }
}


const routes: Routes = [

  { path: '', component: FinancingWareDetailComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjGridFilterModule, WjInputModule],
  declarations: [FinancingWareDetailComponent]

})

export class financingWareDetailModule { }
