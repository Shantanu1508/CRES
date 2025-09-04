using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class ValuationModuleCurrentGridDataContract
    {
        public DateTime? MarkedDate { get; set; }
        public string PropertyType { get; set; }
        public string DealType { get; set; }
        public Decimal? AnoteLTV { get; set; }
        public Decimal? AnoteSpread { get; set; }
        public Decimal? ABwholeLoanLTV { get; set; }
        public Decimal? ABwholeLoanSpread { get; set; }
        public Decimal? EquityLTV { get; set; }
        public Decimal? EquityYield { get; set; }
        public string UserID { get; set; }

    }
}
