import { Component, Inject, Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { DataService } from './data.service';
import { CalculationManagerList } from "../domain/calculationManagerList.model";
import { BatchCalculationMaster } from "../domain/batchCalculationMaster.model";
@Injectable()
export class CalculationManagerService {
  private _noteloadcalculationstatusAPI: string = 'api/calculation/loadcalculationstatus'
  private _insertcalculateonserverrequestAPI: string = 'api/calculation/insertcalculateonserverrequest'
  private _singlenotecalculateonserverRequestAPI: string = 'api/calculation/singlenotecalculateonserverRequest'
  private _getcalculationstatusAPI: string = 'api/calculation/getcalculationstatus'
  private _deleteBatchCalculationRequestByAnalysisIDAPI: string = 'api/calculation/deletebatchcalculationrequestbyanalysisid'
  private _calcstatusAPI: string = 'api/calculation/getallcalcstatus'
  private _Getallexceptions = "api/calculation/getallexceptions";
  private _RunTestCases = "api/testcase/runtestcase";
  private _getbatchcalculationLogAPI: string = 'api/calculation/getbatchcalculationLog';
  private _downloadfilecalcoutputAPI: string = 'api/calculation/downloadfilecalcoutput';
  private _getcurrentoffsetAPI: string = 'api/calculation/gettimecurrentoffset';
  private _gettransactioncategoryAPI: string = 'api/calculation/getTransactionCategory';

  constructor(public datasrv: DataService) { }

  refreshCalculation(_calculationManager: CalculationManagerList) {
    this.datasrv.set(this._noteloadcalculationstatusAPI);
    //return this.datasrv.getAll();
    return this.datasrv.post(JSON.stringify(_calculationManager));
  }

  GetallExceptions(name:any, pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._Getallexceptions, pagesIndex, pagesSize);
    return this.datasrv.post(JSON.stringify(name));
  }

  sendnoteforcalculation(_notelist: Array<CalculationManagerList>) {
    this.datasrv.set(this._insertcalculateonserverrequestAPI);

    return this.datasrv.post(JSON.stringify(_notelist));
  }

  sendsinglenoteforcalculation(_notelist: CalculationManagerList) {
    this.datasrv.set(this._singlenotecalculateonserverRequestAPI);
    return this.datasrv.post(JSON.stringify(_notelist));
  }

  getrefreshCalRequest(calcreq:any) {
    this.datasrv.set(this._getcalculationstatusAPI);
    //return this.datasrv.getAll();
    return this.datasrv.post(JSON.stringify(calcreq));
  }

  deleteBatchCalculationRequestByAnalysisID(analysisid:any) {
    this.datasrv.set(this._deleteBatchCalculationRequestByAnalysisIDAPI);
    //return this.datasrv.getAll();
    return this.datasrv.post(JSON.stringify(analysisid));
  }

  calcstatus() {
    this.datasrv.set(this._calcstatusAPI);
    return this.datasrv.getAll();
    //return this.datasrv.post(JSON.stringify(id));
  }

  getTestCases(testcase:any, pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._RunTestCases, pagesIndex, pagesSize);
    return this.datasrv.post(JSON.stringify(testcase));
  }

  getbatchlog(_batchManager: BatchCalculationMaster) {
    this.datasrv.set(this._getbatchcalculationLogAPI);
    //return this.datasrv.getAll();
    return this.datasrv.post(JSON.stringify(_batchManager));
  }

  downloadfilecalcoutput(_Calclist: CalculationManagerList) {
    this.datasrv.set(this._downloadfilecalcoutputAPI);
    return this.datasrv.post(JSON.stringify(_Calclist));
  }

  GettimezoneCurrentOffset() {
    this.datasrv.set(this._getcurrentoffsetAPI);
    return this.datasrv.getAll();
  }
  GetTransactionCategory() {
    this.datasrv.set(this._gettransactioncategoryAPI);
    return this.datasrv.getAll();
  }
}
