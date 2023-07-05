using System;

namespace CRES.DataContract
{
    public class ServicingOneTimeFeesTableDataContract
    {
        public Guid? NoteID { get; set; }
        public Guid? AccountID { get; set; }
        public DateTime? Event_Date { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public DateTime? EffectiveEndDate { get; set; }
        public int? EventTypeID { get; set; }
        public string EventTypeText { get; set; }

        public Guid? EventId { get; set; }
        public DateTime? Date { get; set; }
        public int? IsCapitalized { get; set; }
        public string IsCapitalizedText { get; set; }
        public decimal? Value { get; set; }

        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string ScheduleID { get; set; }
        public int? ModuleId { get; set; }

    }
}
