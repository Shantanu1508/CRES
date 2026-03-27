import { Component, ViewChild, NgModule } from "@angular/core";
import { Router} from '@angular/router';
import { Workflow } from "../core/domain/workFlow.model";
import { NotificationService } from '../core/services/notification.service'
import { User } from '../core/domain/user.model';
import { UtilityService } from '../core/services/utility.service';
import { Paginated } from '../core/common/paginated.service';
import * as wjcGridDetail from '@grapecity/wijmo.grid.detail';
import * as wjcCore from '@grapecity/wijmo';
import * as wjcGrid from '@grapecity/wijmo.grid';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import { WjGridDetailModule } from '@grapecity/wijmo.angular2.grid.detail';
import { WjInputModule } from '@grapecity/wijmo.angular2.input';
import { WFService } from '../core/services/workFlow.service';
import { DealFunding } from "../core/domain/dealFunding.model";
import * as wjNg2Input from '@grapecity/wijmo.angular2.input';

declare var $: any;
@Component({
  selector: "workflow",
  templateUrl: "./workFlow.html",
  providers: [WFService, NotificationService]
})


export class WorkflowListComponent extends Paginated {

  public dealMessage: string;
  public userid: number;
  public lstworkflow: any;
  public alllstworkflow: any;
  public lstworkflowDetail: any;
  public _lstworkflowDetail: any;
  public _workflow: Array<Workflow>;
  public _workflowObj: Workflow;
  public userobj: User;
  public dealaddpath: any;
  public _workflowListFetching: boolean = false;
  public _ShowmessagedivMsgWar: boolean = false;
  public _dvEmptyWFSearchMsg: boolean = false;
  public _Showmessagediv: boolean = false;
  public _ShowmessagedivMsg: string = '';
  public _WaringMessage: string = '';
  public _isshowDealbutton: boolean = false;
  public _isShowActivityLog: boolean = false;
  public _fundingCache = {};
  public _dealFunding: DealFunding;
  public lststatus: any = [];
  public lstWFDashBoard: any = [];

  detailMode = wjcGridDetail.DetailVisibilityMode[wjcGridDetail.DetailVisibilityMode.ExpandSingle];
  _fundings = new wjcCore.CollectionView();
  @ViewChild('multiselStatus') multiselStatus: wjNg2Input.WjMultiSelect
  public _isChecked: boolean = true;
  @ViewChild('flex') flex: wjcGrid.FlexGrid;
  public lstapprover: any;
  cvDashBoardList: wjcCore.CollectionView;

  constructor(public WFSrv: WFService,
    public utilityService: UtilityService,
    public notificationService: NotificationService,
    private _router: Router) {
    super(30, 1, 0);

    this._isshowDealbutton = false;
    this._workflowObj = new Workflow(0);
    this._workflowObj.filterType = 'all';
    this.getWorkflow(this._workflowObj);
    this.utilityService.setPageTitle("M61–Workflow");
    
  }

  // Component views are initialized
  //ngAfterViewInit() {
  //  // commit row changes when scrolling the grid

  //  this.flex.scrollPositionChanged.addHandler(() => {
  //    var myDiv = $('#flex').find('div[wj-part="root"]');

  //    if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
  //      if (this.flex.rows.length < this._totalCount) {
  //        this._pageIndex = this.pagePlus(1);
  //        //this._workflowObj.filterType = filterType;
  //        this.getWorkflow(this._workflowObj);
  //      }
  //    }
  //  });
  //}

  FetchAllTask(valuechecked) {
    //this._isCalcListFetching = true;

    if (valuechecked) {
      this._workflowObj.filterType = 'all';
    }
    else {
      this._workflowObj.filterType = 'respective';
    }

    this.getWorkflow(this._workflowObj);
  }

  getWorkflow(_workflowObj): void {
    if (localStorage.getItem('divSucessWorkflow') == 'true') {
      this._Showmessagediv = false;
      this._ShowmessagedivMsg = localStorage.getItem('divSucessMsgDeal');
      this._ShowmessagedivMsg = (this._ShowmessagedivMsg.replace('\"', '')).replace('\"', '');
      localStorage.setItem('divSucessDeal', JSON.stringify(false));
      localStorage.setItem('divSucessMsgDeal', JSON.stringify(''));


      setTimeout(function () {
        this._Showmessagediv = false;
        console.log(this._Showmessagediv);
      }.bind(this), 5000);
    }

    if (localStorage.getItem('divWarningMsgWorkflow') == 'true') {
      this._ShowmessagedivMsgWar = true;
      this._WaringMessage = localStorage.getItem('divWarningMsg');
      this._WaringMessage = (this._WaringMessage.replace('\"', '')).replace('\"', '');
      localStorage.setItem('divWarningMsgWorkflow', JSON.stringify(false));
      localStorage.setItem('divWarningMsg', JSON.stringify(''));
      setTimeout(function () {
        this._ShowmessagedivMsgWar = false;
      }.bind(this), 5000);
    }

    this._workflowListFetching = true;

    //this._workflowObj.filterType = filterType;
    this.WFSrv.getAllWorkflowByFilterType(_workflowObj, this._pageIndex, this._pageSize)
      .subscribe(res => {
        if (res.Succeeded) {

          if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {

            var data: any = res.lstWorkflow;
            this.lstapprover = res.UserList
            this._totalCount = res.TotalCount;
            this.lstworkflow = data;
            this.cvDashBoardList = new wjcCore.CollectionView(this.lstworkflow);
            this.cvDashBoardList.trackChanges = true;
            this.alllstworkflow = this.lstworkflow;
            ////if (this._pageIndex == 1) {
            //  this.lstworkflow = data;
            //  this.alllstworkflow = this.lstworkflow;
            //  //remove first cell selection
            //  //   this.flex.selectionMode = wjcGrid.SelectionMode.None;

            //  if (res.TotalCount == 0) {
            //    this._dvEmptyWFSearchMsg = true;
            //    this._workflowListFetching = false;
            //  } else {
            //    this._dvEmptyWFSearchMsg = false;
            //    //setTimeout(() => {
            //    //    this._dvEmptyWFSearchMsg = false;
            //    //    this._workflowListFetching = false;
            //    //}, 500);
            //  }


            //  setTimeout(() => {
            //    this.ApplyPermissions(res.UserPermissionList);
            //  }, 2000);


              //format date
              for (var i = 0; i < this.lstworkflow.length; i++) {

                if (this.lstworkflow[i].Amount < 0) {
                  this.lstworkflow[i].Deadline = 'N/A';

                }
                if (this.lstworkflow[i].Fundingdate != '0001-01-01T00:00:00') {
                  if (this.lstworkflow[i].Fundingdate != null) {
                    this.lstworkflow[i].Fundingdate = this.convertDateToBindable(this.lstworkflow[i].Fundingdate);

                  }
                }
                else {
                  this.lstworkflow[i].Fundingdate = null;
                }
                if (this.lstworkflow[i].Deadline != 'N/A') {
                  if (this.lstworkflow[i].Deadline != '0001-01-01T00:00:00') {
                    if (this.lstworkflow[i].Deadline != null) {
                      this.lstworkflow[i].Deadline = this.convertDateToBindable(this.lstworkflow[i].Deadline);
                    }
                  }
                  else {
                    this.lstworkflow[i].Deadline = null;
                  }
                }
              }

            //}
            //else {

            //  data.forEach((obj, i) => { // FETCH ALL DATA AND PUSH IN FLEX GRID!!!
            //    //format date

            //    if (obj.Fundingdate != '0001-01-01T00:00:00') {
            //      if (obj.Fundingdate == null) {
            //        obj.Fundingdate = null;
            //      } else {
            //        obj.Fundingdate = new Date(obj.Fundingdate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
            //      }
            //    }
            //    else {
            //      obj.Fundingdate = null;
            //    }
            //    if (obj.Deadline != 'N/A') {
            //      if (obj.Deadline != '0001-01-01T00:00:00') {
            //        if (obj.Deadline != null) {
            //          obj.Deadline = new Date(obj.Deadline.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
            //        }
            //      }
            //      else {
            //        obj.Deadline = null;
            //      }
            //    }
            //    //this.flex.rows.push(new wjcGrid.Row(obj));
            //  });

            //  this.lstworkflow = this.lstworkflow.concat(data);
            //  this.alllstworkflow = this.lstworkflow;
            //}

            this._workflowListFetching = false;


            //setTimeout(function () {
            //  if (!this._dvEmptyWFSearchMsg)
            //    this.flex.invalidate();
            //  this.getAllWorkflowdetail();

            //  //this._initDetailProvider(this.flex);
            //  //this.flex.autoSizeColumns(0, this.flex.columns.length, false, 20);
            //  //this.flex.columns[0].width = 350; // for Note Id
            //}.bind(this), 1);
           
            this._bindGridDropdows();

          } else {

            localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
            localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));

            this.utilityService.navigateUnauthorize();
          }
          //
        }
        else {
          this.utilityService.navigateToSignIn();
        }
        if (this.lstworkflow) {
          this.onchangedcheckeditems('onload');
          this.multiselStatus.headerFormat = "3 Status Selected";
        }
        // this.lstworkflow = this.lstworkflow.filter(x => x.StatusName != "Projected" && x.StatusName != "Under Review")
      },
        error => {
          if (error.status == 401) {
            this.notificationService.printErrorMessage('Authentication required');
            this.utilityService.navigateToSignIn();
          }
        }

      );
    this.GetAllWorkflowStatus();
  }

  getAllWorkflowdetail(): void {
    //alert('fundingID ' + fundingID);
    this._dealFunding = new DealFunding('');
    this._dealFunding.DealFundingID = '00000000-0000-0000-0000-000000000000';
    this.WFSrv.getfundingdetailbydealfundingid(this._dealFunding).subscribe(res => {
      if (res.Succeeded) {
        var data: any = res.lstFundingScheduleDetail;
        this.lstworkflowDetail = data;
      }
      else {
        // no record
      }
    });
  }


  getWorkflowdetailByFundingID(fundingID: any): void {
    return this.lstworkflowDetail.filter(x => x.DealFundingID.toLowerCase() == fundingID.toLowerCase());
  }

  ApplyPermissions(_object): void {

    //var buttonarray = _object.filter(function (item) { return item.ModuleType === 'Control' && item.RightsName === 'Edit'; });

    //if (buttonarray.length > 0 && typeof buttonarray != 'undefined') {
    //    this._isshowDealbutton = true;
    //}
    //this._isShowActivityLog = true;
  }


  clickeddeal(url) {
    this._workflowListFetching = true;
  }

  GetAllWorkflowStatus() {
    if (this.lststatus) {
      if (this.lststatus.length == 0) {
        this.WFSrv.getWorkflowStatus().subscribe(res => {
          if (res.Succeeded) {
            var data = res.dt;
            data = data.filter(x => x.StatusName != "Projected" && x.StatusName != "Completed");
            data.find(x => x.StatusName == "Under Review").StatusName = "Under Review/Requested";
            var lststatusName = data.map(x => x.StatusName);

            for (var j = 0; j < lststatusName.length; j++) {
              if (lststatusName[j] != "Projected" && lststatusName[j] != "Completed") {
                this.lststatus.push({ "StatusName": lststatusName[j], selected: lststatusName[j] });
              }
              else {
                this.lststatus.push({ "StatusName": lststatusName[j], selected: undefined });
              }
            }
            this.multiselStatus.headerFormat = "3 Status Selected";
            this.multiselStatus.showDropDownButton = true;
            // this.lststatus = res.dt;

          }
        })
      }
    }

  }

  onchangedcheckeditems(mode) {
    // if (s.checkedItems.length > 0) {
    var checked;
    if (mode == 'onload') {
      checked = this.multiselStatus.itemsSource.filter(x => x.selected != undefined);
      this.multiselStatus.checkedItems = checked;
    }
    else {
       checked = this.multiselStatus.checkedItems;
    }
    var lstchecked = checked.map(x => x.StatusName);

    for (var i = 0; i < lstchecked.length; i++) {
      if (lstchecked[i] == 'Under Review/Requested') {
        var wfstatus = lstchecked[i].split("/");
        for (var k = 0; k < wfstatus.length; k++) {
          lstchecked.push(wfstatus[k]);
        }
        //  lstchecked.splice(lstchecked[i], 1);

        var index = lstchecked.indexOf(lstchecked[i]);
        if (index !== -1) {
          lstchecked.splice(index, 1);
        }
      }
    }

    if (this.multiselStatus.checkedItems.length > 2)
      this.multiselStatus.headerFormat = this.multiselStatus.checkedItems.length + " Status Selected"

    this.lstworkflow = this.alllstworkflow.filter(function (itm) {
      return lstchecked.indexOf(itm.StatusName) > -1;
    });
    this.cvDashBoardList = new wjcCore.CollectionView(this.lstworkflow);
    this.cvDashBoardList.trackChanges = true;


    //var lstpayoff = this.alllstworkflow.filter(x => x.PurposeID == 316);
    //if (lstpayoff) {
    //  for (var i = 0; i < lstpayoff.length; i++) {
    //    this.lstworkflow.push(lstpayoff[i]);
    //  }
    //}

    //   }

  }

  private _bindGridDropdows() {

    var wfflexapprover = this.flex;

    if (wfflexapprover) {
      var colFirstName = wfflexapprover.columns.getColumn('UserID');
      if (colFirstName) {
        //colFirstName.showDropDown = true;
        //this.lstapprover = this.lstApproverUser.filter(x => x.ModuleId);
        colFirstName.dataMap = this._buildDataMap(this.lstapprover, 'UserID', 'FirstName');
      }
    }

  }
  private _buildDataMap(items: any, key: any, value: any): wjcGrid.DataMap {
    var map = [];
    if (items) {
      for (var i = 0; i < items.length; i++) {
        var obj = items[i];
        map.push({ key: obj[key], value: obj[value] });
      }
    }
    return new wjcGrid.DataMap(map, 'key', 'value');
  }

  SaveWFDashboard() {
    var approvertype: string;
    this._workflowListFetching = true;
    var  lst_WFDashBoard: any = [];
    this.lstworkflow.forEach(function (arrayItem) {
      lst_WFDashBoard.push({
        "UserID": arrayItem.UserID, "TaskID": arrayItem.TaskID, "TaskTypeID": arrayItem.TaskTypeID
      });
    });

    this.WFSrv.SaveWFDashboard(lst_WFDashBoard).subscribe(res => {
          if (res.Succeeded == true) {
            this._workflowListFetching = true;
            this._ShowmessagedivMsg = "FC Approver Updated successfully";
            this._Showmessagediv = true;
            setTimeout(() => {
              this._Showmessagediv = false;
            }, 2000);
            
      }
      this._workflowListFetching = false;
        });
  }
  convertDateToBindable(date) {
    var dateObj = null;
    if (date) {
      if (typeof (date) == "string") {
        date = date.replace("Z", "");
        dateObj = new Date(date);
      }
      else {
        dateObj = date;
      }
      if (dateObj != null) {
        return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear();
      }
    }
  }
  getTwoDigitString(number) {
    if (number.toString().length === 1)
      return "0" + number;
    return number;
  }
  
}


const routes: Routes = [

  { path: '', component: WorkflowListComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjInputModule, WjGridModule, WjGridFilterModule, WjGridDetailModule],
  declarations: [WorkflowListComponent]
})

export class workflowListModule { }

