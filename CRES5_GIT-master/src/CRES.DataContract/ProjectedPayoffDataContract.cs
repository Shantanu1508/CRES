using System;

namespace CRES.DataContract
{
    public class ProjectedPayoffDataContract
    {
        public DateTime? ProjectedPayoffAsofDate { get; set; }
        public Decimal? CumulativeProbability { get; set; }
        public DateTime? EarliestDate { get; set; }
        public DateTime? ExpectedDate { get; set; }
        public DateTime? LatestDate { get; set; }
        public DateTime? AuditUpdateDate { get; set; }
        public Guid? DealID { get; set; }
        public string ErrorMsg { get; set; }
        public string Status { get; set; }
        public string ExceptionMsg { get; set; }

    }
}
