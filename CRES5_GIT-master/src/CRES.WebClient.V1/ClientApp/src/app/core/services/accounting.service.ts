import { Injectable  } from '@angular/core';
import { DataService } from './data.service';
import { Note } from '../domain/note.model';
import { Periodic } from '../domain/periodic.model';


@Injectable()
export class accoutingservice {
  private _getallperiodiccloseAPI: string = 'api/accounting/getallaccountingclose';
  private _saveaccountingCloseAPI: string = 'api/accounting/saveaccountingbyclosedate';
  private _saveaccountingOpenAPI: string = 'api/accounting/saveaccountingbyopendate';
  private _getPeriodicDataByNoteIdAPI: string = 'api/note/GetPeriodicDataByNoteId';
  private _getPeriodicCloseByUserIDAPI: string = 'api/periodic/getperiodicclosebyuserid';
  private _savePeriodicCloseAPI: string = 'api/periodic/saveperiodicclose';
  private _openPeriodicCloseAPI: string = 'api/periodic/openperiodicclose';
  private _getallportfolioAPI: string = 'api/portfolio/getallportfolio';
  constructor(public datasrv: DataService) {
  }



  getallaccountingclose(PortfolioMasterGuid) {
    this.datasrv.set(this._getallperiodiccloseAPI);
    return this.datasrv.post(JSON.stringify(PortfolioMasterGuid));
  }


  public saveaccountingClose(lstaccountingClose: any) {
    this.datasrv.set(this._saveaccountingCloseAPI);
    return this.datasrv.post(JSON.stringify(lstaccountingClose));
  }

  public saveaccountingOpen(lstaccountingClose: any) {
    this.datasrv.set(this._saveaccountingOpenAPI);
    return this.datasrv.post(JSON.stringify(lstaccountingClose));
  }


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


  public getallportfolio() {
    this.datasrv.set(this._getallportfolioAPI);
    return this.datasrv.getAll();
  }


}
