using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
namespace CRES.DAL.Repository
{
    public class LookupRepository : ILookupRepository
    {
        public List<LookupDataContract> GetAllLookup(string lookupsIDs)
        {
            DataTable dt = new DataTable();
            List<string> arrLook = new List<string>(lookupsIDs.Split(','));
            List<LookupDataContract> lstLookUpDC = new List<LookupDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@Name", Value = null };
            SqlParameter p2 = new SqlParameter { ParameterName = "@ParentID", Value = null };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetLookupByNameAndParentID", sqlparam);

            List<Lookup> lstLookup = new List<Lookup>();

            foreach (DataRow dr in dt.Rows)
            {
                LookupDataContract _lstLookUp = new LookupDataContract();
                _lstLookUp.LookupID = CommonHelper.ToInt16_NotNullable(dr["LookupID"]);
                _lstLookUp.Name = Convert.ToString(dr["Name"]);
                _lstLookUp.Value = Convert.ToString(dr["Value"]);
                _lstLookUp.StatusID = CommonHelper.ToInt32_NotNullable(dr["StatusID"]); ;
                _lstLookUp.ParentID = CommonHelper.ToInt32_NotNullable(dr["ParentID"]); ;
                _lstLookUp.SortOrder = Convert.ToInt16(dr["SortOrder"]);
                lstLookUpDC.Add(_lstLookUp);
            }
            lstLookUpDC = lstLookUpDC.Where(x => arrLook.Contains(x.ParentID.ToString())).ToList();
            return lstLookUpDC;
        }
    }
}
