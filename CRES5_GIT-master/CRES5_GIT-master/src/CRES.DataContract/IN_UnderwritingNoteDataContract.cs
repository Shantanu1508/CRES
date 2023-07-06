using System;

namespace CRES.DataContract
{
    public class IN_UnderwritingNoteDataContract
    {

        public Guid? IN_UnderwritingNoteID { get; set; }
        public Guid? IN_UnderwritingAccountID { get; set; }
        public Guid? IN_UnderwritingDealID { get; set; }

        public string ClientNoteID { get; set; }
        public string ClientDealID { get; set; }
        public DateTime? ClosingDate { get; set; }
        public DateTime? FirstPaymentDate { get; set; }
        public DateTime? SelectedMaturityDate { get; set; }
        public decimal? InitialFundingAmount { get; set; }
        public decimal? OriginationFee { get; set; }
        public decimal? OriginationFeePct { get; set; }
        public int? IOTerm { get; set; }
        public int? AmortTerm { get; set; }
        public int? DeterminationDateLeadDays { get; set; }
        public int? DeterminationDateReferenceDayoftheMonth { get; set; }
        public int? RoundingMethod { get; set; }
        public string RoundingMethodText { get; set; }

        public int? IndexRoundingRule { get; set; }
        public int? StatusID { get; set; }
        public string StatusIDText { get; set; }


        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedDate { get; set; }

        public string Name { get; set; }
        public int? PayFrequency { get; set; }
        public string PayFrequencyText { get; set; }

        public DateTime? ExpectedMaturityDate { get; set; }
        public DateTime? ExtendedMaturityScenario1 { get; set; }
        public DateTime? ExtendedMaturityScenario2 { get; set; }
        public DateTime? ExtendedMaturityScenario3 { get; set; }

        public DateTime? InitialMaturityDate { get; set; }



        public int? lienposition { get; set; }
        public string lienpositionText { get; set; }
        public int? priority { get; set; }

        public int? NoteExistsInDiffDeal { get; set; }
        public string NoteExistsInDiffDealName { get; set; }


    }
}
