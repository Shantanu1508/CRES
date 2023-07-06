using System;

namespace CRES.DataContract
{
    public class PIKDistributionsDataContract
    {

        public Guid? SourceNoteID { get; set; }
        public Guid? ReceiverNoteID { get; set; }
        public DateTime? TransactionDate { get; set; }
        public Decimal? Amount { get; set; }
    }
}
