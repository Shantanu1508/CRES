using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class TaskManagementDataContract
    {
        public string TaskID { get; set; }
        public int TaskAutoID { get; set; }
        public int? Priority { get; set; }
        public int? TaskType { get; set; }
        public int? Status { get; set; }
        public string PriorityText { get; set; }
        public string TaskTypeText { get; set; }
        public string StatusText { get; set; }
        public string Summary { get; set; }
        public string Description { get; set; }
        public string CategoryTag { get; set; }
        public string SubCategoryTag { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? DeadlineDate { get; set; }
        public string AssignedTo { get; set; }
        public string AssignedToText { get; set; }
        public DateTime? EstimatedCompletionDate { get; set; }
        public DateTime? ActualCompletionDate { get; set; }
        public string Tag1 { get; set; }
        public string Tag2 { get; set; }
        public string Tag3 { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedDate { get; set; }

        public int? ActivityType { get; set; }
        public string Displaymessage { get; set; }

        public string OldAssignedTo { get; set; }
        public string OldTaskID { get; set; }
        public int? OldPriority { get; set; }
        public int? OldTaskType { get; set; }
        public int? OldStatus { get; set; }
        public DateTime? OldDeadlineDate { get; set; }
        public Guid? UserID { get; set; }
    }
}
