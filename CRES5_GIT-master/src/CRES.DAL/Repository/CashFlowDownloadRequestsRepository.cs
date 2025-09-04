using CRES.DAL.IRepository;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Text;
using CRES.Utilities;

namespace CRES.DAL.Repository
{
    public class CashFlowDownloadRequestsRepository : ICashFlowDownloadRequestsRepository
    {
        public int InsertIntoCashFlowDownloadRequests(string AnalysisID,string UserName)
        {
            int CashFlowDownloadRequestsID = 0;
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserName", Value = UserName };
                SqlParameter[] sqlparam = new SqlParameter[] { p1,p2 };
                dt = hp.ExecDataTable("usp_InsertIntoCashFlowDownloadRequests", sqlparam);
                foreach (DataRow dr in dt.Rows)
                {
                    CashFlowDownloadRequestsID = CommonHelper.ToInt32_NotNullable(dr["CashFlowDownloadRequestsID"]);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return CashFlowDownloadRequestsID;
        }

        public void UpdateStatusCashFlowDownloadRequests(string AnalysisID, int CashFlowDownloadRequestsID, string StatusText, string ColumnName, string ErrorMessage, string UserName)
        {
            try
            {
                var res = 0;
                Helper.Helper hp = new Helper.Helper();

                SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@CashFlowDownloadRequestsID", Value = CashFlowDownloadRequestsID };                
                SqlParameter p3 = new SqlParameter { ParameterName = "@StatusText", Value = StatusText.ToString() };
                SqlParameter p4 = new SqlParameter { ParameterName = "@ColumnName", Value = ColumnName.ToString() };
                SqlParameter p5 = new SqlParameter { ParameterName = "@ErrorMessage", Value = ErrorMessage.ToString() };
                SqlParameter p6 = new SqlParameter { ParameterName = "@UserName", Value = UserName.ToString() };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3,p4, p5, p6 };
                hp.ExecDataTablewithparams("dbo.usp_UpdateStatusCashFlowDownloadRequests", sqlparam);

            }
            catch (Exception ex)
            {

                throw;
            }
        }

    }
}
