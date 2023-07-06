using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;

namespace CRES.BusinessLogic
{
    public class UserPermissionLogic
    {
        UserPermissionRespository _UserPermission = new UserPermissionRespository();

        public List<UserPermissionDataContract> GetuserPermissionByUserIDAndPageName(string userID, string pagename, string ObjectID = "", int ObjectTypeID = 0)

        {
            List<UserPermissionDataContract> list = _UserPermission.GetuserPermissionByUserIDAndPageName(userID, pagename, ObjectID, ObjectTypeID);

            return list;
        }

        public List<RoleDataContract> GetRole()
        {
            List<RoleDataContract> list = _UserPermission.GetRole();

            return list;
        }

        public List<ModuleTabMasterDataContract> GetModuleTabMaster()
        {
            List<ModuleTabMasterDataContract> list = _UserPermission.GetModuleTabMaster();

            return list;
        }


        public List<ModuleTabMasterDataContract> GetPermissionByRoleId(string roleid)
        {
            List<ModuleTabMasterDataContract> list = _UserPermission.GetPermissionByRoleId(roleid);

            return list;
        }


        public void InsertUpdateUserPermissionByRoleID(List<ModuleTabMasterDataContract> lstModuleTabMaster)
        {
            _UserPermission.InsertUpdateUserPermissionByRoleID(lstModuleTabMaster);
        }

        public void AddUpdateRole(RoleDataContract roledc)
        {
            _UserPermission.AddUpdateRole(roledc);
        }
        public List<UserDataContract> GetWFApprover(Guid? UserID)
        {
            List<UserDataContract> userlist = _UserPermission.GetWFApprover(UserID);
            return userlist;
        }
        public void InsertUpdateWFApprover(List<UserDataContract> lstEmailNotificationFile)
        {
            _UserPermission.InsertUpdateWFApprover(lstEmailNotificationFile);
        }
        public void DeleteWFApproverByEmailNotificationID(Guid UserID, int? EmailNotificationID, string Email)
        {
            _UserPermission.DeleteWFApproverByEmailNotificationID(UserID, EmailNotificationID, Email);
        }
        public List<ServicerDataContract> GetAllServicer(Guid? UserID)
        {
            List<ServicerDataContract> servicerlst = _UserPermission.GetAllServicer(UserID);
            return servicerlst;
        }

        public bool UpdateServicerByServicerId(Guid? UserID, int? ServicerID, int? ServicerDropDate, int? RepaymentDropDate)
        {
            bool retValue = false;
            retValue = _UserPermission.UpdateServicerByServicerId(UserID, ServicerID, ServicerDropDate, RepaymentDropDate);
            return retValue;
        }

        public DataTable GetAllTransactionTypes(Guid? UserID)
        {
            return _UserPermission.GetAllTransactionTypes(UserID);
        }
        public void InsertUpdateTransactionTypes(DataTable transtypeDC, Guid UserID)
        {
            _UserPermission.InsertUpdateTransactionTypes(transtypeDC, UserID);
        }
        public void deleteTransactioType(int? transactiontypeId, Guid UserID)
        {
            _UserPermission.deleteTransactioType(transactiontypeId, UserID);
        }
        public List<SchedulerConfigDataContract> GetALLSchedulerConfig(string UserID, SchedulerParamDataContract paramDC)
        {
            return _UserPermission.GetALLSchedulerConfig(UserID, paramDC);
        }

        public int InsertUpdateSchedulerLog(string UserID, SchedulerLogDataContract schedulerLog)
        {
            return _UserPermission.InsertUpdateSchedulerLog(UserID, schedulerLog);
        }

        public void UpdateSchedulerConfig(string UserID, SchedulerConfigDataContract schedulerConfig)
        {
            _UserPermission.UpdateSchedulerConfig(UserID, schedulerConfig);
        }

        public void AddUpdateSchedulerConfig(string UserID, List<SchedulerConfigDataContract> lstschedulerConfig)
        {
            _UserPermission.AddUpdateSchedulerConfig(UserID, lstschedulerConfig);
        }

        public SchedulerConfigDataContract GetSchedulerConfigByID(string UserID, SchedulerConfigDataContract schedulerConfig)
        {
            return _UserPermission.GetSchedulerConfigByID(UserID, schedulerConfig);
        }
        public DataTable GetHolidayCalendar(Guid? UserID)
        {
            return _UserPermission.GetHolidayCalendar(UserID);
        }
        public void AddHolidayCalendarName(Guid UserID, string CalendarName)
        {
            _UserPermission.AddHolidayCalendarName(UserID, CalendarName);
        }

        public void InsertHolidayDates(DataTable dtHolidaydates, Guid UserID)
        {
            _UserPermission.InsertHolidayDates(dtHolidaydates, UserID);
        }
        public DataTable GetHolidayMaster(Guid? UserID)
        {
            return _UserPermission.GetHolidayMaster(UserID);
        }
        public List<RuleTypeDataContract> GetAllRules()
        {
            return _UserPermission.GetAllRules();
        }

        public string GetContentByRuleTypeDetailID(int RuleTypeDetailID)
        {
            return _UserPermission.GetContentByRuleTypeDetailID(RuleTypeDetailID);
        }

        public JsonTemplate GetJsonTemplateByKey(int key)
        {
            JsonTemplate list = _UserPermission.GetJsonTemplateByKey(key);

            return list;
        }
    }
}