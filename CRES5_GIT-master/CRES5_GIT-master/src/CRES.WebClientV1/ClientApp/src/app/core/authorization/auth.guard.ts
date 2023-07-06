import { Injectable } from '@angular/core';
import { Router, CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { MembershipService } from '../services/membership.service';

@Injectable()
export class AuthGuard implements CanActivate {

  constructor(private router: Router, public membershipService: MembershipService) { }

  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot) {
    if (this.membershipService.isUserAuthenticated()) {
      //   logged in so return true
      return true;
    }
    else {
      //  not logged in so redirect to login page with the return url
      this.router.navigate(['login'], { queryParams: { returnUrl: state.url } });
      return false;
    }


  }
}
