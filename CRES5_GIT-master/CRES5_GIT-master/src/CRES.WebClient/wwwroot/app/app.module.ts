//import { Component, EventEmitter, Input, Inject, enableProdMode, NgModule } from '@angular/core';
//import { CommonModule } from '@angular/common';

import { Component, NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Location, LocationStrategy, HashLocationStrategy } from '@angular/common';
import { Headers, RequestOptions, BaseRequestOptions} from '@angular/http';
import { HttpModule, JsonpModule } from '@angular/http';
import { AppComponent }  from './app.component';
import { PushNotificationService } from './core/services/pushnotificationservice';
import { BrowserModule } from '@angular/platform-browser';
//import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';
import { appRoutes, AppRoutingModule } from './routes.config';
import { DataService } from './core/services/dataService';
import { MembershipService } from './core/services/membershipservice';
import { WjInputModule } from 'wijmo/wijmo.angular2.input';
import { AzureADServiceConstants } from './ngauth/authenticators/azureadserviceconstants';
import { AzureADAuthService } from './ngauth/authenticators/azureadauthservice';
import { AuthenticatedHttpService } from './ngauth/authenticatedhttpservice';
import { serviceConstants } from './ngauth/authsettings.config';
import { AuthGuard } from './core/authorization/auth.guard';
import { SignalRService } from './Notification/signalRService';
import { PushNotificationComponent } from './Notification/notification.component';
import { PageNotFoundComponent } from './components/pagenotfound.component';
import { NoteService } from './core/services/NoteService';
import { CalculationManagerService } from './core/services/CalculationManagerService';
import { PermissionService } from './core/services/PermissionService';

import { ImpersonateUserModule } from './../app/components/impersonate-user/impersonate-user.module';
import { ChatService } from './../app/core/services/chatService';
let authenticator = new AzureADAuthService(serviceConstants);



class AppBaseRequestOptions extends BaseRequestOptions {
    headers: Headers = new Headers();

    constructor() {
        super();
        this.headers.append('Content-Type', 'application/json');
        this.body = '';
    }
 
}

@NgModule({  
    imports: [BrowserModule,
        FormsModule,
        HttpModule,        
        JsonpModule,
        AppRoutingModule,
        WjInputModule,
        ImpersonateUserModule
    ],
  
    declarations: [AppComponent, PushNotificationComponent, PageNotFoundComponent], 
    providers: [AuthGuard, DataService, MembershipService, SignalRService, PushNotificationService, NoteService, CalculationManagerService, PermissionService, ChatService,
        { provide: LocationStrategy, useClass: HashLocationStrategy },
        { provide: RequestOptions, useClass: AppBaseRequestOptions },
        AuthenticatedHttpService,
        {
            provide: AzureADAuthService,
            useValue: authenticator
        }
    ],
    bootstrap: [AppComponent]
   
})
export class AppModule {

}

