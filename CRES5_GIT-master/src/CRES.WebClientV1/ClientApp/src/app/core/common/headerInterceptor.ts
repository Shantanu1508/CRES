import { Injectable } from '@angular/core';
import { HttpInterceptor, HttpRequest, HttpHandler, HttpEvent } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable()
export class HeaderInterceptor implements HttpInterceptor {
  intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    // add custom header
    const customReq = request.clone({
      responseType: 'blob'
    });

    //console.log('processing request', customReq);

    // pass on the modified request object
    return next.handle(customReq);
  }
}

