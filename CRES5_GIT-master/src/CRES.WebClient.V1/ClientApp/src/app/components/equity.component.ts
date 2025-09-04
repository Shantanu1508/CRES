import { Component, ViewChild, QueryList, ViewChildren } from "@angular/core";
import { Router, ActivatedRoute, Params } from '@angular/router';
import * as wjcGrid from '@grapecity/wijmo.grid';
import { NgModule } from '@angular/core';
import * as wjcCore from '@grapecity/wijmo';
import { Paginated } from '../core/common/paginated.service';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { WjInputModule } from '@grapecity/wijmo.angular2.input';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import { equityService } from '../core/services/equity.service';
import { equity } from "../core/domain/equity.model";
import { UtilsFunctions } from './../core/common/utilsfunctions';
import * as wjNg2Input from '@grapecity/wijmo.angular2.input';
import { UtilityService } from '../core/services/utility.service';
import { PermissionService } from '../core/services/permission.service';
import { Search } from "../core/domain/search.model";
import { JournalLedger, JournalLedgerMaster } from "../core/domain/journalLedger.model";
import { MembershipService } from '../core/services/membership.service';
import { NoteService } from '../core/services/note.service';
import * as wjOdata from '@grapecity/wijmo.odata';
import { debtService } from '../core/services/debt.service';
import { WjGridDetailModule } from '@grapecity/wijmo.angular2.grid.detail';
import '@grapecity/wijmo.styles/wijmo.css';
import { liabilityNoteService } from '../core/services/liabilityNote.service';

declare var $: any;
@Component({
  selector: "equity",
  templateUrl: "./equity.html",
  providers: [debtService, equityService, UtilsFunctions, NoteService, liabilityNoteService]
})

export class EquityComponent extends Paginated {

  public _isShowCalcNotes: boolean = true;
  public _isShowSave: boolean = true;
  public _isShowCancel: boolean = true;
  public _isShowMain: boolean = true;
  public _isShowNotes: boolean = true;
  public _isShowCashflow: boolean = true;
  public _isShowCapContri: boolean = true;
  public _isShowfeeExpenses: boolean = true;
  public _isShowJournalLedger: boolean = true;
  public _isJournalLedgerTabClicked: boolean = false;
  public _isCashflowTabClicked: boolean = false;
  public _isCashflowLoaded: boolean = false;
  public _ShowEmptyFeeDiv: boolean = true;
  public _ShowFeeDiv: boolean = false;
  public _ShowEmptyMannual: boolean = false;
  public _ShowMannualEntryDiv: boolean = false;
  public EffectiveDateCountGeneralSetupDetailsEquity: any;
  public EffectiveDateCountRateFacility: any;
  public EffectiveDateCountFeeFacility: any;
  public EffectiveDateCountInterestExpenseSchedule: any;
  public ListEffectiveDateCount: any;
  public ListFacilityEffectiveDateCounts: any;
  public _isSetHeaderEmpty: boolean = false;
  public modulename: string;
  public lstPeriodicDataList: any;
  public _isPeriodicDataFetching: boolean;
  public _isPeriodicDataFetched: boolean = true;
  public _dvEmptyPeriodicDataMsg: boolean = false;
  public CommittedCapital: number;
  public CapitalReserve: number;
  public UncommittedCapital: number;
  public EarliestEquityArrival: Date;
  public FundBalanceexcludingReserves: number;
  public selectedTypeID: string = '';
  public selectedTypeText: string = '';
  lstAccountCategory: any;
  public _result: any;
  public _searchObj: any;
  public CurrentDebtName: any;
  public CurrentDebtAccountID: any;
  public CurrentDebtGUID: any;
  public selectedFacilityFeeEffectiveDate: any;
  public selectedFacilityRSSEffectiveDate: any;
  public ListDebtExtInterest: any;
  public ListInterestExpense: any;
  debtDataStore = {};
  public _cachedeal = {};
  _currentDate: Date;
  CalcAsOfDate: Date;
  /*  ListHoliday: any;*/

  feeExpenseDataSource: any[];
  equityTypes: any;
  lststatus: any;
  currency: any;
  calcExceptionMsg: string;
  columns: {
    binding?: string, header?: string, width?: any, format?: string
  }[];

  @ViewChild('grdPeriodicData') grdPeriodicData: wjcGrid.FlexGrid;
  @ViewChild('flexliabilityFunding') flexliabilityFunding: wjcGrid.FlexGrid;
  public cvliabilityFundingList: wjcCore.CollectionView;
  lstliabilityFundingList: any;
  listNewliabilityFundingList: any;
  deleteFundingAggregate: any = [];

  @ViewChild('flexJournalLedger') flexJournalLedger: wjcGrid.FlexGrid;
  public cvJournalLedger: wjcCore.CollectionView;
  lstjournalLedger: any;  

  @ViewChildren('flexFacilityFeeSchedule') flexFacilityFeeSchedule: QueryList<wjcGrid.FlexGrid>;
  public cvFacilityFeeSchedule: wjcCore.CollectionView;
  deleteFacilityFeeSchedule: any = [];

  @ViewChildren('flexFacilityRSS') flexFacilityRSS: QueryList<wjcGrid.FlexGrid>;
  public cvFacilityRatespreadschedule: wjcCore.CollectionView;
  deleteFacilityRateSchedule: any = [];  

  public _journal: JournalLedgerMaster;

  public cvEquityNote: wjcCore.CollectionView;
  public _isNotesTabClicked: boolean = false;
  public _isCapContributionClicked: boolean = false;
  public EquityAccountID: any;
  public LiabilityTypeID: any;
  public JournalEntryMasterID: any;
  public _isListFetching: boolean;
  public _Showsuccessmessage: boolean = false;
  public _ShowmessageWarning: boolean = false;
  public actiontype: any;
  public txtCommittedCapital: number;
  public txtCapitalReserve: number;
  public txtUncommittedCapital: number;
  public txtEarliestEquityArrival: any;
  public txtFundBalanceexcludingReserves: number;
  _messageSuccess: any;
  _messageFail: any;

  @ViewChild('flexNotesGrid') flexNotesGrid: wjcGrid.FlexGrid;
  @ViewChild('flexFeeExpenseGrid') flexFeeGrid: wjcGrid.FlexGrid;
  public cvFeeExpense: wjcCore.CollectionView;
  public _equity: equity;
  lstEquityNote: any; 

  @ViewChild('flexCashflowGrid') flexCashflowGrid: wjcGrid.FlexGrid;
  @ViewChild('equityfundsubgrid') equityfundsubgrid: wjcGrid.FlexGrid;
  public cvliabilityFundingDealLevel: wjcCore.CollectionView;
  LFSDealLevelEditedRows: any[] = [];
  FundingAggregateEditedData: any[] = [];
  lstEquityTransaction: any;
  public lstXIRRTags: any = [];
  public lstSelectedXIRRTags: any = [];
  lstTransactionType: any;
  lstStatusTextType: any;
  _currentDateFormatted: string;
  public lstliabilityMasterFunding: any;
  public cvliabilityFundingAggregate: wjcCore.CollectionView;
  lstliabilityDetailFunding: wjOdata.ODataCollectionView;
  lstliabilityDetailFundingOrg: any;
  oldTransdate: any;
  NewTransdate: any;
  _liabilityFundingScheduleMap: Map<string, any> = new Map();
  listliabilityMasterFunding: any;
  public _AllowLiabBlobDownld: boolean = false;
  lstCashAccountCategory: any;
  _isNewCash: boolean = false;
  data: any;
  DetailFundingScheduleNorecord = false;
  public lstFeeType: any;
  lstRateSpreadSch_ValueType: any;
  lstIntCalcMethodID: any;
  lstApplyTrueUpFeature: any;
  lstIndextype: any;
  dataMapValueType: any;
  public holidayCalendarNamelist: any = [];
  public ShowHideFlagRateSpreadSchedule: boolean = false;
  lstAssociatedDebt: any;
  FacilityFeeSchedule: any;
  FacilityRateSpreadSchedule: any;
  public selectedInitialInterestAccrualEnddate: any;
  public selectedFirstRateIndexResetDate: any;
  public selectedAccrualFrequency: any;
  public selectedInitialIndexValueOverride: any;
  public selectedRecourse: any;
   
  public selectedPaymentDayMonth: any;
  public selectedPaymentDateBusinessDayLag: any;
  public selectedDeterminationdateleaddays: any;
  public selectedDeterminationDateRefDayMonth: any;
  public selectedAccrualEndDateBusinessDayLag: any;
  public selectedPayFrequency: any;
  public selectedDefaultIndexName: any;
  public selectedFinanacingSpreadRate: any;
  public selectedIntCalcMethod: any;
  public selectedRoundingMethod: any;
  public selectedDeterminationDateHolidayList: any;
  public selectedResetIndexDaily: any;
  public selectedpmtdtaccper: any;
  public selectedIndexRoundingRule: any;
  public selectedTargetAdvanceRate: any;
  public selectedInterestExpenseScheduleID: any;
  public selectedEffectiveDate: any;
  public selectedEventID: any;
  public DebtExtID: any;
  public isShowFacilityAssumptions: boolean = false;
  public isFacilityAssumptionsLoading: boolean = true;
  public ListDealLevelLiabilityFundingSchedule: any;
  public listAssociatedDeals: any;
  public ListPrepayAndAdditionalFeeScheduleLiabilityDetail: any;
  public lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail: any;
  public modelheaderFeeName: any;
  public modelheaderDate: any;
  constructor(
    public equitySrv: equityService,
    public debtSrv: debtService,
    public liabilityNoteSrv: liabilityNoteService,
    public utils: UtilsFunctions,
    public utilityService: UtilityService,
    public membershipService: MembershipService,
    public noteSrv: NoteService,
    public permissionSrv: PermissionService,

    private _router: Router, private _actrouting: ActivatedRoute) {
    super(50, 1, 0);
    let EquityGUID;
    this.CheckifUserIsLogedIN();
    this._currentDate = new Date();
    ///this.CalcAsOfDate = new Date();
    /* this.GetHolidayList();*/
    this._actrouting.params.forEach((params: Params) => {
      if (params['id'] !== undefined) {
        this._equity = new equity();
        EquityGUID = params['id'];
        this._equity.EquityGUID = EquityGUID;
        this.actiontype = "new";
      } else if (params['nid'] !== undefined) {
        this._equity = new equity();
        EquityGUID = params['nid'];
        this.LiabilityTypeID = EquityGUID;
        this._equity.EquityGUID = EquityGUID;
        this.GetEquity();
        this.actiontype = "update";
        this._isNewCash = false;
      } else {
        this.actiontype = "new";
        this.utilityService.setPageTitle("M61– Equity");
        this.EquityAccountID = "00000000-0000-0000-0000-000000000000";
        this._isNewCash = true;
      }

    });
    this._equity = new equity();
    this.listNewliabilityFundingList = [];
    if (this._equity.ListSelectedXIRRTags === undefined || this._equity.ListSelectedXIRRTags == null) {
      this._equity.ListSelectedXIRRTags = [];
    }

    this.GetAllLookups();

    //this.showEquityCalcStatus();
    this.GetAllTagNameXIRR();
    //this.GetAllowBasicLogin();
    this.GetCashAccountsCategory();
  }

  GetAllTagNameXIRR() {
    this.noteSrv.GetAllTagsNameXIRR().subscribe(res => {
      if (res.Succeeded) {
        this.lstXIRRTags = res.dt;
      }
    });
  }

  getHolidayMaster() {
    this.noteSrv.GetHolidayMaster().subscribe(res => {
      if (res.Succeeded) {
        var data = res.dtholidaymaster;
        this.holidayCalendarNamelist = data;
      }
    })
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
  GetAllLookups(): void {
    this.equitySrv.getAllLookup().subscribe(res => {
      var data = res.lstLookups;
      this.lststatus = data.filter(x => x.ParentID == "51");
      this.lstIndextype = data.filter(x => x.ParentID == "32");
      this.lstAccountCategory = res.dt.filter(x => x.LiabilitiesType == "Debt")
      this.lstApplyTrueUpFeature = data.filter(x => x.ParentID == "95");
      this.lstRateSpreadSch_ValueType = data.filter(x => x.ParentID == "19");
      this.lstIntCalcMethodID = data.filter(x => x.ParentID == "25");
      this.lstFeeType = res.lstFeeTypeLookUp;
      this.lstAccountCategory = res.dt.filter(x => x.LiabilitiesType == "Equity");
      this.lstTransactionType = res.lstTransactionType;
      this.lstStatusTextType = data.filter(x => x.ParentID == "154");
      this.getHolidayMaster();
      this._bindGridDropdowsEquity();
    });
  }

  GetEquity() {
    if (this._equity.EquityGUID != null) {
      this._isListFetching = true;
      this.equitySrv.EquityByEquityId(this._equity).subscribe(res => {
        if (res.Succeeded) {
          this._equity = res.EquityData;

          this.txtCommittedCapital = this.utils.formatNumberforTwoDecimalplaces(this._equity.CommittedCapital, this._equity.CurrencyText);
          this.txtCapitalReserve = this.utils.formatNumberforTwoDecimalplaces(this._equity.CapitalReserve, this._equity.CurrencyText);
          this.txtUncommittedCapital = this.utils.formatNumberforTwoDecimalplaces(this._equity.UncommittedCapital, this._equity.CurrencyText);

          this.txtFundBalanceexcludingReserves = this.utils.formatNumberforTwoDecimalplaces(this._equity.FundBalanceexcludingReserves, this._equity.CurrencyText);
          this.ListEffectiveDateCount = res.ListEffectiveDateCount;
          this.selectedTypeID = this._equity.LinkedShortTermBorrowingFacilityID;
          this.selectedTypeText = this._equity.LinkedShortTermBorrowingFacilityText;
          this.utilityService.setPageTitle("M61–" + this._equity.EquityName);
          this.EquityAccountID = this._equity.EquityAccountID;

          this.txtEarliestEquityArrival = this.utils.convertDateToBindable(this._equity.EarliestEquityArrival);
          this._currentDateFormatted = this.utils.convertDateToBindable(this._equity.CalcAsOfDate);
          this.CalcAsOfDate = this._equity.CalcAsOfDate;
          this.ShowCountOnViewHistory();
          this.GetAssociatedDebtDataByEquityId();

          setTimeout(function () {
            //this._isListFetching = false;
          }.bind(this), 200);
        }
      });
    }
  }

  GetAssociatedDebtDataByEquityId() {
    this._isListFetching = true;
    this.equitySrv.GetAssociatedDebtDataByEquityId(this.EquityAccountID).subscribe(res => {
      if (res.Succeeded) {

        this.lstAssociatedDebt = res.dtAssociatedDebt;

        this.isFacilityAssumptionsLoading = false;

        if (this.lstAssociatedDebt.length > 0) {
          this.isShowFacilityAssumptions = true;
        }
        this.FacilityFeeSchedule = res.FacilityFeeSchedule;
        this.FacilityRateSpreadSchedule = res.FacilityRateSpreadSchedule;
        this.ListDebtExtInterest = res.ListDebtExtInterest;
        this.ListInterestExpense = res.lstInterestExpenseSchedule;
        this.ListFacilityEffectiveDateCounts = res.ListFacilityEffectiveDateCounts;
        this.ListPrepayAndAdditionalFeeScheduleLiabilityDetail = res.ListPrepayAndAdditionalFeeScheduleLiabilityDetail;

        setTimeout(function () {
          if (this.lstAssociatedDebt) {
            this.GetSchedulesforFacility(this.lstAssociatedDebt[0].DebtAccountID, this.lstAssociatedDebt[0].DebtName, this.lstAssociatedDebt[0].DebtGUID, "aEqDebt0");
            this.invalidateCapContribution(false);
          }
        }.bind(this), 500);
        setTimeout(function () {
          this._isListFetching = false;
        }.bind(this), 200);
      }
    });

  }      
  
  IntCalcMethodChange(newvalue): void {
    this.selectedIntCalcMethod = newvalue;
  }
  RoundingMethodChange(newvalue): void {
    this.selectedRoundingMethod = newvalue;
  }
  DeterminationDateHolidayListChange(newvalue): void {
    this.selectedDeterminationDateHolidayList = newvalue;
  }  
  ResetIndexDailyChange(newvalue): void {
    this.selectedResetIndexDaily = newvalue;
  }

  pmtdtaccperChange(newvalue): void {
    this.selectedpmtdtaccper = newvalue;
  }
  DefaultIndexNameChange(newvalue): void {
    this.selectedDefaultIndexName = newvalue;
  }

  GetFacilityDebtExtData(DebtAccountID) {
    this._isListFetching = true;
    this.selectedPayFrequency = null;
    this.selectedAccrualFrequency = null;
    this.selectedAccrualEndDateBusinessDayLag = null;
    this.selectedDefaultIndexName = null;
    this.selectedFinanacingSpreadRate = null;
    this.selectedIntCalcMethod = null;
    this.selectedRoundingMethod = null;
    this.selectedDeterminationDateHolidayList = null;

    this.selectedResetIndexDaily = null;
    this.selectedpmtdtaccper = null;

    this.selectedIndexRoundingRule = null;
    this.selectedTargetAdvanceRate = null;
    this.DebtExtID = null;

    var lst = this.ListDebtExtInterest.filter(item => item.DebtAccountID === DebtAccountID);

    if (lst != null && lst.length > 0) {
      this.DebtExtID = lst[0].DebtExtID;
      this.selectedPayFrequency = lst[0].PayFrequency;
      this.selectedAccrualFrequency = lst[0].AccrualFrequency;
      this.selectedAccrualEndDateBusinessDayLag = lst[0].AccrualEndDateBusinessDayLag;
      this.selectedDefaultIndexName = lst[0].DefaultIndexName;
      this.selectedFinanacingSpreadRate = lst[0].FinanacingSpreadRate;
      this.selectedIntCalcMethod = lst[0].IntCalcMethod;
      this.selectedRoundingMethod = lst[0].RoundingMethod;
      this.selectedDeterminationDateHolidayList = lst[0].DeterminationDateHolidayList;
      this.selectedResetIndexDaily = lst[0].ResetIndexDaily;
      this.selectedpmtdtaccper = lst[0].pmtdtaccper;
      this.selectedIndexRoundingRule = lst[0].IndexRoundingRule;
      this.selectedTargetAdvanceRate = lst[0].TargetAdvanceRate;
    }
    setTimeout(function () {
      this._isListFetching = false;
    }.bind(this), 500);
  }

  GetFacilityFeeScheduleByAccountID(DebtAccountID): void {
    this._isListFetching = true;
    this.selectedFacilityFeeEffectiveDate = null;

    if (this.FacilityFeeSchedule != null) {
      this.debtDataStore[DebtAccountID].lstFacilityFeeSchedule = this.FacilityFeeSchedule.filter(item => item.AccountID === DebtAccountID);

      if (this.debtDataStore[DebtAccountID].lstFacilityFeeSchedule.length > 0) {
        var lstfee = this.debtDataStore[DebtAccountID].lstFacilityFeeSchedule[0];
        this.selectedFacilityFeeEffectiveDate = lstfee.EffectiveDate;
      }
    }
    for (let i = 0; i < this.debtDataStore[DebtAccountID].lstFacilityFeeSchedule.length; i++) {
      if (this.debtDataStore[DebtAccountID].lstFacilityFeeSchedule[i].StartDate != null) {
        this.debtDataStore[DebtAccountID].lstFacilityFeeSchedule[i].StartDate = new Date(this.utils.convertDateToBindable(this.debtDataStore[DebtAccountID].lstFacilityFeeSchedule[i].StartDate));
      }
      if (this.debtDataStore[DebtAccountID].lstFacilityFeeSchedule[i].EndDate != null) {
        this.debtDataStore[DebtAccountID].lstFacilityFeeSchedule[i].EndDate = new Date(this.utils.convertDateToBindable(this.debtDataStore[DebtAccountID].lstFacilityFeeSchedule[i].EndDate));
      }
    }
    this.cvFacilityFeeSchedule = new wjcCore.CollectionView(this.debtDataStore[DebtAccountID].lstFacilityFeeSchedule);
    this.cvFacilityFeeSchedule.trackChanges = true;
    

    setTimeout(function () {
      this._isListFetching = false;
      //this.ngAfterViewInit();
    }.bind(this), 500);
    this.ShowCountOnViewHistoryFacility(DebtAccountID);
    this._bindGridDropdowsEquity();
  }


  GetFacilityRateScheduleByAccountID(DebtAccountID): void {
    this._isListFetching = true;
    this.selectedFacilityRSSEffectiveDate = null;
    if (this.FacilityRateSpreadSchedule != null) {
      this.debtDataStore[DebtAccountID].lstfacilityRateSpreadSchedule = this.FacilityRateSpreadSchedule.filter(item => item.LiabilityNoteAccountID === DebtAccountID);

      if (this.debtDataStore[DebtAccountID].lstfacilityRateSpreadSchedule.length > 0) {
        var lstrss = this.debtDataStore[DebtAccountID].lstfacilityRateSpreadSchedule[0];
        this.selectedFacilityRSSEffectiveDate = lstrss.EffectiveDate;
      }
    }
    for (var i = 0; i < this.debtDataStore[DebtAccountID].lstfacilityRateSpreadSchedule.length; i++) {
      if (this.debtDataStore[DebtAccountID].lstfacilityRateSpreadSchedule[i].Date != null) {
        this.debtDataStore[DebtAccountID].lstfacilityRateSpreadSchedule[i].Date = new Date(this.utils.convertDateToBindable(this.debtDataStore[DebtAccountID].lstfacilityRateSpreadSchedule[i].Date));
      }

    }
    this.cvFacilityRatespreadschedule = new wjcCore.CollectionView(this.debtDataStore[DebtAccountID].lstfacilityRateSpreadSchedule);
    this.cvFacilityRatespreadschedule.trackChanges = true;
    setTimeout(function () {
      this._isListFetching = false;
    }.bind(this), 500);
    this.ShowCountOnViewHistoryFacility(DebtAccountID);
    this._bindGridDropdowsEquity();
  }


  onGridUpdateFEE(DebtAccountID) {
    var debtData = this.debtDataStore[DebtAccountID];
    debtData.lstFacilityFeeSchedule.forEach(item => {
      item.AccountID = DebtAccountID;
      item.AdditionalAccountID = this.EquityAccountID;
      item.EffectiveDate = this.selectedFacilityFeeEffectiveDate;
    });
    this.FacilityFeeSchedule = this.FacilityFeeSchedule.filter(item => item.AccountID !== DebtAccountID);
    this.FacilityFeeSchedule = this.FacilityFeeSchedule.concat(debtData.lstFacilityFeeSchedule);
    //this.ngAfterViewInit();
  }

  onGridUpdateRSS(DebtAccountID) {
    var debtData = this.debtDataStore[DebtAccountID];
    debtData.lstfacilityRateSpreadSchedule.forEach(item => {
      item.AccountID = DebtAccountID;
      item.AdditionalAccountID = this.EquityAccountID;
      item.EffectiveDate = this.selectedFacilityRSSEffectiveDate;
    });
    this.FacilityRateSpreadSchedule = this.FacilityRateSpreadSchedule.filter(item => item.AccountID !== DebtAccountID);
    this.FacilityRateSpreadSchedule = this.FacilityRateSpreadSchedule.concat(this.debtDataStore[DebtAccountID].lstfacilityRateSpreadSchedule);
  }

  OnChangeDebtExtIntExp() {
    var newInterestExpenseData = {
      DebtExtID: this.DebtExtID,
      DebtAccountID: this.CurrentDebtAccountID,
      AdditionalAccountID: this.EquityAccountID,
      PayFrequency: this.selectedPayFrequency,
      AccrualFrequency: this.selectedAccrualFrequency,
      AccrualEndDateBusinessDayLag: this.selectedAccrualEndDateBusinessDayLag,
      DefaultIndexName: this.selectedDefaultIndexName,
      FinanacingSpreadRate: this.selectedFinanacingSpreadRate,
      IntCalcMethod: this.selectedIntCalcMethod,
      RoundingMethod: this.selectedRoundingMethod,
      DeterminationDateHolidayList: this.selectedDeterminationDateHolidayList,
      pmtdtaccper: this.selectedpmtdtaccper,
      ResetIndexDaily: this.selectedResetIndexDaily,
      IndexRoundingRule: this.selectedIndexRoundingRule,
      TargetAdvanceRate: this.selectedTargetAdvanceRate
    };

    var existingDataIndex = this.debtDataStore[this.CurrentDebtAccountID].lstDebtExtIntExpData.findIndex(
      item => item.DebtAccountID === this.CurrentDebtAccountID
    );

    if (existingDataIndex === -1) {
      this.debtDataStore[this.CurrentDebtAccountID].lstDebtExtIntExpData.push(newInterestExpenseData);
    } else {
      this.debtDataStore[this.CurrentDebtAccountID].lstDebtExtIntExpData[existingDataIndex] = newInterestExpenseData;
    }

    this.ListDebtExtInterest = this.ListDebtExtInterest.filter(item => item.DebtAccountID !== this.CurrentDebtAccountID);
    this.ListDebtExtInterest = this.ListDebtExtInterest.concat(this.debtDataStore[this.CurrentDebtAccountID].lstDebtExtIntExpData);
  }

  GetSchedulesforFacility(DebtAccountID, DebtName, DebtGUID, e) {
    //format pannel
    var header = document.getElementById("AssociatedDebtdiv");
    var btns = header.getElementsByClassName("equity-vertical-tabs");
    for (var i = 0; i < btns.length; i++) {
      if (btns[i].className.includes("div-active-color")) {
        btns[i].className = "equity-vertical-tabs";
      }
    }
    var divid = "divEqDebt" + e.substr(e.length - 1);
    var celementa = document.getElementById(e);
    celementa.className += " div-active-color";

    this.CurrentDebtName = DebtName;
    this.CurrentDebtAccountID = DebtAccountID;
    this.CurrentDebtGUID = DebtGUID;
    if (!this.debtDataStore[DebtAccountID]) {
      this.debtDataStore[DebtAccountID] = {
        lstFacilityFeeSchedule: [],
        lstfacilityRateSpreadSchedule: [],
        lstDebtExtIntExpData: [],
        lstInterestExpense: []
      };
    }

    this.GetFacilityDebtExtData(DebtAccountID);
    this.GetFacilityFeeScheduleByAccountID(DebtAccountID);
    this.GetFacilityRateScheduleByAccountID(DebtAccountID);
    this.GetFacilityInterestExpenseData(DebtAccountID);
  }


  CheckDuplicateDebtAndSave() {
    if (!this.CustomValidator()) {
      return;
    }
    this._isListFetching = true;
    this._equity.modulename = "Equity";
    this._equity.EquityAccountID = this.EquityAccountID;
    this.equitySrv.CheckDuplicateforLiabilities(this._equity).subscribe(res => {
      if (res.Succeeded) {
        if (res.Message === "Save") {
          this.SaveEquity();
        } else {
          this._isListFetching = false;
          this.CustomAlert(res.Message);
        }
      } else {
        this._isListFetching = false;
        this.CustomAlert("Error occurred while checking for duplicates.");
      }
    }, error => {
      this._isListFetching = false;
      this.CustomAlert("Error occurred while saving.");
      console.error(error);
    });
  }

  SaveEquity() {
    this._isListFetching = true;
    this._equity.LastDatetoInvest = this.utils.convertDateToUTC(this._equity.LastDatetoInvest);
    this._equity.InceptionDate = this.utils.convertDateToUTC(this._equity.InceptionDate);
    this._equity.InitialMaturityDate = this.utils.convertDateToUTC(this._equity.InitialMaturityDate);
    this._equity.EffectiveDate = this.utils.convertDateToUTC(this._equity.EffectiveDate);
    this._equity.LinkedShortTermBorrowingFacilityID = this.selectedTypeID;    
    
    var allFacilityFeeSchedules = [];
    var allFacilityRateSpreadSchedules = [];
    var allFacilityIntExpSetup = [];
    var allFacilityInterestExpense = [];

    Object.keys(this.debtDataStore).forEach(DebtAccountID => {
      var debtData = this.debtDataStore[DebtAccountID];

      if (debtData.lstDebtExtIntExpData && debtData.lstDebtExtIntExpData.length > 0) {
        debtData.lstDebtExtIntExpData.forEach(item => {
          if (item.InitialInterestAccrualEnddate != null) {
            item.InitialInterestAccrualEnddate = this.utils.convertDateToUTC(item.InitialInterestAccrualEnddate);
          }

          if (item.FirstRateIndexResetDate != null) {
            item.FirstRateIndexResetDate = this.utils.convertDateToUTC(item.FirstRateIndexResetDate);
          }

          allFacilityIntExpSetup.push(item);
        });
      }

      if (debtData.lstFacilityFeeSchedule && debtData.lstFacilityFeeSchedule.length > 0) {

        for (let i = 0; i < this.deleteFacilityFeeSchedule.length; i++) {
          debtData.lstFacilityFeeSchedule.push(this.deleteFacilityFeeSchedule[i]);
        }

        debtData.lstFacilityFeeSchedule.forEach(item => {
          if (item.EffectiveDate != null) {
            item.EffectiveDate = this.utils.convertDateToUTC(item.EffectiveDate);
          }
          if (item.StartDate != null) {
            item.StartDate = this.utils.convertDateToUTC(item.StartDate);
          }
          if (item.EndDate != null) {
            item.EndDate = this.utils.convertDateToUTC(item.EndDate);
          }

          if (!(Number(item.FeeTypeText).toString() == "NaN" || Number(item.FeeTypeText) == 0)) {
            item.ValueTypeID = Number(item.FeeTypeText);
          }
          else {
            var filteredarray = this.lstFeeType.filter(x => x.Name == item.FeeTypeText)
            if (filteredarray.length != 0) {
              item.ValueTypeID = Number(filteredarray[0].LookupID);
            }
          }
          if (!(Number(item.ApplyTrueUpFeatureText).toString() == "NaN" || Number(item.ApplyTrueUpFeatureText) == 0)) {
            item.ApplyTrueUpFeatureID = Number(item.ApplyTrueUpFeatureText);
          }
          else {
            var filteredarray = this.lstFeeType.filter(x => x.Name == item.ApplyTrueUpFeatureText)
            if (filteredarray.length != 0) {
              item.ApplyTrueUpFeatureID = Number(filteredarray[0].LookupID);
            }
          }
          allFacilityFeeSchedules.push(item);
        });
      }

      if (debtData.lstfacilityRateSpreadSchedule && debtData.lstfacilityRateSpreadSchedule.length > 0) {

        for (let i = 0; i < this.deleteFacilityRateSchedule.length; i++) {
          debtData.lstfacilityRateSpreadSchedule.push(this.deleteFacilityRateSchedule[i]);
        }

        debtData.lstfacilityRateSpreadSchedule.forEach(item => {

          if (item.EffectiveDate != null) {
            item.EffectiveDate = this.utils.convertDateToUTC(item.EffectiveDate);
          }
          if (item.Date != null) {
            item.Date = this.utils.convertDateToUTC(item.Date);
          }
          if (!(Number(item.ValueTypeText).toString() == "NaN" || Number(item.ValueTypeText) == 0)) {
            item.ValueTypeID = Number(item.ValueTypeText);
            item.ValueTypeText = this.lstRateSpreadSch_ValueType.find(x => x.LookupID == item.ValueTypeID).Name
          }
          else {
            var filteredarray = this.lstRateSpreadSch_ValueType.filter(x => x.Name == item.ValueTypeText)
            if (filteredarray.length != 0) {
              item.ValueTypeID = Number(filteredarray[0].LookupID);
            }
          }
          if (!(Number(item.IntCalcMethodText).toString() == "NaN" || Number(item.IntCalcMethodText) == 0)) {
            item.IntCalcMethodID = Number(item.IntCalcMethodText);
            item.IntCalcMethodText = this.lstIntCalcMethodID.find(x => x.LookupID == item.IntCalcMethodID).Name
          } else {
            var filteredarray = this.lstIntCalcMethodID.filter(x => x.Name == item.IntCalcMethodText)
            if (filteredarray.length != 0) {
              item.IntCalcMethodID = Number(filteredarray[0].LookupID);
            }
          }
          if (!(Number(item.IndexNameText).toString() == "NaN" || Number(item.IndexNameText) == 0)) {
            item.IndexNameID = Number(item.IndexNameText);

            item.IndexNameText = this.lstIndextype.find(x => x.LookupID == item.IndexNameID).Name
          } else {
            var filteredarray = this.lstIndextype.filter(x => x.Name == item.IndexNameText)

            if (filteredarray.length != 0) {
              item.IndexNameID = Number(filteredarray[0].LookupID);
            }
          }
          if (!(Number(item.DeterminationDateHolidayListText).toString() == "NaN" || Number(item.DeterminationDateHolidayListText) == 0)) {
            item.DeterminationDateHolidayList = Number(item.DeterminationDateHolidayListText);

            item.DeterminationDateHolidayListText = this.holidayCalendarNamelist.find(x => x.HolidayMasterID == item.DeterminationDateHolidayList).CalendarName
          } else {
            var filteredarray = this.holidayCalendarNamelist.filter(x => x.CalendarName == item.DeterminationDateHolidayListText)

            if (filteredarray.length != 0) {
              item.DeterminationDateHolidayList = Number(filteredarray[0].HolidayMasterID);
            }
          }

          allFacilityRateSpreadSchedules.push(item);
        });
      }

      if (debtData.lstInterestExpense && debtData.lstInterestExpense.length > 0) {
        debtData.lstInterestExpense.forEach(item => {
          if (item.EffectiveDate != null) {
            item.EffectiveDate = this.utils.convertDateToUTC(item.EffectiveDate);
          }
          if (item.InitialInterestAccrualEnddate != null) {
            item.InitialInterestAccrualEnddate = this.utils.convertDateToUTC(item.InitialInterestAccrualEnddate);
          }
          if (item.FirstRateIndexResetDate != null) {
            item.FirstRateIndexResetDate = this.utils.convertDateToUTC(item.FirstRateIndexResetDate);
          }
          if (item.EventID == null) {
            item.EventID = "00000000-0000-0000-0000-000000000000";
          }
          allFacilityInterestExpense.push(item);
        });
      }
    });

    this._equity.DebtExtDataList = allFacilityIntExpSetup;
    this._equity.FacilityFeeScheduleList = allFacilityFeeSchedules;
    this._equity.FacilityRateSpreadScheduleList = allFacilityRateSpreadSchedules;
    this._equity.ListInterestExpense = allFacilityInterestExpense;
    this._equity.ListPrepayAndAdditionalFeeScheduleLiabilityDetail = this.ListPrepayAndAdditionalFeeScheduleLiabilityDetail;

    if (this.FundingAggregateEditedData !== undefined && this.FundingAggregateEditedData !== null) {

      for (i = 0; i < this.deleteFundingAggregate.length; i++) {
        this.FundingAggregateEditedData.push(this.deleteFundingAggregate[i]);
      }

      for (var i = 0; i < this.FundingAggregateEditedData.length; i++) {

        let mandatoryFields: string[] = [];

        const record = this.FundingAggregateEditedData[i]; 

        if (!record.TransactionDate) {
          mandatoryFields.push("Date");
        }
        if (!record.TransactionTypes) {
          mandatoryFields.push("Transaction Type");
        }
        if (!record.StatusName) {
          mandatoryFields.push("Status");
        }

        if (mandatoryFields.length > 0) {
          const fieldsList = mandatoryFields.join(", ");
          this.CustomAlert(fieldsList + (mandatoryFields.length > 1 ? ' are mandatory fields.' : ' is mandatory field.'));
          this._isListFetching = false;
          return;
        }        

        this.FundingAggregateEditedData[i].TransactionDate = this.utils.convertDateToUTC(this.FundingAggregateEditedData[i].TransactionDate);

        if (!(Number(this.FundingAggregateEditedData[i].StatusName).toString() == "NaN" || Number(this.FundingAggregateEditedData[i].StatusName) == 0)) {
          this.FundingAggregateEditedData[i].StatusID = Number(this.FundingAggregateEditedData[i].StatusName);
        }
        else {
          var filteredarray = this.lstStatusTextType.filter(x => x.Name == this.FundingAggregateEditedData[i].StatusName)
          if (filteredarray.length != 0) {
            this.FundingAggregateEditedData[i].StatusID = Number(filteredarray[0].LookupID);
          }
        }

      }
    }

    if (this.ListDealLevelLiabilityFundingSchedule !== undefined && this.ListDealLevelLiabilityFundingSchedule !== null) {
      this.ListDealLevelLiabilityFundingSchedule.forEach(scheduleItem => {
        const isLNDealLevelMatch = this.deleteFundingAggregate.some(deleteItem =>
          this.utils.convertDateToBindable(deleteItem.TransactionDate) === scheduleItem.TransactionDate &&
          deleteItem.TransactionTypes === scheduleItem.TransactionTypes
        );

        if (isLNDealLevelMatch) {
          this.LFSDealLevelEditedRows.push({
            ...scheduleItem,
            IsDeleted: true
          });
        }
      });
    }

    if (this.lstliabilityFundingList !== undefined && this.lstliabilityFundingList !== null) {
      this.lstliabilityFundingList.forEach(scheduleItem => {
        const isLNFundlevelMatch = this.deleteFundingAggregate.some(deleteItem =>
          this.utils.convertDateToBindable(deleteItem.TransactionDate) === this.utils.convertDateToBindable(scheduleItem.TransactionDate) &&
          deleteItem.TransactionTypes === scheduleItem.TransactionTypes
        );

        if (isLNFundlevelMatch) {
          this.listNewliabilityFundingList.push({
            ...scheduleItem,
            IsDeleted: true
          });
        }
      });
    }

    for (var i = 0; i < this.listNewliabilityFundingList.length; i++) {
      this.listNewliabilityFundingList[i].TransactionDate = this.utils.convertDateToUTC(this.listNewliabilityFundingList[i].TransactionDate);
      this.listNewliabilityFundingList[i].AssetTransactionDate = this.utils.convertDateToUTC(this.listNewliabilityFundingList[i].AssetTransactionDate);
    }

    for (var i = 0; i < this.LFSDealLevelEditedRows.length; i++) {
      this.LFSDealLevelEditedRows[i].TransactionDate = this.utils.convertDateToUTC(this.LFSDealLevelEditedRows[i].TransactionDate);
    }

    this._equity.liabilityMasterFunding = this.FundingAggregateEditedData;
    this._equity.ListLiabilityFundingSchedule = this.listNewliabilityFundingList;
    this._equity.ListDealLevelLiabilityFundingSchedule = this.LFSDealLevelEditedRows;

    this.equitySrv.Saveequity(this._equity).subscribe(res => {

      if (res.Succeeded) {
        this._Showsuccessmessage = true;
        this._messageSuccess = "Equity Data Saved Successfully.";
        this._isListFetching = false;
        //stop calc equity on save
        //this.QueueEquityForCalculation();

        setTimeout(function () {
          this._messageSuccess = "";
          this._Showsuccessmessage = false;

          if (this.actiontype == "new") {
            this._router.navigate(['/equity/n/', res.LiabilityTypeID]);
          } else {
            var returnUrl = this._router.url;
            if (window.location.href.indexOf("equity/n/") > -1) {
              returnUrl = returnUrl.toString().replace('equity/n/', 'equity/u/');

            }
            else if (returnUrl.indexOf("equity/u/") > -1) {
              returnUrl = returnUrl.toString().replace('equity/u/', 'equity/n/');
            }
            this._router.navigate([returnUrl]);
          }

        }.bind(this), 1000);

      }
      else {
        this._messageFail = "Error Occurred While Saving Equity.";
        this._ShowmessageWarning
        this._ShowmessageWarning = true;
        this._isListFetching = false;

        setTimeout(function () {
          this._messageFail = "";
          this._ShowmessageWarning = false;
        }.bind(this), 2000);
      }



    });
  }
  CustomValidator(): boolean {
    var ms = "";
    let isValid = true;

    if (this._equity.EquityName == "" || this._equity.EquityName == null || this._equity.EquityName === undefined) {
      ms = ms + "Equity Name should not be blank";
      isValid = false;
    }

    if (!this._equity.EffectiveDate && (this._equity.Commitment || this._equity.InitialMaturityDate)) {
      this.CustomAlert("In Effective Date Based Setup, Effective Date should not be blank.");
      this._isListFetching = false;
      return;
    }

    if (!isValid) {
      this.CustomAlert(ms);
    }

    return isValid;
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

  showDeleteDialog(deleteRowIndex: number, moduleName: string, DebtAccountID: any) {
    this.deleteRowIndex = deleteRowIndex;
    this.modulename = moduleName;
    this.DebtAccountID = DebtAccountID;
    var modalDelete = document.getElementById('myModalDelete');

    modalDelete.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }

  showDeleteDialogFunding(deleteRowIndex: number, moduleName: string) {
    this.deleteRowIndex = deleteRowIndex;
    this.modulename = moduleName;
    var modalDelete = document.getElementById('myModalDelete');
    modalDelete.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }

  CloseDeletePopUp() {
    var modal = document.getElementById('myModalDelete');
    modal.style.display = "none";
  }
  deleteRowIndex: number;
  DebtAccountID: any;
  deleteRow() {

    if (this.modulename == "Facility Fee Schedule") {
      this.debtDataStore[this.DebtAccountID].lstFacilityFeeSchedule[this.deleteRowIndex].IsDeleted = true;
      var gridFacilityFEE = this.flexFacilityFeeSchedule.toArray()[0];
      if (gridFacilityFEE.rows[this.deleteRowIndex]) {
        this.deleteFacilityFeeSchedule.push(this.debtDataStore[this.DebtAccountID].lstFacilityFeeSchedule[this.deleteRowIndex]);
      }
      this.cvFacilityFeeSchedule.removeAt(this.deleteRowIndex);
    }

    if (this.modulename == "Facility Rate Spread Schedule") {
      this.debtDataStore[this.DebtAccountID].lstfacilityRateSpreadSchedule[this.deleteRowIndex].IsDeleted = true;
      var gridFacilityRSS = this.flexFacilityRSS.toArray()[0];
      if (gridFacilityRSS.rows[this.deleteRowIndex]) {
        this.deleteFacilityRateSchedule.push(this.debtDataStore[this.DebtAccountID].lstfacilityRateSpreadSchedule[this.deleteRowIndex]);
      }
      this.cvFacilityRatespreadschedule.removeAt(this.deleteRowIndex);
    }

    if (this.modulename == "Liability Funding Aggregate") {
      this.lstliabilityMasterFunding[this.deleteRowIndex].IsDeleted = true;
      if (this.flexliabilityFunding.rows[this.deleteRowIndex]) {
        this.deleteFundingAggregate.push(this.lstliabilityMasterFunding[this.deleteRowIndex]);
      }
      this.cvliabilityFundingAggregate.removeAt(this.deleteRowIndex);
      this.flexliabilityFunding.invalidate(true);
    }

    this.CloseDeletePopUp();
  }

  GetEquityNoteByLiabilityTypeID(): void {
    this._isListFetching = true;
    this.equitySrv.GetEquityNoteByLiabilityTypeID(this.EquityAccountID).subscribe(res => {
      if (res.Succeeded) {

        this.lstEquityNote = res.lstNote;

        for (var i = 0; i < this.lstEquityNote.length; i++) {
          if (this.lstEquityNote[i].InitialInvestmentDate != null) {
            this.lstEquityNote[i].InitialInvestmentDate = new Date(this.utils.convertDateToBindable(this.lstEquityNote[i].InitialInvestmentDate));
          }

          if (this.lstEquityNote[i].MaturityDate != null) {
            this.lstEquityNote[i].MaturityDate = new Date(this.utils.convertDateToBindable(this.lstEquityNote[i].MaturityDate));
          }

        }
        this.cvEquityNote = new wjcCore.CollectionView(this.lstEquityNote);
        this.cvEquityNote.trackChanges = true;
        this.flexNotesGrid.invalidate();

        setTimeout(function () {
          this._isListFetching = false;
        }.bind(this), 500);
      }
    });
  } 
  
  invalidateNotesTab() {
    if (!this._isNotesTabClicked) {
      this._isNotesTabClicked = true;
      this.GetEquityNoteByLiabilityTypeID();
    }
  }
  addFooterRowxEquityGrid(flexNotesGrid: wjcGrid.FlexGrid) {
    var row = new wjcGrid.GroupRow();
    flexNotesGrid.columnFooters.rows.push(row);
    flexNotesGrid.bottomLeftCells.setCellData(0, 0, '\u03A3');

  }
  addFooterJournalEntry(flexJournalLedger: wjcGrid.FlexGrid) {
    var row = new wjcGrid.GroupRow();
    flexJournalLedger.columnFooters.rows.push(row);
    flexJournalLedger.bottomLeftCells.setCellData(0, 0, '\u03A3');

  }
  addFooterRowFundingGrid(flexliabilityFunding: wjcGrid.FlexGrid) {
    var row = new wjcGrid.GroupRow();
    flexliabilityFunding.columnFooters.rows.push(row);
    flexliabilityFunding.bottomLeftCells.setCellData(0, 0, '\u03A3');

  }
  addFooterRowFeeExpenseGrid(flexFeeExpenseGrid: wjcGrid.FlexGrid) {
    var row = new wjcGrid.GroupRow();
    flexFeeExpenseGrid.columnFooters.rows.push(row);
    flexFeeExpenseGrid.bottomLeftCells.setCellData(0, 0, '\u03A3');

  }

  invalidateCapContribution(showloader) {
    if (!this._isCapContributionClicked) {
      this._isCapContributionClicked = true;
      this.GetEquityFundingScheduleByLiabilityTypeID(showloader);
      this.GetLiabilityFundingScheduleAggregate(showloader);
      this.GetDealLevelLiabilityFundingScheduleTypeID();

    }
    if (showloader == true) {
      this.CalculateUnallocatedBalance();
    }

  }

  GetDealLevelLiabilityFundingScheduleTypeID(): void {
    this.equitySrv.GetDealLevelLiabilityFundingScheduleTypeID(this.EquityAccountID).subscribe(res => {
      if (res.Succeeded) {

        this._equity.ListDealLevelLiabilityFundingSchedule = res.EquityData.ListDealLevelLiabilityFundingSchedule;

        this.ListDealLevelLiabilityFundingSchedule = this._equity.ListDealLevelLiabilityFundingSchedule;
        this.listAssociatedDeals = res.listAssociatedDeals;
        for (var i = 0; i < this.ListDealLevelLiabilityFundingSchedule.length; i++) {
          if (this.ListDealLevelLiabilityFundingSchedule[i].TransactionDate != null) {
            this.ListDealLevelLiabilityFundingSchedule[i].TransactionDate = this.utils.convertDateToBindable(this.ListDealLevelLiabilityFundingSchedule[i].TransactionDate);
          }
        }
      }
    });
  }


  GetEquityFundingScheduleByLiabilityTypeID(showloader): void {
    this._isListFetching = showloader;
    this.equitySrv.GetEquityFundingScheduleByLiabilityTypeID(this.EquityAccountID).subscribe(res => {
      if (res.Succeeded) {

        this.lstliabilityFundingList = res.ListLiabilityFundingSchedule;

        for (var i = 0; i < this.lstliabilityFundingList.length; i++) {
          if (this.lstliabilityFundingList[i].TransactionDate != null) {
            this.lstliabilityFundingList[i].TransactionDate = new Date(this.utils.convertDateToBindable(this.lstliabilityFundingList[i].TransactionDate));
          }
          if (this.lstliabilityFundingList[i].AssetTransactionDate != null) {
            this.lstliabilityFundingList[i].AssetTransactionDate = new Date(this.utils.convertDateToBindable(this.lstliabilityFundingList[i].AssetTransactionDate));
          }
        }
        this.CalculateFundBalance(this.lstliabilityFundingList);
        setTimeout(function () {
          this._isListFetching = false;
        }.bind(this), 200);
      }
    });
  }
  CalculateFundBalance(data) {
    var TransactionAmount = 0;
    var cdate = new Date(this.CalcAsOfDate);
    for (var df = 0; df < data.length; df++) {
      if (data[df].TransactionAmount) {
        if (new Date(data[df].TransactionDate) <= cdate) {
          TransactionAmount = TransactionAmount + data[df].TransactionAmount;
        }
      }
    }

    TransactionAmount = parseFloat((TransactionAmount).toFixed(2));
    this._equity.FundBalanceexcludingReserves = TransactionAmount;
    this.txtFundBalanceexcludingReserves = this.utils.formatNumberforTwoDecimalplaces(this._equity.FundBalanceexcludingReserves, this._equity.CurrencyText);
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
  private _bindGridDropdowsEquity() {

    var colTransactionTypeText = this.flexliabilityFunding.getColumn('TransactionTypes');
    if (colTransactionTypeText) {
      colTransactionTypeText.dataMap = this._buildDataMap(this.lstTransactionType, 'Name', 'Name');
    }

    var colStatusText = this.flexliabilityFunding.getColumn('StatusName');
    if (colStatusText) {
      colStatusText.dataMap = this._buildDataMap(this.lstStatusTextType, 'Name', 'Name');
    }

    var gridFacilityFee = this.flexFacilityFeeSchedule?.toArray();

    if (gridFacilityFee && gridFacilityFee.length > 0) {
      gridFacilityFee.forEach((grid: wjcGrid.FlexGrid) => {
        var colFeeTypeText = grid.columns.getColumn('FeeTypeText');
        if (colFeeTypeText) {
          colFeeTypeText.dataMap = this._buildDataMap(this.lstFeeType, 'LookupID', 'Name');
        }

        var colApplyTrueUpFeatureText = grid.columns.getColumn('ApplyTrueUpFeatureText');
        if (colApplyTrueUpFeatureText) {
          colApplyTrueUpFeatureText.dataMap = this._buildDataMap(this.lstApplyTrueUpFeature, 'LookupID', 'Name');
        }
      });
    }

    var gridFacilityRSS = this.flexFacilityRSS?.toArray();

    if (gridFacilityRSS && gridFacilityRSS.length > 0) {
      gridFacilityRSS.forEach((grid: wjcGrid.FlexGrid) => {
        var colrssValueType = grid.columns.getColumn('ValueTypeText');
        var colrssIntCalcMethod = grid.columns.getColumn('IntCalcMethodText');
        var colrssIndexNameText = grid.columns.getColumn('IndexNameText');
        var colrssDeterminationDateHolidayListText = grid.columns.getColumn('DeterminationDateHolidayListText');

        if (colrssValueType) {
          colrssValueType.dataMap = this._buildDataMap(this.lstRateSpreadSch_ValueType, 'LookupID', 'Name');
          this.dataMapValueType = this._buildDataMap(this.lstRateSpreadSch_ValueType, 'LookupID', 'Name');
        }
        if (colrssIntCalcMethod) {
          colrssIntCalcMethod.dataMap = this._buildDataMap(this.lstIntCalcMethodID, 'LookupID', 'Name');
        }
        if (colrssIndexNameText) {
          colrssIndexNameText.dataMap = this._buildDataMap(this.lstIndextype, 'LookupID', 'Name');
        }
        if (colrssDeterminationDateHolidayListText) {
          colrssDeterminationDateHolidayListText.dataMap = this._buildDataMap_holidayCalendarNamelist(this.holidayCalendarNamelist);
        }
      });
    }
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

  GetDebtJournalLedgerbyJournalEntryMasterID(): void {
    this._isListFetching = true;
    this.equitySrv.GetEquityJournalLedgerbyJournalEntryMasterID(this.EquityAccountID).subscribe(res => {
      if (res.Succeeded) {
        this.lstjournalLedger = res.ListjournalLedger;
        for (var i = 0; i < this.lstjournalLedger.length; i++) {
          if (this.lstjournalLedger[i].JournalEntryDate != null) {
            this.lstjournalLedger[i].JournalEntryDate = new Date(this.utils.convertDateToBindable(this.lstjournalLedger[i].JournalEntryDate));
          }
          if (this.lstjournalLedger[i].TransactionDate != null) {
            this.lstjournalLedger[i].TransactionDate = new Date(this.utils.convertDateToBindable(this.lstjournalLedger[i].TransactionDate));
          }
          if (this.lstjournalLedger[i].UpdatedDate != null) {
            this.lstjournalLedger[i].UpdatedDate = new Date(this.utils.convertDateToBindableWithTime(this.lstjournalLedger[i].UpdatedDate));
          }
        }

        if (this.lstjournalLedger.length > 0) {
          this._ShowMannualEntryDiv = true;
          this._ShowEmptyMannual = false;
          this.cvJournalLedger = new wjcCore.CollectionView(this.lstjournalLedger);
          this.cvJournalLedger.trackChanges = true;
          if (this.flexJournalLedger) {
            this.flexJournalLedger.invalidate();
          }

        } else {
          this._ShowMannualEntryDiv = false;
          this._ShowEmptyMannual = true;
        }

        setTimeout(function () {
          this._isListFetching = false;
        }.bind(this), 500);
      }
    });
  }

  invalidateJournalsTab() {
    if (!this._isJournalLedgerTabClicked) {
      this._isJournalLedgerTabClicked = true;
      this.GetDebtJournalLedgerbyJournalEntryMasterID();
    }
  }

  //-auto search
  checkDroppedDownChangedUserName(sender: wjNg2Input.WjAutoComplete, args: any) {
    var ac = sender;
    if (ac.selectedIndex == -1) {
      if (ac.text != this.selectedTypeText) {
        this.selectedTypeText = null;
        this.selectedTypeID = null;
      }
    }
    else {
      this.selectedTypeID = ac.selectedValue;
      this.selectedTypeText = ac.selectedItem.Valuekey;
    }
  }
  getAutosuggestusername = this.getAutosuggestusernameFunc.bind(this);
  getAutosuggestusernameFunc(query: any, max: any, callback: any) {
    this._result = null;
    if (query != null) {
      var self: any = this,
        result = self._cachedeal[query];
      if (result) {
        callback(result);
        return;
      }
      var params = { query: query, max: max };
      this._searchObj = new Search(query);

      this.equitySrv.GetAutosuggestDebtNameSubline(query).subscribe(res => {
        if (res.Succeeded) {
          var data: any = res.lstSearch;
          this._result = data;
          var _valueType;
          let items = [];
          for (var i = 0; i < this._result.length; i++) {
            var c = this._result[i];
            c.DisplayName = c.Valuekey;
          }
          callback(this._result);
        }
        else {
          //this.utilityService.navigateToSignIn();
        }
      });
      (error: string) => console.error('Error: ' + error)
    }
  }

  showDialog(modulename) {
    this._equity.modulename = modulename;
    this.getPeriodicDataByNoteId(this._equity);
  }

  showDialogFacility(modulename, FacilityAccountID) {
    this._equity.modulename = modulename;
    this._equity.FacilityAccountID = FacilityAccountID;
    this.getPeriodicDataByNoteId(this._equity);
  }

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

  ClosePopUp() {
    var modal = document.getElementById('myModal');
    $('#txtNoteJsonResponse').val('');
    modal.style.display = "none";
  }

  addFooterRowCashFlow(flexCashflowGrid: wjcGrid.FlexGrid) {
    var row = new wjcGrid.GroupRow();
    flexCashflowGrid.columnFooters.rows.push(row);
    flexCashflowGrid.bottomLeftCells.setCellData(0, 0, '\u03A3');

  }
  invalidateCashflow() {
    if (!this._isCashflowTabClicked) {
      this._isCashflowTabClicked = true;
      this.GetEquityTransactionByEquityAccountID();
      this.showEquityCalcStatus();
    }
  }
  GetEquityTransactionByEquityAccountID(): void {
    this._isListFetching = true;
    if (this.EquityAccountID == null) {
      this.EquityAccountID = "00000000-0000-0000-0000-000000000000";
    }
    this.equitySrv.GetEquityTransactionByEquityAccountID(this.EquityAccountID).subscribe(res => {
      if (res.Succeeded) {
        this.lstEquityTransaction = res.LiabilityCashFlow;
        var data = res.eqstatus;

        this._equity.UpdatedDate = data.UpdatedDate;
        this._equity.StatusText = data.StatusText;
        this._equity.ErrorMessage = data.ErrorMessage;

        this._isCashflowLoaded = true;
        if (this.lstEquityTransaction && this.lstEquityTransaction.length > 0) {
          for (var i = 0; i < this.lstEquityTransaction.length; i++) {
            if (this.lstEquityTransaction[i].Date != null) {
              this.lstEquityTransaction[i].Date = new Date(this.utils.convertDateToBindable(this.lstEquityTransaction[i].Date));
            }
          }
        }
        setTimeout(function () {
          this._isListFetching = false;
        }.bind(this), 500);

      }
    });
  }

  public getPeriodicDataByNoteId(_equity) {
    this._equity = _equity;
    this.modulename = _equity.modulename;
    this.lstPeriodicDataList = null;
    this._isPeriodicDataFetched = false;
    this._isPeriodicDataFetching = true;
    this._dvEmptyPeriodicDataMsg = false;

    var modal = document.getElementById('myModal');
    modal.style.display = "block";
    $.getScript("/js/jsDrag.js");
    this.equitySrv.GetHistoricalDataOfLiabilityModuleByAccountIdAPI(_equity, this._pageIndex, this._pageSize).subscribe(res => {
      if (res.Succeeded) {
        if (res.StatusCode != 404) {
          this._isPeriodicDataFetched = true;
          this._isPeriodicDataFetching = false;
          this._isSetHeaderEmpty = false;

          switch (_equity.modulename) {

            case "GeneralSetupDetailsEquity":
              this.modulename = "Effective Date Based Setup";
              this.lstPeriodicDataList = res.lstGeneralSetupDetails;
              this._isSetHeaderEmpty = true;
              break;
            case "FacilityPrepayAndAdditionalFeeScheduleLiability":
              this.modulename = "Facility Fee Schedule";
              this.lstPeriodicDataList = res.lstFacilityFeeHistory;
              this._isSetHeaderEmpty = true;
              break;
            case "FacilityRateSpreadScheduleLiability":
              this.modulename = "Facility Rate Spread Schedule";
              this.lstPeriodicDataList = res.lstFacilityRateSpreadHistory;
              this._isSetHeaderEmpty = true;
              break;
            case "InterestExpenseSchedule":
              this.modulename = "Interest Expense Schedule";
              this.lstPeriodicDataList = res.lstInterestExpenseScheduleHistory;
              this._isSetHeaderEmpty = true;
              break;
            default:
              break;
          }
          var data = this.lstPeriodicDataList;
          data.forEach((obj, i) => {
            {
              {
                setTimeout(() => {
                  var colCount = this.grdPeriodicData.columns.length;
                  for (i = 0; i < colCount; i++) {
                    this.grdPeriodicData.columnHeaders.setCellData(0, i, '');
                    this.grdPeriodicData.columns[0].width = 220;
                  }
                  this.grdPeriodicData.selectionMode = wjcGrid.SelectionMode.None;
                }, 20);
              }
            }
          });
          if (this.lstPeriodicDataList.length > 0) {
            const firstItem = this.lstPeriodicDataList[0];
            this.columns = Object.keys(firstItem).map(key => ({
              binding: key,
              header: key,
              width: '*',
              format: ''
            }));
          }
        } else {
          switch (_equity.modulename) {
            case "GeneralSetupDetailsEquity":
              this.modulename = "Effective Date Based Setup";
              break;
            default:
              break;
          }
          this._isPeriodicDataFetching = false;
          this.calcExceptionMsg = "No record found";
          this._dvEmptyPeriodicDataMsg = true;
        }
      }
      error => {
        this._isPeriodicDataFetching = false;
        this._dvEmptyPeriodicDataMsg = true;
        console.error('Error:', error);
      }
    });

  }
  ShowCountOnViewHistory() {
    if (this.ListEffectiveDateCount && this.ListEffectiveDateCount.length > 0) {
      for (var i = 0; i < this.ListEffectiveDateCount.length; i++) {
        var scheduleName = this.ListEffectiveDateCount[i].ScheduleName;
          switch (scheduleName) {
            case "GeneralSetupDetailsEquity":
              scheduleName = "GeneralSetupDetailsEquity";
              this.EffectiveDateCountGeneralSetupDetailsEquity = ' (' + this.ListEffectiveDateCount[i].EffectiveDateCount + ')';
              this._isSetHeaderEmpty = true;
              break;
          }
      }
    }
  }

  ShowCountOnViewHistoryFacility(DebtAccountID) {
    if (this.ListFacilityEffectiveDateCounts && this.ListFacilityEffectiveDateCounts.length > 0) {
      for (var i = 0; i < this.ListFacilityEffectiveDateCounts.length; i++) {
        if (this.ListFacilityEffectiveDateCounts[i].NoteAccountId == DebtAccountID) {
          var scheduleName = this.ListFacilityEffectiveDateCounts[i].ScheduleName;
          switch (scheduleName) {
            case "PrepayAndAdditionalFeeScheduleLiability":
              scheduleName = "PrepayAndAdditionalFeeScheduleLiability";
              this.EffectiveDateCountFeeFacility = ' (' + this.ListFacilityEffectiveDateCounts[i].EffectiveDateCount + ')';
              this._isSetHeaderEmpty = true;
              break;
            case "RateSpreadScheduleLiability":
              scheduleName = "RateSpreadScheduleLiability";
              this.EffectiveDateCountRateFacility = ' (' + this.ListFacilityEffectiveDateCounts[i].EffectiveDateCount + ')';
              this._isSetHeaderEmpty = true;
              break;
            case "InterestExpenseSchedule":
              scheduleName = "InterestExpenseSchedule";
              this.EffectiveDateCountInterestExpenseSchedule = ' (' + this.ListFacilityEffectiveDateCounts[i].EffectiveDateCount + ')';
              this._isSetHeaderEmpty = true;
              break;
            default:
              break;
          }
        }
      }
    }
  }

  QueueEquityForCalculation(): void {
    this._isListFetching = true;
    if (this.EquityAccountID != null) {
      this.equitySrv.QueueEquityForCalculation(this.EquityAccountID).subscribe(res => {
        if (res.Succeeded) {

          this._Showsuccessmessage = true;
          this._messageSuccess = res.Message;
          this._isCashflowLoaded = false;
          this._equity.StatusText = "Processing";
          this.showEquityCalcStatus();
          setTimeout(function () {
            this._isListFetching = false;
            this._Showsuccessmessage = false;
            this._messageSuccess = "";
          }.bind(this), 5000);

        } else {
          this._Showsuccessmessage = true;
          this._messageSuccess = res.Message;

          setTimeout(function () {
            this._ShowmessageWarning = false;
            this._messageFail = "";
          }.bind(this), 5000);
        }
      });
    }

  }

  showEquityCalcStatus() {
    if (this.actiontype == "new") {
      this._equity.EquityAccountID = "00000000-0000-0000-0000-000000000000";
    }
    var status = setInterval(() => {
      this.equitySrv.GetEquityCalcInfoByEquityAccountID(this._equity).subscribe(res => {
        if (res.Succeeded) {
          var data = res.eqstatus;
          if (data.StatusText != "Completed" && data.StatusText != "Failed") {
            this._equity.UpdatedDate = data.UpdatedDate;
            this._equity.StatusText = data.StatusText;
            this._equity.ErrorMessage = data.ErrorMessage;
            //setTimeout(() => {
            //  this.showEquityCalcStatus();
            //}, 2000);
          }
          else {
            clearInterval(status);
            this._equity.UpdatedDate = data.UpdatedDate;
            this._equity.StatusText = data.StatusText;
            this._equity.ErrorMessage = data.ErrorMessage;
            if (this._isCashflowLoaded == false) {
              this.GetEquityTransactionByEquityAccountID();
            }
          }
          if (data.StatusText === undefined || data.StatusText == null || data.StatusText == '') {
            this._equity.StatusText = "Nevercalculated";
            clearInterval(status);
          }
        }

      });
    }, 30000);
  }



  downloadCashflowsExportData(): void {
    this._isListFetching = true;
    var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '-');
    var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '-');
    var fileName = this._equity.EquityName + "_" + "_Cashflow_" + displayDate + "_" + displayTime + ".xlsx";
    var equitystring = this.EquityAccountID + "||" + "Equity";
    this.equitySrv.GetEquityCashflowsExportData(equitystring).subscribe(res => {
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
      this._isListFetching = false;
    });

  }

  downloadCapContriExportData(): void {
    this._isListFetching = true;
    var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '-');
    var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '-');
    var fileName = this._equity.EquityName + "_" + "_CapitalContribution_" + displayDate + "_" + displayTime + ".xlsx";

    this.equitySrv.GetEquityCapitalContributionExportExcel(this.EquityAccountID).subscribe(res => {
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
      this._isListFetching = false;
    });

  }

  downloadCashflowExportExcelEquityonly(): void {
    this._isListFetching = true;
    var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '-');
    var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '-');
    var fileName = this._equity.EquityName + "_" + "_ExportExcelCashflow_" + displayDate + "_" + displayTime + ".xlsx";

    this.equitySrv.GetCashflowTabUIDataforonlyEquityExportExcel(this.EquityAccountID).subscribe(res => {
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
      this._isListFetching = false;
    });
  }

  GetLiabilityFundingScheduleAggregate(showloader): void {
    this._isListFetching = showloader;
    this.debtSrv.GetLiabilityFundingScheduleAggregateByLiabilityTypeID(this.EquityAccountID).subscribe(res => {
      if (res.Succeeded) {
        this.lstliabilityMasterFunding = res.dt;
        this.GetLiabilityFundingScheduleDetail();
        for (var i = 0; i < this.lstliabilityMasterFunding.length; i++) {
          if (this.lstliabilityMasterFunding[i].TransactionDate != null) {
            var cdate = this.lstliabilityMasterFunding[i].TransactionDate;
            this.lstliabilityMasterFunding[i].TransactionDateUsedInSort = new Date(cdate);
            this.lstliabilityMasterFunding[i].TransactionDate = this.utils.convertDateToBindable(this.lstliabilityMasterFunding[i].TransactionDate);
          }
        }

        this.cvliabilityFundingAggregate = new wjcCore.CollectionView(this.lstliabilityMasterFunding);
        //this.sortGrid();
        this.cvliabilityFundingAggregate.trackChanges = true;
        this.CalculateFundBalance(this.lstliabilityMasterFunding);
        setTimeout(function () {
          this._isListFetching = false;
        }.bind(this), 200);
      }

    })
  }
  sortGrid() {
    this.cvliabilityFundingAggregate.sortDescriptions.clear();
    let sd = new wjcCore.SortDescription("TransactionDateUsedInSort", true);
    /* let sd1 = new wjcCore.SortDescription("Applied", true);*/
    this.cvliabilityFundingAggregate.sortDescriptions.push(sd);
    /*   this.cvliabilityFundingAggregate.sortDescriptions.push(sd1);*/
    //this.cvliabilityFundingAggregate.trackChanges = true;
    this.flexliabilityFunding.invalidate(true);

  }
  GetDebtFundingScheduleByLiabilityTypeID(): void {
    this._isListFetching = true;
    this.debtSrv.GetDebtFundingScheduleByLiabilityTypeID(this.EquityAccountID).subscribe(res => {
      if (res.Succeeded) {

        this.lstliabilityFundingList = res.ListLiabilityFundingSchedule;

        for (var i = 0; i < this.lstliabilityFundingList.length; i++) {
          if (this.lstliabilityFundingList[i].TransactionDate != null) {
            this.lstliabilityFundingList[i].TransactionDate = new Date(this.utils.convertDateToBindable(this.lstliabilityFundingList[i].TransactionDate));
          }
          if (this.lstliabilityFundingList[i].AssetTransactionDate != null) {
            this.lstliabilityFundingList[i].AssetTransactionDate = new Date(this.utils.convertDateToBindable(this.lstliabilityFundingList[i].AssetTransactionDate));
          }
        }


        this.cvliabilityFundingList = new wjcCore.CollectionView(this.lstliabilityFundingList);
        this.cvliabilityFundingList.trackChanges = true;
        this.flexliabilityFunding.invalidate();

        setTimeout(function () {
          this._isListFetching = false;
        }.bind(this), 500);
      }
    });
  }

  GetLiabilityFundingScheduleDetail(): void {
    this._isListFetching = true;
    this.debtSrv.getLiabilityFundingScheduleDetailByLiabilityID(this.EquityAccountID).subscribe(res => {
      if (res.Succeeded) {
        this.lstliabilityDetailFundingOrg = res.ListLiabilityFundingSchedule;
        for (var i = 0; i < this.lstliabilityDetailFundingOrg.length; i++) {
          if (this.lstliabilityDetailFundingOrg[i].TransactionDate != null) {
            this.lstliabilityDetailFundingOrg[i].TransactionDate = this.utils.convertDateToBindable(this.lstliabilityDetailFundingOrg[i].TransactionDate);
          }
          if (this.lstliabilityDetailFundingOrg[i].AssetTransactionDate != null) {
            this.lstliabilityDetailFundingOrg[i].AssetTransactionDate = this.utils.convertDateToBindable(this.lstliabilityDetailFundingOrg[i].AssetTransactionDate);
          }
        }
        this._isListFetching = false;
      }
    })
  }

  GetLiabFundingScheduleDetails(Transdate: any, TransactionTypes: any) {
    Transdate = this.utils.convertDateToBindable(Transdate);
    //this.lstliabilityDetailFunding = this.lstliabilityDetailFundingOrg.filter(x => x.TransactionDate === Transdate && x.TransactionTypes == TransactionTypes);

    //let liabilityFundingSchedule = this._liabilityFundingScheduleMap.get(Transdate);

    let liabilityFundingSchedule = this.lstliabilityDetailFundingOrg.filter(
      x => x.TransactionDate === Transdate && x.TransactionTypes == TransactionTypes);
    this._liabilityFundingScheduleMap.set(Transdate, liabilityFundingSchedule);

    return liabilityFundingSchedule;

  }

  downloadBloBData(): void {
    this._isListFetching = true;

    this._equity.FileName = "LiabilityOutput/" + this._equity.FileName;

    this.equitySrv.downloadBloBData(this._equity.FileName).subscribe(res => {

      var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '_');
      var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '_');

      var fileName = this._equity.FileName;

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

      this._isListFetching = false;

    });
  }

  GetAllowBasicLogin() {
    this.permissionSrv.GetAllAppSetting().subscribe(res => {
      if (res.Succeeded) {
        var data = res.AllSettingKeys;
        if (data.find((x: any) => x.Key == "AllowLiabBlobDownld").Value == "0")
          this._AllowLiabBlobDownld = false;
        else
          this._AllowLiabBlobDownld = true;
      }
    });

  }

  getIsReadOnly(item) {
    return item.Applied == true;
  }
  originalAppliedState: any;
  celleditBeginliabilityFunding(liabilitymastergrid: wjcGrid.FlexGrid, e: wjcGrid.CellEditEndingEventArgs) {
    var row = e.row;
    var item = liabilitymastergrid.rows[row].dataItem;
    this.originalAppliedState = item.Applied;

    if (item.Applied == undefined) {
      item.Applied = false;
    }

    if (liabilitymastergrid.columns[e.col].binding !== "Applied") {
      e.cancel = this.getIsReadOnly(liabilitymastergrid.rows[e.row].dataItem);
    }

    this.oldTransdate = this.utils.convertDateToBindable(item.TransactionDate);
  }

  celleditEndedliabilityFunding(liabilitymastergrid: wjcGrid.FlexGrid, e: wjcGrid.CellEditEndingEventArgs) {
    var row = e.row;
    var item = liabilitymastergrid.rows[row].dataItem;
    item.AccountID = this.EquityAccountID;

    if (e.col === liabilitymastergrid.columns.findIndex(col => col.binding === "Applied")) {
      if (item.Applied === false) {
        const nextItem = liabilitymastergrid.rows[row + 1]?.dataItem;
        if (nextItem && nextItem.Applied === true) {
          item.Applied = this.originalAppliedState;
          this.CustomAlert("You can't remove a wire confirmation on an earlier date without removing the wire confirmation on later dates.");
          return;
        }

        // for assigning status as Planned if applied is false
        item.StatusName = "Planned";
        var filteredarray = this.lstStatusTextType.filter(x => x.Name == item.StatusName);
        if (filteredarray.length != 0) {
          item.StatusID = Number(filteredarray[0].LookupID);
          this.flexliabilityFunding.invalidate(true);
        }
      }

      if (item.Applied === true) {
        const preItem = liabilitymastergrid.rows[row - 1]?.dataItem;
        if (preItem && preItem.Applied === false) {
          item.Applied = this.originalAppliedState;
          this.CustomAlert("You can't confirm wire on a later date without confirming all wires in between.");
          return;
        }

        // for assigning status as completed if applied is true
        item.StatusName = "Completed";
        var filteredarray = this.lstStatusTextType.filter(x => x.Name == item.StatusName);
        if (filteredarray.length != 0) {
          item.StatusID = Number(filteredarray[0].LookupID);
          this.flexliabilityFunding.invalidate(true);
        }
      }
    }

    const existingRowIndex = this.FundingAggregateEditedData.findIndex(x => x.TransactionDate === item.TransactionDate);

    if (existingRowIndex !== -1) {
      this.FundingAggregateEditedData[existingRowIndex] = item;
    } else {
      this.FundingAggregateEditedData.push(item);
    }

    this.NewTransdate = this.utils.convertDateToBindable(item.TransactionDate);

    if (e.col == 0) {
      let VTransactionDate = item.TransactionDate;
      item.TransactionDateUsedInSort = VTransactionDate;
    }
    
    this.ListDealLevelLiabilityFundingSchedule.forEach(x => {
      if (x.TransactionDate === this.oldTransdate) {
        x.TransactionDate = this.NewTransdate;
        x.Applied = item.Applied;
        x.TransactionTypes = item.TransactionTypes;
        x.TransactionDateUsedInSort = item.TransactionDateUsedInSort;

        const existingRowIndex = this.LFSDealLevelEditedRows.findIndex(item => item.LiabilityFundingScheduleDealID === x.LiabilityFundingScheduleDealID);

        if (existingRowIndex !== -1) {
          this.LFSDealLevelEditedRows[existingRowIndex] = x;
        } else {
          this.LFSDealLevelEditedRows.push(x);
        }

      }
    });

    this.lstliabilityFundingList.forEach(x => {
      if (this.utils.convertDateToBindable(x.TransactionDate) === this.oldTransdate) {
        x.Applied = item.Applied;
        x.TransactionTypes = item.TransactionTypes;

        const existingRowIndex = this.listNewliabilityFundingList.findIndex(item => item.LiabilityFundingScheduleID === x.LiabilityFundingScheduleID);

        if (existingRowIndex !== -1) {
          this.listNewliabilityFundingList[existingRowIndex] = x;
        } else {
          this.listNewliabilityFundingList.push(x);
        }

      }
    });
    
    if (e.col == 0) {
      this.sortGrid();
    }
  }

  CopiedliabilityFunding(liabilitymastergrid: wjcGrid.FlexGrid, e: wjcGrid.CellEditEndingEventArgs) {
    for (var i = 0; i < this.lstliabilityMasterFunding.length; i++) {
      if (this.lstliabilityMasterFunding[i].LiabilityFundingScheduleAggregateID == undefined) {
        this.lstliabilityMasterFunding[i].AccountID = this.EquityAccountID;
        this.FundingAggregateEditedData.push(this.lstliabilityMasterFunding[i]);
      }
    }
  }

  isRowNew(item: any): boolean {
    return item.Applied !== true;
  }

  getDistinct(array, key) {
    const redUniq = [
      ...array
        .reduce((uniq, curr) => {
          if (!uniq.has(curr[key])) {
            uniq.set(curr[key], curr);
          }
          return uniq;
        }, new Map())
        .values()
    ];
    return redUniq;
  }

  initDetailGrid(detailGrid: any, row: any, item: any) {

    this.DetailFundingScheduleNorecord = false;
    var Transdate = this.utils.convertDateToBindable(item.TransactionDate);

    if (this.ListDealLevelLiabilityFundingSchedule !== undefined && this.ListDealLevelLiabilityFundingSchedule !== null) {

      let liabilityFundingSchedule = this.ListDealLevelLiabilityFundingSchedule.filter(
        x => x.TransactionDate === Transdate && x.TransactionTypes == item.TransactionTypes);
      this._liabilityFundingScheduleMap.set(Transdate, liabilityFundingSchedule);

      this.cvliabilityFundingDealLevel = new wjcCore.CollectionView(liabilityFundingSchedule);
      this.cvliabilityFundingDealLevel.trackChanges = true;

      if (liabilityFundingSchedule.length == 0 && item.Applied == true) {
        this.DetailFundingScheduleNorecord = true;
        var equityfundsubgrid = document.getElementById('equityfundsubgrid');
        equityfundsubgrid.style.display = "none";
      }
      else {
        this.DetailFundingScheduleNorecord = false;
      }
    }

    detailGrid.itemsSource = this.cvliabilityFundingDealLevel;

    var coldeal = this.equityfundsubgrid.getColumn('DealAccountID');
    if (coldeal) {
      coldeal.dataMap = this._buildDataMap(this.listAssociatedDeals, 'LookupIDGuID', 'Name');
    }

    var r = new wjcGrid.GroupRow();
    detailGrid.columnFooters.rows.push(r);
    detailGrid.bottomLeftCells.setCellData(0, 0, '\u03A3');

    this.flexliabilityFunding.autoSizeRow(row.index + 1);
    this._isListFetching = false;

  }
  onCellEditBeginLFSDealLevel(s: any, e: any) {
    e.cancel = this.getIsReadOnly(s.rows[e.row].dataItem);
  }

  onCellEditEndedLFSDealLevel(s: any, e: any, TransactionTypes: any, TransactionDate: any) {
    var row = e.row;
    const editedItem = s.rows[row].dataItem;
    editedItem.TransactionTypes = TransactionTypes;

    if (editedItem.TransactionDate !== undefined && editedItem.TransactionDate !== null) {
      if (this.utils.convertDateToBindable(editedItem.TransactionDate) !== this.utils.convertDateToBindable(TransactionDate)) {
        this.CustomAlert("The Transaction Date in inner grid should be same as the outer grid Transaction Date.");
        return;
      }
    }

    if (editedItem) {
      const existingRowIndex = this.LFSDealLevelEditedRows.findIndex(item => item.LiabilityFundingScheduleDealID === editedItem.LiabilityFundingScheduleDealID);

      if (existingRowIndex !== -1) {
        this.LFSDealLevelEditedRows[existingRowIndex] = editedItem;
      } else {
        this.LFSDealLevelEditedRows.push(editedItem);
      }
        var tnxdate = new Date(editedItem.TransactionDate)
        var notelist = this.lstliabilityFundingList.filter(x => x.DealAccountID == editedItem.DealAccountID && x.TransactionDate.getTime() == tnxdate.getTime());
        if (notelist.length > 0) {
        }
        else {
          var deallist = this.lstliabilityFundingList.filter(x => x.DealAccountID == editedItem.DealAccountID);
          notelist = this.getDistinct(deallist, "AssetAccountID");
        }
        this.DistrubuteAmountbasedonratio(notelist, editedItem);
    }
  }

  DistrubuteAmountbasedonratio(notelist, editedItem) {

    var dealamount = editedItem.TransactionAmount;
    var tnxdate = new Date(editedItem.TransactionDate);
    var Applied = editedItem.Applied;
    var TransactionTypes = editedItem.TransactionTypes;
    //delete old data on same date 
    for (var j = this.listNewliabilityFundingList.length - 1; j >= 0; j--) {
      if (this.listNewliabilityFundingList[j].DealAccountID == editedItem.DealAccountID && this.listNewliabilityFundingList[j].TransactionDate.getTime() == tnxdate.getTime()) {
        this.listNewliabilityFundingList.splice(j, 1);
      }
    }

    var sumOriginalTotalCommitment = 0;
    for (var i = 0; i < notelist.length; i++) {
      sumOriginalTotalCommitment = sumOriginalTotalCommitment + notelist[i].OriginalTotalCommitment;
    }

    sumOriginalTotalCommitment = this.utils.ConverttoFloat((sumOriginalTotalCommitment).toFixed(2));
    for (var i = 0; i < notelist.length; i++) {
      notelist[i].TransactionDate = tnxdate;
      notelist[i].TransactionTypes = TransactionTypes;
      notelist[i].Applied = Applied;
      notelist[i].Ratio = this.utils.DivideIfNotZero(notelist[i].OriginalTotalCommitment, sumOriginalTotalCommitment);
      notelist[i].TransactionAmount = this.utils.ConverttoFloat(dealamount * notelist[i].Ratio);
      this.listNewliabilityFundingList.push(notelist[i]);
    }

  }
  CalculateUnallocatedBalance() {
    for (var df = 0; df < this.lstliabilityMasterFunding.length; df++) {
      let currentbalance = 0;
      let Mastertnxamount = this.lstliabilityMasterFunding[df].TransactionAmount;
      let PreviousUnAllocatedbalance = 0;
      let CurrentUnAllocatedbalance = 0;
      let liabilityFundingSchedule = this.ListDealLevelLiabilityFundingSchedule.filter(
        x => x.TransactionDate === this.lstliabilityMasterFunding[df].TransactionDate && x.TransactionTypes == this.lstliabilityMasterFunding[df].TransactionTypes);

      // calculate current balance
      for (var f = 0; f < liabilityFundingSchedule.length; f++) {
        currentbalance = currentbalance + liabilityFundingSchedule[f].TransactionAmount;
      }
      //get PreviousUnAllocatedbalance
      if (df > 0) {
        PreviousUnAllocatedbalance = this.lstliabilityMasterFunding[df - 1].CurrentUnAllocatedbalance;
      } else {
        PreviousUnAllocatedbalance = 0;
      }
      currentbalance = this.utils.ConverttoFloat(currentbalance);
      Mastertnxamount = this.utils.ConverttoFloat(Mastertnxamount);
      PreviousUnAllocatedbalance = this.utils.ConverttoFloat(PreviousUnAllocatedbalance);
      let balcomp = this.utils.ConverttoFloat((Mastertnxamount - currentbalance))

      if (balcomp < 0) {
        balcomp = balcomp * -1;
        CurrentUnAllocatedbalance = Math.abs(PreviousUnAllocatedbalance - balcomp);
      }
      else {
        CurrentUnAllocatedbalance = Math.abs(PreviousUnAllocatedbalance + balcomp);
      }


      this.lstliabilityMasterFunding[df].CurrentUnAllocatedbalance = CurrentUnAllocatedbalance;

    }


    this.cvliabilityFundingAggregate = new wjcCore.CollectionView(this.lstliabilityMasterFunding);
    this.cvliabilityFundingAggregate.trackChanges = true;
    this.flexliabilityFunding.invalidate(true);
  }

  liabilityNoteLevelFundingSchedule: any;
  _isDataFetching: boolean = false;
  _isDataFetched: boolean = false;
  initNoteLevelLiabilityFundingGrid(item: any) {
    this._isDataFetching = true;
    var Transdate = this.utils.convertDateToBindable(item.TransactionDate);

    this.liabilityNoteLevelFundingSchedule = this.lstliabilityFundingList.filter(
      x => this.utils.convertDateToBindable(x.TransactionDate) === Transdate && x.TransactionTypes == item.TransactionTypes && x.DealAccountID === item.DealAccountID);
    this._liabilityFundingScheduleMap.set(Transdate, this.liabilityNoteLevelFundingSchedule);

    var modal = document.getElementById('myModalLiabilityNoteFunding');
    modal.style.display = "block";
    $.getScript("/js/jsDrag.js");
    this._isDataFetching = false;
    this._isDataFetched = true;
  }
  ClosePopUpAssetFunding() {
    var modal = document.getElementById('myModalLiabilityNoteFunding');
    modal.style.display = "none";
  }

  GetCashAccountsCategory(): void {
    this.equitySrv.getCashAccountList().subscribe(res => {
      this.lstCashAccountCategory = res._lstCashAccount;
    });
  }

  OnChangeInterestExpense() {
    var newInterestExpenseData = {
      InterestExpenseScheduleID: this.selectedInterestExpenseScheduleID,
      DebtAccountID: this.CurrentDebtAccountID,
      AdditionalAccountID: this.EquityAccountID,
      EffectiveDate: this.selectedEffectiveDate,
      InitialInterestAccrualEnddate: this.selectedInitialInterestAccrualEnddate,
      PaymentDayOfMonth: this.selectedPaymentDayMonth,
      PaymentDateBusinessDayLag: this.selectedPaymentDateBusinessDayLag,
      Determinationdateleaddays: this.selectedDeterminationdateleaddays,
      DeterminationDateReferenceDayOftheMonth: this.selectedDeterminationDateRefDayMonth,
      FirstRateIndexResetDate: this.selectedFirstRateIndexResetDate,
      InitialIndexValueOverride: this.selectedInitialIndexValueOverride,
      Recourse: this.selectedRecourse,
      EventID: this.selectedEventID
    };

    var existingDataIndex = this.debtDataStore[this.CurrentDebtAccountID].lstInterestExpense.findIndex(
      item => item.DebtAccountID === this.CurrentDebtAccountID
    );

    if (existingDataIndex === -1) {
      this.debtDataStore[this.CurrentDebtAccountID].lstInterestExpense.push(newInterestExpenseData);
    } else {
      this.debtDataStore[this.CurrentDebtAccountID].lstInterestExpense[existingDataIndex] = newInterestExpenseData;
    }

    if (this.ListInterestExpense != null && this.ListInterestExpense.length > 0)
      this.ListInterestExpense = this.ListInterestExpense.filter(item => item.DebtAccountID !== this.CurrentDebtAccountID);
    this.ListInterestExpense = this.ListInterestExpense.concat(this.debtDataStore[this.CurrentDebtAccountID].lstInterestExpense);
  }

  GetFacilityInterestExpenseData(DebtAccountID) {
    this._isListFetching = true;
    this.selectedInterestExpenseScheduleID = null;
    this.selectedEventID = null;
    this.selectedEffectiveDate = null;
    this.selectedInitialInterestAccrualEnddate = null;
    this.selectedPaymentDayMonth = null;
    this.selectedPaymentDateBusinessDayLag = null;
    this.selectedDeterminationdateleaddays = null;
    this.selectedDeterminationDateRefDayMonth = null;
    this.selectedFirstRateIndexResetDate = null;
    this.selectedInitialIndexValueOverride = null;
    this.selectedRecourse = null;

    var lstInterestExpense = this.ListInterestExpense.filter(item => item.DebtAccountID === DebtAccountID);

    if (lstInterestExpense != null && lstInterestExpense.length > 0) {
      this.selectedInterestExpenseScheduleID = lstInterestExpense[0].InterestExpenseScheduleID;
      this.selectedEventID = lstInterestExpense[0].EventID;
      this.selectedEffectiveDate = lstInterestExpense[0].EffectiveDate;
      this.selectedInitialInterestAccrualEnddate = lstInterestExpense[0].InitialInterestAccrualEnddate;
      this.selectedPaymentDayMonth = lstInterestExpense[0].PaymentDayOfMonth;
      this.selectedPaymentDateBusinessDayLag = lstInterestExpense[0].PaymentDateBusinessDayLag;
      this.selectedDeterminationdateleaddays = lstInterestExpense[0].Determinationdateleaddays;
      this.selectedDeterminationDateRefDayMonth = lstInterestExpense[0].DeterminationDateReferenceDayOftheMonth;
      this.selectedFirstRateIndexResetDate = lstInterestExpense[0].FirstRateIndexResetDate;
      this.selectedInitialIndexValueOverride = lstInterestExpense[0].InitialIndexValueOverride;
      this.selectedRecourse = lstInterestExpense[0].Recourse;  
    }
    this.ShowCountOnViewHistoryFacility(DebtAccountID);
    setTimeout(function () {
      this._isListFetching = false;
    }.bind(this), 500);
  }

  AddPrepayAndAdditionalFeeScheduleLiabilityDetail(item: any) {
    this._isDataFetching = true;
    var filteredarray = this.lstFeeType.filter(x => x.Name == item.FeeTypeText)
    if (filteredarray.length != 0) {
      item.ValueTypeID = Number(filteredarray[0].LookupID);
    }
    if (this.ListPrepayAndAdditionalFeeScheduleLiabilityDetail != undefined) {
      this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail = this.ListPrepayAndAdditionalFeeScheduleLiabilityDetail.filter(x => x.ValueTypeID == item.ValueTypeID && this.utils.convertDateToBindable(x.StartDate) == this.utils.convertDateToBindable(item.StartDate));
    }
    if (this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail.length == 0) {
      var temp = {
        AccountID: item.AccountID,
        AdditionalAccountID: item.AdditionalAccountID,
        EventID: item.EventID,
        StartDate: this.utils.convertDateToBindable(item.StartDate),
        ValueTypeID: item.ValueTypeID,
        CreatedBy: null,
        CreatedDate: null,
        UpdatedBy: null,
        UpdatedDate: null,
        From: null,
        To: null,
        Value: null,
        EffectiveDate: this.utils.convertDateToBindable(this.selectedFacilityFeeEffectiveDate)
      };
      this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail.push(temp);
    }
    this.modelheaderFeeName = item.FeeName;
    this.modelheaderDate = this.utils.convertDateToBindable(item.StartDate);

    var modal = document.getElementById('myModalPrepayAndAdditionalFeeScheduleLiabilityDetail');
    modal.style.display = "block";
    $.getScript("/js/jsDrag.js");
    this._isDataFetching = false;
    this._isDataFetched = true;
  }

  ClosePopUpPrepayAndAdditionalFeeScheduleLiabilityDetail() {
    var modal = document.getElementById('myModalPrepayAndAdditionalFeeScheduleLiabilityDetail');
    modal.style.display = "none";
  }

  UpdatePrepayAndAdditionalFeeScheduleLiabilityDetail() {
    //delete old rows
    if (this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail.length > 0) {
      for (let i = this.ListPrepayAndAdditionalFeeScheduleLiabilityDetail.length - 1; i >= 0; i--) {
        if (this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[0].ValueTypeID == this.ListPrepayAndAdditionalFeeScheduleLiabilityDetail[i].ValueTypeID &&
          this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[0].StartDate == this.ListPrepayAndAdditionalFeeScheduleLiabilityDetail[i].StartDate) {
          this.ListPrepayAndAdditionalFeeScheduleLiabilityDetail.splice(i, 1);
        }
      }
    }

    //Add new rows
    for (let j = 0; j < this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail.length; j++) {
      if (j > 0) {
        this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[j].AccountID = this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[0].AccountID;
        this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[j].AdditionalAccountID = this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[0].AdditionalAccountID;
        this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[j].StartDate = this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[0].StartDate;
        this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[j].ValueTypeID = this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[0].ValueTypeID;
        this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[j].EventID = this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[0].EventID;

        this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[j].CreatedBy = this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[0].CreatedBy;
        this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[j].CreatedDate = this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[0].CreatedDate;
        this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[j].UpdatedBy = this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[0].UpdatedBy;
        this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[j].UpdatedDate = this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[0].UpdatedDate;
        this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[j].EffectiveDate = this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[0].EffectiveDate;
      }
      this.ListPrepayAndAdditionalFeeScheduleLiabilityDetail.push(this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail[j]);
    }
    var modal = document.getElementById('myModalPrepayAndAdditionalFeeScheduleLiabilityDetail');
    modal.style.display = "none";
  }
  
  ngAfterViewInit() {
    // Loop through all FlexGrid instances
    this.flexFacilityFeeSchedule.forEach(grid => {
      // Assume grid is your wijmo FlexGrid instance
      /*grid.formatItem.addHandler((s, e) => {
        // Target only the column where the <a> tag is (e.g., "action")
        if (s.columns[e.col].header === 'Add') {
          const rowData = s.rows[e.row].dataItem;
          
          // Conditionally add the <a> tag
          if (rowData.FeeTypeText === 'Mod Fee') {
            e.cell.hidden = false;
          } else {
            // Optionally do something else, like leave it blank or put placeholder
            e.cell.hidden = true;
          }
        }
      });*/
      grid.invalidate(); // Refreshes all cells
    });
  }
  
}

const routes: Routes = [

  { path: '', component: EquityComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjGridDetailModule, WjInputModule, WjGridFilterModule],
  declarations: [EquityComponent]
})

export class equityModule { }
