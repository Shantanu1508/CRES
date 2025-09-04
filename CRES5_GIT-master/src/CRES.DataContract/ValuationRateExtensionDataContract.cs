using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class ValuationRateExtensionDataContract
    {
        public DateTime? MarkedDate { get; set; }
        public decimal? Value { get; set; }
        //UserID
        public string UserID { get; set; }
    }
}
