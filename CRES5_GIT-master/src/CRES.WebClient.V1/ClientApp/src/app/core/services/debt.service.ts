import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { Debt } from '../domain/debt.model';

@Injectable()
export class debtService
{

  private _debtGetAllLookupAPI: string = 'api/debt/getallLookup';   
  private _InsertUpdatedebtAPI: string = 'api/debt/InsertUpdatedebt';
  private _GetDebtNoteAPI: string = 'api/debt/getDebtNoteByLiabilityTypeID';  
  private _GetDebtDataAPI: string = 'api/debt/GetDebtDataByDebtGUID';
  private _GetDebtFundingSchedulAPI: string = 'api/liabilityNote/getLiabilityFundingScheduleByLiabilityTypeID';
  private _GetDebtJournalLedgerbyJournalEntryMasterIDAPI: string = 'api/debt/GetDebtJournalLedgerbyJournalEntryMasterID';
  private _getHistoricalDataOfLiabilityModuleByAccountIdAPI: string = 'api/debt/GetHistoricalDataOfModuleByAccountId_Liability';
  private _checkduplicateforliabilitesAPI: string = 'api/debt/checkduplicateforliabilities';
  private _GetDebtTransactionByDebtAccountIDAPI: string = 'api/debt/GetDebtTransactionByDebtAccountID';
  private _getLiabilityFundingScheduleAggregateByLiabilityTypeIDAPI: string = 'api/liabilityNote/getLiabilityFundingScheduleAggregateByLiabilityTypeID';
  private _getLiabilityFundingScheduleDetailByLiabilityIDAPI: string = 'api/liabilityNote/getLiabilityFundingScheduleDetailByLiabilityID';
  private _getLiabilityFundingScheduleDetailByLiabilityIDDateAndTypAPI: string = 'api/liabilityNote/getLiabilityFundingScheduleDetailByLiabilityIDDateAndType';
  private _getDealLevelLiabilityFundingScheduleTypeIDAPI: string = 'api/liabilityNote/getDealLevelLiabilityFundingScheduleTypeID';
  constructor(public datasrv: DataService) { }
  getAllLookup() {
    this.datasrv.set(this._debtGetAllLookupAPI);
    return this.datasrv.getAll();
  }

  InsertUpdatedebt(Debt: Debt) {
    this.datasrv.set(this._InsertUpdatedebtAPI);
    return this.datasrv.post(JSON.stringify(Debt));
  }

  GetDebtNoteByLiabilityTypeID(LiabilityTypeID: any) {
    this.datasrv.set(this._GetDebtNoteAPI);
    return this.datasrv.post(JSON.stringify(LiabilityTypeID));
  }

  GetDebtDataByDebtGUID(DebtGUID: any) {
    this.datasrv.set(this._GetDebtDataAPI);
    return this.datasrv.post(JSON.stringify(DebtGUID));
  }
  GetDebtFundingScheduleByLiabilityTypeID(LiabilityTypeID: any) {
    this.datasrv.set(this._GetDebtFundingSchedulAPI);
    return this.datasrv.post(JSON.stringify(LiabilityTypeID));
  }  
  GetDebtTransactionByDebtAccountID(DebtAccountID: any) {
    this.datasrv.set(this._GetDebtTransactionByDebtAccountIDAPI);
    return this.datasrv.post(JSON.stringify(DebtAccountID));
  }  
  GetDebtJournalLedgerbyJournalEntryMasterID(DebtAccountID: any) {
    this.datasrv.set(this._GetDebtJournalLedgerbyJournalEntryMasterIDAPI);
    return this.datasrv.post(JSON.stringify(DebtAccountID));
  }
  GetHistoricalDataOfLiabilityModuleByAccountIdAPI(_debt: Debt, pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._getHistoricalDataOfLiabilityModuleByAccountIdAPI, pagesIndex, pagesSize);
    return this.datasrv.post(JSON.stringify(_debt));
  }
  CheckDuplicateforLiabilities(Debt: Debt) {
    this.datasrv.set(this._checkduplicateforliabilitesAPI);
    return this.datasrv.post(JSON.stringify(Debt));
  }

GetLiabilityFundingScheduleAggregateByLiabilityTypeID(LiabilityTypeID: any) {
    this.datasrv.set(this._getLiabilityFundingScheduleAggregateByLiabilityTypeIDAPI);
    return this.datasrv.post(JSON.stringify(LiabilityTypeID));
  }

  getLiabilityFundingScheduleDetailByLiabilityID(LiabilityTypeID: any) {
    this.datasrv.set(this._getLiabilityFundingScheduleDetailByLiabilityIDAPI);
    return this.datasrv.post(JSON.stringify(LiabilityTypeID));
  }

  getLiabilityFundingScheduleDetailByLiabilityIDTransDateTransType(LiabilityTypeID: any) {
    this.datasrv.set(this._getLiabilityFundingScheduleDetailByLiabilityIDDateAndTypAPI);
    return this.datasrv.post(JSON.stringify(LiabilityTypeID));
  }
  GetDealLevelLiabilityFundingScheduleTypeID(EquityAccountID) {
    this.datasrv.set(this._getDealLevelLiabilityFundingScheduleTypeIDAPI);
    return this.datasrv.post(JSON.stringify(EquityAccountID));
  }
}
