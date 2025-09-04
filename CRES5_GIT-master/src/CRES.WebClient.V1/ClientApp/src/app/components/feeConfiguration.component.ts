import { Component, ViewChild } from '@angular/core';
import { Router } from '@angular/router';
import * as wjcCore from '@grapecity/wijmo';
import * as wjcGrid from '@grapecity/wijmo.grid';
import { UtilityService } from '../core/services/utility.service';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import { PermissionService } from '../core/services/permission.service';
import { feeconfigurationService } from '../core/services/feeConfiguration.service';
import { dealService } from '../core/services/deal.service';
import { NoteService } from '../core/services/note.service';
import { FeeConfig } from '../core/domain/feeConfiguration.model';
declare var $: any;
@Component({
  templateUrl: "./feeConfiguration.html",
  providers: [NoteService, dealService, feeconfigurationService, PermissionService]
})


export class FeeConfigurationComponent {
  public rowsToUpdate: any = [];
  lastFunctionType: any;
  lastPaymentFrequency: any;
  lstAccrualBasis: any;
  lstAccrualStartDate: any;
  lstAccrualPeriod: any;
  lstFeePaymentFrequency: any;
  lstFeeCoveragePeriod: any;
  lstTotalCommitment: any;
  lstUnscheduledPaydowns: any;
  listfeefunction: any;
  listfeefunctionfordropdown: any;
  listfeeamount: any;
  lstFeeTypeLookUp: any;
  lstPrepayAdditinalFee_ValueType: any;
  lstFeeTrans: any;
  lstInitialFunding: any;

  @ViewChild('flexfeefunction') flexfeefunction !: wjcGrid.FlexGrid;
  @ViewChild('flexfeeamount') flexfeeamount !: wjcGrid.FlexGrid;
  _feefunctionList !: wjcCore.CollectionView;
  _feeamountList !: wjcCore.CollectionView;

  public _isFeeFunctionListFetching !: boolean;
  public _Showmessagediv: boolean = false;
  public _ShowSuccessmessagediv: boolean = false;
  public _ShowmessagedivMsg: string = '';
  public Message: string = '';
  _feeConfig: FeeConfig;
  callBaseAmount: boolean = true;
  callFeeAmount: boolean = true;
  public FeeTypeGuID !: string;
  public FeeTypeNameText !: string;
  public deleteRowIndex !: number;
  public _lstfeefunctionCount: any;
  public _isfeeamountListFetching: boolean = false;
  public _feeamountListCount: any;

  constructor(private _router: Router,
    public permissionService: PermissionService,
    public utilityService: UtilityService,
    public feeconfigurationSrv: feeconfigurationService,
    public dealSrv: dealService,
    public noteService: NoteService,
  ) {
    this._feeConfig = new FeeConfig();
    this.GetAllFeeFunction();
    this.utilityService.setPageTitle("M61–Fee Configuration");
    this.GetUserPermission();
    this.getFeeTypesFromFeeSchedulesConfig();
    
  }

  ngOnInit() {

    if (localStorage.getItem('showconfigmessage') == 'true') {
      this._ShowmessagedivMsg = localStorage.getItem('configmessage')
      this._ShowSuccessmessagediv = true;

      localStorage.setItem('showconfigmessage', JSON.stringify(false));
      localStorage.setItem('configmessage', JSON.stringify(''));
      setTimeout(() => {
        this._ShowSuccessmessagediv = false;
        this._ShowmessagedivMsg = "";
      }, 3000);
    }

  }  
  ngAfterViewInit() {

  }

  GetAllFeeFunction(): void {
    if (this.callFeeAmount) {

      try {

        this.feeconfigurationSrv.GetAllFeeFunction().subscribe(res => {
          if (res.Succeeded) {
            this.listfeefunction = []
            var data: any = res.lstFeeFunctionsConfig;
            this.listfeefunction = data;
            this.listfeefunctionfordropdown = data;

            this._feefunctionList = new wjcCore.CollectionView(this.listfeefunction);
            this._feefunctionList.trackChanges = true;

            this.GetAllLookups();
            setTimeout(function () {
              this.flexfeefunction.invalidate();
            }.bind(this), 200);
          }
          else {
            this._router.navigate(['login']);
          }
        });
      } catch (err) {
      }
      this.callFeeAmount = false;
    }
    else {
      setTimeout(function () {
        this.flexfeefunction.invalidate();
      }.bind(this), 200);
    }
  }

  GetAllFeeAmount(): void {

    if (this.callBaseAmount) {

      try {
        this.feeconfigurationSrv.GetAllFeeAmount().subscribe(res => {
          if (res.Succeeded) {
            this.listfeeamount = []
            var data: any = res.lstFeeSchedulesConfig;
            this.listfeeamount = data;

            this._feeamountList = new wjcCore.CollectionView(this.listfeeamount);
            this._feeamountList.trackChanges = true;
            this.callBaseAmount = false;
            setTimeout(function () {
              this.flexfeeamount.invalidate();
            }.bind(this), 200);
            
          }
          else {
            this._router.navigate(['login']);
          }
        });
      } catch (err) {
      }
      this.callFeeAmount = true;
    }
    setTimeout(function () {
      this.flexfeeamount.invalidate();
    }.bind(this), 200);

  }

  GetUserPermission(): void {
    try {
      this.permissionService.GetUserPermissionByPagename("FeeConfiguration").subscribe(res => {
        if (res.Succeeded) {
          if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
            var _object = res.UserPermissionList;
            var controlarrayedit = _object.filter(function (item) { return item.ModuleType === 'Control' && item.RightsName === 'Edit'; });            
          }
        }
      });
    } catch (err) {
      alert(err)
    }
  }

  GetAllLookups(): void {
    this.dealSrv.getAllLookup().subscribe(res => {
      var data = res.lstLookups;

      this.lastFunctionType = data.filter(x => x.ParentID == "84");
      this.lastPaymentFrequency = data.filter(x => x.ParentID == "85");
      this.lstAccrualBasis = data.filter(x => x.ParentID == "86");
      this.lstAccrualStartDate = data.filter(x => x.ParentID == "87");
      this.lstAccrualPeriod = data.filter(x => x.ParentID == "88");
      this.lstFeePaymentFrequency = data.filter(x => x.ParentID == "89");
      this.lstFeeCoveragePeriod = data.filter(x => x.ParentID == "90");
      this.lstTotalCommitment = data.filter(x => x.ParentID == "91");
      this.lstUnscheduledPaydowns = data.filter(x => x.ParentID == "92");
      this.lstFeeTrans = data.filter(x => x.ParentID == "94");

      this.lstPrepayAdditinalFee_ValueType = this.lstFeeTypeLookUp;
      //set dropdown for
      this.lstInitialFunding = data.filter(x => x.ParentID == "91");
      this._bindGridDropdows();
    });
  }

  // apply/remove data maps
  private _bindGridDropdows() {
    //alert('_updateDataMaps');
    var flexfeefunction = this.flexfeefunction;
    var flexfeeamount = this.flexfeeamount;

    if (flexfeefunction) {
      var colRateType = flexfeefunction.columns.getColumn('FunctionTypeText');
      if (colRateType) {
        colRateType.dataMap = this._buildDataMap(this.lastFunctionType);
      }

      var colStatus = flexfeefunction.columns.getColumn('PaymentFrequencyText');
      if (colStatus) {

        colStatus.dataMap = this._buildDataMap(this.lastPaymentFrequency);
      }

      var colRateType = flexfeefunction.columns.getColumn('AccrualBasisText');
      if (colRateType) {
        colRateType.dataMap = this._buildDataMap(this.lstAccrualBasis);
      }

      var colRateType = flexfeefunction.columns.getColumn('AccrualStartDateText');
      if (colRateType) {
        colRateType.dataMap = this._buildDataMap(this.lstAccrualStartDate);
      }

      var colRateType = flexfeefunction.columns.getColumn('AccrualPeriodText');
      if (colRateType) {
        colRateType.dataMap = this._buildDataMap(this.lstAccrualPeriod);
      }
    }

    if (flexfeeamount) {
      var colRateType = flexfeeamount.columns.getColumn('FeePaymentFrequencyText');
      if (colRateType) {
        colRateType.dataMap = this._buildDataMap(this.lstFeePaymentFrequency);
      }

      var colRateType = flexfeeamount.columns.getColumn('FeeCoveragePeriodText');
      if (colRateType) {

        colRateType.dataMap = this._buildDataMap(this.lstFeeCoveragePeriod);
      }

      var colRateType = flexfeeamount.columns.getColumn('FeeFunctionText'); // FeeFunctionText
      if (colRateType) {
        colRateType.dataMap = this._buildDataMap(this.listfeefunctionfordropdown);
      }


      var colRateType = flexfeeamount.columns.getColumn('TotalCommitmentText');
      if (colRateType) {

        colRateType.dataMap = this._buildDataMap(this.lstTotalCommitment);
      }

      var colRateType = flexfeeamount.columns.getColumn('UnscheduledPaydownsText');
      if (colRateType) {

        colRateType.dataMap = this._buildDataMap(this.lstTotalCommitment);
      }

      var colRateType = flexfeeamount.columns.getColumn('BalloonPaymentText');
      if (colRateType) {

        colRateType.dataMap = this._buildDataMap(this.lstTotalCommitment);
      }

      var colRateType = flexfeeamount.columns.getColumn('LoanFundingsText');
      if (colRateType) {

        colRateType.dataMap = this._buildDataMap(this.lstTotalCommitment);
      }

      var colRateType = flexfeeamount.columns.getColumn('ScheduledPrincipalAmortizationPaymentText');
      if (colRateType) {

        colRateType.dataMap = this._buildDataMap(this.lstTotalCommitment);
      }

      var colRateType = flexfeeamount.columns.getColumn('CurrentLoanBalanceText');
      if (colRateType) {

        colRateType.dataMap = this._buildDataMap(this.lstTotalCommitment);
      }

      var colRateType = flexfeeamount.columns.getColumn('InterestPaymentText');
      if (colRateType) {

        colRateType.dataMap = this._buildDataMap(this.lstTotalCommitment);
      }
      var colRateType = flexfeeamount.columns.getColumn('FeeNameTransText');
      if (colRateType) {

        colRateType.dataMap = this._buildDataMap(this.lstFeeTrans);
      }

      var colRateType = flexfeeamount.columns.getColumn('InitialFundingText');
      if (colRateType) {

        colRateType.dataMap = this._buildDataMap(this.lstInitialFunding);
      }

      var colM61AdjustedCommitmentType = flexfeeamount.columns.getColumn('M61AdjustedCommitmentText');
      if (colM61AdjustedCommitmentType) {
        colM61AdjustedCommitmentType.dataMap = this._buildDataMap(this.lstTotalCommitment);
      }
      var colM61AdjustedCommitmentType = flexfeeamount.columns.getColumn('PIKFundingText');
      if (colM61AdjustedCommitmentType) {
        colM61AdjustedCommitmentType.dataMap = this._buildDataMap(this.lstTotalCommitment);
      }

      var colM61AdjustedCommitmentType = flexfeeamount.columns.getColumn('PIKPrincipalPaymentText');
      if (colM61AdjustedCommitmentType) {
        colM61AdjustedCommitmentType.dataMap = this._buildDataMap(this.lstTotalCommitment);
      }
      var colM61AdjustedCommitmentType = flexfeeamount.columns.getColumn('CurtailmentText');
      if (colM61AdjustedCommitmentType) {
        colM61AdjustedCommitmentType.dataMap = this._buildDataMap(this.lstTotalCommitment);
      }
      var colM61AdjustedCommitmentType = flexfeeamount.columns.getColumn('UpsizeAmountText');
      if (colM61AdjustedCommitmentType) {
        colM61AdjustedCommitmentType.dataMap = this._buildDataMap(this.lstTotalCommitment);
      }
      var colM61AdjustedCommitmentType = flexfeeamount.columns.getColumn('UnfundedCommitmentText');
      if (colM61AdjustedCommitmentType) {
        colM61AdjustedCommitmentType.dataMap = this._buildDataMap(this.lstTotalCommitment);
      }

    }
  }

  getFeeTypesFromFeeSchedulesConfig(): void {

    this.noteService.getFeeTypesFromFeeSchedulesConfig().subscribe(res => {
      if (res.Succeeded) {
        this.lstFeeTypeLookUp = res.lstFeeTypeLookUp;
      }
    });
  }

  // build a data map from a string array using the indices as keys
  private _buildDataMap(items): wjcGrid.DataMap {
    var map = [];

    for (var i = 0; i < items.length; i++) {
      var obj = items[i];
      map.push({ key: obj['LookupID'], value: obj['Name'] });
    }
    return new wjcGrid.DataMap(map, 'key', 'value');
  }

  deletefeefunction(e: wjcGrid.CellEditEndingEventArgs) {
    e.cancel = true;
  }

  Copiedfeefunction(flexfeefunction: wjcGrid.FlexGrid, e: wjcGrid.CellEditEndingEventArgs) {

  }

  SaveFeeConfig(): void {
    var isduplicatefunctionName = false;
    var isduplicatefeetypeName = false;

    this._isFeeFunctionListFetching = true;
    //fee function save


    //fee amount save
    if (this.listfeefunction != undefined) {
      this.listfeefunction = this.listfeefunction.filter(x => (x.FunctionNameText != null && x.FunctionNameText != ""));
      for (var i = 0; i < this.listfeefunction.length; i++) {
        if (!(Number(this.listfeefunction[i].FunctionTypeText).toString() == "NaN" || Number(this.listfeefunction[i].FunctionTypeText) == 0)) {
          this.listfeefunction[i].FunctionTypeID = Number(this.listfeefunction[i].FunctionTypeText);
          this.listfeefunction[i].FunctionTypeText = this.lastFunctionType.find(x => x.LookupID == this.listfeefunction[i].FunctionTypeID).Name
        }
        else {
          var filteredarray = this.lastFunctionType.filter(x => x.Name == this.listfeefunction[i].FunctionTypeText)
          if (filteredarray.length != 0) {
            this.listfeefunction[i].FunctionTypeID = Number(filteredarray[0].LookupID);
          }
        }
        if (!(Number(this.listfeefunction[i].PaymentFrequencyText).toString() == "NaN" || Number(this.listfeefunction[i].PaymentFrequencyText) == 0)) {
          this.listfeefunction[i].PaymentFrequencyID = Number(this.listfeefunction[i].PaymentFrequencyText);
          this.listfeefunction[i].PaymentFrequencyText = this.lastPaymentFrequency.find(x => x.LookupID == this.listfeefunction[i].PaymentFrequencyID).Name
        }
        else {
          var filteredarray = this.lastPaymentFrequency.filter(x => x.Name == this.listfeefunction[i].PaymentFrequencyText)
          if (filteredarray.length != 0) {
            this.listfeefunction[i].PaymentFrequencyID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this.listfeefunction[i].AccrualBasisText).toString() == "NaN" || Number(this.listfeefunction[i].AccrualBasisText) == 0)) {
          this.listfeefunction[i].AccrualBasisID = Number(this.listfeefunction[i].AccrualBasisText);
          this.listfeefunction[i].AccrualBasisText = this.lstAccrualBasis.find(x => x.LookupID == this.listfeefunction[i].AccrualBasisID).Name
        }
        else {
          var filteredarray = this.lstAccrualBasis.filter(x => x.Name == this.listfeefunction[i].AccrualBasisText)
          if (filteredarray.length != 0) {
            this.listfeefunction[i].AccrualBasisID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this.listfeefunction[i].AccrualStartDateText).toString() == "NaN" || Number(this.listfeefunction[i].AccrualStartDateText) == 0)) {
          this.listfeefunction[i].AccrualStartDateID = Number(this.listfeefunction[i].AccrualStartDateText);
          this.listfeefunction[i].AccrualStartDateText = this.lstAccrualStartDate.find(x => x.LookupID == this.listfeefunction[i].AccrualStartDateID).Name
        }
        else {
          var filteredarray = this.lstAccrualStartDate.filter(x => x.Name == this.listfeefunction[i].AccrualStartDateText)
          if (filteredarray.length != 0) {
            this.listfeefunction[i].AccrualStartDateID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this.listfeefunction[i].AccrualPeriodText).toString() == "NaN" || Number(this.listfeefunction[i].AccrualPeriodText) == 0)) {
          this.listfeefunction[i].AccrualPeriodID = Number(this.listfeefunction[i].AccrualPeriodText);
          this.listfeefunction[i].AccrualPeriodText = this.lstAccrualPeriod.find(x => x.LookupID == this.listfeefunction[i].AccrualPeriodID).Name
        }
        else {
          var filteredarray = this.lstAccrualPeriod.filter(x => x.Name == this.listfeefunction[i].AccrualPeriodText)
          if (filteredarray.length != 0) {
            this.listfeefunction[i].AccrualPeriodID = Number(filteredarray[0].LookupID);
          }
        }
      }
      this._feeConfig.lstFeeFunctionsConfig = this.listfeefunction;

      isduplicatefunctionName = this.checkDuplicateInObject("FunctionNameText", this._feeConfig.lstFeeFunctionsConfig)
    }
    if (this.listfeeamount != undefined) {
      this.listfeeamount = this.listfeeamount.filter(x => (x.FeeTypeNameText != null && x.FeeTypeNameText != ""));

      for (var i = 0; i < this.listfeeamount.length; i++) {
        if (!(Number(this.listfeeamount[i].FeePaymentFrequencyText).toString() == "NaN" || Number(this.listfeeamount[i].FeePaymentFrequencyText) == 0)) {
          this.listfeeamount[i].FeePaymentFrequencyID = Number(this.listfeeamount[i].FeePaymentFrequencyText);
          this.listfeeamount[i].FeePaymentFrequencyText = this.lstFeePaymentFrequency.find(x => x.LookupID == this.listfeeamount[i].FeePaymentFrequencyID).Name
        }
        else {
          var filteredarray = this.lstFeePaymentFrequency.filter(x => x.Name == this.listfeeamount[i].FeePaymentFrequencyText)
          if (filteredarray.length != 0) {
            this.listfeeamount[i].FeePaymentFrequencyID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this.listfeeamount[i].FeeCoveragePeriodText).toString() == "NaN" || Number(this.listfeeamount[i].FeeCoveragePeriodText) == 0)) {
          this.listfeeamount[i].FeeCoveragePeriodID = Number(this.listfeeamount[i].FeeCoveragePeriodText);
          this.listfeeamount[i].FeeCoveragePeriodText = this.lstFeeCoveragePeriod.find(x => x.LookupID == this.listfeeamount[i].FeeCoveragePeriodID).Name
        }
        else {
          var filteredarray = this.lstFeeCoveragePeriod.filter(x => x.Name == this.listfeeamount[i].FeeCoveragePeriodText)
          if (filteredarray.length != 0) {
            this.listfeeamount[i].FeeCoveragePeriodID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this.listfeeamount[i].FeeFunctionText).toString() == "NaN" || Number(this.listfeeamount[i].FeeFunctionText) == 0)) {
          this.listfeeamount[i].FeeFunctionID = Number(this.listfeeamount[i].FeeFunctionText);
          this.listfeeamount[i].FeeFunctionText = this.listfeefunction.find(x => x.FunctionNameID == this.listfeeamount[i].FeeFunctionID).FunctionNameText
        }
        else {
          var filteredarray = this.listfeefunction.filter(x => x.FunctionNameText == this.listfeeamount[i].FeeFunctionText)
          if (filteredarray.length != 0) {
            this.listfeeamount[i].FeeFunctionID = Number(filteredarray[0].FunctionNameID);
          }
        }

        if (!(Number(this.listfeeamount[i].TotalCommitmentText).toString() == "NaN" || Number(this.listfeeamount[i].TotalCommitmentText) == 0)) {
          this.listfeeamount[i].TotalCommitmentID = Number(this.listfeeamount[i].TotalCommitmentText);
          this.listfeeamount[i].TotalCommitmentText = this.lstTotalCommitment.find(x => x.LookupID == this.listfeeamount[i].TotalCommitmentID).Name
        }
        else {
          var filteredarray = this.lstTotalCommitment.filter(x => x.Name == this.listfeeamount[i].TotalCommitmentText)
          if (filteredarray.length != 0) {
            this.listfeeamount[i].TotalCommitmentID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this.listfeeamount[i].UnscheduledPaydownsText).toString() == "NaN" || Number(this.listfeeamount[i].UnscheduledPaydownsText) == 0)) {
          this.listfeeamount[i].UnscheduledPaydownsID = Number(this.listfeeamount[i].UnscheduledPaydownsText);
          this.listfeeamount[i].UnscheduledPaydownsText = this.lstTotalCommitment.find(x => x.LookupID == this.listfeeamount[i].UnscheduledPaydownsID).Name
        }
        else {
          var filteredarray = this.lstTotalCommitment.filter(x => x.Name == this.listfeeamount[i].UnscheduledPaydownsText)
          if (filteredarray.length != 0) {
            this.listfeeamount[i].UnscheduledPaydownsID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this.listfeeamount[i].BalloonPaymentText).toString() == "NaN" || Number(this.listfeeamount[i].BalloonPaymentText) == 0)) {
          this.listfeeamount[i].BalloonPaymentID = Number(this.listfeeamount[i].BalloonPaymentText);
          this.listfeeamount[i].BalloonPaymentText = this.lstTotalCommitment.find(x => x.LookupID == this.listfeeamount[i].BalloonPaymentID).Name
        }
        else {
          var filteredarray = this.lstTotalCommitment.filter(x => x.Name == this.listfeeamount[i].BalloonPaymentText)
          if (filteredarray.length != 0) {
            this.listfeeamount[i].BalloonPaymentID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this.listfeeamount[i].LoanFundingsText).toString() == "NaN" || Number(this.listfeeamount[i].LoanFundingsText) == 0)) {
          this.listfeeamount[i].LoanFundingsID = Number(this.listfeeamount[i].LoanFundingsText);
          this.listfeeamount[i].LoanFundingsText = this.lstTotalCommitment.find(x => x.LookupID == this.listfeeamount[i].LoanFundingsID).Name
        }
        else {
          var filteredarray = this.lstTotalCommitment.filter(x => x.Name == this.listfeeamount[i].LoanFundingsText)
          if (filteredarray.length != 0) {
            this.listfeeamount[i].LoanFundingsID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this.listfeeamount[i].ScheduledPrincipalAmortizationPaymentText).toString() == "NaN" || Number(this.listfeeamount[i].ScheduledPrincipalAmortizationPaymentText) == 0)) {
          this.listfeeamount[i].ScheduledPrincipalAmortizationPaymentID = Number(this.listfeeamount[i].ScheduledPrincipalAmortizationPaymentText);
          this.listfeeamount[i].ScheduledPrincipalAmortizationPaymentText = this.lstTotalCommitment.find(x => x.LookupID == this.listfeeamount[i].ScheduledPrincipalAmortizationPaymentID).Name
        }
        else {
          var filteredarray = this.lstTotalCommitment.filter(x => x.Name == this.listfeeamount[i].ScheduledPrincipalAmortizationPaymentText)
          if (filteredarray.length != 0) {
            this.listfeeamount[i].ScheduledPrincipalAmortizationPaymentID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this.listfeeamount[i].CurrentLoanBalanceText).toString() == "NaN" || Number(this.listfeeamount[i].CurrentLoanBalanceText) == 0)) {
          this.listfeeamount[i].CurrentLoanBalanceID = Number(this.listfeeamount[i].CurrentLoanBalanceText);
          this.listfeeamount[i].CurrentLoanBalanceText = this.lstTotalCommitment.find(x => x.LookupID == this.listfeeamount[i].CurrentLoanBalanceID).Name
        }
        else {
          var filteredarray = this.lstTotalCommitment.filter(x => x.Name == this.listfeeamount[i].CurrentLoanBalanceText)
          if (filteredarray.length != 0) {
            this.listfeeamount[i].CurrentLoanBalanceID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this.listfeeamount[i].InterestPaymentText).toString() == "NaN" || Number(this.listfeeamount[i].InterestPaymentText) == 0)) {
          this.listfeeamount[i].InterestPaymentID = Number(this.listfeeamount[i].InterestPaymentText);
          this.listfeeamount[i].InterestPaymentText = this.lstTotalCommitment.find(x => x.LookupID == this.listfeeamount[i].InterestPaymentID).Name
        }
        else {
          var filteredarray = this.lstTotalCommitment.filter(x => x.Name == this.listfeeamount[i].InterestPaymentText)
          if (filteredarray.length != 0) {
            this.listfeeamount[i].InterestPaymentID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this.listfeeamount[i].FeeNameTransText).toString() == "NaN" || Number(this.listfeeamount[i].FeeNameTransText) == 0)) {
          this.listfeeamount[i].FeeNameTransID = Number(this.listfeeamount[i].FeeNameTransText);
          this.listfeeamount[i].FeeNameTransText = this.lstFeeTrans.find(x => x.LookupID == this.listfeeamount[i].FeeNameTransID).Name
        }
        else {
          var filteredarray = this.lstTotalCommitment.filter(x => x.Name == this.listfeeamount[i].FeeNameTransText)
          if (filteredarray.length != 0) {
            this.listfeeamount[i].FeeNameTransID = Number(filteredarray[0].LookupID);
          }
        }


        if (!(Number(this.listfeeamount[i].InitialFundingText).toString() == "NaN" || Number(this.listfeeamount[i].InitialFundingText) == 0)) {
          this.listfeeamount[i].InitialFundingID = Number(this.listfeeamount[i].InitialFundingText);
          this.listfeeamount[i].InitialFundingText = this.lstInitialFunding.find(x => x.LookupID == this.listfeeamount[i].InitialFundingID).Name
        }
        else {
          var filteredarray = this.lstInitialFunding.filter(x => x.Name == this.listfeeamount[i].InitialFundingText)
          if (filteredarray.length != 0) {
            this.listfeeamount[i].InitialFundingID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this.listfeeamount[i].M61AdjustedCommitmentText).toString() == "NaN" || Number(this.listfeeamount[i].M61AdjustedCommitmentText) == 0)) {
          this.listfeeamount[i].M61AdjustedCommitmentID = Number(this.listfeeamount[i].M61AdjustedCommitmentText);
          this.listfeeamount[i].M61AdjustedCommitmentText = this.lstTotalCommitment.find(x => x.LookupID == this.listfeeamount[i].M61AdjustedCommitmentID).Name;
        }
        else {
          var filteredarray = this.lstTotalCommitment.filter(x => x.Name == this.listfeeamount[i].M61AdjustedCommitmentText)
          if (filteredarray.length != 0) {
            this.listfeeamount[i].M61AdjustedCommitmentID = Number(filteredarray[0].LookupID);
          }
        }
      
        if (!(Number(this.listfeeamount[i].PIKFundingText).toString() == "NaN" || Number(this.listfeeamount[i].PIKFundingText) == 0)) {
          this.listfeeamount[i].PIKFundingID = Number(this.listfeeamount[i].PIKFundingText);
          this.listfeeamount[i].PIKFundingText = this.lstTotalCommitment.find(x => x.LookupID == this.listfeeamount[i].PIKFundingID).Name;
        }
        else {
          var filteredarray = this.lstTotalCommitment.filter(x => x.Name == this.listfeeamount[i].PIKFundingText)
          if (filteredarray.length != 0) {
            this.listfeeamount[i].PIKFundingID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this.listfeeamount[i].PIKPrincipalPaymentText).toString() == "NaN" || Number(this.listfeeamount[i].PIKPrincipalPaymentText) == 0)) {
          this.listfeeamount[i].PIKPrincipalPaymentID = Number(this.listfeeamount[i].PIKPrincipalPaymentText);
          this.listfeeamount[i].PIKPrincipalPaymentText = this.lstTotalCommitment.find(x => x.LookupID == this.listfeeamount[i].PIKPrincipalPaymentID).Name;
        }
        else {
          var filteredarray = this.lstTotalCommitment.filter(x => x.Name == this.listfeeamount[i].PIKPrincipalPaymentText)
          if (filteredarray.length != 0) {
            this.listfeeamount[i].PIKPrincipalPaymentID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this.listfeeamount[i].CurtailmentText).toString() == "NaN" || Number(this.listfeeamount[i].CurtailmentText) == 0)) {
          this.listfeeamount[i].CurtailmentID = Number(this.listfeeamount[i].CurtailmentText);
          this.listfeeamount[i].CurtailmentText = this.lstTotalCommitment.find(x => x.LookupID == this.listfeeamount[i].CurtailmentID).Name;
        }
        else {
          var filteredarray = this.lstTotalCommitment.filter(x => x.Name == this.listfeeamount[i].CurtailmentText)
          if (filteredarray.length != 0) {
            this.listfeeamount[i].CurtailmentID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this.listfeeamount[i].UnfundedCommitmentText).toString() == "NaN" || Number(this.listfeeamount[i].UnfundedCommitmentText) == 0)) {
          this.listfeeamount[i].UnfundedCommitmentID = Number(this.listfeeamount[i].UnfundedCommitmentText);
          this.listfeeamount[i].UnfundedCommitmentText = this.lstTotalCommitment.find(x => x.LookupID == this.listfeeamount[i].UnfundedCommitmentID).Name;
        }
        else {
          var filteredarray = this.lstTotalCommitment.filter(x => x.Name == this.listfeeamount[i].UnfundedCommitmentText)
          if (filteredarray.length != 0) {
            this.listfeeamount[i].UnfundedCommitmentID = Number(filteredarray[0].LookupID);
          }
        }

        if (!(Number(this.listfeeamount[i].UpsizeAmountText).toString() == "NaN" || Number(this.listfeeamount[i].UpsizeAmountText) == 0)) {
          this.listfeeamount[i].UpsizeAmountID = Number(this.listfeeamount[i].UpsizeAmountText);
          this.listfeeamount[i].UpsizeAmountText = this.lstTotalCommitment.find(x => x.LookupID == this.listfeeamount[i].UpsizeAmountID).Name;
        }
        else {
          var filteredarray = this.lstTotalCommitment.filter(x => x.Name == this.listfeeamount[i].UpsizeAmountText)
          if (filteredarray.length != 0) {
            this.listfeeamount[i].UpsizeAmountID = Number(filteredarray[0].LookupID);
          }
        }

      }


      this._feeConfig.lstFeeSchedulesConfig = this.listfeeamount;
      isduplicatefeetypeName = this.checkDuplicateInObject("FeeTypeNameText", this._feeConfig.lstFeeSchedulesConfig)
    }

    if (isduplicatefunctionName) {

      this.Message = "Duplicate fee function name.Please enter unique name"
      this._Showmessagediv = true;
    }
    else if (isduplicatefeetypeName) {
      this.Message = "Duplicate fee type name.Please enter unique name"
      this._Showmessagediv = true;
    }

    if (isduplicatefunctionName == true || isduplicatefeetypeName == true) {
      this._isFeeFunctionListFetching = false;
      setTimeout(() => {
        this._Showmessagediv = false;
        this.Message = "";
      }, 3000);
    }
    else {

      try {
        this.feeconfigurationSrv.SaveFeeConfig(this._feeConfig).subscribe(res => {
          if (res.Succeeded) {
            this.callBaseAmount = true;

            localStorage.setItem('showconfigmessage', 'true');
            localStorage.setItem('configmessage', 'Fee Config saved successfully');


            //this._router.navigate(['/feeconfiguration']);

            var returnUrl = this._router.url;
            if (window.location.href.indexOf("feeconfiguration/a") > -1) {
              returnUrl = returnUrl.toString().replace('feeconfiguration/a', 'feeconfiguration');

            }
            else if (returnUrl.indexOf("feeconfiguration") > -1) {
              returnUrl = returnUrl.toString().replace('feeconfiguration', 'feeconfiguration/a');
            }

            this._router.navigate([returnUrl]);

            this._isFeeFunctionListFetching = false;
          }
          else {
            this._router.navigate(['login']);
          }
        });
      } catch (err) {
        this._isFeeFunctionListFetching = false;
      }
    }
  }

  checkDuplicateInObject(propertyName, inputArray): boolean {
    var seenDuplicate = false,
      testObject = {};

    inputArray.map(function (item) {
      var itemPropertyName = item[propertyName];
      if (itemPropertyName in testObject) {
        testObject[itemPropertyName].duplicate = true;
        item.duplicate = true;
        seenDuplicate = true;
      }
      else {
        testObject[itemPropertyName] = item;
        delete item.duplicate;
      }
    });

    return seenDuplicate;
  }
  showDeleteDialog(deleteRowIndex: number) {
    this.deleteRowIndex = deleteRowIndex;
    this.FeeTypeNameText = this.listfeeamount[deleteRowIndex].FeeTypeNameText
    this.FeeTypeGuID = this.listfeeamount[deleteRowIndex].FeeTypeGuID
    if (this.FeeTypeGuID != undefined && this.FeeTypeGuID != '') {
      var modalDelete = document.getElementById('myModalDelete');
      modalDelete.style.display = "block";
      $.getScript("/js/jsDrag.js");
    }
  }
  CloseDeletePopUp() {
    var modal = document.getElementById('myModalDelete');
    modal.style.display = "none";
  }

  showDeleteDialogFunction(deleteRowIndex: number) {
    this.deleteRowIndex = deleteRowIndex;
    this.FeeTypeNameText = this.listfeefunction[deleteRowIndex].FunctionNameText
    this.FeeTypeGuID = this.listfeefunction[deleteRowIndex].FunctionGuID
    if (this.FeeTypeGuID != undefined && this.FeeTypeGuID != '') {
      var modalDelete = document.getElementById('myModalDeleteFeeFunction');
      modalDelete.style.display = "block";
      $.getScript("/js/jsDrag.js");
    }
  }

  CloseDeletePopUpFeeFunction() {
    var modal = document.getElementById('myModalDeleteFeeFunction');
    modal.style.display = "none";
  }

  DeleteFeeScheduleConfig() {
    //if (this.listfeefunction != undefined)
    //{
    //    this._feeamountList.removeAt(0);
    //    this.listfeefunction.forEach((e) => {
    //        var checkexist = this.listfeeamount.filter(x => x.FeeFunctionID == e.FunctionNameID);
    //        if (checkexist != null && checkexist != undefined)
    //        {
    //            if (checkexist.length > 0) {
    //                this.listfeefunction.IsUsedInFeeSchedule = true;
    //            }
    //            else
    //            {
    //                this.listfeefunction.IsUsedInFeeSchedule = false;
    //            }

    //        }
    //    });
    //    this.callFeeAmount = true;
    //}





    try {
      this._isFeeFunctionListFetching = true;
      this.feeconfigurationSrv.DeleteScheduleConfig(this.FeeTypeGuID).subscribe(res => {
        if (res.Succeeded) {

          this._feeamountList.removeAt(this.deleteRowIndex);
          this.CloseDeletePopUp();

          this.callFeeAmount = true;

          //

          this._ShowmessagedivMsg = "Record deleted successfully."
          this._ShowSuccessmessagediv = true;

          setTimeout(() => {
            this._ShowSuccessmessagediv = false;
            this._ShowmessagedivMsg = "";
          }, 1000);

          this._isFeeFunctionListFetching = false;
        }
        else {
          this._router.navigate(['login']);
        }
      });
    } catch (err) {
      this._isFeeFunctionListFetching = false;
    }

  }

  DeleteFeeFunctionConfig() {
    try {
      this._isFeeFunctionListFetching = true;
      this.feeconfigurationSrv.DeleteFunctionConfig(this.FeeTypeGuID).subscribe(res => {
        if (res.Succeeded) {

          localStorage.setItem('showconfigmessage', 'true');
          localStorage.setItem('configmessage', 'Record deleted successfully');


          //this._router.navigate(['/feeconfiguration']);

          var returnUrl = this._router.url;
          if (window.location.href.indexOf("feeconfiguration/a") > -1) {
            returnUrl = returnUrl.toString().replace('feeconfiguration/a', 'feeconfiguration');

          }
          else if (returnUrl.indexOf("feeconfiguration") > -1) {
            returnUrl = returnUrl.toString().replace('feeconfiguration', 'feeconfiguration/a');
          }

          this._router.navigate([returnUrl]);



          //this._feefunctionList.removeAt(this.deleteRowIndex);
          //this.CloseDeletePopUp();
          //this._ShowmessagedivMsg = "Record deleted successfully."
          //this._ShowSuccessmessagediv = true;

          //setTimeout(() => {
          //    this._ShowSuccessmessagediv = false;
          //    this._ShowmessagedivMsg = "";
          //}, 3000);

          this._isFeeFunctionListFetching = false;
        }
        else {
          this._router.navigate(['login']);
        }
      });
    } catch (err) {
      this._isFeeFunctionListFetching = false;
    }

  }
}


const routes: Routes = [
  { path: '', component: FeeConfigurationComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjGridModule, WjGridFilterModule],
  declarations: [FeeConfigurationComponent]
})

export class feeConfigurationModule { }
