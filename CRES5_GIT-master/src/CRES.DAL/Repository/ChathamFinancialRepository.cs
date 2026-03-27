using CRES.DAL.IRepository;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Text;
using Syncfusion.DocIO.DLS;

namespace CRES.DAL.Repository
{
    public class ChathamFinancialRepository: IChathamFinancialRepository
    {
        public DataTable GetChathamConfig(string type)
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@FrequencyType", Value = type };               
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };

                dt = hp.ExecDataTable("usp_GetChathamConfig", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dt;
        }
    }
}
