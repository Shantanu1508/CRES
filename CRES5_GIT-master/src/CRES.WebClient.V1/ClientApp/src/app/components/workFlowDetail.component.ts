import { Component, ViewChild } from '@angular/core';
import { Router, ActivatedRoute, Params} from '@angular/router';
import { UtilityService } from '../core/services/utility.service';
import { Workflow, WFAdditionalData, WFCheckListData, WFStatusData, WFNotificationDetailDataContract, WFNotificationMaster } from "../core/domain/workFlow.model";
import appsettings from '../../../../appsettings.json';
//import { _invoiceStorageType, _invoiceLocation } from '../../../../appsettings.json';
import * as wjcCore from '@grapecity/wijmo';
import * as wjcGrid from '@grapecity/wijmo.grid';
import {  NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
import { WjInputModule } from '@grapecity/wijmo.angular2.input';
import { WFService } from '../core/services/workFlow.service';
import { dealService } from '../core/services/deal.service';
import { FileUploadService } from '../core/services/fileUpload.service';
import { DealFunding } from "../core/domain/deals.model";
import { User } from '../core/domain/user.model';
import { DataService } from '../core/services/data.service';
import { DomSanitizer,SafeHtml } from '@angular/platform-browser';
import { DrawFeeInvoiceDetail } from '../core/domain/drawFeeInvoiceDetail.model';
declare var $: any;

@Component({
  selector: "workflowdetail",
  templateUrl: "./workFlowDetail.html",
  providers: [dealService, WFService, FileUploadService]
})


export class WorkflowDetailComponent {
  lstRejectList: any;
  lstCheckListStatusType: any;
  lstAllStatusByPurposeType: any;
  lstWFComments: Array<any> = [];
  @ViewChild('flexWFCheckList') flexWFCheckList: wjcGrid.FlexGrid;
  public _workflow: Workflow;
  public _wfAdditionalData: WFAdditionalData;
  public _wfCheckListData: WFCheckListData;
  public _wfStatusData: WFStatusData;

  _isShowbtnRejected: boolean;
  _isShowbtnSaveDraft: boolean;
  _isShowbtnApproval: boolean;
  savedialogmsg: string
  public _isWFFetching: boolean;
  public _ShowmessagedivWar: boolean = false;
  public _ShowmessagedivMsgWar: string;
  deleteRowIndex: number
  notificationConfig: any;
  public _CuurentWFStatusPurposeMappingID: number;
  public _isShowDownloadDoc: boolean = false;
  cvwfCheckListData: wjcCore.CollectionView;
  public ConfirmDialogBoxFor: string;
  _notificationmaster: WFNotificationMaster

  public _CanChangeReplyTo: boolean = false;
  public _CanChangeRecipientList: boolean = false;
  public _CanChangeHeader: boolean = false;
  public _CanChangeBody: boolean = false;
  public _CanChangeFooter: boolean = false;
  public _CanChangeSchedule: boolean = false;
  public _headerText: string;
  public _bodyText: string;
  public _footerText: string;
  public _activityLog: string;
  _wfNotificationDetail: WFNotificationDetailDataContract;
  _wfTemplateRecipient: any;
  public _isShowNotify: boolean = false;
  public _isShowPreliminary: boolean = false;
  public _isShowRevisedPreliminary: boolean = false;
  public _isShowFinal: boolean = false;
  public _isShowRevisedFinal: boolean = false;
  public _isShowServicer: boolean = false;
  public _isShowRevisedServicer: boolean = false;
  public _isShowFinalPayOff: boolean = false;
  public _isShowRevisedFinalPayOff: boolean = false;


  public: boolean = true;
  public _Preliminary: string = "Preliminary";
  public _Final: string = "Final";
  public _Servicer: string = "Servicer";
  public _RevisedPreliminary: string = "RevisedPreliminary";
  public _RevisedFinal: string = "RevisedFinal";
  public _RevisedServicer: string = "RevisedServicer";
  public _FinalWithoutApproval: string = "FinalWithoutApproval";
  public _RevisedFinalWithoutApproval: string = "RevisedFinalWithoutApproval";
  public _notificationTittle: string = "";
  public _isRefresh: boolean = false;
  public _Showmessagediv: boolean = false;
  public _ShowmessagedivMsg: string = '';
  public _isNotificationMsg: boolean = false;
  public _dealfunding: DealFunding;
  _wflstNoteDealFunding: any;
  _wflstNoteAllocationPercentage: any
  _wflstNoteAllocationAmount: any;
  noteswithAmount: string
  checklistInTable: string
  wfRequiredEquity: any;
  wfAdditionalEquity: any;
  public Delphi_Financial = "Delphi Financial";
  public Delphi_Fixed = "Delphi Fixed";
  public TRE_ACR = "TRE ACR";
  public Refinance_Program = "Refinance Program";
  public ACORE_Credit_IV = "ACORE Credit IV";
  public AFLAC = "AFLAC";
  public _user: User;
  public environmentName = "";
  public _IsShowMsg: boolean;
  public _MsgText: string;
  public commentHistory: string;
  public noteDetail: string;
  trustedNoteDetail: SafeHtml;
  trustedChecklistDetail: SafeHtml;
  trustedNoteAllocationPercentage: SafeHtml;
  public rolename: string;
  r1Data;
  r2Data;
  dataMap;

  public _isShowChecklist: boolean = false;
  public _isShowWorkflowWithoutValidationAndEmail: boolean = false;
  public _isShowWorkActualWorkflow: boolean = false;
  lstPurposeType: any;
  noteswithAllocationPercentage: string;
  noteswithAllocationAmount: string;
  _totalfundingamount: string;
  _IsTeamApproval: boolean = false;
  delphinoteswithAmount: string
  _IsAlreadyCancel: boolean = false;
  _IsAlreadyCancelNegativeAmt: boolean = false;
  public defaultSpecialInstructions: string;
  _wfamount: number;
  ListHoliday: any;
  private _drawFeeInvoice: DrawFeeInvoiceDetail
  _isShowDrawFee: boolean = false;
  _autoSendInvoice: number;
  public _dealfundingDrawFee: DealFunding;
  public _basecurrencyname: any;
  public notificatio_type: string;
  public lstStates: any = [];
  public _isShowinvoicesaveMsg: boolean = false;
  public IsSaveClick: boolean = false;
  public clickButtonType: string = "";
  public _drawFeeInvoiceOrignal: DrawFeeInvoiceDetail
  public IsShowSaveAndStatusButton: boolean = true;
  public IsDrawFeeEditClick: boolean = false;
  public ReserveScheduleBreakDownPrelim: string;
  public ReserveScheduleBreakDownFinal: string;
  public ReserveScheduleBreakDown: string
  _lstReserveScheduleBreakDown: any;
  public chkListTitle: string
  public isShowSendButton: boolean = true;
  public tblPayoff: string = "";
  public _invoiceStorageType = appsettings._invoiceStorageType;
  public _invoiceLocation = appsettings._invoiceLocation;

  constructor(
    private _router: Router,
    private _actrouting: ActivatedRoute,
    public utilityService: UtilityService,
    public wfSrv: WFService,
    public dealSrv: dealService,
    public fileUploadService: FileUploadService,
    public dataService: DataService,
    private sanitizer: DomSanitizer

  ) {
    this._isShowbtnRejected = false;
    this._isShowbtnSaveDraft = false;
    this._isShowbtnApproval = false;
    this._notificationmaster = new WFNotificationMaster(0);
    this._wfNotificationDetail = new WFNotificationDetailDataContract(0);
    WFNotificationDetailDataContract
    let WFTaskDetailId;
    this._workflow = new Workflow(WFTaskDetailId);
    this._drawFeeInvoice = new DrawFeeInvoiceDetail("");
    this._drawFeeInvoiceOrignal = new DrawFeeInvoiceDetail("");

    this._wfAdditionalData = new WFAdditionalData(WFTaskDetailId);
    //this._wfCheckListData = new WFCheckListData(WFTaskDetailId);
    this._wfStatusData = new WFStatusData(WFTaskDetailId);
    this.rolename = window.localStorage.getItem("rolename");
    this._actrouting.params.forEach((params: Params) => {
      if (params['id'] !== undefined) {
        this._workflow.TaskID = params['id'];
        this._dealfunding = new DealFunding('');
        this._dealfunding.DealFundingID = this._workflow.TaskID;
        this._dealfundingDrawFee = new DealFunding('');
        this._dealfundingDrawFee.DealFundingID = this._workflow.TaskID;

      }
      if (params['tasktype'] !== undefined) {
        this._workflow.TaskTypeID = params['tasktype'];
      }

    });
    this._user = JSON.parse(localStorage.getItem('user'));
    // this._workflow.TaskID = 'A6146174-B5AC-44AE-8D62-0412A6A14C98';
    this.GetHolidayList();
    this.GetAllLookups();
    this.getWorkFlowDetail(this._workflow);
    this.utilityService.setPageTitle("M61–Workflow Detail");
    this.trustedNoteDetail = this.getSafeHTML();
    //this.getAllStatesMaster();
    //this.GetDrawFeeInvoiceDetailByTaskID();
    //this.trustedNoteAllocationPercentage = this.getSafeHTMLNoteAllocationPercentage()


  }
  getSafeHTML() {
    return this.sanitizer.bypassSecurityTrustHtml(this.noteswithAmount);
  }
  //getSafeHTMLNoteAllocationPercentage() {
  //    return this.sanitizer.bypassSecurityTrustHtml(this.noteswithAllocationPercentage);
  //}
  GetAllLookups(): void {
    this.dealSrv.getAllLookup().subscribe(res => {
      var data = res.lstLookups;
      this.lstAllStatusByPurposeType = data.filter(x => x.ParentID == "77");
      this.lstCheckListStatusType = data.filter(x => x.ParentID == "78");

      //set dropdown for
      // this._bindGridDropdows();
    });
  }

  private _bindGridDropdows() {
    var flexWFCheckList = this.flexWFCheckList;

    if (flexWFCheckList) {
      var colCheckListStatusType = flexWFCheckList.columns.getColumn('CheckListStatusText');
      if (colCheckListStatusType) {
        //colCheckListStatusType.showDropDown = true;
        colCheckListStatusType.dataMap = this._buildDataMap(this.lstCheckListStatusType, 'LookupID', 'Name');
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

  getWorkFlowDetail(_workflow: Workflow): void {

    if (localStorage.getItem('divSucessWorkflow') == 'true') {
      this._Showmessagediv = true; //Vishal
      this._ShowmessagedivMsg = localStorage.getItem('divSucessMsgWorkflow');
      this._ShowmessagedivMsg = (this._ShowmessagedivMsg.replace('\"', '')).replace('\"', '');
      localStorage.setItem('divSucessWorkflow', JSON.stringify(false));
      localStorage.setItem('divSucessMsgWorkflow', JSON.stringify(''));
      setTimeout(function () {
        this._Showmessagediv = false;
      }.bind(this), 5000);
    }

    this._isWFFetching = true;
    this.wfSrv.GetWorkflowDetailByTaskId(_workflow).subscribe(res => {
      if (res.Succeeded) {
        if (typeof res.UserPermissionList !== 'undefined' && res.UserPermissionList.length > 0) {
          this._workflow = res.WFDetailDataContract;
          if (this._workflow.WorkFlowType == "WF_UNDERREVIEW") {
            this._isShowWorkActualWorkflow = false;
            this._isShowWorkflowWithoutValidationAndEmail = true;
            this._isShowDrawFee = false;
          }
          else {
            this._isShowWorkActualWorkflow = true;
            this._isShowWorkflowWithoutValidationAndEmail = false;

            if (this._workflow.TaskTypeID == 502) {
              var checklistYes = res.WFDetailDataContract.WFCheckList.filter(x => x.CheckListMasterId == 6)[0].CheckListStatusText;
              //primary user of that deal will not be able to complete if team's approval checklist item is 'Yes' regardless of the amount
              if (checklistYes == 'Yes' && this._workflow.IsOnlyPrimaryUser == 1 && this._workflow.NextStatusName == 'Completed') {
                this._IsTeamApproval = true;
              }

              var drawFeeApplicable = res.WFDetailDataContract.WFCheckList.filter(x => x.CheckListMasterId == 9)[0].CheckListStatusText;
              //primary user of that deal will not be able to complete if team's approval checklist item is 'Yes' regardless of the amount
              if (drawFeeApplicable == 'Yes') {
                this._isShowDrawFee = true;
              }
            }
            else if (this._workflow.TaskTypeID == 719) {
              this.chkListTitle = "Reserve";
              var checklistYes = res.WFDetailDataContract.WFCheckList.filter(x => x.CheckListMasterId == 15)[0].CheckListStatusText;
              //primary user of that deal will not be able to complete if team's approval checklist item is 'Yes' regardless of the amount
              if (checklistYes == 'Yes' && this._workflow.IsOnlyPrimaryUser == 1 && this._workflow.NextStatusName == 'Completed') {
                this._IsTeamApproval = true;
              }
            }
          }

          //this._CuurentWFStatusPurposeMappingID = this._workflow.WFStatusPurposeMappingID;

          this._wfAdditionalData = res.WFDetailDataContract.WFAdditionalList;

          if (this._wfAdditionalData.BaseCurrencyName == "USD") {
            this._basecurrencyname = '$';
          }
          else {
            this._basecurrencyname = '£';
          }
          this.wfRequiredEquity = this.formatNumberforTwoDecimalplaces(this.GetDefaultValue(this._wfAdditionalData.RequiredEquity));
          this.wfAdditionalEquity = this.formatNumberforTwoDecimalplaces(this.GetDefaultValue(this._wfAdditionalData.AdditionalEquity));

          this._workflow.DealName = this._wfAdditionalData.DealName;
          this._workflow.DrawComment = this._wfAdditionalData.Comment;
          this._isShowPreliminary = this._wfAdditionalData.IsPreliminaryNotification;
          this._isShowRevisedPreliminary = this._wfAdditionalData.IsRevisedPreliminaryNotification;
          this._isShowFinal = this._wfAdditionalData.IsFinalNotification;
          this._isShowRevisedFinal = this._wfAdditionalData.IsRevisedFinalNotification;
          this._isShowFinalPayOff = this._wfAdditionalData.IsFinalNotificationPayOff;
          this._isShowRevisedFinalPayOff = this._wfAdditionalData.IsRevisedFinalNotificationPayOff;

          this._isShowServicer = this._wfAdditionalData.IsServicerNotification;
          this._isShowRevisedServicer = this._wfAdditionalData.IsRevisedServicerNotification;
          this._wfCheckListData = res.WFDetailDataContract.WFCheckList;
          this._wfStatusData = res.WFDetailDataContract.WFStatusList;
          this._workflow.AdditionalComments = this._wfAdditionalData.AdditionalComments;
          this._workflow.SpecialInstructions = this._wfAdditionalData.SpecialInstructions;
          // sepecial instruction default text functionality
          if (this._workflow.PurposeTypeId == 520) {

            //var defaultSpecialInstructions= "";
            if (this._wfAdditionalData.SeniorServicerName != '' && this._wfAdditionalData.SeniorServicerName != null) {
              this.defaultSpecialInstructions = "Wire these funds to the Servicer (" + this._wfAdditionalData.SeniorServicerName + ") per wire instructions on file.\n" +
                "Funds should be directed to Loan #" + this._wfAdditionalData.SeniorCreNoteID + " – Project Expenditure Reserve."
            }

            if (this._workflow.SpecialInstructions == '' || this._workflow.SpecialInstructions == null) {
              this._workflow.SpecialInstructions = this.defaultSpecialInstructions;
            }

            //this._workflow.SpecialInstructions = this._workflow.SpecialInstructions.replace(/^\s+|\s+$/g, '');
          }

          var statuslist = res.WFDetailDataContract.WFStatusList;
          this._CuurentWFStatusPurposeMappingID = statuslist.filter(x => x.StatusName == this._workflow.StatusName)[0].WFStatusPurposeMappingID;

          this.cvwfCheckListData = new wjcCore.CollectionView(this._wfCheckListData);
          this.cvwfCheckListData.trackChanges = true;


          this.lstRejectList = res.lstRejectList;

          this._workflow.WFCheckList = res.WFDetailDataContract.WFCheckList
          this._workflow.StatusDisplayNameWithFormat = this.FormatWFStatusName(this._workflow.StatusDisplayName);
          if (this._RevisedFinal && this._workflow.StatusName.toLowerCase() == 'completed') {
            this._workflow.StatusDisplayNameWithFormat = 'Completed'
          }

          if (this._workflow.NextStatusDisplayName !== undefined && this._workflow.NextStatusDisplayName != null) {
            this._workflow.NextStatusDisplayNameWithFormat = this.FormatWFStatusName(this._workflow.NextStatusDisplayName);
          }
          this.GetWFCommentsByTaskId(_workflow);
          for (var i = 0; i < this._workflow.WFCheckList.length; i++) {

            if (this._workflow.WFCheckList[i].IsMandatory == true) {
              this._workflow.WFCheckList[i].CheckListName = this._workflow.WFCheckList[i].CheckListName;//+ '<b><span [ngStyle]="{color: red}">*</span></b>';

            }
          }

          for (var i = 0; i < this.lstRejectList.length; i++) {

            this.lstRejectList[i].StatusDisplayName = this.FormatWFStatusName(this.lstRejectList[i].StatusDisplayName)
          }

          if (this._wfAdditionalData.BoxDocumentLink != null && this._wfAdditionalData.BoxDocumentLink != '') {
            this._isShowDownloadDoc = true;
          }
          else {
            this._isShowDownloadDoc = false;
          }

          this._wfamount = parseFloat(this._wfAdditionalData.Amount);
          if (Math.sign(this._wfamount) == -1) {
            var _amount = -1 * this._wfamount;
            this._totalfundingamount = "-$" + _amount.toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
          }
          else
            this._totalfundingamount = "$" + this._wfamount.toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");

          if (this._workflow.wf_isAllow == 0) {
            this.HideButton();
          }
          else {
            this._isShowbtnApproval = true;
            //this._isShowbtnRejected = true;
            this._isShowbtnSaveDraft = true;
          }
          if (this._workflow.wf_isAllowReject == 0 || this.lstRejectList.length == 0) {
            this._isShowbtnRejected = false;
          }
          else {
            this._isShowbtnRejected = true;
          }

          if (this._workflow.StatusName == "Projected") {
            this._wfNotificationDetail.WFNotificationMasterID = 1;
          }

          //get notification config-- WFNotificationMasterID not being used in below functions
          this.getWFNotificationConfigByNotificationType(this._wfNotificationDetail.WFNotificationMasterID);

          this.getTemplateRecipientEmailIDs(this._wfNotificationDetail.WFNotificationMasterID);

          if (this._workflow.TaskTypeID == 502) {
            this.GetDealFundingByDealID();
            //commented on 20 march 2020 by shahid as we need to discuss the rouding rule
            this.GetNoteAllocationPercentage();
            //
            this.getAllStatesMaster();
            this.GetDrawFeeInvoiceDetailByTaskID();

            if (this._workflow.WorkFlowType == "WF_UNDERREVIEW" && this._workflow.PurposeTypeId == 630) {
              this.GetWFPayOffNoteFunding();
            }

          }
          else if (this._workflow.TaskTypeID == 719) {
            this.GetReserveScheduleBreakDown();
          }

          //alert(JSON.stringify(res.WFDetailDataContract))
          //alert(JSON.stringify(this._workflow))
        } else {

          localStorage.setItem('showWarningMsgdashboard', JSON.stringify(true));
          localStorage.setItem('WarmsgdashBoad', JSON.stringify('Sorry, you do not have permissions to access this page'));

          this.utilityService.navigateUnauthorize();
        }
        //console.log(this._workflow);
        this._isWFFetching = false;
        //////////////////Check list dropdown bind///////////////////

        //add line_id to aid in the filter  

        if (this._workflow.WorkFlowType == "WF_UNDERREVIEW") {
          this.r1Data = [
            {
              "line_id": 1,
              "LookupID": 499,
              "Name": "Yes"
            },
            {
              "line_id": 1,
              "LookupID": 616,
              "Name": "No"
            }
          ];
        }
        else {
          this.r1Data = [
            {
              "line_id": 1,
              "LookupID": 499,
              "Name": "Yes"
            },
            {
              "line_id": 1,
              "LookupID": 500,
              "Name": "Waived"
            },
            {
              "line_id": 1,
              "LookupID": 501,
              "Name": "N/A"
            },
            {
              "line_id": 1,
              "LookupID": 550,
              "Name": "Pending"
            }
          ];
        }


        this.r2Data = [
          {
            "line_id": 2,
            "LookupID": 499,
            "Name": "Yes"
          },
          {
            "line_id": 2,
            "LookupID": 616,
            "Name": "No"
          }
        ];

        //let combinedMapData = [...this.r1Data, ...this.r2Data, ...this.r3Data, ...this.r4Data, ...this.r5Data, ...this.r6Data];
        let combinedMapData = [...this.r1Data, ...this.r2Data];

        this.dataMap = new wjcGrid.DataMap(combinedMapData, 'LookupID', 'Name');
        (this.dataMap as any).getDisplayValues = (item => {
          if (!item) {
            return combinedMapData.map(item => item.Name);
          }

          let x = combinedMapData.filter((cItem) => {
            if (cItem.line_id == item.RowId) {
              return true;
            }
            else if (cItem.line_id == 1 && item.RowId != 1 && item.RowId != 2) {
              return true;
            }
            return false;
          }).map(item => item.Name);
          return x;
        });


        var flexWFCheckList = this.flexWFCheckList;


        if (flexWFCheckList) {
          var colCheckListStatusType = flexWFCheckList.columns.getColumn('CheckListStatusText');
          if (colCheckListStatusType) {
            //colCheckListStatusType.showDropDown = true;
            colCheckListStatusType.dataMap = this.dataMap //this._buildDataMap(this.lstCheckListStatusType);
          }
        }

        this.cvwfCheckListData.newItemCreator = function () {
          return {
            CheckListName: '',
            Status: this.r1Data,
            Comment: '',
            RowID: 1
          };
        };


      }
      else {
        this._router.navigate(['login']);
      }
    });

    error => console.error('Error: ' + error)
  }

  init(flexgrid) {
    //some initializzation work for grid
      flexgrid.formatItem.addHandler((s, e) => {
        //if (e.panel.cellType != wjcGrid.CellType.Cell) {
        //    return;
        //}
        if (e.panel.columns[e.col].binding == "CheckListStatusText") {
          let item = e.panel.rows[e.row].dataItem;
          if (!(item == undefined || item == null)) {
            if (item.IsDisable == true) {
              wjcCore.addClass(e.cell, 'disable-col');
            }
          }
        }
      });
  }

  cellEditbeginCheckList(s, e) {
    if (e.col.toString() == "1") {
      if (this.cvwfCheckListData._view !== undefined) {
        if (this._workflow.IsDisableFundingTeamApproval == 1 && (this.cvwfCheckListData._view[e.row].CheckListMasterId == 6 || this.cvwfCheckListData._view[e.row].CheckListMasterId == 15)) {
          e.cancel = true;
        }

        if (this._drawFeeInvoice.DrawFeeStatus != 692 && this._drawFeeInvoice.DrawFeeStatus != 0 && this.cvwfCheckListData._view[e.row].CheckListMasterId == 9) {
          e.cancel = true;
        }

      }
    }
  }
  cellEditEndedChecklist(s, e) {
    if (e.col.toString() == "1") {
      //any AM can do till first approval so no need to check anything in that case
      if (this.cvwfCheckListData._view !== undefined && this._workflow.WFStatusMasterID > 2) {
        if ((this.cvwfCheckListData._view[e.row].CheckListMasterId == 6 || this.cvwfCheckListData._view[e.row].CheckListMasterId == 15) && this.cvwfCheckListData._view[e.row].CheckListStatusText == "499"
          && this._workflow.IsOnlyPrimaryUser == 1 && this._workflow.NextStatusName == 'Completed') {
          this._IsTeamApproval = true
        }
        else {
          this._IsTeamApproval = false;
        }

      }
      if (this.cvwfCheckListData._view !== undefined) {
        if (this.cvwfCheckListData._view[e.row].CheckListMasterId == 9) {
          if (this.cvwfCheckListData._view[e.row].CheckListStatusText == "499") {
            this._isShowDrawFee = true
            if (this.IsDrawFeeEditClick == true)
              this.enableDrawSection();
            else {
              setTimeout(function () {
                this.enableDisableDrawFeeSection();
              }.bind(this), 1000);
            }

          }
          else
            this._isShowDrawFee = false;
        }
      }
    }
  }

  CheckWireConfirmedOnReject(): void {

    this._isWFFetching = true;
    this.wfSrv.GetWorkflowAdditionalDetailByTaskId(this._workflow).subscribe(res => {
      if (res.Succeeded) {
        var _additionalData = res.WFDetailDataContract.WFAdditionalList;
        if (_additionalData.Applied == true) {
          this._isWFFetching = false;
          var msg = "";
          msg = "<p>You can not reject the draw which is already wireconfirmed.";
          this.savedialogmsg = msg;
          this.CustomDialogteSave();
        }
        else {
          if (this._workflow.WorkFlowType == "WF_UNDERREVIEW")
            this.SaveWorkFlowWithoutEmail();
          else
            this.SaveWorkFlow();
        }
      }
      else {
        this._router.navigate(['login']);
      }
    });

    error => console.error('Error: ' + error)
  }

  convertDateToBindable(date) {
    var dateObj = new Date(date);

    var mlist = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    var days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

    return days[dateObj.getDay()] + ", " + mlist[dateObj.getMonth()] + " " + this.AsOrdinal(dateObj.getDate()) + ", " + dateObj.getFullYear();
  }

  convertDateTime(date) {
    var dateObj = new Date(date);
    var ampm = dateObj.getHours() >= 12 ? 'PM' : 'AM'
    var mlist = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    var days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

    return days[dateObj.getDay()] + ", " + mlist[dateObj.getMonth()] + " " + this.AsOrdinal(dateObj.getDate()) + ", " + dateObj.getFullYear() + " " + dateObj.getHours() + ":" + dateObj.getMinutes() + ":" + dateObj.getSeconds() + " " + ampm;
  }

  convertDateTimeIn12Hours(date) {
    var dateObj = new Date(date);
    var mlist = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    var days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    var hours = dateObj.getHours() == 0 ? "12" : dateObj.getHours() > 12 ? dateObj.getHours() - 12 : dateObj.getHours();
    var minutes = (dateObj.getMinutes() < 10 ? "0" : "") + dateObj.getMinutes();
    var ampm = dateObj.getHours() < 12 ? "AM" : "PM";
    return days[dateObj.getDay()] + ", " + mlist[dateObj.getMonth()] + " " + this.AsOrdinal(dateObj.getDate()) + ", " + dateObj.getFullYear() + " " + hours + ":" + minutes + " " + ampm;
  }

  convertDateTOMMDDYYYY(date) {
    var dateObj = new Date(date);
    var ampm = dateObj.getHours() >= 12 ? 'PM' : 'AM'
    var mlist = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    var days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

    //return dateObj.getMonth() + "/" + dateObj.getDate() + "/" + dateObj.getFullYear();
    return ("0" + (dateObj.getMonth() + 1)).slice(-2) + "/" + ("0" + dateObj.getDate()).slice(-2) + "/" + dateObj.getFullYear();
  }


  AsOrdinal(number): string {
    var work = number;
    work = work.toString()
    var modOf100 = number % 100;

    if (modOf100 == 11 || modOf100 == 12 || modOf100 == 13)
      return work + "th";

    switch (number % 10) {
      case 1:
        work += "st"; break;
      case 2:
        work += "nd"; break;
      case 3:
        work += "rd"; break;
      default:
        work += "th"; break;
    }
    return work;
  }


  getTwoDigitString(number) {
    if (number.toString().length === 1)
      return "0" + number;
    return number;
  }

  SaveWorkFlow(): void {
    this._workflow.WFAdditionalList = null;
    this.IsShowSaveAndStatusButton = false;
    //Promise.all(this.saveDrawFeeInvoice()).then(() => { }).catch(() => { });

    this.wfSrv.SaveWorkflowDetailByTaskId(this._workflow).subscribe(res => {
      if (res.Succeeded) {
        if (parseFloat(this._wfAdditionalData.Amount) > 0) {
          if (this._workflow.StatusName == 'Projected' && this._workflow.SubmitType == 498) {

            var notification_type = this._isShowRevisedPreliminary == true ? this._RevisedPreliminary : this._Preliminary;
            this.GetWFCommentsByTaskIdOnNotification(this._workflow, notification_type);
            //this.showWFNotificationDialog(this._Preliminary);
            this.IsShowSaveAndStatusButton = true;
            this._isWFFetching = false;
          }
          else if (this._workflow.NextStatusName == 'Completed' && this._workflow.SubmitType == 498) {
            var notification_type = this._isShowRevisedFinal == true ? this._RevisedFinal : this._Final;
            this.GetWFCommentsByTaskIdOnNotification(this._workflow, notification_type);
            // this.showWFNotificationDialog(this._Final);
            this.IsShowSaveAndStatusButton = true;
            this._isWFFetching = false;
          }
          //else if (this.rolename == 'Asset Manager' && this.IsSaveClick == true && this._isShowDrawFee == true && (this._drawFeeInvoice.DrawFeeStatus == 0 || this._drawFeeInvoice.DrawFeeStatus == 692 || this._drawFeeInvoice.DrawFeeStatus == 696)) {
          //    this._isShowinvoicesaveMsg = true;
          //    this.saveDrawFeeInvoice();
          //    this.IsSaveClick = false;
          //}

          else {

            var notenewcopied;
            if (window.location.href.indexOf("dealdetail/a") > -1) {
              notenewcopied = ['dealdetail', this._wfAdditionalData.CREDealID]
            }
            else {
              notenewcopied = ['dealdetail/a', this._wfAdditionalData.CREDealID]
            }

            localStorage.setItem('ClickedTabId', 'aFunding');
            localStorage.setItem('divSucessDeal', 'true');
            localStorage.setItem('divSucessMsgDeal', 'Draw approval status updated successfully');

            this._router.navigate(notenewcopied);
          }
        }

        else {

          var notenewcopied;
          if (window.location.href.indexOf("dealdetail/a") > -1) {
            notenewcopied = ['dealdetail', this._wfAdditionalData.CREDealID]
          }
          else {
            notenewcopied = ['dealdetail/a', this._wfAdditionalData.CREDealID]
          }

          localStorage.setItem('ClickedTabId', 'aFunding');
          localStorage.setItem('divSucessDeal', 'true');
          localStorage.setItem('divSucessMsgDeal', 'Draw approval status updated successfully');

          this._router.navigate(notenewcopied);
        }


      }
      else {
        this._router.navigate(['login']);
      }
    });

    error => console.error('Error: ' + error)

  }

  SaveWorkFlowWithoutEmail(): void {

    // this.showWFNotificationDialog(this._Preliminary);
    this._workflow.WFAdditionalList = null;

    this.wfSrv.SaveWorkflowDetailByTaskId(this._workflow).subscribe(res => {
      if (res.Succeeded) {
        var notenewcopied;

        //payoff email functionality
        if (this._workflow.NextStatusName == 'Completed' && this._workflow.SubmitType == 498
          && this._workflow.PurposeTypeId == 630
        ) {
          var notification_type = this._FinalWithoutApproval;
          this.showWFNotificationDialogForNegativeAmt(notification_type);
          this._isWFFetching = false;
        }

        else {
          if (window.location.href.indexOf("dealdetail/a") > -1) {
            notenewcopied = ['dealdetail', this._wfAdditionalData.CREDealID]
          }
          else {
            notenewcopied = ['dealdetail/a', this._wfAdditionalData.CREDealID]
          }

          localStorage.setItem('ClickedTabId', 'aFunding');
          localStorage.setItem('divSucessDeal', 'true');
          localStorage.setItem('divSucessMsgDeal', 'Draw approval status updated successfully');

          this._router.navigate(notenewcopied);

          this._isWFFetching = false;
        }
      }
      else {
        this._router.navigate(['login']);
      }
    });

    error => console.error('Error: ' + error)

  }

  saveWorkFlowDetailWithoutEmail(newvalue, btnType): void {
    this._isRefresh = true;
    this._isNotificationMsg = false;
    this._isWFFetching = true;

    if (btnType == 'Rejected') {
      this._workflow.SubmitType = 496;

      var selectedText = newvalue.target.className;
      selectedText = selectedText.trim();
      var newWFStatusPurposeMappingID = this.lstRejectList.filter(x => x.StatusName == selectedText)[0].WFStatusPurposeMappingID;
      this._workflow.WFStatusPurposeMappingID = newWFStatusPurposeMappingID;
      this.CheckWireConfirmedOnReject()
      //this.SaveWorkFlowWithoutEmail();

      return;
    }
    else if (btnType == 'Draft') {
      this._workflow.SubmitType = 497;
      this._workflow.WFStatusPurposeMappingID = this._CuurentWFStatusPurposeMappingID;
    }
    else if (btnType == 'Save') {
      this._workflow.SubmitType = 551;
      this._workflow.WFStatusPurposeMappingID = this._CuurentWFStatusPurposeMappingID;
    }
    else {

      this._workflow.SubmitType = 498;
      this._workflow.WFStatusPurposeMappingID = this._workflow.NextWFStatusPurposeMappingID;
    }

    for (var i = 0; i < this._workflow.WFCheckList.length; i++) {
      if (!(Number(this._workflow.WFCheckList[i].CheckListStatusText).toString() == "NaN" || Number(this._workflow.WFCheckList[i].CheckListStatusText) == 0)) {
        this._workflow.WFCheckList[i].CheckListStatus = Number(this._workflow.WFCheckList[i].CheckListStatusText);
      }
    }

    if (this.IsValidateWithoutEmail(btnType)) {
      this.SaveWorkFlowWithoutEmail();
    } else {
      this._isWFFetching = false;
      this.CustomDialogteSave();
    }

  }

  IsValidateWithoutEmail(btnType): boolean {

    var retvalue = true;
    var msg = "";
    var lookupidForYes = this.lstCheckListStatusType.filter(x => x.Name.toString().toLowerCase() === 'yes')[0].LookupID;



    if (this._wfAdditionalData.Comment == undefined || this._wfAdditionalData.Comment == '') {
      retvalue = false;
      msg = "<p>Draw Number is mandatory for draw approval process.";
      this.savedialogmsg = msg;
      return retvalue;
    }
    var chkListWithMandatoryFields = this._workflow.WFCheckList;

    for (var i = 0; i < chkListWithMandatoryFields.length; i++) {
      if (chkListWithMandatoryFields[i].hasOwnProperty('CheckListName') == false) {
        this._workflow.WFCheckList[i].CheckListName = '';
      }
      if (chkListWithMandatoryFields[i].hasOwnProperty('CheckListStatusText') == false) {
        this._workflow.WFCheckList[i].CheckListStatusText = '';
      }
      if (chkListWithMandatoryFields[i].hasOwnProperty('Comment') == false) {
        this._workflow.WFCheckList[i].Comment = '';
      }

    }

    //Check list name required
    var blankChklist = this._workflow.WFCheckList.filter(x => x.CheckListName.trim() === '' && (x.CheckListStatusText != '' || x.Comment != ''));
    if (blankChklist.length > 0) {
      retvalue = false;
      msg = "<p>Check list name should not be blank.";
      this.savedialogmsg = msg;
      return retvalue;
    }
    if (btnType != 'Draft' && btnType != 'Save') {
      if (this._workflow.StatusName == "Projected") {
        for (var i = 0; i < chkListWithMandatoryFields.length; i++) {
          if (chkListWithMandatoryFields[i].CheckListMasterId == 7) {
            if (Number(chkListWithMandatoryFields[i].CheckListStatus).toString() != lookupidForYes) {
              retvalue = false;
              msg = "<p>" + chkListWithMandatoryFields[i].CheckListName + " should be marked as YES for requested status.";
            }
          }
          if (chkListWithMandatoryFields[i].CheckListMasterId == 8) {
            if (Number(chkListWithMandatoryFields[i].CheckListStatus).toString() == lookupidForYes) {
              retvalue = false;
              msg = msg + "<p>" + chkListWithMandatoryFields[i].CheckListName + " should not be marked as YES for requested status.";

            }
          }
        }
      }
      else if (this._workflow.wfFlag == 'FinalState') {
        for (var i = 0; i < chkListWithMandatoryFields.length; i++) {
          if (Number(chkListWithMandatoryFields[i].CheckListStatus).toString() != lookupidForYes) {
            retvalue = false;
            msg = "<p>All checklist items should be marked as YES for completed status.";
            break;
          }
        }
        var todaysdate = new Date();
        var wcDate = new Date(this._wfAdditionalData.Date);
        if (wcDate > todaysdate) {
          retvalue = false;
          msg = msg + "<p>" + "Funding date should not be greater than today's date." + "</p>";
        }
      }
    }
    this.savedialogmsg = msg;

    return retvalue
  }

  ValidateWireConfirmAndsaveWorkFlowDetail(newvalue, btnType): void {

    var retvalue = true;
    var msg = "";
    if (this._workflow.NextStatusName == 'Completed' && btnType == 'Approved' && this._workflow.TaskTypeID == 502) {
      this.wfSrv.ValidateWireConfirmByTaskId(this._workflow).subscribe(res => {
        if (res.Succeeded) {
          var today = new Date();
          var wcDate = new Date(this._wfAdditionalData.Date);
          var nextbdate = this.getnextbusinessDate(today, 10, true);
          if (res.StatusCode != 0) {
            if (res.StatusCode == 1) {
              retvalue = false;
              msg = "<p>You can't confirm wire on a later date without confirming all wires in between.";
            }
          }
          if (wcDate > nextbdate && this._workflow.WorkFlowType == "WF_FUll") {
            retvalue = false;
            msg = msg + "<p>You can only confirm up to " + this.convertDateToBindable(nextbdate) + "."
          }
          if ((this._drawFeeInvoice === undefined || this._drawFeeInvoice.DrawFeeInvoiceDetailID == 0) && this._workflow.WorkFlowType == "WF_FUll" && this._isShowDrawFee == true) {
            retvalue = false;
            msg = msg + "<p>Please save invoice detail before you proceed."
          }

          if (msg != '') {
            this.savedialogmsg = msg;
            this.CustomDialogteSave();
          }
          else {
            if (this._workflow.WorkFlowType == "WF_UNDERREVIEW") {
              this.saveWorkFlowDetailWithoutEmail(newvalue, btnType)
            }
            else {
              this.saveWorkFlowDetail(newvalue, btnType)
            }
          }
        }
        else {
          this._router.navigate(['login']);
        }
      });

      error => console.error('Error: ' + error)
    }
    else if (this._workflow.WorkFlowType == "WF_UNDERREVIEW") {
      this.saveWorkFlowDetailWithoutEmail(newvalue, btnType)
    }
    else {
      this.saveWorkFlowDetail(newvalue, btnType)
    }
  }

  ValidateWireConfirmOnNotify(notificatioType): void {

    var retvalue = true;
    var msg = "";
    if (this._workflow.TaskTypeID == 502) {


      if ((notificatioType == this._Final || notificatioType == this._RevisedFinal) && this._workflow.StatusName == 'Completed') {
        this.wfSrv.ValidateWireConfirmByTaskId(this._workflow).subscribe(res => {
          if (res.Succeeded) {
            var today = new Date();
            var wcDate = new Date(this._wfAdditionalData.Date);
            var nextbdate = this.getnextbusinessDate(today, 10, true);
            if (res.StatusCode != 0) {
              if (res.StatusCode == 1) {
                retvalue = false;
                msg = "<p>You can't confirm wire on a later date without confirming all wires in between.";
              }
            }
            if (wcDate > nextbdate) {
              retvalue = false;
              msg = msg + "<p>You can only confirm up to " + this.convertDateToBindable(nextbdate) + "."
            }

            if (msg != '') {
              this.savedialogmsg = msg;
              this.CustomDialogteSave();
            }
            else {
              this.Notify(notificatioType);
            }
          }
          else {
            this._router.navigate(['login']);
          }
        });

        error => console.error('Error: ' + error)
      }

      else if ((notificatioType == this._Final || notificatioType == this._RevisedFinal) && this._workflow.StatusName != 'Completed') {
        msg = msg + "<p>You need to mark the draw as completed before sending revised final notification.";
        this.savedialogmsg = msg;
        this.CustomDialogteSave();
      }
      else {
        this.Notify(notificatioType);
      }
    }
    else if (this._workflow.TaskTypeID == 719)//reserve workflow
    {
      this.Notify(notificatioType);
    }
  }

  ValidateWireConfirmNegativAmtOnNotify(notificatioType): void {

    var retvalue = true;
    var msg = "";
    if (this._workflow.TaskTypeID == 502) {


      if ((notificatioType == this._FinalWithoutApproval || notificatioType == this._RevisedFinalWithoutApproval) && this._workflow.StatusName == 'Completed') {
        this.wfSrv.ValidateWireConfirmByTaskId(this._workflow).subscribe(res => {
          if (res.Succeeded) {
            var today = new Date();
            var wcDate = new Date(this._wfAdditionalData.Date);
            var nextbdate = this.getnextbusinessDate(today, 10, true);
            if (res.StatusCode != 0) {
              if (res.StatusCode == 1) {
                retvalue = false;
                msg = "<p>You can't confirm wire on a later date without confirming all wires in between.";
              }
            }

            if (msg != '') {
              this.savedialogmsg = msg;
              this.CustomDialogteSave();
            }
            else {
              this.Notify(notificatioType);
            }
          }
          else {
            this._router.navigate(['login']);
          }
        });

        error => console.error('Error: ' + error)
      }

      else if ((notificatioType == this._FinalWithoutApproval || notificatioType == this._RevisedFinalWithoutApproval) && this._workflow.StatusName != 'Completed') {
        msg = msg + "<p>You need to mark the draw as completed before sending revised final notification.";
        this.savedialogmsg = msg;
        this.CustomDialogteSave();
      }
      else {
        this.Notify(notificatioType);
      }
    }

  }

  getnexybusinessDate(sDate: Date, noofDays: number): Date {
    var daycnt = sDate.getDay();
    if (daycnt == 6)
      sDate.setDate(sDate.getDate() + 1);
    if (daycnt == 1 || daycnt == 2 || daycnt == 3 || daycnt == 4 || daycnt == 5)
      sDate.setDate(sDate.getDate() + 2);

    sDate.setDate(sDate.getDate() + noofDays);

    return sDate;
  }
  getnextbusinessDate(sDate: Date, noofDays: number, addorsub: boolean): Date {
    if (sDate) {
      var i = 0;
      while (i < Math.abs(noofDays)) {
        // for (var i = 1; i < Math.abs(noofDays); i++) {
        var daycnt = sDate.getDay();
        var formateddate = this.convertDateToBindable(sDate);
        if (addorsub == true) {
          if (daycnt == 6 || daycnt == 0
            || this.ListHoliday.filter(x => this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411).length > 0
          ) {
            sDate.setDate(sDate.getDate() + 1);
          }
          if (daycnt == 1 || daycnt == 2 || daycnt == 3 || daycnt == 4 || daycnt == 5) {
            sDate.setDate(sDate.getDate() + 1);
            i++;
          }
          //  sDate.setDate(sDate.getDate() + 1);

        }
        else {
          if (daycnt == 6 || daycnt == 0
            || this.ListHoliday.filter(x => this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411).length > 0
          ) {
            sDate.setDate(sDate.getDate() - 1);
            // i--;
          }
          else {
            sDate.setDate(sDate.getDate() - 1);
            i++;
          }

        }
      }
    }


    //
    for (var j = 0; j < 7; j++) {
      formateddate = this.convertDateToBindable(sDate);
      var daycnt = sDate.getDay();
      if (daycnt == 6 || daycnt == 0
        || this.ListHoliday.filter(x => this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411).length > 0
      ) {
        sDate.setDate(sDate.getDate() - 1);

      }
      else
        return sDate;
    }

    return sDate;
  }
  private GetHolidayList(): void {
    if (this.ListHoliday == null || this.ListHoliday === undefined)

      this.dealSrv.getHolidayList().subscribe(res => {
        if (res.Succeeded) {
          this.ListHoliday = res.HolidayList;
        }
        else
          this.ListHoliday = null;
      });
  }

  saveWorkFlowDetail(newvalue, btnType): void {
    this._isRefresh = true;
    this._isNotificationMsg = false;
    this._isWFFetching = true;
    this.clickButtonType = btnType;

    if (this.commentHistory != '') {
      this._workflow.ActivityLog = "<b>Activity log are below:</b><br/>" + this.commentHistory
    }
    this._workflow.FooterText = "Thank you,<br/>" + this._user.FirstName + ' ' + this._user.LastName + '<br/>' + this._user.Email + ((this._user.ContactNo1 != '' && this._user.ContactNo1 != null) ? ' | ' + this._user.ContactNo1 : '');
    this._workflow.SenderName = this._user.FirstName + ' ' + this._user.LastName;

    this._workflow.WFCheckListStatus = this.lstCheckListStatusType;
    if (btnType == 'Rejected') {
      this._workflow.SubmitType = 496;

      var selectedText = newvalue.target.className;
      selectedText = selectedText.trim();
      var newWFStatusPurposeMappingID = this.lstRejectList.filter(x => x.StatusName == selectedText)[0].WFStatusPurposeMappingID;
      this._workflow.WFStatusPurposeMappingID = newWFStatusPurposeMappingID;

      this.CheckWireConfirmedOnReject()
      //this.SaveWorkFlow();

      return;
    }
    else if (btnType == 'Draft') {
      this._workflow.SubmitType = 497;
      this._workflow.WFStatusPurposeMappingID = this._CuurentWFStatusPurposeMappingID;
    }
    else if (btnType == 'Save') {
      this._workflow.SubmitType = 551;
      this._workflow.WFStatusPurposeMappingID = this._CuurentWFStatusPurposeMappingID;
      this.IsSaveClick = true;
    }
    else {

      this._workflow.SubmitType = 498;
      this._workflow.WFStatusPurposeMappingID = this._workflow.NextWFStatusPurposeMappingID;
    }




    for (var i = 0; i < this._workflow.WFCheckList.length; i++) {
      if (!(Number(this._workflow.WFCheckList[i].CheckListStatusText).toString() == "NaN" || Number(this._workflow.WFCheckList[i].CheckListStatusText) == 0)) {
        this._workflow.WFCheckList[i].CheckListStatus = Number(this._workflow.WFCheckList[i].CheckListStatusText);
      }
    }

    if (this.IsValidate(btnType)) {
      if (this.rolename == 'Asset Manager' && (btnType == 'Save' || btnType == "Approved") && this._isShowDrawFee == true &&
        (this._drawFeeInvoice.DrawFeeStatus == 0 || this._drawFeeInvoice.DrawFeeStatus == 692 || this._drawFeeInvoice.DrawFeeStatus == 696)) {
        this.saveDrawFeeInvoiceAndWorkFlow();
      }
      else {
        this.SaveWorkFlow();
      }
    } else {
      this._isWFFetching = false;
      this.CustomDialogteSave();
    }

  }
  FormatWFStatusName(statusname): string {
    if (statusname == null) {
      return "";
    }
    var status = statusname;
    if (status.indexOf('1st') !== -1) {
      status = '1<sup>st</sup>' + status.replace("1st", "");
    }
    else if (status.indexOf('2nd') !== -1) {
      status = '2<sup>nd</sup>' + status.replace("2nd", "");
    }
    else if (status.indexOf('3rd') !== -1) {
      status = '3<sup>rd</sup>' + status.replace("3rd", "");
    }
    return status;
  }

  IsValidate(btnType): boolean {

    var retvalue = true;
    var msg = "";


    //user need to sendf prelim notifiation before moving further after under review status
    //if debt amt = 0 then skip sending prelim notification
    if (parseFloat(this._wfAdditionalData.Amount) > 0) {
      if (this._workflow.StatusName.toLowerCase() == 'under review' && this._workflow.SubmitType == 498 && this._isShowPreliminary == true) {
        retvalue = false;
        msg = "<p>Please send the preliminary  Notification before changing the Funding Status.";
        this.savedialogmsg = msg;
        return retvalue;
      }
    }
    //



    if (this._wfAdditionalData.Comment == undefined || this._wfAdditionalData.Comment == '') {
      retvalue = false;
      msg = "<p>Draw Number is mandatory for draw approval process.";
      this.savedialogmsg = msg;
      return retvalue;
    }

    //shahid-as per new reuirement comment box should be removed so commented validations
    //if (btnType == 'Save') {
    //    if (this._workflow.Comment == '' || this._workflow.Comment == undefined) {
    //        retvalue = false;
    //        msg = "<p>Comment is required to save the checklist.";
    //        this.savedialogmsg = msg;
    //        return retvalue;
    //    }
    //}



    var lookupidForYes = this.lstCheckListStatusType.filter(x => x.Name.toString().toLowerCase() === 'yes')[0].LookupID;
    var lookupidForNA = this.lstCheckListStatusType.filter(x => x.Name.toString().toLowerCase() === 'n/a')[0].LookupID;
    var lookupidForWaived = this.lstCheckListStatusType.filter(x => x.Name.toString().toLowerCase() === 'waived')[0].LookupID;
    var lookupidForPending = this.lstCheckListStatusType.filter(x => x.Name.toString().toLowerCase() === 'pending')[0].LookupID;

    var chkListWithMandatoryFields = this._workflow.WFCheckList;

    for (var i = 0; i < chkListWithMandatoryFields.length; i++) {
      if (chkListWithMandatoryFields[i].hasOwnProperty('CheckListName') == false) {
        this._workflow.WFCheckList[i].CheckListName = '';
      }
      if (chkListWithMandatoryFields[i].hasOwnProperty('CheckListStatusText') == false) {
        this._workflow.WFCheckList[i].CheckListStatusText = '';
      }
      if (chkListWithMandatoryFields[i].hasOwnProperty('Comment') == false) {
        this._workflow.WFCheckList[i].Comment = '';
      }

    }

    //Check list name required
    var blankChklist = this._workflow.WFCheckList.filter(x => x.CheckListName.trim() === '' && (x.CheckListStatusText != '' || x.Comment != ''));
    if (blankChklist.length > 0) {
      retvalue = false;
      msg = "<p>Check list name should not be blank.";
      this.savedialogmsg = msg;
      return retvalue;
    }


    if (this._workflow.wfFlag == 'FinalState') {
      if (btnType == 'Draft' || btnType == 'Save')//Vishal 
      {

        for (var i = 0; i < this._workflow.WFCheckList.length; i++) {
          if (Number(this._workflow.WFCheckList[i].CheckListStatus).toString() == lookupidForNA || Number(this._workflow.WFCheckList[i].CheckListStatus).toString() == lookupidForWaived) {
            if (this._workflow.WFCheckList[i].Comment == null) this._workflow.WFCheckList[i].Comment = '';

            if (this._workflow.WFCheckList[i].Comment.trim() == '') {
              retvalue = false;
              msg = "<p>Comment is required for N/A or Waived.";
              break;
            }
          }
        }

        chkListWithMandatoryFields = this._workflow.WFCheckList.filter(x => x.IsMandatory === true);
        for (var i = 0; i < chkListWithMandatoryFields.length; i++) {
          if (Number(chkListWithMandatoryFields[i].CheckListStatus).toString() != lookupidForYes) {
            retvalue = false;
            msg = "<p>" + chkListWithMandatoryFields[i].CheckListName.replace('*', '') + " is mandatory.";
            break;
          }
        }


      }
      else {

        for (var i = 0; i < this._workflow.WFCheckList.length; i++) {
          if (Number(this._workflow.WFCheckList[i].CheckListStatus).toString() == lookupidForNA || Number(this._workflow.WFCheckList[i].CheckListStatus).toString() == lookupidForWaived || Number(this._workflow.WFCheckList[i].CheckListStatus).toString() == lookupidForPending) {
            if (this._workflow.WFCheckList[i].Comment == null) this._workflow.WFCheckList[i].Comment = '';

            if (this._workflow.WFCheckList[i].Comment.trim() == '') {
              retvalue = false;
              msg = "<p>Comment is required for N/A, Waived and Pending.";
              break;
            }
          }
        }

        for (var i = 0; i < chkListWithMandatoryFields.length; i++) {
          if (chkListWithMandatoryFields[i].CheckListMasterId != 6 && chkListWithMandatoryFields[i].CheckListMasterId != 15 &&
            chkListWithMandatoryFields[i].CheckListMasterId != 16 && chkListWithMandatoryFields[i].CheckListMasterId != 17 &&
            chkListWithMandatoryFields[i].CheckListMasterId != 9) {
            if (Number(chkListWithMandatoryFields[i].CheckListStatus).toString() != lookupidForYes && Number(chkListWithMandatoryFields[i].CheckListStatus).toString() != lookupidForNA && Number(chkListWithMandatoryFields[i].CheckListStatus).toString() != lookupidForWaived && Number(chkListWithMandatoryFields[i].CheckListStatus).toString() != lookupidForPending) {
              retvalue = false;
              msg = "<p>All checklist items should be marked as YES or N/A or Waived for completed status.";
              break;
            }
          }
        }
        if (this._workflow.TaskTypeID == 719) {

          var checkListService = chkListWithMandatoryFields.filter(x => x.CheckListMasterId == 18)[0];
          //primary user of that deal will not be able to complete if team's approval checklist item is 'Yes' regardless of the amount

          if (Number(checkListService.CheckListStatus).toString() != lookupidForYes) {
            retvalue = false;
            msg = "<p>Checklist item " + checkListService.CheckListName.replace('*', '') + " should be marked as YES for completed status.";
          }
        }
      }
    } else {

      for (var i = 0; i < this._workflow.WFCheckList.length; i++) {
        if (Number(this._workflow.WFCheckList[i].CheckListStatus).toString() == lookupidForNA || Number(this._workflow.WFCheckList[i].CheckListStatus).toString() == lookupidForWaived) {
          if (this._workflow.WFCheckList[i].Comment == null) this._workflow.WFCheckList[i].Comment = '';

          if (this._workflow.WFCheckList[i].Comment.trim() == '') {
            retvalue = false;
            msg = "<p>Comment is required for N/A or Waived.";
            break;
          }
        }
      }

      chkListWithMandatoryFields = this._workflow.WFCheckList.filter(x => x.IsMandatory === true);
      for (var i = 0; i < chkListWithMandatoryFields.length; i++) {
        if (Number(chkListWithMandatoryFields[i].CheckListStatus).toString() != lookupidForYes) {
          retvalue = false;
          msg = "<p>" + chkListWithMandatoryFields[i].CheckListName.replace('*', '') + " is mandatory.";
          break;
        }
      }
    }

    if (this._workflow.TaskTypeID == 502) {
      if (this.rolename == 'Asset Manager' && (btnType == "Save" || btnType == "Approved") && this._isShowDrawFee == false
        && this._workflow.WFCheckList.filter(x => x.CheckListMasterId == 9)[0].CheckListStatus != 499
        && this._workflow.WFCheckList.filter(x => x.CheckListMasterId == 9)[0].Comment == '') {
        retvalue = false;
        msg = "<p>Comment is required when Draw Fee Applicable checklist item is set to No.";
      }

      if (this.rolename == 'Asset Manager' && (btnType == "Save" || btnType == "Approved") && this._isShowDrawFee == true
        && (this._drawFeeInvoice.DrawFeeStatus == 0 || this._drawFeeInvoice.DrawFeeStatus == 692 || this._drawFeeInvoice.DrawFeeStatus == 696)) {
        var errorMsg = this.CheckValidationforDrawFee('');
        if (errorMsg != "") {
          retvalue = false;
          msg = errorMsg;
          //this.CustomAlert(errorMsg);
        }
      }
    }
    this.savedialogmsg = msg;

    return retvalue;
  }


  GetWFCommentsByTaskId(_workflow: Workflow): void {

    this.wfSrv.GetWFCommentsByTaskId(_workflow).subscribe(res => {
      if (res.Succeeded) {
        this.commentHistory = '';
        this.lstWFComments = res.lstWFComments;
        var lstWFStatus = this.lstWFComments.filter(x => (x.SubmitType == 496 || x.SubmitType == 498) && x.WFStatusMasterID != 1 && x.WFStatusMasterID != 2);

        for (var i = 0; i < this.lstWFComments.length; i++) {
          this.lstWFComments[i].StatusName = (this.lstWFComments[i].SubmitType == 496 && this.lstWFComments[i].Comment == '' ? "rejected transaction back to " : "") + this.FormatWFStatusName(this.lstWFComments[i].StatusName);

          if (((this.lstWFComments[i].WFStatusMasterID != 1 && this.lstWFComments[i].WFStatusMasterID != 2) || (this.lstWFComments[i].SubmitType == 496))
            && this.lstWFComments[i].Comment != 'Checklist updated'
            && this.lstWFComments[i].Comment.indexOf("Changed the funding date") < 0 && this.lstWFComments[i].Comment.indexOf("Changed the funding amount") < 0
          ) {
            this.commentHistory += "<i>" + this.lstWFComments[i].Login + "  " + this.lstWFComments[i].StatusName + "  " + this.convertDateTimeIn12Hours(this.lstWFComments[i].CreatedDate) + " " + this.lstWFComments[i].Abbreviation + "</i>" + "\n";
            if (this.lstWFComments[i].Comment != '' && this.lstWFComments[i].Comment != 'Checklist updated') {
              this.commentHistory += this.lstWFComments[i].Comment + "\n";
            }
          }
          //(this.lstWFComments[i].Comment != '' && this.lstWFComments[i].Comment != 'Checklist updated') ? this.lstWFComments[i].Comment + "\n" : '';
          if (!(this.lstWFComments[i].DelegatedUserName == null || this.lstWFComments[i].DelegatedUserName == "" || this.lstWFComments[i].DelegatedUserName == undefined)) {
            this.lstWFComments[i].DelegatedUserName = this.lstWFComments[i].DelegatedUserName + ' (on behalf of ';
            this.lstWFComments[i].Login = this.lstWFComments[i].Login + ' )';
          }
        }

        //if (lstWFStatus.length > 0) {
        //    for (var i = 0; i < lstWFStatus.length; i++) {
        //        this.commentHistory += lstWFStatus[i].Login + "  " + lstWFStatus[i].StatusName + "  " + this.convertDateTime(lstWFStatus[i].CreatedDate) + "\n";
        //    }
        //}

        //this.lstWFComments.forEach(function (value, index) {
        //    this.lstWFComments[index].StatusNameWithFormat = this.FormatWFStatusName(value);
        //    });
      }
      else {
        this._router.navigate(['login']);
      }
    });

    error => console.error('Error: ' + error)
  }


  GetWFCommentsByTaskIdOnNotification(_workflow: Workflow, notificatioType): void {

    this.wfSrv.GetWFCommentsByTaskId(_workflow).subscribe(res => {
      if (res.Succeeded) {
        this.commentHistory = '';
        var lstWFCommentsOnNotification = res.lstWFComments;
        var lstWFStatus = lstWFCommentsOnNotification.filter(x => (x.SubmitType == 496 || x.SubmitType == 498) && x.WFStatusMasterID != 1 && x.WFStatusMasterID != 2);

        for (var i = 0; i < lstWFCommentsOnNotification.length; i++) {
          lstWFCommentsOnNotification[i].StatusName = (lstWFCommentsOnNotification[i].SubmitType == 496 && lstWFCommentsOnNotification[i].Comment == '' ? "rejected transaction back to " : "") + this.FormatWFStatusName(lstWFCommentsOnNotification[i].StatusName);

          if (((lstWFCommentsOnNotification[i].WFStatusMasterID != 1 && lstWFCommentsOnNotification[i].WFStatusMasterID != 2) || (lstWFCommentsOnNotification[i].SubmitType == 496))
            && lstWFCommentsOnNotification[i].Comment != 'Checklist updated'
            && lstWFCommentsOnNotification[i].Comment.indexOf("Changed the funding date") < 0 && lstWFCommentsOnNotification[i].Comment.indexOf("Changed the funding amount") < 0
          ) {
            this.commentHistory += "<i>" + lstWFCommentsOnNotification[i].Login + "  " + lstWFCommentsOnNotification[i].StatusName + "  " + this.convertDateTimeIn12Hours(lstWFCommentsOnNotification[i].CreatedDate) + "</i>" + "\n";
            if (lstWFCommentsOnNotification[i].Comment != '' && lstWFCommentsOnNotification[i].Comment != 'Checklist updated') {
              this.commentHistory += lstWFCommentsOnNotification[i].Comment + "\n";
            }
          }
          //(this.lstWFComments[i].Comment != '' && this.lstWFComments[i].Comment != 'Checklist updated') ? this.lstWFComments[i].Comment + "\n" : '';

        }
        if (this._workflow.TaskTypeID == 502) {
          this.showWFNotificationDialog(notificatioType);
        }
        else if (this._workflow.TaskTypeID == 719) {

          if (this._wfAdditionalData.IsREODeal || notificatioType == this._Final || notificatioType == this._RevisedFinal) {
            this.showWFNotificationDialogForReserveWorkflow(notificatioType);
          }
          else {
            this._isRefresh = true;
            this._isWFFetching = false;
            localStorage.setItem('divSucessWorkflow', 'true');
            localStorage.setItem('divSucessMsgWorkflow', 'Draw approval status updated successfully');
            this.CloseWFNotificationDialog();
          }
        }

      }
    });
  }

  SendWFNotificationWithTimeZone(timezone): void {
    this.isShowSendButton = false;
    this._workflow.TimeZone = timezone;
    //this._workflow.WFAdditionalList = null;
    if (this.commentHistory != '') {

      this.wfSrv.GetWFCommentsByTaskId(this._workflow).subscribe(res => {
        if (res.Succeeded) {
          this.commentHistory = '';
          this._workflow.TimeZone = '';
          this.lstWFComments = res.lstWFComments;
          var lstWFStatus = this.lstWFComments.filter(x => (x.SubmitType == 496 || x.SubmitType == 498) && x.WFStatusMasterID != 1 && x.WFStatusMasterID != 2);

          for (var i = 0; i < this.lstWFComments.length; i++) {
            this.lstWFComments[i].StatusName = (this.lstWFComments[i].SubmitType == 496 && this.lstWFComments[i].Comment == '' ? "rejected transaction back to " : "") + this.FormatWFStatusName(this.lstWFComments[i].StatusName);

            if (((this.lstWFComments[i].WFStatusMasterID != 1 && this.lstWFComments[i].WFStatusMasterID != 2) || (this.lstWFComments[i].SubmitType == 496))
              && this.lstWFComments[i].Comment != 'Checklist updated'
              && this.lstWFComments[i].Comment.indexOf("Changed the funding date") < 0 && this.lstWFComments[i].Comment.indexOf("Changed the funding amount") < 0
            ) {
              if (!(this.lstWFComments[i].DelegatedUserName == null || this.lstWFComments[i].DelegatedUserName == "" || this.lstWFComments[i].DelegatedUserName == undefined)) {
                this.lstWFComments[i].Login = this.lstWFComments[i].DelegatedUserName + " (on behalf of " + this.lstWFComments[i].Login + " )";
              }
              this.commentHistory += "<i>" + this.lstWFComments[i].Login + "  " + this.lstWFComments[i].StatusName + "  " + this.convertDateTimeIn12Hours(this.lstWFComments[i].CreatedDate) + " " + this.lstWFComments[i].Abbreviation + "</i>" + "\n";
              if (this.lstWFComments[i].Comment != '' && this.lstWFComments[i].Comment != 'Checklist updated') {
                this.commentHistory += this.lstWFComments[i].Comment + "\n";
              }
            }
            //(this.lstWFComments[i].Comment != '' && this.lstWFComments[i].Comment != 'Checklist updated') ? this.lstWFComments[i].Comment + "\n" : '';

          }
          if (this.commentHistory != '') {

            this._activityLog = "<b>Activity log are below:</b><br/>" + this.commentHistory;
            if (this._workflow.TaskTypeID == 719 && (this.notificatio_type == this._Final || this.notificatio_type == this._RevisedFinal))
              this._activityLog = "<b>Activity log:</b><br/>" + this.commentHistory;
          }
          this.SendWFNotification('Sent')
        }
        else {
          this._router.navigate(['login']);
        }
      });

      error => console.error('Error: ' + error)
    }
    else {
      this.SendWFNotification('Sent')
    }
  }


  CustomDialogteSave(): void {
    var winW = window.innerWidth;
    var winH = window.innerHeight;
    var dialogbox = document.getElementById('Genericdialogbox');
    document.getElementById('savedialogmessage').innerHTML = this.savedialogmsg;

    dialogbox.style.display = "block";
    $.getScript("/js/jsDrag.js");

  }

  ClosePopUpDialog() {
    var modal = document.getElementById('Genericdialogbox');
    modal.style.display = "none";
  }
  Savedialogbox(): void {

    this.ClosePopUpDialog();
  }


  HideButton(): void {
    //this._isShowbtnRejected = false;
    this._isShowbtnApproval = false;

    if (this._workflow.wfFlag == 'Complete') {
      this._isShowbtnSaveDraft = false;
    }
    else {
      this._isShowbtnSaveDraft = true;

    }
  }

  DiscardChanges(): void {
    var notenewcopied;
    if (window.location.href.indexOf("dealdetail/a") > -1) {
      notenewcopied = ['dealdetail', this._wfAdditionalData.CREDealID]
    }
    else {
      notenewcopied = ['dealdetail/a', this._wfAdditionalData.CREDealID]
    }

    localStorage.setItem('ClickedTabId', 'aFunding');
    this._router.navigate(notenewcopied);

  }


  downloadboxdocument(): void {
    var boxlink = this._wfAdditionalData.BoxDocumentLink;
    if (!boxlink.match(/^[a-zA-Z]+:\/\//)) {
      this._wfAdditionalData.BoxDocumentLink = 'http://' + boxlink;
    }
    window.open(this._wfAdditionalData.BoxDocumentLink, '_blank');


    //if (this._wfAdditionalData.BoxDocumentLink != null && this._wfAdditionalData.BoxDocumentLink != '') {
    //    this._isWFFetching = true;

    //    var filename = this._wfAdditionalData.BoxDocumentLink.split('\\').pop().split('/').pop();

    //    this.fileUploadService.downloadFileFromURL(this._wfAdditionalData.BoxDocumentLink)
    //        .subscribe(fileData => {
    //            let b: any = new Blob([fileData]);
    //            //var url = window.URL.createObjectURL(b);
    //            //window.open(url);

    //            let dwldLink = document.createElement("a");
    //            let url = URL.createObjectURL(b);
    //            let isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
    //            if (isSafariBrowser) {  //if Safari open in new window to save file with random filename.
    //                dwldLink.setAttribute("target", "_blank");
    //            }
    //            dwldLink.setAttribute("href", url);
    //            dwldLink.setAttribute("download", filename);
    //            dwldLink.style.visibility = "hidden";
    //            document.body.appendChild(dwldLink);
    //            dwldLink.click();
    //            document.body.removeChild(dwldLink);
    //            this._isWFFetching = false;
    //        },
    //        error => {
    //            this._isWFFetching = false;
    //            alert('Something went wrong');
    //        }
    //        );


    //}
    //else
    //{

    //    this._ShowmessagedivWar = true;
    //    this._ShowmessagedivMsgWar = 'Sorry, you do not have any document to download';
    //    setTimeout(function () {
    //        this._ShowmessagedivWar = false;
    //        this._ShowmessagedivMsgWar = "";
    //    }.bind(this), 4000);
    //}
  }

  deleteRow() {
    this.cvwfCheckListData.removeAt(this.deleteRowIndex);
    this.CloseDeletePopUp();
  }
  showDeleteDialog(rowIndex: number) {

    this.deleteRowIndex = rowIndex;
    var modalDelete = document.getElementById('myModalDelete');
    modalDelete.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }

  CloseDeletePopUp() {
    var modal = document.getElementById('myModalDelete');
    modal.style.display = "none";
  }

  showWFNotificationDialog(notificatioType): void {
    this.notificatio_type = notificatioType;
    this._isShowChecklist = false;
    var msg = "";
    if (this._wfAdditionalData.Comment == undefined || this._wfAdditionalData.Comment == '') {

      msg = "<p>Draw Number is mandatory for draw approval process.";
      this.savedialogmsg = msg;
      this.CustomDialogteSave();
      return;
    }


    this._bodyText = "";
    this._footerText = "";
    var clientName = "";
    var dealclientName = "";
    var emailto = "";
    var IsMultiinvestor = false;
    var ClientFundingDetail = '';
    var ClientFundingDetailText = '';

    this._activityLog = '';
    this.environmentName = this.dataService._environmentNamae != '' ? "(" + this.dataService._environmentNamae.replace("-", "").trim() + ") " : "";
    var drawnumber = (this._wfAdditionalData.Comment != '' && this._wfAdditionalData.Comment != null) ? ' - ' + this._wfAdditionalData.Comment : '';
    var drawnumberWithoutDash = (this._wfAdditionalData.Comment != '' && this._wfAdditionalData.Comment != null) ? ' ' + this._wfAdditionalData.Comment : '';
    var fundingdateMMDDYYYYPrelim = (this._wfAdditionalData.Date != undefined && this._wfAdditionalData.Date != null) ? ' - Est. Funding Date: ' + this.convertDateTOMMDDYYYY(this._wfAdditionalData.Date) : '';
    var fundingdateMMDDYYYYFianl = (this._wfAdditionalData.Date != undefined && this._wfAdditionalData.Date != null) ? ' - Funding Date: ' + this.convertDateTOMMDDYYYY(this._wfAdditionalData.Date) : '';

    //if (notificatioType != this._Servicer) {
    //    if (this._workflow.WFClientList != null && this._workflow.WFClientList != undefined) {
    //        if (this._workflow.WFClientList[0].EmailID != '' && this._workflow.WFClientList[0].EmailID!=null)
    //        {
    //            emailto = this._workflow.WFClientList[0].EmailIDs
    //        }
    //        if (this._workflow.WFClientList[0].ClientName != '') {
    //            IsMultiinvestor  = this._workflow.WFClientList.length>1
    //            clientName = this._workflow.WFClientList[0].ClientsName + " ";
    //        }

    //    }
    //}

    //


    //vishal
    var Fundingamountpernote = '';
    var TotalFundAmountWithExclude;
    TotalFundAmountWithExclude = this._wflstNoteDealFunding[0].TotalFundAmountWithExclude;

    for (var index = 0; index < this._wflstNoteDealFunding.length; index++) {
      if (this._wflstNoteDealFunding[index].IsExcludeThirdParty == 0) {
        if (this._wflstNoteDealFunding[index].Value != 0 || this._wflstNoteDealFunding[index].TaxVendorLoanNumber != '') {
          Fundingamountpernote = Fundingamountpernote + '\n' + this._wflstNoteDealFunding[index].Name + '\n' +
            "Amount: $" + parseFloat(this._wflstNoteDealFunding[index].Value).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '\n' +
            "WFLoanNo: " + this._wflstNoteDealFunding[index].TaxVendorLoanNumber + '\n';
        }
      }
    }
    //===============

    // add checklist to popup

    var table = '<table id="noteinfo" border="1" style="border-collapse:collapse;font-size:12px;"><tr style="font-weight:bold"><td style="padding-left:5px!important;padding-right:5px!important;">Checklist</td><td style="padding-left:5px!important;padding-right:5px!important;">Status</td><td style="padding-left:5px!important;padding-right:5px!important;">Comment</td></tr>'
    var tr = "";
    for (var i = 0; i < this._workflow.WFCheckList.length; i++) {

      if (!(Number(this._workflow.WFCheckList[i].CheckListStatusText).toString() == "NaN" || Number(this._workflow.WFCheckList[i].CheckListStatusText) == 0)) {
        this._workflow.WFCheckList[i].CheckListStatus = Number(this._workflow.WFCheckList[i].CheckListStatusText);
      }

      var statustext = this.lstCheckListStatusType.filter(x => x.LookupID === this._workflow.WFCheckList[i].CheckListStatus)[0].Name;
      tr = tr + '<tr><td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + this._workflow.WFCheckList[i].CheckListName + '</td><td style="padding-left:5px!important;padding-right:5px!important;">' + statustext + '</td><td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + (this._workflow.WFCheckList[i].Comment == null ? '' : this._workflow.WFCheckList[i].Comment) + '</td></tr>'
    }

    table = table + tr + '</table>';
    this.checklistInTable = table
    //


    var prelimEmails = null;
    var finalEmails = null;
    if (this._workflow.WFNotificationMasterEmail != null && this._workflow.WFNotificationMasterEmail != undefined) {

      prelimEmails = this._workflow.WFNotificationMasterEmail.filter(x => x.LookupID == 604)
      finalEmails = this._workflow.WFNotificationMasterEmail.filter(x => x.LookupID == 605)

    }

    //

    if (notificatioType == this._Preliminary) {

      if (prelimEmails != null && prelimEmails.length > 0) {
        if (prelimEmails[0].EmailID != '' && prelimEmails[0].EmailID != null) {
          emailto = prelimEmails[0].EmailIDs
        }
        if (prelimEmails[0].ClientName != '') {
          IsMultiinvestor = prelimEmails[0].ClientFunding.split('|').length > 1
          clientName = prelimEmails[0].ClientsName + " ";
        }

        if (prelimEmails[0].DealClients != '') {
          dealclientName = prelimEmails[0].DealClients + " ";
        }

      }


      if (IsMultiinvestor) {
        var client = ''
        var detail = prelimEmails[0].ClientFunding.split('|');
        if (detail.length > 0) {
          for (var i = 0; i < detail.length; i++) {
            ClientFundingDetail = ClientFundingDetail + detail[i].split(',')[0] + ": $" + parseFloat(detail[i].split(',')[1]).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + "\n"
            client = client + detail[i].split(',')[0] + '/';
          }
          ClientFundingDetailText = "\n\nAmount broken out by " + client.slice(0, -1) + " are as follows:\n" + ClientFundingDetail
        }
      }

      this._wfNotificationDetail.WFNotificationMasterID = 1
      this._wfNotificationDetail.Subject = "Preliminary " + dealclientName + "Capital Call Notice - " + this._wfAdditionalData.DealName + drawnumber + fundingdateMMDDYYYYPrelim;
      this._bodyText = "ACORE is reviewing" + drawnumberWithoutDash + " in the amount of " + "$" + parseFloat(TotalFundAmountWithExclude).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '. ' +
        "\n\nWe anticipate requesting funding on or around " + this.convertDateToBindable(this._wfAdditionalData.Date) + ", " +
        "with Asset Management's " + "approval due on " + this.convertDateToBindable(this._wfAdditionalData.DeadLineDate) + "." +
        ClientFundingDetailText;
      //"\n\nDetails by note are below:\n";
      //"\nDeal Name - " + this._wfAdditionalData.DealName +
      //"\nFunding Date - " + this.convertDateToBindable(this._wfAdditionalData.Date);
      //"\n\nFunding amount per note:" + '\n' + this.noteswithAmount;
      //if (clientName.trim() == this.Delphi_Financial || clientName.trim() == this.Delphi_Fixed) {
      //    this._bodyText = "ACORE is reviewing" + drawnumberWithoutDash + " in the amount of " + "$" + parseFloat(TotalFundAmountWithExclude).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '. ' +
      //        "\n\nWe anticipate requesting funding on or around " + this.convertDateToBindable(this._wfAdditionalData.Date) + "." +
      //        ClientFundingDetailText;
      //        //"\n\nDetails by note are below:\n";
      //        //"\nDeal Name - " + this._wfAdditionalData.DealName +
      //        //"\nFunding Date - " + this.convertDateToBindable(this._wfAdditionalData.Date);
      //        //"\n\nFunding amount per note:" + '\n' + this.noteswithAmount;
      //}



      this._wfNotificationDetail.WFBody = this._bodyText;
      this._notificationTittle = "Preliminary Notification";
    }
    else if (notificatioType == this._RevisedPreliminary) {
      if (prelimEmails != null && prelimEmails.length > 0) {
        if (prelimEmails[0].EmailID != '' && prelimEmails[0].EmailID != null) {
          emailto = prelimEmails[0].EmailIDs
        }
        if (prelimEmails[0].ClientName != '') {
          IsMultiinvestor = prelimEmails[0].ClientFunding.split('|').length > 1
          clientName = prelimEmails[0].ClientsName + " ";
        }
        if (prelimEmails[0].DealClients != '') {
          dealclientName = prelimEmails[0].DealClients + " ";
        }


      }
      if (IsMultiinvestor) {
        var client = ''
        var detail = prelimEmails[0].ClientFunding.split('|');
        if (detail.length > 0) {
          for (var i = 0; i < detail.length; i++) {
            ClientFundingDetail = ClientFundingDetail + detail[i].split(',')[0] + ": $" + parseFloat(detail[i].split(',')[1]).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + "\n"
            client = client + detail[i].split(',')[0] + '/';
          }
          ClientFundingDetailText = "\n\nAmount broken out by " + client.slice(0, -1) + " are as follows:\n" + ClientFundingDetail
        }
      }

      this._wfNotificationDetail.WFNotificationMasterID = 1
      this._wfNotificationDetail.Subject = "Revised - Preliminary " + dealclientName + "Capital Call Notice - " + this._wfAdditionalData.DealName + drawnumber + fundingdateMMDDYYYYPrelim;
      this._bodyText = "ACORE is reviewing" + drawnumberWithoutDash + " in the amount of " + "$" + parseFloat(TotalFundAmountWithExclude).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '. ' +
        "\n\nWe anticipate requesting funding on or around " + this.convertDateToBindable(this._wfAdditionalData.Date) + ", " +
        "with Asset Management's " + "approval due on " + this.convertDateToBindable(this._wfAdditionalData.DeadLineDate) + "." +
        ClientFundingDetailText;
      //"\n\nDetails by note are below:\n";
      //"\nDeal Name - " + this._wfAdditionalData.DealName +
      //"\nFunding Date - " + this.convertDateToBindable(this._wfAdditionalData.Date);
      //"\n\nFunding amount per note:" + '\n' + this.noteswithAmount;
      //if (clientName.trim() == this.Delphi_Financial || clientName.trim() == this.Delphi_Fixed) {
      //    this._bodyText = "ACORE is reviewing" + drawnumberWithoutDash + " in the amount of " + "$" + parseFloat(TotalFundAmountWithExclude).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '. ' +
      //        "\n\nWe anticipate requesting funding on or around " + this.convertDateToBindable(this._wfAdditionalData.Date) + "." +
      //        ClientFundingDetailText;
      //    //"\n\nDetails by note are below:\n";
      //    //"\nDeal Name - " + this._wfAdditionalData.DealName +
      //    //"\nFunding Date - " + this.convertDateToBindable(this._wfAdditionalData.Date);
      //    //"\n\nFunding amount per note:" + '\n' + this.noteswithAmount;
      //}

      this._wfNotificationDetail.WFBody = this._bodyText;
      this._notificationTittle = "Revised - Preliminary Notification";
    }

    else if (notificatioType == this._Final) {

      this._isShowChecklist = true;
      if (finalEmails != null && finalEmails.length > 0) {
        if (finalEmails[0].EmailID != '' && finalEmails[0].EmailID != null) {
          emailto = finalEmails[0].EmailIDs
        }
        if (finalEmails[0].ClientName != '') {
          IsMultiinvestor = finalEmails[0].ClientFunding.split('|').length > 1
          clientName = finalEmails[0].ClientsName + " ";
        }

        if (finalEmails[0].DealClients != '') {
          dealclientName = finalEmails[0].DealClients + " ";
        }
      }

      if (IsMultiinvestor) {
        var client = ''
        var detail = finalEmails[0].ClientFunding.split('|');
        if (detail.length > 0) {
          for (var i = 0; i < detail.length; i++) {
            ClientFundingDetail = ClientFundingDetail + detail[i].split(',')[0] + ": $" + parseFloat(detail[i].split(',')[1]).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + "\n"
            client = client + detail[i].split(',')[0] + '/';
          }
          ClientFundingDetailText = "\n\nAmount broken out by " + client.slice(0, -1) + " are as follows:\n" + ClientFundingDetail
        }
      }

      this._wfNotificationDetail.WFNotificationMasterID = 2
      this._wfNotificationDetail.Subject = "Final " + dealclientName + "Capital Call Notice - " + this._wfAdditionalData.DealName + drawnumber + fundingdateMMDDYYYYFianl;



      this._bodyText = "Please see approvals below for" + drawnumberWithoutDash +
        " in the amount of " + "$" + parseFloat(TotalFundAmountWithExclude).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") +
        " to be funded on " + this.convertDateToBindable(this._wfAdditionalData.Date) + "." +
        ClientFundingDetailText;
      //"\n\nDetails by note are below:\n";
      //"\nDeal Name - " + this._wfAdditionalData.DealName +
      //"\nFunding Date - " + this.convertDateToBindable(this._wfAdditionalData.Date);
      //"\n\nFunding amount per note:" + '\n' + this.noteswithAmount +
      //"\nFunding amount per note:" + '\n' + Fundingamountpernote +  
      //this._activityLog = "Activity log are below:\n" + this.commentHistory;


      //if (clientName.trim() == this.Delphi_Financial || clientName.trim() == this.Delphi_Fixed || IsMultiinvestor == true) {
      //    this._bodyText = "Please see " + this._wfAdditionalData.CreatedByName + "'s final approval below for" + drawnumberWithoutDash +" in the amount of " + "$" + parseFloat(this._wfAdditionalData.Amount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") +
      //        " to be funded on " + this.convertDateToBindable(this._wfAdditionalData.Date) + ".";
      //}
      //else if (clientName.trim() == this.AFLAC || clientName.trim() == this.TRE_ACR) {
      //    this._bodyText = "Accounting Team,\n\nThe AM team has approved the funding of the current loan request" + drawnumberWithoutDash +" in the amount of " + "$" + parseFloat(this._wfAdditionalData.Amount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + "."+
      //        " \n\nPlease consider this the formal two (2) Day Notice for funding on " + this.convertDateToBindable(this._wfAdditionalData.Date) + ".";
      //}
      //else if (clientName.trim() == this.ACORE_Credit_IV) {
      //    this._bodyText = "Accounting Team,\n\nThe AM team has approved the funding of the current loan request" + drawnumberWithoutDash +" in the amount of " + "$" + parseFloat(this._wfAdditionalData.Amount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + "."+
      //    " \n\nPlease consider this the formal two (2) Day Notice for funding on " + this.convertDateToBindable(this._wfAdditionalData.Date) + ".";
      //}
      this._wfNotificationDetail.WFBody = this._bodyText;
      this._notificationTittle = "Final Notification";
      if (this.commentHistory != '') {
        this._activityLog = "<b>Activity log are below:</b><br/>" + this.commentHistory
      }
    }
    else if (notificatioType == this._RevisedFinal) {
      this._isShowChecklist = true;
      if (finalEmails != null && finalEmails.length > 0) {
        if (finalEmails[0].EmailID != '' && finalEmails[0].EmailID != null) {
          emailto = finalEmails[0].EmailIDs
        }
        if (finalEmails[0].ClientName != '') {
          IsMultiinvestor = finalEmails[0].ClientFunding.split('|').length > 1
          clientName = finalEmails[0].ClientsName + " ";
        }
        if (finalEmails[0].DealClients != '') {
          dealclientName = finalEmails[0].DealClients + " ";
        }
      }

      if (IsMultiinvestor) {
        var client = ''
        var detail = finalEmails[0].ClientFunding.split('|');
        if (detail.length > 0) {
          for (var i = 0; i < detail.length; i++) {
            ClientFundingDetail = ClientFundingDetail + detail[i].split(',')[0] + ": $" + parseFloat(detail[i].split(',')[1]).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + "\n"
            client = client + detail[i].split(',')[0] + '/';
          }
          ClientFundingDetailText = "\n\nAmount broken out by " + client.slice(0, -1) + " are as follows:\n" + ClientFundingDetail
        }
      }
      this._wfNotificationDetail.WFNotificationMasterID = 2
      this._wfNotificationDetail.Subject = "Revised - Final " + dealclientName + "Capital Call Notice - " + this._wfAdditionalData.DealName + drawnumber + fundingdateMMDDYYYYFianl;

      //vishal
      var FundingamountpernoteRe = '';
      var TotalFundAmountWithExcludeRe;
      TotalFundAmountWithExcludeRe = this._wflstNoteDealFunding[0].TotalFundAmountWithExclude;

      for (var index = 0; index < this._wflstNoteDealFunding.length; index++) {
        if (this._wflstNoteDealFunding[index].IsExcludeThirdParty == 0) {
          if (this._wflstNoteDealFunding[index].Value != 0 || this._wflstNoteDealFunding[index].TaxVendorLoanNumber != '') {
            FundingamountpernoteRe = FundingamountpernoteRe + '\n' + this._wflstNoteDealFunding[index].Name + '\n' +
              "Amount: $" + parseFloat(this._wflstNoteDealFunding[index].Value).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '\n' +
              "WFLoanNo: " + this._wflstNoteDealFunding[index].TaxVendorLoanNumber + '\n';
          }
        }
      }
      //===============

      this._bodyText = "Please see approvals below for" + drawnumberWithoutDash +
        " in the amount of " + "$" + parseFloat(TotalFundAmountWithExcludeRe).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") +
        " to be funded on " + this.convertDateToBindable(this._wfAdditionalData.Date) + "." +
        ClientFundingDetailText;
      // "\n\nDetails by note are below:\n" +
      //"\nDeal Name - " + this._wfAdditionalData.DealName +
      //"\nFunding Date - " + this.convertDateToBindable(this._wfAdditionalData.Date) +
      //"\n\nFunding amount per note:" + '\n' + this.noteswithAmount +
      //"\nFunding amount per note:" + '\n' + FundingamountpernoteRe +
      //this._activityLog = "Activity log are below:\n" + this.commentHistory;

      //if (clientName.trim() == this.Delphi_Financial || clientName.trim() == this.Delphi_Fixed || IsMultiinvestor == true) {
      //    this._bodyText = "Please see " + this._wfAdditionalData.CreatedByName + "'s final approval below for Lender’s cash advance" + drawnumberWithoutDash +" in the amount of " + "$" + parseFloat(this._wfAdditionalData.Amount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") +
      //        " to be funded on " + this.convertDateToBindable(this._wfAdditionalData.Date) + ".";
      //}
      //else if (clientName.trim() == this.AFLAC || clientName.trim() == this.TRE_ACR) {
      //    this._bodyText = "Accounting Team,\n\nThe AM team has approved the funding of the current loan request" + drawnumberWithoutDash +" in the amount of " + "$" + parseFloat(this._wfAdditionalData.Amount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + "." +
      //        " \n\nPlease consider this the formal two (2) Day Notice for funding on " + this.convertDateToBindable(this._wfAdditionalData.Date) + ".";
      //}
      //else if (clientName.trim() == this.ACORE_Credit_IV) {
      //    this._bodyText = "Accounting Team,\n\nThe AM team has approved the funding of the current loan request" + drawnumberWithoutDash +" in the amount of " + "$" + parseFloat(this._wfAdditionalData.Amount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + "." +
      //        " \n\nPlease consider this the formal two (2) Day Notice for funding on " + this.convertDateToBindable(this._wfAdditionalData.Date) + ".";
      //}
      this._wfNotificationDetail.WFBody = this._bodyText;
      this._notificationTittle = "Revised - Final Notification";
      if (this.commentHistory != '') {
        this._activityLog = "<b>Activity log are below:</b><br/>" + this.commentHistory
      }
    }
    //else if (notificatioType == this._Servicer) {
    //    this._wfNotificationDetail.WFNotificationMasterID = 3
    //    this._wfNotificationDetail.Subject = "Notification of Funding - " + this._wfAdditionalData.DealName + drawnumber;
    //    this._bodyText = "ACORE will be making this loan advance on  " + this.convertDateToBindable(this._wfAdditionalData.Date) + ". " +
    //        "Please update Wells’ records accordingly.\n\nDetails by note are below:\n" +
    //        "\nDeal Name - " + this._wfAdditionalData.DealName +
    //        "\nFunding Date - " + this.convertDateToBindable(this._wfAdditionalData.Date)+
    //    "\nFunding amount per note:" + '\n'+this.noteswithAmount;
    //    this._wfNotificationDetail.WFBody = this._bodyText;
    //    this._notificationTittle = "Servicer Notification";
    //}
    //else if (notificatioType == this._RevisedServicer) {
    //    this._wfNotificationDetail.WFNotificationMasterID = 3
    //    this._wfNotificationDetail.Subject = "Revised - Notification of Funding - " + this._wfAdditionalData.DealName + drawnumber;
    //    this._bodyText = "ACORE will be making this loan advance on  " + this.convertDateToBindable(this._wfAdditionalData.Date) + ". " +
    //        "Please update Wells’ records accordingly.\n\nDetails by note are below:\n" +
    //        "\nDeal Name - " + this._wfAdditionalData.DealName +
    //        "\nFunding Date - " + this.convertDateToBindable(this._wfAdditionalData.Date) +
    //        "\nFunding amount per note:" + '\n'+ this.noteswithAmount
    //    this._wfNotificationDetail.WFBody = this._bodyText;
    //    this._notificationTittle = "Servicer Notification";
    //}

    this._footerText = "Thank you,\n" + this._user.FirstName + ' ' + this._user.LastName + '\n' + this._user.Email + ((this._user.ContactNo1 != '' && this._user.ContactNo1 != null) ? ' | ' + this._user.ContactNo1 : '');
    this._wfNotificationDetail.WFFooter = this._footerText;
    this._wfNotificationDetail.EnvironmentName = this.environmentName;
    this._wfNotificationDetail.Subject = this.environmentName + this._wfNotificationDetail.Subject

    //change in subject for force funding type--need to uncomment for integration
    if (this._workflow.PurposeTypeId == 520) {
      this._wfNotificationDetail.Subject = "Force Funding – " + this._wfNotificationDetail.Subject;
    }
    var Emailcc = "";
    if (notificatioType == this._Final || notificatioType == this._RevisedFinal) {
      Emailcc = this._wfAdditionalData.AMEmails.replace('|', '');
    }
    else {
      Emailcc = this._wfAdditionalData.AMEmails.split('|')[0];

    }

    //removed amfunding team from the notification as requested by client
    // 13 dec 2019 email-Add AMfunding team in internal emails and remove them from notification.
    //if (notificatioType == this._Preliminary || notificatioType == this._RevisedPreliminary) {

    //    if (Emailcc != '') {
    //        Emailcc = Emailcc + ',' + 'amfunding@mailinator.com';
    //    }
    //    else {
    //        Emailcc = 'amfunding@mailinator.com';
    //    }
    //}

    this._wfNotificationDetail.EmailCCIds = Emailcc;
    //this._wfNotificationDetail.ReplyTo = recipients[0].ReplyTo;
    this._wfNotificationDetail.ReplyTo = this._user.Email;

    if (notificatioType != this._Servicer && emailto != '') {

      this._wfNotificationDetail.EmailToIds = emailto
    }

    var notificationConfig = this.notificationConfig.filter(x => x.WFNotificationMasterID == this._wfNotificationDetail.WFNotificationMasterID);

    this._CanChangeReplyTo = notificationConfig[0].CanChangeReplyTo;
    this._CanChangeRecipientList = notificationConfig[0].CanChangeRecipientList;
    this._CanChangeHeader = notificationConfig[0].CanChangeHeader;
    this._CanChangeBody = notificationConfig[0].CanChangeBody;
    this._CanChangeFooter = notificationConfig[0].CanChangeFooter;
    this._CanChangeSchedule = notificationConfig[0].CanChangeSchedule;
    this._wfNotificationDetail.TemplateID = notificationConfig[0].TemplateID;
    this._wfNotificationDetail.TemplateFileName = IsMultiinvestor ? "MultiInvestorNotification.html" : notificationConfig[0].TemplateFileName;

    this.ConfirmDialogBoxFor = 'Notification';
    var modalWFNotification = document.getElementById('myModalWFNotification');
    modalWFNotification.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }

  showWFNotificationDialogForNegativeAmt(notificatioType): void {
    this.notificatio_type = notificatioType;
    this._isShowChecklist = false;
    var msg = "";
    if (this._wfAdditionalData.Comment == undefined || this._wfAdditionalData.Comment == '') {

      msg = "<p>Draw Number is mandatory for draw approval process.";
      this.savedialogmsg = msg;
      this.CustomDialogteSave();
      return;
    }


    this._bodyText = "";
    this._footerText = "";
    var clientName = "";
    var dealclientName = "";
    var emailto = "";
    var IsMultiinvestor = false;
    var ClientFundingDetail = '';
    var ClientFundingDetailText = '';

    this._activityLog = '';
    this.environmentName = this.dataService._environmentNamae != '' ? "(" + this.dataService._environmentNamae.replace("-", "").trim() + ") " : "";

    var prelimEmails = null;
    var finalEmails = null;
    var finalEmailsWithoutApproval = null;
    if (this._workflow.WFNotificationMasterEmail != null && this._workflow.WFNotificationMasterEmail != undefined) {

      prelimEmails = this._workflow.WFNotificationMasterEmail.filter(x => x.LookupID == 604)
      finalEmails = this._workflow.WFNotificationMasterEmail.filter(x => x.LookupID == 605)
      finalEmailsWithoutApproval = this._workflow.WFNotificationMasterEmail.filter(x => x.LookupID == 704)
    }

    //

    //purpose type Full Payoff
    if (this._workflow.PurposeTypeId == 630) {

      this._isShowChecklist = true;
      if (finalEmailsWithoutApproval != null && finalEmailsWithoutApproval.length > 0) {
        if (finalEmailsWithoutApproval[0].EmailID != '' && finalEmailsWithoutApproval[0].EmailID != null) {
          emailto = finalEmailsWithoutApproval[0].EmailIDs
        }
        if (finalEmailsWithoutApproval[0].ClientName != '') {
          IsMultiinvestor = finalEmailsWithoutApproval[0].ClientFunding.split('|').length > 1
          clientName = finalEmailsWithoutApproval[0].ClientsName + " ";
        }

        if (finalEmailsWithoutApproval[0].DealClients != '') {
          dealclientName = finalEmailsWithoutApproval[0].DealClients + " ";
        }
      }

      this._wfNotificationDetail.WFNotificationMasterID = 6
      if (this.notificatio_type == this._FinalWithoutApproval) {
        this._wfNotificationDetail.Subject = "Final Loan Payoff Notice: " + this._wfAdditionalData.DealName;

        this._bodyText = "The " + this._wfAdditionalData.DealName + " loan paid off today, " + this.convertDateToBindable(new Date()) + ", with a principal balance of " + "$" + Math.abs(parseFloat(this._wfAdditionalData.Amount)).toFixed(2).toString() + ". Funds will be remitted by " + this._wfAdditionalData.ServicerName + " within 2 business days.";
        this._wfNotificationDetail.WFBody = this._bodyText;
        this._notificationTittle = "Full Payoff Notification";
      }
      else if (this.notificatio_type == this._RevisedFinalWithoutApproval) {
        this._wfNotificationDetail.Subject = "Revised-Final Loan Payoff Notice: " + this._wfAdditionalData.DealName;
        this._bodyText = "The " + this._wfAdditionalData.DealName + " loan paid off today, " + this.convertDateToBindable(new Date()) + ", with a principal balance of " + "$" + Math.abs(parseFloat(this._wfAdditionalData.Amount)).toFixed(2).toString() + ". Funds will be remitted by " + this._wfAdditionalData.ServicerName + " within 2 business days.";
        this._wfNotificationDetail.WFBody = this._bodyText;
        this._notificationTittle = "Revised-Full Payoff Notification";
      }
    }

    this._footerText = "Thank you,\n" + this._user.FirstName + ' ' + this._user.LastName + '\n' + this._user.Email + ((this._user.ContactNo1 != '' && this._user.ContactNo1 != null) ? ' | ' + this._user.ContactNo1 : '');
    this._wfNotificationDetail.WFFooter = this._footerText;
    this._wfNotificationDetail.EnvironmentName = this.environmentName;
    this._wfNotificationDetail.Subject = this.environmentName + this._wfNotificationDetail.Subject

    var recipients = this._wfTemplateRecipient.filter(x => x.WFNotificationMasterID == this._wfNotificationDetail.WFNotificationMasterID);
    this._wfAdditionalData.AMEmails = this._wfAdditionalData.AMEmails.replace('|', '');

    var Emailcc = '';
    if (recipients != null && recipients != undefined && recipients != '') {
      if (recipients[0].CC != '')
        Emailcc = recipients[0].CC + ', ' + this._wfAdditionalData.AMEmails;
      else
        Emailcc = this._wfAdditionalData.AMEmails;
      if (recipients[0].TO != '')
        this._wfNotificationDetail.EmailToIds = recipients[0].TO;
    }
    else

      Emailcc = this._wfAdditionalData.AMEmails;


    this._wfNotificationDetail.EmailCCIds = Emailcc;
    //this._wfNotificationDetail.ReplyTo = recipients[0].ReplyTo;
    this._wfNotificationDetail.ReplyTo = this._user.Email;

    if (emailto != '') {

      this._wfNotificationDetail.EmailToIds = emailto
    }

    var notificationConfig = this.notificationConfig.filter(x => x.WFNotificationMasterID == this._wfNotificationDetail.WFNotificationMasterID);

    this._CanChangeReplyTo = notificationConfig[0].CanChangeReplyTo;
    this._CanChangeRecipientList = notificationConfig[0].CanChangeRecipientList;
    this._CanChangeHeader = notificationConfig[0].CanChangeHeader;
    this._CanChangeBody = notificationConfig[0].CanChangeBody;
    this._CanChangeFooter = notificationConfig[0].CanChangeFooter;
    this._CanChangeSchedule = notificationConfig[0].CanChangeSchedule;
    this._wfNotificationDetail.TemplateID = notificationConfig[0].TemplateID;
    this._wfNotificationDetail.TemplateFileName = notificationConfig[0].TemplateFileName;

    this.ConfirmDialogBoxFor = 'Notification';
    var modalWFNotification = document.getElementById('myModalWFNotificationForNegativeAmt');
    modalWFNotification.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }
  CloseWFNotificationDialog() {
    this._wfNotificationDetail.WFBody = "";
    var modal = document.getElementById('myModalWFNotification');
    modal.style.display = "none";

    if (this._isRefresh) {

      var notenewcopied;
      if (window.location.href.indexOf("workflowdetail/a/") > -1) {
        notenewcopied = ['workflowdetail', this._wfAdditionalData.TaskID, this._workflow.TaskTypeID]
      }
      else {
        notenewcopied = ['workflowdetail/a', this._wfAdditionalData.TaskID, this._workflow.TaskTypeID]
      }
      this._router.navigate(notenewcopied);
    }

    //localStorage.setItem('ClickedTabId', 'aFunding');
    //localStorage.setItem('divSucessDeal', 'true');
    //localStorage.setItem('divSucessMsgDeal', 'Draw approval status updated successfully');


  }
  CloseWFNotificationDialogForNegativeAmt() {
    this._wfNotificationDetail.WFBody = "";
    var modal = document.getElementById('myModalWFNotificationForNegativeAmt');
    modal.style.display = "none";

    if (this._isRefresh) {

      var notenewcopied;
      if (window.location.href.indexOf("workflowdetail/a/") > -1) {
        notenewcopied = ['workflowdetail', this._wfAdditionalData.TaskID, this._workflow.TaskTypeID]
      }
      else {
        notenewcopied = ['workflowdetail/a', this._wfAdditionalData.TaskID, this._workflow.TaskTypeID]
      }
      this._router.navigate(notenewcopied);
    }

    //localStorage.setItem('ClickedTabId', 'aFunding');
    //localStorage.setItem('divSucessDeal', 'true');
    //localStorage.setItem('divSucessMsgDeal', 'Draw approval status updated successfully');


  }

  CloseWFNotificationDialogForNegativeAmtWithConfirm() {
    if (this._IsAlreadyCancelNegativeAmt) {

      this._wfNotificationDetail.WFBody = "";
      var modal = document.getElementById('myModalWFNotificationForNegativeAmt');
      modal.style.display = "none";

      if (this._isRefresh) {

        var notenewcopied;
        if (window.location.href.indexOf("workflowdetail/a/") > -1) {
          notenewcopied = ['workflowdetail', this._wfAdditionalData.TaskID, this._workflow.TaskTypeID]
        }
        else {
          notenewcopied = ['workflowdetail/a', this._wfAdditionalData.TaskID, this._workflow.TaskTypeID]
        }
        this._router.navigate(notenewcopied);
      }
    }
    else {
      this._IsAlreadyCancelNegativeAmt = true;

      $('#btnCancelNotificationForNegativeAmt').removeClass("custombuttonGrey").addClass("custombuttonRed");
      $('#btnCancelNotificationForNegativeAmt').html("Are you sure?");
    }
    //localStorage.setItem('ClickedTabId', 'aFunding');
    //localStorage.setItem('divSucessDeal', 'true');
    //localStorage.setItem('divSucessMsgDeal', 'Draw approval status updated successfully');


  }



  CloseWFNotificationDialogWithConfirm() {
    if (this._IsAlreadyCancel) {

      this._wfNotificationDetail.WFBody = "";
      var modal = document.getElementById('myModalWFNotification');
      modal.style.display = "none";

      if (this._isRefresh) {

        var notenewcopied;
        if (window.location.href.indexOf("workflowdetail/a/") > -1) {
          notenewcopied = ['workflowdetail', this._wfAdditionalData.TaskID, this._workflow.TaskTypeID]
        }
        else {
          notenewcopied = ['workflowdetail/a', this._wfAdditionalData.TaskID, this._workflow.TaskTypeID]
        }
        this._router.navigate(notenewcopied);
      }
    }
    else {
      this._IsAlreadyCancel = true;

      $('#btnCancelNotification').removeClass("custombuttonGrey").addClass("custombuttonRed");
      $('#btnCancelNotification').html("Are you sure?");
    }
    //localStorage.setItem('ClickedTabId', 'aFunding');
    //localStorage.setItem('divSucessDeal', 'true');
    //localStorage.setItem('divSucessMsgDeal', 'Draw approval status updated successfully');


  }

  Notify(notificatioType): void {
    this.notificatio_type = notificatioType;
    this._IsAlreadyCancel = false;
    $('#btnCancelNotification').html("Cancel");
    $('#btnCancelNotification').removeClass("custombuttonRed").addClass("custombuttonGrey");
    this._isRefresh = false;
    this._isNotificationMsg = true;
    if (this._workflow.TaskTypeID == 502) {
      if (this._workflow.WorkFlowType == "WF_UNDERREVIEW" && this._workflow.PurposeTypeId == 630) {
        this.showWFNotificationDialogForNegativeAmt(notificatioType);
      }
      else {
        this.showWFNotificationDialog(notificatioType);
      }
    }
    else if (this._workflow.TaskTypeID == 719) {
      this.showWFNotificationDialogForReserveWorkflow(notificatioType)
    }

  }

  getWFNotificationConfigByNotificationType(WFNotificationMasterID: number): void {

    this._CanChangeReplyTo = false;
    this._CanChangeRecipientList = false;
    this._CanChangeHeader = false;
    this._CanChangeBody = false;
    this._CanChangeFooter = false;
    this._CanChangeSchedule = false;

    this._notificationmaster.WFNotificationMasterID = WFNotificationMasterID;
    this._isWFFetching = true;
    this.wfSrv.getWFNotificationConfigByNotificationType(this._notificationmaster).subscribe(res => {
      if (res.Succeeded) {
        this.notificationConfig = res.wfNotificationConfigDataContract;
        //this._CanChangeReplyTo = this.notificationConfig.CanChangeReplyTo;
        //this._CanChangeRecipientList = this.notificationConfig.CanChangeRecipientList;
        //this._CanChangeHeader = this.notificationConfig.CanChangeHeader;
        //this._CanChangeBody = this.notificationConfig.CanChangeBody;
        //this._CanChangeFooter = this.notificationConfig.CanChangeFooter;
        //this._CanChangeSchedule = this.notificationConfig.CanChangeSchedule;
      }
      else {
        this._router.navigate(['login']);
      }
    });

    error => console.error('Error: ' + error)
  }

  SendWFNotification(btnType): void {


    if (this.ValidateTOCCEmail()) {

      this.isShowSendButton = false;
      this._isWFFetching = true;
      if (btnType == 'None') {

        this._wfNotificationDetail.ActionType = 575;
      }
      else if (btnType == 'Scheduled') {
        this._wfNotificationDetail.ActionType = 576;
      }
      else if (btnType == 'Sent') {

        this._wfNotificationDetail.ActionType = 577;
      }
      this._wfNotificationDetail.TaskID = this._workflow.TaskID;
      this._wfNotificationDetail.ActionType = 577
      this._wfNotificationDetail.MessageHTML = 'All,\n\n';
      this._wfNotificationDetail.DealName = this._wfAdditionalData.DealName;


      if (this._wfNotificationDetail.WFHeader != undefined) {
        //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody.replace(/\n/g, "<br>") + '<br/><br/>';
        this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFHeader + '\n\n';
      }

      if (this._workflow.SpecialInstructions != undefined && this._workflow.SpecialInstructions != '') {
        //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody.replace(/\n/g, "<br>") + '<br/><br/>';
        this._wfNotificationDetail.MessageHTML += '<span style="color: black;font-weight:bold;font-size:16px;background-color:yellow">' + this._workflow.SpecialInstructions + '</span>' + '\n\n';
      }


      if (this._wfNotificationDetail.WFBody != undefined) {
        //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
        if (this._workflow.TaskTypeID == 719)
          this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody;
        else
          this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '\n\n';

      }
      if (this.delphinoteswithAmount != undefined && this.delphinoteswithAmount != '') {
        //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
        this._wfNotificationDetail.MessageHTML += this.delphinoteswithAmount + '\n\n';
      }

      if (this.noteswithAmount != undefined && this.noteswithAmount != '') {
        //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
        this._wfNotificationDetail.MessageHTML += "Details by note are below:\n" + this.noteswithAmount + '\n\n';
      }

      if (this.ReserveScheduleBreakDown != undefined && this.ReserveScheduleBreakDown != '') {
        //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
        this._wfNotificationDetail.MessageHTML += this.ReserveScheduleBreakDown + '\n\n';
      }
      if (this._activityLog != undefined) {
        //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
        this._wfNotificationDetail.MessageHTML += this._activityLog + '\n\n';
      }

      if (this._workflow.AdditionalComments != undefined && this._workflow.AdditionalComments != '') {
        //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody.replace(/\n/g, "<br>") + '<br/><br/>';
        this._wfNotificationDetail.MessageHTML += this._workflow.AdditionalComments + '\n\n';
      }

      //send checklist detail on final notification
      if (this._isShowChecklist) {
        if (this.checklistInTable != undefined && this.checklistInTable != '') {
          this._wfNotificationDetail.MessageHTML += "Draw Approval checklist:\n\n" + this.checklistInTable + '\n\n';
        }
      }
      if (this.noteswithAllocationAmount != undefined && this.noteswithAllocationAmount != '') {
        //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
        this._wfNotificationDetail.MessageHTML += "\n" + this.noteswithAllocationAmount + '\n\n';
      }

      if (this.noteswithAllocationPercentage != undefined && this.noteswithAllocationPercentage != '') {
        //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
        this._wfNotificationDetail.MessageHTML += "\n" + this.noteswithAllocationPercentage + '\n\n';
      }




      if (this._wfNotificationDetail.WFFooter != undefined) {
        //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFFooter.replace(/\n/g, "<br>");
        this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFFooter;
      }
      this._wfNotificationDetail.EmailToIds = this._wfNotificationDetail.EmailToIds.replace(/,\s*$/, "");

      if (this._wfNotificationDetail.EmailCCIds != null &&
        this._wfNotificationDetail.EmailCCIds != undefined &&
        this._wfNotificationDetail.EmailCCIds != '') {
        this._wfNotificationDetail.EmailCCIds = this._wfNotificationDetail.EmailCCIds.replace(/,\s*$/, "");
      }
      else {
        this._wfNotificationDetail.EmailCCIds = "";
      }
      this._wfNotificationDetail.UserName = this._user.FirstName + " " + this._user.LastName;
      this._wfNotificationDetail.AdditionalComments = this._workflow.AdditionalComments;
      this._wfNotificationDetail.SpecialInstructions = this._workflow.SpecialInstructions;
      this._wfNotificationDetail.WFCheckList = this._workflow.WFCheckList;
      this._wfNotificationDetail.TaskTypeID = this._workflow.TaskTypeID;
      this.wfSrv.InsertUpdateWFNotification(this._wfNotificationDetail).subscribe(res => {
        if (res.Succeeded) {
          //if (this._wfNotificationDetail.WFNotificationMasterID == 2 && this._autoSendInvoice == 571) {
          if (this._wfNotificationDetail.WFNotificationMasterID == 2 && this._autoSendInvoice == 571
            && (this.notificatio_type == this._Final || (this.notificatio_type == this._RevisedFinal && this._wfAdditionalData.Applied == false))
            && this._isShowDrawFee == true) {

            this.dealSrv.GetDealFundingByDealFundingID(this._dealfundingDrawFee).subscribe(res => {
              if (res.Succeeded) {
                this._dealfundingDrawFee = res._dealFunding;
                if (this._dealfundingDrawFee.Applied == true) {

                  try {
                    this._isWFFetching = true;
                    this._drawFeeInvoice.TaskID = this._workflow.TaskID;
                    this._drawFeeInvoice.UpdatedDate = this._dealfundingDrawFee.UpdatedDate;
                    this._drawFeeInvoice.FundingDate = this._dealfundingDrawFee.Date;
                    this._drawFeeInvoice.CreDealID = this._wfAdditionalData.CREDealID
                    this._drawFeeInvoice.DrawNo = this._wfAdditionalData.Comment;
                    this._drawFeeInvoice.FundingDate = this._wfAdditionalData.Date;
                    this._drawFeeInvoice.DealName = this._wfAdditionalData.DealName;
                    //this._drawFeeInvoice.TemplateName = "m61 invoice template";
                    //this._drawFeeInvoice.InvoiceCode = "Draw Fees";
                    this._drawFeeInvoice.InvoiceTypeID = 558;
                    this._drawFeeInvoice.StorageType = this._invoiceStorageType;
                    this._drawFeeInvoice.FundingAmount = parseFloat(this._wfAdditionalData.Amount);

                    this.wfSrv.CreateInvoice(this._drawFeeInvoice).subscribe(res => {
                      if (res.Succeeded) {

                        this._isRefresh = true;
                        this._isWFFetching = false;
                        localStorage.setItem('divSucessWorkflow', 'true');
                        localStorage.setItem('divSucessMsgWorkflow', 'Draw approval status updated successfully');
                        if (this._isNotificationMsg) {
                          localStorage.setItem('divSucessMsgWorkflow', 'Notification sent successfully');
                        }
                        this.isShowSendButton = true;
                        this.CloseWFNotificationDialog();
                      }
                      else {
                        this._router.navigate(['login']);
                      }
                    });
                  } catch (err) {
                    this._isWFFetching = false;
                  }
                }
                else {
                  this.isShowSendButton = true;
                  this._isRefresh = true;
                  this._isWFFetching = false;
                  localStorage.setItem('divSucessWorkflow', 'true');
                  localStorage.setItem('divSucessMsgWorkflow', 'Draw approval status updated successfully');
                  if (this._isNotificationMsg) {
                    localStorage.setItem('divSucessMsgWorkflow', 'Notification sent successfully');
                  }
                  this.CloseWFNotificationDialog();
                }
              }
            });

          }
          else {
            this.isShowSendButton = true;
            this._isRefresh = true;
            this._isWFFetching = false;
            localStorage.setItem('divSucessWorkflow', 'true');
            localStorage.setItem('divSucessMsgWorkflow', 'Draw approval status updated successfully');
            if (this._isNotificationMsg) {
              localStorage.setItem('divSucessMsgWorkflow', 'Notification sent successfully');
            }
            this.CloseWFNotificationDialog();
          }
        }
        else {
          this._router.navigate(['login']);
        }
      });

      error => console.error('Error: ' + error)
    }
    else {
      this._IsShowMsg = true;
      this.isShowSendButton = true;
      this._MsgText = "Invalid email address. Please correct."
      setTimeout(function () {
        this._IsShowMsg = false;
      }.bind(this), 4000);
    }
  }

  SendWFNotificationForNegativeAmt(): void {


    if (this.ValidateTOCCEmail()) {


      this._isWFFetching = true;
      this._wfNotificationDetail.TaskID = this._workflow.TaskID;
      this._wfNotificationDetail.ActionType = 577
      this._wfNotificationDetail.MessageHTML = 'All,\n\n';
      this._wfNotificationDetail.DealName = this._wfAdditionalData.DealName;


      if (this._wfNotificationDetail.WFHeader != undefined) {
        //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody.replace(/\n/g, "<br>") + '<br/><br/>';
        this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFHeader + '\n\n';
      }

      if (this._workflow.SpecialInstructions != undefined && this._workflow.SpecialInstructions != '') {
        //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody.replace(/\n/g, "<br>") + '<br/><br/>';
        this._wfNotificationDetail.MessageHTML += '<span style="color: black;font-weight:bold;font-size:16px;background-color:yellow">' + this._workflow.SpecialInstructions + '</span>' + '\n\n';
      }


      if (this._wfNotificationDetail.WFBody != undefined) {
        //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '<br/><br/>';
        this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody + '\n\n';
      }


      if (this._workflow.AdditionalComments != undefined && this._workflow.AdditionalComments != '') {
        //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFBody.replace(/\n/g, "<br>") + '<br/><br/>';
        this._wfNotificationDetail.MessageHTML += this._workflow.AdditionalComments + '\n\n';
      }
      if (this.tblPayoff != "") {

        this._wfNotificationDetail.MessageHTML += "\n" + this.tblPayoff + '\n\n';
      }


      if (this._wfNotificationDetail.WFFooter != undefined) {
        //this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFFooter.replace(/\n/g, "<br>");
        this._wfNotificationDetail.MessageHTML += this._wfNotificationDetail.WFFooter;
      }
      this._wfNotificationDetail.EmailToIds = this._wfNotificationDetail.EmailToIds.replace(/,\s*$/, "");
      if (this._wfNotificationDetail.EmailCCIds != null &&
        this._wfNotificationDetail.EmailCCIds != undefined &&
        this._wfNotificationDetail.EmailCCIds != '') {
        this._wfNotificationDetail.EmailCCIds = this._wfNotificationDetail.EmailCCIds.replace(/,\s*$/, "");
      }
      else {
        this._wfNotificationDetail.EmailCCIds = "";
      }
      this._wfNotificationDetail.UserName = this._user.FirstName + " " + this._user.LastName;
      this._wfNotificationDetail.AdditionalComments = this._workflow.AdditionalComments;
      this._wfNotificationDetail.SpecialInstructions = this._workflow.SpecialInstructions;
      this._wfNotificationDetail.WFCheckList = this._workflow.WFCheckList;
      this._wfNotificationDetail.TaskTypeID = this._workflow.TaskTypeID;
      //this.wfSrv.SendWFNotificationForNegativeAmt(this._wfNotificationDetail).subscribe(res => {
      this.wfSrv.InsertUpdateWFNotification(this._wfNotificationDetail).subscribe(res => {
        if (res.Succeeded) {

          this._isRefresh = true;
          this._isWFFetching = false;
          localStorage.setItem('divSucessWorkflow', 'true');
          localStorage.setItem('divSucessMsgWorkflow', 'Notification sent successfully');
          this.CloseWFNotificationDialogForNegativeAmt();
        }
        else {
          this._router.navigate(['login']);
        }
      });

      error => console.error('Error: ' + error)
    }
    else {
      this._IsShowMsg = true;
      this._MsgText = "Invalid email address. Please correct."
      setTimeout(function () {
        this._IsShowMsg = false;
      }.bind(this), 4000);
    }
  }

  getTemplateRecipientEmailIDs(WFNotificationMasterID: number): void {

    this._notificationmaster.WFNotificationMasterID = WFNotificationMasterID;
    this._isWFFetching = true;
    this.wfSrv.getTemplateRecipientEmailIDs(this._notificationmaster).subscribe(res => {
      if (res.Succeeded) {
        this._wfTemplateRecipient = res.wfTemplateRecipient
      }
      else {
        this._router.navigate(['login']);
      }
    });

    error => console.error('Error: ' + error)
  }

  GetDealFundingByDealID(): void {
    var tbl = '';
    var tdKey = ''
    var tdValue = ''
    var strnotes = '';
    var strnotesdelphi = '';
    var total = 0.00;
    var totaldelphi = 0.00;
    var trHeader = '<table id="noteinfo" border="1" style="border-collapse:collapse;font-size:12px;"><tr style="font-weight:bold"><td style="padding-left:5px!important;padding-right:5px!important;">Loan#</td><td style="padding-left:5px!important;padding-right:5px!important;">Note ID</td><td style="padding-left:5px!important;padding-right:5px!important;">Financing Source</td><td style="padding-left:5px!important;padding-right:5px!important;">Note Name</td><td style="padding-left:5px!important;padding-right:5px!important;">Current Request</td> </tr>'
    var trHeaderdelphi = '<table id="noteinfo" border="1" style="border-collapse:collapse;font-size:12px;">' +
      '<tr style="font-weight:bold"><td colspan="5" style="text-align:center;">Delphi Financial Summary</td></tr>' +
      '<tr style="font-weight:bold"><td style="padding-left:5px!important;padding-right:5px!important;">Loan#</td><td style="padding-left:5px!important;padding-right:5px!important;">Note ID</td><td style="padding-left:5px!important;padding-right:5px!important;">Financing Source</td><td style="padding-left:5px!important;padding-right:5px!important;">Note Name</td><td style="padding-left:5px!important;padding-right:5px!important;">Current Request</td> </tr>'
    var trHeaderForInternalEmail = '<table id="noteinfo" border="1" style="border-collapse:collapse;font-size:12px;margin:7px 0px 0px 28px"><tr style="font-weight:bold"><td style="padding-left:5px!important;padding-right:5px!important;">Loan#</td><td style="padding-left:5px!important;padding-right:5px!important;">Note ID</td><td style="padding-left:5px!important;padding-right:5px!important;">Financing Source</td><td style="padding-left:5px!important;padding-right:5px!important;">Note Name</td><td style="padding-left:5px!important;padding-right:5px!important;">Current Request</td> </tr>'

    try {
      this.dealSrv.GetWFNoteFunding(this._dealfunding).subscribe(res => {
        if (res.Succeeded) {
          this._wflstNoteDealFunding = res.lstNoteDealFunding;


          res.lstNoteDealFunding.forEach(function (value, index) {

            if (res.lstNoteDealFunding[index].Value != 0 || res.lstNoteDealFunding[index].TaxVendorLoanNumber != '') {


              strnotes = strnotes +
                '<tr><td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + res.lstNoteDealFunding[index].TaxVendorLoanNumber + '</td><td style="padding-left:5px!important;padding-right:5px!important;">' + res.lstNoteDealFunding[index].CRENoteID + '</td><td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + res.lstNoteDealFunding[index].FinancingSourceName + '</td><td style="text-align:left;text-align:left;padding-left:5px!important;padding-right:5px!important;">' + res.lstNoteDealFunding[index].Name + '</td><td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.lstNoteDealFunding[index].Value).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td> </tr>'

              total += parseFloat(res.lstNoteDealFunding[index].Value)
              if (res.lstNoteDealFunding[index].FinancingSourceName.toLocaleLowerCase().includes('delphi')) {

                strnotesdelphi = strnotesdelphi +
                  '<tr><td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + res.lstNoteDealFunding[index].TaxVendorLoanNumber + '</td><td style="padding-left:5px!important;padding-right:5px!important;">' + res.lstNoteDealFunding[index].CRENoteID + '</td><td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + res.lstNoteDealFunding[index].FinancingSourceName + '</td><td style="text-align:left;text-align:left;padding-left:5px!important;padding-right:5px!important;">' + res.lstNoteDealFunding[index].Name + '</td><td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.lstNoteDealFunding[index].Value).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td> </tr>'
                totaldelphi += parseFloat(res.lstNoteDealFunding[index].Value)
              }

            }


          });

          if (strnotes != "") {
            strnotes = strnotes + '<tr><td></td><td></td><td></td><td style="text-align:left;font-weight:bold;text-align:right;padding-left:5px!important;padding-right:5px!important;">Total Loan Funds</td><td style="text-align:right;font-weight:bold;text-align:right;padding-left:5px!important;padding-right:5px!important;">' + "$" + total.toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td></tr >';

            trHeader = trHeader + strnotes + '</table>';
            trHeaderForInternalEmail = trHeaderForInternalEmail + strnotes + '</table>';
          }
          if (strnotesdelphi != "") {
            strnotesdelphi = strnotesdelphi + '<tr><td></td><td></td><td></td><td style="text-align:left;font-weight:bold;text-align:right;padding-left:5px!important;padding-right:5px!important;">Total Loan Funds</td><td style="text-align:right;font-weight:bold;text-align:right;padding-left:5px!important;padding-right:5px!important;">' + "$" + totaldelphi.toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td></tr >';
            trHeaderdelphi = trHeaderdelphi + strnotesdelphi + '</table>';
            //delphi only note--need to uncomment for integration
            this.delphinoteswithAmount = trHeaderdelphi;
          }

          //var tbl = '<table>' + strnotes + '</table>'
          //this.trustedNoteDetail = this.sanitizer.bypassSecurityTrustResourceUrl(trHeader);

          this.noteswithAmount = trHeader
          this._workflow.NoteswithAmount = '<br/><br/><b style="margin:7px 0px 0px 28px"> Details by note are below: </b><br/>' + trHeaderForInternalEmail;
          this.trustedNoteDetail = this.sanitizer.bypassSecurityTrustHtml(this.noteswithAmount);
        }
        else {
          this._router.navigate(['login']);
        }
      });
    } catch (err) {
    }
  }

  GetReserveScheduleBreakDown(): void {
    var tbl = '';
    var tdKey = ''
    var tdValue = ''
    var strnotes = '';
    var strnotesdelphi = '';
    var totalCurrBal = 0.00;
    var totalReqAmt = 0.00;
    var totalNewBal = 0.00;
    var trHeaderPrelim = '<table id="noteinfo" border="1" style="border-collapse:collapse;font-size:12px;"><tr style="font-weight:bold"><td style="padding-left:5px!important;padding-right:5px!important;">Reserve Name</td><td style="padding-left:5px!important;padding-right:5px!important;">Current Balance</td><td style="padding-left:5px!important;padding-right:5px!important;">Pending Request</td><td style="padding-left:5px!important;padding-right:5px!important;">Expected New Balance</td> </tr>';
    //var trHeaderFinal = '<table id="noteinfo" border="1" style="border-collapse:collapse;font-size:12px;"><tr style="font-weight:bold"><td style="padding-left:5px!important;padding-right:5px!important;">Reserve Name</td><td style="padding-left:5px!important;padding-right:5px!important;">Previous Balance</td><td style="padding-left:5px!important;padding-right:5px!important;">Current Request</td><td style="padding-left:5px!important;padding-right:5px!important;">New Balance</td> </tr>';
    var trHeaderFinal = '<table id="noteinfo" border="1" style="border-collapse:collapse;font-size:12px;"><tr style="font-weight:bold"><td style="padding-left:5px!important;padding-right:5px!important;">Reserve Name</td><td style="padding-left:5px!important;padding-right:5px!important;">Current Balance</td><td style="padding-left:5px!important;padding-right:5px!important;">Pending Request</td><td style="padding-left:5px!important;padding-right:5px!important;">Expected New Balance</td> </tr>';

    var trHeaderInternal = '<table id="noteinfo" border="1" style="border-collapse:collapse;font-size:12px;margin:7px 0px 0px 28px"><tr style="font-weight:bold"><td style="padding-left:5px!important;padding-right:5px!important;">Reserve Name</td><td style="padding-left:5px!important;padding-right:5px!important;">Current Balance</td><td style="padding-left:5px!important;padding-right:5px!important;">Pending Request</td><td style="padding-left:5px!important;padding-right:5px!important;">Expected New Balance</td> </tr>';

    try {
      this.wfSrv.GetReserveScheduleBreakDown(this._workflow).subscribe(res => {
        if (res.Succeeded) {
          this._lstReserveScheduleBreakDown = res.ListReserveScheduleBreakDown;


          res.ListReserveScheduleBreakDown.forEach(function (value, index) {

            strnotes = strnotes +
              '<tr><td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + res.ListReserveScheduleBreakDown[index].ReserveAccountName + '</td><td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.ListReserveScheduleBreakDown[index].CurrentBalance).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td><td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.ListReserveScheduleBreakDown[index].RequestAmount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td><td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.ListReserveScheduleBreakDown[index].NewBalance).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td> </tr>'

            totalCurrBal += parseFloat(res.ListReserveScheduleBreakDown[index].CurrentBalance);
            totalReqAmt += parseFloat(res.ListReserveScheduleBreakDown[index].RequestAmount);
            totalNewBal += parseFloat(res.ListReserveScheduleBreakDown[index].NewBalance);



          });

          if (strnotes != "") {
            strnotes = strnotes + '<tr><td style="text-align:left;font-weight:bold;padding-left:5px!important;padding-right:5px!important;">Total</td><td style="text-align:right;font-weight:bold;padding-left:5px!important;padding-right:5px!important;">' + "$" + totalCurrBal.toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td><td style="text-align:right;font-weight:bold;padding-left:5px!important;padding-right:5px!important;">' + "$" + totalReqAmt.toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td><td style="text-align:right;font-weight:bold;padding-left:5px!important;padding-right:5px!important;">' + "$" + totalNewBal.toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td></tr >';
            trHeaderPrelim = trHeaderPrelim + strnotes + '</table>';
            trHeaderFinal = trHeaderFinal + strnotes + '</table>';
            trHeaderInternal = trHeaderInternal + strnotes + '</table>';
          }


          //var tbl = '<table>' + strnotes + '</table>'
          //this.trustedNoteDetail = this.sanitizer.bypassSecurityTrustResourceUrl(trHeader);

          this.ReserveScheduleBreakDownPrelim = "Anticipated breakdown by reserve is shown below:\n" + trHeaderPrelim;
          this.ReserveScheduleBreakDownFinal = "Breakdown by reserve is shown below:\n" + trHeaderFinal;
          this._workflow.ReserveScheduleBreakDown = '<br/><br/><b style="margin:7px 0px 0px 28px"> Anticipated breakdown by reserve is shown below: </b><br/>' + trHeaderInternal;
        }
        else {
          this._router.navigate(['login']);
        }
      });
    } catch (err) {
    }
  }

  GetNoteAllocationPercentage(): void {
    var tbl = '';
    var tdKey = ''
    var tdValue = ''
    var strnotes = '';
    var total = 0.00;
    //var tableAllocation = '<table id="noteinfo" style="border-collapse:collapse;font-size:12px;border-top: 1px solid;border-bottom: 1px solid;border-left: 1px solid;border-right: 1px solid;" width="98%">';
    var tableAllocation = '<table border="1" id="noteinfo" style="border-collapse:collapse;font-size:12px;" width="98%">';
    var trAllocation = '';
    var tdAllocation = '';

    //var tableAllocationAmount = '<table id="noteinfo"  style="border-collapse:collapse;font-size:12px;border-top: 1px solid;border-bottom: 1px solid;border-left: 1px solid;border-right: 1px solid;" width="98%">';
    var tableAllocationAmount = '<table border="1" id="noteinfo"  style="border-collapse:collapse;font-size:12px;" width="98%">';
    var trAllocationAmount = '';
    var tdAllocationAmount = '';
    var tdAllocationAmountTotal = '';
    var trAllocationAmountTotal = '';

    try {
      this.dealSrv.GetNoteAllocationPercentage(this._dealfunding).subscribe(res => {
        if (res.Succeeded) {
          this._wflstNoteAllocationPercentage = res.lstNoteAllocationPercentage;
          this._wflstNoteAllocationAmount = res.lstNoteAllocationAmount;

          if (this._wflstNoteAllocationPercentage.length > 0) {

            var colLength = Object.getOwnPropertyNames(this._wflstNoteAllocationPercentage[0]).length
            var allocationPercentageTdWidth = 100 / (colLength)
            trAllocation = '<tr><td colspan=' + colLength + ' style=text-align:center;font-weight:bold>ALLOCATION PERCENTAGE</td></tr>';
            //trAllocation += '<tr><td colspan=' + colLength + '><hr/></td></tr>'
            trAllocation += '<tr>';
            Object.getOwnPropertyNames(this._wflstNoteAllocationPercentage[0]).forEach(
              function (val, idx, array) {
                tdAllocation += '<td width=' + allocationPercentageTdWidth + '% style=font-weight:bold;padding-left:5px!important;padding-right:5px!important;text-align:center>' + val + '</td>';
              }
            );
            trAllocation = trAllocation + tdAllocation + '</tr>';
            //trAllocation += '<tr><td colspan=' + colLength + '><hr/></td></tr>'
            for (var i = 0; i < this._wflstNoteAllocationPercentage.length; i++) {
              tdAllocation = '';
              trAllocation += '<tr>';
              var obj = this._wflstNoteAllocationPercentage[i];
              Object.getOwnPropertyNames(obj).forEach(
                function (val, idx, array) {
                  if ((typeof (obj[val]) == 'number')) {
                    tdAllocation += '<td style=text-align:right;padding-left:5px!important;padding-right:5px!important;>' + ((obj[val] == 'null' || obj[val] == null || obj[val] == 0) ? '' : (typeof (obj[val]) == 'number') ? parseFloat(obj[val]).toFixed(6).toString() + '%' : obj[val]) + '</td>';
                  }
                  else {
                    tdAllocation += '<td style=text-align:center;padding-left:5px!important;padding-right:5px!important;>' + ((obj[val] == 'null' || obj[val] == null || obj[val] == 0) ? '' : (typeof (obj[val]) == 'number') ? parseFloat(obj[val]).toFixed(6).toString() + '%' : obj[val]) + '</td>';
                  }
                }
              );
              trAllocation += tdAllocation + '</tr>';
            }
            tableAllocation += trAllocation + '</table>';
            this.noteswithAllocationPercentage = tableAllocation;
            //this.trustedNoteDetail = this.sanitizer.bypassSecurityTrustHtml(this.noteswithAllocationPercentage);
          }

          if (this._wflstNoteAllocationAmount.length > 0) {

            var lstamt = this._wflstNoteAllocationAmount;
            var colLengthAmount = Object.getOwnPropertyNames(this._wflstNoteAllocationAmount[0]).length
            var allocationAmountTdWidth = 100 / (colLengthAmount - 1)
            trAllocationAmount = '<tr><td colspan=' + (colLengthAmount - 1) + ' style=text-align:center;font-weight:bold>ALLOCATION AMOUNT</td></tr>';
            //trAllocationAmount += '<tr><td colspan=' + (colLengthAmount - 1) + '><hr/></td></tr>'
            trAllocationAmount += '<tr>';
            var totalcol = 0.00;
            Object.getOwnPropertyNames(this._wflstNoteAllocationAmount[0]).forEach(

              function (val, idx, array) {
                if (val.toLowerCase() != "total") {
                  if (val.toLowerCase() == "funding amount")//funding amount need little bit more width so we are adding 3% more
                  {
                    tdAllocationAmount += '<td width=' + (allocationAmountTdWidth + 3) + '% style=font-weight:bold;padding-left:5px!important;padding-right:5px!important;text-align:center;>' + val + '</td>';
                  }
                  else {
                    tdAllocationAmount += '<td width=' + allocationAmountTdWidth + '% style=font-weight:bold;padding-left:5px!important;padding-right:5px!important;text-align:center;>' + val + '</td>';
                  }
                  if (val != 'Note Name') {

                    for (var total_col = 0; total_col < lstamt.length; total_col++) {
                      totalcol += lstamt[total_col][val];
                    }

                    tdAllocationAmountTotal += '<td style=font-weight:bold;text-align:right;padding-left:5px!important;padding-right:5px!important;>' + '$' + totalcol.toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>';

                  }
                  else {
                    tdAllocationAmountTotal += '<td style=font-weight:bold;text-align:center;padding-left:5px!important;padding-right:5px!important;>Total</td>';
                  }
                  totalcol = 0.00;
                }
              }
            );
            trAllocationAmount = trAllocationAmount + tdAllocationAmount + '</tr>';
            //trAllocationAmount += '<tr><td colspan=' + (colLengthAmount - 1) + '><hr/></td></tr>'
            for (var i = 0; i < this._wflstNoteAllocationAmount.length; i++) {
              tdAllocationAmount = '';
              trAllocationAmount += '<tr>';
              var obj = this._wflstNoteAllocationAmount[i];
              Object.getOwnPropertyNames(obj).forEach(
                function (val, idx, array) {
                  if (val.toLowerCase() != "total") {
                    if ((typeof (obj[val]) == 'number')) {
                      tdAllocationAmount += '<td style=text-align:right;padding-left:5px!important;padding-right:5px!important;>' + ((obj[val] == 'null' || obj[val] == null || obj[val] == 0) ? '' : (typeof (obj[val]) == 'number') ? '$' + parseFloat(obj[val]).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") : obj[val]) + '</td>';
                    }
                    else {
                      tdAllocationAmount += '<td style=text-align:center;padding-left:5px!important;padding-right:5px!important;>' + ((obj[val] == 'null' || obj[val] == null || obj[val] == 0) ? '' : (typeof (obj[val]) == 'number') ? '$' + parseFloat(obj[val]).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") : obj[val]) + '</td>';
                    }
                  }
                }
              );
              trAllocationAmount += tdAllocationAmount + '</tr>';
            }
            //trAllocationAmountTotal = '<tr><td colspan=' + (colLengthAmount - 1) +'><hr/></td></tr>'
            trAllocationAmountTotal += '<tr>' + tdAllocationAmountTotal + '</tr>'
            tableAllocationAmount += trAllocationAmount + trAllocationAmountTotal + '</table>';
            this.noteswithAllocationAmount = tableAllocationAmount;




            //this.trustedNoteDetail = this.sanitizer.bypassSecurityTrustHtml(this.noteswithAllocationPercentage);
          }
        }
        else {
          this._router.navigate(['login']);
        }
      });
    } catch (err) {
    }
  }

  GetWFPayOffNoteFunding(): void {
    var tbl = '';
    var tdKey = ''
    var tdValue = ''
    var strnotes = '';
    var strnotesdelphi = '';
    var total = 0.00;
    var totaldelphi = 0.00;
    var tblNoteAdditionalInfo = '';
    var tableALL = "";
    var tblInvestorSummary = '<table id = "investorSummary" border = "1" style = "border-collapse:collapse;font-size:12px;" > ' +
      '<tr style="font-weight:bold"><td colspan="6" style="text-align:center;">Investor  Summary</td></tr>' +
      '<tr style="font-weight:bold">' +
      '<td style="padding-left:5px!important;padding-right:5px!important;" > Investor </td>' +
      '<td style="padding-left:5px!important;padding-right:5px!important;">Initial Funding</td>' +
      '<td style="padding-left:5px!important;padding-right:5px!important;">Current Balance</td>' +
      '<td style="padding-left:5px!important;padding-right:5px!important;">Current Commitment</td>' +
      '<td style="padding-left:5px!important;padding-right:5px!important;">Remaining Unfunded</td>' +
      '<td style="padding-left:5px!important;padding-right:5px!important;">Spread</td>'
    '</tr>';
    var tbldelphi = '<table id = "tbldelphi" border = "1" style = "border-collapse:collapse;font-size:12px;" > ' +
      '<tr style="font-weight:bold"><td colspan="9" style="text-align:center;">Delphi Financial Summary</td></tr>' +
      '<tr style="font-weight:bold">' +
      '<td style="padding-left:5px!important;padding-right:5px!important;" > Loan # </td>' +
      '<td style="padding-left:5px!important;padding-right:5px!important;" > Note ID </td>' +
      '<td style="padding-left:5px!important;padding-right:5px!important;" > Financing Source </td>' +
      '<td style="padding-left:5px!important;padding-right:5px!important;" > Note Name </td>' +
      '<td style="padding-left:5px!important;padding-right:5px!important;">Initial Funding</td>' +
      '<td style="padding-left:5px!important;padding-right:5px!important;">Current Balance</td>' +
      '<td style="padding-left:5px!important;padding-right:5px!important;">Current Commitment</td>' +
      '<td style="padding-left:5px!important;padding-right:5px!important;">Remaining Unfunded</td>' +
      '<td style="padding-left:5px!important;padding-right:5px!important;">Spread</td>'
    '</tr>';

    var tblFSource = '<table id = "tblFSource" border = "1" style = "border-collapse:collapse;font-size:12px;" > ' +
      '<tr style="font-weight:bold">' +
      '<td style="padding-left:5px!important;padding-right:5px!important;" > Loan # </td>' +
      '<td style="padding-left:5px!important;padding-right:5px!important;" > Note ID </td>' +
      '<td style="padding-left:5px!important;padding-right:5px!important;" > Financing Source </td>' +
      '<td style="padding-left:5px!important;padding-right:5px!important;" > Note Name </td>' +
      '<td style="padding-left:5px!important;padding-right:5px!important;">Initial Funding</td>' +
      '<td style="padding-left:5px!important;padding-right:5px!important;">Current Balance</td>' +
      '<td style="padding-left:5px!important;padding-right:5px!important;">Current Commitment</td>' +
      '<td style="padding-left:5px!important;padding-right:5px!important;">Remaining Unfunded</td>' +
      '<td style="padding-left:5px!important;padding-right:5px!important;">Spread</td>'
    '</tr>';
    var trInvestor = "";
    var TotaltrInvestor = "";
    var trDelphi = "";
    var TotaltrDelphi = "";
    var trFSources = "";
    var TotaltrFSources = "";
    try {
      this.dealSrv.GetWFPayOffNoteFunding(this._dealfunding).subscribe(res => {
        if (res.Succeeded) {

          if (res.dtNoteAdditionalInfo != null &&
            res.dtNoteAdditionalInfo != undefined
          ) {
            tblNoteAdditionalInfo = '<table id="noteinfo" border="1" style="border-collapse:collapse;font-size:12px;">' +
              '<tr style = "font-weight:bold" > <td style="padding-left:5px!important;padding-right:5px!important;"> Current Balance</td><td style="padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtNoteAdditionalInfo[0].CurrentBalance).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td></tr>' +
              '<tr style = "font-weight:bold" > <td style="padding-left:5px!important;padding-right:5px!important;"> Loan Closing Date</td><td style="padding-left:5px!important;padding-right:5px!important;">' + this.convertDateTOMMDDYYYY(res.dtNoteAdditionalInfo[0].ClosingDate) + '</td></tr>' +
              '<tr style = "font-weight:bold" > <td style="padding-left:5px!important;padding-right:5px!important;"> Initial Maturity</td><td style="padding-left:5px!important;padding-right:5px!important;">' + this.convertDateTOMMDDYYYY(res.dtNoteAdditionalInfo[0].InitialMaturityDate) + '</td></tr>' +
              '<tr style = "font-weight:bold" > <td style="padding-left:5px!important;padding-right:5px!important;"> Initial Funding</td><td style="padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtNoteAdditionalInfo[0].InitialFundingAmount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td></tr>' +
              '<tr style = "font-weight:bold" > <td style="padding-left:5px!important;padding-right:5px!important;"> Current Commitment</td><td style="padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtNoteAdditionalInfo[0].AdjustedTotalCommitment).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td></tr>' +
              '<tr style = "font-weight:bold" > <td style="padding-left:5px!important;padding-right:5px!important;"> Spread</td><td style="padding-left:5px!important;padding-right:5px!important;">' + parseFloat(res.dtNoteAdditionalInfo[0].SpreadPercentage).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td></tr>' +
              '<tr style = "font-weight:bold" > <td style="padding-left:5px!important;padding-right:5px!important;"> Prepayment Premium</td><td style="padding-left:5px!important;padding-right:5px!important;"></td></tr>' +
              '<tr style = "font-weight:bold" > <td style="padding-left:5px!important;padding-right:5px!important;"> Client</td><td style="padding-left:5px!important;padding-right:5px!important;">' + res.dtNoteAdditionalInfo[0].ParentClient + '</td></tr>' +
              '<tr style = "font-weight:bold" > <td style="padding-left:5px!important;padding-right:5px!important;"> Financing source</td><td style="padding-left:5px!important;padding-right:5px!important;">' + res.dtNoteAdditionalInfo[0].FinancingSourceName + '</td></tr>' +
              '<tr style = "font-weight:bold" > <td style="padding-left:5px!important;padding-right:5px!important;"> Third Party Financing</td><td style="padding-left:5px!important;padding-right:5px!important;">' + res.dtNoteAdditionalInfo[0].ThirpPartyFinancingSources + '</td></tr>' +
              '</table>';
          }

          //res.dtInvestors;
          //res.dtNoteFinancingSources;
          res.dtInvestors.forEach(function (value, index) {
            //    if (res.lstNoteDealFunding[index].Value != 0 || res.lstNoteDealFunding[index].TaxVendorLoanNumber != '') {
            if (res.dtInvestors[index].RowType == "Data") {
              trInvestor = trInvestor +
                '<tr>' +
                '<tr><td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + res.dtInvestors[index].ParentClient + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtInvestors[index].InitialFundingAmount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtInvestors[index].CurrentBalance).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtInvestors[index].AdjustedTotalCommitment).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtInvestors[index].RemainingUnfunded).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + res.dtInvestors[index].SpreadPercentage + '</td>' +
                '</tr>';
            }
            else if (res.dtInvestors[index].RowType == "Total") {
              TotaltrInvestor =
                '<tr>' +
                '<tr><td style="font-weight:bold;text-align:right;padding-left:5px!important;padding-right:5px!important;">Total</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtInvestors[index].InitialFundingAmount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtInvestors[index].CurrentBalance).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtInvestors[index].AdjustedTotalCommitment).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtInvestors[index].RemainingUnfunded).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + res.dtInvestors[index].SpreadPercentage + '</td>' +
                '</tr>';
            }

          });
          tblInvestorSummary += trInvestor + TotaltrInvestor + '</table>';


          res.dtDelphi.forEach(function (value, index) {
            //    if (res.lstNoteDealFunding[index].Value != 0 || res.lstNoteDealFunding[index].TaxVendorLoanNumber != '') {
            if (res.dtDelphi[index].RowType == "Data") {
              trDelphi = trDelphi +
                '<tr>' +
                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + res.dtDelphi[index].TaxVendorLoanNumber + '</td>' +
                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + res.dtDelphi[index].NoteID + '</td>' +
                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + res.dtDelphi[index].FinancingSourceName + '</td>' +
                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + res.dtDelphi[index].Name + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtDelphi[index].InitialFundingAmount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtDelphi[index].CurrentBalance).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtDelphi[index].AdjustedTotalCommitment).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtDelphi[index].RemainingUnfunded).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + res.dtDelphi[index].SpreadPercentage + '</td>' +
                '</tr>';
            }
            else if (res.dtDelphi[index].RowType == "Total") {

              TotaltrDelphi = '<tr>' +
                '<td style="font-weight:bold;text-align:right;padding-left:5px!important;padding-right:5px!important;">Total</td>' +
                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;"></td>' +
                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;"></td>' +
                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;"></td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtDelphi[index].InitialFundingAmount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtDelphi[index].CurrentBalance).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtDelphi[index].AdjustedTotalCommitment).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtDelphi[index].RemainingUnfunded).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + res.dtDelphi[index].SpreadPercentage + '</td>' +
                '</tr>';
            }

          });
          tbldelphi += trDelphi + TotaltrDelphi + '</table>';

          res.dtNoteFinancingSources.forEach(function (value, index) {
            //    if (res.lstNoteDealFunding[index].Value != 0 || res.lstNoteDealFunding[index].TaxVendorLoanNumber != '') {
            if (res.dtNoteFinancingSources[index].RowType == "Data") {
              trFSources = trFSources +
                '<tr>' +
                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + res.dtNoteFinancingSources[index].TaxVendorLoanNumber + '</td>' +
                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + res.dtNoteFinancingSources[index].NoteID + '</td>' +
                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + res.dtNoteFinancingSources[index].FinancingSourceName + '</td>' +
                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;">' + res.dtNoteFinancingSources[index].Name + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtNoteFinancingSources[index].InitialFundingAmount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtNoteFinancingSources[index].CurrentBalance).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtNoteFinancingSources[index].AdjustedTotalCommitment).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtNoteFinancingSources[index].RemainingUnfunded).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + res.dtNoteFinancingSources[index].SpreadPercentage + '</td>' +
                '</tr>';
            }
            else if (res.dtNoteFinancingSources[index].RowType == "Total") {

              TotaltrFSources = '<tr>' +
                '<td style="font-weight:bold;text-align:right;padding-left:5px!important;padding-right:5px!important;">Total</td>' +
                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;"></td>' +
                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;"></td>' +
                '<td style="text-align:right;padding-left:5px!important;padding-right:5px!important;"></td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtNoteFinancingSources[index].InitialFundingAmount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtNoteFinancingSources[index].CurrentBalance).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtNoteFinancingSources[index].AdjustedTotalCommitment).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + "$" + parseFloat(res.dtNoteFinancingSources[index].RemainingUnfunded).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>' +
                '<td style="text-align:right:left;padding-left:5px!important;padding-right:5px!important;">' + res.dtNoteFinancingSources[index].SpreadPercentage + '</td>' +
                '</tr>';
            }

          });
          tblFSource += trFSources + TotaltrFSources + '</table>';
          tableALL = "Additional information below:\n" + tblNoteAdditionalInfo;
          if (trInvestor != "")
            tableALL += "\nSummary by Client(s):\n\n" + tblInvestorSummary;
          if (trDelphi != "")
            tableALL += "\n\n" + tbldelphi;
          if (tblFSource != "")
            tableALL += "\nDetails by Financing Sources Below:\n\n" + tblFSource;

          this.tblPayoff = tableALL;
        }
        else {
          this._router.navigate(['login']);
        }
      });
    } catch (err) {
    }
  }

  ValidateEmail(email): boolean {
    const re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(String(email).toLowerCase());
  }

  ValidateTOCCEmail(): boolean {

    var isValid = true;
    //var emailregx = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/
    if (this._wfNotificationDetail.EmailToIds != null &&
      this._wfNotificationDetail.EmailToIds != undefined &&
      this._wfNotificationDetail.EmailToIds != '') {

      var toEmails = this._wfNotificationDetail.EmailToIds.replace(/;/g, ",").split(',')
      for (var i = 0; i < toEmails.length; i++) {

        if (toEmails[i].trim() != '') {
          if (!this.ValidateEmail(toEmails[i].trim())) {
            isValid = false;
            break;
          }
        }
      }
    }
    else {
      isValid = false;
    }
    if (isValid) {
      if (this._wfNotificationDetail.EmailCCIds != null &&
        this._wfNotificationDetail.EmailCCIds != undefined &&
        this._wfNotificationDetail.EmailCCIds != '') {
        var ccEmails = this._wfNotificationDetail.EmailCCIds.replace(/;/g, ",").split(',')
        for (var i = 0; i < ccEmails.length; i++) {
          if (ccEmails[i].trim() != '') {
            if (!this.ValidateEmail(ccEmails[i].trim())) {
              isValid = false;
              break;
            }

            //if (!emailregx.test(ccEmails[i].trim())) {
            //    isValid = false;
            //    break;
            //}
          }
        }
      }
    }
    return isValid;
  }
  OverWriteDefaultInstruction(): void {
    this._workflow.SpecialInstructions = this.defaultSpecialInstructions;
  }

  //DownloadInvoice() {
  //  this.DownloadDocument("DrawFee.pdf", 392, "Invoice");
  //}

  DownloadDocument(filename, storagetypeID, storageLocation) {

    //  documentStorageID = documentStorageID === undefined ? '' : documentStorageID

    //var _reportfilelog = new reportFileLog();
    //_reportfilelog.FileName = filename;
    //_reportfilelog.StorageLocation = storageLocation;
    //_reportfilelog.StorageTypeID = storagetypeID;
    //if (_reportfilelog.StorageTypeID == "459")
    //    _reportfilelog.FileName = documentStorageID;

    var ID = filename;
    //if (storagetypeID == "459")
    //    ID = documentStorageID

    this.dealSrv.downloadObjectDocumentByStorageTypeAndLocation(ID, storagetypeID, storageLocation)
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
        dwldLink.setAttribute("download", filename);
        dwldLink.style.visibility = "hidden";
        document.body.appendChild(dwldLink);
        dwldLink.click();
        document.body.removeChild(dwldLink);

      },
        error => {
          //    alert('Something went wrong');

        }
      );
  }

  GetDrawFeeInvoiceDetailByTaskID(): void {
    this.IsDrawFeeEditClick = false;
    try {
      this.wfSrv.GetDrawFeeInvoiceDetailByTaskID(this._workflow.TaskID).subscribe(res => {
        if (res.Succeeded) {
          this._drawFeeInvoice = res.DrawFeeInvoice;

          setTimeout(function () {
            this.enableDisableDrawFeeSection();
          }.bind(this), 3000);



          if (this._drawFeeInvoice == null || this._drawFeeInvoice.DrawFeeInvoiceDetailID == 0) {
            this._drawFeeInvoice.AutoSendInvoice = 571;
          }
          this._drawFeeInvoiceOrignal = JSON.parse(JSON.stringify(res.DrawFeeInvoice));
          this._autoSendInvoice = this._drawFeeInvoice.AutoSendInvoice;
          this.IsShowSaveAndStatusButton = true;
        }
        else {
          this._router.navigate(['login']);
        }
      });
    } catch (err) {
    }
  }




  DownloadInvoice() {
    if (this._drawFeeInvoice.DrawFeeStatusText == "Generate") {

      var myModelConfirmInvoice = document.getElementById('myModelConfirmInvoice');
      myModelConfirmInvoice.style.display = "block";
      $.getScript("/js/jsDrag.js");

    }
    else if (this._drawFeeInvoice.DrawFeeStatusText == "Invoiced" || this._drawFeeInvoice.DrawFeeStatusText == "Paid") {
      this.dealSrv.downloadObjectDocumentByStorageTypeAndLocation(this._drawFeeInvoice.FileName, this._invoiceStorageType, this._invoiceLocation)
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
          dwldLink.setAttribute("download", this._drawFeeInvoice.FileName);
          dwldLink.style.visibility = "hidden";
          document.body.appendChild(dwldLink);
          dwldLink.click();
          document.body.removeChild(dwldLink);

        },
          error => {
            //  alert('Something went wrong');
          }
        );
    }
  }


  GetDefaultValue(val) {
    if (isNaN(val) || val == null) {
      return 0;
    }
    return val;
  }
  formatNumberforTwoDecimalplaces(data) {
    var num = parseFloat(data.toFixed(2));
    var str = num.toString();
    var numarray = str.split('.');
    var a = new Array();
    a = numarray;
    var newamount;
    //to assign 2 digits after decimal places
    if (a[1]) {
      var l = a[1].length;
      if (l == 1) {
        data = num + "0";
      }
      else {
        data = num;
      }
    } else {
      data = num + ".00";
    }

    //to assign currency with sign
    if (Math.sign(data) == -1) {
      var _amount = -1 * data;
      newamount = "-" + this._basecurrencyname + _amount;
    }
    else {
      newamount = this._basecurrencyname + data;
    }
    var changedamount = newamount.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
    return changedamount;
  }


  CheckAndCreateCustomer(): void {
    try {
      var errorMsg = this.CheckValidationforDrawFee('');
      if (errorMsg != "") {
        this.CustomAlert(errorMsg);
      }
      else {
        this.saveDrawFeeInvoice();
      }
    } catch (err) {
      this._isWFFetching = false;
      console.log(err);
    }
  }


  InsertUpdateDrawFeeInvoice(): void {
    try {
      this._isWFFetching = true;
      this._drawFeeInvoice.TaskID = this._workflow.TaskID;
      this._drawFeeInvoice.ObjectTypeID = 698
      this._drawFeeInvoice.ObjectID = this._workflow.TaskID
      this._drawFeeInvoice.InvoiceTypeID = 558

      this.wfSrv.InsertUpdateDrawFeeInvoice(this._drawFeeInvoice).subscribe(res => {
        if (res.Succeeded) {
          this.GetDrawFeeInvoiceDetailByTaskID();
          this._autoSendInvoice = this._drawFeeInvoice.AutoSendInvoice;
          //refresh activity log
          this.GetWFCommentsByTaskId(this._workflow);
          this._isWFFetching = false;
          if (this._isShowinvoicesaveMsg == false) {
            this._Showmessagediv = true;
            this._ShowmessagedivMsg = 'Invoice detail updated successfully';
            setTimeout(function () {
              this._Showmessagediv = false;
              this._ShowmessagedivMsg = "";
            }.bind(this), 4000);
          }
          else {
            this._isShowinvoicesaveMsg = false
            var notenewcopied;
            if (window.location.href.indexOf("dealdetail/a") > -1) {
              notenewcopied = ['dealdetail', this._wfAdditionalData.CREDealID]
            }
            else {
              notenewcopied = ['dealdetail/a', this._wfAdditionalData.CREDealID]
            }

            localStorage.setItem('ClickedTabId', 'aFunding');
            localStorage.setItem('divSucessDeal', 'true');
            localStorage.setItem('divSucessMsgDeal', 'Draw approval status updated successfully');

            this._router.navigate(notenewcopied);

          }
        }
        else {
          this._router.navigate(['login']);
        }
      });
    } catch (err) {
      this._isWFFetching = false;
    }
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

  getAllStatesMaster() {
    try {
      this.wfSrv.getAllStatesMaster().subscribe(res => {
        if (res.Succeeded) {
          var data = res.dt;
          this.lstStates = data;
        }
      });
    }
    catch (err) {
      console.log(err);
    }
  }

  onChangeDrawfeeAmount() {
    var deccount = 0;
    var FeeAmtdec = this._drawFeeInvoice.Amount;
    if (Math.floor(FeeAmtdec) === FeeAmtdec) {
      deccount = 0;
    }
    else {
      if ((FeeAmtdec % 1) != 0) {
        deccount = FeeAmtdec.toString().split(".")[1].length || 0;
      }
    }
    if (deccount > 2) {
      this._drawFeeInvoice.Amount = parseFloat(parseFloat(this._drawFeeInvoice.Amount.toString()).toFixed(2));
      return;
    }
  }
  onload = function () {
    var ele = document.getElementById('drawFeeInvoicedivs');

  }
  enablediableControls() {
    //// to enable or disable controls
    //if (this.rolename == 'Asset Manager' && (this._drawFeeInvoice.DrawFeeStatus == 0 || this._drawFeeInvoice.DrawFeeStatus == 692 || this._drawFeeInvoice.DrawFeeStatus == 696)) {
    //    $("#drawFeeInvoicedivs").on("mouseover", function () {
    //        $("#drawFeeInvoicedivs").find('input, select, textarea, checkbox, radio, button').removeAttr('disabled', false);
    //        $("#drawFeeInvoicedivs").find('input, select, textarea, checkbox, radio, button').removeClass("disabledrawfee");
    //    });
    //}
    //else {
    //    $("#drawFeeInvoicedivs").on("mouseover", function () {
    //        $('#drawFeeInvoicedivs').find('input, select, textarea, checkbox, radio, button').attr('disabled', true);
    //        $("#drawFeeInvoicedivs").find('input, select, textarea, checkbox, radio, button').addClass("disabledrawfee");
    //    });
    //}
  }

  enableDisableDrawFeeSection() {

    if (this.rolename == 'Asset Manager' && (this._drawFeeInvoice.DrawFeeStatus == 0 || this._drawFeeInvoice.DrawFeeStatus == 692 || this._drawFeeInvoice.DrawFeeStatus == 696)) {

      if (this._drawFeeInvoiceOrignal.FirstName == null || this._drawFeeInvoiceOrignal.FirstName == '' && this._drawFeeInvoice.LastName != null && this._drawFeeInvoice.LastName != '') {

        $("#drawFeeInvoicedivs").find('input, select, textarea, checkbox, radio').removeAttr('disabled', false);
        $("#drawFeeInvoicedivs").find('input, select, textarea, checkbox, radio').removeClass("disabledrawfee");
        $("#drawFeeInvoicedivs").find('wj-input-number').removeClass("disabledrawfee");
      }
      else {
        $('#drawFeeInvoicedivs').find('input, select, textarea, checkbox, radio').attr('disabled', true);
        $("#drawFeeInvoicedivs").find('input, select, textarea, checkbox, radio').addClass("disabledrawfee");
        $("#drawFeeInvoicedivs").find('wj-input-number').addClass("disabledrawfee");
      }
    }
    else {
      $('#drawFeeInvoicedivs').find('input, select, textarea, checkbox, radio').attr('disabled', true);
      $("#drawFeeInvoicedivs").find('input, select, textarea, checkbox, radio').addClass("disabledrawfee");
      $("#drawFeeInvoicedivs").find('wj-input-number').addClass("disabledrawfee");
    }


  }

  CheckValidationforDrawFee(errMsg) {
    var errorMsg = "";
    const Emailexp = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    const Zipexp = /(^\d{5}$)|(^\d{5}-\d{4}$)/;
    var phoneNumberPattern = /^\(?(\d{3})\)[ ]?(\d{3})[-](\d{4})$/;
    var phonepattern = /^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$/;   //for us num
    var pattern = /^[0-9a-bA-B]+$/;


    //var phonepattern = /^(\d{3}-\d{3}-\d{4})$/;

    if (this._drawFeeInvoice.AutoSendInvoice == 0) {
      errorMsg = errorMsg + "<p>" + "Please select Auto Send Draw Fee Invoice.";
    }
    if (this._drawFeeInvoice.Amount == null || this._drawFeeInvoice.Amount == undefined || this._drawFeeInvoice.Amount.toString() == "") {
      errorMsg = errorMsg + "<p>" + "Please enter Draw Fee Amount.";
    }
    else if (this._drawFeeInvoice.Amount <= 0) {
      errorMsg = errorMsg + "<p>" + "The Draw Fee amount can not be zero or negative. You can set Draw Fee Applicable to No in the checklist if you want to skip the draw fee process.";
    }
    if (this._drawFeeInvoice.FirstName == null || this._drawFeeInvoice.FirstName == undefined || this._drawFeeInvoice.FirstName == "") {
      errorMsg = errorMsg + "<p>" + "Please enter First Name.";
    }
    if (this._drawFeeInvoice.LastName == null || this._drawFeeInvoice.LastName == undefined || this._drawFeeInvoice.LastName == "") {
      errorMsg = errorMsg + "<p>" + "Please enter Last Name.";
    }
    //if (this._drawFeeInvoice.Designation == null || this._drawFeeInvoice.Designation == undefined || this._drawFeeInvoice.Designation == "") {
    //    errorMsg = errorMsg + "<p>" + "Please enter Designation.";
    //}
    if (this._drawFeeInvoice.CompanyName == null || this._drawFeeInvoice.CompanyName == undefined || this._drawFeeInvoice.CompanyName == "") {
      errorMsg = errorMsg + "<p>" + "Please enter Company Name.";
    }
    if (this._drawFeeInvoice.Address == null || this._drawFeeInvoice.Address == undefined || this._drawFeeInvoice.Address == "") {
      errorMsg = errorMsg + "<p>" + "Please enter Address.";
    }
    if (this._drawFeeInvoice.City == null || this._drawFeeInvoice.City == undefined || this._drawFeeInvoice.City == "") {
      errorMsg = errorMsg + "<p>" + "Please enter City.";
    }
    if (this._drawFeeInvoice.StateID == null || this._drawFeeInvoice.StateID == undefined || this._drawFeeInvoice.StateID.toString() == "") {
      errorMsg = errorMsg + "<p>" + "Please select State.";
    }

    if (this._drawFeeInvoice.Zip) {
      if (!Zipexp.test(this._drawFeeInvoice.Zip)) {
        errorMsg = errorMsg + "<p>" + "Please enter valid Zip Code." + "</p>";
      }
    }

    if (!this._drawFeeInvoice.Email1) {
      errorMsg = errorMsg + "<p>" + "Please enter Borrower Primary Email Address(es)." + "</p>";
    }
    if (this._drawFeeInvoice.Email1) {
      if (this._drawFeeInvoice.Email1) {
        this._drawFeeInvoice.Email1 = this._drawFeeInvoice.Email1.replace(/,(?=\s*$)/, '');
        var drawtoemail = this._drawFeeInvoice.Email1.replace(/;/g, ",").replace(/,(?=\s*$)/, '');
        var foundemail = '';
        var foundcomma = drawtoemail.indexOf(",");
        if (foundcomma > 0) {
          var splitemail = drawtoemail.split(",");
          for (var k = 0; k < splitemail.length; k++) {
            splitemail[k] = splitemail[k].replace(/\s/g, '');
            if (splitemail[k].trim() != '') {
              if (!Emailexp.test(String(splitemail[k]).toLowerCase())) {
                foundemail = foundemail + splitemail[k] + ", ";
              }
            }
          }
          if (foundemail != '') {
            errorMsg = errorMsg + "<p>" + "Please enter valid Borrower Primary Email Address(es) separated by comma/semicolon." + "</p>";
          }
        }
        else {
          if (this._drawFeeInvoice.Email1 != "") {
            if (!Emailexp.test(String(this._drawFeeInvoice.Email1).toLocaleLowerCase())) {
              errorMsg = errorMsg + "<p>" + "Please enter valid Borrower Primary Email Address(es) separated by comma/semicolon." + "</p>";
            }
          }
        }
      }
    }


    if (this._drawFeeInvoice.Email2) {
      this._drawFeeInvoice.Email2 = this._drawFeeInvoice.Email2.replace(/,(?=\s*$)/, '');
      var drawccemail = this._drawFeeInvoice.Email2.replace(/;/g, ",").replace(/,(?=\s*$)/, '');

      var foundemail = '';
      var foundcomma = drawccemail.indexOf(",");
      if (foundcomma > 0) {
        var splitemail = drawccemail.split(",");
        for (var k = 0; k < splitemail.length; k++) {
          splitemail[k] = splitemail[k].replace(/\s/g, '');
          if (splitemail[k].trim() != '') {
            if (!Emailexp.test(String(splitemail[k]).toLowerCase())) {
              foundemail = foundemail + splitemail[k] + ", ";
            }
          }
        }
        if (foundemail != '') {
          errorMsg = errorMsg + "<p>" + "Please enter valid Borrower Cc Email Address(es) separated by comma/semicolon." + "</p>";
        }
      }
      else {
        if (this._drawFeeInvoice.Email2 != "") {
          if (!Emailexp.test(String(this._drawFeeInvoice.Email2).toLocaleLowerCase())) {
            errorMsg = errorMsg + "<p>" + "Please enter valid Borrower Cc Email Address(es) separated by comma/semicolon." + "</p>";
          }
        }
      }
    }

    if (this._drawFeeInvoice.PhoneNo) {
      if (phonepattern.test(this._drawFeeInvoice.PhoneNo)) {
        this._drawFeeInvoice.PhoneNo = this._drawFeeInvoice.PhoneNo.replace(/\D+/g, '').replace(/^(\d{3})(\d{3})(\d{4}).*/, '($1) $2-$3');
      }
      if (!phoneNumberPattern.test(this._drawFeeInvoice.PhoneNo)) {
        if (this._drawFeeInvoice.PhoneNo == null || this._drawFeeInvoice.PhoneNo.length != 10 || !pattern.test(this._drawFeeInvoice.PhoneNo)) {
          errorMsg = errorMsg + "<p>" + "Please enter valid contact number. Ex: (111) 111-1111";
        }
      }
    }

    if (this._drawFeeInvoice.AlternatePhone) {
      var unformatnum = this._drawFeeInvoice.AlternatePhone.replace(/[^\d]/g, "");
      if (unformatnum.length != 10) {
        errorMsg = errorMsg + "<p>" + "Please enter valid alternate contact number. Ex: (111) 111-1111";
      }
      else {
        this._drawFeeInvoice.AlternatePhone = this._drawFeeInvoice.AlternatePhone.replace(/\D+/g, '').replace(/^(\d{3})(\d{3})(\d{4}).*/, '($1) $2-$3');
      }
    }

    //if (!phoneNumberPattern.test(this._drawFeeInvoice.AlternatePhone)) {
    //    if (this._drawFeeInvoice.AlternatePhone.length != 10 || !pattern.test(this._drawFeeInvoice.AlternatePhone)) {
    //        errorMsg = errorMsg + "<p>" + "Please enter valid alternate contact number. Ex: (111) 111-1111";
    //    }
    //}
    errMsg = errorMsg;
    return errMsg;
  }

  saveDrawFeeInvoice() {
    this._isWFFetching = true;
    this.IsShowSaveAndStatusButton = false;
    this._drawFeeInvoice.TaskID = this._workflow.TaskID;
    this._drawFeeInvoice.DealName = this._wfAdditionalData.DealName;
    this._drawFeeInvoice.CreDealID = this._wfAdditionalData.CREDealID;
    this.wfSrv.CheckQBDCompanyCustomer(this._drawFeeInvoice).subscribe(res => {
      if (res.Succeeded) {
        if (res.DrawFeeInvoice.IsExistCompany == "1") {
          if (res.DrawFeeInvoice.IsExistCustomer == "0") {
            this.wfSrv.CreateQBDcustomer(this._drawFeeInvoice).subscribe(res => {
              if (res.Succeeded) {
                this.InsertUpdateDrawFeeInvoice()
              }
              else {

                this.InsertUpdateDrawFeeInvoice()
                /*
                this._isWFFetching = false;
                this._Showmessagediv = true;
                this._ShowmessagedivWar = true;fche
                this._ShowmessagedivMsgWar = 'Error in saving invoice detail';
                this.IsShowSaveAndStatusButton = true;
                setTimeout(function () {
                    this._ShowmessagedivWar = false;
                    this._ShowmessagedivMsgWar = "";
                }.bind(this), 4000);
                */
              }
            });
          }
          else if (this._drawFeeInvoice.FirstName != this._drawFeeInvoiceOrignal.FirstName ||
            this._drawFeeInvoice.LastName != this._drawFeeInvoiceOrignal.LastName ||
            this._drawFeeInvoice.CompanyName != this._drawFeeInvoiceOrignal.CompanyName ||
            this._drawFeeInvoice.Address != this._drawFeeInvoiceOrignal.Address ||
            this._drawFeeInvoice.City != this._drawFeeInvoiceOrignal.City ||
            this._drawFeeInvoice.StateID != this._drawFeeInvoiceOrignal.StateID ||
            this._drawFeeInvoice.Zip != this._drawFeeInvoiceOrignal.Zip) {
            this.wfSrv.UpdateQBDcustomer(this._drawFeeInvoice).subscribe(res => {
              if (res.Succeeded) {
                this.InsertUpdateDrawFeeInvoice()
              }
              else {

                this.InsertUpdateDrawFeeInvoice()
                /*
                this._isWFFetching = false;
                this._Showmessagediv = true;
                this._ShowmessagedivWar = true;
                this._ShowmessagedivMsgWar = 'Error in saving invoice detail';
                this.IsShowSaveAndStatusButton = true;
                setTimeout(function () {
                    this._ShowmessagedivWar = false;
                    this._ShowmessagedivMsgWar = "";
                }.bind(this), 4000);
                */
              }
            });
          }
          else {
            this.InsertUpdateDrawFeeInvoice();
          }
        }
      }
      else {
        this._router.navigate(['login']);
      }
    });
  }


  saveDrawFeeInvoiceAndWorkFlow() {

    this._isWFFetching = true;
    this.IsShowSaveAndStatusButton = false;
    this._drawFeeInvoice.TaskID = this._workflow.TaskID;
    this._drawFeeInvoice.DealName = this._wfAdditionalData.DealName;
    this._drawFeeInvoice.CreDealID = this._wfAdditionalData.CREDealID;
    this.wfSrv.CheckQBDCompanyCustomer(this._drawFeeInvoice).subscribe(res => {
      if (res.Succeeded) {
        if (res.DrawFeeInvoice.IsExistCompany == "1") {
          if (res.DrawFeeInvoice.IsExistCustomer == "0") {
            this.wfSrv.CreateQBDcustomer(this._drawFeeInvoice).subscribe(res => {
              if (res.Succeeded) {
                this.InsertUpdateDrawFeeInvoiceSaveWorkFlow()
              }
              else {

                this.InsertUpdateDrawFeeInvoiceSaveWorkFlow()
                /*
                this._isWFFetching = false;
                this._Showmessagediv = true;
                this._ShowmessagedivWar = true;
                this._ShowmessagedivMsgWar = 'Error in saving invoice detail';
                this.IsShowSaveAndStatusButton = true;
                setTimeout(function () {
                    this._ShowmessagedivWar = false;
                    this._ShowmessagedivMsgWar = "";
                }.bind(this), 4000);
                */
              }
            });
          }
          else if (this._drawFeeInvoice.FirstName != this._drawFeeInvoiceOrignal.FirstName ||
            this._drawFeeInvoice.LastName != this._drawFeeInvoiceOrignal.LastName ||
            this._drawFeeInvoice.CompanyName != this._drawFeeInvoiceOrignal.CompanyName ||
            this._drawFeeInvoice.Address != this._drawFeeInvoiceOrignal.Address ||
            this._drawFeeInvoice.City != this._drawFeeInvoiceOrignal.City ||
            this._drawFeeInvoice.StateID != this._drawFeeInvoiceOrignal.StateID ||
            this._drawFeeInvoice.Zip != this._drawFeeInvoiceOrignal.Zip) {
            this.wfSrv.UpdateQBDcustomer(this._drawFeeInvoice).subscribe(res => {
              if (res.Succeeded) {
                this.InsertUpdateDrawFeeInvoiceSaveWorkFlow()
              }
              else {
                this.InsertUpdateDrawFeeInvoiceSaveWorkFlow()
                /*
                this._isWFFetching = false;
                this._Showmessagediv = true;
                this._ShowmessagedivWar = true;
                this._ShowmessagedivMsgWar = 'Error in saving invoice detail';
                this.IsShowSaveAndStatusButton = true;
                setTimeout(function () {
                    this._ShowmessagedivWar = false;
                    this._ShowmessagedivMsgWar = "";
                }.bind(this), 4000);
                */
              }
            });
          }
          else {
            this.InsertUpdateDrawFeeInvoiceSaveWorkFlow();
          }
        }
      }
      else {
        this._router.navigate(['login']);
      }
    });
  }

  InsertUpdateDrawFeeInvoiceSaveWorkFlow(): void {
    try {
      this._isWFFetching = true;
      this._drawFeeInvoice.TaskID = this._workflow.TaskID;
      this._drawFeeInvoice.ObjectTypeID = 698
      this._drawFeeInvoice.ObjectID = this._workflow.TaskID
      this._drawFeeInvoice.InvoiceTypeID = 558

      this.wfSrv.InsertUpdateDrawFeeInvoice(this._drawFeeInvoice).subscribe(res => {
        if (res.Succeeded) {
          this.GetDrawFeeInvoiceDetailByTaskIDAndSaveWorkFlow();
          //refresh activity log
          this.GetWFCommentsByTaskId(this._workflow);
        }
        else {
          this._router.navigate(['login']);
        }
      });
    } catch (err) {
      this._isWFFetching = false;
    }
  }

  GetDrawFeeInvoiceDetailByTaskIDAndSaveWorkFlow(): void {
    try {
      this.wfSrv.GetDrawFeeInvoiceDetailByTaskID(this._workflow.TaskID).subscribe(res => {
        if (res.Succeeded) {
          this._drawFeeInvoice = res.DrawFeeInvoice;
          this._drawFeeInvoiceOrignal = JSON.parse(JSON.stringify(res.DrawFeeInvoice));
          this._autoSendInvoice = this._drawFeeInvoice.AutoSendInvoice;
          this.SaveWorkFlow();
        }
        else {
          this._router.navigate(['login']);
        }
      });
    } catch (err) {
    }
  }


  enableDrawSection() {
    // to enable or disable controls
    if (this.rolename == 'Asset Manager' && (this._drawFeeInvoice.DrawFeeStatus == 0 || this._drawFeeInvoice.DrawFeeStatus == 692 || this._drawFeeInvoice.DrawFeeStatus == 696)) {
      this.IsDrawFeeEditClick = true;
      $("#drawFeeInvoicedivs").find('input, select, textarea, checkbox, radio').removeAttr('disabled', false);
      $("#drawFeeInvoicedivs").find('input, select, textarea, checkbox, radio').removeClass("disabledrawfee");
      $("#drawFeeInvoicedivs").find('wj-input-number').removeClass("disabledrawfee");
    }

  }

  disableDrawSection() {
    $('#drawFeeInvoicedivs').find('input, select, textarea, checkbox, radio').attr('disabled', true);
    $("#drawFeeInvoicedivs").find('input, select, textarea, checkbox, radio').addClass("disabledrawfee");

  }

  handleKeyDown(event: any) {

    if (event.keyCode == 13) {
      $("#btnSaveInvoice").trigger("click");
      return false;
    }

  }

  showWFNotificationDialogForReserveWorkflow(notificatioType): void {
    this.notificatio_type = notificatioType;
    this._isShowChecklist = false;
    var msg = "";
    if (this._wfAdditionalData.Comment == undefined || this._wfAdditionalData.Comment == '') {

      msg = "<p>Comment is mandatory for draw approval process.";
      this.savedialogmsg = msg;
      this.CustomDialogteSave();
      return;
    }

    if (notificatioType == this._Final || notificatioType == this._RevisedFinal) {
      var lookupidForYes = this.lstCheckListStatusType.filter(x => x.Name.toString().toLowerCase() === 'yes')[0].LookupID;
      var checkListService = this._workflow.WFCheckList.filter(x => x.CheckListMasterId == 18)[0];
      //primary user of that deal will not be able to complete if team's approval checklist item is 'Yes' regardless of the amount

      if (Number(checkListService.CheckListStatus).toString() != lookupidForYes) {
        msg = "<p>Checklist items " + checkListService.CheckListName.replace('*', '') + " should be marked as YES for completed status.";
        this.savedialogmsg = msg;
        this.CustomDialogteSave();
        return;
      }
    }

    this._bodyText = "";
    this._footerText = "";
    var clientName = "";
    var dealclientName = "";
    var emailto = "";
    var IsMultiinvestor = false;
    var ClientFundingDetail = '';
    var ClientFundingDetailText = '';

    this._activityLog = '';
    this.environmentName = this.dataService._environmentNamae != '' ? "(" + this.dataService._environmentNamae.replace("-", "").trim() + ") " : "";
    var drawnumber = (this._wfAdditionalData.Comment != '' && this._wfAdditionalData.Comment != null) ? ' - ' + this._wfAdditionalData.Comment : '';
    var drawnumberWithoutDash = (this._wfAdditionalData.Comment != '' && this._wfAdditionalData.Comment != null) ? ' ' + this._wfAdditionalData.Comment : '';
    var fundingdateMMDDYYYYPrelim = (this._wfAdditionalData.Date != undefined && this._wfAdditionalData.Date != null) ? ' - Est. Release Date: ' + this.convertDateTOMMDDYYYY(this._wfAdditionalData.Date) : '';
    var fundingdateMMDDYYYYFianl = (this._wfAdditionalData.Date != undefined && this._wfAdditionalData.Date != null) ? ' - Approved: ' + this.convertDateTOMMDDYYYY(this._wfAdditionalData.Date) : '';

    //===============

    // add checklist to popup

    var table = '<table id="noteinfo" border="1" style="border-collapse:collapse;font-size:12px;"><tr style="font-weight:bold"><td style="padding-left:5px!important;padding-right:5px!important;">Checklist</td><td style="padding-left:5px!important;padding-right:5px!important;">Status</td><td style="padding-left:5px!important;padding-right:5px!important;">Comment</td></tr>'
    var tr = "";
    for (var i = 0; i < this._workflow.WFCheckList.length; i++) {

      if (!(Number(this._workflow.WFCheckList[i].CheckListStatusText).toString() == "NaN" || Number(this._workflow.WFCheckList[i].CheckListStatusText) == 0)) {
        this._workflow.WFCheckList[i].CheckListStatus = Number(this._workflow.WFCheckList[i].CheckListStatusText);
      }

      var statustext = this.lstCheckListStatusType.filter(x => x.LookupID === this._workflow.WFCheckList[i].CheckListStatus)[0].Name;
      tr = tr + '<tr><td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + this._workflow.WFCheckList[i].CheckListName + '</td><td style="padding-left:5px!important;padding-right:5px!important;">' + statustext + '</td><td style="text-align:left;padding-left:5px!important;padding-right:5px!important;">' + (this._workflow.WFCheckList[i].Comment == null ? '' : this._workflow.WFCheckList[i].Comment) + '</td></tr>'
    }

    table = table + tr + '</table>';
    this.checklistInTable = table
    //


    var prelimEmails = null;
    var finalEmails = null;
    if (this._workflow.WFNotificationMasterEmail != null && this._workflow.WFNotificationMasterEmail != undefined) {

      prelimEmails = this._workflow.WFNotificationMasterEmail.filter(x => x.LookupID == 604)
      finalEmails = this._workflow.WFNotificationMasterEmail.filter(x => x.LookupID == 605)

    }

    //

    if (notificatioType == this._Preliminary) {

      if (prelimEmails != null && prelimEmails.length > 0) {
        if (prelimEmails[0].EmailID != '' && prelimEmails[0].EmailID != null) {
          emailto = prelimEmails[0].EmailIDs
        }

      }


      this._wfNotificationDetail.WFNotificationMasterID = 4
      this._wfNotificationDetail.Subject = "Preliminary Reserve Release Notice - " + this._wfAdditionalData.DealName + drawnumber + fundingdateMMDDYYYYPrelim;
      this._bodyText = "ACORE is reviewing " + drawnumberWithoutDash.trim() + " in the amount of " + "$" + parseFloat(this._wfAdditionalData.Amount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '. ' +
        "This request is expected to be funded on " + this.convertDateToBindable(this._wfAdditionalData.Date) + ". A Final Notice will be sent once the required approvals are received.\n\n"
      this._wfNotificationDetail.WFBody = this._bodyText;
      this._notificationTittle = "Preliminary Notification";
      this.ReserveScheduleBreakDown = this.ReserveScheduleBreakDownPrelim;
    }
    else if (notificatioType == this._RevisedPreliminary) {
      if (prelimEmails != null && prelimEmails.length > 0) {
        if (prelimEmails[0].EmailID != '' && prelimEmails[0].EmailID != null) {
          emailto = prelimEmails[0].EmailIDs
        }
      }

      this._wfNotificationDetail.WFNotificationMasterID = 4
      this._wfNotificationDetail.Subject = "Revised - Preliminary Reserve Release Notice - " + this._wfAdditionalData.DealName + drawnumber + fundingdateMMDDYYYYPrelim;
      this._bodyText = "ACORE is reviewing " + drawnumberWithoutDash.trim() + " in the amount of " + "$" + parseFloat(this._wfAdditionalData.Amount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '. ' +
        "This request is expected to be funded on " + this.convertDateToBindable(this._wfAdditionalData.Date) + ". A Final Notice will be sent once the required approvals are received.\n\n"
      this._wfNotificationDetail.WFBody = this._bodyText;
      this._notificationTittle = "Revised - Preliminary Notification";
      this.ReserveScheduleBreakDown = this.ReserveScheduleBreakDownPrelim;
    }

    else if (notificatioType == this._Final) {

      this._isShowChecklist = true;
      if (finalEmails != null && finalEmails.length > 0) {
        if (finalEmails[0].EmailID != '' && finalEmails[0].EmailID != null) {
          emailto = finalEmails[0].EmailIDs
        }
      }


      this._wfNotificationDetail.WFNotificationMasterID = 5
      this._wfNotificationDetail.Subject = "Final Reserve Release Notice - " + this._wfAdditionalData.DealName + drawnumber + fundingdateMMDDYYYYFianl;

      this._bodyText = "ACORE has no objection to the release of reserve funds associated with " + drawnumberWithoutDash.trim() +
        ", totaling " + "$" + parseFloat(this._wfAdditionalData.Amount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") +
        ", to be released immediately.\n\nPlease confirm once funds are released.\n";
      this._wfNotificationDetail.WFBody = this._bodyText;
      this._notificationTittle = "Final Notification";
      if (this.commentHistory != '') {
        this._activityLog = "<b>Activity log:</b><br/>" + this.commentHistory
      }
      this.ReserveScheduleBreakDown = this.ReserveScheduleBreakDownFinal;
    }
    else if (notificatioType == this._RevisedFinal) {
      this._isShowChecklist = true;
      if (finalEmails != null && finalEmails.length > 0) {
        if (finalEmails[0].EmailID != '' && finalEmails[0].EmailID != null) {
          emailto = finalEmails[0].EmailIDs
        }
      }


      this._wfNotificationDetail.WFNotificationMasterID = 5
      this._wfNotificationDetail.Subject = "Revised - Final Reserve Release Notice - " + this._wfAdditionalData.DealName + drawnumber + fundingdateMMDDYYYYFianl;
      //vishal

      //===============
      this._bodyText = "ACORE has no objection to the release of reserve funds associated with " + drawnumberWithoutDash.trim() +
        ", totaling " + "$" + parseFloat(this._wfAdditionalData.Amount).toFixed(2).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") +
        ", to be released immediately.\n\nPlease confirm once funds are released.\n";
      this._wfNotificationDetail.WFBody = this._bodyText;
      this._notificationTittle = "Revised - Final Notification";
      if (this.commentHistory != '') {
        this._activityLog = "<b>Activity log:</b><br/>" + this.commentHistory
      }
      this.ReserveScheduleBreakDown = this.ReserveScheduleBreakDownFinal;
    }


    this._footerText = "Thank you,\n" + this._user.FirstName + ' ' + this._user.LastName + '\n' + this._user.Email + ((this._user.ContactNo1 != '' && this._user.ContactNo1 != null) ? ' | ' + this._user.ContactNo1 : '');
    this._wfNotificationDetail.WFFooter = this._footerText;
    this._wfNotificationDetail.EnvironmentName = this.environmentName;
    this._wfNotificationDetail.Subject = this.environmentName + this._wfNotificationDetail.Subject

    //change in subject for force funding type--need to uncomment for integration
    if (this._workflow.PurposeTypeId == 520) {
      this._wfNotificationDetail.Subject = "Force Funding – " + this._wfNotificationDetail.Subject;
    }
    var recipients = this._wfTemplateRecipient.filter(x => x.WFNotificationMasterID == this._wfNotificationDetail.WFNotificationMasterID);


    var Emailcc = '';

    if (this._wfAdditionalData.AMEmails.split('|')[1] != '') {
      Emailcc = this._wfAdditionalData.AMEmails.split('|')[1];
      if (recipients !== undefined && recipients != null && recipients.length > 0 && recipients[0].CC != '')
        Emailcc = Emailcc + ',' + recipients[0].CC;

    }
    else if (recipients !== undefined && recipients != null && recipients.length > 0 && recipients[0].CC != '')
      Emailcc = recipients[0].CC;



    var EmailTo = this._wfAdditionalData.AMEmails.split('|')[0];
    if (recipients !== undefined && recipients != null && recipients.length > 0 && recipients[0].TO != '')
      EmailTo = recipients[0].TO + "," + EmailTo;

    //removed amfunding team from the notification as requested by client
    // 13 dec 2019 email-Add AMfunding team in internal emails and remove them from notification.
    //if (notificatioType == this._Preliminary || notificatioType == this._RevisedPreliminary) {

    //    if (Emailcc != '') {
    //        Emailcc = Emailcc + ',' + 'amfunding@mailinator.com';
    //    }
    //    else {
    //        Emailcc = 'amfunding@mailinator.com';
    //    }
    //}

    this._wfNotificationDetail.EmailCCIds = Emailcc;
    //this._wfNotificationDetail.ReplyTo = recipients[0].ReplyTo;
    this._wfNotificationDetail.ReplyTo = this._user.Email;

    this._wfNotificationDetail.EmailToIds = EmailTo;


    var notificationConfig = this.notificationConfig.filter(x => x.WFNotificationMasterID == this._wfNotificationDetail.WFNotificationMasterID);

    this._CanChangeReplyTo = notificationConfig[0].CanChangeReplyTo;
    this._CanChangeRecipientList = notificationConfig[0].CanChangeRecipientList;
    this._CanChangeHeader = notificationConfig[0].CanChangeHeader;
    this._CanChangeBody = notificationConfig[0].CanChangeBody;
    this._CanChangeFooter = notificationConfig[0].CanChangeFooter;
    this._CanChangeSchedule = notificationConfig[0].CanChangeSchedule;
    this._wfNotificationDetail.TemplateID = notificationConfig[0].TemplateID;
    this._wfNotificationDetail.TemplateFileName = IsMultiinvestor ? "MultiInvestorNotification.html" : notificationConfig[0].TemplateFileName;

    this.ConfirmDialogBoxFor = 'Notification';
    var modalWFNotification = document.getElementById('myModalWFNotification');
    modalWFNotification.style.display = "block";
    $.getScript("/js/jsDrag.js");
  }

}





const routes: Routes = [

  { path: '', component: WorkflowDetailComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjInputModule, WjGridFilterModule],
  declarations: [WorkflowDetailComponent]
})

export class workflowDetailModule { }
