using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class GeneralSetupDetailsDataContract
    {
        public DateTime? EffectiveDate { get; set; }
        public string AttributeName { get; set; }
        public string Value { get; set; }

    }
}
