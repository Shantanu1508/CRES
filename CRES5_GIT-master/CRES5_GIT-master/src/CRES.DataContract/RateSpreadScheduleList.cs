using System;

namespace CRES.DataContract
{
    public partial class RateSpreadSchedule
    {
        public RateSpreadSchedule()
        {

        }

        public Guid? NoteID { get; set; }
        public int? ModuleId { get; set; }
        public Guid? AccountID { get; set; }
        public DateTime? Event_Date { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public DateTime? EffectiveEndDate { get; set; }
        public Guid? EventId { get; set; }
        public DateTime? Date { get; set; }
        public int? ValueTypeID { get; set; }
        public string ValueTypeText { get; set; }
        public decimal? Value { get; set; }
        public int? IntCalcMethodID { get; set; }
        public string IntCalcMethodText { get; set; }
        public Decimal? RateOrSpreadToBeStripped { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string ScheduleID { get; set; }
        public bool isdeleted { get; set; }

        public int? IndexNameID { get; set; }
        public string IndexNameText { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }

    }
}
