"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.isLoggedIn = void 0;
var app_injector_1 = require("./app-injector");
var Auth_1 = require("./Auth");
var router_1 = require("@angular/router");
//import {AppComponent} from "../../app.component";
exports.isLoggedIn = function (next, previous) {
    var injector = app_injector_1.appInjector(); // get the stored reference to the injector
    //let auth: AppComponent = injector.get(AppComponent);
    var auth = injector.get(Auth_1.Auth);
    var router = injector.get(router_1.Router);
    // return a boolean or a promise that resolves a boolean
    //return new Promise((resolve) => {
    //    auth.check()
    //        .subscribe((result) => {
    //            if (result) {
    //                resolve(true);
    //            } else {
    //                //alert('login redirect');
    //                router.navigate(['/Login']);
    //                resolve(false);
    //            }
    //        });
    //});
};
//# sourceMappingURL=is-logged-in.js.map