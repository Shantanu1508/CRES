using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Text;
using System.Threading.Tasks;

namespace CRES.BusinessLogic
{
    public class DynamicSizerLogic
    {
        private DynamicSizerRepository _dySizerRepository = new DynamicSizerRepository();

        public List<DataDictionaryDataContract> GetDataDictionary()
        {
            return _dySizerRepository.GetDataDictionary();
        }
        public List<RefreshLookupDataContract> RefreshLookupList()
        {
            return _dySizerRepository.RefreshLookupList();
        }
        public List<RefreshTagXIRRDataContract> RefreshTagXIRR()
        {
            return _dySizerRepository.RefreshTagXIRR();
        }
        public DealDataContract SaveJSONDeal(DealDataContract _dealDC, string UserID)
        {
            DealDataContract dealdc = _dySizerRepository.SaveJSONDeal(_dealDC, UserID);
            return dealdc;
        }

        public List<LiborScheduleTab> GetLiborRateForVSTO(string CRENoteID, string ScenarioText, DateTime closingdate)
        {
            return _dySizerRepository.GetLiborRateForVSTO(CRENoteID, ScenarioText, closingdate);
        }
        public ScenarioParameterDataContract GetScenarioParameters(string scenariotext)
        {
            return _dySizerRepository.GetScenarioParameters(scenariotext);
        }
        public String CheckPermssionAndDuplicateDeal(string dealID, string dealname, string username, string Password)
        {
            return _dySizerRepository.CheckPermssionAndDuplicateDeal(dealID, dealname, username, Password);
        }
        public void SaveNoteFunding(List<PayruleTargetNoteFundingScheduleDataContract> NotefundingList, string UserID)
        {
            _dySizerRepository.SaveNoteFunding(NotefundingList, UserID);
        }
        public int? AddGenericEntity(List<GenericEntityDataContract> dcGenericEntity, string UserID)
        {
            return _dySizerRepository.AddGenericEntity(dcGenericEntity, UserID);
        }
        public int? AddTagXIRREntity(List<TagXIRREntityDataContract> dcTagXIRREntity, string UserID)
        {
            return _dySizerRepository.AddTagXIRREntity(dcTagXIRREntity, UserID);
        }

        public List<string> GetNamedRangeUsedInBatchUpload()
        {
            return _dySizerRepository.GetNamedRangeUsedInBatchUpload();
        }
        public DataTable GetBatchUploadSummary(int? batchid)
        {
            return _dySizerRepository.GetBatchUploadSummary(batchid);
        }
        public DataTable GetBatchUploadSummaryTagXIRR(int? batchId)
        {
            return _dySizerRepository.GetBatchUploadSummaryTagXIRR(batchId);
        }

            public void OpenClosePeriodForManualTransaction(int? batchid,string UserID)
        {
            _dySizerRepository.OpenClosePeriodForManualTransaction(batchid, UserID);
        }
        


        public DataTable GetBatchUploadSummaryInvoices(int? batchid)
        {
            return _dySizerRepository.GetBatchUploadSummaryInvoices(batchid);
        }


        public DataTable GetNotesWithPikData(int? batchid)
        {
            return _dySizerRepository.GetNotesWithPikData(batchid);
        }

        public DataTable GetPikPaidTransactionByCREnoteID(string crenoteid)
        {
            return _dySizerRepository.GetPikPaidTransactionByCREnoteID(crenoteid);
        }

        public DataTable GetNoteForcalcByBatchID(int? batchid)
        {
            return _dySizerRepository.GetNoteForcalcByBatchID(batchid);
        }

        public string CreateNewBatch(string username)
        {
            return _dySizerRepository.CreateNewBatch(username);
        }

        public int InsertBatchIntoDetail(int batchid, string notid, string SizerScenario)
        {
            return _dySizerRepository.InsertBatchIntoDetail(batchid, notid, SizerScenario);
        }
        public void UpdateNoteStatusAndTime(int batchid, string notid, int BatchDetailAsyncCalcVSTOID)
        {
            _dySizerRepository.UpdateNoteStatusAndTime(batchid, notid, BatchDetailAsyncCalcVSTOID);
        }
        public void InsertNotePeriodicCalcVSTO(List<NotePeriodicOutputsDataContract> _notePeriodicOutputsDC, string username, string CREnoteid, int batchid, string scenario)
        {
            _dySizerRepository.InsertNotePeriodicCalcVSTO(_notePeriodicOutputsDC, username, CREnoteid, batchid, scenario);
        }
        public void InsertTransactionVSTO(List<TransactionEntry> _lsttransactionEntryDC, string CRENoteId, int batchDetailID, string scenario, string notename)
        {
            _dySizerRepository.InsertTransactionVSTO(_lsttransactionEntryDC, CRENoteId, batchDetailID, scenario, notename);
        }

        public GenericVSTOResult CheckCalculationStatus(int batchid)
        {
            return _dySizerRepository.CheckCalculationStatus(batchid);
        }

        public List<TransactionEntryVSTO> GetTransactionEntryByBatchID(int batchID)
        {
            return _dySizerRepository.GetTransactionEntryByBatchID(batchID);
        }

        public List<PeriodicCashflowVSTO> GetNotePeriodicCalcByNoteId(int batchID)
        {
            return _dySizerRepository.GetNotePeriodicCalcByNoteId(batchID);
        }
        public DataTable GetXIRROutputByBatchID(int batchID)
        {
            return _dySizerRepository.GetXIRROutputByBatchID(batchID);
        }

        public string CheckDuplicateDealSettlement(String Credealid, string DealName, string Username, string Password)
        {
            return _dySizerRepository.CheckDuplicateDealSettlement(Credealid, DealName, Username, Password);
        }

        public string CheckDuplicateNoteSettlement(String Credealid, string CRENoteID)
        {
            return _dySizerRepository.CheckDuplicateNoteSettlement(Credealid, CRENoteID);
        }

        public DataTable CalculateXIRRAfterDealSave_FromSizer(String Credealid, string username) 
        {
            return _dySizerRepository.CalculateXIRRAfterDealSave_FromSizer(Credealid, username);
        }

    }
}
