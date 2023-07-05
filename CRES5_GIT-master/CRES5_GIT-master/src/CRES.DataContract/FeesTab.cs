using System;

namespace CRES.DataContract
{
    public partial class FeesTab
    {
        public FeesTab()
        { }
        public DateTime? Date { get; set; }
        public Decimal? DailyFeeAmount { get; set; }
        public Decimal? FeeAmountAllIn { get; set; }
        public Decimal? FeeAmountIncludedinLevelYield { get; set; }
        public Decimal? StrippedFeeReceivableInclInLY { get; set; }
        public Decimal? StrippedFeeReceivableExclFromLY { get; set; }
        public Decimal? NewAdditionalFees { get; set; }
        public Decimal? PrepaymentExitFees { get; set; }
        public Decimal? StrippedFeesCouponReceivedfromSourceNote { get; set; }



    }
}