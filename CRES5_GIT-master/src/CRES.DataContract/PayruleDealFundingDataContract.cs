using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class PayruleDealFundingDataContract
    {
        public Guid? DealFundingID { get; set; }
        public Guid? DealID { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public DateTime? Date { get; set; }
        public Decimal? Value { get; set; }
        public string Comment { get; set; }
        public int? PurposeID { get; set; }
        public string PurposeText { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public Boolean? Applied { get; set; }
        public Boolean? IsChanged { get; set; }
        public string DrawFundingId { get; set; }
        public int? DealFundingRowno { get; set; }
        public DateTime? orgDate { get; set; }
        public Decimal? orgValue { get; set; }
        public int? orgPurposeID { get; set; }
        public string OrgPurposeText { get; set; }
        public Boolean? OrgApplied { get; set; }
        public Decimal? AccumulatedDealFund { get; set; }
        public Boolean? Issaved { get; set; }
        public Decimal? Value1 { get; set; }
        public Decimal? orgValue1 { get; set; }
        public Decimal? EquityAmount { get; set; }
        public Decimal? RemainingFFCommitment { get; set; }
        public Decimal? RemainingEquityCommitment { get; set; }
        public string SubPurposeType { get; set; }
        public string WF_CurrentStatus { get; set; }
        public string WF_CurrentStatusDisplayName { get; set; }
        public bool? WF_IsCompleted { get; set; }
        public bool? WF_IsFlowStart { get; set; }
        public bool? WF_IsAllow { get; set; }
        public bool? WF_isParticipate { get; set; }
        public bool? wf_isUserCurrentFlow { get; set; }
        public bool? isdeleted { get; set; }
        public string OldComment { get; set; }
        public string CREDealID { get; set; }
        public bool? IsRowEdited { get; set; }
        public Decimal? RequiredEquity { get; set; }
        public Decimal? AdditionalEquity { get; set; }
        public string DrawFeeStatus { get; set; }
        public string DrawFeeStatusName { get; set; }
        public string DrawFeeFile { get; set; }
        public bool? IsShowDrawStatus { get; set; }
        public int? OrgDealFundingRowno { get; set; }
        public string GeneratedByText { get; set; }
        public int? GeneratedBy { get; set; }
        public int? TempDealFundingRowno { get; set; }

       public Boolean? NonCommitmentAdj { get; set; }

        public int? AdjustmentType { get; set; }

        public string GeneratedByUserID { get; set; }
    }
}
