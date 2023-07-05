"use strict";
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var TranscationreconciliationService_1 = require("../../core/services/TranscationreconciliationService");
var PermissionService_1 = require("../../core/services/PermissionService");
var utilityService_1 = require("../../core/services/utilityService");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var fileuploadservice_1 = require("../../core/services/fileuploadservice");
var ng2_file_input_1 = require("ng2-file-input");
var wjNg2Input = require("wijmo/wijmo.angular2.input");
var wijmo_angular2_core_1 = require("wijmo/wijmo.angular2.core");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_input_1 = require("wijmo/wijmo.angular2.input");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var wjcGrid = require("wijmo/wijmo.grid");
var paginated_1 = require("../../core/common/paginated");
var dealservice_1 = require("../../core/services/dealservice");
var wjcInput = require("wijmo/wijmo.input");
var TranscationreconciliationComponent = /** @class */ (function (_super) {
    __extends(TranscationreconciliationComponent, _super);
    function TranscationreconciliationComponent(ng2FileInputService, fileUploadService, permissionService, utilityService, transserv, dealSrv, _router) {
        var _this = 
        // this.GetUserPermission();
        _super.call(this, 50, 1, 0) || this;
        _this.ng2FileInputService = ng2FileInputService;
        _this.fileUploadService = fileUploadService;
        _this.permissionService = permissionService;
        _this.utilityService = utilityService;
        _this.transserv = transserv;
        _this.dealSrv = dealSrv;
        _this._router = _router;
        _this.projectId = 0;
        _this.sectionId = 0;
        _this.fileExt = "xlsx,csv";
        _this.maxFiles = 1;
        _this.maxSize = 15; // 15MB
        _this.uploadStatus = new core_1.EventEmitter();
        _this.errors = [];
        _this.actionLog = "";
        _this.myFileInputIdentifier = "tHiS_Id_IS_sPeeCiAL";
        _this.isProcessComplete = false;
        _this._ShowdivMsgWar = false;
        _this._Showmessagediv = false;
        _this._istransRecordexist = false;
        _this.NonZeroDeltaFilter = 0;
        _this._showhistory = false;
        _this.IsReconciled = false;
        _this.IsException = false;
        _this.norecord = false;
        _this.isReconcHistory = false;
        _this._M61chkSelectAll = false;
        _this._ServicerSelectAll = false;
        _this._IgnoreSelectAll = false;
        _this._UnreconcileSelectAll = false;
        // _EmptySearchMsg: boolean = false;
        _this._isFilterapply = false;
        _this._isFilter = false;
        _this.TransactionSplitParent = [];
        _this.TransactionType = 0;
        _this.GetAllServicer();
        _this.GetAllLookups();
        _this.GetAllDealsForFilter();
        _this.GetAllTransactionType();
        //this.GetAllNotes();
        _this.ScenarioId = window.localStorage.getItem("scenarioid");
        _this.utilityService.setPageTitle("M61-Transaction Reconciliation");
        return _this;
    }
    // Component views are initialized
    TranscationreconciliationComponent.prototype.ngAfterViewInit = function () {
        var _this = this;
        this.flextrans.scrollPositionChanged.addHandler(function () {
            var myDiv = $('#flextrans').find('div[wj-part="root"]');
            if (!_this.isReconcHistory) {
                if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
                    if (_this.flextrans.rows.length < _this._totalCount) {
                        _this._pageIndex = _this.pagePlus(1);
                        _this.GetAllTranscationNew();
                    }
                }
            }
        });
    };
    TranscationreconciliationComponent.prototype.GetAllLookups = function () {
        var _this = this;
        this.dealSrv.getAllLookup().subscribe(function (res) {
            var data = res.lstLookups;
            _this.lstRecontype = data.filter(function (x) { return x.ParentID == "82"; });
            _this.lstDeltaNonZero = data.filter(function (x) { return x.ParentID == "83"; });
            _this.lstddlOverideValue = data.filter(function (x) { return x.ParentID == "108"; });
            _this._bindGridDropdows();
        });
    };
    TranscationreconciliationComponent.prototype.GetAllNotes = function () {
        var _this = this;
        this.transserv.getAllNotes().subscribe(function (res) {
            if (res.Succeeded) {
                _this.lstNotes = res.lstNotes;
            }
        });
    };
    TranscationreconciliationComponent.prototype.GetAllDealsForFilter = function () {
        var _this = this;
        this.transserv.getAllDealsForFilter(this.IsReconciled).subscribe(function (res) {
            if (res.Succeeded) {
                _this.lstdeals = res.lstDeals;
            }
        });
    };
    TranscationreconciliationComponent.prototype.AppliedReadOnly = function () {
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
    };
    TranscationreconciliationComponent.prototype.GetAllServicer = function () {
        var _this = this;
        this.transserv.getAllServicer().subscribe(function (res) {
            if (res.Succeeded) {
                _this.lstServicer = res.lstServicer;
                if (_this.lstServicer.length > 0) {
                    _this.closeDate = new Date(_this.lstServicer[0].CloseDate.toString());
                }
                _this.GetAllTranscationNew();
            }
        });
    };
    //
    TranscationreconciliationComponent.prototype.GetAllTransactionType = function () {
        var _this = this;
        this.transserv.getAllTransactionType().subscribe(function (res) {
            if (res.Succeeded) {
                _this.lstallTransactionType = res.dt;
            }
        });
    };
    TranscationreconciliationComponent.prototype.Reconciliation = function () {
        var _this = this;
        this.isProcessComplete = true;
        var exceptionmessage = '';
        var isValidate = true;
        if (this.flextrans.rows.length > 0) {
            var rectrans = [];
            for (var k = 0; k < this.flextrans.rows.length; k++) {
                rectrans.push(this.flextrans.rows[k].dataItem);
            }
            var reconTrans = rectrans.filter(function (x) { return x.M61Value == true || x.ServicerValue == true || x.Ignore == true || x.OverrideValue != null; });
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
                            reconTrans[i].Delta = (reconTrans[i].Delta * 100 / 100).toFixed(2); // = 0.000001;
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
                    this.transserv.InsertupdateTranscation(reconTrans).subscribe(function (res) {
                        if (res.Succeeded) {
                            if (_this._pageIndex != 1)
                                _this._pageIndex = 1;
                            _this._isFilterapply = false;
                            if (_this._isFilter) {
                                _this.FilterData();
                            }
                            else {
                                _this.GetAllTranscationNew();
                                _this.TransactionType = 0;
                            }
                            _this._Showmessagediv = true;
                            _this._ShowmessagedivMsg = res.Message;
                            _this.isProcessComplete = false;
                            _this._ShowdivMsgWar = false;
                        }
                        else {
                            _this._Showmessagediv = false;
                            _this._ShowdivMsgWar = true;
                            _this._WarmsgdashBoad = res.Message;
                            _this.isProcessComplete = false;
                        }
                    });
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
    };
    TranscationreconciliationComponent.prototype.SaveReconcile = function () {
        var _this = this;
        this.isProcessComplete = true;
        if (this.lsttranscation.length > 0) {
            for (var i = 0; i < this.lsttranscation.length; i++) {
                if (this.lsttranscation[i].Delta % 1 == 0) {
                    this.lsttranscation[i].Delta = (this.lsttranscation[i].Delta * 100 / 100).toFixed(2); // = 0.000001;
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
            this.transserv.SaveTranscation(this.lsttranscation).subscribe(function (res) {
                if (res.Succeeded) {
                    _this._Showmessagediv = true;
                    _this._ShowmessagedivMsg = res.Message;
                    _this.isProcessComplete = false;
                    _this._ShowdivMsgWar = false;
                }
                else {
                    _this._ShowdivMsgWar = true;
                    _this._WarmsgdashBoad = res.Message;
                    _this.isProcessComplete = false;
                    _this._Showmessagediv = false;
                }
                // setTimeout(function () {
                //    this._Showmessagediv = false;
                //   this._ShowmessagedivMsg = '';
                //  this._WarmsgdashBoad = '';
                _this.isProcessComplete = false;
                _this.flextrans.invalidate();
                // }.bind(this), 2000);
            });
        }
        else {
            this.isProcessComplete = false;
        }
    };
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
    TranscationreconciliationComponent.prototype._bindGridDropdows = function () {
        if (this.flextrans) {
            var colOverReas = this.flextrans.columns.getColumn('OverrideReasonText');
            if (colOverReas) {
                colOverReas.showDropDown = true;
                colOverReas.dataMap = this._buildDataMap(this.lstddlOverideValue);
            }
        }
    };
    TranscationreconciliationComponent.prototype._buildDataMap = function (items) {
        var map = [];
        for (var i = 0; i < items.length; i++) {
            var obj = items[i];
            map.push({ key: obj['LookupID'], value: obj['Name'] });
        }
        return new wjcGrid.DataMap(map, 'key', 'value');
    };
    TranscationreconciliationComponent.prototype.GetAllTranscationNew = function (type) {
        var _this = this;
        if (type === void 0) { type = ""; }
        var data;
        var type;
        if (!this._isFilterapply) {
            this.isProcessComplete = true;
            this.transserv.getAllTranscationNew(type, this._pageIndex, this._pageSize).subscribe(function (res) {
                if (res.Succeeded) {
                    _this._showhistory = false;
                    data = res.dtCalcReq;
                    _this._totalCount = res.TotalCount;
                    _this.isProcessComplete = false;
                    if (_this._pageIndex == 1) {
                        _this.lsttranscation = data;
                        // this.flextrans.selectionMode = wjcGrid.SelectionMode.None;
                    }
                    else {
                        _this.lsttranscation = _this.lsttranscation.concat(data);
                    }
                    //format date
                    if (_this.lsttranscation.length > 0) {
                        _this._istransRecordexist = true;
                        for (var i = 0; i < _this.lsttranscation.length; i++) {
                            if (_this.lsttranscation[i].DateDue != null) {
                                _this.lsttranscation[i].DateDue = new Date(_this.lsttranscation[i].DateDue.toString());
                            }
                            if (_this.lsttranscation[i].TransactionDate != null) {
                                _this.lsttranscation[i].TransactionDate = new Date(_this.lsttranscation[i].TransactionDate.toString());
                            }
                            if (_this.lsttranscation[i].RemittanceDate != null) {
                                _this.lsttranscation[i].RemittanceDate = new Date(_this.lsttranscation[i].RemittanceDate.toString());
                            }
                            if (_this.lsttranscation[i].Delta % 1 == 0) {
                                _this.lsttranscation[i].Delta = (_this.lsttranscation[i].Delta * 100 / 100).toFixed(2);
                            }
                            if (_this.lsttranscation[i].ActualDelta % 1 == 0) {
                                _this.lsttranscation[i].ActualDelta = (_this.lsttranscation[i].ActualDelta * 100 / 100).toFixed(2);
                            }
                            if (_this.lsttranscation[i].Adjustment % 1 == 0) {
                                _this.lsttranscation[i].Adjustment = (_this.lsttranscation[i].Adjustment * 100 / 100).toFixed(2);
                            }
                            if (_this.lsttranscation[i].AddlInterest % 1 == 0) {
                                _this.lsttranscation[i].AddlInterest = (_this.lsttranscation[i].AddlInterest * 100 / 100).toFixed(2);
                            }
                            if (_this.lsttranscation[i].TotalInterest % 1 == 0) {
                                _this.lsttranscation[i].TotalInterest = (_this.lsttranscation[i].TotalInterest * 100 / 100).toFixed(2);
                            }
                            if (_this.lsttranscation[i].ServicingAmount % 1 == 0) {
                                _this.lsttranscation[i].ServicingAmount = (_this.lsttranscation[i].ServicingAmount * 100 / 100).toFixed(2);
                            }
                            if (_this.lsttranscation[i].CalculatedAmount % 1 == 0) {
                                _this.lsttranscation[i].CalculatedAmount = (_this.lsttranscation[i].CalculatedAmount * 100 / 100).toFixed(2);
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
                        _this._Showmessagediv = true;
                        _this._ShowmessagedivMsg = "M61 values updated successfully.";
                        _this._ShowdivMsgWar = false;
                        // setTimeout(function () {
                        //  this._Showmessagediv = false;
                        //   this._ShowmessagedivMsg = '';
                        //   this._WarmsgdashBoad = '';
                        //  }.bind(this), 2000);
                    }
                }
                else {
                    _this.utilityService.navigateToSignIn();
                }
            });
        }
    };
    TranscationreconciliationComponent.prototype.ReconciledHistory = function (val) {
        this.IsReconciled = val;
        this.GetAllDealsForFilter();
    };
    TranscationreconciliationComponent.prototype.getExceptions = function (val) {
        this.IsException = val;
    };
    TranscationreconciliationComponent.prototype.unRecCheckbox = function (item, val) {
        this.flextrans.invalidate();
        if (val == true) {
            item.isRecon = 1;
        }
        else {
            item.isRecon = 0;
        }
    };
    TranscationreconciliationComponent.prototype.Unreconcile = function () {
        var _this = this;
        var unrec = this.lsttranscation.filter(function (x) { return x.isRecon == 1; });
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
            this.transserv.UnreconcileTranscation(unrec).subscribe(function (res) {
                if (res.Succeeded) {
                    _this._isFilterapply = false;
                    _this._isFilter = false;
                    _this.GetAllTranscationNew();
                    _this.TransactionType = 0;
                    _this._Showmessagediv = true;
                    _this._ShowmessagedivMsg = res.Message;
                    _this.isProcessComplete = false;
                    _this.IsReconciled = false;
                    _this._ShowdivMsgWar = false;
                }
                else {
                    _this._ShowdivMsgWar = true;
                    _this._Showmessagediv = false;
                    _this._WarmsgdashBoad = res.Message;
                    _this.isProcessComplete = false;
                }
            });
        }
        else {
            this.CustomAlert('Please check any record to Unreconcile.');
        }
    };
    TranscationreconciliationComponent.prototype.ClearFilter = function () {
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
    };
    TranscationreconciliationComponent.prototype.FilterData = function () {
        var _this = this;
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
            var Dealsfilter = "'" + this.multiselDeals.checkedItems.map(function (_a) {
                var CREDealID = _a.CREDealID;
                return CREDealID;
            }).join("','");
        if (this.multiselTransactionType != undefined)
            var TransactionTypefilter = "'" + this.multiselTransactionType.checkedItems.map(function (_a) {
                var TransactionType = _a.TransactionType;
                return TransactionType;
            }).join("','");
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
        this.transserv.FilterTranscations(searchstr).subscribe(function (res) {
            if (res.Succeeded) {
                _this._ShowdivMsgWar = false;
                _this._WarmsgdashBoad = '';
                _this._isFilterapply = true;
                _this._isFilter = true;
                _this.lsttranscation = res.dtCalcReq;
                if (_this.lsttranscation.length > 0) {
                    for (var i = 0; i < _this.lsttranscation.length; i++) {
                        if (_this.lsttranscation[i].DateDue != null) {
                            _this.lsttranscation[i].DateDue = new Date(_this.lsttranscation[i].DateDue.toString());
                        }
                        if (_this.lsttranscation[i].TransactionDate != null) {
                            _this.lsttranscation[i].TransactionDate = new Date(_this.lsttranscation[i].TransactionDate.toString());
                        }
                        if (_this.lsttranscation[i].RemittanceDate != null) {
                            _this.lsttranscation[i].RemittanceDate = new Date(_this.lsttranscation[i].RemittanceDate.toString());
                        }
                        if (_this.lsttranscation[i].Delta % 1 == 0) {
                            _this.lsttranscation[i].Delta = (_this.lsttranscation[i].Delta * 100 / 100).toFixed(2); // = 0.000001;
                        }
                        if (_this.lsttranscation[i].ActualDelta % 1 == 0) {
                            _this.lsttranscation[i].ActualDelta = (_this.lsttranscation[i].ActualDelta * 100 / 100).toFixed(2);
                        }
                        if (_this.lsttranscation[i].Adjustment % 1 == 0) {
                            _this.lsttranscation[i].Adjustment = parseFloat((_this.lsttranscation[i].Adjustment * 100 / 100).toFixed(2));
                        }
                        if (_this.lsttranscation[i].AddlInterest % 1 == 0) {
                            _this.lsttranscation[i].AddlInterest = (_this.lsttranscation[i].AddlInterest * 100 / 100).toFixed(2);
                        }
                        if (_this.lsttranscation[i].TotalInterest % 1 == 0) {
                            _this.lsttranscation[i].TotalInterest = (_this.lsttranscation[i].TotalInterest * 100 / 100).toFixed(2);
                        }
                        if (_this.lsttranscation[i].ServicingAmount % 1 == 0) {
                            _this.lsttranscation[i].ServicingAmount = (_this.lsttranscation[i].ServicingAmount * 100 / 100).toFixed(2);
                        }
                        if (_this.lsttranscation[i].CalculatedAmount % 1 == 0) {
                            _this.lsttranscation[i].CalculatedAmount = (_this.lsttranscation[i].CalculatedAmount * 100 / 100).toFixed(2);
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
                    }.bind(_this), 500);
                    _this.isProcessComplete = false;
                }
                else {
                    //this._ShowdivMsgWar = true;
                    //this._WarmsgdashBoad = res.Message;
                    _this.isProcessComplete = false;
                }
            }
            else {
                _this._Showmessagediv = false;
                _this._ShowdivMsgWar = true;
                _this._WarmsgdashBoad = res.Message;
                _this.isProcessComplete = false;
            }
            // setTimeout(function () {
            //  this._Showmessagediv = false;
            // this._ShowdivMsgWar = false;
            // this._ShowmessagedivMsg = '';
            //   this._WarmsgdashBoad = '';
            // }.bind(this), 5000);
        });
    };
    TranscationreconciliationComponent.prototype.servicerClicked = function (servicer) {
        this._servicerName = servicer.SericerName;
        this._servicerid = servicer.ServicerMasterID;
    };
    TranscationreconciliationComponent.prototype.ChangeCheckbox = function (recval) {
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
    };
    TranscationreconciliationComponent.prototype.GetUserPermission = function () {
        var _this = this;
        this.permissionService.GetUserPermissionByPagename("Integration").subscribe(function (res) {
            if (res.Succeeded) {
                if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                }
                else {
                    localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                    localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));
                    _this.utilityService.navigateUnauthorize();
                }
            }
        });
    };
    TranscationreconciliationComponent.prototype.onAction = function (event, servicer) {
        $('.ng2-file-input-file-text').text('');
        this._servicerName = servicer.SericerName;
        this._servicerid = servicer.ServicerMasterID;
        this.actionLog += "\n currentFiles: " + this.getFileNames(event.currentFiles);
        console.log(this.actionLog);
        //let fileList: FileList = event.currentFiles;
        this.fileList = event.currentFiles;
        //this.saveFiles(this.fileList);
    };
    TranscationreconciliationComponent.prototype.convertDateToBindable = function (date) {
        if (date) {
            var dateObj = new Date(date);
            return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear();
        }
    };
    TranscationreconciliationComponent.prototype.getTwoDigitString = function (number) {
        if (number.toString().length === 1)
            return "0" + number;
        return number;
    };
    TranscationreconciliationComponent.prototype.onAdded = function (event) {
        this.actionLog += "\n FileInput: " + event.id;
        this.actionLog += "\n Action: File added";
        this.filename = event.file.name;
        this.showDialog();
        console.log('onAdded');
    };
    TranscationreconciliationComponent.prototype.onRemoved = function (event) {
        this.actionLog += "\n FileInput: " + event.id;
        this.actionLog += "\n Action: File removed";
    };
    TranscationreconciliationComponent.prototype.onInvalidDenied = function (event) {
        this.actionLog += "\n FileInput: " + event.id;
        this.actionLog += "\n Action: File denied";
    };
    TranscationreconciliationComponent.prototype.onCouldNotRemove = function (event) {
        this.actionLog += "\n FileInput: " + event.id;
        this.actionLog += "\n Action: Could not remove file";
    };
    TranscationreconciliationComponent.prototype.resetFileInput = function (file) {
        this.ng2FileInputService.reset(this.myFileInputIdentifier);
    };
    TranscationreconciliationComponent.prototype.logCurrentFiles = function () {
        var files = this.ng2FileInputService.getCurrentFiles(this.myFileInputIdentifier);
        this.actionLog += "\n The currently added files are: " + this.getFileNames(files);
    };
    TranscationreconciliationComponent.prototype.getFileNames = function (files) {
        var names = files.map(function (file) { return file.name; });
        return names ? names.join(", ") : "No files currently added.";
    };
    TranscationreconciliationComponent.prototype.isValidFiles = function (files) {
        // Check Number of files
        if (files.length > this.maxFiles) {
            this.errors.push("At a time you can upload only " + this.maxFiles + " file <BR/>");
            return;
        }
        this.isValidFileExtension(files);
        return this.errors.length === 0;
    };
    TranscationreconciliationComponent.prototype.isValidFileExtension = function (files) {
        // Make array of file extensions
        var extensions = (this.fileExt.split(','))
            .map(function (x) { return x.toLocaleUpperCase().trim(); });
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
    };
    TranscationreconciliationComponent.prototype.isValidFileSize = function (file) {
        var fileSizeinMB = file.size / (1024 * 1000);
        var size = Math.round(fileSizeinMB * 100) / 100; // convert upto 2 decimal place
        if (size > this.maxSize)
            this.errors.push("<BR/>Selected: " + file.name + ": exceed file size limit of " + this.maxSize + "MB ( " + size + "MB )");
    };
    TranscationreconciliationComponent.prototype.ImportFile = function () {
        this.saveFiles();
    };
    TranscationreconciliationComponent.prototype.saveFiles = function () {
        //if (typeof this._servicerName === "undefined") {
        //    this.CustomAlert("Please select SericerName .");
        //    this.isProcessComplete = false;
        //    return;
        var _this = this;
        //}
        //else {
        this.isProcessComplete = true;
        var files = this.fileList;
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
            var formData = new FormData();
            for (var j = 0; j < files.length; j++) {
                formData.append("file[]", files[j], files[j].name);
            }
            var user = JSON.parse(localStorage.getItem('user'));
            var parameters = {
                userid: user.UserID,
                Servicer: this._servicerName,
                Servicerid: this._servicerid,
                ScenarioId: this.ScenarioId
            };
            this.transserv.uploadfile(formData, parameters)
                .subscribe(function (res) {
                if (res.Succeeded) {
                    _this._istransRecordexist = true;
                    _this.GetAllTranscationNew();
                    _this.GetAllDealsForFilter();
                    _this.GetAllTransactionType();
                    _this._Showmessagediv = true;
                    var smessage = res.Message.split('==');
                    _this._ShowmessagedivMsg = smessage[1];
                    _this.isProcessComplete = false;
                    _this._ShowdivMsgWar = false;
                }
                else {
                    _this.uploadStatus.emit(true);
                    _this._ShowdivMsgWar = true;
                    var smessage = res.Message.split('==');
                    _this._WarmsgdashBoad = smessage[1];
                    _this.isProcessComplete = false;
                    _this._Showmessagediv = false;
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
    };
    TranscationreconciliationComponent.prototype.showDialog = function () {
        this.isProcessComplete = false;
        var modaltrans = document.getElementById('myModal');
        modaltrans.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    TranscationreconciliationComponent.prototype.ClosePopUp = function () {
        //  this.isProcessComplete = false;
        var modal = document.getElementById('myModal');
        modal.style.display = "none";
    };
    TranscationreconciliationComponent.prototype.toggleCheckbox = function (item, itemfor, flexGridrw, isChecked) {
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
    };
    TranscationreconciliationComponent.prototype.CustomAlert = function (dialog) {
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
    };
    TranscationreconciliationComponent.prototype.ok = function () {
        document.getElementById('dialogbox').style.display = "none";
        document.getElementById('dialogoverlay').style.display = "none";
    };
    TranscationreconciliationComponent.prototype.clickedalltransactions = function (NoteId, DateDue, TransactionType, CRENoteID, NoteName) {
        var _this = this;
        this.isProcessComplete = true;
        var searchtrans = '';
        this.CRENoteId = CRENoteID;
        this.NoteName = NoteName;
        this.ScenarioId = window.localStorage.getItem("scenarioid");
        searchtrans = NoteId + "#" + this.convertDateToBindable(DateDue) + "#" + TransactionType + "#" + this.ScenarioId;
        this.allTransactions = null;
        this.transserv.GetAllTransactionByNote(searchtrans).subscribe(function (res) {
            if (res.Succeeded) {
                _this.allTransactions = res.lstFundingSchedule;
                _this.isProcessComplete = false;
                _this.norecord = false;
                if (_this.allTransactions) {
                    for (var i = 0; i < _this.allTransactions.length; i++) {
                        if (_this.allTransactions[i].DueDate != null) {
                            _this.allTransactions[i].DueDate = new Date(_this.allTransactions[i].DueDate.toString());
                        }
                        if (_this.allTransactions[i].TransactionDate != null) {
                            _this.allTransactions[i].TransactionDate = new Date(_this.allTransactions[i].TransactionDate.toString());
                        }
                    }
                }
                setTimeout(function () {
                    // this.allTransactions = this.allTransactions;
                    this.flexallTransactions.invalidate();
                }.bind(_this), 1000);
            }
            else {
                _this.allTransactions = null;
                _this.norecord = true;
                _this.isProcessComplete = false;
            }
        });
        var modaltrans = document.getElementById('myModalTrans');
        modaltrans.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    TranscationreconciliationComponent.prototype.addFooterRow = function (flexGrid) {
        var row = new wjcGrid.GroupRow(); // create a GroupRow to show aggregates
        flexGrid.columnFooters.rows.push(row); // add the row to the column footer panel
        flexGrid.bottomLeftCells.setCellData(0, 0, '\u03A3');
        // sigma on the header
    };
    TranscationreconciliationComponent.prototype.CloseTransPopUp = function () {
        var modalCopy = document.getElementById('myModalTrans');
        modalCopy.style.display = "none";
    };
    TranscationreconciliationComponent.prototype.DownloadDocument = function (selectedValue, SericerFile) {
        var _this = this;
        //filename, originalfilename, storagetype, documentStorageID
        var storagetype = 'LocalStorage';
        var documentStorageID = '';
        var filename = SericerFile;
        var originalfilename = SericerFile;
        this.isProcessComplete = true;
        var selectedText = selectedValue.target.text;
        selectedText = selectedText.trim();
        documentStorageID = documentStorageID === undefined ? '' : documentStorageID;
        var ID = '';
        if (storagetype == 'Box')
            ID = documentStorageID;
        else if (storagetype == 'AzureBlob')
            ID = filename;
        else if (storagetype == 'LocalStorage')
            ID = filename;
        this.fileUploadService.downloadObjectDocumentByStorageType(ID, storagetype)
            .subscribe(function (fileData) {
            var b = new Blob([fileData]);
            //var url = window.URL.createObjectURL(b);
            //window.open(url);
            var dwldLink = document.createElement("a");
            var url = URL.createObjectURL(b);
            var isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
            if (isSafariBrowser) { //if Safari open in new window to save file with random filename.
                dwldLink.setAttribute("target", "_blank");
            }
            dwldLink.setAttribute("href", url);
            dwldLink.setAttribute("download", originalfilename);
            dwldLink.style.visibility = "hidden";
            document.body.appendChild(dwldLink);
            dwldLink.click();
            document.body.removeChild(dwldLink);
            _this.isProcessComplete = false;
        }, function (error) {
            //alert('Something went wrong');
            _this.isProcessComplete = false;
            ;
        });
    };
    TranscationreconciliationComponent.prototype.ClearSelection = function () {
        this.lsttranscation.forEach(function (obj, i) {
            obj.ServicerValue = false,
                obj.M61Value = false,
                obj.Ignore = false;
        });
        this.flextrans.invalidate();
    };
    TranscationreconciliationComponent.prototype.celleditActualDelta = function (flextrans, e) {
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
            if (Delta == null && Delta == undefined)
                Delta = 0;
            if (Adjustment == null && Adjustment == undefined)
                Adjustment = 0;
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
                if (!M61_Value)
                    M61_Value = 0;
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
    };
    TranscationreconciliationComponent.prototype.pastedActualDelta = function (flextrans, e) {
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
                if (Delta == null && Delta == undefined)
                    Delta = 0;
                if (Adjustment == null && Adjustment == undefined)
                    Adjustment = 0;
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
                if (!M61_Value)
                    M61_Value = 0;
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
                if (Adjustment == null && Adjustment == undefined)
                    Adjustment = 0;
                if (Delta == null && Delta == undefined)
                    Delta = 0;
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
    };
    TranscationreconciliationComponent.prototype.sortingColumn = function (flextrans, e) {
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
    };
    TranscationreconciliationComponent.prototype.M61SelectAll = function () {
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
    };
    TranscationreconciliationComponent.prototype.ServicerSelectAll = function () {
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
    };
    TranscationreconciliationComponent.prototype.IgnoreSelectAll = function () {
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
    };
    TranscationreconciliationComponent.prototype.UnreconcileSelectAll = function () {
        this._UnreconcileSelectAll = !this._UnreconcileSelectAll;
        for (var i = 0; i <= this.flextrans.rows.length; i++) {
            if (this.flextrans.rows[i]) {
                this.flextrans.rows[i]._data.isRecon = this._UnreconcileSelectAll;
            }
        }
        this.flextrans.invalidate();
    };
    TranscationreconciliationComponent.prototype.filterChanged = function () {
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
    };
    TranscationreconciliationComponent.prototype.RefreshM61Amount = function () {
        this.startDate = null;
        this.EndDate = null;
        this._isFilterapply = false;
        this.NonZeroDeltaFilter = 0;
        this._pageIndex = 1;
        this.IsReconciled = false;
        this.multiselDeals.checkedItems = [];
        this.GetAllTranscationNew("RefreshM61Amount");
    };
    TranscationreconciliationComponent.prototype.onContextMenu = function (grid, e) {
        var hti = grid.hitTest(e);
        if (hti.panel && hti.panel === grid.cells && hti.panel.columns[hti.col].binding === "ServicingAmount") {
            if (grid.rows[hti.row]._data["SplitTransactionid"] == null && (grid.rows[hti.row]._data["TransactionType"] == 'ExitFee' || grid.rows[hti.row]._data["TransactionType"] == 'ExtensionFee' || grid.rows[hti.row]._data["TransactionType"] == 'ScheduledPrincipalPaid')) {
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
    };
    TranscationreconciliationComponent.prototype.menuSplitItemClicked = function (s, e) {
        var _this = this;
        var _a = this.flextrans.selection, selectedRow = _a.row, selectedCol = _a.col;
        var _b = this.hti, clickedRow = _b.row, clickedCol = _b.col;
        this.TransactionSplitParent = this.flextrans.rows[clickedRow]._data; //= this.lsttranscation[clickedRow];
        //this.TransactionSplitParent = this.lsttranscation.filter(x => x.Transcationid == ParentTrans.Transcationid);
        // this.flexSplitParentTrans.invalidate();
        this.TransactionSplitParent.RemittanceDate = this.convertDateToBindable(this.TransactionSplitParent.RemittanceDate);
        this.parentTrans = this.lsttranscation.filter(function (x) { return x.Transcationid == _this.TransactionSplitParent.Transcationid; });
        var modal = document.getElementById('myModalSplitTrans');
        modal.style.display = "block";
        $.getScript("/js/jsDrag.js");
        this.SplitServicingAmount = this.TransactionSplitParent.ServicingAmount ? this.formatNumberforTwoDecimalplaces(parseFloat(this.TransactionSplitParent.ServicingAmount)) : 0;
        this.SplitFinal_ValueUsedInCalc = this.TransactionSplitParent.Final_ValueUsedInCalc ? this.formatNumberforTwoDecimalplaces(parseFloat(this.TransactionSplitParent.Final_ValueUsedInCalc)) : 0;
        this.SplitDelta = this.TransactionSplitParent.Delta ? this.formatNumberforTwoDecimalplaces(parseFloat(this.TransactionSplitParent.Delta)) : 0;
        this.isProcessComplete = true;
        if (this.lsttranscation.length > 0) {
            this.transserv.SplitTranscation(this.parentTrans).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.TransactionSplit = res.dt;
                    for (var i = 0; i < _this.TransactionSplit.length; i++) {
                        if (_this.TransactionSplit[i].DueDate != null) {
                            _this.TransactionSplit[i].DueDate = new Date(_this.TransactionSplit[i].DueDate.toString());
                        }
                    }
                    _this.isProcessComplete = false;
                    _this._ShowdivMsgWar = false;
                }
                else {
                    _this.isProcessComplete = false;
                    _this._Showmessagediv = false;
                }
                //this.isProcessComplete = false;
                // this.flextrans.invalidate();
                _this.flexSplitTrans.invalidate();
            });
        }
        //  this.isProcessComplete = false;
    };
    TranscationreconciliationComponent.prototype.CloseSplitTransaction = function () {
        this.isProcessComplete = false;
        this.TransactionSplit = null;
        var modalSplit = document.getElementById('myModalSplitTrans');
        modalSplit.style.display = "none";
    };
    TranscationreconciliationComponent.prototype.ChangeReceived = function (chkReceived, rowdata) {
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
                    TotalamtUsedCalc += parseFloat(this.TransactionSplit[i].ServicingAmount_Distr);
                }
            }
            else {
                TotalamtUsedCalc += parseFloat(this.TransactionSplit[i].OverrideValue);
            }
        }
        this.TransactionSplitParent.Final_ValueUsedInCalc = TotalamtUsedCalc.toFixed(2);
        this.TransactionSplitParent.Delta = parseFloat(this.TransactionSplitParent.ServicingAmount) - parseFloat(this.TransactionSplitParent.Final_ValueUsedInCalc);
        // this.TransactionSplitParent.Delta = this.TransactionSplitParent.Delta.toFixed(2);
        this.SplitFinal_ValueUsedInCalc = this.formatNumberforTwoDecimalplaces(TotalamtUsedCalc);
        this.SplitDelta = this.TransactionSplitParent.Delta ? this.formatNumberforTwoDecimalplaces(this.TransactionSplitParent.Delta) : 0;
        this.flexSplitTrans.invalidate();
    };
    TranscationreconciliationComponent.prototype.celleditSplitTrans = function (flexSplitTrans, e) {
        var TotalamtUsedCalc = 0;
        for (var i = 0; i < this.TransactionSplit.length; i++) {
            if (this.TransactionSplit[i].OverrideValue == null || this.TransactionSplit[i].OverrideValue == "") {
                if (this.TransactionSplit[i].Received == true) {
                    TotalamtUsedCalc += parseFloat(this.TransactionSplit[i].ServicingAmount_Distr ? this.TransactionSplit[i].ServicingAmount_Distr : 0);
                }
            }
            else {
                TotalamtUsedCalc += parseFloat(this.TransactionSplit[i].OverrideValue);
            }
        }
        this.TransactionSplitParent.Final_ValueUsedInCalc = TotalamtUsedCalc.toFixed(2);
        this.TransactionSplitParent.Delta = parseFloat(this.TransactionSplitParent.ServicingAmount) - parseFloat(this.TransactionSplitParent.Final_ValueUsedInCalc);
        //this.TransactionSplitParent.Delta = this.TransactionSplitParent.Delta.toFixed(2);
        this.SplitFinal_ValueUsedInCalc = this.formatNumberforTwoDecimalplaces(TotalamtUsedCalc);
        this.SplitDelta = this.TransactionSplitParent.Delta ? this.formatNumberforTwoDecimalplaces(this.TransactionSplitParent.Delta) : 0;
        this.flexSplitTrans.invalidate();
    };
    TranscationreconciliationComponent.prototype.SplitTrasaction = function () {
        var _this = this;
        var exceptionmessage = '';
        var isValidate = true;
        if (this.TransactionSplit.length > 0) {
            var reconSplit = this.TransactionSplit.filter(function (x) { return x.Received == true; });
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
                }
            }
            var totalSum = 0;
            for (var i = 0; i < reconSplit.length; i++) {
                if (reconSplit[i].ServicingAmount_Distr) {
                    totalSum += parseFloat(reconSplit[i].ServicingAmount_Distr);
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
        }
        if (isValidate) {
            this.transserv.ReconcileSplitTranscation(reconSplit).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.isProcessComplete = false;
                    _this.CloseSplitTransaction();
                    _this.GetAllTranscationNew();
                    _this.GetAllTransactionType();
                }
            });
        }
        else {
            this.CustomAlert(exceptionmessage);
            this.isProcessComplete = false;
        }
    };
    TranscationreconciliationComponent.prototype.formatNumberforTwoDecimalplaces = function (data) {
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
            }
            else {
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
    };
    __decorate([
        core_1.Input(),
        __metadata("design:type", Number)
    ], TranscationreconciliationComponent.prototype, "projectId", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", Number)
    ], TranscationreconciliationComponent.prototype, "sectionId", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", String)
    ], TranscationreconciliationComponent.prototype, "fileExt", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", Number)
    ], TranscationreconciliationComponent.prototype, "maxFiles", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", Number)
    ], TranscationreconciliationComponent.prototype, "maxSize", void 0);
    __decorate([
        core_1.Output(),
        __metadata("design:type", Object)
    ], TranscationreconciliationComponent.prototype, "uploadStatus", void 0);
    __decorate([
        core_1.ViewChild('flextrans'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], TranscationreconciliationComponent.prototype, "flextrans", void 0);
    __decorate([
        core_1.ViewChild('flexallTransactions'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], TranscationreconciliationComponent.prototype, "flexallTransactions", void 0);
    __decorate([
        core_1.ViewChild('flexSplitParentTrans'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], TranscationreconciliationComponent.prototype, "flexSplitParentTrans", void 0);
    __decorate([
        core_1.ViewChild('flexSplitTrans'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], TranscationreconciliationComponent.prototype, "flexSplitTrans", void 0);
    __decorate([
        core_1.ViewChild('multiselRecon'),
        __metadata("design:type", wjNg2Input.WjMultiSelect)
    ], TranscationreconciliationComponent.prototype, "multiselRecon", void 0);
    __decorate([
        core_1.ViewChild('multiselDeltaNonZero'),
        __metadata("design:type", wjNg2Input.WjMultiSelect)
    ], TranscationreconciliationComponent.prototype, "multiselDeltaNonZero", void 0);
    __decorate([
        core_1.ViewChild('multiselNotes'),
        __metadata("design:type", wjNg2Input.WjMultiSelect)
    ], TranscationreconciliationComponent.prototype, "multiselNotes", void 0);
    __decorate([
        core_1.ViewChild('multiselDeals'),
        __metadata("design:type", wjNg2Input.WjMultiSelect)
    ], TranscationreconciliationComponent.prototype, "multiselDeals", void 0);
    __decorate([
        core_1.ViewChild('multiselTransactionType'),
        __metadata("design:type", wjNg2Input.WjMultiSelect)
    ], TranscationreconciliationComponent.prototype, "multiselTransactionType", void 0);
    __decorate([
        core_1.ViewChild('ctxSplitMenu'),
        __metadata("design:type", wjcInput.Menu)
    ], TranscationreconciliationComponent.prototype, "ctxSplitMenu", void 0);
    TranscationreconciliationComponent = __decorate([
        core_1.Component({
            templateUrl: "app/components/ImportExport/Transcationreconciliation.html?v=" + $.getVersion(),
            providers: [TranscationreconciliationService_1.TranscationreconciliationService, fileuploadservice_1.FileUploadService, PermissionService_1.PermissionService, dealservice_1.dealService]
        }),
        __metadata("design:paramtypes", [ng2_file_input_1.Ng2FileInputService,
            fileuploadservice_1.FileUploadService,
            PermissionService_1.PermissionService,
            utilityService_1.UtilityService,
            TranscationreconciliationService_1.TranscationreconciliationService,
            dealservice_1.dealService,
            router_1.Router])
    ], TranscationreconciliationComponent);
    return TranscationreconciliationComponent;
}(paginated_1.Paginated));
exports.TranscationreconciliationComponent = TranscationreconciliationComponent;
var routes = [
    { path: '', component: TranscationreconciliationComponent }
];
var TranscationreconciliationComponentModule = /** @class */ (function () {
    function TranscationreconciliationComponentModule() {
    }
    TranscationreconciliationComponentModule = __decorate([
        core_2.NgModule({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_core_1.WjCoreModule, wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_input_1.WjInputModule, wijmo_angular2_grid_filter_1.WjGridFilterModule, ng2_file_input_1.Ng2FileInputModule.forRoot()],
            declarations: [TranscationreconciliationComponent]
        })
    ], TranscationreconciliationComponentModule);
    return TranscationreconciliationComponentModule;
}());
exports.TranscationreconciliationComponentModule = TranscationreconciliationComponentModule;
//# sourceMappingURL=Transcationreconciliation.component.js.map