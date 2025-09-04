using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;

namespace CRES.DAL.IRepository
{
    public interface ICashFlowDownloadRequestsRepository
    {
        int InsertIntoCashFlowDownloadRequests(string AnalysisID, string UserName);
        void UpdateStatusCashFlowDownloadRequests(string AnalysisID, int CashFlowDownloadRequestsID, string StatusText, string ColumnName, string ErrorMessage, string UserName);
    }
}
