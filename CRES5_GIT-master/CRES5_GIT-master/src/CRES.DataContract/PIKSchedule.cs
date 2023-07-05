using System;

namespace CRES.DataContract
{
    public class PIKSchedule
    {

        public PIKSchedule()
        {
        }
        public Guid? NoteID { get; set; }
        public Guid? TargateNoteID { get; set; }

        public Guid? AccountID { get; set; }
        public DateTime? Event_Date { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public int? EventTypeID { get; set; }
        public string EventTypeText { get; set; }
        public Guid? PIKScheduleID { get; set; }
        public Guid? EventId { get; set; }
        public Guid? SourceAccountID { get; set; }
        public string SourceAccount { get; set; }
        public Guid? TargetAccountID { get; set; }
        public string TargetAccount { get; set; }
        public decimal? AdditionalIntRate { get; set; }
        public decimal? AdditionalSpread { get; set; }
        public decimal? IndexFloor { get; set; }
        public decimal? IntCompoundingRate { get; set; }
        public decimal? IntCompoundingSpread { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public decimal? IntCapAmt { get; set; }
        public decimal? PurBal { get; set; }
        public decimal? AccCapBal { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

        public int? ModuleId { get; set; }
        public string ScheduleID { get; set; }
        public string SourceCRENoteId { get; set; }
        public string TargetCRENoteId { get; set; }
        public int? PIKReasonCodeID { get; set; }
        public string PIKComments { get; set; }
        public string PIKReasonCodeIDtext { get; set; }

        public int? PIKIntCalcMethodID { get; set; }
        public string PIKIntCalcMethodIDText { get; set; }

    }


}
