import { Component, Inject, Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { DataService } from './data.service';
@Injectable()

export class AutomationService {

  private _getDealListForAutomationAPI: string = 'api/automation/getDealListForAutomation'
  private _SaveDealForAutomationAPI: string = 'api/automation/insertintoautomationRequests'
  private _CancelAutomationAPI: string = 'api/automation/CancelAutomation'
  private _getAutomationLogAPI: string = 'api/automation/getAutomationAuditLog'
  private _getDealByBatchIDAutomationAPI: string = 'api/automation/getDealByBatchIDAutomation';
  private _deleteAutomationlogAPI: string = 'api/automation/deleteAutomationlog';
  private _downloadAutomationExcelAPI: string = 'api/note/downloadAutomationExcel';

  constructor(public datasrv: DataService) { }
  getDealListForAutomation() {
    this.datasrv.set(this._getDealListForAutomationAPI);
    return this.datasrv.getAll();
  }

  InsertintoautomationRequests(AutomationDeals: any) {
    this.datasrv.set(this._SaveDealForAutomationAPI);
    return this.datasrv.post(AutomationDeals);
  }

  CancelAutomation() {
    this.datasrv.set(this._CancelAutomationAPI);
    return this.datasrv.getAll();
  }

  getAutomationLog(pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._getAutomationLogAPI, pagesIndex, pagesSize);
    return this.datasrv.get();
  }

  getDealByBatchIDAutomation(BatchID) {
    this.datasrv.set(this._getDealByBatchIDAutomationAPI);
    return this.datasrv.getByID(BatchID);
  }

  DeleteAutomationlog(BatchID) {
    this.datasrv.set(this._deleteAutomationlogAPI);
    return this.datasrv.getByID(BatchID);
  }

  DownloadAutomationExcel(BatchID) {
    this.datasrv.set(this._downloadAutomationExcelAPI);
    return this.datasrv.getByIDWithBlob(BatchID);
  }
}










