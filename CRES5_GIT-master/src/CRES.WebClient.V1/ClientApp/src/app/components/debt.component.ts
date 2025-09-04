
import { Component, ViewChild, QueryList, ViewChildren } from "@angular/core";
import { Router, ActivatedRoute, Params } from '@angular/router';
import * as wjcGrid from '@grapecity/wijmo.grid';
import * as wjcCore from '@grapecity/wijmo';
import { NgModule } from '@angular/core';
import { Paginated } from '../core/common/paginated.service';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { CommonModule, Location } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { LoggingService } from './../core/services/logging.service';
import { WjInputModule } from '@grapecity/wijmo.angular2.input';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import { debtService } from '../core/services/debt.service';
import { equityService } from '../core/services/equity.service';
import { Debt } from "../core/domain/debt.model";
import { UtilsFunctions } from './../core/common/utilsfunctions';
import { UtilityService } from '../core/services/utility.service';
import { MembershipService } from '../core/services/membership.service';
import { NoteService } from '../core/services/note.service';
import { WjGridDetailModule } from '@grapecity/wijmo.angular2.grid.detail';
import * as wjOdata from '@grapecity/wijmo.odata';
import { JournalLedger, JournalLedgerMaster } from "../core/domain/journalLedger.model";
import { liabilityNoteService } from '../core/services/liabilityNote.service';
import '@grapecity/wijmo.styles/wijmo.css';
import * as wjNg2Input from '@grapecity/wijmo.angular2.input';
import { Search } from "../core/domain/search.model";

declare var $: any;
@Component({
  selector: "debt",
  templateUrl: "./debt.html",
  providers: [debtService, UtilsFunctions, NoteService, equityService, liabilityNoteService]
})

export class DebtComponent extends Paginated {
  public _isShowCalcNotes: boolean = true;
  public _isShowDownloadCashflow: boolean = true;
  public _isShowSave: boolean = true;
  public _isShowCancel: boolean = true;
  public _isShowMain: boolean = true;
  public _isShowNotes: boolean = true;
  public _isShowDrawsPaydowns: boolean = true;
  public _isShowActuals: boolean = true;
  public _isShowCashflow: boolean = true;
  public _isShowJournalLedger: boolean = true;
  public _isListFetching: boolean;
  public txtCurrentBalanceValue: number;
  public txtCommitmentValue: number;
  public txtMaxAdvanceRate: number;
  public txtTargetAdvanceRate: number;
  public _ShowmessagedivMsg: string = '';
  public _Showmessagediv: boolean = false;
  public _ShowmessageWarning: boolean = false;
  public _messageFail: string = '';

  lstIndextype: any;
  lststatus: any;
  lstDebtNote: any;
  lstAccountCategory: any;
  lstApplyTrueUpFeature: any;
  public actiontype: any;

  public LiabilityTypeID: any;
  public DebtAccountID: any;
  public JournalEntryMasterID: any;
  borrowerTransactionsDataSource: any[];
  public cvDebtNote: wjcCore.CollectionView;
  public _isNotesTabClicked: boolean = false;
  public _isDebtDrawsPaydownsClicked: boolean = false;
  public _isCashflowTabClicked: boolean = false;
  public _isJournalLedgerTabClicked: boolean = false;
  public ShowHideFlagRateSpreadSchedule: boolean = false;
  public ShowHideFlagFeeSchedule: boolean = false;
  public EffectiveDateCountInterestExpenseSchedule: any;
  public _isSetHeaderEmpty: boolean = false;
  public modulename: string;
  public lstPeriodicDataList: any;
  public _isPeriodicDataFetching: boolean;
  public _isPeriodicDataFetched: boolean = true;
  public _dvEmptyPeriodicDataMsg: boolean = false;
  public lstFeeType: any;
  public ListofFundName: any;
  lstRateSpreadSch_ValueType: any;
  lstIntCalcMethodID: any;
  calcExceptionMsg: string;
  public holidayCalendarNamelist: any = [];
  dataMapValueType: any;
  lstAssociatedEquity: any;
  CurrentEquityName: any;
  CurrentEquityAccountID: any;
  CurrentEquityGUID: any;
  FacilityFeeSchedule: any;
  FacilityRateSpreadSchedule: any;
  public ListDebtExtInterest: any;
  public ListInterestExpense: any;
  public selectedInitialInterestAccrualEnddate: any;

  public selectedFirstRateIndexResetDate: any;
  public selectedInitialIndexValueOverride: any;
  public selectedRecourse: any;

  public selectedAccrualFrequency: any;
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
  public selectedFacilityFeeEffectiveDate: any;
  public selectedFacilityRSSEffectiveDate: any;
  debtDataStore = {};
  public EffectiveDateCountRateFacility: any;
  public EffectiveDateCountFeeFacility: any;
  public ListFacilityEffectiveDateCounts: any;
  public EffectiveDateCountGeneralSetupDetailsDebt: any;

  columns: {
    binding?: string, header?: string, width?: any, format?: string
  }[];

  @ViewChild('grdPeriodicData') grdPeriodicData: wjcGrid.FlexGrid;
  @ViewChild('flexNotesGrid') flexNotesGrid: wjcGrid.FlexGrid;

  @ViewChild('flexliabilityFunding') flexliabilityFunding: wjcGrid.FlexGrid;
  public cvliabilityFundingList: wjcCore.CollectionView;
  lstliabilityFundingList: any;
  lstliabilityMasterFunding: any;
  public cvliabilityFundingAggregate: wjcCore.CollectionView;
  lstliabilityDetailFunding: wjOdata.ODataCollectionView;
  lstliabilityDetailFundingOrg: any;
  _liabilityFundingScheduleMap: Map<string, any> = new Map();

  @ViewChild('flexJournalLedger') flexJournalLedger: wjcGrid.FlexGrid;
  public cvJournalLedger: wjcCore.CollectionView;
  lstjournalLedger: any;

  @ViewChild('flexCashflowGrid') flexCashflowGrid: wjcGrid.FlexGrid;
  lstDebtTransaction: any;

  @ViewChildren('flexFacilityFeeSchedule') flexFacilityFeeSchedule: QueryList<wjcGrid.FlexGrid>;
  public cvFacilityFeeSchedule: wjcCore.CollectionView;
  deleteFacilityFeeSchedule: any = [];

  @ViewChildren('flexFacilityRSS') flexFacilityRSS: QueryList<wjcGrid.FlexGrid>;
  public cvFacilityRatespreadschedule: wjcCore.CollectionView;
  deleteFacilityRateSchedule: any = [];

  public _Debt: Debt;
  public _journal: JournalLedgerMaster;
  deleteRowIndex: number;
  public lstXIRRTags: any = [];
  public lstSelectedXIRRTags: any = [];
  lstTransactionType: any;
  lstStatusTextType: any;
  listliabilityMasterFunding: any;
  lstCashAccountCategory: any;
  _isNewCash: boolean = false;
  debtfundNorecord: boolean = false;
  public _searchObj: any;
  public selectedBankerID: string = '';
  public selectedBankerText: string = '';
  public _result: any;
  public _cachedeal = {};
  public isShowFundAssumptions: boolean = false;
  public isFundAssumptionsLoading: boolean = true;
  oldTransdate: any;
  NewTransdate: any;
  FundingAggregateEditedData: any[] = [];
  public cvliabilityFundingDealLevel: wjcCore.CollectionView;
  LFSDealLevelEditedRows: any[] = [];
  @ViewChild('debtfundsubgrid') debtfundsubgrid: wjcGrid.FlexGrid;
  public ListDealLevelLiabilityFundingSchedule: any;
  public listAssociatedDeals: any;
  listNewliabilityFundingList: any;
  deleteFundingAggregate: any = [];

  public ListPrepayAndAdditionalFeeScheduleLiabilityDetail: any;
  public lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail: any;
  public modelheaderFeeName: any;
  public modelheaderDate: any;

  constructor(
    public debtSrv: debtService,
    public liabilityNoteSrv: liabilityNoteService,
    public utils: UtilsFunctions,
    public utilityService: UtilityService,
    public membershipService: MembershipService,
    public noteSrv: NoteService,
    public eqSrv: equityService,
    public _location: Location,
    private _router: Router,
    private activatedRoute: ActivatedRoute) {
    super(50, 1, 0);
    this._Debt = new Debt('');
    this.listNewliabilityFundingList = [];
    this.CheckifUserIsLogedIN();
    this.GetAllLookups();
    this.activatedRoute.params.forEach((params: Params) => {
      if (params['id'] !== undefined) {
      }
      else if (params['nid'] !== undefined) {
        this.LiabilityTypeID = params['nid'];
        this.GetDebtDataByDebtGUID();
        this.actiontype = "update";
        this._isNewCash = false;
      } else {
        this.actiontype = "new";
        this.utilityService.setPageTitle("M61– Debt");
        this._isNewCash = true;
      }
    });
    this.GetAllTagNameXIRR();

    this.GetCashAccountsCategory();
  }
  GetAllTagNameXIRR() {
    this.noteSrv.GetAllTagsNameXIRR().subscribe(res => {
      if (res.Succeeded) {
        this.lstXIRRTags = res.dt;
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
  GetAllLookups(): void {
    this.debtSrv.getAllLookup().subscribe(res => {
      if (res.Succeeded) {
        var data = res.lstLookups;
        this.lststatus = data.filter(x => x.ParentID == "51");
        this.lstIndextype = data.filter(x => x.ParentID == "32");
        this.lstAccountCategory = res.dt.filter(x => x.LiabilitiesType == "Debt");
        this.lstApplyTrueUpFeature = data.filter(x => x.ParentID == "95");
        this.lstRateSpreadSch_ValueType = data.filter(x => x.ParentID == "19");
        this.lstIntCalcMethodID = data.filter(x => x.ParentID == "25");
        this.lstFeeType = res.lstFeeTypeLookUp;
        this.ListofFundName = res.ListofFundName;
        this.lstTransactionType = res.lstTransactionType;
        this.lstStatusTextType = data.filter(x => x.ParentID == "154");
        this.getHolidayMaster();

        this._bindGridDropdowsDebt();
      }
      else {
        if (res.Message == "Authentication failed") {
          this._router.navigate(['login']);
        }

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

  checkDroppedDownChangedBanker(sender: wjNg2Input.WjAutoComplete, args: any) {
    var ac = sender;
    if (ac.selectedIndex == -1) {
      if (ac.text != this.selectedBankerText) {
        //this.selectedTypeText = null;
        //this.selectedTypeID = null;
      }
    }
    else {
      this.selectedBankerID = ac.selectedValue;
      this.selectedBankerText = ac.selectedItem.Valuekey;
    }
  }

  getAutosuggestBanker = this.getAutosuggestBankerFunc.bind(this);
  getAutosuggestBankerFunc(query: any, max: any, callback: any) {
    this._result = null;
    if (query != null) {
      var self: any = this,
        result = self._cachedeal[query];
      if (result) {
        callback(result);
        return;
      }
      // not in cache, get from server
      var params = { query: query, max: max };
      this._searchObj = new Search(query);

      this.liabilityNoteSrv.GetAutosuggestBankerName(query).subscribe(res => {
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


  CheckDuplicateDebtAndSave() {
    if (!this.CustomValidator()) {
      return;
    }
    this._isListFetching = true;
    this._Debt.modulename = "Debt";
    this._Debt.DebtAccountID = this.DebtAccountID;

    this.debtSrv.CheckDuplicateforLiabilities(this._Debt).subscribe(res => {
      if (res.Succeeded) {
        if (res.Message === "Save") {
          this.SaveDebt();
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
      this.CustomAlert("Error Occurred While Saving Debt.");
      console.error(error);
    });
  }

  SaveDebt() {
    this._isListFetching = true;
    this._Debt.BankerID = parseInt(this.selectedBankerID);

    this._Debt.EarliestFinancingArrival = this.utils.convertDateToUTC(this._Debt.EarliestFinancingArrival);
    this._Debt.OriginationDate = this.utils.convertDateToUTC(this._Debt.OriginationDate);
    this._Debt.EffectiveDate = this.utils.convertDateToUTC(this._Debt.EffectiveDate);
    this._Debt.InitialMaturityDate = this.utils.convertDateToUTC(this._Debt.InitialMaturityDate);
    this._Debt.InitialInterestAccrualEnddate = this.utils.convertDateToUTC(this._Debt.InitialInterestAccrualEnddate);

    var allFacilityFeeSchedules = [];
    var allFacilityRateSpreadSchedules = [];
    var allFacilityIntExpSetup = [];
    var allFacilityInterestExpense = [];

    Object.keys(this.debtDataStore).forEach(CurrentEquityAccountID => {
      var debtData = this.debtDataStore[CurrentEquityAccountID];

      if (debtData.lstDebtExtIntExpData && debtData.lstDebtExtIntExpData.length > 0) {
        debtData.lstDebtExtIntExpData.forEach(item => {
          if (item.InitialInterestAccrualEnddate != null) {
            item.InitialInterestAccrualEnddate = this.utils.convertDateToUTC(item.InitialInterestAccrualEnddate);
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

    this._Debt.DebtExtDataList = allFacilityIntExpSetup;
    this._Debt.FeeScheduleList = allFacilityFeeSchedules;
    this._Debt.ListLiabilityRate = allFacilityRateSpreadSchedules;
    this._Debt.ListInterestExpense = allFacilityInterestExpense;
    this._Debt.ListPrepayAndAdditionalFeeScheduleLiabilityDetail = this.ListPrepayAndAdditionalFeeScheduleLiabilityDetail;

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

    if (this.listNewliabilityFundingList !== undefined && this.listNewliabilityFundingList !== null) {
      for (var i = 0; i < this.listNewliabilityFundingList.length; i++) {
        this.listNewliabilityFundingList[i].TransactionDate = this.utils.convertDateToUTC(this.listNewliabilityFundingList[i].TransactionDate);
        this.listNewliabilityFundingList[i].AssetTransactionDate = this.utils.convertDateToUTC(this.listNewliabilityFundingList[i].AssetTransactionDate);
      }
    }

    for (var i = 0; i < this.LFSDealLevelEditedRows.length; i++) {
      this.LFSDealLevelEditedRows[i].TransactionDate = this.utils.convertDateToUTC(this.LFSDealLevelEditedRows[i].TransactionDate);
    }

    this._Debt.liabilityMasterFunding = this.FundingAggregateEditedData;
    this._Debt.ListLiabilityFundingSchedule = this.listNewliabilityFundingList;
    this._Debt.ListDealLevelLiabilityFundingSchedule = this.LFSDealLevelEditedRows;

    this.debtSrv.InsertUpdatedebt(this._Debt).subscribe(res => {
      if (res.Succeeded) {
        this._Showmessagediv = true;
        this._ShowmessagedivMsg = "Debt Saved Successfully";

        setTimeout(function () {
          this._Showmessagediv = false;
          this._ShowmessagedivMsg = "";
          this._isListFetching = false;

          if (this.actiontype == "new") {
            this._router.navigate(["debt/n/", res.LiabilityTypeID]);
          } else {
            var returnUrl = this._router.url;
            if (window.location.href.indexOf("debt/n/") > -1) {
              returnUrl = returnUrl.toString().replace('debt/n/', 'debt/u/');

            }
            else if (returnUrl.indexOf("debt/u/") > -1) {
              returnUrl = returnUrl.toString().replace('debt/u/', 'debt/n/');
            }
            //this.flexFacilityFeeSchedule.invalidate();
            this._router.navigate([returnUrl]);
          }

        }.bind(this), 500);
      } else {
        this._ShowmessageWarning = false;
        this._messageFail = "Error Occurred While Saving Debt.";
        this._isListFetching = false;
      }
    });
  }

  CustomValidator(): boolean {
    var ms = "";
    let isValid = true;

    if (this._Debt.DebtName == "" || this._Debt.DebtName == null || this._Debt.DebtName === undefined) {
      ms = ms + "</p>" + "Debt Name can not be blank" + "</p>";
      isValid = false;
    }

    if (!this._Debt.EffectiveDate && (this._Debt.Commitment || this._Debt.InitialMaturityDate)) {
      ms = ms + "<p>" + "In Effective Date Based Setup, Effective Date can not be blank." + "</p>";
      isValid = false;
      this._isListFetching = false;
    }
    
    if (!isValid) {
      this.CustomAlert(ms);
    }

    return isValid;
  }

  Cancel(): void {
    try {
      this._location.back();
    } catch (error) {
      this._router.navigate(['dashboard']);
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
  
  GetDebtNoteByLiabilityTypeID(): void {
    this._isListFetching = true;
    this.debtSrv.GetDebtNoteByLiabilityTypeID(this.DebtAccountID).subscribe(res => {
      if (res.Succeeded) {
        this.lstDebtNote = res.lstNote;

        for (var i = 0; i < this.lstDebtNote.length; i++) {
          if (this.lstDebtNote[i].PledgeDate != null) {
            this.lstDebtNote[i].PledgeDate = new Date(this.utils.convertDateToBindable(this.lstDebtNote[i].PledgeDate));
          }

          if (this.lstDebtNote[i].MaturityDate != null) {
            this.lstDebtNote[i].MaturityDate = new Date(this.utils.convertDateToBindable(this.lstDebtNote[i].MaturityDate));
          }

        }
        this.cvDebtNote = new wjcCore.CollectionView(this.lstDebtNote);
        this.cvDebtNote.trackChanges = true;
        this.flexNotesGrid.invalidate();
        setTimeout(function () {
          this._isListFetching = false;
        }.bind(this), 500);
      }
    });
  }

  GetDebtJournalLedgerbyJournalEntryMasterID(): void {
    this._isListFetching = true;
    this.debtSrv.GetDebtJournalLedgerbyJournalEntryMasterID(this.DebtAccountID).subscribe(res => {
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
        this.cvJournalLedger = new wjcCore.CollectionView(this.lstjournalLedger);
        this.cvJournalLedger.trackChanges = true;
        this.flexJournalLedger.invalidate();
        setTimeout(function () {
          this._isListFetching = false;
        }.bind(this), 500);
      }
    });
  }

  GetDebtDataByDebtGUID(): void {
    this._isListFetching = true;
    this.debtSrv.GetDebtDataByDebtGUID(this.LiabilityTypeID).subscribe(res => {
      if (res.Succeeded) {
        this._Debt = res.Debtdc;
        this.selectedBankerText = this._Debt.BankerText;
        this.lstAssociatedEquity = res.dtAssociatedDebt;
        
        this.isFundAssumptionsLoading = false;

        if (this.lstAssociatedEquity.length > 0) {
          this.isShowFundAssumptions = true;
        }

        this.FacilityFeeSchedule = res.FacilityFeeSchedule;
        this.FacilityRateSpreadSchedule = res.FacilityRateSpreadSchedule;
        this.ListDebtExtInterest = res.ListDebtExtInterest;
        this.ListInterestExpense = res.lstInterestExpenseSchedule;
        this.ListFacilityEffectiveDateCounts = res.ListFacilityEffectiveDateCounts;
        this.ListPrepayAndAdditionalFeeScheduleLiabilityDetail = res.ListPrepayAndAdditionalFeeScheduleLiabilityDetail;
        this.DebtAccountID = this._Debt.DebtAccountID;
        this.txtCurrentBalanceValue = this.utils.formatNumberforTwoDecimalplaces(this._Debt.CurrentBalance, this._Debt.CurrencyText);
        this.txtCommitmentValue = this.utils.formatNumberforTwoDecimalplaces(this._Debt.Commitment, this._Debt.CurrencyText);
        this.txtMaxAdvanceRate = this.utils.formatNumberTopercent(this._Debt.MaxAdvanceRate);
        this.txtTargetAdvanceRate = this.utils.formatNumberTopercent(this._Debt.TargetAdvanceRate);
        this.utilityService.setPageTitle("M61–" + this._Debt.DebtName);
        setTimeout(function () {
          this._isListFetching = false;
          if (this.lstAssociatedEquity) {
            this.GetSchedulesforFacility(this.lstAssociatedEquity[0].EquityAccountID, this.lstAssociatedEquity[0].EquityName, this.lstAssociatedEquity[0].EquityGUID, "aEqDebt0");
          }
        }.bind(this), 500);
      }
    }, error => {
      this._isListFetching = false;
      this._ShowmessageWarning = true;
      this._messageFail = "Error occurred while loading Debt. Please refresh and try again or contact M61 support.";

    });
  }
  invalidateNotesTab() {
    if (!this._isNotesTabClicked) {
      this._isNotesTabClicked = true;
      this.GetDebtNoteByLiabilityTypeID();
    }
  }

  invalidateJournalsTab() {
    if (!this._isJournalLedgerTabClicked) {
      this._isJournalLedgerTabClicked = true;
      this.GetDebtJournalLedgerbyJournalEntryMasterID();
    }
  }

  GetSchedulesforFacility(EquityAccountID, EquityName, EquityGUID, e) {
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

    this.CurrentEquityName = EquityName;
    this.CurrentEquityAccountID = EquityAccountID;
    this.CurrentEquityGUID = EquityGUID;
    if (!this.debtDataStore[this.CurrentEquityAccountID]) {
      this.debtDataStore[this.CurrentEquityAccountID] = {
        lstFacilityFeeSchedule: [],
        lstfacilityRateSpreadSchedule: [],
        lstDebtExtIntExpData: [],
        lstInterestExpense: []
      };
    }

    this.GetFacilityDebtExtData(this.CurrentEquityAccountID);
    this.GetFacilityFeeScheduleByAccountID(this.CurrentEquityAccountID);
    this.GetFacilityRateScheduleByAccountID(this.CurrentEquityAccountID);
    this.GetFacilityInterestExpenseData(this.CurrentEquityAccountID);
  }

  showDialogFacility(modulename, CurrentEquityAccountID) {
    this._Debt.modulename = modulename;
    this._Debt.AdditionalAccountID = CurrentEquityAccountID;
    this.getPeriodicDataByNoteId(this._Debt);
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

  GetFacilityDebtExtData(CurrentEquityAccountID) {
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

    var lst = this.ListDebtExtInterest.filter(item => item.DebtAccountID === this.DebtAccountID && item.AdditionalAccountID === CurrentEquityAccountID);

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

  GetFacilityInterestExpenseData(CurrentEquityAccountID) {
    this._isListFetching = true;
    this.selectedPayFrequency = null;
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

    var lstInterestExpense = this.ListInterestExpense.filter(item => item.DebtAccountID === this.DebtAccountID && item.AdditionalAccountID === CurrentEquityAccountID);

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
    this.ShowCountOnViewHistoryFacility(this.DebtAccountID);
    setTimeout(function () {
      this._isListFetching = false;
    }.bind(this), 500);
  }

  GetFacilityFeeScheduleByAccountID(CurrentEquityAccountID): void {
    this._isListFetching = true;
    this.selectedFacilityFeeEffectiveDate = null;

    if (this.FacilityFeeSchedule != null) {
      this.debtDataStore[CurrentEquityAccountID].lstFacilityFeeSchedule = this.FacilityFeeSchedule.filter(item => item.AccountID === this.DebtAccountID && item.AdditionalAccountID === CurrentEquityAccountID);

      if (this.debtDataStore[CurrentEquityAccountID].lstFacilityFeeSchedule.length > 0) {
        var lstfee = this.debtDataStore[CurrentEquityAccountID].lstFacilityFeeSchedule[0];
        this.selectedFacilityFeeEffectiveDate = lstfee.EffectiveDate;
      }
    }
    for (let i = 0; i < this.debtDataStore[CurrentEquityAccountID].lstFacilityFeeSchedule.length; i++) {
      if (this.debtDataStore[CurrentEquityAccountID].lstFacilityFeeSchedule[i].StartDate != null) {
        this.debtDataStore[CurrentEquityAccountID].lstFacilityFeeSchedule[i].StartDate = new Date(this.utils.convertDateToBindable(this.debtDataStore[CurrentEquityAccountID].lstFacilityFeeSchedule[i].StartDate));
      }
      if (this.debtDataStore[CurrentEquityAccountID].lstFacilityFeeSchedule[i].EndDate != null) {
        this.debtDataStore[CurrentEquityAccountID].lstFacilityFeeSchedule[i].EndDate = new Date(this.utils.convertDateToBindable(this.debtDataStore[CurrentEquityAccountID].lstFacilityFeeSchedule[i].EndDate));
      }
    }
    this.cvFacilityFeeSchedule = new wjcCore.CollectionView(this.debtDataStore[CurrentEquityAccountID].lstFacilityFeeSchedule);
    this.cvFacilityFeeSchedule.trackChanges = true;
    setTimeout(function () {
      this._isListFetching = false;
    }.bind(this), 500);
    this.ShowCountOnViewHistoryFacility(this.DebtAccountID);
    this._bindGridDropdowsDebt();
  }


  GetFacilityRateScheduleByAccountID(CurrentEquityAccountID): void {
    this._isListFetching = true;
    this.selectedFacilityRSSEffectiveDate = null;
    if (this.FacilityRateSpreadSchedule != null) {
      this.debtDataStore[CurrentEquityAccountID].lstfacilityRateSpreadSchedule = this.FacilityRateSpreadSchedule.filter(item => item.LiabilityNoteAccountID === this.DebtAccountID && item.AdditionalAccountID === CurrentEquityAccountID);

      if (this.debtDataStore[CurrentEquityAccountID].lstfacilityRateSpreadSchedule.length > 0) {
        var lstrss = this.debtDataStore[CurrentEquityAccountID].lstfacilityRateSpreadSchedule[0];
        this.selectedFacilityRSSEffectiveDate = lstrss.EffectiveDate;
      }
    }
    for (var i = 0; i < this.debtDataStore[CurrentEquityAccountID].lstfacilityRateSpreadSchedule.length; i++) {
      if (this.debtDataStore[CurrentEquityAccountID].lstfacilityRateSpreadSchedule[i].Date != null) {
        this.debtDataStore[CurrentEquityAccountID].lstfacilityRateSpreadSchedule[i].Date = new Date(this.utils.convertDateToBindable(this.debtDataStore[CurrentEquityAccountID].lstfacilityRateSpreadSchedule[i].Date));
      }

    }
    this.cvFacilityRatespreadschedule = new wjcCore.CollectionView(this.debtDataStore[CurrentEquityAccountID].lstfacilityRateSpreadSchedule);
    this.cvFacilityRatespreadschedule.trackChanges = true;
    setTimeout(function () {
      this._isListFetching = false;
    }.bind(this), 500);
    this.ShowCountOnViewHistoryFacility(this.DebtAccountID);
    this._bindGridDropdowsDebt();
  }


  onGridUpdateFEE(CurrentEquityAccountID)
  {
    var debtData = this.debtDataStore[CurrentEquityAccountID];
    debtData.lstFacilityFeeSchedule.forEach(item => {
      item.AccountID = this.DebtAccountID;
      item.AdditionalAccountID = CurrentEquityAccountID;
      item.EffectiveDate = this.selectedFacilityFeeEffectiveDate;
    });
    this.FacilityFeeSchedule = this.FacilityFeeSchedule.filter(item => item.AdditionalAccountID !== CurrentEquityAccountID);
    this.FacilityFeeSchedule = this.FacilityFeeSchedule.concat(debtData.lstFacilityFeeSchedule);

    for (var df = 0; df < this.FacilityFeeSchedule.length; df++)
    {
      if (!(Number(this.FacilityFeeSchedule[df].FeeTypeText).toString() == "NaN" || Number(this.FacilityFeeSchedule[df].FeeTypeText) == 0))
      {
        this.FacilityFeeSchedule[df].ValueTypeID = Number(this.FacilityFeeSchedule[df].FeeTypeText);
        this.FacilityFeeSchedule[df].FeeTypeText = this.lstFeeType.find(x => x.LookupID == Number(this.FacilityFeeSchedule[df].FeeTypeText)).Name
      }
    }

  }

  onGridUpdateRSS(CurrentEquityAccountID) {
    var debtData = this.debtDataStore[CurrentEquityAccountID];
    debtData.lstfacilityRateSpreadSchedule.forEach(item => {
      item.AccountID = this.DebtAccountID;
      item.AdditionalAccountID = CurrentEquityAccountID;
      item.EffectiveDate = this.selectedFacilityRSSEffectiveDate;
    });
    this.FacilityRateSpreadSchedule = this.FacilityRateSpreadSchedule.filter(item => item.AdditionalAccountID !== CurrentEquityAccountID);
    this.FacilityRateSpreadSchedule = this.FacilityRateSpreadSchedule.concat(this.debtDataStore[CurrentEquityAccountID].lstfacilityRateSpreadSchedule);
  }

  OnChangeDebtExtIntExp() {
    var newInterestExpenseData = {
      DebtExtID: this.DebtExtID,
      DebtAccountID: this.DebtAccountID,
      AdditionalAccountID: this.CurrentEquityAccountID,
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

    var existingDataIndex = this.debtDataStore[this.CurrentEquityAccountID].lstDebtExtIntExpData.findIndex(
      item => item.DebtAccountID === this.DebtAccountID && item.AdditionalAccountID === this.CurrentEquityAccountID
    );

    if (existingDataIndex === -1) {
      this.debtDataStore[this.CurrentEquityAccountID].lstDebtExtIntExpData.push(newInterestExpenseData);
    } else {
      this.debtDataStore[this.CurrentEquityAccountID].lstDebtExtIntExpData[existingDataIndex] = newInterestExpenseData;
    }

    if (this.ListDebtExtInterest != null && this.ListDebtExtInterest.length > 0)
      this.ListDebtExtInterest = this.ListDebtExtInterest.filter(item => item.AdditionalAccountID !== this.CurrentEquityAccountID);
    this.ListDebtExtInterest = this.ListDebtExtInterest.concat(this.debtDataStore[this.CurrentEquityAccountID].lstDebtExtIntExpData);
  }

  OnChangeInterestExpense() {
    var newInterestExpenseData = {
      InterestExpenseScheduleID: this.selectedInterestExpenseScheduleID,
      DebtAccountID: this.DebtAccountID,
      AdditionalAccountID: this.CurrentEquityAccountID,
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

    var existingDataIndex = this.debtDataStore[this.CurrentEquityAccountID].lstInterestExpense.findIndex(
      item => item.DebtAccountID === this.DebtAccountID && item.AdditionalAccountID === this.CurrentEquityAccountID
    );

    if (existingDataIndex === -1) {
      this.debtDataStore[this.CurrentEquityAccountID].lstInterestExpense.push(newInterestExpenseData);
    } else {
      this.debtDataStore[this.CurrentEquityAccountID].lstInterestExpense[existingDataIndex] = newInterestExpenseData;
    }

    if (this.ListInterestExpense != null && this.ListInterestExpense.length > 0)
      this.ListInterestExpense = this.ListInterestExpense.filter(item => item.AdditionalAccountID !== this.CurrentEquityAccountID);
    this.ListInterestExpense = this.ListInterestExpense.concat(this.debtDataStore[this.CurrentEquityAccountID].lstInterestExpense);
  }

  ShowCountOnViewHistoryFacility(DebtAccountID) {
    if (this.ListFacilityEffectiveDateCounts && this.ListFacilityEffectiveDateCounts.length > 0) {
      for (var i = 0; i < this.ListFacilityEffectiveDateCounts.length; i++) {
        if (this.ListFacilityEffectiveDateCounts[i].NoteAccountId == DebtAccountID && this.ListFacilityEffectiveDateCounts[i].AdditionalAccountId === this.CurrentEquityAccountID) {
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
            case "GeneralSetupDetailsDebt":
              scheduleName = "GeneralSetupDetailsDebt";
              this.EffectiveDateCountGeneralSetupDetailsDebt = ' (' + this.ListFacilityEffectiveDateCounts[i].EffectiveDateCount + ')';
              this._isSetHeaderEmpty = true;
              break;
            default:
              break;
          }
        }
      }
    }
  }

  StatusChange(newvalue): void {
    this._Debt.Applied = newvalue;
  }
  DebtTypeChange(newvalue): void {
    this._Debt.DebtType = newvalue;
  }
  CurrencyChange(newvalue): void {
    this._Debt.Currency = newvalue;
  }
  MatchTermsChange(newvalue): void {
    this._Debt.MatchTerms = newvalue;
  }
  IsRevolvingChange(newvalue): void {
    this._Debt.IsRevolving = newvalue;
  }
  ExpenseRateTypeChange(newvalue): void {
    this._Debt.ExpenseRateType = newvalue;
  }
  Commitmentchange(newvalue): void {

    this.txtCommitmentValue = this.utils.formatNumberforTwoDecimalplaces(this._Debt.Commitment, this._Debt.CurrencyText);
  }
  TargetAdvanceRatechange(newvalue): void {

    this.txtTargetAdvanceRate = this.utils.formatNumberTopercent(this._Debt.TargetAdvanceRate);
  } MaxAdvanceRatechange(newvalue): void {

    this.txtMaxAdvanceRate = this.utils.formatNumberTopercent(this._Debt.MaxAdvanceRate);
  }
  LinkedFundIDChange(newvalue): void {
    this._Debt.LinkedFundID = newvalue;
  }

  invalidateDrawsPaydowns(showloader) {

    if (!this._isDebtDrawsPaydownsClicked) {
      this._isDebtDrawsPaydownsClicked = true;
      this.GetDebtFundingScheduleByLiabilityTypeID();
      this.GetLiabilityFundingScheduleAggregate();
      this.GetLiabilityFundingScheduleDetail();
      this.GetDealLevelLiabilityFundingScheduleTypeID();
    }
    if (showloader == true) {
      this.CalculateUnallocatedBalance();
    }
  }

  addFooterRownotes(flexNotesGrid: wjcGrid.FlexGrid) {
    var row = new wjcGrid.GroupRow();
    flexNotesGrid.columnFooters.rows.push(row);
    flexNotesGrid.bottomLeftCells.setCellData(0, 0, '\u03A3');

  }
  addFooterRowFundingGrid(flexliabilityFunding: wjcGrid.FlexGrid) {
    var row = new wjcGrid.GroupRow();
    flexliabilityFunding.columnFooters.rows.push(row);
    flexliabilityFunding.bottomLeftCells.setCellData(0, 0, '\u03A3');
  }  

  GetDealLevelLiabilityFundingScheduleTypeID(): void {
    this.debtSrv.GetDealLevelLiabilityFundingScheduleTypeID(this.DebtAccountID).subscribe(res => {
      if (res.Succeeded) {

        this._Debt.ListDealLevelLiabilityFundingSchedule = res.EquityData.ListDealLevelLiabilityFundingSchedule;

        this.ListDealLevelLiabilityFundingSchedule = this._Debt.ListDealLevelLiabilityFundingSchedule;
        this.listAssociatedDeals = res.listAssociatedDeals;
        for (var i = 0; i < this.ListDealLevelLiabilityFundingSchedule.length; i++) {
          if (this.ListDealLevelLiabilityFundingSchedule[i].TransactionDate != null) {
            this.ListDealLevelLiabilityFundingSchedule[i].TransactionDate = this.utils.convertDateToBindable(this.ListDealLevelLiabilityFundingSchedule[i].TransactionDate);
          }
        }
      }
    });
  }

  GetLiabilityFundingScheduleAggregate(): void {
    this._isListFetching = true;
    this.debtSrv.GetLiabilityFundingScheduleAggregateByLiabilityTypeID(this.DebtAccountID).subscribe(res => {
      if (res.Succeeded) {
        this.lstliabilityMasterFunding = res.dt;

        for (var i = 0; i < this.lstliabilityMasterFunding.length; i++) {
          if (this.lstliabilityMasterFunding[i].TransactionDate != null) {
            var cdate = this.lstliabilityMasterFunding[i].TransactionDate;
            this.lstliabilityMasterFunding[i].TransactionDateUsedInSort = new Date(cdate);
            this.lstliabilityMasterFunding[i].TransactionDate = this.utils.convertDateToBindable(this.lstliabilityMasterFunding[i].TransactionDate);
          }
        }

        this.cvliabilityFundingAggregate = new wjcCore.CollectionView(this.lstliabilityMasterFunding);
        this.cvliabilityFundingAggregate.trackChanges = true;
      }

    })
  }

  GetLiabilityFundingScheduleDetail(): void {
    this._isListFetching = true;
    this.debtSrv.getLiabilityFundingScheduleDetailByLiabilityID(this.DebtAccountID).subscribe(res => {
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

      }
    })
  }


  GetLiabFundingScheduleDetails(Transdate: any, TransactionTypes: any) {
    Transdate = this.utils.convertDateToBindable(Transdate);
    this.lstliabilityDetailFunding = this.lstliabilityDetailFundingOrg.filter(x => x.TransactionDate === Transdate && x.TransactionTypes == TransactionTypes);

    let liabilityFundingSchedule = this._liabilityFundingScheduleMap.get(Transdate);

    liabilityFundingSchedule = this.lstliabilityDetailFundingOrg.filter(
      x => x.TransactionDate === Transdate && x.TransactionTypes == TransactionTypes);
    this._liabilityFundingScheduleMap.set(Transdate, liabilityFundingSchedule);

    return liabilityFundingSchedule;

  }

  GetDebtFundingScheduleByLiabilityTypeID(): void {
    this._isListFetching = true;
    this.debtSrv.GetDebtFundingScheduleByLiabilityTypeID(this.DebtAccountID).subscribe(res => {
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
        this.AppliedReadOnlyForDebtliabilityFunding();
        setTimeout(function () {
          this._isListFetching = false;
        }.bind(this), 500);
      }
    });
  }

  AppliedReadOnlyForDebtliabilityFunding() {
    setTimeout(() => {
      if (this.lstliabilityFundingList) {
        for (var i = 0; i <= (this.lstliabilityFundingList.length - 1); i++) {
          if (this.flexliabilityFunding.rows[i]) {
            if (this.flexliabilityFunding.rows[i].dataItem.Status == true) {
              if (this.flexliabilityFunding.rows[i]) {
                this.flexliabilityFunding.rows[i].isReadOnly = true;
                this.flexliabilityFunding.rows[i].cssClass = "customgridrowcolor";
              }
            }
          }
        }
      }
    }, 1000);
  }

  private _bindGridDropdowsDebt() {

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
  
  addFooterRowCashFlow(flexCashflowGrid: wjcGrid.FlexGrid) {
    var row = new wjcGrid.GroupRow();
    flexCashflowGrid.columnFooters.rows.push(row);
    flexCashflowGrid.bottomLeftCells.setCellData(0, 0, '\u03A3');

  }
  showCashflow() {
    if (!this._isCashflowTabClicked) {
      this._isCashflowTabClicked = true;
      this.GetDebtTransactionByDebtAccountID();
    }
  }
  GetDebtTransactionByDebtAccountID(): void {
    this._isListFetching = true;
    if (this.actiontype == "new") {
      this.DebtAccountID = "00000000-0000-0000-0000-000000000000";
    }
    this.debtSrv.GetDebtTransactionByDebtAccountID(this.DebtAccountID).subscribe(res => {
      if (res.Succeeded) {
        this.lstDebtTransaction = res.LiabilityCashFlow;
        if (this.lstDebtTransaction && this.lstDebtTransaction.length > 0) {
          for (var i = 0; i < this.lstDebtTransaction.length; i++) {
            if (this.lstDebtTransaction[i].Date != null) {
              this.lstDebtTransaction[i].Date = new Date(this.utils.convertDateToBindable(this.lstDebtTransaction[i].Date));
            }
          }
        }
        setTimeout(function () {
          this._isListFetching = false;
        }.bind(this), 500);

      }
    });
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
  private _buildDataMapWithoutLookupNew(items): wjcGrid.DataMap {
    var map = [];

    for (var i = 0; i < items.length; i++) {
      var obj = items[i];
      map.push({ key: obj['FeeTypeNameID'], value: obj['FeeTypeNameText'] });
    }
    return new wjcGrid.DataMap(map, 'key', 'value');
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
  showDialog(modulename) {
    this._Debt.modulename = modulename;
    this.getPeriodicDataByNoteId(this._Debt);
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

  public getPeriodicDataByNoteId(_Debt) {
    this._Debt = _Debt;
    this.modulename = _Debt.modulename;
    this.lstPeriodicDataList = null;
    this._isPeriodicDataFetched = false;
    this._isPeriodicDataFetching = true;
    this._dvEmptyPeriodicDataMsg = false;

    var modal = document.getElementById('myModal');
    modal.style.display = "block";
    $.getScript("/js/jsDrag.js");
    this.debtSrv.GetHistoricalDataOfLiabilityModuleByAccountIdAPI(_Debt, this._pageIndex, this._pageSize).subscribe(res => {
      if (res.Succeeded) {
        if (res.StatusCode != 404) {
          this._isPeriodicDataFetched = true;
          this._isPeriodicDataFetching = false;
          this._isSetHeaderEmpty = false;

          switch (_Debt.modulename) {
            case "PrepayAndAdditionalFeeScheduleLiability":
              this.modulename = "Fee Schedule";
              this.lstPeriodicDataList = res.lstPrepayAndAdditionalFeeScheduleDataContract;
              this._isSetHeaderEmpty = true;
              break;
            case "RateSpreadScheduleLiability":
              this.modulename = "Rate Spread Schedule";
              this.lstPeriodicDataList = res.lstRateSpreadSchedule;
              this._isSetHeaderEmpty = true;
              break;
            case "GeneralSetupDetailsDebt":
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
          switch (_Debt.modulename) {
            case "PrepayAndAdditionalFeeSchedule":
              this.modulename = "Fee Schedule";
              break;
            case "GeneralSetupDetailsDebt":
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
  
  showDeleteDialogFunding(deleteRowIndex: number, moduleName: string) {
    this.deleteRowIndex = deleteRowIndex;
    this.modulename = moduleName;
    var modalDelete = document.getElementById('myModalDelete');
    modalDelete.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }

  showDeleteDialog(deleteRowIndex: number, moduleName: string) {
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

  deleteRow() {
    if (this.modulename == "Facility Fee Schedule") {
      this.debtDataStore[this.CurrentEquityAccountID].lstFacilityFeeSchedule[this.deleteRowIndex].IsDeleted = true;
      var gridFacilityFEE = this.flexFacilityFeeSchedule.toArray()[0];
      if (gridFacilityFEE.rows[this.deleteRowIndex]) {
        this.deleteFacilityFeeSchedule.push(this.debtDataStore[this.CurrentEquityAccountID].lstFacilityFeeSchedule[this.deleteRowIndex]);
      }
      this.cvFacilityFeeSchedule.removeAt(this.deleteRowIndex);
    }

    if (this.modulename == "Facility Rate Spread Schedule") {
      this.debtDataStore[this.CurrentEquityAccountID].lstfacilityRateSpreadSchedule[this.deleteRowIndex].IsDeleted = true;
      var gridFacilityRSS = this.flexFacilityRSS.toArray()[0];
      if (gridFacilityRSS.rows[this.deleteRowIndex]) {
        this.deleteFacilityRateSchedule.push(this.debtDataStore[this.CurrentEquityAccountID].lstfacilityRateSpreadSchedule[this.deleteRowIndex]);
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

  downloadCashflowsExportData(): void {
    this._isListFetching = true;
    var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '-');
    var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '-');
    var fileName = this._Debt.DebtName + "_" + "_Cashflow_" + displayDate + "_" + displayTime + ".xlsx";
    var debtstring = this.DebtAccountID + "||" + "Debt";
    this.eqSrv.GetEquityCashflowsExportData(debtstring).subscribe(res => {
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

  downloadDebtDrawPaydownExportData(): void {
    this._isListFetching = true;
    var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '-');
    var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '-');
    var fileName = this._Debt.DebtName + "_" + "_Draws&Paydown_" + displayDate + "_" + displayTime + ".xlsx";

    this.eqSrv.GetEquityCapitalContributionExportExcel(this.DebtAccountID).subscribe(res => {
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

  ChangeLiabilityAppied(_value: boolean, flexGridrw: wjcGrid.Row, e): void {

    if (_value == true) {
      if (this.lstliabilityFundingList.length > 1) {
        var lstDates = this.lstliabilityFundingList.filter(x => x.Status == false).map(x => x.TransactionDate);
        if (lstDates.length >= 1) {
          var minDate: any;
          minDate = null;
          for (var val = 0; val < this.lstliabilityFundingList.length; val++) {
            if (this.lstliabilityFundingList[val].TransactionDate != null && this.lstliabilityFundingList[val].Status == false) {
              if (minDate === null || this.lstliabilityFundingList[val].TransactionDate < minDate) {
                minDate = this.lstliabilityFundingList[val].TransactionDate;
              }
            }

          }
          if (minDate != null) {
            minDate = new Date(minDate);
          }

          var wcDate = new Date(flexGridrw.dataItem.TransactionDate);
          if (wcDate.toString() != minDate.toString()) {
            this.CustomAlert("You can't confirm on a later date without confirming all in between.")
            flexGridrw.cssClass = "customgridrowcolornotapplied";
            this.flexliabilityFunding.rows[flexGridrw.index].dataItem.Status = false;
            e.target.checked = false;
            return;
          }
        }
      }

    }
    else {
      var maxDate = new Date(Math.max.apply(null, this.lstliabilityFundingList.filter(x => x.Status == true).map(x => x.TransactionDate)));
      if (maxDate.toJSON()) {
        if (flexGridrw.dataItem.TransactionDate) {
          e.target.checked = true;
          var wcDate = new Date(flexGridrw.dataItem.TransactionDate);
          if (wcDate.toString() != maxDate.toString()) {
            this.flexliabilityFunding.invalidate();
            this.CustomAlert("You can't remove a confirmation on an earlier date without removing the confirmation on later dates.")
            flexGridrw.cssClass = "customgridrowcolor"
            this.flexliabilityFunding.rows[flexGridrw.index].dataItem.Status = true;
            return;
          }
        }
      }
    }

    if (_value == true) {
      flexGridrw.isReadOnly = true;
      flexGridrw.dataItem.Status = true;
      e.target.checked = true;
      flexGridrw.cssClass = "customgridrowcolor"
      this.flexliabilityFunding.rows[flexGridrw.index].dataItem.Status = true;
    }
    else {
      flexGridrw.isReadOnly = false;
      flexGridrw.dataItem.Status = false;
      e.target.checked = false;
      flexGridrw.cssClass = "customgridrowcolornotapplied";
      this.flexliabilityFunding.rows[flexGridrw.index].dataItem.Status = false;
    }
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
    item.AccountID = this.DebtAccountID;

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

  sortGrid() {
    this.cvliabilityFundingAggregate.sortDescriptions.clear();
    let sd = new wjcCore.SortDescription("TransactionDateUsedInSort", true);
    /* let sd1 = new wjcCore.SortDescription("Applied", true);*/
    this.cvliabilityFundingAggregate.sortDescriptions.push(sd);
    /*   this.cvliabilityFundingAggregate.sortDescriptions.push(sd1);*/
    //this.cvliabilityFundingAggregate.trackChanges = true;
    this.flexliabilityFunding.invalidate(true);
  }

  CopiedliabilityFunding(liabilitymastergrid: wjcGrid.FlexGrid, e: wjcGrid.CellEditEndingEventArgs) {
    for (var i = 0; i < this.lstliabilityMasterFunding.length; i++) {
      if (this.lstliabilityMasterFunding[i].LiabilityFundingScheduleAggregateID == undefined) {
        this.lstliabilityMasterFunding[i].AccountID = this.DebtAccountID;
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

  initDebtDetailGrid(detailGrid: any, row: any, item: any) {
    this.debtfundNorecord = false;
    var Transdate = this.utils.convertDateToBindable(item.TransactionDate);

    if (this.ListDealLevelLiabilityFundingSchedule !== undefined && this.ListDealLevelLiabilityFundingSchedule !== null) {

      let liabilityFundingSchedule = this.ListDealLevelLiabilityFundingSchedule.filter(
        x => x.TransactionDate === Transdate && x.TransactionTypes == item.TransactionTypes);
      this._liabilityFundingScheduleMap.set(Transdate, liabilityFundingSchedule);

      this.cvliabilityFundingDealLevel = new wjcCore.CollectionView(liabilityFundingSchedule);
      this.cvliabilityFundingDealLevel.trackChanges = true;

      if (liabilityFundingSchedule.length == 0 && item.Applied == true) {
        this.debtfundNorecord = true;
        var debtfundsubgrid = document.getElementById('debtfundsubgrid');
        debtfundsubgrid.style.display = "none";
      }
      else {
        this.debtfundNorecord = false;
      }
    }

    detailGrid.itemsSource = this.cvliabilityFundingDealLevel;

    var coldeal = this.debtfundsubgrid.getColumn('DealAccountID');
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
  updateDebtName() {
    var selectedFund = this.ListofFundName.find(fund => fund.LookupIDGuID == this._Debt.LinkedFundID);
    var selectedDebtType = this.lstAccountCategory.find(cat => cat.LookupID == this._Debt.DebtType);

    var fundName = selectedFund ? selectedFund.Name : '';
    var debtTypeName = selectedDebtType ? selectedDebtType.Name : '';

    this._Debt.DebtName = fundName + "-" + this._Debt.AbbreviationName + "-" + debtTypeName;
  }

  GetCashAccountsCategory(): void {
    this.eqSrv.getCashAccountList().subscribe(res => {
      this.lstCashAccountCategory = res._lstCashAccount;
    });
  }

  downloadCashflowExportExcelEquityonly(): void {
    this._isListFetching = true;
    var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '-');
    var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '-');
    var fileName = this._Debt.DebtName + "_" + "_ExportExcelCashflow_" + displayDate + "_" + displayTime + ".xlsx";

    this.eqSrv.GetCashflowTabUIDataforonlyEquityExportExcel(this.DebtAccountID).subscribe(res => {
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

}

const routes: Routes = [

  { path: '', component: DebtComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, WjGridModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjGridDetailModule, WjInputModule, WjGridFilterModule],
  declarations: [DebtComponent]
})

export class debtModule { }
