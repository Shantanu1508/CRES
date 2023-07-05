"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SharedModule = void 0;
var core_1 = require("@angular/core");
var forms_1 = require("@angular/forms");
var http_1 = require("@angular/http");
var common_1 = require("@angular/common");
var router_1 = require("@angular/router");
var busyspinner_component_1 = require("./components/shared/busyspinner.component");
var busyspinnerService_1 = require("./core/services/busyspinnerService");
var SharedModule = /** @class */ (function () {
    function SharedModule() {
    }
    SharedModule_1 = SharedModule;
    SharedModule.forRoot = function () {
        return {
            ngModule: SharedModule_1
        };
    };
    var SharedModule_1;
    SharedModule = SharedModule_1 = __decorate([
        core_1.NgModule({
            imports: [common_1.CommonModule, router_1.RouterModule, http_1.HttpModule, forms_1.ReactiveFormsModule],
            declarations: [busyspinner_component_1.BusySpinnerComponent],
            exports: [busyspinner_component_1.BusySpinnerComponent],
            providers: [busyspinnerService_1.BusySpinnerService]
        })
    ], SharedModule);
    return SharedModule;
}());
exports.SharedModule = SharedModule;
//# sourceMappingURL=shared.module.js.map