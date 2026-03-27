using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class ValuationProjectedPayoffCalcDataContract
    {

        public DateTime MarkedDate { get; set; }
        public string ControlID { get; set; }
        public string DealName { get; set; }
        public string Client { get; set; }
        public string PropertyType { get; set; }
        public string OpenDate { get; set; }
        public string UserID { get; set; }

    }
}
