import { Injectable, OnInit } from '@angular/core';
//declare var alertify: any;
var alertify = require('../../../assets/js/alertify');

@Injectable()
export class NotificationService {
  private _notifier: any = alertify;
  constructor() {
  }

  printSuccessMessage(message: string) {
    this._notifier.success(message);
  }

  printErrorMessage(message: string) {
    this._notifier.error(message);
  }

  printConfirmationDialog(message: string, okCallback: () => any) {
    this._notifier.confirm(message, function (e:any) {
      if (e) {
        okCallback();
      } else {
      }
    });
  }
}
