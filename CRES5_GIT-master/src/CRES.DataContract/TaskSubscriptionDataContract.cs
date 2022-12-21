using System;

namespace CRES.DataContract
{
    public class TaskSubscriptionDataContract
    {

        public string UserID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string UColor { get; set; }
        public Boolean SubscriptionStatus { get; set; }
        public string TaskID { get; set; }
        public string CommentedByFirstLetter { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

    }
}
