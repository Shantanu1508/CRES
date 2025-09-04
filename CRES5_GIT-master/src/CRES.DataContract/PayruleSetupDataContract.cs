using System;

namespace CRES.DataContract
{
    public class PayruleSetupDataContract
    {
        public int PayruleSetupID { get; set; }
        public string StripTransferFrom { get; set; }
        public string StripTransferTo { get; set; }

        public string DealID { get; set; }
         

        public decimal? Amount { get; set; }
        public decimal? Value { get; set; }
        public int? RuleID { get; set; }
        public string RuleIDText { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
    }
}