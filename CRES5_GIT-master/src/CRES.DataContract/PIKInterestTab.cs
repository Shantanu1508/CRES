using System;

namespace CRES.DataContract
{
    public partial class PIKInterestTab
    {
        public PIKInterestTab()
        { }
        public DateTime? Date { get; set; }
        public Decimal? PIKInterestCapfromPIKTable { get; set; }
        public Decimal? NotePIKCapBalancefromPIKTable { get; set; }
        public Decimal? DailyAccruedPIKInterest { get; set; }
        public Decimal? DailyAccruedPIKInterestAdjustedforPIKInterestCap { get; set; }
        public int? AccrualPeriodEndDateTag { get; set; }
        public Decimal? AccumPIKInterestforCurrentAccrualPeriod { get; set; }
        public Decimal? PIKInterestforthePeriod { get; set; }
        public Decimal? CumPIKInterest { get; set; }
        public Decimal? BeginningPIKBalanceifnotCompoundedinsideLoanBalance { get; set; }
        public Decimal? DailyAccruedCompoundedPIKInterest { get; set; }
        public Decimal? AccumCompoundedPIKInterestforCurrentAccrualPeriod { get; set; }
        public Decimal? PIKInterestforthePeriodBalloon { get; set; }
        public Decimal? PIKBalanceBalloonPayment { get; set; }
        public Decimal? EndingPIKBalanceifnotCompoundedinsideLoanBalance { get; set; }
        public Decimal? DailyAccruedPIKInteresttobeTransferredtoRelatedNote { get; set; }
        public Decimal? AccumPIKInteresttobeTransferredtoRelatedNoteforCurrentAccrualPeriod { get; set; }
        public Decimal? TotalPIKInteresttobeTransferredtoRelatedNoteforthePeriod { get; set; }
        public Decimal? PIKInterestPaidForThePeriod { get; set; }
        public Decimal? PIKInterestPaidAppliedForThePeriod { get; set; }
        public Decimal? PIKInterestOnPMTDate { get; set; }
        public Decimal? PIKInterestonBusinessAdjInterestAccrualEndDate { get; set; }
        public int? PIKBusinessDateAdjcheck { get; set; }
        public Decimal? PIKPrincipalPaidForThePeriod { get; set; }
        public Decimal? UnPaidPIK { get; set; }

        public string PIKComments { get; set; }
        public string PIKReasonCodeText { get; set; }


    }

}
