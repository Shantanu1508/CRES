using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading;

namespace CRES.BusinessLogic
{
    public class CalculationManagerLogic
    {
        private CalculationManagerRespository _calculationrespository = new CalculationManagerRespository();

        public List<CalculationManagerDataContract> RefreshcalculationStatus(CalculationManagerDataContract DCcalc, Guid? UserID)
        {
            List<CalculationManagerDataContract> lstDeals = _calculationrespository.RefreshCalculationStatus(DCcalc, UserID).ToList();

            return lstDeals;
        }

        public bool QueueNotesForCalculation(List<CalculationManagerDataContract> nlist, string username, string RequestFrom = "")
        {
            Thread thread = new Thread(() => CallQueueNotesForCalculation(nlist, username, RequestFrom));
            thread.Start();

            //bool status = _calculationrespository.QueueNotesForCalculation(nlist, username);

            //return status;
            return true;
        }

        public void CallQueueNotesForCalculation(List<CalculationManagerDataContract> nlist, string username, string RequestFrom = "")
        {
            bool status = _calculationrespository.QueueNotesForCalculation(nlist, username, RequestFrom);
        }

        public List<CalculationManagerDataContract> NotesListForCalculation()
        {
            List<CalculationManagerDataContract> lstnotes = _calculationrespository.NotesListForCalculation().ToList();

            return lstnotes;
        }

        public List<CalculationManagerDataContract> NotesListForCalculationByServerIndex(int serverIndex)
        {
            List<CalculationManagerDataContract> lstnotes = _calculationrespository.NotesListForCalculationByServerIndex(serverIndex).ToList();

            return lstnotes;
        }

        public void UpdateCalculationStatusandTime(Guid calcid, string noteid, string statustext, string columnname, string errmsg)

        {
            _calculationrespository.UpdateCalculationStatusandTime(calcid, noteid, statustext, columnname, errmsg);
        }

        public DataTable GetCalculationStatus(List<CalculationManagerDataContract> lstCalcMgrDC)
        {
            return _calculationrespository.GetCalculationStatus(lstCalcMgrDC);
        }

        public int GetCalculationStatus()
        {
            return _calculationrespository.getCalcStatus();
        }

        public int getCalcStatusByServerIndex(int ServerIndex)
        {
            return _calculationrespository.getCalcStatusByServerIndex(ServerIndex);
        }

        public int GetCalcRequestCount()
        {
            return _calculationrespository.GetCalcRequestCount();
        }
        public void QueueNotesForCalculationForDuplicateTransaction()
        {
            _calculationrespository.QueueNotesForCalculationForDuplicateTransaction();
        }
        public void QueueNotesForCalculationIfDWoutofSync()
        {
            _calculationrespository.QueueNotesForCalculationIfDWoutofSync();
        }
        public void UpdateCalculationStatus(string noteid, string statustext, Guid? AnalysisID)
        {
            _calculationrespository.UpdateCalculationStatus(noteid, statustext, AnalysisID);
        }

        public void UpdateCalculationStatusForDependents(string noteid, Guid? AnalysisID)
        {
            _calculationrespository.UpdateCalculationStatusForDependents(noteid, AnalysisID);
        }
        public void AddNoteInCalculationRequestsByScenarioID(string AnalysisID, string username, string envname)
        {
            _calculationrespository.AddNoteInCalculationRequestsByScenarioID(AnalysisID, username, envname);
        }


        public void ExecuteProcedureInADay()
        {
            _calculationrespository.ExecuteProcedureInADay();
        }

        public List<BatchCalculationMasterDataContract> GetBatchCalculationLog(CalculationManagerDataContract DCcalc)
        {
            List<BatchCalculationMasterDataContract> lstlog = _calculationrespository.GetBatchCalculationLog(DCcalc).ToList();

            return lstlog;
        }

        public void CreateBatchCalculationTag()
        {
            _calculationrespository.CreateBatchCalculationTag();
        }


        public CalculatorOutputJsonInfoDataContract GetCalculatorOutputJsonInfo(Guid? CalculationRequestID, Guid? NoteId, Guid? AnalysisID, Guid? UserID)
        {
            return _calculationrespository.GetCalculatorOutputJsonInfo(CalculationRequestID, NoteId, AnalysisID, UserID);
        }

        public int InsertCalculatorOutputJsonInfo(Guid? CalculationRequestID, Guid? NoteId, Guid? AnalysisID, Guid? UserID, String FileName, string FileType)
        {

            return _calculationrespository.InsertCalculatorOutputJsonInfo(CalculationRequestID, NoteId, AnalysisID, UserID, FileName, FileType);
        }

        public string DeleteBatchCalculationRequestByAnalysisID(string AnalysisID)
        {
            return _calculationrespository.DeleteBatchCalculationRequestByAnalysisID(AnalysisID);
        }
        public void UpdateCalcStatusBYAnalysisIDAndType(string AnalysisID, string Type, Guid? UserID)
        {
            _calculationrespository.UpdateCalcStatusBYAnalysisIDAndType(AnalysisID, Type, UserID);
        }
        public DataTable CancelBatchRequestByAnalysisID(string AnalysisID)
        {
            return _calculationrespository.CancelBatchRequestByAnalysisID(AnalysisID);
        }

        public void UpdateBatchDetailWhenCancel(string AnalysisID)
        {
            _calculationrespository.UpdateBatchDetailWhenCancel(AnalysisID);
        }
        public DataTable GetCurrentoffsetbyuserID(Guid? UserID)
        {
            return _calculationrespository.GetCurrentoffsetbyuserID(UserID);
        }
        public DataTable GetTransactionCategory(Guid? UserID)
        {
            return _calculationrespository.GetTransactionCategory(UserID);
        }
        public void UpdateCalculationTimeInMinByNoteID(Guid noteid, int? CalculationTimeInMin)
        {
            _calculationrespository.UpdateCalculationTimeInMinByNoteID(noteid, CalculationTimeInMin);
        }
        public void InsertIntoCalculatorStatistics(string noteid, decimal? calctime, decimal? dbtime, decimal? totaltime, string analysisid)
        {
            _calculationrespository.InsertIntoCalculatorStatistics(noteid, calctime, dbtime, totaltime, analysisid);
        }

        public void UpdateNoteCalculatedWeightedSpread(string NoteID, decimal? WeightedSpread)
        {
            _calculationrespository.UpdateNoteCalculatedWeightedSpread(NoteID, WeightedSpread);
        }
        public DataTable GetTransactionGroup(Guid? UserID)
        {
            return _calculationrespository.GetTransactionGroup(UserID);
        }
        public void InsertUpdatedNoteWiseEndingBalance(Guid NoteID, Guid? UserID)
        {
            _calculationrespository.InsertUpdatedNoteWiseEndingBalance(NoteID, UserID);
        }

        public void CalcNetCapitalInvestedbyNoteId(string NoteID)
        {
            _calculationrespository.CalcNetCapitalInvestedbyNoteId(NoteID);
        }
        public void InsertExceptionsOfCalculatorComponent(Guid? NoteId, Guid? AnalysisID, string UserID)
        {
            _calculationrespository.InsertExceptionsOfCalculatorComponent(NoteId, AnalysisID, UserID);
        }

        public void CancelBatchCalculation(string AnalysisID, bool calledfromgobalcancel)
        {
            try
            {
                //1 ) update batch request table
                UpdateBatchDetailWhenCancel(AnalysisID);
                //2 ) update v1 notes
                DataTable dt = CancelBatchRequestByAnalysisID(AnalysisID);
                V1CalcLogic vc = new V1CalcLogic();
                if (dt.Rows.Count > 0)
                {
                    vc.CallBatchCancelAPI(dt);
                }
                if (calledfromgobalcancel == true)
                {
                    //3 ) Delete calc request
                    DeleteBatchCalculationRequestByAnalysisID(AnalysisID);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
    }
}