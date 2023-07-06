"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.Auth = void 0;
var core_1 = require("@angular/core");
var membershipService_1 = require("../services/membershipService");
var Auth = /** @class */ (function () {
    //isUserLoggedIn(): boolean {
    //    alert('call isUserLoggedIn');
    //    return this.membershipService.isUserAuthenticated();
    //}
    function Auth(membershipService) {
        this.membershipService = membershipService;
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
    Auth.prototype.check = function () {
        this.loggedIn = this.membershipService.isUserAuthenticated();
        //alert(this.loggedIn);
        //  return Observable.of(this.loggedIn);
    };
    Auth = __decorate([
        (0, core_1.Injectable)(),
        __metadata("design:paramtypes", [membershipService_1.MembershipService])
    ], Auth);
    return Auth;
}());
exports.Auth = Auth;
//# sourceMappingURL=auth.js.map