import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { map } from 'rxjs/operators';
import { environment } from "../../environments/environment";


@Injectable()
export class DataService {
  public chatloghistory:any = [];
  constructor(public http: HttpClient) {}

  DownloadFile(url) {

    const headers = this.createAuthorizationHeader();

    return this.http
      .get(url, { headers: headers, responseType: 'json' , observe: 'body'})
      .pipe(
        map((res: any) => {
          return res;
        })
      );
  }

  getAutocomplete(data?: any, mapJson: boolean = true) {
    const headers = this.createAuthorizationHeader();
    const uri =  "https://qacres4api.azurewebsites.net/api/HBOT/getautosuggestsearchdatabyKey?search="+ data +"&pageIndex=1&pageSize=10"

    return this.http
      .get(uri)
      .map((res: any) => {
        return res;
      });
  }

  insertchatlog(status?: any,question?:any) {
    const headers = this.createAuthorizationHeader();
    const uri =  "https://qacres4api.azurewebsites.net/api/HBOT/insertchatlog?Status="+ status +"&Question="+question;
    return this.http
      .get(uri,{headers:headers})
      .subscribe((res) => {
        console.log(res);
      });
  }

  //getchatloghistory
  getchatlogHistory() {
    const headers = this.createAuthorizationHeader();
    const uri =  "https://qacres4api.azurewebsites.net/api/HBOT/getchatlogHistory";
    return this.http
      .get(uri,{headers:headers})
      .subscribe((res) => {
        this.chatloghistory = res;
        console.log(res);
      });
  }


  createAuthorizationHeader() {
   const _token = sessionStorage.getItem('Token');
   const _tokenUI = sessionStorage.getItem('TokenUI');

   //for testing purpose
  // let _token = 'bf6666c500ef75b94b6083c46968c22f';
 // let _tokenUI = 'b0e6697b-3534-4c09-be0a-04473401ab93';
   
    let headers = new HttpHeaders();
   // headers = headers.set("Content-Type","text/plain; charset=utf-8");
    // headers = headers.set("Content-Type", "application/json");
    //headers = headers.set("dataType", "json");
    //headers = headers.set("Token", _token);
    headers = headers.set("TokenUId", _tokenUI);
    return headers;
  }
  

  isUserAuthenticated(): boolean {
  let _token = sessionStorage.getItem('Token');
  let _tokenUI = sessionStorage.getItem('TokenUI');
  let _loginsession = sessionStorage.getItem('LoginSession');

     //for testing purpose
  //  let _token = 'bf6666c500ef75b94b6083c46968c22f';
  //   let _tokenUI = 'b0e6697b-3534-4c09-be0a-04473401ab93';
  //   let _loginsession = 'hcf3y';

    if (_token != undefined && _token != 'undefined' && _token.length > 0 && _tokenUI != undefined && _tokenUI != 'undefined' && _tokenUI.length > 0 &&_loginsession != undefined && _loginsession != 'undefined' && _loginsession.length > 0)
      return true;

    return false;
  }

  mapResponse(response: Response) {
    return <any>(<Response>response).json();
  }

  
}
