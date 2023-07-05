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
exports.AzureADAuthService = void 0;
// #docregion
var core_1 = require("@angular/core");
var JwtHelper_1 = require("../JwtHelper");
var azureadserviceconstants_1 = require("./azureadserviceconstants");
var AzureADAuthService = /** @class */ (function () {
    // #docregion ctor
    function AzureADAuthService(_serviceConstants) {
        this._serviceConstants = _serviceConstants;
        this.parseQueryString = function (url) {
            var params = {};
            var queryString = "";
            if (url.search("#") != -1) {
                queryString = url.substring(url.search("#") + 1);
            }
            else {
                queryString = url.substring(url.indexOf("?") + 1);
            }
            var a = queryString.split('&');
            for (var i = 0; i < a.length; i++) {
                var b = a[i].split('=');
                params[decodeURIComponent(b[0])] = decodeURIComponent(b[1] || '');
            }
            return params;
        };
        this.params = this.parseQueryString(location.hash);
        // do we have an access token, if so add the iframe renewer
        if (window.localStorage.getItem("access_token")) {
            var iframe = document.createElement('iframe');
            iframe.style.display = "none";
            iframe.src = "/app/ngAuth/renewToken.html?tenantID=" +
                encodeURIComponent(this._serviceConstants.tenantID) +
                "&clientID=" + encodeURIComponent(this._serviceConstants.clientID) +
                "&resource=" + encodeURIComponent(this._serviceConstants.graphResource);
            window.onload = function () {
                document.body.appendChild(iframe);
            };
        }
        if (this.params["id_token"] != null) {
            window.localStorage.setItem("id_token", this.params["id_token"]);
            // redirect to get access token here..
            window.location.href = "https://login.microsoftonline.com/" + this._serviceConstants.tenantID +
                "/oauth2/authorize?response_type=token&client_id=" + this._serviceConstants.clientID +
                "&resource=" + this._serviceConstants.graphResource +
                "&prompt=none&state=" + this.params["state"] + "&nonce=SomeNonce";
            //var _login=new LoginComponent();
            //_login.getuserpwd();
        }
        else if (this.params["access_token"] != null) {
            window.localStorage.setItem("access_token", this.params["access_token"]);
            // redirect to the original call URl here.
            window.location.href = this.params["state"];
        }
    }
    AzureADAuthService.prototype.isUserAuthenticated = function () {
        var access_token = this.getAccessToken();
        // alert('isUserAuthenticated')
        return access_token != null;
    };
    AzureADAuthService.prototype.getAccessToken = function () {
        return window.localStorage.getItem("id_token");
    };
    AzureADAuthService.prototype.getUserName = function () {
        var jwtHelper = new JwtHelper_1.JwtHelper();
        var parsedToken = jwtHelper.decodeToken(this.getAccessToken());
        // alert('getusername2' + JSON.stringify(parsedToken));
        var expiryTime = new Date(parsedToken.exp * 1000);
        var now = new Date();
        if (now > expiryTime)
            this.logOut();
        return parsedToken.name;
    };
    AzureADAuthService.prototype.getemail = function () {
        var jwtHelper = new JwtHelper_1.JwtHelper();
        var parsedToken = jwtHelper.decodeToken(this.getAccessToken());
        // alert('getusername2' + JSON.stringify(parsedToken));
        var expiryTime = new Date(parsedToken.exp * 1000);
        var now = new Date();
        if (now > expiryTime)
            this.logOut();
        return parsedToken.email;
    };
    // #docregion login    
    AzureADAuthService.prototype.logIn = function (state) {
        if (state === void 0) { state = "/"; }
        window.location.href = "https://login.microsoftonline.com/" + this._serviceConstants.tenantID +
            "/oauth2/authorize?response_type=id_token&client_id=" + this._serviceConstants.clientID +
            "&redirect_uri=" + encodeURIComponent(this._serviceConstants.redirectURL) +
            "&state=" + state + "&nonce=SomeNonce";
    };
    // #enddocregion login
    AzureADAuthService.prototype.logOut = function (state) {
        if (state === void 0) { state = "/"; }
        window.localStorage.removeItem("id_token");
        window.localStorage.removeItem("access_token");
        window.location.href = state;
    };
    AzureADAuthService.prototype.LogOutall = function (state) {
        if (state === void 0) { state = "/"; }
        window.location.href = "https://login.microsoftonline.com/b8267886-f0c8-4160-ab6f-6e97968fdc90/oauth2/logout?post_logout_redirect_uri=" + "" + this._serviceConstants.redirectURL + "";
        window.localStorage.removeItem("id_token");
        window.localStorage.removeItem("access_token");
        // window.location.href = state;
    };
    AzureADAuthService = __decorate([
        core_1.Injectable(),
        __metadata("design:paramtypes", [azureadserviceconstants_1.AzureADServiceConstants])
    ], AzureADAuthService);
    return AzureADAuthService;
}());
exports.AzureADAuthService = AzureADAuthService;
function error(err) {
    alert(JSON.stringify(err, null, 4));
    console.error(JSON.stringify(err, null, 4));
}
// #enddocregion
//# sourceMappingURL=azureadauthservice.js.map