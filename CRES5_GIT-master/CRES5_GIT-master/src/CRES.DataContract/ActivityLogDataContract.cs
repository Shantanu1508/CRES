using System;

namespace CRES.DataContract
{
    public class ActivityLogDataContract
    {
        public Guid? ActivityLogID { get; set; }
        public Guid? ModuleID { get; set; }
        public int ModuleTypeID { get; set; }
        public string ModuleName { get; set; }
        public string UserName { get; set; }
        public string Currentdate { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

        public string AssignedToText { get; set; }
        public string ActivityByFirstLetter { get; set; }
        public string Modified { get; set; }
        public string UColor { get; set; }
        public string ActivityMessage { get; set; }
        public string DisplayMessage { get; set; }
        public string ActivityColor { get; set; }
        public string ActivityUserFirstLetter { get; set; }
        public string ActivityType { get; set; }

    }
}
