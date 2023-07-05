import { Component, OnInit, OnDestroy } from "@angular/core";
import { ActivatedRoute, Router, Params } from "@angular/router";


@Component({
  selector: "app-root",
  templateUrl: "./app.component.html",
  styleUrls: ["./app.component.css"]
})
export class AppComponent implements OnInit, OnDestroy {
  title = "ChatBotSpeech";
  private sub: any;
  loginsession:any;
  public loginsessionchanged:boolean =false;
  constructor(private route: ActivatedRoute, private router: Router) {}

  ngOnInit() {
    this.sub = this.route.queryParams.subscribe((params: Params) => {
      if (
        params.Token != undefined &&
        params.Token.length > 0 &&
        params.TokenUI != undefined &&
        params.TokenUI.length > 0 &&
        params.LoginSession !=undefined &&
        params.LoginSession.length>0
      ){
        // to check user logged out or not
        this.loginsession = sessionStorage.getItem("LoginSession");
        if(this.loginsession != undefined && this.loginsession.length>0){
          if(this.loginsession != params.LoginSession){
            sessionStorage.setItem("LoginSessionChanged","true");
          }
          else{
            sessionStorage.setItem("LoginSessionChanged","false");
          }
         }else{
          sessionStorage.setItem("LoginSessionChanged","false");
        }
        sessionStorage.setItem("Token", params.Token);
        sessionStorage.setItem("TokenUI", params.TokenUI);
        sessionStorage.setItem("LoginSession",params.LoginSession);
        this.router.navigate(["/chat"]);
      }
    });
  }

  ngOnDestroy() {
   // this.sub.unsubscribe();
  }
}
