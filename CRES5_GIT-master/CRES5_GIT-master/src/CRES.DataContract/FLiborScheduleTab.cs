using System;

namespace CRES.DataContract
{
    public class FLiborScheduleTab
    {
        public DateTime? Date { get; set; }
        public decimal? Value { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public decimal? Indexoverrides { get; set; }
    }
}
