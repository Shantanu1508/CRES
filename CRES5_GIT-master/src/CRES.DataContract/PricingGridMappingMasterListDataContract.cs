using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class PricingGridMappingMasterListDataContract
    {
        public DateTime? MarkedDate { get; set; }
        public string DealTypeName { get; set; }
        public string DealTypeMapping { get; set; }         
        public string UserID { get; set; }

    }
}
