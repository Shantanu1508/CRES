using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class ValuationMasterDataContract
    {
        public String UseDurSpreadVolWt { get; set; }
        public string GAAPBasisInputsIncludeAccrued { get; set; }
        public int MinimumExcessIOCredit { get; set; }
        public Decimal? PercentageofFloorValueincludedinMark { get; set; }
        public bool CalcAndSave { get; set; }
        public DateTime? FloorIndexDate { get; set; }
        public DateTime? MarkedDate { get; set; }

        public string PricingGridKey { get; set; }
        public Decimal? PricingGridMarketSOFRFloor { get; set; }
        public string CreatedBy { get; set; }
        public Decimal? LIBORForecast { get; set; }

        public List<ValuationModuleDataContract> PricingGridList { get; set; }
        public List<ValuationModuleDataContract> LTVSliceComponentPricing { get; set; }
        public List<FloorValueMasterDataContract> ListFloorValueMaster { get; set; }
        public List<FloorValueDetailDataContract> ListFloorValueDetail { get; set; }

        public List<ValuationDealOutputDataContract> ListDealoutput { get; set; }
        public List<ValuationNoteOutputDataContract> ListNoteoutput { get; set; }



    }
}
