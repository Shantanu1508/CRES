import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { Router } from '@angular/router';
import { UserDelegateConfiguration } from "./../../../core/domain/UserDelegateConfiguration";

import { UserService } from "./../../../core/services/userservice";
import { MembershipService } from './../../../core/services/membershipservice';
import { OperationResult } from './../../../core/domain/operationResult';
import { User } from './../../../core/domain/user';

@Component({
    selector: 'app-select-user',
    templateUrl: 'app/components/impersonate-user/select-user/select-user.component.html',
    styleUrls: ['app/components/impersonate-user/select-user/select-user.component.css'],
    providers: [UserService]
})
export class SelectUserComponent implements OnInit {

    private _user: User;
    public userdelegateconfiguration: UserDelegateConfiguration;

    private userNameList: any;
    private delegateuserID: any;
    private userID: any;

    public _isShowImpersonate: boolean = true;
    public _isShowReturntoimpersonator: boolean = false;

    @Input() set _userNameList(obj) {
        if (obj != undefined && obj != null) {
            this.userNameList = obj;
        }
    }

    @Input() set _returnToImpersonator(obj) {
        if (obj != undefined && obj != null) {
            this.userNameList = obj;
            this.ReturnToImpersonator();
        }
    }

    constructor(public userService: UserService,
        private _router: Router) { }

    ngOnInit() {
        this.userdelegateconfiguration = new UserDelegateConfiguration("");
    }

    onSelectionChange(DelegatedUserID, userid): void {
        this.delegateuserID = DelegatedUserID
        this.userID = userid;

    }

    DelegateUser() {
        this.userdelegateconfiguration.DelegatedUserID = this.delegateuserID;
        this.userdelegateconfiguration.UserID = this.userID;
        this.userdelegateconfiguration.RequestType = "Start";
        this.userdelegateconfiguration.EntryType = "User";
        this.userService.ImpersonateUserByUserID(this.userdelegateconfiguration).subscribe(res => {
            if (res.Succeeded) {

                this._isShowImpersonate = false;
                this._isShowReturntoimpersonator = true;
                this.ClosePopUp();
                this.userdelegateconfiguration.DelegatedUserID = null;
                this.userdelegateconfiguration.UserID = null;

                this._user = res.UserData;
                this._user.Token = res.Token;
                this._user.TokenUId = res.UserData.UserID;

                /* Saving information of Impersonator */
                localStorage.setItem('impersonatorUserInfo', localStorage.getItem('user'));

                localStorage.setItem('user', JSON.stringify(this._user));
                localStorage.setItem('rolename', this._user.RoleName);
                localStorage.setItem('showWarningMsgdashboard', null);
                localStorage.setItem('WarmsgdashBoad', null);

                let link = ['/dashboard'];
                this._router.routeReuseStrategy.shouldReuseRoute = () => false;
                this._router.navigate(link);

                setTimeout( ()=> {
                    location.reload(true);
                }, 1000);             

            } else {

            }
        });
    }

    ClosePopUp(): void {
        var modal = document.getElementById('myModelimpersonate');
        modal.style.display = "none";
    }

    ReturnToImpersonator() {
        var delegateuser = JSON.parse(localStorage.getItem('impersonatorUserInfo')); //UserID : c41205eb-2bf6-48a3-abc3-398face6fd6e
        var user = JSON.parse(localStorage.getItem('user'));
        this.userdelegateconfiguration.DelegatedUserID = delegateuser.UserID;
        this.userdelegateconfiguration.UserID = user.UserID;
        this.userdelegateconfiguration.RequestType = "End";
        this.userdelegateconfiguration.EntryType = "User";
        this.userService.ImpersonateUserByUserID(this.userdelegateconfiguration).subscribe(res => {
            if (res.Succeeded) {

                this._isShowImpersonate = false;
                this._isShowReturntoimpersonator = true;
                this.ClosePopUp();
                this.userdelegateconfiguration.DelegatedUserID = null;
                this.userdelegateconfiguration.UserID = null;

                this._user = res.UserData;
                this._user.Token = res.Token;
                this._user.TokenUId = res.UserData.UserID;

                this._user = JSON.parse(localStorage.getItem('impersonatorUserInfo'));
                localStorage.setItem('user', JSON.stringify(this._user));
                localStorage.setItem('rolename', this._user.RoleName);
                localStorage.setItem('showWarningMsgdashboard', null);
                localStorage.setItem('WarmsgdashBoad', null);

                localStorage.removeItem('impersonatorUserInfo');

                let link = ['/dashboard'];
                this._router.routeReuseStrategy.shouldReuseRoute = () => false;
                this._router.navigate(link);

                setTimeout(() => {
                    location.reload(true);
                }, 1000);
            } else {

            }
        });
    }
}
