import { Component, ViewChild, ElementRef } from "@angular/core";
import { Router, ActivatedRoute, Params } from '@angular/router';
import * as wjcGrid from '@grapecity/wijmo.grid';
import { NgModule } from '@angular/core';
import * as wjcCore from '@grapecity/wijmo';
import { Paginated } from '../core/common/paginated.service';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { CommonModule, Location } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { LoggingService } from './../core/services/logging.service';
import { WjInputModule } from '@grapecity/wijmo.angular2.input';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import { liabilityNoteService } from '../core/services/liabilityNote.service';
import { liabilityNote } from "../core/domain/liabilityNote.model";
import { Search } from "../core/domain/search.model";
import * as wjNg2Input from '@grapecity/wijmo.angular2.input';
import { UtilsFunctions } from './../core/common/utilsfunctions';
import { UtilityService } from '../core/services/utility.service';
import { NoteService } from '../core/services/note.service';
import { MembershipService } from '../core/services/membership.service';

@Component({
  selector: "liabilityNote",
  templateUrl: "./liabilityNote.html",
  providers: [liabilityNoteService, NoteService, UtilsFunctions]
})

export class LiabilityNoteComponent extends Paginated {
  public _note: liabilityNote;
  /* public _isShowCalcNotes: boolean = true;*/
  public _isShowSave: boolean = true;
  public _isShowCancel: boolean = true;
  public ShowHideFlagRateSpreadSchedule: boolean = false;
  public ShowHideFlagGeneralSetupDetails: boolean = false;
  public ShowHideFlagFeeSchedule: boolean = false;
  public EffectiveDateCountRateSpreadSchedule: any;
  public EffectiveDateCountFeeSchedule: any;
  public EffectiveDateCountGeneralSetupDetailsLiabilityNote: any;
  public ListEffectiveDateCount: any;
  public DealAccountID: any;
  public LiabilityNoteAccountID: any;
  public _isSetHeaderEmpty: boolean = false;
  public LiabilityNote: any;
  public actiontype: any;
  public LiabilityNoteGUID: any;
  public modulename: string;
  public lstPeriodicDataList: any;
  public _isPeriodicDataFetching: boolean;
  public _isPeriodicDataFetched: boolean = true;
  public _dvEmptyPeriodicDataMsg: boolean = false;
  public _isListFetching: boolean;
  public _ShowmessagedivMsg: string = '';
  public _Showmessagediv: boolean = false;

  public selectedTypeID: string = '';
  public selectedTypeText: string = '';
  public Notetype: string = '';
  public LiabilityTypeID = "";
  public DealName = "";
  public DealID = "";
  public DealInfo: any;
  public _result: any;
  public txtCurrentBalanceValue: any;
  public txtUndrawnCapacity: any;
  public txtCurrentAdvanceRate: any;
  public lbladvnacerate = "";

  public lblUndrawn = "";
  public lblPaydown = "";
  public lblFunding = "";
  public lblTarget = "";

  public _cachedeal = {};
  columns: {
    binding?: string, header?: string, width?: any, format?: string
  }[];

  public _searchObj: any;
  lststatus: any;
  lAssetList: any;

  lstStatus: any;
  lstRateSpreadSch_ValueType: any;
  lstIntCalcMethodID: any;
  lstIndextype: any;
  public holidayCalendarNamelist: any = [];
  dataMapValueType: any;

  @ViewChild('grdPeriodicData') grdPeriodicData: wjcGrid.FlexGrid;
  @ViewChild('flexrss') flexrss: wjcGrid.FlexGrid;
  public cvRatespreadschedule: wjcCore.CollectionView;
  lstRatespreadschedule: any;

  @ViewChild('flexFeeSchedule') flexFeeSchedule: wjcGrid.FlexGrid;
  public cvFeeSchedule: wjcCore.CollectionView;
  deleteFeeSchedule: any = [];
  lstFeeSchedule: any;
  lstApplyTrueUpFeature: any;
  lstLiabilitySource: any;

  calcExceptionMsg: string;
  deleteRowIndex: number;
  deleteRateSpread: any = [];
  lstNoteAssetMapping: any[] = [];
  selectedAssetNotes: any = [];
  filteredAssetList: any[];
  selectedAccountTypeId: number;
  public lstFeeType: any;
  lstdebtandequity: any;
  lstTypesofdebtequity: any;
  public filteredFacilities: any;
  lstNewInterestExpense: any = [];
  EffectiveDateCountInterestExpenseSchedule: any;
  public ListPrepayAndAdditionalFeeScheduleLiabilityDetail: any;
  public lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail: any;
  public modelheaderFeeName: any;
  public modelheaderDate: any;
  constructor(
    public liabilityNoteSrv: liabilityNoteService,
    public noteService: NoteService,
    private _router: Router,
    public _location: Location,
    public utils: UtilsFunctions,
    public utilityService: UtilityService,
    public membershipService: MembershipService,
    private activatedRoute: ActivatedRoute) {

    super(50, 1, 0);
    this._note = new liabilityNote('');
    this.CheckifUserIsLogedIN();
    this.GetAllLookups();
    this.activatedRoute.params.forEach((params: Params) => {
      if (params['id'] !== undefined) {
        this.DealAccountID = params['id'];
        this.actiontype = "new";
        this.GetAssetListByDealAccountID();
        this.GetLiabilityNote("00000000-0000-0000-0000-000000000000");
        this.GetRateScheduleByNoteAccountID();
        this.GetLiabilityFeeScheduleByAccountID();
        this.ChangeHeader();
        this.LiabilityNoteAccountID = "00000000-0000-0000-0000-000000000000";

      }
      else if (params['nid'] !== undefined) {
        this.LiabilityNote = params['nid'];
        this.GetLiabilityNote(this.LiabilityNote);
        this.actiontype = "update";
      }
    });

  }
  OpenPage() {

    var returnUrl = "";

    var LiabilityTypename = this._note.AccountTypeText;
    //this.LiabilityTypeID = this._note.LiabilityTypeGUID;
    if (LiabilityTypename == "Fund") {
      returnUrl = "/equity/n/" + this.LiabilityTypeID;
    } else if (LiabilityTypename != "Cash" && LiabilityTypename != "TBD") {
      returnUrl = "/debt/n/" + this.LiabilityTypeID;
    }
    if (returnUrl != "") {
      this._router.navigate([returnUrl]);
    }
  }
  FacilityChange(e) {
    if (this.filteredFacilities != undefined && this.filteredFacilities != null) {
      this.LiabilityTypeID = this.filteredFacilities.filter(x => x.LookupIDGuID == e)[0].TableGUID
    }
  }
  onLiabilityTypeChange(liabilityTypeId) {
    var selectedType = this.lstTypesofdebtequity.find(item => item.LookupID === parseInt(liabilityTypeId));
    if (selectedType) {
      this._note.AccountTypeText = selectedType.Name;
      this.filteredFacilities = this.lstdebtandequity.filter(item => item.DebtEquityType === selectedType.Name);
    }
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
    this.liabilityNoteSrv.getAllLookup().subscribe(res => {
      var data = res.lstLookups;
      this.lststatus = data.filter(x => x.ParentID == "51");
      this.lstRateSpreadSch_ValueType = data.filter(x => x.ParentID == "19");
      this.lstIntCalcMethodID = data.filter(x => x.ParentID == "25");
      this.lstIndextype = data.filter(x => x.ParentID == "32");
      this.lstApplyTrueUpFeature = data.filter(x => x.ParentID == "95");
      this.lstLiabilitySource = data.filter(x => x.ParentID == "151");
      this.lstFeeType = res.lstFeeTypeLookUp;
      this.getHolidayMaster();

      setTimeout(() => {
        this._bindGridDropdows();
        // this.flexrss.invalidate(true);
      }, 1000);
    });

  }
  DiscardChanges() {
    this._location.back();
  }
  getHolidayMaster() {
    this.noteService.GetHolidayMaster().subscribe(res => {
      if (res.Succeeded) {
        var data = res.dtholidaymaster;
        this.holidayCalendarNamelist = data;
      }
    })
  }

  showSelectAllCheckbox() {

  }
  GetLiabilityNote(noteid): void {
    this._isListFetching = true;
    this.LiabilityNoteGUID = noteid;

    this.liabilityNoteSrv.GetLiabilityNote(this.LiabilityNoteGUID).subscribe(res => {
      this._note = res.lstLiabilityNote;

      this.lstTypesofdebtequity = res.lstDebtEquityType;
      this.lstdebtandequity = res.AssetList;

      this.LiabilityTypeID = this._note.LiabilityTypeGUID;

      if (this.lstTypesofdebtequity !== undefined && this.lstTypesofdebtequity !== null) {
        var selectedType = this.lstTypesofdebtequity.find(item => item.LookupID === this._note.DebtEquityTypeID);
        if (selectedType) {
          this.filteredFacilities = this.lstdebtandequity.filter(item => item.DebtEquityType === selectedType.Name);
        }
      }

      this.Notetype = this._note.Type;
      this.ChangeHeader();
      this.DealAccountID = this._note.DealAccountID;
      this.LiabilityNoteAccountID = this._note.LiabilityNoteAccountID;

      if (this.DealAccountID !== undefined && this.DealAccountID !== null) {
        this.GetAssetListByDealAccountID();
      }

      this.selectedTypeID = this._note.LiabilityTypeID;
      this.selectedTypeText = this._note.LiabilityTypeText;

      this.txtCurrentBalanceValue = this.utils.formatNumberforTwoDecimalplaces(this._note.CurrentBalance, "");
      this.txtUndrawnCapacity = this.utils.formatNumberforTwoDecimalplaces(this._note.UndrawnCapacity, "");
      this.txtCurrentAdvanceRate = this.utils.formatNumberTopercent(this._note.CurrentAdvanceRate);

      this.utilityService.setPageTitle("M61–" + this._note.LiabilityName);
      this.GetRateScheduleByNoteAccountID();
      this.GetLiabilityFeeScheduleByAccountID();

      this.GetInterestExpenseSchedule();
      setTimeout(function () {
        this._isListFetching = false;
      }.bind(this), 500);
    });
  }
  GetAssetListByDealAccountID(): void {
    this.liabilityNoteSrv.GetAssetListByDealAccountID(this.DealAccountID).subscribe(res => {
      this.lAssetList = res.AssetList;

      this.DealInfo = res.DealInfo;
      this.DealID = this.DealInfo[0].DealID;
      this.DealName = this.DealInfo[0].DealName;

      this.filteredAssetList = this.lAssetList.filter(item => item.AccountTypeId !== "10");
      this.filteredAssetList = this.lAssetList.filter(item => item.AccountTypeId !== "10");
      this.lstNoteAssetMapping = res.LNoteAssetMap;

      const selectedAsset = this.lAssetList.find(asset => asset.LookupIDGuID === this._note.AssetAccountID);
      this.selectedAccountTypeId = selectedAsset ? selectedAsset.AccountTypeId : null;

      //Display Asset Notes

      const correspondingMappings = this.lstNoteAssetMapping.filter(
        (mapping) => mapping.LiabilityNoteId === this._note.LiabilityNoteID
      );

      if (correspondingMappings.length > 0) {
        const assetAccountIds = correspondingMappings.map(mapping => mapping.AssetAccountId);

        this.filteredAssetList.forEach(asset => asset.active = false);

        this.filteredAssetList.forEach(asset => {
          if (assetAccountIds.includes(asset.LookupIDGuID)) {
            asset.active = true;
          }
        });
      }

      this.selectedAssetNotes = this.filteredAssetList.filter(asset => asset.active === true);

    });
  }

  GetRateScheduleByNoteAccountID(): void {
    this._isListFetching = true;
    if (this.actiontype == "new") {
      this.LiabilityNoteAccountID = "00000000-0000-0000-0000-000000000000";
    }
    this.liabilityNoteSrv.GetRateScheduleByNoteAccountID(this.LiabilityNoteAccountID).subscribe(res => {
      if (res.Succeeded) {
        this.lstRatespreadschedule = res.ListLiabilityRate;
        this.ListEffectiveDateCount = res.ListEffectiveDateCount;
        if (this.lstRatespreadschedule != null) {
          if (this.lstRatespreadschedule[0] != null) {
            this._note.LatestEffectiveDaterateSchedule = this.lstRatespreadschedule[0].EffectiveDate;
          }
        }
        for (var i = 0; i < this.lstRatespreadschedule.length; i++) {
          if (this.lstRatespreadschedule[i].Date != null) {
            this.lstRatespreadschedule[i].Date = new Date(this.utils.convertDateToBindable(this.lstRatespreadschedule[i].Date));
          }

        }
        this.cvRatespreadschedule = new wjcCore.CollectionView(this.lstRatespreadschedule);
        this.cvRatespreadschedule.trackChanges = true;
        this.flexrss.invalidate();
        setTimeout(function () {
          this._isListFetching = false;
        }.bind(this), 500);
        this.ShowHideFlagRateSpreadSchedule = true;
        this.ShowHideFlagGeneralSetupDetails = true;
        this.ShowCountOnViewHistoryBtn();
      }
    });
  }

  GetLiabilityFeeScheduleByAccountID(): void {
    this._isListFetching = true;
    if (this.actiontype == "new") {
      this.LiabilityNoteAccountID = "00000000-0000-0000-0000-000000000000";
    }
    this.liabilityNoteSrv.GetLiabilityFeeScheduleByAccountID(this.LiabilityNoteAccountID).subscribe(res => {
      if (res.Succeeded) {
        this.lstFeeSchedule = res.ListFeeSchedule;
        this.ListEffectiveDateCount = res.ListEffectiveDateCount;
        this.ListPrepayAndAdditionalFeeScheduleLiabilityDetail = res.ListPrepayAndAdditionalFeeScheduleLiabilityDetail;

        if (this.lstFeeSchedule != null) {
          if (this.lstFeeSchedule[0] != null) {
            this._note.EffectiveDateFeeSchedule = this.lstFeeSchedule[0].EffectiveDate;
          }
        }
        if (this.lstFeeSchedule && this.lstFeeSchedule.length > 0) {
          for (var i = 0; i < this.lstFeeSchedule.length; i++) {
            if (this.lstFeeSchedule[i].StartDate != null) {
              this.lstFeeSchedule[i].StartDate = new Date(this.utils.convertDateToBindable(this.lstFeeSchedule[i].StartDate));
            }
            if (this.lstFeeSchedule[i].EndDate != null) {
              this.lstFeeSchedule[i].EndDate = new Date(this.utils.convertDateToBindable(this.lstFeeSchedule[i].EndDate));
            }
          }
        }
        this.cvFeeSchedule = new wjcCore.CollectionView(this.lstFeeSchedule);
        this.cvFeeSchedule.trackChanges = true;
        this.flexFeeSchedule.invalidate();
        setTimeout(function () {
          this._isListFetching = false;
        }.bind(this), 500);
        this.ShowHideFlagFeeSchedule = true;
        this.ShowHideFlagGeneralSetupDetails = true;
        this.ShowCountOnViewHistoryBtn();

      }
    });
  }

  showDialog(modulename) {
    this._note.modulename = modulename;
    this.getPeriodicDataByNoteId(this._note);
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
  Addcolumn(header, binding, format) {
    try {
      this.columns.push({ "header": header, "binding": binding, "format": format })
    } catch (err) { }
  }
  public getPeriodicDataByNoteId(_note) {
    this._note = _note;
    this.modulename = _note.modulename;
    this.lstPeriodicDataList = null;
    this._isPeriodicDataFetched = false;
    this._isPeriodicDataFetching = true;
    this._dvEmptyPeriodicDataMsg = false;

    var modal = document.getElementById('myModal');
    modal.style.display = "block";
    $.getScript("/js/jsDrag.js");
    this.liabilityNoteSrv.GetHistoricalDataOfLiabilityModuleByAccountIdAPI(_note, this._pageIndex, this._pageSize).subscribe(res => {
      if (res.Succeeded) {
        if (res.StatusCode != 404) {
          this._isPeriodicDataFetched = true;
          this._isPeriodicDataFetching = false;
          this._isSetHeaderEmpty = false;

          switch (_note.modulename) {
            case "GeneralSetupDetailsLiabilityNote":
              this.modulename = "Effective Date Based Setup";
              this.lstPeriodicDataList = res.lstGeneralSetupDetailsLiabilityNote;
              this._isSetHeaderEmpty = true;
              break;
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
              width: '200px',
              format: ''
            }));

            this.columns = [];
            this.columns = [
              { header: '', binding: '0' },
            ];
            var header = [];
            var data: any = this.lstPeriodicDataList;
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
            for (var j = 1; j < header.length; j++) {
              this.Addcolumn(header[j], header[j], 'n2')
            }

            data.forEach((obj, i) => { // FETCH ALL DATA AND PUSH IN FLEX GRID!!!
              this.grdPeriodicData.rows.push(new wjcGrid.Row(obj));
            });
          }
        } else {
          switch (_note.modulename) {
            case "RateSpreadSchedule":
              this.modulename = "Rate Spread Schedule";
              break;
            case "GeneralSetupDetailsLiabilityNote":
              this.modulename = "Effective Date Based Setup";
              break;
            case "InterestExpenseSchedule":
              this.modulename = "Interest Expense Schedule";
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

  ShowCountOnViewHistoryBtn() {
    if (this.ListEffectiveDateCount && this.ListEffectiveDateCount.length > 0) {
      for (var i = 0; i < this.ListEffectiveDateCount.length; i++) {
        var scheduleName = this.ListEffectiveDateCount[i].ScheduleName;
        switch (scheduleName) {

          case "RateSpreadScheduleLiability":
            scheduleName = "RateSpreadScheduleLiability";
            this.EffectiveDateCountRateSpreadSchedule = ' (' + this.ListEffectiveDateCount[i].EffectiveDateCount + ')';
            this._isSetHeaderEmpty = true;
            break;

          case "GeneralSetupDetailsLiabilityNote":
            scheduleName = "GeneralSetupDetailsLiabilityNote";
            this.EffectiveDateCountGeneralSetupDetailsLiabilityNote = ' (' + this.ListEffectiveDateCount[i].EffectiveDateCount + ')';
            this._isSetHeaderEmpty = true;
            break;

          case "PrepayAndAdditionalFeeScheduleLiability":
            scheduleName = "PrepayAndAdditionalFeeScheduleLiability";
            this.EffectiveDateCountFeeSchedule = ' (' + this.ListEffectiveDateCount[i].EffectiveDateCount + ')';
            this._isSetHeaderEmpty = true;
            break;

          case "InterestExpenseSchedule":
            scheduleName = "InterestExpenseSchedule";
            this.EffectiveDateCountInterestExpenseSchedule = ' (' + this.ListEffectiveDateCount[i].EffectiveDateCount + ')';
            this._isSetHeaderEmpty = true;
            break;

          default:
            break;
        }
      }
    }
  }


  ChangeHeader() {
    if (this.Notetype == "Equity") {
      this.lbladvnacerate = "Current Equity (%): ";
      this.lblUndrawn = "Undrawn Equity: ";
      this.lblPaydown = "Paydown Adv. Rate (%)";
      this.lblFunding = "Funding Adv. Rate (%)";
      this.lblTarget = "Target Adv. Rate (%)";
    } else {
      this.lbladvnacerate = "Current Advance Rate (%):";
      this.lblUndrawn = "Undrawn Capacity: ";
      this.lblPaydown = "Paydown Adv. Rate (%)";
      this.lblFunding = "Funding Adv. Rate (%)";
      this.lblTarget = "Target Adv. Rate (%)";

    }
  }


  CheckDuplicateDebtAndSave() {
    if (!this.CustomValidator()) {
      return;
    }
    this._isListFetching = true;
    this._note.modulename = "LiabilityNote";
    this._note.LiabilityNoteAccountID = this.LiabilityNoteAccountID;
    this.liabilityNoteSrv.CheckDuplicateforLiabilities(this._note).subscribe(res => {
      if (res.Succeeded) {
        if (res.Message === "Save") {
          this.SaveNote();
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
      this.CustomAlert("Error Occurred While Saving Liability Note.");
      console.error(error);
    });
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
    if (this.modulename == "Rate Spread Schedule") {
      this.lstRatespreadschedule[this.deleteRowIndex].IsDeleted = true;
      if (this.flexrss.rows[this.deleteRowIndex]) {
        this.deleteRateSpread.push(this.lstRatespreadschedule[this.deleteRowIndex]);
      }
      this.cvRatespreadschedule.removeAt(this.deleteRowIndex);
      this.flexrss.invalidate(true);
    }
    this.CloseDeletePopUp();
  }

  onChangeEnableAutoSpreadFundingsCheckbox(e): void {
    var checked = e.target.checked;
    if (checked == true) {
      this._note.UseNoteLevelOverride = true;
    } else { this._note.UseNoteLevelOverride = false; }
  }

  SaveNote() {
    this._isListFetching = true;
    this._note.LatestEffectiveDaterateSchedule = this.utils.convertDateToUTC(this._note.LatestEffectiveDaterateSchedule);
    this._note.MaturityDate = this.utils.convertDateToUTC(this._note.MaturityDate);
    this._note.PledgeDate = this.utils.convertDateToUTC(this._note.PledgeDate);
    this._note.EffectiveDate = this.utils.convertDateToUTC(this._note.EffectiveDate);
    this._note.EffectiveDateFeeSchedule = this.utils.convertDateToUTC(this._note.EffectiveDateFeeSchedule);

    if (this.lstRatespreadschedule && this.lstRatespreadschedule.length > 0) {
      for (var i = 0; i < this.lstRatespreadschedule.length; i++) {
        if (!(Number(this.lstRatespreadschedule[i].ValueTypeText).toString() == "NaN" || Number(this.lstRatespreadschedule[i].ValueTypeText) == 0)) {
          this.lstRatespreadschedule[i].ValueTypeID = Number(this.lstRatespreadschedule[i].ValueTypeText);
          this.lstRatespreadschedule[i].ValueTypeText = this.lstRateSpreadSch_ValueType.find(x => x.LookupID == this.lstRatespreadschedule[i].ValueTypeID).Name
        }
        else {
          var filteredarray = this.lstRateSpreadSch_ValueType.filter(x => x.Name == this.lstRatespreadschedule[i].ValueTypeText)
          if (filteredarray.length != 0) {
            this.lstRatespreadschedule[i].ValueTypeID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this.lstRatespreadschedule[i].IntCalcMethodText).toString() == "NaN" || Number(this.lstRatespreadschedule[i].IntCalcMethodText) == 0)) {
          this.lstRatespreadschedule[i].IntCalcMethodID = Number(this.lstRatespreadschedule[i].IntCalcMethodText);
          this.lstRatespreadschedule[i].IntCalcMethodText = this.lstIntCalcMethodID.find(x => x.LookupID == this.lstRatespreadschedule[i].IntCalcMethodID).Name
        } else {
          var filteredarray = this.lstIntCalcMethodID.filter(x => x.Name == this.lstRatespreadschedule[i].IntCalcMethodText)
          if (filteredarray.length != 0) {
            this.lstRatespreadschedule[i].IntCalcMethodID = Number(filteredarray[0].LookupID);
          }
        }
        if (!(Number(this.lstRatespreadschedule[i].IndexNameText).toString() == "NaN" || Number(this.lstRatespreadschedule[i].IndexNameText) == 0)) {
          this.lstRatespreadschedule[i].IndexNameID = Number(this.lstRatespreadschedule[i].IndexNameText);

          this.lstRatespreadschedule[i].IndexNameText = this.lstIndextype.find(x => x.LookupID == this.lstRatespreadschedule[i].IndexNameID).Name
        } else {
          var filteredarray = this.lstIndextype.filter(x => x.Name == this.lstRatespreadschedule[i].IndexNameText)

          if (filteredarray.length != 0) {
            this.lstRatespreadschedule[i].IndexNameID = Number(filteredarray[0].LookupID);
          }
        }


        if (!(Number(this.lstRatespreadschedule[i].DeterminationDateHolidayListText).toString() == "NaN" || Number(this.lstRatespreadschedule[i].DeterminationDateHolidayListText) == 0)) {
          this.lstRatespreadschedule[i].DeterminationDateHolidayList = Number(this.lstRatespreadschedule[i].DeterminationDateHolidayListText);

          this.lstRatespreadschedule[i].DeterminationDateHolidayListText = this.holidayCalendarNamelist.find(x => x.HolidayMasterID == this.lstRatespreadschedule[i].DeterminationDateHolidayList).CalendarName
        } else {
          var filteredarray = this.holidayCalendarNamelist.filter(x => x.CalendarName == this.lstRatespreadschedule[i].DeterminationDateHolidayListText)

          if (filteredarray.length != 0) {
            this.lstRatespreadschedule[i].DeterminationDateHolidayList = Number(filteredarray[0].HolidayMasterID);
          }
        }

        this.lstRatespreadschedule[i].EffectiveDate = this._note.LatestEffectiveDaterateSchedule;
        this.lstRatespreadschedule[i].ModuleId = 909;
        this.lstRatespreadschedule[i].LiabilityNoteAccountID = this.LiabilityNoteAccountID;
        this.lstRatespreadschedule[i].AccountID = this.LiabilityNoteAccountID;
        this.lstRatespreadschedule[i].Date = this.utils.convertDateToUTC(this.lstRatespreadschedule[i].Date);

      }
    }
    for (i = 0; i < this.deleteRateSpread.length; i++) {
      this.lstRatespreadschedule.push(this.deleteRateSpread[i]);
    }

    if (this.lstFeeSchedule && this.lstFeeSchedule.length > 0) {
      for (var i = 0; i < this.lstFeeSchedule.length; i++) {
        if (this.lstFeeSchedule[i].StartDate != null) {
          this.lstFeeSchedule[i].StartDate = this.utils.convertDateToUTC(this.lstFeeSchedule[i].StartDate);
        }
        if (this.lstFeeSchedule[i].EndDate != null) {
          this.lstFeeSchedule[i].EndDate = this.utils.convertDateToUTC(this.lstFeeSchedule[i].EndDate);
        }

        if (!(Number(this.lstFeeSchedule[i].FeeTypeText).toString() == "NaN" || Number(this.lstFeeSchedule[i].FeeTypeText) == 0)) {
          this.lstFeeSchedule[i].ValueTypeID = Number(this.lstFeeSchedule[i].FeeTypeText);
        }
        else {
          var filteredarray = this.lstFeeType.filter(x => x.Name == this.lstFeeSchedule[i].FeeTypeText)
          if (filteredarray.length != 0) {
            this.lstFeeSchedule[i].ValueTypeID = Number(filteredarray[0].LookupID);
          }
        }
        //-----
        if (!(Number(this.lstFeeSchedule[i].ApplyTrueUpFeatureText).toString() == "NaN" || Number(this.lstFeeSchedule[i].ApplyTrueUpFeatureText) == 0)) {
          this.lstFeeSchedule[i].ApplyTrueUpFeatureID = Number(this.lstFeeSchedule[i].ApplyTrueUpFeatureText);
        }
        else {
          var filteredarray = this.lstFeeType.filter(x => x.Name == this.lstApplyTrueUpFeature[i].ApplyTrueUpFeatureText)
          if (filteredarray.length != 0) {
            this.lstFeeSchedule[i].ApplyTrueUpFeatureID = Number(filteredarray[0].LookupID);
          }
        }

        this.lstFeeSchedule[i].EffectiveDate = this._note.EffectiveDateFeeSchedule;
        this.lstFeeSchedule[i].ModuleId = 908;
        this.lstFeeSchedule[i].AccountID = this.LiabilityNoteAccountID;

      }
    }
    for (i = 0; i < this.deleteFeeSchedule.length; i++) {
      this.lstFeeSchedule.push(this.deleteFeeSchedule[i]);
    }

    this._note.FeeScheduleList = this.lstFeeSchedule;
    this._note.ListLiabilityRate = this.lstRatespreadschedule;

    if (this.actiontype == "new") {
      this._note.LiabilityNoteAccountID = "00000000-0000-0000-0000-000000000000";
      this._note.DealAccountID = this.DealAccountID;
    }

    this.lstNoteAssetMapping = [];

    var selectedLookupIds = this.selectedAssetNotes.map(assetName => {
      const asset = this.lAssetList.find(x => x.AssetIdName === assetName.AssetIdName);
      return asset ? asset.LookupIDGuID : null;
    }).filter(id => id !== null);

    selectedLookupIds.forEach(lookupId => {
      var newMapping = {
        LiabilityNoteId: this._note.LiabilityNoteID,
        DealAccountId: this._note.DealAccountID,
        LiabilityNoteAccountId: this._note.LiabilityNoteAccountID,
        AssetAccountId: lookupId
      };
      this.lstNoteAssetMapping.push(newMapping);
    });

    if (this.selectedAccountTypeId == 10 && this.selectedAssetNotes.length === 0) {
      this.lAssetList.forEach((e) => {
        if (e.AccountTypeId !== "10") {
          var newMapping = {
            LiabilityNoteId: this._note.LiabilityNoteID,
            DealAccountId: this._note.DealAccountID,
            LiabilityNoteAccountId: this._note.LiabilityNoteAccountID,
            AssetAccountId: e.LookupIDGuID
          };
          this.lstNoteAssetMapping.push(newMapping);
        }
      });
    }

    this._note.LiabilityAssetMap = this.lstNoteAssetMapping;

    this.lstNewInterestExpense = [];
    var newInterestExpenseData = {
      InterestExpenseScheduleID: this._note.InterestExpenseScheduleID,
      DebtAccountID: this.LiabilityNoteAccountID,
      AdditionalAccountID: this._note.SelectedAdditionalAccountID,
      EffectiveDate: this.utils.convertDateToUTC(this._note.SelectedEffectiveDate),
      InitialInterestAccrualEnddate: this.utils.convertDateToUTC(this._note.SelectedInitialInterestAccrualEnddate),
      PaymentDayOfMonth: this._note.SelectedPaymentDayMonth,
      PaymentDateBusinessDayLag: this._note.SelectedPaymentDateBusinessDayLag,
      Determinationdateleaddays: this._note.SelectedDeterminationdateleaddays,
      DeterminationDateReferenceDayOftheMonth: this._note.SelectedDeterminationDateRefDayMonth,
      FirstRateIndexResetDate: this.utils.convertDateToUTC(this._note.SelectedFirstRateIndexResetDate),
      InitialIndexValueOverride: this._note.SelectedInitialIndexValueOverride,
      Recourse: this._note.SelectedRecourse,
      EventID: this._note.SelectedEventID
    };

    this.lstNewInterestExpense.push(newInterestExpenseData);
    this._note.ListInterestExpense = this.lstNewInterestExpense;
    this._note.ListPrepayAndAdditionalFeeScheduleLiabilityDetail = this.ListPrepayAndAdditionalFeeScheduleLiabilityDetail;

    this.liabilityNoteSrv.SaveLiabilityNote(this._note).subscribe(res => {
      if (res.Succeeded) {
        this._Showmessagediv = true;
        this._ShowmessagedivMsg = "Note Saved Successfully";
        setTimeout(function () {
          this._Showmessagediv = false;
          this._ShowmessagedivMsg = "";
          this._isListFetching = false;

          if (this.actiontype == "new") {
            this._location.back();
          } else {
            var returnUrl = this._router.url;
            if (window.location.href.indexOf("liabilityNote/n/") > -1) {
              returnUrl = returnUrl.toString().replace('liabilityNote/n/', 'liabilityNote/u/');

            }
            else if (returnUrl.indexOf("liabilityNote/u/") > -1) {
              returnUrl = returnUrl.toString().replace('liabilityNote/u/', 'liabilityNote/n/');
            } else if (window.location.href.indexOf("liabilityNote/d/") > -1) {
              this._location.back();
            }
            this._router.navigate([returnUrl]);
          }


        }.bind(this), 1000);

      }
    });
  }

  CustomValidator(): boolean {
    var ms = "";
    let isValid = true;

    if (this._note.LiabilityNoteID == "" || this._note.LiabilityNoteID == null || this._note.LiabilityNoteID === undefined) {
      ms = ms + "Liability Note ID" + ", ";
      isValid = false;
    }
    if (this._note.AssetAccountID == null || this._note.AssetAccountID === undefined) {
      ms = ms + "Asset ID" + ", ";
      isValid = false;
    }
    if (this._note.DebtEquityTypeID == null || this._note.DebtEquityTypeID === undefined) {
      ms = ms + "Liability Type" + ", ";
      isValid = false;
    }
    if (this._note.LiabilityTypeID == null || this._note.LiabilityTypeID === undefined) {
      ms = ms + "Facility" + ", ";
      isValid = false;
    }
    if (ms != "") {
      ms = "</p>" + ms.slice(0, ms.length - 2) + " cannot be blank." + "</p>";
    }

    var RatespreadScheduleHasData = this.lstRatespreadschedule && this.lstRatespreadschedule.length > 0;
    if (RatespreadScheduleHasData && !this._note.LatestEffectiveDaterateSchedule) {
      ms = ms + "<p>" + "Rate spread Schedule can not save without Effective Date." + "</p>";
      isValid = false;
    }
    var currentEffectiveDate: any;
    if (this._note.LatestEffectiveDaterateSchedule != null) {
       currentEffectiveDate = this._note.LatestEffectiveDaterateSchedule;
    }
    if (this.lstRatespreadschedule && this.lstRatespreadschedule.length > 0) {
      for (var i = 0; i < this.lstRatespreadschedule.length; i++) {
        var currentStartdate = this.lstRatespreadschedule[i].Date;
        if (new Date(currentStartdate).getTime() < new Date(currentEffectiveDate).getTime()) {
          ms = ms + "<p>" + "Rate Spread Schedule Start Date (" + this.utils.convertDateToBindable(currentStartdate) + ") cannot be smaller than Effective Date (" + this.utils.convertDateToBindable(currentEffectiveDate) + ").</p>";
          isValid = false;
        }
      }
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

  StatusChange(newvalue): void {
    this._note.Applied = newvalue;
  }
  LiabilitySourceChange(newvalue): void {
    this._note.LiabilitySource = newvalue;
  }

  pmtdtaccperChange(newvalue): void {
    this._note.pmtdtaccper = newvalue;
  }
  ResetIndexDailyChange(newvalue): void {
    this._note.ResetIndexDaily = newvalue;
  }
  RoundingMethodChange(newvalue): void {
    this._note.RoundingMethod = newvalue;
  }
  

  AssetIDChange(newvalue): void {
    this._note.AssetAccountID = newvalue;

    const selectedAsset = this.lAssetList.find(asset => asset.LookupIDGuID === this._note.AssetAccountID);
    this.selectedAccountTypeId = selectedAsset ? selectedAsset.AccountTypeId : null;

    if (this.selectedAccountTypeId == 1) {
      this.selectedAssetNotes = [];
    }
  }

  //-auto search
  checkDroppedDownChangedUserName(sender: wjNg2Input.WjAutoComplete, args: any) {
    var ac = sender;
    if (ac.selectedIndex == -1) {//LiabilityTypeID
      if (ac.text != this.selectedTypeText) {
        //this.selectedTypeText = null;
        //this.selectedTypeID = null;
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
      // not in cache, get from server
      var params = { query: query, max: max };
      this._searchObj = new Search(query);

      this.liabilityNoteSrv.GetAutosuggestDebtAndEquityName(query).subscribe(res => {
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

  private _bindGridDropdows() {
    var flexrss = this.flexrss;
    var flexFeeSchedule = this.flexFeeSchedule;
    if (flexrss) {
      var colrssValueType = flexrss.columns.getColumn('ValueTypeText');
      var colrssIntCalcMethod = flexrss.columns.getColumn('IntCalcMethodText');
      var colrssIndexNameText = flexrss.columns.getColumn('IndexNameText');
      var colrssDeterminationDateHolidayListText = flexrss.columns.getColumn('DeterminationDateHolidayListText');


      if (colrssValueType) {
        colrssValueType.dataMap = this._buildDataMap(this.lstRateSpreadSch_ValueType, 'LookupID', 'Name');
        this.dataMapValueType = this._buildDataMap(this.lstRateSpreadSch_ValueType, 'LookupID', 'Name');
        colrssIntCalcMethod.dataMap = this._buildDataMap(this.lstIntCalcMethodID, 'LookupID', 'Name');


        colrssIndexNameText.dataMap = this._buildDataMap(this.lstIndextype, 'LookupID', 'Name');
        colrssDeterminationDateHolidayListText.dataMap = this._buildDataMap_holidayCalendarNamelist(this.holidayCalendarNamelist);
      }
    }
    if (flexFeeSchedule) {
      var colFeeTypeText = flexFeeSchedule.columns.getColumn('FeeTypeText');
      if (colFeeTypeText) {
        colFeeTypeText.dataMap = this._buildDataMap(this.lstFeeType, 'LookupID', 'Name');
      }

      var colPrepayApplyTrueUpFeatureText = flexFeeSchedule.columns.getColumn('ApplyTrueUpFeatureText');
      if (colPrepayApplyTrueUpFeatureText) {
        colPrepayApplyTrueUpFeatureText.dataMap = this._buildDataMap(this.lstApplyTrueUpFeature, 'LookupID', 'Name');
      }
    }
  }

  GetInterestExpenseSchedule(): void {
    this._isListFetching = true;
    if (this.actiontype == "new") {
      this.LiabilityNoteAccountID = "00000000-0000-0000-0000-000000000000";
    }
    this.liabilityNoteSrv.GetInterestExpenseSchedule(this.LiabilityNoteAccountID).subscribe(res => {
      if (res.Succeeded) {
        if (res.lstInterestExpenseSchedule.length > 0) {

          this.lstNewInterestExpense = res.lstInterestExpenseSchedule[0];
          this._note.InterestExpenseScheduleID = this.lstNewInterestExpense.InterestExpenseScheduleID;
          this._note.SelectedEffectiveDate = this.lstNewInterestExpense.EffectiveDate;
          this._note.SelectedInitialInterestAccrualEnddate = this.lstNewInterestExpense.InitialInterestAccrualEnddate;
          this._note.SelectedPaymentDayMonth = this.lstNewInterestExpense.PaymentDayOfMonth;
          this._note.SelectedPaymentDateBusinessDayLag = this.lstNewInterestExpense.PaymentDateBusinessDayLag;
          this._note.SelectedDeterminationdateleaddays = this.lstNewInterestExpense.Determinationdateleaddays;
          this._note.SelectedDeterminationDateRefDayMonth = this.lstNewInterestExpense.DeterminationDateReferenceDayOftheMonth;
          this._note.SelectedInitialIndexValueOverride = this.lstNewInterestExpense.InitialIndexValueOverride;
          this._note.SelectedRecourse = this.lstNewInterestExpense.Recourse;
          this._note.SelectedFirstRateIndexResetDate = this.lstNewInterestExpense.FirstRateIndexResetDate;
          this._note.SelectedEventID = this.lstNewInterestExpense.EventID;
          this._note.SelectedAdditionalAccountID = this.lstNewInterestExpense.AdditionalAccountID;
        }
        else {
          this._note.InterestExpenseScheduleID = 0;
          this._note.SelectedEffectiveDate = null;
          this._note.SelectedInitialInterestAccrualEnddate = null;
          this._note.SelectedPaymentDayMonth = null;
          this._note.SelectedPaymentDateBusinessDayLag = null;
          this._note.SelectedDeterminationdateleaddays = null;
          this._note.SelectedDeterminationDateRefDayMonth = null;
          this._note.SelectedInitialIndexValueOverride = null;
          this._note.SelectedRecourse = null;
          this._note.SelectedFirstRateIndexResetDate = null;
          this._note.SelectedEventID = "00000000-0000-0000-0000-000000000000";
          this._note.SelectedAdditionalAccountID = "00000000-0000-0000-0000-000000000000";
        }
      }
    });
  }

  DeleteInterestExpenseSchedule() {
    this._isListFetching = true;
    if (this.actiontype == "new") {
      this.LiabilityNoteAccountID = "00000000-0000-0000-0000-000000000000";
    }
    this.liabilityNoteSrv.DeleteInterestExpenseSchedule(this.LiabilityNoteAccountID).subscribe(res => {
      if (res.Succeeded) {
        this.GetInterestExpenseSchedule();
      }
    });
    this._isListFetching = false;
  }

  AddPrepayAndAdditionalFeeScheduleLiabilityDetail(item: any) {
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
        EffectiveDate: this.utils.convertDateToBindable(this._note.EffectiveDateFeeSchedule)
      };
      this.lstSpecificPrepayAndAdditionalFeeScheduleLiabilityDetail.push(temp);
    }
    this.modelheaderFeeName = item.FeeName;
    this.modelheaderDate = this.utils.convertDateToBindable(item.StartDate);

    var modal = document.getElementById('myModalPrepayAndAdditionalFeeScheduleLiabilityDetail');
    modal.style.display = "block";
    $.getScript("/js/jsDrag.js");
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

  { path: '', component: LiabilityNoteComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjInputModule, WjGridFilterModule],
  declarations: [LiabilityNoteComponent]
})

export class liabilityNoteModule { }
