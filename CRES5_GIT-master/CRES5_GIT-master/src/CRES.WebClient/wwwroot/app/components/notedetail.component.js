"use strict";
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (Object.prototype.hasOwnProperty.call(b, p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        if (typeof b !== "function" && b !== null)
            throw new TypeError("Class extends value " + String(b) + " is not a constructor or null");
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
exports.NoteDetailModule = exports.NoteDetailComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var Note_1 = require("../core/domain/Note");
var noteDateObjects_1 = require("../core/domain/noteDateObjects");
var noteService_1 = require("../core/services/noteService");
var utilityService_1 = require("../core/services/utilityService");
var membershipservice_1 = require("../core/services/membershipservice");
var search_1 = require("../core/domain/search");
var searchService_1 = require("../core/services/searchService");
var NoteAdditionalList_1 = require("../core/domain/NoteAdditionalList");
var NoteAdditionalListObject_1 = require("../core/domain/NoteAdditionalListObject");
var paginated_1 = require("../core/common/paginated");
var wjcCore = require("wijmo/wijmo");
var wjcGrid = require("wijmo/wijmo.grid");
var wjNg2Input = require("wijmo/wijmo.angular2.input");
var wjcInput = require("wijmo/wijmo.input");
var noteCashflowsExportDataList_1 = require("../core/domain/noteCashflowsExportDataList");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_input_1 = require("wijmo/wijmo.angular2.input");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var userdefaultsetting_1 = require("../core/domain/userdefaultsetting");
var signalRService_1 = require("./../Notification/signalRService");
var appsettings_1 = require("../core/common/appsettings");
var Module_1 = require("../core/domain/Module");
var dealservice_1 = require("../core/services/dealservice");
var ActivityLog_1 = require("../core/domain/ActivityLog");
var document_1 = require("../core/domain/document");
var fileuploadservice_1 = require("../core/services/fileuploadservice");
var ng2_file_input_1 = require("ng2-file-input");
var functionService_1 = require("../core/services/functionService");
var scenarioService_1 = require("../core/services/scenarioService");
var Scenario_1 = require("../core/domain/Scenario");
var devdashboard_1 = require("./../core/domain/devdashboard");
var CalculationManagerService_1 = require("../core/services/CalculationManagerService");
var NoteDetailComponent = /** @class */ (function (_super) {
    __extends(NoteDetailComponent, _super);
    function NoteDetailComponent(activatedRoute, ng2FileInputService, fileUploadService, noteService, dealSrv, utilityService, searchService, membershipservice, _signalRService, calculationsvc, 
    //private changeref: ChangeDetectorRef,
    //private appref:ApplicationRef,
    _router, functionServiceSrv, scenarioService) {
        var _this = _super.call(this, 10, 1, 0) || this;
        _this.activatedRoute = activatedRoute;
        _this.ng2FileInputService = ng2FileInputService;
        _this.fileUploadService = fileUploadService;
        _this.noteService = noteService;
        _this.dealSrv = dealSrv;
        _this.utilityService = utilityService;
        _this.searchService = searchService;
        _this.membershipservice = membershipservice;
        _this._signalRService = _signalRService;
        _this.calculationsvc = calculationsvc;
        _this._router = _router;
        _this.functionServiceSrv = functionServiceSrv;
        _this.scenarioService = scenarioService;
        _this.lstnotesexceptions = [];
        _this._ExceptionListCount = 1;
        _this._CritialExceptionListCount = 1;
        _this._ShowmessagedivWarnote = false;
        _this._ShowmessagenotedivWar = false;
        _this._Showmessagenotediv = false;
        _this._isShowFuturefunding = false;
        _this._isReadOnlyRuleTypeName = true;
        _this._isShowAccounting = false;
        _this._isShowClosing = false;
        _this._isShowFinancing = false;
        _this._isShowSettlement = false;
        _this._isShowServicing = false;
        _this._isShowServicelog = false;
        _this._isShowPiksource = false;
        _this._isShowFeecoupon = false;
        _this._isShowLibor = false;
        _this._isShowFixedamort = false;
        _this._isShowPeriodicoutput = false;
        _this._isshowsavenote = false;
        _this._isShowCopynote = false;
        _this._isShowCalcbutton = true;
        _this._norecordfound = true;
        _this._isShowServicingDropDate = false;
        _this._isShowScenariodiv = false;
        _this._isShowRuleTypediv = false;
        _this._isShowbtnResetdiv = false;
        _this._liborindexMsg = true;
        _this._showliborgride = false;
        _this.lstFundingDeletedSchedule = [];
        _this._showexceptionEmptymessage = false;
        // private _showexceptionEmptydiv: boolean = false;
        _this._isShowDownloadCashflows = false;
        _this._errorMsgDateValidation = "";
        _this.exceptionscount_normal = 0;
        _this.exceptionscount_critical = 0;
        _this._isExceptionscount = false;
        _this._isShowActivityLog = false;
        _this._showamortcheck = false;
        _this._showgaapcheck = false;
        _this._isShowNoteRules = false;
        _this._isRuleTabClicked = false;
        _this._lstgetallrule = [];
        _this._lstruletypedetail = [];
        _this._lstRuleTypeSetupNew = [];
        _this._lstRuleTypeSetuptobesend = [];
        _this._lstRuleTypeSetupfilter = [];
        _this.calcExceptionMsg = "Error occurred";
        _this._isSearchDataFetching = false;
        _this._pageSizeSearch = 10;
        _this._pageIndexSearch = 1;
        _this._totalCountSearch = 0;
        _this._dvEmptySearchMsg = false;
        _this.initialised = 0;
        _this._pageSizeActivity = 50;
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
        _this.rssupdatedRowNo = [];
        _this.rssrowsToUpdate = [];
        _this.prepayrowsToUpdate = [];
        _this.prepayupdatedRowNo = [];
        _this.strippingrowsToUpdate = [];
        _this.strippingupdatedRowNo = [];
        _this.financingfeeupdatedRowNo = [];
        _this.financingfeerowsToUpdate = [];
        _this.flexfinancingschupdatedRowNo = [];
        _this.flexfinancingschrowsToUpdate = [];
        _this.flexdefaultschupdatedRowNo = [];
        _this.flexdefaultschrowsToUpdate = [];
        _this.flexfuturefundingupdatedRowNo = [];
        _this.flexfuturefundingrowsToUpdate = [];
        _this.flexPikupdatedRowNo = [];
        _this.flexPikrowsToUpdate = [];
        _this.flexLiborupdatedRowNo = [];
        _this.flexLiborrowsToUpdate = [];
        _this.flexFixedAmortupdatedRowNo = [];
        _this.flexFixedAmortrowsToUpdate = [];
        _this.flexfeecouponUpdatedRowNo = [];
        _this.flexfeecouponrowsToUpdate = [];
        _this.flexservicelogupdatedRowNo = [];
        _this.flexservicelogupdatedrow_num = [];
        _this.flexservicelogToUpdate = [];
        _this.PIKrowsToUpdate = [];
        _this.maturityupdatedrow = [];
        _this.pikupdatedrow = [];
        _this.ShowHideFlagMaturity = false;
        _this.ShowHideFlagBalanceTransactionSchedule = false;
        _this.ShowHideFlagDefaultSchedule = false;
        _this.ShowHideFlagFeeCouponSchedule = false;
        _this.ShowHideFlagFinancingFeeSchedule = false;
        _this.ShowHideFlagFinancingSchedule = false;
        _this.ShowHideFlagPIKSchedule = false;
        _this.ShowHideFlagPrepayAndAdditionalFeeSchedule = false;
        _this.ShowHideFlagRateSpreadSchedule = false;
        _this.ShowHideFlagServicingFeeSchedule = false;
        _this.ShowHideFlagStrippingSchedule = false;
        _this.ShowHideFlagFutureFunding = false;
        _this.ShowHideFlagLiborSchedule = false;
        _this.ShowFlagHideFixedAmortSchedule = false;
        _this.ShowHideFlagPIKfromPIKSourceNote = false;
        _this.ShowHideFlagFeeCouponStripReceivable = false;
        _this.isSaveOnly = false;
        _this._islastCalcDateTime = true;
        _this._Showmessagedivrule = false;
        _this._ShowmessagedivruleMsg = '';
        _this.strActivity = '';
        _this._isPeriodicDataFetched = true;
        _this._isCalcDataFetched = false;
        _this._isCalcJsonFetched = false;
        _this._isCalcJsonResponseFetched = false;
        _this._isCashFlowClicked = false;
        _this._dvEmptyPeriodicDataMsg = false;
        _this._isSetHeaderEmpty = false;
        _this.IsOpenClosingTab = false;
        _this.IsOpenFinancingTab = false;
        _this.IsOpenExceptionTab = false;
        _this.IsOpenServicingTab = false;
        _this.IsOpenServicinglogTab = false;
        _this.IsOpenshowpikflex = false;
        _this.IsOpenshowfeecouponflex = false;
        _this.IsOpenshowlaborflex = false;
        _this.IsOpenshowfixedamortflex = false;
        _this.IsOpenshowfuturefundingflex = false;
        _this.IsOpenshowperiodicoutputflex = false;
        _this.IsOpenshownoteoutputnpvflex = false;
        _this.IsOpenActivityTab = false;
        _this.IsOpenServicingDropDateTab = false;
        _this._isNoteSaving = false;
        _this._isSuperAdminUser = false;
        _this._disabled = true;
        _this._noteExistMsg = '';
        _this._noteCopyMsg = null;
        _this._dealNoExistMsg = '';
        _this._isCopyonly = false;
        _this._copymessagediv = false;
        _this._copymessagedivMsg = '';
        _this._isCopyandopen = false;
        _this.Copy_Dealid = '';
        _this.Copy_DealName = '';
        _this._dealIndex = -1;
        _this._isNoteSaveonly = false;
        _this._isConvertDate = false;
        _this._isConvertGridDate = false;
        _this._isShowMsgForUseRuletoDetermine = false;
        _this.ModifyCalcValue = 123;
        _this.ModifyComment = "test";
        _this._isDeleteOPtionOk = false;
        _this.deleteoptiontext = "";
        _this._isCallConcurrentCheck = false;
        _this.isProcessComplete = false;
        _this.errors = [];
        _this.fileExt = "JPG, JPEG, PNG, XLS, XLSX, CSV, PDF, DOC, DOCX";
        _this.maxFiles = 5;
        _this.maxSize = 5; // 15MB
        _this.uploadStatus = new core_1.EventEmitter();
        _this.myFileInputIdentifier = "tHiS_Id_IS_sPeeCiAL";
        _this._pageSizeDocImport = 30;
        _this._pageIndexDocImport = 1;
        _this._totalCountDocImport = 0;
        _this.isScrollHandlerAdded = false;
        _this._dvEmptyDocumentMsg = false;
        _this.IsOpenDocImportTab = false;
        _this._isShowDocImport = false;
        _this.actionLog = "";
        _this._isvalidateHolidaySatSun = true;
        _this.IsActive = false;
        _this._ClckservicelogRow = -1;
        _this._ClckservicelogCol = -1;
        _this.listtransactioncategory = [];
        _this.listtransactiongroup = [];
        _this.changedlstmarketnote = [];
        _this.originallstnotemarketprice = [];
        _this.listtransactionname = [];
        _this.listtransactions = [];
        _this.deleteMarketPriceList = [];
        _this.ServicingLog_refreshlist = [];
        _this.NoteCommitmentList = [];
        _this._isNotecommitmentlst = false;
        _this.holidayCalendarNamelist = [];
        _this.maturityList = [];
        _this.maturityTypeList = [];
        _this.lstMaturity = [];
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
        _this._isnoteperiodiccalcFetching = false;
        _this._isnoteperiodiccalcFetched = false;
        _this._isTransactionEntryFetched = true;
        _this._dvEmptynoteperiodiccalcMsg = false;
        _this._divbatchuploadtext = false;
        _this._isnoteoutputNPVFetching = false;
        _this._isnoteoutputNPVFetched = true;
        _this._dvEmptyoutputNPVMsg = false;
        _this._cache = {};
        _this.getAutosuggestpikaccount = _this.getAutosuggestpikFunc.bind(_this);
        //ChangedDeal(sender: wjNg2Input.WjAutoComplete, args) {
        //    var ac = sender;
        //    this.Copy_Dealid = ac.selectedValue;
        //    this.Copy_DealName = ac.text
        //}
        _this._cachedeal = {};
        _this.getAutosuggestDeal = _this.getAutosuggestDealFunc.bind(_this);
        _this._scenariodc = new Scenario_1.Scenario('');
        _this._lstScenario = _this._scenariodc.LstScenarioUserMap;
        _this._note = new Note_1.Note('');
        _this._noteDateObjects = new noteDateObjects_1.NoteDateObjects();
        _this._noteext = new NoteAdditionalList_1.NoteAdditionalList();
        _this._devDashBoard = new devdashboard_1.devDashBoard('');
        _this._noteextt = new NoteAdditionalListObject_1.NoteAdditionalListObject();
        _this._validationobject = new NoteAdditionalList_1.NoteAdditionalList();
        _this._noteArchieveext = new NoteAdditionalList_1.NoteAdditionalList();
        _this._noteArchieveextt = new NoteAdditionalListObject_1.NoteAdditionalListObject();
        _this._moduledelete = new Module_1.Module('');
        _this._activityLog = new ActivityLog_1.ActivityLog('');
        _this._ruletype = new Scenario_1.RuleType;
        _this._moduledelete.LookupID = 0;
        _this.getAllDistinctScenario();
        _this.subscribetoevent();
        _this.rolename = window.localStorage.getItem("rolename");
        //this.ScenarioId = window.localStorage.getItem("scenarioid");
        _this.ScenarioId = window.localStorage.getItem("DefaultScenarioID");
        _this._noteCashflowsExportDataList = new noteCashflowsExportDataList_1.NoteCashflowsExportDataList();
        _this.activatedRoute.params.forEach(function (params) {
            if (params['id'] !== undefined) {
                _this._note.NoteId = params['id'];
            }
        });
        _this._user = JSON.parse(localStorage.getItem('user'));
        _this._userdefaultsetting = new userdefaultsetting_1.userdefaultsetting(_this._user.UserID, '', '');
        _this.fetchNote();
        //this.RateSpreadScheduleList=null;
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
        //this._centralOffset = this._dtUTCHours * 60 * 60 * 1000; // 6 for central time - use whatever you need
        // this.OnChanges();
        _this._document = new document_1.Document();
        _this._document.DocumentTypeID = "406";
        _this.getAllClient();
        _this.getAllFund();
        _this.GetLookupForMaster();
        _this.getFeeTypesFromFeeSchedulesConfig();
        //manish
        _this.GetFinancingSource();
        _this.getDealMaturitybyID();
        return _this;
        //    setTimeout(() => {
        //       this.GetTransactionCategory();
        //  }, 8000);
    }
    NoteDetailComponent.prototype._buildDataMapWithoutLookupForRuleType = function (items) {
        var map = [];
        for (var i = 0; i < items.length; i++) {
            var obj = items[i];
            map.push({ key: obj['FileName'], value: obj['FileName'] });
        }
        return new wjcGrid.DataMap(map, 'key', 'value');
    };
    NoteDetailComponent.prototype.invalidateRulestab = function () {
        if (!this._isRuleTabClicked) {
            localStorage.setItem('ClickedTabId', 'aRulestab');
            this._isRuleTabClicked = true;
        }
        if (this._note.BalanceAware == true) {
            this._isShowScenariodiv = false;
            this._isShowRuleTypediv = false;
            this._isShowbtnResetdiv = false;
            this._Showmessagedivrule = true;
            this._ShowmessagedivruleMsg = "This note belongs to the deal which is set as Balance Aware Deal. To edit the rules, uncheck the balance aware checkbox on deal's Main Tab and save the deal.";
        }
        else {
            this._isShowScenariodiv = true;
            this._isShowRuleTypediv = true;
            this._isShowbtnResetdiv = true;
            this._Showmessagedivrule = false;
            this._ShowmessagedivruleMsg = "";
        }
        this.getAllDistinctScenario();
        this.getAllRuleType();
        this.GetAllRuleTypeDetail();
        this.GetRuleTypeSetupByDealid();
    };
    NoteDetailComponent.prototype.getAllRuleType = function () {
        var _this = this;
        this.scenarioService.getallruletype().subscribe(function (res) {
            if (res.Succeeded) {
                _this._lstruletype = res.lstScenariorule;
                _this._lstgetallrule = res.lstScenariorule;
            }
        });
    };
    NoteDetailComponent.prototype.GetAllRuleTypeDetail = function () {
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
    NoteDetailComponent.prototype.GetRuleTypeSetupByDealid = function () {
        var _this = this;
        this._ruletype.NoteID = this._note.NoteId;
        this.noteService.getruletypesetupbynoteid(this._ruletype).subscribe(function (res) {
            if (res.Succeeded) {
                _this._lstRuleTypeSetupfilter = res.lstScenariorule;
                _this.OnChangeScenarioName(_this._ruletype.AnalysisID);
            }
        });
    };
    NoteDetailComponent.prototype.celleditRuleType = function (s, e) {
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
    NoteDetailComponent.prototype.OnChangeScenarioName = function (newvalue) {
        var _this = this;
        this._lstruletype = [];
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
                        'NoteID': this._note.NoteId,
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
                            'NoteID': this._note.NoteId,
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
    NoteDetailComponent.prototype.ResetRuleType = function () {
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
                        'NoteID': this._note.NoteId,
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
    NoteDetailComponent.prototype.AddUpdateNoteRuleTypeSetup = function () {
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
                    'NoteID': this._lstRuleTypeSetuptobesend[h].NoteID,
                    'RuleTypeMasterID': this._lstRuleTypeSetuptobesend[h].RuleTypeMasterID,
                    'RuleTypeDetailID': RuleTypeDetailID,
                });
            }
        }
        this.noteService.addupdatenoteruletypesetup(this._lstRuleTypeSetupNew).subscribe(function (res) {
            if (res.Succeeded) {
            }
        });
    };
    NoteDetailComponent.prototype.getAllDistinctScenario = function () {
        var _this = this;
        var _userData = JSON.parse(localStorage.getItem('user'));
        this._scenariodc.UserID = _userData.UserID;
        this.scenarioService.getAllScenarioDistinct(this._scenariodc).subscribe(function (res) {
            if (res.Succeeded) {
                if (res.lstScenarioUserMap.length > 0) {
                    _this._lstScenario = res.lstScenarioUserMap;
                    _this.ScenarioId = res.lstScenarioUserMap.filter(function (x) { return x.ScenarioName == "Default"; })[0].AnalysisID;
                    _this.ScenarioName = res.lstScenarioUserMap.filter(function (x) { return x.ScenarioName == "Default"; })[0].ScenarioName;
                    _this._scenariodc.AnalysisID = _this.ScenarioId;
                    _this._note.AnalysisID = _this.ScenarioId;
                }
            }
        });
    };
    NoteDetailComponent.prototype.changeScenario = function (value) {
        this.SelectedScenarioId = value;
        this.ScenarioName = this._lstScenario.filter(function (x) { return x.AnalysisID == value; })[0].ScenarioName;
        this.showperiodicoutputflex(this.IsbtnClickText);
    };
    NoteDetailComponent.prototype.changeCouponScenario = function (value) {
        this.SelectedCouponScenarioId = value;
        this.getFeeCouponStripReceivableDataByNoteId();
    };
    NoteDetailComponent.prototype.ChangeFundingappied = function (ScheduleID, _value, flexGridrw) {
        if (_value == true) {
            if (this._noteext.ListFutureFundingScheduleTab[flexGridrw.index].Date == undefined) {
                this.futurefundingflex.rows[flexGridrw.index].Applied = false;
                this.futurefundingflex.invalidate();
                this.CustomAlert("Date can not be blank.");
                return;
            }
            if (this._noteext.ListFutureFundingScheduleTab.length > 1) {
                var minDate = new Date(Math.min.apply(null, this._noteext.ListFutureFundingScheduleTab.filter(function (x) { return x.Applied == false; }).map(function (x) { return x.Date; })));
                if (minDate.toJSON()) {
                    var wcDate = new Date(flexGridrw.dataItem.Date);
                    if (wcDate.toString() != minDate.toString()) {
                        this.futurefundingflex.rows[flexGridrw.index].Applied = false;
                        this.futurefundingflex.invalidate();
                        //  this.CustomAlert("Before confirming " + minDate.toLocaleDateString("en-US") + " record .Other date is not allowed to confirm.")
                        this.CustomAlert("You can't confirm wire on a later date without confirming all wires in between.");
                        return;
                    }
                    else {
                        var today = new Date();
                        var nextbdate = this.getnexybusinessDate(today, 5);
                        if (wcDate > nextbdate) {
                            flexGridrw.dataItem.Applied = false;
                            this.futurefundingflex.invalidate();
                            this.CustomAlert("You can only confirm up to " + this.convertDateToBindable(nextbdate) + ".");
                            return;
                        }
                    }
                }
            }
        }
        else {
            var maxDate = new Date(Math.max.apply(null, this._noteext.ListFutureFundingScheduleTab.filter(function (x) { return x.Applied == true; }).map(function (x) { return x.Date; })));
            if (maxDate.toJSON()) {
                var wcDate = new Date(flexGridrw.dataItem.Date);
                if (wcDate.toString() != maxDate.toString()) {
                    this.futurefundingflex.rows[flexGridrw.index].Applied = true;
                    this.futurefundingflex.invalidate();
                    //  this.CustomAlert("Before unchecking " + maxDate.toLocaleDateString("en-US") + " record .Other date is not allowed to uncheck.")
                    this.CustomAlert("You can't remove a wire confirmation on an earlier date without removing the wire confirmation on later dates.");
                    return;
                }
            }
        }
        if (this.rolename != 'Super Admin') {
            if (_value == true) {
                flexGridrw.isReadOnly = true;
                flexGridrw.cssClass = "customgridrowcolor";
                flexGridrw.dataItem.Applied = true;
            }
            if (_value == false) {
                flexGridrw.isReadOnly = false;
                flexGridrw.dataItem.Applied = false;
                flexGridrw.cssClass = "customgridrowcolornotapplied";
            }
        }
        else {
            if (_value == true) {
                flexGridrw.isReadOnly = true;
                flexGridrw.dataItem.Applied = true;
                flexGridrw.cssClass = "customgridrowcolor";
            }
            if (_value == false) {
                {
                    flexGridrw.isReadOnly = false;
                    flexGridrw.dataItem.Applied = false;
                    flexGridrw.cssClass = "customgridrowcolornotapplied";
                }
            }
        }
        if (ScheduleID) {
            this._noteext.ListFutureFundingScheduleTab.find(function (x) { return x.ScheduleID == ScheduleID; }).Applied = _value;
        }
    };
    //For remove the Leave Page dialog
    NoteDetailComponent.prototype.beforeunloadHandler = function ($event) {
        if (this.initialised > 1) {
            $event.returnValue = "Are you sure?";
        }
    };
    // Component views are initialized
    NoteDetailComponent.prototype.ngAfterViewInit = function () {
        this._isPeriodicDataFetched = true;
        this._isCalcDataFetched = false;
        this._isCalcJsonFetched = false;
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
        }.bind(this), 3000);
        // this.OnChanges();
    };
    NoteDetailComponent.prototype.FormatDate = function (_note, locale) {
        var options = { year: "numeric", month: "numeric", day: "numeric" };
        if (this._note.StartDate != null) {
            this._note.StartDate = new Date(this._note.StartDate.toString());
        }
        if (this._note.EndDate != null) {
            this._note.EndDate = new Date(this._note.EndDate.toString());
        }
        if (this._note.InitialInterestAccrualEndDate != null) {
            this._note.InitialInterestAccrualEndDate = new Date(this._note.InitialInterestAccrualEndDate.toString());
        }
        if (this._note.FirstPaymentDate != null) {
            this._note.FirstPaymentDate = new Date(this._note.FirstPaymentDate.toString());
        }
        if (this._note.InitialMonthEndPMTDateBiWeekly != null) {
            this._note.InitialMonthEndPMTDateBiWeekly = new Date(this._note.InitialMonthEndPMTDateBiWeekly.toString());
        }
        if (this._note.FinalInterestAccrualEndDateOverride != null) {
            this._note.FinalInterestAccrualEndDateOverride = new Date(this._note.FinalInterestAccrualEndDateOverride.toString());
        }
        if (this._note.FirstRateIndexResetDate != null) {
            this._note.FirstRateIndexResetDate = new Date(this._note.FirstRateIndexResetDate.toString());
        }
        //if (this._note.SelectedMaturityDate != null) { this._note.SelectedMaturityDate = new Date(this._note.SelectedMaturityDate.toString()); }
        //if (this._note.InitialMaturityDate != null) { this._note.InitialMaturityDate = new Date(this._note.InitialMaturityDate.toString()); }
        if (this._note.ExpectedMaturityDate != null) {
            this._note.ExpectedMaturityDate = new Date(this._note.ExpectedMaturityDate.toString());
        }
        // if (this._note.FullyExtendedMaturityDate != null) { this._note.FullyExtendedMaturityDate = new Date(this._note.FullyExtendedMaturityDate.toString()); }
        if (this._note.OpenPrepaymentDate != null) {
            this._note.OpenPrepaymentDate = new Date(this._note.OpenPrepaymentDate.toString());
        }
        if (this._note.FinancingInitialMaturityDate != null) {
            this._note.FinancingInitialMaturityDate = new Date(this._note.FinancingInitialMaturityDate.toString());
        }
        if (this._note.FinancingExtendedMaturityDate != null) {
            this._note.FinancingExtendedMaturityDate = new Date(this._note.FinancingExtendedMaturityDate.toString());
        }
        if (this._note.ClosingDate != null) {
            this._note.ClosingDate = new Date(this._note.ClosingDate.toString());
        }
        //if (this._note.ExtendedMaturityScenario1 != null) { this._note.ExtendedMaturityScenario1 = new Date(this._note.ExtendedMaturityScenario1.toString()); }
        // if (this._note.ExtendedMaturityScenario2 != null) { this._note.ExtendedMaturityScenario2 = new Date(this._note.ExtendedMaturityScenario2.toString()); }
        // if (this._note.ExtendedMaturityScenario3 != null) { this._note.ExtendedMaturityScenario3 = new Date(this._note.ExtendedMaturityScenario3.toString()); }
        if (this._note.ActualPayoffDate != null) {
            this._note.ActualPayoffDate = new Date(this._note.ActualPayoffDate.toString());
        }
        if (this._note.PurchaseDate != null) {
            this._note.PurchaseDate = new Date(this._note.PurchaseDate.toString());
        }
        if (this._note.ValuationDate != null) {
            this._note.ValuationDate = new Date(this._note.ValuationDate.toString());
        }
        if (this._note.lastCalcDateTime != null) {
            this._note.lastCalcDateTime = new Date(this._note.lastCalcDateTime.toString());
        }
        if (this._note.NoteTransferDate != null) {
            this._note.NoteTransferDate = new Date(this._note.NoteTransferDate.toString());
        }
    };
    NoteDetailComponent.prototype.getNotePeriodicCalcByNoteId = function (_note) {
        var _this = this;
        if (this.ScenarioId === undefined || this.ScenarioId === null) {
            this.ScenarioId = this._lstScenario.find(function (x) { return x.ScenarioName == "Default"; }).AnalysisID;
        }
        _note.AnalysisID = this.ScenarioId;
        this._note.CalculationStatus = "";
        this._isnoteperiodiccalcFetching = true;
        this.noteService.getNotePeriodicCalcByNoteId(_note, this._pageIndex, this._pageSize).subscribe(function (res) {
            if (res.Succeeded) {
                _this._noteext.lstnotePeriodicOutputs = res.lstnotePeriodicOutputs;
                if (res.lstnotePeriodicOutputs[0] != null) {
                    _this._note.lastCalcDateTime = res.lstnotePeriodicOutputs[0].UpdatedDate;
                    _this._note.CalculationStatus = res.lstnotePeriodicOutputs[0].CalculationStatus;
                }
                else {
                    _this._note.CalculationStatus = "";
                }
                _this.ConvertToBindableDate(_this._noteext.lstnotePeriodicOutputs, "NotePeriodicCalc", "en-US");
                _this._isNoteSaving = false;
                setTimeout(function () {
                    this.flexnoteperiodiccalc.autoSizeColumns(0, this.flexnoteperiodiccalc.columns.length - 1, false, 20);
                    this._isnoteperiodiccalcFetching = false;
                    //this.grdCalcData.invalidate();
                }.bind(_this), 5000);
            }
            else {
                setTimeout(function () {
                    this._norecordfound = false;
                    this._noteext.lstnotePeriodicOutputs = null;
                    this._isnoteperiodiccalcFetching = false;
                    this._isnoteperiodiccalcFetched = false;
                    this.ShowEmptyGridText();
                }.bind(_this), 1000);
            }
            (function (error) { return console.error('Error: ' + error); });
        });
    };
    NoteDetailComponent.prototype.ShowEmptyGridText = function () {
        //4==N
        if (this.EnableM61Calculations == 4) {
            this._divbatchuploadtext = false;
            this.EmptynoteperiodiccalcMsgString = "This note is set to calculate No for M61 calculations. Please upload transaction using batch upload tool.";
        }
        else {
            this.EmptynoteperiodiccalcMsgString = "There are no transactions for this scenario. Please calculate the note with this scenario or choose a different scenario.";
        }
        this._dvEmptynoteperiodiccalcMsg = true;
    };
    NoteDetailComponent.prototype.getTransactionEntryByNoteId = function (_note) {
        var _this = this;
        if (this.ScenarioId === undefined || this.ScenarioId === null) {
            this.ScenarioId = this._lstScenario.find(function (x) { return x.ScenarioName == "Default"; }).AnalysisID;
        }
        _note.AnalysisID = this.ScenarioId;
        this._note.AnalysisID = this.ScenarioId;
        this._isnoteperiodiccalcFetching = true;
        this.noteService.getTransactionEntryByNoteId(_note).subscribe(function (res) {
            if (res.Succeeded) {
                _this._norecordfound = true;
                _this.lstTransactionEntry = res.lstTransactionEntry;
                if (_this.lstTransactionEntry.length > 0) {
                    for (var i = 0; i < _this.lstTransactionEntry.length; i++) {
                        _this.lstTransactionEntry[i].Date = new Date(_this.lstTransactionEntry[i].Date.toString());
                        if (_this.lstTransactionEntry[i].TransactionDateByRule) {
                            _this.lstTransactionEntry[i].TransactionDateByRule = new Date(_this.lstTransactionEntry[i].TransactionDateByRule.toString());
                        }
                        if (_this.lstTransactionEntry[i].DueDate) {
                            _this.lstTransactionEntry[i].DueDate = new Date(_this.lstTransactionEntry[i].DueDate.toString());
                        }
                        if (_this.lstTransactionEntry[i].RemitDate) {
                            _this.lstTransactionEntry[i].RemitDate = new Date(_this.lstTransactionEntry[i].RemitDate.toString());
                        }
                    }
                }
                _this._isNoteSaving = false;
                _this._dvEmptynoteperiodiccalcMsg = false;
                setTimeout(function () {
                    if (this.flexTransactionEntry) {
                        this.flexTransactionEntry.autoSizeColumns(0, this.flexTransactionEntry.columns.length - 1, false, 20);
                        this.flexTransactionEntry.invalidate();
                    }
                    this._isnoteperiodiccalcFetching = false;
                }.bind(_this), 2000);
            }
            else {
                setTimeout(function () {
                    this._isNoteSaving = false;
                    this._norecordfound = false;
                    this._isTransactionEntryFetched = false;
                    this._isnoteperiodiccalcFetching = false;
                    this.ShowEmptyGridText();
                }.bind(_this), 1000);
            }
            (function (error) { return console.error('Error: ' + error); });
        });
        (function (error) {
            setTimeout(function () {
                this._norecordfound = false;
                this._isTransactionEntryFetched = false;
                this._isnoteperiodiccalcFetching = false;
                this.ShowEmptyGridText();
                this._isNoteSaving = false;
            }.bind(_this), 1000);
        });
    };
    NoteDetailComponent.prototype.ShowPeriodicOutput = function () {
        this._dvEmptynoteperiodiccalcMsg = false;
        this.ScenarioId = this.SelectedScenarioId;
        this.IsbtnClickText = "ShowPeriodicGrid";
        this._isnoteperiodiccalcFetching = true;
        this.getNotePeriodicCalcByNoteId(this._note);
        this._isTransactionEntryFetched = false;
    };
    NoteDetailComponent.prototype.ShowTransaction = function () {
        this._dvEmptynoteperiodiccalcMsg = false;
        this.IsbtnClickText = "ShowTransactionGrid";
        this.ScenarioId = this.SelectedScenarioId;
        this._isnoteperiodiccalcFetching = false;
        this._isTransactionEntryFetched = true;
        this.getTransactionEntryByNoteId(this._note);
    };
    NoteDetailComponent.prototype.getNoteOutputNPVdataByNoteId = function (_note) {
        var _this = this;
        this._isnoteoutputNPVFetching = true;
        this.noteService.getNoteOutputNPVdataByNoteId(_note, this._pageIndex, this._pageSize).subscribe(function (res) {
            if (res.Succeeded) {
                _this._isnoteoutputNPVFetching = false;
                _this._noteext.lstOutputNPVdata = res.lstOutputNPVdata;
            }
            else {
                _this._noteext.lstOutputNPVdata = null;
                _this._isnoteoutputNPVFetching = false;
                _this._dvEmptyoutputNPVMsg = true;
                _this._isnoteoutputNPVFetched = false;
            }
            (function (error) { return console.error('Error: ' + error); });
        });
    };
    NoteDetailComponent.prototype.fetchNote = function () {
        var _this = this;
        this._isNoteSaving = true;
        this._disabled = false;
        this.HideAllTabs();
        this._note.AnalysisID = this.ScenarioId;
        this.noteService.getNoteByNoteID(this._note).subscribe(function (res) {
            if (res.Succeeded) {
                if (res.StatusCode == 404) {
                    localStorage.setItem('divWarNote', JSON.stringify(true));
                    // localStorage.setItem('divWarMsgNote', JSON.stringify(true));
                    localStorage.setItem('divWarMsgNote', JSON.stringify('Note not exists in our system.'));
                    _this._router.navigate(['note']);
                }
                else {
                    if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                        _this.getAllfinancingWarehouse();
                        _this._note = res.NoteData;
                        var notecommitmentdata = res.dtNoteCommitment;
                        //to fetch note market price
                        var data = res.dt;
                        if (data) {
                            _this._note.ListNoteMarketPrice = data;
                            _this.ConvertToBindableDate(_this._note.ListNoteMarketPrice, "NoteMarketPrice", "en-US");
                            if (data.length > 0) {
                                for (var m = 0; m < data.length; m++) {
                                    _this.originallstnotemarketprice.push({ "NoteID": data[m].NoteID, "Date": data[m].Date, "Value": data[m].Value });
                                }
                                setTimeout(function () {
                                    _this.ListNoteMarketPrice = new wjcCore.CollectionView(_this._note.ListNoteMarketPrice);
                                    _this.ListNoteMarketPrice.trackChanges = true;
                                    _this.flexmarketprice.invalidate();
                                }, 1000);
                            }
                            else {
                                _this._note.ListNoteMarketPrice = [];
                                _this.ListNoteMarketPrice = new wjcCore.CollectionView(_this._note.ListNoteMarketPrice);
                                _this.ListNoteMarketPrice.trackChanges = true;
                            }
                        }
                        //end
                        // to fetch notecommitments
                        if (notecommitmentdata) {
                            _this._isNotecommitmentlst = true;
                            _this.NoteCommitmentList = notecommitmentdata;
                            _this.ConvertToBindableDate(_this.NoteCommitmentList, "NoteCommitment", "en-US");
                            if (notecommitmentdata.length > 0) {
                                var lastrownumber = _this.NoteCommitmentList.length - 1;
                                if (notecommitmentdata[lastrownumber].BaseCurrencyName == "USD") {
                                    _this._basecurrencyname = '$';
                                }
                                else {
                                    _this._basecurrencyname = '£';
                                }
                                setTimeout(function () {
                                    _this.NoteCommitmentList = new wjcCore.CollectionView(_this.NoteCommitmentList);
                                    _this.NoteCommitmentList.trackChanges = true;
                                    _this.flexnotecommitments.invalidate();
                                    if (_this.flexnotecommitments.rows[lastrownumber].dataItem.NoteAggregatedTotalCommitment != null || _this.flexnotecommitments.rows[lastrownumber].dataItem.NoteTotalCommitment != null || _this.flexnotecommitments.rows[lastrownumber].dataItem.NoteAdjustedTotalCommitment != null) {
                                        _this._totalcommitmenttextboxvalue = _this.formatNumberforTwoDecimalplaces(_this.flexnotecommitments.rows[lastrownumber].dataItem.NoteTotalCommitment);
                                        _this._aggregatedcommitmenttexboxtvalue = _this.formatNumberforTwoDecimalplaces(_this.flexnotecommitments.rows[lastrownumber].dataItem.NoteAggregatedTotalCommitment);
                                        _this._adjustedcommitmenttextboxvalue = _this.formatNumberforTwoDecimalplaces(_this.flexnotecommitments.rows[lastrownumber].dataItem.NoteAdjustedTotalCommitment);
                                    }
                                }, 1000);
                            }
                            else {
                                _this._isNotecommitmentlst = false;
                                _this._ShowNotecommitmentmsg = "No data to show please save total commitment from deal detail page.";
                            }
                        }
                        //end notecommitments
                        _this.gParentNoteid = _this._note.NoteId;
                        _this.EnableM61Calculations = res.NoteData.EnableM61Calculations;
                        //show eff date count on View History Button
                        _this.ShowCountOnViewHistoryBtn();
                        _this.utilityService.setPageTitle("M61 " + _this._note.CRENoteID + " " + _this._note.Name);
                        _this.getNoteexceptions(_this._note.NoteId);
                        if (_this._note.lastCalcDateTime == null) {
                            _this._islastCalcDateTime = false;
                        }
                        _this.FormatDate(_this._note, "en-US");
                        if (_this._note.PayFrequency == null || _this._note.PayFrequency == 0) {
                            _this._note.PayFrequency = 1;
                        }
                        else {
                            _this._note.PayFrequency = _this._note.PayFrequency;
                        }
                        _this.getTransactionTypes();
                        _this.getHolidayMaster();
                        // this.CalculateAggregateTotal();
                        _this.GetAllNoteLookups();
                        _this._dvEmptySearchMsg = false;
                        _this.GetHolidayList();
                        setTimeout(function () {
                            _this._dvEmptySearchMsg = false;
                            _this._noteext.NoteId = _this._note.NoteId;
                            _this.fetchNoteAdditinallist();
                            _this._isNoteSaving = false;
                            //  this.showindexgrid();                            
                            if (localStorage.getItem('divSucessNote') == 'true') {
                                _this._Showmessagenotediv = true;
                                _this._ShowmessagenotedivMsg = localStorage.getItem('divSucessMsgNote');
                                _this._ShowmessagenotedivMsg = (_this._ShowmessagenotedivMsg.replace('\"', '')).replace('\"', '');
                                localStorage.setItem('divSucessNote', JSON.stringify(false));
                                localStorage.setItem('divSucessMsgNote', JSON.stringify(''));
                                setTimeout(function () {
                                    this._Showmessagenotediv = false;
                                }.bind(_this), 5000);
                            }
                            if (localStorage.getItem('divInfoNote') == 'true') {
                                _this._Showmessagenotediv = true;
                                _this._ShowmessagenotedivMsg = localStorage.getItem('divInfoMsgNote');
                                if (_this._ShowmessagenotedivMsg != "") {
                                    _this._ShowmessagenotedivMsg = (_this._ShowmessagenotedivMsg.replace('\"', '')).replace('\"', '');
                                }
                                localStorage.setItem('divInfoNote', JSON.stringify(false));
                                localStorage.setItem('divInfoMsgNote', JSON.stringify(''));
                                setTimeout(function () {
                                    this._Showmessagenotediv = false;
                                }.bind(_this), 5000);
                            }
                        }, 1000);
                        _this.setFocus();
                        _this.ApplyPermissions(res.UserPermissionList);
                        // this.AppliedReadOnly();
                        _this.GetUserTimezoneByID();
                        if (_this.EnableM61Calculations == 4) {
                            _this._isShowCalcbutton = false;
                            _this._divbatchuploadtext = true;
                        }
                    }
                    else {
                        localStorage.setItem('divWarNote', JSON.stringify(true));
                        localStorage.setItem('divWarMsgNote', JSON.stringify('Sorry, you do not have permissions to access this page'));
                        _this._router.navigate(['note']);
                    }
                }
            }
            else {
                _this.utilityService.navigateToSignIn();
                _this._isNoteSaving = false;
            }
            // this.ConvertToBindableDate(this._note);
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    NoteDetailComponent.prototype.ConvertToBindableDate = function (Data, modulename, locale) {
        if (Data) {
            var options = { year: "numeric", month: "numeric", day: "numeric" };
            switch (modulename) {
                case "Maturity":
                    break;
                case "BalanceTransactionSchedule":
                    break;
                case "DefaultSchedule":
                    if (this._noteext.NoteDefaultScheduleList) {
                    }
                    if (this._noteext.NoteDefaultScheduleList.length > 0) {
                        for (var i = 0; i < Data.length; i++) {
                            if (this._noteext.NoteDefaultScheduleList[i].StartDate != null) {
                                this._noteext.NoteDefaultScheduleList[i].StartDate = new Date(Data[i].StartDate.toString());
                            }
                            if (this._noteext.NoteDefaultScheduleList[i].EndDate != null) {
                                this._noteext.NoteDefaultScheduleList[i].EndDate = new Date(Data[i].EndDate.toString());
                            }
                        }
                    }
                    break;
                case "FeeCouponSchedule":
                    break;
                case "FinancingFeeSchedule":
                    if (this._noteext.lstFinancingFeeSchedule.length > 0) {
                        for (var i = 0; i < Data.length; i++) {
                            if (this._noteext.lstFinancingFeeSchedule[i].Date != null) {
                                this._noteext.lstFinancingFeeSchedule[i].Date = new Date(Data[i].Date.toString());
                            }
                        }
                    }
                    break;
                case "FinancingSchedule":
                    if (this._noteext.NoteFinancingScheduleList.length > 0) {
                        for (var i = 0; i < Data.length; i++) {
                            if (this._noteext.NoteFinancingScheduleList[i].Date != null) {
                                this._noteext.NoteFinancingScheduleList[i].Date = new Date(Data[i].Date.toString());
                            }
                        }
                    }
                    break;
                case "PIKSchedule":
                    break;
                case "PrepayAndAdditionalFeeSchedule":
                    if (this._noteext.NotePrepayAndAdditionalFeeScheduleList.length > 0) {
                        for (var i = 0; i < Data.length; i++) {
                            if (this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].StartDate != null) {
                                this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].StartDate = new Date(Data[i].StartDate.toString());
                            }
                            if (this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ScheduleEndDate != null) {
                                this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ScheduleEndDate = new Date(Data[i].ScheduleEndDate.toString());
                            }
                        }
                    }
                    break;
                case "RateSpreadSchedule":
                    if (this._noteext.RateSpreadScheduleList.length > 0) {
                        for (var i = 0; i < Data.length; i++) {
                            if (this._noteext.RateSpreadScheduleList[i].Date != null) {
                                this._noteext.RateSpreadScheduleList[i].Date = new Date(Data[i].Date.toString());
                            }
                        }
                    }
                    break;
                case "ServicingFeeSchedule":
                    break;
                case "StrippingSchedule":
                    if (this._noteext.NoteStrippingList.length > 0) {
                        for (var i = 0; i < Data.length; i++) {
                            if (this._noteext.NoteStrippingList[i].StartDate != null) {
                                this._noteext.NoteStrippingList[i].StartDate = new Date(Data[i].StartDate.toString());
                            }
                        }
                    }
                    break;
                case "FundingSchedule":
                    if (this._noteext.ListFutureFundingScheduleTab.length > 0) {
                        for (var i = 0; i < Data.length; i++) {
                            if (this._noteext.ListFutureFundingScheduleTab[i].Date != null) {
                                this._noteext.ListFutureFundingScheduleTab[i].Date = new Date(Data[i].Date.toString());
                            }
                            if (this._noteext.ListFutureFundingScheduleTab[i].orgDate != null) {
                                this._noteext.ListFutureFundingScheduleTab[i].orgDate = new Date(Data[i].orgDate.toString());
                            }
                        }
                    }
                    break;
                case "PIKScheduleDetail":
                    if (this._noteext.ListPIKfromPIKSourceNoteTab.length > 0) {
                        for (var i = 0; i < Data.length; i++) {
                            if (this._noteext.ListPIKfromPIKSourceNoteTab[i].Date != null) {
                                this._noteext.ListPIKfromPIKSourceNoteTab[i].Date = new Date(Data[i].Date.toString());
                            }
                        }
                    }
                    break;
                case "LIBORSchedule":
                    if (this._noteext.ListLiborScheduleTab.length > 0) {
                        for (var i = 0; i < Data.length; i++) {
                            if (this._noteext.ListLiborScheduleTab[i].Date != null) {
                                this._noteext.ListLiborScheduleTab[i].Date = new Date(Data[i].Date.toString());
                            }
                        }
                    }
                    break;
                case "AmortSchedule":
                    if (this._noteext.ListFixedAmortScheduleTab.length > 0) {
                        for (var i = 0; i < Data.length; i++) {
                            if (this._noteext.ListFixedAmortScheduleTab[i].Date != null) {
                                this._noteext.ListFixedAmortScheduleTab[i].Date = new Date(Data[i].Date.toString());
                            }
                        }
                    }
                    break;
                case "FeeCouponStripReceivable":
                    if (this._noteext.ListFeeCouponStripReceivable.length > 0) {
                        for (var i = 0; i < Data.length; i++) {
                            if (this._noteext.ListFeeCouponStripReceivable[i].Date != null) {
                                this._noteext.ListFeeCouponStripReceivable[i].Date = new Date(Data[i].Date.toString());
                            }
                        }
                    }
                    break;
                case "Servicinglog":
                    if (this._noteext.lstNoteServicingLog.length > 0) {
                        for (var i = 0; i < Data.length; i++) {
                            if (this._noteext.lstNoteServicingLog[i].TransactionDate != null) {
                                this._noteext.lstNoteServicingLog[i].TransactionDate = new Date(Data[i].TransactionDate.toString());
                            }
                            if (this._noteext.lstNoteServicingLog[i].RelatedtoModeledPMTDate != null) {
                                this._noteext.lstNoteServicingLog[i].RelatedtoModeledPMTDate = new Date(Data[i].RelatedtoModeledPMTDate.toString());
                            }
                            if (this._noteext.lstNoteServicingLog[i].RemittanceDate != null) {
                                this._noteext.lstNoteServicingLog[i].RemittanceDate = this.convertDatetoGMT(this._noteext.lstNoteServicingLog[i].RemittanceDate);
                            }
                        }
                    }
                    break;
                case "NotePeriodicCalc":
                    if (this._noteext.lstnotePeriodicOutputs.length > 0) {
                        for (var i = 0; i < Data.length; i++) {
                            if (this._noteext.lstnotePeriodicOutputs[i].PeriodEndDate != null) {
                                this._noteext.lstnotePeriodicOutputs[i].PeriodEndDate = new Date(Data[i].PeriodEndDate.toString());
                            }
                            if (this._noteext.lstnotePeriodicOutputs[i].CreatedDate != null) {
                                this._noteext.lstnotePeriodicOutputs[i].CreatedDate = new Date(Data[i].CreatedDate.toString());
                            }
                            if (this._noteext.lstnotePeriodicOutputs[i].UpdatedDate != null) {
                                this._noteext.lstnotePeriodicOutputs[i].UpdatedDate = new Date(Data[i].UpdatedDate.toString());
                            }
                        }
                    }
                    break;
                case "NoteOutputNPV":
                    if (this._noteext.lstOutputNPVdata.length > 0) {
                        for (var i = 0; i < Data.length; i++) {
                            if (this._noteext.lstOutputNPVdata[i].NPVdate != null) {
                                this._noteext.lstOutputNPVdata[i].NPVdate = new Date(Data[i].NPVdate.toString());
                            }
                            if (this._noteext.lstnotePeriodicOutputs[i].CreatedDate != null) {
                                this._noteext.lstnotePeriodicOutputs[i].CreatedDate = new Date(Data[i].CreatedDate.toString());
                            }
                            if (this._noteext.lstnotePeriodicOutputs[i].UpdatedDate != null) {
                                this._noteext.lstnotePeriodicOutputs[i].UpdatedDate = new Date(Data[i].UpdatedDate.toString());
                            }
                        }
                    }
                    break;
                case "Calculator":
                    if (this.lstPeriodicDataList.length > 0) {
                        for (var i = 0; i < Data.length; i++) {
                            if (this.lstPeriodicDataList[i].PeriodEndDate != null) {
                                this.lstPeriodicDataList[i].PeriodEndDate = new Date(Data[i].PeriodEndDate.toString());
                            }
                            if (this.lstPeriodicDataList[i].CreatedDate != null) {
                                this.lstPeriodicDataList[i].CreatedDate = new Date(Data[i].CreatedDate.toString());
                            }
                            if (this.lstPeriodicDataList[i].UpdatedDate != null) {
                                this.lstPeriodicDataList[i].UpdatedDate = new Date(Data[i].UpdatedDate.toString());
                            }
                        }
                    }
                case "ServicinglogDropDate":
                    if (this._noteext.lstServicerDropDateSetup.length > 0) {
                        for (var i = 0; i < Data.length; i++) {
                            if (this._noteext.lstServicerDropDateSetup[i].ModeledPMTDropDate != null) {
                                this._noteext.lstServicerDropDateSetup[i].ModeledPMTDropDate = new Date(Data[i].ModeledPMTDropDate.toString());
                            }
                            if (this._noteext.lstServicerDropDateSetup[i].PMTDropDateOverride != null) {
                                this._noteext.lstServicerDropDateSetup[i].PMTDropDateOverride = new Date(Data[i].PMTDropDateOverride.toString());
                            }
                        }
                    }
                    break;
                case "NoteMarketPrice":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._note.ListNoteMarketPrice[i].Date != null) {
                            this._note.ListNoteMarketPrice[i].Date = new Date(this._note.ListNoteMarketPrice[i].Date.toString());
                        }
                    }
                    break;
                case "NoteCommitment":
                    for (var i = 0; i < Data.length; i++) {
                        if (this.NoteCommitmentList[i].Date != null) {
                            this.NoteCommitmentList[i].Date = new Date(this.NoteCommitmentList[i].Date.toString());
                        }
                    }
                    break;
                default:
                    break;
            }
        }
    };
    NoteDetailComponent.prototype.getAllScheduleLatestDataByNoteId = function () {
        var _this = this;
        var pageIndex = 1;
        var pageSize = 10;
        this.noteService.getAllScheduleLatestDataByNoteId(this._note, pageIndex, pageSize).subscribe(function (res) {
            if (res.Succeeded) {
                _this.FutureFundingEffactiveDate = res.NoteAllScheduleLatestRecord.FutureFundingEffactiveDate;
                _this.LiborScheduleEffactiveDate = res.NoteAllScheduleLatestRecord.LiborScheduleEffactiveDate;
                _this.FixedAmortScheduleEffactiveDate = res.NoteAllScheduleLatestRecord.FixedAmortScheduleEffactiveDate;
                _this.PIKfromPIKSourceNoteEffactiveDate = res.NoteAllScheduleLatestRecord.PIKfromPIKSourceNoteEffactiveDate;
                _this.FeeCouponStripReceivableEffactiveDate = res.NoteAllScheduleLatestRecord.FeeCouponStripReceivableEffactiveDate;
                if (_this.FutureFundingEffactiveDate != null) {
                    //this.FutureFundingEffactiveDate = new Date(this.FutureFundingEffactiveDate.toString().replace('T00', 'T17')).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                    _this.FutureFundingEffactiveDate = new Date(_this.FutureFundingEffactiveDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                }
                if (_this.LiborScheduleEffactiveDate != null) {
                    _this.LiborScheduleEffactiveDate = new Date(_this.LiborScheduleEffactiveDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                }
                if (_this.FixedAmortScheduleEffactiveDate != null) {
                    _this.FixedAmortScheduleEffactiveDate = new Date(_this.FixedAmortScheduleEffactiveDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                }
                if (_this.PIKfromPIKSourceNoteEffactiveDate != null) {
                    _this.PIKfromPIKSourceNoteEffactiveDate = new Date(_this.PIKfromPIKSourceNoteEffactiveDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                }
                if (_this.FeeCouponStripReceivableEffactiveDate != null) {
                    _this.FeeCouponStripReceivableEffactiveDate = new Date(_this.FeeCouponStripReceivableEffactiveDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                }
                _this._noteext.ListFutureFundingScheduleTab = res.NoteAllScheduleLatestRecord.ListFutureFundingScheduleTab;
                _this._noteext.ListFixedAmortScheduleTab = res.NoteAllScheduleLatestRecord.ListFixedAmortScheduleTab;
                _this._noteext.ListLiborScheduleTab = res.NoteAllScheduleLatestRecord.ListLiborScheduleTab;
                _this._noteext.ListPIKfromPIKSourceNoteTab = res.NoteAllScheduleLatestRecord.ListPIKfromPIKSourceNoteTab;
                _this._noteext.ListFeeCouponStripReceivable = res.NoteAllScheduleLatestRecord.ListFeeCouponStripReceivable;
                _this.ConvertToBindableDate(_this._noteext.ListFutureFundingScheduleTab, "FundingSchedule", "en-US");
                _this.ConvertToBindableDate(_this._noteext.ListPIKfromPIKSourceNoteTab, "PIKScheduleDetail", "en-US");
                _this.ConvertToBindableDate(_this._noteext.ListLiborScheduleTab, "LIBORSchedule", "en-US");
                _this.ConvertToBindableDate(_this._noteext.ListFixedAmortScheduleTab, "AmortSchedule", "en-US");
                _this.ConvertToBindableDate(_this._noteext.ListFeeCouponStripReceivable, "FeeCouponStripReceivable", "en-US");
                setTimeout(function () {
                    this.AppliedReadOnly();
                }.bind(_this), 500);
                _this.ShowButton();
            }
            else {
                _this.ShowButton();
            }
        });
        (function (error) {
            _this._disabled = true; //show save btn after load
            console.error('Error: ' + error);
        });
    };
    NoteDetailComponent.prototype.getFeeCouponStripReceivableDataByNoteId = function () {
        var _this = this;
        var pageIndex = 1;
        var pageSize = 10;
        var newNoteObj = this._note;
        newNoteObj.AnalysisID = this.SelectedCouponScenarioId;
        this.noteService.getFeeCouponStripReceivableDataByNoteId(this._note, pageIndex, pageSize).subscribe(function (res) {
            if (res.Succeeded) {
                _this._noteext.ListFeeCouponStripReceivable = res.NoteAllScheduleLatestRecord.ListFeeCouponStripReceivable;
                _this.ConvertToBindableDate(_this._noteext.ListFeeCouponStripReceivable, "FeeCouponStripReceivable", "en-US");
                setTimeout(function () {
                    this.AppliedReadOnly();
                    this.feecouponflex.invalidate();
                }.bind(_this), 500);
                _this.ShowButton();
            }
            else {
                _this.ShowButton();
            }
        });
        (function (error) {
            _this._disabled = true; //show save btn after load
            console.error('Error: ' + error);
        });
    };
    NoteDetailComponent.prototype.fetchNoteAdditinallist = function () {
        var _this = this;
        var l_noteid = this._noteext.NoteId;
        this.noteService.getNoteAdditinalListByNoteID(this._noteext).subscribe(function (res) {
            if (res.Succeeded) {
                _this._noteext = res.NoteAdditinalList;
                _this._noteext.NoteId = l_noteid;
                _this.fnotes.valueChanges.subscribe(function (val) {
                    //  alert('changed ' + this.initialised);
                    _this.initialised += 1;
                });
                if (_this._noteext.MaturityScenariosList != null) {
                    if (_this._noteext.MaturityScenariosList[0].EffectiveDate != null)
                        _this.MaturityEffectiveDate = _this._noteext.MaturityScenariosList[0].EffectiveDate;
                    if (_this._noteext.MaturityScenariosList[0].Date != null)
                        _this.MaturityDate = _this._noteext.MaturityScenariosList[0].Date;
                    if (_this.MaturityEffectiveDate != null) {
                        _this.MaturityEffectiveDate = new Date(_this.MaturityEffectiveDate.toString());
                    }
                    if (_this.MaturityDate != null) {
                        _this.MaturityDate = new Date(_this.MaturityDate.toString());
                    }
                }
                if (_this._noteext.NoteServicingFeeScheduleList != null) {
                    if (_this._noteext.NoteServicingFeeScheduleList[0].EffectiveDate != null) {
                        _this.Servicing_EffectiveDate = new Date(_this._noteext.NoteServicingFeeScheduleList[0].EffectiveDate.toString());
                    }
                    if (_this._noteext.NoteServicingFeeScheduleList[0].Date != null) {
                        _this.Servicing_Date = new Date(_this._noteext.NoteServicingFeeScheduleList[0].Date.toString());
                    }
                    _this.Servicing_Value = _this._noteext.NoteServicingFeeScheduleList[0].Value;
                    _this.Servicing_IsCapitalized = _this._noteext.NoteServicingFeeScheduleList[0].IsCapitalized;
                }
                if (_this._noteext.NotePIKScheduleList != null) {
                    if (_this._noteext.NotePIKScheduleList[0].EffectiveDate != null) {
                        _this.PIKSchedule_EffectiveDate = new Date(_this._noteext.NotePIKScheduleList[0].EffectiveDate.toString());
                    }
                    if (_this._noteext.NotePIKScheduleList[0].StartDate != null) {
                        _this.PIKSchedule_StartDate = new Date(_this._noteext.NotePIKScheduleList[0].StartDate.toString());
                    }
                    if (_this._noteext.NotePIKScheduleList[0].EndDate != null) {
                        _this.PIKSchedule_EndDate = new Date(_this._noteext.NotePIKScheduleList[0].EndDate.toString());
                    }
                    _this.PIKSchedule_SourceAccountID = _this._noteext.NotePIKScheduleList[0].SourceAccountID;
                    _this.PIKSchedule_SourceAccount = _this._noteext.NotePIKScheduleList[0].SourceAccount;
                    _this.PIKSchedule_TargetAccountID = _this._noteext.NotePIKScheduleList[0].TargetAccountID;
                    _this.PIKSchedule_TargetAccount = _this._noteext.NotePIKScheduleList[0].TargetAccount;
                    _this.PIKSchedule_AdditionalIntRate = _this._noteext.NotePIKScheduleList[0].AdditionalIntRate;
                    _this.PIKSchedule_AdditionalSpread = _this._noteext.NotePIKScheduleList[0].AdditionalSpread;
                    _this.PIKSchedule_IndexFloor = _this._noteext.NotePIKScheduleList[0].IndexFloor;
                    _this.PIKSchedule_IntCompoundingRate = _this._noteext.NotePIKScheduleList[0].IntCompoundingRate;
                    _this.PIKSchedule_IntCompoundingSpread = _this._noteext.NotePIKScheduleList[0].IntCompoundingSpread;
                    _this.PIKSchedule_IntCapAmt = _this._noteext.NotePIKScheduleList[0].IntCapAmt;
                    _this.PIKSchedule_PurBal = _this._noteext.NotePIKScheduleList[0].PurBal;
                    _this.PIKSchedule_AccCapBal = _this._noteext.NotePIKScheduleList[0].AccCapBal;
                    _this.PIKSchedule_PIKReasonCodeIDText = _this._noteext.NotePIKScheduleList[0].PIKReasonCodeIDText;
                    _this.PIKSchedule_PIKReasonCodeID = _this._noteext.NotePIKScheduleList[0].PIKReasonCodeID;
                    _this.PIKSchedule_PIKIntCalcMethodIDText = _this._noteext.NotePIKScheduleList[0].PIKIntCalcMethodIDText;
                    _this.PIKSchedule_PIKIntCalcMethodID = _this._noteext.NotePIKScheduleList[0].PIKIntCalcMethodID;
                    _this.PIKSchedule_PIKComments = _this._noteext.NotePIKScheduleList[0].PIKComments;
                    if (_this.PIKSchedule_EffectiveDate != null) {
                        _this.PIKSchedule_EffectiveDate = new Date(_this.PIKSchedule_EffectiveDate.toString());
                    }
                    if (_this.PIKSchedule_StartDate != null) {
                        _this.PIKSchedule_StartDate = new Date(_this.PIKSchedule_StartDate.toString());
                    }
                    if (_this.PIKSchedule_EndDate != null) {
                        _this.PIKSchedule_EndDate = new Date(_this.PIKSchedule_EndDate.toString());
                    }
                }
                _this.ConvertToBindableDate(_this._noteext.RateSpreadScheduleList, "RateSpreadSchedule", "en-US");
                _this.ConvertToBindableDate(_this._noteext.NotePrepayAndAdditionalFeeScheduleList, "PrepayAndAdditionalFeeSchedule", "en-US");
                _this.ConvertToBindableDate(_this._noteext.NoteStrippingList, "StrippingSchedule", "en-US");
                _this.ConvertToBindableDate(_this._noteext.lstFinancingFeeSchedule, "FinancingFeeSchedule", "en-US");
                _this.ConvertToBindableDate(_this._noteext.NoteFinancingScheduleList, "FinancingSchedule", "en-US");
                _this.ConvertToBindableDate(_this._noteext.lstNoteServicingLog, "Servicinglog", "en-US");
                _this.ConvertToBindableDate(_this._noteext.lstServicerDropDateSetup, "ServicinglogDropDate", "en-US");
                _this.ServicingLog_refreshlist = _this._noteext.lstNoteServicingLog;
                if (_this._noteext.lstNoteServicingLog) {
                    _this.GetTransactionCategory();
                }
                if (_this._noteext.RateSpreadScheduleList != null && _this._noteext.RateSpreadScheduleList.length > 0) {
                    if (_this._noteext.RateSpreadScheduleList[0].EffectiveDate != null) {
                        _this.Ratespread_EffectiveDate = new Date(_this._noteext.RateSpreadScheduleList[0].EffectiveDate.toString());
                    }
                    _this.cvRateSpreadScheduleList = new wjcCore.CollectionView(_this._noteext.RateSpreadScheduleList);
                    _this.cvRateSpreadScheduleList.trackChanges = true;
                }
                else {
                    _this._noteext.RateSpreadScheduleList = [];
                    _this.cvRateSpreadScheduleList = new wjcCore.CollectionView(_this._noteext.RateSpreadScheduleList);
                    _this.cvRateSpreadScheduleList.trackChanges = true;
                }
                if (_this._noteext.NotePrepayAndAdditionalFeeScheduleList != null && _this._noteext.NotePrepayAndAdditionalFeeScheduleList.length > 0) {
                    if (_this._noteext.NotePrepayAndAdditionalFeeScheduleList[0].EffectiveDate != null) {
                        _this.PrepayAndAdditionalFeeSchedule_EffectiveDate = new Date(_this._noteext.NotePrepayAndAdditionalFeeScheduleList[0].EffectiveDate.toString());
                    }
                    _this.cvNotePrepayAndAdditionalFeeScheduleList = new wjcCore.CollectionView(_this._noteext.NotePrepayAndAdditionalFeeScheduleList);
                    _this.cvNotePrepayAndAdditionalFeeScheduleList.trackChanges = true;
                }
                else {
                    _this._noteext.NotePrepayAndAdditionalFeeScheduleList = [];
                    _this.cvNotePrepayAndAdditionalFeeScheduleList = new wjcCore.CollectionView(_this._noteext.NotePrepayAndAdditionalFeeScheduleList);
                    _this.cvNotePrepayAndAdditionalFeeScheduleList.trackChanges = true;
                }
                if (_this._noteext.NoteStrippingList != null && _this._noteext.NoteStrippingList.length > 0) {
                    if (_this._noteext.NoteStrippingList[0].EffectiveDate != null) {
                        _this.StrippingSchedule_EffectiveDate = new Date(_this._noteext.NoteStrippingList[0].EffectiveDate.toString());
                    }
                    _this.cvNoteStrippingList = new wjcCore.CollectionView(_this._noteext.NoteStrippingList);
                    _this.cvNoteStrippingList.trackChanges = true;
                }
                else {
                    _this._noteext.NoteStrippingList = [];
                    _this.cvNoteStrippingList = new wjcCore.CollectionView(_this._noteext.NoteStrippingList);
                    _this.cvNoteStrippingList.trackChanges = true;
                }
                if (_this._noteext.lstFinancingFeeSchedule) {
                    if (_this._noteext.lstFinancingFeeSchedule[0].EffectiveDate != null) {
                        _this.FinancingFeeSchedule_EffectiveDate = new Date(_this._noteext.lstFinancingFeeSchedule[0].EffectiveDate.toString());
                    }
                }
                if (_this._noteext.NoteFinancingScheduleList) {
                    if (_this._noteext.NoteFinancingScheduleList[0].EffectiveDate != null) {
                        _this.FinancingSchedule_EffectiveDate = new Date(_this._noteext.NoteFinancingScheduleList[0].EffectiveDate.toString());
                    }
                }
                if (_this._noteext.NoteDefaultScheduleList) {
                    if (_this._noteext.NoteDefaultScheduleList[0].EffectiveDate != null) {
                        _this.DefaultSchedule_EffectiveDate = new Date(_this._noteext.NoteDefaultScheduleList[0].EffectiveDate.toString());
                    }
                }
                if (_this._noteext.lstServicerDropDateSetup) {
                    _this.cvNoteServicerDropDateSetup = new wjcCore.CollectionView(_this._noteext.lstServicerDropDateSetup);
                    _this.cvNoteServicerDropDateSetup.trackChanges = true;
                }
                else {
                    _this._noteext.lstServicerDropDateSetup = [];
                    _this.cvNoteServicerDropDateSetup = new wjcCore.CollectionView(_this._noteext.lstServicerDropDateSetup);
                    _this.cvNoteServicerDropDateSetup.trackChanges = true;
                }
                _this.getAllScheduleLatestDataByNoteId();
                _this.futurefundingflex.isReadOnly = true;
                if (_this._note.UseRuletoDetermineNoteFundingText != null) {
                    if (_this._note.UseRuletoDetermineNoteFundingText.toLowerCase() == "y" || _this._note.UseRuletoDetermineNoteFundingText.toLowerCase() == "n") {
                        _this._isShowMsgForUseRuletoDetermine = true;
                        _this.MsgForUseRuletoDetermine = "The funding schedule for this note is based on deal funding payrules. You need to edit the funding schedule from Deal Funding screen .";
                        // prevent default editing
                        // this.futurefundingflex.isReadOnly = true;
                    }
                    else {
                        _this._isShowMsgForUseRuletoDetermine = false;
                        _this.MsgForUseRuletoDetermine = "";
                        // prevent default editing                      
                        //  this.futurefundingflex.isReadOnly = false;
                    }
                }
                if (_this.Ratespread_EffectiveDate != null) {
                    _this.Ratespread_EffectiveDateOld = _this.Ratespread_EffectiveDate;
                }
                if (_this.PrepayAndAdditionalFeeSchedule_EffectiveDate != null) {
                    _this.PrepayAndAdditionalFeeSchedule_EffectiveDateOld = _this.PrepayAndAdditionalFeeSchedule_EffectiveDate;
                }
                if (_this.StrippingSchedule_EffectiveDate != null) {
                    _this.StrippingSchedule_EffectiveDateOld = _this.StrippingSchedule_EffectiveDate;
                }
                if (_this.FinancingFeeSchedule_EffectiveDate != null) {
                    _this.FinancingFeeSchedule_EffectiveDateOld = _this.FinancingFeeSchedule_EffectiveDate;
                }
                if (_this.FinancingSchedule_EffectiveDate != null) {
                    _this.FinancingSchedule_EffectiveDateOld = _this.FinancingSchedule_EffectiveDate;
                }
                if (_this.DefaultSchedule_EffectiveDate != null) {
                    _this.DefaultSchedule_EffectiveDateOld = _this.DefaultSchedule_EffectiveDate;
                }
                if (_this.PIKSchedule_EffectiveDate != null) {
                    _this.PIKSchedule_EffectiveDateOld = _this.PIKSchedule_EffectiveDate;
                }
                //this.ShowButton();
            }
            else {
                _this.utilityService.navigateToSignIn();
            }
        });
        (function (error) {
            console.error('Error: ' + error);
        });
    };
    NoteDetailComponent.prototype.ServicingLogReadOnly = function () {
        if (this._noteext.lstNoteServicingLog) {
            for (var i = 0; i <= (this._noteext.lstNoteServicingLog.length - 1); i++) {
                if (this.flexservicelog.rows[i]) {
                    if (this.flexservicelog.rows[i].dataItem.Calculated == 3 && this.flexservicelog.rows[i].dataItem.AllowCalculationOverride == 4) {
                        if (this.flexservicelog.rows[i]) {
                            this.flexservicelog.rows[i].isReadOnly = true;
                            this.flexservicelog.rows[i].cssClass = "customgridrowcolor";
                        }
                    }
                    if (this.flexservicelog.rows[i].dataItem.Calculated == 3 && this.flexservicelog.rows[i].dataItem.AllowCalculationOverride == 3) {
                        if (this.flexservicelog.rows[i]) {
                            this.flexservicelog.rows[i].isReadOnly = true;
                            this.flexservicelog.rows[i].cssClass = "customgridrowcolor";
                        }
                    }
                    if (this.flexservicelog.rows[i].dataItem.Calculated == 4) {
                        if (this.flexservicelog.rows[i].dataItem.ServicerMasterID == 5 || this.flexservicelog.rows[i].dataItem.ServicerMasterID == 6 || this.flexservicelog.rows[i].dataItem.ServicerMasterID == 7) {
                            if (this.flexservicelog.rows[i]) {
                                this.flexservicelog.rows[i].isReadOnly = false;
                                this.flexservicelog.rows[i].cssClass = "customgridrowcolornotapplied";
                            }
                        }
                    }
                    if (this.flexservicelog.rows[i].dataItem.ServicerMasterID != 5 && this.flexservicelog.rows[i].dataItem.ServicerMasterID != 6 && this.flexservicelog.rows[i].dataItem.ServicerMasterID != 7) {
                        if (this.flexservicelog.rows[i]) {
                            this.flexservicelog.rows[i].isReadOnly = true;
                            this.flexservicelog.rows[i].cssClass = "customgridrowcolor";
                        }
                    }
                }
            }
        }
        this.flexservicelog.invalidate();
    };
    NoteDetailComponent.prototype.ShowButton = function () {
        this._disabled = true; //show save btn after load         
        if (this._noteext.ListFutureFundingScheduleTab != null) {
            if (this._noteext.ListFutureFundingScheduleTab.length > 0)
                this.ShowHideFlagFutureFunding = true;
        }
        if (this.LiborScheduleEffactiveDate != null)
            this.ShowHideFlagLiborSchedule = true;
        if (this.FixedAmortScheduleEffactiveDate != null)
            this.ShowFlagHideFixedAmortSchedule = true;
        if (this.PIKfromPIKSourceNoteEffactiveDate != null)
            this.ShowHideFlagPIKfromPIKSourceNote = true;
        if (this.FeeCouponStripReceivableEffactiveDate != null)
            this.ShowHideFlagFeeCouponStripReceivable = true;
        if (this.MaturityEffectiveDate != null)
            this.ShowHideFlagMaturity = true;
        if (this._noteext.NoteDefaultScheduleList != null)
            this.ShowHideFlagDefaultSchedule = true;
        if (this._noteext.lstFinancingFeeSchedule != null)
            this.ShowHideFlagFinancingFeeSchedule = true;
        if (this._noteext.NoteFinancingScheduleList != null)
            this.ShowHideFlagFinancingSchedule = true;
        if (this._noteext.NotePrepayAndAdditionalFeeScheduleList != null)
            this.ShowHideFlagPrepayAndAdditionalFeeSchedule = true;
        if (this._noteext.RateSpreadScheduleList != null)
            this.ShowHideFlagRateSpreadSchedule = true;
        if (this.Servicing_EffectiveDate != null)
            this.ShowHideFlagServicingFeeSchedule = true;
        if (this._noteext.NoteStrippingList != null)
            this.ShowHideFlagStrippingSchedule = true;
        if (this._noteext.NotePIKScheduleList != null)
            this.ShowHideFlagPIKSchedule = true;
    };
    NoteDetailComponent.prototype.SaveNote = function (objNote) {
        //  alert('txthiddenID');
        //  document.getElementById("txthiddenID").focus();
        // this._note.SelectedMaturityDate = this.MaturityDate;
        this._note.RequestType = null;
        this.ValidateNoteAndSave();
        //this.SaveNotefunc(this._note);
    };
    NoteDetailComponent.prototype.SaveNotefunc = function (objNote, notevalue) {
        var _this = this;
        this._isNoteSaving = true;
        this.convertdate();
        this.initialised = 0;
        var notificationNoteId = this._note.NoteId;
        if (notevalue == "Save") {
            if (this.changedlstmarketnote.length > 0) {
                for (var m = 0; m < this.changedlstmarketnote.length; m++) {
                    this.changedlstmarketnote[m].Date = this.convertDatetoGMT(this.changedlstmarketnote[m].Date);
                }
                objNote.ListNoteMarketPrice = [];
                objNote.ListNoteMarketPrice = this.changedlstmarketnote;
            }
            else {
                objNote.ListNoteMarketPrice = [];
            }
        }
        else if (notevalue == "Copy") {
            objNote.ListNoteMarketPrice = this._note.ListNoteMarketPrice;
        }
        this._noteextt.ParentNoteID = this.gParentNoteid;
        this._noteextt.noteValue = notevalue;
        this.noteService.addNote(objNote).subscribe(function (res) {
            if (res.Succeeded) {
                //  this._isNoteSaving = false;
                _this._noteextt.NoteId = res.newNoteID;
                _this._note.NoteId = res.newNoteID;
                _this.SaveNoteextralist(true);
                _this.AddUpdateNoteRuleTypeSetup();
                _this.SendPushNotification(notificationNoteId);
            }
            else {
                _this.utilityService.navigateToSignIn();
                // this._router.navigate([this.routes.note.name]);
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    NoteDetailComponent.prototype.SaveNoteextralist = function (savebtnclick, calc) {
        var _this = this;
        if (calc === void 0) { calc = false; }
        for (var i = 0; i < this._noteext.RateSpreadScheduleList.length; i++) {
            if (!(Number(this._noteext.RateSpreadScheduleList[i].ValueTypeText).toString() == "NaN" || Number(this._noteext.RateSpreadScheduleList[i].ValueTypeText) == 0)) {
                this._noteext.RateSpreadScheduleList[i].ValueTypeID = Number(this._noteext.RateSpreadScheduleList[i].ValueTypeText);
                this._noteext.RateSpreadScheduleList[i].ValueTypeText = this.lstRateSpreadSch_ValueType.find(function (x) { return x.LookupID == _this._noteext.RateSpreadScheduleList[i].ValueTypeID; }).Name;
            }
            else {
                var filteredarray = this.lstRateSpreadSch_ValueType.filter(function (x) { return x.Name == _this._noteext.RateSpreadScheduleList[i].ValueTypeText; });
                if (filteredarray.length != 0) {
                    this._noteext.RateSpreadScheduleList[i].ValueTypeID = Number(filteredarray[0].LookupID);
                }
            }
            if (!(Number(this._noteext.RateSpreadScheduleList[i].IntCalcMethodText).toString() == "NaN" || Number(this._noteext.RateSpreadScheduleList[i].IntCalcMethodText) == 0)) {
                this._noteext.RateSpreadScheduleList[i].IntCalcMethodID = Number(this._noteext.RateSpreadScheduleList[i].IntCalcMethodText);
                this._noteext.RateSpreadScheduleList[i].IntCalcMethodText = this.lstIntCalcMethodID.find(function (x) { return x.LookupID == _this._noteext.RateSpreadScheduleList[i].IntCalcMethodID; }).Name;
            }
            else {
                var filteredarray = this.lstIntCalcMethodID.filter(function (x) { return x.Name == _this._noteext.RateSpreadScheduleList[i].IntCalcMethodText; });
                if (filteredarray.length != 0) {
                    this._noteext.RateSpreadScheduleList[i].IntCalcMethodID = Number(filteredarray[0].LookupID);
                }
            }
            //manish
            if (!(Number(this._noteext.RateSpreadScheduleList[i].IndexNameText).toString() == "NaN" || Number(this._noteext.RateSpreadScheduleList[i].IndexNameText) == 0)) {
                this._noteext.RateSpreadScheduleList[i].IndexNameID = Number(this._noteext.RateSpreadScheduleList[i].IndexNameText);
                this._noteext.RateSpreadScheduleList[i].IndexNameText = this.lstIndextype.find(function (x) { return x.LookupID == _this._noteext.RateSpreadScheduleList[i].IndexNameID; }).Name;
            }
            else {
                var filteredarray = this.lstIndextype.filter(function (x) { return x.Name == _this._noteext.RateSpreadScheduleList[i].IndexNameText; });
                if (filteredarray.length != 0) {
                    this._noteext.RateSpreadScheduleList[i].IndexNameID = Number(filteredarray[0].LookupID);
                }
            }
            this._noteext.RateSpreadScheduleList[i].EffectiveDate = this.Ratespread_EffectiveDate;
            this._noteext.RateSpreadScheduleList[i].ModuleId = 14;
        }
        if (this._noteext.NotePrepayAndAdditionalFeeScheduleList) {
            for (var i = 0; i < this._noteext.NotePrepayAndAdditionalFeeScheduleList.length; i++) {
                if (!(Number(this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ValueTypeText).toString() == "NaN" || Number(this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ValueTypeText) == 0)) {
                    this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ValueTypeID = Number(this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ValueTypeText);
                }
                else {
                    var filteredarray = this.lstPrepayAdditinalFee_ValueType.filter(function (x) { return x.Name == _this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ValueTypeText; });
                    if (filteredarray.length != 0) {
                        this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ValueTypeID = Number(filteredarray[0].LookupID);
                    }
                }
                if (!(Number(this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ApplyTrueUpFeatureText).toString() == "NaN" || Number(this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ApplyTrueUpFeatureText) == 0)) {
                    this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ApplyTrueUpFeatureID = Number(this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ApplyTrueUpFeatureText);
                }
                else {
                    var filteredarray1 = this.lstPrepayAdditinalFee_lstApplyTrueUpFeature.filter(function (x) { return x.Name == _this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ApplyTrueUpFeatureText; });
                    if (filteredarray1.length != 0) {
                        this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ApplyTrueUpFeatureID = Number(filteredarray1[0].LookupID);
                    }
                }
                this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].EffectiveDate = this.PrepayAndAdditionalFeeSchedule_EffectiveDate;
                this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ModuleId = 13;
            }
        }
        if (this._noteext.NoteStrippingList) {
            for (var i = 0; i < this._noteext.NoteStrippingList.length; i++) {
                if (!(Number(this._noteext.NoteStrippingList[i].ValueTypeText).toString() == "NaN" || Number(this._noteext.NoteStrippingList[i].ValueTypeText) == 0)) {
                    this._noteext.NoteStrippingList[i].ValueTypeID = Number(this._noteext.NoteStrippingList[i].ValueTypeText);
                }
                else {
                    var filteredarray = this.lstStrippingSch_ValueType.filter(function (x) { return x.Name == _this._noteext.NoteStrippingList[i].ValueTypeText; });
                    if (filteredarray.length != 0) {
                        this._noteext.NoteStrippingList[i].ValueTypeID = Number(filteredarray[0].LookupID);
                    }
                }
                this._noteext.NoteStrippingList[i].EffectiveDate = this.StrippingSchedule_EffectiveDate;
                this._noteext.NoteStrippingList[i].ModuleId = 16;
            }
        }
        if (this._noteext.lstFinancingFeeSchedule) {
            for (var i = 0; i < this._noteext.lstFinancingFeeSchedule.length; i++) {
                if (!(Number(this._noteext.lstFinancingFeeSchedule[i].ValueTypeText).toString() == "NaN" || Number(this._noteext.lstFinancingFeeSchedule[i].ValueTypeText) == 0)) {
                    this._noteext.lstFinancingFeeSchedule[i].ValueTypeID = Number(this._noteext.lstFinancingFeeSchedule[i].ValueTypeText);
                }
                else {
                    //
                    var filteredarray = this.lstFinancingFeeSch_ValueType.filter(function (x) { return x.Name == _this._noteext.lstFinancingFeeSchedule[i].ValueTypeText; });
                    if (filteredarray.length != 0) {
                        this._noteext.lstFinancingFeeSchedule[i].ValueTypeID = Number(filteredarray[0].LookupID);
                    }
                }
                this._noteext.lstFinancingFeeSchedule[i].EffectiveDate = this.FinancingFeeSchedule_EffectiveDate;
                this._noteext.lstFinancingFeeSchedule[i].ModuleId = 8;
            }
        }
        if (this._noteext.NoteFinancingScheduleList) {
            for (var i = 0; i < this._noteext.NoteFinancingScheduleList.length; i++) {
                if (!(Number(this._noteext.NoteFinancingScheduleList[i].ValueTypeText).toString() == "NaN" || Number(this._noteext.NoteFinancingScheduleList[i].ValueTypeText) == 0)) {
                    this._noteext.NoteFinancingScheduleList[i].ValueTypeID = Number(this._noteext.NoteFinancingScheduleList[i].ValueTypeText);
                }
                else {
                    var filteredarray = this.lstFinancingSch_ValueType.filter(function (x) { return x.Name == _this._noteext.NoteFinancingScheduleList[i].ValueTypeText; });
                    if (filteredarray.length != 0) {
                        this._noteext.NoteFinancingScheduleList[i].ValueTypeID = Number(filteredarray[0].LookupID);
                    }
                }
                if (!(Number(this._noteext.NoteFinancingScheduleList[i].CurrencyCodeText).toString() == "NaN" || Number(this._noteext.NoteFinancingScheduleList[i].CurrencyCodeText) == 0)) {
                    this._noteext.NoteFinancingScheduleList[i].CurrencyCode = Number(this._noteext.NoteFinancingScheduleList[i].CurrencyCodeText);
                }
                else {
                    var filteredarray = this.lstLoanCurrency.filter(function (x) { return x.Name == _this._noteext.NoteFinancingScheduleList[i].CurrencyCodeText; });
                    if (filteredarray.length != 0) {
                        this._noteext.NoteFinancingScheduleList[i].CurrencyCode = Number(filteredarray[0].LookupID);
                    }
                }
                if (!(Number(this._noteext.NoteFinancingScheduleList[i].IndexTypeText).toString() == "NaN" || Number(this._noteext.NoteFinancingScheduleList[i].IndexTypeText) == 0)) {
                    this._noteext.NoteFinancingScheduleList[i].IndexTypeID = Number(this._noteext.NoteFinancingScheduleList[i].IndexTypeText);
                }
                else {
                    var filteredarray = this.lstIndextype.filter(function (x) { return x.Name == _this._noteext.NoteFinancingScheduleList[i].IndexTypeText; });
                    if (filteredarray.length != 0) {
                        this._noteext.NoteFinancingScheduleList[i].IndexTypeID = Number(filteredarray[0].LookupID);
                    }
                }
                if (!(Number(this._noteext.NoteFinancingScheduleList[i].IntCalcMethodText).toString() == "NaN" || Number(this._noteext.NoteFinancingScheduleList[i].IntCalcMethodText) == 0)) {
                    this._noteext.NoteFinancingScheduleList[i].IntCalcMethodID = Number(this._noteext.NoteFinancingScheduleList[i].IntCalcMethodText);
                }
                else {
                    var filteredarray = this.lstIntCalcMethodID.filter(function (x) { return x.Name == _this._noteext.NoteFinancingScheduleList[i].IntCalcMethodText; });
                    if (filteredarray.length != 0) {
                        this._noteext.NoteFinancingScheduleList[i].IntCalcMethodID = Number(filteredarray[0].LookupID);
                    }
                }
                this._noteext.NoteFinancingScheduleList[i].EffectiveDate = this.FinancingSchedule_EffectiveDate;
                this._noteext.NoteFinancingScheduleList[i].ModuleId = 9;
            }
        }
        if (this._noteext.NoteDefaultScheduleList) {
            for (var i = 0; i < this._noteext.NoteDefaultScheduleList.length; i++) {
                if (!(Number(this._noteext.NoteDefaultScheduleList[i].ValueTypeText).toString() == "NaN" || Number(this._noteext.NoteDefaultScheduleList[i].ValueTypeText) == 0)) {
                    this._noteext.NoteDefaultScheduleList[i].ValueTypeID = Number(this._noteext.NoteDefaultScheduleList[i].ValueTypeText);
                }
                else {
                    var filteredarray = this.lstDefaultSch_ValueType.filter(function (x) { return x.Name == _this._noteext.NoteDefaultScheduleList[i].ValueTypeID; });
                    if (filteredarray.length != 0) {
                        this._noteext.NoteDefaultScheduleList[i].ValueTypeID = Number(filteredarray[0].LookupID);
                    }
                }
                this._noteext.NoteDefaultScheduleList[i].EffectiveDate = this.DefaultSchedule_EffectiveDate;
                this._noteext.NoteDefaultScheduleList[i].ModuleId = 6;
            }
        }
        if (this._noteext.lstNoteServicingLog) {
            if (this.flexservicelogupdatedRowNo.length > 0) {
                this.flexservicelogToUpdate = [];
                // debugger;
                for (var i = 0; i < this.flexservicelogupdatedRowNo.length; i++) {
                    var filterval = this.ServicingLog_refreshlist.filter(function (x) { return x.row_num == _this.flexservicelogupdatedrow_num[i]; });
                    if (filterval.length != 0) {
                        if (!(Number(filterval[0].TransactionTypeText).toString() == "NaN" || Number(filterval[0].TransactionTypeText) == 0)) {
                            filterval[0].TransactionType = Number(filterval[0].TransactionTypeText);
                            //var filteredarray = this.listtransactiontype.filter(x => x.TransactionTypesID == this.ServicingLog_refreshlist[this.flexservicelogupdatedRowNo[i]].TransactionType);
                            var filteredarray = this.listtransactiontype.filter(function (x) { return x.TransactionTypesID == filterval[0].TransactionType; });
                            filterval.TransactionTypeText = filteredarray[0].TransactionName;
                        }
                        this.flexservicelogToUpdate.push(filterval[0]);
                    }
                    //  this.flexservicelogToUpdate.push(this._noteext.lstNoteServicingLog[this.flexservicelogupdatedRowNo[i]]);
                }
                this._noteextt.lstNoteServicingLog = this.flexservicelogToUpdate;
            }
        }
        //if (this._noteextt.noteValue == 'Copy') {
        //    if (this._noteext.lstNoteServicingLog) {
        //        if (this._noteext.lstNoteServicingLog.length > 0) {
        //            for (var i = 0; i < this._noteext.lstNoteServicingLog.length; i++) {
        //                this._noteext.lstNoteServicingLog[i].TransactionId = '00000000-0000-0000-0000-000000000000';
        //            }
        //            this._noteextt.lstNoteServicingLog = this._noteext.lstNoteServicingLog;
        //        }
        //    }
        //}
        if (this._noteext.ListFutureFundingScheduleTab) {
            for (var i = 0; i < this._noteext.ListFutureFundingScheduleTab.length; i++) {
                this._noteext.ListFutureFundingScheduleTab[i].ModuleId = 10;
            }
        }
        if (this._noteext.ListLiborScheduleTab) {
            for (var i = 0; i < this._noteext.ListLiborScheduleTab.length; i++) {
                this._noteext.ListLiborScheduleTab[i].ModuleId = 18;
            }
        }
        if (this._noteext.ListFixedAmortScheduleTab) {
            for (var i = 0; i < this._noteext.ListFixedAmortScheduleTab.length; i++) {
                this._noteext.ListFixedAmortScheduleTab[i].ModuleId = 19;
            }
        }
        if (this._noteext.ListPIKfromPIKSourceNoteTab) {
            for (var i = 0; i < this._noteext.ListPIKfromPIKSourceNoteTab.length; i++) {
                this._noteext.ListPIKfromPIKSourceNoteTab[i].ModuleId = 17;
            }
        }
        if (this._noteext.ListFeeCouponStripReceivable) {
            for (var i = 0; i < this._noteext.ListFeeCouponStripReceivable.length; i++) {
                this._noteext.ListFeeCouponStripReceivable[i].ModuleId = 20;
            }
        }
        //Maturity
        if (!!this.MaturityEffectiveDate) {
            if (this._noteext.MaturityScenariosList != null) {
                this._noteextt.MaturityScenariosList = this._noteext.MaturityScenariosList;
                this._noteextt.MaturityScenariosList[0].EffectiveDate = this.MaturityEffectiveDate;
                this._noteextt.MaturityScenariosList[0].Date = this.MaturityDate;
                this._noteextt.MaturityScenariosList[0].ModuleId = 11;
                this._noteextt.MaturityScenariosList[0].MaturityID = this.MaturityType;
            }
        }
        if (this.maturityTypeList != null) {
            for (var i = 0; i < this.maturityTypeList.length; i++) {
                this.lstMaturity.push({
                    'Date': this.maturityTypeList[i].MaturityDate,
                    'MaturityID': this.maturityTypeList[i].MaturityType
                });
            }
            this._noteextt.lstMaturity = this.lstMaturity;
        }
        //ServicingFeeSchedule
        if (!!this.Servicing_EffectiveDate) {
            this._noteextt.NoteServicingFeeScheduleList = this._noteext.NoteServicingFeeScheduleList;
            if (this.Servicing_EffectiveDate != null) {
                this._noteextt.NoteServicingFeeScheduleList[0].EffectiveDate = this.Servicing_EffectiveDate;
            }
            if (this.Servicing_Date != null) {
                this._noteextt.NoteServicingFeeScheduleList[0].Date = this.Servicing_Date;
            }
            this._noteextt.NoteServicingFeeScheduleList[0].Value = this.Servicing_Value;
            this._noteextt.NoteServicingFeeScheduleList[0].IsCapitalized = this.Servicing_IsCapitalized;
            this._noteextt.NoteServicingFeeScheduleList[0].ModuleId = 15;
        }
        ////PIKSchedule
        if (!!this.PIKSchedule_EffectiveDate) {
            if (this._noteext.NotePIKScheduleList != null) {
                this._noteextt.NotePIKScheduleList = this._noteext.NotePIKScheduleList;
                if (this.PIKSchedule_EffectiveDate != null) {
                    this._noteextt.NotePIKScheduleList[0].EffectiveDate = this.PIKSchedule_EffectiveDate;
                }
                if (this.PIKSchedule_StartDate != null) {
                    this._noteextt.NotePIKScheduleList[0].StartDate = this.PIKSchedule_StartDate;
                }
                if (this.PIKSchedule_EndDate != null) {
                    this._noteextt.NotePIKScheduleList[0].EndDate = this.PIKSchedule_EndDate;
                }
                if (this.SourceAccountID != null) {
                    this._noteextt.NotePIKScheduleList[0].SourceAccountID = this.SourceAccountID;
                }
                else {
                    this._noteextt.NotePIKScheduleList[0].SourceAccountID = this.PIKSchedule_SourceAccountID;
                    this._noteextt.NotePIKScheduleList[0].SourceAccount = this.PIKSchedule_SourceAccount;
                }
                if (this.TargetAccountID != null) {
                    this._noteextt.NotePIKScheduleList[0].TargetAccountID = this.TargetAccountID;
                }
                else {
                    this._noteextt.NotePIKScheduleList[0].TargetAccountID = this.PIKSchedule_TargetAccountID;
                    this._noteextt.NotePIKScheduleList[0].TargetAccount = this.PIKSchedule_TargetAccount;
                }
                //   this._noteextt.lstPIKSchedule[0].SourceAccount = this.SourceAccountID
                //    this._noteextt.lstPIKSchedule[0].TargetAccountID = this.TargetAccountID
                // this._noteextt.lstPIKSchedule[0].TargetAccount = this.TargetAccountID
                this._noteextt.NotePIKScheduleList[0].AdditionalIntRate = this.PIKSchedule_AdditionalIntRate;
                this._noteextt.NotePIKScheduleList[0].AdditionalSpread = this.PIKSchedule_AdditionalSpread;
                this._noteextt.NotePIKScheduleList[0].IndexFloor = this.PIKSchedule_IndexFloor;
                this._noteextt.NotePIKScheduleList[0].IntCompoundingRate = this.PIKSchedule_IntCompoundingRate;
                this._noteextt.NotePIKScheduleList[0].IntCompoundingSpread = this.PIKSchedule_IntCompoundingSpread;
                this._noteextt.NotePIKScheduleList[0].IntCapAmt = this.PIKSchedule_IntCapAmt;
                this._noteextt.NotePIKScheduleList[0].PurBal = this.PIKSchedule_PurBal;
                this._noteextt.NotePIKScheduleList[0].AccCapBal = this.PIKSchedule_AccCapBal;
                this._noteextt.NotePIKScheduleList[0].PIKReasonCodeID = this.PIKSchedule_PIKReasonCodeID;
                this._noteextt.NotePIKScheduleList[0].PIKComments = this.PIKSchedule_PIKComments;
                this._noteextt.NotePIKScheduleList[0].PIKReasonCodeIDText = this.PIKSchedule_PIKReasonCodeIDText;
                this._noteextt.NotePIKScheduleList[0].PIKIntCalcMethodID = this.PIKSchedule_PIKIntCalcMethodID;
                this._noteextt.NotePIKScheduleList[0].PIKIntCalcMethodIDText = this.PIKSchedule_PIKIntCalcMethodIDText;
                this._noteextt.NotePIKScheduleList[0].ModuleId = 12;
            }
        }
        //Date conversion
        this.convertGridDate();
        if (this._noteext.ListFutureFundingScheduleTab) {
            for (var i = 0; i < this._noteext.ListFutureFundingScheduleTab.length; i++) {
                if (!(Number(this._noteext.ListFutureFundingScheduleTab[i].PurposeText).toString() == "NaN" || Number(this._noteext.ListFutureFundingScheduleTab[i].PurposeText) == 0)) {
                    this._noteext.ListFutureFundingScheduleTab[i].PurposeID = Number(this._noteext.ListFutureFundingScheduleTab[i].PurposeText);
                }
                else {
                    var filteredarray = this.lstPurposeType.filter(function (x) { return x.Name == _this._noteext.ListFutureFundingScheduleTab[i].PurposeText; });
                    if (filteredarray.length != 0) {
                        this._noteext.ListFutureFundingScheduleTab[i].PurposeID = Number(filteredarray[0].LookupID);
                    }
                }
            }
        }
        this._noteextt.ListFutureFundingScheduleTab = this._noteext.ListFutureFundingScheduleTab;
        this._noteextt.ListFixedAmortScheduleTab = this._noteext.ListFixedAmortScheduleTab;
        this._noteextt.ListPIKfromPIKSourceNoteTab = this._noteext.ListPIKfromPIKSourceNoteTab;
        this._noteextt.ListFeeCouponStripReceivable = this._noteext.ListFeeCouponStripReceivable;
        if (this._note.UseIndexOverrides) {
            this._noteextt.ListLiborScheduleTab = this._noteext.ListLiborScheduleTab;
        }
        this._noteextt.RateSpreadScheduleList = this._noteext.RateSpreadScheduleList;
        this._noteextt.NotePrepayAndAdditionalFeeScheduleList = this._noteext.NotePrepayAndAdditionalFeeScheduleList;
        this._noteextt.NoteStrippingList = this._noteext.NoteStrippingList;
        this._noteextt.lstFinancingFeeSchedule = this._noteext.lstFinancingFeeSchedule;
        this._noteextt.NoteFinancingScheduleList = this._noteext.NoteFinancingScheduleList;
        this._noteextt.NoteDefaultScheduleList = this._noteext.NoteDefaultScheduleList;
        this._noteextt.lstServicerDropDateSetup = this._noteext.lstServicerDropDateSetup;
        this._noteextt.NoteId = this._note.NoteId;
        this._noteextt.noteobj = this._note;
        if (this.deleteMarketPriceList.length > 0) {
            for (var k = 0; k < this.deleteMarketPriceList.length; k++) {
                this.deleteMarketPriceList[k].Date = this.convertDatetoGMT(this.deleteMarketPriceList[k].Date);
            }
            this._noteextt.deleteMarketPriceList = this.deleteMarketPriceList;
        }
        this.noteService.addNoteExtralist(this._noteextt).subscribe(function (res) {
            if (res.Succeeded) {
                _this.SaveNoteArchieveextralist();
                //get last funding updated date
                _this.noteService.GetLastUpdatedDateAndUpdatedByForSchedule(_this._note).subscribe(function (res) {
                    if (res.Succeeded) {
                        _this._note.FFLastUpdatedDate_String = res.NoteAllScheduleLatestRecord.LastUpdatedDate_String_FF;
                        _this._note.UpdatedByFF = res.NoteAllScheduleLatestRecord.LastUpdatedBy_FF;
                    }
                });
                //
                if (calc) {
                    _this._note.CalculationStatus = "Running";
                    _this.RunCalculator();
                }
                else if (savebtnclick) {
                    _this._isNoteSaving = false;
                    if (res.TotalCount == 0) {
                        _this._copymessagediv = false;
                        _this._isNoteSaveonly = true;
                        localStorage.setItem('divSucessNote', JSON.stringify(true));
                        localStorage.setItem('divSucessMsgNote', JSON.stringify(res.Message));
                        _this._Showmessagenotediv = true;
                        _this._ShowmessagenotedivMsg = res.Message;
                    }
                    else {
                        _this._copymessagediv = false;
                        _this._isNoteSaveonly = true;
                        localStorage.setItem('divInfoNote', JSON.stringify(true));
                        localStorage.setItem('divInfoMsgNote', JSON.stringify(res.Message));
                        _this._ShowmessagenotedivWar = true;
                        _this._ShowmessagenotedivMsgWar = res.Message;
                    }
                    if (res.Succeeded == false) {
                        _this._copymessagediv = false;
                        localStorage.setItem('divWarNote', JSON.stringify(true));
                        localStorage.setItem('divWarMsgNote', JSON.stringify(res.Message));
                        _this._ShowmessagenotedivWar = true;
                        _this._ShowmessagenotedivMsgWar = res.Message;
                    }
                    //if (this._noteCopyMsg != null) {
                    //    //    localStorage.setItem('divSucessNote', JSON.stringify(true));
                    //    //    localStorage.setItem('divSucessMsgNote', JSON.stringify(this._noteCopyMsg));
                    //    localStorage.setItem('divInfoNote', JSON.stringify(false));
                    //    this._copymessagediv = true;
                    //    this._copymessagedivMsg = this._noteCopyMsg;
                    //    //  this.CloseCopyPopUp();
                    //    // this._isNoteSaveonly = false;
                    //    this._copymessagediv = true;
                    //    this._copymessagedivMsg = this._noteCopyMsg;
                    //    if (this._isCopyandopen == true) {
                    //        var notenewcopied;//= ['notedetail', this._noteextt.NoteId];
                    //        if (window.location.href.indexOf("notedetail/a") > -1) {
                    //            notenewcopied = ['notedetail', this._noteextt.NoteId]
                    //        }
                    //        else {
                    //            notenewcopied = ['notedetail/a', this._noteextt.NoteId]
                    //        }
                    //        this._router.navigate(notenewcopied);
                    //    }
                    //    this.CloseCopyPopUp();
                    //    //}
                    //    //else {
                    //    //    this.CloseCopyPopUp();
                    //    //}
                    //    setTimeout(() => {
                    //        this._copymessagediv = false;
                    //        this._noteCopyMsg = null;
                    //        this._isCopyonly = false;
                    //        this._Showmessagenotediv = false;
                    //        this._ShowmessagenotedivWar = false;
                    //    }, 2000);
                    //}
                    //else {
                    if (!_this.isSaveOnly) {
                        _this._router.navigate(['note']);
                    }
                    else if (_this.isSaveOnly) {
                        //alert('this.isSaveOnly ');
                        //call function for reload all schedule grids Ex. Ratesprit
                        //this.fetchNoteAdditinallist();
                        //this.fetchNote();                            
                        // get return url from route parameters or default to '/'
                        var returnUrl = _this._router.url;
                        if (window.location.href.indexOf("notedetail/a") > -1) {
                            returnUrl = returnUrl.toString().replace('notedetail/a/', 'notedetail/');
                        }
                        else if (returnUrl.indexOf("notedetail/") > -1) {
                            returnUrl = returnUrl.toString().replace('notedetail/', 'notedetail/a/');
                        }
                        //var returnUrl = '/notedetail/a/dad85096-fe89-4a9c-b159-643069fe6e3a'; //this._router.url; //this.activatedRoute.url;
                        _this._router.navigate([returnUrl]);
                    }
                    setTimeout(function () {
                        _this._Showmessagenotediv = false;
                        _this._ShowmessagenotedivWar = false;
                    }, 2000);
                    //}
                }
            }
            else {
                //Error msg
                //   this._ShowmessagedivWarnote = true;
                _this._ShowmessagenotedivWar = true;
                _this._isNoteSaving = false;
                //  this._ShowmessagedivMsgWarnote = "Error occurred while saving Note Additional , please contact to system administrator.";
                _this._ShowmessagenotedivMsgWar = "Error occurred while saving Note Additional , please contact to system administrator.";
                _this.ClosePopUp();
                setTimeout(function () {
                    this._isNoteSaving = false;
                    //  this._ShowmessagedivWarnote = false;
                    this._Showmessagenotediv = false;
                    this._ShowmessagenotedivWar = false;
                }.bind(_this), 5000);
            }
        });
    };
    NoteDetailComponent.prototype.Cancel = function () {
        this._router.navigate(['note']);
    };
    NoteDetailComponent.prototype.GetAllNoteLookups = function () {
        var _this = this;
        this.noteService.getAllLookupById().subscribe(function (res) {
            var data = res.lstLookups;
            _this.lstRateSpreadSch_ValueType = data.filter(function (x) { return x.ParentID == "19"; });
            //this.lstPrepayAdditinalFee_ValueType = data.filter(x => x.ParentID == "20");
            _this.lstStrippingSch_ValueType = data.filter(function (x) { return x.ParentID == "21"; });
            _this.lstDefaultSch_ValueType = data.filter(function (x) { return x.ParentID == "22"; });
            _this.lstFinancingFeeSch_ValueType = data.filter(function (x) { return x.ParentID == "23"; });
            _this.lstFinancingSch_ValueType = data.filter(function (x) { return x.ParentID == "24"; });
            _this.lstIntCalcMethodID = data.filter(function (x) { return x.ParentID == "25"; });
            //   this.lstPayFrequency = data.filter(x => x.ParentID == "28");
            _this.lstLoanCurrency = data.filter(function (x) { return x.ParentID == "29"; });
            _this.lstRoundingMethod = data.filter(function (x) { return x.ParentID == "33"; });
            _this.lstTransactionType = data.filter(function (x) { return x.ParentID == "39"; });
            _this.lstIndextype = data.filter(function (x) { return x.ParentID == "32"; });
            _this.lstratingagency = data.filter(function (x) { return x.ParentID == "43"; });
            _this.lstriskrating = data.filter(function (x) { return x.ParentID == "44"; });
            _this.lstCashflowEngineID = data.filter(function (x) { return x.ParentID == "47"; });
            _this.lstPurposeType = data.filter(function (x) { return x.ParentID == "50"; });
            _this.lstServicerType = data.filter(function (x) { return x.ParentID == "62"; });
            _this.lstNoteDeleteFilter = data.filter(function (x) { return x.ParentID == "66"; });
            _this.lstFinancingSource = data.filter(function (x) { return x.ParentID == "71"; });
            _this.lstDebtType = data.filter(function (x) { return x.ParentID == "72"; });
            _this.lstCapStack = data.filter(function (x) { return x.ParentID == "73"; });
            _this.lstPool = data.filter(function (x) { return x.ParentID == "74"; });
            _this.lstPool.sort(_this.sortByPoolName);
            _this.lstPrepayAdditinalFee_ValueType = _this.lstFeeTypeLookUp;
            _this.lstPrepayAdditinalFee_lstApplyTrueUpFeature = data.filter(function (x) { return x.ParentID == "95"; });
            _this.lstCalculationMode = data.filter(function (x) { return x.ParentID == "79"; });
            _this.lstScenario = window.localStorage.getItem("lstScenario");
            _this.lstInterestCalculationRuleForPaydowns = data.filter(function (x) { return x.ParentID == "99"; });
            _this.lstInterestCalculationRuleForPaydownsAmort = data.filter(function (x) { return x.ParentID == "99"; });
            // this.lstddlOverideComment = data.filter(x => x.ParentID == "108");
            //this.lstRoundingNote = data.filter(x => x.ParentID == "95");
            _this.lstStrategy = data.filter(function (x) { return x.ParentID == "110"; });
            if (_this._note.EnableM61Calculations == 3) {
                _this.lstNoteDeleteFilter = _this.lstNoteDeleteFilter.filter(function (x) { return x.LookupID != "685"; });
            }
            _this.lstPIKInterestCalcmethod = data.filter(function (x) { return x.ParentID == "25"; });
            _this._bindGridDropdows();
        });
    };
    NoteDetailComponent.prototype.getAllfinancingWarehouse = function () {
        var _this = this;
        this.noteService.GetAllFinancingWarehouse(this._pageIndex, this._pageSize).subscribe(function (res) {
            if (res.Succeeded) {
                _this.lstfinancingwhouse = res.lstFinancingWarehouseDataContract;
            }
        });
    };
    NoteDetailComponent.prototype.getLiborScheduleData = function () {
        var _this = this;
        this._isNoteSaving = true;
        this.noteService.getLiborScheduleDataByNoteId(this._note, this._pageIndex, this._pageSize).subscribe(function (res) {
            if (res.Succeeded) {
                _this.lstLiborSchedule = res.lstLiborScheduledata;
                _this._noteext.ListLiborScheduleTab = _this.lstLiborSchedule;
                _this.ConvertToBindableDate(_this._noteext.ListLiborScheduleTab, "LIBORSchedule", "en-US");
                // alert('LiborSchedule ' +JSON.stringify(this._noteext.ListLiborScheduleTab));
                _this.showlaborflex();
                _this._isNoteSaving = false;
            }
        });
    };
    NoteDetailComponent.prototype.showindexgrid = function () {
        if (this._note.UseIndexOverrides == true) {
            this._showliborgride = true;
            this._liborindexMsg = false;
            this.getLiborScheduleData();
        }
        else {
            this._showliborgride = false;
            this._liborindexMsg = true;
            this.lstLiborSchedule = null;
            //  this.showlaborflex();
        }
    };
    NoteDetailComponent.prototype.getViewHistory = function (modulename) {
        this._note.pagesIndex = 10;
        this._note.pagesSize = 10;
        this._note.modulename = modulename;
        localStorage.setItem('NoteObj', JSON.stringify(this._note));
        // this._router.navigate([this.routes.periodicData.name]);
    };
    NoteDetailComponent.prototype.getNoteexceptions = function (objectid) {
        var _this = this;
        try {
            this.noteService.GetNoteExceptions(objectid).subscribe(function (res) {
                if (res.Succeeded) {
                    var data = res.Allexceptionslist;
                    _this._ExceptionListCount = data.length;
                    //remove first cell selection
                    // this.flexnoteexceptions.selectionMode = wijmo.grid.SelectionMode.None;
                    if (data.length == 0) {
                        _this._ExceptionListCount = 0;
                        _this._CritialExceptionListCount = 0;
                        _this._showexceptionEmptymessage = true;
                    }
                    else {
                        _this.lstnotesexceptions = data;
                        _this._showexceptionEmptymessage = false;
                        // this._showexceptionEmptydiv = true;
                        // this.showflexnoteexceptionsflex();
                        //var count = 0;
                        var total_critical = data.filter(function (x) { return x.ActionLevelText == "Critical"; });
                        var total_normal = data.filter(function (x) { return x.ActionLevelText == "Normal"; });
                        var gaapcheck = data.filter(function (x) { return x.FieldName == "GAAP Component"; });
                        var amortcheck = data.filter(function (x) { return x.FieldName == "Amort Fee Check" || x.FieldName == "Amort Discount Premium Check" || x.FieldName == "Amort Cap Cost Check"; });
                        if (gaapcheck.length > 0) {
                            _this._showgaapcheck = true;
                        }
                        if (amortcheck.length > 0) {
                            _this._showamortcheck = true;
                        }
                        if (total_critical.length > 0) {
                            _this.exceptionscount_critical = total_critical.length;
                        }
                        if (total_normal.length > 0) {
                            _this.exceptionscount_normal = total_normal.length;
                        }
                        //fetch "Critical" error count
                        _this._CritialExceptionListCount = data.filter(function (x) { return x.ActionLevelText == "Critical"; }).length;
                    }
                }
            });
        }
        catch (err) {
            alert(err);
        }
    };
    NoteDetailComponent.prototype.getNotActivity = function () {
        var _this = this;
        try {
            if (!this.IsOpenActivityTab) {
                this.activityMessage = '';
                this._isNoteSaving = true;
                setTimeout(function () {
                    var d = new Date();
                    var datestring = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate() + " " +
                        d.getHours() + ":" + d.getMinutes();
                    _this._activityLog.ModuleID = _this._note.NoteId;
                    _this._activityLog.ModuleTypeID = 182;
                    _this._activityLog.Currentdate = datestring;
                    _this.noteService.getActivityLogByModuleId(_this._activityLog, _this._pageIndexActivity, _this._pageSizeActivity).subscribe(function (res) {
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
                            //this.arrActivityToday = this.arrActivityToday.sort()
                            //this.arrParentCreatedDate = res.lstActivityLog
                            //this.arrParentCreatedDate = this.arrParentCreatedDate.groupby(x => x.CreatedDate)
                            //var groups = res.lstActivityLog.reduce(function (obj, item) {
                            //    obj[new Date(item.CreatedDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" })] = obj[new Date(item.CreatedDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" })] || [];
                            //    obj[new Date(item.CreatedDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" })].push({
                            //        ActivityMessage: item.ActivityMessage,
                            //        ActivityUserFirstLetter: item.ActivityUserFirstLetter,
                            //        CreatedDate: item.CreatedDate,
                            //        UColor: item.UColor
                            //    });
                            //    return obj;
                            //}, {});
                            //debugger;
                            //this.arrParentCreatedDate = Object.keys(groups).map(function (key) {
                            //    return { CreatedDate: key, ActivityMessage: groups[key] };
                            //});
                            _this.CurrentcountActivity = _this.CurrentcountActivity + _this.currentactivity.length;
                            if (_this.lstActivityLog.length == 0) {
                                _this.activityMessage = "No activities found";
                            }
                            else {
                                //this.strActivity = "";
                                //this.currentActivityDate = this.currentactivity[0].CreatedDate;
                                //this.firstDat = '<b>' + new Date(this.currentactivity[0].CreatedDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" })+'</b>';
                                //for (var i = 0; i < this.currentactivity.length; i++)
                                //{
                                //    var currdt = new Date(this.currentactivity[i].CreatedDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                                //    var parentdt = new Date(this.currentActivityDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                                //    if (currdt == parentdt) {
                                //        this.strActivity = this.strActivity + '</br>' +
                                //            '<div [ngClass]="comment.UColor">' + this.currentactivity[0].ActivityUserFirstLetter + '</div>' +
                                //            '<div>' + this.currentactivity[i].ActivityMessage + '</div>' +
                                //            '<div>' + new Date(this.currentactivity[i].CreatedDate.toString()).toLocaleTimeString("en-US", { year: "numeric", month: "numeric", day: "numeric" }) + '</div>'
                                //    }
                                //    else
                                //    {
                                //        this.currentActivityDate = this.currentactivity[i].CreatedDate;
                                //        var currdt = new Date(this.currentactivity[i].CreatedDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                                //        this.strActivity = this.strActivity + '</br>' + '<b>' + currdt.toString() + '</b>';
                                //        this.strActivity = this.strActivity + '</br>' +
                                //            '<div [ngClass]="comment.UColor">' + this.currentactivity[i].ActivityUserFirstLetter + '</div>' +
                                //            '<div>' + this.currentactivity[i].ActivityMessage + '</div>' +
                                //            '<div>' + new Date(this.currentactivity[i].CreatedDate.toString()).toLocaleTimeString("en-US", { year: "numeric", month: "numeric", day: "numeric" }) + '</div>'
                                //    }
                                //}
                                //this.strActivity = this.firstDat + this.strActivity;
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
                            _this._isNoteSaving = false;
                        }
                        else {
                            _this._router.navigate(['login']);
                        }
                    });
                    _this.IsOpenActivityTab = true;
                }, 200);
            }
            this.setFocus();
        }
        catch (err) {
            this._isNoteSaving = false;
        }
    };
    NoteDetailComponent.prototype.onScrollActivity = function () {
        //For paginging ----uncomment below code
        var myDiv = $('#activityMainDiv');
        if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
            if (this.CurrentcountActivity < this._totalCountActivity) {
                this._pageIndexActivity = this._pageIndexActivity + 1;
                this.IsOpenActivityTab = false;
                this.getNotActivity();
            }
        }
    };
    NoteDetailComponent.prototype.showflexnoteexceptionsflex = function () {
        var _this = this;
        if (!this.IsOpenExceptionTab) {
            setTimeout(function () {
                if (_this.flexnoteexceptions) {
                    _this.flexnoteexceptions.invalidate(true);
                    _this.flexnoteexceptions.autoSizeColumns();
                }
            }, 200);
        }
    };
    NoteDetailComponent.prototype.showDialog = function (modulename) {
        this._note.modulename = modulename;
        this.getPeriodicDataByNoteId(this._note);
    };
    NoteDetailComponent.prototype.showCopyDialog = function (noteid) {
        var modalcopy = document.getElementById('myModalCopyNote');
        this._note.CopyName = null;
        this._note.CopyCRENoteId = null;
        this.Copy_Dealid = this._note.DealID;
        this.Copy_DealName = this._note.DealName;
        this._dealNoExistMsg = null;
        modalcopy.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    NoteDetailComponent.prototype.showDeleteDialog = function (deleteRowIndex, moduleName) {
        this.deleteRowIndex = deleteRowIndex;
        this.modulename = moduleName;
        var modalDelete = document.getElementById('myModalDelete');
        modalDelete.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    NoteDetailComponent.prototype.showDialogDeleteOption = function () {
        var _this = this;
        if (this._moduledelete.LookupID == 0) {
            this.CustomAlert('Please select a delete option');
        }
        else {
            var customdialogbox = document.getElementById('customdialogbox');
            this._moduledelete.ModuleID = this._note.NoteId;
            this._moduledelete.ModuleName = 'Note';
            var LookupName = this.lstNoteDeleteFilter.filter(function (x) { return x.LookupID == _this._moduledelete.LookupID; })[0].Name;
            this._MsgText = 'Are you sure you want to ' + LookupName.toLowerCase() + ' for Note ' + '{' + this._note.CRENoteID + '}?';
            customdialogbox.style.display = "block";
            $.getScript("/js/jsDrag.js");
        }
    };
    NoteDetailComponent.prototype.deleteModuleByID = function () {
        var _this = this;
        this._isDeleteOPtionOk = true;
        this.dealSrv.deleteModuleByID(this._moduledelete)
            .subscribe(function (res) {
            if (res.Succeeded) {
                localStorage.setItem('divSucessNote', JSON.stringify(true));
                //localStorage.setItem('divSucessMsgNote', JSON.stringify('Record deleted successfully'));
                localStorage.setItem('divSucessMsgNote', JSON.stringify(_this.deleteoptiontext + ' for note ' + _this._note.CRENoteID + ' deleted successfully'));
                localStorage.setItem('divInfoNote', JSON.stringify(false));
                localStorage.setItem('divWarNote', JSON.stringify(false));
                _this._router.navigate(['note']);
            }
            else {
                _this.utilityService.navigateToSignIn();
            }
        }, function (error) { return console.error('Error: ' + error); });
    };
    NoteDetailComponent.prototype.CreateNote = function (CRENoteID, Name, creDeal, Isopen) {
        var _this = this;
        this._isNoteSaving = true;
        if (CRENoteID != null && Name != null && this.Copy_Dealid != null) {
            this._note.CopyCRENoteId = CRENoteID;
            this._note.CopyName = Name;
            //   this._note.NoteId = '00000000-0000-0000-0000-000000000000';
            this._note.CopyDealID = this.Copy_Dealid;
            this._note.CopyDealName = this.Copy_DealName;
            this.noteService.checkduplicatenote(this._note).subscribe(function (res) {
                if (res.Succeeded == true) {
                    _this._noteExistMsg = res.Message;
                    setTimeout(function () {
                        _this._noteExistMsg = "";
                        _this._isNoteSaving = false;
                    }, 5000);
                }
                else {
                    if (_this._note.CopyDealID != null) {
                        _this._isCopyonly = true;
                        _this._dealNoExistMsg = null;
                        _this._isCopyandopen = Isopen;
                        _this._noteCopyMsg = 'Note copied successfully.';
                        _this.CopyNote(_this._note);
                        // this.SaveNotefunc(this._note, 'Copy');
                        //  this._isNoteSaving = false;
                    }
                    else {
                        _this._dealNoExistMsg = "Please Select Deal";
                        setTimeout(function () {
                            this._noteCopyMsg = null;
                        }.bind(_this), 1000);
                    }
                    setTimeout(function () {
                        this._noteExistMsg = "";
                        this._dealNoExistMsg = null;
                    }.bind(_this), 1000);
                }
            });
        }
        else if (this.Copy_Dealid == null) {
            this._dealNoExistMsg = "Please select Deal.";
            this._isNoteSaving = false;
            setTimeout(function () {
                this._noteExistMsg = "";
                this._dealNoExistMsg = null;
            }.bind(this), 1000);
        }
        else {
            this._dealNoExistMsg = " Note Id and Note name cannot be empty.";
            this._isNoteSaving = false;
            setTimeout(function () {
                this._noteExistMsg = "";
                this._dealNoExistMsg = null;
            }.bind(this), 1000);
        }
    };
    NoteDetailComponent.prototype.CopyNote = function (note) {
        var _this = this;
        var duplicatedNoteMessage = "";
        this.noteService.CopyNote(note).subscribe(function (res) {
            if (res.Succeeded) {
                // duplicatedNoteMessage = res.Succeeded;
                _this._noteCopyMsg = res.Message;
                var newcopyNoteid = res.newNoteID;
                if (_this._noteCopyMsg != null) {
                    localStorage.setItem('divInfoNote', JSON.stringify(false));
                    _this._copymessagediv = true;
                    _this._copymessagedivMsg = _this._noteCopyMsg;
                    _this._copymessagediv = true;
                    _this._copymessagedivMsg = _this._noteCopyMsg;
                    if (_this._isCopyandopen == true) {
                        var notenewcopied; //= ['notedetail', this._noteextt.NoteId];
                        if (window.location.href.indexOf("notedetail/a") > -1) {
                            notenewcopied = ['notedetail', newcopyNoteid];
                        }
                        else {
                            notenewcopied = ['notedetail/a', newcopyNoteid];
                        }
                        _this._router.navigate(notenewcopied);
                    }
                    _this.CloseCopyPopUp();
                    setTimeout(function () {
                        _this._copymessagediv = false;
                        _this._noteCopyMsg = null;
                        _this._isCopyonly = false;
                        _this._Showmessagenotediv = false;
                        _this._ShowmessagenotedivWar = false;
                    }, 2000);
                }
            }
        });
        return this._noteExistMsg;
    };
    NoteDetailComponent.prototype.CreateOpenNote = function (CRENoteID, Name) {
        var _this = this;
        this._isNoteSaving = true;
        if (CRENoteID != null && Name != null && this.Copy_Dealid != null) {
            this._note.CopyCRENoteId = CRENoteID;
            this._note.CopyName = Name;
            this._note.CopyDealID = this.Copy_Dealid;
            this._note.CopyDealName = this.Copy_DealName;
            //  this._note.NoteId = '00000000-0000-0000-0000-000000000000';
            this.noteService.checkduplicatenote(this._note).subscribe(function (res) {
                if (res.Succeeded == true) {
                    _this._noteExistMsg = res.Message;
                    setTimeout(function () {
                        _this._noteExistMsg = "";
                        _this._isNoteSaving = false;
                    }, 5000);
                }
                else {
                    if (_this._dealNoExistMsg == null) {
                        _this._isCopyandopen = true;
                        _this._dealNoExistMsg = null;
                        _this._isCopyonly = true;
                        _this._noteCopyMsg = 'Note copied successfully.';
                        _this.CopyNote(_this._note);
                        //   this.SaveNotefunc(this._note, 'Copy');
                        _this._isNoteSaving = false;
                    }
                    else {
                        _this._noteCopyMsg = null;
                        setTimeout(function () {
                            _this._dealNoExistMsg = "Please Select Deal";
                        }, 1000);
                    }
                }
            });
        }
        else if (this.Copy_Dealid != null) {
            this._dealNoExistMsg = "Please select Deal.";
            this._isNoteSaving = false;
        }
        else {
            this._dealNoExistMsg = "Note Id, Name can not be empty.";
            this._isNoteSaving = false;
        }
    };
    NoteDetailComponent.prototype.CheckDuplicateNote = function (note) {
        var _this = this;
        var duplicatedNoteMessage = "";
        this.noteService.checkduplicatenote(note).subscribe(function (res) {
            if (res.Succeeded) {
                duplicatedNoteMessage = res.Succeeded;
                _this._noteExistMsg = res.Message;
            }
        });
        return this._noteExistMsg;
    };
    NoteDetailComponent.prototype.ClosePopUp = function () {
        var modal = document.getElementById('myModal');
        this._isNoteSaving = false;
        $('#txtNoteJsonResponse').val('');
        this._isCalcJsonResponseFetched = false;
        modal.style.display = "none";
    };
    NoteDetailComponent.prototype.ClosePopUpScriptEngine = function () {
        var modal = document.getElementById('myModalScriptEngine');
        this._isNoteSaving = false;
        $('#txtNoteJsonResponseForScriptEngine').val('');
        this._isCalcJsonResponseFetched = false;
        modal.style.display = "none";
    };
    NoteDetailComponent.prototype.CloseDeletePopUp = function () {
        var modal = document.getElementById('myModalDelete');
        modal.style.display = "none";
    };
    NoteDetailComponent.prototype.CloseCopyPopUp = function () {
        this._isNoteSaving = false;
        //  this._isNoteSaving = true;
        this._note.CopyName = null;
        this._note.CRENewNoteID = null;
        this.Copy_Dealid = null;
        this.Copy_DealName = null;
        this._note.NewNoteName = null;
        var copymodal = document.getElementById('myModalCopyNote');
        copymodal.style.display = "none";
    };
    NoteDetailComponent.prototype.ClosePopUpDeleteOption = function () {
        var modal = document.getElementById('customdialogbox');
        modal.style.display = "none";
    };
    NoteDetailComponent.prototype.ShowPopUpArchive = function (docid, docname) {
        this._uploadedDocumentLogID = docid;
        this._MsgText = 'Are you sure you want to archive ' + docname + '?';
        var modal = document.getElementById('customdialogarchive');
        modal.style.display = "block";
    };
    NoteDetailComponent.prototype.ClosePopUpArchive = function () {
        var modal = document.getElementById('customdialogarchive');
        modal.style.display = "none";
    };
    NoteDetailComponent.prototype.CloseContextMenuDialog = function () {
        var modal = document.getElementById('ContextMenudialogbox');
        modal.style.display = "none";
    };
    NoteDetailComponent.prototype.checkDropDownChangedsource = function (sender, args) {
        var ac = sender;
        if (ac.selectedIndex > -1) {
            this.SourceAccountID = ac.selectedValue;
            this.PIKSchedule_SourceAccount = ac.selectedItem.Valuekey;
        }
    };
    NoteDetailComponent.prototype.checkDropDownChangedtarget = function (sender, args) {
        var ac = sender;
        if (ac.selectedIndex > -1) {
            this.TargetAccountID = ac.selectedValue;
            this.PIKSchedule_TargetAccount = ac.selectedItem.Valuekey;
        }
    };
    NoteDetailComponent.prototype.getAutosuggestpikFunc = function (query, max, callback) {
        var _this = this;
        var self = this, result = self._cache[query];
        if (result) {
            callback(result);
            return;
        }
        // not in cache, get from server
        var params = { query: query, max: max };
        this._searchObj = new search_1.Search(query);
        this.searchService.getAutosuggestPIKAcccount(this._searchObj, this._pageIndexSearch, this._pageSizeSearch).subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.lstSearch;
                _this._totalCountSearch = res.TotalCount;
                _this._result = data;
                //show message for 1 sec. when no record found
                if (_this._result.length == 0) {
                    setTimeout(function () {
                    }, 1000);
                }
                // add 'DisplayName' property to result
                var items = [];
                for (var i = 0; i < _this._result.length; i++) {
                    var c = _this._result[i];
                    c.DisplayName = c.Valuekey;
                }
                // store result in cache
                self._cache[query] = _this._result;
                // this._isSearchDataFetching = false;
                // and return the result
                callback(_this._result);
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    ////////// Dropdown ///////////////////
    // apply/remove data maps
    NoteDetailComponent.prototype._bindGridDropdows = function () {
        var flexrss = this.flexrss;
        var flexPrepay = this.flexPrepay;
        var flexstripping = this.flexstripping;
        var flexfinancingfee = this.flexfinancingfee;
        var flexFinancingSch = this.flexFinancingSch;
        var flexdefaultsch = this.flexdefaultsch;
        var flexservicelog = this.flexservicelog;
        var futurefundingflex = this.futurefundingflex;
        if (flexrss) {
            var colrssValueType = flexrss.columns.getColumn('ValueTypeText');
            var colrssIntCalcMethod = flexrss.columns.getColumn('IntCalcMethodText');
            var colrssIndexNameText = flexrss.columns.getColumn('IndexNameText');
            if (colrssValueType) {
                colrssValueType.showDropDown = true;
                colrssValueType.dataMap = this._buildDataMap(this.lstRateSpreadSch_ValueType);
                colrssIntCalcMethod.showDropDown = true;
                colrssIntCalcMethod.dataMap = this._buildDataMap(this.lstIntCalcMethodID);
                colrssIndexNameText.showDropDown = true;
                colrssIndexNameText.dataMap = this._buildDataMap(this.lstIndextype);
            }
        }
        if (flexPrepay) {
            var colPrepayValueType = flexPrepay.columns.getColumn('ValueTypeText');
            if (colPrepayValueType) {
                colPrepayValueType.showDropDown = true;
                colPrepayValueType.dataMap = this._buildDataMap(this.lstPrepayAdditinalFee_ValueType);
            }
            var colPrepayApplyTrueUpFeatureText = flexPrepay.columns.getColumn('ApplyTrueUpFeatureText');
            if (colPrepayApplyTrueUpFeatureText) {
                colPrepayApplyTrueUpFeatureText.showDropDown = true;
                colPrepayApplyTrueUpFeatureText.dataMap = this._buildDataMap(this.lstPrepayAdditinalFee_lstApplyTrueUpFeature);
            }
        }
        if (flexstripping) {
            var colstrippingValueType = flexstripping.columns.getColumn('ValueTypeText');
            if (colstrippingValueType) {
                colstrippingValueType.showDropDown = true;
                colstrippingValueType.dataMap = this._buildDataMap(this.lstStrippingSch_ValueType);
            }
        }
        if (flexfinancingfee) {
            var colfinancingfeeValueType = flexfinancingfee.columns.getColumn('ValueTypeText');
            if (colfinancingfeeValueType) {
                colfinancingfeeValueType.showDropDown = true;
                colfinancingfeeValueType.dataMap = this._buildDataMap(this.lstFinancingFeeSch_ValueType);
            }
        }
        if (flexFinancingSch) {
            var colFinancingSchValueType = flexFinancingSch.columns.getColumn('ValueTypeText');
            var colFinancingSchIntCalcMethod = flexFinancingSch.columns.getColumn('IntCalcMethodText');
            var colFinancingSchCurrencyCode = flexFinancingSch.columns.getColumn('CurrencyCodeText');
            var colFinancingSchIndextype = flexFinancingSch.columns.getColumn('IndexTypeText');
            if (colFinancingSchValueType) {
                colFinancingSchValueType.showDropDown = true;
                colFinancingSchValueType.dataMap = this._buildDataMap(this.lstFinancingSch_ValueType);
            }
            if (colFinancingSchIntCalcMethod) {
                colFinancingSchIntCalcMethod.showDropDown = true;
                colFinancingSchIntCalcMethod.dataMap = this._buildDataMap(this.lstIntCalcMethodID);
            }
            if (colFinancingSchCurrencyCode) {
                colFinancingSchCurrencyCode.showDropDown = true;
                colFinancingSchCurrencyCode.dataMap = this._buildDataMap(this.lstLoanCurrency);
            }
            if (colFinancingSchIndextype) {
                colFinancingSchIndextype.showDropDown = true;
                colFinancingSchIndextype.dataMap = this._buildDataMap(this.lstIndextype);
            }
        }
        if (flexdefaultsch) {
            var coldefaultschValueType = flexdefaultsch.columns.getColumn('ValueTypeText');
            if (coldefaultschValueType) {
                coldefaultschValueType.showDropDown = true;
                coldefaultschValueType.dataMap = this._buildDataMap(this.lstDefaultSch_ValueType);
            }
        }
        if (futurefundingflex) {
            var colfuturefundingflexType = futurefundingflex.columns.getColumn('PurposeText');
            if (colfuturefundingflexType) {
                colfuturefundingflexType.showDropDown = true;
                colfuturefundingflexType.dataMap = this._buildDataMap(this.lstPurposeType);
            }
        }
        if (flexservicelog) {
            var colservicelogTransactionType = flexservicelog.columns.getColumn('TransactionTypeText');
            if (colservicelogTransactionType) {
                colservicelogTransactionType.showDropDown = true;
                // colservicelogTransactionType.dataMap.displayMemberPath = 'TransactionName';
                colservicelogTransactionType.dataMap = this._buildDataMapTransaction(this.listtransactiontype);
            }
            //var colOverReas = flexservicelog.columns.getColumn('OverrideReasonText');
            //if (colOverReas) {
            //    colOverReas.showDropDown = true;
            //    colOverReas.dataMap = this._buildDataMap(this.lstddlOverideComment);
            //}
        }
    };
    // build a data map from a string array using the indices as keys
    NoteDetailComponent.prototype._buildDataMap = function (items) {
        var map = [];
        if (items) {
            for (var i = 0; i < items.length; i++) {
                var obj = items[i];
                map.push({ key: obj['LookupID'], value: obj['Name'] });
            }
        }
        return new wjcGrid.DataMap(map, 'key', 'value');
    };
    NoteDetailComponent.prototype._buildDataMapTransaction = function (items) {
        var map = [];
        if (items) {
            for (var i = 0; i < items.length; i++) {
                var obj = items[i];
                map.push({ key: obj['TransactionTypesID'], value: obj['TransactionName'] });
            }
        }
        return new wjcGrid.DataMap(map, 'key', 'value');
    };
    NoteDetailComponent.prototype.rssselectionChanged = function () {
        var flexrss = this.flexrss;
        var rowIdx = this.flexrss.collectionView.currentPosition;
        try {
            var count = this.rssupdatedRowNo.indexOf(rowIdx);
            if (count == -1)
                this.rssupdatedRowNo.push(rowIdx);
        }
        catch (err) {
            console.log(err);
        }
    };
    NoteDetailComponent.prototype.PrepayselectionChanged = function () {
        var flexPrepay = this.flexPrepay;
        var rowIdx = this.flexPrepay.collectionView.currentPosition;
        try {
            var count = this.prepayupdatedRowNo.indexOf(rowIdx);
            if (count == -1)
                this.prepayupdatedRowNo.push(rowIdx);
        }
        catch (err) {
            console.log(err);
        }
    };
    NoteDetailComponent.prototype.strippingselectionChanged = function () {
        var flexstripping = this.flexstripping;
        var rowIdx = this.flexstripping.collectionView.currentPosition;
        try {
            var count = this.strippingupdatedRowNo.indexOf(rowIdx);
            if (count == -1)
                this.strippingupdatedRowNo.push(rowIdx);
        }
        catch (err) {
            console.log(err);
        }
    };
    NoteDetailComponent.prototype.financingfeeselectionChanged = function () {
        var flexfinancingfee = this.flexfinancingfee;
        var rowIdx = this.flexfinancingfee.collectionView.currentPosition;
        try {
            var count = this.financingfeeupdatedRowNo.indexOf(rowIdx);
            if (count == -1)
                this.financingfeeupdatedRowNo.push(rowIdx);
        }
        catch (err) {
            console.log(err);
        }
    };
    NoteDetailComponent.prototype.financingSchselectionChanged = function () {
        var flexFinancingSch = this.flexFinancingSch;
        var rowIdx = this.flexFinancingSch.collectionView.currentPosition;
        try {
            var count = this.flexfinancingschupdatedRowNo.indexOf(rowIdx);
            if (count == -1)
                this.flexfinancingschupdatedRowNo.push(rowIdx);
        }
        catch (err) {
            console.log(err);
        }
    };
    NoteDetailComponent.prototype.defaultschselectionChanged = function () {
        var flexdefaultsch = this.flexdefaultsch;
        var rowIdx = this.flexdefaultsch.collectionView.currentPosition;
        try {
            var count = this.flexdefaultschupdatedRowNo.indexOf(rowIdx);
            if (count == -1)
                this.flexdefaultschupdatedRowNo.push(rowIdx);
        }
        catch (err) {
            console.log(err);
        }
    };
    NoteDetailComponent.prototype.servicelogselectionChanged = function () {
        var flexservicelog = this.flexservicelog;
        var rowIdx = this.flexservicelog.collectionView.currentPosition;
        try {
            var count = this.flexservicelogupdatedRowNo.indexOf(rowIdx);
            if (count == -1)
                this.flexservicelogupdatedRowNo.push(rowIdx);
        }
        catch (err) {
            console.log(err);
        }
    };
    NoteDetailComponent.prototype.futurefundingselectionChanged = function () {
        var futurefundingflex = this.futurefundingflex;
        var rowIdx = this.futurefundingflex.collectionView.currentPosition;
        try {
            var count = this.flexfuturefundingupdatedRowNo.indexOf(rowIdx);
            if (count == -1)
                this.flexfuturefundingupdatedRowNo.push(rowIdx);
        }
        catch (err) {
            console.log(err);
        }
    };
    NoteDetailComponent.prototype.PIKfromPIKSourceNoteTabselectionChanged = function () {
        var Pikflex = this.pikflex;
        var rowIdx = this.pikflex.collectionView.currentPosition;
        try {
            var count = this.flexPikupdatedRowNo.indexOf(rowIdx);
            if (count == -1)
                this.flexPikupdatedRowNo.push(rowIdx);
        }
        catch (err) {
            console.log(err);
        }
    };
    NoteDetailComponent.prototype.LiborScheduleTabSelectionChanged = function () {
        var laborflex = this.laborflex;
        var rowIdx = this.laborflex.collectionView.currentPosition;
        try {
            var count = this.flexLiborupdatedRowNo.indexOf(rowIdx);
            if (count == -1)
                this.flexLiborupdatedRowNo.push(rowIdx);
        }
        catch (err) {
            console.log(err);
        }
    };
    NoteDetailComponent.prototype.FixedAmortselectionChanged = function () {
        var fixedamortflex = this.fixedamortflex;
        var rowIdx = this.fixedamortflex.collectionView.currentPosition;
        try {
            var count = this.flexFixedAmortupdatedRowNo.indexOf(rowIdx);
            if (count == -1)
                this.flexFixedAmortupdatedRowNo.push(rowIdx);
        }
        catch (err) {
            console.log(err);
        }
    };
    NoteDetailComponent.prototype.FeeCouponStripReceivableTabselectionChanged = function () {
        var feecouponflex = this.feecouponflex;
        var rowIdx = this.feecouponflex.collectionView.currentPosition;
        try {
            var count = this.flexfeecouponUpdatedRowNo.indexOf(rowIdx);
            if (count == -1)
                this.flexfeecouponUpdatedRowNo.push(rowIdx);
        }
        catch (err) {
            console.log(err);
        }
    };
    NoteDetailComponent.prototype.showfuturefundingflex = function () {
        var _this = this;
        if (!this.IsOpenshowfuturefundingflex) {
            this._isCallConcurrentCheck = true;
            setTimeout(function () {
                _this.futurefundingflex.invalidate();
                _this.futurefundingflex.autoSizeColumns(0, _this.futurefundingflex.columns.length, false, 20);
                _this.futurefundingflex.columns[0].width = 120; // for Note Id
                _this.IsOpenshowfuturefundingflex = true;
                _this.AppliedReadOnly();
            }, 200);
        }
        this.setFocus();
        setTimeout(function () {
            $('#futurefundingflex .wj-colfooters').parent().css('top', '94%');
            $('#futurefundingflex .wj-bottomleft').parent().css('top', '94%');
        }, 500);
    };
    NoteDetailComponent.prototype.showfixedamortflex = function () {
        var _this = this;
        if (!this.IsOpenshowfixedamortflex) {
            setTimeout(function () {
                _this.fixedamortflex.invalidate();
                _this.IsOpenshowfixedamortflex = true;
            }, 200);
        }
        this.setFocus();
        setTimeout(function () {
            $('#fixedamortflex .wj-colfooters').parent().css('top', '94%');
            $('#fixedamortflex .wj-bottomleft').parent().css('top', '94%');
        }, 500);
    };
    NoteDetailComponent.prototype.showlaborflex = function () {
        var _this = this;
        setTimeout(function () {
            _this.laborflex.invalidate();
        }, 1000);
    };
    NoteDetailComponent.prototype.showfeecouponflex = function () {
        var _this = this;
        if (!this.IsOpenshowfeecouponflex) {
            setTimeout(function () {
                _this.feecouponflex.invalidate();
                _this.IsOpenshowfeecouponflex = true;
            }, 200);
        }
        this.setFocus();
        setTimeout(function () {
            $('#feecouponflex .wj-colfooters').parent().css('top', '94%');
            $('#feecouponflex .wj-bottomleft').parent().css('top', '94%');
        }, 500);
    };
    NoteDetailComponent.prototype.showpikflex = function () {
        var _this = this;
        if (!this.IsOpenshowpikflex) {
            setTimeout(function () {
                _this.pikflex.invalidate();
                _this.IsOpenshowpikflex = true;
            }, 200);
        }
        this.setFocus();
        //For Grid footer Issue.
        setTimeout(function () {
            $('#pikflex .wj-colfooters').parent().css('top', '94%');
            $('#pikflex .wj-bottomleft').parent().css('top', '94%');
        }, 500);
    };
    NoteDetailComponent.prototype.showperiodicoutputflex = function (btnClick) {
        var _this = this;
        if (this.ScenarioId != this.SelectedScenarioId) {
            //if (this.ScenarioId != window.localStorage.getItem("scenarioid")) {
            this._isCashFlowClicked = false;
            this._isnoteperiodiccalcFetching = false;
            this._isnoteperiodiccalcFetched = false;
            if (this.EnableM61Calculations != 4) {
                this._dvEmptynoteperiodiccalcMsg = false;
            }
        }
        if (this.EnableM61Calculations == 4) {
            this._divbatchuploadtext = true;
        }
        if (this._isCashFlowClicked == false) {
            if (!(this.SelectedScenarioId === undefined)) {
                this.ScenarioId = this.SelectedScenarioId;
            }
            else {
                if (this.ScenarioId === undefined) {
                    this.ScenarioId = this._lstScenario.find(function (x) { return x.ScenarioName == "Default"; }).AnalysisID;
                }
                else {
                    this.SelectedScenarioId = this.ScenarioId;
                }
            }
            this._note.AnalysisID = this.ScenarioId;
            this._devDashBoard.NoteID = this._note.NoteId;
            this._devDashBoard.ScenarioID = this.ScenarioId;
            this._devDashBoard.UserID = this._user.UserID;
            this.noteService.getnotecalcinfobynoteId(this._devDashBoard).subscribe(function (res) {
                if (res.Succeeded) {
                    var data = res.dwstatus;
                    if (data != null) {
                        _this._islastCalcDateTime = true;
                        if (data.CalcStatus == "Completed") {
                            _this._note.lastCalcDateTime = data.LastUpdated;
                            _this._note.CalculationStatus = data.CalcStatus;
                        }
                        else {
                            _this.showcalcstatus();
                        }
                    }
                    else {
                        _this._note.CalculationStatus = "";
                    }
                }
            });
            if (btnClick == 'ShowTransactionGrid') {
                this.IsbtnClickText = "ShowTransactionGrid";
                this.getTransactionEntryByNoteId(this._note);
                this._isnoteperiodiccalcFetched = false;
                this._isTransactionEntryFetched = true;
            }
            else {
                this.IsbtnClickText = "ShowPeriodicGrid";
                this.getNotePeriodicCalcByNoteId(this._note);
                this._isnoteperiodiccalcFetched = true;
                this._isTransactionEntryFetched = false;
            }
            this.setFocus();
            this._isCashFlowClicked = true;
        }
        else {
            if (this.IsbtnClickText == "ShowPeriodicGrid") {
                setTimeout(function () {
                    if (this.flexnoteperiodiccalc) {
                        this.flexnoteperiodiccalc.autoSizeColumns(0, this.flexnoteperiodiccalc.columns.length - 1, false, 20);
                    }
                }.bind(this), 3000);
            }
            else if (this.IsbtnClickText == "ShowTransactionGrid") {
                this._dvEmptynoteperiodiccalcMsg = false;
                this._isnoteperiodiccalcFetching = false;
                this._isTransactionEntryFetched = true;
                if (this.lstTransactionEntry) { }
                else {
                    this.ShowEmptyGridText();
                }
                setTimeout(function () {
                    if (this.flexTransactionEntry) {
                        this.flexTransactionEntry.autoSizeColumns(0, this.flexTransactionEntry.columns.length - 1, false, 20);
                        this.flexTransactionEntry.invalidate();
                    }
                }.bind(this), 2000);
            }
        }
    };
    NoteDetailComponent.prototype.showcalcstatus = function () {
        var _this = this;
        if (this.ScenarioId === undefined || this.ScenarioId === null) {
            this.ScenarioId = this._lstScenario.find(function (x) { return x.ScenarioName == "Default"; }).AnalysisID;
        }
        this._devDashBoard.NoteID = this._note.NoteId;
        this._devDashBoard.ScenarioID = this.ScenarioId;
        this._devDashBoard.UserID = this._user.UserID;
        var status = setInterval(function () {
            _this.noteService.getnotecalcinfobynoteId(_this._devDashBoard).subscribe(function (res) {
                if (res.Succeeded) {
                    var data = res.dwstatus;
                    if (!(data.CalcStatus == "Completed")) {
                        _this._note.lastCalcDateTime = data.LastUpdated;
                        _this._note.CalculationStatus = data.CalcStatus;
                    }
                    else {
                        _this.ShowTransaction();
                        _this._note.lastCalcDateTime = data.LastUpdated;
                        _this._note.CalculationStatus = data.CalcStatus;
                        clearInterval(status);
                    }
                }
            });
        }, 2000);
    };
    NoteDetailComponent.prototype.shownoteoutputnpvflex = function () {
        this.getNoteOutputNPVdataByNoteId(this._note);
        this.setFocus();
    };
    NoteDetailComponent.prototype.ClosingTab = function () {
        var _this = this;
        //alert('close');
        if (!this.IsOpenClosingTab) {
            setTimeout(function () {
                //alert('close123456');
                _this.flexPrepay.invalidate(true);
                _this.flexrss.invalidate(true);
                // this.flexstripping.invalidate();
                _this.IsOpenClosingTab = true;
            }, 200);
        }
        this.setFocus();
    };
    NoteDetailComponent.prototype.FinancingTab = function () {
        var _this = this;
        if (!this.IsOpenFinancingTab) {
            setTimeout(function () {
                //alert('close123456');
                _this.flexfinancingfee.invalidate();
                _this.flexFinancingSch.invalidate();
                _this.IsOpenFinancingTab = true;
            }, 200);
        }
        this.setFocus();
    };
    NoteDetailComponent.prototype.ServicingTab = function () {
        var _this = this;
        if (!this.IsOpenServicingTab) {
            setTimeout(function () {
                _this.flexdefaultsch.invalidate();
                _this.IsOpenServicingTab = true;
            }, 200);
        }
        this.setFocus();
    };
    NoteDetailComponent.prototype.Servicinglog = function () {
        var _this = this;
        this._isNoteSaving = true;
        if (!this.IsOpenServicinglogTab) {
            this._isNoteSaving = true;
            setTimeout(function () {
                if (_this.listtransactiontype) {
                    _this.getTransactionTypes();
                }
                _this.flexservicelog.invalidate();
                _this.ServicingLogReadOnly();
                _this.IsOpenServicinglogTab = true;
                _this._isNoteSaving = false;
            }, 1000);
        }
        if (this.IsOpenServicinglogTab == true) {
            this._isNoteSaving = false;
        }
        this.setFocus();
        //setTimeout(function () {
        //    $('#flexservicelog .wj-colfooters').parent().css('top', '94%');
        //    $('#flexservicelog .wj-bottomleft').parent().css('top', '94%');
        //}, 500);
    };
    NoteDetailComponent.prototype.ServicingDropDate = function () {
        var _this = this;
        if (!this.IsOpenServicingDropDateTab) {
            setTimeout(function () {
                _this.flexServicingDropDate.invalidate();
                _this.IsOpenServicingDropDateTab = true;
            }, 200);
        }
        this.setFocus();
    };
    //*****************periodic data code start *****************//
    NoteDetailComponent.prototype.CopyGridDataWithHeader = function (s, e) {
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
    NoteDetailComponent.prototype.getPeriodicDataByNoteId = function (_note) {
        var _this = this;
        this._note = _note;
        this.modulename = _note.modulename;
        this.lstPeriodicDataList = null;
        this._isPeriodicDataFetched = false;
        this._isCalcDataFetched = false;
        this._isCalcJsonFetched = false;
        this._isPeriodicDataFetching = true;
        this._dvEmptyPeriodicDataMsg = false;
        this._note.RequestType = "Calculator";
        if (this.modulename == 'Calculator') {
            this._signalRService.SendCalcNotification("CALCMGR" + '|*|' + appsettings_1.AppSettings._notificationenvironment);
            //run calculator 
            this.RunCalculator();
        }
        else if (this.modulename == 'CalculatorJson') {
            // alert('Calculator');
            //this.SaveNote(this._note);
            var modal = document.getElementById('myModal');
            modal.style.display = "block";
            $.getScript("/js/jsDrag.js");
            if (!!this.MaturityEffectiveDate) {
                if (this._noteext.MaturityScenariosList != null) {
                    this._noteextt.MaturityScenariosList = this._noteext.MaturityScenariosList;
                    this._noteextt.MaturityScenariosList[0].EffectiveDate = this.MaturityEffectiveDate;
                    this._noteextt.MaturityScenariosList[0].Date = this.MaturityDate;
                }
            }
            this._validationobject = this._noteext;
            this._validationobject.noteobj = this._note;
            this.AssignDate();
            this.convertdate();
            this.convertGridDate();
            //==this.ReassignDate();
            this.noteService.validatenote(this._validationobject).subscribe(function (res) {
                if (res.Succeeded) {
                    if (res.Criticalerror == 0) {
                        //this.noteService.addNote(this._note).subscribe(res => {
                        //    if (res.Succeeded) {
                        _this.RunCalculatorForJson();
                        //==================
                        //this.fetchNote();
                        //==================
                        _this._isPeriodicDataFetched = false;
                        _this._isCalcDataFetched = false;
                        _this._isCalcJsonFetched = true;
                        _this._isCashFlowClicked = false;
                        _this.modulename = "Calc JSON";
                        _this._isNoteSaving = false;
                        setTimeout(function () {
                            this.grdCalcData.autoSizeColumns(0, this.grdCalcData.columns.length - 1, false, 20);
                        }.bind(_this), 1000);
                        //     }
                        //});
                        (function (error) { return console.error('Error: ' + error); });
                        //////////////////
                    }
                    else { //close modal div
                        $("#myModal.close").click();
                        _this.ClosePopUp();
                        //this._isExceptionscount = true;
                        // this.flexnoteexceptions.selectionMode = wjcGrid.SelectionMode.None;
                        _this.lstnotesexceptions = res.Allexceptionslist;
                        // this.showflexnoteexceptionsflex();
                        _this.exceptionscount = res.exceptioncount;
                        _this._ShowmessagedivWarnote = true;
                        _this._showexceptionEmptymessage = false;
                        _this._ShowmessagedivMsgWarnote = res.Validationstring;
                        setTimeout(function () {
                            this._ShowmessagedivWar = false;
                        }.bind(_this), 5000);
                    }
                }
            });
            (function (error) { return console.error('Error: ' + error); });
        }
        else {
            var modal = document.getElementById('myModal');
            modal.style.display = "block";
            $.getScript("/js/jsDrag.js");
            _note.MaturityMethodID = 0;
            this.noteService.getHistoricalDataOfModuleByNoteIdAPI(_note, this._pageIndex, this._pageSize).subscribe(function (res) {
                if (res.Succeeded) {
                    if (res.StatusCode != 404) {
                        _this._isPeriodicDataFetched = true;
                        _this._isCalcDataFetched = false;
                        _this._isCalcJsonFetched = false;
                        _this._isPeriodicDataFetching = false;
                        _this._isSetHeaderEmpty = false;
                        switch (_note.modulename) {
                            case "Maturity":
                                _this.modulename = "Maturity";
                                _this.setlstPeriodicDataList = res.lstMaturityScenariosDataContract;
                                //this.gConvertToBindableDate(this.setlstPeriodicDataList);
                                _this._isSetHeaderEmpty = true;
                                break;
                            case "BalanceTransactionSchedule":
                                _this.modulename = "Balance Transaction";
                                break;
                            case "DefaultSchedule":
                                _this.modulename = "Default Schedule";
                                _this.setlstPeriodicDataList = res.lstDefaultScheduleDataContract;
                                _this._isSetHeaderEmpty = true;
                                break;
                            case "FeeCouponSchedule":
                                _this.modulename = "Fee Coupon Schedule";
                                break;
                            case "FinancingFeeSchedule":
                                _this.modulename = "Financing Fee Schedule";
                                _this.setlstPeriodicDataList = res.lstFinancingFeeScheduleDataContract;
                                _this._isSetHeaderEmpty = true;
                                break;
                            case "FinancingSchedule":
                                _this.modulename = "Financing Schedule";
                                _this.setlstPeriodicDataList = res.lstFinancingScheduleDataContract;
                                _this._isSetHeaderEmpty = true;
                                break;
                            case "PIKSchedule":
                                _this.modulename = "PIK Schedule";
                                _this.setlstPeriodicDataList = res.lstPIKSchedule;
                                _this._isSetHeaderEmpty = true;
                                break;
                            case "PrepayAndAdditionalFeeSchedule":
                                _this.modulename = "Prepay And Additional Fee Schedule";
                                _this.setlstPeriodicDataList = res.lstPrepayAndAdditionalFeeScheduleDataContract;
                                _this._isSetHeaderEmpty = true;
                                break;
                            case "RateSpreadSchedule":
                                _this.modulename = "Rate Spread Schedule";
                                _this.setlstPeriodicDataList = res.lstRateSpreadSchedule;
                                _this._isSetHeaderEmpty = true;
                                break;
                            case "ServicingFeeSchedule":
                                _this.modulename = "Servicing Fee Schedule";
                                _this.setlstPeriodicDataList = res.lstNoteServicingFeeScheduleDataContract;
                                _this._isSetHeaderEmpty = true;
                                break;
                            case "StrippingSchedule":
                                _this.modulename = "Stripping Schedule";
                                _this.setlstPeriodicDataList = res.lstStrippingScheduleDataContract;
                                _this._isSetHeaderEmpty = true;
                                break;
                            case "FundingSchedule":
                                _this.modulename = "Funding Schedule";
                                _this.setlstPeriodicDataList = res.lstFundingSchedule;
                                break;
                            case "PIKScheduleDetail":
                                _this.modulename = "PIK Schedule Detail";
                                _this.setlstPeriodicDataList = res.lstPIKScheduleDetail;
                                break;
                            case "LIBORSchedule":
                                _this.modulename = "LIBOR Schedule";
                                _this.setlstPeriodicDataList = res.lstLIBORSchedule;
                                break;
                            case "AmortSchedule":
                                _this.modulename = "Amort Schedule";
                                _this.setlstPeriodicDataList = res.lstAmortSchedule;
                                break;
                            case "FeeCouponStripReceivable":
                                _this.modulename = "Fee Coupon Strip Receivable";
                                _this.setlstPeriodicDataList = res.lstFeeCouponStripReceivable;
                                break;
                            default:
                                break;
                        }
                        if (_note.modulename == 'FundingSchedule') {
                            for (var i = 0; i < _this.setlstPeriodicDataList.length; i++) {
                                if (_this.setlstPeriodicDataList[i].Date != null) {
                                    _this.setlstPeriodicDataList[i].Date = new Date(_this.setlstPeriodicDataList[i].Date.toString());
                                }
                            }
                        }
                        _this.columns = [];
                        //=======================
                        if (_note.modulename == 'FundingSchedule' || _note.modulename == 'PIKScheduleDetail' || _note.modulename == 'LIBORSchedule' || _note.modulename == 'AmortSchedule') {
                            _this.columns = [
                                { header: 'Date', binding: 'Date' },
                            ];
                        }
                        else {
                            if (_note.modulename == 'FeeCouponStripReceivable' || _note.modulename == 'Maturity') {
                            }
                            else {
                                _this.columns = [
                                    { header: '', binding: '0' },
                                ];
                            }
                        }
                        //===================
                        var header = [];
                        var data = _this.setlstPeriodicDataList;
                        //alert("after data fetch");
                        $.each(data, function (obj) {
                            var i = 0;
                            $.each(data[obj], function (key, value) {
                                //alert("key :" + key + " value :" + value);
                                header[i] = key;
                                i = i + 1;
                            });
                            return false;
                        });
                        if (_note.modulename == 'Maturity') {
                            for (var j = 0; j < header.length; j++) {
                                _this.Addcolumn(header[j], header[j], 'p5');
                            }
                        }
                        else {
                            if (_note.modulename == 'LIBORSchedule')
                                for (var j = 1; j < header.length; j++) {
                                    _this.Addcolumn(header[j], header[j], 'p5');
                                }
                            else
                                for (var j = 1; j < header.length; j++) {
                                    _this.Addcolumn(header[j], header[j], 'n2');
                                }
                        }
                        //================
                        if (_note.modulename == 'Maturity')
                            _this._isSetHeaderEmpty = false;
                        _this.lstPeriodicDataList = _this.setlstPeriodicDataList;
                        //var data: any = this.setlstPeriodicDataList;
                        var data = _this.lstPeriodicDataList;
                        _this._totalCount = res.TotalCount;
                        //alert('this._pageIndex' + this._pageIndex);
                        if (_this._pageIndex == 1) {
                            //this.lstPeriodicDataList = this.setlstPeriodicDataList;
                            //if (_note.modulename == "RateSpreadSchedule")
                            if (_this._isSetHeaderEmpty) {
                                _this._isPeriodicDataFetched = true;
                                _this._isCalcDataFetched = false;
                                _this._isCalcJsonFetched = false;
                                data = _this.setlstPeriodicDataList;
                                //this.grdPeriodicData.invalidate();
                                data.forEach(function (obj, i) {
                                    //this.grdPeriodicData.rows.push(new wijmo.grid.Row(obj));
                                    //if (this.grdPeriodicData != null)
                                    {
                                        // alert('i' + this.grdPeriodicData.rows.length + 'data ' + this.lstPeriodicDataList.length);
                                        //if (this.grdPeriodicData.rows.length == this.lstPeriodicDataList.length)
                                        {
                                            setTimeout(function () {
                                                var colCount = _this.grdPeriodicData.columns.length;
                                                for (i = 0; i < colCount; i++) {
                                                    _this.grdPeriodicData.columnHeaders.setCellData(0, i, '');
                                                }
                                                //remove first cell selection
                                                _this.grdPeriodicData.selectionMode = wjcGrid.SelectionMode.None;
                                            }, 20);
                                        }
                                    }
                                });
                            }
                        }
                        else {
                            data.forEach(function (obj, i) {
                                _this.grdPeriodicData.rows.push(new wjcGrid.Row(obj));
                            });
                        }
                        //  this.grdPeriodicData.invalidate(true);
                        //setTimeout(function () {
                        //  this.grdPeriodicData.autoSizeColumns(0, this.grdPeriodicData.columns.length - 1, false, 20);
                        //}.bind(this), 1000);
                        // return true;
                    }
                    else {
                        _this._isPeriodicDataFetching = false;
                        _this.calcExceptionMsg = "No record found";
                        _this._dvEmptyPeriodicDataMsg = true;
                    }
                }
                else {
                    _this._isPeriodicDataFetching = false;
                    _this._dvEmptyPeriodicDataMsg = true;
                    //return true;
                }
            });
        }
        //  return true;
    };
    NoteDetailComponent.prototype.RunCalculator = function () {
        var _this = this;
        //===Run Calculator==========
        this._note.AnalysisID = this.ScenarioId;
        this.noteService.QueueNoteForCalculation(this._note, this._pageIndex, this._pageSize).subscribe(function (res) {
            if (res.Succeeded) {
                _this._isPeriodicDataFetched = false;
                _this._isPeriodicDataFetching = false;
                _this._Showmessagenotediv = true;
                _this._ShowmessagenotedivMsg = res.Message;
                _this.showcalcstatus();
                setTimeout(function () {
                    this._Showmessagenotediv = false;
                    this._ShowmessagenotedivMsg = "";
                    //   console.log(this._ShowmessagedivWar);
                }.bind(_this), 5000);
                return true;
            }
            else {
                _this._ShowmessagedivWarnote = true;
                _this._ShowmessagedivMsgWarnote = "Failed to calculate note, please try after some time. ";
                _this.calcExceptionMsg = res.Message;
                _this._isPeriodicDataFetching = false;
                _this._dvEmptyPeriodicDataMsg = true;
                _this._isCalcDataFetched = false;
                _this._isCalcJsonFetched = false;
                setTimeout(function () {
                    this._ShowmessagedivWar = false;
                    this._ShowmessagenotedivWar = false;
                }.bind(_this), 10000);
                return true;
            }
        });
        //========================
    };
    NoteDetailComponent.prototype.RunCalculatorForJson = function () {
        var _this = this;
        //===Run Calculator==========
        this.noteService.getNoteCalculatorJsonByNoteId(this._note.NoteId).subscribe(function (res) {
            if (res.Succeeded) {
                _this._isPeriodicDataFetched = false;
                _this._isPeriodicDataFetching = false;
                _this.lstPeriodicDataList = res.Message;
                $('#txtNoteJson').val(res.Message);
                //remove first cell selection
                // this.grdCalcData.selectionMode = wijmo.grid.SelectionMode.None;
                return true;
            }
            else {
                _this.calcExceptionMsg = res.Message;
                return true;
            }
        });
        //========================
    };
    NoteDetailComponent.prototype.RunCalculatorByJsonRequest = function () {
        var _this = this;
        //===Run Calculator==========
        // private _note: Note;
        this._isPeriodicDataFetching = true;
        this._note.CalcJSONRequest = $('#txtNoteJson').val();
        this.noteService.getNoteCalculatorDataByJsonRequest(this._note, this._pageIndex, this._pageSize).subscribe(function (res) {
            if (res.Succeeded) {
                _this._isPeriodicDataFetched = false;
                _this._isPeriodicDataFetching = false;
                _this.lstPeriodicDataList = res.Message;
                _this._isCalcJsonResponseFetched = true;
                $('#txtNoteJsonResponse').val(res.Message);
                //remove first cell selection
                // this.grdCalcData.selectionMode = wijmo.grid.SelectionMode.None;
                _this._isPeriodicDataFetching = false;
                return true;
            }
            else {
                _this.calcExceptionMsg = res.Message;
                return true;
            }
        });
        //========================
    };
    NoteDetailComponent.prototype.hideDialog = function () {
        this._isPeriodicDataFetched = false;
        this._isPeriodicDataFetching = true;
        this._dvEmptyPeriodicDataMsg = false;
        this._isCalcDataFetched = false;
        this._isCalcJsonFetched = false;
    };
    //*****************periodic data code end *****************//
    NoteDetailComponent.prototype.DiscardChanges = function () {
        localStorage.setItem('divInfoNote', JSON.stringify(false));
        localStorage.setItem('divSucessNote', JSON.stringify(false));
        localStorage.setItem('divWarNote', JSON.stringify(false));
        //this._router.navigate([this.routes.dashboard.name]);
        window.history.back();
    };
    NoteDetailComponent.prototype.SetClientNoteId = function () {
        if (this._note.ClientNoteID) {
            this._note.ClientNoteID = this._note.CRENoteID;
        }
    };
    NoteDetailComponent.prototype.ConvertDecimalToPercent = function (Data, modulename, IsGrid) {
        if (!IsGrid) {
        }
        else {
            switch (modulename) {
                case "Maturity":
                    break;
                case "BalanceTransactionSchedule":
                    break;
                case "DefaultSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.NoteDefaultScheduleList[i].Value != null) {
                            this._noteext.NoteDefaultScheduleList[i].Value *= 100;
                        }
                    }
                    break;
                case "FeeCouponSchedule":
                    break;
                case "FinancingFeeSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.lstFinancingFeeSchedule[i].Value != null) {
                            this._noteext.lstFinancingFeeSchedule[i].Value *= 100;
                        }
                    }
                    break;
                case "FinancingSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.NoteFinancingScheduleList[i].Value != null) {
                            this._noteext.NoteFinancingScheduleList[i].Value *= 100;
                        }
                    }
                    break;
                case "PIKSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.NotePIKScheduleList[i].Value != null) {
                            this._noteext.NotePIKScheduleList[i].Value *= 100;
                        }
                    }
                    break;
                case "PrepayAndAdditionalFeeSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].Value != null) {
                            this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].Value *= 100;
                        }
                        if (this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].IncludedLevelYield != null) {
                            this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].IncludedLevelYield *= 100;
                        }
                        if (this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].IncludedBasis != null) {
                            this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].IncludedBasis *= 100;
                        }
                        if (this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].PercentageOfFeeToBeStripped != null) {
                            this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].PercentageOfFeeToBeStripped *= 100;
                        }
                    }
                    break;
                case "RateSpreadSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.RateSpreadScheduleList[i].Value != null) {
                            this._noteext.RateSpreadScheduleList[i].Value *= 100;
                        }
                        if (this._noteext.RateSpreadScheduleList[i].RateOrSpreadToBeStripped != null) {
                            this._noteext.RateSpreadScheduleList[i].RateOrSpreadToBeStripped *= 100;
                        }
                    }
                    break;
                case "ServicingFeeSchedule":
                    break;
                case "StrippingSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.NoteStrippingList[i].Value != null) {
                            this._noteext.NoteStrippingList[i].Value *= 100;
                        }
                        if (this._noteext.NoteStrippingList[i].IncludedLevelYield != null) {
                            this._noteext.NoteStrippingList[i].IncludedLevelYield *= 100;
                        }
                        if (this._noteext.NoteStrippingList[i].IncludedBasis != null) {
                            this._noteext.NoteStrippingList[i].IncludedBasis *= 100;
                        }
                    }
                    break;
                case "FundingSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.ListFutureFundingScheduleTab[i].Value != null) {
                            this._noteext.ListFutureFundingScheduleTab[i].Value *= 100;
                        }
                    }
                    break;
                case "PIKScheduleDetail":
                    break;
                case "LIBORSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.ListLiborScheduleTab[i].Value != null) {
                            this._noteext.ListLiborScheduleTab[i].Value *= 100;
                        }
                    }
                    break;
                case "AmortSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.ListFixedAmortScheduleTab[i].Value != null) {
                            this._noteext.ListFixedAmortScheduleTab[i].Value *= 100;
                        }
                    }
                    break;
                case "FeeCouponStripReceivable":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.ListFeeCouponStripReceivable[i].Value != null) {
                            this._noteext.ListFeeCouponStripReceivable[i].Value *= 100;
                        }
                    }
                    break;
                case "Servicinglog":
                    break;
                default:
                    break;
            }
        }
    };
    NoteDetailComponent.prototype.ConvertPercentToDecimal = function (Data, modulename, IsGrid) {
        if (!IsGrid) {
        }
        else {
            switch (modulename) {
                case "Maturity":
                    break;
                case "BalanceTransactionSchedule":
                    break;
                case "DefaultSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.NoteDefaultScheduleList[i].Value != null) {
                            this._noteext.NoteDefaultScheduleList[i].Value /= 100;
                        }
                    }
                    break;
                case "FeeCouponSchedule":
                    break;
                case "FinancingFeeSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.lstFinancingFeeSchedule[i].Value != null) {
                            this._noteext.lstFinancingFeeSchedule[i].Value /= 100;
                        }
                    }
                    break;
                case "FinancingSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.NoteFinancingScheduleList[i].Value != null) {
                            this._noteext.NoteFinancingScheduleList[i].Value /= 100;
                        }
                    }
                    break;
                case "PIKSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.NotePIKScheduleList[i].Value != null) {
                            this._noteext.NotePIKScheduleList[i].Value /= 100;
                        }
                    }
                    break;
                case "PrepayAndAdditionalFeeSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].Value != null) {
                            this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].Value /= 100;
                        }
                        if (this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].IncludedLevelYield != null) {
                            this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].IncludedLevelYield /= 100;
                        }
                        if (this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].IncludedBasis != null) {
                            this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].IncludedBasis /= 100;
                        }
                        if (this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].PercentageOfFeeToBeStripped != null) {
                            this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].PercentageOfFeeToBeStripped /= 100;
                        }
                    }
                    break;
                case "RateSpreadSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.RateSpreadScheduleList[i].Value != null) {
                            this._noteext.RateSpreadScheduleList[i].Value /= 100;
                        }
                    }
                    break;
                case "ServicingFeeSchedule":
                    break;
                case "StrippingSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.NoteStrippingList[i].Value != null) {
                            this._noteext.NoteStrippingList[i].Value /= 100;
                        }
                        if (this._noteext.NoteStrippingList[i].IncludedLevelYield != null) {
                            this._noteext.NoteStrippingList[i].IncludedLevelYield /= 100;
                        }
                        if (this._noteext.NoteStrippingList[i].IncludedBasis != null) {
                            this._noteext.NoteStrippingList[i].IncludedBasis /= 100;
                        }
                    }
                    break;
                case "FundingSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.ListFutureFundingScheduleTab[i].Value != null) {
                            this._noteext.ListFutureFundingScheduleTab[i].Value /= 100;
                        }
                    }
                    break;
                case "PIKScheduleDetail":
                    break;
                case "LIBORSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.ListLiborScheduleTab[i].Value != null) {
                            this._noteext.ListLiborScheduleTab[i].Value /= 100;
                        }
                    }
                    break;
                case "AmortSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.ListFixedAmortScheduleTab[i].Value != null) {
                            this._noteext.ListFixedAmortScheduleTab[i].Value /= 100;
                        }
                    }
                    break;
                case "FeeCouponStripReceivable":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.ListFeeCouponStripReceivable[i].Value != null) {
                            this._noteext.ListFeeCouponStripReceivable[i].Value /= 100;
                        }
                    }
                    break;
                case "Servicinglog":
                    break;
                default:
                    break;
            }
        }
    };
    NoteDetailComponent.prototype.StatusIDChange = function (newvalue) {
        this._note.StatusID = newvalue;
    };
    NoteDetailComponent.prototype.DeletOptionChange = function (newvalueoption) {
        var newval = newvalueoption;
    };
    NoteDetailComponent.prototype.IndexNameIDChange = function (newvalue) {
        this._note.IndexNameID = newvalue.value;
        this._note.IndexNameText = newvalue.selectedOptions[0].label;
        this.getLiborScheduleData();
    };
    NoteDetailComponent.prototype.BaseCurrencyChange = function (newvalue) {
        this._note.BaseCurrencyID = newvalue;
    };
    NoteDetailComponent.prototype.ClientChange = function (newvalue) {
        this._note.ClientID = newvalue;
    };
    NoteDetailComponent.prototype.ServicerNameChange = function (newvalue) {
        this._note.ServicerNameID = newvalue;
    };
    NoteDetailComponent.prototype.InterestCalculationRuleForPaydownsChange = function (newvalue) {
        this._note.InterestCalculationRuleForPaydowns = newvalue;
    };
    NoteDetailComponent.prototype.InterestCalculationRuleForPaydownsAmortChange = function (newvalue) {
        this._note.InterestCalculationRuleForPaydownsAmort = newvalue;
    };
    NoteDetailComponent.prototype.FundChange = function (newvalue) {
        this._note.FundId = newvalue;
    };
    NoteDetailComponent.prototype.FinancingSourceChange = function (newvalue) {
        this._note.FinancingSourceID = newvalue;
    };
    NoteDetailComponent.prototype.DebtTypeChange = function (newvalue) {
        this._note.DebtTypeID = newvalue;
    };
    NoteDetailComponent.prototype.BillingNotesChange = function (newvalue) {
        this._note.BillingNotesID = newvalue;
    };
    NoteDetailComponent.prototype.CapStackChange = function (newvalue) {
        this._note.CapStack = newvalue;
    };
    NoteDetailComponent.prototype.PoolChange = function (newvalue) {
        this._note.PoolID = newvalue;
    };
    NoteDetailComponent.prototype.AccountingModeChange = function (newvalue) {
        this._note.ProspectiveAccountingMode = newvalue;
    };
    NoteDetailComponent.prototype.IsCapitalizedChange = function (newvalue) {
        this._note.IsCapitalized = newvalue;
    };
    NoteDetailComponent.prototype.PIKSeparateCompoundingChange = function (newvalue) {
        this._note.PIKSeparateCompounding = newvalue;
    };
    NoteDetailComponent.prototype.PIKSchedulePIKReasonCodeIDChange = function (newvalue) {
        this.PIKSchedule_PIKReasonCodeID = newvalue;
    };
    NoteDetailComponent.prototype.PIKInterestCalcmethodChange = function (newvalue) {
        this.PIKSchedule_PIKIntCalcMethodID = newvalue;
    };
    NoteDetailComponent.prototype.LoanTypeChange = function (newvalue) {
        this._note.LoanType = newvalue;
    };
    NoteDetailComponent.prototype.ClassificationChange = function (newvalue) {
        this._note.Classification = newvalue;
    };
    NoteDetailComponent.prototype.SubClassificationChange = function (newvalue) {
        this._note.SubClassification = newvalue;
    };
    NoteDetailComponent.prototype.GAAPDesignationChange = function (newvalue) {
        this._note.GAAPDesignation = newvalue;
    };
    NoteDetailComponent.prototype.GeographicLocationChange = function (newvalue) {
        this._note.GeographicLocation = newvalue;
    };
    NoteDetailComponent.prototype.PropertyTypeChange = function (newvalue) {
        this._note.PropertyType = newvalue;
    };
    NoteDetailComponent.prototype.ServicerChange = function (newvalue) {
        this._note.Servicer = newvalue;
    };
    //Enabling M61 Calculation
    NoteDetailComponent.prototype.EnablingCalculationChange = function (newvalue) {
        this._note.EnableM61Calculations = newvalue;
    };
    NoteDetailComponent.prototype.DeleteDataManagementDropdown = function (newvalue) {
        var selectedText = newvalue.target.text;
        selectedText = selectedText.trim();
        this.deleteoptiontext = selectedText.replace('delete', '').trim();
        var LookupID = this.lstNoteDeleteFilter.filter(function (x) { return x.Name == selectedText; })[0].LookupID;
        var customdialogbox = document.getElementById('customdialogbox');
        this._moduledelete.ModuleID = this._note.NoteId;
        this._moduledelete.ModuleName = 'Note';
        this._moduledelete.LookupID = LookupID;
        this._MsgText = 'Are you sure want to delete ' + selectedText + ' for Note ' + this._note.CRENoteID + '?';
        customdialogbox.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    NoteDetailComponent.prototype.SelectedMaturityScenarioChange = function (newvalue) {
        this._note.PropertyType = newvalue;
    };
    NoteDetailComponent.prototype.RateTypeChange = function (newvalue) {
        this._note.RateType = newvalue;
    };
    NoteDetailComponent.prototype.ReAmortizeMonthlyChange = function (newvalue) {
        this._note.ReAmortizeMonthly = newvalue;
    };
    NoteDetailComponent.prototype.ReAmortizeatPMTResetChange = function (newvalue) {
        this._note.ReAmortizeatPMTReset = newvalue;
    };
    NoteDetailComponent.prototype.StubPaidInArrearsChange = function (newvalue) {
        this._note.StubPaidInArrears = newvalue;
    };
    NoteDetailComponent.prototype.RelativePaymentMonthChange = function (newvalue) {
        this._note.RelativePaymentMonth = newvalue;
    };
    NoteDetailComponent.prototype.SettleWithAccrualFlagChange = function (newvalue) {
        this._note.SettleWithAccrualFlag = newvalue;
    };
    NoteDetailComponent.prototype.InterestDueAtMaturityChange = function (newvalue) {
        this._note.InterestDueAtMaturity = newvalue;
    };
    NoteDetailComponent.prototype.DeterminationDateHolidayListChange = function (newvalue) {
        this._note.DeterminationDateHolidayList = newvalue;
    };
    NoteDetailComponent.prototype.StubPaidinAdvanceYNChange = function (newvalue) {
        this._note.StubPaidinAdvanceYN = newvalue;
    };
    NoteDetailComponent.prototype.LoanPurchaseChange = function (newvalue) {
        this._note.LoanPurchase = newvalue;
    };
    NoteDetailComponent.prototype.RoundingMethodChange = function (newvalue) {
        this._note.RoundingMethod = newvalue;
    };
    NoteDetailComponent.prototype.StubInterestPaidonFutureAdvancesChange = function (newvalue) {
        this._note.StubInterestPaidonFutureAdvances = newvalue;
    };
    NoteDetailComponent.prototype.IncludeServicingPaymentOverrideinLevelYieldChange = function (newvalue) {
        this._note.IncludeServicingPaymentOverrideinLevelYield = newvalue;
    };
    NoteDetailComponent.prototype.ModelFinancingDrawsForFutureFundingsChange = function (newvalue) {
        this._note.ModelFinancingDrawsForFutureFundings = newvalue;
    };
    NoteDetailComponent.prototype.FinancingFacilityIDChange = function (newvalue) {
        this._note.FinancingFacilityID = newvalue;
    };
    NoteDetailComponent.prototype.FinancingPayFrequencyChange = function (newvalue) {
        this._note.FinancingPayFrequency = newvalue;
    };
    NoteDetailComponent.prototype.ImpactCommitmentCalcChange = function (newvalue) {
        this._note.ImpactCommitmentCalc = newvalue;
    };
    NoteDetailComponent.prototype.CashflowEngineChange = function (newvalue) {
        if (newvalue == 300) {
            this._isShowCalcbutton = false;
        }
        else {
            this._isShowCalcbutton = true;
        }
    };
    NoteDetailComponent.prototype.FullInterestAtPPayoffChange = function (newvalue) {
        this._note.FullInterestAtPPayoff = newvalue;
    };
    NoteDetailComponent.prototype.RoundingNoteChange = function (newvalue) {
        this._note.RoundingNote = newvalue;
    };
    NoteDetailComponent.prototype.SaveOnly = function (SaveOnly) {
        this.isSaveOnly = SaveOnly;
        this.IsOpenActivityTab = false;
    };
    NoteDetailComponent.prototype.CustomValidator = function () {
        var i;
        var ms;
        ms = "Please fill following fields - ";
        for (i = 0; i < arguments.length; i++) {
            if (arguments[i].value == "")
                ms = ms + arguments[i].name + ", ";
        }
        this.isSaveOnly = false;
        if (ms.length > 31) {
            //ms = ms.left(0, ms.length - 2);
            this.CustomAlert(ms);
        }
        else {
        }
    };
    NoteDetailComponent.prototype.setFocus = function () {
        var ele = document.getElementById('CRENoteID');
        ele.focus();
    };
    NoteDetailComponent.prototype.CustomAlert = function (dialog) {
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
    NoteDetailComponent.prototype.ok = function () {
        document.getElementById('dialogbox').style.display = "none";
        document.getElementById('dialogoverlay').style.display = "none";
    };
    NoteDetailComponent.prototype.Addcolumn = function (header, binding, format) {
        try {
            this.columns.push({ "header": header, "binding": binding, "format": format });
        }
        catch (err) { }
    };
    /*
    convertDatetoGMT(date: Date)
    {
        if (date != null) {
            var d = new Date();
            var dtUTCHours = d.getUTCHours();
    
            date = new Date(date);
            //var _userOffset = date.getTimezoneOffset() * 60 * 1000; // user's offset time
            //var _centralOffset = dtUTCHours * 60 * 60 * 1000; // 6 for central time - use whatever you need
            //date = new Date(date.getTime() - _userOffset + _centralOffset); // redefine variable
            //return date;
    
            //var _date = new Date(1270544790922);
            // outputs > "Tue Apr 06 2010 02:06:30 GMT-0700 (PDT)", for me
           //== date.toLocaleString('fi-FI', { timeZone: 'Europe/Helsinki' });
            // outputs > "6.4.2010 klo 12.06.30"
           //== date.toLocaleString('en-US', { timeZone: 'Europe/Helsinki' });
            // outputs > "4/6/2010, 12:06:30 PM"
    
            date.setMinutes(date.getMinutes() + date.getTimezoneOffset());
            return date;
        }
        else
            return date;
    }
    */
    NoteDetailComponent.prototype.convertDatetoGMT = function (date) {
        if (date != null) {
            //var d = new Date();
            //var dtUTCHours = d.getUTCHours();
            //alert('123 ' + d);
            //alert('dtUTCHours ' + this._dtUTCHours);
            date = new Date(date);
            // check date already redefine or first time call
            if (date.getHours() == 0) {
                ////alert('date getTimezoneOffset' + date.getTimezoneOffset() );
                var _userOffset = date.getTimezoneOffset() * 60 * 1000; // user's offset time
                var _centralOffset = this._dtUTCHours * 60 * 60 * 1000; // 6 for central time - use whatever you need
                //alert('date.getTime() ' + date.getTime());
                date = new Date(date.getTime() - this._userOffset + this._centralOffset); // redefine variable
            }
            return date;
            //var _date = new Date(1270544790922);
            // outputs > "Tue Apr 06 2010 02:06:30 GMT-0700 (PDT)", for me
            //==date.toLocaleString('fi-FI', { timeZone: 'Europe/Helsinki' });
            // outputs > "6.4.2010 klo 12.06.30"
            //date.toLocaleString('en-US', { timeZone: 'Europe/Helsinki' });
            // outputs > "4/6/2010, 12:06:30 PM"
            //var d = new Date('yourDate');
            //date.setMinutes(date.getMinutes() + date.getTimezoneOffset());
            //date = new Date(date.getTime() + date.getTimezoneOffset() * 60000);
            //return date;
        }
        else
            return date;
    };
    NoteDetailComponent.prototype.convertDatetoGMTGrid = function (Data, modulename) {
        if (Data) {
            switch (modulename) {
                case "Maturity":
                    break;
                case "BalanceTransactionSchedule":
                    break;
                case "DefaultSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        //if (this._noteext.NoteDefaultScheduleList[i].EffectiveDate != null) {
                        //    this._noteext.NoteDefaultScheduleList[i].EffectiveDate = this.convertDatetoGMT(this._noteext.NoteDefaultScheduleList[i].EffectiveDate);
                        //}
                        if (this._noteext.NoteDefaultScheduleList[i].StartDate != null) {
                            this._noteext.NoteDefaultScheduleList[i].StartDate = this.convertDatetoGMT(this._noteext.NoteDefaultScheduleList[i].StartDate);
                        }
                        if (this._noteext.NoteDefaultScheduleList[i].EndDate != null) {
                            this._noteext.NoteDefaultScheduleList[i].EndDate = this.convertDatetoGMT(this._noteext.NoteDefaultScheduleList[i].EndDate);
                        }
                    }
                    break;
                case "FeeCouponSchedule":
                    break;
                case "FinancingFeeSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        //if (this._noteext.lstFinancingFeeSchedule[i].EffectiveDate != null) {
                        //    this._noteext.lstFinancingFeeSchedule[i].EffectiveDate = this.convertDatetoGMT(this._noteext.lstFinancingFeeSchedule[i].EffectiveDate);
                        //}
                        if (this._noteext.lstFinancingFeeSchedule[i].Date != null) {
                            this._noteext.lstFinancingFeeSchedule[i].Date = this.convertDatetoGMT(this._noteext.lstFinancingFeeSchedule[i].Date);
                        }
                    }
                    break;
                case "FinancingSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        //if (this._noteext.lstFinancingSchedule[i].EffectiveDate != null) {
                        //    this._noteext.lstFinancingSchedule[i].EffectiveDate = this.convertDatetoGMT(this._noteext.lstFinancingSchedule[i].EffectiveDate);
                        //}
                        if (this._noteext.NoteFinancingScheduleList[i].Date != null) {
                            this._noteext.NoteFinancingScheduleList[i].Date = this.convertDatetoGMT(this._noteext.NoteFinancingScheduleList[i].Date);
                        }
                    }
                    break;
                case "PIKSchedule":
                    break;
                case "PrepayAndAdditionalFeeSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].StartDate != null) {
                            this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].StartDate = this.convertDatetoGMT(this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].StartDate);
                        }
                        if (this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ScheduleEndDate != null) {
                            this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ScheduleEndDate = this.convertDatetoGMT(this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ScheduleEndDate);
                        }
                    }
                    break;
                case "RateSpreadSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        //if (this._noteext.RateSpreadScheduleList[i].EffectiveDate != null) {
                        //    this._noteext.RateSpreadScheduleList[i].EffectiveDate = this.convertDatetoGMT(this._noteext.RateSpreadScheduleList[i].EffectiveDate);
                        //}
                        if (this._noteext.RateSpreadScheduleList[i].Date != null) {
                            this._noteext.RateSpreadScheduleList[i].Date = this.convertDatetoGMT(this._noteext.RateSpreadScheduleList[i].Date);
                            //alert('sam1000 ' + (this._noteext.RateSpreadScheduleList[i].Date));
                        }
                    }
                    break;
                case "ServicingFeeSchedule":
                    break;
                case "StrippingSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.NoteStrippingList[i].StartDate != null) {
                            this._noteext.NoteStrippingList[i].StartDate = this.convertDatetoGMT(this._noteext.NoteStrippingList[i].StartDate);
                        }
                    }
                    break;
                case "FundingSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.ListFutureFundingScheduleTab[i].Date != null) {
                            this._noteext.ListFutureFundingScheduleTab[i].Date = this.convertDatetoGMT(this._noteext.ListFutureFundingScheduleTab[i].Date);
                        }
                    }
                    break;
                case "PIKScheduleDetail":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.ListPIKfromPIKSourceNoteTab[i].Date != null) {
                            this._noteext.ListPIKfromPIKSourceNoteTab[i].Date = this.convertDatetoGMT(this._noteext.ListPIKfromPIKSourceNoteTab[i].Date);
                        }
                    }
                    break;
                case "LIBORSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.ListLiborScheduleTab[i].Date != null) {
                            this._noteext.ListLiborScheduleTab[i].Date = this.convertDatetoGMT(this._noteext.ListLiborScheduleTab[i].Date);
                        }
                    }
                    break;
                case "AmortSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.ListFixedAmortScheduleTab[i].Date != null) {
                            this._noteext.ListFixedAmortScheduleTab[i].Date = this.convertDatetoGMT(this._noteext.ListFixedAmortScheduleTab[i].Date);
                        }
                    }
                    break;
                case "FeeCouponStripReceivable":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.ListFeeCouponStripReceivable[i].Date != null) {
                            this._noteext.ListFeeCouponStripReceivable[i].Date = this.convertDatetoGMT(this._noteext.ListFeeCouponStripReceivable[i].Date);
                        }
                    }
                    break;
                case "Servicinglog":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.lstNoteServicingLog[i].TransactionDate != null) {
                            this._noteext.lstNoteServicingLog[i].TransactionDate = this.convertDatetoGMT(this._noteext.lstNoteServicingLog[i].TransactionDate);
                        }
                        if (this._noteext.lstNoteServicingLog[i].RelatedtoModeledPMTDate != null) {
                            this._noteext.lstNoteServicingLog[i].RelatedtoModeledPMTDate = this.convertDatetoGMT(this._noteext.lstNoteServicingLog[i].RelatedtoModeledPMTDate);
                        }
                        if (this._noteext.lstNoteServicingLog[i].RemittanceDate != null) {
                            this._noteext.lstNoteServicingLog[i].RemittanceDate = this.convertDatetoGMT(this._noteext.lstNoteServicingLog[i].RemittanceDate);
                        }
                    }
                    break;
                case "NotePeriodicCalc":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.lstnotePeriodicOutputs[i].PeriodEndDate != null) {
                            this._noteext.lstnotePeriodicOutputs[i].PeriodEndDate = this.convertDatetoGMT(this._noteext.lstnotePeriodicOutputs[i].PeriodEndDate);
                        }
                        if (this._noteext.lstnotePeriodicOutputs[i].CreatedDate != null) {
                            this._noteext.lstnotePeriodicOutputs[i].CreatedDate = this.convertDatetoGMT(this._noteext.lstnotePeriodicOutputs[i].CreatedDate);
                        }
                        if (this._noteext.lstnotePeriodicOutputs[i].UpdatedDate != null) {
                            this._noteext.lstnotePeriodicOutputs[i].UpdatedDate = this.convertDatetoGMT(this._noteext.lstnotePeriodicOutputs[i].UpdatedDate);
                        }
                    }
                    break;
                case "NoteOutputNPV":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.lstOutputNPVdata[i].NPVdate != null) {
                            this._noteext.lstOutputNPVdata[i].NPVdate = this.convertDatetoGMT(this._noteext.lstOutputNPVdata[i].NPVdate);
                        }
                        if (this._noteext.lstOutputNPVdata[i].CreatedDate != null) {
                            this._noteext.lstOutputNPVdata[i].CreatedDate = this.convertDatetoGMT(this._noteext.lstOutputNPVdata[i].CreatedDate);
                        }
                        if (this._noteext.lstOutputNPVdata[i].UpdatedDate != null) {
                            this._noteext.lstOutputNPVdata[i].UpdatedDate = this.convertDatetoGMT(this._noteext.lstOutputNPVdata[i].UpdatedDate);
                        }
                    }
                    break;
                case "Calculator":
                    for (var i = 0; i < Data.length; i++) {
                        if (this.lstPeriodicDataList[i].PeriodEndDate != null) {
                            this.lstPeriodicDataList[i].PeriodEndDate = this.convertDatetoGMT(this.lstPeriodicDataList[i].PeriodEndDate);
                        }
                        if (this.lstPeriodicDataList[i].CreatedDate != null) {
                            this.lstPeriodicDataList[i].CreatedDate = this.convertDatetoGMT(this.lstPeriodicDataList[i].CreatedDate);
                        }
                        if (this.lstPeriodicDataList[i].UpdatedDate != null) {
                            this.lstPeriodicDataList[i].UpdatedDate = this.convertDatetoGMT(this.lstPeriodicDataList[i].UpdatedDate);
                        }
                    }
                    break;
                case "ServicinglogDropDate":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.lstServicerDropDateSetup[i].ModeledPMTDropDate != null) {
                            this._noteext.lstServicerDropDateSetup[i].ModeledPMTDropDate = this.convertDatetoGMT(this._noteext.lstServicerDropDateSetup[i].ModeledPMTDropDate);
                        }
                        if (this._noteext.lstServicerDropDateSetup[i].PMTDropDateOverride != null) {
                            this._noteext.lstServicerDropDateSetup[i].PMTDropDateOverride = this.convertDatetoGMT(this._noteext.lstServicerDropDateSetup[i].PMTDropDateOverride);
                        }
                    }
                    break;
                default:
                    break;
            }
        }
    };
    NoteDetailComponent.prototype.convertArchieveDatetoGMTGrid = function (Data, modulename) {
        if (Data) {
            switch (modulename) {
                case "PrepayAndAdditionalFeeSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteArchieveext.NotePrepayAndAdditionalFeeScheduleList[i].StartDate != null) {
                            this._noteArchieveext.NotePrepayAndAdditionalFeeScheduleList[i].StartDate = this.convertDatetoGMT(this._noteArchieveext.NotePrepayAndAdditionalFeeScheduleList[i].StartDate);
                        }
                        if (this._noteArchieveext.NotePrepayAndAdditionalFeeScheduleList[i].ScheduleEndDate != null) {
                            this._noteArchieveext.NotePrepayAndAdditionalFeeScheduleList[i].ScheduleEndDate = this.convertDatetoGMT(this._noteArchieveext.NotePrepayAndAdditionalFeeScheduleList[i].ScheduleEndDate);
                        }
                    }
                    break;
                case "RateSpreadSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteArchieveext.RateSpreadScheduleList[i].Date != null) {
                            this._noteArchieveext.RateSpreadScheduleList[i].Date = this.convertDatetoGMT(this._noteArchieveext.RateSpreadScheduleList[i].Date);
                        }
                    }
                    break;
                case "StrippingSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteArchieveext.NoteStrippingList[i].StartDate != null) {
                            this._noteArchieveext.NoteStrippingList[i].StartDate = this.convertDatetoGMT(this._noteArchieveext.NoteStrippingList[i].StartDate);
                        }
                    }
                    break;
                default:
                    break;
            }
        }
    };
    NoteDetailComponent.prototype.convertdate = function () {
        if (this._isConvertDate == false) {
            if (this._note.StartDate != null) {
                this._note.StartDate = this.convertDatetoGMT(this._note.StartDate);
            }
            if (this._note.EndDate != null) {
                this._note.EndDate = this.convertDatetoGMT(this._note.EndDate);
            }
            if (this._note.InitialInterestAccrualEndDate != null) {
                this._note.InitialInterestAccrualEndDate = this.convertDatetoGMT(this._note.InitialInterestAccrualEndDate);
            }
            if (this._note.FirstPaymentDate != null) {
                this._note.FirstPaymentDate = this.convertDatetoGMT(this._note.FirstPaymentDate);
            }
            if (this._note.InitialMonthEndPMTDateBiWeekly != null) {
                this._note.InitialMonthEndPMTDateBiWeekly = this.convertDatetoGMT(this._note.InitialMonthEndPMTDateBiWeekly);
            }
            if (this._note.FinalInterestAccrualEndDateOverride != null) {
                this._note.FinalInterestAccrualEndDateOverride = this.convertDatetoGMT(this._note.FinalInterestAccrualEndDateOverride);
            }
            if (this._note.FirstRateIndexResetDate != null) {
                this._note.FirstRateIndexResetDate = this.convertDatetoGMT(this._note.FirstRateIndexResetDate);
            }
            // if (this._note.SelectedMaturityDate != null) { this._note.SelectedMaturityDate = this.convertDatetoGMT(this._note.SelectedMaturityDate); }
            // if (this._note.InitialMaturityDate != null) { this._note.InitialMaturityDate = this.convertDatetoGMT(this._note.InitialMaturityDate); }
            if (this._note.ExpectedMaturityDate != null) {
                this._note.ExpectedMaturityDate = this.convertDatetoGMT(this._note.ExpectedMaturityDate);
            }
            // if (this._note.FullyExtendedMaturityDate != null) { this._note.FullyExtendedMaturityDate = this.convertDatetoGMT(this._note.FullyExtendedMaturityDate); }
            if (this._note.OpenPrepaymentDate != null) {
                this._note.OpenPrepaymentDate = this.convertDatetoGMT(this._note.OpenPrepaymentDate);
            }
            if (this._note.FinancingInitialMaturityDate != null) {
                this._note.FinancingInitialMaturityDate = this.convertDatetoGMT(this._note.FinancingInitialMaturityDate);
            }
            if (this._note.FinancingExtendedMaturityDate != null) {
                this._note.FinancingExtendedMaturityDate = this.convertDatetoGMT(this._note.FinancingExtendedMaturityDate);
            }
            if (this._note.ClosingDate != null) {
                this._note.ClosingDate = this.convertDatetoGMT(this._note.ClosingDate);
            }
            // if (this._note.ExtendedMaturityScenario1 != null) { this._note.ExtendedMaturityScenario1 = this.convertDatetoGMT(this._note.ExtendedMaturityScenario1); }
            // if (this._note.ExtendedMaturityScenario2 != null) { this._note.ExtendedMaturityScenario2 = this.convertDatetoGMT(this._note.ExtendedMaturityScenario2); }
            // if (this._note.ExtendedMaturityScenario3 != null) { this._note.ExtendedMaturityScenario3 = this.convertDatetoGMT(this._note.ExtendedMaturityScenario3); }
            if (this._note.ActualPayoffDate != null) {
                this._note.ActualPayoffDate = this.convertDatetoGMT(this._note.ActualPayoffDate);
            }
            if (this._note.PurchaseDate != null) {
                this._note.PurchaseDate = this.convertDatetoGMT(this._note.PurchaseDate);
            }
            if (this._note.ValuationDate != null) {
                this._note.ValuationDate = this.convertDatetoGMT(this._note.ValuationDate);
            }
            if (this._note.lastCalcDateTime != null) {
                this._note.lastCalcDateTime = this.convertDatetoGMT(this._note.lastCalcDateTime);
            }
            if (this.MaturityEffectiveDate != null) {
                this.MaturityEffectiveDate = this.convertDatetoGMT(this.MaturityEffectiveDate);
            }
            if (this.MaturityDate != null) {
                this.MaturityDate = this.convertDatetoGMT(this.MaturityDate);
            }
            if (this.Servicing_EffectiveDate != null) {
                this.Servicing_EffectiveDate = this.convertDatetoGMT(this.Servicing_EffectiveDate);
            }
            if (this.Servicing_Date != null) {
                this.Servicing_Date = this.convertDatetoGMT(this.Servicing_Date);
            }
            if (this.PIKSchedule_EffectiveDate != null) {
                this.PIKSchedule_EffectiveDate = this.convertDatetoGMT(this.PIKSchedule_EffectiveDate);
            }
            if (this.PIKSchedule_StartDate != null) {
                this.PIKSchedule_StartDate = this.convertDatetoGMT(this.PIKSchedule_StartDate);
            }
            if (this.PIKSchedule_EndDate != null) {
                this.PIKSchedule_EndDate = this.convertDatetoGMT(this.PIKSchedule_EndDate);
            }
            if (this.Ratespread_EffectiveDate != null) {
                this.Ratespread_EffectiveDate = this.convertDatetoGMT(this.Ratespread_EffectiveDate);
            }
            if (this.PrepayAndAdditionalFeeSchedule_EffectiveDate != null) {
                this.PrepayAndAdditionalFeeSchedule_EffectiveDate = this.convertDatetoGMT(this.PrepayAndAdditionalFeeSchedule_EffectiveDate);
            }
            if (this.StrippingSchedule_EffectiveDate != null) {
                this.StrippingSchedule_EffectiveDate = this.convertDatetoGMT(this.StrippingSchedule_EffectiveDate);
            }
            if (this.FinancingFeeSchedule_EffectiveDate != null) {
                this.FinancingFeeSchedule_EffectiveDate = this.convertDatetoGMT(this.FinancingFeeSchedule_EffectiveDate);
            }
            if (this.FinancingSchedule_EffectiveDate != null) {
                this.FinancingSchedule_EffectiveDate = this.convertDatetoGMT(this.FinancingSchedule_EffectiveDate);
            }
            if (this.DefaultSchedule_EffectiveDate != null) {
                this.DefaultSchedule_EffectiveDate = this.convertDatetoGMT(this.DefaultSchedule_EffectiveDate);
            }
            if (this._note.NoteTransferDate != null) {
                this._note.NoteTransferDate = this.convertDatetoGMT(this._note.NoteTransferDate);
            }
            this._isConvertDate = true;
        }
    };
    NoteDetailComponent.prototype.convertGridDate = function () {
        //Comment "if" for call convertDatetoGMTGrid() all action
        //if (this._isConvertGridDate == false)
        {
            this.convertDatetoGMTGrid(this._noteext.NoteDefaultScheduleList, "DefaultSchedule");
            this.convertDatetoGMTGrid(this._noteext.lstFinancingFeeSchedule, "FinancingFeeSchedule");
            this.convertDatetoGMTGrid(this._noteext.NoteFinancingScheduleList, "FinancingSchedule");
            this.convertDatetoGMTGrid(this._noteext.NotePIKScheduleList, "PIKSchedule");
            this.convertDatetoGMTGrid(this._noteext.NotePrepayAndAdditionalFeeScheduleList, "PrepayAndAdditionalFeeSchedule");
            this.convertDatetoGMTGrid(this._noteext.RateSpreadScheduleList, "RateSpreadSchedule");
            this.convertDatetoGMTGrid(this._noteext.NoteStrippingList, "StrippingSchedule");
            this.convertDatetoGMTGrid(this._noteext.ListFutureFundingScheduleTab, "FundingSchedule");
            this.convertDatetoGMTGrid(this._noteext.ListPIKfromPIKSourceNoteTab, "PIKScheduleDetail");
            this.convertDatetoGMTGrid(this._noteext.ListLiborScheduleTab, "LIBORSchedule");
            this.convertDatetoGMTGrid(this._noteext.ListFixedAmortScheduleTab, "AmortSchedule");
            this.convertDatetoGMTGrid(this._noteext.ListFeeCouponStripReceivable, "FeeCouponStripReceivable");
            this.convertDatetoGMTGrid(this._noteext.lstNoteServicingLog, "Servicinglog");
            this.convertDatetoGMTGrid(this._noteext.lstServicerDropDateSetup, "ServicinglogDropDate");
            this._isConvertGridDate = true;
        }
    };
    NoteDetailComponent.prototype.createDateAsUTC = function (date) {
        if (date)
            return new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds()));
    };
    NoteDetailComponent.prototype.beginningEdit = function (modulename) {
        switch (modulename) {
            case "PIKScheduleDetail":
                //   PIKDetail pikdetail= new PIKDetail();
                var sel = this.pikflex.selection;
                if (this._noteext.ListPIKfromPIKSourceNoteTab[sel.topRow].Date != null)
                    this.prevDateBeforeEdit = this._noteext.ListPIKfromPIKSourceNoteTab[sel.topRow].Date;
                break;
            case "FeeCouponStripReceivable":
                var sel = this.feecouponflex.selection;
                if (this._noteext.ListFeeCouponStripReceivable[sel.topRow].Date != null)
                    this.prevDateBeforeEdit = this._noteext.ListFeeCouponStripReceivable[sel.topRow].Date;
                break;
            case "LIBORSchedule":
                var sel = this.laborflex.selection;
                if (this._noteext.ListLiborScheduleTab[sel.topRow].Date != null)
                    this.prevDateBeforeEdit = this._noteext.ListLiborScheduleTab[sel.topRow].Date;
                break;
            case "AmortSchedule":
                var sel = this.fixedamortflex.selection;
                if (this._noteext.ListFixedAmortScheduleTab[sel.topRow].Date != null)
                    this.prevDateBeforeEdit = this._noteext.ListFixedAmortScheduleTab[sel.topRow].Date;
                break;
            case "FundingSchedule":
                var sel = this.futurefundingflex.selection;
                if (this._noteext.ListFutureFundingScheduleTab[sel.topRow].Date != null)
                    this.prevDateBeforeEdit = this._noteext.ListFutureFundingScheduleTab[sel.topRow].Date;
                break;
            case "Servicelog":
            //var sel = this.flexservicelog.selection;
            //var ss = sel.topRow;
        }
    };
    NoteDetailComponent.prototype.rowEditEnded = function (modulename) {
        var rssformatDate;
        switch (modulename) {
            case "PIKScheduleDetail":
                var sel = this.pikflex.selection;
                var flag = this.CheckDuplicateDate(this._noteext.ListPIKfromPIKSourceNoteTab, sel.topRow);
                if (flag == true) {
                    //   alert("Date " + this._noteext.lstPIKDetailScheduleTab[sel.topRow].Date.toString() + " already in list");
                    var locale = "en-US";
                    var options = { year: "numeric", month: "numeric", day: "numeric" };
                    rssformatDate = this._noteext.ListPIKfromPIKSourceNoteTab[sel.topRow].Date;
                    if (rssformatDate.toString().indexOf("GMT") == -1)
                        this.CustomAlert("Date - " + rssformatDate + " already in list");
                    else
                        this.CustomAlert("Date - " + rssformatDate.toLocaleDateString(locale, options) + " already in list");
                    this._noteext.ListPIKfromPIKSourceNoteTab[sel.topRow].Date = this.prevDateBeforeEdit;
                }
                break;
            case "FeeCouponStripReceivable":
                var sel = this.feecouponflex.selection;
                var flag = this.CheckDuplicateDate(this._noteext.ListFeeCouponStripReceivable, sel.topRow);
                if (flag == true) {
                    // alert("Date " + this._noteext.lstFeeCouponStripReceivableTab[sel.topRow].Date.toString() + " already in list");
                    rssformatDate = this._noteext.ListFeeCouponStripReceivable[sel.topRow].Date;
                    if (rssformatDate.toString().indexOf("GMT") == -1)
                        this.CustomAlert("Date - " + rssformatDate + " already in list");
                    else
                        this.CustomAlert("Date - " + rssformatDate.toLocaleDateString(locale, options) + " already in list");
                    this._noteext.ListFeeCouponStripReceivable[sel.topRow].Date = this.prevDateBeforeEdit;
                }
                break;
            case "LIBORSchedule":
                var sel = this.laborflex.selection;
                var flag = this.CheckDuplicateDate(this._noteext.ListLiborScheduleTab, sel.topRow);
                if (flag == true) {
                    var formatDate;
                    var locale = "en-US";
                    var options = { year: "numeric", month: "numeric", day: "numeric" };
                    formatDate = this._noteext.ListLiborScheduleTab[sel.topRow].Date;
                    if (formatDate.toString().indexOf("GMT") == -1)
                        this.CustomAlert("Date - " + formatDate + " already in list");
                    else
                        this.CustomAlert("Date - " + formatDate.toLocaleDateString(locale, options) + " already in list");
                    this._noteext.ListLiborScheduleTab[sel.topRow].Date = this.prevDateBeforeEdit;
                }
                break;
            case "AmortSchedule":
                var sel = this.fixedamortflex.selection;
                var flag = this.CheckDuplicateDate(this._noteext.ListLiborScheduleTab, sel.topRow);
                if (flag == true) {
                    var formatDate;
                    var locale = "en-US";
                    var options = { year: "numeric", month: "numeric", day: "numeric" };
                    formatDate = this._noteext.ListLiborScheduleTab[sel.topRow].Date;
                    if (formatDate.toString().indexOf("GMT") == -1)
                        this.CustomAlert("Date - " + formatDate + " already in list");
                    else
                        this.CustomAlert("Date - " + formatDate.toLocaleDateString(locale, options) + " already in list");
                    this._noteext.ListLiborScheduleTab[sel.topRow].Date = this.prevDateBeforeEdit;
                }
                break;
        }
        this.prevDateBeforeEdit = null;
    };
    NoteDetailComponent.prototype.CheckDuplicateDate = function (lstData, rwNum) {
        try {
            var i;
            for (i = 0; i < lstData.length; i++)
                if (rwNum != i && lstData[rwNum].Date.toString() == lstData[i].Date.toString())
                    break;
            if (i == lstData.length)
                return false;
            else
                return true;
        }
        catch (err) {
            console.log(err);
        }
    };
    NoteDetailComponent.prototype.addFooterRow = function (flexGrid) {
        var row = new wjcGrid.GroupRow(); // create a GroupRow to show aggregates
        flexGrid.columnFooters.rows.push(row); // add the row to the column footer panel
        flexGrid.bottomLeftCells.setCellData(0, 0, '\u03A3');
        // sigma on the header
    };
    NoteDetailComponent.prototype.addFooterTotalcommitmentRow = function (flexGrid) {
        var row = new wjcGrid.GroupRow(); // create a GroupRow to show aggregates
        flexGrid.columnFooters.rows.push(row); // add the row to the column footer panel
    };
    NoteDetailComponent.prototype.deleteRow = function () {
        //Remove from UI
        //var ecv = <wjcCore.CollectionView>this.futurefundingflex.collectionView;
        //ecv.removeAt(this.deleteRowIndex);
        if (this.modulename == "Rate spread schedule") {
            this.cvRateSpreadScheduleList.removeAt(this.deleteRowIndex);
        }
        if (this.modulename == "Prepay and additional fee schedule") {
            this.cvNotePrepayAndAdditionalFeeScheduleList.removeAt(this.deleteRowIndex);
        }
        if (this.modulename == "Stripping schedule") {
            this.cvNoteStrippingList.removeAt(this.deleteRowIndex);
        }
        if (this.modulename == "Servicing") {
            this.cvNoteServicerDropDateSetup.removeAt(this.deleteRowIndex);
        }
        if (this.modulename == "Servicinglog") {
            console.log("delete Servicinglog");
            this.cvNoteServicingLog.removeAt(this.deleteRowIndex);
            //var count = this.flexservicelogupdatedRowNo.indexOf(this.flexservicelogupdatedRowNo.length - 1);
            //if (count == -1)
            //    this.flexservicelogupdatedRowNo.removeAt(this.flexservicelogupdatedRowNo.length-1);
        }
        if (this.modulename == "Market Price") {
            var rowdeleted = this._note.ListNoteMarketPrice[this.deleteRowIndex];
            this.deleteMarketPriceList.push(rowdeleted);
            this.ListNoteMarketPrice.removeAt(this.deleteRowIndex);
        }
        this.CloseDeletePopUp();
    };
    NoteDetailComponent.prototype.SaveNoteArchieveextralist = function () {
        var _this = this;
        if (this.cvRateSpreadScheduleList.itemsRemoved.length > 0) {
            this._noteArchieveext.RateSpreadScheduleList = [];
            var RateSpreadSchedule = this.cvRateSpreadScheduleList.itemsRemoved;
            for (var i = 0; i < RateSpreadSchedule.length; i++) {
                this._noteArchieveext.RateSpreadScheduleList.push(RateSpreadSchedule[i]);
            }
            for (var i = 0; i < this._noteArchieveext.RateSpreadScheduleList.length; i++) {
                if (!(Number(this._noteArchieveext.RateSpreadScheduleList[i].ValueTypeText).toString() == "NaN" || Number(this._noteArchieveext.RateSpreadScheduleList[i].ValueTypeText) == 0)) {
                    this._noteArchieveext.RateSpreadScheduleList[i].ValueTypeID = Number(this._noteArchieveext.RateSpreadScheduleList[i].ValueTypeText);
                }
                else {
                    var filteredarray = this.lstRateSpreadSch_ValueType.filter(function (x) { return x.Name == _this._noteArchieveext.RateSpreadScheduleList[i].ValueTypeText; });
                    if (filteredarray.length != 0) {
                        this._noteArchieveext.RateSpreadScheduleList[i].ValueTypeID = Number(filteredarray[0].LookupID);
                    }
                }
                if (!(Number(this._noteArchieveext.RateSpreadScheduleList[i].IntCalcMethodText).toString() == "NaN" || Number(this._noteArchieveext.RateSpreadScheduleList[i].IntCalcMethodText) == 0)) {
                    this._noteArchieveext.RateSpreadScheduleList[i].IntCalcMethodID = Number(this._noteArchieveext.RateSpreadScheduleList[i].IntCalcMethodText);
                }
                else {
                    var filteredarray = this.lstIntCalcMethodID.filter(function (x) { return x.Name == _this._noteArchieveext.RateSpreadScheduleList[i].IntCalcMethodText; });
                    if (filteredarray.length != 0) {
                        this._noteArchieveext.RateSpreadScheduleList[i].IntCalcMethodID = Number(filteredarray[0].LookupID);
                    }
                }
                if (!(Number(this._noteArchieveext.RateSpreadScheduleList[i].IndexNameText).toString() == "NaN" || Number(this._noteArchieveext.RateSpreadScheduleList[i].IndexNameText) == 0)) {
                    this._noteArchieveext.RateSpreadScheduleList[i].IndexNameID = Number(this._noteArchieveext.RateSpreadScheduleList[i].IndexNameText);
                }
                else {
                    var filteredarray = this.lstRateSpreadSch_ValueType.filter(function (x) { return x.Name == _this._noteArchieveext.RateSpreadScheduleList[i].IndexNameText; });
                    if (filteredarray.length != 0) {
                        this._noteArchieveext.RateSpreadScheduleList[i].IndexNameID = Number(filteredarray[0].LookupID);
                    }
                }
                this._noteArchieveext.RateSpreadScheduleList[i].EffectiveDate = this.Ratespread_EffectiveDate;
                this._noteArchieveext.RateSpreadScheduleList[i].ModuleId = 14;
            }
        }
        if (this.cvNotePrepayAndAdditionalFeeScheduleList.itemsRemoved.length > 0) {
            this._noteArchieveext.NotePrepayAndAdditionalFeeScheduleList = [];
            var NotePrepayAndAdditionalFeeSchedule = this.cvNotePrepayAndAdditionalFeeScheduleList.itemsRemoved;
            for (var i = 0; i < NotePrepayAndAdditionalFeeSchedule.length; i++) {
                this._noteArchieveext.NotePrepayAndAdditionalFeeScheduleList.push(NotePrepayAndAdditionalFeeSchedule[i]);
            }
            if (this._noteArchieveext.NotePrepayAndAdditionalFeeScheduleList) {
                for (var i = 0; i < this._noteArchieveext.NotePrepayAndAdditionalFeeScheduleList.length; i++) {
                    if (!(Number(this._noteArchieveext.NotePrepayAndAdditionalFeeScheduleList[i].ValueTypeText).toString() == "NaN" || Number(this._noteArchieveext.NotePrepayAndAdditionalFeeScheduleList[i].ValueTypeText) == 0)) {
                        this._noteArchieveext.NotePrepayAndAdditionalFeeScheduleList[i].ValueTypeID = Number(this._noteArchieveext.NotePrepayAndAdditionalFeeScheduleList[i].ValueTypeText);
                    }
                    else {
                        var filteredarray = this.lstPrepayAdditinalFee_ValueType.filter(function (x) { return x.Name == _this._noteArchieveext.NotePrepayAndAdditionalFeeScheduleList[i].ValueTypeText; });
                        if (filteredarray.length != 0) {
                            this._noteArchieveext.NotePrepayAndAdditionalFeeScheduleList[i].ValueTypeID = Number(filteredarray[0].LookupID);
                        }
                    }
                    this._noteArchieveext.NotePrepayAndAdditionalFeeScheduleList[i].EffectiveDate = this.PrepayAndAdditionalFeeSchedule_EffectiveDate;
                    this._noteArchieveext.NotePrepayAndAdditionalFeeScheduleList[i].ModuleId = 13;
                }
            }
        }
        if (this.cvNoteStrippingList.itemsRemoved.length > 0) {
            this._noteArchieveext.NoteStrippingList = [];
            var NoteStripping = this.cvNoteStrippingList.itemsRemoved;
            for (var i = 0; i < NoteStripping.length; i++) {
                this._noteArchieveext.NoteStrippingList.push(NoteStripping[i]);
            }
            if (this._noteArchieveext.NoteStrippingList) {
                for (var i = 0; i < this._noteArchieveext.NoteStrippingList.length; i++) {
                    if (!(Number(this._noteArchieveext.NoteStrippingList[i].ValueTypeText).toString() == "NaN" || Number(this._noteArchieveext.NoteStrippingList[i].ValueTypeText) == 0)) {
                        this._noteArchieveext.NoteStrippingList[i].ValueTypeID = Number(this._noteArchieveext.NoteStrippingList[i].ValueTypeText);
                    }
                    else {
                        var filteredarray = this.lstStrippingSch_ValueType.filter(function (x) { return x.Name == _this._noteArchieveext.NoteStrippingList[i].ValueTypeText; });
                        if (filteredarray.length != 0) {
                            this._noteArchieveext.NoteStrippingList[i].ValueTypeID = Number(filteredarray[0].LookupID);
                        }
                    }
                    this._noteArchieveext.NoteStrippingList[i].EffectiveDate = this.StrippingSchedule_EffectiveDate;
                    this._noteArchieveext.NoteStrippingList[i].ModuleId = 16;
                }
            }
        }
        if (this.cvNoteServicingLog) {
            if (this.cvNoteServicingLog.itemsRemoved.length > 0) {
                this._noteArchieveext.lstNoteServicingLog = [];
                var NoteServicingLog = this.cvNoteServicingLog.itemsRemoved;
                for (var i = 0; i < NoteServicingLog.length; i++) {
                    this._noteArchieveext.lstNoteServicingLog.push(NoteServicingLog[i]);
                }
            }
        }
        this.convertArchieveDatetoGMTGrid(this._noteArchieveext.RateSpreadScheduleList, "RateSpreadSchedule");
        this.convertArchieveDatetoGMTGrid(this._noteArchieveext.NotePrepayAndAdditionalFeeScheduleList, "PrepayAndAdditionalFeeSchedule");
        this.convertArchieveDatetoGMTGrid(this._noteArchieveext.NoteStrippingList, "StrippingSchedule");
        this._noteArchieveextt.RateSpreadScheduleList = this._noteArchieveext.RateSpreadScheduleList;
        this._noteArchieveextt.NotePrepayAndAdditionalFeeScheduleList = this._noteArchieveext.NotePrepayAndAdditionalFeeScheduleList;
        this._noteArchieveextt.NoteStrippingList = this._noteArchieveext.NoteStrippingList;
        this._noteArchieveextt.lstNoteServicingLog = this._noteArchieveext.lstNoteServicingLog;
        this._noteArchieveextt.NoteId = this._note.NoteId;
        //this._noteArchieveextt.noteobj = this._note;
        this.noteService.addNoteArchieveExtralist(this._noteArchieveextt).subscribe(function (res) {
            if (res.Succeeded) {
                //if (savebtnclick) {
                //    this._isNoteSaving = false;
                //    if (res.TotalCount == 0) {
                //        this._copymessagediv = false;
                //        this._isNoteSaveonly = true;
                //        localStorage.setItem('divSucessNote', JSON.stringify(true));
                //        localStorage.setItem('divSucessMsgNote', JSON.stringify(res.Message));
                //    }
                //    else {
                //        this._copymessagediv = false;
                //        this._isNoteSaveonly = true;
                //        localStorage.setItem('divInfoNote', JSON.stringify(true));
                //        localStorage.setItem('divInfoMsgNote', JSON.stringify(res.Message));
                //    }
                //    if (res.Succeeded == false) {
                //        this._copymessagediv = false;
                //        localStorage.setItem('divWarNote', JSON.stringify(true));
                //        localStorage.setItem('divWarMsgNote', JSON.stringify(res.Message));
                //    }
                //    if (this._noteCopyMsg != null) {
                //        //    localStorage.setItem('divSucessNote', JSON.stringify(true));
                //        //    localStorage.setItem('divSucessMsgNote', JSON.stringify(this._noteCopyMsg));
                //        localStorage.setItem('divInfoNote', JSON.stringify(false));
                //        this._copymessagediv = true;
                //        this._copymessagedivMsg = this._noteCopyMsg;
                //        //  this.CloseCopyPopUp();
                //        // this._isNoteSaveonly = false;
                //        if (this._isCopyandopen == true) {
                //            this._copymessagediv = true;
                //            this._copymessagedivMsg = this._noteCopyMsg;
                //            var notenewcopied = ['\notedetail', this._noteextt.NoteId]
                //            this._router.navigate(notenewcopied);
                //        }
                //        else {
                //            this.CloseCopyPopUp();
                //        }
                //        setTimeout(() => {
                //            this._copymessagediv = false;
                //            this._noteCopyMsg = null;
                //        }, 1000);
                //    }
                //    else {
                //        this._router.navigate(['note']);
                //    }
                //}
            }
        });
    };
    NoteDetailComponent.prototype.beginningEditDateAndValue = function (modulename) {
        switch (modulename) {
            case "RateSpreadSchedule":
                var sel = this.flexrss.selection;
                if (this._noteext.RateSpreadScheduleList[sel.topRow].Date != null)
                    this.prevDateBeforeEdit = this._noteext.RateSpreadScheduleList[sel.topRow].Date;
                if (this._noteext.RateSpreadScheduleList[sel.topRow].ValueTypeText != null)
                    this.valueType = this._noteext.RateSpreadScheduleList[sel.topRow].ValueTypeText;
                break;
            case "PrepayAndAdditionalFeeSchedule":
                var sel = this.flexPrepay.selection;
                if (this._noteext.NotePrepayAndAdditionalFeeScheduleList[sel.topRow].StartDate != null)
                    this.prevDateBeforeEdit = this._noteext.NotePrepayAndAdditionalFeeScheduleList[sel.topRow].StartDate;
                if (this._noteext.NotePrepayAndAdditionalFeeScheduleList[sel.topRow].ScheduleEndDate != null)
                    this.prevEndDateBeforeEdit = this._noteext.NotePrepayAndAdditionalFeeScheduleList[sel.topRow].ScheduleEndDate;
                if (this._noteext.NotePrepayAndAdditionalFeeScheduleList[sel.topRow].ValueTypeText != null)
                    this.valueType = this._noteext.NotePrepayAndAdditionalFeeScheduleList[sel.topRow].ValueTypeText;
                break;
            case "StrippingSchedule":
                //alert('Start - StrippingSchedule');
                //alert('sam5555 ' + this._noteext.NoteStrippingList[sel.topRow].StartDate);
                var sel = this.flexstripping.selection;
                if (this._noteext.NoteStrippingList[sel.topRow].StartDate != null)
                    this.prevDateBeforeEdit = this._noteext.NoteStrippingList[sel.topRow].StartDate;
                if (this._noteext.NoteStrippingList[sel.topRow].ValueTypeText != null)
                    this.valueType = this._noteext.NoteStrippingList[sel.topRow].ValueTypeText;
                break;
            case "FinancingFeeSchedule":
                var sel = this.flexfinancingfee.selection;
                if (this._noteext.lstFinancingFeeSchedule[sel.topRow].Date != null)
                    this.prevDateBeforeEdit = this._noteext.lstFinancingFeeSchedule[sel.topRow].Date;
                if (this._noteext.lstFinancingFeeSchedule[sel.topRow].ValueTypeText != null)
                    this.valueType = this._noteext.lstFinancingFeeSchedule[sel.topRow].ValueTypeText;
                break;
            case "FinancingSchedule":
                var sel = this.flexFinancingSch.selection;
                if (this._noteext.lstFinancingFeeSchedule[sel.topRow].Date != null)
                    this.prevDateBeforeEdit = this._noteext.lstFinancingFeeSchedule[sel.topRow].Date;
                if (this._noteext.lstFinancingFeeSchedule[sel.topRow].ValueTypeText != null)
                    this.valueType = this._noteext.lstFinancingFeeSchedule[sel.topRow].ValueTypeText;
                break;
            case "DefaultSchedule":
                var sel = this.flexdefaultsch.selection;
                if (this._noteext.NoteDefaultScheduleList[sel.topRow].StartDate != null)
                    this.prevDateBeforeEdit = this._noteext.NoteDefaultScheduleList[sel.topRow].StartDate;
                if (this._noteext.NoteDefaultScheduleList[sel.topRow].ValueTypeText != null)
                    this.valueType = this._noteext.NoteDefaultScheduleList[sel.topRow].ValueTypeText;
                break;
        }
    };
    NoteDetailComponent.prototype.rowEditEndedDateAndValue = function (modulename) {
        var _this = this;
        switch (modulename) {
            case "RateSpreadSchedule":
                var sel = this.flexrss.selection;
                var rssformatDate;
                var flag = this.CheckDuplicateDateAndValue(this._noteext.RateSpreadScheduleList, sel.topRow);
                if (flag == true) {
                    var formatValuetype = this.lstRateSpreadSch_ValueType.filter(function (x) { return x.LookupID == _this._noteext.RateSpreadScheduleList[sel.topRow].ValueTypeText; });
                    var locale = "en-US";
                    var options = { year: "numeric", month: "numeric", day: "numeric" };
                    rssformatDate = this._noteext.RateSpreadScheduleList[sel.topRow].Date;
                    if (rssformatDate.toString().indexOf("GMT") == -1) {
                        this.CustomAlert("Date - " + rssformatDate + " and value type - " + formatValuetype[0].Name + " already in list");
                    }
                    else {
                        this.CustomAlert("Date - " + rssformatDate.toLocaleDateString(locale, options) + " and value type - " + formatValuetype[0].Name + " already in list");
                    }
                    this._noteext.RateSpreadScheduleList[sel.topRow].Date = this.prevDateBeforeEdit;
                    this._noteext.RateSpreadScheduleList[sel.topRow].ValueTypeText = this.valueType;
                }
                break;
            case "PrepayAndAdditionalFeeSchedule":
                var sel = this.flexPrepay.selection;
                var ppsformatDate;
                var flag = this.CheckDuplicateStartDateAndValue(this._noteext.NotePrepayAndAdditionalFeeScheduleList, sel.topRow);
                if (flag == true) {
                    var formatValuetype = this.lstPrepayAdditinalFee_ValueType.filter(function (x) { return x.LookupID == _this._noteext.NotePrepayAndAdditionalFeeScheduleList[sel.topRow].ValueTypeText; });
                    var locale = "en-US";
                    var options = { year: "numeric", month: "numeric", day: "numeric" };
                    ppsformatDate = this._noteext.NotePrepayAndAdditionalFeeScheduleList[sel.topRow].StartDate;
                    //if (ppsformatDate.toString().indexOf("GMT") == -1)
                    //    this.CustomAlert("Date - " + ppsformatDate + " and value type - " + formatValuetype[0].Name + " already in list");
                    //else
                    //    this.CustomAlert("Date - " + ppsformatDate.toLocaleDateString(locale, options) + " and value type - " + formatValuetype[0].Name + " already in list");
                    //alert("Date " + this._noteext.NotePrepayAndAdditionalFeeScheduleList[sel.topRow].StartDate.toString() + " and value type - " + this._noteext.NotePrepayAndAdditionalFeeScheduleList[sel.topRow].ValueTypeText + " already in list");
                    this._noteext.NotePrepayAndAdditionalFeeScheduleList[sel.topRow].StartDate = this.prevDateBeforeEdit;
                    this._noteext.NotePrepayAndAdditionalFeeScheduleList[sel.topRow].ValueTypeText = this.valueType;
                }
                break;
            case "StrippingSchedule":
                var sel = this.flexstripping.selection;
                var ssformatDate;
                var flag = this.CheckDuplicateStartDateAndValue(this._noteext.NoteStrippingList, sel.topRow);
                if (flag == true) {
                    var formatValuetype = this.lstStrippingSch_ValueType.filter(function (x) { return x.LookupID == _this._noteext.NoteStrippingList[sel.topRow].ValueTypeText; });
                    var locale = "en-US";
                    var options = { year: "numeric", month: "numeric", day: "numeric" };
                    ssformatDate = this._noteext.NoteStrippingList[sel.topRow].StartDate;
                    if (ssformatDate.toString().indexOf("GMT") == -1)
                        this.CustomAlert("Date - " + ssformatDate + " and value type - " + formatValuetype[0].Name + " already in list");
                    else
                        this.CustomAlert("Date - " + ssformatDate.toLocaleDateString(locale, options) + " and value type - " + formatValuetype[0].Name + " already in list");
                    //alert("Date " + this._noteext.NoteStrippingList[sel.topRow].StartDate.toString() + " and value type - " + this._noteext.NoteStrippingList[sel.topRow].ValueTypeText  + " already in list");
                    this._noteext.NoteStrippingList[sel.topRow].StartDate = this.prevDateBeforeEdit;
                    this._noteext.NoteStrippingList[sel.topRow].ValueTypeText = this.valueType;
                }
                break;
            case "FinancingFeeSchedule":
                var sel = this.flexfinancingfee.selection;
                var ssformatDate;
                var flag = this.CheckDuplicateDateAndValue(this._noteext.lstFinancingFeeSchedule, sel.topRow);
                if (flag == true) {
                    var formatValuetype = this.lstFinancingFeeSch_ValueType.filter(function (x) { return x.LookupID == _this._noteext.lstFinancingFeeSchedule[sel.topRow].ValueTypeText; });
                    var locale = "en-US";
                    var options = { year: "numeric", month: "numeric", day: "numeric" };
                    ssformatDate = this._noteext.lstFinancingFeeSchedule[sel.topRow].Date;
                    if (ssformatDate.toString().indexOf("GMT") == -1)
                        this.CustomAlert("Date - " + ssformatDate + " and value type - " + formatValuetype[0].Name + " already in list");
                    else
                        this.CustomAlert("Date - " + ssformatDate.toLocaleDateString(locale, options) + " and value type - " + formatValuetype[0].Name + " already in list");
                    // this._noteext.lstFinancingFeeSchedule[sel.topRow].Date = this.prevDateBeforeEdit;
                    this._noteext.lstFinancingFeeSchedule[sel.topRow].ValueTypeText = '';
                }
                break;
            case "FinancingSchedule":
                var sel = this.flexFinancingSch.selection;
                var ssformatDate;
                var flag = this.CheckDuplicateDateAndValue(this._noteext.NoteFinancingScheduleList, sel.topRow);
                if (flag == true) {
                    var formatValuetype = this.lstFinancingSch_ValueType.filter(function (x) { return x.LookupID == _this._noteext.NoteFinancingScheduleList[sel.topRow].ValueTypeText; });
                    var locale = "en-US";
                    var options = { year: "numeric", month: "numeric", day: "numeric" };
                    ssformatDate = this._noteext.NoteFinancingScheduleList[sel.topRow].Date;
                    if (ssformatDate.toString().indexOf("GMT") == -1)
                        this.CustomAlert("Date - " + ssformatDate + " and value type - " + formatValuetype[0].Name + " already in list");
                    else
                        this.CustomAlert("Date - " + ssformatDate.toLocaleDateString(locale, options) + " and value type - " + formatValuetype[0].Name + " already in list");
                    // this._noteext.lstFinancingFeeSchedule[sel.topRow].Date = this.prevDateBeforeEdit;
                    this._noteext.NoteFinancingScheduleList[sel.topRow].ValueTypeText = '';
                }
                break;
            case "DefaultSchedule":
                var sel = this.flexdefaultsch.selection;
                var ssformatDate;
                var flag = this.CheckDuplicateStartDateAndValue(this._noteext.NoteDefaultScheduleList, sel.topRow);
                if (flag == true) {
                    var formatValuetype = this.lstDefaultSch_ValueType.filter(function (x) { return x.LookupID == _this._noteext.NoteDefaultScheduleList[sel.topRow].ValueTypeText; });
                    var locale = "en-US";
                    var options = { year: "numeric", month: "numeric", day: "numeric" };
                    ssformatDate = this._noteext.NoteDefaultScheduleList[sel.topRow].StartDate;
                    if (ssformatDate.toString().indexOf("GMT") == -1)
                        this.CustomAlert("Date - " + ssformatDate + " and value type - " + formatValuetype[0].Name + " already in list");
                    else
                        this.CustomAlert("Date - " + ssformatDate.toLocaleDateString(locale, options) + " and value type - " + formatValuetype[0].Name + " already in list");
                    // this._noteext.lstFinancingFeeSchedule[sel.topRow].Date = this.prevDateBeforeEdit;
                    this._noteext.NoteDefaultScheduleList[sel.topRow].ValueTypeText = '';
                }
                break;
        }
        this.prevDateBeforeEdit = null;
        this.valueType = null;
    };
    NoteDetailComponent.prototype.CopiedDataValidate = function (modulename) {
        var _this = this;
        try {
            switch (modulename) {
                case "RateSpreadSchedule":
                    var sel = this.flexrss.selection;
                    var rssformatDate;
                    for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
                        var rateValue = (this._noteext.RateSpreadScheduleList[tprow].Value).toString();
                        if (rateValue.includes("%"))
                            this._noteext.RateSpreadScheduleList[tprow].Value = parseFloat(rateValue.substring(0, rateValue.length - 1)) / 100;
                        var flag = this.CheckDuplicateDateAndValue(this._noteext.RateSpreadScheduleList, tprow);
                        if (flag == true) {
                            var formatValuetype = this.lstRateSpreadSch_ValueType.filter(function (x) { return x.LookupID == _this._noteext.RateSpreadScheduleList[tprow].ValueTypeText; });
                            var locale = "en-US";
                            var options = { year: "numeric", month: "numeric", day: "numeric" };
                            rssformatDate = this._noteext.RateSpreadScheduleList[tprow].Date;
                            if (rssformatDate.toString().indexOf("GMT") == -1) {
                                this.CustomAlert("Date - " + rssformatDate + " and value type - " + formatValuetype[0].Name + " already in list");
                            }
                            else {
                                this.CustomAlert("Date - " + rssformatDate.toLocaleDateString(locale, options) + " and value type - " + formatValuetype[0].Name + " already in list");
                            }
                            //this._noteext.RateSpreadScheduleList[tprow].Date = this.prevDateBeforeEdit;
                            this._noteext.RateSpreadScheduleList[tprow].ValueTypeText = "";
                        }
                        break;
                    }
                case "PrepayFeeSchedule":
                    var sel = this.flexPrepay.selection;
                    var prepayformatDate;
                    for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
                        var flag = this.CheckDuplicateStartDateAndValue(this._noteext.NotePrepayAndAdditionalFeeScheduleList, tprow);
                        if (flag == true) {
                            var formatValuetype = this.lstPrepayAdditinalFee_ValueType.filter(function (x) { return x.LookupID == _this._noteext.NotePrepayAndAdditionalFeeScheduleList[tprow].ValueTypeText; });
                            var locale = "en-US";
                            var options = { year: "numeric", month: "numeric", day: "numeric" };
                            prepayformatDate = this._noteext.NotePrepayAndAdditionalFeeScheduleList[tprow].StartDate;
                            //if (prepayformatDate.toString().indexOf("GMT") == -1)
                            //    this.CustomAlert("Date - " + prepayformatDate + " and value type - " + formatValuetype[0].Name + " already in list");
                            //else
                            //    this.CustomAlert("Date - " + prepayformatDate.toLocaleDateString(locale, options) + " and value type - " + formatValuetype[0].Name + " already in list");
                            //this._noteext.RateSpreadScheduleList[tprow].Date = this.prevDateBeforeEdit;
                            // this._noteext.NotePrepayAndAdditionalFeeScheduleList[tprow].ValueTypeText = "";
                        }
                        break;
                    }
                case "StrippingSchedule":
                    var sel = this.flexstripping.selection;
                    var StripSchformatDate;
                    for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
                        var flag = this.CheckDuplicateStartDateAndValue(this._noteext.NoteStrippingList, tprow);
                        if (flag == true) {
                            var formatValuetype = this.lstStrippingSch_ValueType.filter(function (x) { return x.LookupID == _this._noteext.NoteStrippingList[tprow].ValueTypeText; });
                            var locale = "en-US";
                            var options = { year: "numeric", month: "numeric", day: "numeric" };
                            StripSchformatDate = this._noteext.NoteStrippingList[tprow].StartDate;
                            if (StripSchformatDate.toString().indexOf("GMT") == -1)
                                this.CustomAlert("Date - " + StripSchformatDate + " and value type - " + formatValuetype[0].Name + " already in list");
                            else
                                this.CustomAlert("Date - " + StripSchformatDate.toLocaleDateString(locale, options) + " and value type - " + formatValuetype[0].Name + " already in list");
                            //this._noteext.RateSpreadScheduleList[tprow].Date = this.prevDateBeforeEdit;
                            this._noteext.NoteStrippingList[tprow].ValueTypeText = "";
                        }
                        break;
                    }
                case "FinancingFeeSchedule":
                    var sel = this.flexfinancingfee.selection;
                    var StripSchformatDate;
                    for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
                        var flag = this.CheckDuplicateDateAndValue(this._noteext.lstFinancingFeeSchedule, tprow);
                        if (flag == true) {
                            var formatValuetype = this.lstFinancingFeeSch_ValueType.filter(function (x) { return x.LookupID == _this._noteext.lstFinancingFeeSchedule[tprow].ValueTypeText; });
                            var locale = "en-US";
                            var options = { year: "numeric", month: "numeric", day: "numeric" };
                            StripSchformatDate = this._noteext.lstFinancingFeeSchedule[tprow].Date;
                            if (StripSchformatDate.toString().indexOf("GMT") == -1)
                                this.CustomAlert("Date - " + StripSchformatDate + " and value type - " + formatValuetype[0].Name + " already in list");
                            else
                                this.CustomAlert("Date - " + StripSchformatDate.toLocaleDateString(locale, options) + " and value type - " + formatValuetype[0].Name + " already in list");
                            //this._noteext.RateSpreadScheduleList[tprow].Date = this.prevDateBeforeEdit;
                            this._noteext.lstFinancingFeeSchedule[tprow].ValueTypeText = "";
                        }
                        break;
                    }
                case "FinancingSchedule":
                    var sel = this.flexFinancingSch.selection;
                    var StripSchformatDate;
                    for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
                        var flag = this.CheckDuplicateDateAndValue(this._noteext.NoteFinancingScheduleList, tprow);
                        if (flag == true) {
                            var formatValuetype = this.lstFinancingSch_ValueType.filter(function (x) { return x.LookupID == _this._noteext.NoteFinancingScheduleList[tprow].ValueTypeText; });
                            var locale = "en-US";
                            var options = { year: "numeric", month: "numeric", day: "numeric" };
                            StripSchformatDate = this._noteext.NoteFinancingScheduleList[tprow].Date;
                            if (StripSchformatDate.toString().indexOf("GMT") == -1)
                                this.CustomAlert("Date - " + StripSchformatDate + " and value type - " + formatValuetype[0].Name + " already in list");
                            else
                                this.CustomAlert("Date - " + StripSchformatDate.toLocaleDateString(locale, options) + " and value type - " + formatValuetype[0].Name + " already in list");
                            //this._noteext.RateSpreadScheduleList[tprow].Date = this.prevDateBeforeEdit;
                            this._noteext.NoteFinancingScheduleList[tprow].ValueTypeText = "";
                        }
                        break;
                    }
                case "DefaultSchedule":
                    var sel = this.flexdefaultsch.selection;
                    var StripSchformatDate;
                    for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
                        var flag = this.CheckDuplicateStartDateAndValue(this._noteext.NoteDefaultScheduleList, tprow);
                        if (flag == true) {
                            var formatValuetype = this.lstDefaultSch_ValueType.filter(function (x) { return x.LookupID == _this._noteext.NoteDefaultScheduleList[tprow].ValueTypeText; });
                            var locale = "en-US";
                            var options = { year: "numeric", month: "numeric", day: "numeric" };
                            StripSchformatDate = this._noteext.NoteDefaultScheduleList[tprow].StartDate;
                            if (StripSchformatDate.toString().indexOf("GMT") == -1)
                                this.CustomAlert("Date - " + StripSchformatDate + " and value type - " + formatValuetype[0].Name + " already in list");
                            else
                                this.CustomAlert("Date - " + StripSchformatDate.toLocaleDateString(locale, options) + " and value type - " + formatValuetype[0].Name + " already in list");
                            //this._noteext.RateSpreadScheduleList[tprow].Date = this.prevDateBeforeEdit;
                            this._noteext.NoteDefaultScheduleList[tprow].ValueTypeText = "";
                        }
                        break;
                    }
            }
        }
        catch (err) {
            console.log(err);
        }
    };
    NoteDetailComponent.prototype.CopiedValidate = function (modulename) {
        try {
            var StripSchformatDate;
            switch (modulename) {
                case "PIKScheduleDetail":
                    var sel = this.pikflex.selection;
                    for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
                        var flag = this.CheckDuplicateDate(this._noteext.ListPIKfromPIKSourceNoteTab, tprow);
                        if (flag == true) {
                            var locale = "en-US";
                            var options = { year: "numeric", month: "numeric", day: "numeric" };
                            StripSchformatDate = this._noteext.ListPIKfromPIKSourceNoteTab[tprow].Date;
                            if (StripSchformatDate.toString().indexOf("GMT") == -1)
                                this.CustomAlert("Date " + StripSchformatDate + " already in list");
                            else
                                this.CustomAlert("Date " + StripSchformatDate.toLocaleDateString(locale, options) + " already in list");
                            this._noteext.ListPIKfromPIKSourceNoteTab[tprow].Date = null;
                        }
                    }
                case "FeeCouponStripReceivable":
                    var sel = this.feecouponflex.selection;
                    for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
                        var flag = this.CheckDuplicateDate(this._noteext.ListFeeCouponStripReceivable, tprow);
                        if (flag == true) {
                            // alert("Date " + this._noteext.lstFeeCouponStripReceivableTab[tprow].Date.toString() + " already in list");
                            StripSchformatDate = this._noteext.ListFeeCouponStripReceivable[tprow].Date;
                            if (StripSchformatDate.toString().indexOf("GMT") == -1)
                                this.CustomAlert("Date " + StripSchformatDate + " already in list");
                            else
                                this.CustomAlert("Date " + StripSchformatDate.toLocaleDateString(locale, options) + " already in list");
                            this._noteext.ListFeeCouponStripReceivable[sel.topRow].Date = null;
                        }
                    }
                    break;
                case "LIBORSchedule":
                    var sel = this.laborflex.selection;
                    for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
                        var flag = this.CheckDuplicateDate(this._noteext.ListLiborScheduleTab, tprow);
                        if (flag == true) {
                            //  alert("Date " + this._noteext.lstLaborScheduleTab[tprow].Date.toString() + " already in list");
                            StripSchformatDate = this._noteext.ListLiborScheduleTab[tprow].Date;
                            if (StripSchformatDate.toString().indexOf("GMT") == -1)
                                this.CustomAlert("Date " + StripSchformatDate + " already in list");
                            else
                                this.CustomAlert("Date " + StripSchformatDate.toLocaleDateString(locale, options) + " already in list");
                            this._noteext.ListLiborScheduleTab[sel.topRow].Date = null;
                        }
                    }
                    break;
                case "AmortSchedule":
                    var sel = this.fixedamortflex.selection;
                    for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
                        var flag = this.CheckDuplicateDate(this._noteext.ListFixedAmortScheduleTab, tprow);
                        if (flag == true) {
                            //  alert("Date " + this._noteext.lstFixedAmortScheduleTab[tprow].Date.toString() + " already in list");
                            StripSchformatDate = this._noteext.ListFixedAmortScheduleTab[tprow].Date;
                            if (StripSchformatDate.toString().indexOf("GMT") == -1)
                                this.CustomAlert("Date " + StripSchformatDate + " already in list");
                            else
                                this.CustomAlert("Date " + StripSchformatDate.toLocaleDateString(locale, options) + " already in list");
                            this._noteext.ListFixedAmortScheduleTab[tprow].Date = null;
                        }
                    }
                    break;
            }
        }
        catch (err) {
            console.log(err);
        }
    };
    NoteDetailComponent.prototype.CheckDuplicateDateAndValue = function (lstData, rwNum) {
        try {
            var i;
            lstData[rwNum].ValueTypeID = lstData[rwNum].ValueTypeText;
            for (i = 0; i < lstData.length; i++)
                if (rwNum != i && lstData[rwNum].Date.toString() == lstData[i].Date.toString() && lstData[rwNum].ValueTypeID.toString() == lstData[i].ValueTypeID.toString()) {
                    break;
                }
            if (i == lstData.length)
                return false;
            else
                return true;
        }
        catch (err) {
            console.log(err);
        }
    };
    NoteDetailComponent.prototype.CheckDuplicateStartDateAndValue = function (lstData, rwNum) {
        try {
            var i;
            lstData[rwNum].ValueTypeID = lstData[rwNum].ValueTypeText;
            for (i = 0; i < lstData.length; i++)
                if (rwNum != i && lstData[rwNum].StartDate.toString() == lstData[i].StartDate.toString() && lstData[rwNum].ValueTypeID.toString() == lstData[i].ValueTypeID.toString()) {
                    break;
                }
            if (i == lstData.length)
                return false;
            else
                return true;
        }
        catch (err) {
            console.log(err);
        }
    };
    NoteDetailComponent.prototype.checkDroppedDownChangedDeal = function (sender, args) {
        var ac = sender;
        if (ac.selectedIndex == -1) {
            if (ac.text != this.Copy_DealName) {
                this.Copy_Dealid = null;
                this.Copy_DealName = null;
            }
        }
        else {
            this._note.CopyDealID = ac.selectedValue;
            this._note.CopyDealName = ac.selectedItem.Valuekey;
            this.Copy_Dealid = ac.selectedValue;
            this.Copy_DealName = ac.selectedItem.Valuekey;
            this._dealIndex = ac.selectedIndex;
        }
    };
    NoteDetailComponent.prototype.getAutosuggestDealFunc = function (query, max, callback) {
        var _this = this;
        this._result = null;
        this._isSearchDataFetching = true;
        // try getting the result from the cache
        var self = this, result = self._cachedeal[query];
        if (result) {
            this._dvEmptySearchMsg = false;
            this._isSearchDataFetching = false;
            callback(result);
            return;
        }
        // not in cache, get from server
        var params = { query: query, max: max };
        this._searchObj = new search_1.Search(query);
        this.searchService.getAutosuggestSearchDeal(this._searchObj, this._pageIndexSearch, this._pageSizeSearch).subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.lstSearch;
                _this._totalCountSearch = res.TotalCount;
                _this._result = data;
                //show message for 1 sec. when no record found
                if (_this._result.length == 0) {
                    _this._dvEmptySearchMsg = true;
                    setTimeout(function () {
                        _this._dvEmptySearchMsg = false;
                    }, 1000);
                }
                var _valueType;
                // add 'DisplayName' property to result
                var items = [];
                for (var i = 0; i < _this._result.length; i++) {
                    var c = _this._result[i];
                    c.DisplayName = c.Valuekey;
                }
                _this._isSearchDataFetching = false;
                // and return the result
                callback(_this._result);
            }
            else {
                _this.utilityService.navigateToSignIn();
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    //check client is Super admin(Krishna)
    NoteDetailComponent.prototype.ApplyPermissions = function (_object) {
        try {
            var tabarray = _object.filter(function (item) { return item.ModuleType === 'Tab'; });
            for (var i = 0; i < _object.length; i++) {
                if (_object[i].ChildModule == 'Note_Accounting') {
                    this._isShowAccounting = true;
                }
                if (_object[i].ChildModule == 'Note_Closing') {
                    this._isShowClosing = true;
                }
                if (_object[i].ChildModule == 'Note_Financing') {
                    this._isShowFinancing = true;
                }
                if (_object[i].ChildModule == 'Note_Settlement') {
                    this._isShowSettlement = true;
                }
                if (_object[i].ChildModule == 'Note_Servicing') {
                    this._isShowServicing = true;
                }
                if (_object[i].ChildModule == 'Note_ServicingLog') {
                    this._isShowServicelog = true;
                }
                if (_object[i].ChildModule == 'Note_ServicingDropDate') {
                    this._isShowServicingDropDate = true;
                }
                if (_object[i].ChildModule == 'Note_Piksource') {
                    this._isShowPiksource = true;
                }
                if (_object[i].ChildModule == 'Note_Coupon') {
                    this._isShowFeecoupon = true;
                }
                if (_object[i].ChildModule == 'Note_Libor') {
                    this._isShowLibor = true;
                }
                if (_object[i].ChildModule == 'Note_Amort') {
                    this._isShowFixedamort = true;
                }
                if (_object[i].ChildModule == 'Note_Funding') {
                    this._isShowFuturefunding = true;
                }
                if (_object[i].ChildModule == 'Note_Cashflow') {
                    this._isShowPeriodicoutput = true;
                }
                if (_object[i].ChildModule == 'Note_Exceptions') {
                    this._isExceptionscount = true;
                }
                if (_object[i].ChildModule == 'Note_Import') {
                    this._isShowDocImport = true;
                }
                if (_object[i].ChildModule == 'Note_Rules') {
                    this._isShowNoteRules = true;
                }
            }
            this._isShowActivityLog = true;
            //show active tab
            // search to find main in list
            var maintab = _object.filter(function (item) { return item.ChildModule === 'Note_Accounting'; });
            if (maintab.length == 0 || typeof maintab == 'undefined') {
                var str = tabarray[0].ChildModule.split('_')[1];
                str = "a" + str;
                setTimeout(function () {
                    document.getElementById(str).click();
                }.bind(this), 500);
            }
            //Set default tab
            this.SetDefaultTab();
            //apply control permission
            var controlsarry = _object.filter(function (item) { return item.ModuleType === 'Control' && item.RightsName === 'View'; });
            for (var i = 0; i < controlsarry.length; i++) {
                document.getElementById(controlsarry[i].ModuleTabName).removeAttribute('disabled');
            }
            var controlarrayedit = _object.filter(function (item) { return item.ModuleType === 'Control' && item.RightsName === 'Edit'; });
            for (var i = 0; i < controlarrayedit.length; i++) {
                if (controlarrayedit[i].ChildModule == 'btnCalcJson') {
                    this._isSuperAdminUser = true;
                    if (this._note.CashflowEngineID == 300) {
                        this._isShowCalcbutton = false;
                    }
                    else {
                        this._isShowCalcbutton = true;
                    }
                }
                if (controlarrayedit[i].ChildModule == 'btnSaveNote') {
                    this._isshowsavenote = true;
                }
                if (controlarrayedit[i].ChildModule == 'btnCopyNote') {
                    this._isShowCopynote = true;
                }
                if (controlarrayedit[i].ChildModule == 'btnCalcNote') {
                    this._isShowCalcbutton = true;
                }
                if (controlarrayedit[i].ChildModule == 'btnNoteDownloadCashflows') {
                    this._isShowDownloadCashflows = true;
                }
            }
        }
        catch (err) {
            console.log(err);
        }
    };
    NoteDetailComponent.prototype.SetDefaultTab = function () {
        var _this = this;
        this.membershipservice.GetUserDefaultSettingByUserID(this._userdefaultsetting).subscribe(function (res) {
            if (res.Succeeded) {
                var udsetting = res.UserDefaultSetting.filter(function (item) { return item.TypeText === 'UserDefault_Note'; });
                if (udsetting.length > 0) {
                    _this._userdefaultsetting = udsetting[0];
                    var childs = $('#myTab li a').toArray();
                    for (var i = 0; i < childs.length; i++) {
                        var id = $(childs[i]).get(0).id;
                        var text = $(childs[i]).text();
                        var tabname = text.replace(/ /g, '');
                        var defaulttab = _this._userdefaultsetting.Value.replace(/ /g, '');
                        if (tabname.toLowerCase() == defaulttab.toLowerCase()) {
                            var tabid = id;
                            setTimeout(function () {
                                document.getElementById(tabid).click();
                            }.bind(_this), 500);
                            break;
                        }
                    }
                }
            }
            else {
                var tabidnew = "a" + $('#myTab li a').first().get(0).id;
                setTimeout(function () {
                    document.getElementById(tabidnew).click();
                }.bind(_this), 500);
            }
        });
    };
    NoteDetailComponent.prototype.HideAllTabs = function () {
        this._isShowAccounting = false;
        this._isShowClosing = false;
        this._isShowFinancing = false;
        this._isShowSettlement = false;
        this._isShowServicing = false;
        this._isShowServicelog = false;
        this._isShowServicingDropDate = false;
        this._isShowPiksource = false;
        this._isShowFeecoupon = false;
        this._isShowLibor = false;
        this._isShowFixedamort = false;
        this._isShowFuturefunding = false;
        this._isShowPeriodicoutput = false;
        this._isExceptionscount = false;
        this._isSuperAdminUser = false;
        this._isshowsavenote = false;
        this._isShowCalcbutton = false;
        this._isShowCopynote = false;
        this._isShowActivityLog = false;
    };
    NoteDetailComponent.prototype.HideNonSuperAdminUser = function () {
        var ret_val = false;
        var rolename = window.localStorage.getItem("rolename");
        if (rolename != null) {
            if (rolename.toString() == "Super Admin") {
                ret_val = true;
            }
        }
        return ret_val;
    };
    NoteDetailComponent.prototype.downloadNoteCashflowsExportData = function () {
        var _this = this;
        console.log(this._note.StatusID);
        if (this._CritialExceptionListCount > 0) {
            //alert("Please resolve the critical exceptions, recalculate the loan and then try again to download the cashflows.");
            this.CustomAlert("Please resolve the critical exceptions, recalculate the loan and then try again to download the cashflows.");
        }
        else {
            var transactioncategoryname = '';
            var downloadCashFlow = new Note_1.DownloadCashFlow();
            downloadCashFlow.AnalysisID = this.ScenarioId;
            downloadCashFlow.NoteId = this._note.NoteId;
            downloadCashFlow.DealID = "00000000-0000-0000-0000-000000000000";
            downloadCashFlow.Pagename = 'Note';
            downloadCashFlow.MutipleNoteId = '';
            downloadCashFlow.Pagename = 'Note';
            if (this.multiseltransactioncategory != undefined) {
                this.transacatename = this.multiseltransactioncategory.checkedItems.map(function (_a) {
                    var TransactionCategory = _a.TransactionCategory;
                    return TransactionCategory;
                });
                transactioncategoryname = this.multiseltransactioncategory.checkedItems.map(function (_a) {
                    var TransactionCategory = _a.TransactionCategory;
                    return TransactionCategory;
                }).join('|');
                transactioncategoryname = transactioncategoryname.length ? transactioncategoryname : 'Default';
            }
            downloadCashFlow.TransactionCategoryName = transactioncategoryname;
            this._isnoteperiodiccalcFetching = true;
            var filterednames = "";
            if (this.transacatename.length > 0) {
                for (var j = 0; j < this.transacatename.length; j++) {
                    var filtername = this.transacatename[j];
                    filterednames = filterednames + "_" + filtername;
                }
            }
            else {
                filterednames = "_Default";
            }
            if (filterednames == "_Default") {
                filterednames = "";
            }
            else {
                if (filterednames.indexOf("_Default") >= 0) {
                    filterednames = filterednames.replace("_Default", "");
                }
            }
            var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '-');
            var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '-');
            var fileName = this._note.CRENoteID + "_" + this.ScenarioName + filterednames + "_Cashflow_" + displayDate + "_" + displayTime + ".xlsx";
            this.noteService.getNoteCashflowsExportData(downloadCashFlow).subscribe(function (res) {
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
                _this._isnoteperiodiccalcFetching = false;
            });
        }
    };
    NoteDetailComponent.prototype.downloadFile = function (objArray) {
        this._user = JSON.parse(localStorage.getItem('user'));
        var data = this.ConvertToCSV(objArray);
        var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '-');
        var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '-');
        var filterednames = "";
        if (this.transacatename.length > 0) {
            for (var j = 0; j < this.transacatename.length; j++) {
                var filtername = this.transacatename[j];
                filterednames = filterednames + "_" + filtername;
            }
        }
        else {
            filterednames = "_Default";
        }
        //var fileName = "Cashflow_" + window.localStorage.getItem("ScenarioName") + "_" + displayDate + "_" + displayTime + "_" + this._user.Login + ".csv";
        //var fileName = this._note.CRENoteID + filterednames + "_Cashflow_" + displayDate + "_" + displayTime + ".csv";
        //vishal       
        if (filterednames == "_Default") {
            filterednames = "";
        }
        else {
            if (filterednames.indexOf("_Default") >= 0) {
                filterednames = filterednames.replace("_Default", "");
            }
        }
        var fileName = this._note.CRENoteID + "_" + this.ScenarioName + filterednames + "_Cashflow_" + displayDate + "_" + displayTime + ".csv";
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
    NoteDetailComponent.prototype.ConvertToCSV = function (objArray) {
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
    //exportNoteCashflowsExcel() {
    //    wijmo.grid.xlsx.FlexGridXlsxConverter.save(this.flexNoteCashflowsExportDataList, { includeColumnHeaders: true, includeCellStyles: false }, 'NoteCashflow.xlsx');
    //}
    //private ConvertToBindableDateForExportNoteCashflowsExcel(Data, modulename, locale: string) {
    //    var options = { year: "numeric", month: "numeric", day: "numeric" };
    //    for (var i = 0; i < Data.length; i++) {
    //        if (this._noteCashflowsExportDataList.lstNoteCashflowsExportData[i].Date != null) {
    //            this._noteCashflowsExportDataList.lstNoteCashflowsExportData[i].Date = new Date(Data[i].Date.toString().replace('T00', 'T17').split(' ', 4).join(' '));
    //            this._noteCashflowsExportDataList.lstNoteCashflowsExportData[i].DisplayDate = (Data[i].Date.toLocaleDateString("en-US").toString().replace('T00', 'T17').split(' ', 4).join(' '));
    //        }
    //    }
    //}
    NoteDetailComponent.prototype.AssignDate = function () {
        if (this._note.StartDate != null) {
            this._noteDateObjects.StartDate = this._note.StartDate;
        }
        if (this._note.EndDate != null) {
            this._noteDateObjects.EndDate = (this._note.EndDate);
        }
        if (this._note.InitialInterestAccrualEndDate != null) {
            this._noteDateObjects.InitialInterestAccrualEndDate = (this._note.InitialInterestAccrualEndDate);
        }
        if (this._note.FirstPaymentDate != null) {
            this._noteDateObjects.FirstPaymentDate = (this._note.FirstPaymentDate);
        }
        if (this._note.InitialMonthEndPMTDateBiWeekly != null) {
            this._noteDateObjects.InitialMonthEndPMTDateBiWeekly = (this._note.InitialMonthEndPMTDateBiWeekly);
        }
        if (this._note.FinalInterestAccrualEndDateOverride != null) {
            this._noteDateObjects.FinalInterestAccrualEndDateOverride = (this._note.FinalInterestAccrualEndDateOverride);
        }
        if (this._note.FirstRateIndexResetDate != null) {
            this._noteDateObjects.FirstRateIndexResetDate = (this._note.FirstRateIndexResetDate);
        }
        // if (this._note.SelectedMaturityDate != null) { this._noteDateObjects.SelectedMaturityDate = (this._note.SelectedMaturityDate); }
        // if (this._note.InitialMaturityDate != null) { this._noteDateObjects.InitialMaturityDate = (this._note.InitialMaturityDate); }
        if (this._note.ExpectedMaturityDate != null) {
            this._noteDateObjects.ExpectedMaturityDate = (this._note.ExpectedMaturityDate);
        }
        // if (this._note.FullyExtendedMaturityDate != null) { this._noteDateObjects.FullyExtendedMaturityDate = (this._note.FullyExtendedMaturityDate); }
        if (this._note.OpenPrepaymentDate != null) {
            this._noteDateObjects.OpenPrepaymentDate = (this._note.OpenPrepaymentDate);
        }
        if (this._note.FinancingInitialMaturityDate != null) {
            this._noteDateObjects.FinancingInitialMaturityDate = (this._note.FinancingInitialMaturityDate);
        }
        if (this._note.FinancingExtendedMaturityDate != null) {
            this._noteDateObjects.FinancingExtendedMaturityDate = (this._note.FinancingExtendedMaturityDate);
        }
        if (this._note.ClosingDate != null) {
            this._noteDateObjects.ClosingDate = (this._note.ClosingDate);
        }
        // if (this._note.ExtendedMaturityScenario1 != null) { this._noteDateObjects.ExtendedMaturityScenario1 = (this._note.ExtendedMaturityScenario1); }
        // if (this._note.ExtendedMaturityScenario2 != null) { this._noteDateObjects.ExtendedMaturityScenario2 = (this._note.ExtendedMaturityScenario2); }
        //  if (this._note.ExtendedMaturityScenario3 != null) { this._noteDateObjects.ExtendedMaturityScenario3 = (this._note.ExtendedMaturityScenario3); }
        if (this._note.ActualPayoffDate != null) {
            this._noteDateObjects.ActualPayoffDate = (this._note.ActualPayoffDate);
        }
        if (this._note.PurchaseDate != null) {
            this._noteDateObjects.PurchaseDate = (this._note.PurchaseDate);
        }
        if (this._note.ValuationDate != null) {
            this._noteDateObjects.ValuationDate = (this._note.ValuationDate);
        }
        if (this._note.lastCalcDateTime != null) {
            this._noteDateObjects.lastCalcDateTime = (this._note.lastCalcDateTime);
        }
        if (this.MaturityEffectiveDate != null) {
            this._noteDateObjects.MaturityEffectiveDate = (this.MaturityEffectiveDate);
        }
        if (this.MaturityDate != null) {
            this._noteDateObjects.MaturityDate = (this.MaturityDate);
        }
        if (this.Servicing_EffectiveDate != null) {
            this._noteDateObjects.Servicing_EffectiveDate = (this.Servicing_EffectiveDate);
        }
        if (this.Servicing_Date != null) {
            this._noteDateObjects.Servicing_Date = (this.Servicing_Date);
        }
        if (this.PIKSchedule_EffectiveDate != null) {
            this._noteDateObjects.PIKSchedule_EffectiveDate = (this.PIKSchedule_EffectiveDate);
        }
        if (this.PIKSchedule_StartDate != null) {
            this._noteDateObjects.PIKSchedule_StartDate = (this.PIKSchedule_StartDate);
        }
        if (this.PIKSchedule_EndDate != null) {
            this._noteDateObjects.PIKSchedule_EndDate = (this.PIKSchedule_EndDate);
        }
        if (this.Ratespread_EffectiveDate != null) {
            this._noteDateObjects.Ratespread_EffectiveDate = (this.Ratespread_EffectiveDate);
        }
        if (this.PrepayAndAdditionalFeeSchedule_EffectiveDate != null) {
            this._noteDateObjects.PrepayAndAdditionalFeeSchedule_EffectiveDate = (this.PrepayAndAdditionalFeeSchedule_EffectiveDate);
        }
        if (this.StrippingSchedule_EffectiveDate != null) {
            this._noteDateObjects.StrippingSchedule_EffectiveDate = (this.StrippingSchedule_EffectiveDate);
        }
        if (this.FinancingFeeSchedule_EffectiveDate != null) {
            this._noteDateObjects.FinancingFeeSchedule_EffectiveDate = (this.FinancingFeeSchedule_EffectiveDate);
        }
        if (this.FinancingSchedule_EffectiveDate != null) {
            this._noteDateObjects.FinancingSchedule_EffectiveDate = (this.FinancingSchedule_EffectiveDate);
        }
        if (this.DefaultSchedule_EffectiveDate != null) {
            this._noteDateObjects.DefaultSchedule_EffectiveDate = (this.DefaultSchedule_EffectiveDate);
        }
        if (this._note.NoteTransferDate != null) {
            this._noteDateObjects.NoteTransferDate = (this._note.NoteTransferDate);
        }
    };
    NoteDetailComponent.prototype.Addnewfunding = function (e) {
        if (e.col.toString() == "3") {
            this.CustomAlert("Please enter Date or Amount before checking Wire confirm.");
            e.cancel = true;
        }
    };
    NoteDetailComponent.prototype.ReassignDate = function () {
        setTimeout(function () {
            if (this._note.StartDate != null) {
                this._note.StartDate = this._noteDateObjects.StartDate;
            }
            if (this._note.EndDate != null) {
                this._note.EndDate = this._noteDateObjects.EndDate;
            }
            if (this._note.InitialInterestAccrualEndDate != null) {
                this._note.InitialInterestAccrualEndDate = this._noteDateObjects.InitialInterestAccrualEndDate;
            }
            if (this._note.FirstPaymentDate != null) {
                this._note.FirstPaymentDate = this._noteDateObjects.FirstPaymentDate;
            }
            if (this._note.InitialMonthEndPMTDateBiWeekly != null) {
                this._note.InitialMonthEndPMTDateBiWeekly = this._noteDateObjects.InitialMonthEndPMTDateBiWeekly;
            }
            if (this._note.FinalInterestAccrualEndDateOverride != null) {
                this._note.FinalInterestAccrualEndDateOverride = this._noteDateObjects.FinalInterestAccrualEndDateOverride;
            }
            if (this._note.FirstRateIndexResetDate != null) {
                this._note.FirstRateIndexResetDate = this._noteDateObjects.FirstRateIndexResetDate;
            }
            if (this._note.SelectedMaturityDate != null) {
                this._note.SelectedMaturityDate = this._noteDateObjects.SelectedMaturityDate;
            }
            if (this._note.InitialMaturityDate != null) {
                this._note.InitialMaturityDate = this._noteDateObjects.InitialMaturityDate;
            }
            if (this._note.ExpectedMaturityDate != null) {
                this._note.ExpectedMaturityDate = this._noteDateObjects.ExpectedMaturityDate;
            }
            if (this._note.FullyExtendedMaturityDate != null) {
                this._note.FullyExtendedMaturityDate = this._noteDateObjects.FullyExtendedMaturityDate;
            }
            if (this._note.OpenPrepaymentDate != null) {
                this._note.OpenPrepaymentDate = this._noteDateObjects.OpenPrepaymentDate;
            }
            if (this._note.FinancingInitialMaturityDate != null) {
                this._note.FinancingInitialMaturityDate = this._noteDateObjects.FinancingInitialMaturityDate;
            }
            if (this._note.FinancingExtendedMaturityDate != null) {
                this._note.FinancingExtendedMaturityDate = this._noteDateObjects.FinancingExtendedMaturityDate;
            }
            if (this._note.ClosingDate != null) {
                this._note.ClosingDate = this._noteDateObjects.ClosingDate;
            }
            if (this._note.ExtendedMaturityScenario1 != null) {
                this._note.ExtendedMaturityScenario1 = this._noteDateObjects.ExtendedMaturityScenario1;
            }
            if (this._note.ExtendedMaturityScenario2 != null) {
                this._note.ExtendedMaturityScenario2 = this._noteDateObjects.ExtendedMaturityScenario2;
            }
            if (this._note.ExtendedMaturityScenario3 != null) {
                this._note.ExtendedMaturityScenario3 = this._noteDateObjects.ExtendedMaturityScenario3;
            }
            if (this._note.ActualPayoffDate != null) {
                this._note.ActualPayoffDate = this._noteDateObjects.ActualPayoffDate;
            }
            if (this._note.PurchaseDate != null) {
                this._note.PurchaseDate = this._noteDateObjects.PurchaseDate;
            }
            if (this._note.ValuationDate != null) {
                this._note.ValuationDate = this._noteDateObjects.ValuationDate;
            }
            if (this._note.lastCalcDateTime != null) {
                this._note.lastCalcDateTime = this._noteDateObjects.lastCalcDateTime;
            }
            if (this.MaturityEffectiveDate != null) {
                this.MaturityEffectiveDate = this._noteDateObjects.MaturityEffectiveDate;
            }
            if (this.MaturityDate != null) {
                this.MaturityDate = this._noteDateObjects.MaturityDate;
            }
            if (this.Servicing_EffectiveDate != null) {
                this.Servicing_EffectiveDate = this._noteDateObjects.Servicing_EffectiveDate;
            }
            if (this.Servicing_Date != null) {
                this.Servicing_Date = this._noteDateObjects.Servicing_Date;
            }
            if (this.PIKSchedule_EffectiveDate != null) {
                this.PIKSchedule_EffectiveDate = this._noteDateObjects.PIKSchedule_EffectiveDate;
            }
            if (this.PIKSchedule_StartDate != null) {
                this.PIKSchedule_StartDate = this._noteDateObjects.PIKSchedule_StartDate;
            }
            if (this.PIKSchedule_EndDate != null) {
                this.PIKSchedule_EndDate = this._noteDateObjects.PIKSchedule_EndDate;
            }
            if (this.Ratespread_EffectiveDate != null) {
                this.Ratespread_EffectiveDate = this._noteDateObjects.Ratespread_EffectiveDate;
            }
            if (this.PrepayAndAdditionalFeeSchedule_EffectiveDate != null) {
                this.PrepayAndAdditionalFeeSchedule_EffectiveDate = this._noteDateObjects.PrepayAndAdditionalFeeSchedule_EffectiveDate;
            }
            if (this.StrippingSchedule_EffectiveDate != null) {
                this.StrippingSchedule_EffectiveDate = this._noteDateObjects.StrippingSchedule_EffectiveDate;
            }
            if (this.FinancingFeeSchedule_EffectiveDate != null) {
                this.FinancingFeeSchedule_EffectiveDate = this._noteDateObjects.FinancingFeeSchedule_EffectiveDate;
            }
            if (this.FinancingSchedule_EffectiveDate != null) {
                this.FinancingSchedule_EffectiveDate = this._noteDateObjects.FinancingSchedule_EffectiveDate;
            }
            if (this.DefaultSchedule_EffectiveDate != null) {
                this.DefaultSchedule_EffectiveDate = this._noteDateObjects.DefaultSchedule_EffectiveDate;
            }
            if (this._note.NoteTransferDate != null) {
                this._note.NoteTransferDate = this._noteDateObjects.NoteTransferDate;
            }
        }.bind(this), 30000);
    };
    NoteDetailComponent.prototype.ValidateNoteAndSave = function () {
        var _this = this;
        var errorstring = "";
        var effectiveerror = "";
        var amorterrorstring = "";
        var purposeerrorstring = "";
        var msg = "";
        var msgmatfundingdate = "";
        var msgdialog = "";
        var fundingdateval = "";
        var RuleTypeFileNameerror = '';
        var currentdate = new Date();
        var currentmatdate;
        var errorlstmarketprice = "";
        var errmarketprice = "";
        //if (this._note.ActualPayoffDate != null) {
        //    currentmatdate = this._note.ActualPayoffDate
        //} else {
        //    if (this._note.SelectedMaturityDate < currentdate) {
        //        if (this._note.ExtendedMaturityScenario1 < currentdate) {
        //            if (this._note.ExtendedMaturityScenario2 < currentdate) {
        //                if (this._note.ExtendedMaturityScenario3 < currentdate) {
        //                    if (this._note.FullyExtendedMaturityDate < currentdate) {
        //                        currentmatdate = currentdate;
        //                    }
        //                    else {
        //                        currentmatdate = this._note.FullyExtendedMaturityDate;
        //                    }
        //                }
        //                else {
        //                    currentmatdate = this._note.ExtendedMaturityScenario3;
        //                }
        //            } else {
        //                currentmatdate = this._note.ExtendedMaturityScenario2;
        //            }
        //        }
        //        else {
        //            currentmatdate = this._note.ExtendedMaturityScenario1;
        //        }
        //    } else {
        //        currentmatdate = this._note.SelectedMaturityDate;
        //    }
        //}
        for (var i = 0; i < this._noteext.RateSpreadScheduleList.length; i++) {
            if (this._noteext.RateSpreadScheduleList[i].ValueTypeText) {
                if (!(this._noteext.RateSpreadScheduleList[i].Date)) {
                    //var a = this._noteext.RateSpreadScheduleList[i].Date;
                    amorterrorstring = "<p>" + "Please enter rate spread schedule start date." + "</p>";
                }
            }
        }
        for (var i = 0; i < this._noteext.NotePrepayAndAdditionalFeeScheduleList.length; i++) {
            if (this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ValueTypeText) {
                if (!(this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].StartDate)) {
                    //var a = this._noteext.RateSpreadScheduleList[i].Date;
                    amorterrorstring = amorterrorstring + "<p>" + "Please enter prepay and additional start date." + "</p>";
                }
            }
        }
        for (var i = 0; i < this._noteext.NoteStrippingList.length; i++) {
            if (this._noteext.NoteStrippingList[i].ValueTypeText) {
                if (!(this._noteext.NoteStrippingList[i].StartDate)) {
                    //var a = this._noteext.RateSpreadScheduleList[i].Date;
                    amorterrorstring = amorterrorstring + "<p>" + "Please enter note stripping start date." + "</p>";
                }
            }
        }
        if (this.chkDateValidation()) {
            var totalamort = 0;
            //totalamortfnding
            if (this._note.ClosingDate != null) {
                var cdate = (this._note.ClosingDate);
                var amortdata = this._noteext.ListFixedAmortScheduleTab;
                if (amortdata) {
                    for (var i = 0; i < amortdata.length; i++) {
                        if (amortdata[i].Date != null) {
                            if (amortdata[i].Value < 0) {
                                amorterrorstring = amorterrorstring + "<p>" + "Negative amortization amounts (fundings) are not permitted. Funding need to be entered through Funding tab." + "</p>";
                            }
                            totalamort = totalamort + amortdata[i].Value;
                        }
                    }
                }
                if (totalamort > this._note.TotalCommitment) {
                    amorterrorstring = amorterrorstring + "<p>" + "The total of amort payments should not be greater than the Total Commitment amount(Accounting tab) of the note" + "</p>";
                }
                if (this.PIKSchedule_EffectiveDate != null) {
                    var newdate = (this.PIKSchedule_EffectiveDate);
                    var olddate = (this.PIKSchedule_EffectiveDateOld);
                    if (newdate < olddate) {
                        effectiveerror = effectiveerror + "<p>" + "Effective date in pik schedule cannot be smaller than " + olddate.toLocaleDateString("en-US").toString().replace('T00', 'T17').split(' ', 4).join(' ') + "</p>";
                    }
                }
            }
            //Note Market Price
            var flag = false;
            for (var j = 0; j < this._note.ListNoteMarketPrice.length; j++) {
                if (this.originallstnotemarketprice.length > 0) {
                    flag = false;
                    for (var m = 0; m < this.originallstnotemarketprice.length; m++) {
                        if (Object.keys(this._note.ListNoteMarketPrice[j]).length > 0) {
                            if (this.originallstnotemarketprice[m].Date == this._note.ListNoteMarketPrice[j].Date) {
                                flag = true;
                                if (this.originallstnotemarketprice[m].Value != this._note.ListNoteMarketPrice[j].Value) {
                                    this.changedlstmarketnote.push(this._note.ListNoteMarketPrice[j]);
                                }
                                break;
                            }
                        }
                    }
                    if (flag == false) {
                        if (!(this._note.ListNoteMarketPrice[j].Date == null || this._note.ListNoteMarketPrice[j].Date.toString() == "")) {
                            this.changedlstmarketnote.push(this._note.ListNoteMarketPrice[j]);
                        }
                    }
                }
                else {
                    if (!(this._note.ListNoteMarketPrice[j].Date == null || this._note.ListNoteMarketPrice[j].Date.toString() == "")) {
                        this.changedlstmarketnote.push(this._note.ListNoteMarketPrice[j]);
                    }
                }
            }
            if (this.changedlstmarketnote.length > 0) {
                var errorflag = false;
                for (var k = 0; k < this.changedlstmarketnote.length; k++) {
                    var obj = this.changedlstmarketnote[k];
                    if (Object.keys(obj).length > 0) {
                        if (this.changedlstmarketnote[k].Date == "" || this.changedlstmarketnote[k].Date == undefined || this.changedlstmarketnote[k].Date == null) {
                            errmarketprice = "Date ,";
                            errorflag = true;
                        }
                        if (this.changedlstmarketnote[k].Value == "" || this.changedlstmarketnote[k].Value == undefined || this.changedlstmarketnote[k].Value == null) {
                            errmarketprice = errmarketprice + "Value ,";
                            errorflag = true;
                        }
                        if (errorflag == false) {
                            if (!(this.changedlstmarketnote[k].hasOwnProperty("NoteID"))) {
                                this.changedlstmarketnote[k]["NoteID"] = this._note.CRENoteID;
                            }
                        }
                    }
                }
            }
            if (errorstring != "" || effectiveerror != "" || purposeerrorstring != "" || amorterrorstring != "" || errmarketprice != "") {
                if (errorstring != "") {
                    errorstring = errorstring.slice(0, -1);
                    msg = errorstring + " should be greater than closing date";
                }
                if (effectiveerror != "") {
                    msg = msg + effectiveerror;
                }
                if (errmarketprice != "") {
                    msg = msg + "<p>" + errmarketprice.slice(0, -1) + " are required field(s)." + "</p>";
                    this.changedlstmarketnote = [];
                }
                if (purposeerrorstring != "") {
                    msg = msg + purposeerrorstring;
                }
                if (amorterrorstring != "") {
                    msg = msg + amorterrorstring;
                }
            }
            //show invalid date fields
            if (this._errorMsgDateValidation != "") {
                msg += "<br>Please provide valid date (greater than or equal to " + this.utilityService.getDateMinRangeView() + ") in following fields<br>" + this._errorMsgDateValidation;
                errorstring += msg.substring(0, msg.length - 1);
            }
            if (msg != "") {
                this.CustomAlert(msg);
            }
            else if (msgdialog != "") {
                this.savedialogmsg = msgdialog + "<p>" + "Do you want to proceed with save?" + "</p>";
                this.CustomDialogteSave();
            }
            else {
                if (this._isShowMsgForUseRuletoDetermine == false && this._note.FFLastUpdatedDate_String != null && this._isCallConcurrentCheck == true) {
                    //vishal
                    this.noteService.CheckConcurrentUpdate(this._note).subscribe(function (res) {
                        if (res.Succeeded) {
                            if (res.Message == "") {
                                _this.SaveNotefunc(_this._note, 'Save');
                            }
                            else {
                                _this.CustomAlert(res.Message);
                            }
                        }
                    });
                }
                else {
                    this.SaveNotefunc(this._note, 'Save');
                }
            }
        }
    };
    NoteDetailComponent.prototype.CustomDialogteSave = function () {
        var winW = window.innerWidth;
        var winH = window.innerHeight;
        var dialogbox = document.getElementById('Genericdialogbox');
        document.getElementById('savedialogmessage').innerHTML = this.savedialogmsg;
        dialogbox.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    NoteDetailComponent.prototype.SendPushNotification = function (objectId) {
        var _userData = JSON.parse(localStorage.getItem('user'));
        var addupdatetext = '';
        var _module = '';
        if (objectId == '00000000-0000-0000-0000-000000000000') {
            addupdatetext = 'created by ';
            _module = 'Add Note';
        }
        else {
            addupdatetext = 'updated by ';
            _module = 'Edit Note';
        }
        var _notificationMsg = 'A note ' + this._note.Name + ' has been ' + addupdatetext + _userData.FirstName;
        _notificationMsg = _module + '|*|' + _notificationMsg + '|*|' + appsettings_1.AppSettings._notificationenvironment + '|*|' + _userData.UserID;
        this._signalRService.SendNotification(_notificationMsg);
    };
    NoteDetailComponent.prototype.chkDateValidation = function () {
        this._errorMsgDateValidation = "";
        //if (this._isConvertDate == false)
        // validation for invidual controls
        {
            if (this._note.StartDate != null) {
                this.chkDateValidationToControl(this._note.StartDate, "StartDate");
            }
            if (this._note.EndDate != null) {
                this.chkDateValidationToControl(this._note.EndDate, "EndDate");
            }
            if (this._note.InitialInterestAccrualEndDate != null) {
                this.chkDateValidationToControl(this._note.InitialInterestAccrualEndDate, "InitialInterestAccrualEndDate");
            }
            if (this._note.FirstPaymentDate != null) {
                this.chkDateValidationToControl(this._note.FirstPaymentDate, "FirstPaymentDate");
            }
            if (this._note.InitialMonthEndPMTDateBiWeekly != null) {
                this.chkDateValidationToControl(this._note.InitialMonthEndPMTDateBiWeekly, "InitialMonthEndPMTDateBiWeekly");
            }
            if (this._note.FinalInterestAccrualEndDateOverride != null) {
                this.chkDateValidationToControl(this._note.FinalInterestAccrualEndDateOverride, "FinalInterestAccrualEndDateOverride");
            }
            if (this._note.FirstRateIndexResetDate != null) {
                this.chkDateValidationToControl(this._note.FirstRateIndexResetDate, "FirstRateIndexResetDate");
            }
            // if (this._note.SelectedMaturityDate != null) { this.chkDateValidationToControl(this._note.SelectedMaturityDate, "SelectedMaturityDate"); }
            //if (this._note.InitialMaturityDate != null) { this.chkDateValidationToControl(this._note.InitialMaturityDate, "InitialMaturityDate"); }
            if (this._note.ExpectedMaturityDate != null) {
                this.chkDateValidationToControl(this._note.ExpectedMaturityDate, "ExpectedMaturityDate");
            }
            //if (this._note.FullyExtendedMaturityDate != null) { this.chkDateValidationToControl(this._note.FullyExtendedMaturityDate, "FullyExtendedMaturityDate"); }
            if (this._note.OpenPrepaymentDate != null) {
                this.chkDateValidationToControl(this._note.OpenPrepaymentDate, "OpenPrepaymentDate");
            }
            if (this._note.FinancingInitialMaturityDate != null) {
                this.chkDateValidationToControl(this._note.FinancingInitialMaturityDate, "FinancingInitialMaturityDate");
            }
            if (this._note.FinancingExtendedMaturityDate != null) {
                this.chkDateValidationToControl(this._note.FinancingExtendedMaturityDate, "FinancingExtendedMaturityDate");
            }
            if (this._note.ClosingDate != null) {
                this.chkDateValidationToControl(this._note.ClosingDate, "ClosingDate");
            }
            //if (this._note.ExtendedMaturityScenario1 != null) { this.chkDateValidationToControl(this._note.ExtendedMaturityScenario1, "ExtendedMaturityScenario1"); }
            //if (this._note.ExtendedMaturityScenario2 != null) { this.chkDateValidationToControl(this._note.ExtendedMaturityScenario2, "ExtendedMaturityScenario2"); }
            // if (this._note.ExtendedMaturityScenario3 != null) { this.chkDateValidationToControl(this._note.ExtendedMaturityScenario3, "ExtendedMaturityScenario3"); }
            if (this._note.ActualPayoffDate != null) {
                this.chkDateValidationToControl(this._note.ActualPayoffDate, "ActualPayoffDate");
            }
            if (this._note.PurchaseDate != null) {
                this.chkDateValidationToControl(this._note.PurchaseDate, "PurchaseDate");
            }
            if (this._note.ValuationDate != null) {
                this.chkDateValidationToControl(this._note.ValuationDate, "ValuationDate");
            }
            if (this._note.lastCalcDateTime != null) {
                this.chkDateValidationToControl(this._note.lastCalcDateTime, "lastCalcDateTime");
            }
            if (this.MaturityEffectiveDate != null) {
                this.chkDateValidationToControl(this.MaturityEffectiveDate, "MaturityEffectiveDate");
            }
            if (this.MaturityDate != null) {
                this.chkDateValidationToControl(this.MaturityDate, "MaturityDate");
            }
            if (this.Servicing_EffectiveDate != null) {
                this.chkDateValidationToControl(this.Servicing_EffectiveDate, "Servicing_EffectiveDate");
            }
            if (this.Servicing_Date != null) {
                this.chkDateValidationToControl(this.Servicing_Date, "Servicing_Date");
            }
            if (this.PIKSchedule_EffectiveDate != null) {
                this.chkDateValidationToControl(this.PIKSchedule_EffectiveDate, "PIKSchedule_EffectiveDate");
            }
            if (this.PIKSchedule_StartDate != null) {
                this.chkDateValidationToControl(this.PIKSchedule_StartDate, "PIKSchedule_StartDate");
            }
            if (this.PIKSchedule_EndDate != null) {
                this.chkDateValidationToControl(this.PIKSchedule_EndDate, "PIKSchedule_EndDate");
            }
            if (this.Ratespread_EffectiveDate != null) {
                this.chkDateValidationToControl(this.Ratespread_EffectiveDate, "Ratespread_EffectiveDate");
            }
            if (this.PrepayAndAdditionalFeeSchedule_EffectiveDate != null) {
                this.chkDateValidationToControl(this.PrepayAndAdditionalFeeSchedule_EffectiveDate, "PrepayAndAdditionalFeeSchedule_EffectiveDate");
            }
            if (this.StrippingSchedule_EffectiveDate != null) {
                this.chkDateValidationToControl(this.StrippingSchedule_EffectiveDate, "StrippingSchedule_EffectiveDate");
            }
            if (this.FinancingFeeSchedule_EffectiveDate != null) {
                this.chkDateValidationToControl(this.FinancingFeeSchedule_EffectiveDate, "FinancingFeeSchedule_EffectiveDate");
            }
            if (this.FinancingSchedule_EffectiveDate != null) {
                this.chkDateValidationToControl(this.FinancingSchedule_EffectiveDate, "FinancingSchedule_EffectiveDate");
            }
            if (this.DefaultSchedule_EffectiveDate != null) {
                this.chkDateValidationToControl(this.DefaultSchedule_EffectiveDate, "DefaultSchedule_EffectiveDate");
            }
            if (this._note.NoteTransferDate != null) {
                this.chkDateValidationToControl(this._note.NoteTransferDate, "NoteTransferDate");
            }
        }
        //Grid control validation
        //if (this._isConvertGridDate == false)
        {
            this.chkDateValidationToGrid(this._noteext.NoteDefaultScheduleList, "DefaultSchedule");
            this.chkDateValidationToGrid(this._noteext.lstFinancingFeeSchedule, "FinancingFeeSchedule");
            this.chkDateValidationToGrid(this._noteext.NoteFinancingScheduleList, "FinancingSchedule");
            this.chkDateValidationToGrid(this._noteext.NotePIKScheduleList, "PIKSchedule");
            this.chkDateValidationToGrid(this._noteext.NotePrepayAndAdditionalFeeScheduleList, "PrepayAndAdditionalFeeSchedule");
            this.chkDateValidationToGrid(this._noteext.RateSpreadScheduleList, "RateSpreadSchedule");
            this.chkDateValidationToGrid(this._noteext.NoteStrippingList, "StrippingSchedule");
            this.chkDateValidationToGrid(this._noteext.ListFutureFundingScheduleTab, "FundingSchedule");
            this.chkDateValidationToGrid(this._noteext.ListPIKfromPIKSourceNoteTab, "PIKScheduleDetail");
            this.chkDateValidationToGrid(this._noteext.ListLiborScheduleTab, "LIBORSchedule");
            this.chkDateValidationToGrid(this._noteext.ListFixedAmortScheduleTab, "AmortSchedule");
            this.chkDateValidationToGrid(this._noteext.ListFeeCouponStripReceivable, "FeeCouponStripReceivable");
            this.chkDateValidationToGrid(this._noteext.lstNoteServicingLog, "Servicinglog");
        }
        //return this._errorMsgDateValidation;
        return true;
    };
    NoteDetailComponent.prototype.chkDateValidationToControl = function (date, moduleName) {
        if (date != null) {
            var controlDate = new Date(date);
            var systemDate = new Date(this.utilityService.getDateMinRange());
            if (controlDate < systemDate) {
                this._errorMsgDateValidation += moduleName + ", ";
            }
            return "";
        }
        else
            return "";
    };
    NoteDetailComponent.prototype.chkDateValidationToGrid = function (Data, modulename) {
        if (Data) {
            switch (modulename) {
                case "Maturity":
                    break;
                case "BalanceTransactionSchedule":
                    break;
                case "DefaultSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.NoteDefaultScheduleList[i].StartDate != null) {
                            this.chkDateValidationToControl(this._noteext.NoteDefaultScheduleList[i].StartDate, modulename + " StartDate");
                        }
                        if (this._noteext.NoteDefaultScheduleList[i].EndDate != null) {
                            this.chkDateValidationToControl(this._noteext.NoteDefaultScheduleList[i].EndDate, modulename + " EndDate");
                        }
                    }
                    break;
                case "FeeCouponSchedule":
                    break;
                case "FinancingFeeSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.lstFinancingFeeSchedule[i].Date != null) {
                            this.chkDateValidationToControl(this._noteext.lstFinancingFeeSchedule[i].Date, modulename + " Date");
                        }
                    }
                    break;
                case "FinancingSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.NoteFinancingScheduleList[i].Date != null) {
                            this.chkDateValidationToControl(this._noteext.NoteFinancingScheduleList[i].Date, modulename + " Date");
                        }
                    }
                    break;
                case "PIKSchedule":
                    break;
                case "PrepayAndAdditionalFeeSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].StartDate != null) {
                            this.chkDateValidationToControl(this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].StartDate, modulename + " StartDate");
                        }
                        if (this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ScheduleEndDate != null) {
                            this.chkDateValidationToControl(this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ScheduleEndDate, modulename + " ScheduleEndDate");
                        }
                    }
                    break;
                case "RateSpreadSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.RateSpreadScheduleList[i].Date != null) {
                            this.chkDateValidationToControl(this._noteext.RateSpreadScheduleList[i].Date, modulename + " Date");
                        }
                    }
                    break;
                case "ServicingFeeSchedule":
                    break;
                case "StrippingSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.NoteStrippingList[i].StartDate != null) {
                            this.chkDateValidationToControl(this._noteext.NoteStrippingList[i].StartDate, modulename + " StartDate");
                        }
                    }
                    break;
                case "FundingSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.ListFutureFundingScheduleTab[i].Date != null) {
                            this.chkDateValidationToControl(this._noteext.ListFutureFundingScheduleTab[i].Date, modulename + " Date");
                        }
                    }
                    break;
                case "PIKScheduleDetail":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.ListPIKfromPIKSourceNoteTab[i].Date != null) {
                            this.chkDateValidationToControl(this._noteext.ListPIKfromPIKSourceNoteTab[i].Date, modulename + " Date");
                        }
                    }
                    break;
                case "LIBORSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.ListLiborScheduleTab[i].Date != null) {
                            this.chkDateValidationToControl(this._noteext.ListLiborScheduleTab[i].Date, modulename + " Date");
                        }
                    }
                    break;
                case "AmortSchedule":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.ListFixedAmortScheduleTab[i].Date != null) {
                            this.chkDateValidationToControl(this._noteext.ListFixedAmortScheduleTab[i].Date, modulename + " Date");
                        }
                    }
                    break;
                case "FeeCouponStripReceivable":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.ListFeeCouponStripReceivable[i].Date != null) {
                            this.chkDateValidationToControl(this._noteext.ListFeeCouponStripReceivable[i].Date, modulename + " Date");
                        }
                    }
                    break;
                case "Servicinglog":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.lstNoteServicingLog[i].TransactionDate != null) {
                            this.chkDateValidationToControl(this._noteext.lstNoteServicingLog[i].TransactionDate, modulename + " TransactionDate");
                        }
                        if (this._noteext.lstNoteServicingLog[i].RelatedtoModeledPMTDate != null) {
                            this.chkDateValidationToControl(this._noteext.lstNoteServicingLog[i].RelatedtoModeledPMTDate, modulename + " RelatedtoModeledPMTDate");
                        }
                        if (this._noteext.lstNoteServicingLog[i].RemittanceDate != null) {
                            this._noteext.lstNoteServicingLog[i].RemittanceDate = this.convertDatetoGMT(this._noteext.lstNoteServicingLog[i].RemittanceDate);
                        }
                    }
                    break;
                case "NotePeriodicCalc":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.lstnotePeriodicOutputs[i].PeriodEndDate != null) {
                            this.chkDateValidationToControl(this._noteext.lstnotePeriodicOutputs[i].PeriodEndDate, modulename + " PeriodEndDate");
                        }
                        if (this._noteext.lstnotePeriodicOutputs[i].CreatedDate != null) {
                            this.chkDateValidationToControl(this._noteext.lstnotePeriodicOutputs[i].CreatedDate, modulename + " CreatedDate");
                        }
                        if (this._noteext.lstnotePeriodicOutputs[i].UpdatedDate != null) {
                            this.chkDateValidationToControl(this._noteext.lstnotePeriodicOutputs[i].UpdatedDate, modulename + " UpdatedDate");
                        }
                    }
                    break;
                case "NoteOutputNPV":
                    for (var i = 0; i < Data.length; i++) {
                        if (this._noteext.lstOutputNPVdata[i].NPVdate != null) {
                            this.chkDateValidationToControl(this._noteext.lstOutputNPVdata[i].NPVdate, modulename + " NPVdate");
                        }
                        if (this._noteext.lstOutputNPVdata[i].CreatedDate != null) {
                            this.chkDateValidationToControl(this._noteext.lstOutputNPVdata[i].CreatedDate, modulename + " CreatedDate");
                        }
                        if (this._noteext.lstOutputNPVdata[i].UpdatedDate != null) {
                            this.chkDateValidationToControl(this._noteext.lstOutputNPVdata[i].UpdatedDate, modulename + " UpdatedDate");
                        }
                    }
                    break;
                case "Calculator":
                    for (var i = 0; i < Data.length; i++) {
                        if (this.lstPeriodicDataList[i].PeriodEndDate != null) {
                            this.chkDateValidationToControl(this.lstPeriodicDataList[i].PeriodEndDate, modulename + " PeriodEndDate");
                        }
                        if (this.lstPeriodicDataList[i].CreatedDate != null) {
                            this.chkDateValidationToControl(this.lstPeriodicDataList[i].CreatedDate, modulename + " CreatedDate");
                        }
                        if (this.lstPeriodicDataList[i].UpdatedDate != null) {
                            this.chkDateValidationToControl(this.lstPeriodicDataList[i].UpdatedDate, modulename + " UpdatedDate");
                        }
                    }
                    break;
                default:
                    break;
            }
        }
    };
    NoteDetailComponent.prototype.Savedialogbox = function () {
        this.SaveNotefunc(this._note, 'Save');
        this.ClosePopUpDialog();
    };
    NoteDetailComponent.prototype.ClosePopUpDialog = function () {
        var modal = document.getElementById('Genericdialogbox');
        modal.style.display = "none";
    };
    NoteDetailComponent.prototype.AppliedReadOnly = function () {
        if (this._noteext.ListFutureFundingScheduleTab) {
            for (var i = 0; i < this._noteext.ListFutureFundingScheduleTab.length; i++) {
                if (this._noteext.ListFutureFundingScheduleTab[i].Applied == true) {
                    if (this.futurefundingflex.rows[i]) {
                        console.log('144');
                        this.futurefundingflex.rows[i].isReadOnly = true;
                        this.futurefundingflex.rows[i].cssClass = "customgridrowcolor";
                    }
                }
            }
        }
    };
    NoteDetailComponent.prototype.convertDateToBindable = function (date) {
        var dateObj = new Date(date);
        return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear();
    };
    NoteDetailComponent.prototype.getTwoDigitString = function (number) {
        if (number.toString().length === 1)
            return "0" + number;
        return number;
    };
    NoteDetailComponent.prototype.celleditfunding = function (futurefundingflex, e) {
        var _this = this;
        //  alert('e.col.toString() ' + e.col.toString());       
        var deccount = 0;
        if (e.col.toString() == "1") {
            var Amtdec = this._noteext.ListFutureFundingScheduleTab[e.row].Value;
            if (Math.floor(Amtdec) === Amtdec) {
                deccount = 0;
            }
            else {
                deccount = Amtdec.toString().split(".")[1].length || 0;
            }
            if (deccount > 2) {
                this._noteext.ListFutureFundingScheduleTab[e.row].Value = parseFloat(this._noteext.ListFutureFundingScheduleTab[e.row].Value.toFixed(2));
                this.CustomAlert("Funding amount can't have more than 2 decimal places. System has rounded the inputs to 2 decimal places. ");
                this.futurefundingflex.select(e.row, e.col - 1);
                // focus on select row and ready for editing
                this.futurefundingflex.focus();
                return;
            }
        }
        if (e.col.toString() == "0") {
            var maxappliedDate = new Date(Math.max.apply(null, this._noteext.ListFutureFundingScheduleTab.filter(function (x) { return x.Applied == true; }).map(function (x) { return x.Date; })));
            if (new Date(this._noteext.ListFutureFundingScheduleTab[e.row].Date) < maxappliedDate) {
                if (this._noteext.ListFutureFundingScheduleTab[e.row].orgDate == undefined) {
                    this._noteext.ListFutureFundingScheduleTab[e.row].Date = null;
                }
                else {
                    this._noteext.ListFutureFundingScheduleTab[e.row].Date = new Date(this.convertDateToBindable(this._noteext.ListFutureFundingScheduleTab[e.row].orgDate));
                }
                this.CustomAlert("Date can not be less than " + this.convertDateToBindable(maxappliedDate));
            }
            else {
                var sdate = this._noteext.ListFutureFundingScheduleTab[e.row].Date;
                if (!(sdate === undefined) && sdate != null) {
                    var formateddate = this.convertDateToBindable(sdate);
                    var dealfundingday = new Date(sdate).getDay();
                    if (dealfundingday == 6 || dealfundingday == 0
                        || this.ListHoliday.filter(function (x) { return _this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411; }).length > 0) {
                        this.CustomAlert("You have entered a funding date (" + formateddate + ") which is either on holiday or weekend. Please enter different date");
                        if (this._noteext.ListFutureFundingScheduleTab[e.row].orgDate == undefined) {
                            this._noteext.ListFutureFundingScheduleTab[e.row].Date = null;
                        }
                        else {
                            this._noteext.ListFutureFundingScheduleTab[e.row].Date = new Date(this.convertDateToBindable(this._noteext.ListFutureFundingScheduleTab[e.row].orgDate));
                        }
                    }
                }
            }
        }
        else if (e.col.toString() == "3") {
            for (var tprow = 0; tprow <= this.futurefundingflex.rows.length - 1; tprow++) {
                if (this.futurefundingflex.rows[tprow].isReadOnly == false && this.futurefundingflex.rows[tprow]._data.Applied == true) {
                    this.futurefundingflex.rows[tprow]._data.Applied = false;
                    this.CustomAlert("Please enter Date or Amount before checking Wire confirm.");
                    this.futurefundingflex.select(this.futurefundingflex.rows.length - 1, 0);
                    // focus on select row and ready for editing
                    this.futurefundingflex.focus();
                    return;
                }
            }
        }
    };
    NoteDetailComponent.prototype.getnexybusinessDate = function (sDate, noofDays) {
        var daycnt = sDate.getDay();
        if (daycnt == 6)
            sDate.setDate(sDate.getDate() + 1);
        if (daycnt == 1 || daycnt == 2 || daycnt == 3 || daycnt == 4 || daycnt == 5)
            sDate.setDate(sDate.getDate() + 2);
        sDate.setDate(sDate.getDate() + noofDays);
        return sDate;
    };
    NoteDetailComponent.prototype.ImportDocument = function () {
        this.saveFiles();
    };
    NoteDetailComponent.prototype.saveFiles = function () {
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
                ObjectID: this._note.NoteId,
                ObjectTypeID: 182,
                StorageType: appsettings_1.AppSettings._storageType,
                FolderName: this._note.CRENoteID,
                ParentFolderName: this._note.CREDealID
            };
            this.fileUploadService.uploadObjectDocumentByStorageType(formData, parameters)
                .subscribe(function (success) {
                _this.IsOpenActivityTab = false;
                //alert('success ' + success);
                var smessage = success.Message.split('==');
                //alert(smessage);
                //alert(smessage[0]);
                if (smessage[0] == "Success") {
                    _this.uploadStatus.emit(true);
                    //    console.log(success);
                    //localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                    //localStorage.setItem('WarmsgdashBoad', JSON.stringify('File uploaded successfully'));
                    _this._Showmessagenotediv = true;
                    _this._ShowmessagenotedivMsg = "File uploaded successfully";
                    setTimeout(function () {
                        this._Showmessagenotediv = false;
                        this._ShowmessagenotedivMsg = "";
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
                else {
                    _this.uploadStatus.emit(true);
                    // console.log(success);
                    _this._ShowmessagenotedivWar = true;
                    _this._ShowmessagenotedivMsgWar = smessage[1];
                    //this.isProcessComplete = false;
                    setTimeout(function () {
                        this._ShowmessagenotedivWar = false;
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
    NoteDetailComponent.prototype.DocumentTypeIDChange = function (newvalue) {
        this._document.DocumentTypeID = newvalue;
    };
    NoteDetailComponent.prototype.ArchiveDocument = function () {
        var _this = this;
        this._isNoteSaving = true;
        var lstDoc = this.lstDocuments.filter(function (x) { return x.UploadedDocumentLogID == _this._uploadedDocumentLogID; });
        lstDoc.forEach(function (obj, i) { obj.Status = 423; });
        if (lstDoc.length > 0) {
            this.fileUploadService.updateDocumentStatus(lstDoc).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.ClosePopUpArchive();
                    _this.getDocumentList();
                    _this._isNoteSaving = false;
                    _this._Showmessagenotediv = true;
                    _this._ShowmessagenotedivMsg = "File archived successfully";
                    setTimeout(function () {
                        this._Showmessagenotediv = false;
                        this._ShowmessagenotedivMsg = "";
                        //   console.log(this._ShowmessagedivWar);
                    }.bind(_this), 5000);
                }
                else {
                    _this.utilityService.navigateToSignIn();
                }
            });
            (function (error) {
                _this._isNoteSaving = false;
                console.error('Error: ' + error);
                _this.ClosePopUpArchive();
            });
        }
    };
    NoteDetailComponent.prototype.getDocumentList = function () {
        var _this = this;
        this._isNoteSaving = true;
        this._document.ObjectTypeID = '182';
        this._document.ObjectID = this._note.NoteId;
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
                        setTimeout(function () {
                            this.flexDocument.invalidate();
                            //remove first cell selection
                            this.flexDocument.selectionMode = wjcGrid.SelectionMode.None;
                            //this.flexDocument.autoSizeColumns(0, this.flexDocument.columns.length, false, 20);
                            //this.flexDocument.columns[0].width = 350; // for Note Id
                            this.addScrollHandler();
                        }.bind(_this), 500);
                    }
                }
                else {
                    _this.lstDocuments = _this.lstDocuments.concat(data);
                }
                _this._isNoteSaving = false;
            }
            else {
                _this.utilityService.navigateToSignIn();
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    NoteDetailComponent.prototype.showDocImport = function () {
        var _this = this;
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
    };
    NoteDetailComponent.prototype.addScrollHandler = function () {
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
    ///////// Doc Import ///////////////////
    NoteDetailComponent.prototype.onAction = function (event) {
        console.log(event);
        //this.actionLog += "\n currentFiles: " + this.getFileNames(event.currentFiles);
        //console.log(this.actionLog);
        //let fileList: FileList = event.currentFiles;
        this.fileList = event.currentFiles;
        //this.saveFiles(this.fileList);
    };
    NoteDetailComponent.prototype.onAdded = function (event) {
        this.actionLog += "\n FileInput: " + event.id;
        this.actionLog += "\n Action: File added";
    };
    NoteDetailComponent.prototype.onRemoved = function (event) {
        this.actionLog += "\n FileInput: " + event.id;
        this.actionLog += "\n Action: File removed";
    };
    NoteDetailComponent.prototype.onCouldNotRemove = function (event) {
        this.actionLog += "\n FileInput: " + event.id;
        this.actionLog += "\n Action: Could not remove file";
    };
    NoteDetailComponent.prototype.resetFileInput = function () {
        this.ng2FileInputService.reset(this.myFileInputIdentifier);
    };
    NoteDetailComponent.prototype.isValidFiles = function (files) {
        // Check Number of files
        if (files.length > this.maxFiles) {
            this.errors.push("At a time you can upload only " + this.maxFiles + " file <BR/>");
            return;
        }
        this.isValidFileExtension(files);
        return this.errors.length === 0;
    };
    NoteDetailComponent.prototype.isValidFileExtension = function (files) {
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
    NoteDetailComponent.prototype.isValidFileSize = function (file) {
        var fileSizeinMB = file.size / (1024 * 1000);
        var size = Math.round(fileSizeinMB * 100) / 100; // convert upto 2 decimal place
        if (size > this.maxSize)
            this.errors.push("<BR/>Selected: " + file.name + ": exceed file size limit of " + this.maxSize + "MB ( " + size + "MB )");
    };
    NoteDetailComponent.prototype.getAllClient = function () {
        var _this = this;
        this.noteService.getAllClient().subscribe(function (res) {
            if (res.Succeeded) {
                _this.lstClient = res.lstClient;
            }
        });
    };
    NoteDetailComponent.prototype.getAllFund = function () {
        var _this = this;
        this.noteService.getAllFund().subscribe(function (res) {
            if (res.Succeeded) {
                _this.lstFund = res.lstFund;
            }
        });
    };
    NoteDetailComponent.prototype.getFeeTypesFromFeeSchedulesConfig = function () {
        var _this = this;
        this.noteService.getFeeTypesFromFeeSchedulesConfig().subscribe(function (res) {
            if (res.Succeeded) {
                _this.lstFeeTypeLookUp = res.lstFeeTypeLookUp;
            }
        });
    };
    NoteDetailComponent.prototype.DownloadDocument = function (filename, originalfilename, storagetype, documentStorageID) {
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
    NoteDetailComponent.prototype.GetHolidayList = function () {
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
    NoteDetailComponent.prototype.GetLookupForMaster = function () {
        var _this = this;
        this.noteService.GetLookupForMaster().subscribe(function (res) {
            var data = res.lstlookupMaster;
            _this.lstServicerName = data.filter(function (x) { return x.ddlType == "ddlServicer"; });
        });
    };
    NoteDetailComponent.prototype.subscribetoevent = function () {
        this._signalRService.updateCalcNotification.subscribe(function (message) {
            var res = message.split('|*|');
            if (res[0] == "CALCMGR") {
                var notelist = res[2];
                console.log(notelist);
            }
        });
    };
    NoteDetailComponent.prototype.GetFinancingSource = function () {
        var _this = this;
        this.noteService.GetFinancingSource().subscribe(function (res) {
            if (res.Succeeded) {
                _this.lstfinancingsource = res.lstfinancingsource;
            }
        });
    };
    NoteDetailComponent.prototype.ShowCountOnViewHistoryBtn = function () {
        for (var i = 0; i < this._note.ListEffectiveDateCount.length; i++) {
            var scheduleName = this._note.ListEffectiveDateCount[i].ScheduleName;
            switch (scheduleName) {
                case "Maturity":
                    scheduleName = "Maturity";
                    this.EffectiveDateCountMaturity = ' (' + this._note.ListEffectiveDateCount[i].EffectiveDateCount + ')';
                    break;
                case "DefaultSchedule":
                    scheduleName = "DefaultSchedule";
                    this.EffectiveDateCountDefaultSchedule = ' (' + this._note.ListEffectiveDateCount[i].EffectiveDateCount + ')';
                    this._isSetHeaderEmpty = true;
                    break;
                case "FinancingFeeSchedule":
                    scheduleName = "FinancingFeeSchedule";
                    this.EffectiveDateCountFinancingFeeSchedule = ' (' + this._note.ListEffectiveDateCount[i].EffectiveDateCount + ')';
                    this._isSetHeaderEmpty = true;
                    break;
                case "FinancingSchedule":
                    scheduleName = "FinancingSchedule";
                    this.EffectiveDateCountFinancingSchedule = ' (' + this._note.ListEffectiveDateCount[i].EffectiveDateCount + ')';
                    this._isSetHeaderEmpty = true;
                    break;
                case "PIKSchedule":
                    scheduleName = "PIKSchedule";
                    this.EffectiveDateCountPIKSchedule = ' (' + this._note.ListEffectiveDateCount[i].EffectiveDateCount + ')';
                    this._isSetHeaderEmpty = true;
                    break;
                case "PrepayAndAdditionalFeeSchedule":
                    scheduleName = "PrepayAndAdditionalFeeSchedule";
                    this.EffectiveDateCountPrepayAndAdditionalFeeSchedule = ' (' + this._note.ListEffectiveDateCount[i].EffectiveDateCount + ')';
                    this._isSetHeaderEmpty = true;
                    break;
                case "RateSpreadSchedule":
                    scheduleName = "RateSpreadSchedule";
                    this.EffectiveDateCountRateSpreadSchedule = ' (' + this._note.ListEffectiveDateCount[i].EffectiveDateCount + ')';
                    this._isSetHeaderEmpty = true;
                    break;
                case "FundingSchedule":
                    scheduleName = "FundingSchedule";
                    this.EffectiveDateCountFundingSchedule = ' (' + this._note.ListEffectiveDateCount[i].EffectiveDateCount + ')';
                    break;
                case "PIKScheduleDetail":
                    scheduleName = "PIKScheduleDetail";
                    this.EffectiveDateCountPIKScheduleDetail = ' (' + this._note.ListEffectiveDateCount[i].EffectiveDateCount + ')';
                    break;
                case "AmortSchedule":
                    scheduleName = "AmortSchedule";
                    this.EffectiveDateCountAmortSchedule = ' (' + this._note.ListEffectiveDateCount[i].EffectiveDateCount + ')';
                    break;
                case "FeeCouponStripReceivable":
                    scheduleName = "FeeCouponStripReceivable";
                    this.EffectiveDateCountFeeCouponStripReceivable = ' (' + this._note.ListEffectiveDateCount[i].EffectiveDateCount + ')';
                    break;
                default:
                    break;
            }
        }
    };
    NoteDetailComponent.prototype.GetDefaultValue = function (val) {
        if (isNaN(val) || val == null) {
            return 0;
        }
        return val;
    };
    //CalculateAggregateTotal(): void {
    //    this._note.AdjustedTotalCommitment = this.GetDefaultValue(this._note.AdjustedTotalCommitment);
    //    this._note.TotalCommitment = this.GetDefaultValue(this._note.TotalCommitment);
    //    this._note.AggregatedTotal = parseFloat(this._note.TotalCommitment.toString()) + parseFloat(this._note.AdjustedTotalCommitment.toString());
    //}
    NoteDetailComponent.prototype.GetUserTimezoneByID = function () {
        var _this = this;
        this.membershipservice.GetUserTimeZonebyUserID().subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.dt;
                _this._timezoneAbbreviation = data[0].Abbreviation;
            }
        });
    };
    NoteDetailComponent.prototype.getTransactionTypes = function () {
        var _this = this;
        this.noteService.GetTransactionTypes().subscribe(function (res) {
            if (res.Succeeded == true) {
                _this.listtransactiontype = res.dt;
            }
        });
        this._bindGridDropdows();
    };
    NoteDetailComponent.prototype.onContextMenu = function (grid, e) {
        var hti = grid.hitTest(e);
        if (hti.panel && hti.panel === grid.cells && hti.panel.columns[hti.col].binding === "CalculatedAmount") {
            if (this.ServicingLog_refreshlist[hti.row]["AllowCalculationOverride"] == 3) {
                if (this.ServicingLog_refreshlist[hti.row]["TransactionTypeText"] != "PIKPrincipalFunding") {
                    e.preventDefault();
                    this.hti = hti;
                    this.ctxMenu.show(e);
                }
                else {
                    this.ctxMenu.hide();
                }
            }
            else {
                this.ctxMenu.hide();
            }
        }
        else {
            this.ctxMenu.hide();
        }
    };
    NoteDetailComponent.prototype.menuItemClicked = function (s, e) {
        var _a = this.flexservicelog.selection, selectedRow = _a.row, selectedCol = _a.col;
        var _b = this.hti, clickedRow = _b.row, clickedCol = _b.col;
        this._ClckservicelogCol = clickedCol;
        this._ClckservicelogRow = clickedRow;
        if (s.selectedItem._ownerMenu.text == "Reset") {
            this.ContextMenuResetdialogbox();
        }
        if (s.selectedItem._ownerMenu.text == "Update") {
            var modal = document.getElementById('ContextMenudialogbox');
            modal.style.display = "block";
            $.getScript("/js/jsDrag.js");
            document.getElementById('ModifyCalcValue')["value"] = "";
            document.getElementById('ModifyComment')["value"] = "";
        }
    };
    NoteDetailComponent.prototype.celleditservicelog = function (flextrans, e) {
        var transactiongroup = '';
        if (this.multiseltransactiongroup != undefined) {
            transactiongroup = this.multiseltransactiongroup.checkedItems.map(function (_a) {
                var TransactionGroup = _a.TransactionGroup;
                return TransactionGroup;
            }).join('|');
            transactiongroup = transactiongroup.length ? transactiongroup : null;
        }
        else {
            transactiongroup = null;
        }
        var Delta_index = this.flexservicelog.getColumn("Delta").index;
        var Adjustment_index = this.flexservicelog.getColumn("Adjustment").index;
        var ActualDelta_index = this.flexservicelog.getColumn("ActualDelta").index;
        var Override_index = this.flexservicelog.getColumn("OverrideValue").index;
        var Overridereason_index = this.flexservicelog.getColumn("OverrideReasonText").index;
        var M61_index = this.flexservicelog.getColumn("CalculatedAmount").index;
        var Serv_index = this.flexservicelog.getColumn("ServicingAmount").index;
        var M61_Check = this.flexservicelog.getColumn("M61Value").index;
        var Servicer_Check = this.flexservicelog.getColumn("ServicerValue").index;
        //var Ignore_Check = this.flexservicelog.getColumn("Ignore").index;
        var TransactionType_ddl = this.flexservicelog.getColumn("TransactionTypeText").index;
        var Final_ValueinCalc = this.flexservicelog.getColumn("Final_ValueUsedInCalc").index;
        if (e.col == Adjustment_index) {
            var Delta = this.flexservicelog.getCellData(e.row, Delta_index, false);
            var Adjustment = this.flexservicelog.getCellData(e.row, Adjustment_index, false);
            if (Delta == null && Delta == undefined)
                Delta = 0;
            if (Adjustment == null && Adjustment == undefined)
                Adjustment = 0;
            var ActualDelta = parseFloat(Delta) + parseFloat(Adjustment);
            this.flexservicelog.setCellData(e.row, ActualDelta_index, ActualDelta);
            this.flexservicelog.invalidate();
        }
        if (e.col == Override_index || e.col == Overridereason_index) {
            var iserr = false;
            if (!(Number(this._noteext.lstNoteServicingLog[e.row].OverrideReasonText).toString() == "NaN" || Number(this._noteext.lstNoteServicingLog[e.row].OverrideReasonText) == 0)) {
                this._noteext.lstNoteServicingLog[e.row].OverrideReason = Number(this._noteext.lstNoteServicingLog[e.row].OverrideReasonText);
            }
            var OverRideValue = this.flexservicelog.getCellData(e.row, Override_index, false);
            var OverRideComment = this.flexservicelog.getCellData(e.row, Overridereason_index, false);
            var M61_Value = this.flexservicelog.getCellData(e.row, M61_index, false);
            var Serv_Value = this.flexservicelog.getCellData(e.row, Serv_index, false);
            var M61Chk = this.flexservicelog.getCellData(e.row, M61_Check, false);
            var SerChk = this.flexservicelog.getCellData(e.row, Servicer_Check, false);
            if (M61Chk) {
                iserr = true;
                this.CustomAlert('Combination of Override Value and M61 Value is not allowed.');
                this.flexservicelog.setCellData(e.row, Override_index, null);
            }
            if (SerChk) {
                iserr = true;
                this.CustomAlert('Combination of Override Value and Servicer Value is not allowed.');
                this.flexservicelog.setCellData(e.row, Override_index, 0);
            }
            //var IgnoreChk = this.flexservicelog.getCellData(e.row, Ignore_Check, false);
            //if (IgnoreChk) {
            //    iserr = true;
            //    this.CustomAlert('Combination of Override Value and Ignore is not allowed.');
            //    this.flexservicelog.setCellData(e.row, Ignore_Check, "");
            //}
            if (OverRideValue == null) {
                this._noteext.lstNoteServicingLog[e.row].OverrideReasonText = null;
                this._noteext.lstNoteServicingLog[e.row].OverrideReason = null;
                this.flexservicelog.invalidate();
            }
            if (!iserr) {
                var sel = this.flexservicelog.selection;
                if (!M61_Value)
                    M61_Value = 0;
                if (!OverRideValue) {
                    if (OverRideValue == null)
                        this.flexservicelog.setCellData(e.row, Delta_index, Serv_Value - M61_Value);
                    if (OverRideValue == 0) {
                        this.flexservicelog.setCellData(e.row, Delta_index, 0);
                        //   this.flexservicelog.setCellData(e.row, ActualDelta_index, 0 );
                    }
                }
                else {
                    this.flexservicelog.setCellData(e.row, Delta_index, OverRideValue - M61_Value);
                }
                if (M61Chk == false && SerChk == false) {
                    this.flexservicelog.setCellData(e.row, Final_ValueinCalc, OverRideValue);
                }
                var Adjustment = this.flexservicelog.getCellData(e.row, Adjustment_index, false);
                var Delta = this.flexservicelog.getCellData(e.row, Delta_index, false);
                ActualDelta = parseFloat(Delta) + parseFloat(Adjustment);
                this.flexservicelog.setCellData(e.row, ActualDelta_index, ActualDelta);
                this.flexservicelog.invalidate();
            }
        }
        if (e.col == M61_Check) {
            var OverRideValue = this.flexservicelog.getCellData(e.row, Override_index, false);
            if (OverRideValue != 0) {
                this.CustomAlert('Combination of Override Value and M61 Value is not allowed.');
                this.flexservicelog.setCellData(e.row, M61_Check, false);
            }
            var M61Chk = this.flexservicelog.getCellData(e.row, M61_Check, false);
            if (M61Chk == true) {
                this.flexservicelog.select(e.row, M61_index);
                this.flexservicelog.focus();
                this.flexservicelog.setCellData(e.row, Servicer_Check, false);
                //  this.flexservicelog.setCellData(e.row, Ignore_Check, false);
                var M61_Value = this.flexservicelog.getCellData(e.row, M61_index, false);
                this.flexservicelog.setCellData(e.row, Final_ValueinCalc, M61_Value);
            }
            this.flexservicelog.invalidate();
        }
        if (e.col == Servicer_Check) {
            var OverRideValue = this.flexservicelog.getCellData(e.row, Override_index, false);
            if (OverRideValue != 0) {
                this.CustomAlert('Combination of Override Value and Servicer Value is not allowed.');
                this.flexservicelog.setCellData(e.row, Servicer_Check, false);
            }
            var ServicerChk = this.flexservicelog.getCellData(e.row, Servicer_Check, false);
            if (ServicerChk == true) {
                this.flexservicelog.select(e.row, Serv_index);
                this.flexservicelog.focus();
                this.flexservicelog.setCellData(e.row, M61_Check, false);
                //  this.flexservicelog.setCellData(e.row, Ignore_Check, false);
                var Serv_Value = this.flexservicelog.getCellData(e.row, Serv_index, false);
                this.flexservicelog.setCellData(e.row, Final_ValueinCalc, Serv_Value);
            }
            this.flexservicelog.invalidate();
        }
        //if (e.col == Ignore_Check) {
        //    var IgnoreChk = this.flexservicelog.getCellData(e.row, Ignore_Check, false);
        //    var OverRideValue = this.flexservicelog.getCellData(e.row, Override_index, false);
        //    if (IgnoreChk == true) {
        //        if (OverRideValue != 0) {
        //            this.CustomAlert('Combination of Override Value and Ignore is not allowed.');
        //            this.flexservicelog.setCellData(e.row, Ignore_Check, false);
        //        }
        //        this.flexservicelog.setCellData(e.row, M61_Check, false);
        //        this.flexservicelog.setCellData(e.row, Servicer_Check, false);
        //    }
        //}
        if (e.col == M61_index) {
            var M61_Value = this.flexservicelog.getCellData(e.row, M61_index, false);
            this.flexservicelog.setCellData(e.row, Final_ValueinCalc, M61_Value);
        }
        var cunt = this.ServicingLog_refreshlist.indexOf(e.row);
        if (cunt == -1) {
            var row_num = this.ServicingLog_refreshlist[e.row].row_num;
            this.flexservicelogupdatedrow_num.push(row_num);
            this.flexservicelogupdatedRowNo.push(e.row);
        }
        this.flexservicelog.invalidate();
    };
    NoteDetailComponent.prototype.pastedservicelog = function (grid, e) {
        this.ServicingLogReadOnly();
        this.flexservicelog.invalidate();
        e.cancel = true;
        //var Delta_index = this.flexservicelog.getColumn("Delta").index;
        //var Adjustment_index = this.flexservicelog.getColumn("Adjustment").index;
        //var ActualDelta_index = this.flexservicelog.getColumn("ActualDelta").index;
        //var Override_index = this.flexservicelog.getColumn("OverrideValue").index;
        //var Overridereason_index = this.flexservicelog.getColumn("OverrideReasonText").index;
        //var M61_index = this.flexservicelog.getColumn("CalculatedAmount").index;
        //var Serv_index = this.flexservicelog.getColumn("ServicingAmount").index;
        //var M61_Check = this.flexservicelog.getColumn("M61Value").index;
        //var Servicer_Check = this.flexservicelog.getColumn("ServicerValue").index;
        //var Ignore_Check = this.flexservicelog.getColumn("Ignore").index;
        //var TransactionType_ddl = this.flexservicelog.getColumn("TransactionTypeText").index;
        //var Final_ValueinCalc = this.flexservicelog.getColumn("Final_ValueUsedInCalc").index;
        //var OverrideReason_ddl = this.flexservicelog.getColumn("OverrideReason").index;
        //var sel = this.flexservicelog.selection;
        //if (e.col == Adjustment_index) {
        //    for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
        //        var Delta = this.flexservicelog.getCellData(tprow, Delta_index, false);
        //        var Adjustment = this.flexservicelog.getCellData(tprow, Adjustment_index, false);
        //        if (Delta == null && Delta == undefined) Delta = 0;
        //        if (Adjustment == null && Adjustment == undefined) Adjustment = 0;
        //        var ActualDelta = (Delta + Adjustment);
        //        this._noteext.lstNoteServicingLog[tprow].ActualDelta = ActualDelta;
        //        //this.flextrans.setCellData(e.row, ActualDelta_index, ActualDelta, true);
        //        this.flexservicelog.invalidate();
        //    }
        //}
        //if (e.col == Override_index) {
        //    for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
        //        var OverRideValue = this.flexservicelog.getCellData(tprow, Override_index, false);
        //        var M61_Value = this.flexservicelog.getCellData(tprow, M61_index, false);
        //        var Serv_Value = this.flexservicelog.getCellData(tprow, Serv_index, false);
        //        var M61Chk = this.flexservicelog.getCellData(tprow, M61_Check, false);
        //        var SerChk = this.flexservicelog.getCellData(tprow, Servicer_Check, false);
        //        var IgnoreChk = this.flexservicelog.getCellData(e.row, Ignore_Check, false);
        //        if (M61Chk) {
        //            this.CustomAlert('Combination of Override Value and M61 Value is not allowed.');
        //            this.flexservicelog.setCellData(tprow, Override_index, null);
        //        }
        //        if (SerChk) {
        //            this.CustomAlert('Combination of Override Value and Servicer Value is not allowed.');
        //            this.flexservicelog.setCellData(tprow, Override_index, null);
        //        }
        //        if (!M61_Value) M61_Value = 0;
        //        if (!OverRideValue) {
        //            if (OverRideValue == null)
        //                this.flexservicelog.setCellData(tprow, Delta_index, Serv_Value - M61_Value);
        //            if (OverRideValue == 0) {
        //                this.flexservicelog.setCellData(tprow, Delta_index, 0);
        //            }
        //            this.flexservicelog.invalidate();
        //        }
        //        else {
        //            this.flexservicelog.setCellData(tprow, Delta_index, OverRideValue - M61_Value);
        //        }
        //        if (M61Chk == false && IgnoreChk == false && SerChk == false) {
        //            this.flexservicelog.setCellData(tprow, Final_ValueinCalc, OverRideValue);
        //        }
        //        var Adjustment = this.flexservicelog.getCellData(tprow, Adjustment_index, false);
        //        var Delta = this.flexservicelog.getCellData(tprow, Delta_index, false);
        //        if (Adjustment == null && Adjustment == undefined) Adjustment = 0;
        //        if (Delta == null && Delta == undefined) Delta = 0;
        //        var ActualDelta = (Delta + Adjustment);
        //        this._noteext.lstNoteServicingLog[tprow].ActualDelta = ActualDelta;
        //        this.flexservicelog.invalidate();
        //    }
        //}
        //if (e.col == OverrideReason_ddl) {
        //    for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
        //        var OverReas = this.flexservicelog.getCellData(tprow, OverrideReason_ddl, false);
        //        if (!(Number(this._noteext.lstNoteServicingLog[tprow].OverrideReasonText).toString() == "NaN" || Number(this._noteext.lstNoteServicingLog[tprow].OverrideReasonText) == 0)) {
        //            this._noteext.lstNoteServicingLog[tprow].OverrideReason = Number(this._noteext.lstNoteServicingLog[tprow].OverrideReasonText);
        //        }
        //    }
        //}
    };
    NoteDetailComponent.prototype.ContextMenuUpdatedialogbox = function () {
        this._noteext.lstNoteServicingLog = this.ServicingLog_refreshlist;
        var ModifyCalc = document.getElementById('ModifyCalcValue')["value"];
        var ModifyComment = document.getElementById('ModifyComment')["value"];
        if (ModifyCalc) {
            this._noteext.lstNoteServicingLog[this._ClckservicelogRow]["CalculatedAmount"] = parseFloat(ModifyCalc);
            this._noteext.lstNoteServicingLog[this._ClckservicelogRow]["Final_ValueUsedInCalc"] = parseFloat(ModifyCalc);
        }
        this._noteext.lstNoteServicingLog[this._ClckservicelogRow]["comments"] = ModifyComment;
        this._noteext.lstNoteServicingLog[this._ClckservicelogRow]["SourceType"] = "Modified";
        this._noteext.lstNoteServicingLog[this._ClckservicelogRow]["ServicerMasterID"] = 7;
        this.flexservicelog.invalidate();
        this.CloseContextMenuDialog();
        var count = this.flexservicelogupdatedRowNo.indexOf(this._ClckservicelogRow);
        if (count == -1) {
            var sr = this._noteext.lstNoteServicingLog[this._ClckservicelogRow];
            var row_num = this.ServicingLog_refreshlist[this._ClckservicelogRow].row_num;
            this.flexservicelogupdatedrow_num.push(row_num);
            this.flexservicelogupdatedRowNo.push(row_num);
            this.flexservicelogToUpdate.push(sr);
            //this.flexservicelogupdatedRowNo.push(this._ClckservicelogRow);
            //this.flexservicelogToUpdate.push(sr);
        }
    };
    NoteDetailComponent.prototype.ContextMenuResetdialogbox = function () {
        this._noteext.lstNoteServicingLog[this._ClckservicelogRow]["CalculatedAmount"] = this._noteext.lstNoteServicingLog[this._ClckservicelogRow]["TransactionEntryAmount"];
        this._noteext.lstNoteServicingLog[this._ClckservicelogRow]["Final_ValueUsedInCalc"] = this._noteext.lstNoteServicingLog[this._ClckservicelogRow]["TransactionEntryAmount"];
        this._noteext.lstNoteServicingLog[this._ClckservicelogRow]["SourceType"] = "Modified";
        this._noteext.lstNoteServicingLog[this._ClckservicelogRow]["ServicerMasterID"] = 7;
        this.flexservicelog.invalidate();
        this.CloseContextMenuDialog();
        var sr = this._noteext.lstNoteServicingLog[this._ClckservicelogRow];
        var count = this.flexservicelogupdatedRowNo.indexOf(this._ClckservicelogRow);
        if (count == -1) {
            this.flexservicelogupdatedRowNo.push(this._ClckservicelogRow);
            this.flexservicelogToUpdate.push(sr);
        }
    };
    NoteDetailComponent.prototype.GetTransactionCategory = function () {
        var _this = this;
        this.calculationsvc.GetTransactionCategory().subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.dt;
                _this.listtransactioncategory = data;
                var datagroup = res.dtGroup;
                if (datagroup) {
                    _this.listtransactions = datagroup;
                    var list = [];
                    var refreshlist = [];
                    var transname = [];
                    var interestindex;
                    _this.listtransactionname = datagroup.map(function (x) { return x.TransactionName; });
                    list = datagroup.map(function (x) { return x.TransactionGroup; }).filter(function (x, i, a) { return a.indexOf(x) == i; });
                    interestindex = list.indexOf("Interest");
                    for (var j = 0; j < list.length; j++) {
                        if (j == interestindex) {
                            _this.listtransactiongroup.push({ "TransactionGroup": list[j], selected: list[interestindex] });
                        }
                        else {
                            _this.listtransactiongroup.push({ "TransactionGroup": list[j], selected: undefined });
                        }
                    }
                    _this.multiseltransactiongroup.showDropDownButton = true;
                    for (var m = 0; m < _this.listtransactions.length; m++) {
                        if (_this.listtransactions[m].TransactionGroup == "Interest") {
                            transname = _this.listtransactions.filter(function (x) { return x.TransactionGroup == _this.listtransactions[m].TransactionGroup; });
                        }
                    }
                    for (var l = 0; l < transname.length; l++) {
                        if (_this._noteext.lstNoteServicingLog) {
                            for (var j = 0; j < _this._noteext.lstNoteServicingLog.length; j++) {
                                if (transname[l].TransactionName == _this._noteext.lstNoteServicingLog[j].TransactionTypeText) {
                                    refreshlist.push(_this._noteext.lstNoteServicingLog[j]);
                                }
                            }
                        }
                    }
                    refreshlist.sort(_this.dynamicSort("row_num"));
                    //  refreshlist.sort(this.dynamicSort("RemittanceDate"));
                    _this.ServicingLog_refreshlist = refreshlist;
                    _this.cvNoteServicingLog = new wjcCore.CollectionView(refreshlist);
                    _this.cvNoteServicingLog.trackChanges = true;
                    setTimeout(function () {
                        _this.cvNoteServicingLog.refresh();
                        _this.ServicingLogReadOnly();
                    }, 1000);
                }
            }
        });
    };
    NoteDetailComponent.prototype.beginningEditMarketPrice = function () {
        var sel = this.flexmarketprice.selection;
        if (this._note.ListNoteMarketPrice[sel.topRow].Date != null)
            this.prevDateBeforeEditMarketPrice = this._note.ListNoteMarketPrice[sel.topRow].Date;
    };
    NoteDetailComponent.prototype.cellEditEndedMarketPrice = function () {
        var sel = this.flexmarketprice.selection;
        var flag = false;
        if (this._note.ListNoteMarketPrice[sel.topRow].Date.toString() != "") {
            var _notedate = new Date(this._note.ListNoteMarketPrice[sel.topRow].Date).getDate() + '/' + new Date(this._note.ListNoteMarketPrice[sel.topRow].Date).getMonth() + '/' + new Date(this._note.ListNoteMarketPrice[sel.topRow].Date).getFullYear();
        }
        for (var i = 0; i < this._note.ListNoteMarketPrice.length; i++)
            if (sel.topRow != i && _notedate == new Date(this._note.ListNoteMarketPrice[i].Date).getDate() + '/' + new Date(this._note.ListNoteMarketPrice[i].Date).getMonth() + '/' + new Date(this._note.ListNoteMarketPrice[i].Date).getFullYear())
                break;
        if (i == this._note.ListNoteMarketPrice.length)
            flag = false;
        else
            flag = true;
        if (flag == true) {
            var formatDate;
            var locale = "en-US";
            var options = { year: "numeric", month: "numeric", day: "numeric" };
            formatDate = this._note.ListNoteMarketPrice[sel.topRow].Date;
            if (formatDate.toString().indexOf("GMT") == -1)
                this.CustomAlert("Date " + formatDate + " already in list");
            else
                this.CustomAlert("Date " + formatDate.toLocaleDateString(locale, options) + " already in list");
            if (this.prevDateBeforeEditMarketPrice == null || this.prevDateBeforeEditMarketPrice == undefined) {
                this.prevDateBeforeEditMarketPrice = null;
            }
            this._note.ListNoteMarketPrice[sel.topRow].Date = this.prevDateBeforeEditMarketPrice;
        }
        this.prevDateBeforeEditMarketPrice = null;
    };
    NoteDetailComponent.prototype.pastedMarketPrice = function (s, e) {
        var sel = s.selectedItems;
        var datearr = '';
        var formatDate = '';
        var flag = false;
        for (var j = 0; j < sel.length; j++) {
            var seldate = new Date(sel[j].Date).getDate() + '/' + new Date(sel[j].Date).getMonth() + '/' + new Date(sel[j].Date).getFullYear();
            for (var k = 0; k < this._note.ListNoteMarketPrice.length; k++) {
                var _notedate = new Date(this._note.ListNoteMarketPrice[k].Date).getDate() + '/' + new Date(this._note.ListNoteMarketPrice[k].Date).getMonth() + '/' + new Date(this._note.ListNoteMarketPrice[k].Date).getFullYear();
                if (_notedate == seldate) {
                    flag = true;
                }
                else
                    flag = false;
                if (flag == true) {
                    if (sel[j].Date != "") {
                        var month = new Date(sel[j].Date).getMonth() + 1;
                        formatDate = month + '/' + new Date(sel[j].Date).getDate() + '/' + new Date(sel[j].Date).getFullYear();
                        datearr = datearr + formatDate + " ,";
                        sel[j].Date = '';
                    }
                }
            }
        }
        //find unique dates
        var distinct = [];
        var uniquedates = {};
        var listdates = datearr.split(" ,");
        for (var item, i = 0; item = listdates[i++];) {
            var _date = item;
            if (!(_date in uniquedates)) {
                uniquedates[_date] = 1;
                distinct.push(_date);
            }
        }
        if (distinct.length > 0) {
            datearr = distinct.join(" , ");
        }
        this.CustomAlert("Date " + datearr + " already in list");
    };
    NoteDetailComponent.prototype.onchangedcheckeditems = function (s, e) {
        var _this = this;
        this.getTransactionTypes();
        var list = this._noteext.lstNoteServicingLog;
        var _isdatafilterlength = false;
        var _isalldata = false;
        this.ServicingLog_refreshlist = [];
        var transname = [];
        if (s.checkedItems.length > 0) {
            for (var k = 0; k < s.checkedItems.length; k++) {
                if (s.checkedItems[k].TransactionGroup == "All Actual Transactions") {
                    this.cvNoteServicingLog = new wjcCore.CollectionView(this._noteext.lstNoteServicingLog);
                    this.cvNoteServicingLog.trackChanges = true;
                    this.ServicingLog_refreshlist = this._noteext.lstNoteServicingLog;
                    this.ServicingLog_refreshlist.sort(this.dynamicSort("row_num"));
                    _isalldata = true;
                    setTimeout(function () {
                        _this.flexservicelog.invalidate();
                        _this.ServicingLogReadOnly();
                    }, 1000);
                }
                if (s.checkedItems[k].TransactionGroup != "All Actual Transactions") {
                    if (_isalldata == false) {
                        for (var m = 0; m < this.listtransactions.length; m++) {
                            if (s.checkedItems[k].TransactionGroup == this.listtransactions[m].TransactionGroup) {
                                transname = this.listtransactions.filter(function (x) { return x.TransactionGroup == _this.listtransactions[m].TransactionGroup; });
                            }
                        }
                        for (var l = 0; l < transname.length; l++) {
                            for (var j = 0; j < list.length; j++) {
                                if (transname[l].TransactionName == list[j].TransactionTypeText) {
                                    this.ServicingLog_refreshlist.push(list[j]);
                                    _isdatafilterlength = true;
                                    _isalldata = false;
                                }
                            }
                        }
                        this.ServicingLog_refreshlist.sort(this.dynamicSort("row_num"));
                        // this._noteext.lstNoteServicingLog = this.ServicingLog_refreshlist;
                        //  this.ServicingLog_refreshlist.sort(this.dynamicSort("RemittanceDate"));
                    }
                }
            }
            if (_isdatafilterlength == false) {
                if (_isalldata == false) {
                    this.ServicingLog_refreshlist = [{ "CalculatedAmount": "0.00" }];
                    this.cvNoteServicingLog = new wjcCore.CollectionView(this.ServicingLog_refreshlist);
                    this.cvNoteServicingLog.trackChanges = true;
                    this.cvNoteServicingLog.refresh();
                    //this.ServicingLogReadOnly();
                }
            }
            else {
                this.cvNoteServicingLog = new wjcCore.CollectionView(this.ServicingLog_refreshlist);
                this.cvNoteServicingLog.trackChanges = true;
                setTimeout(function () {
                    _this.cvNoteServicingLog.refresh();
                    _this.ServicingLogReadOnly();
                }, 1000);
            }
        }
        else {
            this.cvNoteServicingLog = new wjcCore.CollectionView(this._noteext.lstNoteServicingLog);
            this.cvNoteServicingLog.trackChanges = true;
            this.ServicingLog_refreshlist.sort(this.dynamicSort("row_num"));
            setTimeout(function () {
                _this.flexservicelog.invalidate();
                _this.ServicingLogReadOnly();
            }, 1000);
        }
        // this._noteext.lstNoteServicingLog = this.ServicingLog_refreshlist;
    };
    NoteDetailComponent.prototype.sortByName = function (a, b) {
        var textA = a.FileName.toUpperCase();
        var textB = b.FileName.toUpperCase();
        return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
    };
    NoteDetailComponent.prototype.sortByPoolName = function (a, b) {
        var textA = a.Name.toUpperCase();
        var textB = b.Name.toUpperCase();
        return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
    };
    NoteDetailComponent.prototype.dynamicSort = function (property) {
        var sortOrder = 1;
        if (property[0] === "-") {
            sortOrder = -1;
            property = property.substr(1);
        }
        return function (a, b) {
            /* next line works with strings and numbers,
             * and you may want to customize it to your needs
             */
            var result = (a[property] < b[property]) ? -1 : (a[property] > b[property]) ? 1 : 0;
            return result * sortOrder;
        };
    };
    NoteDetailComponent.prototype.formatNumberforTwoDecimalplaces = function (data) {
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
    NoteDetailComponent.prototype.getHolidayMaster = function () {
        var _this = this;
        this.noteService.GetHolidayMaster().subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.dtholidaymaster;
                _this.holidayCalendarNamelist = data;
            }
        });
    };
    NoteDetailComponent.prototype.getDealMaturitybyID = function () {
        var _this = this;
        this.noteService.getMaturityDatesbyNoteid(this._note.NoteId).subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.dt;
                _this.maturityList = data;
                _this.ConvertToBindableMaturityListDates(_this.maturityList);
                _this.maturityTypeList = data.filter(function (x) { return x.MaturityType.toString() == "708" || x.MaturityType.toString() == "709" || x.MaturityType.toString() == "710"; });
                //var othermatlist = data.filter(x => x.MaturityType.toString() == "711" || x.MaturityType.toString() == "712" || x.MaturityType.toString() == "713");
                if (data.length > 0) {
                    _this.maturityEffectiveDate = _this.maturityList[0].EffectiveDate;
                    _this.maturityExpectedMaturityDate = _this.maturityList[0].ExpectedMaturityDate;
                    _this.maturityOpenPrepaymentDate = _this.maturityList[0].OpenPrepaymentDate;
                    _this.maturityActualPayoffDate = _this.maturityList[0].ActualPayoffDate;
                    _this.maturityGroupName = _this.maturityList[0].MaturityGroupName;
                    _this.MaturityDate = _this.maturityList[0].MaturityDate;
                }
                else {
                    _this.maturityEffectiveDate = null;
                    _this.maturityOpenPrepaymentDate = null;
                    _this.maturityActualPayoffDate = null;
                    _this.maturityExpectedMaturityDate = null;
                    _this.maturityGroupName = _this.maturityList[0].MaturityGroupName;
                }
                if (_this.flexMaturity) {
                    _this.flexMaturity.invalidate();
                }
            }
        });
    };
    NoteDetailComponent.prototype.ConvertToBindableMaturityListDates = function (Data) {
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
    };
    NoteDetailComponent.prototype.exportToExcel = function (filename, arr, sheets) {
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
    var _a, _b, _c, _d, _e, _f, _g, _h, _j, _k, _l, _m, _o, _p, _q, _r, _s, _t, _u, _v, _w, _x, _y, _z, _0, _1, _2, _3, _4, _5;
    __decorate([
        (0, core_1.ViewChild)('grdPeriodicData'),
        __metadata("design:type", typeof (_a = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _a : Object)
    ], NoteDetailComponent.prototype, "grdPeriodicData", void 0);
    __decorate([
        (0, core_1.ViewChild)('flexrss'),
        __metadata("design:type", typeof (_b = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _b : Object)
    ], NoteDetailComponent.prototype, "flexrss", void 0);
    __decorate([
        (0, core_1.ViewChild)('flexPrepay'),
        __metadata("design:type", typeof (_c = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _c : Object)
    ], NoteDetailComponent.prototype, "flexPrepay", void 0);
    __decorate([
        (0, core_1.ViewChild)('flexstripping'),
        __metadata("design:type", typeof (_d = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _d : Object)
    ], NoteDetailComponent.prototype, "flexstripping", void 0);
    __decorate([
        (0, core_1.ViewChild)('flexfinancingfee'),
        __metadata("design:type", typeof (_e = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _e : Object)
    ], NoteDetailComponent.prototype, "flexfinancingfee", void 0);
    __decorate([
        (0, core_1.ViewChild)('flexFinancingSch'),
        __metadata("design:type", typeof (_f = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _f : Object)
    ], NoteDetailComponent.prototype, "flexFinancingSch", void 0);
    __decorate([
        (0, core_1.ViewChild)('flexdefaultsch'),
        __metadata("design:type", typeof (_g = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _g : Object)
    ], NoteDetailComponent.prototype, "flexdefaultsch", void 0);
    __decorate([
        (0, core_1.ViewChild)('flexservicelog'),
        __metadata("design:type", typeof (_h = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _h : Object)
    ], NoteDetailComponent.prototype, "flexservicelog", void 0);
    __decorate([
        (0, core_1.ViewChild)('grdCalcData'),
        __metadata("design:type", typeof (_j = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _j : Object)
    ], NoteDetailComponent.prototype, "grdCalcData", void 0);
    __decorate([
        (0, core_1.ViewChild)('flexnoteexceptions'),
        __metadata("design:type", typeof (_k = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _k : Object)
    ], NoteDetailComponent.prototype, "flexnoteexceptions", void 0);
    __decorate([
        (0, core_1.ViewChild)('flexDocument'),
        __metadata("design:type", typeof (_l = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _l : Object)
    ], NoteDetailComponent.prototype, "flexDocument", void 0);
    __decorate([
        (0, core_1.ViewChild)('f'),
        __metadata("design:type", Object)
    ], NoteDetailComponent.prototype, "fnotes", void 0);
    __decorate([
        (0, core_1.ViewChild)('ServicingDropDateflex'),
        __metadata("design:type", typeof (_m = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _m : Object)
    ], NoteDetailComponent.prototype, "flexServicingDropDate", void 0);
    __decorate([
        (0, core_1.ViewChild)('ctxMenu'),
        __metadata("design:type", typeof (_o = typeof wjcInput !== "undefined" && wjcInput.Menu) === "function" ? _o : Object)
    ], NoteDetailComponent.prototype, "ctxMenu", void 0);
    __decorate([
        (0, core_1.ViewChild)('flexmarketprice'),
        __metadata("design:type", typeof (_p = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _p : Object)
    ], NoteDetailComponent.prototype, "flexmarketprice", void 0);
    __decorate([
        (0, core_1.ViewChild)('flexnotecommitments'),
        __metadata("design:type", typeof (_q = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _q : Object)
    ], NoteDetailComponent.prototype, "flexnotecommitments", void 0);
    __decorate([
        (0, core_1.ViewChild)('RuleTypeList'),
        __metadata("design:type", typeof (_r = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _r : Object)
    ], NoteDetailComponent.prototype, "RuleTypeList", void 0);
    __decorate([
        (0, core_1.ViewChild)('futurefundingflex'),
        __metadata("design:type", typeof (_s = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _s : Object)
    ], NoteDetailComponent.prototype, "futurefundingflex", void 0);
    __decorate([
        (0, core_1.ViewChild)('fixedamortflex'),
        __metadata("design:type", typeof (_t = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _t : Object)
    ], NoteDetailComponent.prototype, "fixedamortflex", void 0);
    __decorate([
        (0, core_1.ViewChild)('laborflex'),
        __metadata("design:type", typeof (_u = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _u : Object)
    ], NoteDetailComponent.prototype, "laborflex", void 0);
    __decorate([
        (0, core_1.ViewChild)('feecouponflex'),
        __metadata("design:type", typeof (_v = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _v : Object)
    ], NoteDetailComponent.prototype, "feecouponflex", void 0);
    __decorate([
        (0, core_1.ViewChild)('pikflex'),
        __metadata("design:type", typeof (_w = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _w : Object)
    ], NoteDetailComponent.prototype, "pikflex", void 0);
    __decorate([
        (0, core_2.Input)(),
        __metadata("design:type", String)
    ], NoteDetailComponent.prototype, "fileExt", void 0);
    __decorate([
        (0, core_2.Input)(),
        __metadata("design:type", Number)
    ], NoteDetailComponent.prototype, "maxFiles", void 0);
    __decorate([
        (0, core_2.Input)(),
        __metadata("design:type", Number)
    ], NoteDetailComponent.prototype, "maxSize", void 0);
    __decorate([
        (0, core_1.Output)(),
        __metadata("design:type", Object)
    ], NoteDetailComponent.prototype, "uploadStatus", void 0);
    __decorate([
        (0, core_1.ViewChild)('multiseltransactioncategory'),
        __metadata("design:type", typeof (_x = typeof wjNg2Input !== "undefined" && wjNg2Input.WjMultiSelect) === "function" ? _x : Object)
    ], NoteDetailComponent.prototype, "multiseltransactioncategory", void 0);
    __decorate([
        (0, core_1.ViewChild)('multiseltransactiongroup'),
        __metadata("design:type", typeof (_y = typeof wjNg2Input !== "undefined" && wjNg2Input.WjMultiSelect) === "function" ? _y : Object)
    ], NoteDetailComponent.prototype, "multiseltransactiongroup", void 0);
    __decorate([
        (0, core_1.ViewChild)('flexMaturity'),
        __metadata("design:type", typeof (_z = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _z : Object)
    ], NoteDetailComponent.prototype, "flexMaturity", void 0);
    __decorate([
        (0, core_1.HostListener)('window:beforeunload', ['$event']),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Object]),
        __metadata("design:returntype", void 0)
    ], NoteDetailComponent.prototype, "beforeunloadHandler", null);
    __decorate([
        (0, core_1.ViewChild)('flexnoteperiodiccalc'),
        __metadata("design:type", typeof (_0 = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _0 : Object)
    ], NoteDetailComponent.prototype, "flexnoteperiodiccalc", void 0);
    __decorate([
        (0, core_1.ViewChild)('flexTransactionEntry'),
        __metadata("design:type", typeof (_1 = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _1 : Object)
    ], NoteDetailComponent.prototype, "flexTransactionEntry", void 0);
    __decorate([
        (0, core_1.ViewChild)('flexnoteoutputnpv'),
        __metadata("design:type", typeof (_2 = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _2 : Object)
    ], NoteDetailComponent.prototype, "flexnoteoutputnpv", void 0);
    NoteDetailComponent = __decorate([
        (0, core_1.Component)({
            selector: "notedetail",
            templateUrl: "app/components/notedetail.html?v=" + $.getVersion(),
            providers: [noteService_1.NoteService, dealservice_1.dealService, utilityService_1.UtilityService, membershipservice_1.MembershipService, fileuploadservice_1.FileUploadService, functionService_1.functionService]
        }),
        __metadata("design:paramtypes", [typeof (_3 = typeof router_1.ActivatedRoute !== "undefined" && router_1.ActivatedRoute) === "function" ? _3 : Object, typeof (_4 = typeof ng2_file_input_1.Ng2FileInputService !== "undefined" && ng2_file_input_1.Ng2FileInputService) === "function" ? _4 : Object, fileuploadservice_1.FileUploadService,
            noteService_1.NoteService,
            dealservice_1.dealService,
            utilityService_1.UtilityService,
            searchService_1.SearchService,
            membershipservice_1.MembershipService,
            signalRService_1.SignalRService,
            CalculationManagerService_1.CalculationManagerService, typeof (_5 = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _5 : Object, functionService_1.functionService,
            scenarioService_1.scenarioService])
    ], NoteDetailComponent);
    return NoteDetailComponent;
}(paginated_1.Paginated));
exports.NoteDetailComponent = NoteDetailComponent;
var routes = [
    { path: '', component: NoteDetailComponent }
];
var NoteDetailModule = /** @class */ (function () {
    function NoteDetailModule() {
    }
    NoteDetailModule = __decorate([
        (0, core_2.NgModule)({
            // imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjInputModule, WjGridFilterModule],
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_input_1.WjInputModule, wijmo_angular2_grid_filter_1.WjGridFilterModule, ng2_file_input_1.Ng2FileInputModule.forRoot()],
            declarations: [NoteDetailComponent]
        })
    ], NoteDetailModule);
    return NoteDetailModule;
}());
exports.NoteDetailModule = NoteDetailModule;
//# sourceMappingURL=notedetail.component.js.map