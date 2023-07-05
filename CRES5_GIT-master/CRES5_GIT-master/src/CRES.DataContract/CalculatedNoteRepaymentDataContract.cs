using System;

namespace CRES.DataContract
{
    public class CalculatedNoteRepaymentDataContract
    {

        public DateTime? Date { get; set; }
        public String NoteID { get; set; }
        public Decimal? Value { get; set; }
        public Decimal? BeginningBalance { get; set; }
        public Decimal? CurrentCPRandSLRFactor { get; set; }
        public Decimal? MonthlyCPRandSLRFactor { get; set; }
        public Decimal? CummulativeRepayments { get; set; }
        public Decimal? EndingBalance { get; set; }
    }
}
