using CRES.DataContract;
using System;
using System.Collections.Generic;

namespace CRES.DAL.IRepository
{
    public interface IUserPermissionRespository
    {
        List<UserPermissionDataContract> GetuserPermissionByUserIDAndPageName(string userID, string pagename, String ObjectID, int? ObjectTypeID);
        List<UserDataContract> GetWFApprover(Guid? UserID);
        void InsertUpdateWFApprover(List<UserDataContract> lstEmailNotificationFile);
        void DeleteWFApproverByEmailNotificationID(Guid UserID, int? EmailNotificationID, string Email);
        List<ServicerDataContract> GetAllServicer(Guid? UserID);
        bool UpdateServicerByServicerId(Guid? UserID, int? ServicerID, int? ServicerDropDate, int? RepaymentDropDate);
        List<SchedulerConfigDataContract> GetALLSchedulerConfig(string UserID, SchedulerParamDataContract param);
        int InsertUpdateSchedulerLog(string UserID, SchedulerLogDataContract schedulerLog);
        void UpdateSchedulerConfig(string UserID, SchedulerConfigDataContract schedulerConfig);
        void AddUpdateSchedulerConfig(string UserID, List<SchedulerConfigDataContract> lstschedulerConfig);
        SchedulerConfigDataContract GetSchedulerConfigByID(string UserID, SchedulerConfigDataContract schedulerConfig);
        List<RuleTypeDataContract> GetAllRules();
        string GetContentByRuleTypeDetailID(int RuleTypeDetailID);
        List<UserDataContract> GetFCApprover(Guid? UserID);
    }
}