using System;

namespace CRES.DataContract
{
    public class IndexTypeDataContract
    {
        public System.Guid IndexesId { get; set; }
        public DateTime Date { get; set; }
        public int? IndexType { get; set; }
        public string Name { get; set; }
        public decimal? Value { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }

        public string AnalysisID { get; set; }
        public int IndexesMasterID { get; set; }
        public System.Guid? IndexesMasterGuid { get; set; }
    }
}
