
using CRES.DAL.IRepository;
using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;

using System.Data.SqlClient;

namespace CRES.DAL.Repository
{
    public class FastFucntionRepository : IFastFucntionRepository
    {
        //  private CRESEntities dbContext = new CRESEntities();

        public string InsertUpdateFastFunction(FastFunctionDataContract _ffDC)
        {
            string NewFunctionID;

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@FunctionID", Value = _ffDC.FunctionID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@FunctionName", Value = _ffDC.FunctionName };
            SqlParameter p3 = new SqlParameter { ParameterName = "@FunctionType", Value = _ffDC.FunctionType, };
            SqlParameter p4 = new SqlParameter { ParameterName = "@CreatedBy", Value = _ffDC.CreatedBy };
            SqlParameter p5 = new SqlParameter { ParameterName = "@IsDefault", Value = _ffDC.IsDefault, };
            SqlParameter p6 = new SqlParameter { ParameterName = "@NewFunctionID", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6 };
            hp.ExecNonquery("dbo.usp_AddUpdateFastFunction", sqlparam);

            NewFunctionID = Convert.ToString(p6.Value);

            //if (res == 1)
            if (!string.IsNullOrEmpty(NewFunctionID))
                return NewFunctionID;
            else
                return "FALSE";
            //return res;
        }


        public List<FastFunctionDataContract> GetAllFastFunction()
        {
            DataTable dt = new DataTable();
            List<FastFunctionDataContract> lstffDC = new List<FastFunctionDataContract>();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("App.usp_GetAllFastFunction");


            foreach (DataRow dr in dt.Rows)
            {
                FastFunctionDataContract _ffDC = new FastFunctionDataContract();
                if (Convert.ToString(dr["FunctionID"]) != "")
                {
                    _ffDC.FunctionID = new Guid(Convert.ToString(dr["FunctionID"]));
                }
                _ffDC.FunctionName = Convert.ToString(dr["FunctionName"]);
                _ffDC.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                _ffDC.IsDefault = Convert.ToBoolean(dr["IsDefault"]);
                lstffDC.Add(_ffDC);
            }
            return lstffDC;
        }


        public void InsertNotePeriodicCalcDynamicColumn(string ColumnNames, string NoteiDs, string ValueStr)
        {

            SqlParameter p1 = new SqlParameter { ParameterName = "@ColumnNames", Value = ColumnNames };
            SqlParameter p2 = new SqlParameter { ParameterName = "@NoteiDs", Value = NoteiDs };
            SqlParameter p3 = new SqlParameter { ParameterName = "@Values", Value = ValueStr };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            Helper.Helper hp = new Helper.Helper();
            hp.ExecNonquery("dbo.usp_InsertNotePeriodicCalcDynamicColumn", sqlparam);
        }
        public void InsertNotePeriodicCalcDynamicColumnWithXML(string ColumnNames, string inserxml, string ValueStr)
        {
            SqlParameter p1 = new SqlParameter { ParameterName = "@ColumnNames", Value = ColumnNames };
            SqlParameter p2 = new SqlParameter { ParameterName = "@NoteiDs", Value = inserxml };
            SqlParameter p3 = new SqlParameter { ParameterName = "@Values", Value = ValueStr };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            Helper.Helper hp = new Helper.Helper();
            hp.ExecNonquery("usp_InsertNotePeriodicCalcDynamicColumnWithXML", sqlparam);

        }


    }
}
