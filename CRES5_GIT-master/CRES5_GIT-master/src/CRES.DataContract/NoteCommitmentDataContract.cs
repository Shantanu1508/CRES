using System;

namespace CRES.DataContract
{
    public class NoteCommitmentDataContract
    {
        public DateTime? Date { get; set; }
        public string Type { get; set; }
        public decimal? Amount { get; set; }
        public int? Rownumber { get; set; }
        public decimal? TotalCommitmentAdjustment { get; set; }
        public decimal? TotalCommitment { get; set; }
    }
}
