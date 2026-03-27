using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class YieldDataContract
    {
        public YieldDataContract() { }
        public YieldDataContract(DateTime? effDate, string Type, Decimal? yield) 
        {
            EffectiveDate = effDate;
            YieldType = Type;
            Yield = yield;
        }
        public YieldDataContract(DateTime? effDate, string Type, double yield) : this(effDate, Type, Convert.ToDecimal(yield)) { }
        public DateTime? EffectiveDate { get; set; }
        public string YieldType { get; set; }
        public Decimal? Yield { get; set; }

    }
}
