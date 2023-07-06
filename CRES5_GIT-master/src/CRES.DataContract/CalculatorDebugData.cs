using System;
using System.Collections.Generic;

namespace CRES.DataContract
{
    public class CalculatorDebugData
    {
        public string NoteName { get; set; }
        public string NoteId { get; set; }
        public Guid? AnalysisID { get; set; }
        public string CRENoteID { get; set; }
        public List<NotePeriodicOutputsDataContract> ListNotePeriodicOutput { get; set; }
        public List<BalanceTab> ListBalanceTab { get; set; }
        public List<CouponTab> ListCouponTab { get; set; }
        public List<PIKInterestTab> ListPIKInterestTab { get; set; }
        public List<FinancingTab> ListFinancingTab { get; set; }
        public List<RateTab> ListRateTab { get; set; }
        public List<FeesTab> ListFeesTab { get; set; }
        public List<DatesTab> ListDatesTab { get; set; }
        public List<GAAPBasisTab> ListGAAPBasisTab { get; set; }
        public List<FeeOutputDataContract> ListFeeOutput { get; set; }
        public List<FutureFundingScheduleTab> ListFutureFundingScheduleTab { get; set; }
        public List<MaturityScenariosDataContract> MaturityScenariosList { get; set; }

    }
}