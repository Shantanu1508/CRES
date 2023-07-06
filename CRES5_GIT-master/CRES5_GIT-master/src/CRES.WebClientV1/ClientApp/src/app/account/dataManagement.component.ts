import { Component, ViewChild, Input, Output, EventEmitter } from "@angular/core";
import { Router} from '@angular/router';
import { MembershipService } from '../core/services/membership.service';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { NotificationService } from '../core/services/notification.service';
import { PermissionService } from '../core/services/permission.service';
import * as wjcGrid from '@grapecity/wijmo.grid';
import * as wjNg2Input from '@grapecity/wijmo.angular2.input';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import * as wjcCore from '@grapecity/wijmo';
import { deals } from "../core/domain/deals.model";
import { dealService } from '../core/services/deal.service';
import { UtilityService } from '../core/services/utility.service';
import { NoteService } from '../core/services/note.service';
import { Note } from "../core/domain/note.model";
import { Module } from "../core/domain/module.model";
//import { Ng2FileInputModule, Ng2FileInputService } from 'ng2-file-input';
import { FileUploadService } from '../core/services/fileUpload.service';
import { Document } from "../core/domain/document.model";
import { _storageType, _environmentNamae } from '../../../../appsettings.json';
import { Servicer } from "../core/domain/note.model";
import { WjInputModule } from '@grapecity/wijmo.angular2.input';




@Component({
  selector: 'datamanagement',
  providers: [NoteService, dealService, MembershipService, NotificationService, PermissionService, FileUploadService],
  templateUrl: './dataManagement.html'
})
export class DataManagement {

  public _ShowSuccessmessage !: string;
  public _ShowErrorMessage !: string;
  public data !: wjcCore.CollectionView;

  @ViewChild('flexpermission') flex !: wjcGrid.FlexGrid;
  @ViewChild('flex') Userflex !: wjcGrid.FlexGrid;
  @ViewChild('transactionflex') transactionflex !: wjcGrid.FlexGrid;
  @ViewChild('holidaycalendarflex') holidaycalendarflex !: wjcGrid.FlexGrid;
  public _MsgText !: string;
  public _deal: deals;
  public _dealListFetching: boolean = false;
  public lstdeal: any;

  public _note: Note;
  public _isNoteListFetching: boolean = false;
  public _notelist: any;
  public _dvEmptyDealSearchMsg: boolean = false;
  public _ShowSuccessmessagediv: boolean = false;
  public _isShowNoteGrid: boolean = false;
  public _isShowDealGrid: boolean = false;
  public _module: Module;
  public _isShowLoader: boolean = false;
  filename: any;
  public fileList !: FileList|null;
  public myFileInputIdentifier: string = "tHiS_Id_IS_sPeeCiAL";
  public actionLog: string = "";
  errors: Array<string> = [];
  @Input() fileExt: string = "XLS, XLSX";
  @Input() maxFiles: number = 5;
  @Input() maxSize: number = 15; //15MB
  @Output() uploadStatus = new EventEmitter();
  public _document !: Document;
  public _ShowmessagedivWar: boolean = false;
  public _ShowmessagedivMsgWar: string = '';
  hideenvqa: boolean = true;
  hideenvinteg: boolean = true;
  hideenvstag: boolean = true;
  public importingstatus: boolean = false;
  public importprocessbar: boolean = false;
  public environmentName = "";
  _envprod: boolean = true;
  public lstServicer: Array<Servicer> = [];
  public servicerdropdate !: number |null;
  public repaymentdropdate !: number |null;
  public servicermasterid !: number|null;
  public servicer: Servicer;
  public _errormessage: any;
  uploadtype: any;
  listtransactiontype: any = [];
  _transactiontypeslist !: wjcCore.CollectionView;
  lstCalculated: any;
  lstCashflowdownlaod: any;
  lstServicingRecocilliation: any;
  lstGAAPCalculations: any;
  lstAllowcalculationOverride: any;
  public _deltransactiontypeid: any;
  public deleteRowIndex !: number;
  public transactionerror: boolean = false;
  public lstHolidayCalendar: any = [];
  public lstHolidaycalendardate !: wjcCore.CollectionView;
  @ViewChild('multiselholidaycalendarname') multiselholidaycalendarname !: wjNg2Input.WjMultiSelect;
  public lstCalendarName: any = [];
  public newCalendarname: any = '';
  public changedCalendarId: any;
  public _dtUTCHours: number;
  public _userOffset: number;
  public _centralOffset: number;
  public myDefault: any = {
    HolidayMasterID: 411
  };
  public _isSavedHolidayDate: boolean = false;
  public _issyncbtnClicked: boolean = false;
  public rolename: any = '';
  public _isShowAllTabs: boolean = true;
  public _isShowsyncTabs: boolean = true;
  public _storageType = _storageType;
  public _environmentNamae = _environmentNamae;

  constructor(public notesvc: NoteService, public utilityService: UtilityService, public notificationService: NotificationService, public dealSrv: dealService, public membershipService: MembershipService,
    private router: Router,
    public permissionService: PermissionService, public fileUploadService: FileUploadService, //private ng2FileInputService: Ng2FileInputService
  ) {
    permissionService.GetUserPermissionBySuperAdmin();

    this._deal = new deals('');
    this._note = new Note('');
    this._module = new Module('');
    this.checkenv();
    this.servicer = new Servicer(null, null, null);

    var _date = new Date();
    this._dtUTCHours = _date.getTimezoneOffset() / 60; //_date.getUTCHours();
    this._userOffset = _date.getTimezoneOffset() * 60 * 1000; // user's offset time

    if (this._dtUTCHours < 6) {
      this._centralOffset = 6 * 60 * 60 * 1000; // 6 for central time - use whatever you need
    }
    else {
      this._centralOffset = this._dtUTCHours * 60 * 60 * 1000; // 6 for central time - use whatever you need
    }
    var rolename = window.localStorage.getItem("rolename");
    if (rolename != null) {
      this.rolename = rolename;
    }

  }

  searchDeal(): void {
    if (this._deal.CREDealID != '' && this._deal.CREDealID !== undefined) {
      this._dealListFetching = true;
      this._deal.DealID = this._deal.DealID.length != 36 ? '00000000-0000-0000-0000-000000000000' : this._deal.DealID;
      this.dealSrv.searchDealByCREDealIdOrDealName(this._deal)

        .subscribe(res => {
          if (res.Succeeded) {

            this.lstdeal = res.lstDeals;
            this._dealListFetching = false;
            if (this.lstdeal.length == 0) {
              this._isShowDealGrid = false;
              this._ShowErrorMessage = "No matching records found";
              this._dvEmptyDealSearchMsg = true;
              setTimeout(() => {
                this._dvEmptyDealSearchMsg = false;
              }, 5000);
            }
            else {
              this._isShowDealGrid = true;
            }
            setTimeout(() =>{
              this.flex.invalidate();
              this.flex.autoSizeColumns(0, this.flex.columns.length, false, 20);
              this.flex.columns[0].width = 350; // for Note Id
            }, 1);
            //
          }
          else {
            this._ShowErrorMessage = "Something went wrong.Please try after some time";
            this._dvEmptyDealSearchMsg = true;
            setTimeout(() => {
              this._dvEmptyDealSearchMsg = false;
            }, 5000);
            //this.utilityService.navigateToSignIn();
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
  }
  searchNote(): void {

    if (this._note.CRENoteID != '' && this._note.CRENoteID !== undefined) {
      this._isNoteListFetching = true;
      this.notesvc.searchNoteByCRENoteId(this._note)

        .subscribe(res => {
          if (res.Succeeded) {
            this._notelist = res.lstNotes;
            this._isNoteListFetching = false;

            if (this._notelist.length == 0) {
              this._isShowNoteGrid = false;
              this._ShowErrorMessage = "No matching records found";
              this._dvEmptyDealSearchMsg = true;
              setTimeout(() => {
                this._dvEmptyDealSearchMsg = false;
              }, 5000);
            }
            else {
              this._isShowNoteGrid = true;
            }

            //
          }
          else {
            this._ShowErrorMessage = "Something went wrong.Please try after some time";
            this._dvEmptyDealSearchMsg = true;
            setTimeout(() => {
              this._dvEmptyDealSearchMsg = false;
            },5000);
            //this.utilityService.navigateToSignIn();
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
  }


  deleteModuleByID(): void {
    this._isNoteListFetching = true;
    this._isShowLoader = true;
    this.ClosePopUp();
    this._module.DealID = this._module.DealID.length != 36 ? '00000000-0000-0000-0000-000000000000' : this._module.DealID;
    this._module.ModuleID = this._module.ModuleID.length != 36 ? '00000000-0000-0000-0000-000000000000' : this._module.ModuleID;
    this.dealSrv.deleteModuleByID(this._module)

      .subscribe(res => {
        if (res.Succeeded) {


          this._isShowLoader = false;
          if (this._module.ModuleName == "Deal") {
            this._isShowDealGrid = false;
            this._deal.CREDealID = "";
          }
          else {
            this._isShowNoteGrid = false;
            this._note.CRENoteID = "";
          }

          this._ShowSuccessmessage = 'Record deleted successfully.'
          this._ShowSuccessmessagediv = true;
          setTimeout(() => {
            this._ShowSuccessmessagediv = false;
          }, 5000);

          //
        }
        else {
          this.ClosePopUp();
          this._isShowLoader = false;
          this._ShowErrorMessage = "Something went wrong.Please try after some time";
          this._dvEmptyDealSearchMsg = true;
          setTimeout(() => {
            this._dvEmptyDealSearchMsg = false;
          }, 5000);
          //this.utilityService.navigateToSignIn();
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

  showDialog(deletetype: string, moduleID: string, dealID: string, credealornoteId: string, dealornoteName: string) {
    var customdialogbox:any = document.getElementById('customdialogbox');
    customdialogbox.style.display = "block";
    this._module.ModuleID = moduleID;
    this._module.ModuleName = 'Note';

    this._module.DealID = dealID;
    if (deletetype == 'Deal') {
      this._module.ModuleName = 'Deal'

    }
    this._MsgText = 'You will not be able to recover the deleted ' + this._module.ModuleName.toLowerCase() + ' data. Are you sure you want to delete the ' + this._module.ModuleName.toLowerCase() + ': [' + credealornoteId + '] - [' + dealornoteName + ']?';
    $.getScript("/js/jsDrag.js");
  }

  ClosePopUp() {
    var modal:any = document.getElementById('customdialogbox');
    modal.style.display = "none";
    //this.isProcessComplete = false;
  }

  public onAdded(event: any, id: any) {
    this.filename = event.file.name;
    this.showWellsDialog();
  }
  public onAction(event: any, uploadtype: any) {
    debugger;
    this.fileList = event.currentFiles;
    this.uploadtype = uploadtype;

  }
  showWellsDialog() {
    var modaltrans:any = document.getElementById('myModal');
    modaltrans.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }

  CloseWellsPopUp() {
    //  this.isProcessComplete = false;
    var modal:any = document.getElementById('myModal');
    modal.style.display = "none";
  }

  ImportFile() {
    this.CloseWellsPopUp();
    this.saveFiles();
  }

  saveFiles() {
    this._isShowLoader = true;
    let files = this.fileList;
    this.errors = []; // Clear error
    debugger;
    if (!(Boolean(files)) || files == null || files.length == 0) {
      this.errors.push("Please select file with " + this.fileExt + " extension.");
      this.CustomAlert(this.errors);
      this._isShowLoader = false;
      return;
    }
    // Validate file size and allowed extensions
    else if (files.length > 0 && (!this.isValidFiles(files))) {
      this.CustomAlert(this.errors);
      this.uploadStatus.emit(false);
      this._isShowLoader = false;
      return;
    }
    else if (files.length > 0) {
      debugger;
      let formData: FormData = new FormData();
      for (var j = 0; j < files.length; j++) {
        formData.append("file[]", files[j], files[j].name);
      }
      var userdata:any = localStorage.getItem('user');
      var user = JSON.parse(userdata);
      var parameters = {
        userid: user.UserID,
        ObjectTypeID: 588,
        StorageType: this._storageType,
        UploadType: this.uploadtype
      }

      this.fileUploadService.uploadObjectDocumentByStorageType(formData, parameters)
        .subscribe(
          success => {
            var smessage = success.toString().split('==');
            if (smessage[0] == "Success") {
              this.uploadStatus.emit(true);
              this._ShowSuccessmessage = 'File uploaded successfully.'
              this._ShowSuccessmessagediv = true;
              setTimeout(() => {
                this._ShowSuccessmessagediv = false;
                this._ShowSuccessmessage = "";
              }, 5000);
            }
            else {
              this.uploadStatus.emit(true);
              this._ShowmessagedivMsgWar = smessage[1];
              this._ShowmessagedivWar = true;
              setTimeout(() => {
                this._ShowmessagedivWar = false;
                this._ShowmessagedivMsgWar = "";
              }, 5000);
            }
            this._isShowLoader = false;
            this.fileList = null;
          },
          error => {
            console.log(error);
            this._isShowLoader = false;
            this.uploadStatus.emit(true);
            this.errors.push(error.ExceptionMessage);
          })
    }
  }
  private isValidFiles(files:any) {
    // Check Number of files
    if (files.length > this.maxFiles) {
      this.errors.push("At a time you can upload only " + this.maxFiles + " file <BR/>");
      return;
    }
    this.isValidFileExtension(files);
    return this.errors.length === 0;
  }

  private isValidFileExtension(files:any) {
    // Make array of file extensions
    var extensions = (this.fileExt.split(','))
      .map(function (x) { return x.toLocaleUpperCase().trim() });
    for (var i = 0; i < files.length; i++) {
      // Get file extension
      var ext = files[i].name.toUpperCase().split('.').pop() || files[i].name;
      // Check the extension exists
      var exists = extensions.includes(ext);
      if (!exists) {
        this.errors.push("<BR/>Please upload file " + files[i].name + " with " + this.fileExt + " extension.");
      }
      // Check file size
      this.isValidFileSize(files[i]);
    }
  }

  private isValidFileSize(file:any) {
    var fileSizeinMB = file.size / (1024 * 1000);
    var size = Math.round(fileSizeinMB * 100) / 100; // convert upto 2 decimal place
    if (size > this.maxSize)
      this.errors.push("<BR/>Selected: " + file.name + ": exceed file size limit of " + this.maxSize + "MB ( " + size + "MB )");
  }
  CustomAlert(dialog:any): void {
    var winW = window.innerWidth;
    var winH = window.innerHeight;
    var dialogoverlay:any = document.getElementById('dialogoverlay');
    var dialogbox:any = document.getElementById('dialogbox');
    dialogoverlay.style.display = "block";
    dialogoverlay.style.height = winH + "px";
    dialogbox.style.left = (winW / 2) - (550 * .5) + "px";
    dialogbox.style.top = "100px";
    dialogbox.style.display = "block";
    var dialogboxhead: any = document.getElementById('dialogboxhead');
    var doalogboxbody: any = document.getElementById('dialogboxbody');
    dialogboxhead.innerHTML = "CRES - Validation Error";
    doalogboxbody.innerHTML = dialog;
    //document.getElementById('dialogboxfoot').innerHTML = '<span class="custombutton" onclientclick="this.ok()">OK</span>';
  }
  public resetFileInput(): void {
    //this.ng2FileInputService.reset(this.myFileInputIdentifier);
  }
  ok(): void {
    var dialogoverlay: any = document.getElementById('dialogoverlay');
    var dialogbox: any = document.getElementById('dialogbox');
    dialogoverlay.style.display = "none";
    dialogbox.style.display = "none";
    this.CloseWellsPopUp();
  }


  checkenv() {
    this.environmentName = this._environmentNamae;
    if (this.environmentName.trim() == "- QA") {
      this.hideenvqa = false;
    }
    if (this.environmentName.trim() == "- St") {
      this.hideenvstag = false;
    }
    if (this.environmentName.trim() == "- In") {
      this.hideenvinteg = false;
    }
    if (this.environmentName.trim() == "") {
      this._envprod = false;
    }
  }


  importDeal() {
    var checkdealmsg = "";
    this.importprocessbar = true;

    if (this._deal.CREDealID == null) {
      checkdealmsg = checkdealmsg + "<p>" + "Source CREDealID is a required field.";

    }
    if (this._deal.envname == null) {
      checkdealmsg = checkdealmsg + "<p>" + "Source Environment is a required field.";

    }
    if (this._deal.CopyDealID == null) {
      checkdealmsg = checkdealmsg + "<p>" + "NewCREDealID is a required field.";

    }
    if (this._deal.CopyDealName == null) {
      checkdealmsg = checkdealmsg + "<p>" + "NewDealName is a required field.";

    }
    if (this._deal.CREDealID == this._deal.CopyDealID && this._deal.CREDealID != null) {
      checkdealmsg = checkdealmsg + "Credealid and NewcredealId can not be same";
    }

    if (!checkdealmsg) {
      this.dealSrv.ImportDeal(this._deal).subscribe(res => {
        if (res.Succeeded) {
          this.importprocessbar = false;
          if (res.TotalCount == 0) {
            checkdealmsg = checkdealmsg + "<p>" + "Deal imported successfully and sent to calculation ";
            this.importingstatus = true;
          }
          else if (res.TotalCount == 2) {
            checkdealmsg = checkdealmsg + "<p>" + "Deal does not exist in source environment";
          }
          else {
            checkdealmsg = checkdealmsg + "<p>" + this._deal.CopyDealID + " already exists";
          }
        }
        this.CustomAlert(checkdealmsg);
      });
    }
    else {
      this.importprocessbar = false;
      this.CustomAlert(checkdealmsg);
    }
  }

  GetAllServicer() {
    this._isShowLoader = true;
    this.permissionService.GetAllServicer().subscribe(res => {
      if (res.Succeeded == true) {
        this._isShowLoader = false;
        this.lstServicer = res.ServicerList;
      }
    });
  }

  ServicerNameChange(newval: any, servicerboxname: any): void {
    var newvalue = newval.target.value
    for (var i = 0; i < this.lstServicer.length; i++) {
      if (servicerboxname == "Name") {
        if (this.lstServicer[i].ServicerMasterID == newvalue) {
          this.servicermasterid = this.lstServicer[i].ServicerMasterID;
          this.repaymentdropdate = this.lstServicer[i].RepaymentDropDate;
          this.servicerdropdate = this.lstServicer[i].ServicerDropDate;

        }
      }
      if (this.lstServicer[i].ServicerMasterID == this.servicermasterid) {
        if (servicerboxname == "ServicerDropDate") {
          this.servicerdropdate = newvalue;
        }
        if (servicerboxname == "RepaymentDropDate") {
          this.repaymentdropdate = newvalue;
        }
      }
    }
  }

  SaveServicer(): void {
    this._errormessage = "";
    var runvalidation = false;
    var servicermsg = "";

    this.servicer.ServicerMasterID = this.servicermasterid;
    this.servicer.ServicerDropDate = this.servicerdropdate;
    this.servicer.RepaymentDropDate = this.repaymentdropdate;
    if (this.servicer.ServicerDropDate == undefined || this.servicer.RepaymentDropDate == undefined || this.servicer.ServicerMasterID == undefined) {
      this._errormessage = "Please select servicer name.";
      this.CustomAlert(this._errormessage);
    }
    if (this.servicer.ServicerDropDate != null) {
      if (this.servicer.ServicerDropDate.toString() < "1" || this.servicer.ServicerDropDate.toString() > "28") {
        servicermsg = servicermsg + "servicer drop date,";
        if (this.servicer.RepaymentDropDate != null) {
          if (this.servicer.RepaymentDropDate.toString() < "1" || this.servicer.RepaymentDropDate.toString() > "28") {
            runvalidation = true;
          }
        }
      }
    }
    else {
      runvalidation = true;
    }

    if (runvalidation == true) {
      if (this.servicer.RepaymentDropDate != null) {
        if (this.servicer.RepaymentDropDate.toString() < "1" || this.servicer.RepaymentDropDate.toString() > "28") {
          servicermsg = servicermsg + " repayment drop date ";
        }
      }
    }

    if (servicermsg) {
      this._errormessage = this._errormessage + "Please enter " + servicermsg.slice(0, -1) + " between 1 to 28.";
      this.CustomAlert(this._errormessage);
    }

    if (runvalidation == false) {
      servicermsg = "";
    }
    if (!this._errormessage) {
      this.permissionService.SaveServicerByServicerID(this.servicer).subscribe(res => {
        if (res.Succeeded == true) {
          this._ShowSuccessmessage = "Servicer updated successfully.";
          this._ShowSuccessmessagediv = true;
          setTimeout(() => {
            this._ShowSuccessmessagediv = false;
          }, 5000);
        }
        else {
          this._ShowErrorMessage = "Something went wrong.Please try after some time.";
          this._dvEmptyDealSearchMsg = true;
          setTimeout(() => {
            this._dvEmptyDealSearchMsg = false;
          }, 5000);
        }
      });
    }
  }

  addFooterRow(flexGrid:any) { //: wjcGrid.FlexGrid
    var row = new wjcGrid.GroupRow(); // create a GroupRow to show aggregates
    flexGrid.columnFooters.rows.push(row); // add the row to the column footer panel
    flexGrid.bottomLeftCells.setCellData(0, 0, '\u03A3');
    // sigma on the header       
  }

  GetAllLookups(): void {
    this.dealSrv.getAllLookup().subscribe(res => {
      var data = res.lstLookups;
      this.lstCalculated = data.filter((x:any)=> x.ParentID == "2");
      this.lstCashflowdownlaod = data.filter((x: any) => x.ParentID == "2");
      this.lstAllowcalculationOverride = data.filter((x: any) => x.ParentID == "2");
      this.lstGAAPCalculations = data.filter((x: any) => x.ParentID == "2");
      this.lstServicingRecocilliation = data.filter((x: any) => x.ParentID == "2");
      this._bindGridDropdows();
    });
  }


  private _bindGridDropdows() {
    var transflex = this.transactionflex;
    if (transflex) {
      var colCalculated = transflex.columns.getColumn('CalculatedText');
      var colCashflowdownlaod = transflex.columns.getColumn('IncludeCashflowDownloadText');
      var colServicingRecocilliation = transflex.columns.getColumn('IncludeServicingReconciliationText');
      var colGAAPCalculations = transflex.columns.getColumn('IncludeGAAPCalculationsText');
      var colAllowcalculationOverride = transflex.columns.getColumn('AllowCalculationOverrideText');

      if (colCalculated) {
        //colCalculated.showDropDown = true;
        colCalculated.dataMap = this._buildDataMap(this.lstCalculated);
      }
      if (colCashflowdownlaod) {
        //colCashflowdownlaod.showDropDown = true;
        colCashflowdownlaod.dataMap = this._buildDataMap(this.lstCashflowdownlaod);
      }
      if (colServicingRecocilliation) {
        //colServicingRecocilliation.showDropDown = true;
        colServicingRecocilliation.dataMap = this._buildDataMap(this.lstServicingRecocilliation);
      }
      if (colGAAPCalculations) {
        //colGAAPCalculations.showDropDown = true;
        colGAAPCalculations.dataMap = this._buildDataMap(this.lstGAAPCalculations);
      }
      if (colAllowcalculationOverride) {
       // colAllowcalculationOverride.showDropDown = true;
        colAllowcalculationOverride.dataMap = this._buildDataMap(this.lstAllowcalculationOverride);
      }
    }
  }

  // build a data map from a string array using the indices as keys
  private _buildDataMap(items:any): wjcGrid.DataMap {
    var map = [];

    for (var i = 0; i < items.length; i++) {
      var obj = items[i];
      map.push({ key: obj['LookupID'], value: obj['Name'] });
    }
    return new wjcGrid.DataMap(map, 'key', 'value');
  }

  getTransactionTypes() {
    this._isShowLoader = true;
    this.permissionService.GetTransactionTypes().subscribe(res => {
      if (res.Succeeded == true) {
        this._isShowLoader = false;
        var data = res.dt;
        this.listtransactiontype = data;

        this._transactiontypeslist = new wjcCore.CollectionView(data);
        this._transactiontypeslist.trackChanges = true;

        this.GetAllLookups();
        this.transactionflex.invalidate();
        //setTimeout(function(){
        //    this.transactionflex.invalidate();
        //}.bind(this),100);
      }
      else {
        this._isShowLoader = false;
        var data = null;
        this._transactiontypeslist = new wjcCore.CollectionView(data);
        this._transactiontypeslist.trackChanges = true;
        this.GetAllLookups();
        this.transactionflex.invalidate();
      }
    });
  }
  AssignvaluestoTransactiontypeDropdown(data:any) {
    var datatext;
    if (data == 4 || data == "4") {
      datatext = "N";
    }
    else if (data == 3 || data == "3") {
      datatext = "Y";
    }
    else {
      datatext = data;
    }
    return datatext;
  }

  CopiedTransactiontypes(s: wjcGrid.FlexGrid, e: wjcGrid.CellEditEndingEventArgs) {
    for (var k = 0; k < this.transactionflex.rows.length - 1; k++) {
      if (!(Number(this.transactionflex.rows[k].dataItem["CalculatedText"]).toString() == "NaN" || Number(this.transactionflex.rows[k].dataItem["CalculatedText"]) == 0)) {
        this.transactionflex.rows[k].dataItem["Calculated"] = this.transactionflex.rows[k].dataItem["CalculatedText"];
        this.transactionflex.rows[k].dataItem["CalculatedText"] = this.AssignvaluestoTransactiontypeDropdown(this.transactionflex.rows[k].dataItem["CalculatedText"]);
        var calculateddata = this.transactionflex.rows[k].dataItem["CalculatedText"];
        if (!(calculateddata == "Y" || calculateddata == "3")) {
          this.transactionflex.rows[k].dataItem["AllowCalculationOverrideText"] = null;
          this.transactionflex.rows[k].dataItem["AllowCalculationOverride"] = null;
        }
      }
      else {
        this.transactionflex.rows[k].dataItem["Calculated"] = this.transactionflex.rows[k].dataItem["Calculated"];
      }
      if (!(Number(this.transactionflex.rows[k].dataItem["IncludeCashflowDownloadText"]).toString() == "NaN" || Number(this.transactionflex.rows[k].dataItem["IncludeCashflowDownloadText"]) == 0)) {
        this.transactionflex.rows[k].dataItem["IncludeCashflowDownload"] = this.transactionflex.rows[k].dataItem["IncludeCashflowDownloadText"];
        this.transactionflex.rows[k].dataItem["IncludeCashflowDownloadText"] = this.AssignvaluestoTransactiontypeDropdown(this.transactionflex.rows[k].dataItem["IncludeCashflowDownloadText"]);
      }
      else {
        this.transactionflex.rows[k].dataItem["IncludeCashflowDownload"] = this.transactionflex.rows[k].dataItem["IncludeCashflowDownload"];
      }

      if (!(Number(this.transactionflex.rows[k].dataItem["IncludeServicingReconciliationText"]).toString() == "NaN" || Number(this.transactionflex.rows[k].dataItem["IncludeServicingReconciliationText"]) == 0)) {
        this.transactionflex.rows[k].dataItem["IncludeServicingReconciliation"] = this.transactionflex.rows[k].dataItem["IncludeServicingReconciliationText"];
        this.transactionflex.rows[k].dataItem["IncludeServicingReconciliationText"] = this.AssignvaluestoTransactiontypeDropdown(this.transactionflex.rows[k].dataItem["IncludeServicingReconciliationText"]);
      }
      else {
        this.transactionflex.rows[k].dataItem["IncludeServicingReconciliation"] = this.transactionflex.rows[k].dataItem["IncludeServicingReconciliation"];
      }
      if (!(Number(this.transactionflex.rows[k].dataItem["IncludeGAAPCalculationsText"]).toString() == "NaN" || Number(this.transactionflex.rows[k].dataItem["IncludeGAAPCalculationsText"]) == 0)) {
        this.transactionflex.rows[k].dataItem["IncludeGAAPCalculations"] = this.transactionflex.rows[k].dataItem["IncludeGAAPCalculationsText"];
        this.transactionflex.rows[k].dataItem["IncludeGAAPCalculationsText"] = this.AssignvaluestoTransactiontypeDropdown(this.transactionflex.rows[k].dataItem["IncludeGAAPCalculationsText"]);
      }
      else {
        this.transactionflex.rows[k].dataItem["IncludeGAAPCalculations"] = this.transactionflex.rows[k].dataItem["IncludeGAAPCalculations"];
      }

      if (!(Number(this.transactionflex.rows[k].dataItem["AllowCalculationOverrideText"]).toString() == "NaN" || Number(this.transactionflex.rows[k].dataItem["AllowCalculationOverrideText"]) == 0)) {
        this.transactionflex.rows[k].dataItem["AllowCalculationOverride"] = this.transactionflex.rows[k].dataItem["AllowCalculationOverrideText"];
        this.transactionflex.rows[k].dataItem["AllowCalculationOverrideText"] = this.AssignvaluestoTransactiontypeDropdown(this.transactionflex.rows[k].dataItem["AllowCalculationOverrideText"]);
      }
      else {
        this.transactionflex.rows[k].dataItem["AllowCalculationOverride"] = this.transactionflex.rows[k].dataItem["AllowCalculationOverride"];
      }
    }
  }


  cellEditTransactionTypes(s: wjcGrid.FlexGrid, e: wjcGrid.CellEditEndingEventArgs) {
    if (e.col == 3) {
      if (!(Number(this.transactionflex.rows[e.row].dataItem["CalculatedText"]).toString() == "NaN" || Number(this.transactionflex.rows[e.row].dataItem["CalculatedText"]) == 0)) {
        this.transactionflex.rows[e.row].dataItem["Calculated"] = this.transactionflex.rows[e.row].dataItem["CalculatedText"];
        this.transactionflex.rows[e.row].dataItem["CalculatedText"] = this.AssignvaluestoTransactiontypeDropdown(this.transactionflex.rows[e.row].dataItem["CalculatedText"]);
        var calculateddata = this.transactionflex.rows[e.row].dataItem["CalculatedText"];
        if (calculateddata == "N" || calculateddata == null || calculateddata == undefined || calculateddata == "" || calculateddata == "4") {
          this.transactionflex.rows[e.row].dataItem["AllowCalculationOverrideText"] = null;
          this.transactionflex.rows[e.row].dataItem["AllowCalculationOverride"] = null;
        }
      }
    }
    if (e.col == 4) {
      if (!(Number(this.transactionflex.rows[e.row].dataItem["IncludeCashflowDownloadText"]).toString() == "NaN" || Number(this.transactionflex.rows[e.row].dataItem["IncludeCashflowDownloadText"]) == 0)) {
        this.transactionflex.rows[e.row].dataItem["IncludeCashflowDownload"] = this.transactionflex.rows[e.row].dataItem["IncludeCashflowDownloadText"];
        this.transactionflex.rows[e.row].dataItem["IncludeCashflowDownloadText"] = this.AssignvaluestoTransactiontypeDropdown(this.transactionflex.rows[e.row].dataItem["IncludeCashflowDownloadText"]);
      }
    }
    if (e.col == 5) {
      if (!(Number(this.transactionflex.rows[e.row].dataItem["IncludeServicingReconciliationText"]).toString() == "NaN" || Number(this.transactionflex.rows[e.row].dataItem["IncludeServicingReconciliationText"]) == 0)) {
        this.transactionflex.rows[e.row].dataItem["IncludeServicingReconciliation"] = this.transactionflex.rows[e.row].dataItem["IncludeServicingReconciliationText"];
        this.transactionflex.rows[e.row].dataItem["IncludeServicingReconciliationText"] = this.AssignvaluestoTransactiontypeDropdown(this.transactionflex.rows[e.row].dataItem["IncludeServicingReconciliationText"]);
      }
    }
    if (e.col == 6) {
      if (!(Number(this.transactionflex.rows[e.row].dataItem["IncludeGAAPCalculationsText"]).toString() == "NaN" || Number(this.transactionflex.rows[e.row].dataItem["IncludeGAAPCalculationsText"]) == 0)) {
        this.transactionflex.rows[e.row].dataItem["IncludeGAAPCalculations"] = this.transactionflex.rows[e.row].dataItem["IncludeGAAPCalculationsText"];
        this.transactionflex.rows[e.row].dataItem["IncludeGAAPCalculationsText"] = this.AssignvaluestoTransactiontypeDropdown(this.transactionflex.rows[e.row].dataItem["IncludeGAAPCalculationsText"]);
      }
    }
    if (e.col == 7) {
      if (!(Number(this.transactionflex.rows[e.row].dataItem["AllowCalculationOverrideText"]).toString() == "NaN" || Number(this.transactionflex.rows[e.row].dataItem["AllowCalculationOverrideText"]) == 0)) {
        this.transactionflex.rows[e.row].dataItem["AllowCalculationOverride"] = this.transactionflex.rows[e.row].dataItem["AllowCalculationOverrideText"];
        this.transactionflex.rows[e.row].dataItem["AllowCalculationOverrideText"] = this.AssignvaluestoTransactiontypeDropdown(this.transactionflex.rows[e.row].dataItem["AllowCalculationOverrideText"]);
      }
    }
  }
  TransactionTypeValidation() {
    var errtransaction = "";
    var errortrans = "";
    this._isShowLoader = true;
    if (this.listtransactiontype) {
      for (var j = 0; j < this.listtransactiontype.length; j++) {
        //check for required fields
        if (this.listtransactiontype[j].TransactionName == null || this.listtransactiontype[j].TransactionName == "" || this.listtransactiontype[j].TransactionName == undefined) {
          errortrans = "Transaction Name ,";
          this.transactionerror = true;
        }
        if (this.listtransactiontype[j].TransactionCategory == null || this.listtransactiontype[j].TransactionCategory == "" || this.listtransactiontype[j].TransactionCategory == undefined) {
          errortrans = errortrans + "Transaction Category ,";
          this.transactionerror = true;
        }
        if (this.listtransactiontype[j].CalculatedText == null || this.listtransactiontype[j].CalculatedText == "" || this.listtransactiontype[j].CalculatedText == undefined) {
          errortrans = errortrans + "Calculated ,";
          this.transactionerror = true;
        }
        if (this.listtransactiontype[j].IncludeCashflowDownloadText == null || this.listtransactiontype[j].IncludeCashflowDownloadText == "" || this.listtransactiontype[j].IncludeCashflowDownloadText == undefined) {
          errortrans = errortrans + "Include in Cashflow Download ,";
          this.transactionerror = true;
        }
        if (this.listtransactiontype[j].IncludeServicingReconciliationText == null || this.listtransactiontype[j].IncludeServicingReconciliationText == "" || this.listtransactiontype[j].IncludeServicingReconciliationText == undefined) {
          errortrans = errortrans + "Include in Servicing Reconciliation ,";
          this.transactionerror = true;
        }
        if (this.listtransactiontype[j].IncludeGAAPCalculationsText == null || this.listtransactiontype[j].IncludeGAAPCalculationsText == "" || this.listtransactiontype[j].IncludeGAAPCalculationsText == undefined) {
          errortrans = errortrans + "Include in GAAP Calculations ";
          this.transactionerror = true;
        }
        if (errortrans != "") {
          break;
        }
      }

      //check duplicate name
      for (var k = 0; k < this.listtransactiontype.length - 1; k++) {
        for (var m = k + 1; m < this.listtransactiontype.length; m++) {
          if (this.listtransactiontype[k].TransactionName == this.listtransactiontype[m].TransactionName) {
            errtransaction = errtransaction + "<p>" + "Transaction name can not be same." + "</p>";
            this.transactionerror = true;
          }
        }

        if (errtransaction != "") {
          break;
        }
      }

      if (errortrans != "" || errtransaction != "") {
        if (errortrans != "") {
          errtransaction = errtransaction + "<p>" + errortrans.slice(0, -1) + " are required field(s)." + "</p>";
        }
        this.CustomAlert(errtransaction);
        this._isShowLoader = false;
      }
      else {
        this.saveTransactionType();
      }
    }
  }
  saveTransactionType() {
    var dtlisttransactiontype = [];
    for (var k = 0; k < this.listtransactiontype.length; k++) {
      dtlisttransactiontype.push({
        "TransactionTypesID": (!this.listtransactiontype[k].TransactionTypesID) ? 0 : this.listtransactiontype[k].TransactionTypesID,
        "TransactionName": this.listtransactiontype[k].TransactionName,
        "TransactionCategory": this.listtransactiontype[k].TransactionCategory,
        "TransactionGroup": this.listtransactiontype[k].TransactionGroup,
        "Calculated": this.listtransactiontype[k].Calculated,
        "IncludeCashflowDownload": this.listtransactiontype[k].IncludeCashflowDownload,
        "IncludeServicingReconciliation": this.listtransactiontype[k].IncludeServicingReconciliation,
        "IncludeGAAPCalculations": this.listtransactiontype[k].IncludeGAAPCalculations,
        "AllowCalculationOverride": this.listtransactiontype[k].AllowCalculationOverride,
        "CreatedBy": this.listtransactiontype[k].CreatedBy,
        "CreatedDate": this.listtransactiontype[k].CreatedDate,
        "UpdatedBy": this.listtransactiontype[k].UpdatedBy,
        "UpdatedDate": this.listtransactiontype[k].UpdatedDate,
      });
    }
    this.permissionService.SaveTransactionTypes(dtlisttransactiontype).subscribe(res => {
      if (res.Succeeded) {
        this._isShowLoader = false;
        this._ShowSuccessmessage = "Transaction types updated successfully.";
        this._ShowSuccessmessagediv = true;
        setTimeout(() =>{
          this._ShowSuccessmessagediv = false;
        }, 5000);
      }
      else {
        this._isShowLoader = false;
        this._ShowErrorMessage = "Something went wrong.Please try after some time.";
        this._dvEmptyDealSearchMsg = true;
        setTimeout(() => {
          this._dvEmptyDealSearchMsg = false;
        }, 5000);
      }
    });

  }

  showDialogbox(Name: string, ID: number, deleteRowIndex: number) {
    this.deleteRowIndex = deleteRowIndex;
    this._deltransactiontypeid = ID;
    var modaltrans:any = document.getElementById('custombox');
    modaltrans.style.display = "block";
    this._MsgText = 'Are you sure you want to delete the ' + Name.toLowerCase() + '?';
    $.getScript("/js/jsDrag.js");
  }

  CloseTransactionPopUp() {
    var modal:any = document.getElementById('custombox');
    modal.style.display = "none";
  }

  deleteTransactionType() {
    this._isShowLoader = true;
    this.CloseTransactionPopUp();
    this._transactiontypeslist.removeAt(this.deleteRowIndex);
    this.permissionService.deleteTransactionType(this._deltransactiontypeid).subscribe(res => {
      if (res.Succeeded) {
        this._isShowLoader = false;
        this._ShowSuccessmessage = "Transaction types deleted successfully.";
        this._ShowSuccessmessagediv = true;
        setTimeout(() => {
          this._ShowSuccessmessagediv = false;
        }, 5000);
      }
      else {
        this._isShowLoader = false;
        this._ShowErrorMessage = "Something went wrong.Please try after some time.";
        this._dvEmptyDealSearchMsg = true;
        setTimeout(()=> {
          this._dvEmptyDealSearchMsg = false;
        }, 5000);
      }
    });
  }

  convertDateToBindable(data:any) {
    for (var k = 0; k < data.length; k++) {
      if (this.lstHolidayCalendar[k].HoliDayDate != null) {
        this.lstHolidayCalendar[k].HoliDayDate = new Date(data[k].HoliDayDate.toString());
      }
    }
  }


  getHolidayCalendar() {
    this._isShowLoader = true;
    this.permissionService.GetHolidayCalendar().subscribe(res => {
      if (res.Succeeded == true) {
        this._isShowLoader = false;
        this.lstCalendarName = [];
        this.lstHolidayCalendar = [];
        var data = res.dt;
        var calendarnamelist = res.dtholidaymaster;
        var refreshlist = [];
        this.lstCalendarName = calendarnamelist;
        this.lstHolidayCalendar = data;
        this.convertDateToBindable(this.lstHolidayCalendar);
        for (var j = 0; j < this.lstHolidayCalendar.length; j++) {
          if (this._isSavedHolidayDate == false) {
            if (this.lstHolidayCalendar[j].CalendarName == 'US') {
              if (this.lstHolidayCalendar[j].HoliDayDate != null) {
                refreshlist.push({ "HoliDayDate": this.lstHolidayCalendar[j].HoliDayDate });
              }
            }
          }
          else {
            if (this.lstHolidayCalendar[j].HolidayMasterID.toString() == this.changedCalendarId.toString()) {
              if (this.lstHolidayCalendar[j].HoliDayDate != null) {
                refreshlist.push({ "HoliDayDate": this.lstHolidayCalendar[j].HoliDayDate });
              }
            }
          }
        }
        this._isSavedHolidayDate = false;
        this.lstHolidaycalendardate = new wjcCore.CollectionView(refreshlist);
        this.lstHolidaycalendardate.trackChanges = true;
        this.holidaycalendarflex.invalidate();
      }
      else {
        this._isShowLoader = false;
        var data = null;
        this.lstHolidaycalendardate = new wjcCore.CollectionView(data);
        this.lstHolidaycalendardate.trackChanges = true;
        this.holidaycalendarflex.invalidate();
      }
    });
  }

  CalendarNameChange(newvalue:any) {
    this.changedCalendarId = newvalue;
    var calendarname = this.lstCalendarName.find((x:any) => x.HolidayMasterID.toString() == newvalue).CalendarName;
    this.newCalendarname = calendarname;
    var selectedval = [];
    for (var j = 0; j < this.lstHolidayCalendar.length; j++) {
      if (this.newCalendarname == this.lstHolidayCalendar[j].CalendarName) {
        if (this.lstHolidayCalendar[j].HoliDayDate != null) {
          selectedval.push({ "HoliDayDate": this.lstHolidayCalendar[j].HoliDayDate });
        }
      }
    }
    this.lstHolidaycalendardate = new wjcCore.CollectionView(selectedval);
    this.lstHolidaycalendardate.trackChanges = true;
    this.holidaycalendarflex.refresh();
  }

  OpenCalendarNamepopup() {
    this.newCalendarname = '';
    var modal:any = document.getElementById('AddCalendarNamedialogbox');
    modal.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }

  CloseAddCalendarPopUp() {
    var modal:any = document.getElementById('AddCalendarNamedialogbox');
    modal.style.display = "none";
  }


  AddNewCalendarName() {
    this._isShowLoader = true;
    var foundName = '';
    var _isfoundName = false;
    for (var k = 0; k < this.lstCalendarName.length; k++) {
      if (this.lstCalendarName[k].CalendarName.toLowerCase() == this.newCalendarname.toLowerCase()) {
        _isfoundName = true;
      }
    }
    if (_isfoundName == true) {
      this._isShowLoader = false;
      this.CloseAddCalendarPopUp();
      foundName = "Calendar name " + this.newCalendarname + " already exists.";
      this.CustomAlert(foundName);
    }
    else {
      this.permissionService.addHolidayCalendarName(this.newCalendarname).subscribe(res => {
        if (res.Succeeded) {
          this._isShowLoader = false;
          this.CloseAddCalendarPopUp();
          this._ShowSuccessmessage = "Calendar name saved successfully.";
          this._ShowSuccessmessagediv = true;
          this.getHolidayCalendar();
          setTimeout(() => {
            this._ShowSuccessmessagediv = false;
          }, 5000);
        }
        else {
          this._isShowLoader = false;
          this.CloseAddCalendarPopUp();
          this._ShowErrorMessage = "Something went wrong.Please try after some time.";
          this._dvEmptyDealSearchMsg = true;
          setTimeout(() => {
            this._dvEmptyDealSearchMsg = false;
          }, 5000);
        }
      });
    }
  }


  cellEditHolidaysDate(s: wjcGrid.FlexGrid, e: wjcGrid.CellEditEndingEventArgs) {
    const items = s.collectionView.items;
    this.checkDuplicateHolidayDates(items, 'edit');
    s.invalidate();
  }

  CopiedHolidaysDate(s: wjcGrid.FlexGrid, e: wjcGrid.CellEditEndingEventArgs) {
    const items = s.collectionView.items;
    this.checkDuplicateHolidayDates(items, 'copy');
    s.invalidate();
  }


  checkDuplicateHolidayDates(data:any, mode:any) {
    var founddates = '';
    var duplicatedateerror = '';
    for (var k = 0; k < data.length; k++) {
      for (var j = k + 1; j < data.length; j++) {
        if (Object.keys(data[j]).length > 0) {
          if (data[j].HoliDayDate.getTime() == data[k].HoliDayDate.getTime()) {
            var month = new Date(data[k].HoliDayDate).getMonth() + 1;
            var date = month + '/' + new Date(data[k].HoliDayDate).getDate() + '/' + new Date(data[k].HoliDayDate).getFullYear();
            founddates = founddates + date + ", ";
          }
        }
      }
    }
    if (founddates != "") {
      founddates = founddates.substring(0, founddates.length - 1);
      duplicatedateerror = "<p> Holiday date(s) found duplicates " + founddates.slice(0, -1) + "</p>";
      this.CustomAlert(duplicatedateerror);
    }
    else {
      if (mode == 'save') {
        this.saveHolidayDate(data);
      }
    }
  }

  convertDatetoGMT(date: Date) {
    if (date != null) {
      date = new Date(date);
      date = new Date(date.getTime() - this._userOffset + this._centralOffset); // redefine variable
      return date;
    }
    else
      return date;
  }


  InsertHolidayDatesByID() {
    this._isShowLoader = true;
    var dtholidaydates = [];
    if (!this.changedCalendarId) {
      this.changedCalendarId = "411";
    }
    for (var k = 0; k < this.holidaycalendarflex.rows.length - 1; k++) {
      if (this.holidaycalendarflex.rows[k].dataItem.HoliDayDate) {
        dtholidaydates.push({
          "HolidayMasterId": this.changedCalendarId,
          "HoliDayDate": this.convertDatetoGMT(this.holidaycalendarflex.rows[k].dataItem.HoliDayDate)
        });
      }
    }
    if (dtholidaydates.length == 0) {
      dtholidaydates.push({
        "HolidayMasterId": this.changedCalendarId,
        "HoliDayDate": null
      });
    }
    this.checkDuplicateHolidayDates(dtholidaydates, 'save');
    this._isShowLoader = false;
  }

  saveHolidayDate(dtholidaydates:any) {
    this.permissionService.addHolidayDates(dtholidaydates).subscribe(res => {
      if (res.Succeeded) {
        this._isShowLoader = false;
        this.CloseAddCalendarPopUp();
        this._ShowSuccessmessage = "Holiday dates updated successfully.";
        this._ShowSuccessmessagediv = true;
        this._isSavedHolidayDate = true;
        this.getHolidayCalendar();
        setTimeout(() => {
          this._ShowSuccessmessagediv = false;
        }, 5000);
      }
      else {
        this._isShowLoader = false;
        this._ShowErrorMessage = "Something went wrong.Please try after some time.";
        this._dvEmptyDealSearchMsg = true;
        setTimeout(() => {
          this._dvEmptyDealSearchMsg = false;
        }, 5000);
      }
    });
  }

  showDeleteDialogbox(Name: string, rowval: string, deleteRowIndex: number) {
    this.deleteRowIndex = deleteRowIndex;
    var modaltrans:any = document.getElementById('deletebox');
    modaltrans.style.display = "block";
    var month = new Date(rowval).getMonth() + 1;
    var mm = month < 10 ? '0' + month : month;
    var dd = new Date(rowval).getDate() < 10 ? '0' + new Date(rowval).getDate() : new Date(rowval).getDate();
    var date = mm + '/' + dd + '/' + new Date(rowval).getFullYear();
    this._MsgText = 'Are you sure you want to delete the ' + Name.toLowerCase() + '-' + date + '?';
    $.getScript("/js/jsDrag.js");
  }

  CloseDeletePopUp() {
    var modal:any = document.getElementById('deletebox');
    modal.style.display = "none";
  }

  deleteFromModuleList(moduleName: string) {
    if (moduleName == "HolidayCalendar") {
      this.CloseDeletePopUp();
      this.lstHolidaycalendardate.removeAt(this.deleteRowIndex);
    }
  }
  syncQuickbook() {
    this._isShowLoader = true;
    if (this._issyncbtnClicked == true) {
      this._ShowmessagedivWar = true;
      this._ShowmessagedivMsgWar = "Please wait while Quickbooks sync is in process.";
      this._isShowLoader = false;
      setTimeout(() => {
        this._ShowmessagedivWar = false;
        this._ShowmessagedivMsgWar = "";
      }, 5000);
    }
    else {
      this._issyncbtnClicked = true;
      this.permissionService.syncQuickbook().subscribe(res => {
        if (res.Succeeded) {
          this._isShowLoader = false;
          setTimeout(()=> {
            this._issyncbtnClicked = false;
          }, 60000);
          this._ShowSuccessmessage = "Request sent successfully. It might take approx 15-20 minutes to sync the data.";
          this._ShowSuccessmessagediv = true;
          setTimeout(() => {
            this._ShowSuccessmessagediv = false;
          }, 5000);
        } else {
          this._isShowLoader = false;
          this._ShowErrorMessage = "Something went wrong.Please try after some time.";
          this._dvEmptyDealSearchMsg = true;
          setTimeout(() => {
            this._dvEmptyDealSearchMsg = false;
          }, 5000);
        }
      });
    }
  }
}

const routes: Routes = [

  { path: '', component: DataManagement }]

@NgModule({

  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjGridModule, WjInputModule, WjGridFilterModule, //Ng2FileInputModule.forRoot()
  ],
  declarations: [DataManagement]

})

export class dataManagementModule { }
