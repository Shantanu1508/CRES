using System;

namespace CRES.DataContract
{
    public class TransactionTypesDataContract
    {
        public Guid? UserID { get; set; }
        public int? TransactionTypesID { get; set; }
        public string TransactionName { get; set; }
        public string TransactionCategory { get; set; }
        public int? Calculated { get; set; }
        public string CalculatedText { get; set; }
        public int? IncludeCashflowDownload { get; set; }
        public string IncludeCashflowDownloadText { get; set; }
        public int? IncludeServicingReconciliation { get; set; }
        public string IncludeServicingReconciliationText { get; set; }
        public int? IncludeGAAPCalculations { get; set; }
        public string IncludeGAAPCalculationsText { get; set; }
        public int? AllowCalculationOverride { get; set; }
        public string AllowCalculationOverrideText { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string TransactionGroup { get; set; }
    }
}
