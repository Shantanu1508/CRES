using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;

namespace CRES.DAL.IRepository
{
    public interface IDynamicSizerRepository
    {
        List<DataDictionaryDataContract> GetDataDictionary();
        List<RefreshLookupDataContract> RefreshLookupList();
        DealDataContract SaveJSONDeal(DealDataContract _dealDc, string UserID);
        List<LiborScheduleTab> GetLiborRateForVSTO(string crenoteid, string scenariotext, DateTime closingdate);
        ScenarioParameterDataContract GetScenarioParameters(string ScenarioText);
        String CreateNewBatch(string username);
        int InsertBatchIntoDetail(int batchid, string notid, string SizerScenario);
        void UpdateNoteStatusAndTime(int batchid, string notid, int BatchDetailAsyncCalcVSTOID);
        void InsertNotePeriodicCalcVSTO(List<NotePeriodicOutputsDataContract> _notePeriodicOutputsDC, string username, string crenoteid, int batchDetailID, string scenario);
        void InsertTransactionVSTO(List<TransactionEntry> _lsttransactionEntryDC, string CRENoteId, int batchDetailID, string scenario, string NoteName);
        GenericVSTOResult CheckCalculationStatus(int batchid);
        List<TransactionEntryVSTO> GetTransactionEntryByBatchID(int batchID);
        List<PeriodicCashflowVSTO> GetNotePeriodicCalcByNoteId(int batchID);
        DataTable GetXIRROutputByBatchID(int batchID);
    }
}
