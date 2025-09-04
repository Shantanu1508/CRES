using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class GenericVSTOResult
    {
        public bool Succeeded { get; set; }
        public string Message { get; set; }
        public DataTable apiResult { get; set; }
        public string Status { get; set; }
        public string Progress { get; set; }
        public string CRENoteID { get; set; }
        public string Comment { get; set; }
    }
}
