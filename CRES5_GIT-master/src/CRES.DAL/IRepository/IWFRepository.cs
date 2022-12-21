using CRES.DataContract;
using CRES.DataContract.WorkFlow;
using System;
using System.Collections.Generic;

namespace CRES.DAL.IRepository
{
    public interface IWFRepository
    {
        WFDetailDataContract GetWorkflowDetailByTaskId(WFDetailDataContract wfDetailDataContract, string UserID);
        WFAdditionalDataContarct GetWorkflowAdditionalDetailByTaskId(WFDetailDataContract wfDetailDataContract, string UserID);
        List<WFStatusDataContract> GetStatusMasterByTaskId(WFDetailDataContract wfDetailDataContract, string UserID);
        List<WFCheckListDataContract> GetCheckListByTaskId(WFDetailDataContract wfDetailDataContract, string UserID);
        string InsertWorkflowDetailForTaskId(WFDetailDataContract _wfDetailDataContract);
        List<WorkflowListDataContract> GetAllWorkflow(Guid? userId, int? PageSize, int? PageIndex, out int? TotalCount);
        List<WFNotificationDataContract> GetWorkflowNotificationDetailByTaskId(string ObjectID, int ObjectTypeId, string UserID);
        List<WFNotificationConfigDataContract> GetWFNotificationConfigByNotificationType(WFNotificationMasterDataContract DCNotificationMaster);
        string InsertUpdateWFNotification(WFNotificationDetailDataContract _wfDetailDataContract, string UserID);
        List<WFTemplateRecipientDataContract> GetTemplateRecipientEmailIDs(WFNotificationMasterDataContract DCNotificationMaster);
        List<ClientDataContract> GetClientByDealFundingID(Guid DealFundingID, string UserID);
        List<ClientDataContract> GetWFNotificationMasterEmail(WFDetailDataContract wfDetailDataContract, string UserID);
        List<WFRejectListDataContract> GetWFRejectStatusByTaskId(WFDetailDataContract wfDetailDataContract, string UserID);
        WFDetailDataContract CheckWFConcurrentUpdate(Guid? TaskID, DateTime dtWFUpdateDate, DateTime dtWFAdditionalUpdateDate);
        int ValidateWireConfirmByTaskId(WFDetailDataContract _wfDetailDataContract, string UserID);
        List<WFStatusPurposeMappingDataContract> GetWFStatusPurposeMapping(Guid? userid);
        List<DrawFeeInvoiceDataContract> GeAlltPendingInvoice(string UserID);
        List<DrawFeeInvoiceDataContract> GetMissingQBDCustomer();
        List<DrawFeeInvoiceDataContract> GeAllInvoicedMissingPDF(string UserID);
        DrawFeeInvoiceDataContract GetDealPrimaryAM(int InvoiceDetailID, string UserID);
        InvoiceConfigDataContract GetInvoiceConfigByInvoiceType(int InvoiceTypeID, string UserID);
        List<WFDetailDataContract> GetWFCommentsByTaskId(WFDetailDataContract wfDetailDataContract, string UserID);
        List<ReserveAccountDataContract> GetReserveScheduleBreakDown(WFDetailDataContract wfDetailDataContract, string UserID);
        string InsertInvoiceDetailByBatchUpload(string UserID, List<DrawFeeInvoiceDataContract> drawFeeDC);
        List<DrawFeeInvoiceDataContract> GetAllBatchInvoice(string UserID);
        DrawFeeInvoiceDataContract GetInvoiceDetailByObjectTypeID(int ObjectTypeID, string ObjectID, string UserID);
        List<DrawFeeInvoiceDataContract> GeAllInvoiceQueued(string UserID);
        //GetMissingQBDCustomerFromBatch
        List<DrawFeeInvoiceDataContract> GetMissingQBDCustomerFromBatch();
        string InsertUpdateWFTaskAdditionalDetail(WFTaskAdditionalDetailDataContract _wfDetailDataContract, string UserID);
        string CompleteWorkflowViaScript(WFDetailDataContract _wfDetailDataContract, string UserID);
        List<InvoiceSplitOutputDataContract> GetInvoiceSplit(InvoiceSplitParamDataContract _param);
        InvoiceAPIDataContract ValidateInvoiceAPIParams(DrawFeeInvoiceDataContract _DrawFeeInvoice, string UserID);
        int InsertUpdateInvoice(string UserID, DrawFeeInvoiceDataContract drawFeeDC);
        DrawFeeInvoiceDataContract GetInvoiceDetailByID(string UserID, int InvoiceDetailID);
        DynamicsCustomer GetCustomerByAccountName(string AccountName);
        List<DrawFeeInvoiceDataContract> GetAllPendingInvoice(string UserID);
        List<DrawFeeInvoiceDataContract> UpdateAndGetAllInvoiceQueued(string UserID);
        string UpdatePropertyManagerEmail(WFDetailDataContract _wfDetailDataContract);
        List<DrawFeeInvoiceDataContract> GetAllInvoicedInvoice(string UserID);
        UserDataContract GetDealPrimaryAMByDealOrTaskType(string DealID, int TaskTypeID, string TaskID, string UserID);
        WFNotificationDetailDataContract GetEmailsForCancelFinalNotifiction(string ObjectID, int ObjectTypeId, string UserID);
    }
}
