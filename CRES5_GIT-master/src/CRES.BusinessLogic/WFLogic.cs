using CRES.DAL.Helper;
using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using CRES.DAL;
using CRES.DataContract.WorkFlow;

namespace CRES.BusinessLogic
{
    public class WFLogic
    {
        WFRepository _wfRepository = new WFRepository();
        public WFDetailDataContract GetWorkflowDetailByTaskId(WFDetailDataContract wfDetailDataContract, string UserID)
        {
            //EmailNotification em = new EmailNotification();
            //em.SendConsolidatWFEmailNotification();
            WFDetailDataContract _wfDetailDataContract = _wfRepository.GetWorkflowDetailByTaskId(wfDetailDataContract, UserID);
            return _wfDetailDataContract;
        }

        public WFAdditionalDataContarct GetWorkflowAdditionalDetailByTaskId(WFDetailDataContract wfDetailDataContract, string UserID)
        {
            WFAdditionalDataContarct _wfAdditionalDataContarct = _wfRepository.GetWorkflowAdditionalDetailByTaskId(wfDetailDataContract, UserID);
            return _wfAdditionalDataContarct;
        }

        public List<WFStatusDataContract> GetStatusMasterByTaskId(WFDetailDataContract wfDetailDataContract, string UserID)
        {
            List<WFStatusDataContract> _wfStatus = _wfRepository.GetStatusMasterByTaskId(wfDetailDataContract, UserID);
            return _wfStatus;
        }

        public List<WFCheckListDataContract> GetCheckListByTaskId(WFDetailDataContract wfDetailDataContract, string UserID)
        {
            List<WFCheckListDataContract> _wfStatus = _wfRepository.GetCheckListByTaskId(wfDetailDataContract, UserID);
            return _wfStatus;
        }

        public string InsertWorkflowDetailForTaskId(WFDetailDataContract _wfDetailDataContract)
        {
            string _result = _wfRepository.InsertWorkflowDetailForTaskId(_wfDetailDataContract);
            return _result;
        }
        
        public List<WorkflowListDataContract> GetAllWorkflow(Guid? userId, int? pageSize, int? pageIndex, out int? TotalCount)
        {
            List<WorkflowListDataContract> lstWorkflow = new List<WorkflowListDataContract>();
            lstWorkflow = _wfRepository.GetAllWorkflow(userId, pageSize, pageIndex, out TotalCount).ToList();
            return lstWorkflow;
        }

        public List<WorkflowListDataContract> GetAllWorkflowByFiltertype(Guid? userId, string filterType, string CREDealID, int? pageSize, int? pageIndex, out int? TotalCount)
        {
            List<WorkflowListDataContract> lstWorkflow = new List<WorkflowListDataContract>();
            lstWorkflow = _wfRepository.GetAllWorkflowByFiltertype(userId, filterType, CREDealID, pageSize, pageIndex, out TotalCount).ToList();
            return lstWorkflow;
        }

        public List<WFNotificationDataContract> GetWorkflowNotificationDetailByTaskId(string ObjectID, int ObjectTypeId, string UserID)
        {
            return _wfRepository.GetWorkflowNotificationDetailByTaskId(ObjectID, ObjectTypeId, UserID);
        }


        public List<WFDetailDataContract> GetWFCommentsByTaskId(WFDetailDataContract wfDetailDataContract, string UserID)
        {
            return _wfRepository.GetWFCommentsByTaskId(wfDetailDataContract, UserID);
        }

        public List<WFNotificationConfigDataContract> GetWFNotificationConfigByNotificationType(WFNotificationMasterDataContract DCNotificationMaster)
        {
            return _wfRepository.GetWFNotificationConfigByNotificationType(DCNotificationMaster);
        }

        public string InsertUpdateWFNotification(WFNotificationDetailDataContract _wfDetailDataContract, string UserID)
        {
            return _wfRepository.InsertUpdateWFNotification(_wfDetailDataContract,UserID);
        }

        public List<WFTemplateRecipientDataContract> GetTemplateRecipientEmailIDs(WFNotificationMasterDataContract DCNotificationMaster)
        {
            return _wfRepository.GetTemplateRecipientEmailIDs(DCNotificationMaster);
        }

        public List<ClientDataContract> GetClientByDealFundingID(Guid DealFundingID, string UserID)
        {
            return _wfRepository.GetClientByDealFundingID(DealFundingID, UserID);
        }

        public List<ClientDataContract> GetWFNotificationMasterEmail(WFDetailDataContract wfDetailDataContract, string UserID)
        {
            return _wfRepository.GetWFNotificationMasterEmail(wfDetailDataContract, UserID);
        }

        public DataTable GetConsolidatWFEmailNotification()
        {
            return _wfRepository.GetConsolidatWFEmailNotification();
        }
        public List<WFRejectListDataContract> GetWFRejectStatusByTaskId(WFDetailDataContract wfDetailDataContract, string UserID)
        {
            return _wfRepository.GetWFRejectStatusByTaskId(wfDetailDataContract, UserID);
        }
        public WFDetailDataContract CheckWFConcurrentUpdate(Guid? TaskID, DateTime dtWFUpdateDate, DateTime dtWFAdditionalUpdateDate)
        {
            return _wfRepository.CheckWFConcurrentUpdate(TaskID, dtWFUpdateDate, dtWFAdditionalUpdateDate);
        }

        public int ValidateWireConfirmByTaskId(WFDetailDataContract _wfDetailDataContract, string UserID)
        {
            return _wfRepository.ValidateWireConfirmByTaskId(_wfDetailDataContract, UserID);
        }
        public List<WFStatusPurposeMappingDataContract> GetWFStatusPurposeMapping(Guid? userid)
        {
            return _wfRepository.GetWFStatusPurposeMapping(userid);
        }


        public DataTable GetAllForceFunding()
        {
            return _wfRepository.GetAllForceFunding();
        }

        public List<WFNotificationDataContract> GetForceFundingNotificationByTaskID(string Taskid)
        {
            return _wfRepository.GetForceFundingNotificationByTaskID(Taskid);
        }

        public DrawFeeInvoiceDataContract GetDrawFeeInvoiceDetailByTaskID(string TaskID, string UserID)
        {
            return _wfRepository.GetDrawFeeInvoiceDetailByTaskID(TaskID, UserID);
        }
        public string InsertUpdateDrawFeeInvoiceDetail(string UserID, DrawFeeInvoiceDataContract drawFeeDC)
        {
            return _wfRepository.InsertUpdateDrawFeeInvoiceDetail(UserID, drawFeeDC);
        }
        public int InsertUpdateInvoice(string UserID, DrawFeeInvoiceDataContract drawFeeDC)
        {
            return _wfRepository.InsertUpdateInvoice(UserID, drawFeeDC);
        }
        public DataTable GetWorkFlowStatus()
        {
            return _wfRepository.GetWorkFlowStatus();
        }


        public string UpdateDrawFeeInvoiceDetailStatus(string UserID, DrawFeeInvoiceDataContract drawFeeDC)
        {
            return _wfRepository.UpdateDrawFeeInvoiceDetailStatus(UserID, drawFeeDC);
        }
       
        

        public List<DrawFeeInvoiceDataContract> GetAllPendingInvoice(string UserID)
        {
            return _wfRepository.GetAllPendingInvoice(UserID);
        }

        public List<DrawFeeInvoiceDataContract> UpdateAndGetAllInvoiceQueued(string UserID)
        {
            return _wfRepository.UpdateAndGetAllInvoiceQueued(UserID);
        }

        public DataTable GetAllFeeInvoice(Guid? userId, string CREDealID, int? PageSize, int? PageIndex, out int? TotalCount)
        {
            return _wfRepository.GetAllFeeInvoice(userId, CREDealID, PageSize, PageIndex,out TotalCount);
        }

        public DrawFeeInvoiceDataContract CheckQBDCompanyCustomer(DrawFeeInvoiceDataContract drawFeeDC)
        { //
            return _wfRepository.CheckQBDCompanyCustomer(drawFeeDC);
        }

        public string AddUpdateQBDCustomer(string UserID,QBDCustomerInputDataContract drawFeeDC)
        {
            return _wfRepository.AddUpdateQBDCustomer(UserID,drawFeeDC);
        }

        public QBDCompanyDataContract GetQuickBookCompany(string UserID, QBDCompanyDataContract qbdCompany)
        {
            return _wfRepository.GetQuickBookCompany(UserID, qbdCompany);
        //
        }
        public DataTable GetAllStatesMaster(string UserID)
        {
            return _wfRepository.GetAllStatesMaster(UserID);
        }
        public DataTable SaveFeeInvoices(DataTable dtFeeInvoice, string UserID)
        {
            return _wfRepository.SaveFeeInvoices(dtFeeInvoice, UserID);
        }

        public List<DrawFeeInvoiceDataContract> GetMissingQBDCustomer()
        {
            return _wfRepository.GetMissingQBDCustomer();
        }

        public List<DrawFeeInvoiceDataContract> GeAllInvoicedMissingPDF(string UserID)
        {
            return _wfRepository.GeAllInvoicedMissingPDF(UserID);
        }


        public DrawFeeInvoiceDataContract GetDealPrimaryAM(int InvoiceDetailID, string UserID)
        {
            return _wfRepository.GetDealPrimaryAM(InvoiceDetailID,UserID);
        }

        public InvoiceConfigDataContract GetInvoiceConfigByInvoiceType(int InvoiceTypeID, string UserID)
        {
            return _wfRepository.GetInvoiceConfigByInvoiceType(InvoiceTypeID, UserID);
        }

        public List<ReserveAccountDataContract> GetReserveScheduleBreakDown(WFDetailDataContract wfDetailDataContract, string UserID)
        {
            return _wfRepository.GetReserveScheduleBreakDown(wfDetailDataContract, UserID);
        }

        public int? InsertInvoiceDetailByBatchUpload(string UserID, List<DrawFeeInvoiceBatchUploadDataContract> drawFeeDC)
        {
            return _wfRepository.InsertInvoiceDetailByBatchUpload(UserID, drawFeeDC);
        }

        public List<DrawFeeInvoiceDataContract> GetAllBatchInvoice(string UserID)
        {
            return _wfRepository.GetAllBatchInvoice(UserID);
        }

        public DrawFeeInvoiceDataContract GetInvoiceDetailByObjectTypeID(int ObjectTypeID, string @ObjectID,string UserID)
        {
            return _wfRepository.GetInvoiceDetailByObjectTypeID(ObjectTypeID, @ObjectID, UserID);
        }
        public List<DrawFeeInvoiceDataContract> GeAllInvoiceQueued(string UserID)
        {
            return _wfRepository.GeAllInvoiceQueued(UserID);
        }
        public List<DrawFeeInvoiceDataContract> GetMissingQBDCustomerFromBatch()
        {
            //_wfRepository
            return _wfRepository.GetMissingQBDCustomerFromBatch();
        }

        public string InsertUpdateWFTaskAdditionalDetail(WFTaskAdditionalDetailDataContract _wfDetailDataContract, string UserID)
        {
            return _wfRepository.InsertUpdateWFTaskAdditionalDetail(_wfDetailDataContract, UserID);
        }

        //CompleteWorkflowViaScript
        public string CompleteWorkflowViaScript(WFDetailDataContract _wfDetailDataContract, string UserID)
        {
            string _result = _wfRepository.CompleteWorkflowViaScript(_wfDetailDataContract,UserID);
            return _result;
        }

        public List<InvoiceSplitOutputDataContract> GetInvoiceSplit(InvoiceSplitParamDataContract _param, string UserID)
        {
            return _wfRepository.GetInvoiceSplit(_param,UserID);
        }

        public InvoiceAPIDataContract ValidateInvoiceAPIParams(DrawFeeInvoiceDataContract _DrawFeeInvoice,string UserID)
        {
            return _wfRepository.ValidateInvoiceAPIParams(_DrawFeeInvoice, UserID);
        }

        public DrawFeeInvoiceDataContract GetInvoiceDetailByID(string UserID, int InvoiceDetailID)
        {
            return _wfRepository.GetInvoiceDetailByID(UserID, InvoiceDetailID);
        }

        public DynamicsCustomer GetCustomerByAccountName(string AccountName)
        {
            return _wfRepository.GetCustomerByAccountName(AccountName);
        }

        public string UpdatePropertyManagerEmail(WFDetailDataContract _wfDetailDataContract)
        {
            string _result = _wfRepository.UpdatePropertyManagerEmail(_wfDetailDataContract);
            return _result;
        }

        public List<DrawFeeInvoiceDataContract> GetAllInvoicedInvoice(string UserID)
        {
            return _wfRepository.GetAllInvoicedInvoice(UserID);
        }

        public UserDataContract GetDealPrimaryAMByDealOrTaskType(string DealID, int TaskTypeID,string TaskID, string UserID)
        {
            return _wfRepository.GetDealPrimaryAMByDealOrTaskType(DealID,TaskTypeID,TaskID,UserID);
        }

        public WFNotificationDetailDataContract GetEmailsForCancelFinalNotifiction(string ObjectID, int ObjectTypeId, string UserID)
        {
            return _wfRepository.GetEmailsForCancelFinalNotifiction(ObjectID, ObjectTypeId, UserID);
        }


        public DataTable GetParentClientMissingEmail()
        {
            return _wfRepository.GetParentClientMissingEmail();
        }
        public string SaveWFDashboard(List<WFDashboardDataContract> lstWorkflow, string UserID)
        {
            return _wfRepository.SaveWFDashboard(lstWorkflow, UserID);
        }

        public List<DrawFeeInvoiceDataContract> GetAllInvoiceQueuedForSandbox(string UserID)
        {
            return _wfRepository.GetAllInvoiceQueuedForSandbox(UserID);
        }

        public string UpdateDrawFeeInvoiceDetailStatusForSandbox(string UserID, DrawFeeInvoiceDataContract drawFeeDC)
        {
            return _wfRepository.UpdateDrawFeeInvoiceDetailStatusForSandbox(UserID, drawFeeDC);
        }
        public List<DrawFeeInvoiceDataContract> GetMissingQBDCustomerInSandbox()
        {
            return _wfRepository.GetMissingQBDCustomerInSandbox();
        }

        public string AddUpdateQBDCustomerForSandbox(string UserID, QBDCustomerInputDataContract drawFeeDC)
        {
            return _wfRepository.AddUpdateQBDCustomerForSandbox(UserID, drawFeeDC);
        }

        public DrawFeeInvoiceDataContract GetInvoiceDetailByInvoiceNo(string UserID, string InvoiceNo)
        {
            return _wfRepository.GetInvoiceDetailByInvoiceNo(UserID, InvoiceNo);
        }

        public int CheckWFConcurrency (string UserID, WFConcurrencyParams prms)
        {
            return _wfRepository.CheckWFConcurrency(UserID, prms);
        }

        public string UpdateSponsorDetailFromBackshop(string DealID,string UserID)
        {
            return _wfRepository.UpdateSponsorDetailFromBackshop(DealID, UserID);
        }
        public DrawFeeInvoiceDataContract GetFormatedSponsorDetailFromBackshop(string DealID, string UserID)
        {
            return _wfRepository.GetFormatedSponsorDetailFromBackshop(DealID, UserID);
        }
        public void saveInvoicesLanding(DataTable dtInvoices)
        {
            _wfRepository.saveInvoicesLanding(dtInvoices);
        }

        public List<DrawFeeInvoiceDataContract> GetAllInvoicesFromInvoiceLanding(string UserID)
        {
            return _wfRepository.GetAllInvoicesFromInvoiceLanding(UserID);
        }

        public List<InvoicesLandingDataContract> GetAllReadyToPayInvoicesFromLanding(string UserID)
        {
            return _wfRepository.GetAllReadyToPayInvoicesFromLanding(UserID);
        }

        public string UpdateInvoiceDetailLandingStatus(string UserID,int InvoiceDetailID, string status)
        {
            return _wfRepository.UpdateInvoiceDetailLandingStatus(UserID, InvoiceDetailID,status);
        }

        public string DeleteInvoiceDetailLanding(string UserID, int InvoiceDetailID)
        {
            return _wfRepository.DeleteInvoiceDetailLanding(UserID, InvoiceDetailID);
        }


        public void updateInvoicesLanding(DataTable dtInvoices)
        {
            _wfRepository.updateInvoicesLanding(dtInvoices);
        }

        public void UpdateInvoice(string UserID, DrawFeeInvoiceDataContract drawFeeDC)
        {
            _wfRepository.updateInvoice(UserID, drawFeeDC);
        }
    }
}
