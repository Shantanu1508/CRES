using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using CRES.DataContract;
using CRES.DataContract.Liability;

namespace CRES.DAL.IRepository
{
    public interface ILiabilityCalcRepository
    {
        List<JsonFormatCalcLiability> GetLiabilityJsonFormat();
        DataSet GetLiabilityCalcRequestData(string userID, String fundIDorName, string analysisID);
        List<EquityCalcDataContract> GetEquityForCalculation();
        List<GenerateAutomationDataContract> GetLiabilitListForCalculation(string type);
        void UpdateLiabilityCalculationStatusandTime(Guid calcid, string statustext, string columnname, string errmsg, string updatedby);
        void InsertTransactionEntryLiabilityLine(List<LiabilityLineTransaction> LiabilityLineTransaction, string username);
        void InsertLiabilityNoteTransaction(List<LiabilityNoteTransaction> LiabilityNoteTransaction, string username);
        void UpdateLiabilityTransactionFileName(int AutomationRequestsID, string FileName);
        List<JsonFormatCalcLiability> GetLiabilityCalcRequestForFeesAndInterest();
        DataSet GetLiabilityFeesAndInterestCalcRequestData(string userID, String fundIDorName, string analysisID);
        bool QueueLiabilityForCalculation(List<CalculationRequestsLiabilityDataContract> list, string username);
        void UpdateCalculationStatusandTime(string calcid, string statustext, string columnname, string errmsg,string requestId, int calculationModeID);
        void InsertLiabilityNoteTransactionForFeeAndInterest(List<LiabilityNoteTransaction> LiabilityNoteTransaction, string username);
        DataSet GetLiabilityFeesCalcRequestData(string userID, String fundIDorName, string analysisID);
        void InsertLiabilityNoteTransactionForFee(List<LiabilityNoteTransaction> LiabilityNoteTransaction, string username);
    }
}
