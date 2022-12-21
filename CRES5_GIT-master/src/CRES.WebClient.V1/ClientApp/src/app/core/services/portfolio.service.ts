import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { portfolio } from "../domain/portfolio.model";
@Injectable()
export class portfolioService {

  private _addupdateportfolioAPI: string = 'api/portfolio/addupdateportfolio';
  private _getallportfolioAPI: string = 'api/portfolio/getallportfolio';
  private _getportfoliodetailbyidAPI: string = 'api/portfolio/getportfoliodetailbyid';



  constructor(public accountService: DataService) { }
  //getAllDeals(_user:User) {
  //    this.accountService.set(this._accountGetAllDeal);
  //    return this.accountService.post(_user);
  //}

  addupdateportfolio(_portfolio: portfolio) {
    this.accountService.set(this._addupdateportfolioAPI);
    return this.accountService.post(JSON.stringify(_portfolio));
  }

  getallportfolio() {
    this.accountService.set(this._getallportfolioAPI);
    return this.accountService.getAll();
  }


  getportfoliodetailbyid(_portfolio: portfolio) {
    this.accountService.set(this._getportfoliodetailbyidAPI);
    return this.accountService.post(JSON.stringify(_portfolio));
  }
}
