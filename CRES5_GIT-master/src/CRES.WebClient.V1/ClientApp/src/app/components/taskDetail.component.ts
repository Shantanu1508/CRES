import { Component, NgModule, Input, Output, EventEmitter } from "@angular/core";
import { Router, ActivatedRoute, Params } from '@angular/router';
import { TaskManagement } from "../core/domain/taskManagement.model";
import { TaskManagerService } from '../core/services/taskManager.service';
import { MembershipService } from '../core/services/membership.service';
import { UtilityService } from '../core/services/utility.service';
import { FileUploadService } from '../core/services/fileUpload.service';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { Search } from "../core/domain/search.model";
import * as wjNg2Input from '@grapecity/wijmo.angular2.input';
import { WjInputModule } from '@grapecity/wijmo.angular2.input';
import { SignalRService } from './../Notification/signalR.service';
import appsettings from '../../../../appsettings.json';
//import { Notificationsettings } from '../../../../appsettings.json';
//import { Ng2FileInputModule, Ng2FileInputService, Ng2FileInputAction } from 'ng2-file-input';
declare var $: any;
@Component({
  selector: "taskdetail",
  templateUrl: "./taskDetail.html",
  providers: [TaskManagerService, MembershipService, FileUploadService]
})

export class TaskDetailComponent {
  //  private routes = Routes;

  taskid: any;
  task_username: any;
  _pagePath: any;
  public usernameID: any;
  public usernameText: any;
  public titlemsg: any;
  public _taskManagement: TaskManagement;
  lstlookupPriority: any;
  lstlookupTaskType: any;
  lstlookupStatus: any;
  public _dtUTCHours: number;
  public _userOffset: number;
  public _centralOffset: number;

  public fileList: FileList;
  public myFileInputIdentifier: string = "tHiS_Id_IS_sPeeCiAL";
  public actionLog: string = "";
  errors: Array<string> = [];
  dragAreaClass: string = 'dragarea';
  @Input() projectId: number = 0;
  @Input() sectionId: number = 0;
  @Input() fileExt: string = "JPG, GIF, PNG, TXT";
  @Input() maxFiles: number = 5;
  @Input() maxSize: number = 5; // 5MB
  @Output() uploadStatus = new EventEmitter();


  constructor(public taskManagerService: TaskManagerService,
    private route: ActivatedRoute,
    public _signalRService: SignalRService,
    private _router: Router,

    public membershipService: MembershipService,
    public utilityService: UtilityService,
    //private ng2FileInputService: Ng2FileInputService,
    public fileUploadService: FileUploadService) {

    var _date = new Date();
    this._dtUTCHours = _date.getTimezoneOffset() / 60; //_date.getUTCHours();
    //alert('date getTimezoneOffset' + _date.getTimezoneOffset() );
    this._userOffset = _date.getTimezoneOffset() * 60 * 1000; // user's offset time

    if (this._dtUTCHours < 6) {
      this._centralOffset = 6 * 60 * 60 * 1000; // 6 for central time - use whatever you need
    }
    else {
      this._centralOffset = this._dtUTCHours * 60 * 60 * 1000; // 6 for central time - use whatever you need
    }


    this.route.params.forEach((params: Params) => {
      if (params['id'] !== undefined) {
        this.taskid = params['id'];
        this._taskManagement = new TaskManagement('');
        this.GetAllLookups();
        this.SetTitleMessage();
        if (this.taskid != "00000000-0000-0000-0000-000000000000") {
          this.GetTaskByTaskID();
        }

      }

    });
  }
  SetTitleMessage(): void {
    if (this.taskid == "00000000-0000-0000-0000-000000000000") {
      this.titlemsg = "Create new task";
      this._taskManagement.Priority = 366;
      this._taskManagement.Status = 373;
      this.usernameID = "";
      this.usernameText = "";
    }
    else {
      this.titlemsg = "Edit task"
    }
  }
  GetAllLookups(): void {
    try {
      this.taskManagerService.getAllLookup().subscribe(res => {
        if (res.Succeeded) {
          var data = res.lstLookups;
          this.lstlookupPriority = data.filter(x => x.ParentID == "57");
          this.lstlookupTaskType = data.filter(x => x.ParentID == "58");
          this.lstlookupStatus = data.filter(x => x.ParentID == "59");
        }
        else {
          this._router.navigate(['login']);
        }
      });
    } catch (err) {
    }
  }

  convertDatetoGMT(date: Date) {
    if (date != null) {
      date = new Date(date);
      var _userOffset = date.getTimezoneOffset() * 60 * 1000; // user's offset time
      var _centralOffset = this._dtUTCHours * 60 * 60 * 1000; // 6 for central time - use whatever you need          
      date = new Date(date.getTime() - this._userOffset + this._centralOffset); // redefine variable          
      return date;
    }
    else
      return date;
  }


  validateandsave(): void {
    var errormsg = "";
    if (this._taskManagement.Summary == undefined || this._taskManagement.Summary == "") {
      errormsg = "<p>" + "Please enter summary." + "</p>";
    }
    if (this._taskManagement.TaskType == undefined || this._taskManagement.TaskType == null) {
      errormsg = errormsg + "<p>" + "Please select task type." + "</p>";
    }

    if (this._taskManagement.StartDate != null) {
      var inputDate = new Date(this._taskManagement.StartDate);
      var todaysDate = new Date();
      if (inputDate.setHours(0, 0, 0, 0) < todaysDate.setHours(0, 0, 0, 0)) {
        errormsg = errormsg + "<p>" + "Please enter start date greater than or equal to today." + "</p>";
      }
    }

    if (this._taskManagement.DeadlineDate != null) {
      var inputDate = new Date(this._taskManagement.DeadlineDate);
      var todaysDate = new Date();
      if (inputDate.setHours(0, 0, 0, 0) < todaysDate.setHours(0, 0, 0, 0)) {
        errormsg = errormsg + "<p>" + "Please enter deadline date greater than or equal to today." + "</p>";
      }
    }
    if (this._taskManagement.EstimatedCompletionDate != null) {
      var inputDate = new Date(this._taskManagement.EstimatedCompletionDate);
      var todaysDate = new Date();
      if (inputDate.setHours(0, 0, 0, 0) < todaysDate.setHours(0, 0, 0, 0)) {
        errormsg = errormsg + "<p>" + "Please enter estimated completion date greater than or equal to today." + "</p>";
      }
    }
    if (this._taskManagement.ActualCompletionDate != null) {
      var inputDate = new Date(this._taskManagement.ActualCompletionDate);
      var todaysDate = new Date();
      if (inputDate.setHours(0, 0, 0, 0) < todaysDate.setHours(0, 0, 0, 0)) {
        errormsg = errormsg + "<p>" + "Please enter actual completion date greater than or equal to today." + "</p>";
      }
    }

    if (errormsg == "") {
      this.InsertUpdateTask();
    }
    else {
      this.CustomAlert(errormsg);
    }

  }
  InsertUpdateTask(): void {
    var _module = '';


    var _env = 'local';
    try {
      this._taskManagement.TaskID = this.taskid;
      if (this._taskManagement.DeadlineDate != null) { this._taskManagement.DeadlineDate = this.convertDatetoGMT(this._taskManagement.DeadlineDate); }
      if (this._taskManagement.StartDate != null) { this._taskManagement.StartDate = this.convertDatetoGMT(this._taskManagement.StartDate); }
      if (this._taskManagement.ActualCompletionDate != null) { this._taskManagement.ActualCompletionDate = this.convertDatetoGMT(this._taskManagement.ActualCompletionDate); }
      if (this._taskManagement.EstimatedCompletionDate != null) { this._taskManagement.EstimatedCompletionDate = this.convertDatetoGMT(this._taskManagement.EstimatedCompletionDate); }
      if (this.usernameID != null) {
        this._taskManagement.AssignedTo = this.usernameID;
        this._taskManagement.AssignedToText = this.usernameText
      }
      if (Number(this._taskManagement.Priority) != null || Number(this._taskManagement.Priority) != 0) {
        this._taskManagement.PriorityText = this.lstlookupPriority.find(x => x.LookupID == this._taskManagement.Priority).Name
      }
      if (Number(this._taskManagement.Status) != null || Number(this._taskManagement.Status) != 0) {
        this._taskManagement.StatusText = this.lstlookupStatus.find(x => x.LookupID == this._taskManagement.Status).Name
      }
      if (Number(this._taskManagement.TaskType) != null || Number(this._taskManagement.TaskType) != 0) {
        this._taskManagement.TaskTypeText = this.lstlookupTaskType.find(x => x.LookupID == this._taskManagement.TaskType).Name
      }

      this.taskManagerService.InsertUpdateTask(this._taskManagement).subscribe(res => {
        if (res.Succeeded) {
          this.taskid = res.newtaskID

          this._pagePath = 'taskactivity/' + this.taskid;
          this._router.navigate([this._pagePath]);
          var Notificationmessage;
          var username = JSON.parse(localStorage.getItem('user'));
          if (this.taskid = "00000000-0000-0000-0000-000000000000") {
            Notificationmessage = "New Task added by" + username.FirstName + " " + username.LastName;
            _module = "Edit Task"
            //Notificationmessage  variable 
            //1 Module Name=Add task/Edit Task
            //2 Message =Actual message which display for Notification.
            //3 Envirement =local/DEV/QA

            Notificationmessage = _module + '|*|' + Notificationmessage + '|*|' + appsettings.Notificationsettings._notificationenvironment;

          }
          this._signalRService.SendTaskToOthers(this.taskid, Notificationmessage);

          //this.saveFiles();
        }
        else {
          this._router.navigate(['login']);
        }
      });
    } catch (err) {
    }
  }

  GetTaskByTaskID(): void {
    try {
      this.taskManagerService.getTaskByTaskID(this.taskid).subscribe(res => {
        if (res.Succeeded) {
          var data = res.TaskData;
          this._taskManagement = data;
          this.task_username = this._taskManagement.AssignedToText;
        }
        else {
          this._router.navigate(['login']);
        }
      });
    } catch (err) {
    }
  }

  checkDroppedDownChangedUserName(sender: wjNg2Input.WjAutoComplete, args) {
    var ac = sender;
    if (ac.selectedIndex == -1) {
      if (ac.text != this.task_username) {
        this.task_username = null;
        this.usernameID = null;
        this.usernameText = null;
      }
    }
    else {
      this.usernameID = ac.selectedValue;
      this.usernameText = ac.selectedItem.Valuekey;
      this.task_username = ac.selectedItem.Valuekey;
    }
  }

  DiscardChanges() {
    window.history.back();
  }

  private _cachedeal = {};
  private _result: any;
  private _searchObj: any;
  public _pageSizeSearch: number = 10;
  public _pageIndexSearch: number = 1;
  public _totalCountSearch: number = 0;

  getAutosuggestusername = this.getAutosuggestusernameFunc.bind(this);
  getAutosuggestusernameFunc(query, max, callback) {
    this._result = null;


    var self = this,
      result = self._cachedeal[query];
    if (result) {
      callback(result);
      return;
    }

    // not in cache, get from server
    var params = { query: query, max: max };
    this._searchObj = new Search(query);

    this.taskManagerService.getAutosuggestSearchUsername(this._searchObj, this._pageIndexSearch, this._pageSizeSearch).subscribe(res => {
      if (res.Succeeded) {
        var data: any = res.lstSearch;
        this._totalCountSearch = res.TotalCount;

        this._result = data;
        //show message for 1 sec. when no record found
        //if (this._result.length == 0)
        //{
        //    this._dvEmptySearchMsg = true;
        //    setTimeout(() => {
        //        this._dvEmptySearchMsg = false;
        //    }, 1000);
        //}
        var _valueType;
        // add 'DisplayName' property to result
        let items = [];
        for (var i = 0; i < this._result.length; i++) {
          var c = this._result[i];
          c.DisplayName = c.Valuekey;
        }
        //  this._isSearchDataFetching = false;
        // and return the result
        callback(this._result);
      }
      else {
        this.utilityService.navigateToSignIn();
      }
    });
    error => console.error('Error: ' + error)
  }

  CustomAlert(dialog): void {
    var winW = window.innerWidth;
    var winH = window.innerHeight;
    var dialogoverlay = document.getElementById('dialogoverlay');
    var dialogbox = document.getElementById('dialogbox');
    dialogoverlay.style.display = "block";
    dialogoverlay.style.height = winH + "px";
    dialogbox.style.left = (winW / 2) - (550 * .5) + "px";
    dialogbox.style.top = "100px";
    dialogbox.style.display = "block";
    document.getElementById('dialogboxhead').innerHTML = "CRES - web";
    document.getElementById('dialogboxbody').innerHTML = dialog;
    //document.getElementById('dialogboxfoot').innerHTML = '<span class="custombutton" onclientclick="this.ok()">OK</span>';
  }

  ok(): void {
    document.getElementById('dialogbox').style.display = "none";
    document.getElementById('dialogoverlay').style.display = "none";
  }

  public onAction(event: any) {
    console.log(event);
    this.actionLog += "\n currentFiles: " + this.getFileNames(event.currentFiles);
    console.log(this.actionLog);
    //let fileList: FileList = event.currentFiles;
    this.fileList = event.currentFiles;
    //this.saveFiles(this.fileList);
  }
  public onAdded(event: any) {
    this.actionLog += "\n FileInput: " + event.id;
    this.actionLog += "\n Action: File added";

  }
  public onRemoved(event: any) {
    this.actionLog += "\n FileInput: " + event.id;
    this.actionLog += "\n Action: File removed";
  }
  public onInvalidDenied(event: any) {
    this.actionLog += "\n FileInput: " + event.id;
    this.actionLog += "\n Action: File denied";
  }
  public onCouldNotRemove(event: any) {
    this.actionLog += "\n FileInput: " + event.id;
    this.actionLog += "\n Action: Could not remove file";
  }

  public resetFileInput(): void {
   // this.ng2FileInputService.reset(this.myFileInputIdentifier);
  }
  public logCurrentFiles(): void {
   // let files = this.ng2FileInputService.getCurrentFiles(this.myFileInputIdentifier);
    //this.actionLog += "\n The currently added files are: " + this.getFileNames(files);
  }
  private getFileNames(files: File[]): string {
    let names = files.map(file => file.name);
    return names ? names.join(", ") : "No files currently added.";
  }

  private isValidFiles(files) {
    // Check Number of files
    if (files.length > this.maxFiles) {
      this.errors.push("Error: At a time you can upload only " + this.maxFiles + " files");
      return;
    }
    this.isValidFileExtension(files);
    return this.errors.length === 0;
  }

  private isValidFileExtension(files) {
    // Make array of file extensions
    var extensions = (this.fileExt.split(','))
      .map(function (x) { return x.toLocaleUpperCase().trim() });
    for (var i = 0; i < files.length; i++) {
      // Get file extension
      var ext = files[i].name.toUpperCase().split('.').pop() || files[i].name;
      // Check the extension exists
      var exists = extensions.includes(ext);
      if (!exists) {
        this.errors.push("Error (Extension): " + files[i].name);
      }
      // Check file size
      this.isValidFileSize(files[i]);
    }
  }

  private isValidFileSize(file) {
    var fileSizeinMB = file.size / (1024 * 1000);
    var size = Math.round(fileSizeinMB * 100) / 100; // convert upto 2 decimal place
    if (size > this.maxSize)
      this.errors.push("Error (File Size): " + file.name + ": exceed file size limit of " + this.maxSize + "MB ( " + size + "MB )");
  }


  saveFiles() {
    //this.saveFiles(this.fileList);
    //alert('save');
    let files = this.fileList;
    //alert('save123456');
    this.errors = []; // Clear error
    // Validate file size and allowed extensions
    if (files.length > 0 && (!this.isValidFiles(files))) {
      this.uploadStatus.emit(false);
      return;
    }
    if (files.length > 0) {
      let formData: FormData = new FormData();
      for (var j = 0; j < files.length; j++) {
        formData.append("file[]", files[j], files[j].name);
      }
      var parameters = {
        projectId: this.projectId,
        sectionId: this.sectionId
      }
      this.fileUploadService.upload(formData, parameters)
        .subscribe(
          success => {
            this.uploadStatus.emit(true);
            console.log(success)
          },
          error => {
            this.uploadStatus.emit(true);
            this.errors.push(error.ExceptionMessage);
          })
    }
  }

}

const routes: Routes = [
  { path: '', component: TaskDetailComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, WjInputModule, RouterModule.forChild(routes)],// Ng2FileInputModule.forRoot()],
  declarations: [TaskDetailComponent]
})

export class taskDetailModule { }
