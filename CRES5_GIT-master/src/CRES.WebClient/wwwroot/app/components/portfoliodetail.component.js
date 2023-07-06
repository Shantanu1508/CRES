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
exports.PortfolioDetailModule = exports.PortfolioDetailComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var portfolio_1 = require("../core/domain/portfolio");
var notificationService_1 = require("../core/services/notificationService");
var NoteService_1 = require("../core/services/NoteService");
var membershipservice_1 = require("../core/services/membershipservice");
var utilityService_1 = require("../core/services/utilityService");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wijmo_angular2_core_1 = require("wijmo/wijmo.angular2.core");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var wijmo_angular2_input_1 = require("wijmo/wijmo.angular2.input");
var portfolioService_1 = require("../core/services/portfolioService");
var wjNg2Input = require("wijmo/wijmo.angular2.input");
var PortfolioDetailComponent = /** @class */ (function () {
    function PortfolioDetailComponent(activatedRoute, _router, noteService, utilityService, notificationService, membershipService, _portfolioService) {
        var _this = this;
        this.activatedRoute = activatedRoute;
        this._router = _router;
        this.noteService = noteService;
        this.utilityService = utilityService;
        this.notificationService = notificationService;
        this.membershipService = membershipService;
        this._portfolioService = _portfolioService;
        this._ShowmessagedivWar = false;
        this.Message = '';
        this._Showmessagediv = false;
        this.activatedRoute.params.forEach(function (params) {
            _this._portfolio = new portfolio_1.portfolio('');
            if (params['id'] !== undefined) {
                var portfolioId = params['id'];
                _this._portfolio.PortfolioMasterGuid = portfolioId;
                _this.GetPortfolioByID();
            }
            else {
                _this.GetAllLookups();
                _this.getAllFund();
            }
        });
        this.utilityService.setPageTitle("M61 – Dynamic Portfolio");
    }
    PortfolioDetailComponent.prototype.ngOnInit = function () {
        // get return url from route parameters or default to '/'
    };
    PortfolioDetailComponent.prototype.GetAllLookups = function () {
        var _this = this;
        var parentids = "74,81";
        this.membershipService.getAllLookup(parentids).subscribe(function (res) {
            var data = res.lstLookups;
            _this.lstPool = data.filter(function (x) { return x.ParentID == "74"; });
            _this.lstPool.forEach(function (objparent, i) {
                _this._portfolio.PoolIDs.split(/\s*,\s*/).forEach(function (obj, j) {
                    if (objparent.LookupID == obj) {
                        _this.lstPool[i].selected = true;
                    }
                });
            });
        });
    };
    PortfolioDetailComponent.prototype.SavePortfolio = function () {
        var _this = this;
        if (this._portfolio.PortfolioName == '' || this._portfolio.PortfolioName == null || this._portfolio.PortfolioName == undefined) {
            this._ShowmessagedivWar = true;
            this._ShowmessagedivMsgWar = "Portfolio name can not be empty.";
            setTimeout(function () {
                this._ShowmessagedivWar = false;
                this._ShowmessagedivMsgWar = '';
            }.bind(this), 5000);
            return;
        }
        var poolids = '';
        var fundids = '';
        var clientids = '';
        var financingsourceids = '';
        if (this.multiselPool != undefined)
            var poolids = this.multiselPool.checkedItems.map(function (_a) {
                var LookupID = _a.LookupID;
                return LookupID;
            }).join(',');
        if (this.multiselFund != undefined)
            var fundids = this.multiselFund.checkedItems.map(function (_a) {
                var FundID = _a.FundID;
                return FundID;
            }).join(',');
        if (this.multiselClient != undefined)
            var clientids = this.multiselClient.checkedItems.map(function (_a) {
                var ClientID = _a.ClientID;
                return ClientID;
            }).join(',');
        if (this.multiselFinancingSource != undefined)
            financingsourceids = this.multiselFinancingSource.checkedItems.map(function (_a) {
                var FinancingSourceMasterID = _a.FinancingSourceMasterID;
                return FinancingSourceMasterID;
            }).join(',');
        this._portfolio.PoolIDs = poolids;
        this._portfolio.FundIDs = fundids;
        this._portfolio.ClientIDs = clientids;
        this._portfolio.FinancingSourceIDs = financingsourceids;
        this._portfolioService.addupdateportfolio(this._portfolio).subscribe(function (res) {
            if (res.Succeeded) {
                if (res.Message == "Success") {
                    localStorage.setItem('divSucessPortfolio', JSON.stringify(true));
                    if (_this._portfolio.PortfolioMasterGuid == '')
                        localStorage.setItem('successmsgPortfolio', JSON.stringify('Portfolio added successfully'));
                    else
                        localStorage.setItem('successmsgPortfolio', JSON.stringify('Portfolio updated successfully'));
                    _this._router.navigate(['portfolio']);
                }
                else if (res.Message == "Duplicate") {
                    _this._ShowmessagedivWar = true;
                    _this._ShowmessagedivMsgWar = "Portfolio name already exist.Please chose other one.";
                    setTimeout(function () {
                        this._ShowmessagedivWar = false;
                        this._ShowmessagedivMsgWar = '';
                    }.bind(_this), 5000);
                }
                else {
                    _this._ShowmessagedivWar = true;
                    _this._ShowmessagedivMsgWar = "Something  went wrong.Please try again.";
                    setTimeout(function () {
                        this._ShowmessagedivWar = false;
                        this._ShowmessagedivMsgWar = '';
                    }.bind(_this), 5000);
                }
            }
            else {
                _this._router.navigate(['login']);
            }
        }),
            function (error) {
                _this._ShowmessagedivWar = true;
                _this._ShowmessagedivMsgWar = "Something  went wrong.Please try again.";
                setTimeout(function () {
                    this._ShowmessagedivWar = false;
                    this._ShowmessagedivMsgWar = '';
                }.bind(_this), 5000);
            };
    };
    PortfolioDetailComponent.prototype.GetPortfolioByID = function () {
        var _this = this;
        try {
            this._portfolioService.getportfoliodetailbyid(this._portfolio).subscribe(function (res) {
                if (res.Succeeded) {
                    if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                        _this._portfolio = res.portfolioDataContract;
                        _this.GetAllLookups();
                        _this.getAllFund();
                        _this.GetFinancingSource();
                        _this.getAllClient();
                    }
                    else {
                        localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                        localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));
                        _this.utilityService.navigateUnauthorize();
                    }
                }
                else {
                    _this._router.navigate(['login']);
                }
            });
        }
        catch (err) {
        }
    };
    PortfolioDetailComponent.prototype.Cancel = function () {
        this._router.navigate(['portfolio']);
    };
    PortfolioDetailComponent.prototype.getAllFund = function () {
        var _this = this;
        this.noteService.getAllFund().subscribe(function (res) {
            if (res.Succeeded) {
                _this.lstFund = res.lstFund;
                _this.lstFund.forEach(function (objparent, i) {
                    _this._portfolio.FundIDs.split(/\s*,\s*/).forEach(function (obj, j) {
                        if (objparent.FundID == obj) {
                            _this.lstFund[i].selected = true;
                        }
                    });
                });
            }
        });
    };
    PortfolioDetailComponent.prototype.GetFinancingSource = function () {
        var _this = this;
        this.noteService.GetFinancingSource().subscribe(function (res) {
            if (res.Succeeded) {
                _this.lstfinancingsource = res.lstfinancingsource;
                _this.lstfinancingsource.forEach(function (objparent, i) {
                    _this._portfolio.FinancingSourceIDs.split(/\s*,\s*/).forEach(function (obj, j) {
                        if (objparent.FinancingSourceMasterID == obj) {
                            _this.lstfinancingsource[i].selected = true;
                        }
                    });
                });
            }
        });
    };
    PortfolioDetailComponent.prototype.getAllClient = function () {
        var _this = this;
        this.noteService.getAllClient().subscribe(function (res) {
            if (res.Succeeded) {
                _this.lstClient = res.lstClient;
                _this.lstClient.forEach(function (objparent, i) {
                    _this._portfolio.ClientIDs.split(/\s*,\s*/).forEach(function (obj, j) {
                        if (objparent.ClientID == obj) {
                            _this.lstClient[i].selected = true;
                        }
                    });
                });
            }
        });
    };
    var _a, _b, _c, _d, _e, _f;
    __decorate([
        (0, core_1.ViewChild)('multiselPool'),
        __metadata("design:type", typeof (_a = typeof wjNg2Input !== "undefined" && wjNg2Input.WjMultiSelect) === "function" ? _a : Object)
    ], PortfolioDetailComponent.prototype, "multiselPool", void 0);
    __decorate([
        (0, core_1.ViewChild)('multiselFund'),
        __metadata("design:type", typeof (_b = typeof wjNg2Input !== "undefined" && wjNg2Input.WjMultiSelect) === "function" ? _b : Object)
    ], PortfolioDetailComponent.prototype, "multiselFund", void 0);
    __decorate([
        (0, core_1.ViewChild)('multiselClient'),
        __metadata("design:type", typeof (_c = typeof wjNg2Input !== "undefined" && wjNg2Input.WjMultiSelect) === "function" ? _c : Object)
    ], PortfolioDetailComponent.prototype, "multiselClient", void 0);
    __decorate([
        (0, core_1.ViewChild)('multiselFinancingSource'),
        __metadata("design:type", typeof (_d = typeof wjNg2Input !== "undefined" && wjNg2Input.WjMultiSelect) === "function" ? _d : Object)
    ], PortfolioDetailComponent.prototype, "multiselFinancingSource", void 0);
    PortfolioDetailComponent = __decorate([
        (0, core_1.Component)({
            selector: "portfoliodetail",
            templateUrl: "app/components/portfoliodetail.html?v=" + $.getVersion(),
            providers: [NoteService_1.NoteService, notificationService_1.NotificationService, utilityService_1.UtilityService, portfolioService_1.portfolioService],
        }),
        __metadata("design:paramtypes", [typeof (_e = typeof router_1.ActivatedRoute !== "undefined" && router_1.ActivatedRoute) === "function" ? _e : Object, typeof (_f = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _f : Object, NoteService_1.NoteService,
            utilityService_1.UtilityService,
            notificationService_1.NotificationService,
            membershipservice_1.MembershipService,
            portfolioService_1.portfolioService])
    ], PortfolioDetailComponent);
    return PortfolioDetailComponent;
}());
exports.PortfolioDetailComponent = PortfolioDetailComponent;
var routes = [
    { path: '', component: PortfolioDetailComponent }
];
var PortfolioDetailModule = /** @class */ (function () {
    function PortfolioDetailModule() {
    }
    PortfolioDetailModule = __decorate([
        (0, core_2.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_core_1.WjCoreModule, wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule, wijmo_angular2_input_1.WjInputModule],
            declarations: [PortfolioDetailComponent]
        })
    ], PortfolioDetailModule);
    return PortfolioDetailModule;
}());
exports.PortfolioDetailModule = PortfolioDetailModule;
//# sourceMappingURL=portfoliodetail.component.js.map