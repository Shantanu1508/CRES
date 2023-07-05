using System;

namespace CRES.DataContract
{
    public class PeriodicDataContract
    {
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string AzureBlobLink { get; set; }
        public string UserID { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public DateTime? MaxEndDate { get; set; }
        public int? PeriodAutoID { get; set; }
        public Guid? PeriodID { get; set; }
        public string Message { get; set; }
        public Guid? AnalysisID { get; set; }
        public string PeriodIDs { get; set; }
        public bool IsOpenPeriod { get; set; }
        public string AnalysisName { get; set; }
    }
}
