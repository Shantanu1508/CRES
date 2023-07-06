using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace CRES.BusinessLogic
{
    public class AccountingReportLogic
    {
        private AccountingReportRepository _reportRepository = new AccountingReportRepository();

        public List<ReportFileDataContract> GetAllReportFiles(Guid? UserID, int? pageSize, int? pageIndex, out int? TotalCount)
        {
            List<ReportFileDataContract> lstReportFiles = new List<ReportFileDataContract>();
            lstReportFiles = _reportRepository.GetAllReportFiles(UserID, pageSize, pageIndex, out TotalCount).ToList();
            return lstReportFiles;
        }
        public ReportFileDataContract GetReportFileByGUID(Guid? ReportFileGUID, Guid? UserID)
        {
            ReportFileDataContract ReportFileDC = new ReportFileDataContract();
            ReportFileDC = _reportRepository.GetReportFileByGUID(ReportFileGUID, UserID);
            return ReportFileDC;
        }

        public DataSet GetReportDataFromSource(ReportFileSheetDataContract ReportDc)
        {
            return _reportRepository.GetReportDataFromSource(ReportDc);
        }
        public string InsertReportFileLog(ReportFileLogDataContract ReportDc)
        {
            return _reportRepository.InsertReportFileLog(ReportDc);
        }
        public List<ReportFileLogDataContract> GetAllReportFileLogByObjectId(ReportFileLogDataContract _documentDC, Guid? userID, int? pgeIndex, int? pageSize, out int? TotalCount)
        {
            List<ReportFileLogDataContract> lstDocuments = new List<ReportFileLogDataContract>();
            lstDocuments = _reportRepository.GetAllReportFileLogByObjectId(_documentDC, userID, pgeIndex, pageSize, out TotalCount);
            return lstDocuments;
        }
        public void UpdateReportLogStatus(List<ReportFileLogDataContract> _docDC, Guid? userID)
        {
            _reportRepository.UpdateReportLogStatus(_docDC, userID);
        }

        //==========Added getwarehouseStatus==========//
        public List<DWStatusDataContract> GetwarehouseStatus(string btnname)
        {
            List<DWStatusDataContract> lstStatus = new List<DWStatusDataContract>();
            lstStatus = _reportRepository.GetwarehouseStatus(btnname).ToList();
            return lstStatus;
        }
    }
}
