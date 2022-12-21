using System;

namespace CRES.DataContract
{
    public partial class NotePrepayAndAdditionalFeeSchedule
    {
        public NotePrepayAndAdditionalFeeSchedule()
        {

        }

        public Guid? EventId { get; set; }
        public Guid? PrepayAndAdditionalFeeScheduleID { get; set; }

        public int NoteID { get; set; }
        public int? ModuleId { get; set; }
        public int NotePrepayAndAdditionalFeeScheduleID { get; set; }
        public DateTime? EffectiveDateForPrepayAndAdditionalFeesSchedule { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public int? NotePrepayAndAdditionalValueType { get; set; }
        public int? ValueTypeID { get; set; }
        public string PrepayValueTypeText { get; set; }
        public string ValueTypeText { get; set; }
        public Decimal? NotePrepayAndAdditionalValue { get; set; }
        public Decimal? Value { get; set; }
        public DateTime? ScheduleStartDate { get; set; }
        public Decimal? PPIncludeInLevelYieldCalc { get; set; }
        public Decimal? PPIncludeInBasisCalc { get; set; }

        public string CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedDate { get; set; }
        public string ScheduleID { get; set; }
        public DateTime? StartDate { get; set; }

    }
}
