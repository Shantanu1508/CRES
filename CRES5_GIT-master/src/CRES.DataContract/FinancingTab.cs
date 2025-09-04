using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public partial class FinancingTab
    {
        public FinancingTab()
        { }

        public DateTime? Date { get; set; }
        public Decimal? BeginningFinancingBalance { get; set; }
        public Decimal? FinancingDrawsCurtailmentsfromFinancingDrawsSchedule { get; set; }
        public Decimal? FinancingDrawsCurtailmentsassociatedwithFutureFundingSchedule { get; set; }
        public Decimal? FinancingBalloon { get; set; }
        public Decimal? EndingFinancingBalance { get; set; }
        public Decimal? FinancingInterestExpense { get; set; }
        public int? FinancingInterestPaymentDate { get; set; }
        public Decimal? CumFinancingInterest { get; set; }
        public Decimal? FinancingInterestPaid { get; set; }
        public Decimal? FinancingFeesPaid { get; set; }
        public Decimal? TotalLeveredCashFlows { get; set; }

        public Decimal? Yield { get; set; }
        


    }
}
