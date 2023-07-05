import { Injectable } from '@angular/core';
import { DataService } from './data.service';


@Injectable()
export class LoggingService {

  private _writeToLog: string = 'api/logging/writeLog';
  constructor(public datasrv: DataService) { }

  Savelog(logtext : any) {
    this.datasrv.set(this._writeToLog);
    return this.datasrv.post(JSON.stringify(logtext));
  }
  writeToLog(module: string, logtype: string, logtext: string) {
    var text = module + "||" + logtype + "||" + logtext;

    this.Savelog(text).subscribe(res => {
      if (res.Succeeded) {
      }
      else {

      }
    });

  }
}
