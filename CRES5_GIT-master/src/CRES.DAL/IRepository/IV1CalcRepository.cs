using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;

namespace CRES.DAL.IRepository
{
    public interface IV1CalcRepository
    {
        List<V1CalculationStatusDataContract> GetAllDealsProcessingstatus();
        void UpdateCalculationRequestsStatus(string dealid, string RequestID, int Status, string AnalysisID, string UserID, string errmsg);
        List<V1CalculationStatusDataContract> GetRecordsFromCalculationRequest();
        int InsertPayRuleDistribution(DataTable dtperiodicoutput, string AnalysisID, string CreatedBy);
        string UpdateM61EngineCalcStatus(string RequestID, int Status, string errmsg);
        DataTable GetDataFromCalculationRequestsByRequestID(string requestid);
        int InsertCalculatorOutputJsonInfo_V1(string RequestID, Guid? UserID, String FileName, string FileType);
        int InsertTransactionEntry(DataTable dtTransactionsoutput, string AnalysisID, string CreatedBy, string crenoteid, string StrCreatedBy);
        int UpdateTransactionEntryCash_NonCash(string NoteId, string AnalysisID);
        List<V1CalculationStatusDataContract> GetRequestIDFromCalculationRequestsDataNotSaveInDB();
    }
}
