using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
