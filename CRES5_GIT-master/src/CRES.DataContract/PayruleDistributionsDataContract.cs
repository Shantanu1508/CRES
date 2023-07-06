using System;

namespace CRES.DataContract
{
    public class PayruleDistributionsDataContract
    {
        public int PayruleDistributionsID { get; set; }
        public string SourceNoteID { get; set; }
        public string ReceiverNoteID { get; set; }
        public decimal? Amount { get; set; }
        public int? RuleID { get; set; }

        public DateTime? TransactionDate { get; set; }

        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
    }
}