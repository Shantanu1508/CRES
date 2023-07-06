import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { backshopImport } from "../domain/backshopImport.model";


@Injectable()
export class ImportServicingLogService {

  constructor(public importUnderwritingService: DataService) {


  }


}
