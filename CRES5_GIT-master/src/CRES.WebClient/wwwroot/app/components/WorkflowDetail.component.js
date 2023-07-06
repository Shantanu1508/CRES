"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __spreadArrays = (this && this.__spreadArrays) || function () {
    for (var s = 0, i = 0, il = arguments.length; i < il; i++) s += arguments[i].length;
    for (var r = Array(s), k = 0, i = 0; i < il; i++)
        for (var a = arguments[i], j = 0, jl = a.length; j < jl; j++, k++)
            r[k] = a[j];
    return r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.WorkflowDetailModule = exports.WorkflowDetailComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var utilityService_1 = require("../core/services/utilityService");
var Workflow_1 = require("../core/domain/Workflow");
var appsettings_1 = require("../core/common/appsettings");
var wjcCore = require("wijmo/wijmo");
var wjcGrid = require("wijmo/wijmo.grid");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wijmo_angular2_core_1 = require("wijmo/wijmo.angular2.core");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var wijmo_angular2_input_1 = require("wijmo/wijmo.angular2.input");
var WFService_1 = require("../core/services/WFService");
var dealservice_1 = require("../core/services/dealservice");
var fileuploadservice_1 = require("../core/services/fileuploadservice");
var Workflow_2 = require("../core/domain/Workflow");
var Workflow_3 = require("../core/domain/Workflow");
var deals_1 = require("../core/domain/deals");
var dataService_1 = require("../core/services/dataService");
var platform_browser_1 = require("@angular/platform-browser");
var DrawFeeInvoiceDetail_1 = require("../core/domain/DrawFeeInvoiceDetail");
var WorkflowDetailComponent = /** @class */ (function () {
    function WorkflowDetailComponent(_router, _actrouting, utilityService, wfSrv, dealSrv, fileUploadService, dataService, sanitizer) {
        var _this = this;
        this._router = _router;
        this._actrouting = _actrouting;
        this.utilityService = utilityService;
        this.wfSrv = wfSrv;
        this.dealSrv = dealSrv;
        this.fileUploadService = fileUploadService;
        this.dataService = dataService;
        this.sanitizer = sanitizer;
        this.lstWFComments = [];
        this._ShowmessagedivWar = false;
        this._isShowDownloadDoc = false;
        this._CanChangeReplyTo = false;
        this._CanChangeRecipientList = false;
        this._CanChangeHeader = false;
        this._CanChangeBody = false;
        this._CanChangeFooter = false;
        this._CanChangeSchedule = false;
        this._isShowNotify = false;
        this._isShowPreliminary = false;
        this._isShowRevisedPreliminary = false;
        this._isShowFinal = false;
        this._isShowRevisedFinal = false;
        this._isShowServicer = false;
        this._isShowRevisedServicer = false;
        this._isShowFinalPayOff = false;
        this._isShowRevisedFinalPayOff = false;
        this.private = true;
        this._Preliminary = "Preliminary";
        this._Final = "Final";
        this._Servicer = "Servicer";
        this._RevisedPreliminary = "RevisedPreliminary";
        this._RevisedFinal = "RevisedFinal";
        this._CancelPreliminary = "CancelPreliminary";
        this._RevisedServicer = "RevisedServicer";
        this._FinalWithoutApproval = "FinalWithoutApproval";
        this._RevisedFinalWithoutApproval = "RevisedFinalWithoutApproval";
        this._notificationTittle = "";
        this._isRefresh = false;
        this._Showmessagediv = false;
        this._ShowmessagedivMsg = '';
        this._isNotificationMsg = false;
        this.Delphi_Financial = "Delphi Financial";
        this.Delphi_Fixed = "Delphi Fixed";
        this.TRE_ACR = "TRE ACR";
        this.Refinance_Program = "Refinance Program";
        this.ACORE_Credit_IV = "ACORE Credit IV";
        this.AFLAC = "AFLAC";
        this.environmentName = "";
        this._isShowChecklist = false;
        this._isShowWorkflowWithoutValidationAndEmail = false;
        this._isShowWorkActualWorkflow = false;
        this._IsTeamApproval = false;
        this._IsAlreadyCancel = false;
        this._IsAlreadyCancelNegativeAmt = false;
        this._isShowDrawFee = false;
        this.lstStates = [];
        this._isShowinvoicesaveMsg = false;
        this.IsSaveClick = false;
        this.clickButtonType = "";
        this.IsShowSaveAndStatusButton = true;
        this.IsDrawFeeEditClick = false;
        this.isShowSendButton = true;
        this.tblPayoff = "";
        this._isShowPayOffFields = false;
        this._isPayOffNotifyClick = false;
        this._isShowPropertyManager = false;
        this.onload = function () {
            var ele = document.getElementById('drawFeeInvoicedivs');
        };
        this._isShowbtnRejected = false;
        this._isShowbtnSaveDraft = false;
        this._isShowbtnApproval = false;
        this._notificationmaster = new Workflow_2.WFNotificationMaster(0);
        this._wfNotificationDetail = new Workflow_3.WFNotificationDetailDataContract(0);
        Workflow_3.WFNotificationDetailDataContract;
        var WFTaskDetailId;
        this._workflow = new Workflow_1.Workflow(WFTaskDetailId);
        this._drawFeeInvoice = new DrawFeeInvoiceDetail_1.DrawFeeInvoiceDetail("");
        this._drawFeeInvoiceOrignal = new DrawFeeInvoiceDetail_1.DrawFeeInvoiceDetail("");
        this._wfAdditionalData = new Workflow_1.WFAdditionalData(WFTaskDetailId);
        //this._wfCheckListData = new WFCheckListData(WFTaskDetailId);
        this._wfStatusData = new Workflow_1.WFStatusData(WFTaskDetailId);
        this.rolename = window.localStorage.getItem("rolename");
        this._actrouting.params.forEach(function (params) {
            if (params['id'] !== undefined) {
                _this._workflow.TaskID = params['id'];
                _this._dealfunding = new deals_1.DealFunding('');
                _this._dealfunding.DealFundingID = _this._workflow.TaskID;
                _this._dealfundingDrawFee = new deals_1.DealFunding('');
                _this._dealfundingDrawFee.DealFundingID = _this._workflow.TaskID;
            }
            if (params['tasktype'] !== undefined) {
                _this._workflow.TaskTypeID = params['tasktype'];
            }
        });
        this._user = JSON.parse(localStorage.getItem('user'));
        // this._workflow.TaskID = 'A6146174-B5AC-44AE-8D62-0412A6A14C98';
        this.GetHolidayList();
        this.GetAllLookups();
        this.getWorkFlowDetail(this._workflow);
        this.utilityService.setPageTitle("M61–Workflow Detail");
        this.trustedNoteDetail = this.getSafeHTML();
        //this.getAllStatesMaster();
        //this.GetDrawFeeInvoiceDetailByTaskID();
        //this.trustedNoteAllocationPercentage = this.getSafeHTMLNoteAllocationPercentage()
    }
    WorkflowDetailComponent.prototype.getSafeHTML = function () {
        return this.sanitizer.bypassSecurityTrustHtml(this.noteswithAmount);
    };
    //getSafeHTMLNoteAllocationPercentage() {
    //    return this.sanitizer.bypassSecurityTrustHtml(this.noteswithAllocationPercentage);
    //}
    WorkflowDetailComponent.prototype.GetAllLookups = function () {
        var _this = this;
        this.dealSrv.getAllLookup().subscribe(function (res) {
            var data = res.lstLookups;
            _this.lstAllStatusByPurposeType = data.filter(function (x) { return x.ParentID == "77"; });
            _this.lstCheckListStatusType = data.filter(function (x) { return x.ParentID == "78"; });
            //set dropdown for
            // this._bindGridDropdows();
        });
    };
    WorkflowDetailComponent.prototype._bindGridDropdows = function () {
        var flexWFCheckList = this.flexWFCheckList;
        if (flexWFCheckList) {
            var colCheckListStatusType = flexWFCheckList.columns.getColumn('CheckListStatusText');
            if (colCheckListStatusType) {
                colCheckListStatusType.showDropDown = true;
                colCheckListStatusType.dataMap = this._buildDataMap(this.lstCheckListStatusType);
            }
        }
    };
    WorkflowDetailComponent.prototype._buildDataMap = function (items) {
        var map = [];
        for (var i = 0; i < items.length; i++) {
            var obj = items[i];
            map.push({ key: obj['LookupID'], value: obj['Name'] });
        }
        return new wjcGrid.DataMap(map, 'key', 'value');
    };
    WorkflowDetailComponent.prototype.getWorkFlowDetail = function (_workflow) {
        var _this = this;
        if (localStorage.getItem('divSucessWorkflow') == 'true') {
            this._Showmessagediv = true; //Vishal
            this._ShowmessagedivMsg = localStorage.getItem('divSucessMsgWorkflow');
            this._ShowmessagedivMsg = (this._ShowmessagedivMsg.replace('\"', '')).replace('\"', '');
            localStorage.setItem('divSucessWorkflow', JSON.stringify(false));
            localStorage.setItem('divSucessMsgWorkflow', JSON.stringify(''));
            setTimeout(function () {
                this._Showmessagediv = false;
            }.bind(this), 5000);
        }
        this._isWFFetching = true;
        this.wfSrv.GetWorkflowDetailByTaskId(_workflow).subscribe(function (res) {
            if (res.Succeeded) {
                if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                    _this._workflow = res.WFDetailDataContract;
                    if (_this._workflow.WorkFlowType == "WF_UNDERREVIEW") {
                        _this._isShowWorkActualWorkflow = false;
                        _this._isShowWorkflowWithoutValidationAndEmail = true;
                        _this._isShowDrawFee = false;
                    }
                    else {
                        _this._isShowWorkActualWorkflow = true;
                        _this._isShowWorkflowWithoutValidationAndEmail = false;
                        if (_this._workflow.TaskTypeID == 502) {
                            var checklistYes = res.WFDetailDataContract.WFCheckList.filter(function (x) { return x.CheckListMasterId == 6; })[0].CheckListStatusText;
                            //primary user of that deal will not be able to complete if team's approval checklist item is 'Yes' regardless of the amount
                            if (checklistYes == 'Yes' && _this._workflow.IsOnlyPrimaryUser == 1 && _this._workflow.NextStatusName == 'Completed') {
                                _this._IsTeamApproval = true;
                            }
                            var drawFeeApplicable = res.WFDetailDataContract.WFCheckList.filter(function (x) { return x.CheckListMasterId == 9; })[0].CheckListStatusText;
                            //primary user of that deal will not be able to complete if team's approval checklist item is 'Yes' regardless of the amount
                            if (drawFeeApplicable == 'Yes') {
                                _this._isShowDrawFee = true;
                            }
                        }
                        else if (_this._workflow.TaskTypeID == 719) {
                            _this.chkListTitle = "Reserve";
                            var checklistYes = res.WFDetailDataContract.WFCheckList.filter(function (x) { return x.CheckListMasterId == 15; })[0].CheckListStatusText;
                            var checklistPropertyManagerYes = res.WFDetailDataContract.WFCheckList.filter(function (x) { return x.CheckListMasterId == 17; })[0] != undefined ? res.WFDetailDataContract.WFCheckList.filter(function (x) { return x.CheckListMasterId == 17; })[0].CheckListStatusText : 'No';
                            //primary user of that deal will not be able to complete if team's approval checklist item is 'Yes' regardless of the amount
                            if (checklistYes == 'Yes' && _this._workflow.IsOnlyPrimaryUser == 1 && _this._workflow.NextStatusName == 'Completed') {
                                _this._IsTeamApproval = true;
                            }
                            if (checklistPropertyManagerYes == 'Yes') {
                                _this._isShowPropertyManager = true;
                            }
                        }
                    }
                    //this._CuurentWFStatusPurposeMappingID = this._workflow.WFStatusPurposeMappingID;
                    _this._wfAdditionalData = res.WFDetailDataContract.WFAdditionalList;
                    //this._wfuser = res.WFDetailDataContract.User;
                    if (_this._wfAdditionalData.BaseCurrencyName == "USD") {
                        _this._basecurrencyname = '$';
                    }
                    else {
                        _this._basecurrencyname = '£';
                    }
                    _this.wfRequiredEquity = _this.formatNumberforTwoDecimalplaces(_this.GetDefaultValue(_this._wfAdditionalData.RequiredEquity));
                    _this.wfAdditionalEquity = _this.formatNumberforTwoDecimalplaces(_this.GetDefaultValue(_this._wfAdditionalData.AdditionalEquity));
                    _this._workflow.DealName = _this._wfAdditionalData.DealName;
                    _this._workflow.DrawComment = _this._wfAdditionalData.Comment;
                    _this._isShowPreliminary = _this._wfAdditionalData.IsPreliminaryNotification;
                    _this._isShowRevisedPreliminary = _this._wfAdditionalData.IsRevisedPreliminaryNotification;
                    _this._isShowFinal = _this._wfAdditionalData.IsFinalNotification;
                    _this._isShowRevisedFinal = _this._wfAdditionalData.IsRevisedFinalNotification;
                    _this._isShowFinalPayOff = _this._wfAdditionalData.IsFinalNotificationPayOff;
                    _this._isShowRevisedFinalPayOff = _this._wfAdditionalData.IsRevisedFinalNotificationPayOff;
                    _this._isShowServicer = _this._wfAdditionalData.IsServicerNotification;
                    _this._isShowRevisedServicer = _this._wfAdditionalData.IsRevisedServicerNotification;
                    _this._wfCheckListData = res.WFDetailDataContract.WFCheckList;
                    _this._wfStatusData = res.WFDetailDataContract.WFStatusList;
                    _this._workflow.AdditionalComments = _this._wfAdditionalData.AdditionalComments;
                    _this._workflow.SpecialInstructions = _this._wfAdditionalData.SpecialInstructions;
                    _this._workflow.PropertyManagerEmail = _this._wfAdditionalData.PropertyManagerEmail;
                    // sepecial instruction default text functionality
                    if (_this._workflow.PurposeTypeId == 520) {
                        //var defaultSpecialInstructions= "";
                        if (_this._wfAdditionalData.SeniorServicerName != '' && _this._wfAdditionalData.SeniorServicerName != null) {
                            _this.defaultSpecialInstructions = "Wire these funds to the Servicer (" + _this._wfAdditionalData.SeniorServicerName + ") per wire instructions on file.\n" +
                                "Funds should be directed to Loan #" + _this._wfAdditionalData.SeniorCreNoteID + " – Project Expenditure Reserve.";
                        }
                        if (_this._workflow.SpecialInstructions == '' || _this._workflow.SpecialInstructions == null) {
                            _this._workflow.SpecialInstructions = _this.defaultSpecialInstructions;
                        }
                        //this._workflow.SpecialInstructions = this._workflow.SpecialInstructions.replace(/^\s+|\s+$/g, '');
                    }
                    var statuslist = res.WFDetailDataContract.WFStatusList;
                    _this._CuurentWFStatusPurposeMappingID = statuslist.filter(function (x) { return x.StatusName == _this._workflow.StatusName; })[0].WFStatusPurposeMappingID;
                    _this.cvwfCheckListData = new wjcCore.CollectionView(_this._wfCheckListData);
                    _this.cvwfCheckListData.trackChanges = true;
                    _this.lstRejectList = res.lstRejectList;
                    _this._workflow.WFCheckList = res.WFDetailDataContract.WFCheckList;
                    _this._workflow.StatusDisplayNameWithFormat = _this.FormatWFStatusName(_this._workflow.StatusDisplayName);
                    if (_this._RevisedFinal && _this._workflow.StatusName.toLowerCase() == 'completed') {
                        _this._workflow.StatusDisplayNameWithFormat = 'Completed';
                    }
                    if (_this._workflow.NextStatusDisplayName !== undefined && _this._workflow.NextStatusDisplayName != null) {
                        _this._workflow.NextStatusDisplayNameWithFormat = _this.FormatWFStatusName(_this._workflow.NextStatusDisplayName);
                    }
                    _this.GetWFCommentsByTaskId(_workflow);
                    for (var i = 0; i < _this._workflow.WFCheckList.length; i++) {
                        if (_this._workflow.WFCheckList[i].IsMandatory == true) {
                            _this._workflow.WFCheckList[i].CheckListName = _this._workflow.WFCheckList[i].CheckListName; //+ '<b><span [ngStyle]="{color: red}">*</span></b>';
                        }
                    }
                    for (var i = 0; i < _this.lstRejectList.length; i++) {
                        _this.lstRejectList[i].StatusDisplayName = _this.FormatWFStatusName(_this.lstRejectList[i].StatusDisplayName);
                    }
                    if (_this._wfAdditionalData.BoxDocumentLink != null && _this._wfAdditionalData.BoxDocumentLink != '') {
                        _this._isShowDownloadDoc = true;
                    }
                    else {
                        _this._isShowDownloadDoc = false;
                    }
                    _this._wfamount = parseFloat(_this._wfAdditionalData.Amount);
                    if (Math.sign(_this._wfamount) == -1) {
                        var _amount = -1 * _this._wfamount;
                        _this._totalfundingamount = "-$" + _amount.toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
                    }
                    else
                        _this._totalfundingamount = "$" + _this._wfamount.toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
                    if (_this._workflow.wf_isAllow == 0) {
                        _this.HideButton();
                    }
                    else {
                        _this._isShowbtnApproval = true;
                        //this._isShowbtnRejected = true;
                        _this._isShowbtnSaveDraft = true;
                    }
                    if (_this._workflow.wf_isAllowReject == 0 || _this.lstRejectList.length == 0) {
                        _this._isShowbtnRejected = false;
                    }
                    else {
                        _this._isShowbtnRejected = true;
                    }
                    if (_this._workflow.StatusName == "Projected") {
                        _this._wfNotificationDetail.WFNotificationMasterID = 1;
                    }
                    //get notification config-- WFNotificationMasterID not being used in below functions
                    _this.getWFNotificationConfigByNotificationType(_this._wfNotificationDetail.WFNotificationMasterID);
                    _this.getTemplateRecipientEmailIDs(_this._wfNotificationDetail.WFNotificationMasterID);
                    if (_this._workflow.TaskTypeID == 502) {
                        _this.GetDealFundingByDealID();
                        //commented on 20 march 2020 by shahid as we need to discuss the rouding rule
                        _this.GetNoteAllocationPercentage();
                        //
                        _this.getAllStatesMaster();
                        _this.GetDrawFeeInvoiceDetailByTaskID();
                        if (_this._workflow.WorkFlowType == "WF_UNDERREVIEW" && _this._workflow.PurposeTypeId == 630) {
                            _this._isShowPayOffFields = true;
                            _this.GetWFPayOffNoteFunding();
                        }
                    }
                    else if (_this._workflow.TaskTypeID == 719) {
                        _this.GetReserveScheduleBreakDown();
                    }
                    //alert(JSON.stringify(res.WFDetailDataContract))
                    //alert(JSON.stringify(this._workflow))
                }
                else {
                    localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                    localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));
                    _this.utilityService.navigateUnauthorize();
                }
                //console.log(this._workflow);
                _this._isWFFetching = false;
                //////////////////Check list dropdown bind///////////////////
                //add line_id to aid in the filter  
                if (_this._workflow.WorkFlowType == "WF_UNDERREVIEW") {
                    _this.r1Data = [
                        {
                            "line_id": 1,
                            "LookupID": 499,
                            "Name": "Yes"
                        },
                        {
                            "line_id": 1,
                            "LookupID": 616,
                            "Name": "No"
                        }
                    ];
                }
                else {
                    _this.r1Data = [
                        {
                            "line_id": 1,
                            "LookupID": 499,
                            "Name": "Yes"
                        },
                        {
                            "line_id": 1,
                            "LookupID": 500,
                            "Name": "Waived"
                        },
                        {
                            "line_id": 1,
                            "LookupID": 501,
                            "Name": "N/A"
                        },
                        {
                            "line_id": 1,
                            "LookupID": 550,
                            "Name": "Pending"
                        }
                    ];
                }
                _this.r2Data = [
                    {
                        "line_id": 2,
                        "LookupID": 499,
                        "Name": "Yes"
                    },
                    {
                        "line_id": 2,
                        "LookupID": 616,
                        "Name": "No"
                    }
                ];
                //let combinedMapData = [...this.r1Data, ...this.r2Data, ...this.r3Data, ...this.r4Data, ...this.r5Data, ...this.r6Data];
                var combinedMapData_1 = __spreadArrays(_this.r1Data, _this.r2Data);
                _this.dataMap = new wjcGrid.DataMap(combinedMapData_1, 'LookupID', 'Name');
                _this.dataMap.getDisplayValues = (function (item) {
                    if (!item) {
                        return combinedMapData_1.map(function (item) { return item.Name; });
                    }
                    var x = combinedMapData_1.filter(function (cItem) {
                        if (cItem.line_id == item.RowId) {
                            return true;
                        }
                        else if (cItem.line_id == 1 && item.RowId != 1 && item.RowId != 2) {
                            return true;
                        }
                        return false;
                    }).map(function (item) { return item.Name; });
                    return x;
                });
                var flexWFCheckList = _this.flexWFCheckList;
                if (flexWFCheckList) {
                    var colCheckListStatusType = flexWFCheckList.columns.getColumn('CheckListStatusText');
                    if (colCheckListStatusType) {
                        colCheckListStatusType.showDropDown = true;
                        colCheckListStatusType.dataMap = _this.dataMap; //this._buildDataMap(this.lstCheckListStatusType);
                    }
                }
                _this.cvwfCheckListData.newItemCreator = function () {
                    return {
                        CheckListName: '',
                        Status: this.r1Data,
                        Comment: '',
                        RowID: 1
                    };
                };
            }
            else {
                _this._router.navigate(['login']);
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    WorkflowDetailComponent.prototype.init = function (flexgrid) {
        //some initializzation work for grid
        flexgrid.formatItem.addHandler(function (s, e) {
            //if (e.panel.cellType != wjcGrid.CellType.Cell) {
            //    return;
            //}
            if (e.panel.columns[e.col].binding == "CheckListStatusText") {
                var item = e.panel.rows[e.row].dataItem;
                if (item !== undefined) {
                    if (item.IsDisable == true) {
                        wjcCore.addClass(e.cell, 'disable-col');
                    }
                }
            }
        });
    };
    WorkflowDetailComponent.prototype.cellEditbeginCheckList = function (s, e) {
        if (e.col.toString() == "1") {
            if (this.cvwfCheckListData._view !== undefined) {
                if (this._workflow.IsDisableFundingTeamApproval == 1 && (this.cvwfCheckListData._view[e.row].CheckListMasterId == 6 || this.cvwfCheckListData._view[e.row].CheckListMasterId == 15)) {
                    e.cancel = true;
                }
                if (this._drawFeeInvoice.DrawFeeStatus != 692 && this._drawFeeInvoice.DrawFeeStatus != 0 && this.cvwfCheckListData._view[e.row].CheckListMasterId == 9) {
                    e.cancel = true;
                }
            }
        }
    };
    WorkflowDetailComponent.prototype.cellEditEndedChecklist = function (s, e) {
        if (e.col.toString() == "1") {
            //any AM can do till first approval so no need to check anything in that case
            if (this.cvwfCheckListData._view !== undefined && this._workflow.WFStatusMasterID > 2) {
                if ((this.cvwfCheckListData._view[e.row].CheckListMasterId == 6 || this.cvwfCheckListData._view[e.row].CheckListMasterId == 15) && this.cvwfCheckListData._view[e.row].CheckListStatusText == "499"
                    && this._workflow.IsOnlyPrimaryUser == 1 && this._workflow.NextStatusName == 'Completed') {
                    this._IsTeamApproval = true;
                }
                else {
                    this._IsTeamApproval = false;
                }
            }
            if (this.cvwfCheckListData._view !== undefined) {
                if (this.cvwfCheckListData._view[e.row].CheckListMasterId == 9) {
                    if (this.cvwfCheckListData._view[e.row].CheckListStatusText == "499") {
                        this._isShowDrawFee = true;
                        if (this.IsDrawFeeEditClick == true)
                            this.enableDrawSection();
                        else {
                            setTimeout(function () {
                                this.enableDisableDrawFeeSection();
                            }.bind(this), 1000);
                        }
                    }
                    else
                        this._isShowDrawFee = false;
                }
                if (this.cvwfCheckListData._view[e.row].CheckListMasterId == 17) {
                    if (this.cvwfCheckListData._view[e.row].CheckListStatusText == "499") {
                        this._isShowPropertyManager = true;
                    }
                    else
                        this._isShowPropertyManager = false;
                }
            }
        }
    };
    WorkflowDetailComponent.prototype.CheckWireConfirmedOnReject = function () {
        var _this = this;
        this._isWFFetching = true;
        this.wfSrv.GetWorkflowAdditionalDetailByTaskId(this._workflow).subscribe(function (res) {
            if (res.Succeeded) {
                var _additionalData = res.WFDetailDataContract.WFAdditionalList;
                if (_additionalData.Applied == true) {
                    _this._isWFFetching = false;
                    var msg = "";
                    msg = "<p>You can not reject the draw which is already wireconfirmed.";
                    _this.savedialogmsg = msg;
                    _this.CustomDialogteSave();
                }
                else {
                    if (_this._workflow.WorkFlowType == "WF_UNDERREVIEW")
                        _this.SaveWorkFlowWithoutEmail();
                    else
                        _this.SaveWorkFlow();
                }
            }
            else {
                _this._router.navigate(['login']);
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    WorkflowDetailComponent.prototype.convertDateToBindable = function (date) {
        var dateObj = new Date(date);
        var mlist = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        var days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
        return days[dateObj.getDay()] + ", " + mlist[dateObj.getMonth()] + " " + this.AsOrdinal(dateObj.getDate()) + ", " + dateObj.getFullYear();
    };
    WorkflowDetailComponent.prototype.convertDateTime = function (date) {
        var dateObj = new Date(date);
        var ampm = dateObj.getHours() >= 12 ? 'PM' : 'AM';
        var mlist = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        var days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
        return days[dateObj.getDay()] + ", " + mlist[dateObj.getMonth()] + " " + this.AsOrdinal(dateObj.getDate()) + ", " + dateObj.getFullYear() + " " + dateObj.getHours() + ":" + dateObj.getMinutes() + ":" + dateObj.getSeconds() + " " + ampm;
    };
    WorkflowDetailComponent.prototype.convertDateTimeIn12Hours = function (date) {
        var dateObj = new Date(date);
        var mlist = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        var days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
        var hours = dateObj.getHours() == 0 ? "12" : dateObj.getHours() > 12 ? dateObj.getHours() - 12 : dateObj.getHours();
        var minutes = (dateObj.getMinutes() < 10 ? "0" : "") + dateObj.getMinutes();
        var ampm = dateObj.getHours() < 12 ? "AM" : "PM";
        return days[dateObj.getDay()] + ", " + mlist[dateObj.getMonth()] + " " + this.AsOrdinal(dateObj.getDate()) + ", " + dateObj.getFullYear() + " " + hours + ":" + minutes + " " + ampm;
    };
    WorkflowDetailComponent.prototype.convertDateTOMMDDYYYY = function (date) {
        var dateObj = new Date(date);
        var ampm = dateObj.getHours() >= 12 ? 'PM' : 'AM';
        var mlist = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        var days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
        //return dateObj.getMonth() + "/" + dateObj.getDate() + "/" + dateObj.getFullYear();
        return ("0" + (dateObj.getMonth() + 1)).slice(-2) + "/" + ("0" + dateObj.getDate()).slice(-2) + "/" + dateObj.getFullYear();
    };
    WorkflowDetailComponent.prototype.AsOrdinal = function (number) {
        var work = number;
        work = work.toString();
        var modOf100 = number % 100;
        if (modOf100 == 11 || modOf100 == 12 || modOf100 == 13)
            return work + "th";
        switch (number % 10) {
            case 1:
                work += "st";
                break;
            case 2:
                work += "nd";
                break;
            case 3:
                work += "rd";
                break;
            default:
                work += "th";
                break;
        }
        return work;
    };
    WorkflowDetailComponent.prototype.getTwoDigitString = function (number) {
        if (number.toString().length === 1)
            return "0" + number;
        return number;
    };
    WorkflowDetailComponent.prototype.SaveWorkFlow = function () {
        var _this = this;
        this._workflow.WFAdditionalList = null;
        this.IsShowSaveAndStatusButton = false;
        //Promise.all(this.saveDrawFeeInvoice()).then(() => { }).catch(() => { });
        this._workflow.CREDealID = this._wfAdditionalData.CREDealID;
        this.wfSrv.SaveWorkflowDetailByTaskId(this._workflow).subscribe(function (res) {
            if (res.Succeeded) {
                if (parseFloat(_this._wfAdditionalData.Amount) > 0) {
                    if (_this._workflow.StatusName == 'Projected' && _this._workflow.SubmitType == 498) {
                        var notification_type = _this._isShowRevisedPreliminary == true ? _this._RevisedPreliminary : _this._Preliminary;
                        _this.GetWFCommentsByTaskIdOnNotification(_this._workflow, notification_type);
                        //this.showWFNotificationDialog(this._Preliminary);
                        _this.IsShowSaveAndStatusButton = true;
                        _this._isWFFetching = false;
                    }
                    else if (_this._workflow.NextStatusName == 'Completed' && _this._workflow.SubmitType == 498) {
                        var notification_type = _this._isShowRevisedFinal == true ? _this._RevisedFinal : _this._Final;
                        _this.GetWFCommentsByTaskIdOnNotification(_this._workflow, notification_type);
                        // this.showWFNotificationDialog(this._Final);
                        _this.IsShowSaveAndStatusButton = true;
                        _this._isWFFetching = false;
                    }
                    //else if (this.rolename == 'Asset Manager' && this.IsSaveClick == true && this._isShowDrawFee == true && (this._drawFeeInvoice.DrawFeeStatus == 0 || this._drawFeeInvoice.DrawFeeStatus == 692 || this._drawFeeInvoice.DrawFeeStatus == 696)) {
                    //    this._isShowinvoicesaveMsg = true;
                    //    this.saveDrawFeeInvoice();
                    //    this.IsSaveClick = false;
                    //}
                    else {
                        if (_this.IsSaveClick == true) {
                            var workflowURL;
                            if (window.location.href.indexOf("workflowdetail/a") > -1) {
                                workflowURL = ['workflowdetail', _this._workflow.TaskID, _this._workflow.TaskTypeID];
                            }
                            else {
                                workflowURL = ['workflowdetail/a', _this._workflow.TaskID, _this._workflow.TaskTypeID];
                            }
                            _this._isWFFetching = false;
                            localStorage.setItem('divSucessWorkflow', 'true');
                            localStorage.setItem('divSucessMsgWorkflow', 'Draw approval status updated successfully');
                            _this._router.navigate(workflowURL);
                        }
                        else {
                            var notenewcopied;
                            if (window.location.href.indexOf("dealdetail/a") > -1) {
                                notenewcopied = ['dealdetail', _this._wfAdditionalData.CREDealID];
                            }
                            else {
                                notenewcopied = ['dealdetail/a', _this._wfAdditionalData.CREDealID];
                            }
                            localStorage.setItem('ClickedTabId', 'aFunding');
                            localStorage.setItem('divSucessDeal', 'true');
                            localStorage.setItem('divSucessMsgDeal', 'Draw approval status updated successfully');
                            _this._router.navigate(notenewcopied);
                        }
                    }
                }
                else {
                    var notenewcopied;
                    if (window.location.href.indexOf("dealdetail/a") > -1) {
                        notenewcopied = ['dealdetail', _this._wfAdditionalData.CREDealID];
                    }
                    else {
                        notenewcopied = ['dealdetail/a', _this._wfAdditionalData.CREDealID];
                    }
                    localStorage.setItem('ClickedTabId', 'aFunding');
                    localStorage.setItem('divSucessDeal', 'true');
                    localStorage.setItem('divSucessMsgDeal', 'Draw approval status updated successfully');
                    _this._router.navigate(notenewcopied);
                }
            }
            else {
                _this._router.navigate(['login']);
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    WorkflowDetailComponent.prototype.SaveWorkFlowWithoutEmail = function () {
        var _this = this;
        // this.showWFNotificationDialog(this._Preliminary);
        this._workflow.WFAdditionalList = null;
        this.wfSrv.SaveWorkflowDetailByTaskId(this._workflow).subscribe(function (res) {
            if (res.Succeeded) {
                var notenewcopied;
                //payoff email functionality
                if (_this._workflow.NextStatusName == 'Completed' && _this._workflow.SubmitType == 498
                    && _this._workflow.PurposeTypeId == 630) {
                    var notification_type = _this._FinalWithoutApproval;
                    _this.showWFNotificationDialogForNegativeAmt(notification_type);
                    _this._isWFFetching = false;
                }
                else {
                    if (window.location.href.indexOf("dealdetail/a") > -1) {
                        notenewcopied = ['dealdetail', _this._wfAdditionalData.CREDealID];
                    }
                    else {
                        notenewcopied = ['dealdetail/a', _this._wfAdditionalData.CREDealID];
                    }
                    localStorage.setItem('ClickedTabId', 'aFunding');
                    localStorage.setItem('divSucessDeal', 'true');
                    localStorage.setItem('divSucessMsgDeal', 'Draw approval status updated successfully');
                    _this._router.navigate(notenewcopied);
                    _this._isWFFetching = false;
                }
            }
            else {
                _this._router.navigate(['login']);
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    WorkflowDetailComponent.prototype.saveWorkFlowDetailWithoutEmail = function (newvalue, btnType) {
        this._isRefresh = true;
        this._isNotificationMsg = false;
        this._isWFFetching = true;
        this._isPayOffNotifyClick = false;
        if (btnType == 'Rejected') {
            this._workflow.SubmitType = 496;
            var selectedText = newvalue.target.className;
            selectedText = selectedText.trim();
            var newWFStatusPurposeMappingID = this.lstRejectList.filter(function (x) { return x.StatusName == selectedText; })[0].WFStatusPurposeMappingID;
            this._workflow.WFStatusPurposeMappingID = newWFStatusPurposeMappingID;
            this.CheckWireConfirmedOnReject();
            //this.SaveWorkFlowWithoutEmail();
            return;
        }
        else if (btnType == 'Draft') {
            this._workflow.SubmitType = 497;
            this._workflow.WFStatusPurposeMappingID = this._CuurentWFStatusPurposeMappingID;
        }
        else if (btnType == 'Save') {
            this._workflow.SubmitType = 551;
            this._workflow.WFStatusPurposeMappingID = this._CuurentWFStatusPurposeMappingID;
        }
        else {
            this._workflow.SubmitType = 498;
            this._workflow.WFStatusPurposeMappingID = this._workflow.NextWFStatusPurposeMappingID;
        }
        for (var i = 0; i < this._workflow.WFCheckList.length; i++) {
            if (!(Number(this._workflow.WFCheckList[i].CheckListStatusText).toString() == "NaN" || Number(this._workflow.WFCheckList[i].CheckListStatusText) == 0)) {
                this._workflow.WFCheckList[i].CheckListStatus = Number(this._workflow.WFCheckList[i].CheckListStatusText);
            }
        }
        if (this.IsValidateWithoutEmail(btnType)) {
            this.SaveWorkFlowWithoutEmail();
        }
        else {
            this._isWFFetching = false;
            this.CustomDialogteSave();
        }
    };
    WorkflowDetailComponent.prototype.IsValidateWithoutEmail = function (btnType) {
        var retvalue = true;
        var msg = "";
        var lookupidForYes = this.lstCheckListStatusType.filter(function (x) { return x.Name.toString().toLowerCase() === 'yes'; })[0].LookupID;
        if (this._wfAdditionalData.Comment == undefined || this._wfAdditionalData.Comment == '') {
            retvalue = false;
            msg = "<p>Draw Number is mandatory for draw approval process.";
            this.savedialogmsg = msg;
            return retvalue;
        }
        var chkListWithMandatoryFields = this._workflow.WFCheckList;
        for (var i = 0; i < chkListWithMandatoryFields.length; i++) {
            if (chkListWithMandatoryFields[i].hasOwnProperty('CheckListName') == false) {
                this._workflow.WFCheckList[i].CheckListName = '';
            }
            if (chkListWithMandatoryFields[i].hasOwnProperty('CheckListStatusText') == false) {
                this._workflow.WFCheckList[i].CheckListStatusText = '';
            }
            if (chkListWithMandatoryFields[i].hasOwnProperty('Comment') == false) {
                this._workflow.WFCheckList[i].Comment = '';
            }
        }
        //Check list name required
        var blankChklist = this._workflow.WFCheckList.filter(function (x) { return x.CheckListName.trim() === '' && (x.CheckListStatusText != '' || x.Comment != ''); });
        if (blankChklist.length > 0) {
            retvalue = false;
            msg = "<p>Check list name should not be blank.";
            this.savedialogmsg = msg;
            return retvalue;
        }
        if (btnType != 'Draft' && btnType != 'Save') {
            if (this._workflow.StatusName == "Projected") {
                for (var i = 0; i < chkListWithMandatoryFields.length; i++) {
                    if (chkListWithMandatoryFields[i].CheckListMasterId == 7) {
                        if (Number(chkListWithMandatoryFields[i].CheckListStatus).toString() != lookupidForYes) {
                            retvalue = false;
                            msg = "<p>" + chkListWithMandatoryFields[i].CheckListName + " should be marked as YES for requested status.";
                        }
                    }
                    if (chkListWithMandatoryFields[i].CheckListMasterId == 8) {
                        if (Number(chkListWithMandatoryFields[i].CheckListStatus).toString() == lookupidForYes) {
                            retvalue = false;
                            msg = msg + "<p>" + chkListWithMandatoryFields[i].CheckListName + " should not be marked as YES for requested status.";
                        }
                    }
                }
            }
            else if (this._workflow.wfFlag == 'FinalState') {
                for (var i = 0; i < chkListWithMandatoryFields.length; i++) {
                    if (Number(chkListWithMandatoryFields[i].CheckListStatus).toString() != lookupidForYes) {
                        retvalue = false;
                        msg = "<p>All checklist items should be marked as YES for completed status.";
                        break;
                    }
                }
                var todaysdate = new Date();
                var wcDate = new Date(this._wfAdditionalData.Date);
                if (wcDate > todaysdate) {
                    retvalue = false;
                    msg = msg + "<p>" + "Funding date should not be greater than today's date." + "</p>";
                }
                if (this._workflow.PurposeTypeId == 630) {
                    if (this._workflow.PrepayPremium == null || this._workflow.PrepayPremium == undefined) {
                        retvalue = false;
                        msg = msg + "<p>Prepayment Premium cannot be Blank." + "</p>";
                    }
                    else if (this._workflow.PrepayPremium < 0) {
                        retvalue = false;
                        msg = msg + "<p>Prepayment Premium cannot be Negative." + "</p>";
                    }
                    if (this._workflow.ExitFee == null || this._workflow.ExitFee == undefined) {
                        retvalue = false;
                        msg = msg + "<p>Exit Fee cannot be Blank." + "</p>";
                    }
                    else if (this._workflow.ExitFee < 0) {
                        retvalue = false;
                        msg = msg + "<p>Exit Fee cannot be Negative." + "</p>";
                    }
                    if (this._workflow.ExitFeePercentage == null || this._workflow.ExitFeePercentage == undefined) {
                        retvalue = false;
                        msg = msg + "<p>Exit Fee Percentage cannot be Blank." + "</p>";
                    }
                    else if (this._workflow.ExitFeePercentage < 0) {
                        retvalue = false;
                        msg = msg + "<p>Exit Fee Percentage cannot be Negative." + "</p>";
                    }
                }
            }
        }
        this.savedialogmsg = msg;
        return retvalue;
    };
    WorkflowDetailComponent.prototype.ValidateWireConfirmAndsaveWorkFlowDetail = function (newvalue, btnType) {
        var _this = this;
        var retvalue = true;
        var msg = "";
        this._isPayOffNotifyClick = false;
        if (this._workflow.NextStatusName == 'Completed' && btnType == 'Approved' && this._workflow.TaskTypeID == 502) {
            this.wfSrv.ValidateWireConfirmByTaskId(this._workflow).subscribe(function (res) {
                if (res.Succeeded) {
                    var today = new Date();
                    var wcDate = new Date(_this._wfAdditionalData.Date);
                    var nextbdate = _this.getnextbusinessDate(today, 10, true);
                    if (res.StatusCode != 0) {
                        if (res.StatusCode == 1) {
                            retvalue = false;
                            msg = "<p>You can't confirm wire on a later date without confirming all wires in between.";
                        }
                    }
                    if (wcDate > nextbdate && _this._workflow.WorkFlowType == "WF_FUll") {
                        retvalue = false;
                        msg = msg + "<p>You can only confirm up to " + _this.convertDateToBindable(nextbdate) + ".";
                    }
                    if ((_this._drawFeeInvoice === undefined || _this._drawFeeInvoice.DrawFeeInvoiceDetailID == 0) && _this._workflow.WorkFlowType == "WF_FUll" && _this._isShowDrawFee == true) {
                        retvalue = false;
                        msg = msg + "<p>Please save invoice detail before you proceed.";
                    }
                    if (msg != '') {
                        _this.savedialogmsg = msg;
                        _this.CustomDialogteSave();
                    }
                    else {
                        if (_this._workflow.WorkFlowType == "WF_UNDERREVIEW") {
                            _this.saveWorkFlowDetailWithoutEmail(newvalue, btnType);
                        }
                        else {
                            _this.saveWorkFlowDetail(newvalue, btnType);
                        }
                    }
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
            (function (error) { return console.error('Error: ' + error); });
        }
        else if (this._workflow.WorkFlowType == "WF_UNDERREVIEW") {
            this.saveWorkFlowDetailWithoutEmail(newvalue, btnType);
        }
        else {
            this.saveWorkFlowDetail(newvalue, btnType);
        }
    };
    WorkflowDetailComponent.prototype.ValidateWireConfirmOnNotify = function (notificatioType) {
        var _this = this;
        var retvalue = true;
        var msg = "";
        if (this._workflow.TaskTypeID == 502) {
            if ((notificatioType == this._Final || notificatioType == this._RevisedFinal) && this._workflow.StatusName == 'Completed') {
                this.wfSrv.ValidateWireConfirmByTaskId(this._workflow).subscribe(function (res) {
                    if (res.Succeeded) {
                        var today = new Date();
                        var wcDate = new Date(_this._wfAdditionalData.Date);
                        var nextbdate = _this.getnextbusinessDate(today, 10, true);
                        if (res.StatusCode != 0) {
                            if (res.StatusCode == 1) {
                                retvalue = false;
                                msg = "<p>You can't confirm wire on a later date without confirming all wires in between.";
                            }
                        }
                        if (wcDate > nextbdate) {
                            retvalue = false;
                            msg = msg + "<p>You can only confirm up to " + _this.convertDateToBindable(nextbdate) + ".";
                        }
                        if (msg != '') {
                            _this.savedialogmsg = msg;
                            _this.CustomDialogteSave();
                        }
                        else {
                            _this.Notify(notificatioType);
                        }
                    }
                    else {
                        _this._router.navigate(['login']);
                    }
                });
                (function (error) { return console.error('Error: ' + error); });
            }
            else if ((notificatioType == this._Final || notificatioType == this._RevisedFinal) && this._workflow.StatusName != 'Completed') {
                msg = msg + "<p>You need to mark the draw as completed before sending revised final notification.";
                this.savedialogmsg = msg;
                this.CustomDialogteSave();
            }
            else {
                this.Notify(notificatioType);
            }
        }
        else if (this._workflow.TaskTypeID == 719) //reserve workflow
         {
            this.Notify(notificatioType);
        }
    };
    WorkflowDetailComponent.prototype.ValidateWireConfirmNegativAmtOnNotify = function (notificatioType) {
        var _this = this;
        this._isPayOffNotifyClick = true;
        var retvalue = true;
        var msg = "";
        if (this._workflow.TaskTypeID == 502) {
            if ((notificatioType == this._FinalWithoutApproval || notificatioType == this._RevisedFinalWithoutApproval) && this._workflow.StatusName == 'Completed') {
                this.wfSrv.ValidateWireConfirmByTaskId(this._workflow).subscribe(function (res) {
                    if (res.Succeeded) {
                        var today = new Date();
                        var wcDate = new Date(_this._wfAdditionalData.Date);
                        var nextbdate = _this.getnextbusinessDate(today, 10, true);
                        if (res.StatusCode != 0) {
                            if (res.StatusCode == 1) {
                                retvalue = false;
                                msg = "<p>You can't confirm wire on a later date without confirming all wires in between.";
                            }
                        }
                        if (msg != '') {
                            _this.savedialogmsg = msg;
                            _this.CustomDialogteSave();
                        }
                        else {
                            _this.Notify(notificatioType);
                        }
                    }
                    else {
                        _this._router.navigate(['login']);
                    }
                });
                (function (error) { return console.error('Error: ' + error); });
            }
            else if ((notificatioType == this._FinalWithoutApproval || notificatioType == this._RevisedFinalWithoutApproval) && this._workflow.StatusName != 'Completed') {
                msg = msg + "<p>You need to mark the draw as completed before sending revised final notification.";
                this.savedialogmsg = msg;
                this.CustomDialogteSave();
            }
            else {
                this.Notify(notificatioType);
            }
        }
    };
    WorkflowDetailComponent.prototype.getnexybusinessDate = function (sDate, noofDays) {
        var daycnt = sDate.getDay();
        if (daycnt == 6)
            sDate.setDate(sDate.getDate() + 1);
        if (daycnt == 1 || daycnt == 2 || daycnt == 3 || daycnt == 4 || daycnt == 5)
            sDate.setDate(sDate.getDate() + 2);
        sDate.setDate(sDate.getDate() + noofDays);
        return sDate;
    };
    WorkflowDetailComponent.prototype.getnextbusinessDate = function (sDate, noofDays, addorsub) {
        var _this = this;
        if (sDate) {
            var i = 0;
            while (i < Math.abs(noofDays)) {
                // for (var i = 1; i < Math.abs(noofDays); i++) {
                var daycnt = sDate.getDay();
                var formateddate = this.convertDateToBindable(sDate);
                if (addorsub == true) {
                    if (daycnt == 6 || daycnt == 0
                        || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411; }).length > 0) {
                        sDate.setDate(sDate.getDate() + 1);
                    }
                    if (daycnt == 1 || daycnt == 2 || daycnt == 3 || daycnt == 4 || daycnt == 5) {
                        sDate.setDate(sDate.getDate() + 1);
                        i++;
                    }
                    //  sDate.setDate(sDate.getDate() + 1);
                }
                else {
                    if (daycnt == 6 || daycnt == 0
                        || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411; }).length > 0) {
                        sDate.setDate(sDate.getDate() - 1);
                        // i--;
                    }
                    else {
                        sDate.setDate(sDate.getDate() - 1);
                        i++;
                    }
                }
            }
        }
        //
        for (var j = 0; j < 7; j++) {
            formateddate = this.convertDateToBindable(sDate);
            var daycnt = sDate.getDay();
            if (daycnt == 6 || daycnt == 0
                || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411; }).length > 0) {
                sDate.setDate(sDate.getDate() - 1);
            }
            else
                return sDate;
        }
        return sDate;
    };
    WorkflowDetailComponent.prototype.GetHolidayList = function () {
        var _this = this;
        if (this.ListHoliday == null || this.ListHoliday === undefined)
            this.dealSrv.getHolidayList().subscribe(function (res) {
                if (res.Succeeded) {
                    _this.ListHoliday = res.HolidayList;
                }
                else
                    _this.ListHoliday = null;
            });
    };
    WorkflowDetailComponent.prototype.saveWorkFlowDetail = function (newvalue, btnType) {
        this._isRefresh = true;
        this._isNotificationMsg = false;
        this._isWFFetching = true;
        this.clickButtonType = btnType;
        this._isPayOffNotifyClick = false;
        if (this.commentHistory != '') {
            this._workflow.ActivityLog = "<b>Activity log are below:</b><br/>" + this.commentHistory;
        }
        this._workflow.FooterText = "Thank you,<br/>" + this._user.FirstName + ' ' + this._user.LastName + '<br/>' + this._user.Email + ((this._user.ContactNo1 != '' && this._user.ContactNo1 != null) ? ' | ' + this._user.ContactNo1 : '');
        this._workflow.SenderName = this._user.FirstName + ' ' + this._user.LastName;
        this._workflow.WFCheckListStatus = this.lstCheckListStatusType;
        if (btnType == 'Rejected') {
            this._workflow.SubmitType = 496;
            var selectedText = newvalue.target.className;
            selectedText = selectedText.trim();
            var newWFStatusPurposeMappingID = this.lstRejectList.filter(function (x) { return x.StatusName == selectedText; })[0].WFStatusPurposeMappingID;
            this._workflow.WFStatusPurposeMappingID = newWFStatusPurposeMappingID;
            this.CheckWireConfirmedOnReject();
            //this.SaveWorkFlow();
            return;
        }
        else if (btnType == 'Draft') {
            this._workflow.SubmitType = 497;
            this._workflow.WFStatusPurposeMappingID = this._CuurentWFStatusPurposeMappingID;
        }
        else if (btnType == 'Save') {
            this._workflow.SubmitType = 551;
            this._workflow.WFStatusPurposeMappingID = this._CuurentWFStatusPurposeMappingID;
            this.IsSaveClick = true;
        }
        else {
            this._workflow.SubmitType = 498;
            this._workflow.WFStatusPurposeMappingID = this._workflow.NextWFStatusPurposeMappingID;
        }
        for (var i = 0; i < this._workflow.WFCheckList.length; i++) {
            if (!(Number(this._workflow.WFCheckList[i].CheckListStatusText).toString() == "NaN" || Number(this._workflow.WFCheckList[i].CheckListStatusText) == 0)) {
                this._workflow.WFCheckList[i].CheckListStatus = Number(this._workflow.WFCheckList[i].CheckListStatusText);
            }
        }
        if (this.IsValidate(btnType)) {
            if (this.rolename == 'Asset Manager' && (btnType == 'Save' || btnType == "Approved") && this._isShowDrawFee == true &&
                (this._drawFeeInvoice.DrawFeeStatus == 0 || this._drawFeeInvoice.DrawFeeStatus == 692 || this._drawFeeInvoice.DrawFeeStatus == 696)) {
                this.saveDrawFeeInvoiceAndWorkFlow();
            }
            else {
                this.SaveWorkFlow();
            }
        }
        else {
            this._isWFFetching = false;
            this.CustomDialogteSave();
        }
    };
    WorkflowDetailComponent.prototype.FormatWFStatusName = function (statusname) {
        if (statusname == null) {
            return "";
        }
        var status = statusname;
        if (status.indexOf('1st') !== -1) {
            status = '1<sup>st</sup>' + status.replace("1st", "");
        }
        else if (status.indexOf('2nd') !== -1) {
            status = '2<sup>nd</sup>' + status.replace("2nd", "");
        }
        else if (status.indexOf('3rd') !== -1) {
            status = '3<sup>rd</sup>' + status.replace("3rd", "");
        }
        return status;
    };
    WorkflowDetailComponent.prototype.IsValidate = function (btnType) {
        var retvalue = true;
        var msg = "";
        //user need to sendf prelim notifiation before moving further after under review status
        //if debt amt = 0 then skip sending prelim notification
        if (parseFloat(this._wfAdditionalData.Amount) > 0) {
            if (this._workflow.StatusName.toLowerCase() == 'under review' && this._workflow.SubmitType == 498 && this._isShowPreliminary == true) {
                retvalue = false;
                msg = "<p>Please send the preliminary  Notification before changing the Funding Status.";
                this.savedialogmsg = msg;
                return retvalue;
            }
        }
        //
        if (this._wfAdditionalData.Comment == undefined || this._wfAdditionalData.Comment == '') {
            retvalue = false;
            msg = "<p>Draw Number is mandatory for draw approval process.";
            this.savedialogmsg = msg;
            return retvalue;
        }
        //shahid-as per new reuirement comment box should be removed so commented validations
        //if (btnType == 'Save') {
        //    if (this._workflow.Comment == '' || this._workflow.Comment == undefined) {
        //        retvalue = false;
        //        msg = "<p>Comment is required to save the checklist.";
        //        this.savedialogmsg = msg;
        //        return retvalue;
        //    }
        //}
        var lookupidForYes = this.lstCheckListStatusType.filter(function (x) { return x.Name.toString().toLowerCase() === 'yes'; })[0].LookupID;
        var lookupidForNA = this.lstCheckListStatusType.filter(function (x) { return x.Name.toString().toLowerCase() === 'n/a'; })[0].LookupID;
        var lookupidForWaived = this.lstCheckListStatusType.filter(function (x) { return x.Name.toString().toLowerCase() === 'waived'; })[0].LookupID;
        var lookupidForPending = this.lstCheckListStatusType.filter(function (x) { return x.Name.toString().toLowerCase() === 'pending'; })[0].LookupID;
        var chkListWithMandatoryFields = this._workflow.WFCheckList;
        for (var i = 0; i < chkListWithMandatoryFields.length; i++) {
            if (chkListWithMandatoryFields[i].hasOwnProperty('CheckListName') == false) {
                this._workflow.WFCheckList[i].CheckListName = '';
            }
            if (chkListWithMandatoryFields[i].hasOwnProperty('CheckListStatusText') == false) {
                this._workflow.WFCheckList[i].CheckListStatusText = '';
            }
            if (chkListWithMandatoryFields[i].hasOwnProperty('Comment') == false) {
                this._workflow.WFCheckList[i].Comment = '';
            }
        }
        //Check list name required
        var blankChklist = this._workflow.WFCheckList.filter(function (x) { return x.CheckListName.trim() === '' && (x.CheckListStatusText != '' || x.Comment != ''); });
        if (blankChklist.length > 0) {
            retvalue = false;
            msg = "<p>Check list name should not be blank.";
            this.savedialogmsg = msg;
            return retvalue;
        }
        if (this._workflow.wfFlag == 'FinalState') {
            if (btnType == 'Draft' || btnType == 'Save') //Vishal 
             {
                for (var i = 0; i < this._workflow.WFCheckList.length; i++) {
                    if (Number(this._workflow.WFCheckList[i].CheckListStatus).toString() == lookupidForNA || Number(this._workflow.WFCheckList[i].CheckListStatus).toString() == lookupidForWaived) {
                        if (this._workflow.WFCheckList[i].Comment == null)
                            this._workflow.WFCheckList[i].Comment = '';
                        if (this._workflow.WFCheckList[i].Comment.trim() == '') {
                            retvalue = false;
                            msg = "<p>Comment is required for N/A or Waived.";
                            break;
                        }
                    }
                }
                chkListWithMandatoryFields = this._workflow.WFCheckList.filter(function (x) { return x.IsMandatory === true; });
                for (var i = 0; i < chkListWithMandatoryFields.length; i++) {
                    if (Number(chkListWithMandatoryFields[i].CheckListStatus).toString() != lookupidForYes) {
                        retvalue = false;
                        msg = "<p>" + chkListWithMandatoryFields[i].CheckListName.replace('*', '') + " is mandatory.";
                        break;
                    }
                }
            }
            else {
                for (var i = 0; i < this._workflow.WFCheckList.length; i++) {
                    if (Number(this._workflow.WFCheckList[i].CheckListStatus).toString() == lookupidForNA || Number(this._workflow.WFCheckList[i].CheckListStatus).toString() == lookupidForWaived || Number(this._workflow.WFCheckList[i].CheckListStatus).toString() == lookupidForPending) {
                        if (this._workflow.WFCheckList[i].Comment == null)
                            this._workflow.WFCheckList[i].Comment = '';
                        if (this._workflow.WFCheckList[i].Comment.trim() == '') {
                            retvalue = false;
                            msg = "<p>Comment is required for N/A, Waived and Pending.";
                            break;
                        }
                    }
                }
                for (var i = 0; i < chkListWithMandatoryFields.length; i++) {
                    if (chkListWithMandatoryFields[i].CheckListMasterId != 6 && chkListWithMandatoryFields[i].CheckListMasterId != 15 &&
                        chkListWithMandatoryFields[i].CheckListMasterId != 16 && chkListWithMandatoryFields[i].CheckListMasterId != 17 &&
                        chkListWithMandatoryFields[i].CheckListMasterId != 9) {
                        if (Number(chkListWithMandatoryFields[i].CheckListStatus).toString() != lookupidForYes && Number(chkListWithMandatoryFields[i].CheckListStatus).toString() != lookupidForNA && Number(chkListWithMandatoryFields[i].CheckListStatus).toString() != lookupidForWaived && Number(chkListWithMandatoryFields[i].CheckListStatus).toString() != lookupidForPending) {
                            retvalue = false;
                            msg = "<p>All checklist items should be marked as YES or N/A or Waived for completed status.";
                            break;
                        }
                    }
                }
                if (this._workflow.TaskTypeID == 719) {
                    var checkListService = chkListWithMandatoryFields.filter(function (x) { return x.CheckListMasterId == 18; })[0];
                    //primary user of that deal will not be able to complete if team's approval checklist item is 'Yes' regardless of the amount
                    if (Number(checkListService.CheckListStatus).toString() != lookupidForYes) {
                        retvalue = false;
                        msg = "<p>Checklist item " + checkListService.CheckListName.replace('*', '') + " should be marked as YES for completed status.";
                    }
                }
            }
        }
        else {
            for (var i = 0; i < this._workflow.WFCheckList.length; i++) {
                if (Number(this._workflow.WFCheckList[i].CheckListStatus).toString() == lookupidForNA || Number(this._workflow.WFCheckList[i].CheckListStatus).toString() == lookupidForWaived) {
                    if (this._workflow.WFCheckList[i].Comment == null)
                        this._workflow.WFCheckList[i].Comment = '';
                    if (this._workflow.WFCheckList[i].Comment.trim() == '') {
                        retvalue = false;
                        msg = "<p>Comment is required for N/A or Waived.";
                        break;
                    }
                }
            }
            chkListWithMandatoryFields = this._workflow.WFCheckList.filter(function (x) { return x.IsMandatory === true; });
            for (var i = 0; i < chkListWithMandatoryFields.length; i++) {
                if (Number(chkListWithMandatoryFields[i].CheckListStatus).toString() != lookupidForYes) {
                    retvalue = false;
                    msg = "<p>" + chkListWithMandatoryFields[i].CheckListName.replace('*', '') + " is mandatory.";
                    break;
                }
            }
        }
        if (this._workflow.TaskTypeID == 502) {
            if (this.rolename == 'Asset Manager' && (btnType == "Save" || btnType == "Approved") && this._isShowDrawFee == false
                && this._workflow.WFCheckList.filter(function (x) { return x.CheckListMasterId == 9; })[0].CheckListStatus != 499
                && this._workflow.WFCheckList.filter(function (x) { return x.CheckListMasterId == 9; })[0].Comment == '') {
                retvalue = false;
                msg = "<p>Comment is required when Draw Fee Applicable checklist item is set to No.";
            }
            if (this.rolename == 'Asset Manager' && (btnType == "Save" || btnType == "Approved") && this._isShowDrawFee == true
                && (this._drawFeeInvoice.DrawFeeStatus == 0 || this._drawFeeInvoice.DrawFeeStatus == 692 || this._drawFeeInvoice.DrawFeeStatus == 696)) {
                var errorMsg = this.CheckValidationforDrawFee('');
                if (errorMsg != "") {
                    retvalue = false;
                    msg = errorMsg;
                    //this.CustomAlert(errorMsg);
                }
            }
        }
        this.savedialogmsg = msg;
        return retvalue;
    };
    WorkflowDetailComponent.prototype.GetWFCommentsByTaskId = function (_workflow) {
        var _this = this;
        this.wfSrv.GetWFCommentsByTaskId(_workflow).subscribe(function (res) {
            if (res.Succeeded) {
                _this.commentHistory = '';
                _this.lstWFComments = res.lstWFComments;
                var lstWFStatus = _this.lstWFComments.filter(function (x) { return (x.SubmitType == 496 || x.SubmitType == 498) && x.WFStatusMasterID != 1 && x.WFStatusMasterID != 2; });
                for (var i = 0; i < _this.lstWFComments.length; i++) {
                    _this.lstWFComments[i].StatusName = (_this.lstWFComments[i].SubmitType == 496 && _this.lstWFComments[i].Comment == '' ? "rejected transaction back to " : "") + _this.FormatWFStatusName(_this.lstWFComments[i].StatusName);
                    if (((_this.lstWFComments[i].WFStatusMasterID != 1 && _this.lstWFComments[i].WFStatusMasterID != 2) || (_this.lstWFComments[i].SubmitType == 496))
                        && _this.lstWFComments[i].Comment != 'Checklist updated'
                        && _this.lstWFComments[i].Comment.indexOf("Changed the funding date") < 0 && _this.lstWFComments[i].Comment.indexOf("Changed the funding amount") < 0) {
                        _this.commentHistory += "<i>" + _this.lstWFComments[i].Login + "  " + _this.lstWFComments[i].StatusName + "  " + _this.convertDateTimeIn12Hours(_this.lstWFComments[i].CreatedDate) + " " + _this.lstWFComments[i].Abbreviation + "</i>" + "\n";
                        if (_this.lstWFComments[i].Comment != '' && _this.lstWFComments[i].Comment != 'Checklist updated') {
                            _this.commentHistory += _this.lstWFComments[i].Comment + "\n";
                        }
                    }
                    //(this.lstWFComments[i].Comment != '' && this.lstWFComments[i].Comment != 'Checklist updated') ? this.lstWFComments[i].Comment + "\n" : '';
                    if (!(_this.lstWFComments[i].DelegatedUserName == null || _this.lstWFComments[i].DelegatedUserName == "" || _this.lstWFComments[i].DelegatedUserName == undefined)) {
                        _this.lstWFComments[i].DelegatedUserName = _this.lstWFComments[i].DelegatedUserName + ' (on behalf of ';
                        _this.lstWFComments[i].Login = _this.lstWFComments[i].Login + ' )';
                    }
                }
                //if (lstWFStatus.length > 0) {
                //    for (var i = 0; i < lstWFStatus.length; i++) {
                //        this.commentHistory += lstWFStatus[i].Login + "  " + lstWFStatus[i].StatusName + "  " + this.convertDateTime(lstWFStatus[i].CreatedDate) + "\n";
                //    }
                //}
                //this.lstWFComments.forEach(function (value, index) {
                //    this.lstWFComments[index].StatusNameWithFormat = this.FormatWFStatusName(value);
                //    });
            }
            else {
                _this._router.navigate(['login']);
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    WorkflowDetailComponent.prototype.GetWFCommentsByTaskIdOnNotification = function (_workflow, notificatioType) {
        var _this = this;
        this.wfSrv.GetWFCommentsByTaskId(_workflow).subscribe(function (res) {
            if (res.Succeeded) {
                _this.commentHistory = '';
                var lstWFCommentsOnNotification = res.lstWFComments;
                var lstWFStatus = lstWFCommentsOnNotification.filter(function (x) { return (x.SubmitType == 496 || x.SubmitType == 498) && x.WFStatusMasterID != 1 && x.WFStatusMasterID != 2; });
                for (var i = 0; i < lstWFCommentsOnNotification.length; i++) {
                    lstWFCommentsOnNotification[i].StatusName = (lstWFCommentsOnNotification[i].SubmitType == 496 && lstWFCommentsOnNotification[i].Comment == '' ? "rejected transaction back to " : "") + _this.FormatWFStatusName(lstWFCommentsOnNotification[i].StatusName);
                    if (((lstWFCommentsOnNotification[i].WFStatusMasterID != 1 && lstWFCommentsOnNotification[i].WFStatusMasterID != 2) || (lstWFCommentsOnNotification[i].SubmitType == 496))
                        && lstWFCommentsOnNotification[i].Comment != 'Checklist updated'
                        && lstWFCommentsOnNotification[i].Comment.indexOf("Changed the funding date") < 0 && lstWFCommentsOnNotification[i].Comment.indexOf("Changed the funding amount") < 0) {
                        _this.commentHistory += "<i>" + lstWFCommentsOnNotification[i].Login + "  " + lstWFCommentsOnNotification[i].StatusName + "  " + _this.convertDateTimeIn12Hours(lstWFCommentsOnNotification[i].CreatedDate) + "</i>" + "\n";
                        if (lstWFCommentsOnNotification[i].Comment != '' && lstWFCommentsOnNotification[i].Comment != 'Checklist updated') {
                            _this.commentHistory += lstWFCommentsOnNotification[i].Comment + "\n";
                        }
                    }
                    //(this.lstWFComments[i].Comment != '' && this.lstWFComments[i].Comment != 'Checklist updated') ? this.lstWFComments[i].Comment + "\n" : '';
                }
                if (_this._workflow.TaskTypeID == 502) {
                    _this.showWFNotificationDialog(notificatioType);
                }
                else if (_this._workflow.TaskTypeID == 719) {
                    if (_this._wfAdditionalData.IsREODeal || notificatioType == _this._Final || notificatioType == _this._RevisedFinal) {
                        _this.showWFNotificationDialogForReserveWorkflow(notificatioType);
                    }
                    else {
                        _this._isRefresh = true;
                        _this._isWFFetching = false;
                        localStorage.setItem('divSucessWorkflow', 'true');
                        localStorage.setItem('divSucessMsgWorkflow', 'Draw approval status updated successfully');
                        _this.CloseWFNotificationDialog();
                    }
                }
            }
        });
    };
    WorkflowDetailComponent.prototype.SendWFNotificationWithTimeZone = function (timezone) {
        var _this = this;
        this.isShowSendButton = false;
        this._workflow.TimeZone = timezone;
        //this._workflow.WFAdditionalList = null;
        if (this.commentHistory != '') {
            this.wfSrv.GetWFCommentsByTaskId(this._workflow).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.commentHistory = '';
                    _this._workflow.TimeZone = '';
                    _this.lstWFComments = res.lstWFComments;
                    var lstWFStatus = _this.lstWFComments.filter(function (x) { return (x.SubmitType == 496 || x.SubmitType == 498) && x.WFStatusMasterID != 1 && x.WFStatusMasterID != 2; });
                    for (var i = 0; i < _this.lstWFComments.length; i++) {
                        _this.lstWFComments[i].StatusName = (_this.lstWFComments[i].SubmitType == 496 && _this.lstWFComments[i].Comment == '' ? "rejected transaction back to " : "") + _this.FormatWFStatusName(_this.lstWFComments[i].StatusName);
                        if (((_this.lstWFComments[i].WFStatusMasterID != 1 && _this.lstWFComments[i].WFStatusMasterID != 2) || (_this.lstWFComments[i].SubmitType == 496))
                            && _this.lstWFComments[i].Comment != 'Checklist updated'
                            && _this.lstWFComments[i].Comment.indexOf("Changed the funding date") < 0 && _this.lstWFComments[i].Comment.indexOf("Changed the funding amount") < 0) {
                            if (!(_this.lstWFComments[i].DelegatedUserName == null || _this.lstWFComments[i].DelegatedUserName == "" || _this.lstWFComments[i].DelegatedUserName == undefined)) {
                                _this.lstWFComments[i].Login = _this.lstWFComments[i].DelegatedUserName + " (on behalf of " + _this.lstWFComments[i].Login + " )";
                            }
                            _this.commentHistory += "<i>" + _this.lstWFComments[i].Login + "  " + _this.lstWFComments[i].StatusName + "  " + _this.convertDateTimeIn12Hours(_this.lstWFComments[i].CreatedDate) + " " + _this.lstWFComments[i].Abbreviation + "</i>" + "\n";
                            if (_this.lstWFComments[i].Comment != '' && _this.lstWFComments[i].Comment != 'Checklist updated') {
                                _this.commentHistory += _this.lstWFComments[i].Comment + "\n";
                            }
                        }
                        //(this.lstWFComments[i].Comment != '' && this.lstWFComments[i].Comment != 'Checklist updated') ? this.lstWFComments[i].Comment + "\n" : '';
                    }
                    if (_this.commentHistory != '') {
                        _this._activityLog = "<b>Activity log are below:</b><br/>" + _this.commentHistory;
                        if (_this._workflow.TaskTypeID == 719 && (_this.notificatio_type == _this._Final || _this.notificatio_type == _this._RevisedFinal))
                            _this._activityLog = "<b>Activity log:</b><br/>" + _this.commentHistory;
                    }
                    _this.SendWFNotification('Sent');
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
            (function (error) { return console.error('Error: ' + error); });
        }
        else {
            this.SendWFNotification('Sent');
        }
    };
    WorkflowDetailComponent.prototype.CustomDialogteSave = function () {
        var winW = window.innerWidth;
        var winH = window.innerHeight;
        var dialogbox = document.getElementById('Genericdialogbox');
        document.getElementById('savedialogmessage').innerHTML = this.savedialogmsg;
        dialogbox.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    WorkflowDetailComponent.prototype.ClosePopUpDialog = function () {
        var modal = document.getElementById('Genericdialogbox');
        modal.style.display = "none";
    };
    WorkflowDetailComponent.prototype.Savedialogbox = function () {
        this.ClosePopUpDialog();
    };
    WorkflowDetailComponent.prototype.HideButton = function () {
        //this._isShowbtnRejected = false;
        this._isShowbtnApproval = false;
        if (this._workflow.wfFlag == 'Complete') {
            this._isShowbtnSaveDraft = false;
        }
        else {
            this._isShowbtnSaveDraft = true;
        }
    };
    WorkflowDetailComponent.prototype.DiscardChanges = function () {
        var notenewcopied;
        if (window.location.href.indexOf("dealdetail/a") > -1) {
            notenewcopied = ['dealdetail', this._wfAdditionalData.CREDealID];
        }
        else {
            notenewcopied = ['dealdetail/a', this._wfAdditionalData.CREDealID];
        }
        localStorage.setItem('ClickedTabId', 'aFunding');
        this._router.navigate(notenewcopied);
    };
    WorkflowDetailComponent.prototype.downloadboxdocument = function () {
        var boxlink = this._wfAdditionalData.BoxDocumentLink;
        if (!boxlink.match(/^[a-zA-Z]+:\/\//)) {
            this._wfAdditionalData.BoxDocumentLink = 'http://' + boxlink;
        }
        window.open(this._wfAdditionalData.BoxDocumentLink, '_blank');
        //if (this._wfAdditionalData.BoxDocumentLink != null && this._wfAdditionalData.BoxDocumentLink != '') {
        //    this._isWFFetching = true;
        //    var filename = this._wfAdditionalData.BoxDocumentLink.split('\\').pop().split('/').pop();
        //    this.fileUploadService.downloadFileFromURL(this._wfAdditionalData.BoxDocumentLink)
        //        .subscribe(fileData => {
        //            let b: any = new Blob([fileData]);
        //            //var url = window.URL.createObjectURL(b);
        //            //window.open(url);
        //            let dwldLink = document.createElement("a");
        //            let url = URL.createObjectURL(b);
        //            let isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
        //            if (isSafariBrowser) {  //if Safari open in new window to save file with random filename.
        //                dwldLink.setAttribute("target", "_blank");
        //            }
        //            dwldLink.setAttribute("href", url);
        //            dwldLink.setAttribute("download", filename);
        //            dwldLink.style.visibility = "hidden";
        //            document.body.appendChild(dwldLink);
        //            dwldLink.click();
        //            document.body.removeChild(dwldLink);
        //            this._isWFFetching = false;
        //        },
        //        error => {
        //            this._isWFFetching = false;
        //            alert('Something went wrong');
        //        }
        //        );
        //}
        //else
        //{
        //    this._ShowmessagedivWar = true;
        //    this._ShowmessagedivMsgWar = 'Sorry, you do not have any document to download';
        //    setTimeout(function () {
        //        this._ShowmessagedivWar = false;
        //        this._ShowmessagedivMsgWar = "";
        //    }.bind(this), 4000);
        //}
    };
    WorkflowDetailComponent.prototype.deleteRow = function () {
        this.cvwfCheckListData.removeAt(this.deleteRowIndex);
        this.CloseDeletePopUp();
    };
    WorkflowDetailComponent.prototype.showDeleteDialog = function (rowIndex) {
        this.deleteRowIndex = rowIndex;
        var modalDelete = document.getElementById('myModalDelete');
        modalDelete.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    WorkflowDetailComponent.prototype.CloseDeletePopUp = function () {
        var modal = document.getElementById('myModalDelete');
        modal.style.display = "none";
    };
    WorkflowDetailComponent.prototype.showWFNotificationDialog = function (notificatioType) {
        var _this = this;
        this.notificatio_type = notificatioType;
        this._isShowChecklist = false;
        var msg = "";
        if (this._wfAdditionalData.Comment == undefined || this._wfAdditionalData.Comment == '') {
            msg = "<p>Draw Number is mandatory for draw approval process.";
            this.savedialogmsg = msg;
            this.CustomDialogteSave();
            return;
        }
        this._bodyText = "";
        this._footerText = "";
        var clientName = "";
        var dealclientName = "";
        var emailto = "";
        var IsMultiinvestor = false;
        var ClientFundingDetail = '';
        var ClientFundingDetailText = '';
        this._activityLog = '';
        this.environmentName = this.dataService._environmentNamae != '' ? "(" + this.dataService._environmentNamae.replace("-", "").trim() + ") " : "";
        var drawnumber = (this._wfAdditionalData.Comment != '' && this._wfAdditionalData.Comment != null) ? ' - ' + this._wfAdditionalData.Comment : '';
        var drawnumberWithoutDash = (this._wfAdditionalData.Comment != '' && this._wfAdditionalData.Comment != null) ? ' ' + this._wfAdditionalData.Comment : '';
        var fundingdateMMDDYYYYPrelim = (this._wfAdditionalData.Date != undefined && this._wfAdditionalData.Date != null) ? ' - Est. Funding Date: ' + this.convertDateTOMMDDYYYY(this._wfAdditionalData.Date) : '';
        var fundingdateMMDDYYYYFianl = (this._wfAdditionalData.Date != undefined && this._wfAdditionalData.Date != null) ? ' - Funding Date: ' + this.convertDateTOMMDDYYYY(this._wfAdditionalData.Date) : '';
        //if (notificatioType != this._Servicer) {
        //    if (this._workflow.WFClientList != null && this._workflow.WFClientList != undefined) {
        //        if (this._workflow.WFClientList[0].EmailID != '' && this._workflow.WFClientList[0].EmailID!=null)
        //        {
        //            emailto = this._workflow.WFClientList[0].EmailIDs
        //        }
        //        if (this._workflow.WFClientList[0].ClientName != '') {
        //            IsMultiinvestor  = this._workflow.WFClientList.length>1
        //            clientName = this._workflow.WFClientList[0].ClientsName + " ";
        //        }
        //    }
        //}
        //
        //vishal
        var Fundingamountpernote = '';
        var TotalFundAmountWithExclude;
        TotalFundAmountWithExclude = this._wflstNoteDealFunding[0].TotalFundAmountWithExclude;
        for (var index = 0; index < this._wflstNoteDealFunding.length; index++) {
            if (this._wflstNoteDealFunding[index].IsExcludeThirdParty == 0) {
                if (this._wflstNoteDealFunding[index].Value != 0 || this._wflstNoteDealFunding[index].TaxVendorLoanNumber != '') {
                    Fundingamountpernote = Fundingamountpernote + '\n' + this._wflstNoteDealFunding[index].Name + '\n' +
                        "Amount: $" + parseFloat(this._wflstNoteDealFunding[index].Value).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '\n' +
                        "WFLoanNo: " + this._wflstNoteDealFunding[index].TaxVendorLoanNumber + '\n';
                }
            }
        }
        //===============
        // add checklist to popup
        var table = '<table id="noteinfo" border="1" style="border-collapse:collapse;font-size:12px;"><tr style="font-weight:bold"><td style="padding-left:5px!important;padding-right:5px!important;">Checklist</td><td style="padding-left:5px!important;padding-right:5px!important;">Status</td><td style="padding-left:5px!important;padding-right:5px!important;">Comment</td></tr>';
        var tr = "";
        for (var i = 0; i < this._workflow.WFCheckList.length; i++) {
            if (!(Number(this._workflow.WFCheckList[i].CheckListStatusText).toString() == "NaN" || Number(this._workflow.WFCheckList[i].CheckListStatusText) == 0)) {
                this._workflow.WFCheckList[i].CheckListStatus = Number(this._workflow.WFCheckList[i].CheckListStatusText);
            }
            var statustext = this.lstCheckListStatusType.filter(function (x) { return x.LookupID === _this._workflow.WFCheckList[i].CheckListStatus; })[0].Name;
            tr = tr + '<tr><td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + this._workflow.WFCheckList[i].CheckListName + '</td><td style="padding-left:5px!important;padding-right:5px!important;">' + statustext + '</td><td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + (this._workflow.WFCheckList[i].Comment == null ? '' : this._workflow.WFCheckList[i].Comment) + '</td></tr>';
        }
        table = table + tr + '</table>';
        this.checklistInTable = table;
        //
        var prelimEmails = null;
        var finalEmails = null;
        if (this._workflow.WFNotificationMasterEmail != null && this._workflow.WFNotificationMasterEmail != undefined) {
            prelimEmails = this._workflow.WFNotificationMasterEmail.filter(function (x) { return x.LookupID == 604; });
            finalEmails = this._workflow.WFNotificationMasterEmail.filter(function (x) { return x.LookupID == 605; });
        }
        //
        if (notificatioType == this._Preliminary) {
            if (prelimEmails != null && prelimEmails.length > 0) {
                if (prelimEmails[0].EmailID != '' && prelimEmails[0].EmailID != null) {
                    emailto = prelimEmails[0].EmailIDs;
                }
                if (prelimEmails[0].ClientName != '') {
                    IsMultiinvestor = prelimEmails[0].ClientFunding.split('|').length > 1;
                    clientName = prelimEmails[0].ClientsName + " ";
                }
                if (prelimEmails[0].DealClients != '') {
                    dealclientName = prelimEmails[0].DealClients + " ";
                }
            }
            if (IsMultiinvestor) {
                var client = '';
                var detail = prelimEmails[0].ClientFunding.split('|');
                if (detail.length > 0) {
                    for (var i = 0; i < detail.length; i++) {
                        ClientFundingDetail = ClientFundingDetail + detail[i].split(',')[0] + ": $" + parseFloat(detail[i].split(',')[1]).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + "\n";
                        client = client + detail[i].split(',')[0] + '/';
                    }
                    ClientFundingDetailText = "\n\nAmount broken out by " + client.slice(0, -1) + " are as follows:\n" + ClientFundingDetail;
                }
            }
            this._wfNotificationDetail.WFNotificationMasterID = 1;
            this._wfNotificationDetail.Subject = "Preliminary " + dealclientName + "Capital Call Notice - " + this._wfAdditionalData.DealName + drawnumber + fundingdateMMDDYYYYPrelim;
            this._bodyText = "ACORE is reviewing" + drawnumberWithoutDash + " in the amount of " + "$" + parseFloat(TotalFundAmountWithExclude).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '. ' +
                "\n\nWe anticipate requesting funding on or around " + this.convertDateToBindable(this._wfAdditionalData.Date) + ", " +
                "with Asset Management's " + "approval due on " + this.convertDateToBindable(this._wfAdditionalData.DeadLineDate) + "." +
                ClientFundingDetailText;
            //"\n\nDetails by note are below:\n";
            //"\nDeal Name - " + this._wfAdditionalData.DealName +
            //"\nFunding Date - " + this.convertDateToBindable(this._wfAdditionalData.Date);
            //"\n\nFunding amount per note:" + '\n' + this.noteswithAmount;
            //if (clientName.trim() == this.Delphi_Financial || clientName.trim() == this.Delphi_Fixed) {
            //    this._bodyText = "ACORE is reviewing" + drawnumberWithoutDash + " in the amount of " + "$" + parseFloat(TotalFundAmountWithExclude).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '. ' +
            //        "\n\nWe anticipate requesting funding on or around " + this.convertDateToBindable(this._wfAdditionalData.Date) + "." +
            //        ClientFundingDetailText;
            //        //"\n\nDetails by note are below:\n";
            //        //"\nDeal Name - " + this._wfAdditionalData.DealName +
            //        //"\nFunding Date - " + this.convertDateToBindable(this._wfAdditionalData.Date);
            //        //"\n\nFunding amount per note:" + '\n' + this.noteswithAmount;
            //}
            this._wfNotificationDetail.WFBody = this._bodyText;
            this._notificationTittle = "Preliminary Notification";
        }
        else if (notificatioType == this._RevisedPreliminary) {
            if (prelimEmails != null && prelimEmails.length > 0) {
                if (prelimEmails[0].EmailID != '' && prelimEmails[0].EmailID != null) {
                    emailto = prelimEmails[0].EmailIDs;
                }
                if (prelimEmails[0].ClientName != '') {
                    IsMultiinvestor = prelimEmails[0].ClientFunding.split('|').length > 1;
                    clientName = prelimEmails[0].ClientsName + " ";
                }
                if (prelimEmails[0].DealClients != '') {
                    dealclientName = prelimEmails[0].DealClients + " ";
                }
            }
            if (IsMultiinvestor) {
                var client = '';
                var detail = prelimEmails[0].ClientFunding.split('|');
                if (detail.length > 0) {
                    for (var i = 0; i < detail.length; i++) {
                        ClientFundingDetail = ClientFundingDetail + detail[i].split(',')[0] + ": $" + parseFloat(detail[i].split(',')[1]).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + "\n";
                        client = client + detail[i].split(',')[0] + '/';
                    }
                    ClientFundingDetailText = "\n\nAmount broken out by " + client.slice(0, -1) + " are as follows:\n" + ClientFundingDetail;
                }
            }
            this._wfNotificationDetail.WFNotificationMasterID = 1;
            this._wfNotificationDetail.Subject = "Revised - Preliminary " + dealclientName + "Capital Call Notice - " + this._wfAdditionalData.DealName + drawnumber + fundingdateMMDDYYYYPrelim;
            this._bodyText = "ACORE is reviewing" + drawnumberWithoutDash + " in the amount of " + "$" + parseFloat(TotalFundAmountWithExclude).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '. ' +
                "\n\nWe anticipate requesting funding on or around " + this.convertDateToBindable(this._wfAdditionalData.Date) + ", " +
                "with Asset Management's " + "approval due on " + this.convertDateToBindable(this._wfAdditionalData.DeadLineDate) + "." +
                ClientFundingDetailText;
            //"\n\nDetails by note are below:\n";
            //"\nDeal Name - " + this._wfAdditionalData.DealName +
            //"\nFunding Date - " + this.convertDateToBindable(this._wfAdditionalData.Date);
            //"\n\nFunding amount per note:" + '\n' + this.noteswithAmount;
            //if (clientName.trim() == this.Delphi_Financial || clientName.trim() == this.Delphi_Fixed) {
            //    this._bodyText = "ACORE is reviewing" + drawnumberWithoutDash + " in the amount of " + "$" + parseFloat(TotalFundAmountWithExclude).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '. ' +
            //        "\n\nWe anticipate requesting funding on or around " + this.convertDateToBindable(this._wfAdditionalData.Date) + "." +
            //        ClientFundingDetailText;
            //    //"\n\nDetails by note are below:\n";
            //    //"\nDeal Name - " + this._wfAdditionalData.DealName +
            //    //"\nFunding Date - " + this.convertDateToBindable(this._wfAdditionalData.Date);
            //    //"\n\nFunding amount per note:" + '\n' + this.noteswithAmount;
            //}
            this._wfNotificationDetail.WFBody = this._bodyText;
            this._notificationTittle = "Revised - Preliminary Notification";
        }
        else if (notificatioType == this._Final) {
            this._isShowChecklist = true;
            if (finalEmails != null && finalEmails.length > 0) {
                if (finalEmails[0].EmailID != '' && finalEmails[0].EmailID != null) {
                    emailto = finalEmails[0].EmailIDs;
                }
                if (finalEmails[0].ClientName != '') {
                    IsMultiinvestor = finalEmails[0].ClientFunding.split('|').length > 1;
                    clientName = finalEmails[0].ClientsName + " ";
                }
                if (finalEmails[0].DealClients != '') {
                    dealclientName = finalEmails[0].DealClients + " ";
                }
            }
            if (IsMultiinvestor) {
                var client = '';
                var detail = finalEmails[0].ClientFunding.split('|');
                if (detail.length > 0) {
                    for (var i = 0; i < detail.length; i++) {
                        ClientFundingDetail = ClientFundingDetail + detail[i].split(',')[0] + ": $" + parseFloat(detail[i].split(',')[1]).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + "\n";
                        client = client + detail[i].split(',')[0] + '/';
                    }
                    ClientFundingDetailText = "\n\nAmount broken out by " + client.slice(0, -1) + " are as follows:\n" + ClientFundingDetail;
                }
            }
            this._wfNotificationDetail.WFNotificationMasterID = 2;
            this._wfNotificationDetail.Subject = "Final " + dealclientName + "Capital Call Notice - " + this._wfAdditionalData.DealName + drawnumber + fundingdateMMDDYYYYFianl;
            this._bodyText = "Please see approvals below for" + drawnumberWithoutDash +
                " in the amount of " + "$" + parseFloat(TotalFundAmountWithExclude).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") +
                " to be funded on " + this.convertDateToBindable(this._wfAdditionalData.Date) + "." +
                ClientFundingDetailText;
            //"\n\nDetails by note are below:\n";
            //"\nDeal Name - " + this._wfAdditionalData.DealName +
            //"\nFunding Date - " + this.convertDateToBindable(this._wfAdditionalData.Date);
            //"\n\nFunding amount per note:" + '\n' + this.noteswithAmount +
            //"\nFunding amount per note:" + '\n' + Fundingamountpernote +  
            //this._activityLog = "Activity log are below:\n" + this.commentHistory;
            //if (clientName.trim() == this.Delphi_Financial || clientName.trim() == this.Delphi_Fixed || IsMultiinvestor == true) {
            //    this._bodyText = "Please see " + this._wfAdditionalData.CreatedByName + "'s final approval below for" + drawnumberWithoutDash +" in the amount of " + "$" + parseFloat(this._wfAdditionalData.Amount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") +
            //        " to be funded on " + this.convertDateToBindable(this._wfAdditionalData.Date) + ".";
            //}
            //else if (clientName.trim() == this.AFLAC || clientName.trim() == this.TRE_ACR) {
            //    this._bodyText = "Accounting Team,\n\nThe AM team has approved the funding of the current loan request" + drawnumberWithoutDash +" in the amount of " + "$" + parseFloat(this._wfAdditionalData.Amount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + "."+
            //        " \n\nPlease consider this the formal two (2) Day Notice for funding on " + this.convertDateToBindable(this._wfAdditionalData.Date) + ".";
            //}
            //else if (clientName.trim() == this.ACORE_Credit_IV) {
            //    this._bodyText = "Accounting Team,\n\nThe AM team has approved the funding of the current loan request" + drawnumberWithoutDash +" in the amount of " + "$" + parseFloat(this._wfAdditionalData.Amount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + "."+
            //    " \n\nPlease consider this the formal two (2) Day Notice for funding on " + this.convertDateToBindable(this._wfAdditionalData.Date) + ".";
            //}
            this._wfNotificationDetail.WFBody = this._bodyText;
            this._notificationTittle = "Final Notification";
            if (this.commentHistory != '') {
                this._activityLog = "<b>Activity log are below:</b><br/>" + this.commentHistory;
            }
        }
        else if (notificatioType == this._RevisedFinal) {
            this._isShowChecklist = true;
            if (finalEmails != null && finalEmails.length > 0) {
                if (finalEmails[0].EmailID != '' && finalEmails[0].EmailID != null) {
                    emailto = finalEmails[0].EmailIDs;
                }
                if (finalEmails[0].ClientName != '') {
                    IsMultiinvestor = finalEmails[0].ClientFunding.split('|').length > 1;
                    clientName = finalEmails[0].ClientsName + " ";
                }
                if (finalEmails[0].DealClients != '') {
                    dealclientName = finalEmails[0].DealClients + " ";
                }
            }
            if (IsMultiinvestor) {
                var client = '';
                var detail = finalEmails[0].ClientFunding.split('|');
                if (detail.length > 0) {
                    for (var i = 0; i < detail.length; i++) {
                        ClientFundingDetail = ClientFundingDetail + detail[i].split(',')[0] + ": $" + parseFloat(detail[i].split(',')[1]).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + "\n";
                        client = client + detail[i].split(',')[0] + '/';
                    }
                    ClientFundingDetailText = "\n\nAmount broken out by " + client.slice(0, -1) + " are as follows:\n" + ClientFundingDetail;
                }
            }
            this._wfNotificationDetail.WFNotificationMasterID = 2;
            this._wfNotificationDetail.Subject = "Revised - Final " + dealclientName + "Capital Call Notice - " + this._wfAdditionalData.DealName + drawnumber + fundingdateMMDDYYYYFianl;
            //vishal
            var FundingamountpernoteRe = '';
            var TotalFundAmountWithExcludeRe;
            TotalFundAmountWithExcludeRe = this._wflstNoteDealFunding[0].TotalFundAmountWithExclude;
            for (var index = 0; index < this._wflstNoteDealFunding.length; index++) {
                if (this._wflstNoteDealFunding[index].IsExcludeThirdParty == 0) {
                    if (this._wflstNoteDealFunding[index].Value != 0 || this._wflstNoteDealFunding[index].TaxVendorLoanNumber != '') {
                        FundingamountpernoteRe = FundingamountpernoteRe + '\n' + this._wflstNoteDealFunding[index].Name + '\n' +
                            "Amount: $" + parseFloat(this._wflstNoteDealFunding[index].Value).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '\n' +
                            "WFLoanNo: " + this._wflstNoteDealFunding[index].TaxVendorLoanNumber + '\n';
                    }
                }
            }
            //===============
            this._bodyText = "Please see approvals below for" + drawnumberWithoutDash +
                " in the amount of " + "$" + parseFloat(TotalFundAmountWithExcludeRe).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") +
                " to be funded on " + this.convertDateToBindable(this._wfAdditionalData.Date) + "." +
                ClientFundingDetailText;
            // "\n\nDetails by note are below:\n" +
            //"\nDeal Name - " + this._wfAdditionalData.DealName +
            //"\nFunding Date - " + this.convertDateToBindable(this._wfAdditionalData.Date) +
            //"\n\nFunding amount per note:" + '\n' + this.noteswithAmount +
            //"\nFunding amount per note:" + '\n' + FundingamountpernoteRe +
            //this._activityLog = "Activity log are below:\n" + this.commentHistory;
            //if (clientName.trim() == this.Delphi_Financial || clientName.trim() == this.Delphi_Fixed || IsMultiinvestor == true) {
            //    this._bodyText = "Please see " + this._wfAdditionalData.CreatedByName + "'s final approval below for Lender’s cash advance" + drawnumberWithoutDash +" in the amount of " + "$" + parseFloat(this._wfAdditionalData.Amount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") +
            //        " to be funded on " + this.convertDateToBindable(this._wfAdditionalData.Date) + ".";
            //}
            //else if (clientName.trim() == this.AFLAC || clientName.trim() == this.TRE_ACR) {
            //    this._bodyText = "Accounting Team,\n\nThe AM team has approved the funding of the current loan request" + drawnumberWithoutDash +" in the amount of " + "$" + parseFloat(this._wfAdditionalData.Amount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + "." +
            //        " \n\nPlease consider this the formal two (2) Day Notice for funding on " + this.convertDateToBindable(this._wfAdditionalData.Date) + ".";
            //}
            //else if (clientName.trim() == this.ACORE_Credit_IV) {
            //    this._bodyText = "Accounting Team,\n\nThe AM team has approved the funding of the current loan request" + drawnumberWithoutDash +" in the amount of " + "$" + parseFloat(this._wfAdditionalData.Amount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + "." +
            //        " \n\nPlease consider this the formal two (2) Day Notice for funding on " + this.convertDateToBindable(this._wfAdditionalData.Date) + ".";
            //}
            this._wfNotificationDetail.WFBody = this._bodyText;
            this._notificationTittle = "Revised - Final Notification";
            if (this.commentHistory != '') {
                this._activityLog = "<b>Activity log are below:</b><br/>" + this.commentHistory;
            }
        }
        else if (notificatioType == this._CancelPreliminary) {
            if (prelimEmails != null && prelimEmails.length > 0) {
                if (prelimEmails[0].EmailID != '' && prelimEmails[0].EmailID != null) {
                    emailto = prelimEmails[0].EmailIDs;
                }
                if (prelimEmails[0].ClientName != '') {
                    IsMultiinvestor = prelimEmails[0].ClientFunding.split('|').length > 1;
                    clientName = prelimEmails[0].ClientsName + " ";
                }
                if (prelimEmails[0].DealClients != '') {
                    dealclientName = prelimEmails[0].DealClients + " ";
                }
            }
            if (IsMultiinvestor) {
                var client = '';
                var detail = prelimEmails[0].ClientFunding.split('|');
                if (detail.length > 0) {
                    for (var i = 0; i < detail.length; i++) {
                        ClientFundingDetail = ClientFundingDetail + detail[i].split(',')[0] + ": $" + parseFloat(detail[i].split(',')[1]).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + "\n";
                        client = client + detail[i].split(',')[0] + '/';
                    }
                    ClientFundingDetailText = "\n\nAmount broken out by " + client.slice(0, -1) + " are as follows:\n" + ClientFundingDetail;
                }
            }
            this._wfNotificationDetail.WFNotificationMasterID = 7;
            this._wfNotificationDetail.Subject = "Canceled – Preliminary " + dealclientName + "Capital Call Notice - " + this._wfAdditionalData.DealName + drawnumber + fundingdateMMDDYYYYPrelim;
            this._bodyText = "Please be advised that the below transaction has been canceled. Please disregard the Preliminary Capital Call below." +
                "\n\nThe Preliminary Capital Call that was originally sent " + this.convertDateToBindable(this._wfAdditionalData.LastPrelimSentDate) + ", " +
                "with Asset Management's " + "approval due on " + this.convertDateToBindable(this._wfAdditionalData.DeadLineDate) + "." +
                ClientFundingDetailText;
            this._wfNotificationDetail.WFBody = this._bodyText;
            this._notificationTittle = "Cancel Preliminary Notification";
        }
        this._footerText = "Thank you,\n" + this._user.FirstName + ' ' + this._user.LastName + '\n' + this._user.Email + ((this._user.ContactNo1 != '' && this._user.ContactNo1 != null) ? ' | ' + this._user.ContactNo1 : '');
        this._wfNotificationDetail.WFFooter = this._footerText;
        this._wfNotificationDetail.EnvironmentName = this.environmentName;
        //change in subject for force funding type--need to uncomment for integration
        if (this._workflow.PurposeTypeId == 520) {
            if (notificatioType == this._CancelPreliminary) {
                this._wfNotificationDetail.Subject = "Canceled - Force Funding – " + this._wfNotificationDetail.Subject.substring(11);
            }
            else {
                this._wfNotificationDetail.Subject = "Force Funding – " + this._wfNotificationDetail.Subject;
            }
        }
        this._wfNotificationDetail.Subject = this.environmentName + this._wfNotificationDetail.Subject;
        var Emailcc = "";
        if (notificatioType == this._Final || notificatioType == this._RevisedFinal) {
            Emailcc = this._wfAdditionalData.AMEmails.replace('|', '');
        }
        else {
            Emailcc = this._wfAdditionalData.AMEmails.split('|')[0];
        }
        //removed amfunding team from the notification as requested by client
        // 13 dec 2019 email-Add AMfunding team in internal emails and remove them from notification.
        //if (notificatioType == this._Preliminary || notificatioType == this._RevisedPreliminary) {
        //    if (Emailcc != '') {
        //        Emailcc = Emailcc + ',' + 'amfunding@mailinator.com';
        //    }
        //    else {
        //        Emailcc = 'amfunding@mailinator.com';
        //    }
        //}
        this._wfNotificationDetail.EmailCCIds = Emailcc;
        //this._wfNotificationDetail.ReplyTo = recipients[0].ReplyTo;
        this._wfNotificationDetail.ReplyTo = this._user.Email;
        if (notificatioType != this._Servicer && emailto != '') {
            this._wfNotificationDetail.EmailToIds = emailto;
        }
        var notificationConfig = this.notificationConfig.filter(function (x) { return x.WFNotificationMasterID == _this._wfNotificationDetail.WFNotificationMasterID; });
        this._CanChangeReplyTo = notificationConfig[0].CanChangeReplyTo;
        this._CanChangeRecipientList = notificationConfig[0].CanChangeRecipientList;
        this._CanChangeHeader = notificationConfig[0].CanChangeHeader;
        this._CanChangeBody = notificationConfig[0].CanChangeBody;
        this._CanChangeFooter = notificationConfig[0].CanChangeFooter;
        this._CanChangeSchedule = notificationConfig[0].CanChangeSchedule;
        this._wfNotificationDetail.TemplateID = notificationConfig[0].TemplateID;
        this._wfNotificationDetail.TemplateFileName = IsMultiinvestor ? "MultiInvestorNotification.html" : notificationConfig[0].TemplateFileName;
        this.ConfirmDialogBoxFor = 'Notification';
        var modalWFNotification = document.getElementById('myModalWFNotification');
        modalWFNotification.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    WorkflowDetailComponent.prototype.showWFNotificationDialogForNegativeAmt = function (notificatioType) {
        var _this = this;
        this.notificatio_type = notificatioType;
        this._isShowChecklist = false;
        var msg = "";
        if (this._wfAdditionalData.Comment == undefined || this._wfAdditionalData.Comment == '') {
            msg = "<p>Draw Number is mandatory for draw approval process.";
            this.savedialogmsg = msg;
            this.CustomDialogteSave();
            return;
        }
        this._bodyText = "";
        this._footerText = "";
        var clientName = "";
        var dealclientName = "";
        var emailto = "";
        var IsMultiinvestor = false;
        var ClientFundingDetail = '';
        var ClientFundingDetailText = '';
        this._activityLog = '';
        this.environmentName = this.dataService._environmentNamae != '' ? "(" + this.dataService._environmentNamae.replace("-", "").trim() + ") " : "";
        var prelimEmails = null;
        var finalEmails = null;
        var finalEmailsWithoutApproval = null;
        if (this._workflow.WFNotificationMasterEmail != null && this._workflow.WFNotificationMasterEmail != undefined) {
            prelimEmails = this._workflow.WFNotificationMasterEmail.filter(function (x) { return x.LookupID == 604; });
            finalEmails = this._workflow.WFNotificationMasterEmail.filter(function (x) { return x.LookupID == 605; });
            finalEmailsWithoutApproval = this._workflow.WFNotificationMasterEmail.filter(function (x) { return x.LookupID == 704; });
        }
        //
        //purpose type Full Payoff
        if (this._workflow.PurposeTypeId == 630) {
            this._isShowChecklist = true;
            if (finalEmailsWithoutApproval != null && finalEmailsWithoutApproval.length > 0) {
                if (finalEmailsWithoutApproval[0].EmailID != '' && finalEmailsWithoutApproval[0].EmailID != null) {
                    emailto = finalEmailsWithoutApproval[0].EmailIDs;
                }
                if (finalEmailsWithoutApproval[0].ClientName != '') {
                    IsMultiinvestor = finalEmailsWithoutApproval[0].ClientFunding.split('|').length > 1;
                    clientName = finalEmailsWithoutApproval[0].ClientsName + " ";
                }
                if (finalEmailsWithoutApproval[0].DealClients != '') {
                    dealclientName = finalEmailsWithoutApproval[0].DealClients + " ";
                }
            }
            this._wfNotificationDetail.WFNotificationMasterID = 6;
            if (this.notificatio_type == this._FinalWithoutApproval) {
                this._wfNotificationDetail.Subject = "Final Loan Payoff Notice: " + this._wfAdditionalData.DealName;
                this._bodyText = "The " + this._wfAdditionalData.DealName + " loan paid off " + this.convertDateToBindable(this._wfAdditionalData.Date) + ", with a principal balance of " + "$" + Math.abs(parseFloat(this._wfAdditionalData.Amount)).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + ". Funds will be remitted by " + this._wfAdditionalData.ServicerName + " within 2 business days.";
                this._wfNotificationDetail.WFBody = this._bodyText;
                this._notificationTittle = "Full Payoff Notification";
            }
            else if (this.notificatio_type == this._RevisedFinalWithoutApproval) {
                this._wfNotificationDetail.Subject = "Revised-Final Loan Payoff Notice: " + this._wfAdditionalData.DealName;
                this._bodyText = "The " + this._wfAdditionalData.DealName + " loan paid off " + this.convertDateToBindable(this._wfAdditionalData.Date) + ", with a principal balance of " + "$" + Math.abs(parseFloat(this._wfAdditionalData.Amount)).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + ". Funds will be remitted by " + this._wfAdditionalData.ServicerName + " within 2 business days.";
                this._wfNotificationDetail.WFBody = this._bodyText;
                this._notificationTittle = "Revised-Full Payoff Notification";
            }
        }
        this._footerText = "Thank you,\n" + this._user.FirstName + ' ' + this._user.LastName + '\n' + this._user.Email + ((this._user.ContactNo1 != '' && this._user.ContactNo1 != null) ? ' | ' + this._user.ContactNo1 : '');
        this._wfNotificationDetail.WFFooter = this._footerText;
        this._wfNotificationDetail.EnvironmentName = this.environmentName;
        this._wfNotificationDetail.Subject = this.environmentName + this._wfNotificationDetail.Subject;
        var recipients = this._wfTemplateRecipient.filter(function (x) { return x.WFNotificationMasterID == _this._wfNotificationDetail.WFNotificationMasterID; });
        this._wfAdditionalData.AMEmails = this._wfAdditionalData.AMEmails.replace('|', '');
        var Emailcc = '';
        if (recipients != null && recipients != undefined && recipients != '') {
            if (recipients[0].CC != '')
                Emailcc = recipients[0].CC + ', ' + this._wfAdditionalData.AMEmails;
            else
                Emailcc = this._wfAdditionalData.AMEmails;
            if (recipients[0].TO != '')
                this._wfNotificationDetail.EmailToIds = recipients[0].TO;
        }
        else
            Emailcc = this._wfAdditionalData.AMEmails;
        this._wfNotificationDetail.EmailCCIds = Emailcc;
        //this._wfNotificationDetail.ReplyTo = recipients[0].ReplyTo;
        this._wfNotificationDetail.ReplyTo = this._user.Email;
        if (emailto != '') {
            this._wfNotificationDetail.EmailToIds = emailto;
        }
        var notificationConfig = this.notificationConfig.filter(function (x) { return x.WFNotificationMasterID == _this._wfNotificationDetail.WFNotificationMasterID; });
        this._CanChangeReplyTo = notificationConfig[0].CanChangeReplyTo;
        this._CanChangeRecipientList = notificationConfig[0].CanChangeRecipientList;
        this._CanChangeHeader = notificationConfig[0].CanChangeHeader;
        this._CanChangeBody = notificationConfig[0].CanChangeBody;
        this._CanChangeFooter = notificationConfig[0].CanChangeFooter;
        this._CanChangeSchedule = notificationConfig[0].CanChangeSchedule;
        this._wfNotificationDetail.TemplateID = notificationConfig[0].TemplateID;
        this._wfNotificationDetail.TemplateFileName = notificationConfig[0].TemplateFileName;
        this.ConfirmDialogBoxFor = 'Notification';
        var modalWFNotification = document.getElementById('myModalWFNotificationForNegativeAmt');
        modalWFNotification.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    WorkflowDetailComponent.prototype.CloseWFNotificationDialog = function () {
        this._wfNotificationDetail.WFBody = "";
        var modal = document.getElementById('myModalWFNotification');
        modal.style.display = "none";
        if (this._isRefresh) {
            var notenewcopied;
            if (window.location.href.indexOf("workflowdetail/a/") > -1) {
                notenewcopied = ['workflowdetail', this._wfAdditionalData.TaskID, this._workflow.TaskTypeID];
            }
            else {
                notenewcopied = ['workflowdetail/a', this._wfAdditionalData.TaskID, this._workflow.TaskTypeID];
            }
            this._router.navigate(notenewcopied);
        }
        //localStorage.setItem('ClickedTabId', 'aFunding');
        //localStorage.setItem('divSucessDeal', 'true');
        //localStorage.setItem('divSucessMsgDeal', 'Draw approval status updated successfully');
    };
    WorkflowDetailComponent.prototype.CloseWFNotificationDialogForNegativeAmt = function () {
        this._wfNotificationDetail.WFBody = "";
        var modal = document.getElementById('myModalWFNotificationForNegativeAmt');
        modal.style.display = "none";
        if (this._isRefresh) {
            var notenewcopied;
            if (window.location.href.indexOf("workflowdetail/a/") > -1) {
                notenewcopied = ['workflowdetail', this._wfAdditionalData.TaskID, this._workflow.TaskTypeID];
            }
            else {
                notenewcopied = ['workflowdetail/a', this._wfAdditionalData.TaskID, this._workflow.TaskTypeID];
            }
            this._router.navigate(notenewcopied);
        }
        //localStorage.setItem('ClickedTabId', 'aFunding');
        //localStorage.setItem('divSucessDeal', 'true');
        //localStorage.setItem('divSucessMsgDeal', 'Draw approval status updated successfully');
    };
    WorkflowDetailComponent.prototype.CloseWFNotificationDialogForNegativeAmtWithConfirm = function () {
        if (this._IsAlreadyCancelNegativeAmt) {
            this._wfNotificationDetail.WFBody = "";
            var modal = document.getElementById('myModalWFNotificationForNegativeAmt');
            modal.style.display = "none";
            if (this._isRefresh) {
                var notenewcopied;
                if (window.location.href.indexOf("workflowdetail/a/") > -1) {
                    notenewcopied = ['workflowdetail', this._wfAdditionalData.TaskID, this._workflow.TaskTypeID];
                }
                else {
                    notenewcopied = ['workflowdetail/a', this._wfAdditionalData.TaskID, this._workflow.TaskTypeID];
                }
                this._router.navigate(notenewcopied);
            }
        }
        else {
            this._IsAlreadyCancelNegativeAmt = true;
            $('#btnCancelNotificationForNegativeAmt').removeClass("custombuttonGrey").addClass("custombuttonRed");
            $('#btnCancelNotificationForNegativeAmt').html("Are you sure?");
        }
        //localStorage.setItem('ClickedTabId', 'aFunding');
        //localStorage.setItem('divSucessDeal', 'true');
        //localStorage.setItem('divSucessMsgDeal', 'Draw approval status updated successfully');
    };
    WorkflowDetailComponent.prototype.CloseWFNotificationDialogWithConfirm = function () {
        if (this._IsAlreadyCancel) {
            this._wfNotificationDetail.WFBody = "";
            var modal = document.getElementById('myModalWFNotification');
            modal.style.display = "none";
            //commented cancel final notification functionality
            //if ((this.notificatio_type == this._Final || this.notificatio_type == this._RevisedFinal) && !this._wfAdditionalData.IsCancelFinalSent) {
            //    this.CancelWFNotification();
            //}
            //else
            if (this._isRefresh) {
                var notenewcopied;
                if (window.location.href.indexOf("workflowdetail/a/") > -1) {
                    notenewcopied = ['workflowdetail', this._wfAdditionalData.TaskID, this._workflow.TaskTypeID];
                }
                else {
                    notenewcopied = ['workflowdetail/a', this._wfAdditionalData.TaskID, this._workflow.TaskTypeID];
                }
                this._router.navigate(notenewcopied);
            }
        }
        else {
            this._IsAlreadyCancel = true;
            $('#btnCancelNotification').removeClass("custombuttonGrey").addClass("custombuttonRed");
            $('#btnCancelNotification').html("Are you sure?");
        }
        //localStorage.setItem('ClickedTabId', 'aFunding');
        //localStorage.setItem('divSucessDeal', 'true');
        //localStorage.setItem('divSucessMsgDeal', 'Draw approval status updated successfully');
    };
    WorkflowDetailComponent.prototype.Notify = function (notificatioType) {
        this.notificatio_type = notificatioType;
        this._IsAlreadyCancel = false;
        $('#btnCancelNotification').html("Cancel");
        $('#btnCancelNotification').removeClass("custombuttonRed").addClass("custombuttonGrey");
        this._isRefresh = false;
        this._isNotificationMsg = true;
        if (this._workflow.TaskTypeID == 502) {
            if (this._workflow.WorkFlowType == "WF_UNDERREVIEW" && this._workflow.PurposeTypeId == 630) {
                this.showWFNotificationDialogForNegativeAmt(notificatioType);
            }
            else {
                this.showWFNotificationDialog(notificatioType);
            }
        }
        else if (this._workflow.TaskTypeID == 719) {
            this.showWFNotificationDialogForReserveWorkflow(notificatioType);
        }
    };
    WorkflowDetailComponent.prototype.getWFNotificationConfigByNotificationType = function (WFNotificationMasterID) {
        var _this = this;
        this._CanChangeReplyTo = false;
        this._CanChangeRecipientList = false;
        this._CanChangeHeader = false;
        this._CanChangeBody = false;
        this._CanChangeFooter = false;
        this._CanChangeSchedule = false;
        this._notificationmaster.WFNotificationMasterID = WFNotificationMasterID;
        this._isWFFetching = true;
        this.wfSrv.getWFNotificationConfigByNotificationType(this._notificationmaster).subscribe(function (res) {
            if (res.Succeeded) {
                _this.notificationConfig = res.wfNotificationConfigDataContract;
                //this._CanChangeReplyTo = this.notificationConfig.CanChangeReplyTo;
                //this._CanChangeRecipientList = this.notificationConfig.CanChangeRecipientList;
                //this._CanChangeHeader = this.notificationConfig.CanChangeHeader;
                //this._CanChangeBody = this.notificationConfig.CanChangeBody;
                //this._CanChangeFooter = this.notificationConfig.CanChangeFooter;
                //this._CanChangeSchedule = this.notificationConfig.CanChangeSchedule;
            }
            else {
                _this._router.navigate(['login']);
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    WorkflowDetailComponent.prototype.SendWFNotification = function (btnType) {
        var _this = this;
        if (this.ValidateTOCCEmail()) {
            this.isShowSendButton = false;
            this._isWFFetching = true;
            if (btnType == 'None') {
                this._wfNotificationDetail.ActionType = 575;
            }
            else if (btnType == 'Scheduled') {
                this._wfNotificationDetail.ActionType = 576;
            }
            else if (btnType == 'Sent') {
                this._wfNotificationDetail.ActionType = 577;
            }
            this._wfNotificationDetail.TaskID = this._workflow.TaskID;
            this._wfNotificationDetail.ActionType = 577;
            this._wfNotificationDetail.MessageHTML = 'All,\n\n';
            this._wfNotificationDetail.DealName = this._wfAdditionalData.DealName;
            if (this._wfNotificationDetail.WFHeader != undefined) {
                //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody.replace(/\n/g, "<br>") + '<br/><br/>';
                this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFHeader + '\n\n';
            }
            if (this.notificatio_type == this._CancelPreliminary) {
                if (this._wfNotificationDetail.WFBody != undefined) {
                    //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
                    if (this._workflow.TaskTypeID == 719)
                        this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody;
                    else
                        this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '\n\n';
                }
                if (this._workflow.SpecialInstructions != undefined && this._workflow.SpecialInstructions != '') {
                    //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody.replace(/\n/g, "<br>") + '<br/><br/>';
                    this._wfNotificationDetail.MessageHTML += '<span style="color: black;font-weight:bold;font-size:16px;background-color:yellow">' + this._workflow.SpecialInstructions + '</span>' + '\n\n';
                }
            }
            else {
                if (this._workflow.SpecialInstructions != undefined && this._workflow.SpecialInstructions != '') {
                    //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody.replace(/\n/g, "<br>") + '<br/><br/>';
                    this._wfNotificationDetail.MessageHTML += '<span style="color: black;font-weight:bold;font-size:16px;background-color:yellow">' + this._workflow.SpecialInstructions + '</span>' + '\n\n';
                }
                if (this._wfNotificationDetail.WFBody != undefined) {
                    //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
                    if (this._workflow.TaskTypeID == 719)
                        this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody;
                    else
                        this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '\n\n';
                }
            }
            if (this.delphinoteswithAmount != undefined && this.delphinoteswithAmount != '') {
                //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
                this._wfNotificationDetail.MessageHTML += this.delphinoteswithAmount + '\n\n';
            }
            if (this.noteswithAmount != undefined && this.noteswithAmount != '') {
                //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
                this._wfNotificationDetail.MessageHTML += "Details by note are below:\n" + this.noteswithAmount + '\n\n';
            }
            if (this.ReserveScheduleBreakDown != undefined && this.ReserveScheduleBreakDown != '') {
                //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
                this._wfNotificationDetail.MessageHTML += this.ReserveScheduleBreakDown + '\n\n';
            }
            if (this._activityLog != undefined) {
                //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
                this._wfNotificationDetail.MessageHTML += this._activityLog + '\n\n';
            }
            if (this._workflow.AdditionalComments != undefined && this._workflow.AdditionalComments != '') {
                //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody.replace(/\n/g, "<br>") + '<br/><br/>';
                this._wfNotificationDetail.MessageHTML += this._workflow.AdditionalComments + '\n\n';
            }
            //send checklist detail on final notification
            if (this._isShowChecklist) {
                if (this.checklistInTable != undefined && this.checklistInTable != '') {
                    this._wfNotificationDetail.MessageHTML += "Draw Approval checklist:\n\n" + this.checklistInTable + '\n\n';
                }
            }
            if (this.noteswithAllocationAmount != undefined && this.noteswithAllocationAmount != '') {
                //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
                this._wfNotificationDetail.MessageHTML += "\n" + this.noteswithAllocationAmount + '\n\n';
            }
            if (this.noteswithAllocationPercentage != undefined && this.noteswithAllocationPercentage != '') {
                //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
                this._wfNotificationDetail.MessageHTML += "\n" + this.noteswithAllocationPercentage + '\n\n';
            }
            if (this._wfNotificationDetail.WFFooter != undefined) {
                //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFFooter.replace(/\n/g, "<br>");
                this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFFooter;
            }
            this._wfNotificationDetail.EmailToIds = this._wfNotificationDetail.EmailToIds.replace(/,\s*$/, "");
            if (this._wfNotificationDetail.EmailCCIds != null &&
                this._wfNotificationDetail.EmailCCIds != undefined &&
                this._wfNotificationDetail.EmailCCIds != '') {
                this._wfNotificationDetail.EmailCCIds = this._wfNotificationDetail.EmailCCIds.replace(/,\s*$/, "");
            }
            else {
                this._wfNotificationDetail.EmailCCIds = "";
            }
            this._wfNotificationDetail.UserName = this._user.FirstName + " " + this._user.LastName;
            this._wfNotificationDetail.AdditionalComments = this._workflow.AdditionalComments;
            this._wfNotificationDetail.SpecialInstructions = this._workflow.SpecialInstructions;
            this._wfNotificationDetail.WFCheckList = this._workflow.WFCheckList;
            this._wfNotificationDetail.TaskTypeID = this._workflow.TaskTypeID;
            this.wfSrv.InsertUpdateWFNotification(this._wfNotificationDetail).subscribe(function (res) {
                if (res.Succeeded) {
                    //if (this._wfNotificationDetail.WFNotificationMasterID == 2 && this._autoSendInvoice == 571) {
                    if (_this._wfNotificationDetail.WFNotificationMasterID == 2 && _this._autoSendInvoice == 571
                        && (_this.notificatio_type == _this._Final || (_this.notificatio_type == _this._RevisedFinal && _this._wfAdditionalData.Applied == false))
                        && _this._isShowDrawFee == true) {
                        _this.dealSrv.GetDealFundingByDealFundingID(_this._dealfundingDrawFee).subscribe(function (res) {
                            if (res.Succeeded) {
                                _this._dealfundingDrawFee = res._dealFunding;
                                if (_this._dealfundingDrawFee.Applied == true) {
                                    try {
                                        _this._isWFFetching = true;
                                        _this._drawFeeInvoice.TaskID = _this._workflow.TaskID;
                                        _this._drawFeeInvoice.UpdatedDate = _this._dealfundingDrawFee.UpdatedDate;
                                        _this._drawFeeInvoice.FundingDate = _this._dealfundingDrawFee.Date;
                                        _this._drawFeeInvoice.CreDealID = _this._wfAdditionalData.CREDealID;
                                        _this._drawFeeInvoice.DrawNo = _this._wfAdditionalData.Comment;
                                        _this._drawFeeInvoice.FundingDate = _this._wfAdditionalData.Date;
                                        _this._drawFeeInvoice.DealName = _this._wfAdditionalData.DealName;
                                        //this._drawFeeInvoice.TemplateName = "m61 invoice template";
                                        //this._drawFeeInvoice.InvoiceCode = "Draw Fees";
                                        _this._drawFeeInvoice.InvoiceTypeID = 558;
                                        _this._drawFeeInvoice.StorageType = appsettings_1.AppSettings._invoiceStorageType;
                                        _this._drawFeeInvoice.FundingAmount = parseFloat(_this._wfAdditionalData.Amount);
                                        _this.wfSrv.CreateInvoice(_this._drawFeeInvoice).subscribe(function (res) {
                                            if (res.Succeeded) {
                                                _this._isRefresh = true;
                                                _this._isWFFetching = false;
                                                localStorage.setItem('divSucessWorkflow', 'true');
                                                localStorage.setItem('divSucessMsgWorkflow', 'Draw approval status updated successfully');
                                                if (_this._isNotificationMsg) {
                                                    localStorage.setItem('divSucessMsgWorkflow', 'Notification sent successfully');
                                                }
                                                _this.isShowSendButton = true;
                                                _this.CloseWFNotificationDialog();
                                            }
                                            else {
                                                _this._router.navigate(['login']);
                                            }
                                        });
                                    }
                                    catch (err) {
                                        _this._isWFFetching = false;
                                    }
                                }
                                else {
                                    _this.isShowSendButton = true;
                                    _this._isRefresh = true;
                                    _this._isWFFetching = false;
                                    localStorage.setItem('divSucessWorkflow', 'true');
                                    localStorage.setItem('divSucessMsgWorkflow', 'Draw approval status updated successfully');
                                    if (_this._isNotificationMsg) {
                                        localStorage.setItem('divSucessMsgWorkflow', 'Notification sent successfully');
                                    }
                                    _this.CloseWFNotificationDialog();
                                }
                            }
                        });
                    }
                    else {
                        _this.isShowSendButton = true;
                        _this._isRefresh = true;
                        _this._isWFFetching = false;
                        localStorage.setItem('divSucessWorkflow', 'true');
                        localStorage.setItem('divSucessMsgWorkflow', 'Draw approval status updated successfully');
                        if (_this._isNotificationMsg) {
                            localStorage.setItem('divSucessMsgWorkflow', 'Notification sent successfully');
                        }
                        _this.CloseWFNotificationDialog();
                    }
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
            (function (error) { return console.error('Error: ' + error); });
        }
        else {
            this._IsShowMsg = true;
            this.isShowSendButton = true;
            this._MsgText = "Invalid email address. Please correct.";
            setTimeout(function () {
                this._IsShowMsg = false;
            }.bind(this), 4000);
        }
    };
    WorkflowDetailComponent.prototype.SendWFNotificationForNegativeAmt = function () {
        var _this = this;
        if (this.ValidateTOCCEmail()) {
            this._isWFFetching = true;
            this._wfNotificationDetail.TaskID = this._workflow.TaskID;
            this._wfNotificationDetail.ActionType = 577;
            this._wfNotificationDetail.MessageHTML = 'All,\n\n';
            this._wfNotificationDetail.DealName = this._wfAdditionalData.DealName;
            if (this._wfNotificationDetail.WFHeader != undefined) {
                //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody.replace(/\n/g, "<br>") + '<br/><br/>';
                this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFHeader + '\n\n';
            }
            if (this.notificatio_type == this._CancelPreliminary) {
                if (this._wfNotificationDetail.WFBody != undefined) {
                    //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
                    this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '\n\n';
                }
                if (this._workflow.SpecialInstructions != undefined && this._workflow.SpecialInstructions != '') {
                    //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody.replace(/\n/g, "<br>") + '<br/><br/>';
                    this._wfNotificationDetail.MessageHTML += '<span style="color: black;font-weight:bold;font-size:16px;background-color:yellow">' + this._workflow.SpecialInstructions + '</span>' + '\n\n';
                }
            }
            else {
                if (this._workflow.SpecialInstructions != undefined && this._workflow.SpecialInstructions != '') {
                    //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody.replace(/\n/g, "<br>") + '<br/><br/>';
                    this._wfNotificationDetail.MessageHTML += '<span style="color: black;font-weight:bold;font-size:16px;background-color:yellow">' + this._workflow.SpecialInstructions + '</span>' + '\n\n';
                }
                if (this._wfNotificationDetail.WFBody != undefined) {
                    //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
                    this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '\n\n';
                }
            }
            if (this._workflow.AdditionalComments != undefined && this._workflow.AdditionalComments != '') {
                //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody.replace(/\n/g, "<br>") + '<br/><br/>';
                this._wfNotificationDetail.MessageHTML += this._workflow.AdditionalComments + '\n\n';
            }
            if (this.tblPayoff != "") {
                var prepPrem = "";
                var exitFee = "";
                var exitFeePer = "";
                if (this._isPayOffNotifyClick == true) {
                    prepPrem = this._prepPrem;
                    exitFee = this._exitFee;
                    exitFeePer = this._exitFeePercentage;
                }
                else {
                    prepPrem = "$" + this._workflow.PrepayPremium.toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
                    exitFee = "$" + this._workflow.ExitFee.toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
                    //exitFeePer = (this._workflow.ExitFeePercentage * 100).toString() + "%";
                    var extFee = Number.isInteger(this._workflow.ExitFeePercentage * 100) ? (this._workflow.ExitFeePercentage * 100).toFixed(2) : parseFloat((this._workflow.ExitFeePercentage * 100).toString());
                    extFee = extFee.toString().split(".")[1].length < 2 ? parseFloat(extFee.toString()).toFixed(2) : extFee.toString();
                    exitFeePer = extFee.toString() + "%";
                }
                this.tblPayoff = this.tblPayoff.replace("$prePrem$", prepPrem);
                this.tblPayoff = this.tblPayoff.replace("$exitFee$", exitFee);
                this.tblPayoff = this.tblPayoff.replace("$exitFeePer$", exitFeePer);
                this._wfNotificationDetail.MessageHTML += "\n" + this.tblPayoff + '\n\n';
            }
            if (this._wfNotificationDetail.WFFooter != undefined) {
                //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFFooter.replace(/\n/g, "<br>");
                this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFFooter;
            }
            this._wfNotificationDetail.EmailToIds = this._wfNotificationDetail.EmailToIds.replace(/,\s*$/, "");
            if (this._wfNotificationDetail.EmailCCIds != null &&
                this._wfNotificationDetail.EmailCCIds != undefined &&
                this._wfNotificationDetail.EmailCCIds != '') {
                this._wfNotificationDetail.EmailCCIds = this._wfNotificationDetail.EmailCCIds.replace(/,\s*$/, "");
            }
            else {
                this._wfNotificationDetail.EmailCCIds = "";
            }
            this._wfNotificationDetail.UserName = this._user.FirstName + " " + this._user.LastName;
            this._wfNotificationDetail.AdditionalComments = this._workflow.AdditionalComments;
            this._wfNotificationDetail.SpecialInstructions = this._workflow.SpecialInstructions;
            this._wfNotificationDetail.WFCheckList = this._workflow.WFCheckList;
            this._wfNotificationDetail.TaskTypeID = this._workflow.TaskTypeID;
            //this.wfSrv.SendWFNotificationForNegativeAmt(this._wfNotificationDetail).subscribe(res => {
            this.wfSrv.InsertUpdateWFNotification(this._wfNotificationDetail).subscribe(function (res) {
                if (res.Succeeded) {
                    _this._isRefresh = true;
                    _this._isWFFetching = false;
                    localStorage.setItem('divSucessWorkflow', 'true');
                    localStorage.setItem('divSucessMsgWorkflow', 'Notification sent successfully');
                    _this.CloseWFNotificationDialogForNegativeAmt();
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
            (function (error) { return console.error('Error: ' + error); });
        }
        else {
            this._IsShowMsg = true;
            this._MsgText = "Invalid email address. Please correct.";
            setTimeout(function () {
                this._IsShowMsg = false;
            }.bind(this), 4000);
        }
    };
    WorkflowDetailComponent.prototype.getTemplateRecipientEmailIDs = function (WFNotificationMasterID) {
        var _this = this;
        this._notificationmaster.WFNotificationMasterID = WFNotificationMasterID;
        this._isWFFetching = true;
        this.wfSrv.getTemplateRecipientEmailIDs(this._notificationmaster).subscribe(function (res) {
            if (res.Succeeded) {
                _this._wfTemplateRecipient = res.wfTemplateRecipient;
            }
            else {
                _this._router.navigate(['login']);
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    WorkflowDetailComponent.prototype.GetDealFundingByDealID = function () {
        var _this = this;
        var tbl = '';
        var tdKey = '';
        var tdValue = '';
        var strnotes = '';
        var strnotesdelphi = '';
        var total = 0.00;
        var totaldelphi = 0.00;
        var trHeader = '<table id="noteinfo" border="1" style="border-collapse:collapse;font-size:12px;"><tr style="font-weight:bold"><td style="padding-left:5px!important;padding-right:5px!important;">Loan#</td><td style="padding-left:5px!important;padding-right:5px!important;">Note ID</td><td style="padding-left:5px!important;padding-right:5px!important;">Financing Source</td><td style="padding-left:5px!important;padding-right:5px!important;">Note Name</td><td style="padding-left:5px!important;padding-right:5px!important;">Current Request</td> </tr>';
        var trHeaderdelphi = '<table id="noteinfo" border="1" style="border-collapse:collapse;font-size:12px;">' +
            '<tr style="font-weight:bold"><td colspan="5" style="text-align:center;">Delphi Financial Summary</td></tr>' +
            '<tr style="font-weight:bold"><td style="padding-left:5px!important;padding-right:5px!important;">Loan#</td><td style="padding-left:5px!important;padding-right:5px!important;">Note ID</td><td style="padding-left:5px!important;padding-right:5px!important;">Financing Source</td><td style="padding-left:5px!important;padding-right:5px!important;">Note Name</td><td style="padding-left:5px!important;padding-right:5px!important;">Current Request</td> </tr>';
        var trHeaderForInternalEmail = '<table id="noteinfo" border="1" style="border-collapse:collapse;font-size:12px;margin:7px 0px 0px 28px"><tr style="font-weight:bold"><td style="padding-left:5px!important;padding-right:5px!important;">Loan#</td><td style="padding-left:5px!important;padding-right:5px!important;">Note ID</td><td style="padding-left:5px!important;padding-right:5px!important;">Financing Source</td><td style="padding-left:5px!important;padding-right:5px!important;">Note Name</td><td style="padding-left:5px!important;padding-right:5px!important;">Current Request</td> </tr>';
        try {
            this.dealSrv.GetWFNoteFunding(this._dealfunding).subscribe(function (res) {
                if (res.Succeeded) {
                    _this._wflstNoteDealFunding = res.lstNoteDealFunding;
                    res.lstNoteDealFunding.forEach(function (value, index) {
                        if (res.lstNoteDealFunding[index].Value != 0 && res.lstNoteDealFunding[index].TaxVendorLoanNumber != '' && res.FinancingSourceID != 26) {
                            strnotes = strnotes +
                                '<tr><td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + res.lstNoteDealFunding[index].TaxVendorLoanNumber + '</td><td style="padding-left:5px!important;padding-right:5px!important;">' + res.lstNoteDealFunding[index].CRENoteID + '</td><td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + res.lstNoteDealFunding[index].FinancingSourceName + '</td><td style="text-align:left;text-align:left;padding-left:5px!important;padding-right:5px!important;">' + res.lstNoteDealFunding[index].Name + '</td><td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.lstNoteDealFunding[index].Value).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td> </tr>';
                            total += parseFloat(res.lstNoteDealFunding[index].Value);
                            if (res.lstNoteDealFunding[index].FinancingSourceName.toLocaleLowerCase().includes('delphi')) {
                                strnotesdelphi = strnotesdelphi +
                                    '<tr><td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + res.lstNoteDealFunding[index].TaxVendorLoanNumber + '</td><td style="padding-left:5px!important;padding-right:5px!important;">' + res.lstNoteDealFunding[index].CRENoteID + '</td><td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + res.lstNoteDealFunding[index].FinancingSourceName + '</td><td style="text-align:left;text-align:left;padding-left:5px!important;padding-right:5px!important;">' + res.lstNoteDealFunding[index].Name + '</td><td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.lstNoteDealFunding[index].Value).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td> </tr>';
                                totaldelphi += parseFloat(res.lstNoteDealFunding[index].Value);
                            }
                        }
                    });
                    if (strnotes != "") {
                        strnotes = strnotes + '<tr><td></td><td></td><td></td><td style="text-align:left;font-weight:bold;text-align:right;padding-left:5px!important;padding-right:5px!important;">Total Loan Funds</td><td style="text-align:right;font-weight:bold;text-align:right;padding-left:5px!important;padding-right:5px!important;">' + "$" + total.toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td></tr >';
                        trHeader = trHeader + strnotes + '</table>';
                        trHeaderForInternalEmail = trHeaderForInternalEmail + strnotes + '</table>';
                    }
                    else {
                        trHeader = "";
                        trHeaderForInternalEmail = "";
                    }
                    if (strnotesdelphi != "") {
                        strnotesdelphi = strnotesdelphi + '<tr><td></td><td></td><td></td><td style="text-align:left;font-weight:bold;text-align:right;padding-left:5px!important;padding-right:5px!important;">Total Loan Funds</td><td style="text-align:right;font-weight:bold;text-align:right;padding-left:5px!important;padding-right:5px!important;">' + "$" + totaldelphi.toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td></tr >';
                        trHeaderdelphi = trHeaderdelphi + strnotesdelphi + '</table>';
                        //delphi only note--need to uncomment for integration
                        _this.delphinoteswithAmount = trHeaderdelphi;
                    }
                    //var tbl = '<table>' + strnotes + '</table>'
                    //this.trustedNoteDetail = this.sanitizer.bypassSecurityTrustResourceUrl(trHeader);
                    _this.noteswithAmount = trHeader;
                    _this._workflow.NoteswithAmount = trHeaderForInternalEmail != "" ? '<br/><br/><b style="margin:7px 0px 0px 28px"> Details by note are below: </b><br/>' + trHeaderForInternalEmail : "";
                    _this.trustedNoteDetail = _this.sanitizer.bypassSecurityTrustHtml(_this.noteswithAmount);
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
        }
    };
    WorkflowDetailComponent.prototype.GetReserveScheduleBreakDown = function () {
        var _this = this;
        var tbl = '';
        var tdKey = '';
        var tdValue = '';
        var strnotes = '';
        var strnotesdelphi = '';
        var totalCurrBal = 0.00;
        var totalReqAmt = 0.00;
        var totalNewBal = 0.00;
        var trHeaderPrelim = '<table width="80%" id="noteinfo" border="1" style="border-collapse:collapse;font-size:12px;"><tr style="font-weight:bold"><td width="25%" style="padding-left:5px!important;padding-right:5px!important;">Reserve Name</td><td width="25%" style="padding-left:5px!important;padding-right:5px!important;">Current Balance</td><td width="25%" style="padding-left:5px!important;padding-right:5px!important;">Pending Request</td><td width="25%" style="padding-left:5px!important;padding-right:5px!important;">Expected New Balance</td> </tr>';
        //var trHeaderFinal = '<table id="noteinfo" border="1" style="border-collapse:collapse;font-size:12px;"><tr style="font-weight:bold"><td style="padding-left:5px!important;padding-right:5px!important;">Reserve Name</td><td style="padding-left:5px!important;padding-right:5px!important;">Previous Balance</td><td style="padding-left:5px!important;padding-right:5px!important;">Current Request</td><td style="padding-left:5px!important;padding-right:5px!important;">New Balance</td> </tr>';
        var trHeaderFinal = '<table width="80%" id="noteinfo" border="1" style="border-collapse:collapse;font-size:12px;"><tr style="font-weight:bold"><td width="25%" style="padding-left:5px!important;padding-right:5px!important;">Reserve Name</td><td width="25%" style="padding-left:5px!important;padding-right:5px!important;">Current Balance</td><td width="25%" style="padding-left:5px!important;padding-right:5px!important;">Pending Request</td><td width="25%" style="padding-left:5px!important;padding-right:5px!important;">Expected New Balance</td> </tr>';
        var trHeaderInternal = '<table width="80%" id="noteinfo" border="1" style="border-collapse:collapse;font-size:12px;margin:7px 0px 0px 28px"><tr style="font-weight:bold"><td width="25%" style="padding-left:5px!important;padding-right:5px!important;">Reserve Name</td><td width="25%" style="padding-left:5px!important;padding-right:5px!important;">Current Balance</td><td width="25%" style="padding-left:5px!important;padding-right:5px!important;">Pending Request</td><td width="25%" style="padding-left:5px!important;padding-right:5px!important;">Expected New Balance</td> </tr>';
        try {
            this.wfSrv.GetReserveScheduleBreakDown(this._workflow).subscribe(function (res) {
                if (res.Succeeded) {
                    _this._lstReserveScheduleBreakDown = res.ListReserveScheduleBreakDown;
                    res.ListReserveScheduleBreakDown.forEach(function (value, index) {
                        strnotes = strnotes +
                            '<tr><td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + res.ListReserveScheduleBreakDown[index].ReserveAccountName + '</td><td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.ListReserveScheduleBreakDown[index].CurrentBalance).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td><td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.ListReserveScheduleBreakDown[index].RequestAmount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td><td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.ListReserveScheduleBreakDown[index].NewBalance).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td> </tr>';
                        totalCurrBal += parseFloat(res.ListReserveScheduleBreakDown[index].CurrentBalance);
                        totalReqAmt += parseFloat(res.ListReserveScheduleBreakDown[index].RequestAmount);
                        totalNewBal += parseFloat(res.ListReserveScheduleBreakDown[index].NewBalance);
                    });
                    if (strnotes != "") {
                        strnotes = strnotes + '<tr><td style="text-align:left;font-weight:bold;padding-left:5px!important;padding-right:5px!important;">Total</td><td style="text-align:right;font-weight:bold;padding-left:5px!important;padding-right:5px!important;">' + "$" + totalCurrBal.toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td><td style="text-align:right;font-weight:bold;padding-left:5px!important;padding-right:5px!important;">' + "$" + totalReqAmt.toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td><td style="text-align:right;font-weight:bold;padding-left:5px!important;padding-right:5px!important;">' + "$" + totalNewBal.toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td></tr >';
                        trHeaderPrelim = trHeaderPrelim + strnotes + '</table>';
                        trHeaderFinal = trHeaderFinal + strnotes + '</table>';
                        trHeaderInternal = trHeaderInternal + strnotes + '</table>';
                    }
                    //var tbl = '<table>' + strnotes + '</table>'
                    //this.trustedNoteDetail = this.sanitizer.bypassSecurityTrustResourceUrl(trHeader);
                    _this.ReserveScheduleBreakDownPrelim = "Anticipated breakdown by reserve is shown below:\n" + trHeaderPrelim;
                    _this.ReserveScheduleBreakDownFinal = "\nBreakdown by reserve is shown below:\n\n" + trHeaderFinal;
                    _this._workflow.ReserveScheduleBreakDown = '<br/><p style = "padding:0px; margin:28px 0px 0px 28px;font-size:12px;">' +
                        '<strong>Anticipated breakdown by reserve is shown below: </strong>' +
                        '</p><br/>' + trHeaderInternal;
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
        }
    };
    WorkflowDetailComponent.prototype.GetNoteAllocationPercentage = function () {
        var _this = this;
        var tbl = '';
        var tdKey = '';
        var tdValue = '';
        var strnotes = '';
        var total = 0.00;
        //var tableAllocation = '<table id="noteinfo" style="border-collapse:collapse;font-size:12px;border-top: 1px solid;border-bottom: 1px solid;border-left: 1px solid;border-right: 1px solid;" width="98%">';
        var tableAllocation = '<table border="1" id="noteinfo" style="border-collapse:collapse;font-size:12px;" width="98%">';
        var trAllocation = '';
        var tdAllocation = '';
        //var tableAllocationAmount = '<table id="noteinfo"  style="border-collapse:collapse;font-size:12px;border-top: 1px solid;border-bottom: 1px solid;border-left: 1px solid;border-right: 1px solid;" width="98%">';
        var tableAllocationAmount = '<table border="1" id="noteinfo"  style="border-collapse:collapse;font-size:12px;" width="98%">';
        var trAllocationAmount = '';
        var tdAllocationAmount = '';
        var tdAllocationAmountTotal = '';
        var trAllocationAmountTotal = '';
        try {
            this.dealSrv.GetNoteAllocationPercentage(this._dealfunding).subscribe(function (res) {
                if (res.Succeeded) {
                    _this._wflstNoteAllocationPercentage = res.lstNoteAllocationPercentage;
                    _this._wflstNoteAllocationAmount = res.lstNoteAllocationAmount;
                    if (_this._wflstNoteAllocationPercentage.length > 0) {
                        var colLength = Object.getOwnPropertyNames(_this._wflstNoteAllocationPercentage[0]).length;
                        var allocationPercentageTdWidth = 100 / (colLength);
                        trAllocation = '<tr><td colspan=' + colLength + ' style=text-align:center;font-weight:bold>ALLOCATION PERCENTAGE</td></tr>';
                        //trAllocation += '<tr><td colspan=' + colLength + '><hr/></td></tr>'
                        trAllocation += '<tr>';
                        Object.getOwnPropertyNames(_this._wflstNoteAllocationPercentage[0]).forEach(function (val, idx, array) {
                            tdAllocation += '<td width=' + allocationPercentageTdWidth + '% style=font-weight:bold;padding-left:5px!important;padding-right:5px!important;text-align:center>' + val + '</td>';
                        });
                        trAllocation = trAllocation + tdAllocation + '</tr>';
                        //trAllocation += '<tr><td colspan=' + colLength + '><hr/></td></tr>'
                        for (var i = 0; i < _this._wflstNoteAllocationPercentage.length; i++) {
                            tdAllocation = '';
                            trAllocation += '<tr>';
                            var obj = _this._wflstNoteAllocationPercentage[i];
                            Object.getOwnPropertyNames(obj).forEach(function (val, idx, array) {
                                if ((typeof (obj[val]) == 'number')) {
                                    tdAllocation += '<td style=text-align:right;padding-left:5px!important;padding-right:5px!important;>' + ((obj[val] == 'null' || obj[val] == null || obj[val] == 0) ? '' : (typeof (obj[val]) == 'number') ? parseFloat(obj[val]).toFixed(6).toString() + '%' : obj[val]) + '</td>';
                                }
                                else {
                                    tdAllocation += '<td style=text-align:center;padding-left:5px!important;padding-right:5px!important;>' + ((obj[val] == 'null' || obj[val] == null || obj[val] == 0) ? '' : (typeof (obj[val]) == 'number') ? parseFloat(obj[val]).toFixed(6).toString() + '%' : obj[val]) + '</td>';
                                }
                            });
                            trAllocation += tdAllocation + '</tr>';
                        }
                        tableAllocation += trAllocation + '</table>';
                        _this.noteswithAllocationPercentage = tableAllocation;
                        //this.trustedNoteDetail = this.sanitizer.bypassSecurityTrustHtml(this.noteswithAllocationPercentage);
                    }
                    if (_this._wflstNoteAllocationAmount.length > 0) {
                        var lstamt = _this._wflstNoteAllocationAmount;
                        var colLengthAmount = Object.getOwnPropertyNames(_this._wflstNoteAllocationAmount[0]).length;
                        var allocationAmountTdWidth = 100 / (colLengthAmount - 1);
                        trAllocationAmount = '<tr><td colspan=' + (colLengthAmount - 1) + ' style=text-align:center;font-weight:bold>ALLOCATION AMOUNT</td></tr>';
                        //trAllocationAmount += '<tr><td colspan=' + (colLengthAmount - 1) + '><hr/></td></tr>'
                        trAllocationAmount += '<tr>';
                        var totalcol = 0.00;
                        Object.getOwnPropertyNames(_this._wflstNoteAllocationAmount[0]).forEach(function (val, idx, array) {
                            if (val.toLowerCase() != "total") {
                                if (val.toLowerCase() == "funding amount") //funding amount need little bit more width so we are adding 3% more
                                 {
                                    tdAllocationAmount += '<td width=' + (allocationAmountTdWidth + 3) + '% style=font-weight:bold;padding-left:5px!important;padding-right:5px!important;text-align:center;>' + val + '</td>';
                                }
                                else {
                                    tdAllocationAmount += '<td width=' + allocationAmountTdWidth + '% style=font-weight:bold;padding-left:5px!important;padding-right:5px!important;text-align:center;>' + val + '</td>';
                                }
                                if (val != 'Note Name') {
                                    for (var total_col = 0; total_col < lstamt.length; total_col++) {
                                        totalcol += lstamt[total_col][val];
                                    }
                                    tdAllocationAmountTotal += '<td style=font-weight:bold;text-align:right;padding-left:5px!important;padding-right:5px!important;>' + '$' + totalcol.toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>';
                                }
                                else {
                                    tdAllocationAmountTotal += '<td style=font-weight:bold;text-align:center;padding-left:5px!important;padding-right:5px!important;>Total</td>';
                                }
                                totalcol = 0.00;
                            }
                        });
                        trAllocationAmount = trAllocationAmount + tdAllocationAmount + '</tr>';
                        //trAllocationAmount += '<tr><td colspan=' + (colLengthAmount - 1) + '><hr/></td></tr>'
                        for (var i = 0; i < _this._wflstNoteAllocationAmount.length; i++) {
                            tdAllocationAmount = '';
                            trAllocationAmount += '<tr>';
                            var obj = _this._wflstNoteAllocationAmount[i];
                            Object.getOwnPropertyNames(obj).forEach(function (val, idx, array) {
                                if (val.toLowerCase() != "total") {
                                    if ((typeof (obj[val]) == 'number')) {
                                        tdAllocationAmount += '<td style=text-align:right;padding-left:5px!important;padding-right:5px!important;>' + ((obj[val] == 'null' || obj[val] == null || obj[val] == 0) ? '' : (typeof (obj[val]) == 'number') ? '$' + parseFloat(obj[val]).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") : obj[val]) + '</td>';
                                    }
                                    else {
                                        tdAllocationAmount += '<td style=text-align:center;padding-left:5px!important;padding-right:5px!important;>' + ((obj[val] == 'null' || obj[val] == null || obj[val] == 0) ? '' : (typeof (obj[val]) == 'number') ? '$' + parseFloat(obj[val]).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") : obj[val]) + '</td>';
                                    }
                                }
                            });
                            trAllocationAmount += tdAllocationAmount + '</tr>';
                        }
                        //trAllocationAmountTotal = '<tr><td colspan=' + (colLengthAmount - 1) +'><hr/></td></tr>'
                        trAllocationAmountTotal += '<tr>' + tdAllocationAmountTotal + '</tr>';
                        tableAllocationAmount += trAllocationAmount + trAllocationAmountTotal + '</table>';
                        _this.noteswithAllocationAmount = tableAllocationAmount;
                        //this.trustedNoteDetail = this.sanitizer.bypassSecurityTrustHtml(this.noteswithAllocationPercentage);
                    }
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
        }
    };
    WorkflowDetailComponent.prototype.GetWFPayOffNoteFunding = function () {
        var _this = this;
        var tbl = '';
        var tdKey = '';
        var tdValue = '';
        var strnotes = '';
        var strnotesdelphi = '';
        var total = 0.00;
        var totaldelphi = 0.00;
        var tblNoteAdditionalInfo = '';
        var tableALL = "";
        var tblInvestorSummary = '<table id = "investorSummary" border = "1" style = "border-collapse:collapse;font-size:12px;" > ' +
            '<tr style="font-weight:bold"><td colspan="6" style="text-align:center;">Investor  Summary</td></tr>' +
            '<tr style="font-weight:bold">' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;" > Investor </td>' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;">Initial Funding</td>' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;">Current Balance</td>' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;">Current Commitment</td>' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;">Remaining Unfunded</td>' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;">Spread</td>';
        '</tr>';
        var tbldelphi = '<table id = "tbldelphi" border = "1" style = "border-collapse:collapse;font-size:12px;" > ' +
            '<tr style="font-weight:bold"><td colspan="9" style="text-align:center;">Delphi Financial Summary</td></tr>' +
            '<tr style="font-weight:bold">' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;" > Loan # </td>' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;" > Note ID </td>' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;" > Financing Source </td>' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;" > Note Name </td>' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;">Initial Funding</td>' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;">Current Balance</td>' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;">Current Commitment</td>' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;">Remaining Unfunded</td>' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;">Spread</td>';
        '</tr>';
        var tblFSource = '<table id = "tblFSource" border = "1" style = "border-collapse:collapse;font-size:12px;" > ' +
            '<tr style="font-weight:bold">' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;" > Loan # </td>' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;" > Note ID </td>' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;" > Financing Source </td>' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;" > Note Name </td>' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;">Initial Funding</td>' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;">Current Balance</td>' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;">Current Commitment</td>' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;">Remaining Unfunded</td>' +
            '<td style="padding-left:5px!important;padding-right:5px!important;text-align:center;">Spread</td>';
        '</tr>';
        var trInvestor = "";
        var TotaltrInvestor = "";
        var trDelphi = "";
        var TotaltrDelphi = "";
        var trFSources = "";
        var TotaltrFSources = "";
        var current_Balance = "";
        var curr_bal_investor = "";
        var curr_bal_delphi = "";
        var curr_bal_fsource = "";
        var curr_comm_investor = "";
        var curr_comm_delphi = "";
        var curr_comm_fsource = "";
        var strThirpPartyAmount = "";
        try {
            this.dealSrv.GetWFPayOffNoteFunding(this._dealfunding).subscribe(function (res) {
                if (res.Succeeded) {
                    if (res.dtNoteAdditionalInfo != null &&
                        res.dtNoteAdditionalInfo != undefined) {
                        if (parseFloat(res.dtNoteAdditionalInfo[0].CurrentBalance) < 0) {
                            current_Balance = "-$" + Math.abs(parseFloat(res.dtNoteAdditionalInfo[0].CurrentBalance)).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
                        }
                        else {
                            current_Balance = "$" + parseFloat(res.dtNoteAdditionalInfo[0].CurrentBalance).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
                        }
                        if (parseFloat(res.dtNoteAdditionalInfo[0].ThirpPartyAmount) == 0) {
                            strThirpPartyAmount = "N/A";
                        }
                        else {
                            strThirpPartyAmount = "$" + parseFloat(res.dtNoteAdditionalInfo[0].ThirpPartyAmount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
                        }
                        _this._prepPrem = "$" + parseFloat(res.dtNoteAdditionalInfo[0].PrepayPremium).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
                        _this._exitFee = "$" + parseFloat(res.dtNoteAdditionalInfo[0].ExitFee).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
                        //this._exitFeePercentage = parseFloat(res.dtNoteAdditionalInfo[0].ExitFeePercentage).toString() + "%";
                        var extFee = Number.isInteger(res.dtNoteAdditionalInfo[0].ExitFeePercentage) ? res.dtNoteAdditionalInfo[0].ExitFeePercentage.toFixed(2) : parseFloat(res.dtNoteAdditionalInfo[0].ExitFeePercentage);
                        _this._exitFeePercentage = extFee.toString().split(".")[1].length < 2 ? extFee.toFixed(2) + "%" : extFee.toString() + "%";
                        tblNoteAdditionalInfo = '<table id="noteinfo" border="1" style="border-collapse:collapse;font-size:12px;">' +
                            '<tr> <td style="padding-left:5px!important;padding-right:5px!important;"><b> Current Balance</b></td><td style="padding-left:5px!important;padding-right:5px!important;">' + current_Balance + '</td></tr>' +
                            '<tr> <td style="padding-left:5px!important;padding-right:5px!important;"><b> Loan Closing Date</b></td><td style="padding-left:5px!important;padding-right:5px!important;">' + _this.convertDateTOMMDDYYYY(res.dtNoteAdditionalInfo[0].ClosingDate) + '</td></tr>' +
                            '<tr> <td style="padding-left:5px!important;padding-right:5px!important;"><b> Initial Maturity</b></td><td style="padding-left:5px!important;padding-right:5px!important;">' + _this.convertDateTOMMDDYYYY(res.dtNoteAdditionalInfo[0].InitialMaturityDate) + '</td></tr>' +
                            '<tr> <td style="padding-left:5px!important;padding-right:5px!important;"><b> Initial Funding</b></td><td style="padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtNoteAdditionalInfo[0].InitialFundingAmount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td></tr>' +
                            '<tr> <td style="padding-left:5px!important;padding-right:5px!important;"><b> Current Commitment</b></td><td style="padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtNoteAdditionalInfo[0].AdjustedTotalCommitment).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td></tr>' +
                            '<tr> <td style="padding-left:5px!important;padding-right:5px!important;"><b> Spread</b></td><td style="padding-left:5px!important;padding-right:5px!important;">' + parseFloat(res.dtNoteAdditionalInfo[0].SpreadPercentage).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '%</td></tr>' +
                            '<tr> <td style="padding-left:5px!important;padding-right:5px!important;"><b> Prepayment Premium</b></td><td style="padding-left:5px!important;padding-right:5px!important;">$prePrem$</td></tr>' +
                            '<tr> <td style="padding-left:5px!important;padding-right:5px!important;"><b> Exit Fee</b></td><td style="padding-left:5px!important;padding-right:5px!important;">$exitFee$</td></tr>' +
                            '<tr> <td style="padding-left:5px!important;padding-right:5px!important;"><b> Exit Fee %</b></td><td style="padding-left:5px!important;padding-right:5px!important;">$exitFeePer$</td></tr>' +
                            '<tr> <td style="padding-left:5px!important;padding-right:5px!important;"><b> Client</b></td><td style="padding-left:5px!important;padding-right:5px!important;">' + res.dtNoteAdditionalInfo[0].ParentClient + '</td></tr>' +
                            '<tr> <td style="padding-left:5px!important;padding-right:5px!important;"><b> Financing source</b></td><td style="padding-left:5px!important;padding-right:5px!important;">' + res.dtNoteAdditionalInfo[0].FinancingSourceName + '</td></tr>' +
                            '<tr> <td style="padding-left:5px!important;padding-right:5px!important;"><b> Third Party Financing</b></td><td style="padding-left:5px!important;padding-right:5px!important;">' + res.dtNoteAdditionalInfo[0].ThirpPartyFinancingSources + '</td></tr>' +
                            '<tr> <td style="padding-left:5px!important;padding-right:5px!important;"><b> Third Party Amount</b></td><td style="padding-left:5px!important;padding-right:5px!important;">' + strThirpPartyAmount + '</td></tr>' +
                            '</table>';
                    }
                    //res.dtInvestors;
                    //res.dtNoteFinancingSources;
                    res.dtInvestors.forEach(function (value, index) {
                        curr_bal_investor = "$" + parseFloat(res.dtInvestors[index].CurrentBalance).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
                        if (parseFloat(res.dtInvestors[index].CurrentBalance) < 0) {
                            curr_bal_investor = "-$" + Math.abs(parseFloat(res.dtInvestors[index].CurrentBalance)).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
                        }
                        curr_comm_investor = "$" + parseFloat(res.dtInvestors[index].AdjustedTotalCommitment).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
                        if (parseFloat(res.dtInvestors[index].AdjustedTotalCommitment) < 0) {
                            curr_comm_investor = "-$" + Math.abs(parseFloat(res.dtInvestors[index].AdjustedTotalCommitment)).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
                        }
                        if (res.dtInvestors[index].RowType == "Data") {
                            trInvestor = trInvestor +
                                '<tr>' +
                                '<td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + res.dtInvestors[index].ParentClient + '</td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtInvestors[index].InitialFundingAmount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + curr_bal_investor + '</td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + curr_comm_investor + '</td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtInvestors[index].RemainingUnfunded).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + parseFloat(res.dtInvestors[index].SpreadPercentage).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '%</td>' +
                                '</tr>';
                        }
                        else if (res.dtInvestors[index].RowType == "Total") {
                            TotaltrInvestor =
                                '<tr>' +
                                    '<td style="text-align:left;padding-left:5px!important;padding-right:5px!important;"><b>Total</b></td>' +
                                    '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;"><b>' + "$" + parseFloat(res.dtInvestors[index].InitialFundingAmount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</b></td>' +
                                    '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;"><b>' + curr_bal_investor + '</b></td>' +
                                    '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;"><b>' + curr_comm_investor + '</b></td>' +
                                    '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;"><b>' + "$" + parseFloat(res.dtInvestors[index].RemainingUnfunded).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</b></td>' +
                                    '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;"><b>' + parseFloat(res.dtInvestors[index].SpreadPercentage).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '%</td>' +
                                    '</tr>';
                        }
                    });
                    tblInvestorSummary += trInvestor + TotaltrInvestor + '</table>';
                    res.dtDelphi.forEach(function (value, index) {
                        curr_bal_delphi = "$" + parseFloat(res.dtDelphi[index].CurrentBalance).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
                        if (parseFloat(res.dtDelphi[index].CurrentBalance) < 0) {
                            curr_bal_delphi = "-$" + Math.abs(parseFloat(res.dtDelphi[index].CurrentBalance)).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
                        }
                        curr_comm_delphi = "$" + parseFloat(res.dtDelphi[index].AdjustedTotalCommitment).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
                        if (parseFloat(res.dtDelphi[index].AdjustedTotalCommitment) < 0) {
                            curr_comm_delphi = "-$" + Math.abs(parseFloat(res.dtDelphi[index].AdjustedTotalCommitment)).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
                        }
                        if (res.dtDelphi[index].RowType == "Data") {
                            trDelphi = trDelphi +
                                '<tr>' +
                                '<td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + res.dtDelphi[index].TaxVendorLoanNumber + '</td>' +
                                '<td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + res.dtDelphi[index].NoteID + '</td>' +
                                '<td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + res.dtDelphi[index].FinancingSourceName + '</td>' +
                                '<td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + res.dtDelphi[index].Name + '</td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtDelphi[index].InitialFundingAmount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + curr_bal_delphi + '</td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + curr_comm_delphi + '</td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtDelphi[index].RemainingUnfunded).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + parseFloat(res.dtDelphi[index].SpreadPercentage).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '%</td>' +
                                '</tr>';
                        }
                        else if (res.dtDelphi[index].RowType == "Total") {
                            TotaltrDelphi = '<tr>' +
                                '<td style="text-align:left;padding-left:5px!important;padding-right:5px!important;"><b>Total</b></td>' +
                                '<td style="text-align:left;padding-left:5px!important;padding-right:5px!important;"></td>' +
                                '<td style="text-align:left;padding-left:5px!important;padding-right:5px!important;"></td>' +
                                '<td style="text-align:left;padding-left:5px!important;padding-right:5px!important;"></td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;"><b>' + "$" + parseFloat(res.dtDelphi[index].InitialFundingAmount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</b></td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;"><b>' + curr_bal_delphi + '</b></td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;"><b>' + curr_comm_delphi + '</b></td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;"><b>' + "$" + parseFloat(res.dtDelphi[index].RemainingUnfunded).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</b></td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;"><b>' + parseFloat(res.dtDelphi[index].SpreadPercentage).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '%</b></td>' +
                                '</tr>';
                        }
                    });
                    tbldelphi += trDelphi + TotaltrDelphi + '</table>';
                    res.dtNoteFinancingSources.forEach(function (value, index) {
                        curr_bal_fsource = "$" + parseFloat(res.dtNoteFinancingSources[index].CurrentBalance).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
                        if (parseFloat(res.dtNoteFinancingSources[index].CurrentBalance) < 0) {
                            curr_bal_fsource = "-$" + Math.abs(parseFloat(res.dtNoteFinancingSources[index].CurrentBalance)).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
                        }
                        curr_comm_fsource = "$" + parseFloat(res.dtNoteFinancingSources[index].AdjustedTotalCommitment).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
                        if (parseFloat(res.dtNoteFinancingSources[index].AdjustedTotalCommitment) < 0) {
                            curr_comm_fsource = "-$" + Math.abs(parseFloat(res.dtNoteFinancingSources[index].AdjustedTotalCommitment)).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
                        }
                        if (res.dtNoteFinancingSources[index].RowType == "Data") {
                            trFSources = trFSources +
                                '<tr>' +
                                '<td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + res.dtNoteFinancingSources[index].TaxVendorLoanNumber + '</td>' +
                                '<td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + res.dtNoteFinancingSources[index].NoteID + '</td>' +
                                '<td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + res.dtNoteFinancingSources[index].FinancingSourceName + '</td>' +
                                '<td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + res.dtNoteFinancingSources[index].Name + '</td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtNoteFinancingSources[index].InitialFundingAmount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + curr_bal_fsource + '</td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + curr_comm_fsource + '</td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtNoteFinancingSources[index].RemainingUnfunded).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + parseFloat(res.dtNoteFinancingSources[index].SpreadPercentage).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '%</td>' +
                                '</tr>';
                        }
                        else if (res.dtNoteFinancingSources[index].RowType == "Total") {
                            TotaltrFSources = '<tr>' +
                                '<td style="text-align:left;padding-left:5px!important;padding-right:5px!important;"><b>Total</b></td>' +
                                '<td style="text-align:left;padding-left:5px!important;padding-right:5px!important;"></td>' +
                                '<td style="text-align:left;padding-left:5px!important;padding-right:5px!important;"></td>' +
                                '<td style="text-align:left;padding-left:5px!important;padding-right:5px!important;"></td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;"><b>' + "$" + parseFloat(res.dtNoteFinancingSources[index].InitialFundingAmount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</b></td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;"><b>' + curr_bal_fsource + '</b></td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;"><b>' + curr_comm_fsource + '</b></td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;"><b>' + "$" + parseFloat(res.dtNoteFinancingSources[index].RemainingUnfunded).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</b></td>' +
                                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;"><b>' + parseFloat(res.dtNoteFinancingSources[index].SpreadPercentage).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '%</b></td>' +
                                '</tr>';
                        }
                    });
                    tblFSource += trFSources + TotaltrFSources + '</table>';
                    tableALL = "Additional information below:\n" + tblNoteAdditionalInfo;
                    if (trInvestor != "")
                        tableALL += "\nSummary by Client(s):\n\n" + tblInvestorSummary;
                    if (trDelphi != "")
                        tableALL += "\n\n" + tbldelphi;
                    if (tblFSource != "")
                        tableALL += "\nDetails by Financing Sources Below:\n\n" + tblFSource;
                    _this.tblPayoff = tableALL;
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
        }
    };
    WorkflowDetailComponent.prototype.ValidateEmail = function (email) {
        var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(String(email).toLowerCase());
    };
    WorkflowDetailComponent.prototype.ValidateTOCCEmail = function () {
        var isValid = true;
        //var emailregx = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/
        if (this._wfNotificationDetail.EmailToIds != null &&
            this._wfNotificationDetail.EmailToIds != undefined &&
            this._wfNotificationDetail.EmailToIds != '') {
            var toEmails = this._wfNotificationDetail.EmailToIds.replace(/;/g, ",").split(',');
            for (var i = 0; i < toEmails.length; i++) {
                if (toEmails[i].trim() != '') {
                    if (!this.ValidateEmail(toEmails[i].trim())) {
                        isValid = false;
                        break;
                    }
                }
            }
        }
        else {
            isValid = false;
        }
        if (isValid) {
            if (this._wfNotificationDetail.EmailCCIds != null &&
                this._wfNotificationDetail.EmailCCIds != undefined &&
                this._wfNotificationDetail.EmailCCIds != '') {
                var ccEmails = this._wfNotificationDetail.EmailCCIds.replace(/;/g, ",").split(',');
                for (var i = 0; i < ccEmails.length; i++) {
                    if (ccEmails[i].trim() != '') {
                        if (!this.ValidateEmail(ccEmails[i].trim())) {
                            isValid = false;
                            break;
                        }
                        //if (!emailregx.test(ccEmails[i].trim())) {
                        //    isValid = false;
                        //    break;
                        //}
                    }
                }
            }
        }
        return isValid;
    };
    WorkflowDetailComponent.prototype.OverWriteDefaultInstruction = function () {
        this._workflow.SpecialInstructions = this.defaultSpecialInstructions;
    };
    //DownloadInvoice() {
    //  this.DownloadDocument("DrawFee.pdf", 392, "Invoice");
    //}
    WorkflowDetailComponent.prototype.DownloadDocument = function (filename, storagetypeID, storageLocation) {
        //  documentStorageID = documentStorageID === undefined ? '' : documentStorageID
        //var _reportfilelog = new reportFileLog();
        //_reportfilelog.FileName = filename;
        //_reportfilelog.StorageLocation = storageLocation;
        //_reportfilelog.StorageTypeID = storagetypeID;
        //if (_reportfilelog.StorageTypeID == "459")
        //    _reportfilelog.FileName = documentStorageID;
        var ID = filename;
        //if (storagetypeID == "459")
        //    ID = documentStorageID
        this.dealSrv.downloadObjectDocumentByStorageTypeAndLocation(ID, storagetypeID, storageLocation)
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
            dwldLink.setAttribute("download", filename);
            dwldLink.style.visibility = "hidden";
            document.body.appendChild(dwldLink);
            dwldLink.click();
            document.body.removeChild(dwldLink);
        }, function (error) {
            //    alert('Something went wrong');
        });
    };
    WorkflowDetailComponent.prototype.GetDrawFeeInvoiceDetailByTaskID = function () {
        var _this = this;
        this.IsDrawFeeEditClick = false;
        try {
            this.wfSrv.GetDrawFeeInvoiceDetailByTaskID(this._workflow.TaskID).subscribe(function (res) {
                if (res.Succeeded) {
                    _this._drawFeeInvoice = res.DrawFeeInvoice;
                    setTimeout(function () {
                        this.enableDisableDrawFeeSection();
                    }.bind(_this), 3000);
                    if (_this._drawFeeInvoice == null || _this._drawFeeInvoice.DrawFeeInvoiceDetailID == 0) {
                        _this._drawFeeInvoice.AutoSendInvoice = 571;
                    }
                    _this._drawFeeInvoiceOrignal = JSON.parse(JSON.stringify(res.DrawFeeInvoice));
                    _this._autoSendInvoice = _this._drawFeeInvoice.AutoSendInvoice;
                    _this.IsShowSaveAndStatusButton = true;
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
        }
    };
    WorkflowDetailComponent.prototype.DownloadInvoice = function () {
        var _this = this;
        if (this._drawFeeInvoice.DrawFeeStatusText == "Generate") {
            var myModelConfirmInvoice = document.getElementById('myModelConfirmInvoice');
            myModelConfirmInvoice.style.display = "block";
            $.getScript("/js/jsDrag.js");
        }
        else if (this._drawFeeInvoice.DrawFeeStatusText == "Invoiced" || this._drawFeeInvoice.DrawFeeStatusText == "Paid") {
            this.dealSrv.downloadObjectDocumentByStorageTypeAndLocation(this._drawFeeInvoice.FileName, appsettings_1.AppSettings._invoiceStorageType, appsettings_1.AppSettings._invoiceLocation)
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
                dwldLink.setAttribute("download", _this._drawFeeInvoice.FileName);
                dwldLink.style.visibility = "hidden";
                document.body.appendChild(dwldLink);
                dwldLink.click();
                document.body.removeChild(dwldLink);
            }, function (error) {
                //  alert('Something went wrong');
            });
        }
    };
    WorkflowDetailComponent.prototype.GetDefaultValue = function (val) {
        if (isNaN(val) || val == null) {
            return 0;
        }
        return val;
    };
    WorkflowDetailComponent.prototype.formatNumberforTwoDecimalplaces = function (data) {
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
            newamount = "-" + this._basecurrencyname + _amount;
        }
        else {
            newamount = this._basecurrencyname + data;
        }
        var changedamount = newamount.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
        return changedamount;
    };
    WorkflowDetailComponent.prototype.CheckAndCreateCustomer = function () {
        try {
            var errorMsg = this.CheckValidationforDrawFee('');
            if (errorMsg != "") {
                this.CustomAlert(errorMsg);
            }
            else {
                this.saveDrawFeeInvoice();
            }
        }
        catch (err) {
            this._isWFFetching = false;
            console.log(err);
        }
    };
    WorkflowDetailComponent.prototype.InsertUpdateDrawFeeInvoice = function () {
        var _this = this;
        try {
            this._isWFFetching = true;
            this._drawFeeInvoice.TaskID = this._workflow.TaskID;
            this._drawFeeInvoice.ObjectTypeID = 698;
            this._drawFeeInvoice.ObjectID = this._workflow.TaskID;
            this._drawFeeInvoice.InvoiceTypeID = 558;
            this.wfSrv.InsertUpdateDrawFeeInvoice(this._drawFeeInvoice).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.GetDrawFeeInvoiceDetailByTaskID();
                    _this._autoSendInvoice = _this._drawFeeInvoice.AutoSendInvoice;
                    //refresh activity log
                    _this.GetWFCommentsByTaskId(_this._workflow);
                    _this._isWFFetching = false;
                    if (_this._isShowinvoicesaveMsg == false) {
                        _this._Showmessagediv = true;
                        _this._ShowmessagedivMsg = 'Invoice detail updated successfully';
                        setTimeout(function () {
                            this._Showmessagediv = false;
                            this._ShowmessagedivMsg = "";
                        }.bind(_this), 4000);
                    }
                    else {
                        _this._isShowinvoicesaveMsg = false;
                        var notenewcopied;
                        if (window.location.href.indexOf("dealdetail/a") > -1) {
                            notenewcopied = ['dealdetail', _this._wfAdditionalData.CREDealID];
                        }
                        else {
                            notenewcopied = ['dealdetail/a', _this._wfAdditionalData.CREDealID];
                        }
                        localStorage.setItem('ClickedTabId', 'aFunding');
                        localStorage.setItem('divSucessDeal', 'true');
                        localStorage.setItem('divSucessMsgDeal', 'Draw approval status updated successfully');
                        _this._router.navigate(notenewcopied);
                    }
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
            this._isWFFetching = false;
        }
    };
    WorkflowDetailComponent.prototype.CustomAlert = function (dialog) {
        var winW = window.innerWidth;
        var winH = window.innerHeight;
        var dialogoverlay = document.getElementById('dialogoverlay');
        var dialogbox = document.getElementById('dialogbox');
        dialogoverlay.style.display = "block";
        dialogoverlay.style.height = winH + "px";
        dialogbox.style.left = (winW / 2) - (550 * .5) + "px";
        dialogbox.style.top = "100px";
        dialogbox.style.display = "block";
        document.getElementById('dialogboxhead').innerHTML = "CRES - Validation Error";
        document.getElementById('dialogboxbody').innerHTML = dialog;
        //document.getElementById('dialogboxfoot').innerHTML = '<span class="custombutton" onclientclick="this.ok()">OK</span>';
    };
    WorkflowDetailComponent.prototype.ok = function () {
        document.getElementById('dialogbox').style.display = "none";
        document.getElementById('dialogoverlay').style.display = "none";
    };
    WorkflowDetailComponent.prototype.getAllStatesMaster = function () {
        var _this = this;
        try {
            this.wfSrv.getAllStatesMaster().subscribe(function (res) {
                if (res.Succeeded) {
                    var data = res.dt;
                    _this.lstStates = data;
                }
            });
        }
        catch (err) {
            console.log(err);
        }
    };
    WorkflowDetailComponent.prototype.onChangeDrawfeeAmount = function () {
        var deccount = 0;
        var FeeAmtdec = this._drawFeeInvoice.Amount;
        if (Math.floor(FeeAmtdec) === FeeAmtdec) {
            deccount = 0;
        }
        else {
            if ((FeeAmtdec % 1) != 0) {
                deccount = FeeAmtdec.toString().split(".")[1].length || 0;
            }
        }
        if (deccount > 2) {
            this._drawFeeInvoice.Amount = parseFloat(parseFloat(this._drawFeeInvoice.Amount.toString()).toFixed(2));
            return;
        }
    };
    WorkflowDetailComponent.prototype.enablediableControls = function () {
        //// to enable or disable controls
        //if (this.rolename == 'Asset Manager' && (this._drawFeeInvoice.DrawFeeStatus == 0 || this._drawFeeInvoice.DrawFeeStatus == 692 || this._drawFeeInvoice.DrawFeeStatus == 696)) {
        //    $("#drawFeeInvoicedivs").on("mouseover", function () {
        //        $("#drawFeeInvoicedivs").find('input, select, textarea, checkbox, radio, button').removeAttr('disabled', false);
        //        $("#drawFeeInvoicedivs").find('input, select, textarea, checkbox, radio, button').removeClass("disabledrawfee");
        //    });
        //}
        //else {
        //    $("#drawFeeInvoicedivs").on("mouseover", function () {
        //        $('#drawFeeInvoicedivs').find('input, select, textarea, checkbox, radio, button').attr('disabled', true);
        //        $("#drawFeeInvoicedivs").find('input, select, textarea, checkbox, radio, button').addClass("disabledrawfee");
        //    });
        //}
    };
    WorkflowDetailComponent.prototype.enableDisableDrawFeeSection = function () {
        if (this.rolename == 'Asset Manager' && (this._drawFeeInvoice.DrawFeeStatus == 0 || this._drawFeeInvoice.DrawFeeStatus == 692 || this._drawFeeInvoice.DrawFeeStatus == 696)) {
            if (this._drawFeeInvoiceOrignal.FirstName == null || this._drawFeeInvoiceOrignal.FirstName == '' && this._drawFeeInvoice.LastName != null && this._drawFeeInvoice.LastName != '') {
                $("#drawFeeInvoicedivs").find('input, select, textarea, checkbox, radio').removeAttr('disabled', false);
                $("#drawFeeInvoicedivs").find('input, select, textarea, checkbox, radio').removeClass("disabledrawfee");
                $("#drawFeeInvoicedivs").find('wj-input-number').removeClass("disabledrawfee");
            }
            else {
                $('#drawFeeInvoicedivs').find('input, select, textarea, checkbox, radio').attr('disabled', true);
                $("#drawFeeInvoicedivs").find('input, select, textarea, checkbox, radio').addClass("disabledrawfee");
                $("#drawFeeInvoicedivs").find('wj-input-number').addClass("disabledrawfee");
            }
        }
        else {
            $('#drawFeeInvoicedivs').find('input, select, textarea, checkbox, radio').attr('disabled', true);
            $("#drawFeeInvoicedivs").find('input, select, textarea, checkbox, radio').addClass("disabledrawfee");
            $("#drawFeeInvoicedivs").find('wj-input-number').addClass("disabledrawfee");
        }
    };
    WorkflowDetailComponent.prototype.CheckValidationforPropertyManager = function (errMsg) {
        var errorMsg = "";
        var Emailexp = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        if (this._workflow.PropertyManagerEmail) {
            this._workflow.PropertyManagerEmail = this._workflow.PropertyManagerEmail.replace(/,(?=\s*$)/, '');
            var drawtoemail = this._workflow.PropertyManagerEmail.replace(/;/g, ",").replace(/,(?=\s*$)/, '');
            var foundemail = '';
            var foundcomma = drawtoemail.indexOf(",");
            if (foundcomma > 0) {
                var splitemail = drawtoemail.split(",");
                for (var k = 0; k < splitemail.length; k++) {
                    splitemail[k] = splitemail[k].replace(/\s/g, '');
                    if (splitemail[k].trim() != '') {
                        if (!Emailexp.test(String(splitemail[k]).toLowerCase())) {
                            foundemail = foundemail + splitemail[k] + ", ";
                        }
                    }
                }
                if (foundemail != '') {
                    errorMsg = errorMsg + "<p>" + "Please enter valid Email Address(es) for property manager separated by comma/semicolon." + "</p>";
                }
            }
            else {
                if (this._workflow.PropertyManagerEmail != "") {
                    if (!Emailexp.test(String(this._workflow.PropertyManagerEmail).toLocaleLowerCase())) {
                        errorMsg = errorMsg + "<p>" + "Please enter valid Email Address(es) for property manager separated by comma/semicolon." + "</p>";
                    }
                }
            }
        }
        errMsg = errorMsg;
        return errMsg;
    };
    WorkflowDetailComponent.prototype.CheckValidationforDrawFee = function (errMsg) {
        var errorMsg = "";
        var Emailexp = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        var Zipexp = /(^\d{5}$)|(^\d{5}-\d{4}$)/;
        var phoneNumberPattern = /^\(?(\d{3})\)[ ]?(\d{3})[-](\d{4})$/;
        var phonepattern = /^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$/; //for us num
        var pattern = /^[0-9a-bA-B]+$/;
        //var phonepattern = /^(\d{3}-\d{3}-\d{4})$/;
        if (this._drawFeeInvoice.AutoSendInvoice == 0) {
            errorMsg = errorMsg + "<p>" + "Please select Auto Send Draw Fee Invoice.";
        }
        if (this._drawFeeInvoice.Amount == null || this._drawFeeInvoice.Amount == undefined || this._drawFeeInvoice.Amount.toString() == "") {
            errorMsg = errorMsg + "<p>" + "Please enter Draw Fee Amount.";
        }
        else if (this._drawFeeInvoice.Amount <= 0) {
            errorMsg = errorMsg + "<p>" + "The Draw Fee amount can not be zero or negative. You can set Draw Fee Applicable to No in the checklist if you want to skip the draw fee process.";
        }
        if (this._drawFeeInvoice.FirstName == null || this._drawFeeInvoice.FirstName == undefined || this._drawFeeInvoice.FirstName == "") {
            errorMsg = errorMsg + "<p>" + "Please enter First Name.";
        }
        if (this._drawFeeInvoice.LastName == null || this._drawFeeInvoice.LastName == undefined || this._drawFeeInvoice.LastName == "") {
            errorMsg = errorMsg + "<p>" + "Please enter Last Name.";
        }
        //if (this._drawFeeInvoice.Designation == null || this._drawFeeInvoice.Designation == undefined || this._drawFeeInvoice.Designation == "") {
        //    errorMsg = errorMsg + "<p>" + "Please enter Designation.";
        //}
        if (this._drawFeeInvoice.CompanyName == null || this._drawFeeInvoice.CompanyName == undefined || this._drawFeeInvoice.CompanyName == "") {
            errorMsg = errorMsg + "<p>" + "Please enter Company Name.";
        }
        if (this._drawFeeInvoice.Address == null || this._drawFeeInvoice.Address == undefined || this._drawFeeInvoice.Address == "") {
            errorMsg = errorMsg + "<p>" + "Please enter Address.";
        }
        if (this._drawFeeInvoice.City == null || this._drawFeeInvoice.City == undefined || this._drawFeeInvoice.City == "") {
            errorMsg = errorMsg + "<p>" + "Please enter City.";
        }
        if (this._drawFeeInvoice.StateID == null || this._drawFeeInvoice.StateID == undefined || this._drawFeeInvoice.StateID.toString() == "") {
            errorMsg = errorMsg + "<p>" + "Please select State.";
        }
        if (this._drawFeeInvoice.Zip) {
            if (!Zipexp.test(this._drawFeeInvoice.Zip)) {
                errorMsg = errorMsg + "<p>" + "Please enter valid Zip Code." + "</p>";
            }
        }
        if (!this._drawFeeInvoice.Email1) {
            errorMsg = errorMsg + "<p>" + "Please enter Borrower Primary Email Address(es)." + "</p>";
        }
        if (this._drawFeeInvoice.Email1) {
            if (this._drawFeeInvoice.Email1) {
                this._drawFeeInvoice.Email1 = this._drawFeeInvoice.Email1.replace(/,(?=\s*$)/, '');
                var drawtoemail = this._drawFeeInvoice.Email1.replace(/;/g, ",").replace(/,(?=\s*$)/, '');
                var foundemail = '';
                var foundcomma = drawtoemail.indexOf(",");
                if (foundcomma > 0) {
                    var splitemail = drawtoemail.split(",");
                    for (var k = 0; k < splitemail.length; k++) {
                        splitemail[k] = splitemail[k].replace(/\s/g, '');
                        if (splitemail[k].trim() != '') {
                            if (!Emailexp.test(String(splitemail[k]).toLowerCase())) {
                                foundemail = foundemail + splitemail[k] + ", ";
                            }
                        }
                    }
                    if (foundemail != '') {
                        errorMsg = errorMsg + "<p>" + "Please enter valid Borrower Primary Email Address(es) separated by comma/semicolon." + "</p>";
                    }
                }
                else {
                    if (this._drawFeeInvoice.Email1 != "") {
                        if (!Emailexp.test(String(this._drawFeeInvoice.Email1).toLocaleLowerCase())) {
                            errorMsg = errorMsg + "<p>" + "Please enter valid Borrower Primary Email Address(es) separated by comma/semicolon." + "</p>";
                        }
                    }
                }
            }
        }
        if (this._drawFeeInvoice.Email2) {
            this._drawFeeInvoice.Email2 = this._drawFeeInvoice.Email2.replace(/,(?=\s*$)/, '');
            var drawccemail = this._drawFeeInvoice.Email2.replace(/;/g, ",").replace(/,(?=\s*$)/, '');
            var foundemail = '';
            var foundcomma = drawccemail.indexOf(",");
            if (foundcomma > 0) {
                var splitemail = drawccemail.split(",");
                for (var k = 0; k < splitemail.length; k++) {
                    splitemail[k] = splitemail[k].replace(/\s/g, '');
                    if (splitemail[k].trim() != '') {
                        if (!Emailexp.test(String(splitemail[k]).toLowerCase())) {
                            foundemail = foundemail + splitemail[k] + ", ";
                        }
                    }
                }
                if (foundemail != '') {
                    errorMsg = errorMsg + "<p>" + "Please enter valid Borrower Cc Email Address(es) separated by comma/semicolon." + "</p>";
                }
            }
            else {
                if (this._drawFeeInvoice.Email2 != "") {
                    if (!Emailexp.test(String(this._drawFeeInvoice.Email2).toLocaleLowerCase())) {
                        errorMsg = errorMsg + "<p>" + "Please enter valid Borrower Cc Email Address(es) separated by comma/semicolon." + "</p>";
                    }
                }
            }
        }
        if (this._drawFeeInvoice.PhoneNo) {
            if (phonepattern.test(this._drawFeeInvoice.PhoneNo)) {
                this._drawFeeInvoice.PhoneNo = this._drawFeeInvoice.PhoneNo.replace(/\D+/g, '').replace(/^(\d{3})(\d{3})(\d{4}).*/, '($1) $2-$3');
            }
            if (!phoneNumberPattern.test(this._drawFeeInvoice.PhoneNo)) {
                if (this._drawFeeInvoice.PhoneNo == null || this._drawFeeInvoice.PhoneNo.length != 10 || !pattern.test(this._drawFeeInvoice.PhoneNo)) {
                    errorMsg = errorMsg + "<p>" + "Please enter valid contact number. Ex: (111) 111-1111";
                }
            }
        }
        if (this._drawFeeInvoice.AlternatePhone) {
            var unformatnum = this._drawFeeInvoice.AlternatePhone.replace(/[^\d]/g, "");
            if (unformatnum.length != 10) {
                errorMsg = errorMsg + "<p>" + "Please enter valid alternate contact number. Ex: (111) 111-1111";
            }
            else {
                this._drawFeeInvoice.AlternatePhone = this._drawFeeInvoice.AlternatePhone.replace(/\D+/g, '').replace(/^(\d{3})(\d{3})(\d{4}).*/, '($1) $2-$3');
            }
        }
        //if (!phoneNumberPattern.test(this._drawFeeInvoice.AlternatePhone)) {
        //    if (this._drawFeeInvoice.AlternatePhone.length != 10 || !pattern.test(this._drawFeeInvoice.AlternatePhone)) {
        //        errorMsg = errorMsg + "<p>" + "Please enter valid alternate contact number. Ex: (111) 111-1111";
        //    }
        //}
        errMsg = errorMsg;
        return errMsg;
    };
    WorkflowDetailComponent.prototype.saveDrawFeeInvoice = function () {
        var _this = this;
        this._isWFFetching = true;
        this.IsShowSaveAndStatusButton = false;
        this._drawFeeInvoice.TaskID = this._workflow.TaskID;
        this._drawFeeInvoice.DealName = this._wfAdditionalData.DealName;
        this._drawFeeInvoice.CreDealID = this._wfAdditionalData.CREDealID;
        this.wfSrv.CheckQBDCompanyCustomer(this._drawFeeInvoice).subscribe(function (res) {
            if (res.Succeeded) {
                if (res.DrawFeeInvoice.IsExistCompany == "1") {
                    if (res.DrawFeeInvoice.IsExistCustomer == "0") {
                        _this.wfSrv.CreateQBDcustomer(_this._drawFeeInvoice).subscribe(function (res) {
                            if (res.Succeeded) {
                                _this.InsertUpdateDrawFeeInvoice();
                            }
                            else {
                                _this.InsertUpdateDrawFeeInvoice();
                                /*
                                this._isWFFetching = false;
                                this._Showmessagediv = true;
                                this._ShowmessagedivWar = true;fche
                                this._ShowmessagedivMsgWar = 'Error in saving invoice detail';
                                this.IsShowSaveAndStatusButton = true;
                                setTimeout(function () {
                                    this._ShowmessagedivWar = false;
                                    this._ShowmessagedivMsgWar = "";
                                }.bind(this), 4000);
                                */
                            }
                        });
                    }
                    else if (_this._drawFeeInvoice.FirstName != _this._drawFeeInvoiceOrignal.FirstName ||
                        _this._drawFeeInvoice.LastName != _this._drawFeeInvoiceOrignal.LastName ||
                        _this._drawFeeInvoice.CompanyName != _this._drawFeeInvoiceOrignal.CompanyName ||
                        _this._drawFeeInvoice.Address != _this._drawFeeInvoiceOrignal.Address ||
                        _this._drawFeeInvoice.City != _this._drawFeeInvoiceOrignal.City ||
                        _this._drawFeeInvoice.StateID != _this._drawFeeInvoiceOrignal.StateID ||
                        _this._drawFeeInvoice.Zip != _this._drawFeeInvoiceOrignal.Zip) {
                        _this.wfSrv.UpdateQBDcustomer(_this._drawFeeInvoice).subscribe(function (res) {
                            if (res.Succeeded) {
                                _this.InsertUpdateDrawFeeInvoice();
                            }
                            else {
                                _this.InsertUpdateDrawFeeInvoice();
                                /*
                                this._isWFFetching = false;
                                this._Showmessagediv = true;
                                this._ShowmessagedivWar = true;
                                this._ShowmessagedivMsgWar = 'Error in saving invoice detail';
                                this.IsShowSaveAndStatusButton = true;
                                setTimeout(function () {
                                    this._ShowmessagedivWar = false;
                                    this._ShowmessagedivMsgWar = "";
                                }.bind(this), 4000);
                                */
                            }
                        });
                    }
                    else {
                        _this.InsertUpdateDrawFeeInvoice();
                    }
                }
            }
            else {
                _this._router.navigate(['login']);
            }
        });
    };
    WorkflowDetailComponent.prototype.saveDrawFeeInvoiceAndWorkFlow = function () {
        var _this = this;
        this._isWFFetching = true;
        this.IsShowSaveAndStatusButton = false;
        this._drawFeeInvoice.TaskID = this._workflow.TaskID;
        this._drawFeeInvoice.DealName = this._wfAdditionalData.DealName;
        this._drawFeeInvoice.CreDealID = this._wfAdditionalData.CREDealID;
        this.wfSrv.CheckQBDCompanyCustomer(this._drawFeeInvoice).subscribe(function (res) {
            if (res.Succeeded) {
                if (res.DrawFeeInvoice.IsExistCompany == "1") {
                    if (res.DrawFeeInvoice.IsExistCustomer == "0") {
                        _this.wfSrv.CreateQBDcustomer(_this._drawFeeInvoice).subscribe(function (res) {
                            if (res.Succeeded) {
                                _this.InsertUpdateDrawFeeInvoiceSaveWorkFlow();
                            }
                            else {
                                _this.InsertUpdateDrawFeeInvoiceSaveWorkFlow();
                                /*
                                this._isWFFetching = false;
                                this._Showmessagediv = true;
                                this._ShowmessagedivWar = true;
                                this._ShowmessagedivMsgWar = 'Error in saving invoice detail';
                                this.IsShowSaveAndStatusButton = true;
                                setTimeout(function () {
                                    this._ShowmessagedivWar = false;
                                    this._ShowmessagedivMsgWar = "";
                                }.bind(this), 4000);
                                */
                            }
                        });
                    }
                    else if (_this._drawFeeInvoice.FirstName != _this._drawFeeInvoiceOrignal.FirstName ||
                        _this._drawFeeInvoice.LastName != _this._drawFeeInvoiceOrignal.LastName ||
                        _this._drawFeeInvoice.CompanyName != _this._drawFeeInvoiceOrignal.CompanyName ||
                        _this._drawFeeInvoice.Address != _this._drawFeeInvoiceOrignal.Address ||
                        _this._drawFeeInvoice.City != _this._drawFeeInvoiceOrignal.City ||
                        _this._drawFeeInvoice.StateID != _this._drawFeeInvoiceOrignal.StateID ||
                        _this._drawFeeInvoice.Zip != _this._drawFeeInvoiceOrignal.Zip) {
                        _this.wfSrv.UpdateQBDcustomer(_this._drawFeeInvoice).subscribe(function (res) {
                            if (res.Succeeded) {
                                _this.InsertUpdateDrawFeeInvoiceSaveWorkFlow();
                            }
                            else {
                                _this.InsertUpdateDrawFeeInvoiceSaveWorkFlow();
                                /*
                                this._isWFFetching = false;
                                this._Showmessagediv = true;
                                this._ShowmessagedivWar = true;
                                this._ShowmessagedivMsgWar = 'Error in saving invoice detail';
                                this.IsShowSaveAndStatusButton = true;
                                setTimeout(function () {
                                    this._ShowmessagedivWar = false;
                                    this._ShowmessagedivMsgWar = "";
                                }.bind(this), 4000);
                                */
                            }
                        });
                    }
                    else {
                        _this.InsertUpdateDrawFeeInvoiceSaveWorkFlow();
                    }
                }
            }
            else {
                _this._router.navigate(['login']);
            }
        });
    };
    WorkflowDetailComponent.prototype.InsertUpdateDrawFeeInvoiceSaveWorkFlow = function () {
        var _this = this;
        try {
            this._isWFFetching = true;
            this._drawFeeInvoice.TaskID = this._workflow.TaskID;
            this._drawFeeInvoice.ObjectTypeID = 698;
            this._drawFeeInvoice.ObjectID = this._workflow.TaskID;
            this._drawFeeInvoice.InvoiceTypeID = 558;
            this.wfSrv.InsertUpdateDrawFeeInvoice(this._drawFeeInvoice).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.GetDrawFeeInvoiceDetailByTaskIDAndSaveWorkFlow();
                    //refresh activity log
                    _this.GetWFCommentsByTaskId(_this._workflow);
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
            this._isWFFetching = false;
        }
    };
    WorkflowDetailComponent.prototype.GetDrawFeeInvoiceDetailByTaskIDAndSaveWorkFlow = function () {
        var _this = this;
        try {
            this.wfSrv.GetDrawFeeInvoiceDetailByTaskID(this._workflow.TaskID).subscribe(function (res) {
                if (res.Succeeded) {
                    _this._drawFeeInvoice = res.DrawFeeInvoice;
                    _this._drawFeeInvoiceOrignal = JSON.parse(JSON.stringify(res.DrawFeeInvoice));
                    _this._autoSendInvoice = _this._drawFeeInvoice.AutoSendInvoice;
                    _this.SaveWorkFlow();
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
        }
    };
    WorkflowDetailComponent.prototype.enableDrawSection = function () {
        // to enable or disable controls
        if (this.rolename == 'Asset Manager' && (this._drawFeeInvoice.DrawFeeStatus == 0 || this._drawFeeInvoice.DrawFeeStatus == 692 || this._drawFeeInvoice.DrawFeeStatus == 696)) {
            this.IsDrawFeeEditClick = true;
            $("#drawFeeInvoicedivs").find('input, select, textarea, checkbox, radio').removeAttr('disabled', false);
            $("#drawFeeInvoicedivs").find('input, select, textarea, checkbox, radio').removeClass("disabledrawfee");
            $("#drawFeeInvoicedivs").find('wj-input-number').removeClass("disabledrawfee");
        }
    };
    WorkflowDetailComponent.prototype.disableDrawSection = function () {
        $('#drawFeeInvoicedivs').find('input, select, textarea, checkbox, radio').attr('disabled', true);
        $("#drawFeeInvoicedivs").find('input, select, textarea, checkbox, radio').addClass("disabledrawfee");
    };
    WorkflowDetailComponent.prototype.handleKeyDown = function (event) {
        if (event.keyCode == 13) {
            $("#btnSaveInvoice").trigger("click");
            return false;
        }
    };
    WorkflowDetailComponent.prototype.showWFNotificationDialogForReserveWorkflow = function (notificatioType) {
        var _this = this;
        this.notificatio_type = notificatioType;
        this._isShowChecklist = false;
        var msg = "";
        if (this._wfAdditionalData.Comment == undefined || this._wfAdditionalData.Comment == '') {
            msg = "<p>Comment is mandatory for draw approval process.";
            this.savedialogmsg = msg;
            this.CustomDialogteSave();
            return;
        }
        if (notificatioType == this._Final || notificatioType == this._RevisedFinal) {
            var lookupidForYes = this.lstCheckListStatusType.filter(function (x) { return x.Name.toString().toLowerCase() === 'yes'; })[0].LookupID;
            var checkListService = this._workflow.WFCheckList.filter(function (x) { return x.CheckListMasterId == 18; })[0];
            //primary user of that deal will not be able to complete if team's approval checklist item is 'Yes' regardless of the amount
            if (Number(checkListService.CheckListStatus).toString() != lookupidForYes) {
                msg = "<p>Checklist items " + checkListService.CheckListName.replace('*', '') + " should be marked as YES for completed status.";
                this.savedialogmsg = msg;
                this.CustomDialogteSave();
                return;
            }
        }
        this._bodyText = "";
        this._footerText = "";
        var clientName = "";
        var dealclientName = "";
        var emailto = "";
        var IsMultiinvestor = false;
        var ClientFundingDetail = '';
        var ClientFundingDetailText = '';
        this._activityLog = '';
        this.environmentName = this.dataService._environmentNamae != '' ? "(" + this.dataService._environmentNamae.replace("-", "").trim() + ") " : "";
        var drawnumber = (this._wfAdditionalData.Comment != '' && this._wfAdditionalData.Comment != null) ? ' - ' + this._wfAdditionalData.Comment : '';
        var drawnumberWithoutDash = (this._wfAdditionalData.Comment != '' && this._wfAdditionalData.Comment != null) ? ' ' + this._wfAdditionalData.Comment : '';
        var fundingdateMMDDYYYYPrelim = (this._wfAdditionalData.Date != undefined && this._wfAdditionalData.Date != null) ? ' - Est. Release Date: ' + this.convertDateTOMMDDYYYY(this._wfAdditionalData.Date) : '';
        var fundingdateMMDDYYYYFianl = (this._wfAdditionalData.Date != undefined && this._wfAdditionalData.Date != null) ? ' - Approved: ' + this.convertDateTOMMDDYYYY(this._wfAdditionalData.Date) : '';
        //===============
        // add checklist to popup
        var table = '<table id="noteinfo" border="1" style="border-collapse:collapse;font-size:12px;"><tr style="font-weight:bold"><td style="padding-left:5px!important;padding-right:5px!important;">Checklist</td><td style="padding-left:5px!important;padding-right:5px!important;">Status</td><td style="padding-left:5px!important;padding-right:5px!important;">Comment</td></tr>';
        var tr = "";
        for (var i = 0; i < this._workflow.WFCheckList.length; i++) {
            if (!(Number(this._workflow.WFCheckList[i].CheckListStatusText).toString() == "NaN" || Number(this._workflow.WFCheckList[i].CheckListStatusText) == 0)) {
                this._workflow.WFCheckList[i].CheckListStatus = Number(this._workflow.WFCheckList[i].CheckListStatusText);
            }
            var statustext = this.lstCheckListStatusType.filter(function (x) { return x.LookupID === _this._workflow.WFCheckList[i].CheckListStatus; })[0].Name;
            tr = tr + '<tr><td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + this._workflow.WFCheckList[i].CheckListName + '</td><td style="padding-left:5px!important;padding-right:5px!important;">' + statustext + '</td><td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + (this._workflow.WFCheckList[i].Comment == null ? '' : this._workflow.WFCheckList[i].Comment) + '</td></tr>';
        }
        table = table + tr + '</table>';
        this.checklistInTable = table;
        //
        var prelimEmails = null;
        var finalEmails = null;
        if (this._workflow.WFNotificationMasterEmail != null && this._workflow.WFNotificationMasterEmail != undefined) {
            prelimEmails = this._workflow.WFNotificationMasterEmail.filter(function (x) { return x.LookupID == 604; });
            finalEmails = this._workflow.WFNotificationMasterEmail.filter(function (x) { return x.LookupID == 605; });
        }
        //
        if (notificatioType == this._Preliminary) {
            if (prelimEmails != null && prelimEmails.length > 0) {
                if (prelimEmails[0].EmailID != '' && prelimEmails[0].EmailID != null) {
                    emailto = prelimEmails[0].EmailIDs;
                }
            }
            this._wfNotificationDetail.WFNotificationMasterID = 4;
            this._wfNotificationDetail.Subject = "Preliminary Reserve Release Notice - " + this._wfAdditionalData.DealName + drawnumber + fundingdateMMDDYYYYPrelim;
            this._bodyText = "ACORE is reviewing " + drawnumberWithoutDash.trim() + " in the amount of " + "$" + parseFloat(this._wfAdditionalData.Amount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '. ' +
                "This request is expected to be funded on " + this.convertDateToBindable(this._wfAdditionalData.Date) + ". A Final Notice will be sent once the required approvals are received.\n\n";
            this._wfNotificationDetail.WFBody = this._bodyText;
            this._notificationTittle = "Preliminary Notification";
            this.ReserveScheduleBreakDown = this.ReserveScheduleBreakDownPrelim;
        }
        else if (notificatioType == this._RevisedPreliminary) {
            if (prelimEmails != null && prelimEmails.length > 0) {
                if (prelimEmails[0].EmailID != '' && prelimEmails[0].EmailID != null) {
                    emailto = prelimEmails[0].EmailIDs;
                }
            }
            this._wfNotificationDetail.WFNotificationMasterID = 4;
            this._wfNotificationDetail.Subject = "Revised - Preliminary Reserve Release Notice - " + this._wfAdditionalData.DealName + drawnumber + fundingdateMMDDYYYYPrelim;
            this._bodyText = "ACORE is reviewing " + drawnumberWithoutDash.trim() + " in the amount of " + "$" + parseFloat(this._wfAdditionalData.Amount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '. ' +
                "This request is expected to be funded on " + this.convertDateToBindable(this._wfAdditionalData.Date) + ". A Final Notice will be sent once the required approvals are received.\n\n";
            this._wfNotificationDetail.WFBody = this._bodyText;
            this._notificationTittle = "Revised - Preliminary Notification";
            this.ReserveScheduleBreakDown = this.ReserveScheduleBreakDownPrelim;
        }
        else if (notificatioType == this._Final) {
            this._isShowChecklist = true;
            if (finalEmails != null && finalEmails.length > 0) {
                if (finalEmails[0].EmailID != '' && finalEmails[0].EmailID != null) {
                    emailto = finalEmails[0].EmailIDs;
                }
            }
            this._wfNotificationDetail.WFNotificationMasterID = 5;
            this._wfNotificationDetail.Subject = "Final Reserve Release Notice - " + this._wfAdditionalData.DealName + drawnumber + fundingdateMMDDYYYYFianl;
            this._bodyText = "ACORE has no objection to the release of reserve funds associated with " + drawnumberWithoutDash.trim() +
                ", totaling " + "$" + parseFloat(this._wfAdditionalData.Amount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") +
                ", to be released immediately.\n\nPlease confirm once funds are released.\n\n";
            this._wfNotificationDetail.WFBody = this._bodyText;
            this._notificationTittle = "Final Notification";
            if (this.commentHistory != '') {
                this._activityLog = "<b>Activity log:</b><br/>" + this.commentHistory;
            }
            this.ReserveScheduleBreakDown = this.ReserveScheduleBreakDownFinal;
        }
        else if (notificatioType == this._RevisedFinal) {
            this._isShowChecklist = true;
            if (finalEmails != null && finalEmails.length > 0) {
                if (finalEmails[0].EmailID != '' && finalEmails[0].EmailID != null) {
                    emailto = finalEmails[0].EmailIDs;
                }
            }
            this._wfNotificationDetail.WFNotificationMasterID = 5;
            this._wfNotificationDetail.Subject = "Revised - Final Reserve Release Notice - " + this._wfAdditionalData.DealName + drawnumber + fundingdateMMDDYYYYFianl;
            //vishal
            //===============
            this._bodyText = "ACORE has no objection to the release of reserve funds associated with " + drawnumberWithoutDash.trim() +
                ", totaling " + "$" + parseFloat(this._wfAdditionalData.Amount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") +
                ", to be released immediately.\n\nPlease confirm once funds are released.\n";
            this._wfNotificationDetail.WFBody = this._bodyText;
            this._notificationTittle = "Revised - Final Notification";
            if (this.commentHistory != '') {
                this._activityLog = "<b>Activity log:</b><br/>" + this.commentHistory;
            }
            this.ReserveScheduleBreakDown = this.ReserveScheduleBreakDownFinal;
        }
        this._footerText = "Thank you,\n" + this._user.FirstName + ' ' + this._user.LastName + '\n' + this._user.Email + ((this._user.ContactNo1 != '' && this._user.ContactNo1 != null) ? ' | ' + this._user.ContactNo1 : '');
        this._wfNotificationDetail.WFFooter = this._footerText;
        this._wfNotificationDetail.EnvironmentName = this.environmentName;
        this._wfNotificationDetail.Subject = this.environmentName + this._wfNotificationDetail.Subject;
        //change in subject for force funding type--need to uncomment for integration
        if (this._workflow.PurposeTypeId == 520) {
            this._wfNotificationDetail.Subject = "Force Funding – " + this._wfNotificationDetail.Subject;
        }
        var recipients = this._wfTemplateRecipient.filter(function (x) { return x.WFNotificationMasterID == _this._wfNotificationDetail.WFNotificationMasterID; });
        var Emailcc = '';
        if (this._wfAdditionalData.AMEmails.split('|')[1] != '') {
            Emailcc = this._wfAdditionalData.AMEmails.split('|')[1];
            if (recipients !== undefined && recipients != null && recipients.length > 0 && recipients[0].CC != '')
                Emailcc = Emailcc + ',' + recipients[0].CC;
        }
        else if (recipients !== undefined && recipients != null && recipients.length > 0 && recipients[0].CC != '')
            Emailcc = recipients[0].CC;
        var EmailTo = this._wfAdditionalData.AMEmails.split('|')[0];
        if (this._workflow.TaskTypeID == 719) {
            this._wfCheckLisupdated = this._wfCheckListData;
            if (this._wfCheckLisupdated.filter(function (x) { return x.CheckListMasterId == 16; })[0] != undefined) {
                var checklistAccountingYes = this._wfCheckLisupdated.filter(function (x) { return x.CheckListMasterId == 16; })[0].CheckListStatus;
                if (checklistAccountingYes == 499) {
                    EmailTo = EmailTo.replace(/^,|,$/g, '');
                    EmailTo = EmailTo + ',' + this._wfAdditionalData.AccountingEmail;
                    EmailTo = EmailTo.replace(/^,|,$/g, '');
                }
            }
            if (this._wfCheckLisupdated.filter(function (x) { return x.CheckListMasterId == 17; })[0] != undefined) {
                var checklistPropertyManagerYes = this._wfCheckLisupdated.filter(function (x) { return x.CheckListMasterId == 17; })[0].CheckListStatus;
                if (checklistPropertyManagerYes == 499) {
                    EmailTo = EmailTo.replace(/^,|,$/g, '');
                    EmailTo = EmailTo + ',' + this._workflow.PropertyManagerEmail;
                    EmailTo = EmailTo.replace(/^,|,$/g, '');
                }
            }
        }
        if (recipients !== undefined && recipients != null && recipients.length > 0 && recipients[0].TO != '')
            EmailTo = recipients[0].TO + "," + EmailTo;
        //removed amfunding team from the notification as requested by client
        // 13 dec 2019 email-Add AMfunding team in internal emails and remove them from notification.
        //if (notificatioType == this._Preliminary || notificatioType == this._RevisedPreliminary) {
        //    if (Emailcc != '') {
        //        Emailcc = Emailcc + ',' + 'amfunding@mailinator.com';
        //    }
        //    else {
        //        Emailcc = 'amfunding@mailinator.com';
        //    }
        //}
        //added new group email in cc for final notification as requested by client
        if (notificatioType == this._Final || notificatioType == this._RevisedFinal) {
            if (Emailcc != '') {
                Emailcc = Emailcc + ',' + this._wfAdditionalData.AdditionalGroupEmail;
            }
            else {
                Emailcc = this._wfAdditionalData.AdditionalGroupEmail;
            }
        }
        this._wfNotificationDetail.EmailCCIds = Emailcc;
        this._wfNotificationDetail.ReplyTo = this._user.Email;
        this._wfNotificationDetail.EmailToIds = EmailTo;
        var notificationConfig = this.notificationConfig.filter(function (x) { return x.WFNotificationMasterID == _this._wfNotificationDetail.WFNotificationMasterID; });
        this._CanChangeReplyTo = notificationConfig[0].CanChangeReplyTo;
        this._CanChangeRecipientList = notificationConfig[0].CanChangeRecipientList;
        this._CanChangeHeader = notificationConfig[0].CanChangeHeader;
        this._CanChangeBody = notificationConfig[0].CanChangeBody;
        this._CanChangeFooter = notificationConfig[0].CanChangeFooter;
        this._CanChangeSchedule = notificationConfig[0].CanChangeSchedule;
        this._wfNotificationDetail.TemplateID = notificationConfig[0].TemplateID;
        this._wfNotificationDetail.TemplateFileName = IsMultiinvestor ? "MultiInvestorNotification.html" : notificationConfig[0].TemplateFileName;
        this.ConfirmDialogBoxFor = 'Notification';
        var modalWFNotification = document.getElementById('myModalWFNotification');
        modalWFNotification.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    WorkflowDetailComponent.prototype.CompleteWorkflowViaScript = function () {
        var _this = this;
        this.CloseCompleteViaScriptPopUp();
        for (var i = 0; i < this._workflow.WFCheckList.length; i++) {
            if (!(Number(this._workflow.WFCheckList[i].CheckListStatusText).toString() == "NaN" || Number(this._workflow.WFCheckList[i].CheckListStatusText) == 0)) {
                this._workflow.WFCheckList[i].CheckListStatus = Number(this._workflow.WFCheckList[i].CheckListStatusText);
            }
        }
        this._isWFFetching = true;
        this.wfSrv.CompleteWorkflowViaScript(this._workflow).subscribe(function (res) {
            if (res.Succeeded) {
                _this._isWFFetching = false;
                var notenewcopied;
                if (window.location.href.indexOf("dealdetail/a") > -1) {
                    notenewcopied = ['dealdetail', _this._wfAdditionalData.CREDealID];
                }
                else {
                    notenewcopied = ['dealdetail/a', _this._wfAdditionalData.CREDealID];
                }
                localStorage.setItem('ClickedTabId', 'aFunding');
                localStorage.setItem('divSucessDeal', 'true');
                localStorage.setItem('divSucessMsgDeal', 'Draw approval status updated successfully');
                _this._router.navigate(notenewcopied);
            }
            else {
                _this._isWFFetching = false;
                _this._router.navigate(['login']);
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    WorkflowDetailComponent.prototype.CloseCompleteViaScriptPopUp = function () {
        var modal = document.getElementById('myModalCompleteViaScript');
        modal.style.display = "none";
    };
    WorkflowDetailComponent.prototype.showCompleteViaScriptPopUp = function () {
        var modalDelete = document.getElementById('myModalCompleteViaScript');
        modalDelete.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    WorkflowDetailComponent.prototype.UpdatePropertyManagerEmail = function () {
        var _this = this;
        try {
            var errorMsg = this.CheckValidationforPropertyManager('');
            if (errorMsg != "") {
                this.CustomAlert(errorMsg);
            }
            else {
                //
                this._isWFFetching = true;
                this._workflow.CREDealID = this._wfAdditionalData.CREDealID;
                this.wfSrv.UpdatePropertyManagerEmail(this._workflow).subscribe(function (res) {
                    if (res.Succeeded) {
                        _this._isWFFetching = false;
                        _this._Showmessagediv = true;
                        _this._ShowmessagedivMsg = 'Property manager email updated successfully';
                        setTimeout(function () {
                            this._Showmessagediv = false;
                            this._ShowmessagedivMsg = "";
                        }.bind(_this), 4000);
                    }
                    else {
                        _this._router.navigate(['login']);
                    }
                });
                (function (error) { return console.error('Error: ' + error); });
                //
            }
        }
        catch (err) {
            this._isWFFetching = false;
            console.log(err);
        }
    };
    WorkflowDetailComponent.prototype.SendInternalNotificion = function (notificatioType) {
        var _this = this;
        this._isWFFetching = true;
        this._workflow.WFAdditionalList = null;
        this.IsShowSaveAndStatusButton = false;
        this._workflow.CREDealID = this._wfAdditionalData.CREDealID;
        this._workflow.WFCheckListStatus = this.lstCheckListStatusType;
        this._workflow.FooterText = "Thank you,<br/>" + this._user.FirstName + ' ' + this._user.LastName + '<br/>' + this._user.Email + ((this._user.ContactNo1 != '' && this._user.ContactNo1 != null) ? ' | ' + this._user.ContactNo1 : '');
        this._workflow.SenderName = this._user.FirstName + ' ' + this._user.LastName;
        this.wfSrv.SendInternalNotificion(this._workflow).subscribe(function (res) {
            if (res.Succeeded) {
                _this._isRefresh = true;
                _this._isWFFetching = false;
                localStorage.setItem('divSucessWorkflow', 'true');
                localStorage.setItem('divSucessMsgWorkflow', 'Notification sent successfully');
                _this.isShowSendButton = true;
                _this.IsShowSaveAndStatusButton = true;
                var notenewcopied;
                if (window.location.href.indexOf("workflowdetail/a/") > -1) {
                    notenewcopied = ['workflowdetail', _this._wfAdditionalData.TaskID, _this._workflow.TaskTypeID];
                }
                else {
                    notenewcopied = ['workflowdetail/a', _this._wfAdditionalData.TaskID, _this._workflow.TaskTypeID];
                }
                _this._router.navigate(notenewcopied);
            }
            else {
                _this._router.navigate(['login']);
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    WorkflowDetailComponent.prototype.CancelWFNotification = function () {
        var _this = this;
        this.isShowSendButton = false;
        this._isWFFetching = true;
        //
        if (this.notificatio_type == this._Final || this.notificatio_type == this._RevisedFinal) {
            if (this._workflow.TaskTypeID == 502)
                this._wfNotificationDetail.WFNotificationMasterID = 8;
            else
                this._wfNotificationDetail.WFNotificationMasterID = 9;
            this.isShowSendButton = false;
            this._workflow.TimeZone = 'EST';
            //this._workflow.WFAdditionalList = null;
            if (this.commentHistory != '') {
                this.wfSrv.GetWFCommentsByTaskId(this._workflow).subscribe(function (res) {
                    if (res.Succeeded) {
                        _this.commentHistory = '';
                        _this._workflow.TimeZone = '';
                        _this.lstWFComments = res.lstWFComments;
                        var lstWFStatus = _this.lstWFComments.filter(function (x) { return (x.SubmitType == 496 || x.SubmitType == 498) && x.WFStatusMasterID != 1 && x.WFStatusMasterID != 2; });
                        for (var i = 0; i < _this.lstWFComments.length; i++) {
                            _this.lstWFComments[i].StatusName = (_this.lstWFComments[i].SubmitType == 496 && _this.lstWFComments[i].Comment == '' ? "rejected transaction back to " : "") + _this.FormatWFStatusName(_this.lstWFComments[i].StatusName);
                            if (((_this.lstWFComments[i].WFStatusMasterID != 1 && _this.lstWFComments[i].WFStatusMasterID != 2) || (_this.lstWFComments[i].SubmitType == 496))
                                && _this.lstWFComments[i].Comment != 'Checklist updated'
                                && _this.lstWFComments[i].Comment.indexOf("Changed the funding date") < 0 && _this.lstWFComments[i].Comment.indexOf("Changed the funding amount") < 0) {
                                if (!(_this.lstWFComments[i].DelegatedUserName == null || _this.lstWFComments[i].DelegatedUserName == "" || _this.lstWFComments[i].DelegatedUserName == undefined)) {
                                    _this.lstWFComments[i].Login = _this.lstWFComments[i].DelegatedUserName + " (on behalf of " + _this.lstWFComments[i].Login + " )";
                                }
                                _this.commentHistory += "<i>" + _this.lstWFComments[i].Login + "  " + _this.lstWFComments[i].StatusName + "  " + _this.convertDateTimeIn12Hours(_this.lstWFComments[i].CreatedDate) + " " + _this.lstWFComments[i].Abbreviation + "</i>" + "\n";
                                if (_this.lstWFComments[i].Comment != '' && _this.lstWFComments[i].Comment != 'Checklist updated') {
                                    _this.commentHistory += _this.lstWFComments[i].Comment + "\n";
                                }
                            }
                            //(this.lstWFComments[i].Comment != '' && this.lstWFComments[i].Comment != 'Checklist updated') ? this.lstWFComments[i].Comment + "\n" : '';
                        }
                        if (_this.commentHistory != '') {
                            _this._activityLog = "<b>Activity log are below:</b><br/>" + _this.commentHistory;
                            if (_this._workflow.TaskTypeID == 719 && (_this.notificatio_type == _this._Final || _this.notificatio_type == _this._RevisedFinal))
                                _this._activityLog = "<b>Activity log:</b><br/>" + _this.commentHistory;
                        }
                        _this._wfNotificationDetail.ActionType = 577;
                        _this._wfNotificationDetail.TaskID = _this._workflow.TaskID;
                        _this._wfNotificationDetail.MessageHTML = 'All,\n\n';
                        _this._wfNotificationDetail.DealName = _this._wfAdditionalData.DealName;
                        _this._wfNotificationDetail.Subject = "Cancelled – " + _this._wfNotificationDetail.Subject;
                        if (_this._wfNotificationDetail.WFHeader != undefined) {
                            //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody.replace(/\n/g, "<br>") + '<br/><br/>';
                            _this._wfNotificationDetail.MessageHTML += _this._wfNotificationDetail.WFHeader + '\n\n';
                        }
                        if (_this._workflow.SpecialInstructions != undefined && _this._workflow.SpecialInstructions != '') {
                            //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody.replace(/\n/g, "<br>") + '<br/><br/>';
                            _this._wfNotificationDetail.MessageHTML += '<span style="color: black;font-weight:bold;font-size:16px;background-color:yellow">' + _this._workflow.SpecialInstructions + '</span>' + '\n\n';
                        }
                        if (_this._wfNotificationDetail.WFBody != undefined) {
                            //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
                            if (_this._workflow.TaskTypeID == 719)
                                _this._wfNotificationDetail.MessageHTML += _this._wfNotificationDetail.WFBody;
                            else
                                _this._wfNotificationDetail.MessageHTML += _this._wfNotificationDetail.WFBody + '\n\n';
                        }
                        if (_this.delphinoteswithAmount != undefined && _this.delphinoteswithAmount != '') {
                            //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
                            _this._wfNotificationDetail.MessageHTML += _this.delphinoteswithAmount + '\n\n';
                        }
                        if (_this.noteswithAmount != undefined && _this.noteswithAmount != '') {
                            //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
                            _this._wfNotificationDetail.MessageHTML += "Details by note are below:\n" + _this.noteswithAmount + '\n\n';
                        }
                        if (_this.ReserveScheduleBreakDown != undefined && _this.ReserveScheduleBreakDown != '') {
                            //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
                            _this._wfNotificationDetail.MessageHTML += _this.ReserveScheduleBreakDown + '\n\n';
                        }
                        if (_this._activityLog != undefined) {
                            //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
                            _this._wfNotificationDetail.MessageHTML += _this._activityLog + '\n\n';
                        }
                        if (_this._workflow.AdditionalComments != undefined && _this._workflow.AdditionalComments != '') {
                            //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody.replace(/\n/g, "<br>") + '<br/><br/>';
                            _this._wfNotificationDetail.MessageHTML += _this._workflow.AdditionalComments + '\n\n';
                        }
                        //send checklist detail on final notification
                        if (_this._isShowChecklist) {
                            if (_this.checklistInTable != undefined && _this.checklistInTable != '') {
                                _this._wfNotificationDetail.MessageHTML += "Draw Approval checklist:\n\n" + _this.checklistInTable + '\n\n';
                            }
                        }
                        if (_this.noteswithAllocationAmount != undefined && _this.noteswithAllocationAmount != '') {
                            //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
                            _this._wfNotificationDetail.MessageHTML += "\n" + _this.noteswithAllocationAmount + '\n\n';
                        }
                        if (_this.noteswithAllocationPercentage != undefined && _this.noteswithAllocationPercentage != '') {
                            //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
                            _this._wfNotificationDetail.MessageHTML += "\n" + _this.noteswithAllocationPercentage + '\n\n';
                        }
                        if (_this._wfNotificationDetail.WFFooter != undefined) {
                            //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFFooter.replace(/\n/g, "<br>");
                            _this._wfNotificationDetail.MessageHTML += _this._wfNotificationDetail.WFFooter;
                        }
                        _this._wfNotificationDetail.EmailToIds = _this._wfNotificationDetail.EmailToIds.replace(/,\s*$/, "");
                        if (_this._wfNotificationDetail.EmailCCIds != null &&
                            _this._wfNotificationDetail.EmailCCIds != undefined &&
                            _this._wfNotificationDetail.EmailCCIds != '') {
                            _this._wfNotificationDetail.EmailCCIds = _this._wfNotificationDetail.EmailCCIds.replace(/,\s*$/, "");
                        }
                        else {
                            _this._wfNotificationDetail.EmailCCIds = "";
                        }
                        _this._wfNotificationDetail.UserName = _this._user.FirstName + " " + _this._user.LastName;
                        _this._wfNotificationDetail.AdditionalComments = _this._workflow.AdditionalComments;
                        _this._wfNotificationDetail.SpecialInstructions = _this._workflow.SpecialInstructions;
                        _this._wfNotificationDetail.WFCheckList = _this._workflow.WFCheckList;
                        _this._wfNotificationDetail.TaskTypeID = _this._workflow.TaskTypeID;
                        _this.wfSrv.CancelNotification(_this._wfNotificationDetail).subscribe(function (res) {
                            if (res.Succeeded) {
                                _this.isShowSendButton = true;
                                _this._isRefresh = true;
                                _this._isWFFetching = false;
                                localStorage.setItem('divSucessWorkflow', 'true');
                                localStorage.setItem('divSucessMsgWorkflow', 'Draw approval status updated successfully');
                                if (_this._isNotificationMsg) {
                                    localStorage.setItem('divSucessMsgWorkflow', 'Notification sent successfully');
                                }
                                _this.CloseWFNotificationDialog();
                            }
                            else {
                                _this._router.navigate(['login']);
                            }
                        });
                        (function (error) { return console.error('Error: ' + error); });
                    }
                    else {
                        _this._router.navigate(['login']);
                    }
                });
                //
            }
        }
        //
    };
    __decorate([
        core_1.ViewChild('flexWFCheckList'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], WorkflowDetailComponent.prototype, "flexWFCheckList", void 0);
    WorkflowDetailComponent = __decorate([
        core_1.Component({
            selector: "workflowdetail",
            templateUrl: "app/components/WorkflowDetail.html?v=" + $.getVersion(),
            providers: [dealservice_1.dealService, WFService_1.WFService, fileuploadservice_1.FileUploadService]
        }),
        __metadata("design:paramtypes", [router_1.Router,
            router_1.ActivatedRoute,
            utilityService_1.UtilityService,
            WFService_1.WFService,
            dealservice_1.dealService,
            fileuploadservice_1.FileUploadService,
            dataService_1.DataService,
            platform_browser_1.DomSanitizer])
    ], WorkflowDetailComponent);
    return WorkflowDetailComponent;
}());
exports.WorkflowDetailComponent = WorkflowDetailComponent;
var routes = [
    { path: '', component: WorkflowDetailComponent }
];
var WorkflowDetailModule = /** @class */ (function () {
    function WorkflowDetailModule() {
    }
    WorkflowDetailModule = __decorate([
        core_2.NgModule({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_core_1.WjCoreModule, wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_input_1.WjInputModule, wijmo_angular2_grid_filter_1.WjGridFilterModule],
            declarations: [WorkflowDetailComponent]
        })
    ], WorkflowDetailModule);
    return WorkflowDetailModule;
}());
exports.WorkflowDetailModule = WorkflowDetailModule;
//# sourceMappingURL=WorkflowDetail.component.js.map