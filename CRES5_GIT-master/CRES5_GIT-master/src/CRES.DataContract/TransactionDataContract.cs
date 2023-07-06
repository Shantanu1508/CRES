using System;

namespace CRES.DataContract
{
    public class TransactionDataContract
    {
        public Guid? PeriodID { get; set; }
        public Guid? RegisterID { get; set; }
        public string TransactionType { get; set; }
        public DateTime? Date { get; set; }
        public decimal? Amount { get; set; }
        public Boolean IsActual { get; set; }
        public int? CurrencyID { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
    }
}
