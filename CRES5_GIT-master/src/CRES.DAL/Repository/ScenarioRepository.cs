using CRES.DAL.IRepository;
#pragma warning disable CS0105 // The using directive for 'CRES.DAL.IRepository' appeared previously in this namespace
#pragma warning restore CS0105 // The using directive for 'CRES.DAL.IRepository' appeared previously in this namespace
using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace CRES.DAL.Repository
{
    public class ScenarioRepository : IScenarioRepository
    {


        public List<ScenarioParameterDataContract> GetAllScenario(string userid, int pageIndex, int pageSize, out int? TotalCount)
        {
            DataTable dt = new DataTable();
            List<ScenarioParameterDataContract> list = new List<ScenarioParameterDataContract>();
            Helper.Helper hp = new Helper.Helper();
            Guid userId = new Guid(userid);
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@PgeIndex", Value = pageIndex };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p4 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            dt = hp.ExecDataTable("dbo.usp_GetAllScenario", sqlparam);

            // ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
            // var lstscenario = dbContext.usp_GetAllScenario(userId, pageIndex, pageSize, totalCount).ToList();
            TotalCount = string.IsNullOrEmpty(Convert.ToString(p4.Value)) ? 0 : Convert.ToInt32(p4.Value);

            foreach (DataRow dr in dt.Rows)
            {
                ScenarioParameterDataContract md = new ScenarioParameterDataContract();
                md.AnalysisID = Convert.ToString(dr["AnalysisID"]);
                md.Description = Convert.ToString(dr["Description"]);
                md.ScenarioName = Convert.ToString(dr["Name"]);
                md.StatusID = CommonHelper.ToInt32(dr["StatusID"]);
                md.StatusIDText = Convert.ToString(dr["StatusIDtext"]);
                md.TemplateName = Convert.ToString(dr["TemplateName"]);
                list.Add(md);
            }

            return list;
        }

        public ScenarioParameterDataContract GetScenarioParameterByScenarioID(string scenarioID)
        {
            try
            {
                DataTable dt = new DataTable();
                ScenarioParameterDataContract spdc = new ScenarioParameterDataContract();
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = scenarioID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetScenarioParameterByScenarioID", sqlparam);
                //  var res = dbContext.usp_GetScenarioParameterByScenarioID(scenarioID).FirstOrDefault();

                if (dt != null && dt.Rows.Count > 0)
                {
                    spdc.AnalysisID = Convert.ToString(dt.Rows[0]["AnalysisID"]);
                    spdc.Description = Convert.ToString(dt.Rows[0]["Description"]);
                    spdc.ScenarioName = Convert.ToString(dt.Rows[0]["Name"]);
                    spdc.AnalysisParameterID = Convert.ToString(dt.Rows[0]["AnalysisParameterID"]);
                    spdc.MaturityAdjustment = CommonHelper.ToInt32(dt.Rows[0]["MaturityAdjustment"]);
                    spdc.MaturityScenarioOverrideID = CommonHelper.ToInt32(dt.Rows[0]["MaturityScenarioOverrideID"]);
                    spdc.MaturityScenarioOverrideText = Convert.ToString(dt.Rows[0]["MaturityAdjustmentText"]);

                    spdc.FunctionName = Convert.ToString(dt.Rows[0]["FunctionName"]);
                    spdc.IndexScenarioOverride = CommonHelper.ToInt32(dt.Rows[0]["IndexScenarioOverride"]);
                    spdc.IndexScenarioOverrideText = Convert.ToString(dt.Rows[0]["IndexScenarioOverrideText"]);
                    spdc.CalculationMode = CommonHelper.ToInt32(dt.Rows[0]["CalculationMode"]);
                    spdc.CalculationModeText = Convert.ToString(dt.Rows[0]["CalculationModeText"]);
                    spdc.ExcludedForcastedPrePayment = CommonHelper.ToInt32(dt.Rows[0]["ExcludedForcastedPrePayment"]);
                    spdc.ExcludedForcastedPrePaymentText = Convert.ToString(dt.Rows[0]["ExcludedForcastedPrePaymentText"]);
                    spdc.AutoCalcFreq = CommonHelper.ToInt32(dt.Rows[0]["AutoCalcFreq"]);
                    spdc.AutoCalcFreqText = Convert.ToString(dt.Rows[0]["AutoCalcFreqText"]);
                    spdc.UseActuals = CommonHelper.ToInt32(dt.Rows[0]["UseActuals"]);
                    spdc.UseActualsText = Convert.ToString(dt.Rows[0]["UseActualsText"]);
                    spdc.DisableBusinessDayAdjustment = CommonHelper.ToInt32(dt.Rows[0]["UseBusinessDayAdjustment"]);
                    spdc.DisableBusinessDayAdjustmentText = Convert.ToString(dt.Rows[0]["UseBusinessDayAdjustmentText"]);
                    spdc.JsonTemplateMasterID = CommonHelper.ToInt32(dt.Rows[0]["JsonTemplateMasterID"]);
                }
                return spdc;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public string InsertUpdateScenario(ScenarioParameterDataContract Scenaridc)
        {
            string result = "";
            int res = 0;
            Helper.Helper hp = new Helper.Helper();
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {

                string NewScenarioID;
                // ObjectParameter newScenarioID = new ObjectParameter("NewScenarioID", typeof(string));
                SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = Scenaridc.AnalysisID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@Name", Value = Scenaridc.ScenarioName };
                SqlParameter p3 = new SqlParameter { ParameterName = "@Description", Value = Scenaridc.Description };
                SqlParameter p4 = new SqlParameter { ParameterName = "@UserName", Value = Scenaridc.UpdatedBy };
                SqlParameter p5 = new SqlParameter { ParameterName = "@ActionStatus", Value = Scenaridc.ActionStatus };
                SqlParameter p6 = new SqlParameter { ParameterName = "@newScenarioID", Direction = ParameterDirection.Output, Size = int.MaxValue };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6 };
                hp.ExecNonquery("dbo.usp_AddUpdateScenario", sqlparam);
                //var res = dbContext.usp_AddUpdateScenario(
                //    Scenaridc.AnalysisID,
                //    Scenaridc.ScenarioName,
                //    Scenaridc.Description,
                //    Scenaridc.UpdatedBy,
                //    Scenaridc.ActionStatus,
                //    newScenarioID

                // );

                NewScenarioID = Convert.ToString(p6.Value);

                if (NewScenarioID != "")
                {
                    Scenaridc.AnalysisID = NewScenarioID;
                }

                if (Scenaridc.AnalysisID != null)
                {

                    SqlParameter q1 = new SqlParameter { ParameterName = "@AnalysisID", Value = Scenaridc.AnalysisID };
                    SqlParameter q2 = new SqlParameter { ParameterName = "@MaturityScenarioOverrideID", Value = Scenaridc.MaturityScenarioOverrideID };
                    SqlParameter q3 = new SqlParameter { ParameterName = "@MaturityAdjustment", Value = Scenaridc.MaturityAdjustment };
                    SqlParameter q4 = new SqlParameter { ParameterName = "@UserName", Value = Scenaridc.UpdatedBy };
                    SqlParameter q5 = new SqlParameter { ParameterName = "@FunctionName", Value = Scenaridc.FunctionName };
                    SqlParameter q6 = new SqlParameter { ParameterName = "@IndexScenarioOverride", Value = Scenaridc.IndexScenarioOverride };
                    SqlParameter q7 = new SqlParameter { ParameterName = "@CalculationMode", Value = Scenaridc.CalculationMode };
                    SqlParameter q8 = new SqlParameter { ParameterName = "@ExcludedForcastedPrePayment", Value = Scenaridc.ExcludedForcastedPrePayment };
                    SqlParameter q9 = new SqlParameter { ParameterName = "@AutoCalcFreq", Value = Scenaridc.AutoCalcFreq };
                    SqlParameter q10 = new SqlParameter { ParameterName = "@UseActuals", Value = Scenaridc.UseActuals };
                    SqlParameter q11 = new SqlParameter { ParameterName = "@UseBusinessDayAdjustment", Value = Scenaridc.DisableBusinessDayAdjustment };
                    SqlParameter q12 = new SqlParameter { ParameterName = "@JsonTemplateMasterID", Value = Scenaridc.JsonTemplateMasterID };

                    SqlParameter[] sqlparam1 = new SqlParameter[] { q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12 };
                    res = hp.ExecNonquery("dbo.usp_AddUpdateScenarioParaMeters", sqlparam1);

                    //   dbContext.usp_AddUpdateScenarioParaMeters(
                    //   Scenaridc.AnalysisID,
                    //   Scenaridc.MaturityScenarioOverrideID,
                    //   Scenaridc.MaturityAdjustment,
                    //   Scenaridc.UpdatedBy,
                    //   Scenaridc.FunctionName,
                    //   Scenaridc.IndexScenarioOverride,
                    //   Scenaridc.CalculationMode,
                    //   Scenaridc.ExcludedForcastedPrePayment,
                    //    Scenaridc.AutoCalcFreq
                    //);
                }

                result = res == -1 ? "TRUE" : "FALSE";


                return result;
            }
            catch (Exception ex)
            {
                throw;
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
        }

        public void UpdateScenarioToInactive(string id)
        {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                DataTable dt = new DataTable();
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = id };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                hp.ExecNonquery("dbo.usp_UpdateScenarioToInactive", sqlparam);
                // var res = dbContext.usp_UpdateScenarioToInactive(id);
            }
            catch (Exception ex)
            {
                throw;
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
        }

        public DataTable GetIndexByScenarioID(string headerUserID, string scenarioID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            DataTable dt = new DataTable();
            int tcount = 0;
            //  ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p0 = new SqlParameter { ParameterName = "@UserID", Value = new Guid(headerUserID) };
                SqlParameter p1 = new SqlParameter { ParameterName = "@ScenarioID", Value = new Guid(scenarioID) };
                SqlParameter p2 = new SqlParameter { ParameterName = "@PgeIndex", Value = pageIndex };
                SqlParameter p3 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
                SqlParameter p4 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter[] sqlparam = new SqlParameter[] { p0, p1, p2, p3, p4 };
                dt = hp.ExecDataTable("dbo.usp_GetScenarioByScenarioID", sqlparam);
                if (dt.Rows.Count == 0)
                {
                    dt.Rows.Add();
                    dt.Rows[0][0] = DateTime.Now.ToShortDateString();
                    for (int i = 1; i < dt.Columns.Count; i++)
                    {
                        dt.Rows[0][i] = "";
                    }
                }

                tcount = string.IsNullOrEmpty(Convert.ToString(p4.Value)) ? 0 : Convert.ToInt32(p4.Value);
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            TotalCount = tcount;
            return dt;
        }


        public DataTable GetIndexesFromDate(ScenariosearchDataContract _ScenariosearchDc, string headerUserID, out int? TotalCount)
        {
            DataTable dt = new DataTable();
            DataTable newdt = new DataTable();
            int tcount = 0;
            // ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p0 = new SqlParameter { ParameterName = "@UserID", Value = new Guid(headerUserID) };
                SqlParameter p1 = new SqlParameter { ParameterName = "@ScenarioID", Value = new Guid(_ScenariosearchDc.AnalysisID) };
                SqlParameter p2 = new SqlParameter { ParameterName = "@Fromdate", Value = _ScenariosearchDc.Fromdate };
                SqlParameter p3 = new SqlParameter { ParameterName = "@Todate", Value = _ScenariosearchDc.Todate };
                SqlParameter p4 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter[] sqlparam = new SqlParameter[] { p0, p1, p2, p3, p4 };
                dt = hp.ExecDataTable("dbo.usp_IndexesBydates", sqlparam);

                tcount = string.IsNullOrEmpty(Convert.ToString(p4.Value)) ? 0 : Convert.ToInt32(p4.Value);
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            TotalCount = tcount;
            if (dt.Rows.Count == 1)
                return newdt;
            else
                return dt;


        }

        public DataTable GetIndexesExportData(ScenariosearchDataContract _ScenariosearchDc, string headerUserID, out int? TotalCount)
        {
            DataTable dt = new DataTable();
            DataTable newdt = new DataTable();
            int tcount = 0;
            //  ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p0 = new SqlParameter { ParameterName = "@UserID", Value = new Guid(headerUserID) };
                SqlParameter p1 = new SqlParameter { ParameterName = "@ScenarioID", Value = new Guid(_ScenariosearchDc.AnalysisID) };
                SqlParameter p2 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter[] sqlparam = new SqlParameter[] { p0, p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetIndexesExportData", sqlparam);

                tcount = string.IsNullOrEmpty(Convert.ToString(p2.Value)) ? 0 : Convert.ToInt32(p2.Value);
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            TotalCount = tcount;
            if (dt.Rows.Count == 1)
                return newdt;
            else
                return dt;


        }


        public void ResetDefaultToActiveScenario(string username)
        {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                //DataTable dt = new DataTable();
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserName", Value = username };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                hp.ExecNonquery("dbo.usp_ResetActiveToDefaultScenario", sqlparam);
                //var res = dbContext.usp_ResetActiveToDefaultScenario(username);
            }
            catch (Exception ex)
            {
                throw;
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
        }
        public bool CheckDuplicateScenarioName(string id, string name)
        {
            Guid scenrioaid = new Guid(id);

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@ScenarioID", Value = scenrioaid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@ScenarioName", Value = name };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            var res = hp.ExecuteScalar("DBO.usp_CheckDuplicatescenario", sqlparam);
            //  var res = dbContext.usp_CheckDuplicatescenario(scenrioaid,name).FirstOrDefault();

            return string.IsNullOrEmpty(Convert.ToString(res)) ? false : Convert.ToBoolean(res);
            // return Convert.ToBoolean(res);
        }

        public ScenarioParameterDataContract GetActiveScenarioParameters(Guid? AnalysisID)
        {
            try
            {
                DataTable dt = new DataTable();
                ScenarioParameterDataContract spdc = new ScenarioParameterDataContract();
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };


                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetActiveScenario", sqlparam);
                // var res = dbContext.usp_GetActiveScenario(AnalysisID).FirstOrDefault();

                if (dt != null && dt.Rows.Count > 0)
                {
                    spdc.AnalysisID = Convert.ToString(dt.Rows[0]["AnalysisID"]);
                    spdc.ScenarioName = Convert.ToString(dt.Rows[0]["Name"]);
                    spdc.AnalysisParameterID = Convert.ToString(dt.Rows[0]["AnalysisParameterID"]);
                    spdc.MaturityAdjustment = CommonHelper.ToInt32(dt.Rows[0]["MaturityAdjustment"]);
                    spdc.MaturityScenarioOverrideID = CommonHelper.ToInt32(dt.Rows[0]["MaturityScenarioOverrideID"]);
                    spdc.MaturityScenarioOverrideText = Convert.ToString(dt.Rows[0]["MaturityScenarioOverrideText"]);
                    spdc.ExcludedForcastedPrePayment = CommonHelper.ToInt32(dt.Rows[0]["ExcludedForcastedPrePayment"]);
                    spdc.ExcludedForcastedPrePaymentText = Convert.ToString(dt.Rows[0]["ExcludedForcastedPrePaymentText"]);
                    spdc.CalculationMode = CommonHelper.ToInt32(dt.Rows[0]["CalculationMode"]);
                    spdc.CalculationModeText = Convert.ToString(dt.Rows[0]["CalculationModeText"]);
                    spdc.UseActuals = CommonHelper.ToInt32(dt.Rows[0]["UseActuals"]);
                    spdc.UseActualsText = Convert.ToString(dt.Rows[0]["UseActualsText"]);
                    spdc.DisableBusinessDayAdjustment = CommonHelper.ToInt32(dt.Rows[0]["UseBusinessDayAdjustment"]);
                    spdc.DisableBusinessDayAdjustmentText = Convert.ToString(dt.Rows[0]["UseBusinessDayAdjustmentText"]);
                    spdc.JsonTemplateMasterID = CommonHelper.ToInt32(dt.Rows[0]["JsonTemplateMasterID"]);
                }
                return spdc;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public string InsertUpdateScenarioUserMap(ScenarioUserMapDataContract Scenaridc)
        {
            string result = "";

#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = Scenaridc.AnalysisID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = Scenaridc.UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                var res = hp.ExecNonquery("dbo.usp_InsertUpdateScenarioUserMap", sqlparam);
                //var res = dbContext.usp_InsertUpdateScenarioUserMap(
                //    Scenaridc.AnalysisID,
                //    Scenaridc.UserID
                // );

                //   result = "TRUE";
                result = res == -1 ? "TRUE" : "FALSE";

                return result;
            }
            catch (Exception ex)
            {
                throw;
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
        }




        public ScenarioUserMapDataContract GetScenarioUserMapByUserID(string UserID)
        {
            try
            {
                DataTable dt = new DataTable();
                ScenarioUserMapDataContract spdc = new ScenarioUserMapDataContract();
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetScenarioUserMapByUserID", sqlparam);
                // var res = dbContext.usp_GetScenarioUserMapByUserID(UserID).FirstOrDefault();

                if (dt != null && dt.Rows.Count > 0)
                {


                    if (Convert.ToString(dt.Rows[0]["ScenarioUserMapID"]) != "")
                    {
                        spdc.ScenarioUserMapID = new Guid(Convert.ToString(dt.Rows[0]["ScenarioUserMapID"]));
                    }
                    if (Convert.ToString(dt.Rows[0]["AnalysisID"]) != "")
                    {
                        spdc.AnalysisID = new Guid(Convert.ToString(dt.Rows[0]["AnalysisID"]));
                    }
                    spdc.UserID = Convert.ToString(dt.Rows[0]["UserID"]);
                    spdc.CreatedBy = Convert.ToString(dt.Rows[0]["CreatedBy"]);
                    spdc.CreatedDate = CommonHelper.ToDateTime(dt.Rows[0]["CreatedDate"]);
                    spdc.UpdatedBy = Convert.ToString(dt.Rows[0]["UpdatedBy"]);
                    spdc.UpdatedDate = CommonHelper.ToDateTime(dt.Rows[0]["UpdatedDate"]);
                    spdc.ScenarioColor = Convert.ToString(dt.Rows[0]["ScenarioColor"]);
                    spdc.CalculationModeID = CommonHelper.ToInt32(dt.Rows[0]["CalculationMode"]);
                    spdc.CalculationModeText = Convert.ToString(dt.Rows[0]["CalculationModeText"]);
                    spdc.ScenarioName = Convert.ToString(dt.Rows[0]["ScenarioName"]);
                }
                return spdc;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public List<ScenarioUserMapDataContract> GetAllScenarioDistinct(string userid)
        {
            DataTable dt = new DataTable();
            List<ScenarioUserMapDataContract> list = new List<ScenarioUserMapDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userid };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetAllScenarioDistinct", sqlparam);
            //ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
            // var lstscenario = dbContext.usp_GetAllScenarioDistinct(userid).ToList();

            foreach (DataRow dr in dt.Rows)
            {
                ScenarioUserMapDataContract md = new ScenarioUserMapDataContract();
                if (Convert.ToString(dr["AnalysisID"]) != "")
                {
                    md.AnalysisID = new Guid(Convert.ToString(dr["AnalysisID"]));
                }
                md.Description = Convert.ToString(dr["Description"]);
                md.ScenarioName = Convert.ToString(dr["Name"]);
                md.ScenarioColor = Convert.ToString(dr["ScenarioColor"]);

                md.CalculationModeID = CommonHelper.ToInt32(dr["CalculationMode"]);
                md.CalculationModeText = Convert.ToString(dr["CalculationModeText"]);
                md.AllowDebugInCalc = Convert.ToString(dr["AllowDebugInCalc"]) == "1" ? true : false;
                list.Add(md);
            }

            return list;
        }

        public DataTable GetScenarioDownload(ScenariosearchDataContract _ScenariosearchDc, string headerUserID, out int? TotalCount)
        {
            DataTable dt = new DataTable();
            DataTable newdt = new DataTable();
            int tcount = 0;
            //  ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p0 = new SqlParameter { ParameterName = "@UserID", Value = new Guid(headerUserID) };
                SqlParameter p1 = new SqlParameter { ParameterName = "@ScenarioID", Value = new Guid(_ScenariosearchDc.AnalysisID) };
                SqlParameter p2 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter[] sqlparam = new SqlParameter[] { p0, p1, p2 };
                dt = hp.ExecDataTable("DBO.usp_getScenarioDownload", sqlparam);

                tcount = string.IsNullOrEmpty(Convert.ToString(p2.Value)) ? 0 : Convert.ToInt32(p2.Value);
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            TotalCount = tcount;
            if (dt.Rows.Count == 1)
                return newdt;
            else
                return dt;

        }



        public DataTable DownloadCashFlowByScenarioID(string AnalysisID)
        {
            DataTable dt = new DataTable();
            DataTable newdt = new DataTable();
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p0 = new SqlParameter { ParameterName = "@NoteId", Value = new Guid("00000000-0000-0000-0000-000000000000") };
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealId", Value = new Guid("00000000-0000-0000-0000-000000000000") };
                SqlParameter p2 = new SqlParameter { ParameterName = "@ScenarioId", Value = new Guid(AnalysisID) };
                SqlParameter p3 = new SqlParameter { ParameterName = "@MultipleNoteids", Value = "" };
                SqlParameter[] sqlparam = new SqlParameter[] { p0, p1, p2, p3 };
                dt = hp.ExecDataTable("dbo.usp_GetNoteCashflowsExportData", sqlparam);


            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used

            if (dt.Rows.Count == 1)
                return newdt;
            else
                return dt;

        }
        public List<ScenarioruletypeDataContract> GetAllRuleType(Guid? userid)
        {
            Helper.Helper hp = new Helper.Helper();
            List<ScenarioruletypeDataContract> list = new List<ScenarioruletypeDataContract>();
            List<ScenarioruletypeDataContract> list1 = new List<ScenarioruletypeDataContract>();
            ScenarioruletypeDataContract _prepayDC = new ScenarioruletypeDataContract();
            DataTable dt = new DataTable();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetAllRuleType", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                ScenarioruletypeDataContract sr = new ScenarioruletypeDataContract();
                sr.RuleTypeMasterID = CommonHelper.ToInt32(dr["RuleTypeMasterID"]);
                sr.RuleTypeName = Convert.ToString(dr["RuleTypeName"]);

                //sr.RuleTypeDetailID = CommonHelper.ToInt32(dr["RuleTypeDetailID"]);
                //sr.FileName = Convert.ToString(dr["FileName"]);
                //sr.RuleTypeMasterID_Detail = CommonHelper.ToInt32(dr["RuleTypeMasterID_Detail"]);
                list.Add(sr);
            }

            return list;
        }

        public List<ScenarioruletypeDataContract> GetAllRuleTypeDetail(Guid? userid)
        {
            Helper.Helper hp = new Helper.Helper();
            List<ScenarioruletypeDataContract> list = new List<ScenarioruletypeDataContract>();
            List<ScenarioruletypeDataContract> list1 = new List<ScenarioruletypeDataContract>();
            ScenarioruletypeDataContract _prepayDC = new ScenarioruletypeDataContract();
            DataTable dt = new DataTable();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetAllRuleTypeDetail", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                ScenarioruletypeDataContract sr = new ScenarioruletypeDataContract();
                sr.RuleTypeDetailID = CommonHelper.ToInt32(dr["RuleTypeDetailID"]);
                sr.FileName = Convert.ToString(dr["FileName"]);
                sr.RuleTypeMasterID_Detail = CommonHelper.ToInt32(dr["RuleTypeMasterID"]);
                sr.RuleTypeName = Convert.ToString(dr["RuleTypeName"]);
                list.Add(sr);
            }

            return list;
        }


        public List<ScenarioruletypeDataContract> GetRuleTypeSetupbyObjectId(string Id)
        {
            DataTable dt = new DataTable();
            List<ScenarioruletypeDataContract> list = new List<ScenarioruletypeDataContract>();
            Helper.Helper hp = new Helper.Helper();

            SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = Id };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetRuleTypeSetupByAnalysisId", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                ScenarioruletypeDataContract sr = new ScenarioruletypeDataContract();
                sr.RuleTypeMasterID = CommonHelper.ToInt32(dr["RuleTypeMasterID"]);
                sr.RuleTypeName = Convert.ToString(dr["RuleTypeName"]);
                sr.RuleTypeDetailID = CommonHelper.ToInt32(dr["RuleTypeDetailID"]);
                sr.FileName = Convert.ToString(dr["FileName"]);

                list.Add(sr);

            }

            return list;
        }

        public string AddUpdateAnalysisRuleTypeSetup(List<ScenarioruletypeDataContract> lstscenarioruletype, string userid)
        {
            string NEWRuleTypeSetupID = "";
            Helper.Helper hp = new Helper.Helper();
            DataTable dtAnalysisRuleTypeSetup = new DataTable();
            dtAnalysisRuleTypeSetup.Columns.Add("AnalysisID");
            dtAnalysisRuleTypeSetup.Columns.Add("RuleTypeMasterID");
            dtAnalysisRuleTypeSetup.Columns.Add("RuleTypeDetailID");

            if (lstscenarioruletype != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(lstscenarioruletype);

                foreach (DataRow dr in dt.Rows)
                {
                    dtAnalysisRuleTypeSetup.ImportRow(dr);
                }
            }

            SqlParameter p1 = new SqlParameter { ParameterName = "@tblanalysisruletypesetup", Value = dtAnalysisRuleTypeSetup };
            SqlParameter p2 = new SqlParameter { ParameterName = "@CreatedBy", Value = userid };


            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, };
            hp.ExecNonquery("dbo.usp_AddUpdateAnalysisRuleTypeSetup", sqlparam);

            // NewDeadID = Convert.ToString(p44.Value);

            if (!string.IsNullOrEmpty(NEWRuleTypeSetupID))
                return NEWRuleTypeSetupID;
            else
                return "FALSE";
        }


        public string deleteScenariobyAnalysisID(string scenarioID, string headerUserID)
        {
            string result = "";
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = scenarioID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@Updatedby", Value = headerUserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            var res = hp.ExecNonquery("dbo.usp_DeleteScenariobyAnalysisID", sqlparam);
            result = res > 0 ? "TRUE" : "FALSE";


            return result;
        }


    }
}
