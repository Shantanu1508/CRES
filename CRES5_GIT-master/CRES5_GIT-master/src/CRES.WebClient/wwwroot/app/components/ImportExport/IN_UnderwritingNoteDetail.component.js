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
exports.IN_UnderwritingNoteModule = exports.IN_UnderwritingNoteDetailComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var ImportUnderwritingService_1 = require("../../core/services/ImportUnderwritingService");
var IN_UnderwritingNotes_1 = require("../../core/domain/IN_UnderwritingNotes");
var utilityService_1 = require("../../core/services/utilityService");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
//import { WjCoreModule } from 'wijmo/wijmo.angular2.core';
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var IN_UnderwritingNoteDetailComponent = /** @class */ (function () {
    function IN_UnderwritingNoteDetailComponent(_activatedRoute, importUnderwritingService, _router, utilityService) {
        var _this = this;
        this._activatedRoute = _activatedRoute;
        this.importUnderwritingService = importUnderwritingService;
        this._router = _router;
        this.utilityService = utilityService;
        this._in_UnderwritingNotes = new IN_UnderwritingNotes_1.IN_UnderwritingNotes('', '', '');
        this._activatedRoute.params.forEach(function (params) {
            if (params['in_UnNoteid'] !== undefined) {
                _this.IN_UnderwritingNoteID = params['in_UnNoteid'];
            }
        });
        // var IN_UnderwritingNoteID = _routeParams.get('in_UnNoteid');
        this._in_UnderwritingNotes.IN_UnderwritingNoteID = this.IN_UnderwritingNoteID;
        this.lstIN_UnderwritingNotes = JSON.parse(localStorage.getItem('lstIN_UnderwritingNotes'));
        this.GetINUnderwritingRateSpreadScheduleByNoteID();
        for (var i = 0; i < this.lstIN_UnderwritingNotes.length; i++) {
            if (this.lstIN_UnderwritingNotes[i].IN_UnderwritingNoteID == this.IN_UnderwritingNoteID) {
                this.IN_UnderwritingNotesDC = this.lstIN_UnderwritingNotes[i];
                break;
            }
        }
        this.utilityService.setPageTitle("M61-Integration Note");
    }
    IN_UnderwritingNoteDetailComponent.prototype.GetINUnderwritingRateSpreadScheduleByNoteID = function () {
        var _this = this;
        this.importUnderwritingService.GetINUnderwritingRateSpreadScheduleByNoteID(this._in_UnderwritingNotes).subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.lstIN_UnderwritingRateSpreadScheduleDataContractList;
                _this.lstINUnderwritingRateSpreadSchedule = data;
                _this.ConvertToBindableDate(_this.lstINUnderwritingRateSpreadSchedule, "RateSpreadSchedule");
            }
            else {
            }
        });
        this.GetINUnderwritingStrippingScheduleByNoteID();
    };
    IN_UnderwritingNoteDetailComponent.prototype.GetINUnderwritingStrippingScheduleByNoteID = function () {
        var _this = this;
        this.importUnderwritingService.GetINUnderwritingStrippingScheduleByNoteID(this._in_UnderwritingNotes).subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.lstIN_UnderwritingStrippingScheduleDataContractList;
                _this.lstINUnderwritingStrippingSchedule = data;
                _this.ConvertToBindableDate(_this.lstINUnderwritingStrippingSchedule, "StrippingSchedule");
            }
            else {
            }
        });
        this.GetINUnderwritingPIKScheduleByNoteID();
    };
    IN_UnderwritingNoteDetailComponent.prototype.GetINUnderwritingPIKScheduleByNoteID = function () {
        var _this = this;
        this.importUnderwritingService.GetINUnderwritingPIKScheduleByNoteID(this._in_UnderwritingNotes).subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.lstIN_UnderwritingPIKScheduleDataContractList;
                _this.lstINUnderwritingPIKSchedule = data;
                _this.ConvertToBindableDate(_this.lstINUnderwritingPIKSchedule, "PIKSchedule");
            }
            else {
            }
        });
        //this.GetINUnderwritingFundingScheduleByNoteID();
    };
    IN_UnderwritingNoteDetailComponent.prototype.GetINUnderwritingFundingScheduleByNoteID = function () {
        var _this = this;
        this.importUnderwritingService.GetINUnderwritingFundingScheduleByNoteID(this._in_UnderwritingNotes).subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.lstIN_UnderwritingFundingScheduleDataContractList;
                _this.lstIN_UnderwritingFundingSchedule = data;
                _this.ConvertToBindableDate(_this.lstIN_UnderwritingFundingSchedule, "FundingSchedule");
            }
            else {
            }
        });
    };
    IN_UnderwritingNoteDetailComponent.prototype.ConvertToBindableDate = function (Data, grid) {
        if (grid == "RateSpreadSchedule") {
            for (var i = 0; i < Data.length; i++) {
                this.lstINUnderwritingRateSpreadSchedule[i].CreatedDate = new Date(Data[i].CreatedDate);
                this.lstINUnderwritingRateSpreadSchedule[i].UpdatedDate = new Date(Data[i].UpdatedDate);
                this.lstINUnderwritingRateSpreadSchedule[i].Date = new Date(Data[i].Date);
            }
        }
        if (grid == "StrippingSchedule") {
            for (var i = 0; i < Data.length; i++) {
                this.lstINUnderwritingStrippingSchedule[i].CreatedDate = new Date(Data[i].CreatedDate);
                this.lstINUnderwritingStrippingSchedule[i].UpdatedDate = new Date(Data[i].UpdatedDate);
                this.lstINUnderwritingStrippingSchedule[i].StartDate = new Date(Data[i].StartDate);
            }
        }
        if (grid == "PIKSchedule") {
            for (var i = 0; i < Data.length; i++) {
                this.lstINUnderwritingPIKSchedule[i].CreatedDate = new Date(Data[i].CreatedDate);
                this.lstINUnderwritingPIKSchedule[i].UpdatedDate = new Date(Data[i].UpdatedDate);
                this.lstINUnderwritingPIKSchedule[i].StartDate = new Date(Data[i].StartDate);
                this.lstINUnderwritingPIKSchedule[i].EndDate = new Date(Data[i].EndDate);
            }
        }
        if (grid == "FundingSchedule") {
            for (var i = 0; i < Data.length; i++) {
                this.lstIN_UnderwritingFundingSchedule[i].CreatedDate = new Date(Data[i].CreatedDate);
                this.lstIN_UnderwritingFundingSchedule[i].UpdatedDate = new Date(Data[i].UpdatedDate);
                this.lstIN_UnderwritingFundingSchedule[i].Date = new Date(Data[i].Date);
            }
        }
    };
    IN_UnderwritingNoteDetailComponent = __decorate([
        core_1.Component({
            templateUrl: "app/components/ImportExport/IN_UnderwritingNoteDetail.html",
            providers: [ImportUnderwritingService_1.ImportUnderwritingService]
        })
        //@CanActivate((next: ComponentInstruction, previous: ComponentInstruction) => {
        //    return isLoggedIn(next, previous);
        //})
        ,
        __metadata("design:paramtypes", [router_1.ActivatedRoute, ImportUnderwritingService_1.ImportUnderwritingService, router_1.Router, utilityService_1.UtilityService])
    ], IN_UnderwritingNoteDetailComponent);
    return IN_UnderwritingNoteDetailComponent;
}());
exports.IN_UnderwritingNoteDetailComponent = IN_UnderwritingNoteDetailComponent;
var routes = [
    { path: '', component: IN_UnderwritingNoteDetailComponent }
];
var IN_UnderwritingNoteModule = /** @class */ (function () {
    function IN_UnderwritingNoteModule() {
    }
    IN_UnderwritingNoteModule = __decorate([
        core_2.NgModule({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule],
            declarations: [IN_UnderwritingNoteDetailComponent]
        })
    ], IN_UnderwritingNoteModule);
    return IN_UnderwritingNoteModule;
}());
exports.IN_UnderwritingNoteModule = IN_UnderwritingNoteModule;
//# sourceMappingURL=IN_UnderwritingNoteDetail.component.js.map