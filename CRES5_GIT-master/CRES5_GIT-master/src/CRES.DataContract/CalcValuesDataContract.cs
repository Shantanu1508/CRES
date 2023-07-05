using System;

namespace CRES.DataContract
{
    public class CalcValuesDataContract
    {
        public Guid? AccountID { get; set; }
        public int? CalcValueID { get; set; }
        public DateTime? Date { get; set; }
        public Guid? RegisterID { get; set; }
        public string TransactionType { get; set; }
        public decimal? Amount { get; set; }
        public Boolean IsActual { get; set; }
        public int? CurrencyID { get; set; }
        public string CreatedBy { get; set; }


    }
}
