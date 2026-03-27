using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
   public  class SizerScenarioDataContract
    {
        public int? Maturity { get; set; }
        public decimal? Spread { get; set; }
        public string CRENoteID { get; set; }
        public int? BatchDetailID { get; set; }

    }
}
