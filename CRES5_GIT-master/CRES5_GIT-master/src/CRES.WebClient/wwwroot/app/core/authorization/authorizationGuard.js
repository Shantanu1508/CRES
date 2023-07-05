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
exports.AuthorizationGuard = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
//import { SessionService } from "./services/session.service";
//import { User } from "./entities/user.entity";
var membershipservice_1 = require("../services/membershipservice");
var AuthorizationGuard = /** @class */ (function () {
    function AuthorizationGuard(_router, membershipService) {
        this._router = _router;
        this.membershipService = membershipService;
    }
    AuthorizationGuard.prototype.canActivate = function () {
        if (this.membershipService.isUserAuthenticated() == true)
            return true;
        this._router.navigate(['account/login']);
        return false;
    };
    var _a;
    AuthorizationGuard = __decorate([
        (0, core_1.Injectable)(),
        __metadata("design:paramtypes", [typeof (_a = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _a : Object, membershipservice_1.MembershipService])
    ], AuthorizationGuard);
    return AuthorizationGuard;
}());
exports.AuthorizationGuard = AuthorizationGuard;
//# sourceMappingURL=authorizationGuard.js.map