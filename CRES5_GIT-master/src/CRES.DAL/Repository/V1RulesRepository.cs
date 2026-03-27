using System;
using System.Collections.Generic;
using System.Text;
using CRES.DataContract;
using CRES.DAL.IRepository;
using System.Data.SqlClient;
using System.Data;
using CRES.Utilities;
namespace CRES.DAL.Repository
{
    public class V1RulesRepository : IV1RulesRepository
    {
        public void InsertUpdateRuleTypeData(DataTable rulesdata, string CreatedBy)
        {
            try
            {
                foreach (DataRow row in rulesdata.Rows)
                {
                    row["Content"] = "";
                }

                Helper.Helper hp = new Helper.Helper();

                rulesdata.Columns["RuleTypeMasterID"].SetOrdinal(0);
                rulesdata.Columns["RuleTypeName"].SetOrdinal(1);
                rulesdata.Columns["Comments"].SetOrdinal(2);
                rulesdata.Columns["RuleTypeDetailID"].SetOrdinal(3);
                rulesdata.Columns["FileName"].SetOrdinal(4);
                rulesdata.Columns["DBFileName"].SetOrdinal(5);
                rulesdata.Columns["Content"].SetOrdinal(6);
                rulesdata.Columns["IsBalanceAware"].SetOrdinal(7);
                rulesdata.Columns["Type"].SetOrdinal(8);

                if (rulesdata.Rows.Count > 0)
                {
                    SqlParameter p1 = new SqlParameter { ParameterName = "@tblRuleType_V1", Value = rulesdata };
                    SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = CreatedBy };
                    SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                    hp.ExecDataTablewithparams("dbo.usp_InsertUpdateRuleTypeData", sqlparam);
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }


    }
}
