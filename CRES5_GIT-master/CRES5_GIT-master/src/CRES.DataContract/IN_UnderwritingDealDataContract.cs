using System;

namespace CRES.DataContract
{
    public class IN_UnderwritingDealDataContract
    {
        public Guid? IN_UnderwritingDealID { get; set; }
        public string ClientDealID { get; set; }
        public string DealName { get; set; }
        public int? StatusID { get; set; }


        public string AssetManager { get; set; }
        public string DealCity { get; set; }
        public string DealState { get; set; }
        public string DealPropertyType { get; set; }
        public decimal? TotalCommitment { get; set; }
        public DateTime? FullyExtMaturityDate { get; set; }


        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
    }
}
