import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { TagMaster } from "../../core/domain/tagMaster.model";

@Injectable()
export class TagMasterService {
  private _getTagMasterAPI: string = 'api/tags/GetTagMaster';
  private _InsertTagMasterAPI: string = 'api/tags/InsertTagMaster';
  private _getNoteCashflowsExportDataFromTransactionCloseAPI: string = 'api/tags/GetNoteCashflowsExportDataFromTransactionClose';
  private _uploadNoteCashflowsExportDataFromTransactionCloseToAzureAPI: string = 'api/tags/UploadNoteCashflowsExportDataFromTransactionCloseToAzure';

  private _DeleteTagByTagIDAPI: string = 'api/tags/DeleteTagByTagID';


  constructor(public datasrv: DataService) { }


  //getTagList(tagid) {
  //    this.datasrv.set(this._getTagMasterAPI);
  //    return this.datasrv.post(JSON.stringify(tagid));

  //}

  GetTagMaster(_tagMaster) {
    this.datasrv.set(this._getTagMasterAPI);
    return this.datasrv.post(JSON.stringify(_tagMaster));
  }


  InsertTagMaster(_tagMaster: TagMaster) {
    this.datasrv.set(this._InsertTagMasterAPI);
    return this.datasrv.post(JSON.stringify(_tagMaster));
  }

  getNoteCashflowsExportDataFromTransactionClose(_tagMaster: TagMaster) {
    this.datasrv.set(this._getNoteCashflowsExportDataFromTransactionCloseAPI);
    return this.datasrv.post(JSON.stringify(_tagMaster));
  }

  uploadNoteCashflowsExportDataFromTransactionCloseToAzure(_tagMaster: TagMaster) {
    this.datasrv.set(this._uploadNoteCashflowsExportDataFromTransactionCloseToAzureAPI);
    return this.datasrv.post(JSON.stringify(_tagMaster));
  }


  DeleteTagByTagID(_tagMaster: TagMaster) {
    this.datasrv.set(this._DeleteTagByTagIDAPI);
    return this.datasrv.post(JSON.stringify(_tagMaster));
  }


}
