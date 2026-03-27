import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { devDashBoard } from '../domain/devDashBoard.model';
import { EnvConfig } from '../domain/EnvConfig.model';

@Injectable()
export class DevDashBoardService {
  private _getCalculationStatus: string = 'api/devdash/GetcalculationStatus';
  private _calculateMultipleNotes: string = 'api/devdash/calculatemultiplenotes';
  private _getRefreshDataWarehouse: string = 'api/devdash/refreshdatawarehouse';
  private _getFailedNotes: string = 'api/devdash/GetFailedNotes';
  private _getCalcjson: string = 'api/devdash/GetCalcJson';
  private _geterrorlogcountAPI: string = 'api/devdash/geterrorlogcount';
 
  private _CalcAllNotes: string = 'api/devdash/calcallnotes';

  private _ImportstagingdataAPI: string = 'api/devdash/importStagingdata';
  private _getLogsExcelAPI: string = 'api/devdash/getLogsDownloadExcel';
  private _getFirstHalfDiscrepancySummaryAPI: string = 'api/devdash/getfirsthalfdiscrepancysummarydevdash';
  private _getSecondHalfDiscrepancySummaryAPI: string = 'api/devdash/getsecondhalfdiscrepancysummarydevdash';
  private _getXIRRSummaryfordevdashAPI: string = 'api/devdash/GetXIRRSummaryfordevdash';
  private _GetstagingdataintointegrationstatusAPI: string = 'api/devdash/getstagingdataintointegrationstatus';

  private _getCalculationStatusForValuationDashBoardAPI: string = 'api/devdash/GetCalculationStatusForValuationDashBoard';
 
  private _getGetAzureVMStatusAPI: string = 'api/devdash/GetAzureVMStatus';
  private _getEnvConfigAPI: string = 'api/devdash/GetEnvConfig';
  private _checkEnvConnectionAPI: string = 'api/devdash/CheckEnvConnection';
  private _ImportDealFromOtherSourceAPI: string = 'api/devdash/ImportDealFromOtherSource';
  private _getValuationLogsExcelAPI: string = 'api/devdash/getValuationLogsDownloadExcel';
  private _getValuationCalculationSummaryAPI: string = 'api/devdash/getValuationCalculationSummary';
  private _calculateMultipleDeals: string = 'api/devdash/calculatemultipledeals';

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
    return this.datasrv.post(JSON.stringify(devDashBoard));
  }

  getCalcJson(devDashBoard: devDashBoard) {
    this.datasrv.set(this._getCalcjson);
    return this.datasrv.post(JSON.stringify(devDashBoard));

  }
  GetErrorCount() {
    this.datasrv.set(this._geterrorlogcountAPI);
    return this.datasrv.getAll();
  }

  GetFirstDiscrepancySummary() {
    this.datasrv.set(this._getFirstHalfDiscrepancySummaryAPI);
    return this.datasrv.getAll();
  }

  GetSecondDiscrepancySummary() {
    this.datasrv.set(this._getSecondHalfDiscrepancySummaryAPI);
    return this.datasrv.getAll();
  }  
  importStagingData() {
    this.datasrv.set(this._ImportstagingdataAPI);
    return this.datasrv.getAll();
  }

  downloadLogsExcel(objectID: any) {
    this.datasrv.set(this._getLogsExcelAPI);
    return this.datasrv.postWithBlob(JSON.stringify(objectID));
  }

  GetXIRRSummaryfordevdash() {
    this.datasrv.set(this._getXIRRSummaryfordevdashAPI);
    return this.datasrv.getAll();
  }
  GetCalculationStatusForValuationDashBoard() {
    this.datasrv.set(this._getCalculationStatusForValuationDashBoardAPI);
    return this.datasrv.getAll();
  }
  GetGetAzureVMStatusAPI() {
    this.datasrv.set(this._getGetAzureVMStatusAPI);
    return this.datasrv.getAll();
  }

  

  GetStagingDataIntoIntegrationStatus() {
    this.datasrv.set(this._GetstagingdataintointegrationstatusAPI);
    return this.datasrv.getAll();
  }

  GetEnvConfig() {
    this.datasrv.set(this._getEnvConfigAPI);
    return this.datasrv.getAll();
  }

  CheckEnvConnection(selectedEnvConfig: EnvConfig) {
    this.datasrv.set(this._checkEnvConnectionAPI);
    return this.datasrv.post(JSON.stringify(selectedEnvConfig));
  }

  ImportDealFromOtherSource(selectedEnvConfig: EnvConfig) {
    this.datasrv.set(this._ImportDealFromOtherSourceAPI);
    return this.datasrv.post(JSON.stringify(selectedEnvConfig));
  }

  downloadValuationLogsExcel(objectID: any) {
    this.datasrv.set(this._getValuationLogsExcelAPI);
    return this.datasrv.postWithBlob(JSON.stringify(objectID));
  }

  GetValuationCalculationSummary() {
    this.datasrv.set(this._getValuationCalculationSummaryAPI);
    return this.datasrv.getAll();
  }

  CalculateMultipleDeals(devDashBoard: devDashBoard) {
    this.datasrv.set(this._calculateMultipleDeals);
    return this.datasrv.post(JSON.stringify(devDashBoard));
  }
}
