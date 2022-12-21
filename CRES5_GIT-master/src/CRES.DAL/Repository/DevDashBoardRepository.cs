using CRES.DAL.IRepository;
using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace CRES.DAL.Repository
{
    public class DevDashBoardRepository : IDevDashBoardRepository
    {
        public List<DevDashBoardDataContract> GetCalculationStaus(Guid analysisID)
        {
            List<DevDashBoardDataContract> list = new List<DevDashBoardDataContract>();

            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = analysisID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetCalculationStatusForDashBoard", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    DevDashBoardDataContract devd = new DataContract.DevDashBoardDataContract();

                    devd.value = CommonHelper.ToInt32(dr["Count"]);
                    devd.Name = Convert.ToString(dr["Name"]);
                    devd.vDate = CommonHelper.ToDateTime(dr["Date"]);
                    devd.IsChart = (dr["IsChart"]).ToString();

                    list.Add(devd);
                }
                return list;
            }
            catch (Exception ex)
            {
                throw new Exception("error in DevDashBoardRepository" + ex.Message);
            }
        }

        public List<DevDashBoardDataContract> UserRequestCount(Guid analysisID)
        {
            List<DevDashBoardDataContract> list = new List<DevDashBoardDataContract>();

            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = analysisID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_CalculationRequestCountPerUser", sqlparam);


                //     var results = dbContext.usp_CalculationRequestCountPerUser(analysisID);

                foreach (DataRow dr in dt.Rows)
                {
                    DevDashBoardDataContract devd = new DataContract.DevDashBoardDataContract();
                    devd.value = CommonHelper.ToInt32(dr["RequestCount"]);
                    devd.Name = Convert.ToString(dr["Firstname"]);
                    list.Add(devd);
                }
                return list;
            }
            catch (Exception ex)
            {
                throw new Exception("error in DevDashBoardRepository" + ex.Message);
            }
        }

        public List<DevDashBoardDataContract> GetFastestandSlowest(Guid analysisID)
        {
            List<DevDashBoardDataContract> list = new List<DevDashBoardDataContract>();
            try
            {

                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = analysisID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetFastestAndSlowest", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    DevDashBoardDataContract devd = new DataContract.DevDashBoardDataContract();
                    devd.CRENoteID = Convert.ToString(dr["crenoteid"]);
                    devd.value = CommonHelper.ToInt32(dr["time"]);
                    devd.Name = Convert.ToString(dr["type"]);
                    list.Add(devd);
                }
                return list;
            }
            catch (Exception ex)
            {
                throw new Exception("error in DevDashBoardRepository" + ex.Message);
            }
        }

        public List<DevDashBoardDataContract> GetFailedNotes(string logtype, Guid UserID)
        {
            List<DevDashBoardDataContract> list = new List<DevDashBoardDataContract>();

            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();
                SqlParameter p1 = new SqlParameter { ParameterName = "@Title", Value = logtype };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetFailedNotes", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    DevDashBoardDataContract devd = new DataContract.DevDashBoardDataContract();



                    devd.CRENoteID = Convert.ToString(dr["CREID"]);
                    if (devd.CRENoteID == "00000000-0000-0000-0000-000000000000")
                    {
                        devd.CRENoteID = null;
                    }
                    devd.NoteName = Convert.ToString(dr["CREName"]);
                    devd.RequestTime = CommonHelper.ToDateTime(dr["RequestTime"]);
                    devd.NoteID = Convert.ToString(dr["ObjectID"]);
                    devd.ErrorMessage = Convert.ToString(dr["ErrorMessage"]);

                    list.Add(devd);
                }
                return list;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<DevDashBoardDataContract> GetAIDashBoardData()
        {
            List<DevDashBoardDataContract> list = new List<DevDashBoardDataContract>();

            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();
                dt = hp.ExecDataTable("dbo.usp_GetAIDashBoardData");
                foreach (DataRow dr in dt.Rows)
                {
                    if (Convert.ToInt32(dr["Count"]) != 0)
                    {
                        DevDashBoardDataContract devd = new DataContract.DevDashBoardDataContract();
                        devd.IsChart = Convert.ToString(dr["ischart"]);
                        devd.value = CommonHelper.ToInt32_NotNullable(dr["Count"]);
                        devd.Name = Convert.ToString(dr["Text"]);
                        devd.ChartType = Convert.ToString(dr["ChartType"]);
                        devd.ChartName = Convert.ToString(dr["ChartName"]);

                        list.Add(devd);
                    }
                }
                return list;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public List<DevDashBoardDataContract> GetAIUserData(string username)
        {
            List<DevDashBoardDataContract> list = new List<DevDashBoardDataContract>();

            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();

                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = username };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetAIUserData", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    if (Convert.ToInt32(dr["Count"]) != 0)
                    {
                        DevDashBoardDataContract devd = new DataContract.DevDashBoardDataContract();
                        devd.IsChart = Convert.ToString(dr["ischart"]);
                        devd.value = CommonHelper.ToInt32_NotNullable(dr["Count"]);
                        devd.Name = Convert.ToString(dr["Text"]);
                        devd.ChartType = Convert.ToString(dr["ChartType"]);
                        devd.ChartName = Convert.ToString(dr["ChartName"]);

                        list.Add(devd);
                    }
                }
                return list;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        //

        public DataTable GetNoteIDAndAnalysisID(string crenoteid)
        {
            DataTable dt = new DataTable();
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@crenoteID", Value = crenoteid };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("usp_GetNoteIDAndAnalysisID", sqlparam);
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            return dt;
        }

        public DataTable GetDatabaseStatus(string currenttime, Guid UserID)
        {
            DataTable dt = new DataTable();
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@currenttime", Value = currenttime };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("usp_CheckDataWareHouseStatus", sqlparam);
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used

            return dt;
        }

        public void CalculateMultipleNotes(string multuplenotes, string AnalysisID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@crenoteid", Value = multuplenotes };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                hp.ExecDataTable("usp_CalculateNoteByCRENoteID", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void CalcAllNotes(string AnalysisID, string username)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UpdatedBy", Value = username };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                hp.ExecDataTable("usp_CalculateAllNotes", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public List<DevDashBoardDataContract> CheckWorkflowStatus(string workflowtext)
        {
            List<DevDashBoardDataContract> list = new List<DevDashBoardDataContract>();
            try
            {
                DataTable dt = new DataTable();
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UpdateWorkFlowStatus", Value = workflowtext };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("usp_CheckWorkflowStatus", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    DevDashBoardDataContract devd = new DataContract.DevDashBoardDataContract();
                    devd.IsEnable = dr["IsEnable"].ToInt32();
                    list.Add(devd);
                }
                return list;
            }
            catch (Exception ex)
            {
                throw new Exception("error in DevDashBoardRepository" + ex.Message);
            }

        }

        public DataTable GetErrorLogs()
        {
            DataTable dt = new DataTable();
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("usp_GetErrorLogs");
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            return dt;
        }

        public DataTable ShowUserSummary()
        {
            DataTable dt = new DataTable();
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("usp_ShowUserSummary");
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            return dt;
        }

        public void ImportStagingData()
        {

#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                hp.ExecNonquery("dbo.usp_ImportStagingDataIntoIntegration");
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
        }

        public string GetImportStagingDataStatus()
        {
            string Status = "";
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = hp.ExecDataTable("dbo.usp_GetImportStagingDataStatus", null);
                Status = Convert.ToString(dt.Rows[0]["Status"]);
            }
            catch (Exception ex)
            {
                Status = "Exception";
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            return Status;
        }

        public DataTable GetStagingDataIntoIntegrationStatus()
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = hp.ExecDataTable("dbo.usp_GetStagingDataIntoIntegration_Status");
                return dt;

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

    }
}