using System;


namespace CRES.DataContract
{
    public class UserNotificationDataContract
    {
        public Guid? UserNotificationID { get; set; }
        public Guid? NotificationSubscriptionID { get; set; }
        public DateTime? ViewedTime { get; set; }
        public DateTime? CleanTime { get; set; }
        public Guid? ObjectId { get; set; }
        public int? ObjectTypeId { get; set; }
        public string Msg { get; set; }
        public string SenderFirstLetter { get; set; }
        public string Sender { get; set; }
        public string Modified { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string UColor { get; set; }
        public int TotalCount { get; set; }
        public int CurrentCount { get; set; }
    }
}
