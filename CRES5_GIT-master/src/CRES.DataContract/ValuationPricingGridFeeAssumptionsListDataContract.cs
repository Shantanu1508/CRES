using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class ValuationPricingGridFeeAssumptionsListDataContract
    {
        public DateTime? MarkedDate { get; set; }
        public string UserID { get; set; }
        public string ValueType { get; set; }
        public decimal? Nonconstruction { get; set; }
        public decimal? Construction { get; set; }
    }
}
