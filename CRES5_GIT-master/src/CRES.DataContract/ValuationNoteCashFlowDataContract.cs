using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class ValuationNoteCashFlowDataContract
    {
        public DateTime MarkedDate { get; set; }
        public int? NoteCashFlowID { get; set; }
        public decimal? ValueOverride { get; set; }
        public string UserID { get; set; }
    }
}
