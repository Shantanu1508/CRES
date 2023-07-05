using System;

namespace CRES.DataContract
{
    public class TransactionEntryVSTO
    {

        public string CRENoteID { get; set; }
        public DateTime? Date { get; set; }
        public Decimal? Amount { get; set; }
        public string Type { get; set; }
        public string FeeName { get; set; }
        public string SizerScenario { get; set; }


    }
}
