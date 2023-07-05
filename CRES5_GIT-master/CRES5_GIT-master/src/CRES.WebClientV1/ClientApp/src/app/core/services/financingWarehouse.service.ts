import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { FinancingWarehouse } from '../domain/financingWarehouse.model';


@Injectable()
export class financingWarehouseService {
  private _fwarehouseGetAllFinancingWarehouseAPI: string = 'api/account/GetFinancingWarehouse';
  private _fwarehouseaddUpdateFinancingWarehouseAPI: string = 'api/note/addUpdateFinancingWarehouse';
  private _fwarehousegetFinancingWarehouseByIdAPI: string = 'api/note/getFinancingWarehouseById';
  private _fwarehouseaddUpdateFinancingWarehouseDetailsAPI: string = 'api/note/addUpdateFinancingWarehouseDetails';

  constructor(public accountService: DataService) { }

  GetAllFinancingWarehouse(pagesIndex?: number, pagesSize?: number) {
    this.accountService.set(this._fwarehouseGetAllFinancingWarehouseAPI, pagesIndex, pagesSize);
    return this.accountService.get();
  }


  SaveFinancing(_fwarehouse: FinancingWarehouse) {
    this.accountService.set(this._fwarehouseaddUpdateFinancingWarehouseAPI);
    return this.accountService.post(JSON.stringify(_fwarehouse));
  }


  SaveFinancingDetails(_fwarehouse: FinancingWarehouse) {
    this.accountService.set(this._fwarehouseaddUpdateFinancingWarehouseDetailsAPI);
    return this.accountService.post(JSON.stringify(_fwarehouse));
  }

  getFinancingWhousebyId(_fwarehouse: FinancingWarehouse) {
    this.accountService.set(this._fwarehousegetFinancingWarehouseByIdAPI);
    return this.accountService.post(JSON.stringify(_fwarehouse));
  }
}
