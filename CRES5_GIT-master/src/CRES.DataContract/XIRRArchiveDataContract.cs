using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class XIRRArchiveDataContract
    {
        public int XIRRConfigID { get; set; }
        public string XIRRConfigGUID { get; set; }
        public string ReturnName { get; set; }
        public string Type { get; set; }
        public string Tags { get; set; }
        public string TransactionType { get; set; }
        public string Scenario { get; set; }
        public DateTime? ArchiveDate { get; set; }
        public string Comments { get; set; }
        public string FileNameInput { get; set; }
        public string FileNameOutput { get; set; }

    }
}
