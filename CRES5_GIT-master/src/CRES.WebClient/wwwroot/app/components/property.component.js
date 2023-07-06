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
exports.PropertyModule = exports.Propertycomponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var Property_1 = require("../core/domain/Property");
var propertyService_1 = require("../core/services/propertyService");
var notificationService_1 = require("../core/services/notificationService");
var utilityService_1 = require("../core/services/utilityService");
//import { Routes, APP_ROUTES } from '../routes.Config';
var paginated_1 = require("../core/common/paginated");
var wjcGrid = require("wijmo/wijmo.grid");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wijmo_angular2_core_1 = require("wijmo/wijmo.angular2.core");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var Propertycomponent = /** @class */ (function (_super) {
    __extends(Propertycomponent, _super);
    function Propertycomponent(_router, propertysvc, notificationService, utilityService) {
        var _this = _super.call(this, 50, 1, 0) || this;
        _this._router = _router;
        _this.propertysvc = propertysvc;
        _this.notificationService = notificationService;
        _this.utilityService = utilityService;
        _this._formatting = true;
        _this.updatedRowNo = [];
        _this.rowsToUpdate = [];
        _this._isPropertyListFetching = false;
        _this._dvEmptyPropertySearchMsg = false;
        _this.alwaysEdit = false;
        _this._prop = new Property_1.Property('');
        _this.getAllproperty(_this._prop);
        _this.utilityService.setPageTitle("M61-Properties");
        return _this;
    }
    // Component views are initialized
    Propertycomponent.prototype.ngAfterViewInit = function () {
        //== this._updateFormatting();
        var _this = this;
        // commit row changes when scrolling the grid
        this.flex.scrollPositionChanged.addHandler(function () {
            var myDiv = $('#flex').find('div[wj-part="root"]');
            if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
                //alert('this.flex.rows.length ' + this.flex.rows.length + 'this._totalCount ' + this._totalCount);
                if (_this.flex.rows.length < _this._totalCount) {
                    _this._pageIndex = _this.pagePlus(1);
                    _this.getAllproperty(_this._prop);
                }
            }
        });
    };
    Propertycomponent.prototype.getAllproperty = function (_prop) {
        var _this = this;
        this._isPropertyListFetching = true;
        _prop.Deal_DealID = '';
        this.propertysvc.getallproperty(_prop, this._pageIndex, this._pageSize).subscribe(function (res) {
            if (res.Succeeded) {
                if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                    var data = res.lstProperty;
                    _this._totalCount = res.TotalCount;
                    if (_this._pageIndex == 1) {
                        _this.lstproperties = data;
                        //remove first cell selection
                        _this.flex.selectionMode = wjcGrid.SelectionMode.None;
                        if (res.TotalCount == 0) {
                            _this._dvEmptyPropertySearchMsg = true;
                            //setTimeout(() => {
                            //    this._dvEmptyPropertySearchMsg = false;
                            //}, 2000);
                        }
                    }
                    else {
                        //data.forEach((obj, i) => { // FETCH ALL DATA AND PUSH IN FLEX GRID!!!
                        //    this.flex.rows.push(new wjcGrid.Row(obj));
                        //});
                        _this.lstproperties.concat(data);
                    }
                    _this.ConvertToBindableDate(_this.lstproperties);
                    _this._isPropertyListFetching = false;
                }
                else {
                    localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
                    localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));
                    _this.utilityService.navigateUnauthorize();
                }
            }
            else {
                _this._router.navigate(['/login']);
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    Propertycomponent.prototype.selectionChangedHandler = function () {
        var flex = this.flex;
        var rowIdx = this.flex.collectionView.currentPosition;
        try {
            var count = this.updatedRowNo.indexOf(rowIdx);
            if (count == -1)
                this.updatedRowNo.push(rowIdx);
        }
        catch (err) {
            console.log(err);
        }
    };
    Propertycomponent.prototype.UpdateProperty = function () {
        try {
            this.rowsToUpdate = [];
            for (var i = 0; i < this.updatedRowNo.length; i++) {
                this.rowsToUpdate.push(this.lstproperties[this.updatedRowNo[i]]);
            }
        }
        catch (err) {
            console.log(err);
        }
        this._prop = this.rowsToUpdate;
        this.propertysvc.AddupdateProperty(this._prop).subscribe(function (res) {
            if (res.Succeeded) {
                //  alert("Succeed");
            }
            else {
                //     this._router.navigate([this.routes.login.name]);
                //  alert("Fail");
            }
        });
        (function (error) { return console.error('Error: ' + error); });
    };
    Propertycomponent.prototype.ConvertToBindableDate = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            this.lstproperties[i].CreatedDate = new Date(Data[i].CreatedDate);
        }
    };
    __decorate([
        core_1.ViewChild('flex'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], Propertycomponent.prototype, "flex", void 0);
    Propertycomponent = __decorate([
        core_1.Component({
            //  selector: "property",
            templateUrl: "app/components/Property.html",
            providers: [propertyService_1.propertyService, notificationService_1.NotificationService]
        })
        //@CanActivate((next: ComponentInstruction, previous: ComponentInstruction) => {
        //    return isLoggedIn(next, previous);
        //})
        ,
        __metadata("design:paramtypes", [router_1.Router, propertyService_1.propertyService,
            notificationService_1.NotificationService,
            utilityService_1.UtilityService])
    ], Propertycomponent);
    return Propertycomponent;
}(paginated_1.Paginated));
exports.Propertycomponent = Propertycomponent;
var routes = [
    { path: '', component: Propertycomponent }
];
var PropertyModule = /** @class */ (function () {
    function PropertyModule() {
    }
    PropertyModule = __decorate([
        core_2.NgModule({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_core_1.WjCoreModule, wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule],
            declarations: [Propertycomponent]
        })
    ], PropertyModule);
    return PropertyModule;
}());
exports.PropertyModule = PropertyModule;
//# sourceMappingURL=property.component.js.map