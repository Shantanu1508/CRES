using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class InvoicesLandingDataContract
    {
        public int? InvoiceDetailID { get; set; }
        public string DealID { get; set; }
        public string CustomerName { get; set; }
        public DateTime? InvoiceDate { get; set; }
        public string InvoiceNo { get; set; }
        public string ItemCode { get; set; }
        public string Description { get; set; }
        public decimal? Amount { get; set; }
        public string Memo { get; set; }
        public decimal? AmountPaid { get; set; }
        public DateTime? PaymentDate{ get; set; }
        public string Status { get; set; }

    }
}
