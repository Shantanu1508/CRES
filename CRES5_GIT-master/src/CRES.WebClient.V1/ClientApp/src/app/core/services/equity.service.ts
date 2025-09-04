import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { equity } from '../domain/equity.model';

@Injectable()
export class equityService {

  private _equityGetAllLookupAPI: string = 'api/equity/getallLookup';
  private _equityAddEquityAPI: string = 'api/equity/addnewequity';
  private _getEquityByEquityIdAPI: string = 'api/equity/getequitybyequityId';
  private _getassociateddebtdataByEquityIdAPI: string = 'api/equity/getassociateddebtdataByEquityId';
  private _GetEquityNoteAPI: string = 'api/equity/getEquityNoteByLiabilityTypeID';
  private _GetEquityFundingSchedulAPI: string = 'api/liabilityNote/getLiabilityFundingScheduleByLiabilityTypeID';
  private _getAutosuggestDebtNameSublineAPI: string = 'api/search/getAutosuggestDebtNameSubline';
  private _GetEquityJournalLedgerbyJournalEntryMasterIDAPI: string = 'api/equity/GetEquityJournalLedgerbyJournalEntryMasterID';
  private _getHistoricalDataOfLiabilityModuleByAccountIdAPI: string = 'api/equity/GetHistoricalDataOfModuleByAccountId_Liability';
  private _checkduplicateforliabilitesAPI: string = 'api/equity/checkduplicateforliabilities';
  private _GetEquityTransactionByEquityAccountIDAPI: string = 'api/equity/GetEquityTransactionByEquityAccountID';
  private _QueueEquityForCalculationAPI: string = 'api/equity/queueEquityForCalculation';
  private _getEquityCalcInfoByEquityAccountIDAPI: string = 'api/equity/getEquityCalcInfoByEquityAccountID';
  private _getEquityCashflowsExportDataAPI: string = 'api/equity/getEquityCashflowsExportExcel';
  private _getEquityCapContriExportDataAPI: string = 'api/equity/getEquityCapitalContributionExportExcel';
  private _getDealLevelLiabilityFundingScheduleTypeIDAPI: string = 'api/liabilityNote/getDealLevelLiabilityFundingScheduleTypeID';
  /*  private _accountGetHolidayListAPI: string = 'api/account/GetHolidayList';*/
  private _getLiabilityCalcExcelBLOBData: string = 'api/equity/getliabilitycalcExcelBlobData';
  private _getCashAccountAPI: string = 'api/equity/getCashAccount';
  private _getLiabilityCalculationStatus: string = 'api/equity/getLiabilityCalculationStatus';
  private _getLiabilityCalculationStatusForDashBoard: string = 'api/equity/getLiabilityCalculationStatusForDashBoard';
  private _getLiabilitySummaryDashBoard: string = 'api/equity/getLiabilitySummaryDashBoard';
  private _getExportExcelLiabilitySummaryDashBoard: string = 'api/equity/GetExportExcelLiabilitySummaryDashBoard';
  private _queueEquityListForCalculationAPI: string = 'api/equity/queueEquityListForCalculation';
  private _getCashflowTabUIDataforonlyEquityExportExcelAPI: string = 'api/equity/getCashflowTabUIDataforonlyEquityExportExcel';
/*  private _accountGetHolidayListAPI: string = 'api/account/GetHolidayList';*/
  constructor(public accountService: DataService) { }
  getAllLookup() {
    this.accountService.set(this._equityGetAllLookupAPI);
    return this.accountService.getAll();
  }

  Saveequity(equity) {
    this.accountService.set(this._equityAddEquityAPI);
    return this.accountService.post(JSON.stringify(equity));
  }

  EquityByEquityId(equity) {
    this.accountService.set(this._getEquityByEquityIdAPI);
    return this.accountService.post(JSON.stringify(equity));
  }

  GetAssociatedDebtDataByEquityId(equity) {
    this.accountService.set(this._getassociateddebtdataByEquityIdAPI);
    return this.accountService.post(JSON.stringify(equity));
  }

  GetEquityNoteByLiabilityTypeID(LiabilityTypeID: any) {
    this.accountService.set(this._GetEquityNoteAPI);
    return this.accountService.post(JSON.stringify(LiabilityTypeID));
  }
  GetEquityFundingScheduleByLiabilityTypeID(LiabilityTypeID: any) {
    this.accountService.set(this._GetEquityFundingSchedulAPI);
    return this.accountService.post(JSON.stringify(LiabilityTypeID));
  }  

  GetAutosuggestDebtNameSubline(searchkey: any) {
    this.accountService.set(this._getAutosuggestDebtNameSublineAPI);
    return this.accountService.post(JSON.stringify(searchkey));
  }
  GetEquityJournalLedgerbyJournalEntryMasterID(EquityAccountID: any) {
    this.accountService.set(this._GetEquityJournalLedgerbyJournalEntryMasterIDAPI);
    return this.accountService.post(JSON.stringify(EquityAccountID));
  }
  GetHistoricalDataOfLiabilityModuleByAccountIdAPI(_equity: equity, pagesIndex?: number, pagesSize?: number) {
    this.accountService.set(this._getHistoricalDataOfLiabilityModuleByAccountIdAPI, pagesIndex, pagesSize);
    return this.accountService.post(JSON.stringify(_equity));
  }
  CheckDuplicateforLiabilities(_equity: equity) {
    this.accountService.set(this._checkduplicateforliabilitesAPI);
    return this.accountService.post(JSON.stringify(_equity));
  }

  GetEquityTransactionByEquityAccountID(EquityAccountID: any) {
    this.accountService.set(this._GetEquityTransactionByEquityAccountIDAPI);
    return this.accountService.post(JSON.stringify(EquityAccountID));
  }

  QueueEquityForCalculation(EquityAccountID: any) {
    this.accountService.set(this._QueueEquityForCalculationAPI);
    return this.accountService.post(JSON.stringify(EquityAccountID));
  }
  GetEquityCalcInfoByEquityAccountID(_equity: equity) {
    this.accountService.set(this._getEquityCalcInfoByEquityAccountIDAPI);
    return this.accountService.post(JSON.stringify(_equity));
  }
  GetEquityCashflowsExportData(EquityAccountID: any) {
    this.accountService.set(this._getEquityCashflowsExportDataAPI);
    return this.accountService.postWithBlob(JSON.stringify(EquityAccountID));
  }
  GetEquityCapitalContributionExportExcel(EquityAccountID: any) {
    this.accountService.set(this._getEquityCapContriExportDataAPI);
    return this.accountService.postWithBlob(JSON.stringify(EquityAccountID));
  }  

  getCashAccountList() {
    this.accountService.set(this._getCashAccountAPI);
    return this.accountService.getAll();
  }
   
  GetDealLevelLiabilityFundingScheduleTypeID(EquityAccountID) {
    this.accountService.set(this._getDealLevelLiabilityFundingScheduleTypeIDAPI);
    return this.accountService.post(JSON.stringify(EquityAccountID));
  }
  
  //GetHolidayList() {
  //  this.accountService.set(this._accountGetHolidayListAPI);
  //  return this.accountService.getAll();
  //}

  downloadBloBData(FileName: string) {
    this.accountService.set(this._getLiabilityCalcExcelBLOBData);
    return this.accountService.postWithBlob(JSON.stringify(FileName));
  }

  getLiabilityCalculationStatus(scenrioID: any) {
    this.accountService.set(this._getLiabilityCalculationStatus);
    return this.accountService.post(JSON.stringify(scenrioID));
  }

  getLiabilityCalculationStatusForDashBoard(scenarioID: any) {
    this.accountService.set(this._getLiabilityCalculationStatusForDashBoard);
    return this.accountService.post(JSON.stringify(scenarioID));
  }

  getLiabilitySummaryDashBoard() {
    this.accountService.set(this._getLiabilitySummaryDashBoard);
    return this.accountService.post();
  }

  GetExportExcelLiabilitySummaryDashBoard() {
    this.accountService.set(this._getExportExcelLiabilitySummaryDashBoard);
    return this.accountService.postWithBlob();
  }
  QueueEquityListForCalculation(EquityAccountList) {
    this.accountService.set(this._queueEquityListForCalculationAPI);
    return this.accountService.post(JSON.stringify(EquityAccountList));
  }

  GetCashflowTabUIDataforonlyEquityExportExcel(EquityAccountID: any) {
    this.accountService.set(this._getCashflowTabUIDataforonlyEquityExportExcelAPI);
    return this.accountService.postWithBlob(JSON.stringify(EquityAccountID));
  }

}
