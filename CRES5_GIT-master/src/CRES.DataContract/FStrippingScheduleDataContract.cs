using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class FStrippingScheduleDataContract
    {
        public Guid? NoteID { get; set; }      
      
        public DateTime? EffectiveDate { get; set; }         
       
        public DateTime? Date { get; set; }
        public decimal? Value { get; set; }
        public int? ValueTypeID { get; set; }
        public string ValueTypeText { get; set; }
        public decimal? IncludedLevelYield { get; set; }
        public decimal? IncludedBasis { get; set; }
       
    }
}
