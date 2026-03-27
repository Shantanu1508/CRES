using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DataContract;
using CRES.DAL.IRepository;
using System.Data;
using System.Data.SqlClient;

namespace CRES.DAL.Repository
{
    public class DashBoardRepository
    {
        public List<DashBoardDataContract> GetDashBoardByUserID(Guid? UserID)
        {           
            List<DashBoardDataContract> _dashBoardDataContractlst = new List<DashBoardDataContract>();


            DataTable dt = new DataTable();


            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
         
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("CRE.usp_GetDashBoardByUserID", sqlparam);
            //  var dashboardList = dbContext.usp_GetDashBoardByUserID(UserID);

            foreach (DataRow dr in dt.Rows)
            {
                DashBoardDataContract _dashBoardDataContract = new DashBoardDataContract();
                _dashBoardDataContract.Value1 = Convert.ToString(dr["Value1"]); 
               _dashBoardDataContract.Value2 = Convert.ToString(dr["Value2"]); 
                _dashBoardDataContract.Module= Convert.ToString(dr["Module"]); 
                _dashBoardDataContract.ValueID = Convert.ToString(dr["ValueID"]);  


                _dashBoardDataContractlst.Add(_dashBoardDataContract);
            }

            return _dashBoardDataContractlst;
        }


        public DataTable GetDashBoardData()
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            try
            {
                dt = hp.ExecDataTable("[DBO].[usp_GetDashBoardData]");
                return dt;
            }
            catch (Exception ex)
            {

                throw;
            }

        }

        public DataTable GetBookMarkedDeals(string UserID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserId ", Value = UserID };
            try
            {
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("[DBO].[usp_GetDashBoardData]", sqlparam);
                return dt;
            }
            catch (Exception ex)
            {
                throw;
            }

        }

        public void InsertUpdateBookMark(string UserID, Guid? AccountID, string IsBookMark)
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserId ", Value = UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AccountId ", Value = AccountID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@IsBookMark ", Value = IsBookMark };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                dt = hp.ExecDataTable("dbo.usp_InsertUpdateBookMark", sqlparam);
            }
            catch (Exception ex)
            {
                var exception = ex.Message;
            }
        }
    }
}
