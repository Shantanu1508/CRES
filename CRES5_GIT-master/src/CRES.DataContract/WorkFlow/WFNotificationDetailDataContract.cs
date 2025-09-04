using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract.WorkFlow
{
    public class WFNotificationDetailDataContract
    {
        public int WFNotificationID { get; set; }
        public Guid WFNotificationGuID { get; set; }
        public int WFNotificationMasterID { get; set; }
        public Guid TaskID { get; set; }
        public int TaskTypeID { get; set; }
        public string MessageHTML { get; set; }
        public DateTime? ScheduledDateTime { get; set; }
        public int ActionType { get; set; }
        public string AdditionalText { get; set; }
        public string EmailToIds { get; set; }
        public string EmailCCIds { get; set; }

        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string TemplateFileName { get; set; }
        public int TemplateID { get; set; }
        public string DealName { get; set; }
        public string Subject { get; set; }
        public string ReplyTo { get; set; }
        public string EnvironmentName { get; set; }
        public string UserName { get; set; }
        public string AdditionalComments { get; set; }
        public string SpecialInstructions { get; set; }
        public List<WFCheckListDataContract> WFCheckList { get; set; }
        public string DelegatedUserID { get; set; }
        public string DealDetail { get; set; }
        public string AdditionalEmail { get; set; }

        public decimal? ExitFee { get; set; }
        public decimal? ExitFeePercentage { get; set; }
        public decimal? PrepayPremium { get; set; }
        public int? OriginalWFStatusPurposeMappingID { get; set; }


    }
}
