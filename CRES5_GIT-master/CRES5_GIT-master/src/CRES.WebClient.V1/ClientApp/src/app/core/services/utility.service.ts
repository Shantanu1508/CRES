
import { Injectable } from '@angular/core';
import { Router } from '@angular/router'
import { Title } from '@angular/platform-browser';
import appsettings from '../../../../../appsettings.json';
//import { _dateMinRange, _dateMinRangeView } from '../../../../../appsettings.json';

@Injectable()
export class UtilityService {
  //==private routes = Routes;

  public _dateMinRange: string = "";
  public _dateMinRangeView: string = "";
  public _dtUTCHours !: number;
  public _userOffset !: number;
  public _centralOffset !: number;

  constructor(private _router: Router, private title: Title) {
  }

  navigate(path: string) {
    this._router.navigate([path]);
  }

  navigateToSignIn() {
    //this.navigate('/Account/Login');
    this._router.navigate(['/login']);
  }
  navigateUnauthorize() {
    this._router.navigate(['/dashboard']);
  }


  setPageTitle(pagetitle: string) {

    this.title.setTitle(pagetitle);
  }

  getDateMinRange(): string {
    //alert('AppSettings._dateMinRange ' + AppSettings._dateMinRange);
    this._dateMinRange = appsettings._dateMinRange;
    return this._dateMinRange;
  }

  getDateMinRangeView(): string {
    //alert('AppSettings._dateMinRange ' + AppSettings._dateMinRange);
    this._dateMinRangeView = appsettings._dateMinRangeView;
    return this._dateMinRangeView;
  }


  convertDatetoGMT(date: Date) {

    if (date != null) {

      var _date = new Date();
      this._dtUTCHours = _date.getTimezoneOffset() / 60; //_date.getUTCHours();
      //alert('date getTimezoneOffset' + _date.getTimezoneOffset() );
      this._userOffset = _date.getTimezoneOffset() * 60 * 1000; // user's offset time

      if (this._dtUTCHours < 6) {
        this._centralOffset = 6 * 60 * 60 * 1000; // 6 for central time - use whatever you need
      }
      else {
        this._centralOffset = this._dtUTCHours * 60 * 60 * 1000; // 6 for central time - use whatever you need
      }

      date = new Date(date);
      var _userOffset = date.getTimezoneOffset() * 60 * 1000; // user's offset time
      var _centralOffset = this._dtUTCHours * 60 * 60 * 1000; // 6 for central time - use whatever you need
      date = new Date(date.getTime() - this._userOffset + this._centralOffset); // redefine variable
      return date;
    }
    else
      return date;
  }

}
