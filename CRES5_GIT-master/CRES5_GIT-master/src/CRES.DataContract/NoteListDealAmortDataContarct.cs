using System;

namespace CRES.DataContract
{
    public class NoteListDealAmortDataContarct
    {
        public string NoteId { get; set; }
        public string CRENoteID { get; set; }
        public string Name { get; set; }
        public DateTime? MaturityDate { get; set; }
        public int? LienPosition { get; set; }
        public string LienPositionText { get; set; }
        public int? Priority { get; set; }
        public int? IOTerm { get; set; }
        public decimal? AmortRate { get; set; }
        public Decimal? TotalCommitment { get; set; }
        public decimal? EstimatedCurrentBalance { get; set; }
        public int? AmortTerm { get; set; }
        public int? RoundingNote { get; set; }
        public string RoundingNoteText { get; set; }
        public decimal? StraightLineAmortOverride { get; set; }
        public int? UseRuletoDetermineAmortization { get; set; }
        public string UseRuletoDetermineAmortizationText { get; set; }
        public DateTime? InitialInterestAccrualEndDate { get; set; }
        public Decimal? InitialFundingAmount { get; set; }

        public Decimal? Ratio { get; set; }
        public Decimal? NoteAmortSchedleAmount { get; set; }
        public DateTime? ActualPayoffDate { get; set; }
        public DateTime? FullyExtendedMaturityDate { get; set; }
        public DateTime? InitialMaturityDate { get; set; }
        public DateTime? FirstPaymentDate { get; set; }


    }
}
