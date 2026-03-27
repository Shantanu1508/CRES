using System;

namespace CRES.DataContract
{
    public class FutureFundingScheduleTab
    {       
        public Guid? NoteID { get; set; }
        public string CRENotedID { get; set; }
        public Guid? AccountID { get; set; }      
        public DateTime? Date { get; set; }
        public decimal? Value { get; set; }
        public DateTime? Event_Date { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public DateTime? EffectiveEndDate { get; set; }
        public int? EventTypeID { get; set; }
        public string EventTypeText { get; set; }
        public Guid? EventId { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? ModuleId { get; set; }
        public string ScheduleID { get; set; }
        public int? PurposeID { get; set; }
        public string PurposeText { get; set; }
        public Boolean? Applied { get; set; }
        public Boolean? Issaved { get; set; }
        public string DrawFundingId { get; set; }
        public string Comments { get; set; }

        public DateTime? orgDate { get; set; }
        public Decimal? orgValue { get; set; }
        public int? orgPurposeID { get; set; }
        public string OrgPurposeText { get; set; }
        public Boolean? OrgApplied { get; set; }

        public Boolean? NonCommitmentAdj { get; set; }
        public string NonCommitmentAdjText { get; set; }
        public string noncommitmentadj { get; set; }

        public int? AdjustmentType { get; set; }
        public string AdjustmentTypeText { get; set; }

        public string adjustmenttype { get; set; }
    }



}
