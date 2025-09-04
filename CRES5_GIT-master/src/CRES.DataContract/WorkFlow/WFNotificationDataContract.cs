using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract.WorkFlow
{
   
        public class WFNotificationDataContract
        {
        public string UserID { get; set; }
        public string TaskID { get; set; }
        public string Email { get; set; }
        public string UserName { get; set; }
        public string DealID { get; set; }
        public string DealName { get; set; }
        public string NextStatusName { get; set; }
        public DateTime FundingDate { get; set; }
        public double FundingAmount { get; set; }
        public DateTime DealLine { get; set; }
        public int WorkflowUserTypeID { get; set; }
        public string Comment { get; set; }
        public string ActivityLog { get; set; }
        public string FooterText { get; set; }
        public string SenderName { get; set; }
        public string DwarApprovalList { get; set; }
        public string AdditionalComments { get; set; }
        public string SpecialInstructions { get; set; }
        public string NoteswithAmount { get; set; }
        public string PreHeaderText { get; set; }
        public int? TaskTypeID { get; set; }
        public string ReserveScheduleBreakDown { get; set; }
        public int TaskType_ID { get; set; }

    }
}
