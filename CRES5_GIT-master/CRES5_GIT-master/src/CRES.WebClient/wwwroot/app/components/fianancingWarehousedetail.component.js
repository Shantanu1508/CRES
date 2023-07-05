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
exports.FinancingWareDetailModule = exports.FinancingWareDetailComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var financingWarehouse_1 = require("../core/domain/financingWarehouse");
var financingWarehouseService_1 = require("../core/services/financingWarehouseService");
var notificationService_1 = require("../core/services/notificationService");
var utilityService_1 = require("../core/services/utilityService");
var wjcGrid = require("wijmo/wijmo.grid");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wijmo_angular2_core_1 = require("wijmo/wijmo.angular2.core");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_input_1 = require("wijmo/wijmo.angular2.input");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var FinancingWareDetailComponent = /** @class */ (function () {
    function FinancingWareDetailComponent(_router, 
    //private _routeParams: RouteParams,
    activatedRoute, financingsvc, utilityService, notificationService) {
        this._router = _router;
        this.activatedRoute = activatedRoute;
        this.financingsvc = financingsvc;
        this.utilityService = utilityService;
        this.notificationService = notificationService;
        this.flexfinancingwhouseupdatedRowNo = [];
        this.flexfinancingwhouseToUpdate = [];
        this._financingWhouse = new financingWarehouse_1.FinancingWarehouse;
        this._financingWarehouse = new financingWarehouse_1.FinancingWarehouse();
        this.getFinancingWhousebyId();
        this.utilityService.setPageTitle("M61-Financing Detail");
    }
    FinancingWareDetailComponent.prototype.saveFinancing = function () {
        var _this = this;
        this.financingsvc.SaveFinancing(this._financingWarehouse).subscribe(function (res) {
            if (res.Succeeded) {
                localStorage.setItem('divSucessFinancing', JSON.stringify(true));
                localStorage.setItem('divSucessMsgFinancing', JSON.stringify(res.Message));
                _this.FinancingWarehouseid = res.newFinancingWarehouseid;
                _this.SaveFinancingDetaillist();
                // this._router.navigate([this.routes.financingWareHouse.name]);
            }
            else {
                _this._router.navigate(['financingWareHouse']);
            }
        });
    };
    FinancingWareDetailComponent.prototype.SaveFinancingDetaillist = function () {
        var _this = this;
        if (this.flexfinancingwhouseupdatedRowNo.length > 0) {
            for (var i = 0; i < this.flexfinancingwhouseupdatedRowNo.length; i++) {
                //  this._financingWarehouse.lstFinancingWarehouseDetail[i].FinancingWarehouseID = this.FinancingWarehouseid;
                this.flexfinancingwhouseToUpdate.push(this._financingWarehouse.lstFinancingWarehouseDetail[this.flexfinancingwhouseupdatedRowNo[i]]);
                this.flexfinancingwhouseToUpdate[i].FinancingWarehouseID = this.FinancingWarehouseid;
            }
            this._financingWhouse.lstFinancingWarehouseDetail = this.flexfinancingwhouseToUpdate;
            this.financingsvc.SaveFinancingDetails(this._financingWhouse).subscribe(function (res) {
                if (res.Succeeded) {
                    localStorage.setItem('divSucessFinancing', JSON.stringify(true));
                    localStorage.setItem('divSucessMsgFinancing', JSON.stringify(res.Message));
                    _this._router.navigate(['financingWareHouse']);
                }
                else {
                    // alert('Fail');
                    _this.utilityService.navigateToSignIn();
                }
            });
        }
        else {
            this._router.navigate(['financingWareHouse']);
        }
    };
    FinancingWareDetailComponent.prototype.getFinancingWhousebyId = function () {
        var _this = this;
        var options = { year: "numeric", month: "numeric", day: "numeric" };
        this.activatedRoute.params.subscribe(function (params) {
            _this._financingWhouse.FinancingWarehouseID = params['id'];
        });
        this.financingsvc.getFinancingWhousebyId(this._financingWhouse).subscribe(function (res) {
            if (res.Succeeded) {
                _this._financingWarehouse = res.FinancingWarehouseDataContract;
                _this.accountid = _this._financingWarehouse.AccountID;
                for (var i = 0; i < _this._financingWarehouse.lstFinancingWarehouseDetail.length; i++) {
                    if (_this._financingWarehouse.lstFinancingWarehouseDetail[i].StartDate != null) {
                        _this._financingWarehouse.lstFinancingWarehouseDetail[i].StartDate = new Date(_this._financingWarehouse.lstFinancingWarehouseDetail[i].StartDate.toString().replace('T00', 'T17')).toLocaleDateString("en-US", options);
                    }
                    if (_this._financingWarehouse.lstFinancingWarehouseDetail[i].EndDate != null) {
                        _this._financingWarehouse.lstFinancingWarehouseDetail[i].EndDate = new Date(_this._financingWarehouse.lstFinancingWarehouseDetail[i].EndDate.toString().replace('T00', 'T17')).toLocaleDateString("en-US", options);
                    }
                }
            }
            else {
                _this._financingWarehouse = new financingWarehouse_1.FinancingWarehouse();
            }
        });
    };
    FinancingWareDetailComponent.prototype.financingselectionChanged = function () {
        var flexfwh = this.flexfwh;
        var rowIdx = this.flexfwh.collectionView.currentPosition;
        try {
            var count = this.flexfinancingwhouseupdatedRowNo.indexOf(rowIdx);
            if (count == -1)
                this.flexfinancingwhouseupdatedRowNo.push(rowIdx);
        }
        catch (err) {
            console.log(err);
        }
    };
    FinancingWareDetailComponent.prototype.DiscardChanges = function () {
        this._router.navigate(['financingWareHouse']);
    };
    FinancingWareDetailComponent.prototype.PayFrequencyChange = function (newvalue) {
        this._financingWarehouse.PayFrequency = newvalue;
    };
    FinancingWareDetailComponent.prototype.BaseCurrencyChange = function (newvalue) {
        this._financingWarehouse.BaseCurrencyID = newvalue;
    };
    FinancingWareDetailComponent.prototype.IsRevolvingChange = function (newvalue) {
        this._financingWarehouse.IsRevolving = newvalue;
    };
    FinancingWareDetailComponent.prototype.CustomValidator = function () {
        if (this._financingWarehouse.Name != "" && this._financingWarehouse.Name != null) {
            this.saveFinancing();
        }
        else {
            var msg = "";
            this.CustomAlert(msg);
        }
    };
    FinancingWareDetailComponent.prototype.CustomAlert = function (dialog) {
        var winW = window.innerWidth;
        var winH = window.innerHeight;
        var dialogoverlay = document.getElementById('dialogoverlay');
        var dialogbox = document.getElementById('dialogbox');
        dialogoverlay.style.display = "block";
        dialogoverlay.style.height = winH + "px";
        dialogbox.style.left = (winW / 2) - (550 * .5) + "px";
        dialogbox.style.top = "100px";
        dialogbox.style.display = "block";
        document.getElementById('dialogboxhead').innerHTML = "CRES - web";
        document.getElementById('dialogboxbody').innerHTML = dialog;
        //document.getElementById('dialogboxfoot').innerHTML = '<span class="custombutton" onclientclick="this.ok()">OK</span>';
    };
    FinancingWareDetailComponent.prototype.ok = function () {
        document.getElementById('dialogbox').style.display = "none";
        document.getElementById('dialogoverlay').style.display = "none";
    };
    __decorate([
        core_1.ViewChild('flexfwh'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], FinancingWareDetailComponent.prototype, "flexfwh", void 0);
    FinancingWareDetailComponent = __decorate([
        core_1.Component({
            //  selector: "FinancingWarehouseDetail",
            templateUrl: "app/components/financingWarehouseDetail.html?v=" + $.getVersion(),
            providers: [financingWarehouseService_1.financingWarehouseService, notificationService_1.NotificationService]
        }),
        __metadata("design:paramtypes", [router_1.Router,
            router_1.ActivatedRoute,
            financingWarehouseService_1.financingWarehouseService,
            utilityService_1.UtilityService,
            notificationService_1.NotificationService])
    ], FinancingWareDetailComponent);
    return FinancingWareDetailComponent;
}());
exports.FinancingWareDetailComponent = FinancingWareDetailComponent;
var routes = [
    { path: '', component: FinancingWareDetailComponent }
];
var FinancingWareDetailModule = /** @class */ (function () {
    function FinancingWareDetailModule() {
    }
    FinancingWareDetailModule = __decorate([
        core_2.NgModule({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_core_1.WjCoreModule, wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule, wijmo_angular2_input_1.WjInputModule],
            declarations: [FinancingWareDetailComponent]
        })
    ], FinancingWareDetailModule);
    return FinancingWareDetailModule;
}());
exports.FinancingWareDetailModule = FinancingWareDetailModule;
//# sourceMappingURL=fianancingWarehousedetail.component.js.map