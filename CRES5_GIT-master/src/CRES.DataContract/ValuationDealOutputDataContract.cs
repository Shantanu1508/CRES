using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public  class ValuationDealOutputDataContract
    {
        public string DealID { get; set; }
        public string CalculationStatus { get; set; }
        public DateTime LastCalculatedon { get; set; }
        public int? PayoffExtended { get; set; }
        public Decimal? DealMarkPriceClean { get; set; }
        public Decimal? DealGAAPPriceClean { get; set; }
        public Decimal? DealMarkClean { get; set; }
        public Decimal? DealUPB { get; set; }
        public Decimal? DealCommitment { get; set; }
        public Decimal? DealGAAPBasisDirty { get; set; }
        public Decimal? DealYieldatParClean { get; set; }
        public Decimal? DealYieldatGAAPBasis { get; set; }
        public Decimal? DealMarkYield { get; set; }
        public Decimal? CalculatedDealAccruedRate { get; set; }
        public Decimal? DealGAAPDM_GtrFLR_Index { get; set; }
        public Decimal? DealMarkDM_GtrFLR_Index { get; set; }
        public Decimal? DealDuration_OnCommitment { get; set; }
        public Decimal? GrossFloorValuefromGrid { get; set; }
        public Decimal? GrossValue_UsageScalar { get; set; }
        public Decimal? DollarValueofFloorinMark { get; set; }
        public Decimal? PointvalueofFloorinMark { get; set; }
        public Decimal? Term { get; set; }
        public Decimal? Strike { get; set; }
        public Decimal? MktStrike { get; set; }
        public string UserID { get; set; }
        public DateTime? MarkedDate { get; set; }
        

    }
}
