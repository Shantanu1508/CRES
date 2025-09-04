using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class AutoRepaymentBalancesDataContract
    {
        public DateTime? Date { get; set; }
        public Decimal? Amount { get; set; }
        public string Type { get; set; }
        public string DealID { get; set; }
    }
}
