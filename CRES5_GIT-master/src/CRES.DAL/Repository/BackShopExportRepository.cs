using CRES.DAL.IRepository;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace CRES.DAL.Repository
{
    public class BackShopExportRepository : IBackShopExportRepository
    {
        public DataTable ExportFFandPIKgetrecordsforJson(string DealID,string NoteID,string userName,string flag)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();

            SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@NoteID", Value = NoteID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@userName", Value = userName };
            SqlParameter p4 = new SqlParameter { ParameterName = "@flag", Value = flag };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            dt = hp.ExecDataTable("dbo.usp_ExportFFandPIKgetrecordsforJson", sqlparam);            

            return dt;
        }
        public void ExportFFandPIKUpdateStatus(string DealID, string NoteID, string Status ,string userName, string UpdateFor)
        {
            
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@NoteID", Value = NoteID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@Status", Value = Status };
            SqlParameter p4 = new SqlParameter { ParameterName = "@userName", Value = userName };
            SqlParameter p5 = new SqlParameter { ParameterName = "@UpdateFor", Value = UpdateFor };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4,p5 };
             hp.ExecNonquery("dbo.usp_ExportFFandPIKUpdateStatus", sqlparam);             

        }

        public void VerifyFutureFundingM61andBackshop(string DealID, string NoteID, string userName, string verificationFor)
        {

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@noteid", Value = NoteID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@userID", Value = userName };
            SqlParameter p4 = new SqlParameter { ParameterName = "@verificationFor", Value = verificationFor };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            hp.ExecNonquery("dbo.usp_VerifyFutureFundingM61andBackshop_ByDealID", sqlparam);

        }

        public void ExportPIKPrincipalFromCRES_API(string CRENoteID, string CreatedBy)
        {

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = CRENoteID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };
            SqlParameter p3 = new SqlParameter { ParameterName = "@UpdatedBy", Value = CreatedBy };
     

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3};
            hp.ExecNonquery("dbo.usp_ExportPIKPrincipalFromCRES_API", sqlparam);

        }
    }
}
