import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { portfolio } from "../domain/portfolio.model";
@Injectable()
export class portfolioService {

  private _addupdateportfolioAPI: string = 'api/portfolio/addupdateportfolio';
  private _getallportfolioAPI: string = 'api/portfolio/getallportfolio';
  private _getportfoliodetailbyidAPI: string = 'api/portfolio/getportfoliodetailbyid';
  private _getXIRROutputByObjectIDAPI: string = 'api/portfolio/getXIRROutputByObjectID';
  private _getXIRRViewNotesByObjectIDAPI: string = 'api/portfolio/getXIRRViewNotesByObjectID';
  private _getXIRRCalculationStatusByObjectID: string = 'api/portfolio/GetXIRRCalculationStatusByObjectID';
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
  GetXIRROutputByObjectID(PortfolioMasterID: any) {
    this.accountService.set(this._getXIRROutputByObjectIDAPI);
    return this.accountService.post(JSON.stringify(PortfolioMasterID));
  }

  GetXIRRCalculationStatusByObjectID(PortfolioMasterID: any) {
    this.accountService.set(this._getXIRRCalculationStatusByObjectID);
    return this.accountService.post(JSON.stringify(PortfolioMasterID));
  }
 
  GetXIRRViewNotesByObjectID(portfolioDC: any) {
    this.accountService.set(this._getXIRRViewNotesByObjectIDAPI);
    return this.accountService.post(JSON.stringify(portfolioDC));
  }

  
}
