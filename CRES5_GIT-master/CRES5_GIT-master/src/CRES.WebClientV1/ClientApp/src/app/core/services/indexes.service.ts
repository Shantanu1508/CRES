import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { Indexes, IndexesSearch } from '../domain/indexes.model';

@Injectable()
export class indexesService {
  private _getallindexesmasterAPI: string = 'api/indextype/getallindexesmaster';
  private _checkduplicateindexesnameAPI: string = 'api/indextype/checkduplicateindexesname';
  private _getindexesdetailbyindexesmasterAPI: string = 'api/indextype/getindexesdetailbyindexesmaster';
  private _insertupdateindexesmasterdetailAPI: string = 'api/indextype/insertupdateindexesmasterdetail';
  private _addupdateindextypeListAPI: string = 'api/indextype/addupdateindextypeList';
  private _getindexesexportdatabyindexesmasteridAPI: string = 'api/indextype/getindexesexportdatabyindexesmasterid';

  private _getindexlistbyindexesMasterIDAPI: string = 'api/indextype/getindexlistbyindexesMasterID';

  private _getindexlistbydateAPI: string = 'api/indextype/getindexlistbydate';
  private _importindexesAPI: string = 'api/indextype/importindexes';
  private _refreshliborAPI: string = 'api/indextype/refreshLibors';


  //private _addupdateindextypeListAPI: string = 'api/indextype/addupdateindextypefromscenario';


  //private _getallLookupAPI: string = 'api/scenarios/getallLookup';
  //private _resetdefaulttoactivescenarioAPI: string = 'api/scenarios/resettodefault';



  //private _getIndexesFromIndexesMasterAPI: string = 'api/indextype/GetIndexesFromIndexesMaster';


  // 
  constructor(public accountService: DataService) { }

  GetAllIndexesMaster(pagesIndex?: number, pagesSize?: number) {
    this.accountService.set(this._getallindexesmasterAPI, pagesIndex, pagesSize);
    return this.accountService.get();
  }

  CheckDuplicateIndexesName(indexes: Indexes) {
    this.accountService.set(this._checkduplicateindexesnameAPI);
    return this.accountService.post(JSON.stringify(indexes));
  }

  GetIndexesDetailByIndexesMasterGuid(indexesMasterGuid:any) {
    this.accountService.set(this._getindexesdetailbyindexesmasterAPI);
    return this.accountService.post(JSON.stringify(indexesMasterGuid));
  }

  InsertUpdateIndexesMasterdetail(indexes: Indexes) {
    this.accountService.set(this._insertupdateindexesmasterdetailAPI);
    return this.accountService.post(JSON.stringify(indexes));
  }

  AddUpdateIndexTypeList(indtype:any) {
    this.accountService.set(this._addupdateindextypeListAPI);
    return this.accountService.post(JSON.stringify(indtype));
  }

  GetIndexesExportDataByIndexesMasterId(_indexesSearch: IndexesSearch) {
    this.accountService.set(this._getindexesexportdatabyindexesmasteridAPI);
    return this.accountService.post(JSON.stringify(_indexesSearch));
  }

  GetIndexListByIndexesMasterID(id: string, pageIndex?: number, pageSize?: number) {
    this.accountService.setbyId(this._getindexlistbyindexesMasterIDAPI, id, pageIndex, pageSize);
    return this.accountService.getByIdwithPaging();
  }


  GetIndexListByDate(_indexesSearch: IndexesSearch) {
    this.accountService.set(this._getindexlistbydateAPI);
    return this.accountService.post(JSON.stringify(_indexesSearch));
  }

  /*

  ResetDefaultToActiveScenario(pagename) {
      this.accountService.set(this._resetdefaulttoactivescenarioAPI);
      return this.accountService.post(JSON.stringify(pagename));
  }

 

 

  getAllLookup() {
      this.accountService.set(this._getallLookupAPI);
      return this.accountService.getAll();
  }

 


  getIndexesFromIndexesMaster() {
      this.accountService.set(this._getIndexesFromIndexesMasterAPI);
      return this.accountService.getAll();
  }
  */
  ImportIndexes(indexes: Indexes) {
    this.accountService.set(this._importindexesAPI);
    return this.accountService.post(JSON.stringify(indexes));
  }

  importindexbyapi(indexes:any, pagesIndex?: number, pagesSize?: number) {
    this.accountService.set(this._refreshliborAPI, pagesIndex, pagesSize);
    return this.accountService.post(JSON.stringify(indexes));
  }
}
