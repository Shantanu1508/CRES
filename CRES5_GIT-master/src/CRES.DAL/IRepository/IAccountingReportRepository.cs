using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;

namespace CRES.DAL.IRepository
{
    public interface IAccountingReportRepository
    {
        List<ReportFileDataContract> GetAllReportFiles(Guid? userId, int? pageSize, int? pageIndex, out int? TotalCount);
        ReportFileDataContract GetReportFileByGUID(Guid? ReportFileGUID, Guid? UserID);
        DataSet GetReportDataFromSource(ReportFileSheetDataContract ReportDc);
        string InsertReportFileLog(ReportFileLogDataContract _reportDC);
        List<ReportFileLogDataContract> GetAllReportFileLogByObjectId(ReportFileLogDataContract _documentDC, Guid? userID, int? pgeIndex, int? pageSize, out int? TotalCount);
        void UpdateReportLogStatus(List<ReportFileLogDataContract> _docDC, Guid? userID);

        //===================Added Getwarehouse====================================//
        List<DWStatusDataContract> GetwarehouseStatus(string btnname);
    }
}

//================================================================================================/