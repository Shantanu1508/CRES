import { Injectable } from '@angular/core';
import { DataService } from './data.service';
//import { Dashboard } from '../domain/dashboard';

@Injectable()
export class DashboardService {
  private _dashboardDataAPI: string = 'api/account/getdashboardbyuserid';

  constructor(public dashboardDataService: DataService) { }

  getAllDashboardData() {
    this.dashboardDataService.set(this._dashboardDataAPI);
    return this.dashboardDataService.getAll();
  }
}
