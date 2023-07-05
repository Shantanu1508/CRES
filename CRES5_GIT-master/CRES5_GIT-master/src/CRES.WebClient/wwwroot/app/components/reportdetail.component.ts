import { Component, OnInit } from "@angular/core";
import { Router, ActivatedRoute, Params, Route } from '@angular/router';


//import { dealService } from '../core/services/dealService';
import { isLoggedIn } from '../core/services/is-logged-in';
import { ReportService } from './../core/services/reportservice'
import { SearchService } from '../core/services/searchService';

import { ModuleWithProviders, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { Headers, RequestOptions, BaseRequestOptions } from '@angular/http';
import { UtilityService } from '../core/services/utilityService';
import { Search } from "../core/domain/search";
import * as pbi from 'powerbi-client';
import { ISettings } from "../../../node_modules/powerbi-models";
import { IEmbedConfigurationBase } from "embed";
//import * as models from 'powerbi-models';

@Component({

    templateUrl: "app/components/reportdetail.html",
    providers: [ReportService, SearchService]

})
//@CanActivate((next: ComponentInstruction, previous: ComponentInstruction) => {
//    return isLoggedIn(next, previous);
//})

export class ReportDetailComponent {
    private _searchObj: Search;
    private _searchData: Search;
    private powerbiReportId: string;
    private _powerbiURL: string;
    private accessToken: string;
    public powerbi: pbi.service.Service;
    public report: pbi.Report;
    public _pageSizeSearch: number = 10;
    public _pageIndexSearch: number = 1;
    public _MsgText: string = '';

    constructor(private activatedRoute: ActivatedRoute, public reportService: ReportService, public utilityService: UtilityService, public searchService: SearchService) {
        this.activatedRoute.params.forEach((params: Params) => {
            this.activatedRoute.params.forEach((params: Params) => {
                if (params['id'] !== undefined) {
                    this.powerbiReportId = params['id'];
                }
            });
        });

        this.showReport('reportContainer', this.powerbiReportId, '', true);
        this.utilityService.setPageTitle("M61-Reports");
        localStorage.setItem('powerbiReportId', this.powerbiReportId);

    }

    getReport() {
        this.reportService.GetReportByID(this.powerbiReportId).subscribe(res => {
            this._powerbiURL = res.Report.embedUrl
            this.accessToken = res.AccessToken

            var iframe = document.getElementById('IpowerbiReport') as HTMLFrameElement;

            iframe.src = this._powerbiURL;
            iframe.onload = function () {
                var msgJson = {
                    action: "loadReport",
                    accessToken: res.AccessToken

                };
                var msgTxt = JSON.stringify(msgJson);
                iframe.contentWindow.postMessage(msgTxt, "*");
            };

        }

        )
    }

    showReport(reportContainerName, reportId: string, reportName: string, isLoad: boolean = true) {
        var _userData = JSON.parse(localStorage.getItem('user'));

        this.reportService.GetReportByID(reportId).subscribe(res => {
            var data = res;
            var config: pbi.IEmbedConfiguration = {
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
                    extensions: this.getExtensions(data.ReportNam)
                }
            };

            // Grab the reference to the div HTML element that will host the report.
            let reportContainer = <HTMLElement>document.getElementById(reportContainerName);

            // Embed the report and display it within the div container.

            this.powerbi = new pbi.service.Service(pbi.factories.hpmFactory, pbi.factories.wpmpFactory, pbi.factories.routerFactory);
            this.report = <pbi.Report>this.powerbi.embed(reportContainer, config);

            this.report.switchMode(pbi.models.ViewMode.Edit);

            // Report.off removes a given event handler if it exists.
            this.report.off("loaded");

            this.report.on("loaded", e => {

                //query page level filter
                var _paramsReportName = sessionStorage.getItem("paramsReportName");
                if (_paramsReportName == reportName) {
                    var _paramsPageFilter = sessionStorage.getItem("paramsPageFilter")
                    var _paramsPageName = sessionStorage.getItem("paramsPageName");

                    sessionStorage.removeItem("paramsReportName");
                    sessionStorage.removeItem("paramsPageFilter");
                    sessionStorage.removeItem("paramsPageName");
                }


            });

            this.report.off("dataSelected");

            // Report.on will add an event listener.
            this.report.on("dataSelected", function (event) {
                var data = event.detail;
                console.log(data);
            });

            this.report.on("commandTriggered", command => {
                this.setCommandTriggered(command);
            });

        });

    }

    getExtensions(reportName: string) {
        //Setting Extenstion for different reports
        var extend, extensions = [];

        extensions.push(
            {
                command: {
                    name: "DealID",
                    title: "DealID",

                    extend: {
                        visualContextMenu: {
                            title: "View Deal",
                        }
                    }
                }
            }
        )

        extensions.push(
            {
                command: {
                    name: "NoteID",
                    title: "NoteID",

                    extend: {
                        visualContextMenu: {
                            title: "View Note",
                        }
                    }
                }
            }
        )

        return extensions;
    }

    setCommandTriggered(command) {
        //Setting commands to be triggered when user click on extension method

        switch (command.detail.command)
        {
            case "DealID":
                let Deal = command.detail.dataPoints[0].identity.filter(x => x.target.column == "DealID");
                if (Deal.length > 0) {
                    window.open(window.location.origin + '/#/dealdetail/' + Deal[0].equals, '_blank');
                }
                else {
                    this._MsgText = 'Please right click on "DealID" column to open deal.';
                    $('#customdialogbox').show();
                }
                break;
            case "NoteID":
                let Note = command.detail.dataPoints[0].identity.filter(x => x.target.column == "NoteID");
                if (Note.length > 0) {
                    this._searchObj = new Search(Note[0].equals);
                    this.searchService.getAutosuggestSearchData(this._searchObj, this._pageIndexSearch, this._pageSizeSearch).subscribe(res => {
                        if (res.Succeeded) {
                            var data: any = res.lstSearch;
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
    }

    public HideDialog(): void {
        $('#customdialogbox').hide();
    }
}

const routes: Routes = [

    { path: '', component: ReportDetailComponent }]

@NgModule({
    imports: [FormsModule, CommonModule, RouterModule.forChild(routes)],
    declarations: [ReportDetailComponent]

})

export class ReportDetailModule { }