import { Component, ViewChild } from "@angular/core";
import { Router } from '@angular/router';
import * as wjcGrid from '@grapecity/wijmo.grid';
import { NgModule } from '@angular/core';
import { Paginated } from '../core/common/paginated.service';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { LoggingService } from './../core/services/logging.service';
import { WjInputModule } from '@grapecity/wijmo.angular2.input';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import { investorsService } from '../core/services/investors.service';

declare var $: any;
@Component({
  selector: "investors",
  templateUrl: "./investors.html",
  providers: [investorsService]
})

export class InvestorsComponent extends Paginated {
  
  lststatus : any;
 
  constructor(
    public investorsSrv: investorsService,
    private _router: Router) {
    super(50, 1, 0);
    this.GetAllLookups();
  }

  ngOnInit(): void {
  }
  GetAllLookups(): void {
    this.investorsSrv.getAllLookup().subscribe(res => {
      var data = res.lstLookups;
      this.lststatus = data.filter(x => x.ParentID == "51");

    });
  }
}
  const routes: Routes = [

    { path: '', component: InvestorsComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjInputModule, WjGridFilterModule],
  declarations: [InvestorsComponent]
})

export class investorsModule { }
