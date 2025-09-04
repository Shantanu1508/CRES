using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public partial class TransactionEntry
    {
        public TransactionEntry()
        {

        }
        public int BatchDetailAsyncCalcVSTOId { get; set; }
        public string CRENoteID { get; set; }
        public string NoteName { get; set; }
        public DateTime? Date { get; set; }
        public Decimal? Amount { get; set; }
        public Guid? AnalysisID { get; set; }
        public string Type { get; set; }
        public string FeeName { get; set; }
        public string FeeTypeName { get; set; }
        public string Comment { get; set; }
        public string SizerScenario { get; set; }
        public string PurposeType { get; set; }
        public DateTime? PaymentDateNotAdjustedforWorkingDay { get; set; }
        public DateTime? TransactionDateByRule { get; set; }
        public DateTime? TransactionDateServicingLog { get; set; }
        public DateTime? RemittanceDate { get; set; }
        public string AdjustmentType { get; set; }
        public Boolean isdeleted { get; set; }
        public Decimal? AllInCouponRate { get; set; }
        public DateTime? IndexDeterminationDate { get; set; }
        public Decimal? BalloonRepayAmount { get; set; }
        public Decimal? IndexValue { get; set; }
        public Decimal? SpreadValue { get; set; }
        public Decimal? OriginalIndex { get; set; }
        public Decimal? LiborPercentage { get; set; }

    }
}
