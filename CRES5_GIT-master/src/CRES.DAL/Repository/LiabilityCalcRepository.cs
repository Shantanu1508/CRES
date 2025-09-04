using CRES.DAL.IRepository;
using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using CRES.DataContract;
using System.Data.SqlClient;
using CRES.Utilities;
using CRES.DataContract.Liability;

namespace CRES.DAL.Repository
{
    public class LiabilityCalcRepository : ILiabilityCalcRepository
    {
        public List<JsonFormatCalcLiability> GetLiabilityJsonFormat()
        {

            List<JsonFormatCalcLiability> lstresult = new List<JsonFormatCalcLiability>();
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = hp.ExecDataTable("dbo.usp_GetJsonFormatCalcLiability");
            foreach (DataRow dr in dt.Rows)
            {
                JsonFormatCalcLiability _lbDC = new JsonFormatCalcLiability();
                _lbDC.JsonFormatCalcLiabilityID = Convert.ToInt32(dr["JsonFormatCalcLiabilityID"]);
                _lbDC.Position = Convert.ToString(dr["Position"]);
                _lbDC.Key = Convert.ToString(dr["Key"]);
                _lbDC.KeyFormat = Convert.ToString(dr["KeyFormat"]);
                _lbDC.DataType = Convert.ToString(dr["DataType"]);
                _lbDC.IsActive = Convert.ToBoolean(dr["IsActive"]);
                _lbDC.ParentID = CommonHelper.ToInt32(dr["ParentID"]);
                _lbDC.FilterBy = Convert.ToString(dr["FilterBy"]);


                lstresult.Add(_lbDC);
            }
            return lstresult;
        }
        public DataSet GetLiabilityCalcRequestData(string userID, String fundIDorName, string analysisID)
        {
            DataSet ds = new DataSet();
            try
            {

                Helper.Helper hp = new Helper.Helper();
                //SqlParameter p0 = new SqlParameter { ParameterName = "@UserID", Value = userID };
                SqlParameter p0 = new SqlParameter { ParameterName = "@FundIdOrName", Value = fundIDorName };
                SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = new Guid(analysisID) };

                SqlParameter[] sqlparam = new SqlParameter[] { p0, p1 };
                ds = hp.ExecDataSet("usp_GetCalcJsonByFundName", sqlparam);
                DataTable dtTableInfo = new DataTable();

                dtTableInfo = ds.Tables[ds.Tables.Count - 1];
                dtTableInfo.TableName = "json_info";

                for (int i = 0; i <= ds.Tables.Count - 2; i++)
                {
                    ds.Tables[i].TableName = dtTableInfo.Rows[i]["Name"].ToString();
                }

            }
            catch (Exception ex)
            {
            }
            return ds;
        }
        public List<EquityCalcDataContract> GetEquityForCalculation()
        {
            List<EquityCalcDataContract> lstresult = new List<EquityCalcDataContract>();
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = hp.ExecDataTable("dbo.usp_GetListOfEquityForCalculation");
            foreach (DataRow dr in dt.Rows)
            {
                EquityCalcDataContract _eqDC = new EquityCalcDataContract();
                _eqDC.AccountID = Convert.ToString(dr["AccountId"]);
                _eqDC.RequestTime = CommonHelper.ToDateTime(dr["RequestTime"]);
                _eqDC.CalculationRequestID = Convert.ToString(dr["CalculationRequestID"]);
                _eqDC.UserName = Convert.ToString(dr["UserName"]);
                _eqDC.AnalysisID = Convert.ToString(dr["AnalysisID"]);
                if (_eqDC.AnalysisID == null || _eqDC.AnalysisID == "")
                {
                    _eqDC.AnalysisID = "c10f3372-0fc2-4861-a9f5-148f1f80804f";
                }
                _eqDC.CalculationModeID = Convert.ToInt32(dr["CalcEngineType"]);
                _eqDC.CalcType = Convert.ToInt32(dr["CalcType"]);
                lstresult.Add(_eqDC);
            }
            return lstresult;
        }
        public void UpdateLiabilityCalculationStatusandTime(Guid calcid, string statustext, string columnname, string errmsg, string updatedby)

        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@CalculationRequestID", Value = calcid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@StatusText", Value = statustext };
            SqlParameter p3 = new SqlParameter { ParameterName = "@ColumnName", Value = columnname };
            SqlParameter p4 = new SqlParameter { ParameterName = "@ErrorMessage", Value = errmsg };
            SqlParameter p5 = new SqlParameter { ParameterName = "@UpdatedBy", Value = errmsg };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            hp.ExecNonquery("dbo.usp_UpdateCalculationStatusAndTime_CalculationRequests", sqlparam);

        }

        public List<GenerateAutomationDataContract> GetLiabilitListForCalculation(string type)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            List<GenerateAutomationDataContract> listofdeals = new List<GenerateAutomationDataContract>();
            SqlParameter p1 = new SqlParameter { ParameterName = "@type", Value = type };

            dt = hp.ExecDataTable("dbo.usp_GetLiabilityListForAutomation", p1);
            foreach (DataRow dr in dt.Rows)
            {
                GenerateAutomationDataContract gad = new GenerateAutomationDataContract();
                gad.DealID = Convert.ToString(dr["AccountID"]);
                gad.StatusText = "Processing";
                if (type == "LiabilityCalculation")
                {
                    gad.AutomationType = 853;
                    gad.BatchType = "LiabilityCalculation";
                }
                listofdeals.Add(gad);
            }
            return listofdeals;
        }

        public void InsertTransactionEntryLiabilityLine(List<LiabilityLineTransaction> LiabilityLineTransaction,string username)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable dtTranscation = new DataTable();
            dtTranscation.Columns.Add("AnalysisID");
            dtTranscation.Columns.Add("LiabilityAccountID");
            dtTranscation.Columns.Add("Date");
            dtTranscation.Columns.Add("Amount");
            dtTranscation.Columns.Add("TransactionType");
            dtTranscation.Columns.Add("EndingBalance");
            dtTranscation.Columns.Add("UserID");             
            if (LiabilityLineTransaction != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(LiabilityLineTransaction);

                foreach (DataRow dr in dt.Rows)
                {
                    dtTranscation.ImportRow(dr);
                }
            }

            if (dtTranscation.Rows.Count > 0)
            {
                for (int i = 0; i < dtTranscation.Rows.Count; i++)
                {
                    dtTranscation.Rows[i]["UserID"] = username;
                }

                SqlParameter p1 = new SqlParameter { ParameterName = "@TableTypeTransactionEntry_LiabilityLine", Value = dtTranscation };                
                SqlParameter[] sqlparam = new SqlParameter[] { p1};
                hp.ExecDataTablewithparams("dbo.usp_InsertTransactionEntryLiabilityLine", sqlparam);
            }
        }

        public void InsertLiabilityNoteTransaction(List<LiabilityNoteTransaction> LiabilityNoteTransaction, string username)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable dtTranscation = new DataTable();
            dtTranscation.Columns.Add("LiabilityAccountID");
            dtTranscation.Columns.Add("LiabilityNoteAccountID");
            dtTranscation.Columns.Add("LiabilityNoteID");
            dtTranscation.Columns.Add("Date");
            dtTranscation.Columns.Add("Amount");
            dtTranscation.Columns.Add("TransactionType");
            dtTranscation.Columns.Add("AnalysisID");
            dtTranscation.Columns.Add("EndingBalance");
            dtTranscation.Columns.Add("AssetAccountID");
            dtTranscation.Columns.Add("AssetDate");
            dtTranscation.Columns.Add("AssetAmount");
            dtTranscation.Columns.Add("AssetTransactionType");
            dtTranscation.Columns.Add("UserID");
            //dtTranscation.Columns.Add("CaclType");

            //dtTranscation.Columns.Add("CashSublineBalance");
            //dtTranscation.Columns.Add("FundBalance");
            //dtTranscation.Columns.Add("SublineBalance");
            //dtTranscation.Columns.Add("LineBalance");
            //dtTranscation.Columns.Add("CashEquityBalance");


            if (LiabilityNoteTransaction != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(LiabilityNoteTransaction);

                foreach (DataRow dr in dt.Rows)
                {
                    dtTranscation.ImportRow(dr);
                }
            }

            if (dtTranscation.Rows.Count > 0)
            {
                for (int i = 0; i < dtTranscation.Rows.Count; i++)
                {
                    dtTranscation.Rows[i]["UserID"] = username;
                }

                SqlParameter p1 = new SqlParameter { ParameterName = "@tblTypeTransactionEntryLiability", Value = dtTranscation };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                hp.ExecDataTablewithparams("dbo.usp_InsertTransactionEntryLiability", sqlparam);
            }
        }

        public void InsertLiabilityNoteTransactionForFeeAndInterest(List<LiabilityNoteTransaction> LiabilityNoteTransaction, string username)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable dtTranscation = new DataTable();
            dtTranscation.Columns.Add("LiabilityAccountID");
            dtTranscation.Columns.Add("LiabilityTypeID");
            dtTranscation.Columns.Add("LiabilityNoteAccountID");
            dtTranscation.Columns.Add("LiabilityNoteID");
            dtTranscation.Columns.Add("Date");
            dtTranscation.Columns.Add("Amount");
            dtTranscation.Columns.Add("TransactionType");
            dtTranscation.Columns.Add("AnalysisID");
            dtTranscation.Columns.Add("EndingBalance");
            dtTranscation.Columns.Add("AssetAccountID");
            dtTranscation.Columns.Add("AssetDate");
            dtTranscation.Columns.Add("AssetAmount");
            dtTranscation.Columns.Add("AssetTransactionType");
            dtTranscation.Columns.Add("UserID");
            dtTranscation.Columns.Add("CalcType");
            dtTranscation.Columns.Add("AllInCouponRate");
            dtTranscation.Columns.Add("SpreadValue");
            dtTranscation.Columns.Add("OriginalIndex");

            //dtTranscation.Columns.Add("CashSublineBalance");
            //dtTranscation.Columns.Add("FundBalance");
            //dtTranscation.Columns.Add("SublineBalance");
            //dtTranscation.Columns.Add("LineBalance");
            //dtTranscation.Columns.Add("CashEquityBalance");


            if (LiabilityNoteTransaction != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(LiabilityNoteTransaction);

                foreach (DataRow dr in dt.Rows)
                {
                    dtTranscation.ImportRow(dr);
                }
            }

            if (dtTranscation.Rows.Count > 0)
            {
                for (int i = 0; i < dtTranscation.Rows.Count; i++)
                {
                    dtTranscation.Rows[i]["UserID"] = username;
                }

                SqlParameter p1 = new SqlParameter { ParameterName = "@tblTypeTransactionEntryLiability", Value = dtTranscation };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                hp.ExecDataTablewithparams("dbo.usp_InsertTransactionEntryLiabilityForFeeAndInterest", sqlparam);
            }
        }
        public void InsertLiabilityNoteTransactionForFee(List<LiabilityNoteTransaction> LiabilityNoteTransaction, string username)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable dtTranscation = new DataTable();
            dtTranscation.Columns.Add("LiabilityAccountID");
            dtTranscation.Columns.Add("LiabilityTypeID");
            dtTranscation.Columns.Add("LiabilityNoteAccountID");
            dtTranscation.Columns.Add("LiabilityNoteID");
            dtTranscation.Columns.Add("Date");
            dtTranscation.Columns.Add("Amount");
            dtTranscation.Columns.Add("TransactionType");
            dtTranscation.Columns.Add("AnalysisID");
            dtTranscation.Columns.Add("EndingBalance");
            dtTranscation.Columns.Add("AssetAccountID");
            dtTranscation.Columns.Add("AssetDate");
            dtTranscation.Columns.Add("AssetAmount");
            dtTranscation.Columns.Add("AssetTransactionType");
            dtTranscation.Columns.Add("UserID");
            dtTranscation.Columns.Add("CalcType");
            dtTranscation.Columns.Add("AllInCouponRate");
            dtTranscation.Columns.Add("SpreadValue");
            dtTranscation.Columns.Add("OriginalIndex");
            dtTranscation.Columns.Add("FeeName");


            //dtTranscation.Columns.Add("CashSublineBalance");
            //dtTranscation.Columns.Add("FundBalance");
            //dtTranscation.Columns.Add("SublineBalance");
            //dtTranscation.Columns.Add("LineBalance");
            //dtTranscation.Columns.Add("CashEquityBalance");


            if (LiabilityNoteTransaction != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(LiabilityNoteTransaction);

                foreach (DataRow dr in dt.Rows)
                {
                    dtTranscation.ImportRow(dr);
                }
            }

            if (dtTranscation.Rows.Count > 0)
            {
                for (int i = 0; i < dtTranscation.Rows.Count; i++)
                {
                    dtTranscation.Rows[i]["UserID"] = username;
                }

                SqlParameter p1 = new SqlParameter { ParameterName = "@tblTypeTransactionEntryLiability", Value = dtTranscation };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                hp.ExecDataTablewithparams("dbo.usp_InsertTransactionEntryLiabilityForFee", sqlparam);
            }
        }


        public void UpdateLiabilityTransactionFileName(int AutomationRequestsID, string FileName)

        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@AutomationRequestsID", Value = AutomationRequestsID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@FileName", Value = FileName };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2};
            hp.ExecNonquery("dbo.usp_UpdateLiabilityTransactionFileName", sqlparam);

        }

        public List<JsonFormatCalcLiability> GetLiabilityCalcRequestForFeesAndInterest()
        {

            List<JsonFormatCalcLiability> lstresult = new List<JsonFormatCalcLiability>();
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = hp.ExecDataTable("dbo.usp_GetJsonFormatCalcLiabilityFeesAndInterest");
            foreach (DataRow dr in dt.Rows)
            {
                JsonFormatCalcLiability _lbDC = new JsonFormatCalcLiability();
                _lbDC.JsonFormatCalcLiabilityID = Convert.ToInt32(dr["JsonFormatCalcLiabilityFeesAndInterestID"]);
                _lbDC.Position = Convert.ToString(dr["Position"]);
                _lbDC.Key = Convert.ToString(dr["Key"]);
                _lbDC.KeyFormat = Convert.ToString(dr["KeyFormat"]);
                _lbDC.DataType = Convert.ToString(dr["DataType"]);
                _lbDC.IsActive = Convert.ToBoolean(dr["IsActive"]);
                _lbDC.ParentID = CommonHelper.ToInt32(dr["ParentID"]);
                _lbDC.FilterBy = Convert.ToString(dr["FilterBy"]);
                _lbDC.DynamicField = Convert.ToString(dr["DynamicField"]);
                _lbDC.DynamicFieldValue = Convert.ToString(dr["DynamicFieldValue"]);
                _lbDC.IsOptional = Convert.ToBoolean(dr["IsOptional"]);

                lstresult.Add(_lbDC);
            }
            return lstresult;
        }

        public DataSet GetLiabilityFeesAndInterestCalcRequestData(string userID, String fundIDorName, string analysisID)
        {
            DataSet ds = new DataSet();
            try
            {

                Helper.Helper hp = new Helper.Helper();
                //SqlParameter p0 = new SqlParameter { ParameterName = "@UserID", Value = userID };
                SqlParameter p0 = new SqlParameter { ParameterName = "@FundIdOrName", Value = fundIDorName };
                SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = new Guid(analysisID) };

                SqlParameter[] sqlparam = new SqlParameter[] { p0, p1 };
                ds = hp.ExecDataSet("usp_GetCalcJsonByFundNameForFeesAndInterest", sqlparam);
                DataTable dtTableInfo = new DataTable();

                dtTableInfo = ds.Tables[ds.Tables.Count - 1];
                dtTableInfo.TableName = "json_info";

                for (int i = 0; i <= ds.Tables.Count - 2; i++)
                {
                    ds.Tables[i].TableName = dtTableInfo.Rows[i]["Name"].ToString();
                }

            }
            catch (Exception ex)
            {
            }
            return ds;
        }

        public bool QueueLiabilityForCalculation(List<CalculationRequestsLiabilityDataContract> list, string username)
        {
            bool status;
            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dList = new DataTable();
                dList.Columns.Add("AnalysisID");
                dList.Columns.Add("AccountId");
                dList.Columns.Add("CalcEngineType");
                dList.Columns.Add("CalcType");
                dList.Columns.Add("UserName");
                dList.Columns.Add("StatusText");

                if (list != null)
                {
                    DataTable dt = new DataTable();
                    dt = ObjToDataTable.ToDataTable(list);
                    foreach (DataRow dr in dt.Rows)
                    {
                        dList.ImportRow(dr);
                    }
                }
                if (dList.Rows.Count > 0)
                {
                  
                   hp.ExecuteDatatable("dbo.usp_QueueLiabilityForCalculation", "TableTypeCalculationRequestsLiability", dList, username, username);
                }

                status = true;
            }
            catch (Exception ex)
            {
                status = false;
                throw;              
            }

            return status;
        }

        public void UpdateCalculationStatusandTime(string calcid, string statustext, string columnname, string errmsg,string requestId, int calculationModeID)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@CalculationRequestsID", Value = calcid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@StatusText", Value = statustext };
            SqlParameter p3 = new SqlParameter { ParameterName = "@ColumnName", Value = columnname };
            SqlParameter p4 = new SqlParameter { ParameterName = "@ErrorMessage", Value = errmsg };
            SqlParameter p5 = new SqlParameter { ParameterName = "@RequestId", Value = requestId };
            SqlParameter p6 = new SqlParameter { ParameterName = "@CalculationModeID", Value = calculationModeID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4,p5,p6};
            hp.ExecNonquery("dbo.usp_UpdateCalculationStatusAndTime_CalculationRequestsLiability", sqlparam);

        }

        public List<LiabilityCalcDataContract> GetCalculationStaus(Guid analysisID)
        {
            List<LiabilityCalcDataContract> list = new List<LiabilityCalcDataContract>();

            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = analysisID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_RefreshCalculationRequestsLiability", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    LiabilityCalcDataContract devd = new DataContract.LiabilityCalcDataContract();
                    devd.AccountID = CommonHelper.ToGuid(dr["AccountID"]);
                    devd.LiabilityName = Convert.ToString(dr["LiabilityName"]);
                    devd.CalcStatus = Convert.ToString(dr["StatusText"]);
                    //devd.value = CommonHelper.ToInt32(dr["Count"]);
                    devd.StartTime = CommonHelper.ToDateTime(dr["StartTime"]);
                    devd.EndTime = CommonHelper.ToDateTime(dr["EndTime"]);
                    devd.ErrorMessage = (dr["ErrorMessage"]).ToString();
                    devd.LiabilityID = (dr["EquityGUID"]).ToString();
                    devd.RequestTime = CommonHelper.ToDateTime(dr["RequestTime"]);
                    list.Add(devd);
                }
                return list;
            }
            catch (Exception ex)
            {
                throw new Exception("error in LiabilityCalc Summary" + ex.Message);
            }
        }

        public List<LiabilityCalcDataContract> GetLiabilityCalculationStatusForDashBoard(Guid analysisID)
        {
            List<LiabilityCalcDataContract> list = new List<LiabilityCalcDataContract>();

            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = analysisID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetLiabilityCalculationStatusForDashBoard", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    LiabilityCalcDataContract devd = new DataContract.LiabilityCalcDataContract();

                    devd.Name = Convert.ToString(dr["Name"]);
                    devd.IsChart = Convert.ToString(dr["IsChart"]);
                    devd.Count = CommonHelper.ToInt32(dr["Count"]);
                    devd.Date = CommonHelper.ToDateTime(dr["Date"]);

                    list.Add(devd);
                }
                return list;
            }
            catch (Exception ex)
            {
                throw new Exception("error in Liability Calc Dashboard Summary" + ex.Message);
            }
        }

        public DataTable GetLiabilitySummaryDashBoard()
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();
                dt = hp.ExecDataTable("dbo.usp_GetFundFacilityLiabilityRelationSummary", null);

                return dt;
            }
            catch (Exception ex)
            {
                throw;// new Exception("error in Liability Summary " + ex.Message);
            }
        }

        public DataSet GetLiabilityFeesCalcRequestData(string userID, String fundIDorName, string analysisID)
        {
            DataSet ds = new DataSet();
            try
            {

                Helper.Helper hp = new Helper.Helper();
                //SqlParameter p0 = new SqlParameter { ParameterName = "@UserID", Value = userID };
                SqlParameter p0 = new SqlParameter { ParameterName = "@FundIdOrName", Value = fundIDorName };
                SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = new Guid(analysisID) };

                SqlParameter[] sqlparam = new SqlParameter[] { p0, p1 };
                ds = hp.ExecDataSet("usp_GetCalcJsonByFundNameForFeesOnly", sqlparam);
                DataTable dtTableInfo = new DataTable();

                dtTableInfo = ds.Tables[ds.Tables.Count - 1];
                dtTableInfo.TableName = "json_info";

                for (int i = 0; i <= ds.Tables.Count - 2; i++)
                {
                    ds.Tables[i].TableName = dtTableInfo.Rows[i]["Name"].ToString();
                }

            }
            catch (Exception ex)
            {
            }
            return ds;
        }
    }
}
