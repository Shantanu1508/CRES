import { Injectable, Directive } from '@angular/core';
import { Message, MsgSpeech } from '../domain/botMessage.model';
import { DataService } from './data.service';
import { HttpClient } from '@angular/common/http';

@Injectable()
export class ChatService {
  private _insertchatlogfromdashboardAPI: string = 'api/HBOT/insertchatlogfordashboard';
  private msg: any = [];

  constructor(public accountService: DataService, public http: HttpClient) { }


  //set message from appcomponent for AI.
  setMessage(val: any) {
    this.msg = val;
  }


  //get message from appcomponent for AI.
  getMessage() {
    return this.msg;
  }


  insertChatLogfromDashboard(dtchatqueans: any) {
    this.accountService.set(this._insertchatlogfromdashboardAPI);
    return this.accountService.post(JSON.stringify(dtchatqueans));
  }


}
