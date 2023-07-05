
import { Component, ViewChild, Input, Output, EventEmitter, ElementRef, HostListener } from "@angular/core";
import { Router, ActivatedRoute} from '@angular/router';
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
import appsettings from '../../../../appsettings.json';
//import { _storageType, _environmentNamae } from '../../../../appsettings.json';
import { Servicer } from "../core/domain/note.model";
import { WjInputModule, WjMenu } from '@grapecity/wijmo.angular2.input';
import { dndDirectiveModule } from '../directives/dnd.directive';
import { changepowerbipasswrd } from "../core/domain/changePassword.model";
import { WjNavModule, WjTreeView } from '@grapecity/wijmo.angular2.nav';
import * as WjNav from '@grapecity/wijmo.nav';
import { ruletype } from "../core/domain/ruleType.model";
//import { TreeViewModule } from '@syncfusion/ej2-angular-navigations';
declare var $: any;


@Component({
  selector: 'datamanagement',
  providers: [NoteService, dealService, MembershipService, NotificationService, PermissionService, FileUploadService],
  templateUrl: './dataManagement.html'
})
export class DataManagement {

  TreeViewdata: TreeItem[];
  isAnimated = false;
  autoCollapse = false;
  expandOnClick = true;

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
  public _changepowerbipassword: changepowerbipasswrd;
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
  public JsonTemplateValue: any = '';
  public JsonTemplateName: any = [];
  public lstTemplatename: any = [];
  public LastselectedRule: any = '';
  public LastParentNode: any = '';
  public selectedRule: any = '';
  public ParentNode: any = '';
  public ChangedRule: any = '';
  public ChangedParentNode: any = '';
  private _isRuleChanged: boolean = false;
  public _isShowaddnewvalidation: boolean = false;
  public validationtxt: any = '';
  public DialogModulename: string;
  GenericDialogBody: string;
  uploadtype: any;
  listtransactiontype: any = [];
  _transactiontypeslist !: wjcCore.CollectionView;
  lstCalculated: any;
  lstCashflowdownlaod: any;
  lstServicingRecocilliation: any;
  lstGAAPCalculations: any;
  lstAllowcalculationOverride: any;
  AllRulesList: any;
  lstCashNonCash: any;
  public Dialogheader: any
  public _deltransactiontypeid: any;
  public deleteRowIndex !: number;
  public transactionerror: boolean = false;
  public lstHolidayCalendar: any = [];
  public lstHolidaycalendardate !: wjcCore.CollectionView;
  @ViewChild('multiselholidaycalendarname') multiselholidaycalendarname !: wjNg2Input.WjMultiSelect;
  @ViewChild('theTree') theTree: WjTreeView;
  @ViewChild('theMenu') theMenu: WjMenu;
  public lstCalendarName: any = [];
  public lstChangedTemplate: any = [];
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
  public _storageType = appsettings._storageType;
  public _environmentNamae = appsettings._environmentNamae;
  @ViewChild("wellsuploadfile", { static: false }) fileDropEl: ElementRef;
  files: any[] = [];
  public filetype = '';
  public _isShowQuickbookBtn: boolean = false;
  public _isShowPowerBITab: boolean = false;
  private listruletype: ruletype;
  public paraselectedrule: any;
  public paraparentnode: any;
  constructor(public notesvc: NoteService, public utilityService: UtilityService, public notificationService: NotificationService, public dealSrv: dealService, public membershipService: MembershipService,
    private router: Router,
    private _actrouting: ActivatedRoute,
    public permissionService: PermissionService, public fileUploadService: FileUploadService, //private ng2FileInputService: Ng2FileInputService
  ) {
    permissionService.GetUserPermissionBySuperAdmin();

    this._deal = new deals('');
    this.listruletype = new ruletype('');
    ruletype
    this._note = new Note('');
    this._module = new Module('');
    this._changepowerbipassword = new changepowerbipasswrd();
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
   
   

    $.getScript("../../assets/js/editorfunction.js");
   
    localStorage.setItem("EditorValueChanged", "false");
    this._actrouting.queryParams.subscribe(params => {
      if (params['tab'] == "rule") {
        var ActiveTabID = 'aJsontemplatetab';
        setTimeout(function () {
          document.getElementById(ActiveTabID).click();
        }.bind(this), 200);
        this.paraparentnode = params['ruletype'];
        this.paraselectedrule = params['filename'];

      }
      else {
        var ActiveTabID = 'adeletedeal';
        setTimeout(function () {
          document.getElementById(ActiveTabID).click();
        }.bind(this), 200);
      }

    });
  }
  redirectonItemClicked(selectedrule, parentnode) {
    try {
      this._isShowLoader = true;
      this.selectedRule = "";
      this.ParentNode = "";
      if (this.isParentnodeClicked() == false) {
        var result = this.AllRulesList.find(x => x.RuleTypeDetailID == selectedrule).FileName

        this._isShowLoader = true;
        this.selectedRule = result;
        this.ParentNode = parentnode;
        this._isShowLoader = true;
        var EditorValueChanged = localStorage.getItem('EditorValueChanged');
        if (EditorValueChanged == "true") {
          this.JsonTemplateValueChange();
          this._isRuleChanged = true;
        } else {
          this._isRuleChanged = false;
        }
        this.LastselectedRule = result;
        this.LastParentNode = parentnode;

        if (this._isRuleChanged == true) {
          //show dialog box and get data
          this.RuleDataChanged();

        } else {
          var getcontentfromdb = true;
          if (this.lstChangedTemplate != undefined && this.lstChangedTemplate != null) {
            var tempselected = this.lstChangedTemplate.find(x => x.FileName == this.selectedRule);
            if (tempselected != undefined && tempselected != null) {
              getcontentfromdb = false;
              this.JsonTemplateValue = tempselected.Content;
              localStorage.setItem('editorData', tempselected.Content);
              setTimeout("setData()", 500);
              this.SetEditorParameterAfterDataLoad();
            }
          }
          if (getcontentfromdb == true) {
            this.GetContentByRule(this.selectedRule);
          }
        }

      } else {
        this._isShowLoader = false;
      }



    } catch (e) {
      this._isShowLoader = false;
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
  onFileDropped(files) {
    this.onAction(files, this.filetype,'drop');
  }
  onClick(filetype) {
    this.filetype = filetype;
  }
  public onAction(files: any, uploadtype: any, mode: any) {
    if (mode == 'change') {
      this.filename = files.target.files[0].name;
      this.fileList = files.target.files;
    } else {
      this.filename = files[0].name;
      this.fileList = files;
    }
    this.uploadtype = uploadtype;
    this.showWellsDialog();
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
      this.lstCashNonCash = data.filter(x => x.ParentID == "121");
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
      var colCashNonCash = transflex.columns.getColumn('Cash_NonCashText');
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
      if (colCashNonCash) {
        colCashNonCash.showDropDown = true;
        colCashNonCash.dataMap = this._buildDataMap(this.lstCashNonCash);
      }
    }
  }

    // build a data map from a string array using the indices as keys
  private _buildDataMap(items): wjcGrid.DataMap {
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
      if (!(Number(this.transactionflex.rows[k].dataItem["Cash_NonCashText"]).toString() == "NaN" || Number(this.transactionflex.rows[k].dataItem["Cash_NonCashText"]) == 0)) {
        this.transactionflex.rows[k].dataItem["Cash_NonCashID"] = this.transactionflex.rows[k].dataItem["Cash_NonCashText"];
        this.transactionflex.rows[k].dataItem["Cash_NonCashText"] = this.lstCashNonCash.find(x => x.LookupID == this.transactionflex.rows[e.row].dataItem["Cash_NonCashID"]).Name;
      }
      else {
        this.transactionflex.rows[k].dataItem["Cash_NonCashID"] = this.transactionflex.rows[k].dataItem["Cash_NonCashID"];
        this.transactionflex.rows[k].dataItem["Cash_NonCashText"] = this.transactionflex.rows[k].dataItem["Cash_NonCashText"];
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
    if (e.col == 8) {
      if (!(Number(this.transactionflex.rows[e.row].dataItem["Cash_NonCashText"]).toString() == "NaN" || Number(this.transactionflex.rows[e.row].dataItem["Cash_NonCashText"]) == 0)) {
        this.transactionflex.rows[e.row].dataItem["Cash_NonCashID"] = this.transactionflex.rows[e.row].dataItem["Cash_NonCashText"];
        this.transactionflex.rows[e.row].dataItem["Cash_NonCashText"] = this.lstCashNonCash.find(x => x.LookupID == this.transactionflex.rows[e.row].dataItem["Cash_NonCashID"]).Name;
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

  getPowerBIPassword() {
    this._isShowLoader = true;
    this._isShowPowerBITab = true;
    this.permissionService.getpowerBIpassword().subscribe(res => {
      if (res.Succeeded == true) {
        this._isShowLoader = false;
        this._changepowerbipassword.Value = res.appconfigpowerBI;
      }
    });
  }

  updatepowerbipassword() {
    this._isShowLoader = true;
    this._changepowerbipassword.key = "PowerBIPassword";
    this.permissionService.UpdatePowerBIPassword(this._changepowerbipassword).subscribe(res => {
      if (res.Succeeded) {
        this._isShowLoader = false;
        this._ShowSuccessmessage = " Password Saved successfully.";
        this._ShowSuccessmessagediv = true;
        this._changepowerbipassword.Value = "";
        this._isShowPowerBITab = false;
        setTimeout(function () {
          this._ShowSuccessmessagediv = false;
        }.bind(this), 5000);
      }
      else {
        this._isShowLoader = false;
        this._ShowErrorMessage = "Something went wrong.Please try again.";

      }

    });

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

  //showquickbook() {
  //  this._isShowQuickbookBtn = true;
  //}

  /// editor code start
  //manish
  GetAllJsonTemplate() {
    this._isShowLoader = true;
    this.permissionService.GetAllRules().subscribe(res => {
      if (res.Succeeded == true) {
        var filename: any;
        this.AllRulesList = res.AllRulesList;
        this.CreateTreeViewData(this.AllRulesList);
        if (this.paraselectedrule != null) {
          filename = this.AllRulesList.find(x => x.RuleTypeDetailID == this.paraselectedrule).FileName;
          this.redirectonItemClicked(this.paraselectedrule, this.paraparentnode);
        }
        setTimeout(function () {
          $('#mainSpliter').enhsplitter({ handle: 'lotsofdots', position: 300, leftMinSize: 0, fixed: false });
          if (this.paraselectedrule != null) {
            var theItem = this._findItem(this.theTree.itemsSource, filename);
            var theNode = this.theTree.getNode(theItem);
            theNode.select();
          }
        }.bind(this), 1000);
        this._isShowLoader = false;
        this.JsonTemplateName = 0;
      }
    });
  }

  UpdateJsonTemplate() {
    try {
      this._isShowLoader = true;

      //manish
      var EditorValueChanged = localStorage.getItem('EditorValueChanged');
      if (EditorValueChanged == "true") {
        this.JsonTemplateValueChange();

      }
      if (this._isRuleChanged == true) {
        this.JsonTemplateValue = this.GetEditorCurrentData();
        this.lstChangedTemplate.push({ FileName: this.ChangedRule, RuleTypeName: this.ChangedParentNode, Content: this.JsonTemplateValue });
        this._isRuleChanged = false;
        localStorage.setItem("EditorValueChanged", "false");
      }

      var ruletypelist = [];
      if (this.lstChangedTemplate.length > 0) {
        for (var k = 0; k < this.lstChangedTemplate.length; k++) {
          var temp = new ruletype('');
          var rule = this.AllRulesList.find(x => x.FileName == this.lstChangedTemplate[k].FileName)

          if (rule !== undefined && rule != null) {
            temp.DBFileName = rule.FileName;
            temp.IsBalanceAware = rule.IsBalanceAware;
            temp.RuleTypeDetailID = rule.RuleTypeDetailID;
            temp.RuleTypeMasterID = rule.RuleTypeMasterID;
            temp.RuleTypeName = rule.RuleTypeName;
            temp.Type = rule.Type;
            temp.Content = this.lstChangedTemplate[k].Content;
            temp.Comments = rule.Comments;
            temp.FileName = rule.FileName;
          } else {

            var masterid = this.AllRulesList.find(x => x.RuleTypeName == this.lstChangedTemplate[k].RuleTypeName).RuleTypeMasterID
            //in case of new
            temp.DBFileName = this.lstChangedTemplate[k].FileName;
            temp.IsBalanceAware = false;
            temp.RuleTypeDetailID = 0;
            temp.RuleTypeMasterID = masterid;
            temp.RuleTypeName = this.lstChangedTemplate[k].RuleTypeName;
            temp.Type = 'json';
            temp.Content = this.lstChangedTemplate[k].Content;
            temp.Comments = "";
            temp.FileName = this.lstChangedTemplate[k].FileName;
          }

          ruletypelist.push(temp);
        }
      }
      this.permissionService.UpdateJsonTemplate(ruletypelist).subscribe(res => {
        if (res.Succeeded) {
          this.AllRulesList = res.AllRulesList;
          this.lstChangedTemplate = [];
          this._isShowLoader = false;
          this._ShowSuccessmessage = " Rules saved successfully.";
          this._ShowSuccessmessagediv = true;
          setTimeout(function () {
            this._ShowSuccessmessagediv = false;
          }.bind(this), 5000);
        }
        else {
          this._isShowLoader = false;
          this._ShowErrorMessage = "Something went wrong.Please try again.";
        }
      });
    } catch (e) {
      this._isShowLoader = false;
      this._ShowErrorMessage = "Something went wrong.Please try again.";

      setTimeout(function () {
        this._ShowSuccessmessagediv = false;
      }.bind(this), 5000);
    }

  }

  onItemClicked(s: WjTreeView) {
    try {
      this._isShowLoader = true;
      this.selectedRule = "";
      this.ParentNode = "";
      if (this.isParentnodeClicked() == false) {
        this._isShowLoader = true;
        this.selectedRule = s.selectedItem.header;
        this.ParentNode = s.selectedPath[0];
        this._isShowLoader = true;
        var EditorValueChanged = localStorage.getItem('EditorValueChanged');
        if (EditorValueChanged == "true") {
          this.JsonTemplateValueChange();
          this._isRuleChanged = true;
        } else {
          this._isRuleChanged = false;
        }
        this.LastselectedRule = s.selectedItem.header;
        this.LastParentNode = s.selectedPath[0];

        if (this._isRuleChanged == true) {
          //show dialog box and get data
          this.RuleDataChanged();

        } else {
          var getcontentfromdb = true;
          if (this.lstChangedTemplate != undefined && this.lstChangedTemplate != null) {
            var tempselected = this.lstChangedTemplate.find(x => x.FileName == this.selectedRule);
            if (tempselected != undefined && tempselected != null) {
              getcontentfromdb = false;
              this.JsonTemplateValue = tempselected.Content;
              localStorage.setItem('editorData', tempselected.Content);
              setTimeout("setData()", 500);
              this.SetEditorParameterAfterDataLoad();
            }
          }
          if (getcontentfromdb == true) {
            this.GetContentByRule(this.selectedRule);
          }
        }

      } else {
        this._isShowLoader = false;
      }



    } catch (e) {
      this._isShowLoader = false;
    }
  }

  GetContentByRule(selectedRule) {
    var RuleTypeDetailID: any;
    var result = this.AllRulesList.find(x => x.FileName == selectedRule)
    if (result !== undefined && result !== null) {
      RuleTypeDetailID = this.AllRulesList.find(x => x.FileName == selectedRule).DBFileName;
      this.permissionService.GetContentByRuleTypeDetailID(RuleTypeDetailID).subscribe(res => {
        if (res.Succeeded == true) {
          this.JsonTemplateValue = res.RuleContent;
          localStorage.setItem('editorData', this.JsonTemplateValue);
          setTimeout("setData()", 500);

          setTimeout(function () {
            this._isRuleChanged = false;
            localStorage.setItem("EditorValueChanged", "false");
            this._isShowLoader = false;
          }.bind(this), 1000);
        } else {
          setTimeout(function () {
            this._isRuleChanged = false;
            localStorage.setItem("EditorValueChanged", "false");
            this._isShowLoader = false;
          }.bind(this), 1000);
        }
      });
    } else {
      localStorage.setItem('editorData', "");
      setTimeout("setData()", 500);

      setTimeout(function () {
        this._isRuleChanged = false;
        localStorage.setItem("EditorValueChanged", "false");
        this._isShowLoader = false;
      }.bind(this), 1000);
    }

  }

  SetEditorParameterAfterDataLoad() {
    setTimeout(function () {
      this._isRuleChanged = false;
      localStorage.setItem("EditorValueChanged", "false");
      this._isShowLoader = false;
    }.bind(this), 1000);
  }

  JsonTemplateValueChange() {
    this.ChangedRule = this.LastselectedRule;
    this.ChangedParentNode = this.LastParentNode;
    this._isRuleChanged = true;

  }
  RuleDataChanged() {
    this.GenericDialogBody = "You have made changes to " + this.ChangedRule + ", do you want to save them before switching to another rule?";
    this.showDialogGeneric("myGenericDialog");
  }

  private isValidFileName(filename) {
    var message = "";
    var extenionallowed = "json,py";
    // Make array of file extensions
    var extensions = (extenionallowed.split(','))
      .map(function (x) { return x.toLocaleUpperCase().trim() });

    var res = filename.slice((filename.lastIndexOf(".") - 1 >>> 0) + 2);
    if (res != "") {
      var ext = filename.toUpperCase().split('.').pop() || filename;
      var exists = extensions.includes(ext);
      if (!exists) {
        message = "Only .json and .py files allowed.";
      }
    }
    else {
      message = "Please enter proper template type name.";
    }
    return message;
  }

  addnewRuleType(rulename) {
    var duplicate = false;
    var res = this.isValidFileName(rulename);
    if (res != "") {
      duplicate = true;
    }
    for (var k = 0; k < this.TreeViewdata.length; k++) {
      for (var il = 0; il < this.TreeViewdata[k].items.length; il++) {
        if (this.TreeViewdata[k].items[il].header.toLowerCase() == rulename.toLowerCase()) {
          duplicate = true;
          break;
        }
      }
    }
    if (duplicate == true) {
      duplicate = true;
      this._isShowaddnewvalidation = true;
      if (res == "") {
        this.validationtxt = "Rule with same name already exists.";
      } else {
        this.validationtxt = res;
      }
      setTimeout(function () {
        this._isShowaddnewvalidation = false;
      }.bind(this), 5000);
    } else {

      var theTree = this.theTree;
      var node = theTree.selectedNode;
      this.TreeViewdata[node.index].items.push({ header: rulename });

      this.theTree.itemsSource = [];
      this.theTree.itemsSource = this.TreeViewdata;

      //setTimeout(function () {
      //    this.theTree.collapseToLevel(10);
      //}.bind(this), 500);


      //this.JsonTemplateValue = "";
      // localStorage.setItem('editorData', this.JsonTemplateValue);
      this.CloseContextMenuDialog();
    }
  }

  showContextMenu(e: any) {
    if (this.isParentnodeClicked() == true) {
      e.preventDefault();
      this.theMenu.show(e);
    }
  }

  isParentnodeClicked() {
    var Parentnode = false;
    var theTree = this.theTree;
    var node = theTree.selectedNode;
    if (node) {
      if (node.level == 0 && node.hasChildren == true) {
        Parentnode = true;
      } else {
        Parentnode = false;
      }
    }
    else {
      Parentnode = false;
    }
    return Parentnode;

  }
  menuItemClick(contextMenu: WjMenu) {
    var modal = document.getElementById('ContextMenudialogbox');
    modal.style.display = "block";
    $.getScript("/js/jsDrag.js");
    document.getElementById('rulename')["value"] = "";
  }
  ContextMenuUpdatedialogbox() {
    var newruletype = document.getElementById('rulename')["value"];
    if (newruletype != "") {
      this.addnewRuleType(newruletype);
    }
  }
  CloseContextMenuDialog() {
    var modal = document.getElementById('ContextMenudialogbox');
    modal.style.display = "none";
  }
  getData(): TreeItem[] {
    return [
      {
        header: 'Parent 1', items: [
          { header: 'Child 1.1' },
          { header: 'Child 1.2' },
          { header: 'Child 1.3' }]
      },
      {
        header: 'Parent 2',
        items: [
          { header: 'Child 2.1' },
          { header: 'Child 2.2' }]
      },
      {
        header: 'Parent 3', items: [
          { header: 'Child 3.1' }]
      }
    ];
  }

  CreateTreeViewData(data) {
    var distinct = [];
    var Treedata = [];
    var uniquedates = {};
    for (var k = 0; k < data.length; k++) {
      var valuetoCheck = data[k].RuleTypeName;
      if (valuetoCheck) {
        if (!(valuetoCheck in uniquedates)) {
          uniquedates[valuetoCheck] = 1;
          distinct.push(valuetoCheck);
        }
      }
    }
    if (distinct.length > 0) {
      for (var m = 0; m < distinct.length; m++) {
        for (var mk = 0; mk < data.length; mk++) {
          if (data[mk].RuleTypeName == distinct[m]) {
            var itemcheck = Treedata.filter(x => x.header == distinct[m])

            if (itemcheck.length == 0) {

              Treedata.push({ header: distinct[m], items: [{ header: data[mk].FileName }] });
            } else {
              Treedata[m].items.push({ header: data[mk].FileName });
            }
          }
        }
      }
    }
    this.TreeViewdata = Treedata;
    

  }

  onNodeEditStarting(s: WjTreeView, e: WjNav.TreeNodeEventArgs) {
    if (e.node.hasChildren) {
      e.cancel = true;
    }

  }
  onnodeEditEnding(s: WjTreeView, e: WjNav.TreeNodeEventArgs) {
    var oldname = e.node.dataItem.header;
    var newname = e.node.element.innerText;

    this.selectedRule = e.node.element.innerText;
    this.ParentNode = s.selectedPath[0];

    for (var mk = 0; mk < this.AllRulesList.length; mk++) {
      if (this.AllRulesList[mk].FileName == oldname) {
        this.AllRulesList[mk].FileName = newname;
      }
    }
    for (var ch = 0; ch < this.lstChangedTemplate.length; ch++) {
      if (this.lstChangedTemplate[ch].FileName == oldname) {
        this.lstChangedTemplate[ch].FileName = newname;
      }
    }
    if (this.lstChangedTemplate != undefined && this.lstChangedTemplate != null) {
      var temp = this.lstChangedTemplate.find(x => x.FileName == newname);
      if (temp != null) {
        for (var tp1 = 0; tp1 < this.lstChangedTemplate.length; tp1++) {
          if (this.lstChangedTemplate[tp1].FileName == newname) {
            this.lstChangedTemplate[tp1].Content = temp.Content;

          }
        }


      } else {
        this.lstChangedTemplate.push({ FileName: newname, RuleTypeName: s.selectedPath[0], Content: this.JsonTemplateValue });
      }

    } else {
      this.lstChangedTemplate.push({ FileName: this.ChangedRule, RuleTypeName: s.selectedPath[0], Content: this.JsonTemplateValue });
    }
  }

  GetEditorCurrentData() {
    var value: any;
    var $editor = $('#editor');
    if ($editor.length > 0) {

      var objeditor = eval("ace.edit('editor')");
      value = objeditor.getValue();
    }
    return value;
  }

  ///editor code end

  //dialog code start

  showDialogGeneric(controlid): void {
    var modalRole = document.getElementById(controlid);
    modalRole.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }

  CloseDialogGeneric(controlid): void {
    this.GetContentByRule(this.selectedRule);
    this.DialogModulename = "";
    var modal = document.getElementById(controlid);
    modal.style.display = "none";
  }

  GenricOkButtonClick() {
    this.AddDataToChangedList();
  }

  AddDataToChangedList() {
    this.JsonTemplateValue = this.GetEditorCurrentData();

    var getcontentfromdb = true;
    if (this.lstChangedTemplate != undefined && this.lstChangedTemplate != null) {
      var temp = this.lstChangedTemplate.find(x => x.FileName == this.ChangedRule);
      if (temp != null) {
        for (var mk = 0; mk < this.lstChangedTemplate.length; mk++) {
          if (this.lstChangedTemplate[mk].FileName == this.ChangedRule) {
            this.lstChangedTemplate[mk].Content = this.JsonTemplateValue;
          }
        }
      }
      else {
        this.lstChangedTemplate.push({ FileName: this.ChangedRule, RuleTypeName: this.ChangedParentNode, Content: this.JsonTemplateValue });
      }

    } else {
      this.lstChangedTemplate.push({ FileName: this.ChangedRule, RuleTypeName: this.ChangedParentNode, Content: this.JsonTemplateValue });
    }

    //this.lstChangedTemplate.push({ FileName: this.ChangedRule, RuleTypeName: this.ChangedParentNode, Content: this.JsonTemplateValue });

    //get data from list if already changed otherwsie get it from db
    if (this.lstChangedTemplate != undefined && this.lstChangedTemplate != null) {
      var tempselected = this.lstChangedTemplate.find(x => x.FileName == this.selectedRule);
      if (tempselected != undefined && tempselected != null) {
        getcontentfromdb = false;
        this.JsonTemplateValue = tempselected.Content;
        localStorage.setItem('editorData', this.JsonTemplateValue);
        setTimeout("setData()", 500);
      }
    }
    if (getcontentfromdb == true) {
      this.GetContentByRule(this.selectedRule);
    }

    this._isShowLoader = false;
    this._isRuleChanged = false;
    localStorage.setItem("EditorValueChanged", "false");

    this.CloseDialogGeneric("myGenericDialog");

  }


    // dialog code end
}

const routes: Routes = [

  { path: '', component: DataManagement }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjGridModule, WjInputModule, WjGridFilterModule, dndDirectiveModule, WjNavModule //Ng2FileInputModule.forRoot()
  ],
  declarations: [DataManagement]

})

export class dataManagementModule { }

export class TreeItem {
  header: string;
  items?: TreeItem[]
}
