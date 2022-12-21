using CRES.DAL.IRepository;
using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace CRES.DAL.Repository
{
    public class PeriodicRepository : IPeriodicRepository
    {

        //private string connstring = ConfigurationManager.ConnectionStrings["LoggingInDB"].ToString();
        //SqlConnection connection = new SqlConnection();
        public List<PeriodicDataContract> GetPeriodicCloseByUserID(Guid? userID, Guid? AnalysisID)
        {

            List<PeriodicDataContract> lstPeriodicDC = new List<PeriodicDataContract>();
            DataTable dt = new DataTable();


            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetPeriodicCloseByUserID", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                PeriodicDataContract _periodicdc = new PeriodicDataContract();
                _periodicdc.StartDate = CommonHelper.ToDateTime(dr["StartDate"]);
                _periodicdc.EndDate = CommonHelper.ToDateTime(dr["EndDate"]);
                _periodicdc.CreatedBy = Convert.ToString(dr["UserName"]);
                _periodicdc.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);

                _periodicdc.MaxEndDate = CommonHelper.ToDateTime(dr["MaxEndDate"]);
                _periodicdc.PeriodAutoID = CommonHelper.ToInt32(dr["PeriodAutoID"]);
                if (Convert.ToString(dr["AnalysisID"]) != "")
                {
                    _periodicdc.AnalysisID = new Guid(Convert.ToString(dr["AnalysisID"]));
                }
                if (Convert.ToString(dr["PeriodID"]) != "")
                {
                    _periodicdc.PeriodID = new Guid(Convert.ToString(dr["PeriodID"]));
                }

                lstPeriodicDC.Add(_periodicdc);
            }

            return lstPeriodicDC;
        }

        public Guid? SavePeriodicClose(DateTime? StartDate, DateTime? EndDate, string AzureBlobLink, Guid? userID, Guid? AnalysisID)
        {
            Guid? PeriodId;
            DataTable ret_dt = new DataTable();
#pragma warning disable CS0219 // The variable 'dt' is assigned but its value is never used
            DateTime dt = new DateTime();
#pragma warning restore CS0219 // The variable 'dt' is assigned but its value is never used
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@StartDate", Value = StartDate };
            SqlParameter p2 = new SqlParameter { ParameterName = "@EndDate", Value = EndDate };
            SqlParameter p3 = new SqlParameter { ParameterName = "@AzureBlobLink", Value = AzureBlobLink };
            SqlParameter p4 = new SqlParameter { ParameterName = "@UserID", Value = userID.ToString() };
            SqlParameter p5 = new SqlParameter { ParameterName = "@AnalysisID", Value = @AnalysisID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };

            ret_dt = hp.ExecDataTable("dbo.usp_SavePeriodicClose", sqlparam);
            PeriodId = new Guid(ret_dt.Rows[0]["PeriodID"].ToString());

            return PeriodId;
        }



        public void ImportIntoPeriodCloseArchive(DateTime? StartDate, DateTime? EndDate, Guid? PeriodId, Guid? userID, Guid? AnalysisID)
        {

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@StartDate", Value = StartDate };
            SqlParameter p2 = new SqlParameter { ParameterName = "@EndDate", Value = EndDate };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PeriodID", Value = PeriodId };
            SqlParameter p4 = new SqlParameter { ParameterName = "@UserID", Value = userID.ToString() };
            SqlParameter p5 = new SqlParameter { ParameterName = "@AnalysisID", Value = @AnalysisID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };

            var result = hp.ExecNonquery("dbo.usp_ImportIntoPeriodCloseArchive", sqlparam);

            // var result = dbContext.usp_ImportIntoPeriodCloseArchive(StartDate, EndDate, PeriodId, userID.ToString(), AnalysisID);

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
        public void OpenPeriodicClose(Guid? userID, PeriodicDataContract _periodicDC)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userID.ToString() };
            SqlParameter p2 = new SqlParameter { ParameterName = "@PeriodIDs", Value = _periodicDC.PeriodIDs };
            SqlParameter p3 = new SqlParameter { ParameterName = "@AnalysisID", Value = _periodicDC.AnalysisID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            hp.ExecNonquery("dbo.usp_OpenPeriodicClose", sqlparam);

        }

        public void DeleteTagMasterTransactionEntryClose(Guid? userID, PeriodicDataContract _periodicDC)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userID.ToString() };
            SqlParameter p2 = new SqlParameter { ParameterName = "@PeriodIDs", Value = _periodicDC.PeriodIDs };
            SqlParameter p3 = new SqlParameter { ParameterName = "@AnalysisID", Value = _periodicDC.AnalysisID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            hp.ExecNonquery("dbo.usp_DeleteTagMasterTransactionEntryClose", sqlparam);

        }
    }
}
