using System;

namespace CRES.DataContract
{
    public partial class BalanceTab
    {
        public BalanceTab()
        { }
        public DateTime? Date { get; set; }
        public int? AccrualPeriodEndDateTag { get; set; }
        public int? RemainingIOTerm { get; set; }
        public int? RemainingAmortTermMo { get; set; }
        public Decimal? BeginningBalance { get; set; }
        public Decimal? FutureAdvancesFromFutureFundingSchedule { get; set; }
        public Decimal? PIKInterestfromPIKSourceNote { get; set; }
        public int? PMTDateTag { get; set; }
        public int? PMTDateTagWorkingdayAdjusted { get; set; }
        public Decimal? AccrualforAmortCalc { get; set; }
        public Decimal? ScheduledPrincipal { get; set; }
        public Decimal? PMTforAmortCalc { get; set; }
        public Decimal? PrincipalPaid { get; set; }
        public Decimal? PrincipalReceivedperServicing { get; set; }
        public Decimal? BalloonPayment { get; set; }
        public Decimal? DefaultPeriodTag { get; set; }
        public Decimal? DebtServiceShortfall { get; set; }
        public Decimal? ScheduledPrincipalShortfall { get; set; }
        public Decimal? PrincipalShortfall { get; set; }
        public Decimal? PrincipalLoss { get; set; }
        public Decimal? EndingBalance { get; set; }
        public Decimal? AccumulatedFundingForThePeriod { get; set; }
        public Decimal? CumFutureAdvancesForAccrualPeriod { get; set; }
        public Decimal? DiscretionaryCurtailmentsForThePeriod { get; set; }
        public int PeriodPMTDropTag { get; set; }
        public Decimal? PMTDropDateTag { get; set; }
        public Decimal? EndingBalanceUsingPMTDropDate { get; set; }
        public Decimal? DiscretionaryCurtailmentsForThePeriodAdjustedforPMTDropDate { get; set; }
        public Decimal? AccumulatedFundingForThePeriodAdjustedforPMTDropDate { get; set; }
        public Decimal? AmortizationPaydownAmount { get; set; }
        public Decimal? NonAmortizationPaydownAmount { get; set; }
        public Decimal? AmortizationEndingBalanceAddon { get; set; }
        public Decimal? NonAmortizationEndingBalanceAddon { get; set; }
        public Decimal? AmortizationEndingBalanceAddonPMTDropDate { get; set; }
        public Decimal? NonAmortizationEndingBalanceAddonPMTDropDate { get; set; }
        public int SoftPayOffFlag { get; set; }



    }
}
