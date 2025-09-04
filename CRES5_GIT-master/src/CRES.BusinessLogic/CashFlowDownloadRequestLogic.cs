using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace CRES.BusinessLogic
{
    public class CashFlowDownloadRequestLogic
    {
        CashFlowDownloadRequestsRepository repo = new CashFlowDownloadRequestsRepository();

        public int InsertIntoCashFlowDownloadRequests(string AnalysisID, string UserName)
        {
            return repo.InsertIntoCashFlowDownloadRequests(AnalysisID, UserName);
        }
        public void UpdateStatusCashFlowDownloadRequests(string AnalysisID, int CashFlowDownloadRequestsID, string StatusText, string ColumnName, string ErrorMessage, string UserName)
        {
            repo.UpdateStatusCashFlowDownloadRequests(AnalysisID, CashFlowDownloadRequestsID, StatusText, ColumnName, ErrorMessage, UserName);
        }
    }
}
