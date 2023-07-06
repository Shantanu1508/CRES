using System;

namespace CRES.DataContract
{
    public partial class NoteRateHedgeScheduleDataContract
    {
        public NoteRateHedgeScheduleDataContract()
        {

        }

        public int NoteRateHedgeScheduleID { get; set; }
        public int? NoteID { get; set; }
        public DateTime? HedgeEffectiveDate { get; set; }
        public DateTime? HedgeUnwindDate { get; set; }
        public DateTime? HedgeMaturityDate { get; set; }
        public int? HedgePurpose { get; set; }
        public Decimal? HedgingNotional { get; set; }
        public Decimal? HedgingSpread { get; set; }
        public int? HedgingIndex { get; set; }
        public int? HedgingRateDayCount { get; set; }
        public int? HedgingRateType { get; set; }
        public int? HedgeType { get; set; }
        public int? HedgePayFrequency { get; set; }
        public int? HedgeCurrency { get; set; }

        public string HedgePurposeText { get; set; }
        public string HedgingIndexText { get; set; }
        public string HedgingRateDayCountText { get; set; }
        public string HedgingRateTypeText { get; set; }
        public string HedgeTypeText { get; set; }
        public string HedgePayFrequencyText { get; set; }
        public string HedgeCurrencyText { get; set; }

        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

    }
}
