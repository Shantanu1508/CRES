import { Injectable } from '@angular/core';
import { DataService } from './data.service';
import { deals } from '../domain/deals.model';
import { Workflow, WFNotificationDetailDataContract } from "../../core/domain/workFlow.model";
import { DealFunding } from "../../core/domain/dealFunding.model";
import { WFNotificationMaster } from "../../core/domain/workFlow.model";
import { DrawFeeInvoiceDetail } from "../../core/domain/drawFeeInvoiceDetail.model";
import { QBDCompany } from "../../core/domain/QBDCompany.model";


@Injectable()

export class WFService {
  private _wfGetWorkflowDetailByTaskIdAPI: string = 'api/wfcontroller/getworkflowdetailbytaskId';
  private _wfManageWorkflowDetailForTaskIdAPI: string = 'api/wfcontroller/manageworkflowdetailfortaskId';
  private _wfGetAllWorkflowAPI: string = 'api/wfcontroller/getallworkflow';
  private _wfGetAllWorkflowByFilterTypeAPI: string = 'api/wfcontroller/getallworkflowbyfiltertype';
  private _wfGetWFCommentsByTaskIdAPI: string = 'api/wfcontroller/GetWFCommentsByTaskId';

  private _getfundingdetailbydealidAPI: string = 'api/deal/getfundingdetailbydealid';
  private _getfundingdetailbydealfundingidAPI: string = 'api/deal/getfundingdetailbyfundingid';
  private _getWFNotificationConfigByNotificationTypeAPI: string = 'api/wfcontroller/getWFNotificationConfigByNotificationType';
  private _InsertUpdateWFNotificationAPI: string = 'api/wfcontroller/InsertUpdateWFNotification';
  private _getTemplateRecipientEmailIDsAPI: string = 'api/wfcontroller/getTemplateRecipientEmailIDs';
  private _getValidateWireConfirmByTaskIdAPI: string = 'api/wfcontroller/validatewireconfirmbytaskId';
  private _wfGetWorkflowAdditionalDetailByTaskIdAPI: string = 'api/wfcontroller/getworkflowadditionaldetailbytaskId';
  private _GetDrawFeeInvoiceDetailByTaskIDAPI: string = 'api/wfcontroller/getdrawFeeinvoicedetailbytaskId';
  private _InsertUpdateDrawFeeInvoiceAPI: string = 'api/wfcontroller/insertupdatedrawfeeinvoice';
  private _createinvoiceAPI: string = 'api/wfcontroller/createinvoice'
  private _getWorkFlowStatusAPI: string = 'api/wfcontroller/getWorkFlowStatus';
  private _createqbdcustomerAPI = "api/wfcontroller/createqbdcustomer";
  private _checkqbdcompanycustomerAPI = "api/wfcontroller/checkqbdcompanycustomer";
  private _updateqbdcustomerAPI = "api/wfcontroller/updateqbdcustomer";
  private _getquickbookcompanyAPI = "api/wfcontroller/getquickbookcompany";
  private _getallStatesMasterAPI: string = 'api/wfcontroller/getallStatesMaster';
  private _SendWFNotificationForNegativeAmtAPI: string = 'api/wfcontroller/sendwfnotificationfornegativeamt';
  private _GetReserveScheduleBreakDownAPI: string = 'api/wfcontroller/getreserveschedulebreakdown';
  private _CompleteWorkflowViaScriptAPI: string = 'api/wfcontroller/completeworkflowviascript';
  private _wfUpdatePropertyManagerAPI: string = 'api/wfcontroller/updatepropertymanageremail';
  private _wfSendInternalNotificionAPI: string = 'api/wfcontroller/sendinternalnotificion';
  private _wfCancelNotificationAPI: string = 'api/wfcontroller/cancelnotification';
  private _SaveWFDashboardAPI: string = 'api/wfcontroller/savewfdashboard';
  private _updateSponsorDetailFromBackshopAPI: string = 'api/wfcontroller/updatesponsordetail';

  constructor(public datasrv: DataService) { }

  GetWorkflowDetailByTaskId(_workflow: Workflow) {
    this.datasrv.set(this._wfGetWorkflowDetailByTaskIdAPI);
    return this.datasrv.post(JSON.stringify(_workflow));
  }
  GetWorkflowAdditionalDetailByTaskId(_workflow: Workflow) {
    this.datasrv.set(this._wfGetWorkflowAdditionalDetailByTaskIdAPI);
    return this.datasrv.post(JSON.stringify(_workflow));
  }

  SaveWorkflowDetailByTaskId(_workflow: Workflow) {
    this.datasrv.set(this._wfManageWorkflowDetailForTaskIdAPI);
    return this.datasrv.post(JSON.stringify(_workflow));
  }

  getAllWorkflow(pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._wfGetAllWorkflowAPI, pagesIndex, pagesSize);
    return this.datasrv.get();
  }

  getAllWorkflowByFilterType(_workflow: Workflow, pagesIndex?: number, pagesSize?: number) {
    this.datasrv.set(this._wfGetAllWorkflowByFilterTypeAPI, pagesIndex, pagesSize);
    return this.datasrv.post(JSON.stringify(_workflow));
  }


  GetWFCommentsByTaskId(_workflow: Workflow) {
    this.datasrv.set(this._wfGetWFCommentsByTaskIdAPI);
    return this.datasrv.post(JSON.stringify(_workflow));
  }

  getFundingDetailByDealid(deal: deals) {
    this.datasrv.set(this._getfundingdetailbydealidAPI);
    return this.datasrv.post(JSON.stringify(deal));
  }

  getfundingdetailbydealfundingid(dealFunding: DealFunding) {
    this.datasrv.set(this._getfundingdetailbydealfundingidAPI);
    return this.datasrv.post(JSON.stringify(dealFunding))
  }

  getWFNotificationConfigByNotificationType(wfconfig: WFNotificationMaster) {
    this.datasrv.set(this._getWFNotificationConfigByNotificationTypeAPI);
    return this.datasrv.post(JSON.stringify(wfconfig));
  }

  InsertUpdateWFNotification(_wfNotificationDetail: WFNotificationDetailDataContract) {
    this.datasrv.set(this._InsertUpdateWFNotificationAPI);
    return this.datasrv.post(JSON.stringify(_wfNotificationDetail));
  }

  getTemplateRecipientEmailIDs(wfMaster: WFNotificationMaster) {
    this.datasrv.set(this._getTemplateRecipientEmailIDsAPI);
    return this.datasrv.post(JSON.stringify(wfMaster));
  }

  ValidateWireConfirmByTaskId(_workflow: Workflow) {
    this.datasrv.set(this._getValidateWireConfirmByTaskIdAPI);
    return this.datasrv.post(JSON.stringify(_workflow));
  }
  GetDrawFeeInvoiceDetailByTaskID(taskid: string) {
    this.datasrv.set(this._GetDrawFeeInvoiceDetailByTaskIDAPI);
    return this.datasrv.post(JSON.stringify(taskid));
  }

  InsertUpdateDrawFeeInvoice(DrawFeeDC: DrawFeeInvoiceDetail) {
    this.datasrv.set(this._InsertUpdateDrawFeeInvoiceAPI);
    return this.datasrv.post(JSON.stringify(DrawFeeDC));
  }

  CreateInvoice(DrawFeeDC: DrawFeeInvoiceDetail) {
    this.datasrv.set(this._createinvoiceAPI);
    return this.datasrv.post(JSON.stringify(DrawFeeDC));
  }

  getWorkflowStatus() {
    this.datasrv.set(this._getWorkFlowStatusAPI);
    return this.datasrv.getAll();
  }

  CheckQBDCompanyCustomer(DrawFeeDC: DrawFeeInvoiceDetail) {
    this.datasrv.set(this._checkqbdcompanycustomerAPI);
    return this.datasrv.post(JSON.stringify(DrawFeeDC));

  }
  CreateQBDcustomer(DrawFeeDC: DrawFeeInvoiceDetail) {
    this.datasrv.set(this._createqbdcustomerAPI);
    return this.datasrv.post(JSON.stringify(DrawFeeDC));
  }
  UpdateQBDcustomer(DrawFeeDC: DrawFeeInvoiceDetail) {
    this.datasrv.set(this._updateqbdcustomerAPI);
    return this.datasrv.patch(JSON.stringify(DrawFeeDC));
  }

  //GetQuickBookCompany
  GetQuickBookCompany(DrawFeeDC: QBDCompany) {
    this.datasrv.set(this._getquickbookcompanyAPI);
    return this.datasrv.post(JSON.stringify(DrawFeeDC));
  }

  getAllStatesMaster() {
    this.datasrv.set(this._getallStatesMasterAPI);
    return this.datasrv.getAll();
  }

  SendWFNotificationForNegativeAmt(_wfNotificationDetail: WFNotificationDetailDataContract) {
    this.datasrv.set(this._SendWFNotificationForNegativeAmtAPI);
    return this.datasrv.post(JSON.stringify(_wfNotificationDetail));
  }

  GetReserveScheduleBreakDown(_workflow: Workflow) {
    this.datasrv.set(this._GetReserveScheduleBreakDownAPI);
    return this.datasrv.post(JSON.stringify(_workflow));
  }

  //Complete Workflow Via Script
  CompleteWorkflowViaScript(_workflow: Workflow) {
    this.datasrv.set(this._CompleteWorkflowViaScriptAPI);
    return this.datasrv.post(JSON.stringify(_workflow));
  }
  UpdatePropertyManagerEmail(_workflow: Workflow) {
    this.datasrv.set(this._wfUpdatePropertyManagerAPI);
    return this.datasrv.post(JSON.stringify(_workflow));
  }

  SendInternalNotificion(_workflow: Workflow) {
    this.datasrv.set(this._wfSendInternalNotificionAPI);
    return this.datasrv.post(JSON.stringify(_workflow));
  }

  CancelNotification(_wfNotificationDetail: WFNotificationDetailDataContract) {
    this.datasrv.set(this._wfCancelNotificationAPI);
    return this.datasrv.post(JSON.stringify(_wfNotificationDetail));
  }
  SaveWFDashboard(WFList: any) {
    this.datasrv.set(this._SaveWFDashboardAPI);
    return this.datasrv.post(JSON.stringify(WFList));
  }

  UpdateSponsorDetailFromBackshop(_credealid: string) {
    this.datasrv.set(this._updateSponsorDetailFromBackshopAPI);
    return this.datasrv.post(JSON.stringify(_credealid));
  }
}




