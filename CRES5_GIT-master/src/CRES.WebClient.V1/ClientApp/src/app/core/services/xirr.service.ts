import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { XIRRConfigMasterDataContract, XIRRConfig, XIRRConfigParam } from "../domain/XIRRConfig.model";
@Injectable()

export class XIRRService {

  private _xirrdownloadReturnAPI: string = 'api/excelupload/downloadxirrreturn';
  private _xirrdownloadReturnArchiveAPI: string = 'api/excelupload/downloadxirrreturnarchive';
  private _saveXIRRConfigsAPI: string = 'api/XIRR/saveXIRRConfigs';
  private _getXIRRConfigsAPI: string = 'api/XIRR/getXIRRConfigs';
  private _xirrcalcAPI: string = 'api/XIRR/xirrcalc';
  private _apigetallxirrtransactiontypesAPI: string = 'api/XIRR/getallxirrtransactiontypes';
  private _getLookupforXIRRFiltersAPI: string = 'api/XIRR/getLookupforXIRRFilters';
  private _getallLookupAPI: string = 'api/XIRR/getallLookup';

  private _archivexirroutputAPI: string = 'api/XIRR/archivexirroutput';
  private _getallxirrArchivesAPI: string = 'api/XIRR/getAllArchiveXIRROutput';

  private _getAllNoteTagsXIRRAPI: string = 'api/XIRR/getAllNoteTags';
  private _saveNoteTagsAPI: string = 'api/XIRR/saveNoteTags';
  private _deleteXIRRNoteTagsAPI: string = 'api/XIRR/deleteNoteTags';


  private _getViewAttachedNotesAPI: string = 'api/XIRR/GetViewAttachedNotes';
  private _generatexirrinptoutputfilesAPI: string = 'api/XIRR/generatexirrinptoutputfilesAPI';
  private _getXIRROutputPortfolioLevelAPI: string = 'api/XIRR/GetXIRROutputPortfolioLevel';
  private _GetXIRROutputDealLevelFromXirrDashBoardAPI: string = 'api/XIRR/GetXIRROutputDealLevelFromXirrDashBoard';

  //private _getXIRROutputPortfolioLevelAPI: string = 'api/XIRR/GetXIRROutputPortfolioLevel';
  private _accountingreportdownloadobjectfileAPI: string = 'api/excelupload/downloadobjectfile';
  private _getExportExcelXIRROutputDealLevelFromXirrDashBoard: string = 'api/XIRR/GetExportExcelXIRROutputDealLevelFromXirrDashBoard';


  private _downloadxirroutputfilesAPI: string = 'api/excelupload/downloadxirroutputfiles';
  private _getAssociatedNotesDataAPI: string = 'api/XIRR/getAssociatedNotesData';
  private _GetXIRRConfigByXIRRConfigGUIDAPI: string = 'api/XIRR/getXIRRConfigByXIRRConfigGUID';

  private _deleteXIRRByXIRRConfigIDAPI: string = 'api/XIRR/deleteXIRRByXIRRConfigID';

  private _downloxirrreturnfromdashboardAPI: string = 'api/excelupload/downloadxirrreturnfromdashboard';

  private _getFileNameForCashflowAPI: string = 'api/XIRR/GetFileNameForCashflow';
 
  private _checkDuplicateXIRRConfigAPI: string = 'api/XIRR/CheckDuplicateXIRRConfig';
  private _archivexirrinputoutputAPI = "api/XIRR/archivexirrinputoutput";
  private _updateXIRRDealOutputCalculateAPI = "api/XIRR/UpdateXIRRDealOutputCalculated";

  constructor(public accountService: DataService) { }

  getAllLookup() {
    this.accountService.set(this._getallLookupAPI);
    return this.accountService.getAll();
  }
  downloxirrreturn(xirrlist) {
    this.accountService.set(this._xirrdownloadReturnAPI);
    return this.accountService.DownloadBylist(xirrlist);
  }

  downloadxirrreturnarchive(xirrlist) {
    this.accountService.set(this._xirrdownloadReturnArchiveAPI);
    return this.accountService.DownloadBylist(xirrlist);
  }

  SaveXIRRConfigs(xirrConfig: XIRRConfig) {
    this.accountService.set(this._saveXIRRConfigsAPI);
    return this.accountService.post(JSON.stringify(xirrConfig));
  }  
  GetXIRRConfigs() {
    this.accountService.set(this._getXIRRConfigsAPI);
    return this.accountService.getAll();
  }

  archivexirroutput(xirrparam: XIRRConfigParam) {
    this.accountService.set(this._archivexirroutputAPI);
    return this.accountService.post(JSON.stringify(xirrparam));
  }

  archivexirrinputoutput(xirrparam: XIRRConfigParam) {
    this.accountService.set(this._archivexirrinputoutputAPI);
    return this.accountService.post(JSON.stringify(xirrparam));
  }

  xirrcalc(xirrparam: XIRRConfigParam) {
    this.accountService.set(this._xirrcalcAPI);
    return this.accountService.post(JSON.stringify(xirrparam));
  }

  GetAllArchiveXIRROutput() {
    this.accountService.set(this._getallxirrArchivesAPI);
    return this.accountService.getAll();
  }

  getallxirrtransactiontypes() {
    this.accountService.set(this._apigetallxirrtransactiontypesAPI);
    return this.accountService.getAll();
  }

  GetLookupforXIRRFilters(XIRRConfigID: any) {
    this.accountService.set(this._getLookupforXIRRFiltersAPI);
    return this.accountService.post(JSON.stringify(XIRRConfigID));
  }

  GetAllNoteTagsXIRR() {
    this.accountService.set(this._getAllNoteTagsXIRRAPI);
    return this.accountService.getAll();
  }

  SaveNoteTagsXIRR(NoteTagsXIRR: any) {
    this.accountService.set(this._saveNoteTagsAPI);
    return this.accountService.post(JSON.stringify(NoteTagsXIRR));
  }
  deleteNoteTags(id: number) {
    this.accountService.set(this._deleteXIRRNoteTagsAPI);
    return this.accountService.post(JSON.stringify(id));
  }
  GetViewAttachedNotes(id: number) {
    this.accountService.set(this._getViewAttachedNotesAPI);
    return this.accountService.post(JSON.stringify(id));
  }
  generatexirrinptoutputfiles(xirrparam: XIRRConfigParam) {
    this.accountService.set(this._generatexirrinptoutputfilesAPI);
    return this.accountService.post(JSON.stringify(xirrparam));
  }

  GetXIRROutputPortfolioLevel(XIRRConfigID: any) {
    this.accountService.set(this._getXIRROutputPortfolioLevelAPI);
    return this.accountService.post(JSON.stringify(XIRRConfigID));
  }
  GetXIRROutputDealLevelFromXirrDashBoard(jsonparameters) {
    this.accountService.set(this._GetXIRROutputDealLevelFromXirrDashBoardAPI);
    return this.accountService.post(JSON.stringify(jsonparameters));
  }

  GetExportExcelXIRROutputDealLevelFromXirrDashBoard(jsonparameters) {
    this.accountService.set(this._getExportExcelXIRROutputDealLevelFromXirrDashBoard);
    return this.accountService.postWithBlob(JSON.stringify(jsonparameters));
  }

  downloadObjectDocumentByStorageTypeAndLocation(id: string, storagetypeid: string, location: string) {
    this.accountService.set(this._accountingreportdownloadobjectfileAPI);
    return this.accountService.getByIDStorageTypeAndLocationWithBlobGET(id, storagetypeid, location);
  }

  GetAssociatedNotesDataAPI(XIRRConfigID: any) {
    this.accountService.set(this._getAssociatedNotesDataAPI);
    return this.accountService.postWithBlob(JSON.stringify(XIRRConfigID));
  }

  GetXIRRConfigByXIRRConfigGUID(XIRRConfigGUID) {
    this.accountService.set(this._GetXIRRConfigByXIRRConfigGUIDAPI);
    return this.accountService.post(JSON.stringify(XIRRConfigGUID));
  }

  downloadxirroutputfiles(xirrlist) {
    this.accountService.set(this._downloadxirroutputfilesAPI);
    return this.accountService.DownloadBylist(xirrlist);
  }

  DeleteXIRRByXIRRConfigID(deletedXIRRConfigID) {
    this.accountService.set(this._deleteXIRRByXIRRConfigIDAPI);
    return this.accountService.post(JSON.stringify(deletedXIRRConfigID));
  }


  getfilenameforcashflow(xirrreturngroup:any) {
    this.accountService.set(this._getFileNameForCashflowAPI);
    return this.accountService.post(JSON.stringify(xirrreturngroup));
  }

  CheckDuplicateXIRRConfig(xirrConfig: XIRRConfig) {
    this.accountService.set(this._checkDuplicateXIRRConfigAPI);
    return this.accountService.post(JSON.stringify(xirrConfig));
  }

  UpdateXIRRDealOutputCalculated(lstjsonparam) {
    this.accountService.set(this._updateXIRRDealOutputCalculateAPI);
    return this.accountService.post(JSON.stringify(lstjsonparam));
  }
  
}
  
