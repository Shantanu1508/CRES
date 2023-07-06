using System;

namespace CRES.DataContract
{
    public partial class Transaction
    {
        public Transaction()
        {

        }
        public DateTime? Date { get; set; }
        public Decimal? Amount { get; set; }
        public string Type { get; set; }
    }
}
