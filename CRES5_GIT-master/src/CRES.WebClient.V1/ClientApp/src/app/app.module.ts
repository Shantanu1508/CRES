import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
//import { HeaderInterceptor } from './core/common/headerInterceptor';
import { HttpClientModule, HttpHeaders, HTTP_INTERCEPTORS } from '@angular/common/http';
import { FormsModule } from '@angular/forms';
import { PushNotificationService } from './core/services/pushNotification.service';
import { DataService } from './core/services/data.service';
import { MembershipService } from './core/services/membership.service';
import { AzureADServiceConstants } from './ngAuth/authenticators/AzureADServiceConstants.model';
import { AzureADAuthService } from './ngAuth/authenticators/azureADAuth.service';
import { AzureADServiceConstantsInternal } from './ngAuth/authenticators/AzureADServiceConstantsInternal.model';
import { AzureADAuthServiceInternal } from './ngAuth/authenticators/azureADAuthInternal.service';
import { AuthenticatedHttpService } from './ngAuth/authenticatedHttp.service';
import { serviceConstants, serviceConstantsInternal } from './ngAuth/authSettings.config';
import { AuthGuard } from './core/authorization/auth.guard';
import { SignalRService } from './Notification/signalR.service';
import { PushNotificationComponent } from './Notification/notification.component';
import { PageNotFoundComponent } from './components/pagenotfound.component';
import { NoteService } from './core/services/note.service';
import { CalculationManagerService } from './core/services/calculationManager.service';
import { PermissionService } from './core/services/permission.service';
import { UtilityService } from './core/services/utility.service';
import { ImpersonateUserModule } from './../app/components/impersonate-user/impersonate-user.module';
import { ChatService } from './core/services/chat.service';

import { ProgressComponent } from './components/shared/progress/progress.component';

// import Wijmo modules
import * as wjcCore from '@grapecity/wijmo';
import { WjInputModule } from '@grapecity/wijmo.angular2.input';

// apply Wijmo license key
import { setLicenseKey } from '@grapecity/wijmo';
import { AuthenticatedHttpInternalService } from './ngAuth/authenticatedHttpInternal.service';

setLicenseKey('Newcon Infosystems,rsip-dev.azurewebsites.net,613184431727163#B0JpMIyNHZisnOiwmbBJye0ICRiwiI34zdxNVexJ5Q9UWUkJFUmhTbFRWV0FlNopkYyBVVwFkQLJHTNFTawJTbiBjQ7BnckFFO9F7cp3SS7dHeZRXe6AHNOVkaZFlYUFDeFlXW8QzLHl5Zmd7UqpkSCZ7MPFGV6sSULtmYzNnbMpHVWt4RzNja5ZFWwNTRhxUUKp4duFWTZJzMLJncxgFRHlHRl56Y48EcyFVMzQDdSlVR6wURQ3UV5gzRvJmVhFDNwNldWRUQql5UqhTTvYVWTNGUIlHWwVUQyw6asNGViRDSSd6RYlzQGlkdJlVN4EUc9kUN92EWLJmYvYjdvh6TrU5cBV6TrQGOCtWURlGOzlVNsdXNqp5NjxGaRhkVwJkdSJlS5I6TlZmR6xERK3yR8gzcsRmZ0l5c7Fkckh5SNFnR4siV7YXNJBDcPFXTRl6NhNnQpVGVBhGRPRURCZzYmB5QEF5R844YVpENFhlI0IyUiwiIzMUQENTM8QjI0ICSiwSOxUDM8MDN7UTM0IicfJye35XX3JSSwIjUiojIDJCLi86bpNnblRHeFBCI4VWZoNFelxmRg2Wbql6ViojIOJyes4nI5kkTRJiOiMkIsIibvl6cuVGd8VEIgIXZ7VWaWRncvBXZSBybtpWaXJiOi8kI1xSfis4N8gkI0IyQiwiIu3Waz9WZ4hXRgAydvJVa4xWdNBybtpWaXJiOi8kI1xSfiQjR6QkI0IyQiwiIu3Waz9WZ4hXRgACUBx4TgAybtpWaXJiOi8kI1xSfiMzQwIkI0IyQiwiIlJ7bDBybtpWaXJiOi8kI1xSfiUFO7EkI0IyQiwiIu3Waz9WZ4hXRgACdyFGaDxWYpNmbh9WaGBybtpWaXJiOi8kI1tlOiQmcQJCLiQTM9UTMxAiNyITM8EDMyIiOiQncDJCLiQXZu9yclRXazJWZ7Vmc5pXYuYXZk5CcpNnciojIz5GRiwiIz5WZ4NXez3mZulEIu36Y7VmTiojIh94QiwiIzYTM7IzNxMDN4gTMzEjNiojIklkIs4nIxYHOxAjMiojIyVmdiwSZwxZY');

let authenticator = new AzureADAuthService(serviceConstants);
let authenticatorinternal = new AzureADAuthServiceInternal(serviceConstantsInternal);



@NgModule({
  declarations: [
    AppComponent,
    PushNotificationComponent,
    PageNotFoundComponent,
    ProgressComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    FormsModule,
    ImpersonateUserModule,
    WjInputModule
    
  ],
  providers: [AuthGuard, DataService, MembershipService, SignalRService, PushNotificationService, NoteService,
    CalculationManagerService, PermissionService, UtilityService, ChatService, 
    //{ provide: LocationStrategy, useClass: HashLocationStrategy, multi:true},
    //{ provide: HTTP_INTERCEPTORS, useClass: HeaderInterceptor, multi:true },
    AuthenticatedHttpService,
    { provide: AzureADAuthService, useValue: authenticator },
    AuthenticatedHttpInternalService,
    { provide: AzureADAuthServiceInternal, useValue: authenticatorinternal }

  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
