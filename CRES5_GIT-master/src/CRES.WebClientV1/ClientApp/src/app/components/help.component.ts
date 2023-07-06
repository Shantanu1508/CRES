import { Component} from "@angular/core";
import { Router} from '@angular/router';
import { NgModule } from '@angular/core';
import { UtilityService } from '../core/services/utility.service';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';

@Component({
  selector: "help",
  templateUrl: "./help.html"
})

export class HelpComponent {
  private _pagePath: any;
  constructor(

    public utilityService: UtilityService,
    private _router: Router) {
    this.utilityService.setPageTitle("M61-Help");
  }

  openLink(): void {

    this._pagePath = ['taskdetail/a', '00000000-0000-0000-0000-000000000000']
    this._router.navigate(this._pagePath)
  }
}

const routes: Routes = [
  { path: '', component: HelpComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes)],
  declarations: [HelpComponent]
})

export class helpModule { }
