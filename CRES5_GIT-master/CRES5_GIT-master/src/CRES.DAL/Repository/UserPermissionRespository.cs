using CRES.DAL.IRepository;
using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace CRES.DAL.Repository
{
    public class UserPermissionRespository : IUserPermissionRespository
    {

        public List<UserPermissionDataContract> GetuserPermissionByUserIDAndPageName(string userID, string pagename, string ObjectID, int? ObjectTypeID)
        {
            DataTable dt = new DataTable();
            List<UserPermissionDataContract> permissionlist = new List<UserPermissionDataContract>();

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserId", Value = userID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@ParentModuleName", Value = pagename };
            SqlParameter p3 = new SqlParameter { ParameterName = "@ObjectID", Value = ObjectID };
            SqlParameter p4 = new SqlParameter { ParameterName = "@ObjectTypeID", Value = ObjectTypeID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            dt = hp.ExecDataTable("dbo.usp_GetUserPermission", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                UserPermissionDataContract udc = new UserPermissionDataContract();
                udc.ParentModule = Convert.ToString(dr["ParentModuleName"]);
                udc.ChildModule = Convert.ToString(dr["ModuleTabName"]);
                udc.RightsName = Convert.ToString(dr["RightsName"]);
                udc.RoleName = Convert.ToString(dr["RoleName"]);
                udc.ModuleTabName = Convert.ToString(dr["ModuleTabName"]);
                udc.ModuleType = Convert.ToString(dr["ModuleType"]);
                permissionlist.Add(udc);

            }

            return permissionlist;
        }



        public List<RoleDataContract> GetRole()
        {
            List<RoleDataContract> rolelist = new List<RoleDataContract>();
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetRole");

            foreach (DataRow dr in dt.Rows)
            {
                RoleDataContract udc = new RoleDataContract();
                udc.RoleID = new Guid(Convert.ToString(dr["RoleID"]));
                udc.RoleName = Convert.ToString(dr["RoleName"]);
                udc.StatusID = CommonHelper.ToInt32(dr["StatusID"]);
                udc.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                udc.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                udc.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                udc.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                rolelist.Add(udc);

            }
            return rolelist;
        }

        public List<ModuleTabMasterDataContract> GetModuleTabMaster()
        {
            List<ModuleTabMasterDataContract> moduletablist = new List<ModuleTabMasterDataContract>();
            List<RoleDataContract> rolelist = new List<RoleDataContract>();
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetModuleTabMaster");

            foreach (DataRow dr in dt.Rows)
            {
                ModuleTabMasterDataContract mtm = new ModuleTabMasterDataContract();
                mtm.ModuleTabMasterID = Convert.ToInt32(dr["ModuleTabMasterID"]);
                mtm.ModuleTabName = Convert.ToString(dr["ModuleTabName"]);
                mtm.ParentID = CommonHelper.ToInt32(dr["ParentID"]);
                mtm.StatusID = CommonHelper.ToInt32(dr["StatusID"]);
                mtm.SortOrder = CommonHelper.ToInt32(dr["SortOrder"]);
                mtm.DisplayName = Convert.ToString(dr["DisplayName"]);
                mtm.ModuleType = Convert.ToString(dr["ModuleType"]);
                mtm.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                mtm.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                mtm.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                mtm.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                moduletablist.Add(mtm);
            }
            return moduletablist;
        }



        public List<ModuleTabMasterDataContract> GetPermissionByRoleId(string roleid)
        {
            List<ModuleTabMasterDataContract> moduletablist = new List<ModuleTabMasterDataContract>();

            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@RoleID", Value = new Guid(roleid) };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetPermissionByRoleId", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                ModuleTabMasterDataContract mtm = new ModuleTabMasterDataContract();
                mtm.ModuleTabMasterID = Convert.ToInt32(dr["ModuleTabMasterID"]);
                mtm.ModuleTabName = Convert.ToString(dr["ModuleTabName"]);
                mtm.ParentID = CommonHelper.ToInt32(dr["ParentID"]);
                mtm.StatusID = CommonHelper.ToInt32(dr["StatusID"]);
                mtm.SortOrder = CommonHelper.ToInt32(dr["SortOrder"]);
                mtm.DisplayName = Convert.ToString(dr["DisplayName"]);
                mtm.ModuleType = Convert.ToString(dr["ModuleType"]);
                mtm.IsEdit = CommonHelper.ToBoolean(dr["IsEdit"]);
                mtm.IsView = CommonHelper.ToBoolean(dr["IsView"]);
                mtm.IsDelete = CommonHelper.ToBoolean(dr["IsDelete"]);
                moduletablist.Add(mtm);
            }

            return moduletablist;
        }

        public void InsertUpdateUserPermissionByRoleID(List<ModuleTabMasterDataContract> lstModuleTabMaster)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable dtMTM = new DataTable();
            dtMTM.Columns.Add("RoleID");
            dtMTM.Columns.Add("ModuleTabMasterID");
            dtMTM.Columns.Add("IsEdit");
            dtMTM.Columns.Add("IsView");
            dtMTM.Columns.Add("IsDelete");

            if (lstModuleTabMaster != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(lstModuleTabMaster);

                foreach (DataRow dr in dt.Rows)
                {
                    dtMTM.ImportRow(dr);
                }
            }

            if (dtMTM.Rows.Count > 0)
            {
                //string CreatedBy = lstModuleTabMaster[0].CreatedBy;
                //string UpdatedBy = lstModuleTabMaster[0].UpdatedBy;
                hp.ExecDataTablewithtable("usp_InsertUpdateUserPermissionByRoleID", "tblUserPermission", dtMTM, "", "");
            }
        }


        public void AddUpdateRole(RoleDataContract roledc)
        {

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@RoleID", Value = roledc.RoleID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@RoleName", Value = roledc.RoleName };
            SqlParameter p3 = new SqlParameter { ParameterName = "@StatusID", Value = roledc.StatusID };
            SqlParameter p4 = new SqlParameter { ParameterName = "@CreatedBy", Value = roledc.UserId };
            SqlParameter p5 = new SqlParameter { ParameterName = "@CreatedDate", Value = roledc.CreatedDate };
            SqlParameter p6 = new SqlParameter { ParameterName = "@UpdatedBy", Value = roledc.UserId };
            SqlParameter p7 = new SqlParameter { ParameterName = "@UpdatedDate", Value = roledc.UpdatedDate };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7 };
            int val = hp.ExecuteScalar("App.usp_AddUpdateRole", sqlparam);
        }

        public List<UserDataContract> GetWFApprover(Guid? UserID)
        {
            DataTable dt = new DataTable();
            List<UserDataContract> userlst = new List<UserDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetWFApprover", sqlparam);
            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    UserDataContract _userlst = new UserDataContract();
                    _userlst.Email = Convert.ToString(dr["EmailId"]);
                    _userlst.Login = Convert.ToString(dr["Login"]);
                    _userlst.ModuleName = Convert.ToString(dr["Name"]);
                    _userlst.EmailNotificationID = Convert.ToInt32(dr["EmailNotificationID"]);
                    _userlst.ModuleId = Convert.ToInt32(dr["ModuleId"]);
                    _userlst.StatusID = Convert.ToInt32(dr["Status"]);
                    _userlst.FirstName = Convert.ToString(dr["FirstName"]) + ' ' + Convert.ToString(dr["LastName"]);
                    userlst.Add(_userlst);
                }
            }
            return userlst;
        }
        public void InsertUpdateWFApprover(List<UserDataContract> lstEmailNotificationFile)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@XMLEmailNotificationFile", Value = lstEmailNotificationFile.ToXML().Replace(" xsi:nil=\"true\"", "") };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            hp.ExecNonquery("dbo.usp_AddUpdateEmailNotification", sqlparam);

        }
        public void DeleteWFApproverByEmailNotificationID(Guid UserID, int? EmailNotificationID, string Email)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserId", Value = UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@EmailNotificationID", Value = EmailNotificationID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@Email", Value = Email };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            hp.ExecNonquery("dbo.usp_DeleteWFAprroverByEmailNotificationID", sqlparam);
        }

        public List<ServicerDataContract> GetAllServicer(Guid? UserID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            List<ServicerDataContract> _servicer = new List<ServicerDataContract>();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetAllServicer", sqlparam);
            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    ServicerDataContract lstservicer = new ServicerDataContract();
                    lstservicer.ServicerMasterID = CommonHelper.ToInt32(dr["ServicerID"]);
                    lstservicer.ServicerDisplayName = Convert.ToString(dr["ServicerName"]);
                    lstservicer.ServicerDropDate = CommonHelper.ToInt32(dr["ServicerDropDate"]);
                    lstservicer.RepaymentDropDate = CommonHelper.ToInt32(dr["RepaymentDropDate"]);
                    _servicer.Add(lstservicer);
                }
            }
            return _servicer;
        }

        public bool UpdateServicerByServicerId(Guid? UserID, int? ServicerID, int? ServicerDropDate, int? RepaymentDropDate)
        {
            bool retValue = false;

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@ServicerID", Value = ServicerID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@ServicerDropDate", Value = ServicerDropDate };
            SqlParameter p4 = new SqlParameter { ParameterName = "@RepaymentDropDate", Value = RepaymentDropDate };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            var count = hp.ExecNonquery("App.usp_UpdateServicerByServicerId", sqlparam);
            if (count == 1)
            {
                retValue = true;
            }
            return retValue;
        }

        public DataTable GetAllTransactionTypes(Guid? UserID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetAllTransactionTypes", sqlparam);
            return dt;
        }

        public void InsertUpdateTransactionTypes(DataTable transtypeDC, Guid UserID)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@Tabletransactiontypes", Value = transtypeDC };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            hp.ExecDataTablewithparams("dbo.usp_InsertUpdateTransactionTypes", sqlparam);
        }

        public void deleteTransactioType(int? transactiontypeId, Guid UserID)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@TransactioTypeID", Value = transactiontypeId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            var count = hp.ExecNonquery("dbo.usp_DeleteTransactionTypesByTransactionID", sqlparam);
        }
        public List<SchedulerConfigDataContract> GetALLSchedulerConfig(string UserID, SchedulerParamDataContract param)
        {
            List<SchedulerConfigDataContract> lstschedulerconfig = new List<SchedulerConfigDataContract>();
            SchedulerConfigDataContract config = null;
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@Status", Value = param.Status };
            SqlParameter p3 = new SqlParameter { ParameterName = "@GroupID", Value = param.GroupID };
            SqlParameter p4 = new SqlParameter { ParameterName = "@ConfigFor", Value = param.ConfigFor };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            dt = hp.ExecDataTable("dbo.usp_GetAllSchedulerConfig", sqlparam);
            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    config = new SchedulerConfigDataContract();

                    config.SchedulerConfigID = Convert.ToInt32(dr["SchedulerConfigID"]);
                    config.SchedulerName = Convert.ToString(dr["SchedulerName"]);
                    config.APIname = Convert.ToString(dr["APIname"]);
                    config.Description = Convert.ToString(dr["Description"]);
                    config.ObjectTypeID = CommonHelper.ToInt32(dr["ObjectTypeID"]);
                    config.ObjectID = CommonHelper.ToInt32(dr["ObjectID"]);
                    config.ExecutionTime = Convert.ToString(dr["ExecutionTime"]);
                    config.NextexecutionTime = CommonHelper.ToDateTime(dr["NextexecutionTime"]);
                    config.Frequency = Convert.ToString(dr["Frequency"]);
                    config.Status = dr["Status"] == null ? 0 : Convert.ToInt32(dr["Status"]);
                    config.JobStatus = Convert.ToString(dr["JobStatus"]);
                    config.IsEnableDayLightSaving = CommonHelper.ToInt32(dr["IsEnableDayLightSaving"]);
                    config.Timezone = Convert.ToString(dr["Timezone"]);
                    config.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                    config.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                    config.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    config.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);

                    lstschedulerconfig.Add(config);
                }
            }
            return lstschedulerconfig;
        }

        public int InsertUpdateSchedulerLog(string UserID, SchedulerLogDataContract schedulerLog)
        {
            int SchedulerLogID;
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@SchedulerLogID", Value = schedulerLog.SchedulerLogID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@SchedulerConfigID", Value = schedulerLog.SchedulerConfigID };
            SqlParameter p4 = new SqlParameter { ParameterName = "@Message", Value = schedulerLog.Message };
            SqlParameter p5 = new SqlParameter { ParameterName = "@StartTime", Value = schedulerLog.StartTime };
            SqlParameter p6 = new SqlParameter { ParameterName = "@EndTime", Value = schedulerLog.EndTime };
            SqlParameter p7 = new SqlParameter { ParameterName = "@GeneratedBy", Value = schedulerLog.GeneratedBy };
            SqlParameter p8 = new SqlParameter { ParameterName = "@OutSchedulerLogID", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8 };
            hp.ExecNonquery("dbo.usp_InsertSchedulerLog", sqlparam);
            SchedulerLogID = Convert.ToInt32(p8.Value.ToString() == "" ? 0 : p8.Value);
            return SchedulerLogID;
        }

        public void UpdateSchedulerConfig(string UserID, SchedulerConfigDataContract schedulerConfig)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@SchedulerConfigID", Value = schedulerConfig.SchedulerConfigID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@JobStatus", Value = schedulerConfig.JobStatus };
            SqlParameter p4 = new SqlParameter { ParameterName = "@RunBy", Value = schedulerConfig.GeneratedBy };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            var count = hp.ExecNonquery("dbo.usp_UpdateSchedulerConfig", sqlparam);
        }

        public void AddUpdateSchedulerConfig(string UserID, List<SchedulerConfigDataContract> lstschedulerConfig)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@XMLSchedulerConfig", Value = lstschedulerConfig.ToXML().Replace(" xsi:nil=\"true\"", "") };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            var count = hp.ExecNonquery("dbo.usp_AddUpdateSchedulerConfig", sqlparam);
        }

        public SchedulerConfigDataContract GetSchedulerConfigByID(string UserID, SchedulerConfigDataContract schedulerConfig)
        {
            DataTable dt = new DataTable();
            SchedulerConfigDataContract config = new SchedulerConfigDataContract();


            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@SchedulerConfigID", Value = schedulerConfig.SchedulerConfigID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };

            dt = hp.ExecDataTable("dbo.usp_GetSchedulerConfigByID", sqlparam);

            if (dt != null && dt.Rows.Count > 0)
            {
                config.SchedulerConfigID = Convert.ToInt32(dt.Rows[0]["SchedulerConfigID"]);
                config.SchedulerName = Convert.ToString(dt.Rows[0]["SchedulerName"]);
                config.APIname = Convert.ToString(dt.Rows[0]["APIname"]);
                config.Description = Convert.ToString(dt.Rows[0]["Description"]);
                config.ObjectTypeID = CommonHelper.ToInt32(dt.Rows[0]["ObjectTypeID"]);
                config.ObjectID = CommonHelper.ToInt32(dt.Rows[0]["ObjectID"]);
                config.ExecutionTime = Convert.ToString(dt.Rows[0]["ExecutionTime"]);
                config.NextexecutionTime = CommonHelper.ToDateTime(dt.Rows[0]["NextexecutionTime"]);
                config.Frequency = Convert.ToString(dt.Rows[0]["Frequency"]);
                config.Status = dt.Rows[0]["Status"] == null ? 0 : Convert.ToInt32(dt.Rows[0]["Status"]);
                config.GroupID = dt.Rows[0]["GroupID"] == null ? 0 : Convert.ToInt32(dt.Rows[0]["GroupID"]);
                config.ServerIndex = dt.Rows[0]["ServerIndex"] == null ? 0 : Convert.ToInt32(dt.Rows[0]["ServerIndex"]);
                config.JobStatus = Convert.ToString(dt.Rows[0]["JobStatus"]);
                config.IsEnableDayLightSaving = CommonHelper.ToInt32(dt.Rows[0]["IsEnableDayLightSaving"]);
                config.Timezone = Convert.ToString(dt.Rows[0]["Timezone"]);
                config.CreatedBy = Convert.ToString(dt.Rows[0]["CreatedBy"]);
                config.CreatedDate = CommonHelper.ToDateTime(dt.Rows[0]["CreatedDate"]);
                config.UpdatedBy = Convert.ToString(dt.Rows[0]["UpdatedBy"]);
                config.UpdatedDate = CommonHelper.ToDateTime(dt.Rows[0]["UpdatedDate"]);
            }
            return config;
        }

        public DataTable GetHolidayCalendar(Guid? UserID)
        {
            try
            {
                DataTable dt = new DataTable();
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetAllHolidayCalendar", sqlparam);
                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void AddHolidayCalendarName(Guid UserID, string CalendarName)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "CalendarName", Value = CalendarName };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                var count = hp.ExecNonquery("dbo.usp_InsertHolidayCalendar", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void InsertHolidayDates(DataTable dtHolidaydates, Guid UserID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@TableHolidays", Value = dtHolidaydates };
                SqlParameter p2 = new SqlParameter { ParameterName = "@CreatedBy", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                hp.ExecDataTablewithparams("dbo.usp_InsertHolidaysDate", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetHolidayMaster(Guid? UserID)
        {
            try
            {
                DataTable dt = new DataTable();
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetHolidayMaster", sqlparam);
                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public List<RuleTypeDataContract> GetAllRules()
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            List<RuleTypeDataContract> _lstAllRules = new List<RuleTypeDataContract>();
            dt = hp.ExecDataTable("dbo.usp_GetRuleTypeNameAndFileName");
            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    RuleTypeDataContract lstrules = new RuleTypeDataContract();

                    lstrules.RuleTypeMasterID = CommonHelper.ToInt32(dr["RuleTypeMasterID"]);
                    lstrules.RuleTypeName = Convert.ToString(dr["RuleTypeName"]);
                    lstrules.RuleTypeDetailID = CommonHelper.ToInt32(dr["RuleTypeDetailID"]);
                    lstrules.FileName = Convert.ToString(dr["FileName"]);
                    lstrules.OriginalFileName = Convert.ToString(dr["FileName"]);
                    lstrules.Type = Convert.ToString(dr["Type"]);
                    lstrules.DBFileName = Convert.ToString(dr["DBFileName"]);
                    _lstAllRules.Add(lstrules);
                }
            }
            return _lstAllRules;
        }


        public string GetContentByRuleTypeDetailID(int RuleTypeDetailID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            string Content = "";
            SqlParameter p1 = new SqlParameter { ParameterName = "@RuleTypeDetailID", Value = RuleTypeDetailID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };

            dt = hp.ExecDataTable("dbo.usp_GetContentByRuleTypeDetailID", sqlparam);
            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    Content = Convert.ToString(dr["Content"]);
                }
            }
            return Content;
        }
        public JsonTemplate GetJsonTemplateByKey(int key)
        {
            JsonTemplate jtitem = new JsonTemplate();
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@key", Value = key };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, };
            dt = hp.ExecDataTable("dbo.usp_GetJsonTemplateByKey", sqlparam);
            if (dt != null && dt.Rows.Count > 0)
            {
                jtitem.Type = Convert.ToString(dt.Rows[0]["Value"]);
            }
            return jtitem;
        }

        public void AddTemplateName(Guid UserID, TemplateNameDc template)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@copyfrom_JsonTemplateMasterID", Value = template.JsonTemplateMasterID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@new_TemplateName", Value = template.NewTemplateName };
                SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                var count = hp.ExecNonquery("dbo.usp_CopyJsonTemplate_V1", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}