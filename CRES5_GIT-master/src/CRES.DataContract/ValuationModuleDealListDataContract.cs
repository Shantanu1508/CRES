using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class ValuationModuleDealListDataContract
    {
        public DateTime? MarkedDate { get; set; }
        public String Calculate { get; set; }
        public string DealID { get; set; }
        public string Scenario { get; set; }
        public string IndexType { get; set; }
        public Decimal? IndexForecast { get; set; }
        public Decimal? IndexFloor { get; set; }
        public string ExcludefromServerCalculation { get; set; }
        public string PORTFOLIO { get; set; }
        public Decimal? LastIndexReset { get; set; }
        public int? PaymentDay { get; set; }
        public Decimal? PriceCaptoThirdParty { get; set; }
        public Decimal? DealNominalDMOrPriceForMark { get; set; }
        public Decimal? DMAdjustment { get; set; }
        public DateTime? StubInterestinAdvancelastaccrualDate { get; set; }
        public Decimal? IOValuationmo { get; set; }
        public Decimal? PendingPayoff { get; set; }
        public Decimal? PpayAdjustedAL { get; set; }
        public string MaterialMezz { get; set; }
        public string SliverMezz { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdateBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string UserID { get; set; }
        public string IsCashFlowLive { get; set; }

    }
}
