using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
