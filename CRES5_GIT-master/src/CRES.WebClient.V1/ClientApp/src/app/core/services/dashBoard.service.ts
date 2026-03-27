import { Injectable } from '@angular/core';
import { DataService } from './data.service';
//import { Dashboard } from '../domain/dashboard';

@Injectable()
export class DashboardService {
  private _dashboardDataAPI: string = 'api/account/getdashboardbyuserid';
  private _insertbookmarkAPI: string = 'api/account/InsertUpdateBookMark';
  constructor(public dashboardDataService: DataService) { }

  getAllDashboardData() {
    this.dashboardDataService.set(this._dashboardDataAPI);
    return this.dashboardDataService.getAll();
  }
  InsertUpdateBookMark(BookmarkParam: any) {
    this.dashboardDataService.set(this._insertbookmarkAPI);
    return this.dashboardDataService.post(JSON.stringify(BookmarkParam));
  }
}
