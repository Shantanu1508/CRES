using CRES.DAL.IRepository;
using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace CRES.DAL.Repository
{
    public class JournalLedgerRepository : IJournalLedgerRepository
    {
        public string InsertUpdateJournalEntry(List<JournalLedgerDataContract> JournalEntry, string userid, int? Id, DateTime? Date, string Comment)
        {
            string JournalEntryMasterGUID = "";
            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable JournalEntryData = new DataTable();
                JournalEntryData.Columns.Add("JournalEntryMasterId");
                JournalEntryData.Columns.Add("DebtEquityAccountID");
                JournalEntryData.Columns.Add("TransactionDate");
                JournalEntryData.Columns.Add("TransactionTypeText");
                JournalEntryData.Columns.Add("TransactionAmount");
                JournalEntryData.Columns.Add("CommentsDetail");
                JournalEntryData.Columns.Add("TransactionEntryID");
                if (JournalEntry != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(JournalEntry);

                    foreach (DataRow dr in dt.Rows)
                    {
                        JournalEntryData.ImportRow(dr);
                    }
                }

                if (JournalEntryData.Rows.Count > 0)
                {
                    JournalEntryMasterGUID =  hp.ExecDataTablewithtableJournalEntry("dbo.usp_InsertUpdateJournalEntry", JournalEntryData, "tbljournalentry", userid, Id, Date, Comment);
                    
                }
            }
            catch (Exception)
            {

                throw;
            }
            return JournalEntryMasterGUID;
        }

        public List<JournalLedgerDataContract> GetJournalEntryByJournalEntryMasterGUID(Guid JournalEntryMasterGUID)
        {
            List<JournalLedgerDataContract> ListJournalEntry = new List<JournalLedgerDataContract>();
            DataTable dt = new DataTable();
            try
            {

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@JournalEntryMasterGUID", Value = JournalEntryMasterGUID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetJournalEntryByJournalEntryMasterGuid", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    JournalLedgerDataContract jldc = new JournalLedgerDataContract();
                    jldc.JournalEntryMasterGUID = new Guid(Convert.ToString(dr["JournalEntryMasterGUID"]));
                    jldc.TransactionEntryID = CommonHelper.ToInt32(dr["TransactionEntryID"]);
                    jldc.JournalEntryMasterID = CommonHelper.ToInt32(dr["JournalEntryMasterID"]);
                    jldc.JournalEntryDate = CommonHelper.ToDateTime(dr["JournalEntryDate"]);
                    jldc.Comments = Convert.ToString(dr["Comment"]);
                    jldc.DebtEquityAccountID = new Guid(Convert.ToString(dr["AccountId"]));
                    jldc.TransactionDate = CommonHelper.ToDateTime(dr["Date"]);
                    jldc.TransactionTypeText = Convert.ToString(dr["Type"]);
                    jldc.TransactionAmount = CommonHelper.ToInt32(dr["Amount"]);
                    jldc.CommentsDetail = Convert.ToString(dr["CommentDetail"]);
                    jldc.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                    jldc.UpdatedByText = Convert.ToString(dr["UpdatedByText"]);
                    
                    jldc.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    ListJournalEntry.Add(jldc);
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
            return ListJournalEntry;

        }

        public List<JournalLedgerDataContract> GetJournalEntryByDebtEquityAccountID(Guid? DebtEquityAccountID)
        {
            List<JournalLedgerDataContract> ListJournalEntry = new List<JournalLedgerDataContract>();
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DebtEquityAccountId", Value = DebtEquityAccountID };
                SqlParameter[] sqlparam = new SqlParameter[] {p1};
                dt = hp.ExecDataTable("usp_GetJournalEntryByDebtEquityAccountId", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    JournalLedgerDataContract jldc = new JournalLedgerDataContract();
                    jldc.JournalEntryMasterGUID = new Guid(Convert.ToString(dr["JournalEntryMasterGUID"]));
                    jldc.TransactionEntryID = CommonHelper.ToInt32(dr["TransactionEntryID"]);
                    jldc.JournalEntryMasterID = CommonHelper.ToInt32(dr["JournalEntryMasterID"]);
                    jldc.JournalEntryDate = CommonHelper.ToDateTime(dr["JournalEntryDate"]);
                    jldc.Comments = Convert.ToString(dr["Comment"]);
                    jldc.DebtEquityAccountID = new Guid(Convert.ToString(dr["AccountId"]));
                    jldc.TransactionDate = CommonHelper.ToDateTime(dr["Date"]);
                    jldc.TransactionTypeText = Convert.ToString(dr["Type"]);
                    jldc.TransactionAmount = CommonHelper.ToInt32(dr["Amount"]);
                    jldc.CommentsDetail = Convert.ToString(dr["CommentDetail"]);
                    jldc.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                    jldc.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    ListJournalEntry.Add(jldc);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return ListJournalEntry;
        }
    }
}
