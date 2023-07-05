import { Injectable, Directive } from '@angular/core';
import { Message, MsgSpeech } from '../domain/botMessage.model';
import { DataService } from './data.service';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { BehaviorSubject, Observable, Subject } from 'rxjs';
import { map } from 'rxjs/operators';
import { LoggingService } from './logging.service';
import { Router } from '@angular/router';


@Injectable()
export class ChatService {
  private _insertchatlogfromdashboardAPI: string = 'api/HBOT/insertchatlogfordashboard';
  conversation = new BehaviorSubject<Message[]>([]);
  public formValue: string = "";
  public QuesAnsasked: any;
  public botstatus: string = '';
  public intentName!: string;
  public _isnewpageRender: boolean = false;
  public _pagePath: any;
  private subject = new Subject<any>();

  constructor(public accountService: DataService, public httpClient: HttpClient, private _router: Router,) { }


  // Sends and receives messages via DialogFlow
  converse(msg: string, _isShowchatpopup:boolean) {
    var usertokenUI = localStorage.getItem('AITokenUId');
    var usertoken = localStorage.getItem('AIToken');
    var loginsession = localStorage.getItem('AISession');
    var _dialogflowbaseurl: any = localStorage.getItem('dialogflowbaseurl');
    var _API_Key: any = localStorage.getItem('API_Key');
    this.formValue = "";
    const userMessage = new Message(
      new MsgSpeech(msg, 'text', "null", "null"),
      'user',
      this.create_UUID(),
      false
    );
    this.QuesAnsasked = msg;
    this.update(userMessage, _isShowchatpopup);
    this.intentName = '';
    this.formValue = "";
    var headers = new HttpHeaders();
    headers = headers.append("auth_key", _API_Key); 
    var JSONdata = {
      "user_utterance": msg,
      "client_api_auth_token": usertokenUI + '|' + usertoken,
      "session_id": loginsession
    };

    //call dialogflowapi to get response
    try {
      this.accountService.postforAIchat(_dialogflowbaseurl, JSONdata, headers)
        .subscribe(val => {
          let speech: any;
        if (val) {
          speech = val;
        } else {
          speech = { speech: speech, type: 'text' };
        }
        const botMessage = new Message(
          new MsgSpeech(speech.output, speech.type, speech.status, speech.intent_name),
          'bot',
          this.create_UUID(),
          false
        );
        this.botstatus = speech.status;
        this.intentName = speech.intent_name;
        this.update(botMessage, _isShowchatpopup);
      });
    } catch (err) {
         console.log("AI_Assistant ", "info", " Question :" + this.QuesAnsasked + " : No response from dialog Flow API");
    }

  }

  create_UUID() {
  var dt = new Date().getTime();
  var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
    var r = (dt + Math.random() * 16) % 16 | 0;
    dt = Math.floor(dt / 16);
    return (c == 'x' ? r : (r & 0x3 | 0x8)).toString(16);
  });
  return uuid;
  } 

  // Adds message to source
  update(msg: Message, _isShowchatpopup:boolean) {
    let content: any = msg.content;
    var openurl: any = "";
    if (msg.sentBy == 'bot') {
      if (msg.content.Type == 'url') {
        openurl = msg.content.Speech;
        msg.content.Speech = "";
        msg.content.Speech = "The requested page is being opened.";
      }
      if (msg.content.Type == 'download') {
        var downloadurl: any = msg.content.Speech;
        msg.content.Speech = "";
        msg.content.Speech = "Download request submitted.";
      }
      this.QuesAnsasked = msg.content.Speech;
      switch (content.Type) {
        case 'download':
          this.DownloadFile(msg, downloadurl);
          break;
        case 'table':
          break;
        case 'url':
          this._isnewpageRender = true;
          var dealindex = openurl.indexOf("dealdetail/");
          var noteindex = openurl.indexOf("notedetail/");
          if (dealindex > 0) {
            var _url = openurl.split("dealdetail/");
            var dealid = _url[1];
            if (window.location.href.indexOf("dealdetail/a") > -1) {
              this._pagePath = ['dealdetail', dealid];
            }
            else {
              this._pagePath = ['dealdetail/a', dealid];
            }
          }
          if (noteindex > 0) {
            var _url = openurl.split("notedetail/");
            var noteid = _url[1];
            if (window.location.href.indexOf("notedetail/a") > -1) {
              this._pagePath = ['notedetail', noteid];
            }
            else {
              this._pagePath = ['notedetail/a', noteid];
            }
          }
          this._router.navigate(this._pagePath);
          break;
        case 'text':
          break;
      }
      this.conversation.next([msg]);
    } else {
      this.conversation.next([msg]);
    }

    //for chat logging 
    if (this.QuesAnsasked != undefined && msg.content.status != undefined) {
      var dtchatqueans = [];
      var loginsession = localStorage.getItem('AISession');
      if (!(msg.sentBy.toString() == "null")) {
        dtchatqueans.push({
          "Status": msg.content.status,
          "Question": this.QuesAnsasked,
          "IntentName": msg.content.intentName,
          "SentBy": msg.sentBy,
          "LoginSession": loginsession
        });
        msg.sentBy = "null";
        this.QuesAnsasked = undefined;
        this.insertChatLogfromDashboard(dtchatqueans).subscribe(res => {
          if (res) {
          }
        });
      }
    }
  }


  errorHandler(error: any): void {
    console.log(error);
  }

  DownloadFile(msg: Message, downloadurl: string) {
    var usertokenUI:any = localStorage.getItem('AITokenUId');
    var TokenUId = usertokenUI;
    this.httpClient.get(downloadurl, { headers: TokenUId })
      .pipe(map((res: any) => (res)))
      .subscribe((res) => {
        var items = res.Listdt;
        var fileName = res.SingleResult;
        const replacer = (key, value) => (value === null ? "" : value);
        const header = Object.keys(items[0]);
        let csv = items.map((row) =>
          header
            .map((fieldName) => JSON.stringify(row[fieldName], replacer))
            .join(",")
        );
        csv.unshift(header.join(","));
        csv = csv.join("\r\n");

        const blob = new Blob(["\ufeff" + csv], {
          type: "text/csv;charset=utf-8;",
        });
        const url = window.URL.createObjectURL(blob);

        if (navigator.msSaveOrOpenBlob) {
          navigator.msSaveBlob(blob, fileName + ".csv");
        } else {
          const a = document.createElement("a");
          a.href = url;
          a.download = fileName + ".csv";
          document.body.appendChild(a);
          a.click();
          document.body.removeChild(a);
        }
        window.URL.revokeObjectURL(url);
        msg.enableLoading = false;
      },
      (error) => {
        msg.enableLoading = false;
        console.log(error);
      }
    );
  }

  ConvertToCSV(objArray) {
    var array = typeof objArray != "object" ? JSON.parse(objArray) : objArray;
    var str = "";

    for (var i = 0; i < array.length; i++) {
      var line = "";
      for (var index in array[i]) {
        if (line != "") line += ",";

        line += array[i][index];
      }

      str += line + "\r\n";
    }

    return str;
  }

  sendMessage(message: string) {
    this.subject.next({ text: message});
  }

  clearMessages() {
    this.subject.next();
  }

  getMessage(): Observable<any> {
    return this.subject.asObservable();
  }

  insertChatLogfromDashboard(dtchatqueans: any) {
    this.accountService.set(this._insertchatlogfromdashboardAPI);
    return this.accountService.post(JSON.stringify(dtchatqueans));
  }
}
