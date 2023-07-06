using System;

namespace CRES.DataContract
{
    public class DailyGAAPBasisComponentsDataContract
    {
        public string NoteID { get; set; }
        public DateTime? Date { get; set; }
        public decimal? AccumAmortofDeferredFees { get; set; }
        public decimal? AccumulatedAmortofDiscountPremium { get; set; }
        public decimal? AccumulatedAmortofCapitalizedCost { get; set; }
        public decimal? EndingBalance { get; set; }
        public decimal? GrossDeferredFees { get; set; }
        public decimal? CleanCost { get; set; }
        public decimal? CurrentPeriodInterestAccrualPeriodEnddate { get; set; }
        public decimal? CurrentPeriodPIKInterestAccrualPeriodEnddate { get; set; }
        public decimal? InterestSuspenseAccountBalance { get; set; }
        public Guid? AnalysisID { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedDate { get; set; }
    }
}
