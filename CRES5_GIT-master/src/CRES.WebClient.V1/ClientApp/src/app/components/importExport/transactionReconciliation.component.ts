import { Component, ViewChild, Input, Output, EventEmitter, OnInit, AfterViewInit, ElementRef } from "@angular/core";
import { Router, ActivatedRoute } from '@angular/router';
import { TranscationreconciliationService } from '../../core/services/transactionReconciliation.service';
import { PermissionService } from '../../core/services/permission.service';
import { UtilityService } from '../../core/services/utility.service';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { FileUploadService } from '../../core/services/fileUpload.service';
//import { Ng2FileInputModule, Ng2FileInputService, Ng2FileInputAction } from 'ng2-file-input';

import * as wjNg2Input from '@grapecity/wijmo.angular2.input';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjInputModule } from '@grapecity/wijmo.angular2.input';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import * as wjcGrid from '@grapecity/wijmo.grid';
import { Paginated } from '../../core/common/paginated.service';
import { dealService } from '../../core/services/deal.service';
import { NoteService } from '../../core/services/note.service';
import { dndDirectiveModule } from "../../directives/dnd.directive";
import * as wjcInput from '@grapecity/wijmo.input';
import { off } from "process";
import { FlexGridFilter } from '@grapecity/wijmo.grid.filter';
declare var $: any;
function readBase64(file): Promise<any> {
  var reader = new FileReader();
  var future = new Promise((resolve, reject) => {
    reader.addEventListener("load", function () {
      resolve(reader.result);
    }, false);

    reader.addEventListener("error", function (event) {
      reject(event);
    }, false);

    reader.readAsDataURL(file);
  });
  return future;
}

@Component({
  templateUrl: "./transactionReconciliation.html",
  providers: [TranscationreconciliationService, FileUploadService, PermissionService, dealService]
})

export class TranscationreconciliationComponent extends Paginated {
  lstServicer: any;
  @Input() projectId: number = 0;
  @Input() sectionId: number = 0;
  @Input() fileExt: string = "xlsx,csv";
  @Input() maxFiles: number = 1;
  @Input() maxSize: number = 15; // 15MB
  @Output() uploadStatus = new EventEmitter();
  errors: Array<string> = [];
  public actionLog: string = "";
  public fileList: FileList;
  private myFileInputIdentifier: string = "tHiS_Id_IS_sPeeCiAL";
  public isProcessComplete: boolean = false;
  _ShowdivMsgWar: boolean = false;
  _WarmsgdashBoad: any;
  _Showmessagediv: boolean = false;
  _ShowmessagedivMsg: any;
  _servicerName: any;
  _servicerid: any;
  _istransRecordexist: boolean = false;
  public lsttranscation: any;
  public lsthistorytranscation: any;
  lstRecontype: any;
  lstDeltaNonZero: any;
  lstddlOverideValue: any;
  allTransactions: any;
  NonZeroDeltaFilter: any = 0;
  defaultRecontype: any;
  lstNotes: any;
  lstdeals: any;
  closeDate: any;
  startDate: any;
  EndDate: any;
  _showhistory: boolean = false;
  IsReconciled: boolean = false;
  IsException: boolean = false;
  filename: any;
  ScenarioId: string;
  CRENoteId: any;
  NoteName: any;
  norecord: boolean = false;
  isReconcHistory: boolean = false;
  ShowAllTrans: boolean = false;
  _M61chkSelectAll: boolean = false;
  _ServicerSelectAll: boolean = false;
  _IgnoreSelectAll: boolean = false;
  _UnreconcileSelectAll: boolean = false;
  // _EmptySearchMsg: boolean = false;
  _isFilterapply: boolean = false;
  _isFilter: boolean = false;
  TransactionSplitParent: any = [];
  TransactionSplit: any;
  parentTrans: any;
  TotalamtUsedCalc: any;
  public _basecurrencyname: any;
  SplitServicingAmount: any;
  SplitFinal_ValueUsedInCalc: any;
  SplitDelta: any;
  hti: any;
  lstallTransactionType: any;
  TransactionType: any = 0;
  ShowAllUnrecTrans: boolean = false;
  lstfinancingsource: any;
  filterState: string = '';
  startRemitDate: any;
  EndRemitDate: any;
  @ViewChild('flextrans') flextrans: wjcGrid.FlexGrid;
  @ViewChild('flexallTransactions') flexallTransactions: wjcGrid.FlexGrid;
  @ViewChild('flexSplitParentTrans') flexSplitParentTrans: wjcGrid.FlexGrid;
  @ViewChild('flexSplitTrans') flexSplitTrans: wjcGrid.FlexGrid;
  @ViewChild('multiselRecon') multiselRecon: wjNg2Input.WjMultiSelect
  @ViewChild('multiselDeltaNonZero') multiselDeltaNonZero: wjNg2Input.WjMultiSelect
  @ViewChild('multiselNotes') multiselNotes: wjNg2Input.WjMultiSelect
  @ViewChild('multiselDeals') multiselDeals: wjNg2Input.WjMultiSelect
  @ViewChild('multiselTransactionType') multiselTransactionType: wjNg2Input.WjMultiSelect
  @ViewChild('ctxSplitMenu') ctxSplitMenu: wjcInput.Menu;
  @ViewChild('M61chkSelectAll') M61chkSelectAll: ElementRef;
  @ViewChild('ServicerchkSelectAll') ServicerchkSelectAll: ElementRef;
  @ViewChild('multiselFinancingSource') multiselFinancingSource: wjNg2Input.WjMultiSelect;
  @ViewChild('filter', { static: false }) flexfilter!: FlexGridFilter;
  constructor(
    public fileUploadService: FileUploadService,
    public permissionService: PermissionService,
    public utilityService: UtilityService,
    public transserv: TranscationreconciliationService,
    public dealSrv: dealService,
    public noteService: NoteService,
    private _router: Router) {
    // this.GetUserPermission();
    super(50, 1, 0);
    this.GetAllServicer();
    this.GetAllLookups();
    this.GetAllDealsForFilter();
    this.GetAllTransactionType();
    this.GetFinancingSource();
    this.ScenarioId = window.localStorage.getItem("scenarioid");
    this.utilityService.setPageTitle("M61-Transaction Reconciliation");
  }
  saveFilterState() {
    if (this.flexfilter) {
      this.filterState = this.flexfilter.filterDefinition;
    }
  }

  restoreFilterState() {
    if (this.flexfilter && this.filterState) {
      this.flexfilter.filterDefinition = this.filterState;
    }
  }

  // Component views are initialized
  ngAfterViewInit() {
    var type = "";
    
    this.flextrans.scrollPositionChanged.addHandler(() => {
      var myDiv = $('#flextrans').find('div[wj-part="root"]');
      if (!this.isReconcHistory) {
        if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
          if (this.flextrans.rows.length < this._totalCount) {
            this._pageIndex = this.pagePlus(1);

            if (this.ShowAllTrans) {
              type = "ShowAllTransaction";
            } else {
              type = "";
            }
            if (JSON.parse(this.filterState).filters.length == 0)
              this.GetAllTranscationNew(type);
            else
              this._pageIndex = 1;
          }
        }
      }
    });
  }


  GetAllLookups(): void {
    this.dealSrv.getAllLookup().subscribe(res => {
      var data = res.lstLookups;

      this.lstRecontype = data.filter(x => x.ParentID == "82");
      this.lstDeltaNonZero = data.filter(x => x.ParentID == "83");
      this.lstddlOverideValue = data.filter(x => x.ParentID == "108");

      this._bindGridDropdows();

    });
  }




  GetFinancingSource(): void {
    this.noteService.GetFinancingSource().subscribe(res => {
      if (res.Succeeded) {
        this.lstfinancingsource = res.lstfinancingsource;
        for (var i = 0; i < this.lstfinancingsource.length; i++) {
          this.lstfinancingsource[i].selected = true;
        }
      }
    });
  }
  GetAllNotes() {
    this.transserv.getAllNotes().subscribe(res => {
      if (res.Succeeded) {
        this.lstNotes = res.lstNotes;
      }
    });
  }


  GetAllDealsForFilter() {
    this.transserv.getAllDealsForFilter(this.IsReconciled).subscribe(res => {
      if (res.Succeeded) {
        this.lstdeals = res.lstDeals;
      }
    });
  }



  AppliedReadOnly() {
    if (this.lsttranscation) {
      for (var i = 0; i <= (this.lsttranscation.length - 1); i++) {
        if (this.lsttranscation[i].isRecon == false) {
          if (this.flextrans.rows[i]) {
            this.flextrans.rows[i].isReadOnly = true;
            this.flextrans.rows[i].cssClass = "customgridrowcolor";
          }
        }
      }
    }
  }



  GetAllServicer(): void {
    this.transserv.getAllServicer().subscribe(res => {
      if (res.Succeeded) {
        this.lstServicer = res.lstServicer;
        if (this.lstServicer.length > 0) {
          this.closeDate = new Date(this.lstServicer[0].CloseDate.toString());
        }
        this.lstServicer = this.lstServicer.filter(x => x.SericerName != 'ManualCashFlowRecon');
        this.GetAllTranscationNew();
      }
    })
  }



  GetAllTransactionType(): void {
    this.transserv.getAllTransactionType().subscribe(res => {
      if (res.Succeeded) {
        this.lstallTransactionType = res.dt;
      }
    })
  }

  Reconciliation(): void {
    this.isProcessComplete = true;
    var exceptionmessage = '';
    var isValidate = true;
    if (this.flextrans.rows.length > 0) {
      var rectrans = [];
      for (var k = 0; k < this.flextrans.rows.length; k++) {
        rectrans.push(this.flextrans.rows[k].dataItem);
      }

      var reconTrans = rectrans.filter(x => x.M61Value == true || x.ServicerValue == true || x.Ignore == true || x.OverrideValue != null);
      var errnotes = '';
      if (reconTrans.length > 0) {
        for (var i = 0; i < reconTrans.length; i++) {
          if (this.ShowAllUnrecTrans)
            reconTrans[i]["ShowAllUnrecTrans"] = true;
          else
            reconTrans[i]["ShowAllUnrecTrans"] = false;


          if (!reconTrans[i].OverrideReasonText) {
            if (reconTrans[i].Exception == 'Exception' && (reconTrans[i].comments == '' || !reconTrans[i].comments)) {
              if (isValidate) {
                exceptionmessage = 'Please enter comment for the notes having Exception before reconciling.';
                isValidate = false;
              }
            }
          }

          if (reconTrans[i].OverrideValue || reconTrans[i].OverrideValue == 0) {
            if (reconTrans[i].OverrideReasonText == null) {
              if (isValidate) {
                isValidate = false;
                exceptionmessage = "Please select 'Override Reason' for the overridden value(s).";
              }
            }
          }


          if (reconTrans[i].RemittanceDate == null || reconTrans[i].RemittanceDate == "") {
            isValidate = false;
            exceptionmessage = "Please enter Remit Date before reconciling.";
          }

          if (reconTrans[i].AddlInterest || reconTrans[i].TotalInterest) {
            if (reconTrans[i].TransactionType == 'InterestPaid') {  //line added by vishal

              var totCashCapital = Math.abs(parseFloat(reconTrans[i].AddlInterest)) + Math.abs(parseFloat(reconTrans[i].TotalInterest));
              totCashCapital = parseFloat(totCashCapital.toFixed(2));
              if (reconTrans[i].M61Value) {
                if (totCashCapital != reconTrans[i].CalculatedAmount) {
                  isValidate = false;
                  errnotes += reconTrans[i].CRENoteID + ", ";
                }
              }
              if (reconTrans[i].ServicerValue) {
                if (totCashCapital != reconTrans[i].ServicingAmount) {
                  isValidate = false;
                  errnotes += reconTrans[i].CRENoteID + ", ";
                }
              }

              if (reconTrans[i].OverrideValue) {
                if (totCashCapital != reconTrans[i].OverrideValue) {
                  isValidate = false;
                  errnotes += reconTrans[i].CRENoteID + ", ";
                }
              }

            }
          }
          //if (reconTrans[i].AddlInterest || reconTrans[i].TotalInterest) {
          //  var totCashCapital = parseFloat(reconTrans[i].AddlInterest) + parseFloat(reconTrans[i].TotalInterest);
          //  if (totCashCapital == reconTrans[i].CalculatedAmount || totCashCapital == reconTrans[i].ServicingAmount || totCashCapital == reconTrans[i].OverrideValue) {
          //    isValidate = false;
          //    exceptionmessage = "Sum of Cash Interest and Capitalized Interest can not be equal to M61 Amount/ Servicing Amount/Override Value.";
          //  }
          //}


          if (isValidate) {
            if (reconTrans[i].TransactionDate != null) {
              reconTrans[i].TransactionDate = this.convertDateToBindable(reconTrans[i].TransactionDate);
            }
            if (reconTrans[i].DateDue != null) {
              reconTrans[i].DateDue = this.convertDateToBindable(reconTrans[i].DateDue);
            }
            if (reconTrans[i].RemittanceDate != null) {
              reconTrans[i].RemittanceDate = this.convertDateToBindable(reconTrans[i].RemittanceDate);
            }


            if (reconTrans[i].Delta % 1 == 0) {
              reconTrans[i].Delta = (reconTrans[i].Delta * 100 / 100).toFixed(2);// = 0.000001;
            } else
              reconTrans[i].Delta = reconTrans[i].Delta.toString();
            if (reconTrans[i].ActualDelta % 1 == 0)
              reconTrans[i].ActualDelta = (reconTrans[i].ActualDelta * 100 / 100).toFixed(2);
            else
              reconTrans[i].ActualDelta = reconTrans[i].ActualDelta.toString();

            if (reconTrans[i].Adjustment % 1 == 0) {
              reconTrans[i].Adjustment = (reconTrans[i].Adjustment * 100 / 100).toFixed(2);
            }
            else
              reconTrans[i].Adjustment = reconTrans[i].Adjustment.toString();

            if (reconTrans[i].AddlInterest % 1 == 0)
              reconTrans[i].AddlInterest = (reconTrans[i].AddlInterest * 100 / 100).toFixed(2);
            else
              reconTrans[i].AddlInterest = (reconTrans[i].AddlInterest).toString();

            if (reconTrans[i].TotalInterest % 1 == 0)
              reconTrans[i].TotalInterest = (reconTrans[i].TotalInterest * 100 / 100).toFixed(2);
            else
              reconTrans[i].TotalInterest = reconTrans[i].TotalInterest.toString();

            if (reconTrans[i].ServicingAmount % 1 == 0)
              reconTrans[i].ServicingAmount = (reconTrans[i].ServicingAmount * 100 / 100).toFixed(2);
            else
              reconTrans[i].ServicingAmount = (reconTrans[i].ServicingAmount).toString();

            if (reconTrans[i].CalculatedAmount % 1 == 0) {
              reconTrans[i].CalculatedAmount = (reconTrans[i].CalculatedAmount * 100 / 100).toFixed(2);
            }
            else
              reconTrans[i].CalculatedAmount = (reconTrans[i].CalculatedAmount).toString();

            //commented by vishal
            //if (reconTrans[i].OverrideValue % 1 == 0) {
            //  reconTrans[i].OverrideValue = (reconTrans[i].OverrideValue * 100 / 100).toFixed(2);
            //}
            //else
            //  reconTrans[i].OverrideValue = (reconTrans[i].OverrideValue).toString();

            if (reconTrans[i].OverrideReason) {
              reconTrans[i].OverrideReason = (reconTrans[i].OverrideReason).toString();
            }
            if (!(Number(reconTrans[i].OverrideReasonText).toString() == "NaN" || Number(reconTrans[i].OverrideReasonText) == 0)) {
              reconTrans[i].OverrideReason = reconTrans[i].OverrideReasonText.toString();
            }

            if (reconTrans[i].OverrideReasonText) {
              reconTrans[i].OverrideReasonText = (reconTrans[i].OverrideReasonText).toString();
            }


            if (reconTrans[i].DueDateAlreadyReconciled) {
              if (reconTrans[i].DueDateAlreadyReconciled == "Yes") {
                reconTrans[i].DueDateAlreadyReconciled = 1;
              }
              else {
                reconTrans[i].DueDateAlreadyReconciled = 0;
              }

            }

          }
        }
        if (isValidate) {
          this.transserv.InsertupdateTranscation(reconTrans).subscribe(res => {
            if (res.Succeeded) {
              if (this._pageIndex != 1)
                this._pageIndex = 1;
              this._isFilterapply = false;
              if (this._isFilter) {
                this.FilterData();
              }
              else {
                this.GetAllTranscationNew();
                this.TransactionType = 0;
              }
              this._Showmessagediv = true;
              this._ShowmessagedivMsg = res.Message;
              this.isProcessComplete = false;
              this._ShowdivMsgWar = false;

            }
            else {
              this._Showmessagediv = false;
              this._ShowdivMsgWar = true;
              this._WarmsgdashBoad = res.Message;
              this.isProcessComplete = false;

            }
          })
        }
        else {
          if (errnotes != "") {
            errnotes = errnotes.slice(0, errnotes.length - 2);
            exceptionmessage = "Sum of cash and capitalized interest should be equal to the amount being reconciled for the following note(s): " + errnotes;
          }

          this.CustomAlert(exceptionmessage);
          this.isProcessComplete = false;
          this._Showmessagediv = false;
          this._ShowmessagedivMsg = '';
        }
      }
      else {
        this.isProcessComplete = false;
      }
    }

    else {
      this.isProcessComplete = false;
    }
  }


  SaveReconcile(): void {
    this.isProcessComplete = true;
    if (this.lsttranscation.length > 0) {
      for (var i = 0; i < this.lsttranscation.length; i++) {
        if (this.lsttranscation[i].Delta % 1 == 0) {
          this.lsttranscation[i].Delta = (this.lsttranscation[i].Delta * 100 / 100).toFixed(2);// = 0.000001;
        }
        else
          this.lsttranscation[i].Delta = this.lsttranscation[i].Delta.toString();

        if (this.lsttranscation[i].ActualDelta % 1 == 0) {
          this.lsttranscation[i].ActualDelta = (this.lsttranscation[i].ActualDelta * 100 / 100).toFixed(2);
        }
        else
          this.lsttranscation[i].ActualDelta = this.lsttranscation[i].ActualDelta.toString();

        if (this.lsttranscation[i].Adjustment % 1 == 0) {
          this.lsttranscation[i].Adjustment = parseFloat((this.lsttranscation[i].Adjustment * 100 / 100).toFixed(2));
        } else
          this.lsttranscation[i].Adjustment = this.lsttranscation[i].Adjustment.toString();


        if (this.lsttranscation[i].AddlInterest % 1 == 0) {
          this.lsttranscation[i].AddlInterest = (this.lsttranscation[i].AddlInterest * 100 / 100).toFixed(2);
        } else
          this.lsttranscation[i].AddlInterest = this.lsttranscation[i].AddlInterest.toString();

        if (this.lsttranscation[i].TotalInterest % 1 == 0) {
          this.lsttranscation[i].TotalInterest = (this.lsttranscation[i].TotalInterest * 100 / 100).toFixed(2);
        } else
          this.lsttranscation[i].TotalInterest = this.lsttranscation[i].TotalInterest.toString();

        if (this.lsttranscation[i].ServicingAmount % 1 == 0) {
          this.lsttranscation[i].ServicingAmount = (this.lsttranscation[i].ServicingAmount * 100 / 100).toFixed(2);
        } else
          this.lsttranscation[i].ServicingAmount = this.lsttranscation[i].ServicingAmount.toString();

        if (this.lsttranscation[i].CalculatedAmount % 1 == 0) {
          this.lsttranscation[i].CalculatedAmount = (this.lsttranscation[i].CalculatedAmount * 100 / 100).toFixed(2);
        } else
          this.lsttranscation[i].CalculatedAmount = this.lsttranscation[i].CalculatedAmount.toString();

        if (this.lsttranscation[i].OverrideValue) {
          if (this.lsttranscation[i].OverrideValue % 1 == 0) {
            this.lsttranscation[i].OverrideValue = (this.lsttranscation[i].OverrideValue * 100 / 100).toFixed(2);
          }
          else
            this.lsttranscation[i].OverrideValue = (this.lsttranscation[i].OverrideValue).toString();
        }
        if (this.lsttranscation[i].OverrideReason) {
          this.lsttranscation[i].OverrideReason = (this.lsttranscation[i].OverrideReason).toString();
        }

        if (this.lsttranscation[i].OverrideReasonText) {
          this.lsttranscation[i].OverrideReasonText = (this.lsttranscation[i].OverrideReasonText).toString();
        }

        if (this.lsttranscation[i].DueDateAlreadyReconciled) {
          if (this.lsttranscation[i].DueDateAlreadyReconciled == "Yes") {
            this.lsttranscation[i].DueDateAlreadyReconciled = 1;
          }
          else {
            this.lsttranscation[i].DueDateAlreadyReconciled = 0;
          }

        }


      }


      this.transserv.SaveTranscation(this.lsttranscation).subscribe(res => {
        if (res.Succeeded) {
          this._Showmessagediv = true;
          this._ShowmessagedivMsg = res.Message;
          this.isProcessComplete = false;
          this._ShowdivMsgWar = false;
        }
        else {
          this._ShowdivMsgWar = true;
          this._WarmsgdashBoad = res.Message;
          this.isProcessComplete = false;
          this._Showmessagediv = false;
        }
        // setTimeout(function () {
        //    this._Showmessagediv = false;
        //   this._ShowmessagedivMsg = '';
        //  this._WarmsgdashBoad = '';
        this.isProcessComplete = false;
        this.flextrans.invalidate();

        // }.bind(this), 2000);


      });
    } else {
      this.isProcessComplete = false;
    }
  }

  //GetAllTranscation(): void {

  //    this.isProcessComplete = true;
  //    this.transserv.getAllTranscation().subscribe(res => {
  //        if (res.Succeeded) {
  //            this._showhistory = false;

  //            this.lsttranscation = res.dtCalcReq;
  //            if (this.lsttranscation.length > 0) {
  //                this._istransRecordexist = true;

  //                for (var i = 0; i < this.lsttranscation.length; i++) {
  //                    if (this.lsttranscation[i].DateDue != null) {
  //                        this.lsttranscation[i].DateDue = new Date(this.lsttranscation[i].DateDue.toString());
  //                    }

  //                    if (this.lsttranscation[i].TransactionDate != null) {
  //                        this.lsttranscation[i].TransactionDate = new Date(this.lsttranscation[i].TransactionDate.toString());
  //                    }

  //                    if (this.lsttranscation[i].RemittanceDate != null) {
  //                        this.lsttranscation[i].RemittanceDate = new Date(this.lsttranscation[i].RemittanceDate.toString());
  //                    }
  //                }

  //                setTimeout(function () {
  //                    this.isProcessComplete = false;
  //                    this.flextrans.invalidate();

  //                    this.GetAllDealsForFilter();
  //                }.bind(this), 500);

  //            }
  //            else {
  //                this._istransRecordexist = false;
  //                this.isProcessComplete = false;
  //            }

  //        }
  //    })
  //}


  private _bindGridDropdows() {
    if (this.flextrans) {
      var colOverReas = this.flextrans.columns.getColumn('OverrideReasonText');

      if (colOverReas) {
        colOverReas.showDropDown = true;
        colOverReas.dataMap = this._buildDataMap(this.lstddlOverideValue);
      }
    }
  }

  private _buildDataMap(items): wjcGrid.DataMap {
    var map = [];

    for (var i = 0; i < items.length; i++) {
      var obj = items[i];
      map.push({ key: obj['LookupID'], value: obj['Name'] });
    }
    return new wjcGrid.DataMap(map, 'key', 'value');
  }


  GetAllTranscationNew(type: any = ""): void {
    this.saveFilterState();
    var data: any;
    var type: any;
    if (!this._isFilterapply) {
      this.isProcessComplete = true;
      if (type == "") {
        if (this.ShowAllTrans) {
          type = "ShowAllTransaction";
        } else {
          type = "";
        }
      }

      this.transserv.getAllTranscationNew(type, this._pageIndex, this._pageSize).subscribe(res => {
        if (res.Succeeded) {
          this.flextrans.columns[8].isReadOnly = true;
          this._showhistory = false;
          data = res.dtCalcReq;
          this._totalCount = res.TotalCount;
          this.isProcessComplete = false;
          if (this._pageIndex == 1) {
            this.lsttranscation = data;
            // this.flextrans.selectionMode = wjcGrid.SelectionMode.None;
          }
          else {
            this.lsttranscation = this.lsttranscation.concat(data);
          }
         
          //format date
          if (this.lsttranscation.length > 0) {
            this._istransRecordexist = true;

            for (var i = 0; i < this.lsttranscation.length; i++) {

              if (this.lsttranscation[i].DateDue != null) {
                this.lsttranscation[i].DateDue = new Date(this.lsttranscation[i].DateDue.toString());
              }

              if (this.lsttranscation[i].TransactionDate != null) {
                this.lsttranscation[i].TransactionDate = new Date(this.lsttranscation[i].TransactionDate.toString());
              }

              if (this.lsttranscation[i].RemittanceDate != null) {
                this.lsttranscation[i].RemittanceDate = new Date(this.lsttranscation[i].RemittanceDate.toString());
              }

              if (this.lsttranscation[i].Delta % 1 == 0) {

                this.lsttranscation[i].Delta = (this.lsttranscation[i].Delta * 100 / 100).toFixed(2);
              }

              if (this.lsttranscation[i].ActualDelta % 1 == 0) {
                this.lsttranscation[i].ActualDelta = (this.lsttranscation[i].ActualDelta * 100 / 100).toFixed(2);
              }

              if (this.lsttranscation[i].Adjustment % 1 == 0) {
                this.lsttranscation[i].Adjustment = (this.lsttranscation[i].Adjustment * 100 / 100).toFixed(2);
              }

              if (this.lsttranscation[i].AddlInterest % 1 == 0) {
                this.lsttranscation[i].AddlInterest = (this.lsttranscation[i].AddlInterest * 100 / 100).toFixed(2);
              }

              if (this.lsttranscation[i].TotalInterest % 1 == 0) {
                this.lsttranscation[i].TotalInterest = (this.lsttranscation[i].TotalInterest * 100 / 100).toFixed(2);
              }

              if (this.lsttranscation[i].ServicingAmount % 1 == 0) {
                this.lsttranscation[i].ServicingAmount = (this.lsttranscation[i].ServicingAmount * 100 / 100).toFixed(2);
              }

              if (this.lsttranscation[i].CalculatedAmount % 1 == 0) {
                this.lsttranscation[i].CalculatedAmount = (this.lsttranscation[i].CalculatedAmount * 100 / 100).toFixed(2);
              }
            }
          }


         // Restore filters after data loads
          setTimeout(function () {
          this.restoreFilterState();
          }.bind(this), 100);

          if (type == "RefreshM61Amount") {
            this._Showmessagediv = true;
            this._ShowmessagedivMsg = "M61 values updated successfully.";
            this._ShowdivMsgWar = false;
            setTimeout(function () {
              this._Showmessagediv = false;
              this._ShowmessagedivMsg = '';

            }.bind(this), 2000);
          }

        }
        else {
          this.utilityService.navigateToSignIn();
        }
      });
    }
    else {

      for (var i = 0; i < this.lsttranscation.length; i++) {
        if (this.lsttranscation[i].DueDateAlreadyReconciled == 1) {
          this.lsttranscation[i].DueDateAlreadyReconciled = "Yes";
        }
        else {
          this.lsttranscation[i].DueDateAlreadyReconciled = "No";
        }

      }

    }
   
      
   
  }


  ReconciledHistory(val): void {
    this.IsReconciled = val;
   // this.GetAllDealsForFilter();
    this.ShowAllUnrecTrans = false;

  }

  onChangeShowAllTransaction(val): void {
    if (val) {
      this.ShowAllTrans = true;
      this._pageIndex = 1;
    } else {
      this.ShowAllTrans = false;
      this._pageIndex = 1;
    }
    this.GetAllTranscationNew();
  }

  onChangeShowAllUnreconTransaction(val): void {
    if (val) {
      this.ShowAllUnrecTrans = true;
      var date = new Date();
      var firstDay = this.convertDateToBindable(new Date(date.getFullYear(), date.getMonth(), 1));
      var lastDay = this.convertDateToBindable(new Date(date.getFullYear(), date.getMonth() + 1, 0));
      this.startDate = firstDay;
      this.EndDate = lastDay;
      this.IsException = false;
      this.IsReconciled = false;
      this.ShowAllTrans = false;
      $('#btnSave').prop('disabled', true);
      this.onChangeShowAllTransaction(false);
    }
    else {
      $('#btnSave').prop('disabled', false);
      this.ShowAllUnrecTrans = false;
      this.startDate = null;
      this.EndDate = null;
    }
  }


  getExceptions(val): void {
    this.IsException = val;
  }

  public unRecCheckbox(item, val) {
    this.flextrans.invalidate();
    var isReccc = this.lsttranscation.filter(x => x.Transcationid == item.Transcationid)
    if (val == true) {
      isReccc[0].isRecon = 1;
     // item.isRecon = 1;
    }
    else {
      isReccc[0].isRecon =0;
    }
  }


  Unreconcile(): void {
    var unrec = [];
    for (var i = 0; i < this.flextrans.rows.length; i++) {
      if (this.flextrans.rows[i].dataItem.isRecon == true) {
        unrec.push(this.flextrans.rows[i].dataItem);
      }
    }
  // var unrec = this.lsttranscation.filter(x => x.isRecon == 1);
    if (unrec.length > 0) {
      this.isProcessComplete = true;

      for (var i = 0; i < unrec.length; i++) {
        if (unrec[i].TransactionDate != null) {
          unrec[i].TransactionDate = this.convertDateToBindable(unrec[i].TransactionDate);
        }
        if (unrec[i].DateDue != null) {
          unrec[i].DateDue = this.convertDateToBindable(unrec[i].DateDue);
        }
        if (unrec[i].RemittanceDate != null) {
          unrec[i].RemittanceDate = this.convertDateToBindable(unrec[i].RemittanceDate);
        }
        if (unrec[i].DueDateAlreadyReconciled == "Yes") {
          unrec[i].DueDateAlreadyReconciled = 1;
        }
        else {
          unrec[i].DueDateAlreadyReconciled = 0;
        }
      }
      this.transserv.UnreconcileTranscation(unrec).subscribe(res => {
        if (res.Succeeded) {
          this._isFilterapply = false;
          this._isFilter = false;

          this.GetAllTranscationNew();
          this.TransactionType = 0;
          this._Showmessagediv = true;
          this._ShowmessagedivMsg = res.Message;
          this.isProcessComplete = false;
          this.IsReconciled = false;

          this._ShowdivMsgWar = false;
        }
        else {
          this._ShowdivMsgWar = true;
          this._Showmessagediv = false;
          this._WarmsgdashBoad = res.Message;
          this.isProcessComplete = false;
        }

      });
    }
    else {
      this.CustomAlert('Please check any record to Unreconcile.');
    }
  }
  ClearFilter(): void {
    this.startDate = null;
    this.EndDate = null;
    this._isFilterapply = false;
    this._isFilter = false;
    this.NonZeroDeltaFilter = 0;
    this.TransactionType = 0;
    this._pageIndex = 1;
    this.IsReconciled = false;
    this.multiselDeals.checkedItems = [];
    this.multiselTransactionType.checkedItems = [];
    this.multiselFinancingSource.checkedItems = [];
    this.ShowAllTrans = false;
    this.IsException = false;
    this.ShowAllUnrecTrans = false;
    this.GetAllTranscationNew();

  }

  FilterData(): void {
    var Deltafilter = '';
    // var Notesfilter = ''
    this._showhistory = false;
    this.isProcessComplete = true;
    if (this.startDate && this.EndDate) {

      if (this.startDate > this.EndDate) {
        this.CustomAlert("End date can not be smaller then Start date.");
        this.isProcessComplete = false;
        return;
      }
      if (this.startDate == this.EndDate) {
        this.CustomAlert("Start date and End date can not be equal.");
        this.isProcessComplete = false;
        return;
      }
    }

    //if (this.multiselNotes != undefined)
    //    var Notesfilter = this.multiselNotes.checkedItems.map(({ CRENoteID }) => CRENoteID).join(',')


    if (this.multiselDeals != undefined)
      var Dealsfilter = "'" + this.multiselDeals.checkedItems.map(({ CREDealID }) => CREDealID).join("','");

    if (this.multiselTransactionType != undefined)
      var TransactionTypefilter = "'" + this.multiselTransactionType.checkedItems.map(({ TransactionType }) => TransactionType).join("','");


    if (this.multiselFinancingSource != undefined)
    //  var FinancingSourcefilter = "'" + this.multiselFinancingSource.checkedItems.map(({ FinancingSourceName }) => FinancingSourceName).join("','");

    var FinancingSourceIDfilter = "'" + this.multiselFinancingSource.checkedItems.map(({ FinancingSourceMasterID }) => FinancingSourceMasterID).join("','");


    var searchstr = '';
    searchstr = "#" + this.convertDateToBindable(this.startDate);
    searchstr = searchstr + "#" + this.convertDateToBindable(this.EndDate);
    searchstr = searchstr + "#" + this.NonZeroDeltaFilter;
    // searchstr = searchstr + "#" + Notesfilter;
    searchstr = searchstr + "#" + Dealsfilter + "'";
    searchstr = searchstr + "#" + this.IsReconciled;
    searchstr = searchstr + "#" + this.IsException;
    searchstr = searchstr + "#" + TransactionTypefilter + "'";
    searchstr = searchstr + "#" + this.ShowAllTrans;
    searchstr = searchstr + "#" + FinancingSourceIDfilter + "'";
    searchstr = searchstr + "#" + this.ShowAllUnrecTrans;
    searchstr = searchstr + "#" + this.convertDateToBindable(this.startRemitDate);
    searchstr = searchstr + "#" + this.convertDateToBindable(this.EndRemitDate);

    this.isReconcHistory = this.IsReconciled;


    if (this.ShowAllUnrecTrans) {
      this.flextrans.columns[8].isReadOnly = false;
      this.flextrans.columns[11].isReadOnly = false;
    }
    else {
      this.flextrans.columns[8].isReadOnly = true;
      this.flextrans.columns[11].isReadOnly = true;
    }


    this.transserv.FilterTranscations(searchstr).subscribe(res => {
      if (res.Succeeded) {
        this._ShowdivMsgWar = false;
        this._WarmsgdashBoad = '';
        this._isFilterapply = true;
        this._isFilter = true;
        this.lsttranscation = res.dtCalcReq;
        if (this.lsttranscation.length > 0) {
          for (var i = 0; i < this.lsttranscation.length; i++) {
            if (this.lsttranscation[i].DateDue != null) {
              this.lsttranscation[i].DateDue = new Date(this.lsttranscation[i].DateDue.toString());
            }


            if (this.lsttranscation[i].LastAccountingCloseDate != null) {
              this.lsttranscation[i].LastAccountingCloseDate = new Date(this.lsttranscation[i].LastAccountingCloseDate.toString());
            }



            if (this.lsttranscation[i].TransactionDate != null) {
              this.lsttranscation[i].TransactionDate = new Date(this.lsttranscation[i].TransactionDate.toString());
            }


            if (this.lsttranscation[i].RemittanceDate != null) {
              this.lsttranscation[i].RemittanceDate = new Date(this.lsttranscation[i].RemittanceDate.toString());
            }


            if (this.lsttranscation[i].Delta % 1 == 0) {
              this.lsttranscation[i].Delta = (this.lsttranscation[i].Delta * 100 / 100).toFixed(2);// = 0.000001;
            }

            if (this.lsttranscation[i].ActualDelta % 1 == 0) {
              this.lsttranscation[i].ActualDelta = (this.lsttranscation[i].ActualDelta * 100 / 100).toFixed(2);
            }

            if (this.lsttranscation[i].Adjustment % 1 == 0) {
              this.lsttranscation[i].Adjustment = parseFloat((this.lsttranscation[i].Adjustment * 100 / 100).toFixed(2));
            }

            if (this.lsttranscation[i].AddlInterest % 1 == 0) {
              this.lsttranscation[i].AddlInterest = (this.lsttranscation[i].AddlInterest * 100 / 100).toFixed(2);
            }

            if (this.lsttranscation[i].TotalInterest % 1 == 0) {
              this.lsttranscation[i].TotalInterest = (this.lsttranscation[i].TotalInterest * 100 / 100).toFixed(2);
            }

            if (this.lsttranscation[i].ServicingAmount % 1 == 0) {
              this.lsttranscation[i].ServicingAmount = (this.lsttranscation[i].ServicingAmount * 100 / 100).toFixed(2);
            }

            if (this.lsttranscation[i].CalculatedAmount % 1 == 0) {
              this.lsttranscation[i].CalculatedAmount = (this.lsttranscation[i].CalculatedAmount * 100 / 100).toFixed(2);
            }


          }
          setTimeout(function () {
            this.flextrans.invalidate();
            for (var i = 0; i < this.lsttranscation.length; i++) {
              if (this.lsttranscation[i].isRecon == false) {
                this._showhistory = true;
                this.flextrans.rows[i].isReadOnly = true;
                this.flextrans.rows[i].cssClass = "customgridrowcolor";
                this.isProcessComplete = false;
              }
            }
          }.bind(this), 500);
          this.isProcessComplete = false;
        }
        else {
          //this._ShowdivMsgWar = true;
          //this._WarmsgdashBoad = res.Message;
          this.isProcessComplete = false;
        }

      }
      else {
        this._Showmessagediv = false;
        this._ShowdivMsgWar = true;
        this._WarmsgdashBoad = res.Message;
        this.isProcessComplete = false;

      }

      // setTimeout(function () {
      //  this._Showmessagediv = false;
      // this._ShowdivMsgWar = false;
      // this._ShowmessagedivMsg = '';
      //   this._WarmsgdashBoad = '';
      // }.bind(this), 5000);
    })
  }

  servicerClicked(servicer): void {
    this._servicerName = servicer.SericerName;
    this._servicerid = servicer.ServicerMasterID;
  }


  ChangeCheckbox(recval): void {
    for (var i = 0; i < this.lsttranscation.length; i++) {
      if (recval == 'Servicing') {
        this.lsttranscation[i].ServicerValue = true;
        this.lsttranscation[i].M61Value = false;
        this.lsttranscation[i].Ignore = false;
      }
      if (recval == 'M61') {
        this.lsttranscation[i].ServicerValue = false;
        this.lsttranscation[i].M61Value = true;
        this.lsttranscation[i].Ignore = false;

      }
      if (recval == 'Ignore') {
        this.lsttranscation[i].ServicerValue = false;
        this.lsttranscation[i].M61Value = false;
        this.lsttranscation[i].Ignore = true;
      }
    }

    this.flextrans.invalidate();
  }


  GetUserPermission(): void {
    this.permissionService.GetUserPermissionByPagename("Integration").subscribe(res => {
      if (res.Succeeded) {
        if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
        }
        else {
          localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
          localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));

          this.utilityService.navigateUnauthorize();
        }
      }
    });
  }

  public onAction(event: any, servicer: any) {
    $('.ng2-file-input-file-text').text('');
    this._servicerName = servicer.SericerName;
    this._servicerid = servicer.ServicerMasterID;
    this.actionLog += "\n currentFiles: " + this.getFileNames(event.currentFiles);
    console.log(this.actionLog);
    //let fileList: FileList = event.currentFiles;
    this.fileList = event.currentFiles;
    //this.saveFiles(this.fileList);
  }


  convertDateToBindable(date) {
    if (date) {
      var dateObj = new Date(date);
      return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear();
    }
  }

  getTwoDigitString(number) {
    if (number.toString().length === 1)
      return "0" + number;
    return number;
  }

  public onAdded(event: any) {
    this.actionLog += "\n FileInput: " + event.id;
    this.actionLog += "\n Action: File added";
    this.filename = event.file.name;
    this.showDialog();

    console.log('onAdded');
  }

  public onRemoved(event: any) {
    this.actionLog += "\n FileInput: " + event.id;
    this.actionLog += "\n Action: File removed";
  }

  public onInvalidDenied(event: any) {
    this.actionLog += "\n FileInput: " + event.id;
    this.actionLog += "\n Action: File denied";
  }

  public onCouldNotRemove(event: any) {
    this.actionLog += "\n FileInput: " + event.id;
    this.actionLog += "\n Action: Could not remove file";
  }

  //public resetFileInput(file): void {
  //  this.ng2FileInputService.reset(this.myFileInputIdentifier);
  //}


  //public logCurrentFiles(): void {
  //  let files = this.ng2FileInputService.getCurrentFiles(this.myFileInputIdentifier);
  //  this.actionLog += "\n The currently added files are: " + this.getFileNames(files);
  //}
  private getFileNames(files: File[]): string {
    let names = files.map(file => file.name);
    return names ? names.join(", ") : "No files currently added.";
  }

  private isValidFiles(files) {
    // Check Number of files
    if (files.length > this.maxFiles) {
      this.errors.push("At a time you can upload only " + this.maxFiles + " file <BR/>");
      return;
    }
    this.isValidFileExtension(files);
    return this.errors.length === 0;
  }

  private isValidFileExtension(files) {
    // Make array of file extensions
    var extensions = (this.fileExt.split(','))
      .map(function (x) { return x.toLocaleUpperCase().trim() });
    for (var i = 0; i < files.length; i++) {
      // Get file extension
      var ext = files[i].name.toUpperCase().split('.').pop() || files[i].name;
      // Check the extension exists
      var exists = extensions.includes(ext);
      if (!exists) {
        this.errors.push("Please upload files with " + this.fileExt + " extension.");
      }
      // Check file size
      this.isValidFileSize(files[i]);
    }
  }

  private isValidFileSize(file) {
    var fileSizeinMB = file.size / (1024 * 1000);
    var size = Math.round(fileSizeinMB * 100) / 100; // convert upto 2 decimal place
    if (size > this.maxSize)
      this.errors.push("<BR/>Selected: " + file.name + ": exceed file size limit of " + this.maxSize + "MB ( " + size + "MB )");
  }

  ImportFile() {
    this.saveFiles();
  }




  saveFiles() {
    //if (typeof this._servicerName === "undefined") {
    //    this.CustomAlert("Please select SericerName .");
    //    this.isProcessComplete = false;
    //    return;

    //}
    //else {

    this.isProcessComplete = true;
    // this.fileList = this.filename;
    let files = this.fileList;
    this.errors = []; // Clear error     
    this.ClosePopUp();
    if (!(Boolean(files))) {
      this.errors.push("Please select file with " + this.fileExt + " extension.");
      this.CustomAlert(this.errors);
      this.isProcessComplete = false;
      return;
    }
    // Validate file size and allowed extensions
    else if (files.length > 0 && (!this.isValidFiles(files))) {
      this.CustomAlert(this.errors);
      this.uploadStatus.emit(false);
      this.isProcessComplete = false;
      return;
    }
    else if (files.length > 0) {
      let formData: FormData = new FormData();
      for (var j = 0; j < files.length; j++) {
        formData.append("file[]", files[j], files[j].name);
      }

      var user = JSON.parse(localStorage.getItem('user'));
      var parameters = {
        userid: user.UserID,
        Servicer: this._servicerName,
        Servicerid: this._servicerid,
        ScenarioId: this.ScenarioId
      }


      this.transserv.uploadfile(formData, parameters)
        .subscribe(res => {
          if (res.Succeeded) {
            this._istransRecordexist = true;
            this.GetAllTranscationNew();
            this.GetAllDealsForFilter();
            this.GetAllTransactionType();
            this._Showmessagediv = true;
            var smessage = res.Message.split('==');
            this._ShowmessagedivMsg = smessage[1];
            this.isProcessComplete = false;
            this._ShowdivMsgWar = false;
          }
          else {
            this.uploadStatus.emit(true);
            this._ShowdivMsgWar = true;
            var smessage = res.Message.split('==');
            this._WarmsgdashBoad = smessage[1];
            this.isProcessComplete = false;
            this._Showmessagediv = false;
          }
          //  setTimeout(function () {
          //    this._Showmessagediv = false;
          //  this._ShowdivMsgWar = false;
          // this._ShowmessagedivMsg = '';
          //this._WarmsgdashBoad = '';
          //  }.bind(this), 7000);
        });
    }
    else {
      this.CustomAlert('Please select a file.');
      this.isProcessComplete = false;
      return;
    }
    //}
  }



  showDialog() {
    this.isProcessComplete = false;
    var modaltrans = document.getElementById('myModal');
    modaltrans.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }

  ClosePopUp() {
    //  this.isProcessComplete = false;
    var modal = document.getElementById('myModal');
    modal.style.display = "none";
  }


  public toggleCheckbox(item, itemfor, flexGridrw: wjcGrid.Row, isChecked) {
    if (isChecked == true) {
      if (itemfor == "M61Value") {
        item.M61Value = true;
        item.ServicerValue = false;
        item.Ignore = false;

        this.flextrans.select(flexGridrw.index, 7);
        this.flextrans.focus();
      }
      else if (itemfor == "ServicerValue") {
        item.M61Value = false;
        item.ServicerValue = true;
        item.Ignore = false;
        this.flextrans.select(flexGridrw.index, 8);
        this.flextrans.focus();
      }
      else if (itemfor == "Ignore") {
        item.M61Value = false;
        item.ServicerValue = false;
        item.Ignore = true;
      }
    }
    else {
      item.M61Value = false;
      item.ServicerValue = false;
      item.Ignore = false;
    }

    this.flextrans.invalidate();
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
    //document.getElementById('dialogboxfoot').innerHTML = '<span class="custombutton" onclientclick="this.ok()">OK</span>';
  }

  ok(): void {
    document.getElementById('dialogbox').style.display = "none";
    document.getElementById('dialogoverlay').style.display = "none";
  }


  clickedalltransactions(NoteId, DateDue, TransactionType, CRENoteID, NoteName): void {
    this.isProcessComplete = true
    var searchtrans = '';
    this.CRENoteId = CRENoteID;
    this.NoteName = NoteName;
    this.ScenarioId = window.localStorage.getItem("scenarioid");
    searchtrans = NoteId + "#" + this.convertDateToBindable(DateDue) + "#" + TransactionType + "#" + this.ScenarioId;
    this.allTransactions = null;

    this.transserv.GetAllTransactionByNote(searchtrans).subscribe(res => {
      if (res.Succeeded) {
        this.allTransactions = res.lstFundingSchedule;
        this.isProcessComplete = false;
        this.norecord = false;

        if (this.allTransactions) {
          for (var i = 0; i < this.allTransactions.length; i++) {
            if (this.allTransactions[i].DueDate != null) {
              this.allTransactions[i].DueDate = new Date(this.allTransactions[i].DueDate.toString());
            }

            if (this.allTransactions[i].TransactionDate != null) {
              this.allTransactions[i].TransactionDate = new Date(this.allTransactions[i].TransactionDate.toString());
            }
          }
        }

        setTimeout(function () {
          // this.allTransactions = this.allTransactions;
          this.flexallTransactions.invalidate();
        }.bind(this), 1000);

      }
      else {
        this.allTransactions = null;
        this.norecord = true;
        this.isProcessComplete = false;
      }
    });


    var modaltrans = document.getElementById('myModalTrans');
    modaltrans.style.display = "block";
    $.getScript("/js/jsDrag.js");




  }



  addFooterRow(flexGrid: wjcGrid.FlexGrid) {
    var row = new wjcGrid.GroupRow(); // create a GroupRow to show aggregates
    flexGrid.columnFooters.rows.push(row); // add the row to the column footer panel
    flexGrid.bottomLeftCells.setCellData(0, 0, '\u03A3');
    // sigma on the header
  }


  CloseTransPopUp() {
    var modalCopy = document.getElementById('myModalTrans');
    modalCopy.style.display = "none";
  }

  DownloadDocument(selectedValue, SericerFile) {

    //filename, originalfilename, storagetype, documentStorageID
    var storagetype = 'AzureBlob';
    var documentStorageID = '';
    var filename = SericerFile;
    var originalfilename = SericerFile;
    this.isProcessComplete = true;

    var selectedText = selectedValue.target.text;
    selectedText = selectedText.trim();

    documentStorageID = documentStorageID === undefined ? '' : documentStorageID

    var ID = '';
    if (storagetype == 'Box')
      ID = documentStorageID
    else if (storagetype == 'AzureBlob')
      ID = filename;
    else if (storagetype == 'LocalStorage')
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
        this.isProcessComplete = false;

      },
        error => {
          //alert('Something went wrong');
          this.isProcessComplete = false;;
        }
      );
  }

  ClearSelection() {
    this._M61chkSelectAll = false;
    this.lsttranscation.forEach((obj, i) => {
      obj.ServicerValue = false,
        obj.M61Value = false,
        obj.Ignore = false
    });
    this.flextrans.invalidate();
  }

  celleditActualDelta(flextrans: wjcGrid.FlexGrid, e: wjcGrid.CellEditEndingEventArgs): void {
    var Delta_index = this.flextrans.getColumn("Delta").index;
    var Adjustment_index = this.flextrans.getColumn("Adjustment").index;
    var ActualDelta_index = this.flextrans.getColumn("ActualDelta").index;
    var Override_index = this.flextrans.getColumn("OverrideValue").index;
    var Overridereason_index = this.flextrans.getColumn("OverrideReasonText").index;
    var M61_index = this.flextrans.getColumn("CalculatedAmount").index;
    var Serv_index = this.flextrans.getColumn("ServicingAmount").index;
    var M61_Check = this.flextrans.getColumn("M61Value").index;
    var Servicer_Check = this.flextrans.getColumn("ServicerValue").index;
    var Ignore_Check = this.flextrans.getColumn("Ignore").index;
    var WriteOff_index = this.flextrans.getColumn("WriteOffAmount").index;
    var ServicingAmt_index = this.flextrans.getColumn("ServicingAmount").index;
    var CalculatedAmt_index = this.flextrans.getColumn("CalculatedAmount").index;
    var TotalInterest_index = this.flextrans.getColumn("TotalInterest").index;

    if (e.col == Adjustment_index) {
      var Delta = this.flextrans.getCellData(e.row, Delta_index, false);
      var Adjustment = this.flextrans.getCellData(e.row, Adjustment_index, false);
      var WriteOffAmount = this.flextrans.getCellData(e.row, WriteOff_index, false);

      if (Delta == null && Delta == undefined) Delta = 0;
      if (Adjustment == null && Adjustment == undefined) Adjustment = 0;
      WriteOffAmount = WriteOffAmount || 0;
      var ActualDelta = parseFloat(Delta) + parseFloat(Adjustment) + parseFloat(WriteOffAmount);
      //  this.lsttranscation[e.row].ActualDelta = ActualDelta.toFixed(2);
      this.flextrans.setCellData(e.row, ActualDelta_index, ActualDelta);

      //this.flextrans.setCellData(e.row, ActualDelta_index, ActualDelta, true);
      this.flextrans.invalidate();
    }
    if (e.col == WriteOff_index) {
      var Delta = this.flextrans.getCellData(e.row, Delta_index, false);
      var Adjustment = this.flextrans.getCellData(e.row, Adjustment_index, false);
      var WriteOffAmount = this.flextrans.getCellData(e.row, WriteOff_index, false);
      WriteOffAmount = WriteOffAmount || 0;
      var ActualDelta = parseFloat(Delta) + parseFloat(Adjustment) + parseFloat(WriteOffAmount);
      this.flextrans.setCellData(e.row, ActualDelta_index, ActualDelta);
    }
    if (e.col == Override_index || e.col == Overridereason_index) {
      var iserr = false;
      if (!(Number(this.lsttranscation[e.row].OverrideReasonText).toString() == "NaN" || Number(this.lsttranscation[e.row].OverrideReasonText) == 0)) {
        this.lsttranscation[e.row].OverrideReason = Number(this.lsttranscation[e.row].OverrideReasonText);
      }
      var OverRideValue = this.flextrans.getCellData(e.row, Override_index, false);
      var OverRideComment = this.flextrans.getCellData(e.row, Overridereason_index, false);
      var M61_Value = this.flextrans.getCellData(e.row, M61_index, false);
      var Serv_Value = this.flextrans.getCellData(e.row, Serv_index, false);
      var M61Chk = this.flextrans.getCellData(e.row, M61_Check, false);
      var SerChk = this.flextrans.getCellData(e.row, Servicer_Check, false);
      if (M61Chk) {
        iserr = true;
        this.CustomAlert('Combination of Override Value and M61 Value is not allowed.');
        this.flextrans.setCellData(e.row, Override_index, null);
      }

      if (SerChk) {
        iserr = true;
        this.CustomAlert('Combination of Override Value and Servicer Value is not allowed.');
        this.flextrans.setCellData(e.row, Override_index, null);
      }
      var IgnoreChk = this.flextrans.getCellData(e.row, Ignore_Check, false);
      if (IgnoreChk) {
        iserr = true;
        this.CustomAlert('Combination of Override Value and Ignore is not allowed.');
        this.flextrans.setCellData(e.row, Ignore_Check, "");
      }
      if (OverRideValue == null) {
        this.lsttranscation[e.row].OverrideReasonText = null;
        this.lsttranscation[e.row].OverrideReason = null;
        //this.flextrans.setCellData(e.row, Overridereason_index, 645);               
        this.flextrans.invalidate();
      }

      if (!iserr) {
        var sel = this.flextrans.selection;

        if (!M61_Value) M61_Value = 0;
        if (!OverRideValue) {
          if (OverRideValue == null)
            this.flextrans.setCellData(e.row, Delta_index, Serv_Value - M61_Value);
          if (OverRideValue == 0) {
            this.flextrans.setCellData(e.row, Delta_index, 0 - M61_Value);
            this.flextrans.setCellData(e.row, TotalInterest_index, 0);
          }
        }
        else {
          this.flextrans.setCellData(e.row, Delta_index, OverRideValue - M61_Value);
        }

        var Adjustment = this.flextrans.getCellData(e.row, Adjustment_index, false);
        var Delta = this.flextrans.getCellData(e.row, Delta_index, false);



        ActualDelta = parseFloat(Delta) + parseFloat(Adjustment);
        this.flextrans.setCellData(e.row, ActualDelta_index, ActualDelta);
        this.flextrans.invalidate();
      }
    }

    if (e.col == M61_Check) {

      var OverRideValue = this.flextrans.getCellData(e.row, Override_index, false);
      if (OverRideValue != null) {
        this.CustomAlert('Combination of Override Value and M61 Value is not allowed.');
        this.flextrans.setCellData(e.row, M61_Check, false);
      }


      var M61Chk = this.flextrans.getCellData(e.row, M61_Check, false);
      if (M61Chk == true) {
        this.flextrans.select(e.row, M61_index);
        this.flextrans.focus();
        this.flextrans.setCellData(e.row, Servicer_Check, false);
        this.flextrans.setCellData(e.row, Ignore_Check, false);
      }
      this.flextrans.invalidate();
    }
    if (e.col == Servicer_Check) {

      var OverRideValue = this.flextrans.getCellData(e.row, Override_index, false);
      if (OverRideValue != null) {
        this.CustomAlert('Combination of Override Value and Servicer Value is not allowed.');
        this.flextrans.setCellData(e.row, Servicer_Check, false);
      }

      var ServicerChk = this.flextrans.getCellData(e.row, Servicer_Check, false);
      if (ServicerChk == true) {
        this.flextrans.select(e.row, Serv_index);
        this.flextrans.focus();
        this.flextrans.setCellData(e.row, M61_Check, false);
        this.flextrans.setCellData(e.row, Ignore_Check, false);
      }

      this.flextrans.invalidate();
    }
    if (e.col == Ignore_Check) {

      var IgnoreChk = this.flextrans.getCellData(e.row, Ignore_Check, false);
      var OverRideValue = this.flextrans.getCellData(e.row, Override_index, false);

      if (IgnoreChk == true) {
        if (OverRideValue != null) {
          this.CustomAlert('Combination of Override Value and Ignore is not allowed.');
          this.flextrans.setCellData(e.row, Ignore_Check, false);
        }
        this.flextrans.setCellData(e.row, M61_Check, false);
        this.flextrans.setCellData(e.row, Servicer_Check, false);
      }

      this.flextrans.invalidate();
    }


    if (e.col == ServicingAmt_index) {
      var ServicingAmt = this.flextrans.getCellData(e.row, ServicingAmt_index, false);
      var CalculatedAmt = this.flextrans.getCellData(e.row, CalculatedAmt_index, false);
      Delta = ServicingAmt - CalculatedAmt;
      this.flextrans.setCellData(e.row, Delta_index, Delta);
      //  var Delta = this.flextrans.getCellData(e.row, Delta_index, false);
      var Adjustment = this.flextrans.getCellData(e.row, Adjustment_index, false);
      var WriteOffAmount = this.flextrans.getCellData(e.row, WriteOff_index, false);

      if (Delta == null && Delta == undefined) Delta = 0;
      if (Adjustment == null && Adjustment == undefined) Adjustment = 0;
      WriteOffAmount = WriteOffAmount || 0;
      var ActualDelta = parseFloat(Delta) + parseFloat(Adjustment) + parseFloat(WriteOffAmount);
      //  this.lsttranscation[e.row].ActualDelta = ActualDelta.toFixed(2);
      this.flextrans.setCellData(e.row, ActualDelta_index, ActualDelta);

      //this.flextrans.setCellData(e.row, ActualDelta_index, ActualDelta, true);
      this.flextrans.invalidate();
    }

    if (e.col == TotalInterest_index) {
      var OverRideValue = this.flextrans.getCellData(e.row, Override_index, false);
      if (OverRideValue == 0) {
        this.flextrans.setCellData(e.row, TotalInterest_index, 0);
      }
    }
  }



  pastedActualDelta(flextrans: wjcGrid.FlexGrid, e: wjcGrid.CellEditEndingEventArgs): void {

    var Delta_index = this.flextrans.getColumn("Delta").index;
    var Adjustment_index = this.flextrans.getColumn("Adjustment").index;
    var ActualDelta_index = this.flextrans.getColumn("ActualDelta").index;
    var Override_index = this.flextrans.getColumn("OverrideValue").index;
    var M61_index = this.flextrans.getColumn("CalculatedAmount").index;
    var Serv_index = this.flextrans.getColumn("ServicingAmount").index;
    var M61_Check = this.flextrans.getColumn("M61Value").index;
    var Servicer_Check = this.flextrans.getColumn("ServicerValue").index;
    var Ignore_Check = this.flextrans.getColumn("Ignore").index;
    var OverrideReason_ddl = this.flextrans.getColumn("OverrideReason").index;
    var OverrideValue_index = this.flextrans.getColumn("OverrideValue").index;
    var TotalInterest_index = this.flextrans.getColumn("TotalInterest").index;

    var sel = this.flextrans.selection;
    if (e.col == Adjustment_index) {
      for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
        var Delta = this.flextrans.getCellData(tprow, Delta_index, false);
        var Adjustment = this.flextrans.getCellData(tprow, Adjustment_index, false);

        if (Delta == null && Delta == undefined) Delta = 0;
        if (Adjustment == null && Adjustment == undefined) Adjustment = 0;

        ActualDelta = parseFloat(Delta) + parseFloat(Adjustment);
        this.lsttranscation[tprow].ActualDelta = ActualDelta;
        this.flextrans.setCellData(e.row, ActualDelta_index, ActualDelta, true);
        this.flextrans.invalidate();
      }
    }
    if (e.col == Override_index) {
      for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
        var OverRideValue = this.flextrans.getCellData(tprow, Override_index, false);
        var M61_Value = this.flextrans.getCellData(tprow, M61_index, false);
        var Serv_Value = this.flextrans.getCellData(tprow, Serv_index, false);
        var M61Chk = this.flextrans.getCellData(tprow, M61_Check, false);
        var SerChk = this.flextrans.getCellData(tprow, Servicer_Check, false);
        if (M61Chk) {
          this.CustomAlert('Combination of Override Value and M61 Value is not allowed.');
          this.flextrans.setCellData(tprow, Override_index, null);
        }

        if (SerChk) {
          this.CustomAlert('Combination of Override Value and Servicer Value is not allowed.');
          this.flextrans.setCellData(tprow, Override_index, null);
        }

        if (!M61_Value) M61_Value = 0;
        if (!OverRideValue) {
          if (OverRideValue == null)
            this.flextrans.setCellData(tprow, Delta_index, Serv_Value - M61_Value);

          if (OverRideValue == 0) {
            this.flextrans.setCellData(tprow, Delta_index, 0 - M61_Value);
            this.flextrans.setCellData(e.row, TotalInterest_index, 0);
          }
          this.flextrans.invalidate();
        }
        else {

          this.flextrans.setCellData(tprow, Delta_index, OverRideValue - M61_Value);

        }

        var Adjustment = this.flextrans.getCellData(tprow, Adjustment_index, false);
        var Delta = this.flextrans.getCellData(tprow, Delta_index, false);

        if (Adjustment == null && Adjustment == undefined) Adjustment = 0;
        if (Delta == null && Delta == undefined) Delta = 0;

        var ActualDelta = parseFloat(Delta) + parseFloat(Adjustment);
        this.lsttranscation[tprow].ActualDelta = ActualDelta;
        this.flextrans.setCellData(tprow, ActualDelta_index, ActualDelta);
        this.flextrans.invalidate();

      }
    }

    if (e.col == OverrideReason_ddl || e.col == OverrideValue_index) {
      for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
        var OverReas = this.flextrans.getCellData(tprow, OverrideReason_ddl, false);

        //if (!(Number(this.flextrans.getCellData(tprow, OverrideReason_ddl, false)).toString() == "NaN" || Number(this.flextrans.getCellData(tprow, OverrideReason_ddl, false)) == 0)) {
        //    this.flextrans.setCellData(tprow, OverrideReason_ddl, OverReas);
        //  //  this.lsttranscation[e.row].OverrideReason = Number(this.lsttranscation[e.row].OverrideReasonText);
        //}


        if (!(Number(this.lsttranscation[tprow].OverrideReasonText).toString() == "NaN" || Number(this.lsttranscation[tprow].OverrideReasonText) == 0)) {
          this.lsttranscation[tprow].OverrideReason = Number(this.lsttranscation[tprow].OverrideReasonText);
        }
      }
    }


    if (e.col == TotalInterest_index) {
      var OverRideValue = this.flextrans.getCellData(tprow, Override_index, false);
      if (OverRideValue == 0) {
        this.flextrans.setCellData(tprow, TotalInterest_index, 0);
      }
    }

  }



  sortingColumn(flextrans: wjcGrid.FlexGrid, e: wjcGrid.CellEditEndingEventArgs): void {
    setTimeout(function () {
     // this.flextrans.invalidate();
      for (var i = 0; i < this.flextrans.rows.length; i++) {
        if (this.flextrans.rows[0]._data.isRecon == false) {
          this._showhistory = true;
          this.flextrans.rows[i].isReadOnly = true;
          this.flextrans.rows[i].cssClass = "customgridrowcolor";
          this.isProcessComplete = false;
        }
      }
     // this.flextrans.invalidate();
    }.bind(this), 100);
  }
  M61SelectAll() {

    this.ServicerchkSelectAll.nativeElement.Value = "off";
    this._M61chkSelectAll = !this._M61chkSelectAll;
    this._ServicerSelectAll = false;
    this._IgnoreSelectAll = false;
    for (var i = 0; i <= this.flextrans.rows.length; i++) {
      if (this.flextrans.rows[i]) {
        this.flextrans.rows[i].dataItem.M61Value = this._M61chkSelectAll;
        this.flextrans.rows[i].dataItem.ServicerValue = false;
        this.flextrans.rows[i].dataItem.Ignore = false;
      }
    }
    this.flextrans.invalidate();
  }

  ServicerSelectAll() {

    this.M61chkSelectAll.nativeElement.value = "off";
    this._ServicerSelectAll = !this._ServicerSelectAll;
    this._M61chkSelectAll = false;
    this._IgnoreSelectAll = false;
    for (var i = 0; i <= this.flextrans.rows.length; i++) {
      if (this.flextrans.rows[i]) {
        this.flextrans.rows[i].dataItem.ServicerValue = this._ServicerSelectAll;
        this.flextrans.rows[i].dataItem.M61Value = false;
        this.flextrans.rows[i].dataItem.Ignore = false;

      }
    }
    this.flextrans.invalidate();
  }

  IgnoreSelectAll() {
    this._IgnoreSelectAll = !this._IgnoreSelectAll;
    this._M61chkSelectAll = false;
    this._ServicerSelectAll = false;

    for (var i = 0; i <= this.flextrans.rows.length; i++) {
      if (this.flextrans.rows[i]) {
        if (!this.flextrans.rows[i].dataItem.OverrideValue) {
          this.flextrans.rows[i].dataItem.Ignore = this._IgnoreSelectAll;
          this.flextrans.rows[i].dataItem.ServicerValue = false;
          this.flextrans.rows[i].dataItem.M61Value = false;
        }
      }
    }
    this.flextrans.invalidate();
  }

  //reconcilledSelectAll() {
  //  this._reconcilledchkSelectAll = !this._reconcilledchkSelectAll;

  //  for (var i = 0; i <= this.flextrans.rows.length; i++) {
  //    if (this.flextrans.rows[i]) {
  //      this.flextrans.rows[i].dataItem.DueDateAlreadyReconciled = this._reconcilledchkSelectAll;
  //    }
  //  }
  //  this.flextrans.invalidate();
  //}


  UnreconcileSelectAll() {
    this._UnreconcileSelectAll = !this._UnreconcileSelectAll;
    for (var i = 0; i <= this.flextrans.rows.length; i++) {
      if (this.flextrans.rows[i].dataItem.LastAccountingCloseDate < this.flextrans.rows[i].dataItem.DateDue) {
        this.flextrans.rows[i].dataItem.isRecon = this._UnreconcileSelectAll;
      }
    }
    this.flextrans.invalidate();

  }



  filterChanged() {
    this.saveFilterState();
    setTimeout(function () {
      this.restoreFilterState(); 
      for (var i = 0; i < this.flextrans.rows.length; i++) {
        if (this.flextrans.rows[0]._data.isRecon == false) {
          this._showhistory = true;
          this.flextrans.rows[i].isReadOnly = true;
          this.flextrans.rows[i].cssClass = "customgridrowcolor";
          this.isProcessComplete = false;
        }
      }
     // this.flextrans.invalidate();
    
    }.bind(this), 100);
  }

  RefreshM61Amount() {
    this.startDate = null;
    this.EndDate = null;
    this._isFilterapply = false;
    this.NonZeroDeltaFilter = 0;
    this._pageIndex = 1;
    this.IsReconciled = false;
    this.multiselDeals.checkedItems = [];
    var showallRefreshAmount;
    if (this.ShowAllTrans)
      showallRefreshAmount = "ShowAllTransaction" + "_" + "RefreshM61Amount";
    else
      showallRefreshAmount = "RefreshM61Amount";

    this.GetAllTranscationNew(showallRefreshAmount);
  }

  onContextMenu(grid, e) {
    var hti = grid.hitTest(e);
    if (hti.panel && hti.panel === grid.cells && hti.panel.columns[hti.col].binding === "ServicingAmount") {
      if (grid.rows[hti.row]._data["SplitTransactionid"] == null && grid.rows[hti.row]._data["isRecon"] == true && (grid.rows[hti.row]._data["TransactionType"] == 'ExitFee' || grid.rows[hti.row]._data["TransactionType"] == 'ExtensionFee' || grid.rows[hti.row]._data["TransactionType"] == 'ScheduledPrincipalPaid' || grid.rows[hti.row]._data["TransactionType"] == 'PIKPrincipalPaid' || grid.rows[hti.row]._data["TransactionType"] == 'FundingOrRepayment' || grid.rows[hti.row]._data["TransactionType"] == 'AdditionalFeesExcludedFromLevelYield' || grid.rows[hti.row]._data["TransactionType"] == 'Balloon' || grid.rows[hti.row]._data["TransactionType"] == 'InterestPaid' || grid.rows[hti.row]._data["TransactionType"] == 'PIKInterestPaid' || grid.rows[hti.row]._data["TransactionType"] == 'UnusedFeeExcludedFromLevelYield')) {
        e.preventDefault();
        this.hti = hti;
        this.ctxSplitMenu.show(e);
      }
      else {
        this.ctxSplitMenu.hide();
      }
    }
    else {
      this.ctxSplitMenu.hide();
    }

  }


  menuSplitItemClicked(s, e) {
    var { row: selectedRow, col: selectedCol } = this.flextrans.selection;
    var { row: clickedRow, col: clickedCol } = this.hti;
    this.TransactionSplitParent = this.flextrans.rows[clickedRow].dataItem;//= this.lsttranscation[clickedRow];

    //this.TransactionSplitParent = this.lsttranscation.filter(x => x.Transcationid == ParentTrans.Transcationid);
    // this.flexSplitParentTrans.invalidate();
    this.TransactionSplitParent.RemittanceDate = this.convertDateToBindable(this.TransactionSplitParent.RemittanceDate);

    this.parentTrans = this.lsttranscation.filter(x => x.Transcationid == this.TransactionSplitParent.Transcationid);
    if (this.parentTrans[0].DueDateAlreadyReconciled == "Yes") {
      this.parentTrans[0].DueDateAlreadyReconciled = 1;
    }
    else {
      this.parentTrans[0].DueDateAlreadyReconciled = 0;
    }
    var modal = document.getElementById('myModalSplitTrans');
    modal.style.display = "block";
    $.getScript("/js/jsDrag.js");

    this.SplitServicingAmount = this.TransactionSplitParent.ServicingAmount ? this.formatNumberforTwoDecimalplaces(parseFloat(this.TransactionSplitParent.ServicingAmount)) : 0;
    this.TransactionSplitParent.Final_ValueUsedInCalc = this.TransactionSplitParent.Final_ValueUsedInCalc != undefined ? this.TransactionSplitParent.Final_ValueUsedInCalc : 0;
    this.SplitFinal_ValueUsedInCalc = this.TransactionSplitParent.Final_ValueUsedInCalc != undefined ? this.formatNumberforTwoDecimalplaces(parseFloat(this.TransactionSplitParent.Final_ValueUsedInCalc)) : 0;
    this.TransactionSplitParent.Delta = parseFloat(this.TransactionSplitParent.ServicingAmount) - parseFloat(this.TransactionSplitParent.Final_ValueUsedInCalc);
    this.SplitDelta = this.TransactionSplitParent.Delta ? this.formatNumberforTwoDecimalplaces(parseFloat(this.TransactionSplitParent.Delta)) : 0;
    this.isProcessComplete = true;
    if (this.lsttranscation.length > 0) {
      this.transserv.SplitTranscation(this.parentTrans).subscribe(res => {
        if (res.Succeeded) {
          this.TransactionSplit = res.dt;
          for (var i = 0; i < this.TransactionSplit.length; i++) {
            if (this.TransactionSplit[i].DueDate != null) {
              this.TransactionSplit[i].DueDate = new Date(this.TransactionSplit[i].DueDate.toString());
            }
          }
          this.isProcessComplete = false;
          this._ShowdivMsgWar = false;
        }
        else {
          this.isProcessComplete = false;
          this._Showmessagediv = false;
        }
        //this.isProcessComplete = false;
        // this.flextrans.invalidate();
        this.flexSplitTrans.invalidate();

      });
    }
    //  this.isProcessComplete = false;

  }


  CloseSplitTransaction() {
    this.isProcessComplete = false;
    this.TransactionSplit = null;
    var modalSplit = document.getElementById('myModalSplitTrans');
    modalSplit.style.display = "none";
  }


  ChangeReceived(chkReceived, rowdata) {
    var TotalamtUsedCalc = 0;
    if (chkReceived == true) {
      this.TransactionSplit[rowdata.index].ServicingAmount_Distr = this.TransactionSplit[rowdata.index].M61Amount;
      this.TransactionSplit[rowdata.index].Received = true;

    }
    else {
      this.TransactionSplit[rowdata.index].ServicingAmount_Distr = null;
      this.TransactionSplit[rowdata.index].Received = false;
    }

    for (var i = 0; i < this.TransactionSplit.length; i++) {
      if (this.TransactionSplit[i].OverrideValue == null || this.TransactionSplit[i].OverrideValue == "") {
        if (this.TransactionSplit[i].Received == true) {
          TotalamtUsedCalc += parseFloat(this.TransactionSplit[i].ServicingAmount_Distr)
        }
      }
      else {
        TotalamtUsedCalc += parseFloat(this.TransactionSplit[i].OverrideValue)
      }
    }

    this.TransactionSplitParent.Final_ValueUsedInCalc = TotalamtUsedCalc.toFixed(2);
    this.TransactionSplitParent.Delta = parseFloat(this.TransactionSplitParent.ServicingAmount) - parseFloat(this.TransactionSplitParent.Final_ValueUsedInCalc);

    // this.TransactionSplitParent.Delta = this.TransactionSplitParent.Delta.toFixed(2);


    this.SplitFinal_ValueUsedInCalc = this.formatNumberforTwoDecimalplaces(TotalamtUsedCalc);
    this.SplitDelta = this.TransactionSplitParent.Delta ? this.formatNumberforTwoDecimalplaces(this.TransactionSplitParent.Delta) : 0;
    this.flexSplitTrans.invalidate();
  }

  celleditSplitTrans(flexSplitTrans: wjcGrid.FlexGrid, e: wjcGrid.CellEditEndingEventArgs) {
    var TotalamtUsedCalc = 0;
    for (var i = 0; i < this.TransactionSplit.length; i++) {
      if (this.TransactionSplit[i].OverrideValue == null || this.TransactionSplit[i].OverrideValue == "") {
        if (this.TransactionSplit[i].Received == true) {
          TotalamtUsedCalc += parseFloat(this.TransactionSplit[i].ServicingAmount_Distr ? this.TransactionSplit[i].ServicingAmount_Distr : 0)
        }
      }
      else {
        TotalamtUsedCalc += parseFloat(this.TransactionSplit[i].OverrideValue)
      }

    }
    this.TransactionSplitParent.Final_ValueUsedInCalc = TotalamtUsedCalc.toFixed(2);
    this.TransactionSplitParent.Delta = parseFloat(this.TransactionSplitParent.ServicingAmount) - parseFloat(this.TransactionSplitParent.Final_ValueUsedInCalc);

    //this.TransactionSplitParent.Delta = this.TransactionSplitParent.Delta.toFixed(2);


    this.SplitFinal_ValueUsedInCalc = this.formatNumberforTwoDecimalplaces(TotalamtUsedCalc);
    this.SplitDelta = this.TransactionSplitParent.Delta ? this.formatNumberforTwoDecimalplaces(this.TransactionSplitParent.Delta) : 0;

    this.flexSplitTrans.invalidate();
  }

  SplitTrasaction() {

    var exceptionmessage = '';
    var isValidate = true;
    if (this.TransactionSplit.length > 0) {
      var reconSplit = this.TransactionSplit.filter(x => x.Received == true);

      if (reconSplit.length > 0) {
        for (var i = 0; i < reconSplit.length; i++) {
          if (reconSplit[i].OverrideValue && (reconSplit[i].comments == '' || !reconSplit[i].comments)) {
            if (isValidate) {
              exceptionmessage = 'Please enter comment for the overridden value(s).';
              isValidate = false;
            }
          }

          if (reconSplit[i].ServicingAmount_Distr == null) {
            if (isValidate) {
              exceptionmessage = 'All the selected checkboxes should have a value in Servicer Amount column.';
              isValidate = false;
            }
          }
          if (reconSplit[i].M61Amount % 1 == 0) {
            reconSplit[i].M61Amount = (reconSplit[i].M61Amount * 100 / 100).toFixed(2);
          }
        }
      }

      var totalSum = 0;
      for (var i = 0; i < reconSplit.length; i++) {

        if (reconSplit[i].ServicingAmount_Distr) {
          totalSum += parseFloat(reconSplit[i].ServicingAmount_Distr)
        }

      }

      if (totalSum == 0 && reconSplit.length == 0) {
        exceptionmessage = 'Please select the transaction(s) to split.';
        isValidate = false;
      }
      else {
        if (parseFloat(totalSum.toFixed(2)) != parseFloat(parseFloat(this.TransactionSplitParent.ServicingAmount).toFixed(2))) {
          exceptionmessage = 'Total servicer amount should be equal to remit amount.';
          isValidate = false;
        }
      }
    }
    this.isProcessComplete = true;

    for (var i = 0; i < reconSplit.length; i++) {
      if (reconSplit[i].DueDate != null) {
        reconSplit[i].DueDate = this.convertDateToBindable(reconSplit[i].DueDate);
      }

      if (reconSplit[i].ServicingAmount_Distr) {
        reconSplit[i].ServicingAmount_Distr = reconSplit[i].ServicingAmount_Distr.toFixed(2);
      }

      if (reconSplit[i].DueDateAlreadyReconciled == 1) {
        reconSplit[i].DueDateAlreadyReconciled = "Yes";
      }
      else {
        reconSplit[i].DueDateAlreadyReconciled = "No";
      }
    }

    if (isValidate) {
      this.transserv.ReconcileSplitTranscation(reconSplit).subscribe(res => {
        if (res.Succeeded) {
          //this._isFilterapply = false;
         this._pageIndex = 1;
          this.isProcessComplete = false;
          this.CloseSplitTransaction();
          this.GetAllTranscationNew();
          this.GetAllTransactionType();
          this.flextrans.invalidate();
        }
      })
    }
    else {
      if (reconSplit.length > 0) {
        for (var i = 0; i < reconSplit.length; i++) {
          if (reconSplit[i].ServicingAmount_Distr) {
            reconSplit[i].ServicingAmount_Distr = parseFloat(reconSplit[i].ServicingAmount_Distr);
          }
        }
      }
      this.CustomAlert(exceptionmessage);
      this.isProcessComplete = false;

    }

  }

  importServicerFile(event: any, servicer: any) {
    this._servicerName = servicer.SericerName;
    this._servicerid = servicer.ServicerMasterID;
    //  this.actionLog += "\n currentFiles: " + this.getFileNames(event.target.files[0].name);
    // console.log(this.actionLog);
    let fileList: FileList = event.currentFiles;
    this.fileList = event.target.files;
    this.filename = event.target.files[0].name;
    this.showDialog();
  }

  public onFileSelected(event: EventEmitter<File[]>) {
    const file: File = event[0];

    console.log(file);

    readBase64(file)
      .then(function (data) {
        console.log(data);
      })

  }

  beginEditTransaction(flextrans: wjcGrid.FlexGrid, e: wjcGrid.CellEditEndingEventArgs) {
    var CapitalizedInterestcolindex = 17;
    var CashInterestcolindex = 18;
    var currentColIndex = e.col;
    if (currentColIndex == CapitalizedInterestcolindex || currentColIndex == CashInterestcolindex) {
      if (flextrans.rows[e.row].dataItem.OverrideValue != null)
        e.cancel = false;
      else
        e.cancel = true;
    }

  }



  formatNumberforTwoDecimalplaces(data) {
    if (data) {
      // this._basecurrencyname = '$';
      var num = parseFloat(data.toFixed(2));
      var str = num.toString();
      var numarray = str.split('.');
      var a = new Array();
      a = numarray;
      var newamount;
      //to assign 2 digits after decimal places
      if (a[1]) {
        var l = a[1].length;
        if (l == 1) {
          data = num + "0";
        }
        else {
          data = num;
        }
      } else {
        data = num + ".00";
      }

      //to assign currency with sign
      if (Math.sign(data) == -1) {
        var _amount = -1 * data;
        newamount = "-" + _amount;
      }
      else {
        newamount = data;
      }
      var changedamount = newamount.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
      return changedamount;
    }
  }

}
const routes: Routes = [

  { path: '', component: TranscationreconciliationComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjInputModule, WjGridFilterModule],
  declarations: [TranscationreconciliationComponent]
})

export class TranscationreconciliationComponentModule {

}

