import { Component, ViewChild } from '@angular/core';
import { Router } from '@angular/router';
import { NotificationService } from '../core/services/notification.service'
import { ReportService } from './../core/services/report.service'
import { UtilityService } from '../core/services/utility.service';
import { Paginated } from '../core/common/paginated.service';
import { Report } from "../core/domain/report.model"
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import * as wjcGrid from '@grapecity/wijmo.grid';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import { User } from '../core/domain/user.model';
import { reportFile } from '../core/domain/reportFile.model';
import { WjInputModule } from '@grapecity/wijmo.angular2.input';

@Component({
  selector: "reportpage",
  templateUrl: "./reportPage.html",
  providers: [ReportService, NotificationService]
})


export class ReportpageComponent extends Paginated {

  public _report: Report;
  public _isNoteListFetching: boolean = false;
  public _dvEmptyReportMsg: boolean = false;
  public _Showmessagediv: boolean = false;
  public _ShowmessagedivMsg: string = '';
  public _dvEmptyNoteSearchMsg: boolean = false;
  lstReport: any;
  powerbistatus_onmsg = "Turn off Power BI Service";
  powerbistatus_offmsg = "Turn on Power BI Service";
  turnonmsg = "Power BI Service currently turned off.You can turn on the service by clicking the link ‘Turn on Power BI Service’ on this page.It will take couple of minutes to start the service.";
  turnoffmsg = "Power BI Service currently turned on. You can trun off the service by clicking the link ‘Turn off Power BI Service’ on this page.";
  initialfetchingmsg = "We are fetching the current status of Power BI Service.";
  submittedreqonmsg = "Request to turn on the Service Submitted Successfully."
  submittedreqoffmsg = "Request to turn off the Service Submitted Successfully."
  public _fetchingstatus: boolean = false;
  public _aftersubmitrequest: boolean = false;
  public _userrolecheck: boolean = false;
  public _otheruserscheck: boolean = false;
  public _checkstatusofuserrole: boolean = false;
  public _ispowerbistatus: boolean = false;
  public _user: User;
  //acore reporting
  public _reportFileGUID = "";
  public _dvInValidJson: boolean = false;
  public _dvInValidJsonMsg: string = '';
  public _attributeValue = "";
  public _ShowmessagedivError: boolean = false;
  public _ShowmessagedivErrorMsg: string = '';
  public ReportGuid: string;
  public reportInputDate: any;
  public Status2: string;

  //public Status2: any = 'Show';
  public Status1: string;
  public BatchEndTime1: string;
  public BatchEndTime: string;
  public Status4: string;
  public BatchEndTime4: string;
  public Status3: string;
  public BatchEndTime3: string;

  //=======================Start Getwarehouse(Refresh Warehouse)====================================//


  warehouseStatus(btnname = "Refresh Data Warehouse") {
    this.reportService.GetwarehouseStatus(btnname).subscribe(res => {
      if (res.Succeeded) {


        if (res.Status2 == "Process Running") {
          /* alert("alert1");*/
          this.Status4 = res.Status2;
          this.BatchEndTime4 = '';
        }
        else if (res.Status2 == "Process InComplete") {

          this.Status4 = res.Status2 + '\r \n Last Updated ';

          this.BatchEndTime4 = res.BatchEndTime;
          this.BatchEndTime4 = this.convertDateToBindableWithTime(res.BatchEndTime);

        }
        else {
          /* alert("alert2");*/
          this.Status4 = res.Status2 + '\r \n Last Updated ';

          this.BatchEndTime4 = res.BatchEndTime;
          this.BatchEndTime4 = this.convertDateToBindableWithTime(res.BatchEndTime);


        }

      }
    });
  }

  showbackshopStatus(btnname = "Refresh Backshop Data") {
    this.reportService.GetwarehouseStatus(btnname).subscribe(res => {
      if (res.Succeeded) {

        if (res.Status2 == "Process Running") {
          this.Status1 = res.Status2 + ' ';
          this.BatchEndTime1 = '';
        }
        else if (res.Status2 == "Process InComplete") {
          this.Status1 = res.Status2 + '\r \n Last Updated ';
          this.BatchEndTime1 = res.BatchEndTime;
          this.BatchEndTime1 = this.convertDateToBindableWithTime(res.BatchEndTime);
        }
        else {
          this.Status1 = res.Status2 + '\r \n Last Updated ';
          this.BatchEndTime1 = res.BatchEndTime;
          this.BatchEndTime1 = this.convertDateToBindableWithTime(res.BatchEndTime);
        }
      }
    });
  }

  showentityStatus(btnname = "Refresh Entity Data") {
    this.reportService.GetwarehouseStatus(btnname).subscribe(res => {
      if (res.Succeeded) {

        if (res.Status2 == "Process Running") {
          this.Status3 = res.Status2;
          this.BatchEndTime3 = '';
        }
        else if (res.Status2 == "Process InComplete") {
          this.Status3 = res.Status2 + '\r \n Last Updated ';
          this.BatchEndTime3 = res.BatchEndTime;
          this.BatchEndTime3 = this.convertDateToBindableWithTime(res.BatchEndTime);
        }
        else {
          this.Status3 = res.Status2 + '\r \n Last Updated ';
          this.BatchEndTime3 = res.BatchEndTime;
          this.BatchEndTime3 = this.convertDateToBindableWithTime(res.BatchEndTime);
        }

      }
    });
  }


  //===================End Getwarehouse(Refresh Warehouse)====================================//



  //Status: string = '';
  // private routes = Routes;
  @ViewChild('flex') flex: wjcGrid.FlexGrid;
  public btnname: any;
  constructor(private _router: Router,
    public reportService: ReportService,
    public utilityService: UtilityService,
    public notificationService: NotificationService) {
    super(50, 1, 0);
    this.utilityService.setPageTitle("M61-Reports");
    this._user = JSON.parse(localStorage.getItem('user'));
    this.getReports();
    ////commented as we are not using it anymore
    //this.GetCRESPowerBIEmbeddedStatus();

    //this.powerbistatus_off = "Turn on Power BI Service";  //Red
    // this.turnonmsg = "Power BI Service currently turned off.You can turn on the service by clicking the button ‘Turn on Power BI Service’ on this page.It will take couple of minutes to start the service.";

  }

  ngOnInit() {
    jQuery.getScript('js/powerbi/angular.js');
    jQuery.getScript('js/powerbi/powerbi.js');
    jQuery.getScript('js/powerbi/angular-powerbi.js');

  }

  getReports(): void {

    this._isNoteListFetching = true;
    this.reportService.GetAllReport(this._pageIndex, this._pageSize).subscribe(res => {

      if (res.Succeeded) {
        var data: any = res.lstReport;
        this._totalCount = res.TotalCount;

        if (this._pageIndex == 1) {
          this.lstReport = data;

          //remove first cell selection
          this.flex.selectionMode = wjcGrid.SelectionMode.None;

          if (res.TotalCount == 0) {
            this._dvEmptyNoteSearchMsg = true;
            //setTimeout(() => {
            //    this._dvEmptyNoteSearchMsg = false;
            //}, 2000);
          }
          //this.getAllAcoreRepots();
        }
        else {
          //data.forEach((obj, i) => { // FETCH ALL DATA AND PUSH IN FLEX GRID!!!
          //    this.flex.rows.push(new wjcGrid.Row(obj));
          //});
          this.lstReport.concat(data);
        }
        this._isNoteListFetching = false;
      }
      else {
        //alert('else');
        //debugger;
        this._isNoteListFetching = false;
        this.utilityService.navigateToSignIn();
      }
    });
    error => console.error('Error: ' + error)
  }

  AssignId(_powerbiId: string) {
    localStorage.setItem('powerbiReportId', JSON.stringify(_powerbiId));
    // alert('done');
  }


  RefreshReport(): void {
    this._isNoteListFetching = true;
    this.reportService.GetimportReport().subscribe(res => {
      if (res.Succeeded) {
        this._Showmessagediv = true;
        this._isNoteListFetching = false;
        this._ShowmessagedivMsg = 'Data Warehouse updated Successfully.';
        setTimeout(function () {
          this._ShowSuccessmessagediv = false;
          this._Showmessagediv = false;
          this._ShowmessagedivMsg = '';
        }.bind(this), 5000);
      }
      else {
        this._isNoteListFetching = false;
        this._router.navigate(['login']);
      }
    });
  }

  //===============================Conversion=================================================================//

  convertDateToBindable(date) {
    if (date) {
      var dateObj = new Date(date);
      return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear();
    }
  }
  getTwoDigitString(number) {
    if (number.toString().length === 1)
      return "0" + number;
    return number;
  }


  convertDateToBindableWithTime(date) {
    var dateObj = new Date(date);
    return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear() + " " + dateObj.getHours() + ":" + dateObj.getMinutes() + ":" + dateObj.getSeconds();
  }



  DownloadNoteDataTape(): void {
    this._isNoteListFetching = true;

    this.reportService.DownloadNoteDataTape('0').subscribe(res => {
      if (res.Succeeded) {
        this._isNoteListFetching = false;
        this.downloadFile(res.lstDownloadNoteDataTape);
      }
      else {
        this._isNoteListFetching = false;
      }
      error => console.error('Error: ' + error)
    });

  }

  downloadFile(objArray) {
    var data = this.ConvertToCSV(objArray);
    var displayDate = new Date().toLocaleDateString("en-US");
    var fileName = "Download Data Tape-" + displayDate + ".csv";

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


  GetCRESPowerBIEmbeddedStatus() {
    var userrole = this._user.RoleName;
    this._otheruserscheck = true;
    this.reportService.CheckPowerBIStatusOnLoad().subscribe(res => {
      this._fetchingstatus = true;
      var data = res.Status;
      if (res.Succeeded) {
        if (userrole == "Super Admin" && data == "Resuming" || userrole == "Super Admin" && data == "Succeeded") {
          this._userrolecheck = true;
          this._aftersubmitrequest = false;
          this._checkstatusofuserrole = false;
          this._ispowerbistatus = true;
          this.powerbistatus_onmsg;  //Green
          this.turnoffmsg;
          clearTimeout(timeInterval);
        }

        else if (userrole != "Super Admin" && data == "Resuming" || userrole != "Super Admin" && data == "Succeeded") {
          this._checkstatusofuserrole = true;
        }
        else if (data == "Paused" || data == "Pausing") {
          this._ispowerbistatus = false;
          this._checkstatusofuserrole = false;
          this._userrolecheck = false;
          var timeInterval = setTimeout(function () {
            this._aftersubmitrequest = false;
            this.GetCRESPowerBIEmbeddedStatus();
            this.powerbistatus_offmsg;  //Red
            this.turnonmsg;
          }.bind(this), 100050);
        }
        else if (data == "") {
          this.GetCRESPowerBIEmbeddedStatus();
        }
      }
    });
  }

  updateCRESPowerBIEmbeddedStatus() {
    this._isNoteListFetching = true;
    this._aftersubmitrequest = true;
    var userrole = this._user.RoleName;
    this._otheruserscheck = true;
    this._fetchingstatus = true;
    this.reportService.updatePowerBIStatusOnLoad().subscribe(res => {
      var data = res.Status;
      if (res.Succeeded) {
        if (userrole == "Super Admin" && data == "Resuming" || userrole == "Super Admin" && data == "Succeeded") {
          this._checkstatusofuserrole = false;
          this._userrolecheck = true;
          this._aftersubmitrequest = false;
          this._ispowerbistatus = true;
          this.powerbistatus_onmsg;  //Green
          this.turnoffmsg;
        }

        else if (userrole != "Super Admin" && data == "Resuming" || userrole != "Super Admin" && data == "Succeeded") {
          this._checkstatusofuserrole = true;
        }
        else if (data == "Paused" || data == "Pausing") {
          this._checkstatusofuserrole = false;
          this._aftersubmitrequest = false;
          this._userrolecheck = false;
          this._ispowerbistatus = false;
          this.powerbistatus_offmsg;  //Red

        }
        else if (data == "") {
          this.GetCRESPowerBIEmbeddedStatus();
        }

        this._isNoteListFetching = false;
      }
    });
  }



  //acore report related methods
  ShowAttributesDialog(attributeValue, reportname) {
    this.ReportGuid = attributeValue;
    this.reportInputDate = '';
    var _isallowinput = this.lstReport.filter(x => x.ReportFileGUID == this.ReportGuid)[0];
    if (_isallowinput.IsAllowInput == true) {
      //this.ReportGuid = attributeValue;
      //$("#txtDefaultAttribute").val(reportname);
      $("#spnHeader").text(reportname + ' parameters');
      var modal = document.getElementById('ModalReportFileAttribute');
      modal.style.display = "block";
      $.getScript("/js/jsDrag.js");
    }
    else {
      //this.ReportGuid = attributeValue;
      this.GenearteAndDownloadReport();
    }
  }

  ClosePopUpReportFileAttribute() {
    var modal = document.getElementById('ModalReportFileAttribute');
    $('#txtDefaultAttribute').val('');
    modal.style.display = "none";
  }

  GenearteAndDownloadReport() {
    var errmsg = "";
    var ReportFileGUID = this.ReportGuid;
    var _objreportfile = this.lstReport.filter(x => x.ReportFileGUID == ReportFileGUID)[0];
    if (_objreportfile.IsAllowInput == true) {
      if (this.reportInputDate == undefined || this.reportInputDate == null || this.reportInputDate.toString() == "") {
        errmsg = "Please enter date.";
      }
    }
    if (errmsg != "") {
      this.CustomAlert(errmsg);
    }
    else {
      var month = new Date(this.reportInputDate).getMonth() + 1;
      var attributedate = { "Date": month + '/' + new Date(this.reportInputDate).getDate() + '/' + new Date(this.reportInputDate).getFullYear() };
      if (_objreportfile.DefaultAttributes !== undefined && _objreportfile.DefaultAttributes != null && _objreportfile.DefaultAttributes != "") {
        this._reportFileGUID = ReportFileGUID;
        this.ShowAttributesDialog(_objreportfile.DefaultAttributes, _objreportfile.Name);
      }
      else {
        this._reportFileGUID = "";
        if (_objreportfile.IsAllowInput == true) {
          this._attributeValue = JSON.stringify(attributedate);
        }
        else {
          this._attributeValue = null;
        }
        this.ClosePopUpReportFileAttribute();
        this.generateReport(_objreportfile.ReportFileGUID);
      }
    }
  }
  GenearteAndDownloadReportWithParam() {
    if (!this.isValidJson($("#txtDefaultAttribute").val())) {
      this._dvInValidJson = true;
      this._dvInValidJsonMsg = "Invalid json format";
      setTimeout(function () {
        this._dvInValidJson = false;
        this._dvInValidJsonMsg = "";
        //   console.log(this._ShowmessagedivWar);
      }.bind(this), 3000);
      return false;
    }
    else {
      var attributeval: any = $("#txtDefaultAttribute").val()
      this._attributeValue = attributeval;
      this.ClosePopUpReportFileAttribute();
      this.generateReport(this._reportFileGUID);
    }
  }

  isValidJson(jsonstring) {
    try {
      JSON.parse(jsonstring);
    } catch (e) {
      return false;
    }
    return true;
  }
  generateReport(ReportFileGUID): void {
    var _objreportfile = this.lstReport.filter(x => x.ReportFileGUID == ReportFileGUID)[0];
    var _reportFile = new reportFile();
    _reportFile.ReportFileGUID = ReportFileGUID;
    _reportFile.IsDownloadRequire = false;
    _reportFile.DefaultAttributes = this._attributeValue;
    this._isNoteListFetching = true;
    this.reportService.GenerateAccountingReport(_reportFile)
      .subscribe(res => {
        this._isNoteListFetching = false;
        if (_reportFile.IsDownloadRequire == false) {
          if (res.Succeeded) {
            //this._isNoteListFetching = false;
            var replog = res.ReportFileLog;
            this.DownloadDocument(replog.FileName, replog.OriginalFileName, replog.StorageTypeID, replog.StorageLocation, res.DocumentStorageID);

            this._Showmessagediv = true;
            this._ShowmessagedivMsg = "File generated successfully";
            setTimeout(function () {
              this._Showmessagediv = false;
              this._ShowmessagedivMsg = "";
              //   console.log(this._ShowmessagedivWar);
            }.bind(this), 5000);
          }
          else {
            this._ShowmessagedivError = true;
            this._ShowmessagedivErrorMsg = "Error in file generation,Please try after some time.";
            setTimeout(function () {
              this._ShowmessagedivError = false;
              this._ShowmessagedivErrorMsg = "";
              //   console.log(this._ShowmessagedivWar);
            }.bind(this), 5000);
          }
        }
        else {

          let b: any = new Blob([res]);
          //var url = window.URL.createObjectURL(b);
          //window.open(url);

          let dwldLink = document.createElement("a");
          let url = URL.createObjectURL(b);
          let isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
          if (isSafariBrowser) {  //if Safari open in new window to save file with random filename.
            dwldLink.setAttribute("target", "_blank");
          }
          dwldLink.setAttribute("href", url);
          dwldLink.setAttribute("download", _objreportfile.Name + '.' + _objreportfile.ReportFileFormat);
          dwldLink.style.visibility = "hidden";
          document.body.appendChild(dwldLink);
          dwldLink.click();
          document.body.removeChild(dwldLink);
          //this._isNoteListFetching = false;
          this._Showmessagediv = true;
          this._ShowmessagedivMsg = "File generated successfully";
          setTimeout(function () {
            this._Showmessagediv = false;
            this._ShowmessagedivMsg = "";
          }.bind(this), 5000);
        }
      },
        error => {
          //alert('Something went wrong');
          this._isNoteListFetching = false;;

        }

      );
  }

  DownloadDocument(filename, originalfilename, storagetypeID, storageLocation, documentStorageID) {

    documentStorageID = documentStorageID === undefined ? '' : documentStorageID

    //var _reportfilelog = new reportFileLog();
    //_reportfilelog.FileName = filename;
    //_reportfilelog.StorageLocation = storageLocation;
    //_reportfilelog.StorageTypeID = storagetypeID;
    //if (_reportfilelog.StorageTypeID == "459")
    //    _reportfilelog.FileName = documentStorageID;

    var ID = filename;
    if (storagetypeID == "459")
      ID = documentStorageID

    this.reportService.downloadObjectDocumentByStorageTypeAndLocation(ID, storagetypeID, storageLocation)
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
        this._isNoteListFetching = false;
      },
        error => {
          //alert('Something went wrong');
          this._isNoteListFetching = false;
        }
      );
  }
  //



  RefreshBSUnderwiting(): void {
    this._isNoteListFetching = true;
    this.reportService.GetRefreshBSUnderwriting().subscribe(res => {
      if (res.Succeeded) {
        this._Showmessagediv = true;
        this._isNoteListFetching = false;
        this._ShowmessagedivMsg = res.Message;
        setTimeout(function () {
          this._ShowSuccessmessagediv = false;
          this._Showmessagediv = false;
          this._ShowmessagedivMsg = '';
        }.bind(this), 5000);
      }
      else {
        this._isNoteListFetching = false;
        this._router.navigate(['login']);
      }
    });
  }


  RefreshEntityDataToDW(): void {
    this._isNoteListFetching = true;
    this.reportService.getrefreshentitydatatodw().subscribe(res => {
      if (res.Succeeded) {
        this._Showmessagediv = true;
        this._isNoteListFetching = false;
        this._ShowmessagedivMsg = res.Message;
        setTimeout(function () {
          this._ShowSuccessmessagediv = false;
          this._Showmessagediv = false;
          this._ShowmessagedivMsg = '';
        }.bind(this), 5000);
      }
      else {
        this._isNoteListFetching = false;
        this._router.navigate(['login']);

      }

    });
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
    document.getElementById('dialogboxhead').innerHTML = "CRES - Validation Error";
    document.getElementById('dialogboxbody').innerHTML = dialog;
    //document.getElementById('dialogboxfoot').innerHTML = '<span class="custombutton" onclientclick="this.ok()">OK</span>';
  }

  ok(): void {
    document.getElementById('dialogbox').style.display = "none";
    document.getElementById('dialogoverlay').style.display = "none";
  }
}


const routes: Routes = [

  { path: '', component: ReportpageComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjGridFilterModule, WjInputModule],
  declarations: [ReportpageComponent]

})

export class reportModule { }
