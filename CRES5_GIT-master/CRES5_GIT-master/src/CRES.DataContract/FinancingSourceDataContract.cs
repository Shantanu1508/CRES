using System;

namespace CRES.DataContract
{
    public class FinancingSourceDataContract
    {
        public int? FinancingSourceMasterID { get; set; }
        public string FinancingSourceName { get; set; }
        public string FinancingSourceCode { get; set; }
        public string ParentClient { get; set; }
        public int? SortOrder { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
    }
}
