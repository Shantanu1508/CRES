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
Object.defineProperty(exports, "__esModule", { value: true });
exports.FeeConfigurationModule = exports.FeeConfigurationComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var wjcCore = require("wijmo/wijmo");
var wjcGrid = require("wijmo/wijmo.grid");
var utilityService_1 = require("../core/services/utilityService");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var PermissionService_1 = require("../core/services/PermissionService");
var feeconfigurationService_1 = require("../core/services/feeconfigurationService");
var dealservice_1 = require("../core/services/dealservice");
var noteService_1 = require("../core/services/noteService");
var FeeConfig_1 = require("../core/domain/FeeConfig");
var FeeConfigurationComponent = /** @class */ (function () {
    function FeeConfigurationComponent(_router, permissionService, utilityService, feeconfigurationSrv, dealSrv, noteService) {
        this._router = _router;
        this.permissionService = permissionService;
        this.utilityService = utilityService;
        this.feeconfigurationSrv = feeconfigurationSrv;
        this.dealSrv = dealSrv;
        this.noteService = noteService;
        //export class CalculationManagerComponent  {
        this.rowsToUpdate = [];
        this._Showmessagediv = false;
        this._ShowSuccessmessagediv = false;
        this._ShowmessagedivMsg = '';
        this.Message = '';
        this.callBaseAmount = true;
        this.callFeeAmount = true;
        this._feeConfig = new FeeConfig_1.FeeConfig();
        this.GetAllFeeFunction();
        this.utilityService.setPageTitle("M61–Fee Configuration");
        this.GetUserPermission();
        this.getFeeTypesFromFeeSchedulesConfig();
        //this.GetAllFeeAmount();
    }
    FeeConfigurationComponent.prototype.ngOnInit = function () {
        var _this = this;
        if (localStorage.getItem('showconfigmessage') == 'true') {
            this._ShowmessagedivMsg = localStorage.getItem('configmessage');
            this._ShowSuccessmessagediv = true;
            localStorage.setItem('showconfigmessage', JSON.stringify(false));
            localStorage.setItem('configmessage', JSON.stringify(''));
            setTimeout(function () {
                _this._ShowSuccessmessagediv = false;
                _this._ShowmessagedivMsg = "";
            }, 3000);
        }
    };
    // Component views are initialized
    FeeConfigurationComponent.prototype.ngAfterViewInit = function () {
    };
    FeeConfigurationComponent.prototype.GetAllFeeFunction = function () {
        var _this = this;
        if (this.callFeeAmount) {
            try {
                this.feeconfigurationSrv.GetAllFeeFunction().subscribe(function (res) {
                    if (res.Succeeded) {
                        _this.listfeefunction = [];
                        var data = res.lstFeeFunctionsConfig;
                        _this.listfeefunction = data;
                        _this.listfeefunctionfordropdown = data;
                        _this._feefunctionList = new wjcCore.CollectionView(_this.listfeefunction);
                        _this._feefunctionList.trackChanges = true;
                        _this.GetAllLookups();
                        setTimeout(function () {
                            this.flexfeefunction.invalidate();
                        }.bind(_this), 200);
                    }
                    else {
                        _this._router.navigate(['login']);
                    }
                });
            }
            catch (err) {
            }
            this.callFeeAmount = false;
        }
        else {
            setTimeout(function () {
                this.flexfeefunction.invalidate();
            }.bind(this), 200);
        }
    };
    FeeConfigurationComponent.prototype.GetAllFeeAmount = function () {
        var _this = this;
        if (this.callBaseAmount) {
            try {
                this.feeconfigurationSrv.GetAllFeeAmount().subscribe(function (res) {
                    if (res.Succeeded) {
                        _this.listfeeamount = [];
                        var data = res.lstFeeSchedulesConfig;
                        _this.listfeeamount = data;
                        _this._feeamountList = new wjcCore.CollectionView(_this.listfeeamount);
                        _this._feeamountList.trackChanges = true;
                        _this.callBaseAmount = false;
                        setTimeout(function () {
                            this.flexfeeamount.invalidate();
                        }.bind(_this), 200);
                        // this.GetAllLookups();
                    }
                    else {
                        _this._router.navigate(['login']);
                    }
                });
            }
            catch (err) {
            }
            this.callFeeAmount = true;
        }
        setTimeout(function () {
            this.flexfeeamount.invalidate();
        }.bind(this), 200);
    };
    FeeConfigurationComponent.prototype.GetUserPermission = function () {
        try {
            this.permissionService.GetUserPermissionByPagename("FeeConfiguration").subscribe(function (res) {
                if (res.Succeeded) {
                    if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                        var _object = res.UserPermissionList;
                        var controlarrayedit = _object.filter(function (item) { return item.ModuleType === 'Control' && item.RightsName === 'Edit'; });
                        //for (var i = 0; i < controlarrayedit.length; i++) {
                        //    if (controlarrayedit[i].ChildModule == 'btnCalculationManagerDownloadCashflows') {
                        //        this._isShowDownloadCashflows = true;
                        //    }
                        //}
                    }
                }
            });
        }
        catch (err) {
            alert(err);
        }
    };
    FeeConfigurationComponent.prototype.GetAllLookups = function () {
        var _this = this;
        this.dealSrv.getAllLookup().subscribe(function (res) {
            var data = res.lstLookups;
            _this.lastFunctionType = data.filter(function (x) { return x.ParentID == "84"; });
            _this.lastPaymentFrequency = data.filter(function (x) { return x.ParentID == "85"; });
            _this.lstAccrualBasis = data.filter(function (x) { return x.ParentID == "86"; });
            _this.lstAccrualStartDate = data.filter(function (x) { return x.ParentID == "87"; });
            _this.lstAccrualPeriod = data.filter(function (x) { return x.ParentID == "88"; });
            _this.lstFeePaymentFrequency = data.filter(function (x) { return x.ParentID == "89"; });
            _this.lstFeeCoveragePeriod = data.filter(function (x) { return x.ParentID == "90"; });
            _this.lstTotalCommitment = data.filter(function (x) { return x.ParentID == "91"; });
            _this.lstUnscheduledPaydowns = data.filter(function (x) { return x.ParentID == "92"; });
            _this.lstFeeTrans = data.filter(function (x) { return x.ParentID == "94"; });
            _this.lstPrepayAdditinalFee_ValueType = _this.lstFeeTypeLookUp;
            //set dropdown for
            _this.lstInitialFunding = data.filter(function (x) { return x.ParentID == "91"; });
            _this._bindGridDropdows();
        });
    };
    // apply/remove data maps
    FeeConfigurationComponent.prototype._bindGridDropdows = function () {
        //alert('_updateDataMaps');
        var flexfeefunction = this.flexfeefunction;
        var flexfeeamount = this.flexfeeamount;
        if (flexfeefunction) {
            var colRateType = flexfeefunction.columns.getColumn('FunctionTypeText');
            if (colRateType) {
                colRateType.showDropDown = true; // show drop-down for countries
                colRateType.dataMap = this._buildDataMap(this.lastFunctionType);
            }
            var colStatus = flexfeefunction.columns.getColumn('PaymentFrequencyText');
            if (colStatus) {
                colStatus.showDropDown = true; // show drop-down for countries
                colStatus.dataMap = this._buildDataMap(this.lastPaymentFrequency);
            }
            var colRateType = flexfeefunction.columns.getColumn('AccrualBasisText');
            if (colRateType) {
                colRateType.showDropDown = true; // show drop-down for countries
                colRateType.dataMap = this._buildDataMap(this.lstAccrualBasis);
            }
            var colRateType = flexfeefunction.columns.getColumn('AccrualStartDateText');
            if (colRateType) {
                colRateType.showDropDown = true; // show drop-down for countries
                colRateType.dataMap = this._buildDataMap(this.lstAccrualStartDate);
            }
            var colRateType = flexfeefunction.columns.getColumn('AccrualPeriodText');
            if (colRateType) {
                colRateType.showDropDown = true; // show drop-down for countries
                colRateType.dataMap = this._buildDataMap(this.lstAccrualPeriod);
            }
        }
        if (flexfeeamount) {
            var colRateType = flexfeeamount.columns.getColumn('FeePaymentFrequencyText');
            if (colRateType) {
                colRateType.showDropDown = true; // show drop-down for countries
                colRateType.dataMap = this._buildDataMap(this.lstFeePaymentFrequency);
            }
            var colRateType = flexfeeamount.columns.getColumn('FeeCoveragePeriodText');
            if (colRateType) {
                colRateType.showDropDown = true; // show drop-down for countries
                colRateType.dataMap = this._buildDataMap(this.lstFeeCoveragePeriod);
            }
            var colRateType = flexfeeamount.columns.getColumn('FeeFunctionText'); // FeeFunctionText
            if (colRateType) {
                colRateType.showDropDown = true; // show drop-down for countries
                colRateType.dataMap = this._buildDataMap(this.listfeefunctionfordropdown);
            }
            var colRateType = flexfeeamount.columns.getColumn('TotalCommitmentText');
            if (colRateType) {
                colRateType.showDropDown = true; // show drop-down for countries
                colRateType.dataMap = this._buildDataMap(this.lstTotalCommitment);
            }
            var colRateType = flexfeeamount.columns.getColumn('UnscheduledPaydownsText');
            if (colRateType) {
                colRateType.showDropDown = true; // show drop-down for countries
                colRateType.dataMap = this._buildDataMap(this.lstTotalCommitment);
            }
            var colRateType = flexfeeamount.columns.getColumn('BalloonPaymentText');
            if (colRateType) {
                colRateType.showDropDown = true; // show drop-down for countries
                colRateType.dataMap = this._buildDataMap(this.lstTotalCommitment);
            }
            var colRateType = flexfeeamount.columns.getColumn('LoanFundingsText');
            if (colRateType) {
                colRateType.showDropDown = true; // show drop-down for countries
                colRateType.dataMap = this._buildDataMap(this.lstTotalCommitment);
            }
            var colRateType = flexfeeamount.columns.getColumn('ScheduledPrincipalAmortizationPaymentText');
            if (colRateType) {
                colRateType.showDropDown = true; // show drop-down for countries
                colRateType.dataMap = this._buildDataMap(this.lstTotalCommitment);
            }
            var colRateType = flexfeeamount.columns.getColumn('CurrentLoanBalanceText');
            if (colRateType) {
                colRateType.showDropDown = true; // show drop-down for countries
                colRateType.dataMap = this._buildDataMap(this.lstTotalCommitment);
            }
            var colRateType = flexfeeamount.columns.getColumn('InterestPaymentText');
            if (colRateType) {
                colRateType.showDropDown = true; // show drop-down for countries
                colRateType.dataMap = this._buildDataMap(this.lstTotalCommitment);
            }
            var colRateType = flexfeeamount.columns.getColumn('FeeNameTransText');
            if (colRateType) {
                colRateType.showDropDown = true; // show drop-down for eeNameTrans
                colRateType.dataMap = this._buildDataMap(this.lstFeeTrans);
            }
            var colRateType = flexfeeamount.columns.getColumn('InitialFundingText');
            if (colRateType) {
                colRateType.showDropDown = true; // show drop-down for countries
                colRateType.dataMap = this._buildDataMap(this.lstInitialFunding);
            }
            var colM61AdjustedCommitmentType = flexfeeamount.columns.getColumn('M61AdjustedCommitmentText');
            if (colM61AdjustedCommitmentType) {
                colM61AdjustedCommitmentType.showDropDown = true; // show drop-down for countries
                colM61AdjustedCommitmentType.dataMap = this._buildDataMap(this.lstTotalCommitment);
            }
        }
    };
    FeeConfigurationComponent.prototype.getFeeTypesFromFeeSchedulesConfig = function () {
        var _this = this;
        this.noteService.getFeeTypesFromFeeSchedulesConfig().subscribe(function (res) {
            if (res.Succeeded) {
                _this.lstFeeTypeLookUp = res.lstFeeTypeLookUp;
            }
        });
    };
    // build a data map from a string array using the indices as keys
    FeeConfigurationComponent.prototype._buildDataMap = function (items) {
        var map = [];
        for (var i = 0; i < items.length; i++) {
            var obj = items[i];
            map.push({ key: obj['LookupID'], value: obj['Name'] });
        }
        return new wjcGrid.DataMap(map, 'key', 'value');
    };
    FeeConfigurationComponent.prototype.deletefeefunction = function (e) {
        e.cancel = true;
    };
    FeeConfigurationComponent.prototype.Copiedfeefunction = function (flexfeefunction, e) {
    };
    FeeConfigurationComponent.prototype.SaveFeeConfig = function () {
        var _this = this;
        var isduplicatefunctionName = false;
        var isduplicatefeetypeName = false;
        this._isFeeFunctionListFetching = true;
        //fee function save
        //fee amount save
        if (this.listfeefunction != undefined) {
            this.listfeefunction = this.listfeefunction.filter(function (x) { return (x.FunctionNameText != null && x.FunctionNameText != ""); });
            for (var i = 0; i < this.listfeefunction.length; i++) {
                if (!(Number(this.listfeefunction[i].FunctionTypeText).toString() == "NaN" || Number(this.listfeefunction[i].FunctionTypeText) == 0)) {
                    this.listfeefunction[i].FunctionTypeID = Number(this.listfeefunction[i].FunctionTypeText);
                    this.listfeefunction[i].FunctionTypeText = this.lastFunctionType.find(function (x) { return x.LookupID == _this.listfeefunction[i].FunctionTypeID; }).Name;
                }
                else {
                    var filteredarray = this.lastFunctionType.filter(function (x) { return x.Name == _this.listfeefunction[i].FunctionTypeText; });
                    if (filteredarray.length != 0) {
                        this.listfeefunction[i].FunctionTypeID = Number(filteredarray[0].LookupID);
                    }
                }
                if (!(Number(this.listfeefunction[i].PaymentFrequencyText).toString() == "NaN" || Number(this.listfeefunction[i].PaymentFrequencyText) == 0)) {
                    this.listfeefunction[i].PaymentFrequencyID = Number(this.listfeefunction[i].PaymentFrequencyText);
                    this.listfeefunction[i].PaymentFrequencyText = this.lastPaymentFrequency.find(function (x) { return x.LookupID == _this.listfeefunction[i].PaymentFrequencyID; }).Name;
                }
                else {
                    var filteredarray = this.lastPaymentFrequency.filter(function (x) { return x.Name == _this.listfeefunction[i].PaymentFrequencyText; });
                    if (filteredarray.length != 0) {
                        this.listfeefunction[i].PaymentFrequencyID = Number(filteredarray[0].LookupID);
                    }
                }
                if (!(Number(this.listfeefunction[i].AccrualBasisText).toString() == "NaN" || Number(this.listfeefunction[i].AccrualBasisText) == 0)) {
                    this.listfeefunction[i].AccrualBasisID = Number(this.listfeefunction[i].AccrualBasisText);
                    this.listfeefunction[i].AccrualBasisText = this.lstAccrualBasis.find(function (x) { return x.LookupID == _this.listfeefunction[i].AccrualBasisID; }).Name;
                }
                else {
                    var filteredarray = this.lstAccrualBasis.filter(function (x) { return x.Name == _this.listfeefunction[i].AccrualBasisText; });
                    if (filteredarray.length != 0) {
                        this.listfeefunction[i].AccrualBasisID = Number(filteredarray[0].LookupID);
                    }
                }
                if (!(Number(this.listfeefunction[i].AccrualStartDateText).toString() == "NaN" || Number(this.listfeefunction[i].AccrualStartDateText) == 0)) {
                    this.listfeefunction[i].AccrualStartDateID = Number(this.listfeefunction[i].AccrualStartDateText);
                    this.listfeefunction[i].AccrualStartDateText = this.lstAccrualStartDate.find(function (x) { return x.LookupID == _this.listfeefunction[i].AccrualStartDateID; }).Name;
                }
                else {
                    var filteredarray = this.lstAccrualStartDate.filter(function (x) { return x.Name == _this.listfeefunction[i].AccrualStartDateText; });
                    if (filteredarray.length != 0) {
                        this.listfeefunction[i].AccrualStartDateID = Number(filteredarray[0].LookupID);
                    }
                }
                if (!(Number(this.listfeefunction[i].AccrualPeriodText).toString() == "NaN" || Number(this.listfeefunction[i].AccrualPeriodText) == 0)) {
                    this.listfeefunction[i].AccrualPeriodID = Number(this.listfeefunction[i].AccrualPeriodText);
                    this.listfeefunction[i].AccrualPeriodText = this.lstAccrualPeriod.find(function (x) { return x.LookupID == _this.listfeefunction[i].AccrualPeriodID; }).Name;
                }
                else {
                    var filteredarray = this.lstAccrualPeriod.filter(function (x) { return x.Name == _this.listfeefunction[i].AccrualPeriodText; });
                    if (filteredarray.length != 0) {
                        this.listfeefunction[i].AccrualPeriodID = Number(filteredarray[0].LookupID);
                    }
                }
            }
            this._feeConfig.lstFeeFunctionsConfig = this.listfeefunction;
            isduplicatefunctionName = this.checkDuplicateInObject("FunctionNameText", this._feeConfig.lstFeeFunctionsConfig);
        }
        if (this.listfeeamount != undefined) {
            this.listfeeamount = this.listfeeamount.filter(function (x) { return (x.FeeTypeNameText != null && x.FeeTypeNameText != ""); });
            for (var i = 0; i < this.listfeeamount.length; i++) {
                if (!(Number(this.listfeeamount[i].FeePaymentFrequencyText).toString() == "NaN" || Number(this.listfeeamount[i].FeePaymentFrequencyText) == 0)) {
                    this.listfeeamount[i].FeePaymentFrequencyID = Number(this.listfeeamount[i].FeePaymentFrequencyText);
                    this.listfeeamount[i].FeePaymentFrequencyText = this.lstFeePaymentFrequency.find(function (x) { return x.LookupID == _this.listfeeamount[i].FeePaymentFrequencyID; }).Name;
                }
                else {
                    var filteredarray = this.lstFeePaymentFrequency.filter(function (x) { return x.Name == _this.listfeeamount[i].FeePaymentFrequencyText; });
                    if (filteredarray.length != 0) {
                        this.listfeeamount[i].FeePaymentFrequencyID = Number(filteredarray[0].LookupID);
                    }
                }
                if (!(Number(this.listfeeamount[i].FeeCoveragePeriodText).toString() == "NaN" || Number(this.listfeeamount[i].FeeCoveragePeriodText) == 0)) {
                    this.listfeeamount[i].FeeCoveragePeriodID = Number(this.listfeeamount[i].FeeCoveragePeriodText);
                    this.listfeeamount[i].FeeCoveragePeriodText = this.lstFeeCoveragePeriod.find(function (x) { return x.LookupID == _this.listfeeamount[i].FeeCoveragePeriodID; }).Name;
                }
                else {
                    var filteredarray = this.lstFeeCoveragePeriod.filter(function (x) { return x.Name == _this.listfeeamount[i].FeeCoveragePeriodText; });
                    if (filteredarray.length != 0) {
                        this.listfeeamount[i].FeeCoveragePeriodID = Number(filteredarray[0].LookupID);
                    }
                }
                if (!(Number(this.listfeeamount[i].FeeFunctionText).toString() == "NaN" || Number(this.listfeeamount[i].FeeFunctionText) == 0)) {
                    this.listfeeamount[i].FeeFunctionID = Number(this.listfeeamount[i].FeeFunctionText);
                    this.listfeeamount[i].FeeFunctionText = this.listfeefunction.find(function (x) { return x.FunctionNameID == _this.listfeeamount[i].FeeFunctionID; }).FunctionNameText;
                }
                else {
                    var filteredarray = this.listfeefunction.filter(function (x) { return x.FunctionNameText == _this.listfeeamount[i].FeeFunctionText; });
                    if (filteredarray.length != 0) {
                        this.listfeeamount[i].FeeFunctionID = Number(filteredarray[0].FunctionNameID);
                    }
                }
                if (!(Number(this.listfeeamount[i].TotalCommitmentText).toString() == "NaN" || Number(this.listfeeamount[i].TotalCommitmentText) == 0)) {
                    this.listfeeamount[i].TotalCommitmentID = Number(this.listfeeamount[i].TotalCommitmentText);
                    this.listfeeamount[i].TotalCommitmentText = this.lstTotalCommitment.find(function (x) { return x.LookupID == _this.listfeeamount[i].TotalCommitmentID; }).Name;
                }
                else {
                    var filteredarray = this.lstTotalCommitment.filter(function (x) { return x.Name == _this.listfeeamount[i].TotalCommitmentText; });
                    if (filteredarray.length != 0) {
                        this.listfeeamount[i].TotalCommitmentID = Number(filteredarray[0].LookupID);
                    }
                }
                if (!(Number(this.listfeeamount[i].UnscheduledPaydownsText).toString() == "NaN" || Number(this.listfeeamount[i].UnscheduledPaydownsText) == 0)) {
                    this.listfeeamount[i].UnscheduledPaydownsID = Number(this.listfeeamount[i].UnscheduledPaydownsText);
                    this.listfeeamount[i].UnscheduledPaydownsText = this.lstTotalCommitment.find(function (x) { return x.LookupID == _this.listfeeamount[i].UnscheduledPaydownsID; }).Name;
                }
                else {
                    var filteredarray = this.lstTotalCommitment.filter(function (x) { return x.Name == _this.listfeeamount[i].UnscheduledPaydownsText; });
                    if (filteredarray.length != 0) {
                        this.listfeeamount[i].UnscheduledPaydownsID = Number(filteredarray[0].LookupID);
                    }
                }
                if (!(Number(this.listfeeamount[i].BalloonPaymentText).toString() == "NaN" || Number(this.listfeeamount[i].BalloonPaymentText) == 0)) {
                    this.listfeeamount[i].BalloonPaymentID = Number(this.listfeeamount[i].BalloonPaymentText);
                    this.listfeeamount[i].BalloonPaymentText = this.lstTotalCommitment.find(function (x) { return x.LookupID == _this.listfeeamount[i].BalloonPaymentID; }).Name;
                }
                else {
                    var filteredarray = this.lstTotalCommitment.filter(function (x) { return x.Name == _this.listfeeamount[i].BalloonPaymentText; });
                    if (filteredarray.length != 0) {
                        this.listfeeamount[i].BalloonPaymentID = Number(filteredarray[0].LookupID);
                    }
                }
                if (!(Number(this.listfeeamount[i].LoanFundingsText).toString() == "NaN" || Number(this.listfeeamount[i].LoanFundingsText) == 0)) {
                    this.listfeeamount[i].LoanFundingsID = Number(this.listfeeamount[i].LoanFundingsText);
                    this.listfeeamount[i].LoanFundingsText = this.lstTotalCommitment.find(function (x) { return x.LookupID == _this.listfeeamount[i].LoanFundingsID; }).Name;
                }
                else {
                    var filteredarray = this.lstTotalCommitment.filter(function (x) { return x.Name == _this.listfeeamount[i].LoanFundingsText; });
                    if (filteredarray.length != 0) {
                        this.listfeeamount[i].LoanFundingsID = Number(filteredarray[0].LookupID);
                    }
                }
                if (!(Number(this.listfeeamount[i].ScheduledPrincipalAmortizationPaymentText).toString() == "NaN" || Number(this.listfeeamount[i].ScheduledPrincipalAmortizationPaymentText) == 0)) {
                    this.listfeeamount[i].ScheduledPrincipalAmortizationPaymentID = Number(this.listfeeamount[i].ScheduledPrincipalAmortizationPaymentText);
                    this.listfeeamount[i].ScheduledPrincipalAmortizationPaymentText = this.lstTotalCommitment.find(function (x) { return x.LookupID == _this.listfeeamount[i].ScheduledPrincipalAmortizationPaymentID; }).Name;
                }
                else {
                    var filteredarray = this.lstTotalCommitment.filter(function (x) { return x.Name == _this.listfeeamount[i].ScheduledPrincipalAmortizationPaymentText; });
                    if (filteredarray.length != 0) {
                        this.listfeeamount[i].ScheduledPrincipalAmortizationPaymentID = Number(filteredarray[0].LookupID);
                    }
                }
                if (!(Number(this.listfeeamount[i].CurrentLoanBalanceText).toString() == "NaN" || Number(this.listfeeamount[i].CurrentLoanBalanceText) == 0)) {
                    this.listfeeamount[i].CurrentLoanBalanceID = Number(this.listfeeamount[i].CurrentLoanBalanceText);
                    this.listfeeamount[i].CurrentLoanBalanceText = this.lstTotalCommitment.find(function (x) { return x.LookupID == _this.listfeeamount[i].CurrentLoanBalanceID; }).Name;
                }
                else {
                    var filteredarray = this.lstTotalCommitment.filter(function (x) { return x.Name == _this.listfeeamount[i].CurrentLoanBalanceText; });
                    if (filteredarray.length != 0) {
                        this.listfeeamount[i].CurrentLoanBalanceID = Number(filteredarray[0].LookupID);
                    }
                }
                if (!(Number(this.listfeeamount[i].InterestPaymentText).toString() == "NaN" || Number(this.listfeeamount[i].InterestPaymentText) == 0)) {
                    this.listfeeamount[i].InterestPaymentID = Number(this.listfeeamount[i].InterestPaymentText);
                    this.listfeeamount[i].InterestPaymentText = this.lstTotalCommitment.find(function (x) { return x.LookupID == _this.listfeeamount[i].InterestPaymentID; }).Name;
                }
                else {
                    var filteredarray = this.lstTotalCommitment.filter(function (x) { return x.Name == _this.listfeeamount[i].InterestPaymentText; });
                    if (filteredarray.length != 0) {
                        this.listfeeamount[i].InterestPaymentID = Number(filteredarray[0].LookupID);
                    }
                }
                if (!(Number(this.listfeeamount[i].FeeNameTransText).toString() == "NaN" || Number(this.listfeeamount[i].FeeNameTransText) == 0)) {
                    this.listfeeamount[i].FeeNameTransID = Number(this.listfeeamount[i].FeeNameTransText);
                    this.listfeeamount[i].FeeNameTransText = this.lstFeeTrans.find(function (x) { return x.LookupID == _this.listfeeamount[i].FeeNameTransID; }).Name;
                }
                else {
                    var filteredarray = this.lstTotalCommitment.filter(function (x) { return x.Name == _this.listfeeamount[i].FeeNameTransText; });
                    if (filteredarray.length != 0) {
                        this.listfeeamount[i].FeeNameTransID = Number(filteredarray[0].LookupID);
                    }
                }
                if (!(Number(this.listfeeamount[i].InitialFundingText).toString() == "NaN" || Number(this.listfeeamount[i].InitialFundingText) == 0)) {
                    this.listfeeamount[i].InitialFundingID = Number(this.listfeeamount[i].InitialFundingText);
                    this.listfeeamount[i].InitialFundingText = this.lstInitialFunding.find(function (x) { return x.LookupID == _this.listfeeamount[i].InitialFundingID; }).Name;
                }
                else {
                    var filteredarray = this.lstInitialFunding.filter(function (x) { return x.Name == _this.listfeeamount[i].InitialFundingText; });
                    if (filteredarray.length != 0) {
                        this.listfeeamount[i].InitialFundingID = Number(filteredarray[0].LookupID);
                    }
                }
                if (!(Number(this.listfeeamount[i].M61AdjustedCommitmentText).toString() == "NaN" || Number(this.listfeeamount[i].M61AdjustedCommitmentText) == 0)) {
                    this.listfeeamount[i].M61AdjustedCommitmentID = Number(this.listfeeamount[i].M61AdjustedCommitmentText);
                    this.listfeeamount[i].M61AdjustedCommitmentText = this.lstTotalCommitment.find(function (x) { return x.LookupID == _this.listfeeamount[i].M61AdjustedCommitmentID; }).Name;
                }
                else {
                    var filteredarray = this.lstTotalCommitment.filter(function (x) { return x.Name == _this.listfeeamount[i].M61AdjustedCommitmentText; });
                    if (filteredarray.length != 0) {
                        this.listfeeamount[i].M61AdjustedCommitmentID = Number(filteredarray[0].LookupID);
                    }
                }
            }
            this._feeConfig.lstFeeSchedulesConfig = this.listfeeamount;
            isduplicatefeetypeName = this.checkDuplicateInObject("FeeTypeNameText", this._feeConfig.lstFeeSchedulesConfig);
        }
        if (isduplicatefunctionName) {
            this.Message = "Duplicate fee function name.Please enter unique name";
            this._Showmessagediv = true;
        }
        else if (isduplicatefeetypeName) {
            this.Message = "Duplicate fee type name.Please enter unique name";
            this._Showmessagediv = true;
        }
        if (isduplicatefunctionName == true || isduplicatefeetypeName == true) {
            this._isFeeFunctionListFetching = false;
            setTimeout(function () {
                _this._Showmessagediv = false;
                _this.Message = "";
            }, 3000);
        }
        else {
            try {
                this.feeconfigurationSrv.SaveFeeConfig(this._feeConfig).subscribe(function (res) {
                    if (res.Succeeded) {
                        _this.callBaseAmount = true;
                        localStorage.setItem('showconfigmessage', 'true');
                        localStorage.setItem('configmessage', 'Fee Config saved successfully');
                        //this._router.navigate(['/feeconfiguration']);
                        var returnUrl = _this._router.url;
                        if (window.location.href.indexOf("feeconfiguration/a") > -1) {
                            returnUrl = returnUrl.toString().replace('feeconfiguration/a', 'feeconfiguration');
                        }
                        else if (returnUrl.indexOf("feeconfiguration") > -1) {
                            returnUrl = returnUrl.toString().replace('feeconfiguration', 'feeconfiguration/a');
                        }
                        _this._router.navigate([returnUrl]);
                        _this._isFeeFunctionListFetching = false;
                    }
                    else {
                        _this._router.navigate(['login']);
                    }
                });
            }
            catch (err) {
                this._isFeeFunctionListFetching = false;
            }
        }
    };
    FeeConfigurationComponent.prototype.checkDuplicateInObject = function (propertyName, inputArray) {
        var seenDuplicate = false, testObject = {};
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
    };
    FeeConfigurationComponent.prototype.showDeleteDialog = function (deleteRowIndex) {
        this.deleteRowIndex = deleteRowIndex;
        this.FeeTypeNameText = this.listfeeamount[deleteRowIndex].FeeTypeNameText;
        this.FeeTypeGuID = this.listfeeamount[deleteRowIndex].FeeTypeGuID;
        if (this.FeeTypeGuID != undefined && this.FeeTypeGuID != '') {
            var modalDelete = document.getElementById('myModalDelete');
            modalDelete.style.display = "block";
            $.getScript("/js/jsDrag.js");
        }
    };
    FeeConfigurationComponent.prototype.CloseDeletePopUp = function () {
        var modal = document.getElementById('myModalDelete');
        modal.style.display = "none";
    };
    FeeConfigurationComponent.prototype.showDeleteDialogFunction = function (deleteRowIndex) {
        this.deleteRowIndex = deleteRowIndex;
        this.FeeTypeNameText = this.listfeefunction[deleteRowIndex].FunctionNameText;
        this.FeeTypeGuID = this.listfeefunction[deleteRowIndex].FunctionGuID;
        if (this.FeeTypeGuID != undefined && this.FeeTypeGuID != '') {
            var modalDelete = document.getElementById('myModalDeleteFeeFunction');
            modalDelete.style.display = "block";
            $.getScript("/js/jsDrag.js");
        }
    };
    FeeConfigurationComponent.prototype.CloseDeletePopUpFeeFunction = function () {
        var modal = document.getElementById('myModalDeleteFeeFunction');
        modal.style.display = "none";
    };
    FeeConfigurationComponent.prototype.DeleteFeeScheduleConfig = function () {
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
        var _this = this;
        //        }
        //    });
        //    this.callFeeAmount = true;
        //}
        try {
            this._isFeeFunctionListFetching = true;
            this.feeconfigurationSrv.DeleteScheduleConfig(this.FeeTypeGuID).subscribe(function (res) {
                if (res.Succeeded) {
                    _this._feeamountList.removeAt(_this.deleteRowIndex);
                    _this.CloseDeletePopUp();
                    _this.callFeeAmount = true;
                    //
                    _this._ShowmessagedivMsg = "Record deleted successfully.";
                    _this._ShowSuccessmessagediv = true;
                    setTimeout(function () {
                        _this._ShowSuccessmessagediv = false;
                        _this._ShowmessagedivMsg = "";
                    }, 1000);
                    _this._isFeeFunctionListFetching = false;
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
            this._isFeeFunctionListFetching = false;
        }
    };
    FeeConfigurationComponent.prototype.DeleteFeeFunctionConfig = function () {
        var _this = this;
        try {
            this._isFeeFunctionListFetching = true;
            this.feeconfigurationSrv.DeleteFunctionConfig(this.FeeTypeGuID).subscribe(function (res) {
                if (res.Succeeded) {
                    localStorage.setItem('showconfigmessage', 'true');
                    localStorage.setItem('configmessage', 'Record deleted successfully');
                    //this._router.navigate(['/feeconfiguration']);
                    var returnUrl = _this._router.url;
                    if (window.location.href.indexOf("feeconfiguration/a") > -1) {
                        returnUrl = returnUrl.toString().replace('feeconfiguration/a', 'feeconfiguration');
                    }
                    else if (returnUrl.indexOf("feeconfiguration") > -1) {
                        returnUrl = returnUrl.toString().replace('feeconfiguration', 'feeconfiguration/a');
                    }
                    _this._router.navigate([returnUrl]);
                    //this._feefunctionList.removeAt(this.deleteRowIndex);
                    //this.CloseDeletePopUp();
                    //this._ShowmessagedivMsg = "Record deleted successfully."
                    //this._ShowSuccessmessagediv = true;
                    //setTimeout(() => {
                    //    this._ShowSuccessmessagediv = false;
                    //    this._ShowmessagedivMsg = "";
                    //}, 3000);
                    _this._isFeeFunctionListFetching = false;
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
            this._isFeeFunctionListFetching = false;
        }
    };
    var _a, _b, _c;
    __decorate([
        (0, core_1.ViewChild)('flexfeefunction'),
        __metadata("design:type", typeof (_a = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _a : Object)
    ], FeeConfigurationComponent.prototype, "flexfeefunction", void 0);
    __decorate([
        (0, core_1.ViewChild)('flexfeeamount'),
        __metadata("design:type", typeof (_b = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _b : Object)
    ], FeeConfigurationComponent.prototype, "flexfeeamount", void 0);
    FeeConfigurationComponent = __decorate([
        (0, core_1.Component)({
            templateUrl: "app/components/feeconfiguration.html?v=" + $.getVersion(),
            providers: [noteService_1.NoteService, dealservice_1.dealService, feeconfigurationService_1.feeconfigurationService, PermissionService_1.PermissionService]
        }),
        __metadata("design:paramtypes", [typeof (_c = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _c : Object, PermissionService_1.PermissionService,
            utilityService_1.UtilityService,
            feeconfigurationService_1.feeconfigurationService,
            dealservice_1.dealService,
            noteService_1.NoteService])
    ], FeeConfigurationComponent);
    return FeeConfigurationComponent;
}());
exports.FeeConfigurationComponent = FeeConfigurationComponent;
var routes = [
    { path: '', component: FeeConfigurationComponent }
];
var FeeConfigurationModule = /** @class */ (function () {
    function FeeConfigurationModule() {
    }
    FeeConfigurationModule = __decorate([
        (0, core_2.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule],
            declarations: [FeeConfigurationComponent]
        })
    ], FeeConfigurationModule);
    return FeeConfigurationModule;
}());
exports.FeeConfigurationModule = FeeConfigurationModule;
//# sourceMappingURL=feeconfiguration.component.js.map