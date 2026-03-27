using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
   public class CalculatorTimeAnalysis
    {
       
        public string Method { get; set; }
        public DateTime EffectiveDate { get; set; }
        public string Message { get; set; }
        public DateTime LogTime { get; set; }

    }
}
