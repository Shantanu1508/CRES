using System;

namespace CRES.DataContract
{
    public partial class OutputArrayTab
    {
        public OutputArrayTab()
        { }
        public DateTime? EffectiveDate { get; set; }
        public DateTime? TransactionDate { get; set; }
        public Decimal? FeeandCouponStripping { get; set; }
        public Decimal? DailyAccruedInterest { get; set; }
        public Decimal? ScheduledPrincipal { get; set; }
        public Decimal? PrincipalPaid { get; set; }
        public Decimal? DailyAccruedPIKInterest { get; set; }
        public Decimal? DailyAccruedCompoundedPIKInterest { get; set; }

    }


}
