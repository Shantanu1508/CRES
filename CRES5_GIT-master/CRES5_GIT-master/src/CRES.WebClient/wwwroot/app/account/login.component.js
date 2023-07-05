"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.LoginModule = exports.LoginComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var user_1 = require("../core/domain/user");
var azureadauthservice_1 = require("../ngauth/authenticators/azureadauthservice");
var membershipservice_1 = require("../core/services/membershipservice");
var operationResult_1 = require("../core/domain/operationResult");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var http_1 = require("@angular/http");
var dataService_1 = require("../core/services/dataService");
var utilityService_1 = require("../core/services/utilityService");
var permissionService_1 = require("../core/services/permissionService");
var LoginComponent = /** @class */ (function () {
    function LoginComponent(_authService, route, _router, membershipService, utilityService, permissionService, dataService, httpClient) {
        this._authService = _authService;
        this.route = route;
        this._router = _router;
        this.membershipService = membershipService;
        this.utilityService = utilityService;
        this.permissionService = permissionService;
        this.dataService = dataService;
        this.httpClient = httpClient;
        this._Showmessagediv = false;
        this._isLogin = false;
        this._allowBasicLogin = false;
        this._IsShowMessage = false;
        this._SucessMsg = '';
        this._user = new user_1.User('', '');
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
            var link = ['/dashboard'];
            this._router.navigate(link);
        }
        else {
            var link = ['/login'];
            this._router.navigate(link);
        }
    }
    LoginComponent.prototype.ngOnInit = function () {
        // get return url from route parameters or default to '/'
        this.returnUrl = this.route.snapshot.queryParams['returnUrl'] || '/';
    };
    LoginComponent.prototype.logInazure = function () {
        this._Showmessagediv = false;
        this._authService.logIn("/");
    };
    LoginComponent.prototype.getusername = function () {
        this._authService.getUserName();
    };
    LoginComponent.prototype.login = function () {
        var _this = this;
        var _authenticationResult = new operationResult_1.OperationResult(false, '', '', this._user);
        this._Showmessagediv = false;
        this._isLogin = true;
        this.membershipService.login(this._user)
            .subscribe(function (res) {
            _authenticationResult.Succeeded = res.Succeeded;
            _authenticationResult.Message = res.Message;
            _authenticationResult.UserData = res.UserData;
            _authenticationResult.Token = res.Token;
            if (_authenticationResult.Succeeded) {
                _this.isloginsuccess = true;
                // this.notificationService.printSuccessMessage('Welcome back ' + this._user.Login + '!');
                //alert(_authenticationResult.UserData);
                _this._user = _authenticationResult.UserData;
                _this._user.Token = _authenticationResult.Token;
                _this._user.TokenUId = _authenticationResult.UserData.UserID;
                //alert('Login.ts' + JSON.stringify(this._user) + ',' + this._user.Token + ',' + _authenticationResult.Token);
                _this.GetHbotLoginSessionKey();
                _this._user.LoginSession = _this.LoginSession;
                localStorage.setItem('user', JSON.stringify(_this._user));
                localStorage.setItem('rolename', _this._user.RoleName);
                localStorage.setItem('showWarningMsgdashboard', null);
                localStorage.setItem('WarmsgdashBoad', null);
                localStorage.setItem('botsessiontimer', null);
                //  this._router.navigate(['/dashboard']);
                //Redirect to Previous URL after Login
                _this._isLogin = false;
                if (_this.returnUrl == "/") {
                    var link = ['/dashboard'];
                    _this._router.navigate(link);
                }
                else {
                    _this._router.navigate([_this.returnUrl]);
                }
            }
            else {
                _this._isLogin = false;
                //this.notificationService.printErrorMessage(_authenticationResult.Message);
                _this._Showmessagediv = true;
                _this.Messageerror = _authenticationResult.Message;
            }
        }),
            function (error) { return console.error('Error: ' + error); };
    };
    ;
    LoginComponent.prototype.loginfromazure = function () {
        var _this = this;
        this._Showmessagediv = false;
        var email = localStorage.getItem('useremail');
        var _authenticationResult = new operationResult_1.OperationResult(false, '', '', this._user);
        if (email != null || email != "undefined") {
            this.membershipService.loginFromAzure(email)
                .subscribe(function (res) {
                _authenticationResult.Succeeded = res.Succeeded;
                _authenticationResult.Message = res.Message;
                _authenticationResult.UserData = res.UserData;
                _authenticationResult.Token = res.Token;
                if (_authenticationResult.Succeeded) {
                    _this._user = _authenticationResult.UserData;
                    _this._user.Token = _authenticationResult.Token;
                    localStorage.setItem('rolename', _this._user.RoleName);
                    _this._user.TokenUId = _authenticationResult.UserData.UserID;
                    _this.GetHbotLoginSessionKey();
                    _this._user.LoginSession = _this.LoginSession;
                    localStorage.setItem('user', JSON.stringify(_this._user));
                    _this._router.navigate(['dashboard']);
                }
                else {
                    setTimeout(function () {
                        _this._authService.LogOutall();
                        _this._Showmessagediv = true;
                        _this.isloginsuccess = false;
                        _this.Messageerror = _authenticationResult.Message;
                    }, 2000);
                    //window.location.href = "https://login.microsoftonline.com/b8267886-f0c8-4160-ab6f-6e97968fdc90/oauth2/logout?post_logout_redirect_uri=" + "" + AppSettings._azureADRedirectUrl + "";
                }
            }),
                function (error) { return console.error('Error: ' + error); };
        }
        ;
    };
    LoginComponent.prototype.GetAllowBasicLogin = function () {
        var _this = this;
        this.permissionService.GetAllowBasiclogin("AllowBasicLogin").subscribe(function (res) {
            if (res.Succeeded) {
                if (res.AllowBasicLogin.Value == "0")
                    _this._allowBasicLogin = false;
                else
                    _this._allowBasicLogin = true;
                localStorage.setItem('allowBasicLogin', _this._allowBasicLogin.toString());
            }
        });
    };
    LoginComponent.prototype.GetHbotLoginSessionKey = function () {
        this.LoginSession = Math.random().toString(36).substring(7);
        //console.log("random", this.LoginSession);
    };
    var _a, _b, _c;
    LoginComponent = __decorate([
        (0, core_1.Component)({
            selector: "login",
            templateUrl: "app/account/login.html",
            providers: [dataService_1.DataService, membershipservice_1.MembershipService, permissionService_1.PermissionService]
        }),
        __param(0, (0, core_1.Inject)(azureadauthservice_1.AzureADAuthService)),
        __metadata("design:paramtypes", [azureadauthservice_1.AzureADAuthService, typeof (_a = typeof router_1.ActivatedRoute !== "undefined" && router_1.ActivatedRoute) === "function" ? _a : Object, typeof (_b = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _b : Object, membershipservice_1.MembershipService, utilityService_1.UtilityService,
            permissionService_1.PermissionService, dataService_1.DataService, typeof (_c = typeof http_1.Http !== "undefined" && http_1.Http) === "function" ? _c : Object])
    ], LoginComponent);
    return LoginComponent;
}());
exports.LoginComponent = LoginComponent;
var routes = [
    { path: '', component: LoginComponent }
];
var LoginModule = /** @class */ (function () {
    function LoginModule() {
    }
    LoginModule = __decorate([
        (0, core_2.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes)],
            declarations: [LoginComponent]
        })
    ], LoginModule);
    return LoginModule;
}());
exports.LoginModule = LoginModule;
//# sourceMappingURL=login.component.js.map