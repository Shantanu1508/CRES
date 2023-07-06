"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ImpersonateUserModule = void 0;
var core_1 = require("@angular/core");
var common_1 = require("@angular/common");
var select_user_component_1 = require("./select-user/select-user.component");
var ImpersonateUserModule = /** @class */ (function () {
    function ImpersonateUserModule() {
    }
    ImpersonateUserModule = __decorate([
        (0, core_1.NgModule)({
            imports: [
                common_1.CommonModule
            ],
            declarations: [select_user_component_1.SelectUserComponent],
            exports: [
                select_user_component_1.SelectUserComponent
            ]
        })
    ], ImpersonateUserModule);
    return ImpersonateUserModule;
}());
exports.ImpersonateUserModule = ImpersonateUserModule;
//# sourceMappingURL=impersonate-user.module.js.map