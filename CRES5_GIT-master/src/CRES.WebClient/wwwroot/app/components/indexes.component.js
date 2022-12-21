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
exports.IndexesModule = exports.IndexesComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var indexesService_1 = require("../core/services/indexesService");
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
var IndexesComponent = /** @class */ (function (_super) {
    __extends(IndexesComponent, _super);
    function IndexesComponent(_router, indexesService, utilityService, notificationService) {
        var _this = _super.call(this, 30, 1, 0) || this;
        _this._router = _router;
        _this.indexesService = indexesService;
        _this.utilityService = utilityService;
        _this.notificationService = notificationService;
        _this.TotalCount = 0;
        _this.indexesupdatedRowNo = [];
        _this.indexesToUpdate = [];
        _this.Message = '';
        _this._ShowSuccessmessagediv = false;
        // private routes = Routes;
        _this._isIndexesListFetching = true;
        _this._isshowIndexesAddbutton = false;
        _this._dvEmptyIndexesSearchMsg = false;
        _this.GetAllIndexes();
        _this.utilityService.setPageTitle("M61–Indexes");
        return _this;
    }
    // Component views are initialized
    IndexesComponent.prototype.ngAfterViewInit = function () {
        // commit row changes when scrolling the grid
        var _this = this;
        this.flexIndexes.scrollPositionChanged.addHandler(function () {
            var myDiv = $('#flex').find('div[wj-part="root"]');
            if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
                if (_this.flexIndexes.rows.length < _this._totalCount) {
                    _this._pageIndex = _this.pagePlus(1);
                    _this.GetAllIndexes();
                }
            }
        });
    };
    IndexesComponent.prototype.GetAllIndexes = function () {
        var _this = this;
        this._isIndexesListFetching = true;
        if (localStorage.getItem('divSucessIndexes') == 'true') {
            this._ShowSuccessmessagediv = true;
            this._ShowSuccessmessage = localStorage.getItem('successmsgindexes');
            this._ShowSuccessmessage = (this._ShowSuccessmessage.replace('\"', '')).replace('\"', '');
            localStorage.setItem('divSucessIndexes', JSON.stringify(false));
            localStorage.setItem('successmsgindexes', JSON.stringify(''));
            //to hide _Showmessagediv after 5 sec
            setTimeout(function () {
                this._ShowSuccessmessagediv = false;
            }.bind(this), 5000);
            setTimeout(function () {
                if (this.flexIndexes) {
                    this.flexIndexes.autoSizeColumns(0, this.flex.columns.length, false, 20);
                    this.flexIndexes.columns[0].width = 350; // for Note Id
                }
            }.bind(this), 1);
        }
        this.indexesService.GetAllIndexesMaster(this._pageIndex, this._pageSize)
            .subscribe(function (res) {
            if (res.Succeeded) {
                if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
                    var data = res.lstIndexesMaster;
                    _this._totalCount = res.TotalCount;
                    if (_this._pageIndex == 1) {
                        _this.lstIndexesData = data;
                        //remove first cell selection
                        _this.flexIndexes.selectionMode = wjcGrid.SelectionMode.None;
                        if (res.TotalCount == 0) {
                            _this._dvEmptyIndexesSearchMsg = true;
                            _this._isIndexesListFetching = false;
                        }
                        else {
                            setTimeout(function () {
                                _this._isIndexesListFetching = false;
                            }, 2000);
                        }
                        setTimeout(function () {
                            _this.ApplyPermissions(res.UserPermissionList);
                        }, 2000);
                    }
                    else {
                        data.forEach(function (obj, i) {
                            //this.flex.rows.push(new wjcGrid.Row(obj));
                        });
                        _this.lstIndexesData = _this.lstIndexesData.concat(data);
                    }
                    _this._isIndexesListFetching = false;
                    setTimeout(function () {
                        this.flex.invalidate();
                        this.flex.autoSizeColumns(0, this.flex.columns.length, false, 20);
                        this.flex.columns[0].width = 150; // for Indexes name Id
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
    IndexesComponent.prototype.ShowSuccessmessageDiv = function (msg) {
        this._ShowSuccessmessagediv = true;
        this._ShowSuccessmessage = msg;
        setTimeout(function () {
            this._ShowSuccessmessagediv = false;
        }.bind(this), 5000);
    };
    IndexesComponent.prototype.ApplyPermissions = function (_object) {
        for (var i = 0; i < _object.length; i++) {
            if (_object[i].ChildModule == 'btnAddIndex') {
                this._isshowIndexesAddbutton = true;
            }
        }
        //var buttonarray = _object.filter(function (item) { return item.ModuleType === 'Control' && item.RightsName === 'Edit'; });
        //if (buttonarray.length > 0 && typeof buttonarray != 'undefined') {
        //    this._isshowIndexesAddbutton = true;
        //}
    };
    IndexesComponent.prototype.AddNewIndexes = function () {
        this._router.navigate(['/indexesdetail', "00000000-0000-0000-0000-000000000000"]);
    };
    __decorate([
        core_1.ViewChild('flexindexes'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], IndexesComponent.prototype, "flexIndexes", void 0);
    IndexesComponent = __decorate([
        core_1.Component({
            selector: "indexes",
            templateUrl: "app/components/indexes.html?v=" + $.getVersion(),
            providers: [indexesService_1.indexesService, notificationService_1.NotificationService]
        }),
        __metadata("design:paramtypes", [router_1.Router,
            indexesService_1.indexesService,
            utilityService_1.UtilityService,
            notificationService_1.NotificationService])
    ], IndexesComponent);
    return IndexesComponent;
}(paginated_1.Paginated));
exports.IndexesComponent = IndexesComponent;
var routes = [
    { path: '', component: IndexesComponent }
];
var IndexesModule = /** @class */ (function () {
    function IndexesModule() {
    }
    IndexesModule = __decorate([
        core_2.NgModule({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_core_1.WjCoreModule, wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule],
            declarations: [IndexesComponent]
        })
    ], IndexesModule);
    return IndexesModule;
}());
exports.IndexesModule = IndexesModule;
//# sourceMappingURL=indexes.component.js.map