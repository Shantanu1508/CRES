using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class NoteServicingLogDataContract
    {

        public Guid TransactionId { get; set; }
        public Guid NoteId { get; set; }
        public Nullable<System.DateTime> TransactionDate { get; set; }
        public Nullable<int> TransactionType { get; set; }

        public string TransactionTypeText { get; set; }
        public decimal? TransactionAmount { get; set; }
        public Nullable<System.DateTime> RelatedtoModeledPMTDate { get; set; }
        public Nullable<decimal> ModeledPayment { get; set; }
        public Nullable<decimal> AmountOutstandingafterCurrentPayment { get; set; }

        public decimal? ServicingAmount { get; set; }
        public decimal? CalculatedAmount { get; set; }
        public decimal? Delta { get; set; }
        public bool? M61Value { get; set; }
        public bool? ServicerValue { get; set; }
        public bool? Ignore { get; set; }
        public decimal? OverrideValue { get; set; }
        public int? OverrideReason { get; set; }
        public string OverrideReasonText { get; set; }
        public string comments { get; set; }
        public string Exception { get; set; }
        public string SourceType { get; set; }
        public int? ServicerMasterID { get; set; }

        public string CreatedBy { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public Nullable<System.DateTime> UpdatedDate { get; set; }
        public string Status_ValueUsedInCalc { get; set; }
        public decimal? Final_ValueUsedInCalc { get; set; }
        public decimal? Adjustment { get; set; }
        public decimal? ActualDelta { get; set; }      
        public DateTime? RemittanceDate { get; set; }
        public int? Calculated { get; set; }
        public int? AllowCalculationOverride { get; set; }
        public decimal? TransactionEntryAmount { get; set; }
        public decimal? InterestAdj { get; set; }
        public decimal? AddlInterest { get; set; }
        public decimal? TotalInterest { get; set; }
        public int? row_num { get; set; }
        public decimal? WriteOffAmount { get; set; }

    }
}
