import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { Document } from '../domain/document.model';

@Injectable()
export class FileUploadService {

  private _fileuploadAPI: string = 'api/fileupload/uploadfiletoazureblob';
  private _fileuploadcsvAPI: string = 'api/fileupload/uploadcsvfiletoazureblob';
  private _fileuploadObjectDocumentAPI: string = 'api/fileupload/uploadobjectfiletoazureblob';
  private _fileuploadObjectBoxAPI: string = 'api/fileupload/uploadobjectfiletobox';
  private _getDocumentsByObjectIdAPI: string = 'api/fileupload/getdocumentsbyobjectid';
  private _downloadDocumentByIdAPI: string = 'api/fileupload/downloadfromazureblob';
  private _updateDocumentStatusAPI: string = 'api/fileupload/updatedocumentstatus';
  private _downloadfilefromazureAPI: string = 'api/fileupload/downloadfilefromazureblob';
  private _fileuploadObjectByStorageTypeAPI: string = 'api/fileupload/uploadobjectfile';
  private _filedownloadObjectByStorageTypeAPI: string = 'api/fileupload/downloadobjectfile';
  private _importWellsDataByDealID: string = 'api/fileupload/downloadfilefromwells';

  //private _downloadfilecalcoutputAPI: string = 'api/fileupload/downloadfilecalcoutput';



  constructor(public dataService: DataService) { }

  upload(files:any, parameters:any) {
    this.dataService.set(this._fileuploadAPI);
    return this.dataService.upload(files, parameters);
  }

  uploadcsv(file:any, parameters:any) {
    this.dataService.set(this._fileuploadcsvAPI);
    return this.dataService.upload(file, parameters);
  }

  uploadObjectDocument(file:any, parameters:any) {
    this.dataService.set(this._fileuploadObjectDocumentAPI);
    return this.dataService.upload(file, parameters);
  }

  getDocumentsByObjectId(_document: Document, pagesIndex?: number, pagesSize?: number) {
    this.dataService.set(this._getDocumentsByObjectIdAPI, pagesIndex, pagesSize);
    return this.dataService.post(JSON.stringify(_document));
  }


  updateDocumentStatus(_document: Document) {
    this.dataService.set(this._updateDocumentStatusAPI);
    return this.dataService.post(JSON.stringify(_document));
  }

  downloadFile(id: string) {
    this.dataService.set(this._downloadfilefromazureAPI);
    return this.dataService.getByIDWithBlob(id);
  }

  uploadObjectDocumentByStorageType(file:any, parameters:any) {
    this.dataService.set(this._fileuploadObjectByStorageTypeAPI);
    return this.dataService.upload(file, parameters);
  }


  downloadObjectDocumentByStorageType(id: string, storagetype: string) {
    this.dataService.set(this._filedownloadObjectByStorageTypeAPI);
    return this.dataService.getByIDAndStorageTypeWithBlob(id, storagetype);
  }

  importWellsDataByDealID(dealID: string) {
    this.dataService.set(this._importWellsDataByDealID);
    // return this.dataService.getByID(dealID);
    return this.dataService.getByIDWithBlob(dealID);

  }

  downloadByURLWithBlob(url: string) {
    return this.dataService.downloadByURLWithBlob(url);
  }

  downloadFileFromURL(id: string) {
    this.dataService.set('api/fileupload/downloadfilefromurl');
    return this.dataService.getByIDWithBlob(id);
  }



  //downloadfilecalcoutput(_Calclist: CalculationManagerList) {
  //    this.dataService.set(this._downloadfilecalcoutputAPI);
  //    return this.dataService.post(JSON.stringify(_Calclist));

  //}


}


