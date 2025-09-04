using CRES.DAL.IRepository;
using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace CRES.DAL.Repository
{
    public class PeriodicRepository : IPeriodicRepository
    {

        public DataTable GetAllPeriodicClose(Guid? PortfolioMasterGuid)
        {
            SqlParameter p1 = new SqlParameter { ParameterName = "@PortfolioMasterGuid", Value = PortfolioMasterGuid };
            Helper.Helper hp = new Helper.Helper();
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            return hp.ExecDataTable("dbo.usp_GetAccountingClose", sqlparam);
        }
        public int SaveAccountingbyOpenDate(string DealIDs, DateTime OpenDate, string UserID, string Comments="")
        {
            
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealIDs", Value = DealIDs };
            SqlParameter p2 = new SqlParameter { ParameterName = "@OpenDate", Value = OpenDate };
            SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p4 = new SqlParameter { ParameterName = "@Comments", Value = Comments };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3,p4 };
            return hp.ExecNonquery("dbo.usp_OpenPeriod", sqlparam);
            
        }
        public int SaveAccountingbyCloseDate(string DealIDs, DateTime closedate, string UserID,string Comments="")
        {
           
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealIDs", Value = DealIDs };
            SqlParameter p2 = new SqlParameter { ParameterName = "@CloseDate", Value = closedate };
            SqlParameter p3 = new SqlParameter { ParameterName = "@AnalysisID", Value = null };
            SqlParameter p4 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p5 = new SqlParameter { ParameterName = "@Comments", Value = Comments };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4,p5 };
            return hp.ExecNonquery("dbo.usp_ClosePeriod", sqlparam);
            
        }
        public DataTable GetAccountingCloseByDealId(string DealID, string UserID, int? pageSize, int? pageIndex, out int? TotalCount)
        {
            DataTable dt = new DataTable();

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = new Guid(DealID) };
            SqlParameter p2 = new SqlParameter { ParameterName = "@PgeIndex", Value = pageIndex };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p4 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            dt= hp.ExecDataTable("dbo.usp_GetAccountingCloseByDealID", sqlparam);
            TotalCount = string.IsNullOrEmpty(Convert.ToString(p4.Value)) ? 0 : Convert.ToInt32(p4.Value);
            return dt;

        }
        public DateTime? GetLastAccountingCloseDateByDealIDORNoteID(Guid? DealID, Guid? Noteid)
        {
            DateTime? LastCLoseDate = Convert.ToDateTime("1/1/1900");
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@NoteID", Value = Noteid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetLastAccountingCloseDateByDealIDORNoteID", sqlparam);
            foreach (DataRow dr in dt.Rows)
            {
                LastCLoseDate = CommonHelper.ToDateTime(dr["LastCLoseDate"]);
            }

            if (LastCLoseDate == null || LastCLoseDate == DateTime.MinValue)
            {
                LastCLoseDate = Convert.ToDateTime("1/1/1900");
            }
            return LastCLoseDate;
        }
        public void UpdatePeriodicCloseAzureBlobLink(PeriodicDataContract _periodicDC)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = new Guid(_periodicDC.UserID) };
            SqlParameter p2 = new SqlParameter { ParameterName = "@PeriodID", Value = _periodicDC.PeriodID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@AzureBlobLink", Value = _periodicDC.AzureBlobLink };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            hp.ExecNonquery("dbo.usp_UpdatePeriodicCloseAzureBlobLink", sqlparam);
        }
        public void ImportIntoTransactionEntryClose(DateTime? StartDate, DateTime? EndDate, Guid? PeriodId, Guid? userID, Guid? TagMasterID, Guid? AnalysisID)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@StartDate", Value = StartDate };
            SqlParameter p2 = new SqlParameter { ParameterName = "@EndDate", Value = EndDate };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PeriodID", Value = PeriodId };
            SqlParameter p4 = new SqlParameter { ParameterName = "@UserID", Value = userID.ToString() };
            SqlParameter p5 = new SqlParameter { ParameterName = "@TagMasterID", Value = TagMasterID };
            SqlParameter p6 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6 };
            hp.ExecNonquery("dbo.usp_ImportIntoTransactionEntryClose", sqlparam);
        }

    }

}
