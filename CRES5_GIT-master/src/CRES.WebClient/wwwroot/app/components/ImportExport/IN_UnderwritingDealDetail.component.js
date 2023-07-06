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
exports.IN_UnderwritingDealModule = exports.IN_UnderwritingDealDetailComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var ImportUnderwritingService_1 = require("../../core/services/ImportUnderwritingService");
var utilityService_1 = require("../../core/services/utilityService");
var backshopImport_1 = require("../../core/domain/backshopImport");
var IN_UnderwritingDeal_1 = require("../../core/domain/IN_UnderwritingDeal");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wjcGrid = require("wijmo/wijmo.grid");
//import { WjCoreModule } from 'wijmo/wijmo.angular2.core';
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var IN_UnderwritingDealDetailComponent = /** @class */ (function () {
    function IN_UnderwritingDealDetailComponent(importUnderwritingService, _router, utilityService) {
        this.importUnderwritingService = importUnderwritingService;
        this._router = _router;
        this.utilityService = utilityService;
        this.isProcessComplete = true;
        this.allowImport = false;
        this._formatting = true;
        this._backshopImport = new backshopImport_1.backshopImport('', '');
        this._backshopImport = JSON.parse(localStorage.getItem('backshopImport'));
        this.IN_UnderwritingDealData = new IN_UnderwritingDeal_1.IN_UnderwritingDeal("");
        this.isProcessComplete = true;
        this.GetINUnderwritingDealDataByDealId();
        this.utilityService.setPageTitle("M61-Integration Deal");
    }
    IN_UnderwritingDealDetailComponent.prototype.GetINUnderwritingDealDataByDealId = function () {
        var _this = this;
        var _userData = JSON.parse(localStorage.getItem('user'));
        this._backshopImport.UserName = _userData.UserID;
        this.importUnderwritingService.GetINUnderwritingDealDataByDealId(this._backshopImport).subscribe(function (res) {
            if (res.Succeeded) {
                _this.IN_UnderwritingDealData = res.IN_UnderwritingDeal;
                //alert(JSON.stringify(this.IN_UnderwritingDealData));
                _this.GetInUnderwritingNotesByDealID();
            }
            else {
            }
        });
    };
    IN_UnderwritingDealDetailComponent.prototype.GetInUnderwritingNotesByDealID = function () {
        var _this = this;
        var _userData = JSON.parse(localStorage.getItem('user'));
        this._backshopImport.UserName = _userData.UserID;
        this.importUnderwritingService.GetInUnderwritingNotesByDealID(this._backshopImport).subscribe(function (res) {
            if (res.Succeeded) {
                _this.isProcessComplete = false;
                var data = res.lstIN_UnderwritingNotes;
                _this.lstIN_UnderwritingNotes = data;
                _this.ConvertToBindableDate(_this.lstIN_UnderwritingNotes);
                localStorage.setItem('lstIN_UnderwritingNotes', JSON.stringify(_this.lstIN_UnderwritingNotes));
                //remove first cell selection
                _this.flex.selectionMode = wjcGrid.SelectionMode.None;
                setTimeout(function () {
                    this.flex.autoSizeColumns(0, this.flex.columns.length, false, 20);
                    this.flex.columns[0].width = 200; // for Note Id
                }.bind(_this), 1);
            }
            else {
            }
        });
    };
    IN_UnderwritingDealDetailComponent.prototype.ImportLandingtableToMainDB = function () {
        var _this = this;
        this.isProcessComplete = true;
        var _userData = JSON.parse(localStorage.getItem('user'));
        this._backshopImport.UserName = _userData.UserID;
        var lstcheckDuplicateNote = this.lstIN_UnderwritingNotes.filter(function (x) { return x.NoteExistsInDiffDeal > 0; });
        var msg = '';
        if (lstcheckDuplicateNote != null) {
            if (lstcheckDuplicateNote.length > 0) {
                for (var i = 0; i < lstcheckDuplicateNote.length; i++) {
                    msg = msg + 'Note id <b>' + lstcheckDuplicateNote[i].ClientNoteID + '</b> is already exists in deal  <b> <a target="_blank" href="/#/dealdetail/' + lstcheckDuplicateNote[i].NoteExistsInDiffDealName + '">' + lstcheckDuplicateNote[i].NoteExistsInDiffDealName + '</a></b></br>';
                }
                this.allowImport = false;
            }
            else {
                this.allowImport = true;
            }
        }
        else {
            this.allowImport = true;
        }
        if (this.allowImport) {
            this.importUnderwritingService.ImportLandingtableToMainDB(this._backshopImport).subscribe(function (res) {
                if (res.Succeeded) {
                    _this.isProcessComplete = false;
                    _this.CustomAlert("Data imported successfully.");
                }
                else {
                    //this.CustomAlert("Deal '" + this._backshopImport.DealName + "' not found.");
                    //this._router.navigate(['/ImportUnderwriting']);
                }
            });
        }
        else {
            this.isProcessComplete = false;
            this.CustomAlert(msg);
        }
    };
    IN_UnderwritingDealDetailComponent.prototype.DeleteINUnderwritingDealDataByDealID = function () {
        var _this = this;
        this.isProcessComplete = true;
        var _userData = JSON.parse(localStorage.getItem('user'));
        this._backshopImport.UserName = _userData.UserID;
        if (confirm("Do you want to discard this import?") == true) {
            this.importUnderwritingService.DeleteINUnderwritingDealDataByDealID(this._backshopImport).subscribe(function (res) {
                if (res.Succeeded) {
                    //alert("Data imported successfully.");
                    _this.isProcessComplete = false;
                    _this._router.navigate(['/ImportUnderwriting']);
                    // this._router.navigate([this.routes.importUnderwriting.name]);
                }
                else {
                    //alert("Deal '" + this._backshopImport.DealName + "' not found.");
                    //this._router.navigate([this.routes.iN_UnderwritingDealDetail.name]);
                }
            });
        }
        else {
            this.isProcessComplete = false;
        }
    };
    Object.defineProperty(IN_UnderwritingDealDetailComponent.prototype, "formatting", {
        get: function () {
            return this._formatting;
        },
        set: function (value) {
            if (this._formatting != value) {
                this._formatting = value;
                this._updateFormatting();
            }
        },
        enumerable: false,
        configurable: true
    });
    IN_UnderwritingDealDetailComponent.prototype.CustomAlert = function (dialog) {
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
    };
    IN_UnderwritingDealDetailComponent.prototype.ok = function () {
        this._router.navigate(['/dashboard']);
        document.getElementById('dialogbox').style.display = "none";
        document.getElementById('dialogoverlay').style.display = "none";
    };
    IN_UnderwritingDealDetailComponent.prototype._updateFormatting = function () {
        var flex = this.flex;
        if (flex) {
            var fmt = this.formatting;
            this._setColumnFormat('ClosingDate', fmt ? 'MMM dd yy' : null);
            this._setColumnFormat('FirstPaymentDate', fmt ? 'MMM dd yy' : null);
            this._setColumnFormat('SelectedMaturityDate', fmt ? 'MMM dd yy' : null);
            this._setColumnFormat('ExpectedMaturityDate', fmt ? 'MMM dd yy' : null);
            this._setColumnFormat('ExtendedMaturityScenario1', fmt ? 'MMM dd yy' : null);
            this._setColumnFormat('ExtendedMaturityScenario2', fmt ? 'MMM dd yy' : null);
            this._setColumnFormat('ExtendedMaturityScenario3', fmt ? 'MMM dd yy' : null);
            this._setColumnFormat('InitialMaturityDate', fmt ? 'MMM dd yy' : null);
        }
    };
    IN_UnderwritingDealDetailComponent.prototype._setColumnFormat = function (name, format) {
        var col = this.flex.columns.getColumn(name);
        if (col) {
            col.format = format;
        }
    };
    IN_UnderwritingDealDetailComponent.prototype.ConvertToBindableDate = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this.lstIN_UnderwritingNotes[i].ClosingDate != null)
                this.lstIN_UnderwritingNotes[i].ClosingDate = new Date(Data[i].ClosingDate);
            if (this.lstIN_UnderwritingNotes[i].FirstPaymentDate != null)
                this.lstIN_UnderwritingNotes[i].FirstPaymentDate = new Date(Data[i].FirstPaymentDate);
            if (this.lstIN_UnderwritingNotes[i].SelectedMaturityDate != null)
                this.lstIN_UnderwritingNotes[i].SelectedMaturityDate = new Date(Data[i].SelectedMaturityDate);
            if (this.lstIN_UnderwritingNotes[i].ExpectedMaturityDate != null)
                this.lstIN_UnderwritingNotes[i].ExpectedMaturityDate = new Date(Data[i].ExpectedMaturityDate);
            if (this.lstIN_UnderwritingNotes[i].ExtendedMaturityScenario1 != null)
                this.lstIN_UnderwritingNotes[i].ExtendedMaturityScenario1 = new Date(Data[i].ExtendedMaturityScenario1);
            if (this.lstIN_UnderwritingNotes[i].ExtendedMaturityScenario2 != null)
                this.lstIN_UnderwritingNotes[i].ExtendedMaturityScenario2 = new Date(Data[i].ExtendedMaturityScenario2);
            if (this.lstIN_UnderwritingNotes[i].ExtendedMaturityScenario3 != null)
                this.lstIN_UnderwritingNotes[i].ExtendedMaturityScenario3 = new Date(Data[i].ExtendedMaturityScenario3);
            if (this.lstIN_UnderwritingNotes[i].InitialMaturityDate != null)
                this.lstIN_UnderwritingNotes[i].InitialMaturityDate = new Date(Data[i].InitialMaturityDate);
        }
    };
    __decorate([
        core_1.ViewChild('flex'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], IN_UnderwritingDealDetailComponent.prototype, "flex", void 0);
    IN_UnderwritingDealDetailComponent = __decorate([
        core_1.Component({
            //  selector: "IN_UnderwritingDealDetail",
            templateUrl: "app/components/ImportExport/IN_UnderwritingDealDetail.html",
            providers: [ImportUnderwritingService_1.ImportUnderwritingService],
        }),
        __metadata("design:paramtypes", [ImportUnderwritingService_1.ImportUnderwritingService, router_1.Router, utilityService_1.UtilityService])
    ], IN_UnderwritingDealDetailComponent);
    return IN_UnderwritingDealDetailComponent;
}());
exports.IN_UnderwritingDealDetailComponent = IN_UnderwritingDealDetailComponent;
var routes = [
    { path: '', component: IN_UnderwritingDealDetailComponent }
];
var IN_UnderwritingDealModule = /** @class */ (function () {
    function IN_UnderwritingDealModule() {
    }
    IN_UnderwritingDealModule = __decorate([
        core_2.NgModule({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_grid_filter_1.WjGridFilterModule],
            declarations: [IN_UnderwritingDealDetailComponent]
        })
    ], IN_UnderwritingDealModule);
    return IN_UnderwritingDealModule;
}());
exports.IN_UnderwritingDealModule = IN_UnderwritingDealModule;
//# sourceMappingURL=IN_UnderwritingDealDetail.component.js.map