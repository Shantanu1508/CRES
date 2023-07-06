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
Object.defineProperty(exports, "__esModule", { value: true });
exports.SelectUserComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var UserDelegateConfiguration_1 = require("./../../../core/domain/UserDelegateConfiguration");
var userservice_1 = require("./../../../core/services/userservice");
var SelectUserComponent = /** @class */ (function () {
    function SelectUserComponent(userService, _router) {
        this.userService = userService;
        this._router = _router;
        this._isShowImpersonate = true;
        this._isShowReturntoimpersonator = false;
    }
    Object.defineProperty(SelectUserComponent.prototype, "_userNameList", {
        set: function (obj) {
            if (obj != undefined && obj != null) {
                this.userNameList = obj;
            }
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(SelectUserComponent.prototype, "_returnToImpersonator", {
        set: function (obj) {
            if (obj != undefined && obj != null) {
                this.userNameList = obj;
                this.ReturnToImpersonator();
            }
        },
        enumerable: false,
        configurable: true
    });
    SelectUserComponent.prototype.ngOnInit = function () {
        this.userdelegateconfiguration = new UserDelegateConfiguration_1.UserDelegateConfiguration("");
    };
    SelectUserComponent.prototype.onSelectionChange = function (DelegatedUserID, userid) {
        this.delegateuserID = DelegatedUserID;
        this.userID = userid;
    };
    SelectUserComponent.prototype.DelegateUser = function () {
        var _this = this;
        this.userdelegateconfiguration.DelegatedUserID = this.delegateuserID;
        this.userdelegateconfiguration.UserID = this.userID;
        this.userdelegateconfiguration.RequestType = "Start";
        this.userdelegateconfiguration.EntryType = "User";
        this.userService.ImpersonateUserByUserID(this.userdelegateconfiguration).subscribe(function (res) {
            if (res.Succeeded) {
                _this._isShowImpersonate = false;
                _this._isShowReturntoimpersonator = true;
                _this.ClosePopUp();
                _this.userdelegateconfiguration.DelegatedUserID = null;
                _this.userdelegateconfiguration.UserID = null;
                _this._user = res.UserData;
                _this._user.Token = res.Token;
                _this._user.TokenUId = res.UserData.UserID;
                /* Saving information of Impersonator */
                localStorage.setItem('impersonatorUserInfo', localStorage.getItem('user'));
                localStorage.setItem('user', JSON.stringify(_this._user));
                localStorage.setItem('rolename', _this._user.RoleName);
                localStorage.setItem('showWarningMsgdashboard', null);
                localStorage.setItem('WarmsgdashBoad', null);
                var link = ['/dashboard'];
                _this._router.routeReuseStrategy.shouldReuseRoute = function () { return false; };
                _this._router.navigate(link);
                setTimeout(function () {
                    location.reload(true);
                }, 1000);
            }
            else {
            }
        });
    };
    SelectUserComponent.prototype.ClosePopUp = function () {
        var modal = document.getElementById('myModelimpersonate');
        modal.style.display = "none";
    };
    SelectUserComponent.prototype.ReturnToImpersonator = function () {
        var _this = this;
        var delegateuser = JSON.parse(localStorage.getItem('impersonatorUserInfo')); //UserID : c41205eb-2bf6-48a3-abc3-398face6fd6e
        var user = JSON.parse(localStorage.getItem('user'));
        this.userdelegateconfiguration.DelegatedUserID = delegateuser.UserID;
        this.userdelegateconfiguration.UserID = user.UserID;
        this.userdelegateconfiguration.RequestType = "End";
        this.userdelegateconfiguration.EntryType = "User";
        this.userService.ImpersonateUserByUserID(this.userdelegateconfiguration).subscribe(function (res) {
            if (res.Succeeded) {
                _this._isShowImpersonate = false;
                _this._isShowReturntoimpersonator = true;
                _this.ClosePopUp();
                _this.userdelegateconfiguration.DelegatedUserID = null;
                _this.userdelegateconfiguration.UserID = null;
                _this._user = res.UserData;
                _this._user.Token = res.Token;
                _this._user.TokenUId = res.UserData.UserID;
                _this._user = JSON.parse(localStorage.getItem('impersonatorUserInfo'));
                localStorage.setItem('user', JSON.stringify(_this._user));
                localStorage.setItem('rolename', _this._user.RoleName);
                localStorage.setItem('showWarningMsgdashboard', null);
                localStorage.setItem('WarmsgdashBoad', null);
                localStorage.removeItem('impersonatorUserInfo');
                var link = ['/dashboard'];
                _this._router.routeReuseStrategy.shouldReuseRoute = function () { return false; };
                _this._router.navigate(link);
                setTimeout(function () {
                    location.reload(true);
                }, 1000);
            }
            else {
            }
        });
    };
    var _a;
    __decorate([
        (0, core_1.Input)(),
        __metadata("design:type", Object),
        __metadata("design:paramtypes", [Object])
    ], SelectUserComponent.prototype, "_userNameList", null);
    __decorate([
        (0, core_1.Input)(),
        __metadata("design:type", Object),
        __metadata("design:paramtypes", [Object])
    ], SelectUserComponent.prototype, "_returnToImpersonator", null);
    SelectUserComponent = __decorate([
        (0, core_1.Component)({
            selector: 'app-select-user',
            templateUrl: 'app/components/impersonate-user/select-user/select-user.component.html',
            styleUrls: ['app/components/impersonate-user/select-user/select-user.component.css'],
            providers: [userservice_1.UserService]
        }),
        __metadata("design:paramtypes", [userservice_1.UserService, typeof (_a = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _a : Object])
    ], SelectUserComponent);
    return SelectUserComponent;
}());
exports.SelectUserComponent = SelectUserComponent;
//# sourceMappingURL=select-user.component.js.map