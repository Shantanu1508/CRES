import { Injectable } from '@angular/core';
import { DataService } from './data.service';

@Injectable()
export class feeconfigurationService {
  private _getallfeefunctionsconfigAPI: string = 'api/feeconfiguration/getallfeefunctionsconfig';
  private _getallfeeschedulesconfigAPI: string = 'api/feeconfiguration/getallfeeschedulesconfig';
  private _addupdatefeefunctionsconfigAPI: string = 'api/feeconfiguration/addupdatefeefunctionsconfig';
  private _addupdatefeeconfigAPI: string = 'api/feeconfiguration/addupdatefeeconfig';
  private _deletefeeschedulesconfigAPI: string = 'api/feeconfiguration/deletefeeschedulesconfig';
  private _deletefeefunctionsconfigAPI: string = 'api/feeconfiguration/deletefeefunctionsconfig';

  private _getpayruledropdownfeeschedulesAPI: string = 'api/feeconfiguration/getpayruledropdownfeeschedules';

  constructor(public accountService: DataService) { }


  GetAllFeeFunction() {
    this.accountService.set(this._getallfeefunctionsconfigAPI);
    return this.accountService.getAll();
  }

  GetAllFeeAmount() {
    this.accountService.set(this._getallfeeschedulesconfigAPI);
    return this.accountService.getAll();
  }

  SaveFeeConfig(feeconfig: any) {
    this.accountService.set(this._addupdatefeeconfigAPI);
    return this.accountService.post(JSON.stringify(feeconfig));
  }

  DeleteScheduleConfig(FeeTypeGuID: string) {
    this.accountService.set(this._deletefeeschedulesconfigAPI);
    return this.accountService.post(JSON.stringify(FeeTypeGuID));
  }

  DeleteFunctionConfig(FunctionGuID: string) {
    this.accountService.set(this._deletefeefunctionsconfigAPI);
    return this.accountService.post(JSON.stringify(FunctionGuID));
  }

  GetPayRuleDropDownFeeSchedules() {
    this.accountService.set(this._getpayruledropdownfeeschedulesAPI);
    return this.accountService.getAll();
  }

}
