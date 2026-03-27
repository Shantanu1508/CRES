using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class BackshopInvoiceResult
    {
        public bool Succeeded { get; set; }
        public string Message { get; set; }
        public string InvoiceNo { get; set; }
        public string FileName { get; set; }


    }
}
