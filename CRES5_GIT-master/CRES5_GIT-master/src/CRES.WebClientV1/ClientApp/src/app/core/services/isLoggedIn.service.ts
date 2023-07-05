import { Injector } from "@angular/core";
import { appInjector } from './appInjector.service';
import { Auth } from './auth';
//==import { Router, RouterLink,  ComponentInstruction } from '@angular/router';
import { Router, RouterLink } from '@angular/router';
//import {AppComponent} from "../../app.component";
//import { Routes, APP_ROUTES } from '../../routes.Config';

export const isLoggedIn = () => {
  let injector: Injector = appInjector(); // get the stored reference to the injector
  //let auth: AppComponent = injector.get(AppComponent);
  let auth: Auth = injector.get(Auth);
  let router: Router = injector.get(Router);

  //alert('islogin.ts');
  // return a boolean or a promise that resolves a boolean
  return new Promise((resolve) => {
    auth.check()
      .subscribe((result) => {
        if (result) {
          resolve(true);
        } else {
          router.navigate(['/Login']);
          resolve(false);
        }
      });
  });
};
