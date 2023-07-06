using System;

namespace CRES.DataContract
{
    public class FFutureFundingScheduleTab
    {
        public Guid? NoteID { get; set; }
        public DateTime? Date { get; set; }
        public decimal? Value { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public string PurposeText { get; set; }

    }
}
