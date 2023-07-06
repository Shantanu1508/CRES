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
    public class TranscationRepository
    {
        string conString = string.Empty;
        public List<ServicerDataContract> GetAllServicer()
        {
            DataTable dt = new DataTable();
            List<ServicerDataContract> lstServicer = new List<ServicerDataContract>();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetAllServicerMaster");

            // var lstSearchResult = dbContext.usp_GetAllServicerMaster();

            foreach (DataRow dr in dt.Rows)
            {
                ServicerDataContract _Servicerdc = new ServicerDataContract();
                _Servicerdc.SericerName = Convert.ToString(dr["ServicerName"]);
                _Servicerdc.ServicerDisplayName = Convert.ToString(dr["ServicerDisplayName"]);
                _Servicerdc.ServicerMasterID = CommonHelper.ToInt32(dr["ServicerMasterID"]);
                _Servicerdc.ServicerNamecss = Convert.ToString(dr["ServicerNamecss"] == null ? "" : dr["ServicerNamecss"]);
                _Servicerdc.Status = CommonHelper.ToInt32(dr["Staus"]);
                _Servicerdc.CloseDate = CommonHelper.ToDateTime(dr["EndDate"]);
                _Servicerdc.ServicerFile = Convert.ToString(dr["ServicerFile"]);
                _Servicerdc.DownloadFileName = Convert.ToString(dr["DownloadDisplayName"]);
                lstServicer.Add(_Servicerdc);
            }
            return lstServicer;
        }


        public int insertupdateFileBatchLog(FileBatchLogDataContract fb, string errmsg)
        {
            int result = 0;


            try
            {
                // ObjectParameter newBatchLogID = new ObjectParameter("NewBatchLogID", typeof(Int32));
                DataTable dt = new DataTable();
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserId", Value = fb.CreatedBy };
                SqlParameter p2 = new SqlParameter { ParameterName = "@ServcerMasterID", Value = fb.ServcerMasterID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@OrigFileName", Value = fb.OrigFileName };
                SqlParameter p4 = new SqlParameter { ParameterName = "@BlobFileName", Value = fb.BlobFileName };
                SqlParameter p5 = new SqlParameter { ParameterName = "@ErrorMsg", Value = errmsg == null ? "" : errmsg };
                SqlParameter p6 = new SqlParameter { ParameterName = "@newBatchLogID", Direction = ParameterDirection.Output, Size = int.MaxValue };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6 };
                dt = hp.ExecDataTable("dbo.usp_InsertIntoFileBatchLog", sqlparam);
                //var res = dbContext.usp_InsertIntoFileBatchLog(fb.CreatedBy,
                //    fb.ServcerMasterID,
                //    fb.OrigFileName,
                //    fb.BlobFileName,
                //    errmsg == null ? "" : errmsg,
                //    newBatchLogID);

                result = Convert.ToInt32(p6.Value);

            }
            catch (Exception ex)
            {

                string exce = ex.ToString();
            }

            return result;
        }
        public void insertupdateFileBatchDetail(string userid, int BatchLogID, string ProcessName, string errmsg)
        {
            try
            {

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserId", Value = userid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@BatchLogID", Value = BatchLogID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@ProcessName", Value = ProcessName };
                SqlParameter p4 = new SqlParameter { ParameterName = "@ErrorMsg", Value = errmsg == null ? "" : errmsg };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
                hp.ExecNonquery("dbo.usp_InsertIntoFileBatchLogDetail", sqlparam);


                //var res = dbContext.usp_InsertIntoFileBatchLogDetail(userid,
                //    BatchLogID,
                //    ProcessName,
                //    errmsg == null ? "" : errmsg);

            }
            catch (Exception ex)
            {

                string exce = ex.ToString();
            }


        }

        public string insertintoTranscation(string procName, int Batchlogid, string ScenarioId)
        {
            string smessage = string.Empty;
            string message = string.Empty;

            try
            {
                Helper.Helper hp = new Helper.Helper();

                SqlParameter p1 = new SqlParameter { ParameterName = "@Batchlogid", Value = Batchlogid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@ScenarioId", Value = ScenarioId };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                DataTable dt = hp.ExecDataTable(procName, sqlparam);
                if (dt.Rows.Count > 0)
                {
                    for (var i = 0; i < dt.Rows.Count; i++)
                    {
                        message += dt.Rows[i]["TransactionType"] + " - " + dt.Rows[i]["Totalrecords"] + " record(s) imported successfully. ";
                        if (dt.Rows[i]["ignored"].ToString() != "0")
                            message += dt.Rows[i]["ignored"] + " record(s) were ignored.";
                        message += "<br/>";
                    }



                    //for (var j = 0; j < isvalid.Rows.Count; j++)
                    //{
                    //    resultOutput += "Note " + isvalid.Rows[j]["CRENoteID"] + ": " + isvalid.Rows[j]["TransactionType"] + " of remit date " + isvalid.Rows[j]["RemittanceDate"] + " is a part of split transaction. It cannot be unreconciled individually. <br/>";
                    //}

                    smessage = "Success#" + message;
                    // message = "Successed#" + dtIgnored.Rows.Count + " are ignored.";
                }


            }
            catch (Exception ex)
            {
                string str = ex.ToString();


            }

            return smessage;
        }


        public DataTable GetallTranscation()
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable dtNote = new DataTable();
            dtNote = hp.ExecDataTable("dbo.usp_GetTranscationForReconciliation");
            return dtNote;
        }
        public DataTable GetallTranscationPaging(int? pageSize, int? pageIndex, out int? TotalCount)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable dt = new DataTable();
            SqlParameter p1 = new SqlParameter { ParameterName = "@PgeIndex", Value = pageIndex };
            SqlParameter p2 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p3 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            dt = hp.ExecDataTable("dbo.usp_GetTranscationForReconciliationPaging", sqlparam);
            TotalCount = string.IsNullOrEmpty(Convert.ToString(p3.Value)) ? 0 : Convert.ToInt32(p3.Value);
            return dt;
        }

        public DataTable GetHistoricalDataforTranscationRecon()
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable dtNote = new DataTable();
            dtNote = hp.ExecDataTable("dbo.usp_GetHistoricalDataforTranscationRecon");
            return dtNote;
        }


        public void Config()
        {

            IConfigurationBuilder builder = new ConfigurationBuilder();
            builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
            var root = builder.Build();
            conString = root.GetSection("Application").GetSection("ConnectionStrings").Value;
            //connstring = "Data Source = 192.168.1.250; Initial Catalog = CRES4_QA; user id=admin;password=admin1*";
        }

        // #Remaining# 
        public string BulkInsertbyServicer(DataTable dt, JsonFileConfiguration fileConf, int FileBatchlogid, DateTime? periodCloseDate)
        {
            string result = "", lessperioddates = "";
            int totalrows = 0;
            try
            {

                Config();
                //IConfigurationBuilder builder = new ConfigurationBuilder();
                //builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
                //var root = builder.Build();
                //var conString = root.GetSection("Application").GetSection("ServerName").Value;

                // string conString = System.Configuration.ConfigurationManager.ConnectionStrings["LoggingInDB"].ConnectionString;

                dt.Columns.Add("FileBatchlogid", typeof(Int32));

                SqlBulkCopy bulkcopy = new SqlBulkCopy(conString);
                bulkcopy.BulkCopyTimeout = 36000;
                bulkcopy.DestinationTableName = fileConf.LandingTableName;

                //  dt = dt.Rows.Cast<DataRow>().Where(row => !row.ItemArray.All(field => field is DBNull || string.IsNullOrWhiteSpace(field as string))).CopyToDataTable();
                //Remove Blank Row
                if (dt.Rows.Count > 0)
                {
                    for (int i = dt.Rows.Count - 1; i >= 0; i--)
                    {
                        if (dt.Rows[i]["Note ID"] == DBNull.Value)
                            dt.Rows[i].Delete();
                    }
                }
                //Remove Blank Row
                for (var i = 0; i < dt.Rows.Count; i++)
                {
                    dt.Rows[i]["Note ID"] = dt.Rows[i]["Note ID"].ToString().Trim();
                    dt.Rows[i]["FileBatchlogid"] = FileBatchlogid;
                    if (dt.Rows[i]["Due Date"].ToString() != "")
                    {
                        if (Convert.ToDateTime(dt.Rows[i]["Due Date"]) < periodCloseDate)
                        {
                            //dt.Rows.RemoveAt(i);
                            //i--;
                            lessperioddates = lessperioddates + " " + Convert.ToDateTime(dt.Rows[i]["Due Date"]).ToShortDateString() + ",";
                            // return "Failed#" + Convert.ToDateTime(dt.Rows[i]["Due Date"]).ToShortDateString() + " is less than period close date.";
                        }
                    }






                }

                if (lessperioddates != "")
                {

                    return "Failed#" + lessperioddates.Remove(lessperioddates.Length - 1, 1) + " is less than period close date.";
                }





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
                    // dt.CaseSensitive = false;
                    bulkcopy.ColumnMappings.Add("FileBatchlogid", "FileBatchlogid");
                    totalrows = dt.Rows.Count;
                    bulkcopy.WriteToServer(dt);
                    result = "Success";
                    //if (totalrows == 1)
                    //{
                    //    result = "Success#" + totalrows + " record imported successfully.";
                    //}
                    //else
                    //{
                    //    result = "Success#" + totalrows + " records imported successfully.";
                    //}


                    //else
                    //{
                    //    if (totalrows == 1)
                    //    {
                    //        result = "Success#" + totalrows + " record imported and " + removedrows + " are ignored.";
                    //    }
                    //    else
                    //    {
                    //        result = "Success#" + totalrows + " records imported and " + removedrows + " are ignored.";
                    //    }

                    //}
                }
            }
            catch (Exception ex)
            {
                result = "Failed#" + ex.Message;
            }
            return result;

        }



        public int UpdateTranscationRecon(DataTable dtTrans, string CreatedBy)
        {

            if (dtTrans.Columns.Count > 0)
            {
                dtTrans.Columns.Remove("CREDealID");
                dtTrans.Columns.Remove("DealName");
                dtTrans.Columns.Remove("CRENoteID");
                dtTrans.Columns.Remove("isRecon");
                dtTrans.Columns.Remove("NoteName");
                dtTrans.Columns.Remove("Exception");
                dtTrans.Columns.Remove("AddlInterest");
                dtTrans.Columns.Remove("TotalInterest");
                dtTrans.Columns.Remove("OverrideReasonText");
                dtTrans.Columns.Remove("InterestAdj");
                dtTrans.Columns.Remove("SplitTransactionid");

            }

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "TmpTrans", Value = dtTrans };
            SqlParameter p2 = new SqlParameter { ParameterName = "CreatedBy", Value = CreatedBy };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            return hp.ExecDataTablewithparams("dbo.usp_UpdateTranscation", sqlparam);


        }


        public int SaveTranscation(DataTable dtTrans, string CreatedBy)
        {

            if (dtTrans.Columns.Count > 0)
            {
                dtTrans.Columns.Remove("CREDealID");
                dtTrans.Columns.Remove("DealName");
                dtTrans.Columns.Remove("CRENoteID");
                dtTrans.Columns.Remove("isRecon");
                dtTrans.Columns.Remove("NoteName");
                dtTrans.Columns.Remove("Exception");
                dtTrans.Columns.Remove("AddlInterest");
                dtTrans.Columns.Remove("TotalInterest");
                dtTrans.Columns.Remove("OverrideReasonText");
                dtTrans.Columns.Remove("InterestAdj");
                dtTrans.Columns.Remove("SplitTransactionid");
            }

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "TmpTrans", Value = dtTrans };
            SqlParameter p2 = new SqlParameter { ParameterName = "CreatedBy", Value = CreatedBy };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            return hp.ExecDataTablewithparams("dbo.usp_SaveTranscations", sqlparam);


            //  return hp.ExecDataTable("usp_UpdateTranscation", "TmpTrans", dtTrans, CreatedBy);

        }


        public string UnreconcileTranscation(DataTable dtTrans, string CreatedBy)
        {
            string resultOutput = ""; int result = 0;

            if (dtTrans.Columns.Count > 0)
            {
                dtTrans.Columns.Remove("CREDealID");
                dtTrans.Columns.Remove("DealName");
                dtTrans.Columns.Remove("CRENoteID");
                dtTrans.Columns.Remove("isRecon");
                dtTrans.Columns.Remove("NoteName");
                dtTrans.Columns.Remove("Exception");
                dtTrans.Columns.Remove("AddlInterest");
                dtTrans.Columns.Remove("TotalInterest");
                dtTrans.Columns.Remove("OverrideReasonText");
                dtTrans.Columns.Remove("InterestAdj");
                dtTrans.Columns.Remove("SplitTransactionid");
            }

            Helper.Helper hp = new Helper.Helper();
            SqlParameter dp1 = new SqlParameter { ParameterName = "TmpUnrecon", Value = dtTrans };

            SqlParameter[] sqlDelparam = new SqlParameter[] { dp1 };
            DataTable isvalid = hp.ExecDataTable("dbo.usp_IsValidUnreconcileTranscation", sqlDelparam);

            if (isvalid.Rows.Count == 0)
            {
                SqlParameter p1 = new SqlParameter { ParameterName = "TmpTrans", Value = dtTrans };
                SqlParameter p2 = new SqlParameter { ParameterName = "CreatedBy", Value = CreatedBy };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                result = hp.ExecDataTablewithparams("dbo.usp_UnreconcileTranscations", sqlparam);
                if (result != 0)
                    resultOutput = "Unreconciled successfully.";
            }
            else
            {
                //Note < 1234 >: < ExitFeeExcludedFromLevel > of remit date mm / dd / yyyy is a part of split transaction.It cannot be unreconciled individually.
                for (var j = 0; j < isvalid.Rows.Count; j++)
                {
                    resultOutput += "Note " + isvalid.Rows[j]["CRENoteID"] + ": " + isvalid.Rows[j]["TransactionType"] + " of remit date " + isvalid.Rows[j]["RemittanceDate"] + " is a part of split transaction. It cannot be unreconciled individually. <br/>";
                }

            }


            return resultOutput;
        }


        public DataTable FilterTranscation(string FilterStr)
        {
            var search_ctr = FilterStr.Split('#');
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1;

            if (search_ctr[1] != "undefined")
            {
                p1 = new SqlParameter { ParameterName = "StartDate", Value = DateTime.Parse(search_ctr[1]) };
            }
            else
            {
                p1 = new SqlParameter { ParameterName = "StartDate", Value = search_ctr[1].Replace("undefined", "1/2/1900") };
            }
            SqlParameter p2;
            if (search_ctr[2] != "undefined")
            {
                p2 = new SqlParameter { ParameterName = "EndDate", Value = DateTime.Parse(search_ctr[2]) };
            }
            else
            {
                DateTime tdate = DateTime.Today.Date;

                tdate = tdate.AddYears(100);
                p2 = new SqlParameter { ParameterName = "EndDate", Value = search_ctr[2].Replace("undefined", tdate.ToString()) };
            }
            SqlParameter p3;
            if (search_ctr[3] != "0")
            {
                p3 = new SqlParameter { ParameterName = "Delta", Value = search_ctr[3] };
            }
            else
            {
                p3 = new SqlParameter { ParameterName = "Delta", Value = "" };
            }
            SqlParameter p4;
            if (search_ctr[4].Length == 2)
            {
                p4 = new SqlParameter { ParameterName = "CREDealID", Value = "" };
            }
            else
            {
                p4 = new SqlParameter { ParameterName = "CREDealID", Value = search_ctr[4] };
            }
            SqlParameter p5 = new SqlParameter { ParameterName = "IsReconciled", Value = search_ctr[5] };
            SqlParameter p6 = new SqlParameter { ParameterName = "@IsException", Value = search_ctr[6] };
            SqlParameter p7;
            if (search_ctr[7].Length != 2)
            {
                p7 = new SqlParameter { ParameterName = "@TransactionType", Value = search_ctr[7] };
            }
            else
            {
                p7 = new SqlParameter { ParameterName = "@TransactionType", Value = "" };
            }


            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7 };
            dt = hp.ExecDataTable("dbo.usp_FilterTransactionReconcil", sqlparam);
            if (dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["isRecon"].ToString() == "0")
                {
                    if (dt.Rows.Count > 500)
                    {
                        DataTable nwtable = new DataTable();
                        nwtable.Columns.Add("ErrorMessage", typeof(string));
                        DataRow dr = nwtable.NewRow();
                        dr["ErrorMessage"] = "Filter having too much data. Please apply more filters for accurate data. ";
                        nwtable.Rows.Add(dr);
                        return nwtable;

                    }
                    else
                    {
                        dt.Columns.Add("ErrorMessage", typeof(string));
                        DataRow dr = dt.NewRow();
                        dr["ErrorMessage"] = "";
                        dt.Rows.Add(dr);

                        // return dt;
                    }
                }
                else
                {
                    dt.Columns.Add("ErrorMessage", typeof(string));
                    DataRow dr = dt.NewRow();
                    dr["ErrorMessage"] = "";
                    dt.Rows.Add(dr);
                    //  return dt;
                }
            }
            else
            {
                dt.Columns.Add("ErrorMessage", typeof(string));
                DataRow dr = dt.NewRow();
                dr["ErrorMessage"] = "";
                dt.Rows.Add(dr);
            }
            return dt;
        }

        public List<TransactionAuditDataContract> GetAllTranscationAuditLog()
        {
            DataTable dt = new DataTable();
            List<TransactionAuditDataContract> lstTransAudit = new List<TransactionAuditDataContract>();
            Helper.Helper hp = new Helper.Helper(); ;
            dt = hp.ExecDataTable("CRE.usp_GetTransactionAuditLog");

            // var lstTransAuditResult = dbContext.usp_GetTransactionAuditLog();
            foreach (DataRow dr in dt.Rows)
            {
                TransactionAuditDataContract _transactionAuditDC = new TransactionAuditDataContract();
                _transactionAuditDC.OrigFileName = Convert.ToString(dr["OrigFileName"]);
                _transactionAuditDC.BlobFileName = Convert.ToString(dr["BlobFileName"]);
                _transactionAuditDC.UploadedBY = Convert.ToString(dr["UploadedBY"]);
                _transactionAuditDC.TotalNumberofRecords = CommonHelper.ToInt32(dr["TotalNumberofRecords"]);
                _transactionAuditDC.NumberofRecordsimported = CommonHelper.ToInt32(dr["NumberofRecordsimported"]);
                _transactionAuditDC.NumberofRecordsIgnored = CommonHelper.ToInt32(dr["NumberofRecordsIgnored"]);
                _transactionAuditDC.NumberofRecordsPaydownIgnored = CommonHelper.ToInt32(dr["NumberofRecordsPaydownIgnored"]);
                _transactionAuditDC.UploadedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                _transactionAuditDC.BatchLogID = CommonHelper.ToInt32(dr["BatchLogID"]);
                lstTransAudit.Add(_transactionAuditDC);
            }
            return lstTransAudit;

        }

        public DataTable GetAllTranscationbyBatchID(int BatchID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();

            DataTable dtNote = new DataTable();
            SqlParameter p1 = new SqlParameter { ParameterName = "BatchID", Value = BatchID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetTranscationsAuditbyBatchID", sqlparam);
            return dt;
        }

        public int DeleteAuditbyBatchlogId(int BatchID)
        {
            int res = 0;
            Helper.Helper hp = new Helper.Helper();

            DataTable dtNote = new DataTable();
            SqlParameter p1 = new SqlParameter { ParameterName = "BatchID", Value = BatchID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            res = hp.ExecNonquery("usp_DeleteTransactionsAuditbyBatchID", sqlparam);
            return res;
        }


        public DataTable GetAllTransactionsByNoteId(string TransParam)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            var Transpar = TransParam.Split('#');
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                SqlParameter p1 = new SqlParameter { ParameterName = "NoteId", Value = Transpar[0] };
                SqlParameter p2 = new SqlParameter { ParameterName = "DueDate", Value = DateTime.Parse(Transpar[1]) };
                SqlParameter p3 = new SqlParameter { ParameterName = "TransactionType", Value = Transpar[2] };
                SqlParameter p4 = new SqlParameter { ParameterName = "ScenarioId", Value = Transpar[3] };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
                dt = hp.ExecDataTable("dbo.usp_GetAllTransactionsByNoteId", sqlparam);
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            return dt;
        }

        public int RefreshM61Amount(string UserId)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            int res = 0;
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                SqlParameter p1 = new SqlParameter { ParameterName = "UserId", Value = UserId };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };

                res = hp.ExecNonquery("dbo.usp_RefreshM61AmountIntoTranscationReconciliation", sqlparam);
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used

            return res;

        }



        public DataTable SplitFeeTransaction(DataTable dtTrans)
        {
            DataTable dt = new DataTable();

            if (dtTrans.Columns.Count > 0)
            {
                dtTrans.Columns.Remove("CREDealID");
                dtTrans.Columns.Remove("DealName");
                dtTrans.Columns.Remove("CRENoteID");
                dtTrans.Columns.Remove("isRecon");
                dtTrans.Columns.Remove("NoteName");
                dtTrans.Columns.Remove("Exception");
                dtTrans.Columns.Remove("AddlInterest");
                dtTrans.Columns.Remove("TotalInterest");
                dtTrans.Columns.Remove("OverrideReasonText");
                dtTrans.Columns.Remove("InterestAdj");
                dtTrans.Columns.Remove("SplitTransactionid");
                if (dtTrans.Columns.Contains("Final_ValueUsedInCalc"))
                {
                    dtTrans.Columns.Remove("Final_ValueUsedInCalc");
                }


            }

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "TmpreconTrans", Value = dtTrans };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_getFeeSplitReconcileTransaction", sqlparam);

            return dt;

        }


        public int ReconcileSplitFeeTransaction(DataTable dtTrans, string CreatedBy)
        {
            int result = 0;


            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "TmpSplitTrans", Value = dtTrans };
            SqlParameter p2 = new SqlParameter { ParameterName = "CreatedBy", Value = CreatedBy };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            result = hp.ExecDataTablewithparams("dbo.usp_SplitFeeTransaction", sqlparam);

            return result;

        }



        //
        public DataTable GetAllTransactionType()
        {
            Helper.Helper hp = new Helper.Helper();
            DataTable dtTransactionType = new DataTable();
            dtTransactionType = hp.ExecDataTable("dbo.usp_GetAllTransactionTypeForFilter");
            return dtTransactionType;
        }

    }
}
