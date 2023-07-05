using System;

namespace CRES.DataContract
{
    public class SchedulerConfigDataContract
    {
        public int SchedulerConfigID { get; set; }
        public string SchedulerName { get; set; }
        public string APIname { get; set; }
        public string Description { get; set; }
        public int? ObjectTypeID { get; set; }
        public int? ObjectID { get; set; }
        public string ExecutionTime { get; set; }
        public DateTime? NextexecutionTime { get; set; }
        public string Frequency { get; set; }
        public int Status { get; set; }
        public string JobStatus { get; set; }
        public int GroupID { get; set; }
        public int ServerIndex { get; set; }
        public int SortOrder { get; set; }
        public int? IsEnableDayLightSaving { get; set; }
        public string Timezone { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string GeneratedBy { get; set; }
    }
}
