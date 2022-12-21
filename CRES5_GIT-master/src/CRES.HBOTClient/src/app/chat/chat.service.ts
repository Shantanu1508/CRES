import { Injectable } from "@angular/core";
import { environment } from "../../environments/environment";
import * as uuid from "uuid";
import { Observable } from "rxjs/Observable";
import { BehaviorSubject } from "rxjs/BehaviorSubject";
import { DataService } from "../services/data.service";
import { HttpClient } from "@angular/common/http";
import { tap } from "rxjs/operators";
import { error } from "util";
import{AppComponent} from "../app.component";



// Message class for displaying messages in the component
export class Message {
  constructor(
    public content: MsgSpeech,
    public sentBy: string,
    public messageID: string,
    public enableLoading: boolean
  ) {}
}

export class MsgSpeech {
  constructor(public Speech: string, public Type: string, public status:string) {}
}

@Injectable()
export class ChatService {
  conversation = new BehaviorSubject<Message[]>([]);
  loadingImage = new BehaviorSubject<Message[]>([]);
  AutoLoadingImage = new BehaviorSubject<boolean>(false);
  IsApplicationReload = false;
  IsSessionRefresh = false;
  MessageHistory = [];
  QuesAnsasked:any;
  firstmsg =  "this is user token " + 
                sessionStorage.getItem("TokenUI")
                 +" do not change it.";
  botmsg = "What is the userToken?";
  _botmsg="Hello there! How can I help you?";
  _isrefreshsession:boolean=false;
  //to get response from dialogflow via python
  private baseURL: string = environment.dialogflow.dialogflowbaseurl;;
  constructor(public DataService: DataService, public httpClient: HttpClient) {
    
  }


  // Sends and receives messages via DialogFlow
  converse(msg: string) {
    const userMessage = new Message(
      new MsgSpeech(msg, 'text',status),
      'user',
      uuid.v4(),
      false
    );
    // to call chat log api assigning question variable
    if(this.firstmsg != msg)
    {
    this.QuesAnsasked = "Question:" + msg;
    }
   
    this.update(userMessage);
    
    let usertoken = sessionStorage.getItem('Token');
    let sessionid = sessionStorage.getItem("LoginSession");
    var encodedmsg = encodeURIComponent(msg);

    //call dialogflowapi to get response
    return this.httpClient.post(`${this.baseURL}`+encodedmsg +'&usertoken='+usertoken+'&key='+environment.dialogflow.API_Key+'&sessionid='+sessionid,
     {headers:this.DataService.createAuthorizationHeader()})
    .subscribe(val=>{
     let speech: any;
      if (val) {
        speech = val;
      } else {
        speech = { speech: speech, type: 'text'};
      }
      const botMessage = new Message(
        new MsgSpeech(speech.speech, speech.type,speech.status),
        'bot',
        uuid.v4(),
        false
      );
      this.update(botMessage);
    });
  }

  // Adds message to source
  update(msg: Message) {
    let content: any = msg.content;
    var openurl:any="";
    if (msg.sentBy == 'bot') {
      if(msg.content.Type == 'url'){
        openurl =  msg.content.Speech;
       msg.content.Speech="";
       msg.content.Speech="The requested page is being opened in a new tab.";
     }
      if(this.botmsg == msg.content.Speech || this._botmsg == msg.content.Speech){
        this.QuesAnsasked = undefined;
      } 
      else{
        this.QuesAnsasked = "Answer:" + msg.content.Speech;
      }
      
      switch (content.Type) {
        case 'download':
          var downloadurl = msg.content.Speech;
          msg.content.Speech="Download request submitted.";
          this.DownloadFile(msg,downloadurl);
          break;
        case 'table':
          break;
        case 'url':
          msg.enableLoading = false;
          this.loadingImage.next([msg]);
          const url =
            window.location != window.parent.location
              ? document.referrer
              : document.location.href;
          window.open(openurl.replace('http', url), '_blank');
          break;
        case 'text':
          break;
      }
      msg.enableLoading = false;
      this.loadingImage.next([msg]);
    } else {
      msg.enableLoading = true;
      this.loadingImage.next([msg]);
    }

    //for chat logging 
    if(this.QuesAnsasked != undefined && msg.content.status != undefined){
      const chatlogres = this.DataService.insertchatlog(msg.content.status,this.QuesAnsasked);
    }

    if (this.IsApplicationReload && msg.sentBy == 'bot') {
      var messageArray = [];
      var result = JSON.parse(localStorage.getItem('hbotMessage'));
      result.forEach((element) => {
        var message = new Message(
          new MsgSpeech(element.content.Speech, element.content.Type, element.content.status),
          element.sentBy,
          element.messageID,
          element.enableLoading
        );
        messageArray.push(message);
      });
      this.MessageHistory.concat(messageArray);
      this.conversation.next(messageArray);
      this.IsApplicationReload = false;
    
    } else if (!this.IsApplicationReload) {
      this.MessageHistory.push(msg);
      this.conversation.next([msg]);
    }

    if (msg.sentBy == 'bot') {
      this.synthVoice(msg.content);
    }
  }

  // add voice to response
  synthVoice(text) {
    const synth = window.speechSynthesis;
    const utterance = new SpeechSynthesisUtterance();
    utterance.text = text;
    //synth.speak(utt2erance);
  }

  public getUrlVars(url, key) {
    const vars = [];
    let hash = [];
    const hashes = url.slice(url.indexOf("?") + 1).split("&");
    for (var i = 0; i < hashes.length; i++) {
      hash = hashes[i].split("=");
      vars.push(hash[0]);
      vars[hash[0]] = hash[1];
    }
    return decodeURIComponent(vars[key]);
  }

  search(value): Observable<any> {
    return this.DataService.getAutocomplete(value.replace("@", ""))
      .pipe(
        tap((response: any) => {
          this.AutoLoadingImage.next(false);
          response.results = response.lstSearch;
          return response;
        })
      )
      .catch((e: any) => Observable.throw(this.errorHandler(e)));
  }

  // tslint:disable-next-line: no-shadowed-variable
  errorHandler(error: any): void {
    this.AutoLoadingImage.next(false);
    console.log(error);
  }

  DownloadFile(msg: Message,downloadurl:string) {
    this.DataService.DownloadFile(downloadurl).subscribe(
      (res) => {
        this.loadingImage.next([msg]);
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
       // const fileName = this.getUrlVars(downloadurl, "DealID");

        if (navigator.msSaveOrOpenBlob) {
         // navigator.msSaveBlob(blob, fileName + "-cashflow.csv");
         navigator.msSaveBlob(blob, fileName + ".csv");
        } else {
          const a = document.createElement("a");
          a.href = url;
          a.download = fileName + ".csv";
         // a.download = fileName + "-cashflow.csv";
          document.body.appendChild(a);
          a.click();
          document.body.removeChild(a);
        }
        window.URL.revokeObjectURL(url);
        msg.enableLoading = false;
      },
      (error) => {
        msg.enableLoading = false;
        this.loadingImage.next([msg]);
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

  IsJsonString(str: string) {
    try {
      JSON.parse(str);
    } catch (error) {
      return false;
    }
    return true;
  }
  
  conversetorefreshsession(msg: string) {
    const userMessage = new Message(
      new MsgSpeech(msg, 'text',status),
      'user',
      uuid.v4(),
      false
    );
   
    this.updatemsg(userMessage);
    
    let usertoken = sessionStorage.getItem('Token');
    let sessionid = sessionStorage.getItem("LoginSession");
    //call dialogflowapi to get response
    return this.httpClient.post(`${this.baseURL}`+msg +'&usertoken='+usertoken+'&key='+environment.dialogflow.API_Key+'&sessionid='+sessionid,
     {headers:this.DataService.createAuthorizationHeader()})
    .subscribe(val=>{
     let speech: any;
      if (val) {
        speech = val;
      } else {
        speech = { speech: speech, type: 'text'};
      }
      const botMessage = new Message(
        new MsgSpeech(speech.speech, speech.type,speech.status),
        'bot',
        uuid.v4(),
        false
      );
      this.updatemsg(botMessage);
    });
    
  }

  // Adds message to source
  updatemsg(msg: Message) {
    let content: any = msg.content;
    if (msg.sentBy == 'bot') {
      msg.enableLoading = false;
      this.loadingImage.next([msg]);
    } else {
      msg.enableLoading = false;
      this.loadingImage.next([msg]);
    }
    
  }
}
