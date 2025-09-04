import { Component, OnInit, Inject, Compiler, AfterViewInit, ViewChild } from '@angular/core';
import { Router, ActivatedRoute, Params, Route } from '@angular/router';
import { indexesService } from '../core/services/indexes.service';
import { NotificationService } from '../core/services/notification.service'
import { UtilityService } from '../core/services/utility.service';
import { Paginated } from '../core/common/paginated.service';
import * as wjcGrid from '@grapecity/wijmo.grid';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import * as wjcCore from '@grapecity/wijmo';

declare var $: any;

@Component({
  selector: "indexes",
  templateUrl: "./indexes.html",
  providers: [indexesService, NotificationService]
})

export class IndexesComponent extends Paginated {
  public _indexes !: indexesService;
  public indexesdata: any
  public TotalCount: number = 0;
  public indexesupdatedRowNo: any = [];
  sindexesaddpath: any;
  public indexesToUpdate: any = [];
  lstIndexesData: any;
  public Message: any = '';
  public _ShowSuccessmessagediv: boolean = false;
  public _ShowSuccessmessage: any;
  public _Showmessagediv: boolean = false;
  public _isIndexesListFetching: boolean = true;
  public _isshowIndexesAddbutton: boolean = false;
  public _dvEmptyIndexesSearchMsg: boolean = false;
  public _chkShowAllActiveInactiveIndexes = false;
  public data !: wjcCore.CollectionView;

  @ViewChild('flexindexes') flexIndexes !: wjcGrid.FlexGrid;

  constructor(private _router: Router,
    public indexesService: indexesService,
    public utilityService: UtilityService,
    public notificationService: NotificationService) {
    super(30, 1, 0);
    this.GetAllIndexes();

    this.utilityService.setPageTitle("M61–Indexes");
  }

  // Component views are initialized
  ngAfterViewInit() {
    // commit row changes when scrolling the grid

    this.flexIndexes.scrollPositionChanged.addHandler(() => {
      var myDiv = $('#flex').find('div[wj-part="root"]');

      if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
        if (this.flexIndexes.rows.length < this._totalCount) {
          this._pageIndex = this.pagePlus(1);
          this.GetAllIndexes();
        }
      }
    });
    this.onChangeShowAllActiveInactiveIndexes(this._chkShowAllActiveInactiveIndexes);
    this.data = new wjcCore.CollectionView(this.lstIndexesData);
  }

  GetAllIndexes(): void {

    this._isIndexesListFetching = true;
    if (localStorage.getItem('divSucessIndexes') == 'true') {
      this._ShowSuccessmessagediv = true;
      this._ShowSuccessmessage = localStorage.getItem('successmsgindexes');
      this._ShowSuccessmessage = (this._ShowSuccessmessage.replace('\"', '')).replace('\"', '');
      localStorage.setItem('divSucessIndexes', JSON.stringify(false));
      localStorage.setItem('successmsgindexes', JSON.stringify(''));

      //to hide _Showmessagediv after 5 sec
      setTimeout(()=> {
        this._ShowSuccessmessagediv = false;
      }, 5000);

      setTimeout(() =>{
        if (this.flexIndexes) {
         // this.flexIndexes.autoSizeColumns(0, this.flexIndexes.columns.length, false, 20);
         // this.flexIndexes.columns[0].width = 350; // for Note Id
        }
      }, 1);

    }


    this.indexesService.GetAllIndexesMaster(this._pageIndex, this._pageSize)
      .subscribe(res => {
        if (res.Succeeded) {

          if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {

            var data: any = res.lstIndexesMaster;
            this._totalCount = res.TotalCount;


            if (this._pageIndex == 1) {
              this.lstIndexesData = data;

              //remove first cell selection
              this.flexIndexes.selectionMode = wjcGrid.SelectionMode.None;

              if (res.TotalCount == 0) {
                this._dvEmptyIndexesSearchMsg = true;
                this._isIndexesListFetching = false;
              } else {
                setTimeout(() => {
                  this._isIndexesListFetching = false;
                }, 2000);
              }


              setTimeout(() => {
                this.ApplyPermissions(res.UserPermissionList);
              }, 2000);

            }
            else {

              data.forEach((obj:any, i:any) => { // FETCH ALL DATA AND PUSH IN FLEX GRID!!!
                //this.flex.rows.push(new wjcGrid.Row(obj));
              });
              this.lstIndexesData = this.lstIndexesData.concat(data);

            }

            this._isIndexesListFetching = false;

            setTimeout(() => {
              //this.flexIndexes.invalidate();
              //this.flexIndexes.autoSizeColumns(0, this.flexIndexes.columns.length, false, 20);
              //this.flexIndexes.columns[0].width = 150; // for Indexes name Id
            }, 1);

          } else {
            this.utilityService.navigateUnauthorize();
          }
          //
        }
        else {
          this.utilityService.navigateToSignIn();
        }
        //this.data = this.lstIndexesData;
        this.onChangeShowAllActiveInactiveIndexes(false);
      },
        (error:any) => {
          if (error.status == 401) {
            this.notificationService.printErrorMessage('Authentication required');
            this.utilityService.navigateToSignIn();
          }
        }

      );

  }

  ShowSuccessmessageDiv(msg:any) {
    this._ShowSuccessmessagediv = true;
    this._ShowSuccessmessage = msg;
    setTimeout(() => {
      this._ShowSuccessmessagediv = false;
    }, 5000);
  }

  ApplyPermissions(_object:any): void {

    for (var i = 0; i < _object.length; i++) {
      if (_object[i].ChildModule == 'btnAddIndex') {
        this._isshowIndexesAddbutton = true;
      }
    }

    //var buttonarray = _object.filter(function (item) { return item.ModuleType === 'Control' && item.RightsName === 'Edit'; });

    //if (buttonarray.length > 0 && typeof buttonarray != 'undefined') {
    //    this._isshowIndexesAddbutton = true;
    //}
  }

  AddNewIndexes(): void {
    this._router.navigate(['/indexesdetail', "00000000-0000-0000-0000-000000000000"]);
  }

  onChangeShowAllActiveInactiveIndexes(newvalue): void {
    // var checked = e.target.checked;

    if (newvalue == true) {
      this.data = new wjcCore.CollectionView(this.lstIndexesData);
      this._chkShowAllActiveInactiveIndexes = true;
    }
    else {
      var lstActiveIndexes = this.lstIndexesData.filter(x => x.StatusText == "Active");
      this.data = new wjcCore.CollectionView(lstActiveIndexes);
      this._chkShowAllActiveInactiveIndexes = false;
    }
    this.data.trackChanges = true;

  }
}


const routes: Routes = [

  { path: '', component: IndexesComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjGridFilterModule],
  declarations: [IndexesComponent]

})

export class indexesModule { }
