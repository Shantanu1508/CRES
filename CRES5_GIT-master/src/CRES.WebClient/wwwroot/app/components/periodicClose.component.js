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
exports.PeriodicCloseModule = exports.PeriodicCloseComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var Periodic_1 = require("../core/domain/Periodic");
var PeriodicDataService_1 = require("../core/services/PeriodicDataService");
var paginated_1 = require("../core/common/paginated");
var wjcGrid = require("wijmo/wijmo.grid");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_input_1 = require("wijmo/wijmo.angular2.input");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var ng2_file_input_1 = require("ng2-file-input");
var functionService_1 = require("../core/services/functionService");
var utilityService_1 = require("../core/services/utilityService");
var PeriodicCloseComponent = /** @class */ (function (_super) {
    __extends(PeriodicCloseComponent, _super);
    function PeriodicCloseComponent(activatedRoute, ng2FileInputService, _router, functionServiceSrv, _periodicservice, _utilityService) {
        var _this = _super.call(this, 10, 1, 0) || this;
        _this.activatedRoute = activatedRoute;
        _this.ng2FileInputService = ng2FileInputService;
        _this._router = _router;
        _this.functionServiceSrv = functionServiceSrv;
        _this._periodicservice = _periodicservice;
        _this._utilityService = _utilityService;
        //private _periodicservice: PeriodicDataService;
        _this._Showmessagediv = false;
        _this._ShowmessagedivMsg = '';
        _this._Showmessagenotediv = false;
        _this._showexceptionEmptymessage = false;
        // private _showexceptionEmptydiv: boolean = false;
        _this._isPeriodiccloseSaving = false;
        _this._disabled = true;
        _this._dvEmptySearchMsg = false;
        _this.ScenarioId = window.localStorage.getItem("scenarioid");
        _this.ScenarioName = window.localStorage.getItem("ScenarioName");
        _this._utilityService.setPageTitle("Periodic-Close");
        _this._periodic = new Periodic_1.Periodic();
        _this.getAllPeriodicClose();
        return _this;
    }
    // Component views are initialized
    PeriodicCloseComponent.prototype.ngAfterViewInit = function () {
        //stop input (number type) control 'Scroll Wheel' feature
        setTimeout(function () {
            $('input[type=number]').each(function () {
                var el = document.getElementById(($(this).attr("id")));
                if (el) {
                    el.addEventListener('wheel', function (e) {
                        e.preventDefault(); // prevent event
                        e.stopImmediatePropagation(); // stop propogation
                    }, true);
                }
            });
            $(".ibox1").each(function () {
                var el = document.getElementById(($(this).attr("id")));
                if (el) {
                    el.addEventListener('wheel', function (e) {
                        e.preventDefault(); // prevent event
                        e.stopImmediatePropagation(); // stop propogation
                    }, true);
                }
            });
        }.bind(this), 3000);
    };
    PeriodicCloseComponent.prototype.SavePeriodicClose = function () {
        this.ScenarioId = window.localStorage.getItem("scenarioid");
        this.ScenarioName = window.localStorage.getItem("ScenarioName");
        this._periodic.AnalysisID = this.ScenarioId;
        if (this.isValidate()) {
            //Confirm msg box
            var customdialogbox = document.getElementById('customdialogbox');
            this._ConfirmMsgText = 'Are you sure you want to close the period for the date entered?';
            customdialogbox.style.display = "block";
            $.getScript("/js/jsDrag.js");
        }
        else {
            this._isPeriodiccloseSaving = false;
            this.CustomDialogteSave();
        }
    };
    PeriodicCloseComponent.prototype.SavePeriodicCloseFunc = function () {
        var _this = this;
        this.ClosePopUpConfirmBox();
        this._periodic.StartDate = this._utilityService.convertDatetoGMT(this._startDate);
        this._periodic.EndDate = this._utilityService.convertDatetoGMT(this._endDate);
        this._isPeriodiccloseSaving = true;
        this._disabled = false;
        this._periodicservice.savePeriodicClose(this._periodic).subscribe(function (res) {
            if (res.Succeeded) {
                _this._startDate = null;
                _this._endDate = null;
                _this.getAllPeriodicClose();
                _this._Showmessagediv = true;
                _this._ShowmessagedivMsg = "Periodic Close added successfully";
                setTimeout(function () {
                    this._Showmessagediv = false;
                    this._isPeriodiccloseSaving = false;
                    this._disabled = true;
                }.bind(_this), 2000);
            }
        });
    };
    PeriodicCloseComponent.prototype.isValidate = function () {
        var ret_value = true;
        this.savedialogmsg = "";
        if (!this._startDate || !this._endDate) {
            this.savedialogmsg = "Please select date range.";
            return false;
        }
        if (this._startDate > this._endDate) {
            this.savedialogmsg = "End date can not be smaller than start date.";
            return false;
        }
        if (this._startDate.getTime() == this._endDate.getTime()) {
            this.savedialogmsg = "Start date and end date can not be equal.";
            return false;
        }
        var firstDayOfmonth = new Date(this._startDate.getFullYear(), this._startDate.getMonth(), 1);
        if (this._startDate.getTime() != new Date(firstDayOfmonth).getTime()) {
            this.savedialogmsg = "Start date should be the first day of month.";
            return false;
        }
        var lastDayOfmonth = new Date(this._endDate.getFullYear(), this._endDate.getMonth() + 1, 0);
        if (this._endDate.getTime() != new Date(lastDayOfmonth).getTime()) {
            this.savedialogmsg = "End date should be last day of month.";
            return false;
        }
        var lastDayOfmonthFromStartDate = new Date(this._startDate.getFullYear(), this._startDate.getMonth() + 1, 0);
        if (this._endDate.getTime() != new Date(lastDayOfmonthFromStartDate).getTime()) {
            this.savedialogmsg = "Start and end date should belong to the same month. Like, Jan 1, 2019 to Jan 31, 2019.";
            return false;
        }
        if (this.lstPeriodicClose) {
            var maxEndDate;
            var minStartDate;
            maxEndDate = this.lstPeriodicClose[0].MaxEndDate;
            minStartDate = this.lstPeriodicClose[this.lstPeriodicClose.length - 1].StartDate;
            if (this._startDate.getTime() < new Date(minStartDate).getTime()) {
                this.savedialogmsg = "Start date should not be less than the start date of first close.";
                return false;
            }
            if (this._startDate.getTime() == new Date(maxEndDate).getTime()) {
                this.savedialogmsg = "Start date can not be equal to last close date.";
                return false;
            }
            if (this._startDate >= new Date(maxEndDate)) {
                if (this._startDate.getTime() == new Date(new Date(maxEndDate).setDate(new Date(maxEndDate).getDate() + 1)).getTime()) {
                    return true;
                }
                else {
                    this.savedialogmsg = "Start date should be the next date of the last close date.";
                    return false;
                }
            }
            var isStartDatePeriodexist = false;
            for (var i = 0; i < this.lstPeriodicClose.length; i++) {
                if (this._startDate.getTime() == new Date(this.lstPeriodicClose[i].StartDate).getTime()) {
                    isStartDatePeriodexist = true;
                    break;
                }
            }
            if (isStartDatePeriodexist) {
                this.savedialogmsg = "Period for this date already exist. Please enter different date.";
                return false;
            }
        }
        //if (this._startDate < new Date(maxEndDate)) {
        //    var isStartDateExist = false;
        //    for (var i = 0; i < this.lstPeriodicClose.length; i++) {
        //        if (this._startDate.getTime() == new Date(this.lstPeriodicClose[i].StartDate).getTime()) {
        //            isStartDateExist = true;
        //            break;
        //        }
        //    }
        //    if (isStartDateExist == false) {
        //        this.savedialogmsg = "Please add a new start date or enter any existing start date.";
        //        return false;
        //    }
        //    var isEndDateExist = false;
        //    for (var i = 0; i < this.lstPeriodicClose.length; i++) {
        //        if (this._endDate.getTime() == new Date(this.lstPeriodicClose[i].EndDate).getTime()) {
        //            isEndDateExist = true;
        //            break;
        //        }
        //    }
        //    if (isEndDateExist == false) {
        //        this.savedialogmsg = "Please add a new end date or enter any existing end date.";
        //        return false;
        //    }
        //}
        return ret_value;
    };
    PeriodicCloseComponent.prototype.getAllPeriodicClose = function () {
        var _this = this;
        this._isGridShow = false;
        this._isPeriodiccloseSaving = true;
        this.ScenarioId = window.localStorage.getItem("scenarioid");
        this.ScenarioName = window.localStorage.getItem("ScenarioName");
        this._periodic.AnalysisID = this.ScenarioId;
        this._periodicservice.getPeriodicCloseByUserID(this._periodic).subscribe(function (res) {
            if (res.Succeeded) {
                if (res.TotalCount == 0) {
                    _this.lstPeriodicClose = null;
                    _this._dvEmptySearchMsg = false;
                    _this._isPeriodiccloseSaving = false;
                    setTimeout(function () {
                        _this._dvEmptySearchMsg = false;
                    }, 2000);
                }
                else {
                    _this._isGridShow = true;
                    _this.lstPeriodicClose = res.lstPeriodicClose;
                    _this.lstselectedPeriod = res.lstPeriodicClose;
                    _this.lstselectedPeriod = _this.lstPeriodicClose.filter(function (x) { return x.PeriodAutoID == 0; });
                    _this.ConvertToBindableDate(_this.lstPeriodicClose);
                    setTimeout(function () {
                        _this._isPeriodiccloseSaving = false;
                    }, 2000);
                }
            }
        });
        (function (error) {
            _this._isPeriodiccloseSaving = false;
            console.error('Error: ' + error);
        });
    };
    PeriodicCloseComponent.prototype.ConvertToBindableDate = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this.lstPeriodicClose[i].StartDate != null)
                this.lstPeriodicClose[i].StartDate = this.convertDateToBindable(this.lstPeriodicClose[i].StartDate);
            if (this.lstPeriodicClose[i].EndDate != null)
                this.lstPeriodicClose[i].EndDate = this.convertDateToBindable(this.lstPeriodicClose[i].EndDate);
            if (this.lstPeriodicClose[i].CreatedDate != null)
                this.lstPeriodicClose[i].CreatedDate = this.convertDateToBindableWithTime(this.lstPeriodicClose[i].CreatedDate);
        }
    };
    PeriodicCloseComponent.prototype.convertDateToBindable = function (date) {
        var dateObj = new Date(date);
        return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear();
    };
    PeriodicCloseComponent.prototype.convertDateToBindableWithTime = function (date) {
        var dateObj = new Date(date);
        return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear() + " " + dateObj.getHours() + ":" + dateObj.getMinutes() + ":" + dateObj.getSeconds();
    };
    PeriodicCloseComponent.prototype.getTwoDigitString = function (number) {
        if (number.toString().length === 1)
            return "0" + number;
        return number;
    };
    PeriodicCloseComponent.prototype.CustomDialogteSave = function () {
        var winW = window.innerWidth;
        var winH = window.innerHeight;
        var dialogbox = document.getElementById('Genericdialogbox');
        document.getElementById('savedialogmessage').innerHTML = this.savedialogmsg;
        dialogbox.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    PeriodicCloseComponent.prototype.ClosePopUpDialog = function () {
        var modal = document.getElementById('Genericdialogbox');
        modal.style.display = "none";
    };
    PeriodicCloseComponent.prototype.Savedialogbox = function () {
        this.ClosePopUpDialog();
    };
    PeriodicCloseComponent.prototype.ClosePopUpConfirmBox = function () {
        var modal = document.getElementById('customdialogbox');
        modal.style.display = "none";
    };
    PeriodicCloseComponent.prototype.ClosePopUpopenperiod = function () {
        var modal = document.getElementById('customdialogboxopenperiod');
        modal.style.display = "none";
    };
    PeriodicCloseComponent.prototype.OpenPeriodicCloseConfirm = function () {
        if (this.lstselectedPeriod.length > 0) {
            var customdialogbox = document.getElementById('customdialogboxopenperiod');
            this._ConfirmMsgText = 'Are you sure you want to open the period for the selected date(s)?';
            customdialogbox.style.display = "block";
            $.getScript("/js/jsDrag.js");
        }
        else {
            this.savedialogmsg = "Please open at least one period.";
            this.CustomDialogteSave();
        }
    };
    //Confirm msg box
    PeriodicCloseComponent.prototype.OpenPeriodicClose = function () {
        var _this = this;
        this.ClosePopUpopenperiod();
        if (this.lstselectedPeriod.length > 0) {
            this._isPeriodiccloseSaving = true;
            var PeriodIDs = '';
            for (var i = 0; i < this.lstselectedPeriod.length; i++) {
                PeriodIDs = PeriodIDs + ',' + this.lstselectedPeriod[i].PeriodID;
            }
            this._periodic.PeriodIDs = PeriodIDs.slice(1, PeriodIDs.length);
            this._periodic.AnalysisID = this.ScenarioId;
            this._periodicservice.openPeriodicClose(this._periodic).subscribe(function (res) {
                if (res.Succeeded) {
                    _this._startDate = null;
                    _this._endDate = null;
                    _this.getAllPeriodicClose();
                    _this._Showmessagediv = true;
                    _this._ShowmessagedivMsg = "Period opened successfully.";
                    setTimeout(function () {
                        this._Showmessagediv = false;
                        this._isPeriodiccloseSaving = false;
                        this._disabled = true;
                    }.bind(_this), 2000);
                }
                else {
                    _this._isPeriodiccloseSaving = false;
                }
            });
            (function (error) {
                console.error('Error: ' + error);
            });
        }
        else {
            this.savedialogmsg = "Please open atleast one period";
            this.CustomDialogteSave();
        }
    };
    PeriodicCloseComponent.prototype.ChangeOpenPeriodicClose = function (id, chkvalue, rowindex) {
        var currselected = this.lstPeriodicClose.filter(function (x) { return x.PeriodAutoID == id; });
        var isValid = true;
        ;
        if (chkvalue == true) {
            this.lstPeriodicClose[rowindex].IsOpenPeriod = true;
            var period = this.lstPeriodicClose.filter(function (x) { return (new Date(x.EndDate) > new Date(currselected[0].EndDate) && x.PeriodAutoID != id); });
            this.lstselectedPeriod.forEach(function (e) {
                period = period.filter(function (x) { return x.PeriodAutoID != e.PeriodAutoID; });
            });
            //var selected = this.lstselectedPeriod.filter(x => x.PeriodAutoID == id);
            if (period.length > 0) {
                this.savedialogmsg = "You can not open the period on a prior date without opening all period(s) of later date.";
                this.CustomDialogteSave();
                this.lstPeriodicClose[rowindex].IsOpenPeriod = false;
            }
            else {
                this.lstselectedPeriod = this.lstselectedPeriod.concat(this.lstPeriodicClose.filter(function (x) { return x.PeriodAutoID == id; }));
            }
        }
        else {
            var period = this.lstPeriodicClose.filter(function (x) { return (new Date(x.EndDate) < new Date(currselected[0].EndDate) && x.PeriodAutoID != id && x.IsOpenPeriod == true); });
            if (period.length > 0) {
                this.savedialogmsg = "You can not open the period on a later date without opening all period(s) of prior date.";
                this.CustomDialogteSave();
                this.lstPeriodicClose[rowindex].IsOpenPeriod = true;
            }
            else {
                this.lstPeriodicClose[rowindex].IsOpenPeriod = false;
                this.lstselectedPeriod = this.lstselectedPeriod.filter(function (x) { return x.PeriodAutoID != id; });
            }
        }
        console.log(this.lstselectedPeriod);
        setTimeout(function () {
            this.flexperiodicclose.invalidate();
        }.bind(this), 1000);
    };
    __decorate([
        core_1.ViewChild('flexperiodicclose'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], PeriodicCloseComponent.prototype, "flexperiodicclose", void 0);
    PeriodicCloseComponent = __decorate([
        core_1.Component({
            selector: "PeriodicClose",
            templateUrl: "app/components/PeriodicClose.html?v=" + $.getVersion(),
            providers: [PeriodicDataService_1.PeriodicDataService, Periodic_1.Periodic, functionService_1.functionService] //NoteService, dealService, UtilityService, MembershipService, FileUploadService, functionService]
        }),
        __metadata("design:paramtypes", [router_1.ActivatedRoute,
            ng2_file_input_1.Ng2FileInputService,
            router_1.Router,
            functionService_1.functionService,
            PeriodicDataService_1.PeriodicDataService, utilityService_1.UtilityService])
    ], PeriodicCloseComponent);
    return PeriodicCloseComponent;
}(paginated_1.Paginated));
exports.PeriodicCloseComponent = PeriodicCloseComponent;
var routes = [
    { path: '', component: PeriodicCloseComponent }
];
var PeriodicCloseModule = /** @class */ (function () {
    function PeriodicCloseModule() {
    }
    PeriodicCloseModule = __decorate([
        core_2.NgModule({
            // imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjInputModule, WjGridFilterModule],
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes), wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_input_1.WjInputModule, wijmo_angular2_grid_filter_1.WjGridFilterModule, ng2_file_input_1.Ng2FileInputModule.forRoot()],
            declarations: [PeriodicCloseComponent]
        })
    ], PeriodicCloseModule);
    return PeriodicCloseModule;
}());
exports.PeriodicCloseModule = PeriodicCloseModule;
//# sourceMappingURL=periodicClose.component.js.map