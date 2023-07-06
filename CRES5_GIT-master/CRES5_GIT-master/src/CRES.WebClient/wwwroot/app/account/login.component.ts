import { Component, Inject, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { User } from '../core/domain/user';
import { AzureADAuthService } from '../ngauth/authenticators/azureadauthservice';
import { MembershipService } from '../core/services/membershipservice';
import { OperationResult } from '../core/domain/operationResult';
import { ModuleWithProviders, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { Location, LocationStrategy, HashLocationStrategy } from '@angular/common';
import { Headers, RequestOptions, BaseRequestOptions, Http } from '@angular/http';
import { DataService } from '../core/services/dataService';
import { UtilityService } from '../core/services/utilityService';
import { PermissionService } from '../core/services/permissionService';
import { AppSettings } from '../core/common/appsettings';
import { Message, MsgSpeech } from '../core/domain/BotMessage';


@Component({
    selector: "login",
    templateUrl: "app/account/login.html",
    providers: [DataService, MembershipService, PermissionService]
})

export class LoginComponent implements OnInit {
    private _user: User;
    private _Showmessagediv: boolean = false;
    private _isLogin: boolean = false;
    Messageerror: any;
    Message: any;
    returnUrl: string;
    isloginsuccess: boolean;
    _userinfo: any;
    _email: any;
    private _allowBasicLogin: boolean = false;

    private _IsShowMessage: boolean = false;
    private _SucessMsg: string = '';
    LoginSession: any;
    

    constructor(
        @Inject(AzureADAuthService) private _authService: AzureADAuthService,
        private route: ActivatedRoute,
        private _router: Router, public membershipService: MembershipService, public utilityService: UtilityService,
        public permissionService: PermissionService, public dataService: DataService, public httpClient: Http) {
        this._user = new User('', '');

        this.GetAllowBasicLogin();
        if (localStorage.getItem('_IsShowMessage') == 'true') {
            this._IsShowMessage = true;
            this._SucessMsg = localStorage.getItem('_SucessMsg');
            this._SucessMsg = (this._SucessMsg.replace('\"', '')).replace('\"', '');
            

            setTimeout(function () {
                this._IsShowMessage = false;
                localStorage.setItem('_IsShowMessage', JSON.stringify(false));
                localStorage.setItem('_SucessMsg', JSON.stringify(''));
            }.bind(this), 5000);
        }

        // this.islogin= false;
        this.utilityService.setPageTitle("M61-Login");
        this.Messageerror = '';
        this._userinfo = localStorage.getItem('user');
        this._email = localStorage.getItem('useremail');

        

        if (this._email.toString() !== "undefined") {                 
            this.isloginsuccess = true;
            this.loginfromazure();
        }
        else if (this._userinfo) {
            this.isloginsuccess = true;
            let link = ['/dashboard'];
            this._router.navigate(link);
        }
        else
        {           
            let link = ['/login'];
            this._router.navigate(link);
        }

        
    }

    ngOnInit() {       
        // get return url from route parameters or default to '/'
       this.returnUrl = this.route.snapshot.queryParams['returnUrl'] || '/';
    }

    logInazure() {
        this._Showmessagediv = false;
        this._authService.logIn("/");
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

                    localStorage.setItem('rolename', this._user.RoleName);


                    localStorage.setItem('showWarningMsgdashboard', null);
                    localStorage.setItem('WarmsgdashBoad', null);
                    localStorage.setItem('botsessiontimer', null);
                   
                    //  this._router.navigate(['/dashboard']);
                    //Redirect to Previous URL after Login
                    this._isLogin = false;
                    if (this.returnUrl == "/") {
                        let link = ['/dashboard'];
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
            error => console.error('Error: ' + error)
    };

    loginfromazure() {
        this._Showmessagediv = false;
        var email = localStorage.getItem('useremail');

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
                        this.GetHbotLoginSessionKey();
                        this._user.LoginSession = this.LoginSession;
                        localStorage.setItem('user', JSON.stringify(this._user));
                        this._router.navigate(['dashboard']);
                    }
                    else {
                        setTimeout(() => {
                            this._authService.LogOutall();
                            this._Showmessagediv = true;
                            this.isloginsuccess = false;
                            this.Messageerror = _authenticationResult.Message;     
                        }, 2000);
                        //window.location.href = "https://login.microsoftonline.com/b8267886-f0c8-4160-ab6f-6e97968fdc90/oauth2/logout?post_logout_redirect_uri=" + "" + AppSettings._azureADRedirectUrl + "";
                                   

                    }
                }),
                error => console.error('Error: ' + error)


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
        //console.log("random", this.LoginSession);
    }

}
const routes: Routes = [

    { path: '', component: LoginComponent }]

@NgModule({
    imports: [FormsModule, CommonModule, RouterModule.forChild(routes)],
    declarations: [LoginComponent]

})

export class LoginModule { }