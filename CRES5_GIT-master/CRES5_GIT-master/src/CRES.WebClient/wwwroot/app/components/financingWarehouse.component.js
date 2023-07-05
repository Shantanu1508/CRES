"use strict";
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
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
exports.FinancingWareModule = exports.FinancingWareComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var financingWarehouseService_1 = require("../core/services/financingWarehouseService");
var notificationService_1 = require("../core/services/notificationService");
var utilityService_1 = require("../core/services/utilityService");
var paginated_1 = require("../core/common/paginated");
var wjcGrid = require("wijmo/wijmo.grid");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wijmo_angular2_core_1 = require("wijmo/wijmo.angular2.core");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var FinancingWareComponent = /** @class */ (function (_super) {
    __extends(FinancingWareComponent, _super);
    function FinancingWareComponent(_router, financingsvc, utilityService, notificationService, _actrouting) {
        var _this = _super.call(this, 50, 1, 0) || this;
        _this._router = _router;
        _this.financingsvc = financingsvc;
        _this.utilityService = utilityService;
        _this.notificationService = notificationService;
        _this._actrouting = _actrouting;
        //private routes = Routes;
        _this._dvEmptyFiancingSearchMsg = false;
        _this._Showmessagediv = false;
        _this._ShowmessagedivMsg = '';
        _this._isFinancingListFetching = false;
        _this._dvEmptyFinancingSearchMsg = false;
        //  this._note = new Note("75385E05-A73F-4BFE-AFEB-7214CB436F26");
        // this._note = new Note('');
        _this.utilityService.setPageTitle("M61-Financing");
        _this.getAllfinancingWarehouse();
        return _this;
    }
    FinancingWareComponent.prototype.ngAfterViewInit = function () {
        var _this = this;
        // commit row changes when scrolling the grid
        this.flex.scrollPositionChanged.addHandler(function () {
            var myDiv = $('#flex').find('div[wj-part="root"]');
            if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
                if (_this.flex.rows.length < _this._totalCount) {
                    _this._pageIndex = _this.pagePlus(1);
                    _this.getAllfinancingWarehouse();
                }
            }
        });
    };
    FinancingWareComponent.prototype.getAllfinancingWarehouse = function () {
        var _this = this;
        if (localStorage.getItem('divSucessFinancing') == 'true') {
            this._Showmessagediv = true;
            this._ShowmessagedivMsg = localStorage.getItem('divSucessMsgFinancing');
            this._ShowmessagedivMsg = (this._ShowmessagedivMsg.replace('\"', '')).replace('\"', '');
            localStorage.setItem('divSucessFinancing', JSON.stringify(false));
            localStorage.setItem('divSucessMsgFinancing', JSON.stringify(''));
            //to hide _Showmessagediv after 5 sec
            setTimeout(function () {
                this._Showmessagediv = false;
                console.log(this._Showmessagediv);
            }.bind(this), 5000);
        }
        this._isFinancingListFetching = true;
        this.financingsvc.GetAllFinancingWarehouse(this._pageIndex, this._pageSize).subscribe(function (res) {
            if (res.Succeeded) {
                //------------------
                var data = res.lstFinancingWarehouseDataContract;
                _this._totalCount = res.TotalCount;
                if (_this._pageIndex == 1) {
                    _this.lstfinancingWarehouse = data;
                    //remove first cell selection
                    _this.flex.selectionMode = wjcGrid.SelectionMode.None;
                    if (res.TotalCount == 0) {
                        _this._dvEmptyFinancingSearchMsg = true;
                    }
                }
                else {
                    //data.forEach((obj, i) => {
                    //    this.flex.rows.push(new wjcGrid.Row(obj));
                    //});
                    _this.lstfinancingWarehouse.concat(data);
                }
                _this._isFinancingListFetching = false;
                if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                }
                else {
                    localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                    localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));
                    _this.utilityService.navigateUnauthorize();
                }
                //-------------------
            }
            else {
                _this.utilityService.navigateToSignIn();
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    FinancingWareComponent.prototype.AddNewFinancing = function () {
        //this.financingaddpath = ['/financingdetail', { id: "00000000-0000-0000-0000-000000000000" }]
        ////      alert("AddNewDeal");
        //this._router.navigate(this.financingaddpath)
        this._router.navigate(['/financingdetail', "00000000-0000-0000-0000-000000000000"]);
    };
    __decorate([
        core_1.ViewChild('flex'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], FinancingWareComponent.prototype, "flex", void 0);
    FinancingWareComponent = __decorate([
        core_1.Component({
            selector: "FinancingWarehouse",
            templateUrl: "app/components/financingWarehouse.html",
            providers: [financingWarehouseService_1.financingWarehouseService, notificationService_1.NotificationService]
        })
        //@CanActivate((next: ComponentInstruction, previous: ComponentInstruction) => {
        //    return isLoggedIn(next, previous);
        //})
        ,
        core_1.Injectable(),
        __metadata("design:paramtypes", [router_1.Router,
            financingWarehouseService_1.financingWarehouseService,
            utilityService_1.UtilityService,
            notificationService_1.NotificationService,
            router_1.ActivatedRoute])
    ], FinancingWareComponent);
    return FinancingWareComponent;
}(paginated_1.Paginated));
exports.FinancingWareComponent = FinancingWareComponent;
var routes = [
    { path: '', component: FinancingWareComponent }
];
var FinancingWareModule = /** @class */ (function () {
    function FinancingWareModule() {
    }
    FinancingWareModule = __decorate([
        core_2.NgModule({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_core_1.WjCoreModule, wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule],
            declarations: [FinancingWareComponent]
        })
    ], FinancingWareModule);
    return FinancingWareModule;
}());
exports.FinancingWareModule = FinancingWareModule;
//# sourceMappingURL=financingWarehouse.component.js.map