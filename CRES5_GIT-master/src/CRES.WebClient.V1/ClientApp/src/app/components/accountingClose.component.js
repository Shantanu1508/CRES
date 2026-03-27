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
exports.AccountingCloseModule = exports.accountingCloseComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var Periodic_1 = require("../core/domain/Periodic");
var accoutingDataService_1 = require("../core/services/accoutingDataService");
var portfolioService_1 = require("../core/services/portfolioService");
var wjcGrid = require("wijmo/wijmo.grid");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var wijmo_angular2_grid_1 = require("wijmo/wijmo.angular2.grid");
var wijmo_angular2_input_1 = require("wijmo/wijmo.angular2.input");
var wijmo_angular2_grid_filter_1 = require("wijmo/wijmo.angular2.grid.filter");
var wjNg2GridFilter = require("wijmo/wijmo.angular2.grid.filter");
var dealservice_1 = require("../core/services/dealservice");
var functionService_1 = require("../core/services/functionService");
var utilityService_1 = require("../core/services/utilityService");
var accountingCloseComponent = /** @class */ (function () {
    function accountingCloseComponent(_accountingservice, _utilityService, _portfolioService, dealSrv) {
        this._accountingservice = _accountingservice;
        this._utilityService = _utilityService;
        this._portfolioService = _portfolioService;
        this.dealSrv = dealSrv;
        this._Showmessagediv = false;
        this._ShowmessagedivMsg = '';
        this._Showmessagenotediv = false;
        this._isaccountingcloseSaving = false;
        this._disabled = true;
        this.lstaccountingClose = new Array();
        this._chkSelectAll = false;
        this._utilityService.setPageTitle("Accounting-Close");
        this.getAllPortfolio();
        this.getAllAccountingClose();
    }
    accountingCloseComponent.prototype.getAllAccountingClose = function () {
        var _this = this;
        this._isaccountingcloseSaving = true;
        this._accountingservice.getallaccountingclose(this.PortfolioMasterGuid).subscribe(function (res) {
            if (res.Succeeded) {
                _this.lstaccountingClose = res.dt;
                for (var i = 0; i < _this.lstaccountingClose.length; i++) {
                    _this.lstaccountingClose[i].Active = false;
                }
                _this.ConvertToBindableDate();
                setTimeout(function () {
                    if (_this.flexaccountingclose) {
                        _this.flexaccountingclose.columnHeaders.rows[0].height = 25;
                        //this.flexaccountingclose.autoSizeColumns();
                        _this.flexaccountingclose.invalidate();
                    }
                    _this._isaccountingcloseSaving = false;
                    _this.gridFilter.getColumnFilter('DealName').valueFilter.maxValues = 1000;
                }, 2000);
            }
        });
        (function (error) {
            _this._isaccountingcloseSaving = false;
            console.error('Error: ' + error);
        });
    };
    accountingCloseComponent.prototype.SelectAll = function () {
        this._chkSelectAll = !this._chkSelectAll;
        for (var i = 0; i < this.flexaccountingclose.rows.length; i++) {
            this.flexaccountingclose.rows[i]._data.Active = this._chkSelectAll;
        }
        this.flexaccountingclose.invalidate();
    };
    accountingCloseComponent.prototype.CheckAndValidateBeforeCloseAndOpen = function (buttonclicktype) {
        var maxclosedate = new Date('1970-01-01Z00:00:00:000');
        ;
        var lstaccounting = this.lstaccountingClose.filter(function (x) { return x.Active == true; });
        var dealname = "";
        this.savedialogmsg = '';
        var accoutinglistforvalidation = this.lstaccountingClose.filter(function (x) { return x.LastAccountingCloseDate != null; });
        if (lstaccounting.length == 0 || !this._closeDate) {
            if (lstaccounting.length == 0) {
                this.savedialogmsg = "<p>" + "Please choose Deal(s) to " + buttonclicktype + ".</p>";
            }
            if (buttonclicktype == "close") {
                if (!this._closeDate) {
                    this.savedialogmsg += "<p> Close Date can not be blank.</p>";
                }
            }
            else if (buttonclicktype == "open") {
                if (!this._openDate) {
                    this.savedialogmsg += "<p> Open Date can not be blank.</p>";
                }
            }
        }
        for (var k = 0; k < accoutinglistforvalidation.length; k++) {
            var currentdate = new Date(accoutinglistforvalidation[k].LastAccountingCloseDate);
            if (currentdate > maxclosedate) {
                maxclosedate = currentdate;
            }
        }
        if (buttonclicktype == "close") {
            if (this._closeDate != null) {
                var newclosedate = new Date(this._closeDate);
                var todaydate = new Date();
                var LastMonthEndDate = new Date(todaydate.getFullYear(), todaydate.getMonth(), 0);
                if (this.CheckDateisLastDayoftheMonth(newclosedate) == false) {
                    this.savedialogmsg += "<p> Close period date " + this.convertDateToBindable(newclosedate) + " should be the end of the month.</p>";
                }
                if (newclosedate > LastMonthEndDate) {
                    this.savedialogmsg += "<p> Close period date " + this.convertDateToBindable(newclosedate) + " cannot be greater than end of the last month " + this.convertDateToBindable(LastMonthEndDate) + ".</p>";
                }
            }
        }
        else if (buttonclicktype == "open") {
            if (this._openDate != null) {
                var newopendate = new Date(this._openDate);
                if (this.CheckDateisLastDayoftheMonth(newopendate) == false) {
                    this.savedialogmsg += "<p> Open period date " + this.convertDateToBindable(newopendate) + " should be the end of the month.</p>";
                }
            }
        }
        for (var i = 0; i < lstaccounting.length; i++) {
            if (lstaccounting[i].isDataExists == 0) {
                dealname += lstaccounting[i].DealName + ", ";
            }
            if (buttonclicktype == "close") {
                if (this._closeDate != null) {
                    var ClosingDateMonthend = this.GetLastDayOftheMonth(lstaccounting[i].ClosingDate);
                    var MaturityMonthend = this.GetLastDayOftheMonth(lstaccounting[i].Maturity);
                    var currentCloseDate = new Date(this._closeDate);
                    if (currentCloseDate < ClosingDateMonthend || currentCloseDate > MaturityMonthend) {
                        this.savedialogmsg += "<p> Close period date " + this.convertDateToBindable(this._closeDate) + " for deal " + lstaccounting[i].DealName + " should be between " + this.convertDateToBindable(ClosingDateMonthend) + " and " + this.convertDateToBindable(MaturityMonthend) + ".</p>";
                    }
                    if (currentCloseDate.toDateString() == (new Date(lstaccounting[i].LastAccountingCloseDate)).toDateString()) {
                        //Close Period date should not be equal to last close .
                        this.savedialogmsg += "<p> Close period date " + this.convertDateToBindable(this._closeDate) + " for deal " + lstaccounting[i].DealName + "is already opened" + ".</p>";
                    }
                }
            }
            else if (buttonclicktype == "open") {
                if (this._openDate != null) {
                    var currentOpenDate = new Date(this._openDate);
                    var ClosingDateMonthend = this.GetLastDayOftheMonth(lstaccounting[i].ClosingDate);
                    var MaturityMonthend = this.GetLastDayOftheMonth(lstaccounting[i].Maturity);
                    //open date should be between close and maturity
                    if (currentOpenDate < ClosingDateMonthend || currentOpenDate > MaturityMonthend) {
                        this.savedialogmsg += "<p> Open period date " + this.convertDateToBindable(this._openDate) + " for deal " + lstaccounting[i].DealName + " should be between " + this.convertDateToBindable(ClosingDateMonthend) + " and " + this.convertDateToBindable(MaturityMonthend) + ".</p>";
                    }
                    if (currentOpenDate > new Date(lstaccounting[i].LastAccountingCloseDate)) {
                        //Open Period date cannot be greater than last accounting close date.
                        this.savedialogmsg += "<p> Open period date " + this.convertDateToBindable(this._openDate) + " for deal " + lstaccounting[i].DealName + " cannot be greater than last accounting close date " + this.convertDateToBindable(lstaccounting[i].LastAccountingCloseDate) + ".</p>";
                    }
                    //if (currentOpenDate.toDateString() == new Date(lstaccounting[i].)) {
                    //    //Open Period date should not be equal to .
                    //    this.savedialogmsg += "<p> Open period date " + this.convertDateToBindable(this._openDate) + " for deal " + lstaccounting[i].DealName + "is already opened"+ ".</p>";
                    //}
                }
            }
        }
        if (dealname != "") {
            this.savedialogmsg += "<p>" + "Deal(s) " + dealname.slice(0, dealname.length - 2) + "  is not prepared for accounting close as there is no cashflow, please re-calculate this deal(s)." + "</p>";
        }
        if (this.savedialogmsg == "") {
            if (buttonclicktype == "close") {
                this.ShowAccoutingCloseDialog();
            }
            else if (buttonclicktype == "open") {
                this.ShowAccoutingOpenDialog();
            }
        }
        else {
            this.CustomDialogteSave();
        }
    };
    accountingCloseComponent.prototype.CheckDateisLastDayoftheMonth = function (date) {
        var d1 = new Date(date);
        d1.setDate(d1.getDate() + 1);
        if (d1.getDate() === 1) {
            //'Date is the last day of the month.';
            return true;
        }
        else {
            //'Date is not the last day of the month.';
            return false;
        }
    };
    accountingCloseComponent.prototype.GetLastDayOftheMonth = function (date) {
        date = new Date(date);
        var lastDate = new Date(date.getFullYear(), date.getMonth() + 1, 0);
        return lastDate;
    };
    accountingCloseComponent.prototype.SaveAccountingClose = function () {
        var _this = this;
        this.ClosePopUpConfirmBox();
        this._isaccountingcloseSaving = true;
        var lstaccounting = this.lstaccountingClose.filter(function (x) { return x.Active == true; });
        this.savedialogmsg = '';
        var closeDate = this.convertDateToBindable(this._closeDate);
        for (var i = 0; i < lstaccounting.length; i++) {
            lstaccounting[i]["closeDate"] = closeDate;
        }
        this._accountingservice.saveaccountingClose(lstaccounting).subscribe(function (res) {
            if (res.Succeeded) {
                _this._ShowmessagedivMsg = "Selected deals has been closed for the period " + _this.convertDateToBindable(_this._closeDate) + ".";
                _this._closeDate = null;
                _this._openDate = null;
                _this.getAllAccountingClose();
                _this._isaccountingcloseSaving = false;
                _this._Showmessagediv = true;
                setTimeout(function () {
                    this._Showmessagediv = false;
                    this._isaccountingcloseSaving = false;
                    this._disabled = true;
                }.bind(_this), 2000);
            }
        });
    };
    accountingCloseComponent.prototype.CustomDialogteSave = function () {
        var dialogbox = document.getElementById('Genericdialogbox');
        document.getElementById('savedialogmessage').innerHTML = this.savedialogmsg;
        dialogbox.style.top = "100px";
        dialogbox.style.display = "block";
        $.getScript("/js/jsDrag.js");
    };
    accountingCloseComponent.prototype.ClosePopUpDialog = function () {
        var modal = document.getElementById('Genericdialogbox');
        modal.style.display = "none";
    };
    accountingCloseComponent.prototype.ShowAccoutingCloseDialog = function () {
        this._ConfirmMsgText = 'Are you sure you want to close accounting for the date ' + this.convertDateToBindable(this._closeDate) + " and for selected deals" + '?';
        var modal = document.getElementById('customdialogboxAccountingclose');
        modal.style.display = "block";
    };
    accountingCloseComponent.prototype.ShowAccoutingOpenDialog = function () {
        this._ConfirmMsgText = 'Are you sure you want to open the accounting for the date ' + this.convertDateToBindable(this._openDate) + " and for selected deals" + '?';
        var modal = document.getElementById('customdialogboxopenperiod');
        modal.style.display = "block";
    };
    accountingCloseComponent.prototype.SaveAccountingOpen = function () {
        var _this = this;
        this._isaccountingcloseSaving = true;
        this.ClosePopUpopenperiod();
        var lstaccounting = this.lstaccountingClose.filter(function (x) { return x.Active == true; });
        this.savedialogmsg = '';
        var openDate = this.convertDateToBindable(this._openDate);
        for (var i = 0; i < lstaccounting.length; i++) {
            lstaccounting[i]["openDate"] = openDate;
        }
        this._accountingservice.saveaccountingOpen(lstaccounting).subscribe(function (res) {
            if (res.Succeeded) {
                _this._ShowmessagedivMsg = "Selected deals has been opened for the period " + _this.convertDateToBindable(_this._openDate) + ".";
                _this._closeDate = null;
                _this._openDate = null;
                _this.getAllAccountingClose();
                _this._Showmessagediv = true;
                setTimeout(function () {
                    this._Showmessagediv = false;
                    this._isaccountingcloseSaving = false;
                    this._disabled = true;
                }.bind(_this), 2000);
            }
        });
    };
    accountingCloseComponent.prototype.ConvertToBindableDate = function () {
        for (var i = 0; i < this.lstaccountingClose.length; i++) {
            if (this.lstaccountingClose[i].LastAccountingCloseDate != null)
                this.lstaccountingClose[i].LastAccountingCloseDate = new Date(this.convertDateToBindable(this.lstaccountingClose[i].LastAccountingCloseDate));
            if (this.lstaccountingClose[i].LastClosedOn != null)
                this.lstaccountingClose[i].LastClosedOn = new Date(this.convertDateToBindableWithTime(this.lstaccountingClose[i].LastClosedOn.toString()));
            if (this.lstaccountingClose[i].ClosingDate != null) {
                this.lstaccountingClose[i].ClosingDate = new Date(this.convertDateToBindable(this.lstaccountingClose[i].ClosingDate));
            }
            if (this.lstaccountingClose[i].Maturity != null)
                this.lstaccountingClose[i].Maturity = new Date(this.convertDateToBindable(this.lstaccountingClose[i].Maturity));
        }
    };
    accountingCloseComponent.prototype.convertDateToBindable = function (date) {
        var dateObj = new Date(date);
        return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear();
    };
    accountingCloseComponent.prototype.convertDateToBindableWithTime = function (date) {
        var dateObj = new Date(date);
        return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear() + " " + dateObj.getHours() + ":" + dateObj.getMinutes() + ":" + dateObj.getSeconds();
    };
    accountingCloseComponent.prototype.getTwoDigitString = function (number) {
        if (number.toString().length === 1)
            return "0" + number;
        return number;
    };
    accountingCloseComponent.prototype.ClosePopUpConfirmBox = function () {
        var modal = document.getElementById('customdialogboxAccountingclose');
        modal.style.display = "none";
    };
    accountingCloseComponent.prototype.ClosePopUpopenperiod = function () {
        var modal = document.getElementById('customdialogboxopenperiod');
        modal.style.display = "none";
    };
    accountingCloseComponent.prototype.getAllPortfolio = function () {
        var _this = this;
        this._portfolioService.getallportfolio().subscribe(function (res) {
            if (res.Succeeded) {
                var data = res.lstportfolio;
                _this.lstPortfolio = data;
            }
        });
    };
    accountingCloseComponent.prototype.ChangeDynamicPortfolio = function (newvalue) {
        this.PortfolioMasterGuid = newvalue.toString();
        this.getAllAccountingClose();
    };
    accountingCloseComponent.prototype.clickedAccoutingCloselog = function (DealID, DealName) {
        var _this = this;
        this.DealName = DealName;
        this._isaccountingcloseSaving = true;
        this.dealSrv.getAccountingClosebyDealid(DealID).subscribe(function (res) {
            if (res.Succeeded) {
                _this.lstdealaccountingClose = res.dt;
                _this.ConvertToBindableDateAccountingClose(_this.lstdealaccountingClose);
                var modaltrans = document.getElementById('myModalAccouting');
                _this._isaccountingcloseSaving = false;
                modaltrans.style.display = "block";
                $.getScript("/js/jsDrag.js");
            }
        });
    };
    accountingCloseComponent.prototype.CloseAccountingpopup = function () {
        var modal = document.getElementById('myModalAccouting');
        modal.style.display = "none";
    };
    accountingCloseComponent.prototype.ConvertToBindableDateAccountingClose = function (Data) {
        for (var i = 0; i < Data.length; i++) {
            if (this.lstdealaccountingClose[i].CloseDate != null) {
                this.lstdealaccountingClose[i].CloseDate = this.convertDateToBindable(this.lstdealaccountingClose[i].CloseDate);
            }
            if (this.lstdealaccountingClose[i].UpdatedOn != null) {
                this.lstdealaccountingClose[i].UpdatedOn = this.convertDateToBindable(this.lstdealaccountingClose[i].UpdatedOn.toString());
            }
            if (this.lstdealaccountingClose[i].OpenDate != null) {
                this.lstdealaccountingClose[i].OpenDate = this.convertDateToBindable(this.lstdealaccountingClose[i].OpenDate);
            }
        }
    };
    __decorate([
        (0, core_1.ViewChild)('flexaccountingclose'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], accountingCloseComponent.prototype, "flexaccountingclose", void 0);
    __decorate([
        (0, core_1.ViewChild)('filter'),
        __metadata("design:type", wjNg2GridFilter.WjFlexGridFilter)
    ], accountingCloseComponent.prototype, "gridFilter", void 0);
    accountingCloseComponent = __decorate([
        (0, core_1.Component)({
            selector: "accountingClose",
            templateUrl: "app/components/accountingClose.html?v=" + $.getVersion(),
            providers: [accoutingDataService_1.accoutingDataService, Periodic_1.Periodic, portfolioService_1.portfolioService, functionService_1.functionService, dealservice_1.dealService]
        }),
        __metadata("design:paramtypes", [accoutingDataService_1.accoutingDataService, utilityService_1.UtilityService, portfolioService_1.portfolioService, dealservice_1.dealService])
    ], accountingCloseComponent);
    return accountingCloseComponent;
}());
exports.accountingCloseComponent = accountingCloseComponent;
var routes = [
    { path: '', component: accountingCloseComponent }
];
var AccountingCloseModule = /** @class */ (function () {
    function AccountingCloseModule() {
    }
    AccountingCloseModule = __decorate([
        (0, core_1.NgModule)({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_1.RouterModule.forChild(routes), wijmo_angular2_grid_1.WjGridModule, wijmo_angular2_input_1.WjInputModule, wijmo_angular2_grid_filter_1.WjGridFilterModule],
            declarations: [accountingCloseComponent]
        })
    ], AccountingCloseModule);
    return AccountingCloseModule;
}());
exports.AccountingCloseModule = AccountingCloseModule;
//# sourceMappingURL=accountingClose.component.js.map