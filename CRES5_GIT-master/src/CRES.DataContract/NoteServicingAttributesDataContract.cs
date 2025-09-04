using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
   public class NoteServicingAttributesDataContract
    {
        public int NoteServicingAttributesID { get; set; }
        public int? NoteID { get; set; }
        public Decimal? OngoingAnnualizedServicingFee { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? IncludeServicingPaymentOverrideinLevelYield { get; set; }
        public string IncludeServicingPaymentOverrideinLevelYieldText { get; set; }

        
      
    }
}
