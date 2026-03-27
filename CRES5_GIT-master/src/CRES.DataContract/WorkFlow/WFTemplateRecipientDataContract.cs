using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract.WorkFlow
{
    public class WFTemplateRecipientDataContract
    {
        public int WFTemplateRecipientID { get; set; }
        public Guid WFTemplateRecipientGuID { get; set; }
        public int? WFTemplateID { get; set; }
        public Guid UserID { get; set; }
        public string EmailID { get; set; }
        public string RecipientType { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string TO { get; set; }
        public string CC { get; set; }
        public string ReplyTo { get; set; }
        public int WFNotificationMasterID { get; set; }
        
    }
}
