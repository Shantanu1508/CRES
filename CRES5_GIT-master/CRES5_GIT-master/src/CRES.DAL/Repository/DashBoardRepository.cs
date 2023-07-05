using CRES.DataContract;
using System;
using System.Collections.Generic;
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
                _dashBoardDataContract.Module = Convert.ToString(dr["Module"]);
                _dashBoardDataContract.ValueID = Convert.ToString(dr["ValueID"]);


                _dashBoardDataContractlst.Add(_dashBoardDataContract);
            }

            return _dashBoardDataContractlst;
        }
    }
}
