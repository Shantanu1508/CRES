import { Component, OnInit, AfterViewInit, ViewChild } from "@angular/core";
import { Router, ActivatedRoute } from '@angular/router';
import { TaskManagement } from "../core/domain/taskManagement.model";
import { TaskManagerService } from '../core/services/taskManager.service';
import { NotificationService } from '../core/services/notification.service'
import { NgModule } from '@angular/core';
import { UtilityService } from '../core/services/utility.service';
import { Paginated } from '../core/common/paginated.service';
import * as wjcGrid from '@grapecity/wijmo.grid';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';

@Component({
  selector: "deal",
  templateUrl: "./taskList.html",
  providers: [TaskManagerService, NotificationService]
})

export class TaskListComponent extends Paginated {
  dealMessage: string;
  userid: number;
  lstTask: any;
  chkeddisplay: boolean = false;
  public _Showmessagediv: boolean = false;
  public _ShowmessagedivMsg: string = '';
  public _TaskListFetching: boolean = false;
  public _task: Array<TaskManagement>;
  public _taskManagement: TaskManagement;
  @ViewChild('flex') flex: wjcGrid.FlexGrid;

  constructor(public TaskSrv: TaskManagerService,
    public utilityService: UtilityService,
    public notificationService: NotificationService,
    private _router: Router) {
    super(30, 1, 0);
    this._taskManagement = new TaskManagement('');
    //get all records except closed send 1
    this.GetTaskList(1);
    this.utilityService.setPageTitle("M61-Task List");
  }

  // Component views are initialized
  ngAfterViewInit() {
    // commit row changes when scrolling the grid

    this.flex.scrollPositionChanged.addHandler(() => {
      var myDiv = $('#flex').find('div[wj-part="root"]');
      if (myDiv.prop('offsetHeight') + myDiv.scrollTop() >= myDiv.prop('scrollHeight')) {
        if (this.flex.rows.length < this._totalCount) {
          this._pageIndex = this.pagePlus(1);
          if (this.chkeddisplay == true) {
            //show closed
            this.GetTaskList(0);
          } else {
            //hide close

            this.GetTaskList(1);
          }
        }
      }
    });
  }

  GetTaskList(all): void {
    if (localStorage.getItem('divSucessTask') == 'true') {
      this._Showmessagediv = true;
      this._ShowmessagedivMsg = localStorage.getItem('divSucessMsgTask');
      this._ShowmessagedivMsg = (this._ShowmessagedivMsg.replace('\"', '')).replace('\"', '');
      localStorage.setItem('divSucessTask', JSON.stringify(false));
      localStorage.setItem('divSucessMsgTask', JSON.stringify(''));
      setTimeout(function () {
        this._Showmessagediv = false;
      }.bind(this), 5000);
    }
    this._TaskListFetching = true;

    this._taskManagement.Status = all;
    this.TaskSrv.getAllTask(this._taskManagement, this._pageIndex, this._pageSize)
      .subscribe(res => {
        if (res.Succeeded) {
          var data: any = res.lstTask;
          this._totalCount = res.TotalCount;
          if (this._pageIndex == 1) {
            this.lstTask = data;
            //remove first cell selection
            this.flex.selectionMode = wjcGrid.SelectionMode.None;
          }
          else {
            data.forEach((obj, i) => { // FETCH ALL DATA AND PUSH IN FLEX GRID!!!
              //format date
              //this.flex.rows.push(new wjcGrid.Row(obj));
            });
            this.lstTask = this.lstTask.concat(data);
          }

          for (var i = 0; i < this.lstTask.length; i++) {
            if (this.lstTask[i].StartDate != '0001-01-01T00:00:00') {
              if (this.lstTask[i].StartDate == null) {
                this.lstTask[i].StartDate = null;
              } else {
                this.lstTask[i].StartDate = new Date(this.lstTask[i].StartDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
              }
            }
            else {
              this.lstTask[i].StartDate = null;
            }

            if (this.lstTask[i].DeadlineDate != '0001-01-01T00:00:00') {
              if (this.lstTask[i].DeadlineDate == null) {
                this.lstTask[i].DeadlineDate = null;
              } else {
                this.lstTask[i].DeadlineDate = new Date(this.lstTask[i].DeadlineDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
              }
            }
            else {
              this.lstTask[i].DeadlineDate = null;
            }

            if (this.lstTask[i].EstimatedCompletionDate != '0001-01-01T00:00:00') {
              if (this.lstTask[i].EstimatedCompletionDate == null) {
                this.lstTask[i].EstimatedCompletionDate = null;
              } else {
                this.lstTask[i].EstimatedCompletionDate = new Date(this.lstTask[i].EstimatedCompletionDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
              }
            }
            else {
              this.lstTask[i].EstimatedCompletionDate = null;
            }

            if (this.lstTask[i].ActualCompletionDate != '0001-01-01T00:00:00') {
              if (this.lstTask[i].ActualCompletionDate == null) {
                this.lstTask[i].ActualCompletionDate = null;
              } else {
                this.lstTask[i].ActualCompletionDate = new Date(this.lstTask[i].ActualCompletionDate.toString()).toLocaleDateString("en-US", { year: "numeric", month: "numeric", day: "numeric" });
              }
            }
            else {
              this.lstTask[i].ActualCompletionDate = null;
            }
          }

          setTimeout(function () {
            this.flex.invalidate();
            this.flex.autoSizeColumns(0, this.flex.columns.length, false, 20);
            this.flex.columns[4].width = 300;
            this.flex.columns[5].width = 300; // for Note Id
          }.bind(this), 1);

          setTimeout(() => {
            this._TaskListFetching = false;
          }, 2000);
        }
        else {
          this.utilityService.navigateToSignIn();
        }
      },
        error => {
          if (error.status == 401) {
            this.notificationService.printErrorMessage('Authentication required');
            this.utilityService.navigateToSignIn();
          }
        }

      );
  }

  AddNewTask(): void {
    this._router.navigate(['taskdetail/a', '00000000-0000-0000-0000-000000000000']);
  }

  Getclosedrecords(): void {
    if (this.chkeddisplay == true) {
      //hide close
      this.chkeddisplay = false;
      this.GetTaskList(1);
    } else {
      //show closed
      this.chkeddisplay = true
      this.GetTaskList(0);
    }
  }
}

const routes: Routes = [
  { path: '', component: TaskListComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjGridFilterModule],
  declarations: [TaskListComponent]
})

export class taskListModule { }
