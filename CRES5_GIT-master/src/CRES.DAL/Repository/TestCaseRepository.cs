
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Data.SqlClient;

namespace CRES.DAL.Repository
{
    public class TestCaseRepository
    {
       
        Helper.Helper hp = new Helper.Helper();
        public DataTable RunTestCases(Boolean isRun, string userId, string ModuleName, int? PageSize, int? PageIndex)
        {
            DataTable dt = new DataTable();
           // ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
            SqlParameter p1 = new SqlParameter { ParameterName = "@IsRun", Value = isRun };
            SqlParameter p2 = new SqlParameter { ParameterName = "@userId", Value = userId };
            SqlParameter p3 = new SqlParameter { ParameterName = "@ModuleName", Value = ModuleName };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PgeIndex", Value = PageIndex };
            SqlParameter p5 = new SqlParameter { ParameterName = "@PageSize", Value = PageSize };
          // SqlParameter p6 = new SqlParameter { ParameterName = "@TotalCount",Size=4, Direction= ParameterDirection.Output, Value = totalCount };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };

            dt = hp.ExecDataTable("dbo.usp_RunTestCases", sqlparam);

            //TotalCount = Convert.ToInt16(totalCount.Value);
           
            return dt;
        }
    }
}
