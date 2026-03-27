using CRES.DAL.IRepository;
using CRES.DAL.IRepository;
using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

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

                md.MaturityScenarioOverrideText = Convert.ToString(dr["MaturityScenarioOverrideText"]);
                md.IndexScenarioOverrideText = Convert.ToString(dr["IndexScenarioOverrideText"]);
                md.ExcludedForcastedPrePaymentText = Convert.ToString(dr["ExcludedForcastedPrePaymentText"]);
                md.UseActualsText = Convert.ToString(dr["UseActualsText"]);
                md.CalcEngineTypeText = Convert.ToString(dr["CalcEngineTypeText"]);
                md.AllowCalcAlongWithDefaultText = Convert.ToString(dr["AllowCalcAlongWithDefaultText"]);
                md.ScenarioStatus = CommonHelper.ToInt32(dr["ScenarioStatus"]);
                md.ScenarioStatusText = Convert.ToString(dr["ScenarioStatusText"]);
                md.AllowCalcOverride = CommonHelper.ToInt32(dr["AllowCalcOverride"]);
                md.AllowCalcOverrideText = Convert.ToString(dr["AllowCalcOverrideText"]);
                md.IncludeProjectedPrincipalWriteoff = CommonHelper.ToInt32(dr["IncludeProjectedPrincipalWriteoff"]);
                md.IncludeProjectedPrincipalWriteoffText = Convert.ToString(dr["IncludeProjectedPrincipalWriteoffText"]);
                md.LastCalculatedDate = CommonHelper.ToDateTime(dr["LastCalculatedDate"]);
                md.IncludeInDiscrepancyText = Convert.ToString(dr["IncludeInDiscrepancyText"]);

                list.Add(md);
            }

            return list;
        }

        public ScenarioParameterDataContract GetScenarioParameterByScenarioID(string scenarioID, Guid userID)
        {
            try
            {
                DataTable dt = new DataTable();
                ScenarioParameterDataContract spdc = new ScenarioParameterDataContract();
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = scenarioID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetScenarioParameterByScenarioID", sqlparam);

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
                    spdc.CalculationFrequency = CommonHelper.ToInt32(dt.Rows[0]["CalculationFrequency"]);
                    spdc.CalculationFrequencyText = Convert.ToString(dt.Rows[0]["CalculationFrequencyText"]);
                    spdc.CalcEngineType = CommonHelper.ToInt32(dt.Rows[0]["CalcEngineType"]);
                    spdc.CalcEngineTypeText = Convert.ToString(dt.Rows[0]["CalcEngineTypeText"]);
                    spdc.AllowCalcOverride = CommonHelper.ToInt32(dt.Rows[0]["AllowCalcOverride"]);
                    spdc.AllowCalcAlongWithDefault = CommonHelper.ToInt32(dt.Rows[0]["AllowCalcAlongWithDefault"]);
                    spdc.AllowCalcAlongWithDefaultText = Convert.ToString(dt.Rows[0]["AllowCalcAlongWithDefaultText"]);

                    spdc.AccountingClose = CommonHelper.ToInt32(dt.Rows[0]["AccountingClose"]);
                    spdc.AccountingCloseText = Convert.ToString(dt.Rows[0]["AccountingCloseText"]);
                    spdc.IncludeProjectedPrincipalWriteoff = CommonHelper.ToInt32(dt.Rows[0]["IncludeProjectedPrincipalWriteoff"]);
                    spdc.IncludeProjectedPrincipalWriteoffText = Convert.ToString(dt.Rows[0]["IncludeProjectedPrincipalWriteoffText"]);
                    spdc.CalculateLiability = CommonHelper.ToInt32(dt.Rows[0]["CalculateLiability"]);
                    spdc.CalculateLiabilityText = Convert.ToString(dt.Rows[0]["CalculateLiabilityText"]);
                    spdc.ScenarioStatus = CommonHelper.ToInt32(dt.Rows[0]["ScenarioStatus"]);
                    spdc.ScenarioStatusText = Convert.ToString(dt.Rows[0]["ScenarioStatusText"]);
                    spdc.UseFinancingMaturityDateOverride = CommonHelper.ToInt32(dt.Rows[0]["UseFinancingMaturityDateOverride"]);
                    spdc.UseFinancingMaturityDateOverrideText = Convert.ToString(dt.Rows[0]["UseFinancingMaturityDateOverrideText"]);
                    spdc.UseMaturityAdjustmentMonths = CommonHelper.ToInt32(dt.Rows[0]["UseMaturityAdjustmentMonths"]);
                    spdc.UseMaturityAdjustmentMonthsText = Convert.ToString(dt.Rows[0]["UseMaturityAdjustmentMonthsText"]);

                    spdc.IncludeInDiscrepancy = CommonHelper.ToInt32(dt.Rows[0]["IncludeInDiscrepancy"]);
                    spdc.IncludeInDiscrepancyText = Convert.ToString(dt.Rows[0]["IncludeInDiscrepancyText"]);

                    spdc.LastCalculatedDate = CommonHelper.ToDateTime(dt.Rows[0]["LastCalculatedDate"]);

                    spdc.OperationMode = Convert.ToString(dt.Rows[0]["OperationMode"]);
                    spdc.EqDelayMonths = CommonHelper.ToInt32(dt.Rows[0]["EqDelayMonths"]);
                    spdc.FinDelayMonths = CommonHelper.ToInt32(dt.Rows[0]["FinDelayMonths"]);
                    spdc.MinEqBalForFinStart = CommonHelper.ToDouble(dt.Rows[0]["MinEqBalForFinStart"]);
                    spdc.SublineEqApplyMonths = CommonHelper.ToInt32(dt.Rows[0]["SublineEqApplyMonths"]);
                    spdc.SublineFinApplyMonths = CommonHelper.ToInt32(dt.Rows[0]["SublineFinApplyMonths"]);
                    spdc.DebtCallDaysOfTheMonth = CommonHelper.ToInt32(dt.Rows[0]["DebtCallDaysOfTheMonth"]);
                    spdc.CapitalCallDaysOfTheMonth = CommonHelper.ToInt32(dt.Rows[0]["CapitalCallDaysOfTheMonth"]);

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
                SqlParameter p7 = new SqlParameter { ParameterName = "@ScenarioStatus", Value = Scenaridc.ScenarioStatus };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7 };
                hp.ExecNonquery("dbo.usp_AddUpdateScenario", sqlparam);

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

                    SqlParameter q13 = new SqlParameter { ParameterName = "@CalculationFrequency", Value = Scenaridc.CalculationFrequency };
                    SqlParameter q14 = new SqlParameter { ParameterName = "@CalcEngineType", Value = Scenaridc.CalcEngineType };
                    SqlParameter q15 = new SqlParameter { ParameterName = "@AllowCalcOverride", Value = Scenaridc.AllowCalcOverride };
                    SqlParameter q16 = new SqlParameter { ParameterName = "@AllowCalcAlongWithDefault", Value = Scenaridc.AllowCalcAlongWithDefault };
                    SqlParameter q17 = new SqlParameter { ParameterName = "@AccountingClose", Value = Scenaridc.AccountingClose };
                    SqlParameter q18 = new SqlParameter { ParameterName = "@IncludeProjectedPrincipalWriteoff", Value = Scenaridc.IncludeProjectedPrincipalWriteoff };
                    SqlParameter q19 = new SqlParameter { ParameterName = "@CalculateLiability", Value = Scenaridc.CalculateLiability };
                    SqlParameter q20 = new SqlParameter { ParameterName = "@UseFinancingMaturityDateOverride", Value = Scenaridc.UseFinancingMaturityDateOverride };
                    SqlParameter q21 = new SqlParameter { ParameterName = "@UseMaturityAdjustmentMonths", Value = Scenaridc.UseMaturityAdjustmentMonths };
                    SqlParameter q22 = new SqlParameter { ParameterName = "@IncludeInDiscrepancy", Value = Scenaridc.IncludeInDiscrepancy };

                    SqlParameter q23 = new SqlParameter { ParameterName = "@OperationMode", Value = Scenaridc.OperationMode };
                    SqlParameter q24 = new SqlParameter { ParameterName = "@EqDelayMonths", Value = Scenaridc.EqDelayMonths };
                    SqlParameter q25 = new SqlParameter { ParameterName = "@FinDelayMonths", Value = Scenaridc.FinDelayMonths };
                    SqlParameter q26 = new SqlParameter { ParameterName = "@MinEqBalForFinStart", Value = Scenaridc.MinEqBalForFinStart };
                    SqlParameter q27 = new SqlParameter { ParameterName = "@SublineEqApplyMonths", Value = Scenaridc.SublineEqApplyMonths };
                    SqlParameter q28 = new SqlParameter { ParameterName = "@SublineFinApplyMonths", Value = Scenaridc.SublineFinApplyMonths };
                    SqlParameter q29 = new SqlParameter { ParameterName = "@DebtCallDaysOfTheMonth", Value = Scenaridc.DebtCallDaysOfTheMonth };
                    SqlParameter q30 = new SqlParameter { ParameterName = "@CapitalCallDaysOfTheMonth", Value = Scenaridc.CapitalCallDaysOfTheMonth };

                    SqlParameter[] sqlparam1 = new SqlParameter[] { q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15, q16, q17, q18, q19, q20, q21, q22, q23, q24, q25, q26, q27, q28, q29, q30 };
                    res = hp.ExecNonquery("dbo.usp_AddUpdateScenarioParaMeters", sqlparam1);


                }

                result = res == -1 ? "TRUE" : "FALSE";


                return NewScenarioID;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public void UpdateScenarioToInactive(string id)
        {
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
        }

        public DataTable GetIndexByScenarioID(string headerUserID, string scenarioID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            DataTable dt = new DataTable();
            int tcount = 0;
            //  ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
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
            TotalCount = tcount;
            return dt;
        }


        public DataTable GetIndexesFromDate(ScenariosearchDataContract _ScenariosearchDc, string headerUserID, out int? TotalCount)
        {
            DataTable dt = new DataTable();
            DataTable newdt = new DataTable();
            int tcount = 0;
            // ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
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
            TotalCount = tcount;
            if (dt.Rows.Count == 1)
                return newdt;
            else
                return dt;


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
                    spdc.IncludeProjectedPrincipalWriteoff = CommonHelper.ToInt32(dt.Rows[0]["IncludeProjectedPrincipalWriteoff"]);
                    spdc.IncludeProjectedPrincipalWriteoffText = Convert.ToString(dt.Rows[0]["IncludeProjectedPrincipalWriteoffText"]);

                    spdc.UseMaturityAdjustmentMonths = CommonHelper.ToInt32(dt.Rows[0]["UseMaturityAdjustmentMonths"]);
                    spdc.UseMaturityAdjustmentMonthsText = Convert.ToString(dt.Rows[0]["UseMaturityAdjustmentMonthsText"]);



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
                md.CalcEngineType = CommonHelper.ToInt32(dr["CalcEngineType"]);
                md.CalculationModeID = CommonHelper.ToInt32(dr["CalculationMode"]);
                md.CalculationModeText = Convert.ToString(dr["CalculationModeText"]);
                md.AllowDebugInCalc = Convert.ToString(dr["AllowDebugInCalc"]) == "1" ? true : false;
                md.ScenarioStatus = CommonHelper.ToInt32(dr["ScenarioStatus"]);
                md.ScenarioStatusText = Convert.ToString(dr["ScenarioStatusText"]);
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

        public void InsertActivityLogDetail(DataTable ActivityLogDetail)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@tblActivityLogDetail", Value = ActivityLogDetail };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            hp.ExecDataTablewithparams("dbo.usp_InsertActivityLogDetail", sqlparam);
        }
    }
}
