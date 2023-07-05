using System;

namespace CRES.DataContract
{
    public class InvoiceConfigDataContract
    {

        public int InvoiceConfigID { get; set; }
        public int InvoiceTypeID { get; set; }
        public string InvoiceCode { get; set; }
        public string Template { get; set; }
        public Boolean IsApplySplit { get; set; }
        public string InvoiceAccountNo { get; set; }

    }
}
