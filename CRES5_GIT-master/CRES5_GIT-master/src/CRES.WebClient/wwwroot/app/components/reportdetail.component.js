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
exports.ReportDetailModule = exports.ReportDetailComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var reportservice_1 = require("./../core/services/reportservice");
var searchService_1 = require("../core/services/searchService");
var core_2 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var router_2 = require("@angular/router");
var utilityService_1 = require("../core/services/utilityService");
var search_1 = require("../core/domain/search");
var pbi = require("powerbi-client");
//import * as models from 'powerbi-models';
var ReportDetailComponent = /** @class */ (function () {
    function ReportDetailComponent(activatedRoute, reportService, utilityService, searchService) {
        var _this = this;
        this.activatedRoute = activatedRoute;
        this.reportService = reportService;
        this.utilityService = utilityService;
        this.searchService = searchService;
        this._pageSizeSearch = 10;
        this._pageIndexSearch = 1;
        this._MsgText = '';
        this.activatedRoute.params.forEach(function (params) {
            _this.activatedRoute.params.forEach(function (params) {
                if (params['id'] !== undefined) {
                    _this.powerbiReportId = params['id'];
                }
            });
        });
        this.showReport('reportContainer', this.powerbiReportId, '', true);
        this.utilityService.setPageTitle("M61-Reports");
        localStorage.setItem('powerbiReportId', this.powerbiReportId);
    }
    ReportDetailComponent.prototype.getReport = function () {
        var _this = this;
        this.reportService.GetReportByID(this.powerbiReportId).subscribe(function (res) {
            _this._powerbiURL = res.Report.embedUrl;
            _this.accessToken = res.AccessToken;
            var iframe = document.getElementById('IpowerbiReport');
            iframe.src = _this._powerbiURL;
            iframe.onload = function () {
                var msgJson = {
                    action: "loadReport",
                    accessToken: res.AccessToken
                };
                var msgTxt = JSON.stringify(msgJson);
                iframe.contentWindow.postMessage(msgTxt, "*");
            };
        });
    };
    ReportDetailComponent.prototype.showReport = function (reportContainerName, reportId, reportName, isLoad) {
        var _this = this;
        if (isLoad === void 0) { isLoad = true; }
        var _userData = JSON.parse(localStorage.getItem('user'));
        this.reportService.GetReportByID(reportId).subscribe(function (res) {
            var data = res;
            var config = {
                type: 'report',
                tokenType: pbi.models.TokenType.Embed,
                accessToken: data.EmbedToken.token,
                embedUrl: data.EmbedUrl,
                id: data.Id,
                permissions: pbi.models.Permissions.All /*gives maximum permissions*/,
                viewMode: pbi.models.ViewMode.View,
                settings: {
                    filterPaneEnabled: true,
                    navContentPaneEnabled: true,
                    extensions: _this.getExtensions(data.ReportNam)
                }
            };
            // Grab the reference to the div HTML element that will host the report.
            var reportContainer = document.getElementById(reportContainerName);
            // Embed the report and display it within the div container.
            _this.powerbi = new pbi.service.Service(pbi.factories.hpmFactory, pbi.factories.wpmpFactory, pbi.factories.routerFactory);
            _this.report = _this.powerbi.embed(reportContainer, config);
            _this.report.switchMode(pbi.models.ViewMode.Edit);
            // Report.off removes a given event handler if it exists.
            _this.report.off("loaded");
            _this.report.on("loaded", function (e) {
                //query page level filter
                var _paramsReportName = sessionStorage.getItem("paramsReportName");
                if (_paramsReportName == reportName) {
                    var _paramsPageFilter = sessionStorage.getItem("paramsPageFilter");
                    var _paramsPageName = sessionStorage.getItem("paramsPageName");
                    sessionStorage.removeItem("paramsReportName");
                    sessionStorage.removeItem("paramsPageFilter");
                    sessionStorage.removeItem("paramsPageName");
                }
            });
            _this.report.off("dataSelected");
            // Report.on will add an event listener.
            _this.report.on("dataSelected", function (event) {
                var data = event.detail;
                console.log(data);
            });
            _this.report.on("commandTriggered", function (command) {
                _this.setCommandTriggered(command);
            });
        });
    };
    ReportDetailComponent.prototype.getExtensions = function (reportName) {
        //Setting Extenstion for different reports
        var extend, extensions = [];
        extensions.push({
            command: {
                name: "DealID",
                title: "DealID",
                extend: {
                    visualContextMenu: {
                        title: "View Deal",
                    }
                }
            }
        });
        extensions.push({
            command: {
                name: "NoteID",
                title: "NoteID",
                extend: {
                    visualContextMenu: {
                        title: "View Note",
                    }
                }
            }
        });
        return extensions;
    };
    ReportDetailComponent.prototype.setCommandTriggered = function (command) {
        //Setting commands to be triggered when user click on extension method
        switch (command.detail.command) {
            case "DealID":
                var Deal = command.detail.dataPoints[0].identity.filter(function (x) { return x.target.column == "DealID"; });
                if (Deal.length > 0) {
                    window.open(window.location.origin + '/#/dealdetail/' + Deal[0].equals, '_blank');
                }
                else {
                    this._MsgText = 'Please right click on "DealID" column to open deal.';
                    $('#customdialogbox').show();
                }
                break;
            case "NoteID":
                var Note = command.detail.dataPoints[0].identity.filter(function (x) { return x.target.column == "NoteID"; });
                if (Note.length > 0) {
                    this._searchObj = new search_1.Search(Note[0].equals);
                    this.searchService.getAutosuggestSearchData(this._searchObj, this._pageIndexSearch, this._pageSizeSearch).subscribe(function (res) {
                        if (res.Succeeded) {
                            var data = res.lstSearch;
                            window.open(window.location.origin + '/#/notedetail/' + data[0].ValueID, '_blank');
                        }
                    });
                }
                else {
                    this._MsgText = 'Please right click on "NoteID" column to open note.';
                    $('#customdialogbox').show();
                }
                break;
        }
    };
    ReportDetailComponent.prototype.HideDialog = function () {
        $('#customdialogbox').hide();
    };
    ReportDetailComponent = __decorate([
        core_1.Component({
            templateUrl: "app/components/reportdetail.html",
            providers: [reportservice_1.ReportService, searchService_1.SearchService]
        })
        //@CanActivate((next: ComponentInstruction, previous: ComponentInstruction) => {
        //    return isLoggedIn(next, previous);
        //})
        ,
        __metadata("design:paramtypes", [router_1.ActivatedRoute, reportservice_1.ReportService, utilityService_1.UtilityService, searchService_1.SearchService])
    ], ReportDetailComponent);
    return ReportDetailComponent;
}());
exports.ReportDetailComponent = ReportDetailComponent;
var routes = [
    { path: '', component: ReportDetailComponent }
];
var ReportDetailModule = /** @class */ (function () {
    function ReportDetailModule() {
    }
    ReportDetailModule = __decorate([
        core_2.NgModule({
            imports: [forms_1.FormsModule, common_1.CommonModule, router_2.RouterModule.forChild(routes)],
            declarations: [ReportDetailComponent]
        })
    ], ReportDetailModule);
    return ReportDetailModule;
}());
exports.ReportDetailModule = ReportDetailModule;
//# sourceMappingURL=reportdetail.component.js.map