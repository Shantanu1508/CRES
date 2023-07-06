using System;

namespace CRES.DataContract.WorkFlow
{
    public class WFNotificationConfigDataContract
    {
        public int WFNotificationConfigID { get; set; }
        public Guid WFNotificationConfigGuID { get; set; }
        public string Name { get; set; }
        public bool? CanChangeReplyTo { get; set; }
        public bool? CanChangeRecipientList { get; set; }
        public bool? CanChangeHeader { get; set; }
        public bool? CanChangeBody { get; set; }
        public bool? CanChangeFooter { get; set; }
        public bool? CanChangeSchedule { get; set; }
        public int? TemplateID { get; set; }
        public string TemplateFileName { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int WFNotificationMasterID { get; set; }
    }
}
