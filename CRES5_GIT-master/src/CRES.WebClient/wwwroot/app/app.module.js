"use strict";
//import { Component, EventEmitter, Input, Inject, enableProdMode, NgModule } from '@angular/core';
//import { CommonModule } from '@angular/common';
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (Object.prototype.hasOwnProperty.call(b, p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        if (typeof b !== "function" && b !== null)
            throw new TypeError("Class extends value " + String(b) + " is not a constructor or null");
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppModule = void 0;
var core_1 = require("@angular/core");
var forms_1 = require("@angular/forms");
var common_1 = require("@angular/common");
var http_1 = require("@angular/http");
var http_2 = require("@angular/http");
var app_component_1 = require("./app.component");
var pushnotificationservice_1 = require("./core/services/pushnotificationservice");
var platform_browser_1 = require("@angular/platform-browser");
//import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';
var routes_config_1 = require("./routes.config");
var dataService_1 = require("./core/services/dataService");
var membershipservice_1 = require("./core/services/membershipservice");
var wijmo_angular2_input_1 = require("wijmo/wijmo.angular2.input");
var azureadauthservice_1 = require("./ngauth/authenticators/azureadauthservice");
var authenticatedhttpservice_1 = require("./ngauth/authenticatedhttpservice");
var authsettings_config_1 = require("./ngauth/authsettings.config");
var auth_guard_1 = require("./core/authorization/auth.guard");
var signalRService_1 = require("./Notification/signalRService");
var notification_component_1 = require("./Notification/notification.component");
var pagenotfound_component_1 = require("./components/pagenotfound.component");
var NoteService_1 = require("./core/services/NoteService");
var CalculationManagerService_1 = require("./core/services/CalculationManagerService");
var PermissionService_1 = require("./core/services/PermissionService");
var impersonate_user_module_1 = require("./../app/components/impersonate-user/impersonate-user.module");
var chatService_1 = require("./../app/core/services/chatService");
var authenticator = new azureadauthservice_1.AzureADAuthService(authsettings_config_1.serviceConstants);
var AppBaseRequestOptions = /** @class */ (function (_super) {
    __extends(AppBaseRequestOptions, _super);
    function AppBaseRequestOptions() {
        var _this = _super.call(this) || this;
        _this.headers = new http_1.Headers();
        _this.headers.append('Content-Type', 'application/json');
        _this.body = '';
        return _this;
    }
    return AppBaseRequestOptions;
}(http_1.BaseRequestOptions));
var AppModule = /** @class */ (function () {
    function AppModule() {
    }
    AppModule = __decorate([
        (0, core_1.NgModule)({
            imports: [platform_browser_1.BrowserModule,
                forms_1.FormsModule,
                http_2.HttpModule,
                http_2.JsonpModule,
                routes_config_1.AppRoutingModule,
                wijmo_angular2_input_1.WjInputModule,
                impersonate_user_module_1.ImpersonateUserModule
            ],
            declarations: [app_component_1.AppComponent, notification_component_1.PushNotificationComponent, pagenotfound_component_1.PageNotFoundComponent],
            providers: [auth_guard_1.AuthGuard, dataService_1.DataService, membershipservice_1.MembershipService, signalRService_1.SignalRService, pushnotificationservice_1.PushNotificationService, NoteService_1.NoteService, CalculationManagerService_1.CalculationManagerService, PermissionService_1.PermissionService, chatService_1.ChatService,
                { provide: common_1.LocationStrategy, useClass: common_1.HashLocationStrategy },
                { provide: http_1.RequestOptions, useClass: AppBaseRequestOptions },
                authenticatedhttpservice_1.AuthenticatedHttpService,
                {
                    provide: azureadauthservice_1.AzureADAuthService,
                    useValue: authenticator
                }
            ],
            bootstrap: [app_component_1.AppComponent]
        })
    ], AppModule);
    return AppModule;
}());
exports.AppModule = AppModule;
//# sourceMappingURL=app.module.js.map