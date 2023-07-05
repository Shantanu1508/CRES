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
exports.ImportUnderwritingModule = exports.ImportUnderwritingComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var dealservice_1 = require("../../core/services/dealservice");
var deals_1 = require("../../core/domain/deals");
var ImportUnderwritingService_1 = require("../../core/services/ImportUnderwritingService");
var PermissionService_1 = require("../../core/services/PermissionService");
var utilityService_1 = require("../../core/services/utilityService");
var backshopImport_1 = require("../../core/domain/backshopImport");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
//import { WjCoreModule } from 'wijmo/wijmo.angular2.core';
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var ImportUnderwritingComponent = /** @class */ (function () {
    function ImportUnderwritingComponent(//private _routeParams: RouteParams,
    dealSrv, importUnderwritingService, permissionService, utilityService, _router) {
        this.dealSrv = dealSrv;
        this.importUnderwritingService = importUnderwritingService;
        this.permissionService = permissionService;
        this.utilityService = utilityService;
        this._router = _router;
        this._dvDealImport = false;
        this._dvDealImportMsg = '';
        this.isProcessComplete = true;
        this._backshopImport = new backshopImport_1.backshopImport('', '');
        this._deal = new deals_1.deals('');
        this.isProcessComplete = false;
        this.GetUserPermission();
        this.utilityService.setPageTitle("M61-Integration");
    }
    ImportUnderwritingComponent.prototype.ImportBackShopInUnderwritingtable = function () {
        var _this = this;
        this.isProcessComplete = true;
        this._dvDealImport = false;
        this._dvDealImportMsg = '';
        var _userData = JSON.parse(localStorage.getItem('user'));
        this._backshopImport.UserName = _userData.UserID;
        this._deal.CREDealID = this._backshopImport.DealName;
        this._deal.DealName = this._backshopImport.DealName;
        this.dealSrv.checkduplicatedeal(this._deal).subscribe(function (res) {
            if (res.Succeeded) {
                _this.messagetext = "Deal Id " + _this._deal.CREDealID + " already exist, do you want to override existing deal information?";
                _this.showDialog();
            }
            else {
                _this.Importdealfrombackshoptoin_underwriting();
            }
        });
        //this.importUnderwritingService.getINUnderwritingDealByDealIdorDealName(this._backshopImport).subscribe(res => {
        //    if (res.Succeeded) {
        //        this.messagetext = res.Message;
        //        this.showDialog();                 
        //    }
        //    else {
        //        this.Importdealfrombackshoptoin_underwriting();
        //    }
        //});
    };
    ImportUnderwritingComponent.prototype.Importdealfrombackshoptoin_underwriting = function () {
        var _this = this;
        //Import deal from backshop to in_underwriting
        this.importUnderwritingService.ImportBackShopInUnderwritingtable(this._backshopImport).subscribe(function (res) {
            if (res.Succeeded) {
                _this.isProcessComplete = false;
                _this._backshopImport = res.BackShopImportDataContract;
                localStorage.setItem('backshopImport', JSON.stringify(_this._backshopImport));
                _this._router.navigate(['\IN_UnderwritingDealDetail']);
            }
            else {
                _this.isProcessComplete = false;
                _this._dvDealImport = true;
                _this._dvDealImportMsg = res.Message;
            }
        });
    };
    ImportUnderwritingComponent.prototype.GetUserPermission = function () {
        var _this = this;
        this.permissionService.GetUserPermissionByPagename("Integration").subscribe(function (res) {
            if (res.Succeeded) {
                if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                }
                else {
                    localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                    localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));
                    _this.utilityService.navigateUnauthorize();
                }
            }
        });
    };
    ImportUnderwritingComponent.prototype.showDialog = function () {
        var customdialogbox = document.getElementById('customdialogbox');
        customdialogbox.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    ImportUnderwritingComponent.prototype.startimportprocess = function () {
        this.Importdealfrombackshoptoin_underwriting();
    };
    ImportUnderwritingComponent.prototype.ClosePopUp = function () {
        var modal = document.getElementById('customdialogbox');
        modal.style.display = "none";
        this.isProcessComplete = false;
    };
    var _a;
    ImportUnderwritingComponent = __decorate([
        (0, core_1.Component)({
            // selector: "ImportUnderwriting",
            templateUrl: "app/components/ImportExport/ImportUnderwriting.html",
            providers: [ImportUnderwritingService_1.ImportUnderwritingService, PermissionService_1.PermissionService, utilityService_1.UtilityService, dealservice_1.dealService],
        }),
        __metadata("design:paramtypes", [dealservice_1.dealService,
            ImportUnderwritingService_1.ImportUnderwritingService,
            PermissionService_1.PermissionService,
            utilityService_1.UtilityService, typeof (_a = typeof router_1.Router !== "undefined" && router_1.Router) === "function" ? _a : Object])
    ], ImportUnderwritingComponent);
    return ImportUnderwritingComponent;
}());
exports.ImportUnderwritingComponent = ImportUnderwritingComponent;
var routes = [
    { path: '', component: ImportUnderwritingComponent }
];
var ImportUnderwritingModule = /** @class */ (function () {
    function ImportUnderwritingModule() {
    }
    ImportUnderwritingModule = __decorate([
        (0, core_2.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule],
            declarations: [ImportUnderwritingComponent]
        })
    ], ImportUnderwritingModule);
    return ImportUnderwritingModule;
}());
exports.ImportUnderwritingModule = ImportUnderwritingModule;
//# sourceMappingURL=ImportUnderwriting.component.js.map