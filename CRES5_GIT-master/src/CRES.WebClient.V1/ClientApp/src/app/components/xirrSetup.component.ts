import { Component, ViewChild } from "@angular/core";
import { Router, ActivatedRoute, Params } from '@angular/router';
import * as wjcGrid from '@grapecity/wijmo.grid';
import { NgModule } from '@angular/core';
import * as wjcCore from '@grapecity/wijmo';
import { Paginated } from '../core/common/paginated.service';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { CommonModule, Location } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { WjInputModule } from '@grapecity/wijmo.angular2.input';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import { UtilsFunctions } from './../core/common/utilsfunctions';
import { UtilityService } from '../core/services/utility.service';
import { MembershipService } from '../core/services/membership.service';
import { PermissionService } from '../core/services/permission.service';
import * as wjNg2Input from '@grapecity/wijmo.angular2.input';
import { dndDirectiveModule } from '../directives/dnd.directive';
import { WjNavModule, WjTreeView } from '@grapecity/wijmo.angular2.nav';
import * as WjNav from '@grapecity/wijmo.nav';
import { scenarioService } from '../core/services/scenario.service';
import { portfolioService } from '../core/services/portfolio.service'
import { NoteService } from '../core/services/note.service';
import { Scenario } from "../core/domain/scenario.model";
import { XIRRService } from '../core/services/xirr.service';
import { XIRRConfigMasterDataContract, XIRRConfig } from "../core/domain/XIRRConfig.model";
import { XIRRConfigParam } from "../core/domain/XIRRConfig.model";
import { XIRRConfigFilterDataContract } from "../core/domain/XIRRConfig.model";
import * as wjNg2GridFilter from '@grapecity/wijmo.angular2.grid.filter';
import * as wjcInput from '@grapecity/wijmo.input';
import { element, utils } from "protractor";
import { type } from "os";
import { portfolio } from "../core/domain/portfolio.model";

declare var $: any;

@Component({
  selector: "xirrSetup",
  templateUrl: "./xirrSetup.html",
  providers: [UtilityService, PermissionService, XIRRService, UtilsFunctions, portfolioService]
})

export class xirrSetupComponent extends Paginated {
  public _ShowSuccessmessage !: string;
  public _ShowErrorMessage !: string;
  public _ShowSuccessmessagediv: boolean = false;
  public _dvEmptyDealSearchMsg: boolean = false;

  public: boolean = false;

  public _isxirrListFetching!: boolean;

  ObjCategoryTrans = {};
  public ListSelectedTransactionsType: any = [];
  lstTransactionTypes: any;
  arrTransTypes = [];
  maxrownumber: any;
  _lstXIRRConfig: any = [];
  public _xirrConfigMaster: XIRRConfigMasterDataContract;
  public _xirrConfig: XIRRConfig;
  public _xirrConfigParam: XIRRConfigParam;
  public _xirrFiltersDC: XIRRConfigFilterDataContract;
  public archiveInputDate: any = new Date();
  lstTagsViewNotes: any;
  AttachedNotesCount: any;
  lstXIRRFilters: any[];
  lstPool: any = [];
  lstProductType: any = [];
  lstState: any = [];
  lstDealType: any = [];
  lstMSA: any = [];
  lstLoanStatus: any = [];
  lstVintageYear: any = [];
  lstXIRRFiltersLookup: any = [];
  lstFilterNames: any = [];
  public lstXIRRTags: any = [];
  _chkSelectAll: boolean = false;
  _isxirrdealdetail: boolean = false;
  isshowportfoliodata: boolean = false;

  _isShowGrouping: boolean = false;
  lstPortfolio: any = [];

  public _lstScenario: any

  private _scenariodc: Scenario;

  public _lstRelativeDate: any;

  public _lstArchivalRequirement: any;
  public _lstUpdateXIRRLinkedDeal: any;
  showAlert: any;
  alert: any;
  xirrConfigList: any = [];
  currentrownumber: any;
  currentconfigid: any;
  currentReturnName: any;
  currentDescription: any;
  hti: any;
  dealorportfolio = "";
  CutoffDateOverrideFormatted = "";
  ListDealLevelinfo: any[];
  listportfolioinfo: any[];
  public _isArchivesTabClicked: boolean = false;
  _lstgetArchivesOutput: any = [];
  _cvarchivesOutputlist !: wjcCore.CollectionView;
  public transactionerror: boolean = false;

  @ViewChild('XIRRflex') XIRRflex !: wjcGrid.FlexGrid;
  @ViewChild('flexXIRROutput') flexXIRROutput !: wjcGrid.FlexGrid;
  @ViewChild('Archivesflex') Archivesflex !: wjcGrid.FlexGrid;
  @ViewChild('Pool') Pool: wjNg2Input.WjMultiSelect
  @ViewChild('ProductType') ProductType: wjNg2Input.WjMultiSelect
  @ViewChild('State') State: wjNg2Input.WjMultiSelect
  @ViewChild('DealType') DealType: wjNg2Input.WjMultiSelect
  @ViewChild('LoanStatus') LoanStatus: wjNg2Input.WjMultiSelect
  @ViewChild('MSA') MSA: wjNg2Input.WjMultiSelect
  @ViewChild('VintageYear') VintageYear: wjNg2Input.WjMultiSelect
  @ViewChild('flexDealLevelinfo') flexDealLevelinfo: wjcGrid.FlexGrid;
  @ViewChild('TagMasterXIRRflex') TagMasterXIRRflex !: wjcGrid.FlexGrid;

  dtlistXIRRfilterConfig: any = [];
  _transactiontypeslist !: wjcCore.CollectionView;
  _cvXIRRConfiglist !: wjcCore.CollectionView;
  public _isShowLoader: boolean = false;
  /* public _isNoteListFetching: boolean = false;*/
  public _ClckXIRRRow: number = -1;
  public _ClckXIRRCol: number = -1;
  public xirrdeleteRowIndex: number;
  //deletedxirrConfig: any = [];
  @ViewChild('ctxMenu') ctxMenu: wjcInput.Menu;
  @ViewChild('ctxAggreMenu') ctxAggreMenu: wjcInput.Menu;
  listtagmasterXIRRlist: any = [];
  public _MsgText !: string;
  public _delTagMasterXIRRId: any;
  public deleteRowIndex !: number;
  _tagmasterXIRRlist !: wjcCore.CollectionView;
  XIRROutputPortfoli: any;
  columns: {
    binding?: string, header?: string, width?: any, format?: string
  }[];
  columnsXIRR: any = [];
  selectedxirrconfigid: any = "";
  Aggregatecolumnhdr: any = "";
  selectedxirrreturnName: any = "";
  lstjsonparameters: any = [];
  lstjsonparam: any = [];
  public selectedreturnname !: string;
  public selectedscenrio !: string;
  public selectedPool!: string;
  public selectedReturnType!: string;
  public LastCalculated!: string;
  public selectedProductType!: string;
  public selectedState!: string;
  public selectedDelType!: string;
  public _isshowxirrinfodiv: boolean = false;
  public xirrType: string;
  public DealIDheader: string;
  _isShowXIRRDashboard: boolean = true;
  _isShowXIRRSetup: boolean = true;
  _isShowArchive: boolean = true;
  _isShownoteTags: boolean = true;
  _isShownDownloadCashflowButton: boolean = false;
  _isnodealxirrfound: boolean = false;
  _isshowpoolinfo: boolean = true;
  _isshowstate: boolean = true;
  _isshowptype: boolean = true;
  _isshowdtype: boolean = true;
  _isshowportreturnname: boolean = false;
  _isshowDealreturnname: boolean = false;

  public selectedLoanStatus!: string;
  public selectedMSA!: string;
  public selectedVintageYear!: string;

  _isshowdLoanStatus: boolean = true;
  _isshowdMSA: boolean = true;
  _isshowdVintageYear: boolean = true;

  calcstatus: any = "";
  statusRefreshInterval: any;
  _isshownoresultfound: boolean = false;
  public archiveComments: string;
  xirrtotal: any;
  validator = (date: Date) => {
    return (date <= new Date())
  }
  constructor(

    public utils: UtilsFunctions,
    private _router: Router,
    public utilityService: UtilityService,
    public membershipService: MembershipService,
    public _location: Location,
    private activatedRoute: ActivatedRoute,
    public permissionService: PermissionService,
    public xirrSrv: XIRRService,
    public _portfolioService: portfolioService,
    public scenarioService: scenarioService,
    public notesvc: NoteService,
  ) {
    super(50, 1, 0);
    this.utilityService.setPageTitle("M61–XIRR-Setup");
    this._scenariodc = new Scenario('');
    this._xirrFiltersDC = new XIRRConfigFilterDataContract();
    this._xirrConfig = new XIRRConfig();
    this.GetAllLookups();
    /* this.getAllDistinctScenario();*/
    this.GetAllTagNameXIRR();
    this.GetAllXIRRTransactiontypes();
    //this.GetLookupforXIRRFilters();

    this.CheckifUserIsLogedIN();
    this.getXIRRConfig();
    this.listportfolioinfo = [];
    this.GetXIRRFiltersDropDown();
    this.getAllArchiveXIRROutput();
  }

  showarrow() {
    $('.panel-collapse').on('show.bs.collapse', function () {
      $(this).siblings('.panel-heading').addClass('active');
    });

    $('.panel-collapse').on('hide.bs.collapse', function () {
      $(this).siblings('.panel-heading').removeClass('active');
    });
  }
  //code start
  ngOnInit() {

  }



  addFooterRowGrid(flexDealLevelinfo: wjcGrid.FlexGrid) {
    var row = new wjcGrid.GroupRow();
    flexDealLevelinfo.columnFooters.rows.push(row);
    flexDealLevelinfo.bottomLeftCells.setCellData(0, 0, '\u03A3');
  }

  addFooterRowCustom(flexGrid) {
    if (flexGrid.columnFooters.rows.length == 0) {
      flexGrid.columnFooters.rows.push(new wjcGrid.GroupRow());
      flexGrid.bottomLeftCells.setCellData(0, 0, '\u03A3');
    }
    if (this.xirrtotal !== undefined) {
      flexGrid.formatItem.addHandler((s, e) => {
        if (s.columnFooters === e.panel && e.row === 0 && e.col === 2) {
          if (s.collectionView) {
            const items = s.collectionView.items;
            if (items) {
              e.cell.innerHTML = this.xirrtotal;
            }
          }
        }
      });
    }

  }

  GetXIRRDashboard() { }
  GetAllXIRRTransactiontypes() {
    this.xirrSrv.getallxirrtransactiontypes().subscribe(res => {
      if (res.Succeeded) {
        this.lstTransactionTypes = res.TTList;
        this.arrTransTypes = [];
        this.lstTransactionTypes.forEach((e) => {
          this.arrTransTypes.push(e.TransactionName)
        });
      }
    });
  }
  showdiv() {
    this._isxirrdealdetail = true;
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

  GetAllTagNameXIRR() {
    this.notesvc.GetAllTagsNameXIRR().subscribe(res => {
      if (res.Succeeded) {
        this.lstXIRRTags = res.dt;
      }
    });
  }


  AddNewXirrConfig() {
    localStorage.setItem('ClickedTabId', 'AddNewXirrConfig');
    var notepath = ['/#/xirrConfiguration/a/00000000-0000-0000-0000-000000000000'];
    window.open(notepath.toString(), '_self', '');

  }
  getXIRRConfig() {
    this._isShowLoader = true;
    this.xirrSrv.GetXIRRConfigs().subscribe(res => {
      if (res.Succeeded == true) {
        this.ApplyPermissions(res.UserPermissionList);
        this._lstXIRRConfig = res.lstXirrConfig;
        this.lstXIRRFilters = res.ListXirrFilters;


        for (var i = 0; i < this._lstXIRRConfig.length; i++) {
          if (this._lstXIRRConfig[i].UpdatedDate != null) {
            this._lstXIRRConfig[i].UpdatedDate = new Date(this.utils.convertDateToBindableWithTime(this._lstXIRRConfig[i].UpdatedDate));
          }
        }


        this._cvXIRRConfiglist = new wjcCore.CollectionView(this._lstXIRRConfig);
        this._cvXIRRConfiglist.trackChanges = true;
        this.XIRRflex.invalidate();
        
        this.statusRefreshInterval = setInterval(() => {
          this.xirrSrv.GetXIRRConfigs().subscribe(updateRes => {
            if (updateRes.Succeeded === true) {

              for (let i = 0; i < this._lstXIRRConfig.length; i++) {
                var updatedConfig = updateRes.lstXirrConfig.find(config => config.XIRRConfigID === this._lstXIRRConfig[i].XIRRConfigID);
                if (updatedConfig) {
                  this._lstXIRRConfig[i].Status = updatedConfig.Status;
                }
              }
              this._cvXIRRConfiglist.refresh();
            }
          });
        }, 10000);

      }

      else {
        this._isShowLoader = false;

        this._ShowErrorMessage = "Error occurred while loading XIRR Setup. Please contact administrator..";
        this._dvEmptyDealSearchMsg = true;
        setTimeout(() => {
          this._dvEmptyDealSearchMsg = false;
        }, 5000);
        //Message
      }

      this._isShowLoader = false;
    });
    //this.XIRRflex.rows.defaultSize = 40;
  }

  ngOnDestroy() {
    clearInterval(this.statusRefreshInterval);
  }


  GetAllLookups(): void {
    this.xirrSrv.getAllLookup().subscribe(res => {
      if (res.Succeeded) {
        var data = res.lstLookups;
        this._lstRelativeDate = data.filter(x => x.ParentID == "145");
      }
      else {
        if (res.Message == "Authentication failed") {
          this._router.navigate(['login']);
        }
      }
    });
  }

  GetXIRRFiltersDropDown() {
    var XIRRConfigID = this._lstXIRRConfig.XIRRConfigID;
    this.xirrSrv.GetLookupforXIRRFilters(XIRRConfigID).subscribe(res => {
      if (res.Succeeded) {
        this.lstXIRRFiltersLookup = res.XIRRFiltersLookup;
        var data = this.lstXIRRFiltersLookup;
        this.lstPool = data.filter(x => x.Type == "Pool");
        this.lstProductType = data.filter(x => x.Type == "ProductType");
        this.lstState = data.filter(x => x.Type == "State");
        this.lstDealType = data.filter(x => x.Type == "DealType");
        this.lstLoanStatus = data.filter(x => x.Type == "LoanStatus");
        this.lstMSA = data.filter(x => x.Type == "MSA");
        this.lstVintageYear = data.filter(x => x.Type == "VintageYear");
        this.lstFilterNames = res.ListXirrFilters;
      }
    });
  }

  XIRRCalc() {
    this._isShowLoader = true;
    //code comment
    var _lstXIRRConfigSelected = this._lstXIRRConfig.filter(x => x.IsActive == true && x.XIRRConfigID !== undefined && x.XIRRConfigID > 0)

    if (_lstXIRRConfigSelected != null && _lstXIRRConfigSelected.length > 0) {

      this._isArchivesTabClicked = false;
      let ids = _lstXIRRConfigSelected.map(x => x.XIRRConfigID);
      var XIRRConfigIDs = ids ? ids.join(",") : "";
      this._xirrConfigParam = new XIRRConfigParam();

      this._xirrConfigParam.XIRRConfigIDs = XIRRConfigIDs;
      this.xirrSrv.xirrcalc(this._xirrConfigParam).subscribe(res => {
        if (res.Succeeded) {
          this._isShowLoader = false;
          this._ShowSuccessmessage = "XIRR Calc submitted successfully.";
          this._ShowSuccessmessagediv = true;
          setTimeout(() => {
            this._ShowSuccessmessagediv = false;
          }, 5000);
        }
        else {
          this._isShowLoader = false;
          this._ShowErrorMessage = "Something went wrong. Please try after some time.";
          this._dvEmptyDealSearchMsg = true;
          setTimeout(() => {
            this._dvEmptyDealSearchMsg = false;
          }, 5000);
        }
      });
    }
    else {

      this.CustomAlert('Please select the Return to calc the XIRR.');
      this._isShowLoader = false;
    }

  }

  XIRRCalcDashBoard() {
    this._isShowLoader = true;

    this._xirrConfigParam = new XIRRConfigParam();
    this._xirrConfigParam.XIRRConfigIDs = this.selectedxirrconfigid;

    if (this.selectedxirrconfigid != "") {
      this.xirrSrv.xirrcalc(this._xirrConfigParam).subscribe(res => {
        if (res.Succeeded) {
          this._isShowLoader = false;
          this._ShowSuccessmessage = "XIRR Calc submitted successfully.";
          this._ShowSuccessmessagediv = true;
          setTimeout(() => {
            this._ShowSuccessmessagediv = false;
          }, 5000);
        }
        else {
          this._isShowLoader = false;
          this._ShowErrorMessage = "Something went wrong. Please try after some time.";
          this._dvEmptyDealSearchMsg = true;
          setTimeout(() => {
            this._dvEmptyDealSearchMsg = false;
          }, 5000);
        }
      });
    } else {
      this.CustomAlert('Please select the Return to calc the XIRR.');
      this._isShowLoader = false;
    }

  }
  XIRRArchive() {

    var _lstXIRRConfigSelected = this._lstXIRRConfig.filter(x => x.IsActive == true && x.XIRRConfigID !== undefined && x.XIRRConfigID > 0)

    if (this.archiveInputDate == undefined || this.archiveInputDate == null || this.archiveInputDate.toString() == "") {
      this.CustomAlert("Please enter date.");
    }

    else if (_lstXIRRConfigSelected != null && _lstXIRRConfigSelected.length > 0) {

      this._isArchivesTabClicked = false;
      this.ClosePopUpReportFileAttribute();
      this.ClosePopUpArchiveDateValidate();
      this._isShowLoader = true;
      let ids = _lstXIRRConfigSelected.map(x => x.XIRRConfigID);
      var XIRRConfigIDs = ids ? ids.join(",") : "";
      this._xirrConfigParam = new XIRRConfigParam();
      this._xirrConfigParam.XIRRConfigIDs = XIRRConfigIDs;
      this._xirrConfigParam.ArchiveDate = this.utils.convertDateToUTC(this.archiveInputDate);
      this._xirrConfigParam.Comments = this.archiveComments;
      this._isShowLoader = false;
      this.xirrSrv.archivexirrinputoutput(this._xirrConfigParam).subscribe(res => {
        if (res.Succeeded) {
          this._isShowLoader = false;
          this._ShowSuccessmessage = "Data archive request sent successfully.";
          this._ShowSuccessmessagediv = true;
          setTimeout(() => {
            this._ShowSuccessmessagediv = false;
          }, 5000);
        }
        else {
          this._isShowLoader = false;
          this._ShowErrorMessage = "Something went wrong. Please try after some time.";
          this._dvEmptyDealSearchMsg = true;
          setTimeout(() => {
            this._dvEmptyDealSearchMsg = false;
          }, 5000);
        }
      });
    }
    else {
      this.CustomAlert('Please select the Return to archive.');
    }

  }

  XIRRArchivefromDealLevelXIRR() {

    if (this.archiveInputDate == undefined || this.archiveInputDate == null || this.archiveInputDate.toString() == "") {
      this.CustomAlert("Please enter date.");
    }

    this.ClosePopUp();
    this.ClosePopUpDealLevelArchiveDateValidate();
    this._isShowLoader = true;
    this._isArchivesTabClicked = false;
    var XIRRConfigIDs = this.selectedxirrconfigid;
    this._xirrConfigParam = new XIRRConfigParam();
    this._xirrConfigParam.XIRRConfigIDs = XIRRConfigIDs;
    this._xirrConfigParam.ArchiveDate = this.utils.convertDateToUTC(this.archiveInputDate);
    this._xirrConfigParam.Comments = this.archiveComments;
    this._isShowLoader = false;
    this.xirrSrv.archivexirrinputoutput(this._xirrConfigParam).subscribe(res => {
      if (res.Succeeded) {
        this._isShowLoader = false;
        this._ShowSuccessmessage = "Data archive request sent successfully.";
        this._ShowSuccessmessagediv = true;
        setTimeout(() => {
          this._ShowSuccessmessagediv = false;
        }, 5000);
        this._isArchivesTabClicked = false;
      }
      else {
        this._isShowLoader = false;
        this._ShowErrorMessage = "Something went wrong. Please try after some time.";
        this._dvEmptyDealSearchMsg = true;
        setTimeout(() => {
          this._dvEmptyDealSearchMsg = false;
        }, 5000);
      }
    });
  }

  invalidateArchiveTab() {
    if (!this._isArchivesTabClicked) {
      this._isArchivesTabClicked = true;
      this.getAllArchiveXIRROutput();
    }

  }

  getAllArchiveXIRROutput() {
    this._isShowLoader = true;
    this.xirrSrv.GetAllArchiveXIRROutput().subscribe(res => {
      if (res.Succeeded == true) {
        this._isShowLoader = false;
        this._lstgetArchivesOutput = res.lstArchivesXIRR;

        for (var i = 0; i < this._lstgetArchivesOutput.length; i++) {
          if (this._lstgetArchivesOutput[i].ArchiveDate != null) {
            this._lstgetArchivesOutput[i].ArchiveDate = new Date(this.utils.convertDateToBindable(this._lstgetArchivesOutput[i].ArchiveDate));
          }
        }

        this._cvarchivesOutputlist = new wjcCore.CollectionView(this._lstgetArchivesOutput);
        this._cvarchivesOutputlist.trackChanges = true;
        this.Archivesflex.invalidate();
      }
      else {
        this._isShowLoader = false;
        var data = null;
        this._cvarchivesOutputlist = new wjcCore.CollectionView(this._lstgetArchivesOutput);
        this._cvarchivesOutputlist.trackChanges = true;
        this.Archivesflex.invalidate();
      }
    });
  }


  XIRRDownload(XIRRConfigID: any): void {
    var _lstXIRRConfigSelected;
    if (XIRRConfigID) {
      _lstXIRRConfigSelected = this._lstXIRRConfig.filter(x => x.XIRRConfigID == XIRRConfigID);
    } else {
      _lstXIRRConfigSelected = this._lstXIRRConfig.filter(x => x.IsActive == true && x.XIRRConfigID !== undefined && x.XIRRConfigID > 0)
    }
    if (_lstXIRRConfigSelected != null && _lstXIRRConfigSelected.length > 0) {
      this._isShowLoader = true;
      this.DownloadXIRROutputFiles(_lstXIRRConfigSelected);
    }

    else {
      this.CustomAlert('Please select the Return to download output.');
    }

  }

  XIRRMultiDownload(XIRRConfigID: any): void {
    var _lstXIRRConfigSelected;
    if (XIRRConfigID) {
      _lstXIRRConfigSelected = this._lstXIRRConfig.filter(x => x.XIRRConfigID == XIRRConfigID);
    } else {
      _lstXIRRConfigSelected = this._lstXIRRConfig.filter(x => x.IsActive == true && x.XIRRConfigID !== undefined && x.XIRRConfigID > 0)
    }
    if (_lstXIRRConfigSelected != null && _lstXIRRConfigSelected.length > 0) {
      this._isShowLoader = true;
      this.DownloadXIRROutputFiles(_lstXIRRConfigSelected);
    }

    else {
      this.CustomAlert('Please select the Return to download output.');
    }

  }


  // dialog code end


  XIRRDownloadFileArchive(objxirrconfig, filename): void {
    this.xirrSrv.downloadxirrreturnarchive(objxirrconfig)
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
        dwldLink.setAttribute("download", filename);
        dwldLink.style.visibility = "hidden";
        document.body.appendChild(dwldLink);
        dwldLink.click();
        document.body.removeChild(dwldLink);
        this._isxirrListFetching = false;
      },
        error => {
          //alert('Something went wrong');
          this._isxirrListFetching = false;
        }
      );

  }

  XIRRDownloadFile(objxirrconfig, filename): void {
    this.xirrSrv.downloxirrreturn(objxirrconfig)
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
        dwldLink.setAttribute("download", filename);
        dwldLink.style.visibility = "hidden";
        document.body.appendChild(dwldLink);
        dwldLink.click();
        document.body.removeChild(dwldLink);
        this._isxirrListFetching = false;
      },
        error => {
          //alert('Something went wrong');
          this._isxirrListFetching = false;
        }
      );

  }

  ShowAttributesDialog() {
    var archiveDate = new Date();
    var lastDateOfMonth = new Date(archiveDate.getFullYear(), archiveDate.getMonth() + 1, 0);
    if (archiveDate != lastDateOfMonth) {
      //get previous month last date
      archiveDate = new Date(archiveDate.getFullYear(), archiveDate.getMonth(), 0);
    }
    this.archiveInputDate = archiveDate;
    //this.ReportGuid = attributeValue;
    //$("#txtDefaultAttribute").val(reportname);
    $("#spnHeader").text('');
    this.archiveComments = "";
    var modal = document.getElementById('ModalXIRRArchive');
    modal.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }

  ShowAttributesDialogforDealXIRRArchive(cuttoffDate) {
    var archiveDate = new Date(cuttoffDate);

    this.archiveInputDate = archiveDate;

    $("#spnHeader").text('');
    this.archiveComments = "";
    var modal = document.getElementById('ModalXIRRArchiveDealLevelXIRR');
    modal.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }

  ShowArchiveDateValidationDialog() {
    var modal = document.getElementById('ModalArchiveDateValidate');
    modal.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }
  ShowDealLevelXIRRArchiveDateValidationDialog() {
    var modal = document.getElementById('ModalDealLevelXIRRArchiveDateValidate');
    modal.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }

  ClosePopUpReportFileAttribute() {
    var modal = document.getElementById('ModalXIRRArchive');
    $('#txtDefaultAttribute').val('');
    modal.style.display = "none";
  }

  ClosePopUp() {
    var modal = document.getElementById('ModalXIRRArchiveDealLevelXIRR');
    $('#txtDefaultAttribute').val('');
    modal.style.display = "none";
  }
  ClosePopUpArchiveDateValidate() {
    var modal = document.getElementById('ModalArchiveDateValidate');
    $('#txtDefaultAttribute').val('');
    modal.style.display = "none";
  }
  ClosePopUpDealLevelArchiveDateValidate() {
    var modal = document.getElementById('ModalDealLevelXIRRArchiveDateValidate');
    $('#txtDefaultAttribute').val('');
    modal.style.display = "none";
  }

  ValidateXIRRArchive() {
    var _lstXIRRConfigSelected = this._lstXIRRConfig.filter((x: any) => x.IsActive == true);

    if (_lstXIRRConfigSelected != null && _lstXIRRConfigSelected.length > 0) {
      this.ShowAttributesDialog();
    }
    else {
      this.CustomAlert('Please select the Return to archive.');
    }

  }

  ValidateArchiveDate() {
    var _lstXIRRConfigSelected = this._lstXIRRConfig.filter((x: any) => x.IsActive == true);

    let ids = _lstXIRRConfigSelected.map(x => x.XIRRConfigID);

    var archiveAlreadyExists = this._lstgetArchivesOutput.filter(x => {
      return new Date(x.ArchiveDate).getDate() == this.archiveInputDate.getDate()
        && x.XIRRConfigID == ids
    });

    if (archiveAlreadyExists && archiveAlreadyExists.length > 0) {
      this.ClosePopUpReportFileAttribute();
      this.ShowArchiveDateValidationDialog();
    }
    else {
      this.XIRRArchive();
    }
  }

  ValidateArchiveDateDealLevelXIRR() {

    var archiveAlreadyExists = this._lstgetArchivesOutput.filter(x => {
      return new Date(x.ArchiveDate).getDate() == this.archiveInputDate.getDate()
        && x.XIRRConfigID == this.selectedxirrconfigid
    });

    if (archiveAlreadyExists && archiveAlreadyExists.length > 0) {
      this.ClosePopUp();
      this.ShowDealLevelXIRRArchiveDateValidationDialog();
    }
    else {
      this.XIRRArchivefromDealLevelXIRR();
    }
  }

  XIRRDownloadArchive(filename, type): void {

    var custfilename = filename.substr(0, filename.lastIndexOf("_")) + ".xlsx";
    var storageLocation = '';
    if (filename != '' && filename != undefined) {
      this._isShowLoader = true;
      if (type == 'input')
        storageLocation = 'XIRRInputArchive';
      else if (type == 'output') {
        storageLocation = 'XIRROutputArchive';
      }

      this.DownloadDocumentWithCustomFileName(filename, custfilename, 392, storageLocation);
    }
    else {
      this.CustomAlert("No files to download");
    }
  }

  CustomAlert(dialog: any): void {
    var winW = window.innerWidth;
    var winH = window.innerHeight;
    var dialogoverlay: any = document.getElementById('dialogoverlay');
    var dialogbox: any = document.getElementById('dialogbox');
    dialogoverlay.style.display = "block";
    dialogoverlay.style.height = winH + "px";
    dialogbox.style.left = (winW / 2) - (550 * .5) + "px";
    dialogbox.style.top = "100px";
    dialogbox.style.display = "block";
    var dialogboxhead: any = document.getElementById('dialogboxhead');
    var doalogboxbody: any = document.getElementById('dialogboxbody');
    dialogboxhead.innerHTML = "CRES - Validation Error";
    doalogboxbody.innerHTML = dialog;
    //document.getElementById('dialogboxfoot').innerHTML = '<span class="custombutton" onclientclick="this.ok()">OK</span>';
  }

  ok(): void {
    var dialogoverlay: any = document.getElementById('dialogoverlay');
    var dialogbox: any = document.getElementById('dialogbox');
    dialogoverlay.style.display = "none";
    dialogbox.style.display = "none";
  }

  SelectAll() {
    this._chkSelectAll = !this._chkSelectAll;

    for (var i = 0; i < this.XIRRflex.rows.length; i++) {
      this.XIRRflex.rows[i].dataItem.IsActive = this._chkSelectAll;
    }
    this.XIRRflex.invalidate();

  }


  GetViewAttachedNotes(TagMasterXIRRID) {
    this._isShowLoader = true;
    this.xirrSrv.GetViewAttachedNotes(TagMasterXIRRID).subscribe(res => {
      if (res.Succeeded) {

        this.lstTagsViewNotes = res.dt;
        this.AttachedNotesCount = res.RowCount;

        if (this.lstTagsViewNotes) {
          var modaltrans = document.getElementById('myModalXIRRTagsViewNotes');
          modaltrans.style.display = "block";
          $.getScript("/js/jsDrag.js");

        } else {

        }
        setTimeout(function () {
          this._isShowLoader = false;
        }.bind(this), 500);
      }
    });
  }

  CloseXIRRViewNotes() {
    var modal = document.getElementById('myModalXIRRTagsViewNotes');
    modal.style.display = "none";

  }

  showDeleteOption: boolean = false;

  onContextMenu(grid, e) {
    var hti = grid.hitTest(e);
    if (hti.panel && hti.panel === grid.cells && hti.panel.columns[hti.col].binding === "ReturnName") {
      var returnName = grid.getCellData(hti.row, hti.col, false);
      var rolename = window.localStorage.getItem("rolename");

      if (rolename != null) {
        if (rolename.toString() == "Super Admin") {
          this.showDeleteOption = true;
        }
      }
      const config = this._lstXIRRConfig.find(item => item.ReturnName === returnName);
      if (config) {
        this.showDeleteOption = config.isAllowDelete;
      }

      this.ctxMenu.dropDownCssClass = 'ctx-menu'
      this.ctxMenu.show(e);
      this.hti = hti;
    }
    else {
      this.ctxMenu.hide();
    }
  }

  onContextAggregateMenu(grid, e) {
    var hti = grid.hitTest(e);
    if (hti.panel && hti.panel === grid.cells && hti.panel.columns[hti.col].index > 1) {

      var { row: clickedRow, col: clickedCol } = hti;
      this._ClckXIRRCol = clickedCol;
      this._ClckXIRRRow = clickedRow;
      var cellValue = this.XIRROutputPortfoli[clickedRow][hti.grid._cols[clickedCol].binding];

      if (cellValue != null && cellValue != '' && cellValue != undefined) {
        this.Aggregatecolumnhdr = hti.panel.columns[hti.col]._hdr;
        this.ctxAggreMenu.dropDownCssClass = 'ctx-menu'
        this.ctxAggreMenu.show(e);
        this.hti = hti;
      }
      else
        this.ctxAggreMenu.hide()
    }
    else {
      this.ctxAggreMenu.hide();
    }
  }

  menuItemClicked(s, e) {
    var { row: selectedRow, col: selectedCol } = this.XIRRflex.selection;
    var { row: clickedRow, col: clickedCol } = this.hti;
    this._ClckXIRRCol = clickedCol;
    this._ClckXIRRRow = clickedRow;
    var selected = this.hti._row;
    // var returnnam= this.XIRRflex.cells.getCellData(this.hti._row, 1)

    //var selectedxirr = this._lstXIRRConfig[this._ClckXIRRRow];
    //  var selectedxirr = this.XIRRflex.selectedItems[0];
    var selectedxirr = this.XIRRflex.itemsSource.items[this.hti._row]

    if (selectedxirr.RowNumber == null || selectedxirr.RowNumber == 0) {
      selectedxirr.RowNumber = this._ClckXIRRRow;
    }
    this.selectedreturnname = selectedxirr.ReturnName;
    if (s.selectedItem._ownerMenu.text == "Configure") {
      //manish
      var notepath = ['/#/xirrConfiguration/a/' + selectedxirr.XIRRConfigGUID];
      window.open(notepath.toString(), '_self', '');
      //this.GetXIRRFilters(selectedxirr.RowNumber, selectedxirr.XIRRConfigID, selectedxirr.ReturnName, selectedxirr.Comments);

    }
    if (s.selectedItem._ownerMenu.text == "View Results") {
      this._isShowLoader = true;
      this._isxirrdealdetail = false;
      this.selectedreturnname = selectedxirr.ReturnName;
      this.GetFilterInformation(selectedxirr.ReturnName, true);
      setTimeout(function () {
        document.getElementById('aXIRRDashboard').click();

      }.bind(this), 500);
    }
    //if (s.selectedItem._ownerMenu.text == "Download Cashflows") {
    //  this.XIRRDownload(selectedxirr.XIRRConfigID);
    //}

    if (s.selectedItem._ownerMenu.text == "Delete") {
      this.showDeleteDialog(this._ClckXIRRRow);
    }
    if (s.selectedItem._ownerMenu.text == "Download Cashflows") {
      this._isShowLoader = true;
      var Newdate = this.utils.convertDateWithoutSlash(new Date())
      var time = new Date();
      Newdate = Newdate + "_" + time.getHours() + time.getMinutes() + time.getSeconds();
      var filename = selectedxirr.ReturnName + '_' + selectedxirr.Type + '_' + selectedxirr.AnalysisName + '_' + Newdate + '.xlsx'
      this.DownloadXIRROutputFile(selectedxirr, filename)
    }
    if (s.selectedItem._ownerMenu.text == "Associated Notes Data") {
      this.GetAssociatedNotesData(selectedxirr.XIRRConfigID, selectedxirr.ReturnName);
    }

  }


  menuAggregateItemClicked(s, e) {
    var { row: selectedRow, col: selectedCol } = this.flexXIRROutput.selection;
    var { row: clickedRow, col: clickedCol } = this.hti;
    this._ClckXIRRCol = clickedCol;
    this._ClckXIRRRow = clickedRow;


    var selectedxirr = this.XIRROutputPortfoli[this._ClckXIRRRow];
    if (selectedxirr.RowNumber == null || selectedxirr.RowNumber == 0) {
      selectedxirr.RowNumber = this._ClckXIRRRow;
    }
    if (s.selectedItem._ownerMenu.text == "Download cashflow") {

      var cellValue = this.XIRROutputPortfoli[this._ClckXIRRRow][this.hti.grid._cols[this._ClckXIRRCol].binding];


      if (cellValue != null && cellValue != '' && cellValue != undefined) {
        if (this._ClckXIRRRow == (this.XIRROutputPortfoli.length - 1) && this.hti.grid._cols[this._ClckXIRRCol].binding == "Total") {
          this.DownloadXIRRInputFromDashboard(selectedxirr.XIRRConfigID, null, null, null, 'Portfolio_OverallTotal');
        }
        else if (this._ClckXIRRRow == (this.XIRROutputPortfoli.length - 1) && this.hti.grid._cols[this._ClckXIRRCol].binding != "Total") {
          this.DownloadXIRRInputFromDashboard(selectedxirr.XIRRConfigID, null, this.Aggregatecolumnhdr, null, 'Portfolio_OverallColumnTotal');
        }

        else if (selectedxirr.LoanStatus == "Total" && this.hti.grid._cols[this._ClckXIRRCol].binding == "Total") {
          this.DownloadXIRRInputFromDashboard(selectedxirr.XIRRConfigID, selectedxirr.G1_Hidden, null, null, 'Portfolio_GroupTotal');
        }
        else if (selectedxirr.LoanStatus == "Total") {
          this.DownloadXIRRInputFromDashboard(selectedxirr.XIRRConfigID, selectedxirr.G1_Hidden, this.Aggregatecolumnhdr, null, 'Portfolio_ColumnTotal');
        }
        else if (this.hti.grid._cols[this._ClckXIRRCol].binding == "Total") {
          this.DownloadXIRRInputFromDashboard(selectedxirr.XIRRConfigID, selectedxirr.G1_Hidden, null, selectedxirr.LoanStatus, 'Portfolio_RowTotal');
        }
        else {
          this.DownloadXIRRInputFromDashboard(selectedxirr.XIRRConfigID, selectedxirr.G1_Hidden, this.Aggregatecolumnhdr, selectedxirr.LoanStatus, null);
        }
      }
    }
    if (s.selectedItem._ownerMenu.text == "View Results") {
      var isvalxirrType = false;
      var cellvalue = this.flexXIRROutput.cells.getCellData(this._ClckXIRRRow, clickedCol, true);
      this.xirrtotal = cellvalue;
      if (selectedxirr.LoanStatus == "Total" && this.hti.grid._cols[this._ClckXIRRCol].binding == "Total") {
        isvalxirrType = true;
      }
      else if (selectedxirr.LoanStatus == "Total") {
        selectedxirr.LoanStatus = null;
      }
      if (selectedxirr.LoanStatus == "Aggregate  Total") {
        selectedxirr.LoanStatus = null;
        selectedxirr.G1_Hidden = null;
      }
      if (this.Aggregatecolumnhdr == "Total") {
        this.Aggregatecolumnhdr = null;
      }

      if (isvalxirrType)
        this.ShowDealLevelDetailData(selectedxirr.XIRRConfigID, selectedxirr.G1_Hidden, null, null, null)
      else
        this.ShowDealLevelDetailData(selectedxirr.XIRRConfigID, selectedxirr.G1_Hidden, this.Aggregatecolumnhdr, selectedxirr.LoanStatus, this.xirrType)
      this.showdiv();
    }
  }

  GetFilterInformation(returnname, callgetdata) {
    this._isshowpoolinfo = true;
    this._isshowstate = true;
    this._isshowptype = true;
    this._isshowdtype = true;
    this._isshowdLoanStatus = true;
    this._isshowdMSA = true;
    this._isshowdVintageYear = true;

    this._isnodealxirrfound = false;
    this._isshowxirrinfodiv = true;
    var currentconfig = this._lstXIRRConfig.find(x => x.ReturnName == returnname);

    if (currentconfig !== undefined && currentconfig != null) {
      this.selectedreturnname = returnname;
      this.selectedReturnType = currentconfig.Type;

      this.selectedscenrio = currentconfig.AnalysisName;
      if (currentconfig.UpdatedDate !== undefined && currentconfig.UpdatedDate !== null) {
        this.LastCalculated = this.utils.convertDateToBindableWithTime(currentconfig.UpdatedDate);
      }
      this.calcstatus = currentconfig.Status;
      this.selectedxirrreturnName = returnname;

      this.xirrType = this.selectedReturnType;

      if (this.selectedReturnType == "Deal") {
        this._isxirrdealdetail = true;
        this.isshowportfoliodata = false;
      }
      else {
        this._isxirrdealdetail = false;
        this.isshowportfoliodata = true;
      }
      this.selectedxirrconfigid = currentconfig.XIRRConfigID;
      if (callgetdata == true) {
        this.GetXIRROutputPortfolioLevel();
      }

      var poolselected = "";
      var poolids = this.lstXIRRFilters.filter(x => x.XIRRFilterSetupID == 1 && x.XIRRConfigID == currentconfig.XIRRConfigID).map(x => x.FilterDropDownValue);
      this.lstPool.forEach((objparent, i) => {
        var currentval = objparent.LookupID;
        poolids.forEach((obj, j) => {
          if (currentval == obj) {
            poolselected = poolselected + objparent.Name + ",";

          }
        });
      });
      this.selectedPool = this.utils.SubstringFromLast(poolselected);

      var ProductTypeselected = "";
      var ProductTypeids = this.lstXIRRFilters.filter(x => x.XIRRFilterSetupID == 2 && x.XIRRConfigID == currentconfig.XIRRConfigID).map(x => x.FilterDropDownValue);
      this.lstProductType.forEach((objparent, i) => {
        var currentval = objparent.LookupID;
        ProductTypeids.forEach((obj, j) => {
          if (currentval == obj) {
            ProductTypeselected = ProductTypeselected + objparent.Name + ",";
          }
        });
      });

      var Stateselected = "";
      var Stateids = this.lstXIRRFilters.filter(x => x.XIRRFilterSetupID == 3 && x.XIRRConfigID == currentconfig.XIRRConfigID).map(x => x.FilterDropDownValue);

      this.lstState.forEach((objparent, i) => {
        var currentval = objparent.LookupID;
        Stateids.forEach((obj, j) => {
          if (currentval == obj) {
            Stateselected = Stateselected + objparent.Name + ",";
          }
        });
      });

      var DealTypeselected = "";
      var DealTypeids = this.lstXIRRFilters.filter(x => x.XIRRFilterSetupID == 4 && x.XIRRConfigID == currentconfig.XIRRConfigID).map(x => x.FilterDropDownValue);

      this.lstDealType.forEach((objparent, i) => {
        var currentval = objparent.LookupID;
        DealTypeids.forEach((obj, j) => {
          if (currentval == obj) {
            DealTypeselected = DealTypeselected + objparent.Name + ",";
          }
        });
      });

      //---- new code
      var LoanStatuselected = "";
      var LoanStatusids = this.lstXIRRFilters.filter(x => x.XIRRFilterSetupID == 5 && x.XIRRConfigID == currentconfig.XIRRConfigID).map(x => x.FilterDropDownValue);

      this.lstLoanStatus.forEach((objparent, i) => {
        var currentval = objparent.LookupID;
        LoanStatusids.forEach((obj, j) => {
          if (currentval == obj) {
            LoanStatuselected = LoanStatuselected + objparent.Name + ",";
          }
        });
      });
      var MSAselected = "";
      var MSAids = this.lstXIRRFilters.filter(x => x.XIRRFilterSetupID == 6 && x.XIRRConfigID == currentconfig.XIRRConfigID).map(x => x.FilterDropDownValue);
      this.lstMSA.forEach((objparent, i) => {
        var currentval = objparent.LookupID;
        MSAids.forEach((obj, j) => {
          if (currentval == obj) {
            MSAselected = MSAselected + objparent.Name + ",";
          }
        });
      });

      var VintageYearselected = "";
      var VintageYearids = this.lstXIRRFilters.filter(x => x.XIRRFilterSetupID == 7 && x.XIRRConfigID == currentconfig.XIRRConfigID).map(x => x.FilterDropDownValue);
      this.lstVintageYear = this.lstXIRRFiltersLookup.filter(x => x.Type == "VintageYear");
      this.lstVintageYear.forEach((objparent, i) => {
        var currentval = objparent.LookupID;
        VintageYearids.forEach((obj, j) => {
          if (currentval == obj) {
            VintageYearselected = VintageYearselected + objparent.Name + ",";
          }
        });
      });


      this.selectedProductType = this.utils.SubstringFromLast(ProductTypeselected);
      this.selectedState = this.utils.SubstringFromLast(Stateselected);
      this.selectedDelType = this.utils.SubstringFromLast(DealTypeselected);

      this.selectedLoanStatus = this.utils.SubstringFromLast(LoanStatuselected);
      this.selectedMSA = this.utils.SubstringFromLast(MSAselected);
      this.selectedVintageYear = this.utils.SubstringFromLast(VintageYearselected);



      if (this.selectedProductType == "") {
        this._isshowptype = false;
      }
      if (this.selectedState == "") {
        this._isshowstate = false;
      }
      if (this.selectedDelType == "") {
        this._isshowdtype = false;
      }
      if (this.selectedPool == "") {
        this._isshowpoolinfo = false;
      }

      if (this.selectedLoanStatus == "") {
        this._isshowdLoanStatus = false;
      }
      if (this.selectedMSA == "") {
        this._isshowdMSA = false;
      }
      if (this.selectedVintageYear == "") {
        this._isshowdVintageYear = false;
      }

    }

    this._isxirrListFetching = false;

  }

  ShowDealLevelDetailData(XIRRConfigID, GValue1, GValue2, LoanStatus, Type): void {
    this._isxirrListFetching = true;
    this.lstjsonparameters = [];
    this.lstjsonparameters.push({ 'XIRRConfigID': XIRRConfigID, 'GValue1': GValue1, 'GValue2': GValue2, 'LoanStatus': LoanStatus, 'Type': Type });
    this.xirrSrv.GetXIRROutputDealLevelFromXirrDashBoard(this.lstjsonparameters).subscribe(res => {
      if (res.Succeeded) {
        if (Type == "Deal") {
          this._isxirrdealdetail = true;
        }
        this.ListDealLevelinfo = res.dt;

        setTimeout(() => {
          this.DealIDheader = 'Deal ID (' + this.ListDealLevelinfo.length + ')';
          this.flexDealLevelinfo.columns[0].header = this.DealIDheader;
          this.addFooterRowCustom(this.flexDealLevelinfo);
          if (this.ListDealLevelinfo.length > 0) {
            if (this.ListDealLevelinfo[0].CutoffDateOverride !== undefined
              && this.ListDealLevelinfo[0].CutoffDateOverride !== null) {
              this._xirrConfig.CutoffDateOverride = new Date(this.utils.convertDateToBindable(this.ListDealLevelinfo[0].CutoffDateOverride));
              this.CutoffDateOverrideFormatted = this.utils.convertDateToBindable(this.ListDealLevelinfo[0].CutoffDateOverride);

            }
          }
        }, 500);

        for (var i = 0; i < this.ListDealLevelinfo.length; i++) {
          if (this.ListDealLevelinfo[i].ClosingDate != null) {
            this.ListDealLevelinfo[i].ClosingDate = new Date(this.utils.convertDateToBindable(this.ListDealLevelinfo[i].ClosingDate));
          }

          if (this.ListDealLevelinfo[i].Maturity != null) {
            this.ListDealLevelinfo[i].Maturity = new Date(this.utils.convertDateToBindable(this.ListDealLevelinfo[i].Maturity));
          }
        }
        if (this.ListDealLevelinfo) {
          if (this.ListDealLevelinfo.length == 0) {
            this.ShowNoDataControls();
          }

        }

        this.showhideDownloadCashflowButton();
        this._isxirrListFetching = false;
        this._isShowLoader = false;

      }
      else {
        this._isxirrListFetching = false;
        this._ShowErrorMessage = "Error occurred while loading Deal level info. Please contact administrator..";
        this._dvEmptyDealSearchMsg = true;
        setTimeout(() => {
          this._dvEmptyDealSearchMsg = false;
          this._isShowLoader = false;
        }, 5000);

      }

    });

  }

  GetExportExcelXIRROutputDealLevel(): void {

    this._isxirrListFetching = true;
    var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '');
    var displayTime = new Date().getTime();
    var fileName = this.selectedreturnname + "_Deal_Level_XIRR_" + displayDate + "_" + displayTime + ".xlsx";


    this.xirrSrv.GetExportExcelXIRROutputDealLevelFromXirrDashBoard(this.lstjsonparameters).subscribe(res => {
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
      this._isxirrListFetching = false;
    });

  }

  showDeleteDialog(deleteRowIndex: number) {
    this.xirrdeleteRowIndex = deleteRowIndex;
    var modalDelete = document.getElementById('myModalDelete');

    modalDelete.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }

  CloseDeletePopUp() {
    var modal = document.getElementById('myModalDelete');
    modal.style.display = "none";
  }

  TagMasterXIRRValidation() {
    var errtagsXIRR = "";
    var errortags = "";
    var emptytagname = "";
    this._isShowLoader = true;
    if (this.listtagmasterXIRRlist) {
      //check duplicate name
      for (var k = 0; k < this.listtagmasterXIRRlist.length - 1; k++) {
        for (var m = k + 1; m < this.listtagmasterXIRRlist.length; m++) {
          if (this.listtagmasterXIRRlist[k].Name == this.listtagmasterXIRRlist[m].Name) {
            errtagsXIRR = errtagsXIRR + "<p>" + "Tag name can not be same." + "</p>";
            this.transactionerror = true;
          }

        }
        if (errtagsXIRR != "") {
          break;
        }
      }
      //Tag name can not be blank
      for (var k = 0; k < this.listtagmasterXIRRlist.length; k++) {
        if (this.listtagmasterXIRRlist[k].Name.trim() == "") {
          emptytagname = "<p>" + "Tag name can not be blank." + "</p>";
          this.transactionerror = true;
          break;
        }
      }

      if (emptytagname != "") {
        errtagsXIRR = errtagsXIRR + emptytagname;
      }
      if (errortags != "" || errtagsXIRR != "") {
        this.CustomAlert(errtagsXIRR);
        this._isShowLoader = false;
      }
      else {
        this.saveTagMasterXIRR();
      }
    }
  }

  getNoteTags() {
    this._isShowLoader = true;
    this.xirrSrv.GetAllNoteTagsXIRR().subscribe(res => {
      if (res.Succeeded == true) {
        this._isShowLoader = false;
        var data = res.dt;
        this.listtagmasterXIRRlist = data;

        this._tagmasterXIRRlist = new wjcCore.CollectionView(data);
        this._tagmasterXIRRlist.trackChanges = true;

        this.TagMasterXIRRflex.invalidate();
      }
      else {
        this._isShowLoader = false;
        var data = null;
        this._tagmasterXIRRlist = new wjcCore.CollectionView(this.listtagmasterXIRRlist);
        this._tagmasterXIRRlist.trackChanges = true;
        this.TagMasterXIRRflex.invalidate();
      }
    });
  }

  saveTagMasterXIRR() {
    var dtlistTagMasterXIRR = [];
    for (var k = 0; k < this.listtagmasterXIRRlist.length; k++) {
      dtlistTagMasterXIRR.push({
        "TagMasterXIRRID": (!this.listtagmasterXIRRlist[k].TagMasterXIRRID) ? 0 : this.listtagmasterXIRRlist[k].TagMasterXIRRID,
        "Name": this.listtagmasterXIRRlist[k].Name
      });
    }
    this.xirrSrv.SaveNoteTagsXIRR(dtlistTagMasterXIRR).subscribe(res => {
      if (res.Succeeded) {
        this.GetAllTagNameXIRR();
        this._isShowLoader = false;
        this._ShowSuccessmessage = "Tags updated successfully.";
        this._ShowSuccessmessagediv = true;
        this.getNoteTags();
        setTimeout(() => {
          this._ShowSuccessmessagediv = false;
        }, 5000);
      }
      else {
        this._isShowLoader = false;
        this._ShowErrorMessage = "Something went wrong.Please try after some time.";
        this._dvEmptyDealSearchMsg = true;
        setTimeout(() => {
          this._dvEmptyDealSearchMsg = false;
        }, 5000);
      }
    });

  }

  showNoteTagDeleteDialog(Name: string, ID: number, deleteRowIndex: number) {
    this.deleteRowIndex = deleteRowIndex;
    this._delTagMasterXIRRId = ID;
    var modaltrans: any = document.getElementById('customboxTags');
    modaltrans.style.display = "block";
    this._MsgText = 'Are you sure you want to delete the ' + Name.toLowerCase() + '?';
    $.getScript("/js/jsDrag.js");
  }
  CloseNoteTagPopUp() {
    var modal: any = document.getElementById('customboxTags');
    modal.style.display = "none";
  }
  deleteNoteTags() {
    this._isShowLoader = true;
    this.CloseNoteTagPopUp();
    this._tagmasterXIRRlist.removeAt(this.deleteRowIndex);
    this.xirrSrv.deleteNoteTags(this._delTagMasterXIRRId).subscribe(res => {
      if (res.Succeeded) {
        this._isShowLoader = false;
        this._ShowSuccessmessage = "Tags deleted successfully.";
        this._ShowSuccessmessagediv = true;
        setTimeout(() => {
          this._ShowSuccessmessagediv = false;
        }, 5000);
      }
      else {
        this._isShowLoader = false;
        this._ShowErrorMessage = "Something went wrong.Please try after some time.";
        this._dvEmptyDealSearchMsg = true;
        setTimeout(() => {
          this._dvEmptyDealSearchMsg = false;
        }, 5000);
      }
    });
  }
  //tage master code end

  deletexirrRow() {
    this._isShowLoader = true;
    var selectedxirr = this._lstXIRRConfig[this._ClckXIRRRow];
    // this.deletedxirrConfig.push(selectedxirr.XIRRConfigID);

    this.xirrSrv.DeleteXIRRByXIRRConfigID(selectedxirr.XIRRConfigID).subscribe(res => {
      if (res.Succeeded) {
        this._isShowLoader = false;
        this._ShowSuccessmessage = "XIRR deleted successfully.";
        this._ShowSuccessmessagediv = true;
        setTimeout(() => {
          this._ShowSuccessmessagediv = false;
        }, 5000);
      } else {
        this._isShowLoader = false;
        this._ShowErrorMessage = "Error occurred while deleting XIRR.Please contact administrator";
        this._dvEmptyDealSearchMsg = true;
        setTimeout(() => {
          this._dvEmptyDealSearchMsg = false;
        }, 5000);
      }
    })

    this._cvXIRRConfiglist.removeAt(this.xirrdeleteRowIndex);
    this.CloseDeletePopUp();
  }


  HideNonSuperAdminUser(): boolean {
    var ret_val = false;
    var rolename = window.localStorage.getItem("rolename");
    // rolename = 'Admin';
    if (rolename != null) {
      if (rolename.toString() == "Super Admin") {
        ret_val = true;
      }
    }
    return ret_val
  }

  AddcolumnXIRRAggregate(header, binding) {
    try {
      this.columns.push({ "header": header, "binding": binding, "format": 'n2', "width": 185 })
    } catch (err) { }
  }

  GetXIRROutputPortfolioLevel() {
    this._isxirrListFetching = true;
    this._isshowportreturnname = false;
    this._isshowDealreturnname = false;
    this._isshownoresultfound = false;
    this.GetFilterInformation(this.selectedxirrreturnName, false);

    this._isxirrdealdetail = false;
    this.isshowportfoliodata = false;

    if (this.xirrType == "Deal") {
      this.ShowDealLevelDetailData(this.selectedxirrconfigid, null, null, null, this.xirrType);
      this._isshowportreturnname = false;
      this._isshowDealreturnname = true;
    } else {
      if (this.selectedxirrconfigid != "") {
        var header = [];

        this.xirrSrv.GetXIRROutputPortfolioLevel(this.selectedxirrconfigid).subscribe(res => {
          if (res.Succeeded) {
            this._isshowportreturnname = true;
            this._isshowDealreturnname = false;
            this.isshowportfoliodata = true;
            this.columnsXIRR = [];
            this.XIRROutputPortfoli = res.dt;
            var data = res.dt;
            if (this.XIRROutputPortfoli.length > 0) {
              $.each(data, function (obj) {
                var i = 0;
                $.each(data[obj], function (key) {
                  header[i] = key;
                  i = i + 1;
                })
                return false;
              });

              for (var j = 0; j < header.length; j++) {
                if (header[j] != "XIRRConfigID" && header[j] != "ReturnName" && header[j] != "Y_Axis" && header[j] != "LoanStatus" && header[j] != "G1_Hidden") {
                  this.AddcolumnXIRRAggregate(header[j], header[j]);
                  this.columnsXIRR.push(header[j]);
                }
              }
              for (var j = 0; j < this.XIRROutputPortfoli.length; j++) {
                if (j + 1 < this.XIRROutputPortfoli.length) {
                  if (this.XIRROutputPortfoli[j].Y_Axis == this.XIRROutputPortfoli[j + 1].Y_Axis) {
                    this.XIRROutputPortfoli[j + 1].Y_Axis = '';

                  }
                }
                if (j + 2 < this.XIRROutputPortfoli.length) {
                  if (this.XIRROutputPortfoli[j].Y_Axis == this.XIRROutputPortfoli[j + 2].Y_Axis) {
                    this.XIRROutputPortfoli[j + 2].Y_Axis = '';
                  }
                }
                if (this.XIRROutputPortfoli[j].Y_Axis == 'OverallTotal') {
                  this.XIRROutputPortfoli[j].Y_Axis = '';
                }
                if (this.XIRROutputPortfoli[j].LoanStatus == 'ColumnTotal') {
                  this.XIRROutputPortfoli[j].LoanStatus = 'Total';
                }
                if (this.XIRROutputPortfoli[j].LoanStatus == 'OverallTotal') {
                  this.XIRROutputPortfoli[j].LoanStatus = 'Aggregate  Total';
                }
              }
              setTimeout(() => {
                this.FormatGridRow();
              }, 100);

            } else
            {
              //no data for portfolio
              this._isshownoresultfound = true;
              this._isshowxirrinfodiv = true;
              this._isxirrListFetching = false;
              this.isshowportfoliodata = false;
            }
            this._isxirrListFetching = false;
            this._isShowLoader = false;
            this.showhideDownloadCashflowButton();
          } else {
            this._ShowErrorMessage = "Error occurred while loading results for return " + this.selectedxirrreturnName + ".Please search for different return name.";
            this._dvEmptyDealSearchMsg = true;
            setTimeout(() => {
              this._dvEmptyDealSearchMsg = false;
            }, 5000);
            this._isxirrListFetching = false;
          }
        });
      } else {
        //no data
        this._isshownoresultfound = true;
        this._isshowxirrinfodiv = false;
        this._isxirrListFetching = false;
      }
    }
  }


  XIRRaddFooterRow(flexGrid) { //: wjcGrid.FlexGrid
    if (this.flexXIRROutput.columnFooters.rows.length == 0) {
      this.flexXIRROutput.columnFooters.rows.push(new wjcGrid.GroupRow());
      this.flexXIRROutput.columnFooters.rows.defaultSize = 120;
    }
  }

  FormatGridRow() {
    var theGrid = this.flexXIRROutput;
    for (var i = 0; i < theGrid.rows.length; i++) {
      var row = theGrid.rows[i];
      var item = row.dataItem;
      if (item.LoanStatus == "Total") {
        row.cssClass = 'gridrowboldTotal';
      } else if (item.LoanStatus == "Aggregate  Total") {
        row.cssClass = 'gridrowboldBlue';
      }
    }

    var lastcolname = theGrid.columns[theGrid.columns.length - 1]._binding._key;
    if (lastcolname == "Total") {
      theGrid.columns[theGrid.columns.length - 1].cssClass = "gridboldTotal"
    }

  }
  sortByY_Axis(a, b) {
    var textA = a.Y_Axis.toUpperCase();
    var textB = b.Y_Axis.toUpperCase();
    return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
  }

  checkDroppedDownChangedUserName(sender: wjNg2Input.WjMultiAutoComplete, args: any) {
    this.selectedxirrconfigid = sender.selectedItem.XIRRConfigID;
    this.selectedxirrreturnName = sender.selectedItem.ReturnName;
    this.xirrType = sender.selectedItem.Type;

  }
  ClientChange(newvalue, e): void {
    this.selectedxirrconfigid = newvalue;
    this.selectedxirrreturnName = e.target.selectedOptions[0].text;
    var filerres = this._lstXIRRConfig.filter(x => x.ReturnName == "Xirr_Whole_Loan");
    if (filerres !== undefined && filerres !== null) {
      this.xirrType = filerres[0].Type;
    }
  }
  DownloadDocument(filename, storagetypeID, storageLocation) {
    var ID = filename;
    this.xirrSrv.downloadObjectDocumentByStorageTypeAndLocation(ID, storagetypeID, storageLocation)
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
        dwldLink.setAttribute("download", filename);
        dwldLink.style.visibility = "hidden";
        document.body.appendChild(dwldLink);
        dwldLink.click();
        document.body.removeChild(dwldLink);
        this._isShowLoader = false;
      },
        error => {
          //    alert('Something went wrong');

        }
      );
  }

  DownloadDocumentWithCustomFileName(filename, displayFileName, storagetypeID, storageLocation) {

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

    this.xirrSrv.downloadObjectDocumentByStorageTypeAndLocation(ID, storagetypeID, storageLocation)
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
        dwldLink.setAttribute("download", displayFileName);
        dwldLink.style.visibility = "hidden";
        document.body.appendChild(dwldLink);
        dwldLink.click();
        document.body.removeChild(dwldLink);
        this._isShowLoader = false;
      },
        error => {
          //    alert('Something went wrong');

        }
      );
  }

  DownloadXIRRInpuOutputFiles(inputfile, outputfile) {
    this.DownloadDocument(inputfile, 392, "XIRRInput");
    this.DownloadDocument(outputfile, 392, "XIRROutput");
  }

  showhideDownloadCashflowButton() {

    if (this.XIRROutputPortfoli != null && this.XIRROutputPortfoli.length > 0
      || this.ListDealLevelinfo != null && this.ListDealLevelinfo.length > 0
    ) {
      this._isShownDownloadCashflowButton = true;
    }
    else {
      this._isShownDownloadCashflowButton = false;
      // this.ShowNoDataControls();

    }
  }

  ShowNoDataControls() {
    //case for no data
    var anyvisiable = false;
    this._isShownDownloadCashflowButton = false;

    if (this.XIRROutputPortfoli != null) {
      if (this.XIRROutputPortfoli.length == 0) {
        this.isshowportfoliodata = false;
        anyvisiable = true;
      }
    }

    if (this.ListDealLevelinfo) {
      if (this.ListDealLevelinfo.length == 0) {
        this._isxirrdealdetail = false;
        anyvisiable = true;
        this._isnodealxirrfound = true;
      }
    }

    if (anyvisiable == false) {
      this._isshownoresultfound = true;
      this._isshowxirrinfodiv = false;
    }
  }


  ApplyPermissions(_object): void {
    try {
      this._isShowXIRRSetup = false;
      this._isShowArchive = false;
      this._isShownoteTags = false;

      for (var i = 0; i < _object.length; i++) {
        if (_object[i].ChildModule == 'XIRR_DashBoard') {
          this._isShowXIRRDashboard = true;
        }

        if (_object[i].ChildModule == 'XIRR_Setup') {
          this._isShowXIRRSetup = true;
        }
        if (_object[i].ChildModule == 'XIRR_Archive') {
          this._isShowArchive = true;
        }
        if (_object[i].ChildModule == 'Tags') {
          this._isShownoteTags = true;
        }



      }

    }
    catch (err) {
      //console.log(err);
    }
  }

  GetAssociatedNotesData(configid, returnname): void {
    this._isxirrListFetching = true;

    var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '');
    var displayTime = new Date().getTime();
    var fileName = this.selectedreturnname + "_Associated_Notes_Data_" + displayDate + "_" + displayTime + ".xlsx";

    this.xirrSrv.GetAssociatedNotesDataAPI(configid).subscribe(res => {
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
      this._isxirrListFetching = false;
    });

  }
  //code end


  DownloadXIRROutputFromDashboard() {
    this._isShowLoader = true;
    var configID = this.selectedxirrconfigid;
    var objConfig = this._lstXIRRConfig.filter(x => x.XIRRConfigID == configID);
    var Newdate = this.utils.convertDateWithoutSlash(new Date())
    var time = new Date();
    Newdate = Newdate + "_" + time.getHours() + time.getMinutes() + time.getSeconds();
    var filename = objConfig[0].ReturnName + '_' + objConfig[0].Type + '_' + objConfig[0].AnalysisName + '.xlsx'
    this.DownloadXIRROutputFile(objConfig[0], filename)

  }
  DownloadXIRROutputFiles(lstConfig) {
    this._isShowLoader = true;
    var Newdate = this.utils.convertDateWithoutSlash(new Date())
    var time = new Date();
    Newdate = Newdate + "_" + time.getHours() + time.getMinutes() + time.getSeconds();
    for (var i = 0; i < lstConfig.length; i++) {
      var filename = lstConfig[0].ReturnName + '_' + lstConfig[0].Type + '_' + lstConfig[0].AnalysisName + '_' + Newdate + '.xlsx'
      this.DownloadXIRROutputFile(lstConfig[i], filename);

      if (i == lstConfig.length - 1) {
        this._isShowLoader = false;
      }
    }
  }


  DownloadXIRROutputFile(objConfig, filename) {
    this.xirrSrv.downloadxirroutputfiles(objConfig)
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
        dwldLink.setAttribute("download", filename);
        dwldLink.style.visibility = "hidden";
        document.body.appendChild(dwldLink);
        dwldLink.click();
        document.body.removeChild(dwldLink);
        this._isxirrListFetching = false;
        this._isShowLoader = false;
      },
        error => {


          this._isShowLoader = false;
          this._ShowErrorMessage = "Error occurred while downloading XIRR.Please try with with return name.";
          this._dvEmptyDealSearchMsg = true;


          this._isxirrListFetching = false;
          this._isShowLoader = false;
          setTimeout(() => {
            this._dvEmptyDealSearchMsg = false;
          }, 5000);
        }
      );

  }

  DownloadXIRRInputFromDashboard(XIRRConfigID, Group1, Group2, LoanStatus, Type) {
    this._isShowLoader = true;
    var objGroup = { 'XIRRConfigID': XIRRConfigID, 'Group1': Group1, 'Group2': Group2, 'LoanStatus': LoanStatus, 'Type': Type };
    this.xirrSrv.getfilenameforcashflow(objGroup).subscribe(res => {
      if (res.Succeeded) {
        var filename = res.XIRRReturnGroupDC.FileName_Input;
        var custfilename = res.XIRRReturnGroupDC.FileName_Input;
        custfilename = custfilename.substr(0, custfilename.lastIndexOf("_")) + ".xlsx";
        if (filename != '' && filename != undefined) {
          this.DownloadDocumentWithCustomFileName(filename, custfilename, 392, "XIRRInput");
        }
        else {
          this.CustomAlert("No files to download");
        }
        this._isShowLoader = false;
      }
      else {
        var error = "";
        this._isShowLoader = false;
      }
    });

  }

  DownloadXIRRInputCashflowFromDashboard() {
    this._isShowLoader = true;
    var objConfig = this._lstXIRRConfig.filter(x => x.XIRRConfigID == this.selectedxirrconfigid);
    var filename = objConfig[0].FileNameInput;

    //removed datetime as per rohit's request
    var custfilename = filename.substr(0, filename.lastIndexOf("_")) + ".xlsx";

    if (filename != '' && filename != undefined) {
      this.DownloadDocumentWithCustomFileName(filename, custfilename, 392, "XIRRInput");
    }
    else {
      this.CustomAlert("No files to download");
    }
  }

  UpdateXIRRDealOutputCalculated() {
    this._isShowLoader = true;

    if (this._xirrConfig.CutoffDateOverride != undefined && this._xirrConfig.CutoffDateOverride != null
      && this._xirrConfig.CutoffDateOverride.toString() != "") {
      this._xirrConfig.CutoffDateOverride = this.utils.convertDateToUTC(this._xirrConfig.CutoffDateOverride);
    }

    this.lstjsonparam = [];
    this.lstjsonparam.push({ 'XIRRConfigID': this.selectedxirrconfigid, 'CutoffDateOverride': this._xirrConfig.CutoffDateOverride });
    this.xirrSrv.UpdateXIRRDealOutputCalculated(this.lstjsonparam).subscribe(res => {
      if (res.Succeeded) {
        this._isShowLoader = false;
        this.GetXIRROutputPortfolioLevel();
      }
      else {
        var error = "";
        this._isShowLoader = false;
      }
    });
  }


}
const routes: Routes = [

  { path: '', component: xirrSetupComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjInputModule, WjGridFilterModule],
  declarations: [xirrSetupComponent]
})

export class xirrSetupModule { }
