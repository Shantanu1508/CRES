using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class XIRRReturnGroupDataContract
    {
        public int XIRRReturnGroupID { get; set; }
        public int XIRRConfigID { get; set; }
        public string Type { get; set; }
        public string ReturnName { get; set; }
        public string ChildReturnName { get; set; }
        public string Group1 { get; set; }
        public string Group2 { get; set; }
        public string AnalysisID { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string LoanStatus { get; set; }
        public string FileName_Input { get; set; }

    }
}
