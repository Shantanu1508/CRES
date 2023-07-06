import { Injectable, Component } from "@angular/core";
import { CanActivate, Router } from "@angular/router";
//import { SessionService } from "./services/session.service";
//import { User } from "./entities/user.entity";
import { MembershipService } from '../services/membership.service';

@Injectable()
export class AuthorizationGuard implements CanActivate {

  constructor(private _router: Router, public membershipService: MembershipService) { }

  public canActivate() {
    if (this.membershipService.isUserAuthenticated() == true) return true;
    this._router.navigate(['account/login']);
    return false;
  }

}
