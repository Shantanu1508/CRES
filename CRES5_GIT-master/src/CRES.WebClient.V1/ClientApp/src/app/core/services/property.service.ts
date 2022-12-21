import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { Property } from '../domain/property.model';


@Injectable()
export class propertyService {
  private _propertygetallpropertyAPI: string = 'api/property/getallproperty';
  private _propertyUpdateProperty: string = 'api/property/updateProperty';

  constructor(public datasrv: DataService) { }

  getallproperty(_prop: Property, pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._propertygetallpropertyAPI, pagesIndex, pagesSize);
    return this.datasrv.post(JSON.stringify(_prop));
  }

  //getallproperty() {
  //    this.datasrv.set(this._propertygetallproperty);
  //    return this.datasrv.getAll();
  //}

  AddupdateProperty(_propert: Property) {
    this.datasrv.set(this._propertyUpdateProperty);

    var s = JSON.stringify(_propert);
    return this.datasrv.post(s);
  }
}
