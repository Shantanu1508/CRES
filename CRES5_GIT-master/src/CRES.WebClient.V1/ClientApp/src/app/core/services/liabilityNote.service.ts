import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { liabilityNote } from '../domain/liabilityNote.model';

@Injectable()
export class liabilityNoteService {

  private _liabilityNoteGetAllLookupAPI: string = 'api/liabilityNote/getallLookup';
  private _saveLiabilityNoteAPI: string = 'api/liabilityNote/InsertUpdateLiabilityNote';
  private _getLiabilityNoteAPI: string = 'api/liabilityNote/getLiabilityNoteByLiabilityNoteID';
  private _getAssetListByDealAccountIDAPI: string = 'api/liabilityNote/getAssetListByDealAccountID';
  private _getAutosuggestDebtAndEquityNameAPI: string = 'api/search/getAutosuggestDebtAndEquityName';
  private _getLiabilityRateSpreadScheduleByNoteAccountIDAPI: string = 'api/liabilityNote/GetLiabilityRateSpreadScheduleByNoteAccountID';
  private _getHistoricalDataOfLiabilityModuleByAccountIdAPI: string = 'api/liabilityNote/GetHistoricalDataOfModuleByAccountId_Liability';
  private _checkduplicateforliabilitesAPI: string = 'api/liabilityNote/checkduplicateforliabilities';
  private _getLiabilityFeeScheduleByAccountIDAPI: string = 'api/debt/GetDebtFeeScheduleByDebtAccountID';
  private _getAutosuggestBankerNameAPI: string = 'api/search/GetAutosuggestBankerName';
  private _getInterestExpenseScheduleAPI: string = 'api/liabilityNote/GetInterestExpenseSchedule';
  private _deleteInterestExpenseScheduleAPI: string = 'api/liabilityNote/DeleteInterestExpenseSchedule';
  constructor(public datasrv: DataService) { }
  
  getAllLookup() {
    this.datasrv.set(this._liabilityNoteGetAllLookupAPI);
    return this.datasrv.getAll();
  }

  SaveLiabilityNote(note: liabilityNote) {
    this.datasrv.set(this._saveLiabilityNoteAPI);
    return this.datasrv.post(JSON.stringify(note));
  }

  GetLiabilityNote(LiabilityNoteGUID: any) {
    this.datasrv.set(this._getLiabilityNoteAPI);
    return this.datasrv.post(JSON.stringify(LiabilityNoteGUID));
  }
  GetRateScheduleByNoteAccountID(LiabilityAccountID: any) {
    this.datasrv.set(this._getLiabilityRateSpreadScheduleByNoteAccountIDAPI);
    return this.datasrv.post(JSON.stringify(LiabilityAccountID));
  }
  GetLiabilityFeeScheduleByAccountID(DebtAccountID: any) {
    this.datasrv.set(this._getLiabilityFeeScheduleByAccountIDAPI);
    return this.datasrv.post(JSON.stringify(DebtAccountID));
  }
  GetAssetListByDealAccountID(DealAccountID: any) {
    this.datasrv.set(this._getAssetListByDealAccountIDAPI);
    return this.datasrv.post(JSON.stringify(DealAccountID));
  }
  
  GetAutosuggestDebtAndEquityName(searchkey: any) {
    this.datasrv.set(this._getAutosuggestDebtAndEquityNameAPI);
    return this.datasrv.post(JSON.stringify(searchkey));
  }
  GetHistoricalDataOfLiabilityModuleByAccountIdAPI(_note: liabilityNote, pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._getHistoricalDataOfLiabilityModuleByAccountIdAPI, pagesIndex, pagesSize);
    return this.datasrv.post(JSON.stringify(_note));
  }
  CheckDuplicateforLiabilities(_note: liabilityNote) {
    this.datasrv.set(this._checkduplicateforliabilitesAPI);
    return this.datasrv.post(JSON.stringify(_note));
  }
  GetAutosuggestBankerName(searchkey: any) {
    this.datasrv.set(this._getAutosuggestBankerNameAPI);
    return this.datasrv.post(JSON.stringify(searchkey));
  }
  GetInterestExpenseSchedule(LiabilityAccountID: any) {
    this.datasrv.set(this._getInterestExpenseScheduleAPI);
    return this.datasrv.post(JSON.stringify(LiabilityAccountID));
  }
  DeleteInterestExpenseSchedule(LiabilityAccountID: any) {
    this.datasrv.set(this._deleteInterestExpenseScheduleAPI);
    return this.datasrv.post(JSON.stringify(LiabilityAccountID));
  }
}
