using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public partial class RateTab
    {
        public RateTab()
        {

        }

        public DateTime? rateDate { get; set; }
        public string IndexName { get; set; }
        public string DeterminationDateHolidayList { get; set; }
        public int? InterestAccrualPeriodEndDateTag { get; set; }
        public Decimal? IndexValueusingFloatingRateIndexReferenceDate { get; set; }
        public Decimal? IndexValueWithoutRounding { get; set; }
        public Decimal? DIndexValueusingFloatingRateIndexReferenceDate { get; set; }
        public Decimal? IndexFloor { get; set; }
        public Decimal? IndexCap { get; set; }
        public Decimal? CouponSpread { get; set; }
        public Decimal? CouponRate { get; set; }
        public Decimal? CouponFloor { get; set; }
        public Decimal? CouponCap { get; set; }
        public Decimal? CouponDefaultRateStepUp { get; set; }
        public Decimal? CouponDefaultRateOverride { get; set; }
        public Decimal? AllInCouponRate { get; set; }
        public Decimal? CouponStrip { get; set; }
        public Decimal? AmortSpread { get; set; }
        public Decimal? AmortRate { get; set; }
        public Decimal? AmortRateFloor { get; set; }
        public Decimal? AmortRateCap { get; set; }
        public Decimal? AmortDefaultRateStepUp { get; set; }
        public Decimal? AmortDefaultRateOverride { get; set; }
        public Decimal? AllInAmortRate { get; set; }
        public Decimal? AdditionalPIKinterestRatefromPIKTable { get; set; }
        public Decimal? AdditionalPIKSpreadfromPIKTable { get; set; }
        public Decimal? PIKIndexFloorfromPIKTable { get; set; }
        public Decimal? AllInPIKInterest { get; set; }
        public Decimal? PIKInterestCompoundingRatefromPIKTable { get; set; }
        public Decimal? PIKInterestCompoundingSpreadfromPIKTable { get; set; }
        public Decimal? AllInPIKInterestCompoundingRate { get; set; }
        public Decimal? SeverityatDefault { get; set; }
        public Decimal? FinancingRate { get; set; }
        public Decimal? FinancingSpread { get; set; }
        public Decimal? AllinFinancingCOF { get; set; }
        public Decimal? FinancingAdvanceRate { get; set; }

        public string RateType { get; set; }
        public string PIKReasonCodeText { get; set; }
        public string PIKComments { get; set; }
    }
}
