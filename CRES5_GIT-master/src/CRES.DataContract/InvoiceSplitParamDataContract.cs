namespace CRES.DataContract
{
    public class InvoiceSplitParamDataContract
    {
        public string DealID { get; set; }
        public int InvoiceTypeID { get; set; }
        public decimal? FeeAmount { get; set; }
    }
}
