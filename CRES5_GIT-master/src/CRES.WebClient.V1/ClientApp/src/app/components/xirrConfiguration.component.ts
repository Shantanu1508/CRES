import { Component, ViewChild, Inject } from "@angular/core";
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
import * as wjNg2Input from '@grapecity/wijmo.angular2.input';
import { portfolioService } from '../core/services/portfolio.service'
import { NoteService } from '../core/services/note.service';

import { XIRRService } from '../core/services/xirr.service';
import { XIRRConfigMasterDataContract, XIRRConfig, TTreeItem } from "../core/domain/XIRRConfig.model";
import { PermissionService } from '../core/services/permission.service';

import { MultiSelectListBox, MultiSelect } from '@grapecity/wijmo.input';
import { TreeView } from '@grapecity/wijmo.nav';

import {
  createElement,
  hasClass,
  closestClass,
  closest,
} from '@grapecity/wijmo';


@Component({
  selector: "xirrConfiguration",
  templateUrl: "./xirrConfiguration.html",
  providers: [UtilityService, XIRRService, UtilsFunctions, portfolioService, PermissionService]

})


export class xirrConfigurationcomponent extends Paginated {

  public _xirrConfigMaster: XIRRConfigMasterDataContract;
  public _xirrConfig: XIRRConfig;
  public _ShowSuccessmessage !: string;
  public _ShowSuccessmessagediv: boolean = false;
  public _isShowLoader: boolean = false;

  public divErrorMessage: boolean = false;
  _ShowErrorMessage: any = "";

  _isShowSave: boolean = true;
  _isShowCancel: boolean = true;
  public XIRRConfigGUID: any = "";
  actiontype: any = "";
  ScenarioId: any = "";
  currentconfigid: any = "";
  public _lstArchivalRequirement: any;
  public _lstUpdateXIRRLinkedDeal: any;
  _lstXIRRConfig: any = [];
  lstXIRRFilters: any = [];
  _isShowGrouping: boolean = false;
  SelectedTransactionTypesData: any = [];
  lstPool: any = [];
  lstProductType: any = [];
  lstState: any = [];
  lstDealType: any = [];
  lstMSA: any = [];
  lstLoanStatus: any = [];
  lstVintageYear: any = [];
  lstXIRRFiltersLookup: any = [];
  lstFilterNames: any = [];
  lstReferencingDealLvRetNames: any = [];
  public _lstScenario: any;
  public lstXIRRTags: any = [];
  lstTransactionTypes: any = [];
  dtlistXIRRfilterConfig: any = [];
  xirrConfigList: any = [];
  showAlert: any;
  alert: any;
  public _lstRelativeDate: any;
  _isShowCutoffDateOverride: boolean = false;
  _lstShowReturnonDealScreen: any;

  showFilterInput = false;
  showSelectAllCheckbox = false;
  searchList = [];
  treeView: TreeView = null;

  data: TTreeItem[];
  @ViewChild('ExcludeTransaction') ExcludeTransaction: wjNg2Input.WjMultiSelect
  @ViewChild('Pool') Pool: wjNg2Input.WjMultiSelect
  @ViewChild('ProductType') ProductType: wjNg2Input.WjMultiSelect
  @ViewChild('State') State: wjNg2Input.WjMultiSelect
  @ViewChild('DealType') DealType: wjNg2Input.WjMultiSelect
  @ViewChild('LoanStatus') LoanStatus: wjNg2Input.WjMultiSelect
  @ViewChild('MSA') MSA: wjNg2Input.WjMultiSelect
  @ViewChild('VintageYear') VintageYear: wjNg2Input.WjMultiSelect
  public xirrValidationerror: boolean = false;
  constructor(
    public utils: UtilsFunctions,
    private _router: Router,
    public utilityService: UtilityService,
    public _location: Location,
    private activatedRoute: ActivatedRoute,
    public xirrSrv: XIRRService,
    public notesvc: NoteService,
    public permissionService: PermissionService,
  ) {
    super(50, 1, 0);
    this._xirrConfig = new XIRRConfig();


    this.GetXIRRFiltersDropDown();
    this.GetAllTagNameXIRR();
    this.GetAllLookups();
    this.activatedRoute.params.forEach((params: Params) => {
      if (params['id'] !== undefined) {
        this.XIRRConfigGUID = params['id'];
        if (this.XIRRConfigGUID == "00000000-0000-0000-0000-000000000000") {
          this.actiontype = "new";
        } else {
          this.actiontype = "update";
        }
        setTimeout(() => {
          this.getXIRRConfigByXIRRConfigGUID();
        }, 2000);

      }

    });

  }
  changeScenario(value: any): void {
    this.ScenarioId = value.target.value;
  }
  validator = (date: Date) => {
    return (date <= new Date())
  }
  //code start

  GetAllLookups(): void {
    this.xirrSrv.getAllLookup().subscribe(res => {
      if (res.Succeeded) {
        var data = res.lstLookups;
        this._lstArchivalRequirement = data.filter(x => x.ParentID == "144");
        this._lstUpdateXIRRLinkedDeal = data.filter(x => x.ParentID == "2");
        this._lstScenario = res.lstScenarioUserMap;

        this.lstReferencingDealLvRetNames = res.lstReferencingDealLevelLookup;

        this._lstRelativeDate = data.filter(x => x.ParentID == "145");
        this._lstShowReturnonDealScreen = data.filter(x => x.ParentID == "2");
      }
      else {
        if (res.Message == "Authentication failed") {
          this._router.navigate(['login']);
        }
      }
    });
  }
  GetXIRRFiltersDropDown() {
    this.xirrSrv.GetLookupforXIRRFilters(1).subscribe(res => {
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

  GetAllTagNameXIRR() {
    this.notesvc.GetAllTagsNameXIRR().subscribe(res => {
      if (res.Succeeded) {
        this.lstXIRRTags = res.dt;
      }
    });
  }
  getXIRRConfigByXIRRConfigGUID() {
    this._isShowLoader = true;

    this.xirrSrv.GetXIRRConfigByXIRRConfigGUID(this.XIRRConfigGUID).subscribe(res => {
      if (res.Succeeded == true) {
        //this.ApplyPermissions(res.UserPermissionList);
        this._lstXIRRConfig = res.lstXirrConfig[0];
        this._xirrConfig = res.lstXirrConfig[0];
        this.lstXIRRFilters = res.ListXirrFilters;
        this.currentconfigid = this._lstXIRRConfig.XIRRConfigID;
        this.getTransactionTypes();
        this.AssginValuesToControlonUI();

      }
      else {
        this._isShowLoader = false;


        this._ShowErrorMessage = "Error occurred while loading XIRR Setup. Please contact administrator..";
        this.divErrorMessage = true;
        setTimeout(() => {
          this.divErrorMessage = false;
        }, 5000);

      }

      //this._isShowLoader = false;
    });
    //this.XIRRflex.rows.defaultSize = 40;
  }

  AssginValuesToControlonUI() {
    var poolids = this.lstXIRRFilters.filter(x => x.XIRRFilterSetupID == 1 && x.XIRRConfigID == this.currentconfigid).map(x => x.FilterDropDownValue);
    this.lstPool = this.lstXIRRFiltersLookup.filter(x => x.Type == "Pool");
    this.lstPool.forEach((objparent, i) => {
      var currentval = objparent.LookupID;
      poolids.forEach((obj, j) => {
        if (currentval == obj) {
          this.lstPool[i].active = true;
        }
      });
    });

    var ProductTypeids = this.lstXIRRFilters.filter(x => x.XIRRFilterSetupID == 2 && x.XIRRConfigID == this.currentconfigid).map(x => x.FilterDropDownValue);
    this.lstProductType = this.lstXIRRFiltersLookup.filter(x => x.Type == "ProductType");
    this.lstProductType.forEach((objparent, i) => {
      var currentval = objparent.LookupID;
      ProductTypeids.forEach((obj, j) => {
        if (currentval == obj) {
          this.lstProductType[i].active = true;
        }
      });
    });

    var Stateids = this.lstXIRRFilters.filter(x => x.XIRRFilterSetupID == 3 && x.XIRRConfigID == this.currentconfigid).map(x => x.FilterDropDownValue);
    this.lstState = this.lstXIRRFiltersLookup.filter(x => x.Type == "State");
    this.lstState.forEach((objparent, i) => {
      var currentval = objparent.LookupID;
      Stateids.forEach((obj, j) => {
        if (currentval == obj) {
          this.lstState[i].active = true;
        }
      });
    });

    var DealTypeids = this.lstXIRRFilters.filter(x => x.XIRRFilterSetupID == 4 && x.XIRRConfigID == this.currentconfigid).map(x => x.FilterDropDownValue);
    this.lstDealType = this.lstXIRRFiltersLookup.filter(x => x.Type == "DealType");
    this.lstDealType.forEach((objparent, i) => {
      var currentval = objparent.LookupID;
      DealTypeids.forEach((obj, j) => {
        if (currentval == obj) {
          this.lstDealType[i].active = true;
        }
      });
    });

    var LoanStatusids = this.lstXIRRFilters.filter(x => x.XIRRFilterSetupID == 5 && x.XIRRConfigID == this.currentconfigid).map(x => x.FilterDropDownValue);
    this.lstLoanStatus = this.lstXIRRFiltersLookup.filter(x => x.Type == "LoanStatus");
    this.lstLoanStatus.forEach((objparent, i) => {
      var currentval = objparent.LookupID;
      LoanStatusids.forEach((obj, j) => {
        if (currentval == obj) {
          this.lstLoanStatus[i].active = true;
        }
      });
    });

    var MSAids = this.lstXIRRFilters.filter(x => x.XIRRFilterSetupID == 6 && x.XIRRConfigID == this.currentconfigid).map(x => x.FilterDropDownValue);
    this.lstMSA = this.lstXIRRFiltersLookup.filter(x => x.Type == "MSA");
    this.lstMSA.forEach((objparent, i) => {
      var currentval = objparent.LookupID;
      MSAids.forEach((obj, j) => {
        if (currentval == obj) {
          this.lstMSA[i].active = true;
        }
      });
    });

    var VintageYearids = this.lstXIRRFilters.filter(x => x.XIRRFilterSetupID == 7 && x.XIRRConfigID == this.currentconfigid).map(x => x.FilterDropDownValue);
    this.lstVintageYear = this.lstXIRRFiltersLookup.filter(x => x.Type == "VintageYear");
    this.lstVintageYear.forEach((objparent, i) => {
      var currentval = objparent.LookupID;
      VintageYearids.forEach((obj, j) => {
        if (currentval == obj) {
          this.lstVintageYear[i].active = true;
        }
      });
    });

    //return type
    if (this._xirrConfig.Type == "Portfolio") {
      var radiobtn = document.getElementById("radioPortfolio") as HTMLInputElement;
      radiobtn.checked = true;
      this.radiobuttonclick("Portfolio");

    } else {
      var radiobtn = document.getElementById("radioDeal") as HTMLInputElement;
      radiobtn.checked = true;
      this.radiobuttonclick("Deal");
    }

    if (this._xirrConfig.CutoffRelativeDateID == 867)
      this._isShowCutoffDateOverride = true;
    else
      this._isShowCutoffDateOverride = false;
    this._isShowLoader = false;

  }

  RelativeDateChange(newvalue): void {

    this._xirrConfig.CutoffRelativeDateID = newvalue;
    if (newvalue == 867)
      this._isShowCutoffDateOverride = true;
    else
      this._isShowCutoffDateOverride = false;
  }

  ShowReturnonDealScreenChange(newvalue): void {
    this._xirrConfig.ShowReturnonDealScreen = newvalue;
  }

  radiobuttonclick(clicked) {
    this._xirrConfig.Type = clicked;

    if (clicked == "Deal") {
      this._isShowGrouping = false;
    }
    else {
      this._isShowGrouping = true;
      if (this.actiontype = "new") {
        if (this._xirrConfig.Group1 == null || this._xirrConfig.Group1 == 0) {
          //set Group1 to loan status and Loan Status  mutltiple drop to select all when new return type and type is porfolio
          this._xirrConfig.Group1 = 5;
        }
        var LoanStatusids = this.lstXIRRFilters.filter(x => x.XIRRFilterSetupID == 5 && x.XIRRConfigID == this.currentconfigid).map(x => x.FilterDropDownValue);
        this.lstLoanStatus = this.lstXIRRFiltersLookup.filter(x => x.Type == "LoanStatus");
        for (var j = 0; j < this.lstLoanStatus.length; j++) {
          this.lstLoanStatus[j].active = true;
        }
        this.lstLoanStatus.forEach((objparent, i) => {
          var currentval = objparent.LookupID;
          LoanStatusids.forEach((obj, j) => {
            if (currentval == obj) {
              this.lstLoanStatus[i].active = true;
            }
          });
        });

      }
    }
  }
  Group1Change(newvalue): void {
    this._xirrConfig.Group1 = newvalue;
  }

  Group2Change(newvalue): void {
    this._xirrConfig.Group2 = newvalue;
  }

  ReferencingDealLevelReturnChange(newvalue): void {
    this._xirrConfig.ReferencingDealLevelReturn = newvalue;
  }



  handleMultiSelectDropdown(id, dropdown, filterSetupID) {
    if (dropdown !== undefined && dropdown.checkedItems.length > 0) {
      var dropdownIds = dropdown.checkedItems.map(({ LookupID }) => LookupID);
      dropdownIds.forEach((value) => {
        var mapping = {
          XIRRConfigID: id,
          XIRRFilterSetupID: filterSetupID,
          FilterDropDownValue: value
        };
        this.dtlistXIRRfilterConfig.push(mapping);
      });
    }
    else {
      var mapping = {
        XIRRConfigID: id
      };
      this.dtlistXIRRfilterConfig.push(mapping);
    }
  }


  CheckDuplicateXIRRConfigAndSave() {
    this._isShowSave = false;
    if (this.XIRRConfigValidation()) {
      this._isShowSave = true;
      return;
    }
    this._isShowLoader = true;
    this._xirrConfig.ReturnName = this._xirrConfig.ReturnName.trim();
    this.xirrSrv.CheckDuplicateXIRRConfig(this._xirrConfig).subscribe(res => {
      if (res.Succeeded) {
        if (res.Message === "Save") {
          this._isShowSave = false;
          this.SaveXIRR();
        } else {
          this._isShowSave = true;
          this._isShowLoader = false;
          this.CustomAlert(res.Message);
        }
      } else {
        this._isShowSave = true;
        this._isShowLoader = false;
        this.CustomAlert("Error occurred while checking for duplicates.");
      }
    }, error => {
      this._isShowSave = true;
      this._isShowLoader = false;
      this.CustomAlert("Error Occurred While Saving XIRR.");
      console.error(error);
    });
  }

  IsGroupSelectedInFilters(groupID: any): boolean {
    let isValid = true;
    const groupIDString = String(groupID);
    switch (groupIDString) {
      case "1":
        if (this.Pool.checkedItems.length === 0) {
          isValid = false;
        }
        break;
      case "2":
        if (this.ProductType.checkedItems.length === 0) {
          isValid = false;
        }
        break;
      case "3":
        if (this.State.checkedItems.length === 0) {
          isValid = false;
        }
        break;
      case "4":
        if (this.DealType.checkedItems.length === 0) {
          isValid = false;
        }
        break;
      case "5":
        if (this.LoanStatus.checkedItems.length === 0) {
          isValid = false;
        }
        break;
      case "6":
        if (this.MSA.checkedItems.length === 0) {
          isValid = false;
        }
        break;
      case "7":
        if (this.VintageYear.checkedItems.length === 0) {
          isValid = false;
        }
        break;
      default:
        return isValid;
    }
    return isValid;
  }



  XIRRConfigValidation(): boolean {
    var errXIRRConfigs = "";
    var errorConfig = "";
    this.showAlert = false;
    this._isShowLoader = true;
    this.xirrValidationerror = false;


    if (this._xirrConfig) {
      //check for required fields
      if (this._xirrConfig.ReturnName == null || this._xirrConfig.ReturnName == "" || this._xirrConfig.ReturnName == undefined || this._xirrConfig.ReturnName.trim() == '') {
        errorConfig = "Return Name, ";
        this.xirrValidationerror = true;
      }
      if (this._xirrConfig.AnalysisID == null || this._xirrConfig.AnalysisID == "" || this._xirrConfig.AnalysisID == undefined) {
        errorConfig = errorConfig + "Scenario ";
        this.xirrValidationerror = true;
      }

      if (this._xirrConfig.PortfolioID === '00000000-0000-0000-0000-000000000000' &&
        (this._xirrConfig.ListTagMasterXIRRData == null ||
          this._xirrConfig.ListTagMasterXIRRData.length === 0)) {
        errorConfig = errorConfig + "Tags ";
        this.xirrValidationerror = true;
      }

      if (this._xirrConfig.Type == "Portfolio" && !this._xirrConfig.Group1) {
        this.showAlert = true;
      }
    }

    if (this._xirrConfig.Type == 'Portfolio') {
      if (this._xirrConfig.Group1 && !this.IsGroupSelectedInFilters(this._xirrConfig.Group1)) {
        this.xirrValidationerror = true;
        this._isShowLoader = false;
        this.CustomAlert("Grouping selection must have associated filters selected");
      }
      else if (this._xirrConfig.Group2 && !this.IsGroupSelectedInFilters(this._xirrConfig.Group2)) {
        this.xirrValidationerror = true;
        this._isShowLoader = false;
        this.CustomAlert("Grouping selection must have associated filters selected");
      }
    }

    if (errorConfig != "" || errXIRRConfigs != "") {
      if (errorConfig != "") {
        errXIRRConfigs = errXIRRConfigs + "<p>" + errorConfig.slice(0, -1) + " are required field(s)." + "</p>";
      }
      this.CustomAlert(errXIRRConfigs);
      this._isShowLoader = false;
    }
    else if (this.showAlert) {
      this.alert = "Group1 must be selected";
      this.xirrValidationerror = true;
      this._isShowLoader = false;
    }

    return this.xirrValidationerror;

  }


  SaveXIRR() {
    if (this._xirrConfig.ReturnName != null) {
      this._xirrConfig.ReturnName = this._xirrConfig.ReturnName.trim();
    }
    const selectedTags = this._xirrConfig.ListTagMasterXIRRData;
    selectedTags.forEach(tag => {
      let configWithTag = new XIRRConfig;
      configWithTag.ObjectType = 'Tag';
      configWithTag.ObjectID = tag.TagMasterXIRRID;
      configWithTag.XIRRConfigID = this.currentconfigid;
      this.xirrConfigList.push(configWithTag);
    });

    if (this.treeView != null) {
      for (var j = 0; j < this.treeView.checkedItems.length; j++) {
        let selectedItem = this.treeView.checkedItems[j];
        let configWithTransaction = new XIRRConfig;
        configWithTransaction.ObjectType = 'Transaction';
        configWithTransaction.XIRRConfigID = this.currentconfigid;
        configWithTransaction.ObjectID = selectedItem.TransactionTypesID;
        this.xirrConfigList.push(configWithTransaction);
      }
    }

    this._xirrConfigMaster = new XIRRConfigMasterDataContract();
    this.handleMultiSelectDropdown(this.currentconfigid, this.Pool, 1);
    this.handleMultiSelectDropdown(this.currentconfigid, this.ProductType, 2);
    this.handleMultiSelectDropdown(this.currentconfigid, this.State, 3);
    this.handleMultiSelectDropdown(this.currentconfigid, this.DealType, 4);
    this.handleMultiSelectDropdown(this.currentconfigid, this.LoanStatus, 5);
    this.handleMultiSelectDropdown(this.currentconfigid, this.MSA, 6);
    this.handleMultiSelectDropdown(this.currentconfigid, this.VintageYear, 7);
    this._xirrConfig.ListXirrConfigFilter = this.dtlistXIRRfilterConfig;
    this._xirrConfig.ListXirrConfig = this.xirrConfigList;
    if (this._xirrConfig.CutoffRelativeDateID != 867) {
      this._xirrConfig.CutoffDateOverride = null;
    }
    if (this._xirrConfig.CutoffDateOverride != undefined && this._xirrConfig.CutoffDateOverride != null && this._xirrConfig.CutoffDateOverride.toString() != "") {
      this._xirrConfig.CutoffDateOverride = this.utils.convertDateToUTC(this._xirrConfig.CutoffDateOverride);
    }
    this.xirrSrv.SaveXIRRConfigs(this._xirrConfig).subscribe(res => {
      if (res.Succeeded) {
        //this._isShowLoader = false;
        this._ShowSuccessmessage = "XIRR return saved successfully and queued for calculation.";
        this._ShowSuccessmessagediv = true;

        setTimeout(() => {
          localStorage.setItem('SaveXIRRConfigs', 'SaveXIRRConfigs');
          //var path = ['/#/xirr'];
          //this._router.navigate([path]);
          this._router.navigate(['xirr']);
          this._ShowSuccessmessagediv = false;
          this._isShowSave = true;
        }, 5000);
      }
      else {
        this._isShowLoader = false;
        this._ShowErrorMessage = "Error occurred while saving XIRR. Please try after some time.";
        this.divErrorMessage = true;
        this._isShowSave = true;
      }
    }); (error: string) => {
      this._isShowLoader = false;
      this._ShowErrorMessage = "Error occurred while saving XIRR. Please try after some time.";
      this.divErrorMessage = true;
      this._isShowSave = true;
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

  ReturnToXirrTab() {

    var path = ['/#/xirr'];
    window.open(path.toString(), '_self', '');
  }


  getTransactionTypes() {
    this._isShowLoader = true;
    this.xirrSrv.getallxirrtransactiontypes().subscribe(res => {
      if (res.Succeeded == true) {
        this._isShowLoader = false;
        var data = res.TTList;
        var grpCategory = this.groupByCat(data, "TransactionCategory");
        var arr = [];
        grpCategory.forEach((obj, i) => {          
          var childarr = [];
          var lstTransactions = obj.map(x => x.TransactionName);
          lstTransactions.forEach((objc) => {
            let transactionType = obj.find(item => item.TransactionName === objc);
            childarr.push({ "header": objc, "TransactionTypesID": transactionType.TransactionTypesID, "active": false })
          })

          childarr.forEach((child, j) => {
            let foundTransaction = this._lstXIRRConfig.ListTransactionTypesData.find(item => item.TransactionTypesID === child.TransactionTypesID);
            if (foundTransaction) {
              child.active = true;
            }
          });          
          arr.push({ "header": i, "items": childarr });
        });

        this.data = arr;

      }
    });
  }


  groupByCat(list: any[], key: string): Map<string, Array<any>> {
    let map = new Map();
    list.map(val => {
      if (!map.has(val[key])) {
        map.set(val[key], list.filter(data => data[key] == val[key]));
      }
    });
    return map;
  }

  //code end

  isDroppedDownChanged(ml) {
    //remove default filter function
    //MultiSelectListBox.prototype._applyFilter = null;
    //Add TreeView on MultiSelect dropdown
    let multiSelectDropdown = document.querySelector(
      '.wj-multiselectlistbox [wj-part="list-box"]'
    ) as HTMLElement;
    if (
      multiSelectDropdown &&
      !multiSelectDropdown.querySelector(`.wj-treeview`)
    ) {
      let treeContainer = createElement(
        '<div class="treeContent></div>',
        multiSelectDropdown
      );
      let filterInputEle = document.querySelector(
        '.wj-multiselectlistbox [wj-part="filter"]'
      ) as HTMLInputElement;
      this.treeView = new TreeView(treeContainer, {
        itemsSource: this.data,
        displayMemberPath: 'header',
        childItemsPath: 'items',
        showCheckboxes: true,
        checkedMemberPath: 'active',
        checkedItemsChanged: (s, e) => {
          ml.inputElement.value = this.getHeaderValues(s.checkedItems);
        },
      });

      filterInputEle.addEventListener(
        'input',
        (e) => {
          e.preventDefault();
          e.stopImmediatePropagation();
          setTimeout(() => {
            this.treeView.collapseToLevel(10);
            //this.searchList = [];
            //let filteredItems = this.getSearchedItems(
            //  this.data,
            //  filterInputEle.value
            //);
            //if (filteredItems) {
            //  this.treeView.itemsSource = [];
            //  this.treeView.itemsSource = filteredItems;
            //}
            ml.inputElement.value = this.getHeaderValues(
              this.treeView.checkedItems
            );
          }, 500); //perform search after some delay
        },
        true
      );



    }
    var wjlistboxitem = document.getElementsByClassName('wj-listbox-item');
    for (var i = 0; i < wjlistboxitem.length; i++) {
      var currentelement = wjlistboxitem[i];
      currentelement["style"].display = 'none';
    }
  }
  private getSearchedItems(items, searchString = '') {
    if (searchString == '') {
      return items;
    }
    // add items and sub-items
    for (var i = 0; i < items.length; i++) {
      let header = items[i].header;
      if (header.toLowerCase().includes(searchString)) {
        this.searchList.push(items[i]);
      }
      if (items[i].items) {
        this.getSearchedItems(items[i].items, searchString);
      }
    }
    return this.searchList;
  }

  private getHeaderValues(arr) {
    if (arr.length > 3) {
      return `${arr.length} items are checked`;
    } else {
      return arr.map((obj) => obj.header).join(', ');
    }
  }






}




const routes: Routes = [

  { path: '', component: xirrConfigurationcomponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjInputModule, WjGridFilterModule],
  declarations: [xirrConfigurationcomponent]

})

export class xirrConfigurationModule { }
