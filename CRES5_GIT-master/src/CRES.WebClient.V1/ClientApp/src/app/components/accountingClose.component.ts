import { Component, ViewChild, NgModule } from "@angular/core";
import { RouterModule, Routes } from '@angular/router';
import { Periodic, AccountingClose } from "../core/domain/periodic.model";
import { accoutingservice } from '../core/services/accounting.service';

import * as wjcGrid from '@grapecity/wijmo.grid';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjInputModule } from '@grapecity/wijmo.angular2.input';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import * as wjNg2GridFilter from '@grapecity/wijmo.angular2.grid.filter';
import { dealService } from '../core/services/deal.service';
import { UtilityService } from '../core/services/utility.service';
declare var $: any;


@Component({

  templateUrl: "./accountingClose.html",
  providers: [accoutingservice, Periodic, dealService]

})

export class accountingCloseComponent {

  public _periodic: Periodic;
  public _Showmessagediv: boolean = false;
  public _ShowmessagedivMsg: string = '';
  public _Showmessagenotediv: boolean = false;
  public _ConfirmMsgText: string;

  Message: any;
  _isaccountingcloseSaving: boolean = false;
  public _disabled: boolean = true;
  savedialogmsg: string;
  _closeDate: Date;
  _openDate: Date;
  @ViewChild('flexaccountingclose') flexaccountingclose: wjcGrid.FlexGrid;
  @ViewChild('filter') gridFilter: wjNg2GridFilter.WjFlexGridFilter;
  public lstaccountingClose: Array<AccountingClose> = new Array<AccountingClose>();
  lstselectedPeriod: any;
  _chkSelectAll: boolean = false;
  lstPortfolio: any;
  PortfolioMasterGuid: string;
  lstdealaccountingClose: any;
  DealName: any;
  comment: any;
  constructor(
    public utilityService: UtilityService, public dealSrv: dealService, public _accountingservice: accoutingservice) {
    this.utilityService.setPageTitle("Accounting-Close");
    this.getAllPortfolio();
    this.getAllAccountingClose();
  }

  getAllAccountingClose(): void {
    this._isaccountingcloseSaving = true;
    this._accountingservice.getallaccountingclose(this.PortfolioMasterGuid).subscribe(res => {
      if (res.Succeeded) {
        this.lstaccountingClose = res.dt;
        for (var i = 0; i < this.lstaccountingClose.length; i++) {
          this.lstaccountingClose[i].Active = false;
        }
        this.ConvertToBindableDate();
        setTimeout(() => {
          if (this.flexaccountingclose) {
            this.flexaccountingclose.columnHeaders.rows[0].height = 25;
            //this.flexaccountingclose.autoSizeColumns();
            this.flexaccountingclose.invalidate();
          }
          this._isaccountingcloseSaving = false;
          this.gridFilter.getColumnFilter('DealName').valueFilter.maxValues = 1000;
        }, 2000);
      }
    });
    error => {
      this._isaccountingcloseSaving = false;
      console.error('Error: ' + error);
    }
  }

  SelectAll(): void {
    this._chkSelectAll = !this._chkSelectAll;
    for (var i = 0; i < this.flexaccountingclose.rows.length; i++) {
      this.flexaccountingclose.rows[i].dataItem.Active = this._chkSelectAll;
    }
    this.flexaccountingclose.invalidate();
  }

  CheckAndValidateBeforeCloseAndOpen(buttonclicktype) {
    var maxclosedate = new Date('1970-01-01Z00:00:00:000');;
    var lstaccounting = this.lstaccountingClose.filter(x => x.Active == true);
    var dealname = "";
    this.savedialogmsg = '';
    var accoutinglistforvalidation = this.lstaccountingClose.filter(x => x.LastAccountingCloseDate != null);

    if (lstaccounting.length == 0 || !this._closeDate) {
      if (lstaccounting.length == 0) {
        this.savedialogmsg = "<p>" + "Please choose Deal(s) to " + buttonclicktype + ".</p>";

      }
      if (buttonclicktype == "close") {
        if (!this._closeDate) {
          this.savedialogmsg += "<p> Close Date can not be blank.</p>";
        }
      } else if (buttonclicktype == "open") {
        if (!this._openDate) {
          this.savedialogmsg += "<p> Open Date can not be blank.</p>";
        }
      }
    }
    for (var k = 0; k < accoutinglistforvalidation.length; k++) {
      var currentdate = new Date(accoutinglistforvalidation[k].LastAccountingCloseDate);
      if (currentdate > maxclosedate) {
        maxclosedate = currentdate;
      }
    }
    var todaydate = new Date();
    var LastMonthEndDate = new Date(todaydate.getFullYear(), todaydate.getMonth(), 0);

    if (buttonclicktype == "close") {
      if (this._closeDate != null) {
        var newclosedate = new Date(this._closeDate);


        if (this.CheckDateisLastDayoftheMonth(newclosedate) == false) {
          this.savedialogmsg += "<p> Close period date " + this.convertDateToBindable(newclosedate) + " should be the end of the month.</p>";
        }

        if (newclosedate > LastMonthEndDate) {
          this.savedialogmsg += "<p> Close period date " + this.convertDateToBindable(newclosedate) + " cannot be greater than end of the last month " + this.convertDateToBindable(LastMonthEndDate) + ".</p>";
        }


      }
    }
    else if (buttonclicktype == "open") {
      if (this._openDate != null) {
        var newopendate = new Date(this._openDate);
        //if (this.CheckDateisLastDayoftheMonth(newopendate) == false)
        //{
        //  this.savedialogmsg += "<p> Open period date " + this.convertDateToBindable(newopendate) + " should be the end of the month.</p>";
        //}

        if (newopendate > LastMonthEndDate) {
          this.savedialogmsg += "<p> Open period date " + this.convertDateToBindable(newopendate) + " cannot be greater than end of the last month " + this.convertDateToBindable(LastMonthEndDate) + ".</p>";
        }
      }

    }

    for (var i = 0; i < lstaccounting.length; i++) {

      var currentaccoutingclosedate = new Date(lstaccounting[i].LastAccountingCloseDate);
      if (currentaccoutingclosedate.getFullYear() < 2000) {
        currentaccoutingclosedate = null;
      }

      if (lstaccounting[i].isDataExists == 0) {
        dealname += lstaccounting[i].DealName + ", ";
      }

      if (buttonclicktype == "close") {
        if (this._closeDate != null) {

          var ClosingDateMonthend = this.GetLastDayOftheMonth(lstaccounting[i].ClosingDate);
          var MaturityMonthend = this.GetLastDayOftheMonth(lstaccounting[i].Maturity);
          var currentCloseDate = new Date(this._closeDate);
          if (currentCloseDate < ClosingDateMonthend || currentCloseDate > MaturityMonthend) {
            this.savedialogmsg += "<p> Close period date " + this.convertDateToBindable(this._closeDate) + " for deal " + lstaccounting[i].DealName + " should be between " + this.convertDateToBindable(ClosingDateMonthend) + " and " + this.convertDateToBindable(MaturityMonthend) + ".</p>";
          }

          if (currentCloseDate.toDateString() == (new Date(lstaccounting[i].LastAccountingCloseDate)).toDateString()) {
            //Close Period date should not be equal to last close .
            this.savedialogmsg += "<p> Close period date " + this.convertDateToBindable(this._closeDate) + " for deal " + lstaccounting[i].DealName + " is already closed" + ".</p>";
          }

          if (currentCloseDate < currentaccoutingclosedate) {
            this.savedialogmsg += "<p> Close period date " + this.convertDateToBindable(this._closeDate) + " for deal " + lstaccounting[i].DealName + " should not be less than last accounting close date " + this.convertDateToBindable(currentaccoutingclosedate) + ".</p>";
          }

          //if (currentCloseDate >= new Date(lstaccounting[i].FirstUnrecDate)) {
          //  this.savedialogmsg += "<p> Close period date " + this.convertDateToBindable(this._closeDate) + " for deal " + lstaccounting[i].DealName + " should be less than First Unreconcile Date " + this.convertDateToBindable(lstaccounting[i].FirstUnrecDate) + ".</p>";
          //}

        }
      }
      else if (buttonclicktype == "open") {

        if (this._openDate != null) {
          var currentOpenDate = new Date(this._openDate);
          var ClosingDateMonthend = this.GetLastDayOftheMonth(lstaccounting[i].ClosingDate);
          var MaturityMonthend = this.GetLastDayOftheMonth(lstaccounting[i].Maturity);

          //open date should be between close and maturity
          if (currentOpenDate < lstaccounting[i].ClosingDate || currentOpenDate > MaturityMonthend) {
            this.savedialogmsg += "<p> Open period date " + this.convertDateToBindable(this._openDate) + " for deal " + lstaccounting[i].DealName + " should be between " + this.convertDateToBindable(lstaccounting[i].ClosingDate) + " and " + this.convertDateToBindable(lstaccounting[i].Maturity) + ".</p>";
          }
          if (currentaccoutingclosedate != undefined && currentaccoutingclosedate != null)
          {
            if (currentOpenDate > currentaccoutingclosedate) {
              //Open Period date cannot be greater than last accounting close date.
              this.savedialogmsg += "<p> Open period date " + this.convertDateToBindable(this._openDate) + " for deal " + lstaccounting[i].DealName + " cannot be greater than last accounting close date " + this.convertDateToBindable(lstaccounting[i].LastAccountingCloseDate) + ".</p>";
            } else if (currentOpenDate.toDateString() == currentaccoutingclosedate.toDateString())
            {
              this.savedialogmsg += "<p>" + "For deal " + lstaccounting[i].DealName + " there are no periods to open. " + "</p>";
            }
          }
          else {
            this.savedialogmsg += "<p>" + "For deal " + lstaccounting[i].DealName + " there are no periods to open. " + "</p>";
          }
        }
      }
    }
    if (dealname != "") {
      this.savedialogmsg += "<p>" + "Deal(s) " + dealname.slice(0, dealname.length - 2) + " is not prepared for accounting close as there is no cashflow, please re-calculate this deal(s)." + "</p>";
    }

    if (this.savedialogmsg == "") {
      if (buttonclicktype == "close") {
        this.ShowAccoutingCloseDialog()
      } else if (buttonclicktype == "open") {
        this.ShowAccoutingOpenDialog();

      }

    } else {
      this.CustomDialogteSave();
    }
  }

  CheckDateisLastDayoftheMonth(date) {
    let d1 = new Date(date);
    d1.setDate(d1.getDate() + 1);
    if (d1.getDate() === 1) {
      //'Date is the last day of the month.';
      return true;
    } else {
      //'Date is not the last day of the month.';
      return false;
    }
  }
  GetLastDayOftheMonth(date) {
    date = new Date(date);
    var lastDate = new Date(date.getFullYear(), date.getMonth() + 1, 0);
    return lastDate;
  }


  SaveAccountingClose() {
    this.ClosePopUpConfirmBox();
    this._isaccountingcloseSaving = true;
    var lstaccounting = this.lstaccountingClose.filter(x => x.Active == true);
    this.savedialogmsg = '';

    var closeDate = this.convertDateToBindable(this._closeDate);
    for (var i = 0; i < lstaccounting.length; i++) {
      lstaccounting[i]["closeDate"] = closeDate;
      lstaccounting[i]["Comments"] = this.comment == undefined ? "" : this.comment;
    }
    this._accountingservice.saveaccountingClose(lstaccounting).subscribe(res => {
      if (res.Succeeded) {
        this._ShowmessagedivMsg = "Selected deals has been closed for the period " + this.convertDateToBindable(this._closeDate) + ".";
        this._closeDate = null;
        this._openDate = null;
        this.comment = null;
        this.getAllAccountingClose();
        this._isaccountingcloseSaving = false;
        this._Showmessagediv = true;

        setTimeout(function () {
          this._Showmessagediv = false;
          this._isaccountingcloseSaving = false;
          this._disabled = true;
        }.bind(this), 2000);
      }
    });

  }
  CustomDialogteSave(): void {

    var dialogbox = document.getElementById('Genericdialogbox');
    document.getElementById('savedialogmessage').innerHTML = this.savedialogmsg;
    dialogbox.style.top = "100px";
    dialogbox.style.display = "block";
    $.getScript("/js/jsDrag.js");

  }

  ClosePopUpDialog() {
    var modal = document.getElementById('Genericdialogbox');
    modal.style.display = "none";
  }

  ShowAccoutingCloseDialog(): void {
    this._ConfirmMsgText = 'Are you sure you want to close accounting for the date ' + this.convertDateToBindable(this._closeDate) + " and for selected deal(s)" + '?';
    var modal = document.getElementById('customdialogboxAccountingclose');
    modal.style.display = "block";
  }

  ShowAccoutingOpenDialog(): void {
    this._ConfirmMsgText = 'Are you sure you want to open the accounting for the date ' + this.convertDateToBindable(this._openDate) + " and for selected deal(s) ?";
    var modal = document.getElementById('customdialogboxopenperiod');
    modal.style.display = "block";
  }
  SaveAccountingOpen() {
    this._isaccountingcloseSaving = true;
    this.ClosePopUpopenperiod();
    var lstaccounting = this.lstaccountingClose.filter(x => x.Active == true);
    this.savedialogmsg = '';

    var openDate = this.convertDateToBindable(this._openDate);
    for (var i = 0; i < lstaccounting.length; i++) {
      lstaccounting[i]["openDate"] = openDate;
      lstaccounting[i]["Comments"] = this.comment == undefined ? "" : this.comment;
    }
    this._accountingservice.saveaccountingOpen(lstaccounting).subscribe(res => {
      if (res.Succeeded) {
        this._ShowmessagedivMsg = "Selected deals has been opened for the period " + this.convertDateToBindable(this._openDate) + ".";
        this._closeDate = null;
        this._openDate = null;
        this.comment = null;
        this.getAllAccountingClose();
        this._Showmessagediv = true;

        setTimeout(function () {
          this._Showmessagediv = false;
          this._isaccountingcloseSaving = false;
          this._disabled = true;
        }.bind(this), 2000);
      }
    });

  }

  private ConvertToBindableDate() {
    for (var i = 0; i < this.lstaccountingClose.length; i++) {
      if (this.lstaccountingClose[i].LastAccountingCloseDate != null)
        this.lstaccountingClose[i].LastAccountingCloseDate = new Date(this.convertDateToBindable(this.lstaccountingClose[i].LastAccountingCloseDate));

      if (this.lstaccountingClose[i].LastClosedOn != null)
        this.lstaccountingClose[i].LastClosedOn = new Date(this.convertDateToBindableWithTime(this.lstaccountingClose[i].LastClosedOn.toString()));

      if (this.lstaccountingClose[i].ClosingDate != null) {
        this.lstaccountingClose[i].ClosingDate = new Date(this.convertDateToBindable(this.lstaccountingClose[i].ClosingDate));
      }

      if (this.lstaccountingClose[i].Maturity != null)
        this.lstaccountingClose[i].Maturity = new Date(this.convertDateToBindable(this.lstaccountingClose[i].Maturity));


      if (this.lstaccountingClose[i].ActualPayoffdate != null) {
        this.lstaccountingClose[i].ActualPayoffdate = new Date(this.convertDateToBindable(this.lstaccountingClose[i].ActualPayoffdate));
      }

      if (this.lstaccountingClose[i].FirstUnrecDate != null) {
        this.lstaccountingClose[i].FirstUnrecDate = new Date(this.convertDateToBindable(this.lstaccountingClose[i].FirstUnrecDate));
      }

    }
  }

  convertDateToBindable(date) {
    var dateObj = new Date(date);
    return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear();
  }

  convertDateToBindableWithTime(date) {
    var dateObj = new Date(date);
    return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear() + " " + dateObj.getHours() + ":" + dateObj.getMinutes() + ":" + dateObj.getSeconds();
  }


  getTwoDigitString(number) {
    if (number.toString().length === 1)
      return "0" + number;
    return number;
  }

  ClosePopUpConfirmBox() {
    var modal = document.getElementById('customdialogboxAccountingclose');
    modal.style.display = "none";
  }
  ClosePopUpopenperiod() {
    var modal = document.getElementById('customdialogboxopenperiod');
    modal.style.display = "none";
  }

  getAllPortfolio(): void {
    this._accountingservice.getallportfolio().subscribe(res => {
      if (res.Succeeded) {
        var data = res.lstportfolio;
        this.lstPortfolio = data;
      }
    });
  }

  ChangeDynamicPortfolio(newvalue): void {
    this.PortfolioMasterGuid = newvalue.toString();
    this.getAllAccountingClose();
  }

  clickedAccoutingCloselog(DealID, DealName) {
    this.DealName = DealName;
    this._isaccountingcloseSaving = true;
    this.dealSrv.getAccountingClosebyDealid(DealID, 0, 5000).subscribe(res => {
      if (res.Succeeded) {
        this.lstdealaccountingClose = res.dt;
        this.ConvertToBindableDateAccountingClose(this.lstdealaccountingClose);
        var modaltrans = document.getElementById('myModalAccouting');
        this._isaccountingcloseSaving = false;
        modaltrans.style.display = "block";
        $.getScript("/js/jsDrag.js");
      }
    });


  }
  CloseAccountingpopup() {
    var modal = document.getElementById('myModalAccouting');
    modal.style.display = "none";

  }

  private ConvertToBindableDateAccountingClose(Data) {
    for (var i = 0; i < Data.length; i++) {
      if (this.lstdealaccountingClose[i].CloseDate != null) {
        this.lstdealaccountingClose[i].CloseDate = this.convertDateToBindable(this.lstdealaccountingClose[i].CloseDate);
      }
      if (this.lstdealaccountingClose[i].UpdatedOn != null) {
        this.lstdealaccountingClose[i].UpdatedOn = this.convertDateToBindableWithTime(this.lstdealaccountingClose[i].UpdatedOn.toString());
      }
      if (this.lstdealaccountingClose[i].OpenDate != null) {
        this.lstdealaccountingClose[i].OpenDate = this.convertDateToBindable(this.lstdealaccountingClose[i].OpenDate);
      }
    }
  }

}

const routes: Routes = [

  { path: '', component: accountingCloseComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjGridModule, WjInputModule, WjGridFilterModule],
  declarations: [accountingCloseComponent]
})

export class AccountingCloseModule { }
