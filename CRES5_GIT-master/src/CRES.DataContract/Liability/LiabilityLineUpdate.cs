using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract.Liability
{
    public class LiabilityLineUpdate
    {
        public DateTime? EffectiveDate { get; set; }
        public Decimal? Commitment { get; set; }
        public DateTime? InitialMaturityDate { get; set; }
    }
}
