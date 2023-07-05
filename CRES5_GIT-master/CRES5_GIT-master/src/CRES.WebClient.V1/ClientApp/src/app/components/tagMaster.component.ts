import { Component,ViewChild } from "@angular/core";
import { Router} from '@angular/router';
import * as wjcGrid from '@grapecity/wijmo.grid';
import { NgModule } from '@angular/core';
import { UtilityService } from '../core/services/utility.service';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { WjChartModule } from '@grapecity/wijmo.angular2.chart';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import { TagMasterService } from '../core/services/tagMaster.service';
import { MembershipService } from '../core/services/membership.service';
import { TagMaster } from "../core/domain/tagMaster.model";
import { User } from "../core/domain/user.model";
import { scenarioService } from '../core/services/scenario.service';
import { Scenario } from "../core/domain/scenario.model";
declare var $: any;
import { FileUploadService } from '../core/services/fileUpload.service';

@Component({
  selector: "tagmaster",
  templateUrl: "./tagMaster.html",
  providers: [TagMasterService, MembershipService, scenarioService, FileUploadService]
})
export class TagMasterComponent {
  public _pagePath: any;
  public listTagMaster: any;
  ScenarioId: string;
  ScenarioName: string;
  public tagMaster: TagMaster;
  public user: User;

  public _alertinfomessage: string;
  public _ShowSuccessmessageRolediv: boolean = false;
  public _ShowSuccessRolemessage: string;
  public _MsgText: string;
  public _ConfirmMsgText: string;
  public _alertinfodiv: boolean = false;
  public _IsShowMsg: boolean;
  public _isRoleSaving: boolean;
  public _Showgrid: boolean = false;
  public _isScenarioDownloading: boolean;
  public _isShowLoader: boolean = false;

  public ConfirmDialogBoxFor: string;
  public _ShowSucessdivMsg: string;
  public _ShowSucessdiv: boolean = false;
  public _isshowAddTag: boolean = false;
  public _isshowDeleteTag: boolean = false;
  public _scenariodc: Scenario;
  public _lstScenario: any;


  @ViewChild('flexTagMaster') flex: wjcGrid.FlexGrid;
  constructor(
    public tagMasterService: TagMasterService,
    public membershipService: MembershipService,
    public utilityService: UtilityService,
    public scenarioService: scenarioService,
    public fileUploadService: FileUploadService,
    private _router: Router) {

    this._isRoleSaving = false;
    this._IsShowMsg = false;
    this._Showgrid = false;

    this.tagMaster = new TagMaster("");
    this.user = JSON.parse(localStorage.getItem('user'));
    this.ConfirmDialogBoxFor = "";

    this.utilityService.setPageTitle("Tag-Master");
    this.GettagList();
    this._scenariodc = new Scenario('');
    this._lstScenario = this._scenariodc.LstScenarioUserMap;
    this.getAllDistinctScenario();


  }
  getAllDistinctScenario(): void {
    var _userData = JSON.parse(localStorage.getItem('user'));
    this._scenariodc.UserID = _userData.UserID;
    this.scenarioService.getAllScenarioDistinct(this._scenariodc).subscribe(res => {
      if (res.Succeeded) {
        if (res.lstScenarioUserMap.length > 0) {
          this._lstScenario = res.lstScenarioUserMap;
          this.ScenarioId = res.lstScenarioUserMap.filter(x => x.ScenarioName == "Default")[0].AnalysisID
        }
      }
    });
  }

  GettagList(): void {
    this.ScenarioId = window.localStorage.getItem("scenarioid");
    this.tagMaster.AnalysisID = this.ScenarioId;

    try {
      this.tagMasterService.GetTagMaster(this.tagMaster).subscribe(res => {
        if (res.Succeeded) {
          if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0 && res.UserPermissionList.filter(x => x.ModuleType == "Page").length > 0) {

            this.listTagMaster = res.TagMasterList;

            if (this.listTagMaster.length > 0) {
              this._Showgrid = true;
              this.ConvertToBindableDate(this.listTagMaster);
            }
            this.ApplyPermissions(res.UserPermissionList);
          } else {

            localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
            localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));

            this.utilityService.navigateUnauthorize();
          }
        }
        else {

        }
      });
    } catch (err) {
    }
  }

  ApplyPermissions(_object): void {

    for (var i = 0; i < _object.length; i++) {
      if (_object[i].ChildModule == 'btnAddTag') {
        this._isshowAddTag = true;
      }
      if (_object[i].ChildModule == 'btnDeleteTag') {
        this._isshowDeleteTag = true;
      }
    }
  }
  private ConvertToBindableDate(Data) {
    for (var i = 0; i < Data.length; i++) {

      if (this.listTagMaster[i].CreatedDate != null)
        this.listTagMaster[i].CreatedDate = this.convertDateToBindable(this.listTagMaster[i].CreatedDate);

    }
  }

  convertDateToBindable(date) {
    var dateObj = new Date(date);
    return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear() + " " + dateObj.getHours() + ":" + dateObj.getMinutes() + ":" + dateObj.getSeconds();
  }
  getTwoDigitString(number) {
    if (number.toString().length === 1)
      return "0" + number;
    return number;
  }


  CallConfirmBox() {
    if (this.ConfirmDialogBoxFor == 'AddTag') {
      this.SaveTag();
    }
    if (this.ConfirmDialogBoxFor == 'DeleteTag') {
      this.DeleteTag();
    }
  }

  DeleteTag(): void {
    this._isShowLoader = true;
    this.tagMasterService.DeleteTagByTagID(this.tagMaster).subscribe(res => {
      if (res.Succeeded) {
        this._isShowLoader = false;
        this.ClosePopUpConfirmBox();

        this._ShowSucessdivMsg = "Tag '" + this.tagMaster.TagName + "' has been deleted successfully."
        this._ShowSucessdiv = true;
        setTimeout(function () {
          this._ShowSucessdiv = false;
        }.bind(this), 4000);

        this.GettagList();
      }
      else {
        this._isShowLoader = false;
        this.ClosePopUpConfirmBox();
        this.GettagList();
      }
      error => {
        this._isShowLoader = false;
        this.ClosePopUpConfirmBox();
        this.GettagList();
      }
    });
  }

  DeleteLink_Click(obj): void {
    this.ConfirmDialogBoxFor = 'DeleteTag';
    this.tagMaster.TagMasterID = obj.TagMasterID;
    this.tagMaster.AnalysisID = obj.AnalysisID;
    this.tagMaster.TagName = obj.TagName;

    var customdialogbox = document.getElementById('customdialogbox');
    this._ConfirmMsgText = 'Are you sure you want to delete ' + this.tagMaster.TagName + ' for ' + obj.AnalysisName + ' scenario?';
    customdialogbox.style.display = "block";
    $.getScript("/js/jsDrag.js");

  }

  CreateTag(): void {

    this.ConfirmDialogBoxFor = 'AddTag';

    if (this.tagMaster.NewTagName.toString() == "") {
      this._alertinfodiv = true;
      this._alertinfomessage = "Please enter tag."

      setTimeout(function () {
        this._alertinfodiv = false;
      }.bind(this), 4000);


    }
    else {
      var Ftaglist;
      if (this.listTagMaster) {
        Ftaglist = this.listTagMaster.filter(x => x.TagName.toLowerCase() == this.tagMaster.NewTagName.toLowerCase())
      }


      if (Ftaglist.length == 0) {
        this.CallConfirmBox();

      } else {
        this._IsShowMsg = true;
        this._MsgText = "Tag: " + this.tagMaster.NewTagName + " already exists."
        setTimeout(function () {
          this._IsShowMsg = false;
        }.bind(this), 4000);
      }
    }

  }

  SaveTag(): void {

    this.ClosePopUpConfirmBox();
    //==============================
    this.tagMaster.TagMasterID = '00000000-0000-0000-0000-000000000000';
    this.tagMaster.AnalysisID = this.ScenarioId;
    this.tagMaster.TagName = this.tagMaster.NewTagName;
    this.tagMaster.TagDesc = this.tagMaster.NewTagDesc;

    //this._isRoleSaving = true;
    this.tagMasterService.InsertTagMaster(this.tagMaster).subscribe(res => {
      if (res.Succeeded) {
        this.tagMaster.NewTagName = "";
        this.tagMaster.NewTagDesc = "";

        //this._isRoleSaving = false;

        //this._ShowSuccessRolemessage = "Tag: " + this.tagMaster.TagName + " saved successfully."
        //this._ShowSuccessmessageRolediv = true;
        //setTimeout(function () {
        //    this._ShowSuccessmessageRolediv = false;
        //}.bind(this), 4000);


        this._ShowSucessdivMsg = "Tag '" + this.tagMaster.TagName + "' saved successfully."
        this._ShowSucessdiv = true;
        setTimeout(function () {
          this._ShowSucessdiv = false;
        }.bind(this), 4000);

        this.CloseCreateTagPopUp();
        this.GettagList();

      } else {

      }
    });
    //==============================
  }

  showCreateTagDialog(): void {
    this.tagMaster.NewTagName = "";
    this.tagMaster.NewTagDesc = "";

    this.ConfirmDialogBoxFor = 'AddTag';

    var modalRole = document.getElementById('myModalCreateTag');
    modalRole.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }

  CloseCreateTagPopUp(): void {
    var modal = document.getElementById('myModalCreateTag');
    modal.style.display = "none";
  }



  //download from azure
  //DownloadScenario(obj): void {
  //    this._isShowLoader = true;
  //    //this.ScenarioId = window.localStorage.getItem("scenarioid");
  //    this.ScenarioName = obj.AnalysisName

  //    this._isScenarioDownloading = true;
  //    this.tagMaster.TagMasterID = obj.TagMasterID;
  //    this.tagMaster.AnalysisID = obj.AnalysisID; //this.ScenarioId;
  //    this.tagMaster.TagName = obj.TagName;
  //    this.tagMaster.TagFileName = obj.TagFileName;
  //    this.tagMaster.NewTagFileName = obj.NewTagFileName;
  //    if (obj.TagFileName == null || obj.TagFileName == undefined || obj.TagFileName == '') {

  //        this.tagMasterService.uploadNoteCashflowsExportDataFromTransactionCloseToAzure(this.tagMaster).subscribe(res => {

  //            if (res.Succeeded) {
  //                //setTimeout(function () {
  //                //    this._isScenarioDownloading = false;
  //                //}.bind(this), 100);

  //                //this.downloadFile(res.dttagWiseCashflow);
  //                //this._isShowLoader = false;
  //                obj.TagFileName = obj.NewTagFileName
  //                this.DownloadTagFile(obj.NewTagFileName, obj.NewTagFileName, 'AzureBlob', '');
  //            }
  //            else {
  //                // this._dvEmptynoteperiodiccalcMsg = true;
  //            }
  //            error => {
  //                this._isShowLoader = false;
  //            }
  //        });
  //    }
  //    else
  //    {
  //        this.DownloadTagFile(obj.TagFileName, obj.TagFileName, 'AzureBlob', '');
  //    } 



  //}

  //normal download from db
  DownloadScenario(obj): void {
    this._isShowLoader = true;
    //this.ScenarioId = window.localStorage.getItem("scenarioid");
    this.ScenarioName = obj.AnalysisName

    this._isScenarioDownloading = true;
    this.tagMaster.TagMasterID = obj.TagMasterID;
    this.tagMaster.AnalysisID = obj.AnalysisID; //this.ScenarioId;
    this.tagMaster.TagName = obj.TagName;

    this.tagMasterService.getNoteCashflowsExportDataFromTransactionClose(this.tagMaster).subscribe(res => {

      if (res.Succeeded) {
        setTimeout(function () {
          this._isScenarioDownloading = false;
        }.bind(this), 100);

        this.downloadFile(res.dttagWiseCashflow);
        this._isShowLoader = false;
      }
      else {
        // this._dvEmptynoteperiodiccalcMsg = true;
      }
      error => {
        this._isShowLoader = false;
      }
    });
  }


  downloadFile(objArray) {
    this.user = JSON.parse(localStorage.getItem('user'));
    var data = this.ConvertToCSV(objArray);
    var displayDate = new Date().toLocaleDateString("en-US").replace(/\//g, '-');
    var displayTime = new Date().toLocaleTimeString("en-US").replace(/\:/g, '-');
    //var fileName = "Cashflow_" + this.tagMaster.TagName + "_" + this.ScenarioName + "_" + displayDate + "_" + displayTime + "_" + this.user.Login + ".csv";
    var fileName = this.tagMaster.TagName + "_" + this.ScenarioName + "_Cashflow_" + displayDate + "_" + displayTime + ".csv";

    let blob = new Blob(['\ufeff' + data], { type: 'text/csv;charset=utf-8;' });
    let dwldLink = document.createElement("a");
    let url = URL.createObjectURL(blob);
    let isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
    if (isSafariBrowser) {  //if Safari open in new window to save file with random filename.
      dwldLink.setAttribute("target", "_blank");
    }
    dwldLink.setAttribute("href", url);
    dwldLink.setAttribute("download", fileName);
    dwldLink.style.visibility = "hidden";
    document.body.appendChild(dwldLink);
    dwldLink.click();
    document.body.removeChild(dwldLink);
  }

  // convert Json to CSV data in Angular2
  ConvertToCSV(objArray) {
    var array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
    var str = '';
    var row = "";

    for (var index in objArray[0]) {
      //Now convert each value to string and comma-separated
      row += index + ',';
    }
    row = row.slice(0, -1);
    //append Label row with line break
    str += row + '\r\n';

    for (var i = 0; i < array.length; i++) {
      var line = '';
      for (var index in array[i]) {
        if (line != '') line += ','

        line += array[i][index];
      }
      str += line + '\r\n';
    }
    return str;
  }


  ClosePopUpConfirmBox() {
    this.ConfirmDialogBoxFor = "";

    var modal = document.getElementById('customdialogbox');
    modal.style.display = "none";
  }

  changeScenario(value): void {
    this.ScenarioId = value
  }

  DownloadTagFile(filename, originalfilename, storagetype, documentStorageID) {
    this._isShowLoader = true;
    documentStorageID = documentStorageID === undefined ? '' : documentStorageID

    var ID = '';
    if (storagetype == 'Box')
      ID = documentStorageID
    else if (storagetype == 'AzureBlob')
      ID = filename;


    this.fileUploadService.downloadObjectDocumentByStorageType(ID, storagetype)
      .subscribe(fileData => {
        let b: any = new Blob([fileData]);
        //var url = window.URL.createObjectURL(b);
        //window.open(url);

        let dwldLink = document.createElement("a");
        let url = URL.createObjectURL(b);
        let isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
        if (isSafariBrowser) {  //if Safari open in new window to save file with random filename.
          dwldLink.setAttribute("target", "_blank");
        }
        dwldLink.setAttribute("href", url);
        dwldLink.setAttribute("download", originalfilename);
        dwldLink.style.visibility = "hidden";
        document.body.appendChild(dwldLink);
        dwldLink.click();
        document.body.removeChild(dwldLink);
        this._isShowLoader = false;

      },
        error => {
          //  alert('Something went wrong');
          this._isShowLoader = false;
        }
      );
  }


}
const routes: Routes = [
  { path: '', component: TagMasterComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjChartModule, WjGridModule, WjGridFilterModule],
  declarations: [TagMasterComponent]
})

export class tagMasterModule { }
