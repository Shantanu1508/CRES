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
    public class V1CalcRepository : IV1CalcRepository
    {

        public DataSet GetCalcRequestData(string objectID, int objectTypeId, string userID, string analysisID, int CalcType)
        {
            DataSet ds = new DataSet();
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                /*
                182    27  Note
                283 27  Deal
                */
                Helper.Helper hp = new Helper.Helper();
                if (objectTypeId == 283)
                {
                    SqlParameter p0 = new SqlParameter { ParameterName = "@UserID", Value = userID };
                    SqlParameter p1 = new SqlParameter { ParameterName = "@DealID_any", Value = objectID };
                    SqlParameter p2 = new SqlParameter { ParameterName = "@Analysis_ID", Value = new Guid(analysisID) };
                    SqlParameter p3 = new SqlParameter { ParameterName = "@CalcTypeID", Value = CalcType };
                    SqlParameter[] sqlparam = new SqlParameter[] { p0, p1, p2, p3 };
                    ds = hp.ExecDataSet("usp_GetCalcJsonByDealID", sqlparam);
                }
                else if (objectTypeId == 182)
                {
                    SqlParameter p0 = new SqlParameter { ParameterName = "@UserID", Value = userID };
                    SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID_any", Value = objectID };
                    SqlParameter p2 = new SqlParameter { ParameterName = "@Analysis_ID", Value = new Guid(analysisID) };
                    SqlParameter p3 = new SqlParameter { ParameterName = "@CalcTypeID", Value = CalcType };
                    SqlParameter[] sqlparam = new SqlParameter[] { p0, p1, p2, p3 };
                    ds = hp.ExecDataSet("usp_GetCalcJsonByNoteID", sqlparam);
                }

                DataTable dtTableInfo = new DataTable();
                dtTableInfo = ds.Tables[ds.Tables.Count - 1];
                dtTableInfo.TableName = "json_info";

                for (int i = 0; i <= ds.Tables.Count - 2; i++)
                {
                    ds.Tables[i].TableName = dtTableInfo.Rows[i]["table_name"].ToString();
                }

            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            return ds;
        }
        public int InsertUpdateNotePeriodicCalc(DataTable dtperiodicoutput, string AnalysisID, string CreatedBy, string crenoteid)
        {

            try
            {

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@creNoteID", Value = crenoteid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                var res = hp.ExecDataSet("dbo.usp_DeleteNotePeriodicCalcByNoteID_V1", sqlparam);

                dtperiodicoutput.Columns.Add("NoteID", typeof(Guid));
                dtperiodicoutput.Columns.Add("Month", typeof(int));
                dtperiodicoutput.Columns.Add("AnalysisID", typeof(Guid));
                dtperiodicoutput.Columns.Add("createdby", typeof(string));
                dtperiodicoutput.Columns.Add("updatedby", typeof(string));
                dtperiodicoutput.Columns.Add("createddate", typeof(DateTime));
                dtperiodicoutput.Columns.Add("updateddate", typeof(DateTime));

                if (res.Tables[0].Rows.Count > 0)
                {
                    for (int i = 0; i < dtperiodicoutput.Rows.Count; i++)
                    {
                        dtperiodicoutput.Rows[i]["NoteID"] = new Guid(res.Tables[0].Rows[0]["NoteID"].ToString());
                        dtperiodicoutput.Rows[i]["AnalysisID"] = AnalysisID;
                        dtperiodicoutput.Rows[i]["Month"] = Convert.ToDateTime(dtperiodicoutput.Rows[i]["Date"]).Month;
                        dtperiodicoutput.Rows[i]["createdby"] = CreatedBy;
                        dtperiodicoutput.Rows[i]["updatedby"] = CreatedBy;
                        dtperiodicoutput.Rows[i]["createddate"] = DateTime.Now;
                        dtperiodicoutput.Rows[i]["updateddate"] = DateTime.Now;
                    }
                }

                //code for Bulk copy
                IConfigurationBuilder builder = new ConfigurationBuilder();
                builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
                var root = builder.Build();
                var conString = root.GetSection("Application").GetSection("ConnectionStrings").Value;

                //insert record
                SqlBulkCopy bulkcopy = new SqlBulkCopy(conString);
                bulkcopy.BulkCopyTimeout = 36000;
                bulkcopy.DestinationTableName = "[CRE].[NotePeriodicCalc]";

                bulkcopy.ColumnMappings.Add("NoteID", "NoteID");
                bulkcopy.ColumnMappings.Add("Date", "PeriodEndDate");
                bulkcopy.ColumnMappings.Add("Month", "Month");
                bulkcopy.ColumnMappings.Add("initbal", "BeginningBalance");
                bulkcopy.ColumnMappings.Add("funding", "TotalFutureAdvancesForThePeriod");
                bulkcopy.ColumnMappings.Add("paydown", "TotalDiscretionaryCurtailmentsforthePeriod");
                bulkcopy.ColumnMappings.Add("schprin", "ScheduledPrincipal");

                bulkcopy.ColumnMappings.Add("periodpikint", "PIKInterestForThePeriod");
                bulkcopy.ColumnMappings.Add("act_periodint", "PIKInterestAccrualforthePeriod");
                bulkcopy.ColumnMappings.Add("act_pikprinpaid", "PIKPrincipalPaidForThePeriod");
                bulkcopy.ColumnMappings.Add("endbal", "EndingBalance");

                bulkcopy.ColumnMappings.Add("clean_cost", "CleanCost");
                bulkcopy.ColumnMappings.Add("feeamort", "TotalAmortAccrualForPeriod");
                bulkcopy.ColumnMappings.Add("cum_am_fee", "AccumulatedAmort");
                bulkcopy.ColumnMappings.Add("am_capcosts", "CapitalizedCostAccrual");
                bulkcopy.ColumnMappings.Add("am_disc", "DiscountPremiumAccrual");
                bulkcopy.ColumnMappings.Add("gaapbv", "EndingGAAPBookValue");

                bulkcopy.ColumnMappings.Add("intaccrual", "CurrentPeriodInterestAccrualPeriodEnddate");
                bulkcopy.ColumnMappings.Add("pikintaccrual", "CurrentPeriodPIKInterestAccrualPeriodEnddate");
                bulkcopy.ColumnMappings.Add("intsuspensebal", "InterestSuspenseAccountBalance");

                bulkcopy.ColumnMappings.Add("AnalysisID", "AnalysisID");
                bulkcopy.ColumnMappings.Add("createdby", "CreatedBy");
                bulkcopy.ColumnMappings.Add("createddate", "CreatedDate");
                bulkcopy.ColumnMappings.Add("updatedby", "UpdatedBy");
                bulkcopy.ColumnMappings.Add("updateddate", "UpdatedDate");

                bulkcopy.WriteToServer(dtperiodicoutput);
                return 1;





            }
            catch (Exception ex)
            {

                throw ex;
            }

        }


        public int InsertTransactionEntry(DataTable dtTransactionsoutput, string AnalysisID, string CreatedBy, string crenoteid, string StrCreatedBy)
        {
            // var res = 0;
            try
            {
                Helper.Helper hp = new Helper.Helper();

                SqlParameter p1 = new SqlParameter { ParameterName = "@creNoteID", Value = crenoteid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                var res = hp.ExecDataSet("dbo.usp_DeleteTransactionEntryByNoteID_V1", sqlparam);

                //Bulk Insert changes
                dtTransactionsoutput.Columns.Add("NoteID", typeof(Guid));
                dtTransactionsoutput.Columns.Add("AnalysisID", typeof(Guid));
                dtTransactionsoutput.Columns.Add("createdby", typeof(string));
                dtTransactionsoutput.Columns.Add("updatedby", typeof(string));
                dtTransactionsoutput.Columns.Add("createddate", typeof(DateTime));
                dtTransactionsoutput.Columns.Add("updateddate", typeof(DateTime));
                dtTransactionsoutput.Columns.Add("GeneratedBy", typeof(string));
                dtTransactionsoutput.Columns.Add("StrCreatedBy", typeof(string));

                if (res.Tables[0].Rows.Count > 0)
                {
                    for (int i = 0; i < dtTransactionsoutput.Rows.Count; i++)
                    {
                        dtTransactionsoutput.Rows[i]["NoteID"] = new Guid(res.Tables[0].Rows[0]["NoteID"].ToString());
                        dtTransactionsoutput.Rows[i]["AnalysisID"] = AnalysisID;
                        dtTransactionsoutput.Rows[i]["createdby"] = CreatedBy;
                        dtTransactionsoutput.Rows[i]["updatedby"] = CreatedBy;
                        dtTransactionsoutput.Rows[i]["createddate"] = DateTime.Now;
                        dtTransactionsoutput.Rows[i]["updateddate"] = DateTime.Now;

                        dtTransactionsoutput.Rows[i]["GeneratedBy"] = "Calculator";
                        dtTransactionsoutput.Rows[i]["StrCreatedBy"] = StrCreatedBy;

                    }
                }

                IConfigurationBuilder builder = new ConfigurationBuilder();
                builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
                var root = builder.Build();
                var conString = root.GetSection("Application").GetSection("ConnectionStrings").Value;


                SqlBulkCopy bulkcopy = new SqlBulkCopy(conString);
                bulkcopy.BulkCopyTimeout = 36000;
                bulkcopy.DestinationTableName = "[CRE].[TransactionEntry]";

                bulkcopy.ColumnMappings.Add("NoteID", "NoteID");
                bulkcopy.ColumnMappings.Add("Date", "Date");
                bulkcopy.ColumnMappings.Add("value", "Amount");
                bulkcopy.ColumnMappings.Add("type", "Type");
                bulkcopy.ColumnMappings.Add("AnalysisID", "AnalysisID");
                bulkcopy.ColumnMappings.Add("createdby", "CreatedBy");
                bulkcopy.ColumnMappings.Add("createddate", "CreatedDate");
                bulkcopy.ColumnMappings.Add("updatedby", "UpdatedBy");
                bulkcopy.ColumnMappings.Add("updateddate", "UpdatedDate");
                bulkcopy.ColumnMappings.Add("Fee Name", "FeeName");
                bulkcopy.ColumnMappings.Add("IO Term End Date", "IOTermEndDate");
                bulkcopy.ColumnMappings.Add("purpose", "PurposeType");
                bulkcopy.ColumnMappings.Add("GeneratedBy", "GeneratedBy");
                bulkcopy.ColumnMappings.Add("StrCreatedBy", "StrCreatedBy");
                bulkcopy.ColumnMappings.Add("remit_dt", "RemitDate");
                bulkcopy.ColumnMappings.Add("transdtbyrule_dt", "TransactionDateByRule");
                bulkcopy.ColumnMappings.Add("trans_dt", "TransactionDateServicingLog");



                bulkcopy.WriteToServer(dtTransactionsoutput);

                return 1;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }


        public int InsertPayRuleDistribution(DataTable dtoutput, string AnalysisID, string CreatedBy)
        {
            Helper.Helper hp = new Helper.Helper();

            SqlParameter p1 = new SqlParameter { ParameterName = "@tbltype_PayRuleDist_V1", Value = dtoutput };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UpdatedBy", Value = CreatedBy };
            SqlParameter p3 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };


            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            var res = hp.ExecDataTablewithparams("dbo.usp_InsertUpdatePayruleDistributions_v1", sqlparam);
            return res;
        }

        public int UpdateTransactionEntryCash_NonCash(string NoteId, string AnalysisID)
        {
            var res = 0;
            Helper.Helper hp = new Helper.Helper();

            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = NoteId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };


            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            res = hp.ExecDataTablewithparams("CRE.usp_UpdateTransactionEntryCash_NonCash", sqlparam);

            return res;
        }
        //
        public List<V1CalculationStatusDataContract> GetAllDealsProcessingstatus()
        {
            List<V1CalculationStatusDataContract> lstresult = new List<V1CalculationStatusDataContract>();
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = hp.ExecDataTable("dbo.usp_getDealidandRequestIDfromCalculationRequests");
            foreach (DataRow dr in dt.Rows)
            {
                V1CalculationStatusDataContract _dealDC = new V1CalculationStatusDataContract();
                _dealDC.DealID = Convert.ToString(dr["DealID"]);
                _dealDC.RequestID = Convert.ToString(dr["RequestID"]);
                _dealDC.AnalysisID = Convert.ToString(dr["AnalysisID"]);
                lstresult.Add(_dealDC);
            }
            return lstresult;
        }

        public List<V1CalculationStatusDataContract> GetRecordsFromCalculationRequest()
        {
            List<V1CalculationStatusDataContract> lstresult = new List<V1CalculationStatusDataContract>();
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = hp.ExecDataTable("dbo.usp_getDealidfromCalculationRequests");
            foreach (DataRow dr in dt.Rows)
            {
                V1CalculationStatusDataContract _dealDC = new V1CalculationStatusDataContract();
                _dealDC.objectID = Convert.ToString(dr["objectID"]);
                _dealDC.objectTypeId = CommonHelper.ToInt32(dr["objectTypeId"]);
                _dealDC.AnalysisID = Convert.ToString(dr["AnalysisID"]);
                _dealDC.CalcType = CommonHelper.ToInt32(dr["CalcType"]);

                lstresult.Add(_dealDC);
            }
            return lstresult;
        }


        public List<V1CalculationStatusDataContract> GetRequestIDFromCalculationRequestsDataNotSaveInDB()
        {
            List<V1CalculationStatusDataContract> lstresult = new List<V1CalculationStatusDataContract>();
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = hp.ExecDataTable("dbo.usp_GetRequestIDFromCalculationRequests_DataNotSaveInDB");
            foreach (DataRow dr in dt.Rows)
            {
                V1CalculationStatusDataContract _dealDC = new V1CalculationStatusDataContract();
                _dealDC.RequestID = Convert.ToString(dr["RequestID"]);
                lstresult.Add(_dealDC);
            }
            return lstresult;
        }

        //usp_GetRequestIDFromCalculationRequests_DataNotSaveInDB

        public void UpdateCalculationRequestsStatus(string dealid, string RequestID, int Status, string AnalysisID, string UserID, string errmsg)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@ObjectID", Value = dealid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@RequestID", Value = RequestID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@Status", Value = Status };
                SqlParameter p4 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
                SqlParameter p5 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p6 = new SqlParameter { ParameterName = "@ErrorMessage", Value = errmsg };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6 };
                hp.ExecDataTable("dbo.usp_UpdateCalculationRequests", sqlparam);
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public string UpdateM61EngineCalcStatus(string RequestID, int Status, string errmsg)
        {
            string rtrmsg = "";
            try
            {

                Helper.Helper hp = new Helper.Helper();

                SqlParameter p1 = new SqlParameter { ParameterName = "@RequestID", Value = RequestID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@Status", Value = Status };
                SqlParameter p3 = new SqlParameter { ParameterName = "@ErrorMessage", Value = errmsg };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                DataTable dt = hp.ExecDataTable("dbo.usp_updateM61EnginecalcStatus", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    V1CalculationStatusDataContract _dealDC = new V1CalculationStatusDataContract();
                    rtrmsg = Convert.ToString(dr["ret_status"]);
                }

                if (rtrmsg == "" || rtrmsg == null)
                {
                    rtrmsg = "sp did not update";
                }

                return rtrmsg;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public DataTable GetDataFromCalculationRequestsByRequestID(string requestid)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@RequestID", Value = requestid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            DataTable dt = hp.ExecDataTable("dbo.usp_GetDataFromCalculationRequestsByRequestID", sqlparam);

            return dt;
        }

        public int InsertCalculatorOutputJsonInfo_V1(string RequestID, Guid? UserID, String FileName, string FileType)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@RequestID", Value = RequestID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@FileName", Value = FileName };
            SqlParameter p4 = new SqlParameter { ParameterName = "@FileType", Value = FileType };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            int result = hp.ExecNonquery("dbo.usp_InsertCalculatorOutputJsonInfo_V1", sqlparam);
            return result;
        }

        public int InsertPrepayPremiumEntry(DataTable dtPrepayPremiumoutput, string CreatedBy)
        {

            Helper.Helper hp = new Helper.Helper();

            SqlParameter p1 = new SqlParameter { ParameterName = "@tblPrepayPremiumoutput", Value = dtPrepayPremiumoutput };
            SqlParameter p2 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            hp.ExecDataSet("dbo.usp_InsertDealPrepayProjection", sqlparam);

            return 1;

        }

        public int InsertPrepayAllocationsEntry(DataTable dtPrepayallocationsoutput, string CreatedBy)
        {
            Helper.Helper hp = new Helper.Helper();

            SqlParameter p1 = new SqlParameter { ParameterName = "@tblPrepayallocationsoutput", Value = dtPrepayallocationsoutput };
            SqlParameter p2 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            hp.ExecDataSet("dbo.usp_InsertDealPrepayAllocations", sqlparam);

            return 1;

        }
    }
}
