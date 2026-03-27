using CRES.DAL.IRepository;
using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace CRES.BusinessLogic
{
    public class GenerateAutomationLogic
    {
        private GenerateAutomationRepository repo = new GenerateAutomationRepository();

        public bool QueueDealForAutomation(List<GenerateAutomationDataContract> list, string username)
        {
            return repo.QueueDealForAutomation(list, username);
        }
        public void UpdateCalculationStatusandTime(int calcid, string DealID, string statustext, string columnname, string errmsg, string updatedby, string DealSaveStatus)
        {
            repo.UpdateCalculationStatusandTime(calcid, DealID, statustext, columnname, errmsg, updatedby, DealSaveStatus);
        }
        public List<GenerateAutomationDataContract> GetListOfDealsForAutomation()
        {
            return repo.GetListOfDealsForAutomation();
        }
        public List<GenerateAutomationDataContract> GetDealListForAutomation(string type)
        {
            return repo.GetDealListForAutomation(type);
        }
        public DataTable GetAutomationRequestsForEmail(string BatchType)
        {
            return repo.GetAutomationRequestsForEmail(BatchType);
        }
        public void UpdateAutomationRequestsSentEmailToY(string BatchType)
        {
            repo.UpdateAutomationRequestsSentEmailToY(BatchType);
        }
        public DataTable GetAutomationRequestsAutoSpreadDealsForEmail(string BatchType)
        {
            return repo.GetAutomationRequestsAutoSpreadDealsForEmail(BatchType);
        }
        public void InsertIntoAutomationExtension(int? AutomationRequestsID, string DealID, int? BatchID, string ErrorMessage, string Message, string CreatedBy, string DealFundingID, string PurposeType, decimal? Amount, DateTime? Date)
        {
            repo.InsertIntoAutomationExtension(AutomationRequestsID, DealID, BatchID, ErrorMessage, Message, CreatedBy, DealFundingID, PurposeType, Amount, Date);
        }
        public DataTable GetDealListForAutomation()
        {
            return repo.GetDealListForAutomation();
        }
        public int CancelAutomation()
        {
            return repo.CancelAutomation();
        }
        public DataTable GetAutomationAuditLog(int? pageSize, int? pageIndex, out int? TotalCount)
        {
            return repo.GetAutomationAuditLog(pageSize, pageIndex, out TotalCount);

        }
        public DataTable GetAutomationRequestsDataForEmailByBatchType(string BatchType)
        {
            return repo.GetAutomationRequestsDataForEmailByBatchType(BatchType);
        }
        public DataTable GetDealByBatchIDAutomation(int BatchID)
        {
            return repo.GetDealByBatchIDAutomation(BatchID);
        }
        public int DeleteAutomationlog(int BatchID)
        {
            return repo.DeleteAutomationlog(BatchID);
        }
        public DataTable GetAutomationRequestsAutoForDownloadExcel(int BatchID)
        {
            return repo.GetAutomationRequestsAutoForDownloadExcel(BatchID);
        }
        public void QueueSingleDealForAutomation(string DealID, int? AutomationType, string CreatedBy, string BatchType, int? BatchID)
        {
            repo.QueueSingleDealForAutomation(DealID, AutomationType, CreatedBy, BatchType, BatchID);
        }

        public DataTable QueueDealForCalcualationAfterDealSaveAutomation()
        {
            return repo.QueueDealForCalcualationAfterDealSaveAutomation();
        }

        public void UpdateDealSentForCalculationToYes()
        {
            repo.UpdateDealSentForCalculationToYes();
        }

        public DataTable GetFundingDrawByBusinessday(int NextBDNumber)
        {
            return repo.GetFundingDrawByBusinessday(NextBDNumber);
        }

        public DataTable GetFundingDrawByOneBusinessdayWF(int NextBDNumber)
        {
            return repo.GetFundingDrawByOneBusinessdayWF(NextBDNumber);
        }
        public DataTable GetDiscrepancyForAdjCommitmentM61VsBackshop()
        {
            return repo.GetDiscrepancyForAdjCommitmentM61VsBackshop();
        }
        public DataTable GetDiscrepancyForCommitmentData()
        {
            return repo.GetDiscrepancyForCommitmentData();
        }

        public DataTable GetFundingDrawByOneBusinessdayBackDate(int NextBDNumber)
        {
            return repo.GetFundingDrawByOneBusinessdayBackDate(NextBDNumber);
        }
    }
}
