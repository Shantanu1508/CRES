using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public partial class OutputNPVdata
    {
        public OutputNPVdata()
        { }


        public Guid? NoteID { get; set; }
        public Guid? OutputNPVdataID { get; set; }

        public DateTime? NPVdate { get; set; }

        //NPVvalue,NPVnetFeeValue,NPVactual 
        public Decimal?  CashFlowUsedForLevelYieldPrecap { get; set; }
        public Decimal?  Actualbasis{ get; set; }
      
        public Decimal? Cost { get; set; }
        public decimal? Value { get; set; }
        
    
       
    }
}
