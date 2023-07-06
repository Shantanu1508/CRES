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
var common_1 = require("@angular/common");
var core_1 = require("@angular/core");
var forms_1 = require("@angular/forms");
var http_1 = require("@angular/http");
var platform_browser_1 = require("@angular/platform-browser");
var router_1 = require("@angular/router");
var ng2_file_input_1 = require("ng2-file-input");
var wjcCore = require("wijmo/wijmo");
var wijmo_angular2_core_1 = require("wijmo/wijmo.angular2.core");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var wijmo_angular2_input_1 = require("wijmo/wijmo.angular2.input");
var wjcGrid = require("wijmo/wijmo.grid");
var wjcGridDetail = require("wijmo/wijmo.grid.detail");
var wijmo_angular2_grid_detail_1 = require("wijmo/wijmo.angular2.grid.detail");
var app_component_1 = require("../app.component");
var appsettings_1 = require("../core/common/appsettings");
var paginated_1 = require("../core/common/paginated");
var ActivityLog_1 = require("../core/domain/ActivityLog");
var dealfunding_1 = require("../core/domain/dealfunding");
var deals_1 = require("../core/domain/deals");
var document_1 = require("../core/domain/document");
var Module_1 = require("../core/domain/Module");
var note_1 = require("../core/domain/note");
var noteCashflowsExportDataList_1 = require("../core/domain/noteCashflowsExportDataList");
var notedetailfunding_1 = require("../core/domain/notedetailfunding");
var property_1 = require("../core/domain/property");
var Scenario_1 = require("../core/domain/Scenario");
var dataservice_1 = require("../core/services/dataservice");
var dealservice_1 = require("../core/services/dealservice");
var feeconfigurationService_1 = require("../core/services/feeconfigurationService");
var fileuploadservice_1 = require("../core/services/fileuploadservice");
var functionService_1 = require("../core/services/functionService");
var membershipservice_1 = require("../core/services/membershipservice");
var noteservice_1 = require("../core/services/noteservice");
var notificationservice_1 = require("../core/services/notificationservice");
var permissionService_1 = require("../core/services/permissionService");
var propertyservice_1 = require("../core/services/propertyservice");
var scenarioService_1 = require("../core/services/scenarioService");
var utilityService_1 = require("../core/services/utilityService");
var signalRService_1 = require("./../Notification/signalRService");
var loggingService_1 = require("./../core/services/loggingService");
var DrawFeeInvoiceDetail_1 = require("../core/domain/DrawFeeInvoiceDetail");
var WFService_1 = require("../core/services/WFService");
var DealDetailComponent = /** @class */ (function (_super) {
    __extends(DealDetailComponent, _super);
    function DealDetailComponent(ng2FileInputService, fileUploadService, dealSrv, dataSrv, noteSrv, propertySrv, notificationService, _router, _actrouting, utilityService, _location, _signalRService, _appcomponent, loggingService, membershipService, functionServiceSrv, permissionService, feeconfigurationSrv, scenarioService, sanitizer, http, wfSrv) {
        var _this = _super.call(this, 50, 1, 0) || this;
        _this.ng2FileInputService = ng2FileInputService;
        _this.fileUploadService = fileUploadService;
        _this.dealSrv = dealSrv;
        _this.dataSrv = dataSrv;
        _this.noteSrv = noteSrv;
        _this.propertySrv = propertySrv;
        _this.notificationService = notificationService;
        _this._router = _router;
        _this._actrouting = _actrouting;
        _this.utilityService = utilityService;
        _this._location = _location;
        _this._signalRService = _signalRService;
        _this._appcomponent = _appcomponent;
        _this.loggingService = loggingService;
        _this.membershipService = membershipService;
        _this.functionServiceSrv = functionServiceSrv;
        _this.permissionService = permissionService;
        _this.feeconfigurationSrv = feeconfigurationSrv;
        _this.scenarioService = scenarioService;
        _this.sanitizer = sanitizer;
        _this.http = http;
        _this.wfSrv = wfSrv;
        //  prevDealFundingList: wjcCore.CollectionView;
        _this.isReadonly = true;
        _this._isnotelevelChecked = true;
        _this._isincludefeeChecked = true;
        _this._showHidenote = false;
        _this._lstSpreadMaintenance = [];
        _this._lstSpreadMaintenancenew = [];
        _this._lstMinimumMult = [];
        _this._lstMinimumMultNew = [];
        _this._lstMinimumFee = [];
        _this._lstMinimumFeeNew = [];
        _this._lstSpreadMaintenance_note = [];
        _this._lstSpreadMaintenance_deal = [];
        _this._lstPrepayAllocations = [];
        _this.savedialogmsg = "";
        _this.lstSequence = [];
        _this.lstSequenceHistory = [];
        _this.lstNotePayruleSetup = [];
        _this.lstNotePayruleSetupSequence = [];
        _this.lstDealFundAutoSpreadDeleted = [];
        _this._isdealfundingChanged = true;
        _this._isdealfundingEdit = true;
        _this._IsCommentEntered = true;
        _this._ShowcopydivWar = false;
        _this._isnotegridEdited = false;
        _this.isIDorNameChanged = false;
        _this.isMaturityDataChanged = false;
        _this._lstChangedMaturityData = [];
        _this._isShowMinimumFee = false;
        _this._isShowFuturefunding = false;
        _this.minispreadinterestdiv = false;
        _this.spreadmaintenancediv = false;
        _this.tdopenrules = false;
        _this.divPrepayCalculationStatus = false;
        _this.divPrepayLastUpdated = false;
        _this.divPrepayCalculationLog = false;
        _this.divPrepaySystemLog = false;
        _this._formatting = true;
        _this.updatedRowNo = [];
        _this.rowsToUpdate = [];
        _this.PropupdatedRowNo = [];
        _this.ProprowsToUpdate = [];
        _this.SequenceupdatedRowNo = [];
        _this.SequencerowsToUpdate = [];
        _this.ShowHideFlagNoteSequence = false;
        _this._isShowLoader = false;
        _this._isShowHome = false;
        _this._isShowNotePayrule = false;
        _this._isShowDocImport = false;
        _this._isShowDealRules = false;
        _this._isShowDealAmort = false;
        _this._isShowPayoff = false;
        _this._isShowFeeInvoice = false;
        _this._isShowDealAdjustedtotalcommitment = false;
        _this._Showmessagediv = false;
        _this._ShowmessagedivMsg = '';
        _this._ShowmessagedivWar = false;
        _this._ShowmessagedivSequenceInfo = false;
        _this.showEquitysummary = false;
        _this._ShowmessagedivMsgWar = '';
        _this._ShowmessagedivSequenceMsgInfo = '';
        _this._Showmessagedivrule = false;
        _this._ShowmessagedivruleMsg = '';
        _this._ShowSucessdiv = false;
        _this._ShowSucessdivMsg = '';
        _this._isShowScenariodiv = false;
        _this._isShowbtnResetdiv = false;
        _this._isShowRuleTypediv = false;
        _this._dealExistMsg = '';
        _this.lrowsToUpdate = [];
        _this._disabled = true;
        _this._isShowCopyDeal = false;
        _this._isShowDealCalcPayoffPenalty = false;
        _this._isShowDownloadCashflows = false;
        _this._CritialExceptionListCount = 0;
        _this._errorMsgDateValidation = "";
        _this.DealCalcuStatus = "";
        _this.PrepayCalcStatus = "";
        _this.CalculationErorMessage = "";
        _this._isdatavalid = true;
        _this._isShowSaveDeal = false;
        _this._isShowCalcScript = false;
        _this.isPrepayCalcClicked = false;
        _this.isrowdeleted = false;
        // private _isDealSaved: boolean = false;
        _this._isFundingruleChanged = false;
        _this._lstgetallrule = [];
        _this._lstruletypedetail = [];
        _this._lstRuleTypeSetupNew = [];
        _this._lstRuleTypeSetuptobesend = [];
        _this._lstRuleTypeSetupfilter = [];
        _this.lstPrepayRuleTemplate = [];
        _this.deleteoptiontext = "";
        _this.LastPurposeType = "";
        _this._isDeleteOPtionOk = false;
        _this._isShowLastUpdateFFMsg = false;
        _this._isCallConcurrentCheck = false;
        _this._isRuleTabClicked = false;
        //Doc Import
        _this.isProcessComplete = false;
        _this.myFileInputIdentifier = "tHiS_Id_IS_sPeeCiAL";
        _this.actionLog = "";
        _this.errors = [];
        _this._ShowdivMsgWar = false;
        _this.dragAreaClass = 'dragarea';
        _this.projectId = 0;
        _this.sectionId = 0;
        _this.fileExt = "JPG, JPEG, PNG, XLS, XLSX, CSV, PDF, DOC, DOCX";
        _this.maxFiles = 5;
        _this.maxSize = 5; // 15MB
        _this.uploadStatus = new core_1.EventEmitter();
        _this._isDocumentListFetching = false;
        _this._dvEmptyDocumentMsg = false;
        _this.IsOpenDocImportTab = false;
        _this._isShowActivityLog = false;
        _this.IsOpenActivityTab = false;
        _this._pageSizeActivity = 20;
        _this._pageIndexActivity = 1;
        _this._totalCountActivity = 0;
        _this.CurrentcountActivity = 0;
        _this.currentactivity = new Array();
        _this.arrActivity = new Array();
        _this.arrActivityArrangeByDate = new Array();
        _this.arrActivityToday = new Array();
        _this.arrActivityTodayMore = new Array();
        _this.arrActivityYesterday = new Array();
        _this.arrActivityYesterdayMore = new Array();
        _this.isActivityTday = false;
        _this.isActivityYday = false;
        _this.isActivityPday = false;
        _this._pageSizeDocImport = 30;
        _this._pageIndexDocImport = 1;
        _this._totalCountDocImport = 0;
        _this.CurrentcountDocImport = 0;
        _this.isScrollHandlerAdded = false;
        _this._isReadOnlyRuleTypeName = true;
        _this._lstprepayadjustment = [];
        _this._lstprepayadjustmentNew = [];
        _this.noteCount = 0;
        _this._lstprepaypremium = [];
        _this._lstprepayCalculationLog = [];
        _this._lstloggedFile = [];
        _this.Noteobj = [];
        _this.NoteRuleobj = [];
        _this._allowRules = false;
        _this._isfixedvaluechanged = false;
        _this.gendynamicColList = [];
        _this.deletedynamicList = [];
        // used to hide show controls for asset manager
        _this._disabledTotalCommitment = true;
        _this._disabledTotalCommitmentAdjustment = true;
        _this._disabledComment = true;
        _this._isShowAddFundingSequence = false;
        _this._isShowAddRePaymentSequence = false;
        _this._isReadOnlyFundingRules = true;
        _this._isvalidateHolidaySatSun = true;
        _this.ShowUseRuleN = false;
        _this.dealfundingColPositionDate = "2";
        _this.dealfundingColPositionAmount = "3";
        _this.dealfundingColPositionPurpose = "6";
        _this.dealfundingColPositionWire = "7";
        _this.dealfundingColPositionComment = "10";
        _this._isShowDownloadExportToServicer = false;
        _this.lstNoteListForDealAmort = [];
        _this.deldynamicautopreadruleCol = [];
        _this.checked = false;
        _this.IsAutoSpreadActive = true; //Used to manage deal funding grid
        _this._isautospreadshow = false; //Used From DB
        _this.lstAmortSequence = [];
        _this._isshowworkflowcheckbox = true;
        // isAmortEnable: boolean = false;
        _this.isAmortFirstLoad = false;
        _this.dynamicAmortColumn = [];
        _this._isreadonlyforfixedpaymentamort = true;
        _this._isreadonlyforperiodicstraightline = true;
        _this._amortmsg = false;
        _this._autospreadgenerate = false;
        _this._isAmortSchChanges = false;
        _this._isMattabclicked = false;
        _this.IsShowAmortGenerate = false;
        _this._NoAmortSch = false;
        _this.listAdjustedTotalCommitment = [];
        _this._issaveadjustedcommitment = false;
        _this._showadminpanel = false;
        _this._isShowCancel = true;
        _this._isamortsequenceadded = false;
        _this._isShowSaveDealAllowForThisRole = false;
        _this._dynamicColumnCountonFundingRules = 31;
        _this._autoTotalComitted = 0;
        _this._autoTotalContriToDate = 0;
        _this._autoSumAdditionalEquity = 0;
        // public lstAutoEquity: Array<AutoEquity>;
        _this._showtotalcommitmentdelcol = false;
        _this._isReadOnlyTotalCommitment = true;
        _this.sumRequiredEquity = 0;
        _this.sumAdditionalEquity = 0;
        _this._isReadOnlyNoteLevelTotalCommitment = true;
        _this._isautospreadRepaymentshow = false;
        _this._lstprojectedpayoffdates = [];
        _this.repaymentchecked = false;
        _this.autospreadRepaymentsDealfields = [];
        _this._isReadOnlyBSDatesFields = false;
        _this.lstprojectedpayoffDBdata = [];
        _this._isautospreadrepaydataChanged = false;
        _this._isrepaymentChanged = false;
        _this._isShowMsgForInvoices = false;
        _this.showBSMsg = '';
        _this._ShowBSData = false;
        _this.checkboxclicked = false;
        _this._isInvoiceTabclicked = false;
        _this._ispaidofdeal = false;
        _this._isShowDealMaturity = false;
        _this._isShowDealPrepaymentPremium = false;
        _this.maturityList = [];
        _this.originalMaturityList = [];
        _this.maturityTypeList = [];
        _this.maturityApprovedList = [];
        _this.noteMaturityList = [];
        _this._lstUpdatedEquitySummary = [];
        _this._isMaturityTabClicked = false;
        _this._isSetHeaderEmpty = false;
        _this._isPeriodicDataFetched = true;
        _this.calcExceptionMsg = "Error occurred";
        _this._dvEmptyPeriodicDataMsg = false;
        _this._isActualpayoffDate = false;
        _this._isAMUser = false;
        _this.otherMaturityTypeList = [];
        _this.userRolename = '';
        _this._isMaturityError = '';
        _this.ShowHideFlagMaturitySchedule = false;
        _this._isvalidateMaturityHoliday = true;
        _this._isshowApplyNoteLevelPaydowns = false;
        _this.currentMaturityEffectivedate = null;
        _this.previousMaturityType = '';
        _this.lstReserveSchedulePurposeType = [];
        _this.lstGeneratedBy = [];
        _this.lstPrePaymentName = [];
        _this.lstSpreadCalctMethodName = [];
        _this.lstBaseAmountName = [];
        _this._isShowReserveTab = false;
        _this.reserveAccountsList = [];
        _this.reserveScheduleList = [];
        _this._isReserveTabClicked = false;
        _this._isReserveValidation = '';
        _this._isPrepaymentTabClicked = false;
        _this._isPrepaymentmethodClicked = false;
        _this._isAdjustedTotalCommitmentTabClicked = false;
        _this.reserveScheduleDynamicColValues = [];
        _this.reserveScheduleDynamicCol = [];
        _this._isReserveScheduleValidation = '';
        _this._listdeletedReserveSchedule = [];
        _this.originalReserveSchedulelst = [];
        _this.showReserveScheduleGrid = false;
        _this.showREODealCheckbox = false;
        _this.lstMaturityConfiguration = [];
        _this.lstGroupName = [];
        _this.lstMaturityMethodID = [];
        _this.selectedGroupName = '';
        _this._isMaturityConfigUpdated = false;
        _this.maturityEffectiveDateslst = [];
        _this._ShowmaturitydivMessageWar = '';
        _this._ShowmaturitydivWar = false;
        _this.isShowgenerateButton = false;
        _this.currentEstimatedBalanceColPasted = false;
        _this.isroleAssetManager = false;
        _this.isShowGenerateAutospreadRepay = false;
        _this.maturityOtherFieldsList = [];
        _this.ClickedTab = '';
        _this.detailMode = wjcGridDetail.DetailVisibilityMode[wjcGridDetail.DetailVisibilityMode.ExpandSingle];
        _this.cellRuleTypeEditHandler = function (s, e) {
            var col = s.columns[e.col];
            if (col.binding == 'FileName') {
                var RuleTypeName = s.rows[e.row].dataItem.RuleTypeName;
                switch (RuleTypeName) {
                    case RuleTypeName:
                        this.lstRuleTypebyruleid = this._lstruletypedetail.filter(function (x) { return x.RuleTypeName == RuleTypeName; });
                        this.lstRuleTypebyruleid.sort(this.sortByName);
                        col.dataMap = this._buildDataMapWithoutLookupForRuleType(this.lstRuleTypebyruleid);
                        break;
                }
            }
        };
        _this._isshowworkflow = true;
        _this._drawFeeInvoice = new DrawFeeInvoiceDetail_1.DrawFeeInvoiceDetail("");
        _this._moduledelete = new Module_1.Module('');
        _this._scenariodc = new Scenario_1.Scenario('');
        _this._moduledelete.LookupID = 0;
        //this.GetAllowRules();
        //this.getFastFolderList();
        _this.getAllDistinctScenario();
        var dealId;
        _this._actrouting.params.forEach(function (params) {
            if (params['id'] !== undefined) {
                dealId = params['id'];
                _this._deal = new deals_1.deals(dealId);
            }
            if (params['tab'] !== undefined) {
                _this.SetActiveTab(params['tab']);
            }
        });
        _this._user = JSON.parse(localStorage.getItem('user'));
        if (_this._user.RoleName == 'Asset Manager') {
            $('#EnableAutoSpreadRepayments').attr("disabled", "disabled");
            _this.isroleAssetManager = true;
        }
        else {
            _this.isroleAssetManager = false;
            $('#EnableAutoSpreadRepayments').removeAttr('disabled');
        }
        _this._activityLog = new ActivityLog_1.ActivityLog('');
        _this._deal = new deals_1.deals(dealId);
        _this._deal.amort = new deals_1.Amort();
        _this._dealArchieve = new deals_1.deals(dealId);
        _this._deal.CREDealID = dealId;
        _this.getUsersByRoleName();
        _this.getAllPropertyType();
        _this.getAllLoanStatus();
        _this._deal.DealID = _this._deal.DealID.length != 36 ? '00000000-0000-0000-0000-000000000000' : _this._deal.DealID;
        _this.fetChDeal(_this._deal);
        _this.rolename = window.localStorage.getItem("rolename");
        _this.Dealfuturefunding = new deals_1.deals(dealId);
        _this.note = new note_1.Note('');
        _this.property = new property_1.Property('');
        _this.dealfunding = new dealfunding_1.DealFunding('');
        _this.Notedetailfunding = new notedetailfunding_1.notedetailfunding('');
        _this._noteCashflowsExportDataList = new noteCashflowsExportDataList_1.NoteCashflowsExportDataList();
        //this.DynamicColData();
        _this._currentDate = new Date();
        _this._ruletype = new Scenario_1.RuleType;
        _this.columns = [
            //{ header: 'Note Id', binding: 'CRENoteID', width: '*', allowEditing: false, },
            { header: 'Name', binding: 'Name', width: '*', allowEditing: false },
            { header: 'Maturity', binding: 'Maturity', width: '*', format: 'M/d/yyyy', allowEditing: false, align: 'right' },
            { header: 'Lien Position', binding: 'LienPositionText', width: '*', allowEditing: false },
            { header: 'Priority', binding: 'Priority', width: '*', allowEditing: false },
            { header: 'Estimated current balance', binding: 'EstBls', width: '*', format: 'n2', aggregate: 'Sum', allowEditing: false },
            { header: 'Current PIK Balance', binding: 'CurrentPIKBalance', width: '*', format: 'n2', aggregate: 'Sum', allowEditing: false },
            { header: 'Total commitment', binding: 'TotalCommitment', width: '*', format: 'n2', aggregate: 'Sum', allowEditing: false },
            { header: 'Adjusted Commitment', binding: 'AdjustedTotalCommitment', width: '*', format: 'n2', aggregate: 'Sum', allowEditing: false },
            // { header: 'Aggregated Total Commitment', binding: 'AggregatedTotal', width: '*', format: 'n2', aggregate: 'Sum', allowEditing: false },
            { header: 'Initial funding amount', binding: 'InitialFundingAmount', width: '*', format: 'n2', aggregate: 'Sum', allowEditing: false },
            // { header: 'Initial Required Equity', binding: 'InitialRequiredEquity', width: '*', format: 'n2', aggregate: 'Sum', allowEditing: false },
            // { header: 'Initial Additional Equity', binding: 'InitialAdditionalEquity', width: '*', format: 'n2', aggregate: 'Sum', allowEditing: false },
            { header: 'Use rule to determine note funding', binding: 'UseRuletoDetermineNoteFundingText', width: '*', allowEditing: true },
            //{ header: 'Note funding rule', binding: 'NoteFundingRuleText', width: '*', allowEditing: true },
            { header: 'Funding priority', binding: 'FundingPriority', width: '*', allowEditing: true },
            //{ header: 'Note balance cap', binding: 'NoteBalanceCap', width: '*', format: 'n2', aggregate: 'Sum', allowEditing: true },
            { header: 'Repayment priority', binding: 'RepaymentPriority', width: '*', allowEditing: true }
        ];
        _this.columnsForPayruleSetup = [
            { header: 'Note id', binding: 'FromNote', width: 150 },
            { header: 'Rule', binding: 'RuleText', width: 150 },
        ];
        _this.columnsForNoteDealFunding = [];
        _this.columnsAmortSchedule = [];
        _this.AmortSeqcolumns = [];
        _this.columnsforCommitmentAdjustment = [];
        var _date = new Date();
        _this._dtUTCHours = _date.getTimezoneOffset() / 60; //_date.getUTCHours();
        //alert('date getTimezoneOffset' + _date.getTimezoneOffset() );
        _this._userOffset = _date.getTimezoneOffset() * 60 * 1000; // user's offset time
        if (_this._dtUTCHours < 6) {
            _this._centralOffset = 6 * 60 * 60 * 1000; // 6 for central time - use whatever you need
        }
        else {
            _this._centralOffset = _this._dtUTCHours * 60 * 60 * 1000; // 6 for central time - use whatever you need
        }
        _this._document = new document_1.Document();
        _this._document.DocumentTypeID = "406";
        //show save deal message
        if (localStorage.getItem('ShowSaveMsg') == 'show') {
            localStorage.setItem('divSucessDeal', JSON.stringify(false));
            _this._Showmessagediv = true;
            _this._ShowmessagedivMsg = "Deal Saved Successfully";
            //Set active tab
            var ActiveTabID = localStorage.getItem('ClickedTabId');
            setTimeout(function () {
                document.getElementById(ActiveTabID).click();
                //localStorage.setItem('ClickedTabId', 'aMain');
            }.bind(_this), 3000);
            localStorage.setItem('ShowSaveMsg', 'hide');
            setTimeout(function () {
                this._Showmessagediv = false;
                this._ShowmessagedivMsg = "";
            }.bind(_this), 4000);
        }
        else if (_this.ClickedTab != '') {
            var ActiveTabID = _this.ClickedTab;
            setTimeout(function () {
                document.getElementById(ActiveTabID).click();
                this.ClickedTab = '';
                //localStorage.setItem('ClickedTabId', 'aMain');
            }.bind(_this), 3000);
        }
        else {
            localStorage.setItem('ClickedTabId', 'aMain');
        }
        //show sucess message
        //alert(localStorage.getItem('divSucessDeal'));
        if (localStorage.getItem('divSucessDeal') == 'true') {
            _this._ShowSucessdiv = true;
            _this._ShowSucessdivMsg = 'Draw approval status updated successfully'; //localStorage.getItem('divSucessMsgDeal');
            //alert(this._ShowSucessdivMsg);
            //this._ShowSucessdivMsg = (this._ShowmessagedivMsg.replace('\"', '')).replace('\"', '');
            //Set active tab
            var ActiveTabID = localStorage.getItem('ClickedTabId');
            setTimeout(function () {
                this._ShowSucessdiv = false;
                localStorage.setItem('divSucessDeal', JSON.stringify(false));
                localStorage.setItem('divSucessMsgDeal', JSON.stringify(''));
                document.getElementById(ActiveTabID).click();
            }.bind(_this), 5000);
        }
        //show delete message from admin panel
        if (localStorage.getItem('ShowDeleteMsg') == 'true') {
            localStorage.setItem('divSucessDeal', JSON.stringify(false));
            _this._Showmessagediv = true;
            var msg = localStorage.getItem('divdeleteMsgDeal');
            _this._ShowmessagedivMsg = msg.substring(1, msg.length - 1);
            //Set active tab
            var ActiveTabID = localStorage.getItem('ClickedTabId');
            setTimeout(function () {
                document.getElementById(ActiveTabID).click();
            }.bind(_this), 3000);
            setTimeout(function () {
                localStorage.setItem('ShowDeleteMsg', JSON.stringify(false));
                localStorage.setItem('divdeleteMsgDeal', JSON.stringify(''));
                this._Showmessagediv = false;
                this._ShowmessagedivMsg = "";
            }.bind(_this), 4000);
        }
        else {
            localStorage.setItem('ClickedTabId', 'aMain');
        } //end delete message from admin panel
        _this.columnsforReserveSchedule = [];
        return _this;
    }
    DealDetailComponent.prototype.ngOnInit = function () {
        this.returnUrl = this._actrouting.snapshot.queryParams['returnUrl'] || '/';
    };
    DealDetailComponent.prototype.AfterViewInit = function () {
        //reset ng2-file-input control after error occoured
        this.resetFileInput();
    };
    // Component views are initialized
    DealDetailComponent.prototype.ngAfterViewInit = function () {
        var _this = this;
        //stop input (number type) control 'Scroll Wheel' feature
        setTimeout(function () {
            $('input[type=number]').each(function () {
                var el = document.getElementById(($(this).attr("id")));
                if (el) {
                    el.addEventListener('wheel', function (e) {
                        e.preventDefault(); // prevent event
                        e.stopImmediatePropagation(); // stop propogation
                    }, true);
                }
            });
            $(".ibox1").each(function () {
                var el = document.getElementById(($(this).attr("id")));
                if (el) {
                    el.addEventListener('wheel', function (e) {
                        e.preventDefault(); // prevent event
                        e.stopImmediatePropagation(); // stop propogation
                    }, true);
                }
            });
        }.bind(this), 2000);
        ////Tool Tip for Commitment/Equity 
        if (this.flexadjustedtotalcommitment) {
            var toolTip_1 = new wjcCore.Tooltip();
            this.flexadjustedtotalcommitment.hostElement.addEventListener("mouseover", function (e) {
                var ht = _this.flexadjustedtotalcommitment.hitTest(e), rng = null;
                if (!ht.range.equals(rng)) {
                    // Checks to make sure that we're in the ColumnHeader row
                    if (ht.cellType == 2) {
                        rng = ht.range;
                        var data = _this.flexadjustedtotalcommitment.getCellData(rng.row, rng.col, true), cellElement = document.elementFromPoint(e.clientX, e.clientY), cellBounds = wjcCore.Rect.fromBoundingRect(cellElement.getBoundingClientRect()), tipContent = void 0;
                        for (var i = 0; i < _this.lstNote.length; i++) {
                            if (cellElement.innerHTML == _this.lstNote[i].CRENoteID) {
                                tipContent = _this.lstNote[i].Name;
                            }
                        }
                        toolTip_1.show(_this.flexadjustedtotalcommitment.hostElement, tipContent, cellBounds);
                    }
                }
            });
            this.flexadjustedtotalcommitment.hostElement.addEventListener("mouseout", function (e) {
                toolTip_1.hide();
            });
        }
    };
    DealDetailComponent.prototype.AddcolumnNotePayruleSetup = function (header, binding) {
        try {
            this.columnsForPayruleSetup.push({ "header": header, "binding": binding, "format": 'p2' });
        }
        catch (err) { }
    };
    //Use Rule N 
    DealDetailComponent.prototype.AddcolumnNoteDealFunding = function (header, binding, allowEdit) {
        try {
            this.columnsForNoteDealFunding.push({ "header": header, "binding": binding, "format": 'n2', "aggregate": 'Sum', "allowEditing": allowEdit });
        }
        catch (err) { }
    };
    DealDetailComponent.prototype.AddcolumnAmortSchedule = function (header, binding, allowEdit) {
        try {
            this.columnsAmortSchedule.push({
                "header": header, "binding": binding, "format": 'n2', "aggregate": 'Sum', "allowEditing": allowEdit
            });
        }
        catch (err) { }
    };
    DealDetailComponent.prototype.AddcolumnAdjustedTotalCommitment = function (header, binding, allowEdit) {
        try {
            this.columnsforCommitmentAdjustment.push({
                "binding": binding, "header": header, "format": 'n2', "aggregate": 'Sum', allowEditing: allowEdit
            });
        }
        catch (err) { }
    };
    DealDetailComponent.prototype.AddcolumnReserveSchedule = function (header, binding) {
        try {
            this.columnsforReserveSchedule.push({
                "binding": binding, "header": header, "format": 'n2', "aggregate": 'Sum'
            });
        }
        catch (err) { }
    };
    DealDetailComponent.prototype.GetNotePayruleSetupDataByDealID = function (dealid) {
        var _this = this;
        try {
            this.dealSrv.GetNotePayruleSetupDataByDealID(dealid).subscribe(function (res) {
                if (res.Succeeded) {
                    var header = [];
                    var objSum = 0;
                    _this.dynamicColListPayrule = [];
                    var data = res.PayruleSetupData;
                    data.sort(_this.SortByNoteID);
                    _this.lstNotePayruleSetup = data;
                    _this.cvNotePayruleSetup = new wjcCore.CollectionView(data);
                    $.each(data, function (obj) {
                        var i = 0;
                        $.each(data[obj], function (key, value) {
                            //alert("key :" + key + " value :" + value);
                            header[i] = key;
                            i = i + 1;
                        });
                        return false;
                    });
                    _this.dynamicColListPayrule = header;
                    //Pushing column in grid --- length-3  as noteID are
                    for (var j = 0; j < header.length; j++) {
                        if (header[j] != "FromNote" && header[j] != "RuleID" && header[j] != "RuleText") {
                            _this.AddcolumnNotePayruleSetup(header[j], header[j]);
                            if (_this.lstNotePayruleSetup[0][header[j]] == null) {
                                _this.lstNotePayruleSetup[0][header[j]] = 0;
                            }
                        }
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
    DealDetailComponent.prototype.ConvertInSequenceListForPayruleSetup = function () {
        this.lstNotePayruleSetupSequence = [];
        this.lstNotePayruleSetupSequence.push({ "DealID": 0, "StripTransferFrom": 0, "StripTransferTo": 0, "Value": 0, "RuleID": 0 });
        for (var i = 2; i < (this.columnsForPayruleSetup.length) - 1; i++) //StripTransferTo are starting from 2 (Column)
         {
            for (var j = 0; j < this.lstNotePayruleSetup.length; j++) //(Row)
             {
                if (this.lstNotePayruleSetup[j][this.columnsForPayruleSetup[i].binding] != 0 && this.lstNotePayruleSetup[j][this.columnsForPayruleSetup[i].binding] != null) //For non 0 values
                 {
                    //From NoteID
                    var fromNoteName = this.lstNotePayruleSetup[j][this.columnsForPayruleSetup[0].binding];
                    var toNoteName = this.columnsForPayruleSetup[i].header;
                    var FromNoteID = this.lstSequenceHistory.filter(function (obj) {
                        return obj.CRENoteID === fromNoteName;
                    })[0];
                    var ToNoteID = this.lstSequenceHistory.filter(function (obj) {
                        return obj.CRENoteID === toNoteName;
                    })[0];
                    this.lstNotePayruleSetupSequence.push({ "DealID": this.note.DealID, "StripTransferFrom": FromNoteID.NoteID, "StripTransferTo": ToNoteID.NoteID, "Value": this.lstNotePayruleSetup[j][this.columnsForPayruleSetup[i].binding], "RuleID": this.lstNotePayruleSetup[j].RuleID });
                }
            }
        }
        //delete first row from list
        this.lstNotePayruleSetupSequence.splice(0, 1);
    };
    //NotePayruleSetup Code END
    DealDetailComponent.prototype.ConvertInDealFundingList = function () {
        this.listdealfundingSave = [];
        this.listdealfundingSave.push({ "DealID": 0, "Date": 0, "StripTransferTo": 0, "Value": 0, "RuleID": 0 });
        for (var i = 2; i < this.columnsForPayruleSetup.length; i++) //StripTransferTo are starting from 2 (Column)
         {
            for (var j = 0; j < this.lstNotePayruleSetup.length; j++) //(Row)
             {
                if (this.lstNotePayruleSetup[j][this.columnsForPayruleSetup[i].binding] != 0 && this.lstNotePayruleSetup[j][this.columnsForPayruleSetup[i].binding] != null) //For non 0 values
                 {
                    //From NoteID
                    var fromNoteName = this.lstNotePayruleSetup[j][this.columnsForPayruleSetup[0].binding];
                    var toNoteName = this.columnsForPayruleSetup[i].header;
                    var FromNoteID = this.lstSequenceHistory.filter(function (obj) {
                        return obj.CRENoteID === fromNoteName;
                    })[0];
                    var ToNoteID = this.lstSequenceHistory.filter(function (obj) {
                        return obj.CRENoteID === toNoteName;
                    })[0];
                    this.lstNotePayruleSetupSequence.push({ "DealID": this.note.DealID, "StripTransferFrom": FromNoteID.NoteID, "StripTransferTo": ToNoteID.NoteID, "Value": this.lstNotePayruleSetup[j][this.columnsForPayruleSetup[i].binding], "RuleID": this.lstNotePayruleSetup[j].RuleID });
                }
            }
        }
        //delete first row from list
        this.lstNotePayruleSetupSequence.splice(0, 1);
    };
    //Sequence Code START
    DealDetailComponent.prototype.Addcolumn = function (header, binding) {
        try {
            this.columns.push({ "header": header, "binding": binding, "format": 'n2', "aggregate": 'Sum', "allowEditing": true });
        }
        catch (err) { }
    };
    DealDetailComponent.prototype.NextSequenceToAdd = function (SequenceType) {
        //var SequenceType = "Funding Sequence ";
        var SequenceNo = 1;
        var NewSeqNo = 1;
        var binding = "";
        if (SequenceType == "Funding sequence ") {
            this.NoOfFunSeqAdded = this.NoOfFunSeqAdded + 1;
            NewSeqNo = this.NoOfFunSeqAdded;
            binding = "FundingSeq";
        }
        else //"Repayment Sequence "
         {
            this.NoOfRepSeqAdded = this.NoOfRepSeqAdded + 1;
            NewSeqNo = this.NoOfRepSeqAdded;
            binding = "RepaymentSeq";
        }
        var SeqNo = 0;
        var data = this.lstSequenceHistory;
        this.dynamicFundingList = [];
        var tempheader = [];
        $.each(data, function (obj) {
            var i = 0;
            $.each(data[obj], function (key, value) {
                tempheader[i] = key;
                i = i + 1;
            });
            return false;
        });
        this.dynamicFundingList = tempheader;
        if (NewSeqNo <= 5) {
            for (var i = 0; i < this.dynamicFundingList.length; i++) {
                if (this.dynamicFundingList[i].includes(SequenceType)) {
                    SeqNo = parseInt(this.dynamicFundingList[i].replace(SequenceType, ""));
                    if (SeqNo > SequenceNo)
                        SequenceNo = SeqNo + 1;
                }
            }
            SequenceNo = SeqNo + NewSeqNo;
            var header = SequenceType + SequenceNo;
            binding = binding + NewSeqNo;
            this.columns.push({ "header": header, "binding": binding, "format": 'n2', "width": 170, "aggregate": 'Sum', "allowEditing": true });
        }
        else {
            this._ShowmessagedivSequenceInfo = true;
            this._ShowmessagedivSequenceMsgInfo = "You can add only 5 sequences at a time. Please save the deal and try again.";
            setTimeout(function () {
                this._ShowmessagedivSequenceInfo = false;
            }.bind(this), 5000);
        }
    };
    DealDetailComponent.prototype.ConvertInSequenceList = function () {
        this.lstSequence = [];
        this.lstSequence.push({ "NoteID": 0, "SequenceNo": 0, "SequenceType": 0, "SequenceTypeText": 0, "Value": 0, "NoteName": 0 });
        for (var i = 10; i < this.columns.length; i++) //Sequence are starting from 7
         {
            for (var j = 0; j < this.lstSequenceHistory.length; j++) {
                if (this.lstSequenceHistory[j].hasOwnProperty(this.columns[i].binding)) {
                    var colHeader = this.columns[i].header;
                    var FunSequenceType = "Funding sequence ";
                    var RepSequenceType = "Repayment sequence ";
                    var SeqNo = 0;
                    if (colHeader.indexOf(FunSequenceType) > -1) {
                        SeqNo = parseInt(colHeader.replace(FunSequenceType, ""));
                        this.lstSequence.push({ "NoteID": this.lstSequenceHistory[j].NoteID, "SequenceNo": SeqNo, "SequenceType": 258, "SequenceTypeText": 'Funding Sequence', "Value": this.lstSequenceHistory[j][this.columns[i].binding], "NoteName": this.lstSequenceHistory[j].NoteName });
                    }
                    //For repayment
                    if (colHeader.indexOf(RepSequenceType) > -1) {
                        SeqNo = parseInt(colHeader.replace(RepSequenceType, ""));
                        this.lstSequence.push({ "NoteID": this.lstSequenceHistory[j].NoteID, "SequenceNo": SeqNo, "SequenceType": 259, "SequenceTypeText": 'Repayment Sequence', "Value": this.lstSequenceHistory[j][this.columns[i].binding], "NoteName": this.lstSequenceHistory[j].NoteName });
                    }
                }
            }
        }
        //delete first row from list
        this.lstSequence.splice(0, 1);
    };
    DealDetailComponent.prototype.GetNoteSequenceHistoryByDealID = function (_objDeal) {
        var _this = this;
        try {
            this.dealSrv.GetNoteSequenceHistoryByDealID(_objDeal).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.dynamicColList = [];
                    var header = [];
                    var data = res.lstFundingRepaymentSequenceHistory;
                    data.sort(_this.SortByNoteID);
                    _this.lstSequenceHistory = data;
                    //for (var i = 0; i < this.lstSequenceHistory.length; i++) {
                    //    this.lstSequenceHistory[i].AggregatedTotal = this.lstSequenceHistory[i].TotalCommitment + this.lstSequenceHistory[i].AdjustedTotalCommitment;
                    //}
                    _this.ConvertToBindableDateNoteMaturity(_this.lstSequenceHistory);
                    //alert("after data fetch");
                    $.each(data, function (obj) {
                        var i = 0;
                        $.each(data[obj], function (key, value) {
                            header[i] = key;
                            i = i + 1;
                        });
                        return false;
                    });
                    _this.dynamicColList = header;
                    //Pushing column in grid
                    for (var j = _this._dynamicColumnCountonFundingRules; j < header.length; j++) {
                        _this.Addcolumn(header[j], header[j]);
                    }
                    if (_this._deal.EnableAutoSpread) {
                        _this.getAutoSpreadRuleByDealID(_this._deal);
                    }
                    //Use Rule N
                    var lstUseRuleN = _this.lstSequenceHistory.filter(function (x) { return x.UseRuletoDetermineNoteFundingText == "3" || x.UseRuletoDetermineNoteFundingText == "Y"; });
                    var lstUseRuleY = _this.lstSequenceHistory.filter(function (x) { return x.UseRuletoDetermineNoteFundingText == "4" || x.UseRuletoDetermineNoteFundingText == "N" || x.UseRuletoDetermineNoteFunding == null; });
                    if (lstUseRuleN.length == 0) {
                        _this.ShowUseRuleN = true;
                        _this._deal.ShowUseRuleN = true;
                        _this._isautospreadshow = false;
                        _this._isshowApplyNoteLevelPaydowns = true;
                        _this._isautospreadRepaymentshow = false;
                        _this.checked = false;
                    }
                    if (lstUseRuleY.length == 0) {
                        _this.ShowUseRuleN = false;
                        _this._deal.ShowUseRuleN = false;
                        _this._isshowApplyNoteLevelPaydowns = false;
                        _this._isautospreadshow = true;
                        _this._isautospreadRepaymentshow = false;
                        if (_this._deal.EnableAutoSpread == true) {
                            _this.checked = true;
                            _this.showEquitysummary = true;
                        }
                    }
                    if (lstUseRuleY.length > 0) {
                        if (_this._deal.EnableAutospreadRepayments == true) {
                            _this._isautospreadRepaymentshow = true;
                        }
                        _this._isshowApplyNoteLevelPaydowns = true;
                    }
                    if (lstUseRuleN.length > 0) {
                        _this._isautospreadshow = true;
                        _this._isshowApplyNoteLevelPaydowns = false;
                        if (_this._deal.EnableAutoSpread == true) {
                            _this.checked = true;
                        }
                    }
                    _this.GetDealFundingByDealID(_this._deal);
                    _this.NoOfFunSeqAdded = 0;
                    _this.NoOfRepSeqAdded = 0;
                    if (_this.grdflexDynamicColForSequence) {
                        _this.grdflexDynamicColForSequence.invalidate();
                    }
                    //   this.grdflexDynamicColForSequence.autoSizeColumns(0, this.grdflexDynamicColForSequence.columns.length - 1, false, 20);
                    setTimeout(function () {
                        if (this.grdflexDynamicColForSequence) {
                            this.grdflexDynamicColForSequence.autoSizeColumns(0, this.grdflexDynamicColForSequence.columns.length - 1, false, 20);
                        }
                    }.bind(_this), 10);
                    _this.getProjectedPayOffDate(_this._deal.DealID);
                    _this.getProjectedPayOffDBData(_this._deal.DealID);
                    if (_this._deal.EnableAutospreadRepayments == true) {
                        _this.repaymentchecked = true;
                    }
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
            return true;
        }
        catch (err) {
        }
    };
    DealDetailComponent.prototype.SortByNoteID = function (a, b) {
        //var aNoteID = a.Name;
        //var bNoteID = b.Name;
        //return ((aNoteID < bNoteID) ? -1 : ((aNoteID > bNoteID) ? 1 : 0));
    };
    //Sequence Code END
    DealDetailComponent.prototype.fetChDeal = function (_objDeal) {
        var _this = this;
        this._isListFetching = true;
        if (localStorage.getItem('divSucessNote') == 'true') {
            this._Showmessagediv = true;
            this._ShowmessagedivMsg = localStorage.getItem('divSucessMsgNote');
            this._ShowmessagedivMsg = (this._ShowmessagedivMsg.replace('\"', '')).replace('\"', '');
            localStorage.setItem('divSucessNote', JSON.stringify(false));
            localStorage.setItem('divSucessMsgNote', JSON.stringify(''));
            //to hide _Showmessagediv after 5 sec
            setTimeout(function () {
                this._Showmessagediv = false;
            }.bind(this), 5000);
        }
        //set title
        this._isShowSaveDeal = false;
        this.lstProperty = null;
        this._disabled = false;
        this.dealSrv.getDealByDealID(_objDeal).subscribe(function (res) {
            if (res.Succeeded) {
                if (res.StatusCode == 404) {
                    _this._ShowmessagedivWar = true;
                    _this._ShowmessagedivMsgWar = "Deal does not exists in our system, Please create or import this deal.";
                    _this._isListFetching = false;
                }
                else {
                    if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                        _this.DealCalcuStatus = res.DealCalcuStatus;
                        _this._disabled = true;
                        _this._deal = res.DealDataContract;
                        _this._actualAmortMethod = _this._deal.amort.AmortizationMethodText;
                        _this.lstScheduledPrincipalPaid = res.ListScheduledPrincipalPaid;
                        _this.lstUserPermission = res.UserPermissionList;
                        if (_this._deal.EnableAutospreadRepayments == false || _this._deal.EnableAutospreadRepayments == null) {
                            _this._deal.ApplyNoteLevelPaydowns = false;
                        }
                        if (_this._deal.BaseCurrencyName == "USD") {
                            _this._basecurrencyname = '$';
                        }
                        else {
                            _this._basecurrencyname = '�';
                        }
                        if (_this._deal.TotalCommitment) {
                            _this._deal.TotalCommitment = parseFloat(_this._deal.TotalCommitment).toFixed(2);
                            _this.dealTotalCommitmenttextboxvalue = parseFloat(parseFloat(_this._deal.TotalCommitment).toFixed(2));
                        }
                        if (_this._deal.DealID == '00000000-0000-0000-0000-000000000000') {
                            _this._showadminpanel = false;
                            _this._isReadOnlyTotalCommitment = false;
                            _this._isReadOnlyNoteLevelTotalCommitment = false;
                            setTimeout(function () {
                                var ele = document.getElementById("TotalCommitment");
                                if (ele != null) {
                                    ele.setAttribute("style", "background-color: none;");
                                }
                            }, 1000);
                        }
                        else {
                            if (_this._deal.TotalCommitment) {
                                //this._deal.TotalCommitment = parseFloat(this._deal.TotalCommitment).toFixed(2);
                                //this.dealTotalCommitmenttextboxvalue = parseFloat(parseFloat(this._deal.TotalCommitment).toFixed(2));
                                _this._showadminpanel = true;
                                _this._isReadOnlyTotalCommitment = true;
                                _this._isReadOnlyNoteLevelTotalCommitment = true;
                                setTimeout(function () {
                                    var ele = document.getElementById("TotalCommitment");
                                    if (ele != null) {
                                        ele.setAttribute("style", "background-color: #cfcfcf;");
                                    }
                                }, 1000);
                            }
                        }
                        _this.note.DealID = _this._deal.DealID;
                        _objDeal.DealID = _this._deal.DealID;
                        _this.Dealfuturefunding = new deals_1.deals(_this._deal.DealID);
                        _this.Dealfuturefunding.amort = new deals_1.Amort();
                        _this.OldBoxDocumentLink = _this._deal.BoxDocumentLink;
                        if (_this._deal.CREDealID) {
                            _this.utilityService.setPageTitle("M61-" + _this._deal.CREDealID + " " + _this._deal.DealName);
                        }
                        else {
                            _this.utilityService.setPageTitle("M61 Deal Detail");
                        }
                        _this.GetAllLookups();
                        _this.getNoteByDealID(_this.note);
                        _this.getPropertyByDealID(_this._deal.DealID);
                        //  this.GetDealFundingByDealID(_objDeal);
                        //call for assign target note
                        _this.GetNoteFundingByDealID(_this._deal);
                        ////format date
                        _this._prepaymentpremium = res.ListPrePaySchedule;
                        _this.GetAppConfigByKey();
                        ////
                        _this.deletedynamicList = [];
                        _this.deladjustmentcommitment = [];
                        //Convert date
                        if (_this._deal.EstClosingDate != null) {
                            _this._deal.EstClosingDate = new Date(_this._deal.EstClosingDate.toString());
                        }
                        if (_this._deal.AppReceived != null) {
                            _this._deal.AppReceived = new Date(_this._deal.AppReceived.toString());
                        }
                        if (_this._deal.FullyExtMaturityDate != null) {
                            _this._deal.FullyExtMaturityDate = new Date(_this._deal.FullyExtMaturityDate.toString());
                        }
                        if (_this._deal.LastUpdatedFF != null) {
                            _this._deal.LastUpdatedFF = new Date(_this._deal.LastUpdatedFF.toString());
                        }
                        if (_this._deal.max_ExtensionMat != null) {
                            _this._deal.max_ExtensionMat = new Date(_this._deal.max_ExtensionMat.toString());
                        }
                        //this._isListFetching = false;
                        _this.HideAllTabs();
                        _this.ApplyPermissions(res.UserPermissionList);
                        _this.showcalcstatus();
                        _this.GetAllFeeAmount();
                        _this.GetHolidayList();
                        _this.invalidateMaturitytab();
                        _this.TempDealRule = _this._deal.DealRule;
                        _this.GetUserTimezoneByID();
                        if (_this._isShowDealAmort) {
                            setTimeout(function () {
                                this.ValidateAmort();
                            }.bind(_this), 1000);
                        }
                    }
                    else {
                        localStorage.setItem('divWarningMsgDeal', JSON.stringify(true));
                        localStorage.setItem('divWarningMsg', JSON.stringify('Sorry, you do not have permissions to access this page'));
                        //   this._router.navigate(['dashboard']);
                    }
                }
                if (_this._deal.DealID == '00000000-0000-0000-0000-000000000000' || _this._deal.DealID == null) {
                    _this._isShowCopyDeal = false;
                    _this._isShowDownloadCashflows = false;
                    _this._isShowDownloadExportToServicer = false;
                }
            }
            else {
                _this._router.navigate(['login']);
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    DealDetailComponent.prototype.GetAllLookups = function () {
        var _this = this;
        this.dealSrv.getAllLookup().subscribe(function (res) {
            var data = res.lstLookups;
            _this.lstsource = data.filter(function (x) { return x.ParentID == "7"; });
            _this.lstdealType = data.filter(function (x) { return x.ParentID == "8"; });
            _this.lstloanProgram = data.filter(function (x) { return x.ParentID == "4"; });
            _this.lstloanPurpose = data.filter(function (x) { return x.ParentID == "5"; });
            _this.lststatus = data.filter(function (x) { return x.ParentID == "51"; });
            _this.lstPropertyType = data.filter(function (x) { return x.ParentID == "15"; });
            _this.lstPurposeType = data.filter(function (x) { return x.ParentID == "50"; });
            _this.lstRateType = data.filter(function (x) { return x.ParentID == "16"; });
            _this.lstUseRuletoDetermineNoteFundingType = data.filter(function (x) { return x.ParentID == "2"; });
            _this.lstPayruleSetupRuleType = data.filter(function (x) { return x.ParentID == "21"; });
            _this.lstNoteFundingRuleType = data.filter(function (x) { return x.ParentID == "38"; });
            _this.lstUnderwritingStatus = data.filter(function (x) { return x.ParentID == "6"; });
            _this.lstDealDeleteFilter = data.filter(function (x) { return x.ParentID == "65"; });
            _this.lstNotestatus = data.filter(function (x) { return x.ParentID == "1"; });
            _this.listautospreadrule = data.filter(function (x) { return x.ParentID == "101"; });
            _this.listAmortizationMethod = data.filter(function (x) { return x.ParentID == "103"; });
            _this.listReduceAmortizationForCurtailments = data.filter(function (x) { return x.ParentID == "95"; });
            _this.listBusinessDayAdjustmentForAmort = data.filter(function (x) { return x.ParentID == "95"; });
            _this.listNoteDistributionMethod = data.filter(function (x) { return x.ParentID == "104"; });
            _this.lstRoundingNote = data.filter(function (x) { return x.ParentID == "2"; });
            _this.lstUseRuletoDetermineAmortization = data.filter(function (x) { return x.ParentID == "2"; });
            _this.lstAutoSpreadPurposeType = data.filter(function (x) { return x.ParentID == "50" && x.Value == 'Positive'; });
            _this.lstAdjustedTotalCommitmentType = data.filter(function (x) { return x.ParentID == "106"; });
            _this.lstAutospreadRepaymentMethodID = data.filter(function (x) { return x.ParentID == "114"; });
            _this.maturityTypeList = data.filter(function (x) { return x.ParentID == "118" && (x.LookupID == "708" || x.LookupID == "709" || x.LookupID == "710"); });
            _this.maturityApprovedList = data.filter(function (x) { return x.ParentID == "2"; });
            _this.otherMaturityTypeList = data.filter(function (x) { return x.ParentID == "118" && (x.LookupID == "711" || x.LookupID == "712" || x.LookupID == "713"); });
            _this.lstReserveSchedulePurposeType = data.filter(function (x) { return x.ParentID == "119"; });
            _this.lstMaturityMethodID = data.filter(function (x) { return x.ParentID == "120"; });
            _this.lstGeneratedBy = data.filter(function (x) { return x.ParentID == "125"; });
            _this.lstPrePaymentName = data.filter(function (x) { return x.ParentID == "123"; });
            _this.lstSpreadCalctMethodName = data.filter(function (x) { return x.ParentID == "25"; });
            _this.lstBaseAmountName = data.filter(function (x) { return x.ParentID == "124"; });
            //set dropdown for
            _this._bindGridDropdows();
            _this._bindGridDropdowsAuto();
        });
    };
    DealDetailComponent.prototype.getAllPropertyType = function () {
        var _this = this;
        this.dealSrv.getallpropertytype().subscribe(function (res) {
            if (res.Succeeded) {
                _this.lstdealPropertyType = res.lstPropertytype;
            }
        });
    };
    DealDetailComponent.prototype.getAllLoanStatus = function () {
        var _this = this;
        this.dealSrv.getallloanstatus().subscribe(function (res) {
            if (res.Succeeded) {
                _this.lstLoanStatus = res.lstLoanstatus;
            }
        });
    };
    DealDetailComponent.prototype.getAllRuleType = function () {
        var _this = this;
        this.scenarioService.getallruletype().subscribe(function (res) {
            if (res.Succeeded) {
                _this._lstruletype = res.lstScenariorule;
                _this._lstgetallrule = res.lstScenariorule;
            }
        });
    };
    DealDetailComponent.prototype.GetAllRuleTypeDetail = function () {
        var _this = this;
        this.scenarioService.getallruletypedetail().subscribe(function (res) {
            if (res.Succeeded) {
                _this._lstruletypedetail = res.lstScenarioRuleDetail;
                var RuleType = _this.RuleTypeList;
                if (RuleType) {
                    var colRuleType = RuleType.columns.getColumn('FileName');
                    if (colRuleType) {
                        colRuleType.showDropDown = true;
                        colRuleType.dataMap = _this._buildDataMapWithoutLookupForRuleType(_this._lstruletypedetail);
                    }
                }
            }
        });
    };
    DealDetailComponent.prototype.GetRuleTypeSetupByDealid = function () {
        var _this = this;
        this._ruletype.DealID = this._deal.DealID;
        this.dealSrv.getruletypesetupbydealid(this._ruletype).subscribe(function (res) {
            if (res.Succeeded) {
                _this._lstRuleTypeSetupfilter = res.lstScenariorule;
                _this.OnChangeScenarioName(_this._ruletype.AnalysisID);
            }
        });
    };
    DealDetailComponent.prototype.celleditRuleType = function (s, e) {
        var RuleTypeFileNameerror = "";
        var rowdata = this.RuleTypeList.rows[e.row].dataItem;
        if (this._ruletype.AnalysisID == undefined) {
            RuleTypeFileNameerror = "<p>" + "Please Select a Scenario" + "</p>";
            this.CustomAlert(RuleTypeFileNameerror);
            return;
        }
        if (Object.keys(rowdata).length > 0) {
            var newFileName = rowdata.FileName;
            if (this._lstRuleTypeSetuptobesend.length > 0) {
                for (var h = 0; h < this._lstRuleTypeSetuptobesend.length; h++) {
                    if (this._lstRuleTypeSetuptobesend[h].RuleTypeName == rowdata.RuleTypeName && this._lstRuleTypeSetuptobesend[h].AnalysisID == this._ruletype.AnalysisID) {
                        this._lstRuleTypeSetuptobesend[h]["FileName"] = newFileName;
                    }
                }
            }
        }
    };
    DealDetailComponent.prototype.invalidateRulestab = function () {
        var _this = this;
        if (!this._isRuleTabClicked) {
            localStorage.setItem('ClickedTabId', 'aRulestab');
            this._isRuleTabClicked = true;
        }
        this._isListFetching = true;
        if (this._deal.BalanceAware == false) {
            this._isShowScenariodiv = false;
            this._isShowRuleTypediv = false;
            this._isShowbtnResetdiv = false;
            this._Showmessagedivrule = true;
            this._ShowmessagedivruleMsg = "This deal is set as Non Balance Aware Deal. To edit the rules, check the balance aware checkbox on Main Tab and save the deal.";
        }
        else {
            this._isShowScenariodiv = true;
            this._isShowRuleTypediv = true;
            this._isShowbtnResetdiv = true;
            this._Showmessagedivrule = false;
            this._ShowmessagedivruleMsg = "";
        }
        this.getAllRuleType();
        this.GetAllRuleTypeDetail();
        this.GetRuleTypeSetupByDealid();
        this.appliedreadonlyrulesetfile();
        setTimeout(function () {
            _this.flex.invalidate();
            _this.flexPro.invalidate();
            // this.flexRules.invalidate();
            _this.RuleTypeList.invalidate();
        }, 200);
        setTimeout(function () {
            _this._isListFetching = false;
        }, 1000);
    };
    DealDetailComponent.prototype.appliedreadonlyrulesetfile = function () {
        var _this = this;
        setTimeout(function () {
            for (var i = 0; i < _this._lstruletype.length; i++) {
                if (_this.RuleTypeList.rows[i]) {
                    if (_this.RuleTypeList.rows[i].dataItem.RuleTypeName == "Prepay") {
                        if (_this.RuleTypeList.rows[i]) {
                            _this.RuleTypeList.rows[i].isReadOnly = true;
                            _this.RuleTypeList.rows[i].cssClass = "customgridrowcolor";
                        }
                    }
                }
            }
        }, 1000);
    };
    DealDetailComponent.prototype.ResetRuleType = function () {
        var _this = this;
        if (this._lstRuleTypeSetupfilter != null) {
            if (this._lstRuleTypeSetupfilter.length > 0) {
                for (var h = 0; h < this._lstRuleTypeSetupfilter.length; h++) {
                    if (this._lstRuleTypeSetupfilter[h].AnalysisID == this._ruletype.AnalysisID) {
                        this._lstRuleTypeSetupfilter[h]["FileName"] = "";
                    }
                }
            }
            this._lstruletype = this._lstRuleTypeSetupfilter.filter(function (x) { return x.AnalysisID == _this._ruletype.AnalysisID; });
        }
        else {
            this._lstruletype = [];
            this.RuleTypeList.invalidate();
        }
        if (this._lstgetallrule.length > 0) {
            for (var h = 0; h < this._lstgetallrule.length; h++) {
                var _lstgetallrule = this._lstruletype.filter(function (x) { return x.RuleTypeName == _this._lstgetallrule[h].RuleTypeName; });
                if (_lstgetallrule.length == 0) {
                    this._lstruletype.push({
                        'AnalysisID': this._ruletype.AnalysisID,
                        'DealID': this._deal.DealID,
                        'RuleTypeMasterID': this._lstgetallrule[h].RuleTypeMasterID,
                        'RuleTypeDetailID': "",
                        'RuleTypeName': this._lstgetallrule[h].RuleTypeName,
                        'FileName': "",
                    });
                }
            }
        }
        if (this._lstRuleTypeSetuptobesend.length > 0) {
            for (var h = 0; h < this._lstRuleTypeSetuptobesend.length; h++) {
                if (this._lstRuleTypeSetuptobesend[h].AnalysisID == this._ruletype.AnalysisID) {
                    this._lstRuleTypeSetuptobesend[h]["FileName"] = "";
                }
            }
        }
    };
    DealDetailComponent.prototype.OnChangeScenarioName = function (newvalue) {
        var _this = this;
        this._lstruletype = [];
        this.appliedreadonlyrulesetfile();
        this.RuleTypeList.invalidate();
        if (this._lstRuleTypeSetupfilter != null) {
            this._lstruletype = this._lstRuleTypeSetupfilter.filter(function (x) { return x.AnalysisID == newvalue; });
            this.RuleTypeList.invalidate();
        }
        if (this._lstgetallrule.length > 0) {
            for (var h = 0; h < this._lstgetallrule.length; h++) {
                var _lstgetallrule = this._lstruletype.filter(function (x) { return x.RuleTypeName == _this._lstgetallrule[h].RuleTypeName; });
                if (_lstgetallrule.length == 0) {
                    this._lstruletype.push({
                        'AnalysisID': newvalue,
                        'DealID': this._deal.DealID,
                        'RuleTypeMasterID': this._lstgetallrule[h].RuleTypeMasterID,
                        'RuleTypeDetailID': "",
                        'RuleTypeName': this._lstgetallrule[h].RuleTypeName,
                        'FileName': "",
                    });
                }
            }
        }
        var newanalysisid = this._lstRuleTypeSetuptobesend.filter(function (x) { return x.AnalysisID == newvalue; });
        if (newanalysisid.length != 0) {
            this._lstruletype = [];
            setTimeout(function () {
                this._lstruletype = newanalysisid;
            }.bind(this), 100);
        }
        else {
            if (newvalue != undefined) {
                if (this._lstruletype.length > 0) {
                    for (var h = 0; h < this._lstruletype.length; h++) {
                        this._lstRuleTypeSetuptobesend.push({
                            'AnalysisID': newvalue,
                            'DealID': this._deal.DealID,
                            'RuleTypeMasterID': this._lstruletype[h].RuleTypeMasterID,
                            'RuleTypeDetailID': this._lstruletype[h].RuleTypeDetailID,
                            'RuleTypeName': this._lstruletype[h].RuleTypeName,
                            'FileName': this._lstruletype[h].FileName,
                        });
                    }
                }
            }
        }
    };
    DealDetailComponent.prototype.AddUpdateDealRuleTypeSetup = function () {
        var _this = this;
        var RuleTypeDetailID = 0;
        if (this._lstRuleTypeSetuptobesend.length > 0) {
            for (var h = 0; h < this._lstRuleTypeSetuptobesend.length; h++) {
                if (this._lstRuleTypeSetuptobesend[h].FileName != "" && this._lstRuleTypeSetuptobesend[h].FileName != null) {
                    RuleTypeDetailID = this._lstruletypedetail.find(function (x) { return x.FileName == _this._lstRuleTypeSetuptobesend[h].FileName; }).RuleTypeDetailID;
                }
                else {
                    RuleTypeDetailID = 0;
                }
                this._lstRuleTypeSetupNew.push({
                    'AnalysisID': this._lstRuleTypeSetuptobesend[h].AnalysisID,
                    'DealID': this._lstRuleTypeSetuptobesend[h].DealID,
                    'RuleTypeMasterID': this._lstRuleTypeSetuptobesend[h].RuleTypeMasterID,
                    'RuleTypeDetailID': RuleTypeDetailID,
                });
            }
            this.dealSrv.addupdatedealruletypesetup(this._lstRuleTypeSetupNew).subscribe(function (res) {
                if (res.Succeeded) {
                }
            });
        }
    };
    DealDetailComponent.prototype.GetDealPrepayProjectionByDealId = function () {
        var _this = this;
        this.dealSrv.getdealprepayprojectionbydealid(this._deal.DealID).subscribe(function (res) {
            if (res.Succeeded) {
                var lstPrepayProjection = res.lstPrepayProjection;
                _this.Prepaylastupdated = res.Prepaylastupdated;
                _this.PrepaylastupdatedBy = res.PrepaylastupdatedBy;
                if (_this.Prepaylastupdated == null && _this.Prepaylastupdated == '') {
                    _this.divPrepayLastUpdated = false;
                }
                else {
                    _this.divPrepayLastUpdated = true;
                }
                if (lstPrepayProjection.length > 0) {
                    _this._lstPrepayPremiumnew = lstPrepayProjection;
                    _this.ConvertToBindableDatePrepayProjection(_this._lstPrepayPremiumnew);
                    for (var i = 0; i < _this._lstPrepayPremiumnew.length; i++) {
                        if (_this._lstPrepayPremiumnew[i].OpenPrepaymentDate != null) {
                            if (_this._lstPrepayPremiumnew[i].OpenPrepaymentDate == "01/01/1900") {
                                _this._lstPrepayPremiumnew[i].OpenPrepaymentDate = "";
                            }
                        }
                    }
                    _this.PrepayPremium.selectionMode = wjcGrid.SelectionMode.None;
                }
                else {
                    _this._lstPrepayPremiumnew = [];
                    _this.PrepayPremium.invalidate();
                    _this.PrepayPremium.selectionMode = wjcGrid.SelectionMode.None;
                }
            }
            else {
                _this._lstPrepayPremiumnew = [];
                _this.PrepayPremium.invalidate();
                _this.PrepayPremium.selectionMode = wjcGrid.SelectionMode.None;
            }
        });
    };
    DealDetailComponent.prototype.GetDealPrepayAllocationsByDealId = function () {
        var _this = this;
        this.dealSrv.getdealprepayallocationbydealid(this._deal.DealID).subscribe(function (res) {
            if (res.Succeeded) {
                _this._lstPrepayAllocations = res.lstPrepayAllocations;
                _this.ConvertToBindableDatePrepayAllocation(_this._lstPrepayAllocations);
                _this.getprepaypremiumbyprepaydate();
            }
        });
    };
    //getprepaypremiumbyprepaydate(prepaydate: any): void {
    //    return this._lstPrepayAllocations.filter(x => x.PrepayDate == prepaydate && x.DealID == this._deal.DealID);
    //}
    DealDetailComponent.prototype.getprepaypremiumbyprepaydate = function () {
        // this._lstPrepayAllocations=this._lstPrepayAllocations.filter(x => x.PrepayDate == prepaydate && x.DealID == this._deal.DealID);
        var itemsPrepayAll = this._lstPrepayAllocations;
        var dealID = this._deal.DealID;
        new wjcGridDetail.FlexGridDetailProvider(this.PrepayPremium, {
            maxHeight: 250,
            isAnimated: true,
            // detailVisibilityMode: 'ExpandMulti',
            // selectionMode:'Cell',
            createDetailCell: function (row) {
                var cell = document.createElement('div');
                var detailGrid = new wjcGrid.FlexGrid(cell, {
                    headersVisibility: wjcGrid.HeadersVisibility.Column,
                    isReadOnly: false,
                    autoGenerateColumns: false,
                    selectionMode: 'Cell',
                    itemsSource: itemsPrepayAll.filter(function (x) { return x.PrepayDate == row._data.PrepayDate && x.DealID == dealID; }),
                    columns: [{
                            header: 'Note Id',
                            binding: 'CRENoteID',
                            isReadOnly: true,
                            width: 200
                        },
                        {
                            header: 'Prepay Premium Allocation',
                            binding: 'MinmultDue',
                            isReadOnly: true,
                            width: 250,
                            dataType: 'Number',
                            aggregate: 'Sum'
                        }
                    ]
                });
                setTimeout(function () {
                    detailGrid.select(-1, -1);
                }.bind(this), 50);
                return cell;
            }
        });
    };
    DealDetailComponent.prototype.getprepaypremiumDetaildatabydealId = function () {
        var _this = this;
        this.dealSrv.getprepaypremiumdetaildatabydeal(this._deal.DealID).subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.lstPrepay;
                _this._prepaymentpremium.PrepayScheduleId = data;
                var lstprepayadjustment = res.lstDealPrepay;
                var lstSpreadMaintenance = res.lstDealSpreadMaintenance;
                var lstMiniSpreadInterest = res.lstDealMiniSpread;
                var lstMiniFee = res.lstDealMiniFee;
                var lstDealSpreadMaintenanceDeallevel = res.lstDealSpreadMaintenanceDeallevel;
                if (lstprepayadjustment.length > 0) {
                    _this._lstprepayadjustment = lstprepayadjustment;
                    _this.ConvertToBindableDatePrepayAdjustment(_this._lstprepayadjustment);
                }
                else {
                    _this.prepayadjustment.invalidate();
                }
                if (_this._prepaymentpremium.HasNoteLevelSMSchedule == true) {
                    if (lstSpreadMaintenance.length > 0) {
                        //  this._lstSpreadMaintenance = lstSpreadMaintenance;
                        _this._lstSpreadMaintenance_note = lstSpreadMaintenance;
                        //  this.ConvertToBindableDateSpreadMaintenance(this._lstSpreadMaintenance);
                        setTimeout(function () {
                            this.SpreadMaintenance.invalidate();
                        }.bind(_this), 2000);
                    }
                    else {
                        _this._lstSpreadMaintenance.push({
                            'CalcAfterPayoff': false
                        });
                    }
                }
                else {
                    if (lstDealSpreadMaintenanceDeallevel.length > 0) {
                        // this._lstSpreadMaintenance = lstDealSpreadMaintenanceDeallevel;
                        _this._lstSpreadMaintenance_deal = lstDealSpreadMaintenanceDeallevel;
                        //  this.ConvertToBindableDateSpreadMaintenance(this._lstSpreadMaintenance);
                    }
                    else {
                        _this._lstSpreadMaintenance.push({
                            'CalcAfterPayoff': false
                        });
                    }
                }
                if (lstMiniSpreadInterest.length > 0) {
                    _this._lstMinimumMult = lstMiniSpreadInterest;
                    _this.ConvertToBindableDateMinimumMult(_this._lstMinimumMult);
                }
                else {
                    //  this.MinimumMult.invalidate();
                }
                if (lstMiniFee.length > 0) {
                    _this._lstMinimumFee = lstMiniFee;
                }
                else {
                    _this._lstMinimumFee.push({
                        'UseActualFees': false
                    });
                }
                _this.EnableDisableMiniFeeGrid(_this._prepaymentpremium.Includefeesincredits);
                //  this.EnabledDisabledNoteColumn(this._prepaymentpremium.HasNoteLevelSMSchedule);
                _this.PrePaymentMethodChange(_this._prepaymentpremium.PrepaymentMethod);
            }
        });
    };
    DealDetailComponent.prototype.PrePaymentMethodChange = function (newvalue) {
        if (newvalue == 738) {
            this.spreadmaintenancediv = true;
            this.minispreadinterestdiv = false;
            if (!this._isPrepaymentmethodClicked) {
                this._isPrepaymentmethodClicked = true;
                setTimeout(function () {
                    this.EnabledDisabledNoteColumn(this._prepaymentpremium.HasNoteLevelSMSchedule);
                }.bind(this), 100);
            }
            else {
                if (this._prepaymentpremium.HasNoteLevelSMSchedule == true) {
                    setTimeout(function () {
                        var dialogoverlay = document.getElementById('divSpreadMaintenance');
                        dialogoverlay.style.width = "700px";
                        var dialogoverlay1 = document.getElementById('divgridSpreadMaintenance');
                        dialogoverlay1.style.width = "700px";
                        var SpreadMaintenance = this.SpreadMaintenance;
                        this._showHidenote = true;
                        if (SpreadMaintenance) {
                            var colNoteId = SpreadMaintenance.columns.getColumn('CRENoteID');
                            if (colNoteId) {
                                colNoteId.showDropDown = true;
                                colNoteId.dataMap = this._buildDataMapWithoutLookupForNoteId(this.lstNote);
                            }
                        }
                    }.bind(this), 100);
                }
                else {
                    setTimeout(function () {
                        this._showHidenote = false;
                        var dialogoverlay = document.getElementById('divSpreadMaintenance');
                        dialogoverlay.style.width = "500px";
                        var dialogoverlay1 = document.getElementById('divgridSpreadMaintenance');
                        dialogoverlay1.style.width = "500px";
                    }.bind(this), 100);
                }
            }
        }
        if (newvalue == 739 || newvalue == 740) {
            this.minispreadinterestdiv = true;
            this.spreadmaintenancediv = false;
            this.EnableDisableMiniFeeGrid(this._prepaymentpremium.Includefeesincredits);
        }
        if (newvalue == 741) {
            this.spreadmaintenancediv = true;
            this.minispreadinterestdiv = true;
            this.EnableDisableMiniFeeGrid(this._prepaymentpremium.Includefeesincredits);
            if (!this._isPrepaymentmethodClicked) {
                this._isPrepaymentmethodClicked = true;
                setTimeout(function () {
                    this.EnabledDisabledNoteColumn(this._prepaymentpremium.HasNoteLevelSMSchedule);
                }.bind(this), 100);
            }
            if (this._prepaymentpremium.HasNoteLevelSMSchedule == true) {
                setTimeout(function () {
                    var SpreadMaintenance = this.SpreadMaintenance;
                    if (SpreadMaintenance) {
                        var colNoteId = SpreadMaintenance.columns.getColumn('CRENoteID');
                        if (colNoteId) {
                            colNoteId.showDropDown = true;
                            colNoteId.dataMap = this._buildDataMapWithoutLookupForNoteId(this.lstNote);
                        }
                    }
                }.bind(this), 100);
            }
            setTimeout(function () {
                if (this._prepaymentpremium.HasNoteLevelSMSchedule == true) {
                    var dialogoverlay = document.getElementById('divSpreadMaintenance');
                    dialogoverlay.style.width = "700px";
                    var dialogoverlay1 = document.getElementById('divgridSpreadMaintenance');
                    dialogoverlay1.style.width = "700px";
                }
                else {
                    var dialogoverlay = document.getElementById('divSpreadMaintenance');
                    dialogoverlay.style.width = "500px";
                    var dialogoverlay1 = document.getElementById('divgridSpreadMaintenance');
                    dialogoverlay1.style.width = "500px";
                }
            }.bind(this), 100);
        }
    };
    DealDetailComponent.prototype.EnabledDisabledNoteColumn = function (valuechecked) {
        var SpreadMaintenance = this.SpreadMaintenance;
        if (valuechecked == true) {
            this._showHidenote = true;
            if (SpreadMaintenance) {
                var colNoteId = SpreadMaintenance.columns.getColumn('CRENoteID');
                if (colNoteId) {
                    colNoteId.showDropDown = true;
                    colNoteId.dataMap = this._buildDataMapWithoutLookupForNoteId(this.lstNote);
                }
            }
            this._lstSpreadMaintenance_deal = this._lstSpreadMaintenance;
            this._lstSpreadMaintenance = this._lstSpreadMaintenance_note;
            var dialogoverlay = document.getElementById('divSpreadMaintenance');
            dialogoverlay.style.width = "700px";
            var dialogoverlay1 = document.getElementById('divgridSpreadMaintenance');
            dialogoverlay1.style.width = "700px";
        }
        else {
            this._lstSpreadMaintenance_note = this._lstSpreadMaintenance;
            this._lstSpreadMaintenance = this._lstSpreadMaintenance_deal;
            this._showHidenote = false;
            var dialogoverlay = document.getElementById('divSpreadMaintenance');
            dialogoverlay.style.width = "500px";
            var dialogoverlay1 = document.getElementById('divgridSpreadMaintenance');
            dialogoverlay1.style.width = "500px";
        }
        this.ConvertToBindableDateSpreadMaintenance(this._lstSpreadMaintenance);
    };
    DealDetailComponent.prototype.EnableDisableMiniFeeGrid = function (gridchk) {
        if (gridchk) {
            this._isShowMinimumFee = true;
            setTimeout(function () {
                var MinimumFee = this.MinimumFee;
                if (MinimumFee) {
                    var colFeeType = MinimumFee.columns.getColumn('FeeTypeNameText');
                    if (colFeeType) {
                        colFeeType.showDropDown = true;
                        colFeeType.dataMap = this._buildDataMapWithoutLookupNew(this.lstFeeType);
                    }
                }
            }.bind(this), 500);
        }
        else {
            this._isShowMinimumFee = false;
        }
    };
    DealDetailComponent.prototype.AddNewPrePayPremium = function () {
        var _this = this;
        if (this._lstprepayadjustment.length > 0) {
            for (var h = 0; h < this._lstprepayadjustment.length; h++) {
                this._lstprepayadjustmentNew.push({
                    // this.adjustedcommitmentheadervalues[n] == null ? 0
                    'PrepayAdjustmentId': this._lstprepayadjustment[h].PrepayAdjustmentId == null ? 0 : this._lstprepayadjustment[h].PrepayAdjustmentId,
                    'Date': this.convertDateToBindable(this._lstprepayadjustment[h].Date),
                    'PrepayAdjAmt': this._lstprepayadjustment[h].PrepayAdjAmt,
                    'Comment': this._lstprepayadjustment[h].Comment
                });
            }
        }
        // this._lstSpreadMaintenance.splice(0, 1);
        if (this._prepaymentpremium.HasNoteLevelSMSchedule == false || this._prepaymentpremium.HasNoteLevelSMSchedule == null) {
            // var CRENoteList = this.lstNote.map(item => item.NoteId).filter((value, index, self) => self.indexOf(value) === index)
            if (this._lstSpreadMaintenance.length > 0) {
                for (var h = 0; h < this._lstSpreadMaintenance.length; h++) {
                    // for (var k = 0; k < CRENoteList.length; k++) {
                    this._lstSpreadMaintenancenew.push({
                        'SpreadMaintenanceScheduleId': this._lstSpreadMaintenance[h].SpreadMaintenanceScheduleId == null ? 0 : this._lstSpreadMaintenance[h].SpreadMaintenanceScheduleId,
                        'NoteID': null,
                        /* 'CRENoteID': this._lstSpreadMaintenance[k].CRENoteID,*/
                        'SpreadDate': this.convertDateToBindable(this._lstSpreadMaintenance[h].SpreadDate),
                        'Spread': this._lstSpreadMaintenance[h].Spread,
                        'CalcAfterPayoff': this._lstSpreadMaintenance[h].CalcAfterPayoff
                    });
                    // }
                }
            }
        }
        else {
            if (this._lstSpreadMaintenance.length > 0) {
                for (var h = 0; h < this._lstSpreadMaintenance.length; h++) {
                    this._lstSpreadMaintenancenew.push({
                        'SpreadMaintenanceScheduleId': this._lstSpreadMaintenance[h].SpreadMaintenanceScheduleId == null ? 0 : this._lstSpreadMaintenance[h].SpreadMaintenanceScheduleId,
                        'NoteId': this._lstSpreadMaintenance[h].CRENoteID,
                        /*'NoteId': this._lstSpreadMaintenance[h].NoteId == undefined ? this._lstSpreadMaintenance[h].CRENoteID : this._lstSpreadMaintenance[h].NoteId,
                         'CRENoteID': this._lstSpreadMaintenance[k].CRENoteID,*/
                        'SpreadDate': this.convertDateToBindable(this._lstSpreadMaintenance[h].SpreadDate),
                        'Spread': this._lstSpreadMaintenance[h].Spread,
                        'CalcAfterPayoff': this._lstSpreadMaintenance[h].CalcAfterPayoff
                    });
                }
            }
        }
        if (this._lstMinimumMult.length > 0) {
            for (var h = 0; h < this._lstMinimumMult.length; h++) {
                this._lstMinimumMultNew.push({
                    'MinMultScheduleID': this._lstMinimumMult[h].MinMultScheduleID == null ? 0 : this._lstMinimumMult[h].MinMultScheduleID,
                    'MiniSpreadDate': this.convertDateToBindable(this._lstMinimumMult[h].MiniSpreadDate),
                    'MinMultAmount': this._lstMinimumMult[h].MinMultAmount
                });
            }
        }
        if (this._lstMinimumFee.length > 0) {
            for (var h = 0; h < this._lstMinimumFee.length; h++) {
                this._lstMinimumFeeNew.push({
                    'FeeCreditsID': this._lstMinimumFee[h].FeeCreditsID == null ? 0 : this._lstMinimumFee[h].FeeCreditsID,
                    'FeeTypeNameText': this._lstMinimumFee[h].FeeTypeNameText,
                    'FeeCreditOverride': this._lstMinimumFee[h].FeeCreditOverride,
                    'UseActualFees': this._lstMinimumFee[h].UseActualFees
                });
            }
        }
        this._prepaymentpremium.PrepayAdjustmentList = this._lstprepayadjustmentNew;
        this._prepaymentpremium.SpreadMaintenanceScheduleList = this._lstSpreadMaintenancenew;
        this._prepaymentpremium.MinMultScheduleList = this._lstMinimumMultNew;
        this._prepaymentpremium.FeeCreditsList = this._lstMinimumFeeNew;
        this.dealSrv.addNewPrepaySchedule(this._prepaymentpremium).subscribe(function (res) {
            if (res.Succeeded) {
                _this.saveprepayruletemplate();
            }
        });
    };
    //save prepay rule template
    DealDetailComponent.prototype.saveprepayruletemplate = function () {
        var _this = this;
        var DefaultScenarioID = this._lstScenario.find(function (x) { return x.ScenarioName == "Default"; }).AnalysisID;
        if (this._prepaymentpremium.PrePaymentRuleType != 0) {
            this._lstRuleTypeSetupNew.push({
                'AnalysisID': DefaultScenarioID,
                'DealID': this._deal.DealID,
                'RuleTypeMasterID': 4,
                'RuleTypeDetailID': this._prepaymentpremium.PrePaymentRuleType,
            });
            this.dealSrv.addupdatedealruletypesetup(this._lstRuleTypeSetupNew).subscribe(function (res) {
                if (res.Succeeded) {
                    if (_this.isPrepayCalcClicked == true) {
                        _this.isPrepayCalcClicked = false;
                        _this.PrepayCalcSubmit();
                    }
                }
            });
        }
    };
    //calc prepay
    DealDetailComponent.prototype.SubmitPrepayCalcRequest = function () {
        this._isShowLoader = true;
        this.isPrepayCalcClicked = true;
        var prepaydateerror = "";
        if (this._deal.PrePayDate == null || this._deal.PrePayDate === undefined) {
            prepaydateerror = "<p>" + "Prepay date can not be blank. Please enter a date. " + "</p>";
            this.CustomAlert(prepaydateerror);
            this._isShowLoader = false;
            return;
        }
        else {
            this._prepaymentpremium.PrepayDate = this.convertDatetoGMT(this._deal.PrePayDate);
            this.divPrepayCalculationStatus = true;
            this.PrepayCalcStatus = "Processing";
        }
        this._prepaymentpremium.DealID = this._deal.DealID;
        this.AddNewPrePayPremium();
        // this.saveprepayruletemplate();
    };
    DealDetailComponent.prototype.PrepayCalcSubmit = function () {
        var _this = this;
        //  var dealid = this._deal.DealID;
        this.dealSrv.CalcPrepaySchedule(this._deal).subscribe(function (res) {
            if (res.Succeeded) {
                _this.showPrepayCalcStatus();
                // this.PrepayCalcStatus = "Running";
                _this._isShowLoader = false;
                _this._ShowmessagedivMsg = "Calculate Prepay saved successfully.";
                _this._Showmessagediv = true;
                setTimeout(function () {
                    _this._Showmessagediv = false;
                }, 3000);
                _this.showprepaycalcstatuswithinterval();
            }
        });
    };
    DealDetailComponent.prototype.showprepaycalcstatuswithinterval = function () {
        var _this = this;
        this._isShowLoader = false;
        this.divPrepayCalculationStatus = true;
        var status = setInterval(function () {
            _this.dealSrv.getprepaycalculationstatus(_this._deal.DealID).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.PrepayCalcStatus = res.PrepayCalcuStatus;
                    _this.CalculationErorMessage = res.CalculationErrorMessage;
                    if (_this.PrepayCalcStatus == "Completed") {
                        clearInterval(status);
                        // this.showprepaycalcstatusmessage(this.CalculationErorMessage);
                        _this.GetDealPrepayAllocationsByDealId();
                        _this.GetDealPrepayProjectionByDealId();
                        _this._isShowLoader = false;
                    }
                    else if (_this.PrepayCalcStatus == "Failed") {
                        clearInterval(status);
                        // this.showprepaycalcstatusmessage(this.CalculationErorMessage);
                        _this._isShowLoader = false;
                    }
                }
            });
        }, 10000);
    };
    DealDetailComponent.prototype.showPrepayCalcStatus = function () {
        var _this = this;
        this.dealSrv.getprepaycalculationstatus(this._deal.DealID).subscribe(function (res) {
            if (res.Succeeded) {
                _this.PrepayCalcStatus = res.PrepayCalcuStatus;
                _this.CalculationErorMessage = res.CalculationErrorMessage;
                if (_this.PrepayCalcStatus == "" || _this.PrepayCalcStatus == undefined) {
                    _this.divPrepayCalculationStatus = false;
                }
                else {
                    _this.divPrepayCalculationStatus = true;
                }
            }
        });
    };
    DealDetailComponent.prototype.showprepaycalcstatusmessage = function (Statusname) {
        var _this = this;
        this._isShowLoader = true;
        this._lstprepayCalculationLog = [];
        this._lstloggedFile = [];
        this.PrepayFailedMessage = "";
        this.dealSrv.GetPrepayCalcStatusMessage(this._deal.DealID).subscribe(function (res) {
            if (res.Succeeded) {
                var PrepayCalcFailedStatusData = res.PrepayCalcFailedStatusData;
                var loggedfiledata = res.loggedfiledata;
                if (Statusname == "Failed") {
                    if (_this.CalculationErorMessage == "Note calculated successfully but failed to save data in DB.") {
                        _this.divPrepaySystemLog = true;
                        _this.PrepayFailedMessage = PrepayCalcFailedStatusData.Message;
                        _this.PrepayFailedMessageBody = PrepayCalcFailedStatusData.Message_StackTrace;
                        var newstrings = _this.PrepayFailedMessageBody.split("\n");
                        if (newstrings.length > 0) {
                            for (var h = 0; h < newstrings.length; h++) {
                                _this._lstprepayCalculationLog.push({
                                    'PrepayMessage': newstrings[h]
                                });
                            }
                        }
                    }
                }
                if (Statusname == "Failed" || Statusname == "Completed") {
                    var lstloggedfiledata = loggedfiledata;
                    _this.divPrepayCalculationLog = true;
                    if (lstloggedfiledata.length > 0) {
                        for (var h = 0; h < lstloggedfiledata.length; h++) {
                            _this._lstloggedFile.push({
                                'data': lstloggedfiledata[h]
                            });
                        }
                    }
                }
                _this._isShowLoader = false;
                setTimeout(function () {
                    var el = document.getElementById("divScroll");
                    el.scrollIntoView({
                        behavior: "smooth",
                        block: "start",
                        inline: "nearest"
                    });
                }.bind(_this), 1000);
            }
        });
    };
    DealDetailComponent.prototype.Savedeals = function (objDeal) {
        this._isListFetching = true;
        for (var i = 0; i < this.lstNotePayruleSetup.length; i++) {
            if (!(Number(this.lstNotePayruleSetup[i].RuleText).toString() == "NaN" || Number(this.lstNotePayruleSetup[i].RuleText) == 0)) {
                this.lstNotePayruleSetup[i].RuleID = Number(this.lstNotePayruleSetup[i].RuleText);
            }
        }
        this.ConvertInSequenceListForPayruleSetup();
        this._deal.PayruleSetupList = this.lstNotePayruleSetupSequence;
        this._deal.PayruleDealFundingList = this.listdealfunding;
        this._deal.AutoSpreadRuleList = this.lstautospreadrule;
        if (this._deal.AutoSpreadRuleList) {
            for (var i = 0; i < this._deal.AutoSpreadRuleList.length; i++) {
                this._deal.AutoSpreadRuleList[i].StartDate = this.convertDatetoGMT(this._deal.AutoSpreadRuleList[i].StartDate);
                this._deal.AutoSpreadRuleList[i].EndDate = this.convertDatetoGMT(this._deal.AutoSpreadRuleList[i].EndDate);
            }
        }
        for (var i = 0; i < this._deal.PayruleDealFundingList.length; i++) {
            if (!(Number(this._deal.PayruleDealFundingList[i].PurposeText).toString() == "NaN" || Number(this._deal.PayruleDealFundingList[i].PurposeText) == 0)) {
                this._deal.PayruleDealFundingList[i].PurposeID = Number(this._deal.PayruleDealFundingList[i].PurposeText);
            }
        }
        //autospread repayment fields.
        this._deal.EarliestPossibleRepaymentDate = this.convertDatetoGMT(this.EarliestPossibleRepaymentDateBS);
        this._deal.ExpectedFullRepaymentDate = this.convertDatetoGMT(this.ExpectedDateBS);
        this._deal.LatestPossibleRepaymentDate = this.convertDatetoGMT(this.LatestPossibleRepaymentDateBS);
        this._deal.AutoPrepayEffectiveDate = this.convertDatetoGMT(this.EffectiveDateBS);
        this._deal.ApplyNoteLevelPaydowns = this._deal.ApplyNoteLevelPaydowns;
        this._deal.IsREODeal = this._deal.IsREODeal;
        if (this._deal.EnableAutospreadRepayments == true) {
            if (this.flexautospreadrepayments) {
                this._deal.ListProjectedPayoff = [];
                for (var k = 0; k < this.flexautospreadrepayments.rows.length - 1; k++) {
                    if (this.flexautospreadrepayments.rows[k].dataItem.ProjectedPayoffAsofDate != null) {
                        var date = this.convertDatetoGMT(this.flexautospreadrepayments.rows[k].dataItem.ProjectedPayoffAsofDate);
                        this._deal.ListProjectedPayoff.push({ "DealID": this._deal.DealID, "ProjectedPayoffAsofDate": date, "CumulativeProbability": this.flexautospreadrepayments.rows[k].dataItem.CumulativeProbability });
                    }
                }
            }
        }
        this.AssginValuesToDealDataContract();
        this._deal.PayruleNoteAMSequenceList = this.lstSequence;
        this._deal.PayruleTargetNoteFundingScheduleList = this.Dealfuturefunding.PayruleTargetNoteFundingScheduleList;
        this._deal.AppReceived = this.convertDatetoGMT(this._deal.AppReceived);
        this._deal.EstClosingDate = this.convertDatetoGMT(this._deal.EstClosingDate);
        this._deal.ListHoliday = this.ListHoliday;
        this.SaveDealfunc(this._deal);
    };
    DealDetailComponent.prototype.shownotepayruleGD = function () {
        var _this = this;
        this._isListFetching = true;
        if (this._deal.IsPayruleClicked != "true") {
            this.GetNotePayruleSetupDataByDealID(this._deal.DealID);
        }
        localStorage.setItem('ClickedTabId', 'aNotepayrule');
        this._deal.IsPayruleClicked = "true";
        setTimeout(function () {
            _this.grdflexDynamicColForNotePayruleSetup.invalidate();
            ;
        }, 200);
        setTimeout(function () {
            _this._isListFetching = false;
        }, 1000);
    };
    DealDetailComponent.prototype.ApplyPermissions = function (_object) {
        try {
            for (var i = 0; i < _object.length; i++) {
                if (_object[i].ChildModule == 'Deal_Funding') {
                    this._isShowFuturefunding = true;
                }
                if (_object[i].ChildModule == 'Deal_Main') {
                    this._isShowHome = true;
                }
                if (_object[i].ChildModule == 'Deal_Payrule') {
                    this._isShowNotePayrule = true;
                }
                if (_object[i].ChildModule == 'Deal_Import') {
                    this._isShowDocImport = true;
                }
                if (_object[i].ChildModule == 'Deal_Rules') {
                    this._isShowDealRules = true;
                }
                if (_object[i].ChildModule == 'Deal_DealAmort') {
                    this._isShowDealAmort = true;
                }
                if (_object[i].ChildModule == 'Deal_AdjustedTotalCommitment') {
                    this._isShowDealAdjustedtotalcommitment = true;
                }
                if (_object[i].ChildModule == 'Deal_PayOff') {
                    this._isShowPayoff = true;
                }
                if (_object[i].ChildModule == 'Deal_FeeInvoice') {
                    this._isShowFeeInvoice = true;
                }
                if (_object[i].ChildModule == 'Deal_Maturity') {
                    this._isShowDealMaturity = true;
                }
                if (_object[i].ChildModule == 'Deal_ReserveFundWorkflow') {
                    this._isShowReserveTab = true;
                }
                if (_object[i].ChildModule == 'Deal_Prepay') {
                    this._isShowDealPrepaymentPremium = true;
                }
            }
            //show activity tab
            this._isShowActivityLog = true;
            if (_object.length >= 1) {
                var controlarrayedit = _object.filter(function (item) { return item.ModuleType === 'Control' && item.RightsName === 'Edit'; });
                //for (var i = 0; i < controlarrayedit.length; i++) {
                //    if (controlarrayedit[i].ChildModule == 'btnDownloadCashflows') {
                //        $("#btnDownloadNoteCashflowsExportData").show();
                //    }
                //}
                // search to find main in list
                var maintab = _object.filter(function (item) { return item.ChildModule === 'Deal_Funding'; });
                if (maintab.length != 0 || typeof maintab != 'undefined') {
                    var tabarray = _object.filter(function (item) { return item.ModuleType === 'Tab' && item.ChildModule === 'Deal_Funding'; });
                    if (tabarray.length > 0 && typeof maintab != 'undefined') {
                        var str = tabarray[0].ChildModule.split('_')[1];
                        str = "a" + str;
                        setTimeout(function () {
                            document.getElementById(str).click();
                        }.bind(this), 600);
                    }
                    else {
                        //click on main tab
                        setTimeout(function () {
                            document.getElementById("aMain").click();
                        }.bind(this), 600);
                    }
                }
                else {
                    //click on main tab
                    setTimeout(function () {
                        document.getElementById("aMain").click();
                    }.bind(this), 600);
                }
                //apply control permission
                var controlarrayedit = _object.filter(function (item) { return item.ModuleType === 'Control' && item.RightsName === 'Edit'; });
                for (var i = 0; i < controlarrayedit.length; i++) {
                    if (controlarrayedit[i].ChildModule == 'btnSaveDeal') {
                        if (this.listdealfunding)
                            this._isShowSaveDeal = true;
                        this._isShowSaveDealAllowForThisRole = true;
                    }
                    if (controlarrayedit[i].ChildModule == 'btnCopyDeal') {
                        this._isShowCopyDeal = true;
                    }
                    if (controlarrayedit[i].ChildModule == 'btnDealDownloadCashflows') {
                        this._isShowDownloadCashflows = true;
                    }
                    if (controlarrayedit[i].ChildModule == 'btnDealCalcJsonScriptEngine') {
                        this._isShowCalcScript = true;
                    }
                    if (controlarrayedit[i].ChildModule == 'btnAddFundingSequence') {
                        this._isShowAddFundingSequence = true;
                    }
                    if (controlarrayedit[i].ChildModule == 'btnAddRepaymentSequence') {
                        this._isShowAddRePaymentSequence = true;
                    }
                    if (controlarrayedit[i].ChildModule == 'btnExportToServicer') {
                        this._isShowDownloadExportToServicer = true;
                        this.HideExportToServicerTab();
                    }
                    if (controlarrayedit[i].ChildModule == 'btnDealCalcPayoffPenalty') {
                        this._isShowDealCalcPayoffPenalty = true;
                    }
                }
                //apply control permission for enable/disable
                var controlarrayedit = _object.filter(function (item) { return item.ModuleType === 'Control' && item.RightsName === 'View'; });
                for (var i = 0; i < controlarrayedit.length; i++) {
                    if (controlarrayedit[i].ChildModule == 'txtTotalCommitment') {
                        this._disabledTotalCommitment = false;
                    }
                    if (controlarrayedit[i].ChildModule == 'txtAdjustedTotalCommitment') {
                        this._disabledTotalCommitmentAdjustment = false;
                    }
                    if (controlarrayedit[i].ChildModule == 'txtDealFundingComment') {
                        this._disabledComment = false;
                    }
                    if (controlarrayedit[i].ChildModule == 'tblFundingRules') {
                        this._isReadOnlyFundingRules = false;
                    }
                }
            }
        }
        catch (err) {
            //console.log(err);
        }
    };
    DealDetailComponent.prototype.HideExportToServicerTab = function () {
        if (this._deal.Statusid == 323) {
            this._isShowDownloadExportToServicer = true;
        }
        else
            this._isShowDownloadExportToServicer = false;
    };
    DealDetailComponent.prototype.HideAllTabs = function () {
        this._isShowFuturefunding = false;
        this._isShowHome = false;
        this._isShowNotePayrule = false;
        this._isShowDocImport = false;
        //$("#btnDownloadNoteCashflowsExportData").hide();
        this._isShowActivityLog = true;
    };
    DealDetailComponent.prototype.HideNonSuperAdminUser = function () {
        var ret_val = false;
        var rolename = window.localStorage.getItem("rolename");
        if (rolename != null) {
            if (rolename.toString() == "Super Admin") {
                ret_val = true;
            }
        }
        return ret_val;
    };
    DealDetailComponent.prototype.checkIfArrayIsUnique = function (myArray, fieldName) {
        var isUnique = true;
        for (var i = 0; i < myArray.length; i++) {
            for (var j = 0; j < myArray.length; j++) {
                if (i != j) {
                    if (fieldName == 'CRENoteID') {
                        if (myArray[i].CRENoteID && myArray[j].CRENoteID) {
                            if (myArray[i].CRENoteID.trim().toLowerCase() == myArray[j].CRENoteID.trim().toLowerCase() && myArray[i].CRENoteID.trim().toLowerCase() != "") {
                                isUnique = false;
                            }
                        }
                    }
                    if (fieldName == 'NoteName') {
                        if (fieldName == 'NoteName') {
                            if (myArray[i].Name && myArray[j].Name) {
                                if (myArray[i].Name.trim().toLowerCase() == myArray[j].Name.trim().toLowerCase() && myArray[i].Name.trim().toLowerCase()) {
                                    isUnique = false;
                                }
                            }
                        }
                    }
                    if (fieldName == 'CRENewNoteID') {
                        if (fieldName == 'CRENewNoteID') {
                            if (myArray[i].CRENewNoteID && myArray[j].CRENewNoteID) {
                                if (myArray[i].CRENewNoteID.trim().toLowerCase() == myArray[j].CRENewNoteID.trim().toLowerCase() && myArray[i].CRENewNoteID.trim().toLowerCase()) {
                                    isUnique = false;
                                }
                            }
                        }
                    }
                    if (fieldName == 'PrepayCRENoteID') {
                        if (myArray[i].CRENoteID && myArray[j].CRENoteID) {
                            if (myArray[i].CRENoteID.trim().toLowerCase() == myArray[j].CRENoteID.trim().toLowerCase() && myArray[i].CRENoteID.trim().toLowerCase() != "") {
                                if (this.convertDateToBindable(myArray[i].SpreadDate) === this.convertDateToBindable(myArray[j].SpreadDate)) {
                                    isUnique = false;
                                }
                            }
                        }
                    }
                }
            }
        }
        return isUnique;
    };
    DealDetailComponent.prototype.checkIfNoteIdorNameBlank = function (myArray) {
        var isblank = false;
        var fieldName1 = 'CRENoteID';
        var fieldName2 = 'NoteName';
        var isblankName = false;
        var isblankID = false;
        if (myArray.length > 1) {
            for (var i = 0; i < myArray.length; i++) {
                if (myArray[i].CRENoteID != undefined) {
                    if (myArray[i].CRENoteID == '' || myArray[i].CRENoteID == null || myArray[i].CRENoteID.trim() == '') {
                        isblankID = true;
                        // break;
                    }
                }
                else {
                    isblankID = true;
                }
                if (myArray[i].Name != undefined) {
                    if (myArray[i].Name == '' || myArray[i].Name == null || myArray[i].Name.trim() == '') {
                        isblankName = true;
                        // break;
                    }
                }
                else {
                    isblankName = true;
                }
                if ((isblankID == true && isblankName == false) || (isblankID == false && isblankName == true)) {
                    isblank = true;
                    break;
                }
            }
        }
        else {
            if (myArray[0].CRENoteID != undefined) {
                if (myArray[0].CRENoteID == '' || myArray[0].CRENoteID == null || myArray[0].CRENoteID.trim() == '') {
                    isblankID = true;
                }
            }
            else {
                isblankID = true;
            }
            if (myArray[0].Name != undefined) {
                if (myArray[0].Name == '' || myArray[0].Name == null || myArray[0].Name.trim() == '') {
                    isblankName = true;
                }
            }
            else {
                isblankID = true;
            }
            if (isblankName == true || isblankID == true) {
                isblank = true;
            }
        }
        return isblank;
    };
    DealDetailComponent.prototype.isString = function (value) { return typeof value === 'string'; };
    DealDetailComponent.prototype.checkIfPropertyNameBlank = function (myArray) {
        var isblank = false;
        //var newArray = myArray.filter(value => Object.keys(this.isString(value) ? value.trim() : value).length !== 0);
        for (var i = 0; i < myArray.length; i++) {
            if (this.ChecKForProperValue(myArray[i].City) || this.ChecKForProperValue(myArray[i].Address) || this.ChecKForProperValue(myArray[i].SQFT)) {
                if (myArray[i].PropertyName != undefined) {
                    if (myArray[i].PropertyName == '' || myArray[i].PropertyName == null) {
                        isblank = true;
                    }
                    else {
                        isblank = false;
                    }
                }
                else {
                    isblank = true;
                }
            }
        }
        return isblank;
    };
    DealDetailComponent.prototype.ChecKForProperValue = function (value) {
        var isblank = true;
        if (value) {
            if (value.trim() != '') {
                isblank = true;
            }
            else {
                isblank = false;
            }
        }
        else {
            isblank = false;
        }
        return isblank;
    };
    DealDetailComponent.prototype.SaveDealfunc = function (objDeal) {
        var _this = this;
        this._deal.FullyExtMaturityDate = this.convertDatetoGMT(this._deal.FullyExtMaturityDate);
        this.convertDatetoGMTGrid(this._deal.PayruleDealFundingList, 'dealPayruleDealFundingList');
        // this.convertDatetoGMTGrid(this._deal.Amort.DealAmortScheduleList, 'Deal Amortization');
        this.TempDealRule = this._deal.DealRule;
        if (this._deal.PayruleTargetNoteFundingScheduleList != undefined) {
            for (var i = 0; i < this._deal.PayruleTargetNoteFundingScheduleList.length; i++) {
                if (this._deal.PayruleTargetNoteFundingScheduleList[i].Date != null) {
                    this._deal.PayruleTargetNoteFundingScheduleList[i].Date = this.convertDatetoGMT(this._deal.PayruleTargetNoteFundingScheduleList[i].Date);
                }
            }
        }
        else {
            this._deal.PayruleTargetNoteFundingScheduleList = this.lstNoteFunding;
        }
        //add deleted rows
        if (this.deletedynamicList != undefined) {
            for (var m = 0; m < this.deletedynamicList.length; m++) {
                //increment for adding new column in dealfunding grid
                if (this.dynamicColList.length > 32) {
                    for (var k = 33; k < this.dynamicColList.length; k++) {
                        if (this.dynamicColList[k] != "Date" && this.dynamicColList[k] != "PurposeID" && this.dynamicColList[k] != "DealFundingRowno" && this.dynamicColList[k] != "Applied") {
                            var newlistdeleted = new deals_1.Notefunding;
                            newlistdeleted.NoteID = this.lstSequenceHistory.find(function (x) { return x.Name == _this.dynamicColList[k]; }).NoteID;
                            newlistdeleted.NoteName = this.dynamicColList[k];
                            newlistdeleted.Value = this.deletedynamicList[m][this.dynamicColList[k]];
                            newlistdeleted.Date = this.deletedynamicList[m].Date;
                            newlistdeleted.isDeleted = 1;
                            newlistdeleted.PurposeID = this.deletedynamicList[m].PurposeID;
                            newlistdeleted.Purpose = this.deletedynamicList[m].PurposeText;
                            this._deal.PayruleTargetNoteFundingScheduleList.push(newlistdeleted);
                        }
                    }
                }
                else {
                    for (var k = 0; k < this.dynamicColList.length; k++) {
                        if (this.dynamicColList[k] != "Date" && this.dynamicColList[k] != "PurposeID" && this.dynamicColList[k] != "DealFundingRowno" && this.dynamicColList[k] != "Applied") {
                            var newlistdeleted = new deals_1.Notefunding;
                            newlistdeleted.NoteID = this.lstSequenceHistory.find(function (x) { return x.Name == _this.dynamicColList[k]; }).NoteID;
                            newlistdeleted.NoteName = this.dynamicColList[k];
                            newlistdeleted.Value = this.deletedynamicList[m][this.dynamicColList[k]];
                            newlistdeleted.Date = this.deletedynamicList[m].Date;
                            newlistdeleted.isDeleted = 1;
                            newlistdeleted.PurposeID = this.deletedynamicList[m].PurposeID;
                            newlistdeleted.Purpose = this.deletedynamicList[m].PurposeText;
                            this._deal.PayruleTargetNoteFundingScheduleList.push(newlistdeleted);
                        }
                    }
                }
            }
        }
        if (this._deal.Flag_DealAmortSave) {
            this.AssignAmortValueToDataContract();
        }
        var DealFundingDelete = [];
        this._deal.DeletedDealFundingList = [];
        if (this.deletedynamicList.length > 0) {
            var DealFunding = this.deletedynamicList;
            for (var i = 0; i < DealFunding.length; i++) {
                this._deal.DeletedDealFundingList.push(DealFunding[i]);
            }
            for (var i = 0; i < this._deal.DeletedDealFundingList.length; i++) {
                if (!(Number(this._deal.DeletedDealFundingList[i].PurposeText).toString() == "NaN" || Number(this._deal.DeletedDealFundingList[i].PurposeText) == 0)) {
                    this._deal.DeletedDealFundingList[i].PurposeID = Number(this._deal.DeletedDealFundingList[i].PurposeText);
                }
            }
        }
        //add items that are removed from  autospread
        if (this.lstDealFundAutoSpreadDeleted) {
            if (this.lstDealFundAutoSpreadDeleted.length > 0) {
                DealFundingDelete = this.lstDealFundAutoSpreadDeleted;
                for (var i = 0; i < DealFundingDelete.length; i++) {
                    if (DealFundingDelete[i].DealFundingID != null && DealFundingDelete[i].DealFundingID !== undefined) {
                        this._deal.DeletedDealFundingList.push(DealFundingDelete[i]);
                    }
                }
            }
        }
        //add items removed from Total Commitment
        if (this.deladjustmentcommitment) {
            this._deal.DeleteAdjustedTotalCommitment = [];
            for (var n = 0; n < this.deladjustmentcommitment.length; n++) {
                this._deal.DeleteAdjustedTotalCommitment.push(this.deladjustmentcommitment[n]);
            }
        }
        if (this.lstAdjustedTotalCommitment) {
            this.TotalCommitmentGridbind(this.listAdjustedTotalCommitment, 'Save');
            this.AssignValuestoAdjustedNoteCommitment(false);
        }
        this._deal.AnalysisID = window.localStorage.getItem("scenarioid");
        //added for testing issue
        //this._deal.PayruleDealFundingList = null;
        //this._deal.amort = null;
        if (this._deal.PayruleDealFundingList != null && this._deal.PayruleDealFundingList !== undefined) {
            if (this._deal.PayruleDealFundingList.length > 0) {
                if (this._deal.PayruleDealFundingList[0]["WF_IsAllow"] === undefined || this._deal.PayruleDealFundingList[0]["WF_IsAllow"] == null) {
                    this._deal.PayruleDealFundingList[0]["WF_IsAllow"] = false;
                }
                if (this._deal.PayruleDealFundingList[0]["WF_IsCompleted"] === undefined || this._deal.PayruleDealFundingList[0]["WF_IsCompleted"] == null) {
                    this._deal.PayruleDealFundingList[0]["WF_IsCompleted"] = false;
                }
                if (this._deal.PayruleDealFundingList[0]["WF_IsFlowStart"] === undefined || this._deal.PayruleDealFundingList[0]["WF_IsFlowStart"] == null) {
                    this._deal.PayruleDealFundingList[0]["WF_IsFlowStart"] = false;
                }
                if (this._deal.PayruleDealFundingList[0]["WF_isParticipate"] === undefined || this._deal.PayruleDealFundingList[0]["WF_isParticipate"] == null) {
                    this._deal.PayruleDealFundingList[0]["WF_isParticipate"] = false;
                }
                if (this._deal.PayruleDealFundingList[0]["wf_isUserCurrentFlow"] === undefined || this._deal.PayruleDealFundingList[0]["wf_isUserCurrentFlow"] == null) {
                    this._deal.PayruleDealFundingList[0]["wf_isUserCurrentFlow"] = false;
                }
            }
        }
        //
        if (this._isInvoiceTabclicked == true) {
            //commented as we are not updating the adjustment amount asof now
            this.SaveFeeInvoices();
        }
        var _isnewdeal = false;
        if (this._deal.DealID == '00000000-0000-0000-0000-000000000000') {
            _isnewdeal = true;
        }
        this.dealSrv.SaveDeal(this._deal).subscribe(function (res) {
            if (res.Succeeded) {
                _this.message = res.Message;
                var dealid = _this._deal.DealID;
                _this._deal.DealID = res.newDeailID;
                localStorage.setItem('divSucessDeal', JSON.stringify(true));
                localStorage.setItem('divSucessMsgDeal', JSON.stringify(res.Message));
                // this._isListFetching = false;
                ///Add Update Property
                _this.AddUpdateProperty();
                _this.UpdateNoteDropDowns();
                _this.note = _this.rowsToUpdate;
                if (_this.lstNote.length > 0) {
                    for (var i = 0; i < _this.lstNote.length; i++) {
                        if (!(Number(_this.lstNote[i].StatusName).toString() == "NaN" || Number(_this.lstNote[i].StatusName) == 0)) {
                            _this.lstNote[i].StatusID = Number(_this.lstNote[i].StatusName);
                        }
                        else {
                            var filteredarray = _this.lstNotestatus.filter(function (x) { return x.Name == _this.lstNote[i].StatusName; });
                            if (filteredarray.length != 0) {
                                _this.lstNote[i].StatusID = Number(filteredarray[0].LookupID);
                            }
                        }
                        if (_this._isShowDealAmort) {
                            for (var j = 0; j < _this.lstNoteListForDealAmort.length; j++) {
                                if (_this.lstNoteListForDealAmort[j].CRENoteID == _this.lstNote[i].CRENoteID) {
                                    //this.lstNote[i].RoundingNoteText = this.lstNoteListForDealAmort[j].RoundingNoteText;
                                    _this.lstNote[i].StraightLineAmortOverride = _this.lstNoteListForDealAmort[j].StraightLineAmortOverride;
                                    _this.lstNote[i].UseRuletoDetermineAmortizationText = _this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortizationText;
                                }
                            }
                        }
                    }
                    //to save note level total commitments
                    if (_isnewdeal == true) {
                        for (var n = 0; n < _this.lstNote.length; n++) {
                            _this.lstNote[n].OriginalTotalCommitment = _this.lstNote[n].TotalCommitment;
                        }
                    }
                    else {
                        if (_this._deal.Listadjustedtotlacommitment) {
                            if (_this._deal.Listadjustedtotlacommitment.length > 0) {
                                var lastrownumber = _this._deal.Listadjustedtotlacommitment.length - 1;
                                var lastrow = _this._deal.Listadjustedtotlacommitment[lastrownumber].Rownumber;
                                for (var j = 0; j < _this._deal.Listadjustedtotlacommitment.length; j++) {
                                    if (_this._deal.Listadjustedtotlacommitment[j].Rownumber == lastrow) {
                                        for (var m = 0; m < _this.lstNote.length; m++) {
                                            if (_this.lstNote[m].NoteId == _this._deal.Listadjustedtotlacommitment[j].NoteID) {
                                                _this.lstNote[m].AdjustedTotalCommitment = _this._deal.Listadjustedtotlacommitment[j].NoteAdjustedTotalCommitment;
                                                _this.lstNote[m].AggregatedTotal = _this._deal.Listadjustedtotlacommitment[j].NoteAggregatedTotalCommitment;
                                                _this.lstNote[m].TotalCommitment = _this._deal.Listadjustedtotlacommitment[j].NoteTotalCommitment;
                                            }
                                        }
                                    }
                                    // save original total commitment value
                                    if (_this._deal.Listadjustedtotlacommitment[j].TypeText == "Closing") {
                                        for (var n = 0; n < _this.lstNote.length; n++) {
                                            var closingdate = new Date(_this.lstNote[n].ClosingDate).getDate() + '/' + new Date(_this.lstNote[n].ClosingDate).getMonth() + '/' + new Date(_this.lstNote[n].ClosingDate).getFullYear();
                                            var adjustmentdate = new Date(_this._deal.Listadjustedtotlacommitment[j].Date).getDate() + '/' + new Date(_this._deal.Listadjustedtotlacommitment[j].Date).getMonth() + '/' + new Date(_this._deal.Listadjustedtotlacommitment[j].Date).getFullYear();
                                            if (closingdate == adjustmentdate) {
                                                if (_this.lstNote[n].NoteId == _this._deal.Listadjustedtotlacommitment[j].NoteID) {
                                                    _this.lstNote[n].OriginalTotalCommitment = _this._deal.Listadjustedtotlacommitment[j].Amount;
                                                    _this.lstNote[n].AdjustedTotalCommitment = _this._deal.Listadjustedtotlacommitment[j].Amount;
                                                    _this.lstNote[n].AggregatedTotal = _this._deal.Listadjustedtotlacommitment[j].Amount;
                                                    _this.lstNote[n].TotalCommitment = _this._deal.Listadjustedtotlacommitment[j].Amount;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            for (var n = 0; n < _this.lstNote.length; n++) {
                                _this.lstNote[n].OriginalTotalCommitment = _this.lstNote[n].OriginalTotalCommitment;
                                _this.lstNote[n].AdjustedTotalCommitment = _this.lstNote[n].AdjustedTotalCommitment;
                                _this.lstNote[n].AggregatedTotal = _this.lstNote[n].AggregatedTotal;
                                _this.lstNote[n].TotalCommitment = _this.lstNote[n].TotalCommitment;
                            }
                        }
                    }
                    if (_this._isMaturityTabClicked == true) {
                        // to save maturity configuration
                        for (var n = 0; n < _this.lstNote.length; n++) {
                            for (var l = 0; l < _this.lstMaturityConfiguration.length; l++) {
                                if (_this.lstNote[n].CRENoteID == _this.lstMaturityConfiguration[l].CRENoteID) {
                                    _this.lstNote[n].MaturityMethodID = _this.lstMaturityConfiguration[l].MaturityMethodID == null ? 0 : _this.lstMaturityConfiguration[l].MaturityMethodID;
                                    _this.lstNote[n].MaturityGroupName = _this.lstMaturityConfiguration[l].MaturityGroupName == null ? '' : _this.lstMaturityConfiguration[l].MaturityGroupName;
                                }
                            }
                            if (_this.noteMaturityList) {
                                _this.lstNote[0].NoteMaturityList = _this.noteMaturityList;
                                if (n != 0) {
                                    _this.lstNote[n].NoteMaturityList = [];
                                    _this.lstNote[n].NoteMaturityList.push({ "CRENoteID": "Test" });
                                }
                            }
                        }
                    }
                    if (_this._isPrepaymentTabClicked == true) {
                        _this.AddNewPrePayPremium();
                    }
                    if (_this._isRuleTabClicked == true) {
                        _this.AddUpdateDealRuleTypeSetup();
                    }
                    _this.convertDatetoGMTGrid(_this.lstNote, 'lstNote');
                    _this.noteSrv.addNewNote(_this.lstNote).subscribe(function (res) {
                        if (res.Succeeded) {
                            localStorage.setItem('ShowSaveMsg', 'show');
                            var returnUrl = _this._router.url;
                            if (window.location.href.indexOf("dealdetail/a/") > -1) {
                                returnUrl = returnUrl.toString().replace('dealdetail/a/', 'dealdetail/');
                            }
                            else if (returnUrl.indexOf("dealdetail/") > -1) {
                                returnUrl = returnUrl.toString().replace('dealdetail/', 'dealdetail/a/');
                            }
                            if (dealid == "00000000-0000-0000-0000-000000000000") {
                                returnUrl = returnUrl.replace('00000000-0000-0000-0000-000000000000', _this._deal.CREDealID);
                            }
                            _this._router.navigate([returnUrl.replace("/invoice", "")]);
                        }
                    });
                    setTimeout(function () {
                        this._ShowmessagedivWar = false;
                    }.bind(_this), 5000);
                }
                else {
                    _this._isListFetching = false;
                    _this._location.back();
                }
                _this.SendPushNotification();
            }
            else {
                _this._isListFetching = false;
                _this._ShowmessagedivWar = true;
                _this._ShowmessagedivMsgWar = "Error occurred while saving Deal , please contact to system administrator.";
            }
        });
        setTimeout(function () {
            this._ShowmessagedivWar = false;
            //  console.log(this._ShowmessagedivWar);
        }.bind(this), 5000);
    };
    DealDetailComponent.prototype.Cancel = function () {
        //this._router.navigate(['dashboard']);
    };
    DealDetailComponent.prototype.OpenNotes = function () {
        for (var i = 0; i < (this.lstNote.length); i++) {
            var notepath = ['/#/notedetail/' + this.lstNote[i].NoteId];
            window.open(notepath.toString(), '_blank', '');
        }
    };
    DealDetailComponent.prototype.OpenFundingNotes = function () {
        for (var i = 0; i < (this.lstSequenceHistory.length); i++) {
            var notepath = ['/#/notedetail/' + this.lstSequenceHistory[i].NoteID];
            window.open(notepath.toString(), '_blank', '');
        }
    };
    DealDetailComponent.prototype.selectionChangedHandlerNote = function () {
        try {
            for (var i = 0; i < this.lstNote.length; i++)
                this.updatedRowNo.push(i);
        }
        catch (err) {
            //console.log(err);
        }
    };
    DealDetailComponent.prototype.getNoteByDealID = function (note) {
        var _this = this;
        this.noteSrv.getNotesFromDealDetailByDealId(note, 1, 1000).subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.lstNotesDeal;
                //data.sort(this.SortByNoteID);
                _this.lstNote = data;
                _this.lstNote.forEach(function (e) {
                    e.FunctionName = 'CalculateNote';
                });
                _this.GetNoteSequenceHistoryByDealID(_this._deal);
                //this.GetNotePayruleSetupDataByDealID(this._deal.DealID);
                _this.ConvertToBindableDate(_this.lstNote);
                _this.lstCopyNote = _this.lstNote;
                //fetch "Critical" error count
                _this._CritialExceptionNoteList = _this.lstNote.filter(function (x) { return x.cntCritialException > 0 && x.StatusID == 1; });
                _this._CritialExceptionAlert = "Please resolve the critical exceptions in the notes, recalculate them and then try again to download the cashflows.";
                for (var i = 0; i < _this._CritialExceptionNoteList.length; i++) { //loop through the array
                    _this._CritialExceptionListCount += _this._CritialExceptionNoteList[i].cntCritialException; //Do the math!
                    if (i == 0) {
                        _this._CritialExceptionAlert += "<br>" + "Note ID:";
                    }
                    _this._CritialExceptionAlert += " " + _this._CritialExceptionNoteList[i].CRENoteID;
                    if (i < _this._CritialExceptionNoteList.length - 1) {
                        _this._CritialExceptionAlert += ",";
                    }
                }
                if (_this.flexRules) {
                    _this.flexRules.itemFormatter = function (panel, r, c, cell) {
                        if (panel.cellType == 1) {
                            cell.setAttribute("id", "cell" + r + c);
                        }
                    };
                }
                // Apply ID attribute for Note FlexGrid
                var dealid = _this._deal.DealID;
                if (_this.flex) {
                    if (_this._deal.Statusid) {
                        if (_this._deal.Statusid == 325 || _this._deal.Statusid.toString() == "Phantom")
                            _this.flex.columns[4].isReadOnly = false;
                        else
                            _this.flex.columns[4].isReadOnly = true;
                    }
                    var colindex = _this.flex.getColumn("TotalCommitment").index;
                    _this.flex.itemFormatter = function (panel, r, c, cell) {
                        if (panel.cellType == 1) {
                            cell.setAttribute("id", "cell" + r + c);
                        }
                        if (c == colindex) {
                            if (dealid == "00000000-0000-0000-0000-000000000000") {
                                cell.style.backgroundColor = null;
                            }
                            else {
                                var item = panel.getCellData(r, c);
                                var colfooter = panel.rows.length - 1;
                                if (r < colfooter || item == null) {
                                    cell.style.backgroundColor = '#cfcfcf';
                                }
                            }
                        }
                    };
                }
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    DealDetailComponent.prototype.CloseCopyPopUp = function () {
        setTimeout(function () {
            this._deal.CopyDealID = '';
            this._deal.CopyDealName = '';
            this._ShowcopydivWar = false;
            this._dealcopymsg = "";
            // this.lstCopyNote = null;
            this._dealcopymsg = '';
            this._isdealCopied = false;
            this._Showmessagediv = false;
            this._ShowcopydivWar = false;
            this._dealcopymsg = '';
            this._isdealCopied = false;
            this._ShowmessagedivMsg = "";
        }.bind(this), 2000);
        var modalCopy = document.getElementById('myModalCopyDeal');
        modalCopy.style.display = "none";
    };
    DealDetailComponent.prototype.getPropertyByDealID = function (dealID) {
        var _this = this;
        this.property.Deal_DealID = dealID;
        this.propertySrv.getallproperty(this.property, 1, 1000).subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.lstProperty;
                _this.lstProperty = data;
            }
            else {
                _this._router.navigate(['login']);
            }
        });
    };
    DealDetailComponent.prototype.UpdateNoteDropDowns = function () {
        try {
            if (this.lstNote.length > 0) {
                if (this.lstNoteListForDealAmort !== undefined) {
                    for (var i = 0; i < this.lstNote.length; i++) {
                        for (var j = 0; j < this.lstNoteListForDealAmort.length; j++) {
                            if (this.lstNoteListForDealAmort[j].CRENoteID == this.lstNote[i].CRENoteID) {
                                this.lstNote[i].RoundingNoteText = this.lstNoteListForDealAmort[j].RoundingNoteText;
                                this.lstNote[i].RoundingNote = this.lstNoteListForDealAmort[j].RoundingNote;
                                this.lstNote[i].UseRuletoDetermineAmortizationText = this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortizationText;
                                this.lstNote[i].UseRuletoDetermineAmortization = this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortization;
                            }
                        }
                    }
                }
            }
            this.selectionChangedHandlerNote();
            this.rowsToUpdate = [];
            for (var i = 0; i < this.updatedRowNo.length; i++) {
                this.lstNote[this.updatedRowNo[i]].DealID = this._deal.DealID;
                //update property with dropdows selected Item
                if (!(Number(this.lstNote[this.updatedRowNo[i]].RateTypeText).toString() == "NaN" || Number(this.lstNote[this.updatedRowNo[i]].RateTypeText) == 0)) {
                    this.lstNote[this.updatedRowNo[i]].RateType = Number(this.lstNote[this.updatedRowNo[i]].RateTypeText);
                }
                if (!(Number(this.lstNote[this.updatedRowNo[i]].NoteFundingRuleText).toString() == "NaN" || Number(this.lstNote[this.updatedRowNo[i]].NoteFundingRuleText) == 0)) {
                    this.lstNote[this.updatedRowNo[i]].NoteFundingRule = Number(this.lstNote[this.updatedRowNo[i]].NoteFundingRuleText);
                }
                if (!(Number(this.lstNote[this.updatedRowNo[i]].UseRuletoDetermineNoteFundingText).toString() == "NaN" || Number(this.lstNote[this.updatedRowNo[i]].UseRuletoDetermineNoteFundingText) == 0)) {
                    this.lstNote[this.updatedRowNo[i]].UseRuletoDetermineNoteFunding = Number(this.lstNote[this.updatedRowNo[i]].UseRuletoDetermineNoteFundingText);
                }
                ////Vishal
                if (!(Number(this.lstNote[this.updatedRowNo[i]].RoundingNoteText).toString() == "NaN" || Number(this.lstNote[this.updatedRowNo[i]].RoundingNoteText) == 0)) {
                    this.lstNote[this.updatedRowNo[i]].RoundingNote = Number(this.lstNote[this.updatedRowNo[i]].RoundingNoteText);
                }
                if (!(Number(this.lstNote[this.updatedRowNo[i]].UseRuletoDetermineAmortizationText).toString() == "NaN" || Number(this.lstNote[this.updatedRowNo[i]].UseRuletoDetermineAmortizationText) == 0)) {
                    this.lstNote[this.updatedRowNo[i]].UseRuletoDetermineAmortization = Number(this.lstNote[this.updatedRowNo[i]].UseRuletoDetermineAmortizationText);
                }
                this.lstNote[this.updatedRowNo[i]].ClientNoteID = this.lstNote[this.updatedRowNo[i]].CRENoteID;
                this.rowsToUpdate.push(this.lstNote[this.updatedRowNo[i]]);
            }
        }
        catch (err) {
            console.log(err);
        }
    };
    DealDetailComponent.prototype.CopyDeal = function () {
        for (var i = 0; i < this.lstNote.length; i++) {
            if (this.lstNote[i].CRENewNoteID) {
                this.lstNote[i].CRENewNoteID = null;
            }
        }
        var modalCopy = document.getElementById('myModalCopyDeal');
        modalCopy.style.display = "block";
        $.getScript("/js/jsDrag.js");
        this.lstCopyNote = this.lstNote;
        this.flexCopy.invalidate();
    };
    DealDetailComponent.prototype.CopyToDeal = function (CopyDealID, CopyDealName, lstCopyNote, isopen) {
        var _this = this;
        this._ShowcopydivWar = false;
        this._isdealCopied = true;
        var copydeal;
        var msgstring = "";
        var noteid = "";
        var valstring = "";
        if (CopyDealID != null || CopyDealID != undefined) {
            CopyDealID = CopyDealID.trim();
        }
        if (CopyDealName != null || CopyDealName != undefined) {
            CopyDealName = CopyDealName.trim();
        }
        copydeal = new deals_1.deals('');
        if (!CopyDealID) {
            msgstring = msgstring.concat("Deal Id" + ", ");
        }
        if (!CopyDealName) {
            msgstring = msgstring + "Deal Name" + ", ";
        }
        copydeal.AnalysisID = window.localStorage.getItem("scenarioid");
        if (lstCopyNote) {
            lstCopyNote = lstCopyNote.filter(function (item) { return item.Isexclude == false; });
            if (lstCopyNote.length == 0) {
                valstring = "<p>" + "Please select at least one note" + "</p>";
            }
            for (var i = 0; i < lstCopyNote.length; i++) {
                if (lstCopyNote[i].Isexclude == false) {
                    if (!lstCopyNote[i].CRENewNoteID) {
                        noteid = "Note Id" + ", ";
                    }
                }
            }
        }
        if (noteid != "") {
            msgstring = msgstring + noteid;
        }
        if (msgstring != "") {
            msgstring = "</p>" + msgstring.slice(0, msgstring.length - 2) + " cannot be blank." + "</p>";
            valstring = msgstring + valstring;
        }
        if (valstring != "") {
            setTimeout(function () {
                this._isdealCopied = false;
            }.bind(this), 3000);
            this.CustomAlert(valstring);
        }
        else {
            copydeal.CREDealID = CopyDealID;
            copydeal.DealName = CopyDealName;
            copydeal.DealID = "00000000-0000-0000-0000-000000000000";
            copydeal.notelist = new Array();
            for (var i = 0; i < lstCopyNote.length; i++) {
                copydeal.notelist.push(lstCopyNote[i]);
                for (var j = 0; j < this.lstNoteListForDealAmort.length; j++) {
                    if (copydeal.notelist[i].CRENoteID == this.lstNoteListForDealAmort[j].CRENoteID) {
                        copydeal.notelist[i].StraightLineAmortOverride = this.lstNoteListForDealAmort[j].StraightLineAmortOverride;
                    }
                }
                // copydeal.notelist[i].CRENoteID = lstCopyNote[i].CRENewNoteID;
                copydeal.notelist[i].NoteId = "00000000-0000-0000-0000-000000000000";
            }
            var noteidUnique = this.checkIfArrayIsUnique(copydeal.notelist, 'CRENewNoteID');
            var uniqueNoteName = this.checkIfArrayIsUnique(copydeal.notelist, 'NoteName');
            if (noteidUnique && uniqueNoteName) {
                this.dealSrv.checkduplicatedeal(copydeal).subscribe(function (res) {
                    if (res.Succeeded) {
                        if (res.Message == "Save") {
                            if (_this._deal && _this.lstNote) {
                                _this._deal.AnalysisID = window.localStorage.getItem("scenarioid");
                                _this.dealSrv.SaveDeal(_this._deal).subscribe(function (res) {
                                    if (res.Succeeded) {
                                        _this.dealSrv.copydeal(copydeal).subscribe(function (res) {
                                            if (res.Succeeded) {
                                                _this._dealcopymsg = res.Message;
                                                _this._ShowmessagedivMsg = res.Message;
                                                _this._ShowcopydivWar = true;
                                                _this._Showmessagediv = true;
                                                _this._isdealCopied = false;
                                                if (isopen) {
                                                    var newcopieddeal; //= ['notedetail', this._noteextt.NoteId];
                                                    if (window.location.href.indexOf("dealdetail/a/") > -1) {
                                                        newcopieddeal = ['dealdetail', _this._deal.CopyDealID];
                                                    }
                                                    else {
                                                        newcopieddeal = ['dealdetail/a', _this._deal.CopyDealID];
                                                    }
                                                    if (newcopieddeal.indexOf("/invoice") > -1)
                                                        _this._router.navigate(newcopieddeal.replace("/invoice", ""));
                                                    else
                                                        _this._router.navigate(newcopieddeal);
                                                }
                                                _this.CloseCopyPopUp();
                                            }
                                        });
                                    }
                                    else {
                                        _this._ShowmessagedivWar = true;
                                        _this._ShowmessagedivMsgWar = "Error occurred while creating copy deal, please contact your system administrator.";
                                        _this.CloseCopyPopUp();
                                    }
                                });
                            }
                        }
                        else {
                            setTimeout(function () {
                                this._isdealCopied = false;
                            }.bind(_this), 3000);
                            _this.CustomAlert(res.Message);
                        }
                    }
                    else {
                        _this._ShowmessagedivWar = true;
                        _this._ShowmessagedivMsgWar = "Error occurred while creating copy deal, please contact your system administrator.";
                    }
                });
            }
            else {
                setTimeout(function () {
                    this._isdealCopied = false;
                }.bind(this), 3000);
                var errmsg = '';
                if (!noteidUnique) {
                    errmsg += "Note id" + ", ";
                }
                if (!uniqueNoteName) {
                    errmsg += "Note name  ";
                }
                this.CustomAlert("<p>" + "Please enter unique " + errmsg.slice(0, -2) + "." + "</p>");
            }
        }
    };
    DealDetailComponent.prototype.selectionChangedHandlerProperty = function () {
        var flexPro = this.flexPro;
        var rowIdx = this.flexPro.collectionView.currentPosition;
        try {
            var count = this.PropupdatedRowNo.indexOf(rowIdx);
            if (count == -1)
                this.PropupdatedRowNo.push(rowIdx);
        }
        catch (err) {
            // console.log(err);
        }
    };
    DealDetailComponent.prototype.setCopiedDataflexPro = function () {
        try {
            var sel = this.flexPro.selection;
            for (var c = sel.topRow; c <= sel.bottomRow; c++) {
                this.PropupdatedRowNo.push(c);
            }
        }
        catch (err) {
            console.log(err);
        }
    };
    DealDetailComponent.prototype.AddUpdateProperty = function () {
        try {
            this.ProprowsToUpdate = [];
            for (var i = 0; i < this.PropupdatedRowNo.length; i++) {
                this.lstProperty[this.PropupdatedRowNo[i]].DealID = this._deal.DealID;
                if (!(Number(this.lstProperty[this.PropupdatedRowNo[i]].PropertyTypeText).toString() == "NaN" || Number(this.lstProperty[this.PropupdatedRowNo[i]].PropertyTypeText) == 0)) {
                    this.lstProperty[this.PropupdatedRowNo[i]].PropertyType = Number(this.lstProperty[this.PropupdatedRowNo[i]].PropertyTypeText);
                }
                this.ProprowsToUpdate.push(this.lstProperty[this.PropupdatedRowNo[i]]);
            }
        }
        catch (err) {
            //console.log(err);
        }
        var ispropertyblank = false;
        ispropertyblank = this.checkIfPropertyNameBlank(this.ProprowsToUpdate);
        if (!ispropertyblank) {
            this.property = this.ProprowsToUpdate;
            this.propertySrv.AddupdateProperty(this.property).subscribe(function (res) {
                if (res.Succeeded) {
                    //    alert("Succeed");
                }
            });
        }
        else {
            this._ShowmessagedivWar = true;
            this._ShowmessagedivMsgWar = 'Property name is required.';
            this._isListFetching = false;
        }
        (function (error) { return console.error('Error: ' + error); });
    };
    DealDetailComponent.prototype.ConvertToDate = function (date) {
        return new Date(date);
    };
    DealDetailComponent.prototype.ConvertToBindableDatePrepayProjection = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this._lstPrepayPremiumnew[i].PrepayDate != null) {
                this._lstPrepayPremiumnew[i].PrepayDate = this.convertDateToBindable(this._lstPrepayPremiumnew[i].PrepayDate);
            }
            if (this._lstPrepayPremiumnew[i].OpenPrepaymentDate != null) {
                this._lstPrepayPremiumnew[i].OpenPrepaymentDate = this.convertDateToBindable(this._lstPrepayPremiumnew[i].OpenPrepaymentDate);
            }
        }
    };
    DealDetailComponent.prototype.ConvertToBindableDatePrepayAllocation = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this._lstPrepayAllocations[i].PrepayDate != null) {
                this._lstPrepayAllocations[i].PrepayDate = this.convertDateToBindable(this._lstPrepayAllocations[i].PrepayDate);
            }
        }
    };
    DealDetailComponent.prototype.ConvertToBindableDatePrepayAdjustment = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this._lstprepayadjustment[i].Date != null) {
                this._lstprepayadjustment[i].Date = this.convertDateToBindable(this._lstprepayadjustment[i].Date);
            }
        }
    };
    DealDetailComponent.prototype.ConvertToBindableDateSpreadMaintenance = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this._lstSpreadMaintenance[i].SpreadDate != null) {
                this._lstSpreadMaintenance[i].SpreadDate = this.convertDateToBindable(this._lstSpreadMaintenance[i].SpreadDate);
            }
        }
    };
    DealDetailComponent.prototype.ConvertToBindableDateMinimumMult = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this._lstMinimumMult[i].MiniSpreadDate != null) {
                this._lstMinimumMult[i].MiniSpreadDate = this.convertDateToBindable(this._lstMinimumMult[i].MiniSpreadDate);
            }
        }
    };
    DealDetailComponent.prototype.ConvertToBindableDate = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this.lstNote[i].FirstPaymentDate != null) {
                this.lstNote[i].FirstPaymentDate = new Date(Data[i].FirstPaymentDate.toString());
            }
            if (this.lstNote[i].InitialInterestAccrualEndDate != null) {
                this.lstNote[i].InitialInterestAccrualEndDate = new Date(Data[i].InitialInterestAccrualEndDate.toString());
            }
            if (this.lstNote[i].ClosingDate != null) {
                this.lstNote[i].ClosingDate = new Date(Data[i].ClosingDate.toString());
            }
            if (this.lstNote[i].ExtendedMaturityCurrent != null) {
                this.lstNote[i].ExtendedMaturityCurrent = new Date(Data[i].ExtendedMaturityCurrent.toString());
            }
            if (this.lstNote[i].ExpectedMaturityDate != null) {
                this.lstNote[i].ExpectedMaturityDate = this.convertDatetoGMT(this.lstNote[i].ExpectedMaturityDate);
            }
            if (this.lstNote[i].FullyExtendedMaturityDate != null) {
                this.lstNote[i].FullyExtendedMaturityDate = new Date(Data[i].FullyExtendedMaturityDate.toString());
            }
            if (this.lstNote[i].InitialMaturityDate != null) {
                this.lstNote[i].InitialMaturityDate = new Date(Data[i].InitialMaturityDate.toString());
            }
            if (this.lstNote[i].ActualPayoffDate != null) {
                this.lstNote[i].ActualPayoffDate = new Date(Data[i].ActualPayoffDate.toString());
            }
            if (this.lstNote[i].OpenPrepaymentDate != null) {
                this.lstNote[i].OpenPrepaymentDate = new Date(Data[i].OpenPrepaymentDate.toString());
            }
        }
    };
    DealDetailComponent.prototype.ConvertToBindableDateFundingSchedule = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this.lstNoteFunding[i].Date != null) {
                this.lstNoteFunding[i].Date = this.convertDateToBindable(this.lstNoteFunding[i].Date);
            }
        }
    };
    DealDetailComponent.prototype.ConvertToBindableDateNoteMaturity = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this.lstSequenceHistory[i].Maturity != null) {
                this.lstSequenceHistory[i].Maturity = this.convertDateToBindable(this.lstSequenceHistory[i].Maturity);
            }
        }
    };
    DealDetailComponent.prototype.ConvertToBindableDateDealFunding = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this.listdealfunding[i].Date != null) {
                this.listdealfunding[i].Date = new Date(this.convertDateToBindable(this.listdealfunding[i].Date));
            }
            if (this.listdealfunding[i].orgDate != null) {
                this.listdealfunding[i].orgDate = new Date(this.convertDateToBindable(this.listdealfunding[i].orgDate));
            }
        }
    };
    DealDetailComponent.prototype.ConvertToBindableDateAutoSpread = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this.lstautospreadrule[i].StartDate != null) {
                this.lstautospreadrule[i].StartDate = new Date(this.convertDateToBindable(this.lstautospreadrule[i].StartDate));
            }
            if (this.lstautospreadrule[i].EndDate != null) {
                this.lstautospreadrule[i].EndDate = new Date(this.convertDateToBindable(this.lstautospreadrule[i].EndDate));
            }
        }
    };
    DealDetailComponent.prototype.ConvertToBindableDateAmort = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this.lstAmortSchedule[i].Date != null) {
                this.lstAmortSchedule[i].Date = new Date(this.convertDateToBindable(this.lstAmortSchedule[i].Date));
            }
        }
    };
    DealDetailComponent.prototype.convertDateToBindable = function (date) {
        var dateObj = null;
        if (date) {
            if (typeof (date) == "string") {
                date = date.replace("Z", "");
                dateObj = new Date(date);
            }
            else {
                dateObj = date;
            }
            if (dateObj != null) {
                return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear();
            }
        }
    };
    DealDetailComponent.prototype.getTwoDigitString = function (number) {
        if (number.toString().length === 1)
            return "0" + number;
        return number;
    };
    ////////// Dropdown ///////////////////
    // apply/remove data maps
    DealDetailComponent.prototype._bindGridDropdows = function () {
        //alert('_updateDataMaps');
        var flex = this.flex;
        var flexPro = this.flexPro;
        var flexDynamicColForSequence = this.grdflexDynamicColForSequence;
        //var flexDynamicColForNotePayruleSetup = this.grdflexDynamicColForNotePayruleSetup;
        var flexPayruleNoteDetail = this.flexFutureFunding;
        var flexdealfunding = this.flexdealfunding;
        var flexNoteDetailDealAmort = this.flexNoteListForDealAmort;
        var flexDealAdjustedTotalCommitment = this.flexadjustedtotalcommitment;
        var flexMaturity = this.flexMaturity;
        var flexMaturityConfig = this.flexMaturityConfig;
        if (flex) {
            //alert('flex');
            var colRateType = flex.columns.getColumn('RateTypeText');
            //alert(colRateType);
            if (colRateType) {
                //  alert(colRateType);
                colRateType.showDropDown = true; // show drop-down for countries
                colRateType.dataMap = this._buildDataMap(this.lstRateType);
            }
            var colStatus = flex.columns.getColumn('StatusName');
            //alert(colRateType);
            if (colStatus) {
                //  alert(colRateType);
                colStatus.showDropDown = true; // show drop-down for countries
                colStatus.dataMap = this._buildDataMap(this.lstNotestatus);
            }
        }
        if (flexDynamicColForSequence) {
            var colUseRuletoDetermineNoteFunding = flexDynamicColForSequence.columns.getColumn('UseRuletoDetermineNoteFundingText');
            var colNoteFundingRule = flexDynamicColForSequence.columns.getColumn('NoteFundingRuleText');
            if (colUseRuletoDetermineNoteFunding) {
                colUseRuletoDetermineNoteFunding.showDropDown = true;
                colUseRuletoDetermineNoteFunding.dataMap = this._buildDataMap(this.lstUseRuletoDetermineNoteFundingType);
            }
            if (colNoteFundingRule) {
                colNoteFundingRule.showDropDown = true;
                colNoteFundingRule.dataMap = this._buildDataMap(this.lstNoteFundingRuleType);
            }
        }
        if (flexPayruleNoteDetail) {
            var colUseRuletoDetermineNoteFunding = flexPayruleNoteDetail.columns.getColumn('UseRuletoDetermineNoteFundingText');
            var colNoteFundingRule = flexPayruleNoteDetail.columns.getColumn('NoteFundingRuleText');
            if (colUseRuletoDetermineNoteFunding) {
                colUseRuletoDetermineNoteFunding.showDropDown = true;
                colUseRuletoDetermineNoteFunding.dataMap = this._buildDataMap(this.lstUseRuletoDetermineNoteFundingType);
            }
            if (colNoteFundingRule) {
                colNoteFundingRule.showDropDown = true;
                colNoteFundingRule.dataMap = this._buildDataMap(this.lstNoteFundingRuleType);
            }
        }
        if (flexdealfunding) {
            var colPurposeType = flexdealfunding.columns.getColumn('PurposeText');
            if (colPurposeType) {
                colPurposeType.showDropDown = true;
                colPurposeType.dataMap = this._buildDataMap(this.lstPurposeType);
            }
        }
        if (flexPro) {
            var colProperty = flexPro.columns.getColumn('PropertyTypeText');
            if (colProperty) {
                colProperty.showDropDown = true;
                colProperty.dataMap = this._buildDataMap(this.lstPropertyType);
            }
        }
        if (flexNoteDetailDealAmort) {
            var colRoundingNote = flexNoteDetailDealAmort.columns.getColumn('RoundingNoteText');
            var colUseRuletoDetermineAmortization = flexNoteDetailDealAmort.columns.getColumn('UseRuletoDetermineAmortizationText');
            if (colRoundingNote) {
                colRoundingNote.showDropDown = true;
                colRoundingNote.dataMap = this._buildDataMap(this.lstRoundingNote);
            }
            if (colUseRuletoDetermineAmortization) {
                colUseRuletoDetermineAmortization.showDropDown = true;
                colUseRuletoDetermineAmortization.dataMap = this._buildDataMap(this.lstUseRuletoDetermineAmortization);
            }
        }
        if (flexDealAdjustedTotalCommitment) {
            var colTypeText = flexDealAdjustedTotalCommitment.columns.getColumn('TypeText');
            if (colTypeText) {
                colTypeText.showDropDown = true;
                colTypeText.dataMap = this._buildDataMap(this.lstAdjustedTotalCommitmentType);
            }
        }
        if (flexMaturity) {
            var colMaturityType = flexMaturity.columns.getColumn('MaturityTypeText');
            if (colMaturityType) {
                colMaturityType.showDropDown = true;
                colMaturityType.dataMap = this._buildDataMap(this.maturityTypeList);
            }
            var colMaturityApproved = flexMaturity.columns.getColumn('ApprovedText');
            if (colMaturityApproved) {
                colMaturityApproved.showDropDown = true;
                colMaturityApproved.dataMap = this._buildDataMap(this.maturityApprovedList);
            }
        }
        if (flexMaturityConfig) {
            var colMethodID = flexMaturityConfig.columns.getColumn('MaturityMethodIDText');
            if (colMethodID) {
                colMethodID.showDropDown = true;
                colMethodID.dataMap = this._buildDataMap(this.lstMaturityMethodID);
            }
        }
    };
    // build a data map from a string array using the indices as keys
    DealDetailComponent.prototype._buildDataMap = function (items) {
        var map = [];
        for (var i = 0; i < items.length; i++) {
            var obj = items[i];
            map.push({ key: obj['LookupID'], value: obj['Name'] });
        }
        return new wjcGrid.DataMap(map, 'key', 'value');
    };
    DealDetailComponent.prototype._buildDataMapWithoutLookupNew = function (items) {
        var map = [];
        for (var i = 0; i < items.length; i++) {
            var obj = items[i];
            map.push({ key: obj['FeeTypeNameID'], value: obj['FeeTypeNameText'] });
        }
        return new wjcGrid.DataMap(map, 'key', 'value');
    };
    DealDetailComponent.prototype._buildDataMapWithoutLookupForNoteId = function (items) {
        var map = [];
        for (var i = 0; i < items.length; i++) {
            var obj = items[i];
            map.push({ key: obj['NoteId'], value: obj['CRENoteID'] });
        }
        return new wjcGrid.DataMap(map, 'key', 'value');
    };
    DealDetailComponent.prototype._buildDataMapWithoutLookupForRuleType = function (items) {
        var map = [];
        for (var i = 0; i < items.length; i++) {
            var obj = items[i];
            map.push({ key: obj['FileName'], value: obj['FileName'] });
        }
        return new wjcGrid.DataMap(map, 'key', 'value');
    };
    DealDetailComponent.prototype._bindGridDropdowsWithoutLookup = function () {
        //alert('_updateDataMaps');
        var flexDynamicColForNotePayruleSetup = this.grdflexDynamicColForNotePayruleSetup;
        if (flexDynamicColForNotePayruleSetup) {
            var colRule = flexDynamicColForNotePayruleSetup.columns.getColumn('RuleText');
            if (colRule) {
                colRule.showDropDown = true;
                colRule.dataMap = this._buildDataMapWithoutLookup(this.listfeeamount);
            }
        }
    };
    DealDetailComponent.prototype._buildDataMapWithoutLookup = function (items) {
        var map = [];
        for (var i = 0; i < items.length; i++) {
            var obj = items[i];
            map.push({ key: obj['ID'], value: obj['NameText'] });
        }
        return new wjcGrid.DataMap(map, 'key', 'value');
    };
    //FlexGrid refreshing on Tab click
    DealDetailComponent.prototype.showfutureFundingGD = function () {
        var _this = this;
        this._isListFetching = true;
        localStorage.setItem('ClickedTabId', 'aFunding');
        this._isCallConcurrentCheck = true;
        this._isShowLastUpdateFFMsg = this._deal.LastUpdatedFF_String != null && this._deal.LastUpdatedFF_String != '';
        this._deal.Flag_DealFundingSave = true;
        setTimeout(function () {
            if (!_this.lstAdjustedTotalCommitment) {
                _this.GetAdjustmenttotalcommitment(_this._deal.DealID);
            }
        }, 250);
        setTimeout(function () {
            _this._isListFetching = false;
        }, 1000);
        setTimeout(function () {
            try {
                _this._deal.Flag_DealFundingSave = true;
                _this.flexdealfunding.invalidate();
                _this.grdflexDynamicColForSequence.invalidate();
                _this.flexautospreadrule.invalidate();
                //  this.AppliedReadOnly();
                setTimeout(function () {
                    this.grdflexDynamicColForSequence.autoSizeColumns(0, this.grdflexDynamicColForSequence.columns.length - 1, false, 20);
                    //  this.grdflexDynamicColForSequence.columns[1].width = 300; // for Note name
                    //remove first cell selection
                    this.flexdealfunding.select(this.flexdealfunding.rows.length - 1, 0);
                    // focus on select row and ready for editing
                    //this.flexdealfunding.focus();
                    //this.flexautospreadrule.focus();
                }.bind(_this), 10);
            }
            catch (err) { }
        }, 200);
    };
    DealDetailComponent.prototype.GetDealFundingByDealID = function (_objDeal) {
        var _this = this;
        try {
            this.dealfunding.DealID = _objDeal.DealID;
            this.dealSrv.GetNoteDealFundingByDealID(_objDeal).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.listfdealfunding = [];
                    var data = res.lstNoteDealFunding;
                    _this.listwfStatusPurposeMapping = res.lstWFStatusPurposeMapping;
                    _this.listdealfunding = data;
                    var controlarrayedit = _this.lstUserPermission.filter(function (item) { return item.ModuleType === 'Control' && item.RightsName === 'Edit'; });
                    if (_this.listdealfunding) {
                        _this.isShowgenerateButton = true;
                        for (var i = 0; i < controlarrayedit.length; i++) {
                            if (controlarrayedit[i].ChildModule == 'btnSaveDeal') {
                                _this._isShowSaveDeal = true;
                            }
                        }
                    }
                    _this.listdealfundingwithoutchange = [];
                    _this.originallistdealfunding = [];
                    for (var d = 0; d < data.length; d++) {
                        if (data[d].Date) {
                            _this.listfdealfunding.push({ "DealID": _objDeal.CREDealID, "Date": data[d].Date, "Value": data[d].Value });
                        }
                        _this.originallistdealfunding.push({ "DealID": _objDeal.CREDealID, "Date": data[d].Date, "Value": data[d].Value });
                        _this.listdealfundingwithoutchange.push({ DealFundingID: data[d].DealFundingID, PurposeID: data[d].PurposeID, "PurposeText": data[d].PurposeText, "Date": data[d].Date, "Value": data[d].Value, "DealFundingRowno": data[d].DealFundingRowno });
                    }
                    _this.dynamicColList = [];
                    var header = [];
                    if (_this.listdealfunding.length == 1) {
                        if (_this.listdealfunding[0].DealFundingID == null) {
                            _this.listdealfunding[0].Applied = false;
                        }
                    }
                    _this._totalDealFunding = parseFloat(data.reduce(function (a, b) { return a + b.Value; }, 0).toFixed(2));
                    _this.ConvertToBindableDateDealFunding(_this.listdealfunding);
                    $.each(data, function (obj) {
                        var i = 0;
                        $.each(data[obj], function (key, value) {
                            header[i] = key;
                            i = i + 1;
                        });
                        return false;
                    });
                    _this.dynamicColList = header;
                    //removing privious generated funding for note from grid
                    if (_this.flexdealfunding.columns.length > 0) {
                        if (_this.IsAutoSpreadActive == true) {
                            //    // removing privious generated funding for note from grid
                            //    for (var j = 13; j < this.flexdealfunding.columns.length; j++) {
                            //        this.flexdealfunding.columns.splice(13, j);
                            //    }
                            //}
                            //else {
                            for (var j = 12; j < _this.flexdealfunding.columns.length; j++) {
                                _this.flexdealfunding.columns.splice(12, j);
                            }
                        }
                    }
                    _this.flexdealfunding.invalidate();
                    // this.columnsForNoteDealFunding = [];                   
                    if (_this.listdealfunding.length > 0) {
                        _this.getEquityValues();
                        //Use Rule N 
                        //increment for adding new column in dealfunding grid
                        for (var j = 33; j < header.length; j++) {
                            _this.AddcolumnNoteDealFunding(header[j], header[j], true);
                        }
                        // }
                        _this.cvDealFundingList = new wjcCore.CollectionView(_this.listdealfunding);
                        _this.cvDealFundingList.trackChanges = true;
                        //push unique dates and values
                        var dynamicColIndex = 0;
                        if (_this.listdealfunding) {
                            for (var j = 0; j < _this.listdealfunding.length; j++) {
                                //GeneratedByText
                                if (_this.listdealfunding[j].GeneratedByText !== undefined && _this.listdealfunding[j].GeneratedByText !== null) {
                                    _this.listdealfunding[j].GeneratedBy = _this.lstGeneratedBy.find(function (x) { return x.Name == _this.listdealfunding[j].GeneratedByText; }).LookupID;
                                }
                                _this.listdealfunding[j]["isValidDate"] = true;
                                var gendynamicCol = [];
                                gendynamicCol["Date"] = _this.listdealfunding[j].Date;
                                gendynamicCol["PurposeID"] = _this.listdealfunding[j].PurposeID;
                                gendynamicCol["DealFundingRowno"] = _this.listdealfunding[j].DealFundingRowno;
                                gendynamicCol["Applied"] = _this.listdealfunding[j].Applied;
                                //increment for adding new column in dealfunding grid
                                for (var m = 32; m < header.length; m++) {
                                    // assign $0 when Deal funding is $0
                                    if (_this.listdealfunding[j].Value == 0) {
                                        _this.listdealfunding[j][header[m]] = 0;
                                    }
                                    else {
                                        gendynamicCol[header[m]] = _this.listdealfunding[j][header[m]];
                                    }
                                }
                                _this.gendynamicColList.push(gendynamicCol);
                            }
                        }
                    }
                    else {
                        if (_this.ShowUseRuleN == true) {
                            if (header.length == 0) {
                                if (_this.lstSequenceHistory) {
                                    if (_this.lstSequenceHistory.length > 0) {
                                        for (var j = 0; j < _this.lstSequenceHistory.length; j++) {
                                            _this.AddcolumnNoteDealFunding(_this.lstSequenceHistory[j].Name, _this.lstSequenceHistory[j].Name, true);
                                            header[j] = _this.lstSequenceHistory[j].Name;
                                        }
                                        _this.dynamicColList = header;
                                    }
                                }
                            }
                        }
                        _this.listdealfunding = [];
                        _this.cvDealFundingList = new wjcCore.CollectionView(_this.listdealfunding);
                        _this.cvDealFundingList.trackChanges = true;
                    }
                    _this.EnableDisableAutospreadRepayments();
                    setTimeout(function () {
                        if (this._deal.EnableAutoSpread || this._deal.ApplyNoteLevelPaydowns) {
                            // this.flexdealfunding.autoClipboard = false;
                            this.flexdealfunding.columns[9].isReadOnly = false;
                            var _lstUseRuleN = this.lstSequenceHistory.filter(function (x) { return x.UseRuletoDetermineNoteFundingText == "4" || x.UseRuletoDetermineNoteFundingText == "N" || x.UseRuletoDetermineNoteFundingText == null || x.UseRuletoDetermineNoteFundingText == ""; });
                            //if (this.flexdefunding) {
                            //    if (_lstUseRuleN.length != this.lstNote.length) {
                            //        this.flexdefunding.autoClipboard = false;
                            //    } else {
                            //        this.flexdealfunding.autoClipboard = true;
                            //    }
                            //}
                        }
                        else {
                            this.flexdealfunding.autoClipboard = true;
                        }
                        this.AppliedReadOnly();
                    }.bind(_this), 100);
                    _this._isListFetching = false;
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
        }
    };
    DealDetailComponent.prototype.GetNoteFundingByDealID = function (_objDeal) {
        var _this = this;
        try {
            this.dealSrv.GetNoteFundingByDealID(_objDeal).subscribe(function (res) {
                if (res.Succeeded) {
                    var data = res.lstnoteFundingschedule;
                    _this.lstNoteFunding = data;
                    _this._totalNoteFunding = parseFloat(data.reduce(function (a, b) { return a + b.Value; }, 0).toFixed(2));
                    _this.ConvertToBindableDateFundingSchedule(_this.lstNoteFunding);
                }
                else {
                    //  this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
        }
    };
    DealDetailComponent.prototype.CallPayRuleFutureFunding = function (_objDeal) {
        var _this = this;
        try {
            _objDeal.DealName = this._deal.DealName;
            this._isDeleteOPtionOk = true;
            if (_objDeal.PayruleDealFundingList) {
                if (_objDeal.PayruleDealFundingList.length > 0) {
                    if (_objDeal.PayruleDealFundingList[0]["WF_IsAllow"] === undefined || _objDeal.PayruleDealFundingList[0]["WF_IsAllow"] == null) {
                        _objDeal.PayruleDealFundingList[0]["WF_IsAllow"] = false;
                    }
                    if (_objDeal.PayruleDealFundingList[0]["WF_IsCompleted"] === undefined || _objDeal.PayruleDealFundingList[0]["WF_IsCompleted"] == null) {
                        _objDeal.PayruleDealFundingList[0]["WF_IsCompleted"] = false;
                    }
                    if (_objDeal.PayruleDealFundingList[0]["WF_IsFlowStart"] === undefined || _objDeal.PayruleDealFundingList[0]["WF_IsFlowStart"] == null) {
                        _objDeal.PayruleDealFundingList[0]["WF_IsFlowStart"] = false;
                    }
                    if (_objDeal.PayruleDealFundingList[0]["WF_isParticipate"] === undefined || _objDeal.PayruleDealFundingList[0]["WF_isParticipate"] == null) {
                        _objDeal.PayruleDealFundingList[0]["WF_isParticipate"] = false;
                    }
                    if (_objDeal.PayruleDealFundingList[0]["wf_isUserCurrentFlow"] === undefined || _objDeal.PayruleDealFundingList[0]["wf_isUserCurrentFlow"] == null) {
                        _objDeal.PayruleDealFundingList[0]["wf_isUserCurrentFlow"] = false;
                    }
                }
            }
            this.dealSrv.GenerateFutureFunding(_objDeal).subscribe(function (res) {
                if (res.Succeeded) {
                    var showfunding = "";
                    var UseRuleNDeal = false;
                    if (_this.isShowGenerateAutospreadRepay == true) {
                        _this.isShowGenerateAutospreadRepay = false;
                    }
                    if (_this.isMaturityDataChanged == true) {
                        _this.isMaturityDataChanged = false;
                    }
                    var header = [];
                    var noteInGrid = "False";
                    var noteCount = (_this.flexdealfunding.columns.length) - 7;
                    var data = res.DealDataContract.PayruleTargetNoteFundingScheduleList;
                    var lstPayruleDealFundingList = res.DealDataContract.PayruleDealFundingList;
                    _this.listdealfunding = res.DealDataContract.PayruleDealFundingList;
                    _this.ConvertToBindableDateDealFunding(_this.listdealfunding);
                    var deldata = res.DealDataContract.PayruleDeletedDealFundingList;
                    _this.CalculateRemainingAmount(_this.listdealfunding);
                    for (var j = 0; j < _this.listdealfunding.length; j++) {
                        _this.listdealfunding[j].GeneratedByText = _this.lstGeneratedBy.find(function (x) { return x.LookupID == _this.listdealfunding[j].GeneratedBy; }).Name;
                    }
                    if (_this._deal.EnableAutoSpread == true) {
                        if (_this.lstautospreadrule) {
                            _this.ConvertToBindableDateAutoSpread(_this.lstautospreadrule);
                        }
                    }
                    if (_this._deal.EnableAutospreadRepayments == true) {
                        _this._deal.RepayExpectedMaturityDate = res.DealDataContract.RepayExpectedMaturityDate;
                    }
                    else {
                        _this._deal.RepayExpectedMaturityDate = null;
                    }
                    if (deldata) {
                        if (deldata.length > 0) {
                            for (var i = 0; i < deldata.length; i++) {
                                if (deldata[i].DealFundingID != null && deldata[i].DealFundingID !== undefined) {
                                    _this.lstDealFundAutoSpreadDeleted.push(deldata[i]);
                                }
                            }
                        }
                    }
                    //determin deal is n deal or Y deal
                    var lstUseRuleN = _this.lstSequenceHistory.filter(function (x) { return x.UseRuletoDetermineNoteFundingText == "3" || x.UseRuletoDetermineNoteFundingText == "Y"; });
                    if (lstUseRuleN.length == 0) {
                        UseRuleNDeal = true;
                    }
                    //this.listdealfunding
                    //this.cvDealFundingList.remove(this.listdealfunding);
                    _this.cvDealFundingList = new wjcCore.CollectionView(_this.listdealfunding);
                    _this.cvDealFundingList.trackChanges = true;
                    _this._isdealfundingChanged = true;
                    _this._isdealfundingEdit = true;
                    _this.isrowdeleted = false;
                    _this._isFundingruleChanged = false;
                    _this._autospreadgenerate = false;
                    _this._isrepaymentChanged = false;
                    for (var r = 0; r < _this.lstSequenceHistory.length; r++) {
                        _this.lstSequenceHistory[r].EstBls = _this.lstSequenceHistory[r].EndingBalance;
                    }
                    //Estimated Balance logic
                    var date = _this.convertDateToBindable(new Date());
                    for (var d = 0; d < res.DealDataContract.PayruleTargetNoteFundingScheduleList.length; d++) {
                        if (_this.convertDateToBindable(res.DealDataContract.PayruleTargetNoteFundingScheduleList[d].Date) == date) {
                            for (var r = 0; r < _this.lstSequenceHistory.length; r++) {
                                if (_this.lstSequenceHistory[r].NoteID == res.DealDataContract.PayruleTargetNoteFundingScheduleList[d].NoteID) {
                                    //if (this.lstSequenceHistory[r].UseRuletoDetermineNoteFundingText == "3" || this.lstSequenceHistory[r].UseRuletoDetermineNoteFundingText == "Y")
                                    {
                                        _this.lstSequenceHistory[r]["EstBls"] = Number(_this.lstSequenceHistory[r]["EstBls"]) + Number(res.DealDataContract.PayruleTargetNoteFundingScheduleList[d].Value);
                                    }
                                    //else {
                                    //    this.lstSequenceHistory[r]["EstBls"] = Number(this.lstSequenceHistory[r]["EndingBalance"]);
                                    //}
                                }
                            }
                            //var p = this.lstSequenceHistory.find(x => x.Name == res.DealDataContract.PayruleTargetNoteFundingScheduleList[d]["NoteName"]);
                        }
                    }
                    _this.grdflexDynamicColForSequence.invalidate();
                    //End of Estimated logic
                    // Refresh grid
                    // removing privious generated funding for note from grid
                    if (_this.IsAutoSpreadActive == true) {
                        // removing privious generated funding for note from grid
                        //    for (var j = 13; j < this.flexdealfunding.columns.length; j++) {
                        //        this.flexdealfunding.columns.splice(13, j);
                        //    }
                        //}
                        //else {
                        for (var j = 12; j < _this.flexdealfunding.columns.length; j++) {
                            _this.flexdealfunding.columns.splice(12, j);
                        }
                    }
                    //if (this._deal.EnableAutoSpread || this.repaymentchecked == true) {
                    //    this.flexdealfunding.autoClipboard = false;
                    //}
                    _this.flexdealfunding.invalidate();
                    _this.lstNoteFunding = data;
                    debugger;
                    //adding note in header
                    for (var j = 0; j < _this.lstNoteFunding.length; j++) {
                        noteInGrid = "False";
                        if (header.length == 0)
                            header.push(_this.lstNoteFunding[j].NoteName);
                        else {
                            for (var i = 0; i < header.length; i++) {
                                if (header[i] == _this.lstNoteFunding[j].NoteName) {
                                    noteInGrid = "True";
                                }
                            }
                            if (noteInGrid == "False") {
                                header.push(_this.lstNoteFunding[j].NoteName);
                            }
                        }
                        // this.lstNoteFunding[j].GeneratedByText = this.lstGeneratedBy.find(x => x.LookupID == this.lstNoteFunding[j].GeneratedBy).Name;
                        var GeneratedByT = _this.lstGeneratedBy.filter(function (x) { return x.LookupID == _this.lstNoteFunding[j].GeneratedBy; });
                        if (GeneratedByT[0]) {
                            _this.lstNoteFunding[j].GeneratedByText = GeneratedByT[0].Name;
                        }
                    }
                    if (header.includes("DealFundingID")) {
                        _this.dynamicColList = header;
                    }
                    else {
                        var splength = _this.dynamicColList.length - 33;
                        _this.dynamicColList.splice(33, _this.dynamicColList.length - 33);
                        for (var k = 0; k < header.length; k++) {
                            _this.dynamicColList.push(header[k]);
                        }
                    }
                    //Add date column in dynamic list
                    header.push("Date");
                    header.push("PurposeID");
                    header.push("DealFundingRowno");
                    header.push("Applied");
                    // this.dynamicColList = header;
                    var dynamicColList = [];
                    //push unique dates and values
                    var dynamicColIndex = 0;
                    for (var j = 0; j < _this.lstNoteFunding.length; j++) {
                        noteInGrid = "False";
                        var dynamicCol = [];
                        //for (var k = 0; k < header.length; k++) {
                        //    dynamicCol[header[k]] = 0;
                        //}
                        if (j == 0) {
                            dynamicCol["Date"] = _this.lstNoteFunding[j].Date;
                            dynamicCol["PurposeID"] = _this.lstNoteFunding[j].PurposeID;
                            dynamicCol["DealFundingRowno"] = _this.lstNoteFunding[j].DealFundingRowno;
                            dynamicCol["Applied"] = _this.lstNoteFunding[j].Applied;
                            dynamicCol[_this.lstNoteFunding[j].NoteName] = _this.lstNoteFunding[j].Value;
                            dynamicColList.push(dynamicCol);
                        }
                        else {
                            for (var i = 0; i < dynamicColList.length; i++) {
                                //   if (dynamicColList[i].Date == this.lstNoteFunding[j].Date && dynamicColList[i].PurposeID == this.lstNoteFunding[j].PurposeID) {
                                if (dynamicColList[i].DealFundingRowno == _this.lstNoteFunding[j].DealFundingRowno) {
                                    dynamicColList[i][_this.lstNoteFunding[j].NoteName] = _this.lstNoteFunding[j].Value;
                                    noteInGrid = "True";
                                }
                            }
                            if (noteInGrid == "False") {
                                dynamicCol["Date"] = _this.lstNoteFunding[j].Date;
                                dynamicCol["PurposeID"] = _this.lstNoteFunding[j].PurposeID;
                                dynamicCol["DealFundingRowno"] = _this.lstNoteFunding[j].DealFundingRowno;
                                dynamicCol["Applied"] = _this.lstNoteFunding[j].Applied;
                                dynamicCol[_this.lstNoteFunding[j].NoteName] = _this.lstNoteFunding[j].Value;
                                dynamicColList.push(dynamicCol);
                            }
                        }
                    }
                    //Restrict to generate funding if values affect wire confirm values
                    //this.gendynamicColList.sort(this.SortBynumber);
                    dynamicColList.sort(_this.SortBynumber);
                    _this.listdealfunding.sort(_this.SortBynumber);
                    //dynamicColList.sort(this.SortByDateandApplied);
                    //this.listdealfunding.sort(this.SortByDateandApplied);
                    /*
                    for (var m = 0; m < this.listdealfunding.length; m++) {
             
                        for (var l = 0; l < header.length; l++) {
                            if (header[l] != "Date" && header[l] != "PurposeID" && header[l] != "DealFundingRowno" && header[l] != "Applied") {
                                if (this.listdealfunding[m].Applied == true) {
                                    dynamicColList[m][header[l]] = this.gendynamicColList[m][header[l]];
                                    if (this.gendynamicColList[m] != undefined) {
                                        if (dynamicColList[m][header[l]] == undefined && this.gendynamicColList[m][header[l]] != undefined) {
                                            dynamicColList[m][header[l]] = 0
                                        }
                                        if (dynamicColList[m][header[l]] != undefined) {
                                            if (dynamicColList[m][header[l]] != this.gendynamicColList[m][header[l]]) {
                                                //assign old value
                                                this.gendynamicColList[m][header[l]] = dynamicColList[m][header[l]];
             
                                                var diffval = parseFloat((this.gendynamicColList[m][header[l]] - dynamicColList[m][header[l]]).toFixed(2));
             
                                                if (Math.abs(diffval) > 0.01) {
                                                    // if (Math.abs(diffval) > 0) {
                                                    this._isfixedvaluechanged = true;
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                    else {
                                        if (this.gendynamicColList[m][header[l]] != undefined) {
                                            this._isfixedvaluechanged = true;
                                            break;
                                        }
                                    }
                                }
                            }
                            if (this._isfixedvaluechanged == true) {
                                break;
                            }
                        }
                    }
                    */
                    //Restrict to generate funding if values affect wire confirm values
                    // add Value in the list
                    if (!_this._isfixedvaluechanged) {
                        if (dynamicColList.length > 0) {
                            for (var m = 0; m < dynamicColList.length; m++) {
                                // dynamicColIndex = this.listdealfunding.findIndex(x => x.Date == dynamicColList[m]["Date"] && x.PurposeID == dynamicColList[m]["PurposeID"]);
                                for (var l = 0; l < header.length; l++) {
                                    if (header[l] != "Date" && header[l] != "PurposeID" && header[l] != "DealFundingRowno" && header[l] != "Applied") {
                                        if (dynamicColList[m][header[l]] != undefined) {
                                            if (_this.listdealfunding[m] != undefined) {
                                                //  if (this.listdealfunding[m]["DealFundingRowno"] == dynamicColList[m][header["DealFundingRowno"]]) {
                                                _this.listdealfunding[m][header[l]] = dynamicColList[m][header[l]];
                                                //}
                                            }
                                            else {
                                                if (_this.listdealfunding) {
                                                    if (m < _this.listdealfunding.length)
                                                        _this.listdealfunding[m][header[l]] = '';
                                                }
                                            }
                                        }
                                        else {
                                            if (_this.listdealfunding) {
                                                if (m < _this.listdealfunding.length)
                                                    _this.listdealfunding[m][header[l]] = '';
                                            }
                                        }
                                    }
                                }
                            }
                            _this.gendynamicColList = dynamicColList;
                            _this.flexdealfunding.invalidate();
                        }
                    }
                    else {
                        _this._isFundingruleChanged = true;
                        showfunding = "do not show";
                        _this.CustomAlert("The change in funding sequence or repayment sequence results in changing the wire confirm record values. Please un-check the Wire Confirm first to process this sequence change.");
                    }
                    if (_this.IsAutoSpreadActive == true) {
                        for (var j = 12; j < _this.flexdealfunding.columns.length; j++) {
                            _this.flexdealfunding.columns.splice(12, j);
                        }
                    }
                    if (dynamicColList.length > 0) {
                        //Pushing column in grid
                        for (var j = 0; j < header.length; j++) {
                            if (header[j] != "Date" && header[j] != "PurposeID" && header[j] != "DealFundingRowno" && header[j] != "Applied") {
                                _this.AddcolumnNoteDealFunding(header[j], header[j], true);
                                //if (UseRuleNDeal == true) {
                                //    //for n deal note columns will  be editable
                                //    this.AddcolumnNoteDealFunding(header[j], header[j], true);
                                //} else {
                                //    this.AddcolumnNoteDealFunding(header[j], header[j], false);
                                //}
                            }
                        }
                        _this.flexdealfunding.invalidate();
                    }
                    setTimeout(function () {
                        this.AppliedReadOnly();
                    }.bind(_this), 100);
                    _this._isDeleteOPtionOk = false;
                    if (!_this._isautospreadRepaymentshow) {
                        _this.ShowUseRuleN = false;
                    }
                    if (showfunding == "") {
                        _this._Showmessagediv = true;
                        _this._ShowmessagedivMsg = res.Message;
                        setTimeout(function () {
                            this._Showmessagediv = false;
                        }.bind(_this), 5000);
                    }
                    else {
                        //showfunding = "Note " + this.lstSequenceHistory[j].CRENoteID + " has the funding after the Maturity Date " + this.convertDateToBindable(this.lstSequenceHistory[j].Maturity);
                        //this.CustomAlert(showfunding);
                    }
                    if (_this._deal.EnableAutospreadRepayments == true) {
                        if (_this._deal.RepayExpectedMaturityDate != null) {
                            _this.maturityExpectedMaturityDate = _this._deal.RepayExpectedMaturityDate;
                        }
                        else {
                            _this.maturityExpectedMaturityDate = _this.maturityExpectedMaturityDate;
                        }
                    }
                    else {
                        _this.maturityExpectedMaturityDate = _this.maturityExpectedMaturityDate;
                    }
                    _this.syncDealfundingandTotalcommitmentlistforYnotes(res.DealDataContract.PayruleTargetNoteFundingScheduleList);
                    // to download excel of repayment after generate
                    if (_this._deal.AllowFundingDevDataFlag != undefined || _this._deal.AllowFundingDevDataFlag != null) {
                        if (_this._deal.AllowFundingDevDataFlag.toString() == "true") {
                            if (res.DealDataContract.ListAutoRepaymentBalances == null || res.DealDataContract.ListAutoRepaymentBalances == undefined) {
                                res.DealDataContract.ListAutoRepaymentBalances = [];
                            }
                            else {
                                for (var k = 0; k < res.DealDataContract.ListAutoRepaymentBalances.length; k++) {
                                    if (res.DealDataContract.ListAutoRepaymentBalances[k].Date != null) {
                                        res.DealDataContract.ListAutoRepaymentBalances[k].Date = new Date(_this.convertDateToBindable(res.DealDataContract.ListAutoRepaymentBalances[k].Date));
                                    }
                                }
                            }
                            if (res.DealDataContract.ListCalculatedAutoRepayment == null || res.DealDataContract.ListCalculatedAutoRepayment == undefined) {
                                res.DealDataContract.ListCalculatedAutoRepayment = [];
                            }
                            else {
                                for (var k = 0; k < res.DealDataContract.ListCalculatedAutoRepayment.length; k++) {
                                    if (res.DealDataContract.ListCalculatedAutoRepayment[k].Date != null) {
                                        res.DealDataContract.ListCalculatedAutoRepayment[k].Date = new Date(_this.convertDateToBindable(res.DealDataContract.ListCalculatedAutoRepayment[k].Date));
                                    }
                                }
                            }
                            if (res.DealDataContract.ListCummulativeProbability == null || res.DealDataContract.ListCummulativeProbability == undefined) {
                                res.DealDataContract.ListCummulativeProbability = [];
                            }
                            else {
                                for (var k = 0; k < res.DealDataContract.ListCummulativeProbability.length; k++) {
                                    if (res.DealDataContract.ListCummulativeProbability[k].ProjectedPayoffAsofDate != null) {
                                        res.DealDataContract.ListCummulativeProbability[k].ProjectedPayoffAsofDate = new Date(_this.convertDateToBindable(res.DealDataContract.ListCummulativeProbability[k].ProjectedPayoffAsofDate));
                                    }
                                }
                            }
                            if (res.DealDataContract.ListCalculatedNoteRepayment == null || res.DealDataContract.ListCalculatedNoteRepayment == undefined) {
                                res.DealDataContract.ListCalculatedNoteRepayment = [];
                            }
                            else {
                                for (var k = 0; k < res.DealDataContract.ListCalculatedNoteRepayment.length; k++) {
                                    if (res.DealDataContract.ListCalculatedNoteRepayment[k].Date != null) {
                                        res.DealDataContract.ListCalculatedNoteRepayment[k].Date = new Date(_this.convertDateToBindable(res.DealDataContract.ListCalculatedNoteRepayment[k].Date));
                                    }
                                }
                            }
                            //file name
                            var filename = _this._deal.DealName + '_Split';
                            _this.exportToExcel(filename, [res.DealDataContract.ListAutoRepaymentBalances, res.DealDataContract.ListCalculatedAutoRepayment, res.DealDataContract.ListCalculatedNoteRepayment, res.DealDataContract.ListCummulativeProbability], ['AutoRepayment Balances', 'CalculatedDealRepayment', 'CalculatedNoteRepayment', 'CummulativeProbability']);
                        }
                    }
                    if (_this._isAdjustedTotalCommitmentTabClicked == true) {
                        _this.UpdateEquitySummary();
                    }
                    _this.getEquityValues();
                }
                else {
                    if (_this._deal.EnableAutoSpread == true) {
                        if (_this.lstautospreadrule) {
                            _this.ConvertToBindableDateAutoSpread(_this.lstautospreadrule);
                        }
                    }
                    _this.ConvertToBindableDateDealFunding(_this.listdealfunding);
                    _this._isDeleteOPtionOk = false;
                    if (_this.isShowGenerateAutospreadRepay == true) {
                        _this.isShowGenerateAutospreadRepay = false;
                    }
                    if (!_this._isautospreadRepaymentshow) {
                        _this.ShowUseRuleN = false;
                    }
                    _this._isListFetching = false;
                    _this._ShowmessagedivWar = true;
                    _this._ShowmessagedivMsgWar = res.Message;
                    setTimeout(function () {
                        this._ShowmessagedivWar = false;
                    }.bind(_this), 5000);
                }
                setTimeout(function () {
                    this._isShowSaveDeal = this._isShowSaveDealAllowForThisRole == true ? true : false;
                }.bind(_this), 5100);
            });
        }
        catch (err) {
            this._isDeleteOPtionOk = false;
            if (!this._isautospreadRepaymentshow) {
                this.ShowUseRuleN = false;
            }
            if (this.isShowGenerateAutospreadRepay == true) {
                this.isShowGenerateAutospreadRepay = false;
            }
            this._isListFetching = false;
            this._ShowmessagedivWar = true;
            this.loggingService.writeToLog("Deal", "error", "Error occurred while generating future funding" + err.stack);
            this._ShowmessagedivMsgWar = "Error occurred while generating future funding. Please refresh and try again or contact M61 support";
            setTimeout(function () {
                this._ShowmessagedivWar = false;
            }.bind(this), 5000);
        }
    };
    DealDetailComponent.prototype.sortByName = function (a, b) {
        var textA = a.FileName.toUpperCase();
        var textB = b.FileName.toUpperCase();
        return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
    };
    DealDetailComponent.prototype.SortByDate = function (a, b) {
        var aDate = a.Date;
        var bDate = b.Date;
        return ((aDate < bDate) ? -1 : ((aDate > bDate) ? 1 : 0));
    };
    DealDetailComponent.prototype.SortBynumber = function (a, b) {
        var ar = a.DealFundingRowno;
        var br = b.DealFundingRowno;
        return ((ar < br) ? -1 : ((ar > br) ? 1 : 0));
    };
    DealDetailComponent.prototype.SortByDateandApplied = function (a, b) {
        var o1 = a.Date;
        var o2 = b.Date;
        var p1 = a.Applied;
        var p2 = b.Applied;
        if (o1 < o2)
            return -1;
        if (o1 > o2)
            return 1;
        if (p1 < p2)
            return -1;
        if (p1 > p2)
            return 1;
        return 0;
    };
    DealDetailComponent.prototype.GetObjects = function (obj, key, val) {
        var objects = [];
        for (var i in obj) {
            if (!obj.hasOwnProperty(i))
                continue;
            if (typeof obj[i] == 'object') {
                objects = objects.concat(this.GetObjects(obj[i], key, val));
            }
            else if (i == key && obj[key] == val) {
                objects.push(obj);
            }
        }
        return objects;
    };
    DealDetailComponent.prototype.ConvertToCurrencyFundingSchedule = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this.lstNoteFunding[i].Value != null) {
                this.lstNoteFunding[i].Value = (this.lstNoteFunding[i].Value.toFixed(2)).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            }
        }
    };
    DealDetailComponent.prototype.ConvertToCurrencyFunding = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this.listdealfunding[i].Value != null) {
                this.listdealfunding[i].Value = (this.listdealfunding[i].Value.toFixed(2)).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            }
            else {
                this.listdealfunding[i].Value = 0;
            }
        }
    };
    DealDetailComponent.prototype.GenerateRepayOrFuding = function () {
        this.ClosePopUpDialogPara('GenereateFundingDialogbox');
        this.ClosePopUpDialogPara('GenereateFundingDialogboxFF');
        if (this.repayorfundingbtn == "Repayment") {
            this.generateAutospreadRepayment();
        }
        else if (this.repayorfundingbtn == "Funding") {
            this.generateFutureFunding();
        }
    };
    DealDetailComponent.prototype.ValidateFuturePaydown = function () {
        var today = new Date();
        var SumfundingPaydown = 0, SumEstimatedcurrentbalance = 0, SumdealfundingFunding = 0, SumAdjustedCommitment = 0, SumFuturePIKFunding = 0, SumFuturePIKPaydown = 0, SumFutureAllPIKFunding = 0, SumFutureAllPIKPaydown = 0, TotalFuturePIK = 0, TotalFutureAllPIK = 0;
        if (this.listdealfunding) {
            var dealfundingPaydown = this.listdealfunding.filter(function (x) { return x.Date > today && x.Value < 0 && x.PurposeText != "Note Transfer"; });
            dealfundingPaydown.forEach(function (e) {
                SumfundingPaydown += e.Value;
            });
            var Futurefunding = this.listdealfunding.filter(function (x) { return x.Date > today && x.Value > 0; });
            Futurefunding.forEach(function (e) {
                SumdealfundingFunding += e.Value;
            });
        }
        if (this.lstSequenceHistory) {
            this.lstSequenceHistory.forEach(function (e) {
                SumEstimatedcurrentbalance += e.EstBls;
            });
            this.lstSequenceHistory.forEach(function (e) {
                SumAdjustedCommitment += e.AdjustedTotalCommitment;
            });
        }
        if (this._deal.ListNoteRepaymentBalances) {
            for (var i = 0; i < this._deal.ListNoteRepaymentBalances.length; i++) {
                if (this._deal.ListNoteRepaymentBalances[i].Date != null) {
                    this._deal.ListNoteRepaymentBalances[i].Date = new Date(this.convertDateToBindable(this._deal.ListNoteRepaymentBalances[i].Date));
                }
            }
            var FuturePIKFunding = this._deal.ListNoteRepaymentBalances.filter(function (y) { return y.Date > today && y.Type == "PIKPrincipalFunding"; });
            FuturePIKFunding.forEach(function (e) {
                SumFuturePIKFunding += e.Amount;
            });
            var FuturePIKPaydown = this._deal.ListNoteRepaymentBalances.filter(function (y) { return y.Date > today && y.Type == "PIKPrincipalPaid"; });
            FuturePIKPaydown.forEach(function (e) {
                SumFuturePIKPaydown += e.Amount;
            });
            var FutureAllPIKFunding = this._deal.ListNoteRepaymentBalances.filter(function (y) { return y.Type == "PIKPrincipalFunding"; });
            FutureAllPIKFunding.forEach(function (e) {
                SumFutureAllPIKFunding += e.Amount;
            });
            var FutureAllPIKPaydown = this._deal.ListNoteRepaymentBalances.filter(function (y) { return y.Type == "PIKPrincipalPaid"; });
            FutureAllPIKPaydown.forEach(function (e) {
                SumFutureAllPIKPaydown += e.Amount;
            });
        }
        var Warningmsg = "";
        if (SumfundingPaydown < 0)
            SumfundingPaydown = SumfundingPaydown * -1;
        TotalFuturePIK = this.getNum(SumFuturePIKFunding) + this.getNum(SumFuturePIKPaydown);
        TotalFutureAllPIK = this.getNum(SumFutureAllPIKFunding) + this.getNum(SumFutureAllPIKPaydown);
        if (TotalFuturePIK < 0)
            TotalFuturePIK = TotalFuturePIK * -1;
        if (TotalFutureAllPIK < 0)
            TotalFutureAllPIK = TotalFutureAllPIK * -1;
        //Projected Paydown(Aggregate future negative amount(except Note Transfer)) <= Current Balance + Future Funding + Future PIK Funding + Future PIK Paydown
        if (parseFloat(this.getNum(SumfundingPaydown).toFixed(2)) > parseFloat((parseFloat(this.getNum(SumEstimatedcurrentbalance).toFixed(2)) + parseFloat(this.getNum(SumdealfundingFunding).toFixed(2)) + parseFloat(this.getNum(TotalFuturePIK).toFixed(2))).toFixed(2))) {
            //if (this.getNum(SumfundingPaydown) > (this.getNum(SumEstimatedcurrentbalance) + this.getNum(SumdealfundingFunding) + TotalFuturePIK)) {
            var deltaCB = parseFloat(this.getNum(SumfundingPaydown).toFixed(2)) - (parseFloat(this.getNum(SumEstimatedcurrentbalance).toFixed(2)) + parseFloat(this.getNum(SumdealfundingFunding).toFixed(2)) + parseFloat(this.getNum(TotalFuturePIK).toFixed(2)));
            var deltaabsCB = Math.abs(parseFloat((deltaCB).toFixed(2)));
            if (deltaabsCB > 0.50) {
                Warningmsg = "<p>" + "Projected Paydown (" + this.formatMoney(SumfundingPaydown) + ") is greater than the sum of (" + this.formatMoney(parseFloat((parseFloat(this.getNum(SumEstimatedcurrentbalance).toFixed(2)) + parseFloat(this.getNum(SumdealfundingFunding).toFixed(2)) + parseFloat(this.getNum(TotalFuturePIK).toFixed(2))).toFixed(2))) + ") Current Balance, Future Funding and Future PIK.";
            }
        }
        //Projected Paydown(Aggregate future negative amount(except Note Transfer)) <= Adjusted Commitment + Future PIK Funding + Future PIK Paydown
        if (parseFloat(this.getNum(SumfundingPaydown).toFixed(2)) > parseFloat((parseFloat(this.getNum(SumAdjustedCommitment).toFixed(2)) + parseFloat(TotalFutureAllPIK.toFixed(2))).toFixed(2))) {
            var deltaAC = parseFloat(this.getNum(SumfundingPaydown).toFixed(2)) - (parseFloat(this.getNum(SumAdjustedCommitment).toFixed(2)) + parseFloat(this.getNum(TotalFutureAllPIK).toFixed(2)));
            var deltaabsAC = Math.abs(parseFloat((deltaAC).toFixed(2)));
            if (deltaabsAC > 0.50) {
                Warningmsg = Warningmsg + "<p>" + "Projected Paydown (" + this.formatMoney(SumfundingPaydown) + ") is greater than the sum of (" + this.formatMoney(parseFloat((parseFloat(this.getNum(SumAdjustedCommitment).toFixed(2)) + parseFloat(TotalFutureAllPIK.toFixed(2))).toFixed(2))) + ") Adjusted Commitment and Total PIK.";
            }
        }
        return Warningmsg;
    };
    DealDetailComponent.prototype.getNum = function (val) {
        if (isNaN(val)) {
            return 0;
        }
        return val;
    };
    DealDetailComponent.prototype.checkAndCallgenerateFutureFunding = function (buttonname) {
        var msgstring = "";
        //var msgstringFF = "";
        this.repayorfundingbtn = "";
        if (this._deal.EnableAutospreadRepayments == true) {
            for (var d = 0; d < this.listdealfunding.length; d++) {
                if (this.listdealfunding[d].PurposeText == "Paydown" || this.listdealfunding[d].PurposeText == "631") {
                    if (this.listdealfunding[d].GeneratedByText == 'User Entered') {
                        if (this.listdealfunding[d].Comment == "" || this.listdealfunding[d].Comment == null) {
                            msgstring = "<p>You have entered Paydown  without comment, the updated record will get overridden by auto spreading amount. Do you want to proceed?</p>";
                            break;
                        }
                    }
                }
            }
        }
        if (this._deal.EnableAutoSpread == true) {
            for (var d = 0; d < this.listdealfunding.length; d++) {
                if (this.listdealfunding[d].Value > 0 && this.listdealfunding[d].Applied != true) {
                    if (this.listdealfunding[d].GeneratedByText == 'User Entered') {
                        if (this.listdealfunding[d].Comment == "" || this.listdealfunding[d].Comment == null) {
                            if (msgstring != "") {
                                msgstring = msgstring;
                            }
                            msgstring = msgstring + "<p>" + "There are record(s) in deal funding grid without comment. They will be overridden by auto spreading amount. Do you want to proceed?</p>";
                            break;
                        }
                    }
                }
            }
        }
        this.repayorfundingbtn = buttonname;
        if (msgstring != "") {
            document.getElementById('dialogboxbodyFF').innerHTML = msgstring;
            this.showDialogGeneric("GenereateFundingDialogboxFF");
        }
        //else
        //if (msgstring != "") {
        //    this.showDialogGeneric("GenereateFundingDialogbox");
        //}
        else {
            if (buttonname == "Repayment") {
                this.generateAutospreadRepayment();
            }
            else if (buttonname == "Funding") {
                this.generateFutureFunding();
            }
        }
    };
    DealDetailComponent.prototype.generateFutureFunding = function () {
        var _this = this;
        this._isShowSaveDeal = false;
        this.ShowUseRuleN = true;
        var lookup = {};
        var result = [];
        var TotalDebtAmount;
        TotalDebtAmount = 0;
        var isvalidateHolidaySatSun = true;
        var errordate = '';
        var TotalLockedAmount = 0;
        var maxextendedmat = null;
        var maxmat = null;
        var errDebtServ = "";
        var totalintitalfunding = 0;
        var sumdealfundingwithnotetransfer = 0;
        var sumdealfunding = 0;
        var sumdealEquityAmount = 0;
        var sumDealRequiredEquity = 0;
        var sumDealAdditionalEquity = 0;
        var TotalDebetAmount = 0;
        var sumdealfundIncludeOtherandTransfer = 0;
        this.ConvertInSequenceList();
        var maxWiredConfirmDate = null;
        this.minClosingDate = null;
        var TotalRequiredEquity = 0, TotalAdditionalEquity = 0;
        var noteTotalAdditionalEquity = 0;
        var noteTotalRequiredEquity = 0;
        var max_ExtensionMat;
        this._deal.EnableAutospreadUseRuleN = false;
        if (this.listdealfunding.length > 0) {
            for (var df = 0; df < this.listdealfunding.length; df++) {
                if (!(Number(this.listdealfunding[df].PurposeText).toString() == "NaN" || Number(this.listdealfunding[df].PurposeText) == 0)) {
                    this.listdealfunding[df].PurposeID = Number(this.listdealfunding[df].PurposeText);
                    this.listdealfunding[df].PurposeText = this.lstPurposeType.find(function (x) { return x.LookupID == _this.listdealfunding[df].PurposeID; }).Name;
                }
                if (this.listdealfunding[df].Value) {
                    if (this.listdealfunding[df].Value > 0) {
                        if (this.listdealfunding[df].PurposeText != "Note Transfer") {
                            sumdealfundingwithnotetransfer = sumdealfundingwithnotetransfer + this.listdealfunding[df].Value;
                        }
                        if (this.listdealfunding[df].PurposeText == "Note Transfer" || this.listdealfunding[df].PurposeText == "Other") {
                            sumdealfundIncludeOtherandTransfer = sumdealfundIncludeOtherandTransfer + this.listdealfunding[df].Value;
                        }
                        sumdealfunding = sumdealfunding + this.listdealfunding[df].Value;
                        if (this.listdealfunding[df].PurposeText == "Capital Expenditure" || this.listdealfunding[df].PurposeText == "OpEx" || this.listdealfunding[df].PurposeText == "Force Funding" || this.listdealfunding[df].PurposeText == "Capitalized Interest" || this.listdealfunding[df].PurposeText == "TI/LC" || this.listdealfunding[df].PurposeText == "Additional Collateral Purchase") {
                            //total locked amount for autospreading funding
                            if (this.listdealfunding[df].Applied == true) {
                                TotalLockedAmount = TotalLockedAmount + this.listdealfunding[df].Value;
                            }
                            else if (this.listdealfunding[df].Comment != null && this.listdealfunding[df].Comment != "") {
                                TotalLockedAmount = TotalLockedAmount + this.listdealfunding[df].Value;
                            }
                            else if (this.listdealfunding[df].WF_IsFlowStart == 1) {
                                TotalLockedAmount = TotalLockedAmount + this.listdealfunding[df].Value;
                            }
                        }
                    }
                }
                //maxWiredConfirmDate
                if (this.listdealfunding[df].Applied == true) {
                    if (maxWiredConfirmDate == null || this.listdealfunding[df].Date > maxWiredConfirmDate) {
                        maxWiredConfirmDate = this.listdealfunding[df].Date;
                    }
                }
            }
            var items = this.listdealfunding;
            for (var item, i = 0; item = items[i++];) {
                var name = item.PurposeText;
                if (name) {
                    if (name != "Note Transfer" && item.Applied == true) {
                        if (!(name in lookup)) {
                            lookup[name] = 1;
                            result.push(name);
                        }
                    }
                }
            }
        }
        sumdealfundingwithnotetransfer = parseFloat((sumdealfundingwithnotetransfer).toFixed(2));
        sumdealfunding = parseFloat((sumdealfunding).toFixed(2));
        sumdealfundIncludeOtherandTransfer = parseFloat((sumdealfundIncludeOtherandTransfer).toFixed(2));
        TotalLockedAmount = parseFloat((TotalLockedAmount).toFixed(2));
        totalintitalfunding = parseFloat(this.lstSequenceHistory.reduce(function (r, a) { return a.InitialFundingAmount > 0.01 ? r + parseFloat(a.InitialFundingAmount) : r; }, 0).toFixed(2));
        if (this.lstNote[0] != null) {
            var maxInitialMaturityDate = new Date('1970-01-01Z00:00:00:000');
            var maxFullyExtendedMaturityDate = new Date('1970-01-01Z00:00:00:000');
            var maxExtendedMaturity = new Date('1970-01-01Z00:00:00:000');
            max_ExtensionMat = null;
            var maxActualPayoffDate = new Date('1970-01-01Z00:00:00:000');
            var usePayOffasmaturity = false;
            if (this.maturityList !== undefined) {
                if (this.maturityList.length > 0) {
                    var vlen = this.maturityList.filter(function (x) { return x.ActualPayoffDate == null; }).length;
                    if (vlen == 0) {
                        usePayOffasmaturity = true;
                    }
                }
            }
            if (this.isMaturityDataChanged == true) {
                //708	118	Initial
                //709	118	Extension
                //710	118	Fully extended
                //this.selectedGroupName
                if (this._lstChangedMaturityData !== undefined) {
                    if (this._lstChangedMaturityData.length > 0) {
                        for (var i = 0; i < this._lstChangedMaturityData.length; i++) {
                            if (this._lstChangedMaturityData[i].Approved == 3 && this._lstChangedMaturityData[i].IsDeleted == 0 && this._lstChangedMaturityData[i].GroupName == this.selectedGroupName) {
                                if (this._lstChangedMaturityData[i].MaturityType == 708) {
                                    if (new Date(this._lstChangedMaturityData[i].MaturityDate) > maxInitialMaturityDate) {
                                        maxInitialMaturityDate = this._lstChangedMaturityData[i].MaturityDate;
                                    }
                                }
                                if (this._lstChangedMaturityData[i].MaturityType == 710) {
                                    if (new Date(this._lstChangedMaturityData[i].MaturityDate) > maxFullyExtendedMaturityDate) {
                                        maxFullyExtendedMaturityDate = this._lstChangedMaturityData[i].MaturityDate;
                                    }
                                }
                                if (this._lstChangedMaturityData[i].MaturityTypeText == 709) {
                                    if (new Date(this._lstChangedMaturityData[i].MaturityDate) > maxExtendedMaturity) {
                                        maxExtendedMaturity = this._lstChangedMaturityData[i].MaturityDate;
                                    }
                                }
                            }
                        }
                    }
                }
                if (this.maturityList !== undefined) {
                    if (this.maturityList.length > 0) {
                        for (var i = 0; i < this.maturityList.length; i++) {
                            if (this.maturityList[i].ApprovedText == "Y" && this.maturityList[i].isDeleted == 0 && this.maturityList[i].MaturityGroupName != this.selectedGroupName) {
                                if (this.maturityList[i].MaturityTypeText == "Initial") {
                                    if (new Date(this.maturityList[i].MaturityDate) > maxInitialMaturityDate) {
                                        maxInitialMaturityDate = this.maturityList[i].MaturityDate;
                                    }
                                }
                                if (this.maturityList[i].MaturityTypeText == "Fully extended") {
                                    if (new Date(this.maturityList[i].MaturityDate) > maxFullyExtendedMaturityDate) {
                                        maxFullyExtendedMaturityDate = this.maturityList[i].MaturityDate;
                                    }
                                }
                                if (this.maturityList[i].MaturityTypeText == "Extension") {
                                    if (new Date(this.maturityList[i].MaturityDate) > maxExtendedMaturity) {
                                        maxExtendedMaturity = this.maturityList[i].MaturityDate;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else {
                if (this.maturityList !== undefined) {
                    if (this.maturityList.length > 0) {
                        for (var i = 0; i < this.maturityList.length; i++) {
                            if (this.maturityList[i].ApprovedText == "Y" && this.maturityList[i].isDeleted == 0) {
                                if (this.maturityList[i].MaturityTypeText == "Initial") {
                                    if (new Date(this.maturityList[i].MaturityDate) > maxInitialMaturityDate) {
                                        maxInitialMaturityDate = this.maturityList[i].MaturityDate;
                                    }
                                }
                                if (this.maturityList[i].MaturityTypeText == "Fully extended") {
                                    if (new Date(this.maturityList[i].MaturityDate) > maxFullyExtendedMaturityDate) {
                                        maxFullyExtendedMaturityDate = this.maturityList[i].MaturityDate;
                                    }
                                }
                                if (this.maturityList[i].MaturityTypeText == "Extension") {
                                    if (new Date(this.maturityList[i].MaturityDate) > maxExtendedMaturity) {
                                        maxExtendedMaturity = this.maturityList[i].MaturityDate;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if (maxInitialMaturityDate.getFullYear() < 2000) {
                maxInitialMaturityDate = new Date(Math.max.apply(null, this.lstNote.map(function (x) { return x.InitialMaturityDate; })));
                if (maxInitialMaturityDate.getFullYear() < 2000) {
                    maxInitialMaturityDate = null;
                }
            }
            if (maxFullyExtendedMaturityDate.getFullYear() < 2000) {
                maxFullyExtendedMaturityDate = new Date(Math.max.apply(null, this.lstNote.map(function (x) { return x.FullyExtendedMaturityDate; })));
                if (maxFullyExtendedMaturityDate.getFullYear() < 2000) {
                    maxFullyExtendedMaturityDate = null;
                }
            }
            if (maxExtendedMaturity.getFullYear() < 2000) {
                maxExtendedMaturity = new Date(Math.max.apply(null, this.lstNote.map(function (x) { return x.ExtendedMaturityCurrent; })));
                max_ExtensionMat = maxExtendedMaturity;
                if (maxExtendedMaturity.getFullYear() < 2000) {
                    maxExtendedMaturity = null;
                    max_ExtensionMat = this._deal.max_ExtensionMat;
                }
            }
            if (this.maturityActualPayoffDate != null) {
                maxActualPayoffDate = new Date(this.maturityActualPayoffDate);
            }
            if (maxActualPayoffDate != null || maxActualPayoffDate != undefined) {
                if (maxActualPayoffDate.getFullYear() < 2000) {
                    maxActualPayoffDate = null;
                }
            }
            if (maxExtendedMaturity != null || maxExtendedMaturity != undefined) {
                if (maxExtendedMaturity.getFullYear() < 2000) {
                    maxExtendedMaturity = null;
                }
            }
            var today = new Date();
            if (maxActualPayoffDate != null && usePayOffasmaturity == true) {
                maxmat = maxActualPayoffDate;
            }
            else if (max_ExtensionMat != null) {
                maxmat = max_ExtensionMat;
            }
            else {
                var nextInitialMaturityDate = this.getnextbusinessDate(new Date(JSON.parse(JSON.stringify(maxInitialMaturityDate))), -20, false);
                if (today >= nextInitialMaturityDate) {
                    var nextExtendedMaturityDate = this.getnextbusinessDate(new Date(JSON.parse(JSON.stringify(maxExtendedMaturity))), -20, false);
                    if (today >= nextExtendedMaturityDate) {
                        maxmat = maxFullyExtendedMaturityDate;
                    }
                    else {
                        maxmat = maxExtendedMaturity;
                    }
                }
                else {
                    //Use InitialMaturityDate if it is smaller than today date
                    maxmat = maxInitialMaturityDate;
                }
                maxmat = this.getPreviousWorkingDate(new Date(JSON.parse(JSON.stringify(maxmat))));
                for (var val = 0; val < this.lstNote.length; val++) {
                    var current = this.lstNote[val];
                    if (maxextendedmat == null || current.FullyExtendedMaturityDate > maxextendedmat) {
                        maxextendedmat = current.FullyExtendedMaturityDate;
                    }
                    if (this.minClosingDate === null || current.ClosingDate < this.minClosingDate) {
                        this.minClosingDate = current.ClosingDate;
                    }
                }
            }
        }
        //check validaion the holiday and sat sun date
        var lstTempDealFunding = this.listdealfunding.filter(function (x) { return x.Applied == false || x.Applied == undefined; });
        if (this.checked == false) {
            for (var i = 0; i < lstTempDealFunding.length; i++) {
                if (lstTempDealFunding[i].Date != null) {
                    var sdate = new Date(lstTempDealFunding[i].Date);
                    var formateddate = this.convertDateToBindable(lstTempDealFunding[i].Date);
                    var dealfundingday = sdate.getDay();
                    if (dealfundingday == 6 || dealfundingday == 0
                        || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411; }).length > 0) {
                        var dateexist = errordate.includes(this.convertDateToBindable(sdate));
                        if (!dateexist) {
                            errordate += this.convertDateToBindable(sdate) + ", ";
                            isvalidateHolidaySatSun = false;
                            //  lstTempDealFunding[i]["isValidDate"] = false;
                        }
                    }
                }
                if (lstTempDealFunding.PurposeText == "Debt Service / Opex" && lstTempDealFunding.Applied == false) {
                    // fundingerror = fundingerror + "<p>" + "Please choose 'Capitalized Interest' instead of 'Debt Service/Opex'." + "</p>";
                    errDebtServ = "Please choose 'Capitalized Interest' instead of 'Debt Service/Opex'";
                }
            }
        }
        var fundingerror = "";
        var netdealfunding = 0;
        var errornotes = "";
        var isDeptOpexExist = false;
        var purposetype = "";
        var isamountblank = false, isDateblank = false, ispurposeblank = false;
        var isDeptOpexExistAfterDate = false;
        var autopositiveamountstring = "";
        this._isfixedvaluechanged = false;
        var SumFundingSeq = 0;
        var SumRepaymentSeq = 0;
        if (this.lstSequenceHistory) {
            var tempseq;
            tempseq = 0;
            var temprepay;
            temprepay = 0;
            for (var j = 0; j < this.lstSequenceHistory.length; j++) {
                noteTotalAdditionalEquity = noteTotalAdditionalEquity + parseFloat(this.GetDefaultValue(parseFloat(this.lstSequenceHistory[j].InitialAdditionalEquity)));
                noteTotalRequiredEquity = noteTotalRequiredEquity + parseFloat(this.GetDefaultValue(parseFloat(this.lstSequenceHistory[j].InitialRequiredEquity)));
                if (this.lstSequenceHistory[j].UseRuletoDetermineNoteFundingText == "3" || this.lstSequenceHistory[j].UseRuletoDetermineNoteFundingText == "Y") {
                    tempseq = 0;
                    temprepay = 0;
                    var temparry = this.lstSequence.filter(function (x) { return x.NoteID == _this.lstSequenceHistory[j].NoteID; });
                    for (var val = 0; val < temparry.length; val++) {
                        if (temparry[val].SequenceTypeText === 'Funding Sequence') {
                            if (temparry[val].Value != null) {
                                tempseq = parseFloat(tempseq) + parseFloat(temparry[val].Value);
                            }
                        }
                        else if (temparry[val].SequenceTypeText === 'Repayment Sequence') {
                            if (temparry[val].Value != null) {
                                temprepay = parseFloat(temprepay) + parseFloat(temparry[val].Value);
                            }
                        }
                    }
                    SumFundingSeq = parseFloat((SumFundingSeq + tempseq).toFixed(2));
                    SumRepaymentSeq = parseFloat((SumRepaymentSeq + temprepay).toFixed(2));
                    if (this.lstSequence.length > 0) {
                        var totFundingseq;
                        totFundingseq = 0;
                        var totRepaymentseq;
                        totRepaymentseq = 0;
                        //Validation for funding sequence Value should be greater than note wired Values
                        var tempar = this.lstSequence.filter(function (x) { return x.NoteName == _this.lstSequenceHistory[j].NoteName; });
                        for (var val = 0; val < tempar.length; val++) {
                            if (tempar[val].SequenceTypeText === 'Funding Sequence') {
                                if (tempar[val].Value != null) {
                                    totFundingseq = parseFloat(totFundingseq.toString()) + parseFloat(tempar[val].Value);
                                }
                            }
                            else if (tempar[val].SequenceTypeText === 'Repayment Sequence') {
                                if (tempar[val].Value != null) {
                                    totRepaymentseq = parseFloat(totRepaymentseq.toString()) + parseFloat(tempar[val].Value);
                                }
                            }
                        }
                        var Appliedfunding = this.listdealfunding.filter(function (x) { return x.Applied == true; });
                        var notefunding = 0, noteRepayment = 0;
                        if (this.lstSequenceHistory[j].Name == tempar[0].NoteName) {
                            for (var m = 0; m < Appliedfunding.length; m++) {
                                if (Appliedfunding[m][this.lstSequenceHistory[j].NoteName] > 0) {
                                    notefunding += Appliedfunding[m][this.lstSequenceHistory[j].NoteName];
                                }
                            }
                            if (parseFloat(totFundingseq.toFixed(2)) < parseFloat(notefunding.toFixed(2))) {
                                fundingerror = fundingerror + "<p>" + "Sum of " + tempar[0].NoteName + " funding sequence amount (" + this.formatMoney(totFundingseq) + ") cannot be less than its wire confirmed funding amount (" + this.formatMoney(parseFloat(notefunding.toFixed(2))) + ")." + "</p>";
                            }
                        }
                        if (this.lstSequenceHistory[j].Name == tempar[0].NoteName) {
                            for (var m = 0; m < Appliedfunding.length; m++) {
                                if (Appliedfunding[m][this.lstSequenceHistory[j].NoteName] < 0) {
                                    noteRepayment += Math.abs(Appliedfunding[m][this.lstSequenceHistory[j].NoteName]);
                                }
                            }
                            if (parseFloat(totRepaymentseq.toFixed(2)) < parseFloat(noteRepayment.toFixed(2))) {
                                fundingerror = fundingerror + "<p>" + "Sum of " + tempar[0].NoteName + " repayment sequence amount (" + this.formatMoney(totRepaymentseq) + ") cannot be less than its wire confirmed repayment amount (" + this.formatMoney(parseFloat(noteRepayment.toFixed(2))) + ")." + "</p>";
                            }
                        }
                    }
                }
            }
        }
        var autoTotalAdditionalEquity = 0;
        var autoTotalRequiredEquity = 0;
        var autostring = "";
        var runothervalidation = false;
        if (this._deal.EnableAutoSpread == true) {
            if (this.lstAdjustedTotalCommitment) {
                for (var i = 0; i < this.lstAdjustedTotalCommitment.items.length; i++) {
                    TotalRequiredEquity = TotalRequiredEquity + parseFloat(this.GetDefaultValue(parseFloat(this.lstAdjustedTotalCommitment.items[i].TotalRequiredEquity)));
                    TotalAdditionalEquity = TotalAdditionalEquity + parseFloat(this.GetDefaultValue(parseFloat(this.lstAdjustedTotalCommitment.items[i].TotalAdditionalEquity)));
                }
            }
            for (var m = 0; m < this.lstautospreadrule.length; m++) {
                if (this.lstautospreadrule[m].PurposeTypeText == "" || this.lstautospreadrule[m].PurposeTypeText == null || this.lstautospreadrule[m].PurposeTypeText == undefined) {
                    autostring = autostring + "Purpose Type ,";
                    runothervalidation = false;
                    if (this.lstautospreadrule[m].DebtAmount == "" || this.lstautospreadrule[m].DebtAmount == null || this.lstautospreadrule[m].DebtAmount == undefined) {
                        if (this.lstautospreadrule[m].StartDate == "" || this.lstautospreadrule[m].StartDate == null || this.lstautospreadrule[m].StartDate == undefined) {
                            if (this.lstautospreadrule[m].EndDate == "" || this.lstautospreadrule[m].EndDate == null || this.lstautospreadrule[m].EndDate == undefined) {
                                runothervalidation = false;
                            }
                            else {
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
                }
                else {
                    runothervalidation = true;
                }
                //if (runothervalidation == false) {
                //    autostring = "";
                //}
                if (runothervalidation == true) {
                    autopositiveamountstring = "";
                    if (!(Number(this.lstautospreadrule[m].PurposeTypeText).toString() == "NaN" || Number(this.lstautospreadrule[m].PurposeTypeText) == 0)) {
                        this.lstautospreadrule[m].PurposeType = Number(this.lstautospreadrule[m].PurposeTypeText);
                        this.lstautospreadrule[m].PurposeTypeText = this.lstPurposeType.find(function (x) { return x.LookupID == _this.lstautospreadrule[m].PurposeType; }).Name;
                    }
                    else {
                        this.lstautospreadrule[m].PurposeType = Number(this.lstPurposeType.find(function (x) { return x.Name == _this.lstautospreadrule[m].PurposeTypeText; }).LookupID);
                    }
                    //to check only positive amount is allowed 
                    if (this.lstautospreadrule[m].PurposeTypeText == "Capital Expenditure" || this.lstautospreadrule[m].PurposeTypeText == "OpEx" || this.lstautospreadrule[m].PurposeTypeText == "Force Funding" || this.lstautospreadrule[m].PurposeTypeText == "Capitalized Interest" || this.lstautospreadrule[m].PurposeTypeText == "TI/LC" || this.lstautospreadrule[m].PurposeTypeText == "Additional Collateral Purchase") {
                        if (this.lstautospreadrule[m].DebtAmount !== null || this.lstautospreadrule[m].DebtAmount !== undefined) {
                            if (Math.sign(this.lstautospreadrule[m].DebtAmount) == -1) {
                                autopositiveamountstring = "Debt amount ,";
                            }
                        }
                        if (this.lstautospreadrule[m].RequiredEquity !== null || this.lstautospreadrule[m].RequiredEquity !== undefined) {
                            if (Math.sign(this.lstautospreadrule[m].RequiredEquity) == -1) {
                                autopositiveamountstring = autopositiveamountstring + "Required Equity ";
                            }
                        }
                        if (this.lstautospreadrule[m].AdditionalEquity !== null || this.lstautospreadrule[m].AdditionalEquity !== undefined) {
                            if (Math.sign(this.lstautospreadrule[m].AdditionalEquity) == -1) {
                                autopositiveamountstring = autopositiveamountstring + "Additional Equity ";
                            }
                        }
                    }
                    if (autopositiveamountstring != "") {
                        fundingerror = fundingerror + "<p>" + autopositiveamountstring.slice(0, -1) + " should be positive for transactions type Capital Expenditure, Capitalized Interest, OpEx, Force Funding, TI/LC, Additional Collateral Purchase." + "</p>";
                    }
                    if (this.lstautospreadrule[m].StartDate == "" || this.lstautospreadrule[m].StartDate == null || this.lstautospreadrule[m].StartDate == undefined) {
                        autostring = autostring + "Start Date ,";
                    }
                    if (this.lstautospreadrule[m].EndDate == "" || this.lstautospreadrule[m].EndDate == null || this.lstautospreadrule[m].EndDate == undefined) {
                        autostring = autostring + "End Date ,";
                    }
                    if (this.lstautospreadrule[m].EndDate != null) {
                        if (this.lstautospreadrule[m].StartDate > this.lstautospreadrule[m].EndDate) {
                            fundingerror = fundingerror + "<p>" + "Start Date should be less than or equal to End Date in Auto Spread." + "</p>";
                        }
                        if (this.lstautospreadrule[m].StartDate < this.minClosingDate) {
                            fundingerror = fundingerror + "<p>" + "Start Date " + this.convertDateToBindable(this.lstautospreadrule[m].StartDate) + " for Purpose Type " + this.lstautospreadrule[m].PurposeTypeText + " should be greater than or equal to Closing Date " + this.convertDateToBindable(this.minClosingDate) + " for Auto Spread." + "</p>";
                        }
                        if (this.lstautospreadrule[m].StartDate) {
                            if (maxmat != null && this.lstautospreadrule[m].StartDate > maxmat) {
                                fundingerror = fundingerror + "<p>" + "Start Date " + this.convertDateToBindable(this.lstautospreadrule[m].StartDate) + " for Purpose Type " + this.lstautospreadrule[m].PurposeTypeText + " should be less than or equal to maturity date " + this.convertDateToBindable(maxmat) + " for Auto Spread." + "</p>";
                            }
                        }
                        if (this.lstautospreadrule[m].EndDate < this.lstautospreadrule[m].StartDate) {
                            fundingerror = fundingerror + "<p>" + "End Date should be greater than or equal to Start Date for Auto Spread." + "</p>";
                        }
                        if (this.lstautospreadrule[m].EndDate) {
                            if (maxmat != null && new Date(this.lstautospreadrule[m].EndDate.toDateString()) > maxmat) {
                                fundingerror = fundingerror + "<p>" + "End Date " + this.convertDateToBindable(this.lstautospreadrule[m].EndDate) + " for Purpose type " + this.lstautospreadrule[m].PurposeTypeText + " should be less than or equal to current maturity date " + this.convertDateToBindable(maxmat) + " for Auto Spread." + "</p>";
                            }
                        }
                    }
                    if (this.lstautospreadrule[m].DistributionMethodText == "" || this.lstautospreadrule[m].DistributionMethodText == null || this.lstautospreadrule[m].DistributionMethodText == undefined) {
                        autostring = autostring + "Distribution Method ,";
                    }
                    if (this.lstautospreadrule[m].FrequencyFactor == "" || this.lstautospreadrule[m].FrequencyFactor == null || this.lstautospreadrule[m].FrequencyFactor == undefined) {
                        autostring = autostring + "Frequency Factor ,";
                    }
                    if (this.lstautospreadrule[m].FrequencyFactor < 1 || this.lstautospreadrule[m].FrequencyFactor > 12) {
                        fundingerror = fundingerror + "<p>" + "Frequency Factor should be between 1 to 12 in Auto Spread." + "</p>";
                    }
                }
                var dealamounttotal = 0;
                var autospreadamounttotal = 0;
                var autoequityamount = 0;
                var autoAdditionalEquity = 0;
                var autoRequiredEquity = 0;
                var currentpurposetype = '';
                var maxdatewithcomment = null;
                var tempdate = null;
                sumDealAdditionalEquity = 0;
                sumDealRequiredEquity = 0;
                TotalDebetAmount = TotalDebetAmount + this.lstautospreadrule[m].DebtAmount;
                autoTotalAdditionalEquity = autoTotalAdditionalEquity + parseFloat(this.GetDefaultValue(parseFloat(this.lstautospreadrule[m].AdditionalEquity)));
                autoTotalRequiredEquity = autoTotalRequiredEquity + parseFloat(this.GetDefaultValue(parseFloat(this.lstautospreadrule[m].RequiredEquity)));
                currentpurposetype = this.lstautospreadrule[m].PurposeTypeText;
                for (var n = 0; n < this.listdealfunding.length; n++) {
                    if (currentpurposetype == this.listdealfunding[n].PurposeText) {
                        var NewValue = 0;
                        var nonwireconfirmedvalue = 0;
                        if (this.listdealfunding[n].Applied == true || this.listdealfunding[n].Comment) {
                            NewValue = this.listdealfunding[n].Value;
                        }
                        else if (this.listdealfunding[n].WF_IsFlowStart == 1) {
                            NewValue = this.listdealfunding[n].Value;
                        }
                        dealamounttotal = NewValue + dealamounttotal;
                        if (this.listdealfunding[n].Applied == true) {
                            sumDealRequiredEquity = sumDealRequiredEquity + this.listdealfunding[n].RequiredEquity;
                            sumDealAdditionalEquity = sumDealAdditionalEquity + this.listdealfunding[n].AdditionalEquity;
                        }
                        else if (this.listdealfunding[n].Comment != null && this.listdealfunding[n].Comment != "") {
                            sumDealRequiredEquity = sumDealRequiredEquity + this.listdealfunding[n].RequiredEquity;
                            sumDealAdditionalEquity = sumDealAdditionalEquity + this.listdealfunding[n].AdditionalEquity;
                        }
                        else if (this.listdealfunding[n].WF_IsFlowStart == 1) {
                            sumDealRequiredEquity = sumDealRequiredEquity + this.listdealfunding[n].RequiredEquity;
                            sumDealAdditionalEquity = sumDealAdditionalEquity + this.listdealfunding[n].AdditionalEquity;
                        }
                    }
                }
                //end validation
                for (var l = 0; l < this.lstautospreadrule.length; l++) {
                    if (currentpurposetype == this.lstautospreadrule[l].PurposeTypeText) {
                        var NewAmount = this.lstautospreadrule[l].DebtAmount;
                        autospreadamounttotal = NewAmount + autospreadamounttotal;
                        autoequityamount = autoequityamount + this.lstautospreadrule[l].EquityAmount;
                        autoAdditionalEquity = autoAdditionalEquity + this.lstautospreadrule[l].AdditionalEquity;
                        autoRequiredEquity = autoRequiredEquity + this.lstautospreadrule[l].RequiredEquity;
                    }
                }
                if (Math.abs(parseFloat((sumDealAdditionalEquity).toFixed(2))) > Math.abs(parseFloat((autoAdditionalEquity).toFixed(2)))) {
                    fundingerror = fundingerror + "<p>" + "Sum of Additional Equity (" + this.formatMoney(autoAdditionalEquity) + ") for purpose type " + currentpurposetype + " can not be less than sum of Deal Additional Equity (" + this.formatMoney(sumDealAdditionalEquity) + ") for same purpose type." + "</p>";
                }
                if (Math.abs(parseFloat((sumDealRequiredEquity).toFixed(2))) > Math.abs(parseFloat((autoRequiredEquity).toFixed(2)))) {
                    fundingerror = fundingerror + "<p>" + "Sum of Required Equity (" + this.formatMoney(autoRequiredEquity) + ") for purpose type " + currentpurposetype + " can not be less than sum of Deal Required Equity (" + this.formatMoney(sumDealRequiredEquity) + ") for same purpose type." + "</p>";
                }
                if (Math.abs(parseFloat((dealamounttotal).toFixed(2))) > Math.abs(parseFloat((autospreadamounttotal).toFixed(2)))) {
                    fundingerror = fundingerror + "<p>" + "Sum of Debt Amount (" + this.formatMoney(autospreadamounttotal) + ") for purpose type " + currentpurposetype + " can not be less than sum of wire confirmed deal funding amount plus active draw amount and any locked draw amount (" + this.formatMoney(dealamounttotal) + ") for same purpose type." + "</p>";
                }
                if (autostring != "" || autopositiveamountstring != "") {
                    break;
                }
            }
            var k = 0;
            for (var l = 0; l < this.lstautospreadrule.length - 1; l++) {
                for (k = l + 1; k < this.lstautospreadrule.length; k++) {
                    if (this.lstautospreadrule[k].PurposeTypeText != "" || this.lstautospreadrule[k].PurposeTypeText != null || this.lstautospreadrule[k].PurposeTypeText != undefined) {
                        var purposetype = "";
                        if (!(Number(this.lstautospreadrule[k].PurposeTypeText).toString() == "NaN" || Number(this.lstautospreadrule[k].PurposeTypeText) == 0)) {
                            purposetype = this.lstPurposeType.find(function (x) { return x.LookupID == Number(_this.lstautospreadrule[k].PurposeTypeText); }).Name;
                            this.lstautospreadrule[k].PurposeTypeText = purposetype;
                        }
                        else {
                            this.lstautospreadrule[k].PurposeTypeText = this.lstautospreadrule[k].PurposeTypeText;
                        }
                    }
                    if (this.lstautospreadrule[l].PurposeTypeText == this.lstautospreadrule[k].PurposeTypeText) {
                        fundingerror = "<p>" + "Purpose Type should be unique in Auto Spread." + "</p>";
                        break;
                    }
                }
            }
            var totalamounttodistribute = 0;
            TotalDebetAmount = parseFloat((TotalDebetAmount).toFixed(2));
            var autospreadtotalfunding = parseFloat((TotalDebetAmount).toFixed(2)) + totalintitalfunding;
            if (parseFloat(autospreadtotalfunding.toFixed(2)) > parseFloat(parseFloat(this._totalcommitmenttextboxvalue).toFixed(2))) {
                fundingerror = fundingerror + "<p>" + "The sum of Deal Funding (" + this.formatMoney(TotalDebetAmount) + ") and Initial Funding (" + this.formatMoney(totalintitalfunding) + ") should be less than or equal to the Total Commitment(" + this.formatMoney(this._deal.TotalCommitment) + ").</p>";
            }
            var ProjectBudget = 0;
            var Amountrem = 0;
            if (TotalLockedAmount > TotalDebetAmount) {
                Amountrem = 0;
                fundingerror = fundingerror + "<p>" + "The total of locked amount (" + this.formatMoney(TotalLockedAmount) + ") in deal funding cannot be greater than total Debt Amount (" + this.formatMoney(TotalDebetAmount) + ")." + "</p>";
            }
            else {
                Amountrem = parseFloat((TotalDebetAmount - TotalLockedAmount).toFixed(2));
            }
            totalamounttodistribute = parseFloat((Amountrem + TotalLockedAmount).toFixed(2));
            ProjectBudget = totalamounttodistribute + sumdealfundIncludeOtherandTransfer;
            if (parseFloat((ProjectBudget).toFixed(2)) > parseFloat((SumFundingSeq).toFixed(2))) {
                fundingerror = fundingerror + "<p>" + "Total of debt amount (" + this.formatMoney(ProjectBudget) + ") including Note Transfer and Others funding should not be greater than Total of funding sequence amount (" + this.formatMoney(SumFundingSeq) + ")." + "</p>";
            }
            var autospreadstartdateerror = "";
            var autospreadEnddateerror = "";
            var errordates = "";
            for (var l = 0; l < this.lstautospreadrule.length; l++) {
                if (this.lstautospreadrule[l].StartDate) {
                    var sdate = new Date(this.lstautospreadrule[l].StartDate);
                    var formateddate = this.convertDateToBindable(this.lstautospreadrule[l].StartDate);
                    var autospreadstartday = sdate.getDay();
                    if (autospreadstartday == 6 || autospreadstartday == 0
                        || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411; }).length > 0) {
                        var dateexist = errordates.includes(this.convertDateToBindable(sdate));
                        if (!dateexist) {
                            var distinct = [];
                            var startdateerror = this.lstautospreadrule[l].StartDate;
                            if (!(startdateerror in distinct)) {
                                distinct.push(startdateerror);
                            }
                            if (distinct.length == 1) {
                                autospreadstartdateerror = this.convertDateToBindable(startdateerror) + ", ";
                            }
                            else {
                                autospreadstartdateerror += this.convertDateToBindable(this.lstautospreadrule[l].StartDate) + ", ";
                            }
                        }
                    }
                }
                if (this.lstautospreadrule[l].EndDate) {
                    var sdate = new Date(this.lstautospreadrule[l].EndDate);
                    var formateddate = this.convertDateToBindable(this.lstautospreadrule[l].EndDate);
                    var autospreadstartday = sdate.getDay();
                    if (autospreadstartday == 6 || autospreadstartday == 0
                        || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411; }).length > 0) {
                        var dateexist = errordates.includes(this.convertDateToBindable(sdate));
                        if (!dateexist) {
                            var distinct = [];
                            var enddateerror = this.lstautospreadrule[l].EndDate;
                            if (!(enddateerror in distinct)) {
                                distinct.push(enddateerror);
                            }
                            if (distinct.length == 1) {
                                autospreadEnddateerror = this.convertDateToBindable(enddateerror) + ", ";
                            }
                            else {
                                autospreadEnddateerror += this.convertDateToBindable(this.lstautospreadrule[l].EndDate) + ", ";
                            }
                        }
                    }
                }
            }
            if (autospreadstartdateerror != "") {
                fundingerror = fundingerror + "<p>" + "You have entered a start date (" + autospreadstartdateerror.slice(0, errordates.length - 2) + ") which is either on holiday or weekend. Please enter different start date." + "</p>";
            }
            if (autospreadEnddateerror != "") {
                fundingerror = fundingerror + "<p>" + "You have entered a end date (" + autospreadEnddateerror.slice(0, errordates.length - 2) + ") which is either on holiday or weekend. Please enter different end date." + "</p>";
            }
            var holidayvalidationauto = true;
            var holidayerrordateauto = '';
            for (var df = 0; df < this.listdealfunding.length; df++) {
                if (this.listdealfunding[df].Applied == false) {
                    if (this.listdealfunding[df].Comment != null && this.listdealfunding[df].Comment != "") {
                        var sdate = new Date(this.listdealfunding[df].Date);
                        var formateddate = this.convertDateToBindable(this.listdealfunding[df].Date);
                        var dealfundingday = sdate.getDay();
                        if (dealfundingday == 6 || dealfundingday == 0 || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411; }).length > 0) {
                            var dateexist = errordate.includes(this.convertDateToBindable(sdate));
                            if (!dateexist) {
                                holidayerrordateauto += this.convertDateToBindable(sdate) + ", ";
                                holidayvalidationauto = false;
                            }
                        }
                    }
                }
            }
            if (!holidayvalidationauto) {
                fundingerror = fundingerror + "<p>" + "You have entered a funding date (" + holidayerrordateauto.slice(0, holidayerrordateauto.length - 2) + ") which is either on holiday or weekend. Please enter different date." + "</p>";
            }
            if (result) {
                for (var re = 0; re < result.length; re++) {
                    var foundornot = "";
                    if (result[re]) {
                        if (result[re] != null && result[re] != "") {
                            if (!(result[re] === "Amortization" || result[re] === "Property Release" || result[re] === "Full Payoff" || result[re] === "Paydown" || result[re] === "Other")) {
                                var objauto = this.lstautospreadrule.filter(function (x) { return x.PurposeTypeText == result[re]; });
                                if (objauto.length > 0) {
                                    if (objauto) {
                                        if (objauto[0].PurposeTypeText == "") {
                                            foundornot = "notfound";
                                        }
                                    }
                                }
                                else {
                                    foundornot = "notfound";
                                }
                                if (foundornot == "notfound") {
                                    purposetype = purposetype + result[re] + ", ";
                                }
                            }
                        }
                    }
                }
            }
            if (purposetype != "") {
                fundingerror = fundingerror + "<p>" + "The purpose type(s) (" + purposetype.slice(0, purposetype.length - 2) + ") in deal funding grid does not exist in auto spread grid." + "</p>";
            }
            if ((parseFloat(autoTotalAdditionalEquity.toFixed(2)) + parseFloat(noteTotalAdditionalEquity.toFixed(2))) > parseFloat(TotalAdditionalEquity.toFixed(2))) {
                fundingerror = fundingerror + "<p>" + "Sum of the Initial Additional Equity and Future Additional Equity (in project budget) should be less than or equal to Total Additional Equity in commitment grid.";
            }
            if ((parseFloat(autoTotalRequiredEquity.toFixed(2)) + parseFloat(noteTotalRequiredEquity.toFixed(2))) > parseFloat(TotalRequiredEquity.toFixed(2))) {
                fundingerror = fundingerror + "<p>" + "Sum of the Initial Required Equity and Future Required Equity (in project budget) should be less than or equal to Total Required Equity in commitment grid.";
            }
            //debt  TotalDebetAmount = 0;
        }
        // end of auto spread validation 
        if (autostring != "") {
            fundingerror = fundingerror + "<p>" + autostring.slice(0, -1) + "are required field(s) in Auto Spreading." + "</p>";
        }
        if (this.listdealfunding.length > 0) {
            var sumdealrepayment = 0;
            //if (this._deal.EnableAutospreadRepayments != true) {
            //    sumdealrepayment = parseFloat(this.listdealfunding.reduce(function (r, a) { return a.Value < 0 ? r + parseFloat(a.Value) : r; }, 0).toFixed(2));
            //}
            if (this._deal.AggregatedTotal == null) {
                this._deal.AggregatedTotal = 0;
            }
            netdealfunding = parseFloat(this.listdealfunding.reduce(function (r, a) { return a.Value ? r + parseFloat(a.Value) : r; }, 0).toFixed(2));
            if (this.checked != true) {
                var sumtotalfunding = sumdealfundingwithnotetransfer + totalintitalfunding;
                if (parseFloat(sumtotalfunding.toFixed(2)) > parseFloat(parseFloat(this._totalcommitmenttextboxvalue).toFixed(2))) {
                    fundingerror = fundingerror + "<p>" + "The sum of Deal Funding (" + this.formatMoney(sumdealfundingwithnotetransfer) + ") and Initial Funding (" + this.formatMoney(totalintitalfunding) + ") should be less than or equal to the Total Commitment.(" + this.formatMoney(this._deal.TotalCommitment) + ")</p>";
                }
            }
            this.listdealfunding.sort(this.SortByDate);
            //  if (this._deal.EnableAutospreadRepayments == true)
            {
                for (var d = 0; d < this.listdealfunding.length; d++) {
                    if (this.listdealfunding[d].Value < 0) {
                        if (this.listdealfunding[d].PurposeText == "Paydown") {
                            if (this.listdealfunding[d].Applied == true) {
                                sumdealrepayment = sumdealrepayment + this.listdealfunding[d].Value;
                            }
                            else if (this.listdealfunding[d].Comment != null && this.listdealfunding[d].Comment != "") {
                                sumdealrepayment = sumdealrepayment + this.listdealfunding[d].Value;
                            }
                            else if (this.listdealfunding[d].WF_IsFlowStart == 1) {
                                sumdealrepayment = sumdealrepayment + this.listdealfunding[d].Value;
                            }
                        }
                        else {
                            sumdealrepayment = sumdealrepayment + this.listdealfunding[d].Value;
                        }
                    }
                }
            }
            for (var d = 0; d < this.listdealfunding.length; d++) {
                this.listdealfunding[d]["DealFundingRowno"] = d + 1;
                if (this.listdealfunding[d].PurposeID || this.listdealfunding[d].Value || this.listdealfunding[d].Date) {
                    if (!this.listdealfunding[d].PurposeID) {
                        ispurposeblank = true;
                    }
                    if (!this.listdealfunding[d].Date) {
                        isDateblank = true;
                    }
                }
                if (this.listdealfunding[d].PurposeText == "" && this.listdealfunding[d].Applied == false) {
                    ispurposeblank = true;
                }
                if (this.listdealfunding[d].PurposeText == "Debt Service / Opex" && this.listdealfunding[d].Applied == false) {
                    isDeptOpexExist = true;
                }
                if (this.listdealfunding[d].PurposeText == "Debt Service / Opex" && this.listdealfunding[d].Applied == true && new Date(this.listdealfunding[d].Date) > new Date('6/1/2019')) {
                    isDeptOpexExistAfterDate = true;
                }
                //positive amount
                if (this.listdealfunding[d].PurposeText == "Capital Expenditure" || this.listdealfunding[d].PurposeText == "OpEx" || this.listdealfunding[d].PurposeText == "Force Funding" || this.listdealfunding[d].PurposeText == "Capitalized Interest" || this.listdealfunding[d].PurposeText == "TI/LC" || this.listdealfunding[d].PurposeText == "Additional Collateral Purchase") {
                    if (maxmat) {
                        if (Date.parse(maxmat) != 0) {
                            if (this.listdealfunding[d].Date > maxmat) {
                                if (this.listdealfunding[d].Applied != true) {
                                    if (this.listdealfunding[d].Comment != null || this.listdealfunding[d].Comment != "") {
                                        fundingerror = fundingerror + "<p>" + "Any date(s) after the Maturity date <b>(" + this.convertDateToBindable(maxmat) + ") </b> in Deal Funding Schedule is not allowed." + "</p>";
                                        break;
                                    }
                                    else {
                                        if (this._deal.EnableAutoSpread != true) {
                                            fundingerror = fundingerror + "<p>" + "Any date(s) after the Maturity date <b>(" + this.convertDateToBindable(maxmat) + ") </b> in Deal Funding Schedule is not allowed." + "</p>";
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if (this.listdealfunding[d].Value !== null || this.listdealfunding[d].Value !== undefined) {
                        //check if value is null
                        if (Math.sign(this.listdealfunding[d].Value) == -1) {
                            fundingerror = fundingerror + "<p>" + "Transaction amount should be positive for transactions type Capital Expenditure, Capitalized Interest, OpEx, Force Funding, TI/LC, Additional Collateral Purchase." + "</p>";
                            break;
                        }
                    }
                }
                if (this.listdealfunding[d].PurposeText == "Amortization" || this.listdealfunding[d].PurposeText == "Property Release" || this.listdealfunding[d].PurposeText == "Full Payoff" || this.listdealfunding[d].PurposeText == "Paydown") {
                    if (this.listdealfunding[d].Value !== null || this.listdealfunding[d].Value !== undefined) {
                        //check if value is null
                        if (Math.sign(this.listdealfunding[d].Value) == 1) {
                            fundingerror = fundingerror + "<p>" + "Transaction amount should be negative for transactions type Amortization, Full Payoff, Paydown and Property Release." + "</p>";
                            break;
                        }
                    }
                }
                //if (this.checked == false) {
                //negative amount
                var currentpurpose = this.listdealfunding[d].PurposeText;
                if (this.listdealfunding[d].PurposeText == "Amortization" || this.listdealfunding[d].PurposeText == "Property Release" || this.listdealfunding[d].PurposeText == "Full Payoff" || this.listdealfunding[d].PurposeText == "Paydown") {
                    if (maxFullyExtendedMaturityDate != null) {
                        if (this.listdealfunding[d].Date > maxFullyExtendedMaturityDate) {
                            var showvalidation = false;
                            if (currentpurpose != "Paydown") {
                                showvalidation = true;
                            }
                            else {
                                if (this.listdealfunding[d].Comment != null || this.listdealfunding[d].Comment != "") {
                                    showvalidation = true;
                                }
                                else if (this.checked == false) {
                                    showvalidation = true;
                                }
                            }
                            if (showvalidation == true) {
                                fundingerror = fundingerror + "<p>" + "Any date(s) after the fully extended maturity date <b>(" + this.convertDateToBindable(maxFullyExtendedMaturityDate) + ") </b> in Deal Repayment Schedule is not allowed." + "</p>";
                                break;
                            }
                        }
                    }
                }
                //other
                if (this.listdealfunding[d].PurposeText == "Other" || this.listdealfunding[d].PurposeText == "Note Transfer") {
                    if (this.listdealfunding[d].Value !== null || this.listdealfunding[d].Value !== undefined) {
                        if (Math.sign(this.listdealfunding[d].Value) == -1) {
                            if (maxextendedmat == null) {
                                maxextendedmat = maxmat;
                            }
                            if (Date.parse(maxextendedmat) != 0 && maxextendedmat != null) {
                                if (this.listdealfunding[d].Date > maxextendedmat) {
                                    fundingerror = fundingerror + "<p>" + "Any date(s) after the fully extended maturity date <b>(" + this.convertDateToBindable(maxextendedmat) + ") </b> in Deal Schedule is not allowed." + "</p>";
                                    break;
                                }
                            }
                        }
                        else {
                            if (maxmat) {
                                if (Date.parse(maxmat) != 0) {
                                    if (this.listdealfunding[d].Date > maxmat) {
                                        fundingerror = fundingerror + "<p>" + "Any date(s) after the Maturity date <b>(" + this.convertDateToBindable(maxmat) + ") </b> in Deal Schedule is not allowed." + "</p>";
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
                //}
                if (!(Number(this.listdealfunding[d].PurposeText).toString() == "NaN" || Number(this.listdealfunding[d].PurposeText) == 0)) {
                    this.listdealfunding[d].PurposeID = Number(this.listdealfunding[d].PurposeText);
                }
            }
            sumdealrepayment = parseFloat((sumdealrepayment).toFixed(2));
            if (isDeptOpexExist) {
                fundingerror = fundingerror + "<p>" + "Please choose 'Capitalized Interest' instead of 'Debt Service/Opex'." + "</p>";
            }
            if (isDeptOpexExistAfterDate) {
                fundingerror = fundingerror + "<p>" + "Debt Service/Opex is not allowed after 6/1/2019. Please choose 'Capitalized Interest' instead of 'Debt Service/Opex'." + "</p>";
            }
            //if (isamountblank) {
            //    fundingerror = fundingerror + "<p>" + "Amount can not be blank. Please enter funding amount." + "</p>";
            //}
            if (ispurposeblank) {
                fundingerror = fundingerror + "<p>" + "Please choose purpose type of funding." + "</p>";
            }
            if (isDateblank) {
                fundingerror = fundingerror + "<p>" + "Please enter funding Date." + "</p>";
            }
            if (this.checked == false) {
                if (SumFundingSeq < sumdealfunding) {
                    fundingerror = fundingerror + "<p>" + "Total funding in Deal Schedule (" + this.formatMoney(sumdealfunding) + ") cannot be  greater than total of Funding Sequences (" + this.formatMoney(SumFundingSeq) + ") included in funding rules." + "</p>";
                }
            }
            if (!(sumdealrepayment * -1 <= SumRepaymentSeq)) {
                fundingerror = fundingerror + "<p>" + "Total repayments in Deal Schedule (" + this.formatMoney(sumdealrepayment) + ") cannot be  greater than total of Repayment Sequences (" + "-" + this.formatMoney(SumRepaymentSeq) + ") included in funding rules.";
            }
            if (this.lstNote[0] != null) {
                for (var val = 0; val < this.lstNote.length; val++) {
                    var temparry = this.lstSequence.filter(function (x) { return x.NoteID == _this.lstNote[val].NoteId; });
                    var tempseq1 = temparry.reduce(function (r, a) { return a.SequenceTypeText === 'Funding Sequence' ? r + a.Value : r; }, 0);
                    if (parseFloat((tempseq1).toFixed(2)) > this.lstNote[val].TotalCommitment) {
                        errornotes = errornotes + this.lstNote[val].CRENoteID + " ,";
                    }
                }
            }
            if (errornotes != "") {
                errornotes = errornotes.substring(0, errornotes.length - 1);
            }
            if (!isvalidateHolidaySatSun) {
                fundingerror = fundingerror + "<p>" + "You have entered a funding date (" + errordate.slice(0, errordate.length - 2) + ") which is either on holiday or weekend. Please enter different date." + "</p>";
            }
            if (errDebtServ != "") {
                fundingerror = fundingerror + "<p>" + "Please choose 'Capitalized Interest' instead of 'Debt Service/Opex'." + "</p>";
            }
            //start-validation for work flow
            //if purpose changed for the status above projected
            var isStatusChanged = false;
            for (var df = 0; df < this.listdealfundingwithoutchange.length; df++) {
                var objdealfunding = this.listdealfunding.filter(function (x) { return x.DealFundingID == _this.listdealfundingwithoutchange[df].DealFundingID; });
                if (objdealfunding.length > 0) {
                    if (objdealfunding[0].WF_CurrentStatus != "Projected" && objdealfunding[0].WF_CurrentStatus != '' && objdealfunding[0].WF_CurrentStatus != null) {
                        if (Number(objdealfunding[0].PurposeText).toString() == "NaN") {
                            if (objdealfunding[0].PurposeText != this.listdealfundingwithoutchange[df].PurposeText) {
                                isStatusChanged = true;
                                break;
                            }
                        }
                        else {
                            if (objdealfunding[0].PurposeText != this.listdealfundingwithoutchange[df].PurposeID) {
                                isStatusChanged = true;
                                break;
                            }
                        }
                    }
                }
            }
            if (isStatusChanged) {
                fundingerror = fundingerror + "<p>" + " You can not change the deal funding purpose for the status above Projected.";
            }
            //end-validation for work flow
            if (this._deal.EnableAutoSpread == true) {
                if (this.lstautospreadrule) {
                    if (this.lstautospreadrule.length == 0) {
                        fundingerror = fundingerror + "<p>" + "This deal is set to use auto spreading feature. Please enter auto spread data or uncheck Enable Auto Spread option";
                    }
                }
                else {
                    fundingerror = fundingerror + "<p>" + "This deal is set to use auto spreading feature. Please enter auto spread data or uncheck Enable Auto Spread option";
                }
            }
            var noteswithissue = "";
            if (fundingerror != "") {
                ///Total Funding sequence + Initial Funding - Pre pay or scheduled amount + negative transfers - ballon = Adjusted Commitment                
                if (this.lstSequenceHistory) {
                    var today = new Date();
                    for (var j = 0; j < this.lstSequenceHistory.length; j++) {
                        var totRepayment;
                        var ScheduledPrincipalPaid;
                        var balloon;
                        var sumNotefunding;
                        totRepayment = 0;
                        balloon = 0;
                        sumNotefunding = 0;
                        ScheduledPrincipalPaid = 0;
                        var currentnoteid = this.lstSequenceHistory[j].NoteID;
                        var InitialFundingAmount = this.lstSequenceHistory[j].InitialFundingAmount;
                        balloon = this.lstSequenceHistory[j].BalloonPayment * -1;
                        if (this.lstScheduledPrincipalPaid) {
                            if (this.lstScheduledPrincipalPaid.length > 0) {
                                var lstScheduledPrip = this.lstScheduledPrincipalPaid.filter(function (x) { return x.NoteID == currentnoteid; });
                                if (lstScheduledPrip.length > 0) {
                                    var temp = lstScheduledPrip[0].Amount;
                                    if (temp != null && temp != undefined) {
                                        ScheduledPrincipalPaid = parseFloat((temp * -1).toFixed(2));
                                    }
                                }
                            }
                        }
                        var noteFundingArray = this.lstNoteFunding.filter(function (x) { return x.NoteID == currentnoteid; });
                        for (var m = 0; m < noteFundingArray.length; m++) {
                            if (noteFundingArray[m].Value) {
                                if (noteFundingArray[m].Value < 0) {
                                    if (new Date(noteFundingArray[m].Date) <= today) {
                                        totRepayment = totRepayment + parseFloat(this.GetDefaultValue(parseFloat(noteFundingArray[m].Value).toFixed(2)));
                                    }
                                }
                                else {
                                    if (noteFundingArray[m].Purpose != "Note Transfer") {
                                        if (noteFundingArray[m].Value !== null) {
                                            sumNotefunding = sumNotefunding + parseFloat(this.GetDefaultValue(parseFloat(noteFundingArray[m].Value).toFixed(2)));
                                        }
                                    }
                                }
                            }
                        }
                        sumNotefunding = parseFloat(sumNotefunding.toFixed(2));
                        totRepayment = parseFloat(totRepayment.toFixed(2));
                        if (parseFloat(InitialFundingAmount) == 0.01) {
                            InitialFundingAmount = 0;
                        }
                        //for loop end
                        //AdjustedTotalCommitment
                        var subtotal = sumNotefunding + parseFloat(InitialFundingAmount) + totRepayment + parseFloat(balloon) + parseFloat(ScheduledPrincipalPaid);
                        if (parseFloat(subtotal.toFixed(2)) > parseFloat(this.lstSequenceHistory[j].AdjustedTotalCommitment.toFixed(2))) {
                            var diffval = parseFloat(subtotal.toFixed(2)) - parseFloat(this.lstSequenceHistory[j].AdjustedTotalCommitment.toFixed(2));
                            if (Math.abs(parseFloat(diffval.toFixed(2))) > 0) {
                                noteswithissue = noteswithissue + this.lstSequenceHistory[j].CRENoteID + ", ";
                            }
                        }
                    }
                }
            }
            if (noteswithissue != "") {
                noteswithissue = noteswithissue.substring(0, noteswithissue.length - 1);
                fundingerror = fundingerror + "<p> Sum of Future Funding and Current Balance should be less than or equal to Adjusted Commitment for Note(s) " + noteswithissue.slice(0, -1) + "</p>";
            }
            if (this._deal.EnableAutospreadRepayments == true) {
                // check auto spread repayment duplicat dates
                if (this.flexautospreadrepayments) {
                    if (this.flexautospreadrepayments.rows.length > 0) {
                        var founddates = '';
                        var datelist = [];
                        var data = this.flexautospreadrepayments.rows;
                        for (var j = 0; j < data.length - 1; j++) {
                            datelist.push({ "ProjectedPayoffAsofDate": data[j].dataItem.ProjectedPayoffAsofDate });
                        }
                        var distinct = [];
                        for (var k = 0; k < datelist.length; k++) {
                            var datetocheck = datelist[k].ProjectedPayoffAsofDate;
                            if (datetocheck) {
                                var formateddate = this.convertDateToBindable(datetocheck);
                                for (var j = k + 1; j < datelist.length; j++) {
                                    var chkdate = this.convertDateToBindable(datelist[j].ProjectedPayoffAsofDate);
                                    if (chkdate == formateddate) {
                                        if (!(datetocheck in distinct)) {
                                            distinct.push(datetocheck);
                                        }
                                    }
                                }
                            }
                        }
                        if (distinct.length > 0) {
                            var dates = distinct.filter(function (date, i, self) {
                                return self.findIndex(function (d) { return d.getTime() === date.getTime(); }) === i;
                            });
                            if (dates.length) {
                                for (var m = 0; m < dates.length; m++) {
                                    founddates += this.convertDateToBindable(dates[m]) + ", ";
                                }
                            }
                        }
                        if (founddates != "") {
                            founddates = founddates.substring(0, founddates.length - 1);
                            fundingerror = fundingerror + "<p> Autospread repayment date(s) found duplicates " + founddates.slice(0, -1) + "</p>";
                        }
                    }
                }
                //duplicat dates ends
                if (this._deal.ExpectedFullRepaymentDate != null && this._deal.ExpectedFullRepaymentDate !== undefined) {
                    if (new Date(this._deal.ExpectedFullRepaymentDate).getFullYear() < 2000) {
                        this._deal.ExpectedFullRepaymentDate = null;
                    }
                }
                if (this._deal.AutoUpdateFromUnderwriting != true) { //only called when  Autospread Repayments are editable 
                    if (this._deal.ExpectedFullRepaymentDate != null) {
                        if (new Date(this._deal.ExpectedFullRepaymentDate) > new Date(maxFullyExtendedMaturityDate)) {
                            fundingerror = fundingerror + "<p>" + "Expected full repayment date cannot be greater than fully extended maturity date." + "</p>";
                        }
                    }
                }
                if (this._deal.EnableAutospreadRepayments == true && this._deal.ExpectedFullRepaymentDate == null) {
                    if (this._deal.RepaymentAutoSpreadMethodID == null || this._deal.RepaymentAutoSpreadMethodID == undefined) {
                        fundingerror = fundingerror + "<p>" + "Please select autospreading repayment method." + "</p>";
                    }
                    if (this._deal.Repaymentallocationfrequency != null) {
                        if (this._deal.Repaymentallocationfrequency < 1 || this._deal.Repaymentallocationfrequency > 12) {
                            fundingerror = fundingerror + "<p>" + "Repayment allocation frequency should be between 1 and 12." + "</p>";
                        }
                    }
                    if (this._deal.Blockoutperiod != null) {
                        if (this._deal.Blockoutperiod < 0 || this._deal.Blockoutperiod > 12) {
                            fundingerror = fundingerror + "<p>" + "Blockout period should be between 0 and 12." + "</p>";
                        }
                    }
                    if (this._deal.PossibleRepaymentdayofthemonth != null) {
                        if (this._deal.PossibleRepaymentdayofthemonth < 1 || this._deal.PossibleRepaymentdayofthemonth > 31) {
                            fundingerror = fundingerror + "<p>" + "Possible repayment day of the month should be between 1 and 31." + " </p>";
                        }
                    }
                }
                //validation to check user entered comment or not for paydowns when entered by them
                //var addvalidation = "";
                //for (var d = 0; d < this.listdealfunding.length; d++) {
                //    if (this.listdealfunding[d].PurposeText == "Paydown" || this.listdealfunding[d].PurposeText == "631") {
                //        if (this.listdealfunding[d].GeneratedByText == 'User Entered') {
                //            if (this.listdealfunding[d].Comment == "" || this.listdealfunding[d].Comment == null) {
                //                addvalidation = "User Entered paydown without comment";
                //            }
                //        }
                //    }
                //}
            }
            //if (this._deal.EnableAutospreadRepayments == true) {
            //    fundingerror = fundingerror + "<p>" + "Please enable repayment auto spreading to apply note level paydowns or uncheck apply note level paydowns." + " </p>";
            //}
            if (fundingerror == "") {
                this.convertDatetoGMTGrid(this.listdealfunding, 'DealFunding');
                if (this._deal.EnableAutoSpread == true) {
                    this.convertDatetoGMTGrid(this.lstautospreadrule, "Auto Spread");
                }
                this._isListFetching = true;
                this.AssginValuesToDealDataContract();
                this.UpdateNoteDropDowns();
                this.lstNoteFunding = [];
                this.Dealfuturefunding.maxMaturityDate = this.convertDatetoGMT(maxFullyExtendedMaturityDate);
                this.Dealfuturefunding.EnableAutoSpread = this._deal.EnableAutoSpread;
                this.Dealfuturefunding.ServicerDropDate = this._deal.ServicerDropDate;
                this.Dealfuturefunding.FirstPaymentDate = this._deal.FirstPaymentDate;
                this.Dealfuturefunding.ServicereDayAjustement = this._deal.ServicereDayAjustement;
                this.Dealfuturefunding.ListHoliday = this.ListHoliday;
                this.Dealfuturefunding.EnableAutospreadUseRuleN = false;
                this.Dealfuturefunding.LastWireConfirmDate_db = this._deal.LastWireConfirmDate_db;
                //   this.Dealfuturefunding.amort = this._deal.amort();
                this.CallPayRuleFutureFunding(this.Dealfuturefunding);
                this._isListFetching = false;
            }
            else {
                this.CustomAlert(fundingerror);
                this._isShowSaveDeal = this._isShowSaveDealAllowForThisRole == true ? true : false;
                this.ShowUseRuleN = false;
            }
        }
        else {
            var generatesave = false;
            if (this._deal.EnableAutoSpread == true) {
                generatesave = true;
            }
            if (this._deal.EnableAutospreadRepayments == true) {
                generatesave = true;
            }
            this._isdealfundingChanged = true;
            if (this._deal.EnableAutoSpread != true && this._deal.EnableAutospreadRepayments != true) {
                fundingerror = "<p>" + "Please enter Deal Funding Schedule before generating funding." + " </p>";
                this.CustomAlert(fundingerror);
                this._isShowSaveDeal = this._isShowSaveDealAllowForThisRole == true ? true : false;
                this.ShowUseRuleN = false;
            }
            //call payrule genration when EnableAutoSpread is true
            if (fundingerror == "" && generatesave == true) {
                this._isListFetching = true;
                this.convertDatetoGMTGrid(this.listdealfunding, 'DealFunding');
                this.convertDatetoGMTGrid(this.lstautospreadrule, "Auto Spread");
                this.AssginValuesToDealDataContract();
                this.UpdateNoteDropDowns();
                this.lstNoteFunding = [];
                this.Dealfuturefunding.maxMaturityDate = this.convertDatetoGMT(maxFullyExtendedMaturityDate);
                this.Dealfuturefunding.EnableAutoSpread = this._deal.EnableAutoSpread;
                this.Dealfuturefunding.ServicerDropDate = this._deal.ServicerDropDate;
                this.Dealfuturefunding.ServicereDayAjustement = this._deal.ServicereDayAjustement;
                this.Dealfuturefunding.ListHoliday = this.ListHoliday;
                this.Dealfuturefunding.EnableAutospreadUseRuleN = false;
                this.Dealfuturefunding.LastWireConfirmDate_db = this._deal.LastWireConfirmDate_db;
                this.CallPayRuleFutureFunding(this.Dealfuturefunding);
                this._isListFetching = false;
            }
            else if (fundingerror != "") {
                this.CustomAlert(fundingerror);
                this._isShowSaveDeal = this._isShowSaveDealAllowForThisRole == true ? true : false;
                this.ShowUseRuleN = false;
            }
        }
    };
    DealDetailComponent.prototype.AssginValuesToDealDataContract = function () {
        var _this = this;
        try {
            var temparray = [];
            this.Dealfuturefunding.PayruleDealFundingList = [];
            this.Dealfuturefunding.PayruleNoteAMSequenceList = [];
            this.Dealfuturefunding.PayruleTargetNoteFundingScheduleList = [];
            this.Dealfuturefunding.PayruleNoteDetailFundingList = [];
            this.Dealfuturefunding.AutoSpreadRuleList = [];
            // this.Dealfuturefunding.Amort.DealAmortizationList = [];
            for (var df = 0; df < this.listdealfunding.length; df++) {
                if (!(Number(this.listdealfunding[df].PurposeText).toString() == "NaN" || Number(this.listdealfunding[df].PurposeText) == 0)) {
                    this.listdealfunding[df].PurposeID = Number(this.listdealfunding[df].PurposeText);
                    this.listdealfunding[df].PurposeText = this.lstPurposeType.find(function (x) { return x.LookupID == _this.listdealfunding[df].PurposeID; }).Name;
                }
            }
            this.Dealfuturefunding.ApplyNoteLevelPaydowns = this._deal.ApplyNoteLevelPaydowns;
            if (this.repaymentchecked == true) {
                this.Dealfuturefunding.EnableAutospreadRepayments = true;
                if (!(Number(this._deal.RepaymentAutoSpreadMethodText).toString() == "NaN" || Number(this._deal.RepaymentAutoSpreadMethodText) == 0)) {
                    this._deal.RepaymentAutoSpreadMethodID = Number(this._deal.RepaymentAutoSpreadMethodText);
                    this._deal.RepaymentAutoSpreadMethodText = this.lstAutospreadRepaymentMethodID.find(function (x) { return x.LookupID == _this._deal.RepaymentAutoSpreadMethodID; }).Name;
                }
                else {
                    if (Number(this._deal.RepaymentAutoSpreadMethodID) != 0) {
                        this._deal.RepaymentAutoSpreadMethodID = Number(this._deal.RepaymentAutoSpreadMethodID);
                        this._deal.RepaymentAutoSpreadMethodText = this.lstAutospreadRepaymentMethodID.find(function (x) { return x.LookupID == _this._deal.RepaymentAutoSpreadMethodID; }).Name;
                    }
                }
                this.Dealfuturefunding.RepaymentAutoSpreadMethodText = this._deal.RepaymentAutoSpreadMethodText;
                this.Dealfuturefunding.Blockoutperiod = this._deal.Blockoutperiod;
                this.Dealfuturefunding.PossibleRepaymentdayofthemonth = this._deal.PossibleRepaymentdayofthemonth;
                this.Dealfuturefunding.Repaymentallocationfrequency = this._deal.Repaymentallocationfrequency;
                this.Dealfuturefunding.LatestPossibleRepaymentDate = this.convertDatetoGMT(this.LatestPossibleRepaymentDateBS);
                this.Dealfuturefunding.ExpectedFullRepaymentDate = this.convertDatetoGMT(this.ExpectedDateBS);
                this.Dealfuturefunding.RepaymentStartDate = this.convertDatetoGMT(this._deal.RepaymentStartDate);
                this.Dealfuturefunding.AutoPrepayEffectiveDate = this.convertDatetoGMT(this.EffectiveDateBS);
                this.Dealfuturefunding.EarliestPossibleRepaymentDate = this.convertDatetoGMT(this.EarliestPossibleRepaymentDateBS);
                this.Dealfuturefunding.ListNoteRepaymentBalances = this._deal.ListNoteRepaymentBalances;
                if (this.flexautospreadrepayments) {
                    this._deal.ListProjectedPayoff = [];
                    for (var k = 0; k < this.flexautospreadrepayments.rows.length - 1; k++) {
                        if (this.flexautospreadrepayments.rows[k].dataItem.ProjectedPayoffAsofDate != null) {
                            var date = this.convertDatetoGMT(this.flexautospreadrepayments.rows[k].dataItem.ProjectedPayoffAsofDate);
                            this._deal.ListProjectedPayoff.push({ "DealID": this._deal.DealID, "ProjectedPayoffAsofDate": date, "CumulativeProbability": this.flexautospreadrepayments.rows[k].dataItem.CumulativeProbability });
                        }
                    }
                }
                this.Dealfuturefunding.ListAutoRepaymentBalances = this._deal.ListAutoRepaymentBalances;
                this.Dealfuturefunding.ListProjectedPayoff = this._deal.ListProjectedPayoff;
            }
            else {
                this.Dealfuturefunding.EnableAutospreadRepayments = false;
            }
            if (this.listdealfunding) {
                for (var k = 0; k < this.listdealfunding.length; k++) {
                    for (var l = 0; l < this.lstNoteFunding.length; l++) {
                        if (this.listdealfunding[k].DealFundingID) {
                            if (this.listdealfunding[k].DealFundingID == this.lstNoteFunding[l].DealFundingID) {
                                this.lstNoteFunding[l].Comments = this.listdealfunding[k].Comment;
                                this.lstNoteFunding[l].GeneratedBy = this.listdealfunding[k].GeneratedBy;
                                this.lstNoteFunding[l].GeneratedByText = this.listdealfunding[k].GeneratedByText;
                                this.lstNoteFunding[l].PurposeID = this.listdealfunding[k].PurposeID;
                                this.lstNoteFunding[l].Purpose = this.listdealfunding[k].PurposeText;
                                this.lstNoteFunding[l].WF_CurrentStatus = this.listdealfunding[k].WF_CurrentStatus;
                            }
                        }
                        else if (this.listdealfunding[k].DealFundingRowno) {
                            if (this.listdealfunding[k].DealFundingRowno == this.lstNoteFunding[l].DealFundingRowno) {
                                this.lstNoteFunding[l].Comments = this.listdealfunding[k].Comment;
                                this.lstNoteFunding[l].GeneratedBy = this.listdealfunding[k].GeneratedBy;
                                this.lstNoteFunding[l].GeneratedByText = this.listdealfunding[k].GeneratedByText;
                                this.lstNoteFunding[l].PurposeID = this.listdealfunding[k].PurposeID;
                                this.lstNoteFunding[l].Purpose = this.listdealfunding[k].PurposeText;
                                this.lstNoteFunding[l].WF_CurrentStatus = this.listdealfunding[k].WF_CurrentStatus;
                            }
                        }
                    }
                }
            }
            this.Dealfuturefunding.CREDealID = this._deal.CREDealID;
            this.Dealfuturefunding.EnableAutoSpread = this._deal.EnableAutoSpread;
            this.Dealfuturefunding.PayruleDealFundingList = this.listdealfunding;
            this.Dealfuturefunding.PayruleNoteAMSequenceList = this.lstSequence;
            this.Dealfuturefunding.PayruleTargetNoteFundingScheduleList = this.lstNoteFunding;
            this.Dealfuturefunding.AutoSpreadRuleList = this.lstautospreadrule;
            this.Dealfuturefunding.AllowFFSaveJsonIntoBlob = this._deal.AllowFFSaveJsonIntoBlob;
            if (this.Dealfuturefunding.AutoSpreadRuleList) {
                for (var i = 0; i < this.Dealfuturefunding.AutoSpreadRuleList.length; i++) {
                    if (this.Dealfuturefunding.AutoSpreadRuleList[i].AutoSpreadRuleID == null) {
                        this.Dealfuturefunding.AutoSpreadRuleList[i].AutoSpreadRuleID = '00000000-0000-0000-0000-000000000000';
                    }
                    else {
                        this.Dealfuturefunding.AutoSpreadRuleList[i].AutoSpreadRuleID = this.Dealfuturefunding.AutoSpreadRuleList[i].AutoSpreadRuleID;
                    }
                    if (!(Number(this.Dealfuturefunding.AutoSpreadRuleList[i].PurposeTypeText).toString() == "NaN" || Number(this.Dealfuturefunding.AutoSpreadRuleList[i].PurposeTypeText) == 0)) {
                        this.Dealfuturefunding.AutoSpreadRuleList[i].PurposeType = Number(this.Dealfuturefunding.AutoSpreadRuleList[i].PurposeTypeText);
                        this.Dealfuturefunding.AutoSpreadRuleList[i].PurposeTypeText = this.lstPurposeType.find(function (x) { return x.LookupID == _this.Dealfuturefunding.AutoSpreadRuleList[i].PurposeType; }).Name;
                    }
                    else {
                        this.Dealfuturefunding.AutoSpreadRuleList[i].PurposeType = Number(this.lstPurposeType.find(function (x) { return x.Name == _this.Dealfuturefunding.AutoSpreadRuleList[i].PurposeTypeText; }).LookupID);
                    }
                    if (!(Number(this.Dealfuturefunding.AutoSpreadRuleList[i].DistributionMethodText).toString() == "NaN" || Number(this.Dealfuturefunding.AutoSpreadRuleList[i].DistributionMethodText) == 0)) {
                        this.Dealfuturefunding.AutoSpreadRuleList[i].DistributionMethod = Number(this.Dealfuturefunding.AutoSpreadRuleList[i].DistributionMethodText);
                        this.Dealfuturefunding.AutoSpreadRuleList[i].DistributionMethodText = this.listautospreadrule.find(function (x) { return x.LookupID == _this.Dealfuturefunding.AutoSpreadRuleList[i].DistributionMethod; }).Name;
                    }
                    else {
                        this.Dealfuturefunding.AutoSpreadRuleList[i].DistributionMethod = Number(this.listautospreadrule.find(function (x) { return x.Name == _this.Dealfuturefunding.AutoSpreadRuleList[i].DistributionMethodText; }).LookupID);
                    }
                }
            }
            for (var i = 0; i < this.lstNote.length; i++) {
                // List lstNote & lstSequenceHistory have different orderby, to match note used this loop
                for (var j = 0; j < this.lstSequenceHistory.length; j++) {
                    if (this.lstSequenceHistory[j].CRENoteID == this.lstNote[i].CRENoteID) {
                        var temp1;
                        temp1 = new notedetailfunding_1.notedetailfunding('');
                        temp1.CRENoteID = this.lstSequenceHistory[j].CRENoteID;
                        temp1.NoteName = this.lstSequenceHistory[j].Name;
                        temp1.NoteID = this.lstSequenceHistory[j].NoteID;
                        temp1.UseRuletoDetermineNoteFundingText = this.lstSequenceHistory[j].UseRuletoDetermineNoteFundingText;
                        temp1.NoteFundingRuleText = this.lstSequenceHistory[j].NoteFundingRuleText;
                        temp1.FundingPriority = this.lstSequenceHistory[j].FundingPriority;
                        temp1.NoteBalanceCap = this.lstSequenceHistory[j].NoteBalanceCap;
                        temp1.RepaymentPriority = this.lstSequenceHistory[j].RepaymentPriority;
                        temp1.TotalCommitment = this.lstNote[i].TotalCommitment;
                        temp1.Lienposition = this.lstSequenceHistory[j].lienposition == null ? 99999 : this.lstSequenceHistory[j].lienposition;
                        temp1.Priority = this.lstSequenceHistory[j].Priority;
                        // temp1.AdjustedTotalCommitment = this.lstSequenceHistory[j].AdjustedTotalCommitment;
                        // temp1.AggregatedTotal = this.lstSequenceHistory[j].AggregatedTotal;
                        temp1.InitialFundingAmount = this.lstSequenceHistory[j].InitialFundingAmount;
                        temp1.CommitmentUsedInFFDistribution = this.lstSequenceHistory[j].CommitmentUsedInFFDistribution;
                        temparray.push(temp1);
                        this.lstNote[i].UseRuletoDetermineNoteFundingText = this.lstSequenceHistory[j].UseRuletoDetermineNoteFundingText;
                        this.lstNote[i].NoteFundingRuleText = this.lstSequenceHistory[j].NoteFundingRuleText;
                        this.lstNote[i].FundingPriority = this.lstSequenceHistory[j].FundingPriority;
                        this.lstNote[i].NoteBalanceCap = this.lstSequenceHistory[j].NoteBalanceCap;
                        this.lstNote[i].RepaymentPriority = this.lstSequenceHistory[j].RepaymentPriority;
                        // this.lstNote[i].AdjustedTotalCommitment = this.lstSequenceHistory[j].AdjustedTotalCommitment;
                        // this.lstNote[i].AggregatedTotal = this.lstSequenceHistory[j].AggregatedTotal;
                    }
                }
            }
            this.Dealfuturefunding.PayruleNoteDetailFundingList = temparray;
        }
        catch (err) {
            //alert(err);
        }
    };
    DealDetailComponent.prototype.CheckDuplicateDealAndSave = function () {
        var _this = this;
        this._isListFetching = true;
        var checkForDuplicate = "";
        if (this._isnotegridEdited == true) {
            checkForDuplicate = "Check";
        }
        if (this.isIDorNameChanged == true) {
            checkForDuplicate = "Check";
        }
        if (checkForDuplicate != "") {
            this._deal.notelist = this.lstNote;
            this.dealSrv.checkduplicatedeal(this._deal).subscribe(function (res) {
                if (res.Succeeded) {
                    if (res.Message == "Save") {
                        _this.CheckConcurrenyAndSave();
                    }
                    else {
                        _this._isListFetching = false;
                        _this.CustomAlert(res.Message);
                    }
                }
                else {
                    _this._ShowmessagedivWar = true;
                    _this._ShowmessagedivMsgWar = "Error occurred while saving Deal , please contact your system administrator.";
                }
            });
        }
        else {
            this.CheckConcurrenyAndSave();
        }
    };
    DealDetailComponent.prototype.CheckConcurrenyAndSave = function () {
        var _this = this;
        this._isListFetching = true;
        var generatefunding = "";
        var hasYnotes = false;
        var lstUseY;
        var lstUseN;
        //this._deal.TotalCommitment = this.dealTotalCommitmenttextboxvalue;
        //==========Use rule determine N===============
        lstUseY = this.lstSequenceHistory.filter(function (x) { return x.UseRuletoDetermineNoteFundingText == "3" || x.UseRuletoDetermineNoteFundingText == "Y"; });
        if (lstUseY) {
            if (lstUseY.length != 0) {
                hasYnotes = true;
            }
        }
        if (this.listdealfunding !== undefined) {
            if (this.listdealfunding.length > 0) {
                if (hasYnotes) {
                    if (!this._isdealfundingChanged) {
                        generatefunding = "<p>" + "You must generate funding schedule before you could save your changes.";
                    }
                    if (this.isrowdeleted) {
                        generatefunding = "<p>" + "You must generate funding schedule before you could save your changes.";
                    }
                    if (this._isFundingruleChanged) {
                        generatefunding = "<p>" + "You must generate funding schedule before you could save your changes.";
                    }
                    if (!this._isdealfundingEdit) {
                        generatefunding = "<p>" + "You must generate funding schedule before you could save your changes.";
                    }
                    if (this.isMaturityDataChanged == true) {
                        generatefunding = "<p>" + "You must generate funding schedule before you could save your changes.";
                    }
                    if (this.checked == true) {
                        if (this._autospreadgenerate) {
                            generatefunding = "<p>" + "You must generate funding schedule before you could save your changes.";
                        }
                    }
                    //if (this._isrepaymentChanged == true) {
                    //    generatefunding = "<p>" + "You must generate funding schedule before you could save your changes.";
                    //}
                }
            }
        }
        if (this._deal.EnableAutospreadRepayments == true) {
            if (!this._isdealfundingChanged) {
                generatefunding = "<p>" + "You must generate funding schedule before you could save your changes.";
            }
        }
        if (this._isAmortSchChanges) {
            if (!(this._deal.amort.AmortizationMethod == 623 || this._deal.amort.AmortizationMethodText == "IO Only")) {
                generatefunding = "<p>" + "You must generate amort schedule before you could save your changes.";
            }
        }
        if (generatefunding == "") {
            if (this._deal.LastUpdatedFF_String != null && this._deal.LastUpdatedFF_String != '') {
                this.dealSrv.CheckConcurrentUpdate(this._deal).subscribe(function (res) {
                    if (res.Succeeded) {
                        if (res.Message == "") {
                            _this.CustomValidator();
                        }
                        else {
                            _this.CustomAlert(res.Message);
                            _this._isListFetching = false;
                        }
                    }
                });
            }
            else {
                this.CustomValidator();
            }
        }
        else {
            this._isListFetching = false;
            this.CustomAlert(generatefunding);
        }
    };
    DealDetailComponent.prototype.CustomValidator = function () {
        var _this = this;
        var i;
        var ms;
        var isDeptOpexExist = false;
        var isDeptOpexExistAfterDate = false;
        var colTotalNnotes = 0;
        var currentnotename = "";
        var extendedmsg;
        var dealfundingmsg;
        var dealfundingamount;
        var prepaymentmsg;
        var prepaymentmsg1;
        var prepaymentmsg2;
        var prepaymentdatemsg;
        var CREIDduplicateNotelevelmsg;
        var noteTotalCommitment = 0;
        var invalivadte;
        var netdealfunding = 0;
        var totalintitalfunding = 0;
        var maxmat = null;
        var minmat = null;
        var maxextendedmat = null;
        var hasYnotes = false;
        var lstUseY;
        var errordialog = "";
        var lstUseN;
        var notenames = "";
        var SumFundingSeq = 0;
        var SumRepaymentSeq = 0;
        var isamountblank = false, isDateblank = false, ispurposeblank = false;
        ms = "Please fill following fields - ";
        var fundingerror = "";
        extendedmsg = "";
        dealfundingmsg = "";
        dealfundingamount = "";
        invalivadte = "";
        prepaymentmsg = "";
        prepaymentmsg1 = "";
        prepaymentmsg2 = "";
        prepaymentdatemsg = "";
        prepaymentdatemsg = "";
        CREIDduplicateNotelevelmsg = "";
        this.ConvertInSequenceList();
        var sumdealfundingwithnotetransfer = 0;
        var sumdealfundIncludeOtherandTransfer = 0;
        var sumdealfunding = 0;
        var sumdealrepayment = 0;
        var checknoteValidation = "";
        var CREIDduplicate = false;
        var NameDuplicate = false;
        var nameblank = false;
        var CREIDduplicateNotelevel = true;
        var max_ExtensionMat;
        var RuleTypelength = 0;
        var RuleTypeFileNameerror = '';
        var RuleTypeerr = '';
        var dtRuleType = [];
        if (this._isnotegridEdited == true) {
            checknoteValidation = "Check";
        }
        if (this.isIDorNameChanged == true) {
            checknoteValidation = "Check";
        }
        if (checknoteValidation == "Check") {
            CREIDduplicate = this.checkIfArrayIsUnique(this.lstNote, 'CRENoteID');
            NameDuplicate = this.checkIfArrayIsUnique(this.lstNote, 'NoteName');
            nameblank = this.checkIfNoteIdorNameBlank(this.lstNote);
        }
        if (this.listdealfunding != undefined) {
            if (this.listdealfunding.length > 0) {
                for (var df = 0; df < this.listdealfunding.length; df++) {
                    if (!(Number(this.listdealfunding[df].PurposeText).toString() == "NaN" || Number(this.listdealfunding[df].PurposeText) == 0)) {
                        this.listdealfunding[df].PurposeID = Number(this.listdealfunding[df].PurposeText);
                        this.listdealfunding[df].PurposeText = this.lstPurposeType.find(function (x) { return x.LookupID == _this.listdealfunding[df].PurposeID; }).Name;
                    }
                    if (this.listdealfunding[df].Value) {
                        if (this.listdealfunding[df].Value > 0) {
                            if (this.listdealfunding[df].PurposeText != "Note Transfer") {
                                sumdealfundingwithnotetransfer = sumdealfundingwithnotetransfer + this.listdealfunding[df].Value;
                            }
                            if (this.listdealfunding[df].PurposeText == "Note Transfer" || this.listdealfunding[df].PurposeText == "Other") {
                                sumdealfundIncludeOtherandTransfer = sumdealfundIncludeOtherandTransfer + this.listdealfunding[df].Value;
                            }
                            sumdealfunding = sumdealfunding + this.listdealfunding[df].Value;
                        }
                        else if (this.listdealfunding[df].Value < 0) {
                            sumdealrepayment = sumdealrepayment + this.listdealfunding[df].Value;
                        }
                    }
                }
            }
        }
        sumdealfundingwithnotetransfer = parseFloat((sumdealfundingwithnotetransfer).toFixed(2));
        sumdealfunding = parseFloat((sumdealfunding).toFixed(2));
        sumdealrepayment = parseFloat((sumdealrepayment).toFixed(2));
        sumdealfundIncludeOtherandTransfer = parseFloat((sumdealfundIncludeOtherandTransfer).toFixed(2));
        if (this.ShowUseRuleN) {
            this.lstNoteFunding = [];
            var griddata = this.cvDealFundingList.sourceCollection;
            for (var df = 0; df < griddata.length; df++) {
                griddata[df].DealFundingRowno = df + 1;
                if (this.lstNote[0] != null) {
                    for (var val = 0; val < this.lstSequenceHistory.length; val++) {
                        var newlist = new deals_1.Notefunding;
                        newlist.NoteID = this.lstNote[val].NoteId;
                        newlist.NoteName = this.lstNote[val].Name;
                        if (griddata[df][this.lstSequenceHistory[val].Name] == null || griddata[df][this.lstSequenceHistory[val].Name] == undefined) {
                            newlist.Value = "0";
                        }
                        else {
                            newlist.Value = griddata[df][this.lstSequenceHistory[val].Name];
                        }
                        newlist.Date = griddata[df].Date;
                        newlist.isDeleted = 0;
                        newlist.Applied = griddata[df].Applied;
                        newlist.Comments = griddata[df].Comment;
                        newlist.DealFundingRowno = griddata[df].DealFundingRowno;
                        newlist.PurposeID = griddata[df].PurposeID;
                        newlist.Purpose = griddata[df].PurposeText;
                        newlist.GeneratedBy = griddata[df].GeneratedBy;
                        newlist.GeneratedByText = griddata[df].GeneratedByText;
                        this.lstNoteFunding.push(newlist);
                    }
                }
            }
            for (var df = 0; df < this.lstNoteFunding.length; df++) {
                if (!(Number(this.lstNoteFunding[df].Purpose).toString() == "NaN" || Number(this.lstNoteFunding[df].Purpose) == 0)) {
                    this.lstNoteFunding[df].PurposeID = Number(this.lstNoteFunding[df].Purpose);
                    this.lstNoteFunding[df].Purpose = this.lstPurposeType.find(function (x) { return x.LookupID == Number(_this.lstNoteFunding[df].PurposeID); }).Name;
                }
            }
        }
        //==========Use rule determine N===============
        lstUseY = this.lstSequenceHistory.filter(function (x) { return x.UseRuletoDetermineNoteFundingText == "3" || x.UseRuletoDetermineNoteFundingText == "Y"; });
        lstUseN = this.lstSequenceHistory.filter(function (x) { return x.UseRuletoDetermineNoteFundingText == "4" || x.UseRuletoDetermineNoteFundingText == "N"; });
        if (lstUseY) {
            if (lstUseY.length != 0) {
                hasYnotes = true;
            }
        }
        if (this._deal.CREDealID == "" || this._deal.CREDealID == null || this._deal.CREDealID === undefined) {
            ms = ms + " Deal ID";
        }
        if (this._deal.DealName == "" || this._deal.DealName == null || this._deal.DealName === undefined) {
            ms = ms + ", Deal name";
        }
        if (checknoteValidation == "Check") {
            if (CREIDduplicate != true) {
                fundingerror = fundingerror + "<p>" + "Please enter unique CRE NoteID in Deal." + "</p>";
            }
            if (NameDuplicate != true) {
                fundingerror = fundingerror + "<p>" + "Please enter unique Note Name in Deal." + "</p>";
            }
            if (nameblank == true) {
                fundingerror = fundingerror + "<p>" + "Note name Cannot be blank." + "</p>";
            }
        }
        //Note name and note id are required.
        if (this.lstNotePayruleSetup != undefined) {
            var msg = "";
            var msg1 = "";
            var objSum = 0;
            var objFromNote = '';
            var data = this.lstNotePayruleSetup;
            var reqstrip = "";
            var stripitself = "";
            //check Payrule validation 
            $.each(data, function (obj) {
                var i = 0;
                $.each(data[obj], function (key, value) {
                    if (!(key == 'FromNote' || key == 'RuleText' || key == 'RuleID' || key == 'Total')) {
                        objSum += value ? value : 0;
                    }
                    i = i + 1;
                });
                //parseFloat((SumRepaymentSeq + temprepay).toFixed(2));
                if (parseFloat(objSum.toFixed(2)) > 1) {
                    fundingerror = fundingerror + "Total percentage stripped from a note cannot be greater than 100%.";
                }
                objSum = 0;
            });
            for (var val = 0; val < this.lstNotePayruleSetup.length; val++) {
                if (this.lstNotePayruleSetup[val].FromNote != "" && this.lstNotePayruleSetup[val].FromNote != null && this.lstNotePayruleSetup[val].FromNote != undefined) {
                    if (this.lstNotePayruleSetup[val].RuleText === null || this.lstNotePayruleSetup[val].RuleText === "" || this.lstNotePayruleSetup[val].RuleText === undefined) {
                        reqstrip = "<p>" + "Stripping Rule is a required field. Please select a valid value for rule column." + "</p>";
                    }
                }
                var temnotelist;
                var fromnote = this.lstNotePayruleSetup[val].FromNote;
                var notefound = "found";
                if (this.lstNote[0] != null && fromnote != null && fromnote.trim() != "") {
                    for (var val1 = 0; val1 < this.lstNote.length; val1++) {
                        if (this.lstNote[val1].OldCRENoteID) {
                            if (this.lstNote[val1].OldCRENoteID.toLowerCase() == fromnote.toLowerCase()) {
                                notefound = "found";
                                break;
                            }
                            else {
                                notefound = "notfound";
                            }
                        }
                    }
                }
                if (notefound == 'notfound') {
                    extendedmsg = "<p>" + "Note does not exist in this deal. Please enter a note that belongs to this deal" + "</p>";
                }
                //
                var data = this.lstNotePayruleSetup[val];
                $.each(data, function (key, value) {
                    if (key == fromnote) {
                        if (value > 0) {
                            stripitself = stripitself + key + ",";
                        }
                    }
                });
            }
            if (stripitself != "") {
                stripitself = "<p>" + "Following notes strip from themselves:" + "<p>" + stripitself.slice(0, -1) + "</p></p>";
            }
            extendedmsg = extendedmsg + reqstrip;
            extendedmsg = extendedmsg + stripitself;
        }
        var errornotes = "";
        if (this.lstSequenceHistory) {
            var tempseq;
            tempseq = 0;
            var temprepay;
            temprepay = 0;
            for (var j = 0; j < this.lstSequenceHistory.length; j++) {
                tempseq = 0;
                temprepay = 0;
                var temparry = this.lstSequence.filter(function (x) { return x.NoteID == _this.lstSequenceHistory[j].NoteID; });
                for (var val = 0; val < temparry.length; val++) {
                    if (temparry[val].SequenceTypeText === 'Funding Sequence') {
                        if (temparry[val].Value != null) {
                            tempseq = parseFloat(tempseq) + parseFloat(temparry[val].Value);
                        }
                    }
                    else if (temparry[val].SequenceTypeText === 'Repayment Sequence') {
                        if (temparry[val].Value != null) {
                            temprepay = parseFloat(temprepay) + parseFloat(temparry[val].Value);
                        }
                    }
                }
                SumFundingSeq = parseFloat((SumFundingSeq + tempseq).toFixed(2));
                SumRepaymentSeq = parseFloat((SumRepaymentSeq + temprepay).toFixed(2));
            }
        }
        var max = null;
        var min = null;
        if (this.lstNote[0] != null) {
            max_ExtensionMat = null;
            var maxInitialMaturityDate = new Date('1970-01-01Z00:00:00:000');
            var maxFullyExtendedMaturityDate = new Date('1970-01-01Z00:00:00:000');
            var maxExtendedMaturity = new Date('1970-01-01Z00:00:00:000');
            var maxActualPayoffDate = new Date('1970-01-01Z00:00:00:000');
            var usePayOffasmaturity = false;
            if (this.maturityList !== undefined) {
                if (this.maturityList.length > 0) {
                    var vlen = this.maturityList.filter(function (x) { return x.ActualPayoffDate == null; }).length;
                    if (vlen == 0) {
                        usePayOffasmaturity = true;
                    }
                }
            }
            if (this.maturityList !== undefined) {
                if (this.maturityList.length > 0) {
                    for (var j = 0; j < this.maturityList.length; j++) {
                        if (this.maturityList[j].ApprovedText == "Y" && this.maturityList[j].isDeleted == 0) {
                            if (this.maturityList[j].MaturityTypeText == "Initial") {
                                if (new Date(this.maturityList[j].MaturityDate) > maxInitialMaturityDate) {
                                    maxInitialMaturityDate = this.maturityList[j].MaturityDate;
                                }
                            }
                            if (this.maturityList[j].MaturityTypeText == "Fully extended") {
                                if (new Date(this.maturityList[j].MaturityDate) > maxFullyExtendedMaturityDate) {
                                    maxFullyExtendedMaturityDate = this.maturityList[j].MaturityDate;
                                }
                            }
                            if (this.maturityList[j].MaturityTypeText == "Extension") {
                                if (new Date(this.maturityList[j].MaturityDate) > maxExtendedMaturity) {
                                    maxExtendedMaturity = this.maturityList[j].MaturityDate;
                                }
                            }
                        }
                    }
                }
            }
            if (maxInitialMaturityDate.getFullYear() < 2000) {
                maxInitialMaturityDate = new Date(Math.max.apply(null, this.lstNote.map(function (x) { return x.InitialMaturityDate; })));
                if (maxInitialMaturityDate.getFullYear() < 2000) {
                    maxInitialMaturityDate = null;
                }
            }
            if (maxFullyExtendedMaturityDate.getFullYear() < 2000) {
                maxFullyExtendedMaturityDate = new Date(Math.max.apply(null, this.lstNote.map(function (x) { return x.FullyExtendedMaturityDate; })));
                if (maxFullyExtendedMaturityDate.getFullYear() < 2000) {
                    maxFullyExtendedMaturityDate = null;
                }
            }
            if (maxExtendedMaturity.getFullYear() < 2000) {
                maxExtendedMaturity = new Date(Math.max.apply(null, this.lstNote.map(function (x) { return x.ExtendedMaturityCurrent; })));
                max_ExtensionMat = maxExtendedMaturity;
                if (maxExtendedMaturity.getFullYear() < 2000) {
                    maxExtendedMaturity = null;
                    max_ExtensionMat = this._deal.max_ExtensionMat;
                }
            }
            if (this.maturityActualPayoffDate != null) {
                maxActualPayoffDate = new Date(this.maturityActualPayoffDate);
            }
            if (maxActualPayoffDate != null || maxActualPayoffDate != undefined) {
                if (maxActualPayoffDate.getFullYear() < 2000) {
                    maxActualPayoffDate = null;
                }
            }
            var today = new Date();
            if (maxActualPayoffDate != null && usePayOffasmaturity == true) {
                maxmat = maxActualPayoffDate;
            }
            else if (max_ExtensionMat != null) {
                maxmat = max_ExtensionMat;
            }
            else {
                var nextInitialMaturityDate = this.getnextbusinessDate(new Date(JSON.parse(JSON.stringify(maxInitialMaturityDate))), -20, false);
                if (today >= nextInitialMaturityDate) {
                    var nextExtendedMaturityDate = this.getnextbusinessDate(new Date(JSON.parse(JSON.stringify(maxExtendedMaturity))), -20, false);
                    if (today >= nextExtendedMaturityDate) {
                        maxmat = maxFullyExtendedMaturityDate;
                    }
                    else {
                        maxmat = maxExtendedMaturity;
                    }
                }
                else {
                    //Use InitialMaturityDate if it is smaller than today date
                    maxmat = maxInitialMaturityDate;
                }
                maxmat = this.getPreviousWorkingDate(new Date(JSON.parse(JSON.stringify(maxmat))));
                for (var val = 0; val < this.lstNote.length; val++) {
                    var current = this.lstNote[val];
                    if (maxextendedmat == null || current.FullyExtendedMaturityDate > maxextendedmat) {
                        maxextendedmat = current.FullyExtendedMaturityDate;
                    }
                    if (this.minClosingDate === null || current.ClosingDate < this.minClosingDate) {
                        this.minClosingDate = current.ClosingDate;
                    }
                }
            }
        }
        var warningFunding = this.ValidateFuturePaydown();
        if (warningFunding != "") {
            errordialog = errordialog + warningFunding;
        }
        var arrynotenamenegative = "";
        var arrynotenamepositive = "";
        var positivefundingnotes = "";
        var negatiefudingnotes = "";
        // N note validation start
        if (this.ShowUseRuleN) {
            for (var d = 0; d < this.listdealfunding.length; d++) {
                if (this.listdealfunding[d].PurposeID || this.listdealfunding[d].Value || this.listdealfunding[d].Date) {
                    if (!this.listdealfunding[d].PurposeID) {
                        ispurposeblank = true;
                    }
                    if (!this.listdealfunding[d].Value) {
                        isamountblank = true;
                    }
                    if (!this.listdealfunding[d].Date) {
                        isDateblank = true;
                    }
                }
                if (this.listdealfunding[d].PurposeText == "" && this.listdealfunding[d].Applied == false) {
                    ispurposeblank = true;
                }
                if (this.listdealfunding[d].PurposeText == "Debt Service / Opex" && this.listdealfunding[d].Applied == false) {
                    isDeptOpexExist = true;
                }
                if (this.listdealfunding[d].PurposeText == "Debt Service / Opex" && this.listdealfunding[d].Applied == true && new Date(this.listdealfunding[d].Date) > new Date('6/1/2019')) {
                    isDeptOpexExistAfterDate = true;
                }
                //positive amount
                if (this.listdealfunding[d].PurposeText == "Capital Expenditure" || this.listdealfunding[d].PurposeText == "OpEx" || this.listdealfunding[d].PurposeText == "Force Funding" || this.listdealfunding[d].PurposeText == "Capitalized Interest" || this.listdealfunding[d].PurposeText == "TI/LC" || this.listdealfunding[d].PurposeText == "Additional Collateral Purchase") {
                    if (Date.parse(maxmat) != 0) {
                        if (this.listdealfunding[d].Date > maxmat) {
                            if (this.listdealfunding[d].Applied != true) {
                                if (this.listdealfunding[d].Comment != null || this.listdealfunding[d].Comment != "") {
                                    fundingerror = fundingerror + "<p>" + "Any date(s) after the Maturity date <b>(" + this.convertDateToBindable(maxmat) + ") </b> in Deal Funding Schedule is not allowed." + "</p>";
                                    break;
                                }
                                else {
                                    if (this._deal.EnableAutoSpread != true) {
                                        fundingerror = fundingerror + "<p>" + "Any date(s) after the Maturity date <b>(" + this.convertDateToBindable(maxmat) + ") </b> in Deal Funding Schedule is not allowed." + "</p>";
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
                // if (this.checked == false) {
                //negative amount
                var currentpurpose = this.listdealfunding[d].PurposeText;
                if (this.listdealfunding[d].PurposeText == "Amortization" || this.listdealfunding[d].PurposeText == "Property Release" || this.listdealfunding[d].PurposeText == "Full Payoff" || this.listdealfunding[d].PurposeText == "Paydown") {
                    if (maxFullyExtendedMaturityDate != null) {
                        if (this.listdealfunding[d].Date > maxFullyExtendedMaturityDate) {
                            var showvalidation = false;
                            if (currentpurpose != "Paydown") {
                                showvalidation = true;
                            }
                            else {
                                if (this.listdealfunding[d].Comment != null || this.listdealfunding[d].Comment != "") {
                                    showvalidation = true;
                                }
                                else if (this.checked == false) {
                                    showvalidation = true;
                                }
                            }
                            if (showvalidation == true) {
                                fundingerror = fundingerror + "<p>" + "Any date(s) after the fully extended maturity date <b>(" + this.convertDateToBindable(maxFullyExtendedMaturityDate) + ") </b> in Deal Repayment Schedule is not allowed." + "</p>";
                                break;
                            }
                        }
                    }
                }
                //other
                if (this.listdealfunding[d].PurposeText == "Other" || this.listdealfunding[d].PurposeText == "Note Transfer") {
                    if (this.listdealfunding[d].Value !== null || this.listdealfunding[d].Value !== undefined) {
                        if (Math.sign(this.listdealfunding[d].Value) == -1) {
                            if (maxextendedmat == null) {
                                maxextendedmat = maxmat;
                            }
                            if (Date.parse(maxextendedmat) != 0 && maxextendedmat != null) {
                                if (this.listdealfunding[d].Date > maxextendedmat) {
                                    fundingerror = fundingerror + "<p>" + "Any date(s) after the fully extended maturity date <b>(" + this.convertDateToBindable(maxextendedmat) + ") </b> in Deal Schedule is not allowed." + "</p>";
                                    break;
                                }
                            }
                        }
                        else {
                            if (Date.parse(maxmat) != 0 && maxextendedmat != null) {
                                if (this.listdealfunding[d].Date > maxmat) {
                                    fundingerror = fundingerror + "<p>" + "Any date(s) after the Maturity date <b>(" + this.convertDateToBindable(maxmat) + ") </b> in Deal Schedule is not allowed." + "</p>";
                                    break;
                                }
                            }
                        }
                    }
                }
                // }
            }
            var fundingdates = "";
            //deal funding loop start
            var notwireDealfunding = this.listdealfunding.filter(function (x) { return x.Applied != true || x.Applied == undefined; });
            if (notwireDealfunding.length > 0) {
                for (var t = 0; t < notwireDealfunding.length; t++) {
                    //Row Total start
                    var rowtotal = 0, dealrowfund = 0;
                    dealrowfund = notwireDealfunding[t].Value; //flexdefunding.getCellData(e.row, 3, false);
                    //increment for adding new column in dealfunding grid
                    if (this.dynamicColList.length > 32) {
                        for (var m = 33; m < this.dynamicColList.length; m++) {
                            if (this.dynamicColList[m] != "Date" && this.dynamicColList[m] != "PurposeID" && this.dynamicColList[m] != "DealFundingRowno" && this.dynamicColList[m] != "Applied") {
                                if (notwireDealfunding[t][this.dynamicColList[m]]) {
                                    if (notwireDealfunding[t][this.dynamicColList[m]].toString().includes(',')) {
                                        rowtotal += parseFloat(notwireDealfunding[t][this.dynamicColList[m]].replace(/,/g, ''));
                                        // rowtotal += notwireDealfunding[t][this.dynamicColList[m]];
                                    }
                                    else {
                                        rowtotal += parseFloat(notwireDealfunding[t][this.dynamicColList[m]]);
                                    }
                                }
                            }
                        }
                    }
                    else {
                        for (var m = 0; m < this.dynamicColList.length; m++) {
                            if (this.dynamicColList[m] != "Date" && this.dynamicColList[m] != "PurposeID" && this.dynamicColList[m] != "DealFundingRowno" && this.dynamicColList[m] != "Applied") {
                                if (notwireDealfunding[t][this.dynamicColList[m]]) {
                                    if (notwireDealfunding[t][this.dynamicColList[m]].toString().includes(',')) {
                                        // rowtotal += parseFloat(notwireDealfunding[t][this.dynamicColList[m]].toString().replace(',', '').toString().replace(',', ''));
                                        rowtotal += parseFloat(notwireDealfunding[t][this.dynamicColList[m]].replace(/,/g, ''));
                                        // rowtotal += notwireDealfunding[t][this.dynamicColList[m]];
                                    }
                                    else {
                                        rowtotal += parseFloat(notwireDealfunding[t][this.dynamicColList[m]]);
                                    }
                                }
                            }
                        }
                    }
                    //  if (rowtotal && dealrowfund) {
                    if (rowtotal !== null && rowtotal !== undefined && dealrowfund !== null && dealrowfund !== undefined) {
                        if (parseFloat(parseFloat(rowtotal.toString()).toFixed(2)) != parseFloat(parseFloat(dealrowfund.toString()).toFixed(2))) {
                            if (!isDateblank) {
                                this._isdealfundingChanged = false;
                                fundingdates += this.convertDateToBindable(notwireDealfunding[t].Date) + ", ";
                            }
                        }
                    }
                    //if (this.checked == false) {
                    //    if (notwireDealfunding[t].Date != null) {
                    //        var sdate = new Date(notwireDealfunding[t].Date)
                    //        var formateddate = this.convertDateToBindable(notwireDealfunding[t].Date);
                    //        var dealfundingday = sdate.getDay();
                    //        if (dealfundingday == 6 || dealfundingday == 0
                    //            || this.ListHoliday.filter(x => this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411).length > 0
                    //        ) {
                    //            var dateexist = errordate.includes(this.convertDateToBindable(sdate));
                    //            if (!dateexist) {
                    //                errordate += this.convertDateToBindable(sdate) + ", ";
                    //                isvalidateHolidaySatSun = false;
                    //            }
                    //        }
                    //    }  //Row Total end
                    //}
                }
            }
            if (fundingdates != "") {
                fundingerror = fundingerror + "<p>" + "At " + fundingdates.slice(0, fundingdates.length - 2) + " sum of note funding is not equal to deal funding." + "</p>";
            }
        }
        //N note validation end
        //for (var df = 0; df < this.listdealfunding.length; df++) {
        //    if (this.listdealfunding[df].Applied == false) {
        //        //if (this.listdealfunding[df].Comment != null && this.listdealfunding[df].Comment != "") {
        //            var sdate = new Date(this.listdealfunding[df].Date);
        //            var formateddate = this.convertDateToBindable(this.listdealfunding[df].Date);
        //            var dealfundingday = sdate.getDay();
        //            if (dealfundingday == 6 || dealfundingday == 0 || this.ListHoliday.filter(x => this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411).length > 0) {
        //                var dateexist = errordate.includes(this.convertDateToBindable(sdate));
        //                if (!dateexist) {
        //                    errordate += this.convertDateToBindable(sdate) + ", ";
        //                    isvalidateHolidaySatSun = false;
        //                }
        //            }
        //    }
        //}
        //if (!isvalidateHolidaySatSun) {
        //    fundingerror = fundingerror + "<p>" + "You have entered a funding date (" + errordate.slice(0, errordate.length - 2) + ") which is either on holiday or weekend. Please enter different date." + "</p>";
        //}
        var errordate = '';
        var isvalidateHolidaySatSun = true;
        for (var df = 0; df < this.listdealfunding.length; df++) {
            if (this.listdealfunding[df].Applied == false) {
                var sdate = new Date(this.listdealfunding[df].Date);
                var formateddate = this.convertDateToBindable(this.listdealfunding[df].Date);
                var dealfundingday = sdate.getDay();
                if (dealfundingday == 6 || dealfundingday == 0 || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411; }).length > 0) {
                    var dateexist = errordate.includes(this.convertDateToBindable(sdate));
                    if (!dateexist) {
                        errordate += this.convertDateToBindable(sdate) + ", ";
                        isvalidateHolidaySatSun = false;
                    }
                }
            }
            var ss = df + 1;
            if (ss <= this.listdealfunding.length) {
                //  this.lstNoteFunding.find(x => x.DealFundingRowno == ss).WF_CurrentStatus = this.listdealfunding[ss].WF_CurrentStatus;
                var ltnt = this.lstNoteFunding.filter(function (x) { return x.DealFundingRowno == ss; }); //.WF_CurrentStatus = this.listdealfunding[ss].WF_CurrentStatus;
                if (ltnt.length > 0) {
                    for (var s = 0; s < ltnt.length; s++) {
                        ltnt[s].WF_CurrentStatus = this.listdealfunding[df].WF_CurrentStatus;
                    }
                }
            }
            if (this.listdealfunding[df].PurposeText != "" || this.listdealfunding[df].PurposeText != null || this.listdealfunding[df].PurposeText != undefined) {
                var purposetype = "";
                if (!(Number(this.listdealfunding[df].PurposeText).toString() == "NaN" || Number(this.listdealfunding[df].PurposeText) == 0)) {
                    purposetype = this.lstPurposeType.find(function (x) { return x.LookupID == Number(_this.listdealfunding[df].PurposeText); }).Name;
                    this.listdealfunding[df].PurposeText = purposetype;
                }
                else {
                    purposetype = this.listdealfunding[df].PurposeText;
                }
                if (purposetype == "Amortization" || purposetype == "Paydown" || purposetype == "Property Release" || purposetype == "Full Payoff") {
                    if (this.listdealfunding[df].Value !== null || this.listdealfunding[df].Value !== undefined) {
                        //check if value is null
                        if (Math.sign(this.listdealfunding[df].Value) == 1) {
                            dealfundingamount = dealfundingamount + "<p>" + "Transaction amount should be negative for transactions type Amortization, Paydown, Full Payoff and Property Release." + "</p>";
                            break;
                        }
                    }
                }
                if (purposetype == "Capital Expenditure" || purposetype == "OpEx" || purposetype == "Force Funding" || purposetype == "Capitalized Interest" || purposetype == "TI/LC" || purposetype == "Additional Collateral Purchase") {
                    if (this.listdealfunding[df].Value !== null || this.listdealfunding[df].Value !== undefined) {
                        //check if value is null
                        if (Math.sign(this.listdealfunding[df].Value) == -1) {
                            dealfundingamount = dealfundingamount + "<p>" + "Transaction amount should be positive for transactions type Capital Expenditure, Capitalized Interest, OpEx, Force Funding, TI/LC, Additional Collateral Purchase." + "</p>";
                            break;
                        }
                    }
                }
            }
            if (this.listdealfunding[df].Date != null) {
                if (new Date(this.listdealfunding[df].Date) < this.minClosingDate) {
                    invalivadte = "<p>" + "Any Funding/Repayment date before closing date is invalid" + "</p>";
                    break;
                }
            }
        }
        //deal funding loop end
        if (!isvalidateHolidaySatSun) {
            fundingerror = fundingerror + "<p>" + "You have entered a funding date (" + errordate.slice(0, errordate.length - 2) + ") which is either on holiday or weekend. Please enter different date." + "</p>";
        }
        var sumdealrepayment = parseFloat(this.listdealfunding.reduce(function (r, a) { return a.Value < 0 ? r + parseFloat(a.Value) : r; }, 0).toFixed(2));
        if (this._deal.AggregatedTotal == null) {
            this._deal.AggregatedTotal = 0;
        }
        netdealfunding = parseFloat(this.listdealfunding.reduce(function (r, a) { return a.Value ? r + parseFloat(a.Value) : r; }, 0).toFixed(2));
        totalintitalfunding = parseFloat(this.lstSequenceHistory.reduce(function (r, a) { return a.InitialFundingAmount > 0.01 ? r + parseFloat(a.InitialFundingAmount) : r; }, 0).toFixed(2));
        var sumtotalfunding = parseFloat((sumdealfundingwithnotetransfer + totalintitalfunding).toFixed(2));
        if (parseFloat(sumtotalfunding.toFixed(2)) > parseFloat(parseFloat(this._totalcommitmenttextboxvalue).toFixed(2))) {
            fundingerror = fundingerror + "<p>" + "The sum of Deal Funding (" + this.formatMoney(sumdealfundingwithnotetransfer) + ") and Initial Funding (" + this.formatMoney(totalintitalfunding) + ") should be less than or equal to the Total Commitment." + "</p>";
        }
        if (parseFloat(sumtotalfunding.toFixed(2)) < parseFloat(parseFloat(this._deal.TotalCommitment).toFixed(2))) {
            // errordialog = errordialog + "Sum of deal funding (" + this.formatMoney(sumdealfundingwithnotetransfer) + ") and Initial Funding (" + this.formatMoney(totalintitalfunding) + ") is less then Total Commitment.";
        }
        //if (isamountblank) {
        //    fundingerror = fundingerror + "<p>" + "Amount can not be blank. Please enter funding amount." + "</p>";
        //}
        if (ispurposeblank) {
            fundingerror = fundingerror + "<p>" + "Please choose purpose type of funding." + "</p>";
        }
        if (isDateblank) {
            fundingerror = fundingerror + "<p>" + "Please enter funding Date." + "</p>";
        }
        if (isDeptOpexExist) {
            fundingerror = fundingerror + "<p>" + "Please choose 'Capitalized Interest' instead of 'Debt Service/Opex'." + "</p>";
        }
        if (isDeptOpexExistAfterDate) {
            fundingerror = fundingerror + "<p>" + "Debt Service/Opex is not allowed after 6/1/2019. Please choose 'Capitalized Interest' instead of 'Debt Service/Opex'." + "</p>";
        }
        if (hasYnotes) {
            if (this.checked == false) {
                if (sumdealfunding > SumFundingSeq) {
                    fundingerror = fundingerror + "<p>" + "Total funding in Deal Schedule (" + this.formatMoney(sumdealfunding) + ") cannot be  greater than total of Funding Sequences  (" + this.formatMoney(SumFundingSeq) + ")  included in funding rules." + "</p>";
                }
            }
            if (SumFundingSeq > sumdealfunding) {
                errordialog = errordialog + "<p>" + "Sum of deal funding is less than total of funding sequences." + "</p>";
            }
            if (!(sumdealrepayment * -1 <= SumRepaymentSeq)) {
                fundingerror = fundingerror + "<p>" + "Total repayments in Deal Schedule (" + this.formatMoney(sumdealrepayment) + ") cannot be  greater than total of Repayment Sequences (" + this.formatMoney(SumRepaymentSeq * -1) + ") included in funding rules.";
            }
        }
        //start-validation for work flow
        //check for duplicate comment
        //commented duplicated check validation
        /*
        var lstfund = this.listdealfunding.filter(x => (x.Comment != null && x.Comment != '' && x.Applied != true))
        if (lstfund.length > 0) {
            var valueArr = lstfund.map(function (item) { return item.Comment });
            var isDuplicate = valueArr.some(function (item, idx) {
                return valueArr.indexOf(item) != idx
            });
     
            if (isDuplicate) {
                fundingerror = fundingerror + "<p>" + " Comment should be unique for the deal."
            }
        }
        */
        //if purpose changed for the status above projected
        var isStatusChanged = false;
        for (var df = 0; df < this.listdealfundingwithoutchange.length; df++) {
            var objdealfunding = this.listdealfunding.filter(function (x) { return x.DealFundingID == _this.listdealfundingwithoutchange[df].DealFundingID; });
            if (objdealfunding.length > 0) {
                if (objdealfunding[0].WF_CurrentStatus != "Projected" && objdealfunding[0].WF_CurrentStatus != '' && objdealfunding[0].WF_CurrentStatus != null) {
                    if (Number(objdealfunding[0].PurposeText).toString() == "NaN") {
                        if (objdealfunding[0].PurposeText != this.listdealfundingwithoutchange[df].PurposeText) {
                            isStatusChanged = true;
                            break;
                        }
                    }
                    else {
                        if (objdealfunding[0].PurposeText != this.listdealfundingwithoutchange[df].PurposeID) {
                            isStatusChanged = true;
                            break;
                        }
                    }
                }
            }
        }
        if (isStatusChanged) {
            fundingerror = fundingerror + "<p>" + " You can not change the deal funding purpose for the status above Projected.";
        }
        //end-validation for work flow       
        //start validation for total commitment tab
        var adjustederror = "";
        var adjustedvalidation = false;
        if (this.listAdjustedTotalCommitment) {
            for (var m = 0; m < this.listAdjustedTotalCommitment.length; m++) {
                if (Object.keys(this.listAdjustedTotalCommitment[m]).length) {
                    if (this.listAdjustedTotalCommitment[m].Date == null || this.listAdjustedTotalCommitment[m].Date == undefined || this.listAdjustedTotalCommitment[m].Date == "") {
                        adjustederror = "Date ,";
                        adjustedvalidation = true;
                    }
                    if (this.listAdjustedTotalCommitment[m].TypeText == null || this.listAdjustedTotalCommitment[m].TypeText == "" || this.listAdjustedTotalCommitment[m].TypeText == undefined) {
                        adjustederror = adjustederror + "Type  ";
                        adjustedvalidation = true;
                    }
                    this.adjustedCommitmentcolumnheaders(this.listAdjustedTotalCommitment[m], m);
                    if (adjustedvalidation == true) {
                        if (this.adjustedcommitmentheadervalues.length > 0) {
                            fundingerror = fundingerror + "<p>" + "Commitment/Equity tab: " + adjustederror.slice(0, -1) + " field(s) can not be blank.";
                            break;
                        }
                        else if (!(this.listAdjustedTotalCommitment[m].Comments == null || this.listAdjustedTotalCommitment[m].Comments == "" || this.listAdjustedTotalCommitment[m].Comments == undefined)) {
                            fundingerror = fundingerror + "<p>" + "Commitment/Equity tab: " + adjustederror.slice(0, -1) + " field(s) can not be blank.";
                            break;
                        }
                        else {
                            fundingerror = fundingerror + "<p>" + "Commitment/Equity tab: " + adjustederror.slice(0, -1) + " field(s) can not be blank.";
                            break;
                        }
                    }
                }
            }
        }
        //end validation for total commitment tab
        ///Total Funding sequence + Initial Funding - Pre pay or scheduled amount + negative transfers - ballon = Adjusted Commitment
        var noteswithissue = "";
        if (this.lstSequenceHistory) {
            var today = new Date();
            for (var j = 0; j < this.lstSequenceHistory.length; j++) {
                var totRepayment;
                var ScheduledPrincipalPaid;
                var balloon;
                var sumNotefunding;
                totRepayment = 0;
                balloon = 0;
                sumNotefunding = 0;
                ScheduledPrincipalPaid = 0;
                var currentnoteid = this.lstSequenceHistory[j].NoteID;
                var InitialFundingAmount = this.lstSequenceHistory[j].InitialFundingAmount;
                balloon = this.lstSequenceHistory[j].BalloonPayment * -1;
                if (this.lstScheduledPrincipalPaid) {
                    if (this.lstScheduledPrincipalPaid.length > 0) {
                        var lstScheduledPrip = this.lstScheduledPrincipalPaid.filter(function (x) { return x.NoteID == currentnoteid; });
                        if (lstScheduledPrip.length > 0) {
                            var temp = lstScheduledPrip[0].Amount;
                            if (temp != null && temp != undefined) {
                                ScheduledPrincipalPaid = parseFloat((temp * -1).toFixed(2));
                            }
                        }
                    }
                }
                var noteFundingArray = this.lstNoteFunding.filter(function (x) { return x.NoteID == currentnoteid; });
                for (var m = 0; m < noteFundingArray.length; m++) {
                    if (noteFundingArray[m].Value) {
                        if (noteFundingArray[m].Value < 0) {
                            if (new Date(noteFundingArray[m].Date) <= today) {
                                totRepayment = totRepayment + parseFloat(this.GetDefaultValue(parseFloat(noteFundingArray[m].Value).toFixed(2)));
                            }
                        }
                        else {
                            if (noteFundingArray[m].Purpose != "Note Transfer") {
                                if (noteFundingArray[m].Value !== null) {
                                    sumNotefunding = sumNotefunding + parseFloat(this.GetDefaultValue(parseFloat(noteFundingArray[m].Value).toFixed(2)));
                                }
                            }
                        }
                    }
                }
                sumNotefunding = parseFloat(sumNotefunding.toFixed(2));
                totRepayment = parseFloat(totRepayment.toFixed(2));
                if (parseFloat(InitialFundingAmount) == 0.01) {
                    InitialFundingAmount = 0;
                }
                //for loop end
                //AdjustedTotalCommitment
                var subtotal = sumNotefunding + parseFloat(InitialFundingAmount) + totRepayment + parseFloat(balloon) + parseFloat(ScheduledPrincipalPaid);
                if (parseFloat(subtotal.toFixed(2)) > parseFloat(this.lstSequenceHistory[j].AdjustedTotalCommitment.toFixed(2))) {
                    var diffval = parseFloat(subtotal.toFixed(2)) - parseFloat(this.lstSequenceHistory[j].AdjustedTotalCommitment.toFixed(2));
                    if (Math.abs(parseFloat(diffval.toFixed(2))) > 0) {
                        noteswithissue = noteswithissue + this.lstSequenceHistory[j].CRENoteID + ", ";
                    }
                }
            }
        }
        if (noteswithissue != "") {
            noteswithissue = noteswithissue.substring(0, noteswithissue.length - 1);
            fundingerror = fundingerror + "<p> Sum of Future Funding and Current Balance should be less than or equal to Adjusted Commitment for Note(s) " + noteswithissue.slice(0, -1) + "</p>";
        }
        var duplicatedateerror = '';
        if (this.flexautospreadrepayments) {
            if (this.flexautospreadrepayments.rows.length > 0) {
                var founddates = '';
                var datelist = [];
                var data = this.flexautospreadrepayments.rows;
                for (var j = 0; j < data.length - 1; j++) {
                    datelist.push({ "ProjectedPayoffAsofDate": data[j].dataItem.ProjectedPayoffAsofDate });
                }
                var distinct = [];
                for (var k = 0; k < datelist.length; k++) {
                    var datetocheck = datelist[k].ProjectedPayoffAsofDate;
                    if (datetocheck) {
                        var formateddate = this.convertDateToBindable(datetocheck);
                        for (var j = k + 1; j < datelist.length; j++) {
                            var chkdate = this.convertDateToBindable(datelist[j].ProjectedPayoffAsofDate);
                            if (chkdate == formateddate) {
                                if (!(datetocheck in distinct)) {
                                    distinct.push(datetocheck);
                                }
                            }
                        }
                    }
                }
                if (distinct.length > 0) {
                    var dates = distinct.filter(function (date, i, self) {
                        return self.findIndex(function (d) { return d.getTime() === date.getTime(); }) === i;
                    });
                    if (dates.length) {
                        for (var m = 0; m < dates.length; m++) {
                            founddates += this.convertDateToBindable(dates[m]) + ", ";
                        }
                    }
                }
                if (founddates != "") {
                    founddates = founddates.substring(0, founddates.length - 1);
                    duplicatedateerror = "<p> Autospread repayment date(s) already exists " + founddates.slice(0, -1) + "</p>";
                }
            }
        }
        if (this._deal.EnableAutospreadRepayments == true) {
            if (this._deal.RepaymentAutoSpreadMethodID == null || this._deal.RepaymentAutoSpreadMethodID == undefined) {
                duplicatedateerror = duplicatedateerror + "<p> Please select autospreading repayment method." + "</p>";
            }
        }
        if (this._isMaturityTabClicked == true) {
            this.createMaturityList('Save', null, this.selectedGroupName);
            if (this._isMaturityError == "") {
                if (this.noteMaturityList.length == 0) {
                    this.noteMaturityList = this.maturityOtherFieldsList;
                }
                else {
                    this.noteMaturityList = this.noteMaturityList;
                }
            }
        }
        if (this._isReserveTabClicked == true) {
            this.validateReserveAccountList();
            this.validateReserveScheduleList();
            if (this._isReserveValidation == '' && this._isReserveScheduleValidation == '') {
                this.createReserveFundList();
                this._deal.ReserveAccountList = this.reserveAccountsList;
                this._deal.ReserveScheduleList = this.reserveScheduleList;
            }
        }
        if (this._isPrepaymentTabClicked == true) {
            var minclosingdate = new Date(Math.min.apply(null, this.lstNote.map(function (x) { return x.ClosingDate; })));
            this._prepaymentpremium = this._prepaymentpremium;
            this._prepaymentpremium.DealID = this._deal.DealID;
            this._prepaymentpremium.EffectiveDate = this.convertDatetoGMT(this._prepaymentpremium.EffectiveDate);
            this._deal.PrePayDate = this.convertDatetoGMT(this._deal.PrePayDate);
            this._prepaymentpremium.CalcThru = this.convertDatetoGMT(this._prepaymentpremium.CalcThru);
            this._prepaymentpremium.PrepayDate = this.convertDatetoGMT(this._deal.PrePayDate);
            this._prepaymentpremium.OpenPaymentDate = this.convertDatetoGMT(this._prepaymentpremium.OpenPaymentDate);
            CREIDduplicateNotelevel = this.checkIfArrayIsUnique(this._lstSpreadMaintenance, 'PrepayCRENoteID');
            if (this._deal.PrePayDate != null && this._prepaymentpremium.CalcThru != null) {
                if (this._prepaymentpremium.CalcThru < this._deal.PrePayDate) {
                    prepaymentmsg = "<p>" + "Prepayment date should be less than calc thro date " + "</p>";
                }
            }
            if (this._prepaymentpremium.CalcThru != null && maxFullyExtendedMaturityDate != null) {
                if (maxFullyExtendedMaturityDate < this._prepaymentpremium.CalcThru) {
                    prepaymentdatemsg = "<p>" + "Calc thro date should be less than fully extended maturity date " + "</p>";
                }
            }
            if (this._deal.PrePayDate != null && minclosingdate != null) {
                if (this._deal.PrePayDate < minclosingdate) {
                    prepaymentmsg1 = "<p>" + "Prepayment date should not be less than closing date " + "</p>";
                }
            }
            if (this._prepaymentpremium.CalcThru != null && minclosingdate != null) {
                if (this._prepaymentpremium.CalcThru < minclosingdate) {
                    prepaymentmsg2 = "<p>" + "Calc thro date should not be less than closing date " + "</p>";
                }
            }
            if (CREIDduplicateNotelevel != true) {
                CREIDduplicateNotelevelmsg = "<p>" + "Please select a unique NoteID at note level prepayment." + "</p>";
            }
        }
        //if (this._deal.EnableAutospreadRepayments == true) {
        //    fundingerror = fundingerror + "<p>" + "Please enable repayment auto spreading to apply note level paydowns or uncheck apply note level paydowns." + " </p>";
        //}
        if (ms.length > 31 || fundingerror != "" || extendedmsg != "" || dealfundingmsg != "" || dealfundingamount != "" || invalivadte != "" || errordialog != "" || duplicatedateerror != "" || this._isMaturityError != "" || this._isReserveValidation != "" || this._isReserveScheduleValidation != "" || prepaymentmsg != "" || prepaymentmsg1 != "" || prepaymentmsg2 != "" || prepaymentdatemsg != "" || CREIDduplicateNotelevelmsg != "") {
            var msg = "";
            if (ms.length > 31) {
                msg = ms;
            }
            if (fundingerror != "") {
                msg = msg + fundingerror;
            }
            if (extendedmsg != "") {
                msg = msg + extendedmsg;
            }
            if (this._isMaturityError != "") {
                msg = msg + this._isMaturityError;
            }
            if (this._isReserveValidation != "") {
                msg = msg + this._isReserveValidation;
            }
            if (this._isReserveScheduleValidation != "") {
                msg = msg + this._isReserveScheduleValidation;
            }
            if (prepaymentmsg != "") {
                msg = msg + prepaymentmsg;
            }
            if (prepaymentmsg1 != "") {
                msg = msg + prepaymentmsg1;
            }
            if (prepaymentmsg2 != "") {
                msg = msg + prepaymentmsg2;
            }
            if (prepaymentdatemsg != "") {
                msg = msg + prepaymentdatemsg;
            }
            if (CREIDduplicateNotelevelmsg != "") {
                msg = msg + CREIDduplicateNotelevelmsg;
            }
            msg = msg + invalivadte;
            msg = msg + dealfundingamount;
            msg = msg + dealfundingmsg;
            msg = msg + duplicatedateerror;
            this._isListFetching = false;
            if (msg != "") {
                this.CustomAlert(msg);
            }
            if (errordialog != "" && msg == "") {
                this.savedialogmsg = errordialog + "<p>" + "Do you want to proceed with save?" + "</p>";
                this.CustomDialogteSave();
            }
        }
        else {
            this.Savedeals(this._deal);
        }
    };
    DealDetailComponent.prototype.calculatediff = function (a, b) {
        return Math.abs(a - b);
    };
    DealDetailComponent.prototype.DiscardChanges = function () {
        //this._location.back();
        //  this._router.navigate(['dashboard']);
    };
    DealDetailComponent.prototype.SetClientDealId = function () {
        if (this._deal.ClientDealID) {
            this._deal.ClientDealID = this._deal.CREDealID;
        }
    };
    DealDetailComponent.prototype.DealTypeChange = function (newvalue) {
        this._deal.DealType = newvalue;
    };
    DealDetailComponent.prototype.StatusChange = function (newvalue) {
        this._deal.Statusid = newvalue;
        if (this._deal.Statusid == 325 || this._deal.Statusid.toString() == "Phantom")
            this.flex.columns[4].isReadOnly = false;
        else
            this.flex.columns[4].isReadOnly = true;
    };
    DealDetailComponent.prototype.LoanProgramChange = function (newvalue) {
        this._deal.LoanProgram = newvalue;
    };
    DealDetailComponent.prototype.LoanPurposeChange = function (newvalue) {
        this._deal.LoanPurpose = newvalue;
    };
    DealDetailComponent.prototype.SourceChange = function (newvalue) {
        this._deal.Source = newvalue;
    };
    DealDetailComponent.prototype.AmortizationMethodChange = function (newvalue) {
        var _this = this;
        this._isAmortSchChanges = true;
        var IOmismatch = false;
        var Amortmismatch = false;
        this._deal.amort.AmortizationMethodText = this.listAmortizationMethod.find(function (x) { return x.LookupID == newvalue; }).Name;
        this._deal.amort.AmortizationMethod = newvalue;
        this._isShowAddFundingSequence = true;
        // to clear box attr
        $('#PeriodicStraightLineAmortOverride').attr('style', 'background-color:none');
        $('#FixedPeriodicPayment').attr('style', 'background-color:none');
        this.Onchangeamortmethod('#NoteDistributionMethod', 'notfound');
        this.Onchangeamortmethod('#ReduceAmortizationForCurtailments', 'notfound');
        this.Onchangeamortmethod('#BusinessDayAdjustmentForAmort', 'notfound');
        this._deal.amort.NoteDistributionMethod = null;
        this._deal.amort.NoteDistributionMethodText = "";
        this._deal.amort.ReduceAmortizationForCurtailments = null;
        this._deal.amort.ReduceAmortizationForCurtailmentsText = "";
        this._deal.amort.BusinessDayAdjustmentForAmort = 571;
        this._deal.amort.BusinessDayAdjustmentForAmortText = this.listBusinessDayAdjustmentForAmort.find(function (x) { return x.LookupID == _this._deal.amort.BusinessDayAdjustmentForAmort; }).Name;
        //end
        if (newvalue == "619" || this._deal.amort.AmortizationMethodText == "Fixed Payment Amortization") {
            this._isreadonlyforfixedpaymentamort = false;
            this._isreadonlyforperiodicstraightline = true;
            this._deal.amort.NoteDistributionMethod = 624;
            this._deal.amort.NoteDistributionMethodText = this.listNoteDistributionMethod.find(function (x) { return x.LookupID == _this._deal.amort.NoteDistributionMethod; }).Name;
            $('#PeriodicStraightLineAmortOverride').attr('style', 'background-color:#D3D3D3');
        }
        else if (newvalue == "618" || this._deal.amort.AmortizationMethodText == "Straight Line Amortization") {
            this._isreadonlyforperiodicstraightline = false;
            this._isreadonlyforfixedpaymentamort = true;
            $('#FixedPeriodicPayment').attr('style', 'background-color:#D3D3D3');
            this._deal.amort.NoteDistributionMethod = 624;
            this._deal.amort.NoteDistributionMethodText = this.listNoteDistributionMethod.find(function (x) { return x.LookupID == _this._deal.amort.NoteDistributionMethod; }).Name;
        }
        else if (this._deal.amort.AmortizationMethod == 622 || this._deal.amort.AmortizationMethodText == "Custom Note Amortization") {
            this._deal.amort.NoteDistributionMethod = 635;
            this._deal.amort.NoteDistributionMethodText = this.listNoteDistributionMethod.find(function (x) { return x.LookupID == _this._deal.amort.NoteDistributionMethod; }).Name;
            this.Onchangeamortmethod('#NoteDistributionMethod', 'found');
            this._deal.amort.ReduceAmortizationForCurtailments = 572;
            this._deal.amort.ReduceAmortizationForCurtailmentsText = this.listReduceAmortizationForCurtailments.find(function (x) { return x.LookupID == _this._deal.amort.ReduceAmortizationForCurtailments; }).Name;
            this.Onchangeamortmethod('#ReduceAmortizationForCurtailments', 'found');
            this.Onchangeamortmethod('#NoteDistributionMethod', 'found');
        }
        else if (newvalue == "621" || this._deal.amort.AmortizationMethodText == "Custom Deal Amortization") {
            this._deal.amort.ReduceAmortizationForCurtailments = 572;
            this._deal.amort.ReduceAmortizationForCurtailmentsText = this.listReduceAmortizationForCurtailments.find(function (x) { return x.LookupID == _this._deal.amort.ReduceAmortizationForCurtailments; }).Name;
            this.Onchangeamortmethod('#ReduceAmortizationForCurtailments', 'found');
        }
        if (!(newvalue == "618" || this._deal.amort.AmortizationMethodText == "Straight Line Amortization" || newvalue == "619" || this._deal.amort.AmortizationMethodText == "Fixed Payment Amortization")) {
            this._isreadonlyforfixedpaymentamort = true;
            this._isreadonlyforperiodicstraightline = true;
            $('#PeriodicStraightLineAmortOverride').attr('style', 'background-color:#D3D3D3');
            $('#FixedPeriodicPayment').attr('style', 'background-color:#D3D3D3');
        }
        else if (newvalue == "618" || this._deal.amort.AmortizationMethodText == "Straight Line Amortization" || newvalue == "619" || this._deal.amort.AmortizationMethodText == "Fixed Payment Amortization") {
        }
        if (this._actualAmortMethod == this._deal.amort.AmortizationMethodText) {
            this._changedAmortMethod = this._deal.amort.AmortizationMethodText;
        }
        if (newvalue == "623" || this._deal.amort.AmortizationMethodText == "IO Only") {
            this._isShowAddFundingSequence = false;
            this.Onchangeamortmethod('#NoteDistributionMethod', 'found');
            this.Onchangeamortmethod('#ReduceAmortizationForCurtailments', 'found');
            this.Onchangeamortmethod('#BusinessDayAdjustmentForAmort', 'found');
        }
        this.showHideGenerateAmortButton();
        if (this._actualAmortMethod != this._deal.amort.AmortizationMethodText) {
            if (this.lstAmortSchedule) {
                this.Amortdialogbox("Changing amortization method will delete all the amortization schedule data.Do you want to proceed.");
            }
        }
        else {
            if (!(this._deal.amort.AmortizationMethod == 623 || this._deal.amort.AmortizationMethodText == "IO Only")) {
                this.getDealAmortizationSchedule();
                this._NoAmortSch = false;
            }
            else {
                if (this.lstAmortSchedule) {
                    this.lstAmortSchedule = null;
                    this._deal.amort.dt = null;
                }
                this._NoAmortSch = true;
                this.amorterrormsg = "There are no amortization records to show based on current amortization setup .";
            }
        }
    };
    DealDetailComponent.prototype.ChangeAmortMethod = function () {
        this.lstAmortSchedule = null;
        this._NoAmortSch = true;
        this._deal.amort.dt = null;
        if (this._actualAmortMethod == this._changedAmortMethod) {
            this._changedAmortMethod = this._actualAmortMethod;
        }
        else if (!(this._actualAmortMethod == this._changedAmortMethod)) {
            this._changedAmortMethod = this._deal.amort.AmortizationMethodText;
        }
        if (this._deal.amort.AmortizationMethod == 623 || this._deal.amort.AmortizationMethodText == "IO Only") {
            this.amorterrormsg = "There are no amortization records to show based on current amortization setup .";
        }
        else {
            this.amorterrormsg = "Please click on Generate Amortization button to generate amortization schedules.";
        }
        setTimeout(function () {
            var modal = document.getElementById('Amortdialogbox');
            modal.style.display = "none";
        }.bind(this), 1000);
    };
    DealDetailComponent.prototype.ReduceAmortizationForCurtailmentsChange = function (newvalue) {
        this._isAmortSchChanges = true;
        this._deal.amort.ReduceAmortizationForCurtailments = newvalue;
    };
    DealDetailComponent.prototype.BusinessDayAdjustmentForAmortChange = function (newvalue) {
        this._isAmortSchChanges = true;
        this._deal.amort.BusinessDayAdjustmentForAmort = newvalue;
    };
    DealDetailComponent.prototype.NoteDistributionMethodChange = function (newvalue) {
        this._isAmortSchChanges = true;
        this._deal.amort.NoteDistributionMethod = newvalue;
    };
    DealDetailComponent.prototype.underwritingStatusChange = function (newvalue) {
        this._deal.UnderwritingStatusid = newvalue;
    };
    DealDetailComponent.prototype.PeriodicStraightChanged = function () {
        this._isAmortSchChanges = true;
    };
    DealDetailComponent.prototype.FixedPeriodicPaymentChanged = function () {
        this._isAmortSchChanges = true;
    };
    DealDetailComponent.prototype.CustomAlert = function (dialog) {
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
    DealDetailComponent.prototype.ok = function () {
        document.getElementById('dialogbox').style.display = "none";
        document.getElementById('dialogoverlay').style.display = "none";
    };
    DealDetailComponent.prototype.CustomDialogteSave = function () {
        var winW = window.innerWidth;
        var winH = window.innerHeight;
        var dialogbox = document.getElementById('Genericdialogbox');
        document.getElementById('savedialogmessage').innerHTML = this.savedialogmsg;
        dialogbox.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    DealDetailComponent.prototype.UseRuledialogbox = function (msg) {
        var winW = window.innerWidth;
        var winH = window.innerHeight;
        var dialogbox = document.getElementById('UseRuledialogbox');
        document.getElementById('userulemessage').innerHTML = msg;
        dialogbox.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    DealDetailComponent.prototype.Amortdialogbox = function (msg) {
        var winW = window.innerWidth;
        var winH = window.innerHeight;
        var dialogbox = document.getElementById('Amortdialogbox');
        document.getElementById('Amortmessage').innerHTML = msg;
        dialogbox.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    //-------------------genric dialog code-------------------------
    DealDetailComponent.prototype.showDialogGeneric = function (controlid) {
        var modalRole = document.getElementById(controlid);
        modalRole.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    DealDetailComponent.prototype.CloseDialogGeneric = function (controlid) {
        this.DialogModulename = "";
        var modal = document.getElementById(controlid);
        modal.style.display = "none";
    };
    DealDetailComponent.prototype.GenricOkButtonClick = function () {
        if (this.DialogModulename == "GenerateFutureFunding") {
            this.generateFutureFunding();
        }
        this.CloseDialogGeneric("myGenericDialog");
    };
    //---------------------------------------
    DealDetailComponent.prototype.convertDatetoGMT = function (date) {
        if (date != null) {
            date = new Date(date);
            var _userOffset = date.getTimezoneOffset() * 60 * 1000; // user's offset time
            var _centralOffset = this._dtUTCHours * 60 * 60 * 1000; // 6 for central time - use whatever you need
            date = new Date(date.getTime() - this._userOffset + this._centralOffset); // redefine variable
            return date;
        }
        else
            return date;
    };
    DealDetailComponent.prototype.convertDatetoGMTGrid = function (Data, modulename) {
        switch (modulename) {
            case "lstNote":
                for (var i = 0; i < Data.length; i++) {
                    if (this.lstNote[i].FirstPaymentDate != null) {
                        this.lstNote[i].FirstPaymentDate = this.convertDatetoGMT(this.lstNote[i].FirstPaymentDate);
                    }
                    if (this.lstNote[i].InitialInterestAccrualEndDate != null) {
                        this.lstNote[i].InitialInterestAccrualEndDate = this.convertDatetoGMT(this.lstNote[i].InitialInterestAccrualEndDate);
                    }
                    if (this.lstNote[i].ClosingDate != null) {
                        this.lstNote[i].ClosingDate = this.convertDatetoGMT(this.lstNote[i].ClosingDate);
                    }
                    if (this.lstNote[i].InitialMaturityDate != null) {
                        this.lstNote[i].InitialMaturityDate = this.convertDatetoGMT(this.lstNote[i].InitialMaturityDate);
                    }
                    if (this.lstNote[i].ExtendedMaturityCurrent != null) {
                        this.lstNote[i].ExtendedMaturityCurrent = this.convertDatetoGMT(this.lstNote[i].ExtendedMaturityCurrent);
                    }
                    if (this.lstNote[i].ExpectedMaturityDate != null) {
                        this.lstNote[i].ExpectedMaturityDate = this.convertDatetoGMT(this.lstNote[i].ExpectedMaturityDate);
                    }
                    if (this.lstNote[i].ActualPayoffDate != null) {
                        this.lstNote[i].ActualPayoffDate = this.convertDatetoGMT(this.lstNote[i].ActualPayoffDate);
                    }
                    if (this.lstNote[i].FullyExtendedMaturityDate != null) {
                        this.lstNote[i].FullyExtendedMaturityDate = this.convertDatetoGMT(this.lstNote[i].FullyExtendedMaturityDate);
                    }
                    if (this.lstNote[i].OpenPrepaymentDate != null) {
                        this.lstNote[i].OpenPrepaymentDate = this.convertDatetoGMT(this.lstNote[i].OpenPrepaymentDate);
                    }
                }
                break;
            case "dealPayruleDealFundingList":
                for (var i = 0; i < Data.length; i++) {
                    if (this._deal.PayruleDealFundingList[i].Date != null) {
                        this._deal.PayruleDealFundingList[i].Date = this.convertDatetoGMT(this._deal.PayruleDealFundingList[i].Date);
                    }
                }
                break;
            case "DealFunding":
                for (var i = 0; i < Data.length; i++) {
                    if (this.listdealfunding[i].Date != null) {
                        this.listdealfunding[i].Date = this.convertDatetoGMT(this.listdealfunding[i].Date);
                    }
                }
                break;
            case "Auto Spread":
                if (Data) {
                    for (var i = 0; i < Data.length; i++) {
                        if (this.lstautospreadrule[i].StartDate != null) {
                            this.lstautospreadrule[i].StartDate = new Date(this.convertDatetoGMT(this.lstautospreadrule[i].StartDate));
                        }
                        if (this.lstautospreadrule[i].EndDate != null) {
                            this.lstautospreadrule[i].EndDate = new Date(this.convertDatetoGMT(this.lstautospreadrule[i].EndDate));
                        }
                    }
                }
                break;
            case "Deal Amortization":
                if (this.lstAmortSchedule) {
                    for (var i = 0; i < this.lstAmortSchedule.length; i++) {
                        if (this.lstAmortSchedule[i].Date != null) {
                            this.lstAmortSchedule[i].Date = new Date(this.convertDatetoGMT(this.lstAmortSchedule[i].Date));
                        }
                    }
                }
                break;
            case "Deal AmortRule":
                if (this.lstNoteListForDealAmort) {
                    for (var i = 0; i < Data.length; i++) {
                        if (this.lstNoteListForDealAmort[i].Maturity != null) {
                            this.lstNoteListForDealAmort[i].Maturity = new Date(this.convertDatetoGMT(this.lstNoteListForDealAmort[i].Maturity));
                        }
                        if (this.lstNoteListForDealAmort[i].ActualPayoffDate != null) {
                            this.lstNoteListForDealAmort[i].ActualPayoffDate = new Date(this.convertDatetoGMT(this.lstNoteListForDealAmort[i].ActualPayoffDate));
                        }
                        if (this.lstNoteListForDealAmort[i].FullyExtendedMaturityDate != null) {
                            this.lstNoteListForDealAmort[i].FullyExtendedMaturityDate = new Date(this.convertDatetoGMT(this.lstNoteListForDealAmort[i].FullyExtendedMaturityDate));
                        }
                        if (this.lstNoteListForDealAmort[i].InitialMaturityDate != null) {
                            this.lstNoteListForDealAmort[i].InitialMaturityDate = new Date(this.convertDatetoGMT(this.lstNoteListForDealAmort[i].InitialMaturityDate));
                        }
                    }
                }
                break;
            case "Total Commitment":
                for (var i = 0; i < Data.length; i++) {
                    if (this.listAdjustedTotalCommitment[i].Date != null) {
                        this.listAdjustedTotalCommitment[i].Date = new Date(this.convertDatetoGMT(this.listAdjustedTotalCommitment[i].Date));
                    }
                }
                break;
            case "FeeInvoice":
                for (var i = 0; i < this.lstFeeInvoice.length; i++) {
                    if (this.lstFeeInvoice[i].CreatedDate != null) {
                        this.lstFeeInvoice[i].CreatedDate = new Date(this.convertDatetoGMT(this.lstFeeInvoice[i].CreatedDate));
                    }
                    if (this.lstFeeInvoice[i].Date != null) {
                        this.lstFeeInvoice[i].Date = new Date(this.convertDatetoGMT(this.lstFeeInvoice[i].Date));
                    }
                }
                break;
            default:
                break;
        }
    };
    DealDetailComponent.prototype.invalidateMain = function () {
        var _this = this;
        this._isListFetching = true;
        localStorage.setItem('ClickedTabId', 'aMain');
        setTimeout(function () {
            _this.flex.invalidate();
            _this.flexPro.invalidate();
            //  this.flexRules.invalidate();
        }, 200);
        setTimeout(function () {
            _this._isListFetching = false;
        }, 1000);
    };
    DealDetailComponent.prototype.invalidateDealAmorttab = function () {
        var _this = this;
        this._isListFetching = true;
        this.ValidateAmort();
        if (!this.isAmortFirstLoad) {
            this.GetNoteDetailForDealAmortByDealID(this._deal);
        }
        this._deal.Flag_DealAmortSave = true;
        localStorage.setItem('ClickedTabId', 'aDealAmorttab');
        setTimeout(function () {
            _this._isListFetching = false;
        }, 1000);
    };
    DealDetailComponent.prototype.GetDefaultValue = function (val) {
        if (isNaN(val) || val == null) {
            return 0;
        }
        return val;
    };
    DealDetailComponent.prototype.downloadNoteCashflowsExportData = function (item) {
        var _this = this;
        if (this._CritialExceptionListCount > 0) {
            this.CustomAlert(this._CritialExceptionAlert);
        }
        else {
            this._isListFetching = true;
            var downloadCashFlow = new note_1.DownloadCashFlow();
            // this._note = new Note('');
            downloadCashFlow.NoteId = "00000000-0000-0000-0000-000000000000";
            downloadCashFlow.DealID = this._deal.DealID;
            downloadCashFlow.AnalysisID = item.AnalysisID;
            this.ScenarioName = item.ScenarioName;
            downloadCashFlow.MutipleNoteId = '';
            downloadCashFlow.TransactionCategoryName = 'Default';
            downloadCashFlow.Pagename = "Deal";
            var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '-');
            var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '-');
            var fileName = this._deal.CREDealID + "_" + this.ScenarioName + "_Cashflow_" + displayDate + "_" + displayTime + ".xlsx";
            this.noteSrv.getNoteCashflowsExportData(downloadCashFlow).subscribe(function (res) {
                var b = new Blob([res]);
                var dwldLink = document.createElement("a");
                var url = URL.createObjectURL(b);
                var isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
                if (isSafariBrowser) { //if Safari open in new window to save file with random filename.
                    dwldLink.setAttribute("target", "_blank");
                }
                dwldLink.setAttribute("href", url);
                dwldLink.setAttribute("download", fileName);
                dwldLink.style.visibility = "hidden";
                document.body.appendChild(dwldLink);
                dwldLink.click();
                document.body.removeChild(dwldLink);
                _this._isListFetching = false;
            });
        }
    };
    DealDetailComponent.prototype.downloadFile = function (objArray) {
        this._user = JSON.parse(localStorage.getItem('user'));
        var data = this.ConvertToCSV(objArray);
        var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '-');
        var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '-');
        //var fileName = "Cashflow_" + window.localStorage.getItem("ScenarioName") + "_" + displayDate + "_" + displayTime + "_" + this._user.Login + ".csv";
        var fileName = this._deal.CREDealID + "_" + this.ScenarioName + "_Cashflow_" + displayDate + "_" + displayTime + ".csv";
        var blob = new Blob(['\ufeff' + data], { type: 'text/csv;charset=utf-8;' });
        var dwldLink = document.createElement("a");
        var url = URL.createObjectURL(blob);
        var isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
        if (isSafariBrowser) { //if Safari open in new window to save file with random filename.
            dwldLink.setAttribute("target", "_blank");
        }
        dwldLink.setAttribute("href", url);
        dwldLink.setAttribute("download", fileName);
        dwldLink.style.visibility = "hidden";
        document.body.appendChild(dwldLink);
        dwldLink.click();
        document.body.removeChild(dwldLink);
    };
    // convert Json to CSV data in Angular2
    DealDetailComponent.prototype.ConvertToCSV = function (objArray) {
        var array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
        var str = '';
        var row = "";
        for (var index in objArray[0]) {
            //Now convert each value to string and comma-separated
            row += index + ',';
        }
        row = row.slice(0, -1);
        //append Label row with line break
        str += row + '\r\n';
        for (var i = 0; i < array.length; i++) {
            var line = '';
            for (var index in array[i]) {
                if (line != '')
                    line += ',';
                line += array[i][index];
            }
            str += line + '\r\n';
        }
        return str;
    };
    // add a footer row to display column aggregates below the data
    DealDetailComponent.prototype.addFooterRow = function (flexGrid) {
        var row = new wjcGrid.GroupRow(); // create a GroupRow to show aggregates
        flexGrid.columnFooters.rows.push(row); // add the row to the column footer panel
        flexGrid.bottomLeftCells.setCellData(0, 0, '\u03A3');
        // sigma on the header       
    };
    DealDetailComponent.prototype.fundingaddFooterRow = function (flexGrid) {
        var _this = this;
        flexGrid.columnFooters.rows.push(new wjcGrid.GroupRow());
        flexGrid.columnFooters.rows.defaultSize = 60;
        //  setTimeout(function () {s
        flexGrid.formatItem.addHandler(function (s, e) {
            _this._ShowmessagedivWar = false;
            if (s.columnFooters === e.panel && e.row === 0 && e.col === 3) {
                if (s.collectionView) {
                    var items = s.collectionView.items;
                    if (items) {
                        var positiveItems = items.filter(function (i) { return i.Value >= 0; });
                        var negativeItems = items.filter(function (i) { return i.Value < 0; });
                        var positiveVal = wjcCore.getAggregate(wjcCore.Aggregate.Sum, positiveItems, 'Value');
                        var negativeVal = wjcCore.getAggregate(wjcCore.Aggregate.Sum, negativeItems, 'Value');
                        var positiveSum = wjcCore.Globalize.formatNumber(positiveVal, 'n2');
                        var negativeSum = wjcCore.Globalize.formatNumber(negativeVal, 'n2');
                        var TotaSum1 = parseFloat(positiveVal) + parseFloat(negativeVal);
                        var TotaSum = wjcCore.Globalize.formatNumber(TotaSum1, 'n2');
                        e.cell.innerHTML = "Funding: " + positiveSum + "<br>Repayment: " + negativeSum + "<br><u><b>Total: " + TotaSum + "</b></u>";
                        // e.cell.innerHTML = "Funding: <font color= `darkgreen`>"+${positiveSum}+"</font><br>Repayment: <font color=`red`>"+${negativeSum}+"</font>";
                    }
                }
            }
        });
    };
    DealDetailComponent.prototype.dealfundingselectionChanged = function () {
        this.AppliedReadOnly();
    };
    DealDetailComponent.prototype.Copieddealfunding = function (flexdefunding, e) {
        var _this = this;
        this._isdealfundingChanged = false;
        var sel = this.flexdealfunding.selection;
        var _lstUseRuleN = this.lstSequenceHistory.filter(function (x) { return x.UseRuletoDetermineNoteFundingText == "4" || x.UseRuletoDetermineNoteFundingText == "N" || x.UseRuletoDetermineNoteFundingText == null || x.UseRuletoDetermineNoteFundingText == ""; });
        //if (this._deal.EnableAutoSpread || this.repaymentchecked == true) {
        //    if (_lstUseRuleN.length != this.lstNote.length) {
        //        flexdefunding.autoClipboard = false;
        //    } {
        //        flexdefunding.autoClipboard = true;
        //    }
        //}
        // else {
        var maxappliedDate = new Date(Math.max.apply(null, this.listdealfunding.filter(function (x) { return x.OrgApplied == true; }).map(function (x) { return x.orgDate; })));
        if (this.ShowUseRuleN == false) {
            //   this._isdealfundingChanged = false;
            this._isdealfundingEdit = false;
        }
        var errorMessage = "<p>" + 'Dates earlier than last wire confirmation (' + this.convertDateToBindable(maxappliedDate) + ') are not allowed. Please correct the ';
        var errorAmount = "<p>" + "Funding amount can't have more than 2 decimal places. System has rounded the inputs to 2 decimal places. " + "</p>";
        var errordate = "";
        this._isdatavalid = true;
        var isAmountvalid = true;
        var errorMessageFF5per = "<p>" + "You have increased the draw amount more than 5% for the funding date(s) - ";
        var errorMessageFF5perDates = "";
        var isValiderror = true;
        var rowcnt = 0, cnt = 0, deccount = 0, drowcnt = 0;
        this.ConvertpastedBindableDate(this.listdealfunding);
        //reset previous Amount if user not belong to current flow for funding
        //for (var tprow = sel.topRow; tprow <= sel.bottomRow - rowcnt; tprow++) {
        //    if (this.listdealfunding[tprow].wf_isUserCurrentFlow == 0) {
        //        this.listdealfunding[tprow].Value = this.listdealfunding[tprow].orgValue;
        //    }
        //}
        if (maxappliedDate && maxappliedDate.toString() != "Invalid Date") {
            for (var tprow = sel.topRow; tprow <= sel.bottomRow - rowcnt; tprow++) {
                //For New values while paste
                if (this.flexdealfunding.rows[tprow].dataItem.WF_IsFlowStart == undefined) {
                    this.listdealfunding[tprow].Applied = false;
                    this.flexdealfunding.rows[tprow].isReadOnly = false;
                    this.flexdealfunding.rows[tprow].cssClass = "customgridrowcolornotapplied";
                }
                //For update values while paste
                if (this.listdealfunding[tprow].OrgApplied == false) {
                    if (this._deal.EnableAutoSpread) {
                        if (this.listdealfunding[tprow].Comment == "") {
                            this.listdealfunding[tprow].Date = new Date(this.convertDateToBindable(this.listdealfunding[tprow].orgDate));
                            this.listdealfunding[tprow].Value = this.listdealfunding[tprow].orgValue;
                            this.listdealfunding[tprow].PurposeID = this.listdealfunding[tprow].orgPurposeID;
                            this.listdealfunding[tprow].PurposeText = this.listdealfunding[tprow].OrgPurposeText;
                        }
                    }
                    if (this.listdealfunding[tprow].Date < maxappliedDate) {
                        this._isdatavalid = false;
                        isValiderror = false;
                        errorMessage += this.listdealfunding[tprow].Date.toLocaleDateString("en-US") + ', ';
                        this.listdealfunding[tprow].Date = new Date(this.convertDateToBindable(this.listdealfunding[tprow].orgDate));
                        this.listdealfunding[tprow].Value = this.listdealfunding[tprow].orgValue;
                        this.listdealfunding[tprow].PurposeID = this.listdealfunding[tprow].orgPurposeID;
                        this.listdealfunding[tprow].PurposeText = this.listdealfunding[tprow].OrgPurposeText;
                        this.listdealfunding[tprow].DrawFundingId = "";
                        this.listdealfunding[tprow]["isValidDate"] = true;
                        //cnt += 1;
                    }
                    this.listdealfunding[tprow].Applied = false;
                    this.flexdealfunding.rows[tprow].cssClass = "customgridrowcolornotapplied";
                    this.flexdealfunding.rows[tprow].isReadOnly = false;
                    //reset previous Amount if user not belong to current flow for funding
                    //if (this.listdealfunding[tprow].wf_isUserCurrentFlow == 0) {
                    //    this.listdealfunding[tprow].Value = this.listdealfunding[tprow].orgValue;
                    //}
                    var Amtdec = this.listdealfunding[tprow].Value;
                    if (Amtdec == undefined) {
                        Amtdec = 0;
                    }
                    if (Math.floor(Amtdec) === Amtdec) {
                        deccount = 0;
                    }
                    else {
                        if ((Amtdec % 1) != 0) {
                            deccount = Amtdec.toString().split(".")[1].length || 0;
                        }
                    }
                    if (deccount > 2) {
                        this.listdealfunding[tprow].Value = parseFloat(this.listdealfunding[tprow].Value).toFixed(2);
                        //    errorAmount += Amtdec + ', ';
                        isAmountvalid = false;
                    }
                }
                //For new values while pasted
                if (this.flexdealfunding.rows[tprow].dataItem.OrgApplied == undefined) {
                    if (this.flexdealfunding.rows[tprow].dataItem.Date < maxappliedDate) {
                        isValiderror = false;
                        errorMessage += this.flexdealfunding.rows[tprow].dataItem.Date.toLocaleDateString("en-US") + ', ';
                        var delrow = this.flexdealfunding.rows[tprow];
                        this.flexdealfunding.rows.remove(delrow);
                        this.listdealfunding.splice(tprow, 1);
                        this._isdatavalid = false;
                        tprow -= 1;
                        rowcnt += 1;
                    }
                    else {
                        var Amtdec = this.listdealfunding[tprow].Value;
                        if (Amtdec == undefined) {
                            Amtdec = 0;
                        }
                        if (Math.floor(Amtdec) === Amtdec) {
                            deccount = 0;
                        }
                        else {
                            if ((Amtdec % 1) != 0) {
                                //   if (Amtdec) {
                                // var deccnt = Amtdec.toString().split(".")[1];
                                deccount = Amtdec.toString().split(".")[1].length || 0;
                            }
                        }
                        if (deccount > 2) {
                            this.listdealfunding[tprow].Value = parseFloat(this.listdealfunding[tprow].Value).toFixed(2);
                            //  errorAmount += Amtdec + ', ';
                            isAmountvalid = false;
                        }
                        if (this.listdealfunding[tprow].Applied != undefined) {
                            if (this.listdealfunding[tprow].Applied != false && this.listdealfunding[tprow].Applied != true) {
                                this.listdealfunding[tprow].Applied = this.listdealfunding[tprow].Applied.toLowerCase() == 'true' ? true : false;
                            }
                        }
                    }
                }
            }
        }
        var rowcnt = 0, cnt = 0, deccount = 0, drowcnt = 0;
        for (var tprow = sel.topRow; tprow <= sel.bottomRow - drowcnt; tprow++) {
            if (this.listdealfunding[tprow] !== undefined) {
                if (this.listdealfunding[tprow].Applied == false) {
                    var sdate = this.listdealfunding[tprow].Date;
                    if (!(sdate === undefined) && sdate != '') {
                        var formateddate = this.convertDateToBindable(sdate);
                        var dealfundingday = sdate.getDay();
                        if (dealfundingday == 6 || dealfundingday == 0
                            || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411; }).length > 0) {
                            this.listdealfunding[tprow]["isValidDate"] = false;
                            //this.flexdealfunding.invalidate();
                            //this.flexdealfunding.rows[tprow].cssClass = "customgridColHalidayDate";
                            this._isvalidateHolidaySatSun = false;
                            errordate += this.convertDateToBindable(sdate) + ", ";
                        }
                        else {
                            this.listdealfunding[tprow]["isValidDate"] = true;
                            if (this.flexdealfunding.rows[tprow].dataItem.WF_IsCompleted == 1 && this.flexdealfunding.rows[tprow].dataItem.Applied == false)
                                this.flexdealfunding.rows[tprow].cssClass = "customgridWFcolor";
                            else
                                this.flexdealfunding.rows[tprow].cssClass = "customgridrowcolornotapplied";
                        }
                    }
                    if ((this.listdealfunding[tprow].WF_CurrentStatus == "1st Approval" ||
                        this.listdealfunding[tprow].WF_CurrentStatus == "2nd Approval") && this.listdealfunding[tprow].Value != this.originallistdealfunding[tprow].Value) {
                        if (errorMessageFF5perDates.indexOf(this.convertDateToBindable(this.listdealfunding[tprow].Date)) < 0) {
                            var msgdt = this.ChangeFundingAmountCopied(tprow);
                            if (msgdt != '') {
                                errorMessageFF5perDates = errorMessageFF5perDates + ', ' + this.ChangeFundingAmountCopied(tprow);
                            }
                        }
                    }
                }
                //this.listdealfunding[tprow].Applied = false;
                if (this.listdealfunding[tprow].OrgApplied == undefined) {
                    var sdate = this.listdealfunding[tprow].Date;
                    if (!(sdate === undefined) && sdate != '') {
                        var formateddate = this.convertDateToBindable(sdate);
                        var dealfundingday = sdate.getDay();
                        if (dealfundingday == 6 || dealfundingday == 0 || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411; }).length > 0) {
                            this.listdealfunding[tprow]["isValidDate"] = false;
                            this._isvalidateHolidaySatSun = false;
                            //this.flexdealfunding.invalidate();
                            //this.flexdealfunding.rows[tprow].cssClass = "customgridColHalidayDate";
                            errordate += this.convertDateToBindable(sdate) + ", ";
                        }
                        else {
                            this.listdealfunding[tprow]["isValidDate"] = true;
                            if (this.flexdealfunding.rows[tprow].dataItem.WF_IsCompleted == 1 && this.flexdealfunding.rows[tprow].dataItem.Applied == false)
                                this.flexdealfunding.rows[tprow].cssClass = "customgridWFcolor";
                            else
                                this.flexdealfunding.rows[tprow].cssClass = "customgridrowcolornotapplied";
                        }
                    }
                }
            }
        }
        if (isValiderror)
            errorMessage = '';
        if (!isAmountvalid) {
            errorMessage = errorMessage + errorAmount;
        }
        if (errorMessageFF5perDates != "") {
            errorMessageFF5perDates = errorMessageFF5perDates.slice(1, errorMessageFF5perDates.length);
            errorMessage = errorMessage + errorMessageFF5per + errorMessageFF5perDates + ". It will reset the status to Under Review.</p>";
        }
        if (!this._isvalidateHolidaySatSun) {
            this._isvalidateHolidaySatSun = true;
            errorMessage = errorMessage + "<p>" + "You have entered a funding date (" + errordate.slice(0, errordate.length - 2) + ") which is either on holiday or weekend. Please enter different date." + "</p>";
        }
        if (!this._isdatavalid || !isAmountvalid || errorMessageFF5perDates != "" || !this._isvalidateHolidaySatSun) {
            this.CustomAlert(errorMessage);
        }
        else if (!this._isvalidateHolidaySatSun) {
            this.CustomAlert("You have entered a funding date which is either on holiday or weekend. Please enter different date");
        }
        this.AppliedReadOnly();
        // var _lstUseRuleN = this.lstSequenceHistory.filter(x => x.UseRuletoDetermineNoteFundingText == "4" || x.UseRuletoDetermineNoteFundingText == "N" || x.UseRuletoDetermineNoteFundingText == null || x.UseRuletoDetermineNoteFundingText == "");
        if (_lstUseRuleN.length == this.lstNote.length) {
            if (!(this.listdealfunding[e.row].PurposeText == undefined)) {
                this.syncDealfundingandTotalcommitmentlistforNnotes(this.listdealfunding);
            }
        }
        //update values in n deals on copypaste
        if (this.ShowUseRuleN == true || this._deal.ApplyNoteLevelPaydowns) {
            this.UpdateNoteFundingOnCopyPaste();
        }
        // }
        //For Use Rule N only
        if (_lstUseRuleN.length == this.lstNote.length) {
            for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
                var totalamt = 0;
                //if (sel.leftCol > 11) {
                var changedata = this.lstNoteFunding.filter(function (x) { return x.PurposeID == _this.listdealfunding[tprow].PurposeID && _this.convertDateToBindable(x.Date) == _this.convertDateToBindable(_this.listdealfunding[tprow].Date) && x.DealFundingRowno == _this.listdealfunding[tprow].DealFundingRowno; });
                var dealfundingcolumns = Object.keys(this.listdealfunding[tprow]);
                for (var n = 0; n < this.lstNote.length; n++) {
                    if (dealfundingcolumns.includes(this.lstNote[n].Name)) {
                        if (this.listdealfunding[tprow][this.lstNote[n].Name]) {
                            totalamt += parseFloat(this.listdealfunding[tprow][this.lstNote[n].Name]);
                            //  var changedata = this.lstNoteFunding.filter(x => x.PurposeID == this.listdealfunding[tprow].PurposeID && this.convertDateToBindable(x.Date) == this.convertDateToBindable(this.listdealfunding[tprow].Date) && x.DealFundingRowno == this.listdealfunding[tprow].DealFundingRowno);
                            var sNoteFunding = this.lstNoteFunding.filter(function (c) { return c.DealFundingRowno == _this.listdealfunding[tprow].DealFundingRowno && c.NoteName == _this.lstNote[n].Name; });
                            if (sNoteFunding.length > 0) {
                                this.lstNoteFunding.find(function (c) { return c.DealFundingRowno == _this.listdealfunding[tprow].DealFundingRowno && c.NoteName == _this.lstNote[n].Name; }).Value = parseFloat(this.listdealfunding[tprow][this.lstNote[n].Name]);
                                this.lstNoteFunding.find(function (c) { return c.DealFundingRowno == _this.listdealfunding[tprow].DealFundingRowno && c.NoteName == _this.lstNote[n].Name; }).Comment = this.listdealfunding[tprow].Comment;
                                //sNoteFunding.orgValue = parseFloat(this.listdealfunding[tprow][this.lstNote[n].Name]);
                            }
                            else {
                                this.lstNoteFunding.push({
                                    "Applied": false,
                                    "NoteName": this.lstNote[n].Name,
                                    "Value": parseFloat(this.listdealfunding[tprow][this.lstNote[n].Name]),
                                    "DealFundingRowno": this.listdealfunding[tprow].DealFundingRowno,
                                    "GeneratedBy": 746,
                                    "NoteID": this.lstNote.find(function (x) { return x.Name == _this.lstNote[n].Name; }).NoteId,
                                    "Comment": this.listdealfunding[tprow].Comment,
                                    "PurposeID": this.listdealfunding[tprow].PurposeID,
                                    "Date": this.convertDatetoGMT(this.listdealfunding[tprow].Date),
                                    "Comments": this.listdealfunding[tprow].Comments
                                });
                            }
                        }
                    }
                }
                // }
                this.listdealfunding[tprow].Value = totalamt;
            }
            this.flexdealfunding.invalidate();
        }
        if (this._isAdjustedTotalCommitmentTabClicked == true) {
            this.CopiedEquitySummaryforFunding();
            this.getEquityValues();
        }
    };
    DealDetailComponent.prototype.CopiedEquitySummaryforFunding = function () {
        if (this._lstEquitySummary.length > 0) {
            var sTotalRequiredEquityFunding = 0;
            var sTotalAdditionalEquityFunding = 0;
            if (this.cvDealFundingList) {
                for (var i = 0; i < this.cvDealFundingList.items.length; i++) {
                    if (this.cvDealFundingList.items[i].Date <= this._currentDate) {
                        if (this.cvDealFundingList.items[i].RequiredEquity) {
                            if (this.cvDealFundingList.items[i].RequiredEquity != undefined || this.cvDealFundingList.items[i].RequiredEquity != "" || this.cvDealFundingList.items[i].RequiredEquity != null) {
                                sTotalRequiredEquityFunding = sTotalRequiredEquityFunding + parseFloat(this.cvDealFundingList.items[i].RequiredEquity);
                            }
                        }
                    }
                }
                for (var i = 0; i < this.cvDealFundingList.items.length; i++) {
                    if (this.cvDealFundingList.items[i].Date <= this._currentDate) {
                        if (this.cvDealFundingList.items[i].AdditionalEquity) {
                            if (this.cvDealFundingList.items[i].AdditionalEquity != undefined || this.cvDealFundingList.items[i].AdditionalEquity != "" || this.cvDealFundingList.items[i].AdditionalEquity != null) {
                                sTotalAdditionalEquityFunding = sTotalAdditionalEquityFunding + parseFloat(this.cvDealFundingList.items[i].AdditionalEquity);
                            }
                        }
                    }
                }
            }
            for (var h = 0; h < this._lstEquitySummary.length; h++) {
                if (this._lstEquitySummary[h].Type == "FF Required Equity") {
                    this._lstEquitySummary[h]["EquityContributedToDate"] = sTotalRequiredEquityFunding;
                    this._lstEquitySummary[h]["RemainingEquity"] = this._lstEquitySummary[h]["ExpectedEquity"] - sTotalRequiredEquityFunding;
                    if (sTotalRequiredEquityFunding == 0 || this._lstEquitySummary[h]["ExpectedEquity"] == 0) {
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = 0.00 + "%";
                    }
                    else {
                        var FundingPerContributedToDate_req = sTotalRequiredEquityFunding / this._lstEquitySummary[h]["ExpectedEquity"] * 100;
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = parseFloat(FundingPerContributedToDate_req.toString()).toFixed(2) + "%";
                    }
                }
            }
            for (var h = 0; h < this._lstEquitySummary.length; h++) {
                if (this._lstEquitySummary[h].Type == "FF Additional Equity") {
                    this._lstEquitySummary[h]["EquityContributedToDate"] = sTotalAdditionalEquityFunding;
                    this._lstEquitySummary[h]["RemainingEquity"] = this._lstEquitySummary[h]["ExpectedEquity"] - sTotalAdditionalEquityFunding;
                    if (sTotalAdditionalEquityFunding == 0 || this._lstEquitySummary[h]["ExpectedEquity"] == 0) {
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = 0.00 + "%";
                    }
                    else {
                        var FundingPerContributedToDate_add = sTotalAdditionalEquityFunding / this._lstEquitySummary[h]["ExpectedEquity"] * 100;
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = parseFloat(FundingPerContributedToDate_add.toString()).toFixed(2) + "%";
                    }
                }
            }
            var TotalExpectedEquity = 0;
            var TotalEquityContributedToDate = 0;
            this._lstEquitySummary.forEach(function (item) {
                if (item.Type != "Total Equity") {
                    TotalExpectedEquity += Number(item.ExpectedEquity);
                    TotalEquityContributedToDate += Number(item.EquityContributedToDate);
                }
            });
            for (var h = 0; h < this._lstEquitySummary.length; h++) {
                if (this._lstEquitySummary[h].Type == "Total Equity") {
                    this._lstEquitySummary[h]["ExpectedEquity"] = TotalExpectedEquity;
                    this._lstEquitySummary[h]["EquityContributedToDate"] = TotalEquityContributedToDate;
                    this._lstEquitySummary[h]["RemainingEquity"] = TotalExpectedEquity - TotalEquityContributedToDate;
                    if (TotalExpectedEquity == 0) {
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = 0.00 + "%";
                    }
                    else {
                        var TotalPerContributedToDate = TotalEquityContributedToDate / TotalExpectedEquity * 100;
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = parseFloat(TotalPerContributedToDate.toString()).toFixed(2) + "%";
                    }
                }
            }
            this._lstEquitySummary = this._lstEquitySummary;
            this.Equitygrid.invalidate();
        }
    };
    DealDetailComponent.prototype.UpdateNoteFundingOnCopyPaste = function () {
        var _this = this;
        if (this.ShowUseRuleN == true || this._deal.ApplyNoteLevelPaydowns) {
            this.lstNoteFunding = [];
            var griddata = this.cvDealFundingList.sourceCollection;
            for (var df = 0; df < griddata.length; df++) {
                griddata[df].DealFundingRowno = df + 1;
                if (this.lstNote[0] != null) {
                    for (var val = 0; val < this.lstSequenceHistory.length; val++) {
                        var newlist = new deals_1.Notefunding;
                        newlist.NoteID = this.lstNote[val].NoteId;
                        newlist.NoteName = this.lstNote[val].Name;
                        if (griddata[df][this.lstSequenceHistory[val].Name] == null || griddata[df][this.lstSequenceHistory[val].Name] == undefined) {
                            newlist.Value = "0";
                        }
                        else {
                            newlist.Value = griddata[df][this.lstSequenceHistory[val].Name];
                        }
                        newlist.Date = griddata[df].Date;
                        newlist.isDeleted = 0;
                        newlist.Applied = griddata[df].Applied;
                        newlist.Comments = griddata[df].Comment;
                        newlist.DealFundingRowno = griddata[df].DealFundingRowno;
                        newlist.PurposeID = griddata[df].PurposeID;
                        newlist.Purpose = griddata[df].PurposeText;
                        this.lstNoteFunding.push(newlist);
                    }
                }
            }
            for (var df = 0; df < this.lstNoteFunding.length; df++) {
                if (!(Number(this.lstNoteFunding[df].Purpose).toString() == "NaN" || Number(this.lstNoteFunding[df].Purpose) == 0)) {
                    this.lstNoteFunding[df].PurposeID = Number(this.lstNoteFunding[df].Purpose);
                    this.lstNoteFunding[df].Purpose = this.lstPurposeType.find(function (x) { return x.LookupID == Number(_this.lstNoteFunding[df].PurposeID); }).Name;
                }
                if (this.lstNoteFunding[df].Date != null) {
                    this.lstNoteFunding[df].Date = this.convertDateToBindable(this.lstNoteFunding[df].Date);
                }
            }
        }
    };
    DealDetailComponent.prototype.AppliedReadOnly = function () {
        if (this.listdealfunding) {
            for (var i = 0; i <= (this.listdealfunding.length - 1); i++) {
                if (this.flexdealfunding.rows[i]) {
                    if (this.flexdealfunding.rows[i].dataItem.Applied == true) {
                        if (this.flexdealfunding.rows[i]) {
                            this.flexdealfunding.rows[i].isReadOnly = true;
                            this.flexdealfunding.rows[i].cssClass = "customgridrowcolor";
                        }
                    }
                    if (this.flexdealfunding.rows[i].dataItem.WF_IsCompleted == 1 && this.flexdealfunding.rows[i].dataItem.Applied == false) {
                        if (this.flexdealfunding.rows[i]) {
                            this.flexdealfunding.rows[i].isReadOnly = true;
                            this.flexdealfunding.rows[i].cssClass = "customgridWFcolor";
                        }
                    }
                }
            }
        }
    };
    DealDetailComponent.prototype.deletedealfunding = function (e) {
        e.cancel = true;
        this.AppliedReadOnly();
        var _lstUseRuleN = this.lstSequenceHistory.filter(function (x) { return x.UseRuletoDetermineNoteFundingText == "4" || x.UseRuletoDetermineNoteFundingText == "N" || x.UseRuletoDetermineNoteFundingText == null || x.UseRuletoDetermineNoteFundingText == ""; });
        if (_lstUseRuleN.length == this.lstNote.length) {
            if (!(this.listdealfunding[e.row].PurposeText == undefined)) {
                this.syncDealfundingandTotalcommitmentlistforNnotes(this.listdealfunding);
            }
        }
    };
    DealDetailComponent.prototype.Addnewfunding = function (flexdefunding, e) {
        if (e.col.toString() == this.dealfundingColPositionWire) {
            this.CustomAlert("Please enter Date or Amount before checking Wire confirm.");
            e.cancel = true;
        }
        var currentrownumber = 0;
        //manish
        this.listdealfunding[e.row].GeneratedBy = 746;
        this.listdealfunding[e.row].GeneratedByText = this.lstGeneratedBy.find(function (x) { return x.LookupID == 746; }).Name;
        //assgin rownumber
        var maxrownumber = 0;
        for (var n1 = 0; n1 < this.listdealfunding.length; n1++) {
            if (this.listdealfunding[n1].DealFundingRowno !== undefined && this.listdealfunding[n1].DealFundingRowno != null) {
                if (this.listdealfunding[n1].DealFundingRowno > maxrownumber) {
                    maxrownumber = this.listdealfunding[n1].DealFundingRowno;
                }
            }
        }
        this.listdealfunding[e.row].DealFundingRowno = maxrownumber + 1;
        currentrownumber = this.listdealfunding[e.row].DealFundingRowno;
        var lstUseN = this.lstSequenceHistory.filter(function (x) { return x.UseRuletoDetermineNoteFundingText == "3" || x.UseRuletoDetermineNoteFundingText == "Y"; });
        if (lstUseN.length > 0) {
            for (var j1 = 0; j1 < lstUseN.length; j1++) {
                this.lstNoteFunding.push({ "Applied": false, "NoteName": lstUseN[j1].Name, "Value": 0, "DealFundingRowno": this.listdealfunding[e.row].DealFundingRowno, "GeneratedBy": 746, "NoteID": lstUseN[j1].NoteID });
            }
        }
        if (lstUseN.length == 0) {
            for (var j2 = 0; j2 < this.lstSequenceHistory.length; j2++) {
                this.lstNoteFunding.push({ "Applied": false, "NoteName": this.lstSequenceHistory[j2].Name, "Value": 0, "DealFundingRowno": this.listdealfunding[e.row].DealFundingRowno, "GeneratedBy": 746, "NoteID": this.lstSequenceHistory[j2].NoteID });
                this.listdealfunding[e.row][this.lstSequenceHistory[j2].Name] = 0;
            }
        }
    };
    DealDetailComponent.prototype.celleditfundingRule = function (flexDynamicColForSequence, e) {
        var Funddec = 0, prevFunddec = 0, deccount = 0;
        this._isFundingruleChanged = false;
        if (e.col > 13) {
            Funddec = this.grdflexDynamicColForSequence.getCellData(e.row, e.col, false);
            prevFunddec = this.grdflexDynamicColForSequence.getCellData(e.row, e.col, true);
            if (Funddec > 0) {
                if (Math.floor(Funddec) === Funddec) {
                    deccount = 0;
                }
                else {
                    if ((Funddec % 1) != 0) {
                        deccount = Funddec.toString().split(".")[1].length || 0;
                    }
                }
            }
            if (deccount > 2) {
                this.grdflexDynamicColForSequence.setCellData(e.row, e.col, prevFunddec, true);
                this.CustomAlert("Funding and Repayments can't have more than 2 decimal places. System has rounded the inputs to 2 decimal places");
                this.grdflexDynamicColForSequence.select(e.row, e.col - 1);
                this.grdflexDynamicColForSequence.focus();
                return;
            }
        }
        //For Use Rule N
        if (e.col == 10) {
            var lstUseN = this.lstSequenceHistory.filter(function (x) { return x.UseRuletoDetermineNoteFundingText == "3" || x.UseRuletoDetermineNoteFundingText == "Y"; });
            if (lstUseN.length > 0) {
                var objdeal = new deals_1.deals('');
                objdeal.ShowUseRuleN = false;
                this.ShowUseRuleN = false;
                this._isautospreadshow = true;
                this._isautospreadRepaymentshow = false;
                this._isshowApplyNoteLevelPaydowns = false;
                if (this._deal.EnableAutoSpread == true) {
                    this.checked = true;
                    this.ConvertToBindableDateAutoSpread(this.lstautospreadrule);
                    this.autospreadrulelist = new wjcCore.CollectionView(this.lstautospreadrule);
                    this.autospreadrulelist.trackChanges = true;
                    this.flexautospreadrule.invalidate();
                }
            }
            //For Use rule to determine note N
            var lstUseRuleN = this.lstSequenceHistory.filter(function (x) { return x.UseRuletoDetermineNoteFundingText == "3" || x.UseRuletoDetermineNoteFundingText == "Y"; });
            if (lstUseRuleN.length == 0) {
                var objdeal = new deals_1.deals('');
                objdeal.DealID = this._deal.DealID;
                objdeal.ShowUseRuleN = true;
                this.ShowUseRuleN = true;
                this._isshowApplyNoteLevelPaydowns = true;
                this.noteFundingId = flexDynamicColForSequence.rows[e.row].dataItem.NoteID;
                this.UseRuledialogbox("Changing all notes to 'Use rule to determine note funding' as 'N' will make them editable. Do you want to proceed?");
            }
            else {
                //For Use rule to determine note Y
                var lstUseRuleY = this.lstSequenceHistory.filter(function (x) { return x.UseRuletoDetermineNoteFundingText == "4" || x.UseRuletoDetermineNoteFundingText == "N"; });
                if (lstUseRuleY.length == 0) {
                    var objdeal = new deals_1.deals('');
                    objdeal.DealID = this._deal.DealID;
                    objdeal.ShowUseRuleN = false;
                    this.ShowUseRuleN = false;
                    this._isautospreadshow = true;
                    this._isautospreadRepaymentshow = false;
                    this._isshowApplyNoteLevelPaydowns = true;
                    // this.GetDealFundingByDealID(objdeal);
                    for (var i = 0; i <= (this.listdealfunding.length - 1); i++) {
                        if (this.listdealfunding[i].Applied == false) {
                            if (this.flexdealfunding.rows[i]) {
                                for (var j = 10; j <= this.flexdealfunding.columns.length; j++) {
                                    if (this.flexdealfunding.columns[j]) {
                                        this.flexdealfunding.columns[j].isReadOnly = true;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        //adjustment total commitment
        if (e.col == 7) {
            for (var i = 0; i < this.lstSequenceHistory.length; i++) {
                this.lstSequenceHistory[i].AggregatedTotal = this.lstSequenceHistory[i].TotalCommitment + this.lstSequenceHistory[i].AdjustedTotalCommitment;
            }
        }
    };
    DealDetailComponent.prototype.CopyGridDataWithHeader = function (s, e) {
        // get clip text
        var text = s.getClipString();
        // add headers
        var sel = s.selection, hdr = '';
        for (var c = sel.leftCol; c <= sel.rightCol; c++) {
            if (hdr)
                hdr += '\t';
            hdr += s.columns[c].header;
        }
        text = hdr + '\r\n' + text;
        wjcCore.Clipboard.copy(text);
        e.cancel = true;
    };
    DealDetailComponent.prototype.Copiedfundingrule = function (flexdefunding, e) {
        if (e.col > 11) {
            this._isFundingruleChanged = true;
            var sel = this.grdflexDynamicColForSequence.selection;
            var deccount = 0, isvalidAmt = true, prevFunddec = 0, Amtdec = 0;
            for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
                Amtdec = this.grdflexDynamicColForSequence.getCellData(tprow, e.col, false);
                prevFunddec = this.grdflexDynamicColForSequence.getCellData(tprow, e.col, true);
                if (Math.floor(Amtdec) === Amtdec) {
                    deccount = 0;
                }
                else {
                    if ((Amtdec % 1) != 0) {
                        deccount = Amtdec.toString().split(".")[1].length || 0;
                    }
                }
                if (deccount > 2) {
                    this.grdflexDynamicColForSequence.setCellData(tprow, e.col, prevFunddec, true);
                    isvalidAmt = false;
                }
            }
            if (!isvalidAmt) {
                this.CustomAlert("Funding and Repayments can't have more than 2 decimal places. System has rounded the inputs to 2 decimal places");
            }
        }
        //For Use Rule N
        if (e.col == 10) {
            //For Use rule to determine note N
            var lstUseRuleN = this.lstSequenceHistory.filter(function (x) { return x.UseRuletoDetermineNoteFundingText == "3" || x.UseRuletoDetermineNoteFundingText == "Y"; });
            if (lstUseRuleN.length == 0) {
                var objdeal = new deals_1.deals('');
                objdeal.DealID = this._deal.DealID;
                objdeal.ShowUseRuleN = true;
                this.ShowUseRuleN = true;
                this._isshowApplyNoteLevelPaydowns = true;
                this.checked = false;
                this._isautospreadshow = false;
                if (this._deal.EnableAutospreadRepayments == true) {
                    this._isautospreadRepaymentshow = true;
                }
                this.UseRuledialogbox("Changing all notes to 'Use rule to determine note funding' as 'N' will make them editable. Do you want to proceed?");
                // this.GetDealFundingByDealID(objdeal);
                //for (var i = 0; i <= (this.listdealfunding.length - 1); i++) {
                //    if (this.listdealfunding[i].Applied == false) {
                //        if (this.flexdealfunding.rows[i]) {
                //            for (var j = 9; j <= this.flexdealfunding.columns.length; j++) {
                //                this.flexdealfunding.columns[j].isReadOnly = false;
                //            }
                //        }
                //    }
                //}
            }
            else {
                //For Use rule to determine note Y
                var lstUseRuleY = this.lstSequenceHistory.filter(function (x) { return x.UseRuletoDetermineNoteFundingText == "4" || x.UseRuletoDetermineNoteFundingText == "N"; });
                if (lstUseRuleY.length == 0) {
                    this._isFundingruleChanged = true;
                    var objdeal = new deals_1.deals('');
                    objdeal.DealID = this._deal.DealID;
                    objdeal.ShowUseRuleN = false;
                    this.ShowUseRuleN = false;
                    this._isautospreadshow = true;
                    this._isshowApplyNoteLevelPaydowns = false;
                    this._isautospreadRepaymentshow = false;
                    //  this.GetDealFundingByDealID(objdeal);
                    for (var i = 0; i <= (this.listdealfunding.length - 1); i++) {
                        if (this.listdealfunding[i].Applied == false) {
                            if (this.flexdealfunding.rows[i]) {
                                for (var j = 10; j <= this.flexdealfunding.columns.length; j++) {
                                    if (this.flexdealfunding.columns[j]) {
                                        this.flexdealfunding.columns[j].isReadOnly = true;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    };
    DealDetailComponent.prototype.celleditfunding = function (flexdefunding, e) {
        var _this = this;
        //  this.isDealfundingEdited = true;
        this._isdealfundingChanged = false;
        this._isdealfundingEdit = false;
        var Amtdec = this.listdealfunding[e.row].Value;
        this.listdealfunding[e.row].IsRowEdited = true;
        var currentcolIndex = e.col.toString();
        var currentintcolindex = e.col;
        this._isdealfundingChanged = false;
        var _lstUseRuleN = this.lstSequenceHistory.filter(function (x) { return x.UseRuletoDetermineNoteFundingText == "4" || x.UseRuletoDetermineNoteFundingText == "N" || x.UseRuletoDetermineNoteFundingText == null || x.UseRuletoDetermineNoteFundingText == ""; });
        if (_lstUseRuleN.length == this.lstNote.length || this._deal.ApplyNoteLevelPaydowns == true) {
            // if (this.ShowUseRuleN == false) {
            if (e.col > 11) {
                var totalamt = 0;
                var dealfundingcolumns = Object.keys(this.listdealfunding[e.row]);
                for (var n = 0; n < this.lstNote.length; n++) {
                    if (dealfundingcolumns.includes(this.lstNote[n].Name)) {
                        if (this.listdealfunding[e.row][this.lstNote[n].Name]) {
                            totalamt += parseFloat(this.listdealfunding[e.row][this.lstNote[n].Name]);
                        }
                    }
                }
                this.listdealfunding[e.row].Value = parseFloat(totalamt.toFixed(2));
            }
        }
        var deccount = 0;
        if (currentcolIndex == this.dealfundingColPositionAmount) {
            if (Math.floor(Amtdec) === Amtdec) {
                deccount = 0;
            }
            else {
                if ((Amtdec % 1) != 0) {
                    //  if (Amtdec) {
                    deccount = Amtdec.toString().split(".")[1].length || 0;
                }
            }
            if (deccount > 2) {
                this.listdealfunding[e.row].Value = parseFloat(parseFloat(this.listdealfunding[e.row].Value).toFixed(2));
                this.CustomAlert("Funding amount can't have more than 2 decimal places. System has rounded the inputs to 2 decimal places. ");
                this.flexdealfunding.select(e.row, e.col - 1);
                // Focus on select row and ready for editing
                this.flexdealfunding.focus();
                return;
            }
        }
        if (currentcolIndex == this.dealfundingColPositionDate) {
            var maxappliedDate = new Date(Math.max.apply(null, this.listdealfunding.filter(function (x) { return x.Applied == true; }).map(function (x) { return x.Date; })));
            var lstdtNotes = this.lstNoteFunding.filter(function (x) { return x.DealFundingRowno == _this.listdealfunding[e.row]["DealFundingRowno"]; });
            if (lstdtNotes.length > 0) {
                for (var j = 0; j < lstdtNotes.length; j++) {
                    if (this.listdealfunding[e.row].Date) {
                        lstdtNotes[j]["Date"] = new Date(this.listdealfunding[e.row].Date.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                    }
                }
            }
            if (this.listdealfunding[e.row].Date < maxappliedDate) {
                if (this.listdealfunding[e.row].orgDate == undefined) {
                    this.listdealfunding[e.row].Date = "";
                }
                else {
                    this.listdealfunding[e.row].Date = new Date(this.convertDateToBindable(this.listdealfunding[e.row].orgDate));
                }
                this.CustomAlert("Date cannot be less than last wire confirmed date " + this.convertDateToBindable(maxappliedDate));
            }
            else {
                var sdate = flexdefunding.rows[e.row]._data.Date;
                if (!(sdate === undefined) && sdate != '') {
                    var formateddate = this.convertDateToBindable(sdate);
                    var dealfundingday = new Date(sdate).getDay();
                    if (dealfundingday == 6 || dealfundingday == 0
                        || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411; }).length > 0) {
                        flexdefunding.rows[e.row]._data.isValidDate = false;
                    }
                    else {
                        flexdefunding.rows[e.row]._data.isValidDate = true;
                    }
                }
            }
        }
        if (currentcolIndex == this.dealfundingColPositionPurpose) { //manish
            this.LastPurposeType = e._data;
            var lstdtNotes = this.lstNoteFunding.filter(function (x) { return x.DealFundingRowno == _this.listdealfunding[e.row]["DealFundingRowno"]; });
            if (lstdtNotes.length > 0) {
                for (var j = 0; j < lstdtNotes.length; j++) {
                    if (this.listdealfunding[e.row].PurposeText) {
                        lstdtNotes[j]["PurposeID"] = this.listdealfunding[e.row].PurposeText.toString();
                    }
                }
            }
            if (this.listdealfunding[e.row].PurposeID === undefined || this.listdealfunding[e.row].PurposeID == null) {
                this.listdealfunding[e.row].PurposeID = parseInt(this.listdealfunding[e.row].PurposeText);
            }
            if (this.listdealfunding[e.row].PurposeText == "319") {
                if (this.listdealfunding[e.row].PurposeID) {
                    this.listdealfunding[e.row].PurposeText = this.listdealfunding[e.row].PurposeID;
                }
                else {
                    this.listdealfunding[e.row].PurposeText = '';
                }
                this.CustomAlert("Please choose 'Capitalized Interest' instead of 'Debt Service/Opex'.");
                return;
            }
            this.EnableDisableAutospreadRepayments();
        }
        else if (currentcolIndex == this.dealfundingColPositionWire) {
            for (var tprow = 0; tprow <= this.flexdealfunding.rows.length - 1; tprow++) {
                if (this.flexdealfunding.rows[tprow]._data.Applied !== undefined) {
                    if (this.flexdealfunding.rows[tprow].isReadOnly == false && this.flexdealfunding.rows[tprow]._data.Applied == true) {
                        this.flexdealfunding.rows[tprow]._data.Applied = false;
                        this.CustomAlert("Please enter Date or Amount before checking Wire confirm.");
                        this.flexdealfunding.select(this.flexdealfunding.rows.length - 1, 0);
                        // focus on select row and ready for editing
                        this.flexdealfunding.focus();
                        return;
                    }
                }
            }
        }
        //check for the ff amount increases above 5%
        if (currentcolIndex == this.dealfundingColPositionAmount) {
            if (this.listdealfunding[e.row].WF_CurrentStatus != undefined) {
                if ((this.listdealfunding[e.row].WF_CurrentStatus == "1st Approval" ||
                    this.listdealfunding[e.row].WF_CurrentStatus == "2nd Approval")
                    && this.listdealfunding[e.row].Value != this.originallistdealfunding[e.row].Value) {
                    if (this.listdealfunding[e.row].WF_IsAllow && !this.listdealfunding[e.row].Applied && this._deal.Statusid != 325)
                        this.ChangeFundingAmount(e.row);
                }
            }
        }
        var GeneratedBy = "";
        //check if data is changed and swtich it user entered
        if (this.listdealfunding[e.row].orgDate != null) {
            if (this.listdealfunding[e.row].Date != null) {
                if (new Date(this.listdealfunding[e.row].Date) != this.listdealfunding[e.row].orgDate) {
                    GeneratedBy = "user entered";
                }
            }
        }
        if (this.listdealfunding[e.row].orgValue != this.listdealfunding[e.row].Value) {
            GeneratedBy = "user entered";
        }
        if (this.listdealfunding[e.row].orgPurposeID != this.listdealfunding[e.row].PurposeID) {
            GeneratedBy = "user entered";
        }
        if (GeneratedBy != "") {
            this.listdealfunding[e.row].GeneratedBy = 746;
            this.listdealfunding[e.row].GeneratedByText = this.lstGeneratedBy.find(function (x) { return x.LookupID == 746; }).Name;
        }
        if (currentintcolindex > 10) {
            var celldata = this.listdealfunding[e.row][flexdefunding.columns[e.col].header];
            var regex2 = /^[a-zA-Z.,;:|\\\/~!@#$%^&*_-{}\[\]()`"'<>?\s]+$/;
            if (regex2.test(celldata)) {
                this.listdealfunding[e.row][flexdefunding.columns[e.col].header] = 0;
                this.flexdealfunding.invalidate();
            }
            //assgin dealfundingrow
            for (var nf = 0; nf < this.lstNoteFunding.length; nf++) {
                if (this.lstNoteFunding[nf].NoteName == flexdefunding.columns[e.col].header) {
                    if (this.lstNoteFunding[nf].DealFundingRowno == null) {
                        if (this.lstNoteFunding[nf].PurposeID == this.listdealfunding[e.row].PurposeID) {
                            if (this.convertDateToBindable(this.lstNoteFunding[nf].Date) == this.convertDateToBindable(this.listdealfunding[e.row].Date)) {
                                this.lstNoteFunding[nf].DealFundingRowno = this.listdealfunding[e.row].DealFundingRowno;
                            }
                        }
                    }
                }
            }
            var recordfound = "";
            var changedata = this.lstNoteFunding.filter(function (x) { return x.PurposeID == _this.listdealfunding[e.row].PurposeID && _this.convertDateToBindable(x.Date) == _this.convertDateToBindable(_this.listdealfunding[e.row].Date) && x.DealFundingRowno == _this.listdealfunding[e.row].DealFundingRowno; });
            for (var j = 0; j < changedata.length; j++) {
                if (changedata[j].NoteName == flexdefunding.columns[e.col].header) {
                    this.lstNoteFunding.find(function (c) { return c.DealFundingRowno == changedata[j].DealFundingRowno && c.NoteName == changedata[j].NoteName; }).Value = this.listdealfunding[e.row][flexdefunding.columns[e.col].header];
                }
            }
        }
        var _lstUseRuleN = this.lstSequenceHistory.filter(function (x) { return x.UseRuletoDetermineNoteFundingText == "4" || x.UseRuletoDetermineNoteFundingText == "N" || x.UseRuletoDetermineNoteFundingText == null || x.UseRuletoDetermineNoteFundingText == ""; });
        if (_lstUseRuleN.length == this.lstNote.length) {
            if (!(this.listdealfunding[e.row].PurposeText == undefined)) {
                this.syncDealfundingandTotalcommitmentlistforNnotes(this.listdealfunding);
            }
        }
        if (this._isAdjustedTotalCommitmentTabClicked == true) {
            var header = flexdefunding.columns[e.col].header;
            if (header == 'Required Equity' || header == 'Additional Equity' || header == 'Date') {
                this.UpdateEquitySummary();
            }
        }
        this.getEquityValues();
        //celleditfunding ends
    };
    DealDetailComponent.prototype.cellEditEndingHandler = function (flexGrid, e) {
        if (e.col.toString() == "5") {
            var s = flexGrid.selection;
            var noteid = this.grdflexDynamicColForSequence.getCellData(e.row, 0, true);
            var Status = this.lstNote.find(function (x) { return x.CRENoteID == noteid; }).StatusName;
            var userule = this.grdflexDynamicColForSequence.getCellData(e.row, e.col, true);
            if (Status != "Active" && userule != 'Y') {
                e.cancel = true;
                this.CustomAlert('Inactive notes can not be included in funding payrules.');
            }
        }
    };
    DealDetailComponent.prototype.celleditPayrule = function (flexpayrule, e) {
        var totalval = 0;
        if (e.col > 1) {
            for (var i = 2; i < (flexpayrule.columns.length) - 2; i++) {
                totalval += this.GetDefaultValue(this.grdflexDynamicColForNotePayruleSetup.getCellData(e.row, i, false));
            }
            this.lstNotePayruleSetup[e.row].Total = totalval;
            this.grdflexDynamicColForNotePayruleSetup.invalidate(true);
        }
    };
    DealDetailComponent.prototype.showDeleteDialog = function (deleteRowIndex, moduleName) {
        this.deleteRowIndex = deleteRowIndex;
        this.modulename = moduleName;
        var modalDelete = document.getElementById('myModalDelete');
        modalDelete.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    DealDetailComponent.prototype.CloseDeletePopUp = function () {
        var modal = document.getElementById('myModalDelete');
        modal.style.display = "none";
    };
    DealDetailComponent.prototype.deleteRow = function () {
        debugger;
        if (this.modulename == "Deal funding") {
            var deldynamicCol = [];
            deldynamicCol = this.cvDealFundingList.currentItem;
            this.deletedynamicList.push(deldynamicCol);
            this.isrowdeleted = true;
            this.cvDealFundingList.removeAt(this.deleteRowIndex);
            if (this.listdealfundingwithoutchange[this.deleteRowIndex]) {
                if (this.listdealfundingwithoutchange[this.deleteRowIndex].DealFundingID != undefined) {
                    var DealFundingID = this.listdealfundingwithoutchange[this.deleteRowIndex].DealFundingID;
                    var DealFundingRowno = this.listdealfundingwithoutchange[this.deleteRowIndex].DealFundingRowno;
                    this.listdealfundingwithoutchange = this.listdealfundingwithoutchange.filter(function (obj) {
                        return obj.DealFundingID != DealFundingID;
                    });
                    for (var j = 0; j < this.lstNoteFunding.length; j++) {
                        if (this.lstNoteFunding[j].DealFundingID) {
                            if (this.lstNoteFunding[j].DealFundingID == DealFundingID) {
                                this.lstNoteFunding.splice(j, 1);
                            }
                        }
                        else {
                            if (this.lstNoteFunding[j].DealFundingRowno == DealFundingRowno) {
                                this.lstNoteFunding.splice(j, 1);
                            }
                        }
                    }
                }
            }
            if (this._isAdjustedTotalCommitmentTabClicked == true) {
                this.UpdateEquitySummary();
            }
        }
        if (this.modulename == "Payrule") {
            this.cvNotePayruleSetup.removeAt(this.deleteRowIndex);
            this.grdflexDynamicColForNotePayruleSetup.invalidate(true);
        }
        if (this.modulename == "Enable Auto Spread") {
            this.deldynamicautopreadruleCol = this.autospreadrulelist.currentItem;
            this.deletedynamicList.push(this.deldynamicautopreadruleCol);
            this.isrowdeleted = true;
            this._autospreadgenerate = true;
            for (var i = 0; i < this.lstautospreadrule.length; i++) {
                if (this.lstautospreadrule[i] == this.deldynamicautopreadruleCol) {
                    this.autospreadrulelist.removeAt(this.deleteRowIndex);
                }
                else {
                    this.lstautospreadrule = this.lstautospreadrule;
                }
            }
            this.flexautospreadrule.invalidate(true);
        }
        if (this.modulename == "Total Commitment") {
            var deltotalcommitment;
            this._isFundingruleChanged = true;
            this.deladjustmentcommitment.push(this.lstAdjustedTotalCommitment.currentItem);
            deltotalcommitment = this.lstAdjustedTotalCommitment.currentItem;
            for (var i = 0; i < this.listAdjustedTotalCommitment.length; i++) {
                if (this.listAdjustedTotalCommitment[i] == deltotalcommitment) {
                    this.lstAdjustedTotalCommitment.removeAt(this.deleteRowIndex);
                }
                else {
                    this.listAdjustedTotalCommitment = this.listAdjustedTotalCommitment;
                }
            }
            this.flexadjustedtotalcommitment.invalidate(true);
            this.UpdateEquitySummary();
        }
        if (this.modulename == "AutospreadRepayment") {
            this._isFundingruleChanged = true;
            this.lstcumulativeprobabilitybyDate.removeAt(this.deleteRowIndex);
            this.flexautospreadrepayments.invalidate(true);
        }
        if (this.modulename == "Maturity") {
            if (this.flexMaturity.rows[this.deleteRowIndex]) {
                if (this.flexMaturity.rows[this.deleteRowIndex].dataItem.ScheduleID) {
                    for (var l = 0; l < this.maturityList.length; l++) {
                        if (this.flexMaturity.rows[this.deleteRowIndex].dataItem.ScheduleID == this.maturityList[l].ScheduleID) {
                            this.maturityList[l].isDeleted = 1;
                        }
                    }
                }
            }
            this._lstMaturity.removeAt(this.deleteRowIndex);
            this.flexMaturity.invalidate(true);
            this.createMaturityList('Delete', null, this.selectedGroupName);
        }
        if (this.modulename == 'ReserveSchedule') {
            if (this.flexReserveSchedule.rows[this.deleteRowIndex]) {
                if (this.flexReserveSchedule.rows[this.deleteRowIndex].dataItem.DealReserveScheduleGUID) {
                    for (var l = 0; l < this.reserveScheduleList.length; l++) {
                        if (this.flexReserveSchedule.rows[this.deleteRowIndex].dataItem.DealReserveScheduleGUID == this.reserveScheduleList[l].DealReserveScheduleGUID) {
                            this.reserveScheduleList[l].isDeleted = 1;
                            this._listdeletedReserveSchedule.push(this.reserveScheduleList[l]);
                        }
                    }
                }
            }
            this._listReserveSchedule.removeAt(this.deleteRowIndex);
            this.flexReserveSchedule.invalidate(true);
        }
        // to call sync function for commitment and dealfunding grid
        var _lstUseRuleN = this.lstSequenceHistory.filter(function (x) { return x.UseRuletoDetermineNoteFundingText == "4" || x.UseRuletoDetermineNoteFundingText == "N" || x.UseRuletoDetermineNoteFundingText == null || x.UseRuletoDetermineNoteFundingText == ""; });
        if (_lstUseRuleN.length == this.lstNote.length) {
            this.syncDealfundingandTotalcommitmentlistforNnotes(this.listdealfunding);
        }
        this.EnableDisableAutospreadRepayments();
        this.CloseDeletePopUp();
    };
    DealDetailComponent.prototype.DeleteDealFundingAndNoteFundingForUseRuleN = function () {
        var deletedids = [];
        var deletednoteids = [];
        for (var d = 0; d < this.listdealfunding.length; d++) {
            if (this.listdealfunding[d].Applied != true) {
                if (this.listdealfunding[d].PurposeText == "Paydown" || this.listdealfunding[d].PurposeText == "631") {
                    if (this.listdealfunding[d].Comment == "" || this.listdealfunding[d].Comment == null) {
                        deletedids.push(this.listdealfunding[d].DealFundingRowno);
                    }
                }
            }
        }
        for (var j = 0; j < this.lstNoteFunding.length; j++) {
            if (this.lstNoteFunding[j].Applied != true) {
                if (this.lstNoteFunding[j].Purpose == "Paydown" || this.lstNoteFunding[j].PurposeID == "631") {
                    if (this.lstNoteFunding[j].Comments == "" || this.lstNoteFunding[j].Comments == null) {
                        deletednoteids.push(this.lstNoteFunding[j].DealFundingRowno);
                    }
                }
            }
        }
        for (var row = 0; row < deletedids.length; row++) {
            for (var dl = 0; dl < this.listdealfunding.length; dl++) {
                if (this.listdealfunding[dl].DealFundingRowno == deletedids[row]) {
                    this.lstDealFundAutoSpreadDeleted.push(this.listdealfunding[dl]);
                    this.listdealfunding.splice(dl, 1);
                }
            }
        }
        for (var noterow = 0; noterow < deletednoteids.length; noterow++) {
            for (var dl = 0; dl < this.lstNoteFunding.length; dl++) {
                if (this.lstNoteFunding[dl].DealFundingRowno == deletednoteids[noterow]) {
                    this.lstNoteFunding.splice(dl, 1);
                }
            }
        }
        this.syncDealfundingandTotalcommitmentlistforNnotes(this.listdealfunding);
        this.cvDealFundingList = new wjcCore.CollectionView(this.listdealfunding);
        this.cvDealFundingList.trackChanges = true;
    };
    DealDetailComponent.prototype.showDialogCalcJsonScriptEengine = function (modulename) {
        if (this.listdealfunding.length > 0) {
            this.ConvertInSequenceList();
        }
        $('#txtNoteJsonForScriptEngine').val('');
        $('#txtNoteJsonResponseForScriptEngine').val('');
        var modal = document.getElementById('myModalScriptEngine');
        modal.style.display = "block";
        $.getScript("/js/jsDrag.js");
        this._note = new note_1.Note('');
        this._note.modulename = modulename;
        var arrNoteID = [];
        this.lstNote.forEach(function (e) {
            arrNoteID.push(e.NoteId);
        });
        this._isPeriodicDataFetching = true;
        this.NoteRuleobj = [];
        this.Noteobj = [];
        this.RunCalculatorForJsonForScriptEngine();
    };
    DealDetailComponent.prototype.ClosePopUpScriptEngine = function () {
        var modal = document.getElementById('myModalScriptEngine');
        $('#txtNoteJsonForScriptEngine').val('');
        $('#txtNoteJsonResponseForScriptEngine').val('');
        modal.style.display = "none";
        this._isSuccess = false;
    };
    DealDetailComponent.prototype.deleteProperty = function (lstObject) {
        lstObject.forEach(function (v) {
            delete v.CreatedBy;
            delete v.CreatedDate;
            delete v.UpdatedBy;
            delete v.UpdatedDate;
        });
    };
    DealDetailComponent.prototype.RunCalculatorForJsonForScriptEngine = function () {
        var _this = this;
        //# create deal json
        this.listfdealfunding = [];
        this.listfnotesequence = [];
        var data = this.listdealfunding;
        for (var d = 0; d < data.length; d++) {
            if (data[d].Date) {
                this.listfdealfunding.push({ "DealID": this._deal.CREDealID, "Date": data[d].Date, "Value": data[d].Value });
            }
        }
        if (this.lstSequence) {
            for (var n = 0; n < this.lstNote.length; n++) {
                var listnote = this.lstSequence.filter(function (x) { return x.NoteID == _this.lstNote[n].NoteId; });
                var cresnoteid = this.lstNote[n].CRENoteID;
                var UseRuletoDetermineNoteFundingText = this.lstNote[n].UseRuletoDetermineNoteFundingText;
                var FundingPriority = this.lstNote[n].FundingPriority;
                var RepaymentPriority = this.lstNote[n].RepaymentPriority;
                var SequenceNo = 0;
                var SequenceTypeText = "";
                var Value = 0;
                for (var g = 0; g < listnote.length; g++) {
                    SequenceNo = listnote[g].SequenceNo;
                    SequenceTypeText = listnote[g].SequenceTypeText;
                    Value = listnote[g].Value;
                    this.listfnotesequence.push({
                        "CRENoteID": cresnoteid,
                        "UseRuletoDetermineNoteFunding": UseRuletoDetermineNoteFundingText,
                        "FundingPriority": FundingPriority,
                        "RepaymentPriority": RepaymentPriority,
                        "SequenceNo": SequenceNo,
                        "SequenceTypeText": SequenceTypeText,
                        "Value": Value,
                        "Ratio": 0
                    });
                }
            }
        }
        //=====Run Calculator==========
        for (var cnt = 0; cnt < this.lstNote.length; cnt++) {
            this.noteSrv.getNoteCalculatorJsonByNoteId(this.lstNote[cnt].NoteId).subscribe(function (res) {
                if (res != null && res.Succeeded) {
                    _this._isSuccess = true;
                    var result = JSON.parse(res.Message);
                    if (result.NotePIKScheduleList != null && result.NotePIKScheduleList != undefined) {
                        _this.deleteProperty(result.NotePIKScheduleList);
                    }
                    if (result.RateSpreadScheduleList != null && result.RateSpreadScheduleList != undefined) {
                        _this.deleteProperty(result.RateSpreadScheduleList);
                    }
                    if (result.MaturityScenariosList != null && result.MaturityScenariosList != undefined) {
                        _this.deleteProperty(result.MaturityScenariosList);
                    }
                    if (result.NoteStrippingList != null && result.NoteStrippingList != undefined) {
                        _this.deleteProperty(result.NoteStrippingList);
                    }
                    if (result.NoteDefaultScheduleList != null && result.NoteDefaultScheduleList != undefined) {
                        _this.deleteProperty(result.NoteDefaultScheduleList);
                    }
                    if (result.NotePrepayAndAdditionalFeeScheduleList != null && result.NotePrepayAndAdditionalFeeScheduleList != undefined) {
                        _this.deleteProperty(result.NotePrepayAndAdditionalFeeScheduleList);
                    }
                    if (result.EffectiveDateList != null && result.EffectiveDateList != undefined) {
                        _this.deleteProperty(result.EffectiveDateList);
                    }
                    if (result.ListFutureFundingScheduleTab != null && result.ListFutureFundingScheduleTab != undefined) {
                        _this.deleteProperty(result.ListFutureFundingScheduleTab);
                    }
                    if (result.ListPIKfromPIKSourceNoteTab != null && result.ListPIKfromPIKSourceNoteTab != undefined) {
                        _this.deleteProperty(result.ListPIKfromPIKSourceNoteTab);
                    }
                    if (result.ListFeeCouponStripReceivable != null && result.ListFeeCouponStripReceivable != undefined) {
                        _this.deleteProperty(result.ListFeeCouponStripReceivable);
                    }
                    if (result.ListFixedAmortScheduleTab != null && result.ListFixedAmortScheduleTab != undefined) {
                        _this.deleteProperty(result.ListFixedAmortScheduleTab);
                    }
                    if (result.NoteServicingFeeScheduleList != null && result.NoteServicingFeeScheduleList != undefined) {
                        _this.deleteProperty(result.NoteServicingFeeScheduleList);
                    }
                    if (result.NoteFinancingScheduleList != null && result.NoteFinancingScheduleList != undefined) {
                        _this.deleteProperty(result.NoteFinancingScheduleList);
                    }
                    if (result.ListServicingLogTab != null && result.ListServicingLogTab != undefined) {
                        _this.deleteProperty(result.ListServicingLogTab);
                    }
                    if (result.ServicingOneTimeFeesTableList != null && result.ServicingOneTimeFeesTableList != undefined) {
                        _this.deleteProperty(result.ServicingOneTimeFeesTableList);
                    }
                    if (result.ListFinancingFeeSchedule != null && result.ListFinancingFeeSchedule != undefined) {
                        _this.deleteProperty(result.ListFinancingFeeSchedule);
                    }
                    if (result.ListPIKInterestTab != null && result.ListPIKInterestTab != undefined) {
                        _this.deleteProperty(result.ListPIKInterestTab);
                    }
                    if (result.ListPIKDistribution != null && result.ListPIKDistribution != undefined) {
                        _this.deleteProperty(result.ListPIKDistribution);
                    }
                    if (result.ListLiborScheduleTab != null && result.ListLiborScheduleTab != undefined) {
                        result.ListLiborScheduleTab.forEach(function (v) {
                            delete v.NoteID;
                            delete v.AccountID;
                            delete v.Event_Date;
                            delete v.EventTypeID;
                            delete v.EventTypeText;
                            delete v.EventId;
                            delete v.CreatedBy;
                            delete v.CreatedDate;
                            delete v.UpdatedBy;
                            delete v.UpdatedDate;
                            delete v.ModuleId;
                            delete v.ScheduleID;
                        });
                    }
                    if (result.DefaultScenarioParameters != null) {
                        _this.DefaultScenarioParameters = result.DefaultScenarioParameters;
                    }
                    result.ListLiborScheduleTab = undefined;
                    result.ListNotePeriodicOutputs = undefined;
                    result.ListTransaction = undefined;
                    result.ListCalcValues = undefined;
                    result.ListCashflowTransactionEntry = undefined;
                    _this.Noteobj.push(result);
                    if (result.NoteRule != null)
                        _this.NoteRuleobj.push(JSON.parse(result.NoteRule));
                    else {
                        var innerindex = 0;
                        for (var i = 0; i < _this.lstNote.length; i++) {
                            if (_this.lstNote[i].NoteId == result.NoteId && result.NoteId != null) {
                                _this.resultNote = _this.lstNote[i];
                                innerindex = i;
                                break;
                            }
                        }
                        _this.NoteRuleobj.push({ "Name": _this.resultNote.Name, "description": "Calculate Note 123 for every period", "when": "", "action": { "actionHandler": "Note", "Name": _this.resultNote.FunctionName, "actionParameters": { "NoteID": result.CRENoteID } }, "priority": innerindex.toString() });
                    }
                }
                if (_this.NoteRuleobj.length == _this.lstNote.length) {
                    _this.GetLiborSchedule();
                }
            }, function (error) {
            });
        }
    };
    DealDetailComponent.prototype.GetLiborSchedule = function () {
        var _this = this;
        this.dealSrv.GetallLiborSchedule().subscribe(function (res) {
            if (res.Succeeded) {
                _this.lstLiborSchedule = [];
                if (res.lstLiborScheduledata != null && res.lstLiborScheduledata != undefined) {
                    res.lstLiborScheduledata.forEach(function (v) {
                        delete v.NoteID;
                        delete v.AccountID;
                        delete v.Event_Date;
                        delete v.EventTypeID;
                        delete v.EventTypeText;
                        delete v.EventId;
                        delete v.CreatedBy;
                        delete v.CreatedDate;
                        delete v.UpdatedBy;
                        delete v.UpdatedDate;
                        delete v.ModuleId;
                        delete v.ScheduleID;
                    });
                    _this.lstLiborSchedule = res.lstLiborScheduledata;
                }
            }
            else
                _this.ListHoliday = [];
            _this.BuildCalcJson();
        });
    };
    DealDetailComponent.prototype.GetHolidayList = function () {
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
    DealDetailComponent.prototype.BuildCalcJson = function () {
        this.NoteRuleobj.push({ "Name": this._deal.DealName, "description": "PayRule generation", "when": "", "action": { "actionHandler": "Pay", "Name": "GeneratePayrule", "actionParameters": { "DealID": this._deal.CREDealID } }, "priority": "1" });
        if (this._isSuccess && this.Noteobj.length) {
            var calcjsonscriptengine = {
                Deal: {
                    DealName: this._deal.DealName,
                    CREDealID: this._deal.CREDealID,
                    DealID: this._deal.DealID,
                    Notes: this.Noteobj,
                    DealFundingList: this.listfdealfunding,
                    FundingsequenceList: this.listfnotesequence,
                    HolidayList: this.ListHoliday,
                    Scenario: {
                        MaturityScenarioOverride: this.DefaultScenarioParameters.MaturityScenarioOverrideText,
                        MaturityAdjustmentMonths: this.DefaultScenarioParameters.MaturityAdjustment == null ? 0 : this.DefaultScenarioParameters.MaturityAdjustment,
                        LiborScheduleList: this.lstLiborSchedule
                    },
                    Rules: this.NoteRuleobj,
                    Output: {
                        Note: [
                            "rate_DIndexValueusingFloatingRateIndexReferenceDate"
                        ],
                        Deal: [
                            "DealName",
                            "CREDealID"
                        ],
                        Response: [
                            "Transaction"
                        ]
                    }
                }
            };
            $('#txtNoteJsonForScriptEngine').val(JSON.stringify(calcjsonscriptengine)
                .replace('NoteStrippingList', 'StrippingList')
                .replace('NoteDefaultScheduleList', 'DefaultScheduleList')
                .replace('NotePrepayAndAdditionalFeeScheduleList', 'PrepayAndAdditionalFeeScheduleList').replace(/null/g, "\"\""));
            this._isSuccess = false;
        }
        else {
            this.ClosePopUpScriptEngine();
            this._ShowmessagedivWar = true;
            this._ShowmessagedivMsgWar = 'Cannot calculate with missing fields see Exception tab for more information';
            setTimeout(function () {
                this._ShowmessagedivWar = false;
            }.bind(this), 5000);
        }
        this._isPeriodicDataFetching = false;
    };
    //**code for calc json script engine-
    DealDetailComponent.prototype.invokeFunction = function () {
        var _this = this;
        var inputjson = $('#txtNoteJsonForScriptEngine').val();
        this._isPeriodicDataFetching = true;
        var parameters = {
            //FunctionName: 'InvokeNew',
            FunctionName: this.foldername == "Auto-Version" ? this.autoVerfoldername : this.foldername,
            PlayLoad: inputjson
        };
        this.functionServiceSrv.invokeFunction(parameters)
            .subscribe(function (res) {
            _this._isPeriodicDataFetching = false;
            if (res != "")
                $('#txtNoteJsonResponseForScriptEngine').val(res);
            else
                $('#txtNoteJsonResponseForScriptEngine').val('Error - Something went wrong');
        }, function (error) {
            $('#txtNoteJsonResponseForScriptEngine').val('Error - Something went wrong');
            _this.utilityService.navigateToSignIn();
        });
    };
    //end
    DealDetailComponent.prototype.Addupdaterules = function (value, index, noteid) {
        //if (value == undefined || value == "")
        value = JSON.stringify({ "Name": this.lstNote[index].Name, "description": "Calculate Note 123 for every period", "when": "", "action": { "actionHandler": "Note", "Name": this.lstNote[index].FunctionName, "actionParameters": { "type": "Note", "id": this.lstNote[index].CRENoteID } }, "priority": index.toString() }, null, 4);
        this.ruleRowIndex = index;
        $('#txtrules').val(value);
        var modal = document.getElementById('myModalRules');
        modal.style.display = "block";
        return false;
    };
    DealDetailComponent.prototype.SaveRule = function () {
        var _this = this;
        this._noteRule = new note_1.Note('');
        this._noteRule.NoteId = this.lstNote[this.ruleRowIndex].NoteId;
        this._noteRule.NoteRule = $('#txtrules').val();
        this._isPeriodicDataFetching = true;
        this.noteSrv.AddUpdateNoteRuleByNoteId(this._noteRule).subscribe(function (res) {
            if (res != null && res.Succeeded) {
                _this.lstNote[_this.ruleRowIndex].NoteRule = $('#txtrules').val();
                $('#txtrules').val('');
                _this.ClosePopUpRules();
                _this._Showmessagediv = true;
                _this._ShowmessagedivMsg = 'Note rule updated successfully';
                setTimeout(function () {
                    this._Showmessagediv = false;
                }.bind(_this), 5000);
                _this._isPeriodicDataFetching = false;
            }
        }, function (error) {
            _this._ShowmessagedivWar = true;
            _this._ShowmessagedivMsgWar = 'Error - Something went wrong';
            setTimeout(function () {
                this._ShowmessagedivWar = false;
            }.bind(_this), 5000);
            _this._isPeriodicDataFetching = false;
        });
    };
    DealDetailComponent.prototype.getFastFolderList = function () {
        var _this = this;
        this.functionServiceSrv.getallFastFunction()
            .subscribe(function (res) {
            _this.lstFolders = res;
            if (_this.lstFolders != null && _this.lstFolders.length > 0) {
                _this.autoVerfoldername = _this.lstFolders[0].FunctionName;
                _this.lstFolders[0].FunctionName = "Auto-Version";
                _this.foldername = "Auto-Version";
            }
        }, function (error) {
            _this.utilityService.navigateToSignIn();
        });
    };
    DealDetailComponent.prototype.ChangeFolder = function (newvalue) {
        this.foldername = newvalue;
    };
    DealDetailComponent.prototype.ChangeNoteFunction = function (newvalue, index) {
        this.lstNote[index].FunctionName = newvalue;
    };
    DealDetailComponent.prototype.ClosePopUpRules = function () {
        var modal = document.getElementById('myModalRules');
        modal.style.display = "none";
    };
    DealDetailComponent.prototype.SendPushNotification = function () {
        //added for signalR notification
        var _userData = JSON.parse(localStorage.getItem('user'));
        //var addupdatetext = 'created by ';
        var _module = '';
        var dealId;
        this._actrouting.params.forEach(function (params) {
            if (params['id'] !== undefined) {
                dealId = params['id'];
            }
        });
        var addupdatetext = '';
        if (dealId == '00000000-0000-0000-0000-000000000000') {
            addupdatetext = 'created by ';
            _module = 'Add deal';
        }
        else {
            addupdatetext = 'updated by ';
            _module = 'Edit Deal';
        }
        var routepath = '#/dealdetail/' + dealId;
        var _notificationMsg = 'A deal ' + this._deal.DealName + ' has been ' + addupdatetext + _userData.FirstName;
        _notificationMsg = _module + '|*|' + _notificationMsg + '|*|' + appsettings_1.AppSettings._notificationenvironment + '|*|' + _userData.UserID;
        this._signalRService.SendNotification(_notificationMsg);
    };
    DealDetailComponent.prototype.ChangeFundingappied = function (dealFundingID, _value, flexGridrw) {
        var _this = this;
        console.log('_isautospreadRepaymentshow ' + this._isautospreadRepaymentshow);
        console.log('isShowgenerateButton ' + this.isShowgenerateButton);
        console.log('isShowGenerateAutospreadRepay ' + this.isShowGenerateAutospreadRepay);
        console.log('ShowUseRuleN ' + this.ShowUseRuleN);
        //this._isdealfundingChanged = false;
        var currentpurposeid;
        if (!this._isdealfundingEdit && (this.isShowGenerateAutospreadRepay || !this.ShowUseRuleN)) {
            // if (this.isShowGenerateAutospreadRepay || !this.ShowUseRuleN) {
            this.CustomAlert("You must generate funding schedule after change funding.");
            this.flexdealfunding.rows[flexGridrw.index].Applied = false;
            this.flexdealfunding.invalidate();
            // }
        }
        else {
            if (_value == true) {
                //workflow validation
                if (!(Number(this.listdealfunding[flexGridrw.index].PurposeText).toString() == "NaN" || Number(this.listdealfunding[flexGridrw.index].PurposeText) == 0)) {
                    currentpurposeid = Number(this.listdealfunding[flexGridrw.index].PurposeText);
                }
                else {
                    currentpurposeid = Number(this.lstPurposeType.find(function (x) { return x.Name == _this.listdealfunding[flexGridrw.index].PurposeText; }).LookupID);
                }
                var lstwfstatus = this.listwfStatusPurposeMapping.filter(function (x) { return x.PurposeTypeId == currentpurposeid; });
                if (!(this._deal.Statusid == 325 && (this._deal.LinkedDealID == "" || this._deal.LinkedDealID == null))) {
                    if (lstwfstatus.length > 0) {
                        if (this.listdealfunding[flexGridrw.index].WF_CurrentStatusDisplayName != "Completed" || this.listdealfunding[flexGridrw.index].WF_CurrentStatusDisplayName == null) {
                            this.CustomAlert("You cannot wire confirm the draw as the workflow status is not completed.");
                            this.flexdealfunding.rows[flexGridrw.index].Applied = false;
                            this.flexdealfunding.invalidate();
                            return;
                        }
                    }
                }
                this._isdealfundingChanged = false;
                //Use Rule N Row Total Validation
                if (this.ShowUseRuleN) {
                    var rowtotal = 0, dealrowfund = 0;
                    dealrowfund = this.listdealfunding[flexGridrw.index]["Value"];
                    if (this.dynamicColList.length > 32) {
                        for (var m = 33; m < this.dynamicColList.length; m++) {
                            if (this.listdealfunding[flexGridrw.index][this.dynamicColList[m]]) {
                                //  rowtotal += parseFloat(this.listdealfunding[flexGridrw.index][this.dynamicColList[m]].replace(/,/g, ''));
                                if (this.listdealfunding[flexGridrw.index][this.dynamicColList[m]].toString().includes(',')) {
                                    rowtotal += parseFloat(this.listdealfunding[flexGridrw.index][this.dynamicColList[m]].replace(/,/g, ''));
                                    // rowtotal += notwireDealfunding[t][this.dynamicColList[m]];
                                }
                                else {
                                    rowtotal += parseFloat(this.listdealfunding[flexGridrw.index][this.dynamicColList[m]]);
                                }
                            }
                        }
                    }
                    else {
                        for (var m = 0; m < this.dynamicColList.length; m++) {
                            if (this.dynamicColList[m] != "Date" && this.dynamicColList[m] != "PurposeID" && this.dynamicColList[m] != "DealFundingRowno" && this.dynamicColList[m] != "Applied") {
                                if (this.listdealfunding[flexGridrw.index][this.dynamicColList[m]]) {
                                    if (this.listdealfunding[flexGridrw.index][this.dynamicColList[m]].toString().includes(',')) {
                                        rowtotal += parseFloat(this.listdealfunding[flexGridrw.index][this.dynamicColList[m]].replace(/,/g, ''));
                                    }
                                    else {
                                        rowtotal += parseFloat(this.listdealfunding[flexGridrw.index][this.dynamicColList[m]]);
                                    }
                                }
                            }
                        }
                    }
                    if (parseFloat(parseFloat(rowtotal.toString()).toFixed(2)) != parseFloat(parseFloat(dealrowfund.toString()).toFixed(2))) {
                        //   if ((Math.round(rowtotal * 100) / 100) != (Math.round(dealrowfund * 100) / 100)) {
                        this.CustomAlert("Sum of note funding is not equal to deal funding.");
                        flexGridrw.dataItem.Applied = false;
                        this.flexdealfunding.invalidate();
                        return;
                    }
                }
                //End Use Rule N Row Total Validation
                if (this.listdealfunding[flexGridrw.index].Date == undefined) {
                    this.flexdealfunding.rows[flexGridrw.index].Applied = false;
                    this.flexdealfunding.invalidate();
                    this.CustomAlert("Date can not be blank.");
                    return;
                }
                if (this.listdealfunding.length > 1) {
                    var lstDates = this.listdealfunding.filter(function (x) { return x.Applied == false; }).map(function (x) { return x.Date; });
                    if (lstDates.length >= 1) {
                        var minDate;
                        minDate = null;
                        // var minDate = new Date(Math.min.apply(null, this.listdealfunding.filter(x => x.Applied == false).map(x => x.Date)));
                        for (var val = 0; val < this.listdealfunding.length; val++) {
                            if (this.listdealfunding[val].Date != null && this.listdealfunding[val].Applied == false) {
                                if (minDate === null || this.listdealfunding[val].Date < minDate) {
                                    minDate = this.listdealfunding[val].Date;
                                }
                            }
                        }
                        if (minDate != null) {
                            minDate = new Date(minDate);
                        }
                        var wcDate = new Date(flexGridrw.dataItem.Date);
                        if (wcDate.toString() != minDate.toString()) {
                            this.listdealfunding.find(function (x) { return x.DealFundingID == dealFundingID; }).OrgApplied = false;
                            flexGridrw.dataItem.Applied = false;
                            this.flexdealfunding.invalidate();
                            this.CustomAlert("You can't confirm wire on a later date without confirming all wires in between.");
                            return;
                        }
                        else {
                            var today = new Date();
                            //  var nextbdate = this.getnexybusinessDate(today, 10);
                            var nextbdate = this.getnextbusinessDate(today, 20, true);
                            if (wcDate > nextbdate) {
                                this.listdealfunding.find(function (x) { return x.DealFundingID == dealFundingID; }).OrgApplied = false;
                                flexGridrw.dataItem.Applied = false;
                                this.flexdealfunding.invalidate();
                                this.CustomAlert("You can only confirm up to " + this.convertDateToBindable(nextbdate) + ".");
                                return;
                            }
                        }
                    }
                }
            }
            else {
                var maxDate = new Date(Math.max.apply(null, this.listdealfunding.filter(function (x) { return x.Applied == true; }).map(function (x) { return x.Date; })));
                if (maxDate.toJSON()) {
                    if (flexGridrw.dataItem.Date) {
                        var wcDate = new Date(flexGridrw.dataItem.Date);
                        if (wcDate.toString() != maxDate.toString()) {
                            this.flexdealfunding.invalidate();
                            this.CustomAlert("You can't remove a wire confirmation on an earlier date without removing the wire confirmation on later dates.");
                            return;
                        }
                    }
                }
                this._isdealfundingChanged = false;
            }
            if (this.rolename != 'Super Admin') {
                if (_value == true) {
                    this.listdealfunding.find(function (x) { return x.DealFundingID == dealFundingID; }).OrgApplied = true;
                    flexGridrw.isReadOnly = true;
                    flexGridrw.cssClass = "customgridrowcolor";
                    flexGridrw.dataItem.Applied = true;
                }
                if (_value == false) {
                    this.listdealfunding.find(function (x) { return x.DealFundingID == dealFundingID; }).OrgApplied = false;
                    flexGridrw.isReadOnly = false;
                    flexGridrw.dataItem.Applied = false;
                    flexGridrw.cssClass = "customgridrowcolornotapplied";
                }
            }
            else {
                if (_value == true) {
                    this.listdealfunding.find(function (x) { return x.DealFundingID == dealFundingID; }).OrgApplied = true;
                    flexGridrw.isReadOnly = true;
                    flexGridrw.dataItem.Applied = true;
                    flexGridrw.cssClass = "customgridrowcolor";
                }
                if (_value == false) {
                    this.listdealfunding.find(function (x) { return x.DealFundingID == dealFundingID; }).OrgApplied = false;
                    flexGridrw.isReadOnly = false;
                    flexGridrw.dataItem.Applied = false;
                    if (flexGridrw.dataItem.WF_IsCompleted == 1 && flexGridrw.dataItem.Applied == false)
                        flexGridrw.cssClass = "customgridWFcolor";
                    else
                        flexGridrw.cssClass = "customgridrowcolornotapplied";
                }
            }
        }
    };
    DealDetailComponent.prototype.ChangeFundingAmount = function (rowindex) {
        if (this.originallistdealfunding[rowindex] != undefined) {
            var originalamount = this.originallistdealfunding[rowindex].Value;
            var amt = originalamount * .05;
            amt = parseFloat(this.js_round(amt, 2));
            var increaseAmt = amt + originalamount;
            increaseAmt = parseFloat(this.js_round(increaseAmt, 2));
            if (increaseAmt.toFixed(2) < this.listdealfunding[rowindex].Value) {
                this.CustomAlert("You have increased the draw amount more than 5% for the funding date(s) - " + this.convertDateToBindable(this.listdealfunding[rowindex].Date) + ". It will reset the status to Under Review.");
            }
        }
    };
    DealDetailComponent.prototype.ChangeFundingAmountCopied = function (rowindex) {
        var dt = "";
        var originalamount = this.originallistdealfunding[rowindex].Value;
        var amt = originalamount * .05;
        amt = parseFloat(this.js_round(amt, 2));
        var increaseAmt = amt + originalamount;
        increaseAmt = parseFloat(this.js_round(increaseAmt, 2));
        if (increaseAmt.toFixed(2) < this.listdealfunding[rowindex].Value) {
            dt = this.convertDateToBindable(this.listdealfunding[rowindex].Date);
        }
        return dt;
    };
    DealDetailComponent.prototype.js_round = function (num, dec) {
        var num_sign = num >= 0 ? 1 : -1;
        return (Math.round((num * Math.pow(10, dec)) + (num_sign * 0.0001)) / Math.pow(10, dec)).toFixed(dec);
    };
    DealDetailComponent.prototype.ConvertpastedBindableDate = function (Data) {
        var options = { year: "numeric", month: "numeric", day: "numeric" };
        for (var i = 0; i < Data.length; i++) {
            if (this.listdealfunding[i].Date != null && this.listdealfunding[i].Date != undefined && this.listdealfunding[i].Date.toString() != "Invalid Date" && this.listdealfunding[i].Date.toString() != "") {
                this.listdealfunding[i].Date = new Date(Data[i].Date.toString());
            }
        }
    };
    DealDetailComponent.prototype.chkDateValidation = function () {
        this._errorMsgDateValidation = "";
        //if (this._isConvertDate == false)
        {
            if (this._deal.AppReceived != null) {
                this.chkDateValidationToControl(this._deal.AppReceived, "AppReceived");
            }
            if (this._deal.EstClosingDate != null) {
                this.chkDateValidationToControl(this._deal.EstClosingDate, "EstClosingDate");
            }
            if (this._deal.FullyExtMaturityDate != null) {
                this.chkDateValidationToControl(this._deal.FullyExtMaturityDate, "FullyExtMaturityDate");
            }
        }
        //Grid control validation
        {
            this.convertDatetoGMTGrid(this._deal.PayruleDealFundingList, 'dealPayruleDealFundingList');
            this.convertDatetoGMTGrid(this.lstNote, 'lstNote');
        }
        return true;
    };
    DealDetailComponent.prototype.chkDateValidationToControl = function (date, moduleName) {
        if (date != null) {
            var controlDate = new Date(date); //.toDateString()
            var systemDate = new Date(this.utilityService.getDateMinRange());
            if (controlDate < systemDate) {
                //alert('1111firstDate ' + controlDate + ' secondDate ' + systemDate);
                this._errorMsgDateValidation += moduleName + ", ";
            }
            return "";
        }
        else
            return "";
    };
    DealDetailComponent.prototype.chkDateValidationToGrid = function (Data, modulename) {
        switch (modulename) {
            case "lstNote":
                for (var i = 0; i < Data.length; i++) {
                    if (this.lstNote[i].FirstPaymentDate != null) {
                        this.chkDateValidationToControl(this.lstNote[i].FirstPaymentDate, modulename + " FirstPaymentDate");
                    }
                    if (this.lstNote[i].InitialInterestAccrualEndDate != null) {
                        this.chkDateValidationToControl(this.lstNote[i].InitialInterestAccrualEndDate, modulename + " InitialInterestAccrualEndDate");
                    }
                    if (this.lstNote[i].ClosingDate != null) {
                        this.chkDateValidationToControl(this.lstNote[i].ClosingDate, modulename + " ClosingDate");
                    }
                    if (this.lstNote[i].InitialMaturityDate != null) {
                        this.chkDateValidationToControl(this.lstNote[i].InitialMaturityDate, modulename + " InitialMaturityDate");
                    }
                    if (this.lstNote[i].ExtendedMaturityCurrent != null) {
                        this.chkDateValidationToControl(this.lstNote[i].ExtendedMaturityCurrent, modulename + " ExtendedMaturityCurrent");
                    }
                }
                break;
            case "dealPayruleDealFundingList":
                for (var i = 0; i < Data.length; i++) {
                    if (this._deal.PayruleDealFundingList[i].Date != null) {
                        this.chkDateValidationToControl(this._deal.PayruleDealFundingList[i].Date, modulename + " dealPayruleDealFundingList");
                    }
                }
                break;
            default:
                break;
        }
    };
    DealDetailComponent.prototype.DeleteDataManagementDropdown = function (newvalue) {
        var selectedText = newvalue.target.text;
        selectedText = selectedText.trim();
        this.deleteoptiontext = selectedText.replace('delete', '').trim();
        var LookupID = this.lstDealDeleteFilter.filter(function (x) { return x.Name == selectedText; })[0].LookupID;
        var customdialogbox = document.getElementById('customdialogbox');
        this._moduledelete.ModuleID = this._deal.DealID;
        this._moduledelete.ModuleName = 'Deal';
        this._moduledelete.LookupID = LookupID;
        this._MsgText = 'Are you sure you want to delete ' + selectedText + ' for deal ' + this._deal.CREDealID + '?';
        customdialogbox.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    DealDetailComponent.prototype.ClosePopUpDeleteOption = function () {
        var modal = document.getElementById('customdialogbox');
        modal.style.display = "none";
    };
    DealDetailComponent.prototype.ClosePopUpDialog = function () {
        var modal = document.getElementById('Genericdialogbox');
        modal.style.display = "none";
    };
    DealDetailComponent.prototype.ClosePopUpDialogPara = function (id) {
        var modal = document.getElementById(id);
        modal.style.display = "none";
    };
    DealDetailComponent.prototype.ClosePopUpUseRule = function () {
        var _this = this;
        if (this.noteFundingId) {
            this.lstSequenceHistory.find(function (x) { return x.NoteID == _this.noteFundingId; }).UseRuletoDetermineNoteFunding = "3";
            this.lstSequenceHistory.find(function (x) { return x.NoteID == _this.noteFundingId; }).UseRuletoDetermineNoteFundingText = "Y";
        }
        else {
            this.lstSequenceHistory[0].UseRuletoDetermineNoteFundingText = "Y";
        }
        this.ShowUseRuleN = false;
        setTimeout(function () {
            this.grdflexDynamicColForSequence.invalidate();
        }.bind(this), 100);
        var modal = document.getElementById('UseRuledialogbox');
        modal.style.display = "none";
    };
    DealDetailComponent.prototype.UseRule = function () {
        var objdeal = new deals_1.deals('');
        objdeal.DealID = this._deal.DealID;
        objdeal.ShowUseRuleN = true;
        this._isautospreadshow = false;
        this.checked = false;
        this._deal.EnableAutoSpread = false;
        if (this._deal.EnableAutospreadRepayments == true) {
            this._isautospreadRepaymentshow = true;
        }
        else {
            this._isautospreadRepaymentshow = false;
        }
        this.ShowUseRuleN = true;
        this.GetDealFundingByDealID(objdeal);
        setTimeout(function () {
            var modal = document.getElementById('UseRuledialogbox');
            modal.style.display = "none";
        }.bind(this), 1000);
    };
    //showFundingCommentEmptyAlert(comment, BoxDocumentLink, dealFundingID) {
    DealDetailComponent.prototype.showFundingCommentEmptyAlert = function (comment, BoxDocumentLink, dealFundingID, date, amount) {
        var workflowstring = "";
        var _validation = false;
        var workflowerror = "";
        if (comment == '' || comment == null || comment == undefined) {
            workflowstring = workflowstring + "Inputting a Comment,";
            _validation = true;
        }
        if (BoxDocumentLink == null || BoxDocumentLink == '') {
            workflowstring = workflowstring + " Box document link ";
            _validation = true;
        }
        if (_validation == true) {
            workflowerror = workflowerror + "<p>" + workflowstring.slice(0, -1) + " is mandatory for the workflow process." + "</p>";
            this.CustomAlert(workflowerror);
        }
        else {
            for (var i = 0; i < this.listdealfunding.length; i++) {
                if (dealFundingID == this.listdealfunding[i].DealFundingID) {
                    if (!(Number(this.listdealfunding[i].PurposeText).toString() == "NaN" || Number(this.listdealfunding[i].PurposeText) == 0)) {
                        this.listdealfunding[i].PurposeID = Number(this.listdealfunding[i].PurposeText);
                    }
                    if (comment != this.listdealfunding[i].OldComment || BoxDocumentLink != this.OldBoxDocumentLink
                        || this.convertDateToBindable(date) != this.convertDateToBindable(this.listdealfundingwithoutchange[i].Date) || amount != this.listdealfundingwithoutchange[i].Value
                        || this.listdealfunding[i].PurposeID != this.listdealfundingwithoutchange[i].PurposeID) {
                        this.CustomAlert("Please save the deal after adding date, amount, comment, purpose type, box document link and then proceed with workflow.");
                    }
                    else {
                        this._router.navigate(['/workflowdetail', dealFundingID, 502]);
                    }
                }
            }
        }
    };
    DealDetailComponent.prototype.ShowPopUpArchive = function (docid, docname) {
        this._uploadedDocumentLogID = docid;
        this._MsgText = 'Are you sure you want to archive ' + docname + '?';
        var modal = document.getElementById('customdialogarchive');
        modal.style.display = "block";
    };
    DealDetailComponent.prototype.ClosePopUpArchive = function () {
        var modal = document.getElementById('customdialogarchive');
        modal.style.display = "none";
    };
    DealDetailComponent.prototype.deleteModuleByID = function () {
        var _this = this;
        this._isDeleteOPtionOk = true;
        this.ClosePopUpDeleteOption();
        this.dealSrv.deleteModuleByID(this._moduledelete)
            .subscribe(function (res) {
            if (res.Succeeded) {
                localStorage.setItem('ShowDeleteMsg', JSON.stringify(true));
                localStorage.setItem('divdeleteMsgDeal', JSON.stringify(_this.deleteoptiontext + ' for deal ' + _this._deal.CREDealID + ' deleted successfully'));
                _this._isDeleteOPtionOk = false;
                var currentdealurl;
                if (window.location.href.indexOf("dealdetail/a/") > -1) {
                    currentdealurl = ['dealdetail', _this._deal.CREDealID];
                }
                else {
                    currentdealurl = ['dealdetail/a', _this._deal.CREDealID];
                }
                if (currentdealurl.indexOf("/invoice") > -1)
                    _this._router.navigate(currentdealurl.replace("/invoice", ""));
                else
                    _this._router.navigate(currentdealurl);
            }
            else {
                _this.ClosePopUpDeleteOption();
                _this._isDeleteOPtionOk = false;
                _this.utilityService.navigateToSignIn();
            }
        }, function (error) { return console.error('Error: ' + error); });
    };
    DealDetailComponent.prototype.Savedialogbox = function () {
        // this._deal.amort.Flag_BasicDealSave = 1;
        //this._deal.amort.Flag_DealFundingSave = 1;
        //this._deal.amort.Flag_NoteSaveFromDealDetail = 1;
        //this._deal.amort.Flag_DealAmortSave = 0;
        this.Savedeals(this._deal);
        this.ClosePopUpDialog();
    };
    ///////// Doc Import ///////////////////
    DealDetailComponent.prototype.onAction = function (event) {
        this.actionLog += "\n currentFiles: " + this.getFileNames(event.currentFiles);
        //let fileList: FileList = event.currentFiles;
        this.fileList = event.currentFiles;
        //this.saveFiles(this.fileList);
    };
    DealDetailComponent.prototype.onAdded = function (event) {
        this.actionLog += "\n FileInput: " + event.id;
        this.actionLog += "\n Action: File added";
    };
    DealDetailComponent.prototype.onRemoved = function (event) {
        this.actionLog += "\n FileInput: " + event.id;
        this.actionLog += "\n Action: File removed";
    };
    DealDetailComponent.prototype.onInvalidDenied = function (event) {
        this.actionLog += "\n FileInput: " + event.id;
        this.actionLog += "\n Action: File denied";
    };
    DealDetailComponent.prototype.onCouldNotRemove = function (event) {
        this.actionLog += "\n FileInput: " + event.id;
        this.actionLog += "\n Action: Could not remove file";
    };
    DealDetailComponent.prototype.resetFileInput = function () {
        this.ng2FileInputService.reset(this.myFileInputIdentifier);
    };
    DealDetailComponent.prototype.logCurrentFiles = function () {
        var files = this.ng2FileInputService.getCurrentFiles(this.myFileInputIdentifier);
        this.actionLog += "\n The currently added files are: " + this.getFileNames(files);
    };
    DealDetailComponent.prototype.getFileNames = function (files) {
        var names = files.map(function (file) { return file.name; });
        return names ? names.join(", ") : "No files currently added.";
    };
    DealDetailComponent.prototype.isValidFiles = function (files) {
        // Check Number of files
        if (files.length > this.maxFiles) {
            this.errors.push("At a time you can upload only " + this.maxFiles + " file <BR/>");
            return;
        }
        this.isValidFileExtension(files);
        return this.errors.length === 0;
    };
    DealDetailComponent.prototype.isValidFileExtension = function (files) {
        // Make array of file extensions
        var extensions = (this.fileExt.split(','))
            .map(function (x) { return x.toLocaleUpperCase().trim(); });
        for (var i = 0; i < files.length; i++) {
            // Get file extension
            var ext = files[i].name.toUpperCase().split('.').pop() || files[i].name;
            // Check the extension exists
            var exists = extensions.includes(ext);
            if (!exists) {
                this.errors.push("<BR/>Please upload file " + files[i].name + " with " + this.fileExt + " extension.");
            }
            // Check file size
            this.isValidFileSize(files[i]);
        }
    };
    DealDetailComponent.prototype.isValidFileSize = function (file) {
        var fileSizeinMB = file.size / (1024 * 1000);
        var size = Math.round(fileSizeinMB * 100) / 100; // convert upto 2 decimal place
        if (size > this.maxSize)
            this.errors.push("<BR/>Selected: " + file.name + ": exceed file size limit of " + this.maxSize + "MB ( " + size + "MB )");
    };
    DealDetailComponent.prototype.getUsersByRoleName = function () {
        var _this = this;
        this.membershipService.getusersbyrolename('Asset Manager').subscribe(function (res) {
            if (res.Succeeded) {
                _this.lstAssetManagers = res.UserList;
            }
        });
    };
    DealDetailComponent.prototype.ChangeAM = function (newvalue) {
        this._deal.AssetManagerID = newvalue;
    };
    DealDetailComponent.prototype.ChangeAMTeamLeadUserID = function (newvalue) {
        this._deal.AMTeamLeadUserID = newvalue;
    };
    DealDetailComponent.prototype.ChangeAMSecondUserID = function (newvalue) {
        this._deal.AMSecondUserID = newvalue;
    };
    DealDetailComponent.prototype.ImportDocument = function () {
        this.saveFiles();
    };
    DealDetailComponent.prototype.saveFiles = function () {
        var _this = this;
        this.isProcessComplete = true;
        var files = this.fileList;
        this.errors = []; // Clear error
        if (!(Boolean(files)) || files == null || files.length == 0) {
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
                comment: this._document.Comment,
                documentTypeID: this._document.DocumentTypeID,
                ObjectID: this._deal.DealID,
                ObjectTypeID: 283,
                StorageType: appsettings_1.AppSettings._storageType,
                FolderName: this._deal.CREDealID,
                ParentFolderName: ''
            };
            this.fileUploadService.uploadObjectDocumentByStorageType(formData, parameters)
                .subscribe(function (res) {
                if (res.Succeeded) {
                    console.log(res);
                    _this.IsOpenActivityTab = false;
                    var smessage = res.Message.split('==');
                    if (smessage[0] == "Success") {
                        _this.uploadStatus.emit(true);
                        _this._Showmessagediv = true;
                        _this._ShowmessagedivMsg = "File uploaded successfully";
                        setTimeout(function () {
                            this._Showmessagediv = false;
                            this._ShowmessagedivMsg = "";
                            //   console.log(this._ShowmessagedivWar);
                        }.bind(_this), 5000);
                        //this._router.navigate(['/dashboard']);
                        //call load document function
                        //reset ng2-file-input control after error occoured
                        _this.resetFileInput();
                        //alert('getDocumentList');
                        _this._pageIndexDocImport = 1;
                        _this.getDocumentList();
                        _this._document.DocumentTypeID = "406";
                        _this._document.Comment = '';
                    }
                }
                else {
                    _this.uploadStatus.emit(true);
                    // console.log(success);
                    _this._ShowmessagedivWar = true;
                    _this._ShowmessagedivMsgWar = smessage[1];
                    //this.isProcessComplete = false;
                    setTimeout(function () {
                        this._ShowmessagedivWar = false;
                    }.bind(_this), 5000);
                    //reset ng2-file-input control after error occoured
                    _this.resetFileInput();
                }
                _this.isProcessComplete = false;
                _this.fileList = null;
            }, function (error) {
                console.log(error);
                _this.isProcessComplete = false;
                _this.uploadStatus.emit(true);
                _this.errors.push(error.ExceptionMessage);
            });
        }
    };
    DealDetailComponent.prototype.DocumentTypeIDChange = function (newvalue) {
        this._document.DocumentTypeID = newvalue;
    };
    DealDetailComponent.prototype.ArchiveDocument = function () {
        var _this = this;
        this._isListFetching = true;
        var lstDoc = this.lstDocuments.filter(function (x) { return x.UploadedDocumentLogID == _this._uploadedDocumentLogID; });
        lstDoc.forEach(function (obj, i) { obj.Status = 423; });
        if (lstDoc.length > 0) {
            this.fileUploadService.updateDocumentStatus(lstDoc).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.ClosePopUpArchive();
                    _this.getDocumentList();
                    _this._isListFetching = false;
                    _this._Showmessagediv = true;
                    _this._ShowmessagedivMsg = "File archived successfully";
                    setTimeout(function () {
                        this._Showmessagediv = false;
                        this._ShowmessagedivMsg = "";
                        //   console.log(this._ShowmessagedivWar);
                    }.bind(_this), 5000);
                }
                else {
                    _this.utilityService.navigateToSignIn();
                }
            });
            (function (error) {
                _this._isListFetching = false;
                console.error('Error: ' + error);
                _this.ClosePopUpArchive();
            });
        }
    };
    DealDetailComponent.prototype.getDocumentList = function () {
        var _this = this;
        this._isListFetching = true;
        this._document.ObjectTypeID = '283';
        this._document.ObjectID = this._deal.DealID;
        var d = new Date();
        var datestring = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate() + " " +
            d.getHours() + ":" + d.getMinutes();
        this._document.CurrentTime = datestring;
        this._document.Status = 1;
        this.fileUploadService.getDocumentsByObjectId(this._document, this._pageIndexDocImport, this._pageSizeDocImport).subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.lstDocument;
                _this._totalCountDocImport = res.TotalCount;
                if (_this._pageIndexDocImport == 1) {
                    _this.lstDocuments = data;
                    if (_this._totalCountDocImport == 0) {
                        _this._dvEmptyDocumentMsg = true;
                    }
                    else {
                        _this._dvEmptyDocumentMsg = false;
                    }
                }
                else {
                    _this.lstDocuments = _this.lstDocuments.concat(data);
                }
                _this._isListFetching = false;
                setTimeout(function () {
                    this.flexDocument.invalidate();
                    //remove first cell selection
                    this.flexDocument.selectionMode = wjcGrid.SelectionMode.None;
                    //this.flexDocument.autoSizeColumns(0, this.flexDocument.columns.length, false, 20);
                    //this.flexDocument.columns[0].width = 350; // for Note Id
                    this.addScrollHandler();
                }.bind(_this), 100);
            }
            else {
                _this.utilityService.navigateToSignIn();
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    DealDetailComponent.prototype.showDocImport = function () {
        var _this = this;
        this._isListFetching = true;
        localStorage.setItem('ClickedTabId', 'aImport');
        if (!this.IsOpenDocImportTab) {
            setTimeout(function () {
                _this.getDocumentList();
                _this.IsOpenDocImportTab = true;
                //if (this.flexDocument) {
                //    this.flexDocument.invalidate(true);
                //    this.flexDocument.autoSizeColumns();
                //}
            }, 200);
        }
        setTimeout(function () {
            _this._isListFetching = false;
        }, 1000);
    };
    DealDetailComponent.prototype.addScrollHandler = function () {
        var _this = this;
        if (!this.isScrollHandlerAdded) {
            this.flexDocument.scrollPositionChanged.addHandler(function () {
                var myDiv = $('#flexDocument').find('div[wj-part="root"]');
                if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
                    if (_this.flexDocument.rows.length < _this._totalCountDocImport) {
                        _this._pageIndexDocImport = _this._pageIndexDocImport + 1;
                        _this.IsOpenDocImportTab = false;
                        _this.showDocImport();
                    }
                }
            });
            this.isScrollHandlerAdded = true;
        }
    };
    DealDetailComponent.prototype.getDealActivity = function () {
        var _this = this;
        this._isListFetching = true;
        localStorage.setItem('ClickedTabId', 'aActivitytab');
        try {
            if (!this.IsOpenActivityTab) {
                this.activityMessage = '';
                // this._isListFetching = true;
                setTimeout(function () {
                    var d = new Date();
                    var datestring = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate() + " " +
                        d.getHours() + ":" + d.getMinutes();
                    _this._activityLog.ModuleID = _this._deal.DealID;
                    _this._activityLog.ModuleTypeID = 283;
                    _this._activityLog.Currentdate = datestring;
                    _this.noteSrv.getActivityLogByModuleId(_this._activityLog, _this._pageIndexActivity, _this._pageSizeActivity).subscribe(function (res) {
                        if (res.Succeeded) {
                            _this.lstActivityLog = res.lstActivityLog;
                            _this.currentactivity = res.lstActivityLog;
                            _this._totalCountActivity = res.TotalCount;
                            var tdate = new Date().toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                            var yd = new Date();
                            yd.setDate(yd.getDate() - 1);
                            var ydate = new Date(yd.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                            if (_this._pageIndexActivity == 1) {
                                _this.arrActivityToday = res.lstActivityLog.filter(function (x) { return new Date(x.CreatedDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" }) == tdate; });
                                _this.arrActivityYesterday = res.lstActivityLog.filter(function (x) { return new Date(x.CreatedDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" }) == ydate; });
                            }
                            else {
                                _this.arrActivityTodayMore = res.lstActivityLog.filter(function (x) { return new Date(x.CreatedDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" }) == tdate; });
                                _this.arrActivityTodayMore = _this.arrActivityTodayMore.filter(function (val) { return !_this.arrActivityToday.includes(val); });
                                _this.arrActivityYesterdayMore = res.lstActivityLog.filter(function (x) { return new Date(x.CreatedDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" }) == ydate; });
                                _this.arrActivityYesterdayMore = _this.arrActivityYesterdayMore.filter(function (val) { return !_this.arrActivityYesterday.includes(val); });
                            }
                            _this.arrActivityToday = _this.arrActivityToday.concat(_this.arrActivityTodayMore);
                            _this.arrActivityYesterday = _this.arrActivityYesterday.concat(_this.arrActivityYesterdayMore);
                            _this.CurrentcountActivity = _this.CurrentcountActivity + _this.currentactivity.length;
                            if (_this.lstActivityLog.length == 0) {
                                _this.activityMessage = "No activities found";
                            }
                            else {
                                _this.currentactivity = _this.currentactivity.filter(function (x) { return new Date(x.CreatedDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" }) != tdate; });
                                _this.currentactivity = _this.currentactivity.filter(function (x) { return new Date(x.CreatedDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" }) != ydate; });
                                _this.arrActivity = _this.arrActivity.concat(_this.currentactivity);
                                if (_this.arrActivityToday.length > 0) {
                                    _this.isActivityTday = true;
                                }
                                if (_this.arrActivityYesterday.length > 0) {
                                    _this.isActivityYday = true;
                                }
                                if (_this.arrActivity.length > 0) {
                                    _this.isActivityPday = true;
                                }
                            }
                            _this._isListFetching = false;
                        }
                        else {
                            _this._router.navigate(['login']);
                        }
                    });
                    _this.IsOpenActivityTab = true;
                }, 200);
            }
            this._isListFetching = false;
        }
        catch (err) {
            this._isListFetching = false;
        }
    };
    DealDetailComponent.prototype.getPayoffDatabyurl = function () {
        var xhr = new XMLHttpRequest();
        xhr.withCredentials = true;
        var that = this;
        xhr.addEventListener("readystatechange", function () {
            if (this.readyState === 4) {
                var data = this.responseText;
                console.log(this.responseText);
                //that.iframePayoff.src = data;
                that.iframePayoffData.nativeElement.src = data;
            }
        });
        xhr.open("GET", "https://acore.m61systems.com/prepayment/statement?dealid=fdd8ec03-9d63-4512-9990-89c508983edc");
        xhr.setRequestHeader("Authorization", "Basic Q1JFUzpNU2l4dHkxQDIwMjBD");
        xhr.setRequestHeader("Access-Control-Allow-Credentials", "true");
        xhr.send();
    };
    DealDetailComponent.prototype.postPayoffData = function () {
        var _this = this;
        //call you API - Pushp
        try {
            var iframeUrl = 'https://acore.m61systems.com/api/prepayment/statement';
            var iframeTokenKey = 'Authorization';
            var iframeTokenValue = 'Basic Q1JFUzpNU2l4dHkxQDIwMjBD';
            this._isListFetching = true;
            this.dealSrv.GetPayloadData(this._deal).subscribe(function (res) {
                if (res.Succeeded) {
                    var _payoff = res.Payload;
                    var data = JSON.stringify(_payoff);
                    //this.CustomAlert(data);
                    var xhr = new XMLHttpRequest();
                    //xhr.withCredentials = true;
                    var that = _this;
                    xhr.addEventListener("readystatechange", function () {
                        if (this.readyState === 4) {
                            console.log(this.responseText);
                            that.getPayoffData();
                        }
                    });
                    xhr.open("POST", iframeUrl);
                    xhr.setRequestHeader("Content-Type", "application/json");
                    xhr.setRequestHeader("Authorization", "Basic Q1JFUzpNU2l4dHkxQDIwMjBD");
                    xhr.send(data);
                    //this.dealSrv.PostPayoffIframeData(_payoff, iframeUrl, iframeTokenKey, iframeTokenValue).subscribe(res => {
                    //    if (res.Succeeded) {
                    //        this.getPayoffData();
                    //        this._isListFetching = false;
                    //    }
                    //    else {
                    //        // this._router.navigate(['login']);
                    //    }
                    //});
                }
                else {
                    // this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
            this._router.navigate(['login']);
        }
    };
    DealDetailComponent.prototype.getPayoffData = function () {
        var _this = this;
        try {
            var _dealId = this._deal.DealID;
            var iframeUrl = 'https://acore.m61systems.com?dealid=' + _dealId + '&token==REVWOk1TaXh0eTFAMjAyMA==';
            //var iframeUrl = 'https://acore.m61systems.com/prepayment/statement?dealid=' + _dealId;  //fdd8ec03-9d63-4512-9990-89c508983edc
            //var iframeTokenKey = 'Authorization';
            //var iframeTokenValue = 'Basic Q1JFUzpNU2l4dHkxQDIwMjBD';
            this._isListFetching = true;
            //this.dataSrv.getIframeData(iframeUrl)
            //    .subscribe(blob => this.iframePayoffData.nativeElement.src = blob);
            setTimeout(function () {
                _this._isListFetching = false;
            }, 2000);
            this.urlSafe = this.sanitizer.bypassSecurityTrustResourceUrl(iframeUrl);
            //this.urlSafe = this.sanitizer.bypassSecurityTrustResourceUrl("https://acore.m61systems.com?dealid=1fd23dfd-9739-48e5-8c4d-20a6015a77ae&token==REVWOk1TaXh0eTFAMjAyMA==");
        }
        catch (err) {
            this._router.navigate(['login']);
        }
    };
    DealDetailComponent.prototype.onScrollActivity = function () {
        //For paginging ----uncomment below code
        var myDiv = $('#activityMainDiv');
        if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
            if (this.CurrentcountActivity < this._totalCountActivity) {
                this._pageIndexActivity = this._pageIndexActivity + 1;
                this.IsOpenActivityTab = false;
                this.getDealActivity();
            }
        }
    };
    DealDetailComponent.prototype.onScrollDocImport = function () {
        //For paginging ----uncomment below code
        var myDiv = $('#docimportMainDiv');
        if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
            if (this.CurrentcountDocImport < this._totalCountDocImport) {
                this._pageIndexDocImport = this._pageIndexDocImport + 1;
                this.IsOpenDocImportTab = false;
                this.showDocImport();
            }
        }
    };
    DealDetailComponent.prototype.getnexybusinessDate = function (sDate, noofDays) {
        var daycnt = sDate.getDay();
        if (daycnt == 6)
            sDate.setDate(sDate.getDate() + 1);
        if (daycnt == 1 || daycnt == 2 || daycnt == 3 || daycnt == 4 || daycnt == 5)
            sDate.setDate(sDate.getDate() + 2);
        sDate.setDate(sDate.getDate() + noofDays);
        return sDate;
    };
    DealDetailComponent.prototype.getPreviousWorkingDate = function (sDate) {
        var _this = this;
        if (sDate.getFullYear() < 2000) {
            sDate = null;
        }
        else {
            if (sDate) {
                var i = 0;
                var isCompleted = false;
                while (i < 7) {
                    var daycnt = sDate.getDay();
                    var formateddate = this.convertDateToBindable(sDate);
                    if (daycnt == 6 || daycnt == 0 || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411; }).length > 0) {
                        sDate.setDate(sDate.getDate() - 1);
                        isCompleted = true;
                    }
                    else {
                        if (!isCompleted) {
                            sDate.setDate(sDate.getDate() - 1);
                            isCompleted = true;
                        }
                    }
                    i++;
                }
            }
        }
        return sDate;
    };
    DealDetailComponent.prototype.getnextbusinessDate = function (sDate, noofDays, addorsub) {
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
    DealDetailComponent.prototype.DownloadDocument = function (filename, originalfilename, storagetype, documentStorageID) {
        var _this = this;
        this.isProcessComplete = true;
        documentStorageID = documentStorageID === undefined ? '' : documentStorageID;
        var ID = '';
        if (storagetype == 'Box')
            ID = documentStorageID;
        else if (storagetype == 'AzureBlob')
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
            alert('Something went wrong');
            _this.isProcessComplete = false;
            ;
        });
    };
    DealDetailComponent.prototype.downloadWellsExportData = function () {
        var _this = this;
        this._isListFetching = true;
        this.fileUploadService.importWellsDataByDealID(this._deal.CREDealID).subscribe(function (fileData) {
            var b = new Blob([fileData]);
            //var url = window.URL.createObjectURL(b);
            //window.open(url);
            var displayDate = new Date().toLocaleDateString("en-US");
            var fileName = "M61_Wells_Export_" + _this._deal.CREDealID + "_" + displayDate + ".xlsx";
            var dwldLink = document.createElement("a");
            var url = URL.createObjectURL(b);
            var isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
            if (isSafariBrowser) { //if Safari open in new window to save file with random filename.
                dwldLink.setAttribute("target", "_blank");
            }
            dwldLink.setAttribute("href", url);
            dwldLink.setAttribute("download", fileName);
            dwldLink.style.visibility = "hidden";
            document.body.appendChild(dwldLink);
            dwldLink.click();
            document.body.removeChild(dwldLink);
            _this._isListFetching = false;
        }, function (error) {
            alert('Something went wrong');
            _this._isListFetching = false;
            ;
        });
    };
    DealDetailComponent.prototype.GetAllFeeAmount = function () {
        var _this = this;
        this.feeconfigurationSrv.GetPayRuleDropDownFeeSchedules().subscribe(function (res) {
            if (res.Succeeded) {
                _this.listfeeamount = [];
                var data = res.lstFeeSchedulesConfig;
                _this.listfeeamount = data;
                _this._bindGridDropdowsWithoutLookup();
            }
        });
    };
    DealDetailComponent.prototype.GetAppConfigByKey = function () {
        var _this = this;
        this.permissionService.GetAllowBasiclogin("EnableM61Calculator").subscribe(function (res) {
            if (res.Succeeded) {
                var AllowBasicLogin = res.AllowBasicLogin;
                if (AllowBasicLogin.Value == "0")
                    _this._deal.EnableM61Calculator = false;
                else
                    _this._deal.EnableM61Calculator = true;
            }
        });
    };
    DealDetailComponent.prototype.getAllDistinctScenario = function () {
        var _this = this;
        var _userData = JSON.parse(localStorage.getItem('user'));
        this._scenariodc.UserID = _userData.UserID;
        this.scenarioService.getAllScenarioDistinct(this._scenariodc).subscribe(function (res) {
            if (res.Succeeded) {
                if (res.lstScenarioUserMap.length > 0) {
                    _this._lstScenario = res.lstScenarioUserMap;
                    _this.ScenarioId = res.lstScenarioUserMap.filter(function (x) { return x.ScenarioName == "Default"; })[0].AnalysisID;
                    // this._ruletype.AnalysisID = this.ScenarioId;
                }
            }
        });
    };
    DealDetailComponent.prototype.getAutoSpreadRuleByDealID = function (_objdeals) {
        var _this = this;
        this.showEquitysummary = true;
        this._deal.DealID = _objdeals.DealID;
        this.dealSrv.GetAutoSpreadRuleByDealID(_objdeals).subscribe(function (res) {
            if (res.Succeeded) {
                var data = res._autospreadrule;
                _this.lstautospreadrule = data;
                _this.checked = true;
                _this.ConvertToBindableDateAutoSpread(_this.lstautospreadrule);
                _this.autospreadrulelist = new wjcCore.CollectionView(_this.lstautospreadrule);
                _this.autospreadrulelist.trackChanges = true;
                setTimeout(function () {
                    this.flexautospreadrule.invalidate();
                }.bind(_this), 2000);
            }
        });
    };
    DealDetailComponent.prototype.onChangeEnableAutoSpreadFundingsCheckbox = function (e) {
        this._isdealfundingChanged = false;
        var checked = e.target.checked;
        if (checked == true) {
            var _lstUseRuleN = this.lstSequenceHistory.filter(function (x) { return x.UseRuletoDetermineNoteFundingText == "4" || x.UseRuletoDetermineNoteFundingText == "N" || x.UseRuletoDetermineNoteFundingText == null || x.UseRuletoDetermineNoteFundingText == ""; });
            this.showEquitysummary = true;
            //if (_lstUseRuleN.length != this.lstNote.length) {
            //    this.flexdealfunding.autoClipboard = false;
            //} else {
            //    this.flexdealfunding.autoClipboard = true;
            //}
            // this.flexdealfunding.autoClipboard = false;
            this.flexdealfunding.columns[9].isReadOnly = false;
            if (this.lstautospreadrule == null || this.lstautospreadrule == undefined) {
                this.getAutoSpreadRuleByDealID(this._deal);
            }
            else {
                this.checked = true;
                this.ConvertToBindableDateAutoSpread(this.lstautospreadrule);
                this.autospreadrulelist = new wjcCore.CollectionView(this.lstautospreadrule);
                this.autospreadrulelist.trackChanges = true;
                this.flexautospreadrule.invalidate();
            }
        }
        else if (checked == false) {
            this.showEquitysummary = false;
            // this.flexdealfunding.autoClipboard = true;
            this.autospreadrulelist = this.lstautospreadrule;
            this.checked = false;
        }
    };
    DealDetailComponent.prototype._bindGridDropdowsAuto = function () {
        var flexautospreadrule = this.flexautospreadrule;
        if (flexautospreadrule) {
            var colPurposeType = flexautospreadrule.getColumn('PurposeTypeText');
            var colDistributionMethod = flexautospreadrule.getColumn('DistributionMethodText');
            if (colPurposeType) {
                colPurposeType.showDropDown = true;
                colPurposeType.dataMap = this._buildDataMap(this.lstAutoSpreadPurposeType);
            }
            if (colDistributionMethod) {
                colDistributionMethod.showDropDown = true;
                colDistributionMethod.dataMap = this._buildDataMap(this.listautospreadrule);
            }
        }
    };
    DealDetailComponent.prototype.FormatWFStatusName = function (statusname) {
        if (statusname == null || statusname == "") {
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
    DealDetailComponent.prototype.GetNoteDetailForDealAmortByDealID = function (_objDeal) {
        var _this = this;
        try {
            this._isListFetching = true;
            this.dealSrv.GetNoteDetailForDealAmortByDealID(_objDeal).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.isAmortFirstLoad = true;
                    var headers = [];
                    _this.lstNoteListForDealAmort = res.dt;
                    var data = res.dt;
                    //this.ConvertToBindableDateDealAmort(this.lstNoteListForDealAmort);
                    _this.convertDatetoGMTGrid(_this.lstNoteListForDealAmort, "Deal AmortRule");
                    _this.AmortSeqcolumns = [];
                    $.each(data, function (obj) {
                        var i = 0;
                        $.each(data[obj], function (key, value) {
                            if (i > 22) {
                                headers[i] = key;
                            }
                            i = i + 1;
                        });
                    });
                    for (var k = 0; k < headers.length; k++) {
                        if (headers[k]) {
                            _this.AmortSeqcolumns.push({ "header": headers[k], "binding": headers[k], "format": 'n2', "width": 100, "aggregate": 'Sum', "allowEditing": true });
                        }
                    }
                    _this.showHideGenerateAmortButton();
                    _this.flexNoteListForDealAmort.invalidate();
                    _this.NoOfAmortSeq = 0;
                    if (!(_this._deal.amort.AmortizationMethod == 623 || _this._deal.amort.AmortizationMethodText == "IO Only")) {
                        _this.getDealAmortizationSchedule();
                    }
                    else {
                        _this._NoAmortSch = true;
                        _this.amorterrormsg = "There are no amortization records to show based on current amortization setup .";
                    }
                }
                else {
                    // this._router.navigate(['login']);
                }
            });
            return true;
        }
        catch (err) {
        }
    };
    DealDetailComponent.prototype.showHideGenerateAmortButton = function () {
        if (!(this._deal.amort.AmortizationMethod == 623 || this._deal.amort.AmortizationMethodText == "IO Only")) {
            if (this.lstNoteListForDealAmort.filter(function (x) { return x.UseRuletoDetermineAmortizationText == 'Y' || x.UseRuletoDetermineAmortizationText == '3'; }).length > 0) {
                this.IsShowAmortGenerate = true;
            }
            else {
                this.IsShowAmortGenerate = false;
            }
        }
        else {
            this.IsShowAmortGenerate = false;
        }
    };
    DealDetailComponent.prototype.CopiedAmortSchedule = function (flexamort, e) {
        this._isAmortSchChanges = true;
        if (e.col > 1) {
            if (flexamort.columns.length > 2) {
                for (var s = 0; s < this.lstAmortSchedule.length; s++) {
                    if (this.lstAmortSchedule[s]["Amount"]) {
                        this.lstAmortSchedule[s]["Amount"] = 0;
                    }
                    var sAmt = 0;
                    for (var i = 0; i < this.dynamicAmortColumn.length; i++) {
                        if (flexamort.rows[s]._data[this.dynamicAmortColumn[i]]) {
                            sAmt = sAmt + parseFloat(flexamort.rows[s]._data[this.dynamicAmortColumn[i]]);
                        }
                    }
                    if (sAmt > 0) {
                        this.lstAmortSchedule[s]["Amount"] = sAmt;
                    }
                }
            }
        }
        this.flexDealAmortizationSchedule.invalidate();
    };
    DealDetailComponent.prototype.GetTotalAmortAmount = function () {
        if (this.flexDealAmortizationSchedule.columns.length > 2) {
            for (var s = 0; s < this.lstAmortSchedule.length; s++) {
                if (this.lstAmortSchedule[s]["Amount"]) {
                    this.lstAmortSchedule[s]["Amount"] = 0;
                }
                var sAmt = 0;
                for (var i = 0; i < this.dynamicAmortColumn.length; i++) {
                    if (this.flexDealAmortizationSchedule.rows[s]._data[this.dynamicAmortColumn[i]]) {
                        sAmt = sAmt + parseFloat(this.flexDealAmortizationSchedule.rows[s]._data[this.dynamicAmortColumn[i]]);
                    }
                }
                if (sAmt > 0) {
                    this.lstAmortSchedule[s]["Amount"] = sAmt.toFixed(2);
                }
            }
        }
        this.flexDealAmortizationSchedule.invalidate();
    };
    DealDetailComponent.prototype.ConvertToBindableDateDealAmort = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this.lstNoteListForDealAmort[i].Maturity != null) {
                this.lstNoteListForDealAmort[i].Maturity = new Date(this.convertDateToBindable(this.lstNoteListForDealAmort[i].Maturity));
            }
            if (this.lstNoteListForDealAmort[i].ActualPayoffDate != null) {
                this.lstNoteListForDealAmort[i].ActualPayoffDate = new Date(this.convertDateToBindable(this.lstNoteListForDealAmort[i].ActualPayoffDate));
            }
            if (this.lstNoteListForDealAmort[i].FullyExtendedMaturityDate != null) {
                this.lstNoteListForDealAmort[i].FullyExtendedMaturityDate = new Date(this.convertDateToBindable(this.lstNoteListForDealAmort[i].FullyExtendedMaturityDate));
            }
            if (this.lstNoteListForDealAmort[i].InitialMaturityDate != null) {
                this.lstNoteListForDealAmort[i].InitialMaturityDate = new Date(this.convertDateToBindable(this.lstNoteListForDealAmort[i].InitialMaturityDate));
            }
        }
    };
    DealDetailComponent.prototype.convertDatetoGMTDateDealAmortization = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this.lstAmortSchedule[i].Date != null) {
                //  this.lstAmortSchedule[i].Date = new Date(this.convertDatetoGMT(this.lstAmortSchedule[i].Date));
                this.lstAmortSchedule[i].Date = this.convertDatetoGMT(this.lstAmortSchedule[i].Date);
            }
        }
    };
    DealDetailComponent.prototype.ConvertToBindableAmortSchedule = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            if (Data[i].Date != null) {
                Data[i].Date = new Date(this.convertDateToBindable(Data[i].Date));
            }
        }
    };
    DealDetailComponent.prototype.NextAmortSequenceToAdd = function () {
        var SequenceNo = 1;
        var NewSeqNo = 1;
        var binding = "Sequence";
        var Header = "Sequence ";
        this._isamortsequenceadded = true;
        //    console.log(' AmortSeqcolumns ' + this.AmortSeqcolumns.length);
        this.NoOfAmortSeqAdded = this.AmortSeqcolumns.length;
        this.NoOfAmortSeqAdded = this.NoOfAmortSeqAdded + 1;
        NewSeqNo = this.NoOfAmortSeqAdded;
        this.NoOfAmortSeq = this.NoOfAmortSeq + 1;
        var SeqNo = 0;
        if (this.NoOfAmortSeq <= 5) {
            SequenceNo = SeqNo + NewSeqNo;
            var header = Header + NewSeqNo;
            binding = binding + NewSeqNo;
            this.AmortSeqcolumns.push({ "header": header, "binding": binding, "format": 'n2', "width": 100, "aggregate": 'Sum', "allowEditing": true });
        }
        else {
            this._ShowmessagedivSequenceInfo = true;
            this._ShowmessagedivSequenceMsgInfo = "You can add only 5 sequences at a time. Please save the deal and try again.";
            setTimeout(function () {
                this._ShowmessagedivSequenceInfo = false;
            }.bind(this), 5000);
        }
    };
    DealDetailComponent.prototype.ConvertInAmortSequenceList = function () {
        this.lstAmortSequence = [];
        this.lstAmortSequence.push({ "NoteID": 0, "SequenceNo": 0, "SequenceType": 0, "Value": 0, "NoteName": 0 });
        for (var i = 0; i < this.lstNoteListForDealAmort.length; i++) {
            for (var j = 0; j < this.AmortSeqcolumns.length; j++) {
                if (this.lstNoteListForDealAmort[i].hasOwnProperty(this.AmortSeqcolumns[j].binding)) {
                    this.lstAmortSequence.push({ "NoteID": this.lstNoteListForDealAmort[i].NoteID, "SequenceNo": parseInt(this.AmortSeqcolumns[j].header.replace("Sequence ", "")), "SequenceType": 'AmortSequence', "Value": this.lstNoteListForDealAmort[i][this.AmortSeqcolumns[j].binding], "NoteName": this.lstNoteListForDealAmort[i].Name });
                }
            }
        }
        this.lstAmortSequence.splice(0, 1);
    };
    DealDetailComponent.prototype.getDealAmortizationSchedule = function () {
        var _this = this;
        this._isListFetching = true;
        this._deal.amort.NoteListForDealAmort = this.lstNoteListForDealAmort;
        var lstAmortNote = this._deal.amort.NoteListForDealAmort.filter(function (x) { return x.UseRuletoDetermineAmortizationText == 'Y' || x.UseRuletoDetermineAmortizationText == '3'; });
        this.dealSrv.GetAmortDealSchedulebyDealid(this._deal).subscribe(function (res) {
            _this._isListFetching = false;
            if (res.Succeeded) {
                _this._isListFetching = false;
                var data = res.dt;
                _this.lstAmortSchedule = data;
                // this.convertDatetoGMTGrid(this.lstAmortSchedule, "Deal Amortization");
                if (_this.lstAmortSchedule) {
                    _this.ConvertToBindableDateAmort(_this.lstAmortSchedule);
                }
                _this.columnsAmortSchedule = [];
                if (_this.dynamicAmortColumn.length > 0) {
                    for (var i = 0; i < lstAmortNote.length; i++) {
                        if (_this.columnsAmortSchedule.filter(function (x) { return x.header == lstAmortNote[i].Name; }).length == 0) {
                            _this.dynamicAmortColumn.push(lstAmortNote[i].Name);
                            _this.AddcolumnAmortSchedule(lstAmortNote[i].Name, lstAmortNote[i].Name, true);
                        }
                    }
                }
                else {
                    for (var i = 0; i < lstAmortNote.length; i++) {
                        _this.dynamicAmortColumn.push(lstAmortNote[i].Name);
                        _this.AddcolumnAmortSchedule(lstAmortNote[i].Name, lstAmortNote[i].Name, true);
                    }
                }
            }
            else {
                setTimeout(function () {
                    if (_this._NoAmortSch == true) {
                        _this.amorterrormsg = "There are no amortization records to show based on current amortization setup .";
                    }
                }, 2000);
            }
            setTimeout(function () {
                if (_this._deal.amort.AmortizationMethodText == "Custom Note Amortization" || _this._deal.amort.AmortizationMethod == 622) {
                    _this.flexDealAmortizationSchedule.columns[0].isReadOnly = true;
                    _this.flexDealAmortizationSchedule.columns[1].isReadOnly = true;
                    _this.flexDealAmortizationSchedule.invalidate();
                }
                if (_this._deal.amort.AmortizationMethodText == "Custom Deal Amortization" || _this._deal.amort.AmortizationMethod == 621) {
                    if (_this.flexDealAmortizationSchedule) {
                        _this.flexDealAmortizationSchedule.columns[0].isReadOnly = false;
                        _this.flexDealAmortizationSchedule.columns[1].isReadOnly = false;
                        for (var i = 2; i < _this.flexDealAmortizationSchedule.columns.length; i++) {
                            _this.flexDealAmortizationSchedule.columns[i].isReadOnly = true;
                        }
                        _this.flexDealAmortizationSchedule.invalidate();
                    }
                }
                if (_this._deal.amort.AmortizationMethodText == "Fixed Payment Amortization" || _this._deal.amort.AmortizationMethod == 619 || _this._deal.amort.AmortizationMethodText == "Straight Line Amortization" || _this._deal.amort.AmortizationMethodText == "Full Amortization by Rate & Term" || _this._deal.amort.AmortizationMethod == 618 || _this._deal.amort.AmortizationMethod == 620) {
                    if (_this.flexDealAmortizationSchedule) {
                        _this.flexDealAmortizationSchedule.isReadOnly = true;
                        _this.flexDealAmortizationSchedule.invalidate();
                    }
                }
                if (!_this.lstAmortSchedule) {
                    _this._NoAmortSch = true;
                }
                if (_this.lstAmortSchedule) {
                    if (_this.lstAmortSchedule.length == 0) {
                        _this._NoAmortSch = true;
                    }
                    else {
                        _this._NoAmortSch = false;
                    }
                }
                if (_this._NoAmortSch == true) {
                    _this.amorterrormsg = "There are no amortization records to show based on current amortization setup .";
                }
            }, 200);
        });
    };
    DealDetailComponent.prototype.ClosePopUpAmort = function () {
        var _this = this;
        if (this._actualAmortMethod == this._changedAmortMethod) {
            this._deal.amort.AmortizationMethod = this.listAmortizationMethod.find(function (x) { return x.Name == _this._actualAmortMethod; }).LookupID;
            this._deal.amort.AmortizationMethodText = this.listAmortizationMethod.find(function (x) { return x.LookupID == _this._deal.amort.AmortizationMethod; }).Name;
        }
        else if (this._changedAmortMethod) {
            this._deal.amort.AmortizationMethod = this.listAmortizationMethod.find(function (x) { return x.Name == _this._changedAmortMethod; }).LookupID;
            this._deal.amort.AmortizationMethodText = this.listAmortizationMethod.find(function (x) { return x.LookupID == _this._deal.amort.AmortizationMethod; }).Name;
        }
        else if (this._actualAmortMethod) {
            this._deal.amort.AmortizationMethod = this.listAmortizationMethod.find(function (x) { return x.Name == _this._actualAmortMethod; }).LookupID;
            this._deal.amort.AmortizationMethodText = this.listAmortizationMethod.find(function (x) { return x.LookupID == _this._deal.amort.AmortizationMethod; }).Name;
        }
        else if (this._actualAmortMethod == null) {
            this._deal.amort.AmortizationMethod = this._actualAmortMethod;
            this._deal.amort.AmortizationMethodText = this._actualAmortMethod;
        }
        var modal = document.getElementById('Amortdialogbox');
        modal.style.display = "none";
    };
    DealDetailComponent.prototype.AssignDropdownAmort = function (data) {
        for (var j = 0; j < this.lstNoteListForDealAmort.length; j++) {
            if (this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortizationText == '4' && this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortization == 3) {
                this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortizationText = 'N';
                this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortization = 4;
            }
            if (this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortizationText == '3' && this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortization == 4) {
                this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortizationText = 'Y';
                this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortization = 3;
            }
            if (this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortizationText == '3' && this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortization == 3) {
                this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortizationText = 'Y';
                this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortization = 3;
            }
            if (this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortizationText == '4' && this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortization == 4) {
                this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortizationText = 'N';
                this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortization = 4;
            }
            if (this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortizationText == '3' && this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortization == null) {
                this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortizationText = 'Y';
                this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortization = 3;
            }
            if (this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortizationText == '4' && this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortization == null) {
                this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortizationText = 'N';
                this.lstNoteListForDealAmort[j].UseRuletoDetermineAmortization = 4;
            }
            //-----RoundingNoteText
            if (this.lstNoteListForDealAmort[j].RoundingNoteText == '4' && this.lstNoteListForDealAmort[j].RoundingNote == 3) {
                this.lstNoteListForDealAmort[j].RoundingNoteText = 'N';
                this.lstNoteListForDealAmort[j].RoundingNote = 4;
            }
            if (this.lstNoteListForDealAmort[j].RoundingNoteText == '3' && this.lstNoteListForDealAmort[j].RoundingNote == 4) {
                this.lstNoteListForDealAmort[j].RoundingNoteText = 'Y';
                this.lstNoteListForDealAmort[j].RoundingNote = 3;
            }
            if (this.lstNoteListForDealAmort[j].RoundingNoteText == '3' && this.lstNoteListForDealAmort[j].RoundingNote == 3) {
                this.lstNoteListForDealAmort[j].RoundingNoteText = 'Y';
                this.lstNoteListForDealAmort[j].RoundingNote = 3;
            }
            if (this.lstNoteListForDealAmort[j].RoundingNoteText == '4' && this.lstNoteListForDealAmort[j].RoundingNote == 4) {
                this.lstNoteListForDealAmort[j].RoundingNoteText = 'N';
                this.lstNoteListForDealAmort[j].RoundingNote = 4;
            }
            if (this.lstNoteListForDealAmort[j].RoundingNoteText == '3' && this.lstNoteListForDealAmort[j].RoundingNote == null) {
                this.lstNoteListForDealAmort[j].RoundingNoteText = 'Y';
                this.lstNoteListForDealAmort[j].RoundingNote = 3;
            }
            if (this.lstNoteListForDealAmort[j].RoundingNoteText == '4' && this.lstNoteListForDealAmort[j].RoundingNote == null) {
                this.lstNoteListForDealAmort[j].RoundingNoteText = 'N';
                this.lstNoteListForDealAmort[j].RoundingNote = 4;
            }
        }
    };
    DealDetailComponent.prototype.amortizationDynamiccolbinding = function () {
        if (this.flexDealAmortizationSchedule) {
            for (var k = 0; k < this.flexDealAmortizationSchedule.columns.length; k++) {
                for (var m = 0; m < this.flexDealAmortizationSchedule.rows.length; m++) {
                    var colamountvalue = this.flexDealAmortizationSchedule.getCellData(m, 1, false);
                    var colname = this.flexDealAmortizationSchedule.columns[k].binding;
                    if (colname != "Amount" && colname != "Date") {
                        // var colvalue = this.flexDealAmortizationSchedule.getCellData(m, k, false);
                        var colvalue = this.lstAmortSchedule[m][colname];
                        if (colvalue) {
                            this.lstAmortSchedule[m][colname] = parseFloat(colvalue);
                        }
                        if (colamountvalue) {
                            this.lstAmortSchedule[m]["Amount"] = parseFloat(colamountvalue);
                        }
                    }
                }
            }
        }
    };
    DealDetailComponent.prototype.generateAmortization = function () {
        var _this = this;
        this.IsShowAmortGenerate = false;
        var amorterror = "";
        this._amortmsg = false;
        var seqtotal = 0;
        var noteseqtotal = 0;
        var errnotes = "";
        var yNoteCount = 0;
        var _isincludednote = "";
        var roundingnotecount = 0;
        var amortoverrideamount = this.lstNoteListForDealAmort.filter(function (x) { return x.StraightLineAmortOverride == null || x.StraightLineAmortOverride == 0; });
        if (!(Number(this._deal.amort.NoteDistributionMethodText).toString() == "NaN" || Number(this._deal.amort.NoteDistributionMethodText) == 0)) {
            this._deal.amort.NoteDistributionMethod = Number(this._deal.amort.NoteDistributionMethodText);
            this._deal.amort.NoteDistributionMethodText = this.listNoteDistributionMethod.find(function (x) { return x.LookupID == _this._deal.amort.NoteDistributionMethod; }).Name;
        }
        else {
            this._deal.amort.NoteDistributionMethod = Number(this._deal.amort.NoteDistributionMethod);
            this._deal.amort.NoteDistributionMethodText = this.listNoteDistributionMethod.find(function (x) { return x.LookupID == _this._deal.amort.NoteDistributionMethod; }).Name;
        }
        var _isInclude = this.lstNoteListForDealAmort.filter(function (x) { return x.UseRuletoDetermineAmortizationText == "3" || x.UseRuletoDetermineAmortizationText == "Y"; });
        if (!this._deal.amort.AmortizationMethod || !this._deal.amort.AmortizationMethodText) {
            amorterror = amorterror + "<p>" + "Amortization Method can not be blank for generate." + "</p>";
            this._amortmsg = true;
        }
        if (!(this._deal.amort.AmortizationMethod == 622 || this._deal.amort.AmortizationMethodText == "Custom Note Amortization")) {
            if (this._deal.amort.NoteDistributionMethod == 635 || this._deal.amort.NoteDistributionMethodText == "Not Applicable") {
                amorterror = amorterror + "<p>" + "Please select different Note Distribution method, Not Applicable is only allowed for Custom Note Amortization method." + "</p>";
            }
        }
        if (this._deal.amort.AmortizationMethod == 619 || this._deal.amort.AmortizationMethodText == "Fixed Payment Amortization") {
            if (this._deal.amort.FixedPeriodicPayment == null || this._deal.amort.FixedPeriodicPayment == undefined || this._deal.amort.FixedPeriodicPayment == 0) {
                if (amortoverrideamount.length > 0 && _isInclude.length > 0) {
                    for (var k = 0; k < amortoverrideamount.length; k++) {
                        for (var l = 0; l < _isInclude.length; l++) {
                            if (amortoverrideamount[k].CRENoteID == _isInclude[l].CRENoteID) {
                                var includednote = _isInclude[l].CRENoteID + ", ";
                                _isincludednote = _isincludednote + includednote;
                            }
                        }
                    }
                }
                if (_isincludednote != "") {
                    amorterror = amorterror + "<p>" + "Please enter fixed periodic payment or amount override amount for note(s) " + _isincludednote.slice(0, -2) + "</p>";
                    this._amortmsg = true;
                }
            }
        }
        //Find total of all sequences
        for (var i = 0; i < this.lstNoteListForDealAmort.length; i++) {
            if (!(Number(this.lstNoteListForDealAmort[i].RoundingNoteText).toString() == "NaN" || Number(this.lstNoteListForDealAmort[i].RoundingNoteText) == 0)) {
                this.lstNoteListForDealAmort[i].RoundingNote = Number(this.lstNoteListForDealAmort[i].RoundingNoteText);
                this.lstNoteListForDealAmort[i].RoundingNoteText = this.lstRoundingNote.find(function (x) { return x.LookupID == _this.lstNoteListForDealAmort[i].RoundingNote; }).Name;
            }
            if (!(Number(this.lstNoteListForDealAmort[i].UseRuletoDetermineAmortizationText).toString() == "NaN" || Number(this.lstNoteListForDealAmort[i].UseRuletoDetermineAmortizationText) == 0)) {
                this.lstNoteListForDealAmort[i].UseRuletoDetermineAmortization = Number(this.lstNoteListForDealAmort[i].UseRuletoDetermineAmortizationText);
                this.lstNoteListForDealAmort[i].UseRuletoDetermineAmortizationText = this.lstUseRuletoDetermineAmortization.find(function (x) { return x.LookupID == _this.lstNoteListForDealAmort[i].UseRuletoDetermineAmortization; }).Name;
            }
            for (var j = 0; j < this.AmortSeqcolumns.length; j++) {
                if (this.lstNoteListForDealAmort[i].hasOwnProperty(this.AmortSeqcolumns[j].binding)) {
                    var amount = this.lstNoteListForDealAmort[i][this.AmortSeqcolumns[j].binding];
                    seqtotal = seqtotal + amount;
                    seqtotal = seqtotal;
                }
            }
            if (this.lstNoteListForDealAmort[i].UseRuletoDetermineAmortization == 3 || this.lstNoteListForDealAmort[i].UseRuletoDetermineAmortizationText == "Y") {
                if (this.lstNoteListForDealAmort[i].RoundingNote == 3 || this.lstNoteListForDealAmort[i].RoundingNoteText == "Y") {
                    roundingnotecount = roundingnotecount + 1;
                }
                yNoteCount = yNoteCount + 1;
            }
        }
        if (yNoteCount != 0) {
            if (roundingnotecount == 0) {
                amorterror = amorterror + "<p>" + "Please select atleast one rounding note from the notes which are included in the amortization." + "</p>";
            }
            else if (roundingnotecount > 1) {
                amorterror = amorterror + "<p>" + "Please select only one rounding note from the notes which are included in the amortization." + "</p>";
            }
        }
        if (this._deal.amort.AmortizationMethod == 618 || this._deal.amort.AmortizationMethodText == "Straight Line Amortization") {
            if (this._deal.amort.NoteDistributionMethod == 636 || this._deal.amort.NoteDistributionMethodText == "Use Payrules") {
                if (this._isamortsequenceadded == false) {
                    if (!this.AmortSeqcolumns) {
                        amorterror = amorterror + "<p>" + "Please add sequence for use payrules note distribution method." + "</p>";
                        this._amortmsg = true;
                    }
                }
                else {
                    if (seqtotal == 0) {
                        amorterror = amorterror + "<p>" + "Please add sequence value for use payrules note distribution method." + "</p>";
                        this._amortmsg = true;
                    }
                }
            }
        }
        for (var k = 0; k < this.lstNoteListForDealAmort.length; k++) {
            noteseqtotal = 0;
            if (this.lstNoteListForDealAmort[k].UseRuletoDetermineAmortizationText == "Y" || this.lstNoteListForDealAmort[k].UseRuletoDetermineAmortizationText == "3") {
                for (var j = 0; j < this.AmortSeqcolumns.length; j++) {
                    var amount = this.lstNoteListForDealAmort[k][this.AmortSeqcolumns[j].binding];
                    noteseqtotal = noteseqtotal + amount;
                    noteseqtotal = noteseqtotal;
                }
                if (parseFloat((noteseqtotal).toFixed(2)) > this.lstNoteListForDealAmort[k].TotalCommitment) {
                    errnotes = errnotes + this.lstNoteListForDealAmort[k].CRENoteID + " ,";
                }
            }
        }
        if (errnotes != "") {
            errnotes = errnotes.substring(0, errnotes.length - 1);
            amorterror = amorterror + "<p>" + "Total Funding Sequence of note(s) " + errnotes.slice(0, -1) + " cannot be greater than their respective note commitment." + "</p>";
            this._amortmsg = true;
        }
        if (this.lstAmortSchedule) {
            var isnullamortdate = this.lstAmortSchedule.filter(function (x) { return x.Date == null || x.Date == '' || x.Date == undefined; });
            var isamount = this.lstAmortSchedule.filter(function (x) { return x.Amount == null || x.Amount == 0; });
            if (isnullamortdate.length > 0) {
                //if (isamount.length > 0) {
                amorterror = amorterror + "<p>" + "Please enter funding Date." + "</p>";
                this._amortmsg = true;
                // }
            }
            if (this._deal.amort.AmortizationMethod == 622 || this._deal.amort.AmortizationMethodText == "Custom Note Amortization") {
                var lstAmortNote = this._deal.amort.NoteListForDealAmort.filter(function (x) { return x.UseRuletoDetermineAmortizationText == 'Y' || x.UseRuletoDetermineAmortizationText == '3'; });
                var isnum = 0;
                for (var i = 0; i < this.lstAmortSchedule.length; i++) {
                    var rowsum = 0;
                    for (var j = 0; j < lstAmortNote.length; j++) {
                        var amount = this.lstAmortSchedule[i][lstAmortNote[j].Name];
                        rowsum = rowsum + amount;
                    }
                    if (rowsum != 0) {
                        isnum = 1;
                        this.lstAmortSchedule[i]["ColIndex"] = i;
                    }
                    else {
                        this.lstAmortSchedule[i]["ColIndex"] = -1;
                    }
                }
                var maxColIndex = Number(Math.max.apply(null, this.lstAmortSchedule.map(function (x) { return x.ColIndex; })));
                for (var i = 0; i < this.lstAmortSchedule.length - 1; i++) {
                    if (this.lstAmortSchedule[i + 1]["ColIndex"] < this.lstAmortSchedule[i]["ColIndex"]) {
                        if (this.lstAmortSchedule[i]["ColIndex"] < maxColIndex) {
                            amorterror = amorterror + "<p>" + "Please enter amort funding in sequence." + "</p>";
                            this._amortmsg = true;
                            //  this.CustomAlert("<p>" + "Please enter amort funding in sequence." + "</p>");
                            break;
                        }
                    }
                }
                this.lstAmortSchedule.forEach(function (x) { delete x.ColIndex; });
            }
        }
        if (amorterror != "") {
            this._amortmsg = true;
        }
        if (this._amortmsg == true) {
            this.IsShowAmortGenerate = true;
            this.CustomAlert(amorterror);
        }
        else if (this._amortmsg == false) {
            this._deal.ListHoliday = this.ListHoliday;
            this._changedAmortMethod = this._deal.amort.AmortizationMethodText;
            this._isListFetching = true;
            this.ConvertInAmortSequenceList();
            this._deal.amort.AmortSequenceList = this.lstAmortSequence;
            this.AssignDropdownAmort(this.lstNoteListForDealAmort);
            this._deal.amort.NoteListForDealAmort = this.lstNoteListForDealAmort;
            this._deal.PayruleTargetNoteFundingScheduleList = this.lstNoteFunding;
            //this.convertDatetoGMTGrid(this.listdealfunding, 'DealFunding');
            this._deal.PayruleDealFundingList = this.listdealfunding;
            this.dynamicAmortColumn = [];
            if (this.lstAmortSchedule) {
                if (this.lstAmortSchedule.length > 0) {
                    this.ConvertToBindableDateAmort(this.lstAmortSchedule);
                    this.convertDatetoGMTGrid(this.lstAmortSchedule, "Deal Amortization");
                    for (var k = 2; k < this.flexDealAmortizationSchedule.columns.length; k++) {
                        var colamountvalue = this.flexDealAmortizationSchedule.getCellData(0, 1, false);
                        var colname = this.flexDealAmortizationSchedule.columns[k].binding;
                        var colvalue = this.flexDealAmortizationSchedule.getCellData(0, k, false);
                        if (colvalue != null) {
                            var num = colvalue;
                            var str = num.toString();
                            var numarray = str.split('.');
                            var a = new Array();
                            a = numarray;
                            //to assign 2 digits after decimal places
                            if (a[1]) {
                                var l = a[1].length;
                                if (l == 1) {
                                    colvalue = num + "0";
                                }
                                else {
                                    colvalue = num;
                                }
                            }
                            else {
                                colvalue = num + ".00";
                            }
                            this.lstAmortSchedule[0][colname] = colvalue;
                        }
                    }
                    this._deal.amort.dt = this.lstAmortSchedule;
                }
            }
            if (this._deal.amort.AmortizationMethodText == "Custom Note Amortization" || this._deal.amort.AmortizationMethod == 622 || this._deal.amort.AmortizationMethodText == "Straight Line Amortization" || this._deal.amort.AmortizationMethodText == "Full Amortization by Rate & Term" || this._deal.amort.AmortizationMethod == 618 || this._deal.amort.AmortizationMethod == 620 || this._deal.amort.AmortizationMethodText == "Custom Deal Amortization" || this._deal.amort.AmortizationMethod == 621) {
                this.dealSrv.FutureFundingForAmort(this._deal).subscribe(function (res) {
                    if (res.Succeeded) {
                        _this.IsShowAmortGenerate = true;
                        _this._isAmortSchChanges = false;
                        _this._isListFetching = false;
                        var lstAmortNote = _this._deal.amort.NoteListForDealAmort.filter(function (x) { return x.UseRuletoDetermineAmortizationText == 'Y' || x.UseRuletoDetermineAmortizationText == '3'; });
                        _this.columnsAmortSchedule = [];
                        if (_this.dynamicAmortColumn.length > 0) {
                            for (var i = 0; i < lstAmortNote.length; i++) {
                                if (_this.columnsAmortSchedule.filter(function (x) { return x.header == lstAmortNote[i].Name; }).length == 0) {
                                    _this.dynamicAmortColumn.push(lstAmortNote[i].Name);
                                    _this.AddcolumnAmortSchedule(lstAmortNote[i].Name, lstAmortNote[i].Name, true);
                                }
                            }
                        }
                        else {
                            for (var i = 0; i < lstAmortNote.length; i++) {
                                _this.dynamicAmortColumn.push(lstAmortNote[i].Name);
                                _this.AddcolumnAmortSchedule(lstAmortNote[i].Name, lstAmortNote[i].Name, true);
                            }
                        }
                        var data = res.dt;
                        _this.lstAmortSchedule = res.dt;
                        _this.ConvertToBindableDateAmort(_this.lstAmortSchedule);
                        if (!_this.lstAmortSchedule) {
                            _this._NoAmortSch = true;
                        }
                        else {
                            if (_this.lstAmortSchedule.length == 0) {
                                _this._NoAmortSch = true;
                            }
                            else {
                                _this._NoAmortSch = false;
                            }
                        }
                        if (_this.flexDealAmortizationSchedule) {
                            _this.flexDealAmortizationSchedule.invalidate();
                        }
                        setTimeout(function () {
                            if (_this._deal.amort.AmortizationMethodText == "Custom Note Amortization" || _this._deal.amort.AmortizationMethod == 622) {
                                if (_this.flexDealAmortizationSchedule) {
                                    for (var j = 0; j < _this.flexDealAmortizationSchedule.columns.length; j++) {
                                        _this.flexDealAmortizationSchedule.columns[j].isReadOnly = false;
                                    }
                                    _this.flexDealAmortizationSchedule.columns[0].isReadOnly = true;
                                    _this.flexDealAmortizationSchedule.columns[1].isReadOnly = true;
                                    _this.amortizationDynamiccolbinding();
                                    _this.flexDealAmortizationSchedule.invalidate();
                                }
                            }
                            if (_this._deal.amort.AmortizationMethodText == "Custom Deal Amortization" || _this._deal.amort.AmortizationMethod == 621) {
                                if (_this.flexDealAmortizationSchedule) {
                                    _this.flexDealAmortizationSchedule.columns[0].isReadOnly = false;
                                    _this.flexDealAmortizationSchedule.columns[1].isReadOnly = false;
                                    for (var i = 2; i < _this.flexDealAmortizationSchedule.columns.length; i++) {
                                        _this.flexDealAmortizationSchedule.columns[i].isReadOnly = true;
                                    }
                                    _this.amortizationDynamiccolbinding();
                                    _this.flexDealAmortizationSchedule.invalidate();
                                }
                            }
                            if (_this._deal.amort.AmortizationMethodText == "Straight Line Amortization" || _this._deal.amort.AmortizationMethodText == "Full Amortization by Rate & Term" || _this._deal.amort.AmortizationMethod == 618 || _this._deal.amort.AmortizationMethod == 620) {
                                if (_this.flexDealAmortizationSchedule) {
                                    _this.flexDealAmortizationSchedule.isReadOnly = true;
                                    _this.amortizationDynamiccolbinding();
                                    _this.flexDealAmortizationSchedule.invalidate();
                                }
                            }
                        }, 100);
                        //  this.GetTotalAmortAmount();
                        _this._Showmessagediv = true;
                        _this._ShowmessagedivMsg = res.Message;
                        setTimeout(function () {
                            this._Showmessagediv = false;
                        }.bind(_this), 2000);
                    }
                    else {
                        _this._isAmortSchChanges = false;
                        setTimeout(function () {
                            if (this._NoAmortSch == true) {
                                if (res.Message) {
                                    this.amorterrormsg = res.Message;
                                }
                                else {
                                    this.amorterrormsg = "There are no amortization records to show based on current amortization setup .";
                                }
                                this.IsShowAmortGenerate = true;
                                this._isListFetching = false;
                            }
                        }.bind(_this), 2000);
                    }
                });
            }
            if (this._deal.amort.AmortizationMethodText == "Fixed Payment Amortization" || this._deal.amort.AmortizationMethod == 619) {
                var lstAmortNote = this._deal.amort.NoteListForDealAmort.filter(function (x) { return x.UseRuletoDetermineAmortizationText == 'Y' || x.UseRuletoDetermineAmortizationText == '3'; });
                var noteids = "";
                for (var i = 0; i < lstAmortNote.length; i++) {
                    noteids += lstAmortNote[i].CRENoteID + ",";
                }
                this._deal.amort.MutipleNoteIds = noteids.slice(0, -1);
                if (this._deal.amort.MutipleNoteIds != "") {
                    this.dealSrv.FutureFundingForAmort(this._deal).subscribe(function (res) {
                        if (res.Succeeded) {
                            _this.IsShowAmortGenerate = true;
                            _this._isAmortSchChanges = false;
                            _this._isListFetching = false;
                            var data = res.dt;
                            _this.lstAmortSchedule = data;
                            _this.convertDatetoGMTGrid(_this.lstAmortSchedule, "Deal Amortization");
                            var lstAmortNote = _this._deal.amort.NoteListForDealAmort.filter(function (x) { return x.UseRuletoDetermineAmortizationText == 'Y' || x.UseRuletoDetermineAmortizationText == '3'; });
                            _this.columnsAmortSchedule = [];
                            if (_this.dynamicAmortColumn.length > 0) {
                                for (var i = 0; i < lstAmortNote.length; i++) {
                                    if (_this.columnsAmortSchedule.filter(function (x) { return x.header == lstAmortNote[i].Name; }).length == 0) {
                                        _this.dynamicAmortColumn.push(lstAmortNote[i].Name);
                                        _this.AddcolumnAmortSchedule(lstAmortNote[i].Name, lstAmortNote[i].Name, true);
                                    }
                                }
                            }
                            else {
                                for (var i = 0; i < lstAmortNote.length; i++) {
                                    _this.dynamicAmortColumn.push(lstAmortNote[i].Name);
                                    _this.AddcolumnAmortSchedule(lstAmortNote[i].Name, lstAmortNote[i].Name, true);
                                }
                            }
                            if (!_this.lstAmortSchedule) {
                                _this._NoAmortSch = true;
                            }
                            else {
                                if (_this.lstAmortSchedule.length == 0) {
                                    _this._NoAmortSch = true;
                                }
                                else {
                                    _this._NoAmortSch = false;
                                }
                            }
                            setTimeout(function () {
                                if (_this.flexDealAmortizationSchedule) {
                                    _this.flexDealAmortizationSchedule.invalidate();
                                    for (var s = 0; s < _this.flexDealAmortizationSchedule.columns.length; s++) {
                                        if (_this.flexDealAmortizationSchedule.columns[s]) {
                                            _this.flexDealAmortizationSchedule.columns[s].isReadOnly = true;
                                        }
                                    }
                                    _this.amortizationDynamiccolbinding();
                                    _this.flexDealAmortizationSchedule.invalidate();
                                }
                            }, 100);
                        }
                        //setTimeout(function () {
                        //    this.IsShowAmortGenerate = true;
                        //   // if (this._NoAmortSch == true) {
                        //        if (res.Message) {
                        //            this.amorterrormsg = res.Message;
                        //        }
                        //        else {
                        //            this.amorterrormsg = "There are no amortization records to show based on current amortization setup .";
                        //        }
                        //   // }
                        //}.bind(this), 1000);
                        _this.IsShowAmortGenerate = true;
                        _this._Showmessagediv = true;
                        _this._ShowmessagedivMsg = res.Message;
                        setTimeout(function () {
                            this._Showmessagediv = false;
                        }.bind(_this), 2000);
                        _this._isListFetching = false;
                    });
                }
                else {
                    this.IsShowAmortGenerate = true;
                    this._isListFetching = false;
                    this._ShowmessagedivWar = true;
                    this._ShowmessagedivMsgWar = "No Notes are included.";
                    setTimeout(function () {
                        this._ShowmessagedivWar = false;
                    }.bind(this), 2000);
                }
            }
            if (this._deal.amort.AmortizationMethodText == "Custom Deal Amortization" || this._deal.amort.AmortizationMethod == 621) {
                //        this.dealSrv.FutureFundingForAmort(this._deal).subscribe(res => {
                //            if (res.Succeeded) {
                //                this.IsShowAmortGenerate = true;
                //                this._isAmortSchChanges = false;
                //                this._isListFetching = false;
                //                var data = res.dt;
                //                this.lstAmortSchedule = data;
                //                this.convertDatetoGMTGrid(this.lstAmortSchedule, "Deal Amortization");
                //                var lstAmortNote = this._deal.amort.NoteListForDealAmort.filter(x => x.UseRuletoDetermineAmortizationText == 'Y' || x.UseRuletoDetermineAmortizationText == '3')
                //                this.columnsAmortSchedule = [];
                //                if (this.dynamicAmortColumn.length > 0) {
                //                    for (var i = 0; i < lstAmortNote.length; i++) {
                //                        if (this.columnsAmortSchedule.filter(x => x.header == lstAmortNote[i].Name).length == 0) {
                //                            this.dynamicAmortColumn.push(lstAmortNote[i].Name);
                //                            this.AddcolumnAmortSchedule(lstAmortNote[i].Name, lstAmortNote[i].Name, true);
                //                        }
                //                    }
                //                }
                //                else {
                //                    for (var i = 0; i < lstAmortNote.length; i++) {
                //                        this.dynamicAmortColumn.push(lstAmortNote[i].Name);
                //                        this.AddcolumnAmortSchedule(lstAmortNote[i].Name, lstAmortNote[i].Name, true);
                //                    }
                //                }
                //                if (!this.lstAmortSchedule) {
                //                    this._NoAmortSch = true;
                //                } else {
                //                    if (this.lstAmortSchedule.length == 0) {
                //                        this._NoAmortSch = true;
                //                    }
                //                    else {
                //                        this._NoAmortSch = false;
                //                    }
                //                }
                //                setTimeout(() => {
                //                    if (this.flexDealAmortizationSchedule) {
                //                        this.flexDealAmortizationSchedule.invalidate();
                //                        for (var s = 0; s < this.flexDealAmortizationSchedule.columns.length; s++) {
                //                            if (this.flexDealAmortizationSchedule.columns[s]) {
                //                                this.flexDealAmortizationSchedule.columns[s].isReadOnly = true;
                //                            }
                //                        }
                //                        this.amortizationDynamiccolbinding();
                //                        this.flexDealAmortizationSchedule.invalidate();
                //                    }
                //                }, 100);
                //            }
                //            else {
                //                setTimeout(function () {
                //                    this.IsShowAmortGenerate = true;
                //                    if (this._NoAmortSch == true) {
                //                        if (res.Message) {
                //                            this.amorterrormsg = res.Message;
                //                        }
                //                        else {
                //                            this.amorterrormsg = "There are no amortization records to show based on current amortization setup .";
                //                        }
                //                    }
                //                }.bind(this), 2000);
                //                this._isListFetching = false;
                //            }
                //        });
                //}
            }
            if (!this._deal.amort.AmortizationMethodText) {
                this._isListFetching = false;
            }
            if (!this.lstAmortSchedule) {
                this._NoAmortSch = true;
            }
            else {
                if (this.lstAmortSchedule.length == 0) {
                    this._NoAmortSch = true;
                }
                else {
                    this._NoAmortSch = false;
                }
            }
            if (this._NoAmortSch == true) {
                this.amorterrormsg = "There are no amortization records to show based on current amortization setup .";
            }
        }
    };
    DealDetailComponent.prototype.celleditAmortSchedule = function (flexamort, e) {
        this._isAmortSchChanges = true;
        if (this._deal.amort.AmortizationMethodText == "Custom Note Amortization" || this._deal.amort.AmortizationMethod == 622) {
            this.flexDealAmortizationSchedule.rows[e.row]._data.Amount = 0;
            for (var i = 2; i < this.flexDealAmortizationSchedule.columns.length; i++) {
                var colname = this.flexDealAmortizationSchedule.columns[i].binding;
                if (this.lstAmortSchedule[e.row][colname]) {
                    this.lstAmortSchedule[e.row][colname] = parseFloat(parseFloat(this.lstAmortSchedule[e.row][colname]).toFixed(2));
                    this.lstAmortSchedule[e.row]["Amount"] = parseFloat(parseFloat(this.lstAmortSchedule[e.row]["Amount"]).toFixed(2)) + parseFloat(parseFloat(this.lstAmortSchedule[e.row][colname]).toFixed(2));
                }
            }
        }
    };
    DealDetailComponent.prototype.AssignAmortValueToDataContract = function () {
        var _this = this;
        this._deal.amort.DealAmortScheduleList = [];
        this._deal.amort.NoteAmortScheduleList = [];
        this.ConvertInAmortSequenceList();
        this._deal.amort.AmortSequenceList = this.lstAmortSequence;
        this.convertDatetoGMTGrid(this._deal.amort.DealAmortScheduleList, 'Deal Amortization');
        if (this.lstAmortSchedule) {
            for (var i = 0; i < this.lstAmortSchedule.length; i++) {
                if (this.lstAmortSchedule[i].Amount) {
                    var _dealamort = new deals_1.DealAmortization();
                    _dealamort.DealAmortizationScheduleID = this.lstAmortSchedule[i].DealAmortizationScheduleID == null ? '00000000-0000-0000-0000-000000000000' : this.lstAmortSchedule[i].DealAmortizationScheduleID;
                    //  _dealamort.DealAmortizationScheduleAutoID = this.lstAmortSchedule[i].DealAmortizationScheduleAutoID;
                    _dealamort.DealID = this.dealfunding.DealID;
                    _dealamort.DealAmortScheduleRowno = i + 1;
                    _dealamort.Date = this.lstAmortSchedule[i].Date;
                    _dealamort.Amount = this.lstAmortSchedule[i].Amount;
                    if (i == 0) {
                        if (this._actualAmortMethod) {
                            if (this._actualAmortMethod != this._deal.amort.AmortizationMethodText)
                                _dealamort.IsDelete = true;
                            else
                                _dealamort.IsDelete = false;
                        }
                    }
                    this._deal.amort.DealAmortScheduleList.push(_dealamort);
                }
            }
        }
        if (this.dynamicAmortColumn) {
            for (var m = 0; m < this.dynamicAmortColumn.length; m++) {
                if (this.lstAmortSchedule) {
                    if (this.lstAmortSchedule !== null) {
                        for (var i = 0; i < this.lstAmortSchedule.length; i++) {
                            if (this.lstAmortSchedule[i][this.dynamicAmortColumn[m]]) {
                                var _noteamort = new deals_1.NoteAmortization();
                                _noteamort.DealID = this.dealfunding.DealID;
                                _noteamort.NoteID = this.lstNoteListForDealAmort.find(function (x) { return x.Name == _this.dynamicAmortColumn[m]; }).NoteID;
                                _noteamort.NoteName = this.dynamicAmortColumn[m];
                                _noteamort.CRENoteID = this.lstNoteListForDealAmort.find(function (x) { return x.Name == _this.dynamicAmortColumn[m]; }).CRENoteID;
                                _noteamort.Value = this.lstAmortSchedule[i][this.dynamicAmortColumn[m]];
                                _noteamort.DealAmortScheduleRowno = i + 1;
                                _noteamort.Date = this.lstAmortSchedule[i].Date;
                                //   _noteamort.DealAmortizationScheduleAutoID = this.lstAmortSchedule[i].DealAmortizationScheduleAutoID;
                                _noteamort.DealAmortizationScheduleID = this.lstAmortSchedule[i].DealAmortizationScheduleID == null ? '00000000-0000-0000-0000-000000000000' : this.lstAmortSchedule[i].DealAmortizationScheduleID;
                                if (_noteamort) {
                                    this._deal.amort.NoteAmortScheduleList.push(_noteamort);
                                }
                            }
                        }
                    }
                }
            }
        }
    };
    DealDetailComponent.prototype.ValidateAmort = function () {
        if (this._deal.amort.AmortizationMethod == 619 || this._deal.amort.AmortizationMethodText == "Fixed Payment Amortization") {
            this._isreadonlyforfixedpaymentamort = false;
            this._isreadonlyforperiodicstraightline = true;
            //this.Onchangeamortmethod('#NoteDistributionMethod', 'found');
            $('#PeriodicStraightLineAmortOverride').attr('style', 'background-color:#D3D3D3');
            this.Onchangeamortmethod('#ReduceAmortizationForCurtailments', 'found');
            //this.Onchangeamortmethod('#BusinessDayAdjustmentForAmort', 'found');
        }
        else if (this._deal.amort.AmortizationMethod == 618 || this._deal.amort.AmortizationMethodText == "Straight Line Amortization") {
            this._isreadonlyforperiodicstraightline = false;
            this._isreadonlyforfixedpaymentamort = true;
            $('#FixedPeriodicPayment').attr('style', 'background-color:#D3D3D3');
        }
        else {
            this._isreadonlyforfixedpaymentamort = true;
            this._isreadonlyforperiodicstraightline = true;
            this.Onchangeamortmethod('#NoteDistributionMethod', 'notfound');
            $('#FixedPeriodicPayment').attr('style', 'background-color:#D3D3D3');
            $('#PeriodicStraightLineAmortOverride').attr('style', 'background-color:#D3D3D3');
        }
        if (this._deal.amort.AmortizationMethod == 622 || this._deal.amort.AmortizationMethodText == "Custom Note Amortization") {
            this.Onchangeamortmethod('#NoteDistributionMethod', 'found');
            this.Onchangeamortmethod('#ReduceAmortizationForCurtailments', 'found');
        }
        if (this._deal.amort.AmortizationMethod == 621 || this._deal.amort.AmortizationMethodText == "Custom Deal Amortization") {
            this.Onchangeamortmethod('#ReduceAmortizationForCurtailments', 'found');
        }
        if (this._deal.amort.AmortizationMethod == null || this._deal.amort.AmortizationMethodText == "") {
            $('#FixedPeriodicPayment').attr('style', 'background-color:none');
            $('#PeriodicStraightLineAmortOverride').attr('style', 'background-color:none');
        }
        if (this._deal.amort.AmortizationMethod == 623 || this._deal.amort.AmortizationMethodText == "IO Only") {
            this._isShowAddFundingSequence = false;
            this.Onchangeamortmethod('#NoteDistributionMethod', 'found');
            this.Onchangeamortmethod('#ReduceAmortizationForCurtailments', 'found');
            this.Onchangeamortmethod('#BusinessDayAdjustmentForAmort', 'found');
            this.IsShowAmortGenerate = false;
        }
    };
    DealDetailComponent.prototype.celleditAmortRule = function (flexNoteListForDealAmort, e) {
        if (this._deal.amort.AmortizationMethod == 623 || this._deal.amort.AmortizationMethodText == "IO Only") {
        }
        else {
            if (this.lstNoteListForDealAmort.filter(function (x) { return x.UseRuletoDetermineAmortizationText == 'Y' || x.UseRuletoDetermineAmortizationText == '3'; }).length > 0) {
                this.IsShowAmortGenerate = true;
                this._isAmortSchChanges = true;
                if (this.lstAmortSchedule) {
                    this._NoAmortSch = false;
                }
            }
            else {
                this.IsShowAmortGenerate = false;
                this._isAmortSchChanges = false;
                this._NoAmortSch = true;
                this.amorterrormsg = "There are no amortization records to show based on current amortization setup .";
            }
        }
    };
    DealDetailComponent.prototype.celleditautospread = function (flexautospread, e) {
        var _this = this;
        var autospreadchange = this.lstautospreadrule[e.row];
        this._autospreadgenerate = true;
        if (this.lstAdjustedTotalCommitment) {
            var sTotalRequiredEquity = 0, sTotalAdditionalEquity = 0;
            for (var i = 0; i < this.lstAdjustedTotalCommitment.items.length; i++) {
                sTotalRequiredEquity = sTotalRequiredEquity + parseFloat(this.lstAdjustedTotalCommitment.items[i].TotalRequiredEquity);
                sTotalAdditionalEquity = sTotalAdditionalEquity + parseFloat(this.lstAdjustedTotalCommitment.items[i].TotalAdditionalEquity);
            }
            this._autoTotalComitted = sTotalRequiredEquity + sTotalAdditionalEquity;
        }
        ///Check Start and ENd Date Holiday
        var sdate = this.lstautospreadrule[e.row].StartDate;
        var Edate = this.lstautospreadrule[e.row].EndDate;
        if (sdate) {
            var formatedSdate = this.convertDateToBindable(sdate);
            var startday = sdate.getDay();
            if (startday == 6 || startday == 0
                || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formatedSdate && x.HolidayTypeID == 411; }).length > 0) {
                this.lstautospreadrule[e.row]["isValidStartDate"] = false;
            }
            else {
                this.lstautospreadrule[e.row]["isValidStartDate"] = true;
            }
        }
        if (Edate) {
            var formatedEdate = this.convertDateToBindable(Edate);
            var Endday = Edate.getDay();
            if (Endday == 6 || Endday == 0
                || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formatedEdate && x.HolidayTypeID == 411; }).length > 0) {
                this.lstautospreadrule[e.row]["isValidEndDate"] = false;
            }
            else {
                this.lstautospreadrule[e.row]["isValidEndDate"] = true;
            }
        }
    };
    DealDetailComponent.prototype.Copiedautospreadrule = function (flexautospreadrule, e) {
        var _this = this;
        var sel = this.flexautospreadrule.selection;
        for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
            //if (this.listdealfunding[tprow].wf_isUserCurrentFlow == 0) {
            //    this.listdealfunding[tprow].Value = this.listdealfunding[tprow].orgValue;
            //}
            ///Check Start and ENd Date Holiday
            var sdate = this.lstautospreadrule[tprow].StartDate;
            var Edate = this.lstautospreadrule[tprow].EndDate;
            if (sdate) {
                var formatedSdate = this.convertDateToBindable(sdate);
                var startday = sdate.getDay();
                if (startday == 6 || startday == 0
                    || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formatedSdate && x.HolidayTypeID == 411; }).length > 0) {
                    this.lstautospreadrule[tprow]["isValidStartDate"] = false;
                }
                else {
                    this.lstautospreadrule[tprow]["isValidStartDate"] = true;
                }
            }
            if (Edate) {
                var formatedEdate = this.convertDateToBindable(Edate);
                var Endday = Edate.getDay();
                if (Endday == 6 || Endday == 0
                    || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formatedEdate && x.HolidayTypeID == 411; }).length > 0) {
                    this.lstautospreadrule[tprow]["isValidEndDate"] = false;
                }
                else {
                    this.lstautospreadrule[tprow]["isValidEndDate"] = true;
                }
            }
        }
    };
    DealDetailComponent.prototype.formatMoney = function (amount) {
        amount = parseFloat(amount.toFixed(2));
        if (Math.sign(amount) == -1) {
            var _amount = -1 * amount;
            amount = "-" + this._basecurrencyname + _amount;
        }
        else {
            amount = this._basecurrencyname + amount;
        }
        var changedamount = amount.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
        return changedamount;
    };
    DealDetailComponent.prototype.CalculateRemainingAmount = function (dealfundinglist) {
        var wiredconfirmedamount = 0;
        var initialfundingamount = 0;
        for (var c = 0; c < dealfundinglist.length; c++) {
            if (dealfundinglist[c].Applied == true) {
                wiredconfirmedamount = wiredconfirmedamount + dealfundinglist[c].Value;
            }
        }
        for (var d = 0; d < this.lstSequenceHistory.length; d++) {
            initialfundingamount = initialfundingamount + this.lstSequenceHistory[d].InitialFundingAmount;
        }
        var totalamount = wiredconfirmedamount + initialfundingamount;
        this._deal.RemainingAmount = this._deal.AggregatedTotal - totalamount;
    };
    DealDetailComponent.prototype.cellEditbeginDealfunding = function (s, e) {
        var commentcolindex = 10;
        var purposecolindex = 6;
        var currentColIndex = e.col;
        var generatedbycolindex = commentcolindex - 2;
        var Statuscolindex = commentcolindex - 1;
        var notecolindx = commentcolindex + 1;
        var currentpurpose = s.rows[e.row].dataItem.PurposeText;
        var UseRuleNDeal = false;
        var NDeal = false;
        var lstUseRuleY = this.lstSequenceHistory.filter(function (x) { return x.UseRuletoDetermineNoteFundingText == "3" || x.UseRuletoDetermineNoteFundingText == "Y"; });
        if (lstUseRuleY.length == 0) {
            UseRuleNDeal = true;
            NDeal = true;
        }
        //if (this._deal.ApplyNoteLevelPaydowns == true && currentpurpose == "Paydown") {
        //    UseRuleNDeal = true;
        //}
        if (UseRuleNDeal == true) {
            if (currentColIndex > notecolindx) {
                e.cancel = false;
            }
            else if (currentColIndex == purposecolindex || currentColIndex == 2 || currentColIndex == commentcolindex) {
                e.cancel = false;
            }
            else if (currentColIndex == 3) {
                if (NDeal == false) {
                    e.cancel = false;
                }
                else {
                    e.cancel = true;
                }
            }
            else {
                if (e.col != 4 && e.col != 5)
                    e.cancel = true;
            }
        }
        else {
            if (currentColIndex != Statuscolindex && currentColIndex != generatedbycolindex && currentColIndex <= commentcolindex) {
                e.cancel = false;
            }
            else {
                e.cancel = true;
            }
        }
    };
    DealDetailComponent.prototype.onChangeApplyNoteLevelPaydownsCheckbox = function (e) {
        this._isdealfundingChanged = false;
        var checked = e.target.checked;
        if (checked == true) {
            // this.flexdealfunding.autoClipboard = false;
            this._deal.ApplyNoteLevelPaydowns == true;
            for (var i = 11; i < this.flexdealfunding.columns.length; i++) {
                this.flexdealfunding.columns[i].isReadOnly = false;
            }
        }
        else {
            // this.flexdealfunding.autoClipboard = true;
            this._deal.ApplyNoteLevelPaydowns == false;
            for (var i = 11; i < this.flexdealfunding.columns.length; i++) {
                this.flexdealfunding.columns[i].isReadOnly = true;
            }
        }
    };
    DealDetailComponent.prototype.Onchangeamortmethod = function (divid, value) {
        if (value == 'found') {
            $(divid).attr("disabled", "disabled");
            $(divid).attr('style', 'background-color:#D3D3D3');
        }
        else {
            $(divid).removeAttr('disabled');
            $(divid).attr('style', 'background-color:none');
        }
    };
    DealDetailComponent.prototype.GetAdjustmenttotalcommitment = function (dealid) {
        var _this = this;
        if (!this.lstAdjustedTotalCommitment) {
            this.dealSrv.GetAdjustmentTotalCommitment(dealid).subscribe(function (res) {
                if (res.Succeeded == true) {
                    //var data = [];
                    //if (tabclicked == 'FundingTab') {
                    //    this.isAdjustedTotalCommitmentEnable = false;
                    //}
                    //else {
                    //    this.isAdjustedTotalCommitmentEnable = true;
                    //}
                    _this.TotalCommitmentGridbind(res.dt, 'null');
                }
            });
        }
    };
    DealDetailComponent.prototype.TotalCommitmentGridbind = function (listdata, mode) {
        var header = [];
        this.dynamicadjustedcollist = [];
        this.adjusteddynamicnotescol = [];
        this.listAdjustedTotalCommitment = listdata;
        var data = listdata;
        this.ConvertToBindableDateAdjustedtotalCommitment(this.listAdjustedTotalCommitment);
        this.lstAdjustedTotalCommitment = new wjcCore.CollectionView(data);
        this.lstAdjustedTotalCommitment.trackChanges = true;
        $.each(data, function (obj) {
            var i = 0;
            $.each(data[obj], function (key, value) {
                header[i] = key;
                i = i + 1;
            });
            return false;
        });
        this.dynamicadjustedcollist = header;
        this.columnsforCommitmentAdjustment = [];
        //push noteid for column binding and make list for notes
        for (var k = 0; k < header.length; k++) {
            var _isbracket = header[k].indexOf("_");
            if (_isbracket > -1) {
                if (header[k].includes("_Noteid")) {
                    var splitarray = header[k].split("_Noteid");
                    for (var m = 0; m < this.lstNote.length; m++) {
                        if (this.lstNote[m].CRENoteID == splitarray[0]) {
                            this.AddcolumnAdjustedTotalCommitment(this.lstNote[m].Name, header[k], true);
                            if (this.listAdjustedTotalCommitment[0][header[k]] == null) {
                                this.listAdjustedTotalCommitment[0][header[k]] = 0;
                            }
                        }
                    }
                }
                this.adjusteddynamicnotescol.push(header[k]);
            }
        }
        var user = JSON.parse(localStorage.getItem('user'));
        if (user.RoleName == "Super Admin") {
            this._showtotalcommitmentdelcol = true;
        }
        else {
            this._showtotalcommitmentdelcol = false;
        }
        if (user.RoleName == "Asset Manager") {
            this.flexadjustedtotalcommitment.allowAddNew = false;
        }
        var commentcolindex = this.flexadjustedtotalcommitment.getColumn("Comments").index;
        this.flexadjustedtotalcommitment.itemFormatter = function (panel, r, c, cell) {
            if (panel.cellType != wjcGrid.CellType.Cell) {
                return;
            }
            if (user.RoleName == "Asset Manager") {
                if (panel.columns[c].index > commentcolindex || panel.columns[c].header == 'Delete') {
                    cell.style.backgroundColor = '#cfcfcf';
                }
                else {
                    cell.style.backgroundColor = null;
                }
                var columnName = panel.columns[2].binding;
                var item = panel.getCellData(r, columnName);
                if (panel.columns[c].binding == "TypeText" || panel.columns[c].binding == "Date") {
                    if (!(panel.columns[c].binding == "Comments" || panel.columns[c].binding == "TotalAdditionalEquity" || panel.columns[c].binding == "TotalRequiredEquity")) {
                        if (item != "Equity Rebalancing") {
                            cell.style.backgroundColor = '#cfcfcf';
                        }
                        else {
                            if (item == "Equity Rebalancing") {
                                if (panel.columns[c].binding == "Date") {
                                    cell.style.backgroundColor = null;
                                }
                                if (panel.columns[c].binding == "TypeText") {
                                    cell.style.backgroundColor = '#cfcfcf';
                                }
                            }
                        }
                    }
                    else {
                        cell.style.backgroundColor = null;
                    }
                }
                if (item == "Upsize/Mod" && panel.rows[r].dataItem.CommitmentType == "PIKPrincipalFunding") {
                    if (!(panel.columns[c].binding == "Comments" || panel.columns[c].binding == "TotalAdditionalEquity" || panel.columns[c].binding == "TotalRequiredEquity")) {
                        cell.style.backgroundColor = '#cfcfcf';
                    }
                }
            }
            else {
                var columnName = panel.columns[2].binding;
                if (columnName == "TypeText") {
                    var item = panel.getCellData(r, columnName);
                    if (item == "Closing") {
                        if (panel.columns[c].header == "Delete" || panel.columns[c].binding == "Date" || panel.columns[c].binding == "TypeText") {
                            cell.style.backgroundColor = '#cfcfcf';
                        }
                        else {
                            cell.style.backgroundColor = null;
                        }
                    }
                    else {
                        if (item == "Prepayment" || item == "Scheduled Principal") {
                            if (!(panel.columns[c].binding == "Comments" || panel.columns[c].binding == "TotalAdditionalEquity" || panel.columns[c].binding == "TotalRequiredEquity")) {
                                cell.style.backgroundColor = '#cfcfcf';
                            }
                            else {
                                cell.style.backgroundColor = null;
                            }
                        }
                        else {
                            cell.style.backgroundColor = null;
                        }
                    }
                    if (item == "Upsize/Mod" && panel.rows[r].dataItem.CommitmentType == "PIKPrincipalFunding") {
                        if (!(panel.columns[c].binding == "Comments" || panel.columns[c].binding == "TotalAdditionalEquity" || panel.columns[c].binding == "TotalRequiredEquity")) {
                            cell.style.backgroundColor = '#cfcfcf';
                        }
                    }
                }
            } // end
            if (panel.columns[c].binding == "TotalEquityatClosing") {
                cell.style.backgroundColor = '#cfcfcf';
            }
        };
        setTimeout(function () {
            this.showCalculatedAdjustedtotalCommitment();
            if (mode == 'Save') {
                this.showCalculatedNoteCommitments('Copy', 'e');
            }
            else {
                this.showCalculatedNoteCommitments('Get', 'e');
            }
        }.bind(this), 100);
        this.getEquityValues();
        this.flexadjustedtotalcommitment.invalidate();
    };
    DealDetailComponent.prototype.ConvertToBindableDateAdjustedtotalCommitment = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this.listAdjustedTotalCommitment[i].Date != null) {
                this.listAdjustedTotalCommitment[i].Date = new Date(this.convertDateToBindable(this.listAdjustedTotalCommitment[i].Date));
            }
        }
    };
    DealDetailComponent.prototype.ViewCommitmentDetailsBtnClick = function () {
        document.getElementById("aAdjustedTotalCommitment").click();
        this.invalidateDealAdjustedTab();
    };
    DealDetailComponent.prototype.GetAllFeeType = function () {
        var _this = this;
        if (!this._isPrepaymentTabClicked) {
            localStorage.setItem('ClickedTabId', 'aPrepaymentPremiumtab');
            this._isPrepaymentTabClicked = true;
            this.showPrepayCalcStatus();
            this.showprepaycalcstatuswithinterval();
            this.GetDealPrepayProjectionByDealId();
            this.GetDealPrepayAllocationsByDealId();
            this.getprepaypremiumDetaildatabydealId();
        }
        if (this.rolename == 'Super Admin') {
            this.tdopenrules = true;
        }
        else {
            this.tdopenrules = false;
        }
        this.getprepayruletypetemplate();
        this.getprepayruletemplate();
        this.feeconfigurationSrv.GetAllFeeAmount().subscribe(function (res) {
            if (res.Succeeded) {
                _this.listfeeamount = [];
                var data = res.lstFeeSchedulesConfig;
                _this.lstFeeType = data;
            }
        });
    };
    DealDetailComponent.prototype.PrePayRuleTypeChange = function (newvalue) {
        if (newvalue == 0) {
            var url = "/#/datamanagement?tab=rule";
            window.open(url);
        }
    };
    DealDetailComponent.prototype.getprepayruletypetemplate = function () {
        var _this = this;
        this.scenarioService.getallruletypedetail().subscribe(function (res) {
            if (res.Succeeded) {
                var PrepayRuleTemplatelist = res.lstScenarioRuleDetail;
                var filterPrepayRuleTemplatelist = PrepayRuleTemplatelist.filter(function (x) { return x.RuleTypeName == "Prepay"; });
                _this.lstPrepayRuleTemplate = filterPrepayRuleTemplatelist;
                if (_this.rolename == 'Super Admin') {
                    _this.lstPrepayRuleTemplate.push({
                        "RuleTypeDetailID": 0,
                        "FileName": "--Create New--"
                    });
                }
            }
        });
    };
    DealDetailComponent.prototype.getprepayruletemplate = function () {
        var _this = this;
        this._ruletype.DealID = this._deal.DealID;
        this.dealSrv.getruletypesetupbydealid(this._ruletype).subscribe(function (res) {
            if (res.Succeeded) {
                _this._lstRuleTypeSetupfilter = res.lstScenariorule;
                var lstprepayruletemplatebyanalysisid = _this._lstRuleTypeSetupfilter.find(function (x) { return x.AnalysisName == "Default" && x.RuleTypeName == "Prepay"; }).RuleTypeDetailID;
                _this._prepaymentpremium.PrePaymentRuleType = lstprepayruletemplatebyanalysisid;
            }
        });
    };
    DealDetailComponent.prototype.UpdateEquitySummary = function () {
        if (this._lstEquitySummary.length > 0) {
            for (var h = 0; h < this._lstEquitySummary.length; h++) {
                if (this._lstEquitySummary[h].Type == "Closing") {
                    if (this._deal.EquityatClosing == 0 || this._deal.EquityatClosing == null || this._deal.EquityatClosing == undefined) {
                        this._lstEquitySummary[h]["ExpectedEquity"] = 0;
                        this._lstEquitySummary[h]["EquityContributedToDate"] = 0;
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = 0.00 + "%";
                    }
                    else {
                        this._lstEquitySummary[h]["ExpectedEquity"] = this._deal.EquityatClosing;
                        this._lstEquitySummary[h]["EquityContributedToDate"] = this._deal.EquityatClosing;
                        var Per_ContributedToDate = this._deal.EquityatClosing / this._deal.EquityatClosing * 100;
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = parseFloat(Per_ContributedToDate.toString()).toFixed(2) + "%";
                    }
                }
            }
            var sTotalRequiredEquity = 0;
            var sTotalAdditionalEquity = 0;
            if (this.lstAdjustedTotalCommitment) {
                for (var i = 0; i < this.lstAdjustedTotalCommitment.items.length; i++) {
                    if (this.lstAdjustedTotalCommitment.items[i].Date <= this._currentDate) {
                        if (this.lstAdjustedTotalCommitment.items[i].TotalRequiredEquity) {
                            if (this.lstAdjustedTotalCommitment.items[i].TotalRequiredEquity != undefined || this.lstAdjustedTotalCommitment.items[i].TotalRequiredEquity != "" || this.lstAdjustedTotalCommitment.items[i].TotalRequiredEquity != null) {
                                sTotalRequiredEquity = sTotalRequiredEquity + parseFloat(this.lstAdjustedTotalCommitment.items[i].TotalRequiredEquity);
                            }
                        }
                    }
                }
                for (var i = 0; i < this.lstAdjustedTotalCommitment.items.length; i++) {
                    if (this.lstAdjustedTotalCommitment.items[i].Date <= this._currentDate) {
                        if (this.lstAdjustedTotalCommitment.items[i].TotalAdditionalEquity) {
                            if (this.lstAdjustedTotalCommitment.items[i].TotalAdditionalEquity != undefined || this.lstAdjustedTotalCommitment.items[i].TotalAdditionalEquity != "" || this.lstAdjustedTotalCommitment.items[i].TotalAdditionalEquity != null) {
                                sTotalAdditionalEquity = sTotalAdditionalEquity + parseFloat(this.lstAdjustedTotalCommitment.items[i].TotalAdditionalEquity);
                            }
                        }
                    }
                }
                var lstAdjustedTotalCommitmentforClosing = this.listAdjustedTotalCommitment.filter(function (x) { return x.TypeText == "Closing"; });
                var minAdjustedTotalCommitmentdate = new Date(Math.min.apply(null, lstAdjustedTotalCommitmentforClosing.map(function (x) { return x.Date; })));
                for (var i = 0; i < this.lstAdjustedTotalCommitment.items.length; i++) {
                    if (this.convertDateToBindable(minAdjustedTotalCommitmentdate) == this.convertDateToBindable(this.lstAdjustedTotalCommitment.items[i].Date)) {
                        if (this.lstAdjustedTotalCommitment.items[i].TypeText == "Closing") {
                            this.flexadjustedtotalcommitment.rows[i].dataItem.TotalEquityatClosing = this._deal.EquityatClosing;
                            this.listAdjustedTotalCommitment[i]["TotalEquityatClosing"] = this._deal.EquityatClosing;
                            this.flexadjustedtotalcommitment.invalidate();
                        }
                    }
                }
            }
            for (var h = 0; h < this._lstEquitySummary.length; h++) {
                if (this._lstEquitySummary[h].Type == "FF Required Equity") {
                    this._lstEquitySummary[h]["ExpectedEquity"] = sTotalRequiredEquity;
                    this._lstEquitySummary[h]["RemainingEquity"] = sTotalRequiredEquity - this._lstEquitySummary[h]["EquityContributedToDate"];
                    if (sTotalRequiredEquity == 0) {
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = 0.00 + "%";
                    }
                    else {
                        var CommitmentPerContributedToDate_req = this._lstEquitySummary[h]["EquityContributedToDate"] / sTotalRequiredEquity * 100;
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = parseFloat(CommitmentPerContributedToDate_req.toString()).toFixed(2) + "%";
                    }
                }
            }
            for (var h = 0; h < this._lstEquitySummary.length; h++) {
                if (this._lstEquitySummary[h].Type == "FF Additional Equity") {
                    this._lstEquitySummary[h]["ExpectedEquity"] = sTotalAdditionalEquity;
                    this._lstEquitySummary[h]["RemainingEquity"] = sTotalAdditionalEquity - this._lstEquitySummary[h]["EquityContributedToDate"];
                    if (sTotalAdditionalEquity == 0) {
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = 0.00 + "%";
                    }
                    else {
                        var CommitmentPerContributedToDate_add = this._lstEquitySummary[h]["EquityContributedToDate"] / sTotalAdditionalEquity * 100;
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = parseFloat(CommitmentPerContributedToDate_add.toString()).toFixed(2) + "%";
                    }
                }
            }
            var sTotalRequiredEquityFunding = 0;
            var sTotalAdditionalEquityFunding = 0;
            if (this.cvDealFundingList) {
                for (var i = 0; i < this.cvDealFundingList.items.length; i++) {
                    if (this.cvDealFundingList.items[i].Date <= this._currentDate) {
                        if (this.cvDealFundingList.items[i].RequiredEquity) {
                            if (this.cvDealFundingList.items[i].RequiredEquity != undefined || this.cvDealFundingList.items[i].RequiredEquity != "" || this.cvDealFundingList.items[i].RequiredEquity != null) {
                                sTotalRequiredEquityFunding = sTotalRequiredEquityFunding + parseFloat(this.cvDealFundingList.items[i].RequiredEquity);
                            }
                        }
                    }
                }
                for (var i = 0; i < this.cvDealFundingList.items.length; i++) {
                    if (this.cvDealFundingList.items[i].Date <= this._currentDate) {
                        if (this.cvDealFundingList.items[i].AdditionalEquity) {
                            if (this.cvDealFundingList.items[i].AdditionalEquity != undefined || this.cvDealFundingList.items[i].AdditionalEquity != "" || this.cvDealFundingList.items[i].AdditionalEquity != null) {
                                sTotalAdditionalEquityFunding = sTotalAdditionalEquityFunding + parseFloat(this.cvDealFundingList.items[i].AdditionalEquity);
                            }
                        }
                    }
                }
            }
            for (var h = 0; h < this._lstEquitySummary.length; h++) {
                if (this._lstEquitySummary[h].Type == "FF Required Equity") {
                    this._lstEquitySummary[h]["EquityContributedToDate"] = sTotalRequiredEquityFunding;
                    this._lstEquitySummary[h]["RemainingEquity"] = this._lstEquitySummary[h]["ExpectedEquity"] - sTotalRequiredEquityFunding;
                    if (sTotalRequiredEquityFunding == 0 || this._lstEquitySummary[h]["ExpectedEquity"] == 0) {
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = 0.00 + "%";
                    }
                    else {
                        var FundingPerContributedToDate_req = sTotalRequiredEquityFunding / this._lstEquitySummary[h]["ExpectedEquity"] * 100;
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = parseFloat(FundingPerContributedToDate_req.toString()).toFixed(2) + "%";
                    }
                }
            }
            for (var h = 0; h < this._lstEquitySummary.length; h++) {
                if (this._lstEquitySummary[h].Type == "FF Additional Equity") {
                    this._lstEquitySummary[h]["EquityContributedToDate"] = sTotalAdditionalEquityFunding;
                    this._lstEquitySummary[h]["RemainingEquity"] = this._lstEquitySummary[h]["ExpectedEquity"] - sTotalAdditionalEquityFunding;
                    if (sTotalAdditionalEquityFunding == 0 || this._lstEquitySummary[h]["ExpectedEquity"] == 0) {
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = 0.00 + "%";
                    }
                    else {
                        var FundingPerContributedToDate_add = sTotalAdditionalEquityFunding / this._lstEquitySummary[h]["ExpectedEquity"] * 100;
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = parseFloat(FundingPerContributedToDate_add.toString()).toFixed(2) + "%";
                    }
                }
            }
            var TotalExpectedEquity = 0;
            var TotalEquityContributedToDate = 0;
            this._lstEquitySummary.forEach(function (item) {
                if (item.Type != "Total Equity") {
                    TotalExpectedEquity += Number(item.ExpectedEquity);
                    TotalEquityContributedToDate += Number(item.EquityContributedToDate);
                }
            });
            for (var h = 0; h < this._lstEquitySummary.length; h++) {
                if (this._lstEquitySummary[h].Type == "Total Equity") {
                    this._lstEquitySummary[h]["ExpectedEquity"] = TotalExpectedEquity;
                    this._lstEquitySummary[h]["EquityContributedToDate"] = TotalEquityContributedToDate;
                    this._lstEquitySummary[h]["RemainingEquity"] = TotalExpectedEquity - TotalEquityContributedToDate;
                    if (TotalExpectedEquity == 0) {
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = 0.00 + "%";
                    }
                    else {
                        var TotalPerContributedToDate = TotalEquityContributedToDate / TotalExpectedEquity * 100;
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = parseFloat(TotalPerContributedToDate.toString()).toFixed(2) + "%";
                    }
                }
            }
            this._lstEquitySummary = this._lstEquitySummary;
            this.Equitygrid.invalidate();
            this.getEquityValues();
        }
    };
    DealDetailComponent.prototype.GetEquitySummary = function (dealid) {
        var _this = this;
        this.dealSrv.GetEquitySummaryByDealID(dealid).subscribe(function (res) {
            if (res.Succeeded) {
                var lstequitysummary = res.equitySummaryDatas;
                if (lstequitysummary.length > 0) {
                    _this._lstEquitySummary = lstequitysummary;
                    for (var h = 0; h < _this._lstEquitySummary.length; h++) {
                        _this._lstEquitySummary[h]["Per_ContributedToDate"] = parseFloat(_this._lstEquitySummary[h]["Per_ContributedToDate"]).toFixed(2) + "%";
                    }
                }
                else {
                    _this._lstEquitySummary = [];
                }
            }
        });
    };
    DealDetailComponent.prototype.invalidateDealAdjustedTab = function () {
        var _this = this;
        this._isListFetching = true;
        if (!this._isAdjustedTotalCommitmentTabClicked) {
            this._isAdjustedTotalCommitmentTabClicked = true;
            this.GetEquitySummary(this._deal.DealID);
        }
        else {
            this._lstEquitySummary = this._lstEquitySummary;
            setTimeout(function () {
                _this.Equitygrid.invalidate();
            }, 500);
        }
        if (!this.lstAdjustedTotalCommitment) {
            this.GetAdjustmenttotalcommitment(this._deal.DealID);
        }
        else {
            setTimeout(function () {
                _this.TotalCommitmentGridbind(_this.listAdjustedTotalCommitment, 'null');
            }, 200);
        }
        localStorage.setItem('ClickedTabId', 'aAdjustedTotalCommitment');
        setTimeout(function () {
            _this._isListFetching = false;
        }, 1000);
    };
    DealDetailComponent.prototype.celleditadjustedtotalcommitment = function (s, e) {
        var _this = this;
        this._isFundingruleChanged = true;
        var adjustedtotalcommitment = this.listAdjustedTotalCommitment[e.row];
        for (var t = 0; t < this.listAdjustedTotalCommitment.length; t++) {
            if (!(Number(this.listAdjustedTotalCommitment[t].TypeText).toString() == "NaN" || Number(this.listAdjustedTotalCommitment[t].TypeText) == 0)) {
                this.listAdjustedTotalCommitment[t].Type = Number(this.listAdjustedTotalCommitment[t].TypeText);
                this.listAdjustedTotalCommitment[t].TypeText = this.lstAdjustedTotalCommitmentType.find(function (x) { return x.LookupID == _this.listAdjustedTotalCommitment[t].TypeText; }).Name;
            }
        }
        if (Object.keys(adjustedtotalcommitment).length) {
            this.showCalculatedAdjustedtotalCommitment();
            this.showCalculatedNoteCommitments('Edit', e);
        }
        if (this._isAdjustedTotalCommitmentTabClicked == true) {
            var header = s.columns[e.col].header;
            if (header == 'Total Required Equity' || header == 'Total Additional Equity' || header == 'Date') {
                this.UpdateEquitySummary();
            }
        }
        this.getEquityValues();
    };
    DealDetailComponent.prototype.Copiedadjustedtotalcommitment = function (s, e) {
        var _this = this;
        this._isFundingruleChanged = true;
        var adjustedtotalcommitment = this.listAdjustedTotalCommitment[e.row];
        var datecellindex = s.getColumn("Date").index;
        for (var t = 0; t < this.listAdjustedTotalCommitment.length; t++) {
            if (!(Number(this.listAdjustedTotalCommitment[t].TypeText).toString() == "NaN" || Number(this.listAdjustedTotalCommitment[t].TypeText) == 0)) {
                this.listAdjustedTotalCommitment[t].Type = Number(this.listAdjustedTotalCommitment[t].TypeText);
                this.listAdjustedTotalCommitment[t].TypeText = this.lstAdjustedTotalCommitmentType.find(function (x) { return x.LookupID == _this.listAdjustedTotalCommitment[t].TypeText; }).Name;
            }
        }
        if (Object.keys(adjustedtotalcommitment).length) {
            this.CopiedEquitySummaryforCommitment();
            this.getEquityValues();
            this.showCalculatedAdjustedtotalCommitment();
            this.showCalculatedNoteCommitments('Copy', e);
        }
    };
    DealDetailComponent.prototype.cellEditbeginAdjustedCommitment = function (s, e) {
        var commentcolindex = s.getColumn("Comments").index;
        var totaladdequitycellindex = s.getColumn("TotalAdditionalEquity").index;
        var totalreqequitycellindex = s.getColumn("TotalRequiredEquity").index;
        var typetextcellindex = s.getColumn("TypeText").index;
        var datecellindex = s.getColumn("Date").index;
        //  var excludeFromCommitmentCalculationindex = s.getColumn("ExcludeFromCommitmentCalculation").index;
        var user = JSON.parse(localStorage.getItem('user'));
        if (user.RoleName == "Asset Manager") {
            if (e.col > commentcolindex || e.col == 0 || e.col == typetextcellindex) {
                e.cancel = true;
            }
            else {
                e.cancel = false;
            }
            if (e.col == totalreqequitycellindex || e.col == totaladdequitycellindex || e.col == commentcolindex) {
                e.cancel = false;
            }
            if (s.rows[e.row].dataItem.TypeText == 'Equity Rebalancing') {
                if (e.col == datecellindex || e.col == totalreqequitycellindex || e.col == totaladdequitycellindex || e.col == commentcolindex) {
                    e.cancel = false;
                }
            }
            else {
                if (!(e.col == totalreqequitycellindex || e.col == totaladdequitycellindex || e.col == commentcolindex)) {
                    e.cancel = true;
                }
            }
        }
        else {
            //if (e.col == excludeFromCommitmentCalculationindex) {
            //    e.cancel = false;
            //} else {
            if (s.rows[e.row].dataItem.TypeText == 'Closing') {
                if (e.col >= totalreqequitycellindex) {
                    e.cancel = false; //readonly false for notelevel columns.
                }
                else {
                    e.cancel = true;
                }
            }
            if (s.rows[e.row].dataItem.TypeText != 'Closing') {
                if (s.rows[e.row].dataItem.TypeText == 'Prepayment' || s.rows[e.row].dataItem.TypeText == 'Scheduled Principal') {
                    if (!(e.col == commentcolindex || e.col == totalreqequitycellindex || e.col == totaladdequitycellindex)) {
                        e.cancel = true; //readonly true
                    }
                }
                else {
                    e.cancel = false;
                }
                //}
            }
        }
    };
    DealDetailComponent.prototype.cellPastingAdjustedCommitment = function (s, e) {
        var commentcolindex = s.getColumn("Comments").index;
        var totaladdequitycellindex = s.getColumn("TotalAdditionalEquity").index;
        var totalreqequitycellindex = s.getColumn("TotalRequiredEquity").index;
        var typetextcellindex = s.getColumn("TypeText").index;
        var datecellindex = s.getColumn("Date").index;
        var user = JSON.parse(localStorage.getItem('user'));
        if (user.RoleName == "Asset Manager") {
            if (e.col > commentcolindex || e.col == 0 || e.col == typetextcellindex) {
                e.cancel = true;
            }
            else {
                e.cancel = false;
            }
            if (e.col == totalreqequitycellindex || e.col == totaladdequitycellindex || e.col == commentcolindex) {
                e.cancel = false;
            }
            if (s.rows[e.row].dataItem.TypeText == 'Equity Rebalancing') {
                if (e.col == datecellindex || e.col == totalreqequitycellindex || e.col == totaladdequitycellindex || e.col == commentcolindex) {
                    e.cancel = false;
                }
            }
            else {
                if (!(e.col == totalreqequitycellindex || e.col == totaladdequitycellindex || e.col == commentcolindex)) {
                    e.cancel = true;
                }
            }
        }
        else {
            if (s.rows[e.row].dataItem.TypeText == 'Closing' || s.rows[e.row].dataItem.TypeText == 'Prepayment' || s.rows[e.row].dataItem.TypeText == 'Scheduled Principal') {
                if (e.col == datecellindex || e.col == typetextcellindex) {
                    e.cancel = true; //readonly true 
                }
            }
            if (s.rows[e.row].dataItem.TypeText != 'Closing') {
                if (s.rows[e.row].dataItem.TypeText == 'Prepayment' || s.rows[e.row].dataItem.TypeText == 'Scheduled Principal') {
                    if (e.col > commentcolindex) {
                        e.cancel = true; //readonly true
                    }
                }
                else {
                    e.cancel = false;
                }
            }
        }
    };
    DealDetailComponent.prototype.CopiedEquitySummaryforCommitment = function () {
        if (this._lstEquitySummary.length > 0) {
            var sTotalRequiredEquity = 0;
            var sTotalAdditionalEquity = 0;
            if (this.lstAdjustedTotalCommitment) {
                for (var i = 0; i < this.lstAdjustedTotalCommitment.items.length; i++) {
                    if (this.lstAdjustedTotalCommitment.items[i].Date <= this._currentDate) {
                        if (this.lstAdjustedTotalCommitment.items[i].TotalRequiredEquity) {
                            if (this.lstAdjustedTotalCommitment.items[i].TotalRequiredEquity != undefined || this.lstAdjustedTotalCommitment.items[i].TotalRequiredEquity != "" || this.lstAdjustedTotalCommitment.items[i].TotalRequiredEquity != null) {
                                sTotalRequiredEquity = sTotalRequiredEquity + parseFloat(this.lstAdjustedTotalCommitment.items[i].TotalRequiredEquity);
                            }
                        }
                    }
                }
                for (var i = 0; i < this.lstAdjustedTotalCommitment.items.length; i++) {
                    if (this.lstAdjustedTotalCommitment.items[i].Date <= this._currentDate) {
                        if (this.lstAdjustedTotalCommitment.items[i].TotalAdditionalEquity) {
                            if (this.lstAdjustedTotalCommitment.items[i].TotalAdditionalEquity != undefined || this.lstAdjustedTotalCommitment.items[i].TotalAdditionalEquity != "" || this.lstAdjustedTotalCommitment.items[i].TotalAdditionalEquity != null) {
                                sTotalAdditionalEquity = sTotalAdditionalEquity + parseFloat(this.lstAdjustedTotalCommitment.items[i].TotalAdditionalEquity);
                            }
                        }
                    }
                }
            }
            for (var h = 0; h < this._lstEquitySummary.length; h++) {
                if (this._lstEquitySummary[h].Type == "FF Required Equity") {
                    this._lstEquitySummary[h]["ExpectedEquity"] = sTotalRequiredEquity;
                    this._lstEquitySummary[h]["RemainingEquity"] = sTotalRequiredEquity - this._lstEquitySummary[h]["EquityContributedToDate"];
                    if (sTotalRequiredEquity == 0) {
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = 0.00 + "%";
                    }
                    else {
                        var CommitmentPerContributedToDate_req = this._lstEquitySummary[h]["EquityContributedToDate"] / sTotalRequiredEquity * 100;
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = parseFloat(CommitmentPerContributedToDate_req.toString()).toFixed(2) + "%";
                    }
                }
            }
            for (var h = 0; h < this._lstEquitySummary.length; h++) {
                if (this._lstEquitySummary[h].Type == "FF Additional Equity") {
                    this._lstEquitySummary[h]["ExpectedEquity"] = sTotalAdditionalEquity;
                    this._lstEquitySummary[h]["RemainingEquity"] = sTotalAdditionalEquity - this._lstEquitySummary[h]["EquityContributedToDate"];
                    if (sTotalAdditionalEquity == 0) {
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = 0.00 + "%";
                    }
                    else {
                        var CommitmentPerContributedToDate_add = this._lstEquitySummary[h]["EquityContributedToDate"] / sTotalAdditionalEquity * 100;
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = parseFloat(CommitmentPerContributedToDate_add.toString()).toFixed(2) + "%";
                    }
                }
            }
            var TotalExpectedEquity = 0;
            var TotalEquityContributedToDate = 0;
            this._lstEquitySummary.forEach(function (item) {
                if (item.Type != "Total Equity") {
                    TotalExpectedEquity += Number(item.ExpectedEquity);
                    TotalEquityContributedToDate += Number(item.EquityContributedToDate);
                }
            });
            for (var h = 0; h < this._lstEquitySummary.length; h++) {
                if (this._lstEquitySummary[h].Type == "Total Equity") {
                    this._lstEquitySummary[h]["ExpectedEquity"] = TotalExpectedEquity;
                    this._lstEquitySummary[h]["EquityContributedToDate"] = TotalEquityContributedToDate;
                    this._lstEquitySummary[h]["RemainingEquity"] = TotalExpectedEquity - TotalEquityContributedToDate;
                    if (TotalExpectedEquity == 0) {
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = 0.00 + "%";
                    }
                    else {
                        var TotalPerContributedToDate = TotalEquityContributedToDate / TotalExpectedEquity * 100;
                        this._lstEquitySummary[h]["Per_ContributedToDate"] = parseFloat(TotalPerContributedToDate.toString()).toFixed(2) + "%";
                    }
                }
            }
            this._lstEquitySummary = this._lstEquitySummary;
            this.Equitygrid.invalidate();
        }
    };
    DealDetailComponent.prototype.showCalculatedAdjustedtotalCommitment = function () {
        for (var adj = 0; adj < this.listAdjustedTotalCommitment.length; adj++) {
            var data = this.listAdjustedTotalCommitment[adj];
            this.adjusteddealcommitmenthistorycol = 0;
            this.adjusteddealtotalcommitmentcol = 0;
            this.adjusteddealaggregatedcommitmentcol = 0;
            this.adjusteddealcommitmentcol = 0;
            this.adjustedCommitmentcolumnheaders(data, adj);
            for (var n = 0; n < this.adjustedcommitmentheader.length; n++) {
                var _isbracket = this.adjustedcommitmentheader[n].indexOf("_");
                if (_isbracket > -1) {
                    if (this.adjustedcommitmentheader[n].includes("_Noteid")) {
                        var sumofdealhistorycol = this.adjusteddealcommitmenthistorycol + this.adjustedcommitmentheadervalues[n];
                        this.adjusteddealcommitmenthistorycol = sumofdealhistorycol;
                        //Deal History Column for all types
                        this.flexadjustedtotalcommitment.rows[adj].dataItem.DealAdjustmentHistory = this.adjusteddealcommitmenthistorycol;
                        // if (this.listAdjustedTotalCommitment[adj].TypeText == "Closing") {
                        if (adj == 0) {
                            this.flexadjustedtotalcommitment.rows[adj].dataItem.AdjustedCommitment = this.adjusteddealcommitmenthistorycol;
                            this.flexadjustedtotalcommitment.rows[adj].dataItem.TotalCommitment = this.adjusteddealcommitmenthistorycol;
                            this.flexadjustedtotalcommitment.rows[adj].dataItem.AggregatedCommitment = this.adjusteddealcommitmenthistorycol;
                        }
                        //}
                        else {
                            //Adjusted Commitment Column
                            if (this.flexadjustedtotalcommitment.rows[adj].dataItem.ExcludeFromCommitmentCalculation) {
                                this.flexadjustedtotalcommitment.rows[adj].dataItem.AdjustedCommitment = this.flexadjustedtotalcommitment.rows[adj - 1].dataItem.AdjustedCommitment;
                                var exclDealAdjustmentHistory = this.flexadjustedtotalcommitment.rows[adj].dataItem.DealAdjustmentHistory;
                                for (var i = adj + 1; i < this.listAdjustedTotalCommitment.length; i++) {
                                    this.flexadjustedtotalcommitment.rows[i].dataItem.AdjustedCommitment = this.flexadjustedtotalcommitment.rows[i].dataItem.AdjustedCommitment - exclDealAdjustmentHistory;
                                }
                            }
                            else {
                                this.adjusteddealcommitmentcol = this.flexadjustedtotalcommitment.rows[adj].dataItem.DealAdjustmentHistory + this.flexadjustedtotalcommitment.rows[adj - 1].dataItem.AdjustedCommitment;
                                this.flexadjustedtotalcommitment.rows[adj].dataItem.AdjustedCommitment = this.adjusteddealcommitmentcol;
                            }
                            //Total Commitment Column
                            if (this.flexadjustedtotalcommitment.rows[adj].dataItem.ExcludeFromCommitmentCalculation) {
                                this.flexadjustedtotalcommitment.rows[adj].dataItem.TotalCommitment = this.flexadjustedtotalcommitment.rows[adj - 1].dataItem.TotalCommitment;
                                var excltotalcommitment = this.flexadjustedtotalcommitment.rows[adj].dataItem.TotalCommitment;
                                for (var i = adj + 1; i < this.listAdjustedTotalCommitment.length; i++) {
                                    this.flexadjustedtotalcommitment.rows[i].dataItem.TotalCommitment = this.flexadjustedtotalcommitment.rows[i].dataItem.TotalCommitment - excltotalcommitment;
                                }
                            }
                            else {
                                if (this.listAdjustedTotalCommitment[adj].TypeText == "Upsize/Mod" || this.listAdjustedTotalCommitment[adj].TypeText == "Note Transfer" || this.listAdjustedTotalCommitment[adj].TypeText == "Closing") {
                                    this.adjusteddealtotalcommitmentcol = this.flexadjustedtotalcommitment.rows[adj - 1].dataItem.TotalCommitment + this.flexadjustedtotalcommitment.rows[adj].dataItem.DealAdjustmentHistory;
                                }
                                else {
                                    this.adjusteddealtotalcommitmentcol = this.flexadjustedtotalcommitment.rows[adj - 1].dataItem.TotalCommitment;
                                }
                                this.flexadjustedtotalcommitment.rows[adj].dataItem.TotalCommitment = this.adjusteddealtotalcommitmentcol;
                            }
                            //Aggregated Commitment Column
                            if (this.listAdjustedTotalCommitment[adj].TypeText == "Prepayment" || this.listAdjustedTotalCommitment[adj].TypeText == "Scheduled Principal") {
                                this.adjusteddealaggregatedcommitmentcol = this.flexadjustedtotalcommitment.rows[adj - 1].dataItem.AggregatedCommitment;
                            }
                            else {
                                this.adjusteddealaggregatedcommitmentcol = this.flexadjustedtotalcommitment.rows[adj].dataItem.DealAdjustmentHistory + this.flexadjustedtotalcommitment.rows[adj - 1].dataItem.AggregatedCommitment;
                            }
                            this.flexadjustedtotalcommitment.rows[adj].dataItem.AggregatedCommitment = this.adjusteddealaggregatedcommitmentcol;
                        }
                    }
                }
            }
        }
        // make sure this is a regular cell (not a header) 
        var lastrownumber = this.listAdjustedTotalCommitment.length - 1;
        if (this.flexadjustedtotalcommitment.rows[lastrownumber].dataItem.AggregatedCommitment != null || this.flexadjustedtotalcommitment.rows[lastrownumber].dataItem.TotalCommitment != null || this.flexadjustedtotalcommitment.rows[lastrownumber].dataItem.AdjustedCommitment != null) {
            this._totalcommitmenttextboxvalue = this.formatNumberforTwoDecimalplaces(this.flexadjustedtotalcommitment.rows[lastrownumber].dataItem.TotalCommitment);
            this._aggregatedcommitmenttexboxtvalue = this.formatNumberforTwoDecimalplaces(this.flexadjustedtotalcommitment.rows[lastrownumber].dataItem.AggregatedCommitment);
            this._adjustedcommitmenttextboxvalue = this.formatNumberforTwoDecimalplaces(this.flexadjustedtotalcommitment.rows[lastrownumber].dataItem.AdjustedCommitment);
            this._deal.TotalCommitment = parseFloat(this.flexadjustedtotalcommitment.rows[lastrownumber].dataItem.TotalCommitment).toFixed(2);
            this._deal.AdjustedTotalCommitment = this.flexadjustedtotalcommitment.rows[lastrownumber].dataItem.AdjustedCommitment;
            //  this._deal.AggregatedTotal = this.flexadjustedtotalcommitment.rows[lastrownumber].dataItem.AggregatedCommitment;
        }
        this.flexadjustedtotalcommitment.invalidate();
    };
    //Note level total commitments columns
    DealDetailComponent.prototype.showCalculatedNoteCommitments = function (mode, e) {
        this.dynamiccollistvalues = [];
        for (var nlc = 0; nlc < this.listAdjustedTotalCommitment.length; nlc++) {
            var data = this.listAdjustedTotalCommitment[nlc];
            this.adjustedCommitmentcolumnheaders(data, nlc);
            var notearr = [];
            for (var n = 0; n < this.adjustedcommitmentheader.length; n++) {
                var notetotalcommitmentcol = 0;
                var _isbracket = this.adjustedcommitmentheader[n].indexOf("_");
                if (_isbracket > -1) {
                    if (this.adjustedcommitmentheader[n].includes("_Noteid")) {
                        var notesplitarray = this.adjustedcommitmentheader[n].split("_Noteid");
                        notearr.push({ 'NoteID': notesplitarray[0], 'Value': this.adjustedcommitmentheadervalues[n] == null ? 0 : this.adjustedcommitmentheadervalues[n] });
                    }
                }
            }
            for (var n = 0; n < this.adjustedcommitmentheader.length; n++) {
                var notetotalcommitmentcol = 0;
                var colnoteid = [];
                var _isbracket = this.adjustedcommitmentheader[n].indexOf("_");
                if (_isbracket > -1) {
                    for (var l = 0; l < this.dynamicadjustedcollist.length; l++) {
                        notetotalcommitmentcol = 0;
                        if (mode == 'Edit' || mode == 'Copy') {
                            if (this.flexadjustedtotalcommitment.columns[e.col].binding)
                                colnoteid = this.flexadjustedtotalcommitment.columns[e.col].binding.split("_Noteid");
                        }
                        if (this.dynamicadjustedcollist[l].includes("_AdjustedCommitment")) {
                            var adjustedsplitarray = this.dynamicadjustedcollist[l].split("_AdjustedCommitment");
                            for (var t = 0; t < notearr.length; t++) {
                                var notecol = this.dynamicadjustedcollist[l];
                                if (notearr[t].NoteID == adjustedsplitarray[0]) {
                                    if (nlc == 0) {
                                        if (mode == 'Edit' || mode == 'Copy') {
                                            if (colnoteid[0] == adjustedsplitarray[0]) {
                                                this.listAdjustedTotalCommitment[0][notecol] = notearr[t].Value;
                                            }
                                        }
                                        else {
                                            this.listAdjustedTotalCommitment[0][notecol] = this.listAdjustedTotalCommitment[0][notecol];
                                        }
                                        for (var k = 0; k < this.lstSequenceHistory.length; k++) {
                                            if (this.lstSequenceHistory[k].CRENoteID == notearr[t].NoteID) {
                                                this.lstSequenceHistory[k].AdjustedTotalCommitment = notearr[t].Value;
                                            }
                                        }
                                    }
                                    else {
                                        var _item = this.listAdjustedTotalCommitment[nlc - 1][notecol];
                                        notetotalcommitmentcol = _item + notearr[t].Value;
                                        this.listAdjustedTotalCommitment[nlc][notecol] = notetotalcommitmentcol;
                                        for (var k = 0; k < this.lstSequenceHistory.length; k++) {
                                            if (this.lstSequenceHistory[k].CRENoteID == notearr[t].NoteID) {
                                                this.lstSequenceHistory[k].AdjustedTotalCommitment = notetotalcommitmentcol;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if (this.dynamicadjustedcollist[l].includes("_AggregateCommitment")) {
                            var aggregatesplitarray = this.dynamicadjustedcollist[l].split("_AggregateCommitment");
                            var notecol = this.dynamicadjustedcollist[l];
                            for (var t = 0; t < notearr.length; t++) {
                                if (notearr[t].NoteID == aggregatesplitarray[0]) {
                                    if (nlc == 0) {
                                        if (mode == 'Edit' || mode == 'Copy') {
                                            if (colnoteid[0] == aggregatesplitarray[0]) {
                                                this.listAdjustedTotalCommitment[0][notecol] = notearr[t].Value;
                                            }
                                        }
                                        else {
                                            this.listAdjustedTotalCommitment[0][notecol] = this.listAdjustedTotalCommitment[0][notecol];
                                        }
                                        for (var k = 0; k < this.lstSequenceHistory.length; k++) {
                                            if (this.lstSequenceHistory[k].CRENoteID == notearr[t].NoteID) {
                                                this.lstSequenceHistory[k].AggregatedTotal = notearr[t].Value;
                                            }
                                        }
                                    }
                                    else {
                                        if (this.listAdjustedTotalCommitment[nlc].TypeText == "Prepayment" || this.listAdjustedTotalCommitment[nlc].TypeText == "Scheduled Principal") {
                                            var item = this.listAdjustedTotalCommitment[nlc - 1][notecol];
                                            notetotalcommitmentcol = item;
                                        }
                                        else {
                                            var item = this.listAdjustedTotalCommitment[nlc - 1][notecol];
                                            notetotalcommitmentcol = item + notearr[t].Value;
                                        }
                                        this.listAdjustedTotalCommitment[nlc][notecol] = notetotalcommitmentcol;
                                        for (var k = 0; k < this.lstSequenceHistory.length; k++) {
                                            if (this.lstSequenceHistory[k].CRENoteID == notearr[t].NoteID) {
                                                this.lstSequenceHistory[k].AggregatedTotal = notetotalcommitmentcol;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if (this.dynamicadjustedcollist[l].includes("_TotalCommitment")) {
                            var totalsplitarray = this.dynamicadjustedcollist[l].split("_TotalCommitment");
                            var notecol = this.dynamicadjustedcollist[l];
                            for (var t = 0; t < notearr.length; t++) {
                                if (notearr[t].NoteID == totalsplitarray[0]) {
                                    if (nlc == 0) {
                                        if (mode == 'Edit' || mode == 'Copy') {
                                            if (colnoteid[0] == totalsplitarray[0]) {
                                                this.listAdjustedTotalCommitment[0][notecol] = notearr[t].Value;
                                            }
                                        }
                                        else {
                                            this.listAdjustedTotalCommitment[0][notecol] = this.listAdjustedTotalCommitment[0][notecol];
                                        }
                                        for (var k = 0; k < this.lstSequenceHistory.length; k++) {
                                            if (this.lstSequenceHistory[k].CRENoteID == notearr[t].NoteID) {
                                                this.lstSequenceHistory[k].TotalCommitment = notearr[t].Value;
                                            }
                                        }
                                    }
                                    else {
                                        if (this.listAdjustedTotalCommitment[nlc].TypeText == "Closing" || this.listAdjustedTotalCommitment[nlc].TypeText == "Upsize/Mod" || this.listAdjustedTotalCommitment[nlc].TypeText == "Note Transfer") {
                                            var _item = this.listAdjustedTotalCommitment[nlc - 1][notecol];
                                            notetotalcommitmentcol = _item + notearr[t].Value;
                                        }
                                        else {
                                            var item = this.listAdjustedTotalCommitment[nlc - 1][notecol];
                                            notetotalcommitmentcol = item;
                                        }
                                        this.listAdjustedTotalCommitment[nlc][notecol] = notetotalcommitmentcol;
                                        for (var k = 0; k < this.lstSequenceHistory.length; k++) {
                                            if (this.lstSequenceHistory[k].CRENoteID == notearr[t].NoteID) {
                                                this.lstSequenceHistory[k].TotalCommitment = this.listAdjustedTotalCommitment[nlc][notecol];
                                            }
                                        }
                                        for (var j = 0; j < this.lstNote.length; j++) {
                                            if (this.lstNote[j].CRENoteID == notearr[t].NoteID) {
                                                this.lstNote[j].TotalCommitment = this.listAdjustedTotalCommitment[nlc][notecol];
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } // end of loop
        }
        this.grdflexDynamicColForSequence.invalidate();
    };
    DealDetailComponent.prototype.syncDealfundingandTotalcommitmentlistforYnotes = function (notedataList) {
        var filterednotelist = [];
        var Todaysdate = new Date();
        var purposetypenotelist = notedataList.filter(function (x) { return x.PurposeID == 315 || x.PurposeID == 630 || x.PurposeID == 631 || x.PurposeID == 351; });
        if (purposetypenotelist.length > 0) {
            for (var j = 0; j < purposetypenotelist.length; j++) {
                if (new Date(purposetypenotelist[j].Date) <= Todaysdate) {
                    for (var m = 0; m < this.lstNote.length; m++) {
                        if (this.lstNote[m].Name == purposetypenotelist[j].NoteName) {
                            filterednotelist.push({
                                "CRENoteID": this.lstNote[m].CRENoteID, "Date": new Date(purposetypenotelist[j].Date),
                                "Type": purposetypenotelist[j].PurposeID == 351 ? 691 : 638,
                                "Value": purposetypenotelist[j].Value,
                                "TypeText": purposetypenotelist[j].Purpose == "Amortization" ? "Scheduled Principal" : "Prepayment",
                            });
                        }
                    }
                }
            }
        }
        this.generateCommitmentRowswithFundingGrid(filterednotelist, 'Y');
    };
    DealDetailComponent.prototype.syncDealfundingandTotalcommitmentlistforNnotes = function (data) {
        var Todaysdate = new Date();
        var filterednotelist = [];
        var purposetypedeallist = data.filter(function (x) { return x.PurposeID == 315 || x.PurposeID == 630 || x.PurposeID == 631 || x.PurposeID == 351 || x.PurposeText == "315" || x.PurposeText == "630" || x.PurposeText == "631" || x.PurposeText == "351"; });
        if (purposetypedeallist.length > 0) {
            for (var j = 0; j < purposetypedeallist.length; j++) {
                if (purposetypedeallist[j].Date <= Todaysdate) {
                    for (var m = 0; m < this.lstNote.length; m++) {
                        for (var n = 0; n < this.dynamicColList.length; n++) {
                            if (this.lstNote[m].Name == this.dynamicColList[n]) {
                                if (purposetypedeallist[j][this.dynamicColList[n]] != undefined) {
                                    if (!(purposetypedeallist[j][this.dynamicColList[n]] == null || purposetypedeallist[j][this.dynamicColList[n]] == undefined)) {
                                        filterednotelist.push({
                                            "CRENoteID": this.lstNote[m].CRENoteID, "Date": new Date(purposetypedeallist[j].Date),
                                            "Type": purposetypedeallist[j].PurposeID == 351 || purposetypedeallist[j].PurposeText == "351" ? 691 : 638,
                                            "Value": purposetypedeallist[j][this.dynamicColList[n]],
                                            "TypeText": purposetypedeallist[j].PurposeText == "Amortization" || purposetypedeallist[j].PurposeText == "351" ? "Scheduled Principal" : "Prepayment",
                                        });
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        this.generateCommitmentRowswithFundingGrid(filterednotelist, 'N');
    };
    DealDetailComponent.prototype.generateCommitmentRowswithFundingGrid = function (filterednotelist, mode) {
        // to sumup values on same date
        if (filterednotelist.length > 0) {
            var notecommitmentlist = [];
            var prepaylist = filterednotelist.filter(function (x) { return x.Type == 638; });
            var scheduledprincipal = filterednotelist.filter(function (x) { return x.Type == 691; });
            var prepaynotesum = 0;
            var schedulednotesum = 0;
            // to sum up prepayment type amount
            if (prepaylist.length) {
                for (var t = 0; t < prepaylist.length; t++) {
                    prepaynotesum = prepaylist[t].Value;
                    var _isfoundflag = false;
                    for (var u = t + 1; u < prepaylist.length; u++) {
                        if (prepaylist[t].CRENoteID == prepaylist[u].CRENoteID) {
                            if (prepaylist[t].Date.getTime() == prepaylist[u].Date.getTime()) {
                                if (prepaylist[t].Type == prepaylist[u].Type) {
                                    prepaynotesum = prepaynotesum + prepaylist[u].Value;
                                }
                            }
                        }
                    }
                    if (notecommitmentlist.length == 0) {
                        notecommitmentlist.push({
                            "CRENoteID": prepaylist[t].CRENoteID, "Date": prepaylist[t].Date, "Type": prepaylist[t].Type,
                            "Value": prepaynotesum,
                            "TypeText": prepaylist[t].TypeText
                        });
                    }
                    else {
                        for (var v = 0; v < notecommitmentlist.length; v++) {
                            if (prepaylist[t].CRENoteID == notecommitmentlist[v].CRENoteID) {
                                if (prepaylist[t].Date.getTime() == notecommitmentlist[v].Date.getTime()) {
                                    if (prepaylist[t].Type == notecommitmentlist[v].Type) {
                                        _isfoundflag = true;
                                        break;
                                    }
                                }
                            }
                        }
                        if (_isfoundflag == false) {
                            notecommitmentlist.push({
                                "CRENoteID": prepaylist[t].CRENoteID, "Date": prepaylist[t].Date, "Type": prepaylist[t].Type,
                                "Value": prepaynotesum,
                                "TypeText": prepaylist[t].TypeText
                            });
                        }
                    }
                    prepaynotesum = 0;
                }
            }
            // to sum up scheduled principal type amount
            if (scheduledprincipal.length) {
                for (var t = 0; t < scheduledprincipal.length; t++) {
                    schedulednotesum = scheduledprincipal[t].Value;
                    var _isfoundflag = false;
                    for (var u = t + 1; u < scheduledprincipal.length; u++) {
                        if (scheduledprincipal[t].CRENoteID == scheduledprincipal[u].CRENoteID) {
                            if (scheduledprincipal[t].Date.getTime() == scheduledprincipal[u].Date.getTime()) {
                                schedulednotesum = schedulednotesum + scheduledprincipal[u].Value;
                            }
                        }
                    }
                    if (notecommitmentlist.length == 0) {
                        notecommitmentlist.push({
                            "CRENoteID": scheduledprincipal[t].CRENoteID, "Date": scheduledprincipal[t].Date, "Type": scheduledprincipal[t].Type,
                            "Value": schedulednotesum,
                            "TypeText": scheduledprincipal[t].TypeText
                        });
                    }
                    else {
                        for (var v = 0; v < notecommitmentlist.length; v++) {
                            if (scheduledprincipal[t].CRENoteID == notecommitmentlist[v].CRENoteID) {
                                if (scheduledprincipal[t].Date.getTime() == notecommitmentlist[v].Date.getTime()) {
                                    if (scheduledprincipal[t].Type == notecommitmentlist[v].Type) {
                                        _isfoundflag = true;
                                        break;
                                    }
                                }
                            }
                        }
                        if (_isfoundflag == false) {
                            notecommitmentlist.push({
                                "CRENoteID": scheduledprincipal[t].CRENoteID, "Date": scheduledprincipal[t].Date, "Type": scheduledprincipal[t].Type,
                                "Value": schedulednotesum,
                                "TypeText": scheduledprincipal[t].TypeText
                            });
                        }
                    }
                    schedulednotesum = 0;
                }
            }
            //for creating new commitment list
            var arr = [];
            var insertnotedata = [];
            var rownumber = 0;
            for (var com = 0; com < notecommitmentlist.length; com++) {
                var _isfounddate = false;
                for (var l = 0; l < this.listAdjustedTotalCommitment.length; l++) {
                    if (rownumber != l) {
                        if (!(this.listAdjustedTotalCommitment[l].CommitmentType == "BalloonPayment")) {
                            if (this.listAdjustedTotalCommitment[l].TypeText == "Prepayment" || this.listAdjustedTotalCommitment[l].TypeText == "Scheduled Principal") {
                                var commitmentdate = new Date(this.listAdjustedTotalCommitment[l].Date).getMonth() + "/" + new Date(this.listAdjustedTotalCommitment[l].Date).getDate() + "/" + new Date(this.listAdjustedTotalCommitment[l].Date).getFullYear();
                                var dealfundingdate = new Date(notecommitmentlist[com].Date).getMonth() + "/" + new Date(notecommitmentlist[com].Date).getDate() + "/" + new Date(notecommitmentlist[com].Date).getFullYear();
                                if (commitmentdate == dealfundingdate) {
                                    if (notecommitmentlist[com].Type == this.listAdjustedTotalCommitment[l].Type) {
                                        rownumber = l;
                                        _isfounddate = true;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
                // add new date row in commitment list
                if (_isfounddate == false) {
                    arr = [];
                    var len = this.listAdjustedTotalCommitment.length;
                    arr.push({
                        "Date": new Date(notecommitmentlist[com].Date), "TypeText": notecommitmentlist[com].TypeText, "Type": notecommitmentlist[com].Type
                    });
                    insertnotedata.push(notecommitmentlist[com]);
                    for (var a = 0; a < arr.length; a++) {
                        var _isfoundflag = false;
                        for (var m = 0; m < this.listAdjustedTotalCommitment.length; m++) {
                            if (!(this.listAdjustedTotalCommitment[m].CommitmentType == "BalloonPayment")) {
                                if (this.listAdjustedTotalCommitment[m].TypeText == "Prepayment" || this.listAdjustedTotalCommitment[m].TypeText == "Scheduled Principal") {
                                    var commitdate = new Date(this.listAdjustedTotalCommitment[m].Date).getMonth() + "/" + new Date(this.listAdjustedTotalCommitment[m].Date).getDate() + "/" + new Date(this.listAdjustedTotalCommitment[m].Date).getFullYear();
                                    var dealfunddate = new Date(arr[a].Date).getMonth() + "/" + new Date(arr[a].Date).getDate() + "/" + new Date(arr[a].Date).getFullYear();
                                    if (commitdate == dealfunddate) {
                                        if (arr[a].Type == this.listAdjustedTotalCommitment[m].Type) {
                                            _isfoundflag = true;
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                        if (_isfoundflag == false) {
                            this.listAdjustedTotalCommitment[len] = arr[a];
                        }
                    }
                }
            }
            // to assign all columns in new row added in listcommitment
            if (insertnotedata.length > 0) {
                this.AssignValuestoAdjustedNoteCommitment(true);
            }
            // to delete extra rows from total commitment list
            for (var m = 0; m < this.listAdjustedTotalCommitment.length; m++) {
                var _isfoundflag = false;
                if (!(this.listAdjustedTotalCommitment[m].CommitmentType == "BalloonPayment")) {
                    if (this.listAdjustedTotalCommitment[m].TypeText == "Prepayment" || this.listAdjustedTotalCommitment[m].TypeText == "Scheduled Principal") {
                        for (var l = 0; l < notecommitmentlist.length; l++) {
                            var commitdate = new Date(this.listAdjustedTotalCommitment[m].Date).getMonth() + "/" + new Date(this.listAdjustedTotalCommitment[m].Date).getDate() + "/" + new Date(this.listAdjustedTotalCommitment[m].Date).getFullYear();
                            var dealfunddate = new Date(notecommitmentlist[l].Date).getMonth() + "/" + new Date(notecommitmentlist[l].Date).getDate() + "/" + new Date(notecommitmentlist[l].Date).getFullYear();
                            if (commitdate == dealfunddate) {
                                if (notecommitmentlist[l].Type == this.listAdjustedTotalCommitment[m].Type) {
                                    _isfoundflag = true;
                                    break;
                                }
                            }
                        }
                        if (_isfoundflag == false) {
                            this.listAdjustedTotalCommitment.splice(m, 1);
                        }
                        if (m > 0) {
                            if (m != this.listAdjustedTotalCommitment.length) {
                                for (var r = 0; r < this.listAdjustedTotalCommitment.length; r++) {
                                    if (r != m) {
                                        if (new Date(this.listAdjustedTotalCommitment[m].Date).getTime() == new Date(this.listAdjustedTotalCommitment[r].Date).getTime()) {
                                            if (this.listAdjustedTotalCommitment[m].Type == this.listAdjustedTotalCommitment[r].Type) {
                                                if (this.listAdjustedTotalCommitment[m].NoteAdjustedCommitmentMasterID == null) {
                                                    this.listAdjustedTotalCommitment.splice(r, 1);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        } // end
                    }
                }
            }
            // assign note values to new row
            for (var g = 0; g < notecommitmentlist.length; g++) {
                for (var b = 0; b < this.listAdjustedTotalCommitment.length; b++) {
                    if (!(this.listAdjustedTotalCommitment[b].CommitmentType == "BalloonPayment")) {
                        if (this.listAdjustedTotalCommitment[b].TypeText == "Prepayment" || this.listAdjustedTotalCommitment[b].TypeText == "Scheduled Principal") {
                            for (var dyn = 0; dyn < this.dynamicadjustedcollist.length; dyn++) {
                                var _isbracket = this.dynamicadjustedcollist[dyn].indexOf("_");
                                if (_isbracket > -1) {
                                    if (this.dynamicadjustedcollist[dyn].includes("_Noteid")) {
                                        var notesplitarray = this.dynamicadjustedcollist[dyn].split("_Noteid");
                                        var noteid = this.dynamicadjustedcollist[dyn];
                                        var commitmentdate = new Date(this.listAdjustedTotalCommitment[b].Date).getMonth() + "/" + new Date(this.listAdjustedTotalCommitment[b].Date).getDate() + "/" + new Date(this.listAdjustedTotalCommitment[b].Date).getFullYear();
                                        var dealfundingdate = new Date(notecommitmentlist[g].Date).getMonth() + "/" + new Date(notecommitmentlist[g].Date).getDate() + "/" + new Date(notecommitmentlist[g].Date).getFullYear();
                                        if (commitmentdate == dealfundingdate) {
                                            if (notesplitarray[0] == notecommitmentlist[g].CRENoteID) {
                                                if (this.listAdjustedTotalCommitment[b].Type == 638) {
                                                    if (notecommitmentlist[g].Type == 638) {
                                                        if (notesplitarray[0] == notecommitmentlist[g].CRENoteID) {
                                                            this.listAdjustedTotalCommitment[b][noteid] = notecommitmentlist[g].Value;
                                                        }
                                                    }
                                                }
                                                if (this.listAdjustedTotalCommitment[b].Type == 691) {
                                                    if (notecommitmentlist[g].Type == 691) {
                                                        if (notesplitarray[0] == notecommitmentlist[g].CRENoteID) {
                                                            this.listAdjustedTotalCommitment[b][noteid] = notecommitmentlist[g].Value;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        else {
            if (filterednotelist.length == 0) {
                for (var b = 0; b < this.listAdjustedTotalCommitment.length; b++) {
                    if (!(this.listAdjustedTotalCommitment[b].CommitmentType == "BalloonPayment")) {
                        if (this.listAdjustedTotalCommitment[b].TypeText == "Prepayment" || this.listAdjustedTotalCommitment[b].TypeText == "Scheduled Principal") {
                            this.listAdjustedTotalCommitment.splice(b, 1);
                            b = 0;
                        }
                    }
                }
            }
        }
        // to bind total commitment grid with new list
        this.TotalCommitmentGridbind(this.listAdjustedTotalCommitment, 'null');
        if (this.ShowUseRuleN == false) {
            setTimeout(function () {
                this.ValidateCurrenBalanceAndCommitment();
            }.bind(this), 150);
        }
    };
    DealDetailComponent.prototype.ValidateCurrenBalanceAndCommitment = function () {
        ///Total Funding sequence + Initial Funding - Pre pay or scheduled amount + negative transfers - ballon = Adjusted Commitment
        var noteswithissue = "";
        if (!(this.ShowUseRuleN)) {
            if (this.lstSequenceHistory) {
                var today = new Date();
                for (var j = 0; j < this.lstSequenceHistory.length; j++) {
                    var totRepayment;
                    var ScheduledPrincipalPaid;
                    var balloon;
                    var sumNotefunding;
                    totRepayment = 0;
                    balloon = 0;
                    sumNotefunding = 0;
                    ScheduledPrincipalPaid = 0;
                    var currentnoteid = this.lstSequenceHistory[j].NoteID;
                    var InitialFundingAmount = this.lstSequenceHistory[j].InitialFundingAmount;
                    balloon = this.lstSequenceHistory[j].BalloonPayment * -1;
                    if (this.lstScheduledPrincipalPaid) {
                        if (this.lstScheduledPrincipalPaid.length > 0) {
                            var lstScheduledPrip = this.lstScheduledPrincipalPaid.filter(function (x) { return x.NoteID == currentnoteid; });
                            if (lstScheduledPrip.length > 0) {
                                var temp = lstScheduledPrip[0].Amount;
                                if (temp != null && temp != undefined) {
                                    ScheduledPrincipalPaid = parseFloat((temp * -1).toFixed(2));
                                }
                            }
                        }
                    }
                    var noteFundingArray = this.lstNoteFunding.filter(function (x) { return x.NoteID == currentnoteid; });
                    for (var m = 0; m < noteFundingArray.length; m++) {
                        if (noteFundingArray[m].Value) {
                            if (noteFundingArray[m].Value < 0) {
                                if (new Date(noteFundingArray[m].Date) <= today) {
                                    totRepayment = totRepayment + parseFloat(this.GetDefaultValue(parseFloat(noteFundingArray[m].Value).toFixed(2)));
                                }
                            }
                            else {
                                if (noteFundingArray[m].Purpose != "Note Transfer") {
                                    if (noteFundingArray[m].Value !== null) {
                                        sumNotefunding = sumNotefunding + parseFloat(this.GetDefaultValue(parseFloat(noteFundingArray[m].Value).toFixed(2)));
                                    }
                                }
                            }
                        }
                    }
                    sumNotefunding = parseFloat(sumNotefunding.toFixed(2));
                    totRepayment = parseFloat(totRepayment.toFixed(2));
                    if (parseFloat(InitialFundingAmount) == 0.01) {
                        InitialFundingAmount = 0;
                    }
                    //for loop end
                    //AdjustedTotalCommitment
                    var subtotal = sumNotefunding + parseFloat(InitialFundingAmount) + totRepayment + parseFloat(balloon) + parseFloat(ScheduledPrincipalPaid);
                    if (parseFloat(subtotal.toFixed(2)) > parseFloat(this.lstSequenceHistory[j].AdjustedTotalCommitment.toFixed(2))) {
                        var diffval = parseFloat(subtotal.toFixed(2)) - parseFloat(this.lstSequenceHistory[j].AdjustedTotalCommitment.toFixed(2));
                        if (Math.abs(parseFloat(diffval.toFixed(2))) > 0) {
                            noteswithissue = noteswithissue + this.lstSequenceHistory[j].CRENoteID + ", ";
                        }
                    }
                }
            }
            if (noteswithissue != "") {
                var fundingerror = "";
                noteswithissue = noteswithissue.substring(0, noteswithissue.length - 1);
                fundingerror = fundingerror + "<p> Sum of Future Funding and Current Balance should be less than or equal to Adjusted Commitment for Note(s) " + noteswithissue.slice(0, -1) + "</p>";
                this.CustomAlert(fundingerror);
            }
        }
    };
    DealDetailComponent.prototype.formatNumberforTwoDecimalplaces = function (data) {
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
    DealDetailComponent.prototype.adjustedCommitmentcolumnheaders = function (data, rownumber) {
        var i = 0;
        var headers = [];
        var headervalues = [];
        this.adjustedcommitmentheader = [];
        this.adjustedcommitmentheadervalues = [];
        var i = 0;
        $.each(data, function (key, value) {
            headers[i] = key;
            headervalues[i] = value;
            i = i + 1;
        });
        //push data of note columns only
        for (var m = 0; m < headers.length; m++) {
            for (var n = 0; n < this.adjusteddynamicnotescol.length; n++) {
                if (headers[m] == this.adjusteddynamicnotescol[n]) {
                    this.adjustedcommitmentheader.push(headers[m]);
                    this.adjustedcommitmentheadervalues.push(headervalues[m]);
                }
            }
        }
        //push data for saving list 
        if (this._issaveadjustedcommitment == true) {
            for (var j = 0; j < headers.length; j++) {
                if (headers[j].includes("_Noteid")) {
                    this.dynamiccollistvalues.push({
                        "Rowno": rownumber, "CRENoteID": headers[j], "Amount": headervalues[j], "NoteId": null,
                        "NoteAdjustedTotalCommitment": null, "NoteAggregatedTotalCommitment": null, "NoteTotalCommitment": null
                    });
                }
            }
        }
    };
    DealDetailComponent.prototype.AssignValuestoAdjustedNoteCommitment = function (mode) {
        this.dynamiccollistvalues = [];
        var listnoteforadjutsedtotalcommitment = [];
        this._issaveadjustedcommitment = true;
        if (this.listAdjustedTotalCommitment) {
            var actualcollength = this.dynamicadjustedcollist.length;
            //to make columns as rows for noteid
            for (var t = 0; t < this.listAdjustedTotalCommitment.length; t++) {
                var data = this.listAdjustedTotalCommitment[t];
                var collistlength = Object.keys(data).length;
                var objectcolname = Object.keys(data);
                //to bind columns externally
                if (this.listAdjustedTotalCommitment[t].Date) {
                    if (this.listAdjustedTotalCommitment[t].TypeText) {
                        if (collistlength != actualcollength) {
                            for (var n = 0; n < actualcollength; n++) {
                                var notMatchFlag = false;
                                for (var le = 0; le < collistlength; le++) {
                                    if (objectcolname[le] == this.dynamicadjustedcollist[n]) {
                                        notMatchFlag = true;
                                        break;
                                    }
                                }
                                if (notMatchFlag == false) {
                                    data[this.dynamicadjustedcollist[n]] = null;
                                }
                            }
                            this.listAdjustedTotalCommitment[t] = data;
                        }
                        this.adjustedCommitmentcolumnheaders(data, t);
                    }
                }
            }
            //assign noteid to list
            if (mode == false) {
                this.showCalculatedNoteCommitments('save', 'e');
                for (var n = 0; n < this.listAdjustedTotalCommitment.length; n++) {
                    for (var k = 0; k < this.dynamiccollistvalues.length; k++) {
                        for (var l = 0; l < this.lstNote.length; l++) {
                            if (this.dynamiccollistvalues[k].Rowno == 0 && n == 0) {
                                if (this.dynamiccollistvalues[k].CRENoteID.includes("_Noteid")) {
                                    var splitnoteid = this.dynamiccollistvalues[k].CRENoteID.split("_Noteid");
                                    if (this.lstNote[l].CRENoteID == splitnoteid[0]) {
                                        this.dynamiccollistvalues[k].NoteId = this.lstNote[l].NoteId;
                                        this.dynamiccollistvalues[k].NoteAdjustedTotalCommitment = this.dynamiccollistvalues[k].Amount;
                                        this.dynamiccollistvalues[k].NoteAggregatedTotalCommitment = this.dynamiccollistvalues[k].Amount;
                                        this.dynamiccollistvalues[k].NoteTotalCommitment = this.dynamiccollistvalues[k].Amount;
                                    }
                                }
                            }
                            else {
                                if (!(n == 0)) {
                                    if (this.dynamiccollistvalues[k].Rowno == n) {
                                        if (this.dynamiccollistvalues[k].CRENoteID.includes("_Noteid")) {
                                            var splitnoteid = this.dynamiccollistvalues[k].CRENoteID.split("_Noteid");
                                            if (this.lstNote[l].CRENoteID == splitnoteid[0]) {
                                                this.dynamiccollistvalues[k].NoteId = this.lstNote[l].NoteId;
                                                for (var j = 0; j < this.dynamicadjustedcollist.length; j++) {
                                                    if (this.dynamicadjustedcollist[j].includes("_AdjustedCommitment")) {
                                                        var adjustednoteid = this.dynamicadjustedcollist[j].split("_AdjustedCommitment");
                                                        if (this.lstNote[l].CRENoteID == adjustednoteid[0]) {
                                                            this.dynamiccollistvalues[k].NoteAdjustedTotalCommitment = this.listAdjustedTotalCommitment[n][this.dynamicadjustedcollist[j]];
                                                        }
                                                    }
                                                    if (this.dynamicadjustedcollist[j].includes("_AggregateCommitment")) {
                                                        var aggregatednoteid = this.dynamicadjustedcollist[j].split("_AggregateCommitment");
                                                        if (this.lstNote[l].CRENoteID == aggregatednoteid[0]) {
                                                            this.dynamiccollistvalues[k].NoteAggregatedTotalCommitment = this.listAdjustedTotalCommitment[n][this.dynamicadjustedcollist[j]];
                                                        }
                                                    }
                                                    if (this.dynamicadjustedcollist[j].includes("_TotalCommitment")) {
                                                        var totalnoteid = this.dynamicadjustedcollist[j].split("_TotalCommitment");
                                                        if (this.lstNote[l].CRENoteID == totalnoteid[0]) {
                                                            this.dynamiccollistvalues[k].NoteTotalCommitment = this.listAdjustedTotalCommitment[n][this.dynamicadjustedcollist[j]];
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                } //end
                //Assinging data to deal list for total commitment
                var notetemp;
                for (var m = 0; m < this.listAdjustedTotalCommitment.length; m++) {
                    for (var j = 0; j < this.dynamiccollistvalues.length; j++) {
                        if (this.dynamiccollistvalues[j].Rowno == m) {
                            notetemp = new deals_1.DealAdjustedTotalCommitmentTab();
                            notetemp.DealID = this._deal.DealID;
                            notetemp.NoteID = this.dynamiccollistvalues[j].NoteId;
                            notetemp.CRENoteID = this.dynamiccollistvalues[j].CRENoteID;
                            notetemp.AdjustedCommitment = this.listAdjustedTotalCommitment[m].AdjustedCommitment;
                            notetemp.AggregatedCommitment = this.listAdjustedTotalCommitment[m].AggregatedCommitment;
                            notetemp.Amount = this.dynamiccollistvalues[j].Amount;
                            notetemp.Comments = this.listAdjustedTotalCommitment[m].Comments;
                            notetemp.Date = this.convertDatetoGMT(this.listAdjustedTotalCommitment[m].Date);
                            notetemp.DealAdjustmentHistory = this.listAdjustedTotalCommitment[m].DealAdjustmentHistory;
                            notetemp.NoteAdjustedCommitmentMasterID = this.listAdjustedTotalCommitment[m].NoteAdjustedCommitmentMasterID == null ? 0 : this.listAdjustedTotalCommitment[m].NoteAdjustedCommitmentMasterID;
                            notetemp.TotalCommitment = this.listAdjustedTotalCommitment[m].TotalCommitment;
                            notetemp.Type = this.listAdjustedTotalCommitment[m].Type;
                            notetemp.Rownumber = this.dynamiccollistvalues[j].Rowno;
                            notetemp.TypeText = this.listAdjustedTotalCommitment[m].TypeText;
                            notetemp.NoteAdjustedTotalCommitment = this.dynamiccollistvalues[j].NoteAdjustedTotalCommitment;
                            notetemp.NoteAggregatedTotalCommitment = this.dynamiccollistvalues[j].NoteAggregatedTotalCommitment;
                            notetemp.NoteTotalCommitment = this.dynamiccollistvalues[j].NoteTotalCommitment;
                            notetemp.TotalRequiredEquity = this.listAdjustedTotalCommitment[m].TotalRequiredEquity;
                            notetemp.TotalAdditionalEquity = this.listAdjustedTotalCommitment[m].TotalAdditionalEquity;
                            notetemp.ExcludeFromCommitmentCalculation = this.listAdjustedTotalCommitment[m].ExcludeFromCommitmentCalculation;
                            notetemp.TotalEquityatClosing = this.listAdjustedTotalCommitment[m].TotalEquityatClosing;
                            listnoteforadjutsedtotalcommitment.push(notetemp);
                        }
                    }
                }
                this._deal.Listadjustedtotlacommitment = listnoteforadjutsedtotalcommitment;
            } // end for save list
        }
    };
    DealDetailComponent.prototype.cellNoteEditEndingHandler = function (flex, e) {
        if (e.col.toString() == "1" || e.col.toString() == "0") {
            this._isnotegridEdited = true;
        }
    };
    DealDetailComponent.prototype.cellNoteEditfundingRule = function (flex, e) {
        if (e.col.toString() == "1" || e.col.toString() == "0") {
            this._isnotegridEdited = true;
        }
    };
    DealDetailComponent.prototype.CopiedNotefundingrule = function (flex, e) {
        this._isnotegridEdited = true;
    };
    DealDetailComponent.prototype.IDorNameChanged = function () {
        this.isIDorNameChanged = true;
    };
    DealDetailComponent.prototype.GetUserTimezoneByID = function () {
        var _this = this;
        this.membershipService.GetUserTimeZonebyUserID().subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.dt;
                _this._timezoneAbbreviation = data[0].Abbreviation;
            }
        });
    };
    //ShowAutoSpreadEquity() {
    //    var modal = document.getElementById('AutospreadEquitydialogbox');
    //    modal.style.display = "block";
    //    $.getScript("/js/jsDrag.js");
    //    this.lstAutoEquity = new Array<AutoEquity>();
    //    var TotalRequiredEquity = 0;
    //    var TotalAdditionalEquity = 0;
    //    var TotalnoteInitialRequiredEquity = 0, TotalnoteInitialAdditionalEquity = 0
    //    if (this.lstAdjustedTotalCommitment) {
    //        for (var i = 0; i < this.lstAdjustedTotalCommitment.items.length; i++) {
    //            TotalRequiredEquity = TotalRequiredEquity + parseFloat(this.lstAdjustedTotalCommitment.items[i].TotalRequiredEquity);
    //            TotalAdditionalEquity = TotalAdditionalEquity + parseFloat(this.lstAdjustedTotalCommitment.items[i].TotalAdditionalEquity);
    //        }
    //    }
    //    if (this.lstNote) {
    //        for (var i = 0; i < this.lstNote.length; i++) {
    //            TotalnoteInitialRequiredEquity = TotalnoteInitialRequiredEquity + parseFloat(this.GetDefaultValue(this.lstNote[i].InitialRequiredEquity));
    //            TotalnoteInitialAdditionalEquity = TotalnoteInitialAdditionalEquity + parseFloat(this.GetDefaultValue(this.lstNote[i].InitialAdditionalEquity));
    //        }
    //    }
    //    this.autoEquity = new AutoEquity();
    //    this.autoEquity.EquityName = "Required Equity";
    //    if (TotalRequiredEquity)
    //        this.autoEquity.TotalCommitted = TotalRequiredEquity;
    //    else
    //        this.autoEquity.TotalCommitted = 0;
    //    if (this._autoTotalContriToDate)
    //        this.autoEquity.TotalContibutedDate = this.sumRequiredEquity + this.GetDefaultValue(TotalnoteInitialRequiredEquity);
    //    else
    //        this.autoEquity.TotalContibutedDate = 0 + this.GetDefaultValue(TotalnoteInitialRequiredEquity);
    //    this.autoEquity.RemainingtoContribute = this.autoEquity.TotalCommitted - this.autoEquity.TotalContibutedDate;
    //    if (this.autoEquity.TotalCommitted == 0)
    //        this.autoEquity.Percentcontributed = 0;
    //    else
    //        this.autoEquity.Percentcontributed = (this.autoEquity.TotalContibutedDate / this.autoEquity.TotalCommitted) * 100;
    //    this.lstAutoEquity.push(this.autoEquity);
    //    this.autoEquity = new AutoEquity();
    //    this.autoEquity.EquityName = "Additional Equity";
    //    if (TotalAdditionalEquity)
    //        this.autoEquity.TotalCommitted = TotalAdditionalEquity;
    //    else
    //        this.autoEquity.TotalCommitted = 0;
    //    if (this._autoSumAdditionalEquity)
    //        this.autoEquity.TotalContibutedDate = this._autoSumAdditionalEquity + this.GetDefaultValue(TotalnoteInitialAdditionalEquity);
    //    else
    //        this.autoEquity.TotalContibutedDate = 0 + this.GetDefaultValue(TotalnoteInitialAdditionalEquity);
    //    this.autoEquity.RemainingtoContribute = this.autoEquity.TotalCommitted - this.autoEquity.TotalContibutedDate
    //    if (this.autoEquity.TotalCommitted == 0)
    //        this.autoEquity.Percentcontributed = 0;
    //    else
    //        this.autoEquity.Percentcontributed = (this.autoEquity.TotalContibutedDate / this.autoEquity.TotalCommitted) * 100;
    //    this.lstAutoEquity.push(this.autoEquity);
    //    this.flexgrdAutoEquity.invalidate();
    //}
    DealDetailComponent.prototype.getEquityValues = function () {
        var TotalnoteInitialRequiredEquity = 0, TotalnoteInitialAdditionalEquity = 0;
        var sTotalRequiredEquity = 0, sTotalAdditionalEquity = 0;
        var sRequiredEquity = 0;
        var sAdditionalEquity = 0;
        var sEquityatClosing = 0;
        if (this._deal.EquityatClosing == 0 || this._deal.EquityatClosing == null || this._deal.EquityatClosing == undefined) {
            sEquityatClosing = 0;
        }
        else {
            sEquityatClosing = this._deal.EquityatClosing;
        }
        if (this.listdealfunding) {
            var today = new Date();
            var appliedfunding = this.listdealfunding.filter(function (x) { return x.Date < today; });
            if (this.lstAdjustedTotalCommitment) {
                for (var i = 0; i < this.lstAdjustedTotalCommitment.items.length; i++) {
                    if (this.lstAdjustedTotalCommitment.items[i].TotalRequiredEquity) {
                        sTotalRequiredEquity = sTotalRequiredEquity + parseFloat(this.lstAdjustedTotalCommitment.items[i].TotalRequiredEquity);
                    }
                    if (this.lstAdjustedTotalCommitment.items[i].TotalAdditionalEquity) {
                        sTotalAdditionalEquity = sTotalAdditionalEquity + parseFloat(this.lstAdjustedTotalCommitment.items[i].TotalAdditionalEquity);
                    }
                }
                var TotalComitted = this.GetDefaultValue(sTotalRequiredEquity + sTotalAdditionalEquity + sEquityatClosing);
                this._autoTotalComitted = this.formatNumberforTwoDecimalplaces(this.GetDefaultValue(sTotalRequiredEquity + sTotalAdditionalEquity + sEquityatClosing));
            }
            if (this.lstNote) {
                for (var i = 0; i < this.lstNote.length; i++) {
                    TotalnoteInitialRequiredEquity = TotalnoteInitialRequiredEquity + parseFloat(this.GetDefaultValue(this.lstNote[i].InitialRequiredEquity));
                    TotalnoteInitialAdditionalEquity = TotalnoteInitialAdditionalEquity + parseFloat(this.GetDefaultValue(this.lstNote[i].InitialAdditionalEquity));
                }
            }
            if (appliedfunding) {
                for (var i = 0; i < appliedfunding.length; i++) {
                    if (appliedfunding[i].RequiredEquity) {
                        sRequiredEquity = sRequiredEquity + parseFloat(appliedfunding[i].RequiredEquity);
                        //  sAdditionalEquity = sAdditionalEquity + parseFloat(appliedfunding[i].AdditionalEquity);
                    }
                    if (appliedfunding[i].AdditionalEquity) {
                        //  sRequiredEquity = sRequiredEquity + parseFloat(appliedfunding[i].RequiredEquity);
                        sAdditionalEquity = sAdditionalEquity + parseFloat(appliedfunding[i].AdditionalEquity);
                    }
                }
            }
            this.sumRequiredEquity = sRequiredEquity;
            this.sumAdditionalEquity = sAdditionalEquity;
            var TotalContriToDate = this.GetDefaultValue(sRequiredEquity + sAdditionalEquity + sEquityatClosing + TotalnoteInitialRequiredEquity + TotalnoteInitialAdditionalEquity);
            this._autoTotalContriToDate = this.formatNumberforTwoDecimalplaces(this.GetDefaultValue(sRequiredEquity + sAdditionalEquity + sEquityatClosing + TotalnoteInitialRequiredEquity + TotalnoteInitialAdditionalEquity));
            this._autoSumAdditionalEquity = sAdditionalEquity;
            this._autoRemainingtoContribute = this.formatNumberforTwoDecimalplaces(this.GetDefaultValue(parseFloat(TotalComitted) - parseFloat(TotalContriToDate)));
        }
    };
    //ClosePopUpAutospread() {
    //    var modal = document.getElementById('AutospreadEquitydialogbox');
    //    modal.style.display = "none";
    //}
    DealDetailComponent.prototype.AddEquityRowforAM = function () {
        this._isFundingruleChanged = true;
        var rowlength = 0;
        var row = new wjcGrid.Row();
        if (this.listAdjustedTotalCommitment.length > 1) {
            rowlength = this.listAdjustedTotalCommitment.length - 1;
            if (Object.keys(this.listAdjustedTotalCommitment[rowlength]).length == 0 || this.listAdjustedTotalCommitment[rowlength].TypeText == "") {
                this.listAdjustedTotalCommitment.splice(rowlength, 1);
            }
            rowlength = this.listAdjustedTotalCommitment.length;
            this.listAdjustedTotalCommitment.push({ "Type": "690", "TypeText": "Equity Rebalancing", "TotalRequiredEquity": 0.00, "TotalAdditionalEquity": 0.00 });
            this.flexadjustedtotalcommitment.rows.insert(rowlength, row);
        }
        else {
            rowlength = this.listAdjustedTotalCommitment.length;
            this.listAdjustedTotalCommitment.push({ "Type": "690", "TypeText": "Equity Rebalancing", "TotalRequiredEquity": 0.00, "TotalAdditionalEquity": 0.00 });
            this.flexadjustedtotalcommitment.rows.insert(rowlength, row);
        }
        var data = this.listAdjustedTotalCommitment;
        this.lstAdjustedTotalCommitment = new wjcCore.CollectionView(data);
        this.lstAdjustedTotalCommitment.trackChanges = true;
        this.flexadjustedtotalcommitment.invalidate();
    };
    //dealfundingExporttoexcel() {
    //    wjcGridXlsx.FlexGridXlsxConverter.save(this.flexdealfunding,
    //        {
    //            includeColumnHeaders: true,
    //            includeRowHeaders: false,
    //            sheetName: "DealFunding",
    //            includeCellStyles: false
    //            //  formatItem: this.customContent ? this._exportFormatItem : null
    //        },
    //        this._deal.DealName + '_DealFunding.xlsx');
    //}
    DealDetailComponent.prototype.invalidateFeeInvoicetab = function () {
        if (!this._isInvoiceTabclicked) {
            localStorage.setItem('ClickedTabId', 'aFeeInvoicetab');
            this._isInvoiceTabclicked = true;
            this.GetAllFeeInvoice();
        }
    };
    DealDetailComponent.prototype.GetAllFeeInvoice = function () {
        var _this = this;
        this._isListFetching = true;
        this.dealSrv.GetAllFeeInvoice(this._deal.DealID, 1, 50).subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.dt;
                if (data.length > 0) {
                    _this._isShowMsgForInvoices = false;
                    _this.MsgForInvoices = "";
                    _this.lstFeeInvoice = res.dt;
                    _this.convertDatetoGMTGrid(_this.lstFeeInvoice, "FeeInvoice");
                    var result = _this.lstFeeInvoice.map(function (el) {
                        var o = Object.assign({}, el);
                        o.DeltaAmount = 0;
                        return o;
                    });
                    _this.lstFeeInvoice = result;
                    for (var m = 0; m < _this.lstFeeInvoice.length; m++) {
                        _this.lstFeeInvoice[m].DeltaAmount = _this.lstFeeInvoice[m].AmountPaid - _this.lstFeeInvoice[m].Amount + _this.lstFeeInvoice[m].AmountAdj;
                    }
                    _this._lstFeeInvoice = new wjcCore.CollectionView(_this.lstFeeInvoice);
                    _this._lstFeeInvoice.trackChanges = true;
                    setTimeout(function () {
                        this.flexFeeInvoice.invalidate(true);
                        this._isListFetching = false;
                    }.bind(_this), 2000);
                }
                else {
                    _this._isListFetching = false;
                    _this._isShowMsgForInvoices = true;
                    _this.MsgForInvoices = "No invoices found.";
                }
            }
        });
    };
    //create draw fee invoice 
    DealDetailComponent.prototype.CreateInvoice = function () {
        var _this = this;
        this.CloseInvoicePopUp();
        try {
            this._isListFetching = true;
            this._drawFeeInvoice.TaskID = this.listdealfunding[this.invoiceRowindex].DealFundingID;
            this._drawFeeInvoice.FundingDate = this.convertDatetoGMT(this.listdealfunding[this.invoiceRowindex].Date);
            this._drawFeeInvoice.CreDealID = this._deal.CREDealID;
            this._drawFeeInvoice.DrawNo = this.listdealfunding[this.invoiceRowindex].Comment;
            this._drawFeeInvoice.DealName = this._deal.DealName;
            this._drawFeeInvoice.IsManualInvoice = true;
            this._drawFeeInvoice.UpdatedDate = this.listdealfunding[this.invoiceRowindex].UpdatedDate;
            this._drawFeeInvoice.InvoiceTypeID = 558;
            //this._drawFeeInvoice.TemplateName = "m61 invoice template";
            //this._drawFeeInvoice.InvoiceCode = "Draw Fees";
            this._drawFeeInvoice.StorageType = "Blob";
            this._drawFeeInvoice.FundingAmount = this.listdealfunding[this.invoiceRowindex].Value;
            this.wfSrv.CreateInvoice(this._drawFeeInvoice).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.GetDealFundingByDealID(_this._deal);
                    _this.NoOfFunSeqAdded = 0;
                    _this.NoOfRepSeqAdded = 0;
                    if (_this.grdflexDynamicColForSequence) {
                        _this.grdflexDynamicColForSequence.invalidate();
                    }
                    //   this.grdflexDynamicColForSequence.autoSizeColumns(0, this.grdflexDynamicColForSequence.columns.length - 1, false, 20);
                    setTimeout(function () {
                        if (this.grdflexDynamicColForSequence) {
                            this.grdflexDynamicColForSequence.autoSizeColumns(0, this.grdflexDynamicColForSequence.columns.length - 1, false, 20);
                        }
                    }.bind(_this), 10);
                    _this._Showmessagediv = true;
                    _this._ShowmessagedivMsg = "Invoice generated successfully";
                    setTimeout(function () {
                        this._Showmessagediv = false;
                        this._ShowmessagedivMsg = "";
                    }.bind(_this), 4000);
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
            this._isListFetching = false;
        }
    };
    DealDetailComponent.prototype.CloseInvoicePopUp = function () {
        var modal = document.getElementById('myModelConfirmInvoice');
        modal.style.display = "none";
    };
    DealDetailComponent.prototype.DownloadInvoice = function (DrawFeeFile, DrawFeeStatusName, rowindex) {
        if (DrawFeeStatusName == "Generate") {
            this.invoiceRowindex = rowindex;
            var myModelConfirmInvoice = document.getElementById('myModelConfirmInvoice');
            myModelConfirmInvoice.style.display = "block";
            $.getScript("/js/jsDrag.js");
        }
        else if (DrawFeeStatusName == "Invoiced" || DrawFeeStatusName == "Paid") {
            this.dealSrv.downloadObjectDocumentByStorageTypeAndLocation(DrawFeeFile, appsettings_1.AppSettings._invoiceStorageType, appsettings_1.AppSettings._invoiceLocation)
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
                dwldLink.setAttribute("download", DrawFeeFile);
                dwldLink.style.visibility = "hidden";
                document.body.appendChild(dwldLink);
                dwldLink.click();
                document.body.removeChild(dwldLink);
            }, function (error) {
                //  alert('Something went wrong');
            });
        }
    };
    DealDetailComponent.prototype.addFooterRowForAutospreadRepayment = function (flexGrid) {
        var row = new wjcGrid.GroupRow(); // create a GroupRow to show aggregates
        flexGrid.columnFooters.rows.push(row); // add the row to the column footer panel
    };
    DealDetailComponent.prototype.getProjectedPayOffDate = function (dealID) {
        var _this = this;
        this._isListFetching = true;
        var dtDeal = [];
        dtDeal.push({
            "DealID": dealID,
            "DealStatus": this._deal.Statusid
        });
        this.dealSrv.GetProjectedPayoffDatesByDealId(dtDeal).subscribe(function (res) {
            if (res.Succeeded) {
                _this.checkboxclicked = false;
                _this._isListFetching = false;
                var data = res._lstprojectedpayoffdates;
                _this._lstprojectedpayoffdates = data;
                for (var i = 0; i < _this._lstprojectedpayoffdates.length; i++) {
                    if (_this._lstprojectedpayoffdates[i].ProjectedPayoffAsofDate != null) {
                        _this._lstprojectedpayoffdates[i].ProjectedPayoffAsofDate = new Date(_this.convertDateToBindable(_this._lstprojectedpayoffdates[i].ProjectedPayoffAsofDate));
                    }
                }
                if (_this._deal.EnableAutospreadRepayments == true) {
                    if (_this._deal.AutoUpdateFromUnderwriting == true) {
                        if (data[0].ErrorMsg == "Success") {
                            _this.showBSMsg = '';
                            _this._ShowBSData = false;
                        }
                        else if (data[0].ErrorMsg == "No data for the deal in Backshop.") {
                            _this._ShowBSData = true;
                            _this.showBSMsg = "There is no data for cumulative probability in Backshop for this deal. Please disable Auto-update from Underwriting to use M61 data.";
                            setTimeout(function () {
                                _this._ShowBSData = false;
                                _this.showBSMsg = '';
                            }, 5000);
                        }
                        else {
                            if (data[0].ErrorMsg == "Backshop error.") {
                                _this._ShowBSData = true;
                                _this.showBSMsg = "Backshop Service currently not working.Please disable Auto-update from Underwriting to see M61 data.";
                                setTimeout(function () {
                                    _this._ShowBSData = false;
                                    _this.showBSMsg = '';
                                }, 5000);
                            }
                        }
                    }
                    _this.autospreadRepaygridBind();
                    _this.autospreadRepaymentDateFieldsBS();
                    var underwritingflag = _this._deal.AutoUpdateFromUnderwriting;
                    var roleAM = _this.isroleAssetManager;
                    _this.flexautospreadrepayments.itemFormatter = function (panel, r, c, cell) {
                        if (panel.cellType != wjcGrid.CellType.Cell) {
                            return;
                        }
                        if (roleAM == true) {
                            if (panel.columns[c].header == 'As Of Date' || panel.columns[c].header == 'Cumulative Probability') {
                                cell.style.backgroundColor = '#cfcfcf';
                            }
                        }
                        else if (underwritingflag == true) {
                            if (panel.columns[c].header == 'As Of Date' || panel.columns[c].header == 'Cumulative Probability' || panel.columns[c].header == 'Delete') {
                                cell.style.backgroundColor = '#cfcfcf';
                            }
                        }
                        else {
                            cell.style.backgroundColor = null;
                        }
                    };
                }
            }
        });
    };
    DealDetailComponent.prototype.onChangeEnableAutoSpreadRepaymentsCheckbox = function (e) {
        var checked = e.target.checked;
        this._isdealfundingChanged = false;
        var UseruleYlist = this.lstSequenceHistory.filter(function (x) { return x.UseRuletoDetermineNoteFundingText == "3" || x.UseRuletoDetermineNoteFundingText == "Y"; });
        if (checked == true) {
            this._deal.EnableAutospreadRepayments = true;
            this._deal.AutoUpdateFromUnderwriting = true;
            this.repaymentchecked = true;
            this.autospreadRepaygridBind();
            this.autospreadRepaymentDateFieldsBS();
            if (UseruleYlist.length == 0) {
                this._isautospreadRepaymentshow = true;
            }
            else {
                this._isautospreadRepaymentshow = false;
            }
        }
        else {
            this._deal.EnableAutospreadRepayments = false;
            if (this._isshowApplyNoteLevelPaydowns == false) {
                this._deal.ApplyNoteLevelPaydowns = false;
            }
            this._deal.AutoUpdateFromUnderwriting = false;
            this.repaymentchecked = false;
            if (this._isautospreadRepaymentshow == true) {
                this._isautospreadRepaymentshow = false;
            }
            if (UseruleYlist.length == 0) {
                this.DeleteDealFundingAndNoteFundingForUseRuleN();
            }
        }
        setTimeout(function () {
            this.AppliedReadOnly();
        }.bind(this), 100);
    };
    DealDetailComponent.prototype.onChangeBalanceAwareCheckbox = function (e) {
    };
    DealDetailComponent.prototype.onChangeAutoUpdateFromUnderwritingCheckbox = function (e) {
        var _this = this;
        this._deal.AutoUpdateFromUnderwriting = e.target.checked;
        this._isrepaymentChanged = true;
        var errormsg = '';
        if (this.checkboxclicked == true) {
            errormsg = 'Not Success';
        }
        else if (this._lstprojectedpayoffdates.length > 0) {
            errormsg = this._lstprojectedpayoffdates[0].ErrorMsg;
        }
        if (this._deal.AutoUpdateFromUnderwriting == true) {
            if (errormsg == "Not Success") {
                this._ShowBSData = true;
                this.showBSMsg = "Backshop Service currently not working.Please disbale Auto-update from Underwriting to see M61 data.";
                setTimeout(function () {
                    _this._ShowBSData = false;
                    _this.showBSMsg = '';
                }, 5000);
            }
            else if (errormsg == "No data for the deal in Backshop.") {
                this._ShowBSData = true;
                this.showBSMsg = "There is no data for cumulative probability in Backshop for this deal. Please disable Auto-update from Underwriting to use M61 data.";
                setTimeout(function () {
                    _this._ShowBSData = false;
                    _this.showBSMsg = '';
                }, 5000);
            }
            else if (errormsg == "Backshop error.") {
                this._ShowBSData = true;
                this.showBSMsg = "Backshop Service currently not working.Please disbale Auto-update from Underwriting to see M61 data.";
                setTimeout(function () {
                    _this._ShowBSData = false;
                    _this.showBSMsg = '';
                }, 5000);
            }
        }
        this.autospreadRepaygridBind();
        this.autospreadRepaymentDateFieldsBS();
    };
    DealDetailComponent.prototype.RepaymentAutoSpreadMethodIDChange = function (e) {
        this._isrepaymentChanged = true;
        this._deal.RepaymentAutoSpreadMethodID = e;
    };
    DealDetailComponent.prototype.autospreadRepaygridBind = function () {
        if (this._deal.AutoUpdateFromUnderwriting == true) {
            if (this._lstprojectedpayoffdates.length > 0) {
                this.lstcumulativeprobabilitybyDate = new wjcCore.CollectionView(this._lstprojectedpayoffdates);
            }
            else {
                var data = [];
                this.lstcumulativeprobabilitybyDate = new wjcCore.CollectionView(data);
            }
        }
        else {
            if (this.lstprojectedpayoffDBdata.length > 0) {
                this.lstcumulativeprobabilitybyDate = new wjcCore.CollectionView(this.lstprojectedpayoffDBdata);
            }
            else {
                var data = [];
                this.lstcumulativeprobabilitybyDate = new wjcCore.CollectionView(data);
            }
        }
        this.lstcumulativeprobabilitybyDate.trackChanges = true;
        this.flexautospreadrepayments.invalidate();
    };
    DealDetailComponent.prototype.autospreadRepaymentDateFieldsBS = function () {
        var expecteddate = document.getElementById("ExpectedFullRepaymentDate");
        var effectiveDate = document.getElementById("AutoPrepayEffectiveDate");
        var earliestrepaydate = document.getElementById("EarliestPossibleRepaymentDate");
        var latestrepaydate = document.getElementById("LatestPossibleRepaymentDate");
        var repaymethodid = document.getElementById('RepaymentAutoSpreadMethodID');
        var possiblerepayday = document.getElementById('PossibleRepaymentdayofthemonth');
        var repayallocationfreq = document.getElementById('Repaymentallocationfrequency');
        var blockoutperiod = document.getElementById('Blockoutperiod');
        if (this.flexautospreadrepayments) {
            var underwritingflag = this._deal.AutoUpdateFromUnderwriting;
            var roleAM = this.isroleAssetManager;
            this.flexautospreadrepayments.itemFormatter = function (panel, r, c, cell) {
                if (panel.cellType != wjcGrid.CellType.Cell) {
                    return;
                }
                if (roleAM == true) {
                    if (panel.columns[c].header == 'As Of Date' || panel.columns[c].header == 'Cumulative Probability' || panel.columns[c].header == 'Delete') {
                        cell.style.backgroundColor = '#cfcfcf';
                    }
                }
                else if (underwritingflag == true) {
                    if (panel.columns[c].header == 'As Of Date' || panel.columns[c].header == 'Cumulative Probability' || panel.columns[c].header == 'Delete') {
                        cell.style.backgroundColor = '#cfcfcf';
                    }
                }
                else {
                    cell.style.backgroundColor = null;
                }
            };
        }
        if (this.isroleAssetManager == true) {
            this._isReadOnlyBSDatesFields = true;
            expecteddate.setAttribute("style", "background-color: #cfcfcf;");
            effectiveDate.setAttribute("style", "background-color: #cfcfcf;");
            earliestrepaydate.setAttribute("style", "background-color: #cfcfcf;");
            latestrepaydate.setAttribute("style", "background-color: #cfcfcf;");
            repaymethodid.setAttribute("style", "background-color: #cfcfcf;");
            possiblerepayday.setAttribute("style", "background-color: #cfcfcf;");
            blockoutperiod.setAttribute("style", "background-color: #cfcfcf;");
            repayallocationfreq.setAttribute("style", "background-color: #cfcfcf;");
        }
        else if (this._deal.AutoUpdateFromUnderwriting == true) {
            this._isReadOnlyBSDatesFields = true;
            expecteddate.setAttribute("style", "background-color: #cfcfcf;");
            effectiveDate.setAttribute("style", "background-color: #cfcfcf;");
            earliestrepaydate.setAttribute("style", "background-color: #cfcfcf;");
            latestrepaydate.setAttribute("style", "background-color: #cfcfcf;");
            if (this._lstprojectedpayoffdates.length > 0) {
                if (this._lstprojectedpayoffdates[0].EarliestDate != null) {
                    this.EarliestPossibleRepaymentDateBS = new Date(this.convertDateToBindable(this._lstprojectedpayoffdates[0].EarliestDate));
                }
                else {
                    this.EarliestPossibleRepaymentDateBS = null;
                }
                if (this._lstprojectedpayoffdates[0].ExpectedDate != null) {
                    this.ExpectedDateBS = new Date(this.convertDateToBindable(this._lstprojectedpayoffdates[0].ExpectedDate));
                }
                else {
                    this.ExpectedDateBS = null;
                }
                if (this._lstprojectedpayoffdates[0].LatestDate != null) {
                    this.LatestPossibleRepaymentDateBS = new Date(this.convertDateToBindable(this._lstprojectedpayoffdates[0].LatestDate));
                }
                else {
                    this.LatestPossibleRepaymentDateBS = null;
                }
                if (this._lstprojectedpayoffdates[0].AuditUpdateDate != null) {
                    this.EffectiveDateBS = new Date(this.convertDateToBindable(this._lstprojectedpayoffdates[0].AuditUpdateDate));
                }
                else {
                    this.EffectiveDateBS = null;
                }
            }
            else {
                this.EffectiveDateBS = null;
                this.LatestPossibleRepaymentDateBS = null;
                this.ExpectedDateBS = null;
                this.EarliestPossibleRepaymentDateBS = null;
            }
        }
        else {
            expecteddate.setAttribute("style", "background-color: none;");
            effectiveDate.setAttribute("style", "background-color:none;");
            earliestrepaydate.setAttribute("style", "background-color:none;");
            latestrepaydate.setAttribute("style", "background-color:none;");
            this._isReadOnlyBSDatesFields = false;
            this.EarliestPossibleRepaymentDateBS = this._deal.EarliestPossibleRepaymentDate;
            this.ExpectedDateBS = this._deal.ExpectedFullRepaymentDate;
            this.LatestPossibleRepaymentDateBS = this._deal.LatestPossibleRepaymentDate;
            this.EffectiveDateBS = this._deal.AutoPrepayEffectiveDate;
        }
        // to compare data between backshop and M61.
        if (this._deal.EnableAutospreadRepayments == true) {
            if (this.lstprojectedpayoffDBdata.length > 0 && this._lstprojectedpayoffdates.length > 0) {
                if (this.lstprojectedpayoffDBdata[0].EarliestDate != this._lstprojectedpayoffdates[0].EarliestDate) {
                    this._isautospreadrepaydataChanged = true;
                }
                else if (this.lstprojectedpayoffDBdata[0].ExpectedDate != this._lstprojectedpayoffdates[0].ExpectedDate) {
                    this._isautospreadrepaydataChanged = true;
                }
                else if (this.lstprojectedpayoffDBdata[0].LatestDate != this._lstprojectedpayoffdates[0].LatestDate) {
                    this._isautospreadrepaydataChanged = true;
                }
                else if (this.lstprojectedpayoffDBdata[0].AuditUpdateDate != this._lstprojectedpayoffdates[0].AuditUpdateDate) {
                    this._isautospreadrepaydataChanged = true;
                }
                else {
                    if (this._isautospreadrepaydataChanged == false) {
                        for (var k = 0; k < this.lstprojectedpayoffDBdata.length; k++) {
                            for (var j = 0; j < this._lstprojectedpayoffdates.length; j++) {
                                if (this.lstprojectedpayoffDBdata[k].ProjectedPayoffAsofDate == this._lstprojectedpayoffdates[j].ProjectedPayoffAsofDate) {
                                    this._isautospreadrepaydataChanged = false;
                                }
                                else {
                                    this._isautospreadrepaydataChanged = true;
                                    break;
                                }
                                if (this._isautospreadrepaydataChanged == false) {
                                    if (this.lstprojectedpayoffDBdata[k].CumulativeProbability == this._lstprojectedpayoffdates[j].CumulativeProbability) {
                                        this._isautospreadrepaydataChanged = false;
                                    }
                                    else {
                                        this._isautospreadrepaydataChanged = true;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if (this._isrepaymentChanged == false) {
                if (this.lstprojectedpayoffDBdata.length != this._lstprojectedpayoffdates.length) {
                    this._isrepaymentChanged = true;
                }
                else if (this._isautospreadrepaydataChanged == true) {
                    this._isrepaymentChanged = true;
                }
                else {
                    this._isrepaymentChanged = false;
                }
            }
        }
    };
    DealDetailComponent.prototype.celleditautospreadrepay = function (s, e) {
        if (this._deal.AutoUpdateFromUnderwriting == false || this._deal.AutoUpdateFromUnderwriting == null) {
            var rowdata = this.flexautospreadrepayments.rows[e.row].dataItem;
            if (Object.keys(rowdata).length > 0) {
                if (this.lstprojectedpayoffDBdata.length == 0) {
                    this.lstprojectedpayoffDBdata.push({
                        "ProjectedPayoffAsofDate": rowdata.ProjectedPayoffAsofDate, "CumulativeProbability": rowdata.CumulativeProbability
                    });
                }
                else {
                    this.lstprojectedpayoffDBdata[e.row].ProjectedPayoffAsofDate = rowdata.ProjectedPayoffAsofDate;
                    this.lstprojectedpayoffDBdata[e.row].CumulativeProbability = rowdata.CumulativeProbability;
                }
                this.checkDuplicateDates(this.flexautospreadrepayments.rows);
            }
        }
    };
    DealDetailComponent.prototype.Copiedautospreadrepay = function (s, e) {
        if (this._deal.AutoUpdateFromUnderwriting == false || this._deal.AutoUpdateFromUnderwriting == null) {
            this.checkDuplicateDates(this.flexautospreadrepayments.rows);
            var newlist = [];
            for (var j = 0; j < this.flexautospreadrepayments.rows.length - 1; j++) {
                newlist.push({ "ProjectedPayoffAsofDate": this.flexautospreadrepayments.rows[j].dataItem.ProjectedPayoffAsofDate, "CumulativeProbability": this.flexautospreadrepayments.rows[j].dataItem.CumulativeProbability });
            }
            this.lstprojectedpayoffDBdata = newlist;
            this.autospreadRepaygridBind();
        }
    };
    DealDetailComponent.prototype.checkDuplicateDates = function (data) {
        var founddates = '';
        var duplicatedateerror = '';
        var datelist = [];
        for (var j = 0; j < data.length - 1; j++) {
            datelist.push({ "ProjectedPayoffAsofDate": data[j].dataItem.ProjectedPayoffAsofDate });
        }
        var distinct = [];
        for (var k = 0; k < datelist.length; k++) {
            var datetocheck = datelist[k].ProjectedPayoffAsofDate;
            if (datetocheck) {
                var formateddate = this.convertDateToBindable(datetocheck);
                for (var j = k + 1; j < datelist.length; j++) {
                    var chkdate = this.convertDateToBindable(datelist[j].ProjectedPayoffAsofDate);
                    if (chkdate == formateddate) {
                        if (!(datetocheck in distinct)) {
                            distinct.push(datetocheck);
                        }
                    }
                }
            }
        }
        if (distinct.length > 0) {
            var dates = distinct.filter(function (date, i, self) {
                return self.findIndex(function (d) { return d.getTime() === date.getTime(); }) === i;
            });
            if (dates.length) {
                for (var m = 0; m < dates.length; m++) {
                    founddates += this.convertDateToBindable(dates[m]) + ", ";
                }
            }
        }
        if (founddates != "") {
            founddates = founddates.substring(0, founddates.length - 1);
            duplicatedateerror = "<p> Autospread repayment date(s) found duplicates " + founddates.slice(0, -1) + "</p>";
            this.CustomAlert(duplicatedateerror);
        }
    };
    DealDetailComponent.prototype.OnchangeExpectedfullrepayment = function (e) {
        this._isrepaymentChanged = true;
        this._deal.ExpectedFullRepaymentDate = e;
    };
    DealDetailComponent.prototype.OnchangePossiblerepayment = function (e) {
        this._isrepaymentChanged = true;
        this._deal.PossibleRepaymentdayofthemonth = e == "" ? null : this._deal.PossibleRepaymentdayofthemonth;
    };
    DealDetailComponent.prototype.OnchangeRepaymentfrequency = function (e) {
        this._isrepaymentChanged = true;
        this._deal.Repaymentallocationfrequency = e == "" ? null : this._deal.Repaymentallocationfrequency;
    };
    DealDetailComponent.prototype.OnchangeEffectivedate = function (e) {
        this._isrepaymentChanged = true;
        this._deal.AutoPrepayEffectiveDate = e;
    };
    DealDetailComponent.prototype.OnchangeEarliestpossibleRepaymentdate = function (e) {
        this._isrepaymentChanged = true;
        this._deal.EarliestPossibleRepaymentDate = e;
    };
    DealDetailComponent.prototype.OnchangeLatestpossibleRepaymentdate = function (e) {
        this._isrepaymentChanged = true;
        this._deal.LatestPossibleRepaymentDate = e;
    };
    DealDetailComponent.prototype.OnchangeBlockoutperiod = function (e) {
        this._isrepaymentChanged = true;
        this._deal.Blockoutperiod = e == "" ? null : this._deal.Blockoutperiod;
    };
    DealDetailComponent.prototype.getProjectedPayOffDBData = function (dealID) {
        var _this = this;
        this._isListFetching = true;
        this.dealSrv.GetProjectedPayoffDBDataByDealId(dealID).subscribe(function (res) {
            if (res.Succeeded) {
                _this._isListFetching = false;
                _this.lstprojectedpayoffDBdata = res.dt;
                for (var j = 0; j < _this.lstprojectedpayoffDBdata.length; j++) {
                    if (_this.lstprojectedpayoffDBdata[j].ProjectedPayoffAsofDate != null) {
                        _this.lstprojectedpayoffDBdata[j].ProjectedPayoffAsofDate = new Date(_this.convertDateToBindable(_this.lstprojectedpayoffDBdata[j].ProjectedPayoffAsofDate));
                    }
                }
                _this.autospreadRepaygridBind();
                _this.autospreadRepaymentDateFieldsBS();
            }
        });
    };
    DealDetailComponent.prototype.exportToExcel = function (filename, arr, sheets) {
        var fileName = filename + '.xlsx';
        var ws = XLSX.WorkSheet;
        var wb = XLSX.WorkBook;
        wb = XLSX.utils.book_new();
        wb.Props = {
            Title: "CRES",
            Subject: fileName,
            Author: "M61",
            CreatedDate: Date.now()
        };
        for (var i = 0; i < arr.length; i++) {
            ws = XLSX.utils.json_to_sheet(arr[i]);
            XLSX.utils.book_append_sheet(wb, ws, sheets[i]);
        }
        XLSX.writeFile(wb, fileName);
    };
    DealDetailComponent.prototype.celleditFeeInvoice = function (s, e) {
        var deccount = 0;
        var feeadjamountcol = this.flexFeeInvoice.getColumn("AmountAdj").index;
        if (e.col.toString() == feeadjamountcol.toString()) {
            var FeeAmtdec = this.lstFeeInvoice[e.row].AmountAdj;
            if (Math.floor(FeeAmtdec) === FeeAmtdec) {
                deccount = 0;
            }
            else {
                if ((FeeAmtdec % 1) != 0) {
                    deccount = FeeAmtdec.toString().split(".")[1].length || 0;
                }
            }
            if (deccount > 2) {
                this.lstFeeInvoice[e.row].AmountAdj = parseFloat(parseFloat(this.lstFeeInvoice[e.row].AmountAdj).toFixed(2));
                this.CustomAlert("Adjustment amount can't have more than 2 decimal places. System has rounded the inputs to 2 decimal places.");
                this.flexFeeInvoice.select(e.row, e.col);
                // Focus on select row and ready for editing
                this.flexFeeInvoice.focus();
                return;
            }
            this.lstFeeInvoice[e.row].DeltaAmount = this.lstFeeInvoice[e.row].AmountPaid - this.lstFeeInvoice[e.row].Amount + this.lstFeeInvoice[e.row].AmountAdj;
        }
    };
    DealDetailComponent.prototype.SaveFeeInvoices = function () {
        var dtFeeInvoice = [];
        if (this.flexFeeInvoice) {
            for (var k = 0; k < this.flexFeeInvoice.rows.length; k++) {
                dtFeeInvoice.push({
                    "InvoiceDetailID": this.flexFeeInvoice.rows[k].dataItem.InvoiceDetailID,
                    "ObjectID": this.flexFeeInvoice.rows[k].dataItem.ObjectID,
                    "AmountAdj": this.flexFeeInvoice.rows[k].dataItem.AmountAdj,
                    "InvoiceComment": this.flexFeeInvoice.rows[k].dataItem.InvoiceComment,
                    // Added NEW Invoice Comment//
                    "BatchUploadComment": this.flexFeeInvoice.rows[k].dataItem.BatchUploadComment
                });
            }
        }
        this._deal.ListFeeInvoice = dtFeeInvoice;
    };
    DealDetailComponent.prototype.CopiedFeeInvoice = function (s, e) {
        var deccount = 0;
        var feeadjamountcol = this.flexFeeInvoice.getColumn("AmountAdj").index;
        if (e.col.toString() == feeadjamountcol.toString()) {
            for (var k = 0; k < this.lstFeeInvoice.length; k++) {
                var FeeAmtdec = this.lstFeeInvoice[k].AmountAdj;
                if (Math.floor(FeeAmtdec) === FeeAmtdec) {
                    deccount = 0;
                }
                else {
                    if ((FeeAmtdec % 1) != 0) {
                        deccount = FeeAmtdec.toString().split(".")[1].length || 0;
                    }
                }
                if (deccount > 2) {
                    this.lstFeeInvoice[k].AmountAdj = parseFloat(parseFloat(this.lstFeeInvoice[k].AmountAdj).toFixed(2));
                    this.CustomAlert("Adjustment amount can't have more than 2 decimal places. System has rounded the inputs to 2 decimal places.");
                    // this.flexFeeInvoice.select(rows[k], col[k]);
                    // Focus on select row and ready for editing
                    // this.flexFeeInvoice.focus();
                    return;
                }
                this.lstFeeInvoice[k].DeltaAmount = this.lstFeeInvoice[k].AmountPaid - this.lstFeeInvoice[k].Amount + this.lstFeeInvoice[k].AmountAdj;
            }
        }
    };
    DealDetailComponent.prototype.generateAutospreadRepayment = function () {
        if (this.lstNote[0] != null) {
            this.isShowGenerateAutospreadRepay = true;
            this._isShowSaveDeal = false;
            var maxmat = null;
            var maxextendedmat = null;
            var max_ExtensionMat = null;
            var maxInitialMaturityDate = new Date('1970-01-01Z00:00:00:000');
            var maxFullyExtendedMaturityDate = new Date('1970-01-01Z00:00:00:000');
            var maxExtendedMaturity = new Date('1970-01-01Z00:00:00:000');
            max_ExtensionMat = null;
            var maxActualPayoffDate = new Date('1970-01-01Z00:00:00:000');
            var usePayOffasmaturity = false;
            if (this.maturityList !== undefined) {
                if (this.maturityList.length > 0) {
                    var vlen = this.maturityList.filter(function (x) { return x.ActualPayoffDate == null; }).length;
                    if (vlen == 0) {
                        usePayOffasmaturity = true;
                    }
                }
            }
            if (this.isMaturityDataChanged == true) {
                //708	118	Initial
                //709	118	Extension
                //710	118	Fully extended
                //this.selectedGroupName
                if (this._lstChangedMaturityData !== undefined) {
                    if (this._lstChangedMaturityData.length > 0) {
                        for (var i = 0; i < this._lstChangedMaturityData.length; i++) {
                            if (this._lstChangedMaturityData[i].Approved == 3 && this._lstChangedMaturityData[i].IsDeleted == 0 && this._lstChangedMaturityData[i].GroupName == this.selectedGroupName) {
                                if (this._lstChangedMaturityData[i].MaturityType == 708) {
                                    if (new Date(this._lstChangedMaturityData[i].MaturityDate) > maxInitialMaturityDate) {
                                        maxInitialMaturityDate = this._lstChangedMaturityData[i].MaturityDate;
                                    }
                                }
                                if (this._lstChangedMaturityData[i].MaturityType == 710) {
                                    if (new Date(this._lstChangedMaturityData[i].MaturityDate) > maxFullyExtendedMaturityDate) {
                                        maxFullyExtendedMaturityDate = this._lstChangedMaturityData[i].MaturityDate;
                                    }
                                }
                                if (this._lstChangedMaturityData[i].MaturityTypeText == 709) {
                                    if (new Date(this._lstChangedMaturityData[i].MaturityDate) > maxExtendedMaturity) {
                                        maxExtendedMaturity = this._lstChangedMaturityData[i].MaturityDate;
                                    }
                                }
                            }
                        }
                    }
                }
                if (this.maturityList !== undefined) {
                    if (this.maturityList.length > 0) {
                        for (var i = 0; i < this.maturityList.length; i++) {
                            if (this.maturityList[i].ApprovedText == "Y" && this.maturityList[i].isDeleted == 0 && this.maturityList[i].MaturityGroupName != this.selectedGroupName) {
                                if (this.maturityList[i].MaturityTypeText == "Initial") {
                                    if (new Date(this.maturityList[i].MaturityDate) > maxInitialMaturityDate) {
                                        maxInitialMaturityDate = this.maturityList[i].MaturityDate;
                                    }
                                }
                                if (this.maturityList[i].MaturityTypeText == "Fully extended") {
                                    if (new Date(this.maturityList[i].MaturityDate) > maxFullyExtendedMaturityDate) {
                                        maxFullyExtendedMaturityDate = this.maturityList[i].MaturityDate;
                                    }
                                }
                                if (this.maturityList[i].MaturityTypeText == "Extension") {
                                    if (new Date(this.maturityList[i].MaturityDate) > maxExtendedMaturity) {
                                        maxExtendedMaturity = this.maturityList[i].MaturityDate;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else {
                if (this.maturityList !== undefined) {
                    if (this.maturityList.length > 0) {
                        for (var i = 0; i < this.maturityList.length; i++) {
                            if (this.maturityList[i].ApprovedText == "Y" && this.maturityList[i].isDeleted == 0) {
                                if (this.maturityList[i].MaturityTypeText == "Initial") {
                                    if (new Date(this.maturityList[i].MaturityDate) > maxInitialMaturityDate) {
                                        maxInitialMaturityDate = this.maturityList[i].MaturityDate;
                                    }
                                }
                                if (this.maturityList[i].MaturityTypeText == "Fully extended") {
                                    if (new Date(this.maturityList[i].MaturityDate) > maxFullyExtendedMaturityDate) {
                                        maxFullyExtendedMaturityDate = this.maturityList[i].MaturityDate;
                                    }
                                }
                                if (this.maturityList[i].MaturityTypeText == "Extension") {
                                    if (new Date(this.maturityList[i].MaturityDate) > maxExtendedMaturity) {
                                        maxExtendedMaturity = this.maturityList[i].MaturityDate;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if (maxInitialMaturityDate.getFullYear() < 2000) {
                maxInitialMaturityDate = new Date(Math.max.apply(null, this.lstNote.map(function (x) { return x.InitialMaturityDate; })));
                if (maxInitialMaturityDate.getFullYear() < 2000) {
                    maxInitialMaturityDate = null;
                }
            }
            if (maxFullyExtendedMaturityDate.getFullYear() < 2000) {
                maxFullyExtendedMaturityDate = new Date(Math.max.apply(null, this.lstNote.map(function (x) { return x.FullyExtendedMaturityDate; })));
                if (maxFullyExtendedMaturityDate.getFullYear() < 2000) {
                    maxFullyExtendedMaturityDate = null;
                }
            }
            if (maxExtendedMaturity.getFullYear() < 2000) {
                maxExtendedMaturity = new Date(Math.max.apply(null, this.lstNote.map(function (x) { return x.ExtendedMaturityCurrent; })));
                max_ExtensionMat = maxExtendedMaturity;
                if (maxExtendedMaturity.getFullYear() < 2000) {
                    maxExtendedMaturity = null;
                    max_ExtensionMat = this._deal.max_ExtensionMat;
                }
            }
            if (this.maturityActualPayoffDate != null) {
                maxActualPayoffDate = new Date(this.maturityActualPayoffDate);
            }
            if (maxActualPayoffDate != null || maxActualPayoffDate != undefined) {
                if (maxActualPayoffDate.getFullYear() < 2000) {
                    maxActualPayoffDate = null;
                }
            }
            var today = new Date();
            //ActualPayoffDate
            if (maxActualPayoffDate != null && usePayOffasmaturity == true) {
                maxmat = maxActualPayoffDate;
            }
            else if (max_ExtensionMat != null) {
                maxmat = max_ExtensionMat;
            }
            else {
                var nextInitialMaturityDate = this.getnextbusinessDate(new Date(JSON.parse(JSON.stringify(maxInitialMaturityDate))), -20, false);
                if (today >= nextInitialMaturityDate) {
                    var nextExtendedMaturityDate = this.getnextbusinessDate(new Date(JSON.parse(JSON.stringify(maxExtendedMaturity))), -20, false);
                    if (today >= nextExtendedMaturityDate) {
                        maxmat = maxFullyExtendedMaturityDate;
                    }
                    else {
                        maxmat = maxExtendedMaturity;
                    }
                }
                else {
                    //Use InitialMaturityDate if it is smaller than today date
                    maxmat = maxInitialMaturityDate;
                }
                maxmat = this.getPreviousWorkingDate(new Date(JSON.parse(JSON.stringify(maxmat))));
                for (var val = 0; val < this.lstNote.length; val++) {
                    var current = this.lstNote[val];
                    if (maxextendedmat == null || current.FullyExtendedMaturityDate > maxextendedmat) {
                        maxextendedmat = current.FullyExtendedMaturityDate;
                    }
                    if (this.minClosingDate === null || current.ClosingDate < this.minClosingDate) {
                        this.minClosingDate = current.ClosingDate;
                    }
                }
            }
        }
        var fundingerror = "";
        var errordate = '';
        var fundingdates = "";
        //deal funding loop start
        var notwireDealfunding = this.listdealfunding.filter(function (x) { return x.Applied != true || x.Applied == undefined; });
        if (notwireDealfunding.length > 0) {
            for (var t = 0; t < notwireDealfunding.length; t++) {
                //Row Total start
                var rowtotal = 0, dealrowfund = 0;
                var purpose = "";
                var comment = "";
                var checkfortotal = true;
                dealrowfund = notwireDealfunding[t].Value;
                if (notwireDealfunding[t].PurposeText) {
                    purpose = notwireDealfunding[t].PurposeText;
                }
                if (notwireDealfunding[t].Comment) {
                    comment = notwireDealfunding[t].Comment;
                }
                if (purpose == "Paydown") {
                    if (comment == "") {
                        checkfortotal = false;
                    }
                    else {
                        checkfortotal = true;
                    }
                }
                if (checkfortotal == true) {
                    //increment for adding new column in dealfunding grid
                    if (this.dynamicColList.length > 32) {
                        for (var m = 33; m < this.dynamicColList.length; m++) {
                            if (this.dynamicColList[m] != "Date" && this.dynamicColList[m] != "PurposeID" && this.dynamicColList[m] != "DealFundingRowno" && this.dynamicColList[m] != "Applied") {
                                if (notwireDealfunding[t][this.dynamicColList[m]]) {
                                    if (notwireDealfunding[t][this.dynamicColList[m]].toString().includes(',')) {
                                        rowtotal += parseFloat(notwireDealfunding[t][this.dynamicColList[m]].replace(/,/g, ''));
                                        // rowtotal += notwireDealfunding[t][this.dynamicColList[m]];
                                    }
                                    else {
                                        rowtotal += parseFloat(notwireDealfunding[t][this.dynamicColList[m]]);
                                    }
                                }
                            }
                        }
                    }
                    else {
                        for (var m = 0; m < this.dynamicColList.length; m++) {
                            if (this.dynamicColList[m] != "Date" && this.dynamicColList[m] != "PurposeID" && this.dynamicColList[m] != "DealFundingRowno" && this.dynamicColList[m] != "Applied") {
                                if (notwireDealfunding[t][this.dynamicColList[m]]) {
                                    if (notwireDealfunding[t][this.dynamicColList[m]].toString().includes(',')) {
                                        // rowtotal += parseFloat(notwireDealfunding[t][this.dynamicColList[m]].toString().replace(',', '').toString().replace(',', ''));
                                        rowtotal += parseFloat(notwireDealfunding[t][this.dynamicColList[m]].replace(/,/g, ''));
                                        // rowtotal += notwireDealfunding[t][this.dynamicColList[m]];
                                    }
                                    else {
                                        rowtotal += parseFloat(notwireDealfunding[t][this.dynamicColList[m]]);
                                    }
                                }
                            }
                        }
                    }
                    if (rowtotal !== null && rowtotal !== undefined && dealrowfund !== null && dealrowfund !== undefined) {
                        if (parseFloat(parseFloat(rowtotal.toString()).toFixed(2)) != parseFloat(parseFloat(dealrowfund.toString()).toFixed(2))) {
                            this._isdealfundingChanged = false;
                            fundingdates += this.convertDateToBindable(notwireDealfunding[t].Date) + ", ";
                        }
                    }
                }
            }
        }
        if (fundingdates != "") {
            fundingerror = fundingerror + "<p>" + "At " + fundingdates.slice(0, fundingdates.length - 2) + " sum of note funding is not equal to deal funding." + "</p>";
        }
        if (fundingerror == "") {
            if (this._isautospreadRepaymentshow) {
                this.convertDatetoGMTGrid(this.listdealfunding, 'DealFunding');
                if (this._deal.EnableAutoSpread == true) {
                    this.convertDatetoGMTGrid(this.lstautospreadrule, "Auto Spread");
                }
                this._isListFetching = true;
                this.AssginValuesToDealDataContract();
                this.UpdateNoteDropDowns();
                this.lstNoteFunding = [];
                this.Dealfuturefunding.maxMaturityDate = this.convertDatetoGMT(maxFullyExtendedMaturityDate);
                this.Dealfuturefunding.EnableAutoSpread = this._deal.EnableAutoSpread;
                this.Dealfuturefunding.ServicerDropDate = this._deal.ServicerDropDate;
                this.Dealfuturefunding.FirstPaymentDate = this._deal.FirstPaymentDate;
                this.Dealfuturefunding.ServicereDayAjustement = this._deal.ServicereDayAjustement;
                this.Dealfuturefunding.ListNoteRepaymentBalances = this._deal.ListNoteRepaymentBalances;
                this.Dealfuturefunding.ListHoliday = this.ListHoliday;
                this.Dealfuturefunding.LastWireConfirmDate_db = this._deal.LastWireConfirmDate_db;
                this.Dealfuturefunding.EnableAutospreadUseRuleN = true;
                //   this.Dealfuturefunding.amort = this._deal.amort();
                this.CallPayRuleFutureFunding(this.Dealfuturefunding);
                this._isListFetching = false;
            }
        }
        else {
            this.CustomAlert(fundingerror);
            this._isListFetching = false;
            this.isShowGenerateAutospreadRepay = false;
            this._isShowSaveDeal = true;
        }
    };
    DealDetailComponent.prototype.dealfundingExporttoexcel = function () {
        var _this = this;
        this._isListFetching = true;
        var flexdealfunding = this.flexdealfunding.itemsSource._src;
        //  flexdealfunding[0]["NotesCount"] = this.lstNote.length;
        flexdealfunding[0]["NotesCount"] = this.flexdealfunding.columns.length - 12;
        for (var k = 0; k < flexdealfunding.length; k++) {
            var dealfundingcolumns = Object.keys(flexdealfunding[k]);
            if (flexdealfunding[k].Date != null) {
                flexdealfunding[k].Date = this.convertDatetoGMT(flexdealfunding[k].Date);
            }
            if (flexdealfunding[k].Value) {
                flexdealfunding[k].Value = flexdealfunding[k].Value.toString();
            }
            else {
                flexdealfunding[k].Value = "0";
            }
            if (flexdealfunding[k].PurposeText) {
                if (!(Number(flexdealfunding[k].PurposeText).toString() == "NaN" || Number(flexdealfunding[k].PurposeText) == 0)) {
                    var currentpurposeid;
                    currentpurposeid = Number(flexdealfunding[k].PurposeText);
                    flexdealfunding[k].PurposeText = this.lstPurposeType.find(function (x) { return x.LookupID == currentpurposeid; }).Name;
                }
            }
            for (var i = 0; i < this.lstNote.length; i++) {
                if (dealfundingcolumns.includes(this.lstNote[i].Name)) {
                    if (flexdealfunding[k][this.lstNote[i].Name]) {
                        flexdealfunding[k][this.lstNote[i].Name] = flexdealfunding[k][this.lstNote[i].Name].toString();
                    }
                    else {
                        flexdealfunding[k][this.lstNote[i].Name] = "0";
                    }
                }
            }
        }
        this.dealSrv.downloadexcelfile(flexdealfunding)
            .subscribe(function (fileData) {
            _this._isListFetching = false;
            for (var k = 0; k < flexdealfunding.length; k++) {
                if (flexdealfunding[k].Value) {
                    flexdealfunding[k].Value = parseFloat(flexdealfunding[k].Value);
                }
                for (var i = 0; i < _this.lstNote.length; i++) {
                    if (dealfundingcolumns.includes(_this.lstNote[i].Name)) {
                        {
                            if (flexdealfunding[k][_this.lstNote[i].Name]) {
                                flexdealfunding[k][_this.lstNote[i].Name] = flexdealfunding[k][_this.lstNote[i].Name] = flexdealfunding[k][_this.lstNote[i].Name] == 0 ? null : parseFloat(flexdealfunding[k][_this.lstNote[i].Name]);
                            }
                        }
                    }
                }
                if (flexdealfunding[k].Value == 0) {
                    for (var i = 0; i < _this.lstNote.length; i++) {
                        if (dealfundingcolumns.includes(_this.lstNote[i].Name)) {
                            {
                                flexdealfunding[k][_this.lstNote[i].Name] = 0;
                            }
                        }
                    }
                }
            }
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
            dwldLink.setAttribute("download", _this._deal.DealName + '_DealFunding.xlsx');
            dwldLink.style.visibility = "hidden";
            document.body.appendChild(dwldLink);
            dwldLink.click();
            document.body.removeChild(dwldLink);
            _this.isProcessComplete = false;
        }, function (error) {
            console.log(error);
            // alert('Something went wrong');
            _this.isProcessComplete = false;
            ;
        });
    };
    DealDetailComponent.prototype.EnableDisableAutospreadRepayments = function () {
        var check = 0;
        var result = this.listdealfunding.filter(function (x) { return x.PurposeText == "Full Payoff"; });
        if (result === undefined || result === null || result.length == 0) {
            result = this.listdealfunding.filter(function (x) { return x.PurposeText == "630"; });
        }
        if (result !== undefined) {
            if (result !== null) {
                if (result.length > 0) {
                    check = 1;
                    this._deal.EnableAutospreadRepayments == false;
                    this._deal.ApplyNoteLevelPaydowns = false;
                    this.repaymentchecked = false;
                    this._ispaidofdeal = true;
                    $('#EnableAutoSpreadRepayments').attr("disabled", "disabled");
                    $('#EnableAutoSpreadRepayments').attr('style', 'background-color:#D3D3D3');
                }
            }
        }
        if (check == 0) {
            this._ispaidofdeal = false;
            if (this.isroleAssetManager == false) {
                $('#EnableAutoSpreadRepayments').removeAttr('disabled');
                $('#EnableAutoSpreadRepayments').attr('style', 'background-color:none');
            }
        }
        var lstUseRuleN = this.lstSequenceHistory.filter(function (x) { return x.UseRuletoDetermineNoteFundingText == "3" || x.UseRuletoDetermineNoteFundingText == "Y"; });
        var UseRuleNDeal = false;
        if (lstUseRuleN.length == 0) {
            UseRuleNDeal = true;
        }
        else {
            this.DealBtntype = 1;
        }
        if (this._ispaidofdeal == true) {
            if (UseRuleNDeal == true) {
                this.DeleteDealFundingAndNoteFundingForUseRuleN();
                this._isautospreadRepaymentshow = false;
                this._deal.EnableAutospreadRepayments = false;
                this._deal.ApplyNoteLevelPaydowns = false;
                this.DealBtntype = 0;
            }
        }
        else {
            if (UseRuleNDeal == true) {
                if (this.LastPurposeType == '630' || "Full Payoff") {
                    this._deal.EnableAutospreadRepayments = this._deal.EnableAutospreadRepayments_db;
                }
                if (this._deal.EnableAutospreadRepayments == true) {
                    this._deal.EnableAutospreadRepayments = true;
                    //Commented date: 5/31/2022
                    //  this._deal.AutoUpdateFromUnderwriting = true;
                    this.repaymentchecked = true;
                    this.autospreadRepaygridBind();
                    this.autospreadRepaymentDateFieldsBS();
                    this._isautospreadRepaymentshow = true;
                    this.DealBtntype = 2;
                }
                else {
                    this._isautospreadRepaymentshow = false;
                    this.DealBtntype = 0;
                }
            }
        }
    };
    DealDetailComponent.prototype.invalidateMaturitytab = function () {
        var _this = this;
        this._isListFetching = true;
        if (this.maturityList.length == 0) {
            this.getDealMaturitybyID(this._deal.DealID);
        }
        else {
            this.createMaturityConfigurationList();
        }
        localStorage.setItem('ClickedTabId', 'aMaturitytab');
        setTimeout(function () {
            _this._isListFetching = false;
        }, 1000);
    };
    DealDetailComponent.prototype.getDealMaturitybyID = function (id) {
        var _this = this;
        this.dealSrv.getMaturityDatesbyDealid(this._deal.DealID).subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.dt;
                var effectivedatedata = res.dtEffectiveDates;
                _this.maturityEffectiveDateslst = effectivedatedata;
                _this.maturityList = data;
                _this.ConvertToBindableAnyListDate(_this.maturityList, 'Maturity');
                for (var k = 0; k < _this.maturityList.length; k++) {
                    _this.maturityList[k].IsValidateMaturityDate = true;
                    _this.originalMaturityList.push({
                        'Approved': _this.maturityList[k].Approved,
                        'ApprovedText': _this.maturityList[k].ApprovedText,
                        'EffectiveDate': _this.maturityList[k].EffectiveDate,
                        'ExpectedMaturityDate': _this.maturityList[k].ExpectedMaturityDate,
                        'OpenPrepaymentDate': _this.maturityList[k].OpenPrepaymentDate,
                        'ActualPayoffDate': _this.maturityList[k].ActualPayoffDate,
                        'MaturityDate': _this.maturityList[k].MaturityDate,
                        'MaturityType': _this.maturityList[k].MaturityType,
                        'MaturityTypeText': _this.maturityList[k].MaturityTypeText,
                        'NoteID': _this.maturityList[k].NoteID,
                        'ScheduleID': _this.maturityList[k].ScheduleID,
                        'isDeleted': _this.maturityList[k].isDeleted,
                        'IsValidateMaturityDate': _this.maturityList[k].IsValidateMaturityDate,
                        'CRENoteID': _this.maturityList[k].CRENoteID,
                        'MaturityMethodID': _this.maturityList[k].MaturityMethodID,
                        'MaturityGroupName': _this.maturityList[k].MaturityGroupName
                    });
                }
                _this.createMaturityConfigurationList();
            }
        });
    };
    DealDetailComponent.prototype.createMaturityConfigurationList = function () {
        var matconfigdata = [];
        var lstdata = [];
        var lstConfigmat = [];
        var newnotelst = [];
        var lstnote = this.lstNote.filter(function (x) { return !(x.CRENoteID == undefined || x.CRENoteID == ''); });
        if (this.lstMaturityConfiguration.length == 0 || this.lstMaturityConfiguration == undefined) {
            lstdata = lstnote;
        }
        else if (this.lstMaturityConfiguration.length < lstnote.length) {
            for (var l = 0; l < lstnote.length; l++) {
                if (!('NoteId' in lstnote[l])) {
                    newnotelst.push(lstnote[l]);
                }
            }
            lstdata = this.lstMaturityConfiguration;
        }
        else {
            lstdata = this.lstMaturityConfiguration;
        }
        for (var n = 0; n < lstdata.length; n++) {
            var notename = lstdata[n].CRENoteID + ": " + lstdata[n].Name;
            var noteid = !lstdata[n].NoteID ? lstdata[n].NoteId : lstdata[n].NoteID;
            lstConfigmat.push({
                "NoteSequenceNumber": lstdata[n].NoteSequenceNumber,
                "NoteID": noteid == undefined ? '00000000-0000-0000-0000-000000000000' : noteid,
                "CRENoteID": lstdata[n].CRENoteID,
                "Name": lstdata[n].Name,
                "Note": lstdata[n].CRENoteID + ": " + lstdata[n].Name,
                "PreviousMethodID": !lstdata[n].MaturityMethodID ? '' : lstdata[n].MaturityMethodID,
                "PreviousMethodIDText": !lstdata[n].MaturityMethodIDText ? '' : lstdata[n].MaturityMethodIDText,
                "PreviousGroupName": !lstdata[n].MaturityGroupName ? '' : (lstdata[n].MaturityGroupName == "" || lstdata[n].MaturityGroupName.toString() == "null") ? notename : lstdata[n].MaturityGroupName,
                "MaturityGroupName": !lstdata[n].MaturityGroupName ? '' : lstdata[n].MaturityGroupName == "" || lstdata[n].MaturityGroupName.toString() == "null" ? '' : lstdata[n].MaturityGroupName,
                "MaturityMethodID": !lstdata[n].MaturityMethodID ? '' : lstdata[n].MaturityMethodID,
                "MaturityMethodIDText": !lstdata[n].MaturityMethodIDText ? '' : lstdata[n].MaturityMethodIDText,
            });
        }
        if (newnotelst.length > 0) {
            for (var l = 0; l < newnotelst.length; l++) {
                var notename = newnotelst[l].CRENoteID + ": " + newnotelst[l].Name;
                lstConfigmat.push({
                    "NoteSequenceNumber": newnotelst[l].NoteSequenceNumber,
                    "NoteID": '00000000-0000-0000-0000-000000000000',
                    "CRENoteID": newnotelst[l].CRENoteID,
                    "Name": newnotelst[l].Name,
                    "Note": notename,
                    "PreviousMethodID": '',
                    "PreviousMethodIDText": '',
                    "PreviousGroupName": '',
                    "MaturityGroupName": '',
                    "MaturityMethodID": '',
                    "MaturityMethodIDText": ''
                });
            }
        }
        this.lstMaturityConfiguration = lstConfigmat;
        var groupname = '';
        var uniquieData = [];
        var firstmethodidlst = this.lstMaturityConfiguration.filter(function (x) { return x.MaturityMethodIDText == "Most recent effective date" || x.MaturityMethodIDText == "All effective date(s)"; });
        var secondmethodidlst = this.lstMaturityConfiguration.filter(function (x) { return !(x.MaturityMethodIDText == "Most recent effective date" || x.MaturityMethodIDText == "All effective date(s)"); });
        for (var n = 0; n < firstmethodidlst.length; n++) {
            var Matnotename = firstmethodidlst[n].Note;
            if (!uniquieData.includes(firstmethodidlst[n].MaturityGroupName)) {
                uniquieData.push(firstmethodidlst[n].MaturityGroupName == "" || firstmethodidlst[n].MaturityGroupName.toString() == "null" ? Matnotename : firstmethodidlst[n].MaturityGroupName);
            }
        }
        for (var n = 0; n < secondmethodidlst.length; n++) {
            var Matnotename = secondmethodidlst[n].Note;
            if (!uniquieData.includes(secondmethodidlst[n].MaturityGroupName)) {
                uniquieData.push(secondmethodidlst[n].MaturityGroupName == "" || secondmethodidlst[n].MaturityGroupName.toString() == "null" ? Matnotename : secondmethodidlst[n].MaturityGroupName);
            }
        }
        for (var n = 0; n < uniquieData.length; n++) {
            var CRENotelist = this.lstMaturityConfiguration.filter(function (x) { return x.MaturityGroupName == uniquieData[n]; });
            var Notename = '';
            if (CRENotelist.length > 0) {
                for (var d = 0; d < CRENotelist.length; d++) {
                    Notename = Notename + CRENotelist[d].Name + ", ";
                }
            }
            else {
                var CRENotelist = this.lstMaturityConfiguration.filter(function (x) { return x.Note == uniquieData[n]; });
                Notename = CRENotelist[0].Name + ", ";
            }
            matconfigdata.push({
                "MaturityGroupName": uniquieData[n],
                "Maturitytooltip": Notename.substring(0, Notename.length - 2)
            });
        }
        groupname = this.lstMaturityConfiguration.filter(function (x) { return x.NoteSequenceNumber == 1; });
        this.lstGroupName = matconfigdata;
        this.invalidateMaturitygridData(this.maturityList, groupname[0]["MaturityGroupName"]);
        this.GetScheduleEffectiveDateCount();
    };
    DealDetailComponent.prototype.invalidateMaturitygridData = function (data, groupName) {
        var _this = this;
        this._isMaturityTabClicked = true;
        var filteredmatlist = [];
        var user = JSON.parse(localStorage.getItem('user'));
        this.userRolename = user.RoleName;
        var isdate = false;
        var splittedname = [];
        //new change
        if ((groupName)) {
            this.selectedGroupName = groupName;
            if (groupName[0].CRENoteID) {
                filteredmatlist = data.filter(function (x) { return x.CRENoteID == groupName[0].CRENoteID && x.isDeleted.toString() != 1; });
            }
            else {
                if (groupName.includes(":")) {
                    splittedname = groupName.split(":");
                    filteredmatlist = data.filter(function (x) { return x.CRENoteID == splittedname[0] && x.isDeleted.toString() != 1; });
                }
                else {
                    var minNoteValue_1 = Math.min.apply(null, this.lstMaturityConfiguration.filter(function (x) { return x.MaturityGroupName == groupName; }).map(function (item) { return item.NoteSequenceNumber == undefined ? 9999 : item.NoteSequenceNumber; }));
                    if (minNoteValue_1) {
                        var minCRENoteID_1 = this.lstMaturityConfiguration.find(function (x) { return x.NoteSequenceNumber == minNoteValue_1; }).CRENoteID;
                        filteredmatlist = data.filter(function (x) { return x.CRENoteID == minCRENoteID_1 && x.isDeleted.toString() != 1; });
                    }
                }
            }
        }
        else {
            if (groupName.includes(":")) {
                splittedname = groupName.split(":");
                var groupname = data.filter(function (x) { return x.CRENoteID == splittedname[0] && x.isDeleted.toString() != 1; })[0].MaturityGroupName;
                this.selectedGroupName = groupname;
            }
            else {
                filteredmatlist = data.filter(function (x) { return x.NoteID == _this.lstNote[0].NoteId && x.isDeleted.toString() != 1; });
                this.selectedGroupName = this.lstNote[0].CRENoteID + ':' + this.lstNote[0].Name;
            }
        }
        setTimeout(function () {
            _this._lstMaturity = new wjcCore.CollectionView(filteredmatlist);
            _this._lstMaturity.trackChanges = true;
            _this.flexMaturity.invalidate();
        }, 200);
        if (filteredmatlist.length > 0) {
            if (this._isMattabclicked == false) {
                this.OldmaturityEffectiveDate = filteredmatlist[0].EffectiveDate;
                this._isMattabclicked = true;
            }
            this.maturityEffectiveDate = filteredmatlist[0].EffectiveDate;
            this.maturityActualPayoffDate = filteredmatlist[0].ActualPayoffDate;
            this.maturityExpectedMaturityDate = filteredmatlist[0].ExpectedMaturityDate;
            this.maturityOpenPrepaymentDate = filteredmatlist[0].OpenPrepaymentDate;
        }
        else {
            this.maturityEffectiveDate = null;
            this.maturityActualPayoffDate = null;
            this.maturityExpectedMaturityDate = null;
            this.maturityOpenPrepaymentDate = null;
            this.OldmaturityEffectiveDate = null;
        }
        if (this.maturityActualPayoffDate) {
            isdate = true;
        }
        else {
            isdate = false;
            for (var k = 0; k < this.flexMaturity.rows.length - 1; k++) {
                if (this.flexMaturity.rows[k].dataItem.MaturityDate !== undefined && this.flexMaturity.rows[k].dataItem.MaturityDate !== "") {
                    this.holidayDateCheck(this.flexMaturity.rows[k].dataItem.MaturityDate, k, 'grid');
                }
            }
        }
        if (this.flexMaturity) {
            this.flexMaturity.itemFormatter = function (panel, r, c, cell) {
                if (panel.cellType != wjcGrid.CellType.Cell) {
                    return;
                }
                if (user.RoleName == "Asset Manager") {
                    if (panel.columns[c].header == 'Maturity date' || panel.columns[c].header == 'Type' || panel.columns[c].header == 'Delete') {
                        cell.style.backgroundColor = '#cfcfcf';
                    }
                    else {
                        cell.style.backgroundColor = null;
                    }
                }
                else {
                    if (isdate == true) {
                        if (panel.columns[c].header == 'Maturity date' || panel.columns[c].header == 'Type' || panel.columns[c].header == 'Approved' || panel.columns[c].header == 'Delete') {
                            cell.style.backgroundColor = '#cfcfcf';
                        }
                    }
                    else {
                        if (panel.columns[c].header == 'Maturity date') {
                            if (panel.rows[r].dataItem) {
                                if (panel.rows[r].dataItem.IsValidateMaturityDate == false) {
                                    cell.style.backgroundColor = '#FFB3A7';
                                }
                                else {
                                    cell.style.backgroundColor = null;
                                }
                            }
                        }
                    }
                }
            };
        }
        if (user.RoleName != "Asset Manager") {
            if (isdate == true) {
                this._isActualpayoffDate = true;
                this.flexMaturity.allowAddNew = false;
                $('#EffectiveDate').attr('style', 'background-color:#D3D3D3');
                $('#OpenPrepaymentDate').attr('style', 'background-color:#D3D3D3');
                for (var k = 0; k < this.flexMaturity.rows.length; k++) {
                    if (this.flexMaturity.rows[k].dataItem) {
                        this.flexMaturity.rows[k].dataItem.IsValidateMaturityDate = true;
                    }
                }
                this.flexMaturity.invalidate();
            }
            else {
                this._isActualpayoffDate = false;
                this.flexMaturity.allowAddNew = true;
                var holidayeffectivedatestatus = this.holidayDateCheck(this.maturityEffectiveDate, k, 'otherdate');
                var holidayopenprepaydatestatus = this.holidayDateCheck(this.maturityOpenPrepaymentDate, k, 'otherdate');
                if (holidayeffectivedatestatus == true) {
                    $('#EffectiveDate').attr('style', 'background-color:#FFB3A7');
                }
                else {
                    $('#EffectiveDate').attr('style', 'background-color:none');
                }
                if (holidayopenprepaydatestatus == true) {
                    $('#OpenPrepaymentDate').attr('style', 'background-color:#FFB3A7');
                }
                else {
                    $('#OpenPrepaymentDate').attr('style', 'background-color:none');
                }
            }
            var holidayactualpayoffdatestatus = this.holidayDateCheck(this.maturityActualPayoffDate, k, 'otherdate');
            if (holidayactualpayoffdatestatus == true) {
                $('#ActualPayoffDate').attr('style', 'background-color:#FFB3A7');
            }
            else {
                $('#ActualPayoffDate').attr('style', 'background-color:none');
            }
            if (this._deal.EnableAutospreadRepayments == true) {
                $('#ExpectedMaturityDate').attr('style', 'background-color:#cfcfcf');
            }
            else {
                var holidayexpecteddatestatus = this.holidayDateCheck(this.maturityExpectedMaturityDate, k, 'otherdate');
                if (holidayexpecteddatestatus == true) {
                    $('#ExpectedMaturityDate').attr('style', 'background-color:#FFB3A7');
                }
                else {
                    $('#ExpectedMaturityDate').attr('style', 'background-color:none');
                }
            }
        }
        else {
            this.flexMaturity.allowAddNew = false;
            $('#EffectiveDate').attr('style', 'background-color:#cfcfcf');
            $('#OpenPrepaymentDate').attr('style', 'background-color:#cfcfcf');
            $('#ActualPayoffDate').attr('style', 'background-color:#cfcfcf');
            $('#ExpectedMaturityDate').attr('style', 'background-color:#cfcfcf');
            $('#DealLevelMaturity').attr("disabled", "disabled");
            this._isAMUser = true; // check
        }
        setTimeout(function () {
            if (_this._deal.EnableAutospreadRepayments == true) {
                if (_this._deal.RepayExpectedMaturityDate != null) {
                    _this.maturityExpectedMaturityDate = _this._deal.RepayExpectedMaturityDate;
                }
                else {
                    _this.maturityExpectedMaturityDate = _this.maturityExpectedMaturityDate;
                }
            }
            else {
                _this.maturityExpectedMaturityDate = _this.maturityExpectedMaturityDate;
            }
        }, 1000);
    };
    DealDetailComponent.prototype.viewDealMaturityHistory = function () {
        var _this = this;
        var modal = document.getElementById('myModal');
        modal.style.display = "block";
        $.getScript("/js/jsDrag.js");
        if (this.selectedGroupName) {
            if (this.selectedGroupName.includes(":")) {
                this.note.NoteId = this.selectedNoteID;
                this.note.AnalysisID = window.localStorage.getItem("scenarioid");
                this.note.modulename = 'Maturity';
                this.note.MaturityMethodID = 0;
            }
            else {
                var noteilds = '';
                var lstgrp = this.lstMaturityConfiguration.filter(function (x) { return x.MaturityGroupName == _this.selectedGroupName; });
                if (lstgrp) {
                    for (var i = 0; i < lstgrp.length; i++) {
                        noteilds += lstgrp[i]["CRENoteID"] + ",";
                    }
                }
                this.note.MultipleNoteids = noteilds;
                this.note.modulename = 'Maturity';
                this.note.MaturityMethodID = 1;
            }
        }
        else {
            if (this.selectedGroupName == '') {
                this.note.NoteId = this.lstNote[0].NoteId;
                this.note.AnalysisID = window.localStorage.getItem("scenarioid");
                this.note.modulename = 'Maturity';
                this.note.MaturityMethodID = 0;
            }
        }
        this.noteSrv.getHistoricalDataOfModuleByNoteIdAPI(this.note, this._pageIndex, this._pageSize).subscribe(function (res) {
            if (res.Succeeded) {
                if (res.StatusCode != 404) {
                    _this._isPeriodicDataFetched = true;
                    _this._isPeriodicDataFetching = false;
                    _this._isSetHeaderEmpty = false;
                    switch (_this.note.modulename) {
                        case "Maturity":
                            _this.modulename = "Maturity";
                            _this.lstPeriodicDataList = res.lstMaturityScenariosDataContract;
                            _this._isSetHeaderEmpty = true;
                            break;
                    }
                    for (var i = 0; i < _this.lstPeriodicDataList.length; i++) {
                        if (_this.lstPeriodicDataList[i]["Effective Date"] != null) {
                            _this.lstPeriodicDataList[i]["Effective Date"] = new Date(_this.lstPeriodicDataList[i]["Effective Date"].toString());
                        }
                        if (_this.lstPeriodicDataList[i]["Maturity Date"] != null) {
                            _this.lstPeriodicDataList[i]["Maturity Date"] = new Date(_this.lstPeriodicDataList[i]["Maturity Date"].toString());
                        }
                    }
                    var header = [];
                    var data = _this.lstPeriodicDataList;
                    $.each(data, function (obj) {
                        var i = 0;
                        $.each(data[obj], function (key, value) {
                            header[i] = key;
                            i = i + 1;
                        });
                        return false;
                    });
                    for (var j = 1; j < header.length; j++) {
                        _this.AddcolumnForViewHistory(header[j], header[j], 'n2');
                    }
                }
                else {
                    _this._isPeriodicDataFetching = false;
                    _this.calcExceptionMsg = "No record found";
                    _this._dvEmptyPeriodicDataMsg = true;
                    _this.lstPeriodicDataList = null;
                    _this._dvEmptyPeriodicDataMsg = true;
                    _this._isPeriodicDataFetched = false;
                }
            }
            else {
                _this._isPeriodicDataFetching = false;
                _this._dvEmptyPeriodicDataMsg = true;
                //return true;
            }
        });
    };
    DealDetailComponent.prototype.AddcolumnForViewHistory = function (header, binding, format) {
        try {
            this.columnsMatrity.push({ "header": header, "binding": binding, "format": format });
        }
        catch (err) { }
    };
    DealDetailComponent.prototype.GetScheduleEffectiveDateCount = function () {
        var _this = this;
        var noteilds = '';
        if ((this.selectedGroupName)) {
            if (this.selectedGroupName.includes(":")) {
                noteilds = this.selectedGroupName.split(":")[0];
            }
            else {
                var lstgrp = this.lstMaturityConfiguration.filter(function (x) { return x.MaturityGroupName == _this.selectedGroupName; });
                if (lstgrp) {
                    for (var i = 0; i < lstgrp.length; i++) {
                        noteilds += lstgrp[i]["CRENoteID"] + ",";
                    }
                }
            }
        }
        if (noteilds == '') {
            noteilds = this.lstNote[0].CRENoteID;
        }
        if (noteilds.includes(',')) {
            this.MaturityHistCount = null;
        }
        else {
            var selectedNoteID = this.lstNote.find(function (x) { return x.CRENoteID == noteilds; }).NoteId;
            this.selectedNoteID = selectedNoteID;
            this.dealSrv.GetScheduleEffectiveDateCount(this._deal.DealID).subscribe(function (res) {
                if (res.Succeeded) {
                    var data = res.dt;
                    _this.listMaturityHistCount = data;
                    if (_this.listMaturityHistCount) {
                        var EffectiveDateCounts = data.filter(function (x) { return x.NoteId == selectedNoteID; });
                        if (EffectiveDateCounts[0])
                            _this.MaturityHistCount = EffectiveDateCounts[0].EffectiveStartDateCounts;
                        else
                            _this.MaturityHistCount = 0;
                        //   this.MaturityHistCount = data.find(x => x.NoteId == selectedNoteID).EffectiveStartDateCounts;
                        if (_this.MaturityHistCount != 0)
                            _this.ShowHideFlagMaturitySchedule = true;
                    }
                    else {
                        _this.MaturityHistCount = 0;
                    }
                }
            });
        }
    };
    DealDetailComponent.prototype.cellDealMaturityEdit = function (maturityFlex, e) {
        this.isMaturityDataChanged = true;
        this.previousMaturityType = maturityFlex.rows[e.row].dataItem.MaturityType;
        if (!(Number(maturityFlex.rows[e.row].dataItem.MaturityTypeText).toString() == "NaN" || Number(maturityFlex.rows[e.row].dataItem.MaturityTypeText) == 0)) {
            maturityFlex.rows[e.row].dataItem.MaturityType = maturityFlex.rows[e.row].dataItem.MaturityTypeText;
            maturityFlex.rows[e.row].dataItem.MaturityTypeText = this.maturityTypeList.filter(function (x) { return x.LookupID.toString() == maturityFlex.rows[e.row].dataItem.MaturityTypeText; })[0].Name;
        }
        if (!(maturityFlex.rows[e.row].dataItem.MaturityTypeText == "" || maturityFlex.rows[e.row].dataItem.MaturityTypeText == undefined)) {
            if (maturityFlex.rows[e.row].dataItem.MaturityType.toString() == "708" || maturityFlex.rows[e.row].dataItem.MaturityType.toString() == "710") {
                maturityFlex.rows[e.row].dataItem.ApprovedText = 'Y';
                maturityFlex.rows[e.row].dataItem.Approved = this.maturityApprovedList.filter(function (x) { return x.Name.toString() == 'Y'; })[0].LookupID;
            }
            else if (maturityFlex.rows[e.row].dataItem.MaturityType.toString() == "709") {
                if (!(Number(maturityFlex.rows[e.row].dataItem.ApprovedText).toString() == "NaN" || Number(maturityFlex.rows[e.row].dataItem.ApprovedText) == 0)) {
                    maturityFlex.rows[e.row].dataItem.Approved = maturityFlex.rows[e.row].dataItem.ApprovedText;
                    maturityFlex.rows[e.row].dataItem.ApprovedText = this.maturityApprovedList.filter(function (x) { return x.LookupID.toString() == maturityFlex.rows[e.row].dataItem.ApprovedText; })[0].Name;
                }
            }
        }
        else {
            if (!(Number(maturityFlex.rows[e.row].dataItem.ApprovedText).toString() == "NaN" || Number(maturityFlex.rows[e.row].dataItem.ApprovedText) == 0)) {
                maturityFlex.rows[e.row].dataItem.Approved = maturityFlex.rows[e.row].dataItem.ApprovedText;
                maturityFlex.rows[e.row].dataItem.ApprovedText = this.maturityApprovedList.filter(function (x) { return x.LookupID.toString() == maturityFlex.rows[e.row].dataItem.ApprovedText; })[0].Name;
            }
        }
        this.createMaturityList('Edit', e.row, this.selectedGroupName);
    };
    DealDetailComponent.prototype.CopiedDealMaturity = function (maturityFlex, e) {
        this.isMaturityDataChanged = true;
        var rownum = '';
        for (var m = 0; m < maturityFlex.rows.length - 1; m++) {
            if (!(Number(maturityFlex.rows[m].dataItem.MaturityTypeText).toString() == "NaN" || Number(maturityFlex.rows[m].dataItem.MaturityTypeText) == 0)) {
                maturityFlex.rows[m].dataItem.MaturityType = maturityFlex.rows[m].dataItem.MaturityTypeText;
                maturityFlex.rows[m].dataItem.MaturityTypeText = this.maturityTypeList.filter(function (x) { return x.LookupID.toString() == maturityFlex.rows[m].dataItem.MaturityTypeText; })[0].Name;
            }
            if (!(maturityFlex.rows[m].dataItem.MaturityTypeText == "" || maturityFlex.rows[m].dataItem.MaturityTypeText == undefined)) {
                if (maturityFlex.rows[m].dataItem.MaturityType.toString() == "708" || maturityFlex.rows[m].dataItem.MaturityType.toString() == "710") {
                    maturityFlex.rows[m].dataItem.ApprovedText = 'Y';
                    maturityFlex.rows[m].dataItem.Approved = this.maturityApprovedList.filter(function (x) { return x.Name.toString() == 'Y'; })[0].LookupID;
                }
                else if (maturityFlex.rows[m].dataItem.MaturityType.toString() == "709") {
                    if (!(Number(maturityFlex.rows[m].dataItem.ApprovedText).toString() == "NaN" || Number(maturityFlex.rows[m].dataItem.ApprovedText) == 0)) {
                        maturityFlex.rows[m].dataItem.Approved = maturityFlex.rows[m].dataItem.ApprovedText;
                        var matname = this.maturityApprovedList.filter(function (x) { return x.LookupID.toString() == maturityFlex.rows[e.row].dataItem.ApprovedText; });
                        if (matname.length > 1) {
                            maturityFlex.rows[m].dataItem.ApprovedText = matname[0].Name;
                        }
                    }
                }
            }
            else {
                if (!(Number(maturityFlex.rows[m].dataItem.ApprovedText).toString() == "NaN" || Number(maturityFlex.rows[m].dataItem.ApprovedText) == 0)) {
                    maturityFlex.rows[m].dataItem.Approved = maturityFlex.rows[m].dataItem.ApprovedText;
                    var matname = this.maturityApprovedList.filter(function (x) { return x.LookupID.toString() == maturityFlex.rows[e.row].dataItem.ApprovedText; });
                    if (matname.length > 1) {
                        maturityFlex.rows[m].dataItem.ApprovedText = matname[0].Name;
                    }
                }
            }
        }
        this.createMaturityList('Copy', rownum, this.selectedGroupName);
    };
    DealDetailComponent.prototype.createMaturityList = function (modename, rownum, groupname) {
        var _this = this;
        var notedata = [];
        var CRENoteID = '';
        var NoteID = '';
        var minNoteValue;
        var minCRENoteID;
        this._lstChangedMaturityData = [];
        if (groupname.includes(":")) {
            var splittedgroupname = this.selectedGroupName.split(":");
            CRENoteID = splittedgroupname[0];
        }
        else {
            if (groupname == "") {
                CRENoteID = this.lstNote[0].CRENoteID;
            }
            else {
                minNoteValue = Math.min.apply(null, this.lstMaturityConfiguration.filter(function (x) { return x.MaturityGroupName == groupname; }).map(function (item) { return item.NoteSequenceNumber == undefined ? 9999 : item.NoteSequenceNumber; }));
                if (minNoteValue) {
                    minCRENoteID = this.lstMaturityConfiguration.find(function (x) { return x.NoteSequenceNumber == minNoteValue; }).CRENoteID;
                }
                CRENoteID = minCRENoteID;
            }
        }
        if (CRENoteID != '') {
            NoteID = this.lstNote.filter(function (x) { return x.CRENoteID == CRENoteID; })[0].NoteId;
            if (NoteID == undefined) {
                NoteID = '00000000-0000-0000-0000-000000000000';
            }
            this.selectedNoteID = NoteID;
        }
        var maturitymethodID;
        var maturitymethodname = this.lstMaturityConfiguration.filter(function (x) { return x.MaturityGroupName == groupname; });
        if (maturitymethodname.length > 0) {
            maturitymethodID = maturitymethodname[0].MaturityMethodID;
        }
        else {
            var notematuritymethodID = this.lstMaturityConfiguration.filter(function (x) { return x.MaturityMethodIDText == 'Note level'; });
            if (notematuritymethodID.length > 0) {
                maturitymethodID = notematuritymethodID[0].MaturityMethodID;
            }
            else {
                maturitymethodID = "723";
            }
        }
        for (var g = this.maturityList.length - 1; g >= 0; g--) {
            if (CRENoteID != '') {
                if (this.maturityList[g].NoteID == NoteID) {
                    if (this.maturityList[g].isDeleted != 1) {
                        this.maturityList.splice(g, 1);
                    }
                }
            }
        }
        var flexlength = 0;
        if (this.flexMaturity.allowAddNew == false) {
            flexlength = this.flexMaturity.rows.length;
        }
        else {
            flexlength = this.flexMaturity.rows.length - 1;
        }
        for (var h = 0; h < flexlength; h++) {
            if (Object.keys(this.flexMaturity.rows[h]).length > 0) {
                if ('MaturityTypeText' in this.flexMaturity.rows[h].dataItem || 'MaturityDate' in this.flexMaturity.rows[h].dataItem) {
                    if (!('NoteID' in this.flexMaturity.rows[h].dataItem)) {
                        this.flexMaturity.rows[h].dataItem.NoteID = NoteID;
                    }
                    if (!('CRENoteID' in this.flexMaturity.rows[h].dataItem)) {
                        this.flexMaturity.rows[h].dataItem.CRENoteID = CRENoteID;
                    }
                    if (!('DealID' in this.flexMaturity.rows[h].dataItem)) {
                        this.flexMaturity.rows[h].dataItem.DealID = this._deal.DealID;
                    }
                    if (!('isDeleted' in this.flexMaturity.rows[h].dataItem)) {
                        this.flexMaturity.rows[h].dataItem.isDeleted = 0;
                    }
                    if (!('MaturityType' in this.flexMaturity.rows[h].dataItem)) {
                        this.flexMaturity.rows[h].dataItem.MaturityType = '';
                    }
                    if (!('MaturityDate' in this.flexMaturity.rows[h].dataItem)) {
                        this.flexMaturity.rows[h].dataItem.MaturityDate = '';
                    }
                    if (!('EffectiveDate' in this.flexMaturity.rows[h].dataItem)) {
                        this.flexMaturity.rows[h].dataItem.EffectiveDate = this.maturityEffectiveDate;
                    }
                    if (!('IsValidateMaturityDate' in this.flexMaturity.rows[h].dataItem)) {
                        this.flexMaturity.rows[h].dataItem.IsValidateMaturityDate = true;
                    }
                    if (!('IsSaved' in this.flexMaturity.rows[h].dataItem)) {
                        if (this.flexMaturity.rows[h].dataItem.MaturityType.toString() == '709') {
                            this.flexMaturity.rows[h].dataItem.IsSaved = 'true';
                        }
                        else {
                            this.flexMaturity.rows[h].dataItem.IsSaved = 'false';
                        }
                    }
                    else {
                        if (this.flexMaturity.rows[h].dataItem.MaturityType != null) {
                            if (this.flexMaturity.rows[h].dataItem.MaturityType.toString() == '709') {
                                this.flexMaturity.rows[h].dataItem.IsSaved = 'true';
                            }
                        }
                    }
                    if (!('Rowno' in this.flexMaturity.rows[h].dataItem)) {
                        this.flexMaturity.rows[h].dataItem.Rowno = h;
                    }
                    this.maturityList.push(this.flexMaturity.rows[h].dataItem);
                }
            }
        }
        var dtMaturity = [], originalmatextList = [], _originalmatextlst = [];
        if (this.maturityList.length > 0) {
            for (var k = 0; k < this.maturityList.length; k++) {
                if (this.maturityList[k].NoteID == NoteID) {
                    if (this.maturityList[k].MaturityType || this.maturityList[k].MaturityDate) {
                        dtMaturity.push({
                            'DealID': this._deal.DealID,
                            'NoteID': this.maturityList[k].NoteID,
                            'EffectiveDate': this.maturityEffectiveDate == null ? null : this.convertDatetoGMT(this.maturityEffectiveDate),
                            'MaturityDate': this.convertDatetoGMT(this.maturityList[k].MaturityDate),
                            'MaturityType': this.maturityList[k].MaturityType,
                            'Approved': this.maturityList[k].Approved,
                            'IsDeleted': this.maturityList[k].isDeleted,
                            'ActualPayoffDate': this.maturityActualPayoffDate == null ? null : this.convertDatetoGMT(this.maturityActualPayoffDate),
                            'ExpectedMaturityDate': this.maturityExpectedMaturityDate == null ? null : this.convertDatetoGMT(this.maturityExpectedMaturityDate),
                            'OpenPrepaymentDate': this.maturityOpenPrepaymentDate == null ? null : this.convertDatetoGMT(this.maturityOpenPrepaymentDate),
                            'CRENoteID': this.maturityList[k].CRENoteID,
                            'MaturityMethodID': this.maturityList[k].MaturityMethodID == undefined ? maturitymethodID : this.maturityList[k].MaturityMethodID
                        });
                        this._lstChangedMaturityData.push({
                            'MaturityDate': this.convertDatetoGMT(this.maturityList[k].MaturityDate),
                            'MaturityType': this.maturityList[k].MaturityType,
                            'Approved': this.maturityList[k].Approved,
                            'IsDeleted': this.maturityList[k].isDeleted,
                            'GroupName': groupname,
                            'NoteID': this.maturityList[k].NoteID
                        });
                    }
                }
            }
        }
        if (dtMaturity.length == 0) {
            this.maturityOtherFieldsList = [];
            this.maturityOtherFieldsList.push({
                'DealID': this._deal.DealID,
                'NoteID': NoteID,
                'EffectiveDate': null,
                'MaturityDate': null,
                'MaturityType': null,
                'Approved': null,
                'IsDeleted': 0,
                'ActualPayoffDate': this.maturityActualPayoffDate == null ? null : this.convertDatetoGMT(this.maturityActualPayoffDate),
                'ExpectedMaturityDate': this.maturityExpectedMaturityDate == null ? null : this.convertDatetoGMT(this.maturityExpectedMaturityDate),
                'OpenPrepaymentDate': this.maturityOpenPrepaymentDate == null ? null : this.convertDatetoGMT(this.maturityOpenPrepaymentDate),
                'CRENoteID': CRENoteID,
                'MaturityMethodID': maturitymethodID
            });
        }
        if (this.noteMaturityList.length > 0) {
            // remove old rows of selected note id
            var j = 0;
            while (j < this.noteMaturityList.length) {
                if (this.noteMaturityList[j].NoteID == NoteID) {
                    this.noteMaturityList.splice(j, 1);
                    j = 0;
                }
                else {
                    j++;
                }
            }
            for (var n = 0; n < dtMaturity.length; n++) {
                this.noteMaturityList.push(dtMaturity[n]);
            }
        }
        else {
            this.noteMaturityList = dtMaturity;
        }
        notedata = this.lstNote.filter(function (x) { return x.CRENoteID == CRENoteID; });
        if (dtMaturity.length > 0) {
            _originalmatextlst = this.originalMaturityList.filter(function (x) { return x.NoteID == dtMaturity[0].NoteID && x.MaturityType != null && x.MaturityType.toString() == "709"; });
            if (_originalmatextlst.length > 0) {
                for (var m = 0; m < _originalmatextlst.length; m++) {
                    if (_originalmatextlst[m].Approved) {
                        if (_originalmatextlst[m].Approved.toString() == "3") {
                            originalmatextList.push(_originalmatextlst[m]);
                        }
                    }
                }
            }
        }
        // validations start
        var duplicatedmaterror = '';
        if (!(modename == 'Delete')) { //
            var initialmatList = [];
            var fullyextendedmatList = [];
            var extensionList = [];
            var YextensionList = [];
            var mattypefound = false;
            var effectivedateerr = '';
            var maturitytypeerr = '';
            var maturitydateerr = '';
            var minextmaturitydateerr = '';
            var _ismaturitydate = false;
            var minmaturitydate = '';
            var minextensiondate, minoriginalextensiondate;
            for (var l = 0; l < dtMaturity.length; l++) {
                if (dtMaturity[l].IsDeleted != 1) {
                    if (dtMaturity[l].MaturityType != null) {
                        if (dtMaturity[l].MaturityType.toString() == "708") {
                            initialmatList.push(dtMaturity[l]);
                        }
                        if (dtMaturity[l].MaturityType.toString() == "710") {
                            fullyextendedmatList.push(dtMaturity[l]);
                        }
                        if (dtMaturity[l].MaturityType.toString() == "709") {
                            extensionList.push(dtMaturity[l]);
                        }
                        if (dtMaturity[l].MaturityType.toString() == "709" && dtMaturity[l].Approved != undefined && dtMaturity[l].Approved.toString() == "3") {
                            YextensionList.push(dtMaturity[l]);
                        }
                        if (dtMaturity[l].EffectiveDate == null) {
                            if (!effectivedateerr.includes(notedata[0].Name)) {
                                effectivedateerr = effectivedateerr + notedata[0].Name + ', ';
                                _ismaturitydate = true;
                            }
                        }
                        if (dtMaturity[l].MaturityType == null || dtMaturity[l].MaturityType == "" || dtMaturity[l].MaturityType == undefined) {
                            if (!maturitytypeerr.includes(notedata[0].Name)) {
                                maturitytypeerr = maturitytypeerr + notedata[0].Name + ', ';
                            }
                        }
                        if (isNaN(dtMaturity[l].MaturityDate.getTime()) || dtMaturity[l].MaturityDate == null || dtMaturity[l].MaturityDate == "" || dtMaturity[l].MaturityDate == undefined) {
                            if (!maturitydateerr.includes(notedata[0].Name)) {
                                maturitydateerr = maturitydateerr + notedata[0].Name + ', ';
                            }
                        }
                        else if (new Date(dtMaturity[l].MaturityDate.getTime()).getTime() < new Date(notedata[0].ClosingDate).getTime()) {
                            if (dtMaturity[l].MaturityType.toString() == '708' || dtMaturity[l].MaturityType.toString() == '709' || dtMaturity[l].MaturityType.toString() == '710') {
                                var date = this.convertDateToBindable(dtMaturity[l].MaturityDate);
                                if (!minmaturitydate.includes(date)) {
                                    minmaturitydate = minmaturitydate + date + ', ';
                                }
                            }
                        }
                    }
                }
            }
            if (!(modename == 'Edit' || modename == 'Copy')) {
                if (this.maturityEffectiveDate != null) {
                    if (new Date(this.maturityEffectiveDate).getTime() < new Date(notedata[0].ClosingDate).getTime()) {
                        duplicatedmaterror = duplicatedmaterror + "<p>" + notedata[0].Name + ": Effective date can not be smaller than closing date - " + this.convertDateToBindable(this.maturityEffectiveDate) + "</p>";
                    }
                }
                if (this.maturityActualPayoffDate != null) {
                    if (new Date(this.maturityActualPayoffDate).getTime() < new Date(notedata[0].ClosingDate).getTime()) {
                        duplicatedmaterror = duplicatedmaterror + "<p>" + notedata[0].Name + ": Actual payoff date can not be smaller than closing date -" + this.convertDateToBindable(this.maturityActualPayoffDate) + "</p>";
                    }
                }
                if (this.maturityOpenPrepaymentDate != null) {
                    if (new Date(this.maturityOpenPrepaymentDate).getTime() < new Date(notedata[0].ClosingDate).getTime()) {
                        duplicatedmaterror = duplicatedmaterror + "<p>" + notedata[0].Name + ": Open prepayment date can not be smaller than closing date - " + this.convertDateToBindable(this.maturityOpenPrepaymentDate) + "</p>";
                    }
                }
                if (maturitytypeerr != '') {
                    duplicatedmaterror = duplicatedmaterror + "<p>" + maturitytypeerr.slice(0, -2) + ": Maturity type can not be blank." + "</p>";
                }
                if (maturitydateerr != '') {
                    duplicatedmaterror = duplicatedmaterror + "<p>" + maturitydateerr.slice(0, -2) + ": Maturity date can not be blank." + "</p>";
                }
                if (originalmatextList.length > 0) {
                    minoriginalextensiondate = originalmatextList[0].MaturityDate;
                    for (var v = 0; v < originalmatextList.length; v++) {
                        if (new Date(minoriginalextensiondate).getTime() < new Date(originalmatextList[v].MaturityDate).getTime()) {
                            minoriginalextensiondate = minoriginalextensiondate;
                        }
                        else {
                            minoriginalextensiondate = originalmatextList[v].MaturityDate;
                        }
                    }
                }
                if (YextensionList.length > 0) {
                    minextensiondate = YextensionList[0].MaturityDate;
                    for (var v = 0; v < YextensionList.length; v++) {
                        if (new Date(minextensiondate).getTime() < new Date(YextensionList[v].MaturityDate).getTime()) {
                            minextensiondate = minextensiondate;
                        }
                        else {
                            minextensiondate = YextensionList[v].MaturityDate;
                        }
                    }
                    if (minoriginalextensiondate && minextensiondate) {
                        if (new Date(minextensiondate).getTime() < new Date(minoriginalextensiondate).getTime()) {
                            var date = this.convertDateToBindable(minoriginalextensiondate);
                            duplicatedmaterror = duplicatedmaterror + "<p>" + notedata[0].Name + ": Approved Extended Maturity Date can not be less than the existing minimum Approved Extended Maturity Date - " + date + "</p>";
                        }
                    }
                }
            }
            if (minmaturitydate != '') {
                duplicatedmaterror = duplicatedmaterror + "<p>" + notedata[0].Name + ": Maturity date can not be smaller than closing date - " + minmaturitydate.slice(0, -2) + "</p>";
            }
            if (effectivedateerr != '') {
                duplicatedmaterror = duplicatedmaterror + "<p>" + effectivedateerr.slice(0, -2) + ": Effective date can not be blank." + "</p>";
            }
            if (dtMaturity.length == 0) {
                if (this.maturityEffectiveDate != null) {
                    duplicatedmaterror = duplicatedmaterror + "<p>" + "Please enter initial maturity date if Effective date is entered." + "</p>";
                }
            }
            if (initialmatList.length > 1) {
                mattypefound = true;
                duplicatedmaterror = duplicatedmaterror + "<p>" + notedata[0].Name + ": Initial maturity already exists." + "</p>";
            }
            if (fullyextendedmatList.length > 1) {
                mattypefound = true;
                duplicatedmaterror = duplicatedmaterror + "<p>" + notedata[0].Name + ": Fully extended maturity already exists." + "</p>";
            }
            var _isfounddate = '';
            if (extensionList.length > 0) {
                for (var l = 0; l < extensionList.length; l++) {
                    for (var m = l + 1; m < extensionList.length; m++) {
                        if (extensionList[l].NoteID == extensionList[m].NoteID) {
                            if (new Date(extensionList[l].MaturityDate).getTime() == new Date(extensionList[m].MaturityDate).getTime()) {
                                var date = this.convertDateToBindable(extensionList[l].MaturityDate);
                                if (!_isfounddate.includes(date)) {
                                    _isfounddate = _isfounddate + date + ', ';
                                }
                            }
                        }
                    }
                }
                if (_isfounddate != '') {
                    duplicatedmaterror = duplicatedmaterror + "<p>" + notedata[0].Name + ": Extended maturity with same date already exists -" + _isfounddate.slice(0, -2) + ". Please update or delete the record." + "</p>";
                }
                if (fullyextendedmatList.length > 0 || initialmatList.length > 0) {
                    for (var g = 0; g < extensionList.length; g++) {
                        if (fullyextendedmatList.length > 0) {
                            for (var f = 0; f < fullyextendedmatList.length; f++) {
                                if (new Date(fullyextendedmatList[f].MaturityDate).getTime() < new Date(extensionList[g].MaturityDate).getTime() || new Date(extensionList[g].MaturityDate).getTime() < new Date(notedata[0].ClosingDate).getTime()) {
                                    var date = this.convertDateToBindable(extensionList[g].MaturityDate);
                                    if (!minextmaturitydateerr.includes(date)) {
                                        minextmaturitydateerr = minextmaturitydateerr + date + ', ';
                                    }
                                }
                            }
                        }
                        if (initialmatList.length > 0) {
                            for (var h = 0; h < initialmatList.length; h++) {
                                if (new Date(initialmatList[h].MaturityDate).getTime() > new Date(extensionList[g].MaturityDate).getTime() || new Date(extensionList[g].MaturityDate).getTime() < new Date(notedata[0].ClosingDate).getTime()) {
                                    var date = this.convertDateToBindable(initialmatList[h].MaturityDate);
                                    if (!minextmaturitydateerr.includes(date)) {
                                        minextmaturitydateerr = minextmaturitydateerr + date + ', ';
                                    }
                                }
                            }
                        }
                    }
                }
                if (minextmaturitydateerr != '') {
                    duplicatedmaterror = duplicatedmaterror + "<p>" + notedata[0].Name + ": Extended date can not be smaller than closing date, initial maturity date and greater than Fully extended maturity date -" + minextmaturitydateerr.slice(0, -2) + "</p>";
                }
            }
            var fullyextdate = '';
            if (fullyextendedmatList.length > 0) {
                for (var k = 0; k < fullyextendedmatList.length; k++) {
                    if (initialmatList.length > 0) {
                        for (var l = 0; l < initialmatList.length; l++) {
                            if (initialmatList[l].MaturityDate > fullyextendedmatList[k].MaturityDate) {
                                var date = this.convertDateToBindable(fullyextendedmatList[k].MaturityDate);
                                if (!fullyextdate.includes(date)) {
                                    fullyextdate += fullyextdate + date + ', ';
                                }
                            }
                        }
                    }
                }
            }
            if (fullyextdate != '') {
                duplicatedmaterror = duplicatedmaterror + "<p>" + notedata[0].Name + ": Initial maturity date can not be greater than Fully extended date - " + fullyextdate.slice(0, -2) + "</p>";
            }
            if (mattypefound == true || _ismaturitydate == false) {
                if (modename == 'Edit') {
                    var initiallst = this.maturityList.filter(function (x) { return x.NoteID == NoteID; });
                    var fullyexttype = this.originalMaturityList.filter(function (x) { return x.NoteID == dtMaturity[0].NoteID && x.MaturityType != null && x.MaturityType.toString() == "710"; });
                    var initialtype = this.originalMaturityList.filter(function (x) { return x.NoteID == dtMaturity[0].NoteID && x.MaturityType != null && x.MaturityType.toString() == "708"; });
                    if (initiallst.length > 0) {
                        if (this.flexMaturity.rows[rownum].dataItem.IsSaved == 'true') {
                            if (this.flexMaturity.rows[rownum].dataItem.MaturityType != null) {
                                if (this.flexMaturity.rows[rownum].dataItem.MaturityType.toString() == '710' && fullyexttype.length > 0) {
                                    this.flexMaturity.rows[rownum].dataItem.MaturityTypeText = '';
                                    this.flexMaturity.rows[rownum].dataItem.MaturityType = '';
                                    this.flexMaturity.rows[rownum].dataItem.ApprovedText = '';
                                    this.flexMaturity.rows[rownum].dataItem.Approved = '';
                                }
                                if (this.flexMaturity.rows[rownum].dataItem.MaturityType.toString() == '708' && initialtype.length > 0) {
                                    this.flexMaturity.rows[rownum].dataItem.MaturityTypeText = '';
                                    this.flexMaturity.rows[rownum].dataItem.MaturityType = '';
                                    this.flexMaturity.rows[rownum].dataItem.ApprovedText = '';
                                    this.flexMaturity.rows[rownum].dataItem.Approved = '';
                                }
                            }
                        }
                        else if (this.flexMaturity.rows[rownum].dataItem.IsSaved == 'false') {
                            if (mattypefound == true) {
                                this.flexMaturity.rows[rownum].dataItem.MaturityTypeText = '';
                                this.flexMaturity.rows[rownum].dataItem.MaturityType = '';
                                this.flexMaturity.rows[rownum].dataItem.ApprovedText = '';
                                this.flexMaturity.rows[rownum].dataItem.Approved = '';
                            }
                            else if (!(this.previousMaturityType == '' || this.previousMaturityType == undefined)) {
                                if (this.previousMaturityType.toString() == '710' || this.previousMaturityType.toString() == '708') {
                                    this.flexMaturity.rows[rownum].dataItem.MaturityTypeText = this.maturityTypeList.filter(function (x) { return x.LookupID.toString() == _this.previousMaturityType.toString(); })[0].Name;
                                    this.flexMaturity.rows[rownum].dataItem.MaturityType = this.previousMaturityType;
                                }
                            }
                        }
                    }
                }
                if (modename == 'Copy') {
                    var notelstfilter = this.maturityList.filter(function (x) { return x.NoteID == NoteID; });
                    var initiallstType = notelstfilter.filter(function (x) { return x.MaturityType != null && x.MaturityType.toString() == '708'; });
                    if (initiallstType.length > 0) {
                        var mininitiallstRowno = initiallstType.reduce(function (min, p) { return p.Rowno < min ? p.Rowno : min; }, initiallstType[0].Rowno);
                        var maxinitiallstRowno = initiallstType.reduce(function (max, p) { return p.Rowno > max ? p.Rowno : max; }, initiallstType[0].Rowno);
                    }
                    var fullyextendedlstType = notelstfilter.filter(function (x) { return x.MaturityType != null && x.MaturityType.toString() == '710'; });
                    if (fullyextendedlstType.length > 0) {
                        var minfullyextendedlstRowno = fullyextendedlstType.reduce(function (min, p) { return p.Rowno < min ? p.Rowno : min; }, fullyextendedlstType[0].Rowno);
                        var maxfullyextendedlstRowno = fullyextendedlstType.reduce(function (max, p) { return p.Rowno > max ? p.Rowno : max; }, fullyextendedlstType[0].Rowno);
                    }
                    for (var m = 0; m < this.flexMaturity.rows.length - 1; m++) {
                        if (this.flexMaturity.rows[m].dataItem) {
                            if (this.flexMaturity.rows[m].dataItem.IsSaved == 'true') {
                                if (this.flexMaturity.rows[m].dataItem.MaturityType != null) {
                                    if (this.flexMaturity.rows[m].dataItem.MaturityType.toString() == "708") {
                                        if (!(maxinitiallstRowno == m || maxinitiallstRowno == mininitiallstRowno)) {
                                            this.flexMaturity.rows[m].dataItem.MaturityType = '';
                                            this.flexMaturity.rows[m].dataItem.MaturityTypeText = '';
                                            this.flexMaturity.rows[m].dataItem.ApprovedText = '';
                                            this.flexMaturity.rows[m].dataItem.Approved = '';
                                        }
                                    }
                                    if (this.flexMaturity.rows[m].dataItem.MaturityType.toString() == "710") {
                                        if (!(maxfullyextendedlstRowno == m && maxfullyextendedlstRowno == minfullyextendedlstRowno)) {
                                            this.flexMaturity.rows[m].dataItem.MaturityType = '';
                                            this.flexMaturity.rows[m].dataItem.MaturityTypeText = '';
                                            this.flexMaturity.rows[m].dataItem.ApprovedText = '';
                                            this.flexMaturity.rows[m].dataItem.Approved = '';
                                        }
                                    }
                                }
                            }
                            else if (this.flexMaturity.rows[m].dataItem.IsSaved == 'false') {
                                if (mattypefound == true) {
                                    if (initialmatList.length > 0) {
                                        if (this.flexMaturity.rows[m].dataItem.Rowno > mininitiallstRowno && m != maxfullyextendedlstRowno) {
                                            this.flexMaturity.rows[m].dataItem.MaturityType = '';
                                            this.flexMaturity.rows[m].dataItem.MaturityTypeText = '';
                                            this.flexMaturity.rows[m].dataItem.ApprovedText = '';
                                            this.flexMaturity.rows[m].dataItem.Approved = '';
                                        }
                                    }
                                    if (fullyextendedlstType.length > 0) {
                                        if (this.flexMaturity.rows[m].dataItem.Rowno > minfullyextendedlstRowno && m != maxfullyextendedlstRowno) {
                                            this.flexMaturity.rows[m].dataItem.MaturityType = '';
                                            this.flexMaturity.rows[m].dataItem.MaturityTypeText = '';
                                            this.flexMaturity.rows[m].dataItem.ApprovedText = '';
                                            this.flexMaturity.rows[m].dataItem.Approved = '';
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            var matdt = [];
            matdt = dtMaturity.filter(function (x) { return !(x.IsDeleted == 1); });
            for (var h = 0; h < matdt.length; h++) {
                var isholidayfound = this.holidayDateCheck(matdt[h].MaturityDate, h, 'grid');
                var formateddate = this.convertDateToBindable(matdt[h].MaturityDate);
            }
        }
        var lstgroupname = this.lstMaturityConfiguration.filter(function (x) { return x.MaturityGroupName == groupname; });
        var lstgroupseqno = lstgroupname.filter(function (x) { return x.NoteSequenceNumber == undefined ? 9999 : x.NoteSequenceNumber != minNoteValue; });
        var lstgroupnote = lstgroupseqno.map(function (item) { return item.CRENoteID; });
        lstgroupnote.forEach(function (e) {
            var j = 0;
            if (_this.noteMaturityList.length > 0) {
                while (j < _this.noteMaturityList.length) {
                    if (_this.noteMaturityList[j].CRENoteID == e) {
                        _this.noteMaturityList.splice(j, 1);
                        j = 0;
                    }
                    else {
                        j++;
                    }
                }
            }
            else if (_this.maturityOtherFieldsList.length > 0) {
                while (j < _this.maturityOtherFieldsList.length) {
                    if (_this.maturityOtherFieldsList[j].CRENoteID == e) {
                        _this.maturityOtherFieldsList.splice(j, 1);
                        j = 0;
                    }
                    else {
                        j++;
                    }
                }
            }
        });
        var lstMat = [];
        lstgroupnote.forEach(function (e) {
            var NoteID = '';
            var lstNoteID = _this.maturityList.filter(function (x) { return x.CRENoteID == e; });
            if (lstNoteID.length > 0) {
                NoteID = _this.maturityList.find(function (x) { return x.CRENoteID == e; }).NoteID;
            }
            else {
                var _lstNoteID = _this.lstNote.filter(function (x) { return x.CRENoteID == e; });
                if (_lstNoteID.length > 0) {
                    NoteID = _this.lstNote.find(function (x) { return x.CRENoteID == e; }).NoteId;
                }
                else {
                    NoteID = '00000000-0000-0000-0000-000000000000';
                }
            }
            var dtmat = [];
            if (dtMaturity.length > 0) {
                dtmat = dtMaturity;
            }
            else {
                dtmat = _this.maturityOtherFieldsList;
            }
            for (var k = 0; k < dtmat.length; k++) {
                lstMat.push({
                    'DealID': dtmat[k].DealID,
                    'NoteID': NoteID,
                    'EffectiveDate': dtmat[k].EffectiveDate,
                    'MaturityDate': dtmat[k].MaturityDate,
                    'MaturityType': dtmat[k].MaturityType,
                    'Approved': dtmat[k].Approved,
                    'IsDeleted': dtmat[k].IsDeleted,
                    'ActualPayoffDate': dtmat[k].ActualPayoffDate,
                    'ExpectedMaturityDate': dtmat[k].ExpectedMaturityDate,
                    'OpenPrepaymentDate': dtmat[k].OpenPrepaymentDate,
                    'CRENoteID': e,
                    'MaturityMethodID': dtmat[k].MaturityMethodID,
                });
            }
        });
        if (lstMat.length > 0) {
            for (var g = 0; g < lstMat.length; g++) {
                if (this.noteMaturityList.length > 0) {
                    this.noteMaturityList.push(lstMat[g]);
                }
                else {
                    this.maturityOtherFieldsList.push(lstMat[g]);
                }
            }
        }
        this._isMaturityError = '';
        this._isMaturityError = duplicatedmaterror;
        if (duplicatedmaterror != "") {
            this.CustomAlert(duplicatedmaterror);
        }
    };
    DealDetailComponent.prototype.holidayDateCheck = function (date, rownum, mode) {
        var _this = this;
        var _iserrfound = false;
        var maturitydateday;
        if (date != null) {
            var formateddate = this.convertDateToBindable(date);
            if (mode == 'grid') {
                maturitydateday = date.getDay();
                if (this.flexMaturity.rows[rownum]) {
                    if (this.flexMaturity.rows[rownum].dataItem) {
                        if (maturitydateday == 6 || maturitydateday == 0 || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411; }).length > 0) {
                            this.flexMaturity.rows[rownum].dataItem.IsValidateMaturityDate = false;
                            this._isvalidateMaturityHoliday = false;
                        }
                        else {
                            this.flexMaturity.rows[rownum].dataItem.IsValidateMaturityDate = true;
                            this._isvalidateMaturityHoliday = true;
                        }
                    }
                }
                else {
                    maturitydateday = new Date(date).getDay();
                    if (maturitydateday == 6 || maturitydateday == 0 || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411; }).length > 0) {
                        this._isvalidateMaturityHoliday = false;
                    }
                    else {
                        this._isvalidateMaturityHoliday = true;
                    }
                }
            }
            else {
                maturitydateday = new Date(date).getDay();
                if (maturitydateday == 6 || maturitydateday == 0 || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411; }).length > 0) {
                    this._isvalidateMaturityHoliday = false;
                }
                else {
                    this._isvalidateMaturityHoliday = true;
                }
            }
            if (!this._isvalidateMaturityHoliday) {
                _iserrfound = true;
            }
        }
        return _iserrfound;
    };
    DealDetailComponent.prototype.ClosePopUp = function () {
        var modal = document.getElementById('myModal');
        modal.style.display = "none";
    };
    DealDetailComponent.prototype.ConvertToBindableAnyListDate = function (Data, tabname) {
        if (tabname == 'Maturity') {
            for (var i = 0; i < Data.length; i++) {
                if (this.maturityList[i].ActualPayoffDate != null) {
                    this.maturityList[i].ActualPayoffDate = new Date(this.convertDateToBindable(this.maturityList[i].ActualPayoffDate));
                }
                if (this.maturityList[i].EffectiveDate != null) {
                    this.maturityList[i].EffectiveDate = new Date(this.convertDateToBindable(this.maturityList[i].EffectiveDate));
                }
                if (this.maturityList[i].ExpectedMaturityDate != null) {
                    this.maturityList[i].ExpectedMaturityDate = new Date(this.convertDateToBindable(this.maturityList[i].ExpectedMaturityDate));
                }
                if (this.maturityList[i].MaturityDate != null) {
                    this.maturityList[i].MaturityDate = new Date(this.convertDateToBindable(this.maturityList[i].MaturityDate));
                }
                if (this.maturityList[i].OpenPrepaymentDate != null) {
                    this.maturityList[i].OpenPrepaymentDate = new Date(this.convertDateToBindable(this.maturityList[i].OpenPrepaymentDate));
                }
            }
        }
    };
    DealDetailComponent.prototype.OnchangeExpectedMaturityDate = function (val) {
        var checkedactualpayoff = val;
        if (checkedactualpayoff == "") {
            this.maturityExpectedMaturityDate = null;
        }
        else {
            var date = new Date(checkedactualpayoff);
            if (date.toString() != 'Invalid Date') {
                this.maturityExpectedMaturityDate = checkedactualpayoff;
            }
            else {
                this.maturityExpectedMaturityDate = this.maturityExpectedMaturityDate;
            }
        }
        this.onChangeMaturityDates();
    };
    DealDetailComponent.prototype.OnchangeActualPayoffDate = function (val) {
        this.isMaturityDataChanged = true;
        var checkedactualpayoff = val;
        if (checkedactualpayoff == "") {
            this.maturityActualPayoffDate = null;
        }
        else {
            var date = new Date(checkedactualpayoff);
            if (date.toString() != 'Invalid Date') {
                this.maturityActualPayoffDate = checkedactualpayoff;
            }
            else {
                this.maturityActualPayoffDate = this.maturityActualPayoffDate;
            }
        }
        this.onChangeMaturityDates();
    };
    DealDetailComponent.prototype.OnchangeopenPrepaymentDate = function (val) {
        this.isMaturityDataChanged = true;
        var checkedactualpayoff = val;
        if (checkedactualpayoff == "") {
            this.maturityOpenPrepaymentDate = null;
        }
        else {
            var date = new Date(checkedactualpayoff);
            if (date.toString() != 'Invalid Date') {
                this.maturityOpenPrepaymentDate = checkedactualpayoff;
            }
            else {
                this.maturityOpenPrepaymentDate = this.maturityOpenPrepaymentDate;
            }
        }
        this.onChangeMaturityDates();
    };
    DealDetailComponent.prototype.openEffectiveDatepopup = function (val) {
        if (this.OldmaturityEffectiveDate !== undefined && this.OldmaturityEffectiveDate !== null) {
            this.isMaturityDataChanged = true;
            this._previousMaturityEffectivedate = this.maturityEffectiveDate;
            var month = new Date(this.OldmaturityEffectiveDate).getMonth() + 1;
            var maturitydate = month + '/' + new Date(this.OldmaturityEffectiveDate).getDate() + '/' + new Date(this.OldmaturityEffectiveDate).getFullYear();
            if (new Date(val) < new Date(maturitydate)) {
                var modalDelete = document.getElementById('maturityEffectiveDateDialogbox');
                modalDelete.style.display = "block";
                $.getScript("/js/jsDrag.js");
            }
            else {
                this.OnchangematurityEffectiveDate(val);
            }
        }
    };
    DealDetailComponent.prototype.OnchangematurityEffectiveDate = function (val) {
        this.isMaturityDataChanged = true;
        var checkedactualpayoff = val; //
        this.ClosePopUpMaturityEffectiveDate();
        if (checkedactualpayoff == "") {
            this.maturityEffectiveDate = null;
        }
        else {
            var date = new Date(checkedactualpayoff);
            if (date.toString() != 'Invalid Date') {
                this.maturityEffectiveDate = checkedactualpayoff;
            }
            else {
                this.maturityEffectiveDate = this.maturityEffectiveDate;
            }
        }
        this.onChangeMaturityDates();
        this.checkMaturityMaxEffectiveDate();
    };
    DealDetailComponent.prototype.ClosePopUpMaturityEffectiveDate = function () {
        var modal = document.getElementById('maturityEffectiveDateDialogbox');
        modal.style.display = "none";
        this._previousMaturityEffectivedate = this.convertDateToBindable(this._previousMaturityEffectivedate);
        this.maturityEffectiveDate = this._previousMaturityEffectivedate;
    };
    DealDetailComponent.prototype.onChangeMaturityDates = function () {
        var _this = this;
        this.isMaturityDataChanged = true;
        var groupname = this.selectedGroupName;
        var CRENoteID = '';
        var minNoteValue, minCRENoteID;
        if (groupname.includes(":")) {
            var splittedgroupname = this.selectedGroupName.split(":");
            CRENoteID = splittedgroupname[0];
        }
        else {
            if (groupname == "") {
                CRENoteID = this.lstNote[0].CRENoteID;
            }
            else {
                minNoteValue = Math.min.apply(null, this.lstMaturityConfiguration.filter(function (x) { return x.MaturityGroupName == groupname; }).map(function (item) { return item.NoteSequenceNumber == undefined ? 9999 : item.NoteSequenceNumber; }));
                if (minNoteValue) {
                    minCRENoteID = this.lstMaturityConfiguration.find(function (x) { return x.NoteSequenceNumber == minNoteValue; }).CRENoteID;
                }
                CRENoteID = minCRENoteID;
            }
        }
        if (CRENoteID != '') {
            this.selectedNoteID = this.lstNote.filter(function (x) { return x.CRENoteID == CRENoteID; })[0].NoteId;
            if (this.selectedNoteID == undefined) {
                this.selectedNoteID = '00000000-0000-0000-0000-000000000000';
            }
            else {
                this.selectedNoteID == this.selectedNoteID;
            }
        }
        var checknoteid = this.maturityList.filter(function (x) { return x.NoteID == _this.selectedNoteID; });
        if (checknoteid.length > 0) {
            for (var l = 0; l < this.maturityList.length; l++) {
                if (this.maturityList[l].CRENoteID == CRENoteID) {
                    this.maturityList[l].ActualPayoffDate = this.maturityActualPayoffDate;
                    this.maturityList[l].OpenPrepaymentDate = this.maturityOpenPrepaymentDate;
                    this.maturityList[l].EffectiveDate = this.maturityEffectiveDate;
                    this.maturityList[l].ExpectedMaturityDate = this.maturityExpectedMaturityDate;
                }
            }
        }
        else {
            var len = this.maturityList.length;
            var dtmat = [];
            dtmat.push({
                'DealID': this._deal.DealID,
                'NoteID': this.selectedNoteID,
                'EffectiveDate': this.maturityEffectiveDate == null ? null : this.convertDatetoGMT(this.maturityEffectiveDate),
                'MaturityDate': '',
                'MaturityType': '',
                'Approved': '',
                'isDeleted': 0,
                'ActualPayoffDate': this.maturityActualPayoffDate == null ? null : this.convertDatetoGMT(this.maturityActualPayoffDate),
                'ExpectedMaturityDate': this.maturityExpectedMaturityDate == null ? null : this.convertDatetoGMT(this.maturityExpectedMaturityDate),
                'OpenPrepaymentDate': this.maturityOpenPrepaymentDate == null ? null : this.convertDatetoGMT(this.maturityOpenPrepaymentDate),
                'CRENoteID': CRENoteID,
                'MaturityMethodID': ''
            });
            this.maturityList[len] = dtmat[0];
        }
        this.createMaturityList('Change', null, this.selectedGroupName);
        this.invalidateMaturitygridData(this.maturityList, this.selectedGroupName);
    };
    DealDetailComponent.prototype.cellEditbeginMaturity = function (s, e) {
        this.isMaturityDataChanged = true;
        var maturityTypeindex = s.getColumn("MaturityTypeText").index;
        var approvedindex = s.getColumn("ApprovedText").index;
        var maturitydateindex = s.getColumn("MaturityDate").index;
        var user = JSON.parse(localStorage.getItem('user'));
        if (user.RoleName == "Asset Manager") {
            if (e.col == maturitydateindex || e.col == maturityTypeindex) {
                var item = s.getCellData(e.row, maturityTypeindex);
                if (item == 'Initial' || item == 'Fully extended') {
                    e.cancel = true;
                }
                else {
                    e.cancel = false;
                }
            }
            else {
                e.cancel = false;
            }
        }
    };
    DealDetailComponent.prototype.invalidateReserveTab = function () {
        if (!this._isReserveTabClicked) {
            localStorage.setItem('ClickedTabId', 'aReservetab');
            this._isReserveTabClicked = true;
            this.getAllReserveAccounts();
        }
        //this._isListFetching = true;
        //if (this._isReserveTabClicked == false) {
        //    this.getAllReserveAccounts();
        //}
        //else {
        //    setTimeout(() => {
        //        this.flexReserveAccounts.invalidate();
        //        if (this.showReserveScheduleGrid == true) {
        //            this.flexReserveSchedule.invalidate();
        //        }
        //    }, 200)
        //}
        //setTimeout(() => {
        //    this._isListFetching = false;
        //}, 1000);
    };
    DealDetailComponent.prototype.getAllReserveAccounts = function () {
        var _this = this;
        //this._isReserveTabClicked = true;
        this._isListFetching = true;
        this.dealSrv.getAllReserveAccounts(this._deal.DealID).subscribe(function (res) {
            if (res.Succeeded) {
                var datadt = res.dt;
                if (datadt.length > 0) {
                    _this.showReserveScheduleGrid = true;
                    _this.getAllReserveSchedule();
                }
                for (var j = 0; j < datadt.length; j++) {
                    if (datadt[j].InitialBalanceDate != null) {
                        datadt[j].InitialBalanceDate = new Date(_this.convertDateToReserveBindable(datadt[j].InitialBalanceDate));
                    }
                    if (datadt[j].EstimatedReserveBalance == 0 || datadt[j].EstimatedReserveBalance == null) {
                        datadt[j].EstimatedReserveBalance = datadt[j].InitialFundingAmount;
                    }
                }
                _this.reserveAccountsList = datadt;
                if (_this.reserveAccountsList.length > 0) {
                    for (var i = 0; i < _this.reserveAccountsList.length; i++) {
                        if (!('InitialFundingAmount_Org' in _this.reserveAccountsList[i])) {
                            _this.reserveAccountsList[i].InitialFundingAmount_Org = _this.reserveAccountsList[i].InitialFundingAmount;
                        }
                    }
                }
                _this._listReserveAccounts = new wjcCore.CollectionView(_this.reserveAccountsList);
                _this._listReserveAccounts.trackChanges = true;
                //this.flexReserveAccounts.invalidate();
                _this._user = JSON.parse(localStorage.getItem('user'));
                if (_this._user.RoleName == "Asset Manager") {
                    _this.showREODealCheckbox = true;
                }
                else {
                    _this.showREODealCheckbox = false;
                }
                if (_this.flexReserveAccounts) {
                    var floatcol = _this.flexReserveAccounts.getColumn('FloatInterestRate').index;
                    _this.flexReserveAccounts.itemFormatter = function (panel, r, c, cell) {
                        if (panel.cellType != wjcGrid.CellType.Cell) {
                            return;
                        }
                        if (panel.rows[r].dataItem) {
                            if (panel.columns[c].index == floatcol) {
                                var colval = panel.getCellData(r, floatcol);
                                if (colval) {
                                    var indexval = colval.toString().indexOf('e');
                                    if (indexval > -1) {
                                        panel.setCellData(r, floatcol, 0);
                                    }
                                }
                            }
                        }
                    };
                }
                setTimeout(function () {
                    this.flexReserveAccounts.invalidate(true);
                    this._isListFetching = false;
                }.bind(_this), 2000);
            }
        });
    };
    DealDetailComponent.prototype.getAllReserveSchedule = function () {
        var _this = this;
        this.dealSrv.getAllReserveSchedule(this._deal.DealID).subscribe(function (res) {
            if (res.Succeeded) {
                var datadt = res.dt;
                _this.showReserveScheduleGrid = true;
                for (var j = 0; j < datadt.length; j++) {
                    if (datadt[j].Date != null) {
                        datadt[j].Date = new Date(_this.convertDateToReserveBindable(datadt[j].Date));
                    }
                }
                var header = [];
                $.each(datadt, function (obj) {
                    var i = 0;
                    $.each(datadt[obj], function (key, value) {
                        header[i] = key;
                        i = i + 1;
                    });
                    return false;
                });
                _this._listReserveSchedule = new wjcCore.CollectionView(datadt);
                _this._listReserveSchedule.trackChanges = true;
                _this.reserveScheduleList = datadt;
                _this.columnsforReserveSchedule = [];
                for (var k = 0; k < header.length; k++) {
                    for (var m = 0; m < _this.reserveAccountsList.length; m++) {
                        if (_this.reserveAccountsList[m].ReserveAccountName == header[k]) {
                            _this.AddcolumnReserveSchedule(header[k], header[k]);
                            _this.reserveScheduleDynamicCol.push(_this.reserveAccountsList[m].ReserveAccountName);
                            if (datadt[0][header[k]] == null) {
                                datadt[0][header[k]] = 0;
                            }
                        }
                    }
                }
                _this._user = JSON.parse(localStorage.getItem('user'));
                if (_this._user.RoleName != "Asset Manager") {
                    for (var r = 0; r < _this.reserveScheduleList.length; r++) {
                        var objreserveschedule = _this.reserveScheduleList.filter(function (x) { return x.DealReserveScheduleID == _this.reserveScheduleList[r].DealReserveScheduleID; });
                        if (objreserveschedule.length > 0) {
                            if (objreserveschedule[0].WF_CurrentStatus != "Projected" && objreserveschedule[0].WF_CurrentStatus != '' && objreserveschedule[0].WF_CurrentStatus != null) {
                                _this.showREODealCheckbox = true;
                                break;
                            }
                            else {
                                _this.showREODealCheckbox = false;
                            }
                        }
                    }
                }
                else {
                    _this.showREODealCheckbox = true;
                }
                setTimeout(function () {
                    _this.flexReserveSchedule.invalidate();
                    var colMaturityType = _this.flexReserveSchedule.columns.getColumn('PurposeTypeText');
                    if (colMaturityType) {
                        colMaturityType.showDropDown = true;
                        colMaturityType.dataMap = _this._buildDataMap(_this.lstReserveSchedulePurposeType);
                    }
                    _this.reserveAppliedReadOnly();
                }, 200);
                for (var h = 0; h < datadt.length; h++) {
                    _this.originalReserveSchedulelst.push({
                        'Date': datadt[h].Date,
                        'ReserveAmount': datadt[h].ReserveAmount,
                        'PurposeID': datadt[h].PurposeID,
                        'PurposeTypeText': datadt[h].PurposeTypeText,
                        'Comment': datadt[h].Comment,
                        'DealReserveScheduleGUID': datadt[h].DealReserveScheduleGUID,
                        'DealReserveScheduleID': datadt[h].DealReserveScheduleID
                    });
                }
            }
        });
    };
    DealDetailComponent.prototype.cellReserveAccountsEdit = function (reserveaccflex, e) {
        var _this = this;
        if ('InitialFundingAmount' in this.flexReserveAccounts.rows[e.row].dataItem) {
            if (!('EstimatedReserveBalance' in this.flexReserveAccounts.rows[e.row].dataItem)) {
                this.flexReserveAccounts.rows[e.row].dataItem.EstimatedReserveBalance = this.flexReserveAccounts.rows[e.row].dataItem.InitialFundingAmount;
            }
            else if (this.flexReserveAccounts.rows[e.row].dataItem.EstimatedReserveBalance > 0) {
                if (!('InitialFundingAmount_Org' in this.flexReserveAccounts.rows[e.row].dataItem)) {
                    this.flexReserveAccounts.rows[e.row].dataItem.InitialFundingAmount_Org = this.flexReserveAccounts.rows[e.row].dataItem.InitialFundingAmount;
                    this.flexReserveAccounts.rows[e.row].dataItem.EstimatedReserveBalance = this.flexReserveAccounts.rows[e.row].dataItem.InitialFundingAmount;
                }
                else {
                    this.flexReserveAccounts.rows[e.row].dataItem.EstimatedReserveBalance = this.flexReserveAccounts.rows[e.row].dataItem.EstimatedReserveBalance + this.flexReserveAccounts.rows[e.row].dataItem.InitialFundingAmount - this.flexReserveAccounts.rows[e.row].dataItem.InitialFundingAmount_Org;
                    this.flexReserveAccounts.rows[e.row].dataItem.InitialFundingAmount_Org = this.flexReserveAccounts.rows[e.row].dataItem.InitialFundingAmount;
                }
            }
            else {
                this.flexReserveAccounts.rows[e.row].dataItem.EstimatedReserveBalance = this.flexReserveAccounts.rows[e.row].dataItem.InitialFundingAmount;
            }
        }
        else {
            if (!('InitialFundingAmount' in this.flexReserveAccounts.rows[e.row].dataItem)) {
                this.flexReserveAccounts.rows[e.row].dataItem.InitialFundingAmount = 0;
            }
            if (!('EstimatedReserveBalance' in this.flexReserveAccounts.rows[e.row].dataItem)) {
                this.flexReserveAccounts.rows[e.row].dataItem.EstimatedReserveBalance = 0;
            }
        }
        //if(this.reserveAccountsList[e.row].Date) {
        //    this.onChangereserveamount(e.row,e.col,'Edit');
        //}
        this.reserveAccountsList[e.row] = this.flexReserveAccounts.rows[e.row].dataItem;
        if (this.reserveAccountsList[e.row].InitialBalanceDate) {
            var accsDate = this.reserveAccountsList[e.row].InitialBalanceDate;
            var formateddate = this.convertDateToReserveBindable(accsDate);
            var accAccountdateday = accsDate.getDay();
            if (accAccountdateday == 6 || accAccountdateday == 0 || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411; }).length > 0) {
                this.flexReserveAccounts.rows[e.row].dataItem.IsValidateHoliday = 'false';
            }
            else {
                this.flexReserveAccounts.rows[e.row].dataItem.IsValidateHoliday = 'true';
            }
        }
        this.flexReserveAccounts.invalidate();
    };
    DealDetailComponent.prototype.copiedReserveAccounts = function (reserveaccflex, e) {
        var _this = this;
        for (var j = 0; j < this.reserveAccountsList.length; j++) {
            if (this.reserveAccountsList[j].InitialBalanceDate) {
                var accsDate = this.reserveAccountsList[j].InitialBalanceDate;
                var formateddate = this.convertDateToReserveBindable(accsDate);
                var accAccountdateday = accsDate.getDay();
                if (accAccountdateday == 6 || accAccountdateday == 0 || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411; }).length > 0) {
                    this.flexReserveAccounts.rows[j].dataItem.IsValidateHoliday = 'false';
                }
                else {
                    this.flexReserveAccounts.rows[j].dataItem.IsValidateHoliday = 'true';
                }
            }
            if (this.currentEstimatedBalanceColPasted == false) {
                if ('InitialFundingAmount' in this.flexReserveAccounts.rows[j].dataItem) {
                    if (this.flexReserveAccounts.rows[j].dataItem.EstimatedReserveBalance > 0) {
                        if (!('InitialFundingAmount_Org' in this.flexReserveAccounts.rows[j].dataItem)) {
                            this.flexReserveAccounts.rows[j].dataItem.InitialFundingAmount_Org = this.flexReserveAccounts.rows[j].dataItem.InitialFundingAmount;
                            this.flexReserveAccounts.rows[j].dataItem.EstimatedReserveBalance = this.flexReserveAccounts.rows[j].dataItem.InitialFundingAmount;
                        }
                        else {
                            this.flexReserveAccounts.rows[j].dataItem.EstimatedReserveBalance = this.flexReserveAccounts.rows[j].dataItem.EstimatedReserveBalance + this.flexReserveAccounts.rows[j].dataItem.InitialFundingAmount - this.flexReserveAccounts.rows[j].dataItem.InitialFundingAmount_Org;
                            this.flexReserveAccounts.rows[j].dataItem.InitialFundingAmount_Org = this.flexReserveAccounts.rows[j].dataItem.InitialFundingAmount;
                        }
                    }
                    else {
                        this.flexReserveAccounts.rows[j].dataItem.EstimatedReserveBalance = this.flexReserveAccounts.rows[j].dataItem.InitialFundingAmount;
                    }
                }
                else {
                    if (!('InitialFundingAmount' in this.flexReserveAccounts.rows[j].dataItem)) {
                        this.flexReserveAccounts.rows[j].dataItem.InitialFundingAmount = 0;
                    }
                    if (!('EstimatedReserveBalance' in this.flexReserveAccounts.rows[j].dataItem)) {
                        this.flexReserveAccounts.rows[j].dataItem.EstimatedReserveBalance = 0;
                    }
                }
            }
        }
        this.flexReserveAccounts.invalidate();
    };
    DealDetailComponent.prototype.cellReserveBeginEdit = function (scheduleflex, e) {
        this.reservepreviousDate = scheduleflex.rows[e.row].dataItem.Date;
        var datecol = this.flexReserveSchedule.getColumn("Date").index;
        if (this.flexReserveSchedule.rows[e.row].dataItem.Applied == true) {
            e.cancel = true;
        }
        else if (this.flexReserveSchedule.rows[e.row].dataItem.WF_IsCompleted == 1 && this.flexReserveSchedule.rows[e.row].dataItem.Applied == false) {
            if (e.col == datecol) {
                e.cancel = false;
            }
            else {
                e.cancel = true;
            }
        }
        else {
            e.cancel = false;
        }
    };
    DealDetailComponent.prototype.cellReserveScheduleEdit = function (scheduleflex, e) {
        var _this = this;
        var statuscol = this.flexReserveSchedule.getColumn("WF_CurrentStatusDisplayName").index;
        var datecol = this.flexReserveSchedule.getColumn("Date").index;
        var purposecol = scheduleflex.getColumn("PurposeTypeText").index;
        var reservescheduledynamiccol = this.flexReserveSchedule.getColumn(this.reserveAccountsList[0].ReserveAccountName).index;
        if (e.col == purposecol) {
            if (!(Number(scheduleflex.rows[e.row].dataItem.PurposeTypeText).toString() == "NaN" || Number(scheduleflex.rows[e.row].dataItem.PurposeTypeText) == 0)) {
                scheduleflex.rows[e.row].dataItem.PurposeID = scheduleflex.rows[e.row].dataItem.PurposeTypeText;
                scheduleflex.rows[e.row].dataItem.PurposeTypeText = this.lstReserveSchedulePurposeType.filter(function (x) { return x.LookupID.toString() == scheduleflex.rows[e.row].dataItem.PurposeTypeText; })[0].Name;
            }
        }
        if (e.col == purposecol || e.col >= reservescheduledynamiccol) {
            for (var l = reservescheduledynamiccol; l < this.flexReserveSchedule.columns.length; l++) {
                var cellvalue = scheduleflex.getCellData(e.row, l, false);
                if (scheduleflex.rows[e.row].dataItem.PurposeTypeText == 'Reserve Release') {
                    if (cellvalue > 0) {
                        scheduleflex.setCellData(e.row, l, -1 * cellvalue);
                    }
                }
                else {
                    if (cellvalue < 0) {
                        scheduleflex.setCellData(e.row, l, -1 * cellvalue);
                    }
                }
            }
        }
        if (this._listReserveSchedule.currentAddItem) {
            if (!('_IsRowChanged' in this._listReserveSchedule.currentAddItem)) {
                this._listReserveSchedule.currentAddItem._IsRowChanged = true;
            }
            if (!('isDeleted' in this._listReserveSchedule.currentAddItem)) {
                this._listReserveSchedule.currentAddItem.isDeleted = 0;
            }
            if (!('Comment' in this._listReserveSchedule.currentAddItem)) {
                this._listReserveSchedule.currentAddItem.Comment = null;
            }
            this.reserveScheduleList[e.row] = this._listReserveSchedule.currentAddItem;
        }
        if (this._listReserveSchedule.currentEditItem) {
            if (!('_IsRowChanged' in this._listReserveSchedule.currentEditItem)) {
                this._listReserveSchedule.currentEditItem._IsRowChanged = true;
            }
            if (!('isDeleted' in this._listReserveSchedule.currentEditItem)) {
                this._listReserveSchedule.currentEditItem.isDeleted = 0;
            }
            if (!('Comment' in this._listReserveSchedule.currentEditItem)) {
                this._listReserveSchedule.currentEditItem.Comment = null;
            }
            this.reserveScheduleList[e.row] = this._listReserveSchedule.currentEditItem;
        }
        this.onChangereserveamount(e.row, e.row, e.col, 'EditSchedule');
        if (e.col.toString() == datecol.toString()) {
            var maxappliedDate = new Date(Math.max.apply(null, this.reserveScheduleList.filter(function (x) { return x.Applied == true; }).map(function (x) { return x.Date; })));
            if (this.reserveScheduleList[e.row].Date < maxappliedDate) {
                if (this.reserveScheduleList[e.row].Date == undefined) {
                    this.reserveScheduleList[e.row].Date = "";
                }
                else {
                    //this.reserveScheduleList[e.row].Date = new Date(this.convertDateToBindable(this.reservepreviousDate));
                    this.reserveScheduleList[e.row].Date = new Date(this.convertDateToBindable(this.reserveScheduleList[e.row].Date));
                }
                this.CustomAlert("Date cannot be less than last wire confirmed date " + this.convertDateToBindable(maxappliedDate));
            }
            else {
                if (this.reserveScheduleList[e.row].Date) {
                    var accsDate = this.reserveScheduleList[e.row].Date;
                    var formateddate = this.convertDateToReserveBindable(accsDate);
                    var accScheduledateday = accsDate.getDay();
                    if (accScheduledateday == 6 || accScheduledateday == 0 || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411; }).length > 0) {
                        this.flexReserveSchedule.rows[e.row].dataItem.IsValidateHoliday = 'false';
                    }
                    else {
                        this.flexReserveSchedule.rows[e.row].dataItem.IsValidateHoliday = 'true';
                    }
                }
            }
        }
    };
    DealDetailComponent.prototype.copiedReserveSchedule = function (scheduleflex, e) {
        var _this = this;
        var statuscol = this.flexReserveSchedule.getColumn("WF_CurrentStatusDisplayName").index;
        var datecol = this.flexReserveSchedule.getColumn("Date").index;
        var row = scheduleflex.selection.bottomRow;
        var toprow = scheduleflex.selection.topRow;
        for (var m = toprow; m <= row; m++) {
            if (!('_IsRowChanged' in scheduleflex.rows[m].dataItem)) {
                scheduleflex.rows[m].dataItem._IsRowChanged = true;
            }
            if (!('isDeleted' in scheduleflex.rows[m].dataItem)) {
                scheduleflex.rows[m].dataItem.isDeleted = 0;
            }
            if (!('Comment' in scheduleflex.rows[m].dataItem)) {
                scheduleflex.rows[m].dataItem.Comment = null;
            }
            if (!(Number(scheduleflex.rows[m].dataItem.PurposeTypeText).toString() == "NaN" || Number(scheduleflex.rows[m].dataItem.PurposeTypeText) == 0)) {
                scheduleflex.rows[m].dataItem.PurposeID = scheduleflex.rows[m].dataItem.PurposeTypeText;
                scheduleflex.rows[m].dataItem.PurposeTypeText = this.lstReserveSchedulePurposeType.filter(function (x) { return x.LookupID.toString() == scheduleflex.rows[m].dataItem.PurposeTypeText; })[0].Name;
            }
            scheduleflex.rows[m].dataItem.Applied = false;
            if (scheduleflex.rows[m].dataItem.PurposeTypeText == 'Reserve Release') {
                for (var l = 0; l < this.reserveAccountsList.length; l++) {
                    var colindex = scheduleflex.getColumn(this.reserveAccountsList[l].ReserveAccountName).index;
                    var cellvalue = scheduleflex.getCellData(m, colindex, false);
                    if (cellvalue > 0) {
                        scheduleflex.setCellData(m, colindex, -1 * cellvalue);
                    }
                }
            }
            this.reserveScheduleList[m] = scheduleflex.rows[m].dataItem;
            if (scheduleflex.rows[m].dataItem.Date) {
                var accsDate = new Date(scheduleflex.rows[m].dataItem.Date);
                var formateddate = this.convertDateToReserveBindable(accsDate);
                var accScheduledateday = accsDate.getDay();
                if (accScheduledateday == 6 || accScheduledateday == 0 || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411; }).length > 0) {
                    this.flexReserveSchedule.rows[m].dataItem.IsValidateHoliday = 'false';
                }
                else {
                    this.flexReserveSchedule.rows[m].dataItem.IsValidateHoliday = 'true';
                }
            }
        }
        this.reserveAppliedReadOnly();
        this.onChangereserveamount(toprow, row, null, 'CopySchedule');
    };
    DealDetailComponent.prototype.onChangereserveamount = function (startrowno, endrowno, colnum, mode) {
        var _isestimatedbalzero = false;
        var _isInitialFundingsmaller = false;
        var accnamewiseamount = 0;
        var sumwireConfirmAndNegAMt = 0;
        var accnamecoltotal = 0;
        var estimatedreservebal = 0;
        var accountname = '';
        var scheduleKeys = Object.keys(this.flexReserveSchedule.rows[startrowno].dataItem);
        var schedulevalues = Object.values(this.flexReserveSchedule.rows[startrowno].dataItem);
        var rowarr = [];
        rowarr.push(startrowno);
        if (endrowno > startrowno) {
            var temp = startrowno;
            while (temp != endrowno) {
                rowarr.push(startrowno + 1);
                temp++;
            }
        }
        //if (mode == 'CopySchedule') {
        //    var accnamewiseamount: any;
        //    var istypeReserveRelease = false;
        //    for (var a = 0; a < this.reserveAccountsList.length; a++) {
        //        accnamewiseamount = 0;
        //        for (var m = 0; m < this.reserveScheduleList.length; m++) {
        //            istypeReserveRelease = false;
        //            if (this.reserveScheduleList[m].PurposeTypeText == 'Reserve Release') {
        //                istypeReserveRelease = true;
        //                var scheduleKeys = Object.keys(this.reserveScheduleList[m]);
        //                var schedulevalues = Object.values(this.reserveScheduleList[m]);
        //                for (var n = 0; n < scheduleKeys.length; n++) {
        //                    if (this.reserveAccountsList[a].ReserveAccountName == scheduleKeys[n]) {
        //                        if (schedulevalues[n] == null) {
        //                            schedulevalues[n] = 0;
        //                        }
        //                        accnamewiseamount = accnamewiseamount + schedulevalues[n];
        //                    }
        //                }
        //            }
        //        }
        //        if (istypeReserveRelease == true) {
        //            if (this.reserveAccountsList[a].InitialFundingAmount < accnamewiseamount) {
        //                var colno = this.flexReserveSchedule.getColumn(this.reserveAccountsList[a].ReserveAccountName).index;
        //                for (var i = 0; i < rowarr.length; i++) {
        //                    this.flexReserveSchedule.setCellData(rowarr[i], colno, 0);
        //                }
        //                _isInitialFundingsmaller = true;
        //                if (!accountname.includes(this.reserveAccountsList[a].ReserveAccountName)) {
        //                    accountname = accountname + this.reserveAccountsList[a].ReserveAccountName + ', ';
        //                }
        //            }
        //        }
        //    }
        //}
        //if (mode == 'EditSchedule') {
        //    if (this.flexReserveSchedule.rows[startrowno].dataItem.PurposeTypeText == 'Reserve Release') {
        //        for (var a = 0; a < this.reserveAccountsList.length; a++) {
        //            accnamecoltotal = 0;
        //            var colname = this.flexReserveSchedule.columns[colnum].binding;
        //            for (var p = 0; p < scheduleKeys.length; p++) {
        //                if (this.reserveAccountsList[a].ReserveAccountName == colname) {
        //                    if (colname == scheduleKeys[p]) {
        //                        var celldata = this.flexReserveSchedule.getCellData(startrowno, colnum, false);
        //                        if (celldata > this.flexReserveAccounts.rows[a].dataItem.InitialFundingAmount) {
        //                            var colno = this.flexReserveSchedule.getColumn(this.reserveAccountsList[a].ReserveAccountName).index;
        //                            this.flexReserveSchedule.setCellData(startrowno, colno, 0);
        //                            _isInitialFundingsmaller = true;
        //                            if (!accountname.includes(this.reserveAccountsList[a].ReserveAccountName)) {
        //                                accountname = accountname + this.reserveAccountsList[a].ReserveAccountName + ', ';
        //                            }
        //                        }
        //                    }
        //                }
        //            }
        //        }
        //    }
        //}
        // to check estimated balance
        for (var a = 0; a < this.reserveAccountsList.length; a++) {
            accnamecoltotal = 0;
            //filteredlst = this.reserveScheduleList.filter(x => x.Date <= todaysdate);
            if (this.reserveScheduleList.length > 0) {
                for (var m = 0; m < this.reserveScheduleList.length; m++) {
                    var scheduleKeys = Object.keys(this.reserveScheduleList[m]);
                    var schedulevalues = Object.values(this.reserveScheduleList[m]);
                    for (var n = 0; n < scheduleKeys.length; n++) {
                        if (this.reserveAccountsList[a].ReserveAccountName == scheduleKeys[n]) {
                            if (schedulevalues[n] == null) {
                                schedulevalues[n] = 0;
                            }
                            accnamecoltotal = accnamecoltotal + schedulevalues[n];
                        }
                    }
                }
                estimatedreservebal = this.flexReserveAccounts.rows[a].dataItem.InitialFundingAmount + accnamecoltotal;
                if (_isInitialFundingsmaller == false) {
                    if (estimatedreservebal < 0) {
                        var _colno = this.flexReserveSchedule.getColumn(this.reserveAccountsList[a].ReserveAccountName).index;
                        if (mode == 'CopySchedule') {
                            for (var i = 0; i < rowarr.length; i++) {
                                this.flexReserveSchedule.setCellData(rowarr[i], _colno, 0);
                            }
                        }
                        else {
                            this.flexReserveSchedule.setCellData(startrowno, _colno, 0);
                        }
                        _isestimatedbalzero = true;
                        if (!accountname.includes(this.reserveAccountsList[a].ReserveAccountName)) {
                            accountname = accountname + this.reserveAccountsList[a].ReserveAccountName + ', ';
                        }
                    }
                    else {
                        this.flexReserveSchedule.rows[startrowno].dataItem.ReserveAmount = accnamecoltotal;
                    }
                }
            }
        }
        if (mode == 'Applied') {
            var lstAppliedOnly = this.reserveScheduleList.filter(function (x) { return x.Applied == true; });
            //var scheduleKeys = Object.keys(this.flexReserveSchedule.rows[startrowno].dataItem);
            //var schedulevalues = Object.values(this.flexReserveSchedule.rows[startrowno].dataItem);
            for (var a = 0; a < this.reserveAccountsList.length; a++) {
                accnamecoltotal = 0;
                for (var appl = 0; appl < lstAppliedOnly.length; appl++) {
                    var scheduleKeys = Object.keys(lstAppliedOnly[appl]);
                    var schedulevalues = Object.values(lstAppliedOnly[appl]);
                    for (var n = 0; n < scheduleKeys.length; n++) {
                        if (this.reserveAccountsList[a].ReserveAccountName == scheduleKeys[n]) {
                            if (schedulevalues[n] == null) {
                                schedulevalues[n] = 0;
                            }
                            accnamecoltotal = accnamecoltotal + schedulevalues[n];
                        }
                    }
                }
                //if (this.flexReserveSchedule.rows[startrowno].dataItem.Applied == true) {
                //    estimatedreservebal = this.flexReserveAccounts.rows[a].dataItem.InitialFundingAmount + accnamecoltotal;
                //}
                //else {
                //    estimatedreservebal = this.flexReserveAccounts.rows[a].dataItem.EstimatedReserveBalance - accnamecoltotal;
                //}
                //this.flexReserveAccounts.rows[a].dataItem.EstimatedReserveBalance = estimatedreservebal;
                this.flexReserveAccounts.rows[a].dataItem.EstimatedReserveBalance = this.flexReserveAccounts.rows[a].dataItem.InitialFundingAmount + accnamecoltotal;
            }
        }
        for (var m = 0; m < this.reserveScheduleList.length; m++) {
            var rowscheduleKeys = Object.keys(this.reserveScheduleList[m]);
            var rowschedulevalues = Object.values(this.reserveScheduleList[m]);
            accnamewiseamount = 0;
            for (var a = 0; a < this.reserveAccountsList.length; a++) {
                for (var n = 0; n < rowscheduleKeys.length; n++) {
                    if (this.reserveAccountsList[a].ReserveAccountName == rowscheduleKeys[n]) {
                        if (rowschedulevalues[n] == null) {
                            rowschedulevalues[n] = 0;
                        }
                        accnamewiseamount = accnamewiseamount + rowschedulevalues[n];
                        if (this.reserveScheduleList[m].Applied || this.reserveScheduleList[m].PurposeTypeText == 'Reserve Release') {
                            sumwireConfirmAndNegAMt = sumwireConfirmAndNegAMt + schedulevalues[n];
                        }
                    }
                }
            }
            this.flexReserveSchedule.rows[m].dataItem.ReserveAmount = accnamewiseamount;
        }
        this.flexReserveAccounts.invalidate();
        if (_isestimatedbalzero == true) {
            this.CustomAlert("Reserve Release amount for account - " + accountname.slice(0, -2) + " can not be more than its respective Current Reserve Balance.");
        }
        //if (_isInitialFundingsmaller == true) {
        //    this.CustomAlert("Sum of reserve schedule amount can not be greater than reserve account initial funding amount for account - " + accountname.slice(0, -2));
        //}
    };
    DealDetailComponent.prototype.cellBeginEditReserveAccounts = function (s, e) {
        var col = s.columns[e.col];
        if (col.binding == 'EstimatedReserveBalance') {
            e.cancel = true;
        }
        else {
            e.cancel = false;
        }
    };
    DealDetailComponent.prototype.cellPastingReserveAccounts = function (s, e) {
        var accnamecol = s.getColumn("ReserveAccountName").index;
        var accinitialdatecol = s.getColumn("InitialBalanceDate").index;
        var accinitialfundcol = s.getColumn("InitialFundingAmount").index;
        var accfloatcol = s.getColumn("FloatInterestRate").index;
        if (!(e.col == accnamecol || e.col == accinitialdatecol || e.col == accinitialfundcol || e.col == accfloatcol)) {
            e.cancel = true;
            this.currentEstimatedBalanceColPasted = true;
        }
        else {
            e.cancel = false;
            this.currentEstimatedBalanceColPasted = false;
        }
    };
    DealDetailComponent.prototype.validateReserveAccountList = function () {
        var _this = this;
        var _isvalidation = '';
        var err = '';
        var _isrowtobeSpliced = false;
        var _isholidaydatefound = '';
        var negativeInitialFundingAmount = '';
        for (var j = 0; j < this.reserveAccountsList.length; j++) {
            if (Object.keys(this.reserveAccountsList[j]).length > 0) {
                if (!(this.reserveAccountsList[j].hasOwnProperty('InitialBalanceDate') && this.reserveAccountsList[j].hasOwnProperty('InitialFundingAmount') && this.reserveAccountsList[j].hasOwnProperty('EstimatedReserveBalance'))) {
                    if (this.reserveAccountsList[j].CREReserveAccountID == "" && this.reserveAccountsList[j].ReserveAccountName == "") {
                        this.reserveAccountsList.splice(j, 1);
                        _isrowtobeSpliced = true;
                    }
                    else if (!(this.reserveAccountsList[j].hasOwnProperty('CREReserveAccountID')) && this.reserveAccountsList[j].ReserveAccountName == "") {
                        this.reserveAccountsList.splice(j, 1);
                        _isrowtobeSpliced = true;
                    }
                    else if (!(this.reserveAccountsList[j].hasOwnProperty('ReserveAccountName')) && this.reserveAccountsList[j].CREReserveAccountID == "") {
                        this.reserveAccountsList.splice(j, 1);
                        _isrowtobeSpliced = true;
                    }
                    if (_isrowtobeSpliced == true) {
                        if (j == 0) {
                            j = 0;
                        }
                        else {
                            j = j - 1;
                        }
                    } //
                }
                //if (this.reserveAccountsList[j].CREReserveAccountID == "" || this.reserveAccountsList[j].CREReserveAccountID == null || this.reserveAccountsList[j].CREReserveAccountID == undefined) {
                //    if (!_isvalidation.includes('Reserve account ID')) {
                //        _isvalidation = _isvalidation + 'Reserve account ID' + ', ';
                //    }
                //}
                if (this.reserveAccountsList[j].ReserveAccountName == "" || this.reserveAccountsList[j].ReserveAccountName == null || this.reserveAccountsList[j].ReserveAccountName == undefined) {
                    if (!_isvalidation.includes('Reserve account name')) {
                        _isvalidation = _isvalidation + 'Reserve account name' + ', ';
                    }
                }
                if (this.reserveAccountsList[j].InitialBalanceDate == "" || this.reserveAccountsList[j].InitialBalanceDate == null || this.reserveAccountsList[j].InitialBalanceDate == undefined) {
                    if (!_isvalidation.includes('Initial balance date')) {
                        _isvalidation = _isvalidation + 'Initial balance date' + ', ';
                    }
                }
                if (this.reserveAccountsList[j].InitialFundingAmount == "" || this.reserveAccountsList[j].InitialFundingAmount == null || this.reserveAccountsList[j].InitialFundingAmount == undefined) {
                    if (!_isvalidation.includes('Initial funding amount')) {
                        _isvalidation = _isvalidation + 'Initial funding amount' + ', ';
                    }
                }
                else if (this.reserveAccountsList[j].InitialFundingAmount < 0) {
                    if (!negativeInitialFundingAmount.includes(this.reserveAccountsList[j].InitialFundingAmount)) {
                        negativeInitialFundingAmount += this.reserveAccountsList[j].InitialFundingAmount + ', ';
                    }
                }
                if (this.reserveAccountsList[j].InitialBalanceDate) {
                    var accsDate = this.reserveAccountsList[j].InitialBalanceDate;
                    var formateddate = this.convertDateToReserveBindable(accsDate);
                    var accAccountdateday = accsDate.getDay();
                    if (accAccountdateday == 6 || accAccountdateday == 0 || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411; }).length > 0) {
                        if (!_isholidaydatefound.includes(formateddate)) {
                            _isholidaydatefound = _isholidaydatefound + formateddate + ', ';
                        }
                    }
                }
            }
        }
        if (_isholidaydatefound != '') {
            err = err + "<p>" + "Reserve account date - " + _isholidaydatefound.slice(0, -2) + " is either on holiday or weekend. Please enter different date." + " </p>";
        }
        if (_isvalidation != '') {
            err = err + "<p>" + 'Reserve account - ' + _isvalidation.slice(0, -2) + " can not be blank." + "</p>";
        }
        if (negativeInitialFundingAmount != '') {
            err = err + "<p>" + 'Reserve account - Initial funding amount can not be less than zero.' + "</p>";
        }
        // for unique reserve account name
        var _isfoundduplicateName = '';
        for (var j = 0; j < this.reserveAccountsList.length; j++) {
            for (var l = j + 1; l < this.reserveAccountsList.length; l++) {
                if (this.reserveAccountsList[j].ReserveAccountName != undefined) {
                    if (this.reserveAccountsList[j].ReserveAccountName == this.reserveAccountsList[l].ReserveAccountName) {
                        if (!_isfoundduplicateName.includes(this.reserveAccountsList[j].ReserveAccountName)) {
                            _isfoundduplicateName = _isfoundduplicateName + this.reserveAccountsList[j].ReserveAccountName + ', ';
                        }
                    }
                }
            }
        }
        if (_isfoundduplicateName != '') {
            err = err + "Reserve account name(s) already exists- " + _isfoundduplicateName.slice(0, -2) + " " + "</p>";
        }
        this._isReserveValidation = '';
        if (err != '') {
            this._isReserveValidation = err;
        }
    };
    DealDetailComponent.prototype.validateReserveScheduleList = function () {
        var _this = this;
        var err = '';
        var _isvalidation = '';
        var _isDate = '';
        var _isholidaydatefound = '';
        var _isrowtobeSpliced = false;
        var _isnegativeamountval = false;
        var _ispositiveamountval = false;
        var accountname = '';
        // find minimum date and initial funding total amount in account grid
        if (this.reserveAccountsList !== undefined && this.reserveAccountsList != null && this.reserveAccountsList.length > 0) {
            var _mindate = this.reserveAccountsList[0].InitialBalanceDate;
            for (var i = 0; i < this.reserveAccountsList.length; i++) {
                if (this.reserveAccountsList[i].InitialBalanceDate < _mindate) {
                    _mindate = this.reserveAccountsList[i].InitialBalanceDate;
                }
            }
        }
        for (var j = 0; j < this.reserveScheduleList.length; j++) {
            if (Object.keys(this.reserveScheduleList[j]).length > 0) {
                if (!('ReserveAmount' in this.reserveScheduleList[j])) {
                    if (!(this.reserveScheduleList[j].hasOwnProperty('Date')) && this.reserveScheduleList[j].PurposeTypeText == "") {
                        this.reserveScheduleList.splice(j, 1);
                        _isrowtobeSpliced = true;
                    }
                    else if (!(this.reserveScheduleList[j].hasOwnProperty('PurposeTypeText')) && !(this.reserveScheduleList[j].hasOwnProperty('Date'))) {
                        this.reserveScheduleList.splice(j, 1);
                        _isrowtobeSpliced = true;
                    }
                }
                else if ((this.reserveScheduleList[j].ReserveAmount == null || this.reserveScheduleList[j].ReserveAmount == 0) && (this.reserveScheduleList[j].Date == null && this.reserveScheduleList[j].PurposeID == null)) {
                    this.reserveScheduleList.splice(j, 1);
                    _isrowtobeSpliced = true;
                }
                if (_isrowtobeSpliced == true) {
                    if (j == 0) {
                        j = 0;
                    }
                    else {
                        j = j - 1;
                    }
                }
                if (this.reserveScheduleList.length > 0) {
                    if (this.reserveScheduleList[j].Date == "" || this.reserveScheduleList[j].Date == null || this.reserveScheduleList[j].Date == undefined) {
                        if (!_isvalidation.includes('Date')) {
                            _isvalidation = _isvalidation + 'Date' + ', ';
                        }
                    }
                    else {
                        //if (this.reserveScheduleList[j].Date < _mindate) {
                        //var date = this.convertDateToBindable(this.reserveScheduleList[j].Date);
                        //if (!_isvalidation.includes(date)) {
                        //    _isDate = _isDate + date + ', ';
                        //}
                        var isValidReserveScheduleDate = true;
                        this.reserveAccountsList.forEach(function (e) {
                            if (_this.reserveScheduleList[j][e.ReserveAccountName] != null &&
                                _this.reserveScheduleList[j][e.ReserveAccountName] != "" &&
                                _this.reserveScheduleList[j][e.ReserveAccountName] != 0) {
                                if (_this.reserveScheduleList[j].Date < e.InitialBalanceDate) {
                                    isValidReserveScheduleDate = false;
                                }
                            }
                        });
                        if (!isValidReserveScheduleDate) {
                            var date = this.convertDateToBindable(this.reserveScheduleList[j].Date);
                            if (!_isvalidation.includes(date)) {
                                _isDate = _isDate + date + ', ';
                            }
                        }
                    }
                    if (this.reserveScheduleList[j].PurposeID == "" || this.reserveScheduleList[j].PurposeID == null || this.reserveScheduleList[j].PurposeID == undefined) {
                        if (!_isvalidation.includes('Purpose')) {
                            _isvalidation = _isvalidation + 'Purpose' + ', ';
                        }
                    }
                    else if (this.reserveScheduleList[j].PurposeTypeText == 'Reserve Release') {
                        //if (this.reserveScheduleList[j].ReserveAmount > 0) {
                        //    if (_isnegativeamountval == false) {
                        //        _isnegativeamountval = true;
                        //    }
                        //}
                        this.reserveAccountsList.forEach(function (e) {
                            if (_this.reserveScheduleList[j][e.ReserveAccountName] != null &&
                                _this.reserveScheduleList[j][e.ReserveAccountName] != "" &&
                                _this.reserveScheduleList[j][e.ReserveAccountName] > 0) {
                                if (_isnegativeamountval == false) {
                                    _isnegativeamountval = true;
                                }
                            }
                        });
                    }
                    else if (this.reserveScheduleList[j].PurposeTypeText == 'Reserve Payment' || this.reserveScheduleList[j].PurposeTypeText == 'Float Interest') {
                        //if (this.reserveScheduleList[j].ReserveAmount < 0) {
                        //    if (_ispositiveamountval == false) {
                        //        _ispositiveamountval = true;
                        //    }
                        //}
                        this.reserveAccountsList.forEach(function (e) {
                            if (_this.reserveScheduleList[j][e.ReserveAccountName] != null &&
                                _this.reserveScheduleList[j][e.ReserveAccountName] != "" &&
                                _this.reserveScheduleList[j][e.ReserveAccountName] < 0) {
                                if (_ispositiveamountval == false) {
                                    _ispositiveamountval = true;
                                }
                            }
                        });
                    }
                    if (this.reserveScheduleList[j].ReserveAmount == "" || this.reserveScheduleList[j].ReserveAmount == null || this.reserveScheduleList[j].ReserveAmount == undefined) {
                        if (!_isvalidation.includes('Reserve amount')) {
                            _isvalidation = _isvalidation + 'Reserve amount' + ', ';
                        }
                    }
                    if (this.reserveScheduleList[j].Date) {
                        var accsDate = this.reserveScheduleList[j].Date;
                        var formateddate = this.convertDateToReserveBindable(accsDate);
                        var accScheduledateday = accsDate.getDay();
                        if (accScheduledateday == 6 || accScheduledateday == 0 || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411; }).length > 0) {
                            if (!_isholidaydatefound.includes(formateddate)) {
                                _isholidaydatefound = _isholidaydatefound + formateddate + ', ';
                            }
                        }
                    }
                }
            }
        }
        if (this.reserveScheduleList.length > 0) {
            var amount = 0;
            for (var m = 0; m < this.reserveAccountsList.length; m++) {
                var reservescheduletotalamount = 0;
                for (var l = 0; l < this.reserveScheduleList.length; l++) {
                    var rowscheduleKeys = Object.keys(this.reserveScheduleList[l]);
                    var rowschedulevalues = Object.values(this.reserveScheduleList[l]);
                    for (var n = 0; n < rowscheduleKeys.length; n++) {
                        if (this.reserveAccountsList[m].ReserveAccountName == rowscheduleKeys[n]) {
                            amount = 0;
                            if (rowschedulevalues[n] == null) {
                                amount = 0;
                            }
                            else {
                                amount = rowschedulevalues[n];
                            }
                            //amount = -1 * amount;
                            reservescheduletotalamount = reservescheduletotalamount + amount;
                        }
                    }
                }
                var estimatedreservebal = this.reserveAccountsList[m].InitialFundingAmount - reservescheduletotalamount;
                if (estimatedreservebal < 0) {
                    if (!accountname.includes(this.reserveAccountsList[m].ReserveAccountName)) {
                        accountname = accountname + this.reserveAccountsList[m].ReserveAccountName + ', ';
                    }
                }
            }
        }
        // to check account name wise sum of amount
        var _isnamefound = '';
        var _isNotEnoughtCurrBal = '';
        var accnamewiseamount;
        var sumwireConfirmAndNegAMt;
        for (var a = 0; a < this.reserveAccountsList.length; a++) {
            accnamewiseamount = 0;
            sumwireConfirmAndNegAMt = 0;
            for (var m = 0; m < this.reserveScheduleList.length; m++) {
                var scheduleKeys = Object.keys(this.reserveScheduleList[m]);
                var schedulevalues = Object.values(this.reserveScheduleList[m]);
                for (var n = 0; n < scheduleKeys.length; n++) {
                    if (this.reserveAccountsList[a].ReserveAccountName == scheduleKeys[n]) {
                        if (schedulevalues[n] == null) {
                            schedulevalues[n] = 0;
                        }
                        accnamewiseamount = accnamewiseamount + schedulevalues[n];
                        if (this.reserveScheduleList[m].Applied || this.reserveScheduleList[m].PurposeTypeText == 'Reserve Release') {
                            sumwireConfirmAndNegAMt = sumwireConfirmAndNegAMt + schedulevalues[n];
                        }
                    }
                }
            }
            //console.log(this.reserveAccountsList[a].ReserveAccountName + ':'+ sumwireConfirmAndNegAMt);
            //if (this.reserveAccountsList[a].InitialFundingAmount < accnamewiseamount) {
            //    if (!_isnamefound.includes(this.reserveAccountsList[a].ReserveAccountName)) {
            //        _isnamefound = _isnamefound + this.reserveAccountsList[a].ReserveAccountName + ', ';
            //    }
            //}
            if ((this.reserveAccountsList[a].InitialFundingAmount + sumwireConfirmAndNegAMt) < 0) {
                if (!_isNotEnoughtCurrBal.includes(this.reserveAccountsList[a].ReserveAccountName)) {
                    _isNotEnoughtCurrBal = _isNotEnoughtCurrBal + this.reserveAccountsList[a].ReserveAccountName + ', ';
                }
            }
        }
        if (_isnegativeamountval) {
            err = err + '<p>' + 'Reserve fund amount should be negative for purpose type Reserve Release.' + '</p>';
        }
        if (_ispositiveamountval) {
            err = err + '<p>' + 'Reserve fund amount should be positive for purpose type Reserve Payment and Float Interest.' + '</p>';
        }
        if (_isNotEnoughtCurrBal != '') {
            err = err + "<p>" + "Sum of wireconfirmed and reserve release amount for account - " + _isNotEnoughtCurrBal.slice(0, -2) + " can not be more than current reserve balance of account - " + _isNotEnoughtCurrBal.slice(0, -2) + "</p>";
        }
        //if (_isnamefound != '') {
        //    err = err + "<p>" + "Sum of reserve schedule amount for account - " + _isnamefound.slice(0, -2) + " can not be greater than reserve account - " + _isnamefound.slice(0, -2) + " initial funding amount." + " </p>";
        //}
        if (accountname != '') {
            err = err + "<p>" + "Reserve Release amount for account - " + accountname.slice(0, -2) + " can not be more than its respective Current Reserve Balance." + " </p>";
        }
        if (_isholidaydatefound != '') {
            err = err + "<p>" + "Reserve schedule date - " + _isholidaydatefound.slice(0, -2) + " is either on holiday or weekend. Please enter different date." + " </p>";
        }
        if (_isvalidation != '') {
            err = err + "<p>" + 'Reserve schedule - ' + _isvalidation.slice(0, -2) + " can not be blank." + "</p>";
        }
        if (_isDate != '') {
            //err = err + '<p>' + 'Reserve schedule date can not be smaller than minimum reserve account initial funding date - ' + _isDate.slice(0, -2) + '</p';
            err = err + '<p>' + 'Reserve schedule date can not be smaller than the associated reserve account initial funding date.Below Schedule dates are invalid.</br>' + _isDate.slice(0, -2) + '</p';
        }
        // to check WF status
        var isStatusChanged = false;
        for (var df = 0; df < this.originalReserveSchedulelst.length; df++) {
            var objreserveschedule = this.reserveScheduleList.filter(function (x) { return x.DealReserveScheduleID == _this.originalReserveSchedulelst[df].DealReserveScheduleID; });
            if (objreserveschedule.length > 0) {
                if (objreserveschedule[0].WF_CurrentStatus != "Projected" && objreserveschedule[0].WF_CurrentStatus != '' && objreserveschedule[0].WF_CurrentStatus != null) {
                    if (Number(objreserveschedule[0].PurposeTypeText).toString() == "NaN") {
                        if (objreserveschedule[0].PurposeTypeText != this.originalReserveSchedulelst[df].PurposeTypeText) {
                            isStatusChanged = true;
                            break;
                        }
                    }
                    else {
                        if (objreserveschedule[0].PurposeTypeText != this.originalReserveSchedulelst[df].PurposeID) {
                            isStatusChanged = true;
                            break;
                        }
                    }
                }
            }
        }
        if (isStatusChanged) {
            err = err + "<p>" + " You can not change the reserve fund purpose for the status above Projected.";
        }
        this._isReserveScheduleValidation = '';
        if (err != '') {
            this._isReserveScheduleValidation = err;
        }
    };
    DealDetailComponent.prototype.createReserveFundList = function () {
        var dtReserveAccount = [];
        for (var j = 0; j < this.reserveAccountsList.length; j++) {
            if (Object.keys(this.reserveAccountsList[j]).length > 0) {
                if (!('ReserveAccountGUID' in this.reserveAccountsList[j])) {
                    this.reserveAccountsList[j].ReserveAccountGUID = '00000000-0000-0000-0000-000000000000';
                }
                if (!('DealID' in this.reserveAccountsList[j])) {
                    this.reserveAccountsList[j].DealID = this._deal.DealID;
                }
                if (!('FloatInterestRate' in this.reserveAccountsList[j])) {
                    this.reserveAccountsList[j].FloatInterestRate = null;
                }
                if (!('CREReserveAccountID' in this.reserveAccountsList[j])) {
                    this.reserveAccountsList[j].CREReserveAccountID = 0;
                }
                dtReserveAccount.push({
                    'ReserveAccountGUID': this.reserveAccountsList[j].ReserveAccountGUID,
                    'DealID': this.reserveAccountsList[j].DealID,
                    'CREReserveAccountID': this.reserveAccountsList[j].CREReserveAccountID,
                    'ReserveAccountName': this.reserveAccountsList[j].ReserveAccountName,
                    'InitialBalanceDate': this.convertDatetoGMT(this.reserveAccountsList[j].InitialBalanceDate),
                    'InitialFundingAmount': this.reserveAccountsList[j].InitialFundingAmount,
                    'EstimatedReserveBalance': !(this.reserveAccountsList[j].EstimatedReserveBalance) ? 0 : this.reserveAccountsList[j].EstimatedReserveBalance,
                    'FloatInterestRate': this.reserveAccountsList[j].FloatInterestRate
                });
            }
        }
        this.reserveAccountsList = dtReserveAccount;
        var isrowchangedfilteredlst = this.reserveScheduleList.filter(function (x) { return x._IsRowChanged == true; });
        var dtlst = [];
        if (isrowchangedfilteredlst.length > 0) {
            for (var j = 0; j < isrowchangedfilteredlst.length; j++) {
                this.createDynamicColScheduleList(isrowchangedfilteredlst[j]);
                for (var h = 0; h < this.reserveScheduleDynamicColValues.length; h++) {
                    dtlst.push({
                        'DealReserveScheduleID': isrowchangedfilteredlst[j].DealReserveScheduleID == null ? '0' : isrowchangedfilteredlst[j].DealReserveScheduleID,
                        'DealReserveScheduleGUID': isrowchangedfilteredlst[j].DealReserveScheduleGUID == null ? '00000000-0000-0000-0000-000000000000' : isrowchangedfilteredlst[j].DealReserveScheduleGUID,
                        'DealID': this._deal.DealID,
                        'Date': this.convertDatetoGMT(isrowchangedfilteredlst[j].Date),
                        'Amount': isrowchangedfilteredlst[j].ReserveAmount,
                        'PurposeID': isrowchangedfilteredlst[j].PurposeID,
                        'Comment': isrowchangedfilteredlst[j].Comment,
                        'Applied': isrowchangedfilteredlst[j].Applied = isrowchangedfilteredlst[j].Applied == true ? true : false,
                        'isDeleted': isrowchangedfilteredlst[j].isDeleted,
                        'ReserveAccountID': this.reserveScheduleDynamicColValues[h].ReserveAccountID,
                        'CREReserveAccountID': this.reserveScheduleDynamicColValues[h].CREReserveAccountID,
                        'ReserveScheduleAmount': this.reserveScheduleDynamicColValues[h].ReserveScheduleAmount,
                        'RNO': j + 1
                    });
                }
            }
        }
        if (this._listdeletedReserveSchedule.length > 0) {
            for (var j = 0; j < this._listdeletedReserveSchedule.length; j++) {
                this.createDynamicColScheduleList(this._listdeletedReserveSchedule[j]);
                for (var h = 0; h < this.reserveScheduleDynamicColValues.length; h++) {
                    dtlst.push({
                        'DealReserveScheduleID': this._listdeletedReserveSchedule[j].DealReserveScheduleID,
                        'DealReserveScheduleGUID': this._listdeletedReserveSchedule[j].DealReserveScheduleGUID,
                        'DealID': this._deal.DealID,
                        'Date': this.convertDatetoGMT(this._listdeletedReserveSchedule[j].Date),
                        'Amount': this._listdeletedReserveSchedule[j].ReserveAmount,
                        'PurposeID': this._listdeletedReserveSchedule[j].PurposeID,
                        'Comment': this._listdeletedReserveSchedule[j].Comment,
                        'Applied': this._listdeletedReserveSchedule[j].Applied = this._listdeletedReserveSchedule[j].Applied == true ? true : false,
                        'isDeleted': this._listdeletedReserveSchedule[j].isDeleted,
                        'ReserveAccountID': this.reserveScheduleDynamicColValues[h].ReserveAccountID,
                        'CREReserveAccountID': this.reserveScheduleDynamicColValues[h].CREReserveAccountID,
                        'ReserveScheduleAmount': this.reserveScheduleDynamicColValues[h].ReserveScheduleAmount,
                        'RNO': j + 1
                    });
                }
            }
        }
        this.reserveScheduleList = dtlst;
    };
    DealDetailComponent.prototype.createDynamicColScheduleList = function (data) {
        var header = [];
        var headervalue = [];
        var dt = [];
        dt = data;
        this.reserveScheduleDynamicColValues = [];
        $.each(dt, function (obj) {
            var i = 0;
            $.each(dt, function (key, value) {
                header[i] = key;
                headervalue[i] = value;
                i = i + 1;
            });
            return false;
        });
        for (var n = 0; n < header.length; n++) {
            for (var m = 0; m < this.reserveScheduleDynamicCol.length; m++) {
                if (this.reserveScheduleDynamicCol[m] == header[n]) {
                    this.reserveScheduleDynamicColValues.push({
                        'ReserveAccountID': null,
                        'ReserveAccountGUID': null,
                        'CREReserveAccountID': null,
                        'ReserveAccountName': header[n],
                        'ReserveScheduleAmount': headervalue[n]
                    });
                }
            }
        }
        for (var k = 0; k < this._listReserveAccounts.items.length; k++) {
            for (var l = 0; l < this.reserveScheduleDynamicColValues.length; l++) {
                if (this._listReserveAccounts.items[k].ReserveAccountName == this.reserveScheduleDynamicColValues[l].ReserveAccountName) {
                    this.reserveScheduleDynamicColValues[l].ReserveAccountGUID = this._listReserveAccounts.items[k].ReserveAccountGUID;
                    this.reserveScheduleDynamicColValues[l].CREReserveAccountID = this._listReserveAccounts.items[k].CREReserveAccountID;
                    this.reserveScheduleDynamicColValues[l].ReserveAccountID = this._listReserveAccounts.items[k].ReserveAccountID;
                }
            }
        }
    };
    DealDetailComponent.prototype.showReserveCommentEmptyAlert = function (comment, DealReserveScheduleGUID, date, amount, purposetype) {
        var workflowerror = "";
        if (comment == '' || comment == null || comment == undefined) {
            workflowerror = workflowerror + "<p>" + "Inputting a Comment is mandatory for the reserve workflow process." + "</p>";
            this.CustomAlert(workflowerror);
        }
        else {
            for (var i = 0; i < this.originalReserveSchedulelst.length; i++) {
                if (DealReserveScheduleGUID == this.originalReserveSchedulelst[i].DealReserveScheduleGUID) {
                    if (comment != this.originalReserveSchedulelst[i].Comment || this.convertDateToBindable(date) != this.convertDateToBindable(this.originalReserveSchedulelst[i].Date) || amount != this.originalReserveSchedulelst[i].ReserveAmount || this.originalReserveSchedulelst[i].PurposeTypeText != purposetype) {
                        this.CustomAlert("Please save the deal after adding date, amount, comment, purpose type and then proceed with workflow.");
                    }
                    else {
                        this._router.navigate(['/workflowdetail', DealReserveScheduleGUID, 719]);
                    }
                }
            }
        }
    };
    DealDetailComponent.prototype.changeReserveScheduleApplied = function (reserveScheduleID, value, reserveflexGrid) {
        if (!('_IsRowChanged' in this.flexReserveSchedule.rows[reserveflexGrid.index].dataItem)) {
            this.flexReserveSchedule.rows[reserveflexGrid.index].dataItem._IsRowChanged = true;
        }
        this.reserveScheduleList[reserveflexGrid.index] = this.flexReserveSchedule.rows[reserveflexGrid.index].dataItem;
        if (this.reserveScheduleList[reserveflexGrid.index].Date == undefined) {
            this.flexReserveSchedule.rows[reserveflexGrid.index].Applied = false;
            this.flexReserveSchedule.invalidate();
            this.CustomAlert("Date can not be blank.");
            return;
        }
        if (value == true) {
            if (this.reserveScheduleList[reserveflexGrid.index].PurposeTypeText == 'Reserve Release') {
                if (!(this.reserveScheduleList[reserveflexGrid.index].WF_CurrentStatusDisplayName == "Completed") || this.reserveScheduleList[reserveflexGrid.index].WF_CurrentStatusDisplayName == null) {
                    this.CustomAlert("You cannot wire confirm the record as the workflow status is not completed.");
                    this.flexReserveSchedule.rows[reserveflexGrid.index].dataItem.Applied = false;
                    this.flexReserveSchedule.invalidate();
                    return;
                }
            }
            if (this.reserveScheduleList.length >= 1) {
                var lstDates = this.reserveScheduleList.filter(function (x) { return x.Applied == false; }).map(function (x) { return x.Date; });
                if (lstDates.length > 1) {
                    var minDate;
                    minDate = null;
                    // var minDate = new Date(Math.min.apply(null, this.listdealfunding.filter(x => x.Applied == false).map(x => x.Date)));
                    for (var val = 0; val < this.reserveScheduleList.length; val++) {
                        if (this.reserveScheduleList[val].Date != null && this.reserveScheduleList[val].Applied == false) {
                            if (minDate === null || this.reserveScheduleList[val].Date < minDate) {
                                minDate = this.reserveScheduleList[val].Date;
                            }
                        }
                    }
                    if (minDate != null) {
                        minDate = new Date(minDate);
                    }
                    var wcDate = new Date(reserveflexGrid.dataItem.Date);
                    if (wcDate.toString() != minDate.toString()) {
                        reserveflexGrid.dataItem.Applied = false;
                        this.flexReserveSchedule.invalidate();
                        this.CustomAlert("You can't confirm wire on a later date without confirming all wires in between.");
                        return;
                    }
                    else {
                        var today = new Date();
                        var nextbdate = this.getnextbusinessDate(today, 20, true);
                        if (wcDate > nextbdate) {
                            reserveflexGrid.dataItem.Applied = false;
                            this.flexReserveSchedule.invalidate();
                            this.CustomAlert("You can only confirm up to " + this.convertDateToBindable(nextbdate) + ".");
                            return;
                        }
                    }
                }
                else {
                    var applieddate = this.reserveScheduleList[reserveflexGrid.index].Date;
                    if (lstDates[0] < reserveflexGrid.dataItem.Date) {
                        reserveflexGrid.dataItem.Applied = false;
                        this.flexReserveSchedule.invalidate();
                        this.CustomAlert("You can't confirm wire on a later date without confirming all wires in between.");
                        return;
                    }
                }
            }
        }
        else {
            var maxDate = new Date(Math.max.apply(null, this.reserveScheduleList.filter(function (x) { return x.Applied == true; }).map(function (x) { return x.Date; })));
            if (maxDate.toJSON()) {
                if (reserveflexGrid.dataItem.Date) {
                    var wcDate = new Date(reserveflexGrid.dataItem.Date);
                    if (wcDate.toString() != maxDate.toString()) {
                        this.flexReserveSchedule.invalidate();
                        this.CustomAlert("You can't remove a wire confirmation on an earlier date without removing the wire confirmation on later dates.");
                        return;
                    }
                }
            }
        }
        this.reserveScheduleList[reserveflexGrid.index].Applied = value;
        this.onChangereserveamount(reserveflexGrid.index, this.flexReserveSchedule.rows.length - 1, null, 'Applied');
        this.reserveAppliedReadOnly();
    };
    DealDetailComponent.prototype.reserveAppliedReadOnly = function () {
        var wireconfirmcol = this.flexReserveSchedule.getColumn("Applied").index;
        var dynamiccolindex = this.flexReserveSchedule.getColumn(this.reserveAccountsList[0].ReserveAccountName).index;
        if (this.flexReserveSchedule) {
            this.flexReserveSchedule.itemFormatter = function (panel, r, c, cell) {
                if (panel.cellType != wjcGrid.CellType.Cell) {
                    return;
                }
                if (panel.rows[r].dataItem) {
                    var isWFCompleted = panel.rows[r].dataItem.WF_IsCompleted;
                    var item = panel.getCellData(r, wireconfirmcol);
                    if (item == true) {
                        cell.style.backgroundColor = '#cfcfcf';
                        // cell.style.color = 'black';
                    }
                    else if (isWFCompleted == 1 && item == false) {
                        if (panel.columns[c].header != 'Date') {
                            cell.style.backgroundColor = '#cce6ff';
                            // cell.style.color = 'black';
                        }
                        else {
                            cell.style.backgroundColor = null;
                        }
                    }
                    else {
                        cell.style.backgroundColor = null;
                    }
                    if (c >= dynamiccolindex) {
                        var cellvalue = panel.getCellData(r, c);
                        if (cellvalue > 0) {
                            cell.style.color = 'darkgreen';
                        }
                        else if (cellvalue < 0) {
                            cell.style.color = 'red';
                        }
                    }
                }
            };
        }
    };
    DealDetailComponent.prototype.convertDateToReserveBindable = function (date) {
        var dateObj = null;
        if (date) {
            if (typeof (date) == "string") {
                date = date.replace("Z", "");
                dateObj = new Date(date);
            }
            else {
                dateObj = date;
            }
            if (dateObj != null) {
                //return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear();
                return dateObj.toLocaleDateString('en-US', {
                    day: '2-digit', month: '2-digit', year: 'numeric'
                }).replace(/ /g, '-');
            }
        }
    };
    DealDetailComponent.prototype.OpenMaturityConfigPopUp = function () {
        var _this = this;
        var modal = document.getElementById('maturityConfigModal');
        modal.style.display = "block";
        $.getScript("/js/jsDrag.js");
        var data = [];
        var lstdata = [];
        var newnotelst = [];
        var lstnote = this.lstNote.filter(function (x) { return !(x.CRENoteID == undefined || x.CRENoteID == ''); });
        if (this.lstMaturityConfiguration.length == 0) {
            lstdata = lstnote;
        }
        else if (this.lstMaturityConfiguration.length < lstnote.length) {
            for (var l = 0; l < lstnote.length; l++) {
                if (!('NoteId' in lstnote[l])) {
                    newnotelst.push(lstnote[l]);
                }
            }
            lstdata = this.lstMaturityConfiguration;
        }
        else {
            lstdata = this.lstMaturityConfiguration;
        }
        for (var n = 0; n < lstdata.length; n++) {
            var noteid = !lstdata[n].NoteID ? lstdata[n].NoteId : lstdata[n].NoteID;
            var notename = lstdata[n].CRENoteID + ": " + lstdata[n].Name;
            data.push({
                "NoteSequenceNumber": lstdata[n].NoteSequenceNumber,
                "NoteID": noteid == undefined ? '00000000-0000-0000-0000-000000000000' : noteid,
                "CRENoteID": lstdata[n].CRENoteID,
                "Name": lstdata[n].Name,
                "Note": lstdata[n].CRENoteID + ": " + lstdata[n].Name,
                "PreviousMethodID": lstdata[n].MaturityMethodID,
                "PreviousMethodIDText": lstdata[n].MaturityMethodIDText,
                "PreviousGroupName": lstdata[n].MaturityGroupName == "" || lstdata[n].MaturityGroupName.toString() == "null" ? notename : lstdata[n].MaturityGroupName,
                "MaturityGroupName": lstdata[n].MaturityGroupName == "" || lstdata[n].MaturityGroupName.toString() == "null" ? '' : lstdata[n].MaturityGroupName,
                "MaturityMethodID": lstdata[n].MaturityMethodID,
                "MaturityMethodIDText": lstdata[n].MaturityMethodIDText
            });
        }
        if (newnotelst.length > 0) {
            for (var l = 0; l < newnotelst.length; l++) {
                var notename = newnotelst[l].CRENoteID + ": " + newnotelst[l].Name;
                data.push({
                    "NoteSequenceNumber": newnotelst[l].NoteSequenceNumber,
                    "NoteID": '00000000-0000-0000-0000-000000000000',
                    "CRENoteID": newnotelst[l].CRENoteID,
                    "Name": newnotelst[l].Name,
                    "Note": notename,
                    "PreviousMethodID": '',
                    "PreviousMethodIDText": '',
                    "PreviousGroupName": '',
                    "MaturityGroupName": '',
                    "MaturityMethodID": '',
                    "MaturityMethodIDText": ''
                });
            }
        }
        this.lstMaturityConfiguration = data;
        setTimeout(function () {
            _this.flexMaturityConfig.invalidate();
        }, 200);
    };
    DealDetailComponent.prototype.CloseMaturityConfigPopUp = function () {
        var modal = document.getElementById('maturityConfigModal');
        modal.style.display = "none";
        var data = [];
        var datagroupname = [];
        var uniquieData = [];
        if (this._isMaturityConfigUpdated == false) {
            for (var n = 0; n < this.lstMaturityConfiguration.length; n++) {
                var notename = this.lstMaturityConfiguration[n].CRENoteID + ": " + this.lstMaturityConfiguration[n].Name;
                data.push({
                    "NoteSequenceNumber": this.lstMaturityConfiguration[n].NoteSequenceNumber,
                    "NoteID": this.lstMaturityConfiguration[n].NoteId,
                    "CRENoteID": this.lstMaturityConfiguration[n].CRENoteID,
                    "Name": this.lstMaturityConfiguration[n].Name,
                    "Note": this.lstMaturityConfiguration[n].CRENoteID + ": " + this.lstMaturityConfiguration[n].Name,
                    "PreviousMethodID": this.lstMaturityConfiguration[n].PreviousMethodID,
                    "PreviousMethodIDText": this.lstMaturityConfiguration[n].PreviousMethodIDText,
                    "PreviousGroupName": this.lstMaturityConfiguration[n].PreviousGroupName,
                    "MaturityGroupName": this.lstMaturityConfiguration[n].PreviousGroupName == notename ? '' : this.lstMaturityConfiguration[n].PreviousGroupName,
                    "MaturityMethodID": this.lstMaturityConfiguration[n].PreviousMethodID == null ? null : this.lstMaturityConfiguration[n].PreviousMethodID,
                    "MaturityMethodIDText": this.lstMaturityConfiguration[n].PreviousMethodIDText
                });
            }
            this.lstMaturityConfiguration = data;
            var firstmethodidlst = this.lstMaturityConfiguration.filter(function (x) { return x.MaturityMethodIDText == "Most recent effective date" || x.MaturityMethodIDText == "All effective date(s)"; });
            var secondmethodidlst = this.lstMaturityConfiguration.filter(function (x) { return !(x.MaturityMethodIDText == "Most recent effective date" || x.MaturityMethodIDText == "All effective date(s)"); });
            for (var n = 0; n < firstmethodidlst.length; n++) {
                var _notename = firstmethodidlst[n].Note;
                if (!uniquieData.includes(firstmethodidlst[n].MaturityGroupName)) {
                    uniquieData.push(firstmethodidlst[n].MaturityGroupName == "" || firstmethodidlst[n].MaturityGroupName.toString() == "null" ? _notename : firstmethodidlst[n].MaturityGroupName);
                }
            }
            for (var n = 0; n < secondmethodidlst.length; n++) {
                var _notename = secondmethodidlst[n].Note;
                if (!uniquieData.includes(secondmethodidlst[n].MaturityGroupName)) {
                    uniquieData.push(secondmethodidlst[n].MaturityGroupName == "" || secondmethodidlst[n].MaturityGroupName.toString() == "null" ? _notename : secondmethodidlst[n].MaturityGroupName);
                }
            }
            for (var n = 0; n < uniquieData.length; n++) {
                var CRENotelist = this.lstMaturityConfiguration.filter(function (x) { return x.MaturityGroupName == uniquieData[n]; });
                var lstCRENoteId = '';
                var Notename = '';
                if (CRENotelist.length > 0) {
                    for (var d = 0; d < CRENotelist.length; d++) {
                        Notename = Notename + CRENotelist[d].Name + ", ";
                        lstCRENoteId += CRENotelist[d].CRENoteID + ", ";
                    }
                    lstCRENoteId.slice(0, -1);
                }
                else {
                    var CRENotelist = this.lstMaturityConfiguration.filter(function (x) { return x.Note == uniquieData[n]; });
                    Notename = CRENotelist[0].Name + ", ";
                }
                datagroupname.push({
                    "MaturityGroupName": uniquieData[n],
                    "CRENoteID": lstCRENoteId,
                    "Maturitytooltip": Notename.substring(0, Notename.length - 2)
                });
            }
            this.lstGroupName = datagroupname;
        }
        this._isMaturityConfigUpdated = false;
    };
    DealDetailComponent.prototype.onChangeMaturityGroup = function (groupName) {
        this.createMaturityList('Change', null, this.selectedGroupName);
        if (this._isMaturityError == "") {
            this.selectedGroupName = groupName;
        }
        else {
            this.selectedGroupName = this.selectedGroupName;
            $('#selectedNoteName').val(this.selectedGroupName);
        }
        this.GetScheduleEffectiveDateCount();
        this.invalidateMaturitygridData(this.maturityList, this.selectedGroupName);
    };
    DealDetailComponent.prototype.cellEditMaturityConfig = function (matflex, e) {
        var maturitymethodcol = matflex.getColumn("MaturityMethodIDText").index;
        if (e.col == maturitymethodcol) {
            if (!(Number(matflex.rows[e.row].dataItem.MaturityMethodIDText).toString() == "NaN" || Number(matflex.rows[e.row].dataItem.MaturityMethodIDText) == 0)) {
                matflex.rows[e.row].dataItem.MaturityMethodID = matflex.rows[e.row].dataItem.MaturityMethodIDText;
                matflex.rows[e.row].dataItem.MaturityMethodIDText = this.lstMaturityMethodID.filter(function (x) { return x.LookupID.toString() == matflex.rows[e.row].dataItem.MaturityMethodIDText; })[0].Name;
            }
        }
        this.lstMaturityConfiguration[e.row] = matflex.rows[e.row].dataItem;
    };
    DealDetailComponent.prototype.copyMaturityConfig = function (matflex, e) {
        for (var k = 0; k < matflex.rows.length; k++) {
            if (!(Number(matflex.rows[k].dataItem.MaturityMethodIDText).toString() == "NaN" || Number(matflex.rows[k].dataItem.MaturityMethodIDText) == 0)) {
                matflex.rows[k].dataItem.MaturityMethodID = matflex.rows[k].dataItem.MaturityMethodIDText;
                matflex.rows[k].dataItem.MaturityMethodIDText = this.lstMaturityMethodID.filter(function (x) { return x.LookupID.toString() == matflex.rows[k].dataItem.MaturityMethodIDText; })[0].Name;
            }
            this.lstMaturityConfiguration[k] = matflex.rows[k].dataItem;
        }
    };
    DealDetailComponent.prototype.maturityConfigurationSetup = function () {
        this.isMaturityDataChanged = true;
        var data = [];
        var uniquieData = [];
        var errmsg = '';
        var crenoteid = '';
        var notelevelcrenoteid = '';
        var distinctmethod = '';
        var firstmethodidlst = this.lstMaturityConfiguration.filter(function (x) { return x.MaturityMethodIDText == "Most recent effective date" || x.MaturityMethodIDText == "All effective date(s)"; });
        var secondmethodidlst = this.lstMaturityConfiguration.filter(function (x) { return !(x.MaturityMethodIDText == "Most recent effective date" || x.MaturityMethodIDText == "All effective date(s)"); });
        for (var n = 0; n < firstmethodidlst.length; n++) {
            var notename = firstmethodidlst[n].Note;
            if (!uniquieData.includes(firstmethodidlst[n].MaturityGroupName)) {
                uniquieData.push(firstmethodidlst[n].MaturityGroupName == "" || firstmethodidlst[n].MaturityGroupName.toString() == "null" ? notename : firstmethodidlst[n].MaturityGroupName);
            }
        }
        for (var n = 0; n < secondmethodidlst.length; n++) {
            var notename = secondmethodidlst[n].Note;
            if (!uniquieData.includes(secondmethodidlst[n].MaturityGroupName)) {
                uniquieData.push(secondmethodidlst[n].MaturityGroupName == "" || secondmethodidlst[n].MaturityGroupName.toString() == "null" ? notename : secondmethodidlst[n].MaturityGroupName);
            }
        }
        for (var m = 0; m < this.lstMaturityConfiguration.length; m++) {
            if (this.lstMaturityConfiguration[m].MaturityMethodID == null || this.lstMaturityConfiguration[m].MaturityMethodIDText == "") {
                if (this.lstMaturityConfiguration[m].MaturityGroupName) {
                    crenoteid = crenoteid + this.lstMaturityConfiguration[m].CRENoteID + ', ';
                }
            }
            else if (this.lstMaturityConfiguration[m].MaturityGroupName == '' || this.lstMaturityConfiguration[m].MaturityGroupName == null) {
                if (this.lstMaturityConfiguration[m].MaturityMethodID.toString() != "723") {
                    crenoteid = crenoteid + this.lstMaturityConfiguration[m].CRENoteID + ', ';
                }
            }
            if (this.lstMaturityConfiguration[m].MaturityMethodID) {
                if (this.lstMaturityConfiguration[m].MaturityMethodID.toString() == "723") {
                    if (this.lstMaturityConfiguration[m].MaturityGroupName) {
                        notelevelcrenoteid = notelevelcrenoteid + this.lstMaturityConfiguration[m].CRENoteID + ', ';
                    }
                }
            }
        }
        for (var n = 0; n < uniquieData.length; n++) {
            var filteredlst = this.lstMaturityConfiguration.filter(function (x) { return x.MaturityGroupName == uniquieData[n]; });
            var filteredmethodlst = filteredlst.filter(function (x) { return x.MaturityMethodID == null ? '' : x.MaturityMethodID; });
            for (var m = 0; m < filteredmethodlst.length; m++) {
                for (var k = m + 1; k < filteredmethodlst.length; k++) {
                    if (filteredmethodlst[k].MaturityMethodID != filteredmethodlst[m].MaturityMethodID) {
                        if (!distinctmethod.includes(filteredmethodlst[k].CRENoteID)) {
                            distinctmethod = distinctmethod + filteredmethodlst[k].CRENoteID + ', ';
                        }
                    }
                }
            }
        }
        if (distinctmethod != '') {
            errmsg = errmsg + "<p>" + "For note(s)- " + distinctmethod.slice(0, -2) + " method name should be same for same group name." + "</p>";
        }
        if (crenoteid != '') {
            errmsg = errmsg + "<p>" + "For note(s)- " + crenoteid.slice(0, -2) + " method name or group name cannot be blank." + "</p>";
        }
        if (notelevelcrenoteid != '') {
            errmsg = errmsg + "<p>" + "For Note level method note(s)- " + notelevelcrenoteid.slice(0, -2) + " group name should be blank." + "</p>";
        }
        if (errmsg != '') {
            this.CustomAlert(errmsg);
        }
        else {
            this.checkMaturityMaxEffectiveDate();
            for (var n = 0; n < uniquieData.length; n++) {
                var CRENotelist = this.lstMaturityConfiguration.filter(function (x) { return x.MaturityGroupName == uniquieData[n]; });
                var lstCRENoteId = '';
                var Notename = '';
                if (CRENotelist.length > 0) {
                    for (var d = 0; d < CRENotelist.length; d++) {
                        Notename = Notename + CRENotelist[d].Name + ", ";
                        lstCRENoteId += CRENotelist[d].CRENoteID + ",";
                    }
                    lstCRENoteId.slice(0, -1);
                }
                else {
                    var CRENotelist = this.lstMaturityConfiguration.filter(function (x) { return x.Note == uniquieData[n]; });
                    Notename = CRENotelist[0].Name + ", ";
                }
                data.push({
                    "MaturityGroupName": uniquieData[n],
                    "CRENoteID": lstCRENoteId,
                    "Maturitytooltip": Notename.substring(0, Notename.length - 2)
                });
            }
            var selectedGrp = this.lstMaturityConfiguration.filter(function (x) { return x.NoteSequenceNumber == 1; });
            this.lstGroupName = data;
            this.invalidateMaturitygridData(this.maturityList, selectedGrp[0]["MaturityGroupName"]);
            this._isMaturityConfigUpdated = true;
            this.GetScheduleEffectiveDateCount();
            this.CloseMaturityConfigPopUp();
        }
    };
    DealDetailComponent.prototype.showcalcstatus = function () {
        var _this = this;
        var status = setInterval(function () {
            _this.dealSrv.GetDealCalculationStatus(_this._deal.DealID).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.DealCalcuStatus = res.DealCalcuStatus;
                    if ((_this.DealCalcuStatus == "Completed")) {
                        clearInterval(status);
                    }
                }
            });
        }, 30000);
    };
    DealDetailComponent.prototype.checkMaturityMaxEffectiveDate = function () {
        var _this = this;
        var mineffectivedate;
        var filteredeffectivedatelst = [];
        var minCRENoteID = '';
        var _foundCRENoteID = '';
        var maxeffectivedate = '';
        var methodfilterlst = this.lstMaturityConfiguration.filter(function (x) { return x.MaturityMethodID == null ? "" : x.MaturityMethodID.toString() == "721" && x.MaturityGroupName == _this.selectedGroupName; });
        if (methodfilterlst.length > 0) {
            var minNoteValue = Math.min.apply(null, methodfilterlst.map(function (item) { return item.NoteSequenceNumber == undefined ? 9999 : item.NoteSequenceNumber; }));
            if (minNoteValue) {
                minCRENoteID = this.lstMaturityConfiguration.find(function (x) { return x.NoteSequenceNumber == minNoteValue; }).CRENoteID;
            }
            if (this.maturityEffectiveDateslst.length > 0) {
                mineffectivedate = this.maturityEffectiveDateslst.filter(function (x) { return x.CRENoteID == minCRENoteID; })[0].EffectiveDate;
                for (var k = 0; k < methodfilterlst.length; k++) {
                    for (var l = 0; l < this.maturityEffectiveDateslst.length; l++) {
                        if (this.maturityEffectiveDateslst[l].CRENoteID == methodfilterlst[k].CRENoteID) {
                            filteredeffectivedatelst.push({
                                'CRENoteID': this.maturityEffectiveDateslst[l].CRENoteID,
                                'EffectiveDate': this.maturityEffectiveDateslst[l].EffectiveDate
                            });
                        }
                    }
                }
                maxeffectivedate = filteredeffectivedatelst.reduce(function (max, date) { return (date.EffectiveDate > max ? date.EffectiveDate : max); }, filteredeffectivedatelst[0].EffectiveDate);
                if (new Date(maxeffectivedate) > new Date(mineffectivedate)) {
                    for (var n = 0; n < filteredeffectivedatelst.length; n++) {
                        if (new Date(filteredeffectivedatelst[n].EffectiveDate) > new Date(mineffectivedate)) {
                            _foundCRENoteID = _foundCRENoteID + filteredeffectivedatelst[n].CRENoteID + ', ';
                        }
                    }
                }
            }
            if (_foundCRENoteID != '') {
                this._ShowmaturitydivWar = true;
                this._ShowmaturitydivMessageWar = 'For group- ' + this.selectedGroupName + ' effective date for note(s)- ' + _foundCRENoteID.slice(0, -2) + ' found greater than ' + this.convertDateToBindable(mineffectivedate) + ' that will invalidate the effective date for note(s)-' + _foundCRENoteID.slice(0, -2) + '.';
            }
            else {
                this._ShowmaturitydivWar = false;
                this._ShowmaturitydivMessageWar = '';
            }
        }
    };
    DealDetailComponent.prototype.mouseover = function (event) {
        $("#maturityPopup").hide();
        if (event.target.matches('#selectedNoteName')) {
            this.showToolTip();
            $("#maturityPopup").val('');
            $("#maturityPopup").show();
        }
    };
    DealDetailComponent.prototype.showToolTip = function () {
        var _this = this;
        this.tooltipList = [];
        var methodfilterlst = this.lstMaturityConfiguration.filter(function (x) { return x.MaturityGroupName == _this.selectedGroupName; });
        if (methodfilterlst.length > 0) {
            for (var j = 0; j < methodfilterlst.length; j++) {
                if (!(methodfilterlst[j].MaturityMethodID.toString() == "" || methodfilterlst[j].MaturityMethodID.toString() == "723" || methodfilterlst[j].MaturityMethodIDText == "Note level")) {
                    this.tooltipList.push(methodfilterlst[j].Name);
                }
            }
        }
    };
    DealDetailComponent.prototype.SetActiveTab = function (tab) {
        if (tab.trim().toLowerCase() == 'invoice') {
            this.ClickedTab = "aFeeInvoicetab";
        }
    };
    __decorate([
        core_1.ViewChild('flex'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "flex", void 0);
    __decorate([
        core_1.ViewChild('flexPro'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "flexPro", void 0);
    __decorate([
        core_1.ViewChild('flexPayruleNoteDetail'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "flexFutureFunding", void 0);
    __decorate([
        core_1.ViewChild('flexdealfunding'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "flexdealfunding", void 0);
    __decorate([
        core_1.ViewChild('flexNoteSequence'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "flexNoteSequence", void 0);
    __decorate([
        core_1.ViewChild('grdSequenceData'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "grdSequenceData", void 0);
    __decorate([
        core_1.ViewChild('flexDynamicColForSequence'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "grdflexDynamicColForSequence", void 0);
    __decorate([
        core_1.ViewChild('flexDynamicColForNotePayruleSetup'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "grdflexDynamicColForNotePayruleSetup", void 0);
    __decorate([
        core_1.ViewChild('flexNoteCashflowsExportDataList'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "flexNoteCashflowsExportDataList", void 0);
    __decorate([
        core_1.ViewChild('flexCopy'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "flexCopy", void 0);
    __decorate([
        core_1.ViewChild('flexDocument'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "flexDocument", void 0);
    __decorate([
        core_1.ViewChild('flexRules'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "flexRules", void 0);
    __decorate([
        core_1.ViewChild('flexautospreadrule'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "flexautospreadrule", void 0);
    __decorate([
        core_1.ViewChild('flexNoteListForDealAmort'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "flexNoteListForDealAmort", void 0);
    __decorate([
        core_1.ViewChild('flexDealAmortizationSchedule'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "flexDealAmortizationSchedule", void 0);
    __decorate([
        core_1.ViewChild('flexDealForAdjustedTotalCommitment'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "flexadjustedtotalcommitment", void 0);
    __decorate([
        core_1.ViewChild('iframePayoff'),
        __metadata("design:type", core_1.ElementRef)
    ], DealDetailComponent.prototype, "iframePayoff", void 0);
    __decorate([
        core_1.ViewChild('iframePayoffData'),
        __metadata("design:type", core_1.ElementRef)
    ], DealDetailComponent.prototype, "iframePayoffData", void 0);
    __decorate([
        core_1.ViewChild('grdPeriodicData'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "grdPeriodicData", void 0);
    __decorate([
        core_1.ViewChild('prepayadjustment'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "prepayadjustment", void 0);
    __decorate([
        core_1.ViewChild('SpreadMaintenance'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "SpreadMaintenance", void 0);
    __decorate([
        core_1.ViewChild('MinimumMult'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "MinimumMult", void 0);
    __decorate([
        core_1.ViewChild('MinimumFee'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "MinimumFee", void 0);
    __decorate([
        core_1.ViewChild('RuleTypeList'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "RuleTypeList", void 0);
    __decorate([
        core_1.ViewChild('PrepayPremium'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "PrepayPremium", void 0);
    __decorate([
        core_1.ViewChild('Equitygrid'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "Equitygrid", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", Number)
    ], DealDetailComponent.prototype, "projectId", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", Number)
    ], DealDetailComponent.prototype, "sectionId", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", String)
    ], DealDetailComponent.prototype, "fileExt", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", Number)
    ], DealDetailComponent.prototype, "maxFiles", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", Number)
    ], DealDetailComponent.prototype, "maxSize", void 0);
    __decorate([
        core_1.Output(),
        __metadata("design:type", Object)
    ], DealDetailComponent.prototype, "uploadStatus", void 0);
    __decorate([
        core_1.ViewChild('flexautospreadrepayment'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "flexautospreadrepayments", void 0);
    __decorate([
        core_1.ViewChild('flexFeeInvoice'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "flexFeeInvoice", void 0);
    __decorate([
        core_1.ViewChild('flexMaturity'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "flexMaturity", void 0);
    __decorate([
        core_1.ViewChild('flexReserveSchedule'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "flexReserveSchedule", void 0);
    __decorate([
        core_1.ViewChild('flexReserveAccounts'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "flexReserveAccounts", void 0);
    __decorate([
        core_1.ViewChild('flexMaturityConfig'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], DealDetailComponent.prototype, "flexMaturityConfig", void 0);
    __decorate([
        core_1.HostListener('document:mouseover', ['$event']),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Object]),
        __metadata("design:returntype", void 0)
    ], DealDetailComponent.prototype, "mouseover", null);
    DealDetailComponent = __decorate([
        core_1.Component({
            selector: "dealdetail",
            templateUrl: "app/components/dealdetail.html?v=" + $.getVersion(),
            //templateUrl: "app/components/dealdetail.html",
            providers: [dealservice_1.dealService, notificationservice_1.NotificationService, noteservice_1.NoteService, propertyservice_1.propertyService, app_component_1.AppComponent, fileuploadservice_1.FileUploadService, membershipservice_1.MembershipService, functionService_1.functionService, permissionService_1.PermissionService, feeconfigurationService_1.feeconfigurationService, scenarioService_1.scenarioService, dataservice_1.DataService, WFService_1.WFService, loggingService_1.LoggingService],
        }),
        __metadata("design:paramtypes", [ng2_file_input_1.Ng2FileInputService,
            fileuploadservice_1.FileUploadService,
            dealservice_1.dealService,
            dataservice_1.DataService,
            noteservice_1.NoteService,
            propertyservice_1.propertyService,
            notificationservice_1.NotificationService,
            router_1.Router,
            router_1.ActivatedRoute,
            utilityService_1.UtilityService,
            common_1.Location,
            signalRService_1.SignalRService,
            app_component_1.AppComponent,
            loggingService_1.LoggingService,
            membershipservice_1.MembershipService,
            functionService_1.functionService,
            permissionService_1.PermissionService,
            feeconfigurationService_1.feeconfigurationService,
            scenarioService_1.scenarioService,
            platform_browser_1.DomSanitizer,
            http_1.Http,
            WFService_1.WFService])
    ], DealDetailComponent);
    return DealDetailComponent;
}(paginated_1.Paginated));
exports.DealDetailComponent = DealDetailComponent;
var routes = [
    { path: '', component: DealDetailComponent }
];
var DealDetailModule = /** @class */ (function () {
    function DealDetailModule() {
    }
    DealDetailModule = __decorate([
        core_1.NgModule({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_1.RouterModule.forChild(routes), wijmo_angular2_core_1.WjCoreModule, wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_input_1.WjInputModule, wijmo_angular2_grid_filter_1.WjGridFilterModule, wijmo_angular2_grid_detail_1.WjGridDetailModule, ng2_file_input_1.Ng2FileInputModule.forRoot()],
            declarations: [DealDetailComponent],
        })
    ], DealDetailModule);
    return DealDetailModule;
}());
exports.DealDetailModule = DealDetailModule;
//# sourceMappingURL=dealdetail.component.js.map