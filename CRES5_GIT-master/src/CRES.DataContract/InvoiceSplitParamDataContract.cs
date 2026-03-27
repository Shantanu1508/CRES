using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class InvoiceSplitParamDataContract
    {
     public string DealID { get; set; }
     public int InvoiceTypeID { get; set; }
     public decimal? FeeAmount { get; set; }
    }
}
