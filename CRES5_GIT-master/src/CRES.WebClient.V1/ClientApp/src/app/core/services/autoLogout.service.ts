
import { Injectable, Inject } from "@angular/core";
import { Router } from '@angular/router'
import { AzureADAuthService } from '../../ngAuth/authenticators/azureADAuth.service';
const MINUTES_UNITL_AUTO_LOGOUT = 60 * 720;// in mins
const CHECK_INTERVAL = 1000 * 60 * 60;// in ms
const STORE_KEY = 'lastAction';
import { MembershipService } from './membership.service';


@Injectable()
export class AutoLogoutService {
  public getLastAction() {
    var storekey:any = localStorage.getItem(STORE_KEY);
    return parseInt(storekey);
  }
  public setLastAction(lastAction: number) {
    localStorage.setItem(STORE_KEY, lastAction.toString());
  }

  constructor(@Inject(AzureADAuthService) private _authService: AzureADAuthService,
    private router: Router,
    public membershipService: MembershipService) {
    this.check();
    this.initListener();
    this.initInterval();
    localStorage.setItem(STORE_KEY, Date.now().toString());
  }

  initListener() {
    document.body.addEventListener('click', () => this.reset());
    document.body.addEventListener('mouseover', () => this.reset());
    document.body.addEventListener('mouseout', () => this.reset());
    document.body.addEventListener('keydown', () => this.reset());
    document.body.addEventListener('keyup', () => this.reset());
    document.body.addEventListener('keypress', () => this.reset());
  }

  reset() {
    this.setLastAction(Date.now());
  }

  initInterval() {
    setInterval(() => {
      this.check();
    }, CHECK_INTERVAL);
  }

  check() {
    const now = Date.now();
    const timeleft = this.getLastAction() + MINUTES_UNITL_AUTO_LOGOUT * 60 * 1000;
    const diff = timeleft - now;
    const isTimeout = diff < 0;

    if (isTimeout) {
      localStorage.clear();
      this.logout();
    }
  }


  logout(state = "/"): void {
    var useremil = window.localStorage.getItem("useremail");

    if (useremil) {
      var link = window.location.href;
      link = link.substr(0, link.lastIndexOf("/"));
      // window.location.href = "https://login.microsoftonline.com/b8267886-f0c8-4160-ab6f-6e97968fdc90/oauth2/logout?post_logout_redirect_uri=" + "http://acore.azurewebsites.net/"
      this._authService.LogOutall();
      localStorage.removeItem('user');
      localStorage.removeItem('useremail');
      window.localStorage.removeItem("id_token");
      window.localStorage.removeItem("access_token");
      window.localStorage.removeItem("allowbasiclogin");
      window.localStorage.clear();
    }
    else {
      this.membershipService.logout()
        .subscribe(res => {
          let link = ['/login'];
          this.router.navigate(link);
        },
          error => console.error('Errro' + error),
          () => { });
    }

    //update for reload left menu after new login

  }
}
