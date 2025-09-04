using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class LiabilityFundingScheduleDataContract
    {
        public int? LiabilityFundingScheduleID { get; set; }
        public string LiabilityNoteAccountID { get; set; }
        public string LiabilityNoteID { get; set; }
        public string LiabilityNoteName { get; set; }
        public DateTime? TransactionDate { get; set; }
        public decimal? TransactionAmount { get; set; }
        public int? WorkflowStatus { get; set; }
        public string WorkflowStatusText { get; set; }
        public int? GeneratedBy { get; set; }
        public string GeneratedByText { get; set; }
        public string GeneratedByUserID { get; set; }
        public bool Applied { get; set; }
        public string Comments { get; set; }
        public string AssetAccountID { get; set; }
        public string AssetName { get; set; }
        public string AssetID { get; set; }
        public DateTime? AssetTransactionDate { get; set; }
        public decimal? AssetTransactionAmount { get; set; }
        public Decimal? TransactionAdvanceRate { get; set; }
        public Decimal? CumulativeAdvanceRate { get; set; }
        public string AssetTransactionComment { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? RowNo { get; set; }
        public string TransactionTypes { get; set; }
        public string AccountID { get; set; }
        public Decimal? EndingBalance { get; set; } 
        public string CRENoteID { get; set; }
        public string DealName { get; set; }
        public string CREDealID { get; set; }
        public int? CalcType { get; set; }
        public string DealAccountID { get; set; }
        public int? LiabilityFundingScheduleDealID { get; set; }
        public decimal? OriginalTotalCommitment { get; set; }
        public Decimal? Ratio { get; set; }
        public Boolean? IsDeleted { get; set; }
        public int? StatusID { get; set; }
        public string StatusName { get; set; }
    }
}
