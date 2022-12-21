import { Component} from "@angular/core";
import { Router} from '@angular/router';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { UtilityService } from '../core/services/utility.service';
import { TranscationreconciliationService } from './../core/services/transcationreconciliation.service';
import { RouterModule, Routes } from '@angular/router';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjInputModule } from '@grapecity/wijmo.angular2.input';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import { FileUploadService } from '../core/services/fileUpload.service';
declare var $: any;


@Component({
  templateUrl: "./transactionAudit.html",
  providers: [TranscationreconciliationService, FileUploadService]
})

export class TransactionAuditComponent {
  public lsttranscationaudit: any;
  public lsttransauditcnt: any;
  public _isShowLoader: boolean = false;
  public _ShowdivMsgWar: boolean = false;
  public _Warningmsg: string = '';
  public _lsttransauditcnt: boolean;

  constructor(
    public utilityService: UtilityService,
    public transserv: TranscationreconciliationService, public fileUploadService: FileUploadService,
    private _router: Router) {
    this.utilityService.setPageTitle("M61-Transaction Audit");
    this.GetAlltranscationaudit();
  }

  GetAlltranscationaudit() {
    this.transserv.getalltranscationaudit().subscribe(res => {
      if (res.Succeeded) {
        this.lsttranscationaudit = res.lstTransactionAudit;
        if (this.lsttranscationaudit) {
          this._lsttransauditcnt = true;
          this._isShowLoader = false;
          for (var i = 0; i < this.lsttranscationaudit.length; i++) {
            if (this.lsttranscationaudit[i].UploadedDate != null) {
              this.lsttranscationaudit[i].UploadedDate = new Date(this.lsttranscationaudit[i].UploadedDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric" });
            }
          }
        } else {
          this._lsttransauditcnt = false;
        }
      }
    });
  }


  DownloadDocument(filename, originalfilename, storagetype, documentStorageID) {
    this._isShowLoader = true;
    documentStorageID = documentStorageID === undefined ? '' : documentStorageID

    var ID = '';
    if (storagetype == 'Box')
      ID = documentStorageID
    else if (storagetype == 'AzureBlob')
      ID = filename;


    this.fileUploadService.downloadObjectDocumentByStorageType(ID, storagetype)
      .subscribe(fileData => {
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
        dwldLink.setAttribute("download", originalfilename);
        dwldLink.style.visibility = "hidden";
        document.body.appendChild(dwldLink);
        dwldLink.click();
        document.body.removeChild(dwldLink);
        this._isShowLoader = false;

      },
        error => {
          //  alert('Something went wrong');
          this._isShowLoader = false;;
        }
      );
  }

  DeleteAuditRecords(BatchLogID) {
    this._isShowLoader = true;
    this.transserv.DeleteAuditbyBatchlogId(BatchLogID).subscribe(res => {
      if (res.Succeeded) {
        this._Warningmsg = 'Deleted Successfully.';
        this.GetAlltranscationaudit();
        this._ShowdivMsgWar = true;

        setTimeout(function () {
          this._ShowdivMsgWar = false;
          this._isShowLoader = false;

        }.bind(this), 2000);
      }
    })


  }
}



const routes: Routes = [

  { path: '', component: TransactionAuditComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjInputModule, WjGridFilterModule],
  declarations: [TransactionAuditComponent]
})

export class transactionAuditComponentModule {}
