import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { deals } from '../domain/deals.model';

@Injectable()
export class investorsService {

  private _investorsGetAllLookupAPI: string = 'api/investors/getallLookup';

  constructor(public accountService: DataService) { }
  getAllLookup() {
    this.accountService.set(this._investorsGetAllLookupAPI);
    return this.accountService.getAll();
  }


}
