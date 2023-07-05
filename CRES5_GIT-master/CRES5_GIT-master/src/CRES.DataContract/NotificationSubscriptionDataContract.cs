using System;

namespace CRES.DataContract
{
    public class NotificationSubscriptionDataContract
    {

        public string NotificationSubscriptionID { get; set; }
        public string Notification_NotificationID { get; set; }
        public string User_UserID { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public bool Status { get; set; }
        public string NotificationID { get; set; }
        public string Name { get; set; }
    }
}
