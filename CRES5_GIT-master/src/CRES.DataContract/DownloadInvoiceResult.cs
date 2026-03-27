using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class DownloadInvoiceResult
    {
        public bool Succeeded { get; set; }
        public string Message { get; set; }
        public string FileName { get; set; }
        public byte[] FileByte { get; set; }
    }

}
