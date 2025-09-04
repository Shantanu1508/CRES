using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class InvoiceReferenceDataContract
    {
        public int InvoiceReferenceDataID { get; set; }
        public int InvoiceDetailID { get; set; }
        public string Key { get; set; }
        public string Value { get; set; }
        
    }
}
