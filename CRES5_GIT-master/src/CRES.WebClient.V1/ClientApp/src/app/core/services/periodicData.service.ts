import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { Note } from '../domain/note.model';
import { Periodic } from '../domain/periodic.model';


@Injectable()
export class PeriodicDataService {


  private _getPeriodicDataByNoteIdAPI: string = 'api/note/GetPeriodicDataByNoteId';
  private _getPeriodicCloseByUserIDAPI: string = 'api/periodic/getperiodicclosebyuserid';
  private _savePeriodicCloseAPI: string = 'api/periodic/saveperiodicclose';
  private _openPeriodicCloseAPI: string = 'api/periodic/openperiodicclose';

  constructor(public datasrv: DataService) {
  }

  //,pagesIndex?: number, pagesSize?: number, modulename?: string

  getPeriodicDataByNoteId(_note: Note, pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._getPeriodicDataByNoteIdAPI, pagesIndex, pagesSize);
    return this.datasrv.post(JSON.stringify(_note));
  }

  public getPeriodicCloseByUserID(_periodic: Periodic) {
    this.datasrv.set(this._getPeriodicCloseByUserIDAPI);
    return this.datasrv.post(JSON.stringify(_periodic));
  }

  public savePeriodicClose(_periodic: Periodic) {
    this.datasrv.set(this._savePeriodicCloseAPI);
    return this.datasrv.post(JSON.stringify(_periodic));
  }
  public openPeriodicClose(_periodic: Periodic) {
    this.datasrv.set(this._openPeriodicCloseAPI);
    return this.datasrv.post(JSON.stringify(_periodic));
  }


}
