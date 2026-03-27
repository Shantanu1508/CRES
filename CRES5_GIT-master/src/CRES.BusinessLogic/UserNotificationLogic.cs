using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DAL.Repository;
using CRES.DataContract;

namespace CRES.BusinessLogic
{
    public class UserNotificationLogic
    {

       UserNotificationRepository _userRepository = new UserNotificationRepository();
        public List<UserNotificationDataContract> GetUserNotification(string userid,string dt,int pageindex)
        {
            return _userRepository.GetUserNotification(userid,dt,pageindex);
        }


        public bool ClearNotification(Guid notificationid, string updatedby)
        {
            return _userRepository.ClearNotification(notificationid, updatedby);
        }


        public bool ClearAllNotification(string userid)
        {
            return _userRepository.ClearAllNotification(userid);
        }



        public bool ClearAllNotificationCount(string userid)
        {
            return _userRepository.ClearAllNotificationCount(userid);
        }


        public UserNotificationDataContract GetUserNotificationCount(string userid)
        {
            return _userRepository.GetUserNotificationCount(userid);
        }


        public List<NotificationSubscriptionDataContract> GetNotificationSubscriptionListByUserId(Guid? userId, int? PageIndex, int? PageSize, out int? TotalCount)
        {
            return _userRepository.GetNotificationSubscriptionListByUserId(userId, PageIndex, PageSize, out TotalCount).ToList();
        }

        public bool AddUpdateNotificationSubscription(Guid? userid, List<NotificationSubscriptionDataContract> subscriptionDataContract, string CreatedBy, string UpdatedBy)
        {
            return _userRepository.AddUpdateNotificationSubscription(userid, subscriptionDataContract, CreatedBy, UpdatedBy);
        }


        public List<UserNotificationDataContract> GetAllUserNotification(string userid, string dt, int pageindex, int pageSize, out int? TotalCount)
        {
            return _userRepository.GetAllUserNotification(userid, dt, pageindex, pageSize,out TotalCount);
        }


    }
}
