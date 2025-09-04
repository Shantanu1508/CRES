using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class ValuationModuleDataContract
    {

        public DateTime? MarkedDate { get; set; }
        

        //PricingGrid
        public string PropertyName { get; set; }
        public Decimal? LTValueDecline { get; set; }

        //PricingGridDetailDealType
        public Decimal? DetailSlicePercentage { get; set; }
        public Decimal? DetailSliceValue { get; set; }
        public string DealTypeName { get; set; }
        public Decimal? DetailDealTypeValue { get; set; }
        public string CreatedBy { get; set; }
        public string UserID { get; set; }

        public int? SortOrder { get; set; }
        
    }
}
