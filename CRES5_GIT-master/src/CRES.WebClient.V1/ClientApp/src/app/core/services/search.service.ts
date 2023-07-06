import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { Search } from '../domain/search.model';

@Injectable()
export class SearchService {
  private _searchGetAutosuggestSearchDataAPI: string = 'api/search/getautosuggestsearchdata';

  private _searchGetAutosuggestPIKAccountAPI: string = 'api/search/getautosuggestpikaccount';
  private _updaterankinsearchitemAPI: string = 'api/search/updaterankinsearchitem';
  private _searchGetAutosuggestSearchDealAPI: string = 'api/search/getautosuggestsearchdeal';

  constructor(public dataService: DataService) { }

  getAutosuggestSearchData(_search: Search, pagesIndex?: number, pagesSize?: number) {
    this.dataService.set(this._searchGetAutosuggestSearchDataAPI, pagesIndex, pagesSize);
    return this.dataService.post(JSON.stringify(_search));
  }


  getAutosuggestPIKAcccount(_search: Search, pagesIndex?: number, pagesSize?: number) {
    this.dataService.set(this._searchGetAutosuggestPIKAccountAPI, pagesIndex, pagesSize);
    return this.dataService.post(JSON.stringify(_search));
  }


  UpdateRankInSearchItem(_search: Search) {
    this.dataService.set(this._updaterankinsearchitemAPI);
    return this.dataService.post(JSON.stringify(_search));
  }

  getAutosuggestSearchDeal(_search: Search, pagesIndex?: number, pagesSize?: number) {
    this.dataService.set(this._searchGetAutosuggestSearchDealAPI, pagesIndex, pagesSize);
    return this.dataService.post(JSON.stringify(_search));
  }




}
