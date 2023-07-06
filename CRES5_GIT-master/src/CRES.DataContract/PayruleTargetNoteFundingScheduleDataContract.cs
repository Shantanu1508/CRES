using System;

namespace CRES.DataContract
{
    public class PayruleTargetNoteFundingScheduleDataContract
    {
        public Guid? NoteID { get; set; }
        public DateTime? Date { get; set; }
        public Decimal? Value { get; set; }
        public String NoteName { get; set; }
        public string AccountId { get; set; }
        public int? PurposeID { get; set; }
        public String Purpose { get; set; }
        public Boolean? Applied { get; set; }
        public string DrawFundingId { get; set; }
        public int? DealFundingRowno { get; set; }
        public string Comments { get; set; }
        public int? isDeleted { get; set; }
        public decimal? NoteSplitDiff { get; set; }
        public Guid? DealFundingID { get; set; }
        public string WF_CurrentStatus { get; set; }
        public string WF_CurrentStatusDisplayName { get; set; }
        public string OldComment { get; set; }
        public Boolean isDeletedAutoSpread { get; set; }
        public int? OrgDealFundingRowno { get; set; }
        public string GeneratedByText { get; set; }
        public int? GeneratedBy { get; set; }
        public int? TempDealFundingRowno { get; set; }
    }
}