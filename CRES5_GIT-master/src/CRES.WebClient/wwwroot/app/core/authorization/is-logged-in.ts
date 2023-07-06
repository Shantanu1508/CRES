import {Injector,Component} from '@angular/core';
import {appInjector} from './app-injector';
import {Auth} from './Auth';
import { Router, RouterLink } from '@angular/router';
//import {AppComponent} from "../../app.component";


export const isLoggedIn = (next: Component, previous: Component) => {
    let injector: Injector = appInjector(); // get the stored reference to the injector
    //let auth: AppComponent = injector.get(AppComponent);
    let auth: Auth = injector.get(Auth);
    let router: Router = injector.get(Router);

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