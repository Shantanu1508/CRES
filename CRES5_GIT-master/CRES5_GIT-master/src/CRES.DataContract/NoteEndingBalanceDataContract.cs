using System;

namespace CRES.DataContract
{
    public class NoteEndingBalanceDataContract
    {
        public DateTime? Date { get; set; }
        public Decimal? EndingBalance { get; set; }
        public string NoteID { get; set; }
        public string NotenName { get; set; }
        public Decimal? RepayToBeAdjustedUseRuleN { get; set; }
    }
}
