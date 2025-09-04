// #docregion
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { AzureADServiceConstants } from "./AzureADServiceConstants.model";
import { JwtHelper } from '../JwtHelper';
import appsettings from '../../../../../appsettings.json';

@Injectable()
export class AzureADAuthService {
  public isUserAuthenticated(): boolean {
    let access_token = this.getAccessToken();
    // alert('isUserAuthenticated')
    return access_token != null;
  }

  public getAccessToken(): string {
    var token:any = window.localStorage.getItem("id_token")
    return token;
  }

  public getUserName(): string {

    var jwtHelper = new JwtHelper();
    var parsedToken = jwtHelper.decodeToken(this.getAccessToken());

    // alert('getusername2' + JSON.stringify(parsedToken));
    var expiryTime = new Date(parsedToken.exp * 1000);
    var now = new Date();
    if (now > expiryTime) this.logOut();

    return parsedToken.name;
  }

  public getemail(): string {

    var jwtHelper = new JwtHelper();
    var parsedToken = jwtHelper.decodeToken(this.getAccessToken());

    // alert('getusername2' + JSON.stringify(parsedToken));
    var expiryTime = new Date(parsedToken.exp * 1000);
    var now = new Date();
    if (now > expiryTime) this.logOut();

    return parsedToken.unique_name;
  }
  public getClientId(): string {

    var jwtHelper = new JwtHelper();
    var parsedToken = jwtHelper.decodeToken(this.getAccessToken());

    //// alert('getusername2' + JSON.stringify(parsedToken));
    //var expiryTime = new Date(parsedToken.exp * 1000);
    //var now = new Date();
    //if (now > expiryTime) this.logOut();

    return parsedToken.aud;
  }

  // #docregion login    
  public logIn(state = "/") {
    window.location.href = "https://login.microsoftonline.com/" + this._serviceConstants.tenantID +
      "/oauth2/authorize?response_type=id_token&client_id=" + this._serviceConstants.clientID +
      "&redirect_uri=" + encodeURIComponent(this._serviceConstants.redirectURL) +
      "&state=" + state + "&nonce=SomeNonce";
  }
  // #enddocregion login

  public logOut(state = "/") {
    window.localStorage.removeItem("id_token");
    window.localStorage.removeItem("access_token");
    window.location.href = state;

  }

  public LogOutall(state = "/") {
    var clientId = this.getClientId();
    if (clientId == appsettings.AzuresettingsInternal._azureADClientID) {
      localStorage.setItem("logoutFrom", "Internal");
      window.location.href = "https://login.microsoftonline.com/" + appsettings.AzuresettingsInternal._azureADTenanID + "/oauth2/logout?post_logout_redirect_uri=" + "" + appsettings.AzuresettingsInternal._azureADRedirectUrl;
    }
    else {
      window.location.href = "https://login.microsoftonline.com/" + appsettings.Azuresettings._azureADTenanID + "/oauth2/logout?post_logout_redirect_uri=" + "" + appsettings.Azuresettings._azureADRedirectUrl;
    }
    window.localStorage.removeItem("id_token");
    window.localStorage.removeItem("access_token");
    // window.location.href = state;
  }


  private parseQueryString = function (url: string) {
    var params: { [key: string]: any } = {};
    var queryString = "";
    if (url.search("#") != -1) {
      queryString = url.substring(url.search("#") + 1);

    } else {
      queryString = url.substring(url.indexOf("?") + 1);
    }
    var a = queryString.split('&');
    for (var i = 0; i < a.length; i++) {
      var b = a[i].split('=');
      params[decodeURIComponent(b[0])] = decodeURIComponent(b[1] || '');
    }
    return params;
  }

  private params:any = this.parseQueryString(location.hash);
  // #docregion ctor
  constructor(private _serviceConstants: AzureADServiceConstants) {
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
      }
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
  // #enddocregion ctor
}



function error(err: any) {
  alert(JSON.stringify(err, null, 4));
  console.error(JSON.stringify(err, null, 4));
}

// #enddocregion
