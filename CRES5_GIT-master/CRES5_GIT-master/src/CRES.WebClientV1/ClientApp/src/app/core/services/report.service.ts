import { Component, Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { DataService } from './data.service';
import { reportFileLog } from "../domain/reportFileLog.model";
import { reportFile } from "../domain/reportFile.model";


@Injectable()
export class ReportService {
  private _reportGetAllReport: string = 'api/pbireport/getallreports';
  private _reportGetReportByID: string = 'api/pbireport/GetReportByID';
  private _reportgetimportreport: string = 'api/note/getimportsourcetodw-new';
  private _DownloadNoteDataTape: string = 'api/note/DownloadNoteDataTape';
  private _checkpowerbistatus: string = 'api/pbireport/GetCRESPowerBIEmbeddedStatus';
  private _updatepowerbistatus: string = 'api/pbireport/updatecrespowerbiembeddedstatus';
  private _getrefreshBSUnderwritingAPI: string = 'api/note/getRefreshBSUnderwriting';

  //acore accounting reports
  private _accountingreportgetallreportAPI: string = 'api/accountingreport/getallreport';
  private _accountingreportgenerateAPI: string = 'api/excelupload/generatefile';
  private _accountingreportgetDocumentsByObjectIdAPI: string = 'api/accountingreport/getdocumentsbyobjectid';
  private _accountingreportdownloadobjectfileAPI: string = 'api/excelupload/downloadobjectfile';
  private _accountingreportupdateReportLogStatusAPI: string = 'api/accountingreport/updatereportlogstatus';

  //



  constructor(public accountService: DataService) { }

  GetAllReport(pagesIndex?: number, pagesSize?: number) {
    this.accountService.set(this._reportGetAllReport, pagesIndex, pagesSize);
    return this.accountService.getAll();
  }

  GetReportByID(id: string) {
    this.accountService.set(this._reportGetReportByID);
    return this.accountService.getByID(id);

  }

  GetimportReport() {
    this.accountService.set(this._reportgetimportreport);
    return this.accountService.getAll();
  }


  DownloadNoteDataTape(id: string) {
    this.accountService.set(this._DownloadNoteDataTape);
    return this.accountService.getByID(id);

  }



  CheckPowerBIStatusOnLoad() {
    this.accountService.set(this._checkpowerbistatus);
    return this.accountService.getAll();
  }

  updatePowerBIStatusOnLoad() {
    this.accountService.set(this._updatepowerbistatus);
    return this.accountService.getAll();
  }

  GetAllAccountingReport(pagesIndex?: number, pagesSize?: number) {
    this.accountService.set(this._accountingreportgetallreportAPI, pagesIndex, pagesSize);
    return this.accountService.get();
  }

  //GenerateAccountingReport(ReportFileGUID)
  //{
  //    this.accountService.set(this._accountingreportgenerateAPI);
  //    return this.accountService.post(JSON.stringify(ReportFileGUID));
  //}
  GenerateAccountingReport(_reportFile: reportFile) {
    this.accountService.set(this._accountingreportgenerateAPI);
    if (_reportFile.IsDownloadRequire) {
      return this.accountService.postWithBlob(JSON.stringify(_reportFile))
    }
    else {
      return this.accountService.post(JSON.stringify(_reportFile))
    }
  }



  getDocumentsByObjectId(_document: reportFileLog, pagesIndex?: number, pagesSize?: number) {
    this.accountService.set($.trim(this._accountingreportgetDocumentsByObjectIdAPI), pagesIndex, pagesSize);
    return this.accountService.post(JSON.stringify(_document));
  }
  //downloadObjectDocumentByStorageTypeAndLocation(_document: reportFileLog) {
  //    this.accountService.set($.trim(this._accountingreportdownloadobjectfileAPI));
  //    return this.accountService.postWithBlob(JSON.stringify(_document));
  //}
  //downloadObjectDocumentByStorageTypeAndLocation(_document: reportFileLog) {
  //    this.accountService.set($.trim(this._accountingreportdownloadobjectfileAPI));
  //    return this.accountService.postWithBlob(JSON.stringify(_document));
  //}
  downloadObjectDocumentByStorageTypeAndLocation(id: string, storagetypeid: string, location: string) {
    this.accountService.set($.trim(this._accountingreportdownloadobjectfileAPI));
    return this.accountService.getByIDStorageTypeAndLocationWithBlob(id, storagetypeid, location);
  }

  GetRefreshBSUnderwriting() {
    this.accountService.set(this._getrefreshBSUnderwritingAPI);
    return this.accountService.getAll();
  }
  updateReportLogStatus(_document: reportFileLog) {
    this.accountService.set(this._accountingreportupdateReportLogStatusAPI);
    return this.accountService.post(JSON.stringify(_document));
  }
}
