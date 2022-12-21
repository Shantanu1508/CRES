import { Component, ViewChild, Input, Output, EventEmitter, OnInit, AfterViewInit } from "@angular/core";
import { Router, ActivatedRoute } from '@angular/router';
import { TranscationreconciliationService } from '../../core/services/TranscationreconciliationService';
import { PermissionService } from '../../core/services/PermissionService';
import { UtilityService } from '../../core/services/utilityService';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { FileUploadService } from '../../core/services/fileuploadservice';
import { Ng2FileInputModule, Ng2FileInputService, Ng2FileInputAction } from 'ng2-file-input';
import * as wjNg2Input from 'wijmo/wijmo.angular2.input';
import { WjCoreModule } from 'wijmo/wijmo.angular2.core';
import { WjGridModule } from 'wijmo/wijmo.angular2.grid';
import { WjInputModule } from 'wijmo/wijmo.angular2.input';
import { WjGridFilterModule } from 'wijmo/wijmo.angular2.grid.filter';
import * as wjcGrid from 'wijmo/wijmo.grid';
import { Paginated } from '../../core/common/paginated';
import { dealService } from '../../core/services/dealservice';
import * as wjcInput from 'wijmo/wijmo.input';
declare var $: any;

@Component({
    templateUrl: "app/components/ImportExport/Transcationreconciliation.html?v=" + $.getVersion(),
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

    constructor(private ng2FileInputService: Ng2FileInputService,
        public fileUploadService: FileUploadService,
        public permissionService: PermissionService,
        public utilityService: UtilityService,
        public transserv: TranscationreconciliationService,
        public dealSrv: dealService,
        private _router: Router) {
        // this.GetUserPermission();
        super(50, 1, 0);
        this.GetAllServicer();
        this.GetAllLookups();
        this.GetAllDealsForFilter();
        this.GetAllTransactionType();
        //this.GetAllNotes();
        this.ScenarioId = window.localStorage.getItem("scenarioid");
        this.utilityService.setPageTitle("M61-Transaction Reconciliation");
    }


    // Component views are initialized
    ngAfterViewInit() {

        this.flextrans.scrollPositionChanged.addHandler(() => {
            var myDiv = $('#flextrans').find('div[wj-part="root"]');
            if (!this.isReconcHistory) {
                if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
                    if (this.flextrans.rows.length < this._totalCount) {
                        this._pageIndex = this.pagePlus(1);
                        this.GetAllTranscationNew();
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

                this.GetAllTranscationNew();
            }
        })


    }


    //
    

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

            if (reconTrans.length > 0) {
                for (var i = 0; i < reconTrans.length; i++) {
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
                        }

                        if (reconTrans[i].ActualDelta % 1 == 0) {
                            reconTrans[i].ActualDelta = (reconTrans[i].ActualDelta * 100 / 100).toFixed(2);
                        }

                        if (reconTrans[i].Adjustment % 1 == 0) {
                            reconTrans[i].Adjustment = (reconTrans[i].Adjustment * 100 / 100).toFixed(2);
                        }

                        if (reconTrans[i].AddlInterest % 1 == 0) {
                            reconTrans[i].AddlInterest = (reconTrans[i].AddlInterest * 100 / 100).toFixed(2);
                        }

                        if (reconTrans[i].TotalInterest % 1 == 0) {
                            reconTrans[i].TotalInterest = (reconTrans[i].TotalInterest * 100 / 100).toFixed(2);
                        }

                        if (reconTrans[i].ServicingAmount % 1 == 0) {
                            reconTrans[i].ServicingAmount = (reconTrans[i].ServicingAmount * 100 / 100).toFixed(2);
                        }

                        if (reconTrans[i].CalculatedAmount % 1 == 0) {
                            reconTrans[i].CalculatedAmount = (reconTrans[i].CalculatedAmount * 100 / 100).toFixed(2);
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
        var data: any;
        var type: any;
        if (!this._isFilterapply) {
            this.isProcessComplete = true;
            this.transserv.getAllTranscationNew(type, this._pageIndex, this._pageSize).subscribe(res => {
                if (res.Succeeded) {
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
                    //debugger;

                    //setTimeout(function () {
                    //    debugger;
                    //    this.flextrans.invalidate();
                    //    for (var i = 0; i < this.flextrans.rows.length; i++) {
                    //        if (this.flextrans.rows[i]) {
                    //            var cl = this.getRandomColor();
                    //            // this.flextrans.rows[i]
                    //            this.flextrans.rows[i].style.backgroundColor  = cl;
                    //        }
                    //    }
                    //}.bind(this), 500);
                    //this.flextrans.invalidate();
                    //this.flextrans.invalidate(true);
                    //for (var i = 0; i < this.flextrans.rows.length ; i++) {
                    //    this.flextrans.invalidate();
                    //    if (this.flextrans.rows[i]) {
                    //        var cl = this.getRandomColor();
                    //        // this.flextrans.rows[i]
                    //        this.flextrans.rows[i].Background = cl;
                    //    }
                    //}
                    

                    if (type == "RefreshM61Amount") {
                        this._Showmessagediv = true;
                        this._ShowmessagedivMsg = "M61 values updated successfully.";
                        this._ShowdivMsgWar = false;
                        // setTimeout(function () {
                        //  this._Showmessagediv = false;
                        //   this._ShowmessagedivMsg = '';
                        //   this._WarmsgdashBoad = '';

                        //  }.bind(this), 2000);
                    }

                }
                else {
                    this.utilityService.navigateToSignIn();
                }
            });
        }
    }


    ReconciledHistory(val): void {
        this.IsReconciled = val;
        this.GetAllDealsForFilter()

    }



    getExceptions(val): void {
        this.IsException = val;
    }

    public unRecCheckbox(item, val) {
        this.flextrans.invalidate();
        if (val == true) {
            item.isRecon = 1;
        }
        else {
            item.isRecon = 0;
        }
    }


    Unreconcile(): void {
        var unrec = this.lsttranscation.filter(x => x.isRecon == 1);
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

        
        var searchstr = '';
        searchstr = "#" + this.convertDateToBindable(this.startDate);
        searchstr = searchstr + "#" + this.convertDateToBindable(this.EndDate);
        searchstr = searchstr + "#" + this.NonZeroDeltaFilter;
        // searchstr = searchstr + "#" + Notesfilter;
        searchstr = searchstr + "#" + Dealsfilter + "'";
        searchstr = searchstr + "#" + this.IsReconciled;
        searchstr = searchstr + "#" + this.IsException;
        searchstr = searchstr + "#" + TransactionTypefilter + "'";
        this.isReconcHistory = this.IsReconciled;


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

    public resetFileInput(file): void {
        this.ng2FileInputService.reset(this.myFileInputIdentifier);
    }


    public logCurrentFiles(): void {
        let files = this.ng2FileInputService.getCurrentFiles(this.myFileInputIdentifier);
        this.actionLog += "\n The currently added files are: " + this.getFileNames(files);
    }
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
        var storagetype = 'LocalStorage';
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
        if (e.col == Adjustment_index) {
            var Delta = this.flextrans.getCellData(e.row, Delta_index, false);
            var Adjustment = this.flextrans.getCellData(e.row, Adjustment_index, false);

            if (Delta == null && Delta == undefined) Delta = 0;
            if (Adjustment == null && Adjustment == undefined) Adjustment = 0;

            var ActualDelta = parseFloat(Delta) + parseFloat(Adjustment);
            //  this.lsttranscation[e.row].ActualDelta = ActualDelta.toFixed(2);
            this.flextrans.setCellData(e.row, ActualDelta_index, ActualDelta);

            //this.flextrans.setCellData(e.row, ActualDelta_index, ActualDelta, true);
            this.flextrans.invalidate();
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

        var sel = this.flextrans.selection;
        if (e.col == Adjustment_index) {
            for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
                var Delta = this.flextrans.getCellData(tprow, Delta_index, false);
                var Adjustment = this.flextrans.getCellData(tprow, Adjustment_index, false);

                if (Delta == null && Delta == undefined) Delta = 0;
                if (Adjustment == null && Adjustment == undefined) Adjustment = 0;

                var ActualDelta = (Delta + Adjustment);
                this.lsttranscation[tprow].ActualDelta = ActualDelta;
                //this.flextrans.setCellData(e.row, ActualDelta_index, ActualDelta, true);
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

                var ActualDelta = (Delta + Adjustment);
                this.lsttranscation[tprow].ActualDelta = ActualDelta;
                this.flextrans.invalidate();

            }
        }

        if (e.col == OverrideReason_ddl) {
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

    }



    sortingColumn(flextrans: wjcGrid.FlexGrid, e: wjcGrid.CellEditEndingEventArgs): void {
        setTimeout(function () {
            //for (var i = 0; i < this.lsttranscation.length; i++) {
            //    this.lsttranscation[i].Ignore = false;
            //    this.lsttranscation[i].ServicerValue = false;
            //    this.lsttranscation[i].M61Value = false;
            //}

            this.flextrans.invalidate();
            for (var i = 0; i < this.flextrans.rows.length; i++) {
                if (this.flextrans.rows[0]._data.isRecon == false) {
                    this._showhistory = true;
                    this.flextrans.rows[i].isReadOnly = true;
                    this.flextrans.rows[i].cssClass = "customgridrowcolor";
                    this.isProcessComplete = false;
                }
            }
            this.flextrans.invalidate();
        }.bind(this), 100);
    }
    M61SelectAll() {
        this._M61chkSelectAll = !this._M61chkSelectAll;
        this._ServicerSelectAll = false;
        this._IgnoreSelectAll = false;
        for (var i = 0; i <= this.flextrans.rows.length; i++) {
            if (this.flextrans.rows[i]) {
                this.flextrans.rows[i]._data.M61Value = this._M61chkSelectAll;
                this.flextrans.rows[i]._data.ServicerValue = false;
                this.flextrans.rows[i]._data.Ignore = false;
            }
        }
        this.flextrans.invalidate();
    }

    ServicerSelectAll() {
        this._ServicerSelectAll = !this._ServicerSelectAll;
        this._M61chkSelectAll = false;
        this._IgnoreSelectAll = false;
        for (var i = 0; i <= this.flextrans.rows.length; i++) {
            if (this.flextrans.rows[i]) {
                this.flextrans.rows[i]._data.ServicerValue = this._ServicerSelectAll;
                this.flextrans.rows[i]._data.M61Value = false;
                this.flextrans.rows[i]._data.Ignore = false;

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
                if (!this.flextrans.rows[i]._data.OverrideValue) {
                    this.flextrans.rows[i]._data.Ignore = this._IgnoreSelectAll;
                    this.flextrans.rows[i]._data.ServicerValue = false;
                    this.flextrans.rows[i]._data.M61Value = false;
                }
            }
        }
        this.flextrans.invalidate();
    }


    UnreconcileSelectAll() {
        this._UnreconcileSelectAll = !this._UnreconcileSelectAll;
        for (var i = 0; i <= this.flextrans.rows.length; i++) {
            if (this.flextrans.rows[i]) {
                this.flextrans.rows[i]._data.isRecon = this._UnreconcileSelectAll;
            }
        }
        this.flextrans.invalidate();

    }



    filterChanged() {
        setTimeout(function () {
            //for (var i = 0; i < this.lsttranscation.length; i++) {
            //    if (this.lsttranscation[i].isRecon == true) {
            //        this.lsttranscation[i].Ignore = false;
            //        this.lsttranscation[i].ServicerValue = false;
            //        this.lsttranscation[i].M61Value = false;
            //    }
            //}

          //  this.flextrans.invalidate();
            for (var i = 0; i < this.flextrans.rows.length; i++) {
                if (this.flextrans.rows[0]._data.isRecon == false) {
                    this._showhistory = true;
                    this.flextrans.rows[i].isReadOnly = true;
                    this.flextrans.rows[i].cssClass = "customgridrowcolor";
                    this.isProcessComplete = false;
                }
            }
            this.flextrans.invalidate();
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
        this.GetAllTranscationNew("RefreshM61Amount");
    }

    onContextMenu(grid, e) {
        var hti = grid.hitTest(e);
        if (hti.panel && hti.panel === grid.cells && hti.panel.columns[hti.col].binding === "ServicingAmount") {
            if (grid.rows[hti.row]._data["SplitTransactionid"] == null && (grid.rows[hti.row]._data["TransactionType"] == 'ExitFee' || grid.rows[hti.row]._data["TransactionType"] == 'ExtensionFee' || grid.rows[hti.row]._data["TransactionType"] == 'ScheduledPrincipalPaid') ) {
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
        this.TransactionSplitParent = this.flextrans.rows[clickedRow]._data;//= this.lsttranscation[clickedRow];

        //this.TransactionSplitParent = this.lsttranscation.filter(x => x.Transcationid == ParentTrans.Transcationid);
         // this.flexSplitParentTrans.invalidate();
        this.TransactionSplitParent.RemittanceDate = this.convertDateToBindable(this.TransactionSplitParent.RemittanceDate);

        this.parentTrans = this.lsttranscation.filter(x => x.Transcationid == this.TransactionSplitParent.Transcationid);
        var modal = document.getElementById('myModalSplitTrans');
            modal.style.display = "block";
        $.getScript("/js/jsDrag.js");
        this.SplitServicingAmount = this.TransactionSplitParent.ServicingAmount? this.formatNumberforTwoDecimalplaces(parseFloat( this.TransactionSplitParent.ServicingAmount)):0;
        this.SplitFinal_ValueUsedInCalc = this.TransactionSplitParent.Final_ValueUsedInCalc ? this.formatNumberforTwoDecimalplaces(parseFloat(this.TransactionSplitParent.Final_ValueUsedInCalc)):0;
        this.SplitDelta = this.TransactionSplitParent.Delta ? this.formatNumberforTwoDecimalplaces(parseFloat(this.TransactionSplitParent.Delta)):0;
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
        this.SplitDelta = this.TransactionSplitParent.Delta?this.formatNumberforTwoDecimalplaces(this.TransactionSplitParent.Delta):0;
        this.flexSplitTrans.invalidate();
    }

    celleditSplitTrans(flexSplitTrans: wjcGrid.FlexGrid, e: wjcGrid.CellEditEndingEventArgs) {
        var TotalamtUsedCalc = 0;
        for (var i = 0; i < this.TransactionSplit.length; i++) {
            if (this.TransactionSplit[i].OverrideValue == null || this.TransactionSplit[i].OverrideValue=="" ) {
                if (this.TransactionSplit[i].Received == true) {
                    TotalamtUsedCalc += parseFloat(this.TransactionSplit[i].ServicingAmount_Distr?this.TransactionSplit[i].ServicingAmount_Distr:0)
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
        this.SplitDelta = this.TransactionSplitParent.Delta?this.formatNumberforTwoDecimalplaces(this.TransactionSplitParent.Delta):0;
        
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
                  
                    if (reconSplit[i].ServicingAmount_Distr==null) {
                        if (isValidate) {
                            exceptionmessage = 'All the selected checkboxes should have a value in Servicer Amount column.';
                            isValidate = false;
                        }
                    }
                }
            }

            var totalSum =0;
            for (var i = 0; i < reconSplit.length; i++) {
                if (reconSplit[i].ServicingAmount_Distr) {
                    totalSum += parseFloat(reconSplit[i].ServicingAmount_Distr)
                }
              
            }

            if (totalSum==0 && reconSplit.length == 0) {
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
        }

        if (isValidate) {
            this.transserv.ReconcileSplitTranscation(reconSplit).subscribe(res => {
                if (res.Succeeded) {
                    this.isProcessComplete = false;
                    this.CloseSplitTransaction();
                    this.GetAllTranscationNew();
                    this.GetAllTransactionType();
                }
            })
        }
        else {
            this.CustomAlert(exceptionmessage);
            this.isProcessComplete = false;
           
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
                newamount = "-" +  _amount;
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
    imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjInputModule, WjGridFilterModule, Ng2FileInputModule.forRoot()],
    declarations: [TranscationreconciliationComponent]
})

export class TranscationreconciliationComponentModule {

}
