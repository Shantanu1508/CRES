using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public partial class CouponTab
    {
        public CouponTab()
        {
        }
        public DateTime? Date { get; set; }
        public string InterestCalcMethod { get; set; }
        public int? NumberofDaysinReferencedAccrualPeriod { get; set; }
        public Decimal? InterestCalcMethodAdjustment30_360vsActual_360 { get; set; }
        public Decimal? InterestAccrualPeriodEndDateTag { get; set; }
        public Decimal? DailyAccruedInterestbeforeStrippingRule { get; set; }
        public Decimal? DailyAccruedCouponStripping { get; set; }
        public Decimal? DailyAccruedInterest { get; set; }
        public Decimal? AccumInterestforCurrentAccrualPeriod { get; set; }
        public Decimal? AccumCouponStrippingforCurrentAccrualPeriod { get; set; }
        public Decimal? InterestforthePeriodShortfall { get; set; }
        public Decimal? InterestPaidonPMTDateShortfall { get; set; }
        public Decimal? CumulativeInterestPaidonPMTDateShortfall { get; set; }
        public Decimal? InterestShortfallLoss { get; set; }
        public Decimal? InterestShortfallRecovery { get; set; }
        public Decimal? InterestforthePeriod { get; set; }
        public Decimal? InterestPaidonPaymentDate { get; set; }
        public Decimal? InterestPaidperServicing { get; set; }
        public Decimal? CouponStrippingforthePeriod { get; set; }
        public Decimal? CouponStrippedonPaymentDate { get; set; }
        public int? ServicingOverrideTag { get; set; }
        public Decimal? CouponbasedonFutureFunding { get; set; }
        public Decimal? AccumCouponbasedonFutureFunding { get; set; }
        public Decimal? InterestSuspenseAdjustment { get; set; }
        public Decimal? InterestSuspenseAccountActivityforthePeriod { get; set; }
        public Decimal? InterestSuspenseAccountBalance { get; set; }
        public Decimal? PMTDropDateDailyAccruedInterestbeforeStrippingRule { get; set; }
        public Decimal? PMTDropDateDailyAccruedCouponStripping { get; set; }
        public Decimal? PMTDropDateDailyAccruedInterest { get; set; }
        public Decimal? PMTDropDateDailyAccruedInterestAddOn { get; set; }
        public Decimal? PMTDropDateAccumInterestforCurrentAccrualPeriod { get; set; }
        public Decimal? PMTDropDateAccumInterestforCurrentAccrualPeriodAddOn { get; set; }
        public Decimal? PMTDropDateAccumCouponStrippingforCurrentAccrualPeriod { get; set; }
        public Decimal? PMTDropDateInterestforthePeriod { get; set; }
        public Decimal? PMTDropDateInterestPaidonPaymentDate { get; set; }
        public Decimal? PMTDropDateInterestPaidperServicing { get; set; }
        public Decimal? PMTDropDateCouponStrippingforthePeriod { get; set; }
        public Decimal? PMTDropDateCouponStrippedonPaymentDate { get; set; }
        public Decimal? InterestPaid { get; set; }
        public Decimal? InterestPaidDeltaforthePeriod { get; set; }
        public Decimal? CoveredDelta { get; set; }
        public Decimal? DeltaBalance { get; set; }
        public Decimal? DailySpreadInterestbeforeStrippingRule { get; set; }
        public Decimal? DailyLiborInterestbeforeStrippingRule { get; set; }
        public Decimal? InterestPaidServicingWithDropDate { get; set; }
        public Decimal? CouponStripReceivable { get; set; }
        public Decimal? UnpaidInterest { get; set; }
        public Decimal? InterestPastDue { get; set; }
        public Decimal? CashInterest { get; set; }
        public Decimal? CapitalizedInterest { get; set; }
    }
}
