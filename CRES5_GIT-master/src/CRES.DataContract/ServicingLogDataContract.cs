using System;

namespace CRES.DataContract
{
    public class ServicingLogDataContract
    {
        public ServicingLogDataContract()
        {
        }
        public DateTime? TransactionDate { get; set; }
        public int? TransactionType { get; set; }
        public string TransactionTypeText { get; set; }
        public Decimal? TransactionAmount { get; set; }
        public DateTime? RelatedtoModeledPMTDate { get; set; }
        public Decimal? ModeledPayment { get; set; }
        public Decimal? AmountOutstandingafterCurrentPayment { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public DateTime? TransactionDateOutput { get; set; }
        public int? TransactionTypeOutput { get; set; }
        public string TransactionTypeOutputText { get; set; }
        public Decimal? TransactionAmountOutput { get; set; }
        public DateTime? RelatedtoModeledPMTDateOutput { get; set; }
        public string FileName { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

    }
}
