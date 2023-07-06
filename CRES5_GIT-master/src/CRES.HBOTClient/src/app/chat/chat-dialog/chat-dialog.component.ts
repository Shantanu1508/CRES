import {
  Component,
  OnInit,
  ViewChild,
  ElementRef,
  HostListener,
} from "@angular/core";
import { ChatService, Message, MsgSpeech } from "../chat.service";
import { Observable } from "rxjs/Observable";
import "rxjs/add/operator/scan";
import { SpeechRecognitionService } from "../../speech-recognition.service";
import { FormControl } from "@angular/forms";
import { map, startWith, switchMap, debounceTime } from "rxjs/operators";
import { MatOptionSelectionChange } from "@angular/material";
import { Subject } from "rxjs";

export interface User {
  name: string;
}

@Component({
  selector: "app-chat-dialog",
  templateUrl: "./chat-dialog.component.html",
  styleUrls: ["./chat-dialog.component.css"],
})
export class ChatDialogComponent implements OnInit {
  @ViewChild("msgArea") msgArea: ElementRef;
  @ViewChild("sendButtonRef") sendButtonRef: ElementRef;
  @ViewChild("micimage") micImage: ElementRef;
 

  myControl = new FormControl();
  filteredOptions: Observable<any>;
  isLoadingImageEnable: boolean = false;
  SelectedItem: string = "";
  public scrollMe: number;
  public show: boolean = false;
  public FakeHandler: boolean = false;

  startListenButton: boolean;
  stopListeningButton: boolean;
  speechData: string;
  messages: Observable<Message[]>;
  loadingImage: Observable<Message[]>;
  AutocompleteLoadingImage: Observable<boolean>;
  isLoadingImage: boolean;
  MessageID: string;
  formValue: string;
  interval;
  timeStart : number = 60*12;
  userActivity;
  userInactive: Subject<any> = new Subject();
  _isuserinactive:boolean = false;
 
  constructor(
    public chatService: ChatService,
    private speechRecognitionService: SpeechRecognitionService
  ) {
    this.startListenButton = true;
    this.stopListeningButton = false;
    this.speechData = "";
    setTimeout(() => {
     this.refreshSession();
    }, 2000);

    //to check user inactivity
    this.checkUserActivity();
    this.userInactive.subscribe(() => this._isuserinactive=true);
  }

  ngOnInit() {
    this.filteredOptions = this.myControl.valueChanges.pipe(
      startWith(""),
      debounceTime(200),
      switchMap((value) => {
        if (value.indexOf("@") !== -1) {
          const re = new RegExp(/[@]\S+/, "g");
          const splitArray = re.exec(value);

          if (
            splitArray != null &&
            splitArray[0].length > 2 &&
            splitArray[0] != this.SelectedItem
          ) {
            this.isLoadingImageEnable = true;
            const data = this.chatService.search(splitArray[0]);
            return data;
          } else {
            this.isLoadingImageEnable = false;
            return Observable.of(value);
          }
        } else {
          this.isLoadingImageEnable = false;
          return Observable.of(value);
        }
      })
    );
    this.AutocompleteLoadingImage = this.chatService.AutoLoadingImage.asObservable();

    this.AutocompleteLoadingImage.subscribe((res) => {
      this.isLoadingImageEnable = res;
    });

    this.isLoadingImage = false;
    this.loadingImage = this.chatService.loadingImage
      .asObservable()
      .scan((acc, val) => val);
    this.messages = this.chatService.conversation
      .asObservable()
      .scan((acc, val) => acc.concat(val.reverse()));
  }

  

  selected(event: MatOptionSelectionChange, option) {
    if (option.Valuekey == undefined) {
      event.source.value = this.SelectedItem = option.replace(/@\w+/gm, "@");
    } else {
      event.source.value = this.formValue.replace(/[@]\S+/, option.Valuekey);
    }
  }

  sendMessage() {
    if(this.formValue != ""){
    this.chatService.converse(this.formValue);
  }
    // this.setListener();
    let loginsessionchanged = sessionStorage.getItem("LoginSessionChanged");
   //this.messages.subscribe((val) => console.log("component amy 1", val));
    // WIP: doesnt work. Still listens to itself
    let robotResponse: any;
    
    this.messages.subscribe((val) => {
      val.reverse();
      if(loginsessionchanged == "true"){
        if(val.length>0){
          val = [];
          sessionStorage.setItem("LoginSessionChanged","false");
        }
      }
      else 
      if(val.length>0){
        robotResponse = val;
      const total = robotResponse.length - 1 < 0 ? 0 : robotResponse.length - 1;
     // this.scrollMe = this.msgArea.nativeElement.scrollHeight;
      const lastRobotResponse = robotResponse[total];
      

      if (lastRobotResponse.sentBy == "bot") {
        // if (this.startListenButton && !this.stopListeningButton) {
        //   this.activateSpeechSearch();
        // }
      }
    }
    });

    this.loadingImage.subscribe((res) => {
      if (res.length > 0) {
        const data: any = res[0];
        this.isLoadingImage = data.enableLoading;
        this.MessageID = data.messageID;
      }
    });
    this.formValue = "";
    this._isuserinactive=false;
  }

  ngOnDestroy(): void {
    this.speechRecognitionService.DestroySpeechObject();
  }

  activateSpeechSearch(): void {
    this.startListenButton = false;

    this.speechRecognitionService.record().subscribe(
      (value) => {
        this.speechData = value;
        this.formValue =
          this.formValue == undefined ? value : this.formValue + " " + value;
      },
      (err) => {
        console.log(err);
        if (err.error == "no-speech") {
          this.activateSpeechSearch();
        }
      },
      () => {
        this.sendMessageFromSpeechRecognition();
      }
    );
  }


  sendMessageFromSpeechRecognition(): void {
    this.show = !this.show;

    if (this.FakeHandler) {
      this.FakeHandler = true;
      return;
    }

    if (this.show) {
      this.micImage.nativeElement.src = "assets/img/emic.png";
      this.activateSpeechSearch();
    } else {
      this.speechRecognitionService.DestroySpeechObject();
      this.micImage.nativeElement.src = "assets/img/mic.png";
    }
  }

  @HostListener("document:keydown", ["$event"])
  handleKeyboardEvent(event: KeyboardEvent): void {
    {
      if (event.keyCode == 13) this.FakeHandler = true;
    }
  }

  @HostListener("window:beforeunload", ["$event"]) beforeUnloadHander(
    event: any
  ) {
    localStorage.setItem("hbotMessage", JSON.stringify(this.chatService.MessageHistory));
  }

  refreshSession(){
  var result = JSON.parse(localStorage.getItem("hbotMessage"));
  if (result != undefined && result.length > 0) {
    this.chatService.IsApplicationReload = true;
    this.chatService.converse(
      "this is user token " +
        sessionStorage.getItem("TokenUI") +
        " do not change it."
    );
  } else {
    this.formValue =
      "this is user token " +
        sessionStorage.getItem("TokenUI") +
      " do not change it.";
    this.sendMessage();
  }
}

checkUserActivity() {
  this.userActivity = setTimeout(() =>this.userInactive.next(undefined),1000*12*60);
}

@HostListener('window:keyup', ['$event']) //keyEvent(event: KeyboardEvent) {
  //console.log(event);
  refreshUserState() {
  clearTimeout(this.userActivity);
  if(this._isuserinactive == true){
    this.chatService.conversetorefreshsession(
      "this is user token " +
        sessionStorage.getItem("TokenUI") +
        " do not change it."
    );
  }
    this._isuserinactive=false;
    this.checkUserActivity();
}

}
