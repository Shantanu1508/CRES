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


        

        public DataTable GetNoteIDAndAnalysisID(string crenoteid)
        {
            DataTable dt = new DataTable();
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
            return dt;
        }

        public DataTable GetDatabaseStatus(string currenttime, Guid UserID)
        {
            DataTable dt = new DataTable();
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
            try
            {
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("usp_GetErrorLogs");
            }
            catch (Exception ex)
            {
            }
            return dt;
        }

        public DataTable GetLogsForDownloadExcel(string objectID)
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper(); 
                SqlParameter p1 = new SqlParameter { ParameterName = "@ObjectID", Value = objectID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("usp_GetLogsDownload",sqlparam );
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dt;
        }

        public DataTable GetCalculationSummary()
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("usp_GetCalculationSummary");
            }
            catch (Exception ex)
            {
            }
            return dt;
        }

        public DataTable ShowUserSummary()
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("usp_ShowUserSummary");
            }
            catch (Exception ex)
            {
            }
            return dt;
        }

        public void ImportStagingData()
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();
                hp.ExecNonquery("dbo.usp_ImportStagingDataIntoIntegration");
            }
            catch (Exception ex)
            {
            }
        }

        public string GetImportStagingDataStatus()
        {
            string Status = "";
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

        public DataTable GetErrorForEmail()
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("usp_GetErrorForEmail");
            }
            catch (Exception ex)
            {
            }
            return dt;
        }

        public List<DevDashBoardDataContract> GetXIRRStatusSummaryfordevdash()
        {
            List<DevDashBoardDataContract> list = new List<DevDashBoardDataContract>();

            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();

                dt = hp.ExecDataTable("dbo.usp_GetXIRRStatusSummaryfordevdash");

                foreach (DataRow dr in dt.Rows)
                {
                    DevDashBoardDataContract devd = new DataContract.DevDashBoardDataContract();

                    devd.value = CommonHelper.ToInt32(dr["Count"]);
                    devd.Name = Convert.ToString(dr["Name"]);

                    list.Add(devd);
                }
                return list;
            }
            catch (Exception ex)
            {
                throw new Exception("error in DevDashBoardRepository" + ex.Message);
            }
        }


        public List<DevDashBoardDataContract> GetCalculationStatusForValuationDashBoard()
        {
            List<DevDashBoardDataContract> list = new List<DevDashBoardDataContract>();

            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();
                
                dt = hp.ExecDataTable("dbo.usp_GetCalculationStatusForValuationDashBoard");

                foreach (DataRow dr in dt.Rows)
                {
                    DevDashBoardDataContract devd = new DataContract.DevDashBoardDataContract();

                    devd.value = CommonHelper.ToInt32(dr["Count"]);
                    devd.Name = Convert.ToString(dr["Name"]);
                    devd.StatusID = CommonHelper.ToInt32(dr["StatusID"]);
                    devd.IsChart = (dr["IsChart"]).ToString();
                    devd.ErrorMessage = (dr["ErrorMessage_group"]).ToString();
                    

                    list.Add(devd);
                }
                return list;
            }
            catch (Exception ex)
            {
                throw new Exception("error in DevDashBoardRepository" + ex.Message);
            }
        }

        public List<EnvConfigDataContract> GetEnvConfig()
        {
            List<EnvConfigDataContract> list = new List<EnvConfigDataContract>();

            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();

                IConfigurationBuilder builder = new ConfigurationBuilder();
                builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
                var root = builder.Build();
                string ExcludedEnvName = root.GetSection("Application").GetSection("ServerName").Value.Split("-")[1].ToString();

                SqlParameter p1 = new SqlParameter { ParameterName = "@ExcludedEnvName", Value = ExcludedEnvName };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetEnvConfig", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    EnvConfigDataContract devd = new DataContract.EnvConfigDataContract();

                    devd.EnvName = Convert.ToString(dr["EnvName"]);
                    devd.ServerName = Convert.ToString(dr["ServerName"]);
                    devd.LoginName = Convert.ToString(dr["LoginName"]);
                    devd.Password = Convert.ToString(dr["Password"]);
                    devd.DBName = Convert.ToString(dr["DBName"]);

                    list.Add(devd);
                }
                return list;
            }
            catch (Exception ex)
            {
                throw new Exception("error in DevDashBoardRepository GetEnvConfig : " + ex.Message);
            }
        }

        public string CheckEnvConnection(EnvConfigDataContract selectedEnvConfig)
        {
            try
            {
                SqlConnection selConn = new SqlConnection();
                selConn.ConnectionString = "Data Source='" + selectedEnvConfig.ServerName + "';initial catalog='" + selectedEnvConfig.DBName + "';user id='" + selectedEnvConfig.LoginName + "';password='" + selectedEnvConfig.Password + "';MultipleActiveResultSets=True;Connection Timeout=30;Max Pool Size=500;Pooling=True";
                selConn.Open();
                return "Connection Success";
            }
            catch (Exception ex)
            {
                return "Connection Failed";
                throw new Exception("error in DevDashBoardRepository GetEnvConfig : " + ex.Message);
            }
        }

        public string ImportDealFromOtherSource(EnvConfigDataContract selectedEnvConfig,string UpdatedBy)
        {
            List<EnvConfigDataContract> list = new List<EnvConfigDataContract>();

            try
            {
                Helper.Helper hp = new Helper.Helper();
                

                SqlParameter p1 = new SqlParameter { ParameterName = "@ServerName", Value = selectedEnvConfig.ServerName };
                SqlParameter p2 = new SqlParameter { ParameterName = "@Login", Value = selectedEnvConfig.LoginName };
                SqlParameter p3 = new SqlParameter { ParameterName = "@Password", Value = selectedEnvConfig.Password };
                SqlParameter p4 = new SqlParameter { ParameterName = "@DataBaseName", Value = selectedEnvConfig.DBName };
                SqlParameter p5 = new SqlParameter { ParameterName = "@CREDealID", Value = selectedEnvConfig.DealID };
                SqlParameter p6 = new SqlParameter { ParameterName = "@UpdatedBy", Value = UpdatedBy };
                SqlParameter p7 = new SqlParameter { ParameterName = "@CRENoteID", Value = selectedEnvConfig.NoteID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1,p2,p3,p4,p5,p6,p7 };
                hp.ExecNonquery("dbo.usp_CopyFF_FromOtherSource", sqlparam);

                return "Import Success";
            }
            catch (Exception ex)
            {
                return "Import Failed";
                throw new Exception("error in DevDashBoardRepository GetEnvConfig : " + ex.Message);
            }
        }

        public DataTable GetValuationLogsForDownloadExcel()
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                
                dt = hp.ExecDataTable("usp_GetValuationLogsDownload");
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dt;
        }

        public DataTable GetValuationCalculationSummary()
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("usp_GetCalculationSummaryForValuationDashBoard");
            }
            catch (Exception ex)
            {
            }
            return dt;
        }

        public void CalculateMultipleDeals(string multupledeals, string AnalysisID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@creDealid", Value = multupledeals };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                hp.ExecDataTable("usp_CalculateDealByCREDealID", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}