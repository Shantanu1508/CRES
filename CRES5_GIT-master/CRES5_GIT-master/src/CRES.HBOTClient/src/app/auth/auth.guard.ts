import { Injectable } from "@angular/core";
import {
  Router,
  CanActivate,
  ActivatedRouteSnapshot,
  RouterStateSnapshot,
} from "@angular/router";
import { DataService } from "../services/data.service";

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(private router: Router, private DataService: DataService) {}

  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot) {
    if (this.DataService.isUserAuthenticated()) {
      return true;
    } else {
      this.router.navigate(["/error"]);
    }
  }
}
