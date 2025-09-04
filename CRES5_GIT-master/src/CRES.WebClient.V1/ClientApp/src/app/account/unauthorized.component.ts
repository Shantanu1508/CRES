import { Component, Inject, NgModule, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { User } from '../core/domain/user.model';
import { MembershipService } from '../core/services/membership.service';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { DataService } from '../core/services/data.service';
import { PermissionService } from '../core/services/permission.service';
declare var $: any;

@Component({
  selector: 'app-Unauthorized',
  templateUrl: './unauthorized.html',
  providers: [DataService, MembershipService, PermissionService]
})
export class UnauthorizedComponent implements OnInit {

  returnUrl !: string;
  constructor(

    private route: ActivatedRoute,
    private _router: Router, public membershipService: MembershipService,
    public permissionService: PermissionService) {

  }

  ngOnInit() {
    localStorage.removeItem('user');
    localStorage.removeItem('useremail');
    window.localStorage.removeItem("id_token");
    window.localStorage.removeItem("access_token");
    window.localStorage.removeItem("allowbasiclogin");

    var toprow = document.getElementById("toprow");

    //toprow.style.display == "None";
    if (toprow != undefined && toprow != null) {
      $("#toprow").css("display", "None");
    }
    var leftmenu = document.getElementById("leftmenu");
    if (leftmenu != undefined && leftmenu != null) {
      $("#leftmenu").css("display", "None");
    }
    var maincontaintdiv = document.getElementById("maincontaintdiv");
    if (maincontaintdiv != undefined && maincontaintdiv != null) {
      $("#maincontaintdiv").css("width", "100%");
    }
    var environmentname = document.getElementById("environmentname");
    if (environmentname != undefined && environmentname != null) {
      $("#environmentname").css("display", "None");
    }

  }


}

const route: Routes = [

  { path: '', component: UnauthorizedComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(route)],
  declarations: [UnauthorizedComponent]

})
export class unauthorizedModule { }

