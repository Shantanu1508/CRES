using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class CommitmentEquityDataContract
    {
        public string Dealid { get; set; }

        public DateTime? Date { get; set; }
        public string Type { get; set; }
        public Decimal? DealAdjustmentHistory { get; set; }
        public Decimal? AdjustedCommitment { get; set; }
        public Decimal? TotalCommitment { get; set; }



    }


    public class NoteCommitmentEquityDataContract
    {
        public string NoteId { get; set; }
        public string CRENoteId { get; set; }
        public string DealID { get; set; }
        public DateTime? Date { get; set; }
        public string Type { get; set; }
        public Decimal? NoteAmount { get; set; }
        public Decimal? NoteAdjustedCommitment { get; set; }
        public Decimal? NoteTotalCommitment { get; set; }

        public Decimal? RequiredEquity { get; set; }

        public Decimal? AdditionalEquity { get; set; }

    }


    public class DealCommitmentEquityDataContract
    {

        public string DealID { get; set; }

        public int? Rownumber { get; set; }
        public DateTime? Date { get; set; }
        public int? Type { get; set; }
        public string TypeText { get; set; }

        public Decimal? DealAdjustmentHistory { get; set; }
        public Decimal? AdjustedCommitment { get; set; }
        public Decimal? TotalCommitment { get; set; }
        public Decimal? TotalRequiredEquity { get; set; }
        public Decimal? TotalAdditionalEquity { get; set; }
        //public Boolean? ExcludeFromCommitmentCalculation { get; set; }

        public string Comments { get; set; }


        public string NoteID { get; set; }

        public Decimal? Amount { get; set; }
        public Decimal? NoteAdjustedTotalCommitment { get; set; }
        public Decimal? NoteAggregatedTotalCommitment { get; set; }

        public Decimal? NoteTotalCommitment { get; set; }
    }
}
