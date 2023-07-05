import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { backshopImport } from "../domain/backshopImport.model";
import { IN_UnderwritingNotes } from '../domain/inUnderwritingNotes.model';

@Injectable()
export class ImportUnderwritingService {

  private _ImportBackShopInUnderwritingtableAPI: string = 'api/ImportExportController/ImportBackShopInUnderwritingtable';
  private _GetBackshopDealByDealNameAPI: string = 'api/ImportExportController/GetBackshopDealByDealName';
  private _GetInUnderwritingNotesByDealIDAPI: string = 'api/ImportExportController/GetInUnderwritingNotesByDealID';
  private _GetINUnderwritingRateSpreadScheduleByNoteIDAPI: string = 'api/ImportExportController/GetINUnderwritingRateSpreadScheduleByNoteID';
  private _GetINUnderwritingStrippingScheduleByNoteIDAPI: string = 'api/ImportExportController/GetINUnderwritingStrippingScheduleByNoteID';
  private _GetINUnderwritingPIKScheduleByNoteIDAPI: string = 'api/ImportExportController/GetINUnderwritingPIKScheduleByNoteID';
  private _GetINUnderwritingFundingScheduleByNoteIDAPI: string = 'api/ImportExportController/GetINUnderwritingFundingScheduleByNoteID';
  private _ImportLandingtableToMainDBAPI: string = 'api/ImportExportController/ImportLandingtableToMainDB';
  private _DeleteINUnderwritingDealDataByDealIDAPI: string = 'api/ImportExportController/DeleteINUnderwritingDealDataByDealID';
  private _getINUnderwritingDealByDealIdorDealNameAPI: string = 'api/ImportExportController/getINUnderwritingDealByDealIdorDealName';

  private _getINUnderwritingDealDataByDealIdAPI: string = 'api/ImportExportController/getINUnderwritingDealDataByDealId';




  public backshopImport = backshopImport;
  public _in_UnderwritingNotes: IN_UnderwritingNotes;

  constructor(public importUnderwritingService: DataService) {


  }

  ImportBackShopInUnderwritingtable(backshopImport: backshopImport) {
    this.importUnderwritingService.set(this._ImportBackShopInUnderwritingtableAPI);
    return this.importUnderwritingService.post(JSON.stringify(backshopImport));
  }




  ImportLandingtableToMainDB(backshopImport: backshopImport) {
    this.importUnderwritingService.set(this._ImportLandingtableToMainDBAPI);
    return this.importUnderwritingService.post(JSON.stringify(backshopImport));
  }


  DeleteINUnderwritingDealDataByDealID(backshopImport: backshopImport) {
    this.importUnderwritingService.set(this._DeleteINUnderwritingDealDataByDealIDAPI);
    return this.importUnderwritingService.post(JSON.stringify(backshopImport));
  }

  GetBackshopDealByDealName(backshopImport: backshopImport) {
    this.importUnderwritingService.set(this._GetBackshopDealByDealNameAPI);
    return this.importUnderwritingService.post(JSON.stringify(backshopImport));
  }



  GetInUnderwritingNotesByDealID(backshopImport: backshopImport) {

    this.importUnderwritingService.set(this._GetInUnderwritingNotesByDealIDAPI);
    return this.importUnderwritingService.post(JSON.stringify(backshopImport));
  }

  GetINUnderwritingDealDataByDealId(backshopImport: backshopImport) {

    this.importUnderwritingService.set(this._getINUnderwritingDealDataByDealIdAPI);
    return this.importUnderwritingService.post(JSON.stringify(backshopImport));
  }


  GetINUnderwritingRateSpreadScheduleByNoteID(IN_UnderwritingNotes: IN_UnderwritingNotes) {

    this.importUnderwritingService.set(this._GetINUnderwritingRateSpreadScheduleByNoteIDAPI);
    return this.importUnderwritingService.post(JSON.stringify(IN_UnderwritingNotes));
  }


  GetINUnderwritingStrippingScheduleByNoteID(IN_UnderwritingNotes: IN_UnderwritingNotes) {

    this.importUnderwritingService.set(this._GetINUnderwritingStrippingScheduleByNoteIDAPI);
    return this.importUnderwritingService.post(JSON.stringify(IN_UnderwritingNotes));
  }


  GetINUnderwritingPIKScheduleByNoteID(IN_UnderwritingNotes: IN_UnderwritingNotes) {

    this.importUnderwritingService.set(this._GetINUnderwritingPIKScheduleByNoteIDAPI);
    return this.importUnderwritingService.post(JSON.stringify(IN_UnderwritingNotes));
  }

  GetINUnderwritingFundingScheduleByNoteID(IN_UnderwritingNotes: IN_UnderwritingNotes) {

    this.importUnderwritingService.set(this._GetINUnderwritingFundingScheduleByNoteIDAPI);
    return this.importUnderwritingService.post(JSON.stringify(IN_UnderwritingNotes));
  }


  getINUnderwritingDealByDealIdorDealName(backshopImport: backshopImport) {
    this.importUnderwritingService.set(this._getINUnderwritingDealByDealIdorDealNameAPI);
    return this.importUnderwritingService.post(JSON.stringify(backshopImport));
  }



}
