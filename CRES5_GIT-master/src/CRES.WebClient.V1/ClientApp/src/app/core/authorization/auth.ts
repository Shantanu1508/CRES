import { Observable } from 'rxjs';
import { Injectable } from '@angular/core';
import { MembershipService } from '../services/membership.service';

@Injectable()
export class Auth {
  public loggedIn: any;

  //isUserLoggedIn(): boolean {
  //    alert('call isUserLoggedIn');
  //    return this.membershipService.isUserAuthenticated();
  //}

  constructor(public membershipService: MembershipService) {
    // this.loggedIn = this.membershipService.isUserAuthenticated();
    // this.loggedIn = true;
    this.loggedIn = false;
  }

  /*
  login() {
      this.loggedIn = true;
  }

  logout() {
      this.loggedIn = false;
  }*/

  check() {
    this.loggedIn = this.membershipService.isUserAuthenticated();
    //alert(this.loggedIn);
    //  return Observable.of(this.loggedIn);
  }
}
