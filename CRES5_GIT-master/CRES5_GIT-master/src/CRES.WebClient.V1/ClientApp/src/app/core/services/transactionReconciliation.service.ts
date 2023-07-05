import { Injectable } from '@angular/core';
import { DataService } from './data.service';


@Injectable()
export class TranscationreconciliationService {
  private _GetgetallservicerAPI: string = 'api/excelupload/getallservicer';
  private _GetallnotesAPI: string = 'api/note/GetAllNotes';
  private _getAllTranscationAPI: string = 'api/excelupload/GetAllTranscation';
  private _getAllTranscationWithpagingAPI: string = 'api/excelupload/GetAllTransc';
  private _fileuploadFileAPI: string = 'api/excelupload/uploadfiletoazureblob';
  private _AddUpdateTranscationReconciliationAPI: string = 'api/excelupload/AddUpdateTranscationReconciliation';
  private _saveTranscationReconciliationAPI: string = 'api/excelupload/saveTranscationReconciliation';
  private _dealDealByDealIdAPI: string = 'api/deal/getdealbydealid';
  private _FilterTranscationAPI: string = 'api/excelupload/FilterTranscation';
  private _GetHistoricalTranscationAPI: string = 'api/excelupload/GetHistoricalTranscation'
  private _GetAllDealsForTranscationsFilterAPI: string = 'api/deal/GetAllDealsForTranscationsFilter'
  private _UnreconcileTranscationAPI: string = 'api/excelupload/UnreconcileTranscation';
  private _GetAllTranscationAuditAPI: string = 'api/excelupload/getallTranscationAuditLog';
  private _GetTranscationAuditDetailAPI: string = 'api/excelupload/getTranscationAuditDetail';
  private _GetAllTransactionByNoteAPI: string = 'api/excelupload/AllTransactionsByNoteId';
  private _DeleteAuditbyBatchlogIdAPI: string = 'api/excelupload/DeleteAuditbyBatchlogId';
  private _splitTranscationReconciliationAPI: string = 'api/excelupload/splitfeetransaction';
  private _reconcileSplitFeeTransactionAPI: string = 'api/excelupload/reconcilesplitfeetransaction';s
  constructor(public datasrv: DataService) { }

  getAllServicer() {
    this.datasrv.set(this._GetgetallservicerAPI);
    return this.datasrv.getAll();//
  }

  getAllNotes() {
    this.datasrv.set(this._GetallnotesAPI);
    return this.datasrv.getAll();//
  }

  getAllDealsForFilter(IsReconciled) {
    this.datasrv.set(this._GetAllDealsForTranscationsFilterAPI);
    return this.datasrv.post(JSON.stringify(IsReconciled));//
  }


  getalltranscationaudit() {
    this.datasrv.set(this._GetAllTranscationAuditAPI);
    return this.datasrv.getAll();//
  }

  getTranscationAuditDetail(batchid) {
    this.datasrv.set(this._GetTranscationAuditDetailAPI);
    return this.datasrv.post(JSON.stringify(batchid));
  }

  DeleteAuditbyBatchlogId(batchid) {
    this.datasrv.set(this._DeleteAuditbyBatchlogIdAPI);
    return this.datasrv.post(JSON.stringify(batchid));
  }

  getAllLookup() {
    this.datasrv.set(this._dealDealByDealIdAPI);
    return this.datasrv.getAll();
  }

  getAllTranscation() {
    this.datasrv.set(this._getAllTranscationAPI);
    return this.datasrv.getAll();//
  }


  getAllTranscationNew(data, pagesIndex, pagesSize) {
    this.datasrv.set(this._getAllTranscationWithpagingAPI, pagesIndex, pagesSize);
    return this.datasrv.post(JSON.stringify(data));
  }

  getHistoricalTranscation() {
    this.datasrv.set(this._GetHistoricalTranscationAPI);
    return this.datasrv.getAll();//
  }

  InsertupdateTranscation(transcations) {
    this.datasrv.set(this._AddUpdateTranscationReconciliationAPI);
    return this.datasrv.post(JSON.stringify(transcations));
  }

  FilterTranscations(Filterdata) {
    this.datasrv.set(this._FilterTranscationAPI);
    return this.datasrv.post(JSON.stringify(Filterdata));
  }


  SaveTranscation(transcations) {
    this.datasrv.set(this._saveTranscationReconciliationAPI);
    return this.datasrv.post(JSON.stringify(transcations));
  }

  UnreconcileTranscation(transcations) {
    this.datasrv.set(this._UnreconcileTranscationAPI);
    return this.datasrv.post(JSON.stringify(transcations));
  }

  uploadfile(file, parameters) {
    this.datasrv.set(this._fileuploadFileAPI);
    return this.datasrv.upload(file, parameters);
  }

  GetAllTransactionByNote(FilterTrans) {
    this.datasrv.set(this._GetAllTransactionByNoteAPI);
    return this.datasrv.post(JSON.stringify(FilterTrans));
  }


  SplitTranscation(transcations) {
    this.datasrv.set(this._splitTranscationReconciliationAPI);
    return this.datasrv.post(JSON.stringify(transcations));
  }


  ReconcileSplitTranscation(transcations) {
    this.datasrv.set(this._reconcileSplitFeeTransactionAPI);
    return this.datasrv.post(JSON.stringify(transcations));
  }
}
