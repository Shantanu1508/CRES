using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace CRES.DAL.Repository
{
    public class UserNotificationRepository
    {
        public List<UserNotificationDataContract> GetUserNotification(string userid, string dt, int pageindex)
        {
            DataTable dt1 = new DataTable();
            List<UserNotificationDataContract> _lstUserNotification = new List<UserNotificationDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@currentTime", Value = dt };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PgeIndex", Value = pageindex };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            dt1 = hp.ExecDataTable("dbo.usp_GetUserNotification", sqlparam);
            // var UserNotification = _dbContext.usp_GetUserNotification(userid,dt, pageindex);
            foreach (DataRow dr in dt1.Rows)
            {
                UserNotificationDataContract un = new UserNotificationDataContract();
                if (Convert.ToString(dr["UserNotificationID"]) != "")
                {
                    un.UserNotificationID = new Guid(Convert.ToString(dr["UserNotificationID"]));
                }
                if (Convert.ToString(dr["NotificationSubscriptionID"]) != "")
                {
                    un.NotificationSubscriptionID = new Guid(Convert.ToString(dr["NotificationSubscriptionID"]));
                }


                un.ViewedTime = CommonHelper.ToDateTime(dr["ViewedTime"]);
                un.CleanTime = CommonHelper.ToDateTime(dr["CleanTime"]);
                if (Convert.ToString("ObjectId") != "")
                {
                    un.ObjectId = new Guid(Convert.ToString("ObjectId"));
                }

                un.ObjectTypeId = CommonHelper.ToInt32(dr["ObjectTypeId"]);
                un.Msg = Convert.ToString(dr["Msg"]);
                un.Sender = Convert.ToString(dr["Sender"]);
                un.SenderFirstLetter = Convert.ToString(dr["SenderFirstLetter"]);
                un.Modified = Convert.ToString(dr["Modified"]);
                un.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                un.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                un.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                un.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                un.UColor = Convert.ToString(dr["UColor"]);
                _lstUserNotification.Add(un);
            }

            return _lstUserNotification;

        }


        public bool ClearNotification(Guid notificationid, string updatedby)
        {
            bool iscleared = false;
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NotificationID", Value = notificationid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UpdatedBy", Value = updatedby };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            var isresult = hp.ExecNonquery("dbo.usp_ClearNotification", sqlparam);
            // var isresult = _dbContext.usp_ClearNotification(notificationid, updatedby);
            iscleared =isresult == -1 ? true : false;
            return iscleared;

        }


        public bool ClearAllNotification(string userid)
        {
            bool iscleared = false;
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            var isresult = hp.ExecNonquery("dbo.usp_ClearAllUserNotification", sqlparam);
            //var isresult=_dbContext.usp_ClearAllUserNotification(userid);

            iscleared =isresult == -1 ? true : false;
            return iscleared;
        }



        public bool ClearAllNotificationCount(string userid)
        {
            bool iscleared = false;
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            var isresult = hp.ExecNonquery("dbo.usp_ClearAllUserNotificationCount", sqlparam);
            // var isresult = _dbContext.usp_ClearAllUserNotificationCount(userid);
            iscleared = isresult == -1 ? true : false;
            return iscleared;

        }



        public UserNotificationDataContract GetUserNotificationCount(string userid)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetUserNotificationCount", sqlparam);
            UserNotificationDataContract userNotifiDC = new UserNotificationDataContract();
            if (dt.Rows.Count > 0)
            {
                //var objresult = _dbContext.usp_GetUserNotificationCount(userid).ToList();
                userNotifiDC.TotalCount = Convert.ToInt32(dt.Rows[0]["totalCount"]);
                userNotifiDC.CurrentCount = Convert.ToInt32(dt.Rows[0]["currentcount"]);
            }
            return userNotifiDC;

        }


        public List<NotificationSubscriptionDataContract> GetNotificationSubscriptionListByUserId(Guid? userId, int? PageIndex, int? PageSize, out int? TotalCount)
        {
            DataTable dt = new DataTable();
            List<NotificationSubscriptionDataContract> lstNotificationSubscription = new List<NotificationSubscriptionDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@PageIndex", Value = PageIndex };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PageSize", Value = PageSize };
            SqlParameter p4 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            dt = hp.ExecDataTable("dbo.usp_GetNotificationSubscriptionByUserID", sqlparam);
            //ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
            // var lstSubscription = _dbContext.usp_GetNotificationSubscriptionByUserID(userId, PageIndex, PageSize, totalCount);
            TotalCount = string.IsNullOrEmpty(Convert.ToString(p4.Value))? 0:Convert.ToInt32(p4.Value);

            foreach (DataRow dr in dt.Rows)
            {
                NotificationSubscriptionDataContract md = new NotificationSubscriptionDataContract();
                md.NotificationID = Convert.ToString(dr["NotificationID"]);
                md.NotificationSubscriptionID = Convert.ToString(dr["NotificationSubscriptionID"]);
                md.Name = Convert.ToString(dr["Name"]);
                md.User_UserID = Convert.ToString(userId);
                md.Status = Convert.ToBoolean((dr["Status"]) == null || Convert.ToInt32(dr["Status"]) == 0) ? false : true;
                lstNotificationSubscription.Add(md);
            }

            return lstNotificationSubscription;
        }

        public bool AddUpdateNotificationSubscription(Guid? userid, List<NotificationSubscriptionDataContract> subscriptionDataContract, string CreatedBy, string UpdatedBy)
        {
            string NewNotificationSubscriptionID;
            bool retValue = false;
            Helper.Helper hp = new Helper.Helper();
            foreach (var SubItem in subscriptionDataContract)
            {

                SqlParameter p1 = new SqlParameter { ParameterName = "@NotificationSubscriptionID", Value = new Guid(SubItem.NotificationSubscriptionID)};
                SqlParameter p2 = new SqlParameter { ParameterName = "@Notification_NotificationID", Value = new Guid(SubItem.NotificationID) };
                SqlParameter p3 = new SqlParameter { ParameterName = "@User_UserID", Value = new Guid(SubItem.User_UserID), };
                SqlParameter p4 = new SqlParameter { ParameterName = "@CreatedBy", Value = SubItem.CreatedBy };
                SqlParameter p5 = new SqlParameter { ParameterName = "@UpdatedBy", Value = SubItem.UpdatedBy };
                SqlParameter p6 = new SqlParameter { ParameterName = "@Status", Value = SubItem.Status };
                SqlParameter p7 = new SqlParameter { ParameterName = "@newNotificationSubscriptionID", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7 };
                var result = hp.ExecNonquery("dbo.usp_InsertUpdateNotificationSubscription", sqlparam);
                // ObjectParameter _newNotificationSubscriptionID = new ObjectParameter("NewNotificationSubscriptionID", typeof(string));
                NewNotificationSubscriptionID = Convert.ToString(p7.Value);

                if (result != 0)
                    retValue = true;

            }
            return retValue;
        }

        public List<UserNotificationDataContract> GetAllUserNotification(string userid, string dt, int pageindex, int pageSize, out int? TotalCount)
        {
            DataTable dt1 = new DataTable();
            List<UserNotificationDataContract> _lstUserNotification = new List<UserNotificationDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@currentTime", Value = dt };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PgeIndex", Value = pageindex };
            SqlParameter p4 = new SqlParameter { ParameterName = "@pageSize", Value = pageSize };
            SqlParameter p5 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt1 = hp.ExecDataTable("dbo.usp_GetAllUserNotification", sqlparam);
            // ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
            // var UserNotification = _dbContext.usp_GetAllUserNotification(userid, dt, pageindex, pageSize, totalCount).ToList();
            TotalCount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
            foreach (DataRow dr in dt1.Rows)
            {
                UserNotificationDataContract un = new UserNotificationDataContract();
                if (Convert.ToString(dr["UserNotificationID"]) != "")
                {
                    un.UserNotificationID = new Guid(Convert.ToString(dr["UserNotificationID"]));
                }
                if (Convert.ToString(dr["NotificationSubscriptionID"]) != "")
                {
                    un.NotificationSubscriptionID = new Guid(Convert.ToString(dr["NotificationSubscriptionID"]));
                }

                un.ViewedTime = CommonHelper.ToDateTime(dr["ViewedTime"]);
                un.CleanTime = CommonHelper.ToDateTime(dr["CleanTime"]);
                if (Convert.ToString(dr["ObjectId"]) != "")
                {
                    un.ObjectId = new Guid(Convert.ToString(dr["ObjectId"]));
                }

                un.ObjectTypeId = CommonHelper.ToInt32(dr["ObjectTypeId"]);
                un.Msg = Convert.ToString(dr["Msg"]);
                un.Sender = Convert.ToString(dr["Sender"]);
                un.SenderFirstLetter = Convert.ToString(dr["SenderFirstLetter"]);
                un.Modified = Convert.ToString(dr["Modified"]);
                un.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                un.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                un.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                un.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                un.UColor = Convert.ToString(dr["UColor"]);
                _lstUserNotification.Add(un);
            }
            return _lstUserNotification;
        }



        public System.Data.DataTable GetTimeZoneyUserID(Guid UserID, Guid? DelegateUserID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@DelegateUserID", Value = DelegateUserID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("usp_GetTimeZoneByUserID", sqlparam);
            return dt;
        }

    }
}
