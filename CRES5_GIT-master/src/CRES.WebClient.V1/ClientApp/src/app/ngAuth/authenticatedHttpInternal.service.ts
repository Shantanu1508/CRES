// #docregion
import { Injectable, Inject } from '@angular/core';
import { HttpClient, HttpHeaders, HttpResponse } from '@angular/common/http';
import { Observable, Subscriber } from 'rxjs';
import { AzureADAuthServiceInternal } from './authenticators/azureADAuthInternal.service';

@Injectable()
export class AuthenticatedHttpInternalService {
  private _authenticator: AzureADAuthServiceInternal;
  private _http: HttpClient;
  constructor(@Inject(HttpClient) http: HttpClient, @Inject(AzureADAuthServiceInternal) authenticator: AzureADAuthServiceInternal) {
    this._authenticator = authenticator;
    this._http = http;
  }

  createAuthorizationHeader(headers: HttpHeaders) {
    headers = headers.append('Authorization', 'Bearer ' + this._authenticator.getAccessToken());
    return headers;
  }

  get(url: string) {
    let headers = new HttpHeaders();
    headers = this.createAuthorizationHeader(headers);
    return this._http.get(url, { headers: headers });
  }

  post(url: string, data: any) {
    let headers = new HttpHeaders();
    headers = this.createAuthorizationHeader(headers);
    return this._http.post(url, data, {
      headers: headers,
    });
  }
}
