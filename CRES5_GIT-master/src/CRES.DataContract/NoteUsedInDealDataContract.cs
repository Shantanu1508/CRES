using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
 public   class NoteUsedInDealDataContract
    {
        public string NoteId { get; set; }         
        public string AccountID { get; set; }
        public string DealID { get; set; }
        public string CRENoteID { get; set; }
        public DateTime? ClosingDate { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? StatusID { get; set; }
        public string StatusName { get; set; }
        public string Name { get; set; }
        public int? UseRuletoDetermineNoteFunding { get; set; }
        public string UseRuletoDetermineNoteFundingText { get; set; }
        public int? NoteFundingRule { get; set; }
        public string NoteFundingRuleText { get; set; }
        public Decimal? NoteBalanceCap { get; set; }
        public int? FundingPriority { get; set; }
        public int? RepaymentPriority { get; set; }
        public DateTime? ExtendedMaturityCurrent { get; set; }       
        public DateTime? InitialMaturityDate { get; set; }
        public DateTime? ExpectedMaturityDate { get; set; }
        public DateTime? FullyExtendedMaturityDate { get; set; }
        public DateTime? OpenPrepaymentDate { get; set; }
        public DateTime? ActualPayoffDate { get; set; }
        public Decimal? TotalCommitment { get; set; }
        public int cntCritialException { get; set; }
        public int? LienPosition { get; set; }
        public string LienPositionText { get; set; }
        public int? Priority { get; set; }
        public string OldCRENoteID { get; set; }
        public string NoteRule { get; set; }
        public string OriginalCRENoteID { get; set; }
        public decimal? OriginalTotalCommitment { get; set; }
        public decimal? AdjustedTotalCommitment { get; set; }
        public decimal? AggregatedTotal { get; set; }
        public Decimal? InitialRequiredEquity { get; set; }
        public Decimal? InitialAdditionalEquity { get; set; }
        public string OriginalNoteName { get; set; }
        public Boolean Isexclude { get; set; }
        public int? PayFrequency { get; set; }
        public int? RoundingNote { get; set; }
        public string RoundingNoteText { get; set; }
        public decimal? StraightLineAmortOverride { get; set; }
        public int? UseRuletoDetermineAmortization { get; set; }
        public string MaturityGroupName { get; set; }
        public int? MaturityMethodID { get; set; }
        public string MaturityMethodIDText { get; set; }   
        public int? NoteType { get; set; }
        public string NoteTypeText { get; set; }
        public int? NoteSequenceNumber { get; set; }
        public decimal? InitialFundingAmount { get; set; }        
    }
}
