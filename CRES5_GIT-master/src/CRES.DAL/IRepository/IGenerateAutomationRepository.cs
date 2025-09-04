using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace CRES.DAL.IRepository
{
    public interface IGenerateAutomationRepository
    {
        bool QueueDealForAutomation(List<GenerateAutomationDataContract> list, string username);
        void UpdateCalculationStatusandTime(int calcid, string DealID, string statustext, string columnname, string errmsg, string UpdatedBy, string DealSaveStatus);
        List<GenerateAutomationDataContract> GetListOfDealsForAutomation();
        List<GenerateAutomationDataContract> GetDealListForAutomation(string type);
        DataTable GetAutomationRequestsForEmail(string BatchType);
        public void InsertIntoAutomationExtension(int? AutomationRequestsID, string DealID, int? BatchID, string ErrorMessage, string Message, string CreatedBy, string DealFundingID, string PurposeType, decimal? Amount, DateTime? Date);
        void UpdateAutomationRequestsSentEmailToY(string BatchType);
        DataTable GetAutomationRequestsAutoSpreadDealsForEmail(string BatchType);
        DataTable GetDealListForAutomation();
        void QueueSingleDealForAutomation(string DealID, int? AutomationType, string CreatedBy, string BatchType, int? BatchID);
        DataTable GetAutomationRequestsDataForEmailByBatchType(string BatchType);
        DataTable QueueDealForCalcualationAfterDealSaveAutomation();
        void UpdateDealSentForCalculationToYes();
        DataTable GetFundingDrawByBusinessday(int NextBDNumber);
        DataTable GetFundingDrawByOneBusinessdayWF(int NextBDNumber);
        DataTable GetDiscrepancyForAdjCommitmentM61VsBackshop();
        DataTable GetDiscrepancyForCommitmentDataByDealID(string DealID);
        DataTable GetFundingDrawByOneBusinessdayBackDate(int NextBDNumber);
    }
}
