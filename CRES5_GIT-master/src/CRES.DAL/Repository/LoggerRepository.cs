using CRES.DAL.IRepository;
using CRES.DataContract;
using System;
using System.Data;
using System.Data.SqlClient;

namespace CRES.DAL.Repository
{
    public class LoggerRepository : ILoggerRepository
    {
        public void InsertLog(LoggerDataContract ldc)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@Severity", Value = ldc.Severity };
                SqlParameter p2 = new SqlParameter { ParameterName = "@Module", Value = ldc.Module };
                SqlParameter p3 = new SqlParameter { ParameterName = "@Message", Value = ldc.Message };
                SqlParameter p4 = new SqlParameter { ParameterName = "@Message_StackTrace", Value = ldc.Message_StackTrace };
                SqlParameter p5 = new SqlParameter { ParameterName = "@Priority", Value = ldc.Priority };
                SqlParameter p6 = new SqlParameter { ParameterName = "@ExceptionSource", Value = ldc.ExceptionSource };
                SqlParameter p7 = new SqlParameter { ParameterName = "@MethodName", Value = ldc.MethodName };
                SqlParameter p8 = new SqlParameter { ParameterName = "@RequestText", Value = ldc.RequestText };
                SqlParameter p9 = new SqlParameter { ParameterName = "@ObjectID", Value = ldc.ObjectID };
                SqlParameter p10 = new SqlParameter { ParameterName = "@CreatedBy", Value = ldc.CreatedBy };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10 };
                hp.ExecDataTable("usp_InsertIntoLogger", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public bool GetAllowLoggingValue()
        {
            bool allow = false;
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {

                DataTable dt = new DataTable();
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("dbo.usp_GetCollectCalculatorLogsValue");

                if (dt != null && dt.Rows.Count > 0)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        if (Convert.ToString(dr["Value"]) == "1")
                        {
                            allow = true;
                        }
                        else
                        {
                            allow = false;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                allow = false;
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used

            return allow;
        }
    }
}
