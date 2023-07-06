import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { devDashBoard } from '../domain/devDashBoard.model';

@Injectable()
export class DevDashBoardService {
  private _getCalculationStatus: string = 'api/devdash/GetcalculationStatus';
  private _calculateMultipleNotes: string = 'api/devdash/calculatemultiplenotes';
  private _getRefreshDataWarehouse: string = 'api/devdash/refreshdatawarehouse';
  private _getFailedNotes: string = 'api/devdash/GetFailedNotes';
  private _getCalcjson: string = 'api/devdash/GetCalcJson';
  private _geterrorlogcountAPI: string = 'api/devdash/geterrorlogcount';
  private _GetAIUserData: string = 'api/devdash/GetAIUserData';
  private _CalcAllNotes: string = 'api/devdash/calcallnotes';
  private _GetAIDashBoardData: string = 'api/devdash/GetAIDashBoardData';
  private _ImportstagingdataAPI: string = 'api/devdash/importStagingdata';


  constructor(public datasrv: DataService) { }

  getCalculationStatus(scenrioID:any) {
    this.datasrv.set(this._getCalculationStatus);
    return this.datasrv.post(JSON.stringify(scenrioID));

  }

  CalcAllNotes(scenrioID: any) {
    this.datasrv.set(this._CalcAllNotes);
    return this.datasrv.post(JSON.stringify(scenrioID));
  }

  getFailedNotes(logtype: any) {
    this.datasrv.set(this._getFailedNotes);
    return this.datasrv.post(JSON.stringify(logtype));

  }

  RefreshDataWarehouse(currenttime: any) {
    this.datasrv.set(this._getRefreshDataWarehouse);
    return this.datasrv.post(JSON.stringify(currenttime));

  }
  CalculateMultipleNotes(devDashBoard: devDashBoard) {
    this.datasrv.set(this._calculateMultipleNotes);
    return this.datasrv.post(JSON.stringify(devDashBoard));//
  }

  getCalcJson(devDashBoard: devDashBoard) {
    this.datasrv.set(this._getCalcjson);
    return this.datasrv.post(JSON.stringify(devDashBoard));

  }
  GetErrorCount() {
    this.datasrv.set(this._geterrorlogcountAPI);
    return this.datasrv.getAll();
  }


  GetAIDashBoardData() {
    this.datasrv.set(this._GetAIDashBoardData);
    return this.datasrv.getAll();
  }

  GetaiUserLog(username: any) {
    this.datasrv.set(this._GetAIUserData);
    return this.datasrv.post(JSON.stringify(username));
  }

  importStagingData() {
    this.datasrv.set(this._ImportstagingdataAPI);
    return this.datasrv.getAll();
  }

}
