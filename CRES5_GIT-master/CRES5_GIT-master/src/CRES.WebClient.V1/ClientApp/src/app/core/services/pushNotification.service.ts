import { Injectable } from '@angular/core';
import { DataService } from './data.service';

@Injectable()
export class PushNotificationService {
  private _notificationsubscriptionAPI: string = 'api/notification/notificationsubscription'
  private _savenotificationsubscriptionAPI: string = 'api/notification/addupdatenotificationsubscription'
  private _getallnotificationAPI: string = 'api/notification/allnotification'
  private _getallnotificationsAPI: string = 'api/notification/getallnotifications';
  private _clearnotificationsAPI: string = 'api/notification/clearnotifications';
  private _clearallnotificationsAPI: string = 'api/notification/clearallnotifications';
  private _clearallnotificationscountAPI: string = 'api/notification/clearallnotificationscount';
  private _getusernotificationscountAPI: string = 'api/notification/getusernotificationscount';

  constructor(public datasrv: DataService) { }


  getnotificationsubscription(pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._notificationsubscriptionAPI, pagesIndex, pagesSize);
    return this.datasrv.get();
  }


  savenotificationsubscription(_notificationSubscription: any) {
    this.datasrv.set(this._savenotificationsubscriptionAPI);
    return this.datasrv.post(JSON.stringify(_notificationSubscription));
  }

  public getallnotification(dt: string, pageindex?: number, pagesize?: number) {
    this.datasrv.setbyId(this._getallnotificationAPI, dt, pageindex, pagesize);
    return this.datasrv.getByIdwithPaging();
    //this.datasrv.set(this._getallnotificationAPI);
    //return this.datasrv.post(JSON.stringify(dt));
  }

  getAllUserNotification(dt: string) {
    this.datasrv.set(this._getallnotificationsAPI);
    return this.datasrv.post(JSON.stringify(dt));
  }

  ClearUserNotification(notificationid: any) {
    this.datasrv.set(this._clearnotificationsAPI);
    return this.datasrv.post(JSON.stringify(notificationid));
  }


  ClearAllUserNotification() {
    this.datasrv.set(this._clearallnotificationsAPI);
    return this.datasrv.getAll();
  }


  ClearUserNotificationCount() {
    this.datasrv.set(this._clearallnotificationscountAPI);
    return this.datasrv.getAll();
  }


  GetUserNotificationCount() {
    this.datasrv.set(this._getusernotificationscountAPI);
    return this.datasrv.getAll();
  }

}
