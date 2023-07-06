using CRES.DAL.IRepository;
using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace CRES.DAL.Repository
{
    public class PayruleSetupRepository : IPayruleSetupRepository
    {


        public List<PayruleSetupDataContract> GetNoteDependentsByNoteID(string noteid)
        {

            List<PayruleSetupDataContract> _notedependendent = new List<PayruleSetupDataContract>();
            DataTable dt = new DataTable();

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = noteid };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetNoteDependents", sqlparam);

            // var CashflowsExportDataList = _dbContext.usp_GetNoteDependents(noteid);

            foreach (DataRow dr in dt.Rows)
            {
                PayruleSetupDataContract psd = new PayruleSetupDataContract();

                psd.Amount = CommonHelper.ToDecimal(dr["Value"]);
                psd.StripTransferFrom = Convert.ToString(dr["StripTransferFrom"]);
                psd.StripTransferTo = Convert.ToString(dr["StripTransferTo"]);
                psd.RuleID = CommonHelper.ToInt32(dr["LookupID"]);
                psd.RuleIDText = Convert.ToString(dr["name"]);
                psd.Value = CommonHelper.ToDecimal(dr["Value"]);
                _notedependendent.Add(psd);
            }

            return _notedependendent;
        }

        public void InsertUpdatePayruleDistributions(string sourcenoteid, string updatedby, Guid? AnalysisID)
        {
            try
            {

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@SourceNoteID", Value = sourcenoteid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UpdatedBy", Value = updatedby };
                SqlParameter p3 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                hp.ExecNonquery("dbo.usp_InsertUpdatePayruleDistributions", sqlparam);


            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetNotePayruleSetupDataByDealID(Guid? dealID)
        {
            //string connection = ConfigurationManager.ConnectionStrings["myConnectionString"].ConnectionString;
            //SqlConnection conn = new SqlConnection(connection);

            DataTable dt = new DataTable();

#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = dealID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetNotePayruleSetupDataByDealID", sqlparam);
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used

            return dt;
        }

        public void InsertIntoPayruleSetup(List<PayruleSetupDataContract> list, string username, string DealID)
        {

#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dNote = new DataTable();
                dNote.Columns.Add("DealID");
                dNote.Columns.Add("StripTransferFrom");
                dNote.Columns.Add("StripTransferTo");
                dNote.Columns.Add("Value");
                dNote.Columns.Add("RuleID");
                if (list != null)
                {
                    DataTable dt = new DataTable();
                    dt = ObjToDataTable.ToDataTable(list);
                    foreach (DataRow dr in dt.Rows)
                    {
                        dNote.ImportRow(dr);
                    }
                }

                hp.InsertUpdatePayruleSetup(dNote, username, DealID, "PayruleSetup");


            }
            catch (Exception ex)
            {
                throw;

            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used


        }
    }
}