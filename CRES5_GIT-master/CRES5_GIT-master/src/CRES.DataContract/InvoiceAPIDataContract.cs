namespace CRES.DataContract
{
    public class InvoiceAPIDataContract
    {
        public bool IsDuplicateInvoice { get; set; }
        public int StateID { get; set; }
        public int InvoiceTypeID { get; set; }
        public string DealName { get; set; }
        public string AMEmails { get; set; }
    }
}
