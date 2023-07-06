

using CRES.DAL.IRepository;
using CRES.DataContract;
using CRES.Utilities;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;

namespace CRES.DAL.Repository
{
    public class DocumentRepository : IDocumentRepository
    {

        public List<DocumentDataContract> GetAllDocumentByObjectId(DocumentDataContract _documentDC, Guid? userID, int? pgeIndex, int? pageSize, out int? TotalCount)
        {
            DataTable dt = new DataTable();
            List<DocumentDataContract> lstDocumentDC = new List<DocumentDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@ObjectID", Value = _documentDC.ObjectID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@ObjectTypeID", Value = _documentDC.ObjectTypeID };
            SqlParameter p4 = new SqlParameter { ParameterName = "@currentTime", Value = _documentDC.CurrentTime };
            SqlParameter p5 = new SqlParameter { ParameterName = "@Status", Value = _documentDC.Status };
            SqlParameter p6 = new SqlParameter { ParameterName = "@PgeIndex", Value = pgeIndex };
            SqlParameter p7 = new SqlParameter { ParameterName = "@pageSize", Value = pageSize };
            SqlParameter p8 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8 };
            dt = hp.ExecDataTable("dbo.usp_GetUploadedDocumentLog", sqlparam);

            TotalCount = string.IsNullOrEmpty(Convert.ToString(p8.Value)) ? 0 : Convert.ToInt32(p8.Value);
            foreach (DataRow dr in dt.Rows)
            {
                DocumentDataContract _docdc = new DocumentDataContract();
                if (Convert.ToString(dr["UploadedDocumentLogID"]) != "")
                {
                    _docdc.UploadedDocumentLogID = new Guid(Convert.ToString(dr["UploadedDocumentLogID"]));
                }
                _docdc.FileName = Convert.ToString(dr["FileName"]);
                _docdc.OriginalFileName = Convert.ToString(dr["OriginalFileName"]);
                _docdc.UserFullName = Convert.ToString(dr["UserFullName"]);
                _docdc.DocumentType = Convert.ToString(dr["DocumentType"]);
                _docdc.UploadedTime = Convert.ToString(dr["UploadedTime"]);
                _docdc.FilePath = Convert.ToString(dr["FileName"]);
                _docdc.Comment = Convert.ToString(dr["Comment"]);
                _docdc.ObjectID = Convert.ToString(dr["ObjectID"]);
                _docdc.ObjectTypeID = Convert.ToString(dr["ObjectTypeID"]);
                _docdc.Name = Convert.ToString(dr["Name"]);
                _docdc.ObjectType = Convert.ToString(dr["ObjectType"]);
                _docdc.DocumentStorageID = Convert.ToString(dr["DocumentStorageID"]);
                _docdc.Storagetype = Convert.ToString(dr["Storagetype"]);

                lstDocumentDC.Add(_docdc);
            }

            return lstDocumentDC;
        }

        public string InsertUploadedDocumentLog(DocumentDataContract _docDC)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@CreatedBy", Value = _docDC.CreatedBy };
            SqlParameter p2 = new SqlParameter { ParameterName = "@FileName", Value = _docDC.FileName };
            SqlParameter p3 = new SqlParameter { ParameterName = "@OriginalFileName", Value = _docDC.OriginalFileName };
            SqlParameter p4 = new SqlParameter { ParameterName = "@storagetype", Value = _docDC.Storagetype };
            SqlParameter p5 = new SqlParameter { ParameterName = "@ObjectID", Value = _docDC.ObjectID };
            SqlParameter p6 = new SqlParameter { ParameterName = "@ObjectTypeID", Value = _docDC.ObjectTypeID };
            SqlParameter p7 = new SqlParameter { ParameterName = "@DocumentTypeID", Value = _docDC.DocumentTypeID };
            SqlParameter p8 = new SqlParameter { ParameterName = "@Comment", Value = _docDC.Comment };
            SqlParameter p9 = new SqlParameter { ParameterName = "@DocumentStorageID", Value = _docDC.DocumentStorageID };
            SqlParameter p10 = new SqlParameter { ParameterName = "@NewUploadedDocumentLogID", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10 };
            hp.ExecNonquery("dbo.usp_InsertUploadedDocumentLog", sqlparam);

            if (p10.Value.ToString() != "0")
                return Convert.ToString(p10.Value);
            else
                return "";
        }


        public void UpdateDocumentStatus(List<DocumentDataContract> _docDC, Guid? userID)
        {

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@XMLUploadedDocumentLogID", Value = _docDC.ToXML() };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            hp.ExecNonquery("dbo.usp_UpdateDocumentStatus", sqlparam);

            //  var res = dbContext.usp_UpdateDocumentStatus(userID.ToString(), _docDC.ToXML());
        }

        public string WellsDailyExtractBulkInsert(DataTable dt, string DestTableName)
        {
            string result = "";
            try
            {
                IConfigurationBuilder builder = new ConfigurationBuilder();
                builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
                var root = builder.Build();
                var conString = root.GetSection("Application").GetSection("ConnectionStrings").Value;
                //string conString = System.Configuration.ConfigurationManager.ConnectionStrings["LoggingInDB"].ConnectionString;

                //truncate table
                SqlConnection sqlConn = new SqlConnection(conString.ToString());
                sqlConn.Open();
                string deleteQuery = "truncate table DW.ServicingTransactionBI"; // just delete them all
                SqlCommand sqlComm = new SqlCommand(deleteQuery, sqlConn);
                sqlComm.ExecuteNonQuery();
                sqlConn.Close();

                //insert record
                SqlBulkCopy bulkcopy = new SqlBulkCopy(conString);
                bulkcopy.BulkCopyTimeout = 36000;
                bulkcopy.DestinationTableName = DestTableName;

                bulkcopy.ColumnMappings.Add("Transaction Date", "TransactionDate");
                bulkcopy.ColumnMappings.Add("Current Payment Date", "CurrentPaymentDate");
                bulkcopy.ColumnMappings.Add("Current Interest Paid To Date", "CurrentInterestPaidToDate");
                bulkcopy.ColumnMappings.Add("Current All-In Interest Rate", "CurrentAllInInterestRate");
                bulkcopy.ColumnMappings.Add("Current Interest Rate Adj Date", "CurrentInterestRateAdjDate");
                bulkcopy.ColumnMappings.Add("Beginning Balance", "BeginningBalance");
                bulkcopy.ColumnMappings.Add("Total Scheduled P&I Due", "TotalScheduledP&IDue");
                bulkcopy.ColumnMappings.Add("Schedule Principal Paid", "SchedulePrincipalPaid");
                bulkcopy.ColumnMappings.Add("Beg Bal Less PRN Payment", "BegBalLessPRNPayment");
                bulkcopy.ColumnMappings.Add("Note ID", "NoteID");
                bulkcopy.ColumnMappings.Add("Servicer ID", "ServicerID");
                bulkcopy.ColumnMappings.Add("Entry No", "EntryNo");
                bulkcopy.ColumnMappings.Add("Transaction Type", "TransactionType");
                bulkcopy.ColumnMappings.Add("Current Index Rate", "CurrentIndexRate");
                bulkcopy.ColumnMappings.Add("Date Due", "DateDue");
                bulkcopy.ColumnMappings.Add("Int Rate from Receivable", "IntRatefromReceivable");
                bulkcopy.ColumnMappings.Add("Principal", "Principal");
                bulkcopy.ColumnMappings.Add("Interest Payment", "InterestPayment");
                bulkcopy.ColumnMappings.Add("Late Charge Payment", "LateChargePayment");
                bulkcopy.ColumnMappings.Add("New Index Rate", "NewIndexRate");
                bulkcopy.ColumnMappings.Add("New Interest Rate", "NewInterestRate");
                bulkcopy.ColumnMappings.Add("Next Payment Adj Date", "NextPaymentAdjDate");
                bulkcopy.ColumnMappings.Add("Effective Date", "EffectiveDate");
                bulkcopy.ColumnMappings.Add("Transaction Amount", "TransactionAmount");
                bulkcopy.ColumnMappings.Add("Tax Escrow Amount", "TaxEscrowAmount");
                bulkcopy.ColumnMappings.Add("Insurance Escrow Amount", "InsuranceEscrowAmount");
                bulkcopy.ColumnMappings.Add("Reserve Escrow Amount", "ReserveEscrowAmount");
                bulkcopy.ColumnMappings.Add("Suspense", "Suspense");
                bulkcopy.ColumnMappings.Add("Balance after Funding Transacton", "BalanceafterFundingTransacton");
                bulkcopy.ColumnMappings.Add("Principal Write Off", "PrincipalWriteOff");
                bulkcopy.ColumnMappings.Add("Payment Status", "PaymentStatus");

                // dt.CaseSensitive = false;
                bulkcopy.WriteToServer(dt);
                result = "Success";

            }
            catch (Exception ex)
            {
                result = "Failed#" + ex.Message;
            }
            return result;

        }
        //public void SyncBoxDocument(List<DocumentDataContract> _docDC, Guid? userID, string CREDealID)
        //{
        //    var res = dbContext.usp_SyncBoxDocument(userID.ToString(), CREDealID, _docDC.ToXML().Replace(" xsi:nil=\"true\"", ""));
        //}
        public string BulkInsertForNoteMatrix(DataTable dt, JsonFileConfiguration fileConf)
        {
            string result = "";
            int totalrows = 0;
            try
            {
                IConfigurationBuilder builder = new ConfigurationBuilder();
                builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
                var root = builder.Build();
                var conString = root.GetSection("Application").GetSection("ConnectionStrings").Value;

                SqlBulkCopy bulkcopy = new SqlBulkCopy(conString);
                bulkcopy.BulkCopyTimeout = 36000;
                bulkcopy.DestinationTableName = fileConf.LandingTableName;

                //  dt = dt.Rows.Cast<DataRow>().Where(row => !row.ItemArray.All(field => field is DBNull || string.IsNullOrWhiteSpace(field as string))).CopyToDataTable();
                //Remove Blank Row
                //if (dt.Rows.Count > 0)
                //{
                //    for (int i = dt.Rows.Count - 1; i >= 0; i--)
                //    {


                //        if (dt.Rows[i]["Note ID"] == DBNull.Value)
                //            dt.Rows[i].Delete();
                //    }
                //}




                if (result == "")
                {
                    for (var i = 0; i < fileConf.MappingColumns.Count; i++)
                    {
                        if (fileConf.MappingColumns[i].SheetColumnName == dt.Columns[i].ColumnName)
                        {

                            bulkcopy.ColumnMappings.Add(fileConf.MappingColumns[i].SheetColumnName, fileConf.MappingColumns[i].LandingColumnName);
                        }
                        else
                        {
                            result = "Failed#" + "Not valid data";
                        }
                    }

                    totalrows = dt.Rows.Count;
                    bulkcopy.WriteToServer(dt);
                    var res = InsertIntoNoteMatrix();
                    if (res == -1)
                        result = "Success";
                    else
                        result = "Failed";

                }
            }
            catch (Exception ex)
            {
                result = "Failed#" + ex.Message;
            }
            return result;
        }


        public int InsertIntoNoteMatrix()
        {
            Helper.Helper hp = new Helper.Helper();
            int res = hp.ExecNonquery("DW.usp_InsertNoteMatrixBI");
            return res;
        }

        public string BulkInsert(DataTable dt, string DestTableName, List<FileImportColumnMappingDataContract> columnMapping, bool IsTruncateRequired)
        {
            string result = "";
            int totalrows = 0;
            try
            {
                IConfigurationBuilder builder = new ConfigurationBuilder();
                builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
                var root = builder.Build();
                var conString = root.GetSection("Application").GetSection("ConnectionStrings").Value;

                if (IsTruncateRequired)
                {
                    //truncate table
                    SqlConnection sqlConn = new SqlConnection(conString.ToString());
                    sqlConn.Open();
                    string deleteQuery = "truncate table " + DestTableName; // just delete them all
                    SqlCommand sqlComm = new SqlCommand(deleteQuery, sqlConn);
                    sqlComm.ExecuteNonQuery();
                    sqlConn.Close();
                }



                SqlBulkCopy bulkcopy = new SqlBulkCopy(conString);
                bulkcopy.BulkCopyTimeout = 36000;
                bulkcopy.DestinationTableName = DestTableName;

                foreach (FileImportColumnMappingDataContract col in columnMapping)
                {
                    bulkcopy.ColumnMappings.Add(col.FileColumnName, col.LandingColumnName);
                }

                totalrows = dt.Rows.Count;
                bulkcopy.WriteToServer(dt);
                result = "Success";

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }
    }
}