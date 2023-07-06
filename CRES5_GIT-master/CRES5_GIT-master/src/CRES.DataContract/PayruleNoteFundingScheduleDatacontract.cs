using System;

namespace CRES.DataContract
{
    public class PayruleNoteFundingScheduleDatacontract
    {


        public Guid? NoteID { get; set; }
        public Decimal? Value { get; set; }
        public DateTime Date { get; set; }

        public Guid? DealID { get; set; }

    }
}
