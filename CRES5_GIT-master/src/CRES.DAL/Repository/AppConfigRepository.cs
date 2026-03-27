using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DataContract;
using CRES.DAL.IRepository;
using System.Data.SqlClient;
using System.Data;
using CRES.Utilities;

namespace CRES.DAL.Repository
{
    public class AppConfigRepository :  IAppConfigRepository
    {
        public List<AppConfigDataContract> GetAppConfigByKey(Guid? userId, string KeyName)
        {
            DataTable dt = new DataTable();

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@userId", Value = userId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@Key", Value = KeyName };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("App.usp_GetAppConfigByKey", sqlparam);
            
            List<AppConfigDataContract> lstAppConfig = new List<AppConfigDataContract>();
            lstAppConfig = dt.DataTableToList<AppConfigDataContract>();
            
            return lstAppConfig;
        }

        public int UpdateAppConfigByKey(Guid? userId, AppConfigDataContract _appconfigdatacontract)
        {

            DataTable dt = new DataTable();

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@userId", Value = userId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@Key", Value = _appconfigdatacontract.Key };
            SqlParameter p3 = new SqlParameter { ParameterName = "@Value", Value = _appconfigdatacontract.Value };
            SqlParameter p4 = new SqlParameter { ParameterName = "@UpdatedBy", Value = _appconfigdatacontract.UpdatedBy };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2,p3,p4 };
            hp.ExecNonquery("App.usp_UpdateAppConfigByKey", sqlparam);
            return 1;
        }


        public List<AppConfigDataContract> GetAllAppConfig(Guid? userId)
        {
            List<AppConfigDataContract> lstAppConfig = new List<AppConfigDataContract>();
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@userId", Value = userId };
            SqlParameter[] sqlparam = new SqlParameter[] { p1};
            dt = hp.ExecDataTable("App.usp_GetAppConfig", sqlparam);
           
            foreach (DataRow dr in dt.Rows)
            {
                AppConfigDataContract _appconfigdatacontract = new AppConfigDataContract();
                _appconfigdatacontract.Key = Convert.ToString(dr["Key"]);
                _appconfigdatacontract.Value = Convert.ToString(dr["Value"]);
                lstAppConfig.Add(_appconfigdatacontract);

            }
            return lstAppConfig;
        }
    }
}
