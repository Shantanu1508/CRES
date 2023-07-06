using System;

namespace CRES.DataContract.WorkFlow
{
    public class WFNotificationMasterDataContract
    {
        public int WFNotificationMasterID { get; set; }
        public Guid WFNotificationMasterGuID { get; set; }
        public string Name { get; set; }
        public int WFNotificationConfigID { get; set; }
        public int TemplateID { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public bool IsEnable { get; set; }

    }
}
