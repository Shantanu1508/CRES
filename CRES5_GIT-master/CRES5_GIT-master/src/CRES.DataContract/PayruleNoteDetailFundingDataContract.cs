using System;

namespace CRES.DataContract
{
    public class PayruleNoteDetailFundingDataContract
    {
        public Guid NoteID { get; set; }
        public string CRENoteID { get; set; }
        public string NoteName { get; set; }
        public string UseRuletoDetermineNoteFundingText { get; set; }
        public int? UseRuletoDetermineNoteFunding { get; set; }
        public int? NoteFundingRule { get; set; }
        public string NoteFundingRuleText { get; set; }
        public decimal? NoteBalanceCap { get; set; }
        public int? FundingPriority { get; set; }
        public int? RepaymentPriority { get; set; }
        public decimal? TotalCommitment { get; set; }


        public int? Lienposition { get; set; }
        public int? Priority { get; set; }
        public decimal? InitialFundingAmount { get; set; }
        public decimal? AdditionalBalance { get; set; }

        public decimal? AdditionalRepaymentBalance { get; set; }
        public decimal? AdjustedTotalCommitment { get; set; }
        public decimal? AggregatedTotal { get; set; }
        public decimal? CommitmentUsedInFFDistribution { get; set; }
        public decimal? Paydown { get; set; }
    }
}