import { Component, ViewChild } from '@angular/core';
import { Router, ActivatedRoute, Params} from '@angular/router';
import { portfolio } from "../core/domain/portfolio.model";
import { NotificationService } from '../core/services/notification.service'
import { NoteService } from '../core/services/note.service'
import { MembershipService } from '../core/services/membership.service';
import { UtilityService } from '../core/services/utility.service';
import * as wjcCore from '@grapecity/wijmo';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import { WjInputModule } from '@grapecity/wijmo.angular2.input';
import { portfolioService } from '../core/services/portfolio.service'
import * as wjNg2Input from "@grapecity/wijmo.angular2.input";
declare var $: any;

@Component({
  selector: "portfoliodetail",
  templateUrl: "./portfoliodetail.html",
  providers: [NoteService, NotificationService, UtilityService, portfolioService],
})

export class PortfolioDetailComponent {
  cvScenarioDetaildata: wjcCore.CollectionView;
  public _portfolio: portfolio;
  public _ShowmessagedivMsgWar: any;
  public _ShowmessagedivWar: boolean = false;
  public Message: any = '';
  public _Showmessagediv: boolean = false;
  lstPool: any;
  lstFund: any;
  lstfinancingsource: any;
  lstClient: any;
  @ViewChild('multiselPool') multiselPool: wjNg2Input.WjMultiSelect
  @ViewChild('multiselFund') multiselFund: wjNg2Input.WjMultiSelect
  @ViewChild('multiselClient') multiselClient: wjNg2Input.WjMultiSelect
  @ViewChild('multiselFinancingSource') multiselFinancingSource: wjNg2Input.WjMultiSelect
  public _isScenarioDetailFetching: boolean = false;

  constructor(private activatedRoute: ActivatedRoute,
    private _router: Router,
    public noteService: NoteService,
    public utilityService: UtilityService,
    public notificationService: NotificationService,
    public membershipService: MembershipService,
    public _portfolioService: portfolioService
  ) {

    this.activatedRoute.params.forEach((params: Params) => {
      this._portfolio = new portfolio('');

      if (params['id'] !== undefined) {
        var portfolioId = params['id'];
        this._portfolio.PortfolioMasterGuid = portfolioId;
        this.GetPortfolioByID();
      }
      else {
        this.GetAllLookups();

        this.getAllFund();
      }
    });


    this.utilityService.setPageTitle("M61 – Dynamic Portfolio");
  }

  ngOnInit() {
    // get return url from route parameters or default to '/'



  }

  GetAllLookups(): void {
    var parentids = "74,81";
    this.membershipService.getAllLookup(parentids).subscribe(res => {
      var data = res.lstLookups;
      this.lstPool = data.filter(x => x.ParentID == "74");
      this.lstPool.forEach((objparent, i) => { // FETCH ALL DATA AND PUSH IN FLEX GRID!!!

        this._portfolio.PoolIDs.split(/\s*,\s*/).forEach((obj, j) => {
          if (objparent.LookupID == obj) {
            this.lstPool[i].selected = true;
          }
        });
      });
    });
  }

  SavePortfolio(): void {

    if (this._portfolio.PortfolioName == '' || this._portfolio.PortfolioName == null || this._portfolio.PortfolioName == undefined) {
      this._ShowmessagedivWar = true;
      this._ShowmessagedivMsgWar = "Portfolio name can not be empty.";
      setTimeout(function () {
        this._ShowmessagedivWar = false;
        this._ShowmessagedivMsgWar = '';
      }.bind(this), 5000);
      return;
    }

    var poolids = ''
    var fundids = ''
    var clientids = '';
    var financingsourceids = '';
    if (this.multiselPool != undefined)
      var poolids = this.multiselPool.checkedItems.map(({ LookupID }) => LookupID).join(',')
    if (this.multiselFund != undefined)
      var fundids = this.multiselFund.checkedItems.map(({ FundID }) => FundID).join(',')
    if (this.multiselClient != undefined)
      var clientids = this.multiselClient.checkedItems.map(({ ClientID }) => ClientID).join(',')
    if (this.multiselFinancingSource != undefined)
      financingsourceids = this.multiselFinancingSource.checkedItems.map(({ FinancingSourceMasterID }) => FinancingSourceMasterID).join(',')

    this._portfolio.PoolIDs = poolids;
    this._portfolio.FundIDs = fundids;
    this._portfolio.ClientIDs = clientids;
    this._portfolio.FinancingSourceIDs = financingsourceids;
    this._portfolioService.addupdateportfolio(this._portfolio).subscribe(res => {
      if (res.Succeeded) {
        if (res.Message == "Success") {
          localStorage.setItem('divSucessPortfolio', JSON.stringify(true));
          if (this._portfolio.PortfolioMasterGuid == '')
            localStorage.setItem('successmsgPortfolio', JSON.stringify('Portfolio added successfully'));
          else
            localStorage.setItem('successmsgPortfolio', JSON.stringify('Portfolio updated successfully'));

          this._router.navigate(['portfolio']);

        }
        else if (res.Message == "Duplicate") {
          this._ShowmessagedivWar = true;
          this._ShowmessagedivMsgWar = "Portfolio name already exist.Please chose other one.";
          setTimeout(function () {
            this._ShowmessagedivWar = false;
            this._ShowmessagedivMsgWar = '';
          }.bind(this), 5000);
        }
        else {

          this._ShowmessagedivWar = true;
          this._ShowmessagedivMsgWar = "Something  went wrong.Please try again.";
          setTimeout(function () {
            this._ShowmessagedivWar = false;
            this._ShowmessagedivMsgWar = '';
          }.bind(this), 5000);
        }

      }
      else {
        this._router.navigate(['login']);
      }
    }),
      error => {
        this._ShowmessagedivWar = true;
        this._ShowmessagedivMsgWar = "Something  went wrong.Please try again.";
        setTimeout(function () {
          this._ShowmessagedivWar = false;
          this._ShowmessagedivMsgWar = '';
        }.bind(this), 5000);
      }
  }

  GetPortfolioByID(): void {
    try {
      this._portfolioService.getportfoliodetailbyid(this._portfolio).subscribe(res => {
        if (res.Succeeded) {
          if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
            this._portfolio = res.portfolioDataContract
            this.GetAllLookups();
            this.getAllFund();
            this.GetFinancingSource();
            this.getAllClient();
          }
          else {

            localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
            localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));
            this.utilityService.navigateUnauthorize();
          }
        }
        else {
          this._router.navigate(['login']);
        }
      });
    } catch (err) {
    }
  }

  Cancel(): void {
    this._router.navigate(['portfolio']);
  }

  getAllFund(): void {
    this.noteService.getAllFund().subscribe(res => {
      if (res.Succeeded) {
        this.lstFund = res.lstFund;
        this.lstFund.forEach((objparent, i) => { // FETCH ALL DATA AND PUSH IN FLEX GRID!!!

          this._portfolio.FundIDs.split(/\s*,\s*/).forEach((obj, j) => {
            if (objparent.FundID == obj) {
              this.lstFund[i].selected = true;
            }
          });

        });
      }
    });
  }


  GetFinancingSource(): void {
    this.noteService.GetFinancingSource().subscribe(res => {
      if (res.Succeeded) {
        this.lstfinancingsource = res.lstfinancingsource;
        this.lstfinancingsource.forEach((objparent, i) => { // FETCH ALL DATA AND PUSH IN FLEX GRID!!!

          this._portfolio.FinancingSourceIDs.split(/\s*,\s*/).forEach((obj, j) => {
            if (objparent.FinancingSourceMasterID == obj) {
              this.lstfinancingsource[i].selected = true;
            }
          });

        });
      }
    });
  }

  getAllClient(): void {
    this.noteService.getAllClient().subscribe(res => {
      if (res.Succeeded) {
        this.lstClient = res.lstClient;
        this.lstClient.forEach((objparent, i) => { // FETCH ALL DATA AND PUSH IN FLEX GRID!!!

          this._portfolio.ClientIDs.split(/\s*,\s*/).forEach((obj, j) => {
            if (objparent.ClientID == obj) {
              this.lstClient[i].selected = true;
            }
          });

        });
      }
    });
  }
}


const routes: Routes = [

  { path: '', component: PortfolioDetailComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjGridFilterModule, WjInputModule],
  declarations: [PortfolioDetailComponent]
})

export class portfolioDetailModule { }
