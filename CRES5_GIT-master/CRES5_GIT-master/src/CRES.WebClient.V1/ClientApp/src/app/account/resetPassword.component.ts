import { Component, Inject, OnInit } from '@angular/core';
import { Router, ActivatedRoute, Params } from '@angular/router';
import { User } from '../core/domain/user.model';
import { AzureADAuthService } from '../ngAuth/authenticators/azureADAuth.service';
import { MembershipService } from '../core/services/membership.service';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { DataService } from '../core/services/data.service';
import { UtilityService } from '../core/services/utility.service';
import { PermissionService } from '../core/services/permission.service';
import { changepasswrd } from '../core/domain/changePassword.model';

@Component({
  selector: "resetpassword",
  templateUrl: "./resetPassword.html",
  providers: [DataService, MembershipService, PermissionService]
})

export class resetpassword implements OnInit {
  public _user: User;
  public _Showmessagediv: boolean = false;
  public _isLogin: boolean = false;
  Messageerror: any;
  Message: any;
  returnUrl !: string;
  isloginsuccess !: boolean;
  _userinfo: any;
  _email: any;
  public _allowBasicLogin: boolean = false;

  public _errormessage: any = '';
  public _changepasswrd: changepasswrd;
  public _ShowSuccessmessagediv: boolean = false;
  public _ShowSuccessmessage: any;

  constructor(
    @Inject(AzureADAuthService) private _authService: AzureADAuthService,
    private route: ActivatedRoute,
    private _router: Router, public membershipService: MembershipService, public utilityService: UtilityService,
    public permissionService: PermissionService) {
    this._user = new User('', '');

    this._changepasswrd = new changepasswrd('', '', '')
    // this.islogin= false;
    this.utilityService.setPageTitle("M61-Login");
    this._errormessage = '';
    this._userinfo = localStorage.getItem('user');

    this.route.params.forEach((params: Params) => {
      if (params['id'] !== undefined) {
        this._changepasswrd.AuthenticationKey = params['id'];
      }
    });

    if (this._userinfo) {
      this.logout();
    }
  }

  ngOnInit() {
    // get return url from route parameters or default to '/'
    this.returnUrl = this.route.snapshot.queryParams['returnUrl'] || '/';
  }

  resetPassword(): void {
    if (this._changepasswrd.NewPassword != this._changepasswrd.ConfirmPassword) {
      this._errormessage = "New password and confirm password is not matching."
      this._Showmessagediv = true;
      setTimeout(() => {
        this._Showmessagediv = false;
      }, 5000);
    }
    else {
      this.route.params.forEach((params: Params) => {
        if (params['id'] !== undefined) {
          this._changepasswrd.AuthenticationKey = params['id'];
        }
      });
      var returnUrl = this._router.url;
      this.membershipService.ResetPassword(this._changepasswrd).subscribe(res => {
        if (res.Succeeded) {
          this._ShowSuccessmessage = JSON.stringify('Password reset succesfully.');
          this._ShowSuccessmessagediv = true;
          setTimeout(() => {
            this._ShowSuccessmessagediv = false;
          }, 5000);

          localStorage.setItem('_IsShowMessage', JSON.stringify(true));
          localStorage.setItem('_SucessMsg', JSON.stringify('Password reset succesfully.'));

          if (this.returnUrl == "/") {
            let link = ['/login'];
            this._router.navigate(link);
          }
          else {
            this._router.navigate([this.returnUrl]);
          }
        }
        else {

          //this._errormessage = "You are nor autherize user."
          //this._Showmessagediv = true;

          localStorage.setItem('_IsShowMessage', JSON.stringify(true));
          localStorage.setItem('_SucessMsg', JSON.stringify('You are not autherize user.'));

          setTimeout(() => {
            this._Showmessagediv = false;
            let link = ['/login'];
            this._router.navigate(link);
          }, 5000);

        }
      })
    }
  }

  logout(state = "/"): void {
    var useremil:any = window.localStorage.getItem("useremail");
    debugger;
    if (useremil.toString() !== "undefined") {
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

      this.route.params.forEach((params: Params) => {
        if (params['id'] !== undefined) {
          this._changepasswrd.AuthenticationKey = params['id'];
        }
      });

      this.membershipService.logout()
        .subscribe(res => {
          let link = ['/resetpassword/' + this._changepasswrd.AuthenticationKey];
          this._router.navigate(link);
        },
          error => console.error('Errro' + error),
          () => { });
    }
    //update for reload left menu after new login       
  }



}
const routes: Routes = [

  { path: '', component: resetpassword }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes)],
  declarations: [resetpassword]

})

export class resetPasswordModule { }
