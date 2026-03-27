using System;

namespace CRES.DataContract
{
    public class StrippingScheduleDataContract
    {
        ////Following fields are not sync with DB... Please recreate once DB finalized
        //public int? NoteID { get; set; }

        //public int StrippingScheduleID { get; set; }
        //public int EventID { get; set; }

        //public DateTime? EffectiveDate { get; set; }
        //public decimal? Value { get; set; }
        //public int? ValueTypeID { get; set; }
        //public string ValueTypeText { get; set; }
        //public DateTime? StartDate { get; set; }
        //public Decimal? IncludedLevelYield { get; set; }
        //public Decimal? IncludedBasis { get; set; }
        //public string CreatedBy { get; set; }
        //public DateTime? CreatedDate { get; set; }
        //public string UpdatedBy { get; set; }
        //public DateTime? UpdatedDate { get; set; }
        ////End
        
        public Guid? NoteID { get; set; }

        public Guid? AccountID { get; set; }
        public int? ModuleId { get; set; }
        public DateTime? Event_Date { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public DateTime? EffectiveEndDate { get; set; }
        public int? EventTypeID { get; set; }
        public string EventTypeText { get; set; }
     //   public Guid? StrippingScheduleID { get; set; }
        public Guid? EventId { get; set; }
        public DateTime? StartDate { get; set; }
        public decimal? Value { get; set; }
        public int? ValueTypeID { get; set; }
        public string ValueTypeText { get; set; }
        public decimal? IncludedLevelYield { get; set; }
        public decimal? IncludedBasis { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string ScheduleID { get; set; }
    }
}