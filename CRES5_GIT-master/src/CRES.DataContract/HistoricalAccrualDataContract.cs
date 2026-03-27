using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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


        public Decimal? gaapbv { get; set; }
        public Decimal? cum_am_disc { get; set; }
        public Decimal? feeamort { get; set; }
        public Decimal? cum_am_fee { get; set; }
        public Decimal? cum_dailypikint { get; set; }
        public Decimal? cum_baladdon_am { get; set; }
        public Decimal? cum_baladdon_nonam { get; set; }
        public Decimal? cum_dailyint { get; set; }
        public Decimal? cum_ddbaladdon { get; set; }
        public Decimal? cum_ddintdelta { get; set; }
        public Decimal? cum_am_capcosts { get; set; }
        public Decimal? endbal { get; set; }
        public Decimal? initbal { get; set; }
        public Decimal? cum_fee_levyld { get; set; }
        public Decimal? period_ddintdelta_shifted { get; set; }
        public Decimal? intdeltabal { get; set; }


    }
}
