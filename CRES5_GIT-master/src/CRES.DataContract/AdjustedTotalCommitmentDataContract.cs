using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class AdjustedTotalCommitmentDataContract
    {
        public Guid? DealID { get; set; }
        public Guid? UserID { get; set; }
        public Guid? NoteID { get; set; }
        public int? NoteAdjustedCommitmentMasterID { get; set; }
        public string CRENoteID { get; set; }
        public DateTime? Date { get; set; }
        public int? Type { get; set; }
        public int? Rownumber { get; set; }
        public decimal? DealAdjustmentHistory { get; set; }
        public decimal? AdjustedCommitment { get; set; }
        public decimal? TotalCommitment { get; set; }
        public decimal? AggregatedCommitment { get; set; }
        public string Comments { get; set; }
        public decimal? Amount { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string TypeText { get; set; }
        public decimal? NoteAdjustedTotalCommitment { get; set; }
     //   public decimal? NoteAggregatedTotalCommitment { get; set; }
        public decimal? NoteTotalCommitment { get; set; }
        public decimal? TotalRequiredEquity {get;set;}
        public decimal? TotalAdditionalEquity {get;set;}

       // public Boolean? ExcludeFromCommitmentCalculation { get; set; }

        public string CommitmentType { get; set; }
        public decimal? TotalEquityatClosing { get; set; }


    }
}
