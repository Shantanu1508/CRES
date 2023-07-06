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
exports.resetpasswordModule = exports.resetpassword = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var user_1 = require("../core/domain/user");
var azureadauthservice_1 = require("../ngauth/authenticators/azureadauthservice");
var membershipservice_1 = require("../core/services/membershipservice");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var dataService_1 = require("../core/services/dataService");
var utilityService_1 = require("../core/services/utilityService");
var permissionService_1 = require("../core/services/permissionService");
var changepassword_1 = require("../core/domain/changepassword");
var resetpassword = /** @class */ (function () {
    function resetpassword(_authService, route, _router, membershipService, utilityService, permissionService) {
        var _this = this;
        this._authService = _authService;
        this.route = route;
        this._router = _router;
        this.membershipService = membershipService;
        this.utilityService = utilityService;
        this.permissionService = permissionService;
        this._Showmessagediv = false;
        this._isLogin = false;
        this._allowBasicLogin = false;
        this._errormessage = '';
        this._ShowSuccessmessagediv = false;
        this._user = new user_1.User('', '');
        this._changepasswrd = new changepassword_1.changepasswrd('', '', '');
        // this.islogin= false;
        this.utilityService.setPageTitle("M61-Login");
        this._errormessage = '';
        this._userinfo = localStorage.getItem('user');
        this.route.params.forEach(function (params) {
            if (params['id'] !== undefined) {
                _this._changepasswrd.AuthenticationKey = params['id'];
            }
        });
        if (this._userinfo) {
            this.logout();
        }
    }
    resetpassword.prototype.ngOnInit = function () {
        // get return url from route parameters or default to '/'
        this.returnUrl = this.route.snapshot.queryParams['returnUrl'] || '/';
    };
    resetpassword.prototype.resetPassword = function () {
        var _this = this;
        if (this._changepasswrd.NewPassword != this._changepasswrd.ConfirmPassword) {
            this._errormessage = "New password and confirm password is not matching.";
            this._Showmessagediv = true;
            setTimeout(function () {
                this._Showmessagediv = false;
            }.bind(this), 5000);
        }
        else {
            this.route.params.forEach(function (params) {
                if (params['id'] !== undefined) {
                    _this._changepasswrd.AuthenticationKey = params['id'];
                }
            });
            var returnUrl = this._router.url;
            this.membershipService.ResetPassword(this._changepasswrd).subscribe(function (res) {
                if (res.Succeeded) {
                    _this._ShowSuccessmessage = JSON.stringify('Password reset succesfully.');
                    _this._ShowSuccessmessagediv = true;
                    setTimeout(function () {
                        this._ShowSuccessmessagediv = false;
                    }.bind(_this), 5000);
                    localStorage.setItem('_IsShowMessage', JSON.stringify(true));
                    localStorage.setItem('_SucessMsg', JSON.stringify('Password reset succesfully.'));
                    if (_this.returnUrl == "/") {
                        var link = ['/login'];
                        _this._router.navigate(link);
                    }
                    else {
                        _this._router.navigate([_this.returnUrl]);
                    }
                }
                else {
                    //this._errormessage = "You are nor autherize user."
                    //this._Showmessagediv = true;
                    localStorage.setItem('_IsShowMessage', JSON.stringify(true));
                    localStorage.setItem('_SucessMsg', JSON.stringify('You are not autherize user.'));
                    setTimeout(function () {
                        this._Showmessagediv = false;
                        var link = ['/login'];
                        this._router.navigate(link);
                    }.bind(_this), 5000);
                }
            });
        }
    };
    resetpassword.prototype.logout = function (state) {
        var _this = this;
        if (state === void 0) { state = "/"; }
        var useremil = window.localStorage.getItem("useremail");
        debugger;
        if (useremil.toString() !== "undefined") {
            var link = window.location.href;
            link = link.substr(0, link.lastIndexOf("/"));
            // window.location.href = "https://login.microsoftonline.com/b8267886-f0c8-4160-ab6f-6e97968fdc90/oauth2/logout?post_logout_redirect_uri=" + "http://acore.azurewebsites.net/"
            this._authService.LogOutall();
            localStorage.removeItem('user');
            localStorage.removeItem('useremail');
            window.localStorage.removeItem("id_token");
            window.localStorage.removeItem("access_token");
            window.localStorage.removeItem("allowbasiclogin");
            window.localStorage.clear();
        }
        else {
            this.route.params.forEach(function (params) {
                if (params['id'] !== undefined) {
                    _this._changepasswrd.AuthenticationKey = params['id'];
                }
            });
            this.membershipService.logout()
                .subscribe(function (res) {
                var link = ['/resetpassword/' + _this._changepasswrd.AuthenticationKey];
                _this._router.navigate(link);
            }, function (error) { return console.error('Errro' + error); }, function () { });
        }
        //update for reload left menu after new login       
    };
    var _a, _b;
    resetpassword = __decorate([
        (0, core_1.Component)({
            selector: "resetpassword",
            templateUrl: "app/account/resetPassword.html",
            providers: [dataService_1.DataService, membershipservice_1.MembershipService, permissionService_1.PermissionService]
        }),
        __param(0, (0, core_1.Inject)(azureadauthservice_1.AzureADAuthService)),
        __metadata("design:paramtypes", [azureadauthservice_1.AzureADAuthService, typeof (_a = typeof router_1.ActivatedRoute !== "undefined" && router_1.ActivatedRoute) === "function" ? _a : Object, typeof (_b = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _b : Object, membershipservice_1.MembershipService, utilityService_1.UtilityService,
            permissionService_1.PermissionService])
    ], resetpassword);
    return resetpassword;
}());
exports.resetpassword = resetpassword;
var routes = [
    { path: '', component: resetpassword }
];
var resetpasswordModule = /** @class */ (function () {
    function resetpasswordModule() {
    }
    resetpasswordModule = __decorate([
        (0, core_2.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes)],
            declarations: [resetpassword]
        })
    ], resetpasswordModule);
    return resetpasswordModule;
}());
exports.resetpasswordModule = resetpasswordModule;
//# sourceMappingURL=resetPassword.component.js.map