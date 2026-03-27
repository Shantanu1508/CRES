using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
   public class EffectiveDateDataContract
    {
        public Nullable<System.DateTime> EffectiveDate { get; set; }
        public Nullable<int> EventTypeID { get; set; }
        public string EventTypeText { get; set; }
    }
}
