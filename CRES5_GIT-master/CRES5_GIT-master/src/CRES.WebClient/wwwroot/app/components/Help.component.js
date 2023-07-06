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
exports.HelpModule = exports.HelpComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var core_2 = require("@angular/core");
var utilityService_1 = require("../core/services/utilityService");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var HelpComponent = /** @class */ (function () {
    function HelpComponent(utilityService, _router) {
        this.utilityService = utilityService;
        this._router = _router;
        this.utilityService.setPageTitle("M61-Help");
    }
    HelpComponent.prototype.openLink = function () {
        this._pagePath = ['taskdetail/a', '00000000-0000-0000-0000-000000000000'];
        this._router.navigate(this._pagePath);
    };
    HelpComponent = __decorate([
        core_1.Component({
            selector: "help",
            templateUrl: "app/components/help.html"
        }),
        __metadata("design:paramtypes", [utilityService_1.UtilityService,
            router_1.Router])
    ], HelpComponent);
    return HelpComponent;
}());
exports.HelpComponent = HelpComponent;
var routes = [
    { path: '', component: HelpComponent }
];
var HelpModule = /** @class */ (function () {
    function HelpModule() {
    }
    HelpModule = __decorate([
        core_2.NgModule({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes)],
            declarations: [HelpComponent]
        })
    ], HelpModule);
    return HelpModule;
}());
exports.HelpModule = HelpModule;
//# sourceMappingURL=Help.component.js.map