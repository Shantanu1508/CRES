import { Component, ViewChild } from "@angular/core";
import { Router, ActivatedRoute, Params } from '@angular/router';
import * as wjcGrid from '@grapecity/wijmo.grid';
import { NgModule } from '@angular/core';
import * as wjcCore from '@grapecity/wijmo';
import { Paginated } from '../core/common/paginated.service';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { CommonModule, Location } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { WjInputModule } from '@grapecity/wijmo.angular2.input';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import { UtilsFunctions } from './../core/common/utilsfunctions';
import { UtilityService } from '../core/services/utility.service';
import { journalLedgerService } from '../core/services/journalLedger.service';
import { JournalLedger, JournalLedgerMaster } from "../core/domain/journalLedger.model";
import { MembershipService } from '../core/services/membership.service';

@Component({
  selector: "journalLedger",
  templateUrl: "./journalLedger.html",
  providers: [journalLedgerService, UtilsFunctions]
})

export class JournalLedgerComponent extends Paginated {
  public _isShowCalcNotes: boolean = true;
  public _isShowSave: boolean = true;
  public _isShowCancel: boolean = true;
  public _isListFetching: boolean;
  public JournalEntryMasterID: any;
  public JournalEntryMasterGuid: any;
  public _Showsuccessmessage: boolean = false;
  public _ShowmessageWarning: boolean = false;
  public _ShowLastUpdated: boolean = false;

  _messageSuccess: any;
  JournalEntryMasterIDheader: any;
  LastUpdatedBy: any;
  LastUpdatedDate: any;
  _messageFail: any;
   lstTransactionType: any;
  lstdebtandequity: any;
  public actiontype: any;

  @ViewChild('flexJournalLedger') flexJournalLedger: wjcGrid.FlexGrid;
  public cvJournalLedger: wjcCore.CollectionView;
  lstjournalLedger: any;

  public _journal: JournalLedgerMaster;
  public _journalLedger: JournalLedger;
  constructor(
    public journalSrv: journalLedgerService,
    public utils: UtilsFunctions,
    private _router: Router,
    public utilityService: UtilityService,
    public membershipService: MembershipService,
    public _location: Location,
    private activatedRoute: ActivatedRoute) {
    super(50, 1, 0);
    this.utilityService.setPageTitle("M61–Journal Ledger");
    this._journal = new JournalLedgerMaster(0);
    this.CheckifUserIsLogedIN();
    this.activatedRoute.params.forEach((params: Params) => {
      if (params['id'] !== undefined) {
      }
      else if (params['nid'] !== undefined) {
        this.JournalEntryMasterGuid = params['nid'];
        this.GetJournalLedgerbyJournalEntryMasterGuid();
        this.actiontype = "update";
      } else {
        this.actiontype = "new";
        this.GetJournalLedgerbyJournalEntryMasterGuid();
      }
    });
  }

  CheckifUserIsLogedIN(): void {
    this.membershipService.CheckifUserIsLogedIN().subscribe(res => {
      if (res.Succeeded) {

      }
      else {
        if (res.Message == "Authentication failed") {
          this._router.navigate(['login']);
        }
      }
    });
  }
  isDateInArray(needle, haystack) {
    for (var i = 0; i < haystack.length; i++) {
      if (needle.getTime() === haystack[i].getTime()) {
        return true;
      }
    }
    return false;
  }

  CustomValidator(): boolean {
    var sTransactionamount = 0;
    var error = "";
    var blankitems = "";
    var Accountblank = "";
    var dateblank = "";
    let isValid = true;

    if (this._journal.JournalEntryDate == undefined || this._journal.JournalEntryDate == null) {
      error = error + "</p>" + "Please enter value for Journal Entry Date." + "</p>";
      isValid = false;
    }
    var runothervalidation = false;
    for (var i = 0; i < this.lstjournalLedger.length; i++) {
      if (this.lstjournalLedger[i].DebtEquityAccountID === undefined || this.lstjournalLedger[i].DebtEquityAccountID == null || this.lstjournalLedger[i].DebtEquityAccountID == "") {
        if (this.lstjournalLedger[i].TransactionDate === undefined || this.lstjournalLedger[i].TransactionDate == null || this.lstjournalLedger[i].TransactionDate == "") {
          if (this.lstjournalLedger[i].TransactionTypeText === undefined || this.lstjournalLedger[i].TransactionTypeText == null || this.lstjournalLedger[i].TransactionTypeText == "") {
            if (this.lstjournalLedger[i].CommentsDetail === undefined || this.lstjournalLedger[i].CommentsDetail == null || this.lstjournalLedger[i].CommentsDetail == "") {
              if (this.lstjournalLedger[i].TransactionAmount === undefined || this.lstjournalLedger[i].TransactionAmount == null || this.lstjournalLedger[i].TransactionAmount == "" || this.lstjournalLedger[i].TransactionAmount === 0) {
                runothervalidation = false;
              } else {
                runothervalidation = true;
              }
            }
            else {
              runothervalidation = true;
            }
          }
          else {
            runothervalidation = true;
          }

        } else {
          runothervalidation = true;
        }
      } else {
        runothervalidation = true;
      }
      if (runothervalidation == true) {
        if (this.lstjournalLedger[i].DebtEquityAccountID === undefined || this.lstjournalLedger[i].DebtEquityAccountID == null) {

          Accountblank = "Account ,";
        }
        if (this.lstjournalLedger[i].TransactionDate === undefined || this.lstjournalLedger[i].TransactionDate == null) {

          dateblank = "Transaction Date ,";
        }
      }


    }
    blankitems = Accountblank + dateblank;
    if (blankitems != "") {
      isValid = false;
      error = error + "</p>" + "Please enter value for " + blankitems.slice(0, blankitems.length - 2) + "</p>";
    }



    var issuedates = "";
    var uniqueDates = [];
    for (var i = 0; i < this.lstjournalLedger.length; i++) {
      if (!this.isDateInArray(this.lstjournalLedger[i].TransactionDate, uniqueDates)) {
        uniqueDates.push(this.lstjournalLedger[i].TransactionDate);
      }
    }

    if (uniqueDates[0] != null) {
      for (var j = 0; j < uniqueDates.length; j++) {
        sTransactionamount = 0;
        for (var i = 0; i < this.lstjournalLedger.length; i++) {
          var currentdate = new Date(uniqueDates[j].toLocaleDateString());
          var trdate = new Date(this.lstjournalLedger[i].TransactionDate.toLocaleDateString());
          if (currentdate.getTime() == trdate.getTime()) {
            sTransactionamount = sTransactionamount + (parseFloat(this.lstjournalLedger[i].TransactionAmount) * parseFloat(this.lstjournalLedger[i].AssetOrLiability));
          }
        }
        sTransactionamount = parseFloat((sTransactionamount).toFixed(2));
        if (Math.abs(sTransactionamount) != 0) {
          issuedates = issuedates + this.utils.convertDateToBindable(uniqueDates[j]) + ", ";
          //error = error + "<p>" + "Sum of Transaction Amounts should be equals to zero.For date " + this.utils.convertDateToBindable(uniqueDates[j]) + "</p>";
        }
      }
      if (issuedates != "") {
        isValid = false;
        error += "<p>" + "Sum of Transaction Amounts should be equals to zero.For date(s) " + issuedates.slice(0, issuedates.length - 2) + "</p>";
      }
    }


    if (!isValid) {
      this.CustomAlert(error);
    }

    return isValid;
  }
  SaveJournalLedger() {
    for (var i = 0; i < this.lstjournalLedger.length; i++) {
      if (this.lstjournalLedger[i].TransactionDate != null) {
        this.lstjournalLedger[i].TransactionDate = new Date(this.utils.convertDateToBindable(this.lstjournalLedger[i].TransactionDate));
      }

    }
    if (!this.CustomValidator()) {
      return;
    }
    this._isListFetching = true;
    this._journal.JournalEntryDate = this.utils.convertDateToUTC(this._journal.JournalEntryDate);
    this._journal.Listjldc = this.lstjournalLedger;

    for (var i = 0; i < this.lstjournalLedger.length; i++) {
      if (this.lstjournalLedger[i].TransactionDate != null) {
        this.lstjournalLedger[i].TransactionDate = new Date(this.utils.convertDateToUTC(this.lstjournalLedger[i].TransactionDate));
      }

      if (!(Number(this.lstjournalLedger[i].TransactionTypeText).toString() == "NaN" || Number(this.lstjournalLedger[i].TransactionTypeText) == 0))
      {
        this.lstjournalLedger[i].TransactionType = Number(this.lstjournalLedger[i].TransactionTypeText);
        this.lstjournalLedger[i].TransactionTypeText = this.lstTransactionType.find(x => x.LookupID == this.lstjournalLedger[i].TransactionType).Name
      }
      else {
        var filteredarray = this.lstTransactionType.filter(x => x.Name == this.lstjournalLedger[i].TransactionTypeText)
        if (filteredarray.length != 0) {
          this.lstjournalLedger[i].TransactionType = Number(filteredarray[0].LookupID);
          this.lstjournalLedger[i].TransactionTypeText = filteredarray[0].Name;
        }
      }

    }

    this.journalSrv.InsertUpdateJournalLedger(this._journal).subscribe(res => {
      if (res.Succeeded) {
        this._Showsuccessmessage = true;
        this._messageSuccess = "Journal Entry Data Saved Successfully.";
        this._isListFetching = false;

        setTimeout(function () {
          this._Showmessagediv = false;
          this._messageSuccess = "";
          this._Showsuccessmessage = false;

          if (this.actiontype == "new") {
            this._router.navigate(['/journalLedger/n/', res.JournalEntryMasterGUID]);
          } else {
            var returnUrl = this._router.url;
            if (window.location.href.indexOf("journalLedger/n/") > -1) {
              returnUrl = returnUrl.toString().replace('journalLedger/n/', 'journalLedger/u/');

            }
            else if (returnUrl.indexOf("journalLedger/u/") > -1) {
              returnUrl = returnUrl.toString().replace('journalLedger/u/', 'journalLedger/n/');
            }
            this._router.navigate([returnUrl]);
          }
         
        }.bind(this), 1000);

      }
      else {
        this._messageFail = "Error Occurred While Saving Journal Entry.";
        this._ShowmessageWarning = true;
        this._isListFetching = false;
      }
    });
  }

  GetJournalLedgerbyJournalEntryMasterGuid(): void {
    this._isListFetching = true;
    if (this.actiontype == "new") {
      this.JournalEntryMasterGuid = "00000000-0000-0000-0000-000000000000";
    }
    this.journalSrv.GetJournalLedgerbyJournalEntryMasterGuid(this.JournalEntryMasterGuid).subscribe(res => {
      if (res.Succeeded) {
        this._journal = res.journalLedger;

        this.lstjournalLedger = res.ListjournalLedger;
        this.lstdebtandequity = res.AssetList;
        this.lstTransactionType = res.lstLookups;

        for (var i = 0; i < this.lstjournalLedger.length; i++) {
          if (this.lstjournalLedger[i].TransactionDate != null) {
            this.lstjournalLedger[i].TransactionDate = new Date(this.utils.convertDateToBindable(this.lstjournalLedger[i].TransactionDate));
          }
        }
        if (this.lstjournalLedger[0]) {
          if (this.actiontype != "new") {
            this._ShowLastUpdated = true;
          }
          this.LastUpdatedBy = this.lstjournalLedger[0].UpdatedByText;
          this.LastUpdatedDate = new Date(this.utils.convertDateToBindableWithTime(this.lstjournalLedger[0].UpdatedDate));
        }
        this.JournalEntryMasterIDheader = this._journal.JournalEntryMasterID;
        this.cvJournalLedger = new wjcCore.CollectionView(this.lstjournalLedger);
        this.cvJournalLedger.trackChanges = true;
        this.flexJournalLedger.invalidate();
        this._bindGridDropdows();
        setTimeout(function () {
          this._isListFetching = false;
        }.bind(this), 500);
      }
    });
  }

  private _bindGridDropdows() {
    var flexJournalLedger = this.flexJournalLedger;
    if (flexJournalLedger)
    {
      var colLiabilityTypeText = flexJournalLedger.getColumn('DebtEquityAccountID');
      if (colLiabilityTypeText) {
        colLiabilityTypeText.dataMap = this._buildDataMap(this.lstdebtandequity, 'LookupIDGuID', 'Name');
      }
      var colTransactionTypeText = flexJournalLedger.getColumn('TransactionTypeText');
      if (colTransactionTypeText) {
        colTransactionTypeText.dataMap = this._buildDataMap(this.lstTransactionType, 'LookupID', 'Name');
      }       
    }
  }

  addFooterRowngrid(flexJournalLedger: wjcGrid.FlexGrid) {
    var row = new wjcGrid.GroupRow();
    flexJournalLedger.columnFooters.rows.push(row);
    flexJournalLedger.bottomLeftCells.setCellData(0, 0, '\u03A3');
  }

  private _buildDataMap(items: any, key: any, value: any): wjcGrid.DataMap {
    var map = [];
    if (items) {
      for (var i = 0; i < items.length; i++) {
        var obj = items[i];
        map.push({ key: obj[key], value: obj[value] });
      }
    }
    return new wjcGrid.DataMap(map, 'key', 'value');
  }

  onCellEditEnded(flexJournalLedger: wjcGrid.FlexGrid, e: any) {

    var colname = flexJournalLedger.columns[e.col].binding;

    if (colname === 'DebtEquityAccountID') {
      const editedRowData = flexJournalLedger.collectionView.items[e.row];
      if (editedRowData) {
        const selectedValue = editedRowData['DebtEquityAccountID'];
        const selectedItem = this.lstdebtandequity.find(item => item.LookupIDGuID === selectedValue);
        if (selectedItem) {
          editedRowData['AssetOrLiability'] = selectedItem.AssetOrLiability;
          flexJournalLedger.invalidate();
        }
      }
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
    dialogbox.style.zIndex = "10000";
    document.getElementById('dialogboxbody').innerHTML = dialog;
  }

  ok(): void {
    document.getElementById('dialogbox').style.display = "none";
    document.getElementById('dialogoverlay').style.display = "none";
  }
  Cancel(): void {
    try {
      this._location.back();
    } catch (error) {
      this._router.navigate(['dashboard']);
    }
  }

}
const routes: Routes = [

  { path: '', component: JournalLedgerComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjInputModule, WjGridFilterModule],
  declarations: [JournalLedgerComponent]
})

export class journalledgerModule { }
