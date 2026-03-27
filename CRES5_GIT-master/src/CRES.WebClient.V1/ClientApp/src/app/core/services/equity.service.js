"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.equityService = void 0;
var equityService = /** @class */ (function () {
    /*  private _accountGetHolidayListAPI: string = 'api/account/GetHolidayList';*/
    function equityService(accountService) {
        this.accountService = accountService;
        this._equityGetAllLookupAPI = 'api/equity/getallLookup';
        this._equityAddEquityAPI = 'api/equity/addnewequity';
        this._getEquityByEquityIdAPI = 'api/equity/getequitybyequityId';
        this._getassociateddebtdataByEquityIdAPI = 'api/equity/getassociateddebtdataByEquityId';
        this._GetEquityNoteAPI = 'api/equity/getEquityNoteByLiabilityTypeID';
        this._GetEquityFundingSchedulAPI = 'api/liabilityNote/getLiabilityFundingScheduleByLiabilityTypeID';
        this._getAutosuggestDebtNameSublineAPI = 'api/search/getAutosuggestDebtNameSubline';
        this._GetEquityJournalLedgerbyJournalEntryMasterIDAPI = 'api/equity/GetEquityJournalLedgerbyJournalEntryMasterID';
        this._getHistoricalDataOfLiabilityModuleByAccountIdAPI = 'api/equity/GetHistoricalDataOfModuleByAccountId_Liability';
        this._checkduplicateforliabilitesAPI = 'api/equity/checkduplicateforliabilities';
        this._GetEquityTransactionByEquityAccountIDAPI = 'api/equity/GetEquityTransactionByEquityAccountID';
        this._QueueEquityForCalculationAPI = 'api/equity/queueEquityForCalculation';
        this._getEquityCalcInfoByEquityAccountIDAPI = 'api/equity/getEquityCalcInfoByEquityAccountID';
        this._getEquityCashflowsExportDataAPI = 'api/equity/getEquityCashflowsExportExcel';
        this._getEquityCapContriExportDataAPI = 'api/equity/getEquityCapitalContributionExportExcel';
        this._getDealLevelLiabilityFundingScheduleTypeIDAPI = 'api/liabilityNote/getDealLevelLiabilityFundingScheduleTypeID';
        /*  private _accountGetHolidayListAPI: string = 'api/account/GetHolidayList';*/
        this._getLiabilityCalcExcelBLOBData = 'api/equity/getliabilitycalcExcelBlobData';
        this._getCashAccountAPI = 'api/equity/getCashAccount';
        this._getLiabilityCalculationStatus = 'api/equity/getLiabilityCalculationStatus';
        this._getLiabilityCalculationStatusForDashBoard = 'api/equity/getLiabilityCalculationStatusForDashBoard';
        this._getLiabilitySummaryDashBoard = 'api/equity/getLiabilitySummaryDashBoard';
        this._getExportExcelLiabilitySummaryDashBoard = 'api/equity/GetExportExcelLiabilitySummaryDashBoard';
        this._queueEquityListForCalculationAPI = 'api/equity/queueEquityListForCalculation';
    }
    equityService.prototype.getAllLookup = function () {
        this.accountService.set(this._equityGetAllLookupAPI);
        return this.accountService.getAll();
    };
    equityService.prototype.Saveequity = function (equity) {
        this.accountService.set(this._equityAddEquityAPI);
        return this.accountService.post(JSON.stringify(equity));
    };
    equityService.prototype.EquityByEquityId = function (equity) {
        this.accountService.set(this._getEquityByEquityIdAPI);
        return this.accountService.post(JSON.stringify(equity));
    };
    equityService.prototype.GetAssociatedDebtDataByEquityId = function (equity) {
        this.accountService.set(this._getassociateddebtdataByEquityIdAPI);
        return this.accountService.post(JSON.stringify(equity));
    };
    equityService.prototype.GetEquityNoteByLiabilityTypeID = function (LiabilityTypeID) {
        this.accountService.set(this._GetEquityNoteAPI);
        return this.accountService.post(JSON.stringify(LiabilityTypeID));
    };
    equityService.prototype.GetEquityFundingScheduleByLiabilityTypeID = function (LiabilityTypeID) {
        this.accountService.set(this._GetEquityFundingSchedulAPI);
        return this.accountService.post(JSON.stringify(LiabilityTypeID));
    };
    equityService.prototype.GetAutosuggestDebtNameSubline = function (searchkey) {
        this.accountService.set(this._getAutosuggestDebtNameSublineAPI);
        return this.accountService.post(JSON.stringify(searchkey));
    };
    equityService.prototype.GetEquityJournalLedgerbyJournalEntryMasterID = function (EquityAccountID) {
        this.accountService.set(this._GetEquityJournalLedgerbyJournalEntryMasterIDAPI);
        return this.accountService.post(JSON.stringify(EquityAccountID));
    };
    equityService.prototype.GetHistoricalDataOfLiabilityModuleByAccountIdAPI = function (_equity, pagesIndex, pagesSize) {
        this.accountService.set(this._getHistoricalDataOfLiabilityModuleByAccountIdAPI, pagesIndex, pagesSize);
        return this.accountService.post(JSON.stringify(_equity));
    };
    equityService.prototype.CheckDuplicateforLiabilities = function (_equity) {
        this.accountService.set(this._checkduplicateforliabilitesAPI);
        return this.accountService.post(JSON.stringify(_equity));
    };
    equityService.prototype.GetEquityTransactionByEquityAccountID = function (EquityAccountID) {
        this.accountService.set(this._GetEquityTransactionByEquityAccountIDAPI);
        return this.accountService.post(JSON.stringify(EquityAccountID));
    };
    equityService.prototype.QueueEquityForCalculation = function (EquityAccountID) {
        this.accountService.set(this._QueueEquityForCalculationAPI);
        return this.accountService.post(JSON.stringify(EquityAccountID));
    };
    equityService.prototype.GetEquityCalcInfoByEquityAccountID = function (_equity) {
        this.accountService.set(this._getEquityCalcInfoByEquityAccountIDAPI);
        return this.accountService.post(JSON.stringify(_equity));
    };
    equityService.prototype.GetEquityCashflowsExportData = function (EquityAccountID) {
        this.accountService.set(this._getEquityCashflowsExportDataAPI);
        return this.accountService.postWithBlob(JSON.stringify(EquityAccountID));
    };
    equityService.prototype.GetEquityCapitalContributionExportExcel = function (EquityAccountID) {
        this.accountService.set(this._getEquityCapContriExportDataAPI);
        return this.accountService.postWithBlob(JSON.stringify(EquityAccountID));
    };
    equityService.prototype.getCashAccountList = function () {
        this.accountService.set(this._getCashAccountAPI);
        return this.accountService.getAll();
    };
    equityService.prototype.GetDealLevelLiabilityFundingScheduleTypeID = function (EquityAccountID) {
        this.accountService.set(this._getDealLevelLiabilityFundingScheduleTypeIDAPI);
        return this.accountService.post(JSON.stringify(EquityAccountID));
    };
    //GetHolidayList() {
    //  this.accountService.set(this._accountGetHolidayListAPI);
    //  return this.accountService.getAll();
    //}
    equityService.prototype.downloadBloBData = function (FileName) {
        this.accountService.set(this._getLiabilityCalcExcelBLOBData);
        return this.accountService.postWithBlob(JSON.stringify(FileName));
    };
    equityService.prototype.getLiabilityCalculationStatus = function (scenrioID) {
        this.accountService.set(this._getLiabilityCalculationStatus);
        return this.accountService.post(JSON.stringify(scenrioID));
    };
    equityService.prototype.getLiabilityCalculationStatusForDashBoard = function (scenarioID) {
        this.accountService.set(this._getLiabilityCalculationStatusForDashBoard);
        return this.accountService.post(JSON.stringify(scenarioID));
    };
    equityService.prototype.getLiabilitySummaryDashBoard = function () {
        this.accountService.set(this._getLiabilitySummaryDashBoard);
        return this.accountService.post();
    };
    equityService.prototype.GetExportExcelLiabilitySummaryDashBoard = function () {
        this.accountService.set(this._getExportExcelLiabilitySummaryDashBoard);
        return this.accountService.postWithBlob();
    };
    equityService.prototype.QueueEquityListForCalculation = function (EquityAccountList) {
        this.accountService.set(this._queueEquityListForCalculationAPI);
        return this.accountService.post(JSON.stringify(EquityAccountList));
    };
    return equityService;
}());
exports.equityService = equityService;
//# sourceMappingURL=equity.service.js.map