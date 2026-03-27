using CRES.DAL.IRepository;
using CRES.DAL.Helper;
using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace CRES.DAL.Repository
{
    public class PayoffRepository : IPayoffRepository
    {
        public DataSet GetPayoffAnalysisData(string DealID, DateTime PayoffDate, DateTime? ActualPayoffDate)
        {
            DataSet dspayoff = new DataSet();
            Helper.Helper hp = new Helper.Helper();

            if (!string.IsNullOrEmpty(DealID))
            {
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@PayoffDate", Value = PayoffDate };
                SqlParameter p3 = new SqlParameter { ParameterName = "@ActualPayoffDate", Value = ActualPayoffDate };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                dspayoff = hp.ExecDataSet("usp_GetPayoffStatementByDealID", sqlparam);
            }
            return dspayoff;

        }
        public int GetPayoffEmailToSendCount()
        {
            try
            {
                int count = 0;
                Helper.Helper hp = new Helper.Helper();
                count = hp.ExecuteScalar("usp_GetPayoffEmailToSendCount");
                return count;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void UpdateCalculationRequestSetIsEmailSentToYes(string CalculationRequestID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@CalculationRequestID", Value = CalculationRequestID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                hp.ExecuteScalar("usp_UpdateCalculationRequestSetIsEmailSentToYes", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public DataTable GetPayoffEmailData()
        {
            try
            {
                DataTable dt = new DataTable();
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("usp_GetPayoffEmailData");
                return dt;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}
