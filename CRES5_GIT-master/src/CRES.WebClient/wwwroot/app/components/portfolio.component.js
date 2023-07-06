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
exports.PortfolioModule = exports.PortfolioComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var notificationService_1 = require("../core/services/notificationService");
var NoteService_1 = require("../core/services/NoteService");
var membershipservice_1 = require("../core/services/membershipservice");
var utilityService_1 = require("../core/services/utilityService");
var wjcGrid = require("wijmo/wijmo.grid");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wijmo_angular2_core_1 = require("wijmo/wijmo.angular2.core");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var wijmo_angular2_input_1 = require("wijmo/wijmo.angular2.input");
var portfolioService_1 = require("../core/services/portfolioService");
var PortfolioComponent = /** @class */ (function () {
    function PortfolioComponent(activatedRoute, _router, noteService, utilityService, notificationService, membershipService, _portfolioService) {
        this.activatedRoute = activatedRoute;
        this._router = _router;
        this.noteService = noteService;
        this.utilityService = utilityService;
        this.notificationService = notificationService;
        this.membershipService = membershipService;
        this._portfolioService = _portfolioService;
        this.TotalCount = 0;
        this._ShowmessagedivWar = false;
        this.Message = '';
        this._Showmessagediv = false;
        this._ShowSuccessmessagediv = false;
        // private routes = Routes;
        this._isPortfolioListFetching = true;
        this._isNoRecord = false;
        this.GetAllPortfolio();
        this.utilityService.setPageTitle("M61 – Dynamic Portfolio");
    }
    PortfolioComponent.prototype.GetAllPortfolio = function () {
        var _this = this;
        if (localStorage.getItem('divSucessPortfolio') == 'true') {
            this._ShowSuccessmessagediv = true;
            this._ShowSuccessmessage = localStorage.getItem('successmsgPortfolio');
            this._ShowSuccessmessage = (this._ShowSuccessmessage.replace('\"', '')).replace('\"', '');
            localStorage.setItem('divSucessPortfolio', JSON.stringify(false));
            localStorage.setItem('successmsgPortfolio', JSON.stringify(''));
            //to hide _Showmessagediv after 5 sec
            setTimeout(function () {
                this._ShowSuccessmessagediv = false;
            }.bind(this), 5000);
            setTimeout(function () {
                if (this.flexportfolio) {
                    this.flexportfolio.autoSizeColumns(0, this.flex.columns.length, false, 20);
                    this.flexportfolio.columns[0].width = 350; // for Note Id
                }
            }.bind(this), 1);
        }
        this._portfolioService.getallportfolio().subscribe(function (res) {
            if (res.Succeeded) {
                if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                    var data = res.lstportfolio;
                    _this.lstPortfolio = data;
                    _this.TotalCount = data.lenght;
                    _this._isNoRecord = _this.lstPortfolio.length == 0 ? true : false;
                    setTimeout(function () {
                        if (this.TotalCount > 0)
                            this.flexportfolio.selectionMode = wjcGrid.SelectionMode.None;
                        this._isPortfolioListFetching = false;
                    }.bind(_this), 200);
                }
                else {
                    localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                    localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));
                    _this.utilityService.navigateUnauthorize();
                }
            }
            else {
                _this.utilityService.navigateToSignIn();
            }
        });
    };
    PortfolioComponent.prototype.AddNewPortfolio = function () {
        this._router.navigate(['/portfoliodetail', "00000000-0000-0000-0000-000000000000"]);
    };
    var _a, _b, _c;
    __decorate([
        (0, core_1.ViewChild)('flexportfolio'),
        __metadata("design:type", typeof (_a = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _a : Object)
    ], PortfolioComponent.prototype, "flexportfolio", void 0);
    PortfolioComponent = __decorate([
        (0, core_1.Component)({
            selector: "portfolio",
            templateUrl: "app/components/portfolio.html?v=" + $.getVersion(),
            providers: [NoteService_1.NoteService, notificationService_1.NotificationService, utilityService_1.UtilityService, portfolioService_1.portfolioService],
        }),
        __metadata("design:paramtypes", [typeof (_b = typeof router_1.ActivatedRoute !== "undefined" && router_1.ActivatedRoute) === "function" ? _b : Object, typeof (_c = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _c : Object, NoteService_1.NoteService,
            utilityService_1.UtilityService,
            notificationService_1.NotificationService,
            membershipservice_1.MembershipService,
            portfolioService_1.portfolioService])
    ], PortfolioComponent);
    return PortfolioComponent;
}());
exports.PortfolioComponent = PortfolioComponent;
var routes = [
    { path: '', component: PortfolioComponent }
];
var PortfolioModule = /** @class */ (function () {
    function PortfolioModule() {
    }
    PortfolioModule = __decorate([
        (0, core_2.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_core_1.WjCoreModule, wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule, wijmo_angular2_input_1.WjInputModule],
            declarations: [PortfolioComponent]
        })
    ], PortfolioModule);
    return PortfolioModule;
}());
exports.PortfolioModule = PortfolioModule;
//# sourceMappingURL=portfolio.component.js.map