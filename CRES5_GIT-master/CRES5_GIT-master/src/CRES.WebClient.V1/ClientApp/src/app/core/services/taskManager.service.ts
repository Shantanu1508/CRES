import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { Search } from '../domain/search.model';
import { TaskManagement } from '../domain/taskManagement.model';
@Injectable()
export class TaskManagerService {
  private _getallLookupAPI: string = 'api/taskmanagement/getallLookup';
  private _insertupdatetaskApi: string = 'api/taskmanagement/insertupdatetask';
  private _GetAllTaskApi: string = 'api/taskmanagement/getalltask';
  private _GetTaskByTaskIDApi: string = 'api/taskmanagement/taskbytaskid';
  private _GetNotifyEmailDApi: string = 'api/taskmanagement/getsubscribeduserbytaskid';
  private _searchGetAutosuggestSearchUserNameAPI: string = 'api/search/getautosuggestsearchusername';
  private _insertupdatetaskCommentApi: string = 'api/taskmanagement/insertupdatetaskcomment';
  private _GetCommentsByTaskIDApi: string = 'api/taskmanagement/commentsbytaskid';
  private _insertupdateSubscribeUserApi: string = 'api/taskmanagement/insertsubscriptiondata';
  constructor(public datasrv: DataService) { }



  getAllLookup() {
    this.datasrv.set(this._getallLookupAPI);
    return this.datasrv.getAll();
  }

  InsertUpdateTask(taskdc: any) {
    this.datasrv.set(this._insertupdatetaskApi);
    return this.datasrv.post(JSON.stringify(taskdc));
  }


  InsertUpdateSubscribeUser(taskdc: any) {
    this.datasrv.set(this._insertupdateSubscribeUserApi);
    return this.datasrv.post(JSON.stringify(taskdc));
  }

  //getAllTask(pagesIndex?: number, pagesSize?: number) {
  //    this.datasrv.set(this._GetAllTaskApi, pagesIndex, pagesSize);
  //    return this.datasrv.get();
  //}


  getAllTask(_task: TaskManagement, pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._GetAllTaskApi, pagesIndex, pagesSize);
    return this.datasrv.post(JSON.stringify(_task));
  }

  getTaskByTaskID(TaskID: any) {
    this.datasrv.set(this._GetTaskByTaskIDApi);
    return this.datasrv.post(JSON.stringify(TaskID));
  }


  getNotifyEmail(TaskID: any) {
    this.datasrv.set(this._GetNotifyEmailDApi);
    return this.datasrv.post(JSON.stringify(TaskID));
  }

  getAutosuggestSearchUsername(_search: Search, pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._searchGetAutosuggestSearchUserNameAPI, pagesIndex, pagesSize);
    return this.datasrv.post(JSON.stringify(_search));
  }


  InsertUpdateTaskComment(taskCommentdc: any) {
    this.datasrv.set(this._insertupdatetaskCommentApi);
    return this.datasrv.post(JSON.stringify(taskCommentdc));
  }


  GetTCommentsByTaskID(taskCommentdc: any) {
    this.datasrv.set(this._GetCommentsByTaskIDApi);
    return this.datasrv.post(JSON.stringify(taskCommentdc));
  }



}
