using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DAL.Repository;
using CRES.DataContract;
using System.Data;

namespace CRES.BusinessLogic
{
    public class TranscationLogic
    {
        TranscationRepository _transcationRepositoryRepository = new TranscationRepository();
        public List<ServicerDataContract> GetAllServicer()
        {
            return _transcationRepositoryRepository.GetAllServicer();
        }

        public List<ServicerDataContract> GetAllServicerLiability()
        {
            return _transcationRepositoryRepository.GetAllServicerLiability();
        }

        public string BulkInsertbyServicer(DataTable dt, JsonFileConfiguration fileConf, int Servicerid, DateTime? periodCloseDate)
        {
            return _transcationRepositoryRepository.BulkInsertbyServicer(dt, fileConf, Servicerid, periodCloseDate);
        }
        //

        public int insertupdateFileBatchLog(FileBatchLogDataContract fb, string errmsg)
        {
            return _transcationRepositoryRepository.insertupdateFileBatchLog(fb, errmsg);
        }

        public void insertupdateFileBatchDetail(string userid, int BatchLogID, string ProcessName, string errmsg)
        {
            _transcationRepositoryRepository.insertupdateFileBatchDetail(userid, BatchLogID, ProcessName, errmsg);

        }
        public int insertupdateFileBatchLogLiability(FileBatchLogDataContract fb, string errmsg)
        {
            return _transcationRepositoryRepository.insertupdateFileBatchLogLiability(fb, errmsg);
        }

        public void insertupdateFileBatchDetailLiability(string userid, int BatchLogID, string ProcessName, string errmsg)
        {
            _transcationRepositoryRepository.insertupdateFileBatchDetailLiability(userid, BatchLogID, ProcessName, errmsg);

        }


        public string insertintoTranscation(string procName, int Batchlogid, string ScenarioId)
        {
            return _transcationRepositoryRepository.insertintoTranscation(procName, Batchlogid, ScenarioId);
        }


        public DataTable GetAllTranscation()
        {
            return _transcationRepositoryRepository.GetallTranscation();
        }

        public DataTable GetAllTranscationPaging(bool ShowAllTransaction, string userId, int? pageSize, int? pageIndex, out int? TotalCount)
        {
            return _transcationRepositoryRepository.GetallTranscationPaging(ShowAllTransaction, userId, pageSize, pageIndex, out TotalCount);
        }

        public DataTable GetAllTranscationLiability(bool ShowAllTransaction, string userId, int? pageSize, int? pageIndex, out int? TotalCount)
        {
            return _transcationRepositoryRepository.GetAllTranscationLiability(ShowAllTransaction, userId, pageSize, pageIndex, out TotalCount);
        }

        public DataTable GetHistoricalDataforTranscationRecon()
        {
            return _transcationRepositoryRepository.GetHistoricalDataforTranscationRecon();
        }

        public int UpdateTranscationRecon(DataTable dtTrans, string CreatedBy)
        {
            return _transcationRepositoryRepository.UpdateTranscationRecon(dtTrans, CreatedBy);
        }

        public int UpdateTranscationReconLiability(DataTable dtTrans, string CreatedBy)
        {
            return _transcationRepositoryRepository.UpdateTranscationReconLiability(dtTrans, CreatedBy);
        }


        public int SaveTranscation(DataTable dtTrans, string CreatedBy)
        {
            return _transcationRepositoryRepository.SaveTranscation(dtTrans, CreatedBy);
        }


        public DataTable FilterTranscation(string FilterStr, string headerUserID)
        {
            return _transcationRepositoryRepository.FilterTranscation(FilterStr, headerUserID);
        }

        public string UnreconcileTranscation(DataTable dtTrans, string CreatedBy)
        {
            return _transcationRepositoryRepository.UnreconcileTranscation(dtTrans, CreatedBy);
        }


        public List<TransactionAuditDataContract> GetAllTranscationAuditLog()
        {
            return _transcationRepositoryRepository.GetAllTranscationAuditLog();
        }

        public DataTable GetAllTranscationbyBatchID(int batchid)
        {
            return _transcationRepositoryRepository.GetAllTranscationbyBatchID(batchid);
        }

        public int DeleteAuditbyBatchlogId(int batchid)
        {
            return _transcationRepositoryRepository.DeleteAuditbyBatchlogId(batchid);
        }

        public DataTable GetAllTransactionsByNoteId(string TransParam)
        {
            return _transcationRepositoryRepository.GetAllTransactionsByNoteId(TransParam);
        }

        public int RefreshM61Amount(string UserId)
        {
            return _transcationRepositoryRepository.RefreshM61Amount(UserId);
        }

        public DataTable SplitFeeTransaction(DataTable dtTrans)
        {
            return _transcationRepositoryRepository.SplitFeeTransaction(dtTrans);
        }


        public int ReconcileSplitFeeTransaction(DataTable dtTrans, string CreatedBy)
        {
            return _transcationRepositoryRepository.ReconcileSplitFeeTransaction(dtTrans, CreatedBy);
        }


        public DataTable GetAllTransactionType()
        {
            return _transcationRepositoryRepository.GetAllTransactionType();
        }
        public DataSet GetServicerBalanceForServicerNotification()
        {
            return _transcationRepositoryRepository.GetServicerBalanceForServicerNotification();
        }

        public DataSet GetDiscrepancyForCalcGapBtnDefAndFullyScenario()
        {
            return _transcationRepositoryRepository.GetDiscrepancyForCalcGapBtnDefAndFullyScenario();
        }
    }
}
