import { Component, OnInit, AfterViewInit, ViewChild, Output, HostListener, EventEmitter } from "@angular/core";
import { Router, ActivatedRoute, Params } from '@angular/router';
import { Note, DownloadCashFlow, NoteMarketPrice } from "../core/domain/note.model";
import { NoteDateObjects } from "../core/domain/noteDateObjects.model";
import { NoteService } from '../core/services/note.service';
import { UtilityService } from '../core/services/utility.service';
import { MembershipService } from '../core/services/membership.service';
import { User } from '../core/domain/user.model';
import { Search } from "../core/domain/search.model";
import { SearchService } from '../core/services/search.service';
import { NoteAdditionalList } from "../core/domain/noteAdditionalList.model";
import { NoteAdditionalListObject } from "../core/domain/noteAdditionalListObject.model";

import { financingWarehouseService } from '../core/services/financingWarehouse.service';

import { Paginated } from '../core/common/paginated.service';
import * as wjcCore from '@grapecity/wijmo';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { NoteCashflowsExportDataList } from "../core/domain/noteCashflowsExportDataList.model";
import { ModuleWithProviders, Input, Inject, enableProdMode, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjInputModule } from '@grapecity/wijmo.angular2.input';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import { userdefaultsetting } from '../core/domain/userDefaultSetting.model';
import { SignalRService } from './../Notification/signalR.service';
import appsettings from '../../../../appsettings.json';
//import { Notificationsettings, _storageType } from '../../../../appsettings.json';
import { Module } from "../core/domain/module.model";
import { dealService } from '../core/services/deal.service';
import { ActivityLog } from "../core/domain/activityLog.model";
import { Document } from "../core/domain/document.model";
import { FileUploadService } from '../core/services/fileUpload.service';
//import { Ng2FileInputModule, Ng2FileInputService, Ng2FileInputAction } from 'ng2-file-input';
import { functionService } from '../core/services/function.service';
import { scenarioService } from '../core/services/scenario.service';
import { Scenario, RuleType } from '../core/domain/scenario.model';
import { devDashBoard } from './../core/domain/devDashBoard.model';
import { CalculationManagerService } from '../core/services/calculationManager.service';
import { dndDirectiveModule } from "../directives/dnd.directive";
import * as wjcGrid from '@grapecity/wijmo.grid';
import * as wjcInput from '@grapecity/wijmo.input';
import * as wjNg2Input from '@grapecity/wijmo.angular2.input';

declare var XLSX: any;
declare var $: any;

@Component({
  selector: "notedetail",
  templateUrl: "./notedetail.html",
  providers: [NoteService, dealService, UtilityService, MembershipService, FileUploadService, functionService]
})

export class NoteDetailComponent extends Paginated implements OnInit {
  cvRateSpreadScheduleList: wjcCore.CollectionView;
  cvNotePrepayAndAdditionalFeeScheduleList: wjcCore.CollectionView;
  cvNoteStrippingList: wjcCore.CollectionView;
  cvNoteServicingLog: wjcCore.CollectionView;
  cvDeletedNoteServicingLog: wjcCore.CollectionView;
  cvNoteServicerDropDateSetup: wjcCore.CollectionView;
  cvEditRateSpreadScheduleList: wjcCore.CollectionView;
  cvEditFeeScheduleList: wjcCore.CollectionView;
  cvEditPIKSchedulelist: wjcCore.CollectionView;
  public _note: Note;
  public _noteDateObjects: NoteDateObjects;
  public _noteext: NoteAdditionalList;
  private _ruletype: RuleType;
  public _noteextt: NoteAdditionalListObject;
  public _noteEditList: NoteAdditionalListObject;
  public _validationobject: NoteAdditionalList;
  public lstnotesexceptions: any = [];
  public _ExceptionListCount: number = 1;
  public _CritialExceptionListCount: number = 1;
  public _ShowmessagedivWarnote: boolean = false;
  public _ShowmessagenotedivWar: boolean = false;
  public _Showmessagenotediv: boolean = false;

  public _noteArchieveext: NoteAdditionalList;
  public _noteArchieveextt: NoteAdditionalListObject;
  Message: any;
  public _isShowFuturefunding: boolean = false;
  public _isShowAccounting: boolean = false;
  public _isShowClosing: boolean = false;
  public _isShowFinancing: boolean = false;
  public _isShowSettlement: boolean = false;
  public _isShowServicing: boolean = false;
  public _isShowServicelog: boolean = false;
  public _isShowPiksource: boolean = false;
  public _isShowFeecoupon: boolean = false;
  public _isShowLibor: boolean = false;
  public _isShowFixedamort: boolean = false;
  public _isShowPeriodicoutput: boolean = false;
  public _isshowsavenote: boolean = false;
  public _isShowCopynote: boolean = false;
  public _isShowCalcbutton: boolean = true;
  public _norecordfound: boolean = true;

  public showpikAdditionalrate: boolean = true;
  public showpikAccrualrate: boolean = true;
  public showpikAccruesrate: boolean = true;
  public showpikwithPIKSeparateCompounding: boolean = true;

  public showCurrentPayRate: boolean = true;

  showpiksetupdiv: boolean = true;
  public _isShowServicingDropDate: boolean = false;
  public _isShowScenariodiv: boolean = false;
  public _isShowRuleTypediv: boolean = false;
  public _isShowbtnResetdiv: boolean = false;
  public _noteCashflowsExportDataList: NoteCashflowsExportDataList;
  public _userdefaultsetting: userdefaultsetting;
  public _liborindexMsg: boolean = true;
  public _showliborgride: boolean = false;
  public lstFundingDeletedSchedule: any = [];
  public deleteRowIndex: number;
  public _showexceptionEmptymessage: boolean = false;
  // private _showexceptionEmptydiv: boolean = false;
  public _isShowDownloadCashflows: boolean = false;
  public _errorMsgDateValidation: string = "";

  _ShowmessagedivMsgWarnote: any;
  _ShowmessagenotedivMsgWar: any;
  _ShowmessagenotedivMsg: any;
  exceptionscount: any;
  exceptionscount_normal: number = 0;
  exceptionscount_critical: number = 0;
  public _isExceptionscount: boolean = false;
  public _isShowActivityLog: boolean = false;
  public _isShowNoteRules: boolean = false;
  public _showamortcheck: boolean = false;
  public _showgaapcheck: boolean = false;
  public _isRuleTabClicked: boolean = false;
  public _lstruletype: any;
  public _lstgetallrule: any = [];
  public _lstruletypedetail: any = [];
  public _lstRuleTypeSetupNew: any = [];
  public _lstRuleTypeSetuptobesend: any = [];
  public _lstRuleTypeSetupfilter: any = [];
  public _Showmessagedivrule: boolean = false;
  public _ShowmessagedivruleMsg: string = '';
  lstAccountingMode: any;
  lstexception: any;
  lstGeographicLoc: any;
  lstLoanType: any;
  lstClassification: any;
  lstSubClassification: any;
  lstGAAPDesignation: any;
  lstPropertyType: any;
  lstServicerType: any;
  lstPayFrequency: any;
  lstYesNo: any;
  lstLoanCurrency: any;
  lstRateType: any;
  lstStatus: any;
  lstIntCalcMethodID: any;
  lstDeterminationDateHoliday: any;
  lstFinancingPayFrequency: any;
  lstRateSpreadSch_ValueType: any;
  lstTransactionType: any;
  lstIndextype: any;
  lstPrepayAdditinalFee_ValueType: any;
  lstStrippingSch_ValueType: any;
  lstDefaultSch_ValueType: any;
  lstFinancingFeeSch_ValueType: any;
  lstFinancingSch_ValueType: any;
  lstRoundingMethod: any;
  lstClient: any;
  lstFund: any;
  lstFinancingSource: any;
  lstDebtType: any;
  lstBillingNotes: any;
  lstCapStack: any;
  lstPool: any;
  lstServicerName: any;

  lstFeeTypeLookUp: any;
  lstPIKInterestCalcmethod: any;

  lstPrepayAdditinalFee_lstApplyTrueUpFeature: any;
  lstRoundingNote: any;
  lstCalculationMode: any;
  lstScenario: any;
  lstInterestCalculationRuleForPaydowns: any;
  lstInterestCalculationRuleForPaydownsAmort: any;
  lstAccrualPeriodType: any;
  lstAccrualPeriodBusinessDayAdj: any;
  //  lstddlOverideComment: any;
  TargetAccountID: any;
  SourceAccountID: any;
  calcExceptionMsg: any = "Error occurred";
  MaturityEffectiveDate: Date;
  MaturityDate: Date;
  Servicing_EffectiveDate: Date;
  Servicing_Date: Date;
  Servicing_Value: any;
  Servicing_IsCapitalized: any;
  MaturityType: number;
  PIKSchedule_StartDate: Date;
  PIKSchedule_EndDate: Date;
  PIKSchedule_SourceAccountID: any;
  PIKSchedule_SourceAccount: any;
  PIKSchedule_TargetAccountID: any;
  PIKSchedule_TargetAccount: any;
  PIKSchedule_AdditionalIntRate: any;

  PIKSchedule_AdditionalSpread: any;
  PIKSchedule_IndexFloor: any;
  PIKSchedule_IntCompoundingRate: any;
  PIKSchedule_IntCompoundingSpread: any;
  PIKSchedule_IntCapAmt: any;
  PIKSchedule_PeriodicRateCapAmount: any;
  PIKSchedule_PeriodicRateCapPercent: any;
  PIKSchedule_PurBal: any;
  PIKSchedule_AccCapBal: any;

  PIKSchedule_PIKReasonCodeID: any;
  PIKSchedule_PIKComments: any;
  PIKSchedule_PIKReasonCodeIDText: any;

  PIKSchedule_PIKIntCalcMethodID: any;
  PIKSchedule_PIKIntCalcMethodIDText: any;
  PIKSetUp: any;
  PIKSetUpText: any;
  PIKPercentage: any;
  PIKCurrentPayRate: any;
  PIKSeparateCompounding: any;
  PIKSeparateCompoundingText: any;
  Ratespread_EffectiveDate: Date;
  PrepayAndAdditionalFeeSchedule_EffectiveDate: Date;
  StrippingSchedule_EffectiveDate: Date;
  FinancingFeeSchedule_EffectiveDate: Date;
  FinancingSchedule_EffectiveDate: Date;
  DefaultSchedule_EffectiveDate: Date;
  PIKSchedule_EffectiveDate: Date;

  Ratespread_EffectiveDateOld: Date;
  PrepayAndAdditionalFeeSchedule_EffectiveDateOld: Date;
  StrippingSchedule_EffectiveDateOld: Date;
  FinancingFeeSchedule_EffectiveDateOld: Date;
  FinancingSchedule_EffectiveDateOld: Date;
  DefaultSchedule_EffectiveDateOld: Date;
  PIKSchedule_EffectiveDateOld: Date;
  dataMapValueType: any;
  public _result: any;
  public _pagePath: any;
  public _searchObj: Search;
  public _isSearchDataFetching: boolean = false;
  public _pageSizeSearch: number = 10;
  public _pageIndexSearch: number = 1;
  public _totalCountSearch: number = 0;
  public _dvEmptySearchMsg: boolean = false;
  public initialised = 0;


  public _pageSizeActivity: number = 50;
  public _pageIndexActivity: number = 1;
  public _totalCountActivity: number = 0;
  public CurrentcountActivity: number = 0;
  public currentactivity = new Array<ActivityLog>();
  public arrActivity = new Array<ActivityLog>();
  public arrActivityArrangeByDate = new Array<ActivityLog>();
  public arrParentCreatedDate: any;

  public arrActivityToday = new Array<ActivityLog>();
  public arrActivityTodayMore = new Array<ActivityLog>();
  public arrActivityYesterday = new Array<ActivityLog>();
  public arrActivityYesterdayMore = new Array<ActivityLog>();
  public isActivityTday: boolean = false;
  public isActivityYday: boolean = false;
  public isActivityPday: boolean = false;

  @ViewChild('grdPeriodicData') grdPeriodicData: wjcGrid.FlexGrid;
  //@ViewChild(PeriodicDataComponent) periodicDataComponent: PeriodicDataComponent;
  @ViewChild('flexrss') flexrss: wjcGrid.FlexGrid;
  @ViewChild('flexPrepay') flexPrepay: wjcGrid.FlexGrid;
  @ViewChild('flexstripping') flexstripping: wjcGrid.FlexGrid;
  @ViewChild('flexfinancingfee') flexfinancingfee: wjcGrid.FlexGrid;
  @ViewChild('flexFinancingSch') flexFinancingSch: wjcGrid.FlexGrid;
  @ViewChild('flexdefaultsch') flexdefaultsch: wjcGrid.FlexGrid;
  @ViewChild('flexservicelog') flexservicelog: wjcGrid.FlexGrid;
  @ViewChild('grdCalcData') grdCalcData: wjcGrid.FlexGrid;
  @ViewChild('flexnoteexceptions') flexnoteexceptions: wjcGrid.FlexGrid;
  @ViewChild('flexDocument') flexDocument: wjcGrid.FlexGrid;
  //@ViewChild('flexNoteCashflowsExportDataList') flexNoteCashflowsExportDataList: wjcGrid.FlexGrid;
  @ViewChild('f') fnotes;
  @ViewChild('ServicingDropDateflex') flexServicingDropDate: wjcGrid.FlexGrid;
  @ViewChild('ctxMenu') ctxMenu: wjcInput.Menu;
  @ViewChild('flexmarketprice') flexmarketprice: wjcGrid.FlexGrid;
  @ViewChild('flexnotecommitments') flexnotecommitments: wjcGrid.FlexGrid;
  @ViewChild('NoteEditRSSData') flexEditRSS: wjcGrid.FlexGrid;
  @ViewChild('NoteEditFEEData') flexEditFee: wjcGrid.FlexGrid;
  @ViewChild('NoteEditPIKData') flexEditPIK: wjcGrid.FlexGrid;
  public rssupdatedRowNo: any = [];
  public rssrowsToUpdate: any = [];
  public prepayrowsToUpdate: any = [];
  public prepayupdatedRowNo: any = [];
  public strippingrowsToUpdate: any = [];
  public strippingupdatedRowNo: any = [];
  public financingfeeupdatedRowNo: any = [];
  public financingfeerowsToUpdate: any = [];
  public flexfinancingschupdatedRowNo: any = [];
  public flexfinancingschrowsToUpdate: any = [];

  public flexdefaultschupdatedRowNo: any = [];
  public flexdefaultschrowsToUpdate: any = [];

  public flexfuturefundingupdatedRowNo: any = [];
  public flexfuturefundingrowsToUpdate: any = [];

  public flexPikupdatedRowNo: any = [];
  public flexPikrowsToUpdate: any = [];

  public flexLiborupdatedRowNo: any = [];
  public flexLiborrowsToUpdate: any = [];

  public flexFixedAmortupdatedRowNo: any = [];
  public flexFixedAmortrowsToUpdate: any = [];

  public flexfeecouponUpdatedRowNo: any = [];
  public flexfeecouponrowsToUpdate: any = [];

  public flexservicelogupdatedRowNo: any = [];
  public flexservicelogupdatedrow_num: any = [];
  public flexservicelogToUpdate: any = [];

  public PIKrowsToUpdate: any = [];

  public maturityupdatedrow: any = [];
  public pikupdatedrow: any = [];
  public lstfinancingwhouse: any;
  public lstLiborSchedule: any;

  //   @ViewChild('pikAsync') sourceaccount: wjNg2Input.WjAutoComplete;


  public maturityTypeList: any = [];
  public lstMaturity: any = [];
  public ShowHideFlagMaturity: boolean = false;
  public ShowHideFlagBalanceTransactionSchedule: boolean = false;
  public ShowHideFlagDefaultSchedule: boolean = false;
  public ShowHideFlagFeeCouponSchedule: boolean = false;
  public ShowHideFlagFinancingFeeSchedule: boolean = false;
  public ShowHideFlagFinancingSchedule: boolean = false;
  public ShowHideFlagPIKSchedule: boolean = false;
  public ShowHideFlagPrepayAndAdditionalFeeSchedule: boolean = false;
  public ShowHideEditPrepayAndAdditionalFeeSchedule: boolean = false;
  public ShowHideFlagRateSpreadSchedule: boolean = false;
  public ShowHideEditRateSpreadSchedule: boolean = false;
  public ShowHideEditPIKSchedule: boolean = false;
  public ShowHideFlagServicingFeeSchedule: boolean = false;
  public ShowHideFlagStrippingSchedule: boolean = false;

  public ShowHideFlagFutureFunding: boolean = false;
  public ShowHideFlagLiborSchedule: boolean = false;
  public ShowFlagHideFixedAmortSchedule: boolean = false;
  public ShowHideFlagPIKfromPIKSourceNote: boolean = false;
  public ShowHideFlagFeeCouponStripReceivable: boolean = false;
  public isSaveOnly: boolean = false;
  public _islastCalcDateTime: boolean = true;

  // private _noteobj: NoteObject

  public FutureFundingEffactiveDate: any;
  public LiborScheduleEffactiveDate: any;
  public FixedAmortScheduleEffactiveDate: any;
  public PIKfromPIKSourceNoteEffactiveDate: any;
  public FeeCouponStripReceivableEffactiveDate: any;
  public lstPIKfromPIKSourceNoteTab: any;
  public lstFeeCouponStripReceivableTab: any;

  public valueType: string;
  public prevDateBeforeEdit: Date;
  public currentActivityDate: Date;
  public strActivity: string = '';
  public firstDat: string;

  public prevEndDateBeforeEdit: Date;


  @ViewChild('futurefundingflex') futurefundingflex: wjcGrid.FlexGrid;
  @ViewChild('fixedamortflex') fixedamortflex: wjcGrid.FlexGrid;
  @ViewChild('laborflex') laborflex: wjcGrid.FlexGrid;
  @ViewChild('feecouponflex') feecouponflex: wjcGrid.FlexGrid;
  @ViewChild('pikflex') pikflex: wjcGrid.FlexGrid;
  // PeriodicData
  //public _note: Note;

  public lstratingagency: any;
  public lstriskrating: any;
  public lstCashflowEngineID: any;
  public lstPurposeType: any;
  public setlstPeriodicDataList: any;
  public modulename: string;
  public lstPeriodicDataList: any;
  public _isPeriodicDataFetching: boolean;
  public _isPeriodicDataFetched: boolean = true;
  public _isCalcDataFetched: boolean = false;
  public _isCalcJsonFetched: boolean = false;
  public _isCalcJsonResponseFetched: boolean = false;
  public _isCashFlowClicked: boolean = false;
  public _dvEmptyPeriodicDataMsg: boolean = false;
  public _isSetHeaderEmpty: boolean = false;
  public savedialogmsg: any;
  //additional data
  public RateSpreadScheduleList: any;
  public IsOpenClosingTab: boolean = false;
  public IsOpenFinancingTab: boolean = false;
  public IsOpenExceptionTab: boolean = false;
  public IsOpenServicingTab: boolean = false;
  public IsOpenServicinglogTab: boolean = false;
  public IsOpenshowpikflex: boolean = false;
  public IsOpenshowfeecouponflex: boolean = false;
  public IsOpenshowlaborflex: boolean = false;
  public IsOpenshowfixedamortflex: boolean = false;
  public IsOpenshowfuturefundingflex: boolean = false;
  public IsOpenshowperiodicoutputflex: boolean = false;
  public IsOpenshownoteoutputnpvflex: boolean = false;
  public IsOpenActivityTab: boolean = false;
  public IsOpenServicingDropDateTab: boolean = false;
  private _devDashBoard: devDashBoard;
  _isNoteSaving: boolean = false;
  _isSuperAdminUser: boolean = false;
  public _disabled: boolean = true;
  public _noteExistMsg: string = '';
  public _noteCopyMsg: string = null;
  public _dealNoExistMsg: string = '';
  public _isCopyonly: boolean = false;
  public _copymessagediv: boolean = false;
  public _copymessagedivMsg: string = '';
  public _isCopyandopen: boolean = false;
  public Copy_Dealid: string = '';
  public Copy_DealName: string = '';
  public _dealIndex: number = -1;
  public _isNoteSaveonly: boolean = false;
  public _user: User;
  public _isConvertDate: boolean = false;
  public _isConvertGridDate: boolean = false;
  public rolename: string;
  public _dtUTCHours: number;
  public _userOffset: number;
  public _centralOffset: number;

  public lstTransactionEntry: any;

  public MsgForUseRuletoDetermine: string;
  public _isShowMsgForUseRuletoDetermine: boolean = false;
  public gParentNoteid: any;
  public EnableM61Calculations: any;
  public FullIOTermFlag: any;

  public EmptynoteperiodiccalcMsgString: any;

  public ModifyCalcValue: number = 123;
  public ModifyComment: string = "test";

  columns: {
    binding?: string, header?: string, width?: any, format?: string
  }[];

  public lstNoteDeleteFilter: any;
  public _moduledelete: Module;
  public _MsgText: string;
  selectedDeleteOption: any
  public _isDeleteOPtionOk: boolean = false;
  public deleteoptiontext: string = "";
  public _activityLog: ActivityLog;
  lstActivityLog: any;
  activityMessage: string;
  public _isCallConcurrentCheck: boolean = false;
  public isProcessComplete: boolean = false;
  public fileList: FileList;
  public files = [];
  errors: Array<string> = [];
  @Input() fileExt: string = "JPG, JPEG, PNG, XLS, XLSX, CSV, PDF, DOC, DOCX";
  @Input() maxFiles: number = 5;
  @Input() maxSize: number = 5; // 15MB
  @Output() uploadStatus = new EventEmitter();
  public _document: Document;
  public myFileInputIdentifier: string = "tHiS_Id_IS_sPeeCiAL";
  public _pageSizeDocImport: number = 30;
  public _pageIndexDocImport: number = 1;
  public _totalCountDocImport: number = 0;
  public isScrollHandlerAdded: boolean = false;
  lstDocuments: any;
  public _dvEmptyDocumentMsg: boolean = false;
  public IsOpenDocImportTab: boolean = false;
  public _isShowDocImport: boolean = false;

  public actionLog: string = "";
  public _uploadedDocumentLogID: number;
  ListHoliday: any;
  _isvalidateHolidaySatSun: boolean = true;

  public ScenarioId: any;
  public SelectedScenarioId: any;
  public _lstScenario: any;
  public _scenariodc: Scenario;
  ScenarioName: string;

  public SelectedCouponScenarioId: any;
  public IsbtnClickText: any;
  public IsActive: boolean = false;

  public EffectiveDateCountMaturity: any;
  public EffectiveDateCountBalanceTransactionSchedule: any;
  public EffectiveDateCountDefaultSchedule: any;
  public EffectiveDateCountFeeCouponSchedule: any;
  public EffectiveDateCountFinancingFeeSchedule: any;
  public EffectiveDateCountFinancingSchedule: any;
  public EffectiveDateCountPIKSchedule: any;
  public EffectiveDateCountPrepayAndAdditionalFeeSchedule: any;
  public EffectiveDateCountRateSpreadSchedule: any;
  public EffectiveDateCountServicingFeeSchedule: any;
  public EffectiveDateCountStrippingSchedule: any;
  public EffectiveDateCountLiborSchedule: any;
  public EffectiveDateCountPIKScheduleDetail: any;
  public EffectiveDateCountFeeCouponStripReceivable: any;
  public EffectiveDateCountAmortSchedule: any;
  public EffectiveDateCountFundingSchedule: any;
  public _timezoneAbbreviation: any;
  public listtransactiontype: any;
  lstStrategy: any;
  hti: any;
  public _ClckservicelogRow: number = -1;
  public _ClckservicelogCol: number = -1;
  public listtransactioncategory: any = [];
  public listtransactiongroup: any = [];
  @ViewChild('multiseltransactioncategory') multiseltransactioncategory: wjNg2Input.WjMultiSelect
  @ViewChild('multiseltransactiongroup') multiseltransactiongroup: wjNg2Input.WjMultiSelect
  @ViewChild('selectColumnGroups') selectColumnGroups: wjNg2Input.WjMultiSelect

  ListNoteMarketPrice: wjcCore.CollectionView;
  public changedlstmarketnote: any = [];
  public originallstnotemarketprice: any = [];
  public prevDateBeforeEditMarketPrice: Date;
  public listtransactionname: any = [];
  public listtransactions: any = [];
  public deleteMarketPriceList: any = [];
  public transacatename: any;
  public ServicingLog_refreshlist: any = [];
  public NoteCommitmentList: any = [];
  public _isNotecommitmentlst: boolean = false;
  public _ShowNotecommitmentmsg: any;
  public _totalcommitmenttextboxvalue;
  public _aggregatedcommitmenttexboxtvalue;
  public _adjustedcommitmenttextboxvalue;
  public _basecurrencyname: any;
  public holidayCalendarNamelist: any = [];
  @ViewChild('flexMaturity') flexMaturity: wjcGrid.FlexGrid;
  @ViewChild('RuleTypeList') RuleTypeList: wjcGrid.FlexGrid;
  public maturityList: any = [];
  public maturityEffectiveDate: any;
  public maturityExpectedMaturityDate: any;
  public maturityOpenPrepaymentDate: any;
  public maturityActualPayoffDate: any;
  public maturityGroupName: any;
  isResetMenuShow: boolean = false;
  lstAdjustmentType: any;

  public lstXIRRTags: any = [];
  lstNoteEditRSSlist: any = [];
  lstNoteEditFEElist: any = [];
  lstNoteEditPIKSchedulelist: any = [];
  deleteRateSpreadSchedulePopup: any = [];
  deleteFeeSchedulePopup: any = [];
  deletePIKSchedulePopup: any = [];
  newEffectiveDates: any;
  existingEffectiveDatesRSS: any;
  existingEffectiveDatesFEE: any;
  existingEffectiveDatesPIK: any;
  lstCheckDuplicateTransactionCashflow: any;
  lstPIKSetuptype: any;
  lstPIKReasonCodetype: any;
  lstPIKCompoundingType: any;
  lstPIKCashIntCalc: any;
  lstPIKImpactinCommit: any;

  columnGroupHeaders: any[] = [];
  selectedColumnGroups: any[] = [];

  getColumnGroups(): any[] {
    const groups = [
      { binding: 'PeriodEndDate', header: 'Period End Date', align: 'right' },
      { binding: 'Month', header: 'Month', align: 'right', format: 'n0' },
      {
        header: 'Balance', align: 'center', collapseTo: 'BeginningBalance', columns: [
          {
            binding: 'BeginningBalance', header: 'Beginning balance', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const BeginningBalance = cell.item.BeginningBalance;
              const color = BeginningBalance < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${BeginningBalance.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'TotalFutureAdvancesForThePeriod', header: 'Total future advances for the period', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const TotalFutureAdvancesForThePeriod = cell.item.TotalFutureAdvancesForThePeriod;
              const color = TotalFutureAdvancesForThePeriod < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${TotalFutureAdvancesForThePeriod.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'TotalDiscretionaryCurtailmentsforthePeriod', header: 'Total discretionary curtailments for the period', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const TotalDiscretionaryCurtailmentsforthePeriod = cell.item.TotalDiscretionaryCurtailmentsforthePeriod;
              const color = TotalDiscretionaryCurtailmentsforthePeriod < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${TotalDiscretionaryCurtailmentsforthePeriod.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'ScheduledPrincipal', header: 'Scheduled Principal', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const ScheduledPrincipal = cell.item.ScheduledPrincipal;
              const color = ScheduledPrincipal < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${ScheduledPrincipal.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          //{
          //  binding: 'PrincipalPaid', header: 'Principal Paid', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
          //    const PrincipalPaid = cell.item.PrincipalPaid;
          //    const color = PrincipalPaid < 0 ? 'red' : 'darkgreen';
          //    return `<div style="color: ${color};">${PrincipalPaid.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
          //  }
          //},
          {
            binding: 'NetPIKAmountForThePeriod', header: 'Net PIK Amount For The Period', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const NetPIKAmountForThePeriod = cell.item.NetPIKAmountForThePeriod;
              const color = NetPIKAmountForThePeriod < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${NetPIKAmountForThePeriod.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'BalloonPayment', header: 'Balloon Payment', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const BalloonPayment = cell.item.BalloonPayment;
              const color = BalloonPayment < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${BalloonPayment.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'EndingBalance', header: 'Ending Balance', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const EndingBalance = cell.item.EndingBalance;
              const color = EndingBalance < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${EndingBalance.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
        ]
      },
      {
        header: 'Clean Cost', align: 'center', collapseTo: 'GrossDeferredFees', columns: [
          {
            binding: 'GrossDeferredFees', header: 'Gross Deferred Fees', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const GrossDeferredFees = cell.item.GrossDeferredFees;
              const color = GrossDeferredFees < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${GrossDeferredFees.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'CleanCost', header: 'Clean Cost', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const CleanCost = cell.item.CleanCost;
              const color = CleanCost < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${CleanCost.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
        ]
      },
      {
        header: 'Amortized Cost', align: 'center', collapseTo: 'TotalAmortAccrualForPeriod', columns: [
          {
            binding: 'TotalAmortAccrualForPeriod', header: 'Amort of Deferred Fees', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const TotalAmortAccrualForPeriod = cell.item.TotalAmortAccrualForPeriod;
              const color = TotalAmortAccrualForPeriod < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${TotalAmortAccrualForPeriod.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'AccumulatedAmort', header: 'Accumulated Amort of Deferred Fees', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const AccumulatedAmort = cell.item.AccumulatedAmort;
              const color = AccumulatedAmort < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${AccumulatedAmort.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'DiscountPremiumAccrual', header: 'Amort of (Discount) / Premium', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const DiscountPremiumAccrual = cell.item.DiscountPremiumAccrual;
              const color = DiscountPremiumAccrual < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${DiscountPremiumAccrual.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'DiscountPremiumAccumulatedAmort', header: 'Accumulated Amort of (Discount) / Premium', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const DiscountPremiumAccumulatedAmort = cell.item.DiscountPremiumAccumulatedAmort;
              const color = DiscountPremiumAccumulatedAmort < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${DiscountPremiumAccumulatedAmort.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'CapitalizedCostAccrual', header: 'Amort of Capitalized Cost', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const CapitalizedCostAccrual = cell.item.CapitalizedCostAccrual;
              const color = CapitalizedCostAccrual < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${CapitalizedCostAccrual.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'CapitalizedCostAccumulatedAmort', header: 'Accumulated Amort of Capitalized Cost', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const CapitalizedCostAccumulatedAmort = cell.item.CapitalizedCostAccumulatedAmort;
              const color = CapitalizedCostAccumulatedAmort < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${CapitalizedCostAccumulatedAmort.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'AmortizedCost', header: 'Amortized Cost', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const AmortizedCost = cell.item.AmortizedCost;
              const color = AmortizedCost < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${AmortizedCost.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          }
        ]
      },
      {
        header: 'GAAP Interest Income', align: 'center', collapseTo: 'ReversalofPriorInterestAccrual', columns: [
          {
            binding: 'ReversalofPriorInterestAccrual', header: 'Reversal of Prior Interest Accrual', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const ReversalofPriorInterestAccrual = cell.item.ReversalofPriorInterestAccrual;
              const color = ReversalofPriorInterestAccrual < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${ReversalofPriorInterestAccrual.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'InterestReceivedinCurrentPeriod', header: 'Interest Received in Current Period', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const InterestReceivedinCurrentPeriod = cell.item.InterestReceivedinCurrentPeriod;
              const color = InterestReceivedinCurrentPeriod < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${InterestReceivedinCurrentPeriod.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'CurrentPeriodInterestAccrual', header: 'Current Period Interest Accrual', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const CurrentPeriodInterestAccrual = cell.item.CurrentPeriodInterestAccrual;
              const color = CurrentPeriodInterestAccrual < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${CurrentPeriodInterestAccrual.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'CurrentPeriodPIKInterestAccrual', header: 'Current Period PIK Interest Accrual', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const CurrentPeriodPIKInterestAccrual = cell.item.CurrentPeriodPIKInterestAccrual;
              const color = CurrentPeriodPIKInterestAccrual < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${CurrentPeriodPIKInterestAccrual.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'InterestSuspenseAccountActivityforthePeriod', header: 'Interest Suspense Account Activity for the Period', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const InterestSuspenseAccountActivityforthePeriod = cell.item.InterestSuspenseAccountActivityforthePeriod;
              const color = InterestSuspenseAccountActivityforthePeriod < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${InterestSuspenseAccountActivityforthePeriod.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'InterestSuspenseAccountBalance', header: 'Interest Suspense Account Balance', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const InterestSuspenseAccountBalance = cell.item.InterestSuspenseAccountBalance;
              const color = InterestSuspenseAccountBalance < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${InterestSuspenseAccountBalance.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'TotalGAAPInterestFortheCurrentPeriod', header: 'Total GAAP Interest for the Current Period', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const TotalGAAPInterestFortheCurrentPeriod = cell.item.TotalGAAPInterestFortheCurrentPeriod;
              const color = TotalGAAPInterestFortheCurrentPeriod < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${TotalGAAPInterestFortheCurrentPeriod.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'CashInterest', header: 'Cash Interest', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const CashInterest = cell.item.CashInterest;
              const color = CashInterest < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${CashInterest.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          }, {
            binding: 'CapitalizedInterest', header: 'Capitalized Interest', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const CapitalizedInterest = cell.item.CapitalizedInterest;
              const color = CapitalizedInterest < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${CapitalizedInterest.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          }
        ]
      },
      {
        header: 'Book Value', align: 'center', collapseTo: 'EndingGAAPBookValue', columns: [
          {
            binding: 'EndingGAAPBookValue', header: 'Ending GAAP book value', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const EndingGAAPBookValue = cell.item.EndingGAAPBookValue;
              const color = EndingGAAPBookValue < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${EndingGAAPBookValue.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          }
        ]
      },
      {
        header: 'Coupon', align: 'center', collapseTo: 'AllInCouponRate', columns: [
          { binding: 'AllInCouponRate', header: 'All In coupon rate', align: 'right', aggregate: 'Sum', format: 'p9' },
          {
            binding: 'CurrentPeriodInterestAccrualPeriodEnddate', header: 'Monthly Interest Income', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const CurrentPeriodInterestAccrualPeriodEnddate = cell.item.CurrentPeriodInterestAccrualPeriodEnddate;
              const color = CurrentPeriodInterestAccrualPeriodEnddate < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${CurrentPeriodInterestAccrualPeriodEnddate.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'CurrentPeriodPIKInterestAccrualPeriodEnddate', header: 'Monthly PIK Interest Income', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const CurrentPeriodPIKInterestAccrualPeriodEnddate = cell.item.CurrentPeriodPIKInterestAccrualPeriodEnddate;
              const color = CurrentPeriodPIKInterestAccrualPeriodEnddate < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${CurrentPeriodPIKInterestAccrualPeriodEnddate.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'DropDateInterestDeltaBalance', header: 'Drop Date Interest Delta Balance', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const DropDateInterestDeltaBalance = cell.item.DropDateInterestDeltaBalance;
              const color = DropDateInterestDeltaBalance < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${DropDateInterestDeltaBalance.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          }
        ]
      },
      {
        binding: 'EndOfPeriodWAL', header: 'End of Period WAL', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
          const EndOfPeriodWAL = cell.item.EndOfPeriodWAL;
          const color = EndOfPeriodWAL < 0 ? 'red' : 'darkgreen';
          return `<div style="color: ${color};">${EndOfPeriodWAL.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
        }
      },
      {
        header: 'PIK', align: 'center', collapseTo: 'AllInPIKRate', columns: [
          { binding: 'AllInPIKRate', header: 'All In PIK Rate', align: 'right', aggregate: 'Sum', format: 'p9' },
          {
            binding: 'PIKInterestPercentage', header: 'PIK Interest Percentage', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const PIKInterestPercentage = cell.item.PIKInterestPercentage;
              const color = PIKInterestPercentage < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${PIKInterestPercentage.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'PIKInterestFromPIKSourceNote', header: 'PIK interest from PIK source note', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const PIKInterestFromPIKSourceNote = cell.item.PIKInterestFromPIKSourceNote;
              const color = PIKInterestFromPIKSourceNote < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${PIKInterestFromPIKSourceNote.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'PIKInterestTransferredToRelatedNote', header: 'PIK interest transferred to related note', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const PIKInterestTransferredToRelatedNote = cell.item.PIKInterestTransferredToRelatedNote;
              const color = PIKInterestTransferredToRelatedNote < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${PIKInterestTransferredToRelatedNote.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },

          {
            binding: 'PIKInterestForThePeriod', header: 'PIK interest for the period', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const PIKInterestForThePeriod = cell.item.PIKInterestForThePeriod;
              const color = PIKInterestForThePeriod < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${PIKInterestForThePeriod.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'PIKInterestPaidForThePeriod', header: 'PIK Interest Paid For The Period', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const PIKInterestPaidForThePeriod = cell.item.PIKInterestPaidForThePeriod;
              const color = PIKInterestPaidForThePeriod < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${PIKInterestPaidForThePeriod.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'PIKInterestAppliedForThePeriod', header: 'PIK Interest Applied For The Period', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const PIKInterestAppliedForThePeriod = cell.item.PIKInterestAppliedForThePeriod;
              const color = PIKInterestAppliedForThePeriod < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${PIKInterestAppliedForThePeriod.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'PIKPrincipalPaidForThePeriod', header: 'PIK Principal Paid For the Period', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const PIKPrincipalPaidForThePeriod = cell.item.PIKPrincipalPaidForThePeriod;
              const color = PIKPrincipalPaidForThePeriod < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${PIKPrincipalPaidForThePeriod.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'BeginningPIKBalanceNotInsideLoanBalance', header: 'Separately Compounded Beginning PIK Balance', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const BeginningPIKBalanceNotInsideLoanBalance = cell.item.BeginningPIKBalanceNotInsideLoanBalance;
              const color = BeginningPIKBalanceNotInsideLoanBalance < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${BeginningPIKBalanceNotInsideLoanBalance.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'PIKInterestForPeriodNotInsideLoanBalance', header: 'Separately Compounded PIK Interest', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const PIKInterestForPeriodNotInsideLoanBalance = cell.item.PIKInterestForPeriodNotInsideLoanBalance;
              const color = PIKInterestForPeriodNotInsideLoanBalance < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${PIKInterestForPeriodNotInsideLoanBalance.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'PIKBalanceBalloonPayment', header: 'Separately Compounded PIK Balloon', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const PIKBalanceBalloonPayment = cell.item.PIKBalanceBalloonPayment;
              const color = PIKBalanceBalloonPayment < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${PIKBalanceBalloonPayment.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'EndingPIKBalanceNotInsideLoanBalance', header: 'Separately Compounded Ending PIK Balance', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const EndingPIKBalanceNotInsideLoanBalance = cell.item.EndingPIKBalanceNotInsideLoanBalance;
              const color = EndingPIKBalanceNotInsideLoanBalance < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${EndingPIKBalanceNotInsideLoanBalance.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
        ]
      },
      {
        header: 'Coupon Stripping', align: 'center', collapseTo: 'TotalCouponStrippedforthePeriod', columns: [
          {
            binding: 'TotalCouponStrippedforthePeriod', header: 'Total coupon stripped for the period', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const TotalCouponStrippedforthePeriod = cell.item.TotalCouponStrippedforthePeriod;
              const color = TotalCouponStrippedforthePeriod < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${TotalCouponStrippedforthePeriod.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'CouponStrippedonPaymentDate', header: 'Coupon stripped on payment date', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const CouponStrippedonPaymentDate = cell.item.CouponStrippedonPaymentDate;
              const color = CouponStrippedonPaymentDate < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${CouponStrippedonPaymentDate.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
        ]
      },
      {
        header: 'Shortfall & Recovery', align: 'center', collapseTo: 'ScheduledPrincipalShortfall', columns: [
          {
            binding: 'ScheduledPrincipalShortfall', header: 'Scheduled principal shortfall', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const ScheduledPrincipalShortfall = cell.item.ScheduledPrincipalShortfall;
              const color = ScheduledPrincipalShortfall < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${ScheduledPrincipalShortfall.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'PrincipalShortfall', header: 'Principal Shortfall', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const PrincipalShortfall = cell.item.PrincipalShortfall;
              const color = PrincipalShortfall < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${PrincipalShortfall.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'PrincipalLoss', header: 'Principal Loss', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const PrincipalLoss = cell.item.PrincipalLoss;
              const color = PrincipalLoss < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${PrincipalLoss.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'InterestForPeriodShortfall', header: 'Interest for period shortfall', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const InterestForPeriodShortfall = cell.item.InterestForPeriodShortfall;
              const color = InterestForPeriodShortfall < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${InterestForPeriodShortfall.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'InterestPaidOnPMTDateShortfall', header: 'Interest paid on payment date shortfall', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const InterestPaidOnPMTDateShortfall = cell.item.InterestPaidOnPMTDateShortfall;
              const color = InterestPaidOnPMTDateShortfall < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${InterestPaidOnPMTDateShortfall.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'CumulativeInterestPaidOnPMTDateShortfall', header: 'Cumulative interest paid on payment date shortfall', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const CumulativeInterestPaidOnPMTDateShortfall = cell.item.CumulativeInterestPaidOnPMTDateShortfall;
              const color = CumulativeInterestPaidOnPMTDateShortfall < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${CumulativeInterestPaidOnPMTDateShortfall.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'InterestShortfallLoss', header: 'Interest shortfall loss', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const InterestShortfallLoss = cell.item.InterestShortfallLoss;
              const color = InterestShortfallLoss < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${InterestShortfallLoss.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'InterestShortfallRecovery', header: 'Interest shortfall recovery', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const InterestShortfallRecovery = cell.item.InterestShortfallRecovery;
              const color = InterestShortfallRecovery < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${InterestShortfallRecovery.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
        ]
      },
      {
        header: 'Financing', align: 'center', collapseTo: 'BeginningFinancingBalance', columns: [
          {
            binding: 'BeginningFinancingBalance', header: 'Beginning financing balance', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const BeginningFinancingBalance = cell.item.BeginningFinancingBalance;
              const color = BeginningFinancingBalance < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${BeginningFinancingBalance.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          { binding: 'Totalfinancingdraws', header: 'Total financing draws/curtailments for period', align: 'right', aggregate: 'Sum', format: 'n2' },
          {
            binding: 'FinancingBalloon', header: 'Financing Balloon', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const FinancingBalloon = cell.item.FinancingBalloon;
              const color = FinancingBalloon < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${FinancingBalloon.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'EndingFinancingBalance', header: 'Ending Financing Balance', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const EndingFinancingBalance = cell.item.EndingFinancingBalance;
              const color = EndingFinancingBalance < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${EndingFinancingBalance.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'FinancingInterestPaid', header: 'Financing Interest Paid', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const FinancingInterestPaid = cell.item.FinancingInterestPaid;
              const color = FinancingInterestPaid < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${FinancingInterestPaid.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'FinancingFeesPaid', header: 'Financing Fees Paid', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const FinancingFeesPaid = cell.item.FinancingFeesPaid;
              const color = FinancingFeesPaid < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${FinancingFeesPaid.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'PeriodLeveredYield', header: 'Period Levered Yield', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const PeriodLeveredYield = cell.item.PeriodLeveredYield;
              const color = PeriodLeveredYield < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${PeriodLeveredYield.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
        ]
      },
      {
        header: 'All-In Basis', align: 'center', collapseTo: 'DeferredFeesReceivable', columns: [
          {
            binding: 'DeferredFeesReceivable', header: 'Deferred Fees Receivable', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const DeferredFeesReceivable = cell.item.DeferredFeesReceivable;
              const color = DeferredFeesReceivable < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${DeferredFeesReceivable.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'FeeStrippedforthePeriod', header: 'Fee Stripped for the Period', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const FeeStrippedforthePeriod = cell.item.FeeStrippedforthePeriod;
              const color = FeeStrippedforthePeriod < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${FeeStrippedforthePeriod.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'AdditionalFeeAccrual', header: 'Additional Fee Accrual', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const AdditionalFeeAccrual = cell.item.AdditionalFeeAccrual;
              const color = AdditionalFeeAccrual < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${AdditionalFeeAccrual.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'ExitFeeAccrual', header: 'Exit Fee Accrual', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const ExitFeeAccrual = cell.item.ExitFeeAccrual;
              const color = ExitFeeAccrual < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${ExitFeeAccrual.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'AllInBasisValuation', header: 'All-In Basis(Valuation)', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const AllInBasisValuation = cell.item.AllInBasisValuation;
              const color = AllInBasisValuation < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${AllInBasisValuation.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
        ]
      },
      {
        header: 'PV Basis', align: 'center', collapseTo: 'ActualCashFlows', columns: [
          {
            binding: 'ActualCashFlows', header: 'Actual cashflows', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const cashFlowValue = cell.item.ActualCashFlows;
              const color = cashFlowValue < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${cashFlowValue.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'GAAPCashFlows', header: 'GAAP cashflows', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const GAAPCashFlows = cell.item.GAAPCashFlows;
              const color = GAAPCashFlows < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${GAAPCashFlows.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'AmortAccrualLevelYield', header: 'Amort accrual level yield', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const AmortAccrualLevelYield = cell.item.AmortAccrualLevelYield;
              const color = AmortAccrualLevelYield < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${AmortAccrualLevelYield.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'EndingPreCapPVBasis', header: 'Ending Pre Cap PVBasis', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const EndingPreCapPVBasis = cell.item.EndingPreCapPVBasis;
              const color = EndingPreCapPVBasis < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${EndingPreCapPVBasis.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'LevelYieldIncomeForThePeriod', header: 'Level Yield Income For The Period', width: 150, align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const LevelYieldIncomeForThePeriod = cell.item.LevelYieldIncomeForThePeriod;
              const color = LevelYieldIncomeForThePeriod < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${LevelYieldIncomeForThePeriod.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'PVAmortTotalIncomeMethod', header: 'PVAmort Total Income Method', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const PVAmortTotalIncomeMethod = cell.item.PVAmortTotalIncomeMethod;
              const color = PVAmortTotalIncomeMethod < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${PVAmortTotalIncomeMethod.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'EndingCleanCostLY', header: 'Ending Clean Cost LY', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const EndingCleanCostLY = cell.item.EndingCleanCostLY;
              const color = EndingCleanCostLY < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${EndingCleanCostLY.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'EndingAccumAmort', header: 'Ending Accum GAAP Amort', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const EndingAccumAmort = cell.item.EndingAccumAmort;
              const color = EndingAccumAmort < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${EndingAccumAmort.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'PVAmortForThePeriod', header: 'GAAP Amort for the period', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const PVAmortForThePeriod = cell.item.PVAmortForThePeriod;
              const color = PVAmortForThePeriod < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${PVAmortForThePeriod.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'EndingSLBasis', header: 'Ending SL Basis', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const EndingSLBasis = cell.item.EndingSLBasis;
              const color = EndingSLBasis < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${EndingSLBasis.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'SLAmortForThePeriod', header: 'SL Amort For The Period', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const SLAmortForThePeriod = cell.item.SLAmortForThePeriod;
              const color = SLAmortForThePeriod < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${SLAmortForThePeriod.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'SLAmortOfTotalFeesInclInLY', header: 'SL Amort Of Total Fees Incl In LY', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const SLAmortOfTotalFeesInclInLY = cell.item.SLAmortOfTotalFeesInclInLY;
              const color = SLAmortOfTotalFeesInclInLY < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${SLAmortOfTotalFeesInclInLY.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'SLAmortOfDiscountPremium', header: 'SL Amort Of Discount Premium', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const SLAmortOfDiscountPremium = cell.item.SLAmortOfDiscountPremium;
              const color = SLAmortOfDiscountPremium < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${SLAmortOfDiscountPremium.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'SLAmortOfCapCost', header: 'SL Amort Of Cap Cost', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const SLAmortOfCapCost = cell.item.SLAmortOfCapCost;
              const color = SLAmortOfCapCost < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${SLAmortOfCapCost.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'EndingAccumSLAmort', header: 'Ending Accum SL Amort', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const EndingAccumSLAmort = cell.item.EndingAccumSLAmort;
              const color = EndingAccumSLAmort < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${EndingAccumSLAmort.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'EndingPreCapGAAPBasis', header: 'Ending PreCap GAAP Basis', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const EndingPreCapGAAPBasis = cell.item.EndingPreCapGAAPBasis;
              const color = EndingPreCapGAAPBasis < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${EndingPreCapGAAPBasis.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          }
        ]
      },
      {
        header: 'Reporting', align: 'center', collapseTo: 'ActualCashFlows', columns: [
          {
            binding: 'RemainingUnfundedCommitment', header: 'Unfunded Commitment', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const RemainingUnfundedCommitment = cell.item.RemainingUnfundedCommitment;
              const color = RemainingUnfundedCommitment < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${RemainingUnfundedCommitment.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'AverageDailyBalance', header: 'Average Daily Balance', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const AverageDailyBalance = cell.item.AverageDailyBalance;
              const color = AverageDailyBalance < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${AverageDailyBalance.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
          {
            binding: 'InterestPastDue', header: 'Interest Past Due', align: 'right', aggregate: 'Sum', format: 'n2', cellTemplate: (cell: any) => {
              const InterestPastDue = cell.item.InterestPastDue;
              const color = InterestPastDue < 0 ? 'red' : 'darkgreen';
              return `<div style="color: ${color};">${InterestPastDue.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>`;
            }
          },
        ]
      }
    ]
    //this.columnGroupHeaders = groups.map(group => ({header: group.header}));
    // Collect all individual column headers
    this.columnGroupHeaders = [];
    groups.forEach(group => {
      if (group.columns) {
        group.columns.forEach(column => {
          this.columnGroupHeaders.push({ header: column.header });
        });
      }
      else {
        this.columnGroupHeaders.push({ header: group.header });
      }
    });
    return groups;
  }

  animated = true;
  columnGroups = this.getColumnGroups();
  checkedItems: any[] = [];
  lstNoteTranchePercentage: any;

  constructor(private activatedRoute: ActivatedRoute,
    //private ng2FileInputService: Ng2FileInputService,
    public fileUploadService: FileUploadService,
    public noteService: NoteService,
    public dealSrv: dealService,
    public utilityService: UtilityService,
    public searchService: SearchService,
    public membershipservice: MembershipService,
    public _signalRService: SignalRService,
    public calculationsvc: CalculationManagerService,
    //private changeref: ChangeDetectorRef,
    //private appref:ApplicationRef,
    private _router: Router, public functionServiceSrv: functionService,
    public scenarioService: scenarioService) {
    super(10, 1, 0);
    this._scenariodc = new Scenario('');
    this._lstScenario = this._scenariodc.LstScenarioUserMap;
    this._note = new Note('');
    this._noteDateObjects = new NoteDateObjects();
    this._noteext = new NoteAdditionalList();
    this._devDashBoard = new devDashBoard('');
    this._noteextt = new NoteAdditionalListObject();
    this._noteEditList = new NoteAdditionalListObject();
    this._validationobject = new NoteAdditionalList();
    this._noteArchieveext = new NoteAdditionalList();
    this._noteArchieveextt = new NoteAdditionalListObject();
    this._moduledelete = new Module('');
    this._activityLog = new ActivityLog('');
    this._ruletype = new RuleType;
    this._moduledelete.LookupID = 0;
    this.getAllDistinctScenario();
    this.subscribetoevent();

    this.rolename = window.localStorage.getItem("rolename");
    //this.ScenarioId = window.localStorage.getItem("scenarioid");
    this.ScenarioId = window.localStorage.getItem("DefaultScenarioID");

    this._noteCashflowsExportDataList = new NoteCashflowsExportDataList();
    this.activatedRoute.params.forEach((params: Params) => {
      if (params['id'] !== undefined) {
        this._note.NoteId = params['id'];
      }
    });

    this._user = JSON.parse(localStorage.getItem('user'));
    this._userdefaultsetting = new userdefaultsetting(this._user.UserID, '', '');
    this.fetchNote();
    //this.RateSpreadScheduleList=null;

    var _date = new Date();
    this._dtUTCHours = _date.getTimezoneOffset() / 60; //_date.getUTCHours();
    //alert('date getTimezoneOffset' + _date.getTimezoneOffset() );
    this._userOffset = _date.getTimezoneOffset() * 60 * 1000; // user's offset time

    if (this._dtUTCHours < 6) {
      this._centralOffset = 6 * 60 * 60 * 1000; // 6 for central time - use whatever you need
    }
    else {
      this._centralOffset = this._dtUTCHours * 60 * 60 * 1000; // 6 for central time - use whatever you need
    }
    //this._centralOffset = this._dtUTCHours * 60 * 60 * 1000; // 6 for central time - use whatever you need
    // this.OnChanges();
    this._document = new Document();
    this._document.DocumentTypeID = "406";
    this.getAllClient();
    this.getAllFund();
    this.GetLookupForMaster();
    this.getFeeTypesFromFeeSchedulesConfig();
    //manish
    this.GetFinancingSource();
    this.getDealMaturitybyID();
    this.GetAllTagNameXIRR();
    //    setTimeout(() => {
    //       this.GetTransactionCategory();
    //  }, 8000);

  }
  ngOnInit(): void {
    this.checkedItems = [...this.columnGroupHeaders];
  }

  onMultiSelectInitialized() {
    const dropDown = this.selectColumnGroups.dropDown;
    const footer = document.createElement('div');
    footer.className = 'footer-button';
    footer.style.display = 'block';
    footer.innerHTML = '<button class="custombutton">Apply</button>';

    dropDown.appendChild(footer);

    if (footer) {
      const button = footer.querySelector('.custombutton') as HTMLButtonElement;
      if (button) {
        button.addEventListener('click', () => this.toggleColumns());
      }
    }
  }

  onSelectionChanged(s, e) {
    this.selectedColumnGroups = s.checkedItems;
  }

  toggleColumns() {
    this._isnoteperiodiccalcFetching = true;
    setTimeout(function () {
      this.columnGroups.forEach(group => {
        if (group.columns && Array.isArray(group.columns)) {
          group.columns.forEach((column: any) => {
            const selectedColumn = this.selectedColumnGroups.find(item => item.header === column.header);
            this.flexnoteperiodiccalc.getColumn(column.binding).visible = !!selectedColumn;
          });
        } else {
          const selectedGroup = this.selectedColumnGroups.find(item => item.header === group.header);
          this.flexnoteperiodiccalc.getColumn(group.binding).visible = !!selectedGroup;
        }
      });
      this._isnoteperiodiccalcFetching = false;
    }.bind(this), 1000);
  }

  private _buildDataMapWithoutLookupForRuleType(items): wjcGrid.DataMap {
    var map = [];

    for (var i = 0; i < items.length; i++) {
      var obj = items[i];
      map.push({ key: obj['FileName'], value: obj['FileName'] });
    }
    return new wjcGrid.DataMap(map, 'key', 'value');
  }

  invalidateRulestab() {
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
  }

  getAllRuleType() {
    this.scenarioService.getallruletype().subscribe(res => {
      if (res.Succeeded) {
        this._lstruletype = res.lstScenariorule;
        this._lstgetallrule = res.lstScenariorule;
      }
    });

  }

  GetAllRuleTypeDetail() {
    this.scenarioService.getallruletypedetail().subscribe(res => {
      if (res.Succeeded) {
        this._lstruletypedetail = res.lstScenarioRuleDetail;
        var RuleType = this.RuleTypeList;
        if (RuleType) {
          var colRuleType = RuleType.columns.getColumn('FileName');
          if (colRuleType) {
            // colRuleType.showDropDown = true;
            colRuleType.dataMap = this._buildDataMapWithoutLookupForRuleType(this._lstruletypedetail);
          }
        }

      }

    });
  }

  GetRuleTypeSetupByDealid() {
    this._ruletype.NoteID = this._note.NoteId;
    this.noteService.getruletypesetupbynoteid(this._ruletype).subscribe(res => {
      if (res.Succeeded) {
        this._lstRuleTypeSetupfilter = res.lstScenariorule;
        this.OnChangeScenarioName(this._ruletype.AnalysisID);
      }
    });
  }

  cellRuleTypeEditHandler = function (s, e) {
    var col = s.columns[e.col];
    if (col.binding == 'FileName') {
      var RuleTypeName = s.rows[e.row].dataItem.RuleTypeName
      switch (RuleTypeName) {
        case RuleTypeName:
          this.lstRuleTypebyruleid = this._lstruletypedetail.filter(x => x.RuleTypeName == RuleTypeName)
          this.lstRuleTypebyruleid.sort(this.sortByName);
          col.dataMap = this._buildDataMapWithoutLookupForRuleType(this.lstRuleTypebyruleid);
          break;

      }
    }
  }

  celleditRuleType(s: wjcGrid.FlexGrid, e: wjcGrid.CellEditEndingEventArgs) {
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
  }

  OnChangeScenarioName(newvalue) {
    this._lstruletype = [];
    this.RuleTypeList.invalidate();
    if (this._lstRuleTypeSetupfilter != null) {

      this._lstruletype = this._lstRuleTypeSetupfilter.filter(x => x.AnalysisID == newvalue);

      this.RuleTypeList.invalidate();
    }
    if (this._lstgetallrule.length > 0) {
      for (var h = 0; h < this._lstgetallrule.length; h++) {
        var _lstgetallrule = this._lstruletype.filter(x => x.RuleTypeName == this._lstgetallrule[h].RuleTypeName)
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

    var newanalysisid = this._lstRuleTypeSetuptobesend.filter(x => x.AnalysisID == newvalue)
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
  }

  ResetRuleType() {
    if (this._lstRuleTypeSetupfilter != null) {
      if (this._lstRuleTypeSetupfilter.length > 0) {
        for (var h = 0; h < this._lstRuleTypeSetupfilter.length; h++) {
          if (this._lstRuleTypeSetupfilter[h].AnalysisID == this._ruletype.AnalysisID) {
            this._lstRuleTypeSetupfilter[h]["FileName"] = "";

          }
        }
      }
      this._lstruletype = this._lstRuleTypeSetupfilter.filter(x => x.AnalysisID == this._ruletype.AnalysisID);
    }
    else {
      this._lstruletype = [];
      this.RuleTypeList.invalidate();
    }
    if (this._lstgetallrule.length > 0) {
      for (var h = 0; h < this._lstgetallrule.length; h++) {
        var _lstgetallrule = this._lstruletype.filter(x => x.RuleTypeName == this._lstgetallrule[h].RuleTypeName)
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

  }

  AddUpdateNoteRuleTypeSetup() {
    var RuleTypeDetailID = 0;
    if (this._lstRuleTypeSetuptobesend.length > 0) {

      for (var h = 0; h < this._lstRuleTypeSetuptobesend.length; h++) {
        if (this._lstRuleTypeSetuptobesend[h].FileName != "" && this._lstRuleTypeSetuptobesend[h].FileName != null) {
          RuleTypeDetailID = this._lstruletypedetail.find(x => x.FileName == this._lstRuleTypeSetuptobesend[h].FileName).RuleTypeDetailID
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
    this.noteService.addupdatenoteruletypesetup(this._lstRuleTypeSetupNew).subscribe(res => {
      if (res.Succeeded) {

      }
    });
  }
  getAllDistinctScenario(): void {
    var _userData = JSON.parse(localStorage.getItem('user'));
    this._scenariodc.UserID = _userData.UserID;
    this.scenarioService.getAllScenarioDistinct(this._scenariodc).subscribe(res => {
      if (res.Succeeded) {

        if (res.lstScenarioUserMap.length > 0) {
          this._lstScenario = res.lstScenarioUserMap;
          this.ScenarioId = res.lstScenarioUserMap.filter(x => x.ScenarioName == "Default")[0].AnalysisID;
          this.ScenarioName = res.lstScenarioUserMap.filter(x => x.ScenarioName == "Default")[0].ScenarioName;
          this._scenariodc.AnalysisID = this.ScenarioId;
          this._note.AnalysisID = this.ScenarioId;
        }
      }
    });
  }

  changeScenario(value): void {
    this.SelectedScenarioId = value;
    this.ScenarioName = this._lstScenario.filter(x => x.AnalysisID == value)[0].ScenarioName;
    this.showperiodicoutputflex(this.IsbtnClickText);

  }
  changeCouponScenario(value): void {
    this.SelectedCouponScenarioId = value;
    this.getFeeCouponStripReceivableDataByNoteId();
  }


  ChangeFundingappied(ScheduleID: string, _value: boolean, flexGridrw: wjcGrid.Row): void {

    if (_value == true) {
      if (this._noteext.ListFutureFundingScheduleTab[flexGridrw.index].Date == undefined) {
        this.futurefundingflex.rows[flexGridrw.index].dataItem.Applied = false;
        this.futurefundingflex.invalidate();
        this.CustomAlert("Date can not be blank.")
        return;
      }

      if (this._noteext.ListFutureFundingScheduleTab.length > 1) {
        var minDate = new Date(Math.min.apply(null, this._noteext.ListFutureFundingScheduleTab.filter(x => x.Applied == false).map(x => x.Date)));
        if (minDate.toJSON()) {
          var wcDate = new Date(flexGridrw.dataItem.Date);
          if (wcDate.toString() != minDate.toString()) {
            this.futurefundingflex.rows[flexGridrw.index].dataItem.Applied = false;
            this.futurefundingflex.invalidate();
            //  this.CustomAlert("Before confirming " + minDate.toLocaleDateString("en-US") + " record .Other date is not allowed to confirm.")
            this.CustomAlert("You can't confirm wire on a later date without confirming all wires in between.")
            return;
          }
          else {
            var today = new Date();
            var nextbdate = this.getnexybusinessDate(today, 5);
            if (wcDate > nextbdate) {
              flexGridrw.dataItem.Applied = false;
              this.futurefundingflex.invalidate();
              this.CustomAlert("You can only confirm up to " + this.convertDateToBindable(nextbdate) + ".")
              return;
            }
          }
        }
      }
    }
    else {
      var maxDate = new Date(Math.max.apply(null, this._noteext.ListFutureFundingScheduleTab.filter(x => x.Applied == true).map(x => x.Date)));
      if (maxDate.toJSON()) {
        var wcDate = new Date(flexGridrw.dataItem.Date);
        if (wcDate.toString() != maxDate.toString()) {
          this.futurefundingflex.rows[flexGridrw.index].dataItem.Applied = true;
          this.futurefundingflex.invalidate();
          //  this.CustomAlert("Before unchecking " + maxDate.toLocaleDateString("en-US") + " record .Other date is not allowed to uncheck.")
          this.CustomAlert("You can't remove a wire confirmation on an earlier date without removing the wire confirmation on later dates.")
          return;
        }
      }
    }


    if (this.rolename != 'Super Admin') {
      if (_value == true) {
        flexGridrw.isReadOnly = true;
        flexGridrw.cssClass = "customgridrowcolor"
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
        flexGridrw.cssClass = "customgridrowcolor"
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
      this._noteext.ListFutureFundingScheduleTab.find(x => x.ScheduleID == ScheduleID).Applied = _value;
    }
  }

  ////For remove the Leave Page dialog
  //@HostListener('window:beforeunload', ['$event'])
  //public beforeunloadHandler($event) {

  //  if (this.initialised > 1) {
  //    $event.returnValue = "Are you sure?";
  //  }
  //}

  // Component views are initialized
  ngAfterViewInit() {
    this._isPeriodicDataFetched = true;
    this._isCalcDataFetched = false;
    this._isCalcJsonFetched = false;



    //stop input (number type) control 'Scroll Wheel' feature
    setTimeout(function () {
      $('input[type=number]').each(function () {
        var el = (<HTMLInputElement>document.getElementById(($(this).attr("id"))));
        if (el) {
          el.addEventListener('wheel', function (e) {
            e.preventDefault(); // prevent event
            e.stopImmediatePropagation(); // stop propogation
          }, true);
        }
      })

      $(".ibox1").each(function () {
        var el = (<HTMLInputElement>document.getElementById(($(this).attr("id"))));
        if (el) {
          el.addEventListener('wheel', function (e) {
            e.preventDefault(); // prevent event
            e.stopImmediatePropagation(); // stop propogation
          }, true);
        }
      })
    }.bind(this), 3000);

    // this.OnChanges();
  }

  FormatDate(_note: Note, locale: string): void {
    var options = { year: "numeric", month: "numeric", day: "numeric" };

    if (this._note.StartDate != null) { this._note.StartDate = new Date(this._note.StartDate.toString()); }
    if (this._note.EndDate != null) { this._note.EndDate = new Date(this._note.EndDate.toString()); }
    if (this._note.InitialInterestAccrualEndDate != null) { this._note.InitialInterestAccrualEndDate = new Date(this._note.InitialInterestAccrualEndDate.toString()); }
    if (this._note.FirstPaymentDate != null) { this._note.FirstPaymentDate = new Date(this._note.FirstPaymentDate.toString()); }
    if (this._note.InitialMonthEndPMTDateBiWeekly != null) { this._note.InitialMonthEndPMTDateBiWeekly = new Date(this._note.InitialMonthEndPMTDateBiWeekly.toString()); }
    if (this._note.FinalInterestAccrualEndDateOverride != null) { this._note.FinalInterestAccrualEndDateOverride = new Date(this._note.FinalInterestAccrualEndDateOverride.toString()); }
    if (this._note.FirstRateIndexResetDate != null) { this._note.FirstRateIndexResetDate = new Date(this._note.FirstRateIndexResetDate.toString()); }
    //if (this._note.SelectedMaturityDate != null) { this._note.SelectedMaturityDate = new Date(this._note.SelectedMaturityDate.toString()); }
    //if (this._note.InitialMaturityDate != null) { this._note.InitialMaturityDate = new Date(this._note.InitialMaturityDate.toString()); }
    if (this._note.ExpectedMaturityDate != null) { this._note.ExpectedMaturityDate = new Date(this._note.ExpectedMaturityDate.toString()); }
    // if (this._note.FullyExtendedMaturityDate != null) { this._note.FullyExtendedMaturityDate = new Date(this._note.FullyExtendedMaturityDate.toString()); }
    if (this._note.OpenPrepaymentDate != null) { this._note.OpenPrepaymentDate = new Date(this._note.OpenPrepaymentDate.toString()); }
    if (this._note.FinancingInitialMaturityDate != null) { this._note.FinancingInitialMaturityDate = new Date(this._note.FinancingInitialMaturityDate.toString()); }
    if (this._note.FinancingExtendedMaturityDate != null) { this._note.FinancingExtendedMaturityDate = new Date(this._note.FinancingExtendedMaturityDate.toString()); }
    if (this._note.ClosingDate != null) { this._note.ClosingDate = new Date(this._note.ClosingDate.toString()); }
    if (this._note.LastAccountingCloseDate != null) { this._note.LastAccountingCloseDate = new Date(this._note.LastAccountingCloseDate.toString()); }

    //if (this._note.ExtendedMaturityScenario1 != null) { this._note.ExtendedMaturityScenario1 = new Date(this._note.ExtendedMaturityScenario1.toString()); }
    // if (this._note.ExtendedMaturityScenario2 != null) { this._note.ExtendedMaturityScenario2 = new Date(this._note.ExtendedMaturityScenario2.toString()); }
    // if (this._note.ExtendedMaturityScenario3 != null) { this._note.ExtendedMaturityScenario3 = new Date(this._note.ExtendedMaturityScenario3.toString()); }
    if (this._note.ActualPayoffDate != null) { this._note.ActualPayoffDate = new Date(this._note.ActualPayoffDate.toString()); }

    if (this._note.PurchaseDate != null) { this._note.PurchaseDate = new Date(this._note.PurchaseDate.toString()); }
    if (this._note.ValuationDate != null) { this._note.ValuationDate = new Date(this._note.ValuationDate.toString()); }

    if (this._note.lastCalcDateTime != null) { this._note.lastCalcDateTime = new Date(this._note.lastCalcDateTime.toString()); }
    if (this._note.AccountingCloseDate != null) { this._note.AccountingCloseDate = new Date(this._note.AccountingCloseDate.toString()); }
    if (this._note.NoteTransferDate != null) { this._note.NoteTransferDate = new Date(this._note.NoteTransferDate.toString()); }

    if (this._note.FirstIndexDeterminationDateOverride != null) { this._note.FirstIndexDeterminationDateOverride = new Date(this._note.FirstIndexDeterminationDateOverride.toString()); }
  }

  public lstnotePeriodicOutputs: any;
  @ViewChild('flexnoteperiodiccalc') flexnoteperiodiccalc: wjcGrid.FlexGrid;

  public _isnoteperiodiccalcFetching: boolean = false;
  public _isnoteperiodiccalcFetched: boolean = false;
  @ViewChild('flexTransactionEntry') flexTransactionEntry: wjcGrid.FlexGrid;
  public _isTransactionEntryFetched: boolean = true;
  public _dvEmptynoteperiodiccalcMsg: boolean = false;
  public _divbatchuploadtext: boolean = false;


  getNotePeriodicCalcByNoteId(_note: Note): void {
    if (this.ScenarioId === undefined || this.ScenarioId === null) {
      this.ScenarioId = this._lstScenario.find(x => x.ScenarioName == "Default").AnalysisID;
    }
    _note.AnalysisID = this.ScenarioId;
    this._note.CalculationStatus = "";
    this._isnoteperiodiccalcFetching = true;
    this.noteService.getNotePeriodicCalcByNoteId(_note, this._pageIndex, this._pageSize).subscribe(res => {
      if (res.Succeeded) {
        this._noteext.lstnotePeriodicOutputs = res.lstnotePeriodicOutputs;

        if (res.lstnotePeriodicOutputs[0] != null) {
          this._note.lastCalcDateTime = res.lstnotePeriodicOutputs[0].UpdatedDate;
          this._note.CalculationStatus = res.lstnotePeriodicOutputs[0].CalculationStatus;
          this._note.AccountingCloseDate = res.lstnotePeriodicOutputs[0].AccountingCloseDate;
        }
        else {
          this._note.CalculationStatus = "";
          this._note.ErrorMessage = "";
        }

        this.ConvertToBindableDate(this._noteext.lstnotePeriodicOutputs, "NotePeriodicCalc", "en-US");
        this._isNoteSaving = false;

        setTimeout(function () {
          this.flexnoteperiodiccalc.autoSizeColumns(0, this.flexnoteperiodiccalc.columns.length - 1, false, 20);
          this.flexnoteperiodiccalc.invalidate();
          this._isnoteperiodiccalcFetching = false;
        }.bind(this), 5000);
      }
      else {
        setTimeout(function () {
          this._norecordfound = false;
          this._noteext.lstnotePeriodicOutputs = null;
          this._isnoteperiodiccalcFetching = false;
          this._isnoteperiodiccalcFetched = false;
          this.ShowEmptyGridText();

        }.bind(this), 1000);

      }
      error => console.error('Error: ' + error)
    });
  }

  ShowEmptyGridText() {
    //4==N
    if (this.EnableM61Calculations == 4) {
      this._divbatchuploadtext = false;
      this.EmptynoteperiodiccalcMsgString = "This note is set to calculate No for M61 calculations. Please upload transaction using batch upload tool.";
    } else {
      this.EmptynoteperiodiccalcMsgString = "There are no transactions for this scenario. Please calculate the note with this scenario or choose a different scenario.";
    }
    this._dvEmptynoteperiodiccalcMsg = true;
  }

  getTransactionEntryByNoteId(_note: Note): void {
    if (this.ScenarioId === undefined || this.ScenarioId === null) {
      this.ScenarioId = this._lstScenario.find(x => x.ScenarioName == "Default").AnalysisID;
    }
    _note.AnalysisID = this.ScenarioId;
    this._note.AnalysisID = this.ScenarioId;
    this._isnoteperiodiccalcFetching = true;
    this.noteService.getTransactionEntryByNoteId(_note).subscribe(res => {
      if (res.Succeeded) {
        this._norecordfound = true;
        this.lstTransactionEntry = res.lstTransactionEntry;
        if (this.lstTransactionEntry.length > 0) {
          for (var i = 0; i < this.lstTransactionEntry.length; i++) {
            this.lstTransactionEntry[i].Date = new Date(this.lstTransactionEntry[i].Date.toString());

            if (this.lstTransactionEntry[i].TransactionDateByRule) {
              this.lstTransactionEntry[i].TransactionDateByRule = new Date(this.lstTransactionEntry[i].TransactionDateByRule.toString());
            }
            if (this.lstTransactionEntry[i].DueDate) {
              this.lstTransactionEntry[i].DueDate = new Date(this.lstTransactionEntry[i].DueDate.toString());
            }

            if (this.lstTransactionEntry[i].AccountingCloseDate) {
              this.lstTransactionEntry[i].AccountingCloseDate = new Date(this.lstTransactionEntry[i].AccountingCloseDate.toString());
            }


            if (this.lstTransactionEntry[i].RemitDate) {
              this.lstTransactionEntry[i].RemitDate = new Date(this.lstTransactionEntry[i].RemitDate.toString());
            }
          }
        }
        this._isNoteSaving = false;
        this._dvEmptynoteperiodiccalcMsg = false;
        setTimeout(function () {

          if (this.flexTransactionEntry) {
            this.flexTransactionEntry.autoSizeColumns(0, this.flexTransactionEntry.columns.length - 1, false, 20);
            this.flexTransactionEntry.invalidate();
          }
          this._isnoteperiodiccalcFetching = false;
        }.bind(this), 2000);
      }
      else {
        setTimeout(function () {
          this._isNoteSaving = false;
          this._norecordfound = false;
          this._isTransactionEntryFetched = false;
          this._isnoteperiodiccalcFetching = false;
          this.ShowEmptyGridText();
        }.bind(this), 1000);
      }
      error => console.error('Error: ' + error)
    });
    error => {
      setTimeout(function () {
        this._norecordfound = false;
        this._isTransactionEntryFetched = false;
        this._isnoteperiodiccalcFetching = false;
        this.ShowEmptyGridText();
        this._isNoteSaving = false;
      }.bind(this), 1000);
    }
  }


  ShowPeriodicOutput(): void {
    this._dvEmptynoteperiodiccalcMsg = false;
    this.ScenarioId = this.SelectedScenarioId;
    this.IsbtnClickText = "ShowPeriodicGrid";
    this._isnoteperiodiccalcFetching = true;
    this.getNotePeriodicCalcByNoteId(this._note);
    this._isTransactionEntryFetched = false;

  }


  ShowTransaction(): void {
    this._dvEmptynoteperiodiccalcMsg = false;
    this.IsbtnClickText = "ShowTransactionGrid";
    this.ScenarioId = this.SelectedScenarioId;
    this._isnoteperiodiccalcFetching = false;
    this._isTransactionEntryFetched = true;
    this.getTransactionEntryByNoteId(this._note);



  }

  private lstNoteOutputNPVdata: any;
  private _isnoteoutputNPVFetching: boolean = false;
  private _isnoteoutputNPVFetched: boolean = true;
  private _dvEmptyoutputNPVMsg: boolean = false;
  @ViewChild('flexnoteoutputnpv') flexnoteoutputnpv: wjcGrid.FlexGrid;

  getNoteOutputNPVdataByNoteId(_note: Note): void {
    this._isnoteoutputNPVFetching = true;
    this.noteService.getNoteOutputNPVdataByNoteId(_note, this._pageIndex, this._pageSize).subscribe(res => {
      if (res.Succeeded) {
        this._isnoteoutputNPVFetching = false;
        this._noteext.lstOutputNPVdata = res.lstOutputNPVdata;
      }
      else {
        this._noteext.lstOutputNPVdata = null;
        this._isnoteoutputNPVFetching = false;
        this._dvEmptyoutputNPVMsg = true;
        this._isnoteoutputNPVFetched = false;
      }
      error => console.error('Error: ' + error)
    });
  }

  fetchNote(): void {

    this._isNoteSaving = true;
    this._disabled = false;
    this.HideAllTabs();

    this._note.AnalysisID = this.ScenarioId;

    this.noteService.getNoteByNoteID(this._note).subscribe(res => {
      if (res.Succeeded) {
        if (res.StatusCode == 404) {
          localStorage.setItem('divWarNote', JSON.stringify(true));
          // localStorage.setItem('divWarMsgNote', JSON.stringify(true));
          localStorage.setItem('divWarMsgNote', JSON.stringify('Note not exists in our system.'));
          // this._router.navigate(['note']);
          this._router.navigate(['login']);
        }
        else {
          if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {


            this.getAllfinancingWarehouse();
            this._note = res.NoteData;

            if (this._note.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate == null) {
              this._note.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate = 4;
            }
            var notecommitmentdata = res.dtNoteCommitment;

            //to fetch note market price
            var data = res.dt;
            if (data) {
              this._note.ListNoteMarketPrice = data;
              this.ConvertToBindableDate(this._note.ListNoteMarketPrice, "NoteMarketPrice", "en-US");
              if (data.length > 0) {
                for (var m = 0; m < data.length; m++) {
                  this.originallstnotemarketprice.push({ "NoteID": data[m].NoteID, "Date": data[m].Date, "Value": data[m].Value });
                }
                setTimeout(() => {
                  this.ListNoteMarketPrice = new wjcCore.CollectionView(this._note.ListNoteMarketPrice);
                  this.ListNoteMarketPrice.trackChanges = true;
                  this.flexmarketprice.invalidate();
                }, 1000);
              }
              else {
                this._note.ListNoteMarketPrice = [];
                this.ListNoteMarketPrice = new wjcCore.CollectionView(this._note.ListNoteMarketPrice);
                this.ListNoteMarketPrice.trackChanges = true;
              }
            }
            //end

            // to fetch notecommitments
            if (notecommitmentdata) {
              this._isNotecommitmentlst = true;
              this.NoteCommitmentList = notecommitmentdata;
              this.ConvertToBindableDate(this.NoteCommitmentList, "NoteCommitment", "en-US");
              if (notecommitmentdata.length > 0) {
                var lastrownumber = this.NoteCommitmentList.length - 1;
                if (notecommitmentdata[lastrownumber].BaseCurrencyName == "USD") {
                  this._basecurrencyname = '$';
                }
                else {
                  this._basecurrencyname = '£';
                }
                setTimeout(() => {
                  this.NoteCommitmentList = new wjcCore.CollectionView(this.NoteCommitmentList);
                  this.NoteCommitmentList.trackChanges = true;
                  this.flexnotecommitments.invalidate();
                  if (this.flexnotecommitments.rows[lastrownumber].dataItem.NoteAggregatedTotalCommitment != null || this.flexnotecommitments.rows[lastrownumber].dataItem.NoteTotalCommitment != null || this.flexnotecommitments.rows[lastrownumber].dataItem.NoteAdjustedTotalCommitment != null) {
                    this._totalcommitmenttextboxvalue = this.formatNumberforTwoDecimalplaces(this.flexnotecommitments.rows[lastrownumber].dataItem.NoteTotalCommitment);
                    this._aggregatedcommitmenttexboxtvalue = this.formatNumberforTwoDecimalplaces(this.flexnotecommitments.rows[lastrownumber].dataItem.NoteAggregatedTotalCommitment);
                    this._adjustedcommitmenttextboxvalue = this.formatNumberforTwoDecimalplaces(this.flexnotecommitments.rows[lastrownumber].dataItem.NoteAdjustedTotalCommitment);
                  }
                }, 1000);
              }
              else {
                this._isNotecommitmentlst = false;
                this._ShowNotecommitmentmsg = "No data to show please save total commitment from deal detail page.";
              }
            }
            //end notecommitments
            this.gParentNoteid = this._note.NoteId;
            this.EnableM61Calculations = res.NoteData.EnableM61Calculations;

            //show eff date count on View History Button
            this.ShowCountOnViewHistoryBtn();

            this.utilityService.setPageTitle("M61 " + this._note.CRENoteID + " " + this._note.Name);

            this.getNoteexceptions(this._note.NoteId);

            if (this._note.lastCalcDateTime == null) {
              this._islastCalcDateTime = false;
            }

            this.FormatDate(this._note, "en-US");

            if (this._note.PayFrequency == null || this._note.PayFrequency == 0) {
              this._note.PayFrequency = 1;
            }
            else {
              this._note.PayFrequency = this._note.PayFrequency;
            }
            this.getTransactionTypes();
            this.getHolidayMaster();
            // this.CalculateAggregateTotal();
            this.GetAllNoteLookups();

            this._dvEmptySearchMsg = false;
            this.GetHolidayList();

            setTimeout(() => {
              this._dvEmptySearchMsg = false;
              this._noteext.NoteId = this._note.NoteId;
              this.fetchNoteAdditinallist();

              this._isNoteSaving = false;
              //  this.showindexgrid();                            
              if (localStorage.getItem('divSucessNote') == 'true') {
                this._Showmessagenotediv = true;
                this._ShowmessagenotedivMsg = localStorage.getItem('divSucessMsgNote');
                this._ShowmessagenotedivMsg = (this._ShowmessagenotedivMsg.replace('\"', '')).replace('\"', '');
                localStorage.setItem('divSucessNote', JSON.stringify(false));
                localStorage.setItem('divSucessMsgNote', JSON.stringify(''));
                setTimeout(function () {
                  this._Showmessagenotediv = false;
                }.bind(this), 5000);
              }
              if (localStorage.getItem('divInfoNote') == 'true') {
                this._Showmessagenotediv = true;
                this._ShowmessagenotedivMsg = localStorage.getItem('divInfoMsgNote');
                if (this._ShowmessagenotedivMsg != "") {
                  this._ShowmessagenotedivMsg = (this._ShowmessagenotedivMsg.replace('\"', '')).replace('\"', '');
                }
                localStorage.setItem('divInfoNote', JSON.stringify(false));
                localStorage.setItem('divInfoMsgNote', JSON.stringify(''));
                setTimeout(function () {
                  this._Showmessagenotediv = false;
                }.bind(this), 5000);
              }
            }, 1000);

            this.setFocus();
            this.ApplyPermissions(res.UserPermissionList);
            // this.AppliedReadOnly();
            this.GetUserTimezoneByID();

            if (this.EnableM61Calculations == 4) {
              this._isShowCalcbutton = false;
              this._divbatchuploadtext = true;
            }

          }

          else {
            localStorage.setItem('divWarNote', JSON.stringify(true));
            localStorage.setItem('divWarMsgNote', JSON.stringify('Sorry, you do not have permissions to access this page'));
            this._router.navigate(['note']);
          }
        }
      }
      else {
        this.utilityService.navigateToSignIn();
        this._isNoteSaving = false;
      }
      // this.ConvertToBindableDate(this._note);
    });

    error => console.error('Error: ' + error)
  }

  private ConvertToBindableDate(Data, modulename, locale: string) {
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
              //if (this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].EffectiveDate != null) {
              //  this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].EffectiveDate = new Date(Data[i].EffectiveDate.toString());
              //}
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
              //if (this._noteext.RateSpreadScheduleList[i].EffectiveDate != null) {
              //  this._noteext.RateSpreadScheduleList[i].EffectiveDate = new Date(Data[i].EffectiveDate.toString());
              //}
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
  }

  getAllScheduleLatestDataByNoteId(): void {
    var pageIndex = 1;
    var pageSize = 10;

    this.noteService.getAllScheduleLatestDataByNoteId(this._note, pageIndex, pageSize).subscribe(res => {
      if (res.Succeeded) {
        this.FutureFundingEffactiveDate = res.NoteAllScheduleLatestRecord.FutureFundingEffactiveDate;
        this.LiborScheduleEffactiveDate = res.NoteAllScheduleLatestRecord.LiborScheduleEffactiveDate;
        this.FixedAmortScheduleEffactiveDate = res.NoteAllScheduleLatestRecord.FixedAmortScheduleEffactiveDate;
        this.PIKfromPIKSourceNoteEffactiveDate = res.NoteAllScheduleLatestRecord.PIKfromPIKSourceNoteEffactiveDate;
        this.FeeCouponStripReceivableEffactiveDate = res.NoteAllScheduleLatestRecord.FeeCouponStripReceivableEffactiveDate;

        if (this.FutureFundingEffactiveDate != null) {
          //this.FutureFundingEffactiveDate = new Date(this.FutureFundingEffactiveDate.toString().replace('T00', 'T17')).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
          this.FutureFundingEffactiveDate = new Date(this.FutureFundingEffactiveDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
        }
        if (this.LiborScheduleEffactiveDate != null) {
          this.LiborScheduleEffactiveDate = new Date(this.LiborScheduleEffactiveDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
        }
        if (this.FixedAmortScheduleEffactiveDate != null) {
          this.FixedAmortScheduleEffactiveDate = new Date(this.FixedAmortScheduleEffactiveDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
        }
        if (this.PIKfromPIKSourceNoteEffactiveDate != null) {
          this.PIKfromPIKSourceNoteEffactiveDate = new Date(this.PIKfromPIKSourceNoteEffactiveDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
        }
        if (this.FeeCouponStripReceivableEffactiveDate != null) {
          this.FeeCouponStripReceivableEffactiveDate = new Date(this.FeeCouponStripReceivableEffactiveDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
        }

        this._noteext.ListFutureFundingScheduleTab = res.NoteAllScheduleLatestRecord.ListFutureFundingScheduleTab;
        this._noteext.ListFixedAmortScheduleTab = res.NoteAllScheduleLatestRecord.ListFixedAmortScheduleTab;
        this._noteext.ListLiborScheduleTab = res.NoteAllScheduleLatestRecord.ListLiborScheduleTab;
        this._noteext.ListPIKfromPIKSourceNoteTab = res.NoteAllScheduleLatestRecord.ListPIKfromPIKSourceNoteTab;
        this._noteext.ListFeeCouponStripReceivable = res.NoteAllScheduleLatestRecord.ListFeeCouponStripReceivable;

        this.ConvertToBindableDate(this._noteext.ListFutureFundingScheduleTab, "FundingSchedule", "en-US");
        this.ConvertToBindableDate(this._noteext.ListPIKfromPIKSourceNoteTab, "PIKScheduleDetail", "en-US");
        this.ConvertToBindableDate(this._noteext.ListLiborScheduleTab, "LIBORSchedule", "en-US");
        this.ConvertToBindableDate(this._noteext.ListFixedAmortScheduleTab, "AmortSchedule", "en-US");
        this.ConvertToBindableDate(this._noteext.ListFeeCouponStripReceivable, "FeeCouponStripReceivable", "en-US");

        if (this._noteext.ListFutureFundingScheduleTab !== undefined && this._noteext.ListFutureFundingScheduleTab !== null) {
          for (var i = 0; i < this._noteext.ListFutureFundingScheduleTab.length; i++) {
            if (this._noteext.ListFutureFundingScheduleTab[i].AdjustmentType) {
              //  this._noteext.ListFutureFundingScheduleTab[i].SNonCommitmentAdj = this._noteext.ListFutureFundingScheduleTab[i].NonCommitmentAdj ? "Yes" : "No";
              this._noteext.ListFutureFundingScheduleTab[i].AdjustmentTypeText = this.lstAdjustmentType.find(x => x.LookupID == this._noteext.ListFutureFundingScheduleTab[i].AdjustmentType).Name;
            }
          }
        }
        setTimeout(function () {
          this.AppliedReadOnly();
        }.bind(this), 500);
        this.ShowButton();
      }
      else {
        this.ShowButton();
      }
    });
    error => {
      this._disabled = true; //show save btn after load
      console.error('Error: ' + error)
    }
  }


  getFeeCouponStripReceivableDataByNoteId(): void {
    var pageIndex = 1;
    var pageSize = 10;
    var newNoteObj = this._note;

    newNoteObj.AnalysisID = this.SelectedCouponScenarioId;
    this.noteService.getFeeCouponStripReceivableDataByNoteId(this._note, pageIndex, pageSize).subscribe(res => {
      if (res.Succeeded) {

        this._noteext.ListFeeCouponStripReceivable = res.NoteAllScheduleLatestRecord.ListFeeCouponStripReceivable;


        this.ConvertToBindableDate(this._noteext.ListFeeCouponStripReceivable, "FeeCouponStripReceivable", "en-US");

        setTimeout(function () {
          this.AppliedReadOnly();
          this.feecouponflex.invalidate();
        }.bind(this), 500);
        this.ShowButton();
      }
      else {
        this.ShowButton();
      }
    });
    error => {
      this._disabled = true; //show save btn after load
      console.error('Error: ' + error)
    }
  }



  fetchNoteAdditinallist(): void {
    var l_noteid = this._noteext.NoteId;

    this.noteService.getNoteAdditinalListByNoteID(this._noteext).subscribe(res => {
      if (res.Succeeded) {
        this._noteext = res.NoteAdditinalList;
        this.lstNoteEditRSSlist = res.NoteList_RSSFEE.RateSpreadScheduleList;
        this.lstNoteEditFEElist = res.NoteList_RSSFEE.NotePrepayAndAdditionalFeeScheduleList;
        this.lstNoteEditPIKSchedulelist = res.NoteList_RSSFEE.NotePIKScheduleList;

        if (this.lstNoteEditRSSlist != null) {
          this.existingEffectiveDatesRSS = this.lstNoteEditRSSlist.map(item => item.EffectiveDate);
        }
        if (this.lstNoteEditFEElist != null) {
          this.existingEffectiveDatesFEE = this.lstNoteEditFEElist.map(item => item.EffectiveDate);
        }
        if (this.lstNoteEditPIKSchedulelist != null) {
          this.existingEffectiveDatesPIK = this.lstNoteEditPIKSchedulelist.map(item => item.EffectiveDate);
        }

        this._noteext.NoteId = l_noteid;

        this.fnotes.valueChanges.subscribe(val => {
          //  alert('changed ' + this.initialised);
          this.initialised += 1;
        });

        if (this._noteext.MaturityScenariosList != null) {
          if (this._noteext.MaturityScenariosList[0].EffectiveDate != null)
            this.MaturityEffectiveDate = this._noteext.MaturityScenariosList[0].EffectiveDate;
          if (this._noteext.MaturityScenariosList[0].Date != null)
            this.MaturityDate = this._noteext.MaturityScenariosList[0].Date;

          if (this.MaturityEffectiveDate != null) {
            this.MaturityEffectiveDate = new Date(this.MaturityEffectiveDate.toString());
          }
          if (this.MaturityDate != null) {
            this.MaturityDate = new Date(this.MaturityDate.toString());
          }
        }
        if (this._noteext.NoteServicingFeeScheduleList != null) {
          if (this._noteext.NoteServicingFeeScheduleList[0].EffectiveDate != null) {
            this.Servicing_EffectiveDate = new Date(this._noteext.NoteServicingFeeScheduleList[0].EffectiveDate.toString());
          }
          if (this._noteext.NoteServicingFeeScheduleList[0].Date != null) {
            this.Servicing_Date = new Date(this._noteext.NoteServicingFeeScheduleList[0].Date.toString());
          }
          this.Servicing_Value = this._noteext.NoteServicingFeeScheduleList[0].Value;
          this.Servicing_IsCapitalized = this._noteext.NoteServicingFeeScheduleList[0].IsCapitalized;
        }

        if (this._noteext.NotePIKScheduleList != null) {
          if (this._noteext.NotePIKScheduleList[0].EffectiveDate != null) {
            this.PIKSchedule_EffectiveDate = new Date(this._noteext.NotePIKScheduleList[0].EffectiveDate.toString());
          }
          if (this._noteext.NotePIKScheduleList[0].StartDate != null) {
            this.PIKSchedule_StartDate = new Date(this._noteext.NotePIKScheduleList[0].StartDate.toString());
          }
          if (this._noteext.NotePIKScheduleList[0].EndDate != null) {
            this.PIKSchedule_EndDate = new Date(this._noteext.NotePIKScheduleList[0].EndDate.toString());
          }

          this.PIKSchedule_SourceAccountID = this._noteext.NotePIKScheduleList[0].SourceAccountID;
          this.PIKSchedule_SourceAccount = this._noteext.NotePIKScheduleList[0].SourceAccount;
          if (this.PIKSchedule_SourceAccount == undefined) {
            this.PIKSchedule_SourceAccount = "";
          }
          this.PIKSchedule_TargetAccountID = this._noteext.NotePIKScheduleList[0].TargetAccountID;
          this.PIKSchedule_TargetAccount = this._noteext.NotePIKScheduleList[0].TargetAccount;
          if (this.PIKSchedule_TargetAccount == undefined) {
            this.PIKSchedule_TargetAccount = "";
          }
          this.PIKSchedule_AdditionalIntRate = this._noteext.NotePIKScheduleList[0].AdditionalIntRate;


          this.PIKSchedule_AdditionalSpread = this._noteext.NotePIKScheduleList[0].AdditionalSpread;
          this.PIKSchedule_IndexFloor = this._noteext.NotePIKScheduleList[0].IndexFloor;
          this.PIKSchedule_IntCompoundingRate = this._noteext.NotePIKScheduleList[0].IntCompoundingRate;
          this.PIKSchedule_IntCompoundingSpread = this._noteext.NotePIKScheduleList[0].IntCompoundingSpread;
          this.PIKSchedule_IntCapAmt = this._noteext.NotePIKScheduleList[0].IntCapAmt;
          this.PIKSchedule_PeriodicRateCapPercent = this._noteext.NotePIKScheduleList[0].PeriodicRateCapPercent;
          this.PIKSchedule_PeriodicRateCapAmount = this._noteext.NotePIKScheduleList[0].PeriodicRateCapAmount;
          this.PIKSchedule_PurBal = this._noteext.NotePIKScheduleList[0].PurBal;
          this.PIKSchedule_AccCapBal = this._noteext.NotePIKScheduleList[0].AccCapBal;

          this.PIKSchedule_PIKReasonCodeIDText = this._noteext.NotePIKScheduleList[0].PIKReasonCodeIDText;
          this.PIKSchedule_PIKReasonCodeID = this._noteext.NotePIKScheduleList[0].PIKReasonCodeID;


          this.PIKSchedule_PIKIntCalcMethodIDText = this._noteext.NotePIKScheduleList[0].PIKIntCalcMethodIDText;
          this.PIKSchedule_PIKIntCalcMethodID = this._noteext.NotePIKScheduleList[0].PIKIntCalcMethodID;

          this.PIKSetUp = this._noteext.NotePIKScheduleList[0].PIKSetUp;
          this.PIKSetUpText = this._noteext.NotePIKScheduleList[0].PIKSetUpText;
          this.PIKPercentage = this._noteext.NotePIKScheduleList[0].PIKPercentage;
          this.PIKCurrentPayRate = this._noteext.NotePIKScheduleList[0].PIKCurrentPayRate;
          this.PIKSeparateCompounding = this._noteext.NotePIKScheduleList[0].PIKSeparateCompounding;

          this.PIKSchedule_PIKComments = this._noteext.NotePIKScheduleList[0].PIKComments;

          if (this.PIKSchedule_EffectiveDate != null) {
            this.PIKSchedule_EffectiveDate = new Date(this.PIKSchedule_EffectiveDate.toString());
          }
          if (this.PIKSchedule_StartDate != null) {
            this.PIKSchedule_StartDate = new Date(this.PIKSchedule_StartDate.toString());
          }
          if (this.PIKSchedule_EndDate != null) {
            this.PIKSchedule_EndDate = new Date(this.PIKSchedule_EndDate.toString());
          }
        }

        this.ConvertToBindableDate(this._noteext.RateSpreadScheduleList, "RateSpreadSchedule", "en-US");
        this.ConvertToBindableDate(this._noteext.NotePrepayAndAdditionalFeeScheduleList, "PrepayAndAdditionalFeeSchedule", "en-US");
        this.ConvertToBindableDate(this._noteext.NoteStrippingList, "StrippingSchedule", "en-US");
        this.ConvertToBindableDate(this._noteext.lstFinancingFeeSchedule, "FinancingFeeSchedule", "en-US");
        this.ConvertToBindableDate(this._noteext.NoteFinancingScheduleList, "FinancingSchedule", "en-US");
        this.ConvertToBindableDate(this._noteext.lstNoteServicingLog, "Servicinglog", "en-US");
        this.ConvertToBindableDate(this._noteext.lstServicerDropDateSetup, "ServicinglogDropDate", "en-US");



        this.ServicingLog_refreshlist = this._noteext.lstNoteServicingLog;
        if (this._noteext.lstNoteServicingLog) {
          this.GetTransactionCategory();
        }



        if (this._noteext.RateSpreadScheduleList != null && this._noteext.RateSpreadScheduleList.length > 0) {
          if (this._noteext.RateSpreadScheduleList[0].EffectiveDate != null) {
            this.Ratespread_EffectiveDate = new Date(this._noteext.RateSpreadScheduleList[0].EffectiveDate.toString());
          }
          this.cvRateSpreadScheduleList = new wjcCore.CollectionView(this._noteext.RateSpreadScheduleList);
          this.cvRateSpreadScheduleList.trackChanges = true;
        }
        else {
          this._noteext.RateSpreadScheduleList = [];
          this.cvRateSpreadScheduleList = new wjcCore.CollectionView(this._noteext.RateSpreadScheduleList);
          this.cvRateSpreadScheduleList.trackChanges = true;
        }

        if (this._noteext.NotePrepayAndAdditionalFeeScheduleList != null && this._noteext.NotePrepayAndAdditionalFeeScheduleList.length > 0) {
          if (this._noteext.NotePrepayAndAdditionalFeeScheduleList[0].EffectiveDate != null) {
            this.PrepayAndAdditionalFeeSchedule_EffectiveDate = new Date(this._noteext.NotePrepayAndAdditionalFeeScheduleList[0].EffectiveDate.toString());
          }
          this.cvNotePrepayAndAdditionalFeeScheduleList = new wjcCore.CollectionView(this._noteext.NotePrepayAndAdditionalFeeScheduleList);
          this.cvNotePrepayAndAdditionalFeeScheduleList.trackChanges = true;
        }
        else {
          this._noteext.NotePrepayAndAdditionalFeeScheduleList = [];
          this.cvNotePrepayAndAdditionalFeeScheduleList = new wjcCore.CollectionView(this._noteext.NotePrepayAndAdditionalFeeScheduleList);
          this.cvNotePrepayAndAdditionalFeeScheduleList.trackChanges = true;
        }

        if (this._noteext.NoteStrippingList != null && this._noteext.NoteStrippingList.length > 0) {
          if (this._noteext.NoteStrippingList[0].EffectiveDate != null) {
            this.StrippingSchedule_EffectiveDate = new Date(this._noteext.NoteStrippingList[0].EffectiveDate.toString());
          }
          this.cvNoteStrippingList = new wjcCore.CollectionView(this._noteext.NoteStrippingList);
          this.cvNoteStrippingList.trackChanges = true;
        }
        else {
          this._noteext.NoteStrippingList = [];
          this.cvNoteStrippingList = new wjcCore.CollectionView(this._noteext.NoteStrippingList);
          this.cvNoteStrippingList.trackChanges = true;
        }

        if (this._noteext.lstFinancingFeeSchedule) {
          if (this._noteext.lstFinancingFeeSchedule[0].EffectiveDate != null) {
            this.FinancingFeeSchedule_EffectiveDate = new Date(this._noteext.lstFinancingFeeSchedule[0].EffectiveDate.toString());
          }
        }


        if (this._noteext.NoteFinancingScheduleList) {
          if (this._noteext.NoteFinancingScheduleList[0].EffectiveDate != null) {
            this.FinancingSchedule_EffectiveDate = new Date(this._noteext.NoteFinancingScheduleList[0].EffectiveDate.toString());
          }
        }

        if (this._noteext.NoteDefaultScheduleList) {
          if (this._noteext.NoteDefaultScheduleList[0].EffectiveDate != null) {
            this.DefaultSchedule_EffectiveDate = new Date(this._noteext.NoteDefaultScheduleList[0].EffectiveDate.toString());
          }
        }

        if (this._noteext.lstServicerDropDateSetup) {
          this.cvNoteServicerDropDateSetup = new wjcCore.CollectionView(this._noteext.lstServicerDropDateSetup);
          this.cvNoteServicerDropDateSetup.trackChanges = true;
        }
        else {
          this._noteext.lstServicerDropDateSetup = [];
          this.cvNoteServicerDropDateSetup = new wjcCore.CollectionView(this._noteext.lstServicerDropDateSetup);
          this.cvNoteServicerDropDateSetup.trackChanges = true;
        }


        this.showhidepikcompundingsetup();
        this.getAllScheduleLatestDataByNoteId();

        this.futurefundingflex.isReadOnly = true;
        if (this._note.UseRuletoDetermineNoteFundingText != null) {
          if (this._note.UseRuletoDetermineNoteFundingText.toLowerCase() == "y" || this._note.UseRuletoDetermineNoteFundingText.toLowerCase() == "n") {
            this._isShowMsgForUseRuletoDetermine = true;
            this.MsgForUseRuletoDetermine = "The funding schedule for this note is based on deal funding payrules. You need to edit the funding schedule from Deal Funding screen .";
            // prevent default editing
            // this.futurefundingflex.isReadOnly = true;
          }
          else {
            this._isShowMsgForUseRuletoDetermine = false;
            this.MsgForUseRuletoDetermine = "";
            // prevent default editing                      
            //  this.futurefundingflex.isReadOnly = false;
          }
        }

        if (this.Ratespread_EffectiveDate != null) {
          this.Ratespread_EffectiveDateOld = this.Ratespread_EffectiveDate;
        }

        if (this.PrepayAndAdditionalFeeSchedule_EffectiveDate != null) { this.PrepayAndAdditionalFeeSchedule_EffectiveDateOld = this.PrepayAndAdditionalFeeSchedule_EffectiveDate; }
        if (this.StrippingSchedule_EffectiveDate != null) { this.StrippingSchedule_EffectiveDateOld = this.StrippingSchedule_EffectiveDate; }
        if (this.FinancingFeeSchedule_EffectiveDate != null) { this.FinancingFeeSchedule_EffectiveDateOld = this.FinancingFeeSchedule_EffectiveDate; }
        if (this.FinancingSchedule_EffectiveDate != null) { this.FinancingSchedule_EffectiveDateOld = this.FinancingSchedule_EffectiveDate; }
        if (this.DefaultSchedule_EffectiveDate != null) { this.DefaultSchedule_EffectiveDateOld = this.DefaultSchedule_EffectiveDate; }
        if (this.PIKSchedule_EffectiveDate != null) { this.PIKSchedule_EffectiveDateOld = this.PIKSchedule_EffectiveDate; }
        //this.ShowButton();
      }
      else {
        this.utilityService.navigateToSignIn();
      }
    });
    error => {
      console.error('Error: ' + error);
    }
  }

  ClearNoteUsedPikSetup() {

    if (this.PIKSetUp == 871) {//PIK Rate

      this.PIKPercentage = null;
      this.PIKSeparateCompounding = null;
      this.PIKSchedule_IntCompoundingRate = null;
      this.PIKSchedule_IntCompoundingSpread = null;
      this.PIKCurrentPayRate = null;
    } else if (this.PIKSetUp == 870) {
      //As a % of Coupon
      this.PIKSchedule_AdditionalIntRate = null;
      this.PIKSchedule_AdditionalSpread = null;
      this.PIKCurrentPayRate = null;
      if (this.PIKSeparateCompounding != 3) {
        this.PIKSchedule_IntCompoundingRate = null;
        this.PIKSchedule_IntCompoundingSpread = null;
      }
    }
    else if (this.PIKSetUp == 891) {//Over Current Pay Rate
      this.PIKSchedule_AdditionalIntRate = null;
      this.PIKSchedule_AdditionalSpread = null;
      this.PIKPercentage = null;
      if (this.PIKSeparateCompounding != 3) {
        this.PIKSchedule_IntCompoundingRate = null;
        this.PIKSchedule_IntCompoundingSpread = null;
      }
    }
  }

  showhidepikcompundingsetup() {
    this.showpiksetupdiv = true;
    this.showCurrentPayRate = false;
    if (this.PIKSetUp == null || this.PIKSetUp == 0 || this.PIKSetUp == 871) {
      this.showpikAdditionalrate = true;
      this.showpikAccrualrate = false;
      this.showpikAccruesrate = false;
      this.showpikwithPIKSeparateCompounding = false

      this.showpiksetupdiv = true;
    } else if (this.PIKSetUp == 870) {
      if (this.PIKSeparateCompounding == 3) {
        this.showpikAdditionalrate = false;
        this.showpikAccrualrate = true;
        this.showpikAccruesrate = true;
        this.showpikwithPIKSeparateCompounding = true;

      } else {
        this.showpiksetupdiv = false;
        this.showpikAccruesrate = true;
        this.showpikwithPIKSeparateCompounding = true;
      }

    } else if (this.PIKSetUp == 891) {
      this.showpikwithPIKSeparateCompounding = true;
      this.showpikAccruesrate = false;
      this.showCurrentPayRate = true;

      if (this.PIKSeparateCompounding == 3) {
        this.showpikAdditionalrate = false;
        this.showpikAccrualrate = true;
      } else {
        this.showpiksetupdiv = false;
      }
    }
  }

  ServicingLogReadOnly() {
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


          if (this.flexservicelog.rows[i].dataItem.ServicerMasterID == 6) {
            if (this.flexservicelog.rows[i]) {
              this.flexservicelog.rows[i].isReadOnly = true;
              this.flexservicelog.rows[i].cssClass = "customgridActualcolor";
            }
          }
        }
      }


    }
    this.flexservicelog.invalidate();
  }

  RssFeePikModulename: any;

  EditDialogRSSFEE(modulename) {

    this.RssFeePikModulename = modulename;

    if (modulename == 'Rate Spread Schedule') {
      this.lstNoteEditRSSlist;

      for (var i = 0; i < this.lstNoteEditRSSlist.length; i++) {
        if (this.lstNoteEditRSSlist[i].EffectiveDate != null) {
          this.lstNoteEditRSSlist[i].EffectiveDate = new Date(this.lstNoteEditRSSlist[i].EffectiveDate.toString());
        }
        if (this.lstNoteEditRSSlist[i].Date != null) {
          this.lstNoteEditRSSlist[i].Date = new Date(this.lstNoteEditRSSlist[i].Date.toString());
        }
      }

      if (this.lstNoteEditRSSlist != null && this.lstNoteEditRSSlist.length > 0) {
        this.cvEditRateSpreadScheduleList = new wjcCore.CollectionView(this.lstNoteEditRSSlist);
        this.cvEditRateSpreadScheduleList.trackChanges = true;
      }
      else {
        this.lstNoteEditRSSlist = [];
        this.cvEditRateSpreadScheduleList = new wjcCore.CollectionView(this.lstNoteEditRSSlist);
        this.cvEditRateSpreadScheduleList.trackChanges = true;
      }

      var modal = document.getElementById('myModalEditNoteRSS');
      modal.style.display = "block";
      $.getScript("/js/jsDrag.js");
    }

    else if (modulename == 'Fee Schedule') {
      this.lstNoteEditFEElist;
      for (var i = 0; i < this.lstNoteEditFEElist.length; i++) {
        if (this.lstNoteEditFEElist[i].EffectiveDate != null) {
          this.lstNoteEditFEElist[i].EffectiveDate = new Date(this.lstNoteEditFEElist[i].EffectiveDate.toString());
        }
        if (this.lstNoteEditFEElist[i].StartDate != null) {
          this.lstNoteEditFEElist[i].StartDate = new Date(this.lstNoteEditFEElist[i].StartDate.toString());
        }
        if (this.lstNoteEditFEElist[i].ScheduleEndDate != null) {
          this.lstNoteEditFEElist[i].ScheduleEndDate = new Date(this.lstNoteEditFEElist[i].ScheduleEndDate.toString());
        }
      }

      if (this.lstNoteEditFEElist != null && this.lstNoteEditFEElist.length > 0) {
        this.cvEditFeeScheduleList = new wjcCore.CollectionView(this.lstNoteEditFEElist);
        this.cvEditFeeScheduleList.trackChanges = true;
      }
      else {
        this.lstNoteEditFEElist = [];
        this.cvEditFeeScheduleList = new wjcCore.CollectionView(this.lstNoteEditFEElist);
        this.cvEditFeeScheduleList.trackChanges = true;
      }

      var modal = document.getElementById('myModalEditNoteFEE');
      modal.style.display = "block";
      $.getScript("/js/jsDrag.js");
    }

    else if (modulename == 'PIK Schedule') {
      this.lstNoteEditPIKSchedulelist;

      for (var i = 0; i < this.lstNoteEditPIKSchedulelist.length; i++) {
        if (this.lstNoteEditPIKSchedulelist[i].EffectiveDate != null) {
          this.lstNoteEditPIKSchedulelist[i].EffectiveDate = new Date(this.lstNoteEditPIKSchedulelist[i].EffectiveDate.toString());
        }
        if (this.lstNoteEditPIKSchedulelist[i].StartDate != null) {
          this.lstNoteEditPIKSchedulelist[i].StartDate = new Date(this.lstNoteEditPIKSchedulelist[i].StartDate.toString());
        }
        if (this.lstNoteEditPIKSchedulelist[i].EndDate != null) {
          this.lstNoteEditPIKSchedulelist[i].EndDate = new Date(this.lstNoteEditPIKSchedulelist[i].EndDate.toString());
        }
      }

      if (this.lstNoteEditPIKSchedulelist != null && this.lstNoteEditPIKSchedulelist.length > 0) {
        this.cvEditPIKSchedulelist = new wjcCore.CollectionView(this.lstNoteEditPIKSchedulelist);
        this.cvEditPIKSchedulelist.trackChanges = true;
      }
      else {
        this.lstNoteEditPIKSchedulelist = [];
        this.cvEditPIKSchedulelist = new wjcCore.CollectionView(this.lstNoteEditPIKSchedulelist);
        this.cvEditPIKSchedulelist.trackChanges = true;
      }

      this.flexEditPIK.itemFormatter = function (panel, r, c, cell) {
        if (panel.cellType != wjcGrid.CellType.Cell) {
          return;
        }
        if (panel.columns[c].header == 'Impact in Commitment Calc'
          || panel.columns[c].header == 'Cash Interest Calc-PIK Balance updated on Business Adjusted Pmt Date'
          || panel.columns[c].header == 'Source Account'
          || panel.columns[c].header == 'Target Account') {
          cell.style.backgroundColor = '#cfcfcf';
        }
      }
      var modal = document.getElementById('myModalEditNotePIK');
      modal.style.display = "block";
      $.getScript("/js/jsDrag.js");

    }

    this._bindGridDropdows();
  }


  ShowButton(): void {
    this._disabled = true; //show save btn after load         

    if (this._noteext.ListFutureFundingScheduleTab != null) {
      if (this._noteext.ListFutureFundingScheduleTab.length > 0) this.ShowHideFlagFutureFunding = true;
    }
    if (this.LiborScheduleEffactiveDate != null) this.ShowHideFlagLiborSchedule = true;
    if (this.FixedAmortScheduleEffactiveDate != null) this.ShowFlagHideFixedAmortSchedule = true;
    if (this.PIKfromPIKSourceNoteEffactiveDate != null) this.ShowHideFlagPIKfromPIKSourceNote = true;
    if (this.FeeCouponStripReceivableEffactiveDate != null) this.ShowHideFlagFeeCouponStripReceivable = true;
    if (this.MaturityEffectiveDate != null) this.ShowHideFlagMaturity = true;
    if (this._noteext.NoteDefaultScheduleList != null) this.ShowHideFlagDefaultSchedule = true;
    if (this._noteext.lstFinancingFeeSchedule != null) this.ShowHideFlagFinancingFeeSchedule = true;
    if (this._noteext.NoteFinancingScheduleList != null) this.ShowHideFlagFinancingSchedule = true;
    if (this._noteext.NotePrepayAndAdditionalFeeScheduleList != null) this.ShowHideFlagPrepayAndAdditionalFeeSchedule = true;
    if (this._noteext.NotePrepayAndAdditionalFeeScheduleList != null) this.ShowHideEditPrepayAndAdditionalFeeSchedule = true;
    if (this._noteext.RateSpreadScheduleList != null) this.ShowHideFlagRateSpreadSchedule = true;
    if (this._noteext.RateSpreadScheduleList != null) this.ShowHideEditRateSpreadSchedule = true;
    if (this._noteext.NotePIKScheduleList != null) this.ShowHideEditPIKSchedule = true;
    if (this.Servicing_EffectiveDate != null) this.ShowHideFlagServicingFeeSchedule = true;
    if (this._noteext.NoteStrippingList != null) this.ShowHideFlagStrippingSchedule = true;
    if (this._noteext.NotePIKScheduleList != null) this.ShowHideFlagPIKSchedule = true;
  }

  SaveNote(objNote): void {
    this._note.RequestType = null;
    this.ValidateNoteAndSave();

    //this.SaveNotefunc(this._note);
  }

  SaveNotefunc(objNote, notevalue): void {
    this._isNoteSaving = true;

    //clear old pik values which are not used
    if (this.PIKSetUp == 871) {
      //PIK Rate  
      objNote.PIKSeparateCompounding = null;
    }
    this.ClearNoteUsedPikSetup();

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
    this.noteService.addNote(objNote).subscribe(res => {
      if (res.Succeeded) {
        //  this._isNoteSaving = false;
        this._noteextt.NoteId = res.newNoteID;
        this._note.NoteId = res.newNoteID;
        this.SaveNoteextralist(true);
        this.AddUpdateNoteRuleTypeSetup();
        // this.SendPushNotification(notificationNoteId);
      }
      else {
        this.utilityService.navigateToSignIn();
        // this._router.navigate([this.routes.note.name]);
      }
    });
    error => console.error('Error: ' + error);
  }

  SaveNoteextralist(savebtnclick, calc = false): void {
    for (var i = 0; i < this._noteext.RateSpreadScheduleList.length; i++) {
      if (!(Number(this._noteext.RateSpreadScheduleList[i].ValueTypeText).toString() == "NaN" || Number(this._noteext.RateSpreadScheduleList[i].ValueTypeText) == 0)) {
        this._noteext.RateSpreadScheduleList[i].ValueTypeID = Number(this._noteext.RateSpreadScheduleList[i].ValueTypeText);
        this._noteext.RateSpreadScheduleList[i].ValueTypeText = this.lstRateSpreadSch_ValueType.find(x => x.LookupID == this._noteext.RateSpreadScheduleList[i].ValueTypeID).Name
      }
      else {
        var filteredarray = this.lstRateSpreadSch_ValueType.filter(x => x.Name == this._noteext.RateSpreadScheduleList[i].ValueTypeText)
        if (filteredarray.length != 0) {
          this._noteext.RateSpreadScheduleList[i].ValueTypeID = Number(filteredarray[0].LookupID);
        }
      }

      if (!(Number(this._noteext.RateSpreadScheduleList[i].IntCalcMethodText).toString() == "NaN" || Number(this._noteext.RateSpreadScheduleList[i].IntCalcMethodText) == 0)) {
        this._noteext.RateSpreadScheduleList[i].IntCalcMethodID = Number(this._noteext.RateSpreadScheduleList[i].IntCalcMethodText);
        this._noteext.RateSpreadScheduleList[i].IntCalcMethodText = this.lstIntCalcMethodID.find(x => x.LookupID == this._noteext.RateSpreadScheduleList[i].IntCalcMethodID).Name
      } else {
        var filteredarray = this.lstIntCalcMethodID.filter(x => x.Name == this._noteext.RateSpreadScheduleList[i].IntCalcMethodText)
        if (filteredarray.length != 0) {
          this._noteext.RateSpreadScheduleList[i].IntCalcMethodID = Number(filteredarray[0].LookupID);
        }
      }
      //manish
      if (!(Number(this._noteext.RateSpreadScheduleList[i].IndexNameText).toString() == "NaN" || Number(this._noteext.RateSpreadScheduleList[i].IndexNameText) == 0)) {
        this._noteext.RateSpreadScheduleList[i].IndexNameID = Number(this._noteext.RateSpreadScheduleList[i].IndexNameText);

        this._noteext.RateSpreadScheduleList[i].IndexNameText = this.lstIndextype.find(x => x.LookupID == this._noteext.RateSpreadScheduleList[i].IndexNameID).Name
      } else {
        var filteredarray = this.lstIndextype.filter(x => x.Name == this._noteext.RateSpreadScheduleList[i].IndexNameText)

        if (filteredarray.length != 0) {
          this._noteext.RateSpreadScheduleList[i].IndexNameID = Number(filteredarray[0].LookupID);
        }
      }


      if (!(Number(this._noteext.RateSpreadScheduleList[i].DeterminationDateHolidayListText).toString() == "NaN" || Number(this._noteext.RateSpreadScheduleList[i].DeterminationDateHolidayListText) == 0)) {
        this._noteext.RateSpreadScheduleList[i].DeterminationDateHolidayList = Number(this._noteext.RateSpreadScheduleList[i].DeterminationDateHolidayListText);

        this._noteext.RateSpreadScheduleList[i].DeterminationDateHolidayListText = this.holidayCalendarNamelist.find(x => x.HolidayMasterID == this._noteext.RateSpreadScheduleList[i].DeterminationDateHolidayList).CalendarName
      } else {
        var filteredarray = this.holidayCalendarNamelist.filter(x => x.CalendarName == this._noteext.RateSpreadScheduleList[i].DeterminationDateHolidayListText)

        if (filteredarray.length != 0) {
          this._noteext.RateSpreadScheduleList[i].DeterminationDateHolidayList = Number(filteredarray[0].HolidayMasterID);
        }
      }

      this._noteext.RateSpreadScheduleList[i].EffectiveDate = this.Ratespread_EffectiveDate;
      //this._noteext.RateSpreadScheduleList[i].AccountID = this._note.AccountID
      this._noteext.RateSpreadScheduleList[i].ModuleId = 14;
    }

    if (this._noteext.NotePrepayAndAdditionalFeeScheduleList) {
      for (var i = 0; i < this._noteext.NotePrepayAndAdditionalFeeScheduleList.length; i++) {
        if (!(Number(this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ValueTypeText).toString() == "NaN" || Number(this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ValueTypeText) == 0)) {
          this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ValueTypeID = Number(this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ValueTypeText);
        }
        else {

          var filteredarray = this.lstPrepayAdditinalFee_ValueType.filter(x => x.Name == this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ValueTypeText)
          if (filteredarray.length != 0) {
            this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ValueTypeID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ApplyTrueUpFeatureText).toString() == "NaN" || Number(this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ApplyTrueUpFeatureText) == 0)) {
          this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ApplyTrueUpFeatureID = Number(this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ApplyTrueUpFeatureText);
        }
        else {

          var filteredarray1 = this.lstPrepayAdditinalFee_lstApplyTrueUpFeature.filter(x => x.Name == this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ApplyTrueUpFeatureText)
          if (filteredarray1.length != 0) {
            this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ApplyTrueUpFeatureID = Number(filteredarray1[0].LookupID);
          }
        }


        this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].EffectiveDate = this.PrepayAndAdditionalFeeSchedule_EffectiveDate;
        //this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].AccountID = this._note.AccountID
        this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].ModuleId = 13;
      }
    }

    if (this._noteext.NoteStrippingList) {
      for (var i = 0; i < this._noteext.NoteStrippingList.length; i++) {
        if (!(Number(this._noteext.NoteStrippingList[i].ValueTypeText).toString() == "NaN" || Number(this._noteext.NoteStrippingList[i].ValueTypeText) == 0)) {
          this._noteext.NoteStrippingList[i].ValueTypeID = Number(this._noteext.NoteStrippingList[i].ValueTypeText);
        }
        else {
          var filteredarray = this.lstStrippingSch_ValueType.filter(x => x.Name == this._noteext.NoteStrippingList[i].ValueTypeText)
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
          var filteredarray = this.lstFinancingFeeSch_ValueType.filter(x => x.Name == this._noteext.lstFinancingFeeSchedule[i].ValueTypeText)
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
        } else {
          var filteredarray = this.lstFinancingSch_ValueType.filter(x => x.Name == this._noteext.NoteFinancingScheduleList[i].ValueTypeText)
          if (filteredarray.length != 0) {
            this._noteext.NoteFinancingScheduleList[i].ValueTypeID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this._noteext.NoteFinancingScheduleList[i].CurrencyCodeText).toString() == "NaN" || Number(this._noteext.NoteFinancingScheduleList[i].CurrencyCodeText) == 0)) {
          this._noteext.NoteFinancingScheduleList[i].CurrencyCode = Number(this._noteext.NoteFinancingScheduleList[i].CurrencyCodeText);
        } else {
          var filteredarray = this.lstLoanCurrency.filter(x => x.Name == this._noteext.NoteFinancingScheduleList[i].CurrencyCodeText)
          if (filteredarray.length != 0) {
            this._noteext.NoteFinancingScheduleList[i].CurrencyCode = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this._noteext.NoteFinancingScheduleList[i].IndexTypeText).toString() == "NaN" || Number(this._noteext.NoteFinancingScheduleList[i].IndexTypeText) == 0)) {
          this._noteext.NoteFinancingScheduleList[i].IndexTypeID = Number(this._noteext.NoteFinancingScheduleList[i].IndexTypeText);
        }
        else {
          var filteredarray = this.lstIndextype.filter(x => x.Name == this._noteext.NoteFinancingScheduleList[i].IndexTypeText)
          if (filteredarray.length != 0) {
            this._noteext.NoteFinancingScheduleList[i].IndexTypeID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this._noteext.NoteFinancingScheduleList[i].IntCalcMethodText).toString() == "NaN" || Number(this._noteext.NoteFinancingScheduleList[i].IntCalcMethodText) == 0)) {
          this._noteext.NoteFinancingScheduleList[i].IntCalcMethodID = Number(this._noteext.NoteFinancingScheduleList[i].IntCalcMethodText);
        } else {
          var filteredarray = this.lstIntCalcMethodID.filter(x => x.Name == this._noteext.NoteFinancingScheduleList[i].IntCalcMethodText)
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
          var filteredarray = this.lstDefaultSch_ValueType.filter(x => x.Name == this._noteext.NoteDefaultScheduleList[i].ValueTypeID)
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
          var filterval = this._noteext.lstNoteServicingLog.filter(x => x.row_num == this.flexservicelogupdatedrow_num[i])
          if (filterval.length != 0) {
            if (!(Number(filterval[0].TransactionTypeText).toString() == "NaN" || Number(filterval[0].TransactionTypeText) == 0)) {
              filterval[0].TransactionType = Number(filterval[0].TransactionTypeText);
              //var filteredarray = this.listtransactiontype.filter(x => x.TransactionTypesID == this.ServicingLog_refreshlist[this.flexservicelogupdatedRowNo[i]].TransactionType);
              var filteredarray = this.listtransactiontype.filter(x => x.TransactionTypesID == filterval[0].TransactionType);

              filterval[0].TransactionTypeText = filteredarray[0].TransactionName;
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
      this._noteextt.NoteServicingFeeScheduleList[0].Value = this.Servicing_Value
      this._noteextt.NoteServicingFeeScheduleList[0].IsCapitalized = this.Servicing_IsCapitalized
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

        this._noteextt.NotePIKScheduleList[0].EndDate = this.PIKSchedule_EndDate;


        if (this.SourceAccountID != null) {
          this._noteextt.NotePIKScheduleList[0].SourceAccountID = this.SourceAccountID
        } else {
          this._noteextt.NotePIKScheduleList[0].SourceAccountID = this.PIKSchedule_SourceAccountID
          this._noteextt.NotePIKScheduleList[0].SourceAccount = this.PIKSchedule_SourceAccount
        }

        if (this.TargetAccountID != null) {
          this._noteextt.NotePIKScheduleList[0].TargetAccountID = this.TargetAccountID
        } else {
          this._noteextt.NotePIKScheduleList[0].TargetAccountID = this.PIKSchedule_TargetAccountID
          this._noteextt.NotePIKScheduleList[0].TargetAccount = this.PIKSchedule_TargetAccount
        }

        //   this._noteextt.lstPIKSchedule[0].SourceAccount = this.SourceAccountID
        //    this._noteextt.lstPIKSchedule[0].TargetAccountID = this.TargetAccountID
        // this._noteextt.lstPIKSchedule[0].TargetAccount = this.TargetAccountID
        this._noteextt.NotePIKScheduleList[0].AdditionalIntRate = this.PIKSchedule_AdditionalIntRate

        this._noteextt.NotePIKScheduleList[0].AdditionalSpread = this.PIKSchedule_AdditionalSpread
        this._noteextt.NotePIKScheduleList[0].IndexFloor = this.PIKSchedule_IndexFloor
        this._noteextt.NotePIKScheduleList[0].IntCompoundingRate = this.PIKSchedule_IntCompoundingRate
        this._noteextt.NotePIKScheduleList[0].IntCompoundingSpread = this.PIKSchedule_IntCompoundingSpread
        this._noteextt.NotePIKScheduleList[0].IntCapAmt = this.PIKSchedule_IntCapAmt
        this._noteextt.NotePIKScheduleList[0].PurBal = this.PIKSchedule_PurBal
        this._noteextt.NotePIKScheduleList[0].AccCapBal = this.PIKSchedule_AccCapBal

        this._noteextt.NotePIKScheduleList[0].PIKReasonCodeID = this.PIKSchedule_PIKReasonCodeID
        this._noteextt.NotePIKScheduleList[0].PIKComments = this.PIKSchedule_PIKComments
        this._noteextt.NotePIKScheduleList[0].PIKReasonCodeIDText = this.PIKSchedule_PIKReasonCodeIDText

        this._noteextt.NotePIKScheduleList[0].PIKIntCalcMethodID = this.PIKSchedule_PIKIntCalcMethodID
        this._noteextt.NotePIKScheduleList[0].PIKIntCalcMethodIDText = this.PIKSchedule_PIKIntCalcMethodIDText

        this._noteextt.NotePIKScheduleList[0].PeriodicRateCapAmount = this.PIKSchedule_PeriodicRateCapAmount
        this._noteextt.NotePIKScheduleList[0].PeriodicRateCapPercent = this.PIKSchedule_PeriodicRateCapPercent

        this._noteextt.NotePIKScheduleList[0].PIKSetUp = this.PIKSetUp
        this._noteextt.NotePIKScheduleList[0].PIKSetUpText = this.PIKSetUpText
        this._noteextt.NotePIKScheduleList[0].PIKPercentage = this.PIKPercentage
        this._noteextt.NotePIKScheduleList[0].PIKCurrentPayRate = this.PIKCurrentPayRate
        this._noteextt.NotePIKScheduleList[0].PIKSeparateCompounding = this.PIKSeparateCompounding
        this._noteextt.NotePIKScheduleList[0].PIKSeparateCompoundingText = this.PIKSeparateCompoundingText


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
          var filteredarray = this.lstPurposeType.filter(x => x.Name == this._noteext.ListFutureFundingScheduleTab[i].PurposeText)
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

    this.noteService.addNoteExtralist(this._noteextt).subscribe(res => {
      if (res.Succeeded) {
        this.SaveNoteArchieveextralist();

        //get last funding updated date
        this.noteService.GetLastUpdatedDateAndUpdatedByForSchedule(this._note).subscribe(res => {
          if (res.Succeeded) {
            this._note.FFLastUpdatedDate_String = res.NoteAllScheduleLatestRecord.LastUpdatedDate_String_FF;
            this._note.UpdatedByFF = res.NoteAllScheduleLatestRecord.LastUpdatedBy_FF;
          }
        });

        if (calc) {
          this._note.CalculationStatus = "Running";
          this.RunCalculator();
        }
        else if (savebtnclick) {
          this._isNoteSaving = false;
          if (res.TotalCount == 0) {
            this._copymessagediv = false;
            this._isNoteSaveonly = true;
            localStorage.setItem('divSucessNote', JSON.stringify(true));
            localStorage.setItem('divSucessMsgNote', JSON.stringify(res.Message));
            this._Showmessagenotediv = true;
            this._ShowmessagenotedivMsg = res.Message;
            this.exceptionscount_critical = 0;
            this.exceptionscount_normal = 0;
            this.lstnotesexceptions = [];

          }
          else {
            this._copymessagediv = false;
            this._isNoteSaveonly = true;
            localStorage.setItem('divInfoNote', JSON.stringify(true));
            localStorage.setItem('divInfoMsgNote', JSON.stringify(res.Message));
            this._ShowmessagenotedivWar = true;
            this._ShowmessagenotedivMsgWar = res.Message;
            this.exceptionscount_critical = res.TotalCount;
            this.exceptionscount_normal = 0;
            this.lstnotesexceptions = res.Allexceptionslist;

          }
          if (res.Succeeded == false) {
            this._copymessagediv = false;
            localStorage.setItem('divWarNote', JSON.stringify(true));
            localStorage.setItem('divWarMsgNote', JSON.stringify(res.Message));
            this._ShowmessagenotedivWar = true;
            this._ShowmessagenotedivMsgWar = res.Message;
          }


          if (!this.isSaveOnly) {
            this._router.navigate(['note']);
          }
          else if (this.isSaveOnly) {

            var returnUrl = this._router.url;
            if (window.location.href.indexOf("notedetail/a") > -1) {
              returnUrl = returnUrl.toString().replace('notedetail/a/', 'notedetail/');

            }
            else if (returnUrl.indexOf("notedetail/") > -1) {
              returnUrl = returnUrl.toString().replace('notedetail/', 'notedetail/a/');
            }
            this._router.navigate([returnUrl]);
          }

          setTimeout(() => {
            this._Showmessagenotediv = false;
            this._ShowmessagenotedivWar = false;
          }, 2000);

        }
      }
      else {
        //Error msg

        //   this._ShowmessagedivWarnote = true;
        this._ShowmessagenotedivWar = true;
        this._isNoteSaving = false;
        //  this._ShowmessagedivMsgWarnote = "Error occurred while saving Note Additional , please contact to system administrator.";
        this._ShowmessagenotedivMsgWar = "Error occurred while saving Note Additional , please contact to system administrator.";
        this.ClosePopUp();

        setTimeout(function () {
          this._isNoteSaving = false;
          //  this._ShowmessagedivWarnote = false;
          this._Showmessagenotediv = false;
          this._ShowmessagenotedivWar = false;
        }.bind(this), 5000);
      }
    })
  }


  showConfirmationDialog(name) {
    var modalConfirm = document.getElementById('myModalConfirmationBox');
    var messageElement = document.getElementById('confirmationMessage');
    var heading = document.getElementById('heading');
    var btn = document.getElementById('yesbtn');

    messageElement.innerHTML = 'This will update historical records. Are you sure you want to update this?';
    heading.innerHTML = 'Update';
    btn.style.visibility = 'visible';

    var locale = "en-US";
    var options: any = { year: "numeric", month: "numeric", day: "numeric" };

    if (name == 'EditRSS') {
      var sel = this.flexEditRSS.selection;
      var editedRowIndex = sel.topRow;
      var currentItem = this.lstNoteEditRSSlist.findIndex(x => x.ScheduleID == this.flexEditRSS.rows[editedRowIndex].dataItem.ScheduleID);

      var rssformatDate: Date;
      var isCopy = sel.bottomRow !== undefined;
      if (isCopy) {
        // Handle copied data scenario
        for (var tprow = currentItem; tprow <= currentItem; tprow++) {
          var flag = this.CheckDuplicateDateAndValue(this.lstNoteEditRSSlist, tprow);
          if (flag == true) {
            var formatValuetype = this.lstRateSpreadSch_ValueType.filter(x => x.LookupID == this.lstNoteEditRSSlist[tprow].ValueTypeText);

            rssformatDate = this.lstNoteEditRSSlist[tprow].Date;

            if (rssformatDate.toString().indexOf("GMT") == -1) {
              messageElement.innerHTML = "Date - " + rssformatDate + " and Value Type - " + formatValuetype[0].Name + " already in list";
            } else {
              messageElement.innerHTML = "Date - " + rssformatDate.toLocaleDateString(locale, options) + " and Value Type - " + formatValuetype[0].Name + " already in list";
            }
            heading.innerHTML = "CRES - Validation Error";
            btn.style.visibility = 'hidden';

          }
        }
      }
      else {
        // Handle single cell edit scenario
        var flag = this.CheckDuplicateDateAndValue(this.lstNoteEditRSSlist, currentItem);
        if (flag == true) {
          var formatValuetype = this.lstRateSpreadSch_ValueType.filter(x => x.LookupID == this.lstNoteEditRSSlist[currentItem].ValueTypeText);


          rssformatDate = this.lstNoteEditRSSlist[currentItem].Date;

          if (rssformatDate.toString().indexOf("GMT") == -1) {
            messageElement.innerHTML = "Date - " + rssformatDate + " and Value Type - " + formatValuetype[0].Name + " already in list";
          } else {
            messageElement.innerHTML = "Date - " + rssformatDate.toLocaleDateString(locale, options) + " and Value Type - " + formatValuetype[0].Name + " already in list";
          }
          heading.innerHTML = "CRES - Validation Error";
          btn.style.visibility = 'hidden';

        }
      }
    }

    if (name == 'EditFEE') {
      var sel = this.flexEditFee.selection;
      var editedRowIndex = sel.topRow;
      var currentItem = this.lstNoteEditFEElist.findIndex(x => x.ScheduleID == this.flexEditFee.rows[editedRowIndex].dataItem.ScheduleID);

      var feeformatDate: Date;
      var isCopy = sel.bottomRow !== undefined;
      if (isCopy) {
        // Handle copied data scenario
        for (var tprow = currentItem; tprow <= currentItem; tprow++) {
          var flag = this.CheckDuplicateDateAndValue(this.lstNoteEditFEElist, tprow);
          if (flag == true) {
            var formatValuetype = this.lstPrepayAdditinalFee_ValueType.filter(x => x.LookupID == this.lstNoteEditFEElist[tprow].ValueTypeText);

            feeformatDate = this.lstNoteEditFEElist[tprow].Date;

            if (feeformatDate.toString().indexOf("GMT") == -1) {
              messageElement.innerHTML = "Date - " + feeformatDate + " and Value Type - " + formatValuetype[0].Name + " already in list";
            } else {
              messageElement.innerHTML = "Date - " + feeformatDate.toLocaleDateString(locale, options) + " and Value Type - " + formatValuetype[0].Name + " already in list";
            }
            heading.innerHTML = "CRES - Validation Error";
            btn.style.visibility = 'hidden';

          }
        }
      }
      else {
        // Handle single cell edit scenario
        var flag = this.CheckDuplicateDateAndValue(this.lstNoteEditFEElist, currentItem);
        if (flag == true) {
          var formatValuetype = this.lstPrepayAdditinalFee_ValueType.filter(x => x.LookupID == this.lstNoteEditFEElist[currentItem].ValueTypeText);


          feeformatDate = this.lstNoteEditFEElist[currentItem].Date;

          if (feeformatDate.toString().indexOf("GMT") == -1) {
            messageElement.innerHTML = "Date - " + feeformatDate + " and Value Type - " + formatValuetype[0].Name + " already in list";
          } else {
            messageElement.innerHTML = "Date - " + feeformatDate.toLocaleDateString(locale, options) + " and Value Type - " + formatValuetype[0].Name + " already in list";
          }
          heading.innerHTML = "CRES - Validation Error";
          btn.style.visibility = 'hidden';

        }
      }
    }

    if (name == 'EditPIK') {
      var sel = this.flexEditPIK.selection;
      var editedRowIndex = sel.topRow;
      var currentItem = this.lstNoteEditPIKSchedulelist.findIndex(x => x.ScheduleID == this.flexEditPIK.rows[editedRowIndex].dataItem.ScheduleID);

      var pikformatDate: Date;
      var isCopy = sel.bottomRow !== undefined;
      if (isCopy) {
        // Handle copied data scenario
        for (var tprow = currentItem; tprow <= currentItem; tprow++) {
          var flag = this.CheckDuplicateDateAndValue(this.lstNoteEditPIKSchedulelist, tprow);
          if (flag == true) {
            pikformatDate = this.lstNoteEditPIKSchedulelist[tprow].Date;

            if (pikformatDate.toString().indexOf("GMT") == -1) {
              messageElement.innerHTML = "Date - " + pikformatDate + " already in list";
            } else {
              messageElement.innerHTML = "Date - " + pikformatDate.toLocaleDateString(locale, options) + " already in list";
            }
            heading.innerHTML = "CRES - Validation Error";
            btn.style.visibility = 'hidden';

          }
        }
      }
      else {
        // Handle single cell edit scenario
        var flag = this.CheckDuplicateDateAndValue(this.lstNoteEditPIKSchedulelist, currentItem);
        if (flag == true) {

          pikformatDate = this.lstNoteEditPIKSchedulelist[currentItem].Date;

          if (pikformatDate.toString().indexOf("GMT") == -1) {
            messageElement.innerHTML = "Date - " + pikformatDate + " already in list";
          } else {
            messageElement.innerHTML = "Date - " + pikformatDate.toLocaleDateString(locale, options) + " already in list";
          }
          heading.innerHTML = "CRES - Validation Error";
          btn.style.visibility = 'hidden';

        }
      }
    }

    modalConfirm.style.display = "block";
    $.getScript("/js/jsDrag.js");

  }


  CloseConfirmPopUp() {
    var modalConfirm = document.getElementById('myModalConfirmationBox');
    modalConfirm.style.display = "none";
    $.getScript("/js/jsDrag.js");
  }



  UpdateNoteEditlistRSSFEEPIK(): void {

    //===========================================================
    if (this.lstNoteEditRSSlist) {
      for (var i = 0; i < this.lstNoteEditRSSlist.length; i++) {
        if (!(Number(this.lstNoteEditRSSlist[i].ValueTypeText).toString() == "NaN" || Number(this.lstNoteEditRSSlist[i].ValueTypeText) == 0)) {
          this.lstNoteEditRSSlist[i].ValueTypeID = Number(this.lstNoteEditRSSlist[i].ValueTypeText);
          this.lstNoteEditRSSlist[i].ValueTypeText = this.lstRateSpreadSch_ValueType.find(x => x.LookupID == this.lstNoteEditRSSlist[i].ValueTypeID).Name
        }
        else {
          var filteredarray = this.lstRateSpreadSch_ValueType.filter(x => x.Name == this.lstNoteEditRSSlist[i].ValueTypeText)
          if (filteredarray.length != 0) {
            this.lstNoteEditRSSlist[i].ValueTypeID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this.lstNoteEditRSSlist[i].IntCalcMethodText).toString() == "NaN" || Number(this.lstNoteEditRSSlist[i].IntCalcMethodText) == 0)) {
          this.lstNoteEditRSSlist[i].IntCalcMethodID = Number(this.lstNoteEditRSSlist[i].IntCalcMethodText);
          this.lstNoteEditRSSlist[i].IntCalcMethodText = this.lstIntCalcMethodID.find(x => x.LookupID == this.lstNoteEditRSSlist[i].IntCalcMethodID).Name
        } else {
          var filteredarray = this.lstIntCalcMethodID.filter(x => x.Name == this.lstNoteEditRSSlist[i].IntCalcMethodText)
          if (filteredarray.length != 0) {
            this.lstNoteEditRSSlist[i].IntCalcMethodID = Number(filteredarray[0].LookupID);
          }
        }
        if (!(Number(this.lstNoteEditRSSlist[i].IndexNameText).toString() == "NaN" || Number(this.lstNoteEditRSSlist[i].IndexNameText) == 0)) {
          this.lstNoteEditRSSlist[i].IndexNameID = Number(this.lstNoteEditRSSlist[i].IndexNameText);

          this.lstNoteEditRSSlist[i].IndexNameText = this.lstIndextype.find(x => x.LookupID == this.lstNoteEditRSSlist[i].IndexNameID).Name
        } else {
          var filteredarray = this.lstIndextype.filter(x => x.Name == this.lstNoteEditRSSlist[i].IndexNameText)

          if (filteredarray.length != 0) {
            this.lstNoteEditRSSlist[i].IndexNameID = Number(filteredarray[0].LookupID);
          }
        }


        if (!(Number(this.lstNoteEditRSSlist[i].DeterminationDateHolidayListText).toString() == "NaN" || Number(this.lstNoteEditRSSlist[i].DeterminationDateHolidayListText) == 0)) {
          this.lstNoteEditRSSlist[i].DeterminationDateHolidayList = Number(this.lstNoteEditRSSlist[i].DeterminationDateHolidayListText);

          this.lstNoteEditRSSlist[i].DeterminationDateHolidayListText = this.holidayCalendarNamelist.find(x => x.HolidayMasterID == this.lstNoteEditRSSlist[i].DeterminationDateHolidayList).CalendarName
        } else {
          var filteredarray = this.holidayCalendarNamelist.filter(x => x.CalendarName == this.lstNoteEditRSSlist[i].DeterminationDateHolidayListText)

          if (filteredarray.length != 0) {
            this.lstNoteEditRSSlist[i].DeterminationDateHolidayList = Number(filteredarray[0].HolidayMasterID);
          }
        }

        this.lstNoteEditRSSlist[i].AccountID = this._note.AccountID
        this.lstNoteEditRSSlist[i].ModuleId = 14;
      }
    }

    if (this.lstNoteEditFEElist) {
      for (var i = 0; i < this.lstNoteEditFEElist.length; i++) {
        if (!(Number(this.lstNoteEditFEElist[i].ValueTypeText).toString() == "NaN" || Number(this.lstNoteEditFEElist[i].ValueTypeText) == 0)) {
          this.lstNoteEditFEElist[i].ValueTypeID = Number(this.lstNoteEditFEElist[i].ValueTypeText);
        }
        else {
          var filteredarray = this.lstPrepayAdditinalFee_ValueType.filter(x => x.Name == this.lstNoteEditFEElist[i].ValueTypeText)
          if (filteredarray.length != 0) {
            this.lstNoteEditFEElist[i].ValueTypeID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this.lstNoteEditFEElist[i].ApplyTrueUpFeatureText).toString() == "NaN" || Number(this.lstNoteEditFEElist[i].ApplyTrueUpFeatureText) == 0)) {
          this.lstNoteEditFEElist[i].ApplyTrueUpFeatureID = Number(this.lstNoteEditFEElist[i].ApplyTrueUpFeatureText);
        }
        else {

          var filteredarray1 = this.lstPrepayAdditinalFee_lstApplyTrueUpFeature.filter(x => x.Name == this.lstNoteEditFEElist[i].ApplyTrueUpFeatureText)
          if (filteredarray1.length != 0) {
            this.lstNoteEditFEElist[i].ApplyTrueUpFeatureID = Number(filteredarray1[0].LookupID);
          }
        }


        this.lstNoteEditFEElist[i].AccountID = this._note.AccountID
        this.lstNoteEditFEElist[i].ModuleId = 13;
      }
    }

    if (this.lstNoteEditPIKSchedulelist) {
      for (var i = 0; i < this.lstNoteEditPIKSchedulelist.length; i++) {
        if (!(Number(this.lstNoteEditPIKSchedulelist[i].PIKSetUpText).toString() == "NaN" || Number(this.lstNoteEditPIKSchedulelist[i].PIKSetUpText) == 0)) {
          this.lstNoteEditPIKSchedulelist[i].PIKSetUp = Number(this.lstNoteEditPIKSchedulelist[i].PIKSetUpText);
          this.lstNoteEditPIKSchedulelist[i].PIKSetUpText = this.lstPIKSetuptype.find(x => x.LookupID == this.lstNoteEditPIKSchedulelist[i].PIKSetUp).Name
        }
        else {
          var filteredarray = this.lstPIKSetuptype.filter(x => x.Name == this.lstNoteEditPIKSchedulelist[i].PIKSetUpText)
          if (filteredarray.length != 0) {
            this.lstNoteEditPIKSchedulelist[i].PIKSetUp = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this.lstNoteEditPIKSchedulelist[i].PIKIntCalcMethodIDText).toString() == "NaN" || Number(this.lstNoteEditPIKSchedulelist[i].PIKIntCalcMethodIDText) == 0)) {
          this.lstNoteEditPIKSchedulelist[i].PIKIntCalcMethodID = Number(this.lstNoteEditPIKSchedulelist[i].PIKIntCalcMethodIDText);
          this.lstNoteEditPIKSchedulelist[i].PIKIntCalcMethodIDText = this.lstPIKInterestCalcmethod.find(x => x.LookupID == this.lstNoteEditPIKSchedulelist[i].PIKIntCalcMethodID).Name
        } else {
          var filteredarray = this.lstPIKInterestCalcmethod.filter(x => x.Name == this.lstNoteEditPIKSchedulelist[i].PIKIntCalcMethodIDText)
          if (filteredarray.length != 0) {
            this.lstNoteEditPIKSchedulelist[i].PIKIntCalcMethodID = Number(filteredarray[0].LookupID);
          }
        }
        if (!(Number(this.lstNoteEditPIKSchedulelist[i].PIKReasonCodeIDtext).toString() == "NaN" || Number(this.lstNoteEditPIKSchedulelist[i].PIKReasonCodeIDtext) == 0)) {
          this.lstNoteEditPIKSchedulelist[i].PIKReasonCodeID = Number(this.lstNoteEditPIKSchedulelist[i].PIKReasonCodeIDtext);
          this.lstNoteEditPIKSchedulelist[i].PIKReasonCodeIDtext = this.lstPIKReasonCodetype.find(x => x.LookupID == this.lstNoteEditPIKSchedulelist[i].PIKReasonCodeID).Name
        } else {
          var filteredarray = this.lstPIKReasonCodetype.filter(x => x.Name == this.lstNoteEditPIKSchedulelist[i].PIKReasonCodeIDtext)
          if (filteredarray.length != 0) {
            this.lstNoteEditPIKSchedulelist[i].PIKReasonCodeID = Number(filteredarray[0].LookupID);
          }
        }

        this.lstNoteEditPIKSchedulelist[i].AccountID = this._note.AccountID
        this.lstNoteEditPIKSchedulelist[i].ModuleId = 12;
      }
    }

    if (this.lstNoteEditRSSlist) {
      for (var i = 0; i < this.lstNoteEditRSSlist.length; i++) {
        if (this.lstNoteEditRSSlist[i].EffectiveDate != null) {
          this.lstNoteEditRSSlist[i].EffectiveDate = this.convertDatetoGMT(this.lstNoteEditRSSlist[i].EffectiveDate);
        }
        if (this.lstNoteEditRSSlist[i].Date != null) {
          this.lstNoteEditRSSlist[i].Date = this.convertDatetoGMT(this.lstNoteEditRSSlist[i].Date);
        }
      }
    }
    if (this.lstNoteEditFEElist) {
      for (var i = 0; i < this.lstNoteEditFEElist.length; i++) {

        if (this.lstNoteEditFEElist[i].EffectiveDate != null) {
          this.lstNoteEditFEElist[i].EffectiveDate = this.convertDatetoGMT(this.lstNoteEditFEElist[i].EffectiveDate);
        }
        if (this.lstNoteEditFEElist[i].StartDate != null) {
          this.lstNoteEditFEElist[i].StartDate = this.convertDatetoGMT(this.lstNoteEditFEElist[i].StartDate);
        }

        if (this.lstNoteEditFEElist[i].ScheduleEndDate != null) {
          this.lstNoteEditFEElist[i].ScheduleEndDate = this.convertDatetoGMT(this.lstNoteEditFEElist[i].ScheduleEndDate);
        }
      }
    }
    if (this.lstNoteEditPIKSchedulelist) {
      for (var i = 0; i < this.lstNoteEditPIKSchedulelist.length; i++) {

        if (this.lstNoteEditPIKSchedulelist[i].EffectiveDate != null) {
          this.lstNoteEditPIKSchedulelist[i].EffectiveDate = this.convertDatetoGMT(this.lstNoteEditPIKSchedulelist[i].EffectiveDate);
        }
        if (this.lstNoteEditPIKSchedulelist[i].StartDate != null) {
          this.lstNoteEditPIKSchedulelist[i].StartDate = this.convertDatetoGMT(this.lstNoteEditPIKSchedulelist[i].StartDate);
        }

        if (this.lstNoteEditPIKSchedulelist[i].EndDate != null) {
          this.lstNoteEditPIKSchedulelist[i].EndDate = this.convertDatetoGMT(this.lstNoteEditPIKSchedulelist[i].EndDate);
        }

      }
    }
    //===========================================================

    //RSS
    if (this.RssFeePikModulename == "Rate Spread Schedule") {

      //Delete list append
      for (i = 0; i < this.deleteRateSpreadSchedulePopup.length; i++) {
        this.lstNoteEditRSSlist.push(this.deleteRateSpreadSchedulePopup[i]);
      }

      // Validation for New Effective Date RSS
      this.newEffectiveDates = this.lstNoteEditRSSlist
        .filter(item => !item.isdeleted)
        .map(item => {
          const date = new Date(item.EffectiveDate);
          return new Date(date.getFullYear(), date.getMonth(), date.getDate()).toString();
        });

      for (var i = 0; i < this.existingEffectiveDatesRSS.length; i++) {
        this.existingEffectiveDatesRSS[i] = new Date(this.existingEffectiveDatesRSS[i]).toString();
      }

      const invalidDates = this.newEffectiveDates.filter(newDate => !this.existingEffectiveDatesRSS.includes(newDate));

      if (invalidDates.length > 0) {
        this.CloseConfirmPopUp();
        this.CustomAlert("You cannot enter a new Effective Date.");
        return;
      }
      else {
        this._noteEditList.RateSpreadScheduleList = this.lstNoteEditRSSlist;
      }
    }

    //FEE
    if (this.RssFeePikModulename == "Fee Schedule") {

      if (this.deleteFeeSchedulePopup) {
        for (var i = 0; i < this.deleteFeeSchedulePopup.length; i++) {

          if (this.deleteFeeSchedulePopup[i].EffectiveDate != null) {
            this.deleteFeeSchedulePopup[i].EffectiveDate = this.convertDatetoGMT(this.deleteFeeSchedulePopup[i].EffectiveDate);
          }
          if (this.deleteFeeSchedulePopup[i].StartDate != null) {
            this.deleteFeeSchedulePopup[i].StartDate = this.convertDatetoGMT(this.deleteFeeSchedulePopup[i].StartDate);
          }

          if (this.deleteFeeSchedulePopup[i].ScheduleEndDate != null) {
            this.deleteFeeSchedulePopup[i].ScheduleEndDate = this.convertDatetoGMT(this.deleteFeeSchedulePopup[i].ScheduleEndDate);
          }
        }
      }

      //Delete list append
      for (i = 0; i < this.deleteFeeSchedulePopup.length; i++) {
        this.lstNoteEditFEElist.push(this.deleteFeeSchedulePopup[i]);
      }

      // Validation for New Effective Date FEE
      this.newEffectiveDates = this.lstNoteEditFEElist
        .filter(item => !item.isdeleted)
        .map(item => {
          const date = new Date(item.EffectiveDate);
          return new Date(date.getFullYear(), date.getMonth(), date.getDate()).toString();
        });

      for (var i = 0; i < this.existingEffectiveDatesFEE.length; i++) {
        this.existingEffectiveDatesFEE[i] = new Date(this.existingEffectiveDatesFEE[i]).toString();
      }

      const invalidDates = this.newEffectiveDates.filter(newDate => !this.existingEffectiveDatesFEE.includes(newDate));

      if (invalidDates.length > 0) {
        this.CloseConfirmPopUp();
        this.CustomAlert("You cannot enter a new Effective Date.");
        return;
      }
      else {
        this._noteEditList.NotePrepayAndAdditionalFeeScheduleList = this.lstNoteEditFEElist;
      }
    }

    //PIK
    if (this.RssFeePikModulename == "PIK Schedule") {

      if (this.deletePIKSchedulePopup) {
        for (var i = 0; i < this.deletePIKSchedulePopup.length; i++) {

          if (this.deletePIKSchedulePopup[i].EffectiveDate != null) {
            this.deletePIKSchedulePopup[i].EffectiveDate = this.convertDatetoGMT(this.deletePIKSchedulePopup[i].EffectiveDate);
          }
          if (this.deletePIKSchedulePopup[i].StartDate != null) {
            this.deletePIKSchedulePopup[i].StartDate = this.convertDatetoGMT(this.deletePIKSchedulePopup[i].StartDate);
          }

          if (this.deletePIKSchedulePopup[i].EndDate != null) {
            this.deletePIKSchedulePopup[i].EndDate = this.convertDatetoGMT(this.deletePIKSchedulePopup[i].EndDate);
          }

          this.deletePIKSchedulePopup[i].AccountID = this._note.AccountID
        }
      }

      //Delete list append
      for (i = 0; i < this.deletePIKSchedulePopup.length; i++) {
        this.lstNoteEditPIKSchedulelist.push(this.deletePIKSchedulePopup[i]);
      }

      // Validation for New Effective Date FEE
      this.newEffectiveDates = this.lstNoteEditPIKSchedulelist
        .filter(item => !item.isdeleted)
        .map(item => {
          const date = new Date(item.EffectiveDate);
          return new Date(date.getFullYear(), date.getMonth(), date.getDate()).toString();
        });

      for (var i = 0; i < this.existingEffectiveDatesPIK.length; i++) {
        this.existingEffectiveDatesPIK[i] = new Date(this.existingEffectiveDatesPIK[i]).toString();
      }

      const invalidDates = this.newEffectiveDates.filter(newDate => !this.existingEffectiveDatesPIK.includes(newDate));

      if (invalidDates.length > 0) {
        this.CloseConfirmPopUp();
        this.CustomAlert("You cannot enter a new Effective Date.");
        return;
      }
      else {
        this._noteEditList.NotePIKScheduleList = this.lstNoteEditPIKSchedulelist;
      }
    }

    this._noteEditList.NoteId = this._note.NoteId;
    this._noteEditList.EnableM61Calculations = this.EnableM61Calculations;

    this.noteService.UpdateNoteEditlistRSSFEEPIK(this._noteEditList).subscribe(res => {
      if (res.Succeeded) {
        this._isNoteSaving = false;
        this.CloseConfirmPopUp();
        this.ClosePopUpNoteRSS();
        this.ClosePopUpNoteFEE();
        this.ClosePopUpNotePIK();

        this._Showmessagenotediv = true;
        this._ShowmessagenotedivMsg = `${this.RssFeePikModulename} Updated Successfully`;
        setTimeout(function () {
          this._isNoteSaving = false;
          this._Showmessagenotediv = false;
          this._ShowmessagenotedivMsg = false;

          var returnUrl = this._router.url;
          if (window.location.href.indexOf("notedetail/a") > -1) {
            returnUrl = returnUrl.toString().replace('notedetail/a/', 'notedetail/');

          }
          else if (returnUrl.indexOf("notedetail/") > -1) {
            returnUrl = returnUrl.toString().replace('notedetail/', 'notedetail/a/');
          }
          this._router.navigate([returnUrl]);

        }.bind(this), 2000);

      }
      else {
        this._ShowmessagenotedivWar = true;
        this._isNoteSaving = false;
        this._ShowmessagenotedivMsgWar = "Error occurred while updating Note Additional , please contact to system administrator.";
        this.CloseConfirmPopUp();
        this.ClosePopUpNoteRSS();
        this.ClosePopUpNoteFEE();
        this.ClosePopUpNotePIK();

        setTimeout(function () {
          this._isNoteSaving = false;
          this._Showmessagenotediv = false;
          this._ShowmessagenotedivWar = false;
        }.bind(this), 5000);
      }
    })
  }

  Cancel(): void {
    this._router.navigate(['note']);
  }

  GetAllNoteLookups(): void {
    this.noteService.getAllLookupById().subscribe(res => {
      var data = res.lstLookups;

      this.lstRateSpreadSch_ValueType = data.filter(x => x.ParentID == "19");

      //this.lstPrepayAdditinalFee_ValueType = data.filter(x => x.ParentID == "20");

      this.lstStrippingSch_ValueType = data.filter(x => x.ParentID == "21");
      this.lstDefaultSch_ValueType = data.filter(x => x.ParentID == "22");
      this.lstFinancingFeeSch_ValueType = data.filter(x => x.ParentID == "23");
      this.lstFinancingSch_ValueType = data.filter(x => x.ParentID == "24");
      this.lstIntCalcMethodID = data.filter(x => x.ParentID == "25");
      //   this.lstPayFrequency = data.filter(x => x.ParentID == "28");
      this.lstLoanCurrency = data.filter(x => x.ParentID == "29");
      this.lstRoundingMethod = data.filter(x => x.ParentID == "33");
      this.lstTransactionType = data.filter(x => x.ParentID == "39");
      this.lstIndextype = data.filter(x => x.ParentID == "32");
      this.lstratingagency = data.filter(x => x.ParentID == "43");
      this.lstriskrating = data.filter(x => x.ParentID == "44");
      this.lstCashflowEngineID = data.filter(x => x.ParentID == "47");
      this.lstPurposeType = data.filter(x => x.ParentID == "50");
      this.lstServicerType = data.filter(x => x.ParentID == "62");
      this.lstNoteDeleteFilter = data.filter(x => x.ParentID == "66");
      this.lstFinancingSource = data.filter(x => x.ParentID == "71");
      this.lstDebtType = data.filter(x => x.ParentID == "72");
      this.lstCapStack = data.filter(x => x.ParentID == "73");
      this.lstPool = data.filter(x => x.ParentID == "74");
      this.lstPool.sort(this.sortByPoolName);

      this.lstPrepayAdditinalFee_ValueType = this.lstFeeTypeLookUp;
      this.lstPrepayAdditinalFee_lstApplyTrueUpFeature = data.filter(x => x.ParentID == "95");

      this.lstCalculationMode = data.filter(x => x.ParentID == "79");
      this.lstScenario = window.localStorage.getItem("lstScenario");
      this.lstInterestCalculationRuleForPaydowns = data.filter(x => x.ParentID == "99");
      this.lstInterestCalculationRuleForPaydownsAmort = data.filter(x => x.ParentID == "99");
      this.lstAccrualPeriodType = data.filter(x => x.ParentID == "136");
      this.lstAccrualPeriodBusinessDayAdj = data.filter(x => x.ParentID == "137");
      // this.lstddlOverideComment = data.filter(x => x.ParentID == "108");
      //this.lstRoundingNote = data.filter(x => x.ParentID == "95");
      this.lstStrategy = data.filter(x => x.ParentID == "110");
      this.lstAdjustmentType = data.filter(x => x.ParentID == "141");
      if (this._note.EnableM61Calculations == 3) {
        this.lstNoteDeleteFilter = this.lstNoteDeleteFilter.filter(x => x.LookupID != "685");
      }

      this.lstPIKInterestCalcmethod = data.filter(x => x.ParentID == "25");
      this.lstPIKSetuptype = data.filter(x => x.ParentID == "146");
      this.lstPIKReasonCodetype = data.filter(x => x.ParentID == "111");
      this.lstPIKCompoundingType = data.filter(x => x.ParentID == "2");
      this.lstPIKCashIntCalc = data.filter(x => x.ParentID == "2");
      this.lstPIKImpactinCommit = data.filter(x => x.ParentID == "2");

      setTimeout(() => {
        this._bindGridDropdows();
      }, 10000);

    });
  }

  getAllfinancingWarehouse(): void {
    this.noteService.GetAllFinancingWarehouse(this._pageIndex, this._pageSize).subscribe(res => {
      if (res.Succeeded) {
        this.lstfinancingwhouse = res.lstFinancingWarehouseDataContract;
      }
    });
  }

  getLiborScheduleData(): void {
    this._isNoteSaving = true;
    this.noteService.getLiborScheduleDataByNoteId(this._note, this._pageIndex, this._pageSize).subscribe(res => {
      if (res.Succeeded) {
        this.lstLiborSchedule = res.lstLiborScheduledata;
        this._noteext.ListLiborScheduleTab = this.lstLiborSchedule;
        this.ConvertToBindableDate(this._noteext.ListLiborScheduleTab, "LIBORSchedule", "en-US");
        // alert('LiborSchedule ' +JSON.stringify(this._noteext.ListLiborScheduleTab));
        this.showlaborflex();

        this._isNoteSaving = false;
      }
    });
  }

  showindexgrid() {
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
  }

  getViewHistory(modulename): void {
    this._note.pagesIndex = 10;
    this._note.pagesSize = 10;
    this._note.modulename = modulename;

    localStorage.setItem('NoteObj', JSON.stringify(this._note));

    // this._router.navigate([this.routes.periodicData.name]);
  }

  getNoteexceptions(objectid): void {
    try {
      this.noteService.GetNoteExceptions(objectid).subscribe(res => {
        if (res.Succeeded) {
          var data = res.Allexceptionslist;
          this._ExceptionListCount = data.length;
          //remove first cell selection
          // this.flexnoteexceptions.selectionMode = wijmo.grid.SelectionMode.None;
          if (data.length == 0) {
            this._ExceptionListCount = 0;
            this._CritialExceptionListCount = 0;
            this._showexceptionEmptymessage = true;
          }
          else {
            this.lstnotesexceptions = data;
            this._showexceptionEmptymessage = false;
            // this._showexceptionEmptydiv = true;
            // this.showflexnoteexceptionsflex();
            //var count = 0;
            var total_critical = data.filter(x => x.ActionLevelText == "Critical");
            var total_normal = data.filter(x => x.ActionLevelText == "Normal");

            var gaapcheck = data.filter(x => x.FieldName == "GAAP Component");
            var amortcheck = data.filter(x => x.FieldName == "Amort Fee Check" || x.FieldName == "Amort Discount Premium Check" || x.FieldName == "Amort Cap Cost Check");

            if (gaapcheck.length > 0) {
              this._showgaapcheck = true;
            }
            if (amortcheck.length > 0) {
              this._showamortcheck = true;
            }
            if (total_critical.length > 0) {
              this.exceptionscount_critical = total_critical.length;
            }
            if (total_normal.length > 0) {
              this.exceptionscount_normal = total_normal.length;
            }

            //fetch "Critical" error count
            this._CritialExceptionListCount = data.filter(x => x.ActionLevelText == "Critical").length;
          }
        }
      });
    } catch (err) {
      alert(err)
    }
  }
  getNotActivity(): void {
    try {

      if (!this.IsOpenActivityTab) {
        this.activityMessage = '';
        this._isNoteSaving = true;
        setTimeout(() => {
          var d = new Date();
          var datestring = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate() + " " +
            d.getHours() + ":" + d.getMinutes();

          this._activityLog.ModuleID = this._note.NoteId;
          this._activityLog.ModuleTypeID = 182;
          this._activityLog.Currentdate = datestring;


          this.noteService.getActivityLogByModuleId(this._activityLog, this._pageIndexActivity, this._pageSizeActivity).subscribe(res => {
            if (res.Succeeded) {
              this.lstActivityLog = res.lstActivityLog;
              this.currentactivity = res.lstActivityLog;
              this._totalCountActivity = res.TotalCount;

              var tdate = new Date().toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" })

              var yd = new Date(); yd.setDate(yd.getDate() - 1);

              var ydate = new Date(yd.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" })
              if (this._pageIndexActivity == 1) {
                this.arrActivityToday = res.lstActivityLog.filter(x => new Date(x.CreatedDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" }) == tdate)
                this.arrActivityYesterday = res.lstActivityLog.filter(x => new Date(x.CreatedDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" }) == ydate)
              }
              else {
                this.arrActivityTodayMore = res.lstActivityLog.filter(x => new Date(x.CreatedDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" }) == tdate)
                this.arrActivityTodayMore = this.arrActivityTodayMore.filter(val => !this.arrActivityToday.includes(val));

                this.arrActivityYesterdayMore = res.lstActivityLog.filter(x => new Date(x.CreatedDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" }) == ydate)
                this.arrActivityYesterdayMore = this.arrActivityYesterdayMore.filter(val => !this.arrActivityYesterday.includes(val));
              }
              this.arrActivityToday = this.arrActivityToday.concat(this.arrActivityTodayMore);
              this.arrActivityYesterday = this.arrActivityYesterday.concat(this.arrActivityYesterdayMore);
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


              this.CurrentcountActivity = this.CurrentcountActivity + this.currentactivity.length;
              if (this.lstActivityLog.length == 0) {
                this.activityMessage = "No activities found";
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


                this.currentactivity = this.currentactivity.filter(x => new Date(x.CreatedDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" }) != tdate)
                this.currentactivity = this.currentactivity.filter(x => new Date(x.CreatedDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" }) != ydate)
                this.arrActivity = this.arrActivity.concat(this.currentactivity);

                if (this.arrActivityToday.length > 0) {
                  this.isActivityTday = true;
                }
                if (this.arrActivityYesterday.length > 0) {
                  this.isActivityYday = true;
                }
                if (this.arrActivity.length > 0) {
                  this.isActivityPday = true;
                }
              }
              this._isNoteSaving = false;

            }
            else {
              this._router.navigate(['login']);
            }
          });
          this.IsOpenActivityTab = true;
        }, 200);
      }
      this.setFocus();

    } catch (err) {
      this._isNoteSaving = false;
    }
  }

  onScrollActivity() {
    //For paginging ----uncomment below code

    var myDiv = $('#activityMainDiv');

    if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {

      if (this.CurrentcountActivity < this._totalCountActivity) {

        this._pageIndexActivity = this._pageIndexActivity + 1;
        this.IsOpenActivityTab = false;
        this.getNotActivity();

      }
    }

  }


  showflexnoteexceptionsflex() {
    if (!this.IsOpenExceptionTab) {
      setTimeout(() => {
        if (this.flexnoteexceptions) {
          this.flexnoteexceptions.invalidate(true);

          this.flexnoteexceptions.autoSizeColumns();
        }
      }, 200);
    }
  }

  showDialog(modulename) {
    this._note.modulename = modulename;
    this.getPeriodicDataByNoteId(this._note);
  }

  showCopyDialog(noteid) {
    this._isNoteSaving = false;
    var modalcopy = document.getElementById('myModalCopyNote');
    this._note.CopyName = null;
    this._note.CopyCRENoteId = null;
    this.Copy_Dealid = this._note.DealID;
    this.Copy_DealName = this._note.DealName;
    this._dealNoExistMsg = null;
    modalcopy.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }

  showDeleteDialog(deleteRowIndex: number, moduleName: string) {
    this.deleteRowIndex = deleteRowIndex;
    this.modulename = moduleName;
    var modalDelete = document.getElementById('myModalDelete');

    modalDelete.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }

  showDialogDeleteOption() {

    if (this._moduledelete.LookupID == 0) {
      this.CustomAlert('Please select a delete option');
    }
    else {


      var customdialogbox = document.getElementById('customdialogbox');
      this._moduledelete.ModuleID = this._note.NoteId;
      this._moduledelete.ModuleName = 'Note';
      var LookupName = this.lstNoteDeleteFilter.filter(x => x.LookupID == this._moduledelete.LookupID)[0].Name;

      this._MsgText = 'Are you sure you want to ' + LookupName.toLowerCase() + ' for Note ' + '{' + this._note.CRENoteID + '}?';
      customdialogbox.style.display = "block";
      $.getScript("/js/jsDrag.js");
    }
  }

  deleteModuleByID(): void {
    this._isDeleteOPtionOk = true;

    this.dealSrv.deleteModuleByID(this._moduledelete)
      .subscribe(res => {
        if (res.Succeeded) {
          localStorage.setItem('divSucessNote', JSON.stringify(true));
          //localStorage.setItem('divSucessMsgNote', JSON.stringify('Record deleted successfully'));
          localStorage.setItem('divSucessMsgNote', JSON.stringify(this.deleteoptiontext + ' for note ' + this._note.CRENoteID + ' deleted successfully'));

          localStorage.setItem('divInfoNote', JSON.stringify(false));
          localStorage.setItem('divWarNote', JSON.stringify(false));

          this._router.navigate(['note']);

        }
        else {
          this.utilityService.navigateToSignIn();
        }
      },
        error => console.error('Error: ' + error)
      );
  }

  CreateNote(CRENoteID, Name, creDeal, Isopen) {
    this._isNoteSaving = false;

    if (CRENoteID != null && Name != null && this.Copy_Dealid != null) {
      this._note.CopyCRENoteId = CRENoteID;
      this._note.CopyName = Name;

      //   this._note.NoteId = '00000000-0000-0000-0000-000000000000';
      this._note.CopyDealID = this.Copy_Dealid;
      this._note.CopyDealName = this.Copy_DealName;

      this.noteService.checkduplicatenote(this._note).subscribe(res => {
        if (res.Succeeded == true) {
          this._noteExistMsg = res.Message;
          setTimeout(() => {
            this._noteExistMsg = "";
            this._isNoteSaving = false;
          }, 5000);
        }
        else {
          if (this._note.CopyDealID != null) {
            this._isCopyonly = true;

            this._dealNoExistMsg = null;
            this._isCopyandopen = Isopen;
            this._noteCopyMsg = 'Note copied successfully.'
            this.CopyNote(this._note);
            // this.SaveNotefunc(this._note, 'Copy');
            //  this._isNoteSaving = false;
          }
          else {
            this._dealNoExistMsg = "Please Select Deal";
            setTimeout(function () {
              this._noteCopyMsg = null;
            }.bind(this), 1000);
          }

          setTimeout(function () {
            this._noteExistMsg = "";
            this._dealNoExistMsg = null;
          }.bind(this), 1000);
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
  }

  CopyNote(note): any {
    var duplicatedNoteMessage = "";
    this.noteService.CopyNote(note).subscribe(res => {
      if (res.Succeeded) {
        // duplicatedNoteMessage = res.Succeeded;
        this._noteCopyMsg = res.Message;
        var newcopyNoteid = res.newNoteID;
        if (this._noteCopyMsg != null) {

          localStorage.setItem('divInfoNote', JSON.stringify(false));
          this._copymessagediv = true;
          this._copymessagedivMsg = this._noteCopyMsg;

          this._copymessagediv = true;
          this._copymessagedivMsg = this._noteCopyMsg;
          if (this._isCopyandopen == true) {
            var notenewcopied;//= ['notedetail', this._noteextt.NoteId];
            if (window.location.href.indexOf("notedetail/a") > -1) {
              notenewcopied = ['notedetail', newcopyNoteid]
            }
            else {
              notenewcopied = ['notedetail/a', newcopyNoteid]
            }

            this._router.navigate(notenewcopied);
          }
          this.CloseCopyPopUp();


          setTimeout(() => {

            this._copymessagediv = false;
            this._noteCopyMsg = null;
            this._isCopyonly = false;
            this._Showmessagenotediv = false;
            this._ShowmessagenotedivWar = false;
          }, 2000);
        }
      }
      else {
        this._ShowmessagenotedivWar = true;
        this.CloseCopyPopUp();
        this._ShowmessagenotedivMsgWar = "Error occurred while creating Copy Note, please contact to system administrator.";

        //setTimeout(function () {
        //    this._ShowmessagenotedivWar = false;
        //}.bind(this), 5000);
      }
    });
    return this._noteExistMsg;
  }

  CreateOpenNote(CRENoteID, Name) {
    this._isNoteSaving = true;
    if (CRENoteID != null && Name != null && this.Copy_Dealid != null) {
      this._note.CopyCRENoteId = CRENoteID;
      this._note.CopyName = Name;
      this._note.CopyDealID = this.Copy_Dealid;
      this._note.CopyDealName = this.Copy_DealName;
      //  this._note.NoteId = '00000000-0000-0000-0000-000000000000';
      this.noteService.checkduplicatenote(this._note).subscribe(res => {
        if (res.Succeeded == true) {
          this._noteExistMsg = res.Message;
          setTimeout(() => {
            this._noteExistMsg = "";
            this._isNoteSaving = false;
          }, 5000);
        }
        else {
          if (this._dealNoExistMsg == null) {
            this._isCopyandopen = true;
            this._dealNoExistMsg = null;
            this._isCopyonly = true;
            this._noteCopyMsg = 'Note copied successfully.'
            this.CopyNote(this._note);
            //   this.SaveNotefunc(this._note, 'Copy');
            this._isNoteSaving = false;
          }
          else {
            this._noteCopyMsg = null;
            setTimeout(() => {
              this._dealNoExistMsg = "Please Select Deal";
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
  }

  CheckDuplicateNote(note): any {
    var duplicatedNoteMessage = "";
    this.noteService.checkduplicatenote(note).subscribe(res => {
      if (res.Succeeded) {
        duplicatedNoteMessage = res.Succeeded;
        this._noteExistMsg = res.Message;
      }
    });
    return this._noteExistMsg;
  }

  ClosePopUp() {
    var modal = document.getElementById('myModal');
    this._isNoteSaving = false;
    $('#txtNoteJsonResponse').val('');
    this._isCalcJsonResponseFetched = false;
    modal.style.display = "none";
  }

  ClosePopUpNoteRSS() {
    var modal = document.getElementById('myModalEditNoteRSS');
    modal.style.display = "none";
  }
  ClosePopUpNoteFEE() {
    var modal = document.getElementById('myModalEditNoteFEE');
    modal.style.display = "none";
  }
  ClosePopUpNotePIK() {
    var modal = document.getElementById('myModalEditNotePIK');
    modal.style.display = "none";
  }

  ClosePopUpScriptEngine() {
    var modal = document.getElementById('myModalScriptEngine');
    this._isNoteSaving = false;
    $('#txtNoteJsonResponseForScriptEngine').val('');
    this._isCalcJsonResponseFetched = false;
    modal.style.display = "none";
  }

  CloseDeletePopUp() {
    var modal = document.getElementById('myModalDelete');
    modal.style.display = "none";
  }
  CloseCopyPopUp() {
    this._isNoteSaving = false;
    //  this._isNoteSaving = true;
    this._note.CopyName = null;
    this._note.CRENewNoteID = null;
    this.Copy_Dealid = null;
    this.Copy_DealName = null;
    this._note.NewNoteName = null;

    var copymodal = document.getElementById('myModalCopyNote');
    copymodal.style.display = "none";
  }
  ClosePopUpDeleteOption() {
    var modal = document.getElementById('customdialogbox');
    modal.style.display = "none";
  }

  ShowPopUpArchive(docid, docname): void {

    this._uploadedDocumentLogID = docid;
    this._MsgText = 'Are you sure you want to archive ' + docname + '?';
    var modal = document.getElementById('customdialogarchive');
    modal.style.display = "block";
  }
  ClosePopUpArchive() {
    var modal = document.getElementById('customdialogarchive');
    modal.style.display = "none";
  }

  CloseContextMenuDialog() {
    var modal = document.getElementById('ContextMenudialogbox');
    modal.style.display = "none";
  }
  checkDropDownChangedsource(sender: wjNg2Input.WjAutoComplete, args) {
    var ac = sender;
    if (ac.selectedIndex > -1) {
      this.SourceAccountID = ac.selectedValue;
      this.PIKSchedule_SourceAccount = ac.selectedItem.Valuekey;
    }
  }

  checkDropDownChangedtarget(sender: wjNg2Input.WjAutoComplete, args) {
    var ac = sender;
    if (ac.selectedIndex > -1) {
      this.TargetAccountID = ac.selectedValue;
      this.PIKSchedule_TargetAccount = ac.selectedItem.Valuekey;
    }
  }

  private _cache = {};
  getAutosuggestpikaccount = this.getAutosuggestpikFunc.bind(this);
  getAutosuggestpikFunc(query, max, callback) {
    var self = this,
      result = self._cache[query];
    if (result) {
      callback(result);
      return;
    }

    // not in cache, get from server
    var params = { query: query, max: max };
    this._searchObj = new Search(query);

    this.searchService.getAutosuggestPIKAcccount(this._searchObj, this._pageIndexSearch, this._pageSizeSearch).subscribe(res => {
      if (res.Succeeded) {
        var data: any = res.lstSearch;
        this._totalCountSearch = res.TotalCount;
        this._result = data;

        //show message for 1 sec. when no record found
        if (this._result.length == 0) {
          setTimeout(() => {
          }, 1000);
        }

        // add 'DisplayName' property to result
        let items = [];
        for (var i = 0; i < this._result.length; i++) {
          var c = this._result[i];
          c.DisplayName = c.Valuekey;
        }

        // store result in cache
        self._cache[query] = this._result;

        // this._isSearchDataFetching = false;
        // and return the result
        callback(this._result);
      }
    });
    error => console.error('Error: ' + error)
  }
  TObject: any;

  ////////// Dropdown ///////////////////

  // apply/remove data maps
  private _bindGridDropdows() {
    var flexrss = this.flexrss;
    var flexPrepay = this.flexPrepay;
    var flexstripping = this.flexstripping;
    var flexfinancingfee = this.flexfinancingfee;
    var flexFinancingSch = this.flexFinancingSch;
    var flexdefaultsch = this.flexdefaultsch;
    var flexservicelog = this.flexservicelog;
    var futurefundingflex = this.futurefundingflex;
    var flexEditRSS = this.flexEditRSS;
    var flexEditFee = this.flexEditFee;
    var flexEditPIK = this.flexEditPIK;

    if (flexrss) {
      var colrssValueType = flexrss.columns.getColumn('ValueTypeText');
      var colrssIntCalcMethod = flexrss.columns.getColumn('IntCalcMethodText');
      var colrssIndexNameText = flexrss.columns.getColumn('IndexNameText');
      var colrssDeterminationDateHolidayListText = flexrss.columns.getColumn('DeterminationDateHolidayListText');


      if (colrssValueType) {
        //colrssValueType.showDropDown = true;
        colrssValueType.dataMap = this._buildDataMap(this.lstRateSpreadSch_ValueType, 'LookupID', 'Name');

        this.dataMapValueType = this._buildDataMap(this.lstRateSpreadSch_ValueType, 'LookupID', 'Name');
        //colrssIntCalcMethod.showDropDown = true;
        colrssIntCalcMethod.dataMap = this._buildDataMap(this.lstIntCalcMethodID, 'LookupID', 'Name');


        // colrssIndexNameText.showDropDown = true;
        colrssIndexNameText.dataMap = this._buildDataMap(this.lstIndextype, 'LookupID', 'Name');
        colrssDeterminationDateHolidayListText.dataMap = this._buildDataMap_holidayCalendarNamelist(this.holidayCalendarNamelist);
      }
    }

    if (flexPrepay) {
      var colPrepayValueType = flexPrepay.columns.getColumn('ValueTypeText');
      if (colPrepayValueType) {
        //colPrepayValueType.showDropDown = true;
        colPrepayValueType.dataMap = this._buildDataMap(this.lstPrepayAdditinalFee_ValueType, 'LookupID', 'Name');
      }

      var colPrepayApplyTrueUpFeatureText = flexPrepay.columns.getColumn('ApplyTrueUpFeatureText');
      if (colPrepayApplyTrueUpFeatureText) {
        //colPrepayApplyTrueUpFeatureText.showDropDown = true;
        colPrepayApplyTrueUpFeatureText.dataMap = this._buildDataMap(this.lstPrepayAdditinalFee_lstApplyTrueUpFeature, 'LookupID', 'Name');
      }

    }

    if (flexEditRSS) {
      var colrssValueType = flexEditRSS.columns.getColumn('ValueTypeText');
      var colrssIntCalcMethod = flexEditRSS.columns.getColumn('IntCalcMethodText');
      var colrssIndexNameText = flexEditRSS.columns.getColumn('IndexNameText');
      var colrssDeterminationDateHolidayListText = flexEditRSS.columns.getColumn('DeterminationDateHolidayListText');

      if (colrssValueType) {
        //colrssValueType.showDropDown = true;
        colrssValueType.dataMap = this._buildDataMap(this.lstRateSpreadSch_ValueType, 'LookupID', 'Name');

        this.dataMapValueType = this._buildDataMap(this.lstRateSpreadSch_ValueType, 'LookupID', 'Name');
        //colrssIntCalcMethod.showDropDown = true;
        colrssIntCalcMethod.dataMap = this._buildDataMap(this.lstIntCalcMethodID, 'LookupID', 'Name');


        // colrssIndexNameText.showDropDown = true;
        colrssIndexNameText.dataMap = this._buildDataMap(this.lstIndextype, 'LookupID', 'Name');
        colrssDeterminationDateHolidayListText.dataMap = this._buildDataMap_holidayCalendarNamelist(this.holidayCalendarNamelist);
      }
    }

    if (flexEditFee) {
      var colPrepayValueType = flexEditFee.columns.getColumn('ValueTypeText');
      if (colPrepayValueType) {
        //colPrepayValueType.showDropDown = true;
        colPrepayValueType.dataMap = this._buildDataMap(this.lstPrepayAdditinalFee_ValueType, 'LookupID', 'Name');
      }

      var colPrepayApplyTrueUpFeatureText = flexEditFee.columns.getColumn('ApplyTrueUpFeatureText');
      if (colPrepayApplyTrueUpFeatureText) {
        //colPrepayApplyTrueUpFeatureText.showDropDown = true;
        colPrepayApplyTrueUpFeatureText.dataMap = this._buildDataMap(this.lstPrepayAdditinalFee_lstApplyTrueUpFeature, 'LookupID', 'Name');
      }

    }

    if (flexEditPIK) {
      var colPikIntCalcMethod = flexEditPIK.columns.getColumn('PIKIntCalcMethodIDText');
      if (colPikIntCalcMethod) {
        colPikIntCalcMethod.dataMap = this._buildDataMap(this.lstPIKInterestCalcmethod, 'LookupID', 'Name');
      }

      var colPikSetup = flexEditPIK.columns.getColumn('PIKSetUpText');
      if (colPikSetup) {
        colPikSetup.dataMap = this._buildDataMap(this.lstPIKSetuptype, 'LookupID', 'Name');
      }

      var colPikReasonCode = flexEditPIK.columns.getColumn('PIKReasonCodeIDtext');
      if (colPikReasonCode) {
        colPikReasonCode.dataMap = this._buildDataMap(this.lstPIKReasonCodetype, 'LookupID', 'Name');
      }

      var colPIKSeparateCompounding = flexEditPIK.columns.getColumn('PIKSeparateCompounding');
      if (colPIKSeparateCompounding) {
        colPIKSeparateCompounding.dataMap = this._buildDataMap(this.lstPIKCompoundingType, 'LookupID', 'Name');
      }

      var colPIKCashIntCalc = flexEditPIK.columns.getColumn('PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate');
      if (colPIKCashIntCalc) {
        colPIKCashIntCalc.dataMap = this._buildDataMap(this.lstPIKCashIntCalc, 'LookupID', 'Name');
      }

      var colImpactCommitmentCalc = flexEditPIK.columns.getColumn('ImpactCommitmentCalc');
      if (colImpactCommitmentCalc) {
        colImpactCommitmentCalc.dataMap = this._buildDataMap(this.lstPIKImpactinCommit, 'LookupID', 'Name');
      }
    }

    if (flexstripping) {
      var colstrippingValueType = flexstripping.columns.getColumn('ValueTypeText');
      if (colstrippingValueType) {
        //colstrippingValueType.showDropDown = true;
        colstrippingValueType.dataMap = this._buildDataMap(this.lstStrippingSch_ValueType, 'LookupID', 'Name');
      }
    }
    if (flexfinancingfee) {
      var colfinancingfeeValueType = flexfinancingfee.columns.getColumn('ValueTypeText');
      if (colfinancingfeeValueType) {
        //colfinancingfeeValueType.showDropDown = true;
        colfinancingfeeValueType.dataMap = this._buildDataMap(this.lstFinancingFeeSch_ValueType, 'LookupID', 'Name');
      }
    }
    if (flexFinancingSch) {
      var colFinancingSchValueType = flexFinancingSch.columns.getColumn('ValueTypeText');
      var colFinancingSchIntCalcMethod = flexFinancingSch.columns.getColumn('IntCalcMethodText');
      var colFinancingSchCurrencyCode = flexFinancingSch.columns.getColumn('CurrencyCodeText');
      var colFinancingSchIndextype = flexFinancingSch.columns.getColumn('IndexTypeText');
      if (colFinancingSchValueType) {
        //colFinancingSchValueType.showDropDown = true;
        colFinancingSchValueType.dataMap = this._buildDataMap(this.lstFinancingSch_ValueType, 'LookupID', 'Name');
      }
      if (colFinancingSchIntCalcMethod) {
        //colFinancingSchIntCalcMethod.showDropDown = true;
        colFinancingSchIntCalcMethod.dataMap = this._buildDataMap(this.lstIntCalcMethodID, 'LookupID', 'Name');
      }
      if (colFinancingSchCurrencyCode) {
        //colFinancingSchCurrencyCode.showDropDown = true;
        colFinancingSchCurrencyCode.dataMap = this._buildDataMap(this.lstLoanCurrency, 'LookupID', 'Name');
      }
      if (colFinancingSchIndextype) {
        //colFinancingSchIndextype.showDropDown = true;
        colFinancingSchIndextype.dataMap = this._buildDataMap(this.lstIndextype, 'LookupID', 'Name');
      }
    }

    if (flexdefaultsch) {
      var coldefaultschValueType = flexdefaultsch.columns.getColumn('ValueTypeText');
      if (coldefaultschValueType) {
        //coldefaultschValueType.showDropDown = true;
        coldefaultschValueType.dataMap = this._buildDataMap(this.lstDefaultSch_ValueType, 'LookupID', 'Name');
      }
    }

    if (futurefundingflex) {
      var colfuturefundingflexType = futurefundingflex.columns.getColumn('PurposeText');
      if (colfuturefundingflexType) {
        //colfuturefundingflexType.showDropDown = true;
        colfuturefundingflexType.dataMap = this._buildDataMap(this.lstPurposeType, 'LookupID', 'Name');
      }
    }

    if (flexservicelog) {
      var colservicelogTransactionType = flexservicelog.columns.getColumn('TransactionTypeText');
      if (colservicelogTransactionType) {
        //colservicelogTransactionType.showDropDown = true;
        // colservicelogTransactionType.dataMap.displayMemberPath = 'TransactionName';
        colservicelogTransactionType.dataMap = this._buildDataMapTransaction(this.listtransactiontype);

      }

      //var colOverReas = flexservicelog.columns.getColumn('OverrideReasonText');
      //if (colOverReas) {
      //    colOverReas.showDropDown = true;
      //    colOverReas.dataMap = this._buildDataMap(this.lstddlOverideComment);
      //}
    }
  }

  // build a data map from a string array using the indices as keys
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

  private _buildDataMap_holidayCalendarNamelist(items): wjcGrid.DataMap {
    var map = [];
    if (items) {
      for (var i = 0; i < items.length; i++) {
        var obj = items[i];
        map.push({ key: obj['HolidayMasterID'], value: obj['CalendarName'] });
      }
    }
    return new wjcGrid.DataMap(map, 'key', 'value');
  }

  private _buildDataMapTransaction(items): wjcGrid.DataMap {
    var map = [];
    if (items) {
      for (var i = 0; i < items.length; i++) {
        var obj = items[i];
        map.push({ key: obj['TransactionTypesID'], value: obj['TransactionName'] });
      }
    }
    return new wjcGrid.DataMap(map, 'key', 'value');
  }

  rssselectionChanged() {
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
  }

  PrepayselectionChanged() {
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
  }

  strippingselectionChanged() {
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
  }
  financingfeeselectionChanged() {
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
  }

  financingSchselectionChanged() {
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
  }

  defaultschselectionChanged() {
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
  }

  servicelogselectionChanged() {
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

  }

  futurefundingselectionChanged() {
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
  }

  PIKfromPIKSourceNoteTabselectionChanged() {
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
  }

  LiborScheduleTabSelectionChanged() {
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
  }

  FixedAmortselectionChanged() {
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
  }

  FeeCouponStripReceivableTabselectionChanged() {
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
  }

  showfuturefundingflex() {
    if (!this.IsOpenshowfuturefundingflex) {
      this._isCallConcurrentCheck = true;
      setTimeout(() => {
        this.futurefundingflex.invalidate();
        //this.futurefundingflex.autoSizeColumns(0, this.futurefundingflex.columns.length, false, 20);
        //this.futurefundingflex.columns[0].width = 120; // for Note Id
        this.IsOpenshowfuturefundingflex = true;
        this.AppliedReadOnly();
      }, 200);
    }
    this.setFocus();

    setTimeout(function () {
      $('#futurefundingflex .wj-colfooters').parent().css('top', '94%');
      $('#futurefundingflex .wj-bottomleft').parent().css('top', '94%');
    }, 500);
  }

  showfixedamortflex() {
    if (!this.IsOpenshowfixedamortflex) {
      setTimeout(() => {
        this.fixedamortflex.invalidate();
        this.IsOpenshowfixedamortflex = true;
      }, 200);
    }
    this.setFocus();

    setTimeout(function () {
      $('#fixedamortflex .wj-colfooters').parent().css('top', '94%');
      $('#fixedamortflex .wj-bottomleft').parent().css('top', '94%');
    }, 500);
  }

  showlaborflex() {
    setTimeout(() => {
      this.laborflex.invalidate();
    }, 1000);
  }

  showfeecouponflex() {
    if (!this.IsOpenshowfeecouponflex) {
      setTimeout(() => {
        this.feecouponflex.invalidate();
        this.IsOpenshowfeecouponflex = true;
      }, 200);
    }
    this.setFocus();

    setTimeout(function () {
      $('#feecouponflex .wj-colfooters').parent().css('top', '94%');
      $('#feecouponflex .wj-bottomleft').parent().css('top', '94%');
    }, 500);
  }
  showpikflex() {
    if (!this.IsOpenshowpikflex) {
      setTimeout(() => {
        this.pikflex.invalidate();
        this.IsOpenshowpikflex = true;
      }, 200);
    }
    this.setFocus();

    //For Grid footer Issue.

    setTimeout(function () {
      $('#pikflex .wj-colfooters').parent().css('top', '94%');
      $('#pikflex .wj-bottomleft').parent().css('top', '94%');
    }, 500);
  }

  showperiodicoutputflex(btnClick) {
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
          this.ScenarioId = this._lstScenario.find(x => x.ScenarioName == "Default").AnalysisID;
        }
        else {
          this.SelectedScenarioId = this.ScenarioId;
        }
      }

      this._note.AnalysisID = this.ScenarioId;
      this._devDashBoard.NoteID = this._note.NoteId;
      this._devDashBoard.ScenarioID = this.ScenarioId;
      this._devDashBoard.UserID = this._user.UserID;
      this.noteService.getnotecalcinfobynoteId(this._devDashBoard).subscribe(res => {
        if (res.Succeeded) {
          var data = res.dwstatus;
          if (data != null) {
            this._islastCalcDateTime = true;
            if (data.CalcStatus == "Completed") {
              this._note.lastCalcDateTime = data.LastUpdated;
              this._note.CalculationStatus = data.CalcStatus;
              this._note.CalcEngineTypeText = data.CalcEngineTypeText;
              this._note.ErrorMessage = data.ErrorMessage;
              this._note.AccountingCloseDate = data.AccountingCloseDate;
            }
            else {
              this.showcalcstatus();
            }
          }
          else {
            this._note.CalculationStatus = "";
            this._note.CalcEngineTypeText = "";
          }
        }
      });

      if (btnClick == 'ShowTransactionGrid') {
        this.IsbtnClickText = "ShowTransactionGrid";
        this.getTransactionEntryByNoteId(this._note);
        this._isnoteperiodiccalcFetched = false;
        this._isTransactionEntryFetched = true;
      } else {
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

        if (this.lstTransactionEntry) { } else {
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
  }

  showcalcstatus() {
    if (this.ScenarioId === undefined || this.ScenarioId === null) {
      this.ScenarioId = this._lstScenario.find(x => x.ScenarioName == "Default").AnalysisID;
    }
    this._devDashBoard.NoteID = this._note.NoteId;
    this._devDashBoard.ScenarioID = this.ScenarioId;
    this._devDashBoard.UserID = this._user.UserID;

    var status = setInterval(() => {
      this.noteService.getnotecalcinfobynoteId(this._devDashBoard).subscribe(res => {
        if (res.Succeeded) {
          var data = res.dwstatus;
          if (!(data.CalcStatus == "Completed")) {
            this._note.lastCalcDateTime = data.LastUpdated;
            this._note.CalculationStatus = data.CalcStatus;
            this._note.ErrorMessage = data.ErrorMessage;
            this._note.AccountingCloseDate = data.AccountingCloseDate;
          }
          else {
            this.ShowTransaction();
            clearInterval(status);
            this._note.lastCalcDateTime = data.LastUpdated;
            this._note.AccountingCloseDate = data.AccountingCloseDate;
            this._note.CalculationStatus = data.CalcStatus;
            this._note.ErrorMessage = data.ErrorMessage;
          }
          if (data.CalcStatus === undefined || data.CalcStatus == null || data.CalcStatus == '') {
            this._note.CalculationStatus = "Nevercalculated";
            this._note.ErrorMessage = "";
            clearInterval(status);
          }
        }

      });
    }, 5000);
  }

  shownoteoutputnpvflex() {
    this.getNoteOutputNPVdataByNoteId(this._note);
    this.setFocus();
  }

  ClosingTab() {
    //alert('close');
    if (!this.IsOpenClosingTab) {
      setTimeout(() => {
        this._bindGridDropdows();
        this.flexPrepay.invalidate(true);
        this.flexrss.invalidate(true);
        // this.flexstripping.invalidate();
        this.IsOpenClosingTab = true;
      }, 200);
    }
    this.setFocus();
  }

  FinancingTab() {
    if (!this.IsOpenFinancingTab) {
      setTimeout(() => {
        this._bindGridDropdows();
        this.flexfinancingfee.invalidate();
        this.flexFinancingSch.invalidate();
        this.IsOpenFinancingTab = true;
      }, 200);
    }
    this.setFocus();
  }

  ServicingTab() {
    if (!this.IsOpenServicingTab) {
      setTimeout(() => {
        this._bindGridDropdows();
        this.flexdefaultsch.invalidate();
        this.IsOpenServicingTab = true;
      }, 200);
    }
    this.setFocus();
  }

  Servicinglog() {
    this._isNoteSaving = true;
    if (!this.IsOpenServicinglogTab) {
      this._isNoteSaving = true;
      setTimeout(() => {
        this._bindGridDropdows();
        if (this.listtransactiontype) {
          this.getTransactionTypes();
        }
        this.flexservicelog.invalidate();
        this.ServicingLogReadOnly();
        this.IsOpenServicinglogTab = true;
        this._isNoteSaving = false;
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
  }

  ServicingDropDate() {
    if (!this.IsOpenServicingDropDateTab) {
      setTimeout(() => {
        this.flexServicingDropDate.invalidate();
        this.IsOpenServicingDropDateTab = true;
      }, 200);
    }
    this.setFocus();
  }

  //*****************periodic data code start *****************//
  CopyGridDataWithHeader(s: wjcGrid.FlexGrid, e: wjcGrid.CellEditEndingEventArgs) {
    // get clip text
    var text = s.getClipString();
    // add headers
    var sel = s.selection,
      hdr = '';
    for (var c = sel.leftCol; c <= sel.rightCol; c++) {
      if (hdr) hdr += '\t';
      hdr += s.columns[c].header;
    }
    text = hdr + '\r\n' + text;
    wjcCore.Clipboard.copy(text);
    e.cancel = true;
  }

  public getPeriodicDataByNoteId(_note) {
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
      //   this._signalRService.SendCalcNotification("CALCMGR" + '|*|' + appsettings.Notificationsettings._notificationenvironment);
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
      this.noteService.validatenote(this._validationobject).subscribe(res => {
        if (res.Succeeded) {

          if (res.Criticalerror == 0) {
            //this.noteService.addNote(this._note).subscribe(res => {
            //    if (res.Succeeded) {
            this.RunCalculatorForJson();
            //==================
            //this.fetchNote();
            //==================

            this._isPeriodicDataFetched = false;
            this._isCalcDataFetched = false;
            this._isCalcJsonFetched = true;
            this._isCashFlowClicked = false;
            this.modulename = "Calc JSON";
            this._isNoteSaving = false;
            setTimeout(function () {
              this.grdCalcData.autoSizeColumns(0, this.grdCalcData.columns.length - 1, false, 20);
            }.bind(this), 1000);
            //     }
            //});
            error => console.error('Error: ' + error)
            //////////////////
          }
          else {    //close modal div
            $("#myModal.close").click();
            this.ClosePopUp();

            //this._isExceptionscount = true;
            // this.flexnoteexceptions.selectionMode = wjcGrid.SelectionMode.None;
            this.lstnotesexceptions = res.Allexceptionslist;
            // this.showflexnoteexceptionsflex();
            this.exceptionscount = res.exceptioncount;
            this._ShowmessagedivWarnote = true;
            this._showexceptionEmptymessage = false;
            this._ShowmessagedivMsgWarnote = res.Validationstring;
            setTimeout(function () {
              this._ShowmessagedivWar = false;
            }.bind(this), 5000);
          }
        }
      });

      error => console.error('Error: ' + error)
    }
    else {
      var modal = document.getElementById('myModal');
      modal.style.display = "block";
      $.getScript("/js/jsDrag.js");
      _note.MaturityMethodID = 0;
      this.noteService.getHistoricalDataOfModuleByNoteIdAPI(_note, this._pageIndex, this._pageSize).subscribe(res => {
        if (res.Succeeded) {
          if (res.StatusCode != 404) {
            this._isPeriodicDataFetched = true;
            this._isCalcDataFetched = false;
            this._isCalcJsonFetched = false;
            this._isPeriodicDataFetching = false;
            this._isSetHeaderEmpty = false;

            switch (_note.modulename) {
              case "Maturity":
                this.modulename = "Maturity";

                this.setlstPeriodicDataList = res.lstMaturityScenariosDataContract;
                //this.gConvertToBindableDate(this.setlstPeriodicDataList);
                this._isSetHeaderEmpty = true;
                break;

              case "BalanceTransactionSchedule":
                this.modulename = "Balance Transaction";
                break;

              case "DefaultSchedule":
                this.modulename = "Default Schedule";
                this.setlstPeriodicDataList = res.lstDefaultScheduleDataContract;
                this._isSetHeaderEmpty = true;
                break;

              case "FeeCouponSchedule":
                this.modulename = "Fee Coupon Schedule";
                break;

              case "FinancingFeeSchedule":
                this.modulename = "Financing Fee Schedule";
                this.setlstPeriodicDataList = res.lstFinancingFeeScheduleDataContract;
                this._isSetHeaderEmpty = true;
                break;
              case "FinancingSchedule":
                this.modulename = "Financing Schedule";
                this.setlstPeriodicDataList = res.lstFinancingScheduleDataContract;
                this._isSetHeaderEmpty = true;
                break;
              case "PIKSchedule":
                this.modulename = "PIK Schedule";
                this.setlstPeriodicDataList = res.lstPIKSchedule;
                this._isSetHeaderEmpty = true;
                break;
              case "PrepayAndAdditionalFeeSchedule":
                this.modulename = "Prepay And Additional Fee Schedule";
                this.setlstPeriodicDataList = res.lstPrepayAndAdditionalFeeScheduleDataContract;
                this._isSetHeaderEmpty = true;
                break;
              case "RateSpreadSchedule":
                this.modulename = "Rate Spread Schedule";
                this.setlstPeriodicDataList = res.lstRateSpreadSchedule;
                this._isSetHeaderEmpty = true;
                break;
              case "ServicingFeeSchedule":
                this.modulename = "Servicing Fee Schedule";
                this.setlstPeriodicDataList = res.lstNoteServicingFeeScheduleDataContract;
                this._isSetHeaderEmpty = true;
                break;
              case "StrippingSchedule":
                this.modulename = "Stripping Schedule";
                this.setlstPeriodicDataList = res.lstStrippingScheduleDataContract;
                this._isSetHeaderEmpty = true;
                break;

              case "FundingSchedule":
                this.modulename = "Funding Schedule";
                this.setlstPeriodicDataList = res.lstFundingSchedule;

                break;

              case "PIKScheduleDetail":
                this.modulename = "PIK Schedule Detail";
                this.setlstPeriodicDataList = res.lstPIKScheduleDetail;

                break;

              case "LIBORSchedule":
                this.modulename = "LIBOR Schedule";
                this.setlstPeriodicDataList = res.lstLIBORSchedule;

                break;

              case "AmortSchedule":
                this.modulename = "Amort Schedule";
                this.setlstPeriodicDataList = res.lstAmortSchedule;

                break;

              case "FeeCouponStripReceivable":
                this.modulename = "Fee Coupon Strip Receivable";
                this.setlstPeriodicDataList = res.lstFeeCouponStripReceivable;

                break;

              default:
                break;
            }
            if (_note.modulename == 'FundingSchedule') {
              for (var i = 0; i < this.setlstPeriodicDataList.length; i++) {
                if (this.setlstPeriodicDataList[i].Date != null) {
                  this.setlstPeriodicDataList[i].Date = new Date(this.setlstPeriodicDataList[i].Date.toString());
                }
              }
            }
            this.columns = [];
            //=======================

            if (_note.modulename == 'FundingSchedule' || _note.modulename == 'PIKScheduleDetail' || _note.modulename == 'LIBORSchedule' || _note.modulename == 'AmortSchedule') {
              this.columns = [
                { header: 'Date', binding: 'Date' },
              ];
            }
            else {
              if (_note.modulename == 'FeeCouponStripReceivable' || _note.modulename == 'Maturity') {

              }
              else {
                this.columns = [
                  { header: '', binding: '0' },
                ];
              }
            }

            //===================

            var header = [];
            var data: any = this.setlstPeriodicDataList;
            //alert("after data fetch");
            $.each(data, function (obj) {
              var i = 0;
              $.each(data[obj], function (key, value) {
                //alert("key :" + key + " value :" + value);
                header[i] = key;
                i = i + 1;
              })
              return false;
            });

            if (_note.modulename == 'Maturity') {
              for (var j = 0; j < header.length; j++) {
                this.Addcolumn(header[j], header[j], 'p5')
              }
            }

            else {

              if (_note.modulename == 'LIBORSchedule')
                for (var j = 1; j < header.length; j++) {
                  this.Addcolumn(header[j], header[j], 'p5')
                }
              else
                for (var j = 1; j < header.length; j++) {
                  this.Addcolumn(header[j], header[j], 'n2')
                }
            }

            //================

            if (_note.modulename == 'Maturity')
              this._isSetHeaderEmpty = false;
            this.lstPeriodicDataList = this.setlstPeriodicDataList;
            //var data: any = this.setlstPeriodicDataList;
            var data: any = this.lstPeriodicDataList;
            this._totalCount = res.TotalCount;
            //alert('this._pageIndex' + this._pageIndex);
            if (this._pageIndex == 1) {
              //this.lstPeriodicDataList = this.setlstPeriodicDataList;

              //if (_note.modulename == "RateSpreadSchedule")
              if (this._isSetHeaderEmpty) {
                this._isPeriodicDataFetched = true;
                this._isCalcDataFetched = false;
                this._isCalcJsonFetched = false;
                data = this.setlstPeriodicDataList;
                //this.grdPeriodicData.invalidate();
                data.forEach((obj, i) => { // FETCH ALL DATA AND PUSH IN FLEX GRID!!!
                  {

                    {
                      setTimeout(() => {
                        var colCount = this.grdPeriodicData.columns.length;
                        for (i = 0; i < colCount; i++) {
                          this.grdPeriodicData.columnHeaders.setCellData(0, i, '');
                        }

                        //remove first cell selection
                        this.grdPeriodicData.selectionMode = wjcGrid.SelectionMode.None;
                      }, 20);
                    }
                  }
                });
              }
            }
            else {
              data.forEach((obj, i) => { // FETCH ALL DATA AND PUSH IN FLEX GRID!!!
                this.grdPeriodicData.rows.push(new wjcGrid.Row(obj));
              });
            }

            setTimeout(function () {
              this.grdPeriodicData.autoSizeColumns(0, this.grdPeriodicData.columns.length - 1, false, 20);
            }.bind(this), 1000);

            // return true;
          } else {
            this._isPeriodicDataFetching = false;

            this.calcExceptionMsg = "No record found";
            this._dvEmptyPeriodicDataMsg = true;
          }
        }
        else {
          this._isPeriodicDataFetching = false;
          this._dvEmptyPeriodicDataMsg = true;
          //return true;
        }
      });
    }
    //  return true;
  }

  RunCalculator() {
    //===Run Calculator==========
    this._note.AnalysisID = this.ScenarioId;
    this.noteService.QueueNoteForCalculation(this._note, this._pageIndex, this._pageSize).subscribe(res => {
      if (res.Succeeded) {

        this._isPeriodicDataFetched = false;
        this._isPeriodicDataFetching = false;
        this._Showmessagenotediv = true;
        this._ShowmessagenotedivMsg = res.Message;
        if (res.DealCalcuStatus == "CalcSubmit") {
          this._note.CalculationStatus = "CalcSubmit";
        } else {
          this._note.CalculationStatus = "Processing";
        }
        setTimeout(function () {
          this._Showmessagenotediv = false;
          this._ShowmessagenotedivMsg = "";
          this.showcalcstatus();
        }.bind(this), 6000);
        return true;
      }
      else {

        this._ShowmessagedivWarnote = true;
        this._ShowmessagedivMsgWarnote = "Failed to calculate note, please try after some time. ";
        this.calcExceptionMsg = res.Message;
        this._isPeriodicDataFetching = false;
        this._dvEmptyPeriodicDataMsg = true;
        this._isCalcDataFetched = false;
        this._isCalcJsonFetched = false;
        setTimeout(function () {
          this._ShowmessagedivWar = false
          this._ShowmessagenotedivWar = false;
        }.bind(this), 10000);
        return true;
      }
    });
    //========================
  }
  RunCalculatorForJson() {
    //===Run Calculator==========
    this.noteService.getNoteCalculatorJsonByNoteId(this._note.NoteId).subscribe(res => {
      if (res.Succeeded) {
        this._isPeriodicDataFetched = false;
        this._isPeriodicDataFetching = false;
        this.lstPeriodicDataList = res.Message;

        $('#txtNoteJson').val(res.Message);
        //remove first cell selection
        // this.grdCalcData.selectionMode = wijmo.grid.SelectionMode.None;

        return true;
      }
      else {
        this.calcExceptionMsg = res.Message;

        return true;
      }
    });
    //========================
  }

  RunCalculatorByJsonRequest() {
    //===Run Calculator==========
    // private _note: Note;
    this._isPeriodicDataFetching = true;
    this._note.CalcJSONRequest = $('#txtNoteJson').val();
    this.noteService.getNoteCalculatorDataByJsonRequest(this._note, this._pageIndex, this._pageSize).subscribe(res => {
      if (res.Succeeded) {
        this._isPeriodicDataFetched = false;
        this._isPeriodicDataFetching = false;
        this.lstPeriodicDataList = res.Message;

        this._isCalcJsonResponseFetched = true;
        $('#txtNoteJsonResponse').val(res.Message);
        //remove first cell selection
        // this.grdCalcData.selectionMode = wijmo.grid.SelectionMode.None;

        this._isPeriodicDataFetching = false;
        return true;
      }
      else {
        this.calcExceptionMsg = res.Message;

        return true;
      }
    });
    //========================
  }

  hideDialog() {
    this._isPeriodicDataFetched = false;
    this._isPeriodicDataFetching = true;
    this._dvEmptyPeriodicDataMsg = false;
    this._isCalcDataFetched = false;
    this._isCalcJsonFetched = false;
  }

  //*****************periodic data code end *****************//

  DiscardChanges() {
    localStorage.setItem('divInfoNote', JSON.stringify(false));
    localStorage.setItem('divSucessNote', JSON.stringify(false));
    localStorage.setItem('divWarNote', JSON.stringify(false));


    //this._router.navigate([this.routes.dashboard.name]);
    window.history.back();
  }

  SetClientNoteId() {
    if (this._note.ClientNoteID) {
      this._note.ClientNoteID = this._note.CRENoteID;
    }
  }

  private ConvertDecimalToPercent(Data, modulename, IsGrid: boolean) {
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
  }

  private ConvertPercentToDecimal(Data, modulename, IsGrid: boolean) {
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
  }

  StatusIDChange(newvalue): void {
    this._note.StatusID = newvalue;
  }
  DeletOptionChange(newvalueoption): void {
    var newval = newvalueoption;
  }




  IndexNameIDChange(newvalue): void {
    this._note.IndexNameID = newvalue.value;
    this._note.IndexNameText = newvalue.selectedOptions[0].label;

    this.getLiborScheduleData();
  }

  BaseCurrencyChange(newvalue): void {
    this._note.BaseCurrencyID = newvalue;
  }

  ClientChange(newvalue): void {
    this._note.ClientID = newvalue;
  }

  ServicerNameChange(newvalue): void {
    this._note.ServicerNameID = newvalue;
  }

  InterestCalculationRuleForPaydownsChange(newvalue): void {
    this._note.InterestCalculationRuleForPaydowns = newvalue;
  }

  InterestCalculationRuleForPIKPaydownsChange(newvalue): void {
    this._note.InterestCalculationRuleForPIKPaydowns = newvalue;
  }

  InterestCalculationRuleForPaydownsAmortChange(newvalue): void {
    this._note.InterestCalculationRuleForPaydownsAmort = newvalue;
  }

  AccrualPeriodTypeChange(newvalue): void {
    this._note.AccrualPeriodType = newvalue;
  }

  AccrualPeriodBusinessDayAdjChange(newvalue): void {
    this._note.AccrualPeriodBusinessDayAdj = newvalue;
  }


  FundChange(newvalue): void {
    this._note.FundId = newvalue;
  }

  FinancingSourceChange(newvalue): void {
    this._note.FinancingSourceID = newvalue;
  }

  DebtTypeChange(newvalue): void {
    this._note.DebtTypeID = newvalue;
  }

  BillingNotesChange(newvalue): void {
    this._note.BillingNotesID = newvalue;
  }

  CapStackChange(newvalue): void {
    this._note.CapStack = newvalue;
  }

  PoolChange(newvalue): void {
    this._note.PoolID = newvalue;
  }

  AccountingModeChange(newvalue): void {
    this._note.ProspectiveAccountingMode = newvalue;
  }

  IsCapitalizedChange(newvalue): void {
    this._note.IsCapitalized = newvalue;
  }

  PIKSeparateCompoundingChange(newvalue)
    : void {
    this.PIKSeparateCompounding = newvalue;
    this.showhidepikcompundingsetup();
  }

  PIKSchedulePIKReasonCodeIDChange(newvalue)
    : void {
    this.PIKSchedule_PIKReasonCodeID = newvalue;
  }
  PIKInterestCalcmethodChange(newvalue)
    : void {
    this.PIKSchedule_PIKIntCalcMethodID = newvalue;
  }
  PIKSetUpmethodChange(newvalue)
    : void {
    this.PIKSetUp = newvalue;
    this.showhidepikcompundingsetup();
  }

  LoanTypeChange(newvalue): void {
    this._note.LoanType = newvalue;
  }

  ClassificationChange(newvalue): void {
    this._note.Classification = newvalue;
  }

  SubClassificationChange(newvalue): void {
    this._note.SubClassification = newvalue;
  }

  GAAPDesignationChange(newvalue): void {
    this._note.GAAPDesignation = newvalue;
  }
  GeographicLocationChange(newvalue): void {
    this._note.GeographicLocation = newvalue;
  }

  PropertyTypeChange(newvalue): void {
    this._note.PropertyType = newvalue;
  }
  ServicerChange(newvalue): void {
    this._note.Servicer = newvalue;
  }

  //Enabling M61 Calculation
  EnablingCalculationChange(newvalue): void {
    this._note.EnableM61Calculations = newvalue;
  }
  FullIOTermFlagChange(newvalue): void {
    this._note.FullIOTermFlag = newvalue;
  }
  NoteTypeChange(newvalue): void {
    this._note.NoteType = newvalue;
  }

  DeleteDataManagementDropdown(newvalue): void {

    var selectedText = newvalue.target.text
    selectedText = selectedText.trim();
    this.deleteoptiontext = selectedText.replace('delete', '').trim();
    var LookupID = this.lstNoteDeleteFilter.filter(x => x.Name == selectedText)[0].LookupID;
    var customdialogbox = document.getElementById('customdialogbox');
    this._moduledelete.ModuleID = this._note.NoteId;
    this._moduledelete.ModuleName = 'Note';
    this._moduledelete.LookupID = LookupID;

    this._MsgText = 'Are you sure want to delete ' + selectedText + ' for Note ' + this._note.CRENoteID + '?';
    customdialogbox.style.display = "block";
    $.getScript("/js/jsDrag.js");



  }

  SelectedMaturityScenarioChange(newvalue): void {
    this._note.PropertyType = newvalue;
  }

  RateTypeChange(newvalue): void {
    this._note.RateType = newvalue;
  }
  ReAmortizeMonthlyChange(newvalue): void {
    this._note.ReAmortizeMonthly = newvalue;
  }
  ReAmortizeatPMTResetChange(newvalue): void {
    this._note.ReAmortizeatPMTReset = newvalue;
  }
  StubPaidInArrearsChange(newvalue): void {
    this._note.StubPaidInArrears = newvalue;
  }
  RelativePaymentMonthChange(newvalue): void {
    this._note.RelativePaymentMonth = newvalue;
  }
  SettleWithAccrualFlagChange(newvalue): void {
    this._note.SettleWithAccrualFlag = newvalue;
  }
  InterestDueAtMaturityChange(newvalue): void {
    this._note.InterestDueAtMaturity = newvalue;
  }
  DeterminationDateHolidayListChange(newvalue): void {
    this._note.DeterminationDateHolidayList = newvalue;
  }
  StubPaidinAdvanceYNChange(newvalue): void {
    this._note.StubPaidinAdvanceYN = newvalue;
  }
  LoanPurchaseChange(newvalue): void {
    this._note.LoanPurchase = newvalue;
  }
  RoundingMethodChange(newvalue): void {
    this._note.RoundingMethod = newvalue;
  }
  StubInterestPaidonFutureAdvancesChange(newvalue): void {
    this._note.StubInterestPaidonFutureAdvances = newvalue;
  }
  IncludeServicingPaymentOverrideinLevelYieldChange(newvalue): void {
    this._note.IncludeServicingPaymentOverrideinLevelYield = newvalue;
  }
  ModelFinancingDrawsForFutureFundingsChange(newvalue): void {
    this._note.ModelFinancingDrawsForFutureFundings = newvalue;
  }
  FinancingFacilityIDChange(newvalue): void {
    this._note.FinancingFacilityID = newvalue;
  }
  FinancingPayFrequencyChange(newvalue): void {
    this._note.FinancingPayFrequency = newvalue;
  }
  ImpactCommitmentCalcChange(newvalue): void {
    this._note.ImpactCommitmentCalc = newvalue;
  }
  CashflowEngineChange(newvalue): void {
    if (newvalue == 300) {
      this._isShowCalcbutton = false;
    }
    else {
      this._isShowCalcbutton = true;
    }
  }
  FullInterestAtPPayoffChange(newvalue): void {
    this._note.FullInterestAtPPayoff = newvalue;
  }
  RoundingNoteChange(newvalue): void {
    this._note.RoundingNote = newvalue;
  }

  InterestOnlyNoteChange(newvalue): void {
    this._note.InterestOnlyNote = newvalue;
  }
  ConstantPaymentMethodChange(newvalue): void {
    this._note.ConstantPaymentMethod = newvalue;
  }
  PaymentDateAccrualPeriodChange(newvalue): void {
    this._note.PaymentDateAccrualPeriod = newvalue;
  }

  SaveOnly(SaveOnly) {

    this.isSaveOnly = SaveOnly;
    this.IsOpenActivityTab = false;
  }

  CustomValidator() {
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
  }
  setFocus(): void {
    var ele = document.getElementById('CRENoteID');
    ele.focus();
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
    document.getElementById('dialogboxhead').innerHTML = "CRES - Validation Error";
    document.getElementById('dialogboxbody').innerHTML = dialog;
    //document.getElementById('dialogboxfoot').innerHTML = '<span class="custombutton" onclientclick="this.ok()">OK</span>';
  }

  ok(): void {
    document.getElementById('dialogbox').style.display = "none";
    document.getElementById('dialogoverlay').style.display = "none";
  }
  Addcolumn(header, binding, format) {
    try {
      this.columns.push({ "header": header, "binding": binding, "format": format })
    } catch (err) { }
  }

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

  convertDatetoGMT(date: Date) {
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
  }

  convertDatetoGMTGrid(Data, modulename) {
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

            //if (this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].EffectiveDate != null) {
            //  this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].EffectiveDate = this.convertDatetoGMT(this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].EffectiveDate);
            //}
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
  }

  convertArchieveDatetoGMTGrid(Data, modulename) {
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
  }

  convertdate() {
    if (this._isConvertDate == false) {
      if (this._note.StartDate != null) { this._note.StartDate = this.convertDatetoGMT(this._note.StartDate); }
      if (this._note.EndDate != null) { this._note.EndDate = this.convertDatetoGMT(this._note.EndDate); }
      if (this._note.InitialInterestAccrualEndDate != null) { this._note.InitialInterestAccrualEndDate = this.convertDatetoGMT(this._note.InitialInterestAccrualEndDate); }
      if (this._note.FirstPaymentDate != null) { this._note.FirstPaymentDate = this.convertDatetoGMT(this._note.FirstPaymentDate); }
      if (this._note.InitialMonthEndPMTDateBiWeekly != null) { this._note.InitialMonthEndPMTDateBiWeekly = this.convertDatetoGMT(this._note.InitialMonthEndPMTDateBiWeekly); }
      if (this._note.FinalInterestAccrualEndDateOverride != null) { this._note.FinalInterestAccrualEndDateOverride = this.convertDatetoGMT(this._note.FinalInterestAccrualEndDateOverride); }
      if (this._note.FirstRateIndexResetDate != null) { this._note.FirstRateIndexResetDate = this.convertDatetoGMT(this._note.FirstRateIndexResetDate); }
      // if (this._note.SelectedMaturityDate != null) { this._note.SelectedMaturityDate = this.convertDatetoGMT(this._note.SelectedMaturityDate); }
      // if (this._note.InitialMaturityDate != null) { this._note.InitialMaturityDate = this.convertDatetoGMT(this._note.InitialMaturityDate); }
      if (this._note.ExpectedMaturityDate != null) { this._note.ExpectedMaturityDate = this.convertDatetoGMT(this._note.ExpectedMaturityDate); }
      // if (this._note.FullyExtendedMaturityDate != null) { this._note.FullyExtendedMaturityDate = this.convertDatetoGMT(this._note.FullyExtendedMaturityDate); }
      if (this._note.OpenPrepaymentDate != null) { this._note.OpenPrepaymentDate = this.convertDatetoGMT(this._note.OpenPrepaymentDate); }
      if (this._note.FinancingInitialMaturityDate != null) { this._note.FinancingInitialMaturityDate = this.convertDatetoGMT(this._note.FinancingInitialMaturityDate); }
      if (this._note.FinancingExtendedMaturityDate != null) { this._note.FinancingExtendedMaturityDate = this.convertDatetoGMT(this._note.FinancingExtendedMaturityDate); }

      if (this._note.ClosingDate != null) { this._note.ClosingDate = this.convertDatetoGMT(this._note.ClosingDate); }
      if (this._note.LastAccountingCloseDate != null) { this._note.LastAccountingCloseDate = this.convertDatetoGMT(this._note.LastAccountingCloseDate); }


      // if (this._note.ExtendedMaturityScenario1 != null) { this._note.ExtendedMaturityScenario1 = this.convertDatetoGMT(this._note.ExtendedMaturityScenario1); }
      // if (this._note.ExtendedMaturityScenario2 != null) { this._note.ExtendedMaturityScenario2 = this.convertDatetoGMT(this._note.ExtendedMaturityScenario2); }
      // if (this._note.ExtendedMaturityScenario3 != null) { this._note.ExtendedMaturityScenario3 = this.convertDatetoGMT(this._note.ExtendedMaturityScenario3); }
      if (this._note.ActualPayoffDate != null) { this._note.ActualPayoffDate = this.convertDatetoGMT(this._note.ActualPayoffDate); }

      if (this._note.PurchaseDate != null) { this._note.PurchaseDate = this.convertDatetoGMT(this._note.PurchaseDate); }
      if (this._note.ValuationDate != null) { this._note.ValuationDate = this.convertDatetoGMT(this._note.ValuationDate); }
      if (this._note.lastCalcDateTime != null) { this._note.lastCalcDateTime = this.convertDatetoGMT(this._note.lastCalcDateTime); }

      if (this._note.AccountingCloseDate != null) { this._note.AccountingCloseDate = this.convertDatetoGMT(this._note.AccountingCloseDate); }

      if (this.MaturityEffectiveDate != null) { this.MaturityEffectiveDate = this.convertDatetoGMT(this.MaturityEffectiveDate); }
      if (this.MaturityDate != null) { this.MaturityDate = this.convertDatetoGMT(this.MaturityDate); }

      if (this.Servicing_EffectiveDate != null) { this.Servicing_EffectiveDate = this.convertDatetoGMT(this.Servicing_EffectiveDate); }
      if (this.Servicing_Date != null) { this.Servicing_Date = this.convertDatetoGMT(this.Servicing_Date); }

      if (this.PIKSchedule_EffectiveDate != null) { this.PIKSchedule_EffectiveDate = this.convertDatetoGMT(this.PIKSchedule_EffectiveDate); }
      if (this.PIKSchedule_StartDate != null) { this.PIKSchedule_StartDate = this.convertDatetoGMT(this.PIKSchedule_StartDate); }
      if (this.PIKSchedule_EndDate != null) { this.PIKSchedule_EndDate = this.convertDatetoGMT(this.PIKSchedule_EndDate); }

      if (this.Ratespread_EffectiveDate != null) {
        this.Ratespread_EffectiveDate = this.convertDatetoGMT(this.Ratespread_EffectiveDate);
      }
      if (this.PrepayAndAdditionalFeeSchedule_EffectiveDate != null) { this.PrepayAndAdditionalFeeSchedule_EffectiveDate = this.convertDatetoGMT(this.PrepayAndAdditionalFeeSchedule_EffectiveDate); }
      if (this.StrippingSchedule_EffectiveDate != null) { this.StrippingSchedule_EffectiveDate = this.convertDatetoGMT(this.StrippingSchedule_EffectiveDate); }
      if (this.FinancingFeeSchedule_EffectiveDate != null) { this.FinancingFeeSchedule_EffectiveDate = this.convertDatetoGMT(this.FinancingFeeSchedule_EffectiveDate); }
      if (this.FinancingSchedule_EffectiveDate != null) { this.FinancingSchedule_EffectiveDate = this.convertDatetoGMT(this.FinancingSchedule_EffectiveDate); }
      if (this.DefaultSchedule_EffectiveDate != null) { this.DefaultSchedule_EffectiveDate = this.convertDatetoGMT(this.DefaultSchedule_EffectiveDate); }
      if (this._note.NoteTransferDate != null) { this._note.NoteTransferDate = this.convertDatetoGMT(this._note.NoteTransferDate); }
      if (this._note.FirstIndexDeterminationDateOverride != null) { this._note.FirstIndexDeterminationDateOverride = this.convertDatetoGMT(this._note.FirstIndexDeterminationDateOverride); }
      this._isConvertDate = true;
    }
  }

  convertGridDate() {
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
  }

  createDateAsUTC(date) {
    if (date)
      return new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds()));
  }

  beginningEdit(modulename): void {
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
  }

  rowEditEnded(modulename): void {
    var rssformatDate: Date
    switch (modulename) {
      case "PIKScheduleDetail":
        var sel = this.pikflex.selection;
        var flag = this.CheckDuplicateDate(this._noteext.ListPIKfromPIKSourceNoteTab, sel.topRow);
        if (flag == true) {
          //   alert("Date " + this._noteext.lstPIKDetailScheduleTab[sel.topRow].Date.toString() + " already in list");

          var locale = "en-US"
          var options: any = { year: "numeric", month: "numeric", day: "numeric" };

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
          var formatDate: Date;
          var locale = "en-US"
          var options: any = { year: "numeric", month: "numeric", day: "numeric" };
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
          var formatDate: Date;
          var locale = "en-US"
          var options: any = { year: "numeric", month: "numeric", day: "numeric" };
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
  }

  CheckDuplicateDate(lstData, rwNum): boolean {
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
  }

  addFooterRow(flexGrid: wjcGrid.FlexGrid) {
    var row = new wjcGrid.GroupRow(); // create a GroupRow to show aggregates
    flexGrid.columnFooters.rows.push(row); // add the row to the column footer panel
    flexGrid.bottomLeftCells.setCellData(0, 0, '\u03A3');
    // sigma on the header
  }
  addFooterTotalcommitmentRow(flexGrid: wjcGrid.FlexGrid) {
    var row = new wjcGrid.GroupRow(); // create a GroupRow to show aggregates
    flexGrid.columnFooters.rows.push(row); // add the row to the column footer panel
  }
  deleteRow() {
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

    if (this.modulename == "Rate Spread Schedule History") {
      if (this.flexEditRSS.rows[this.deleteRowIndex]) {

        // Finding schedule id to delete the row
        var delrowIndex = this.lstNoteEditRSSlist.findIndex(x => x.ScheduleID == this.flexEditRSS.rows[this.deleteRowIndex].dataItem.ScheduleID);
        if (delrowIndex !== -1) {
          var delrow = this.lstNoteEditRSSlist[delrowIndex];
          this.deleteRateSpreadSchedulePopup.push(delrow);
          this.lstNoteEditRSSlist[delrowIndex].isdeleted = true;
        }
      }
      this.cvEditRateSpreadScheduleList.removeAt(this.deleteRowIndex);
    }

    if (this.modulename == "Fee Schedule History") {
      if (this.flexEditFee.rows[this.deleteRowIndex]) {

        //finding schedule id to delete the row
        var delrowfeeindex = this.lstNoteEditFEElist.findIndex(x => x.ScheduleID == this.flexEditFee.rows[this.deleteRowIndex].dataItem.ScheduleID);
        if (delrowfeeindex !== -1) {
          var delrowfee = this.lstNoteEditFEElist[delrowfeeindex];
          this.deleteFeeSchedulePopup.push(delrowfee);
          this.lstNoteEditFEElist[delrowfeeindex].isdeleted = true;
        }
      }
      this.cvEditFeeScheduleList.removeAt(this.deleteRowIndex);
    }

    if (this.modulename == "PIK Schedule History") {
      if (this.flexEditPIK.rows[this.deleteRowIndex]) {

        //finding schedule id to delete the row
        var delrowpikindex = this.lstNoteEditPIKSchedulelist.findIndex(x => x.ScheduleID == this.flexEditPIK.rows[this.deleteRowIndex].dataItem.ScheduleID);
        if (delrowpikindex !== -1) {
          var delrowpik = this.lstNoteEditPIKSchedulelist[delrowpikindex];
          this.deletePIKSchedulePopup.push(delrowpik);
          this.lstNoteEditPIKSchedulelist[delrowpikindex].isdeleted = true;
        }
      }
      this.cvEditPIKSchedulelist.removeAt(this.deleteRowIndex);
    }

    this.CloseDeletePopUp();
  }

  SaveNoteArchieveextralist(): void {
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
          var filteredarray = this.lstRateSpreadSch_ValueType.filter(x => x.Name == this._noteArchieveext.RateSpreadScheduleList[i].ValueTypeText)
          if (filteredarray.length != 0) {
            this._noteArchieveext.RateSpreadScheduleList[i].ValueTypeID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this._noteArchieveext.RateSpreadScheduleList[i].IntCalcMethodText).toString() == "NaN" || Number(this._noteArchieveext.RateSpreadScheduleList[i].IntCalcMethodText) == 0)) {
          this._noteArchieveext.RateSpreadScheduleList[i].IntCalcMethodID = Number(this._noteArchieveext.RateSpreadScheduleList[i].IntCalcMethodText);
        } else {
          var filteredarray = this.lstIntCalcMethodID.filter(x => x.Name == this._noteArchieveext.RateSpreadScheduleList[i].IntCalcMethodText)
          if (filteredarray.length != 0) {
            this._noteArchieveext.RateSpreadScheduleList[i].IntCalcMethodID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this._noteArchieveext.RateSpreadScheduleList[i].IndexNameText).toString() == "NaN" || Number(this._noteArchieveext.RateSpreadScheduleList[i].IndexNameText) == 0)) {
          this._noteArchieveext.RateSpreadScheduleList[i].IndexNameID = Number(this._noteArchieveext.RateSpreadScheduleList[i].IndexNameText);
        }
        else {
          var filteredarray = this.lstRateSpreadSch_ValueType.filter(x => x.Name == this._noteArchieveext.RateSpreadScheduleList[i].IndexNameText)
          if (filteredarray.length != 0) {
            this._noteArchieveext.RateSpreadScheduleList[i].IndexNameID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this._noteArchieveext.RateSpreadScheduleList[i].DeterminationDateHolidayListText).toString() == "NaN" || Number(this._noteArchieveext.RateSpreadScheduleList[i].DeterminationDateHolidayListText) == 0)) {
          this._noteArchieveext.RateSpreadScheduleList[i].DeterminationDateHolidayList = Number(this._noteArchieveext.RateSpreadScheduleList[i].DeterminationDateHolidayListText);
        }
        else {
          var filteredarray = this.lstRateSpreadSch_ValueType.filter(x => x.Name == this._noteArchieveext.RateSpreadScheduleList[i].DeterminationDateHolidayListText)
          if (filteredarray.length != 0) {
            this._noteArchieveext.RateSpreadScheduleList[i].DeterminationDateHolidayList = Number(filteredarray[0].LookupID);
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
            var filteredarray = this.lstPrepayAdditinalFee_ValueType.filter(x => x.Name == this._noteArchieveext.NotePrepayAndAdditionalFeeScheduleList[i].ValueTypeText)
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
            var filteredarray = this.lstStrippingSch_ValueType.filter(x => x.Name == this._noteArchieveext.NoteStrippingList[i].ValueTypeText)
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

    this.noteService.addNoteArchieveExtralist(this._noteArchieveextt).subscribe(res => {
      if (res.Succeeded) {
      }
    })
  }

  beginningEditDateAndValue(modulename): void {
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
  }

  delDown(e, grid) {
    let row = grid.selection.row, col = grid.selection.col;
    if (grid.columns[col].binding == 'FeeAmountOverride' || grid.columns[col].binding == 'BaseAmountOverride') {
      grid.setCellData(row, col, null, null);
    }
  }
  rowEditEndedDateAndValue(modulename): void {
    switch (modulename) {
      case "RateSpreadSchedule":
        var sel = this.flexrss.selection;
        var editedRowIndex = sel.topRow;
        var currentItem = this._noteext.RateSpreadScheduleList.findIndex(x => x.ScheduleID == this.flexrss.rows[editedRowIndex].dataItem.ScheduleID);

        var rssformatDate: Date;
        var flag = this.CheckDuplicateDateAndValue(this._noteext.RateSpreadScheduleList, currentItem);
        if (flag == true) {
          var formatValuetype = this.lstRateSpreadSch_ValueType.filter(x => x.LookupID == this._noteext.RateSpreadScheduleList[currentItem].ValueTypeText);

          var locale = "en-US"
          var options: any = { year: "numeric", month: "numeric", day: "numeric" };

          rssformatDate = this._noteext.RateSpreadScheduleList[currentItem].Date;

          if (rssformatDate.toString().indexOf("GMT") == -1) {
            this.CustomAlert("Date - " + rssformatDate + " and value type - " + formatValuetype[0].Name + " already in list");
          }
          else {
            this.CustomAlert("Date - " + rssformatDate.toLocaleDateString(locale, options) + " and value type - " + formatValuetype[0].Name + " already in list");
          }
          this._noteext.RateSpreadScheduleList[currentItem].Date = this.prevDateBeforeEdit;
          this._noteext.RateSpreadScheduleList[currentItem].ValueTypeText = this.valueType;
        }


        break;

      case "PrepayAndAdditionalFeeSchedule":
        var sel = this.flexPrepay.selection;
        var ppsformatDate: Date;
        var flag = this.CheckDuplicateStartDateAndValue(this._noteext.NotePrepayAndAdditionalFeeScheduleList, sel.topRow);
        if (flag == true) {
          var formatValuetype = this.lstPrepayAdditinalFee_ValueType.filter(x => x.LookupID == this._noteext.NotePrepayAndAdditionalFeeScheduleList[sel.topRow].ValueTypeText);

          var locale = "en-US"
          var options: any = { year: "numeric", month: "numeric", day: "numeric" };

          ppsformatDate = this._noteext.NotePrepayAndAdditionalFeeScheduleList[sel.topRow].StartDate;
          //if (ppsformatDate.toString().indexOf("GMT") == -1)
          //  this.CustomAlert("Date - " + ppsformatDate + " and value type - " + formatValuetype[0].Name + " already in list");
          //else
          //  this.CustomAlert("Date - " + ppsformatDate.toLocaleDateString(locale, options) + " and value type - " + formatValuetype[0].Name + " already in list");

          //alert("Date " + this._noteext.NotePrepayAndAdditionalFeeScheduleList[sel.topRow].StartDate.toString() + " and value type - " + this._noteext.NotePrepayAndAdditionalFeeScheduleList[sel.topRow].ValueTypeText + " already in list");
          this._noteext.NotePrepayAndAdditionalFeeScheduleList[sel.topRow].StartDate = this.prevDateBeforeEdit;
          this._noteext.NotePrepayAndAdditionalFeeScheduleList[sel.topRow].ValueTypeText = this.valueType;
        }
        break;

      case "StrippingSchedule":
        var sel = this.flexstripping.selection;
        var ssformatDate: Date;
        var flag = this.CheckDuplicateStartDateAndValue(this._noteext.NoteStrippingList, sel.topRow);
        if (flag == true) {
          var formatValuetype = this.lstStrippingSch_ValueType.filter(x => x.LookupID == this._noteext.NoteStrippingList[sel.topRow].ValueTypeText);

          var locale = "en-US"
          var options: any = { year: "numeric", month: "numeric", day: "numeric" };

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
        var ssformatDate: Date;
        var flag = this.CheckDuplicateDateAndValue(this._noteext.lstFinancingFeeSchedule, sel.topRow);
        if (flag == true) {
          var formatValuetype = this.lstFinancingFeeSch_ValueType.filter(x => x.LookupID == this._noteext.lstFinancingFeeSchedule[sel.topRow].ValueTypeText);

          var locale = "en-US"
          var options: any = { year: "numeric", month: "numeric", day: "numeric" };

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
        var ssformatDate: Date;
        var flag = this.CheckDuplicateDateAndValue(this._noteext.NoteFinancingScheduleList, sel.topRow);
        if (flag == true) {
          var formatValuetype = this.lstFinancingSch_ValueType.filter(x => x.LookupID == this._noteext.NoteFinancingScheduleList[sel.topRow].ValueTypeText);

          var locale = "en-US"
          var options: any = { year: "numeric", month: "numeric", day: "numeric" };

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
        var ssformatDate: Date;
        var flag = this.CheckDuplicateStartDateAndValue(this._noteext.NoteDefaultScheduleList, sel.topRow);
        if (flag == true) {
          var formatValuetype = this.lstDefaultSch_ValueType.filter(x => x.LookupID == this._noteext.NoteDefaultScheduleList[sel.topRow].ValueTypeText);

          var locale = "en-US"
          var options: any = { year: "numeric", month: "numeric", day: "numeric" };

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
  }

  CopiedDataValidate(modulename): void {
    try {
      const options: Intl.DateTimeFormatOptions = { year: 'numeric', month: 'numeric', day: 'numeric' };
      switch (modulename) {
        case "RateSpreadSchedule":
          var sel = this.flexrss.selection;
          var editedRowIndex = sel.topRow;
          var currentItem = this._noteext.RateSpreadScheduleList.findIndex(x => x.ScheduleID == this.flexrss.rows[editedRowIndex].dataItem.ScheduleID);

          var rssformatDate: Date;

          for (var tprow = currentItem; tprow <= sel.bottomRow; tprow++) {
            var rateValue = (this._noteext.RateSpreadScheduleList[tprow].Value).toString();
            if (rateValue.includes("%"))
              this._noteext.RateSpreadScheduleList[tprow].Value = parseFloat(rateValue.substring(0, rateValue.length - 1)) / 100;


            var flag = this.CheckDuplicateDateAndValue(this._noteext.RateSpreadScheduleList, tprow);
            if (flag == true) {
              var formatValuetype = this.lstRateSpreadSch_ValueType.filter(x => x.LookupID == this._noteext.RateSpreadScheduleList[tprow].ValueTypeText);

              var locale = "en-US"
              //var options = { year: "numeric", month: "numeric", day: "numeric" };

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
            for (var i = 0; i < this._noteext.RateSpreadScheduleList.length; i++) {
              if (i == 0) {
                var RateValue = (this._noteext.RateSpreadScheduleList[i].Value).toString();
                if (RateValue.includes("%"))
                  this._noteext.RateSpreadScheduleList[i].Value = parseFloat(RateValue.substring(0, RateValue.length - 1)) / 100;

              }
            }
          }
          break;

        case "PrepayFeeSchedule":
          var sel = this.flexPrepay.selection;
          var prepayformatDate: Date;

          for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {

            var PrepayFeeValue = (this._noteext.NotePrepayAndAdditionalFeeScheduleList[tprow].Value).toString();
            if (PrepayFeeValue.includes("%"))
              this._noteext.NotePrepayAndAdditionalFeeScheduleList[tprow].Value = parseFloat(PrepayFeeValue.substring(0, PrepayFeeValue.length - 1)) / 100;

            var PrepayIncludedLevelYield = (this._noteext.NotePrepayAndAdditionalFeeScheduleList[tprow].IncludedLevelYield).toString();
            if (PrepayIncludedLevelYield.includes("%"))
              this._noteext.NotePrepayAndAdditionalFeeScheduleList[tprow].IncludedLevelYield = parseFloat(PrepayIncludedLevelYield.substring(0, PrepayIncludedLevelYield.length - 1)) / 100;


            var PrepayPercentageOfFeeToBeStripped = (this._noteext.NotePrepayAndAdditionalFeeScheduleList[tprow].PercentageOfFeeToBeStripped).toString();
            if (PrepayPercentageOfFeeToBeStripped.includes("%"))
              this._noteext.NotePrepayAndAdditionalFeeScheduleList[tprow].PercentageOfFeeToBeStripped = parseFloat(PrepayPercentageOfFeeToBeStripped.substring(0, PrepayPercentageOfFeeToBeStripped.length - 1)) / 100;


            var flag = this.CheckDuplicateStartDateAndValue(this._noteext.NotePrepayAndAdditionalFeeScheduleList, tprow);
            if (flag == true) {
              var formatValuetype = this.lstPrepayAdditinalFee_ValueType.filter(x => x.LookupID == this._noteext.NotePrepayAndAdditionalFeeScheduleList[tprow].ValueTypeText);

              var locale = "en-US"
              //var options = { year: "numeric", month: "numeric", day: "numeric" };

              prepayformatDate = this._noteext.NotePrepayAndAdditionalFeeScheduleList[tprow].StartDate;



              //this._noteext.NotePrepayAndAdditionalFeeScheduleList[tprow].Date = this.prevDateBeforeEdit;
              this._noteext.NotePrepayAndAdditionalFeeScheduleList[tprow].ValueTypeText = this.valueType;
              //var IncludedLevelYield = (this._noteext.NotePrepayAndAdditionalFeeScheduleList[tprow].IncludedLevelYield).toString();
              //if (IncludedLevelYield.includes("%"))
              //    this._noteext.NotePrepayAndAdditionalFeeScheduleList[tprow].IncludedLevelYield = parseFloat(IncludedLevelYield.substring(0, IncludedLevelYield.length - 1)) / 100;

              // this._noteext.RateSpreadScheduleList[tprow].Date = this.prevDateBeforeEdit;
              //this._noteext.NotePrepayAndAdditionalFeeScheduleList[tprow].ValueTypeText = this.valueType;
            }
            //for (var i = 0; i < this._noteext.NotePrepayAndAdditionalFeeScheduleList.length; i++) {
            //    if (i == 0) {
            //        var IncludedLevelYield = (this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].IncludedLevelYield).toString();
            //        if (IncludedLevelYield.includes("%"))
            //            this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].IncludedLevelYield = parseFloat(IncludedLevelYield.substring(0, IncludedLevelYield.length - 1)) / 100;


            //        var PrepayValue = (this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].Value).toString();
            //        if (PrepayValue.includes("%"))
            //            this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].Value = parseFloat(PrepayValue.substring(0, PrepayValue.length - 1)) / 100;



            //        var PrepayPercentageOfFeeToBeStripped = (this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].PercentageOfFeeToBeStripped).toString();
            //        if (PrepayPercentageOfFeeToBeStripped.includes("%"))
            //            this._noteext.NotePrepayAndAdditionalFeeScheduleList[i].PercentageOfFeeToBeStripped = parseFloat(PrepayPercentageOfFeeToBeStripped.substring(0, PrepayPercentageOfFeeToBeStripped.length - 1)) / 100;

            //        //   this._noteext.RateSpreadScheduleList[tprow].Date = this.prevDateBeforeEdit;
            //        //this._noteext.NotePrepayAndAdditionalFeeScheduleList[tprow].ValueTypeText = this.valueType;

            //    }
            //}
          }
          break;

        case "StrippingSchedule":
          var sel = this.flexstripping.selection;
          var StripSchformatDate: Date;

          for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
            var flag = this.CheckDuplicateStartDateAndValue(this._noteext.NoteStrippingList, tprow);

            if (flag == true) {
              var formatValuetype = this.lstStrippingSch_ValueType.filter(x => x.LookupID == this._noteext.NoteStrippingList[tprow].ValueTypeText);

              var locale = "en-US"
              //var options = { year: "numeric", month: "numeric", day: "numeric" };

              StripSchformatDate = this._noteext.NoteStrippingList[tprow].StartDate;
              if (StripSchformatDate.toString().indexOf("GMT") == -1)
                this.CustomAlert("Date - " + StripSchformatDate + " and value type - " + formatValuetype[0].Name + " already in list");
              else
                this.CustomAlert("Date - " + StripSchformatDate.toLocaleDateString(locale, options) + " and value type - " + formatValuetype[0].Name + " already in list");
              //this._noteext.RateSpreadScheduleList[tprow].Date = this.prevDateBeforeEdit;
              this._noteext.NoteStrippingList[tprow].ValueTypeText = "";
            }
          }
          break;

        case "FinancingFeeSchedule":

          var sel = this.flexfinancingfee.selection;
          var StripSchformatDate: Date;

          for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
            var flag = this.CheckDuplicateDateAndValue(this._noteext.lstFinancingFeeSchedule, tprow);
            if (flag == true) {
              var formatValuetype = this.lstFinancingFeeSch_ValueType.filter(x => x.LookupID == this._noteext.lstFinancingFeeSchedule[tprow].ValueTypeText);

              var locale = "en-US"
              //var options = { year: "numeric", month: "numeric", day: "numeric" };

              StripSchformatDate = this._noteext.lstFinancingFeeSchedule[tprow].Date;
              if (StripSchformatDate.toString().indexOf("GMT") == -1)
                this.CustomAlert("Date - " + StripSchformatDate + " and value type - " + formatValuetype[0].Name + " already in list");
              else
                this.CustomAlert("Date - " + StripSchformatDate.toLocaleDateString(locale, options) + " and value type - " + formatValuetype[0].Name + " already in list");
              //this._noteext.RateSpreadScheduleList[tprow].Date = this.prevDateBeforeEdit;
              this._noteext.lstFinancingFeeSchedule[tprow].ValueTypeText = "";
            }
          }
          break;

        case "FinancingSchedule":
          var sel = this.flexFinancingSch.selection;
          var StripSchformatDate: Date;

          for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {

            var FinancingValue = (this._noteext.NoteFinancingScheduleList[tprow].Value).toString();
            if (FinancingValue.includes("%"))
              this._noteext.NoteFinancingScheduleList[tprow].Value = parseFloat(FinancingValue.substring(0, FinancingValue.length - 1)) / 100;

            var flag = this.CheckDuplicateDateAndValue(this._noteext.NoteFinancingScheduleList, tprow);
            if (flag == true) {
              var formatValuetype = this.lstFinancingSch_ValueType.filter(x => x.LookupID == this._noteext.NoteFinancingScheduleList[tprow].ValueTypeText);

              var locale = "en-US"
              //var options = { year: "numeric", month: "numeric", day: "numeric" };

              StripSchformatDate = this._noteext.NoteFinancingScheduleList[tprow].Date;
              if (StripSchformatDate.toString().indexOf("GMT") == -1)
                this.CustomAlert("Date - " + StripSchformatDate + " and value type - " + formatValuetype[0].Name + " already in list");
              else
                this.CustomAlert("Date - " + StripSchformatDate.toLocaleDateString(locale, options) + " and value type - " + formatValuetype[0].Name + " already in list");
              //this._noteext.RateSpreadScheduleList[tprow].Date = this.prevDateBeforeEdit;
              this._noteext.NoteFinancingScheduleList[tprow].ValueTypeText = "";


            }
          }
          break;

        case "DefaultSchedule":
          var sel = this.flexdefaultsch.selection;
          var StripSchformatDate: Date;

          for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
            var flag = this.CheckDuplicateStartDateAndValue(this._noteext.NoteDefaultScheduleList, tprow);
            if (flag == true) {
              var formatValuetype = this.lstDefaultSch_ValueType.filter(x => x.LookupID == this._noteext.NoteDefaultScheduleList[tprow].ValueTypeText);

              var locale = "en-US"
              //var options = { year: "numeric", month: "numeric", day: "numeric" };

              StripSchformatDate = this._noteext.NoteDefaultScheduleList[tprow].StartDate;
              if (StripSchformatDate.toString().indexOf("GMT") == -1)
                this.CustomAlert("Date - " + StripSchformatDate + " and value type - " + formatValuetype[0].Name + " already in list");
              else
                this.CustomAlert("Date - " + StripSchformatDate.toLocaleDateString(locale, options) + " and value type - " + formatValuetype[0].Name + " already in list");
              //this._noteext.RateSpreadScheduleList[tprow].Date = this.prevDateBeforeEdit;
              this._noteext.NoteDefaultScheduleList[tprow].ValueTypeText = "";
            }
          }
          break;

      }
    }
    catch (err) {
      console.log(err);
    }
  }

  CopiedValidate(modulename): void {
    try {
      var StripSchformatDate: Date;
      switch (modulename) {
        case "PIKScheduleDetail":
          var sel = this.pikflex.selection;
          for (var tprow = sel.topRow; tprow <= sel.bottomRow; tprow++) {
            var flag = this.CheckDuplicateDate(this._noteext.ListPIKfromPIKSourceNoteTab, tprow);
            if (flag == true) {
              var locale = "en-US"
              var options: any = { year: "numeric", month: "numeric", day: "numeric" };

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
    } catch (err) {
      console.log(err);
    }
  }

  CheckDuplicateDateAndValue(lstData, rwNum): boolean {
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
  }

  CheckDuplicateStartDateAndValue(lstData, rwNum): boolean {
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
  }
  checkDroppedDownChangedDeal(sender: wjNg2Input.WjAutoComplete, args) {
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
  }

  //ChangedDeal(sender: wjNg2Input.WjAutoComplete, args) {
  //    var ac = sender;
  //    this.Copy_Dealid = ac.selectedValue;
  //    this.Copy_DealName = ac.text
  //}

  private _cachedeal = {};
  getAutosuggestDeal = this.getAutosuggestDealFunc.bind(this);
  getAutosuggestDealFunc(query, max, callback) {
    this._result = null;
    this._isSearchDataFetching = true;
    // try getting the result from the cache
    var self = this,
      result = self._cachedeal[query];
    if (result) {
      this._dvEmptySearchMsg = false;
      this._isSearchDataFetching = false;
      callback(result);
      return;
    }

    // not in cache, get from server
    var params = { query: query, max: max };
    this._searchObj = new Search(query);

    this.searchService.getAutosuggestSearchDeal(this._searchObj, this._pageIndexSearch, this._pageSizeSearch).subscribe(res => {
      if (res.Succeeded) {
        var data: any = res.lstSearch;
        this._totalCountSearch = res.TotalCount;

        this._result = data;
        //show message for 1 sec. when no record found
        if (this._result.length == 0) {
          this._dvEmptySearchMsg = true;
          setTimeout(() => {
            this._dvEmptySearchMsg = false;
          }, 1000);
        }
        var _valueType;
        // add 'DisplayName' property to result
        let items = [];
        for (var i = 0; i < this._result.length; i++) {
          var c = this._result[i];
          c.DisplayName = c.Valuekey;
        }
        this._isSearchDataFetching = false;
        // and return the result
        callback(this._result);
      }
      else {
        this.utilityService.navigateToSignIn();
      }
    });
    error => console.error('Error: ' + error)
  }

  //check client is Super admin(Krishna)

  ApplyPermissions(_object): void {
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
          this._isShowPeriodicoutput = true
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
  }

  SetDefaultTab(): void {
    this.membershipservice.GetUserDefaultSettingByUserID(this._userdefaultsetting).subscribe(res => {
      if (res.Succeeded) {
        var udsetting = res.UserDefaultSetting.filter(function (item) { return item.TypeText === 'UserDefault_Note'; });

        if (udsetting.length > 0) {
          this._userdefaultsetting = udsetting[0];

          var childs = $('#myTab li a').toArray();

          for (var i = 0; i < childs.length; i++) {
            var id = $(childs[i]).get(0).id;
            var text = $(childs[i]).text();
            var tabname = text.replace(/ /g, '');
            var defaulttab = this._userdefaultsetting.Value.replace(/ /g, '');

            if (tabname.toLowerCase() == defaulttab.toLowerCase()) {
              var tabid = id;
              setTimeout(function () {
                document.getElementById(tabid).click();
              }.bind(this), 500);
              break;
            }
          }
        }
      }
      else {
        var tabidnew = "a" + $('#myTab li a').first().get(0).id;
        setTimeout(function () {
          document.getElementById(tabidnew).click();
        }.bind(this), 500);
      }
    });
  }

  HideAllTabs(): void {
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
  }

  HideNonSuperAdminUser(): boolean {
    var ret_val = false;
    var rolename = window.localStorage.getItem("rolename");
    if (rolename != null) {
      if (rolename.toString() == "Super Admin") {
        ret_val = true;
      }
    }
    return ret_val
  }


  CheckDuplicateTransactionCashflow(): void {
    this._isnoteperiodiccalcFetching = true;
    var downloadCashFlow = new DownloadCashFlow();
    downloadCashFlow.Pagename = "Note";
    downloadCashFlow.AnalysisID = this.ScenarioId;
    downloadCashFlow.NoteId = this._note.NoteId;
    this.noteService.CheckDuplicateTransactionCashflow(downloadCashFlow).subscribe(res => {
      this.lstCheckDuplicateTransactionCashflow = res.CheckDuplicateData
      if (this.lstCheckDuplicateTransactionCashflow != null) {
        this.CustomAlert("There is a duplicate transaction we found in cashflow download, please try after some time.");
      }
      else {
        this.downloadNoteCashflowsExportData();
      }
      this._isnoteperiodiccalcFetching = false;
    });
  }


  downloadNoteCashflowsExportData(): void {
    console.log(this._note.StatusID);
    if (this._CritialExceptionListCount > 0) {
      //alert("Please resolve the critical exceptions, recalculate the loan and then try again to download the cashflows.");
      this.CustomAlert("Please resolve the critical exceptions, recalculate the loan and then try again to download the cashflows.");
    }
    else {
      var transactioncategoryname = '';
      var downloadCashFlow = new DownloadCashFlow();
      downloadCashFlow.AnalysisID = this.ScenarioId;
      downloadCashFlow.NoteId = this._note.NoteId;
      downloadCashFlow.DealID = "00000000-0000-0000-0000-000000000000";
      downloadCashFlow.Pagename = 'Note';
      downloadCashFlow.MutipleNoteId = '';
      downloadCashFlow.Pagename = 'Note';
      if (this.multiseltransactioncategory != undefined) {
        this.transacatename = this.multiseltransactioncategory.checkedItems.map(({ TransactionCategory }) => TransactionCategory);
        transactioncategoryname = this.multiseltransactioncategory.checkedItems.map(({ TransactionCategory }) => TransactionCategory).join('|')
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
      } else {
        if (filterednames.indexOf("_Default") >= 0) {
          filterednames = filterednames.replace("_Default", "");
        }
      }

      var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '-');
      var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '-');
      var fileName = this._note.CRENoteID + "_" + this.ScenarioName + filterednames + "_Cashflow_" + displayDate + "_" + displayTime + ".xlsx";

      this.noteService.getNoteCashflowsExportData(downloadCashFlow).subscribe(res => {
        let b: any = new Blob([res]);
        let dwldLink = document.createElement("a");
        let url = URL.createObjectURL(b);
        let isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
        if (isSafariBrowser) {  //if Safari open in new window to save file with random filename.
          dwldLink.setAttribute("target", "_blank");
        }
        dwldLink.setAttribute("href", url);
        dwldLink.setAttribute("download", fileName);
        dwldLink.style.visibility = "hidden";
        document.body.appendChild(dwldLink);
        dwldLink.click();
        document.body.removeChild(dwldLink);
        this._isnoteperiodiccalcFetching = false;
      });

    }
  }

  downloadFile(objArray) {
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
    } else {
      if (filterednames.indexOf("_Default") >= 0) {
        filterednames = filterednames.replace("_Default", "");
      }
    }
    var fileName = this._note.CRENoteID + "_" + this.ScenarioName + filterednames + "_Cashflow_" + displayDate + "_" + displayTime + ".csv";


    let blob = new Blob(['\ufeff' + data], { type: 'text/csv;charset=utf-8;' });
    let dwldLink = document.createElement("a");
    let url = URL.createObjectURL(blob);
    let isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
    if (isSafariBrowser) {  //if Safari open in new window to save file with random filename.
      dwldLink.setAttribute("target", "_blank");
    }
    dwldLink.setAttribute("href", url);
    dwldLink.setAttribute("download", fileName);
    dwldLink.style.visibility = "hidden";
    document.body.appendChild(dwldLink);
    dwldLink.click();
    document.body.removeChild(dwldLink);
  }

  // convert Json to CSV data in Angular2
  ConvertToCSV(objArray) {
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
        if (line != '') line += ','

        line += array[i][index];
      }
      str += line + '\r\n';
    }
    return str;
  }

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

  AssignDate() {
    if (this._note.StartDate != null) { this._noteDateObjects.StartDate = this._note.StartDate; }
    if (this._note.EndDate != null) { this._noteDateObjects.EndDate = (this._note.EndDate); }
    if (this._note.InitialInterestAccrualEndDate != null) { this._noteDateObjects.InitialInterestAccrualEndDate = (this._note.InitialInterestAccrualEndDate); }
    if (this._note.FirstPaymentDate != null) { this._noteDateObjects.FirstPaymentDate = (this._note.FirstPaymentDate); }
    if (this._note.InitialMonthEndPMTDateBiWeekly != null) { this._noteDateObjects.InitialMonthEndPMTDateBiWeekly = (this._note.InitialMonthEndPMTDateBiWeekly); }
    if (this._note.FinalInterestAccrualEndDateOverride != null) { this._noteDateObjects.FinalInterestAccrualEndDateOverride = (this._note.FinalInterestAccrualEndDateOverride); }
    if (this._note.FirstRateIndexResetDate != null) { this._noteDateObjects.FirstRateIndexResetDate = (this._note.FirstRateIndexResetDate); }
    // if (this._note.SelectedMaturityDate != null) { this._noteDateObjects.SelectedMaturityDate = (this._note.SelectedMaturityDate); }
    // if (this._note.InitialMaturityDate != null) { this._noteDateObjects.InitialMaturityDate = (this._note.InitialMaturityDate); }
    if (this._note.ExpectedMaturityDate != null) { this._noteDateObjects.ExpectedMaturityDate = (this._note.ExpectedMaturityDate); }
    // if (this._note.FullyExtendedMaturityDate != null) { this._noteDateObjects.FullyExtendedMaturityDate = (this._note.FullyExtendedMaturityDate); }

    if (this._note.OpenPrepaymentDate != null) { this._noteDateObjects.OpenPrepaymentDate = (this._note.OpenPrepaymentDate); }
    if (this._note.FinancingInitialMaturityDate != null) { this._noteDateObjects.FinancingInitialMaturityDate = (this._note.FinancingInitialMaturityDate); }
    if (this._note.FinancingExtendedMaturityDate != null) { this._noteDateObjects.FinancingExtendedMaturityDate = (this._note.FinancingExtendedMaturityDate); }
    if (this._note.ClosingDate != null) { this._noteDateObjects.ClosingDate = (this._note.ClosingDate); }

    // if (this._note.ExtendedMaturityScenario1 != null) { this._noteDateObjects.ExtendedMaturityScenario1 = (this._note.ExtendedMaturityScenario1); }
    // if (this._note.ExtendedMaturityScenario2 != null) { this._noteDateObjects.ExtendedMaturityScenario2 = (this._note.ExtendedMaturityScenario2); }
    //  if (this._note.ExtendedMaturityScenario3 != null) { this._noteDateObjects.ExtendedMaturityScenario3 = (this._note.ExtendedMaturityScenario3); }
    if (this._note.ActualPayoffDate != null) { this._noteDateObjects.ActualPayoffDate = (this._note.ActualPayoffDate); }

    if (this._note.PurchaseDate != null) { this._noteDateObjects.PurchaseDate = (this._note.PurchaseDate); }
    if (this._note.ValuationDate != null) { this._noteDateObjects.ValuationDate = (this._note.ValuationDate); }
    if (this._note.lastCalcDateTime != null) { this._noteDateObjects.lastCalcDateTime = (this._note.lastCalcDateTime); }

    if (this.MaturityEffectiveDate != null) { this._noteDateObjects.MaturityEffectiveDate = (this.MaturityEffectiveDate); }
    if (this.MaturityDate != null) { this._noteDateObjects.MaturityDate = (this.MaturityDate); }

    if (this.Servicing_EffectiveDate != null) { this._noteDateObjects.Servicing_EffectiveDate = (this.Servicing_EffectiveDate); }
    if (this.Servicing_Date != null) { this._noteDateObjects.Servicing_Date = (this.Servicing_Date); }

    if (this.PIKSchedule_EffectiveDate != null) { this._noteDateObjects.PIKSchedule_EffectiveDate = (this.PIKSchedule_EffectiveDate); }
    if (this.PIKSchedule_StartDate != null) { this._noteDateObjects.PIKSchedule_StartDate = (this.PIKSchedule_StartDate); }
    if (this.PIKSchedule_EndDate != null) { this._noteDateObjects.PIKSchedule_EndDate = (this.PIKSchedule_EndDate); }

    if (this.Ratespread_EffectiveDate != null) { this._noteDateObjects.Ratespread_EffectiveDate = (this.Ratespread_EffectiveDate); }
    if (this.PrepayAndAdditionalFeeSchedule_EffectiveDate != null) { this._noteDateObjects.PrepayAndAdditionalFeeSchedule_EffectiveDate = (this.PrepayAndAdditionalFeeSchedule_EffectiveDate); }
    if (this.StrippingSchedule_EffectiveDate != null) { this._noteDateObjects.StrippingSchedule_EffectiveDate = (this.StrippingSchedule_EffectiveDate); }
    if (this.FinancingFeeSchedule_EffectiveDate != null) { this._noteDateObjects.FinancingFeeSchedule_EffectiveDate = (this.FinancingFeeSchedule_EffectiveDate); }
    if (this.FinancingSchedule_EffectiveDate != null) { this._noteDateObjects.FinancingSchedule_EffectiveDate = (this.FinancingSchedule_EffectiveDate); }
    if (this.DefaultSchedule_EffectiveDate != null) { this._noteDateObjects.DefaultSchedule_EffectiveDate = (this.DefaultSchedule_EffectiveDate); }
    if (this._note.NoteTransferDate != null) { this._noteDateObjects.NoteTransferDate = (this._note.NoteTransferDate); }
    if (this._note.FirstIndexDeterminationDateOverride != null) { this._noteDateObjects.FirstIndexDeterminationDateOverride = (this._note.FirstIndexDeterminationDateOverride); }
  }


  Addnewfunding(e: wjcGrid.CellEditEndingEventArgs) {

    if (e.col.toString() == "3") {
      this.CustomAlert("Please enter Date or Amount before checking Wire confirm.");
      e.cancel = true;
    }
  }

  ReassignDate() {
    setTimeout(function () {
      if (this._note.StartDate != null) { this._note.StartDate = this._noteDateObjects.StartDate; }
      if (this._note.EndDate != null) { this._note.EndDate = this._noteDateObjects.EndDate; }
      if (this._note.InitialInterestAccrualEndDate != null) { this._note.InitialInterestAccrualEndDate = this._noteDateObjects.InitialInterestAccrualEndDate; }
      if (this._note.FirstPaymentDate != null) { this._note.FirstPaymentDate = this._noteDateObjects.FirstPaymentDate; }
      if (this._note.InitialMonthEndPMTDateBiWeekly != null) { this._note.InitialMonthEndPMTDateBiWeekly = this._noteDateObjects.InitialMonthEndPMTDateBiWeekly; }
      if (this._note.FinalInterestAccrualEndDateOverride != null) { this._note.FinalInterestAccrualEndDateOverride = this._noteDateObjects.FinalInterestAccrualEndDateOverride; }
      if (this._note.FirstRateIndexResetDate != null) { this._note.FirstRateIndexResetDate = this._noteDateObjects.FirstRateIndexResetDate; }
      if (this._note.SelectedMaturityDate != null) { this._note.SelectedMaturityDate = this._noteDateObjects.SelectedMaturityDate; }
      if (this._note.InitialMaturityDate != null) { this._note.InitialMaturityDate = this._noteDateObjects.InitialMaturityDate; }
      if (this._note.ExpectedMaturityDate != null) { this._note.ExpectedMaturityDate = this._noteDateObjects.ExpectedMaturityDate; }
      if (this._note.FullyExtendedMaturityDate != null) { this._note.FullyExtendedMaturityDate = this._noteDateObjects.FullyExtendedMaturityDate; }
      if (this._note.OpenPrepaymentDate != null) { this._note.OpenPrepaymentDate = this._noteDateObjects.OpenPrepaymentDate; }
      if (this._note.FinancingInitialMaturityDate != null) { this._note.FinancingInitialMaturityDate = this._noteDateObjects.FinancingInitialMaturityDate; }
      if (this._note.FinancingExtendedMaturityDate != null) { this._note.FinancingExtendedMaturityDate = this._noteDateObjects.FinancingExtendedMaturityDate; }
      if (this._note.ClosingDate != null) { this._note.ClosingDate = this._noteDateObjects.ClosingDate; }

      if (this._note.ExtendedMaturityScenario1 != null) { this._note.ExtendedMaturityScenario1 = this._noteDateObjects.ExtendedMaturityScenario1; }
      if (this._note.ExtendedMaturityScenario2 != null) { this._note.ExtendedMaturityScenario2 = this._noteDateObjects.ExtendedMaturityScenario2; }
      if (this._note.ExtendedMaturityScenario3 != null) { this._note.ExtendedMaturityScenario3 = this._noteDateObjects.ExtendedMaturityScenario3; }
      if (this._note.ActualPayoffDate != null) { this._note.ActualPayoffDate = this._noteDateObjects.ActualPayoffDate; }

      if (this._note.PurchaseDate != null) { this._note.PurchaseDate = this._noteDateObjects.PurchaseDate; }
      if (this._note.ValuationDate != null) { this._note.ValuationDate = this._noteDateObjects.ValuationDate; }
      if (this._note.lastCalcDateTime != null) { this._note.lastCalcDateTime = this._noteDateObjects.lastCalcDateTime; }

      if (this.MaturityEffectiveDate != null) { this.MaturityEffectiveDate = this._noteDateObjects.MaturityEffectiveDate; }
      if (this.MaturityDate != null) { this.MaturityDate = this._noteDateObjects.MaturityDate; }

      if (this.Servicing_EffectiveDate != null) { this.Servicing_EffectiveDate = this._noteDateObjects.Servicing_EffectiveDate; }
      if (this.Servicing_Date != null) { this.Servicing_Date = this._noteDateObjects.Servicing_Date; }

      if (this.PIKSchedule_EffectiveDate != null) { this.PIKSchedule_EffectiveDate = this._noteDateObjects.PIKSchedule_EffectiveDate; }
      if (this.PIKSchedule_StartDate != null) { this.PIKSchedule_StartDate = this._noteDateObjects.PIKSchedule_StartDate; }
      if (this.PIKSchedule_EndDate != null) { this.PIKSchedule_EndDate = this._noteDateObjects.PIKSchedule_EndDate; }

      if (this.Ratespread_EffectiveDate != null) { this.Ratespread_EffectiveDate = this._noteDateObjects.Ratespread_EffectiveDate; }
      if (this.PrepayAndAdditionalFeeSchedule_EffectiveDate != null) { this.PrepayAndAdditionalFeeSchedule_EffectiveDate = this._noteDateObjects.PrepayAndAdditionalFeeSchedule_EffectiveDate; }
      if (this.StrippingSchedule_EffectiveDate != null) { this.StrippingSchedule_EffectiveDate = this._noteDateObjects.StrippingSchedule_EffectiveDate; }
      if (this.FinancingFeeSchedule_EffectiveDate != null) { this.FinancingFeeSchedule_EffectiveDate = this._noteDateObjects.FinancingFeeSchedule_EffectiveDate; }
      if (this.FinancingSchedule_EffectiveDate != null) { this.FinancingSchedule_EffectiveDate = this._noteDateObjects.FinancingSchedule_EffectiveDate; }
      if (this.DefaultSchedule_EffectiveDate != null) { this.DefaultSchedule_EffectiveDate = this._noteDateObjects.DefaultSchedule_EffectiveDate; }
      if (this._note.NoteTransferDate != null) { this._note.NoteTransferDate = this._noteDateObjects.NoteTransferDate; }

      if (this._note.FirstIndexDeterminationDateOverride != null) { this._note.FirstIndexDeterminationDateOverride = this._noteDateObjects.FirstIndexDeterminationDateOverride; }
    }.bind(this), 30000);
  }

  Checkequal(dt1, dt2) {
    var equal = null;
    var date1 = new Date(dt1);
    var date2 = new Date(dt2);
    if (date1 > date2) {
      equal = false;
    } else if (date1 < date2) {
      equal = false;
    } else {
      equal = true;
    }

    return equal;
  }

  ValidateNoteAndSave(): void {
    var errorstring = "";
    var effectiveerror = "";
    var amorterrorstring = "";
    var RuleTypeFileNameerror = '';
    var purposeerrorstring = "";
    var msg = "";
    var msgmatfundingdate = "";
    var msgdialog = "";
    var fundingdateval = "";

    var currentdate = new Date();
    var currentmatdate: any;
    var errorlstmarketprice = "";
    var errmarketprice = "";
    var effectiveDateerrorstring = "";

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
    if (this._noteext.RateSpreadScheduleList.length > 0) {
      if (!this.Ratespread_EffectiveDate) {
        amorterrorstring = amorterrorstring + "<p>" + "Please enter Rate Spread Effective date." + "</p>";
      }
    }
    if (this._noteext.NotePrepayAndAdditionalFeeScheduleList.length > 0) {
      if (!this.PrepayAndAdditionalFeeSchedule_EffectiveDate) {
        amorterrorstring = amorterrorstring + "<p>" + "Please enter Fee schedule Effective date." + "</p>";
      }
    }

    if (this._noteext.lstFinancingFeeSchedule.length > 0) {
      if (this._noteext.lstFinancingFeeSchedule[0].Date) {
        if (!this.FinancingFeeSchedule_EffectiveDate) {
          amorterrorstring = amorterrorstring + "<p>" + "Please enter Financing fee schedule Effective date." + "</p>";
        }
      }
    }

    if (this.PIKSchedule_EndDate != null) {
      if (this.PIKSchedule_EndDate < this.PIKSchedule_StartDate) {
        amorterrorstring = amorterrorstring + "<p>" + "PIK End Date must be greater than PIK Start Date." + "</p>";
      }
    }

    //if (this._note.LastAccountingCloseDate != null) {
    //  if (this.Ratespread_EffectiveDate != null)
    //  {
    //    if (this.Checkequal(this.Ratespread_EffectiveDate, this._note.ClosingDate) == false)
    //    {
    //      var neweffective = new Date(this.Ratespread_EffectiveDate);
    //      var oldeffective = new Date(this.Ratespread_EffectiveDateOld);
    //      if (neweffective != oldeffective) {
    //        if (this.Ratespread_EffectiveDate < this._note.LastAccountingCloseDate)
    //        {
    //          amorterrorstring = amorterrorstring + "<p>" + "Rate Spread effective date cannnot be before last accounting date " + this.convertDateToBindable(this._note.LastAccountingCloseDate) + ".</p>";
    //        }

    //      } else {
    //        if (this.cvRateSpreadScheduleList.itemsEdited.length > 0) {
    //          if (this.Ratespread_EffectiveDate < this._note.LastAccountingCloseDate) {
    //            amorterrorstring = amorterrorstring + "<p>" + "Rate Spread effective date cannnot be before last accounting date " + this.convertDateToBindable(this._note.LastAccountingCloseDate) + ".</p>";
    //          }
    //        }
    //      }
    //    }
    //  }
    //}

    if (this._note.LastAccountingCloseDate != null) {
      if (this.Ratespread_EffectiveDate != null) {

        var neweffective = new Date(this.Ratespread_EffectiveDate);
        var oldeffective = new Date(this.Ratespread_EffectiveDateOld);

        if (this.Checkequal(neweffective, oldeffective) == false) {
          if (this.Ratespread_EffectiveDate < this._note.LastAccountingCloseDate) {
            amorterrorstring = amorterrorstring + "<p>" + "Rate spread schedule effective date cannnot be before last accounting date " + this.convertDateToBindable(this._note.LastAccountingCloseDate) + ".</p>";
          }

        } else {
          if (this.cvRateSpreadScheduleList.itemsEdited.length > 0) {
            if (this.Ratespread_EffectiveDate < this._note.LastAccountingCloseDate) {
              amorterrorstring = amorterrorstring + "<p>" + "Rate spread schedule effective date cannnot be before last accounting date " + this.convertDateToBindable(this._note.LastAccountingCloseDate) + ".</p>";
            }
          }
        }

      }

      if (this.PrepayAndAdditionalFeeSchedule_EffectiveDate != null) {

        var neweffective = new Date(this.PrepayAndAdditionalFeeSchedule_EffectiveDate);
        var oldeffective = new Date(this.PrepayAndAdditionalFeeSchedule_EffectiveDateOld);

        if (this.Checkequal(neweffective, oldeffective) == false) {
          if (this.PrepayAndAdditionalFeeSchedule_EffectiveDate < this._note.LastAccountingCloseDate) {
            amorterrorstring = amorterrorstring + "<p>" + "Fee schedule effective date cannnot be before last accounting date " + this.convertDateToBindable(this._note.LastAccountingCloseDate) + ".</p>";
          }

        } else {
          if (this.cvNotePrepayAndAdditionalFeeScheduleList.itemsEdited.length > 0) {
            if (this.PrepayAndAdditionalFeeSchedule_EffectiveDate < this._note.LastAccountingCloseDate) {
              amorterrorstring = amorterrorstring + "<p>" + "Fee schedule effective date cannnot be before last accounting date " + this.convertDateToBindable(this._note.LastAccountingCloseDate) + ".</p>";
            }
          }
        }

      }

    }





    if (this._noteext.NoteFinancingScheduleList.length > 0) {
      if (this._noteext.NoteFinancingScheduleList[0].Date) {
        if (!this.FinancingSchedule_EffectiveDate) {
          amorterrorstring = amorterrorstring + "<p>" + "Please enter Financing schedule Effective date." + "</p>";
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
          amorterrorstring = amorterrorstring + "<p>" + "The total of amort payments should not be greater than the Total Commitment amount(Accounting tab) of the note" + "</p>"
        }

        if (this.PIKSchedule_EffectiveDate != null) {
          var newdate = (this.PIKSchedule_EffectiveDate);
          var olddate = (this.PIKSchedule_EffectiveDateOld);
          if (newdate < olddate) {
            effectiveerror = effectiveerror + "<p>" + "Effective date in PIK Schedule cannot be smaller than " + olddate.toLocaleDateString("en-US").toString().replace('T00', 'T17').split(' ', 4).join(' ') + "</p>";
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
            this.changedlstmarketnote.push(this._note.ListNoteMarketPrice[j]);
          }
        }
        else {
          this.changedlstmarketnote.push(this._note.ListNoteMarketPrice[j]);
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
      } else if (msgdialog != "") {
        this.savedialogmsg = msgdialog + "<p>" + "Do you want to proceed with save?" + "</p>";
        this.CustomDialogteSave();

      }
      else {
        if (this._isShowMsgForUseRuletoDetermine == false && this._note.FFLastUpdatedDate_String != null && this._isCallConcurrentCheck == true) {
          //vishal
          this.noteService.CheckConcurrentUpdate(this._note).subscribe(res => {
            if (res.Succeeded) {
              if (res.Message == "") {
                this.SaveNotefunc(this._note, 'Save');
              }
              else {
                this.CustomAlert(res.Message);
              }
            }
          });
        }
        else {
          this.SaveNotefunc(this._note, 'Save');
        }
      }


    }
  }

  CustomDialogteSave(): void {
    var winW = window.innerWidth;
    var winH = window.innerHeight;
    var dialogbox = document.getElementById('Genericdialogbox');
    document.getElementById('savedialogmessage').innerHTML = this.savedialogmsg;

    dialogbox.style.display = "block";
    $.getScript("/js/jsDrag.js");

  }

  SendPushNotification(objectId: string): void {

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
    _notificationMsg = _module + '|*|' + _notificationMsg + '|*|' + appsettings.Notificationsettings._notificationenvironment + '|*|' + _userData.UserID;
    this._signalRService.SendNotification(_notificationMsg);

  }

  chkDateValidation(): boolean {
    this._errorMsgDateValidation = "";
    //if (this._isConvertDate == false)
    // validation for invidual controls
    {
      if (this._note.StartDate != null) { this.chkDateValidationToControl(this._note.StartDate, "StartDate"); }
      if (this._note.EndDate != null) { this.chkDateValidationToControl(this._note.EndDate, "EndDate"); }
      if (this._note.InitialInterestAccrualEndDate != null) { this.chkDateValidationToControl(this._note.InitialInterestAccrualEndDate, "InitialInterestAccrualEndDate"); }
      if (this._note.FirstPaymentDate != null) { this.chkDateValidationToControl(this._note.FirstPaymentDate, "FirstPaymentDate"); }
      if (this._note.InitialMonthEndPMTDateBiWeekly != null) { this.chkDateValidationToControl(this._note.InitialMonthEndPMTDateBiWeekly, "InitialMonthEndPMTDateBiWeekly"); }
      if (this._note.FinalInterestAccrualEndDateOverride != null) { this.chkDateValidationToControl(this._note.FinalInterestAccrualEndDateOverride, "FinalInterestAccrualEndDateOverride"); }
      if (this._note.FirstRateIndexResetDate != null) { this.chkDateValidationToControl(this._note.FirstRateIndexResetDate, "FirstRateIndexResetDate"); }
      // if (this._note.SelectedMaturityDate != null) { this.chkDateValidationToControl(this._note.SelectedMaturityDate, "SelectedMaturityDate"); }
      //if (this._note.InitialMaturityDate != null) { this.chkDateValidationToControl(this._note.InitialMaturityDate, "InitialMaturityDate"); }
      if (this._note.ExpectedMaturityDate != null) { this.chkDateValidationToControl(this._note.ExpectedMaturityDate, "ExpectedMaturityDate"); }
      //if (this._note.FullyExtendedMaturityDate != null) { this.chkDateValidationToControl(this._note.FullyExtendedMaturityDate, "FullyExtendedMaturityDate"); }
      if (this._note.OpenPrepaymentDate != null) { this.chkDateValidationToControl(this._note.OpenPrepaymentDate, "OpenPrepaymentDate"); }
      if (this._note.FinancingInitialMaturityDate != null) { this.chkDateValidationToControl(this._note.FinancingInitialMaturityDate, "FinancingInitialMaturityDate"); }
      if (this._note.FinancingExtendedMaturityDate != null) { this.chkDateValidationToControl(this._note.FinancingExtendedMaturityDate, "FinancingExtendedMaturityDate"); }

      if (this._note.ClosingDate != null) { this.chkDateValidationToControl(this._note.ClosingDate, "ClosingDate"); }

      //if (this._note.ExtendedMaturityScenario1 != null) { this.chkDateValidationToControl(this._note.ExtendedMaturityScenario1, "ExtendedMaturityScenario1"); }
      //if (this._note.ExtendedMaturityScenario2 != null) { this.chkDateValidationToControl(this._note.ExtendedMaturityScenario2, "ExtendedMaturityScenario2"); }
      // if (this._note.ExtendedMaturityScenario3 != null) { this.chkDateValidationToControl(this._note.ExtendedMaturityScenario3, "ExtendedMaturityScenario3"); }
      if (this._note.ActualPayoffDate != null) { this.chkDateValidationToControl(this._note.ActualPayoffDate, "ActualPayoffDate"); }

      if (this._note.PurchaseDate != null) { this.chkDateValidationToControl(this._note.PurchaseDate, "PurchaseDate"); }
      if (this._note.ValuationDate != null) { this.chkDateValidationToControl(this._note.ValuationDate, "ValuationDate"); }
      if (this._note.lastCalcDateTime != null) { this.chkDateValidationToControl(this._note.lastCalcDateTime, "lastCalcDateTime"); }

      if (this.MaturityEffectiveDate != null) { this.chkDateValidationToControl(this.MaturityEffectiveDate, "MaturityEffectiveDate"); }
      if (this.MaturityDate != null) { this.chkDateValidationToControl(this.MaturityDate, "MaturityDate"); }

      if (this.Servicing_EffectiveDate != null) { this.chkDateValidationToControl(this.Servicing_EffectiveDate, "Servicing_EffectiveDate"); }
      if (this.Servicing_Date != null) { this.chkDateValidationToControl(this.Servicing_Date, "Servicing_Date"); }

      if (this.PIKSchedule_EffectiveDate != null) { this.chkDateValidationToControl(this.PIKSchedule_EffectiveDate, "PIKSchedule_EffectiveDate"); }
      if (this.PIKSchedule_StartDate != null) { this.chkDateValidationToControl(this.PIKSchedule_StartDate, "PIKSchedule_StartDate"); }
      if (this.PIKSchedule_EndDate != null) { this.chkDateValidationToControl(this.PIKSchedule_EndDate, "PIKSchedule_EndDate"); }

      if (this.Ratespread_EffectiveDate != null) { this.chkDateValidationToControl(this.Ratespread_EffectiveDate, "Ratespread_EffectiveDate"); }
      if (this.PrepayAndAdditionalFeeSchedule_EffectiveDate != null) { this.chkDateValidationToControl(this.PrepayAndAdditionalFeeSchedule_EffectiveDate, "PrepayAndAdditionalFeeSchedule_EffectiveDate"); }
      if (this.StrippingSchedule_EffectiveDate != null) { this.chkDateValidationToControl(this.StrippingSchedule_EffectiveDate, "StrippingSchedule_EffectiveDate"); }
      if (this.FinancingFeeSchedule_EffectiveDate != null) { this.chkDateValidationToControl(this.FinancingFeeSchedule_EffectiveDate, "FinancingFeeSchedule_EffectiveDate"); }
      if (this.FinancingSchedule_EffectiveDate != null) { this.chkDateValidationToControl(this.FinancingSchedule_EffectiveDate, "FinancingSchedule_EffectiveDate"); }
      if (this.DefaultSchedule_EffectiveDate != null) { this.chkDateValidationToControl(this.DefaultSchedule_EffectiveDate, "DefaultSchedule_EffectiveDate"); }
      if (this._note.NoteTransferDate != null) { this.chkDateValidationToControl(this._note.NoteTransferDate, "NoteTransferDate"); }
      if (this._note.FirstIndexDeterminationDateOverride != null) { this.chkDateValidationToControl(this._note.FirstIndexDeterminationDateOverride, "FirstIndexDeterminationDateOverride"); }
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
  }

  chkDateValidationToControl(date: Date, moduleName: string) {
    if (date != null) {
      var controlDate = new Date(date);
      var systemDate = new Date(this.utilityService.getDateMinRange());
      if (controlDate < systemDate) {
        this._errorMsgDateValidation += moduleName + ", "
      }

      return "";
    }
    else
      return "";
  }

  chkDateValidationToGrid(Data, modulename) {
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
  }


  Savedialogbox(): void {
    this.SaveNotefunc(this._note, 'Save');
    this.ClosePopUpDialog();
  }

  ClosePopUpDialog() {
    var modal = document.getElementById('Genericdialogbox');
    modal.style.display = "none";
  }

  AppliedReadOnly() {
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
  }

  convertDateToBindable(date) {
    var dateObj = new Date(date);
    return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear();
  }

  getTwoDigitString(number) {
    if (number.toString().length === 1)
      return "0" + number;
    return number;
  }

  celleditfunding(futurefundingflex: wjcGrid.FlexGrid, e: wjcGrid.CellEditEndingEventArgs) {

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
      var maxappliedDate = new Date(Math.max.apply(null, this._noteext.ListFutureFundingScheduleTab.filter(x => x.Applied == true).map(x => x.Date)));

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
        var sdate = this._noteext.ListFutureFundingScheduleTab[e.row].Date

        if (!(sdate === undefined) && sdate != null) {
          var formateddate = this.convertDateToBindable(sdate);
          var dealfundingday = new Date(sdate).getDay();
          if (dealfundingday == 6 || dealfundingday == 0
            || this.ListHoliday.filter(x => this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411).length > 0
          ) {
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

        if (this.futurefundingflex.rows[tprow].isReadOnly == false && this.futurefundingflex.rows[tprow].dataItem.Applied == true) {
          this.futurefundingflex.rows[tprow].dataItem.Applied = false;
          this.CustomAlert("Please enter Date or Amount before checking Wire confirm.");
          this.futurefundingflex.select(this.futurefundingflex.rows.length - 1, 0);
          // focus on select row and ready for editing
          this.futurefundingflex.focus();

          return;
        }
      }
    }

  }

  getnexybusinessDate(sDate: Date, noofDays: number): Date {
    var daycnt = sDate.getDay();
    if (daycnt == 6)
      sDate.setDate(sDate.getDate() + 1);
    if (daycnt == 1 || daycnt == 2 || daycnt == 3 || daycnt == 4 || daycnt == 5)
      sDate.setDate(sDate.getDate() + 2);

    sDate.setDate(sDate.getDate() + noofDays);

    return sDate;
  }

  ImportDocument() {

    this.saveFiles();
  }
  saveFiles() {
    this.isProcessComplete = true;
    let files = this.files;
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
      let formData: FormData = new FormData();
      for (var j = 0; j < files.length; j++) {
        formData.append("file[]", files[j][0], files[j][0].name);
      }

      var user = JSON.parse(localStorage.getItem('user'));
      var parameters = {
        userid: user.UserID,
        comment: this._document.Comment,
        documentTypeID: this._document.DocumentTypeID,
        ObjectID: this._note.NoteId,
        ObjectTypeID: 182,
        StorageType: appsettings._storageType,
        FolderName: this._note.CRENoteID,
        ParentFolderName: this._note.CREDealID
      }

      this.fileUploadService.uploadObjectDocumentByStorageType(formData, parameters)
        .subscribe(
          success => {
            this.IsOpenActivityTab = false;
            //alert('success ' + success);
            var smessage = success.Message.split('==');
            //alert(smessage);
            //alert(smessage[0]);
            if (smessage[0] == "Success") {
              this.uploadStatus.emit(true);
              //    console.log(success);

              //localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
              //localStorage.setItem('WarmsgdashBoad', JSON.stringify('File uploaded successfully'));

              this._Showmessagenotediv = true;
              this._ShowmessagenotedivMsg = "File uploaded successfully";
              setTimeout(function () {
                this._Showmessagenotediv = false;
                this._ShowmessagenotedivMsg = "";
                //   console.log(this._ShowmessagedivWar);
              }.bind(this), 5000);

              //this._router.navigate(['/dashboard']);
              //call load document function

              //reset ng2-file-input control after error occoured
              this.resetFileInput();
              //alert('getDocumentList');
              this._pageIndexDocImport = 1;
              this.getDocumentList();
              this._document.DocumentTypeID = "406";
              this._document.Comment = '';
            }
            else {

              this.uploadStatus.emit(true);
              // console.log(success);
              this._ShowmessagenotedivWar = true;
              this._ShowmessagenotedivMsgWar = smessage[1];
              //this.isProcessComplete = false;
              setTimeout(function () {
                this._ShowmessagenotedivWar = false;
              }.bind(this), 5000);

              //reset ng2-file-input control after error occoured
              this.resetFileInput();
            }
            this.isProcessComplete = false;
            this.fileList = null;
          },
          error => {

            this.isProcessComplete = false;
            this.uploadStatus.emit(true);
            this.errors.push(error.ExceptionMessage);
          })
      this.files = [];
    }

  }

  DocumentTypeIDChange(newvalue): void {
    this._document.DocumentTypeID = newvalue;
  }
  ArchiveDocument(): void {
    this._isNoteSaving = true;
    var lstDoc = this.lstDocuments.filter(x => x.UploadedDocumentLogID == this._uploadedDocumentLogID);
    lstDoc.forEach((obj, i) => { obj.Status = 423 });

    if (lstDoc.length > 0) {
      this.fileUploadService.updateDocumentStatus(lstDoc).subscribe(res => {
        if (res.Succeeded) {
          this.ClosePopUpArchive();
          this.getDocumentList()
          this._isNoteSaving = false;

          this._Showmessagenotediv = true;
          this._ShowmessagenotedivMsg = "File archived successfully";
          setTimeout(function () {
            this._Showmessagenotediv = false;
            this._ShowmessagenotedivMsg = "";
            //   console.log(this._ShowmessagedivWar);
          }.bind(this), 5000);
        }

        else {
          this.utilityService.navigateToSignIn();
        }
      });
      error => {
        this._isNoteSaving = false;
        console.error('Error: ' + error)
        this.ClosePopUpArchive();
      }
    }

  }

  getDocumentList(): void {

    this._isNoteSaving = true;
    this._document.ObjectTypeID = '182';
    this._document.ObjectID = this._note.NoteId;
    var d = new Date();
    var datestring = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate() + " " +
      d.getHours() + ":" + d.getMinutes();

    this._document.CurrentTime = datestring;
    this._document.Status = 1;

    this.fileUploadService.getDocumentsByObjectId(this._document, this._pageIndexDocImport, this._pageSizeDocImport).subscribe(res => {
      if (res.Succeeded) {
        var data: any = res.lstDocument;
        if (data.length > 0) {
          for (var j = 0; j < data.length; j++) {
            if (data[j].Comment.toString() == "undefined") {
              data[j].Comment = null;
            }
          }
        }
        this._totalCountDocImport = res.TotalCount;

        if (this._pageIndexDocImport == 1) {
          this.lstDocuments = data;
          if (this._totalCountDocImport == 0) {
            this._dvEmptyDocumentMsg = true;
          }
          else {
            this._dvEmptyDocumentMsg = false;
            setTimeout(function () {
              this.flexDocument.invalidate();
              //remove first cell selection
              this.flexDocument.selectionMode = wjcGrid.SelectionMode.None;
              //this.flexDocument.autoSizeColumns(0, this.flexDocument.columns.length, false, 20);
              //this.flexDocument.columns[0].width = 350; // for Note Id
              this.addScrollHandler();
            }.bind(this), 500);
          }

        }
        else {
          this.lstDocuments = this.lstDocuments.concat(data);
        }
        this._isNoteSaving = false;



      }
      else {
        this.utilityService.navigateToSignIn();
      }
    });
    error => console.error('Error: ' + error)
  }

  showDocImport() {
    if (!this.IsOpenDocImportTab) {

      setTimeout(() => {
        this.getDocumentList();
        this.IsOpenDocImportTab = true;
        //if (this.flexDocument) {
        //    this.flexDocument.invalidate(true);

        //    this.flexDocument.autoSizeColumns();
        //}
      }, 200);
    }
  }

  addScrollHandler() {
    if (!this.isScrollHandlerAdded) {
      this.flexDocument.scrollPositionChanged.addHandler(() => {
        var myDiv = $('#flexDocument').find('div[wj-part="root"]');
        if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
          if (this.flexDocument.rows.length < this._totalCountDocImport) {
            this._pageIndexDocImport = this._pageIndexDocImport + 1;
            this.IsOpenDocImportTab = false;
            this.showDocImport();
          }
        }
      });
      this.isScrollHandlerAdded = true;
    }
  }

  onFileDropped(files) {
    this.onAction(files, 'drop');
  }

  public onAction(event: any, mode: any) {

    if (mode == 'drop') {
      this.files.push(event);
    } else {
      this.files.push(event.target.files);
    }
    if (this.files.length > 1) {
      this.actionLog = '';
      this.actionLog += "\n currentFiles: " + this.getFileNames(this.files);
    }
    else {
      if (mode == 'drop') {
        this.actionLog += "\n currentFiles: " + event[0].name;
      } else {
        this.actionLog += "\n currentFiles: " + event.target.files[0].name;
      }
    }
    //let fileList: FileList = event.currentFiles;
    //this.saveFiles(this.fileList);
  }

  public onAdded(event: any) {
    this.actionLog += "\n FileInput: " + event.id;
    this.actionLog += "\n Action: File added";

  }
  public onRemoved(event: any) {
    this.actionLog += "\n FileInput: " + event.id;
    this.actionLog += "\n Action: File removed";
  }

  public onCouldNotRemove(event: any) {
    this.actionLog += "\n FileInput: " + event.id;
    this.actionLog += "\n Action: Could not remove file";
  }

  public resetFileInput(): void {
    // this.ng2FileInputService.reset(this.myFileInputIdentifier);
  }

  public logCurrentFiles(): void {
    //let files = this.ng2FileInputService.getCurrentFiles(this.myFileInputIdentifier);
    //this.actionLog += "\n The currently added files are: " + this.getFileNames(files);
  }
  public getFileNames(files): string {
    let names = files.map(file => file.name);
    var newnames = names ? names.join(", ") : "No files currently added.";
    return newnames;
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
      var file;
      if (files[i].length > 0) {
        file = files[i][0];
      } else {
        file = files[i];
      }
      var ext = file.name.toUpperCase().split('.').pop() || file.name;
      // Check the extension exists
      var exists = extensions.includes(ext);
      if (!exists) {
        this.errors.push("<BR/>Please upload file " + file.name + " with " + this.fileExt + " extension.");
      }
      // Check file size
      this.isValidFileSize(file);
    }
  }

  private isValidFileSize(file) {
    var fileSizeinMB = file.size / (1024 * 1000);
    var size = Math.round(fileSizeinMB * 100) / 100; // convert upto 2 decimal place
    if (size > this.maxSize)
      this.errors.push("<BR/>Selected: " + file.name + ": exceed file size limit of " + this.maxSize + "MB ( " + size + "MB )");
  }

  getAllClient(): void {
    this.noteService.getAllClient().subscribe(res => {
      if (res.Succeeded) {
        this.lstClient = res.lstClient;
      }
    });
  }

  getAllFund(): void {
    this.noteService.getAllFund().subscribe(res => {
      if (res.Succeeded) {
        this.lstFund = res.lstFund;
      }
    });
  }

  getFeeTypesFromFeeSchedulesConfig(): void {
    this.noteService.getFeeTypesFromFeeSchedulesConfig().subscribe(res => {
      if (res.Succeeded) {
        this.lstFeeTypeLookUp = res.lstFeeTypeLookUp;
      }
    });
  }

  DownloadDocument(filename, originalfilename, storagetype, documentStorageID) {
    this.isProcessComplete = true;
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
        this.isProcessComplete = false;

      },
        error => {
          alert('Something went wrong');
          this.isProcessComplete = false;;
        }
      );
  }

  private GetHolidayList(): void {
    if (this.ListHoliday == null || this.ListHoliday === undefined)

      this.dealSrv.getHolidayList().subscribe(res => {
        if (res.Succeeded) {
          this.ListHoliday = res.HolidayList;
        }
        else
          this.ListHoliday = null;
      });
  }

  GetLookupForMaster(): void {
    this.noteService.GetLookupForMaster().subscribe(res => {
      var data = res.lstlookupMaster;
      this.lstServicerName = data.filter(x => x.ddlType == "ddlServicer");

    });
  }


  subscribetoevent(): void {

    this._signalRService.updateCalcNotification.subscribe((message: any) => {
      var res = message.split('|*|');
      if (res[0] == "CALCMGR") {

        var notelist = res[2];
        console.log(notelist);

      }
    })

  }

  lstfinancingsource: any;
  GetFinancingSource(): void {
    this.noteService.GetFinancingSource().subscribe(res => {
      if (res.Succeeded) {
        this.lstfinancingsource = res.lstfinancingsource;
      }
    });
  }


  ShowCountOnViewHistoryBtn() {
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
  }

  GetDefaultValue(val) {
    if (isNaN(val) || val == null) {
      return 0;
    }
    return val;
  }

  //CalculateAggregateTotal(): void {
  //    this._note.AdjustedTotalCommitment = this.GetDefaultValue(this._note.AdjustedTotalCommitment);
  //    this._note.TotalCommitment = this.GetDefaultValue(this._note.TotalCommitment);
  //    this._note.AggregatedTotal = parseFloat(this._note.TotalCommitment.toString()) + parseFloat(this._note.AdjustedTotalCommitment.toString());
  //}

  GetUserTimezoneByID() {
    this.membershipservice.GetUserTimeZonebyUserID().subscribe(res => {
      if (res.Succeeded) {
        var data = res.dt;
        this._timezoneAbbreviation = data[0].Abbreviation;
      }
    });
  }


  getTransactionTypes() {

    this.noteService.GetTransactionTypes().subscribe(res => {
      if (res.Succeeded == true) {
        this.listtransactiontype = res.dt;
      }
    });
    this._bindGridDropdows();
  }


  onContextMenu(grid, e) {
    var hti = grid.hitTest(e);
    if (hti.panel && hti.panel === grid.cells && hti.panel.columns[hti.col].binding === "CalculatedAmount") {
      if (this.ServicingLog_refreshlist[hti.row]["AllowCalculationOverride"] == 3) {
        if (this.ServicingLog_refreshlist[hti.row]["SourceType"] == "Modified")
          this.isResetMenuShow = true;
        else
          this.isResetMenuShow = false;
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
  }

  menuItemClicked(s, e) {
    var { row: selectedRow, col: selectedCol } = this.flexservicelog.selection;
    var { row: clickedRow, col: clickedCol } = this.hti;
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
  }


  celleditservicelog(flextrans: wjcGrid.FlexGrid, e: wjcGrid.CellEditEndingEventArgs): void {
    var transactiongroup = '';
    if (this.multiseltransactiongroup != undefined) {
      transactiongroup = this.multiseltransactiongroup.checkedItems.map(({ TransactionGroup }) => TransactionGroup).join('|')
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

      if (Delta == null && Delta == undefined) Delta = 0;
      if (Adjustment == null && Adjustment == undefined) Adjustment = 0;

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
        if (!M61_Value) M61_Value = 0;
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
  }


  pastedservicelog(grid, e) {
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



  }


  ContextMenuUpdatedialogbox() {
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

  }

  ContextMenuResetdialogbox() {
    let rownum;
    this.ServicingLog_refreshlist[this._ClckservicelogRow]["CalculatedAmount"] = this.ServicingLog_refreshlist[this._ClckservicelogRow]["TransactionEntryAmount"];
    this.ServicingLog_refreshlist[this._ClckservicelogRow]["Final_ValueUsedInCalc"] = this.ServicingLog_refreshlist[this._ClckservicelogRow]["TransactionEntryAmount"];
    this.ServicingLog_refreshlist[this._ClckservicelogRow]["SourceType"] = "Modified";
    this.ServicingLog_refreshlist[this._ClckservicelogRow]["ServicerMasterID"] = 99;
    this.flexservicelog.invalidate();
    this.CloseContextMenuDialog();
    var sr = this.ServicingLog_refreshlist[this._ClckservicelogRow];
    var serv = this._noteext.lstNoteServicingLog.filter(x => x.TransactionId == this.ServicingLog_refreshlist[this._ClckservicelogRow].TransactionId);
    if (serv)
      rownum = serv[0].row_num;
    var count = this.flexservicelogupdatedRowNo.indexOf(this._ClckservicelogRow);
    if (count == -1) {
      this.flexservicelogupdatedrow_num.push(rownum);
      this.flexservicelogupdatedRowNo.push(rownum);
      this.flexservicelogToUpdate.push(sr);
    }
  }


  GetTransactionCategory() {
    this.calculationsvc.GetTransactionCategory().subscribe(res => {
      if (res.Succeeded) {
        var data = res.dt;
        this.listtransactioncategory = data;
        var datagroup = res.dtGroup;
        if (datagroup) {
          this.listtransactions = datagroup;
          var list = [];
          var refreshlist = [];
          var transname = [];
          var interestindex;
          this.listtransactionname = datagroup.map(x => x.TransactionName);
          list = datagroup.map(x => x.TransactionGroup).filter((x, i, a) => a.indexOf(x) == i);
          interestindex = list.indexOf("Interest");
          for (var j = 0; j < list.length; j++) {
            if (j == interestindex) {
              this.listtransactiongroup.push({ "TransactionGroup": list[j], selected: list[interestindex] });
            }
            else {
              this.listtransactiongroup.push({ "TransactionGroup": list[j], selected: undefined });
            }
          }
          this.multiseltransactiongroup.showDropDownButton = true;
          for (var m = 0; m < this.listtransactions.length; m++) {
            if (this.listtransactions[m].TransactionGroup == "Interest") {
              transname = this.listtransactions.filter(x => x.TransactionGroup == this.listtransactions[m].TransactionGroup);
            }
          }
          for (var l = 0; l < transname.length; l++) {
            if (this._noteext.lstNoteServicingLog) {
              for (var j = 0; j < this._noteext.lstNoteServicingLog.length; j++) {
                if (transname[l].TransactionName == this._noteext.lstNoteServicingLog[j].TransactionTypeText) {
                  refreshlist.push(this._noteext.lstNoteServicingLog[j]);
                }
              }
            }
          }

          refreshlist.sort(this.dynamicSort("row_num"));
          //  refreshlist.sort(this.dynamicSort("RemittanceDate"));

          this.ServicingLog_refreshlist = refreshlist;
          this.cvNoteServicingLog = new wjcCore.CollectionView(refreshlist);
          this.cvNoteServicingLog.trackChanges = true;
          setTimeout(() => {
            this.cvNoteServicingLog.refresh();
            this.ServicingLogReadOnly();
          }, 1000);
        }
      }
    });
  }

  beginningEditMarketPrice() {
    var sel = this.flexmarketprice.selection;
    if (this._note.ListNoteMarketPrice[sel.topRow].Date != null)
      this.prevDateBeforeEditMarketPrice = this._note.ListNoteMarketPrice[sel.topRow].Date;
  }

  cellEditEndedMarketPrice() {
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
      var formatDate: Date;
      var locale = "en-US"
      var options: any = { year: "numeric", month: "numeric", day: "numeric" };
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
  }

  pastedMarketPrice(s, e) {
    var sel = s.selectedItems;
    var datearr = '';
    var formatDate = '';
    var arrDate = this._note.ListNoteMarketPrice.filter(x => x.NoteID == this._note.CRENoteID);
    var flag = false;
    for (var j = 0; j < sel.length; j++) {
      var seldate = new Date(sel[j].Date).getDate() + '/' + new Date(sel[j].Date).getMonth() + '/' + new Date(sel[j].Date).getFullYear();
      for (var k = 0; k < arrDate.length; k++) {

        var _notedate = new Date(arrDate[k].Date).getDate() + '/' + new Date(arrDate[k].Date).getMonth() + '/' + new Date(arrDate[k].Date).getFullYear();
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

    for (var m = 0; m < this._note.ListNoteMarketPrice.length; m++) {
      this._note.ListNoteMarketPrice[m].NoteID = this._note.CRENoteID;
    }

    if (distinct.length > 0) {
      datearr = distinct.join(" , ");
      this.CustomAlert("Date " + datearr + " already in list");
    }


  }


  onchangedcheckeditems(s, e) {
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
          setTimeout(() => {
            this.flexservicelog.invalidate();
            this.ServicingLogReadOnly();
          }, 1000);
        }
        if (s.checkedItems[k].TransactionGroup != "All Actual Transactions") {
          if (_isalldata == false) {
            for (var m = 0; m < this.listtransactions.length; m++) {
              if (s.checkedItems[k].TransactionGroup == this.listtransactions[m].TransactionGroup) {
                transname = this.listtransactions.filter(x => x.TransactionGroup == this.listtransactions[m].TransactionGroup);
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
        setTimeout(() => {
          this.cvNoteServicingLog.refresh();
          this.ServicingLogReadOnly();
        }, 1000);
      }
    }
    else {
      this.cvNoteServicingLog = new wjcCore.CollectionView(this._noteext.lstNoteServicingLog);
      this.cvNoteServicingLog.trackChanges = true;
      this.ServicingLog_refreshlist.sort(this.dynamicSort("row_num"));
      setTimeout(() => {
        this.flexservicelog.invalidate();
        this.ServicingLogReadOnly();
      }, 1000);
    }

    // this._noteext.lstNoteServicingLog = this.ServicingLog_refreshlist;
  }
  sortByName(a, b) {
    var textA = a.FileName.toUpperCase();
    var textB = b.FileName.toUpperCase();
    return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
  }
  sortByPoolName(a, b) {
    var textA = a.Name.toUpperCase();
    var textB = b.Name.toUpperCase();
    return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
  }
  dynamicSort(property) {
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
    }
  }
  formatNumberforTwoDecimalplaces(data) {
    data = data ? data : 0;
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
      newamount = "-" + this._basecurrencyname + _amount;
    }
    else {
      newamount = this._basecurrencyname + data;
    }
    var changedamount = newamount.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
    return changedamount;
  }

  getHolidayMaster() {
    this.noteService.GetHolidayMaster().subscribe(res => {
      if (res.Succeeded) {
        var data = res.dtholidaymaster;
        this.holidayCalendarNamelist = data;
      }
    })
  }

  getDealMaturitybyID() {
    this.noteService.getMaturityDatesbyNoteid(this._note.NoteId).subscribe(res => {
      if (res.Succeeded) {
        var data = res.dt;
        this.maturityList = data;
        //this.maturityList = data.filter(x => x.MaturityType.toString() == "708" || x.MaturityType.toString() == "709" || x.MaturityType.toString() == "710");
        this.ConvertToBindableMaturityListDates(this.maturityList);
        this.maturityTypeList = data.filter(x => x.MaturityType.toString() == "708" || x.MaturityType.toString() == "709" || x.MaturityType.toString() == "710");

        //var othermatlist = data.filter(x => x.MaturityType.toString() == "711" || x.MaturityType.toString() == "712" || x.MaturityType.toString() == "713");
        if (data.length > 0) {
          this.maturityEffectiveDate = this.maturityList[0].EffectiveDate;
          this.maturityExpectedMaturityDate = this.maturityList[0].ExpectedMaturityDate;
          this.maturityOpenPrepaymentDate = this.maturityList[0].OpenPrepaymentDate;
          this.maturityActualPayoffDate = this.maturityList[0].ActualPayoffDate;
          this.maturityGroupName = this.maturityList[0].MaturityGroupName;
          this.MaturityDate = this.maturityList[0].MaturityDate;

        }
        else {
          this.maturityEffectiveDate = null;
          this.maturityOpenPrepaymentDate = null;
          this.maturityActualPayoffDate = null;
          this.maturityExpectedMaturityDate = null;
          this.maturityGroupName = this.maturityList[0].MaturityGroupName;
        }
        if (this.flexMaturity) {
          this.flexMaturity.invalidate();
        }
      }
    });
  }

  ConvertToBindableMaturityListDates(Data) {
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

  exportToExcel(filename, arr, sheets) {

    const fileName = filename + '.xlsx';
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
  }

  GetAllTagNameXIRR() {
    this.noteService.GetAllTagsNameXIRR().subscribe(res => {
      if (res.Succeeded) {
        this.lstXIRRTags = res.dt;
      }
    });
  }

  getNoteTranchePercentage() {
    this.noteService.getNoteTranchePercentagebyNoteid(this._note.NoteId).subscribe(res => {
      if (res.Succeeded) {
        var data = res.dt;
        this.lstNoteTranchePercentage = data;
      }
    });

    this.setFocus();
  }

  UpdateNoteTranchePercentageFromBackshop() {

    this._isNoteSaving = true;
    this.noteService.UpdateNoteTranchePercentage(this._note.CRENoteID).subscribe(res => {
      if (res.Succeeded) {
        this.getNoteTranchePercentage();
        this._Showmessagenotediv = true;
        this._ShowmessagenotedivMsg = 'Note tranche percentage updated successfully';
        this._isNoteSaving = false;
        setTimeout(() => {
          this._Showmessagenotediv = false;
          this._ShowmessagenotedivMsg = '';
        }, 2000);
      }
      else {
        this._isNoteSaving = false;
        this._ShowmessagenotedivWar = true;
        this._ShowmessagenotedivMsgWar = "Something went wrong. please try after some time.";

        setTimeout(function () {
          this._ShowmessagenotedivMsgWar = '';
          this._ShowmessagenotedivWar = false;
        }.bind(this), 2000);
      }
    });

   
  }

}
const routes: Routes = [

  { path: '', component: NoteDetailComponent }]

@NgModule({
  // imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjInputModule, WjGridFilterModule],
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjGridModule, WjInputModule, WjGridFilterModule, dndDirectiveModule], //, Ng2FileInputModule.forRoot()
  declarations: [NoteDetailComponent]
})

export class noteDetailModule { }
