using System;

namespace CRES.DataContract
{
    public class HistoricalAccrualDataContract
    {
        public Guid? NoteID { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public DateTime? PeriodDate { get; set; }
        public Decimal? PVBasis { get; set; }
        public Decimal? DeferredFeeAccrual { get; set; }
        public Decimal? DiscountPremiumAccrual { get; set; }
        public Decimal? CapitalizedCostAccrual { get; set; }
        public Decimal? AllInBasisValuation { get; set; }
        public Guid HistAccrualID { get; set; }


    }
}
