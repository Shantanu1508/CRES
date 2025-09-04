import { Component, Inject, NgModule, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { User } from '../core/domain/user.model';
import { MembershipService } from '../core/services/membership.service';
import { OperationResult } from '../core/domain/operationResult.model';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { DataService } from '../core/services/data.service';
import { UtilityService } from '../core/services/utility.service';
import { PermissionService } from '../core/services/permission.service';
import { AzureADAuthServiceInternal } from '../ngAuth/authenticators/azureADAuthInternal.service';

@Component({
  selector: 'app-logininternal',
  templateUrl: './logininternal.html',
  providers: [DataService, MembershipService, PermissionService, UtilityService]
})
export class LogininternalComponent implements OnInit {

  public _user: User;
  public _Showmessagediv: boolean = false;
  public _isLogin: boolean = false;
  Messageerror: any;
  Message: any;
  returnUrl !: string;
  isloginsuccess !: boolean;
  _userinfo: any;
  _email: any;
  public _allowBasicLogin: boolean = false;

  public _IsShowMessage: boolean = false;
  public _SucessMsg: any = '';
  LoginSession: any;

  constructor(
    @Inject(AzureADAuthServiceInternal) private _authService: AzureADAuthServiceInternal,
    private route: ActivatedRoute,
    private _router: Router, public membershipService: MembershipService, public utilityService: UtilityService,
    public permissionService: PermissionService) {
    this._user = new User('', '');

    this.GetAllowBasicLogin();
    if (localStorage.getItem('_IsShowMessage') == 'true') {
      this._IsShowMessage = true;
      this._SucessMsg = localStorage.getItem('_SucessMsg');
      this._SucessMsg = (this._SucessMsg.replace('\"', '')).replace('\"', '');


      setTimeout(() => {
        this._IsShowMessage = false;
        localStorage.setItem('_IsShowMessage', JSON.stringify(false));
        localStorage.setItem('_SucessMsg', JSON.stringify(''));
        //}.bind(this), 5000);
      }, 7000);
    }

    // this.islogin= false;
    this.utilityService.setPageTitle("M61-Login");
    this.Messageerror = '';
    this._userinfo = localStorage.getItem('user');
    this._email = localStorage.getItem('useremail');



    if (this._email.toString() != "undefined") {
      this.isloginsuccess = true;
      this.loginfromazure();
    }
    else if (this._userinfo) {
      this.isloginsuccess = true;
      let link = ['dashboard'];
      this._router.navigate(link);
    }
    else {
      let link = ['logininternal'];
      this._router.navigate(link);
    }


  }

  ngOnInit() {
    // get return url from route parameters or default to '/'
    this.returnUrl = this.route.snapshot.queryParams['returnUrl'] || '/';
  }

  logInazure() {
    this._Showmessagediv = false;
    this._authService.logIn("/logininternal");
  }

  getusername() {
    this._authService.getUserName();
  }



  login(): void {
    var _authenticationResult: OperationResult = new OperationResult(false, '', '', this._user);
    this._Showmessagediv = false;
    this._isLogin = true;
    this.membershipService.login(this._user)
      .subscribe(res => {
        _authenticationResult.Succeeded = res.Succeeded;
        _authenticationResult.Message = res.Message;
        _authenticationResult.UserData = res.UserData;
        _authenticationResult.Token = res.Token;

        if (_authenticationResult.Succeeded) {
          this.isloginsuccess = true;
          // this.notificationService.printSuccessMessage('Welcome back ' + this._user.Login + '!');
          //alert(_authenticationResult.UserData);
          this._user = _authenticationResult.UserData;
          this._user.Token = _authenticationResult.Token;
          this._user.TokenUId = _authenticationResult.UserData.UserID;

          //alert('Login.ts' + JSON.stringify(this._user) + ',' + this._user.Token + ',' + _authenticationResult.Token);

          this.GetHbotLoginSessionKey();
          this._user.LoginSession = this.LoginSession;
          localStorage.setItem('user', JSON.stringify(this._user));
          localStorage.setItem('dbloginfrom', 'internal');
          localStorage.setItem('rolename', this._user.RoleName);


          localStorage.setItem('showWarningMsgdashboard', "null");
          localStorage.setItem('WarmsgdashBoad', "null");

          //  this._router.navigate(['/dashboard']);
          //Redirect to Previous URL after Login
          this._isLogin = false;
          if (this.returnUrl == "/") {
            let link = ['dashboard'];
            this._router.navigate(link);
          }
          else {
            this._router.navigate([this.returnUrl]);
          }

        }
        else {
          this._isLogin = false;
          //this.notificationService.printErrorMessage(_authenticationResult.Message);
          this._Showmessagediv = true;
          this.Messageerror = _authenticationResult.Message;
        }
      }),
      (error: string) => console.error('Error: ' + error)
  };

  loginfromazure() {
    this._Showmessagediv = false;
    var email: any = localStorage.getItem('useremail');

    var _authenticationResult: OperationResult = new OperationResult(false, '', '', this._user);
    if (email != null || email != "undefined") {
      
      this.membershipService.loginFromAzure(email)
        .subscribe(res => {
          _authenticationResult.Succeeded = res.Succeeded;
          _authenticationResult.Message = res.Message;
          _authenticationResult.UserData = res.UserData;
          _authenticationResult.Token = res.Token;
          if (_authenticationResult.Succeeded) {
            this._user = _authenticationResult.UserData;
            this._user.Token = _authenticationResult.Token;
            localStorage.setItem('rolename', this._user.RoleName);
            this._user.TokenUId = _authenticationResult.UserData.UserID;
            localStorage.setItem('user', JSON.stringify(this._user));
            this._router.navigate(['dashboard']);
          }
          else {
            setTimeout(() => {
              //this._authService.LogOutall();
              localStorage.setItem('user', null);
              this._Showmessagediv = true;
              this.isloginsuccess = false;
              this.Messageerror = _authenticationResult.Message;
              window.localStorage.clear();
              this._router.navigate(['unauthorized']);
            }, 2000);
            //window.location.href = "https://login.microsoftonline.com/b8267886-f0c8-4160-ab6f-6e97968fdc90/oauth2/logout?post_logout_redirect_uri=" + "" + AppSettings._azureADRedirectUrl + "";


          }
        }),
        (error: string) => console.error('Error: ' + error)
    };
  }

  GetAllowBasicLogin() {
    this.permissionService.GetAllowBasiclogin("AllowBasicLogin").subscribe(res => {
      if (res.Succeeded) {
        if (res.AllowBasicLogin.Value == "0")
          this._allowBasicLogin = false;
        else
          this._allowBasicLogin = true;
        localStorage.setItem('allowBasicLogin', this._allowBasicLogin.toString());
      }
    })
  }

  GetHbotLoginSessionKey() {
    this.LoginSession = Math.random().toString(36).substring(7);
  }

}

const route: Routes = [

  { path: '', component: LogininternalComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(route)],
  declarations: [LogininternalComponent]

})
export class logininternalModule { }
 
