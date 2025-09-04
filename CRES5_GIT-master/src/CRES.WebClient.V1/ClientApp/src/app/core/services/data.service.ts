
import { HttpHeaders, HttpClient, HttpResponse, HttpParams } from '@angular/common/http';
import { Injectable, Inject } from '@angular/core';
import { Observable, throwError } from 'rxjs';
//import {Observer} from 'rxjs/Observer';

//import 'rxjs/add/operator/map';
//import 'rxjs/add/operator/toPromise';
import { Router } from "@angular/router";
import { map, catchError } from 'rxjs/operators';
//import { AzureADAuthService } from './../../ngauth/authenticators/AzureADAuthService';
import { Subscriber } from 'rxjs';
import appsettings from '../../../../../appsettings.json';
//import { AppSettings } from './../common/appsettings';
//import { _apiPath, _environmentNamae, _environmentCSS, _isAIEnable  } from '../../../../../appsettings.json';
//import { HeaderInterceptor } from '../common/headerInterceptor';

@Injectable()
export class DataService {
  public _baseUri !: string;
  public _pageSize: number | undefined;
  public _pageIndex: number | undefined;
  public _id !: string;

  //Setting
  public _apiPath: string = appsettings._apiPath;
  public _environmentNamae = appsettings._environmentNamae;
  public _environmentCSS = appsettings._environmentCSS;
  public _isV1UIEnable = appsettings._isV1UIEnable;

  // public HbotApiKey = AppSettings.HbotApiPath;


  //Staging (QA) 
  //public _apiPath: string = 'http://qacres4api.azurewebsites.net/';
  //public _environmentNamae = '- QA';
  //public _environmentCSS = 'headerGreen';
  //public HbotApiKey = AppSettings.HbotApiPath;


  //Acore for - Acore (CRES5)
  //public _apiPath: string = 'http://acoreapi.azurewebsites.net/';
  //public _environmentNamae = '';
  //public _environmentCSS = 'header';  
  //public HbotApiKey = AppSettings.HbotApiPath;


  //Dev Azure for - azure (CRES5)
  //public _apiPath: string = 'http://devcres4api.azurewebsites.net/';
  //public _environmentNamae = '- Dev';
  //public _environmentCSS = 'headerOrange';



  //Live - PP
  //public _apiPath: string = 'http://ppcres4api.azurewebsites.net/';
  //public _environmentNamae = '';
  //public _environmentCSS = 'header';

  constructor(public http: HttpClient,
    //public jsonp: Jsonp,
    private _router: Router) {
    this.http = http;
  }

  createAuthorizationHeader(headers: HttpHeaders) {
    var Token: any = '';
    var TokenUId: any = '';
    var DelegatedUser = null;
    var DelegatedUserID = '';
    var delegateuser: any = localStorage.getItem('impersonatorUserInfo');
    DelegatedUser = JSON.parse(delegateuser);
    if (DelegatedUser == null) {
      DelegatedUserID = '';
    }
    else {
      DelegatedUserID = DelegatedUser.UserID;
    }
    var user: any = localStorage.getItem('user');
    var _userData = JSON.parse(user);

    if (_userData == null) {
      headers = headers.append('Token', Token);
      headers = headers.append('TokenUId', TokenUId);
      headers = headers.append('DelegatedUser', DelegatedUserID);
    }
    else {
      Token = _userData.Token;
      TokenUId = _userData.UserID;
      headers = headers.append('Token', Token);
      headers = headers.append('TokenUId', TokenUId);
      headers = headers.append('DelegatedUser', DelegatedUserID);
    }
    return headers;
  }

  set(baseUri: string, pageIndex?: number, pageSize?: number): void {
    this._baseUri = this._apiPath + baseUri;

    this._pageIndex = pageIndex;
    this._pageSize = pageSize;
  }

  setbyId(baseUri: string, id: any, pageIndex?: number, pageSize?: number): void {
    this._baseUri = this._apiPath + baseUri;
    this._id = id;
    this._pageIndex = pageIndex;
    this._pageSize = pageSize;
  }



  get() {
    let headers = new HttpHeaders();
    headers.append('Content-Type', 'application/json');
    headers.append('dataType', 'json');
    headers = this.createAuthorizationHeader(headers);
    var pageindex: any = this._pageIndex;
    var pagesize: any = this._pageSize;
    var uri = this._baseUri + '?pageIndex=' + pageindex.toString() + '&pageSize=' + pagesize.toString();
    return this.http.get(uri, {
      headers: headers
    }).pipe(map(response => response)
      , catchError(error => this.errorResponse(error)));
  }

  getAll() {
    let headers = new HttpHeaders();
    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append('dataType', 'json');

    headers = this.createAuthorizationHeader(headers);

    var uri = this._baseUri;

    return this.http.get(uri, {
      headers: headers
    }).pipe(map(response => response)
      , catchError(error => this.errorResponse(error)));
  }



  getByID(ID: string) {
    let headers = new HttpHeaders();
    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append('dataType', 'jsonp');

    headers = this.createAuthorizationHeader(headers);

    var uri = this._baseUri + '?ID=' + ID.toString();
    return this.http.get(uri, {
      headers: headers
    }).pipe(map(response => response)
      , catchError(error => this.errorResponse(error)));
  }

  getByIDWithOutJson(ID: string) {
    let headers = new HttpHeaders();
    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append('dataType', 'jsonp');

    headers = this.createAuthorizationHeader(headers);

    var uri = this._baseUri + '?ID=' + ID.toString();
    return this.http.get(uri, {
      headers: headers
    }).pipe(map(responce => <any>(<Response>responce))
      , catchError(error => this.errorResponse(error)));
  }

  getByIDAndIDDest(ID: string, IDDest: string) {
    let headers = new HttpHeaders();
    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append('dataType', 'jsonp');

    headers = this.createAuthorizationHeader(headers);

    var uri = this._baseUri + '?ID=' + ID.toString() + '&IDDest=' + IDDest;
    return this.http.get(uri, {
      headers: headers
    }).pipe(map(response => response)
      , catchError(error => this.errorResponse(error)));
  }


  getByIdwithPaging() {
    var uri;
    let headers = new HttpHeaders();
    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append('dataType', 'jsonp');

    headers = this.createAuthorizationHeader(headers);
    var pageindex: any = this._pageIndex;
    var pagesize: any = this._pageSize;
    uri = this._baseUri + '?pageIndx=' + pageindex.toString() + '&pageSize=' + pagesize.toString() + '&gId= ' + this._id.toString();


    return this.http.get(uri, {
      headers: headers
    }).pipe(map(response => response)
      , catchError(error => this.errorResponse(error)));
  }

  post(data?: any, mapJson: boolean = true) {
    let headers = new HttpHeaders();
    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append('dataType', 'jsonp');

    headers = this.createAuthorizationHeader(headers);

    var uri;
    var pagesize: any = this._pageSize;
    if (this._pageIndex) {
      uri = this._baseUri + '?pageIndex=' + this._pageIndex.toString() + '&pageSize=' + pagesize.toString();
    }
    else {
      uri = this._baseUri;
    }

    if (mapJson) {

      return this.http.post(uri, data, {
        headers: headers
      }).pipe(map(response => response)
        , catchError(error => this.errorResponse(error)));

    }
    else {
      return this.http.post(uri, data, {
        headers: headers
      }).pipe(map(response => response));
    }
  }

  patch(data?: any, mapJson: boolean = true) {
    let headers = new HttpHeaders();
    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append('dataType', 'jsonp');

    headers = this.createAuthorizationHeader(headers);
    var uri;

    if (this._pageIndex) {
      uri = this._baseUri + '?pageIndex=' + this._pageIndex.toString() + '&pageSize=' + this._pageSize.toString();
    }
    else {
      uri = this._baseUri;
    }

    if (mapJson) {
      return this.http.patch(uri, data, {
        headers: headers
      }).pipe(map(response => response)
        , catchError(error => this.errorResponse(error)));

    }
    else {
      return this.http.patch(uri, data, {
        headers: headers
      }).pipe(map(response => response));
    }
  }

  PostWithParam(parameters: any) {
    let headers = new HttpHeaders();
    let params = new HttpParams();
    const options = {
      headers: headers,
      params: parameters
    }
    //let options = new RequestOptions({ headers: headers });
    // options.params = parameters;

    return this.http.post(this._baseUri, '', options)
      .pipe(map(response => response)
        , catchError(error => this.errorResponse(error)));
  }

  postWithBlob(data?: any, mapJson: boolean = true) {
    let headers = new HttpHeaders();
    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append('dataType', 'jsonp');

    headers = this.createAuthorizationHeader(headers);
    var uri;

    if (this._pageIndex) {
      uri = this._baseUri + '?pageIndex=' + this._pageIndex + '&pageSize=' + this._pageSize;
    }
    else {
      uri = this._baseUri;
    }
 
    {

      return this.http.post<Blob>(uri, data,
        { headers: headers, responseType: 'blob' as 'json' }).pipe(map(response => response)
          , catchError(error => this.errorResponse(error)));       

    }
    
  }


  delete(id: number) {
    let headers = new HttpHeaders();
    headers = this.createAuthorizationHeader(headers);

    return this.http.delete(this._baseUri + '/' + id.toString())
      .pipe(map(response => response)
        , catchError(error => this.errorResponse(error)));
  }

  deleteResource(resource: string) {
    let headers = new HttpHeaders();
    headers = this.createAuthorizationHeader(headers);

    return this.http.delete(resource)
      .pipe(map(response => response)
        , catchError(error => this.errorResponse(error)));
  }

  upload(files: any, parameters: any) {
    let headers = new HttpHeaders();
    //options.params = parameters;
    return this.http.post(this._baseUri, files, { params: parameters })
      .pipe(map(response => response)
        , catchError(error => this.errorResponse(error)));
  }

  getImages() {
    return this.http.get(this._baseUri + "getimages")
      .pipe(map(response => JSON.stringify(response))
        , catchError(error => this.errorResponse(error)));
  }

  getByIDWithBlob(ID: string): Observable<any> {
    var uri = this._baseUri + '?ID=' + ID.toString();
    //let options = new RequestOptions({ responseType: ResponseContentType.Blob });
    return this.http.get<Blob>(uri, { responseType: 'blob' as 'json' })
      .pipe(map((response) => <Blob>response)
        , catchError(error => this.errorResponse(error)));
  }

  getByIDAndStorageTypeWithBlob(ID: string, StorageType: string): Observable<any> {
    var uri = this._baseUri + '?ID=' + ID + '&StorageType=' + StorageType;
    //let options = new RequestOptions({ responseType: ResponseContentType.Blob });
    return this.http.get<Blob>(uri, { responseType: 'blob' as 'json' })
      .pipe(map((response) => <Blob>response)
        , catchError(error => this.errorResponse(error)));
  }

  getByIDStorageTypeAndLocationWithBlob(ID: string, StorageTypeID: string, StorageLocation: string): Observable<any> {
    var uri = this._baseUri + '?ID=' + ID + '&StorageTypeID=' + StorageTypeID + '&Location=' + StorageLocation;
    //let options = new RequestOptions({ responseType: ResponseContentType.Blob });
    //return this.http.get(uri, options)
    //  .map((response: Response) => <Blob>response.blob())
    //  .catch(error => this.errorResponse(error));

    return this.http.post<Blob>(uri, { responseType: 'blob' as 'json' }).pipe(map(response => response)
      , catchError(error => this.errorResponse(error)));

  }

  getByIDStorageTypeAndLocationWithBlobGET(ID: string, StorageTypeID: string, StorageLocation: string): Observable<any> {
    var uri = this._baseUri + '?ID=' + ID + '&StorageTypeID=' + StorageTypeID + '&Location=' + StorageLocation;
    //let options = new RequestOptions({ responseType: ResponseContentType.Blob });
    //return this.http.get(uri, options)
    //  .map((response: Response) => <Blob>response.blob())
    //  .catch(error => this.errorResponse(error));

    return this.http.get<Blob>(uri, { responseType: 'blob' as 'json' })
      .pipe(map((response) => <Blob>response)
        , catchError(error => this.errorResponse(error)));

  }

  PostByDataTable(dealfunding: any): Observable<any> {
    // let options = new RequestOptions({ responseType: ResponseContentType.Blob });
    return this.http.post<Blob>(this._baseUri, dealfunding, { responseType: 'blob' as 'json' })
      .pipe(map((response) => <Blob>response)
        , catchError(
          error => this.errorResponse(error)
        ));
  }

  DownloadBylist(lst: any): Observable<any> {
    // let options = new RequestOptions({ responseType: ResponseContentType.Blob });
    return this.http.post<Blob>(this._baseUri, lst, { responseType: 'blob' as 'json' })
      .pipe(map((response) => <Blob>response)
        , catchError(
          error => this.errorResponse(error)
        ));
  }


  getByIDAndID1WithBlob(ID: string, ID1: string): Observable<any> {
    var uri = this._baseUri + '?ID=' + ID + '&ID1=' + ID1;
    //let options = new RequestOptions({ responseType: ResponseContentType.Blob });
    return this.http.get<Blob>(uri, { responseType: 'blob' as 'json' })
      .pipe(map((response) => <Blob>response)
        , catchError(error => this.errorResponse(error)));
  }

  getByIDAndID1andID2WithBlob(ID: string, ID1: string, ID2: string): Observable<any> {
    var uri = this._baseUri + '?ID=' + ID + '&ID1=' + ID1 + '&ID2=' + ID2;
    //let options = new RequestOptions({ responseType: ResponseContentType.Blob });
    return this.http.get<Blob>(uri, { responseType: 'blob' as 'json' })
      .pipe(map((response) => <Blob>response)
        , catchError(error => this.errorResponse(error)));
  }


  downloadByURLWithBlob(URL: string): Observable<any> {
    //let options = new RequestOptions({ responseType: ResponseContentType.Blob });
    return this.http.get<Blob>(URL, { responseType: 'blob' as 'json' })
      .pipe(map((response) => <Blob>response)
        , catchError(error => this.errorResponse(error)));
  }

  errorResponse(error: any): Observable<any> {
    if (error.status == 401) {
      this.logout();
    }
    return throwError(error);
  }


  logout(state = "/"): void {
    var useremil: any = window.localStorage.getItem("useremail");

    /* TODO: Azure logout on data service*/
    if (useremil.toString() !== "undefined") {
      var link = window.location.href;
      link = link.substr(0, link.lastIndexOf("/"));
      // window.location.href = "https://login.microsoftonline.com/b8267886-f0c8-4160-ab6f-6e97968fdc90/oauth2/logout?post_logout_redirect_uri=" + "http://acore.azurewebsites.net/"
      // this._authService.LogOutall();
      localStorage.removeItem('user');
      localStorage.removeItem('useremail');
      window.localStorage.removeItem("id_token");
      window.localStorage.removeItem("access_token");
      window.localStorage.removeItem("allowbasiclogin");
      window.localStorage.clear();
    }
    else {
      localStorage.removeItem('user');
      localStorage.clear();
      this.set("api/account/logout/");
      this.post(null, false)
        .subscribe(res => {
          let link = ['/login'];
          this._router.navigate(link);

          /* Reset settings*/
          setTimeout(() => {
            location.reload();
          }, 1000);
        },
          error => console.error('Error' + error),
          () => { });
    }
  }


  getIframeData1(iframeUrl: string, iframeTokenKey: string, iframeTokenValue: string) {
    let headers = new HttpHeaders();
    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append('dataType', 'json');
    headers = headers.append(iframeTokenKey, iframeTokenValue);
    //headers.append('AUTH-TOKEN', 'Q1JFUzpNU2l4dHkxQDIwMjBD');
    //this.createAuthorizationHeader(headers);
    var uri = iframeUrl;
    return this.http.get(uri, {
      headers: headers
    }).pipe(map(response => response)
      , catchError(error => this.errorResponse(error)));
  }

  //getIframeData(iframeUrl: string): Observable<any> {
  //  let options = new RequestOptions();
  //  options.headers = new HttpHeaders();
  //  //options.headers.append(iframeTokenKey, iframeTokenValue);
  //  options.responseType = ResponseContentType.Blob;

  //  return new Observable((observer: Subscriber<any>) => {
  //    let objectUrl: string = null;

  //    this.http
  //      .get(iframeUrl, options)
  //      .subscribe(m => {
  //        objectUrl = URL.createObjectURL(m.blob());
  //        observer.next(objectUrl);
  //      });

  //    return () => {
  //      if (objectUrl) {
  //        URL.revokeObjectURL(objectUrl);
  //        objectUrl = null;
  //      }
  //    };
  //  });
  //}



  postIframeData(iframeUrl: string, iframeTokenKey: string, iframeTokenValue: string, data: any) {

    let headers = new HttpHeaders();
    headers = headers.append('Content-Type', 'application/json');
    //headers.append('dataType', 'jsonp');
    headers = headers.append(iframeTokenKey, iframeTokenValue);

    //this.createAuthorizationHeader(headers);
    var uri;
    uri = iframeUrl;

    return this.http.post(uri, JSON.stringify(data), {
      headers: headers
    }).pipe(map(response => response)
      , catchError(error => this.errorResponse(error)));
  }

  //calling for AI dialogflow api 
  postforAIchat(url?: string, data?: any, newheader?: any) {
    return this.http.post(url, data, {
      headers: newheader
    }).pipe(map(response => response)
      , catchError(error => this.errorResponse(error)));
  }

  public getIPAddress() {

    fetch('https://api.ipify.org?format=json')
      .then(results => results.json())
      .then(data => {
        setTimeout(function () {
          localStorage.setItem('userIP', JSON.stringify(data.ip));
          // return data.ip;
        }.bind(this), 5000);
      });


  }
}

