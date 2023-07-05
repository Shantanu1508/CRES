"use strict";
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (Object.prototype.hasOwnProperty.call(b, p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        if (typeof b !== "function" && b !== null)
            throw new TypeError("Class extends value " + String(b) + " is not a constructor or null");
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
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
exports.DealListModule = exports.DealListComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var dealService_1 = require("../core/services/dealService");
var notificationService_1 = require("../core/services/notificationService");
var core_2 = require("@angular/core");
var utilityService_1 = require("../core/services/utilityService");
var paginated_1 = require("../core/common/paginated");
var wjcGrid = require("wijmo/wijmo.grid");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wjcGridFilter = require("wijmo/wijmo.grid.filter");
var wijmo_angular2_core_1 = require("wijmo/wijmo.angular2.core");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var DealListComponent = /** @class */ (function (_super) {
    __extends(DealListComponent, _super);
    function DealListComponent(dealSrv, utilityService, notificationService, _router) {
        var _this = _super.call(this, 30, 1, 0) || this;
        _this.dealSrv = dealSrv;
        _this.utilityService = utilityService;
        _this.notificationService = notificationService;
        _this._router = _router;
        _this._dealListFetching = false;
        _this._ShowmessagedivMsgWar = false;
        _this._dvEmptyDealSearchMsg = false;
        _this._Showmessagediv = false;
        _this._ShowmessagedivMsg = '';
        _this._WaringMessage = '';
        _this._isshowDealbutton = false;
        _this._isShowActivityLog = false;
        _this._isshowDealbutton = false;
        _this.getDeals();
        _this.utilityService.setPageTitle("M61–Deals");
        return _this;
    }
    DealListComponent.prototype.initialized = function (s, e) {
        this.gridFilter.filterChanged.addHandler(function () {
            console.log('filter changed 11111');
        });
    };
    // Component views are initialized
    DealListComponent.prototype.ngAfterViewInit = function () {
        // commit row changes when scrolling the grid
        var _this = this;
        this.flex.scrollPositionChanged.addHandler(function () {
            var myDiv = $('#flex').find('div[wj-part="root"]');
            if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
                if (_this.flex.rows.length < _this._totalCount) {
                    _this._pageIndex = _this.pagePlus(1);
                    _this.getDeals();
                }
            }
        });
    };
    DealListComponent.prototype.getDeals = function () {
        var _this = this;
        if (localStorage.getItem('divSucessDeal') == 'true') {
            this._Showmessagediv = false; //Vishal
            this._ShowmessagedivMsg = localStorage.getItem('divSucessMsgDeal');
            this._ShowmessagedivMsg = (this._ShowmessagedivMsg.replace('\"', '')).replace('\"', '');
            localStorage.setItem('divSucessDeal', JSON.stringify(false));
            localStorage.setItem('divSucessMsgDeal', JSON.stringify(''));
            setTimeout(function () {
                this._Showmessagediv = false;
                console.log(this._Showmessagediv);
            }.bind(this), 5000);
        }
        if (localStorage.getItem('divWarningMsgDeal') == 'true') {
            this._ShowmessagedivMsgWar = true;
            this._WaringMessage = localStorage.getItem('divWarningMsg');
            this._WaringMessage = (this._WaringMessage.replace('\"', '')).replace('\"', '');
            localStorage.setItem('divWarningMsgDeal', JSON.stringify(false));
            localStorage.setItem('divWarningMsg', JSON.stringify(''));
            setTimeout(function () {
                this._ShowmessagedivMsgWar = false;
            }.bind(this), 5000);
        }
        this._dealListFetching = true;
        this.dealSrv.getAllDeals(this._pageIndex, this._pageSize)
            .subscribe(function (res) {
            if (res.Succeeded) {
                if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                    var data = res.lstDeals;
                    _this._totalCount = res.TotalCount;
                    if (_this._pageIndex == 1) {
                        _this.lstdeals = data;
                        //remove first cell selection
                        _this.flex.selectionMode = wjcGrid.SelectionMode.None;
                        if (res.TotalCount == 0) {
                            _this._dvEmptyDealSearchMsg = true;
                            _this._dealListFetching = false;
                        }
                        else {
                            setTimeout(function () {
                                _this._dealListFetching = false;
                            }, 2000);
                        }
                        setTimeout(function () {
                            _this.ApplyPermissions(res.UserPermissionList);
                        }, 2000);
                        //format date
                        for (var i = 0; i < _this.lstdeals.length; i++) {
                            if (_this.lstdeals[i].FullyExtMaturityDate != '0001-01-01T00:00:00') {
                                if (_this.lstdeals[i].FullyExtMaturityDate == null) {
                                    _this.lstdeals[i].FullyExtMaturityDate = null;
                                }
                                else {
                                    _this.lstdeals[i].FullyExtMaturityDate = new Date(_this.lstdeals[i].FullyExtMaturityDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                                }
                            }
                            else {
                                _this.lstdeals[i].FullyExtMaturityDate = null;
                            }
                            if (_this.lstdeals[i].EstClosingDate != '0001-01-01T00:00:00') {
                                if (_this.lstdeals[i].EstClosingDate != null) {
                                    _this.lstdeals[i].EstClosingDate = new Date(_this.lstdeals[i].EstClosingDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                                }
                            }
                            else {
                                _this.lstdeals[i].EstClosingDate = null;
                            }
                        }
                    }
                    else {
                        data.forEach(function (obj, i) {
                            //format date
                            if (obj.FullyExtMaturityDate != '0001-01-01T00:00:00') {
                                if (obj.FullyExtMaturityDate == null) {
                                    obj.FullyExtMaturityDate = null;
                                }
                                else {
                                    obj.FullyExtMaturityDate = new Date(obj.FullyExtMaturityDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                                }
                            }
                            else {
                                obj.FullyExtMaturityDate = null;
                            }
                            if (obj.EstClosingDate != '0001-01-01T00:00:00') {
                                if (obj.EstClosingDate != null) {
                                    obj.EstClosingDate = new Date(obj.EstClosingDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
                                }
                            }
                            else {
                                obj.EstClosingDate = null;
                            }
                            //this.flex.rows.push(new wjcGrid.Row(obj));
                        });
                        _this.lstdeals = _this.lstdeals.concat(data);
                    }
                    _this._dealListFetching = false;
                    setTimeout(function () {
                        this.flex.invalidate();
                        //this.flex.autoSizeColumns(0, this.flex.columns.length, false, 20);
                        //this.flex.columns[0].width = 350; // for Note Id
                    }.bind(_this), 1);
                }
                else {
                    _this.utilityService.navigateUnauthorize();
                }
                //
            }
            else {
                _this.utilityService.navigateToSignIn();
            }
        }, function (error) {
            if (error.status == 401) {
                _this.notificationService.printErrorMessage('Authentication required');
                _this.utilityService.navigateToSignIn();
            }
        });
    };
    DealListComponent.prototype.ApplyPermissions = function (_object) {
        var buttonarray = _object.filter(function (item) { return item.ModuleType === 'Control' && item.RightsName === 'Edit'; });
        if (buttonarray.length > 0 && typeof buttonarray != 'undefined') {
            this._isshowDealbutton = true;
        }
        this._isShowActivityLog = true;
    };
    DealListComponent.prototype.AddNewDeal = function () {
        this._router.navigate(['/dealdetail', "00000000-0000-0000-0000-000000000000"]);
    };
    DealListComponent.prototype.clickeddeal = function () {
        this._dealListFetching = true;
    };
    var _a, _b, _c;
    __decorate([
        (0, core_1.ViewChild)('flex'),
        __metadata("design:type", typeof (_a = typeof wjcGrid !== "undefined" && wjcGrid.FlexGrid) === "function" ? _a : Object)
    ], DealListComponent.prototype, "flex", void 0);
    __decorate([
        (0, core_1.ViewChild)('filter'),
        __metadata("design:type", typeof (_b = typeof wjcGridFilter !== "undefined" && wjcGridFilter.FlexGridFilter) === "function" ? _b : Object)
    ], DealListComponent.prototype, "gridFilter", void 0);
    DealListComponent = __decorate([
        (0, core_1.Component)({
            selector: "deal",
            templateUrl: "app/components/deal.html?v=" + $.getVersion(),
            providers: [dealService_1.dealService, notificationService_1.NotificationService]
        }),
        __metadata("design:paramtypes", [dealService_1.dealService,
            utilityService_1.UtilityService,
            notificationService_1.NotificationService, typeof (_c = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _c : Object])
    ], DealListComponent);
    return DealListComponent;
}(paginated_1.Paginated));
exports.DealListComponent = DealListComponent;
var routes = [
    { path: '', component: DealListComponent }
];
var DealListModule = /** @class */ (function () {
    function DealListModule() {
    }
    DealListModule = __decorate([
        (0, core_2.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_core_1.WjCoreModule, wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule],
            declarations: [DealListComponent]
        })
    ], DealListModule);
    return DealListModule;
}());
exports.DealListModule = DealListModule;
//# sourceMappingURL=deal.component.js.map