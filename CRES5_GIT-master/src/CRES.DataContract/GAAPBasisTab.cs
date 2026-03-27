using System;

namespace CRES.DataContract
{
    public partial class GAAPBasisTab
    {
        public GAAPBasisTab()
        { }

        public DateTime? Date { get; set; }
        public Decimal? CashFlowusedforLevelYieldPreCap { get; set; }
        public Decimal? PreCapLevelYield { get; set; }
        public Decimal? LockedPreCapBasis { get; set; }
        public Decimal? PeriodLevelYieldIncomePreCap { get; set; }
        public Decimal? Amort { get; set; }
        public Decimal? GrossDeferredFees { get; set; }
        public Decimal? CleanCost { get; set; }
        public Decimal? DeferredFeesReceivable { get; set; }
        public Decimal? GAAPIncomeforthePeriod { get; set; }
        public Decimal? AmortofDeferredFees { get; set; }
        public Decimal? AmortizedCost { get; set; }
        public Decimal? AccumAmortofDeferredFees { get; set; }
        public Decimal? EndingGAAPBookValue { get; set; }
        public Decimal? MinPrepaymentAmount { get; set; }
        public Decimal? UnamortizedPortionofOriginationFeePremiumExpenses { get; set; }
        public Decimal? AdditionalFeesPrepaymentFeesReceived { get; set; }
        public Decimal? CumCouponPIKInterestDailyAccrual { get; set; }
        public Decimal? ValueCap { get; set; }
        public Decimal? AdjustedBasissubjecttoCap { get; set; }
        public Decimal? AdjustedLevelYieldIncome { get; set; }
        public Decimal? AdjustedAmort { get; set; }
        public Decimal? AdjustedPeriodicYld { get; set; }
        public Decimal? CashFlowadjustedforServicingInfo { get; set; }
        public Decimal? CostBasis { get; set; }
        public Decimal? TotalPeriodGAAPIncome { get; set; }
        public Decimal? ActualBasis { get; set; }
        public Decimal? TotalStrippedCashFlow { get; set; }
        public Decimal? AllInBasis { get; set; }        
        public Decimal? NetPrincipalInflowOutflow { get; set; }
        public Decimal? ParBasis { get; set; }
        public Decimal? DeferredFeeAccrualBasis { get; set; }
        public Decimal? DeferredFeeAccrual { get; set; }
        public Decimal? DiscountPremiumAccrualBasis { get; set; }
        public Decimal? DiscountPremiumAccrual { get; set; }
        public Decimal? AccumulatedAmortofDiscountPremium { get; set; }
        public Decimal? CapitalizedCostsAccrualBasis { get; set; }
        public Decimal? CapitalizedCostAccrual { get; set; }
        public Decimal? AccumulatedAmortofCapitalizedCost { get; set; }
        public Decimal? PVBasis { get; set; }
        public Decimal? CleanCostPrice { get; set; }
        public Decimal? AmortizedCostPrice { get; set; }
        public Decimal? ActualYield { get; set; }
        public Decimal? CashFlowusedforLevelYieldAmort { get; set; }
    }
}