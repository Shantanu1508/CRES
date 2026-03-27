using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;

namespace CRES.DAL.IRepository
{
    public interface ICalculationManagerRespository
    {
        List<CalculationManagerDataContract> RefreshCalculationStatus(CalculationManagerDataContract DCcalc, Guid? UserID);
        bool QueueNotesForCalculation(List<CalculationManagerDataContract> noteslist,string username, string RequestFrom = "");

        void UpdateCalculationStatusandTime(Guid calcid, string noteid, string statustext, string columnname, string errmsg);

        List<CalculationManagerDataContract> NotesListForCalculation();

        int GetCalcRequestCount();
        List<RequestFailureDataContract> GetCalculationRequestFailureNotes(int moduleId);
        List<BatchCalculationMasterDataContract> GetBatchCalculationLog(CalculationManagerDataContract DCcalc);
        List<BatchCalculationMasterDataContract> GetBatchCalculationForEmailNotification(string UserID);
        void CreateBatchCalculationTag();
        List<CalculationManagerDataContract> NotesListForCalculationByServerIndex(int ServerIndex);
        string DeleteBatchCalculationRequestByAnalysisID(string AnalysisID);
        DataTable GetTransactionCategory(Guid? UserID);
        DataTable GetTransactionGroup(Guid? UserID);
        void InsertExceptionsOfCalculatorComponent(Guid? NoteId, Guid? AnalysisID, string UserID);
        DataTable CancelBatchRequestByAnalysisID(string AnalysisID);
        void QueueNotesForCalculationForDuplicateTransaction();
        void UpdateNoteCalculatedWeightedSpread(string NoteID, decimal? WeightedSpread);
        void UpdateCalcStatusBYAnalysisIDAndType(string AnalysisID, string Type, Guid? UserID);
        void UpdateBatchDetailWhenCancel(string AnalysisID);

        void CalcNetCapitalInvestedbyNoteId(string NoteID);
        void QueueNotesForCalculationIfDWoutofSync();

    }
}