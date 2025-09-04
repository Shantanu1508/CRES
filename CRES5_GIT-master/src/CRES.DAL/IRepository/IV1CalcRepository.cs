using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DataContract;
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
        int InsertTransactionEntry(DataTable dtTransactionsoutput, string AnalysisID, string CreatedBy, string crenoteid, string StrCreatedBy, string noteid, DateTime? LastAccountingCloseDate);
        int UpdateTransactionEntryCash_NonCash(string NoteId, string AnalysisID, DateTime LastAccountingclosedate, DateTime? MaturityUsedInCalc);
        void UpdateCalculationStatusForDependents(string CRENoteID, string AnalysisID);
        void InsertIntoCalculatorExtensionDbSave(string NoteID, string AnalysisID, string RequestID, string FileName, int ServerFileCount);
        DataTable GetTransactionEntryFromAccountingClose(string Noteid, string AnalysisID);
        DataTable GetNotePeriodicCalcFromAccountingClose(string Noteid, string AnalysisID);
        DataTable GetNoteInfoForPIKExport_V1(string Noteid);
        void DeleteTransactionEntry(string AnalysisID, string crenoteid);
        string CheckRequestIdInCalcTable(string RequestID);
        string UpdateM61EngineCalcStatusForLiability(string RequestID, int Status, string errmsg);
        V1CalcQueueSaveOutput GetDataFromCalculationRequestsLiabilityByRequestID(string requestid);
        List<V1CalculationStatusDataContract> GetDealidForPrepaymentCalculation();

    }
}
